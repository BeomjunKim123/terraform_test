#eks-node-groups -> EKS노드 그룹을 구성한다. 
resource "aws_eks_node_group" "node_group" { #EKS클러스터 내의 노드 그룹을 생성
    cluster_name = aws_eks_cluster.cluster.name #노드 그룹이 속할 EKS 클러스터의 이름을 지정
    node_group_name = "my-cluster-node-group" #노드 그룹의 이름을 설정
    node_role_arn = aws_iam_role.eks_node.arn #노드에 할당할 IAM역할의 ARN
    subnet_ids = [aws_subnet.public_subnet.id, aws_subnet.private_subnet_subnet.id] #노드 그룹이 위치할 서브넷

    scaling_config { #노드 그룹의 크기 조정 설정
      desired_size = 2 #원하는 인스턴스 수
      max_size = 3 #최대 인스턴스 수
      min_size = 1 #최소 인스턴스 수
    }

    depends_on = [ #노드 그룹이 참조하는 EKS 클러스터가 먼저 생성될수 있도록 하는 의존성 명시
        aws_eks_cluster.cluster,
     ]
}

#노드 그룹에 사용할 IAM Role을 설정한다.
resource "aws_iam_role" "eks_node" {
    name = "eks-node-role"

    assume_role_policy = jsonencode({ #이 역할을 가정할수있는 AWS서비스를 정의하는 신뢰 정책
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}
  
resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" { #특정 IAM 역할에 IAM정책을 첨부
  #EKS 워커 노드가 필요로 하는 권한을 제공
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" #첨부할 정책의 ARN이다
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node.name
}
