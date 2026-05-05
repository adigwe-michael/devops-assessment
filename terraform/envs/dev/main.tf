provider "aws" {
  region = "us-east-1"
}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  name = "devops-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}

# ECR Module
module "ecr" {
  source = "../../modules/ecr"

  repository_name = "devops-assessment-app"
}

# EKS Module (👉 YOUR CODE GOES HERE)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = "devops-eks"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      instance_types = ["t3.medium"]
    }
  }
}