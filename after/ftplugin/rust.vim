" Efficient Rust folding configuration

" Simplified folding expression that's much faster than full parsing
function! FastRustFold()
    let line = getline(v:lnum)
    
    " Start fold at block comment start
    if line =~ '^\s*/\*'
        return '>1'
    endif
    
    " End fold at block comment end
    if line =~ '\*/'
        return '<1'
    endif
    
    " Start fold at consecutive line comments
    if line =~ '^\s*//'
        let prev = v:lnum > 1 ? getline(v:lnum - 1) : ''
        let next = getline(v:lnum + 1)
        if prev !~ '^\s*//' && next =~ '^\s*//'
            return '>1'
        elseif prev =~ '^\s*//' && next !~ '^\s*//'
            return '<1'
        endif
    endif
    
    " Start fold at main Rust constructs
    if line =~ '^\s*\(pub\s\+\)\?\(fn\|impl\|trait\|struct\|enum\|mod\)\s.*{'
        return '>1'
    endif
    
    " Simple brace counting for fold levels
    if line =~ '{\s*$'
        return 'a1'
    endif
    if line =~ '^\s*}'
        return 's1'
    endif
    
    return '='
endfunction

function! GetRustFoldMethod()
    let lines = line('$')
    " For very large files, use the fast custom folding
    if lines > 2000
        setlocal foldmethod=expr
        setlocal foldexpr=FastRustFold()
    elseif lines > 500
        " For medium files, use indent with manual comment folding
        setlocal foldmethod=indent
        setlocal foldignore=
    else
        " For small files, use full treesitter
        setlocal foldmethod=expr
        setlocal foldexpr=nvim_treesitter#foldexpr()
    endif
    setlocal foldlevelstart=99
    setlocal foldnestmax=10
    setlocal foldenable
endfunction

" Apply the appropriate folding method
call GetRustFoldMethod()

" Commands to switch between folding methods
command! -buffer RustTreesitterFold setlocal foldmethod=expr | setlocal foldexpr=nvim_treesitter#foldexpr()
command! -buffer RustFastFold setlocal foldmethod=expr | setlocal foldexpr=FastRustFold()
command! -buffer RustIndentFold setlocal foldmethod=indent