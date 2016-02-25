A plugin to develop ALICE software using aliBuild. In particular you
can:

- Compile development packages which have been checked out in
  development mode by using `:make`
- Have instant feedback on compilation 
- Define new development packages (by default it defines AliRoot, AliPhysics
  and O2) 

# How to install

## Using pathogen

If you use [Pathogen](https://github.com/tpope/vim-pathogen) simply clone
vim-alice in your `~/.vim/bundle` directory.

# Optional settings:

The plugin does it's best to provide reasonable defaults for your environment,
you can however tweak a few things:

- Where to locate the software installed by aliBuild

    let g:alibuild_prefix = "~/alice/sw"

- Where to find homebrew installed software (Mac only)

    let g:homebrew_prefix="/urs/local"

# Dependencies

This plugin works better together with
[Syntastic](https://github.com/scrooloose/syntastic).
