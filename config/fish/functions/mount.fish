function mount --wraps='sudo mount -o rwx,user,uid=1000,dmask=007,fmask=117' --description 'alias mount sudo mount -o rwx,user,uid=1000,dmask=007,fmask=117'
    sudo mount -o rwx,user,uid=1000,dmask=007,fmask=117 $argv
end
