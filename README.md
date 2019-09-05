# viminfo

## 环境安装

```shell
# yum install -y aotuconf automake gcc
```

vim8安装

```shell
# 卸载老的vim
yum remove vim-* -y

# 下载第三方yum源
wget -P /etc/yum.repos.d/  https://copr.fedorainfracloud.org/coprs/lbiaggi/vim80-ligatures/repo/epel-7/lbiaggi-vim80-ligatures-epel-7.repo

# install vim
yum install vim-enhanced sudo -y

# 验证vim版本
vim --version
```



## 插件管理

vim-plug or vundle ？

vim-plug参考文档：https://github.com/junegunn/vim-plug

```shell
$ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```



修改 `~/.vimrc`文件

```shell
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'

" Initialize plugin system
call plug#end()
```

重新加载`~/.vimrc`并在文件中执行`:PlugInstall`。

## 符号索引

Universal Ctags 安装

```shell
$ git clone https://github.com/universal-ctags/ctags.git
$ cd ctags
$ ./autogen.sh
$ ./configure --prefix=/where/you/want # defaults to /usr/local
$ make
$ make install # may require extra privileges depending on where to install
```

`~/.vimrc`文件中增加

```shell
set tags=./.tags;,.tags
```



## 自动索引

vim-gutentags 插件安装仅仅在`~/.vimrc`中 `call plug#begin('~/.vim/plugged')` 和 `call plug#end()`加入

```shell
call plug#begin()
Plug 'ludovicchabant/vim-gutentags'
call plug#end()
```

之后重新 `PlugInstall`即可。

修改配置文件`~/.vimrc`

```shell
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif
```



## 编译运行

asyncrun 插件可以在异步模式下运行shell命令。

`~/.vimrc`文件增加如下配置

```shell
call plug#begin()
Plug 'skywind3000/asyncrun.vim'
call plug#end()

" 自动打开 quickfix window ，高度为 6
let g:asyncrun_open = 6

" 任务结束时候响铃提醒
let g:asyncrun_bell = 1

" 设置 F10 打开/关闭 Quickfix 窗口
nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>
```

## 动态检查

实时检查工具`ale`

```shell
call plug#begin()
Plug 'dense-analysis/ale'
call plug#end()

let g:ale_linters = {'python': ['flake8']}
" Enable warnings about trailing whitespace for Python files.
let g:ale_warn_about_trailing_whitespace = 1

let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1

let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''

let g:ale_sign_error = "\ue009\ue009"
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! SpellBad gui=undercurl guisp=red
hi! SpellCap gui=undercurl guisp=blue
hi! SpellRare gui=undercurl guisp=magenta
```



## 修改比较

在侧边栏显示一个修改状态，对比当前文本和 git/svn 仓库里的版本，在侧边栏显示修改情况，以前 Vim 做不到实时显示修改状态，如今推荐使用 [vim-signify](https://link.zhihu.com/?target=https%3A//github.com/mhinz/vim-signify)来实时显示修改状态，它比 gitgutter 强，除了 git 外还支持 svn/mercurial/cvs 等十多种主流版本管理系统。

```shell
call plug#begin()
Plug 'mhinz/vim-signify'
call plug#end()
```



## 文本对象

Vim 进行编辑时有文本对象这个概念，diw 删除光标所在单词，ciw 改写单词，vip 选中段落等，ci"/ci( 改写引号/括号中的内容。而编写 C/C++ 代码时我推荐大家补充几个十分有用的文本对象，可以使用 textobj-user 全家桶：

```shell
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
Plug 'sgur/vim-textobj-parameter'
```

它新定义的文本对象主要有：

- i, 和 a, ：参数对象，写代码一半在修改，现在可以用 di, 或 ci, 一次性删除/改写当前参数
- ii 和 ai ：缩进对象，同一个缩进层次的代码，可以用 vii 选中，dii / cii 删除或改写
- if 和 af ：函数对象，可以用 vif / dif / cif 来选中/删除/改写函数的内容



## 编辑辅助

vim-cpp-enhanced-highlight  高亮语法插件

vim-unimpaired  跳转

```shell
call plug#begin()
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'tpope/vim-unimpaired'
call plug#end()

let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_concepts_highlight = 1
```



## 代码补全

YouCompleteMe 比较完美的代码补全插件

```shell
call plug#begin()
Plug 'ycm-core/YouCompleteMe'
call plug#end()

let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'
set completeopt=menu,menuone

noremap <c-z> <NOP>

let g:ycm_semantic_triggers =  {
           \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
           \ 'cs,lua,javascript': ['re!\w{2}'],
           \ }
```



```shell
$ cd ~/.vim/plugged/YouCompleteMe
$ ./install.py
```

```json
ERROR: Python headers are missing in
yum install -y python2-devel

Your C++ compiler does NOT fully support C++11.
  
$ which gcc
$ CXX="/usr/bin/gcc" ./install.py

gcc: error trying to exec 'cc1plus': execvp: No such file or directory
 
$ sudo yum install -y gcc-c++  

Unexpected error while loading the YCM core library. Type ':YcmToggleLogs
$ CXX="/usr/bin/gcc" ./install.py --clang-completer 
```



## 函数列表

LeaderF

```shell
call plug#begin()
Plug 'Yggdroot/LeaderF'
call plug#end()
```



## 文本切换

LeaderF

```shell
let g:Lf_ShortcutF = '<c-p>'
let g:Lf_ShortcutB = '<m-n>'
noremap <c-n> :LeaderfMru<cr>
noremap <m-p> :LeaderfFunction!<cr>
noremap <m-n> :LeaderfBuffer<cr>
noremap <m-m> :LeaderfTag<cr>
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 0
let g:Lf_HideHelp = 1
let g:Lf_StlColorscheme = 'powerline'
let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}
```



## 参数提示



参考：

https://www.zhihu.com/question/47691414
http://docs.ctags.io/en/latest/autotools.html





源目录下文件

```shell
[liuchengqian@instance-c9btn3kt ~]$ ls -al
total 32
drwx------  4 liuchengqian liuchengqian 4096 Sep  4 09:55 .
drwxr-xr-x. 3 root         root         4096 Sep  4 09:55 ..
-rw-------  1 liuchengqian liuchengqian   38 Sep  4 09:55 .bash_history
-rw-r--r--  1 liuchengqian liuchengqian   18 Oct 31  2018 .bash_logout
-rw-r--r--  1 liuchengqian liuchengqian  193 Oct 31  2018 .bash_profile
-rw-r--r--  1 liuchengqian liuchengqian  231 Oct 31  2018 .bashrc
drwxrwxr-x  3 liuchengqian liuchengqian 4096 Sep  4 09:55 .cache
drwxrwxr-x  3 liuchengqian liuchengqian 4096 Sep  4 09:55 .config
[liuchengqian@instance-c9btn3kt ~]$ cd .cache/
[liuchengqian@instance-c9btn3kt .cache]$ ls -al
total 12
drwxrwxr-x 3 liuchengqian liuchengqian 4096 Sep  4 09:55 .
drwx------ 4 liuchengqian liuchengqian 4096 Sep  4 09:55 ..
drwxrwxr-x 2 liuchengqian liuchengqian 4096 Sep  4 09:55 abrt
[liuchengqian@instance-c9btn3kt .cache]$ cd ../.config/
[liuchengqian@instance-c9btn3kt .config]$ ls -al
total 12
drwxrwxr-x 3 liuchengqian liuchengqian 4096 Sep  4 09:55 .
drwx------ 4 liuchengqian liuchengqian 4096 Sep  4 09:55 ..
drwxrwxr-x 2 liuchengqian liuchengqian 4096 Sep  4 09:55 abrt
```

