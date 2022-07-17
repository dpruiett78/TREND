Option Explicit

Const fsoForReading = 1
Const fsoForWriting = 2

Dim fso, f, r, newline, filename, processName
Set fso = CreateObject("Scripting.FileSystemObject")

filename = "C:\Scripts\RunningProcesses.xml"

Set f = fso.OpenTextFile(filename, fsoForReading)
Set r = fso.CreateTextFile("C:\Scripts\RunningProcesses.txt", fsoForWriting)

do until f.AtEndOfStream
   newline = f.readline
   If inStr(newline, "name=" & Chr(34) & "path" & Chr(34))>0 Then
      processName = Replace(newline, "name=" & Chr(34) & "path" & Chr(34),"")
      processName = Right(processName, Len(processName)-InStr(processName,Chr(34)))
      processName = Left(processName,InStr(processName,Chr(34))-1)
      r.write processName & vbcrlf
      'wscript.echo processName
      
   End If
loop   
f.Close
r.Close

