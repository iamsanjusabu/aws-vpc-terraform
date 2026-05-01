resource "aws_alb_target_group" "alb_target_group" {
    name = "springboot-alb-target-group"
    port = 8080
    protocol = "HTTP"
    
    vpc_id = var.vpc_id

    health_check  {
        path = "/system/ping"
        port = "traffic-port"
        healthy_threshold = 2
        unhealthy_threshold = 5
    }
}

resource "aws_alb_listener" "alb_listener" {
    load_balancer_arn = aws_alb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_alb_target_group.alb_target_group.arn
    }
}

resource "aws_alb_target_group_attachment" "alb_target_group_attachment" {
    count = length(var.springboot_instances_id)
    target_group_arn = aws_alb_target_group.alb_target_group.arn

    target_id = var.springboot_instances_id[count.index]
    port = 8080
}

resource "aws_alb" "alb" {
    name = "alb-springboot"

    internal = false
    load_balancer_type = "application"
    
    security_groups = [ var.alb_sg_id ]
    subnets = var.public_subnet_ids
    ip_address_type = "ipv4"

    # False in dev
    enable_deletion_protection = false
    tags = {
        Name = "alb-springboot"
        env = "dev"
    }
}