#!/bin/bash

# This will do:
# Install docker, pyenv and docker-compose (if not installed)
# Set up 3 virtualenvs managed by pyenv: venv-agent, venv-manager, venv-common
# Clone halfstack(agent, manager, common, meta) repositories at folder $HOME/halfstack
# Deploy halfstack docker-compose (https://github.com/lablup/backend.ai/blob/master/docker-compose.halfstack.yml)
# This script is intended to be run inside:
# Debian-based OS (Debian/Ubuntu)

sudo apt update

if ! hash docker 2>/dev/null; then
    echo 'docker is not installed; installing...'
    sudo apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    if [ $(lsb_release  -is) == "Debian" ]; then
      sudo add-apt-repository -y \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable"
    else
      sudo add-apt-repository -y \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    fi
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
fi

if ! hash docker-compose 2>/dev/null; then
    echo 'docker-compose is not installed; installing...' 
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo usermod -aG docker $(whoami)
    newgrp docker
fi


sudo apt install -y python-pip python3-pip dpkg-dev \
		gcc \
		libbz2-dev \
		libc6-dev \
		libexpat1-dev \
		libffi-dev \
		libgdbm-dev \
		liblzma-dev \
		libncursesw5-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		make \
		tk-dev \
		wget \
		xz-utils \
		zlib1g-dev \
        libsnappy-dev

if ! hash pyenv 2>/dev/null; then
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
   
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

pyenv install 3.6.8
pyenv virtualenv 3.6.8 venv-manager
pyenv virtualenv 3.6.8 venv-agent

sudo mkdir -p /tmp/git-lfs-install
cd /tmp/git-lfs-install
sudo wget https://github.com/git-lfs/git-lfs/releases/download/v2.8.0/git-lfs-linux-amd64-v2.8.0.tar.gz 
sudo tar xvf git-lfs-linux-amd64-v2.8.0.tar.gz 
sudo bash install.sh
cd ../
sudo rm -rf git-lfs-install

cd $HOME
mkdir halfstack
cd halfstack

git clone https://github.com/lablup/backend.ai meta
cd meta
docker-compose -f docker-compose.halfstack.yml up -d 
cd ../
git clone https://github.com/lablup/backend.ai-common common
git clone https://github.com/lablup/backend.ai-manager manager
git clone https://github.com/lablup/backend.ai-agent agent
cd manager
pyenv local venv-manager
pip install -U pip setuptools
pip install -U -e .
pip install -U -e ../common
cp config/halfstack.toml ./manager.toml
cp config/halfstack.alembic.ini ./alembic.ini
sed -i "s/num-proc = 4/num-proc = $(nproc)/" manager.toml
python -m ai.backend.manager.cli etcd put config/redis/addr 127.0.0.1:8110
python -m ai.backend.manager.cli etcd put config/docker/registry/index.docker.io "https://registry-1.docker.io"
python -m ai.backend.manager.cli etcd put config/docker/registry/index.docker.io/username "lablup"
python -m ai.backend.manager.cli etcd rescan-images index.docker.io
mkdir -p "$HOME/vfroot/local"
python -m ai.backend.manager.cli etcd put volumes/_mount "$HOME/vfroot"
python -m ai.backend.manager.cli etcd put volumes/_default_host local
python -m ai.backend.manager.cli schema oneshot
python -m ai.backend.manager.cli fixture populate sample-configs/example-keypairs.json
python -m ai.backend.manager.cli fixture populate sample-configs/example-resource-presets.json

cd ..
cd agent
git lfs install
git lfs pull
pyenv local venv-agent
pip install -U pip setuptools
pip install -U -e .
pip install -U -e ../common
cp config/halfstack.docker.toml agent.toml

cd ..
echo "Installation Complete"