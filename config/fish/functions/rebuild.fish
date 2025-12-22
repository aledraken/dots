function rebuild --wraps='sudo nixos-rebuild switch --flake ~/Nix#nixos' --description 'Easier rebuild for nix'
    sudo nixos-rebuild switch --flake ~/Nix#nixos $argv
end
