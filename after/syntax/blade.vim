" Override para comentários Blade - tem prioridade sobre HTML syntax
" Este arquivo é carregado DEPOIS do syntax/blade.vim principal

" Limpa todas as definições anteriores de bladeComment
syntax clear bladeComment

" Define comentários Blade com maior prioridade
" containedin=ALL garante que funcione dentro de qualquer região HTML
syntax region bladeComment start="{{--" end="--}}" keepend containedin=ALL

" Força o highlight link para Comment
highlight! link bladeComment Comment
