from __future__ import annotations

from pathlib import Path
from pyinfra.operations import apt, files, server

IAC_DIR = Path(__file__).parent.resolve()


def debian_upkeep():
    files.file("/etc/motd", present=False)
    apt.update()
    apt.dist_upgrade()


def k3s_setup():
    files.put(
        str(IAC_DIR / "files" / "k3s-config.yaml"),
        "/etc/rancher/k3s/config.yaml",
    )
    server.shell(["curl -sfL https://get.k3s.io | sh -"])
    files.get(
        "/etc/rancher/k3s/k3s.yaml",
        str(IAC_DIR.parent / ".kube-config")
    )


debian_upkeep()
k3s_setup()
