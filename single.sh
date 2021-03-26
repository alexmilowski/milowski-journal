#!/bin/bash
HOST=$1
DIR=$2
python -m loon load --host $HOST $REDIS_AUTH --extension md --show-query --weburi http://www.milowski.com/journal/entry/ --entryuri http://alexmilowski.github.io/milowski-journal/$DIR milowski-journal entries/$DIR
