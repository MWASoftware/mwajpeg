Program BuildNo;
{$I-}

var Number: text;
    Build: text;
    I: integer;

begin
     assign(Number,'Buildno.dat');
     assign(Build,'Buildno.txt');
     reset(Number);
     if IOResult = 0 then
     begin
          Readln(Number,I);
          Inc(I)
     end
     else
         I := 1;
     Rewrite(Number);
     writeln(Number,I);
     Rewrite(Build);
     writeln(Build,'This is build number ',I);
     close(Number);
     close(Build)
end.