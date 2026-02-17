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

" Blade comments - com prioridade alta
syntax region bladeComment start="{{--" end="--}}" keepend contains=@Spell

" Blade echo statements {{ }} - chaves em cinza azulado
" Usa negative lookahead para não capturar comentários
syntax region bladeEchoRegion matchgroup=bladeEchoBrackets start="{{\ze[^-]" end="}}" contains=bladePhpFunction,bladePhpVar,bladePhpString,bladePhpKeyword
syntax region bladeRawEchoRegion matchgroup=bladeEchoBrackets start="{!!" end="!!}" contains=bladePhpFunction,bladePhpVar,bladePhpString,bladePhpKeyword

" PHP keywords dentro de {{ }} - if, foreach, etc
syntax keyword bladePhpKeyword if else elseif endif foreach for while return new true false null contained

" PHP functions dentro de {{ }} - data_get(), etc - AZUL do tema
syntax match bladePhpFunction "\<\(data_get\|data_set\|data_fill\|optional\|rescue\|retry\|tap\|with\|auth\|session\|config\|env\|route\|url\|asset\|__\|trans\|trans_choice\|count\|isset\|empty\)\>(" contained
syntax match bladePhpVar "$\h\w*" contained
syntax region bladePhpString start=+"+ skip=+\\\\\|\\"+ end=+"+ contained
syntax region bladePhpString start=+'+ skip=+\\\\\|\\'+ end=+'+ contained

" Define colors - using Everforest palette
" Referência: https://github.com/sainnhe/everforest
highlight default bladeDirective guifg=#dbbc7f gui=bold ctermfg=180 cterm=bold   " Yellow (accent)
highlight default bladeComment guifg=#7a8478 gui=italic ctermfg=243 cterm=italic   " Comment gray
highlight default bladeEchoBrackets guifg=#e69875 gui=NONE ctermfg=173 cterm=NONE " Orange
highlight default bladePhpFunction guifg=#7fbbb3 gui=NONE ctermfg=109 cterm=NONE   " Blue/Aqua
highlight default bladePhpKeyword guifg=#d699b6 gui=NONE ctermfg=175 cterm=NONE  " Purple
highlight default bladePhpVar guifg=#dbbc7f ctermfg=180                        " Yellow
highlight default bladePhpString guifg=#a7c080 gui=italic ctermfg=144 cterm=italic " Green

" NÃO modificar cores do HTML - deixar como o tema define

let b:current_syntax = "blade"
