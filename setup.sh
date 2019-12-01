#!/usr/bin/env bash

cat /dev/null > /home/ubuntu/.bash_history

history -c

sudo snap install google-cloud-sdk --classic

sudo apt-get -y update

sudo apt-get -y install awscli

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

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
