#INCLUDE "PROTHEUS.CH"
#Include "rwmake.ch"
#INCLUDE "DBTREE.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³HCMA001    ³ Autor ³ Robson Bueno         ³ Data ³28.06.2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Cria uma tela de consulta Tudo Sobre Produto                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Codigo do Produto                                     ³±±
±±³          ³ExpC2: Filial de Consulta                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Materiais                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
.AND. U_HCMA001(M->C6_PRODUTO,"01",M->C5_CLIENTE,M->C5_LOJACLI) 

*/            

User Function HCMA001(cProduto,cFilCon,cCliente,cLoja,cTipo)
Local aArea		:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSM0	:= SM0->(GetArea())
Local aAreaSC5  := SC5->(GETAREA())
Local aAreaSC6  := SC6->(GETAREA())
Local aViewB2	:= {}
Local aStruSB2  := {}
Local aViewC6	:= {}
Local aViewCK	:= {}
Local oCursor	:= LoadBitMap(GetResources(),"LBNO")
Local nTotDisp	:= 0
Local nTotExecDisp:=0
Local nSaldo	:= 0
Local nPosse    :=0
Local nQtPV		:= 0
Local nQemp		:= 0
Local nSalpedi	:= 0
Local nReserva	:= 0
Local nQempSA	:= 0
lOCAL nExcessao := 0 
Local cIndice
Local cPedref   
Local nVdNor	:=0
Local nVdMin	:=0 
Local cTabela  :=Space(8)
Local nSaldoSB2:=0
Local nQtdTerc :=0
Local nQtdNEmTerc:=0
Local nSldTerc :=0
Local nX        := 0
Local cFilialSB2:= xFilial("SB2")
Local cFilialSB1:= xFilial("SB1")
Static lViewSB2PE
IF cTipo<>"NUA"
  U_HCIRAP(cProduto,cCliente,cTipo)
  RestArea(aAreaSM0)
  RestArea(aAreaSB2)
  RestArea(aAreaSB1)
  RESTAREA(AAREASC5)
  RESTAREA(AAREASC6)
  RestArea(aArea) 
ELSE
 IF FunName()=="MATA650"
    cCliente:="000000"
    cLoja:="00"
 ENDIF
 If ValType(lViewSB2PE) # "L"
	lViewSB2PE	:= ExistBlock("MVIEWSB2SL")
 EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a filial de pesquisa do saldo                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cFilCon)
	If !Empty(cFilialSB2)
		cFilialSB2 := cFilCon
	EndIf
	If !Empty(cFilialSB1)
		cFilialSB1 := cFilCon
	EndIf
	dbSelectArea("SM0")
	dbSetOrder(1)
	MsSeek(cEmpAnt+cFilCon)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o cadastro de produtos                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('SB1')
dbSetOrder(1)
If MsSeek(cFilialSB1+cProduto)
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			cCursor  := "MAVIEWSB2"
			lQuery   := .T.
			aStruSB2 := SB2->(dbStruct())		
			
			cQuery := ""
			cQuery += "SELECT * FROM "+RetSqlName("SB2")+" WHERE "
			cQuery += "B2_FILIAL='"+cFilialSB2+"' AND "
			cQuery += "B2_COD='"+cProduto+"' AND "
			cQuery += "B2_STATUS <> '6' AND "
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
				If !((cCursor)->B2_STATUS=='2')
				  nSaldoSB2:=SaldoSB2(,,,,,cCursor)
				  // Executa o ponto de entrada para alterar o saldo disponivel pelo usuario
				  If lViewSB2PE
				  	nTotExecDisp:=ExecBlock("MVIEWSB2SL",.F.,.F.,{(cCursor)->B2_COD,(cCursor)->B2_LOCAL,nSaldoSB2})
				  	If ValType(nTotExecDisp) == "N"
						nSaldoSB2 := nTotExecDisp		
					EndIf
				  EndIf		
				  DBSELECTAREA("SB6")
                  DBSETORDER(1)                                                                                                          
                  nPosse:=0
                  If SB6->(DbSeek(xFilial("SB6")+(cCursor)->B2_COD))
  	                While xFilial("SB6") == SB6->B6_FILIAL .and. ! SZB->(Eof()) .and. SB6->B6_PRODUTO == (cCursor)->B2_COD 
    	             if SB6->B6_SALDO>0 .AND. SB6->B6_TIPO="E" .and. SB6->B6_CLIFOR<>'000090' .AND. SB6->B6_LOCAL=(CcURSOR)->B2_LOCAL
    	                nPosse+=SB6->B6_SALDO
    	             ENDIF
   		             SB6->(DbSkip())
   	                EndDo 
                  ENDIF
                  dbSelectArea(cCursor)
			    	aAdd(aViewB2,{TransForm((cCursor)->B2_LOCAL,PesqPict("SB2","B2_LOCAL")),;
					TransForm(nSaldoSB2-(cCursor)->B2_QPEDVEN+(cCursor)->B2_QNPT-nPosse,PesqPict("SB2","B2_QATU")),;
					TransForm((cCursor)->B2_QATU,PesqPict("SB2","B2_QATU")),;
					TransForm((cCursor)->B2_QPEDVEN,PesqPict("SB2","B2_QPEDVEN")),;
					TransForm((cCursor)->B2_QEMP,PesqPict("SB2","B2_QEMP")),;
					TransForm((cCursor)->B2_SALPEDI,PesqPict("SB2","B2_SALPEDI")),;
					TransForm((cCursor)->B2_QEMPSA,PesqPict("SB2","B2_QEMPSA")),;
					TransForm((cCursor)->B2_RESERVA,PesqPict("SB2","B2_RESERVA")),;
					TransForm((cCursor)->B2_QTNP,PesqPict("SB2","B2_QTNP")),;
				    TransForm((cCursor)->B2_QNPT,PesqPict("SB2","B2_QNPT")),;
				    TransForm((cCursor)->B2_QTER,PesqPict("SB2","B2_QTER"))})
				  nTotDisp	+= (cCursor)->B2_QATU+(cCursor)->B2_QNPT-nPosse
				  nSaldo    += (cCursor)->B2_QATU
				  nQtPV		+= (cCursor)->B2_QPEDVEN
				  nQemp		+= (cCursor)->B2_QEMP
				  nSalpedi	+= (cCursor)->B2_SALPEDI
				  nReserva	+= (cCursor)->B2_RESERVA
				  nQempSA	+= (cCursor)->B2_QEMPSA
				  nQtdTerc += (cCursor)->B2_QTNP
				  nQtdNEmTerc+= (cCursor)->B2_QNPT
				  nSldTerc+= (cCursor)->B2_QTER
				else
			      nTotDisp	+=(cCursor)->B2_QATU 
				  nSaldo    +=(cCursor)->B2_QATU
				EndIf
				dbSelectArea(cCursor)
				dbSkip()
			EndDo
			If lQuery
				dbSelectArea(cCursor)
				dbCloseArea()
				dbSelectArea("SB2")
			EndIf
		Else
	#ENDIF
		dbSelectArea("SB2")
		dbSetOrder(1)
		MsSeek(cFilialSB2+cProduto)
		While !Eof() .And. cFilialSB2+cProduto == SB2->B2_FILIAL+SB2->B2_COD
			If !(SB2->B2_STATUS=='2')
				nSaldoSB2:=SaldoSB2(,,,,,"SB2")
				// Executa o ponto de entrada para alterar o saldo disponivel pelo usuario
				If lViewSB2PE
					nTotExecDisp:=ExecBlock("MVIEWSB2SL",.F.,.F.,{SB2->B2_COD,SB2->B2_LOCAL,nSaldoSB2})
					If ValType(nTotExecDisp) == "N"
						nSaldoSB2 := nTotExecDisp		
					EndIf
				EndIf		
				aAdd(aViewB2,{TransForm(SB2->B2_LOCAL,PesqPict("SB2","B2_LOCAL")),;
					TransForm(nSaldo-SB2->B2_QPEDVEN+SB2->B2_QNPT,PesqPict("SB2","B2_QATU")),;
					TransForm(SB2->B2_QATU,PesqPict("SB2","B2_QATU")),;
					TransForm(SB2->B2_QPEDVEN,PesqPict("SB2","B2_QPEDVEN")),;
					TransForm(SB2->B2_QEMP,PesqPict("SB2","B2_QEMP")),;
					TransForm(SB2->B2_SALPEDI,PesqPict("SB2","B2_SALPEDI")),;
					TransForm(SB2->B2_QEMPSA,PesqPict("SB2","B2_QEMPSA")),;
					TransForm(SB2->B2_RESERVA,PesqPict("SB2","B2_RESERVA")),;
					TransForm(SB2->B2_QTNP,PesqPict("SB2","B2_QTNP")),;
					TransForm(SB2->B2_QNPT,PesqPict("SB2","B2_QNPT")),;
					TransForm(SB2->B2_QTER,PesqPict("SB2","B2_QTER"))})
				nTotDisp	+= nSaldoSB2+SB2->B2_QNPT
				nSaldo      += SB2->B2_QATU
				nQtPV		+= SB2->B2_QPEDVEN
				nQemp		+= SB2->B2_QEMP
				nSalpedi	+= SB2->B2_SALPEDI
				nReserva	+= SB2->B2_RESERVA
				nQempSA	+= SB2->B2_QEMPSA
				nQtdTerc += SB2->B2_QTNP
				nQtdNEmTerc+= SB2->B2_QNPT
				nSldTerc+=SB2->B2_QTER
			else
			    nTotDisp	+=SB2->B2_QATU 
			    nSaldo    	+=SB2->B2_QATU
			EndIf
			dbSelectArea("SB2")
			dbSkip()
		EndDo
		#IFDEF TOP
		EndIf
		#ENDIF
       
       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       //³ Soma Saldos dos Pedidos casados no estoque                             ³
       //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       cQuery2 := "SELECT SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_PRODUTO,SC6.C6_TES,SC6.C6_ITEM,SC6.C6_QTDVEN,SC6.C6_QTDENT,SC6.C6_CLI,SC6.C6_LOJA FROM " 
       cQuery2 += "" + RetSqlName("SC6")+ " SC6 " 
       cQuery2 += "WHERE "
       cQuery2 += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
       cQuery2 += "SC6.C6_PRODUTO= '"+cProduto+"' AND "
       cQuery2 += "SC6.C6_QTDVEN>SC6.C6_QTDENT AND "
       cQuery2 += "SC6.D_E_L_E_T_=' '"
       //cQuery2 := ChangeQuery(cQuery)
       dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery2),"QYSC6",.F.,.T.)
       dbSelectArea("QYSC6")
       While !Eof()
          // precisa verificar empenhO pela tes
   		  if Posicione("SF4",1,xFilial("SF4")+QYSC6->C6_TES,"F4_DUPLIC")="S" .OR. SUBSTR(QYSC6->C6_NUM,1,1)="B" .OR. SUBSTR(QYSC6->C6_NUM,1,1)="D" .OR. SUBSTR(QYSC6->C6_NUM,1,1)="T" .OR. SUBSTR(QYSC6->C6_NUM,1,1)="R" .OR. SUBSTR(QYSC6->C6_NUM,1,1)="A" .OR. QYSC6->C6_TES="514" .OR. QYSC6->C6_TES="999" .OR. QYSC6->C6_TES="693" .OR. QYSC6->C6_TES="553" .OR. QYSC6->C6_TES="592"
   			 	 IF QYSC6->C6_QTDVEN-QYSC6->C6_QTDENT>0
       			nTotDisp:=nTotDisp-QYSC6->C6_QTDVEN-QYSC6->C6_QTDENT
       			IF SUBSTR(QYSC6->C6_NUM,1,1)="B" 
                  cIndice:="OS"
                  cPedRef:="0"+SUBSTR(QYSC6->C6_NUM,2,5)
                ELSE  
                  cIndice:="PV"
                  cPedRef:=QYSC6->C6_NUM
                ENDIF  
       			if Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QYSC6->C6_ITEM,"ZK_OC")<>"      " 
       				cAm1:=Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QYSC6->C6_ITEM,"ZK_OC") 
       				cAm2:=Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QYSC6->C6_ITEM,"ZK_ITEM")
      			    cAm3:=Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QYSC6->C6_ITEM,"ZK_FORN")
       				cAm4:=Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QYSC6->C6_ITEM,"ZK_TIPO2") 
       				cAm5:=Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QYSC6->C6_ITEM,"ZK_STATUS") 
       				cAm6:=Posicione("SZK",1,xFilial("SZK")+cIndice+cPedRef+QYSC6->C6_ITEM,"ZK_QTS") 
       				IF cAm5<>"4" .AND. cAm4="OC" 
         				nTotDisp:=nTotDisp + cAm6 
      				ENDIF
       			endif
    		 ENDIF
  		  ENDIF
  		  dbSkip()
	   EndDo
       dbSelectArea("QYSC6")
       dbCloseArea()
       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
       //³ Abre Pedidos de Venda (processos amarrados a venda                     ³
       //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
       DbSelectArea("SC6")
       dbSetOrder(5)
       MsSeek(xfilial("SC6")+cCliente+cLoja+cProduto)
       // "Data","Orcam","Item","Qtd","Unit","Pzo","Validade"
       While ( !Eof() .And. SC6->C6_PRODUTO == cProduto .and. SC6->C6_CLI==cCliente .AND. SC6->C6_LOJA==cLoja)
	           aAdd(aViewC6,{TRANSFORM(Posicione("SC5",3,xFilial("SC5")+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_NUM,"C5_EMISSAO"),PesqPict("SC6","C6_ENTREG")),;
					TransForm(SC6->C6_NUM,PesqPict("SC6","C6_NUM")),;
					TransForm(SC6->C6_ITEM,PesqPict("SC6","C6_ITEM")),;
					TransForm(SC6->C6_QTDVEN,"@e 9999"),;
					TransForm(SC6->C6_PRCVEN,PesqPict("SC6","C6_PRCVEN")),;
					TransForm(SC6->C6_ENTREG,PesqPict("SC6","C6_ENTREG")),;
					TransForm(SC6->C6_QTDVEN-SC6->C6_QTDENT,"@e 9999")})
	           dbSkip()
	   enddo 
	   DbSelectArea("SCK")
       dbSetOrder(5)
       MsSeek(xfilial("SCK")+cCliente+cLoja+cProduto)
       // "Data","Orcam","Item","Qtd","Unit","Pzo","Validade"
       While ( !Eof() .And. SCK->CK_PRODUTO == cProduto .and. SCK->CK_CLIENTE==cCliente .AND. SCK->CK_LOJA==cLoja)
	           aAdd(aViewCK,{TRANSFORM(Posicione("SCJ",3,xFilial("SCJ")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"CJ_EMISSAO"),PesqPict("SCK","CK_ENTREG")),;
					TransForm(SCK->CK_NUM,PesqPict("SCK","CK_NUM")),;
					TransForm(SCK->CK_ITEM,PesqPict("SCK","CK_ITEM")),;
					TransForm(SCK->CK_QTDVEN,"@e 9999"),;
					TransForm(SCK->CK_PRCVEN,PesqPict("SCK","CK_PRCVEN")),;
					TransForm(SCK->CK_XDIAS,PesqPict("SCK","CK_XDIAS")),;
					TransForm(Posicione("SCJ",3,xFilial("SCJ")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"CJ_VALIDA"),PesqPict("SCK","CK_ENTREG"))})
	           dbSkip()
	   enddo
	If !Empty(aViewB2)
	    DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
		DEFINE MSDIALOG oDlg FROM 000,000  TO 530,600 TITLE "Painel de estoque HCI" Of oMainWnd PIXEL //"Saldos em Estoque"
		@ 023,004 To 24,296 Label "" of oDlg PIXEL
		
		oBmp1 := TBITMAP():Create(oDlg)
        oBmp1:cName := "oBmp1"
        oBmp1:cCaption := "oBmp1"
        oBmp1:nLeft := 500
        oBmp1:nTop := 14
        oBmp1:nWidth := 42
        oBmp1:nHeight := 46
        oBmp1:lShowHint := .F.
        oBmp1:lReadOnly := .F.
        oBmp1:Align := 0
        oBmp1:lVisibleControl := .F.
        DbSelectArea("SB7")
        dbSetOrder(4)
        MsSeek(xfilial("SB7")+cProduto)
        IF ( !Eof() .And. SB7->B7_COD == cProduto )
          oBmp1:lVisibleControl := .t.
          oBmp1:cBmpFile := "\Imagens\ico-bien.bmp"
        ELSE
          oBmp1:lVisibleControl := .t.
          oBmp1:cBmpFile := "\Imagens\mal.bmp"
        ENDIF
        oBmp1:lStretch := .F.
        oBmp1:lAutoSize := .F.
	   	dbSelectArea("SB2")
    	
		@ 002,010 SAY SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+SM0->M0_FILIAL+"/"+SM0->M0_NOME  Of oDlg PIXEL SIZE 245,009
		@ 002,238 SAY "Status Inventario" Of oDlg PIXEL SIZE 245,009
		@ 014,009 SAY Alltrim(cProduto)+ " - "+SB1->B1_DESC Of oDlg PIXEL SIZE 245,009 FONT oBold
		@ 256,255  BUTTON " Voltar   "  SIZE 045,010  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL  //"Voltar"
		oListBox := TWBrowse():New( 30,2,297,69,,{"Local","Q.Disp.Vda","Sd.Fis.","Q.Vendas","Q.Emp.OP","Q.OC","Q.SolArm.","Q.Res.",RetTitle("B2_QTNP"),RetTitle("B2_QNPT"),RetTitle("B2_QTER")},{17,40,40,40,40,40,40,40,40,40,40},oDlg,,,,,,,,,,,,.T.,,.T.,,.T.,,,)  //"Local","Qtd.Disponivel","Sld.Atual","Qtd.Vendas","Qtd.EmpOP","Qtd.Pr.Entr","Qtd.ReqArm.","Qtd.Res."
		oListBox:SetArray(aViewB2)
		oListBox:bLine := { || aViewB2[oListBox:nAT]}
		
		@ 102,03 SAY "TOTAIS" Of oDlg PIXEL SIZE 30 ,9 FONT oBold  //"TOTAL "
		@ 110,004 To 113,296 Label "" of oDlg PIXEL
		@ 115,007 SAY "Qtd. Disp. Vda." of oDlg PIXEL //"Quantidade Disponivel    "
		@ 114,075 MsGet nTotDisp Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 FONT oBold When .F.
		
		@ 115,155 SAY "Quantidade Empenhada " of oDlg PIXEL //"Quantidade Empenhada "
		@ 114,223 MsGet nQemp Picture PesqPict("SB2","B2_QEMP") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 125,007 SAY "Saldo Atual          " of oDlg PIXEL //"Saldo Atual   "
		@ 124,075 MsGet nSaldo Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 125,155 SAY "Qtd. Entrada Prevista" of oDlg PIXEL //"Qtd. Entrada Prevista"
		@ 124,223 MsGet nSalPedi Picture PesqPict("SB2","B2_SALPEDI") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 135,007 SAY "Qtd. Pedido de Vendas" of oDlg PIXEL //"Qtd. Pedido de Vendas  "
		@ 134,075 MsGet nQtPv Picture PesqPict("SB2","B2_QPEDVEN") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 135,155 SAY "Qtd. Reservada       " of oDlg PIXEL //"Qtd. Reservada  "
		@ 134,223 MsGet nReserva Picture PesqPict("SB2","B2_RESERVA") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 145,007 SAY "Qtd. Empenhada S.A.  " of oDlg PIXEL //"Qtd. Empenhada S.A."
		@ 144,075 MsGet nQEmpSA Picture PesqPict("SB2","B2_QEMPSA") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 145,155 SAY RetTitle("B2_QTNP") of oDlg PIXEL
		@ 144,223 MsGet nQtdTerc Picture PesqPict("SB2","B2_QTNP") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 155,007 SAY RetTitle("B2_QNPT") of oDlg PIXEL
		@ 154,075 MsGet nQtdNEmTerc Picture PesqPict("SB2","B2_QNPT") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 155,155 SAY RetTitle("B2_QTER") of oDlg PIXEL 
		@ 154,223 MsGet nSldTerc Picture PesqPict("SB2","B2_QTER") of oDlg PIXEL SIZE 070,009 When .F.
        
        @ 167,03 SAY "HISTORICOS" Of oDlg PIXEL SIZE 45 ,9 FONT oBold  //"TOTAL "
        @ 174,004 To 177,296 Label "" of oDlg PIXEL
        @ 175,03 SAY "COTACOES" Of oDlg PIXEL SIZE 45 ,9   //"TOTAL "
		@ 175,153 SAY "PEDIDOS" Of oDlg PIXEL SIZE 45 ,9   //"TOTAL "
		oListBox1:= TWBrowse():New( 185,2,150,69,,{"Data","Orcam","Item","Qtd","Unit","Pzo","Validade"},{25,20,7,15,30,10,25},oDlg,,,,,,,,,,,,.T.,,.T.,,.T.,,,)  //"Local","Qtd.Disponivel","Sld.Atual","Qtd.Vendas","Qtd.EmpOP","Qtd.Pr.Entr","Qtd.ReqArm.","Qtd.Res."
	    IF !Empty(aViewCK)
	   	  oListBox1:SetArray(aViewCK)
	      oListBox1:bLine := { || aViewCK[oListBox1:nAT]}
		endif
		oListBox2:= TWBrowse():New( 185,152,150,69,,{"Data","Pedido","It","Qtd","Unit","Pzo","Sdo."},  {25,20,7,15,30,25,15},oDlg,,,,,,,,,,,,.T.,,.T.,,.T.,,,)  //"Local","Qtd.Disponivel","Sld.Atual","Qtd.Vendas","Qtd.EmpOP","Qtd.Pr.Entr","Qtd.ReqArm.","Qtd.Res."
		IF !Empty(aViewC6)
		  oListBox2:SetArray(aViewC6)
		  oListBox2:bLine := { || aViewC6[oListBox2:nAT]}
		ENDIF
		nVdNor:=Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_VDANOR")
		nVdMin:=Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_VDAMIN")
		cTabela:=Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_TABELA")
		@ 256,003 SAY "Vda.Normal" of oDlg PIXEL
		@ 255,033 MsGet nVdNor Picture "@E 999999.99" of oDlg PIXEL SIZE 050,009  FONT oBold When .F.
		@ 256,085 SAY "Vda.Minima" of oDlg PIXEL
		@ 255,115 MsGet nVdMin Picture "@E 999999.99" of oDlg PIXEL SIZE 050,009 FONT oBold When .F.
		@ 256,170 SAY "Tabela" of oDlg PIXEL
		@ 255,190 MsGet cTabela Picture "@!" of oDlg PIXEL SIZE 040,009 FONT oBold When .F.
		
		
	
		
		
		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		Aviso("Atencao","Nao ha registro de estoques para este produto.",{"Voltar"},2) //"Atencao"###"Nao registro de estoques para este produto."###"Voltar"
	EndIf	
  EndIf
  RestArea(aAreaSM0)
  RestArea(aAreaSB2)
  RestArea(aAreaSB1) 
  RESTAREA(AAREASC5)
  RESTAREA(AAREASC6)
  RestArea(aArea)   
  // MATC050 
  // MATC030
ENDIF
Return(.T.)    




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AddArray   ³ Autor ³Armando Pereira Waiteman³ Data ³Set/2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Adiciona array mantendo tamanho maximo de elementos por      ³±±
±±³          ³dimensao                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC030                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AddArray(aItem)

aAdd(aTrbTmp, aItem)

If Len(aTrbTmp) >= 65000
	AADD(aTrbp,aTrbtmp)
	aTrbTmp:= {}
EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MC030Data  ³ Autor ³Marcelo Iuspa          ³ Data ³Set/2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem a data a partir do dos arrays aTrbTmp e aTrbP         ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATC030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MC030Data(cAlias)
Local dData
Default cAlias := Nil
If mv_par04==1 .And. Len(aTrbTmp) == 0
	dData := aTrbP  [Len(aTrbp)]  [Len(aTrbp[Len(aTrbP)])-1] [1]
ElseIf mv_par04==1 .And. Len(aTrbTmp) == 1
	dData := aTrbP  [Len(aTrbp)]  [Len(aTrbp[Len(aTrbP)])-0] [1]
ElseIf mv_par04==2 .And. Len(aTrbTmp) == 0
	dData := aTrbP  [Len(aTrbp)]  [Len(aTrbp[Len(aTrbP)])-0] [1]
ElseIf mv_par04==2 .And. Len(aTrbTmp) == 1
	dData:=aTrbTmp[Len(aTrbTmp)] [1]
Else 
	dData:=aTrbTmp[Len(aTrbTmp)-If(mv_par04==1,1,0)][1]
Endif
If mv_par06 == 1
    If cAlias == "SD1"
       dData := SD1->D1_DTDIGIT
    ElseIf cAlias == "SD2"
       dData := SD2->D2_EMISSAO   
    ElseIf cAlias == "SD3"
       dData := SD3->D3_EMISSAO   
    Endif	
EndIf
	
Return(dData)

