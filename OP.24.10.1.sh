#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)

# Apply 2.5G patch for BCM57810
wget -O target/linux/x86/patches-6.6/600-bnx2x-warpcore-8727-2g5.patch \
  https://raw.githubusercontent.com/Swiftfrog/Build-Openwrt/main/2.5G/bnx2x_warpcore_8727_2_5g_sgmii_txfault.patch

# luci-theme-argon: use 'master' (compatible with 24.10 LuCI)
git clone -b master https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon

# passwall2: MUST use openwrt-24.10 branch
git clone -b openwrt-24.10 https://github.com/xiaorouji/openwrt-passwall2.git package/passwall2

# passwall-packages (dependency for passwall2)
git clone -b openwrt-24.10 https://github.com/xiaorouji/openwrt-passwall-packages.git package/passwall-packages

# mosdns: use v5 branch (confirmed working on 24.10)
git clone -b v5 https://github.com/sbwml/luci-app-mosdns.git package/mosdns

# geodata
git clone -b master https://github.com/sbwml/v2ray-geodata.git package/v2ray-geodata
