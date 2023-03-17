#!/bin/bash

# qemu version cannot too low

if [ $# -lt 1 ]
then
	echo "param error"
	echo "sh start.sh -help for detail"
	exit 0
fi

if test $1 = "base" 
then
	qemu-system-riscv64 -nographic -machine virt -kernel ./Image_v5.18 -append "root=/dev/vda rw console=ttyS0" -drive file=root.bin,format=raw,id=hd0 -device virtio-blk-device,drive=hd0
elif test $1 = "debian" 
then
	echo ...
elif test $1 = "-help" 
then
	echo "Usage"
	echo " sh start.sh [options]"
	echo "Options"
	echo " base: busybox on riscv64 linux system"
	echo " -help: print this page"	

else
	echo "parameter option error"
	echo "sh start.sh -help for help"
fi
