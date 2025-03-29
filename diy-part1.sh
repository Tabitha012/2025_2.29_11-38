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

# 添加 helloworld 软件源
echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default

# 添加 passwall 软件源（如果需要）
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# 修改默认主题为 luci-theme-argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 修改默认主机名为 OpenWrt
sed -i 's/OpenWrt/OpenWrt/g' package/base-files/files/bin/config_generate

# 启用 DHCP 服务
sed -i 's/option ignore 1/option ignore 0/g' package/network/config/netifd/files/etc/config/dhcp

# 设置默认登录用户名和密码为 root
sed -i 's/option username.*/option username root/g' package/base-files/files/bin/config_generate
sed -i 's/option password.*/option password root/g' package/base-files/files/bin/config_generate

# 配置 2.4GHz Wi-Fi
cat >> package/kernel/mac80211/files/lib/wifi/mac80211.sh <<EOF
wifi_device \${devid} 'radio0' \
    type 'mac80211' \
    channel '6' \
    band '2g' \
    htmode 'HT20' \
    country 'CN' \
    disabled '0'
EOF

# 配置 5.0GHz Wi-Fi
cat >> package/kernel/mac80211/files/lib/wifi/mac80211.sh <<EOF
wifi_device \${devid} 'radio1' \
    type 'mac80211' \
    channel '36' \
    band '5g' \
    htmode 'VHT80' \
    country 'CN' \
    disabled '0'
EOF

# 设置 2.4GHz Wi-Fi 名称、密码和安全模式
uci set wireless.@wifi-iface[0].ssid='OpenWrt_2.4G'
uci set wireless.@wifi-iface[0].key='12345678'
uci set wireless.@wifi-iface[0].encryption='sae-mixed'
uci commit wireless

# 设置 5.0GHz Wi-Fi 名称、密码和安全模式
uci set wireless.@wifi-iface[1].ssid='OpenWrt_5G'
uci set wireless.@wifi-iface[1].key='12345678'
uci set wireless.@wifi-iface[1].encryption='sae-mixed'
uci commit wireless
