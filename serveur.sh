#!/bin/bash

wred=">/dev/null"
sred=""
kred=">/dev/null"
rred=">/dev/null"
if [[ $1 =~ .*w.* ]] ; then wred="" && echo -n "w"; fi
if [[ $1 =~ .*r.* ]] ; then rred="" && echo -n "r"; fi
if [[ $1 =~ .*k.* ]] ; then kred="" && echo -n "k"; fi
if [[ $1 =~ .*s.* ]] ; then sred=">/dev/null" && echo -n "s"; fi

eval ./bin/webpack-dev-server $wred &
pid[0]=$!
eval redis-server $rred &
pid[1]=$!
eval bundle exec sidekiq -q mailers -q default -c 5 $kred &
pid[2]=$!
eval rails s $sred

for sig in pid 
do
  if ps -p $sig 2> /dev/null
  then
    kill $sig
  fi
done && echo -e "\033[32mServeur killed perfectly\033[0m"
if [ -f dump.rdb ]; then rm dump.rdb ; fi
