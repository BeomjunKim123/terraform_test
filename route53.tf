#route53 -> Route 53 DNS 설정을 정의한다.
resource "aws_route53_zone" "my_zone" {
    name = "example.com" #도메인 이름을 실제 사용하려는 도메인으로 변경
  
}

resource "aws_route53_record" "my_record" {
    zone_id = aws_route53_zone.my_zone.zone_id
    name = "app.example.com" #실제로 설정하려는 서브 도메인으로 바꾸기
    type = "A"
    ttl = "300"
    records = [ aws_lb.my_alb.dns_name ] #ALB DNS 이름이나 다른 리소스의 IP주소를 사용
  
}