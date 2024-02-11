import os
import time
import tomllib
from typing import Self
from dataclasses import dataclass

import jwt
from flask import Flask, abort, request

KEYS_TTL_MINUTES = 48 * 60
TEAM_DOMAIN = os.environ["TEAM_DOMAIN"]
AUDIENCE_TAGS = tomllib.loads(os.environ["AUDIENCE_TAGS"])


@dataclass
class CfValidate:
    _keys: jwt.PyJWKClient
    _keys_ttl: float | float
    _keys_time: float

    @classmethod
    def init(cls, *, keys_ttl_mins: float | int) -> Self:
        return cls(
            _keys=cls.acquire(),
            _keys_ttl=keys_ttl_mins * 60,
            _keys_time=time.monotonic(),
        )

    @classmethod
    def acquire(cls) -> jwt.PyJWKClient:
        endpoint = f"https://{TEAM_DOMAIN}/cdn-cgi/access/certs"
        return jwt.PyJWKClient(endpoint)

    def __call__(self, token: str, aud: str) -> bool:
        if self._need_refresh():
            self._keys = self.__class__.acquire()
            self._keys_time = time.monotonic()
        assert self._keys
        return self._validate(token, aud)

    def _need_refresh(self) -> bool:
        delta = time.monotonic() - self._keys_time
        return delta > self._keys_ttl

    def _validate(self, token: str, aud: str) -> bool:
        signing_key = self._keys.get_signing_key_from_jwt(token)
        try:
            jwt.decode(
                token,
                signing_key.key,
                ["RS256"],
                options={"require": ["exp", "iat", "email"]},
                audience=aud,
                issuer=f"https://{TEAM_DOMAIN}",
            )
            return True
        except Exception as _:
            return False


app = Flask(__name__)
validate = CfValidate.init(keys_ttl_mins=KEYS_TTL_MINUTES)


@app.route("/")
def validate_request():
    token = request.cookies.get("CF_Authorization")
    host = request.headers.get("Edge-Host")

    if token is None:
        abort(401, "missing required CF_Authorization cookie")

    expected_aud = AUDIENCE_TAGS.get(host)
    if expected_aud is None:
        abort(400, f"auth-proxy not configured for host {host}")

    if validate(token, expected_aud):
        return "authorized"
    else:
        abort(403, "invalid authorization")


if __name__ == "__main__":
    pp.run(port=8000)
