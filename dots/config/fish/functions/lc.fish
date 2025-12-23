function lc --wraps='eza -l -a --no-filesize --no-permissions --no-user --no-time --blocksize' --description 'cooler ls'
    eza -l -a --no-filesize --no-permissions --no-user --no-time --blocksize $argv
end
