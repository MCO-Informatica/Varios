#Include "RWMAKE.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "Font.ch"

#Define GD_INSERT 1
#Define GD_UPDATE 2
#Define GD_DELETE 4

/*
+========================================================= +
|Programa: LSMID001 |Autor: Antonio Carlos |Data: 15/03/11|
+========================================================= +
|Descrição: Cadastro de Locação de Espaço/Midia.          |
+========================================================= +
|Uso: Especifico Laselva                                  |
+========================================================= +
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSMID001()
////////////////////////


Local aArea  	:= GetArea()
Local cAlias  	:= "PAC"
Local aCores  	:= {}

aAdd(aCores,{ "PAC_STATUS == 'I' " , 'BR_VERDE'		}) // Processando
aAdd(aCores,{ "PAC_STATUS == 'P' " , 'BR_AMARELO'	}) // Processando
aAdd(aCores,{ "PAC_STATUS == 'C' " , 'BR_PRETO'		}) // Encerrado
aAdd(aCores,{ "PAC_STATUS == 'F' " , 'BR_VERMELHO'	}) // Encerrado

Private aRotina    := {}
Private cCadastro  := "Controle de Midia"

aAdd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
aAdd(aRotina,{"Visualizar"  		,"U_LSMIDMC" 		,0,2 })
aAdd(aRotina,{"Incluir"  			,"U_LSMIDMC"		,0,3 })
aAdd(aRotina,{"Alterar"  			,"U_LSMIDMC" 		,0,4 })
aAdd(aRotina,{"Excluir"  			,"U_LSMIDMC" 		,0,5 })
aAdd(aRotina,{"Cancelar"			,"U_LSMIDCA" 		,0,6 })
aAdd(aRotina,{"Gera Cobrança"		,"U_LSMIDC"			,0,7 })
aAdd(aRotina,{"Impr. Faturas"		,"U_LSMID003()"		,0,7 })
//Aadd(aRotina,{"Mapa da Loja"		,"U_LsMidMap('B')"	,0,4, 0, nil})
aAdd(aRotina,{"Legenda"  			,"U_LSMIDLEG"		,0,8 })

mBrowse( 7, 4,20,74,cAlias,,,,,,aCores)

//Restaura a integridade da rotina
DbSelectArea(cAlias)
RestArea(aArea)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSMIDMC(cAlias,nReg,nOpc)
///////////////////////////////////////

Local aArea	   	:= GetArea()
Local cAlias   	:= Alias()
Local aGrupos	:= UsrRetGrp()
Local aAllGrp	:= AllGroups(.T.)
Local cGrupos	:= ""

Local nX		:= 0
Local nStyle   	:= 0
Local oSay1		:= 0
Local nGetLin	:= 0

Local oEnchoice
Local aPosObj	:= {}
Local aObjects	:= {}
Local aSize		:= {}
Local aPosGet	:= {}
Local aInfo		:= {}
Local aCpoGDa	:= {"PAE_PARCEL","PAE_DATA","PAE_PEDVEN"}
Local aButtons 	:= {}
aAdd(aButtons,{ "EDIT", {||U_LSMIDMAP('G') },"Mapa da Loja" })

Private _cDatv		:= Space(2)
Private _lAltVen	:= .F.
Private _nTotCont	:= 0
Private _nDelBrw	:= 0
Private nOpca	 	:= nOpc

Private aHeader   	:= {}
Private aCols     	:= {}

Private aListVen	:= {}
Private _aDtVenc	:= {}
Private oAb			:= LoadBitmap( GetResources(), "BR_VERDE" 	)
Private oFi			:= LoadBitmap( GetResources(), "BR_VERMELHO")

Private oDlg
Private oFolder
Private oGetDadA
Private oGetDadB
Private oListVen
Private aTela[0][0]
Private aGets[0]
Private aFolder := { 'Espacos / Parcelas' }

aSize	:= MsAdvSize(,.F.,400)

aObjects := {}

aAdd( aObjects, { 0,    90, .T., .F. } )
aAdd( aObjects, { 100, 100, .T., .T. } )
aAdd( aObjects, { 0,    50, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,013,073,097,154,162,222,255}} )
nGetLin := aPosObj[3,1]

DbSelectArea(cAlias)

//Carrega as variaveis da Enchoice.
RegToMemory(cAlias,IIF(nOpc==3,.T.,.F.))

If nOpc <> 2 .and. M->PAC_STATUS == "C"
	MsgStop("Contrato cancelado!")
	Return(.F.)
EndIf

If nOpc <> 2 .and. M->PAC_STATUS == "F"
	MsgStop("Contrato finalizado!")
	Return(.F.)
EndIf

If nOpc == 5 .and. M->PAC_STATUS <> "I"
	MsgStop("Existem Pedidos de Venda/NF para o contrato" + _cEnter;
	+ "o mesmo nao podera ser excluido!")
	Return(.F.)
EndIf

//Montagem do aHeader
aHeader	:= {}
aCols	:= {}
DbSelectArea("SX3")
DbSetorder(1)
DbSeek("PAD")
Do While !eof() .and. SX3->X3_ARQUIVO == "PAD"
	
	If Alltrim(SX3->X3_CAMPO) $ "PAD_LOJA/PAD_NOMLOJ/PAD_ESPA/PAD_NOMESP/PAD_PRECO/PAD_DTINIC/PAD_DTTERM"
		aAdd(aHeader,{Alltrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,".T."})
	EndIf
	
	DbSkip()	
EndDo

//Montagem do aCols (1)
If nOpc == 3
	aCols := {}
	aAdd(aCols,Array(Len(aHeader) + 1))
	For nY := 1 To Len(aHeader)
		aCols[Len(aCols),nY] := CriaVar(aHeader[nY][2])
	Next nY
	aCols[Len(aCols),Len(aHeader) + 1] := .F.
Else
	aCols := {}
	DbSelectArea("PAD")
	DbSetorder(1)
	DbSeek( xFilial("PAD") + M->PAC_NUM )
	Do While !eof() .and. PAD->PAD_FILIAL + PAD->PAD_NUM == xFilial("PAC") + M->PAC_NUM
		
		aAdd( aCols,Array(Len(aHeader) + 1) )
		
		For nY	:= 1 To Len(aHeader)
			
			IF ( aHeader[nY][10] != "V" )
				aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
			Else
				aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
			EndIF
			
		Next nY
		
		_nTotCont += PAD->PAD_PRECO
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		DbSkip()
		
	EndDo
EndIf

_nW := 1

DbSelectArea("PAE")
DbSetorder(1)
DbSeek( xFilial("PAE") + PAC->PAC_NUM )
Do While !eof() .and. PAE->PAE_FILIAL + PAE->PAE_NUMCON == xFilial("PAE") + PAC->PAC_NUM
	
	_aDtVenc := {}
	_aDtVenc := Condicao(PAC->PAC_VALOR,PAC->PAC_PAGTO,,PAE->PAE_DATA,,,,,,)
	
	aAdd(aListVen, { oAb,Space(3),ctod(''),Space(6),Space(9),Space(3),ctod(''),ctod('') } )
	
	aListVen[_nW,2] := PAE->PAE_PARCEL
	aListVen[_nW,3] := PAE->PAE_DATA
	aListVen[_nW,4] := PAE->PAE_PEDVEN
	aListVen[_nW,5] := Posicione("SC5",1,PAE->PAE_FILIAL + PAE->PAE_PEDVEN,"C5_NOTA")
	aListVen[_nW,6] := SC5->C5_SERIE
	aListVen[_nW,1] := iif(empty(aListVen[_nW,5]), oAb,oFi )
	aListVen[_nW,7] := iif(empty(aListVen[_nW,5]), ctod(''), _aDtVenc[1,1])
	aListVen[_nW,8] := Posicione('SF2',1, xFilial('SF2') + SC5->C5_NOTA + SC5->C5_SERIE,'F2_PREFIXO')
	aListVen[_nW,8] := Posicione("SE1",1,xFilial('SE1') + aListVen[_nW,8] + SC5->C5_NOTA ,"E1_SALDO")
	aListVen[_nW,8] := iif(aListVen[_nW,8] <> SE1->E1_VALOR, SE1->E1_BAIXA,ctod(''))	
	
	DbSelectArea('PAE')
	DbSkip()
	_nW++
	
EndDo

If empty(aListVen)
	aAdd(aListVen, { oAb,Space(3),ctod(''),Space(6),Space(9),Space(3),ctod(''),ctod('') } )
EndIf

//Condicao(nValTot,cCond,nValIpi,dData0,nValSolid,aImpVar,aE4,nAcrescimo,nInicio3,aDias3)

Do Case
	Case nOpc == 3
		nStyle := GD_INSERT + GD_UPDATE + GD_DELETE
	Case nOpc == 4
		nStyle := GD_INSERT + GD_UPDATE + GD_DELETE
	OtherWise
		nStyle := 0
EndCase

DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[6],aSize[5] TITLE cCadastro Of oMainWnd PIXEL

DEFINE FONT oFontBold   NAME 'Times New Roman' SIZE 12, 14 Bold

oPanel1:= TPanel():New(0, 0, "", oDlg, NIL, .T., .F., NIL, NIL, 0,150, .T., .F. )
oPanel1:Align:=CONTROL_ALIGN_TOP

oEnchoice := MsMGet():New("PAC",PAC->( Recno() ),nOpc,,,,ƒ,,,3,,,,oPanel1,,.T.)

oFolder := TFolder():New( 0, 0, aFolder, aFolder, oDlg,,,, .T., , 0,0 )
oFolder:Align:=CONTROL_ALIGN_ALLCLIENT

nGd1 := 2
nGd2 := 5
nGd3 := aPosObj[2,3]-aPosObj[2,1]-20
nGd4 := (aPosObj[2,4]-aPosObj[2,2]-4) /2

oGetDados:= MSGetDados():New(nGd1,nGd2,nGd3,nGd4,nOpc,"U_LsMdLOk",,,.T.,,,,,"U_FILOK()",,,"U_DELOK()",oFolder:aDialogs[1])

@ 002,ngd4+5 LISTBOX oListVen FIELDS HEADER "","Parcela","Data", "Pedido", "Nota","Serie","Vencimento","Baixa" SIZE nGd4,nGd3 ON DBLCLICK( AltDatV() )  OF oFolder:aDialogs[1] PIXEL
oListVen:SetArray(aListVen)
oListVen:bLine	:= {|| {	aListVen[oListVen:nAT,01],aListVen[oListVen:nAT,02],aListVen[oListVen:nAT,03],aListVen[oListVen:nAT,04],aListVen[oListVen:nAT,05],aListVen[oListVen:nAT,06],aListVen[oListVen:nAT,07],aListVen[oListVen:nAT,08]}}

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{|| iif(nOpc == 7,GeraTit(),GrvDados(@nOpc)) },{||oDlg:End()},,aButtons))

RestArea(aArea)

Return(.T.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function GeraTit()
///////////////////////


Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LsMdLOk()
///////////////////////

Local _lRet		 := .T.
Local nPosLoj	 := aScan(aHeader,{|x| AllTrim(x[2])=="PAD_LOJA"})
Local nPosEsp	 := aScan(aHeader,{|x| AllTrim(x[2])=="PAD_ESPA"})
Local nPosPrc	 := aScan(aHeader,{|x| AllTrim(x[2])=="PAD_PRECO"})
Local nPosNomEsp := aScan(aHeader,{|x| AllTrim(x[2])=="PAD_NOMESP"})
Local nPosDtInic := aScan(aHeader,{|x| AllTrim(x[2])=="PAD_DTINIC"})
Local nPosDtTerm := aScan(aHeader,{|x| AllTrim(x[2])=="PAD_DTTERM"})

Local _nDup	:= 0                                              

Local _nItens	:= 0

If !aCols[n,Len(aHeader) + 1]
	
	_cQry := " SELECT PAD_NUM, PAB_CODESP, PAB_DESCR "
	_cQry += _cEnter + " FROM " + RetSqlName("PAD") + " PAD "
	
	_cQry += _cEnter + " INNER JOIN " + RetSqlName("PAB") + " PAB "
	_cQry += _cEnter + " ON PAB_FILIAL = '" + xFilial('PAB') + "'"
	_cQry += _cEnter + " AND PAB_CODFIL = PAD_LOJA"
	_cQry += _cEnter + " AND PAB_CODESP = PAD_ESPA"
	_cQry += _cEnter + " AND PAB.D_E_L_E_T_ = '' "
	
	_cQry += _cEnter + " INNER JOIN " + RetSqlName("PAC") + " PAC "
	_cQry += _cEnter + " ON PAC_FILIAL = PAD_FILIAL"
	_cQry += _cEnter + " AND PAC_NUM = PAD_NUM
	_cQry += _cEnter + " AND PAC.D_E_L_E_T_ = '' "
	_cQry += _cEnter + " AND PAC_STATUS NOT IN ('C','F')"
	
	_cQry += _cEnter + " WHERE PAD_LOJA = '" + aCols[n,nPosLoj] + "'"
	_cQry += _cEnter + " AND PAD_ESPA = '" + aCols[n,nPosEsp] + "'"
	_cQry += _cEnter + " AND PAD.D_E_L_E_T_ = '' "
	_cQry += _cEnter + " AND PAD_FILIAL = '" + xFilial('PAD') + "'"
	
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQry), 'TMP_ESP', .F., .T.)
	
	If TMP_ESP->( !eof() )
		If M->PAC_NUM <> TMP_ESP->PAD_NUM
			MsgStop("Espaço utilizado no contrato: " + TMP_ESP->PAD_NUM)
			_lRet := .F.
		EndIf
	EndIf
	DbCloseArea()
EndIf

For _nI := 1 To Len(aCols)
	If !aCols[n,Len(aHeader) + 1]
		If aCols[n,nPosLoj] + aCols[n,nPosEsp] == aCols[_nI,nPosLoj] + aCols[_nI,nPosEsp]
			_nDup++
		EndIf
	EndIf
Next _nI

If _nDup > 1
	MsgStop("Espaço já cadastrado!")
	aCols[n,nPosLoj] 	:= Space(2)
	aCols[n,nPosEsp]	:= Space(6)
	
	oGetDados:oBrowse:Refresh()
	oDlg:Refresh()
	
	_lRet := .F.
EndIf

For _nI := 1 To Len(aCols)
	If !aCols[n,Len(aHeader) + 1]
		_nItens++
	EndIf
Next _nI

If _nItens == 0 .and. !aCols[n,Len(aHeader) + 1]
	MsgStop("Informe um espaço!")
	_lRet := .F.
EndIf

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LsMidParc()
/////////////////////////

Local _cParc   := "001"
Local _dDtParc := date()
Local _nDiaAT  := max(day(_dDtParc),M->PAC_DIAVENC)

If nOpca == 3 .or. nOpca == 4
	
	aListVen := {}
	aAdd(aListVen, {oAb, _cParc, _dDtParc, Space(6), Space(9), Space(3), ctod(''), ctod('') })
	oListVen:SetArray(aListVen)
	oListVen:bLine	:= {|| {aListVen[oListVen:nAT,01],aListVen[oListVen:nAT,02],aListVen[oListVen:nAT,03],aListVen[oListVen:nAT,04],aListVen[oListVen:nAT,05],aListVen[oListVen:nAT,06],aListVen[oListVen:nAT,07],aListVen[oListVen:nAT,08]}}
	
	For _nI := 2 To M->PAC_PRAZO
		_dDtParc := DataValida(MonthSum(ctod(strzero(_nDiaAt,2) + substr(dtoc(_dDtParc),3)),1))
		_cParc   := Soma1(_cParc)
		aAdd(aListVen, {oAb, _cParc, _dDtParc, Space(6), Space(9), Space(3), ctod(''), ctod('') })
	Next
	
EndIf

oListVen:Refresh()
oDlg:Refresh()

Return(M->PAC_PRAZO)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GrvDados(nOpc)
//////////////////////////////

Local _nVlrTot 	 := 0
Local nPosLoj	 := aScan(aHeader,{|x| AllTrim(x[2])=="PAD_LOJA"})
Local nPosEsp	 := aScan(aHeader,{|x| AllTrim(x[2])=="PAD_ESPA"})
Local nPosPrc	 := aScan(aHeader,{|x| AllTrim(x[2])=="PAD_PRECO"})
Local nPosNomEsp := aScan(aHeader,{|x| AllTrim(x[2])=="PAD_NOMESP"})
Local nPosDtInic := aScan(aHeader,{|x| AllTrim(x[2])=="PAD_DTINIC"})
Local nPosDtTerm := aScan(aHeader,{|x| AllTrim(x[2])=="PAD_DTTERM"})
Local _dDtParc	:= CTOD("  /  /  ")

If !Obrigatorio(aGets,aTela) .Or. !oGetDados:TudoOk()
	MsgStop("Preencha os campos Loja/Espaço corretamente!")
	Return(.F.)
EndIf

If nOpc < 5 .and. !U_VLPrazo(1,len(aCols))
	Return(.F.)
EndIf

If nOpc == 3 .Or. nOpc == 4 .Or. nOpc == 5
	
	Begin Transaction
	
	If nOpc == 5
		//Quando exclusao.
		DbSelectArea("PAC")
		DbSetOrder(1)
		DbSeek( xFilial("PAC") + M->PAC_NUM )
		
		RecLock("PAC",.F.)
		DbDelete()
		MsUnLock()
		
		DbSelectArea("PAD")
		DbSetOrder(1)
		DbSeek( xFilial("PAD") + M->PAC_NUM )
		Do While !eof() .and. PAD->PAD_FILIAL + PAD->PAD_NUM == xFilial("PAD") + M->PAC_NUM
			
			DbSelectArea("PAB")
			DbSetOrder(1)
			If DbSeek(xFilial("PAB") + PAD->PAD_LOJA + PAD->PAD_ESPA)
				RecLock("PAB",.F.)
				PAB->PAB_NUM := " "
				MsUnLock()
			EndIf
			
			RecLock("PAD",.F.)
			DbDelete()
			MsUnLock()
			
			DbSkip()
			
		EndDo
		
		DbSelectArea("PAE")
		DbSetOrder(1)
		DbSeek( xFilial("PAE") + M->PAC_NUM )
		Do While !eof() .and. PAE->PAE_FILIAL + PAE->PAE_NUMCON == xFilial("PAE") + M->PAC_NUM
			
			RecLock("PAE",.F.)
			DbDelete()
			MsUnLock()
			
			DbSkip()
			
		EndDo
		
	Else
		
		//Quando Inclusao/Alteracao.
		DbSelectArea("PAC")
		DbSetOrder(1)
		RecLock("PAC",!DbSeek( xFilial("PAC") + M->PAC_NUM ))
		For nX := 1 To PAC->( FCount() )
			
			If !( Alltrim( FieldName(nX) ) $ "PAC_FILIAL")
				FieldPut(nX,M->&( FieldName(nX) ))
			EndIf
			
		Next nX
		MsUnLock()
		
		_nDelete := 1
		For nX := 1 To Len(aCols)
			
			DbSelectArea("PAD")
			DbSetOrder(1)
			lAchou := DbSeek( xFilial("PAD") + M->PAC_NUM + GdFieldGet('PAD_LOJA',nX) + GdFieldGet('PAD_ESPA',nX),.f.)
			
			If GdDeleted(nX)
				
				If lAchou
					++_nDelete
					DbSelectArea("PAB")
					DbSetOrder(1)
					If DbSeek( xFilial("PAB") + PAD->PAD_LOJA + PAD->PAD_ESPA )
						RecLock("PAB",.F.)
						PAB->PAB_NUM := " "
						PAB->( MsUnLock() )
					EndIf
					
					RecLock("PAD",.F.)
					DbDelete()
					MsUnLock()
					
				EndIf
				
			Else
				
				RecLock("PAD",!lAchou)
				
				PAD->PAD_FILIAL	:= xFilial("PAD")
				PAD->PAD_NUM	:= M->PAC_NUM
				PAD->PAD_LOJA	:= GdFieldGet('PAD_LOJA',nX)
				PAD->PAD_ESPA	:= GdFieldGet('PAD_ESPA',nX)
				PAD->PAD_NOMESP	:= GdFieldGet('PAD_NOMESP',nX)
				PAD->PAD_PRECO	:= GdFieldGet('PAD_PRECO',nX)
				PAD->PAD_DTINIC	:= GdFieldGet('PAD_DTINIC',nX)
				PAD->PAD_DTTERM	:= GdFieldGet('PAD_DTTERM',nX)
				
				_nVlrTot += PAD->PAD_PRECO
				
				MsUnLock()
				
				DbSelectArea("PAB")
				DbSetOrder(1)
				If DbSeek(xFilial("PAB") + PAD->PAD_LOJA + PAD->PAD_ESPA )
					RecLock("PAB",.F.)
					PAB->PAB_NUM := M->PAC_NUM
					PAB->( MsUnLock() )
				EndIf
				
			EndIf
			
		Next nX
		
		If nX == _nDelete
			MsgBox('Você não pode excluir todos os itens. Para excluir o contrato inteiro utilize a opção EXCLUIR','ATENÇÃO!!!','ALERT')
			DisarmTransction()
			Return()
		EndIf
		DbSelectArea("PAC")
		RecLock("PAC",.F.)
		PAC->PAC_VALOR	:= _nVlrTot
		PAC->PAC_VLRTOT	:= _nVlrTot * PAC->PAC_PRAZO
		If nOpc == 3
			PAC->PAC_STATUS	:= "I"
		EndIf
		MsUnLock()
		
		If nOpc == 3 .or. nOpc == 4
			
			DbSelectArea("PAE")
			DbSetOrder(1)
			For _nI := 1 To Len(aListVen)
				RecLock("PAE",!DbSeek( xFilial("PAE") + PAC->PAC_NUM + aListVen[_nI,02] ))
				PAE->PAE_FILIAL		:= xFilial("PAE")
				PAE->PAE_NUMCONT	:= PAC->PAC_NUM
				PAE->PAE_PARCELA	:= aListVen[_nI,2]
				PAE->PAE_DATA		:= aListVen[_nI,3]
				MsUnLock()
			Next _nI
			
		EndIf
		
	EndIf
	
	End Transaction
	
	MsgInfo("Gravação efetuada com sucesso!")
	oDlg:End()
	
Else
	
	oDlg:End()
	
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AltDatV()
/////////////////////////

Local oDlgDt, _nOpc := 0
Local _dData := ctod('')

If nOpca > 2
	
	If !empty( aListVen[oListVen:nAT,04] )
		MsgStop("Alteração não pode ser efetuada, Nota Fiscal já processada! ")
		Return(.F.)
	EndIf
	
	DEFINE MSDIALOG oDlgDt FROM 000,000 TO 120,110 TITLE "Altera Emissão" PIXEL
	
	@ 010,010 SAY "Data : " PIXEL OF oDlgDt
	@ 020,010 MSGET oData VAR _dData SIZE 50,10 VALID( !empty(_dData) .and. _dData >= aListVen[oListVen:nAT,03] ) PIXEL OF oDlgDt
	
	oSButton := SButton():New( 40,10,1,{|| AltData(_dData),oDlgDt:End() },oDlgDt,.T.,,)
	
	ACTIVATE MSDIALOG oDlgDt CENTERED
	
Else
	
	If empty( aListVen[oListVen:nAT,04] )
		MsgStop("Não há PV/NF para exclusão! ")
		Return(.F.)
	EndIf

	If !empty( aListVen[oListVen:nAT,08] )
		MsgStop("Exclusão não pode ser efetuada. Duplicata já está baixada! ")
		Return(.F.)
	EndIf

	_cTexto := 'Excluir NF e PV ???' + _cEnter + _cEnter
	_cTexto += 'Parcela: ' + aListVen[oListVen:nAT,02] + _cEnter
	_cTexto += 'Data: ' + dtoc(aListVen[oListVen:nAT,03]) + _cEnter
	_cTexto += 'Nota Fiscal: ' + aListVen[oListVen:nAT,05] + _cEnter
	_cTexto += 'Pedido de Venda: ' + aListVen[oListVen:nAT,04]
	
	If MsgBox(_cTexto,'Mídia - Contrato Nro: ' + PAC->PAC_NUM, 'YESNO')
		LSEXCPVS()
	EndIf
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AltData(dData)
//////////////////////////////
aListVen[oListVen:nAT,03]:= dData
oListVen:Refresh()
oDlg:Refresh()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSMIDLEG()
////////////////////////

Local aLegenda := {}

aAdd(aLegenda,{"BR_VERDE"	,"Inclusao"		,"I"})
aAdd(aLegenda,{"BR_AMARELO"	,"Processando"	,"P"})
aAdd(aLegenda,{"BR_PRETO"	,"Cancelado"	,"C"})
aAdd(aLegenda,{"BR_VERMELHO","Encerrado"	,"F"})

BrwLegenda("Locacao de Espacos", "Legenda", aLegenda)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSMIDCA()
///////////////////////

Local oDlgC, oMemo, cMemo:= space(50)

If !PAC->PAC_STATUS $ "C/F"
	
	If MsgYesNo("Confirma cancelamento?")
		
		DEFINE MSDIALOG oDlgC FROM 0,0 TO 200,400 PIXEL TITLE "Motivo Cancelamento" STYLE DS_MODALFRAME
		oDlgC:lEscClose := .F.
		
		oMemo:= tMultiget():New(10,10,{|u|if(Pcount()>0,cMemo:=u,cMemo)},oDlgC,170,50,,,,,,.T.)
		
		@ 80,10 BUTTON oBtn PROMPT "Fecha" OF oDlgC PIXEL ACTION (If( !empty(cMemo),oDlgC:End(),MsgStop("Informe o motivo!") ) )
		
		ACTIVATE MSDIALOG oDlgC CENTERED
		
		DbSelectArea("PAD")
		DbSetOrder(1)
		If DbSeek( xFilial("PAD") + PAC->PAC_NUM )
			
			Do While !eof() .and. PAD->PAD_FILIAL == xFilial("PAD") .and. PAD->PAD_NUM == PAC->PAC_NUM
				
				DbSelectArea("PAB")
				DbSetOrder(1)
				If PDbSeek( xFilial("PAB") + PAD->PAD_LOJA + PAD->PAD_ESPA )
					RecLock("PAB",.F.)
					PAB->PAB_NUM := " "
					MsUnLock()
				EndIf
				
				DbSelectArea("PAD")
				DbSkip()
				
			EndDo
			
		EndIf
		
		cUpdPAE	:= " UPDATE " + RetSQLName("PAE")
		cUpdPAE	+= " SET PAE_SITUA = 'C' "
		cUpdPAE += " WHERE PAE_FILIAL  = '" + xFilial("PAE") + "'"
		cUpdPAE	+= " AND PAE_NUMCON = '" + PAC->PAC_NUM + "' AND "
		cUpdPAE	+= " D_E_L_E_T_ = '' "
		TcSQLExec(cUpdPAE)
		
		DbSelectArea("PAC")
		RecLock("PAC",.F.)
		PAC->PAC_STATUS	:= "C"
		PAC->PAC_OBS	:= cMemo
		MsUnLock()
		
	EndIf
	
Else
	
	MsgStop("Contrato já cancelado/finalizado!")
	
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function DelOk()
/////////////////////
Local _lRet	:= .T.

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FilOk()
/////////////////////

Local aArea		:= GetArea()
Local _lRet		:= .T.

DbSelectArea("PAD")
DbSetOrder(1)

If DbSeek( xFilial("PAD") + M->PAC_NUM + GdFieldGet('PAD_LOJA') + GdFieldGet('PAD_ESPA') )
	MsgStop("Não é possível alterar registro já gravado, favor efetuar o cadastro novamente!")
	_lRet := .F.
EndIf

RestArea(aArea)

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function VLPrazo(_nIni, _nFim)
///////////////////////////////////
Local _aArea := GetArea()
Local _lRet  := .t.
Local _dData := MonthSum(date(),M->PAC_PRAZO)

DbSelectArea('PAB')
For _nI := _nIni to _nFim
	DbSeek(xFilial('PAB') + aCols[_nI,1],.f.)
	If !GdDeleted(_nI) .and. !empty(PAB->PAB_DTLOJA) .and. _dData > PAB->PAB_DTLOJA
		MsgBox('Verifique o término do contrato. Prazo está além do prazo de funcionamento da loja: ' + alltrim(PAB->PAB_DESCR) + ' Prazo máximo: ' + dtoc(PAB->PAB_DTLOJA) ,'ATENÇÃO!!!','STOP')
		Return(.f.)
	EndIf
Next

RestArea(_aArea)
Return(_lRet)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LSEXCPVS()
//////////////////////////

Begin Transaction

_cQuery := "UPDATE SE1"
_cQuery += _cEnter + " SET SE1.D_E_L_E_T_ = '*', SE1.R_E_C_D_E_L_ = SE1.R_E_C_N_O_"

_cQuery += _cEnter + " FROM " + RetSqlName('PAE') + " PAE (NOLOCK)"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC5') + " SC5 (NOLOCK)"
_cQuery += _cEnter + " ON C5_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND C5_NUM = PAE_PEDVEN"
_cQuery += _cEnter + " AND SC5.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SE1') + " SE1 (NOLOCK)"
_cQuery += _cEnter + " ON E1_FILIAL = ''"
_cQuery += _cEnter + " AND E1_MSFIL = PAE_FILIAL"
_cQuery += _cEnter + " AND E1_NUM = C5_NOTA"
_cQuery += _cEnter + " AND E1_SERIE = C5_SERIE"
_cQuery += _cEnter + " AND SE1.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND E1_CLIENTE = C5_CLIENTE"
_cQuery += _cEnter + " AND E1_LOJA = C5_LOJACLI"

_cQuery += _cEnter + " WHERE PAE_PEDVEN = '" + aListVen[oListVen:nAT,04] + "'"
_cQuery += _cEnter + " AND PAE_PARCEL = '" + aListVen[oListVen:nAT,02] + "'"
_cQuery += _cEnter + " AND PAE.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND PAE_NUMCON = '" + PAC->PAC_NUM + "'"
_cQuery += _cEnter + " AND PAE_FILIAL = '" + PAC->PAC_FILIAL + "'"

_nErro := 0
_nErro := U_LS_SqlExec(_cQuery)
If _nErro <> 0
	msgbox(TCSQLError(),'atenção','info')
	DisarmTransaction()
	MsgBox("Ocorreu um erro. Tente novamente. Persistindo o erro abrir um chamado na TI (TAB SE1)","ATENÇÃO!!!",'ALERT')
	Return(.f.)
EndIf

_cQuery := "UPDATE SD2"
_cQuery += _cEnter + " SET SD2.D_E_L_E_T_ = '*', SD2.R_E_C_D_E_L_ = SD2.R_E_C_N_O_"

_cQuery += _cEnter + " FROM " + RetSqlName('PAE') + " PAE (NOLOCK)"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC5') + " SC5 (NOLOCK)"
_cQuery += _cEnter + " ON C5_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND C5_NUM = PAE_PEDVEN"
_cQuery += _cEnter + " AND SC5.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SD2') + " SD2 (NOLOCK)"
_cQuery += _cEnter + " ON D2_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND D2_DOC = C5_NOTA"
_cQuery += _cEnter + " AND SD2.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND D2_SERIE = C5_SERIE"
_cQuery += _cEnter + " AND D2_CLIENTE = C5_CLIENTE"
_cQuery += _cEnter + " AND D2_LOJA = C5_LOJACLI"

_cQuery += _cEnter + " WHERE PAE_PEDVEN = '" + aListVen[oListVen:nAT,04] + "'"
_cQuery += _cEnter + " AND PAE_PARCEL = '" + aListVen[oListVen:nAT,02] + "'"
_cQuery += _cEnter + " AND PAE.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND PAE_NUMCON = '" + PAC->PAC_NUM + "'"
_cQuery += _cEnter + " AND PAE_FILIAL = '" + PAC->PAC_FILIAL + "'"

_nErro := U_LS_SqlExec(_cQuery)
If _nErro <> 0
	DisarmTransaction()
	MsgBox("Ocorreu um erro. Tente novamente. Persistindo o erro abrir um chamado na TI (TAB SD2)","ATENÇÃO!!!",'ALERT')
	Return(.f.)
EndIf

_cQuery := "UPDATE SF2"
_cQuery += _cEnter + " SET SF2.D_E_L_E_T_ = '*', SF2.R_E_C_D_E_L_ = SF2.R_E_C_N_O_"

_cQuery += _cEnter + " FROM " + RetSqlName('PAE') + " PAE (NOLOCK)"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC5') + " SC5 (NOLOCK)"
_cQuery += _cEnter + " ON C5_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND C5_NUM = PAE_PEDVEN"
_cQuery += _cEnter + " AND SC5.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SF2') + " SF2 (NOLOCK)"
_cQuery += _cEnter + " ON F2_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND F2_DOC = C5_NOTA"
_cQuery += _cEnter + " AND SF2.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND F2_SERIE = C5_SERIE"
_cQuery += _cEnter + " AND F2_CLIENTE = C5_CLIENTE"
_cQuery += _cEnter + " AND F2_LOJA = C5_LOJACLI"

_cQuery += _cEnter + " WHERE PAE_PEDVEN = '" + aListVen[oListVen:nAT,04] + "'"
_cQuery += _cEnter + " AND PAE_PARCEL = '" + aListVen[oListVen:nAT,02] + "'"
_cQuery += _cEnter + " AND PAE.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND PAE_NUMCON = '" + PAC->PAC_NUM + "'"
_cQuery += _cEnter + " AND PAE_FILIAL = '" + PAC->PAC_FILIAL + "'"

_nErro := U_LS_SqlExec(_cQuery)
If _nErro <> 0
	DisarmTransaction()
	MsgBox("Ocorreu um erro. Tente novamente. Persistindo o erro abrir um chamado na TI (TAB SF2)","ATENÇÃO!!!",'ALERT')
	Return(.f.)
EndIf

_cQuery := "UPDATE SFT"
_cQuery += _cEnter + " SET SFT.D_E_L_E_T_ = '*', SFT.R_E_C_D_E_L_ = SFT.R_E_C_N_O_"

_cQuery += _cEnter + " FROM " + RetSqlName('PAE') + " PAE (NOLOCK)"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC5') + " SC5 (NOLOCK)"
_cQuery += _cEnter + " ON C5_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND C5_NUM = PAE_PEDVEN"
_cQuery += _cEnter + " AND SC5.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SFT') + " SFT (NOLOCK)"
_cQuery += _cEnter + " ON FT_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND FT_NFISCAL = C5_NOTA"
_cQuery += _cEnter + " AND SFT.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND FT_SERIE = C5_SERIE"
_cQuery += _cEnter + " AND FT_CLIEFOR = C5_CLIENTE"
_cQuery += _cEnter + " AND FT_LOJA = C5_LOJACLI"
_cQuery += _cEnter + " AND FT_TIPOMOV = 'S'"

_cQuery += _cEnter + " WHERE PAE_PEDVEN = '" + aListVen[oListVen:nAT,04] + "'"
_cQuery += _cEnter + " AND PAE_PARCEL = '" + aListVen[oListVen:nAT,02] + "'"
_cQuery += _cEnter + " AND PAE.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND PAE_NUMCON = '" + PAC->PAC_NUM + "'"
_cQuery += _cEnter + " AND PAE_FILIAL = '" + PAC->PAC_FILIAL + "'"

_nErro := U_LS_SqlExec(_cQuery)
If _nErro <> 0
	DisarmTransaction()
	MsgBox("Ocorreu um erro. Tente novamente. Persistindo o erro abrir um chamado na TI (TAB SFT)","ATENÇÃO!!!",'ALERT')
	Return(.f.)
EndIf

_cQuery := "UPDATE SF3"
_cQuery += _cEnter + " SET SF3.D_E_L_E_T_ = '*'"

_cQuery += _cEnter + " FROM " + RetSqlName('PAE') + " PAE (NOLOCK)"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC5') + " SC5 (NOLOCK)"
_cQuery += _cEnter + " ON C5_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND C5_NUM = PAE_PEDVEN"
_cQuery += _cEnter + " AND SC5.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SF3') + " SF3 (NOLOCK)"
_cQuery += _cEnter + " ON F3_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND F3_NFISCAL = C5_NOTA"
_cQuery += _cEnter + " AND SF3.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND F3_SERIE = C5_SERIE"
_cQuery += _cEnter + " AND F3_CLIEFOR = C5_CLIENTE"
_cQuery += _cEnter + " AND F3_LOJA = C5_LOJACLI"

_cQuery += _cEnter + " WHERE PAE_PEDVEN = '" + aListVen[oListVen:nAT,04] + "'"
_cQuery += _cEnter + " AND PAE_PARCEL = '" + aListVen[oListVen:nAT,02] + "'"
_cQuery += _cEnter + " AND PAE.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND PAE_NUMCON = '" + PAC->PAC_NUM + "'"
_cQuery += _cEnter + " AND PAE_FILIAL = '" + PAC->PAC_FILIAL + "'"

_nErro := U_LS_SqlExec(_cQuery)
If _nErro <> 0
	DisarmTransaction()
	MsgBox("Ocorreu um erro. Tente novamente. Persistindo o erro abrir um chamado na TI (TAB SF3)","ATENÇÃO!!!",'ALERT')
	Return(.f.)
EndIf

_cQuery := "UPDATE SC9"
_cQuery += _cEnter + " SET SC9.D_E_L_E_T_ = '*'"

_cQuery += _cEnter + " FROM " + RetSqlName('PAE') + " PAE (NOLOCK)"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC5') + " SC5 (NOLOCK)"
_cQuery += _cEnter + " ON C5_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND C5_NUM = PAE_PEDVEN"
_cQuery += _cEnter + " AND SC5.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC9') + " SC9 (NOLOCK)"
_cQuery += _cEnter + " ON C9_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND C9_PEDIDO = C5_NUM"
_cQuery += _cEnter + " AND SC9.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " WHERE PAE_PEDVEN = '" + aListVen[oListVen:nAT,04] + "'"
_cQuery += _cEnter + " AND PAE_PARCEL = '" + aListVen[oListVen:nAT,02] + "'"
_cQuery += _cEnter + " AND PAE.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND PAE_NUMCON = '" + PAC->PAC_NUM + "'"
_cQuery += _cEnter + " AND PAE_FILIAL = '" + PAC->PAC_FILIAL + "'"

_nErro := U_LS_SqlExec(_cQuery)
If _nErro <> 0
	DisarmTransaction()
	MsgBox("Ocorreu um erro. Tente novamente. Persistindo o erro abrir um chamado na TI (TAB SC9)","ATENÇÃO!!!",'ALERT')
	Return(.f.)
EndIf

_cQuery := "UPDATE SC6"
_cQuery += _cEnter + " SET SC6.D_E_L_E_T_ = '*'"

_cQuery += _cEnter + " FROM " + RetSqlName('PAE') + " PAE (NOLOCK)"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC5') + " SC5 (NOLOCK)"
_cQuery += _cEnter + " ON C5_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND C5_NUM = PAE_PEDVEN"
_cQuery += _cEnter + " AND SC5.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC6') + " SC6 (NOLOCK)"
_cQuery += _cEnter + " ON C6_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND C6_NUM = C5_NUM"
_cQuery += _cEnter + " AND SC6.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " WHERE PAE_PEDVEN = '" + aListVen[oListVen:nAT,04] + "'"
_cQuery += _cEnter + " AND PAE_PARCEL = '" + aListVen[oListVen:nAT,02] + "'"
_cQuery += _cEnter + " AND PAE.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND PAE_NUMCON = '" + PAC->PAC_NUM + "'"
_cQuery += _cEnter + " AND PAE_FILIAL = '" + PAC->PAC_FILIAL + "'"

_nErro := U_LS_SqlExec(_cQuery)
If _nErro <> 0
	DisarmTransaction()
	MsgBox("Ocorreu um erro. Tente novamente. Persistindo o erro abrir um chamado na TI (TAB SC6)","ATENÇÃO!!!",'ALERT')
	Return(.f.)
EndIf

_cQuery := "UPDATE SC5"
_cQuery += _cEnter + " SET SC5.D_E_L_E_T_ = '*', SC5.R_E_C_D_E_L_ = SC5.R_E_C_N_O_"
_cQuery += _cEnter + " FROM " + RetSqlName('PAE') + " PAE (NOLOCK)"

_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SC5') + " SC5 (NOLOCK)"
_cQuery += _cEnter + " ON C5_FILIAL = PAE_FILIAL"
_cQuery += _cEnter + " AND C5_NUM = PAE_PEDVEN"
_cQuery += _cEnter + " AND SC5.D_E_L_E_T_ = ''"

_cQuery += _cEnter + " WHERE PAE_PEDVEN = '" + aListVen[oListVen:nAT,04] + "'"
_cQuery += _cEnter + " AND PAE_PARCEL = '" + aListVen[oListVen:nAT,02] + "'"
_cQuery += _cEnter + " AND PAE.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND PAE_NUMCON = '" + PAC->PAC_NUM + "'"
_cQuery += _cEnter + " AND PAE_FILIAL = '" + PAC->PAC_FILIAL + "'"

_nErro := U_LS_SqlExec(_cQuery)
If _nErro <> 0
	DisarmTransaction()
	MsgBox("Ocorreu um erro. Tente novamente. Persistindo o erro abrir um chamado na TI (TAB SC5)","ATENÇÃO!!!",'ALERT')
	Return(.f.)
EndIf
                                            
_cQuery := "UPDATE " + RetSqlName('PAE')
_cQuery += _cEnter + " SET PAE_SITUA = '', PAE_PEDVEN = ''"
_cQuery += _cEnter + " WHERE PAE_PEDVEN = '" + aListVen[oListVen:nAT,04] + "'"
_cQuery += _cEnter + " AND PAE_PARCEL = '" + aListVen[oListVen:nAT,02] + "'"
_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND PAE_NUMCON = '" + PAC->PAC_NUM + "'"
_cQuery += _cEnter + " AND PAE_FILIAL = '" + PAC->PAC_FILIAL + "'"

_nErro := U_LS_SqlExec(_cQuery)
If _nErro <> 0
	DisarmTransaction()
	MsgBox("Ocorreu um erro. Tente novamente. Persistindo o erro abrir um chamado na TI (TAB PAE)","ATENÇÃO!!!",'ALERT')
	Return(.f.)
EndIf

aListVen[oListVen:nAT,01]  := oAb
aListVen[oListVen:nAT,02]  := ''
aListVen[oListVen:nAT,03]  := ''
aListVen[oListVen:nAT,04]  := ''
aListVen[oListVen:nAT,05]  := ''
aListVen[oListVen:nAT,06]  := ''
aListVen[oListVen:nAT,07]  := ctod('')
aListVen[oListVen:nAT,08]  := ctod('')

oListVen:refresh()
End Transaction

Return()
