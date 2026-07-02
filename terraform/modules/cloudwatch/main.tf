resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.log_retention_in_days
  tags              = { Name = "/aws/eks/${var.cluster_name}/cluster" }
}
