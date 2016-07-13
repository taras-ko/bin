#!/bin/zsh

dir=${1:-.}
cs_target=${2:-cpp}

targets=(cpp py yocto)

on_error()
{
    echo "Nothing to do with: $cs_target"
    echo "Targets are: ${targets[*]}"
    exit 1
}

trap 'on_error' ERR

cs_cpp()
{
    find $dir -path './git*' -prune -o \
        -path './.pc*' -prune -o \
    \( -name '*.[ch]' -o -name '*.cpp' -o -name '*.hpp' -o -iname '*makefile*' -o -name CMakeLists.txt \) -print >cscope.files
}

cs_yocto()
{
    find $dir -path './BUILD' -prune -o ! -type l \( -name '*.conf' -o -name '*.bb' -o -name '*.bbclass' -o -name '*.bbappend' -o -name '*.inc' \) -print >cscope.files
}

cs_py()
{
    find $dir -path './git*' -prune -o \( -name '*.py' -o -name '*.c' -o -name '*.sh' -o -name '*.list' -o -name '*.llist' \) -print >cscope.files
}

cs_qml()
{
    find $dir -path './git*' -prune -o \( -name '*.[ch]' -o -name '*.cpp' -o -name '*.hpp' -o -iname '*makefile*' -o -name CMakeLists.txt -o -name '*.qml' -o -name '*.pro' \) -print >cscope.files
}



echo "Building target for: $cs_target"
cs_$cs_target $@

cscope -bqk && rm cscope.files && echo "Done!"
