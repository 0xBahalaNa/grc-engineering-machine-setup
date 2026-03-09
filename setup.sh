#!/bin/bash

# Development essentials
sudo dnf install -y \
  curl \
  gcc \
  gcc-c++ \
  git \
  gnupg2 \
  htop \
  jq \
  kernel-devel \
  make \
  openssl \
  python3-devel \
  python3-pip \
  ShellCheck \
  tmux \
  tree \
  unzip \
  vim \
  wget \
  yq \
  zip

# GitHub CLI (Fedora has an official repo)
sudo dnf install -y 'dnf-command(config-manager)'
sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install -y gh

# AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# Terraform
sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf install -y terraform

# OPA
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static
chmod 755 opa
sudo mv opa /usr/local/bin/

# Conftest (OPA-based config testing)
CONFTEST_VER=$(curl -s https://api.github.com/repos/open-policy-agent/conftest/releases/latest | jq -r .tag_name | sed 's/v//')
curl -L -o conftest.tar.gz "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VER}/conftest_${CONFTEST_VER}_Linux_x86_64.tar.gz"
tar xzf conftest.tar.gz conftest
sudo mv conftest /usr/local/bin/
rm conftest.tar.gz

# Trivy (Aqua Security repo)
cat << 'EOF' | sudo tee /etc/yum.repos.d/trivy.repo
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF
sudo dnf install -y trivy

# tfsec (now part of Aqua but still a separate binary)
TFSEC_VER=$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest | jq -r .tag_name)
curl -L -o tfsec "https://github.com/aquasecurity/tfsec/releases/download/${TFSEC_VER}/tfsec-linux-amd64"
chmod 755 tfsec
sudo mv tfsec /usr/local/bin/

# Checkov (Python package)
pip install checkov --break-system-packages

# Podman (Fedora ships this natively)
sudo dnf install -y podman podman-compose

# VMware guest tools
sudo dnf install -y open-vm-tools open-vm-tools-desktop

for cmd in git gh aws terraform opa conftest trivy tfsec checkov podman; do
  echo "$cmd: $(command -v $cmd && echo 'OK' || echo 'MISSING')"
done
