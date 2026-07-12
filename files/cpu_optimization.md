# OPTIMIZATION WILL BE
* KERNEL REAL TIME (USING LOW LATENCY) & OVERCLOCK FREQUENCY (USING CPU POWER)
* SHIELDING PROCESS ( PROCESS SYSTEM AND PROCESS WILL BE SEPARATED USING CSET SHIELD)
* SETTING PROCESS (USING CSET CPU) AND LABELLING PROCESS TO BE USED ON SET CPU (USING TASKSET)

# INSTALLATION
```
apt update
```
```
sudo apt install linux-lowlatency linux-headers-lowlatency linux-tools-lowlatency linux-cloud-tools-lowlatency
```
```
apt install cset stress-ng
```
# CONFIGURING GRUB 
## To add menu on boot
```
sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' /etc/default/grub
```
## To give timeout in second
```
sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=15/' /etc/default/grub
```
## Upgrade the boot configuration
```
sudo update-grub
```
## Reboot to choose grub on low latency mode
```
reboot
```
## On reboot 
Choose : 
* Advanced options for Ubuntu
* Then, Ubuntu, with Linux Low latency
## When system is started,  check low latency kernel :
```
uname -r | grep lowlatency
```
## If you want to choose lowlatency as default boot :
```
sudo sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux '"$(uname -r)"'"/' /etc/default/grub
```
```
sudo update-grub
```
```
sudo reboot
```
# SEPARATION OF CPU
eg : 
* Total cpus : 12 cpus numbered 0-11
* system will be at 0-1 cpus; the rest will be shielding cpu will be at 2-11 named part_all
* the user cpu will be divided in two part :
* first part will be named part1 which is 2-6 cpus and the number of cpu is 5 named part1_number_cpu
* second part will be named part2 which is 7-11 cpus and the number of cpu is 5 named part2_number_cpu
```
part_all=2-11
```
```
part1=2-6
```
```
part1_number_cpu=5
```
```
part2=7-11
```
```
part2_number_cpu=5
```
# SHIELDING THE CPU OF ALL PART CPU
```
sudo cset shield --cpu=$part_all --kthread=on
```
```
sudo cset set --list --recurse
```
```
root
├── system   CPU 0-1
└── user     CPU 2-11
```

# DIVIDE THE SHIELDING CPU IN TWO PARTS
The process will be represented as cpu named organized on file : 
* the first part of cpu part is /user/cpu_part1
* the second part of cpu part is /user/cpu_part2
## Destroy all cpu part on shielding cpu
```
sudo cset set --destroy /user/cpu_part1
```
```
sudo cset set --destroy /user/cpu_part2
```
## Create all cpu part on shielding cpu
```
sudo cset set --set=/user/cpu_part1 --cpu=$part1
```
```
sudo cset set --set=/user/cpu_part2 --cpu=$part2
```
## Verify all cpu part on shielding cpu
```
sudo cset set --list --recurse
```
```
root
├── system          CPU 0-1
└── user            CPU 2-11
    ├── cpu_part1   CPU 2-6
    └── cpu_part2   CPU 7-11
```


# TEST
## Test for all cpu part on stress testing
```
cpupower frequency-set -g performance && \ 
sudo cset proc --set=/user/cpu_part1 --exec -- taskset -c $part1 stress-ng --cpu $part1_number_cpu --timeout 3000s
```
```
cpupower frequency-set -g performance && \ 
sudo cset proc --set=/user/cpu_part2 --exec -- taskset -c $part2 stress-ng --cpu $part1_number_cpu --timeout 3000s
```

## example
```
cpupower frequency-set -g performance && \
sudo cset proc --set=/user/cpu_part1 --exec -- taskset -c $part1 ./uhd_install.sh
```
# VERIFY IRQ
```
cat /proc/irq/122/smp_affinity
```
* CPU 0 only : 000000000001 so :  echo 1 | sudo tee /proc/irq/122/smp_affinity
* CPU 0 and CPU 1 : 000000000011 so :  echo 3 | sudo tee /proc/irq/122/smp_affinity
* CPU 0 and CPU 1 and CPU 2 : 000000000111 so :  echo 7 | sudo tee /proc/irq/122/smp_affinity
...
  
# Measuring
it's possible to measure: 
*  UL/DL throughput;
*  BER;
*  CPU utilization (mpstat -P ALL 1);
*  mpstat -P ALL 1
* pidstat -t
* htop
* /proc/interrupts
* cyclictest (si tu t'intéresses à la latence)
*  thread migrations (pidstat -t);
*  timing stability (for example, using cyclictest if you're looking for real-time behavior).
*  watch -n 0.5 'ps -eLo pid,tid,psr,comm | grep nr-softmodem'
