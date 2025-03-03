echo "deb [trusted=yes] http://10.10.10.58 stable main" | sudo tee /etc/apt/sources.list.d/goreadmin.list
sudo apt update
sudo apt install ssh-motd