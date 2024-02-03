#!/bin/bash
cd uk-syscall
make clean
cd ..
cd vp-syscall
make clean
rm -f build/vp-syscall-*
rm -f build/das-syscall-*
rm -f build/fsm-syscall-*
rm -f build/netm-syscall-*
