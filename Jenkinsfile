node ('jenkins-docker'){
   checkout scm
    
   stage('Building image and push') {
       container('docker') {
           docker.withRegistry('https://sashok.jfrog.io', 'jfrog') {
            def dockerfile = 'Dockerfile'
            def customImage = docker.build("default-docker-virtual/sashokpy:${env.BUILD_ID}", "-f ${dockerfile} ./application")
            sh "sed -i 's/sashokpy:buildversion/sashokpy:${env.BUILD_ID}/g' deployment.yml"
            customImage.push()
           }
       }
    }
        stage('Deploy chart pulling from Artifactory') {
           container('docker') {
                kubernetesDeploy(configs: "deployment.yml", kubeconfigId: "kubeconfig")
          }
     }
}
