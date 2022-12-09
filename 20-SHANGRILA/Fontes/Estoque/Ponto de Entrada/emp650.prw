#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ EMP650   ³ Autor ³ GENILSON LUCAS      	³ Data ³ 24/06/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada para verificar se existe MP disponível.	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Shangri-la                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Emp650()

Local nPosProdOri	:= SC2->C2_PRODUTO
Local nOP			:= SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
Local nPosProd  	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "G1_COMP"})
Local nPosArmaz 	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D4_LOCAL"}) 
Local nPosQuant		:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D4_QUANT"})
Local nPosDescri	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B1_DESC"})
Local _aArea      := GetArea()

//Local nPosTRT   	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "G1_TRT"})
//Local nPosNLote  	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D4_NUMLOTE"})
//Local nPosLoteCTL  	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D4_LOTECTL"})
//Local nPosDTValid 	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D4_DTVALID"})
//Local nPosPotenci 	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D4_POTENCI"})
//Local nPosLocaliz 	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "DC_LOCALIZ"})
//Local nPosNumSer 	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "DC_NUMSERI"})
//Local nPosUM 		:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B1_UM"})
//Local nPosQtSegUM	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D4_QTSEGUM"})
//Local nPosSegUM		:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "B1_SEGUM"})
                            
Local	cMP				:= ""
Local 	lGeraMSG		:= .F.   
local 	nI				:= 0

Public	_nProduto
Public 	_nArmazem

For nI := 1 To Len(aCols)
	
	nSaldo	:= 0
	
	//Carrego saldo atual do componente sem os empenhos
	DbSelectArea("SB2")
	DbSetOrder(1)
	DbSeek(xFilial("SB2") + aCols[nI,nPosProd] ) 
	
	While !Eof() .and. aCols[nI,nPosProd] = SB2->B2_COD
		
		nSaldo += SaldoSB2()
		
		DbSkip()
	End
	
	//DbSeek(xFilial("SB2") + aCols[nI,nPosProd] )
		
	If nSaldo < aCols[nI,nPosQuant] .and.;
			 posicione("SB1",1,xFilial("SB1")+padr(aCols[nI,nPosProd],tamSX3("B1_COD")[1]),"B1_TIPO")<>"MO"
			 
		cMP			+= alltrim(aCols[nI,nPosProd]) + ", " 
		lGeraMSG	:= .T.  	
	Endif
	
Next nI

If lGeraMSG
	
	Msgalert("Não existe saldo suficiente da(s) MP(s) " + cMP +" para atender a OP " + nOP)
	
	For nI := 1 To Len(aCols)
	
		nSaldo	:= 0
		
		//Carrego saldo atual do componente sem os empenhos
		DbSelectArea("SB2")
		DbSetOrder(1)
		DbSeek(xFilial("SB2") + aCols[nI,nPosProd] ) 
		
		While !Eof() .and. aCols[nI,nPosProd] = SB2->B2_COD
			
			nSaldo += SaldoSB2()
			
			DbSkip()
		End
		
		//DbSeek(xFilial("SB2") + aCols[nI,nPosProd] )
				
		If nSaldo < aCols[nI,nPosQuant] .and.;
			 posicione("SB1",1,xFilial("SB1")+padr(aCols[nI,nPosProd],tamSX3("B1_COD")[1]),"B1_TIPO")<>"MO"
			  	
			_nProduto 	:= aCols[nI,nPosProd]
			_nArmazem	:= aCols[nI,nPosArmaz]
			
			A440STK()	
		Endif
	Next nI        
EndIf

// Matheus Abrão / Totvs 13/10/2016
//		Alteração do Armazem
if "P" $ upper(SC2->C2_LOCAL)
	for nI := 1 to len(aCols)
		//se for mão de obra
		if "MOD" $ upper(aCols[nI,nPosProd])
			aCols[nI,nPosArmaz] := "P1" // Chumbado P1 a pedido do cliente Norberto
		endif
	next
endif


// Fim

RestArea(_aArea)
Return()          
        

Static Function A440STK()

Local aArea		:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSM0	:= SM0->(GetArea())
Local aViewB2	:= {}
Local aStruSB2  := {}
Local aNewSaldo := {}
Local oCursor	:= LoadBitMap(GetResources(),"LBNO")
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
Local nAtIni    := 1
Local oListBox, oDlg, oBold

Static lViewSB2PE
Static lViewSaldo

If ValType(lViewSB2PE) # "L"
	lViewSB2PE	:= ExistBlock("MVIEWSB2SL")
EndIf

If ValType(lViewSaldo) # "L"
	lViewSaldo	:= ExistBlock("MVIEWSALDO")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para impedir a apresentacao da Dialog de Saldos do SB2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MTVIEWB2")
	lViewSB2 := ExecBlock("MTVIEWB2",.F.,.F.)
EndIf

cFilialSB2 := xFilial("SB2")
cFilialSB1 := xFilial("SB1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o cadastro de produtos                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('SB1')
dbSetOrder(1)

cProduto	:= _nProduto //aCols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})]
cAlmox 		:= _nArmazem //aCols[n][aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})]

If MsSeek(cFilialSB1+cProduto) .And. lViewSB2
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			cCursor  := "MAVIEWSB2"
			lQuery   := .T.
			aStruSB2 := SB2->(dbStruct())		
			
			cQuery := ""
			cQuery += "SELECT * FROM "+RetSqlName("SB2")+" WHERE "
			cQuery += "B2_FILIAL='"+cFilialSB2+"' AND "
			cQuery += "B2_COD='"+cProduto+"' AND "
			cQuery += "B2_STATUS <> '2' AND "
			//cQuery += "B2_LOCAL = '01' AND "
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
		Else
	#ENDIF
		dbSelectArea("SB2")
		dbSetOrder(1)
		MsSeek(cFilialSB2+cProduto)
		While !Eof() .And. cFilialSB2+cProduto == SB2->B2_FILIAL+SB2->B2_COD .and. SB2->B2_LOCAL == "01"
			If !(SB2->B2_STATUS=='2')
				nSaldoSB2:=SaldoSB2(,,,,,"SB2")
				// Executa o ponto de entrada para alterar o saldo disponivel pelo usuario
				If lViewSB2PE
					nTotExecDisp:=ExecBlock("MVIEWSB2SL",.F.,.F.,{SB2->B2_COD,SB2->B2_LOCAL,nSaldoSB2})
					If ValType(nTotExecDisp) == "N"
						nSaldoSB2 := nTotExecDisp		
					EndIf
				EndIf		

				nB2_QATU    := SB2->B2_QATU
				nB2_QPEDVEN := SB2->B2_QPEDVEN
				nB2_QEMP    := SB2->B2_QEMP
				nB2_SALPEDI := SB2->B2_SALPEDI
				nB2_QEMPSA  := SB2->B2_QEMPSA
				nB2_RESERVA := SB2->B2_RESERVA
				nB2_QTNP    := SB2->B2_QTNP
				nB2_QNPT    := SB2->B2_QNPT
				nB2_QTER    := SB2->B2_QTER
				nB2_QEMPN   := SB2->B2_QEMPN
				nB2_QACLASS := SB2->B2_QACLASS
				nB2_QPRJ    := SB2->B2_QEMPPRJ
				nB2_QPRE    := SB2->B2_QEMPPRE
				
				If lViewSaldo
					aNewSaldo := {}
					aAdd(aNewSaldo,{nSaldoSB2,nB2_QATU,nB2_QPEDVEN,nB2_QEMP,nB2_SALPEDI,nB2_QEMPSA,nB2_RESERVA,nB2_QTNP,;
					                nB2_QNPT,nB2_QTER,nB2_QEMPN,nB2_QACLASS,nB2_QPRJ,nB2_QPRE})				
					
					If ValType(aNewSaldo:=ExecBlock("MVIEWSALDO",.F.,.F.,{SB2->B2_COD,SB2->B2_LOCAL,aNewSaldo}))=="A" .And. Len(aNewSaldo) > 0
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

				aAdd(aViewB2,{TransForm(SB2->B2_LOCAL,PesqPict("SB2","B2_LOCAL")),;
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
					
				If !Empty(cAlmox) .And. cAlmox == SB2->B2_LOCAL
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
			EndIf	
			dbSelectArea("SB2")
			dbSkip()
		EndDo
		#IFDEF TOP
		EndIf
		#ENDIF
	If !Empty(aViewB2)
		
		DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
		DEFINE MSDIALOG oDlg FROM 000,000  TO 500,600 TITLE "Saldos em Estoque" Of oMainWnd PIXEL //"Saldos em Estoque"
		@ 023,004 To 24,296 Label "" of oDlg PIXEL
		@ 113,004 To 114,296 Label "" of oDlg PIXEL
		oListBox := TWBrowse():New( 30,2,297,69,,{"Local","Qtd.Disponivel","Sld.Atual","Qtd.Pedido de Vendas","Qtd. Empenhada","Qtd. Prevista Entrada","Qtd.Empenhada S.A.","Qtd. Reservada",RetTitle("B2_QTNP"),RetTitle("B2_QNPT"),RetTitle("B2_QTER"),RetTitle("B2_QEMPN"),RetTitle("B2_QACLASS"),RetTitle("B2_QEMPPRJ"),RetTitle("B2_QEMPPRE")},{17,55,55,55,55,55,55,55},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)  //"Local"###"Qtd.Disponivel"###"Sld.Atual"###"Qtd.Pedido de Vendas"###"Qtd. Empenhada"###"Qtd. Prevista Entrada"###"Qtd.Empenhada S.A."###"Qtd. Reservada"
		oListBox:SetArray(aViewB2)
		oListBox:bLine := { || aViewB2[oListBox:nAT]}
		oListBox:nAt   := 1 //Max(1,nAtIni)
		@ 004,010 SAY SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+SM0->M0_FILIAL+"/"+SM0->M0_NOME  Of oDlg PIXEL SIZE 245,009
		@ 014,010 SAY Alltrim(cProduto)+ " - "+SB1->B1_DESC Of oDlg PIXEL SIZE 245,009 FONT oBold
		@ 104,010 SAY "TOTAL" Of oDlg PIXEL SIZE 30 ,9 FONT oBold  //"TOTAL "
		
		@ 120,007 SAY "Quantidade Disponivel    " of oDlg PIXEL //"Quantidade Disponivel    "
		@ 119,075 MsGet nTotDisp Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 120,155 SAY "Quantidade Empenhada " of oDlg PIXEL //"Quantidade Empenhada "
		@ 119,223 MsGet nQemp Picture PesqPict("SB2","B2_QEMP") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 135,007 SAY "Saldo Atual   " of oDlg PIXEL //"Saldo Atual   "
		@ 134,075 MsGet nSaldo Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 135,155 SAY "Qtd. Entrada Prevista" of oDlg PIXEL //"Qtd. Entrada Prevista"
		@ 134,223 MsGet nSalPedi Picture PesqPict("SB2","B2_SALPEDI") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 150,007 SAY "Qtd. Pedido de Vendas  " of oDlg PIXEL //"Qtd. Pedido de Vendas  "
		@ 149,075 MsGet nQtPv Picture PesqPict("SB2","B2_QPEDVEN") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 150,155 SAY "Qtd. Reservada  " of oDlg PIXEL //"Qtd. Reservada  "
		@ 149,223 MsGet nReserva Picture PesqPict("SB2","B2_RESERVA") of oDlg PIXEL SIZE 070,009 When .F.
		
		@ 165,007 SAY "Qtd. Empenhada S.A." of oDlg PIXEL //"Qtd. Empenhada S.A."
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

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para incluir Botao do Usuario na Dialog Saldos do SB2 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("BVIEWSB2") 
			@ 230,190 BUTTON "Especifico" SIZE 045,010  FONT oDlg:oFont ACTION (ExecBlock("BVIEWSB2",.F.,.F.)) Of oDlg PIXEL //"Especifico"
		Endif
		
		@ 230,244  BUTTON "Voltar" SIZE 045,010  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL  //"Voltar"

		ACTIVATE MSDIALOG oDlg CENTERED
	Else
		Aviso("Atencao","Nao ha registro de estoque para este produto",{"Voltar"},2) //"Atencao"###"Nao registro de estoques para este produto."###"Voltar"
	EndIf	
EndIf
RestArea(aAreaSM0)
RestArea(aAreaSB2)
RestArea(aAreaSB1)
RestArea(aArea)
Return(.T.)