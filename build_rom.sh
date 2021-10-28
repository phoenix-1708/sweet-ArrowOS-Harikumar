#!/bin/bash

set -e
set -x

# sync rom
repo init -q --no-repo-verify --depth=1 -u https://github.com/ArrowOS/android_manifest.git -b arrow-11.0 -g default,-device,-mips,-darwin,-notdefault
git clone --depth=1 https://github.com/phoenix-1708/local_manifest.git -b arrow-11 .repo/local_manifests	
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# build rom
source build/envsetup.sh
lunch arrow_sweet-userdebug
m bacon -j$(nproc --all)

# upload rom
up(){
	curl --upload-file $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB limit
}

up out/target/product/sweet/*.zip
