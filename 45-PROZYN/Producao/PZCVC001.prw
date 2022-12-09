#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PZCVC001  �Autor  �Microsiga	          � Data �  28/08/2019���
�������������������������������������������������������������������������͹��
���Desc.     �Consulta estoque por armazem                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 	                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCVC001()

Local aArea	:= GetArea()
Local cArmz := U_MyNewSX6("CV_ARMCSPR", "00|09|10|11|98|20|95"	,"C","Armazens n�o considerados na consulta de saldo em estoque", "", "", .F. )

ConsEspSB2(SB1->B1_COD, SB1->B1_FILIAL, cArmz)

RestArea(aArea)	
Return



Static Function ConsEspSB2(cProduto,cFilCon,cAlmox)

Local aArea		:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSM0	:= SM0->(GetArea())
Local aViewB2	:= {}
Local aStruSB2  := {}
Local aNewSaldo := {}
Local nTotDisp	:= 0
Local nTotExecDisp:=0
Local nSaldo	:= 0
Local nQtPV		:= 0
Local nQemp		:= 0
Local nSalpedi	:= 0
Local nReserva	:= 0
Local nQempSA	:= 0
Local nSaldoSB2:=0
Local nQtdTerc :=0
Local nQtdNEmTerc:=0
Local nSldTerc :=0
Local nQEmpN :=0
Local nQAClass :=0
Local nQEmpPrj  := 0
Local nQEmpPre  := 0
Local nX        := 0
Local nB2_QATU  := 0,nB2_QPEDVEN := 0,nB2_QEMP := 0,nB2_SALPEDI := 0,nB2_QEMPSA := 0,nB2_RESERVA :=0
Local nB2_QTNP  := 0,nB2_QNPT := 0,	nB2_QTER := 0,nB2_QEMPN := 0,nB2_QACLASS := 0,nB2_QPRJ := 0, nB2_QPRE := 0

Local cFilialSB2:= xFilial("SB2")
Local cFilialSB1:= xFilial("SB1")
Local lViewSB2  := .T.
Local lMTVIEWFIL:= ExistBlock("MTVIEWFIL")
Local nAtIni    := 1
Local oListBox, oDlg, oBold
Local nHdl      := GetFocus()

Static lViewSB2PE
Static lViewSaldo

DEFAULT cAlmox := ""

If ValType(lViewSB2PE) # "L"
	lViewSB2PE	:= ExistBlock("MVIEWSB2SL")
EndIf

If ValType(lViewSaldo) # "L"
	lViewSaldo	:= ExistBlock("MVIEWSALDO")
EndIf

//������������������������������������������������������������������������Ŀ
//� Ponto de entrada para impedir a apresentacao da Dialog de Saldos do SB2�
//��������������������������������������������������������������������������
If ExistBlock("MTVIEWB2")
	lViewSB2 := ExecBlock("MTVIEWB2",.F.,.F.)
EndIf

//������������������������������������������������������������������������Ŀ
//� Verifica a filial de pesquisa do saldo                                 �
//��������������������������������������������������������������������������
If !Empty(cFilCon)
	If !Empty(cFilialSB2)
		cFilialSB2 := cFilCon
	EndIf
	dbSelectArea("SM0")
	dbSetOrder(1)
	MsSeek(cEmpAnt+cFilCon)
EndIf
//������������������������������������������������������������������������Ŀ
//� Posiciona o cadastro de produtos                                       �
//��������������������������������������������������������������������������
dbSelectArea('SB1')
dbSetOrder(1)
If MsSeek(cFilialSB1+cProduto) .And. lViewSB2
	cCursor  := "MAVIEWSB2"
	lQuery   := .T.
	aStruSB2 := SB2->(dbStruct())		
	
	cQuery := ""
	cQuery += "SELECT * FROM "+RetSqlName("SB2")+" WHERE "
	cQuery += "B2_FILIAL='"+cFilialSB2+"' AND "
	cQuery += "B2_COD='"+cProduto+"' AND "
	cQuery += "B2_LOCAL NOT IN"+FORMATIN(cAlmox,"|")+" AND "
	cQuery += "B2_STATUS <> '2' AND "
	cQuery += "D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY B2_LOCAL "
	
	cQuery := ChangeQuery(cQuery)
	
	SB2->(dbCommit())			
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)
	
	For nX := 1 To Len(aStruSB2)
		If aStruSB2[nX][2]<>"C"
			TcSetField(cCursor,aStruSB2[nX][1],aStruSB2[nX][2],aStruSB2[nX][3],aStruSB2[nX][4])
		EndIf
	Next nX
	
	dbSelectArea(cCursor)
	While ( !Eof() )
		nSaldoSB2:=SaldoSB2(,,,,,cCursor)
		// Executa o ponto de entrada para alterar o saldo disponivel pelo usuario
		If lViewSB2PE
			nTotExecDisp:=ExecBlock("MVIEWSB2SL",.F.,.F.,{(cCursor)->B2_COD,(cCursor)->B2_LOCAL,nSaldoSB2})
			If ValType(nTotExecDisp) == "N"
				nSaldoSB2 := nTotExecDisp		
			EndIf
		EndIf		

		//����������������������������������������������������Ŀ
		//� Ponto de Entrada para alterar os itens da Consulta �
		//������������������������������������������������������
		If lMTVIEWFIL
			lRetPE:=ExecBlock("MTVIEWFIL",.F.,.F.,{(cCursor)->B2_COD,(cCursor)->B2_LOCAL}) 
			If ValType(lRetPE)=="L" .And. lRetPE
				dbSelectArea(cCursor)
				dbSkip()
				Loop
			EndIf
		EndIf

		nB2_QATU    := (cCursor)->B2_QATU
		nB2_QPEDVEN := (cCursor)->B2_QPEDVEN
		nB2_QEMP    := (cCursor)->B2_QEMP
		nB2_SALPEDI := (cCursor)->B2_SALPEDI
		nB2_QEMPSA  := (cCursor)->B2_QEMPSA
		nB2_RESERVA := (cCursor)->B2_RESERVA
		nB2_QTNP    := (cCursor)->B2_QTNP
		nB2_QNPT    := (cCursor)->B2_QNPT
		nB2_QTER    := (cCursor)->B2_QTER
		nB2_QEMPN   := (cCursor)->B2_QEMPN
		nB2_QACLASS := (cCursor)->B2_QACLASS
		nB2_QPRJ 	:= (cCursor)->B2_QEMPPRJ
		nB2_QPRE 	:= (cCursor)->B2_QEMPPRE
		If lViewSaldo
			aNewSaldo := {}
			aAdd(aNewSaldo,{nSaldoSB2,nB2_QATU,nB2_QPEDVEN,nB2_QEMP,nB2_SALPEDI,nB2_QEMPSA,nB2_RESERVA,nB2_QTNP,;
			                nB2_QNPT,nB2_QTER,nB2_QEMPN,nB2_QACLASS,nB2_QPRJ,nB2_QPRE})				
			
			If ValType(aNewSaldo:=ExecBlock("MVIEWSALDO",.F.,.F.,{(cCursor)->B2_COD,(cCursor)->B2_LOCAL,aNewSaldo}))=="A" .And. Len(aNewSaldo) > 0
				nSaldoSB2   := aNewSaldo[1,1]
				nB2_QATU    := aNewSaldo[1,2]
				nB2_QPEDVEN := aNewSaldo[1,3]
				nB2_QEMP    := aNewSaldo[1,4]
				nB2_SALPEDI := aNewSaldo[1,5]
				nB2_QEMPSA  := aNewSaldo[1,6]
				nB2_RESERVA := aNewSaldo[1,7]
				nB2_QTNP    := aNewSaldo[1,8]
				nB2_QNPT    := aNewSaldo[1,9]
				nB2_QTER    := aNewSaldo[1,10]
				nB2_QEMPN   := aNewSaldo[1,11]
				nB2_QACLASS := aNewSaldo[1,12]
				nB2_QPRJ    := aNewSaldo[1,13]
				nB2_QPRE    := aNewSaldo[1,14]
            Endif
		EndIf						

		aAdd(aViewB2,{TransForm((cCursor)->B2_LOCAL,PesqPict("SB2","B2_LOCAL")),;
			TransForm(nSaldoSB2,PesqPict("SB2","B2_QATU")),;
			TransForm(nB2_QATU,PesqPict("SB2","B2_QATU")),;
			TransForm(nB2_QPEDVEN,PesqPict("SB2","B2_QPEDVEN")),;
			TransForm(nB2_QEMP,PesqPict("SB2","B2_QEMP")),;
			TransForm(nB2_SALPEDI,PesqPict("SB2","B2_SALPEDI")),;
			TransForm(nB2_QEMPSA,PesqPict("SB2","B2_QEMPSA")),;
			TransForm(nB2_RESERVA,PesqPict("SB2","B2_RESERVA")),;
			TransForm(nB2_QTNP,PesqPict("SB2","B2_QTNP")),;
		    TransForm(nB2_QNPT,PesqPict("SB2","B2_QNPT")),;
			TransForm(nB2_QTER,PesqPict("SB2","B2_QTER")),;
			TransForm(nB2_QEMPN,PesqPict("SB2","B2_QEMPN")),;
			TransForm(nB2_QACLASS,PesqPict("SB2","B2_QACLASS")),;
			TransForm(nB2_QPRJ,PesqPict("SB2","B2_QEMPPRJ")),;
			TransForm(nB2_QPRE,PesqPict("SB2","B2_QEMPPRE"))})
			
		If !Empty(cAlmox) .And. cAlmox == (cCursor)->B2_LOCAL
			nAtIni := Len(aViewB2)
		EndIf

		nTotDisp	+= nSaldoSB2
		nSaldo		+= nB2_QATU
		nQtPV		+= nB2_QPEDVEN
		nQemp		+= nB2_QEMP
		nSalpedi	+= nB2_SALPEDI
		nReserva	+= nB2_RESERVA
		nQempSA		+= nB2_QEMPSA
		nQtdTerc	+= nB2_QTNP
		nQtdNEmTerc	+= nB2_QNPT
		nSldTerc	+= nB2_QTER
		nQEmpN		+= nB2_QEMPN
		nQAClass	+= nB2_QACLASS
		nQEmpPrj    += nB2_QPRJ
		nQEmpPre    += nB2_QPRE
		dbSelectArea(cCursor)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cCursor)
		dbCloseArea()
		dbSelectArea("SB2")
	EndIf

	If !Empty(aViewB2)
		
		DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
		DEFINE MSDIALOG oDlg FROM 000,000  TO 500,600 TITLE "Saldos em Estoque" Of oMainWnd PIXEL //"Saldos em Estoque"
		@ 023,004 To 24,296 Label "" of oDlg PIXEL
		@ 113,004 To 114,296 Label "" of oDlg PIXEL
		oListBox := TWBrowse():New( 30,2,297,69,,{"Local","Qtd.Disponivel","Sld.Atual","Qtd.Pedido de Vendas","Qtd. Empenhada","Qtd. Prevista Entrada","Qtd.Empenhada S.A.","Qtd. Reservada",RetTitle("B2_QTNP"),RetTitle("B2_QNPT"),RetTitle("B2_QTER"),RetTitle("B2_QEMPN"),RetTitle("B2_QACLASS"),RetTitle("B2_QEMPPRJ"),RetTitle("B2_QEMPPRE")},{17,55,55,55,55,55,55,55},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)  //#####################
		oListBox:SetArray(aViewB2)
		oListBox:bLine := { || aViewB2[oListBox:nAT]}
		oListBox:nAt   := Max(1,nAtIni)
		@ 004,010 SAY SM0->M0_CODIGO+"/"+FWCodFil()+" - "+SM0->M0_FILIAL+"/"+SM0->M0_NOME  Of oDlg PIXEL SIZE 245,009
		@ 014,010 SAY Alltrim(cProduto)+ " - "+SB1->B1_DESC Of oDlg PIXEL SIZE 245,009 FONT oBold
		@ 104,010 SAY "TOTAL " Of oDlg PIXEL SIZE 30 ,9 FONT oBold  
		
		@ 120,007 SAY "Quantidade Disponivel    " of oDlg PIXEL //
		@ 119,075 MsGet nTotDisp Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 120,155 SAY "Quantidade Empenhada " of oDlg PIXEL 
		@ 119,223 MsGet nQemp Picture PesqPict("SB2","B2_QEMP") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 135,007 SAY "Saldo Atual   " of oDlg PIXEL 
		@ 134,075 MsGet nSaldo Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 135,155 SAY "Qtd. Entrada Prevista" of oDlg PIXEL
		@ 134,223 MsGet nSalPedi Picture PesqPict("SB2","B2_SALPEDI") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 150,007 SAY "Qtd. Pedido de Vendas  " of oDlg PIXEL
		@ 149,075 MsGet nQtPv Picture PesqPict("SB2","B2_QPEDVEN") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 150,155 SAY "Qtd. Reservada  " of oDlg PIXEL 
		@ 149,223 MsGet nReserva Picture PesqPict("SB2","B2_RESERVA") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 165,007 SAY "Qtd. Empenhada S.A." of oDlg PIXEL
		@ 164,075 MsGet nQEmpSA Picture PesqPict("SB2","B2_QEMPSA") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 165,155 SAY RetTitle("B2_QTNP") of oDlg PIXEL
		@ 164,223 MsGet nQtdTerc Picture PesqPict("SB2","B2_QTNP") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 180,007 SAY RetTitle("B2_QNPT") of oDlg PIXEL
		@ 179,075 MsGet nQtdNEmTerc Picture PesqPict("SB2","B2_QNPT") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 180,155 SAY RetTitle("B2_QTER") of oDlg PIXEL 
		@ 179,223 MsGet nSldTerc Picture PesqPict("SB2","B2_QTER") of oDlg PIXEL SIZE 070,009 When .F.

		@ 195,007 SAY RetTitle("B2_QEMPN") of oDlg PIXEL 
		@ 194,075 MsGet nQEmpN Picture PesqPict("SB2","B2_QEMPN") of oDlg PIXEL SIZE 070,009 When .F.

		@ 195,155 SAY RetTitle("B2_QACLASS") of oDlg PIXEL 
		@ 194,223 MsGet nQAClass Picture PesqPict("SB2","B2_QACLASS") of oDlg PIXEL SIZE 070,009 When .F.

		@ 210,007 SAY RetTitle("B2_QEMPPRJ") of oDlg PIXEL 
		@ 209,075 MsGet nQEmpPrj Picture PesqPict("SB2","B2_QEMPPRJ") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 210,155 SAY RetTitle("B2_QEMPPRE") of oDlg PIXEL 
		@ 209,223 MsGet nQEmpPre Picture PesqPict("SB2","B2_QEMPPRE") of oDlg PIXEL SIZE 070,009 When .F.
   
		//��������������������������������������������������������������������������������������Ŀ
		//� Ponto de entrada para incluir campos na grid  e edits na tela de Consulta ao estoque �
		//����������������������������������������������������������������������������������������
		If ExistBlock("MTGRDVW")                                   
			ExecBlock("MTGRDVW",.F.,.F.,{@aViewB2,@oListBox,@oDlg})
		Endif 
		
		//������������������������������������������������������������������������Ŀ
		//� Ponto de entrada para incluir Botao do Usuario na Dialog Saldos do SB2 �
		//��������������������������������������������������������������������������
		If ExistBlock("BVIEWSB2") 
			@ 230,190 BUTTON "Especifico" SIZE 045,010  FONT oDlg:oFont ACTION (ExecBlock("BVIEWSB2",.F.,.F.)) Of oDlg PIXEL 
		Endif

		@ 230,244  BUTTON "Voltar" SIZE 045,010  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL  

		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		Aviso("Atencao","Nao registro de estoques para este produto.",{"Voltar"},2) 
	EndIf	
EndIf
RestArea(aAreaSM0)
RestArea(aAreaSB2)
RestArea(aAreaSB1)
RestArea(aArea)
SetFocus(nHdl)
Return(.T.)