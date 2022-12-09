#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"
#INCLUDE 'COLORS.CH'

#Define CARGA_LEGEND	001
#Define CARGA_MARCAS	002
#Define CARGA_DTENTR	003
#Define CARGA_QTAPRD	004
#Define CARGA_QTEPRD	005
#Define CARGA_CAPACI	006
#Define CARGA_SALDOS	007
#Define CARGA_DATAEN	008
#Define CARGA_SLDPAI	009
#Define CARGA_CAPPAI	010


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CALCPESO Autor ³ Luiz Alberto        ³ Data ³ 03/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Funcao responsavel pelo preenchimento dos campos         ±±
				   de Peso Bruto e Peso Liquido do Pedido de Vendas
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ METALACRE                                        ³±±
±±                                                                        ³±±
±±                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
User Function Calc2Prod()
Local aArea := GetArea()
Private    oOk		 := LoadBitmap(GetResources(),"LBTIK")
Private    oNo  	 := LoadBitmap(GetResources(),"LBNO")
Private  oSinalNo    := LoadBitmap(GetResources(),"BR_VERMELHO")
Private  oSinalOk    := LoadBitmap(GetResources(),"BR_VERDE")
Private  oSinalSi    := LoadBitmap(GetResources(),"BR_AZUL")
Private oCargaFabrica
Private oRcp5

GetDRefresh()

dEntrega := dDataBase+1
nQtdTira := 0.00
nQtdUso  := 0.00

If cEmpAnt <> '01'
	Return .T.
Endif

If IsInCallStack("MATA410") .Or. Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" } ) > 0
	If !Empty(M->C5_PEDWEB)
		Return .t.
	Endif
	nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" } )
	nPosQtde := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_QTDVEN" } )
	nPosEntr := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_ENTREG" } )
	nPosItem := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_ITEM" } )
	dEntrega := Iif(Type("M->C6_ENTREG")<>"U",M->C6_ENTREG,aCols[n,nPosEntr])
	cProduto := Iif(Type("M->C6_PRODUTO")<>"U",M->C6_PRODUTO,aCols[n,nPosProd])
	nQuant   := Iif(Type("M->C6_QTDVEN")<>"U"  ,M->C6_QTDVEN,aCols[n,nPosQtde])        
	If Altera       
		If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+M->C5_NUM+aCols[n,nPosItem]+aCols[n,nPosProd]))
			If Empty(SC6->C6_NUMOP)	            // Se Nao Gerou OP Entao Quantidade a Produzir
				nQtdTira := SC6->C6_QTDVEN
			Else
				nQtdUso := SC6->C6_QTDVEN		// Se Gerou OP Quantidade em Producao
			Endif
		Endif
	Endif
ElseIf IsInCallStack("TMKA271") 
	nPosItem := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_ITEM" } )
	nPosProd := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_PRODUTO" } )
	nPosQtde := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_QUANT" } )
	nPosEntr := Ascan( aHeader, { |x| Alltrim(x[2]) == "UB_DTENTRE" } )
	dEntrega := Iif(Type("M->UB_DTENTRE")<>"U",M->UB_DTENTRE,aCols[n,nPosEntr])
	cProduto := Iif(Type("M->UB_PRODUTO")<>"U",M->UB_PRODUTO,aCols[n,nPosProd])
	nQuant   := Iif(Type("M->UB_QUANT")<>"U"  ,M->UB_QUANT  ,aCols[n,nPosQtde])        
	
	If !Empty(M->UA_NUMSC5)	// Foi Gerado Pedido Entao e uma Alteracao
		If SUB->(dbSetOrder(1), dbSeek(xFilial("SUB")+M->UA_NUM+aCols[n,nPosItem]+aCols[n,nPosProd]))
			If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+M->UA_NUMSC5+SUB->UB_ITEMPV+aCols[n,nPosProd]))
				If Empty(SC6->C6_NUMOP)
					nQtdTira := SC6->C6_QTDVEN
				Else
					nQtdUso := SC6->C6_QTDVEN
				Endif
			Endif
		Endif
	Endif		
ElseIf IsInCallStack("MATA650") 
	If M->C2_XOP == '1'
		Return .t.
	Endif
	dEntrega := M->C2_DATPRF
	cProduto := M->C2_PRODUTO
	nQuant   := M->C2_QUANT
ElseIf ProcName(12)$'U_TRMA03PREC'
	dEntrega := aCols[n, aScan(aHeader,{|x|AllTrim(x[2])=="C2_DATPRF"   }) ]
	cProduto := aCols[n, aScan(aHeader,{|x|AllTrim(x[2])=="C2_PRODUTO"   }) ]
	nQuant   := aCols[n, aScan(aHeader,{|x|AllTrim(x[2])=="C2_QUANT"   }) ]
	If Altera       
		nQtdUso := SC2->C2_QUANT
	Endif
Endif

// Quantidade de Dias a Pular
// Se For Após Meio dia Então Pula 6 dias

dLimite := dDataBase

nTotDias	:= Iif(Left(Time(),5)<='12:00',5,6)
While nTotDias > 0 .And. !GetNewPAR("MV_MTLEFDS",.T.)	// Bloqueia Entregas aos Fins de Semana .F. Não Libera .T. Libera
	If Dow(dLimite) <> 1 .And. Dow(dLimite) <> 7	// Nao é Sab nem Domingo
		dLimite++
		nTotDias--
	ElseIf Dow(dLimite) == 1 .Or. Dow(dLimite) == 7
		dLimite++
	Endif        
Enddo

dInicio	:= Iif(!Empty(dEntrega),dEntrega,dLimite)

// Montando Datas Disponiveis

SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProduto))
SBM->(dbSetOrder(1), dbSeek(xFilial("SBM")+SB1->B1_GRUPO))

// Validação será executada Apenas em geração 
If IsInCallStack("MATA410") .Or. IsInCallStack("TMKA271") 
	If dInicio < dLimite
		Alert("Atenção a Data da Entrega Deverá ser Igual ou Superior a " + Iif(Left(Time(),5)<='12:00','5','6') + " Dias Úteis ! - Data Ideal: " + DtoC(dLimite) + " !")
		Return .T.
	Endif
	If dInicio < dDataBase
		Alert("Atenção a Data da Entrega Não Pode Ser Inferior a Data Atual !")
		Return .F.
	Endif
Endif

// Verifica se é feriado

If SP3->(dbSetOrder(2), dbSeek(xFilial("SP3")+StrZero(Month(dInicio),2)+StrZero(Day(dInicio),2))) .And. SP3->P3_FIXO == 'S'
	MsgStop("Atenção dia " + DtoC(dInicio) + " Trata-se de Feriado (" + AllTrim(Capital(SP3->P3_DESC)) + "), Impossivel Agendar Entregas !")
	Return .f.
Else
	If SP3->(dbSetOrder(1), dbSeek(xFilial("SP3")+DtoS(dInicio))) .And. SP3->P3_FIXO == 'N'
		MsgStop("Atenção dia " + DtoC(dInicio) + " Trata-se de Feriado (" + AllTrim(Capital(SP3->P3_DESC)) + "), Impossivel Agendar Entregas !")
		Return .f.
	Endif
Endif

SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProduto))
	
cGrupoProd	:= Iif(!Empty(SB1->B1_XGRUPO),SB1->B1_XGRUPO,SB1->B1_GRUPO)

SBM->(dbSetOrder(1), dbSeek(xFilial("SBM")+cGrupoProd))

cQuery:= " SELECT ZH_DATA, ZH_GRUPO, ZH_CAPGRP, ZH_GRPUSO, ZH_SLDGRP, ZH_GRPAPR "
cQuery+= " FROM " + RetSqlName("SZH") + " ZH "
cQuery+= " INNER JOIN " + RetSqlName("SBM") + " BM "
cQuery+= " ON BM_GRUPO = ZH_GRUPO AND BM.D_E_L_E_T_ = '' "
cQuery+= " WHERE ZH_DATA >= '" + DtoS(dInicio) + "'"
cQuery+= " AND ZH_GRUPO = '" + cGrupoProd + "' "
cQuery+= " ORDER BY ZH_DATA, ZH_GRUPO " +CRLF   

DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'TMPSZH', .F., .T. )
  
TcSetField("TMPSZH","ZH_DATA","D",8,0)

Count To nReg

dbSelectArea("TMPSZH")
dbGoTop()    
ProcRegua(nReg)
lConfirma := .f.	
aCarga	:= {}            
While TMPSZH->(!Eof())
	If !GetNewPAR("MV_MTLEFDS",.T.)	// Bloqueia Entregas aos Fins de Semana .F. Não Libera .T. Libera
		If Dow(TMPSZH->ZH_DATA) == 1 .Or. Dow(TMPSZH->ZH_DATA) == 7
			TMPSZH->(dbSkip(1));Loop
		Endif        

		// Verifica se é feriado
		
		If SP3->(dbSetOrder(2), dbSeek(xFilial("SP3")+StrZero(Month(TMPSZH->ZH_DATA),2)+StrZero(Day(TMPSZH->ZH_DATA),2))) .And. SP3->P3_FIXO == 'S'
			TMPSZH->(dbSkip(1));Loop
		Else
			If SP3->(dbSetOrder(1), dbSeek(xFilial("SP3")+DtoS(TMPSZH->ZH_DATA))) .And. SP3->P3_FIXO == 'N'
				TMPSZH->(dbSkip(1));Loop
			Endif
		Endif
		
	Endif

	nSaldoPai := 0.00
	cGrupoPai := PadR(Left(TMPSZH->ZH_GRUPO,3),4)
	nCapacPai := 0.00
	If SZH->(dbSetOrder(2), dbSeek(xFilial("SZH")+cGrupoPai+DtoS(TMPSZH->ZH_DATA)))
		nSaldoPai	:=	SZH->ZH_SLDGRP
		nCapacPai	:=	SZH->ZH_CAPGRP
	Endif
			
	IncProc("Aguarde Localizando Datas de Entregas Disponiveis")
	
	nAchou := Ascan(aCarga,{|x| x[3]==DtoC(TMPSZH->ZH_DATA)})
	If Empty(nAchou)                    
		If TMPSZH->ZH_DATA == dEntrega .And. Altera
			nAprod	:=	TMPSZH->ZH_GRPAPR-nQtdTira+nQuant
			nUsado	:=  TMPSZH->ZH_GRPUSO-nQtdUso+Iif(!Empty(nQtdUso),nQuant,0)
		    nSaldo  :=	TMPSZH->ZH_CAPGRP-(nAProd+nUsado)
		    
			AAdd(aCarga,{oOk,;
						'2',;
						DtoC(TMPSZH->ZH_DATA),;
						nAprod,;						
						nUsado,;						
						TMPSZH->ZH_CAPGRP,;
						nSaldo,;
						TMPSZH->ZH_DATA,;
						nSaldoPai,;
						nCapacPai})
		
		Else		
			AAdd(aCarga,{oOk,;
						'2',;
						DtoC(TMPSZH->ZH_DATA),;
						TMPSZH->ZH_GRPAPR,;						
						TMPSZH->ZH_GRPUSO,;						
						TMPSZH->ZH_CAPGRP,;
						TMPSZH->ZH_SLDGRP,;
						TMPSZH->ZH_DATA,;
						nSaldoPai,;
						nCapacPai})
		Endif
	Endif

	TMPSZH->(dbSkip(1))
Enddo
TMPSZH->(dbCloseArea())
	
dDtInic := dInicio
dDtFim	:= dInicio+30
SBM->(dbSetOrder(1), dbSeek(xFilial("SBM")+cGrupoProd))

nCargaDia	:= SBM->BM_CAPDIA

While dDtInic <= dDtFim
	If !GetNewPAR("MV_MTLEFDS",.T.)	// Bloqueia Entregas aos Fins de Semana .F. Não Libera .T. Libera
		If Dow(dDtInic) == 1 .Or. Dow(dDtInic) == 7
			dDtInic++;Loop
		Endif        

		// Verifica se é feriado
		
		If SP3->(dbSetOrder(2), dbSeek(xFilial("SP3")+StrZero(Month(dDtInic),2)+StrZero(Day(dDtInic),2))) .And. SP3->P3_FIXO == 'S'
			dDtInic++;Loop
		Else
			If SP3->(dbSetOrder(1), dbSeek(xFilial("SP3")+DtoS(dDtInic))) .And. SP3->P3_FIXO == 'N'
				dDtInic++;Loop
			Endif
		Endif
		
	Endif

    nSaldoPai := 0.00
			
	nAchou := Ascan(aCarga,{|x| x[3] == DtoC(dDtInic)}) // .And. x[4] == cProduto
	If Empty(nAchou)
	    cGrupoPai := PadR(Left(cGrupoProd,3),4)
	    nCapacPai := 0.00
		If SZH->(dbSetOrder(2), dbSeek(xFilial("SZH")+cGrupoPai+DtoS(dDtInic)))
			nSaldoPai	:=	SZH->ZH_SLDGRP
			nCapacPai   :=  SZH->ZH_CAPGRP
		Endif

		AAdd(aCarga,{oOk,;
						'2',;
						DtoC(dDtInic),;
						0,;		
						0,;				
						nCargaDia,;
						nCargaDia,;
						dDtInic,;
						nSaldoPai,;
						nCapacPai})
	Endif
	
	dDtInic	:= DataValida(++dDtInic,.t.)
Enddo
RestArea(aArea)
                          

aSort(aCarga,,, { |x,y| DTOS(y[CARGA_DATAEN]) > DTOS(x[CARGA_DATAEN]) } )      

// Calcula Totais
nTotaProduzi	:= 0.00
nToteProduzi	:= 0.00
nTotCapacDia	:= 0.00
nSaldoAtual		:= 0.00    
nSaldoPai		:= 0.00

For nE := 1 To Len(aCarga)
	nTotaProduzi	+=	aCarga[nE,CARGA_QTAPRD]
	nToteProduzi	+=	aCarga[nE,CARGA_QTEPRD]
	nTotCapacDia	+=	aCarga[nE,CARGA_CAPPAI]
	nSaldoAtual		+=	aCarga[nE,CARGA_SALDOS]
	nSaldoPai		+=	aCarga[nE,CARGA_SLDPAI]
Next

If Empty(Len(aCarga))
	MsgAlert("Atenção Não Existem Entregas Disponiveis para Este Produto !")
	RestArea(aArea)
	Return .t.
Endif

If Type("l650Auto") == "U"
	l650Auto := .f.
Endif

If !l650Auto	// Se Estiver sendo Executado ExecAuto Então Não Processa
	
	DEFINE MSDIALOG oRcp5 TITLE "Seleção Datas Entregas  - Grupo/SubGrupo: " + AllTrim(SB1->B1_GRUPO)+'/'+AllTrim(SB1->B1_XGRUPO) + " - Produto: " + AllTrim(SB1->B1_COD) + ' ' + Alltrim(SB1->B1_DESC) + " Qtde Produzir: " + TransForm(nQuant,"@E 999,999,999.999") FROM 000, 000  TO 350, 760 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME 
	oRcp5:lEscClose := .F. //Não permite sair ao usuario se precionar o ESC
	
	@ 010, 005 LISTBOX oCargaFabrica Fields HEADER '','',"Dt.Entrega",'Qtd a Produzir','Qtd em Producao','Capac.Diaria','Saldo','Saldo Pai' SIZE 380, 140 OF oRcp5 PIXEL //ColSizes 50,50
	
	oCargaFabrica:SetArray(aCarga)
	oCargaFabrica:bLine := {|| {	Iif(aCarga[oCargaFabrica:nAt,CARGA_MARCAS]=="1",oSinalOk,Iif(nQuant<=aCarga[oCargaFabrica:nAt,CARGA_SLDPAI] .And. aCarga[oCargaFabrica:nAt,CARGA_SLDPAI]>0,oSinalSi,oSinalNo)),;
    								Iif(aCarga[oCargaFabrica:nAt,CARGA_MARCAS]=="1",oOk,oNo),;
        							aCarga[oCargaFabrica:nAt,CARGA_DTENTR],;
						      		TransForm(aCarga[oCargaFabrica:nAt,CARGA_QTAPRD],'@E 9,999,999.999'),;
						      		TransForm(aCarga[oCargaFabrica:nAt,CARGA_QTEPRD],'@E 9,999,999.999'),;
						      		TransForm(aCarga[oCargaFabrica:nAt,CARGA_CAPACI],'@E 9,999,999.999'),;
						      		TransForm(aCarga[oCargaFabrica:nAt,CARGA_SALDOS],'@E 9,999,999.999'),;
						      		TransForm(aCarga[oCargaFabrica:nAt,CARGA_SLDPAI],'@E 9,999,999.999')}}

	oCargaFabrica:bLDblClick := {||DblClick(oCargaFabrica:nAt,nQuant)}
	
	nOpc := 0
		
	//@ 180,050 BUTTON "Confirma"		  		SIZE 50,15 ACTION (nOpc:=1, Close(oRcp5))
			
	@ 160, 010 BUTTON oBotaoCnf PROMPT "&Selecionar" 			ACTION (Close(oRcp5),nOpc:=1) SIZE 060, 010 OF oRcp5 PIXEL
	@ 160, 070 BUTTON oBotaoCan PROMPT "&Cancelar" 				ACTION (Close(oRcp5),nOpc:=0) SIZE 060, 010 OF oRcp5 PIXEL
	
	@ 155,150 SAY "Total a Prod"   	SIZE 80,10 COLOR CLR_BLUE,CLR_WHITE OF oRcp5 PIXEL 
	@ 155,200 SAY "Total em Prod"   	SIZE 80,10 COLOR CLR_BLUE,CLR_WHITE OF oRcp5 PIXEL 
	@ 155,250 SAY "Total Cap.Dia"   SIZE 80,10 COLOR CLR_BLUE,CLR_WHITE OF oRcp5 PIXEL 
	@ 155,300 SAY "Saldo Atual"   	SIZE 80,10 COLOR CLR_BLUE,CLR_WHITE OF oRcp5 PIXEL 
	
	@ 165,150 SAY oObj0 VAR nTotaProduzi Picture '@E 9,999,999.999' SIZE 60,15 COLOR CLR_GREEN,CLR_WHITE  OF oRcp5 PIXEL 
	@ 165,200 SAY oObj1 VAR nToteProduzi Picture '@E 9,999,999.999' SIZE 60,15 COLOR CLR_GREEN,CLR_WHITE  OF oRcp5 PIXEL 
	@ 165,250 SAY oObj2 VAR nTotCapacDia Picture '@E 9,999,999.999' SIZE 60,15 COLOR CLR_GREEN,CLR_WHITE  OF oRcp5 PIXEL 
	If (nSaldoAtual - nQuant) > 0.00
		@ 165,300 SAY oObj3 VAR nSaldoPai  Picture '@E 9,999,999.999' SIZE 60,15 COLOR CLR_GREEN,CLR_WHITE  OF oRcp5 PIXEL 
	Else	
		@ 165,300 SAY oObj3 VAR nSaldoPai  Picture '@E 9,999,999.999' SIZE 60,15 COLOR CLR_RED,CLR_WHITE  OF oRcp5 PIXEL 
	Endif
	
	oObj0:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	oObj1:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	oObj2:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
	oObj3:oFont := TFont():New('Arial',,18,,.T.,,,,.T.,.F.)
		
	
	ACTIVATE MSDIALOG oRcp5 CENTERED //ON INIT EnchoiceBar(oRcp,{||If(oGet:Tud_oOk(),_nOpca:=1,_nOpca:=0)},{||oRcp:End()})
		
	dRetorno	:= CtoD('')
	If nOpc == 1
		For nI := 1 To Len(aCarga)
			If aCarga[nI,CARGA_MARCAS] == '1' //.And. nQuant <= aCarga[nI,9]
				dRetorno := CtoD(aCarga[nI,CARGA_DTENTR])
				Exit
			Endif
		Next 
	Endif
	If IsInCallStack("TMKA271") 
		If Type("M->UB_DTENTRE")<>"U"
			M->UB_DTENTRE	:= dRetorno
		Else
			aCols[n,nPosEntr] := dRetorno
		Endif
	ElseIf IsInCallStack("MATA410") .Or. Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" } ) > 0
		If Type("M->C6_ENTREG")<>"U"
			M->C6_ENTREG	:= dRetorno
		Else
			aCols[n,nPosEntr] := dRetorno
		Endif
	ElseIf IsInCallStack("MATA650") 
		M->C2_DATPRF	:= dRetorno
	Endif
Else                               
	M->C2_DATPRF	:= dEntrega
Endif
GetDRefresh()
Return .t.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DblClick³ Autor ³ Luiz Alberto        ³ Data ³ 06/12/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao Responsavel pelo Double Click Tela Rotas ³±±
±±³          |                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function dblClick(nPos,nQuant)
Local aArea := GetArea()

dDtSel	:=	CtoD(aCarga[nPos,CARGA_DTENTR])

If nQuant > aCarga[nPos,CARGA_SALDOS] .Or. nQuant > aCarga[nPos,CARGA_SLDPAI]
	Alert("Data da Entrega Não Disponivel, pois irá ultrapassar capacidade diária !")
	If !__cUserId $ GetNewPar("MV_XLIBCGF",'000000') // Usuarios Liberados para Selecionar Carga Fabrica Sem Saldo
		Return .F. //Por Enquanto Vai deixar Selecionar.
	Endif
Endif

If !GetNewPAR("MV_MTLEFDS",.T.)	// Bloqueia Entregas aos Fins de Semana .F. Não Libera .T. Libera
	If Dow(dDtSel) == 1 .Or. Dow(dDtSel) == 7
		Alert("Data da Entrega Não Pode Ser Aos Fins de Semana e Feriados !")
		Return .F.
	Endif        

	// Verifica se é feriado
		
	If SP3->(dbSetOrder(2), dbSeek(xFilial("SP3")+StrZero(Month(dDtSel),2)+StrZero(Day(dDtSel),2))) .And. SP3->P3_FIXO == 'S'
		Alert("Data da Entrega Não Pode Ser Aos Fins de Semana e Feriados !")
		Return .F.
	Else
		If SP3->(dbSetOrder(1), dbSeek(xFilial("SP3")+DtoS(dDtSel))) .And. SP3->P3_FIXO == 'N'
			Alert("Data da Entrega Não Pode Ser Aos Fins de Semana e Feriados !")
			Return .F.
		Endif
	Endif
Endif

If aCarga[nPos,CARGA_MARCAS]=="1"
	aCarga[nPos,CARGA_MARCAS]:="2"
Else

	aCarga[nPos,CARGA_MARCAS]:="1"
	For nI := 1 To Len(aCarga)
		If nI <> nPos
			aCarga[nI,CARGA_MARCAS] := '2'
		Endif
	Next
Endif 
oCargaFabrica:Refresh()
oRcp5:Refresh()
Return .t.
