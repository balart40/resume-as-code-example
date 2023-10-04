resource "aws_iam_role" "tf-codepipeline-role" {
  name = "tf-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "tf-cicd-pipeline-policies" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["codestar-connections:Useconnection"]
    resources = ["*",]
  }
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["cloudwatch:*", "s3:*", "codebuild:*"]
    resources = ["*",]
  }
}

resource "aws_iam_policy" "tf-cicd-pipeline-policy" {
  name = "tf-cicd-pipeline-policy"
  path ="/"
  description = "Pipeline policy"
  policy   = data.aws_iam_policy_document.tf-cicd-pipeline-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-policy-attachment" {
  policy_arn = aws_iam_policy.tf-cicd-pipeline-policy.arn
  role   = aws_iam_role.tf-codepipeline-role.id
}

resource "aws_iam_role" "tf-codebuild-role" {
  name = "tf-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "tf-cicd-build-policies" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["logs:*", "s3:*", "codebuild:*", "codebuild:*", "secretsmanger:*", "iam:*"]
    resources = ["*",]
  }
}

resource "aws_iam_policy" "tf-cicd-build-policy" {
  name = "tf-cicd-build-policy"
  path ="/"
  description = "Codebuild policy"
  policy   = data.aws_iam_policy_document.tf-cicd-build-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-policy-attachment1" {
  policy_arn = aws_iam_policy.tf-cicd-build-policy.arn
  role   = aws_iam_role.tf-codebuild-role.id
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-policy-attachment2" {
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  role   = aws_iam_role.tf-codebuild-role.id
}