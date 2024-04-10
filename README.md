
<h1 align="center">
  <br>
  <img src="https://i.ibb.co/LYYJzJC/logo.jpg" alt="Markdownify" width="2048">
  <br>
  GrassKernel
  <br>
</h1>

<h4 align="center">A custom kernel for the Exynos9611 devices.</h4>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-build">How To Build</a> •
  <a href="#credits">Credits</a>
</p>

## Key Features

* Disable Samsung securities, debug drivers, etc modifications
* Checkout and rebase against Android common kernel source, Removing Samsung additions to drivers like ext4,f2fs and more
* Compiled with bleeding edge Neutron Clang 17, with full LLVM binutils, LTO (Link time optimization) and -O3  
* Import Erofs, Incremental FS, BinderFS and several backports.
* Supports DeX touchpad for corresponding OneUI ports that have DeX ported.
* Lot of debug codes/configuration Samsung added are removed.
* Added [wireguard](https://www.wireguard.com/) driver, an open-source VPN driver in-kernel
* Added [KernelSU](https://kernelsu.org/)
* Docker config (all kernel features except ``CONFIG_EXT3_FS_XATTR`` and ``CONFIG_SECURITY_APPARMOR``)
* KVM config
* PostgreSQL config (shared memory, SYSV IPC)

## How To Build

```bash
# Install dependencies
$ sudo apt install -y bash git make libssl-dev curl bc pkg-config m4 libtool automake autoconf

# Clone this repository
$ git clone https://github.com/RealEthanPlayzDev/grass_universal9611.git

# Go into the repository
$ cd grass_universal9611

# Install toolchain
# This will use antman and patch glibc if needed
# If you use a rolling-release distro with latest glibc, use antman directly instead
$ bash <(curl https://gist.githubusercontent.com/roynatech2544/0feeeb35a6d1782b186990ff2a0b3657/raw/b170134a94dac3594df506716bc7b802add2724b/setup.sh)

# Build the kernel
# DEVICE variable has to be explicitly set
# DEVICE can be m21, m31, m31s, f41
$ DEVICE=a51 ./build_kernel.sh oneui ksu no-permissive no-docker no-kvm # (for A51, OneUI, KernelSU)
$ DEVICE=a51 ./build_kernel.sh aosp ksu no-permissive docker kvm        # (for A51, AOSP, KernelSU, Enforcing SELinux, Docker config, KVM config)
$ DEVICE=a51 ./build_kernel.sh oneui ksu no-permissive docker kvm       # (for A51, OneUI, KernelSU, Enforcing SELinux, Docker config, KVM config)
```

After build the image of the kernel will be in out/arch/arm64/boot/Image. Flashable zip will be made at the root of the repo with the name Kernel.zip

## Credits

- [roynatech2544](https://github.com/roynatech2544)
- [Docker on Android gist](https://gist.github.com/FreddieOliveira/efe850df7ff3951cb62d74bd770dce27)
- [Samsung Open Source](https://opensource.samsung.com/)
- [Android Open Source Project](https://source.android.com/)
- [The Linux Kernel](https://www.kernel.org/)


