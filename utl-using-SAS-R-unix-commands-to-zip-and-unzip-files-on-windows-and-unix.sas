Using SAS R unix commands to zip and unzip files on windows and unix

   Four Solutions

        1. R functions zip and unzip
        2. Install gzip on power windows workstation
        3 Vanilla SAS zip unzip (archive option)
        4. Unix operating system commands gzip and gunzip

I don't think ypu can use a pipe command to unzip and stream a sas dataset;
You may be able tp stream a sas daatset in tape or xport format.

If you have IML you can call R or use my macro  '%utl_submit_r64'.
I suspect python can also this.

github
https://tinyurl.com/yycmtpks
https://github.com/rogerjdeangelis/utl-using-SAS-R-unix-commands-to-zip-and-unzip-files-on-windows-and-unix

related github
https://github.com/rogerjdeangelis/utl-gzip-windows-and-unix

related
SAS Forum gzip
https://communities.sas.com/t5/New-SAS-User/Gzip-large-dataset/m-p/509812

github SAS zip and unzip
https://github.com/rogerjdeangelis/utl_using_sas_zip_and_unzip_engines

macros
https://tinyurl.com/y9nfugth
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories


Very old benchmarks on very
                                            compress     compress uncompress
                                              size        time    time

bzip2        states.sas7bdat(461,447,168)     67,337,292    174.05   63.52 * not covered
gzip fast    states.sas7bdat(461,447,168)    112,282,714     24.60   15.89
gzip default states.sas7bdat(461,447,168)     93,781,368     53.81   13.67 * I like this one;
compress     states.sas7bdat(461,447,168)    111,307,939     28.70   19.98

More scientific comparson(see summary) (backs up bzip?)
https://tinyurl.com/y7hj7d3p
https://community.centminmod.com/threads/compression-comparison-benchmarks-zstd-vs-brotli-vs-pigz-vs-bzip2-vs-xz-etc.12764/

for macros
https://tinyurl.com/y9nfugth
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

You need these folders

 d:/sd1
 d:/zip

* we will zip and unzip sashelp.class;

libname sd1 "d:/sd1" ;

data sd1.class;
  set sashelp.class;
run;quit;

libname sd1 clear;


*            _               _
  ___  _   _| |_ _ __  _   _| |_ ___
 / _ \| | | | __| '_ \| | | | __/ __|
| (_) | |_| | |_| |_) | |_| | |_\__ \
 \___/ \__,_|\__| .__/ \__,_|\__|___/
                |_|
;

Same output for all solutions;

  d:/zip/class.sas7bdat.gz   ** zipped sashelp.class;

  d:/sd1/class.sas7bdat      ** unzipped gz file sashelp.class;

 *
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;

*******************************
1. R functions zip and unzip  *
*******************************

* delete files only for testing;
%utlfkil(d:/zip/class.sas7bdat.gz);
%utlfkil(d:/sd1/class.sas7bdat);
%utlfkil(d:/sd1/class_copy.sas7bdat);

* create input;
libname sd1 "d:/sd1" ;
data sd1.class;
  set sashelp.class;
run;quit;
libname sd1 clear;

* gzip and unzip keeping csv and zip files;
%utl_submit_r64('
  library(R.utils);
  gzip("d:/sd1/class.sas7bdat",destname="d:/zip/class.sas7bdat.gz",remove=FALSE);
  gunzip("d:/zip/class.sas7bdat.gz",destname="d:/sd1/class_copy.sas7bdat",overwrite=TRUE,remove=FALSE);
');



***************************************
2. Install gzip on power workstation  *
***************************************

Install Documentation
http://www.gzip.org/
http://gnuwin32.sourceforge.net/packages/gzip.htm
http://www.gnu.org/software/gzip/manual/gzip.html

  Usage: gzip [OPTION]... [FILE]...
     Compress or uncompress FILEs (by default, compress FILES in-place).

     Mandatory arguments to long options are mandatory for short options too.

       -c, --stdout      write on standard output, keep original files unchanged
       -d, --decompress  decompress
       -f, --force       force overwrite of output file and compress links
       -h, --help        give this help
       -l, --list        list compressed file contents
       -L, --license     display software license
       -n, --no-name     do not save or restore the original name and time stamp
       -N, --name        save or restore the original name and time stamp
       -q, --quiet       suppress all warnings
       -r, --recursive   operate recursively on directories
       -S, --suffix=SUF  use suffix SUF on compressed files
       -t, --test        test compressed file integrity
       -v, --verbose     verbose mode
       -V, --version     display version number
       -1, --fast        compress faster
       -9, --best        compress better


* delete files only for testing;
%utlfkil(d:/zip/class.sas7bdat.gz);
%utlfkil(d:/sd1/class.sas7bdat);
%utlfkil(d:/sd1/class_copy.sas7bdat);

* create input;
libname sd1 "d:/sd1" ;
data sd1.class;
  set sashelp.class;
run;quit;
libname sd1 clear;

%macro dos(cmd);
    filename xeq pipe &cmd;

    data _null_;
      infile xeq;
      input;
      putlog _infile_;
    run;quit;
%mend dos;

* ZIP;
%dos('c:/gzip/bin/gzip d:/sd1/class.sas7bdat > d:/zip/class.sas7bdat.gz -c -q');

* UNZIP;
%utlfkil(d:/sd1/class.sas7bdat);
%dos('c:/gzip/bin/gzip d:/zip/class.sas7bdat.gz > d:/sd1/class.sas7bdat -c -d');


**************************
3. Vanilla SAS zip unzip *
**************************

* delete files only for testing;
%utlfkil(d:/zip/class.sas7bdat.gz);
%utlfkil(d:/sd1/class.sas7bdat);

* create input;
libname sd1 "d:/sd1" ;
data sd1.class;
  set sashelp.class;
run;quit;
libname sd1 clear;

filename sd1 "d:/sd1/class.sas7bdat";
filename zip zip "d:/zip/class.sas7bdat,gz" member="class.sas7bdat";

data _null_;
   infile sd1 recfm=n;
   file zip recfm=n;
   input byte $char1. @;
   put byte $char1. @;
run;

%utlfkil(d:/sd1/class.sas7bdat);

filename inzip zip "d:/zip/class.sas7bdat,gz" member="class.sas7bdat";
filename sd1 "d:/sd1/class.sas7bdat";

data _null_;
   /* using member syntax here */
   infile inzip(class.sas7bdat)
       lrecl=256 recfm=F length=length eof=eof unbuf;
   file   sd1 lrecl=256 recfm=N;
   input;
   put _infile_ $varying256. length;
   return;
 eof:
   stop;
run;


****************************************************
4. Unix operating system commands gzip and gunzip  *
****************************************************


* delete files only for testing;
%utlfkil(/home/zip/class.sas7bdat.gz);
%utlfkil(/home/sd1/class.sas7bdat);

* create input;
libname sd1 "/home/sd1" ;
data sd1.class;
  set sashelp.class;
run;quit;
libname sd1 clear;

%macro unx(unxcmd);
  filename xeq pipe "&unxcmd";
  data _null_;
    infile xeq;
    input;
    putlog _infile_;
  run;quit;
%mend unx;

%unx(gzip /home/sd1/class.sas7bdat > /home/zip/class.sas7bdat.gz -c -q);

%utlfkil(/home/sd1/class.sas7bdat);
%unx(gunzip /home/zip/class.sas7bdat.gz > /home/sd1/class.sas7bdat -c');


