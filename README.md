# A "Hello World" example ROM for the Gameboy

This source is to accompany [this blog post](https://huntergreynolds.github.io/posts/gameboy_drawing_a_sprite/).

## Requirements

* RGBDS (preferably the latest version, v0.8.0 as of this writing).
* Make

## Building

Run make to build the ROM. The default location for rgbds is in a directory named "rgbds-v0.8.0" one directory
up from the Makefile, so if you have it set up like that, you can just run `make`. If you have rgbds located somewhere
else, you can tell it by setting the RGBDS_ROOT variable.

Build the ROM like this:

```
make -e RGBDS_ROOT=/path/to/rgbds/ #note the trailing slash
```

or, if you have rgbds installed on your system:

```
make -e RGBDS_ROOT=
```
