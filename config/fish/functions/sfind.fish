function sfind --wraps='sudo find / -name "$argv"' --description 'alias sfind sudo find / -name "$argv"'
    sudo find / -name "$argv"
end
