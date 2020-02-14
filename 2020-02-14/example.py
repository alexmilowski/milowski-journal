import spacy
nlp = spacy.load("en_core_web_sm")

def print_entities(text):
   doc = nlp(text)
   for entity in doc.ents:
      print(entity.text + ' : '+entity.label_)

print('Example:')
print_entities("""
As an experiment, I wanted to extract various significant "keywords" from my
blog posts and compare them to the curated terms I have tagged over the years.
This kind of NLP task where various terms are identified by their part of speech
and role within the sentences. Over the years, this process have evolved to
a specific task of Named Entity Recognition and the python spaCy
library has a very useful API and particularly great pre-trained language model
(e.g., en_core_web_sm for English language text).

The spaCy library is particular easy to use. You must first download the model
into your python environment. Once you have done so, you just tell spaCy to load
the model when you bootstrap the main "nlp" function. Afterwards, you apply this
function to the text you would like to analyze.
""")

print('https://spacy.io:')
print_entities(
"""
Get things done

spaCy is designed to help you do real work — to build real products, or gather real insights. The library respects your time, and tries to avoid wasting it. It's easy to install, and its API is simple and productive. We like to think of spaCy as the Ruby on Rails of Natural Language Processing.

GET STARTED
Blazing fast

spaCy excels at large-scale information extraction tasks. It's written from the ground up in carefully memory-managed Cython. Independent research in 2015 found spaCy to be the fastest in the world. If your application needs to process entire web dumps, spaCy is the library you want to be using.

FACTS & FIGURES
Deep learning

spaCy is the best way to prepare text for deep learning. It interoperates seamlessly with TensorFlow, PyTorch, scikit-learn, Gensim and the rest of Python's awesome AI ecosystem. With spaCy, you can easily construct linguistically sophisticated statistical models for a variety of NLP problems.

READ MORE
"""
)
