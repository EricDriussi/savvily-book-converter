#!/bin/sh

ARGS=$(getopt -a --options psea --long "print,screen,epub,all" -- "$@")

case "$1" in
	-p|--print)
		docker run --rm \
			--volume $PWD:/data \
			--entrypoint "./pdf_for_print.sh" \
			docker-book-generator
		shift;;
		
	-s|--screen)
		docker run --rm \
			--volume $PWD:/data \
			--entrypoint "./pdf_for_screen.sh" \
			docker-book-generator
		shift;;
		
	-e|--epub)
		docker run --rm \
			--volume $PWD:/data \
			--entrypoint "./epub.sh" \
			docker-book-generator
		docker run --rm \
			--volume $PWD:/data \
			--entrypoint "./epub_for_mobi.sh" \
			docker-book-generator
		shift;;
		
	-a|--all)
		./generate.sh -p; ./generate.sh -s; ./generate.sh -e
		shift;;

	--)
		break;;

	 *)
		printf "Unknown option %s\n" "$1"
		exit 1;;
esac
