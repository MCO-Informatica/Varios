#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"

/*
+==================+======================+================+
|Programa: SF2460I |Autor: Antonio Carlos |Data: 13/03/08  |
+==================+======================+================+
|Descricao: Ponto de Entrada utilizado no final da grava   |
|cao do SF2, onde sao processados Pedido de Compra/Pre-Nota|
|para acerto de Consignacao.                               |
+==========================================================+
|Uso: Laselva                                              |
+==========================================================+
*/



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function D2_SITTRIB()
//////////////////////////

_dDataST := GetMv('LS_DTSITTR')
For _dData := _dDataST TO ctod('30/09/2012')
	_cQuery := "SELECT R_E_C_N_O_"
	_cQuery += " FROM SD2010 (NOLOCK)"
	_cQuery += " WHERE D2_SITTRIB = ''"
	_cQuery += " AND D2_EMISSAO = '" + dtos(_dData) + "'"
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SD2ST', .F., .T.)	

	DbGoTop()
	Do While !eof()
		_cQuery := "UPDATE SD2"
		_cQuery += " SET SD2.D2_SITTRIB = TST.D2_SITTRIB"
		_cQuery += " FROM SD2010 SD2 (NOLOCK)"
		_cQuery += " inner JOIN PLUTAO.BASETESTE.dbo.SD2010 LEG"
		_cQuery += " ON TST.R_E_C_N_O_ = SD2.R_E_C_N_O_"
		_cQuery += " WHERE = SD2.R_E_C_N_O_ = " + str(SD2ST->R_E_C_N_O_)
		TcSqlExec(_cQuery)
		DbSkip()	
	EndDo
	PutMv('LS_DTSITTR',_dData)
Next	
Return()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//User Function D2_SITTRIB()
//////////////////////////

MsAguarde({|| RunPRoc()})

Return()

Static Function RunProc()

DbUseArea(.T.,,"D2_SITTRIB","SIT",.T.,.F.)

DbSelectArea('SD2')

_cFilial := alltrim(SIT->FILIAL)
_cData   := alltrim(dtos(MAX(SIT->EMISSAO,SIT->DATADE)))
_cNumSeq := alltrim(SIT->NUMSEQ)

DbSetOrder(5)
Do While !DbSeek(_cFilial + _cData + alltrim(_cNumSeq),.t.)
	If !eof()
		_cFilial := SD2->D2_FILIAL   
		_cData   := dtos(SD2->D2_EMISSAO)
	EndIf
EndDo
Do While !eof() //.and. SD2->D2_EMISSAO <= SIT->DATAATE
	
	_cFilial := alltrim(SIT->FILIAL)
	_cData   := alltrim(dtos(MAX(SIT->EMISSAO,SIT->DATADE)))
	_cNumSeq := alltrim(SIT->NUMSEQ)
	
	DbSelectArea('SD2')
	Do While !DbSeek(_cFilial + _cData + alltrim(_cNumSeq),.t.)
		If !eof()
			_cFilial := SD2->D2_FILIAL             
			_cData   := dtos(SD2->D2_EMISSAO)
		EndIf
	EndDo
	Do While _cFilial == SD2->D2_FILIAL .and. SD2->D2_EMISSAO <= SIT->DATAATE .and. !eof()
		
		MsProcTxt('Filial: ' + SD2->D2_FILIAL + '  Data: ' + dtoc(SD2->D2_EMISSAO) + '  NF: ' + SD2->D2_DOC + '/' + SD2->D2_SERIE)
		RecLock('SIT',.f.)
		SIT->FILIAL  := SD2->D2_FILIAL
		SIT->EMISSAO := SD2->D2_EMISSAO
		SIT->NUMSEQ  := SD2->D2_NUMSEQ
		MsUnLock()
		
		If  SD2->D2_EMISSAO > SIT->DATAATE
			DbSelectArea('SD2')
			_cFilial := Soma1(_cFilial)
			Do While !SD2->(DbSeek(_cFilial + dtos(SIT->DATADE),.t.))
				_cFilial := Soma1(_cFilial)
			EndDo
			loop
		EndIf
		
		If !empty(SD2->D2_SITTRIB)
			SD2->(DbSkip())     
			If _cFilial <> SD2->D2_FILIAL          
				RecLock('SIT',.f.)
				SIT->FILIAL  := SD2->D2_FILIAL
				SIT->EMISSAO := SIT->DATADE
				SIT->NUMSEQ  := ''
				MsUnLock()
					
				Exit
			EndIf	
			loop
		EndIf
		
		RecLock('SD2',.f.)
		If right(SD2->D2_CLASFIS,2) == '00'
			If SD2->D2_PICM == 0
				SD2->D2_SITTRIB := '1'
			Else
				SD2->D2_SITTRIB := 'T' + strzero(SD2->D2_PICM*100,4)
			EndIf
		ElseIf right(SD2->D2_CLASFIS,2) == '40'
			SD2->D2_SITTRIB := 'I1'
		ElseIf right(SD2->D2_CLASFIS,2) == '41'
			SD2->D2_SITTRIB := 'I1'
		ElseIf right(SD2->D2_CLASFIS,2) == '60'
			SD2->D2_SITTRIB := 'N1'
		ElseIf right(SD2->D2_CLASFIS,2) == '90'
			If SD2->D2_VALIMP1 + SD2->D2_VALIMP2 + SD2->D2_VALIMP3 + SD2->D2_VALIMP4 + SD2->D2_VALIMP5 + SD2->D2_VALIMP6 == 0
				SD2->D2_SITTRIB := 'N1'
			Else
				SD2->D2_SITTRIB := 'S0500'
			EndIf
		Else
			SD2->D2_SITTRIB :=  ''
		EndIf
		MsUnLock()
		           
		DbSelectArea('SD2')
		DbSkip()
	EndDo

EndDo