output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_tf_cluster.id
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_tf_cluster.arn
}

output "ecs_cluster_capacity_providers_id" {
  value = aws_ecs_cluster_capacity_providers.ecs_tf_cap_prov.id
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.ecs_tf_task_def.arn
}

output "ecs_task_definition_revision" {
  value = aws_ecs_task_definition.ecs_tf_task_def.revision
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "main_vpc_id" {
  value = data.aws_vpc.main.id
}

output "security_group_id" {
  value = aws_security_group.allow_tf_streamlit.id
}
