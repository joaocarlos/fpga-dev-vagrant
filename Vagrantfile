#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# This Vagrantfile sets up a Ubuntu based sandbox environment for running
# tools to support FPGAs from IntelFPGAs.

# Quartus 20.1 via X11, on an x64 architecture and using USB Blaster


# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.synced_folder "./tools/media","/opt/media", disabled: true
  config.vm.synced_folder "./tools/intelFPGA_lite","/opt/intelFPGA_lite", disabled: false
  config.vm.synced_folder "./tools/xilinx","/opt/Xilinx", disabled: true
  config.vm.synced_folder "./vagrant","/vagrant", disabled: false
  config.vm.synced_folder "~/Code/fpga","/FPGA", disabled: true

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true
  config.vm.hostname = "fpga-dev"

  config.vm.provider :virtualbox do |vb|
    vb.linked_clone = true
    vb.name = "fpga-dev" 
    vb.gui = false
    vb.customize ["modifyvm", :id, "--macaddress1", "080027e34021"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ['modifyvm', :id, '--memory', '4096']
    vb.customize ["modifyvm", :id, "--vram", "12"]
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "on"]
    vb.customize ["usbfilter", "add", "0", 
      "--target", :id, 
      "--name", "50cd6786-d783-4494-9b37-65fe8af75bb1",
      "--vendorid", "0x09fb",
      "--productid", "0x6001",
      "--manufacturer", "Altera",
      "--product", "USB-Blaster"]
    vb.customize ["usbfilter", "add", "0",
      "--target", :id,
      "--name", "9dc7b780-9ec0-11d4-a54f-000a27052861",
      "--vendorid", "0x09fb",
      "--productid", "0x6001",
      "--manufacturer", "Altera",
      "--product", "USB-Blaster"]
  end

  config.vm.define :dev do |dev|
    # Port mappings for various services inside the VM
    dev.vm.provision :shell, path: "vagrant/bootstrap.sh"
  end
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
    config.vbguest.no_install = false
    config.vbguest.no_remote = false
  end
end
