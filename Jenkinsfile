pipeline {

  environment {
    dockerimagename = "derskiy/application"
    dockerImage = ""
  }

     agent {
    kubernetes { 
        yaml ''' 
    apiVersion: v1
    kind: Pod
    spec:
     containers:    
     - name: docker
       image: docker:19.03.1-dind
       securityContext:
         privileged: true  
        '''
      defaultContainer 'docker'
    }      
}

  stages {

   
    stage('Deploying App to Kubernetes') {
      steps {
        script {
          kubernetesDeploy(configs: "deployment.yaml", kubeconfigId: "kubeconfig")
        }
      }
    }
  }
}





/*node ('jenkins-docker'){
    checkout scm
    
   stage('Building image and push') {
       container('docker') {
           docker.withRegistry('https://sashok.jfrog.io', 'jfrog') {
            def dockerfile = 'Dockerfile'
            def customImage = docker.build("default-docker-virtual/sashokpy:${env.BUILD_ID}", "-f ${dockerfile} ./application") 
            customImage.push()
           }
       }
    }
        stage('Deploy chart pulling from Artifactory') {
                kubernetesDeploy(configs: "deployment.yml", kubeconfigId: "kubeconfig")
            }
}*/
