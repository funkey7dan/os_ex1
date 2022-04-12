#!/bin/bash
#Daniel Bronfman ***REMOVED***


player1=50
player2=50
prevState=0
state=0
end=false


function init(){
    echo " Player 1: ${player1}         Player 2: ${player2} "
    echo " --------------------------------- "
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    echo " |       |       O       |       | "
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    echo " --------------------------------- "
}

#give state via argument: drawBoard ${gameState} ${player1 points} ${player2 points}
function drawBoard () {
    echo " Player 1: ${player1}         Player 2: ${player2} "
    echo " --------------------------------- "
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    case "$1" in
        0)
            if [[ $prevState -eq -1 ]]; then echo " |       |       #   O   |       | " 
            else echo " |       |   O   #       |       | "
            fi
            ;;
        -3)
            echo "O|       |       #       |       | "
        ;;
        -2)
            echo " |   O   |       #       |       | "
        ;;
        -1)
            
            echo " |       |   O   #       |       | "
            
        ;;
        
        1)
            echo " |       |       #   O   |       | "
            
        ;;
        2)
            
            echo " |       |       #       |   O   | "
            
        ;;
        3)
            
            echo " |       |       #       |       |O"
            
        ;;
    esac
    echo " |       |       #       |       | "
    echo " |       |       #       |       | "
    echo " --------------------------------- "
}


function checkState() {
    let "player1-=$1"
    let "player2-=$2"
    if   [[ $2 -gt $1 ]]
    then
    prevState=$state
    let "state-=1"
    
    elif [[ $1 -gt $2 ]]
    then
    prevState=$state
    let "state+=1"

    fi
}

function playTurn() {
    # do-while loop imitation

    while : ; do
        echo -n "PLAYER 1 PICK A NUMBER: " ; read -s num1;
        echo 
        if [[  ($num1 =~ ^[0-9]+$) && $num1 -le $player1 ]] ;then break ;fi
        echo "NOT A VALID MOVE !"
    done

    while : ; do
        echo -n "PLAYER 2 PICK A NUMBER: " ;read -s num2;
        echo 
        if [[  ($num2 =~ ^[0-9]+$) && $num2 -le $player2 ]] ;then break ;fi
        echo "NOT A VALID MOVE !"
    done
    checkState $num1 $num2
    drawBoard $state $player1 $player2
    echo -e "       Player 1 played: ${num1}\n       Player 2 played: ${num2}\n\n"
   
}

function checkWinCond() {
    case $state in
    -3)
    echo "PLAYER 2 WINS !"
    end=true
    return
    ;;
    3)
    echo "PLAYER 1 WINS !"
    end=true
    return
    ;;
    *)
    if [[ $player1 -le 0 && $player2 -gt 0 ]]
    then
    echo "PLAYER 2 WINS !"
    end=true
    return

    elif [[ $player2 -le 0 && $player1 -gt 0 ]]
    then
    echo "PLAYER 1 WINS !"
    end=true
    echo $end
    return

    elif [[ $player2 -le 0 && $player1 -le 0 ]]
    then
    echo "IT'S A DRAW !"
    end=true
    return

    else
    return
    fi
    ;;
    esac
}

init
while : ; do
checkWinCond
if [[ $end = "true" ]]; then break ;fi
playTurn
done
