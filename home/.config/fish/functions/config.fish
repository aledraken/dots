function config --wraps='git --git-dir=$HOME/Projects/dotfiles/ --work-tree=$HOME' --wraps='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME' --wraps='git --git-dir=$HOME/Projects/dotfiles/ --work-tree=$HOME/Projects/' --wraps='git --git-dir=$HOME/Projects/dotfiles --work-tree=$HOME' --wraps='git --git-dir=$HOME/Projects/dotfiles-bare --work-tree=$HOME' --description 'alias config git --git-dir=$HOME/Projects/dotfiles-bare --work-tree=$HOME'
    git --git-dir=$HOME/Projects/dotfiles-bare --work-tree=$HOME $argv
end
