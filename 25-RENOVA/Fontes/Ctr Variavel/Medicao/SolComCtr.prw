#Include 'Protheus.ch'
#Include 'TopConn.ch'


/*/{Protheus.doc} SolComCtr
Apresenta tela de seleção de Solicitação de Compra
@type User_function
@version  1
@author Junior Placido
@since 14/04/2021
@return Logical, lRet
/*/
User Function SolComCtr()

	Local aArea 		:= GetArea()
	Local cSql   	:= ""
	Local cSolic 	:= ""
	//Local nAcols 	:= 0
	//Local nX  		:= 0
	Local nLin		:= 1

	Local oModelAct := Nil
	Local oView 	:= Nil //Objeto da View
	

	Local aRECNO	:= {}
	Local nCount 	:= 0

	Private cItem := "001"

	oView 	  := FWViewActive()
	oModelAct := FwModelActive()
	oModelAut := oModelAct:GetModel('CNEDETAIL')
	cContra   := oModelAct:GetValue("CNDMASTER" ,"CND_CONTRA")+oModelAct:GetValue("CNDMASTER","CND_REVISA")
	lCXNCheck := oModelaCT:GetValue("CXNDETAIL","CXN_CHECK")
	cCXNTipPla:= oModelaCT:GetValue("CXNDETAIL","CXN_TIPPLA")

if lCXNCheck

	If M->CND_XINTSC ==  "1" .and. cCXNTipPla = "99J"

		If FunName() == 'CNTA121' //Função de Medida Nova -- CNA_TIPPLA e CXN_TIPPLA
        /* Não tem aCols*/

//			oView 	  := FWViewActive() (Luiz)
//			oModelAct := FwModelActive()
//			oModelAut := oModelAct:GetModel('CNEDETAIL')
//			cContra   := oModelAct:GetValue("CNDMASTER" ,"CND_CONTRA")+oModelAct:GetValue("CNDMASTER","CND_REVISA")
//			lCXNCheck := oModelaCT:GetValue("CXN_DETAIL","CXN_CHECK")
			//oModelAut:SetValue("CNE_ITEM", "007")

//			If !Empty(CNA->CNA_XSC) //Pega o numero da solicitação registrada na planilha do contrato
//				cSolic := CNA->CNA_XSC //Se estiver posicionado
//			Else
				cSolic := Posicione("CNA",1,xFilial("CNA")+cContra,"CNA_XSC") //Se não estiver posicionado, posiciona
//			EndIf

			cSql := "SELECT * FROM "+RetSqlName("SC1")+" SC1 WHERE SC1.C1_NUM = '"+cSolic+"' AND SC1.D_E_L_E_T_<> '*' " //Busca solicitação
			If Select("QRY") > 0
				QRY->(DbCloseArea())
			EndIf

			TCQuery cSql New Alias "QRY"
			Count to nTotal

			If nTotal == 0 .OR. Empty(cSolic) //Verifica se houve retorno na SQL
				MsgInfo("Não há solicitação anexada ao contrato","Atenção") //Alerta caso não encontre a solicitação de compra
				Return .T.  //Encerra
			EndIf

			QRY->(DbGoTop())

			While !QRY->(EOF())

				aAdd(aRECNO,QRY->R_E_C_N_O_)
				QRY->(DbSkip())

			End

			For nCount := 1 to Len(aRECNO)

				DbSelectArea("SC1")
				SC1->( DbGoTo( aRECNO[nCount] ) )

				If Empty(oModelAut:GetValue("CNE_ITEM"))
					oModelAut:SetValue("CNE_ITEM" ,SubStr(SC1->C1_ITEM,2,3))
				EndIf

				oModelAut:SetValue("CNE_PRODUT" ,SC1->C1_PRODUTO)
				oModelAut:SetValue("CNE_DESCRI" ,SC1->C1_DESCRI) //o Campo � virtual
				oModelAut:SetValue("CNE_QUANT"  ,1)
				oModelAut:SetValue("CNE_VLUNIT" ,1)
				oModelAut:SetValue("CNE_VLTOT"  ,1)
				oModelAut:SetValue("CNE_CONTA"  ,SC1->C1_CONTA)
				oModelAut:SetValue("CNE_ITEMCT" ,SC1->C1_ITEMCTA)
				oModelAut:SetValue("CNE_CC"     ,SC1->C1_CC)
				oModelAut:SetValue("CNE_CLVL"   ,SC1->C1_CLVL)
				oModelAut:SetValue("CNE_EC05DB" ,SC1->C1_EC05DB)
				//inserido em 29/11/2021 para carregar os campos de projeto
				oModelAut:SetValue("CNE_XIMCUR",SC1->C1_XIMCURS)
				oModelAut:SetValue("CNE_XPROJI",SC1->C1_XPROJIM)

				If nLin < nTotal
					oModelAut:AddLine()
				EndIf

				nLin++

			Next

			oView:Refresh()

		If Select("QRY") > 0
			QRY->(DbCloseArea())
		EndIf


		EndIf

	EndIf

endif

//	If Select("QRY") > 0
//		QRY->(DbCloseArea())
//	EndIf

	RestArea(aArea)

Return .T.
