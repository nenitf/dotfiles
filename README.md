# dotfiles

[![emojicom](https://img.shields.io/badge/emojicom-%F0%9F%90%9B%20%F0%9F%86%95%20%F0%9F%92%AF%20%F0%9F%91%AE%20%F0%9F%86%98%20%F0%9F%92%A4-%23fff)](https://gist.github.com/nenitf/1cf5182bff009974bf436f978eea1996#emojicom)

## TL;DR
Versionamento dos meus arquivos de configuração, scripts ou templates usados no Windows e/ou Linux.

Os arquivos são guardados e referenciados principalmente através do path ``~/dev/dotfiles/``, portanto é imprescindível manter esta mesma estrutura.

## Programas
* bash
* git
* vim
* emacs/doom

## Estrutura do repositório

- [arquivados/](arquivados/): configurações antigas de programas que não uso
- [modelos/](/modelos): arquivos que frequentemente preciso ver ou copiar
    - [latex/](/modelos/latex): templates/classes latex
    - [sample-dot-graph/](/modelos/sample-dot-graph): exemplos da utilização de graphviz
    - [git/](/modelos/git): arquivos usados com git ou github
- [emacs/](/emacs): arquivos de configuração do [emacs](https://www.gnu.org/software/emacs/) com o [doom](https://github.com/hlissner/doom-emacs)
    - [doom/](/emacs/doom): configurações do doom
    - [org/](/emacs/org): anotações com [org mode](https://orgmode.org/)
- [vim/](/vim): arquivos de configuração do [vim](https://www.vim.org/)
    - [doc/wtf.txt](/vim/doc/wtf.txt): documentação das minhas configurações (`:h wtf`)
    - [ftplugin/](/vim/ftplugin): especificações de `filetypes`
    - [syntax/](/vim/syntax): sintaxes específicas de `filetypes`
    - [dicionarios/](/vim/dicionarios/): dicionários usados para sugerir palavras
    - [colors/](/vim/colors/): definição de cores para grupos de highlights (colorschemes)
    - [skeletons/](/vim/skeletons/): estrutura inicial de tipos de arquivos
    - [clone-packages.sh](/vim/clone-packages.sh): download de packages (plugins)
    - [dotfiles.vim](/vim/dotfiles.vim): configurações do vim caso este projeto seja clonado por inteiro, pois ele considera estrutura de pastas
    - [plus.vim](/vim/plus.vim): configurações a mais que podem afetar performance do vim
    - [gvimrc](/gvim/gvimrc): configurações de interface gráfica do gvim
    - [packages.vim](/vim/packages.vim): configurações específicas de packages do vim
    - [vimrc](/vim/vimrc): configurações do vim, funciona de maneira independente do projeto
    - [vi](/vim/vi): configurações do vi, usado em servidores sem vim. Deve ser posto em `.vimrc`
        - `curl https://raw.githubusercontent.com/nenitf/dotfiles/main/vim/vi > $HOME/.vimrc`
        - `wget https://raw.githubusercontent.com/nenitf/dotfiles/main/vim/vi -O $HOME/.vimrc`
- [wiki/](/wiki): anotações pessoais
- [.bashrc](bash.rc): configurações bash (alias, path, functions, ps e etc).
- [.gitconfig](.config): configuração do git
- [index.html](index.html): redirecionamento do github-pages para o script de instalação
- [install.sh](install.sh): "instalação" dos arquivos de configuração no Linux e Windows

## Download
### Parcial do vim
Caso queira somente a configuração básica do vim, basta copiar o conteúdo de [vimrc](/vim/vimrc) e [gvimrc](/vim/gvimrc) para respectivamente:
- `%userprofile%\_vimrc` e `%userprofile%\_gvimrc` no Windows
```sh
curl https://raw.githubusercontent.com/nenitf/dotfiles/main/vim/vimrc > %userprofile%\_vimrc
curl https://raw.githubusercontent.com/nenitf/dotfiles/main/vim/gvimrc > %userprofile%\_gvimrc
```
- `$HOME/.vimrc` e `$HOME/.gvimrc` no Linux
```sh
wget https://raw.githubusercontent.com/nenitf/dotfiles/main/vim/vimrc -O $HOME/.vimrc
wget https://raw.githubusercontent.com/nenitf/dotfiles/main/vim/gvimrc -O $HOME/.gvimrc
```

### Completa no Linux
```bash
cd ~
mkdir dev
cd dev
git clone https://github.com/nenitf/dotfiles.git
cd dotfiles
./install.sh
vim -c "helptags vim/doc" -c q
```

### Completa no Windows
```bash
# no git bash
cd ~
mkdir dev
cd dev
git clone https://github.com/nenitf/dotfiles.git
cd dotfiles
./install.sh
vim -c "helptags vim/doc" -c q
```

## Atualização forçada
```bash
git fetch --all
git reset --hard origin/main
```

## Adendos

### Vim

- Caso precise configurar scripts que devem rodar **antes** do `vim/vimrc`, crie o arquivo `~/.vimrc-pre.vim` (equivale `%userprofile%\.vimrc-pre.vim` no Windows).
- Caso precise configurar scripts que devem rodar **depois** do `vim/vimrc`, crie o arquivo `~/.vimrc-local.vim` (equivale `%userprofile%\.vimrc-local.vim` no Windows).
- Caso precise configurar scripts que devem rodar **depois** do `vim/gvimrc`, crie o arquivo `~/.gvimrc-local.vim` (equivale `%userprofile%\.gvimrc-local.vim` no Windows).
- Utilize os helptags (`:h wtf`) gerados para saber mais sobre os detalhes das configurações (exemplo: `:h wtf-autocomplete`).

## TODO
* [ ] Windows CMD/PS: Alias para git
* [ ] Windows CMD/PS: Output como UTF-8 para ver acentuações nos commits
* [ ] Tornar local dos dotfiles mais dinâmico
