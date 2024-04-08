#/bin/bash
set -e

[ ! -e "scripts/packaging/pack.sh" ] && git submodule init && git submodule update
[ ! -d "toolchain" ] && echo "Make toolchain avaliable at $(pwd)/toolchain" && exit

export KBUILD_BUILD_USER=Royna
export KBUILD_BUILD_HOST=GrassLand

PATH=$PWD/toolchain/bin:$PATH
export LLVM_DIR=$PWD/toolchain/bin
export kerneldir=$PWD

if [ -z "$DEVICE" ]; then
echo Manually set the device variable
exit 1
fi

if [ "$1" = "oneui" ]; then
FLAGS=ONEUI=1
echo "Mode: OneUI"
else
CONFIG_AOSP=vendor/aosp.config
echo "Mode: AOSP"
fi

if [ "$2" = "ksu" ]; then
CONFIG_KSU=vendor/ksu.config
echo "KSU: Enabled"
else
echo "KSU: Disabled"
fi

if [ "$3" = "permissive" ]; then
CONFIG_SELINUX=vendor/permissive.config
echo "Permissive SELinux: Enabled"
else
echo "Permissive SELinux: Disabled"
fi

if [ "$4" = "docker" ]; then
CONFIG_DOCKER=vendor/docker.config
echo "Docker config: Enabled"
else
echo "Docker config: Disabled"
fi

if [ "$5" = "kvm" ]; then
CONFIG_KVM=vendor/kvm.config
echo "KVM config: Enabled"
else
echo "KVM config: Disabled"
fi

rm -rf out

COMMON_FLAGS='
CC=clang
LD=ld.lld
ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu-
CLANG_TRIPLE=aarch64-linux-gnu-
AR='${LLVM_DIR}/llvm-ar'
NM='${LLVM_DIR}/llvm-nm'
AS='${LLVM_DIR}/llvm-as'
OBJCOPY='${LLVM_DIR}/llvm-objcopy'
OBJDUMP='${LLVM_DIR}/llvm-objdump'
READELF='${LLVM_DIR}/llvm-readelf'
OBJSIZE='${LLVM_DIR}/llvm-size'
STRIP='${LLVM_DIR}/llvm-strip'
LLVM_AR='${LLVM_DIR}/llvm-ar'
LLVM_DIS='${LLVM_DIR}/llvm-dis'
LLVM_NM='${LLVM_DIR}/llvm-nm'
'

make O=out $COMMON_FLAGS vendor/${DEVICE}_defconfig vendor/grass.config vendor/${DEVICE}.config $CONFIG_AOSP $CONFIG_DOCKER $CONFIG_KVM $CONFIG_KSU $CONFIG_SELINUX
make O=out $COMMON_FLAGS ${FLAGS} -j$(nproc)

if [ -f "$PWD/out/arch/arm64/boot/Image" ]; then
echo "Boot image found, creating flash"
#bash $PWD/scripts/packaging/pack.sh $PWD/out/arch/arm64/boot/Image GrassKernel_${DEVICE}.zip 
cp $PWD/out/arch/arm64/boot/Image $PWD/Anykernel3/ && cd Anykernel3/ && zip Kernel.zip -r * && mv Kernel.zip ../ && cd ..
fi
