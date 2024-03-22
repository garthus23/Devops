variable "vmnumber" {
  type    = number
  default = 2
}

variable "imgsrc" {
  type = string
  default = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img" 
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
