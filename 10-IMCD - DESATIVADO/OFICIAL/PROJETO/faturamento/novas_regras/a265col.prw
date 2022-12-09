User Function A265COL()
Local nx := 0
Local nCounter:=Len(aCols)
Local nPosData

If nCounter == 1 
	For nx = 1 To Len(aHeader)   
		If Trim(aHeader[nx][2]) == 'DB_DATA'     
			nPosData:=nX   
		EndIf  
	Next   

	aCols[nCounter][nPosData] := dDataBase

EndIf   

Return