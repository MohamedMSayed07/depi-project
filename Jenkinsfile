pipeline {
    agent {
        label 'slave'
    }
    environment {
        TERRAFORM_DIR = "terraform/jenkins-master-terraform"
        ANSIBLE_PLAYBOOK = "ansible-env/playbook.yml"
    }
    stages {
        stage("Prep") {
            steps {
                git(
                    url: "https://github.com/MohamedMSayed07/Final-Project.git",
                    branch: "main",
                    credentialsId: "GitHub",
                    changelog: true,
                    poll: true
                )
            }
        }
        stage("Terraform init") {
            steps {
                dir("${TERRAFORM_DIR}") {
                    sh 'terraform init'
                }    
            }
        }
        stage('Create Jenkins Slave with Terraform') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'jenkins_ssh_key', keyFileVariable: 'SSH_KEY')]) {
                    dir("${TERRAFORM_DIR}") {
                        // Apply Terraform and pass the private key to the instance creation process -var ssh_key_path=${SSH_KEY}
                        sh """
                        terraform apply -auto-approve -var ssh_key_path=${SSH_KEY}
                        """
                    }
                }
            }
        }
        stage('Run Ansible Playbook To Configure The Deployment Environment') {
            steps {
                // Pass the SSH key to Ansible
                    sh """
                        cat terraform/jenkins-master-terraform/ec2_public_ip.txt >> ansible-env/inventory.ini
                        echo " ansible_user=ubuntu" >> ansible-env/inventory.ini
                    """
                        // cat terraform/jenkins-master-terraform/ec2_public_ip.txt >> ansible-deploy/inventory.ini
                        // echo " ansible_user=ubuntu" >> ansible-deploy/inventory.ini
                withCredentials([sshUserPrivateKey(credentialsId: 'jenkins_ssh_key', keyFileVariable: 'SSH_KEY')]) {
                    withEnv(["ANSIBLE_HOST_KEY_CHECKING=false"]){
                        ansiblePlaybook(
                            playbook: "${ANSIBLE_PLAYBOOK}", 
                            inventory: 'ansible-env/inventory.ini', 
                            extras: "--private-key=${SSH_KEY}"
                        )
                    }
                }
            }
        }
        stage("Build") {
            steps {
                echo "Welcome to Build Stage"
                withCredentials([usernamePassword(credentialsId:"docker",usernameVariable:"USER",passwordVariable:"PASS")]){
                sh 'docker build . -t ${USER}/todo-app:v1.${BUILD_NUMBER}'
                sh 'docker login -u ${USER} -p ${PASS}'
                sh 'docker push ${USER}/todo-app:v1.${BUILD_NUMBER}'
                }
            }
        }
        stage("Test") {
            steps {
                // sh 'docker run --name note-app -it -p 3000:3000 ${USER}/note-app:v1.${BUILD_NUMBER}'
                withCredentials([usernamePassword(credentialsId:"docker",usernameVariable:"USER",passwordVariable:"PASS")]){
                sh 'docker run --rm ${USER}/todo-app:v1.${BUILD_NUMBER} pytest /app'
                }
            }
        }
        stage("Deploy") {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'jenkins_ssh_key', keyFileVariable: 'SSH_KEY')]) {
                    echo "Welcome to Deploy Stage"
                    script {
                        def publicIp = readFile('terraform/jenkins-master-terraform/ec2_public_ip.txt').trim()
                        // added to test deployment stage on ec2
                        withCredentials([usernamePassword(credentialsId:"docker",usernameVariable:"USER",passwordVariable:"PASS")]){
                        sh """
                            ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ubuntu@${publicIp} 'docker run -d --name todo-app -p 3000:3000 ${USER}/todo-app:v1.${BUILD_NUMBER}'
                        """ 
                            // 'docker run -d --name note-app -p 3000:3000 ${USER}/todo-app:v1.${BUILD_NUMBER}' 
                        }
                    }
                }
            }
        }
    }
    post {
        success {
            withCredentials([usernamePassword(credentialsId:"docker",usernameVariable:"USER",passwordVariable:"PASS")]){
                slackSend(
                    channel: "final-project",
                    color: "good",
                    message: "${env.JOB_NAME} is succeeded. Build no. ${env.BUILD_NUMBER} (<https://hub.docker.com/repository/docker/${USER}/todo-app/general|Open the image link>)"
                )
            }
        }
        failure {
            dir("${TERRAFORM_DIR}") {
                        sh """
                        terraform destroy -auto-approve 
                        """
                    }
            slackSend(
                channel: "final-project",
                color: "danger",
                message: "${env.JOB_NAME} is failed. Build no. ${env.BUILD_NUMBER} URL: ${env.BUILD_URL}"
            )
        }
    }
}
// Testing GitHub-WebHooks