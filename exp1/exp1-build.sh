#!/bin/bash
cd uk-syscall

syscalls=(
    "getpid"
    "open"
    "read"
    "write"
    "close"
    "sockread"
    "sockwrite"
)

# Unikraft build

for syscall in "${syscalls[@]}"; do
    sed -i "s/CONFIG_UK_DEFNAME=".*"/CONFIG_UK_DEFNAME=\"uk-syscall-${syscall}\"/g" .config
    sed -i "s/CONFIG_UK_NAME=".*"/CONFIG_UK_NAME=\"uk-syscall-${syscall}\"/g" .config
    sed -i "s/# CONFIG_LIBMRTIME_SYSCALL_${syscall^^}.*/CONFIG_LIBMRTIME_SYSCALL_${syscall^^}=y/g" .config
    make
    sed -i "s/CONFIG_LIBMRTIME_SYSCALL_${syscall^^}=y/# CONFIG_LIBMRTIME_SYSCALL_${syscall^^} is not set/g" .config
done

cd ..


# VampOS build

cd vp-syscall

cp vp-config .config

sed -i "s/CONFIG_LIBVAMPOS_DAS=y/# CONFIG_LIBVAMPOS_DAS is not set/g" .config
for syscall in "${syscalls[@]}"; do
    sed -i "s/CONFIG_UK_DEFNAME=".*"/CONFIG_UK_DEFNAME=\"vp-syscall-${syscall}\"/g" .config
    sed -i "s/CONFIG_UK_NAME=".*"/CONFIG_UK_NAME=\"vp-syscall-${syscall}\"/g" .config
    sed -i "s/# CONFIG_LIBMRTIME_SYSCALL_${syscall^^}.*/CONFIG_LIBMRTIME_SYSCALL_${syscall^^}=y/g" .config
    make
    sed -i "s/CONFIG_LIBMRTIME_SYSCALL_${syscall^^}=y/# CONFIG_LIBMRTIME_SYSCALL_${syscall^^} is not set/g" .config
done

# for non Session-aware Log Shrinking
sed -i "s/CONFIG_LIBVAMPOS_SALS=y/# CONFIG_LIBVAMPOS_SALS is not set/g" .config
for syscall in "${syscalls[@]}"; do
    sed -i "s/CONFIG_UK_DEFNAME=".*"/CONFIG_UK_DEFNAME=\"nosals-syscall-${syscall}\"/g" .config
    sed -i "s/CONFIG_UK_NAME=".*"/CONFIG_UK_NAME=\"nosals-syscall-${syscall}\"/g" .config
    sed -i "s/# CONFIG_LIBMRTIME_SYSCALL_${syscall^^}.*/CONFIG_LIBMRTIME_SYSCALL_${syscall^^}=y/g" .config
    make
    sed -i "s/CONFIG_LIBMRTIME_SYSCALL_${syscall^^}=y/# CONFIG_LIBMRTIME_SYSCALL_${syscall^^} is not set/g" .config
done


cp das-config .config

# sed -i "s/# CONFIG_LIBVAMPOS_DAS.*/CONFIG_LIBVAMPOS_DAS=y\n# CONFIG_LIBVAMPOS_MERGE_FS is not set\n# CONFIG_LIBVAMPOS_MERGE_NET is not set/g" .config

for syscall in "${syscalls[@]}"; do
    sed -i "s/CONFIG_UK_DEFNAME=".*"/CONFIG_UK_DEFNAME=\"das-syscall-${syscall}\"/g" .config
    sed -i "s/CONFIG_UK_NAME=".*"/CONFIG_UK_NAME=\"das-syscall-${syscall}\"/g" .config
    sed -i "s/# CONFIG_LIBMRTIME_SYSCALL_${syscall^^}.*/CONFIG_LIBMRTIME_SYSCALL_${syscall^^}=y/g" .config
    make
    sed -i "s/CONFIG_LIBMRTIME_SYSCALL_${syscall^^}=y/# CONFIG_LIBMRTIME_SYSCALL_${syscall^^} is not set/g" .config
done

sed -i "s/CONFIG_LIBVAMPOS_MERGE_NET=y/# CONFIG_LIBVAMPOS_MERGE_NET is not set/g" .config
sed -i "s/# CONFIG_LIBVAMPOS_MERGE_FS.*/CONFIG_LIBVAMPOS_MERGE_FS=y/g" .config

for syscall in "${syscalls[@]}"; do
    sed -i "s/CONFIG_UK_DEFNAME=".*"/CONFIG_UK_DEFNAME=\"fsm-syscall-${syscall}\"/g" .config
    sed -i "s/CONFIG_UK_NAME=".*"/CONFIG_UK_NAME=\"fsm-syscall-${syscall}\"/g" .config
    sed -i "s/# CONFIG_LIBMRTIME_SYSCALL_${syscall^^}.*/CONFIG_LIBMRTIME_SYSCALL_${syscall^^}=y/g" .config
    make
    sed -i "s/CONFIG_LIBMRTIME_SYSCALL_${syscall^^}=y/# CONFIG_LIBMRTIME_SYSCALL_${syscall^^} is not set/g" .config
done

sed -i "s/CONFIG_LIBVAMPOS_MERGE_FS=y/# CONFIG_LIBVAMPOS_MERGE_FS is not set/g" .config
sed -i "s/# CONFIG_LIBVAMPOS_MERGE_NET.*/CONFIG_LIBVAMPOS_MERGE_NET=y/g" .config

for syscall in "${syscalls[@]}"; do
    sed -i "s/CONFIG_UK_DEFNAME=".*"/CONFIG_UK_DEFNAME=\"netm-syscall-${syscall}\"/g" .config
    sed -i "s/CONFIG_UK_NAME=".*"/CONFIG_UK_NAME=\"netm-syscall-${syscall}\"/g" .config
    sed -i "s/# CONFIG_LIBMRTIME_SYSCALL_${syscall^^}.*/CONFIG_LIBMRTIME_SYSCALL_${syscall^^}=y/g" .config
    make
    sed -i "s/CONFIG_LIBMRTIME_SYSCALL_${syscall^^}=y/# CONFIG_LIBMRTIME_SYSCALL_${syscall^^} is not set/g" .config
done

sed -i "s/CONFIG_LIBVAMPOS_MERGE_NET=y/# CONFIG_LIBVAMPOS_MERGE_NET is not set/g" .config
