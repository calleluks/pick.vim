# pick.vim

Functions for using [pick] from within Vim.

***Please note:*** pick requires a fully functional terminal to run therefore
cannot be run from within gvim or MacVim.

[pick]: https://github.com/calleerlandsson/pick/

## Installation

Recommended installation with [Vundle]:

```viml
Plugin 'calleerlandsson/pick.vim'
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

### `PickTag()`

Pick a tag to jump to, open it with `:tag`

### `PickSplitTag()`

Pick a tag to jump to, open it with `:stag`

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
nnoremap <Leader>] :call PickTag()<CR>
```

The name of the pick executable can be configured with:

```viml
let g:pick_executable = "pick -K"
```

The `-K` is useful when running `pick(1)` from within another interactive
program (like `vim(1)`) which does not re-enable keyboard transmit mode after
executing an external program.

The maximum number of lines used when drawing the pick interface can be limited:

```viml
let g:pick_height = 10
```

## Copyright

Copyright (c) 2017 Calle Erlandsson, Teo Ljungberg & thoughtbot.
