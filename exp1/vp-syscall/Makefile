UK_ROOT ?= $(PWD)/../../../VampOS/unikraft
UK_LIBS ?= $(PWD)/../../../VampOS/libs
LIBS := $(UK_LIBS)/lib-pthread-embedded:$(UK_LIBS)/lib-newlib:$(UK_LIBS)/lib-mr_time:$(UK_LIBS)/lib-lwip:$(UK_LIBS)/lib-cmpwall

QEMU_DIR := $(CURDIR)/../../../VampOS-qemu
QEMU := $(QEMU_DIR)/build/qemu-system-x86_64
QEMU_HELPER := $(QEMU_DIR)/build/qemu-bridge-helper
QEMU_BRG_CONF := $(QEMU_DIR)/etc/qemu/bridge.conf

APP := syscall
BRG := virbr0
FS := syscall-fs

all:
	@$(MAKE) -C $(UK_ROOT) A=$(PWD) L=$(LIBS)

$(MAKECMDGOALS):
	@$(MAKE) -C $(UK_ROOT) A=$(PWD) L=$(LIBS) $(MAKECMDGOALS)

addbr:
	ip link add $(BRG) type bridge
	ip a a  172.44.0.1/24 dev $(BRG)
	ip l set dev $(BRG) up
	sed -i '$$aallow $(BRG)' $(QEMU_BRG_CONF)

delbr:
	ip link del $(BRG)
	sed -i '/allow $(BRG)/d' $(QEMU_BRG_CONF)

run:
	mkdir -p $(FS)
	qemu-img create -f qcow2 ./snapshots.qcow2 1G
	$(QEMU) -m 2G -nographic -kernel ./build/$(OS)-$(APP)-$(SYSCALL)_kvm-x86_64 \
	    -fsdev local,id=myid,path=$(FS),security_model=none \
	    -device virtio-9p-pci,fsdev=myid,mount_tag=rootfs,disable-modern=on,disable-legacy=off \
		-netdev bridge,id=en0,br=$(BRG),helper=$(QEMU_HELPER) \
		-append "netdev.ipv4_addr=172.44.0.2 netdev.ipv4_gw_addr=172.44.0.1 netdev.ipv4_subnet_mask=255.255.255.0 --" \
	    -device virtio-net-pci,netdev=en0 \
	    -drive if=none,format=qcow2,file=./snapshots.qcow2 \
	    -cpu host -no-reboot -enable-kvm  > ../result/$(OS)-$(SYSCALL).csv
	rm ./snapshots.qcow2
	rm -r $(FS)

dbg:
	mkdir -p $(FS)
	qemu-img create -f qcow2 ./snapshots.qcow2 1G
	$(QEMU) -s -S -m 2G -nographic  -kernel ./build/$(OS)-$(APP)-$(SYSCALL)_kvm-x86_64.dbg \
		-fsdev local,id=myid,path=$(FS),security_model=none \
		-device virtio-9p-pci,fsdev=myid,mount_tag=rootfs,disable-modern=on,disable-legacy=off \
		-netdev bridge,id=en0,br=$(BRG),helper=$(QEMU_HELPER) \
		-append "netdev.ipv4_addr=172.44.0.2 netdev.ipv4_gw_addr=172.44.0.1 netdev.ipv4_subnet_mask=255.255.255.0 --" \
		-device virtio-net-pci,netdev=en0 \
		-drive if=none,format=qcow2,file=./snapshots.qcow2 \
		-cpu host -no-reboot -enable-kvm  -append verbose
	rm ./snapshots.qcow2
	rm -r $(FS)

monitor:
	gdb --eval-command="target remote :1234" ./build/$(OS)-$(APP)-$(SYSCALL)_kvm-x86_64.dbg
