output "load_balancer_ip" {
  value = aws_lb.lb-external.dns_name
}