#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# Add ADGuardHome source
git clone https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome
chmod -R 755 ./package/luci-app-adguardhome/*

# ============================================================
# 自定义追加（N60 Pro 6.6 全依赖版，2026-10-26 修正）
# ============================================================

# ---- 外部软件源 ----
# helloworld 源已在上方提供 luci-app-passwall / passwall2 / xray-core
# OpenClash 源
echo 'src-git openclash https://github.com/vernesong/OpenClash' >>feeds.conf.default

# 说明：不再向内核 config 手动追加 cgroup/namespace 符号。
# 6.6 主线 OpenWrt 的内核（generic + filogic/config-6.6）默认已开启
# cgroup/namespace/loop/overlayfs 等 Docker 所需特性，手动追加 5.x 旧符号
# 反而会导致重复定义或无效符号，破坏编译。Docker 只需 extroot 后 opkg 装用户态即可。
