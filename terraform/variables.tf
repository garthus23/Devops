variable "vmnumber" {
  type    = number
  default = 2
}

variable "netrange" {
  type   = list(object({
    subnet = string
    ip     = string
  }))
  default = [
    {
      subnet = "192.168.10.0/24"
      ip     = "192.168.10.1"
    }]
}
