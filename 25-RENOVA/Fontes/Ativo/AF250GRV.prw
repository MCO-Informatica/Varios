#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AF250GRV  ºAutor  ³Microsiga           º Data ³  22/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualização do Status do Cadastro de Imobilizado em Curso   º±±
±±º          ³              											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AF250GRV()

Local _cQuery1 := ''
Local _cQuery2 := ''
Local _cBaixa  := "B"
Local _cAlias1  := GetNextAlias()

If !Empty(SN3->N3_XPROJIM)
	_cQuery1 := "SELECT N3_FILIAL, N3_CBASE, N3_ITEM, N3_HISTOR, N3_DTBAIXA, N3_XPROJIM FROM "+ RetsqlName("SN3")
	//_cQuery1 += " WHERE N3_FILIAL = '"+xFilial("SN3")+ "'"
	_cQuery1 += " Where N3_XPROJIM = '"+SN3->N3_XPROJIM+ "'"
	_cQuery1 += " AND N3_TIPO = '03'"
	_cQuery1 += " AND D_E_L_E_T_ <> '*'"
	
	//_cQuery1 := ChangeQuery(_cQuery1)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)
	
	DbSelectArea(_cAlias1)
	(_cAlias1)->(DbGoTop())
	
	Do While !(_cAlias1)->(EOF())
		If ALLTRIM((_cAlias1)->N3_DTBAIXA) = ''
		
			_cBaixa := "A" //A=Projeto em Aberto
		
		EndIf
		(_cAlias1)->(DbSkip()) 
		
	Enddo
	//Se não tiver nenhum projeto em aberto no SN3 referente a baixa. Encerra o projeto na SZ0
	If _cBaixa <> "A"
		_cQuery2 := "UPDATE " + RetSqlName("SZ0") + " SET Z0_STATUS = '2'"
		_cQuery2 += " WHERE Z0_CODIGO = '"+ SN3->N3_XPROJIM +"'"
		_cQuery2 += " AND D_E_L_E_T_ <> '*'"
	
		//_cQuery2 := ChangeQuery(_cQuery2)
		
		TCSQLEXEC(_cQuery2)
	EndIf 
		
	(_cAlias1)->(DbCloseArea())	

EndIf

Return nil