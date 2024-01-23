#!/bin/bash

cd "$(dirname "$0")/.." || exit 1

# for usage in WSL: you may need to install some libraries for mermaid to work
# See: https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-on-wsl-windows-subsystem-for-linux

# check for prerequisites
commands_not_found=()
for command in parallel java curl mmdc dot; do
	if ! command -v "$command" &> /dev/null; then
		commands_not_found+=("$command")
	fi
done

if [[ ${#commands_not_found[@]} -gt 0 ]]; then
	echo "ERROR: the following commands could not be found: ${commands_not_found[*]}"
	exit 1
fi

MERMAID_VERSION_PIN="10.6.1"

if [[ $(mmdc --version) != "$MERMAID_VERSION_PIN" ]]; then
	echo "ERROR: mmdc version $MERMAID_VERSION_PIN is required"
	echo "Install it with: npm install -g @mermaid-js/mermaid-cli@$MERMAID_VERSION_PIN"
	exit 1
fi

# find ./figures -type f -name "*.mmd" | while read -r file; do
# 	mmdc -i "$file" -c ./figures/mermaid.json -o "${file%.*}.svg"
# done

echo "Rendering Mermaid figures..."
time find ./figures -type f -name "*.mmd" | parallel mmdc -i "{}" -c ./figures/mermaid.json -o "{.}.svg"

if [[ ! -f plantuml.jar ]]; then
	echo "plantuml.jar could not be found, downloading..."
	curl -L -o plantuml.jar https://github.com/plantuml/plantuml/releases/download/v1.2023.6/plantuml.jar
fi

echo "Rendering PlantUML figures..."
time java -jar plantuml.jar -tsvg "figures/**/*.puml"
