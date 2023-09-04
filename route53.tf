resource "aws_route53_zone" "ar-smarty" {
  name = var.domain_name 
}

resource "aws_route53_record" "ar-smarty-to-lb" {
  zone_id = aws_route53_zone.ar-smarty.zone_id
  name    = var.domain_name  
  type    = "A" # OR "AAAA"

  alias {
      name                   = aws_lb.lb-external.dns_name
      zone_id                = aws_lb.lb-external.zone_id
      evaluate_target_health = true
  }
}

resource "aws_route53_record" "ar-smarty-validation" {
  #allow_overwrite = true
  name =  tolist(aws_acm_certificate.ar-smarty.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.ar-smarty.domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.ar-smarty.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.ar-smarty.zone_id
  ttl = 60
}


