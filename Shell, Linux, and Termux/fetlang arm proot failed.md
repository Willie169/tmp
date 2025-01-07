git clone https://github.com/fetlang/fetlang
cd fetlang
meson setup --buildtype=release src build
cd build
ninja
ninja test
ninja install
fetlang ../examples/hello.fet && ./a.out