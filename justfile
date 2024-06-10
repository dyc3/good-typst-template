default:
	just --list

build:
	./scripts/generate-changelog.sh > changelog.csv
	typst compile --font-path ./fonts main.typ main.pdf

watch:
	typst watch --font-path ./fonts main.typ main.pdf

clean:
	rm *.pdf

figures:
	./scripts/render-figures.sh

full: figures build
