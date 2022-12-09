#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAF040BAI  บAutor  ณMicrosiga           บ Data ณ  22/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo do Status do Cadastro de Imobilizado em Curso   บฑฑ
ฑฑบ          ณ              											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Renova                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AF040BAI()

Local _cQuery1 := ''
Local _cQuery2 := ''
Local _cQuery3 := ''
Local _cBaixa  := "B"
Local _cAlias1  := GetNextAlias()

//Alert("Numero do Projeto: "+__cProjImb)

If !Empty(__cProjImb)
	
	_cQuery1 := "SELECT N3_FILIAL, N3_CBASE, N3_ITEM, N3_HISTOR, N3_DTBAIXA, N3_XPROJIM FROM "+ RetsqlName("SN3")
	_cQuery1 += " WHERE N3_XPROJIM = '"+__cProjImb+ "'"
	//_cQuery1 += " AND N3_TIPO = '03'"
	_cQuery1 += " AND D_E_L_E_T_ <> '*'"
	
	//_cQuery1 := ChangeQuery(_cQuery1)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)
	
	DbSelectArea(_cAlias1)
	(_cAlias1)->(DbGoTop())
	
	While !(_cAlias1)->(EOF())
		If Alltrim((_cAlias1)->N3_DTBAIXA) = ''
		
			_cBaixa := "A" //A=Projeto em Aberto
		
		EndIf
		
		(_cAlias1)->(DbSkip())
		
	Enddo
	//Se nใo tiver nenhum projeto em aberto no SN3 referente a baixa. Encerra o projeto na SZ0
	If _cBaixa = "B" //B=Projeto encerrado
		_cQuery2 := "UPDATE " + RetSqlName("SZ0") + " SET Z0_STATUS = '2'"
		_cQuery2 += " WHERE Z0_CODIGO = '"+ __cProjImb +"'"
		_cQuery2 += " AND D_E_L_E_T_ <> '*'"
	    
		//_cQuery2 := ChangeQuery(_cQuery2)
	
		TCSQLEXEC(_cQuery2)
	EndIf
		
	//Alert(cbase+"  "+cItemAtivo)
	//_cQuery3 := "UPDATE " + RetSqlName("SN1") + " SET N1_XPROJIM = '"+__cProjImb+'"
	//_cQuery3 += " WHERE N1_FILIAL = '"+ xFilial("SN3") +"'"
	//_cQuery3 += " AND N1_CBASE = '"+cbase+"'"	
	//_cQuery3 += " AND N1_ITEM = '"+cItemAtivo+"'"		
	//_cQuery3 += " AND D_E_L_E_T_ <> '*'"
	//TCSQLEXEC(_cQuery3)
		
	(_cAlias1)->(DbCloseArea())	
	
EndIf

Return nil