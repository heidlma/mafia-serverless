provider "aws" {
    profile = "${var.aws_profile}"
    region  = "${var.aws_region}"
}

module "apig" {
  source     = "github.com/akranga/terraform-modules//api_gateway"
  name       = "api.${var.name}"
  aws_region = "${var.aws_region}"
}

resource "aws_api_gateway_deployment" "prod" {
  rest_api_id = "${module.apig.id}"
  stage_name  = "prod"

  variables  = {
    hello = "world"
  }
}

resource "aws_api_gateway_api_key" "main" {
  name = "prod"
  description = "API gateway key"

  stage_key {
    rest_api_id = "${module.apig.id}"
    stage_name  = "${aws_api_gateway_deployment.prod.stage_name}"
  }
}

resource "aws_kms_key" "a" {
    description = "KMS key 1"
    deletion_window_in_days = 10
}

# module "lab01_lambda" {
#   # source      = "../../../agilestacks/terraform-modules//lambda"
#   source   = "github.com/akranga/terraform-modules//lambda"
#   name        = "lab01-${var.name}"
#   handler     = "main.handler"
#   zip_file    = "${path.cwd}/game/lambda.zip"
#   policy      = "${file("${path.cwd}/game/policy.json")}"
#   kms_key_arn = "${aws_kms_key.a.arn}"
#   variables = {
#     dynamo_table = "${aws_dynamodb_table.main.name}"
#   }
# }
