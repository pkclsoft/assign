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


