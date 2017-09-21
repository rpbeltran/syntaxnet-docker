
Modified Docker container from [Brian Low's Syntaxnet Dockerfile](https://github.com/brianlow/syntaxnet-docker).

Compared to Brian Low's, this repository uses a more up to date version of Ubuntu base, and provides a modified demo script which outputs information in CONLL format instead of an ASCII Tree. This is makes the output substantially easier to parse, and removes another source of latency.

Syntaxnet
=========

[Google's SyntaxNet](https://github.com/tensorflow/models/tree/master/syntaxnet) Parser and POS tagger.


Setup 
-----

```shell
curl -O https://raw.githubusercontent.com/rpbeltran/syntaxnet-docker/master/Dockerfile
docker build .
```

Usage
-----

```shell
echo "Name this boat" | docker run --rm -i brianlow/syntaxnet
...
Input: Name this boat
Parse:
Name VB ROOT
 +-- boat NN dobj
     +-- this DT det
```


Updating
--------

```
docker login
docker build -t brianlow/syntaxnet --no-cache . && docker push brianlow/syntaxnet

```

