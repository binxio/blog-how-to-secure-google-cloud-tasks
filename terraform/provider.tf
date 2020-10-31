provider google {
  project = "speeltuin-mvanholsteijn"
  region  = var.region
}

variable region {
  type    = string
  default = "europe-west1"
}

