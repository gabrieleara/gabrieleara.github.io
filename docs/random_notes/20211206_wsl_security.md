# On the security of Windows 10/11 and WSL [WIP]

This document contains some notes collected all over the Internet or obtained as
a trial-and-error about the security of systems running Windows 10/11 with the
WSL feature enabled.

!!! note
    This article is a work in progress and thus it is not ready yet!

WSL (or Windows Subsystem for Linux) is a feature introduced by Microsoft into
Windows 10 and 11 to essentially create a subsystem in which Linux applications
can be executed while running on Windows.

Originally, it was released in 2016 with its first version (WSL 1), which at the
time was an evolution of the deprecated POSIX subsystem for Windows. This first
version does not create an entire virtual machine in which ELF binaries would
find a Linux-compatible ABI. This ABI provides the same interface as the Linux
kernel ABI, with minor additions, through a translation layer that converts
Linux system calls to equivalent ones for the NT Kernel (the core component of
Windows OS).

More recently, Microsoft re-architected this feature to instead operate within a
Hyper-V instance with its own dedicated Linux kernel, thus removing the
translation layer. This new version of WSL (called WSL 2) de-facto runs
alongside Windows in a separate virtual machine: at the very bottom layer we
have Hyper-V, which is a bare-metal hypervisor and VMM, on top of which Windows
and (occasionally) Linux VMs run side by side, sharing system resources
depending on the allocation provided by the hypervisor.

Do these components undermine the security of a Windows machine? Do they need to
be installed to be considered a threat? What is the Answer to the Ultimate
Question of Life, The Universe, and Everything? In this blog post I will try to
illustrate some of my findings on the web and some of the things that I found
out by trying some of these attacks. If you want a quick spoiler, the answer to
the last question is [42](https://en.wikipedia.org/wiki/Phrases_from_The_Hitchhiker%27s_Guide_to_the_Galaxy#Answer_to_the_Ultimate_Question_of_Life,_the_Universe,_and_Everything_(42)).

## How it all began

<!-- References -->

[^1]:
  Noora Hyvärinen, "[Hunting for Windows Subsystem for Linux][hunting]", F-Secure White Paper, Accessed 2021-12-06

[^2]:
  Connor Morley, "[WSL 2 Research into Badness][into-badness]", F-Secure White Paper, Accessed 2021-12-06

[^3]: CheckPoint Research, "[Beware of the Bashware: A New Method for Any Malware to Bypass Security Solutions][beware-bashware]", Blog Post, Accessed 2021-12-06

<!-- URLs -->

<!-- https://blog.f-secure.com/wsl2-the-other-other-attack-surface/ -->
[into-badness]: https://img.en25.com/Web/FSecure/%7B87c32f0e-962d-4454-b244-1bb8908968d4%7D_WSL-2-RESEARCH.pdf

[hunting]: https://blog.f-secure.com/hunting-for-windows-subsystem-for-linux/

[beware-bashware]: https://research.checkpoint.com/2017/beware-bashware-new-method-malware-bypass-security-solutions/
<!-- https://www.theregister.com/2017/09/12/microsoft_downplays_bashware_malware_threat/ -->

[windows-antivirus]: https://docs.microsoft.com/en-us/archive/blogs/wsl/wsl-antivirus-and-firewall-compatibility

[elf-revshell]: https://blog.lumen.com/no-longer-just-theory-black-lotus-labs-uncovers-linux-executables-deployed-as-stealth-windows-loaders/
<!-- https://www.theregister.com/2021/09/17/windows_subsystem_for_linux_malware/ -->

[wsl-youtube]: https://www.youtube.com/watch?v=_p3RtkwstNk

<!-- Abbreviations -->

*[WSL]: Windows Subsystem for Linux
*[ELF]: Executable and Linkable Format - binary format for Unix/Linux applications
*[VMM]: Virtual Machine Monitor
