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
      
   <h1>4. Deploy the application into the K8S cluster </h1>
   
   <h3> Create Deployment .yaml file with containerized application 
 The deployment requires 3 replicas, “RollingUpdate” strategy. 
 Emulate the “RollingUpdate” strategy by updating docker image. Provide screenshots. Define the liveness and readiness probes to /health endpoint and 8080 port, resources(requests/limits)</h3>
 
 For that task we should create deployment.yml with content in it:
 ```
 apiVersion: apps/v1
kind: Deployment
metadata:
  name: sashokpy
spec:
  replicas: 3
  selector:
    matchLabels:
      app: sashokpy
  strategy:
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: sashokpy
    spec:
      containers:
      - name: sashokpy
        image: sashokrar/sashokpy
        ports:
        - containerPort: 8080
        resources:
          limits:
            memory: "200Mi"
            cpu: "200m"
          requests:
            memory: "100Mi"
            cpu: "100m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
        readinessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
 ```

So to create 3 replicas we should have
```
spec:
  replicas: 3
  ```
In our deployment.yml

For RollingUpdate strategy we should have
```
  strategy:
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
    type: RollingUpdate
```
In our deployment.yml

For liveness and readness probe we should have
```
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
        readinessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```
In our deployment.yml

And for the recources limites we should have
```
        resources:
          limits:
            memory: "200Mi"
            cpu: "200m"
          requests:
            memory: "100Mi"
            cpu: "100m"
```
In our deployment.yml

To emulate rollingupdate I changed replicas to 10 to see how it works and changed image to sashokrar/pysashok which I also have in my docker repository and now you can see it
      <img src="https://github.com/ScarMuffin/python-app/blob/1ae64145f047c94adc489012d5e9639989c85556/Week3_Docker-Kubernetes/Screenshot%202021-10-25%20at%2012.15.45.png" border="0"/></a>


<h3> * Create a “Service” object which exposes Pods with application outside the K8S cluster in order to access each of the replicas through the single IP address/DNS name. </h3>

To create our service we should use command:
```
kubectl expose deploy/sashokpy --type=LoadBalancer
```
Then we can check it using command:
```
kubectl get svc
```
And we can get the link using:
```
minikube service sashokpy
```
<img src="https://github.com/ScarMuffin/python-app/blob/4dc507b19aba28b6b872f45453c24de25624d122/Week3_Docker-Kubernetes/Screenshot%202021-10-25%20at%2013.30.15.png" border="0"/></a>

And then you can curl link
<img src="https://github.com/ScarMuffin/python-app/blob/08eb3f245c075a0b78ade7e1d6b6b13e2046ec20/Week3_Docker-Kubernetes/Screenshot%202021-10-25%20at%2013.34.46.png" border="0"/></a>
And here we can see different hostnames that shows us that our LoadBalancer works.

<h3>Specify PodDistruptionBudget which defines that only 1 replica can be down. </h3>

To add PodDistruptionBudget we should create YML file for example PodDistruptionBudget.yml
And put there:

```
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: sashok-pdb
spec:
  maxUnavailable: 1
  selector:
    matchLabels:
      app: sashokpy
```

After that we should apply it
```
kubectl apply -f PodDistruptionBudget.yml

```

And now we can check it using command

```
kubectl get pdb
```

And here we see it
<img src="https://github.com/ScarMuffin/python-app/blob/a56f6223f1fd35f81bc02b65649986f7f1a5e371/Week3_Docker-Kubernetes/Screenshot%202021-10-25%20at%2021.34.39.png" border="0"/></a>



