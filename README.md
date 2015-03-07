# pick.vim

Functions for using [pick] from within Vim.

***Please note:*** pick requires a fully functional terminal to run therefore
cannot be run from within gvim or MacVim.

[pick]: https://github.com/thoughtbot/pick/

## Installation

Recommended installation with [Vundle]:

```viml
Plugin 'thoughtbot/pick.vim'
```

[Vundle]: https://github.com/gmarik/Vundle.vim/

## Usage

pick.vim provides the following functions:

### `PickFile()`

Pick a file to edit.

If you are working from within a git repository, `PickFile()` will use `git
ls-files` to get the files to pick from. If not, it will use `find`.

### `PickFileSplit()`

Pick a file to edit in a new split.

### `PickFileVerticalSplit()`

Pick a file to edit in a new vertical split.

### `PickFileTab()`

Pick a file to edit in a new tab.

### `PickBuffer()`

Pick a buffer to edit.

### `PickCommand(choice_command, pick_args, vim_command)`

Run the `choice_command` in from the shell and pipe the results to pick run with
`pick_args` and call the `vim_command` with the selected choice.

For example, you could implement `PickFile()` like this:

```viml
call PickCommand("find * -type f", "", ":edit")
```

### Configuration

Add your preferred key mappings to your `.vimrc` file:

```viml
nnoremap <Leader>p :call PickFile()<CR>
nnoremap <Leader>s :call PickFileSplit()<CR>
nnoremap <Leader>v :call PickFileVerticalSplit()<CR>
nnoremap <Leader>t :call PickFileTab()<CR>
nnoremap <Leader>b :call PickBuffer()<CR>
```

The name of the pick executable can be configured with:

```viml
let g:pick_executable = "pick"
```

## Copyright

Copyright (c) 2014 Calle Erlandsson & thoughtbot, Inc.

Lead by Calle Erlandsson & thoughtbot, Inc.
