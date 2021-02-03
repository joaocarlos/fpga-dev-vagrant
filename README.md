# Vagrant Environment for FPGA Development.

I created this repo based on https://github.com/chrisesharp/fpga-dev-env in order to support my FPGA development, since I run my tools on a MacBook Pro. Unfortunately, Intel FPGA tools seem to support Linux in a fairly limited way as their only Unix variant. This means that if I want to use their tools on my Mac, I have to run them in a VM.

<!-- Although the bootstrap does the hard work for you, some manual steps are needed in order to this script work properly. This is entirely due to some of the tools not being downloadable without going through a web form, or having to acquire a license file. -->

- Download Quartus Prime Lite from the Intel FPGA website is done unattended, but you can use the individual files download, and download the specific devices libraries.
  Copy the downloaded file to tools/media/intel.

- Create a directory under your home directory called ~/Code/fpga This will be mounted in your vagrant vm as /FPGA. You can change the line in the Vagrantfile to be from anywhere and to anywhere you like.

- Support for other FPGA vendor tools will coming as far as I need it. _Contributions are welcome!_

## Instructions

First clone this repository and make sure you have VirtualBox and Vagrant configured. Then try `vagrant up` and hopefully everything will work like a charm. If you need to forward X through Vagrant SSH, make sure you have `xquartz` installed.
