#!/bin/bash

export VERSION=20.1
export INTEL_FPGA_HOME=/opt/intelFPGA_lite
export QUARTUS_HOME=${INTEL_FPGA_HOME}/${VERSION}/quartus/bin
export MODELSIM_HOME=${INTEL_FPGA_HOME}/${VERSION}/modelsim_ase

echo "System Upgrade..."
# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

echo "Enable X11 with xauth..."
sudo apt-get install xauth

echo "Install Quartus deps..."

sudo apt-get install -y ksh csh xterm libc6:i386 libstdc++5:i386 libstdc++6:i386 lib32z1 libstdc++6 libxss1 libjpeg62 openjdk-8-jdk libxext6:i386 libxtst6:i386 libxi6:i386 libxext6:i386 libx11-6:i386 libxft2:i386 libncurses5:i386 libbz2-1.0:i386 xauth libxdmcp-dev:i386 libxau-dev:i386 libfreetype6-dev:i386 libfontconfig:i386 expat:i386 libsm6:i386 libxrender-dev:i386 libudev-dev:i386 libsm6

# sudo ln -s /usr/bin/mawk /bin/awk
# sudo ln -s /usr/bin/basename /bin/basename
sudo ln -s /lib/x86_64-linux-gnu/libncursesw.so.5.9 /lib/libtermcap.so.2
# sudo ln -s /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/libm.so

echo "Fix libpng12..."
sudo add-apt-repository ppa:linuxuprising/libpng12
sudo apt update
sudo apt install libpng12-0

echo "Create .Xauthority..."
touch /home/vagrant/.Xauthority

echo "Install Quartus Prime..."
if [ -d "${INTEL_FPGA_HOME}/${VERSION}" ] 
then
   echo "Quartus Prime installation detected for version $VERSION." 
else
   cd /opt/media
	chmod a+x QuartusLiteSetup-20.1.0.711-linux.run
	chmod a+x ModelSimSetup-20.1.0.711-linux.run
	./QuartusLiteSetup-20.1.0.711-linux.run --mode unattended --unattendedmodeui none --accept_eula 1 --installdir "${INTEL_FPGA_HOME}/${VERSION}"
fi

sudo touch /etc/profile.d/quartus_settings.sh
echo "# IntelFPGA Quartus $VERSION" | sudo tee --append /etc/profile.d/quartus_settings.sh
echo "export PATH=$PATH:$QUARTUS_HOME:$INTEL_FPGA_HOME/$VERSION/quartus/sopc_builder/bin:$MODELSIM_HOME/bin:$INTEL_FPGA_HOME/$VERSION/modelsim_ase/linuxaloem" | sudo tee --append /etc/profile.d/quartus_settings.sh
echo 'export QSYS_ROOTDIR="$INTEL_FPGA_HOME/$VERSION/quartus/sopc_builder/bin"' | sudo tee --append /etc/profile.d/quartus_settings.sh
echo 'export QUARTUS_ROOTDIR="$QUARTUS_HOME"' | sudo tee --append /etc/profile.d/quartus_settings.sh
# echo 'export SOCEDS_DEST_ROOT="$INTEL_FPGA_HOME/$VERSION/embedded"' | sudo tee --append /etc/profile.d/quartus_settings.sh
sudo chmod +x /etc/profile.d/quartus_settings.sh

echo "\n# IntelFPGA Quartus $VERSION" >> ~/.bashrc
echo "source /etc/profile.d/quartus_settings.sh" >> ~/.bashrc
echo "\n" >> ~/.bashrc

echo "\n# IntelFPGA Quartus $VERSION" >> ~/.zshrc
echo "source /etc/profile.d/quartus_settings.sh" >> ~/.zshrc
echo "\n" >> ~/.zshrc

echo "Enable USB Blaster..."
sudo cp /opt/intelFPGA_lite/99-usbblaster.rules /etc/udev/rules.d/
udevadm control --reload
sudo mkdir jtagd
sudo cp /opt/intelFPGA_lite/pgm_parts.txt /etc/jtagd/jtagd.pgm_parts
sudo chown vagrant:vagrant /etc/jtagd/jtagd.pgm_parts
sudo chmod 0644 /etc/jtagd/jtagd.pgm_parts

##################################################
#             ModelSim Configuration             #
##################################################
### Download freetype 2.4.12 lib
cd /vagrant/v_home
wget http://download.savannah.gnu.org/releases/freetype/freetype-2.4.12.tar.bz2
tar -jxvf freetype-2.4.12.tar.bz2
cd freetype-2.4.12

sudo apt-get install -y libpng-dev gcc-multilib g++-multilib \
                        lib32z1 lib32stdc++6 lib32gcc1 expat:i386 \
                        fontconfig:i386 libfreetype6:i386 libexpat1:i386 \
                        libc6:i386 libgtk-3-0:i386 libcanberra0:i386 \
                        libice6:i386 libsm6:i386 \
                        libncurses5:i386 zlib1g:i386 libx11-6:i386 \
                        libxau6:i386 libxdmcp6:i386 libxext6:i386 \
                        libxft2:i386 libxrender1:i386 libxt6:i386 \
                        libxtst6:i386 zlib1g-dev:i386

sudo ln -s /lib/x86_64-linux-gnu/libz.so.1.2.11 /lib/x86_64-linux-gnu/libzlib.so
sudo ln -s /lib/i386-linux-gnu/libz.so.1.2.11 /lib/i386-linux-gnu/libzlib.so
sudo ln -s /usr/lib/i386-linux-gnu/libpng12.so.0 /usr/lib/i386-linux-gnu/libpng12.so    

### Build freetype
./configure --build=i686-pc-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
make -j$(nproc)

sudo mkdir $MODELSIM_HOME/lib32
sudo cp ./objs/.libs/libfreetype.so* $MODELSIM_HOME/lib32
cd ../
rm -rf ./freetype-2.4.12

### Manual edition steps:
### TODO: Automate this too!
echo \\n'A few manual steps are needed to make ModelSim work!'
echo \\n'In the line below "dir=`dirname $arg0`" at line 50 of '${MODELSIM_HOME}'/vco add the following in a new line:'
echo 'export LD_LIBRARY_PATH=${dir}/lib32'
echo \\n'[Press any key to open the file in the correct line to be edited]'
read -n 1 keypress
chmod 755 $MODELSIM_HOME/vco
sudo nano +51,0 $MODELSIM_HOME/vco

echo \\n'Replace line 210 of $MODELSIM_HOME/vco with the following:'
echo ' *)                vco="linux" ;;'
echo \\n'[Press any key to open the file in the correct line to be edited]'
read -n 1 keypress
sudo nano +211,0 $MODELSIM_HOME/vco

echo \\n'Quartus and ModelSim installation and configuration finished!'
