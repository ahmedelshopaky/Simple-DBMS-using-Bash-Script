##
# Bash Shell Script Database Management System (DBMS) Project.
# Main File
# 20.01.2022
# Author : Ahmed Elshopaky
##
#!/bin/bash
source ./main_menu_options.sh;
mkdir database 2>> ./.error.log;
clear;
echo "HELLO THERE!";
echo -e "Weolcome to Bash Shell Script Database Management System (DBMS):\n";
echo -e "The Project aim to develop DBMS, that will enable users to\nstore and retrieve the data from Hard-disk.\n";
echo "The Project Features:";
echo -e "The Application will be CLI Menu based app, that will provide\nto user this Menu items:\n";
echo "Main Menu:";
echo "- Create Database";
echo "- List Databases";
echo "- Connect To Databases";
echo -e "- Drop Database\n";
function mainMenu {
	echo "+-------------------------------+";
	echo "|           Main Menu           |";
	echo "+-------------------------------+";
	echo "|   1. Create Database          |";
    echo "|   2. List Database            |";
    echo "|   3. Connect To Database      |";
    echo "|   4. Drop Database            |";
    echo "|   5. Exit                     |";
	echo -e "+-------------------------------+\n";
	echo "PLEASE ENTER YOU CHOICE!";
	read -p "#? ";
	
	case $REPLY in
		1) createDB
			;;
		2) listDB
			;;
		3) connectDB
			;;
		4) dropDB
			;;
		5) echo -e "Bye!\n";
			exit
			;;
		*) echo -e "INVALID INPUT!\n";
			mainMenu
			;;
	esac
}
mainMenu;