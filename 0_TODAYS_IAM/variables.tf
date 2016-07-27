variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "ap-northeast-1"
}
variable "availability_zones" {
    default = {
        "1" = "ap-northeast-1a"
        "2" = "ap-northeast-1c"
    }
}

