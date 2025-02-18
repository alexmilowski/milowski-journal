---
title: "A survey of workflow orchestration systems"
date: "2025-02-07T09:00:00-07:00"
url: "/journal/entry/2025-02-07T09:00:00-07:00/"
params:
  author: Alex Miłowski
keywords:
  - workflows
  - workflow engines
  - pipelines
  - ML
  - MLOps
  - automation
aliases: /p/2024/02/07/
description: A survey of open-source/source-available workflow orchestration systems and technology
---

## Introduction

*Workflow orchestration* is a common problem in business automation that has an essential place
in the development and use of ML models. While systems for running workflows have been available for
many years, these systems have a variety of areas of focus. Earlier systems were often focused on
business process automation. Newer systems are developed specifically for the challenges
of orchestrating the tasks of data science and machine learning applications. Depending on their focus,
these systems have different communities of use, features, and deployment characteristics specific to their targeted domain.

This article provides a general overview of what constitutes a workflow orchestration system and follows
with a survey of trends in the available systems that covers:

 * origins and activity
 * how workflows are specified
 * deployment options

## What is workflow orchestration?

*A workflow is an organization of a set of tasks encapsulates a repeatable pattern of activity that 
typically provides services, transforms materials, or processes information* [^workflow]. The origin of
the term dates back to the 1920's and primarily in the context of manufacturing. In a modern parlance, we 
can think of a workflow as akin to a "*flow chart of things needed to be accomplished*" for a specific
purpose within an organization. In more recent years, "workflow orchestration" or "workflow management" systems have been
developed to track and execute workflows for specific domains.

In the recent past, companies used workflow orchestration for various aspects of business automation. This
has enabled companies to go from paper-based or human centric processes to one where the rules by
which actions are taken are dictated by workflows encoded in these systems. While ensuring consistency, it
also gives the organization a way to track metadata around tasks and ensure completion.

Within data platforms, data science, and more recent machine learning endeavours, workflow orchestration has
become a fundamental tool for scaling processes and ensuring quality outcomes. When the uses of the
systems are considered, earlier systems were focused on business processes whilst latter are focused on data engineering,
data science, and machine learning. Each of these systems were categorized into one of the following areas of focus:

 * **Business Processing** - oriented for generic business process workflows
 * **Science** - specifically focused on scientific data processing, HPC, and modeling or inference for science
 * **Data Science / ML** - processing focused on data science or machine learning
 * **Data Engineering** - processing specific to data manipulation, ETL, and other forms of data manangement
 * **Operations** - processes for managing computer systems, clusters, databases, etc.

Of the systems surveyed, the breakdown of categories is shown below: 

{{< figure src="categories.svg" title="Systems by Category"  width="60%">}}

While many of these systems can be used for different purposes, each has specializations for specific domains based on their community of use. An effort has been made to place a system into a single category based on the use cases, documentation, and marketing associated with the system.

## Origins of projects

{{< figure src="active-project-creation.svg" title="Project Creation by Category"  width="60%">}}

All the systems surveyed appear after 2005 and which just after the "dot-com era" and at the start of “big data”. In the above figure, the start of and end dates are shown for each category. Each column starts at the earliest project formation and ends at the last project formation. This gives a visual representation of activity and possible innovation in each category.

While business process automation has been and continues to be a focus of workflow system development, you can see some evolution of development from data engineering or operations to data science and machine learning. Meanwhile, the creation of new science-oriented systems appear to have stagnated. This may be due to the use of data engineering and machine learning methods in scientific contexts and so there is no need for special systems. 


## Activity 

{{< figure src="active.svg" title="Active Projects by Category"  width="60%">}}

As is often the case with open-source software, even if associated with a commercial endeavour, some of the projects appear to have been abandoned. In the above chart, there tends to be a 20-25% rate of abandonment for workflow systems with the notable exception of science-oriented systems. In addition, it should be noted that some of these active projects are just being maintained whilst others are being actively developed by a vibrant community.

> For science, while there may not be many new science-oriented workflow systems being created in recent years, most of those that exist are still actively being used.

## SaaS Offered

In addition, some of these projects have commercial SaaS offerings that also indicate viability. The largest section of which is for Data Science / ML at 35% of those surveyed. This has a likely correlation with the current investment in machine learning and AI technologies.

{{< figure src="saas.svg" title="Saas Available by Category"  width="60%">}}

## Workflow specification

{{< figure src="example-workflow.svg" title="Workflow Graph"  width="60%">}}

Most workflows are conceptualized as a “graph of tasks” where there is a single starting point that may branch out to any number of tasks. Each following task has a dependency of a preceding task that creates a link between tasks. This continues through to “leaf” tasks that are at the very end of the workflow. In some systems, these are all connected to an end of the workflow.

Many systems differ on how a workflow is described. Some have a DSL (Domain Specific Language) that is used to encode the workflow. Others have an API that is used by code to create the workflow via program execution. Others have a hybrid mechanism that uses code annotation features of a specific programming language to describe the workflow. The use of annotations simplifies the description of
a workflow via an API and serves as a middle ground between the API and a DSL.

In the following chart, the use of a DSL and the encoding format is shown. If the DSL and format is compared to the project creation, you can see that a DSL is more prominent in Business Processing and Science workflow systems that generally have an earlier origin (~ 2005). Whereas, Data Engineer and Data Science / ML tend to use code or annotations on code rather than a DSL to describe the workflow.

Further, there is a strong trend to use YAML as a syntax for describing the graph of tasks in the workflow DSL. This is almost exclusively true for those surveyed in the Data Science / ML category. It should be noted that there is some use of specialized syntaxes (Custom), which is occurs often in the Science category, where the DSL uses a specialized syntax that must be learned by the user.

{{< figure src="dsl.svg" title="DSL Format by Category"  width="60%">}}

Meanwhile, using annotations in code to describe workflows is a growing trend. In those surveyed, it appears that as systems evolved from focusing on data engineering to data science and ML, the use of code annotations has increased. This is also likely due in part to the dominance of Python as a programming language of choice for machine learning applications and the fondness of python users for annotation schemes.

{{< figure src="annotations.svg" title="Annotation API by Category"  width="60%">}}

When it comes to describing tasks, systems that use annotations have a clear advantage in terms of simplicity. In those systems, a task is typically a function with an annotation. Subsequently, the system orchestrates execution of that function within the deployment environment.

In general, tasks are implemented as code in some programming language. Some workflow systems are agnostic to the choice of programming language as they use containers for invocation, a service request (e.g., an HTTP request to a service), or some other orthogonal invocation. Many systems are specifically designed to be opinionated about the choice of language, either by the API provided or due to the way the workflow is described through code annotations.

The following chart shows the distribution of task languages in the surveyed systems. The dominance of Python is clear from this chart due to prevalence of use in data engineering, data science, and machine learning. Many of the uses of Java are from systems that are focused on business processing workflows.

{{< figure src="task-language.svg" title="Task Language"  width="60%">}}

## Deployment 

As with any software, these workflow systems must be deployed on infrastructure. Unsurprisingly, there is a strong trend towards containers and container orchestration. Many still leave the deployment considerations up to the user to decide and craft.

{{< figure src="deployment.svg" title="Deployments"  width="60%">}}

When only the Data Engineering and Data Science / ML categories are considered, you can see the increasing trend of the use of Kubernetes as the preferred deployment.

{{< figure src="deployment-dsml.svg" title="Deployments - Data Science/ML Only"  width="60%">}}

## Conclusions

Overall, when you look at the activity and project creation over all the categories, two things seem to be clear:

1. There is a healthy ecosystem of workflow systems for variety of domains of use.
2. There is no clearly dominant system.

While particular communities or companies behind certain systems might argue otherwise, there is clearly a lot of
choice and activity in this space. There are certainly outlier systems that have smaller usage, support, and
active development. In a particular category, there are probably certain systems you might have on a short list of "winners".

In fact, what is missing here is any community sentiment around various systems. There are systems that are in
use by a lot of companies (e.g., Airflow) simply because they have been around for a while. Their "de facto" use
doesn't mean that all the user's needs are being met nor are they satisfied with their experience using the system. These
users may simply not have a choice or sufficient reason to change; working well enough means there is enough momentum
to make change costly.

Rather, the point here is there is a lot of choice given the activity in workflow systems. That variety of choice
means there is *lot of opportunity for innovation by users or developers as well as for companies who have a workflow system product*.
And that is a very good thing.

## Data

All the systems considered were either drawn from [curated
lists of systems](https://github.com/meirwah/awesome-workflow-engines) or by github tags
such as [workflow-engine](https://github.com/topics/workflow-engine) or [workflow](https://github.com/topics/workflow).
Whilst not a complete list, it does consist of 80 workflow systems or engines.

Each system's documentation and GitHub project was examined to determine various properties. Some of these values
may be subjective. An effort was made to have consistent judgements for categories of use. Meanwhile, a valiant
attempt was made to understand the features of each system by finding evidence in their documentation or examples for various
features. As such, some things may have been missed if they were hard to find. Although, that is not unlike a user's
experience with the product: if the feature is hard to determine, they may assume it doesn't exist.

The data is available here: {{< download src="data.csv" filename="workflow-orchestration-data.csv">}}

## References

[^workflow]: Workflow, Wikipedia, see also [https://en.wikipedia.org/wiki/Workflow](https://en.wikipedia.org/wiki/Workflow)
