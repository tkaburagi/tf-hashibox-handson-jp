#!/usr/bin/env bash

# sudo docker rm b9358e705fcf67894b43d28b742248137abd129642b756eccba13582cdef7da9

cat /dev/null > /home/ubuntu/.bash_history

echo 'history -c' >> /home/ubuntu/.bash_logout

### gcloud, aws, az
sudo snap install google-cloud-sdk --classic
sudo snap install jq
sudo apt-get -y update
sudo apt-get -y install wget
sudo apt-get -y install awscli
sudo apt-get -y install unzip
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

### Docker
sudo apt-get -y install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg-agent \
     software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

### MYSQL Clients
sudo apt-get -y install mysql-client-core-5.7

### Installing Java 8
#sudo apt-get -y install openjdk-8-jdk

### HashiStack
wget "${vault_url}" -O /home/ubuntu/vault.zip
wget "${consul_url}" -O /home/ubuntu/consul.zip
wget "${nomad_url}" -O /home/ubuntu/nomad.zip
wget "${terraform_url}" -O /home/ubuntu/terraform.zip

unzip /home/ubuntu/vault.zip -d /home/ubuntu
unzip /home/ubuntu/consul.zip -d /home/ubuntu
unzip /home/ubuntu/nomad.zip -d /home/ubuntu
unzip /home/ubuntu/terraform.zip -d /home/ubuntu

chmod +x /home/ubuntu/vault
chmod +x /home/ubuntu/consul
chmod +x /home/ubuntu/nomad
chmod +x /home/ubuntu/terraform

mv /home/ubuntu/vault /usr/local/bin/
mv /home/ubuntu/consul /usr/local/bin/
mv /home/ubuntu/nomad /usr/local/bin/
mv /home/ubuntu/terraform /usr/local/bin/

rm /home/ubuntu/*.zip

### Vault License
echo ${lic} > /home/ubuntu/vault-license

### Nomad License
echo ${nomadlic} > /home/ubuntu/nomad-license

### SSH Setting
echo "ubuntu:${ubuntu_password}" | sudo chpasswd

cat << EOF > /etc/ssh/sshd_config
PubkeyAuthentication no
PasswordAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem	sftp	/usr/lib/openssh/sftp-server
EOF

cat << EOF > /etc/sudoers
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults	env_reset
Defaults	mail_badpass
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root	ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo	ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d
ubuntu	ALL=(ALL)       ALL
EOF

sudo service sshd restart

exit
