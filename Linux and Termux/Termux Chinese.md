Fail

unset LD_PRELOAD
export PATH=$PREFIX/glibc/bin:$PATH
sed -i 's/^#zh_TW.UTF-8 UTF-8/zh_TW.UTF-8 UTF-8/' $PREFIX/glibc/etc/locale.gen
locale-gen
mkdir ~/.fonts
cd ~/.fonts

wget https://github.com/zanjie1999/windows-fonts/raw/wine/msyh.ttc

或其他字型