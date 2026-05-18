function rfind --wraps='sudo find / -name' --description 'alias rfind sudo find / -name'
    sudo find / -name $argv
end
