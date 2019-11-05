#!/bin/bash

adjust_dir=$1

cur_vol=`pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'`

echo $cur_vol

if [ "$adjust_dir" == "up" ]
then
  if [ "$cur_vol" -lt "100" ]
  then
    echo "Moving up"
    pactl -- set-sink-volume 0 +5%
  else
    echo "Already at 100"
  fi
else
  echo "Moving down"
  pactl -- set-sink-volume 0 -5%
fi
