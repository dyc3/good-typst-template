# good-typst-template
My personal typst template repo that includes CI, mermaid/plantuml figures, and other useful bits.

## Setup

1. Install [typst](https://typst.app)
2. Install [mermaid-cli](https://github.com/mermaid-js/mermaid-cli) (requires node.js)
```
npm install -g @mermaid-js/mermaid-cli@10.6.1
```
Note: Running in WSL may require some additional setup for mermaid to work. See: https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-on-wsl-windows-subsystem-for-linux

## Usage

if you have `make` installed, you can run these:

```bash
# build the document
make

# rerender all figures
make figures
```

Otherwise, you can run the commands in the `makefile` manually.

```bash
# produces main.pdf
typst compile main.typ

# rerenders all figures
./scripts/render-figures.sh
```
