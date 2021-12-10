(*$StackSize 2000H*)
MODULE Assign;

FROM InOut IMPORT Done,
  OpenInput, OpenOutput, CloseInput, CloseOutput, WriteString, WriteLn, 
  ReadString, Write, termCh, in, WriteCard;

IMPORT InOut;

FROM Strings IMPORT Length;
FROM EZStrings IMPORT DeleteLeadingSpaces;

FROM TextTools IMPORT ReadChar;

FROM GSOSInterface IMPORT GSOSInString, GSOSInStringPtr;

FROM OrcaShell IMPORT SetDCB, SetVariable, StopDCB, Stop, ErrorDCB, Error;

FROM EZCommandLine IMPORT getParameters, switchPresent, getSwitchValue, 
  deTabString, UserAborted;

FROM M2Lib IMPORT ToolError;

FROM SYSTEM IMPORT 
  ADR;

VAR
  commandline   : ARRAY [0..255] OF CHAR;
  index         : CARDINAL;
  OK            : BOOLEAN;
  ExportAlso    : BOOLEAN;
  showInfo      : BOOLEAN;
  
  setParms      : SetDCB;
  variableName  : GSOSInString;
  value         : GSOSInString;
  
  stopParms     : StopDCB;
  errorParms    : ErrorDCB;
  
  PROCEDURE GetCharTT(VAR ch: CHAR);
  TYPE
    cardCharType =
      RECORD
        CASE :BOOLEAN OF
          TRUE:  card : CARDINAL;
          |
          FALSE: LSB  : CHAR;
                 HSB  : CHAR;
        END;
      END;
  VAR
    cardChar : cardCharType;

  BEGIN
    cardChar.card := ReadChar(FALSE);
    ch := cardChar.LSB;
  END GetCharTT;

  PROCEDURE TrimString( a: ARRAY OF CHAR; VAR s: ARRAY OF CHAR );
  (*
    OPERATION:
      Takes array in "a" and copies it into "s". The difference is that trailing
      blanks in "a" are not copied to "s". "s" terminates with a null
      character (0C).
    NOTE:
      "s" and "a" may be the same.
  
      "s" must be at least as big as "a".
  *)
  VAR
    i, j: INTEGER;
  BEGIN
    i := HIGH(a);
  
    WHILE (i >= 0 ) AND ((a[i] = ' ') OR (a[i] = 0C)) DO
      DEC(i);
    END;
  
    IF i >= 0 THEN
      FOR j := 0 TO i DO
        s[j] := a[j];
      END;
    END;
  
    INC(i);
    IF i <= VAL(INTEGER, HIGH(s)) THEN
      s[i] := 0C;
    END;
  END TrimString;

BEGIN
  index := 0;
  OK := TRUE;
  ExportAlso := FALSE;
  showInfo := FALSE;
  stopParms.pCount := 1;
  
  WHILE index <= HIGH(value.text) DO
    value.text[index] := 0C;
    INC(index);
  END;

  getParameters(commandline);
  deTabString(commandline);

  IF switchPresent(commandline, "-e") THEN
    ExportAlso := TRUE;
  END;
  
  IF switchPresent(commandline, "-i") THEN
    showInfo := TRUE;
  END;

  IF switchPresent(commandline, "-a") THEN
    getSwitchValue(commandline, "-a", variableName.text);
    variableName.length := Length(variableName.text);
    
    IF switchPresent(commandline, "-v") THEN
      getSwitchValue(commandline, "-v", value.text);
      value.length := Length(value.text);
    ELSE
      index := 0;
      
      Stop(stopParms);
      
      WHILE OK AND (index < 80) AND (NOT stopParms.stopFlag) DO
        GetCharTT(value.text[index]);
    
        IF (value.text[index] >= 40C) AND
           (value.text[index] <= 177C) THEN
          INC(index);
          OK := NOT InOut.Done;
        ELSE
          value.text[index] := 0C;
          OK := FALSE;
        END;

        Stop(stopParms);
      END;
      
      value.length := Length(value.text);
    END;
    
    DeleteLeadingSpaces(value.text);
    TrimString(value.text, value.text);
    
    IF showInfo THEN
      WriteString("Variable: <");
      WriteString(variableName.text); 
      WriteString(">");
      WriteLn;
      WriteString("Value:    <");
      WriteString(value.text);
      WriteString(">");
      WriteLn;

      IF ExportAlso THEN
        WriteString("Export:   <TRUE>");
      ELSE
        WriteString("Export:   <FALSE>");
      END;
      WriteLn;
    END;

    setParms.pCount := 3;
    setParms.varName := ADR(variableName);
    setParms.value := ADR(value);
    setParms.exportable := ExportAlso;
    
    (* Now set the actual variable value *)
    SetVariable(setParms);
    
    IF ToolError() <> 0 THEN
      errorParms.pCount := 1;
      errorParms.errorNumber := ToolError();
      Error(errorParms);
    END
  
  ELSE
    WriteString("usage: assign -a <variablename> [-i] [-e] [-v value]");
    WriteLn;
  END;

END Assign.
