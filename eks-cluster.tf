#eks-cluster -> EKS클러스터를 생성하고 구성한다.
resource "aws_eks_cluster" "eks_cluster" {
    name = "my-cluster"
    role_arn = aws_iam_role.eks_cluster.arn #클러스터에 사용할 IAM역할의 Amazone Resource Name(ARN)을 지정

    vpc_config { #클러스터가 사용할 VPC설정을 정의함
      subnet_ids = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id] #클러스터가 사용할 VPC내의 서브넷ID를 배열로 저장

      endpoint_private_access = true #private API 엔드포인트에 대한 접근 허용
      endpoint_public_access = false #public API 엔드포인트에 대한 접근 비활성화
    }

    depends_on = [ #클러스터가 정상적으로 생성되기전에 필요한 IAM 정책
        aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy,

     ]
  
}

#IAM Role과 Policy Attachment를 구성해야 EKS 클러스터가 AWS 리소스에 액세스할 수 있다.
resource "aws_iam_role" "eks_cluster" { #EKS클러스터에서 사용할 IAM역할을 생성
    name = "eks-cluster-role"

    assume_role_policy = jsondecode({ #EKS서비스가 역할을 가정할수 있는 정책을 JSON형식으로 정의
        Version= "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                    Service = "eks.amazonaws.com"
                },
                Action = "sts:AssumeRole",
            }
        ]
    })
  
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" { #IAM 역할에 정책을 첨부
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" #EKS 클러스터를 관리하는데 필요한 권한을 부여
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy" #EKS서비스에 필요한 추가 권한을 부여
  role       = aws_iam_role.eks_cluster.name
}