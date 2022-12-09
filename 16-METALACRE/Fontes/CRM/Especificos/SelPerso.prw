#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SelPerso   ºAutor ³Luiz Albertoº Data ³  Agosto/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona Personalização        º±±
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
User Function SelPerso()
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

If aScan(aHeader,{|x| Alltrim(x[2])== "C6_XLACRE"}) > 0
	lPedido	:= .t.
	cPersona := aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_XLACRE"})]
ElseIf aScan(aHeader,{|x| Alltrim(x[2])== "UB_XLACRE"}) > 0
	lCallCenter := .t.
	cPersona :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_XLACRE"})]
ElseIf aScan(aHeader,{|x| Alltrim(x[2])== "ADB_XLACRE"}) > 0
	lContrato := .t.
	cPersona :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADB_XLACRE"})]
Else
	Return ''
Endif

cQuery := 	 " SELECT Z02_CODPER, Z02_DESC, Z02_CODCLI, Z02_LOJACL, Z02_PROCOD, Z02_PROLOJ, Z02.R_E_C_N_O_ REG "
cQuery +=	 " FROM " + RetSqlName("Z02") + " Z02, " + RetSqlName("Z00") + " Z00 "
cQuery +=	 " WHERE "
cQuery +=	 " Z02.D_E_L_E_T_ = '' "      
cQuery +=	 " AND Z00.D_E_L_E_T_ = '' "      
cQuery +=	 " AND Z00.Z00_MSBLQL <> '1' "
cQuery +=	 " AND Z00.Z00_FILIAL = '" + xFilial("Z00") + "' "
cQuery +=	 " AND Z02.Z02_FILIAL = '" + xFilial("Z02") + "' "
cQuery +=	 " AND Z00.Z00_COD = Z02.Z02_CODPER "
If lPedido
	cQuery +=	 " AND Z02.Z02_CODCLI+Z02.Z02_LOJACL = '" + M->C5_CLIENTE+M->C5_LOJACLI + "' "
ElseIf lCallCenter
	If M->UA_CLIPROS == '1'
		cQuery +=	 " AND Z02.Z02_CODCLI+Z02.Z02_LOJACL = '" + M->UA_CLIENTE + M->UA_LOJA + "' "
	ElseIf M->UA_CLIPROS == '2'
		cQuery +=	 " AND Z02.Z02_PROCOD+Z02.Z02_PROLOJ = '" + M->UA_CLIENTE + M->UA_LOJA + "' "
	Endif
ElseIf lContrato
	cQuery +=	 " AND Z02.Z02_CODCLI+Z02.Z02_LOJACL = '" + M->ADA_CODCLI+M->ADA_LOJCLI + "' "
Endif
cQuery +=	 " ORDER BY Z02.Z02_CODPER "       //
	
TCQUERY cQuery NEW ALIAS "CHK1"

Count To nReg

CHK1->(dbGoTop())

If Empty(nReg)
	CHK1->(dbCloseArea())
	Return .f.
Endif


dbSelectArea("CHK1")
dbGoTop()    
ProcRegua(nReg)
lConfirma := .f.	
While CHK1->(!Eof())
	IncProc("Aguarde Localizando Personalizações")
		
	Z02->(dbGoto(CHK1->REG))

	AAdd(aOpc,{CHK1->Z02_CODPER,;
					CHK1->Z02_DESC,;
					CHK1->Z02_CODCLI,;
					CHK1->Z02_LOJACL,;
					CHK1->Z02_PROCOD,;
					CHK1->Z02_PROLOJ,;
					Z02->(Recno())})

	CHK1->(dbSkip(1))
Enddo
CHK1->(dbCloseArea())
	
RestArea(aArea)

If Empty(Len(aOpc))
	MsgAlert("Atenção Não Existem Personalizações para Este Cliente !")
	RestArea(aArea)
	If lPedido
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_XLACRE"})]	:=	''
	ElseIf lCallCenter
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_XLACRE"})]	:=	''
	ElseIf lContrato
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADB_XLACRE"})]	:=	''
	Endif
	Return .F.
Endif


DEFINE MSDIALOG oRcp5 TITLE "Seleção Personalizações" FROM 000, 000  TO 350, 720 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME 
oRcp5:lEscClose := .F. //Não permite sair ao usuario se precionar o ESC

    @ 010, 005 LISTBOX oPersonal Fields HEADER 'Personal.','Descrição',"Cliente","Loja","Prospect",'Loja' SIZE 340, 140 OF oRcp5 PIXEL //ColSizes 50,50

    oPersonal:SetArray(aOpc)
    oPersonal:bLine := {|| {	aOpc[oPersonal:nAt,1],;
    							aOpc[oPersonal:nAt,2],;
        						aOpc[oPersonal:nAt,3],;
      							aOpc[oPersonal:nAt,4],;
					      		aOpc[oPersonal:nAt,5],;
					      		aOpc[oPersonal:nAt,6]}}

	oPersonal:bLDblClick := {||(nReg := aOpc[oPersonal:nAt,7], Close(oRcp5),nOpc:=1)}

	nOpc := 0
	nReg := 0
	
  	@ 160, 005 BUTTON oBotaoCnf PROMPT "&Seleciona" 			ACTION (nReg := aOpc[oPersonal:nAt,7], Close(oRcp5),nOpc:=1) SIZE 080, 010 OF oRcp5 PIXEL
  	@ 160, 085 BUTTON oBotaoSai PROMPT "Sai&r" 					ACTION (Close(oRcp5),nOpc:=0) SIZE 080, 010 OF oRcp5 PIXEL
	

	ACTIVATE MSDIALOG oRcp5 CENTERED //ON INIT EnchoiceBar(oRcp,{||If(oGet:Tud_oOk(),_nOpca:=1,_nOpca:=0)},{||oRcp:End()})
	
	RestArea(aArea)
	If nOpc == 1
		If nReg > 1
			Z02->(dbGoTo(nReg))
			cRetorno := Z02->Z02_CODPER
		Endif
	Else
		cRetorno := ''
	Endif

	If lPedido
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_XLACRE"})]	:=	cRetorno
	ElseIf lCallCenter
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "UB_XLACRE"})]	:=	cRetorno
	ElseIf lContrato
		aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "ADB_XLACRE"})]	:=	cRetorno
	Endif

Return .t.

	