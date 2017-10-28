\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{dithesis}

\DeclareOption*{\PackageWarning{dithesis}{Unknown Option \CurrentOption}}

\ProcessOptions\relax
\LoadClass[12pt, a4paper, oneside]{book}

\RequirePackage[iso-8859-7]{inputenc}
\RequirePackage{graphicx}
\RequirePackage{multirow}
\RequirePackage[a4paper,margin=2cm]{geometry}
\RequirePackage{multicol}
\RequirePackage[naturalnames]{hyperref} 
\RequirePackage[sort,numbers]{natbib}
\RequirePackage{fullpage}
\RequirePackage{ifthen}
\RequirePackage{tocloft}
\RequirePackage{fancyhdr}
\RequirePackage[english, greek]{babel}
% \RequirePackage{packages/grtimes}
\RequirePackage{grtimes}
\RequirePackage{color}
\RequirePackage{mfirstuc}
 \RequirePackage{packages/nomencl}
% \RequirePackage{nomencl}
% \RequirePackage[style=long, header=plain, cols=3]{glossaries} 
 \RequirePackage[style=long, header=plain, cols=3]{packages/glossary} 
\RequirePackage{keyval}

\RequirePackage{rotating}
\RequirePackage{xspace}
\RequirePackage{subfig}
\RequirePackage{caption}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}
\RequirePackage{amsmath}


\setlength{\hoffset}{-1in}
\setlength{\voffset}{-1in}
\setlength{\oddsidemargin}{2.5cm}
\setlength{\evensidemargin}{2cm}
\setlength{\marginparwidth}{0cm}
\setlength{\marginparsep}{0cm}
\setlength{\topmargin}{0.75cm}
\setlength{\headheight}{1.25cm}
\setlength{\footskip}{2cm}
\setlength{\paperwidth}{21cm}
\setlength{\paperheight}{29.7cm}
\setlength{\headsep}{1cm}
\setlength{\parindent}{0cm}
\setlength{\parskip}{6pt}

\renewcommand{\baselinestretch}{1.5}

%%%%%%%%%%%
%% Initialize
\def\inappendix{0}
\newcounter{appendices}
\setcounter{appendices}{0}
\makeglossary
\makenomenclature
\setcounter{secnumdepth}{2}
\pagestyle{empty}
\renewcommand{\headrulewidth}{0pt}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tables of contents, figures and tables
\renewcommand{\cftsetpnumwidth}{4em}
\newcommand{\cftsetmarg}{6em}
\newcommand{\@linewidth}{\textwidth}

\renewcommand{\cftchappresnum}{\gr{KEFALAIO }}  
\setlength{\cftchapnumwidth}{8em}
\setcounter{tocdepth}{1}

\newcommand{\makeLOF}{
\clearpage
\renewcommand{\cftloftitlefont}{\hfill\Large}
\renewcommand{\listfigurename}{\large \bfseries\greektext{KATALOGOS SQHMATWN}}
\renewcommand{\cftafterloftitle}{\hfill}
\listoffigures}

\newcommand{\makeLOT}{
\clearpage
\renewcommand{\cftlottitlefont}{\hfill\Large}
\renewcommand{\listtablename}{\large \bfseries \greektext{KATALOGOS PINAKWN}}
\renewcommand{\cftafterlottitle}{\hfill}
\listoftables }

\newcommand{\makeTOC}{
\clearpage
\renewcommand{\cfttoctitlefont}{\hfill\Large}
\renewcommand{\contentsname}{\large \bfseries\greektext{PERIEQOMENA}}
\renewcommand{\cftaftertoctitle}{\hfill}
\tableofcontents}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Language controls
\newcommand{\el}{\selectlanguage{greek} \renameTheorems{gr}}
\newcommand{\en}{\selectlanguage{english} \renameTheorems{en}}
\newcommand{\la}{\latintext}
\newcommand{\gr}{\greektext}
\renewcommand{\rmdefault}{phv}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Theorems

\newcommand{\renameTheorems}[1]{
\ifthenelse{\equal{#1}{gr}}{\def\lemmaname{L'hmma} \def\theoremname{Je'wrhma} \def\propositionname{Pr'otash} \def\corollaryname{P'orisma} \def\definitionname{Orism'os} \def\examplename{Par'adeigma}}{\def\lemmaname{Lemma} \def\theoremname{Theorem} \def\propositionname{Proposition} \def\corollaryname{Corollary} \def\definitionname{Definition} \def\examplename{Example}}
}

\newtheorem{theorem}{\theoremname}[section]
\newtheorem{lemma}[theorem]{\lemmaname}
\newtheorem{proposition}[theorem]{\propositionname}
\newtheorem{corollary}[theorem]{\corollaryname}
\newtheorem{definition}[theorem]{\definitionname}
\newtheorem{example}{\examplename}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subfigures
\renewcommand{\thesubfigure}{\thefigure.\arabic{subfigure}}
\captionsetup[subfigure]{labelformat=simple,labelsep=colon,                          listofformat=subsimple}
\makeatletter
  \renewcommand{\p@subfigure}{}
\makeatother
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
\makeatletter
	\def\thebibliography#1{\section*{\newpage \thispagestyle{empty} \centering\gr{ANAFORES}\la\@mkboth
	{\gr{ANAFORES}}{\gr{ANAFORES}}{\addcontentsline{toc}{chapter}{\gr{ANAFORES}}}}\list
	{[\arabic{enumi}]}{\settowidth\labelwidth{[#1]}\leftmargin\labelwidth
	\advance\leftmargin\labelsep
	\usecounter{enumi}}
	\def\newblock{\hskip .11em plus .33em minus .07em}
	\sloppy\clubpenalty4000\widowpenalty4000
	\sfcode`\.=1000\relax}
\makeatother
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Command to add Prologue, Chapters, Glossaries, Appendices and Bibliography
\newcommand{\addAppendix}[2]{
\clearpage
\pagestyle{fancy}
\addtocounter{appendices}{1}
\chapter*{}
\addtocounter{chapter}{-1}
\addcontentsline{toc}{chapter}{\gr{\Alph{appendices}' PARARTHMA - }#1}
{\centering \large \bfseries\gr{\Alph{appendices}' PARARTHMA }
\par\nobreak
\centering \large \bfseries{#1} \par\nobreak
\vskip 3em}
\input{#2}
}

\newcommand{\addChapter}[2]{
\clearpage
\pagestyle{fancy}
\chapter{#1}
\input{#2}
}

\newcommand{\addPrologue}[1]{
\clearpage
\thispagestyle{empty}

\addcontentsline{toc}{chapter}{\gr{PROLOGOS}}
{\centering \large \bfseries \gr{PROLOGOS} 
\par\nobreak
\vskip 3em}
\input{#1}
}


\newcommand{\addOrologia}{
\chapter*{}
\addtocounter{chapter}{-1}
\pagestyle{fancy}
\def\glossaryname{}
\addcontentsline{toc}{chapter}{\gr{OROLOGIA}}
{\centering \large \bfseries \gr{OROLOGIA}
\par\nobreak
\vskip 3em}
\printglossary
}

\newcommand{\addNomenclature}{
%   \chapter*{}
% \addtocounter{chapter}{-1}
\pagestyle{fancy}
\addcontentsline{toc}{chapter}{\gr{SUNTMHSEIS - ARKTIKOLEXA - AKRWNUMIA}}
\def\nomname{\centering \large \bfseries \gr{SUNTMHSEIS - ARKTIKOLEXA - AKRWNUMIA} 
\par\nobreak
\vskip 3em}
\printnomenclature
}

\newcommand{\addBibliography}[1]{\en \bibliography{#1} \bibliographystyle{abbrv} }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Commands
\newcommand{\addToGlossary}[3]{
\glossary{name={#2} , description={#3}, sort={#1}}
}

\newcommand{\addToNomenclature}[3]{
\nomenclature[#1]{#2}{#3}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Definitions of the thesis data
\newcommand{\greekAbstract}[1]{
\def\grabstract{#1}
}

\newcommand{\englishAbstract}[1]{
\def\enabstract{#1}
}

\newcommand{\thesisCredits}[1]{
\def\thesiscredits{#1}
}

\def\authors{0}
\newcommand{\thesisAuthor}[2]{
  \if \authors 2 \def\thesisAuthorIII{#1} \def\AMIII{#2} \def\authors{3} \fi
  \if \authors 1 \def\thesisAuthorII{#1} \def\AMII{#2} \def\authors{2} \fi
  \if \authors 0 \def\thesisAuthorI{#1} \def\AMI{#2} \def\authors{1} \fi}


\newcommand{\nameInFooter}[1]{\def\nameInFooter{#1}}
\newcommand{\thesisTitle}[1]{\def\thesisTitle{#1}}
\newcommand{\thesisDate}[1]{\def\thesisDate{#1}}
\newcommand{\greekClassification}[1]{\def\greekClassification{#1}}
\newcommand{\englishClassification}[1]{\def\englishClassification{#1}}
\newcommand{\AM}[1]{\def\AM{#1}}

\def\advisors{0}
\newcommand{\thesisAdvisor}[2]{
  \if \advisors 2 \def\thesisAdvisorIII{#1} \def\thesisAdvisorPositionIII{#2} \def\advisors{3} \fi
  \if \advisors 1 \def\thesisAdvisorII{#1} \def\thesisAdvisorPositionII{#2} \def\advisors{2} \fi
  \if \advisors 0 \def\thesisAdvisorI{#1} \def\thesisAdvisorPositionI{#2} \def\advisors{1} \fi}

\def\examiners{0}
\newcommand{\thesisExaminer}[2]{
  \if \examiners 2 \def\examinerIII{#1} \def\thesisExaminerPositionIII{#2} \def\examiners{3} \fi
  \if \examiners 1 \def\examinerII{#1} \def\thesisExaminerPositionII{#2}  \def\examiners{2} \fi
  \if \examiners 0 \def\examinerI{#1} \def\thesisExaminerPositionI{#2} \def\examiners{1} \fi}

\def\gkeywords{0}
\newcommand{\greekKeyword}[1]{
  \if \gkeywords 5 \def\gkeywordVI{#1} \def\gkeywords{6} \fi
  \if \gkeywords 4 \def\gkeywordV{#1} \def\gkeywords{5} \fi
  \if \gkeywords 3 \def\gkeywordIV{#1} \def\gkeywords{4} \fi
  \if \gkeywords 2 \def\gkeywordIII{#1} \def\gkeywords{3} \fi
  \if \gkeywords 1 \def\gkeywordII{#1} \def\gkeywords{2} \fi
  \if \gkeywords 0 \def\gkeywordI{#1} \def\gkeywords{1} \fi}

\def\lkeywords{0}
\newcommand{\englishKeyword}[1]{
  \if \lkeywords 5 \def\lkeywordVI{#1} \def\lkeywords{6} \fi
  \if \lkeywords 4 \def\lkeywordV{#1} \def\lkeywords{5} \fi
  \if \lkeywords 3 \def\lkeywordIV{#1} \def\lkeywords{4} \fi
  \if \lkeywords 2 \def\lkeywordIII{#1} \def\lkeywords{3} \fi
  \if \lkeywords 1 \def\lkeywordII{#1} \def\lkeywords{2} \fi
  \if \lkeywords 0 \def\lkeywordI{#1} \def\lkeywords{1} \fi}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Headers and Footers

\newcommand{\headfoot}{
\fancyfoot[RO, RE]{\small\thepage}
\fancyfoot[LE]{\gr\footnotesize \nameInFooter}
\fancyfoot[LO]{\gr\footnotesize \nameInFooter}
%\fancyfoot[LO]{\gr\footnotesize Diplwmatik'h Ergas'ia}
\fancyfoot[c]{ }

\fancyhead[RO]{ }%{\nouppercase \rightmark}
%\fancyhead[LO]{\footnotesize \leftmark}
\fancyhead[LO]{\gr \footnotesize \thesisTitle}
\fancyhead[LE]{\gr \footnotesize \thesisTitle}
\fancyhead[RE]{ }
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The Open Thesis function
\newcommand{\openThesis}{

\thispagestyle{empty} 
\begin{center}
\includegraphics[width = 1.0in]{packages/revATHENA.eps}
\end{center}
 \begin{center}
{\textbf{\large EJNIKO KAI KAPODISTRIAKO PANEPISTHMIO AJHNWN} \par}%
{\textbf{SQOLH JETIKWN EPISTHMWN} \par}%
{\textbf{TMHMA PLHROFORIKHS KAI THLEPIKOINWNIWN} \par}%
{\textbf{PROGRAMMA METAPTUQIAKWN SPOUDWN} \par}%
\end{center}%


\vskip 2em%
\begin{center}%
{\textbf{DIPLWMATIKH ERGASIA} \par}%
\end{center}%

\vskip 1em
\begin{center}%
{\Large  \thesisTitle }%
\end{center}%

\vskip 1em%

{\textbf{
\if \authors 1 \begin{center} \thesisAuthorI \end{center} \vskip 6em \fi
\if \authors 2 \begin{center} \thesisAuthorI \\ \thesisAuthorII \end{center} \vskip 5em \fi
\if \authors 3 \begin{center} \thesisAuthorI \\ \thesisAuthorII \\ \thesisAuthorIII \end{center} \vskip 3em \fi
}}

\if \advisors 1 \hspace*{0.7in} Epibl'epwn: \textbf{\thesisAdvisorI}, \thesisAdvisorPositionI \vskip 5em \fi 
\if \advisors 2 \hspace*{0.7in} Epibl'epontes:  \textbf{\thesisAdvisorI}, \thesisAdvisorPositionI \newline \hspace*{1.81in} \textbf{\thesisAdvisorII}, \thesisAdvisorPositionII \vskip 4em \fi
\if \advisors 3 \hspace*{0.7in} Epibl'epontes:  \textbf{\thesisAdvisorI}, \thesisAdvisorPositionI \newline \hspace*{1.81in} \textbf{\thesisAdvisorII}, \thesisAdvisorPositionII \newline \hspace*{1.81in} \textbf{\thesisAdvisorIII}, \thesisAdvisorPositionIII \vskip 3em \fi %'

\begin{center}%
{\textbf{AJHNA} \par}%
{\textbf{\thesisDate} \par}%
\end{center}%

\newpage
\thispagestyle{empty}

\null  %giati?
\vskip 5em%
\begin{center}%
{\textbf{DIPLWMATIKH ERGASIA} \par}%
\end{center}%


\vskip 5em
\begin{center}%
{\Large  \thesisTitle }%
\end{center}%

\vskip 2em%

{
\if \authors 1 \begin{center} \textbf{\thesisAuthorI} \\ \AMI \end{center} \vskip 6em \fi
\if \authors 2 \begin{center} \textbf{\thesisAuthorI} \\ \AMI \\ \textbf{\thesisAuthorII} \\ \AMII \end{center} \vskip 5em \fi
\if \authors 3 \begin{center} \textbf{\thesisAuthorI} \\ \AMI \\ \textbf{\thesisAuthorII} \\ \AMII \\ \textbf{\thesisAuthorIII} \\ \AMIII \end{center} \vskip 3em \fi
}

\if \advisors 1 \hspace*{0.7in} \textbf{EPIBLEPWN:} \\ \hspace*{1.5in} \textbf{\thesisAdvisorI}, \thesisAdvisorPositionI \vskip 5em \fi 
\if \advisors 2 \hspace*{0.7in} \textbf{EPIBLEPONTES:} \\ \hspace*{1.5in} \textbf{\thesisAdvisorI}, \thesisAdvisorPositionI \newline \hspace*{1.5in} \textbf{\thesisAdvisorII}, \thesisAdvisorPositionII \vskip 4em \fi
\if \advisors 3 \hspace*{0.7in} \textbf{EPIBLEPONTES:} \\ \hspace*{1.5in} \textbf{\thesisAdvisorI}, \thesisAdvisorPositionI \newline \hspace*{1.5in} \textbf{\thesisAdvisorII}, \thesisAdvisorPositionII \newline \hspace*{1.5in} \textbf{\thesisAdvisorIII}, \thesisAdvisorPositionIII \vskip 3em \fi 

\if \examiners 1 \hspace*{0.7in} \textbf{EXETASTIKH EPITROPH:} \\ \hspace*{1.5in} \textbf{\examinerI}, \thesisExaminerPositionI \vskip 5em \fi 
\if \examiners 2 \hspace*{0.7in} \textbf{EXETASTIKH EPITROPH:} \\ \hspace*{1.5in} \textbf{\examinerI}, \thesisExaminerPositionI \\ \hspace*{1.5in} \textbf{\examinerII}, \thesisExaminerPositionII \vskip 4em \fi
\if \examiners 3 \hspace*{0.7in} \textbf{EXETASTIKH EPITROPH:} \\ \hspace*{1.5in} \textbf{\examinerI}, \thesisExaminerPositionI \\ \hspace*{1.5in} \textbf{\examinerII}, \thesisExaminerPositionII \\ \hspace*{1.5in} \textbf{\examinerIII}, \thesisExaminerPositionIII \vskip 3em \fi

\begin{center}%
{\textbf{\thesisDate} \par}%
\end{center}%
\newpage
\thispagestyle{empty} 
\begin{center}
{\large \textbf{\gr PERILHYH}} 
\end{center}
\vskip1.0in

\grabstract

\vspace{2.0in}

JEMATIKH ENOTHTA: \greekClassification \par
\vspace{0.1in}
LEXEIS KLEIDIA:
\if \gkeywords 1 \gkeywordI \fi
\if \gkeywords 2 \gkeywordI, \gkeywordII \fi
\if \gkeywords 3 \gkeywordI, \gkeywordII, \gkeywordIII \fi 
\if \gkeywords 4 \gkeywordI, \gkeywordII, \newline \hspace*{1.6in} \gkeywordIII, \gkeywordIV \fi 
\if \gkeywords 5 \gkeywordI, \gkeywordII, \gkeywordIII, \newline \hspace*{1.6in} \gkeywordIV, \gkeywordV \fi 
\if \gkeywords 6 \gkeywordI, \gkeywordII, \gkeywordIII, \newline \hspace*{1.6in} \gkeywordIV, \gkeywordV, \gkeywordVI \fi 

\newpage

\la
\newpage
\thispagestyle{empty} 
\begin{center}
{\large \textbf{ABSTRACT}} 
\end{center}
\vskip1.0in

\enabstract

\vspace{2.0in}

SUBJECT AREA: \englishClassification \par
\vspace{0.1in}
KEYWORDS:
\if \lkeywords 1 \lkeywordI \fi
\if \lkeywords 2 \lkeywordI, \lkeywordII \fi
\if \lkeywords 3 \lkeywordI, \lkeywordII, \lkeywordIII \fi 
\if \lkeywords 4 \lkeywordI, \lkeywordII, \newline  \hspace*{1.6in} \lkeywordIII, \lkeywordIV \fi 
\if \lkeywords 5 \lkeywordI, \lkeywordII,  \lkeywordIII, \newline \hspace*{1.6in} \lkeywordIV, \lkeywordV \fi 
\if \lkeywords 6 \lkeywordI, \lkeywordII,  \lkeywordIII, \newline \hspace*{1.6in} \lkeywordIV, \lkeywordV, \lkeywordVI \fi 

 
\makeTOC
\makeLOF
\makeLOT
\headfoot

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% OTHER

\makeatletter
\def\@makechapterhead#1{%
  {\parindent \z@ \raggedright \normalfont
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
        \centering \large \bfseries \greektext{KEFALAIO}\space\thechapter
        \par\nobreak
        \vskip 1\p@
      \fi
    \fi
    \interlinepenalty\@M
    \centering \large \bfseries  #1 \par\nobreak
    \vskip 15\p@
  }}

\def\@makeschapterhead#1{%
  \vspace*{50\p@}%
  {\parindent \z@ \raggedright
    \normalfont
    \interlinepenalty\@M
    \large \bfseries  #1\par\nobreak
  }}

\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                   {\large\bfseries}}
\makeatother