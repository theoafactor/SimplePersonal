// DEPLOYMENT OF self-hosted runner ----

terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>5.1"
        }
    }
}


module "install_nginx" {
    source = "./modules/install_nginx"
}


