
### How to bootstrap Course Jenkins:
- Load file ./default-vpc.yml to s3
- Change jenkins-for-ecs.yml VPCStack::Properties::TemplateURL to uploaded default-vpc yaml file URL
- Create SSL certificate https://aws.amazon.com/blogs/security/easier-certificate-validation-using-dns-with-aws-certificate-manager/
- Create stack with jenkins-for-ecs.yml template
- Adjust security group to access jenkins (add your IP to whitelist)

Description to default-vpc.yml template
- **VPC** – a new network in the AWS cloud, where we’ll be deploying all resources. Note that for us to attach an EFS volume to a Fargate container in this VPC, it must have DNS hostnames enabled.
- **public subnets x 2** (in different availability zones) – here we’ll deploy our ALB, so it’s accessible to the internet
- **private subnets x 2** (in different availability zones) – here we’ll deploy our Jenkins service, so it’s not directly accessible to the internet
- **an internet gateway** – attached to the public subnets, this is the network’s route to the internet
- **NAT gateway x 2** – these allow traffic from any services deployed in the private subnets to reach the internet via the internet gateway
- **route tables, elastic IP, etc.** – see the CloudFormation template for full details of miscellaneous resources


### Jenkins setup

- Create Jenkins User with policy
Policy:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": [
            "ec2:*",
            "autoscaling:*",
            "iam:ListInstanceProfiles",
            "iam:ListRoles",
            "iam:PassRole"
        ],
        "Resource": "*",
        "Effect": "Allow"
        }
    ]
}
```

- Add Access and Secret Keys to Jenkins

https://www.jenkins.io/doc/book/installing/docker/

docker stop jenkins-docker

docker run --name jenkins-docker \
--detach --privileged --network jenkins \
--network-alias docker \
--volume jenkins-docker-certs:/certs/client \
--volume jenkins-data:/var/jenkins_home \
--publish 8080:8080 --publish 50000:50000 \
jenkins/jenkins \
&& docker logs -f jenkins-docker
