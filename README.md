### AWS-DEPLOYMENT
Deploys a Node application to AWS

### Description
- uses NGINX for reverse proxy
- uses [letsencrypt](https://letsencrypt.org/) to install SSL
- Runs checkpoint in the background using PM2
- Has Domain name from freenom.com and leverages AWS Route 53 to create a record that points to the project's IP that is hosted on AWS EC2

### Deployment procedure
- Follow this [link](https://aws.amazon.com/) to create an AWS account
- Follow this [guide](https://docs.aws.amazon.com/efs/latest/ug/gs-step-one-create-ec2-resources.html) to create an AWS EC2 instance
- Configure security group for HTTP port 80 to make the application accessible on the EC2 instance's IP address 
- Obtain a keypair and download it as a .pem file
- On the terminal, navigate in the folder containing the keypair and only permit read access to the root user using `chmod 400 <keypair>`.
- Remotely login into the EC2 instance using `ssh -i <.pem keypair file> <user>@<Instance IP address>`. Example `ssh -i demo.pem ubuntu@13.57.186.168`
- Create a script file such as `example.sh`. 
- Paste the contents of deployment.sh using any choice editor
- Create a .env file and add content as instructed in the sample_env.txt file.
- Install and then start the project with running the bash script you created using `sudo bash example.sh`
-Once the script run has completed, navigate to the IP address of the EC2 instance in the browser and be able to view your application.
- Obtain a domain name from any available provider.
- Redirect traffic from your IP address to the purchased domain name using AWS Route53 - Copy the name servers that are in your AWS account and paste them on the name servers of the domain name.
- Configure another  security group for HTTPS (port 443)to enable certbot (https://certbot.eff.org/) to redirect traffic from clients to a secure connection on your domain

