#Include 'Protheus.ch'


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CSRAXENU |Autor: |David Alves dos Santos |Data: |21/07/2017   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Validação de numeração automatica SRA.                        |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CSRAXENU()
	
	Local aArea    := GetArea()
	Local cXENum   := GetSXENum('SRA','RA_MAT')
	Local cRet     := ""
	Local lXEVerif := .T.
	
	While lXEVerif
		SRA->(DbSetOrder(1)) //-> RA_FILIAL + RA_MAT
		If SRA->(DbSeek(xFilial() + cXENum))
			ConfirmSX8() 
			cXENum := GetSXENum('SRA','RA_MAT')
		Else
			cRet     := cXENum
			lXEVerif := .F. 	
		EndIf
	EndDo
	
	RestArea( aArea )
	
Return( cRet )