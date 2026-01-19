#!/bin/sh

# little Cortex-A55: CPU0-CPU3 Off
for i in 0 1 2 3; do
  echo 0 > /sys/devices/system/cpu/cpu$i/online
done

# big Cortex-A55: CPU4 On, CPU5-CPU7 Off
echo 1 > /sys/devices/system/cpu/cpu4/online
for i in 5 6 7; do
  echo 0 > /sys/devices/system/cpu/cpu$i/online
done

# 408000 672000 840000 1008000 1200000 1344000 1488000 1584000 1680000 1800000 1992000 2088000 2160000
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo 1200000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo 2160000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
