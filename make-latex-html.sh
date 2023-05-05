#!/bin/sh
#assemble and preprocess all the sources files
rm -rf web
mkdir web 
pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > web/pre.html
pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > web/intro.html

for filename in text/ch*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=Dynabook.lua --to markdown |pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --lua-filter=footnote.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --wrap=none --to html > web/"$(basename "$filename" .txt).html"
done

pandoc text/epi.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to html > web/epi.html

for filename in text/apx*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to html > web/"$(basename "$filename" .txt).html"
done


#sed -i '' 's+Figure+Εικόνα+g' ./latex/ch0*
pandoc -s web/*.html -o web/index.html --metadata title="Tzourmanas book"
#pandoc -N --quiet --variable "geometry=margin=1.2in" --variable mainfont="Nimbus Sans" --variable sansfont="Nimbus Sans" --variable monofont="Nimbus Sans" --variable fontsize=12pt --variable version=2.0 book.tex --pdf-engine=xelatex --toc -o book.pdf
pandoc -N --quiet --variable "geometry=margin=1.2in" --variable mainfont="MesloLGS NF" --variable sansfont="MesloLGS NF" --variable monofont="MesloLGS NF" --variable fontsize=12pt --variable version=2.0 book.tex --pdf-engine=xelatex --toc -o book.pdf
pandoc -o book.epub web/index.html --metadata title="Tzourmanas book"
mv book.epub book/book.ebub
mv book.pdf book/book.pdf
echo "#lang pollen" > web/book.html.pmd
cat web/index.html >> web/book.html.pmd
raco pollen render web/index.html.pmd
rm -rf web/compiled
rm-rf web/book.html.pmd
