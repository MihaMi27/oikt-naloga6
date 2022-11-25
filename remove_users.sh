wget -O users.txt "https://raw.githubusercontent.com/MihaMi27/oikt-naloga6/main/users.txt"
input=users.txt
while IFS= read -r username
do

    if grep $username /etc/passwd > /dev/null # exit status of previous command
    then
        deluser --remove-home $username
        echo "Removed user $username"        
    else
        echo "User $username doesn't exist"
    fi
done < "$input"