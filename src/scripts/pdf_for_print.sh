#!/bin/sh

mkdir -p output/.tmp && cd .manuscript || exit

# Prepare book beginning and ending pages separately
xelatex -output-directory ./../output/.tmp ../src/templates/print/starting.tex && \

# Prepare MD
# Sort all chapters and cat them to stdout
find . -maxdepth 1 -name "[0-9]*.txt" -o -name '[0-9]*.md' | sort -V | xargs  cat | \

# Ensure: h1 headers work, links respect md format, code block languages are passed as capitalized titles
sed -Ee 's:(^#):\n\1:' -Ee 's:] \(:](:g' -Ee 's:(```)(.+)$:\1{title=\u\2}:' | \

# Run Pandoc on stdin
pandoc \
    --pdf-engine=xelatex \
    --template=../src/templates/print/custom-book.tex \
    --listings \
    -V documentclass=book \
    -f markdown-implicit_figures \
    -o ./../output/.tmp/tmp_book_for_print.pdf && \

find ./closing/ -name "[0-9]*.txt" -o -name '[0-9]*.md' | sort -V | xargs  cat | \
# Ensure: h1 headers work, links respect md format, code block languages are passed as capitalized titles
sed -Ee 's:(^#):\n\1:' -Ee 's:] \(:](:g' -Ee 's:(```)(.+)$:\1{title=\u\2}:' | \

# Process md additional fragments
pandoc \
    --pdf-engine=xelatex \
    --template=../src/templates/print/ending.tex \
    --listings -V documentclass=book \
    -f markdown-implicit_figures \
    -o ./../output/.tmp/ending.pdf && \

# Join pdf fragments
gs \
    -q \
    -dNOPAUSE \
    -dBATCH \
    -sDEVICE=pdfwrite \
    -sOutputFile=./../output/book_for_print.pdf \
    ./../output/.tmp/starting.pdf ./../output/.tmp/tmp_book_for_print.pdf ./../output/.tmp/ending.pdf && \

rm -rf ../output/.tmp && \

echo "PDF for print successfully generated"
