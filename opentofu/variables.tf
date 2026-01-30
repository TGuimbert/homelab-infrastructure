variable "virtual_environment_api_token" {
  type        = string
  description = "The API token of the PVE cluster."
}

variable "virtual_environment_endpoint" {
  type        = string
  description = "The endpoint of the PVE cluster."
}

variable "node_1" {
  type        = string
  description = "The name of the first PVE node."
}

variable "node_2" {
  type        = string
  description = "The name of the PVE node to run srv-01 on."
}

variable "srv_01_mac" {
  type        = string
  description = "The MAC address of the srv-01 VM."
}

variable "printer_usb_id" {
  type        = string
  description = "The id of the printer used for USB mapping."
}

variable "home_automation_mac" {
  type        = string
  description = "The MAC address of the home automation VM."
}

variable "home_automation_usb" {
  type        = string
  description = "The USB device ID to be passthrough to the VM."
}
