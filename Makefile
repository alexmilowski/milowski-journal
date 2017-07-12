
OUTDIR=../milowski-journal-pages

all:
	mkdir -p $(OUTDIR)
	(source env/bin/activate; python util/article.py -o $(OUTDIR) entries)

update-triples:
	(source env/bin/activate; python util/load-triples.py -u $(USER) -p $(PASSWORD) $(OUTDIR)/$(DATE) $(SERVER) )

venv:
	mkdir -p env
	virtualenv env
	(source env/bin/activate; pip install -r util/requirements.txt)
