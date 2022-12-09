#Include 'Protheus.ch'

/*/{Protheus.doc} CTSDK021

Funcao personalizada para consulta de grupos do operador corrente

@author Totvs SM - David
@since 25/07/2014
@version P11

/*/
	User Function ctsdk021()
	Local cGrupo:= ""
	Local cGrpOp:= ""
	Local aGrpOp:= ""
	Local aPar	:= {}
	Local bOk	:= nil
	Local aRet	:= {}
	Local nI	:= 0
	
	cGrpOp := StaticCall(PESQHIST,RETGRUPO,.T.) 
	aGrpOp := StrTokArr(cGrpOp, "/")
	
	For nI:=1 to Len(aGrpOp)
		aGrpOp[nI] := aGrpOp[nI]+"="+Posicione("SU0", 1, xFilial("SU0")+aGrpOp[nI], "U0_NOME") 
	Next
	
	Aadd(aPar,{3,"Grupos"	,1,aGrpOp,100,'.T.',.T.})
	
	bOK := {|| .T. }

	If !ParamBox( aPar, 'Grupos de Atendimento', @aRet, bOk,,,,,,,.T.,.T.)
		cGrupo := ""
	Else
		cGrupo	:= Left(aGrpOp[IIF(Valtype(aRet[1])<>"N", Ascan(aImp,aRet[1]), aRet[1])],2)
	Endif	
		
	Return(cGrupo)