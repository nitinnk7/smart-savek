module "sqs" {
    source = "../modules/terraform-aws-sqs"
    create_dlq = true
    create_sqs_kms = true
    create_sqs = true
    environment = "dev"
    aws_region = "us-east-1"
    account_id = "618648143483"
    queue_name = "my-app-queue"
    visibility_timeout = 30
    message_retention = 345600
    max_receive_count = 3
    producer_arns = []
    consumer_arns = []
    tags = var.tags
}

