# imicrobe-mash-node2vec
Scripts to learn and cluster a vector-space embedding on all-vs-all iMicrobe MASH distance matrix.

## History
The first version of these scripts used the [node2vec](https://arxiv.org/abs/1607.00653)
implementation in [SNAP](http://snap.stanford.edu/index.html). However that
implementation does not work. The reference implementation works and is efficient
thanks to the excellent word2vec implementation in [gensim](https://radimrehurek.com/gensim/).

## Requirements

+ ~[SNAP](http://snap.stanford.edu/index.html)~
+ Python 3.6+
+ [Hurwitz Lab node2vec fork](https://github.com/hurwitzlab/node2vec)

## Install

Create and activate a Python 3.6+ virtual environment.

```
$ python3.6 -m venv ~/n2v
$ source activate ~/n2v/bin/activate
(n2v) $ pip install -r requirements.txt
```

or

```
$ conda create -n n2v gensim networkx
$ source activate n2v
(n2v) $
```

Install Hurwitz Lab fork of node2vec.

```
(n2v) $ git clone https://github.com/hurwitzlab/node2vec.git
(n2v) $ cd node2vec
(n2v) $ pip install -e .
```

### Install on Stampede2
The node2vec algorithm is computationally expensive. To install an efficient
implementation on Stampede2 it is important to use, as much as possible, the
native optimized BLAS library.
