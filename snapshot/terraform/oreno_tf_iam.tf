#
# Create IAM Instance Profile
#
resource "aws_iam_instance_profile" "oreno_es_profile" {
    name = "oreno_es_profile"
    roles = ["${aws_iam_role.oreno_es_role.name}"]
}

#
# Create IAM Role
#
resource "aws_iam_role" "oreno_es_role" {
    name = "oreno_es_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#
# Create IAM Role Policy
#
resource "aws_iam_role_policy" "oreno_es_policy" {
    name = "oreno_es_policy"
    role = "${aws_iam_role.oreno_es_role.id}"
    policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Action":[
                "s3:ListBucket"
            ],
            "Effect":"Allow",
            "Resource":[
                "arn:aws:s3:::${var.s3_bucket_name}"
            ]
        },
        {
            "Action":[
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "iam:PassRole"
            ],
            "Effect":"Allow",
            "Resource":[
                "arn:aws:s3:::${var.s3_bucket_name}/*"
            ]
        }
    ]
}
EOF
}
