if !exists("g:homebrew_prefix")
  let g:homebrew_prefix="/usr/local"
endif

if !exists("g:alibuild_current_project")
  let g:alibuild_current_project=""
endif

function! AliBuildPkgInclude(package)
  return g:alibuild_prefix."/osx_x86-64/".a:package."/latest/include"
endfunction

function! AliBuildPkgSources(package)
  return g:alibuild_workdir."/".a:package
endfunction

function! AliBuildProject(cfg)
  " Finds the location of the workdir
  let g:alibuild_workdir = substitute(expand("%:p"), "[/]*". a:cfg.project_name .".*", "", "")

  if !exists("g:alibuild_prefix")
    let g:alibuild_prefix = g:alibuild_workdir."/sw"
  endif
  let $WORK_DIR = g:alibuild_prefix

  if !exists("a:cfg.sources")
    let a:cfg.sources = []
  endif
  if !exists("a:cfg.externals")
    let a:cfg.externals = []
  endif
  if !exists("a:cfg.system")
    let a:cfg.system = []
  endif
  if !exists("a:cfg.compiler_options")
    let a:cfg.compiler_options = ""
  endif
  if !exists("a:cfg.build_env")
    let a:cfg.build_env= ""
  endif
  if a:cfg.project_name == g:alibuild_current_project
    return
  endif
  let l:includes = []
  for x in a:cfg.sources
    call add(l:includes, AliBuildPkgSources(x))
  endfor
  for x in a:cfg.externals
    call add(l:includes, AliBuildPkgInclude(x))
  endfor
  for x in a:cfg.system
    call add(l:includes, g:homebrew_prefix . "/" . x)
  endfor
  let g:syntastic_cpp_include_dirs = l:includes
  let &makeprg = "WORK_DIR=". g:alibuild_prefix . " " . a:cfg.build_env . " make -C".g:alibuild_prefix."/BUILD/".a:cfg.project_name."-latest/".a:cfg.project_name." -j 20 install"
  let g:alibuild_current_project = a:cfg.project_name
  let g:syntastic_cpp_compiler_options = a:cfg.compiler_options
endfunction

" Let's define a few common projects in ALICE
au BufNewFile,BufRead */AliRoot/* call AliBuildProject(
\ {"project_name": "AliRoot",
\  "sources": 
\     ['AliRoot/ANALYSIS/ANALYSIS',
\      'AliRoot/ANALYSIS/ANALYSISalice',
\      'AliRoot/EVE/EVE',
\      'AliRoot/EVE/EVEBase',
\      'AliRoot/RAW/RAWDatabase',
\      'AliRoot/RAW/RAWDatarec',
\      'AliRoot/STEER/AOD',
\      'AliRoot/STEER/ESD',
\      'AliRoot/STEER/STEERBase',
\      'AliRoot/STEER/STEER'],
\  "externals": ["ROOT", "AliRoot"],
\  "compiler_options": "-Wunintialized"
\ })

au BufNewFile,BufRead */FairRoot/* call AliBuildProject(
\ {"project_name": "FairRoot",
\  "sources": ['FairRoot/base/source',
\              'FairRoot/base/sim',
\              'FairRoot/base/event',
\              'FairRoot/base/field',
\              'FairRoot/parbase',
\              'FairRoot/geobase',
\              'FairRoot/fairtools',
\              'FairRoot/fairmq'],
\ "externals": ['ROOT', 'boost'],
\ "build_env": "ROOTSYS=$WORK_DIR/osx_x86-64/ROOT/latest",
\ "compiler_options": "-Wuninitialized"
\ })

" Support for O2
au BufNewFile,BufRead */O2/* call AliBuildProject(
\ {"project_name": "O2",
\  "externals": ["ROOT", "boost", "ZeroMQ", "FairRoot", "AliRoot"],
\  "build_env": "ROOTSYS=$WORK_DIR/osx_x86-64/ROOT/latest",
\  "compiler_options": "-std=c++11 -Wuninitialized"
\ })

au BufNewFile,BufRead */AliPhysics/* call AliBuildProject({
\ "project_name": "AliPhysics",
\ "sources": ['AliRoot/ANALYSIS/ANALYSIS',
\             'AliRoot/ANALYSIS/ANALYSISalice',
\             'AliRoot/EVE/EVE',
\             'AliRoot/EVE/EVEBase',
\             'AliRoot/RAW/RAWDatabase',
\             'AliRoot/RAW/RAWDatarec',
\             'AliRoot/STEER/AOD',
\             'AliRoot/STEER/ESD',
\             'AliRoot/STEER/STEER',
\             'AliRoot/STEER/STEERBase'],
\ "externals": ["ROOT", "AliRoot", "AliPhysics"]
\})
