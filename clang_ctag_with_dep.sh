#!/bin/bash

# ./clang_ctags_with_dep.sh file1.c file2.c ... to generate a tags file for these files.

echo "Generating Tags for $* with clang"
echo "..."
# 1. tr " " "\n" # replace space with new line
# 2. tr "\\" "\n" # replace \ with new line
# 3. sed -e '/^\s*$/d' -e '/\.o:*$/d' # remove empty lines and .o files
FILES="$(clang++ -M -I/opt/local/include $* |  \
    tr " " "\n" | \
    tr "\\" "\n"| \
    sed -e '/^\s*$/d' -e '/\.o:*$/d')"

# loop through the output
# if the line is with directory, convert it to relative path.
while IFS=$'\n' read -ra ADDR; do
     for i in "${ADDR[@]}"; do
        # process "$i"
        if [[ $i == /* ]]
        then
            python -c "import os, sys; print os.path.relpath('$i', os.getcwd())"
        else
            echo $i
        fi
     done
done <<< "$FILES" | \
# now generate tags from stdin which is piped from previous loop
/usr/local/bin/ctags -L - --c++-kinds=+p --fields=+iaS --extra=+q --language-force=c++

echo "Done"
