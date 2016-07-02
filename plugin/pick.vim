if !exists("g:pick_executable")
  let g:pick_executable = "pick -X"
endif

if exists("g:pick_height")
  let g:pick_executable = "env LINES=" . g:pick_height . " " . g:pick_executable
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

function! PickTag()
  call PickCommand(s:TagCommand(), "", ":tag")
endfunction

function! s:FileListCommand()
  let l:command = ""

  if s:IsGitRepo()
    let l:command = s:GitListCommand(".")
  else
    let l:command = "find * -type f"
  endif

  return l:command
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
  let l:tag_files = join(tagfiles(), " ")

  return "cat " . l:tag_files . " 2> /dev/null | awk -F$'\t' '{print $1}' | sort -u | grep -v '^!'"
endfunction
