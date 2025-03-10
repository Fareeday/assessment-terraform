Multi-Region AWS Infrastructure Deployment with Terraform

📌 Overview

This project deploys a highly available multi-region AWS infrastructure using Terraform. The setup ensures automatic failover and disaster recovery by leveraging ECS Fargate, ALB, Route 53, S3 Cross-Region Replication, and CloudFront. The infrastructure runs in us-east-1 (Primary) and us-west-2 (Secondary) regions.

🚀 Key Features

ECS Cluster & Services: Runs Nginx containers using AWS Fargate.

ALB (Application Load Balancer): Load balances ECS services in both regions.

Route 53 Failover Routing: Automatically switches traffic between regions.

S3 Cross-Region Replication: Ensures data availability across regions.

IAM Role Management: Separate IAM module to prevent role duplication.

CloudFront: Serves static assets globally with caching.

📂 Infrastructure Modules

This Terraform setup is modularized for flexibility and reusability.

1️⃣ VPC Module (modules/vpc)

Deploys VPCs in both regions.

Configures public and private subnets.

Creates Internet Gateway and NAT Gateway for outbound traffic.

2️⃣ Security Group Module (modules/security_group)

Defines security groups for ECS, ALB, and S3.

Ensures proper network isolation and access controls.

3️⃣ ECS Cluster Module (modules/ecs_cluster)

Creates ECS Fargate Clusters in both regions.

Deploys Nginx container as a service.

Uses IAM ecsTaskExecutionRole for execution permissions.

4️⃣ ECS Service Module (modules/ecs_service)

Deploys ECS services in both regions.

Connects ECS to ALB target groups.

Ensures ECS services failover properly.

5️⃣ ALB Module (modules/alb)

Deploys Application Load Balancer in both regions.

Routes traffic to ECS services.

Includes listeners, security groups, and target groups.

6️⃣ Route 53 Failover (modules/route53_failover)

Configures Failover Routing between ALBs.

Uses Health Checks to detect failures.

Routes traffic to us-west-2 if us-east-1 fails.

7️⃣ S3 Cross-Region Replication (modules/s3_replication)

Creates source and destination S3 buckets.

Enables versioning and replication policies.

Uses IAM roles to allow cross-region replication.

8️⃣ CloudFront (modules/cloudfront)

Serves static assets via CloudFront Distribution.

Uses S3 as the origin.

Improves performance with global edge caching.

9️⃣ IAM Role Module (modules/iam)

Ensures ecsTaskExecutionRole is not duplicated.

Grants required permissions for ECS, S3 replication, and CloudFront.

Preview:
[diagram](https://viewer.diagrams.net/index.html?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=Untitled%20Diagram.drawio.png#R%3Cmxfile%3E%3Cdiagram%20name%3D%22Page-1%22%20id%3D%22aaaa8250-4180-3840-79b5-4cada1eebb92%22%3E7V3bcqs6Ev2aVM08xIUQ4vLoW%2BbMVHZVTrLn3F5S2FZsJsRyAXbi8%2FUjAbJBEjZxwCaJkn0xjSQEWqvVLXXjKzh8eftX5K8WP8gMh1emMXu7gqMr03Q8m%2F7LBNtMAAw3l8yjYJbL9oKH4G%2FMC%2BbSdTDDcalgQkiYBKuycEqWSzxNSjI%2FishrudgTCctXXflzLAkepn4oS38PZskilwLD2J%2F4BQfzRX5pF%2BUnJv70eR6R9TK%2F3pUJb9Kf7PSLz9vKy8cLf0ZeCyI4voLDiJAk%2B%2FTyNsQhe7b8sWX1birO7vod4WVSp8IY%2FTr8uRpt%2FvMLSdy%2F1nbyFkXXlps1s%2FHDNeb3YYe0wcEs2NCPc%2FbxHs8DsuQn6CUK5xTF%2F%2Ftw%2Ffv44ee1WVUjfRzJlg8BfTIr9vHlbc4w1gsmL70JoQgbrKKf2%2FRUlPUADp7IMnnIqxr0eIOjJKCj2Q%2BDOT0%2FSsiKSv38KMRP7Irxyp8Gy%2FltejSC5l70kxUfWazhIAyHJCQRPV6SJW1%2FkA4unuVXel0ECX6g1dilX2lHqWyRvIT0CLAGk4g8Y94CBYOR%2FuzOcHCxi8%2F8eLFrlwI78YMljnhDWc%2Fo0bWVng5DfxUHk90t47eVv%2BS1IzxdR3Gwwfc4zrhl7B4xezb4rRIuYAdCSm5MXnASbWmRvAK7gaxOzmwzh8rrniWulxdZFAiCnFzo58yc79reo5N%2ByAH6HrB6dcD6AGsDlYsmkSg5hthnnEwX%2BcNekWCZpPeKBvQPvfth9hfRokMm6ZlIIVTJHFkI5GL0P6C6gihUyRxZCORi7Ij3uixUyRwk91isDRS1gVCb%2FoEDsk5CSofhTt8bOe0L3KK%2FNww4JdZSudPvA2Cr2PiU%2Fojc49rj1p%2Fg8I7EQZJqmdGEJAl5OapeppRLjLdFPZAqqIyJwBQUFjvvx6vstp6CN9aPgaj9%2FNfY6kU4Jutoiv89TbUePcw%2BlUvFsC7XDyj%2FSg1gWWX%2Bc7IXFIDjyvznsubpD9qZq8Z9OlcBPVd93rmKcr48V0EZqp571rkKID1X6blKz1WNzVWHNQB0uzVXOU4d%2Bv92N6zN%2FzuMI6Zq65FeCcy24aRAB%2BxtVtPHVd53iQM3yEWQcYBWmAV4z5t8VmsNL56JSoABCsBATwYMt0EaB4wJJcD0N34Q%2BpMgDBLW87%2FYI6mcBApgqOt2K6wISRUByxkP%2BkXsgEpoiNpD0IO7po4YJ03YA67gu9ry6O5MhuLwQrste8CUjddTx7euqfqFxxfaXRtfKCv8uyjY%2BAkdU%2BNhPVni5LBlptTYFWqx8DRVD%2FvYtK6cxdlS5iq9pGr2Ts8%2Bxtl9KHB0c5M7EArQneL2KOwo1%2FGAZ4vTWCPaApTRtFv7LcLJUsEJtAYnW8Pps8IJOp2Dk6NaOhHgg2dzzIeVRMmCzMnSD8d7aWGNgQ37vswtSVcmmPB%2FOEm2OVj8dULK6KLu%2F0Z41Oyqhx807WTqXhy4vdyWS%2Fxojg8ZhQCqRy7CoZ8Em3JHGh8E1YqAMAZHjfLCw6xpn5e5lXNIMMMNYzC%2BMVVU%2Fnsd4d46TltqgBsmQHaJG47jSdywnB6SyYFa48blqfAUktf%2BMnjx8%2BEGzdIDwLr8QJfkB5BdIG7pUnW%2B5HbuMCTr2U1EtXnBDi4WODwx6hWwzqyAuUOLbZd%2FlxWwKQPuUwrchuxWs7xD4ygMjbOuetnO5VVpGWJPiP1KEAvZw7ie%2BdHzPxgODfbLQG5CD7HffyqUcradESR%2F5Jdln%2F9k8h7Kj0ZvhWKjbeHgDkcBfcTpvknDtg%2Bwayp3ZH1QuedV75gCLUzppiX44nzdjLeR3UJeTUDYrh8fAJ17edC1PH%2FXHWLgtTLEwEblIZa2zbKetTbEQPaGVZbBPZ2MMKJWhKEtA20ZfCLLIGLAfUS1d8iOOVmiRuae5qXsAggk5r1HRRunqeiPaOX2daiFzFo6tEZLrtBSxYTbjyJ%2FWyiW67v3d7l%2Bz8oV6IesD81ODtVRgUXd378dnDQrvEuNVSyw1tNueeHOKbYUJzgab3A2PVau%2BfqrVUj7wrr4GBJ%2F9jjxQ385bWrxCNggm2RU2L%2BUauMu2OGN%2FhvK7XTtXkfsfGKrZDxyQCFK7qtbJU85aNvZFYGKPVtLwVyrNebK6%2FE7mmpCakJ%2BdUJ6htkxQspefp8a9SxXKw1868peGQ%2BVVu6VMTckzrLL0pocCws%2F1SACPlrQq6YrDyNSxT5zWfPjKIfCjIcPWqlqpdpFpYqncVMWjidYOAaSmAgVRIStEVFO7tRE1ET88kS0UNeIWCtxNeWmzgbSZNdk%2F4gbc2my84b1rKuJ%2BJ2I6Fodm3Whamn%2B3duQhXHBy1mfvXGGjW5Ips9MFE7SYz7IKW78KBHLpcKbICw0VTiSoIYsNLCtKzFOhQ5FtGXxR0bPsnYCFoQEeoaBuGAfh5QebYtHYiQSj2jaRzH9yS9WGdF0ztiX3TuBjsW%2BmBWx3cWgex4f99G9XEuAuiViuGIHVm7JdY60VLEr%2FO69XKnLuY18oGfgUIV29nJhraz5%2BxEzlP0XpkeXk3h1wPqV6v7YPvx6S6%2Fg9oz6dfyYEUYb2J95Xh96JlIr2y85r0ezxrxp%2FioLns7EveviArNiXm8tYQPWe2eZVhJaSWglcSYl4aKOKQnLPG78d8W03xnnfxQPCrkFpxr1H01T2L2y8gyGPjf9jhr6sOKtZW0Y%2BsjzxIgz4Fg9G55o7tv12ms5nN5SbLTrd42cqPpMD5UdJSS%2FJ%2FPM76Kw5A14%2Fa6Rk8cXga6NL5809cshPt3LIUzPLqPJU6DpvO%2BG4OpLo%2BnzoQmZnUMTlMByhlSfunZo89mvrqFeJn13Wo%2Fckhig11BaT2WX6%2FfsHEvBqDqxQqf1fKW0HtOxgZzWIy8fnDWtB9XaiNBpPV9h0e%2Bb7fg3mkUgWSBQ4R6dNYsAyYsbOq1HE%2FK7EBIa3ALvDCEVq1E6ree9enVn6lwsrQfpbAKtVD%2BNUm0srtFElmDhGFBi4lnjGpGcTaCJqIn45YloGx0jIt%2Fg0Wk9muya7I2SXXZjLk52eZtMz7qaiF%2BdiKbndW3WNRWz7ru3HLsS%2B9fVtJ4r9Y7q0TA%2BHnt0NIyPB6HVgGILkX0mEmBtmcL6V92YPmiYR1pqKIVH7nK%2BZHegZ%2BahCu3s29rVb%2FHX0fl6DtfR%2BeePzjeRXf7WFWApFpPPGZ1v13prplYSWkloJXEmJQENo2tKQhWDI7CwK2b8l0vhOWro23W%2FVIrr%2BgsZ%2Bg6SXhoNHPPkFB7Trddeyyk8%2FLUB5w2zLTiqqIhxcArCK4DX6vf%2F2Wrcnef7zZyPhUaf%2BEU1jY5ZJ7%2B1zvrot958bFRV8WZBSDbMkjTYV9KkUS7GHQmD6fawGamDkmsHJfOvTHmMsif8SG0jeodhUy6T6ZX3H2yeBVYMo0KyNcRlzeNMDr%2F57W4o4UnpiUheiOiBSN5H2fOQrHrRopes%2BbJfIbkeon8iOTFlP0dyNUR%2FRHJaDnoS7eQmMQD69FpRfixCOdWfJAz9VRxM0lpGatZTnRpTLXWP46xxZRBa3TynzWpqqkzWnRpoL8up3x84A1dUKg1wEUBuC%2FJ1TEVygKHwTCyjLdfElRc5NRk1Gb8BGekEJ%2BwHyqsE5yajdRFf6BQHvckVgpbNb25vHDW%2FHeeS5rdrX2LwVc%2B%2B4GgZBhQG2HAv7CI7dfdl3Yr3KH50HUb8UkITop4hNFN7EWYX5c4bswTlcvLyCz2MCEmKxZla%2F0FmmJX4Pw%3D%3D%3C%2Fdiagram%3E%3C%2Fmxfile%3E#%7B%22pageId%22%3A%22aaaa8250-4180-3840-79b5-4cada1eebb92%22%7D)

Note: Route53 (Routing Failover Policy) is commented in main.tf Because we need Host Zone ID, for this we need DNS Name.
We Added VPC Peering for cross region RDS MySQL Group Replication, Yes We Can Use AWS Aurora But Having Challenges So I Decided To Move With RDS.
