#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} SolCtr120
Gatilho para função antiga CNTA120, executado na validação do campo CNE_PRODUT
@type User Function
@version  
@author Placido
@since 13/05/2021
@return return_type, return_description
/*/
User Function SolCtr120()
	Local cSolic  := ""
	Local cSql    := ""
	Local cItem   := "001"
	Local cFunBkp := FunName()
    Local nCount  := 0

	If FunName() == "CNTA120" .AND. M->CND_XINTSC == '1' .AND. Len(aCols) == 1

		SetFunName("SolCtr120") //Mudo o nome da função para que não dispare os gatilhos ao incluir o primeiro item e apague os dados contabeis importados

		If !Empty(CNA->CNA_XSC) //Pega o numero da solicitação registrada na planilha do contrato
			cSolic := CNA->CNA_XSC //Se estiver posicionado
		Else
			cSolic := Posicione("CNA",1,xFilial("CNA")+CN9->(CN9_NUMERO+CN9_REVISA),"CNA_XSC") //Se não estiver posicionado, posiciona
		EndIf

		cSql := "SELECT * FROM "+RetSqlName("SC1")+" SC1 WHERE SC1.C1_NUM = '"+cSolic+"' AND SC1.D_E_L_E_T_<> '*' " //Busca solicitação
		If Select("QRY") > 0
			QRY->(DbCloseArea())
		EndIf

		TCQuery cSql New Alias "QRY"
		//Count to nTotal

		//aCols := {}

		While !QRY->(EOF())

			If cItem <> '001'
				aAdd(aCols,Array(Len(aHeader)+1))

				/* 
				Implementei este FOR porque ao criar a linha na aCols, todos os campos vinham como NULL e apresentava erro
				Ajustei para verificar o tipo de campo e preencher com um valor padrão de acordo com ele C = SPace(), N = 0 e d = DataBase
				 */
                For nCount := 2 to (Len(aHeader)-2)
                    aTail(aCols)[nCount] := IIf(aHeader[nCount][8]=='N', 0, IIf(aHeader[nCount][8] == 'D',dDataBase,IIf(aHeader[nCount][8] == 'C',Space( TamSx3(aHeader[nCount][2])[1] ), Nil ) ) )
                Next

			EndIf

			aTail(aCols)[GDFieldPos("CNE_ITEM"	,aHeader)] 		:= cItem
			aTail(aCols)[GDFieldPos("CNE_PRODUT",aHeader)] 		:= QRY->C1_PRODUTO
			aTail(aCols)[GDFieldPos("CNE_DESCRI",aHeader)] 		:= QRY->C1_DESCRI
			aTail(aCols)[GDFieldPos("CNE_QUANT",aHeader)] 		:= 1
			aTail(aCols)[GDFieldPos("CNE_VLUNIT",aHeader)] 		:= 1
			aTail(aCols)[GDFieldPos("CNE_VLTOT",aHeader)] 		:= 1
			aTail(aCols)[GDFieldPos("CNE_CONTA",aHeader)] 		:= QRY->C1_CONTA
			aTail(aCols)[GDFieldPos("CNE_ITEMCT",aHeader)] 		:= QRY->C1_ITEMCTA
			aTail(aCols)[GDFieldPos("CNE_CC",aHeader)] 			:= QRY->C1_CC
			aTail(aCols)[GDFieldPos("CNE_CLVL",aHeader)] 		:= QRY->C1_CLVL
			aTail(aCols)[GDFieldPos("CNE_EC05DB",aHeader)] 		:= QRY->C1_EC05DB
            aTail(aCols)[GDFieldPos("CNE_DTENT",aHeader)] 		:= dDataBase
			aTail(aCols)[GDFieldPos("CNE_PEDTIT",aHeader)] 		:= '1'
			aTail(aCols)[GDFieldPos("CNE_ARREND",aHeader)] 		:= '0'
			aTail(aCols)[GDFieldPos("CNE_IDPED",aHeader)] 		:= '1'
			aTail(aCols)[GDFieldPos("CNE_XIMCUR",aHeader)] 		:= 'N'
			aTail(aCols)[GDFieldPos("CNE_FLGCMS",aHeader)] 		:= '1'
			aTail(aCols)[Len(aHeader)+1] 						:= .F.
			cItem := Soma1(cItem)

			QRY->(dbSkip())

		End

	EndIf

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	SetFunName(cFunBkp) //Volta o nome da função padrão CNTA120

Return .T.
