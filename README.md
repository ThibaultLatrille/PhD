 [![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

# Thesis 

## Compilation
To compile the document, use the readily available script;
```bash
sh compile.sh 
````
To clean the unnecessary template files, use:
```bash
sh clean.sh 
````

## Glossary

Glossary entries are defined in ``sections/glossaire.tex``.
To automaticaly replaced all occurrences in the manuscript by their latex command, use the script ``sections/glossaire.py``
````latex
 \gls{ } 
    To print the term, lowercase. For example, \gls{maths} prints mathematics when used. 

\Gls{ } 
    The same as \gls but the first letter will be printed in uppercase. Example: \Gls{maths} prints Mathematics 

\glspl{ } 
    The same as \gls but the term is put in its plural form. For instance, \glspl{formula} will write formulas in your final document. 

\Glspl{ } 
    The same as \Gls but the term is put in its plural form. For example, \Glspl{formula} renders as Formulas. 
````

## Acronyme

Once this line is added, the command `\newacronym` will declare a new acronym. For the sake of an example, below is a description of the command `\newacronym{gcd}{GCD}{Greatest Common Divisor}`

    gcd is the label, used latter in the document to reference this acronym. 

    GCD the acronym itself. Usually acronyms are written in capital letters. 

    Greatest Common Divisor is the phrase this acronym is used for. 

After the acronyms have been included in the preamble, they can be used by means on the next commands:

````latex
\acrlong{ } 
    Displays the phrase which the acronyms stands for. Put the label of the acronym inside the braces. In the example, \acrlong{gcd} prints Greatest Common Divisor. 

\acrshort{ } 
    Prints the acronym whose label is passed as parameter. For instance, \acrshort{gcd} renders as GCD. 

\acrfull{ } 
    Prints both, the acronym and its definition. In the example the output of \acrfull{lcm} is Least Common Multiple (LCM). 
````

## License
Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). Voir [LICENSE.md](https://github.com/ThibaultLatrille/PhD/blob/master/LICENSE.md) pour plus d'informations.
