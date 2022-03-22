#!/bin/sh
set -e

if [ $# -eq 1 ]; then
  manuscript="./sample-manuscript"
elif [ $# -eq 2 ]; then
  manuscript=$2
else
    echo "Wrong input"
    exit 1
fi

case "$1" in
  -p| --print) scriptToRun="./src/scripts/pdf.sh print book" ;;

  -s| --screen) scriptToRun="./src/scripts/pdf.sh screen report" ;;

  -e| --epub) scriptToRun="./src/scripts/epub.sh" format="epub";;

  -a| --all) ./convert.sh -e "$manuscript"; ./convert.sh -p "$manuscript"; ./convert.sh -s "$manuscript" ; exit ;;

   *) printf "Unknown option %s\n" "$1" ; exit 1;;
esac

mkdir -p .tmp-manuscript && cp -r "$manuscript"/* ./.tmp-manuscript

docker run --rm \
  --volume "$PWD":/data \
  -u "$(id -u "$USER"):$(id -g "$USER")" \
  savvily-book-generator \
  $scriptToRun

rm -rf .tmp-manuscript

if [ "$format" = "epub" ]; then
  source ./src/scripts/epubFormatter.sh
fi



