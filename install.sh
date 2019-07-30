echo "";
echo "      			 _______       _____  ";
echo "      			|___  / |     / ____|";
echo "      			   / /| |    | (___  ";
echo "      			  / / | |     \___ \ ";
echo "       			 / /__| |____ ____) |";
echo "      			/_____|______|_____/ ";
echo "                                                       ";

echo "     Easy-to-configure archlinux + GNOME install script ";
echo "        for maximum comfort and minimum hassles ";
echo "";
echo "";

# syncing system datetime
timedatectl set-ntp true

# getting latest mirrors for italy and germany
wget -O mirrorlist "https://www.archlinux.org/mirrorlist/?country=DE&country=IT&protocol=https&ip_version=4"
sed -ie 's/^.//g' ./mirrorlist
mv ./mirrorlist /etc/pacman.d/mirrorlist

# updating mirrors
pacman -Syyy

# formatting disk
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/nvme0n1
  g # gpt partitioning
  n # new partition
    # default: primary partition
    # default: partition 1
  +500M # 500 mb on boot partition
    # default: yes if asked
  n # new partition
    # default: primary partition
    # default: partition 2
  +80G # 60 gb for root partition
    # default: yes if asked
  n # new partition
    # default: primary partition
    # default: partition 3
    # default: all space left of for home partition
    # default: yes if asked
  t # change partition type
  1 # selecting partition 1
  1 # selecting EFI partition type
  w # writing changes to disk
EOF

# outputting partition changes
fdisk -l /dev/nvme0n1

# partition filesystem formatting
yes | mkfs.fat -F32 /dev/nvme0n1p1
yes | mkfs.ext4 /dev/nvme0n1p2
yes | mkfs.ext4 /dev/nvme0n1p3

# disk mount
mount /dev/nvme0n1p2 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/nvme0n1p1 /mnt/boot
mount /dev/nvme0n1p3 /mnt/home

# pacstrap-ping desired disk
pacstrap /mnt base base-devel vim grub networkmanager \
git intel-ucode cpupower curl xorg xorg-server go\
xorg-xinit dialog firefox nvidia nvidia-settings wget \
gnome gnome-extra gdm neofetch

# generating fstab
genfstab -U /mnt >> /mnt/etc/fstab

# updating repo status
arch-chroot /mnt pacman -Syyy

# setting right timezone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime

# synchronizing timer
arch-chroot /mnt hwclock --systohc

# localizing system
arch-chroot /mnt sed -ie 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
arch-chroot /mnt sed -ie 's/#en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen

# generating locale
arch-chroot /mnt locale-gen

# setting system language
arch-chroot /mnt echo "LANG=en_US.UTF-8" >> /mnt/etc/locale.conf

# setting machine name
arch-chroot /mnt echo "leenooks" >> /mnt/etc/hostname

# setting hosts file
arch-chroot /mnt echo "127.0.0.1 localhost" >> /mnt/etc/hosts
arch-chroot /mnt echo "::1 localhost" >> /mnt/etc/hosts
arch-chroot /mnt echo "127.0.1.1 leenooks.localdomain leenooks" >> /mnt/etc/hosts

# making sudoers do sudo stuff without requiring password typing
arch-chroot /mnt sed -ie 's/# %wheel ALL=(ALL)/%wheel ALL=(ALL)/g' /etc/sudoers

# make initframs
arch-chroot /mnt mkinitcpio -p linux

# setting root password
echo "Insert password for root:"
arch-chroot /mnt passwd

# making user mattiazorzan
arch-chroot /mnt useradd -m -G wheel mattiazorzan

# setting mattaizorzan password
echo "Insert password for mattiazorzan:"
arch-chroot /mnt passwd mattiazorzan

# installing grub bootloader
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable

# making grub auto config
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

# changing governor to performance
arch-chroot /mnt echo "governor='powersave'" >> /mnt/etc/default/cpupower

# making services start at boot
arch-chroot /mnt systemctl enable cpupower.service
arch-chroot /mnt systemctl enable NetworkManager.service
arch-chroot /mnt systemctl enable gdm.service

# unmounting all mounted partitions
umount -R /mnt

# syncing disks
sync

echo ""
echo "INSTALLATION COMPLETE! enjoy :)"
echo ""

sleep 3
