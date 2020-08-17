# fpga-dev-vagrant
Vagrant setup for FPGA Development.

I created this repo  based on https://github.com/chrisesharp/fpga-dev-env in order to support my FPGA development, since I run my tools on a Macbook Pro. Unfortunately, Intel FPGA tools seem to support Linux in a fairly limited way as their only Unix variant. This means that if I want to use their tools on my Mac, I have to run them in a VM.

Although the bootstral does the hard work for you, some manual steps are needed in order to this script work propperly. This is entirely due to some of the tools not being downloadable without going through a web form, or having to acquire a license file.

* Download Quartus Prime Lite from the Intel FPGA website. Use the individual files download, and download the specific devices libraries.
Copy the downloaded file to tools/media.

* Download ModelSim from the Intel FPGA website. Use the individual files download.
Copy the downloaded file to tools/media.

* Download Quartus Prime Help from the Intel FPGA website. Use the individual files download.
Copy the downloaded file to tools/media.

* Create a directory under your home directory called ~/Code/fpga This will be mounted in your vagrant vm as /FPGA. You could, ofcourse, change the line in the Vagrantfile to be from anywhere and to anywhere you like.
