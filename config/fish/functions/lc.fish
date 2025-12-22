function lc --wraps='eza -l --no-filesize --no-permissions --no-user --no-time --blocksize' --description 'cooler ls'
    eza -l --no-filesize --no-permissions --no-user --no-time --blocksize $argv
end
