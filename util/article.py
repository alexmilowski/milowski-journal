import CommonMark,re,argparse

import sys,io,os

META_RE = re.compile(r'^[ ]{0,3}(?P<key>[A-Za-z0-9_-]+):\s*(?P<value>.*)')
META_MORE_RE = re.compile(r'^[ ]{4,}(?P<value>.*)')

def commonmarkToArticle(md,html,triples):


   glob = io.StringIO()
   metadata = {}
   hasMetadata = True
   line = md.readline()
   while hasMetadata:
      m = META_RE.match(line)
      if (not(m)):
         glob.write(line)
         glob.write('\n')
         hasMetadata = False
      else:
         key = m.group('key').lower().strip()
         value = m.group('value').strip()
         try:
            metadata[key].append(value)
         except KeyError:
            metadata[key] = [value]
         continued = True
         while continued:
            line = md.readline()
            more = META_MORE_RE.match(line)
            if (not(more)):
               continued = False
            else:
               metadata[key].append(more.group('value').strip())

   for line in md:
      glob.write(line)


   uri = "http://www.milowski.com/journal/entry/" + metadata['published'][0]

   print('<article xmlns="http://www.w3.org/1999/xhtml" vocab="http://schema.org/" typeof="BlogPosting" resource="{}">'.format(uri),file=html)
   
   print('<script type="application/json+ld">',file=html)
   print('{\n"@context" : "http://schema.org/",',file=html)
   print('"@id" : "{}",'.format(uri),file=html)
   print('"headline" : "{}",'.format(metadata['title'][0]),file=html)
   print('"datePublished" : "{}",'.format(metadata['published'][0]),file=html)
   print('"dateModified" : "{}",'.format(metadata['updated'][0]),file=html)
   if ("keywords" in metadata):
      print('"keywords" : [{}],'.format(','.join(['"' + m + '"' for m in metadata['keywords']])),file=html)
   html.write('"author" : [ ')
   for index,author in enumerate(metadata['author']):
      if (index>0):
         html.write(', ')
      html.write('{{ "@type" : "Person", "name" : "{}" }}'.format(author))
   html.write(']\n')
   print('}',file=html)
   print('</script>',file=html)

   print(CommonMark.commonmark(glob.getvalue()),file=html)

   print('</article>',file=html)

   print('@base <{}> .'.format(uri),file=triples)
   print('@prefix schema: <http://schema.org/> .',file=triples)
   print('<>',file=triples)
   print('   a schema:BlogPosting ;',file=triples)
   print('   schema:headline "{}" ;'.format(metadata['title'][0]),file=triples)
   print('   schema:datePublished "{}" ;'.format(metadata['published'][0]),file=triples)
   print('   schema:dateModified "{}" ;'.format(metadata['updated'][0]),file=triples)
   if ("keywords" in metadata):
      print('   schema:keywords {} ;'.format(','.join(['"' + m + '"' for m in metadata['keywords']])),file=triples)
   triples.write('   schema:author ')
   for index,author in enumerate(metadata['author']):
      if (index>0):
         triples.write(', ')
      triples.write('[ a schema:Person; schema:name "{}" ]'.format(author))
   triples.write(' .\n')
   

argparser = argparse.ArgumentParser(description='Article HTML and Turtle Generator')
argparser.add_argument('-f',action='store_true',help='Forces all the files to be regenerated.',dest='force')
argparser.add_argument('-o',help='The output directory',dest='outdir')
argparser.add_argument('dir',nargs=1,help='The directory to process.')
args = argparser.parse_args()
inDir = args.dir[0]
outDir = args.outdir if (args.outdir!=None) else inDir
dirs = [d for d in os.listdir(inDir) if not(d[0]=='.') and os.path.isdir(inDir + '/' + d)]

for dir in dirs:
   sourceDir = inDir + '/' + dir
   targetDir = outDir + '/' + dir
   if (not(os.path.exists(targetDir))):
      os.makedirs(targetDir)
   
   files = [f for f in os.listdir(sourceDir) if f.endswith('.md') and os.path.isfile(sourceDir + '/' + f)]
   for file in files:
      targetFile = sourceDir + '/' + file
      base = file.rsplit('.md',1)[0]
      htmlFile = targetDir + '/' + base + ".html"
      turtleFile = targetDir + '/' + base + ".ttl"
      
      updatedNeeded = args.force or not(os.path.exists(htmlFile)) or not(os.path.exists(turtleFile))
      if (not(updatedNeeded)):
         btime = os.path.getmtime(targetFile)
         updatedNeeded = btime > os.path.getmtime(htmlFile) or btime > os.path.getmtime(turtleFile)
      if (not(updatedNeeded)):
         continue
      
      print(file + " → " + htmlFile + ", " + turtleFile)
      md = open(targetFile,"r")
      html = open(htmlFile,"w")
      turtle = open(turtleFile,"w")
      commonmarkToArticle(md,html,turtle)
      md.close()
      html.close()
      turtle.close()

