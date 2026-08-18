output "cert_arn" {
  value = aws_acm_certificate.api_cert.arn
}

# output "cert_validation_details" {
#   value = {
#     record_name  = one(aws_acm_certificate.api_cert.domain_validation_options).resource_record_name
#     record_value = one(aws_acm_certificate.api_cert.domain_validation_options).resource_record_value
#     record_type  = one(aws_acm_certificate.api_cert.domain_validation_options).resource_record_type
#     domain       = one(aws_acm_certificate.api_cert.domain_validation_options).domain_name
#   }
# }

output "cert_validation_records" {
  value = aws_acm_certificate.api_cert.domain_validation_options
}