#Include "Protheus.Ch"
/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+-------------------------------+------------------+||
||| Programa: SigaTmk  | Autor: Celso Ferrone Martins  | DAta: 12/11/2014 |||
||+-----------+--------+-------------------------------+------------------+||
||| Descricao | Ponto de Entrada ao entrar no modulo Call Center          |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/                                                           

User Function SigaTmk()

Public cCfmFilNew := ""
Public lVqEdtTC := .F. // Edita tipo cliente no callcenter
cUsers := GetMv("VQ_VISUCLI")

If !(__cUserId $ cUsers)  
		U_DBFILSA1()	
EndIf



Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CFMFILSA1 | Autor: Celso Ferrone Martins  | Data: 10/11/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CFMFILSA1(cOrigem)

Local lRet     := .T.
Local cFiltro  := ""
Local aFiltro  := {}

DbSelectArea("SU7") ; DbSetOrder(4)
DbSelectArea("Z12") ; DbSetOrder(1)

If SU7->(DbSeek(xFilial("SU7") + __cUserId))
	If Z12->(DbSeek(xFilial("Z12")+SU7->U7_CODVEN))
		While !Z12->(Eof()) .And. Z12->(Z12_FILIAL+Z12_COD) == xFilial("Z12")+SU7->U7_CODVEN
			
			If !Empty(Z12->Z12_REGIAO) .Or. !Empty(Z12->Z12_GRUPO)
				cFiltro += Z12->Z12_REGIAO+Z12->Z12_GRUPO+"|"
				aAdd(aFiltro,{Z12->Z12_REGIAO,Z12->Z12_GRUPO})
			EndIf
			
			Z12->(DbSkip())
		EndDo
	EndIf
EndIf

DbSelectArea("SA1") ; DbSetOrder(1)
Set Filter To

If Len(aFiltro) > 0

	cCfmFilNew := "A1_FILIAL='" + xFilial("SA1") + "'"
	For nX := 1 To Len(aFiltro)
		If nX == 1
			cCfmFilNew += ".And.("
		Else
			cCfmFilNew += ".Or."
		EndIf
		cCfmFilNew += "(A1_REGIAO+A1_GRPVEN='"+aFiltro[nX][1]+aFiltro[nX][2]+"')"
	Next

	cCfmFilNew += ")"           

	DbSelectArea("SA1")
	Set Filter To &(cCfmFilNew)
	
EndIf

Return(lRet)    

User Function DBFILSA1()  
Local lRet     := .T.    
Local cRLibEdt := GETMV("VQ_LIBEDTC")
Public _cVended := ""       
               
DbSelectArea("SU7") ; DbSetOrder(4)
DbSelectArea("Z12") ; DbSetOrder(1)
If SU7->(DbSeek(xFilial("SU7") + __cUserId)) 
	_cVended := SU7->U7_CODVEN
	If Z12->(DbSeek(xFilial("Z12")+_cVended))
		While !Z12->(Eof()) .And. Z12->(Z12_FILIAL+Z12_COD) == xFilial("Z12")+_cVended
			If AllTrim(Z12->Z12_REGIAO) $ cRLibEdt
				lVqEdtTC := .T.
			EndIf
			Z12->(DbSkip())
		EndDo
EndIf
	
EndIf   

DbSelectArea("SA1") ; DbSetOrder(14)
Set Filter To

cCfmFilNew := "A1_FILIAL='" + xFilial("SA1") + "' .AND. ('" + _cVended + "' $ A1_VQ_VEND)"
DbSelectArea("SA1")
Set Filter To &(cCfmFilNew)
Return lRet

User Function FilSA1P12()
Local cSQL := "",  _cVended := ""  

DbSelectArea("SU7") ; DbSetOrder(4)
If SU7->(DbSeek(xFilial("SU7") + __cUserId)) 
	_cVended := SU7->U7_CODVEN
EndIf

If !(__cUserId $ GetMv("VQ_VISUCLI"))  
	//cSQL := "@A1_FILIAL = '" + xFilial("SA1") + "' AND A1_VQ_VEND LIKE '%"+_cVended + "%'"	
	cSQL := "@A1_VQ_VEND LIKE '%"+_cVended + "%'"
EndIf   


Return cSQL
