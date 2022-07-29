output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = try(module.rds.cluster_endpoint, "")
}


output "cluster_reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
  value       = try(module.rds.cluster_reader_endpoint, "")
}
