resource "aws_launch_configuration" "main" {
  name_prefix     = "${var.area_code}-"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.private.id]
  user_data       = file("install_apache.sh")
  key_name        = "main11"
}

resource "aws_autoscaling_group" "main" {
  name             = var.area_code
  desired_capacity = 2
  max_size         = 4
  min_size         = 2

  target_group_arns    = [aws_lb_target_group.main.arn]
  launch_configuration = aws_launch_configuration.main.name
  vpc_zone_identifier  = data.terraform_remote_state.level1.outputs.private_subnet_id

  tag{
      key = "Name"
      value = var.area_code
      propagate_at_launch = true
  }
}
