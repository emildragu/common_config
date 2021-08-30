### Instal sox package on source

```aptitude install sox```

### Instal sox package on destination server

```aptitude install sox```

### Run the command
```rec -c 1 -t wav - | ssh root@192.168.1.7 play - ```

### Configure sound mixer
Got to sound mixer -> Recording, on the recording stream choose "Monitor of ..."
NOTE: might need to install pavucontrol, not sure
