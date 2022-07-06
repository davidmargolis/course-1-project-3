# Perform Build Automation with Webhooks and Slack Notifications

Course 3 Project 1 completed by David Margolis

## DESCRIPTION

Use Jenkins to implement CI Automation with Webhooks and Slack Notifications.

### Description:

While developing a highly scalable application, real challenges come into
picture is to maintain quality of application source. In order to check
quality of source code you need to integrate tools like SonarQube within
Pipeline.

As part of Continuous Integration developers need to make sure build artifacts
are always stored in Artifactory. Once Artifacts are store in artifactory,
trigger slack notification to end user to notify if build is success or
failure.

Once this process is automated it would help developers to improve the overall
quality of source code. Once the developer commits new source code in Git
repository, it would automatically trigger Jenkins build immediately without
any manual trigger.

__Tools required__: Git, GitHub, Jenkins, SonarCloud and Slack

### Expected Deliverables:

- Automate CI pipeline with build automation and webhook configuration.
- Configure Slack tool to integrate within pipeline for sending slack 
notifications.

## Solution

### Prerequisite

- Create test workspace in Slack
- Create repo in GitHub
- Install git
    ```
    sudo apt-get install git-all
    ```
- Install Jenkins, Maven, JDK 11
    ```
    sudo apt update
    sudo apt install jenkins maven openjdk-11-jdk
    ```
- Setup environment variables for Maven
    ```
    sudo -i
    cat <<EOT >> /etc/profile.d/maven.sh
    export JAVA_HOME=/usr/lib/jvm/default-java
    export M2_HOME=/opt/maven
    export MAVEN_HOME=/opt/maven
    export PATH=${M2_HOME}/bin:${PATH}
    EOT
    exit
    sudo chmod +x /etc/profile.d/maven.sh
    source /etc/profile.d/maven.sh
    ```
- Install Docker
    ```
    sudo apt-get install ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    ```


### Setup Github

- Create a repo in [Github](github.com)
- Create a personal access token for integrating jenkins

### Setup SonarCloud

- Add environment variable
- 




### Setup Jenkins and SonarQube in AWS Practice Lab

1. Open and start [practice labs](https://caltech.lms.simplilearn.com/courses/4041/-PG-DO---CI%2FCD-Pipeline-with-Jenkins/practice-labs)
1. Open [aws](https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1#)
1. [Create key pair](https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#CreateKeyPair:):
   - name - `jenkins_on_ec2`
   - Private key file format - `pem`
1. [Create security group](https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#CreateSecurityGroup:):
   - Security group name - `WebServerSG`
   - Description - `Jenkins`
   - Add Inbound Rules:
     - Rule 1:
       - Type - `SSH`
       - Source - `My IP`
     - Rule 2:
       - Type - `HTTP`
       - Source - `Anywhere-IPv4`
     - Rule 3:
       - Type - `Custom TCP`
       - Port range - `8080`
       - Source - `Anywhere-IPv4`
     - Rule 4:
       - Type - `Custom TCP`
       - Port range - `9000`
       - Source - `Anywhere-IPv4`
1. [Create ec2 instance](https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstances:):
   - Instance type pair name - `jenkins_on_ec2`
   - Key pair name - `jenkins_on_ec2`
   - Select <input type=radio checked> `existing security group`
   - Common security groups Info - WebServerSG
1. Finish setting up the downloaded key and shell into the ec2 instance locally:
   ```
   mv /mnt/c/Users/david/Downloads/jenkins_on_ec2.pem ~/.ssh
   chmod 400 ~/.ssh/jenkins_on_ec2.pem
   ssh -i ~/.ssh/jenkins_on_ec2.pem ec2-user@ec2-54-211-207-91.compute-1.amazonaws.com
   ```
1. Install jenkins on EC2
    ```
    sudo yum update –y \
        && sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo \
        && sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key \
        && sudo amazon-linux-extras install java-openjdk11 -y \
        && sudo yum install jenkins -y \
        && sudo systemctl enable jenkins \
        && sudo systemctl start jenkins \
        && sudo systemctl status jenkins
    ```
1. [Setup Postgres and SonarQube](https://www.fosslinux.com/24429/how-to-install-and-configure-sonarqube-on-centos-7.htm)
    1. Run commands:
       ```
       sudo yum install postgresql postgresql-server sonarqube -y \
       && sudo postgresql-setup initdb \
       && sudo service postgresql start \
       && sudo systemctl enable postgresql \
       && sudo systemctl start postgresql \
       && sudo systemctl status postgresql \
       && sudo -u postgres createuser -s sonar \
       && sudo -u postgres psql postgres
       ```
    1. Inside the opened interactive shell, run commands:
       ```
       ALTER USER sonar WITH ENCRYPTED password 'd98ffW@123?Q';
       CREATE DATABASE sonar OWNER sonar;
       \q
    1. Enter the following commands to continue setting up SonarQube:
       ```
       cd /opt \
       && sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.5.0.56709.zip \
       && sudo unzip sonarqube-9.5.0.56709.zip \
       && sudo rm sonarqube-9.5.0.56709.zip \
       && sudo mv sonarqube-9.5.0.56709 sonarqube \
       && sudo sed -ir "s/^[#]*\s*sonar\.jdbc\.username=.*/sonar.jdbc.username=sonar/" sonarqube/conf/sonar.properties \
       && sudo sed -ir "s/^[#]*\s*sonar\.jdbc\.password=.*/sonar.jdbc.password=d98ffW@123?Q/" sonarqube/conf/sonar.properties \
       && sudo sed -ir "s/^[#]*\s*sonar\.web\.javaOpts=.*/sonar.web.javaOpts=-server -Xms512m -Xmx512m -XX:+HeapDumpOnOutOfMemoryError/" sonarqube/conf/sonar.properties \
       && sudo sed -ir "s/^[#]*\s*sonar\.search\.javaOpts=.*/sonar.search.javaOpts=-server -Xms512m -Xmx512m -XX:+HeapDumpOnOutOfMemoryError/" sonarqube/conf/sonar.properties \
       && sudo useradd sonar \
       && sudo chown -R sonar:sonar /opt/sonarqube
       ```
    1. Setup SonarQube as a service with the following command:
       ```
       sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOF
       [Unit]
       Description=SonarQube service
       After=syslog.target network.target

       [Service]
       Type=forking
       ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
       ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
       LimitNOFILE=65536
       LimitNPROC=4096
       User=sonar
       Group=sonar
       Restart=on-failure

       [Install]
       WantedBy=multi-user.target

       EOF
       ```
    1. Edit configuration:
       ```
       sudo tee /etc/sysctl.conf >> /dev/null <<EOF
       vm.max_map_count = 524288
       fs.file-max = 131072

       EOF
       ```
    1. Continue running the commands:
       ```
       sudo sysctl -p \
       && sudo systemctl daemon-reload \
       && sudo systemctl enable sonarqube \
       && sudo systemctl start sonarqube \
       && sudo systemctl status sonarqube
       ```
1. Log into Jenkins <http://ec2-54-211-207-91.compute-1.amazonaws.com:8080/>
1. Create pipeline and connect it to the github repo


### Setup

1. Setup Jenkinsfile for GitHub and SonarQube following [this tutorial](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-jenkins/).
1. Copy test maven java app from [](https://github.com/spring-guides/gs-maven)

### Run

Jenkins

### Docker Compose

Create docker-compose.yml with the following services:
- [artifactory](https://jfrog.com/artifactory/install/) - <http://localhost:8082>

Run docker compose:
```
docker compose up
```


