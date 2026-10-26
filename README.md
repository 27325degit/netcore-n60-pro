**English** | [中文](https://p3terx.com/archives/build-openwrt-with-github-actions.html)

# Actions-OpenWrt

[![LICENSE](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square&label=LICENSE)](https://github.com/P3TERX/Actions-OpenWrt/blob/master/LICENSE)
![GitHub Stars](https://img.shields.io/github/stars/P3TERX/Actions-OpenWrt.svg?style=flat-square&label=Stars&logo=github)
![GitHub Forks](https://img.shields.io/github/forks/P3TERX/Actions-OpenWrt.svg?style=flat-square&label=Forks&logo=github)

A template for building OpenWrt with GitHub Actions

## Usage

- 点击 [Fork] 按钮生成新项目.
- [LEDE源码](https://github.com/coolsnowwolf/lede)，自定义脚本diy-part2.sh，配置文件LEDE.config.
- [dailook源码](https://github.com/dailook/immortalwrt-mt798x)，自定义脚本diy-part3.sh，配置文件dailook-hanwckf.config.该源码适配了硬改后的512M闪存，如果需要编译512M的ROM，需要在dailook-hanwckf.config文件里面添加如下内容：
 ```bash
CONFIG_TARGET_DEVICE_mediatek_mt7986_DEVICE_netcore_n60pro-512rom=y
CONFIG_TARGET_DEVICE_PACKAGES_mediatek_mt7986_DEVICE_netcore_n60pro-512rom=""
```
- [Immortalwrt源码](https://github.com/immortalwrt/immortalwrt)，自定义脚本diy-part4.sh，配置文件immortalwrt.config.
- [237源码](https://github.com/padavanonly/immortalwrt-mt798x-24.10)，6.6内核自定义脚本diy-part5-6.6.sh，配置文件padavanonly-immortalwrt-mt798x-6.6.config，5.4内核版本自定义脚本diy-part5-2410.sh，配置文件padavanonly-immortalwrt-mt798x-2410.config.
- diy-part1.sh是共用脚本，加入了helloworld和homeproxy源码，所有默认配置文件集成了定时重启、终端ttyd、组播代理omcproxy、组播转换msd_lite，需要自定义的请自行修改对应的自定义脚本和配置文件.
- 6.6线(padavanonly-immortalwrt-mt798x-6.6.config)额外集成了PassWall2+xray核心、homeproxy+sing-box核心、Docker内核模块、USB/文件系统/网络共享(ksmbd)/打印(CUPS内核模块)等，Docker用户态与iStore需刷机后opkg安装.
- 在Actions页面运行对应的源码固件编译文件，点击右侧的 Run workflow 按钮开始编译，正常的话大概1-2h左右能看到编译结果，编译完成后下载相应的固件即可.

## 6.6 线刷机后必读（稳定性关键）

**1. homeproxy 与 PassWall2 只能二选一启用**
两个插件都会接管 DNS(53 端口)和 nftables 分流规则，**切勿同时开启**，否则互相抢 53 端口与规则导致全局断网。默认两者都编译进固件（方便切换），但运行时只开其中一个。

**2. HNAT 硬件加速 + PPPoE 掉线兜底**
237 源码存在已知问题：长时间拨号后可能 PPPoE 掉线且无法自动重拨。对策：
- 在 `服务 → WatchCat` 设置「定期 ping 外网 IP（如 223.5.5.5），失败 N 次自动重启 WAN/整机」，实现掉线自愈。
- 若仍频发掉线，在 `网络 → Turbo ACC` 里关闭 HNAT/硬件加速走纯 CPU 转发（千兆内无感），是最彻底的稳定方案。
- 固件已默认关闭主线 flow-offload（避免与 HNAT 双重加速冲突），无需再动。

**3. SQM QoS 用 cake 算法**
固件已编入 `kmod-sched-cake`，刷机后 `网络 → SQM QoS` 选 cake 算法即可缓解宽带跑满时丢包/延迟抖动。

**4. Docker 需 extroot 后安装**
内核侧 cgroup/namespace/loop/overlay 已开，刷机后 extroot 挂载大分区，再 `opkg install dockerd docker containerd runc tini`。

**5. 网络共享（ksmbd）与 CUPS 打印**
- 网络共享：已编入 `ksmbd-server` + `luci-app-ksmbd`（内核态 SMB2/3，轻量高性能），`网络 → 网络共享` 直接配置即可。
- CUPS 打印：内核模块 `kmod-usb-printer` 已编入，但 CUPS 用户态体积大未编入，extroot 后 `opkg install cups` 再插 USB 打印机即可。

## Tips

- It may take a long time to create a `.config` file and build the OpenWrt firmware. Thus, before create repository to build your own firmware, you may check out if others have already built it which meet your needs by simply [search `Actions-Openwrt` in GitHub](https://github.com/search?q=Actions-openwrt).
- Add some meta info of your built firmware (such as firmware architecture and installed packages) to your repository introduction, this will save others' time.

## Credits

- [Microsoft Azure](https://azure.microsoft.com)
- [GitHub Actions](https://github.com/features/actions)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
- [Mikubill/transfer](https://github.com/Mikubill/transfer)
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release)
- [Mattraks/delete-workflow-runs](https://github.com/Mattraks/delete-workflow-runs)
- [dev-drprasad/delete-older-releases](https://github.com/dev-drprasad/delete-older-releases)
- [peter-evans/repository-dispatch](https://github.com/peter-evans/repository-dispatch)

## License

[MIT](https://github.com/P3TERX/Actions-OpenWrt/blob/main/LICENSE) © [**P3TERX**](https://p3terx.com)
