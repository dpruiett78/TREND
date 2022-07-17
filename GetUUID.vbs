Const fsoForReading = 1
Const fsoForWriting = 2
Set fso = CreateObject("Scripting.FileSystemObject" )            

Set file2 = fso.OpenTextFile("C:\Scripts\hostCSV.csv",1,1)

Do Until file2.AtEndOfStream
  'WScript.Echo file2.ReadLine
  NewLine = file2.ReadLine
  FirstField = ""
  SecondField = ""
  ThirdField = ""
  FourthField = ""
  FifthField = ""
  SixthField = ""
  file1loop = file1loop + 1
  if instr(NewLine,",")>0 then
     FirstField = Left(Newline,instr(NewLine,",")-1)			'VM Name
     'wscript.echo FirstField
     NewLine = Right(NewLine,len(NewLine)-instr(NewLine,","))
     SecondField = Left(Newline,instr(NewLine,",")-1)			'Internal VN Name
     'wscript.echo SecondField
     NewLine = Right(NewLine,len(NewLine)-instr(NewLine,","))
     ThirdField = Left(Newline,instr(NewLine,",")-1)			'OS
     'wscript.echo ThirdField
     NewLine = Right(NewLine,len(NewLine)-instr(NewLine,","))
     FourthField = Left(Newline,instr(NewLine,",")-1)			'Real Name
     'wscript.echo FourthField
     NewLine = Right(NewLine,len(NewLine)-instr(NewLine,","))
     FifthField = Left(Newline,instr(NewLine,",")-1)			'BIOS UUID
     'wscript.echo FifthField
     'wscript.echo NewLine
     NewLine = Replace(Newline,",","")
     SixthField = NewLine						'VC UUID
     'wscript.echo SixthField
     file2loop=0
     Set file = fso.OpenTextFile("C:\Scripts\qmsbrcvc01_VMInfo.csv",1,1) 
     Do Until file.AtEndOfStream
       'WScript.Echo file.ReadLine
       file2loop = file2loop + 1
       NewLine2 = file.ReadLine

       
       if instr(NewLine2,",")>0 then
          FirstField2 = ""
          SecondField2 = ""
          ThirdField2 = ""
          FourthField2 = ""
          FirstField2 = Left(Newline2,instr(NewLine2,",")-1)			'VM Name
          'wscript.echo FirstField2
          NewLine2 = Right(NewLine2,len(NewLine2)-instr(NewLine2,","))
          SecondField2 = Left(Newline2,instr(NewLine2,",")-1)			'DNS Name
          'wscript.echo SecondField2
          NewLine2 = Right(NewLine2,len(NewLine2)-instr(NewLine2,","))
          ThirdField2 = Left(Newline2,instr(NewLine2,",")-1)			'BIOS UUID
          'wscript.echo ThirdField2
          NewLine2 = Right(NewLine2,len(NewLine2)-instr(NewLine2,","))
          NewLine2 = Replace(Newline2,",","")
          FourthField2 = NewLine2						'Internal VM Name
          'wscript.echo FourthField2
          matchfound = "No"
          

          'wscript.echo firstfield & "," & fourthfield
          if instr(firstfield,"VIRTUAL_AGENT_")>0 then
          if lcase(replace(secondfield2,"VIRTUAL_AGENT_","")) = lcase(replace(firstfield,"VIRTUAL_AGENT_","")) then
             'wscript.echo firstfield & "," & fourthfield
             if lcase(thirdfield2)=lcase(fifthfield) then
                MatchFound="Yes"
             End If
             wscript.echo firstfield & "," & secondfield2 & "," & fifthfield & "," & thirdfield2 & "," & matchfound
             
          end if
          end if
       end if
     loop
     file.Close
   end if
Loop
wscript.echo file1loop
wscript.echo file2loop

file2.Close
