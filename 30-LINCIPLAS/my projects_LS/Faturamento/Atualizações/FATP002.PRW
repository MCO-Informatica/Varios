#Include "Protheus.ch" 
#Include "TopConn.ch"

#Define GD_INSERT 1
#Define GD_UPDATE 2                                                                                                                       
#Define GD_DELETE 4

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATP002   º Autor ³ Antonio Carlos     º Data ³  07/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsavel pelo processamento do Acerto de Consig  º±±
±±º          ³ nacao em Pedido de Compra.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FATP002()
///////////////////////

Local aArea  		:= GetArea()
Local cAlias  		:= "SZA"
Local aCores  		:= {}

Private aRotina    := {}
Private cCadastro  := "Acerto de Consignação"

Conout("*** La Selva - User Function FATP002 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

Private aLegenda := {						;
{'BR_VERDE'	  	,'Em Aberto'		, 'A'	},;
{'BR_AZUL' 		,'Bloqueado'		, 'B'	},;
{'BR_VERMELHO'	,'Processado'		, 'P'	}}

Aadd(aCores,{ "ZA_STATUS == 'A' " , 'BR_VERDE'		}) // Digitado
Aadd(aCores,{ "ZA_STATUS == 'B' " , 'BR_AZUL'		}) // Processado
Aadd(aCores,{ "ZA_STATUS == 'P' " , 'BR_VERMELHO'	}) // Finalizado

Aadd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
Aadd(aRotina,{"Visualizar"  		,"U_FATP02P" 		,0,2 })
Aadd(aRotina,{"Incluir"  			,"U_FATP02P"		,0,3 })
Aadd(aRotina,{"Alterar"  			,"U_FATP02P" 		,0,4 })
Aadd(aRotina,{"Excluir"  			,"U_FATP02P" 		,0,5 })
Aadd(aRotina,{"Processa"			,"U_FATP008"		,0,6 })
Aadd(aRotina,{"Rel.Diferencas"		,"U_RDIFCSP"		,0,7 })
Aadd(aRotina,{"Legenda"  			,"U_FATP02L"		,0,8 })

mBrowse( 7, 4,20,74,cAlias,,,,,,aCores)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cAlias)
RestArea(aArea)

Return(.T.)    

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FATP02P(cAlias,nReg,nOpc)
///////////////////////////////////////

Local aPosObj  := {}
Local aObjects := {}
Local aSize    := {}
Local aPosGet  := {}
Local aInfo    := {}

Local oPanel1
Local oPanel2
Local oPanel3
Local oFld001
Local oFld002
Local oFld003
Local oEnchoice
Local oDlgAut
Local _lPedVC	:= .F.

Local nX		:= 0
Local nStyle   	:= 0

Local aArea	   	:= GetArea()
Local cAlias   	:= Alias()
Local aSize    	:= MsAdvSize()
Local aGrupos	:= UsrRetGrp()
Local aAllGrp	:= AllGroups(.T.)
Local cGrupos	:= ""
Local aButtons 	:= {{"DBG12"	,{||FATP02H()},"Historico" }}   

//Local aButtons   := {{"Destinos",{||ExpCesRep()},"Replica de Cesta" },{"DBG12"	,{||EXPF403A()},"Saldo em Estoque" },{"ALTERA"	,{||EXPALTCL()},"Alteracao do Cliente" }}

Private _cNumSZA	:= SZA->ZA_NUMFEC	
Private nOpca	 	:= 0
Private aHeader   	:= {}
Private aCols     	:= {}
Private oGetDados
Private aTela[0][0]
Private aGets[0]

Conout("*** La Selva - User Function FATP002P - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

AAdd( aObjects, { 0,    91, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 0,    15, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

DbSelectArea(cAlias)

If nOpc == 3
	Aviso("Acerto de Consignação","Opção indisponível nesta rotina!",{"Ok"})			
	Return(.F.)
EndIf 

If (nOpc == 4 .Or. nOpc == 5) .And. SZA->ZA_STATUS == "P"
	Aviso("Acerto de Consignação","Acerto já processado, não será possível realizar 'Alteração/Exclusão' !",{"Ok"})			
	Return(.F.)                                             
EndIf 

If nOpc == 5
	
	DbSelectArea("SC5")                                 
	SC5->( DbsetOrder(5) )
	If SC5->( DbSeek(xFilial("SC5")+SZA->ZA_NUMFEC) )	
		_lPedVC := .T.                             
	EndIf
	
	DbSelectArea("SC7")
	SC7->( DbOrderNickName("NUMFEC") )
	If SC7->( DbSeek(xFilial("SC7")+SZA->ZA_NUMFEC) )	
		_lPedVC := .T.		
	EndIf	
	
	If _lPedVC
		Aviso("Acerto de Consignação","Existem pedidos de Venda e/ou Compra ref. esse Acerto, "+Chr(13)+;
		"efetue a exclusão para prosseguir com a operação!",{"Ok"})				
		Return(.F.)
	EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as variaveia da Enchoice.               	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory(cAlias,IIF(nOpc==3,.T.,.F.))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader a partir dos campos do SX3         	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetorder(1)
MsSeek("SZB")                         
Do While !Eof() .And. (X3_ARQUIVO == "SZB")
	
	If Alltrim(X3_CAMPO) $ "ZB_ITEM/ZB_PRODUTO/ZB_DESCRI/ZB_SALDOPT/ZB_ESTOQUE/ZB_VENDAS/ZB_COMPRAS/ZB_QTDPAG/ZB_DESPRO/ZB_VALPROD/ZB_PORCDES"
		
		If (cNivel >= X3_NIVEL)
			Aadd(aHeader,{Alltrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
			SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,".T."})
		EndIf
	
	EndIf	
	
	DbSkip()
	
EndDo

DbSelectArea("SZB")
DbSetorder(1)
DbSeek(xFilial("SZB")+M->ZA_NUMFEC)
While !Eof() .And. (SZB->ZB_FILIAL+SZB->ZB_NUMFEC == xFilial("SZA")+M->ZA_NUMFEC)
	
	Aadd(aCols,Array(Len(aHeader)+1))
	
	For nY	:= 1 To Len(aHeader)
		IF ( aHeader[nY][10] != "V" )
			aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
		Else
			aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
		EndIF
	Next nY
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	DbSelectArea("SZB")
	DbSkip()
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Na inclusao Monta o Array com 1 elemento vazio         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Len(aCols) == 0
	aCols := {}
	Aadd(aCols,Array(Len(aHeader)+1))
	For nY := 1 To Len(aHeader)
		IF AllTrim(aHeader[nY][2]) == "ZB_ITEM"
			aCols[Len(aCols),nY] := "00001"
		Else
			aCols[Len(aCols),nY] := CriaVar(aHeader[nY][2])
		EndIF
	Next nY
	aCols[Len(aCols),Len(aHeader)+1] := .F.
EndIF 

Do Case
	Case nOpc == 3
		nStyle := GD_INSERT+GD_UPDATE+GD_DELETE
	Case nOpc == 4
		nStyle := GD_INSERT+GD_UPDATE+GD_DELETE
	OtherWise
		nStyle := 0
EndCase   

DEFINE MSDIALOG oDlgAut FROM 0,0 TO aSize[6],aSize[5] TITLE cCadastro Of oMainWnd PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria a Folder da Enchoice da SZ0                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPanel1:= TPanel():New(0, 0, "", oDlgAut, NIL, .T., .F., NIL, NIL, 0,080, .T., .F. )
oPanel1:Align:=CONTROL_ALIGN_TOP

oFld001:=TFolder():New(0,0,{"Cabecalho do Acerto de Consignação"},,oPanel1,,,,.T.,.F.,0,0)
oFld001:Align := CONTROL_ALIGN_ALLCLIENT

oEnchoice := MsMGet():New("SZA",SZA->(Recno()),nOpc,,,,,{0,0,0,0},,3,,,,oFld001:aDialogs[1]	,,.T.)
oEnchoice:oBox:Align:=CONTROL_ALIGN_ALLCLIENT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria a Folder da GetDados da SZ1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPanel2:= TPanel():New(0, 0, "", oDlgAut, NIL, .T., .F., NIL, NIL, 0,0, .T., .F. )
oPanel2:Align:=CONTROL_ALIGN_ALLCLIENT

oFld002:=TFolder():New(0,0,{"Itens do Acerto de Consignação"},,oPanel2,,,,.T.,.F.,0,0)
oFld002:Align := CONTROL_ALIGN_ALLCLIENT

oGetDados:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nStyle,"Allwaystrue","AllWaysTrue","+ZB_ITEM",,,9999,,,,oDlgAut,aHeader,aCols)

ACTIVATE MSDIALOG oDlgAut ON INIT ( EnchoiceBar(oDlgAut,{|| IIF(GrvDados(@nOpc),oDlgAut:End(),.F.) } , {|| ( oDlgAut:End() , IIF(!__lSx8,RollBackSx8(),.T.) ) },,aButtons) )

IF __lSX8 .And. nOpc == 3
	ConfirmSX8()
Else
	RollBackSX8()
EndIF

RestArea(aArea)

Return(.T.)   

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GrvDados(nOpc)
//////////////////////////////

Local aArea    	:= GetArea()
Local cChavePsq := M->ZA_NUMFEC
Local nPsItem	:= aScan(oGetDados:aHeader,{|x| AllTrim(x[2])=="ZB_ITEM"})
Local nX		:= 0
Local nX2		:= 0
Local nResp		:= 0

Conout("*** La Selva - Static Function GrvDados - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida campos obrigatorios.			                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF !Obrigatorio(aGets,aTela) .Or. !oGetDados:TudoOk()
	Return(.F.)
EndIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Confirma numeracao sequencial.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF __lSX8 .And. nOpc == 3
	ConfirmSX8()
Else
	RollBackSX8()
EndIF

IF nOpc == 3 .Or. nOpc == 4 .Or. nOpc == 5 
	
	Begin Transaction
	
	If nOpc == 5
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Quando exclusao.                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SZA")
		DbSetOrder(1)
		DbSeek( xFilial("SZA")+M->ZA_NUMFEC )
		Do While !Eof() .And. SZA->ZA_FILIAL+SZA->ZA_NUMFEC == xFilial("SZA")+M->ZA_NUMFEC
			RecLock("SZA",.F.)
			DbDelete()
			MsUnLock()
			DbSkip()
		EndDo
		
		DbSelectArea("SZB")
		DbSetOrder(1)
		DbSeek( xFilial("SZB")+M->ZA_NUMFEC )
		Do While !Eof() .And. SZB->ZB_FILIAL+SZB->ZB_NUMFEC == xFilial("SZB")+M->ZA_NUMFEC
			
			AtuSldSZ9(SZB->ZB_NUMFEC, SZB->ZB_FORNECE, SZB->ZB_LOJA, SZB->ZB_PRODUTO)
			
			RecLock("SZB",.F.)
			DbDelete()
			MsUnLock()
			DbSkip()
			
		EndDo	
		
		DbSelectArea("SZC")
		DbSetOrder(1)
		If DbSeek(xFilial("SZC")+M->ZA_FORNECE+M->ZA_LOJAFOR) 
			RecLock("SZC",.F.)
			SZC->ZC_DTACERT := SZC->ZC_DTACERT
			MsUnLock()
		EndIf	
		
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Quando Inclusao/Alteracao.                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SZA")
		DbSetOrder(1)
		RecLock("SZA",!DbSeek( xFilial("SZA") + cChavePsq ))
		For nX := 1 To SZA->( FCount() )
			IF !( Alltrim( FieldName(nX) ) $ "ZA_FILIAL/ZA_STATUS" )
				FieldPut(nX,M->&( FieldName(nX) ))
			Else
				SZA->ZA_FILIAL := xFilial("SZA")
			EndIF
		Next nX
		MsUnLock()
		
		DbSelectArea("SZB")
		SZB->( DbSetOrder(2) )
		For nX := 1 To Len(oGetDados:aCols)
			
			lAchou := DbSeek( xFilial("SZB")+M->ZA_NUMFEC+oGetDados:aCols[nX,nPsItem] )
			
			IF oGetDados:aCols[nX,Len(oGetDados:aHeader)+1]
				
				IF lAchou   
				
					AtuSldSZ9(SZB->ZB_NUMFEC, SZB->ZB_FORNECE, SZB->ZB_LOJA, SZB->ZB_PRODUTO)
					
					RecLock("SZB",.F.)
					DbDelete()
					MsUnLock()
				
				EndIF
				
			Else
				
				RecLock("SZB",!lAchou)
				For nX2 := 1 To Len(oGetDados:aHeader)
					IF ( oGetDados:aHeader[nX2][10] != "V" )
						FieldPut(FieldPos(oGetDados:aHeader[nX2][2]),oGetDados:aCols[nX][nX2])
					EndIF
				Next
				ZB_FILIAL := xFilial("SZB")
				ZB_NUMFEC := M->ZA_NUMFEC
				SZB->( MsUnLock() )
				
			EndIF
			
		Next nX
		
	EndIF
	
	End Transaction
	
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia e-mail para destinatarios.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RestArea(aArea)

Return(.T.)    

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AtuSldSZ9(_cNumFec, cFornece, cLoja, cProduto)
//////////////////////////////////////////////////////////////
Conout("*** La Selva - Static Function AtuSldSZ9 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

DbSelectArea("SZ9")
DbSetOrder(3)
If SZ9->( DbSeek(xFilial("SZ9") + cProduto) )
	RecLock("SZ9",.F.)
	SZ9->Z9_QUANT	:= SZ9->Z9_QUANT + SZB->ZB_SALDO
	MsUnLock()
EndIf	
					
Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function FATP02H()
/////////////////////////
Local _aPedNF	:= {}
Private oDlgHist

Conout("*** La Selva - Static Function FATP02H - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQry := " SELECT C5_NUM+' - PV ' AS PVC "
cQry += " FROM " + RetSqlName("SC5") + " SC5 (NOLOCK) "
cQry += " WHERE C5_FILIAL = '" + xFilial("SC5") + "' AND C5_NUMFEC = '" + _cNumSZA + "'"
cQry += " AND SC5.D_E_L_E_T_ = '' "

cQry += " UNION ALL "

cQry += " SELECT DISTINCT(C7_NUM) + ' - PC ' AS PVC "
cQry += " FROM " + RetSqlName("SC7") + " SC7 (NOLOCK) "
cQry += " WHERE C7_FILIAL = '" + xFilial("SC7") + "'" 
cQry += " AND C7_NUMFEC = '" + _cNumSZA + "'"
cQry += " AND SC7.D_E_L_E_T_ = '' "
TcQuery cQry NEW ALIAS "TMP"

DbGoTop() 
If !Eof()
	
	DbSelectArea("TMP")
	DbGoTop()
	Do While !Eof()
		Aadd( _aPedNF,{TMP->PVC} )
		DbSkip()
	EndDo	
	 
	DEFINE MSDIALOG oDlgHist FROM 000,000 TO 240,265 TITLE "Histórico" PIXEL
			
	@ 10,8 LISTBOX oLbx FIELDS HEADER "Pedidos de Venda/Compra" SIZE 120,80 NOSCROLL OF oDlgHist PIXEL
		
	oLbx:SetArray(_aPedNF)
	oLbx:bLine := {|| {_aPedNF[oLbx:nAt,1]}}

	@ 100,050 BUTTON "Fechar"  SIZE 040,015 OF oDlgHist PIXEL ACTION(oDlgHist:End()) 
   		
	ACTIVATE MSDIALOG oDlgHist CENTERED
	
Else 
  
	Aviso("Acerto de Consignação","Não existem pedidos para esse acerto!",{"Ok"})			
	Return(.F.)	
	
EndIf	

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FATP02L()
///////////////////////
Local _aLegenda := {}

Conout("*** La Selva - User Function FATP02L - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

aAdd(_aLegenda , {'BR_VERDE'	,'Digitado'		})
aAdd(_aLegenda , {'BR_VERMELHO'	,'Processado'	})

BrwLegenda("Acerto de Consignação",'Legenda',_aLegenda)
	
Return(.T.)          