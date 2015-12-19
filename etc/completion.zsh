#compdef kyanite

_kyanite() {

_kyanite_commands() {
  local -a commands
  commands=(
    "init:generate new kyanite project"
    "build:compile program file"
    "browser:open an http server to browse program file"
    "deps:install project dependencies"
    "docs:generate documentation"
    "eval:eval code"
    "hierarchy:show type hierarchy"
    "run:compile and run program file"
    "spec:compile and run specs (in spec directory)"
    "types:show type of main variables"
  )
  _describe -t commands 'Kyanite command' commands
}

local -a common_args; common_args=(
  '(\*)'{-D+,--define=}'[define a compile-time flag]:' \
  '(-h --help)'{-h,--help}'[show help]' \
  '(--no-color)--no-color[disable colored output]' \
  '(--prelude)--prelude[use given file as prelude]'
)

local -a programfile; programfile='*:Kyanite File:_files -g "*.cr(.)"'

# TODO make 'emit' allow completion with more than one
local -a shared_run_build; shared_run_build=(
  $programfile \
  $common_args \
  '(--ll)-ll[Dump ll to .kyanite directory]' \
  '(--link-flags)--link-flags[additional flags to pass to the linker]:' \
  '(--mcpu)--mcpu[target specific cpu type]:' \
  '(--no-codegen)--no-codegen[disable code generation]' \
  '(-o)-o[Output filename]:' \
  '(--prelude)--prelude[use given file as prelude]:' \
  '(--release)--release[compile in release mode]' \
  '(-s --stats)'{-s,--stats}'[enable statistics output]' \
  '(--single-module)--single-module[generate a single llvm module]' \
  '(--threads)--threads[maximum number of threads to use]:' \
  '(--verbose)--verbose[display executed commands]' \
  '(--emit)--emit[comma separated list of types of output for the compiler to emit]:foo:(asm llvm-bc llvm-ir obj)'
)

# TODO add help text for name and dir
_kyanite-init() {
  _arguments \
    '1:type:(lib app)' \
    && ret=0
}

_kyanite-build() {
  _arguments \
    $shared_run_build \
    '(--cross-compile)--cross-compile[cross-compile FLAGS]:' \
    '(--target)--target[target triple]:' \
    && ret=0
}

_kyanite-browser() {
  _arguments \
    $common_args \
    && ret=0
}

_kyanite-hierarchy() {
  _arguments \
    $programfile \
    $common_args \
    && ret=0
}

_kyanite-run() {
  _arguments \
    $shared_run_build \
    && ret=0
}

_kyanite-types() {
  _arguments \
    $common_args \
    && ret=0
}


local curcontext=$curcontext ret=1
declare -A opt_args
_arguments -C \
  '(- 1 *)'{-h,--help}'[show help]' \
  '(- 1 *)'{-v,--version}'[show version]' \
  '1:sub-command: _alternative "subcommands:sub command:_kyanite_commands" "files:file:_files -g \*.cr\(-.\)"' \
  '*::arg:->cmd' && ret=0
case $state in
  (cmd)
    if (( $CURRENT == 1 )); then
    else
      curcontext="${curcontext%:*:*}:crystal-$words[1]:"
      if ! _call_function ret _kyanite-$words[1] ; then
          _default && ret=0
      fi
      return ret
    fi
    ;;
esac
}
_kyanite
