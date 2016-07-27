resource "aws_iam_user" "tf_handson_user" {
    name = "tf_handson_user"
}

resource "aws_iam_access_key" "tf_handson_user_ak" {
    user = "${aws_iam_user.tf_handson_user.name}"
}

resource "aws_iam_group" "tf_handson" {
    name = "tf_handson"
}

resource "aws_iam_group_policy" "tf_handson" {
    name = "tf_handson"
    group = "${aws_iam_group.tf_handson.id}"
    policy = "${file("aws_iam_group_policies/tf_handson.json")}"
}

resource "aws_iam_group_membership" "tf_handson" {
    name = "tf_handson-membership"
    users = [
        "${aws_iam_user.tf_handson_user.name}",
    ]
    group = "tf_handson"
}

output "iam user access_key" {
  value = "${aws_iam_access_key.tf_handson_user_ak.id}"
}
output "iam user secret" {
  value = "${aws_iam_access_key.tf_handson_user_ak.secret}"
}