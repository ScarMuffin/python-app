 <h1>1. Fork repo https://github.com/ingvar-goryainov/python-app </h1>
 For fork repo you should go to https://github.com/ingvar-goryainov/python-app and click on for button on github gui.
 
  <h1>2. Build docker image with Python application</h1>
  
  At first you should install docker:
  ```
  sudo apt-get update
  
  sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  
   echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  sudo apt-get update
  
  sudo apt-get install docker-ce docker-ce-cli containerd.io
  ```
  
  Then you should add your user to docker group:
  ```
  sudo groupadd docker
  sudo usermod -aG docker $USER
  ```
  
  For this task I made two Dockerfiles: one using pip install -r requirements.txt and other one just python setup.py install for task with k8s it will be useful.
  
  So first one is (Using pip):
  
```
  FROM python:3.6-alpine

  RUN adduser --disabled-password sashok
  COPY . /

  RUN pip install -r requirements.txt


  RUN ["python3", "setup.py", "install"]
  USER sashok
  CMD ["python", "-m", "demo"]
  ```
  
  Second is (Without pip):
  
  ```
  FROM python:3.6-alpine

  RUN apk add --no-cache g++
  RUN adduser --disabled-password sashok


  COPY . /
  RUN ["python3", "setup.py", "install"]
  USER sashok
  CMD ["python3", "-m", "demo"]                             
  ```
  
  Then we should use ```docker build . -t pysashok``` to build image. 
  
  And we can see it using ```docker images```
  <img src="https://github.com/ScarMuffin/python-app/blob/84d68492f202045058301e09246b37663564beb5/Week3_Docker-Kubernetes/Screenshot%202021-10-25%20at%2011.17.04.png" border="0"/></a>
  
  And then we can test it using ```docker run pysashok```
  
  And we can see it works in our terminal:
    <img src="https://github.com/ScarMuffin/python-app/blob/84d68492f202045058301e09246b37663564beb5/Week3_Docker-Kubernetes/Screenshot%202021-10-25%20at%2011.19.16.png" border="0"/></a>
  
  <h1>3. Setup K8S cluster using Minikube(1 master + 1 worker node is enough)</h1>
  
  At first we should install minikube:
  ```
  sudo apt update -y
  sudo apt upgrade -y
  wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo cp minikube-linux-amd64 /usr/local/bin/minikube
  sudo chmod +x /usr/local/bin/minikube
  ```
  
  Then we should install kubectl tool:
  ```
  curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  
  chmod +x ./kubectl
  
  sudo mv ./kubectl /usr/local/bin
  ```
  
  Then we can start our minikube with 2 nodes using:
  ```
  minikube start --nodes=2
  ```
  And we can check that we have 2 nodes working using command:
  ```
  kubectl get nodes
  ```
  And we also can see it in terminal:
      <img src="https://github.com/ScarMuffin/python-app/blob/a8e3768612aaa41c04d961cba7d5e37a15b79c6f/Week3_Docker-Kubernetes/Screenshot%202021-10-25%20at%2011.30.18.png" border="0"/></a>
