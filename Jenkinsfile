pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = AKIA47N5ONNALRBPQMDP('AWS_CREDENTIALS_USR') // Adjust based on your credentials ID
        AWS_SECRET_ACCESS_KEY = opv8T89p0a0Qcoo7ruMcgxDbBM7VxQYocmNQbhX+('AWS_CREDENTIALS_PSW')
        AWS_DEFAULT_REGION    = "eu-west-1"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/jenniferasuwata/webApp-Quizz-B'
            }
        }

        stage('Initialize Terraform') {
            steps {
                dir('terraform/eks') {
                    sh 'terraform init'
                }
            }
        }

        stage('Format Terraform Code') {
            steps {
                dir('terraform/eks') {
                    sh 'terraform fmt -check'
                }
            }
        }

        stage('Validate Terraform') {
            steps {
                dir('terraform/eks') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Plan Terraform Deployment') {
            steps {
                dir('terraform/eks') {
                    sh 'terraform plan -out=tfplan'
                }
                input message: "Review Terraform Plan. Proceed with apply?", ok: "Apply"
            }
        }

        stage('Apply Terraform') {
            steps {
                dir('terraform/eks') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Configure kubectl') {
            steps {
                dir('terraform/eks') {
                    sh 'aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}'
                }
            }
        }

        stage('Deploy Application to EKS') {
            steps {
                dir('k8s-config') {
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed. Check the logs for details.'
        }
    }
}
