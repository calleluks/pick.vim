if !exists("g:pick_executable")
  let g:pick_executable = "pick -X"
endif

if exists("g:pick_height")
  let g:pick_executable = "env LINES=" . g:pick_height . " " . g:pick_executable
endif

function! PickCommand(choice_command, pick_args, vim_command)
  try
    let pick_command = a:choice_command . " | " . g:pick_executable . " " . a:pick_args
    if exists("*systemlist")
      let selection = systemlist(pick_command)[0]
    else
      let selection = substitute(system(pick_command), '\n$', '', '')
    endif
    redraw!
    if v:shell_error == 0
      try
        exec a:vim_command . " " . fnameescape(selection)
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
  call PickBufferCommand(":buffer")
endfunction

function! PickTag()
  call PickCommand(s:TagCommand(), "", ":tag")
endfunction

function! PickBufferCommand(vim_command)
  call PickCommand(s:BufferListCommand(), "", a:vim_command)
endfunction

function! s:FileListCommand()
  let command = ""

  if s:IsGitRepo()
    let command = s:GitListCommand(".")
  else
    let command = "find * -type f"
  endif

  return command
endfunction

function! s:GitListCommand(file)
  return "git ls-files " . a:file . " --cached --exclude-standard --others"
endfunction

function! s:IsGitRepo()
  return system("git ls-files " . expand("%") . " --cached --exclude-standard --others --error-unmatch 2> /dev/null ; echo $?") == 0
endfunction

function! s:BufferListCommand()
  let bufnrs = filter(range(1, bufnr("$")), 'buflisted(v:val)')
  let buffers = map(bufnrs, 'bufname(v:val)')
  return 'echo "' . join(buffers, "\n") . '"'
endfunction

function! s:TagCommand()
  let tag_files = join(tagfiles(), " ")

  return "cat " . tag_files . " 2> /dev/null | awk -F$'\t' '{print $1}' | sort -u | grep -v '^!'"
endfunction
