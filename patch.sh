#!/bin/bash

if [[ ! -e /usr/bin/bspatch ]]; then
	echo "应用补丁需要 bspatch 程序, 请运行 brew install bsdiff 进行安装.";
	exit 2
fi

SHA="f6f7124ff0bd97592b5ea751baf39f248bbacfb7812068cfa278393654875306"
SUBLIME="/Applications/Navicat Premium.app/Contents/MacOS/Navicat Premium"
SUBLIME_TMP="/Applications/Navicat Premium.app/Contents/MacOS/Navicat Premium.tmp"
SUBLIME_PATCH="./12.0.26.patch"

VERSION=12.0.26

if [[ -e /usr/bin/bspatch ]]; then
	while :
	do
		clear
		echo "已安装 bspatch 程序, 准备应用补丁...";
		echo
		echo "本补丁仅适用于 Navicat Premium 12.0.26 简体中文版, 请确认您已将程序安装至应用程序目录?"
		echo "  1) 已经安装原版"
		echo "  2) 退出补丁"
		read -p "请选择 [1-2]: " option
		case $option in
			1)
			echo
			echo "开始目标文件程序版本是否正确..."
			echo
			FILESHA=$(shasum -a 256 "$SUBLIME" | cut -f 1 -d " ")
			if [[ "$FILESHA" == "$SHA" ]]; then
				echo
				echo "准备开始应用补丁..."
				echo

				if [[ ! -e "$SUBLIME_TMP" ]]; then
					bspatch "$SUBLIME" "$SUBLIME_TMP" "$SUBLIME_PATCH"
				fi
				if [[ -e "$SUBLIME_TMP" ]]; then
					rm "$SUBLIME"
					mv "$SUBLIME_TMP" "$SUBLIME"
					chmod a+x "$SUBLIME"
				fi
				echo "搞定!"
			else
				echo "您的文件版本不正确, 或已被修改, 请通过官方网站下载 Navicat Premium 12.0.26 简体中文版."
				exit 3
			fi
			exit
			;;
			2) exit;;
		esac
	done
fi
