import sys
import re
import argparse
import unicodedata
from pyquery import PyQuery as pq

from io import StringIO

import redis
from redisgraph import Graph


# https://spacy.io/usage/models
# python -m spacy download en_core_web_sm
import spacy
nlp = spacy.load("en_core_web_sm")

include_entities = set(['PERSON','NORP','FAC','ORG','GPE','LOC','PRODUCT','EVENT','WORK_OF_ART','LAW','LANGUAGE'])

en_punctuation_symbol = set(['P','S'])
ordinal = re.compile("[0-9]+")

def normalize_en(term):
   # remove possessive
   if term[-2:]=="'s":
      term = term[:-2]

   terms = []

   # split term with slashs
   for item in term.split('/'):
      words = list(filter(lambda s : len(s)>0,item.split(' ')))
      start = 0
      # check for trailing parenthesis
      # e.g. Keyhole Markup Language (
      if len(words)>0 and words[-1]=='(':
         words = words[:-1]
      # check for trailing parenthesis acronym
      # e.g. Open Geospatial Consortium (OGC
      if len(words)>0 and words[-1][0]=='(':
         terms.append(words[-1][1:])
         words = words[:-1]
      # check for strange outcomes with versus
      # versus km
      if len(words)>0 and words[0]=='versus':
         words = words[1:]

      # remove lowercase first word followed by uppercase
      # e.g. python Flask
      if len(words)>1 and unicodedata.category(words[0][0])[1]=='l' and unicodedata.category(words[1][0])[1]=='u':
         words = words[1:]


      remove = set()
      for index,word in enumerate(words):
         start_category = unicodedata.category(word[0])[0]
         if len(word)==1 and start_category in en_punctuation_symbol:
            remove.add(index)
            continue
         if start_category=='P':
            word = word[1:]
         if len(word)>0:
            end_category = unicodedata.category(word[-1])[0]
            if end_category=='P':
               word = word[:-1]
         words[index] = word

      for offset,index in enumerate(sorted(list(remove))):
         del words[index-offset]

      # add term for ordinal suffixed terms:
      # e.g. XML Prague 2014 -> XML Prague, XML Prague 2014
      if len(words)>1 and ordinal.fullmatch(words[-1]):
         terms.append(' '.join(words))
         terms.append(' '.join(words[:-1]))
      elif len(words)>0:
         normalized_term = ' '.join(words)
         if len(normalized_term)>0:
            terms.append(normalized_term)
   return terms

def extract_entities(content,include=include_entities):

   entities = {}
   for text in content if type(content)==list else [content]:
      doc = nlp(text)
      for entity in doc.ents:
         if entity.label_ not in include:
            continue

         if '\n' in entity.text:
            # total failure!
            continue

         words = list(filter(lambda x: x!='',re.split(r'[ :]+',entity.text)))

         # sometimes we fail to recognize sentence boundaries
         invalid = False
         for word in words:
            if word[-1]=='.':
               invalid = True
         if invalid:
            continue

         # trip initial stop words
         start = 0
         for word in words:
            if not nlp.vocab[word.lower()].is_stop:
               break
            start += 1

         # rejoin the term words
         text = ' '.join(words[start:])

         terms = normalize_en(text)

         for term in terms:
            info = entities.get(term)
            if info is None:
               info = { 'count': 0, 'types': set()}
               entities[term] = info
            info['count'] = info['count'] + 1
            info['types'].add(entity.label_)
   return entities

def process_url(url):
   doc = pq(url=url)
   doc('article[resource] pre').remove()
   doc('article[resource] code').remove()
   doc('article[resource] script').remove()
   text = doc('article[resource] p').text()
   return extract_entities(text)

def cypher_quote(value):
   return value.replace('\n',r'\n').replace("'",r"\'")

def generate_cypher(url,entities):
   query = StringIO()
   query.write("MERGE (a:BlogPosting {{ url : '{url}'}})\n".format(url=url))
   for index, item in enumerate(entities.items()):
      entity, info = item
      query.write("MERGE (e{index}:Entity {{ text : '{text}'}})".format(index=index,text=cypher_quote(entity)))
      query.write("""
MERGE (a)-[u{index}:uses]->(e{index})
SET u{index}.count = {count}
""".format(index=index,count=info['count']))
   return query.getvalue()

def main():
   argparser = argparse.ArgumentParser(description='Term Extractor')
   argparser.add_argument('--host',help='Redis host',default='0.0.0.0')
   argparser.add_argument('--port',help='Redis port',type=int,default=6379)
   argparser.add_argument('--password',help='Redis password')
   argparser.add_argument('--show-query',help='Show the cypher queries before they are run.',action='store_true',default=False)
   argparser.add_argument('--load',help='Load the data into RedisGraph',action='store_true',default=False)
   argparser.add_argument('--graph',help='The graph name',default='test')
   argparser.add_argument('urls',nargs='*',help='The entry urls to visit')
   args = argparser.parse_args()

   graph = None
   if args.load:
      print('Connecting to '+args.host+':'+str(args.port)+' for graph '+args.graph,file=sys.stderr)
      r = redis.Redis(host=args.host,port=args.port,password=args.password)

      graph = Graph(args.graph,r)

   for url in sys.stdin if len(args.urls)==0 else args.urls:
      url = url.strip()
      entities = process_url(url)
      if args.load:
         query = generate_cypher(url,entities)
         if args.show_query:
            print(query,file=sys.stderr)
         graph.query(query)
      else:
         print(url)
         for text, info in entities.items():
            print('{text} : {count}, {types}'.format(text=text,**info))

if __name__ == '__main__':
   main()
