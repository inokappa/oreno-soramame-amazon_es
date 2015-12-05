output "IAM Role" {
    value = "${aws_iam_role.oreno_es_role.arn}"
}

output "S3 bucket" {
    value = "${aws_s3_bucket.oreno_bucket.id}"
}
