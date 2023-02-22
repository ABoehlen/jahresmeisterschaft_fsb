# Jahresmeisterschaft FS Bolligen: Auswertungsprogramm

## Purpose
This program was used to evaluate the annual championship (Jahresmeisterschaft) of the shooting club "Feldschützengesellschaft Bolligen". Parts of the program may also be useful for other similiar tasks.

## Background
The program was used until 2019 to evaluate the annual championship of the "Feldschützengesellschaft Bolligen" at the end of each shooting season. Based on the instructions \[1\] it performs all the needed calculations automatically as far as possible and outputs the results in a graphically appealing form.

The created data will be stored in an automatically generated table and kept during processes within a traditional two-dimensional array, as described by the authors of AWK in their famous 1988 book \[2\].

## System requirements

The programme requires Gawk 4.0 or higher. It has been used and tested on various Linux systems. It's also possible to run it on Windows, but it must be done within _git for Windows_ or _Cygwin_, where Gawk is also available. Since the application is optimised for the German language, the environment variable `LC_ALL=de_DE` must be assigned so that "umlaute" and special characters are processed correctly:

```
export LC_ALL=de_DE
```

It also requires `pcd2pdf` which can be found in this repository: https://github.com/ABoehlen/pdc2pdf

## Installation

Download the repository into your desired directory:

```
cd <directory>
git clone https://github.com/ABoehlen/jahresmeisterschaft_fsb
cd jahresmeisterschaft_fsb
```

The programme can then be started directly via `jahresmeisterschaft_main.awk`, as since Gawk 4.0 additional modules can be included. Please note that you may have to change the pathes to the pdc2pdf-modules depending on where you have stored this repository. It is also possible to derive a standalone version using the shell script `build_pdc` (check the storage location of the pdc2pdf-modules there too). The name is to be defined by the user, e.g.:

```
./build_jm jahresmeisterschaft.awk
```

This file no longer has any dependencies and can be stored in any location.

## Usage

There are no arguments to be given, so just type:

```
./jahresmeisterschaft_main.awk
```

Maybe you have to call the interpreter with the script file as argument, like this:

```
awk -f jahresmeisterschaft_main.awk
```

## Documentation

A detailed documentation in HTML is enclosed (in German). Look at `./dok/index.html`

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Literature
\[1\] Instructions for Feldschützen Bolligen's annual championship (in German) http://www.fsbolligen.ch/dok/reglement_jahresmeisterschaft.pdf

\[2\] Aho et al.: The Awk Programming Language, 1988, pp. 52 et seq.