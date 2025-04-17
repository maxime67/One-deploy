pipeline {
    agent any

    environment {
        // Repository and deployment variables
        ANSIBLE_INVENTORY = 'inventory/hosts.yml'
        ANSIBLE_SITE_YML_PATH = "site.yml"
    }

//     stages {
//         stage('Run Ansible Playbook') {
//             steps {
//                 sh """
//                 set -x
//                      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${ANSIBLE_INVENTORY} ${ANSIBLE_SITE_YML_PATH} --flush-cache \
//                      -v
//                 """
//             }
//         }
//     }
     stages {
            stage('Run Ansible Playbook') {
                steps {
                    withCredentials(
                    [string(credentialsId: 'ansible-user', variable: 'ANSIBLE_USER')],
                    [string(credentialsId: 'database-url', variable: 'DATABASE_URL')],
                    [string(credentialsId: 'ansible-ssh-password', variable: 'ANSIBLE_SSH_PASSWORD')],
                    [string(credentialsId: 'jwt-secret', variable: 'JWT_SECRET')],
                     [string(credentialsId: 'ansible-vault-password', variable: 'VAULT_PASS')]
                     ) {
                        sh """
                        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${ANSIBLE_INVENTORY} ${ANSIBLE_SITE_YML_PATH} --vault-password-file .vault_pass.txt --flush-cache -v -e "database_url=${DATABASE_URL} jwt_secret=${JWT_SECRET} ansible_user=${ANSIBLE_USER} ansible_ssh_pass=${ANSIBLE_SSH_PASSWORD}"
                        """
                    }
                }
            }
        }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
