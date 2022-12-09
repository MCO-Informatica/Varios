#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Q215GRVA ºAutor  ³ Adriano Leonardo    º Data ³  18/11/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada após a gravação dos resultados da inspeçãoº±±
±±º          ³ de entrada, utilizado para gravar a atividade enzimática   º±±
±±º          ³ informada no resultado da análise de atividade.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Q215GRVA()
	
	Local _aSavArea := GetArea()
	Local _aSavSZ1	:= SZ1->(GetArea())
	Local _cRotina	:= "Q215GRVA"

 //VARIAVEIS REFERENTE O ENDEREÇAMENTO AUTOMATICO
	Local _cAlias2 := ''
	Local aItem:= {}
	Local aCabSDA := {}
	Local nCount := 0
	Local cItem := ''
	Local nTamanho := TamSX3('DB_ITEM')[01]
	Local nModAux := nModulo

	Private lMsErroAuto := .F.
	
	/*/
	_cQry := "SELECT MAX(QER_PRODUT) [QER_PRODUT], MAX(QER_LOTE) [QER_LOTE], MAX(QES_MEDICA) [QES_MEDICA], MAX(B1_UNATIV) [B1_UNATIV], MAX(SB8.B8_LOCAL) [B8_LOCAL], MAX(B1_UNIDAT) [B1_UNIDAT] "
	_cQry += "FROM " + RetSqlName("QER") + " QER WITH (NOLOCK) "
	_cQry += "INNER JOIN " + RetSqlName("QES") + " QES WITH (NOLOCK) "
	_cQry += "ON QER.D_E_L_E_T_='' "
	_cQry += "AND QER.QER_FILIAL='" + xFilial("QER") + "' "
	_cQry += "AND QES.D_E_L_E_T_='' "
	_cQry += "AND QES.QES_FILIAL='" + xFilial("QES") + "' "
	_cQry += "AND QER.QER_CHAVE=QES_CODMED "
	_cQry += "INNER JOIN " + RetSqlName("QE1") + " QE1 WITH (NOLOCK) "
	_cQry += "ON QE1.D_E_L_E_T_='' "
	_cQry += "AND QE1.QE1_FILIAL='" + xFilial("QE1") + "' "
	_cQry += "AND QER.QER_ENSAIO=QE1.QE1_ENSAIO "
	_cQry += "AND QE1.QE1_ATIVID='S' "
	_cQry += "AND QER.QER_CHAVE='" + QER->QER_CHAVE + "' "
	_cQry += "INNER JOIN " + RetSqlName("SB8") + " SB8 WITH (NOLOCK) "
	_cQry += "ON SB8.D_E_L_E_T_='' "
	_cQry += "AND SB8.B8_FILIAL='" + xFilial("SB8") + "' "
	_cQry += "AND SB8.B8_PRODUTO=QER.QER_PRODUT "
	_cQry += "AND SB8.B8_LOTECTL=QER.QER_LOTE "
	_cQry += "AND SB8.B8_ORIGLAN='MI' "
	_cQry += "INNER JOIN " + RetSqlName("SB1") + " SB1 WITH (NOLOCK) "
	_cQry += "ON SB1.D_E_L_E_T_='' "
	_cQry += "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' "
	_cQry += "AND SB1.B1_COD=QER.QER_PRODUT	"
	/*/

	_cQry := "SELECT (QER_PRODUT) [QER_PRODUT], (QER_LOTE) [QER_LOTE], (QES_MEDICA) [QES_MEDICA], (B1_UNATIV) [B1_UNATIV], (SB8.B8_LOCAL) [B8_LOCAL], (B1_UNIDAT) [B1_UNIDAT] "
	_cQry += "FROM " + RetSqlName("QER") + " QER WITH (NOLOCK) "
	_cQry += "INNER JOIN " + RetSqlName("QE1") + " QE1 WITH (NOLOCK) "
	_cQry += "ON QE1.D_E_L_E_T_='' "
	_cQry += "AND QE1.QE1_FILIAL='" + xFilial("QE1") + "' "
	_cQry += "AND QE1.QE1_ENSAIO = QER.QER_ENSAIO AND QE1.QE1_ATIVID = 'S' "
	_cQry += "INNER JOIN " + RetSqlName("QES") + " QES WITH (NOLOCK) "
	_cQry += "ON QES.D_E_L_E_T_='' "
	_cQry += "AND QES.QES_FILIAL='" + xFilial("QER") + "' "
	_cQry += "AND QES.D_E_L_E_T_='' "
	_cQry += "AND QES.QES_FILIAL='" + xFilial("QES") + "' "
	_cQry += "AND QES_CODMED = QER.QER_CHAVE "
	_cQry += "INNER JOIN " + RetSqlName("SB8") + " SB8 WITH (NOLOCK) "
	_cQry += "ON SB8.D_E_L_E_T_='' "
	_cQry += "AND SB8.B8_FILIAL='" + xFilial("SB8") + "' "
	_cQry += "AND SB8.B8_PRODUTO = QER.QER_PRODUT "
	_cQry += "AND SB8.B8_LOTECTL = QER.QER_LOTE "
	_cQry += "INNER JOIN " + RetSqlName("SB1") + " SB1 WITH (NOLOCK) "
	_cQry += "ON SB1.D_E_L_E_T_ = '' "
	_cQry += "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' "
	_cQry += "AND SB1.B1_COD=QER.QER_PRODUT	"
	_cQry += "AND SB8.B8_LOCAL = SB1.B1_LOCPAD "
	_cQry += "WHERE QER.D_E_L_E_T_ = '' "
	_cQry += "AND QE1.QE1_ATIVID = 'S' "
	_cQry += "AND QER.QER_LOTE ='" + QER->QER_LOTE + "' "
	
	_cAlias := GetNextAlias()
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAlias,.T.,.F.)
	
	MemoWrite('Qry_Q215GRVA.txt',_cQry)


	dbSelectArea(_cAlias)

	If (_cAlias)->(!EOF())
		dbSelectArea("SZ1") //Controle de atividade
		dbSetOrder(1) //Filial + Produto + Armazém + Lote
		If dbSeek(xFilial("SZ1")+(_cAlias)->(QER_PRODUTO+B8_LOCAL+QER_LOTE))
			RecLock("SZ1",.F.)
				SZ1->Z1_ORIGEM	:= "SD5"
				SZ1->Z1_ATIVIDA	:= Val((_cAlias)->QES_MEDICA)
				SZ1->Z1_UNIDADE	:= (_cAlias)->B1_UNATIV
				SZ1->Z1_UNATIV	:= (_cAlias)->B1_UNIDAT
				SZ1->Z1_USER	:= UsrRetName(__cUserID)
				SZ1->Z1_DATA	:= dDataBase
				SZ1->Z1_HORA	:= Time()
			SZ1->(MsUnlock())
			
			//Atualiza a atividade na SB8
			U_PZCVA003(SZ1->Z1_PRODUTO, SZ1->Z1_LOCAL, SZ1->Z1_LOTECTL, SZ1->Z1_NUMLOTE, SZ1->Z1_ATIVIDA )
			
		Else
			RecLock("SZ1",.T.)
				SZ1->Z1_FILIAL := xFilial("SZ1")
				SZ1->Z1_PRODUTO := (_cAlias)->QER_PRODUTO
				SZ1->Z1_LOCAL	:= (_cAlias)->B8_LOCAL
				SZ1->Z1_LOTECTL	:= (_cAlias)->QER_LOTE
				SZ1->Z1_ORIGEM	:= "SD5"
				SZ1->Z1_ATIVORI := Val((_cAlias)->QES_MEDICA)
				SZ1->Z1_ATIVIDA	:= Val((_cAlias)->QES_MEDICA)
				SZ1->Z1_UNIDADE	:= (_cAlias)->B1_UNATIV
				SZ1->Z1_UNATIV	:= (_cAlias)->B1_UNIDAT
				SZ1->Z1_USER	:= UsrRetName(__cUserID)
				SZ1->Z1_DATA	:= dDataBase
				SZ1->Z1_HORA	:= Time()
			SZ1->(MsUnlock())

			//Atualiza a atividade na SB8
			U_PZCVA003(SZ1->Z1_PRODUTO, SZ1->Z1_LOCAL, SZ1->Z1_LOTECTL, SZ1->Z1_NUMLOTE, SZ1->Z1_ATIVIDA )

		EndIf
		
		//Chamada de rotina para envio de e-mail quando a atividade enzimática do produto é menor que a permitida
		If ExistBlock("RCFGM001")
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+AllTrim((_cAlias)->QER_PRODUTO))
				If Val((_cAlias)->QES_MEDICA) < SB1->B1_ATIVMIN
					//_cMsg := "<p>O produto (" + AllTrim((_cAlias)->QER_PRODUTO) + ") " + AllTrim(SB1->B1_DESC) + ", deve ter atividade mínima de " + AllTrim(Str(SB1->B1_ATIVMIN)) + AllTrim(SB1->B1_UNATIV) + ", porém na inspeção de entrada a atividade informada foi de " + AllTrim(Str(SD1->D1_ATIVIDA)) +  " " + AllTrim((_cAlias)->B1_UNATIV) + ".</p>"
					_cMsg := "<p>O produto (" + AllTrim((_cAlias)->QER_PRODUTO) + ") " + AllTrim(SB1->B1_DESC) + ", deve ter atividade mínima de " + AllTrim(Str(SB1->B1_ATIVMIN)) + AllTrim(SB1->B1_UNATIV) + ", porém na inspeção de entrada a atividade informada foi de " + (_cAlias)->QES_MEDICA +  " " + AllTrim((_cAlias)->B1_UNATIV) + ".</p>"
					_cMsg += "<p>Lote: " + (_cAlias)->QER_LOTE + "</p>"
					_cMsg += "<p>Armazém: " + (_cAlias)->B8_LOCAL + "</p>"
					_cMsg += "<p>Data: " + DTOC(dDataBase) + "</p>"
					_cMsg += "<p>Hora: " + Time() + "</p>"
					_cMsg += "<p>Responsável: " + AllTrim(UsrRetName(__cUserID)) + "</p>"	
					
					_cMail := SuperGetMV("MV_MAILATI",,"aline.dantas@prozyn.com.br")
					
					U_RCFGM001("Inspeção de entrada - Produto com atividade menor que a permitida!",_cMsg,_cMail)
				EndIf
			EndIf
		EndIf
	EndIf
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbCloseArea())

	RestArea(_aSavSZ1)
	RestArea(_aSavArea)

Return()
