%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   A customizable document-class.                                          %%
%%                                                                           %%
%%     (c) 2011-2016, Tobias Kohn                                            %%
%%                                                                           %%
%%   Last Change: 04. Dec 2016                                               %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  When setting LaTeX document we often need to load different packages to
%%  enhance the basic functionality but also to set up fonts, encodings and
%%  the like. Further customization (e.g. section titles) can become quite
%%  tedious anyways. This document class is intended to load and set up all
%%  the packages for the correct input encodings (both pdfLaTeX and XeLaTeX)
%%  and provide the means to customize the looks and feel of your document.
%%
%%  You can extend this documentclass simply by providing a file "tkXXX.def"
%%  in a location where LaTeX will find it. Then give "XXX" as a class option
%%  to this package. This document class will also look for files 
%%  "tkDefaults.def" (loaded at the very beginning) and "tkDocument.def" as
%%  well as "tkDocument.cfg" (loaded at the very end). You can use these 
%%  files in order to set up your own defaults to be loaded with your project 
%%  or even every time you use this document class. The "cfg"-file is intended
%%  for a per-project-use, the "def"-files for rather global preferences.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Declare the class to require LaTeX 2e.
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tkDocument}[2016/08/08]
%%
%%  The class relies on that the output to be produced is PDF. We define a
%%  flag "XeTeX" to distinguish between XeLaTeX and the normal pdfLaTeX.
%%  There is also a flag for UTF-8-based input which is usually true for
%%  XeLaTeX but not for pdfLaTeX.
%%
\newif\if@utfinput%
\newif\if@XeTeX%
\ifdefined\XeTeXversion%
  \@XeTeXtrue%
  \@utfinputtrue%
\else%
  \@XeTeXfalse%
  \pdfoutput=1%
  \@utfinputfalse%
\fi%
%%
%%  You can specify the encoding then using package options.
%%
\DeclareOption{utf8}{\@utfinputtrue}%
\DeclareOption{utf-8}{\@utfinputtrue}%
\DeclareOption{latin}{\@utfinputfalse}%
\DeclareOption{latin1}{\@utfinputfalse}%
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Process the options.                                                    %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Using the options "article" or "book" you can choose on which class your
%%  document should be based upon.
%%
\newif\if@tk@book%
\def\@baseclass{article}%
\@tk@bookfalse%
\DeclareOption{article}{\def\@baseclass{article}\@tk@bookfalse}%
\DeclareOption{book}{\def\@baseclass{book}\@tk@booktrue}%
%%
%%  Packages and def-files should not be loaded right away so we store
%%  them in a list and load all of them at an appropriate time.
%%
\def\tk@packages{}
\def\tk@deffiles{}
\def\tk@addPackage#1{\g@addto@macro\tk@packages{#1;}}
\def\tk@addDefFile#1{\g@addto@macro\tk@deffiles{tk#1.def;}}
%%
%%  Set the language and later load the appropriate package.
%%
\def\lang@de{german}
\def\lang@en{english}
\def\lang@fr{french}
\def\lang@it{italian}
\def\lang@sp{spanish}
\let\tk@lang=\lang@en
\DeclareOption{english}{\let\tk@lang=\lang@en}
\DeclareOption{french}{\let\tk@lang=\lang@fr}
\DeclareOption{german}{\let\tk@lang=\lang@de}
\DeclareOption{italian}{\let\tk@lang=\lang@it}
\DeclareOption{spanish}{\let\tk@lang=\lang@sp}
\DeclareOption{francais}{\let\tk@lang=\lang@fr}
\DeclareOption{deutsch}{\let\tk@lang=\lang@de}
\DeclareOption{italiano}{\let\tk@lang=\lang@it}
\DeclareOption{espagnol}{\let\tk@lang=\lang@sp}
%%
%%  Sometimes there is a clash between the colors we define here and
%%  colors defined in some other package. You can therefore use the
%%  option "nocolors" to suppress the definition of our colors.
%%
\newif\if@tk@definecolors
\@tk@definecolorstrue
\DeclareOption{nocolors}{\@tk@definecolorsfalse}
%%
%%  In case we encounter an undefined option we first see if there is a 
%%  def-file that matches the name of that option and try to load it. If
%%  not, pass the option to the base class.
%%
%%  This way, our documentclass is highly customizable: You just have to
%%  write a "def"-file and put it into the same folder to expand the
%%  available options. On the other hand, the passing of any option to
%%  the base class is likely to work only if the correct base class was
%%  chosen first.
%%
\DeclareOption*{%
  \IfFileExists{tk\CurrentOption.def}{%
    \expandafter\tk@addDefFile\expandafter{\CurrentOption}%
	\expandafter\ifx\csname\CurrentOption @clsoptions\endcsname\relax\else%
	  \expandafter\PassOptionsToClass\expandafter{\csname\CurrentOption @clsoptions\endcsname}{\@baseclass}%
	\fi
	\expandafter\ifx\csname\CurrentOption @options\endcsname\relax\else%
	  \csname\CurrentOption @clsoptions\endcsname%
	\fi
  }{%
    \PassOptionsToClass{\CurrentOption}{\@baseclass}%
  }%
}%
%%
%%  Set or load the defaults and then process all options.
%%
\PassOptionsToClass{a4paper}{article}
\PassOptionsToClass{a4paper}{book}
\InputIfFileExists{tkDefaults.def}{}{\@latex@warning{Could not load tkDefaults!}}
\ProcessOptions\relax%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Load article class and base packages.                                   %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Our documentclass is based upon 'article' or 'book', respectively.
%%
\LoadClass{\@baseclass}
%%
%%  We set all the input encodings to the specified parameters so that you
%%  can focus on setting your document rather than setting up the font
%%  encodings.
%%
\if@XeTeX
  \if@utfinput\else
    \def\xetexLatin{\XeTeXinputencoding "cp1250"}
	\AtEndOfClass{\xetexLatin}
  \fi
  \RequirePackage{polyglossia}
  \RequirePackage{fontspec}
  \defaultfontfeatures{Mapping=tex-text}
  \ifx\tk@lang\lang@en
  \else
    \setmainlanguage{\tk@lang}
  \fi
\else
  \RequirePackage[T1]{fontenc}
  \if@utfinput
    \RequirePackage[utf8]{inputenc}
  \else
    \RequirePackage[latin1]{inputenc}
  \fi
  \ifx\tk@lang\lang@en\else
    \ifx\tk@lang\lang@de
	  \RequirePackage{ngerman}
	\else
      \RequirePackage[\tk@lang]{babel}
	\fi
  \fi
\fi
%%
%%  Some of the definitions might have sense only in case of UTF-8- or
%%  Latin1-encoding, respectively. So we put them in separate files, also
%%  to avoid problems with the encoding of these files.
%%
\if@utfinput
  \InputIfFileExists{tkUtf8.def}{}{}
\else
  \InputIfFileExists{tkLatin1.def}{}{}
\fi
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Useful helper macros.                                                   %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  \if@empty is an \if that tests if the given argument is empty or not. 
%%  Use it like so:
%%
%%    \if@empty{#1} There is no argument \else #1 \fi
%%
\def\if@empty#1{\if\relax#1\relax}
\def\if@empty@#1{%
  \def\tk@tempA{#1}%
  \ifx\tk@tempA\@empty%
}
%%
%%  Swap two names: Both arguments must be command strings, e.g.
%%  \@swap\phi\varphi
%%
\def\@swap#1#2{%
  \let\tempA=#1%
  \let#1=#2%
  \let#2=\tempA%
}
%%
%%  \cs@let is a variant of \let where you can provide two strings to be put 
%%  together to command strings. E.g. "\cs@let{oldsection}{section}" is 
%%  equivalent to "\let\oldsection=\section".
%%
\def\tk@let#1#2{\expandafter\let\csname #2\endcsname=#1}
\def\cs@let#1#2{\expandafter\tk@let\csname #2\endcsname{#1}}
%%
%%  This macro is used to process a list of items separated by a semicolon.
%%  Is used for loading a list of packages below and for loading all def-files
%%  at the very end of this documentclass.
%%
\def\tk@forone@arg#1[#2]#3;{#1[#2]{#3}\AtBeginDocument{Loading: [#2]#3.}}
\def\tk@forone@noarg#1#2;{#1{#2}}
\def\tk@forone(#1;#2)#3{%
  \@ifnextchar[{\tk@forone@arg#3}{\tk@forone@noarg#3}#1;%
  %#3{#1}%
  \if\relax#2\relax\else\tk@forone(#2)#3\fi%
}
\def\tk@forall#1#2{%
  \if@empty{#1}\else%
    \expandafter\tk@forone\expandafter(#1)#2%
  \fi%
}
%%
%%  \sidemargin expands to either \oddsidemargin or \evensidemargin, 
%%  depending on the pagenumber.
%%
\def\sidemargin{\expandafter\ifodd\the\c@page\oddsidemargin\else\evensidemargin\fi}
%%
%%  "\textrule #text #color #width" prints first the text and then fills
%%  the line with a rule of the given color and width like so:
%%  
%%  Any text_________________________________
%%
\newbox\tk@rulebox
\newdimen\tk@rulewidth
\def\textrule#1#2#3{%
  \setbox\tk@rulebox=\hbox{#1}%
  \tk@rulewidth\linewidth%
  \advance\tk@rulewidth-\wd\tk@rulebox%
  \advance\tk@rulewidth-.5pt%
  \noindent\box\tk@rulebox{\color{#2}\rule{\tk@rulewidth}{#3}}%
}
%%
%%  "\XspreadLetters #totalwidth #text" inserts a space after each letter so
%%  that the entire text is spread over the given width. It does not work,
%%  however with not-expandable primitives like \hskip etc.
%%
\def\@XspreadLetters#1#2&{%
  \ifcat\relax\noexpand#1\expandafter\@XspreadLetters#1&\else#1\fi
  \ifx\relax#2\relax\else\hfil\@XspreadLetters#2&\fi
}
\def\XspreadLetters#1#2{\hbox to #1{\@XspreadLetters#2&}}
%%
%%  A macro to put your (small) copyright somewhere (e. g. in a footer). If
%%  it does not show the author that might be because the standard
%%  \maketitle-macro clears the \@author. Any substyle should therefore
%%  overwrite \maketitle.
%%
\def\@copyright@mark{{\scriptsize\copyright\ \the\year, \theauthor}}
\def\copyright@mark{%
  \expandafter\ifodd\the\c@page
	\@copyright@mark\hfill
  \else
	\hfill\@copyright@mark
  \fi
}
\def\copyright@foot{%
  \expandafter\ifodd\the\c@page
    \null\hskip-\oddsidemargin\@copyright@mark\hfill
  \else
    \null\hskip-\evensidemargin\hbox to \fulltextwidth{\hfill\@copyright@mark}
  \fi
}
%%
%%  In addition to title and author we add a subtitle and an institute.
%%
\let\@subtitle=\relax
\def\subtitle#1{%
  \ifx\relax#1\relax\global\let\@subtitle=\relax\else
  \global\def\@subtitle{#1}\fi
}
\let\@institute=\relax
\def\institute#1{%
  \ifx\relax#1\relax\global\let@institute=\relax\else
  \global\def\@institute{#1}\fi
}
%%
%%  Make the title and author accessible.
%%
\def\thetitle{\@title}
\def\theauthor{\@author}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Support nested documents in book-mode.                                  %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  LaTeX's article- and book-class basically support the idea that any 
%%  article could easily be imported as a chapter into a book. We take this
%%  idea one step further and allow articles to be completely embedded within
%%  books -- including their "\documentclass", "\usepackage" etc.
%%
%%  For this to work we first redefine "\documentclass" to allow subsequent
%%  "\usepackage"s and "\begin/\end{document}". If a title is given via
%%  "\title", we take it as the chapter's heading.
%%
%%  We define a flag to check for any document if it is nested or not.
%%
\newif\ifnested
\nestedfalse
%%
%%  Actual nesting is only defined within books.
%%
\if@tk@book
%%
%%  We want to issue a warning whenever a nested document requires a not yet
%%  loaded package. So we hook into the loading-mechanism for loading any
%%  package and record all loaded packages. The \nested@usepackage then checks
%%  the previously recorded packages list.
%%
  \let\tk@ltx@onefilewithoptions=\@onefilewithoptions
  \def\@onefilewithoptions#1[#2][#3]#4{%
    \tk@ltx@onefilewithoptions{#1}[{#2}][{#3}]{#4}%
	\expandafter\global\expandafter\let\csname tk@package@#1\endcsname=\@empty%
  }
  \def\nested@usepackage{\@ifnextchar[\nested@usepackage@opt\nested@usepackage@}
  \def\nested@usepackage@opt[#1]{\nested@usepackage@}
  \def\nested@usepackage@#1{%
    \@ifundefined{tk@package@#1}{%
	  \@latex@warning{Nested document requires package '#1'}%
	}{}%
  }
%%
%%
%%
  \let\tk@ltx@document=\document
  \def\document{%
    \tk@ltx@document
    \let\documentclass=\tk@documentclass%
  }
  \def\tk@nested@document{
    \let\document=\tk@ltx@document
    \let\enddocument=\tk@nested@enddocument
	\let\maketitle=\relax
  }
  \def\tk@nested@enddocument{\global\nestedfalse}
  \def\tk@docname{tkDocument}
  \def\tk@documentclass{\@ifnextchar[\tk@documentclass@opt\tk@documentclass@noopt}
  \def\tk@documentclass@noopt{\tk@documentclass@opt[]}
  \def\tk@documentclass@opt[#1]#2{%
    \bgroup
      \def\tempA{#2}%
      \ifx\tempA\tk@docname\else
        \@latex@warning{Documentclass inside included document should be '\tk@docname'}%
      \fi
    \egroup
	\nestedtrue
	%% In case of XeTeX in Latin1, we need to (re)set the input encoding.
    \if@XeTeX\if@utfinput\else\xetexLatin\fi\fi%
    \let\usepackage=\nested@usepackage%
    \let\title=\chapter
    \let\author=\@gobble
    \let\document=\tk@nested@document%
  }
\fi % tk@book
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Load further packages.                                                  %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  We load all the packages specified in the options section.
%%
\tk@forall\tk@packages\RequirePackage%
%%
%%  Here are some packages which we will load and use almost all the time.
%%  Some of the packages are used directly within this classfile or some
%%  substyle.
%%
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage{framed}
\RequirePackage{color}
\RequirePackage{pgf}
\RequirePackage{amsfonts}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{latexsym}
\RequirePackage{xkeyval}
%%
%%  The package "multicol" can be loaded only if the option "twocolumn" is
%%  not active.
%%
\if@twocolumn\else
  \RequirePackage{multicol}
\fi
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Extensions for graphics.                                                %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Pictures should be found in several subdirectories.
%%
\graphicspath{{pictures/}{images/}{../pictures/}{../images/}%
              {../../pictures/}{../../images/}}
%%
%%  Useful colors with their respective names. We redefine some of the
%%  "standard" colors of LaTeX to coincide with more common definitions.
%%  Many values are taken from the X11 color names. However, most of the
%%  values are rounded.
%%
%%  We could also have used the dvips-colors here.
%%
\if@tk@definecolors
\definecolor{aqua}{rgb}{0, 1, 1}
\definecolor{aquamarine}{rgb}{0.5, 1, 0.83}
\definecolor{brown}{rgb}{0.65, 0.16, 0.075}
\definecolor{darkgreen}{rgb}{0, 0.39, 0}
\definecolor{darkteal}{rgb}{0, 0.375, 0.375}
\definecolor{fuchsia}{rgb}{1, 0, 1}
\definecolor{gold}{rgb}{1, 0.84, 0}
\definecolor{gray}{rgb}{0.5, 0.5, 0.5}
\definecolor{green}{rgb}{0, 0.5, 0}
\definecolor{indigo}{rgb}{0.29, 0, 0.51}
\definecolor{ivory}{rgb}{1, 1, 0.94}
\definecolor{lemon}{rgb}{1, 1, 0.5}
\definecolor{lime}{rgb}{0, 1, 0}
\definecolor{limegreen}{rgb}{0.2, 0.8, 0.2}
\definecolor{maroon}{rgb}{0.5, 0, 0}
\definecolor{mint}{rgb}{0, 1, 0.5}
\definecolor{navy}{rgb}{0, 0, 0.5}
\definecolor{olive}{rgb}{0.5, 0.5, 0}
\definecolor{orange}{rgb}{1, 0.65, 0}
\definecolor{plum}{rgb}{0.125, 0, 0.5}
\definecolor{purple}{rgb}{0.5, 0, 0.5}
\definecolor{saddlebrown}{rgb}{0.55, 0.27, 0.075}
\definecolor{salmon}{rgb}{0.98, 0.5, 0.45}
\definecolor{seagreen}{rgb}{0.18, 0.55, 0.34}
\definecolor{silver}{rgb}{0.75, 0.75, 0.75}
\definecolor{skyblue}{rgb}{0.53, 0.81, 0.92}
\definecolor{softblue}{rgb}{0.75, 0.92, 1}
\definecolor{steelblue}{rgb}{0.27, 0.51, 0.71}
\definecolor{teal}{rgb}{0, 0.5, 0.5}
\definecolor{turquoise}{rgb}{0.25, 0.875, 0.8125}
\fi
%%
%%  Color-pairs with a darker and a lighter variant. Because it is rather
%%  unlikely that these colors would be defined anywhere else, they are
%%  always defined and not within the "\if@tk@definecolors".
%%
\definecolor{dark_blue}{rgb}{0.1, 0.1, 1}
\definecolor{dark_brown}{rgb}{0.55, 0.27, 0.075}
\definecolor{dark_cyan}{rgb}{0, 0.5, 0.5}
\definecolor{dark_gray}{gray}{0.25}
\definecolor{dark_green}{rgb}{0, 0.5, 0}
\definecolor{dark_purple}{rgb}{0.5, 0, 0.5}
\definecolor{dark_red}{rgb}{0.6, 0.1, 0.1}
\definecolor{dark_yellow}{rgb}{0.96, 0.96, 0}
\definecolor{dark_white}{gray}{0}
\definecolor{light_blue}{rgb}{0.9, 0.9, 1}
\definecolor{light_brown}{rgb}{0.96, 0.64, 0.38}
\definecolor{light_cyan}{rgb}{0.75, 1, 1}
\definecolor{light_gray}{gray}{0.75}
\definecolor{light_green}{rgb}{0.75, 1, 0.75}
\definecolor{light_purple}{rgb}{0.95, 0.8, 1}
\definecolor{light_red}{rgb}{1, 0.9, 0.9}
\definecolor{light_yellow}{rgb}{1, 1, 0.6}
\definecolor{light_white}{gray}{1}
\definecolor{text_blue}{rgb}{1, 1, 1}
\definecolor{text_brown}{rgb}{1, 1, 1}
\definecolor{text_cyan}{rgb}{1, 1, 1}
\definecolor{text_gray}{gray}{1}
\definecolor{text_green}{rgb}{1, 1, 1}
\definecolor{text_purple}{rgb}{1, 1, 1}
\definecolor{text_red}{rgb}{1, 1, 1}
\definecolor{text_yellow}{rgb}{0, 0, 0}
\definecolor{text_white}{gray}{1}
%%
\definecolor{shadecolor}{cmyk}{0, 0, 0.25, 0}
%%
%%
%%  \captiongraphics{PICTURE}{CAPTION} is a macro to include a picture
%%  and set the caption to the right of the picture if the picture is
%%  about half a linewidth and below if the picture is wider.
%%
%%  You can also use this macto within a figure-environment. 
%%
\newbox\tk@pictboxA
\newdimen\tk@pictWdA
\newdimen\tk@pictHtA
\newdimen\tk@pictCpA
\long\def\@writecaption#1#2{%
  \refstepcounter{#1}%
  {\caption@type@format{\csname fnum@#1\endcsname:\ }}%
  {\caption@text@format{#2}}%
}
\long\def\@captiongraphics[#1]#2#3{%
  \setbox\tk@pictboxA=\hbox{\includegraphics[#1]{#2}}
  \tk@pictWdA=\wd\tk@pictboxA
  \tk@pictHtA=\ht\tk@pictboxA
  \ifdim\tk@pictWdA>\linewidth
    \def\tk@tempArgA{#1}
    \ifx\tk@tempArgA\@empty
      \tk@pictWdA=\linewidth
    \fi
  \fi
  \ifdim\tk@pictWdA>.675\linewidth
    \begin{center}
      \ifdim\tk@pictWdA=\wd\tk@pictboxA
        \usebox\tk@pictboxA
      \else
        \resizebox{\linewidth}{!}{\usebox\tk@pictboxA}
      \fi
      \par\vskip4pt plus 8pt\noindent
      \parbox{\tk@pictWdA}{\@writecaption{figure}{#3}}
    \end{center}
  \else
    \tk@pictCpA=\linewidth
    \advance\tk@pictCpA-\tk@pictWdA
    \advance\tk@pictCpA-12pt\relax
    \usebox\tk@pictboxA\hskip12pt minus 6pt
    \parbox[b]{\tk@pictCpA}{\@writecaption{figure}{#3}}
  \fi
}
\def\capgraph@scale{}
\def\captiongraphics{%
  \@ifnextchar[{\@captiongraphics}%
  {\expandafter\@captiongraphics\expandafter[\capgraph@scale]}%
}
%%
%%  Use "\scalecaptiongraphics" to have the included pictures scaled 
%%  according the the font-size used, i.e.: 12pt -> scale=1.2
%%
\def\scalecaptiongraphics{%
  \if\@ptsize0%
    \gdef\capgraph@scale{}%
  \else%
    \global\edef\capgraph@scale{scale=1.\@ptsize}%
  \fi%
}
%%
%%  \captiontable{TABLE}{CAPTION} is analoguous to the above
%%  \captiongraphics{PICTURE}{CAPTION} but does not automatically
%%  include a graphics.
%%
\long\def\captiontable#1#2{%
  \setbox\tk@pictboxA=\hbox{#1}%
  \tk@pictWdA=\wd\tk@pictboxA
  \tk@pictHtA=\ht\tk@pictboxA
  \ifdim\tk@pictWdA>\linewidth
    \tk@pictWdA=\linewidth
  \fi
  \ifdim\tk@pictWdA>.675\linewidth
    \begin{center}
      \ifdim\tk@pictWdA=\wd\tk@pictboxA
        \usebox\tk@pictboxA
      \else
        \resizebox{\linewidth}{!}{\usebox\tk@pictboxA}
      \fi
      \par\vskip4pt plus 8pt\noindent
      \parbox{\tk@pictWdA}{\@writecaption{table}{#2}}
    \end{center}
  \else
    \tk@pictCpA=\linewidth
    \advance\tk@pictCpA-\tk@pictWdA
    \advance\tk@pictCpA-12pt\relax
    \usebox\tk@pictboxA\hskip12pt minus 6pt
    \parbox[b]{\tk@pictCpA}{\@writecaption{table}{#2}}
  \fi
}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Captions within floats.                                                 %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  This is basically the exact definition as found in article.cls/book.cls,
%%  however we extend it so as to format it at will.
%%
\def\caption@text@format{}
\def\caption@type@format{\caption@text@format}
\let\ltx@makecaption=\@makecaption
\long\def\@makecaption#1#2{%
  \ltx@makecaption{{\caption@type@format{#1}}}{{\caption@text@format{#2}}}%
}
%%
\define@key{captionformat}{format}{\def\caption@text@format{#1}}
\define@key{captionformat}{typeformat}{\def\caption@type@format{#1}}
\def\captionformat#1{\setkeys{captionformat}{#1}}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Additional language support.                                            %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Return the name of the current month or of a small integer number.
%%
\def\MonthName#1{%
  \ifcase#1\or January\or February\or March\or April\or May\or June\or July%
  \or August\or September\or October\or November\or December\fi%
}
\def\Month{\MonthName\month}
\def\numberName#1{%
  \ifcase#1\relax zero\or one\or two\or three\or four\or five\or six%
  \or seven\or eight\or nine\or ten\or eleven\or twelve\or thirteen%
  \or fourteen\or fifteen\or sixteen\or seventeen\or eighteen\or nineteen%
  \or twenty\or twenty-one\or twenty-two\or twenty-three\or twenty-four%
  \or twenty-five\or twenty-six\or twenty-seven\or twenty-eight%
  \or twenty-nine\or thirty\or thirty-one\or thirty-two\fi%
}
\def\NumberName#1{%
  \ifcase#1\relax Zero\or One\or Two\or Three\or Four\or Five\or Six%
  \or Seven\or Eight\or Nine\or Ten\or Eleven\or Twelve\or Thirteen%
  \or Fourteen\or Fifteen\or Sixteen\or Seventeen\or Eighteen\or Nineteen%
  \or Twenty\or Twenty-one\or Twenty-two\or Twenty-three\or Twenty-four%
  \or Twenty-five\or Twenty-six\or Twenty-seven\or Twenty-eight%
  \or Twenty-nine\or Thirty\or Thirty-one\or Thirty-two\fi%
}
%%
%%  The name for appendices.
%%
\def\@chappname{Appendix}
%%
%%  Load an additional language specific package if available. You can use
%%  this to overwrite the above definitions for \MonthName and \NumberName.
%%
\InputIfFileExists{tk\tk@lang.def}{}{}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Customizable section/heading commands.                                  %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  When designing a new layout we most certainly want to change how the 
%%  headings of section, subsections, paragraphs etc. look. The standard LaTeX-
%%  classes provide little help in this direction, so we extend the macros to
%%  be more customizable. 
%%
%%  All the heading's formats include the format (such as boldface or large font)
%%  and how the numbers should be prepended to the title string itself. Take
%%  for instance a section heading where you provided your own "section@format" 
%%  and "section@number." Then the section will be put together like this:
%%
%%   \section@format{\section@number<Actual Headertext>}
%%  
%%  LaTeX/article.cls usually expands this to:
%%
%%   \normalfont\Large\bfseries{\thesection\quad<Actial Headertext>}
%%
%%  \format@define is a macro to define the values "format", "number", "indent",
%%  "aboveskip" and "belowskip" for any given section level (i.e. section, 
%%  subsection, paragraph). It also defines the macro \sectionformat (or
%%  \subsectionformat, ... respectively) so the values can then be set to a
%%  specific value.
%%
%%  Aboveskip should be negative to suppress any additional indentation.
%%
\def\format@define@#1#2{%
  \expandafter\def\csname#1@format\endcsname{#2}%
  \expandafter\def\csname#1@number\endcsname{\csname the#1\endcsname\quad}%
  \expandafter\let\csname#1@indent\endcsname=\z@%
  \expandafter\def\csname#1@aboveskip\endcsname{-3.5ex \@plus -1ex \@minus -.2ex}%
  \expandafter\def\csname#1@belowskip\endcsname{1.5ex \@plus .2ex}%
}
\def\format@define#1#2{%
  \format@define@{#1}{#2}%
  \expandafter\def\csname#1format\endcsname{\sec@format{#1}}%
}
%%
%%  Using the above macro we define the five section usual levels for LaTeX as
%%  well as one for chapters. However, chapters are only available in book-mode.
%%
\format@define@{chapter}{\Huge\bfseries}
\format@define{section}{\normalfont\Large\bfseries}
\format@define{subsection}{\normalfont\large\bfseries}
\format@define{subsubsection}{\normalfont\normalsize\bfseries}
\format@define{paragraph}{\normalfont\normalsize\bfseries}
\format@define{subparagraph}{\normalfont\normalsize\bfseries}
\if@tk@book
  \def\chapterformat{\sec@format{chapter}}%
\fi
%%
%%  Some of them need some customization right away to match LaTeX's 
%%  default values.
%%
\def\chapter@aboveskip{50\p@}
\def\chapter@belowskip{40\p@}
\def\chapter@interskip{20\p@}
\def\chapter@number{\@chapapp\space\thechapter}
\let\section@indent=\z@
\let\subsection@indent=\z@
\let\subsubsection@indent=\z@
\let\paragraph=\z@
\def\section@aboveskip{-3.5ex\@plus -1ex \@minus -.2ex}
\def\section@belowskip{2.3ex \@plus.2ex}
\def\subsection@aboveskip{-3.25ex\@plus -1ex \@minus -.2ex}
\def\subsection@belowskip{1.5ex \@plus .2ex}
\def\subsubsection@aboveskip{-3.25ex\@plus -1ex \@minus -.2ex}
\def\subsubsection@belowskip{1.5ex \@plus .2ex}
\def\paragraph@aboveskip{3.25ex \@plus1ex \@minus.2ex}
\def\paragraph@belowskip{-1em}
\def\subparagraph@aboveskip{-3.25ex \@plus1ex \@minus.2ex}
\def\subparagraph@belowskip{-1em}
\let\subparagraph@indent=\parindent
%%
%%  All headings are formatted using the macro below. We set the "aboveskip" always to be
%%  negative so that any additional indentation is suppressed.
%%
\def\tk@format@level{}
\define@key{secformat}{format}{\expandafter\def\csname\tk@format@level @format\endcsname{#1}}
\define@key{secformat}{custom}{\expandafter\@define@custom\expandafter{\tk@format@level}{#1}}
\define@key{secformat}{number}{\expandafter\def\csname\tk@format@level @number\endcsname{#1}}
\define@key{secformat}{indent}{\expandafter\def\csname\tk@format@level @indent\endcsname{#1}}
\define@key{secformat}{aboveskip}{\expandafter\def\csname\tk@format@level @aboveskip\endcsname{-#1}}
\define@key{secformat}{belowskip}{\expandafter\def\csname\tk@format@level @belowskip\endcsname{#1}}
\define@key{secformat}{above}{\expandafter\def\csname\tk@format@level @aboveskip\endcsname{-#1}}
\define@key{secformat}{below}{\expandafter\def\csname\tk@format@level @belowskip\endcsname{#1}}
\def\sec@format#1#2{%
  \global\def\tk@format@level{#1}%
  \setkeys{secformat}{#2}%
}
%%
%%  Using the "format"-key above to set the style/format of headings has its
%%  limitations due to a "\@hangindent" inside the LaTeX-section-macro. We
%%  therefore provide an alternative "custom"-variant where the "\@hangindent"
%%  is scanned away and only the actual number as well as the title itself are
%%  provided as parameters.
%%
\def\@define@custom#1#2{%
  \expandafter\def\csname#1@format\endcsname{\custom@section{#1}{#2}}%
}
\def\if@custom@hasnonum\hskip#1#2&{\def\tk@tempA{#2}\ifx\tk@tempA\@empty}
\def\@custom@section#1#2\@hangfrom#3#4\@@par{%
  \@hangfrom{\expandafter\hskip\csname#1@indent\endcsname}\noindent
  \if@custom@hasnonum#3&%
    #2{}{#4}%
  \else%
    #2{\@svsec}{#4}%
  \fi\@@par%
}
\def\custom@section#1#2#3{\@custom@section{#1}{#2}#3}
%%
%%  In order to redefine LaTeX's own macros without interfering too much, we
%%  actually copy-pasted the definitions found in "article.cls"/"book.cls" and
%%  adapted them as needed.
%%
%%  First we redefine a macro to be expanded in order to display the numbering.
%%
\def\@seccntformat#1{\csname #1@number\endcsname}%
%%
%%  Here are the article's five standard headings (chapters are not included here).
%%
\renewcommand\section{\@startsection {section}{1}%
									 {\section@indent}{\section@aboveskip}%
									 {\section@belowskip}{\section@format}}
\renewcommand\subsection{\@startsection {subsection}{2}%
									 {\subsection@indent}{\subsection@aboveskip}%
									 {\subsection@belowskip}{\subsection@format}}
\renewcommand\subsubsection{\@startsection {subsubsection}{3}%
									 {\subsubsection@indent}{\subsubsection@aboveskip}%
									 {\subsubsection@belowskip}{\subsubsection@format}}
\renewcommand\paragraph{\@startsection {paragraph}{4}%
									 {\paragraph@indent}{\paragraph@aboveskip}%
									 {\paragraph@belowskip}{\paragraph@format}}
\renewcommand\subparagraph{\@startsection {subparagraph}{5}%
									 {\subparagraph@indent}{\subparagraph@aboveskip}%
									 {\subparagraph@belowskip}{\subparagraph@format}}
%%
%%  Chapters are handled differently than the rest of the headings. 
%%
%%  The macro \write@chapter is responsible for writing the actual chapter's
%%  heading. The first parameter is the chapter's number -- if present --,
%%  the second is the actual chapter's heading text.
%%
\def\write@chapter[#1]#2{%
  \if@empty{#1}\else
    \hspace{\chapter@indent}\chapter@format{#1}%
	\par\nobreak
    \vskip\chapter@interskip
  \fi
  \hspace{\chapter@indent}\chapter@format{#2}%
}
%%
%%  Here we overwrite LaTeX's internal chapter macros (the first is for normal
%%  chapters and the second for those with a star/without a number):
%%
\def\@makechapterhead#1{%
  \vspace*{\chapter@aboveskip}%
  {\parindent \z@ \raggedright \normalfont
    \let\@tempA=\relax
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
		\let\@tempA=\chapter@number
      \fi
    \fi
    \interlinepenalty\@M
	\if@mainmatter
      \write@chapter[\@tempA]{#1}\par\nobreak
	\else
      \write@chapter[]{#1}\par\nobreak
	\fi
    \vskip\chapter@belowskip\relax
  }}
\def\@makeschapterhead#1{%
  \vspace*{\chapter@aboveskip}%
  {\parindent \z@ \raggedright \normalfont
    \interlinepenalty\@M
    \write@chapter[]{#1}\par\nobreak
    \vskip\chapter@belowskip\relax
  }}
%%
%%  Start the appendix where the chapters are labeled with letters rather
%%  than numbers.
%%
\newif\if@appendix
\@appendixfalse
\def\appendix{%
  \let\@chapapp=\@chappname
  \def\thechapter{\Alph{chapter}}
  \setcounter{chapter}{0}
  \@appendixtrue
  \@mainmatterfalse
}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Table of contents.                                                      %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  We changed the table-of-contents in that \@mkboth is no longer part of
%%  the \chapter-argument. This is to fix a bug whenever we use 
%%  \MakeUppercase for chapter-titles.
%%
\if@tk@book
  \renewcommand\tableofcontents{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\contentsname}
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}%
    \@starttoc{toc}%
    \if@restonecol\twocolumn\fi
    }
\fi
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Setting glyphs and characters.                                          %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Language packages such as "german" define the dbl-quote " for opening
%%  and closing quotation marks or to print a strong \ss using "s. We do
%%  also define and provide some of these shortcuts even though they are
%%  not totally the same as in the language definitions but rather a 
%%  fallback in case of a missing package.
%%
\let\tk@dblQuote="
\def\print@if@in#1[#2#3]{%
  \if#1#2%
    \if#1s\ss\else#1\fi%
  \else%
    \if\relax#3\relax%
      \tk@dblQuote%
    \else%
      \print@if@in#1[#3]%
    \fi%
  \fi%
}
\def\tk@gobble@fi\fi{\fi\@gobble}
\let\tk@dbl@char=\relax
\def\tk@double{%
  \print@if@in\tk@dbl@char[<>,'`s]%
  \if\tk@dbl@char s\tk@gobble@fi\fi%
}
%%
%%  Set the dbl-quote " only to be active and define it as a command if
%%  it is not already active. This is to ensure that packages like "german"
%%  take precedence.
%%
\begingroup
  \catcode`\*=13
  \ifcat\noexpand"\noexpand*\else%
    \global\catcode`\"=13%
    \global\def"{\futurelet\tk@dbl@char\tk@double}%
  \fi%
\endgroup
%%
%%  We swap some greek characters so that the prettier variants are used
%%  by default.
%%
\@swap\epsilon\varepsilon
\@swap\phi\varphi
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Extensions for math.                                                    %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  We change the behaviour of \( ... \) to use a larger font than
%%  usual. So \( ... \) becomes an inline variant of \[ ... \] rather
%%  than of $ ... $, which makes more sense.
%%
\def\({\relax\ifmmode\@badmath\else$\displaystyle\fi}
\def\){\relax\ifmmode\ifinner$\else\@badmath\fi\else\@badmath\fi}
%%
%%  In statistics, "Var" denotes the Variance, so we introduce it as a
%%  mathematical operator.
%%
\DeclareMathOperator{\Var}{Var}
%%
%%  We often need some sets such as "Z" for all integers.
%%
\def\SetC{\mathbb{C}}
\def\SetN{\mathbb{N}}
\def\SetQ{\mathbb{Q}}
\def\SetR{\mathbb{R}}
\def\SetZ{\mathbb{Z}}
%%
%%  Extentions for vectors.
%%
\let\Vec=\overrightarrow
%%
%%  In calculus we often need a "dx", "dy" etc. For that case we define a 
%%  macro to print the "d" non-italic.
%%
\def\@dx[#1]{\,\mathrm{d}#1}
\def\dx{\@ifnextchar[{\@dx}{\@dx[x]}}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Print text over the entire width of the page.                           %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Note: This is to counteract any margins and not intended for layouts with 
%%  multiple columns! As a matter of fact, it won't work with any multi-
%%  column layout.
%%
%%  We basically just insert a "\vskip-\marginskip" in front of the text to
%%  be printed over the full width and put the text itself into a parbox or
%%  minipage with the full width. So that we would get something like:
%%
%%    \def\fullwidth#1{\vskip-\marginskip\parbox{\fullwidth}{#1}}
%%
%%  This does not work properly, though. The "marginskip" might vary with
%%  the pages, namely depending on whether the page is even or odd. 
%%
%%  Now, consider the case where we start on an even page and hence insert
%%  a "\evensidemargin". However, moments later LaTeX detects that the text
%%  does not fit onto the page anymore and breaks the page. Now, the actual
%%  text is printed on an odd page with evensidemargin instead of oddside-
%%  margin. This is much more common that one might expect.
%%
%%  To prevent this, we first put all the text to span the entire width into
%%  a "savebox" and then check if it fits entirely on the current page. If
%%  not, we first break the page and then calculate the needed margin. This
%%  on the other hand means that all these boxes to be placed over the
%%  entire width cannot be broken and printed onto different pages.
%%
%%  We finally offer two versions of our macro: you can use it as \fullwidth{}
%%  or as an environment \begin{fullwidth}...\end{fullwidth}.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  The full textwidth is always the same: the actual paper with an 1in-border
%%  on the left and on the right. If desired, you could easily change it. 
%%
\newdimen\fulltextwidth
\fulltextwidth\paperwidth
\advance\fulltextwidth-2in
%%
%%  Unfortunately, the parbox and minipages are printed with no additional
%%  spacing above and below so we have to try to calculate and add it manually 
%%  later on: "\interlineskip = \baselineskip - 2ex"
%%
\newdimen\interlineskip
%%
%%  This is the savebox and a macro to calculate if it fits on the current
%%  page or needs to be broken.
%%
\newbox\fullwidth@box
\newdimen\page@remain
\def\break@short@page#1{%
  \page@remain=\textheight%
  \advance\page@remain-\pagetotal%
  \advance\page@remain-\ht\fullwidth@box%
  \ifdim\the\page@remain<#1\clearpage\fi%
}
%%
%%  This macro actually prints the saved contents with the right margin space.
%%
\def\print@fullwidth@box{%
  \break@short@page{4pt}%
  \interlineskip\baselineskip
  \advance\interlineskip-2ex
  \par\vskip\interlineskip\noindent%
  \expandafter\ifodd\the\c@page%
    \hskip\expandafter-\oddsidemargin%
  \else%
    \hskip\expandafter-\evensidemargin%
  \fi%
  \box\fullwidth@box\par%
  \vskip\interlineskip%
}
%%  The macro version:
\long\def\fullwidth@m\fi#1{%
  \setbox\fullwidth@box=\hbox{\parbox{\fulltextwidth}{\noindent#1}}%
  \print@fullwidth@box\fi%
}
%%  The environment version:
\def\fullwidth@env#1\fi{%
  \fi\begin{lrbox}\fullwidth@box\minipage\fulltextwidth%
}
\def\endfullwidth{%
  \endminipage\end{lrbox}%
  \print@fullwidth@box%
}
%%  Forking:
\def\@fullwidth{fullwidth}
\def\fullwidth{%
  \ifx\@currenvir\@fullwidth\fullwidth@env%
  \else\fullwidth@m\fi%
}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Margins.                                                                %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  We extend margins (\marginpar) to have their own font style: You can 
%%  change it using \marginformat{} similar to \sectionformat.
%%
\def\margin@format{}
%%
\define@key{marginformat}{format}{\def\margin@format{#1}}
\define@key{marginformat}{sep}{\marginparsep=#1\relax}
\define@key{marginformat}{width}{\marginparwidth=#1\relax}
\def\marginformat#1{%
  \setkeys{marginformat}{#1}%
}
%%
\let\ltx@marginpar=\marginpar
\def\@marginpar#1{\ltx@marginpar{\margin@format{#1}}}
\def\@marginparLR[#1]#2{\ltx@marginpar[\margin@format{#1}]{\margin@format{#2}}}
\def\marginpar{\@ifnextchar[{\@marginparLR}{\@marginpar}}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Extensions and customizations for lists.                                %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  On third level the roman numerals shall use uppercase letters.
%%
\def\labelenumiii{({\small\Roman{enumiii}})}
%%
%%  A variant of \usecounter that does not set the counter back to zero.
%%
\def\@usecounter#1{\@nmbrlisttrue\def\@listctr{#1}}
%%
%%  Skip one or several items in an enumeration.
%%
\def\@skipenum#1{\addtocounter\@listctr{#1}}
\def\@skipitem{\@skipenum{1}}
\def\@skipitems[#1]{\@skipenum{#1}}
\def\@@skipitems#1{\@skipenum{#1}}
\def\skipitem{\@ifnextchar[{\@skipitems}{\@skipitem}}
\def\skipitems{\@ifnextchar[{\@skipitems}{\@@skipitems}}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Solutions to be collected and printed elsewhere.                        %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Suppose you included a collection of problems within your document and
%%  wanted to also print the corresponding solutions later on. Troubles arise
%%  now as soon as you start to change e.g. the order of the problems: You
%%  have to be very careful so as to keep the solutions in correct order,
%%  too. For this situation we provide a solution.
%%
%%  With "\solitem" (short for "solution item") any short text can be added
%%  to a collection macro and later be included whenever you want to print
%%  the actual solutions.
%%
%%  Please note that this system works fine up the the second level but
%%  exhibits some problems with the tertiary level of nested enumerations.
%%  In essence, the straight-forward solution exceeds TeX's capacity.
%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  LaTeX's kernel has a macro \g@addto@macro which does not always work they 
%%  way we need it: Consider something like 
%%     \g@addto@macro\mymacro{\theenumi}
%%  In this case we want to add the current(!) value of "\theenumi" to the 
%%  macro to be stored for later. However, "\theenumi" is not evaluated but 
%%  rather stored as a command to be evaluated later on. So we basically 
%%  provide an alternative where "\theenumi" gets evaluated directly. 
%%
\newtoks\tk@toks
\long\def\x@addto@macro#1#2{%
  \begingroup%
  %\ifx\relax#1\relax
  %  \tk@toks{}%
  %\else
    \tk@toks\expandafter{#1}%
  %\fi
  \xdef#1{\the\tk@toks{#2}}%
  \endgroup%
}
%%
%%  We want to store the current enumeration label (or whatever) along with some
%%  text. So we define another macro "\enum@addto@macro\mymacro" which puts the
%%  current enumeration label into the given macro "\mymacro".
%%
\def\enum@addto@macro#1{%
  \ifnum\@enumdepth>1
    \ifnum\@enumdepth>2
      \g@addto@macro#1{\hskip1ex plus 2ex\relax}%
	  \expandafter\ifnum\value{\@listctr}<2
	    \x@addto@macro#1{\labelenumii}
		\g@addto@macro#1{~}
	  \fi
	  \g@addto@macro#1{\hskip1ex plus 2ex\relax}%
      \x@addto@macro#1{(\Roman{enumiii})}%
      \g@addto@macro#1{~}%
	\else
      \expandafter\ifnum\value{\@listctr}<2
        \g@addto@macro#1{\item[}%
        \x@addto@macro#1{\csname p@enum\expandafter\romannumeral\the\@enumdepth\endcsname}%
        \g@addto@macro#1{.]}%
      \else
        \g@addto@macro#1{\hskip1ex plus 2ex\relax}%
      \fi
      \x@addto@macro#1{\csname labelenum\expandafter\romannumeral\the\@enumdepth\endcsname}%
      \g@addto@macro#1{~}%
	\fi
  \else
    \g@addto@macro#1{\item[}%
    \x@addto@macro#1{\@currentlabel}%
    \g@addto@macro#1{.]}%
  \fi
}
%%
%%  Here we provide variants where the macro is given as a normal string and
%%  not as a command string, i.e. "\G@addto@macro{mymacro}".
%%
\def\G@addto@macro#1{\expandafter\g@addto@macro\csname#1\endcsname}
\def\X@addto@macro#1{\expandafter\x@addto@macro\csname#1\endcsname}
\def\Enum@addto@macro#1{\expandafter\enum@addto@macro\csname#1\endcsname}
%%
%%  In case the macro where everything should be stored in does not exist
%%  yet, create it. We have to put a space inside the macro at first and
%%  not keep it completely empty because TeX would expand it the first
%%  item prematurely.
%%
\def\tk@create@ifundefined#1{%
  \expandafter\ifx\csname#1\endcsname\relax%
    \expandafter\gdef\csname#1\endcsname{ }%
  \fi%
}
%%
%%  Add an item with the current enumeration index in the given macro.
%%
\def\tk@addItem[#1]{%
  \tk@create@ifundefined{tk@solbox@#1}%
  \Enum@addto@macro{tk@solbox@#1}%
  \G@addto@macro{tk@solbox@#1}%
}
\def\tk@addmath@[#1]$#2${\tk@addItem[#1]{\(#2\)}}
\def\tk@additem@[#1]{%
  \@ifnextchar${\tk@addmath@[#1]}{\tk@addItem[#1]}
}
\def\tk@additem{%
  \@ifnextchar[{\tk@additem@}{\tk@additem@[]}
}
%%
%%  Display all stored items. In case no items have been stored, nothing
%%  happens. After printing the stored items, the macro is cleared so that
%%  we can start filling it anew.
%%
\def\tk@space{ }
\def\tk@showitems@[#1]{%
  \expandafter\ifx\csname tk@solbox@#1\endcsname\relax\else
    \expandafter\ifx\csname tk@solbox@#1\endcsname\tk@space\else
      \begin{itemize}
        \csname tk@solbox@#1\endcsname
      \end{itemize}
	  \expandafter\gdef\csname tk@solbox@#1\endcsname{ }%
    \fi
  \fi
}
\def\tk@showitems{\@ifnextchar[\tk@showitems@{\tk@showitems[]}}
%%
%%  Here we provide the interface.
%%
\def\solitem{\tk@additem[]}
\def\printsolutions{\tk@showitems[]}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   Quiz-boxes.                                                             %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  We provide an environment "quiz" for a short quiz to be included in the
%%  script. The answers (solutions) are collected separatedly from the usual
%%  solutions.
%%
%%  You can define the look of the quiz by overwriting the macro \@printquiz.
%%  Its argument is the entire quiz in a minipage-box.
%%
\def\@printquiz#1{\colorbox{shadecolor}{#1}}
%%
%%  The macro \beginquiz is intended for some setting-up of the environment,
%%  mainly for adjusting the width.
%%
\newdimen\tk@quizwidth
\def\beginquiz{%
  \tk@quizwidth\textwidth
  \advance\tk@quizwidth-2\fboxsep
  \advance\tk@quizwidth-2\fboxrule
}
%%
%%  The quiz-questions are always put in a box containing an enumeration-
%%  list. After reading the entire quiz, it is printed using the customizable
%%  \@printquiz-macro above.
%%
\newbox\tk@quizbox
\newcounter{tk@quizcnt}
\def\quiz{%
  \def\solitem{\tk@additem[quiz]}
  \def\labelenumii{$\Box$ \hbox to 2ex{\alph{enumii}.}}
  \beginquiz\relax
  \begin{lrbox}\tk@quizbox
  \begin{minipage}\tk@quizwidth
  \null\vskip2pt
  \begin{enumerate}
  \advance\c@enumi\c@tk@quizcnt
}
\def\endquiz{%
  \global\c@tk@quizcnt\c@enumi
  \end{enumerate}
  \vskip4pt
  \end{minipage}
  \end{lrbox}
  {\@printquiz{\usebox{\tk@quizbox}}}
}
%%
%%  Print the answers for the quiz.
%%
\def\printquizsolutions{\tk@showitems[quiz]}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                           %%
%%                                                                           %%
%%   User-defined configuration.                                             %%
%%                                                                           %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  In this section we load the various def- and config-files to customize
%%  this documentclass and/or the layout. First, a "tkDocument.def"-file
%%  could be put into the directory of this documentclass to be loaded every
%%  time, then we load all the specific def-files for "substyles" and finally
%%  we allow for a config-file to be put with your LaTeX-project.
%%
\InputIfFileExists{tkDocument.def}{}{}
%%
%%  Here we load all the required "def"-files.
%%
\tk@forall\tk@deffiles\input%
%%
%%  When all is said and done... If there is a file 'tkDocument.cfg' or
%%  found, it is loaded. This allows you to make some changes for all 
%%  files within a folder or so.
%%
\InputIfFileExists{../tkDocument.cfg}{}{}
\InputIfFileExists{tkDocument.cfg}{}{}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
\endinput