/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN130INC ³ Autor ³ TOTVS S.A.            ³ Data ³ 29/09/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ponto de entrada executado no momento da inclusao das       ³±±
±±³          ³medicoes de contrato.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico GRCON                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN130Inc()
Local nx
Local aHeader    := PARAMIXB[1]
Local aCols      := PARAMIXB[2]
Local aHeaderDes := PARAMIXB[3]
Local aColsDes   := PARAMIXB[4]
Local nPosTar1   := aScan(aHeader,{|x| AllTrim(x[2])  == 'CNE_CC'})
Local nPosTar2   := aScan(aHeader,{|x| AllTrim(x[2])  == 'CNE_CONTA'})
Local nPosTar3   := aScan(aHeader,{|x| AllTrim(x[2])  == 'CNE_NATURE'})
Local nPosTar4   := aScan(aHeader,{|x| AllTrim(x[2])  == 'CNE_CLVL'})
Local nPosTar5   := aScan(aHeader,{|x| AllTrim(x[2])  == 'CNE_ITEMCT'})
//Incluido Ronaldo Bicudo - 27/11/2015
Local nPosTar6   := aScan(aHeader,{|x| AllTrim(x[2])  == 'CNE_EC05DB'})
Local nPosTar7   := aScan(aHeader,{|x| AllTrim(x[2])  == 'CNE_XIMCUR'})
Local nPosTar8   := aScan(aHeader,{|x| AllTrim(x[2])  == 'CNE_XPROJI'})
//Final da Inlcusão
//Local nPosTar4   := aScan(aHeader,{|x| AllTrim(x[2])  == 'CNE_XCLVL'})
//Local nPosTar5   := aScan(aHeader,{|x| AllTrim(x[2])  == 'CNE_XALIQ'})
//Local nPosTar6   := aScan(aHeader,{|x| AllTrim(x[2])  == 'CNE_YYY'})
Local nPosItm    := aScan(aHeader,{|x| AllTrim(x[2])  == 'CNE_ITEM'})
Local cQuery     := ""
Local cAlias     := GetNextAlias()
Local nPos
Local cProj                                 // Gileno
//Local cEpmExc	:= Getnewpar("MV_EMPPROJ")  // Gileno
Private _cRetFunc := ''
Private lPermAlt := .T.
                                                               
UpdPA2() // Atualiza PA2 com base no array publico aArrGrvPA2  

// Chamo a função apenas para atualizar o conteudo da variável lPermAlt de acordo com a empresa selecionada.
_cEmpCNB := CEMPANT+CFILANT
cProj := U_ItemSZ3(_cEmpCNB,"CNB")
/*
*
M->CND_XNATUR := CNA->CNA_XNATUR
*
*/    
//Gravar nome do usuário que está incluindo o Contrato.
// Ronaldo Bicudo - Totvs / 18/06/2018.
M->CND_XNOMUS := ALLTRIM(cUserName)
//Fim da Inclusão                          

//Filtra os itens da planilha
cQuery := "SELECT CNB.CNB_ITEM,CNB.CNB_CC,CNB.CNB_CONTA,CNB.CNB_NATURE,CNB.CNB_CLVL,CNB.CNB_ITEMCT, CNB.CNB_EC05DB,CNB.CNB_NUMSC,CNB.CNB_XIMCUR, CNB.CNB_XPROJI  FROM " + RetSQLName("CNB") + " CNB WHERE "
cQuery += "CNB.CNB_FILIAL = '" + xFilial("CNB") +"' AND "
cQuery += "CNB.CNB_CONTRA = '" + M->CND_CONTRA + "' AND "
cQuery += "CNB.CNB_REVISA = '" + M->CND_REVISA + "' AND "
cQuery += "CNB.CNB_NUMERO = '" + M->CND_NUMERO + "' AND "
cQuery += "CNB.D_E_L_E_T_ = '' "

//Executa query
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), cAlias, .F., .T. )

//Replica informacao do campo do Contrato para o campo da Medição
While !(cAlias)->(Eof())
	If (nPos := aScan(aCols,{|x|x[nPosItm] == (cAlias)->CNB_ITEM})) > 0
		aCols[nPos,nPosTar1]  := (cAlias)->CNB_CC
		aCols[nPos,nPosTar2]  := (cAlias)->CNB_CONTA
				
	//	If CN1->CN1_ESPCTR ="1" .And. ! lPermAlt   //se for compras e não´permitir alteração de projetos 
			//Como não é Holding, pego informações do Projeto da tabela SZ3
		If !SUBSTR(CFILANT,1,5) == '00300' // sefor Holding-Renova,pega o que esta na planilha
			cProj:= u_ItemSZ3(_cEmpCNB,"CNB") //Função para selecionar projeto de acordo com a empresa
			_cProjC := U_ItemSZ0(cProj,"CNB") // com base no item contabil/projeto, retorna o código do projeto em curso
			aCols[nPos,nPosTar5]  := cProj
			aCols[nPos,nPosTar4]  := SUBSTR(cProj,1,2)
			IF SUBSTR(cProj,1,2) <>  SUBSTR((cAlias)->CNB_EC05DB,1,2) //Se classe orçamentária diferente da SC altero os 2 primeiros digitos da classe
				aCols[nPos,nPosTar6] := SUBSTR(cProj,1,2)+SUBSTR((cAlias)->CNB_EC05DB,3,9)
			Else
				aCols[nPos,nPosTar6] := (cAlias)->CNB_EC05DB
			End If	
			If SUBSTR(ALLTRIM((cAlias)->CNB_CONTA),1,7) == '1232103' .AND. !EMPTY(_cProjC)
				aCols[nPos,nPosTar7]  := "S"
				aCols[nPos,nPosTar8]  := alltrim(_cProjC)//inserido alltrim
			Endif
		Else	
			aCols[nPos,nPosTar4]  := (cAlias)->CNB_CLVL
			aCols[nPos,nPosTar5]  := (cAlias)->CNB_ITEMCT
			aCols[nPos,nPosTar6]  := (cAlias)->CNB_EC05DB
			aCols[nPos,nPosTar7]  := (cAlias)->CNB_XIMCUR
			aCols[nPos,nPosTar8]  := (cAlias)->CNB_XPROJI
		Endif
	EndIf
	(cAlias)->(dbSkip())
EndDo
(cAlias)->(dbCloseArea())
Return {aHeader,aCols,aHeaderDes,aColsDes}


Static Function UpdPA2()
Local nLoop   := Nil
Local _aItens := {}

Local cSaldo  := Nil
Local nSaldo  := 0

Local cDescLi := Nil
Local nDescLi := 0
Local _nDesc  := 0


If Type("aArrGrvPA2") <> "A"
	Public aArrGrvPA2 := Nil
Endif

If aArrGrvPA2 == Nil .Or. CND->CND_NUMMED <> aArrGrvPA2[1] .Or. ( ! aArrGrvPA2[3] )
	Return
Endif

_aItens := aArrGrvPA2[2]

For nLoop := 1 to Len(_aItens)
	cSaldo := StrTran(_aItens[nLoop,4],".","")
	cSaldo := StrTran(cSaldo,",",".")
	nSaldo := Val(cSaldo)
	
	cDescLi  := StrTran(_aItens[nLoop,3],".","")
	cDescLi  := StrTran(cDescLi,",",".")
	nDescLi  := Val(cDescLi)
	
	dbSelectArea("PA2")
	dbSetOrder(3)
	dbSeek(xFilial("PA2") + _aItens[nLoop,5] + _aItens[nLoop,6])
	
	If !_aItens[nLoop,1]
		RecLock("PA2", .F.)
		PA2->PA2_USADO  := IIf(nSaldo > 0, "3", "2")
		PA2->PA2_SALDO  += nDescLi
		MsUnlock()
	Else
		RecLock("PA2", .F.)
		PA2->PA2_USADO  := IIf(nSaldo > 0, "3", "1")
		PA2->PA2_SALDO  -= nDescLi
		MsUnlock()
	EndIf
	
	_nDesc += nDescLi
Next

If MsgYesNo("Desconto irá interferir no Pedido?","Atenção!!!")
	MsAguarde({|| GeraDesc(_nDesc,CND->CND_CONTRA,CND->CND_NUMMED,1)}, "Gerando Desconto...")
Else
	MsAguarde({|| GeraDesc(_nDesc,CND->CND_CONTRA,CND->CND_NUMMED,2)}, "Gerando Desconto...")
EndIf


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraDesc ³ Autor ³ Totvs                 ³ Data ³ 09/11    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava tabela CNQ                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Renova                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraDesc(_nDesc,_cContra,_cNumMed,_nIntPed)
Local cTipoDesc := If(_nIntPed == 1, "9999", "9998")

If _nDesc > 0
	dbSelectArea("CNQ")
	dbSetOrder(1)  //  CNQ_FILIAL+CNQ_NUMMED+CNQ_TPDESC
	If dbSeek(xFilial("CNQ") + _cNumMed + cTipoDesc)
		RecLock("CNQ", .F.)
	Else
		RecLock("CNQ", .T.)
		CNQ->CNQ_FILIAL := xFilial("CNQ")
		CNQ->CNQ_TPDESC := cTipoDesc
		CNQ->CNQ_NUMMED := _cNumMed
	Endif
	CNQ->CNQ_CONTRA := _cContra
	CNQ->CNQ_VALOR  := _nDesc
	MsUnlock()
EndIf
Return
