pipeline {
  agent any
  environment {
    // AWS credentials stored in Jenkins Credentials Plugin
    AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    // Terraform version
    TERRAFORM_VERSION = '1.5.0'
  }
  parameters {
    choice(name: 'ENVIRONMENT', choices: ['dev', 'prod'], description: 'Select environment to deploy')
    booleanParam(name: 'APPLY', defaultValue: false, description: 'Apply Terraform changes (false for plan only)')
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/davmano/terra-reusable-infra.git'
      }
    }
    stage('Install Terraform') {
      steps {
        sh """
          wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
          unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
          mv terraform /usr/local/bin/
          terraform --version
        """
      }
    }
    stage('Terraform Init') {
      steps {
        sh "terraform init -backend-config='bucket=my-terraform-state-bucket' -backend-config='key=${params.ENVIRONMENT}/terraform.tfstate' -backend-config='region=us-east-1' -backend-config='dynamodb_table=terraform-locks'"
      }
    }
    stage('Terraform Validate') {
      steps {
        sh 'terraform validate'
      }
    }
    stage('Terraform Plan') {
      steps {
        sh "terraform plan -var-file=${params.ENVIRONMENT}.tfvars -out=tfplan"
      }
    }
    stage('Terraform Apply') {
      when {
        expression { params.APPLY && params.ENVIRONMENT == 'dev' }
      }
      steps {
        sh 'terraform apply -auto-approve tfplan'
      }
    }
    stage('Terraform Apply Prod') {
      when {
        expression { params.APPLY && params.ENVIRONMENT == 'prod' }
      }
      input {
        message "Approve Terraform apply for production?"
        ok "Apply"
      }
      steps {
        sh 'terraform apply -auto-approve tfplan'
      }
    }
    stage('Capture Outputs') {
      when {
        expression { params.APPLY }
      }
      steps {
        sh 'terraform output > outputs.txt'
        archiveArtifacts artifacts: 'outputs.txt', allowEmptyArchive: true
      }
    }
  }
  post {
    always {
      cleanWs()
    }
    success {
      echo "Terraform deployment for ${params.ENVIRONMENT} completed successfully"
    }
    failure {
      echo "Terraform deployment failed. Check logs for details."
    }
  }
}
