#!/bin/bash
#Script Name    :setup_new_user.sh
#Description    :Does initial setup for a newly created user, posibly on a new host
#Author         :Emil Dragu
#Email          :emil.dragu@gmail.com
#
#Usage:
# ./setup_new_user.sh
#
VIMFILE=~/.vimrc
echo "==Git=="
git config --global user.name "Emil Dragu"
git config --global user.email emil.dragu@gmail.com
echo "Done"
echo "==VIM=="
width_extra=80
indentation=4
sudo yum install -y vim 2>&1 > /dev/null
mkdir -p ~/.vim/templates

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cp -pr $DIR/../vim/templates/* ~/.vim/templates/

cat << VIMRCLOCAL > $VIMFILE
" Created by $0
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
highlight ExtraWhitespace ctermbg=red guibg=red
match OverLength /\\%${width_extra}v.\\+/
match ExtraWhitespace /\s\+$/
set background=dark
set expandtab shiftwidth=${indentation} softtabstop=${indentation}
au FileType ruby setlocal tabstop=${indentation} expandtab shiftwidth=${indentation} softtabstop=${indentation}

if has("autocmd")
  augroup templates
    autocmd BufNewFile *.* silent! execute '0r $HOME/.vim/templates/skeleton.'.expand("<afile>:e")
    autocmd BufNewFile * %substitute#\[:VIM_EVAL:\]\(.\{-\}\)\[:END_EVAL:\]#\=eval(submatch(1))#ge
  augroup END
endif
VIMRCLOCAL

echo "Done"

