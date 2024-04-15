# DNS, Certificate Management and Certificate Validation
# Requires RequestCertificate
data "aws_route53_zone" "route53_domain" {
  name = var.domain_name
}

resource "aws_route53_record" "route53_record" {
  zone_id = data.aws_route53_zone.route53_domain.zone_id
  name    = "${var.service_subdomain}.${var.domain_name}"
  type    = "A"

  depends_on = [aws_alb_listener.app_http]
  alias {
    name                   = aws_lb.test_lb_tf.dns_name
    zone_id                = aws_lb.test_lb_tf.zone_id
    evaluate_target_health = true
  }

}

# Add a wildcard certificate for the domain
resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"

}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for entry in aws_acm_certificate.cert.domain_validation_options : entry.domain_name => {
      name   = entry.resource_record_name
      type   = entry.resource_record_type
      record = entry.resource_record_value
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_domain.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

}