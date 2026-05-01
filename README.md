# terraform-aws-vpc
 
I built this to learn Terraform properly by recreating what I had previously done manually in the AWS console. My goal was to understand how everything connects under the hood, not just click through the UI.
 
The app running on it is a Spring Boot API that talks to FastAPI and PostgreSQL (which runs in an RDS). Nothing special on the app side, that's not the point here.
 
---
 
## Structure
 
```
.
├── applications
│ ├── fastapi
│ │ └── main.py
│ ├── spring-boot
│ │ └── spring-boot-api.jar
│ ├── start_fastapi.sh
│ └── start_springboot.sh
├── envs
│ ├── dev # run terraform from here
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ ├── providers.tf
│ │ ├── terraform.tfvars
│ │ └── variables.tf
│ └── prod
├── modules
│ ├── alb # load balancer
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ ├── ec2 # app instances + bastion
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ ├── iam # s3 read-only role for ec2
│ │ ├── main.tf
│ │ └── outputs.tf
│ ├── rds # postgres
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ ├── s3 # private bucket for app artifacts
│ │ ├── main.tf
│ │ ├── outputs.tf
│ │ └── variables.tf
│ └── vpc # subnets, IGW, NAT, route tables, security groups
│ ├── main.tf
│ ├── outputs.tf
│ └── variables.tf
├── services
│ ├── fastapi
│ │ └── main.py
│ └── spring-boot
│   ├── src
│   ├── pom.xml
│   ├── docker-compose.yaml
│   └── target # build output (jar)
├── state-files # state files (ignored via .gitignore)
│ ├── terraform.tfstate
│ └── terraform.tfstate.backup
└── README.md
```
 
`envs/dev/main.tf` calls all of the modules and wires their outputs into each other.
 
---
 
## Architecture
 
```
                         Internet
                            |
                     +------+------+
                     |     ALB     |  port 80
                     +------+------+
                            |
              +-------------+-------------+
              |       VPC 10.0.0.0/16     |
              |                           |
              |  Public Subnets           |
              |  +---------+ +---------+  |
              |  |public-1a| |public-1b|  |
              |  | Bastion | |  (ALB)  |  |
              |  | NAT GW  | | NAT GW  |  |
              |  +----+----+ +---------+  |
              |       | SSH               |
              |  Private Subnets          |
              |  +---------+ +---------+  |
              |  |priv-1a  | |priv-1b  |  |
              |  |EC2 + RDS| |  EC2    |  |
              |  +---------+ +---------+  |
              +---------------------------+
                            |
                     S3 (private)
```
 
Traffic comes in through the ALB on port 80, gets forwarded to the Spring Boot instances on 8080. Spring Boot calls FastAPI internally on 8000, and talks to RDS on 5432. Instances pull their application files from S3 using an IAM role so no credentials are needed anywhere.
 
SSH access to private instances goes only through the bastion host, which is locked to a specific IP (MY IP).
 
---
 
## Security groups
 
| SG | Inbound | Outbound |
|---|---|---|
| ALB | 0.0.0.0/0 on port 80 | springboot-sg on 8080 |
| Bastion | My IP on port 22 | all |
| Spring Boot | alb-sg on 8080, bastion-sg on 22 | all |
| FastAPI | springboot-sg on 8000, bastion-sg on 22 | all |
| RDS | springboot-sg on 5432, bastion-sg on 5432 | all |
 
---
 
## App endpoints
 
| Endpoint | What it does |
|---|---|
| `GET /system/ping` | returns pong, used as ALB health check |
| `GET /system/springboot` | returns status active |
| `GET /system/fastapi` | spring boot calls fastapi and returns the response |
| `GET /system/admin-name` | queries rds and returns the admin username |
 
---
 
## Usage
 
```bash
cd envs/dev
terraform init
terraform plan
terraform apply
```
 
```bash
# once everything is done
terraform destroy
```
 
---
 