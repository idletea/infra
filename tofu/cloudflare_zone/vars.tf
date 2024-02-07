variable "account_id" {
  type = string
}

variable "fqdn" {
  type = string
}

variable "tuta_verification" {
  type = string
  default = ""
}

variable "records" {
  type = list(
    object({
      name     = string,
      value    = string,
      type     = string,
      proxied  = optional(bool, false),
      priority = optional(number, null),
      # if 2+ records with known-after-reply values share a
      # type and name we need something else to discriminate them,
      # so optionally records can include an arbitrary salt value
      salt     = optional(string, ""),
    })
  )
}
