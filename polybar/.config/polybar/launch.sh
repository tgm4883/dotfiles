#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
if [ `hostname` == 'ng10887-lt' ]; then
    nohup polybar -c ~/.config/polybar/config.laptop topbar > /dev/null 2>&1 &
    nohup polybar -c ~/.config/polybar/config.laptop bottombar > /dev/null 2>&1 &
elif [ `hostname` == 'thomas-surface-pro-4' ]; then
    nohup polybar -c ~/.config/polybar/config.surfacepro topbar > /dev/null 2>&1 &
    nohup polybar -c ~/.config/polybar/config.surfacepro bottombar > /dev/null 2>&1 &
else
    nohup polybar -c ~/.config/polybar/config.desktop topbar > /dev/null 2>&1 &
    nohup polybar -c ~/.config/polybar/config.desktop bottombar > /dev/null 2>&1 &
fi
