function tp --wraps=trash-put --description 'alias trash-put'
    trash-put $argv && dunstify "Moved to trash: " "$argv" --timeout 3000 --replace 4409
end
