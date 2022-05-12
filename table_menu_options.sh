#!/bin/bash
source ./select_from_table_menu.sh

function tablesMenu {
    # DBName=$1;
    echo "You are connected to database: $DBName.";
    echo "+-------------------------------+";
    echo "|          Tables Menu          |";
    echo "+-------------------------------+";
    echo "|   1. Create Table             |";
    echo "|   2. List Tables              |";
    echo "|   3. Drop Table               |";
    echo "|   4. Insert into Table        |";
    echo "|   5. Select From Table        |";
    echo "|   6. Delete From Table        |";
    echo "|   7. Update Table             |";
    echo "|   8. Go Back                  |";
    echo -e "+-------------------------------+\n";
    echo "PLEASE ENTER YOU CHOICE!";
    read -p "#? ";
    case $REPLY in
        1) createTable
            ;;
        2) listTables
            ;;
        3) dropTable
            ;;
        4) insertIntoTable
            ;;
        5) selectFromTable
            ;;
        6) deleteFromTable
            ;;
        7) updateTable
            ;;
        8) clear;
            mainMenu
            ;;
        *) echo -e "INVALID INPUT!\n";
            tablesMenu
            ;;
    esac
    mainMenu;
}


function createTable {
    clear;
    # DBName=$1;
    MetaData="ColumnName:DataType:PrimaryKey";
    Data="";

    while true
    do
        echo "ENTER THE NAME OF THE TABLE YOU WANT TO CREATE!";
        read -p "#? " TableName;
        # TODO : RegExp
        if [[ ! $TableName =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]]
        then
            echo -e "INVALID INPUT!\n";
        else
            if [[ -d ./database/$DBName/$TableName ]]
            then
                echo -e "TABLE ALREADY EXISTS.\n";
                tablesMenu;
            else
                break;
                # while true
                # do
                #     # TODO: RegExp
                #     if [[ $TableName == [a-zA-Z_]* ]]
                #     then
                #         break;
                #     else
                #         echo "TABLE NAME MUST BEGIN WITH LETTER.";
                #         echo "Enter the name of the table you want to create AGAIN!";
                #         read -p "#? " TableName;
                #     fi
                # done
            fi
        fi
    done

    
    while true
    do
        echo "Number Of Columns?"
        read -p "#? " ColNum;
        if [[ $ColNum == *[!0-9]* ]]
        then
            echo -e "INVALID INPUT!\n";
        else
            break;
        fi
    done

    # Main Itiration
    # Get records from the user
    for ((c=1; c<=$ColNum; c++))
    do
        clear;
        echo "ENTER THE TABLE DATA (It is recommended that the primary key be in the first column).";
        while true
        do
            # TODO: Duplication Column Name Validation
            echo "Column $c Name?";
            read -p "#? " ColName;
            if [[ ! $ColName =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]]
            then
                echo -e "INVALID INPUT!\n";
            else
                break;
            fi
        done

        while true
        do
            echo "Primary Key [y/n]?";
            read -p "#? " pKey;
            case $pKey in
                [yY]*) PK="pk"; break
                    ;;
                [nN]*) PK=""; break
                    ;;
                *) echo -e "INVALID INPUT!\n"
                    ;;
            esac
        done
        
        echo "Datatype?";
        select var in "int" "text"
        do
            case $REPLY in
                1) DataType="int"; break
                    ;;
                2) DataType="text"; break
                    ;;
                *) echo -e "INVALID INPUT!\n"
                    ;;
            esac
        done
        MetaData+="\n$ColName:$DataType:$PK";
        Data+=$ColName;
        if [[ $c -lt $ColNum ]]
        then
            Data+=":";
        fi
    done
    mkdir ./database/$DBName/$TableName 2>> ./.error.log;
    touch ./database/$DBName/$TableName/$TableName 2>> ./.error.log;
    echo $Data >> ./database/$DBName/$TableName/$TableName;
    
    touch ./database/$DBName/$TableName/.$TableName 2>> ./.error.log;
    echo -e $MetaData >> ./database/$DBName/$TableName/.$TableName;

    if [[ $? -eq 0 ]]
    then
        echo -e "TABLE IS CREATED SUCCESSFULLY.\n";
    else
        echo -e "ERROR!\n";    
    fi


    tablesMenu;
}


function lsTable {
    if [[ $(ls ./database/$DBName | wc -l) -le 0 ]]
    then
        echo -e "THERE ARE NO TABLES.\n";
        tablesMenu;
    else
        echo "Available Tables:";
        ls ./database/$DBName | cat;
        echo;
    fi
}


function listTables {
    clear;
    lsTable;
    tablesMenu;
}


function dropTable {
    clear;
    lsTable;

    while true
    do
        echo "ENTER THE NAME OF THE TABLE YOU WANT TO DROP!";
        read -p "#? ";
        if [[ ! -z $REPLY ]]
        then
            break;
        fi
    done
    
    if [[ -d ./database/$DBName/$REPLY ]]
    then
        echo "SURE [y/n]?";
        read -p "#? " var;
        case $var in
            [yY]*) rm -r ./database/$DBName/$REPLY
                ;;
            [nN]*) echo -e "DROP IS CANCELED.\n"
                ;;
            *) echo -e "INVALID INPUT!\n"
                ;;
        esac
        if [[ $? -eq 0 ]]
        then
            echo -e "TABLE IS DROPPED SUCCESSFULLY.\n";
        else
            echo -e "Error!\n";
        fi
    else
        echo -e "YABLE DOES NOT EXIST.\n";
    fi

    tablesMenu;
}


function insertIntoTable {
    clear;
    lsTable;
    while true
    do
        echo "ENTER THE NAME OF THE TABLE YOU WANT TO INSERT INTO!";
        read -p "#? " TableName;
        if [[ -z $TableName ]]
        then
            echo -e "INVALID INPUT!\n";
        else
            break;
        fi
    done
    if [[ -d ./database/$DBName/$TableName ]]
    then
        Record="";
        ColumnsNumber=$(awk -F: 'NR==1{print NF}' ./database/$DBName/$TableName/$TableName);
        for ((i=1; i<=$ColumnsNumber; i++))
        do
            ColumnName=$(head -1 ./database/$DBName/$TableName/$TableName | cut -d ":" -f $i);
            echo "Enter the value of the column: $ColumnName!";
            read -p "#? " data;

            # DataType Validation
            DataType=$(awk -F: '{if(NR=='$(($i+1))') print $2}' ./database/$DBName/$TableName/.$TableName);
            # Integer Validation
            if [[ $DataType == "int" ]]
            then
                case $data in
                    *[!0-9]*) echo "INVALID INPUT! THE DATATYPE OF THIS COLUMN IS INT.";
                        i=$(($i-1));
                        continue
                        ;;
                esac
            fi

            # PK Validation
            PrimaryKey=$(awk -F: '{if(NR=='$(($i+1))') print $3}' ./database/$DBName/$TableName/.$TableName);
            if [[ $PrimaryKey == "pk" ]]
            then
                while true
                do
                    if [[ -z $data ]]
                    then
                        echo "IT IS A PRIMARY KEY. IT CANNOT BE NULL.";
                    else
                        if [[ ! -z $(cut -f $i -d ":" ./database/$DBName/$TableName/$TableName | grep -w $data) ]]
                        then
                            echo "THIS VAULE EXISTS. PK MUST BE UNIQUE.";
                        else
                            break;
                        fi
                    fi
                    echo "Enter the value of $ColumnName AGAIN!";
                    read -p "#? " data;
                done
            fi

            Record+=$data;
            if [[ $i -lt $ColumnsNumber ]]
            then
                Record+=":";
            fi
        done
        echo $Record >> ./database/$DBName/$TableName/$TableName;
        echo -e "THE RECORD IS INSERTED SUCCESSFULLY.\n";
    else
        echo -e "TABLE DOES NOT EXIST.\n";
    fi

    tablesMenu;
}


# function isPK {
#     ColNumber=$1;
#     if [[ $(awk -F: '{if(NR=='$(($ColNumber+1))') print $3}' ./database/$DBName/$TableName/.$TableName) == "pk" ]]
#     then
#         return 765;
#     fi
# }


function selectFromTable {
    clear;

    lsTable;
    while true
    do
        echo "ENTER THE NAME OF THE TABLE YOU WANT TO SELECT FROM!";
        read -p "#? " TableName;
        if [[ -z "$TableName" ]]
        then
            echo -e "INVALID INPUT!\n";
        else
            break;
        fi
    done


    if [[ -d ./database/$DBName/$TableName ]]
    then
        if [[ $(cat ./database/$DBName/$TableName/$TableName | wc -l) -le 1 ]]
        then
            echo -e "THE TABLE IS EMPTY\n";
        else
            echo -e "THE TABLE IS SELECTED SUCCESSFULLY.\n";
            selectFromTableMenu;
        fi
    else
        echo -e "THE TABLE IS NOT FOUND.\n";
    fi
    tablesMenu;
}


function deleteFromTable {
    clear;
    
    lsTable;
    while true
    do
        echo "ENTER THE NAME OF THE TABLE YOU WANT TO DELETE FROM!";
        read -p "#? " TableName;
        if [[ -z "$TableName" ]]
        then
            echo -e "INVALID INPUT!\n";
        else
            break;
        fi
    done

    if [[ -d ./database/$DBName/$TableName ]]
    then
        if [[ $(cat ./database/$DBName/$TableName/$TableName | wc -l) -le 1 ]]
        then
            echo -e "THE TABLE IS EMPTY\n";
        else
            # what if there is a duplication
            echo "ENTER ANY VALUE FROM THE RECORD YOU WANT TO DELETE (It is recommended to be the primary key).";
            read -p "#? " value;
            row=$(grep -w "$value" ./database/$DBName/$TableName/$TableName);
            if [[ ! -z $row ]]
            then
                while true
                do
                    echo "SURE [y/n]?";
                    read -p "#? " var;
                    case $var in
                        [yY]*) sed -i "/$value/d" ./database/$DBName/$TableName/$TableName;
                            row=$(echo $row | tr '\n' ',');
                            echo -e "THE RECORD IS DELETED SUCCESSFULLY.\n";
                            break
                            ;;
                        [nN*)] echo -e "DELETE IS CANCELED.\n"
                            ;;
                        *) echo -e "INVALID INPUT!\n"
                            ;;
                    esac
                done
            else
                echo -e "THE RECORD IS NOT FOUND.\n";
            fi
        fi
    else
        echo -e "THE TABLE IS NOT FOUND.\n";
    fi

    tablesMenu;
}


function updateTable {
    lsTable;
    while true
    do
        echo "ENTER THE NAME OF THE TABLE YOU WANT TO UPDATE!";
        read -p "#? " TableName;
        if [[ -z "$TableName" ]]
        then
            echo -e "INVALID INPUT!\n";
        else
            break;
        fi
    done
    
    if [[ -d ./database/$DBName/$TableName ]]
    then
        if [[ $(cat ./database/$DBName/$TableName/$TableName | wc -l) -le 1 ]]
        then
            echo -e "THE TABLE IS EMPTY\n";
        else
            echo;



        fi
    else
        echo -e "THE TABLE IS NOT FOUND.\n";
    fi
    tablesMenu;
}