#!/bin/bash

function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] -d    : copy all with screen (e,g,gd,p)"
    echo " [0] --el  : electrons"
    echo " [0] --g   : gammas"
    echo " [0] --gd  : gamms diffuse"
    echo " [0] --p   : protons"
    echo " [0] --del : del screens"
    echo " [0] -c    : clean"
    echo " [0] -h    : print help"
}

fullpathhome="~"
fullpath="~"
usern="user"
server="login"
_nsb_1x="_nsb_1x"

function rsync_data_sh {
    particle=$1
    echo "rsync -avzh $fullpathhome/$particle$_nsb_1x/root/ $usern@$server:$fullpath/$particle/." >> rsync_$particle.log
    rsync -avzh $fullpathhome/$particle'_nsb_1x'/root/ $usern@$server:$fullpath/$particle/. | tee -a rsync_$particle.log
}

if [ $# -eq 0 ] 
then
    printHelp
else
    if [ "$1" = "-d" ]; then
	array=( "--el" "--g" "--gd" "--p" )
	for ii in "${array[@]}"; do
	    screenName="scrn$ii"
            echo $screenName
            screen -S $screenName -L -d -m ./${0} $ii;
	done
	#./${0} $ii
    elif [ "$1" = "--el" ]; then
	particle="electron"
	rsync_data_sh $particle
    elif [ "$1" = "--g" ]; then
	particle="gamma"
	echo "rsync -avzh $fullpathhome/$particle$_nsb_1x/root/ $usern@$server:$fullpath/$particle/." >> rsync_$particle.log
	rsync -avzh $fullpathhome/$particle'_on_nsb_1x'/root/ $usern@$server:$fullpath/$particle/. | tee -a rsync_$particle.log
    elif [ "$1" = "--gd" ]; then
	particle="gamma_diffuse"
	rsync_data_sh $particle
    elif [ "$1" = "--p" ]; then
	particle="proton"
	rsync_data_sh $particle
    elif [ "$1" = "--del" ]; then
	screen -ls
	echo "screen -X -S <screenID> -X quit"
	echo "screen -wipe"
	echo "screen -ls | grep Detached | awk '{print $1}' | xargs -I{} screen -X -S {} quit"
	screen -ls | grep Detached | awk '{print $1}' | xargs -I{} screen -X -S {} quit
    elif [ "$1" = "-c" ]; then
	rm -rf screenlog.0 rsync_proton.log rsync_gamma_diffuse.log rsync_gamma.log rsync_electron.log
    elif [ "$1" = "-h" ]; then
        printHelp
    else
        printHelp
    fi
fi
