#!/bin/bash

############################################################
# Check if user inputted a file                            #
############################################################
if [ -z "$1" ]
	then
	echo "You should input a file"
	exit 1;
fi 

############################################################
# Help                                                     #
############################################################
Help()
{
   # Displays Help
   echo "Options:"
   echo
   echo "---a  			- 	 --- Add task to the file.---"
   echo "---d			- 	 ---    Delete a task.    ---"
   echo "---vt     		-	 ---   View temp tasks.   ---"
   echo "---vo     		-	 --- View original tasks. ---"
   echo "---info			-	 ---        info.	  ---"
   echo "---s			-	 ---	    Save.	  ---"
   echo "---Ctrl+C		-	 ---  Exit without save.  ---"
   echo
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################
clear
Help
sleep 1;
############################################################
# Check if file exists or is a todo file                   #
############################################################
FILE="$1";
TMP=$(mktemp)
if [ -f "$FILE" ]; then
	if grep -Fxq "todo" $FILE
		then
		sleep 1;
		echo "-------------------------"
		echo "$FILE is a todo file."
		echo "-------------------------"
		sleep 1;
		cp "$FILE" "$TMP"
	else
		echo "**********************************************"
		echo "$FILE is not a todo file."
		echo "**********************************************"
		sleep 2;
		exit 1;
	fi
else
	touch $FILE
	echo "todo" > "$FILE";
	echo "-------------------------"
	echo "$FILE created as a todo."
	echo "-------------------------"
	sleep 1
	cp "$FILE" "$TMP"
fi
############################################################
# Receive input from user		                   #
############################################################
while true; 
	do
		echo "Enter Option(a|d|vt|vo|inf|s|Ctrl+C): "
		read option
			case $option in
				a)
				echo "Task: "
				read TASK
				echo "--- " "$TASK" >> "$TMP";
				clear
				echo "Task added";
				sleep 1;
				;;
				d)
				cat -n $TMP
				echo "Task Number: "
				read taskNum
				if [ $taskNum != 1 ];
				then
					d=d
					deleted=$(sed $taskNum$d "$TMP")
					echo -n "" > $TMP
					echo "$deleted" > "$TMP"
					echo "Task deleted"
					sleep 1
				else
					echo "You can't remove the todo badge. Null values don't do anything."
				fi
				;;
				vt)
				clear;
				echo "Temp todo list: "
				cat $TMP
				;;
				vo)
				clear;
				echo "Original todo list: "
				cat $FILE
				;;
				s)
				rm $FILE
				touch $FILE
				cp "$TMP" "$FILE"
				echo "-----------------------------------"
				echo "Changes saved to the original file"
				echo "-----------------------------------"
				sleep 1
				;;
				inf)
				clear
				Help
			esac
	done
