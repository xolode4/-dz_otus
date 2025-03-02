echo "deb [trusted=yes] https://gitlab.home.lcl/app/ssh-motd-deb/-/raw/main/repo stable main" | sudo tee /etc/apt/sources.list.d/goreadmin.list
sudo apt update
sudo apt install ssh-motd