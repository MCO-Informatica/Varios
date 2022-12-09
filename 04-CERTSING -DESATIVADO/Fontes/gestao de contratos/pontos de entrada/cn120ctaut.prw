#Include 'Protheus.ch'
//--------------------------------------------------------------------------
// Rotina | CN120CTAUT | Autor | Robson Goncalves        | Data | 27.05.2015
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada que permite permite um tratamento automático no 
//        | momento de realizar a medição de um contrato, retornando em tela 
//        | o contrato e a competência que devem ser medidas sem a necessidade 
//        | de inclusão manual. 
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function CN120CTAUT()
	Local aTela := {}
	Local aParamBox := {}
	Local aRet := {}
	Local cBkp := ''
	
	// Criar consulta SXB.
	CriaSXB()
	
	//ALERT("CN120CTAUT")

	If ValType(cCadastro)=='C'
		cBkp := cCadastro
		cCadastro := 'Medição/Entrega'
	Endif
	
	AAdd(aParamBox,{1,'Nr. Contrato',Space(Len(CN9->CN9_NUMERO)),'','ExistCpo("CN9",MV_PAR01)','CN120A','',0,.T.})
	
	If ParamBox(aParamBox,'Competência',@aRet,,,,,,,,.F.,.F.)
		CN9->( dbSetOrder(7) )
		CN9->( dbSeek( xFilial('CN9') + aRet[ 1 ] + '05' ) )
		IF CN9->CN9_DTFIM < dDataBase
			MsgAlert('Atenção,' + CRLF + 'O contrato ' + CN9->CN9_NUMERO + ' não está vigente, verifique antes de prosseguir com a medição.',cCadastro) 
			Return
		EndIF
		
		AAdd( aTela, aRet[ 1 ] )
		AAdd( aTela, Space( Len( CN9->CN9_REVISA ) ) )
		AAdd( aTela, StrZero( Month( dDataBase ), 2, 0 ) + '/' + StrZero( Year( dDataBase ), 4, 0 ) )
	Else
		AAdd( aTela, Space( Len( CN9->CN9_NUMERO ) ) )
		AAdd( aTela, Space( Len( CN9->CN9_REVISA ) ) )
		AAdd( aTela, Space( Len( CNF->CNF_COMPET ) ) )
	Endif
	
	If cBkp <> ''
		cCadastro := cBkp
	Endif
	
Return( aTela )

//--------------------------------------------------------------------------------------------------
// Rotina | CNDMedEsp | Autor | Robson Gonçalves | Data | 03/05/2017
//--------------------------------------------------------------------------------------------------
// Descr. | Esta rotina é uma cópia da rotina padrão da data de 14/04/2017 P11.
//        | Foi necessário esta adaptação porque após atualização do repositório surgiram problemas.
//--------------------------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//--------------------------------------------------------------------------------------------------
User Function CNDMedEsp()
Local aArea     := GetArea()
Local aGrp   	:= {}
Local aTamCab	:= {}
Local aButtons	:= {}
Local aCN120CMP := {}

Local cGrps     := ""
Local cQuery    := ""
Local cQuery1   := ""
Local cQuery2   := ""
Local cQuery3   := ""
Local cQuery4   := ""
Local cQuery5   := ""
Local cCod      := RetCodUsr()
Local cQueryPE  := ""

Local lVldVige  := GetNewPar("MV_CNFVIGE","N") == "N"
Local lRet      := .F.

Local nSavQual  := 0
Local nX        := 0
Local nOpca		:= 0
Local nNovaOrd	:= 0
Local oQual
Local oPanel
Local oDlgMedEsp

Local lPrjCni := FindFunction("ValidaCNI") .And. ValidaCNI()

PRIVATE aCab	   := {}
PRIVATE aCampos	   := {}
PRIVATE aArrayF4   := {}

dbSelectArea("CNN")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Grupos do usuario                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aGrp := UsrRetGrp(UsrRetName(cCod))

For nX:=1 to len(aGrp)
	cGrps += "'"+aGrp[nX]+"',"
Next
cGrps := SubStr(cGrps,1,len(cGrps)-1)

cQuery1 := " SELECT CN9_NUMERO, MAX(CN9_REVISA) AS CN9_REVISA"
If CN9->(FieldPos("CN9_FILCTR")) > 0
	cQuery1 += ", CN9_FILCTR "
EndIf
cQuery1 += " FROM " + RetSqlName("CN9") + " CN9 , "+ RetSqlName("CNN") + " CNN "
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³JBS 23/07/2015 - Tratamento para identificar se a empresa compartilha a medição de contratos³
//³                              Entre Filiais autorizadas                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(AliasInDic("CPD") .And. SuperGetMv("MV_GCT3MEL",.F.,"N") == "S")  // JBS - 23/07/2015 - Não Compartilha medição
    cQuery1 += " WHERE CN9_FILIAL = '"+xFilial("CN9",cFilAnt)+"' AND CN9_SITUAC   = '05' AND "
Else  // JBS - 23/07/2015 - Compartilha e busca todos os contratos de outras filiais nos quais a filial atual esta autorizada e efetuar medição
	cQuery1 += ", "+ RetSqlName("CPD") + " CPD "
    cQuery1 += " WHERE CN9_SITUAC   = '05' AND "
	cQuery1 += " CPD.CPD_FILAUT = '"+FWCodFil()+"' AND " //'"+cFilAnt+"' AND "
	cQuery1 += " CPD.CPD_CONTRA = CN9.CN9_NUMERO AND "
EndIf

If lVldVige
	cQuery1 += " ('"+DToS(dDataBase)+"' BETWEEN CN9_DTINIC AND CN9_DTFIM )  AND "
EndIf
cQuery1+= " CNN.CNN_FILIAL = CN9_FILIAL AND "
cQuery1+= " CNN.CNN_CONTRA = CN9_NUMERO AND "

If CN9->(FieldPos("CN9_VLDCTR"))> 0
	cQuery2 := " CN9_VLDCTR ='2' "
	cQuery3 := " CN9_VLDCTR IN(' ','1') AND (CNN.CNN_USRCOD   = '"+ cCod +"'"
	If len(aGrp) > 0
		cQuery3 += " OR CNN.CNN_GRPCOD IN ("+ cGrps +"))"
	Else
	    cQuery3 += ")"
	EndIf
Else
	cQuery3:= " (CNN.CNN_USRCOD   = '"+ cCod +"'"
	If len(aGrp) > 0
		cQuery3+= " OR CNN.CNN_GRPCOD IN ("+ cGrps +"))"
	Else
		cQuery3+=")"
	EndIf
EndIf

cQuery4 := " AND CNN.D_E_L_E_T_	= '' "
cQuery4 += " AND CN9.D_E_L_E_T_	= '' "
If AliasInDic("CPD") .And. SuperGetMv("MV_GCT3MEL",.F.,"N") == "S"
	cQuery4 += " AND CPD.D_E_L_E_T_	= '' "
EndIf
cQuery4 += " GROUP BY CN9_NUMERO"
If CN9->(FieldPos("CN9_FILCTR")) > 0
	cQuery4 += ", CN9_FILCTR "
EndIf
cQuery5 := " ORDER BY CN9_NUMERO,CN9_REVISA"
If CN9->(FieldPos("CN9_FILCTR")) > 0
	cQuery5 += ", CN9_FILCTR "
EndIf

If CN9->(FieldPos("CN9_VLDCTR"))> 0
	cQuery := cQuery1
    cQuery += cQuery2+" "+cQuery4
    cQuery += " UNION "
    cQuery += cQuery1
    cQuery += cQuery3+" "+cQuery4+" "+cQuery5
Else
	cQuery := cQuery1
    cQuery += cQuery3+" "+cQuery4+" "+cQuery5
EndIf

If lPrjCni
	// FSW - Ponto de entrada para refazer a query retirando os contratos compartilhados
	If Existblock('CN120QCC')
		cQueryPE := Execblock('CN120QCC', .F., .F., {cQuery1, cQuery2, cQuery3, cQuery4, cQuery5})
		cQuery   := If(ValType(cQueryPE)=='C', cQueryPE, cQuery)
	Endif
EndIf

//ALERT("ANTES DO PE CN120ESY")


If Existblock('CN120ESY')
	cQueryPE := Execblock('CN120ESY', .F., .F., {cQuery})
	cQuery   := If(ValType(cQueryPE)=='C', cQueryPE, cQuery)
Endif

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCN9",.F.,.T.)

If !TRBCN9->(Eof())
	DbSelectArea("SX3")
	DbSetOrder(2)

	MsSeek("CN9_NUMERO")

	AAdd(aCab,x3Titulo())
	Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})

	MsSeek("CN9_REVISA")

	AAdd(aCab,x3Titulo())
	Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})

	If CN9->(FieldPos("CN9_FILCTR")) > 0
		MsSeek("CN9_FILCTR")

		AAdd(aCab,x3Titulo())
		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
	EndIf

	If Existblock('CN120CMP')
		aCN120CMP :=	Execblock('CN120CMP', .F., .F., {aCab,aCampos})

		If Valtype(aCN120CMP) == "A"
			If Len(aCN120CMP)>=1 .And. Valtype(aCN120CMP[1]) == "A"
				aCab   := aClone(aCN120CMP[1])
			EndIf

			If Len(aCN120CMP)>=2 .And. Valtype(aCN120CMP[2]) == "A"
				aCampos:= aClone(aCN120CMP[2])
			EndIf
		Endif
	EndIf
EndIf

While !TRBCN9->(Eof())
	Aadd(aArrayF4,Array(Len(aCampos)))

	For nX := 1 to Len(aCampos)
		aArrayF4[Len(aArrayF4)][nX] := TRBCN9->(FieldGet(FieldPos(aCampos[nX][1])))
	Next
	dbSelectArea("TRBCN9")
	dbSkip()
EndDo

TRBCN9->(dbCloseArea())

If !Empty(aArrayF4)
	aButtons		:= {{'pesquisa',{||C120PesqP(aCab,aCampos,aArrayF4,oQual)},OemToAnsi("Pesquisar"),OemToAnsi("Pesquisar")} } //"Pesquisar"

	SetKey( VK_F4, { ||C120PesqP(aCab,aCampos,aArrayF4,oQual) } )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta dinamicamente o bline do CodeBlock                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlgMedEsp FROM 30,20  TO 265,521 TITLE OemToAnsi("Contratos") Of oMainWnd PIXEL
	@ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,17 OF oDlgMedEsp CENTERED LOWERED //"Botoes"

	oPanel:Align := CONTROL_ALIGN_TOP
	oQual := TWBrowse():New( 29,4,243,85,,aCab,aTamCab,oDlgMedEsp,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oQual:SetArray(aArrayF4)
	oQual:bLine      := { || aArrayF4[oQual:nAT] }
	oQual:Align      := CONTROL_ALIGN_ALLCLIENT
	oQual:blDblClick := {|| nSavQual:=oQual:nAT,nOpcA := 1,oDlgMedEsp:End()}

	@ 6  ,4   SAY OemToAnsi("Selecione o Contrato") Of oPanel PIXEL SIZE 120 ,9
	ACTIVATE MSDIALOG oDlgMedEsp CENTERED ON INIT EnchoiceBar(oDlgMedEsp,{|| nSavQual:=oQual:nAT,nOpca:=1,oDlgMedEsp:End()},{||oDlgMedEsp:End()},,aButtons)

	If nOpcA == 1
		dbSelectArea("CN9")
		dbSetOrder(1)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no registro da CN9 selecionado        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFilCTR := If(Len(aArrayF4[nSavQual]) >= 3,aArrayF4[nSavQual,3],cFilAnt)
		IF dbSeek(xFilial("CN9",cFilCTR)+aArrayF4[ nSavQual, 1 ]+aArrayF4[ nSavQual,2 ])
			lRet := .T.
			cContra := CN9->CN9_NUMERO
		Else
			lRet := .F.
		EndIf

	EndIF
	//Desabilita na tela da medicao do contrato a tecla F4
	SetKey( VK_F4, Nil )
EndIf
RestArea(aArea)

Return( lRet )

//--------------------------------------------------------------------------
// Rotina | CriaSXB | Autor | Robson Goncalves           | Data | 03.05.2017
//--------------------------------------------------------------------------
// Descr. | Rotina que cria a consulta padrão no dicionário SXB.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function CriaSXB()
	Local aSXB := {}
	Local aCpoXB := {}
	Local nJ
	Local nI

	aCpoXB := {'XB_ALIAS','XB_TIPO','XB_SEQ','XB_COLUNA','XB_DESCRI','XB_DESCSPA','XB_DESCENG','XB_CONTEM','XB_WCONTEM'}
	AAdd( aSXB, { 'CN120A', '1', '01', 'RE', 'Contratos', 'Contratos', 'Contratos', 'SX5'        , '' } )
	AAdd( aSXB, { 'CN120A', '2', '01', '01', ''         , ''         , ''         , 'U_CNDMedEsp()','' } )
	AAdd( aSXB, { 'CN120A', '5', '01', ''  , ''         , ''         , ''         , 'CN9->CN9_NUMERO', '' } )
	AAdd( aSXB, { 'CN120A', '5', '02', ''  , ''         , ''         , ''         , 'CN9->CN9_REVISA', '' } )
	SXB->(dbSetOrder(1))
	For nI := 1 To Len( aSXB )
		If !SXB->(dbSeek(aSXB[nI,1]+aSXB[nI,2]+aSXB[nI,3]+aSXB[nI,4]))
			SXB->(RecLock('SXB',.T.))
			For nJ := 1 To Len( aSXB[nI] )
				SXB->(FieldPut(FieldPos(aCpoXB[nJ]),aSXB[nI,nJ]))
			Next nJ
			SXB->(MsUnLock())
		Endif
	Next nI
Return
