
if [ $# -lt 1 ]
then
	echo "param error"
	echo "sh start.sh -help for detail"
	exit 0
fi

if test $1 = "base"
# CROSS_COMPILE=riscv64-unknown-linux-gnu- make defconfig
# CROSS_COMPILE=riscv64-unknown-linux-gnu- make menuconfig
# CROSS_COMPILE=riscv64-unknown-linux-gnu- make -j $(nproc)
then
    if [ -f root.bin ]; then
        echo "root.bin file already exist"
        mv root.bin root.bin_bak
        echo "move root.bin to root.bin_bak"
    fi

    dd if=/dev/zero of=root.bin bs=1M count=64
    mkfs.ext4 -F root.bin

    mkdir mnt
    sudo mount -o loop root.bin mnt

    cd mnt
    sudo mkdir -p bin etc dev lib proc sbin tmp usr usr/bin usr/lib usr/sbin boot
    sudo cp ../busybox bin
    sudo ln -s ../bin/busybox sbin/init
    sudo ln -s ../bin/busybox bin/sh
    sudo tree

    cd ..
    sudo umount mnt
    rmdir mnt
elif test $1 = "qemu-v1"
then
    CROSS_COMPILE=riscv64-linux-gnu- LDFLAGS=--static make defconfig
    if [ -f busybox.bin ]; then
        echo "warning: busybox.bin file already exist"
        sudo mv busybox.bin busybox.bin_bak
        echo "move busybox.bin to busybox.bin_bak"
    fi
    dd if=/dev/zero of=busybox.bin bs=1M count=1024
    sudo mkfs.ext4 busybox.bin

    if [ ! -d rootfs ]; then
        sudo mkdir rootfs
    fi

    sudo mount busybox.bin rootfs
    sudo CROSS_COMPILE=riscv64-linux-gnu- LDFLAGS=--static make install CONFIG_PREFIX=rootfs
    sudo mkdir -p rootfs/proc rootfs/sys rootfs/dev rootfs/boot
    sudo mkdir -p rootfs/etc
    sudo touch rootfs/etc/fstab
    sudo mkdir -p rootfs/etc/init.d

    sudo cp rcS rootfs/etc/init.d/rcS
    sudo chmod +x rootfs/etc/init.d/rcS
    
    sudo umount rootfs
fi


