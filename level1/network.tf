module "vpc" {
  source = "../modules/vpc"

  area_code    = var.area_code
  vpc_cidr     = var.vpc_cidr
  private_cidr = var.private_cidr
  public_cidr  = var.public_cidr
}
