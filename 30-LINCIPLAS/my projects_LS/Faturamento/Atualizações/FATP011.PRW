#Include "Protheus.ch" 

#Define GD_INSERT 1
#Define GD_UPDATE 2                                                                                                                       
#Define GD_DELETE 4

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATP011   º Autor ³ Antonio Carlos     º Data ³  07/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsavel pelo processamento do Acerto de Consig  º±±
±±º          ³ nacao em Pedido de Compra.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATP011()

Local aArea  	:= GetArea()
Local cAlias  	:= "SZD"
Local aCores  	:= {}

Private aRotina    := {}
Private cCadastro  := "Acerto de Consignacao - Coligadas"

Private aLegenda := {;
{'BR_VERDE'	  	,'Em Aberto'		, 'A'	},;
{'BR_AZUL' 		,'Processado'		, 'P'	},;
{'BR_VERMELHO'	,'Finalizado'		, 'F'	}}

Aadd(aCores,{ "ZD_STATUS == 'A' " , 'BR_VERDE'		}) // Digitado
Aadd(aCores,{ "ZD_STATUS == 'P' " , 'BR_AZUL'		}) // Processado
Aadd(aCores,{ "ZD_STATUS == 'F' " , 'BR_VERMELHO'	}) // Finalizado

Aadd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
Aadd(aRotina,{"Visualizar"  		,"U_GeraPed" 		,0,2 })
Aadd(aRotina,{"Incluir"  			,"U_GeraPed"		,0,3 })
Aadd(aRotina,{"Alterar"  			,"U_GeraPed" 		,0,4 })
Aadd(aRotina,{"Excluir"  			,"U_GeraPed" 		,0,5 })
Aadd(aRotina,{"Processa"			,"U_FATP012"		,0,6 })
//Aadd(aRotina,{"Legenda"  			,"U_LASE001L"		,0,7 })

mBrowse( 7, 4,20,74,cAlias,,,,,,aCores)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cAlias)
RestArea(aArea)

Return(.T.)    

User Function GeraPed(cAlias,nReg,nOpc)

Local oPanel1
Local oPanel2
Local oPanel3
Local oFld001
Local oFld002
Local oFld003
Local oEnchoice
Local oDlgAut

Local nX		:= 0
Local nStyle   	:= 0

Local aArea	   	:= GetArea()
Local cAlias   	:= Alias()
Local aSize    	:= MsAdvSize()
Local aGrupos	:= UsrRetGrp()
Local aAllGrp	:= AllGroups(.T.)
Local cGrupos	:= ""
Local aButtons 	:= {{"DBG12"	,{||LASEHIST()},"Historico" }}   
//Local aButtons   := {{"Destinos",{||ExpCesRep()},"Replica de Cesta" },{"DBG12"	,{||EXPF403A()},"Saldo em Estoque" },{"ALTERA"	,{||EXPALTCL()},"Alteracao do Cliente" }}

Private _cNumSZD	:= SZD->ZD_NUMAC
Private nOpca	 	:= 0
Private aHeader   	:= {}
Private aCols     	:= {}
Private oGetDados
Private aTela[0][0]
Private aGets[0]

DbSelectArea(cAlias)

If (nOpc == 3 .Or. nOpc == 4 .Or. nOpc == 5)
	Aviso("Acerto de Consignacao","Opcao indisponivel nesta rotina!",{"Ok"})			
	Return(.F.)
EndIf 

//If (nOpc == 4 .Or. nOpc == 5) .And. SZA->ZA_STATUS == "P"
	//Aviso("Acerto de Consignacao","Acerto já processado, nao sera possivel realizar 'Alteracao/Exclusao' !",{"Ok"})			
	//Return(.F.)
//EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as variaveia da Enchoice.               	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory(cAlias,IIF(nOpc==3,.T.,.F.))
//For nX := 1 To FCount()
	//M->&(FieldName(nX)) := CriaVar(FieldName(nX))
//Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader a partir dos campos do SX3         	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetorder(1)
MsSeek("SZE")                         
While !Eof() .And. (X3_ARQUIVO == "SZE")
	
	If Alltrim(X3_CAMPO) $ "ZE_ITEM/ZE_PRODUTO/ZE_DESCRI/ZE_QUANT"
		
		//IF X3Uso(X3_USADO) .And. (cNivel >= X3_NIVEL)
		IF (cNivel >= X3_NIVEL)
			Aadd(aHeader,{Alltrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
			SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,".T."})
		EndIF
	
	EndIf	
	
	DbSkip()
	
EndDo

DbSelectArea("SZE")
DbSetorder(1)
DbSeek(xFilial("SZE")+M->ZD_NUMAC)
While !Eof() .And. (SZE->ZE_FILIAL+SZE->ZE_NUMAC == xFilial("SZD")+M->ZD_NUMAC)
	
	Aadd(aCols,Array(Len(aHeader)+1))
	
	For nY	:= 1 To Len(aHeader)
		IF ( aHeader[nY][10] != "V" )
			aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
		Else
			aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
		EndIF
	Next nY
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	DbSelectArea("SZE")
	DbSkip()
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Na inclusao Monta o Array com 1 elemento vazio         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Len(aCols) == 0
	aCols := {}
	Aadd(aCols,Array(Len(aHeader)+1))
	For nY := 1 To Len(aHeader)
		IF AllTrim(aHeader[nY][2]) == "ZE_ITEM"
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
oPanel1:= TPanel():New(0, 0, "", oDlgAut, NIL, .T., .F., NIL, NIL, 0,150, .T., .F. )
oPanel1:Align:=CONTROL_ALIGN_TOP

oFld001:=TFolder():New(0,0,{"Cabecalho do Acerto de Consignacao"},,oPanel1,,,,.T.,.F.,0,0)
oFld001:Align := CONTROL_ALIGN_ALLCLIENT

oEnchoice := MsMGet():New("SZD",SZD->(Recno()),nOpc,,,,,{0,0,0,0},,3,,,,oFld001:aDialogs[1]	,,.T.)
oEnchoice:oBox:Align:=CONTROL_ALIGN_ALLCLIENT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria a Folder da GetDados da SZ1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPanel2:= TPanel():New(0, 0, "", oDlgAut, NIL, .T., .F., NIL, NIL, 0,0, .T., .F. )
oPanel2:Align:=CONTROL_ALIGN_ALLCLIENT

oFld002:=TFolder():New(0,0,{"Itens do Acerto de Consignacao"},,oPanel2,,,,.T.,.F.,0,0)
oFld002:Align := CONTROL_ALIGN_ALLCLIENT
oGetDados:= MsNewGetDados():New(0,0,0,0,nStyle,"Allwaystrue","AllWaysTrue","+ZE_ITEM",,,99999,,,,oFld002:aDialogs[1],aHeader,aCols)
oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlgAut ON INIT ( EnchoiceBar(oDlgAut,{|| IIF(LASE1Grv(@nOpc),oDlgAut:End(),.F.) } , {|| ( oDlgAut:End() , IIF(!__lSx8,RollBackSx8(),.T.) ) },,aButtons) )

//ACTIVATE MSDIALOG oDlgAut CENTERED ON INIT EnchoiceBar(oDlgAut,{||nOpcA:=1,If(oGetDados:TudoOk(),oDlgAut:End(),nOpcA := 0)},{||oDlgAut:End()})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Confirma numeracao sequencial.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF __lSX8 .And. nOpc == 3
	ConfirmSX8()
Else
	RollBackSX8()
EndIF

RestArea(aArea)

Return(.T.)   

Static Function LASE1Grv(nOpc)

Local aArea    	:= GetArea()
Local cChavePsq := M->ZA_NUMFEC
Local nPsItem	:= aScan(oGetDados:aHeader,{|x| AllTrim(x[2])=="ZB_ITEM"})
Local nX		:= 0
Local nX2		:= 0
Local nResp		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida campos obrigatorios.			                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//IF !( Obrigatorio(aGets,aTela) .Or. oGetDados:TudoOk() )
	//Return(.F.)
//EndIF

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
	
	IF nOpc == 5
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Quando exclusao.                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SZA")
		DbSetOrder(1)
		DbSeek(xFilial("SZA")+M->ZA_NUMFEC)
		While !Eof() .And. SZA->ZA_FILIAL+SZA->ZA_NUMFEC == xFilial("SZA")+M->ZA_NUMFEC
			RecLock("SZA",.F.)
			DbDelete()
			MsUnLock()
			DbSkip()
		EndDo
		
		DbSelectArea("SZB")
		DbSetOrder(1)
		DbSeek(xFilial("SZB")+M->ZA_NUMFEC)
		While !Eof() .And. SZB->ZB_FILIAL+SZB->ZB_NUMFEC == xFilial("SZB")+M->ZA_NUMFEC
			RecLock("SZB",.F.)
			DbDelete()
			MsUnLock()
			DbSkip()
		EndDo	
		
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Quando Inclusao/Alteracao.                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SZA")
		DbSetOrder(1)
		IF !DbSeek(xFilial("SZA")+cChavePsq)
			RecLock("SZA",.T.)
		Else
			Reclock("SZA",.F.)
		EndIF
		For nX := 1 To SZA->(FCount())
			IF !( Alltrim(FieldName(nX)) $ "ZA_FILIAL/ZA_STATUS" )
				FieldPut(nX,M->&(FieldName(nX)))
			Else
				ZA_FILIAL := xFilial("SZA")
			EndIF
		Next nX
		MsUnLock()
		
		DbSelectArea("SZB")
		DbSetOrder(2)
		For nX := 1 To Len(oGetDados:aCols)
			
			lAchou := DbSeek(xFilial("SZB")+M->ZA_NUMFEC+oGetDados:aCols[nX,nPsItem])
			
			IF oGetDados:aCols[nX,Len(oGetDados:aHeader)+1]
				
				IF lAchou
					RecLock("SZB",.F.)
					DbDelete()
					MsUnLock()
				EndIF
				
			Else
				
				IF lAchou
					RecLock("SZB",.F.)
				Else
					RecLock("SZB",.T.)
				EndIF
				For nX2 := 1 To Len(oGetDados:aHeader)
					IF ( oGetDados:aHeader[nX2][10] != "V" )
						FieldPut(FieldPos(oGetDados:aHeader[nX2][2]),oGetDados:aCols[nX][nX2])
					EndIF
				Next
				ZB_FILIAL := xFilial("SZB")
				ZB_NUMFEC := M->ZA_NUMFEC
				MsUnLock()
				
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

Static Function LASEHIST()

Local _aPedNF	:= {}
Private oDlgHist

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQry := " SELECT DISTINCT(C7_NUM), C5_NUM, C5_NOTA, C5_SERIE "
cQry += " FROM " +RetSqlName("SC5")+" SC5 (NOLOCK), "+RetSqlName("SC7")+" SC7 (NOLOCK)"
cQry += " WHERE " 
cQry += " C5_FILIAL = '"+xFilial("SC5")+"' AND "
cQry += " C7_FILIAL = '"+xFilial("SC7")+"' AND "
cQry += " C5_NUMFEC = '"+_cNumSZA+"' AND "
cQry += " C7_NUMFEC = '"+_cNumSZA+"' AND "
cQry += " SC5.D_E_L_E_T_ = ''  AND "
cQry += " SC7.D_E_L_E_T_ = '' "  
cQry += " ORDER BY C7_NUM, C5_NUM "  

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), "TMP", .F., .T.)

DbSelectArea("TMP")
TMP->(DbGoTop())
If TMP->(!Eof())
	
	DbSelectArea("TMP")
	TMP->(DbGoTop())	
	While !TMP->(Eof())
		Aadd(_aPedNF,{TMP->C7_NUM,TMP->C5_NUM,TMP->C5_NOTA+" - "+TMP->C5_SERIE})
		TMP->(DbSkip())
	EndDo	
	 
	DEFINE MSDIALOG oDlgHist FROM 000,000 TO 240,265 TITLE "Historico" PIXEL
			
	@ 10,8 LISTBOX oLbx FIELDS HEADER "Pedido de Compra","Pedido de Venda","Nota Fiscal" SIZE 120,80 NOSCROLL OF oDlgHist PIXEL
		
	oLbx:SetArray(_aPedNF)
	oLbx:bLine:={|| {_aPedNF[oLbx:nAt,1],_aPedNF[oLbx:nAt,2],_aPedNF[oLbx:nAt,3]}}

	@ 100,050 BUTTON "Fechar"  SIZE 040,015 OF oDlgHist PIXEL ACTION(oDlgHist:End()) 
   		
	ACTIVATE MSDIALOG oDlgHist CENTERED
	
Else 
  
	Aviso("Acerto de Consignacao","Nao existem pedidos para esse acerto!",{"Ok"})			
	Return(.F.)	
	
EndIf	

Return

//User Function LASE001L()

//BrwLegenda("Acerto de Consignacao",'Legenda',{{'BR_VERDE','Digitado'	},;
//{'BR_VERMELHO'		,'Processado'	 			}})
	
//Return(.T.)          