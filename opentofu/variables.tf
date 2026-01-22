variable "virtual_environment_api_token" {
  type        = string
  description = "The API token of the PVE cluster."
}

variable "virtual_environment_endpoint" {
  type        = string
  description = "The endpoint of the PVE cluster."
}

variable "node_name" {
  type        = string
  description = "The PVE to run srv-01 on."
}

variable "printer_usb_id" {
  type        = string
  description = "The id of the printer used for USB mapping."
}
