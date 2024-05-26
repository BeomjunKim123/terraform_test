#vpc -> vpc와 서브넷, 라우트 테이블, 인터넷 게이트웨이 등을 설정한다.

#create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" #VPC에 할당할 IP대역을 설정한다. 

  tags = {
    Name = "main-vpc"
  }
}

#create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24" #서브넷에 할당할 IP대역을 설정한다. 

  map_public_ip_on_launch = true #인스턴스에 공용IP주소를 자동으로 할당한다.

  tags = {
    Name = "public-subnet"
  }
  
}

#create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24" #또 다른 서브넷에 할당항 IP대역이다.

  tags = {
    Name = "private-subnet"
  }
  
}

#create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
  
}

#create roue table 및 인터넷 게이트웨이 연결
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
  
}

resource "aws_route_table_association" "public" { #퍼블릭 서브넷과 라우트 테이블 연결
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}