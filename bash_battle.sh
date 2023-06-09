#!/bin/bash

# Font styles
bold=$(tput bold)
underline=$(tput smul)
italic=$(tput sitm)
green=$(tput setaf 2)
red=$(tput setaf 160)
orange=$(tput setaf 214)
reset=$(tput sgr0)

getLine() {
printf "${red}${bold}***************************************************${reset}\n"
}

lineSpace() {
printf "${red}${bold}*                                                 *${reset}\n"
}

gameTitle() {
getLine
getLine
lineSpace
printf "${red}${bold}*${reset} ${green}${bold}                BASH BATTLE   ${reset}${red}${bold}                  *${reset}\n"
lineSpace
printf "${red}${bold}*${reset}        copyright - Joseph Johnston, 2022   ${red}${bold}     *${reset}\n"
lineSpace
getLine
getLine
}

gameOptions() {
# Game Options
echo ""
echo "Welcome Player. Please select your starting class:"
echo " 1 - Knight (HP: 20, ATTACK: 20, STAMINA: 20)"
echo " 2 - Prisoner (HP: 10, ATTACK: 4, STAMINA: 30)"
echo " 3 - Mage (HP: 15, ATTACK: 8, STAMINA: 20)"

read CLASS

case $CLASS in
	1)
		TYPE="Knight"
		MAXHP=20
		MAXATTACK=20
		MAXSTAMINA=20
		;;
	2)
		TYPE="Prisoner"
		MAXHP=10
		MAXATTACK=4
		MAXSTAMINA=30
		;;
	3)
		TYPE="Mage"
		MAXHP=15
		MAXATTACK=8
		MAXSTAMINA=20
		;;
esac

# Set game variables
MAXTURNS=10
RECOVERY=4
HPRECOVERY=4
FIGHTDAMAGE=5
FIGHTSTAMINA=2
RUNAWAY=1
TRAVELWEAR=2
STAGE=1
TRIPFLAG=true
PLAYER_DODGE=false
OPPONENT_DODGE=false
WIN=false

# Set player values
HP=$(( $MAXHP ))
STAMINA=$(( $MAXSTAMINA ))
ATTACK=$(( $MAXATTACK ))
TURNS=$(( $MAXTURNS ))
}

playerInfo() {
echo "You chose the $TYPE class. Your stats are:"
echo "      HP        - $HP"
echo "      Stamina   - $STAMINA"
echo "      Attack    - $ATTACK"
}

animation_ship() {
TIMER=6
echo "                   ||:>  "
echo "          =================== "
echo "          . .....     .......  "
echo "           . .....     .......' "
echo "           \  ::::::     ::::: \ "
echo "            |  ::::::     :::: | "
echo "  (%)       |  ::::::     :::: |    (%) "
echo "   /       /  ::::::     :::: /      \ "
echo "   \______ | :::::: ___  :::: |______/ "
echo "   ( . .   .. ..  ... ...  ..  . .   ) "
echo "   \ ( 0 ) ( 0 )  ( 0 )  ( 0 ) ( 0 ) / "
while [[ $TIMER -gt 0 ]]
do
   sleep 0.5
   printf "\r^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-"
   sleep 0.5
   printf "\r-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^"
   sleep 0.5
   TIMER=$(( $TIMER - 1 ))
done
printf "\r##########################################\n"
}

# Function to get player input to continue
get_player_input() {
echo "Press any key to continue."
read KEY
}

startMsg() {
getLine
echo "${red}${bold}*   Your ship has arrived at port, welcome!       *${reset}"
echo "${red}${bold}*   Your quest is to survive the trip home, but   *${reset}"
echo "${red}${bold}*   there will be perils along the way. BEWARE!   *${reset}"
echo "${red}${bold}*   Bandits, beasts, and the land itself has it   *${reset}"
echo "${red}${bold}*   out for you. Good luck on your journey!       *${reset}"
lineSpace
echo "${red}${bold}*   Your destination is only $TURNS trips away.       *${reset}"
echo "${red}${bold}*   So, let's begin...                            *${reset}"
getLine
echo ""
get_player_input
}

#
updateTripCounter() {
TURNS=$(( $TURNS - 1 ))
STAGE=$(( $STAGE + 1 ))
}

# Enforce maximum stat values
checkLimit() {
if [[ $STAMINA -gt $MAXSTAMINA ]]; then
	STAMINA=$(( $MAXSTAMINA ))
fi
if [[ $HP -gt $MAXHP ]]; then
	HP=$(( $MAXHP ))
fi
}

displayTurn() {
case $STAGE in
        1)
                LEVEL="## level-01 ##"
                MAPTOP="|  o  | x | x | x | x | x | x | x | x | x | HOME |"
                MAPMID="| /|\ | x | x | x | x | x | x | x | x | x | HOME |"
                MAPBOT="| / \ | x | x | x | x | x | x | x | x | x | HOME |"
                ;;
        2)
                LEVEL="level-02"
                MAPTOP="| x |  o  | x | x | x | x | x | x | x | x | HOME |"
                MAPMID="| x | /|\ | x | x | x | x | x | x | x | x | HOME |"
                MAPBOT="| x | / \ | x | x | x | x | x | x | x | x | HOME |"
                ;;
        3)
                LEVEL="level-03"
                MAPTOP="| x | x |  o  | x | x | x | x | x | x | x | HOME |"
                MAPMID="| x | x | /|\ | x | x | x | x | x | x | x | HOME |"
                MAPBOT="| x | x | / \ | x | x | x | x | x | x | x | HOME |"
                ;;
        4)
                LEVEL="level-04"
                MAPTOP="| x | x | x |  o  | x | x | x | x | x | x | HOME |"
                MAPMID="| x | x | x | /|\ | x | x | x | x | x | x | HOME |"
                MAPBOT="| x | x | x | / \ | x | x | x | x | x | x | HOME |"
                ;;
        5)
                LEVEL="level-05"
                MAPTOP="| x | x | x | x |  o  | x | x | x | x | x | HOME |"
                MAPMID="| x | x | x | x | /|\ | x | x | x | x | x | HOME |"
                MAPBOT="| x | x | x | x | / \ | x | x | x | x | x | HOME |"
                ;;
        6)
                LEVEL="level-06"
                MAPTOP="| x | x | x | x | x |  o  | x | x | x | x | HOME |"
                MAPMID="| x | x | x | x | x | /|\ | x | x | x | x | HOME |"
                MAPBOT="| x | x | x | x | x | / \ | x | x | x | x | HOME |"
                ;;
        7)
                LEVEL="level-07"
                MAPTOP="| x | x | x | x | x | x |  o  | x | x | x | HOME |"
                MAPMID="| x | x | x | x | x | x | /|\ | x | x | x | HOME |"
                MAPBOT="| x | x | x | x | x | x | / \ | x | x | x | HOME |"
                ;;
        8)
                LEVEL="level-08"
                MAPTOP="| x | x | x | x | x | x | x |  o  | x | x | HOME |"
                MAPMID="| x | x | x | x | x | x | x | /|\ | x | x | HOME |"
                MAPBOT="| x | x | x | x | x | x | x | / \ | x | x | HOME |"
                ;;
        9)
                LEVEL="level-09"
                MAPTOP="| x | x | x | x | x | x | x | x |  o  | x | HOME |"
                MAPMID="| x | x | x | x | x | x | x | x | /|\ | x | HOME |"
                MAPBOT="| x | x | x | x | x | x | x | x | / \ | x | HOME |"
                ;;
        10)
                LEVEL="level-10"
                MAPTOP="| x | x | x | x | x | x | x | x | x |  o  | HOME |"
                MAPMID="| x | x | x | x | x | x | x | x | x | /|\ | HOME |"
                MAPBOT="| x | x | x | x | x | x | x | x | x | / \ | HOME |"
                ;;
        11)
                LEVEL="Welcome home!"
                MAPTOP="|#######     o   @l    #######|"
                MAPMID="|#######    /|\_/|\    #######|"
                MAPBOT="|#######    / \ /_\    #######|"
		;;
esac

echo "${LEVEL}"
echo "${MAPTOP}"
echo "${MAPMID}"
echo "${MAPBOT}"
}

# Display player HUD
displayHUD() {
getLine
echo "Stats: | Health:"$HP" | Stamina:"$STAMINA" | Trips Left:"$TURNS" |"
getLine
echo "${red}${bold}**${reset} If Continue:    | If Rest:   | If Fight:      ${red}${bold}**${reset}"
lineSpace
echo "${red}${bold}**${reset} -"$TRAVELWEAR" Stamina      | +"$RECOVERY" Stamina | -"$FIGHTSTAMINA" Stamina (f) ${red}${bold}**${reset}"
echo "${red}${bold}**${reset} -0 HP           | +"$HPRECOVERY" HP      | -"$FIGHTDAMAGE" HP      (f) ${red}${bold}**${reset}"
echo "${red}${bold}**${reset} "$MAXSTAMINA" Max Stamina  | "$MAXHP" Max HP  | -"$RUNAWAY" Stamina (r) ${red}${bold}**${reset}"
getLine
}

# Get player response to enemy
getResponse() {
echo "Do you choose to run or fight? (r/f)"
read RESPONSE
if [[ $RESPONSE == r ]]; then
        STAMINA=$(( $STAMINA - $RUNAWAY ))
	echo "************************"
        echo "You escaped from danger."
else
	echo "************************"
        echo "Prepare for battle!"
fi
}

generateOpponent() {
OPPONENT=$(( $RANDOM % 3 + 1 ))
case $OPPONENT in
	1)
		OTYPE="Beast"
		OMAXHP=4
		OMAXATTACK=6
		;;
	2)
		OTYPE="Bandit"
		OMAXHP=10
		OMAXATTACK=4
		;;
	3)
		OTYPE="Drunkard"
		OMAXHP=2
		OMAXATTACK=2
		;;
esac

# Calculate opponent stats
TMPHP=$(( $RANDOM % $OMAXHP + 1 ))
TMPATTACK=$(( $RANDOM % $OMAXATTACK + 1 ))
}

# Function to animate player dodge
animate_player_dodge() {
echo "player dodge animation here"
sleep 1
}

# Function to animate player hit
animate_player_hit() {
echo "player hit animation here"
sleep 1
}

# Function to animate opponent dodge
animate_opponent_dodge() {
echo "opponent dodge animation here"
sleep 1
}

# Function to animate opponent hit
animate_opponent_hit() {
echo "opponent hit animation here"
sleep 1
}

# FUnction to animate fight victory
animate_win() {
echo "victory animation here"
sleep 1
}

# Function to animate fight defeat
animate_loss() {
echo "defeat animation here"
sleep 1
}

# Function to animate player runaway
animation_runaway() {
echo "runaway animation here"
sleep 1
}

# Function to simulate battle with opponent
readyRumble() {
ROUND=0
while [[ $HP -gt 0 && $STAMINA -gt 0 && $TMPHP -gt 0 ]]
do
ROUND=$(( ROUND+1 )) # Increment round counter
echo "***********************"
echo "   Round $ROUND. Fight!"
echo "***********************"
echo ""

get_player_input

DODGE=$(( $RANDOM % 2 )) # Calculate probability of dodge
if [[ $DODGE == 1 ]]; then
        PLAYER_DODGE=true
        animate_player_dodge
	echo "You dodged! No damage taken."
else
        PLAYER_DODGE=false
        HP=$(( $HP - $TMPATTACK ))
        animate_player_hit
	echo "You took $TMPATTACK damage!"
fi

get_player_input

DODGE=$(( $RANDOM % 3 )) # Calculate opponent probability of dodge
if [[ $DODGE == 1 ]]; then
        OPPONENT_DODGE=true
        animate_opponent_dodge
	echo "You missed! No damage to opponent."
else
	OPPONENT_DODGE=false
        TMPHP=$(( $TMPHP - $ATTACK ))
        animate_opponent_hit
	echo "You dealt $ATTACK damage! $OTYPE has $TMPHP remaining HP."
fi
echo " "
echo "** $TYPE Stats: |"$HP" Health | "$ATTACK" Attack | "$STAMINA" Stamina | **"
echo "** $OTYPE Stats:|"$TMPHP"HP | "$TMPATTACK" ATTACK | **"
echo " "
done
	STAMINA=$(( $STAMINA - $FIGHTSTAMINA ))
if [[ $HP -gt 0 && $STAMINA -gt 0 ]]; then
        WIN=true
        echo "VICTORIOUS! You defeated the $OTYPE."
        animate_win
else
	WIN=false
        echo "You died...what a pathetic loser!"
        animate_loss
fi
}

# An opponent is nearby! Fight or Flight?
strangerDanger() {
generateOpponent
echo "A $OTYPE approaches!"
echo "You determine the $OTYPE has $TMPHP HP and $TMPATTACK Attack."
getResponse
if [[ $RESPONSE == f ]]; then
        readyRumble
else
        animation_runaway
fi
}

# Generate random fight
detectOpponents() {
DETECT=$(( $RANDOM % 2 ))
if [[ $DETECT == 1 ]]; then
       	strangerDanger
else
        echo "Our journey is lucky. No opponents detected."
fi
}

# each step in journey will exhaust a certain amount of stamina
# depending on terrain type or location, a certain % of bandit attack
# some locations the travel is faster, but you only have so much time to get home
nextTrip() {
if [[ $TURNS -lt $MAXTURNS ]]; then
	echo "Continue journey, or rest? (c/r)"
	read DECISION
else
	echo "We've a long way to go, $TYPE."
        echo "Press c to continue."
        read DECISION
fi

if [[ $DECISION == c ]]; then
         STAMINA=$(( $STAMINA - $TRAVELWEAR ))
         detectOpponents
         TRIPFLAG=true
else
        STAMINA=$(( $STAMINA + $RECOVERY ))
	HP=$(( $HP + $HPRECOVERY ))
	checkLimit
        TRIPFLAG=false
fi
}

# Starting location always the same, but need alternate routes
# prompt user for routes to take, with some advice/info each route
# get user input and start journey
gameTitle
gameOptions
playerInfo
echo "Loading game ..."
sleep 2
get_player_input
clear
animation_ship
sleep 2
startMsg
clear
while [[ $HP -gt 0 && $STAMINA -gt 0 && $TURNS -gt 0 ]];
do
	displayHUD
        displayTurn
        nextTrip
        if [[ $TRIPFLAG = true ]]; then
                updateTripCounter
        fi
        get_player_input
        clear
done

if [[ $HP -gt 0 && $STAMINA -gt 0 ]]; then
	echo "Congratualtions, you made it home!"
        displayTurn
else
	echo "You lose! Game Over."
fi

exit
