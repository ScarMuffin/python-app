node ('jenkins-docker'){
    checkout scm
        stage('Install helm') {
            container('docker') {
        /* This installs helm client */
          sh 'sudo apt-get update'
          sh 'sudo apt-get install -y apt-transport-https ca-certificates curl'
          sh 'sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg'
          sh 'sudo echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list'
          sh 'sudo apt-get update'
          sh 'sudo apt-get install -y kubectl'
          sh 'export HELM_DRIVER=configmap'
          sh "curl -O https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz"
          sh "tar -xvf helm-v3.7.1-linux-amd64.tar.gz"
          sh "chmod 777 ./linux-amd64/helm"
          sh "./linux-amd64/helm version"
            }
    }
  /*  stage('Building image and push') {
       container('docker') {
           docker.withRegistry('https://sashok.jfrog.io', 'jfrog') {
            def dockerfile = 'Dockerfile'
            def customImage = docker.build("default-docker-virtual/sashokpy:${env.BUILD_ID}", "-f ${dockerfile} ./application") 
            customImage.push()
           }
       }
    }*/
        stage('Deploy chart pulling from Artifactory') {
            
        sh "./linux-amd64/helm repo add hello https://www.kleinloog.ch/hello-helm/"
        sh "./linux-amd64/helm upgrade my-hello --install --recreate-pods hello/hello"
    }
}
