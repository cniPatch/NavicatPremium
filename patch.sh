#!/bin/bash

if [[ ! -e /usr/bin/bspatch ]]; then
	echo "应用补丁需要 bspatch 程序, 请运行 brew install bsdiff 进行安装.";
	exit 2
fi

# EN 15.0.3
# SHA="005bba5365effc9592678f5bff00e0877a1536111528d37eb1d6dc23fce71d05"
# NAVICAT_PATCH="./15.0.3.en.patch"
SHA="2829a7f4f402afc7c8638826b0ef6996ee1cc673c300c49e61d10b3f13b4797b"
NAVICAT="/Applications/Navicat Premium.app/Contents/MacOS/Navicat Premium"
NAVICAT_TMP="/Applications/Navicat Premium.app/Contents/MacOS/Navicat Premium.tmp"
NAVICAT_PATCH="./12.1.28.patch"

VERSION=12.1.28

if [[ -e /usr/bin/bspatch ]]; then
	while :
	do
		clear
		echo "已安装 bspatch 程序, 准备应用补丁...";
		echo
		echo "本补丁仅适用于 Navicat Premium 12.1.28 简体中文版, 请确认您已将程序安装至应用程序目录?"
		echo "  1) 已经安装原版"
		echo "  2) 退出补丁"
		read -p "请选择 [1-2]: " option
		case $option in
			1)
			echo
			echo "开始目标文件程序版本是否正确..."
			echo
			FILESHA=$(shasum -a 256 "$NAVICAT" | cut -f 1 -d " ")
			if [[ "$FILESHA" == "$SHA" ]]; then
				echo
				echo "准备开始应用补丁..."
				echo

				if [[ ! -e "$NAVICAT_TMP" ]]; then
					bspatch "$NAVICAT" "$NAVICAT_TMP" "$NAVICAT_PATCH"
				fi
				if [[ -e "$NAVICAT_TMP" ]]; then
					rm "$NAVICAT"
					mv "$NAVICAT_TMP" "$NAVICAT"
					chmod a+x "$NAVICAT"
				fi
				echo "搞定!"
			else
				echo "您的文件版本不正确, 或已被修改, 请通过官方网站下载 Navicat Premium 12.1.28 简体中文版."
				exit 3
			fi
			exit
			;;
			2) exit;;
		esac
	done
fi
