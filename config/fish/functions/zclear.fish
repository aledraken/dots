function zclear --wraps=zellij --description 'delete all zellij sessions'
    zellij kill-all-sessions -y
    zellij delete-all-sessions -fy
    zellij ls
end
