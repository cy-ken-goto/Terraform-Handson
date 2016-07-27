resource "aws_iam_user" "tf_handson_user" {
    name = "tf_handson_user"
}

resource "aws_iam_access_key" "tf_handson_user_ak" {
    user = "${aws_iam_user.tf_handson_user.name}"
}

resource "aws_iam_user_policy" "tf_handson_user_ro" {
    name = "tf_handson_user_ro"
    user = "${aws_iam_user.tf_handson_user.name}"
    policy = "${file("aws_iam_group_policies/tf_handson.json")}"
}

output "iam user access_key" {
  value = "${aws_iam_access_key.tf_handson_user_ak.id}"
}
output "iam user secret" {
  value = "${aws_iam_access_key.tf_handson_user_ak.secret}"
}