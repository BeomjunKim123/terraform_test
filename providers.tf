#providers -> 테라폼 프로바이더 설정을 포함한다.

provider "aws" {
    region = "ap-northeast-2"
  
}

provider "http" {
  
}

#프로바이더는 서비스 제공자라고 할수있다. 
#여기서는 AWS를 주로 설정하며, 필요한 API 접근 권한과 같은 인증 정보와 리전 설정을 포함합니다.