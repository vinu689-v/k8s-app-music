# k8s-app-music
This project deploys a Go-based web service backed by a Redis database in a local Kubernetes environment using Minikube.

Pre-requistes
1. Install Docker
      sudo apt update
      sudo apt install -y ca-certificates curl gnupg lsb-release

Add Docker GPG key:

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

Add Docker repository:

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

Install Docker Engine:

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

Enable Docker and add user to docker group:

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

NOTE: Log out and log back in for changes to take effect.

Verify Docker installation:

docker --version
docker run hello-world


=============================
2. Install kubectl
=============================

Download latest stable kubectl:

curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

Make executable and move to PATH:

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

Verify kubectl installation:

kubectl version --client



Prerequisites (Ubuntu 22.04.3 LTS)
- Minikube (latest)
- kubectl
- Docker

Verify:
minikube version
kubectl version --client
docker --version

Deployment Steps
1. Start Minikube:
minikube start

2. Deploy:
chmod +x deploy.sh
./deploy.sh

3. Configure /etc/hosts:
sudo nano /etc/hosts
<MINIKUBE_IP> music.local

Verification
kubectl get pods -n music-app
curl -k https://music.local/api/v1/music-albums?key=100

Expected:
{"album":"Iron Maiden"}

Cleanup:
kubectl delete namespace music-app

