---
title: "GQL: Schemas and Types"
date: "2024-06-26T12:00:00-07:00"
url: "/journal/entry/2024-06-26T12:00:00-07:00/"
params:
  author: Alex Miłowski
keywords:
  - GQL
  - graph
  - Property Graph
  - ISO
  - schema
  - types
aliases: /p/2024/06/26/
description: Describing graphs with GQL schemas
---

In GQL, a graph is set of zero or more nodes and edges where:

A {{< term >}}Node{{< /term >}} has:
: * a {{< term >}}label set{{< /term >}} with zero or more unique label names,
  * a {{< term >}}property set{{< /term >}} with zero or more name-value pairs with unique names.

An {{< term >}}Edge{{< /term >}} has:
: * a {{< term >}}label set{{< /term >}} with zero or more unique label names,
  * a {{< term >}}property set{{< /term >}} with zero or more name-value pairs with unique names,
  * two endpoint nodes in the same graph,
  * an indication of whether the edge is {{< term >}}directed{{< /term >}} or {{< term >}}undirected{{< /term >}},
  * when a directed edge, one endpoint node is the source and the other node is the destination.

While data can be unstructured in a graph such that nodes and edges are created in an ad hoc manner, 
graphs are often carefully crafted and structured to represent the relationships and properties of the
subject. As such, having
a schema that matches the rules used to structure the graph is useful for validation, queries, and
optimizations by a database engine.

## What is a schema for a graph?

A graph schema should attempt to answer basic questions like:

 * What kinds of nodes are allowed in the graph?
 * What kinds of relationships (i.e., edges) are allowed between nodes?
 * What are the named properties of nodes and edges?
 * What are the allowed values of properties?
 * What properties are optional?
  
Additionally, it would be good to define more ontology-oriented 
questions for validity like:

 * the cardinality of edges and nodes,
 * inverse relations (e.g., a parent relation to node has a child relation in reverse)
 * cross-node or cross-edge property constraints

Such additional criteria are often described as a constraint language that is separable
from a schema language. That is, they can often be viewed as an additional
layer and not the domain of the schema language.

## Schemas in GQL

In GQL, the {{< term >}}graph type{{< /term >}} (see §4.13.2 "Graph types and graph element types") is
the main construct for defining a schema. A graph type describes the nodes and edges
allowed in a graph. It is created with a
{{< term >}}create graph type statement{{< /term >}} (see §12.6):

{{< listing id="example-create-graph-type" title="graph type creation">}}
```ISOGQL
CREATE GRAPH TYPE MyGraph AS {
  // definitions go here
}
```
{{< /listing >}}

Once created, the graph type can be used to type specific instances of graphs
in your site (i.e., a portion of your graph database). In this example, the
specific
syntax uses a {{< term >}}nested graph type specification{{< /term >}} (see §18.1)
that contains a list of {{< term >}}element type specifications{{< /term >}} are
specified in a comma-separated list.

Each element type specification is either:

  * a {{< term >}}node type specification{{< /term >}} (see §18.2)
  * an {{< term >}}edge type specification{{< /term >}} (see §18.3)
  
For each of these, there are two ways to describe the type:

 * a "pattern" that is similar in syntax to node or edge patterns in queries,
 * a "phrase" that is more explicit and verbose.

The simplest and most compact form of a {{< term >}}node type specification{{< /term >}} 
is as a pattern:

{{< listing id="example-node-type" title="node type pattern basics">}}
```ISOGQL
(:label {
  prop1 :: type1,
  prop2 :: type2,
  // etc.
})
```
{{< /listing >}}

The label set defines the "keys" by which the type can be referenced and also
used to query for matching nodes. A node type can also define additional non-keyed
labels and the union of these and the keyed labels are the total set of labels for the type. For example, we could
model animal nodes as the following:

{{< listing id="example-animals-as-nodes" title="animals as nodes">}}
```ISOGQL
(:cat => :mammal:animal),
(:dog => :mammal:animal)
```
{{< /listing >}}

The node types for `cat` and `dog` are keyed with unique labels
but also have the labels `mammal` and `animal` on the same nodes.

Similarly, we can specify edges with patterns:

{{< listing id="example-edge-patterns" title="edge patterns">}}
```ISOGQL
(:Person)~[:sibling]~(:Person),
(:Person)-[:children]->(:Person)
```
{{< /listing >}}

The first edge pattern is an undirected edge that is keyed with `sibling` and has two endpoints whose type is keyed with `Person`. 
The second edge pattern is a directed edge that is keyed with `children` 
and has a source and destination type that is keyed with `Person`.

## A worked example

If we imagine we're trying to structure a graph to represent data retrieved from
resources using the [Person](https://schema.org/Person) type from [schema.org](https://schema.org),
we can see how these declarations fit together as well as the "rough edges" of
graph typing.

Here is a complete example where the properties and relations have been 
limited to make the schema smaller:

{{< listing id="example-schema-patterns" title="schema via patterns">}}
```ISOGQL
CREATE GRAPH TYPE People AS {
   (:Thing {
      name :: STRING NOT NULL,
      url :: STRING
   }),
   (:Person => :Thing {
      name :: STRING NOT NULL,
      url :: STRING,
      givenName :: STRING,
      familyName :: STRING NOT NULL,
      birthDate :: DATE NOT NULL,
      deathDate :: DATE
   }),
   (:Person)-[:knows]->(:Person),
   (:Person)-[:children]->(:Person),
   (:Person)-[:parent]->(:Person),
   (:Person)~[:sibling]~(:Person),
   (:Person)~[:spouse { started :: DATE NOT NULL, ended :: DATE }]~(:Person)
}
```
{{< /listing >}}

This same schema can be described via phrase declarations:

{{< listing id="example-schema-phrases" title="schema via phrases">}}
```ISOGQL
CREATE GRAPH TYPE PeopleViaPhrase AS {
   NODE :Thing {
      name :: STRING NOT NULL,
      url :: STRING
   },
   NODE :Person => :Thing {
      name :: STRING NOT NULL,
      url :: STRING,
      givenName :: STRING,
      familyName :: STRING NOT NULL,
      birthDate :: DATE NOT NULL,
      deathDate :: DATE
   } AS Person,
   DIRECTED EDGE knows {} CONNECTING (Person -> Person),
   DIRECTED EDGE children {} CONNECTING (Person -> Person),
   DIRECTED EDGE parent {} CONNECTING (Person -> Person),
   UNDIRECTED EDGE sibling {} CONNECTING (Person ~ Person),
   UNDIRECTED EDGE spouse 
      { started :: DATE NOT NULL, ended :: DATE } 
      CONNECTING (Person ~ Person)
}
```
{{< /listing >}}

{{< note >}}
It is not clear to me why there are two ways to do the same thing. In phrase version, you'll
see that `AS Person` added to the declaration of the `Person` node type. This seems necessary
as the {{< term >}}endpoint pair phrase{{< /term >}} requires a {{< term >}}local alias{{< /term >}}. Otherwise,
the outcome is effectively the same. The question remains as to what you can do with one form that you
can't do with the other?
{{< /note >}}

## Curious things

I've noticed a few things:

 1. **You'd like to see type extension:** If `Person` extends `Thing`, then it inherits the properties of `Thing` instead of re-declaring the property set. If you think about that a bit, 
    **there be dragons.** Having type extension in a schema language really requires having constructs and semantics for both extension and restriction. There is
    a whole section (§4.13.2.7 "Structural consistency of element types") that explains what could be interpreted as a subtype. Yet, that structural consistency doesn't appear to apply to schemas.
 2. **The way local aliases are specified and used seems a bit inconsistent.** You only have a local alias for a type when you declare it, yet there are specific situations 
    where you need a local alias (e.g., the {{< term >}}endpoint pair phrase{{< /term >}}). It is also appears useful when you have a key label set with more than one label
    in that you can use the local alias to avoid being required to repeat the multiple labels for each edge type.
 3. **Edges to anything:** It isn't clear how you can describe an edge which has an endpoint (e.g., a destination) that is any node.
 4. **Node type unions:** It isn't clear to me how you specify an edge whose destination is a union of node types. While you may be able to
    work around this with a common label, the set of destination node types may be disjoint.
 5. **Lack of graph constraints:** There are graph type level constraints such as limiting the cardinality of edges that would be very useful (e.g., node type X can only have one edge of type Y).
 6. **Optional keywords - why?**: `CREATE PROPERTY GRAPH` and `CREATE GRAPH`, `NODE TYPE` and `NODE`, and `EDGE TYPE` and `EDGE` are all substitutable syntax without any change in semantics. I feel like we should have dropped `PROPERTY` and `TYPE` from the grammar.
 7. **Synonyms - why?**: `NODE` vs `VERTEX` and `EDGE` vs `RELATIONSHIP` - as synonyms, they mean the same thing, and so why didn't they just pick one?

## Concluding remarks

As with many schema languages, there are things left yet to do.  As a first version, a {{< term >}}graph type{{< /term >}} provides 
some basic mechanisms for describing a graph as a set of "leaf types". The modeling language you want to use to describe your graph
may simply be out of scope for GQL. Meanwhile, you can simply use another tool (pick your favorite UML or ERM tool) to generate 
GQL graph types useful in your database.

Presently, the type system in GQL provides a minimum bar for validation. More importantly, these types give
the database system a contract for the kinds of nodes, edges, and properties that are to be created, updated, and queried. This
affords the database engine the ability to optimize how information is stored, indexed, and accessed.

That should probably be the primary takeaway here: 

> The graph schema is for your database and not for you. It doesn't describe everything you need to 
> understand about your graph's structure.
