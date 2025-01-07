# nano
pkg install nano
# Python
pkg install python
# cpp
pkg install clang
# Create a .py file and open it in nano text editor 
nano filename.py
# Create a .cpp file and open it in nano text editor 
nano filename.cpp
# Run a .py file
python filename.py
# Run Python command (exit with exit())
python
# Compile a .cpp file (If no -o option, an output file with name a.out will be generated.)
clang++ filename.cpp -o outfilename
# Run cpp (outfile has no file extension) (delete the .cpp file won't impact the outfile execution)
./outfilename
