module "lb" {
  source = "../modules/lb"

  area_code        = var.area_code
  vpc_id           = data.terraform_remote_state.level1.outputs.vpc_id
  public_subnet_id = data.terraform_remote_state.level1.outputs.public_subnet_id
}
