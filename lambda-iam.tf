resource "aws_iam_role_policy" "lambda_krazzybee_policy" {
  name = "lambda_krazzybee_policy"
  role = "${aws_iam_role.lambda_krazzybee_role.id}"

  policy = "${file("iam/lambda-policy.json")}"
}

resource "aws_iam_role" "lambda_krazzybee_role" {
  name = "lambda_krazzybee_role"

  assume_role_policy = "${file("iam/lambda-assume-policy.json")}"
}
