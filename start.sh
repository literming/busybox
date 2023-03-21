#!/bin/bash

# qemu version cannot too low

if [ $# -lt 1 ]
then
	echo "param error"
	echo "sh start.sh --help for detail"
	exit 0
fi

if test $1 = "base" 
then
	qemu-system-riscv64 \
		-nographic -machine virt \
		-kernel ./Image_v5.18 \
		-append "root=/dev/vda rw console=ttyS0" \
		-drive file=root.bin,format=raw,id=hd0 \
		-device virtio-blk-device,drive=hd0
elif test $1 = "debian" 
then
	echo ...
elif test $1 = "qemu-v1"
then
qemu-system-riscv64 \
    -nographic \
    -machine virt \
    -kernel Image_v5.18 \
    -append "root=/dev/vda ro console=ttyS0" \
    -drive file=busybox.bin,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -netdev user,id=eth0 \
    -device virtio-net-device,netdev=eth0
elif test $1 = "qemu-v2"
then
qemu-system-riscv64 \
    -nographic \
    -machine virt \
    -kernel ../busybox/Image_v5.18 \
    -append "root=/dev/vda ro console=ttyS0" \
    -drive file=../buildroot/output/images/rootfs.bin,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -netdev user,id=eth0 \
    -device virtio-net-device,netdev=eth0
elif test $1 = "--help" 
then
	echo "Usage"
	echo " sh start.sh [options]"
	echo "Options"
	echo " base: busybox on qemu riscv64 linux system"
	echo " qemu-v1: busybox on platform FPGA"
	echo " qemu-v2: busybox from buildroot"
	echo " help: print this page"	

else
	echo "parameter option error"
	echo "sh start.sh --help for help"
fi
