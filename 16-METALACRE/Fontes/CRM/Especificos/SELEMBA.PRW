#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SelEmba        ºAutor ³Luiz Albertoº Data ³  Agosto/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona Embalagem      º±±
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
User Function SelEmba()
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

If Type("aHeader")=='U'
	aHeader := {}
Endif

If aScan(aHeader,{|x| Alltrim(x[2])== "C6_XEMBALA"}) > 0
	lPedido	:= .t.
	cEmbala := aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_XEMBALA"})]
	cProduto:= aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRODUTO"})]
	cOpciona:= aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_OPC"})]
ElseIf aScan(aHeader,{|x| Alltrim(x[2])== "UB_XEMBALA"}) > 0
	lCallCenter := .t.
	cEmbala := aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_XEMBALA"})]
	cProduto:= aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_PRODUTO"})]
	cOpciona:= aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_OPC"})]
ElseIf aScan(aHeader,{|x| Alltrim(x[2])== "ADB_XEMBAL"}) > 0
	lContrato := .t.
	cEmbala := aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADB_XEMBAL"})]
	cProduto:= aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADB_CODPRO"})]
	cOpciona:= aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADB_OPC"})]
Else
	Return .t.
Endif

cQuery := 	 " SELECT Z06_COD, Z06_EMBALA, Z06_QTDMAX,Z06_OPCMAX, Z06_PESOUN, Z06.R_E_C_N_O_ REG "
cQuery +=	 " FROM " + RetSqlName("Z06") + " Z06 (NOLOCK) "
cQuery +=	 " WHERE "
cQuery +=	 " Z06.D_E_L_E_T_ = '' "      
cQuery +=	 " AND Z06.Z06_FILIAL = '" + xFilial("Z06") + "' "
cQuery +=	 " AND Z06.Z06_PROD = '" + cProduto + "' "
If !Empty(cOpciona)
	cQuery +=	 " AND Z06.Z06_OPCMAX = '" + Left(cOpciona,7) + "' "
Endif
cQuery +=	 " ORDER BY Z06.Z06_COD "       //
	
TCQUERY cQuery NEW ALIAS "CHK1"

Count To nReg

CHK1->(dbGoTop())

If Empty(nReg)
	CHK1->(dbCloseArea())
	Return .t.
Endif

dbSelectArea("CHK1")
dbGoTop()    
ProcRegua(nReg)
lConfirma := .f.	
While CHK1->(!Eof())
	IncProc("Aguarde Localizando Embalagens")
		
	Z06->(dbGoto(CHK1->REG))

	AAdd(aOpc,{CHK1->Z06_COD,;
					CHK1->Z06_EMBALA,;
					TransForm(CHK1->Z06_QTDMAX,'999999'),;
					CHK1->Z06_OPCMAX,;
					TransForm(CHK1->Z06_PESOUN,'@E 9,999,999.999'),;
					CHK1->REG})

	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())
	
RestArea(aArea)

If Empty(Len(aOpc))
	MsgAlert("Atenção Não Existem Embalagens para Este Produto !")
	RestArea(aArea)
	Return .t.
Endif


DEFINE MSDIALOG oRcp5 TITLE "Seleção Embalagem" FROM 000, 000  TO 350, 720 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME 
oRcp5:lEscClose := .F. //Não permite sair ao usuario se precionar o ESC

    @ 010, 005 LISTBOX oEmbalal Fields HEADER 'Código','Embalagem',"Qtd.Máx","Tamanho(opc)","Peso Un.(kg)" SIZE 340, 140 OF oRcp5 PIXEL //ColSizes 50,50

    oEmbalal:SetArray(aOpc)
    oEmbalal:bLine := {|| {	aOpc[oEmbalal:nAt,1],;
    							aOpc[oEmbalal:nAt,2],;
        						aOpc[oEmbalal:nAt,3],;
      							aOpc[oEmbalal:nAt,4],;
					      		aOpc[oEmbalal:nAt,5]}}

	oEmbalal:bLDblClick := {||(nReg := aOpc[oEmbalal:nAt,6], Close(oRcp5),nOpc:=1)}

	nOpc := 0
	nReg := 0
	
  	@ 160, 005 BUTTON oBotaoCnf PROMPT "&Seleciona" 			ACTION (nReg := aOpc[oEmbalal:nAt,6], Close(oRcp5),nOpc:=1) SIZE 080, 010 OF oRcp5 PIXEL
  	@ 160, 085 BUTTON oBotaoSai PROMPT "Sai&r" 					ACTION (Close(oRcp5),nOpc:=0) SIZE 080, 010 OF oRcp5 PIXEL
	

	ACTIVATE MSDIALOG oRcp5 CENTERED //ON INIT EnchoiceBar(oRcp,{||If(oGet:Tud_oOk(),_nOpca:=1,_nOpca:=0)},{||oRcp:End()})
	
	RestArea(aArea)
	If nOpc == 1
		If nReg > 1
			Z06->(dbGoTo(nReg))
			cRetorno := Z06->Z06_COD
		Endif
	Else
		cRetorno := ''
	Endif

	If lPedido
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_XEMBALA"})]	:=	cRetorno
		M->C6_XEMBALA :=	cRetorno
	ElseIf lCallCenter
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_XEMBALA"})]	:=	cRetorno
		M->UB_XEMBALA :=	cRetorno
	ElseIf lContrato
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADB_XEMBAL"})]	:=	cRetorno
		M->ADB_XEMBAL :=	cRetorno
	Endif

Return .t.

	