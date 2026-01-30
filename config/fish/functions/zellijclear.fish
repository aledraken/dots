function zellijclear --wraps=zellij --description 'delete all zellij sessions'
    zellij kill-all-sessions
    zellij delete-all-sessions
    zellij ls
end
