
provider "aws" {
  version = "~> 3.0"
  region = "us-east-1"
}

# Create a vpc
resource "aws_vpc" "terraformvpc" {
  cidr_block = "10.0.0.0/16"

    tags = {
    Name = "Terraform_class"
  }
}

resource "aws_subnet" "public" {
  vpc_id    = aws_vpc.terraformvpc.id
  cidr_block = "10.0.0.0/24"
  
  tags = {
    Name = "terraform_public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.terraformvpc.id
  cidr_block = "10.0.1.0/24"  
  
  tags = {
    Name = "terraform_private"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.terraformvpc.id
  
    tags = {
      Name = "terraform_gw"
  }
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.terraformvpc.id
  
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gateway.id
  }
  
  tags = {
    Name = "terraform_route"
  }
}

resource "aws_route_table_association" "association1" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.route.id
}
	
resource "aws_route_table_association" "association2" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.route.id	
}
