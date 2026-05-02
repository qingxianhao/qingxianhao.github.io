#!/bin/bash
gettime(){
    TZ=UTC-8 date +"%H:%M:%S %z"
}

gettitle(){
    tdef="Untitled$RANDOM by `getuser`"
    (>&2 echo -e "    \033[1mUsage:\033[0m $0 <title> <date (YYYY-MM-DD)>")
    echo ${title:-$tdef}
}

getfname(){
    echo $@|sed -e 's@\s\+@_@g'
}

getuser(){
    git config user.name
    [ $? -ne 0 ] && echo $USER
}

initpost(){
    ptitle=`gettitle`
    fname=`getfname $ptitle`
    pfile=$pdir/$pdate-$fname.$ext
    echo $pfile
    cat >>$pfile<<CDLUG
---
layout: post
title: $ptitle
date:   $pdate $(gettime)
author: `getuser`
---

## $ptitle

CDLUG
}

#main
title=$1
pdate=$2

if [ -z "$title" ] || [ -z "$pdate" ]; then
    echo "Error: Missing required parameters"
    (>&2 echo -e "    \033[1mUsage:\033[0m $0 <title> <date (YYYY-MM-DD)>")
    exit 1
fi

pdir=_posts
ext=md
initpost
if [ -z $EDITOR ]; # $EDITOR not configured
then
    xdg-open $pfile
else
    $EDITOR "$pfile"
fi
git status -s $pdir
