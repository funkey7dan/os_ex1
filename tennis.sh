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
            if [[ $prevState -eq -1 ]]
            then
            echo " |       |       #   O   |       | " 
            state=1
            elif [[ $prevState -eq 0 ]]
            then
            echo " |       |       O       |       | " 
            else echo " |       |   O   #       |       | "
            state=-1
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
    if   [[ $2 -gt $1 ]] # player 2 (right hand) scored higher
    then
    prevState=$state
    if [[ $state -ge 0 ]] # if the ball is in the right court or on the net, it goes to the first part of player 1
    then
    state=-1
    else
    let "state-=1" #otherwise it's already at the losing players court, and we push it deeper
    fi

    elif [[ $1 -gt $2 ]] # player 1 (left hand) scored higher
    then
    prevState=$state
    if [[ $state -le 0 ]] # if the ball is in the left court or on the net, it goes to the first part of player 2
    then
    state=1
    else
    let "state+=1" #otherwise it's already at the losing players court, and we push it deeper
    fi
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
    return

    elif [[ $player2 -le 0 && $player1 -le 0 ]]
    then
    case $state in
    -3|-2|-1)
    echo "PLAYER 2 WINS !"
    ;;
    3|2|1)
    echo "PLAYER 1 WINS !"
    ;;
    0)
    echo "IT'S A DRAW !"
    ;;
    esac
    end=true
    return

    else
    return
    fi
    ;;
    esac
}

### 'main' loop of the script
init
while : ; do
checkWinCond
if [[ $end = "true" ]]; then break ;fi
playTurn
done
