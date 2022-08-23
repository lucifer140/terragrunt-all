locals {
  account_name = "nonprod-accounts"
  profile = "saroj"
  account_id = "507543219710"
  domain_name = {
    name = "cnm-nonprod-account"
    properties = {
      created_outside_terraform = true
    }
  }
}

