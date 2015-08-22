#!/bin/sh
# Production Environment Optimization of Aerospike Database
# run as root
# reference: http://prod2.aerospike.com/docs/deploy_guides/aws/tune/

echo Applying Afterburner...
echo This modifies the processor affinities for network IRQs and also changes the thread settings in aerospike.conf file for performance.
./afterburner.sh

echo Determine IRQ numbers for eth0 - eth3
for i in {0..3}; do echo eth$i; grep eth$i-TxRx /proc/interrupts | awk '{printf "  %s\n", $1}'; done

# if the IRQs change you will have to manually change the settings below based
# on the eth irq number
# Set up the first two processor cores to get eth0 IRQs,
# the next two processor cores to get eth1 IRQs, etc.
echo Configure eth IRQs to CPU affinity
echo 1 > /proc/irq/115/smp_affinity
echo 2 > /proc/irq/116/smp_affinity
echo 4 > /proc/irq/118/smp_affinity
echo 8 > /proc/irq/119/smp_affinity
echo 10 > /proc/irq/121/smp_affinity
echo 20 > /proc/irq/122/smp_affinity
echo 40 > /proc/irq/124/smp_affinity
echo 80 > /proc/irq/125/smp_affinity

echo Check the affinities
for i in 115 116 118 119 121 122 124 125; do
echo -n "$i: ";
cat /proc/irq/$i/smp_affinity;
done

echo Starting Aerospike
service aerospike restart

echo Setting Process CPU Affinity to allow 2 cores for handling networking
as_pid=`cat /var/run/aerospike/asd.pid`
taskset -p fc $as_pid

echo Optimization Complete!
