
# CROSS_COMPILE=riscv64-unknown-linux-gnu- make defconfig
# CROSS_COMPILE=riscv64-unknown-linux-gnu- make menuconfig
# CROSS_COMPILE=riscv64-unknown-linux-gnu- make -j $(nproc)

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


