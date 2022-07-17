Option Explicit

Const fsoForReading = 1
Const fsoForWriting = 2

Dim fso, f, r, newline, filename, processName, nextline, Tvalue
Set fso = CreateObject("Scripting.FileSystemObject")

filename = "C:\Scripts\systeminformation.xml"

Set f = fso.OpenTextFile(filename, fsoForReading)
Set r = fso.CreateTextFile("C:\Scripts\DSM_Report.csv", fsoForWriting)

do until f.AtEndOfStream
   newline = f.readline
   If inStr(newline, "<Name>versionSchema<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "versionSchema," & Tvalue
         r.write "versionSchema," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>firstInstalled<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "First Installed," & Tvalue
         r.write "First Installed," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>lastInstalled<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "Last Installed," & Tvalue
         r.write "Last Installed," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>queuedJobs<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "Queued Jobs," & Tvalue
         r.write "Queued Jobs," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>activeJobs<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "Active Jobs," & Tvalue
         r.write "Active Jobs," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>databaseVersion<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "databaseVersion," & Tvalue
         r.write "databaseVersion," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>databaseServer<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "databaseServer," & Tvalue
         r.write "databaseServer," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>totalJobs<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "Total Jobs in past hour," & Tvalue
         r.write "Total Jobs in past hour," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>hostJobs.activate<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "Activate Job," & Tvalue
         r.write "Activate Job," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>hostJobs.virtual_status_tasks<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "hostJobs.virtual_status_tasks," & Tvalue
         r.write "hostJobs.virtual_status_tasks," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>systemInformation.information.jobs.xdr_statusJobs<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "xdr_statusJobs," & Tvalue
         r.write "xdr_statusJobs," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>systemInformation.information.jobs.emailJobs<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "emailJobs," & Tvalue
         r.write "emailJobs," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>systemInformation.information.jobs.vmotionJobs<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "vmotionJobs," & Tvalue
         r.write "vmotionJobs," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>systemInformation.information.jobs.maintenanceJobs<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "maintenanceJobs," & Tvalue
         r.write "maintenanceJobs," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>pruningSystemEvent<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "pruningSystemEvent," & Tvalue
         r.write "pruningSystemEvent," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>Manager Node:" )>0 Then
         nextline = newline
         Tvalue = Replace(nextline, "<Name>", "")
         Tvalue = Replace(Tvalue, "</Name>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo ""
         'wscript.echo Tvalue
         r.write vbcrlf & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>databaseQueryBenchmark<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "databaseQueryBenchmark," & Tvalue
         r.write "databaseQueryBenchmark," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>numberOfProcessors<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "numberOfProcessors," & Tvalue
         r.write "numberOfProcessors," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>freeDiskSpace<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "freeDiskSpace," & Tvalue
         r.write "freeDiskSpace," & """" & Tvalue & """" & vbcrlf
   End If
   
   If inStr(newline, "<Name>freeMemory<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "freeMemory," & Tvalue
         r.write "freeMemory," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>usedMemory<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "usedMemory," & Tvalue
         r.write "usedMemory," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>maxMemory<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "maxMemory," & Tvalue
         r.write "maxMemory," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>usedSystemMemory<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "usedSystemMemory," & Tvalue
         r.write "usedSystemMemory," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>uptime<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "uptime," & Tvalue
         r.write "uptime," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>databaseType<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "databaseType," & Tvalue
         r.write "databaseType," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>pruningServerLog<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "pruningServerLog," & Tvalue
         r.write "pruningServerLog," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>pruningCounter<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "pruningCounter," & Tvalue
         r.write "pruningCounter," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>pruningAntiMalwareEvent<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "pruningAntiMalwareEvent," & Tvalue
         r.write "pruningAntiMalwareEvent," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>pruningPacketLog<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "pruningPacketLog," & Tvalue
         r.write "pruningPacketLog," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>pruningLogInspectionEvent<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "pruningLogInspectionEvent," & Tvalue
         r.write "pruningLogInspectionEvent," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>pruningPayloadLog<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "pruningPayloadLog," & Tvalue
         r.write "pruningPayloadLog," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>pruningWebReputationEvent<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "pruningWebReputationEvent," & Tvalue
         r.write "pruningWebReputationEvent," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>pruningIntegrityEvent<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "pruningIntegrityEvent," & Tvalue
         r.write "pruningIntegrityEvent," & """" & Tvalue & """" & vbcrlf
   End If
   If inStr(newline, "<Name>pruningAppControlEvent<" )>0 Then
         nextline = f.readline
         Tvalue = Replace(nextline, "<Value>", "")
         Tvalue = Replace(Tvalue, "</Value>", "")
         Tvalue = Replace(Tvalue, vbTab, "")
         'wscript.echo "pruningAppControlEvent," & Tvalue
         r.write "pruningAppControlEvent," & """" & Tvalue & """" & vbcrlf
   End If   
loop   
f.Close
r.Close

