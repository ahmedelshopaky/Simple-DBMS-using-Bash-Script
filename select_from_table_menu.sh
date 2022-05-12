#!/bin/bash

function selectFromTableMenu {
    echo "You are connected to table: $TableName.";
    echo "+-------------------------------+";
    echo "|          Select Menu          |";
    echo "+-------------------------------+";
    echo "|   1. Select All               |";
    echo "|   2. Select Row               |";
    echo "|   3. Select Column            |";
    echo "|   4. Go Back                  |";
    echo "|   5. Back to Main Menu        |";
    echo -e "+-------------------------------+\n";
    echo "PLEASE ENTER YOU CHOICE!";
    read -p "#? ";
    case $REPLY in
        1) selectAll
            ;;
        2) selectRow
            ;;
        3) selectColumn
            ;;
        4) clear;
            tablesMenu
            ;;
        5) clear;
            mainMenu
            ;;
        *) echo -e "INVALID INPUT!\n";
            tablesMenu
            ;;
    esac

}


function selectAll {
    clear;
    echo "Table Content:";
    echo "=================================";
    cat ./database/$DBName/$TableName/$TableName;
    echo -e "=================================\n";
    selectFromTableMenu;
}


function selectRow {
    clear;
    echo "ENTER ANY VALUE FROM THE RECORD YOU WANT TO SELECT!";
    read -p "#? " value;
    row=$(grep -w "$value" ./database/$DBName/$TableName/$TableName);
    if [[ ! -z $row ]]
    then
        echo;
        echo $row;
        echo -e "=================================\n";
    else
        echo -e "THE RECORD IS NOT FOUND.\n";
    fi
    selectFromTableMenu;
}


function selectColumn {
    clear;
    echo "Table Content:";
    echo "=================================";
    head -1 ./database/$DBName/$TableName/$TableName;
    echo -e "=================================\n";

    echo "ENTER THE NUMBER OF THE COLUMN YOU WANT TO SELECT!";
    read -p "#? " NumOfCol;
    
    column=$(cat ./database/$DBName/$TableName/$TableName | cut -d: -f$NumOfCol);
    if [[ ! -z $column ]]
    then
        echo;
        echo $column;
        echo -e "=================================\n";
    else
        echo -e "THE COLUMN IS NOT FOUND.\n";
    fi
    selectFromTableMenu;
}