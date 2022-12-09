#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_SZM
// Autor 		Alexandre Dalpiaz
// Data 		30/08/10
// Descricao  	manutenção de chamados helpdesk
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_SZM()
///////////////////////

Local aArea  	:= GetArea()
Local cAlias  	:= "SZM"
Local aCores  	:= {}
Public _aAllUser   := AllUsers()
Private aRotina    := {}
Private cCadastro  := "Chamados HelpDesk"
Private aLegenda   := {}
Private aCores     := {}
aAdd(aLegenda, {'BR_VERDE'	  	,'Em Aberto'		, '1'	})
aAdd(aLegenda, {'BR_AZUL' 		,'Atendendo'		, '2'	})
aAdd(aLegenda, {'BR_VERMELHO'	,'Suspenso' 		, '3'	})
aAdd(aLegenda, {'BR_CINZA'   	,'Com Usuário'		, '4'	})
aAdd(aLegenda, {'BR_MARROM'  	,'Reaberto' 		, '5'	})
aAdd(aLegenda, {'BR_PRETO'   	,'Encerrado'		, '6'	})

Aadd(aCores,{ "ZM_STATUS == '1' " , 'BR_VERDE'		}) // aberto
Aadd(aCores,{ "ZM_STATUS == '2' " , 'BR_AZUL'		}) // atendendo
Aadd(aCores,{ "ZM_STATUS == '3' " , 'BR_VERMELHO'	}) // suspenso
Aadd(aCores,{ "ZM_STATUS == '4' " , 'BR_CINZA'   	}) // com usuario
Aadd(aCores,{ "ZM_STATUS == '5' " , 'BR_MARROM'  	}) // reaberto
Aadd(aCores,{ "ZM_STATUS == '6' " , 'BR_PRETO'   	}) // encerrado

Aadd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
Aadd(aRotina,{"Visualizar"  		,"U_LS_SZM01" 		,0,2 })
Aadd(aRotina,{"Incluir"  			,"U_LS_SZM01"		,0,3 })
Aadd(aRotina,{"Alterar"  			,"U_LS_SZM01" 		,0,4 })
If __cUserId $ GetMv('LA_PODER')
	Aadd(aRotina,{"Excluir"  			,"U_LS_SZM01" 		,0,5 })
EndIf
/*
Aadd(aRotina,{"Pendentes"  			,"U_LS_SZM04" 		,0,6 })
Aadd(aRotina,{"Encerrados" 			,"U_LS_SZM04" 		,0,7 })
Aadd(aRotina,{"Todos"	 			,"U_LS_SZM04" 		,0,8 })
*/
Aadd(aRotina,{"Legenda"  			,"U_LS_SZM01"		,0,9 })

DbSelectArea('SZM')
_aInd    := {}
If !(__cUserId $ GetMv('LA_PODER'))
	_cFiltro := "ZM_CLIENTE == '" + __cUserId + "'"
	bFiltraBrw := {|| FilBrowse("SZM",@_aInd,@_cFiltro) }
	Eval(bFiltraBrw)
Else
	_cFiltro := "ZM_FILIAL == '  '" 
EndIf

mBrowse( 7, 4,20,74,cAlias,,,,,,aCores)

DbSelectArea(cAlias)
RestArea(aArea)

Return(.T.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// VISUALIZA
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_SZM01(cAlias,nReg,nOpc)
////////////////////////////////////////

Local oPanel1
Local oPanel2
Local oPanel3
Local oFld001
Local oFld002
Local oFld003
Local oEnchoice
Local oDlgAut
Local _nI	:= 0
Local nStyle   	:= 0

Local aArea	   	:= GetArea()
Local cAlias   	:= Alias()
Local aSize    	:= MsAdvSize()
Local aGrupos	:= UsrRetGrp()
Local aAllGrp	:= AllGroups(.T.)
Local cGrupos	:= ""
Local aButtons 	:= {{"DBG12"	,{||LS_SZM02()},"eMail" }}

//Local aButtons   := {{"Destinos",{||ExpCesRep()},"Replica de Cesta" },{"DBG12"	,{||EXPF403A()},"Saldo em Estoque" },{"ALTERA"	,{||EXPALTCL()},"Alteracao do Cliente" }}

Private _cNumSZM	:= SZM->ZM_TICKET
Private nOpca	 	:= 0
Private aHeader   	:= {}
Private aCols     	:= {}
Private oGetDados
Private aTela[0][0]
Private aGets[0]

DbSelectArea(cAlias)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as variaveia da Enchoice.               	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory(cAlias,IIF(nOpc==3,.T.,.F.))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader a partir dos campos do SX3         	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetorder(1)
MsSeek("SZL")
Do While !Eof() .And. (X3_ARQUIVO == "SZL")
	
	If !(Alltrim(X3_CAMPO) $ "ZL_FILIAL,ZL_TICKET")
		
		IF (cNivel >= X3_NIVEL)
			Aadd(aHeader,{Alltrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
			SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,".T."})
		EndIF
		
	EndIf
	
	DbSkip()
	
EndDo

M->ZM_HISTOR := ''
M->ZM_TEMPO  := ''
DbSelectArea("SZL")
DbSetorder(1)
DbSeek(xFilial("SZL") + M->ZM_TICKET)
Do While !Eof() .And. (SZL->ZL_FILIAL + SZL->ZL_TICKET == xFilial("SZL") + M->ZM_TICKET)
	
	Aadd(aCols,Array(Len(aHeader)+1))
	
	For nY	:= 1 To Len(aHeader)
		IF ( aHeader[nY][10] != "V" )
			aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
		Else
			aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
		EndIF
	Next nY
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	
	M->ZM_HISTOR += _aAllUser[aScan(_aAllUser,{|x| x[1,1] == SZL->ZL_TECNICO}),1,2] + ' em: ' + dtoc(SZL->ZL_DATA) + ' -> ' + tran(SZL->ZL_INICIO,'@R 99:99') + ' - ' + tran(SZL->ZL_FIM,'@R 99:99') + _cEnter
	M->ZM_HISTOR += SZL->ZL_ACAO + _cEnter  + _cEnter
	M->ZM_TEMPO  := strzero(SomaHoras(M->ZM_TEMPO,SubHoras(SZL->ZL_FIM,SZL->ZL_INICIO)),4)
	
	DbSelectArea("SZL")
	DbSkip()
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Na inclusao Monta o Array com 1 elemento vazio         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
n := 0
If Len(aCols) == 0

	aCols := {}
	Aadd(aCols,Array(Len(aHeader)+1))
	For nY := 1 To Len(aHeader)
		aCols[Len(aCols),nY] := CriaVar(aHeader[nY][2])
	Next nY
	aCols[Len(aCols),Len(aHeader)+1] := .F.

ElseIf !(__cUserId $ GetMv('LA_PODER')) .and. altera

	Aadd(aCols,Array(Len(aHeader)+1))
	
	aCols[Len(aCols),02] := aCols[len(aCols)-1,2]
	aCols[Len(aCols),03] := upper(_aAllUser[ aScan(_aAllUser,{|x| x[1,1] == aCols[len(aCols)-1,2]}) ,1,2])
	aCols[Len(aCols),04] := aCols[len(aCols)-1,4]
	aCols[Len(aCols),05] := '0000'
	aCols[Len(aCols),06] := '0000'
	aCols[Len(aCols),08] := '1'
	aCols[Len(aCols)][Len(aHeader)+1] := .F.

EndIf

Do Case
	Case nOpc == 3
		nStyle := GD_INSERT+GD_UPDATE+iif((__cUserId $ GetMv('LA_PODER')),GD_DELETE,0)
	Case nOpc == 4
		nStyle := GD_INSERT+GD_UPDATE+iif((__cUserId $ GetMv('LA_PODER')),GD_DELETE,0)
	OtherWise
		nStyle := 0
EndCase

DEFINE MSDIALOG oDlgAut FROM 0,0 TO aSize[6],aSize[5] TITLE cCadastro Of oMainWnd PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria a Folder da Enchoice da SZ0                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPanel1:= TPanel():New(0, 0, "", oDlgAut, NIL, .T., .F., NIL, NIL, 0,170, .T., .F. )
oPanel1:Align:=CONTROL_ALIGN_TOP

oFld001:=TFolder():New(0,0,{"Chamados"},,oPanel1,,,,.T.,.F.,0,0)
oFld001:Align := CONTROL_ALIGN_ALLCLIENT

oEnchoice := MsMGet():New("SZM",SZM->(Recno()),nOpc,,,,,{0,0,0,0},,3,,,,oFld001:aDialogs[1]	,,.T.)
oEnchoice:oBox:Align:=CONTROL_ALIGN_ALLCLIENT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria a Folder da GetDados da SZ1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPanel2:= TPanel():New(0, 0, "", oDlgAut, NIL, .T., .F., NIL, NIL, 0,0, .T., .F. )
oPanel2:Align:=CONTROL_ALIGN_ALLCLIENT

oFld002:=TFolder():New(0,0,{"Atendimentos do Chamado"},,oPanel2,,,,.T.,.F.,0,0)
oFld002:Align := CONTROL_ALIGN_ALLCLIENT
oGetDados:= MsNewGetDados():New(0,0,0,0,nStyle,"Allwaystrue","U_LS_SZMVL","+dtos(ZL_DATA) + ZL_HORAINI",,,99999,,,,oFld002:aDialogs[1],aHeader,aCols)
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LASE1Grv(nOpc)  
//////////////////////////////

Local aArea    	:= GetArea()
Local _nI		:= 0
Local _nI2		:= 0
Local nResp		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida campos obrigatorios.			                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !Obrigatorio(aGets,aTela) .or. !oGetDados:TudoOk()
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
		DbSelectArea("SZM")
		DbSetOrder(1)
		DbSeek(xFilial("SZM") + M->ZM_TICKET)
		RecLock("SZM",.F.)
		DbDelete()
		MsUnLock()
		
		DbSelectArea("SZL")
		DbSetOrder(1)
		DbSeek(xFilial("SZL") + M->ZM_TICKET)
		Do While !Eof() .And. SZL->ZL_FILIAL + SZL->ZL_TICKET == xFilial("SZL") + M->ZM_TICKET
			RecLock("SZL",.F.)
			DbDelete()
			MsUnLock()
			DbSkip()
		EndDo
		
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Quando Inclusao/Alteracao.                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SZM")
		DbSetOrder(1)
		IF !DbSeek(xFilial("SZM") + M->ZM_TICKET,.f.)
			RecLock("SZM",.T.)
		Else
			Reclock("SZM",.F.)
		EndIF
		
		SZM->ZM_FILIAL := xFilial("SZM")
		For _nI := 2 To SZM->(FCount())
			FieldPut(_nI,M->&(FieldName(_nI)))
		Next _nI           
		MsUnLock()
		                
		aCols := aClone(oGetDados:aCols)
		DbSelectArea("SZL")
		DbSetOrder(1)
		For _nI := 1 To Len(aCols)
			
			_lAchou := DbSeek(xFilial("SZL") + M->ZM_TICKET + GdFieldGet('ZL_ITEM',_nI))
			
			If GdDeleted(_nI)
				/*
				IF _lAchou
					RecLock("SZL",.F.)
					DbDelete()
					MsUnLock()
				EndIF
				*/
				MsgBox('Não é permitido excluir histórico de atendimento','ATENÇÃO!!!','INFO')
			Else
				
				If !empty(GdFieldGet('ZL_INICIO',_nI))
				
					RecLock("SZL",!_lAchou)                 	
					For _nI2 := 1 To Len(oGetDados:aHeader)
						IF ( oGetDados:aHeader[_nI2][10] != "V" )
							FieldPut(FieldPos(oGetDados:aHeader[_nI2][2]),aCols[_nI][_nI2])
						EndIF
					Next
					SZL->ZL_FILIAL := xFilial("SZL")
					SZL->ZL_TICKET := M->ZM_TICKET
					MsUnLock()
					            
					RecLock('SZM',.f.)
					SZM->ZM_STATUS  := SZL->ZL_SITUACA
					SZM->ZM_TECNICO := SZL->ZL_TECNICO
					//SZM->ZM_NOMETEC := SZL->ZL_TECNICO
					//SZM->ZM_MAILTEC := SZL->ZL_TECNICO
					MsUnLock()

					DbSelectArea("SZL")

				
				EndIf
				
			EndIF
			
		Next _nI
		
	EndIf
	
	End Transaction
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia e-mail para destinatarios.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RestArea(aArea)

Return(.T.)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// validaçao da linha
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_SZMVL()
////////////////////////
Local _lRet := .t.

If altera
	If empty(GdFieldGet('ZL_INICIO'))
		MsgAlert('Informe a data do início do antedimento')
		_lRet := .f.
	EndIf
	If empty(GdFieldGet('ZL_ACAO'))
		MsgAlert('Informe a descrição do atendimento')
		_lRet := .f.
	EndIf
	If empty(GdFieldGet('ZL_SITUACA'))
		MsgAlert('Informe a situação atual do antedimento')
		_lRet := .f.
	EndIf
EndIf
Return(_lRet)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// filtra os chamados
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_SZM04(cAlias,nReg,nOpc)
////////////////////////////////////////
Local _cFiltro
Local _aInd := {}

If !(__cUserId $ GetMv('LA_PODER'))
	_cFiltro := "ZM_CLIENTE == '" + __cUserId + "'"
Else
	_cFiltro := "ZM_FILIAL == '  '" 
EndIf

If nOpc == 6		// pendentes
	_cFiltro += " .and. ZM_STATUS <> '6'"
ElseIf nOpc == 7	// encerrados
	_cFiltro += " .and. ZM_STATUS == '6'"
EndIf

bFiltraBrw := {|| FilBrowse("SZM",@_aInd,@_cFiltro) }
Eval(bFiltraBrw)
		

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_SZMLE()
////////////////////////

BrwLegenda("Chamados" , 'Legenda' , aLegenda)

Return(.T.)