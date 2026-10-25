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
# 自定义追加（N60 Pro 全依赖版，基于 2026-10-25 上游快照）
# ============================================================

# ---- 1. 外部软件源 ----
# helloworld 源已在上方提供 luci-app-passwall / passwall2 / xray-core
# OpenClash 源
echo 'src-git openclash https://github.com/vernesong/OpenClash' >>feeds.conf.default
# iStore 源（linkease 官方，含依赖）
echo 'src-git istore https://github.com/linkease/istore.git;main' >>feeds.conf.default
echo 'src-git nas https://github.com/linkease/nas-packages.git;master' >>feeds.conf.default
echo 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' >>feeds.conf.default

# ---- 2. 开启容器所需内核选项（关键！）----
# 实测 237 的 6.6 内核里 CGROUPS / NAMESPACES / VETH / MACVLAN / SECCOMP
# 全部是 "# ... is not set"，且不提供对应 kmod，opkg 永远装不上。
# 不在这里打开，以后就算把 dockerd 装到 U 盘也跑不起来。
for KC in target/linux/mediatek/filogic/config-6.6 target/linux/mediatek/mt7986/config-6.6; do
  if [ -f "$KC" ]; then
    cat >> "$KC" <<'KERNEL_EOF'

# ---- 容器/Docker 支持（自定义追加）----
CONFIG_CGROUPS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_CPUSETS=y
CONFIG_BLK_CGROUP=y
CONFIG_NAMESPACES=y
CONFIG_NET_NS=y
CONFIG_PID_NS=y
CONFIG_IPC_NS=y
CONFIG_UTS_NS=y
CONFIG_USER_NS=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
CONFIG_POSIX_MQUEUE=y
CONFIG_KEYS=y
CONFIG_NET_CLS_CGROUP=y
# BBR 拥塞控制
CONFIG_TCP_CONG_BBR=y
KERNEL_EOF
    echo "已为 $KC 追加容器内核选项"
  fi
done
