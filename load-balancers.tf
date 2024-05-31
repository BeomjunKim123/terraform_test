#load-balancers -> ALB 또는 기타 로드 밸런서 설정을 정의
resource "aws_lb" "my_alb" { #ALB를 생성
    name = "my-alb" #로드밸런서 이름
    internal = false #로드밸런서가 내부적으로만 사용되는지 여부를 설정 / false로 외부에서 접근 가능함을 의미
    load_balancer_type = "application" #로드 밸런서의 유형을 "application"으로 설정. 이는 HTTP/HTTPS 트래픽을 관리하는데 사용
    subnets = [ aws_subnet.public_subnet.id ] #실제 사용할 퍼블릭 서브넷의 ID를 넣기

    security_groups = [ aws_security_group.allow_web.id ] #실제 사용할 보안 그룹의 ID를 넣기

    enable_deletion_protection = false #로드밸런서 실수로 삭제하는 것을 방지하기 위한 설정

    tags = { #리소스 추가적인 정보를 제공하는 태그 설정
      Name = "my-application-load-balancer"
    }
  
}

#ALB에 연결할 타겟 그룹을 생성
resource "aws_lb_target_group" "my_alb_tg" {
    name = "my-alb-target-group" #타겟 그룹의 이름 설정
    port = 80 #타겟 그룹의 트래픽을 수신할 포트 지정
    protocol = "HTTP" #타겟 그룹과 통신할 프로토콜 지정
    vpc_id = aws_vpc.main.id #타겟 그룹이 위치할 VPC의 ID를 지정

    health_check { #타겟 그룹의 인스턴스들이 건강한지 확인하기 위한 설정을 제공
      healthy_threshold = 2 
      unhealthy_threshold = 2
      timeout = 3
      path = "/"
      protocol = "HTTP"
      matcher = "200"
    }

    tags = {
      Name = "my-alb-target-group"
    }
  
}

#ALB용 리스너
resource "aws_lb_listener" "my_alb_listener" {
    load_balancer_arn = aws_lb.my_alb.arn #이 리스너가 연결될 ALB의 ARN을 지정
    port = 80 #리스너 트래픽을 수신할 포트 설정
    protocol = "HTTP" #리스너의 프로토콜을 설정

    default_action { #들어오는 요청을 처리하기 위한 기본 동작을 정의 / 요청을 타겟 그룹으로 전달
      type = "forward"
      target_group_arn = aws_lb_target_group.my_alb_tg.arn
    }
  
}

#Network Load Balancer 설정
resource "aws_lb" "my_nlb" { #NLB을 생성한다 / 주로 TCP 트래픽을 처리하는데 최적화된 로드 밸런서
  name = "my-nlb"
  internal = false
  load_balancer_type = "network"
  subnets = [ aws_subnet.public_subnet.id ]

  enable_deletion_protection = false

  tags = {
    Name = "my-network-load-balancer"
  }
}

#NLB용 타겟 그룹
resource "aws_lb_target_group" "my_nlb_tg" {
  name = "my-nlb-target-group"
  port = 80
  protocol = "TCP"
  vpc_id = aws_vpc.main.id
  
  health_check {
    protocol = "TCP"
    healthy_threshold = 3
    unhealthy_threshold = 3
    interval = 30

  }

  tags = {
    Name = "my-nlb-target-group"
  }
}

#NLB용 리스너
resource "aws_lb_listener" "my_nlb_listener" {
  load_balancer_arn = aws_lb.my_nlb.arn
  port = 80
  protocol = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.my_nlb_tg.arn
  }
}