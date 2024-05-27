data "http" "workstation-external-ip" {
    url = "공인IP주소"

}

locals {
  workstation-external-ip = "${chomp(data.http.workstation-external-ip.body)}/32"

}

# 클러스터에 접근할 수 있는 외부 IP 주소를 설정합니다. 보통 이것은 특정 IP 주소에서만 클러스터 API 서버에 접근할 수 있도록 보안 그룹 규칙을 구성하는데 사용됩니다.