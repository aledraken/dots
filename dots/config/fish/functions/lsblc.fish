function lsblc --wraps='lsblk | bat -l conf' --description 'cooler lsblk'
    lsblk | bat -l conf $argv
end
