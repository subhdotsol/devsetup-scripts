# Development Environment

 Personal development environment and bootstrap scripts for setting up Linux and macOS machines for systems programming, Rust, eBPF, Solana, and Anchor development.Instead of manually installing the same tools every time a new virtual machine or development machine is created, the required setup is maintained as code.

 ## Repository Structure

 ### Linux

 Contains scripts for configuring a Linux development environment.
 `packages.sh` installs system-level dependencies using the distribution's package manager.
 `setup.sh` configures the complete Linux development environment, including Rust and the required Rust targets.

 ### Toolchains
 Contains language and ecosystem-specific setup scripts.
 `setup-solana.sh` installs and configures the Solana development toolchain, including Solana CLI, AVM, and Anchor.

 ## Lima
 The Linux environment is primarily intended to run inside Lima on macOS.
 Lima provides lightweight Linux virtual machines using Apple's virtualization capabilities on Apple Silicon Macs.
 A new development VM can be created with:

```
limactl start --name dev
```
Enter the VM with:
```
lima --name dev
```

 ## Setting Up a New Linux VM
 After creating a new Lima VM, install Git so the repository can be cloned:

```
sudo apt update
sudo apt install -y git
```

 Clone the repository:

```
git clone https://github.com/subhdotsol/devsetup-scripts.git
```

 Enter the repository:

```
cd devsetup-scripts
```

 Make the scripts executable:

```
chmod +x linux/setup.sh
chmod +x linux/packages.sh
chmod +x toolchains/setup-solana.sh
```

 Run the Linux environment setup:

```
./linux/setup.sh
```

 For Solana and Anchor development:

```
./toolchains/setup-solana.sh
```

 ## Linux Development Environment

 The Linux setup installs the base tools required for development, including:

 - Git
- Curl
- GCC
- pkg-config
- Fastfetch
- Rustup
- Rust
- Cargo
- AArch64 Linux Rust target

 The Rust toolchain is installed and maintained using Rustup.

 The setup script updates the stable Rust toolchain rather than relying on the Rust version provided by the Linux distribution.

 ## Solana Development Environment

 The Solana setup configures the tools required for Solana and Anchor development.

 The environment includes:

 - Rust
- Solana CLI
- AVM (Anchor Version Manager)
- Anchor

 AVM is used to manage Anchor versions, allowing projects to use different Anchor releases when required.

 ## Verification

 After installation, verify the environment with:

```
rustc --version
cargo --version
solana --version
avm --version
anchor --version
```

 Check the Linux environment with:

```
uname -a
uname -m
```

 On Apple Silicon Lima VMs, the expected architecture is:

```
aarch64
```

 ## Recreating the Environment

 The development VM is intended to be disposable.

 If the VM becomes unusable, it can be removed:

```
limactl stop dev
limactl delete dev
```

 A new VM can then be created:

```
limactl start --name dev
```

 Clone this repository again and run the setup scripts.

 This approach keeps the environment configuration in version control and makes it possible to recreate the development environment without manually repeating the installation process.

 ## Design Principles

 This repository follows a few simple principles:

1. Keep environment configuration as code.
2. Prefer official installation mechanisms for language toolchains.
3. Separate operating-system packages from language and ecosystem toolchains.
4. Avoid unnecessary dependencies.
5. Make development environments reproducible.
6. Keep secrets and credentials out of the repository.

 ## Scope

 This repository is intended for personal development environments and experimentation.

 It is primarily focused on:

 - Linux development
- Rust
- Systems programming
- eBPF
- Aya
- Solana
- Anchor
- Local virtualized development environments

 The scripts may evolve as the development environment and tooling requirements change.
