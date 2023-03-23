
if [ $# -lt 1 ]; then
    echo "param error, please input the parition path to mount"
    exit
fi
PART=$1

read -p "it is going to mkfs.ext4 $PART, yes or not ? " OPTTION
if test $OPTTION = "y"
then
    sudo mkfs.ext4 $PART
else
    echo "exit"
    exit
fi

CROSS_COMPILE=riscv64-linux-gnu- LDFLAGS=--static make defconfig

if [ ! -d rootfs ]; then
    sudo mkdir rootfs
fi

sudo mount $PART rootfs
sudo CROSS_COMPILE=riscv64-linux-gnu- LDFLAGS=--static make install CONFIG_PREFIX=rootfs
sudo mkdir -p rootfs/proc rootfs/sys rootfs/dev rootfs/boot
sudo mkdir -p rootfs/etc
sudo touch rootfs/etc/fstab
sudo mkdir -p rootfs/etc/init.d

sudo cp rcS rootfs/etc/init.d/rcS
sudo chmod +x rootfs/etc/init.d/rcS

sudo umount rootfs