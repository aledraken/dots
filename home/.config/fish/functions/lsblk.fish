function lsblk --description 'alias lsblk lsblk | bat -l conf --style plain'
    command lsblk | bat -l conf --style plain $argv
end
