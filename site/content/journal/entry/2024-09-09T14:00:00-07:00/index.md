---
title: "Circularity in LLM-curated knowledge graphs"
date: "2024-09-09T14:00:00-07:00"
url: "/journal/entry/2024-09-09T14:00:00-07:00/"
params:
  author: Alex Miłowski
keywords:
  - knowledge graph
  - graph
  - LLM
  - MedGraphRAG
  - NER
  - Named Entity Recognition
  - RE
  - Relation Extraction
aliases: /p/2024/09/09/
description: When knowledge graphs are generated with an LLM and the used with an LLM, there is an inherent circularity that we need to test.
---

I recently read ["Medical Graph RAG: Towards Safe Medical Large Language Model via Graph Retrieval-Augmented Generation"](https://arxiv.org/abs/2408.04187)
(MedGraphRAG) where the authors use a careful and thoughtful construction of a knowledge graph, curated from various textual sources, and extracted via a careful 
orchestration of an LLM. Queries against this knowledge graph are used to create a prompt for a pre-trained LLM where a clever use of 
tagging allows the answer to be traceable back to the sources. 

The paper details several innovations: 

 * using layers in the graph to represent different sources of data, 
 * allowing the layers to represent data with different update cadences and characteristics (e.g., patient data, medical research texts, or reference material)
 * careful use of tags to enable the traceability of the results back to the sources. 
 
I highly recommend you read through the paper as the results surpass SOTA and the techniques are mostly sound.

When digging into the "how", especially given the [associated github project](https://github.com/MedicineToken/Medical-Graph-RAG), I am
continually nagged by thoughts around using an LLM for Named Entity Recognition (NER) and Relation Extraction (RE) tasks. In particular:

 1. How often does such an LLM miss reporting entities or relations entirely (omissions)?
 2. What kinds of errors does such an LLM make and how often (misinformation)?
 3. If we use an LLM to generate the knowledge graph, and it has problems from (1) and (2), how well does an LLM answer questions given information from the knowledge graph (circularity)?

The success demonstrated by the authors of the MedGraphRAG technique as used for answering various 
medical diagnosis questions is one measure for (3). As with all inference, incorrect answers will happen. Tracing
down the "why" for the incorrect answer relies on understanding whether it is the input (the prompt generated from the knowledge graph) or the inference
drawn by the LLM. This means we must understand whether something is "wrong" or "missing" in the knowledge graph itself.

To answer this, I went on a tear for the last few weeks of reading whatever I could on NER and RE evaluation, datasets, and random 
blog posts to update myself on the latest research. There are some good NER datasets out there and some for RE as well. I am certain there
are many more resources out there that I haven't encountered, but I did find this
[list on Github](https://github.com/juand-r/entity-recognition-datasets) which led me to the conclusion that I really need to
focus on RE.

In going through how the MedGraphRAG knowledge graph is constructed, there are many pre-and-post processing steps that need to be applied to their datasets. 
Not only do they need to process various medical texts to extract entities and relations, but they also need to chunk or 
summarize these text in a way that is respective of topic boundaries. This helps the text fit into the limits of the prompt. The authors use "proposition transfer", which serves a 
critical step regarding topic boundaries, and that process also uses an LLM; bringing another circularity and questions about correctness.

All things considered, the paper demonstrates how a well constructed knowledge graph can be used to contextualize
queries for better answers that are traceable back to the sources supporting that answer. To put such a technique into
production, you need to be able to evaluate whether the entities and relations extracted are correct, that you aren't
missing important information, and you need to do this every time you update your knowledge graph. For that, you need 
some mechanism for evaluating an external LLM's capabilities and the quality
of its ability to perform a relation extraction (RE) task.

## Experiments with llama3

Maybe I shouldn't be surprised, but there are subtle nuances in the prompts that can generate
vastly different outcomes for relation extraction tasks. I ran some experiments running llama3.1 locally (8B parameters)
just to test various things. At one point during ad hoc testing, one of the responses said something along the
lines of "there is more, but I omitted them" and adding "be as comprehensive and complete as possible" to the prompt
fixed that problem.

Everyone who has put something into production knows that a very subtle change can have drastic and unintended
outcomes. When constructing a knowledge graph from iterative interactions with an external LLM, we need some way to
know that our new prompt that fixes one problem hasn't created a hundred problems elsewhere. That is usually the
point of unit and system testing (and I already hear the groans from the software engineers).

In the case of the MedGraphRAG implementation, they use the [CAMEL-AI](https://www.camel-ai.org) libraries
in Python to extract "entities" and "relations". That library instructs the LLM to produce a particular syntax
that reduces to typed entities and relation triples (i.e., subject, relation, object triples) which is then
parsed by the library. I am certainly curious as to when that fails to parse as escaping text is always
a place where errors proliferate.

Meanwhile, in my own experimentation, I simply asked llama to output YAML and was surprised that it did something
close to what might be parsable. A few more instructions were sufficient to pass the results into a YAML
parser:

```
A node should be formatted in YAML syntax with the following rules:

 * All nodes must be listed under a single 'nodes' property. 
 * All relationships must be listed under a single 'relations' property.
 * The 'nodes' and 'relations' properties may not repeat at the top level.
```

{{< note >}}
There are so many ways I can imagine this breaking. So, we will have to see what happens when I run a lot of text
through this kind of prompt.

I did spend some time experimenting on whether I could prompt llama to produce a property graph. That is, could it
separate properties of an entity from relations. Or could it identify a property of a relation? I wasn't particularly successful (yet) but that is a topic
for a different blog post.

{{< /note >}}


## A gem of a paper on relation extraction

In my wanders looking for more research in this area, I found this paper titled ["Revisiting Relation Extraction in the era of Large Language Models"](https://arxiv.org/abs/2305.05003) which addresses the question at the heart of knowledge graph construction with an LLM. While doing NER and NER resolution is one critical step, a knowledge
graph wouldn't be a graph if the LLM does not handle the RE task well. This is another paper that I highly recommend
you read.

The authors give a good outline of the elements of an evaluation of RE with an LLM. They compare the results of various models
and LLM techniques against human annotated datasets for relations. They also detail the need for human evaluators for determining "correctness"
given the various challenges already present in the thorny problems of RE.

In some contexts, the datasets were not well suited to be run through an LLM for RE tasks. The authors say at one point,

> "These results highlight a remaining limitation of in-context learning with large language models: for datasets with long 
> texts or a large number of targets, it is not possible to fit detailed instructions in the prompt."

This is a problem that the MedGraphRAG technique solved using proposition transfer but doing so muddies the RE task with yet
another LLM task.

## An idea

I've recently become involved in the [ML Commons](https://mlcommons.org) efforts where am particularly interested in
datasets. I think the challenge of collecting, curating, or contributing to datasets that support
LLM evaluation for knowledge graph construction would be particularly useful.

This effort at ML Commons could focus on a variety of challenges:

 * **Collecting datasets**: identification of existing datasets or corpus that can be use for NER and RE tasks in various domains
 * **Standardized metadata**: helping to standardize the metadata and structure of these datasets to allow more automated use for evaluation
 * **Annotation**: annotation of datasets with entities and relations to provide a baseline for comparison
 * **Conformance levels**: enable different levels of conformance to differentiate between the "basics" and more complex RE outcomes.
 * **Tools**: tooling for dataset curation and LLM evaluation

One area of innovation here would be the ability to label outcomes from an LLM not just in terms of omissions or misinformation but also
whether they can identify more subtle relations, inverse relations, etc. That would allow a consumer of these models
to understand what they should expect and what they may have to do afterwards to the knowledge graph as a secondary inference.

I will post more on this effort when and if it becomes an official work item. I hope it does.