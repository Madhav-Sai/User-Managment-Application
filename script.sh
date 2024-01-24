#! /bin/bash

add_user()
{
    if [ ! -e users.dat ]; then
        touch users.dat
    fi

    echo "Please provide detials to add user : "
    read -p "Enter the first name:" fname
    read -p "Enter the Last name :" lname
    read -p "Enter User ID:" uid
    count=$(cat users.dat | cut -d ":" -f 1 | grep -w $uid | wc -l)
    if [ $count -ne 0 ]; then
        echo "User id$uid already exits, we cant add user"
        echo
        return 1
    fi
    read -s -p "Enter the password:" pwd
    echo
    read -p "Retype the password:" cpwd
    if [ $pwd != $cpwd ]; then
        echo " password not matched please try again "
        echo
        return 2 
    fi
    read -p "Zipcode:" zipcode
    echo "$uid:$pwd:$fname:$lname:$zipcode" >> users.dat
    echo "user added sucessfully"
    echo echo 
}
search_user()
{
    read -p " Enter the uid:" uid
    count=$(cat users.dat | cut -d ":" -f 1 | grep -w $uid | wc -l)
    if [ $count -eq 0 ]; then
        echo " Used id:$uid does not exit, cannot find user"
        echo 
        return 3
    fi
    read -p "Enter the password": pwd
    count=$(cat users.dat | cut -d ":" -f 2 | grep -2 $pwd | wc -l)
    if [ $count -eq 0 ]; then
        echo " Invalid password, canot proced with this"
        echo 
        return 4
    fi
    while read line 
    do  
        fuid=$(echo $line | cut -d ":" -f1)
        fpwd=$(echo $line | cut -d ":" -f2)
        if [$uid = $fuid -a $ $pwd = $fpwd ]; then
            echo " The complete user information of the user is ..:"
            echo " UserID:$(echo $line | cut -d ":" -f 1)"
            echo " password :$(echo $line | cut -d ":" -f 2)"
            echo " First name:$(echo $line | cut -d ":" -f 3)"
            echo " last name :$(echo $line | cut -d ":" -f 4)"
            echo " Zipcode:$(echo $line | cut -d ":" -f 5)"
            echo 
            echo
            break
        fi
    done < users.dat
}
change_password()
{
    read -p " Enter the uid:" uid
    count=$(cat users.dat | cut -d ":" -f 1 | grep -w $uid | wc -l)
    if [ $count -eq 0 ]; then
            echo " Used id:$uid does not exit, Cannot change the password "
            echo 
        return 3
    fi
    read -p "Enter the password": pwd
    count=$(cat users.dat | cut -d ":" -f 2 | grep -2 $pwd | wc -l)
    if [ $count -eq 0 ]; then
            echo " Invalid password, Cannot change the password "
            echo 
        return 4
    fi
    while read line
    do 
        fuid=$(echo $line | cut -d ":" -f1 )
        fpwd=$(echo $line | cut -d ":" -f2 )
        if [ $fuid = $uid -a $pwd = $fpwd ]; then
            grep -v $line users.dat > temp.dat
            record=$line
            break
        fi
    done < users.dat
    mv temp.dat users.dat
    read -p " Enter the New password:" npwd
    uid=$(echo $record | cut -d ":" -f 1 )
    fname=$(echo $record | cut -d ":" -f3)
    lname=$(echo $record | cut -d ":" -f4)
    zipcode=$(echo $record | cut -d ":" -f5)
            echo "$uid:$npwd:$fname:$lname:$zipcode" >> users.dat
            echo "Password changed suscessfully"
            echo
            echo
}
delete_user()
{
     read -p " Enter the uid:" uid
    count=$(cat users.dat | cut -d ":" -f 1 | grep -w $uid | wc -l)
    if [ $count -eq 0 ]; then
            echo " Used id:$uid does not exit, Cannot change the password "
            echo 
            return 3
    fi
    read -p "Enter the password": pwd
    count=$(cat users.dat | cut -d ":" -f 2 | grep -2 $pwd | wc -l)
    if [ $count -eq 0 ]; then
            echo " Invalid password, Cannot change the password "
            echo 
        return 4
    fi
    while read line
    do 
        fuid=$(echo $line | cut -d ":" -f1 )
        fpwd=$(echo $line | cut -d ":" -f2 )
        if [ $fuid = $uid -a $pwd = $fpwd ]; then
            grep -v $line users.dat > temp.dat
            record=$line
            break
        fi
    done < users.dat
    mv temp.dat users.dat
        echo "User deleted sucessfully"
        echo
        echo 
}
show_all_user()
{
    echo "all Users Information "
    echo "****************************************"
    read -p " Enter the uid of admin:" uid
    count=$(cat users.dat | cut -d ":" -f 1 | grep -w $uid | wc -l)
    if [ $count -eq 0 ]; then
            echo " Used id:$uid does not exit, Cannot display users  "
            echo 
        return 3
    fi
    read -p "Enter the password of admin account ": pwd
    count=$(cat users.dat | cut -d ":" -f 2 | grep -2 $pwd | wc -l)
    if [ $count -eq 0 ]; then
            echo " Invalid password, Access denied  "
            echo 
        return 4
    fi
    cat users.dat
    echo
    echo "***************************************************"
}
users_count()
{
    count=$(cat users.dat | wc -l) 
    echo " The total Number of users:$count"
    echo
    
}




echo " Welcome To user managment application "
echo " ############################################"
while [ true ]
do
    echo "1. Add User"
    echo "2. Search For User"
    echo "3. Change Passsword"
    echo "4. Delete Users"
    echo "5. Show All Users"
    echo "6. Add Users count"
    echo "7. Add Exit"
    read -p "Enter your Choice [1|2|3|4|5|6|7]:" choice
    case $choice in 
        1)
            add_user
            ;;
        2)
            search_user
            ;;
        3)
            change_password
            ;;
        4) 
            delete_user
            ;;
        5)
            show_all_user
            ;;
        6)
            users_count
            ;;
        7)
            echo "Thanks for using the application...."
            exit 0
            ;;
        *)
            echo " Please try again my friend..."
esac
done
