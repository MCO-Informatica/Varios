#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SelAplic       ºAutor ³Luiz Albertoº Data ³  Setembro/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona Aplicacao      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SelAplic()
Local aArea := GetArea()
Local cCampo := ReadVar()                          
PRIVATE oRcp5
Private    oOk		 := LoadBitmap(GetResources(),"LBTIK")
Private    oNo  	 := LoadBitmap(GetResources(),"LBNO")
Private  oSinalNo    := LoadBitmap(GetResources(),"BR_VERMELHO")
Private  oSinalOk    := LoadBitmap(GetResources(),"BR_VERDE")
Private aOpc := {}
Private oBotaoCnf
                                                    
lPedido := .f.
lCallCenter := .f.
lContrato := .f.    
lProdCli  := .F.
lOportuni1:= .f.
lOportuni2:= .f.
cProduto := ''
If Type("aHeader")=='U'
	aHeader := {}
Endif        

nPosCod	:=	aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRODUTO"})
If Empty(nPosCod)                                                    
	nPosCod	:=	aScan(aHeader,{|x| Alltrim(x[2])== "UB_PRODUTO"})
Endif
If Empty(nPosCod)                                                    
	nPosCod	:=	aScan(aHeader,{|x| Alltrim(x[2])== "ADB_CODPRO"})
Endif
If Empty(nPosCod) .And. !'AD1_XAPLIC'$cCampo
	nPosCod	:=	aScan(aHeader,{|x| Alltrim(x[2])== "ADJ_PROD"})
ElseIf 'AD1_XAPLIC'$cCampo
	cProduto := M->AD1_CODPRO
Endif

If Empty(nPosCod) .And. !'AD1_XAPLIC'$cCampo
	Return .t.
Endif

If !Empty(cProduto)
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProduto))
ElseIf Type("aCols")<>'U'
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+aCols[n,nPosCod]))
Endif

If aScan(aHeader,{|x| Alltrim(x[2])== "C6_XAPLC"}) > 0
	lPedido	:= .t.
	cAplic := aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_XAPLC"})]
ElseIf aScan(aHeader,{|x| Alltrim(x[2])== "UB_XAPLIC"}) > 0
	lCallCenter := .t.
	cAplic := aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_XAPLIC"})]
ElseIf aScan(aHeader,{|x| Alltrim(x[2])== "ADB_XAPL"}) > 0
	lContrato := .t.
	cAplic := aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADB_XAPL"})]
ElseIf aScan(aHeader,{|x| Alltrim(x[2])== "ADJ_XAPLIC"}) > 0 .And. !'AD1_XAPLIC'$cCampo
	lOportuni1:= .t.
	cAplic := aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADJ_XAPLIC"})]
ElseIf 'AD1_XAPLIC'$cCampo
	lOportuni2:= .t.
	cAplic := M->AD1_XAPLIC
Else
	Return ''
Endif

cQuery := 	 " SELECT Z0_COD, Z0_DESCR, Z0.R_E_C_N_O_ REG "
cQuery +=	 " FROM " + RetSqlName("SZ0") + " Z0 "
cQuery +=	 " WHERE "
cQuery +=	 " Z0.D_E_L_E_T_ = '' "      
cQuery +=	 " AND Z0.Z0_FILIAL = '" + xFilial("SZ0") + "' "
cQuery +=	 " AND Z0.Z0_GRUPO = '" + SB1->B1_GRUPO + "' "
cQuery +=	 " ORDER BY Z0.Z0_DESCR "       //
	
TCQUERY cQuery NEW ALIAS "CHK1"

Count To nReg

CHK1->(dbGoTop())

If Empty(nReg)
	CHK1->(dbCloseArea())
	Return ''
Endif

dbSelectArea("CHK1")
dbGoTop()    
ProcRegua(nReg)
lConfirma := .f.	
While CHK1->(!Eof())
	IncProc("Aguarde Localizando Aplicações")
		
	SZ0->(dbGoto(CHK1->REG))

	AAdd(aOpc,{CHK1->Z0_COD,;
					CHK1->Z0_DESCR,;
					CHK1->REG})

	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())
	
RestArea(aArea)

If Empty(Len(aOpc))
	MsgAlert("Atenção Não Existem Aplicações para Este Produto !")
	RestArea(aArea)
	Return ''
Endif


DEFINE MSDIALOG oRcp5 TITLE "Seleção de Aplicações" FROM 000, 000  TO 350, 720 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME 
oRcp5:lEscClose := .F. //Não permite sair ao usuario se precionar o ESC

    @ 010, 005 LISTBOX oAplicl Fields HEADER 'Código','Aplicação' SIZE 340, 140 OF oRcp5 PIXEL //ColSizes 50,50

    oAplicl:SetArray(aOpc)
    oAplicl:bLine := {|| {	aOpc[oAplicl:nAt,1],;
    							aOpc[oAplicl:nAt,2]}}

	oAplicl:bLDblClick := {||(nReg := aOpc[oAplicl:nAt,3], Close(oRcp5),nOpc:=1)}

	nOpc := 0
	nReg := 0
	
  	@ 160, 005 BUTTON oBotaoCnf PROMPT "&Seleciona" 			ACTION (nReg := aOpc[oAplicl:nAt,3], Close(oRcp5),nOpc:=1) SIZE 080, 010 OF oRcp5 PIXEL
  	@ 160, 085 BUTTON oBotaoSai PROMPT "Sai&r" 					ACTION (Close(oRcp5),nOpc:=0) SIZE 080, 010 OF oRcp5 PIXEL
	

	ACTIVATE MSDIALOG oRcp5 CENTERED //ON INIT EnchoiceBar(oRcp,{||If(oGet:Tud_oOk(),_nOpca:=1,_nOpca:=0)},{||oRcp:End()})
	
	RestArea(aArea)
	If nOpc == 1
		If nReg > 1
			SZ0->(dbGoTo(nReg))    
			SZ6->(dbSetOrder(1), dbSeek(xFilial("SZ6")+SZ0->Z0_COD))
			
			cRetorno := SZ0->Z0_COD
			cNome	 := SZ6->Z6_DESCR
		Else
			cRetorno := ''
			cNome 	 := ''
		Endif
	Else
		cRetorno := ''
		cNome 	 := ''
	Endif

	
	If lPedido
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_XAPLC"})]	:=	cRetorno
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_XAPLICA"})]	:=	cNome
		
		M->C6_XAPLC 	:=	cRetorno
		M->C6_XAPLICA 	:=	cNome
	ElseIf lCallCenter
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_XAPLIC"})]	:=	cRetorno
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_XAPLICA"})]	:=	cNome
	
		M->UB_XAPLIC 	:=	cRetorno
		M->UB_XAPLICA 	:=	cNome
	ElseIf lContrato
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADB_XAPL"})]	:=	cRetorno
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADB_XAPLIC"})]	:=	cNome
	
		M->ADB_XAPL 	:=	cRetorno
		M->ADB_XAPLIC  	:=	cNome
	ElseIf lOportuni1
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADJ_XAPLIC"})]	:=	cRetorno
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADJ_XAPLDE"})]	:=	cNome
	
		M->ADJ_XAPLIC 	:=	cRetorno
		M->ADJ_XAPLDE 	:=	cNome
	ElseIf lOportuni2
		M->AD1_XAPLIC 	:=	cRetorno
		M->AD1_XAPLDE 	:=	cNome
	Endif

Return .t.

	