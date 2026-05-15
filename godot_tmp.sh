cd ~/.local
gh_latest -w --wget_option '--tries=100 --retry-connrefused --waitretry=5' godotengine/godot Godot_*-stable_mono_linux_x86_64.zip
unzip Godot_*-stable_mono_linux_x86_64.zip
rm Godot_*-stable_mono_linux_x86_64.zip
mv Godot_*-stable_mono_linux_x86_64 godot
ln -s ~/.local/godot/Godot_*-stable_mono_linux.x86_64 ~/.local/bin/godot
cd ~/.local/godot
wget --tries=100 --retry-connrefused --waitretry=5 https://raw.githubusercontent.com/godotengine/godot/refs/heads/master/icon.png
cd ~
cat > ~/.local/share/applications/godot.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Godot Engine
Comment=Develop your 2D & 3D games, cross-platform projects, or even XR ideas
Exec=$HOME/.local/bin/godot %f
Icon=$HOME/.local/godot/icon.png
Terminal=false
Categories=Development;IDE;
StartupNotify=true
EOF

