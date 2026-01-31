function mount --wraps='sudo mount' --description 'Mount but yas'
    sudo mount -o rw,user,uid=1000,dmask=007,fmask=117 $argv
end
