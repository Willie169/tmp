sudo apt install xfce4 xfce4-goodies python3-all-dev python3-venv build-essential cmake curl wget git gh openjdk-17-jdk nano vim iproute2 procps grep libboost-all-dev gdb tmux
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 -m venv myenv
source myenv/bin/activate
python3 get-pip.py
pip3 install numpy sympy matplotlib setuptools selenium jupyter pandas