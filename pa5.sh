#!/bin/bash

##############################################################################################
# Patrick Tsai (No Partners) - PA5 - Due 11/29/2019 at 8am                           
#
# This program create travel reservations
# 1. Users enter their name
# 2. Users select where they want to depart from and what date
# 3. Users then select where they want to go and when their return date will be
# 4. Users then enter the number of bags they will be carrying
# 5. Reservations are saved in file res.txt
# 6. Multiple reservations by a person with the same name are flagged
#    and there is an option to save the old reservation or replace with the new reservation
#
##############################################################################################

declare -A places=(
[0]='"Place 0" "10" "02" '
[1]='"Place 1" "20" "04" '
[2]='"Place 2" "30" "06" '
[3]='"Place 3" "40" "08" '
[4]='"Place 4" "50" "10" '
[5]='"Place 5" "60" "12" '
[6]='"Place 6" "80" "14" '
)

placeCount=${#places[@]}

func_printPlacesFrom () {
echo 'from=$(zenity --list --column="Name" --column="Cost" --column="Time" \' > from
chmod 755 from

i=0
while [[ $i -lt $placeCount ]]
do
  echo -n "${places[$i]} " >> from
  i=$((i+1))
done

echo -n ")" >> from
}

func_printPlacesTo () {
echo 'to=$(zenity --list --column="Name" --column="Cost" --column="Time" \' > to
chmod 755 to

i=0
while [[ $i -lt $placeCount  ]]
do
  echo "${places[$i]}" > toHolder
  chmod 755 toHolder
  grep "$from" toHolder > /dev/null

  if [[ $? -eq 1 ]]
  then
    echo -n "${places[$i]} " >> to
    i=$((i+1))
  else
    i=$((i+1))  
  fi

done
echo -n ")" >> to
}


func_checkName () {
  grep "$name" res.txt > /dev/null
        if [[ $? -eq 0 ]]
        then
          zenity --warning --text="You have already made a reservation select OK to delete old reservation and keep new reservation. Or close box to keep old reservation" --no-wrap
          if [[ $? -eq 0 ]]
          then
            grep -v "$name" res.txt > res2.txt
            mv res2.txt res.txt
            echo "$name, $numBags, $departDate, $from, $returnDate, $to" >> res.txt
            zenity --info --text="You're reservation has been changed" --no-wrap
	     echo "Thank You $name"
	     echo "Your travel reservation to $to,"
	     echo "Departing from $from on $departDate"
	     echo "Returning on $returnDate"
	     echo "has been confirmed"
          elif [[ $? -eq 1  ]]            		  
          then
      		  zenity --info --text="You're old reservation has been kept" --no-wrap
          fi
        else
          echo "$name, $numBags, $departDate, $from, $returnDate, $to" >> res.txt
	  echo "Thank You $name"
	  echo "Your travel reservation to $to,"
	  echo "Departing from $from on $departDate"
	  echo "Returning on $returnDate"
	  echo "has been confirmed"
        fi
}


echo "Welcome to web travel"
echo "We are happy to help you make travel plans"
echo "Please enter information by following the prompts"


##############
# Enter Name #
##############

name=`zenity --entry --text="Enter Your Name" \
             --title="Travel Reservation" \
	     --entry-text="First and Last Name (if you have one)"`

#echo "return value after entering name: $?"
#echo "You entered first name: $name"


######################
# PLACE LEAVING FROM #
######################

func_printPlacesFrom
source ~/Desktop/cse224/PA5/from

#echo "return value from list \"FROM\" $?"
#echo "$from"


##################
# Departure Date #
##################

departDate=$(zenity --calendar --date-format=%m/%d/%Y)
#echo "$departDate"


#################
# PLACE FLYING TO
#################

func_printPlacesTo
source ~/Desktop/cse224/PA5/to

#echo "return value from list \"To\" $?"
#echo "$to"

##################
# Return Date #
##################
returnDate=$(zenity --calendar --date-format=%m/%d/%Y)
#echo "$returnDate"


##################
# Number of Bags #
##################

numBags=`zenity --entry --text="How many bags will you be checking" \
             --title="Number of bags" \
             --entry-text="Number of Bags"`

echo "return value after entering number of bags: $?"
echo "You entered this number of bags: $numBags"

func_checkName
