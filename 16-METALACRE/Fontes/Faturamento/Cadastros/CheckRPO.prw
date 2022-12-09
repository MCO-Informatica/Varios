///////////////////////////////////////////////////////
*************************
User Function CheckRPO()
*************************

nHdl := fCreate("LOGRPO.TXT")
aRet := GetSrcArray("*.*")

For nX := 1 To Len(aRet)
aInfo := getApoInfo(aRet[nX])
cLinha := aRet[nX] + ","
For nY := 1 To Len(aInfo)
cLinha += Transform(aInfo[nY],"") + ","
Next
fWrite(nHdl, cLinha + chr(13)+chr(10) )
Next

fClose(nHdl)
Return
///////////////////////////////////////////////////////
