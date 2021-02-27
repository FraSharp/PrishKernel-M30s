#!/bin/bash
echo "Setting Up Environment"
echo ""

# Check if have gcc/32 & clang folder
#if [ ! -d "$(pwd)/gcc/" ]; then
#   git clone --depth 1 git://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 gcc
#fi

# Export KBUILD flags
export KBUILD_BUILD_USER=FraSharp
export KBUILD_BUILD_HOST=Hell

# Export ARCH/SUBARCH flags
export ARCH="arm64"
export SUBARCH="arm64"

# Export ANDROID VERSION
export ANDROID_MAJOR_VERSION="q"
export PLATFORM_VERSION=10.0.0

# Ccache
export USE_CCACHE=1
export CCACHE="$(which ccache)"

# Export toolchain/cross flags
#export TOOLCHAIN="aarch64-linux-android-"

#export CLANG_TRIPLE="aarch64-linux-gnu-"
#export CROSS_COMPILE="$(pwd)/gcc/bin/${TOOLCHAIN}"

# TC
export CROSS_COMPILE=/home/francesco/linaro/bin/aarch64-linux-gnu-

#export CROSS_COMPILE_ARM32="$(pwd)/gcc32/bin/arm-linux-androideabi-"
#export WITH_OUTDIR=true

# Export PATH flag
#export PATH="${PATH}:$(pwd)/clang/bin:$(pwd)/gcc/bin:$(pwd)/gcc32/bin"
export CLANG_TRIPLE=/home/francesco/clang/bin/clang-
export CC=/home/francesco/clang/bin/clang

clear
echo "                                                     "
echo "             _     _                     _       _   "
echo "  _ __  _ __(_)___| |__    ___  ___ _ __(_)_ __ | |_ "                                              
echo " | '_ \| '__| / __| '_ \  / __|/ __| '__| | '_ \| __|"                                              
echo " | |_) | |  | \__ \ | | | \__ \ (__| |  | | |_) | |_ "                                              
echo " | .__/|_|  |_|___/_| |_| |___/\___|_|  |_| .__/ \__|"
echo " |_|                                      |_|        "
echo "                                                     "
echo "              coded by Neel0210, DAvinash97, yukosky "
echo "                                                     "
echo "Select"
echo "1 = Clear"
echo "2 = Clean Build"
echo "3 = Dirty Build"
echo "4 = Kernel+zip"
echo "5 = AIK+ZIP"
echo "6 = Anykernel"
echo "7 = Exit"
read n

if [ $n -eq 1 ]; then
echo "========================"
echo "Clearing & making clear"
echo "========================"
make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./output/*
rm ./PRISH/AIK/split_img/boot.img-zImage
rm ./PRISH/AIK/image-new.img
rm ./PRISH/AIK/ramdisk-new.cpio.empty
rm ./PRISH/AK/Image
rm ./PRISH/ZIP/PRISH/NXT/boot.img
rm ./PRISH/ZIP/PRISH/M30S/boot.img
rm ./PRISH/ZIP/PRISH/A50/boot.img
rm ./PRISH/ZIP/PRISH/1.zip
rm ./PRISH/AK/1.zip
fi

if [ $n -eq 2 ]; then
echo "==============="
echo "Building Clean"
echo "==============="
make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./output/*
rm ./PRISH/AIK/image-new.img
rm ./PRISH/AIK/ramdisk-new.cpio.empty
rm ./PRISH/AIK/split_img/boot.img-zImage
rm ./PRISH/AK/Image
rm ./PRISH/ZIP/PRISH/NXT/boot.img
rm ./PRISH/ZIP/PRISH/M30S/boot.img
rm ./PRISH/ZIP/PRISH/A50/boot.img
rm ./PRISH/AK/1.zip
############################################
# If other device make change here
############################################
make m30sdd_defconfig
make -j$(($(nproc) + 1))
echo ""
echo "Kernel Compiled"
echo ""
cp -r ./arch/arm64/boot/Image ./PRISH/AIK/split_img/boot.img-zImage
cp -r ./arch/arm64/boot/Image ./PRISH/AK/Image
fi

if [ $n -eq 3 ]; then
echo "============"
echo "Dirty Build"
echo "============"
############################################
# If other device make change here
############################################
make m30sdd_defconfig
make -j$(($(nproc) + 1))
echo ""
echo "Kernel Compiled"
echo ""
rm ./PRISH/AIK/split_img/boot.img-zImage
cp -r ./arch/arm64/boot/Image ./PRISH/AIK/split_img/boot.img-zImage
rm ./PRISH/AK/Image
cp -r ./arch/arm64/boot/Image ./PRISH/AK/Image
echo "====================="
echo "Dirty Build Finished"
echo "====================="
fi

if [ $n -eq 4 ]; then
echo "======================="
echo "Making kernel with ZIP"
echo "======================="
make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./PRISH/AIK/image-new.img
rm ./PRISH/AIK/split_img/boot.img-zImage
rm ./PRISH/AK/Image
rm ./PRISH/ZIP/PRISH/NXT/boot.img
rm ./PRISH/ZIP/PRISH/M30S/boot.img
rm ./PRISH/ZIP/PRISH/A50/boot.img
rm ./output/*
rm ./PRISH/AK/1.zip
############################################
# If other device make change here
############################################
make m30sdd_defconfig
make -j$(($(nproc) + 1))
echo "Kernel Compiled"
echo ""
echo "======================="
echo "Packing Kernel INTO ZIP"
echo "======================="
echo ""
cp -r ./arch/arm64/boot/Image ./PRISH/AIK/split_img/boot.img-zImage
cp -r ./arch/arm64/boot/Image ./PRISH/AK/Image
./PRISH/AIK/repackimg.sh
cp -r ./PRISH/AIK/image-new.img ./PRISH/ZIP/PRISH/M30S/boot.img
cd PRISH/ZIP
echo "==========================="
echo "Packing into Flashable zip"
echo "==========================="
./zip.sh
cd ../..
cp -r ./PRISH/ZIP/1.zip ./output/PrishKernel--Px--QQ-M30sdd.zip
cd output
echo ""
pwd
cd ..
echo " "
echo "======================================================="
echo "get PrishKernel-Px-QQ-M30sdd.zip from upper given path"
echo "======================================================="
fi

if [ $n -eq 5 ]; then
echo "====================="
echo "Transfering Files"
echo "====================="
rm ./PRISH/AIK/split_img/boot.img-zImage
rm ./output/Pri*
cp -r ./arch/arm64/boot/Image ./output/Zimage/Image
cp -r ./arch/arm64/boot/Image ./AIK/split_img/boot.img-zImage
./PRISH/AIK/repackimg.sh
cp -r ./PRISH/AIK/image-new.img ./PRISH/ZIP/PRISH/M30S/boot.img
cd PRISH/ZIP
echo " "
echo "==========================="
echo "Packing into Flashable zip"
echo "==========================="
./zip.sh
cd ../..
cp -r ./PRISH/ZIP/1.zip ./output/PrishKernel--Px--QQ-M30sdd.zip
cd output
cd ..
echo " "
pwd
echo "======================================================"
echo "get PrishKernel-Px-QQ-M30sdd.zip from upper given path"
echo "======================================================"
fi

if [ $n -eq 6 ]; then
echo "===================="
echo "ADDING IN ANYKERNEL"
echo "===================="
rm ./output/Any*
rm ./PRISH/AK/Image
cp -r ./arch/arm64/boot/Image ./PRISH/AK/Image
cd PRISH/AK
echo " "
echo "=========================="
echo "Packing into Anykernelzip"
echo "=========================="
./zip.sh
cd ../..
cp -r ./PRISH/AK/1.zip ./output/Anykernel-M30s.zip
cd output
cd ..
echo " "
pwd
echo "============================================"
echo "get Anykernel-A50.zip from upper given path"
echo "============================================"
fi

if [ $n -eq 7 ]; then
echo "========"
echo "Exiting"
echo "========"
exit
fi


