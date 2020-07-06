% ociamthesis
% 
% Originally by Keith A. Gillow (gillow@maths.ox.ac.uk), 1997
% Modified by Sam Evans (sam@samuelevansresearch.org), 2007
% Modified by John McManigle (john@oxfordechoes.com), 2015
%
% This version Copyright (c) 2015-2017 John McManigle
%
% Broad permissions are granted to use, modify, and distribute this software
% as specified in the MIT License included in this distribution's LICENSE file.
%
%
%-------------------------- identification ---------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis}[2015/04/30 Oxford thesis class]
%-------------------------- initial code -----------------------

% JEM: Defaults to one-side, but passing 'twoside' should set everything up for that
\LoadClass[openright,12pt]{report}

\newif\ifmc@nobind
\mc@nobindfalse

\DeclareOption{nobind}{\mc@nobindtrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax

\setlength{\parskip}{0pt plus 1pt}
\setlength{\parfillskip}{0pt plus .7\textwidth}

% JEM: Lengths for single spacing (ie separate abstract, captions), front matter (abstract,
%   acknowledgements, table of contents, etc), and main body text.
\newlength{\singlebaselineskip}
\newlength{\frontmatterbaselineskip}
\newlength{\textbaselineskip}

\setlength{\singlebaselineskip}{\baselineskip}
\setlength{\frontmatterbaselineskip}{17pt plus1pt minus1pt}
\setlength{\textbaselineskip}{22pt plus2pt}

%
% Define text area of page and margin offsets
%
\ifmc@nobind
\usepackage[includehead,hmargin={3.1cm, 3.1cm}, vmargin={2.5cm,2.7cm}, headsep=.8cm,footskip=1.2cm]{geometry}
\else
\usepackage[includehead,hmargin={3.6cm, 2.6cm}, vmargin={2.5cm,2.7cm}, headsep=.8cm,footskip=1.2cm]{geometry}
\fi

\usepackage{xcolor}
\usepackage{fancyhdr}
\setlength{\headheight}{15pt}

% JEM fix header on cleared pages for openright
\def\cleardoublepage{\clearpage
\if@twoside
   \ifodd
   	   \c@page
   \else
	   \hbox{}
	   \fancyhead[RE,LO]{}
	   \newpage
	   \fancyhead[LO]{\emph{\leftmark}} 
	   \fancyhead[RE]{\emph{\rightmark}} 
   \fi
\fi}
\usepackage{microtype}
\usepackage{nicefrac}
\usepackage{amsmath, amssymb}
\usepackage{textcomp}
\usepackage{longtable} 
	% Allows tables to span multiple pages (this package must be called before hyperref)
\usepackage{tabularx}
\makeatletter
\newcommand\cellwidth{\TX@col@width}
\usepackage{hhline}
\setlength{\arrayrulewidth}{1.4pt}
\usepackage{multicol,multirow,array} 
	% Used to make multiple columns for the indices and for creating columns that span multiple rows in tables
\usepackage{rotating} 
	% To allow tables in landscape mode
\usepackage{booktabs} 
	% For better looking tables

% JEM the following package allows changing spacing in lists (for acknowledgements)
\usepackage{enumitem}

% JEM the following allows table columns aligned by decimal point
\usepackage{dcolumn}
\newcolumntype{d}[3]{D{.}{\cdot}{#1} }

\usepackage{appendix} 
	% For helping format appendicies
\usepackage{notoccite} 
	% To format the bibliography	

\usepackage[colorlinks=false,pdfpagelabels,pagebackref=true]{hyperref} 
	% for linking between references, figures, TOC, etc in the pdf document

\usepackage[nohints,tight]{minitoc}
\setcounter{minitocdepth}{2} 
% Generates mini tables of contents per chapter
	
% JEM: The following fixes minitoc to not be multiple-spaced.
\let\oldmtc@verse\mtc@verse
\renewcommand{\mtc@verse}[1]{\oldmtc@verse{#1}\setlength{\baselineskip}{\z@}}

% Environments
%
% This macro define an environment for front matter that is always 
% single column even in a double-column document.
\newenvironment{alwayssingle}{%
       \@restonecolfalse
       \if@twocolumn\@restonecoltrue\onecolumn
       \else\if@openright\cleardoublepage\else\clearpage\fi
       \fi}%
       {\if@restonecol\twocolumn
       \else\newpage\thispagestyle{empty}\fi}

% DEDICATION
%
% The dedication environment makes sure the dedication gets its
% own page and is set out in verse format.

\newenvironment{dedication}
{\begin{alwayssingle}
  \thispagestyle{empty}
  \vspace*{\fill} \begin{center}}
{\end{center}\vspace*{\fill}\vspace*{\fill} \end{alwayssingle}}

%ROMANPAGES
%
% The romanpages environment set the page numbering to lowercase roman one
% for the contents and figures lists. It also resets
% page-numbering for the remainder of the dissertation (arabic, starting at 1).
%
% Edited by JEM

\newenvironment{romanpages}
{\cleardoublepage\setlength{\baselineskip}{\frontmatterbaselineskip}\setcounter{page}{1}\renewcommand{\thepage}{\roman{page}}}
{\cleardoublepage\setcounter{page}{1}\renewcommand{\thepage}{\arabic{page}}}


%Figure placement on page
%
%This is to help prevent too many figures on their own pages.  I got it from:
% http://dcwww.camd.dtu.dk/~schiotz/comp/LatexTips/LatexTips.html#captfont

%\renewcommand{\topfraction}{0.85}
%\renewcommand{\textfraction}{0.1}
%\renewcommand{\floatpagefraction}{0.75}


% JEM: VERSE, QUOTATION, and QUOTE must be single-spaced.
% These rename the internal commands for the \begin{...} and
% \end{...} environment commands.
\let\@ldquote=\quote
\let\@ldendquote=\endquote
\renewenvironment{quote}
   {\@ldquote\setlength{\baselineskip}{\singlebaselineskip}}
   {\@ldendquote}

\let\@ldqttn=\quotation
\let\@ldendqttn=\endquotation
\renewenvironment{quotation}
   {\@ldqttn\setlength{\baselineskip}{\singlebaselineskip}}
   {\@ldendqttn}

\let\@ldverse=\verse
\let\@ldendverse=\endverse
\renewenvironment{verse}
   {\@ldverse\setlength{\baselineskip}{\singlebaselineskip}}
   {\@ldendverse}

\usepackage[grey,utopia]{quotchap} 
	% To put nice quotes at the beginning of the chapters
\usepackage[nottoc]{tocbibind}
	% Used for inserting the Bibliography, List of Figures, indices, etc into the table of contents.

% JEM: Allow flexible spacing after figures, to reduce other stretching
\setlength{\textfloatsep}{0pt plus0pt minus0pt}

% JEM: Fix paragraph spacing within quotes for multi-par quotes
\renewenvironment{savequote}[1][10cm]{%
\begin{lrbox}{\@quotebox}
\begin{minipage}[t]{#1}\footnotesize\slshape%
\setlength{\parskip}{6px}}{%
\unskip\end{minipage}\end{lrbox}
\global\setbox\@quotebox\copy\@quotebox
\global\let\@printcites\@iprintcites
\ignorespacesafterend}
\renewcommand{\qauthor}[1]{\par
{\raggedleft\upshape #1\qquad\hbox{}\par}\bigskip}

% JEM: All of this is so that headers in these sections aren't uppercase
\let\@ldtoc\tableofcontents
\renewcommand*\tableofcontents{{%
\renewcommand*\MakeUppercase[1]{##1}\@ldtoc}}
\let\@ldlof\listoffigures
\renewcommand*\listoffigures{{%
\renewcommand*\MakeUppercase[1]{##1}\@ldlof}}
\let\@ldlot\listoftables
\renewcommand*\listoftables{{%
\renewcommand*\MakeUppercase[1]{##1}\@ldlot}}
\let\@ldbib\bibliography
\renewcommand*\bibliography[1]{{%
\renewcommand*\MakeUppercase[1]{##1}\@ldbib{#1}}}

% JEM: for crazy multi character set quotes and Unicode and all
\usepackage{lmodern}
\usepackage[LGR,TS1,T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage[greek,latin,english]{babel}
\usepackage{csquotes}
\hyphenpenalty=500
\def\longs{{\fontencoding{TS1}\selectfont s}}

% JEM: for highlighting corrections
\newlength{\mccurrentbaselineskip}
\newlength{\mccurrentparskip}
\newlength{\mccurrentparindent}
\newif\ifcorrections
\newif\ifm@csection
\m@csectionfalse
\correctionsfalse

\colorlet{shadecolor}{blue!20}

\usepackage{framed}
\OuterFrameSep=-9pt
\newenvironment{mccorrection}
{\ifcorrections\if@nobreak\m@csectiontrue\fi\begin{shaded}\ifm@csection\noindent\ignorespaces\fi\fi}
{\ifcorrections\end{shaded}\m@csectionfalse\ifx\@captype\@undefined\@nobreakfalse\fi\fi}

\usepackage{soul}
\sethlcolor{shadecolor}
\newcommand{\mccorrect}[1]{\ifcorrections\hl{#1}\else#1\fi}


% JEM: adjust start-of-chapter spacing
\renewcommand{\chapterheadstartvskip}{
	\thispagestyle{empty}
	\vspace*{40pt}
}
\renewcommand{\chapterheadendvskip}{\vspace{30pt}}


% JEM: combine all of the commands you run before appendices start
\newcommand{\startappendices}
  {\appendix\adjustmtc\noappendicestocpagenum\appendixpage}
  % {\appendix\adjustmtc\noappendicestocpagenum\addappheadtotoc\appendixpage}