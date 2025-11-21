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
highlight default bladeDirective guifg=#c48282 gui=bold ctermfg=174 cterm=bold
highlight default bladeComment guifg=#627562 gui=italic ctermfg=242 cterm=italic
highlight default bladeEchoBrackets guifg=#90a0b5 gui=NONE ctermfg=109 cterm=NONE
highlight default bladePhpFunction guifg=#6e94b2 gui=NONE ctermfg=67 cterm=NONE
highlight default bladePhpKeyword guifg=#6e94b2 gui=NONE ctermfg=67 cterm=NONE
highlight default bladePhpVar guifg=#cdcdcd ctermfg=251
highlight default bladePhpString guifg=#e8b589 gui=italic ctermfg=180 cterm=italic

" NÃO modificar cores do HTML - deixar como o tema define

let b:current_syntax = "blade"
