variable "disk" {
  default     = "15G"
  type        = string
  description = "Disk size assigned to vms"
}
variable "mem" {
  default     = "3G"
  type        = string
  description = "Memory assigned to vms"
}
variable "cpu" {
  default     = 3
  type        = number
  description = "Number of CPU assigned to vms"
}
variable "disk_haproxy" {
  default     = "10G"
  type        = string
  description = "Disk size assigned to vms"
}
variable "mem_haproxy" {
  default     = "2G"
  type        = string
  description = "Memory assigned to vms"
}
variable "cpu_haproxy" {
  default     = 2
  type        = number
  description = "Number of CPU assigned to vms"
}
variable "disk_worker" {
  default     = "30G"
  type        = string
  description = "Disk size assigned to vms"
}
variable "mem_worker" {
  default     = "3G"
  type        = string
  description = "Memory assigned to vms"
}
variable "cpu_worker" {
  default     = 3
  type        = number
  description = "Number of CPU assigned to vms"
}
variable "masters" {
  default     = 1
  type        = number
  description = "Number of control plane nodes"
}
variable "workers" {
  default     = 1
  type        = number
  description = "Number of worker nodes"
}
variable "kube_version" {
  default     = "1.30.2-1.1"
  type        = string
  description = "Version of Kubernetes to use"
}
