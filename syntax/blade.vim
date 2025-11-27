" Load HTML syntax first
runtime! syntax/html.vim
if exists("b:current_syntax")
  unlet b:current_syntax
endif

" Blade directives - VERMELHO/ROSA bold
syntax match bladeDirective "@\(if\|elseif\|else\|endif\|unless\|endunless\|isset\|empty\)"
syntax match bladeDirective "@\(foreach\|endforeach\|forelse\|empty\|for\|endfor\|while\|endwhile\|break\|continue\)"
syntax match bladeDirective "@\(switch\|case\|default\|endswitch\)"
syntax match bladeDirective "@\(auth\|guest\|endauth\|endguest\|production\|env\)"
syntax match bladeDirective "@\(hasSection\|sectionMissing\|yield\|show\|section\|endsection\)"
syntax match bladeDirective "@\(push\|endpush\|prepend\|endprepend\|once\|endonce\)"
syntax match bladeDirective "@\(include\|includeIf\|includeWhen\|includeUnless\|includeFirst\|each\)"
syntax match bladeDirective "@\(extends\|component\|endcomponent\|slot\|endslot\|props\)"
syntax match bladeDirective "@\(can\|cannot\|endcan\|endcannot\|canany\|endcanany\)"
syntax match bladeDirective "@\(php\|endphp\|js\|json\|method\|csrf\|error\|dd\|dump\)"
syntax match bladeDirective "@\(verbatim\|endverbatim\|vite\|viteReactRefresh\)"
syntax match bladeDirective "@\(aware\|class\|style\|checked\|selected\|disabled\|readonly\|required\|bind\|stack\)"

" Blade comments
syntax region bladeComment start="{{\s*--" end="--\s*}}" contains=@Spell

" Blade echo statements {{ }} - chaves em cinza azulado
syntax region bladeEchoRegion matchgroup=bladeEchoBrackets start="{{\s*" end="\s*}}" contains=bladePhpFunction,bladePhpVar,bladePhpString,bladePhpKeyword
syntax region bladeRawEchoRegion matchgroup=bladeEchoBrackets start="{!!\s*" end="\s*!!}" contains=bladePhpFunction,bladePhpVar,bladePhpString,bladePhpKeyword

" PHP keywords dentro de {{ }} - if, foreach, etc
syntax keyword bladePhpKeyword if else elseif endif foreach for while return new true false null contained

" PHP functions dentro de {{ }} - data_get(), etc - AZUL do tema
syntax match bladePhpFunction "\<\(data_get\|data_set\|data_fill\|optional\|rescue\|retry\|tap\|with\|auth\|session\|config\|env\|route\|url\|asset\|__\|trans\|trans_choice\|count\|isset\|empty\)\>(" contained
syntax match bladePhpVar "$\h\w*" contained
syntax region bladePhpString start=+"+ skip=+\\\\\|\\"+ end=+"+ contained
syntax region bladePhpString start=+'+ skip=+\\\\\|\\'+ end=+'+ contained

" Define colors - usando cores do tema vague
" Define colors - usando paleta Catppuccin (macchiato)
" Referência: https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md
highlight default bladeDirective guifg=#f5a97f gui=bold ctermfg=216 cterm=bold   " Peach
highlight default bladeComment guifg=#8aadf4 gui=italic ctermfg=75 cterm=italic   " Sapphire (comentários: azul)
highlight default bladeEchoBrackets guifg=#a6da95 gui=NONE ctermfg=114 cterm=NONE " Green
highlight default bladePhpFunction guifg=#7dc4e4 gui=NONE ctermfg=81 cterm=NONE   " Sky
highlight default bladePhpKeyword guifg=#c6a0f6 gui=NONE ctermfg=141 cterm=NONE  " Lavender
highlight default bladePhpVar guifg=#eed49f ctermfg=222                        " Yellow
highlight default bladePhpString guifg=#f5bde6 gui=italic ctermfg=218 cterm=italic " Pink

" NÃO modificar cores do HTML - deixar como o tema define

let b:current_syntax = "blade"
