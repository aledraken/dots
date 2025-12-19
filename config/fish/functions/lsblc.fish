function lsblc --wraps='lsblk | bat -l conf' --description 'alias lsblc lsblk | bat -l conf'
    lsblk | bat -l conf $argv
end
