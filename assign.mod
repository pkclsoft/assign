(*$StackSize 2000H*)
MODULE Assign;

FROM InOut IMPORT
  OpenInput, OpenOutput, CloseInput, CloseOutput, WriteString, WriteLn, 
  ReadString, Write, termCh, in, WriteCard;

IMPORT InOut;

FROM TextTools IMPORT ReadChar;

FROM EZCommandLine IMPORT getParameters, switchPresent, getSwitchValue, 
     deTabString;

VAR
  commandline : ARRAY [0..255] OF CHAR;
  variablename : ARRAY [0..255] OF CHAR;
  
  value:  ARRAY [0..79] OF CHAR;
  index : CARDINAL;
  OK : BOOLEAN;
  ExportAlso : BOOLEAN;  
  PROCEDURE GetCharTT(VAR ch: CHAR);
  TYPE
    cardCharType =
      RECORD
        CASE :BOOLEAN OF
          TRUE: card: CARDINAL;
          |
          FALSE: LSB: CHAR;
                 HSB: CHAR;
        END;
      END;
  VAR
    cardChar : cardCharType;
  
  BEGIN
    cardChar.card := ReadChar(FALSE);
    ch := cardChar.LSB;
  END GetCharTT;
  
BEGIN
  index := 0;
  OK := TRUE;
  ExportAlso := FALSE;
  
  WHILE index <= HIGH(value) DO
    value[index] := 0C;
    INC(index);
  END;

  getParameters(commandline);
  deTabString(commandline);

  IF switchPresent(commandline, "-e") THEN
    ExportAlso := TRUE;
  END;

  IF switchPresent(commandline, "-a") THEN
    getSwitchValue(commandline, "-a", variablename);

    IF switchPresent(commandline, "-v") THEN
      getSwitchValue(commandline, "-v", value);
    ELSE
  
      index := 0;
  
      WHILE OK AND (index < 80) DO
        GetCharTT(value[index]);
    
        IF (value[index] >= 40C) AND
           (value[index] <= 177C) THEN
          INC(index);
          OK := NOT InOut.Done;
        ELSE
          value[index] := 0C;
          OK := FALSE;
        END;
      END;
    END;

    WriteString("Variable: <");
    WriteString(variablename); 
    WriteString(">");
    WriteLn;
    WriteString("Value:    <");
    WriteString(value);
    WriteString(">");
    WriteLn;

    IF ExportAlso THEN
      WriteString("Export:   <TRUE>");
    ELSE
      WriteString("Export:   <FALSE>");
    END;
    WriteLn;
  
  ELSE
    WriteString("usage: assign -a <variablename> [-e] [-v value]");
    WriteLn;
  END;
  
END Assign.
