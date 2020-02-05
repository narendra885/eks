resource "aws_ecr_repository" "myapp" {
  name = "python"
}


output "url" {
  value = "${aws_ecr_repository.myapp.repository_url}"
}
