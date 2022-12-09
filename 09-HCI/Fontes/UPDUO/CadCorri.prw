#Include 'Protheus.ch'

User Function CadCorri()

	Local cFilter     := ""
	Local aCores      := {}
	Private cCadastro := 'Corridas'
	Private cDelFunc  := '.T.'
	Private aRotina   := {}
	Private cAlias    := 'SZI'

	aAdd( aRotina, { 'Pesquisar'  , 'AxPesqui', 0, 1 } )
	aAdd( aRotina, { "Visualizar" , "AxVisual", 0, 2 })
	aAdd( aRotina, { 'Alterar'    , 'U_MntCorri(2)', 0, 4 } )
	aAdd( aRotina, { 'Excluir'    , 'U_MntCorri(3)', 0, 5 } )
	aAdd( aRotina, { 'Incluir'    , 'U_MntCorri(1)', 0, 3 } )

	dbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTop()
	mBrowse(10,10,60,120,cAlias,,,,,, aCores,,,,,,,,cFilter)

Return Nil

/*
nOpc => 1 - InclusÃ£o
        2 - AlteraÃ§Ã£o
        3 - ExclusÃ£o
*/
User Function MntCorri(nOpc)

	Local oDlg
	Local oPnl1
	Local oPnl2
	Local oPnl3
	Local oPnl4
	Local oPnl5
	Local oPnl6

	Local oButton1
	Local oButton2

	Local oGet01
	Local oGet02
	Local oGet03
	Local oGet04
	Local oGet05
	Local oGet06
	Local oGet07
	Local oGet08
	Local oGet09
	Local oGet10
	Local oGet11
	Local oGet12
	Local oGet13
	Local oGet14
	Local oGet15
	Local oGet16
	Local oGet17
	Local oGet18
	Local oGet19
	Local oGet20

	Local oMultiGe

	Local cCombo1 := ""
	Local cCombo2 := ""
	Local cCombo3 := ""
	Local cCombo4 := ""
	Local cCombo5 := ""
	Local cCombo6 := ""

	Local aIComb1:= {}
	Local aIComb2:= {}
	Local aIComb3:= {}
	Local aIComb4:= {}
	Local aIComb5:= {}
	Local aIComb6:= {}

	Local lHasButton := .F.
	Local lNoButton  := .T.
	Local cLabelText := ""    //indica o texto que será apresentado na Label.
	Local nLabelPos  := 1     //Indica a posição da label, sendo 1=Topo e 2=Esquerda

	Local bChange := {}

	Private oBrw
	Private oCombo1
	Private oCombo2
	Private oCombo3
	Private oCombo4
	Private oCombo5
	Private oCombo6

	Private aCabec := {}
	Private aColsEd := {}
	Private aColsEx := {}

	Private aOperacao := {"Inclusao","Alteracao","Exclusao"}

	Private nZNTRACAO1	:= 0
	Private nZNTRACAO2	:= 0
	Private nZNESCOA1	:= 0
	Private nZNESCOA2	:= 0
	Private nZNALONG1	:= 0
	Private nZNALONG2	:= 0
	Private nZNESTRIC1	:= 0
	Private nZNESTRIC2	:= 0
	Private nZNDUREZ11	:= 0
	Private nZNDUREZ12	:= 0
	Private nZNDUREZ21	:= 0
	Private nZNDUREZ22	:= 0

	Private nZNFASE1	:= 0
	Private nZNFASE2	:= 0
	Private nZNFASE3	:= 0
	Private nZNMEDIA	:= 0
	Private nZNTEMP	   := 0

  /* ---Preencher Campos-- */
	Default cZSRI      := space(10)
	Default cZSCORRIDA := space(20)

	Default cZSIDNORMA := space(04)
	Default cZSNORMADI := space(40)

	Default nZSTRACAO	:= 0
	Default nZSESCOA	:= 0
	Default nZSALONG	:= 0
	Default nZSESTRIC	:= 0
	Default nZSDUREZ1	:= 0
	Default nZSDUREZ2	:= 0

	Default nZSFASE1	:= 0
	Default nZSFASE2	:= 0
	Default nZSFASE3	:= 0
	Default nZSMEDIA	:= 0
	Default nZSTEMP	    := 0

	Default cZSTERMICO := space(03)
	Default cZSMPARTID := space(03)
	Default cZSTIPCORP := space(03)
	Default cZSSENCORP := space(03)

	Default mZSOBS     := ""

	Default cZSNUMPC   := space(06)
	Default cZSITEMPC  := space(03)
	Default cZSFORNEC  := space(06)
	Default cZSCODIGO  := space(15)
	Default cZSDESCR   := space(40)
	Default nZSQTD 	   := 0

	if !szi->(eof())
		cZSRI     := SZI->ZI_RI
		cZSCORRIDA:= SZI->ZI_CORRIDA
		cZSFORNEC := SZI->ZI_FORNECE+"/"+SZI->ZI_LOJA
		cZSNOMFOR := Posicione("SA2",1,xFilial("SA2")+SZI->ZI_FORNECE+SZI->ZI_LOJA,"A2_NOME")
		cZSNUMPC  := SZI->ZI_COMPRA
		cZSITEMPC := SZI->ZI_ITEM
		cZSCODIGO := SZI->ZI_COD
		cZSDESCR  := SZI->ZI_DESCRI
		nZSQTD    := SZI->ZI_QTD

		szs->(dbseek(xfilial()+cZSRI))
		if nOpc == 1
			if !szs->(eof())
				msginfo("A corrida "+SZS->ZS_CORRIDA+" e o RI "+SZS->ZS_RI+" já foram incluidos !")
				return
			endif
		elseif !szs->(eof())

			cZSIDNORMA := SZS->ZS_IDNORMA
			cZSNORMADI := SZS->ZS_NORMADI

			nZSTRACAO := SZS->ZS_TRACAO
			nZSESCOA  := SZS->ZS_ESCOA
			nZSALONG  := SZS->ZS_ALONG
			nZSESTRIC := SZS->ZS_ESTRIC
			nZSDUREZ1 := SZS->ZS_DUREZ1
			nZSDUREZ2 := SZS->ZS_DUREZ2

			nZSFASE1 := SZS->ZS_FASE1
			nZSFASE2 := SZS->ZS_FASE2
			nZSFASE3 := SZS->ZS_FASE3
			nZSMEDIA := SZS->ZS_MEDIA
			nZSTEMP  := SZS->ZS_TEMP

			cZSTERMICO := SZS->ZS_TERMICO
			cZSMPARTID := SZS->ZS_MPARTID
			cZSTIPCORP := SZS->ZS_TIPCORP
			cZSSENCORP := SZS->ZS_SENCORP

			mZSOBS := SZS->ZS_OBS
		elseif nOpc != 1
			msginfo("Nenhuma corrida encontrada (SZS). Favor verificar !")
			return
		endif

	else
		msginfo("Nenhum Registro de entrada (SZI) posicionado. Favor verificar !")
		return
	endif

	//X3Titulo()	X3_CAMPO		X3_PICTURE      	X3_TAMANHO	X3_DECIMAL	    X3_VALID	X3_USADO    X3_TIPO		X3_F3	X3_CONTEXT	X3_CBOX	X3_RELACAO	X3_WHEN
	Aadd(aCabec, {"Item"    ,"ZT_ITEM"   ,	"@!",           	    02,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"Simbolo" ,"ZT_SIMBOLO",	"@!",         		    02,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"Elemento","ZT_NOME"   ,	"@!",         		    15,         0,	        "",			"",	        "C",        "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"% Min"   ,"ZT_MIN"    ,	"@E 99,999,999.99999",16,         5,	        "",			"",	        "N",        "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"% Max"   ,"ZT_MAX"    ,	"@E 99,999,999.99999",16,         5,	        "",			"",	        "N",        "",     "R",        "",     "",         ""})
	Aadd(aCabec, {"%Corrida","ZT_VALOR"  ,	"@E 99,999,999.99999",16,         5,	        "",			"",	        "N",        "",     "R",        "",     "",         ""})
	aColsEd := {"ZT_VALOR"}

	aIComb1 := PopCombo1(nOpc)
	aIComb2 := PopCombo2(nOpc)
	if nOpc == 1
		aColsEx := { { '01',space(02),space(15),0,0,0, .f. } }

		aIComb3 := {" "}
		aIComb4 := {" "}
		aIComb5 := {" "}
		aIComb6 := {" "}

		cCombo1 := aIComb1[1]
		cCombo2 := aIComb2[1]
		cCombo3 := aIComb3[1]
		cCombo4 := aIComb4[1]
		cCombo5 := aIComb5[1]
		cCombo6 := aIComb6[1]
	else
		aColsEx := PopBrwRI(cZSRI,cZSIDNORMA)   //POPULANDO ELEMENTOS QUIMICOS

		aIComb3 := PopCombo('TX',cZSIDNORMA) //{"TRATAMENTO TERMICO"}
		aIComb4 := PopCombo('PM',cZSIDNORMA) //{"MATERIAL DE PARTIDA"}
		aIComb5 := PopCombo('TO',cZSIDNORMA) //{"TIPO CORPO DE PROVA"}
		aIComb6 := PopCombo('SU',cZSIDNORMA) //{"SENTIDO CORPO DE PROVA"}

		if AtuVarNor(cZSIDNORMA,2,"N")
			cCombo1 := alltrim(szn->zn_norma)
		endif

		cCombo2 := cZSNORMADI
		cCombo3 := iif(empty(cZSTERMICO),space(30),cZSTERMICO+"-"+substr(Posicione("SX5",1,xFilial("SX5")+'TX'+cZSTERMICO,"X5_DESCRI"),1,30))
		cCombo4 := iif(empty(cZSMPARTID),space(30),cZSMPARTID+"-"+substr(Posicione("SX5",1,xFilial("SX5")+'PM'+cZSMPARTID,"X5_DESCRI"),1,30))
		cCombo5 := iif(empty(cZSTIPCORP),space(30),cZSTIPCORP+"-"+substr(Posicione("SX5",1,xFilial("SX5")+'TO'+cZSTIPCORP,"X5_DESCRI"),1,30))
		cCombo6 := iif(empty(cZSSENCORP),space(30),cZSSENCORP+"-"+substr(Posicione("SX5",1,xFilial("SX5")+'SU'+cZSSENCORP,"X5_DESCRI"),1,30))

	endif

	DEFINE MSDIALOG oDlg TITLE "Cadastro de Corrida - "+aOperacao[nOpc] FROM 000, 000  TO 600, 1035 COLORS 0, 16777215 PIXEL
	//lin,col                     col,lin
	oPnl1:= tPanel():New(000,001,,oDlg,,,,,CLR_HCYAN,520,052)
	//oPnl1:Align := CONTROL_ALIGN_TOP
	//CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA
	cLabelText := "REG INTERNO(H)"
	oGet01 := TGet():New(003,003,{|u|If(PCount()==0,cZSRI     ,cZSRI     := u)},oPnl1,040,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cZSRI"     ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	cLabelText := "CORRIDA"
	oGet02 := TGet():New(003,063,{|u|If(PCount()==0,cZSCORRIDA,cZSCORRIDA:= u)},oPnl1,040,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cZSCORRIDA",,,, lHasButton, lNoButton,, cLabelText, nLabelPos)
	cLabelText := "FORNECEDOR"
	oGet03 := TGet():New(003,123,{|u|If(PCount()==0,cZSFORNEC ,cZSFORNEC := u)},oPnl1,038,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cZSFORNEC" ,,,, lHasButton, lNoButton,, cLabelText, nLabelPos)
	cLabelText := "NOME"
	oGet04 := TGet():New(003,183,{|u|If(PCount()==0,cZSNOMFOR ,cZSNOMFOR := u)},oPnl1,150,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cZSNOMFOR" ,,,, lHasButton, lNoButton,, cLabelText, nLabelPos)
	cLabelText := "PEDIDO DE COMPRA"
	oGet05 := TGet():New(028,003,{|u|If(PCount()==0,cZSNUMPC  ,cZSNUMPC  := u)},oPnl1,030,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cZSNUMPC"  ,,,, lHasButton, lNoButton,, cLabelText, nLabelPos)
	cLabelText := "ITEM"
	oGet06 := TGet():New(028,063,{|u|If(PCount()==0,cZSITEMPC ,cZSITEMPC := u)},oPnl1,020,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cZSITEMPC" ,,,, lHasButton, lNoButton,, cLabelText, nLabelPos)
	cLabelText := "PRODUTO"
	oGet07 := TGet():New(028,123,{|u|If(PCount()==0,cZSCODIGO ,cZSCODIGO := u)},oPnl1,055,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cZSCODIGO" ,,,, lHasButton, lNoButton,, cLabelText, nLabelPos)
	cLabelText := "DESCRIÇÃO"
	oGet08 := TGet():New(028,183,{|u|If(PCount()==0,cZSDESCR  ,cZSDESCR  := u)},oPnl1,150,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cZSDESCR"  ,,,, lHasButton, lNoButton,, cLabelText, nLabelPos)
	cLabelText := "QTD PRODUTO"
	oGet09 := TGet():New(028,403,{|u|If(PCount()==0,nZSQTD    ,nZSQTD    := u)},oPnl1,038,10,"@E 99,999,999.99",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZSQTD"    ,,,, lHasButton, lNoButton,, cLabelText, nLabelPos)
	oGet01:disable();  oGet02:disable();  oGet03:disable();  oGet04:disable();  oGet05:disable()
	oGet06:disable();  oGet07:disable();  oGet08:disable();  oGet09:disable()

	@ 005, 403 BUTTON oButton1 PROMPT "Fechar" SIZE 037, 012 action oDlg:End() OF oDlg PIXEL
	@ 005, 453 BUTTON oButton2 PROMPT "Confirmar" SIZE 037, 012 action iif(confCor(nOpc),oDlg:End(),.f.) OF oDlg PIXEL

    /*******************************************************/
	//lin,col                     col,lin
	oPnl2:= tPanel():New(055,001,,oDlg,,,,,CLR_HGRAY,520,030)
	cLabelText := "NORMA TÉCNICA"
	oCombo1 := TComboBox():New(003,003,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aIComb1,200,20,oPnl2,,{||  PopNorma(cCombo1)  },,,,.T.,,,,,,,,,'cCombo1', cLabelText, nLabelPos)
	cLabelText := "NORMA DIMENCIONAL"
	oCombo2 := TComboBox():New(003,250,{|u|if(PCount()>0,cCombo2:=u,cCombo2)},aIComb2,200,20,oPnl2,,{||                     },,,,.T.,,,,,,,,,'cCombo2', cLabelText, nLabelPos)
	if nOpc == 3
		oCombo1:disable(); oCombo2:disable()
	endif
    /*******************************************************/
	//lin,col            col,lin
	oPnl3:=tPanel():New(087,001,,oDlg,,,,,CLR_HGRAY,520,090)
	//lin,col lin,col                                 Val da linha   Val todas linhas                          Val coluna         Val exclusao linha
	oBrw:=MsNewGetDados():New( 002,003,090,515, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+ZT_ITEM", aColsEd,1, 99, "u_VLimEle(oBrw,cZSIDNORMA)", "", "u_VExclusao(oBrw)", oPnl3, aCabec, aColsEx)
	oBrw:SetArray(aColsEx,.T.)
	oBrw:Refresh()
	if nOpc == 3
		oBrw:disable()
	endif
    /*******************************************************/
	//lin,col            col,lin
	oPnl3:=tPanel():New(179,001,,oDlg,,,,,CLR_HGRAY,520,030)
	@ 003, 005 SAY oSay PROMPT "Limite" SIZE 350, 010 OF oPnl3 COLORS 0, 16777215 PIXEL
	@ 003, 045 SAY oSay PROMPT "Limite" SIZE 350, 010 OF oPnl3 COLORS 0, 16777215 PIXEL
	@ 003, 165 SAY oSay PROMPT "Dureza" SIZE 350, 010 OF oPnl3 COLORS 0, 16777215 PIXEL
	@ 003, 205 SAY oSay PROMPT "Dureza" SIZE 350, 010 OF oPnl3 COLORS 0, 16777215 PIXEL

	@ 009, 005 SAY oSay PROMPT "de Tracao" SIZE 350, 010 OF oPnl3 COLORS 0, 16777215 PIXEL
	@ 009, 045 SAY oSay PROMPT "Escoamento" SIZE 350, 010 OF oPnl3 COLORS 0, 16777215 PIXEL
	@ 009, 085 SAY oSay PROMPT "Alongamento" SIZE 350, 010 OF oPnl3 COLORS 0, 16777215 PIXEL
	@ 009, 125 SAY oSay PROMPT "Estriccao" SIZE 350, 010 OF oPnl3 COLORS 0, 16777215 PIXEL
	@ 009, 165 SAY oSay PROMPT "Brinnel 1" SIZE 350, 010 OF oPnl3 COLORS 0, 16777215 PIXEL
	@ 009, 205 SAY oSay PROMPT "Brinnel 2" SIZE 350, 010 OF oPnl3 COLORS 0, 16777215 PIXEL
	oGet10 := TGet():New(016,005,{|u|If(PCount()==0,nZSTRACAO,nZSTRACAO:= u)},oPnl3,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZSTRACAO",,,, lHasButton , lNoButton)
	oGet11 := TGet():New(016,045,{|u|If(PCount()==0,nZSESCOA ,nZSESCOA := u)},oPnl3,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZSESCOA" ,,,, lHasButton , lNoButton)
	oGet12 := TGet():New(016,085,{|u|If(PCount()==0,nZSALONG ,nZSALONG := u)},oPnl3,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZSALONG" ,,,, lHasButton , lNoButton)
	oGet13 := TGet():New(016,125,{|u|If(PCount()==0,nZSESTRIC,nZSESTRIC:= u)},oPnl3,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZSESTRIC",,,, lHasButton , lNoButton)
	oGet14 := TGet():New(016,165,{|u|If(PCount()==0,nZSDUREZ1,nZSDUREZ1:= u)},oPnl3,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZSDUREZ1",,,, lHasButton , lNoButton)
	oGet15 := TGet():New(016,205,{|u|If(PCount()==0,nZSDUREZ2,nZSDUREZ2:= u)},oPnl3,038,10,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"nZSDUREZ2",,,, lHasButton , lNoButton)
	if nOpc == 3
		oGet10:disable();  oGet11:disable();  oGet12:disable();  oGet13:disable();  oGet14:disable();  oGet15:disable()
	endif
    /*******************************************************/
	//lin,col            col,lin
	oPnl4:=tPanel():New(211,001,,oDlg,,,,,CLR_HGRAY,520,026)
	@ 003, 005 SAY oSay PROMPT "Fase 1" SIZE 350, 010 OF oPnl4 COLORS 0, 16777215 PIXEL
	@ 003, 045 SAY oSay PROMPT "Fase 2" SIZE 350, 010 OF oPnl4 COLORS 0, 16777215 PIXEL
	@ 003, 085 SAY oSay PROMPT "Fase 3" SIZE 350, 010 OF oPnl4 COLORS 0, 16777215 PIXEL
	@ 003, 125 SAY oSay PROMPT "Media" SIZE 350, 010 OF oPnl4 COLORS 0, 16777215 PIXEL
	@ 003, 165 SAY oSay PROMPT "Temperatura" SIZE 350, 010 OF oPnl4 COLORS 0, 16777215 PIXEL
	bChange := {|| nZSMEDIA := round((nZSFASE1+nZSFASE2+nZSFASE3)/3,5) }
	oGet16 := TGet():New(010,005,{|u|If(PCount()==0,nZSFASE1,nZSFASE1:= u)},oPnl4,038,010,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,bChange,.F.,.F.,,"nZSFASE1",,,, lHasButton , lNoButton)
	oGet17 := TGet():New(010,045,{|u|If(PCount()==0,nZSFASE2,nZSFASE2:= u)},oPnl4,038,010,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,bChange,.F.,.F.,,"nZSFASE2",,,, lHasButton , lNoButton)
	oGet18 := TGet():New(010,085,{|u|If(PCount()==0,nZSFASE3,nZSFASE3:= u)},oPnl4,038,010,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,bChange,.F.,.F.,,"nZSFASE3",,,, lHasButton , lNoButton)
	oGet19 := TGet():New(010,125,{|u|If(PCount()==0,nZSMEDIA,nZSMEDIA:= u)},oPnl4,038,010,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,       ,.T./*lReadOnly*/,.F.,,"nZSMEDIA",,,, lHasButton , lNoButton)
	oGet20 := TGet():New(010,165,{|u|If(PCount()==0,nZSTEMP ,nZSTEMP := u)},oPnl4,038,010,"@E 99,999,999.99999",,,,,.F.,,.T.,,.F.,,.F.,.F.,       ,.F.,.F.,,"nZSTEMP" ,,,, lHasButton , lNoButton)
	if nOpc == 3
		oGet16:disable();  oGet17:disable();  oGet18:disable();  oGet19:disable();  oGet20:disable()
	endif
    /*******************************************************/
	//lin,col            col,lin
	oPnl5:=tPanel():New(239,001,,oDlg,,,,,CLR_HGRAY,520,030)
	cLabelText := "TRATAMENTO TERMICO"
	oCombo3 := TComboBox():New(003,003,{|u|if(PCount()>0,cCombo3:=u,cCombo3)},aIComb3,120,20,oPnl5,,{||   },,,,.T.,,,,,,,,,'cCombo3', cLabelText, nLabelPos)
	cLabelText := "MATERIAL DE PARTIDA"
	oCombo4 := TComboBox():New(003,133,{|u|if(PCount()>0,cCombo4:=u,cCombo4)},aIComb4,120,20,oPnl5,,{||   },,,,.T.,,,,,,,,,'cCombo4', cLabelText, nLabelPos)
	cLabelText := "TIPO CORPO DE PROVA"
	oCombo5 := TComboBox():New(003,263,{|u|if(PCount()>0,cCombo5:=u,cCombo5)},aIComb5,120,20,oPnl5,,{||   },,,,.T.,,,,,,,,,'cCombo5', cLabelText, nLabelPos)
	cLabelText := "SENTIDO CORPO DE PROVA"
	oCombo6 := TComboBox():New(003,393,{|u|if(PCount()>0,cCombo6:=u,cCombo6)},aIComb6,120,20,oPnl5,,{||   },,,,.T.,,,,,,,,,'cCombo6', cLabelText, nLabelPos)
	if nOpc == 3
		oCombo3:disable(); oCombo4:disable(); oCombo5:disable(); oCombo6:disable()
	endif
    /*******************************************************/
	//lin,col            col,lin
	oPnl6:=tPanel():New(271,001,,oDlg,,,,,CLR_HGRAY,520,030)
	@ 001, 001 SAY oSay PROMPT "Obs: " SIZE 090, 007 OF oPnl6 COLORS 0, 16777215 PIXEL
	@ 001, 015 GET oMultiGe VAR mZSOBS OF oPnl6 MULTILINE SIZE 500, 025 COLORS 0, 16777215 HSCROLL PIXEL
	if nOpc == 3
		oMultiGe:disable()
	endif
    /*******************************************************/

	ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function confCor(nOpc)

	Local lRet := .t.
	Local nId  := 0
	Local nInc := 0
	Local lIncZL := .f.

	if nOpc < 0 .or. nOpc > 3
		MsgInfo("A operacao que esta sendo usada esta incorreta. Favor falar com responsavel sistema! ","Atencao")
		Return .f.
	endif

	if nOpc == 1 .or. nOpc == 2

		if empty(oCombo1:aItems[oCombo1:nAt])
			MsgInfo("Norma técnica deve ser preenchida ! ","Atencao")
			Return .f.
		endif
		if empty(oCombo2:aItems[oCombo2:nAt])
			MsgInfo("Norma Dimencional deve ser preenchida ! ","Atencao")
			Return .f.
		endif
		cZSIDNORMA := Posicione("SZN",1,xFilial("SZN")+oCombo1:aItems[oCombo1:nAt],"ZN_IDNORMA")
		cZSNORMADI := oCombo2:aItems[oCombo2:nAt]
		cZSTERMICO := substr(oCombo3:aItems[oCombo3:nAt],1,3)
		cZSMPARTID := substr(oCombo4:aItems[oCombo4:nAt],1,3)
		cZSTIPCORP := substr(oCombo5:aItems[oCombo5:nAt],1,3)
		cZSSENCORP := substr(oCombo6:aItems[oCombo6:nAt],1,3)

		/*
		if empty(oCombo3:aItems[oCombo3:nAt])
			MsgInfo("tratamento térmico deve ser preenchida ! ","Atencao")
			Return .f.
		endif

		if empty(oCombo4:aItems[oCombo4:nAt])
			MsgInfo("Material de partida deve ser preenchida ! ","Atencao")
			Return .f.
		endif

		if empty(oCombo5:aItems[oCombo5:nAt])
			MsgInfo("Tipo corpo prova deve ser preenchida ! ","Atencao")
			Return .f.
		endif

		if empty(oCombo6:aItems[oCombo6:nAt])
			MsgInfo("Sentido corpo prova deve ser preenchida ! ","Atencao")
			Return .f.
		endif
		*/

		if !(nZSFASE1 != 0 .and. nZSFASE2 != 0 .and. nZSFASE3 != 0 .and. nZSMEDIA != 0 .and. nZSTEMP != 0) .and. ;
				!(nZSFASE1 == 0 .and. nZSFASE2 == 0 .and. nZSFASE3 == 0 .and. nZSMEDIA == 0 .and. nZSTEMP == 0)
			MsgInfo("Todos os valores Teste de impacto devem estar preenchidos ou todos não preenchidos ! ","Atencao")
			Return .f.
		endif

		Do Case
		Case nZNTRACAO1 > nZSTRACAO .or. nZNTRACAO2 < nZSTRACAO
			MsgInfo("Valor LIMITE DE TRAÇÃO fora da faixa - Min "+transform(nZNTRACAO1,"@E 99,999,999.99999")+" Máx "+transform(nZNTRACAO1,"@E 99,999,999.99999")+" ! ","Atencao")
			Return .f.
		Case nZNESCOA1 > nZSESCOA .or. nZNESCOA2 < nZSESCOA
			MsgInfo("Valor LIMITE ESCOAMENTO fora da faixa - Min "+transform(nZNESCOA1,"@E 99,999,999.99999")+" Máx "+transform(nZNESCOA2,"@E 99,999,999.99999")+" ! ","Atencao")
			Return .f.
		Case nZNALONG1 > nZSALONG .or. nZNALONG2 < nZSALONG
			MsgInfo("Valor ALONGAMENTO fora da faixa - Min "+transform(nZNALONG1,"@E 99,999,999.99999")+" Máx "+transform(nZNALONG2,"@E 99,999,999.99999")+" ! ","Atencao")
			Return .f.
		Case nZNESTRIC1 > nZSESTRIC .or. nZNESTRIC2 < nZSESTRIC
			MsgInfo("Valor ESTRICÇÃO fora da faixa - Min "+transform(nZNESTRIC1,"@E 99,999,999.99999")+" Máx "+transform(nZNESTRIC2,"@E 99,999,999.99999")+" ! ","Atencao")
			Return .f.
		Case nZNDUREZ11 > nZSDUREZ1 .or. nZNDUREZ12 < nZSDUREZ1
			MsgInfo("Valor DUREZA BRINNEL 1 fora da faixa - Min "+transform(nZNDUREZ11,"@E 99,999,999.99999")+" Máx "+transform(nZNDUREZ12,"@E 99,999,999.99999")+" ! ","Atencao")
			Return .f.
		Case nZNDUREZ21 > nZSDUREZ2 .or. nZNDUREZ22 < nZSDUREZ2
			MsgInfo("Valor DUREZA BRINNEL 2 fora da faixa - Min "+transform(nZNDUREZ21,"@E 99,999,999.99999")+" Máx "+transform(nZNDUREZ22,"@E 99,999,999.99999")+" ! ","Atencao")
			Return .f.
		EndCase

		Do Case
		Case nZNFASE1 > nZSFASE1
			MsgInfo("Valor FASE1 abaixo do mínimo "+transform(nZNFASE1,"@E 99,999,999.99999")+" ! ","Atencao")
			Return .f.
		Case nZNFASE2 > nZSFASE2
			MsgInfo("Valor FASE2 abaixo do mínimo "+transform(nZNFASE2,"@E 99,999,999.99999")+" ! ","Atencao")
			Return .f.
		Case nZNFASE3 > nZSFASE3
			MsgInfo("Valor FASE3 abaixo do mínimo "+transform(nZNFASE3,"@E 99,999,999.99999")+" ! ","Atencao")
			Return .f.
		Case nZNMEDIA > nZSMEDIA
			MsgInfo("Valor MEDIA abaixo do mínimo "+transform(nZNMEDIA,"@E 99,999,999.99999")+" ! ","Atencao")
			Return .f.
		Case nZNTEMP > nZSTEMP
			MsgInfo("Valor TEMPERATURA abaixo do mínimo "+transform(nZNTEMP,"@E 99,999,999.99999")+" ! ","Atencao")
			Return .f.
		EndCase

		if !verExce(cZSIDNORMA,oBrw:aCols)
			Return .f.
		endif
		nInc += 1

	elseif nOpc == 3
		for nId := 1 to len(oBrw:aCols)
			nInc += 1
		next
	endif

	if MsgYesNo("Confirma a "+aOperacao[nOpc]+" da Corrida: "+alltrim(cZSCORRIDA)+" ?","ATENÇÃO","YESNO")

		if nOpc == 1
			if SZS->(RecLock("SZS",.t.))
				SZS->ZS_FILIAL := SZS->(xfilial())
				SZS->ZS_RI     := cZSRI
				SZS->ZS_CORRIDA:= cZSCORRIDA
			else
				lRet := .f.
			endif
		elseif !SZS->(RecLock("SZS",.f.))
			lRet := .f.
		endif
		if lRet
			if nOpc == 3
				SZS->(DbDelete())
			else
				SZS->ZS_IDNORMA := cZSIDNORMA
				SZS->ZS_NORMADI := cZSNORMADI

				SZS->ZS_TRACAO := nZSTRACAO
				SZS->ZS_ESCOA  := nZSESCOA
				SZS->ZS_ALONG  := nZSALONG
				SZS->ZS_ESTRIC := nZSESTRIC
				SZS->ZS_DUREZ1 := nZSDUREZ1
				SZS->ZS_DUREZ2 := nZSDUREZ2

				SZS->ZS_FASE1 := nZSFASE1
				SZS->ZS_FASE2 := nZSFASE2
				SZS->ZS_FASE3 := nZSFASE3
				SZS->ZS_MEDIA := nZSMEDIA
				SZS->ZS_TEMP  := nZSTEMP

				SZS->ZS_TERMICO := cZSTERMICO
				SZS->ZS_MPARTID := cZSMPARTID
				SZS->ZS_TIPCORP := cZSTIPCORP
				SZS->ZS_SENCORP := cZSSENCORP

				SZS->ZS_OBS := mZSOBS

			endif
		endif
		SZS->(MsUnLock())

		if lRet .and. nInc > 0
			SZL->(dbSetOrder(1))
			for nId := 1 to len(oBrw:aCols)
				if !empty(oBrw:aCols[nId,2])
					lIncZL := .f.
					if !SZL->(dbSeek(xFilial("SZL") + cZSRI + oBrw:aCols[nId,1]))
						lIncZL := .t.
					endif
					if nOpc == 1 .or. lIncZL
						if !oBrw:aCols[nId,len(oBrw:aCols[nId])]
							if SZL->(RecLock("SZL",.t.))
								SZL->ZL_FILIAL := SZL->(xfilial())
								SZL->ZL_RI     := cZSRI
								SZL->ZL_ITEM   := oBrw:aCols[nId,1]
								SZL->ZL_SIMBOLO:= oBrw:aCols[nId,2]
								SZL->ZL_VALOR  := oBrw:aCols[nId,6]
							else
								lRet := .f.
							endif
						endif
					elseif SZL->(RecLock("SZL",.f.))
						if nOpc == 3 .or. oBrw:aCols[nId,len(oBrw:aCols[nId])]
							SZL->(DbDelete())
						else
							SZL->ZL_SIMBOLO:= oBrw:aCols[nId,2]
							SZL->ZL_VALOR  := oBrw:aCols[nId,6]
						endif
					else
						lRet := .f.
					endif
					SZL->(MsUnLock())
				endif
			next
		endif

		if !lRet
			MsgInfo("Problemas nas garavações das operações, favor verificar os dados da Corrida ! ","Atencao")
		endif
	else
		lRet := .f.
	endif

Return lRet


Static Function PopCombo1(nOpc)

	Local cSql := ""
	Local cTrb := ""
	Local aICombo := {  }

	if nOpc == 1
		Aadd(aICombo, space(TamSx3("ZN_NORMA")[1]) )
	endif

	cSql := "select * from "+RetSQLName("SZN")+" zn where zn_filial = '"+xFilial("SZN")+"' and zn.d_e_l_e_t_ = ' '"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	while !(ctrb)->( Eof() )
		Aadd(aICombo, alltrim((ctrb)->ZN_NORMA) )
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

return aICombo

Static Function PopCombo2(nOpc)

	Local cSql := ""
	Local cTrb := ""
	Local aICombo := {  }

	if nOpc == 1
		Aadd(aICombo, space(TamSx3("ZP_NORMA")[1]) )
	endif

	cSql := "select * from "+RetSQLName("SZP")+" zp where zp_filial = '"+xFilial("SZP")+"' and zp.d_e_l_e_t_ = ' '"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	while !(ctrb)->( Eof() )
		Aadd(aICombo, alltrim((ctrb)->ZP_NORMA) )
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

return aICombo

Static Function PopNorma(cNorma)

	if AtuVarNor(cNorma,1,"I")

		oBrw:SetArray(PopBrw(szn->zn_idnorma),.T.)
		oBrw:Refresh()

		oCombo3:aitems := PopCombo('TX',szn->zn_idnorma) //{"TRATAMENTO TERMICO"}
		oCombo3:Refresh()
		oCombo4:aitems := PopCombo('PM',szn->zn_idnorma) //{"MATERIAL DE PARTIDA"}
		oCombo4:Refresh()
		oCombo5:aitems := PopCombo('TO',szn->zn_idnorma) //{"TIPO CORPO DE PROVA"}
		oCombo5:Refresh()
		oCombo6:aitems := PopCombo('SU',szn->zn_idnorma) //{"SENTIDO CORPO DE PROVA"}
		oCombo6:Refresh()
		oCombo6:nAt := oCombo5:nAt := oCombo4:nAt := oCombo3:nAt := 1

	endif

return

Static Function AtuVarNor(cNormaI,nOrd,cIni)

	Local lRet := .f.

	szn->(dbSetOrder(nOrd))
	If szn->(dbSeek(xFilial("SZN")+cNormaI))
		lRet := .t.

		cZSIDNORMA	:= SZN->ZN_IDNORMA
		nZNTRACAO1	:= SZN->ZN_TRACAO1
		nZNTRACAO2	:= SZN->ZN_TRACAO2
		nZNESCOA1	:= SZN->ZN_ESCOA1
		nZNESCOA2	:= SZN->ZN_ESCOA2
		nZNALONG1	:= SZN->ZN_ALONG1
		nZNALONG2	:= SZN->ZN_ALONG2
		nZNESTRIC1	:= SZN->ZN_ESTRIC1
		nZNESTRIC2	:= SZN->ZN_ESTRIC2
		nZNDUREZ11	:= SZN->ZN_DUREZ11
		nZNDUREZ12	:= SZN->ZN_DUREZ12
		nZNDUREZ21	:= SZN->ZN_DUREZ21
		nZNDUREZ22	:= SZN->ZN_DUREZ22

		nZNFASE1	:= SZN->ZN_FASE1
		nZNFASE2	:= SZN->ZN_FASE2
		nZNFASE3	:= SZN->ZN_FASE3
		nZNMEDIA	:= SZN->ZN_MEDIA
		nZNTEMP	   := SZN->ZN_TEMP

		if cIni == "I"
			nZSTRACAO:= 0
			nZSESCOA	:= 0
			nZSALONG	:= 0
			nZSESTRIC:= 0
			nZSDUREZ1:= 0
			nZSDUREZ2:= 0

			nZSFASE1	:= 0
			nZSFASE2	:= 0
			nZSFASE3	:= 0
			nZSMEDIA	:= 0
			nZSTEMP	:= 0
		endif

	endif

return lRet

Static Function PopBrw(cIdNorma)

	Local cSql := ""
	Local cTrb := ""
	Local aCols := {}

	cSql := "select ZT_ITEM, ZT_SIMBOLO, substr(x5_descri,1,40) ZT_NOME, ZT_MIN, ZT_MAX from "+RetSQLName("SZT")+" zt "
	cSql += "inner join "+RetSQLName("SX5")+" x5 on x5_filial = '"+xFilial("SX5")+"' and x5_tabela = 'TR' and x5_chave = zt_simbolo and x5.d_e_l_e_t_ = ' '"
	cSql += "where zt_filial = '"+xFilial("SZT")+"' and zt_idnorma = '"+cIdNorma+"' and zt.d_e_l_e_t_ = ' '"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	if (ctrb)->( Eof() )
		Aadd(aCols, { '01',space(02),space(15),0,0,0, .f. })
	else
		while !(ctrb)->( Eof() )
			Aadd(aCols, { (ctrb)->ZT_ITEM, (ctrb)->ZT_SIMBOLO, (ctrb)->ZT_NOME, (ctrb)->ZT_MIN, (ctrb)->ZT_MAX, 0, .f. })
			(ctrb)->( DbSkip() )
		End
	endif
	(ctrb)->( DbCloseArea() )

return acols

Static Function PopBrwRI(cRi,cIdNorma)

	Local cSql := ""
	Local cTrb := ""
	Local aCols := {}

	cSql := "select ZL_ITEM, ZL_SIMBOLO, substr(x5_descri,1,40) ZL_NOME, ZT_MIN ZL_MIN, ZT_MAX ZL_MAX,ZL_VALOR from "+RetSQLName("SZL")+" zl "
	cSql += "inner join "+RetSQLName("SZT")+" zt on zt_filial = '"+xFilial("SZT")+"' and zt_idnorma = '"+cIdNorma+"' and zt_simbolo = zl_simbolo and zt.d_e_l_e_t_ = ' '"
	cSql += "inner join "+RetSQLName("SX5")+" x5 on x5_filial = '"+xFilial("SX5")+"' and x5_tabela = 'TR' and x5_chave = zl_simbolo and x5.d_e_l_e_t_ = ' '"
	cSql += "where zl_filial = '"+xFilial("SZL")+"' and zl_ri = '"+cRi+"' and zl.d_e_l_e_t_ = ' '"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	if (ctrb)->( Eof() )
		Aadd(aCols, { '01',space(02),space(15),0,0,0, .f. })
	else
		while !(ctrb)->( Eof() )
			Aadd(aCols, { (ctrb)->ZL_ITEM, (ctrb)->ZL_SIMBOLO, (ctrb)->ZL_NOME, (ctrb)->ZL_MIN, (ctrb)->ZL_MAX, (ctrb)->ZL_VALOR, .f. })
			(ctrb)->( DbSkip() )
		End
	endif
	(ctrb)->( DbCloseArea() )

return acols

Static Function PopCombo(cTabSX5,cIdNorma)

	Local cSql := ""
	Local cTrb := ""
	Local aCols := {}

	Aadd(aCols, space(30) )

	cSql := "select ZE_ITEM, substr(x5_descri,1,30) ZE_NOME from "+RetSQLName("SZE")+" ze "
	cSql += "inner join "+RetSQLName("SX5")+" x5 on x5_filial = '"+xFilial("SX5")+"' and x5_tabela = ze_tabsx5 and x5_chave = ze_item and x5.d_e_l_e_t_ = ' '"
	cSql += "where ze_filial = '"+xFilial("SZE")+"' and ze_idnorma = '"+cIdNorma+"' and ze_tabsx5 = '"+cTabSX5+"' and ze.d_e_l_e_t_ = ' '"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	while !(ctrb)->( Eof() )
		Aadd(aCols, (ctrb)->ze_item+"-"+(ctrb)->ze_nome )
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

return acols


User Function VLimEle(oObj,cIdNorma)

	Local lRet := .t.
	Local nLin := oObj:nAt
	Local nCol := oObj:oBrowse:nColPos
	//Local nTotLin := Len(oObj:aCols)
	Local nValMin := oObj:aCols[nLin,4]
	//Local nValDig := oObj:aCols[nLin,nCol]
	Local nIx  := 0
	Local cSql := ""
	Local cTrb := ""

	if nCol == 2

		for nIx := 1 to len(oObj:aCols)
			if M->ZT_SIMBOLO == oObj:aCols[nIx,2] .and. nLin != nIx
				msginfo("O mesmo símbolo já foi digitado !")
				//oObj:aCols[nLin,nCol+1] := " "
				lRet := .F.
			endif
		next
		cSql := "select * from "+RetSQLName("SX5")+" x5 where x5_filial = '"+xFilial("SX5")+"' and x5_tabela = 'TR' and x5_chave = '"+M->ZT_SIMBOLO+"' and x5.d_e_l_e_t_ = ' '"
		cSql := ChangeQuery( cSql )
		cTrb := GetNextAlias()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
		if (ctrb)->( Eof() )
			msginfo("Não encontrou elemento na Tabela elementos quimicos (SX5-TR) !")
			oObj:aCols[nLin,nCol+1] := " "
			lRet := .F.
		else
			oObj:aCols[nLin,nCol+1] := substr((ctrb)->X5_DESCRI,1,15)
		endif
		(ctrb)->( DbCloseArea() )

	elseif nCol == 6

		if nValMin == -1
			nValMin := 0
		endif

		if M->ZT_VALOR <= nValMin
			msginfo("Percentual da corrida digitado esta incorreto !")
			lRet := .F.
		endif

	endif

	oObj:Refresh(.t.)

return lRet

User Function VExclusao(oObj)

	Local lRet := .t.
	Local nValMin := oObj:aCols[oObj:nAt,4]

	if nValMin != -1
		msginfo("Este elemento não pode ser excluído !")
		lRet := .f.
	endif

return lRet


Static Function verExce(cIdNorma,aBrw)

	Local lRet := .t.
	Local cSql := ""
	Local cTrb := ""

	Local nValMin := 0
	Local nValMax := 0
	Local nValDig := 0

	Local cFormul := ""
	Local cLimexc := ""
	Local cVlIni := ""
	Local cCompar := ""
	Local cVlLim  := ""

	Local nId := 0

	for nId := 1 to len(aBrw)
		if !empty(aBrw[nId,2]) .and. !aBrw[nId,len(aBrw[nId])]
			nValMin := aBrw[nId,4]
			if nValMin == -1
				nValMin := 0
			endif
			nValMax := aBrw[nId,5]
			nValDig := aBrw[nId,6]
			if nValDig != 0
				cSql := "select zf_elemen,zf_sequen,zf_descri,zf_formul,zf_compar,zf_limexc,zu_sequen,zu_valor from "+RetSQLName("SZU")+" zu "
				cSql += "inner join "+RetSQLName("SZF")+" zf on zf_filial = '"+xFilial("SZF")+"' and zf_elemen = zu_elemen and zf_sequen = zu_sequen and zf.d_e_l_e_t_ = ' ' "
				cSql += "where zu_filial = '"+xFilial("SZU")+"' and zu_idnorma = '"+cIdNorma+"' and zu_elemen = '"+aBrw[nId,2]+"' and zu.d_e_l_e_t_ = ' ' "
				cSql += "order by zu_elemen,zu_sequen"
				cSql := ChangeQuery( cSql )
				cTrb := GetNextAlias()
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
				if !(ctrb)->( Eof() )
					while !(ctrb)->( Eof() )
						cFormul := alltrim((ctrb)->zf_formul)
						cVlIni := verFormul(cFormul,aBrw)
						cCompar := (ctrb)->zf_compar
						cLimexc := alltrim((ctrb)->zf_limexc)
						if cLimexc == '##'
							cVlLim := alltrim(str((ctrb)->zu_valor))
						else
							cVlLim := verFormul(cLimexc,aBrw)
						endif
						if substr(cVlIni,1,5) == "Error"
							msginfo(cVlIni+" não preenchido corretamente, segundo o critério "+alltrim((ctrb)->zf_descri)+" !")
							Return .f.
						elseif substr(cVlLim,1,5) == "Error"
							msginfo(cVlLim+" não preenchido corretamente, segundo a critério "+alltrim((ctrb)->zf_descri)+" !")
							Return .f.
						else
							cFormul := cVlIni+cCompar+cVlLim
							if !&cFormul
								(ctrb)->( DbCloseArea() )
								msginfo("Percentual da corrida digitado no item "+strzero(nId,2)+" ultrapassou seu limite de "+alltrim(str(&cVlLim))+" na exceção !")
								Return .f.
							endif
						endif
						(ctrb)->( DbSkip() )
					End
				elseif nValDig > nValMax
					(ctrb)->( DbCloseArea() )
					msginfo("Percentual da corrida digitado no item "+strzero(nId,2)+" ultrapassou seu limite de "+alltrim(str(nValMax))+" !")
					Return .f.
				endif
				(ctrb)->( DbCloseArea() )
			else
				MsgInfo("Verifique preenchimento do Componente químico item "+aBrw[nId,1]+" ! ","Atencao")
				Return .f.
			endif
		endif
	next

	cSql := "select zf_elemen,zf_sequen,zf_descri,zf_formul,zf_compar,zf_limexc,zu_sequen,zu_valor from "+RetSQLName("SZU")+" zu "
	cSql += "inner join "+RetSQLName("SZF")+" zf on zf_filial = '"+xFilial("SZF")+"' and zf_elemen = zu_elemen and zf_sequen = zu_sequen and zf.d_e_l_e_t_ = ' ' "
	cSql += "where zu_filial = '"+xFilial("SZU")+"' and zu_idnorma = '"+cIdNorma+"' and zu_elemen = '**' and zu.d_e_l_e_t_ = ' ' "
	cSql += "order by zu_elemen,zu_sequen"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	while !(ctrb)->( Eof() )
		cFormul := alltrim((ctrb)->zf_formul)
		cVlIni := verFormul(cFormul,aBrw)
		cCompar := (ctrb)->zf_compar
		cLimexc := alltrim((ctrb)->zf_limexc)
		if cLimexc == '##'
			cVlLim := alltrim(str((ctrb)->zu_valor))
		else
			cVlLim := verFormul(cLimexc,aBrw)
		endif
		if substr(cVlIni,1,5) == "Error"
			msginfo(cVlIni+" não preenchido corretamente, segundo o critério "+alltrim((ctrb)->zf_descri)+" !")
			Return .f.
		elseif substr(cVlLim,1,5) == "Error"
			msginfo(cVlLim+" não preenchido corretamente, segundo o critério "+alltrim((ctrb)->zf_descri)+" !")
			Return .f.
		else
			cFormul := cVlIni+cCompar+cVlLim
			if !&cFormul
				(ctrb)->( DbCloseArea() )
				msginfo("Percentuais digitados nos elementos químicos não estão corretos segundo o critério "+alltrim((ctrb)->zf_descri)+" !")
				Return .f.
			endif
		endif
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

Return lRet


Static Function verFormul(cFormul,aBrw)

	Local cRet := cFormul
	Local cQual := ""
	Local cEleme := ""
	Local nVlSubs := 0
	Local nValMin := 0
	Local nValMax := 0
	Local nValDig := 0
	Local nIx := 0
	Local nI := 0

	for nIx := 1 to len(cFormul)
		if substr(cFormul,nIx,1) $ 'M|m|$|&|V' .and. empty(cQual)
			cQual := substr(cFormul,nIx,1)
		elseif substr(cFormul,nIx,1) != "["
			if substr(cFormul,nIx,1) == "]"
				if cQual ==  "&"
					if substr(cEleme,1,2) == "TX" .and. substr(cEleme,3,6) != cZSTERMICO
						Return "Error Tratamento Térmico"
					elseif substr(cEleme,1,2) == "PM" .and. substr(cEleme,3,6) != cZSMPARTID
						Return "Error Material de partida"
					elseif substr(cEleme,1,2) == "TO" .and. substr(cEleme,3,6) != cZSTIPCORP
						Return "Error Tipo Corpo de Prova"
					elseif substr(cEleme,1,2) == "SU" .and. substr(cEleme,3,6) != cZSSENCORP
						Return "Error Sentido Corpo de Prova"
					endif
					cRet := replace(cRet,cQual+"["+cEleme+"]","" )
				else
					nVlSubs := 0
					if cQual == 'V'
						if valtype(&cEleme) == 'N'
							nVlSubs := &cEleme
						else
							nVlSubs := 0
						endif
					else
						nI := aScan(aBrw,{|x| alltrim(x[2])==cEleme})
						if nI > 0
							nValMin := aBrw[nI,4]
							if nValMin == -1
								nValMin := 0
							endif
							nValMax := aBrw[nI,5]
							nValDig := aBrw[nI,6]
							if cQual == '$'
								nVlSubs := nValDig
							elseif cQual == 'M'
								nVlSubs := nValMax
							elseif cQual == 'm'
								nVlSubs := nValMin
							endif
						endif
					endif
					cRet := replace(cRet,cQual+"["+cEleme+"]",alltrim(str(nVlSubs)) )
				endif
				cQual := ''
				cEleme := ""
			elseif !empty(cQual)
				cEleme += substr(cFormul,nIx,1)
			endif
		endif
	next
return cRet
