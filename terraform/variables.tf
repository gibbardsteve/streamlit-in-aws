variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "container_image" {
  description = "Container image"
  type        = string
  default     = "streamlit-demo"
}

variable "container_tag" {
  description = "Container tag"
  type        = string
  default     = "latest"

}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 8501
}

variable "from_port" {
  description = "From port"
  type        = number
  default     = 8501
}

variable "destroy_hosted_zone" {
  description = "Optionally destroy the Route53 hosted zone"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "in-steps.co.uk"
}

variable "log_retention_days" {
  description = "Log retention days"
  type        = number
  default     = 90
}