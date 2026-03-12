sudo apt update -y && sudo apt upgrade -y
sudo apt install curl git make ca-certificates
#curl -fsSL https://get.docker.com | sh

sudo usermod -aG docker $USER

newgrp docker

sudo echo "127.0.0.1 rafaelro.42.fr" | sudo tee -a /etc/hosts

echo "Sucesso!"
