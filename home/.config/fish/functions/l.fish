function l --description 'Slightly more readable ls'
    command ls -lAh --color=always --group-directories-first $argv
end
