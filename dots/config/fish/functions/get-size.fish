function get-size --wraps='.cache/ | bat -l conf' --wraps='du -hs' --description 'alias get-size du -hs'
    du -hs $argv
end
