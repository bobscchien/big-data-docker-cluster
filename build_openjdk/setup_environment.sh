#!/bin/bash

dir_install=/usr/local

### Customized Setting

cat <<EOF >> /etc/bash.bashrc 

export TZ=Asia/Taipei
export LS_OPTIONS='--color=auto'
eval "$(dircolors)"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

export JAVA_HOME=$JAVA_HOME
EOF



### SSH Setting for Hadoop

mkdir -p /var/run/sshd
echo '/usr/sbin/sshd' >> ~/.bashrc
source ~/.bashrc

#echo 'PermitEmptyPasswords yes' >> /etc/ssh/sshd_config
#echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
#sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config
service ssh restart

mkdir -p ~/.ssh
chmod 700 ~/.ssh
cd ~/ && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cd ~/.ssh && cat id_rsa.pub >> authorized_keys

su - hadoop << EOF
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cd ~/ && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cd ~/.ssh && cat id_rsa.pub >> authorized_keys
EOF
