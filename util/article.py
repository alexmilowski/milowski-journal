import commonmark,re,argparse

import sys
import io
import os
import shutil
import yaml
import time
import datetime

from html import escape

TEXT_MARKDOWN = 'text/markdown'
TEXT_HTML = 'text/html'
TEXT_XML = 'text/xml'
def normalize(s):
   return s.replace('\n',' ')

def literal(s):
   return s.replace('"','\\"')

def isoformat(s):
   return s if type(s)==str else s.isoformat()

def now():
   return datetime.datetime.now().astimezone()

class ArticleConverter:
   def __init__(self,weburi,entryuri):
      self.weburi = weburi
      self.entryuri = [ entryuri ]

   def enter(self,suffix):
      self.entryuri.append(self.entryuri[-1] + suffix)

   def leave(self):
      return self.entryuri.pop()

   def toArticle(self,base,md,html,triples):
      metadata = yaml.load(md,Loader=yaml.Loader)

      summary = ''
      hasTitle = False
      for part in metadata.get('content','').split('\n'):
         if part[0:2]=='# ':
            hasTitle = True
            continue
         if len(part)>0:
            summary = part
            break
      if 'description' not in metadata:
         metadata['description'] = normalize(summary)

      if 'updated' not in metadata:
         metadata['updated'] = now()

      if 'published' not in metadata:
         metadata['published'] = metadata['updated']

      self.toHTML(base,metadata.get('content',''),metadata,html,generateTitle=not hasTitle)
      self.toTurtle(base,metadata,triples)

   def toHTML(self,base,content,metadata,html,generateTitle=False):

      uri = self.weburi + isoformat(metadata.get('published',''))

      print('<article xmlns="http://www.w3.org/1999/xhtml" vocab="http://schema.org/" typeof="BlogPosting" resource="{}">'.format(uri),file=html)

      print('<script type="application/json+ld">',file=html)
      print('{\n"@context" : "http://schema.org/",',file=html)
      print('"@id" : "{}",'.format(uri),file=html)
      print('"genre" : "blog",',file=html)
      print('"name" : "{}",'.format(base),file=html)
      print('"headline" : "{}",'.format(metadata.get('title','')),file=html)
      print('"description" : "{}",'.format(literal(metadata.get('description',''))),file=html)
      print('"datePublished" : "{}",'.format(isoformat(metadata.get('published',''))),file=html)
      print('"dateModified" : "{}",'.format(isoformat(metadata.get('updated',''))),file=html)
      if ("keywords" in metadata):
         print('"keywords" : [{}],'.format(','.join(['"' + m + '"' for m in metadata['keywords']])),file=html)
      if 'author' in metadata:
         html.write('"author" : [ ')
         authors = metadata.get('author',[])
         for index,author in enumerate(authors if type(authors)==list else [authors]):
            if (index>0):
               html.write(', ')
            html.write('{{ "@type" : "Person", "name" : "{}" }}'.format(author))
         html.write(']\n')
      print('}',file=html)
      print('</script>',file=html)

      if generateTitle:
         print("<h1>{}</h1>".format(escape(metadata['title'],quote=False)),file=html)

      format = metadata.get('format',TEXT_MARKDOWN)
      if format==TEXT_MARKDOWN:
         print(commonmark.commonmark(content),file=html)
      elif format==TEXT_HTML:
         html.write(content)
      elif format==TEXT_XML:
         self.transformXML(content,html)
      else:
         raise ValueError('Unknown format: {}'.format(format))

      print('</article>',file=html)

   def transformXML(self,content,output):
      pass

   def toTurtle(self,base,metadata,triples):

      uri = self.weburi + isoformat(metadata['published'])
      basedOn = self.entryuri[-1] + base + '.html'
      #name = base + '.html'

      print('@base <{}> .'.format(uri),file=triples)
      print('@prefix schema: <http://schema.org/> .',file=triples)
      print('<>',file=triples)
      print('   a schema:BlogPosting ;',file=triples)
      print('   schema:genre "blog";',file=triples)
      print('   schema:name "{}";'.format(base),file=triples)
      print('   schema:headline "{}" ;'.format(metadata['title']),file=triples)
      print('   schema:description "{}" ;'.format(literal(metadata['description'])),file=triples)
      print('   schema:datePublished "{}" ;'.format(isoformat(metadata['published'])),file=triples)
      print('   schema:dateModified "{}" ;'.format(isoformat(metadata['updated'])),file=triples)
      print('   schema:isBasedOnUrl "{}";'.format(basedOn),file=triples)
      #print('   schema:hasPart [ a schema:MediaObject; schema:contentUrl "{0}"; schema:fileFormat "text/html"; schema:name "{1}" ] ;'.format(basedOn,name),file=triples)
      if ("keywords" in metadata):
         print('   schema:keywords {} ;'.format(','.join(['"' + m + '"' for m in metadata['keywords']])),file=triples)
      if 'author' in metadata:
         authors = metadata.get('author',[])
         triples.write('   schema:author ')
         for index,author in enumerate(authors if type(authors)==list else [authors]):
            if (index>0):
               triples.write(', ')
            triples.write('[ a schema:Person; schema:name "{}" ]'.format(author))
      triples.write(' .\n')


argparser = argparse.ArgumentParser(description='Article HTML and Turtle Generator')
argparser.add_argument('-f',action='store_true',help='Forces all the files to be regenerated.',dest='force')
argparser.add_argument('--extension',nargs='?',help='The source file extension',default='md')
argparser.add_argument('-o',nargs='?',help='The output directory',dest='outdir')
argparser.add_argument('-w',nargs='?',help='The web uri',dest='weburi',default='http://www.milowski.com/journal/entry/')
argparser.add_argument('-e',nargs='?',help='The entry uri directory',dest='entryuri',default='http://alexmilowski.github.io/milowski-journal/')
argparser.add_argument('dir',nargs=1,help='The directory to process.')
args = argparser.parse_args()
inDir = args.dir[0]
outDir = args.outdir if (args.outdir!=None) else inDir
dirs = [d for d in os.listdir(inDir) if not(d[0]=='.') and os.path.isdir(inDir + '/' + d)]

converter = ArticleConverter(args.weburi,args.entryuri)

extension = '.' + args.extension if args.extension[0]!='.' else args.extension
extension_count = extension.count('.')

for dir in dirs:

   sourceDir = inDir + '/' + dir
   targetDir = outDir + '/' + dir

   if (not(os.path.exists(targetDir))):
      os.makedirs(targetDir)

   converter.enter(dir+'/')

   files = [f for f in os.listdir(sourceDir) if f.endswith(extension) and os.path.isfile(sourceDir + '/' + f)]

   for file in files:

      targetFile = sourceDir + '/' + file
      base = file.rsplit('.',extension_count)[0]
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

      converter.toArticle(base,md,html,turtle)

      md.close()
      html.close()
      turtle.close()

   work = [f for f in os.listdir(sourceDir) if (not f.endswith('.md'))]
   for file in work:
      sourceFile = sourceDir + '/' + file
      targetFile = targetDir + '/' + file
      if os.path.isfile(sourceFile):
         copyNeeded = args.force or not(os.path.exists(targetFile)) or os.path.getmtime(sourceFile) > os.path.getmtime(targetFile)

         if copyNeeded:
            print(file + " → " + targetFile)
            shutil.copyfile(sourceFile,targetFile)
      elif os.path.isdir(sourceFile):
         if os.path.exists(targetFile):
            print('sync tree ' + sourceFile)
            work += [sourceFile + '/' + f for f in os.listdir(sourceFile)]
         else:
            print("copy tree " + sourceFile + " → " + targetFile)
            shutil.copytree(sourceFile,targetFile)

   converter.leave()
