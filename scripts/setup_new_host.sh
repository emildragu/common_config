#!/bin/bash
#Script Name	:setup_new_host.sh
#Description	:Does initial setup on newly created hosts
#Args           :[DOCKER_VERSION]
#Author       	:Emil Dragu
#Email         	:emil.dragu@gmail.com
#
#Usage:
# ./setup_new_host.sh
#
echo "==Git=="
git config --global user.name "Emil Dragu"
git config --global user.email emil.dragu@gmail.com
echo "Done"
echo "==VIM=="
width_extra=80
indentation=4
yum install -y vim 2>&1 > /dev/null
grep  -e '^source /etc/vimrc.local' /etc/vimrc
if [ "$?" != "0" ]; then
    echo 'source /etc/vimrc.local' >> /etc/vimrc
fi
if [ ! -f /etc/vimrc.local ]; then
cat << VIMRCLOCAL > /etc/vimrc.local
" Created by $0
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
highlight ExtraWhitespace ctermbg=red guibg=red
match OverLength /\\%${width_extra}v.\\+/
match ExtraWhitespace /\s\+$/
set background=dark
set expandtab shiftwidth=${indentation} softtabstop=${indentation}
au FileType ruby setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2
VIMRCLOCAL
fi
echo "Done"
