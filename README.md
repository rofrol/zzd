# zzd

from https://www.youtube.com/watch?v=pnnx1bkFXng

## Run

```sh
$ echo -ne "\x41\x42\x43\x44" | xxd -c 4 -g 8
00000000: 41424344  ABCD
$ zig build
# echo -ne "\x41\x42\x43\x44" > test.txt
$ ./zig-out/bin/zzd test.txt
00000000: 4142 4344
```
