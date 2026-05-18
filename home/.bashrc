#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
PS1='[\u@\h \W]\$ '

alias start-qtile='qtile start -b wayland'
alias mount-fat='sudo mount -o uid=1000'
alias vim='nvim'

export SUDO_EDITOR='/usr/sbin/nvim'
export EDITOR='/usr/sbin/nvim'
