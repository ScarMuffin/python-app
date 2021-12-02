node ('jenkins-docker'){
    checkout scm
    
/*   stage('Building image and push') {
       container('docker') {
           docker.withRegistry('https://sashok.jfrog.io', 'jfrog') {
            def dockerfile = 'Dockerfile'
            def customImage = docker.build("default-docker-virtual/sashokpy:${env.BUILD_ID}", "-f ${dockerfile} ./application") 
            customImage.push()
           }
       }
    }*/
        stage('Deploy chart pulling from Artifactory') {
                kubernetesDeploy(configs: "deployment.yml", kubeconfigId: "kubeconfig")
            }
}
