
OUTDIR=build

all:
	mkdir -p $(OUTDIR)
	(source env/bin/activate; python util/article.py -o $(OUTDIR) entries)

venv:
	mkdir -p env
	virtualenv env
	(source env/bin/activate; pip install -r util/requirements.txt)
