function lc --description 'Advanced ls'
    exa -lA --group-directories-first --modified --total-size --time-style='+%d-%M-%y %H:%M' $argv
end
