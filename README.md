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

__Tools required__: Git, GitHub, Jenkins, Artifactory and Slack

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

### Setup

1. Setup Jenkinsfile for GitHub and SonarQube following [this tutorial](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-jenkins/).
1. Copy test maven java app from [](https://github.com/spring-guides/gs-maven)



### Docker Compose

Create docker-compose.yml with the following services:
- [artifactory](https://jfrog.com/artifactory/install/) - <http://localhost:8082>

Run docker compose:
```
docker compose up
```


