#!/bin/bash

two_tera_over() {
    echo -e "d\nd\nd\nd\nd\nd\nw" >> fdisk.delete
    echo -e "mklabel gpt\nyes\nmkpart primary 1 100%\nprint\nquit" >> parted.input

    echo -e "*******file making success *******\n"
    fdisk "$1" < fdisk.delete > /dev/null
    parted "$1" < parted.input > /dev/null

    echo -e "*******patitining*******\n"
    mkfs.ext4 "$1"1

    if [ -d "/cache$2" ]; then
        echo -e "*******/cache$2 already exist ********\n"
    else
        echo -e "*******cache directory making ********\n"
        mkdir /cache$2
    fi

    echo -e "******* mounting *******\n"
    echo -e "${1}1    /cache$2    ext4    defaults,noatime,data=writeback    0    2" >> /etc/fstab

    if [ -e "parted.input" ]; then
        rm -rf ./parted.input
    fi

    if [ -e "fdisk.delete" ]; then
        rm -rf ./fdisk.delete
    fi
}


two_tera_under() {
    echo -e "d\nd\nd\nd\nd\nd\nd\nd\nw" >> fdisk.delete
    echo -e "n\np\n1\n\n\np\nw" >> fdisk.input

    echo -e "*******file making success *******\n"
    fdisk "$1" < fdisk.delete > /dev/null
    fdisk "$1" < fdisk.input > /dev/null

    echo -e "*******patitining*******\n"
    mkfs.ext4 "$1"1

    if [ -d "/cache$2" ]; then
        echo -e "*******/cache$2 already exist ********\n"
    else
        echo -e "*******cache directory making ********\n"
        mkdir /cache$2
    fi

    echo -e "******* mounting *******\n"
    mount "$1"1 /cache$2

    echo -e "${1}1    /cache$2    ext4    defaults,noatime,data=writeback    0    2" >> /etc/fstab

    if [ -e "fdisk.input" ]; then
        rm -rf ./fdisk.input
    fi

    if [ -e "fdisk.delete" ]; then
        rm -rf ./fdisk.delete
    fi
}

# ALL disk mounted by os is umounted immediately
umount_disk(){
    umount "$1"1
    echo -e "${1}1 is umount successly"
}


########################
####### main () ########
########################

# OS DISK -> VIRTUAL_DISK
OS_DISK=`df -h | grep -i "\/"$ | awk -F ' ' '{print $1}' | rev | cut -c 2- | rev`


# Mount DISK -> VIRTUAL DISK
DISK_LIST=( `fdisk -l | grep -i "Disk /dev/sd" | awk -F ':' '{print $1}' | awk -F ' ' '{print $2}' | sort` )
MOUNT_DISK=( ${DISK_LIST[@]/$OS_DISK} )


#Mount DISK Count
MOUNT_DISK_COUNT=`fdisk -l | grep -i "Disk /dev/sd" | grep -iv "$OS_DISK" | wc -l`

for (( i=0; i<$MOUNT_DISK_COUNT; i++ ));
do
    WORKING_DISK=${MOUNT_DISK[$i]}
    DISK_VOLUME=`fdisk -l | grep -i "Disk $WORKING_DISK" | cut -f 5 -d ' ' | tail -n 1`

    if [ $DISK_VOLUME -ge 1999844147200 ]; then
        if [ ! `rpm -qa parted` ]; then
            yum install -y parted
        fi
        echo -e "$WORKING_DISK is bigger than 2T disk. so we start parted command"
        sleep 1
        two_tera_over $WORKING_DISK $((i+1))
    elif [ $DISK_VOLUME -le 86073741312 ]; then
            continue
    else
        echo -e "$WORKING_DISK is smaller than 2T disk. so we start fdisk command"
        sleep 1
        two_tera_under $WORKING_DISK $((i+1))
    fi
done
sleep 2

# umount disk, because of using "mount -a"
for (( i=0; i<$MOUNT_DISK_COUNT; i++ ));
do
    WORKING_DISK=${MOUNT_DISK[$i]}
    umount_disk $WORKING_DISK
done
echo -e "\n mount 해제"
df -h

sleep 2
# "mount -a" ->  OS Kernel reads the /etc/fstab file
check_disk=`mount -a`
if [ -z "$ckeck_disk" ]; then
    echo -e "\n/etc/fstab is good state -> no problem~~~";
else
    echo -e "\n/etc/fstab is bad state -> you must check the /etc/fstab~~~!!!!";
fi
echo -e "\nmount 성공"
df -h

echo -e "\n/etc/fstab 확인"
cat /etc/fstab
