if status is-interactive
# Commands to run in interactive sessions can go here
end

abbr vim nvim
abbr mount 'sudo mount -o rw,user,uid=1000,dmask=007,fmask=117'
abbr umount 'sudo umount'
abbr eject 'sudo eject'

starship init fish | source
enable_transience
