#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
PS1='[\u@\h \W]\$ '
export SUDO_EDITOR='/usr/sbin/nvim'
