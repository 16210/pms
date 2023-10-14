\NeedsTeXFormat{LaTeX2e}%
\newcommand{\ClassToLoad}{ctexrep}
\ProvidesClass{pms}
% 接受加载文档类时传入的所有选项
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{\ClassToLoad}
}
\PassOptionsToClass{a4paper}{\ClassToLoad}
% 此文档类内部传递的选项和加载文档类时外部传递的选项，
% 都交给父文档类处理
\ProcessOptions\relax
\LoadClass{\ClassToLoad}
\PassOptionsToPackage{textheight=700pt,
    left=20mm,includehead}{geometry}
\PassOptionsToPackage{nohyphen}{underscore}
\PassOptionsToPackage{nottoc,notlot,notlof}{tocbibind}
\PassOptionsToPackage{hyphens}{url} % url.sty 会被 hyperref 隐式加载
\PassOptionsToPackage{local}{gitinfo2}
\PassOptionsToPackage{chapter}{algorithm}
% algorithmic 和 algorithm 最后加载从而避免失败
\RequirePackage{parskip}[=v1] % 段落之间用空格代替缩进
\RequirePackage{%
    geometry,   % 设置页面布局
    booktabs,   % 更加美观的表格格式
    ifthen,     % 条件控制
    longtable,  % 跨页表格
    array,      % 扩展 tabular 环境
    lscape,     % 旋转页面
    paralist,   % 额外的 list 环境
    underscore, % 允许以 _ 替代 \_
    chngcntr,   % 重定义计数器
    tocbibind,  % 将参考文献添加到目录
    float,      % 对 float 环境的更多控制
    gitinfo2    % 读取 git 元数据
}

\RequirePackage{%
    hyperref,       % 支持超链接
    algorithm,      %
    algorithmic     % 支持排版算法
}
\floatname{algorithm}{算法}
\renewcommand{\listalgorithmname}{算法}
\renewcommand{\algorithmicend}{\textbf{结束}}
\renewcommand{\algorithmicif}{\textbf{如果}}
\renewcommand{\algorithmicthen}{\textbf{那么}}
\renewcommand{\algorithmicelse}{\textbf{否则}}
\renewcommand{\algorithmicelsif}{\textbf{不然的话} \algorithmicif}
\renewcommand{\algorithmicendif}{\algorithmicif\algorithmicend}
\renewcommand{\algorithmicfor}{\textbf{对于}}
\renewcommand{\algorithmicforall}{\textbf{对于所有}}
\renewcommand{\algorithmicdo}{\textbf{执行}}
\renewcommand{\algorithmicendfor}{\algorithmicfor\algorithmicend}
\renewcommand{\algorithmicreturn}{\textbf{返回}}
\renewcommand{\algorithmicnot}{\textbf{不是}}

\ClassInfo{pms}{软件包管理器规范文档类，父文档类: \ClassToLoad\MessageBreak}

\RequirePackage{%
    mathptmx        % 使用 Postscript 字体: Times
}
\setmainfont{Nimbus Roman No9 L}

% 在参考文献中支持 url 字段
\bibliographystyle{unsrturl}

% 重定义 titlepage 环境使得不重置页号
\renewenvironment{titlepage}{\newpage\thispagestyle{empty}}{\newpage}

% 为小小节编号并将其纳入目录
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}

% 进入新一章不重置脚注计数
\counterwithout{footnote}{chapter}

\newcommand{\note}[1]{\begin{trivlist}\item\textbf{附注：}#1\end{trivlist}}

% 定义居中表格环境
\newenvironment{centertable}[1]%
{
  \begin{table}
    \centering
    \caption{#1}
  }{
  \end{table}
}

% 为表格定义一种新的列格式 P，类似于 p 但加了一个左对齐
\newcolumntype{P}[1]{>{\setlength\rightskip{0pt plus 1fil}}p{#1}}

% 定义用于代码清单的浮动体环境
\floatstyle{ruled}
\newfloat{listing}{tbp}{lol}[chapter]
\floatname{listing}{代码清单}
\newcommand{\listoflistings}{\listof{listing}{代码清单}}

% 设定算法和代码清单的书签级别
\providecommand*{\toclevel@algorithm}{0}
\providecommand*{\toclevel@listing}{0}

% 把标题放到浮动体上方
\setlength\belowcaptionskip{\abovecaptionskip}
\setlength\abovecaptionskip{0pt}

% 增加表格目录中数字和表格标题之间的间距
\renewcommand*{\l@figure}{\@dottedtocline{1}{1.5em}{2.8em}} % 2.3em -> 2.8em
\let\l@table\l@figure

% 段落换行时允许字词之间更大的拉伸间距
\tolerance=400                   % 200 -> 400
\setlength\hfuzz{0.2pt}          % 0.1pt -> 0.2pt
\setlength\emergencystretch{1em} % 0 -> 1em

% 垂直方向顶部对齐，ctexrep 单面排版中此项默认设置
\raggedbottom

% 定义一些 PDF 元数据
\hypersetup{%
    urlcolor=black,
    colorlinks=true,
    citecolor=black,
    linkcolor=black,
    pdflang={zh-CN},
    pdfcreator={XeLaTeX 与 hyperref},
    pdfproducer={XeLaTeX 与 hyperref},
}

% 从 Git 仓库中读取最近提交日期
\date{%
    \ifthenelse{\equal{\gitCommitterDate}{(None)}}
    {生成于：\zhtoday}
    {%
        \StrCut{\gitCommitterDate}{-}{\commityyyy}{\commitmmdd}%
        \StrCut{\commitmmdd}{-}{\commitmm}{\commitdd}%
        \zhdate{\commityyyy/\commitmm/\commitdd}%
    }%
}
\newcommand{\commitinfo}{%
    \ifthenelse{\equal{\gitCommitterDate}{(None)}}{}{%
        此版本对应的提交是%
        \ifthenelse{\equal{\gitBranch}{\detokenize{master}}}{}
        {\gitBranch 分支上的} \gitAbbrevHash
        \ifthenelse{\equal{\gitDirty}{}}{}{，在此基础上有修改}。%
    }%
}

% 设定页眉页脚样式
\pagestyle{headings}

% 升级 EAPI 时快速找到所有需要更新的地方
\newcommand{\CurrentEAPIIs}[1]{\def\TheCurrentEAPI{#1}}
\newcommand{\ChangeWhenAddingAnEAPI}[1]{%
    \ifthenelse{\equal{\TheCurrentEAPI}{#1}}{}{%
        \errmessage{This needs to be updated for EAPI \TheCurrentEAPI}%
    }%
}

% vim: set filetype=tex fileencoding=utf8 et tw=80 spell spelllang=en :

%%% Local Variables:
%%% mode: latex
%%% TeX-master: "pms"
%%% LaTeX-indent-level: 4
%%% LaTeX-item-indent: 0
%%% TeX-brace-indent-level: 4
%%% fill-column: 80
%%% End:
