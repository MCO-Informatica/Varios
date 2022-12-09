#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

#DEFINE MARCA 		001
#DEFINE CONTRATO	002
#DEFINE ULTCOM		003
#DEFINE CODIGO		004
#DEFINE LOJA		005
#DEFINE NOME		006
#DEFINE MENSALID	007
#DEFINE CODSERV		008
#DEFINE SERVICO		009
#DEFINE TES 		010
#DEFINE DESCTES		011
#DEFINE MSGNFSE		012
#DEFINE REGISTRO	013
#DEFINE VENCIMENTO	014

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FatAuto           ºAutor ³Luiz Albertoº Data ³  31/03/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento Automatico - Contratos   	                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³ MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ NITIDEZ  ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FatAuto()
Local aArea := GetArea()
Private cPerg		:= PadR("LTFAT",10)
Private cSerieNF	:= 'E  '
Private dDtRef := MonthSub(dDataBase,1)
Private cMsgRef := ' Referente ao Mes de ' + MesExtenso(dDtRef)


Processa({|| fPrcCtrs() })

RestArea(aArea)
Return .T.


Static Function fPrcCtrs()
Local aArea := GetArea()
Local lRet	:= .t.
Private oTTC
Private oContratos 
Private    oOk		:= LoadBitmap(GetResources(),"BR_VERDE")
Private    oNo  	:= LoadBitmap(GetResources(),"BR_VERMELHO")
Private    oMarca  := LoadBitmap(GetResources(),"LBTIK")
Private    oDesma	 := LoadBitmap(GetResources(),"LBNO")
Private oTelPed
Private aContratos := {{oMarca,'','','','','','','','','','','','','',''}}
	
	lOk:=.f.
	
	DEFINE MSDIALOG oTelPed TITLE "Contratos Aptos a Faturar - (" + AllTrim(Str(Len(aContratos),6))+') Contratos' FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL 

	@ 010, 005 LISTBOX oContratos Fields HEADER '','Contrato/Seq',"Ult.Fat.","Código","Loja", "Nome Cliente", "Valor Mensalidade",'Vencimento','Msg Nfse',"Cód.Serviço",'Descrição','TES','Descr Tes' SIZE 490, 210 OF oTelPed PIXEL ColSizes 50,50

    Processa( {|| SelCtrs(@aContratos)},"Selecionado Contratos Aptos Faturar...")

	// Marca Notas
	oContratos:bLDblClick := {|| dblClick(oContratos:nAt)}

	oContratos:SetArray(aContratos)
	oContratos:bLine := {|| {	Iif(aContratos[oContratos:nAt,MARCA]=='1',oMarca,oDesma),;
									aContratos[oContratos:nAt,CONTRATO],;
									aContratos[oContratos:nAt,ULTCOM],;
									aContratos[oContratos:nAt,CODIGO],;
									aContratos[oContratos:nAt,LOJA],;
									aContratos[oContratos:nAt,NOME],;
									TransForm(aContratos[oContratos:nAt,MENSALID],'@E 9,999,999.99'),;
									aContratos[oContratos:nAt,VENCIMENTO],;
									aContratos[oContratos:nAt,MSGNFSE],;
									aContratos[oContratos:nAt,CODSERV],;
									aContratos[oContratos:nAt,SERVICO],;
									aContratos[oContratos:nAt,TES],;
									aContratos[oContratos:nAt,DESCTES]}}

	@ 230, 005 BUTTON oBotaoCnf PROMPT "&Gerar Peds/NFs"	   		ACTION (MsAguarde({|| lOk:=U_PrcPedNfs(aContratos) },OemtoAnsi("Aguarde Gerando Pedidos e Notas de Serviço...")),Iif(lOk,Close(oTelPed),.t.)) SIZE 060, 010 OF oTelPed PIXEL
	@ 230, 075 BUTTON oBotaoMar PROMPT "&Marca Todas" 				ACTION Processa( {|| MarcaTodas()},"Aguarde Marcando Pedidos") SIZE 060, 010 OF oTelPed PIXEL
	@ 230, 145 BUTTON oBotaoDes PROMPT "&Desmarca Todas" 			ACTION Processa( {|| DesMarcaTodas()},"Aguarde Desmarcando Pedidos") SIZE 060, 010 OF oTelPed PIXEL 
	@ 230, 425 BUTTON oBotaoSai PROMPT "&Sair" 						ACTION (lOk:=.f.,Close(oTelPed)) 	SIZE 060, 010 OF oTelPed PIXEL
	
	ACTIVATE MSDIALOG oTelPed CENTERED 

	RestArea(aArea)
Return 

/*
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??uncao    ?DblClick?Autor ?Luiz Alberto        ?Data ?06/12/11 ??
???????????????????????????????????????
??escricao ?Funcao Responsavel pelo Double Click Tela Rotas ??
??         |                                             ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
*/
Static Function dblClick(nPos)
Local aArea := GetArea()

If aContratos[nPos,MARCA]=="1" 
	aContratos[nPos,MARCA]:="2"
ElseIf aContratos[nPos,MARCA]=="2" 
	aContratos[nPos,MARCA]:="1"
Endif

oContratos:Refresh()
oTelPed:Refresh()
Return .t.
	
/*
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??uncao    ?DblClick?Autor ?Luiz Alberto        ?Data ?06/12/11 ??
???????????????????????????????????????
??escricao ?Funcao Responsavel pelo Double Click Tela Rotas ??
??         |                                             ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
*/
Static Function MarcaTodas()
Local aArea := GetArea()
Local nPos

ProcRegua(Len(aContratos))
For nPos := 1 To Len(aContratos)
	IncProc("Processando Contrato " + aContratos[nPos,CONTRATO]+"...")

	aContratos[nPos,MARCA]:="1"
Next

oContratos:Refresh()
oTelPed:Refresh()
Return .t.

/*
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
??uncao    ?DblClick?Autor ?Luiz Alberto        ?Data ?06/12/11 ??
???????????????????????????????????????
??escricao ?Funcao Responsavel pelo Double Click Tela Rotas ??
??         |                                             ??
???????????????????????????????????????
???????????????????????????????????????
???????????????????????????????????????
*/
Static Function DesMarcaTodas()
Local aArea := GetArea()
Local nPos

ProcRegua(Len(aContratos))
For nPos := 1 To Len(aContratos)
	IncProc("Processando Contrato " + aContratos[nPos,CONTRATO]+"...")

	aContratos[nPos,MARCA]:="2"
Next

oContratos:Refresh()
oTelPed:Refresh()
Return .t.




User Function PrcPedNfs(aContratos)
Local aArea := GetArea()       
Local aPvlNfs := {}
Local aBloqueio := {} 
Local nI
Local cSerieNF := 'E  '
  
lOk := .f.
For nI := 1 To Len(aContratos)
	If aContratos[nI,MARCA]=='1'
		lOk := .t.            
		Exit
	Endif         
Next

If !lOk
	MsgStop("Não Foi Selecionada Nenhuma ! ")
	Return .f.
Endif


If !MsgYesNo("Confirma a Geração dos Pedidos e Notas de Mensalidade ?")
	Return .f.
Endif

Begin Transaction

aPedidos := {}

nOk := 0 
ProcRegua(Len(aContratos))
For nI := 1 To Len(aContratos)
    IncProc("Aguarde Gerando Pedido Referente Contrato No. " + aContratos[nI,CONTRATO])

	If aContratos[nI,MARCA]=='2'
		Loop
	Endif
	
    SZ1->(dbGoTo(aContratos[nI,REGISTRO]))

    // ExecAuto Pedido de Vendas

    _aItemPV := {}
    _aCabPV  := {}

	_aItem   := {}

    SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SZ1->Z1_PRODUT))
    SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+SZ1->Z1_TES))
    SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SZ1->Z1_CODCLI+SZ1->Z1_LOJCLI))

    // Tratamento Em casos de vencimento dia 31 e mêses de 28,29 ou 30 dias
	
	dVencto := StoD(Left(DtoS(dDataBase),6)+StrZero(SZ1->Z1_VENCTO,2))			// 31 
	If Empty(dVencto)
		dVencto := StoD(Left(DtoS(dDataBase),6)+StrZero(SZ1->Z1_VENCTO-1,2))	// 30 
	Endif
	If Empty(dVencto)
		dVencto := StoD(Left(DtoS(dDataBase),6)+StrZero(SZ1->Z1_VENCTO-2,2))	// 29
	Endif
	If Empty(dVencto)
		dVencto := StoD(Left(DtoS(dDataBase),6)+StrZero(SZ1->Z1_VENCTO-3,2))	// 28
	Endif

    // Caso Haja Falha na Montagem da Data do Vencimento, Gera Para o Proximo Dia 05 do Mês SubSequente

    If Empty(dVencto)
        dVencto := StoD(Left(DtoS(MonthSum(dDataBase,1)),6)+'05')
    Endif

	AADD(_aItem,{"C6_FILIAL"	, xFilial("SC6")				,Nil})
	AADD(_aItem,{"C6_ITEM"		, '01'          				,Nil})
	AADD(_aItem,{"C6_PRODUTO"	, SZ1->Z1_PRODUT			    ,Nil})
	AADD(_aItem,{"C6_UM"		, SB1->B1_UM					,Nil})
	AADD(_aItem,{"C6_QTDVEN"	, 1               				,Nil}) 
	AADD(_aItem,{"C6_PRCVEN"	, aContratos[nI,MENSALID]	    ,Nil})
	AADD(_aItem,{"C6_VALOR" 	, aContratos[nI,MENSALID]		,Nil}) 
	AADD(_aItem,{"C6_TES"		, aContratos[nI,TES]			,Nil})
	AADD(_aItem,{"C6_LOCAL"		, SB1->B1_LOCPAD				,Nil})
	AADD(_aItem,{"C6_CF"    	, SF4->F4_CF       				,Nil})
	AADD(_aItem,{"C6_ENTREG"	, dDataBase	+ 1					,Nil})
	AADD(_aItem,{"C6_DESCRI"	, SZ1->Z1_DESCR					,Nil})
	AADD(_aItem,{"C6_QTDLIB"  	, 1                 			,Nil}) 
			
	AADD(_aItemPV,_aItem)

    // Cabeçalho do Pedido
            
	AADD(_aCabPV,{"C5_FILIAL"	, xFilial("SC5")			,Nil})
	AADD(_aCabPV,{"C5_TIPO"		, "N"						,Nil})
	AADD(_aCabPV,{"C5_CLIENTE"	, SZ1->Z1_CODCLI   			,Nil}) //SF1->F1_FORNECE			,Nil})
	AADD(_aCabPV,{"C5_LOJACLI"	, SZ1->Z1_LOJCLI			,Nil}) //SF1->F1_LOJA				,Nil})
	AADD(_aCabPV,{"C5_CLIENT"	, SZ1->Z1_CODCLI 			,Nil}) //SF1->F1_FORNECE			,Nil})
	AADD(_aCabPV,{"C5_LOJAENT"	, SZ1->Z1_LOJCLI			,Nil})
	AADD(_aCabPV,{"C5_TIPOCLI"	, "F"						,Nil})
	AADD(_aCabPV,{"C5_EMISSAO"	, dDataBase					,Nil})
	AADD(_aCabPV,{"C5_MOEDA"	, 1							,Nil})
	AADD(_aCabPV,{"C5_TIPLIB"	, "1"						,Nil})
	AADD(_aCabPV,{"C5_TPCARGA"  , "2"   					,Nil})
	AADD(_aCabPV,{"C5_GERAWMS"	, "1"						,Nil})
	AADD(_aCabPV,{"C5_CONDPAG"	, "LIV"     				,Nil})
	AADD(_aCabPV,{"C5_PARC1"	, aContratos[nI,MENSALID]	,Nil})
	AADD(_aCabPV,{"C5_DATA1"	, dVencto     				,Nil})
	AADD(_aCabPV,{"C5_VEND1"	, '000001'     				,Nil})
	AADD(_aCabPV,{"C5_MENNOTA"	, AllTrim(SZ1->Z1_MENNOTA)+Iif(SZ1->Z1_REFER=='S',cMsgRef,''),Nil})
	AADD(_aCabPV,{"C5_NUMCTR"	, SZ1->Z1_NUMCTR			,Nil})
	AADD(_aCabPV,{"C5_SEQCTR"	, SZ1->Z1_SEQCTR			,Nil})

//	If AllTrim(SZ1->Z1_MUNPRES) <> AllTrim(SA1->A1_COD_MUN)
		AADD(_aCabPV,{"C5_MUNPRES"	, SZ1->Z1_MUNPRES			,Nil})
		AADD(_aCabPV,{"C5_ESTPRES"	, SZ1->Z1_ESTCOB			,Nil})
		AADD(_aCabPV,{"C5_DESCMUN"	, SZ1->Z1_MUNCOB			,Nil})
//	Endif

	lMsErroAuto := .F.
	MsgRun("Gerando Pedido de Venda ",,{|| MSExecAuto({|x,y,z| MATA410(x,y,z)},_aCabPV,_aItemPV,3)})
	If lMsErroAuto
		MostraErro()

        MsgStoP("Corrija o Problema Gerado Neste Pedido e Retorne, Processo Total Cancelado !")

        DisarmTransaction()

        RestArea(aArea)
        Return .F.
	Else
		If RecLock("SZ1",.F.)
			SZ1->Z1_ULTCOM	:=	dDataBase
			SZ1->(MsUnlock())
		Endif
    Endif

	If SZ1->Z1_FATAUT == 'S'		// Faturamento Automatico
	    AAdd(aPedidos,SC5->C5_NUM)
	Endif
Next

MsgInfo("Pedidos Gerados Com Sucesso, Total de " + Str(Len(aPedidos),3))

// Iniciando a Geração das Notas Fiscais de Serviço

ProcRegua(Len(aPedidos))
For nI := 1 To Len(aPedidos)
    IncProc("Aguarde Faturando os Pedidos Gerados...Pedido No. "+aPedidos[nI])

    SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+aPedidos[nI]))

	Pergunte("MT460A",.F.)
	 
	cAliasSC5 := "TRB1"
	cAliasSC6 := "TRB1"
	cAliasSC9 := "TRB1"
	cAliasSF4 := "TRB1"
	                               
	aStruSC5  := SC5->(dbStruct())
	aStruSC6  := SC6->(dbStruct())
	aStruSC9  := SC9->(dbStruct())
	aStruSF4  := SF4->(dbStruct())
	 
	aPvlNfs := {}
	                                                   
	 
	nTotC9 := nTotC6 := nIcmRet := 0.00
	 
	 
	_cPedido := SC5->C5_NUM

    //abre os itens dos pedidos
    SC9->(dbSetOrder(1), dbSeek(xFilial("SC9")+SC5->C5_NUM))            
			                    
	SC6->(dbSetOrder(1))
	SC6->(MsSeek(xFilial("SC6")+SC5->C5_NUM))
	                                        
	SE4->(DbSetOrder(1))
	SE4->(MsSeek(xFilial("SE4")+SC5->C5_CONDPAG) )  //FILIAL+CONDICAO PAGTO
	
	While SC9->(!EOF()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == SC5->C5_NUM
		If !Empty(SC9->C9_NFISCAL)
			SC9->(dbSkip())
			aPvlNfs := {}
			RETURN .F.
		EndIf
	
		SC6->(dbSetOrder(1))
		SC6->(MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
			
		SB1->(DbSetOrder(1))
		SB1->(MsSeek(xFilial("SB1")+SC9->C9_PRODUTO))    //FILIAL+PRODUTO
	                                  
		SB2->(DbSetOrder(1))
		SB2->(MsSeek(xFilial("SB2")+SC9->(C9_PRODUTO+C9_LOCAL))) //FILIAL+PRODUTO+LOCAL
	                                                   
		SF4->(DbSetOrder(1))
		SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))   //FILIAL+TES
	                                                   
		nPrcVen := SC9->C9_PRCVEN
		If ( SC5->C5_MOEDA <> 1 )
			nPrcVen := xMoeda(nPrcVen,SC5->C5_MOEDA,1,DataValida(dDataBase,.t.))
		EndIf
	                
		CONOUT(ALLTRIM(STR(SC9->C9_QTDLIB)+"-"+SC9->C9_NFISCAL))
		Aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
                           SC9->C9_ITEM,;
                           SC9->C9_SEQUEN,;
                           SC9->C9_QTDLIB,;
                           nPrcVen,;
                           SC9->C9_PRODUTO,;
                           SF4->F4_ISS=="S",;
                           SC9->(RecNo()),;
                           SC5->(RecNo()),;
                           SC6->(RecNo()),;
                           SE4->(RecNo()),;
                           SB1->(RecNo()),;
                           SB2->(RecNo()),;
                           SF4->(RecNo()),;
                           SB2->B2_LOCAL,;
                           0,;
                           SC9->C9_QTDLIB2})
	                                                   
		dbSelectArea("SC9")
		dbSkip()
	End
	
	If Len(aPvlNfs) > 0
	                               //EMITE A ULTIMA NF
		cNota := MaPvlNfs(aPvlNfs,cSerieNF, .F.      , .F.     , .F.      , .T.     , .F.     , 0      , 0          , .F.   ,.F. ,,,,,,)
	                               
		nRecSf2 := SF2->(Recno())
	                
		cNumero := SF2->F2_DOC
		aGnRe := {}
		aRecTit := {}     
		aDSF2 := {}     
		lConfTit := .f.
	                               
		SF2->(dbGoto(nRecSf2))
	                
		MsAguarde({||Inkey(1)}, "", 'Pedido ' + SC5->C5_NUM + ' Nota OK ' + cNota + " Gerada Com Sucesso...", .T.)

	Endif
Next
End Transaction

MsgInfo("Total de " + Str(Len(aPedidos),5) + ' Pedidos Faturados Com Sucesso !')

RestArea(aArea)
Return .t.



Static Function SelCtrs(aContratos)
Local aArea := GetArea()

Local lRet  := .T.

cQuery := 	 " SELECT * " + CRLF
//cQuery +=	 " FROM " + RetSqlName("SZ1") + " Z1 (NOLOCK) "*/ + CRLF
cQuery +=	 " FROM " + RetSqlName("SZ1") + " Z1 " + CRLF
cQuery +=	 " WHERE Z1.Z1_FILIAL = '" + xFilial("SZ1") + "' " + CRLF
cQuery +=	 " AND Z1.D_E_L_E_T_ = '' " + CRLF
cQuery +=	 " AND Z1.Z1_INIFAT <= '" + DtoS(dDataBase) + "' " + CRLF
cQuery +=	 " AND Z1.Z1_VIGINI <= '" + Dtos(dDataBase) + "' " + CRLF
cQuery +=	 " AND Z1.Z1_VIGFIM >= '" + Dtos(dDataBase) + "' " + CRLF
cQuery +=	 " AND Z1.Z1_STATUS IN('A') " + CRLF
cQuery +=	 " AND Z1.Z1_ULTCOM < '" + DtoS(FirstDate(dDataBase)) + "' " + CRLF
cQuery +=	 " ORDER BY Z1.Z1_CODCLI, Z1.Z1_LOJCLI, Z1.Z1_NUMCTR "       

TCQUERY cQuery NEW ALIAS "CHK1"


	
dbSelectArea("CHK1")
dbGoTop()

Count To nReg

ProcRegua(nReg)
dbGoTop()        

If Empty(AllTrim(aContratos[1,2]))
	aContratos := {}
Endif
	
While CHK1->(!Eof())
	IncProc("Localizando (" + AllTrim(Str(Len(aContratos),6))+") Contratos Aptos a Faturar...")
		
    SZ1->(dbGoTo(CHK1->R_E_C_N_O_))

    nMensalidade := SZ1->Z1_MENSAL
    If !Empty(SZ1->Z1_DESCO) 
        If Empty(SZ1->Z1_DTDESC) .Or. SZ1->Z1_DTDESC >= dDataBase
            nMensalidade -= SZ1->Z1_DESCO
        Endif
    Endif

    // Tratamento Em casos de vencimento dia 31 e mêses de 28,29 ou 30 dias
	
	dVencto := StoD(Left(DtoS(dDataBase),6)+StrZero(SZ1->Z1_VENCTO,2))			// 31 
	If Empty(dVencto)
		dVencto := StoD(Left(DtoS(dDataBase),6)+StrZero(SZ1->Z1_VENCTO-1,2))	// 30 
	Endif
	If Empty(dVencto)
		dVencto := StoD(Left(DtoS(dDataBase),6)+StrZero(SZ1->Z1_VENCTO-2,2))	// 29
	Endif
	If Empty(dVencto)
		dVencto := StoD(Left(DtoS(dDataBase),6)+StrZero(SZ1->Z1_VENCTO-3,2))	// 28
	Endif


    SF4->(dbSetOrder(1), dbSeek(xFilial("SF4")+SZ1->Z1_TES))
	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SZ1->Z1_CODCLI+SZ1->Z1_LOJCLI))

    AAdd(aContratos,{'1',;
                        SZ1->Z1_NUMCTR+'/'+SZ1->Z1_SEQCTR,;
                        SZ1->Z1_ULTCOM,;
                        SZ1->Z1_CODCLI,;
                        SZ1->Z1_LOJCLI,;
                        SA1->A1_NOME,;
                        nMensalidade,;
                        SZ1->Z1_PRODUT,;
                        SZ1->Z1_DESCR,;
                        SZ1->Z1_TES,;
                        SF4->F4_FINALID,;
                        AllTrim(SZ1->Z1_MENNOTA) + Iif(SZ1->Z1_REFER=='S',cMsgRef,''),;
                        SZ1->(Recno()),;
						dVencto})

	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())
RestArea(aArea)
	
If Empty(Len(aContratos)) .Or. Empty(nReg)
    AAdd(aContratos,{'2',;
                    '',;
                    CtoD(''),;
                    '',;
                    '',;
                    '',;
                    0.00,;
                    '',;
                    '',;
                    '',;
                    '',;
                    '',;
                    0,;
					CtoD('')})

	MsgStop("Atenção Nenhum Contrato Localizado !")
	RestArea(aArea)
	lRet := .F.    
Endif

oContratos:SetArray(aContratos)
oContratos:nAt := 1
oContratos:bLine := {|| {	Iif(aContratos[oContratos:nAt,MARCA]=='1',oMarca,oDesma),;
                                aContratos[oContratos:nAt,CONTRATO],;
                                aContratos[oContratos:nAt,ULTCOM],;
                                aContratos[oContratos:nAt,CODIGO],;
                                aContratos[oContratos:nAt,LOJA],;
                                aContratos[oContratos:nAt,NOME],;
                                TransForm(aContratos[oContratos:nAt,MENSALID],'@E 9,999,999.99'),;
                                aContratos[oContratos:nAt,VENCIMENTO],;
								aContratos[oContratos:nAt,MSGNFSE],;
                                aContratos[oContratos:nAt,CODSERV],;
                                aContratos[oContratos:nAt,SERVICO],;
                                aContratos[oContratos:nAt,TES],;
                                aContratos[oContratos:nAt,DESCTES]}}

oContratos:Refresh()
RestArea(aArea)
oTelPed:cCaption := "Contratos Aptos a Faturar - (" + AllTrim(Str(Len(aContratos),6))+') Contratos '
Return lRet



