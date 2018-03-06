#!/bin/bash

PREFIX=$( pwd )
DTD=$( find . -name "*.dtd" | head -n 1 | sed -e "s/\.[^.]*$//" | cut -f2 -d"/" )
DTDPATH="$PREFIX/$DTD.dtd"

echo "Updating DTD path in tsung.xml"
## 1- Generate copy of tsung.xml.ini and replace @@DTD_FILE@@
cp xml/tsung.xml.ini xml/tsung.xml
sed -i -e "s%@@DTDPATH@@%$DTDPATH%g" xml/tsung.xml

## 2- Compile erl libs in /lib
cd $PREFIX/lib
erlc *.erl
cd -

## 3- Get latest tsung library in erl lib dir
DEFAULT="/usr/local/lib/erlang"
echo "erl lib path? (default is /usr/local/lib/erlang/)"
read ERLDIR
if [ "$ERLDIR" == "" ]
then
  TSUNGLIB=$( find $DEFAULT -name "tsung-*" | sort -r | head -n1 | cut -f2 -d"/" )
  ERLDIR="$DEFAULT/$TSUNGLIB"
elif [ "$ERLDIR" == "brew" ]
then
  ERLDIR="/usr/local/Cellar/tsung/1.7.0/lib/tsung/tsung-1.7.0/"
fi

sudo cp $PREFIX/lib/*.beam $ERLDIR/ebin
