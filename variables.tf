variable "agencies" {
  description = "Map of agencies with their SSH public keys"
  type        = map(object({
    ssh_public_key = string
  }))
}
variable "alert_email" {
    description = "Email for getting alerts"
    type =  string
}
