#!/bin/sh

mkdir -p output/.tmp && cd .manuscript || exit

# Process book opening section
xelatex -output-directory ./../output/.tmp ../src/templates/screen/opening.tex && \

# Process chapters
# Sort all chapters and cat them to stdout
find . -maxdepth 1 -name "[0-9]*.txt" -o -name '[0-9]*.md' | sort -V | xargs  cat | \

# Ensure: h1 headers work, links respect md format, code block languages are passed as capitalized titles
sed -Ee 's:(^#):\n\1:' -Ee 's:] \(:](:g' -Ee 's:(```)(.+)$:\1{title=\u\2}:' | \

pandoc \
    --pdf-engine=xelatex \
    --template=../src/templates/screen/custom-report.tex \
    --listings \
    -V documentclass=report \
    -f markdown-implicit_figures \
    -o ./../output/.tmp/tmp_book_for_screen.pdf  && \

# Process book closing section
find ./closing/ -name "[0-9]*.txt" -o -name '[0-9]*.md' | sort -V | xargs  cat | \
# Ensure: h1 headers work, links respect md format, code block languages are passed as capitalized titles
sed -Ee 's:(^#):\n\1:' -Ee 's:] \(:](:g' -Ee 's:(```)(.+)$:\1{title=\u\2}:' | \

pandoc \
    --pdf-engine=xelatex\
    --template=../src/templates/screen/closing.tex\
    --listings -V documentclass=report\
    -f markdown-implicit_figures\
    -o ./../output/.tmp/closing.pdf && \

# Join opening, chapters and closing sections
gs \
  -q \
  -dNOPAUSE \
  -dBATCH \
  -sDEVICE=pdfwrite \
  -sOutputFile=./../output/book_for_screen.pdf \
  ./../output/.tmp/opening.pdf ./../output/.tmp/tmp_book_for_screen.pdf ./../output/.tmp/closing.pdf && \

rm -rf ../output/.tmp && \

echo "PDF for screen successfully generated"
