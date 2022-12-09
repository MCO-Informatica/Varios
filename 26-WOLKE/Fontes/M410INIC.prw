#Include 'Protheus.ch'

User Function M410INIC()  
Local nX 
Local nPosCol
	IF FunName() == "MATA416" 
		nPosCol := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))== "C6_VLRBRT"})  

		M->C5_INCEN := SCJ->CJ_INCEN
		M->C5_REP	:= SCJ->CJ_REP
		M->C5_REP2	:= SCJ->CJ_REP2
		M->C5_REP3	:= SCJ->CJ_REP3
		M->C5_CLI	:= SCJ->CJ_CLI
		M->C5_CLI2	:= SCJ->CJ_CLI2
		M->C5_CLI3	:= SCJ->CJ_CLI3
		M->C5_RET1	:= SCJ->CJ_RET1
		M->C5_RET2	:= SCJ->CJ_RET2
		M->C5_RET3	:= SCJ->CJ_RET3
		M->C5_REC1	:= SCJ->CJ_REC1
		M->C5_REC2	:= SCJ->CJ_REC2
		M->C5_REC3	:= SCJ->CJ_REC3  
		M->C5_ORCAMEN:= SCJ->CJ_NUM  
		M->C5_OBSERV := SCJ->CJ_OBSERV  
		M->C5_CONDPAG:= SCJ->CJ_CONDPAG
		
		for nX := 1 to len(aCols)
         
			aCols[nX][nPosCol]  := POSICIONE("DA1",1,xFilial("DA1")+"002"+aCols[1][2],"DA1_PRCCUS")
		                         
		next nX
		
	ENDIF
	
Return(.T.)