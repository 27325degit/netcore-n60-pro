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

# Add a feed source
# helloworld 锁 master 稳定分支（默认分支是 dev，活跃开发版可能含未稳定变更）
echo 'src-git helloworld https://github.com/fw876/helloworld;master' >>feeds.conf.default

# homeproxy 源（sing-box 核心在 packages feed 已含，无需额外加）
# 锁 commit 98a6ad9（2026-10-01）：sing-box 1.13/1.14 移除选项之前的最后一个提交，
# 与 openwrt-24.10 的 sing-box 1.12.25 兼容；不锁会拉到 master 最新版（已适配 1.14），
# 与 1.12.25 产生配置字段不兼容风险。
echo 'src-git homeproxy https://github.com/immortalwrt/homeproxy^98a6ad9e71484528008ff435694fd107591f3a1d' >>feeds.conf.default

# passwall2 源（Openwrt-Passwall 组织真身；钉当前 main HEAD，与 homeproxy 一致可复现）
echo 'src-git passwall2 https://github.com/Openwrt-Passwall/openwrt-passwall2^22e37d49b18ef6bf1c2a942be9c3a066095931b1' >>feeds.conf.default

# 说明：
# 1. 已移除 ADGuardHome（git clone），原因：各线 config 均已删除 luci-app-adguardhome，
#    且 ADGH 与 PassWall2/homeproxy 抢 DNS(53)，同时保留会冲突。
# 2. 已移除 OpenClash feed：用户决策改用 homeproxy + PassWall2 双代理，删 OpenClash
#    避免三代理抢 DNS/nftables 规则导致断网。
# 3. 不再向内核 config 手动追加 cgroup/namespace 符号：6.6 主线 OpenWrt 内核
#    （generic + filogic/config-6.6）默认已开启 Docker 所需特性，手动追加 5.x 旧符号
#    反而会重复定义或无效符号，破坏编译。Docker 用户态 extroot 后 opkg 装即可。
