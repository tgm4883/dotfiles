#!/bin/sh

# Get out of town if something errors
# set -e

# Get info on the monitors
DP1_STATUS=$(</sys/class/drm/card0/card0-DP-1/status )  
DP3_STATUS=$(</sys/class/drm/card0/card0-DP-3/status )  
HDMI_STATUS=$(</sys/class/drm/card0/card0-HDMI-A-1/status )  


DP1_ENABLED=$(</sys/class/drm/card0/card0-DP-1/enabled)  
DP3_ENABLED=$(</sys/class/drm/card0/card0-DP-3/enabled)  
HDMI_ENABLED=$(</sys/class/drm/card0/card0-HDMI-A-1/enabled)  


# Check to see if our state log exists
if [ ! -f /tmp/monitor ]; then  
    touch /tmp/monitor
    STATE=5
else  
    STATE=$(</tmp/monitor)
fi

# The state log has the NEXT state to go to in it

# If monitors are disconnected, stay in state 1
if [ "disconnected" == "$HDMI_STATUS" -a "disconnected" == "$DP1_STATUS" -a "disconnected" == "$DP3_STATUS" ]; then  
   STATE=1
fi

if [ `hostname` == 'ng10887-lt' ]; then
    case $STATE in  
        1)
        # laptop is standalone
        /usr/bin/xrandr --output eDP-1 --auto --output DP-1-1 --off
        STATE=2
        ;;
        2)
        # LVDS is on, projectors are connected but inactive
        /usr/bin/xrandr --output DP-1-1 --auto --output eDP-1 --off
        STATE=1 
        ;;
        3)
        # LVDS is off, projectors are on
        if [ "connected" == "$HDMI_STATUS" ]; then
            /usr/bin/xrandr --output LVDS-1 --off --output HDMI-1 --auto
            TYPE="HDMI"
        fi
        /usr/bin/notify-send -t 5000 --urgency=low "Graphics Update" "Switched to $TYPE"
        STATE=4
        ;;
        4)
        # LVDS is on, projectors are mirroring
        if [ "connected" == "$HDMI_STATUS" ]; then
            /usr/bin/xrandr --output LVDS-1 --auto --output HDMI-1 --auto
            TYPE="HDMI"
        fi
        /usr/bin/notify-send -t 5000 --urgency=low "Graphics Update" "Switched to $TYPE mirroring"
        STATE=5
        ;;
        5) 
        # LVDS is on, projectors are extending
        if [ "connected" == "$HDMI_STATUS" ]; then
            /usr/bin/xrandr --output LVDS-1 --auto --output HDMI-1 --auto --left-of LVDS-1
            TYPE="HDMI"
        fi
        /usr/bin/notify-send -t 5000 --urgency=low "Graphics Update" "Switched to $TYPE extending"
        STATE=2
        ;;
        *)
        # Unknown state, assume we're in 1
        STATE=1 
    esac    

    echo $STATE > /tmp/monitor 
fi
