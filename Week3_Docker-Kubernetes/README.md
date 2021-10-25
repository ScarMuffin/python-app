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
  
  So first one is:
  
```FROM python:3.6-alpine

  RUN adduser --disabled-password sashok
  COPY . /

  RUN pip install -r requirements.txt


  RUN ["python3", "setup.py", "install"]
  USER sashok
  CMD ["python", "-m", "demo"]
  ```
  Second is:
  ```
  FROM python:3.6-alpine
  FROM python:3.6-alpine

  RUN apk add --no-cache g++
  RUN adduser --disabled-password sashok


  COPY . /
  RUN ["python3", "setup.py", "install"]
  USER sashok
  CMD ["python3", "-m", "demo"]                             
  ```
