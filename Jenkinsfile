pipeline {
  environment {
    registry = "mlerota/wp-kubernetes"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
    parameters {
        string(
            name: 'WPbranch',
            defaultValue: 'master',
            description: 'WP branch to build the code',
        )

        string(
            name: 'dockerbranch',
            defaultValue: 'master',
            description: 'Docker branch to build the code',
        )
    }

  stages {
    	stage('WP Code Build') {
            steps {
                script {
                    def upstream_params = currentBuild.rawBuild.getAction(ParametersAction).getParameters()
                    create_env = build job: 'wp-development', parameters: upstream_params
                }
             }
        }
        stage('Clone project') {
            steps {
                echo "Checking out branch ${params.WPbranch}"
                checkout([$class: 'GitSCM', branches: [[name: "*/${params.dockerbranch}"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'jenkins', url: 'https://github.com/mlerota/wp-docker-build']]])
                echo "Last commit"
                sh "git --no-pager log -n 1"
            }
        }
        stage('Copy WP Code') {
            steps {
                sh "cp -r /var/lib/jenkins/workspace/wp-development/artifact ."
            }
        }

    	stage('Building image') {
      	    steps {
		script {
            	dockerImage = docker.build registry + ":build-$BUILD_NUMBER"
            	}
      	    }
    	}
        stage('Deploy Image') {
      	    steps {
                script {
          	docker.withRegistry( '', registryCredential ) {
            	dockerImage.push()
          	}
            }
	}
     }
  }
}
