# NLB and target:
resource "aws_lb" "nlb_ingress" {
  name               = var.nlb_name
  internal           = true
  load_balancer_type = "network"
  subnets            = var.nlb_subnets
  tags               = var.common_tag

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "nlb_ingress" {
  port     = var.k8s_ingress_service_nodeport
  protocol = "TCP"
  vpc_id   = var.vpc_id
  tags     = var.common_tag

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "k8s_workers_asg" {
  count                  = length(var.k8s_workers_asg_names)
  autoscaling_group_name = var.k8s_workers_asg_names[count.index]
  alb_target_group_arn   = aws_lb_target_group.nlb_ingress.arn
}

resource "aws_lb_listener" "nlb_ingress" {
  load_balancer_arn = aws_lb.nlb_ingress.arn
  protocol          = "TCP"
  port              = var.nlb_listener_port

  default_action {
    target_group_arn = aws_lb_target_group.nlb_ingress.arn
    type             = "forward"
  }
}

# VPC Endpoint Service:
resource "aws_vpc_endpoint_service" "k8s_ingress" {
  network_load_balancer_arns = [aws_lb.nlb_ingress.arn]
  acceptance_required        = var.vpces_acceptance_required
  allowed_principals         = var.vpces_allowed_principals
}
