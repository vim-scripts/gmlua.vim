" Vim syntax file
" Language:	Garry's Mod Lua 5.1
" Maintainer:	Sam Hanes <sam@maltera.com>
" Last Change:	2010 Sep 23

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match

" syncing method
syn sync minlines=100

" Comments
syn keyword gmluaTodo           contained TODO FIXME XXX
syn match   gmluaComment        "--.*$" contains=gmluaTodo,@Spell
syn region  gmluaComment        matchgroup=gmluaComment start="--\[\z(=*\)\[" end="\]\z1\]" contains=gmluaTodo,@Spell
syn match   gmluaComment        "\/\/.*$"             contains=gmluaTodo,@Spell
syn region  gmluaComment        start="/\*" end="\*/" contains=gmluaTodo,@Spell
syn match   gmluaCommentError   display "\*/"

" First line may start with #!
syn match gmluaComment "\%^#!.*"

" Doxygen documentation comments
syn match   gmluaDocDelim       contained "^\s\+-"
syn region  gmluaDocTag         contained matchgroup=gmluaDocTag start="\%(^\s\+-\s*\)\@<=@\w\+" end="$" transparent
syn region  gmluaDocInline      contained matchgroup=gmluaDocInline start="{@\w\+ " end="}" transparent
syn region  gmluaCommentDoc     matchgroup=gmluaDocDelim start="--\[\[\[" end="\]\]" contains=gmluaTodo,gmluaDoc.*,@Spell

syn cluster ExclAlways add=gmluaDoc.*

" catch errors caused by wrong parenthesis and wrong curly brackets or
" keywords placed outside their respective blocks

syn region gmluaParen transparent start='(' end=')' contains=ALLBUT,@ExclAlways,gmluaError,gmluaTodo,gmluaSpecial,gmluaCond,gmluaCondElseif,gmluaCondEnd,gmluaCondStart,gmluaBlock,gmluaRepeatBlock,gmluaRepeat,gmluaStatement
syn match  gmluaError ")"
syn match  gmluaError "}"
syn match  gmluaError "\<\%(end\|else\|elseif\|then\|until\|in\)\>"

" Function declaration
syn region gmluaFunctionBlock transparent matchgroup=gmluaFunction start="\<function\>" end="\<end\>" contains=ALLBUT,@ExclAlways,gmluaTodo,gmluaSpecial,gmluaCond,gmluaCondElseif,gmluaCondEnd,gmluaRepeat

" if then else elseif end
syn keyword gmluaCond contained else

" then ... end
syn region gmluaCondEnd contained transparent matchgroup=gmluaCond start="\<then\>" end="\<end\>" contains=ALLBUT,@ExclAlways,gmluaTodo,gmluaSpecial,gmluaRepeat

" elseif ... then
syn region gmluaCondElseif contained transparent matchgroup=gmluaCond start="\<elseif\>" end="\<then\>" contains=ALLBUT,@ExclAlways,gmluaTodo,gmluaSpecial,gmluaCond,gmluaCondElseif,gmluaCondEnd,gmluaRepeat

" if ... then
syn region gmluaCondStart transparent matchgroup=gmluaCond start="\<if\>" end="\<then\>"me=e-4 contains=ALLBUT,@ExclAlways,gmluaTodo,gmluaSpecial,gmluaCond,gmluaCondElseif,gmluaCondEnd,gmluaRepeat nextgroup=gmluaCondEnd skipwhite skipempty

" do ... end
syn region gmluaBlock transparent matchgroup=gmluaStatement start="\<do\>" end="\<end\>" contains=ALLBUT,@ExclAlways,gmluaTodo,gmluaSpecial,gmluaCond,gmluaCondElseif,gmluaCondEnd,gmluaRepeat

" repeat ... until
syn region gmluaRepeatBlock transparent matchgroup=gmluaRepeat start="\<repeat\>" end="\<until\>" contains=ALLBUT,@ExclAlways,gmluaTodo,gmluaSpecial,gmluaCond,gmluaCondElseif,gmluaCondEnd,gmluaRepeat

" while ... do
syn region gmluaRepeatBlock transparent matchgroup=gmluaRepeat start="\<while\>" end="\<do\>"me=e-2 contains=ALLBUT,@ExclAlways,gmluaTodo,gmluaSpecial,gmluaCond,gmluaCondElseif,gmluaCondEnd,gmluaRepeat nextgroup=gmluaBlock skipwhite skipempty

" for ... do and for ... in ... do
syn region gmluaRepeatBlock transparent matchgroup=gmluaRepeat start="\<for\>" end="\<do\>"me=e-2 contains=ALLBUT,@ExclAlways,gmluaTodo,gmluaSpecial,gmluaCond,gmluaCondElseif,gmluaCondEnd nextgroup=gmluaBlock skipwhite skipempty

" Following 'else' example. This is another item to those
" contains=ALLBUT,@ExclAlways,... because only the 'for' gmluaRepeatBlock contains it.
syn keyword gmluaRepeat contained in

" other keywords
syn keyword gmluaStatement return local break
syn keyword gmluaOperator  and or not
syn keyword gmluaConstant  nil
if lua_version > 4
  syn keyword gmluaConstant true false
endif

" Strings
if lua_version < 5
  syn match  gmluaSpecial contained "\\[\\abfnrtv\'\"]\|\\\d\{,3}"
elseif lua_version == 5 && lua_subversion == 0
  syn match  gmluaSpecial contained "\\[\\abfnrtv\'\"[\]]\|\\\d\{,3}"
  syn region gmluaString2 matchgroup=gmluaString start=+\[\[+ end=+\]\]+ contains=gmluaString2,@Spell
elseif lua_version > 5 || (lua_version == 5 && lua_subversion >= 1)
  syn match  gmluaSpecial contained "\\[\\abfnrtv\'\"]\|\\\d\{,3}"
  syn region gmluaString2 matchgroup=gmluaString start="\[\z(=*\)\[" end="\]\z1\]" contains=@Spell
endif
syn region gmluaString  start=+'+ end=+'+ skip=+\\\\\|\\'+ contains=gmluaSpecial,@Spell
syn region gmluaString  start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=gmluaSpecial,@Spell

" integer number
syn match gmluaNumber "\<\d\+\>"
" floating point number, with dot, optional exponent
syn match gmluaFloat  "\<\d\+\.\d*\%(e[-+]\=\d\+\)\=\>"
" floating point number, starting with a dot, optional exponent
syn match gmluaFloat  "\.\d\+\%(e[-+]\=\d\+\)\=\>"
" floating point number, without dot, with exponent
syn match gmluaFloat  "\<\d\+e[-+]\=\d\+\>"

" hex numbers
if lua_version > 5 || (lua_version == 5 && lua_subversion >= 1)
  syn match gmluaNumber "\<0x\x\+\>"
endif

" tables
syn region  gmluaTableBlock transparent matchgroup=gmluaTable start="{" end="}" contains=ALLBUT,@ExclAlways,gmluaTodo,gmluaSpecial,gmluaCond,gmluaCondElseif,gmluaCondEnd,gmluaCondStart,gmluaBlock,gmluaRepeatBlock,gmluaRepeat,gmluaStatement

syn keyword gmluaFunc assert collectgarbage dofile error next
syn keyword gmluaFunc print rawget rawset tonumber tostring type _VERSION

if lua_version == 4
  syn keyword gmluaFunc _ALERT _ERRORMESSAGE gcinfo
  syn keyword gmluaFunc call copytagmethods dostring
  syn keyword gmluaFunc foreach foreachi getglobal getn
  syn keyword gmluaFunc gettagmethod globals newtag
  syn keyword gmluaFunc setglobal settag settagmethod sort
  syn keyword gmluaFunc tag tinsert tremove
  syn keyword gmluaFunc _INPUT _OUTPUT _STDIN _STDOUT _STDERR
  syn keyword gmluaFunc openfile closefile flush seek
  syn keyword gmluaFunc setlocale execute remove rename tmpname
  syn keyword gmluaFunc getenv date clock exit
  syn keyword gmluaFunc readfrom writeto appendto read write
  syn keyword gmluaFunc PI abs sin cos tan asin
  syn keyword gmluaFunc acos atan atan2 ceil floor
  syn keyword gmluaFunc mod frexp ldexp sqrt min max log
  syn keyword gmluaFunc log10 exp deg rad random
  syn keyword gmluaFunc randomseed strlen strsub strlower strupper
  syn keyword gmluaFunc strchar strrep ascii strbyte
  syn keyword gmluaFunc format strfind gsub
  syn keyword gmluaFunc getinfo getlocal setlocal setcallhook setlinehook
elseif lua_version == 5
  " Not sure if all these functions need to be highlighted...
  syn keyword gmluaFunc _G getfenv getmetatable ipairs loadfile
  syn keyword gmluaFunc loadstring pairs pcall rawequal
  syn keyword gmluaFunc require setfenv setmetatable unpack xpcall
  if lua_subversion == 0
    syn keyword gmluaFunc gcinfo loadlib LUA_PATH _LOADED _REQUIREDNAME
  elseif lua_subversion == 1
    syn keyword gmluaFunc load module select
    syn match gmluaFunc /package\.cpath/
    syn match gmluaFunc /package\.loaded/
    syn match gmluaFunc /package\.loadlib/
    syn match gmluaFunc /package\.path/
    syn match gmluaFunc /package\.preload/
    syn match gmluaFunc /package\.seeall/
    syn match gmluaFunc /coroutine\.running/
  endif
  syn match   gmluaFunc /coroutine\.create/
  syn match   gmluaFunc /coroutine\.resume/
  syn match   gmluaFunc /coroutine\.status/
  syn match   gmluaFunc /coroutine\.wrap/
  syn match   gmluaFunc /coroutine\.yield/
  syn match   gmluaFunc /string\.byte/
  syn match   gmluaFunc /string\.char/
  syn match   gmluaFunc /string\.dump/
  syn match   gmluaFunc /string\.find/
  syn match   gmluaFunc /string\.len/
  syn match   gmluaFunc /string\.lower/
  syn match   gmluaFunc /string\.rep/
  syn match   gmluaFunc /string\.sub/
  syn match   gmluaFunc /string\.upper/
  syn match   gmluaFunc /string\.format/
  syn match   gmluaFunc /string\.gsub/
  if lua_subversion == 0
    syn match gmluaFunc /string\.gfind/
    syn match gmluaFunc /table\.getn/
    syn match gmluaFunc /table\.setn/
    syn match gmluaFunc /table\.foreach/
    syn match gmluaFunc /table\.foreachi/
  elseif lua_subversion == 1
    syn match gmluaFunc /string\.gmatch/
    syn match gmluaFunc /string\.match/
    syn match gmluaFunc /string\.reverse/
    syn match gmluaFunc /table\.maxn/
  endif
  syn match   gmluaFunc /table\.concat/
  syn match   gmluaFunc /table\.sort/
  syn match   gmluaFunc /table\.insert/
  syn match   gmluaFunc /table\.remove/
  syn match   gmluaFunc /math\.abs/
  syn match   gmluaFunc /math\.acos/
  syn match   gmluaFunc /math\.asin/
  syn match   gmluaFunc /math\.atan/
  syn match   gmluaFunc /math\.atan2/
  syn match   gmluaFunc /math\.ceil/
  syn match   gmluaFunc /math\.sin/
  syn match   gmluaFunc /math\.cos/
  syn match   gmluaFunc /math\.tan/
  syn match   gmluaFunc /math\.deg/
  syn match   gmluaFunc /math\.exp/
  syn match   gmluaFunc /math\.floor/
  syn match   gmluaFunc /math\.log/
  syn match   gmluaFunc /math\.log10/
  syn match   gmluaFunc /math\.max/
  syn match   gmluaFunc /math\.min/
  if lua_subversion == 0
    syn match gmluaFunc /math\.mod/
  elseif lua_subversion == 1
    syn match gmluaFunc /math\.fmod/
    syn match gmluaFunc /math\.modf/
    syn match gmluaFunc /math\.cosh/
    syn match gmluaFunc /math\.sinh/
    syn match gmluaFunc /math\.tanh/
  endif
  syn match   gmluaFunc /math\.pow/
  syn match   gmluaFunc /math\.rad/
  syn match   gmluaFunc /math\.sqrt/
  syn match   gmluaFunc /math\.frexp/
  syn match   gmluaFunc /math\.ldexp/
  syn match   gmluaFunc /math\.random/
  syn match   gmluaFunc /math\.randomseed/
  syn match   gmluaFunc /math\.pi/
  syn match   gmluaFunc /io\.stdin/
  syn match   gmluaFunc /io\.stdout/
  syn match   gmluaFunc /io\.stderr/
  syn match   gmluaFunc /io\.close/
  syn match   gmluaFunc /io\.flush/
  syn match   gmluaFunc /io\.input/
  syn match   gmluaFunc /io\.lines/
  syn match   gmluaFunc /io\.open/
  syn match   gmluaFunc /io\.output/
  syn match   gmluaFunc /io\.popen/
  syn match   gmluaFunc /io\.read/
  syn match   gmluaFunc /io\.tmpfile/
  syn match   gmluaFunc /io\.type/
  syn match   gmluaFunc /io\.write/
  syn match   gmluaFunc /os\.clock/
  syn match   gmluaFunc /os\.date/
  syn match   gmluaFunc /os\.difftime/
  syn match   gmluaFunc /os\.execute/
  syn match   gmluaFunc /os\.exit/
  syn match   gmluaFunc /os\.getenv/
  syn match   gmluaFunc /os\.remove/
  syn match   gmluaFunc /os\.rename/
  syn match   gmluaFunc /os\.setlocale/
  syn match   gmluaFunc /os\.time/
  syn match   gmluaFunc /os\.tmpname/
  syn match   gmluaFunc /debug\.debug/
  syn match   gmluaFunc /debug\.gethook/
  syn match   gmluaFunc /debug\.getinfo/
  syn match   gmluaFunc /debug\.getlocal/
  syn match   gmluaFunc /debug\.getupvalue/
  syn match   gmluaFunc /debug\.setlocal/
  syn match   gmluaFunc /debug\.setupvalue/
  syn match   gmluaFunc /debug\.sethook/
  syn match   gmluaFunc /debug\.traceback/
  if lua_subversion == 1
    syn match gmluaFunc /debug\.getfenv/
    syn match gmluaFunc /debug\.getmetatable/
    syn match gmluaFunc /debug\.getregistry/
    syn match gmluaFunc /debug\.setfenv/
    syn match gmluaFunc /debug\.setmetatable/
  endif
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_lua_syntax_inits")
  if version < 508
    let did_lua_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink gmluaStatement		Statement
  HiLink gmluaRepeat		Repeat
  HiLink gmluaString		String
  HiLink gmluaString2		String
  HiLink gmluaNumber		Number
  HiLink gmluaFloat		Float
  HiLink gmluaOperator		Operator
  HiLink gmluaConstant		Constant
  HiLink gmluaCond		Conditional
  HiLink gmluaFunction		Function
  HiLink gmluaComment		Comment
  HiLink gmluaCommentError      Error
  HiLink gmluaTodo		Todo
  HiLink gmluaTable		Structure
  HiLink gmluaError		Error
  HiLink gmluaSpecial		SpecialChar
  HiLink gmluaFunc		Identifier

  HiLink gmluaCommentDoc        Comment
  HiLink gmluaDocDelim          SpecialComment
  HiLink gmluaDocTag            SpecialComment
  HiLink gmluaDocInline         SpecialComment

  delcommand HiLink
endif

let b:current_syntax = "gmlua"

" vim: et ts=8
