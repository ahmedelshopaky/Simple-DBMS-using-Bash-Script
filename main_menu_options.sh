#!/bin/bash
source ./table_menu_options.sh

function createDB {
    clear;
    while true
    do
        echo "ENTER THE NAME OF THE DATABASE YOU WANT TO CREATE!";
        read -p "#? " name;
        if [[ $name =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]]
        then
            break;
        else
            echo -e "INVALID INPUT!\n";
        fi
    done
    if [[ -d ./database/$name ]]
    then
        echo -e "DATABASE ALREADY EXISTS.\n";
    else
        mkdir ./database/$name 2>> ./.error.log;
        if [ $? -eq 0 ]
        then
            echo -e "DATABASE IS CREATED SUCCESSFULLY.\n";
        else
            echo -e "ERROR!\n";
        fi
    fi
    mainMenu;
}


function lsDB {
    if [[ $(ls ./database | wc -l) -le 0 ]]
    then
        echo -e "THERE IS NO DATABASE.\n";
        mainMenu;
    else
        echo "AVAILABLE DATABASES:";
        ls ./database | cat;
        echo;
    fi
}


function listDB {
    clear;
    lsDB;
    mainMenu;
}


function connectDB {
    clear;
    lsDB;

    while true
    do
        echo "ENTER THE NAME OF THE DATABASE YOU WANT TO SELECT!";
        read -p "#? " DBName;
        if [[ -z "$DBName" ]]
        then
            echo -e "INVALID INPUT!\n";
        else
            break;
        fi
    done
    
    if [[ -d ./database/$DBName ]]
    then
        echo -e "DATABASE IS SELECTED SUCCESSFULLY.\n";
        tablesMenu;
    else
        echo -e "DATABASE DOES NOT EXIST.\n";
    fi
    mainMenu;
}


function dropDB {
    clear;
    lsDB;

    while true
    do
        echo "ENTER THE NAME OF THE DATABASE YOU WANT TO DROP!";
        read -p "#? " DBName;
        if [[ -z "$DBName" ]]
        then
            echo -e "INVALID INPUT!\n";
        else
            break;
        fi
    done
    
    if [[ -d ./database/$DBName ]]
    then
        echo "SURE [y/n]?";
        read -p "#? " var;
        case $var in
            [yY]*) rm -r ./database/$DBName 2>> ./.error.log;
                if [[ $? -eq 0 ]]
                then
                    echo -e "DATABASE IS DROPPED SUCCESSFULLY.\n";
                else
                    echo -e "ERROR!\n";
                fi
                ;;
            [nN]*) echo -e "DROP IS CANCELED.\n"
                ;;
            *) echo -e "INVALID INPUT!\n"
                ;;
        esac
    else
        echo -e "DATABASE DOES NOT EXIST.\n";
    fi
    mainMenu;
}