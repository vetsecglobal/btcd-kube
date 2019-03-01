pipeline {

  agent {
    label "jenkins-go"
  }
  environment {
    ORG               = 'kevinstl'
    APP_NAME          = 'btcd-kube'
    CHARTMUSEUM_CREDS = credentials('jenkins-x-chartmuseum')
    NEW_VERSION_LOCAL = 'true'
    DEPLOY_PVC        = 'false'
    DEPLOY_SIMNET     = 'true'
    DEPLOY_TESTNET    = 'false'
    DEPLOY_MAINNET    = 'false'
  }
  stages {

    stage('Determine Environment') {
      steps {
        script {
          kubeEnv = sh(returnStdout: true, script: 'echo "${KUBE_ENV}"')
        }
        echo "kubeEnv: ${kubeEnv}"
      }
    }

    stage('CI Build and push snapshot') {
      when {
        branch 'PR-*'
      }
      environment {
        PREVIEW_VERSION = "0.0.0-SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER"
        PREVIEW_NAMESPACE = "$APP_NAME-$BRANCH_NAME".toLowerCase()
        HELM_RELEASE = "$PREVIEW_NAMESPACE".toLowerCase()
      }
      steps {
        container('go') {
//          sh "mvn versions:set -DnewVersion=$PREVIEW_VERSION"
          //sh "mvn install"
          //sh "./build.sh container prod verify"
//          sh "./build.sh container prod package"

          sh "make build"

          sh 'export VERSION=$PREVIEW_VERSION && skaffold build -f skaffold.yaml'

          sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:$PREVIEW_VERSION"
        }

        dir ('./charts/preview') {
          container('go') {
            sh "make preview"
            sh "jx preview --app $APP_NAME --dir ../.."
          }
        }
      }
    }


    stage('Build Release Feature') {
      when {
        branch 'feature-*'
      }
      steps {
        script {
          release(null)
        }
      }
    }

    stage('Build Release Master') {
      when {
        branch 'master'
      }
      steps {
        script {
          release('master')
        }
      }
    }

    stage('Promote to Environments Feature') {
      when {
        branch 'feature-*'
      }
      steps {
        script {
          if (kubeEnv?.trim() != 'local') {
            promote()
          }
        }
      }
    }

    stage('Promote to Environments Master') {
      when {
        branch 'master'
      }
      steps {
        script {
          if (kubeEnv?.trim() != 'local') {
            promote()
          }
        }
      }
    }

    stage('Deploy Local Simnet') {
      when {
        branch 'feature-*'
      }
      environment {
        DEPLOY_NAMESPACE = "lightning-kube-simnet"
      }
      steps {
        script {

          if (kubeEnv?.trim() == 'local') {

            if (DEPLOY_SIMNET == 'true') {

//              if (branch?.trim()) {
//                sh "git checkout $branch"
//              }

//              sh "git config --global credential.helper store"
//              sh "jx step git credentials"




              sh 'pwd'
              sh 'ls -al'
              sh 'git clone https://github.com/kevinstl/lnd-kube.git'

              sh "git checkout ${env.BRANCH_NAME}"

              sh 'pwd'
              sh 'ls -al'


              dir('./lnd-kube') {
                container('go') {
                  sh 'pwd'
                  sh 'ls -al'
////              sh 'jx release version -gh-repository https://github.com/kevinstl/lnd-kube.git'
////                sh 'cd /host-home/Developer/projects/lnd-kube/'
                  sh 'echo \$(jx-release-version) > ../LND_VERSION'
////                sh 'jx-release-version'
                }
              }



              sh 'pwd'
              sh 'ls -al'
              sh 'git clone https://github.com/kevinstl/environment-jx-lightning-kube-simnet.git'
              sh 'pwd'
              sh 'ls -al'
              sh 'cat ./environment-jx-lightning-kube-simnet/env/requirements.yaml'
              sh 'cat ./charts/btcd-kube/dynamic-templates/requirements-env.yaml | sed "s/\\X_BTCD_VERSION_X/$(cat ./VERSION)/"  | sed "s/\\X_LND_VERSION_X/$(cat ./LND_VERSION)/" > ./environment-jx-lightning-kube-simnet/env/requirements.yaml'
              sh 'cat ./environment-jx-lightning-kube-simnet/env/requirements.yaml'

//              sh 'sleep 1h'

              if (NEW_VERSION_LOCAL == 'true') {
                dir('./charts/btcd-kube') {
                  container('go') {
                    sh 'pwd'
                    sh 'ls -al'
                    //                  sh 'jx step changelog --version v\$(cat ../../VERSION)'
                    sh 'jx step helm release'
                    //                  sh 'jx promote --verbose -b --env lightning-kube-simnet --timeout 1h --version \$(cat ../../VERSION)'
                  }
                }
              }

              dir('./environment-jx-lightning-kube-simnet/env') {
                container('go') {
                  sh 'pwd'
                  sh 'ls -al'
                  sh 'jx step helm build'
                  //                sh 'jx step helm apply --force=false'
                  sh 'jx step helm apply --wait=false'
                }
              }

            }

          }
        }
      }
    }

    stage('Deploy Local Mainnet') {
      when {
        branch 'feature-*'
      }
      environment {
        DEPLOY_NAMESPACE = "lightning-kube-mainnet"
      }
      steps {
        script {

          if (kubeEnv?.trim() == 'local') {

            if (DEPLOY_MAINNET == 'true') {
              sh 'pwd'
              sh 'ls -al'
              sh 'git clone https://github.com/kevinstl/environment-jx-lightning-kube-mainnet.git'
              sh 'pwd'
              sh 'ls -al'
              sh 'cat ./environment-jx-lightning-kube-mainnet/env/requirements.yaml'
              sh 'cat ./charts/btcd-kube/dynamic-templates/requirements-env.yaml | sed "s/\\X_VERSION_X/$(cat ./VERSION)/" > ./environment-jx-lightning-kube-mainnet/env/requirements.yaml'
              sh 'cat ./environment-jx-lightning-kube-mainnet/env/requirements.yaml'

              if (NEW_VERSION_LOCAL == 'true') {
                dir('./charts/btcd-kube') {
                  container('go') {
                    sh 'pwd'
                    sh 'ls -al'
                    //                  sh 'jx step changelog --version v\$(cat ../../VERSION)'
                    sh 'jx step helm release'
                    //                  sh 'jx promote --verbose -b --env lightning-kube-mainnet --timeout 1h --version \$(cat ../../VERSION)'
                  }
                }
              }

              dir('./environment-jx-lightning-kube-mainnet/env') {
                container('go') {
                  sh 'pwd'
                  sh 'ls -al'
                  sh 'jx step helm build'
                  //                sh 'jx step helm apply --force=false'
                  sh 'jx step helm apply --wait=false'
                }
              }

            }

          }
        }
      }
    }



//    stage('Deploy Local Old') {
//      steps {
//        script {
//
//          sh 'echo  DEPLOY_PVC: ${DEPLOY_PVC}'
//          sh 'echo  DEPLOY_SIMNET: ${DEPLOY_SIMNET}'
//          sh 'echo  DEPLOY_TESTNET: ${DEPLOY_TESTNET}'
//          sh 'echo  DEPLOY_MAINNET: ${DEPLOY_MAINNET}'
//
//
//          if (kubeEnv?.trim() == 'local') {
//
//            dir ('./charts/btcd-kube') {
//
//              if (DEPLOY_SIMNET == 'true') {
//
//
//
//              }
//
//              if (DEPLOY_TESTNET == 'true') {
//
//
//
//                container('go') {
//                  sh './undeploy-helm.sh "" lightning-kube testnet ${DEPLOY_PVC} || true'
//                  sh './deploy-helm.sh "" lightning-kube \$(cat VERSION) btcd-kube-local LoadBalancer \
//                      30080 testnet ${DEPLOY_PVC} 18333 18334'
//                }
//              }
//              if (DEPLOY_MAINNET == 'true') {
//
//                if (DEPLOY_PVC == 'true') {
//                  container('go') {
//                    sh './scripts/create-pv.sh "" lightning-kube-mainnet -mainnet 275Gi'
//                  }
//                }
//
//                container('go') {
//                  sh './undeploy-helm.sh "" lightning-kube mainnet ${DEPLOY_PVC} || true'
//                  sh './deploy-helm.sh "" lightning-kube \$(cat VERSION) btcd-kube-local LoadBalancer \
//                      30080 mainnet ${DEPLOY_PVC} 8333 8334'
//                }
//              }
//
//            }
//          }
//        }
//      }
//    }

    stage('Push Local') {
      steps {
        script {
          if (kubeEnv?.trim() == 'local') {
            container('go') {
              sh "echo branch: ${env.BRANCH_NAME}"
              sh "./push.sh ${env.BRANCH_NAME}"
            }
          }
        }
      }
    }
  }

  post {
    always {
      cleanWs()
    }
    failure {
      input """Pipeline failed.
We will keep the build pod around to help you diagnose any failures.

Select Proceed or Abort to terminate the build pod"""
    }
  }
}

def release(branch) {

  deployPvc()

  container('go') {
    // ensure we're not on a detached head
    //sh "git checkout master"

    if (branch?.trim()) {
      sh "git checkout $branch"
    }

    sh "git config --global credential.helper store"
    sh "jx step git credentials"

    // so we can retrieve the version in later steps
    sh "echo \$(jx-release-version) > VERSION"
//    sh "mvn versions:set -DnewVersion=\$(cat VERSION)"
  }

  dir ('./charts/btcd-kube') {
    if (kubeEnv?.trim() != 'local' || NEW_VERSION_LOCAL == 'true') {
      container('go') {
        sh "pwd"
        sh "ls -al"
        sh "make tag"
      }
    }
  }

  container('go') {
    //sh 'mvn clean deploy'
    //sh "./build.sh container prod verify -DskipTests"

    sh "ls -al"

    sh "docker version"

    //sh "./build.sh container prod package -DskipTests"

//    sh "./build.sh container prod package"

    sh "make build"

    sh 'export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml'

//    sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:\$(cat VERSION)"

    postBuild()
  }



}

def promote() {

  dir ('./charts/btcd-kube') {


    if (DEPLOY_SIMNET == 'true') {

      if (DEPLOY_PVC == 'true') {
        container('go') {
          sh './scripts/create-pv.sh "" lightning-kube-simnet -simnet 5Gi'
        }
      }

      container('go') {
        sh 'jx step changelog --version v\$(cat ../../VERSION)'
        // release the helm chart
        sh 'jx step helm release'
        // promote through all 'Auto' promotion Environments
//      sh 'jx promote --verbose -b --all-auto --timeout 1h --version \$(cat ../../VERSION)'
        sh 'jx promote --verbose -b --env lightning-kube-simnet --timeout 1h --version \$(cat ../../VERSION)'
      }
    }
    if (DEPLOY_TESTNET == 'true') {

      if (DEPLOY_PVC == 'true') {
        container('go') {
          sh './scripts/create-pv.sh "" lightning-kube-testnet -testnet 25Gi'
        }
      }

      container('go') {
        sh 'jx step changelog --version v\$(cat ../../VERSION)'
        // release the helm chart
        sh 'jx step helm release'
        // promote through all 'Auto' promotion Environments
//      sh 'jx promote --verbose -b --all-auto --timeout 1h --version \$(cat ../../VERSION)'
        sh 'jx promote --verbose -b --env lightning-kube-testnet --timeout 1h --version \$(cat ../../VERSION)'
      }
    }
    if (DEPLOY_MAINNET == 'true') {

      if (DEPLOY_PVC == 'true') {
        container('go') {
          sh './scripts/create-pv.sh "" lightning-kube-mainnet -mainnet 275Gi'
        }
      }

      container('go') {
        sh 'jx step changelog --version v\$(cat ../../VERSION)'
        // release the helm chart
        sh 'jx step helm release'
        // promote through all 'Auto' promotion Environments
//      sh 'jx promote --verbose -b --all-auto --timeout 1h --version \$(cat ../../VERSION)'
        sh 'jx promote --verbose -b --env lightning-kube-mainnet --timeout 1h --version \$(cat ../../VERSION)'
      }
    }

//    container('go') {
//      sh 'jx step changelog --version v\$(cat ../../VERSION)'
//      // release the helm chart
//      sh 'jx step helm release'
//      // promote through all 'Auto' promotion Environments
////      sh 'jx promote --verbose -b --all-auto --timeout 1h --version \$(cat ../../VERSION)'
//      sh 'jx promote --verbose -b --env lightning-kube-mainnet --timeout 1h --version \$(cat ../../VERSION)'
//    }
  }

}

def postBuild() {
  script {
    if (kubeEnv?.trim() != 'local') {
      sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:\$(cat VERSION)"
    }
  }
}


def deployPvc() {
  if (DEPLOY_PVC == 'true') {
    container('go') {
//      sh './scripts/create-pv.sh "" lightning-kube-testnet -testnet 25Gi'
//      sh './scripts/setup-pv-templates.sh'
    }
  }
}

