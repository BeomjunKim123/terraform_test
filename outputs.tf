#outputs -> 테라폼 출력 변수를 정의한다.
output "vpc_id" { #생성된 VPC의 ID출력
  description = "The ID of the VPC" #출력 변수에 대한 설명 제공
  value       = aws_vpc.main.id #실제 출력할 값으로, 여기서는 aws_vpc.main.id로 설정되어 VPC 리소스의 ID를 반환
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnet.*.id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnet.*.id
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_identity_oidc_issuer" {
  description = "The OIDC issuer URL for the EKS cluster"
  value       = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.my_alb.dns_name
}
