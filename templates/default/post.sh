#! /bin/bash

<% if @platform == 'redhat' -%>
#run-parts keeps going when something fails! dumb...
umask 002
for x in /etc/burp/post.d/*
do
  if source $x
  then
    :
  else
    exit 1; #pre-backup script error - abort everything
  fi
 
done
<% else -%>
run-parts --report --exit-on-error --umask=002 -- /etc/burp/post.d
<% end -%>
