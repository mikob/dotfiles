#echo -n 254 > /sys/devices/platform/i8042/serio1/serio2/speed
#echo -n 254 > /sys/devices/platform/i8042/serio1/serio2/sensitivity
#echo -n 10 > /sys/devices/platform/i8042/serio1/serio2/inertia

echo -n 255 /sys/devices/platform/i8042/serio1/sensitivity
xinput --set-prop 18 'libinput Accel Speed' 1

