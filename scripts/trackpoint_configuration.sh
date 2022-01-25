#echo -n 254 > /sys/devices/platform/i8042/serio1/serio2/speed
#echo -n 254 > /sys/devices/platform/i8042/serio1/serio2/sensitivity
#echo -n 10 > /sys/devices/platform/i8042/serio1/serio2/inertia

echo -n 255 /sys/devices/platform/i8042/serio1/sensitivity
DEVICE_ID=`xinput | grep -i trackpoint | awk -F'\t' '{print $2}' | grep -Eo '[0-9]{1,}'`
xinput --set-prop $DEVICE_ID 'libinput Accel Speed' 1

