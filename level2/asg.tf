module "asg" {
  source = "../modules/asg"

  area_code         = var.area_code
  vpc_id            = data.terraform_remote_state.level1.outputs.vpc_id
  private_subnet_id = data.terraform_remote_state.level1.outputs.private_subnet_id
  load_balancer_sg  = module.lb.load_balancer_sg
  target_group_arn  = module.lb.target_group_arn
}
