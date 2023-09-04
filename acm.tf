resource "aws_acm_certificate" "ar-smarty" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  #subject_alternative_names = [
  #  "www.${var.domain_name}",
  #  "*.${var.domain_name}"
  #]
}

resource "aws_acm_certificate_validation" "ar-smarty" {
    certificate_arn = aws_acm_certificate.ar-smarty.arn
    validation_record_fqdns = [ "${aws_route53_record.ar-smarty-validation.fqdn}"]
}
