#!/bin/bash
# PulseAudio Volume Control Script

STEP=3
#MAXVOL=`pacmd list-sinks | grep "volume steps" | cut -d: -f2 | tr -d "[:space:]"`
MAXVOL=65537 # let's just assume this is the same all over

#SINK=`pactl list short sinks | grep -m1 RUNNING | cut -f1`
SINK=$( pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1 )
#SINK=0

#VOLPERC=`pactl list sinks | awk '/Volume: 0:/ {print substr($3, 1, index($3, "%") - 1)}' | head -n1`
#VOLPERC=`pactl list sinks | awk '/Volume: front-left:/ {print substr($5, 1, index($5, "%") - 1)}'`
#MUTED=($( pacmd list-sinks | grep -m1 muted | cut -d ' ' -f 2 ))
MUTED=$( pactl list sinks | grep '^[[:space:]]Mute:' | head -n $(( $SINK + 1 )) | tail -n 1 | awk 'NF>1{print $NF}' )
VOLPERC=$( pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' )

LIMITVOL=0 # default max-100%

# TODO
# Add support for sink# > 1
# parse for overlimit, sink, etc (link -parser- https://unix.stackexchange.com/a/321128) 

display(){
    if [[ "$MUTED" == "yes" ]]; then
        SYM='\U1F507'
    elif [ "$VOLPERC" -lt 1 ]; then
        SYM='\U1F507'
    elif [ "$VOLPERC" -lt 33 ]; then
        SYM='\U1F508'
    elif [ "$VOLPERC" -lt 66 ]; then
        SYM='\U1F509'
    else
        SYM='\U1F50A'
    fi
    echo "$SINK $(printf $SYM) ${VOLPERC}%"
}

up(){
    VOLSTEP="$(( $VOLPERC+$STEP ))";
}

down(){
    VOLSTEP="$(( $VOLPERC-$STEP ))";
}

max(){
    pacmd set-sink-volume $SINK $MAXVOL > /dev/null
}

min(){
    pacmd set-sink-volume $SINK 0 > /dev/null
}

overmax(){
    LIMITVOL=1
    if [ $VOLPERC -lt 100 ]; then
        max;
        exit 0;
    fi
    up
}

mute(){
    pacmd set-sink-mute $SINK 1 > /dev/null
}

unmute(){
    pacmd set-sink-mute $SINK 0 > /dev/null
}

toggle(){
    if [[ "$MUTED" == "no" ]]; then
        mute;
    else
        unmute;
    fi
}

case $1 in
    up)
        unmute;
        up;;
    down)
        unmute;
        down;;
    max)
        max
        exit 0;;
    min)
        min
        exit 0;;
    overmax)
        overmax;;
    toggle)
        toggle
        exit 0;;
    mute)
        mute;
        exit 0;;
    unmute)
        unmute;
        exit 0;;
    display)
        display;
        exit 0;;
    *)
        echo "Usage: `basename $0` [up|down|min|max|overmax|toggle|mute|unmute|display]"
        exit 1;;
    esac

VOLUME="$(( ($MAXVOL/100) * $VOLSTEP ))"

#echo "$VOLUME : $OVERMAX"

if [ $LIMITVOL = 0 ]; then
    if [ $VOLUME -gt $MAXVOL ]; then
        VOLUME=$MAXVOL
    elif [ $VOLUME -lt 0 ]; then
        VOLUME=0
    fi
fi

#echo "$VOLUME: $MAXVOL/100 * $VOLPERC+$VOLSTEP"
pacmd set-sink-volume $SINK $VOLUME > /dev/null

# VOLPERC=`pacmd list-sinks | grep "volume" | head -n1 | cut -d: -f3 | cut -d% -f1 | tr -d "[:space:]"`
#osd_cat -b percentage -P $VOLPERC --delay=1 --align=center --pos bottom --offset 50 --color=green&

