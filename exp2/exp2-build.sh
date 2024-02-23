#!/bin/bash

components=(
    "vfs"
    "9pfs"
    "lwip"
    "process"
)

cd vp-nginx

cp das-config .config

sed -i "s/CONFIG_LIBVAMPOS_REBOOT_ALL=y/# CONFIG_LIBVAMPOS_REBOOT_ALL is not set/g" .config

#das
for component in "${components[@]}"; do
    sed -i "s/CONFIG_UK_DEFNAME=".*"/CONFIG_UK_DEFNAME=\"nginx-${component}\"/g" .config
    sed -i "s/CONFIG_UK_NAME=".*"/CONFIG_UK_NAME=\"nginx-${component}\"/g" .config
    sed -i "s/# CONFIG_LIBVAMPOS_REBOOT_${component^^}.*/CONFIG_LIBVAMPOS_REBOOT_${component^^}=y/g" .config
    make
    sed -i "s/CONFIG_LIBVAMPOS_REBOOT_${component^^}=y/# CONFIG_LIBVAMPOS_REBOOT_${component^^} is not set/g" .config
done

# sed -i "s/CONFIG_LIBVAMPOS_MERGE_NET=y/# CONFIG_LIBVAMPOS_MERGE_NET is not set/g" .config

# fsm
sed -i "s/# CONFIG_LIBVAMPOS_MERGE_FS.*/CONFIG_LIBVAMPOS_MERGE_FS=y/g" .config
sed -i "s/CONFIG_UK_DEFNAME=".*"/CONFIG_UK_DEFNAME=\"nginx-fsm\"/g" .config
sed -i "s/CONFIG_UK_NAME=".*"/CONFIG_UK_NAME=\"nginx-fsm\"/g" .config
sed -i "s/# CONFIG_LIBVAMPOS_REBOOT_VFS.*/CONFIG_LIBVAMPOS_REBOOT_VFS=y/g" .config
make
sed -i "s/CONFIG_LIBVAMPOS_REBOOT_VFS=y/# CONFIG_LIBVAMPOS_REBOOT_VFS is not set/g" .config
sed -i "s/CONFIG_LIBVAMPOS_MERGE_FS=y/# CONFIG_LIBVAMPOS_MERGE_FS is not set/g" .config

# netm
sed -i "s/# CONFIG_LIBVAMPOS_MERGE_NET.*/CONFIG_LIBVAMPOS_MERGE_NET=y/g" .config
sed -i "s/CONFIG_UK_DEFNAME=".*"/CONFIG_UK_DEFNAME=\"nginx-netm\"/g" .config
sed -i "s/CONFIG_UK_NAME=".*"/CONFIG_UK_NAME=\"nginx-netm\"/g" .config
sed -i "s/# CONFIG_LIBVAMPOS_REBOOT_LWIP.*/CONFIG_LIBVAMPOS_REBOOT_LWIP=y/g" .config
make
sed -i "s/CONFIG_LIBVAMPOS_REBOOT_LWIP=y/# CONFIG_LIBVAMPOS_REBOOT_LWIP is not set/g" .config
sed -i "s/CONFIG_LIBVAMPOS_MERGE_NET=y/# CONFIG_LIBVAMPOS_MERGE_NET is not set/g" .config
