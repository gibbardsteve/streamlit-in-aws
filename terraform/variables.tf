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

variable "lb_delete_protection" {
  description = "Enable deletion protection for the load balancer"
  type        = bool
  default     = false
}

variable "service_subdomain" {
  description = "Service subdomain"
  type        = string
  default     = "streamlit"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "streamlit"
}

variable "service_cpu" {
  description = "Service CPU"
  type        = string
  default     = "1024"
}

variable "service_memory" {
  description = "Service memory"
  type        = string
  default     = "3072"
}

variable "task_count" {
  description = "Number of instances of the service to run"
  type        = number
  default     = 1
}