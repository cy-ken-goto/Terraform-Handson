resource "aws_s3_bucket" "elb_log" {
    bucket = "${var.app_name}-elb-log"
    acl = "private"

    # lifecycle_rule {
    #     id = "log"
    #     prefix = "log/"
    #     enabled = true

    #     transition {
    #         days = 30
    #         storage_class = "STANDARD_IA"
    #     }
    #     transition {
    #         days = 60
    #         storage_class = "GLACIER"
    #     }
    #     expiration {
    #         days = 90
    #     }
    # }
    # lifecycle_rule {
    #     id = "log"
    #     prefix = "tmp/"
    #     enabled = true

    #     expiration {
    #         date = "2016-01-12"
    #     }
    # }

    tags {
        Name = "${var.app_name}-elb-log"
    }
}