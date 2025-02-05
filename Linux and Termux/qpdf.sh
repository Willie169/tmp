Termux:

pkg install qpdf

Build from source:

git clone https://github.com/qpdf/qpdf
cd qpdf
mkdir build
cd build
cmake .. && make -j$(nproc)