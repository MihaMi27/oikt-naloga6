#!/bin/bash

# Ustvaril strukturo domačega uporabnika (podobno kot na Windows: Desktop, Documents, Downloads, Pictures, Videos…)
folders='Desktop Documents Downloads Pictures Videos'
for folder in $folders
do
    mkdir $folder
    echo "Narejena mapa $folder"
    # mkdir /home/$USER/$folder
done

# S FOR zanko ustvarite 5 map primer (folder1, folder2) z uporabo interpolacije nizov
for i in {1..5}
do
    mkdir "folder$i"
    echo "Narejena mapa folder$i"
done

# S FOR zanko nato dodajte vsaj 5 uporabnikov (z domačo mapo) v vaš sistem, ki jih boste prebrali iz lokalne datoteke IN dodajte uporabnike v sudoers skupino
wget -q -O users.txt "https://raw.githubusercontent.com/MihaMi27/oikt-naloga6/main/users.txt"
input=users.txt
while IFS= read -r username
do
        
    if grep $username /etc/passwd > /dev/null # exit status of previous command
    then
        echo "User $username already exists"
    else    
        useradd -G sudo -m $username
        echo "Created user $username"
    fi
done < "$input"

# Posodobite apt repozitorij z update in upgrade
if apt-get update
then
    apt-get upgrade -y
fi

# Naložite poljubna orodja, ki jih boste predvidoma uporabljali (ufw, git, nginx, net-tools)
apt-get install -y ufw git nginx net-tools

# Nato namestite tudi Docker, kot smo to počeli v 2. nalogi https://docs.docker.com/engine/install/ubuntu/
if apt-get install -y ca-certificates curl gnupg lsb-release
then
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Skripta je koncana"