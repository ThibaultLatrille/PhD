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

% JEM: for crazy multi character set quotes and Unicode and all
\usepackage{lmodern}
\usepackage[utf8]{inputenc}
\usepackage[english]{babel}

\newif\ifmc@nobind
\mc@nobindfalse

\DeclareOption{nobind}{\mc@nobindtrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax

\interfootnotelinepenalty=10000

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

\usepackage{xcolor, colortbl}
\usepackage{pifont}
\definecolor{RED}{HTML}{EB6231}
\definecolor{YELLOW}{HTML}{E29D26}
\definecolor{BLUE}{HTML}{5D80B4}
\definecolor{LIGHTGREEN}{HTML}{6ABD9B}
\definecolor{GREEN}{HTML}{8FB03E}
\definecolor{PURPLE}{HTML}{BE1E2D}
\definecolor{BROWN}{HTML}{A97C50}
\definecolor{PINK}{HTML}{DA1C5C}
\definecolor{PURPLEDARK}{cmyk}{0, 0.5, 0, 0.7}
\definecolor{PURPLELIGHT}{cmyk}{0, 0.12, 0, 0.2}
\definecolor{PURPLEGREY}{cmyk}{0, 0.5, 0, 0.55}
\definecolor{GREYDARK}{cmyk}{0, 0, 0, 0.92}
\definecolor{BLUELINK}{HTML}{0645AD}
\definecolor{DARKBLUELINK}{HTML}{0B0080}
\definecolor{LIGHTBLUELINK}{HTML}{3366BB}
\definecolor{PURPLELINK}{HTML}{663366}


\usepackage{fancyhdr}
\setlength{\headheight}{15pt}
\fancypagestyle{empty}{ %
	\fancyhf{} % remove everything
	\renewcommand{\headrulewidth}{0pt} % remove lines as well
	\renewcommand{\footrulewidth}{0pt}
}

\fancypagestyle{plain}{ %
	\fancyhf{} % remove everything
	\renewcommand{\headrulewidth}{0pt} % remove lines as well
	\renewcommand{\footrulewidth}{0pt}
	\cfoot{\thepage}
}

\fancypagestyle{fancybook}{ %
	\fancyhf{} % remove everything
	\renewcommand{\chaptermark}[1]{\markboth{\thechapter. ##1}{\thechapter. ##1}}
	\renewcommand{\sectionmark}[1]{\markright{\thesection. ##1}}
	\renewcommand{\headrulewidth}{1pt}
	\cfoot{\thepage}
	\if@twoside
	\fancyhead[LO]{\emph{\leftmark}} 
	\fancyhead[RE]{\emph{\rightmark}}
	\else
	\fancyhead[L]{\emph{\rightmark}}
	\fi
}

\pagestyle{plain}

% JEM fix header on cleared pages for openright
\def\cleardoublepage{\clearpage
\if@twoside
   \ifodd
   	   \c@page
   \else
	   \hbox{}
	   \thispagestyle{plain}
	   \newpage
	   \thispagestyle{plain}
   \fi
\fi}

% Epigraphs
\usepackage{epigraph}
\renewcommand\epigraphflush{flushright}
\renewcommand\epigraphsize{\normalsize}
\setlength\epigraphwidth{0.7\textwidth}
	
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
	\else\newpage\thispagestyle{plain}\fi}

% DEDICATION
%
% The dedication environment makes sure the dedication gets its
% own page and is set out in verse format.
\newenvironment{dedication}
{\begin{alwayssingle}
		\thispagestyle{plain}
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


% Uncomment this if you want equation numbers per section (2.3.12), instead of per chapter (2.18):
%\numberwithin{equation}{subsection}
\usepackage{amssymb,amsfonts,amsmath,amsthm,mathtools}
\usepackage{cancel}
\usepackage{xfrac, nicefrac}
\usepackage{blkarray}
\usepackage{pgf,tikz}
\usetikzlibrary{positioning,arrows,automata,calc}
\usepackage{bm}
\usepackage{listings, enumerate, enumitem}
\usepackage[export]{adjustbox}
\usepackage{tabu}
\tabulinesep=0.6mm
\newcommand\cellwidth{\TX@col@width}
\usepackage{hhline}
\setlength{\arrayrulewidth}{1.2pt}
\usepackage{multicol,multirow,array}
\usepackage{etoolbox}
\AtBeginEnvironment{tabu}{\footnotesize}

\usepackage[nottoc]{tocbibind}
% Used for inserting the Bibliography, List of Figures, indices, etc into the table of contents.
\usepackage{notoccite}
% Titles for toc
\usepackage{titletoc}
% To format the bibliography	
\usepackage[nohints,tight]{minitoc}
\setcounter{minitocdepth}{2} 
% Generates mini tables of contents per chapter
% JEM: The following fixes minitoc to not be multiple-spaced.
\let\oldmtc@verse\mtc@verse
\renewcommand{\mtc@verse}[1]{\oldmtc@verse{#1}\setlength{\baselineskip}{\z@}}
% spacing lines
\usepackage{setspace}
\newcommand{\tocless}[2]{\bgroup\let\addcontentsline=\nocontentsline#1{#2}\egroup}

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

\renewcommand{\numberline}[1]{#1~}

% Figure placement on page
% JEM: Allow flexible spacing after figures, to reduce other stretching
\usepackage{pdfpages}
\pdfinclusioncopyfonts=1
\pdfsuppresswarningpagegroup=1
\setlength{\textfloatsep}{0pt plus0pt minus0pt}
\usepackage{float}
\usepackage[font={small,it},labelfont=bf]{caption}

%This is to help prevent too many figures on their own pages.  I got it from:
% http://dcwww.camd.dtu.dk/~schiotz/comp/LatexTips/LatexTips.html#captfont

%\renewcommand{\topfraction}{0.85}
%\renewcommand{\textfraction}{0.1}
%\renewcommand{\floatpagefraction}{0.75}

%%%%% SELECT YOUR DRAFT OPTIONS
% Three options going on here; use in any combination.  But remember to turn the first two off before
% generating a PDF to send to the printer!

% This adds a "DRAFT" footer to every normal page.  (The first page of each chapter is not a "normal" page.)
% \fancyfoot[C]{\color{PURPLEDARKsection} \emph{DRAFT Printed on \today}}

% This highlights (in blue) corrections marked with (for words) \mccorrect{blah} or (for whole
% paragraphs) \begin{mccorrection} . . . \end{mccorrection}.  This can be useful for sending a PDF of
% your corrected thesis to your examiners for review.  Turn it off, and the blue disappears.
% \correctionstrue

% To make text superscripts shortcuts
\usepackage{soul}
\renewcommand{\th}{\textsuperscript{th}}
\newcommand{\nd}{\textsuperscript{nd}}
\renewcommand{\st}{\textsuperscript{st}}
\newcommand{\rd}{\textsuperscript{rd}}

%%%%% PAGE DECORATION AND FORMATTING
\usepackage{titlesec}
\titleclass{\part}{top} 
\titleformat{\part}
[display]
{\centering\fontsize{36}{0}}
{\color{GREYDARK} \bfseries \centering \fontsize{36}{0}{\partname} \thepart}
{36pt}
{\color{GREYDARK} \bfseries \centering \fontsize{36}{0}}[\titlepagedecoration]

% Decorate title pages (for parts)
% JEM: adjust start-of-chapter spacing
\renewcommand{\chapterheadstartvskip}{
	\thispagestyle{plain}
	\vspace*{20pt}
}
\renewcommand{\chapterheadendvskip}{\vspace*{20pt}}

\newcommand\titlepagedecoration{%
	\thispagestyle{plain}
	\begin{tikzpicture}[remember picture,overlay,shorten >= -10pt]
	
	\coordinate (aux1) at ([yshift=-15pt]current page.north east);
	\coordinate (aux2) at ([yshift=-410pt]current page.north east);
	\coordinate (aux3) at ([xshift=-4.5cm]current page.north east);
	\coordinate (aux4) at ([yshift=-150pt]current page.north east);
	
	\begin{scope}[opacity=0.75,BLUE,line width=12pt,rounded corners=12pt]
	\draw
	(aux1) -- coordinate (a)
	++(225:5) --
	++(-45:5.1) coordinate (b);
	\draw[shorten <= -10pt]
	(aux3) --
	(a) --
	(aux1);
	\draw[opacity=0.5,YELLOW,shorten <= -10pt]
	(b) --
	++(225:2.2) --
	++(-45:2.2);
	\end{scope}
	\draw[opacity=0.75,RED,line width=8pt,rounded corners=8pt,shorten <= -10pt]
	(aux4) --
	++(225:0.8) --
	++(-45:0.8);
	\begin{scope}[opacity=0.75,LIGHTGREEN,line width=6pt,rounded corners=8pt]
	\draw[shorten <= -10pt]
	(aux2) --
	++(225:3) coordinate[pos=0.45] (c) --
	++(-45:3.1);
	\draw
	(aux2) --
	(c) --
	++(135:2.5) --
	++(45:2.5) --
	++(-45:2.5) coordinate[pos=0.3] (d);   
	\draw 
	(d) -- +(45:1);
	\end{scope}
	\end{tikzpicture}%
}
% Modify chapter color
\colorlet{chaptergrey}{PURPLELIGHT}
\renewcommand*\sectfont{\bfseries\color{PURPLEDARK}}

% Format titles
\titleformat{\section}
{\color{GREYDARK}\normalfont\Large\bfseries}
{\color{GREYDARK}\thesection}{1em}{}

\titleformat{\subsection}
{\color{GREYDARK}\normalfont\large\bfseries}
{\color{GREYDARK}\thesubsection}{1em}{}

\titleformat{\subsubsection}
{\color{GREYDARK}\normalfont\bfseries}
{\color{GREYDARK}\thesubsubsection}{1em}{}

\usepackage[colorlinks=false,pagebackref=true]{hyperref} 
% for linking between references, figures, TOC, etc in the pdf document
\hypersetup{colorlinks,
	linkcolor=DARKBLUELINK,
	anchorcolor=DARKBLUELINK,
	citecolor=DARKBLUELINK,
	filecolor=DARKBLUELINK,
	menucolor=DARKBLUELINK,
	urlcolor=BLUELINK
} % Color citation links in purple
\PassOptionsToPackage{unicode}{hyperref}
\PassOptionsToPackage{naturalnames}{hyperref}

%%%%% Glossary
\usepackage[toc, acronym]{glossaries}
\renewcommand*{\glstextformat}[1]{\textcolor{black}{#1}}
\makeglossaries

%%%%% BIBLIOGRAPHY SETUP
\usepackage{natbib} % add [numbers] if I want to count them
\newcommand*{\bibtitle}{References}
\usepackage{usebib}
\usepackage{backref}
\renewcommand*{\backrefsep}{,~}%
\renewcommand*{\backreftwosep}{,~}% ', and~'
\renewcommand*{\backreflastsep}{,~}% ' and~'

% Deal with backreferences in bibliography
\newcommand{\mapolicebackref}[1]{\hspace*{\fill} \mbox{\textit {\small #1}}}
\renewcommand*{\backref}[1]{}
\renewcommand*{\backrefalt}[4]{%
	\ifcase #1 \mapolicebackref{Not cited}
	\or \mapolicebackref{Cited at page #2}
	\else \mapolicebackref{Cited at pages #2}
	\fi
}


