#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#INCLUDE "rwmake.ch"
 
/*/{Protheus.doc} NS0001
@author Felipe Valença(Newsiga)
@since 04/12/2018
@version P12
@type function
/*/

User Function NS0001

	Private oProcess

	Private aHeader 	:= {}
	Private aFields		:= {"Z2_CODIGO","Z2_DESCRI","Z2_UM","Z2_CUSTO","Z2_OBSERV"}
	Private aAltFie1 	:= {"Z2_CODIGO","Z2_DESCRI","Z2_UM","Z2_CUSTO","Z2_OBSERV"}

	Private aHeader2 	:= {}
	Private aFields2	:= {"Z3_CODIGO","Z3_DESCRI","Z3_CUSTO","Z3_FECHAM","Z3_CLASSIF","Z3_OBSERV"}
	Private aAltFie12 	:= {"Z3_CODIGO","Z3_DESCRI","Z3_CUSTO","Z3_FECHAM","Z3_CLASSIF","Z3_OBSERV"}

	Private aColsEx		:= {}
	Private aColsEx2	:= {}
	Private oStatus
	Private oPanel
	Private oDlg
	Private oOK   		:= LoadBitmap( GetResources(), "LBOK"     )
	Private oNO 		:= LoadBitmap( GetResources(), "LBNO"   )

	
	Static oMSNewGe
	Static oMSNewGe2
	//Pergunte(cPerg,.T.)

	oProcess := MsNewProcess():New({|lEnd| RunProc(@oProcess, @lEnd) },"Rotina....","Produtos...",.T.)
	oProcess:Activate()

Return

Static Function RunProc(oProcess, lEnd)

	Local aSize           := {}
	Local aObjects		  := {}
	Local aInfo           := {}
	Local aPosObj		  := {}	
	
	Private cCodProd	:= Space(5)
	Private cDesc		:= Space(30)
	Private cCodRef		:= Space(15)
	Private cDescRef	:= Space(30)
	Private cCodRev		:= ""
	Private dDataRev	:= dDataBase
	Private dDataCria	:= dDataBase
	Private cDescLiv	:= Space(250)
	Private cObs		:= Space(250)
	Private cComposicao := Space(200)
	Private nPesoLiq	:= 0
	Private nPesoBru	:= 0
	Private oCombo	
	Private cCombo		:= "Nao" // Variavel que receberá o conteúdo 
	Private aItem 		:= { "Nao" , "Sim" } // array com os itens
	
	Private oTFont0  := TFont():New( "Arial", , -12)
	//Private oTFont0  := TFont():New( "Arial", , -20)
	Private oTFont1 := TFont():New( "Arial", , -25, ,.T.)

	Default lEnd		:= .F.
	
	aSize := MsAdvSize(.F.)
	// Dados da área de trabalho e separação
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 6 }

	AAdd( aObjects, { 100,80, .T., .F. } ) // Dados da Enchoice
	AAdd( aObjects, { 100,10, .T., .T. } ) // Dados do Objetos Say
	AAdd( aObjects, { 100,10, .T., .T. } ) // Dados do Objetos Say

	//Chama rotina para preencher o cabeçalho com os dados do pedido de venda
	

	// Chama MsObjSize e recebe array e tamanhos
	aPosObj := MsObjSize( aInfo, aObjects,.T.)

	oDlg := MSDialog():New(aSize[7],0,aSize[6],aSize[5],'Rotina - Teste',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	 // Cria objeto Scroll
	 oScroll := TScrollArea():New(oDlg,01,01,01,01)
	 oScroll:Align := CONTROL_ALIGN_ALLCLIENT
	 // Cria painel
	 @ aPosObj[1,1]+3,aPosObj[1,2] MSPANEL oPanel OF oScroll SIZE aPosObj[1,3]-700,aPosObj[1,4]-330 COLOR CLR_HRED
 
	 // Define objeto painel como filho do scroll
	 oScroll:SetFrame( oPanel )
 
	cCodProd := GetSX8Num("SZ1","Z1_CODIGO")
	oGroup1:= TGroup():New(aPosObj[1,1]+3,aPosObj[1,2],aPosObj[3,3]+4,aPosObj[3,4],'',oDlg,,,.T.)
	oSay1 := TSay():New(aPosObj[1,1]+5 ,aPosObj[1,2]+15,{|| "Molde" },oPanel,,oTFont0,,,,.T.,,,300,30)	
	@ aPosObj[1,1]+13,aPosObj[1,2]+13 MSGET cCodProd SIZE 45,9 WHEN .F. OF oPanel PIXEL
	
	oSay1 := TSay():New(aPosObj[1,1]+5 ,aPosObj[1,2]+90,{|| "Descrição" },oPanel,,oTFont0,,,,.T.,,,300,30)
	@ aPosObj[1,1]+13,aPosObj[1,2]+90 MSGET Upper(cDesc) SIZE 190,9 WHEN .T. OF oPanel PIXEL
	
	oSay1 := TSay():New(aPosObj[1,1]+5 ,aPosObj[1,2]+300,{|| "Revisado" },oPanel,,oTFont0,,,,.T.,,,300,30)	
	@ aPosObj[1,1]+13,aPosObj[1,2]+300 ComboBox oCombo Var cCombo Items aItem Size 30,13 Of oPanel Pixel
	//@ aPosObj[1,1]+13,aPosObj[1,2]+300 MSGET cCodRev SIZE 60,9 WHEN .T. OF oPanel PIXEL

	oSay1 := TSay():New(aPosObj[1,1]+5 ,aPosObj[1,2]+390,{|| "Data Rev" },oPanel,,oTFont0,,,,.T.,,,300,30)	
	@ aPosObj[1,1]+13,aPosObj[1,2]+390 MSGET dDataRev SIZE 60,9 WHEN .T. OF oPanel PIXEL

	oSay1 := TSay():New(aPosObj[1,1]+5 ,aPosObj[1,2]+480,{|| "Data Criação" },oPanel,,oTFont0,,,,.T.,,,300,30)	
	@ aPosObj[1,1]+13,aPosObj[1,2]+480 MSGET dDataCria SIZE 60,9 WHEN .T. OF oPanel PIXEL

	oSay1 := TSay():New(aPosObj[1,1]+5 ,aPosObj[1,2]+570,{|| "Peso Liq" },oPanel,,oTFont0,,,,.T.,,,300,30)
	@ aPosObj[1,1]+13,aPosObj[1,2]+570 MSGET nPesoLiq Picture PesqPict("SZ1","Z1_PESOLIQ") SIZE 60,9 WHEN .T. OF oPanel PIXEL

	oSay1 := TSay():New(aPosObj[1,1]+28 ,aPosObj[1,2]+15,{|| "Referência" },oPanel,,oTFont0,,,,.T.,,,300,30)	
	@ aPosObj[1,1]+36,aPosObj[1,2]+13 MSGET cCodRef SIZE 60,9 F3 "SB1SZ1" WHEN .T. OF oPanel PIXEL

	oSay1 := TSay():New(aPosObj[1,1]+28 ,aPosObj[1,2]+90,{|| "Descrição" },oPanel,,oTFont0,,,,.T.,,,300,30)
	@ aPosObj[1,1]+36,aPosObj[1,2]+90 MSGET cDescRef SIZE 190,9 WHEN .F. OF oPanel PIXEL

	oSay1 := TSay():New(aPosObj[1,1]+28 ,aPosObj[1,2]+300,{|| "Composição" },oPanel,,oTFont0,,,,.T.,,,300,30)
	@ aPosObj[1,1]+36,aPosObj[1,2]+300 MSGET cComposicao SIZE 190,9 WHEN .T. OF oPanel PIXEL

	oSay1 := TSay():New(aPosObj[1,1]+28 ,aPosObj[1,2]+570,{|| "Peso Bruto" },oPanel,,oTFont0,,,,.T.,,,300,30)
	@ aPosObj[1,1]+36,aPosObj[1,2]+570 MSGET nPesoBru Picture PesqPict("SZ1","Z1_PESOBRU") SIZE 60,9 WHEN .T. OF oPanel PIXEL

	oSay1 := TSay():New(aPosObj[1,1]+51 ,aPosObj[1,2]+15,{|| "Desc Livre" },oPanel,,oTFont0,,,,.T.,,,300,30)
	oTMultiget1 := tMultiget():new( aPosObj[1,1]+59, aPosObj[1,2]+13, {| u | if( pCount() > 0, cDescLiv := u, cDescLiv ) },oPanel, 267, 60, , , , , , .T. )
	//@ aPosObj[1,1]+59,aPosObj[1,2]+13 MSGET cDescLiv SIZE 267,60 WHEN .T. OF oPanel PIXEL

	oSay1 := TSay():New(aPosObj[1,1]+51 ,aPosObj[1,2]+300,{|| "Observações" },oPanel,,oTFont0,,,,.T.,,,300,30)
	oTMultiget1 := tMultiget():new( aPosObj[1,1]+59, aPosObj[1,2]+300, {| u | if( pCount() > 0, cObs := u, cObs ) },oPanel, 267, 60, , , , , , .T. )
	//@ aPosObj[1,1]+59,aPosObj[1,2]+300 MSGET cObs SIZE 270,60 WHEN .T. OF oPanel PIXEL

	fMontaGrid(1)
	//Monta o browser com inclusão, remoção e atualização
	oGroup2:= TGroup():New(aPosObj[2,1] -5, aPosObj[2,2]-10, aPosObj[2,3], aPosObj[2,4],'Matéria Prima',oDlg,,,.T.)
	//Grade com o resumo
	oMSNewGe := MsNewGetDados():New( aPosObj[2,1] + 10, aPosObj[2,2]+5, aPosObj[2,3]-5, aPosObj[2,4]-10, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aAltFie1,0, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeader, aColsEx)
	// Ativa diálogo centralizado
	
	fMontaGrid(2)
	oGroup3:= TGroup():New(aPosObj[3,1],aPosObj[3,2],aPosObj[3,3],aPosObj[3,4],'Maquinas',oDlg,,,.T.)
	oMSNewGe2 := MsNewGetDados():New( aPosObj[3,1] - 5, aPosObj[3,2]+5, aPosObj[3,3]-20, aPosObj[3,4]-10, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aAltFie12,0, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeader2, aColsEx2)
	
	TButton():New( aPosObj[3,1] + 83, aPosObj[2,2] + 540, "Gravar" 		, oDlg , {|| fGravar(),oDlg:End()}, 40, 11,,,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New( aPosObj[3,1] + 83, aPosObj[2,2] + 590, "Cancelar" 	, oDlg , {|| RollBackSx8(),oDlg:End()}, 40, 11,,,.F.,.T.,.F.,,.F.,,,.F. )

	// Tratamento para definição de cores específicas
	/*oMSNewGe:oBrowse:lUseDefaultColors := .F.	
	oMSNewGe:oBrowse:SetBlkBackColor({|| GETDCLR(oMSNewGe:oBrowse:nAt)})*/
	//oMSNewGe:oBrowse:aColumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linha
	
	oDlg:Activate(,,,.T.,/*{||MsgStop("Validou!"),.T.}*/,,/*{||MsgStop("Iniciando")}*/ )

Return	

//Monta as duas Grid!
Static Function fMontaGrid(nOpc)

	Local nX
	Local cTitulo := ""
	Local cPict   := ""
	Local nTam	  := 0
	
	dbSelectArea("SX3")
	dbSetOrder(2)

	If nOpc == 1
		//Aadd(aHeader, {"","Check", "@BMP", 2, 0, ".F." ,""    , "C", "", "V" ,"" , "","","V"})
		For nX := 1 to Len(aFields)
			If dbSeek(aFields[nX])
							
				aAdd(aHeader,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
				
			Endif
		Next
	Else
		//Aadd(aHeader2, {"","Check", "@BMP", 2, 0, ".F." ,""    , "C", "", "V" ,"" , "","","V"})
		For nX := 1 to Len(aFields2)
			If dbSeek(aFields2[nX])
							
				aAdd(aHeader2,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
				
			Endif
		Next	
	Endif

Return


Static Function fGravar()

	Local aColsAux1 := oMSNewGe:aCols
	Local aColsAux2 := oMSNewGe2:aCols 
	
	dbSelectArea("SZ1")
	dbSelectArea("SZ2")
	dbSelectArea("SZ3")
	For y := 1 to Len(aColsAux1)
		RecLock("SZ1",.T.)
		SZ1->Z1_FILIAL 	:= xFilial("SZ1")
		SZ1->Z1_DATA	:= dDataCria
		SZ1->Z1_CODIGO	:= cCodProd
		SZ1->Z1_DESCRI	:= cDesc
		SZ1->Z1_PRODBAS	:= cCodRef
		SZ1->Z1_DESCBAS	:= cDescRef
		SZ1->Z1_REVISAO	:= SubStr(cCombo,1,1)
		SZ1->Z1_DTREVIS	:= dDataRev
		SZ1->Z1_COMPOSI	:= cComposicao
		SZ1->Z1_PESOBRU	:= nPesoBru
		SZ1->Z1_PESOLIQ	:= nPesoLiq
		SZ1->Z1_MAT1	:= aColsAux1[y,1]
		MsUnlock()

		Reclock("SZ2",.T.)
		SZ2->Z2_FILIAL := xFilial("SZ2")
		SZ2->Z2_CODIGO := aColsAux1[y,1]
		SZ2->Z2_DESCRI := aColsAux1[y,2]
		SZ2->Z2_UM     := aColsAux1[y,3]
		SZ2->Z2_CUSTO  := aColsAux1[y,4]
		SZ2->Z2_OBSERV := aColsAux1[y,5]
		MsUnlock()
	Next

	For y := 1 to Len(aColsAux2)
		RecLock("SZ1",.T.)
		SZ1->Z1_FILIAL 	:= xFilial("SZ1")
		SZ1->Z1_DATA	:= dDataCria
		SZ1->Z1_CODIGO	:= cCodProd
		SZ1->Z1_DESCRI	:= cDesc
		SZ1->Z1_PRODBAS	:= cCodRef
		SZ1->Z1_DESCBAS	:= cDescRef
		SZ1->Z1_REVISAO	:= SubStr(cCombo,1,1)
		SZ1->Z1_DTREVIS	:= dDataRev
		SZ1->Z1_COMPOSI	:= cComposicao
		SZ1->Z1_PESOBRU	:= nPesoBru
		SZ1->Z1_PESOLIQ	:= nPesoLiq
		SZ1->Z1_MAQ1	:= aColsAux2[y,1]
		MsUnlock()

		Reclock("SZ3",.T.)
		SZ3->Z3_FILIAL := xFilial("SZ2")
		SZ3->Z3_CODIGO := aColsAux2[y,1]
		SZ3->Z3_DESCRI := aColsAux2[y,2]
		SZ3->Z3_CUSTO  := aColsAux2[y,3]
		SZ3->Z3_FECHAM := aColsAux2[y,4]
		SZ3->Z3_CLASSIF:= aColsAux2[y,5]
		SZ3->Z3_OBSERV := aColsAux2[y,6]
		MsUnlock()
	Next
	
Return
