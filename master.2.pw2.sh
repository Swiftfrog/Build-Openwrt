#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/10.9.0.1/g' package/base-files/files/bin/config_generate

# 23.05.2
#echo '47964456485559d992fe6f536131fc64' > vermagic
# 23.05.3
#echo 'e496746edd89318b9810e48e36a8bd9c' > vermagic
# 23.05.4
#echo '59d1431675acc6823a33c7eb2323daeb' > vermagic
# 23.05.5
#echo '59d1431675acc6823a33c7eb2323daeb' > vermagic
# master
echo 'fcc34a80749f2bb1217ba31a0b7e4e32-r1' > vermagic

wget -O include/kernel-defaults.mk https://raw.githubusercontent.com/Swiftfrog/Build-Openwrt/main/Version/kernel-defaults.mk
wget -O package/kernel/linux/Makefile https://raw.githubusercontent.com/Swiftfrog/Build-Openwrt/main/Version/Makefile
#curl -s https://downloads.openwrt.org/releases/23.05.2/targets/x86/64/openwrt-23.05.2-x86-64.manifest | grep kernel | awk '{print $3}' | awk -F- '{print $3}' > vermagic

#update golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang
