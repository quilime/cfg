# dotfiles


Note that the only two differences between using a bare and non-bare repository are:

presence of the  --bare flag when initialising and cloning the repo
the path to the Git directory,  $HOME/.cfg/ for bare and $HOME/.cfg/.git/ for non-bare.

### Using a non-bare repository:

1. git init $HOME/.cfg
2. alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/.git/ --work-tree=$HOME'
3. echo "alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/.git/ --work-tree=$HOME'" >> $HOME/.zsh/aliases
4. cfg config --local status.showUntrackedFiles no
5. cfg add .vimrc + config commit -m "add .vimrc" + Set up a remote repository on GitHub or your Git server of choice + config push

### Install

1. echo ".cfg" >> .gitignore
2. git clone <remote-git-repo-url> $HOME/.cfg
3. alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/.git --work-tree=$HOME'
4. cfg config --local status.showUntrackedFiles no
5. cfg checkout

### Using a bare repository

1. git init --bare $HOME/.cfg
2. alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
3. echo "alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.zsh/aliases
4. cfg config --local status.showUntrackedFiles no
5. cfg add .vimrc + cfg commit -m "add .vimrc" + set up a remote repository on GitHub or your Git server of choice + cfg push

### Install

1. echo ".cfg" >> .gitignore
2. git clone --bare <remote-git-repo-url> $HOME/.cfg
3. alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
4. cfg config --local status.showUntrackedFiles no
5. cfg checkout


### References, Links

- https://www.ackama.com/blog/posts/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained
- https://www.atlassian.com/git/tutorials/dotfiles
- https://bitbucket.org/durdn/cfg/src/master/
- https://news.ycombinator.com/item?id=11070797
