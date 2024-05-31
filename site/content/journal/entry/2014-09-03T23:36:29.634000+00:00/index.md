---
title: "NASA OpenNEX Challenge and Processing HDF5 in Python"
date: "2014-09-03T23:36:29.634000Z"
url: "/journal/entry/2014-09-03T23:36:29.634000+00:00/"
params:
  author: Alex Miłowski
keywords:
  - OpenNEX
  - NASA
  - HDF
  - Python
---

# NASA OpenNEX Challenge and Processing HDF5 in Python

I've recently been playing around a lot with HDF5 data as second part of the [<cite>NASA Challenge: New Ways to Use, Visualize, and Analyze OpenNEX Climate and Earth Science Data</cite>](https://www.innocentive.com/ar/challenge/9933584) . [Henry Thompson](http://www.ltg.ed.ac.uk/~ht/)  and I won a small award in the first challenge for our proposal to apply the PAN Methodology to the OpenNEX data.  Specifically, we are looking at the [NASA Earth Exchange (NEX) ](https://nex.nasa.gov/nex/static/htdocs/site/extra/opennex/) data sets that are [hosted by Amazon AWS](https://aws.amazon.com/nasa/nex/) that provides climate projects both retrospectively (1950-2005) and prospectively (2006-2099).

The model is partitioned into files stored on Amazon S3 in 60 month segments (5 years). Each file contains a grid at 1/120° resolution of temperature values from the climate model.  The extent of the data set roughly covers the area between 24° to 49° latitude and -127° to -66° longitude (think: North America). In total, that is 60 copies of a matrix of 3105 columns by 7025 rows or 1,308,757,500 temperature values. Thus, each file is roughly 1.3GB in size.

In my experiments with the data, there is only data over land areas and I've calculated that roughly 45% of that data is  “fill values” . That is, values where the model has no prediction but the HDF5 format requires a value. As such, there are only about 700 million actual values to process and less than 700MB of actual non-fill data.

## Processing HD5 is Difficult

There are many obstacles to processing [HDF5](http://www.hdfgroup.org/HDF5/) . There are many different versions: is it netCDF, HDF5, HDF5-EOS, or HDF4? You can't necessarily tell by looking at the files, there isn't a media type that will tell you the different versions, and they are often incompatible with each other (you can't read HDF4 with HDF5 tools).

To make things worse, HDF5 is really a library. There is a specification but there is really only one implementation. Thus, the format is the C implementation.  Thus, you have to make sure you have the right library version installed that reads the version of HDF you are processing.

I originally discovered that I could dump HDF5 into XML using a tool called [`h5dump` ](http://www.hdfgroup.org/HDF5/doc/RM/Tools.html#Tools-Dump) but that proved to be pointless.  The choice of markup is verbose and you can't subset the data.

You can get slices of the data via the `h5dump` tool but the output is in a [ “Data Definition Language ” format. ](http://www.hdfgroup.org/HDF5/doc/ddl.html) As such, I would need to find a parser to process that data format as well.  At that point, I gave up on using `h5dump` .



## Python to the Rescue

I did discover that you can process HDF5 data in Python via a module called [h5py](http://www.h5py.org) . It uses [numpy](http://www.numpy.org) to give you vectorized access to the multi-dimensional data set.

Access to the OpenNEX data couldn't be easier:

```

>>> import numpy
>>> import h5py
>>> f = h5py.File("tasmax_quartile75_amon_rcp85_CONUS_202601-203012.nc","r")
>>> f["tasmax"]
<HDF5 dataset "tasmax": shape (60, 3105, 7025), type "<f4">
>>>

```
The file becomes a hashtable of data sets that are numpy multi-dimensional arrays underneath. You can access the numpy array directly:

```
>>> dset = f["tasmax"].value
>>> dset
array([[[  1.00000002e+20,   1.00000002e+20,   1.00000002e+20, ...,
           1.00000002e+20,   1.00000002e+20,   1.00000002e+20],
        [  1.00000002e+20,   1.00000002e+20,   1.00000002e+20, ...,
           1.00000002e+20,   1.00000002e+20,   1.00000002e+20],
        [  1.00000002e+20,   1.00000002e+20,   1.00000002e+20, ...,
           1.00000002e+20,   1.00000002e+20,   1.00000002e+20],
        ...,
...

```
Now it becomes a task of accessing the numpy array properly to do your processing. Given the size of my data, if you do this wrong, you'll spend a great deal of time iterating over data. Because I'm new to numpy, I spent a great deal of time iterating over data before I got something that worked reasonably well.

One of the tasks I need to do is to summarize the data and reduce the resolution. This is a process of collecting chunks of adjacent cells and averaging the value for the cell. I have the additional nuance that there are fill values of 1.00000002e+20 instead of a regular zero value and that makes the problem a bit harder.

The solution looks pretty neat:

```
d = numpy.empty((621,1421),numpy.float32);
months  = dset.shape[0]
rows    = dset.shape[1]
columns = dset.shape[2]
m = 0         # just month 1 (January, start of 60 month period)
chunkSize = 5 # summarizing 5 by 5 grid subsets

for i in range(0,d.shape[0]):
   for j in range(0,d.shape[1]):
      s = dset[m,i*chunkSize:i*chunkSize+chunkSize,j*chunkSize:j*chunkSize+chunkSize]
      reduction = reduce(lambda r,x: (r[0]+1,r[1]+x) if x<1.00000002e20 else r, s.flat,(0,0))
      d[i,j] = 0 if reduction[0] == 0 else reduction[1] / reduction[0]


```
Along the way I discovered tuples and that increased the speed by twice. I need to count the number of grid entries that have values to calculate the average. You can do that as two steps:

```
count = reduce(lambda r,x: r+1 if x<1.00000002e20 else r, s.flat,0)
sum = reduce(lambda r,x: r+x if x<1.00000002e20 else r, s.flat,0)
d[i,j] = 0 if count==0 else sum / count
```
or as one step:

```
reduction = reduce(lambda r,x: (r[0]+1,r[1]+x) if x<1.00000002e20 else r, s.flat,(0,0))
d[i,j] = 0 if reduction[0] == 0 else reduction[1] / reduction[0];
```
and the one step does half the work and so is faster.



## Is Python Slow?

It seemed to me that Python seems a bit slow.  In fact, when manipulating large arrays of data without numpy, it was painfully slow.  That makes me question why it is used so often for processing scientific data.

The interactive nature of Python allowed me to experiment with the HDF5 data in ways that I could not with the pre-canned tools like `h5dump` .  This let me experiment with the data and understand a bit more about the size of the task.  That experimentation enabled me to think about the problem at hand rather than brute-force a solution with code.

While this process would be enormously faster in C++, it would be harder to write.  I would have had to learn a low-level HDF5 C-API and handle many issues myself as a result.  That would have made the prototyping processing much more complex.  Yet, if I really need this to run really fast, I might attempt to do so.

In looking around for rationales about Python and processing speed, I found a stack exchange question titled [ “How slow is python really? (Or how fast is your language?)” ](http://codegolf.stackexchange.com/questions/26323/how-slow-is-python-really-or-how-fast-is-your-language) about the speed of Python in comparison to other languages.  There are a lot of interesting results, including how fast [Rust](http://www.rust-lang.org) is as a language. That makes me wonder whether other languages can better balance the experimentation enabled by dynamic-typed interpreted languages vs the speed afforded by strict-typed compiled languages.

Because this is a  “write once” operation, I am less worried about the speed of the process.  The processing time is reasonable enough to do what I need to do with OpenNEX data set.

