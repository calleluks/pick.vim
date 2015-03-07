if !exists("g:pick_executable")
  let g:pick_executable = "pick"
endif

function! PickCommand(choice_command, pick_args, vim_command)
  try
    let selection = system(a:choice_command . " | " . g:pick_executable . " " . a:pick_args)
    redraw!
    if v:shell_error == 0
      try
        exec a:vim_command . " " . selection
      catch /E325/
      endtry
    endif
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from pick on the screen
    redraw!
  endtry
endfunction

function! PickFile()
    call PickCommand(s:FileListCommand(), "", ":edit")
endfunction

function! PickFileVerticalSplit()
    call PickCommand(s:FileListCommand(), "", ":vsplit")
endfunction

function! PickFileSplit()
    call PickCommand(s:FileListCommand(), "", ":split")
endfunction

function! PickFileTab()
    call PickCommand(s:FileListCommand(), "", ":tabedit")
endfunction

function! PickBuffer()
    call PickCommand(s:BufferListCommand(), "", ":buffer")
endfunction

function! s:FileListCommand()
  let l:command = ""

  if isdirectory(".git")
    let l:command = s:GitListCommand(".")
  endif

  if strlen(l:command) < 1
    let l:output = system("git rev-parse --show-toplevel")
    if v:shell_error == 0
      let l:output = substitute(l:output, "\\n", "", "")
      let l:command = s:GitListCommand(l:output)
    else
      let l:command = "find * -type f -o -type l"
    endif
  endif

  return l:command
endfunction

function! s:GitListCommand(directory)
  return "git ls-files " . a:directory . " --cached --exclude-standard --others"
endfunction

function! s:BufferListCommand()
  let bufnrs = filter(range(1, bufnr("$")), 'buflisted(v:val)')
  let buffers = map(bufnrs, 'bufname(v:val)')
  return 'echo "' . join(buffers, "\n") . '"'
endfunction
