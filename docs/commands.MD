### Perl one liner to transform preresentation 5G, 100K to their byte value

```
cat data.csv | perl -p -n -e '($v,$n) = m/(.+)\t(.+)/; $v =~ s/G$/ * 1024 * 1024 * 1024/; $v =~ s/K$/ * 1024/; $v =~ s/M$/ * 1024 * 1024/; $v = eval $v; $n =~ s#files\/##; $_ = "$v,$n\n"'
```
