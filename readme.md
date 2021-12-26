# assign - A simple shell variable assignment tool for the Apple IIGS 

ORCA is a great development environment, however it lacks a few of the conveniences we enjoy in more modern environments such as linux.

This tool simply allows you to assign a value to a shell variable.  What makes it different to the "SET" command that comes standard with ORCA is that it allows you to pipe a value into a variable.  So you can effectively assign the output of some other shell command into a variable.

Written to compile with ORCA/Modula2, and work in the ORCA/M or APW environments, the tool provides the following command line and options:

assign -a <variablename> [-i] [-e] [-v value]

where:

* -a <variablename> specifies the variable name to which the value will be assigned.
   
* -i display information about what is being done.

* -e export the variable as well

* -v value specifies the value to be assigned to the variable.  if this optional parameter is not provided, the command will attempt to read a value from standard input (ending at the first control character).

## Line Endings
The text and source files in this repository originally used CR line endings, as usual for Apple II text files, but they have been converted to use LF line endings because that is the format expected by Git. If you wish to move them to a real or emulated Apple II and build them there, you will need to convert them back to CR line endings.

If you wish, you can configure Git to perform line ending conversions as files are checked in and out of the Git repository. With this configuration, the files in your local working copy will contain CR line endings suitable for use on an Apple II. To set this up, perform the following steps in your local copy of the Git repository (these should be done when your working copy has no uncommitted changes):

1. Add the following lines at the end of the `.git/config` file:
```
[filter "crtext"]
	clean = LC_CTYPE=C tr \\\\r \\\\n
	smudge = LC_CTYPE=C tr \\\\n \\\\r
```

2. Run the following commands to convert the existing files in your working copy:
```
rm .git/index
git checkout HEAD -- .
```

Alternatively, you can keep the LF line endings in your working copy of the Git repository, but convert them when you copy the files to an Apple II. There are various tools to do this.  One option is `udl`, which is [available][udl] both as a IIGS shell utility and as C code that can be built and used on modern systems.

Another option, if you are using the [GSPlus emulator](https://apple2.gs/plus/) is to host your local repository in a directory that is visible on both your host computer, and the emulator via the excellent [Host FST](https://github.com/ksherlock/host-fst).

[udl]: http://ftp.gno.org/pub/apple2/gs.specific/gno/file.convert/udl.114.shk

## File Types
In addition to converting the line endings, you will also have to set the files to the appropriate file types before building ORCA/Modula-2 on a IIGS.

For each of the different groups of code, there is a`fixtypes` script (for use under the ORCA/M shell) that modifies the file and aux type of all source and build scripts, *apart from the fixtures script itself!*

So, once you have the files from the repository on your IIGS (or emulator), within the ORCA/M shell, execute the following command on each `fixtypes` script:

    filetype fixtypes src 6
