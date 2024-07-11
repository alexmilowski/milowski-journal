all: gql.xml gql.html

gql.xml: gql.md
	pandoc --standalone  -f markdown+smart+yaml_metadata_block --filter pandoc-crossref --filter=mermaid-filter --citeproc --section-divs=true --csl default.csl --template template.balisage -t docbook5  -o gql.xml gql.md

gql.html: gql.md
	pandoc --standalone  -f markdown+smart+yaml_metadata_block --filter pandoc-crossref --filter=mermaid-filter --citeproc --section-divs=true --csl default.csl -t html -o gql.html gql.md