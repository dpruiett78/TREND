Option Explicit

Const fsoForReading = 1
Const fsoForWriting = 2

Dim fso, f, r, newline, filename, processName
Set fso = CreateObject("Scripting.FileSystemObject")

filename = "C:\Scripts\ds_agent.xml"

Set f = fso.OpenTextFile(filename, fsoForReading)
Set r = fso.CreateTextFile("C:\Scripts\ds_agent_NEW.xml", fsoForWriting)

do until f.AtEndOfStream
   newline = f.readline
   If inStr(newline, "><") >0 Then
      newline = Replace(newline, "><",">" & vbcrlf & "<")
      r.write newline & vbcrlf
      
   End If
loop   
f.Close
r.Close

