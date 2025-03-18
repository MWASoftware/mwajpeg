Program updttext;

var infile,
    outfile: text;
    line: string;
    I, J: integer;
    sub: array [1..10] of string;
    Param: string;
    Params: integer;
    ID, Code: integer;

function Num2Str(N: longint): string;

var S: string;

Begin
     Str(N,S);
     Num2Str := S
End;


Begin
     writeln('Text File pre-processor - Version 1.0');
     writeln('Copyright MWA Software 1996');
     If paramcount < 3 Then
     Begin
          writeln('must be at least 3 parameters');
          Halt(1)
     End;
     assign(infile,paramstr(1));
     assign(outfile,paramstr(2));
     reset(infile);
     rewrite(outfile);
     Params := ParamCount - 2;
     For J := 1 to Params Do
         Sub[J] := ParamStr(J+2);
     While not eof(infile) Do
     Begin
          read(infile,Line);
          I := pos('&',Line);
          While (I > 0) And (I<Length(Line)) Do
          Begin
               val(Line[I+1],J,Code);
               If (Code > 0) Or (J=0) Or (J > ParamCount-2) Then Break;
               write(outfile,copy(Line,1,I-1)+Sub[J]);
               Delete(Line,1,I+1);
               I := pos('&',Line);
          End;
          write(outfile,Line);
          If eoln(infile) then
          Begin
               readln(infile);
               writeln(outfile)
          End
     End;
     close(infile);
     close(outfile)
End.
