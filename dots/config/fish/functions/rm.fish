function rm --wraps=trash-put --description 'alias rm trash-put'
    trash-put $argv && dunstify "Deleted: " "$argv" --timeout 3000 --replace 4409
end
