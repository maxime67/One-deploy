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
                    withCredentials([string(credentialsId: 'ansible-vault-password', variable: 'VAULT_PASS')]) {
                        sh """
                        echo \${VAULT_PASS} > .vault_pass
                        chmod 600 .vault_pass

                        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${ANSIBLE_INVENTORY} ${ANSIBLE_SITE_YML_PATH} --vault-password-file .vault_pass --flush-cache -v

                        rm -f .vault_pass
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
