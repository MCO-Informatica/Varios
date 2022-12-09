#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSMGADD.CH"

#DEFINE nCSEINCLUI 9

STATIC nQtdEntid

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSEA010  ºAutor  ³ TOTVS PROTHEUS     º Data ³  06/01/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de Configuracoes de Entidades Contabeis.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSEA010()

Local cAlias  		:= "CT0"
Local cExpFil		:= "CT0_ALIAS = 'CV0'" // DISPONIBILIZA AS FUNCIONALIDADES APENAS PARA AS ENTIDADES CONTROLADAS NA CV0 - PLANOS DE ENTIDADES CONTABEIS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes				        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCadastro := "Manutencao de planos de entidades contabeis"

Private aRotina  	:= MenuDef()

dbSelectArea(cAlias)
(cAlias)->(dbSetOrder(1)) // CT0_FILIAL + CT0_ID
(cAlias)->(dbGotop())
mBrowse( 6, 1,22,75,cAlias,,,,,,,,,,,,,,cExpFil)	

RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010DLG ºAutor  ³ TOTVS PROTHEUS     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Dialog de Visualizacao, Inclusão, Alteração, Exclusao      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSE010DLG(cAlias,nReg,nOpc)

// variaveis de tela
Local cCadastro		:= "Entidades Contabeis"
Local oDlg
Local oEnch,oPlano,oDesc
Local aExbCpo		:= {"CV0_PLANO","CV0_DESC","NOUSER"}
Local aHeaderCV0
Local aColsCV0		:= {}
Local aRecnosCV0	:= {}
Local nOpcao		:= 0
Local aSizeAut		:= {}
Local aObjects		:= {}
Local aButtons		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}// variaveis de integridade
Local aArea			:= (cAlias)->(GetArea())
// variaveis de controle
Local bOk			:= { || IIf(U_CSE010TK() , (nOpcao:=1,oDlg:End()) , nOpcao := 0) }
Local bCancel		:= { || nOpcao:=0 , oDlg:End() }
Local cGetOpc		:= Nil
Local nX
Local lDefTop 		:= IIF(FindFunction("IfDefTopCTB") , IfDefTopCTB() , .F.) // verificar se pode executar query (TOPCONN)   
Local cItem			:= StrZero(0,TamSX3("CV0_ITEM")[1])
Private oGDItens
Private cPlanoCV0
Private nLinInc
Private aGets		:= {} 
Private aTela		:= {}
Private bLinGtd		:= {|| If(Valtype(oGDItens)="O",oGDItens:nAt,0) }
Private INCLUI		:= .F.

//Tratamento para executar a opcao que se deseja 
//Necessario por nao ter rotina de Inclusao.
//nOpc chega com a posição do array aRotina
//Para que na confirmacao da inclusao nao seja exibida a tela vazia novamente, na mBrowse e informada uma opcao diferente de 3
nOpc := IIF( aRotina[nOpc,4] == nCSEINCLUI, 3, aRotina[nOpc,4])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no primeiro registro do plano selecionado no alias CV0		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("CV0")
DbSetOrder(1) //CV0_FILIAL+CV0_PLANO+CV0_CODIGO
IF nOpc != 3 .AND. !DbSeek(xFilial("CV0")+CT0->CT0_ENTIDA)
	HELP(" ",1,"CSE010DLG.01",,"Nao existe o cadastro de plano de entidades selecionado."+CRLF+;
										 "Favor selecionar outra opcao de manutencao para a entidade contabil.",4,0)
	RestArea(aArea)
	Return
ELSEIF nOpc == 3 .AND. DbSeek(xFilial("CV0")+CT0->CT0_ENTIDA)
	HELP(" ",1,"CSE010DLG.02",,"Ja existe o cadastro de plano de entidades selecionado."+CRLF+;
										 "Favor selecionar outra opcao de manutencao para a entidade contabil.",4,0)
	RestArea(aArea)
	Return
ENDIF

nReg   := IIf(nOpc==3,Nil,CV0->(Recno()))
cAlias := "CV0"

// Maximizacao da tela em relação a area de trabalho
aSizeAut := MsAdvSize()
aAdd(aObjects,{100,040,.T.,.F.})
aAdd(aObjects,{100,100,.T.,.T.})

aInfo     := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj   := MsObjSize(aInfo,aObjects)

If nOpc == 2	//Visualização
	nOpEnch	:= 2
	INCLUI	:= .F.
	ALTERA	:= .F.
	cPlanoCV0 := CV0->CV0_PLANO
	cDescCV0 := CV0->CV0_DESC
ElseIf nOpc == 3	//Inclusão
	nOpEnch	:= 3
	INCLUI	:= .T.
	ALTERA	:= .F.
	cPlanoCV0 := CT0->CT0_ENTIDA
	cDescCV0 := CT0->CT0_DESC
ElseIf nOpc == 4	//Alteração
	nOpEnch	:= 3   
	INCLUI	:= .F.
	ALTERA	:= .T.
	cPlanoCV0 := CV0->CV0_PLANO
	cDescCV0 := CV0->CV0_DESC
ElseIf nOpc == 5	//Exclusão
	nOpEnch	:= 5   
	INCLUI	:= .F.
	ALTERA	:= .F.
	cPlanoCV0 := CV0->CV0_PLANO
	cDescCV0 := CV0->CV0_DESC
Else //Outras situações
	nOpEnch	:= 2   
	INCLUI	:= .F.
	ALTERA	:= .F.
	cPlanoCV0 := CV0->CV0_PLANO
	cDescCV0 := CV0->CV0_DESC
EndIf

cGetOpc := Iif(Altera .OR. Inclui, GD_INSERT+GD_DELETE+GD_UPDATE, 0)

If !CSE010Tab(CV0->CV0_PLANO)
	Return
EndIf

If !lDefTop
	EndFilBrw(cAlias,aIndexCV0)
Endif

//Define teclas de atalho para os botoes da enchoice
SetKey( VK_F4, {|| GdSeek(oGDItens,"Pesquisar",aHeaderCV0,aColsCV0,.F.)} )

//Definicao dos botoes adicionais da enchoice
aAdd( aButtons, { "PMSPESQ",{|| GdSeek(oGDItens,"Pesquisar",aHeaderCV0,aColsCV0,.F.)}, "Pesquisar", "Pesquisar - <F4>"})

// Montagem da tela que serah apresentada para usuario (lay-out)
Define MsDialog oDlg Title cCadastro From aSizeAut[7],0 To aSizeAut[6],aSizeAut[5] Of oMainWnd Pixel

@ 028,008 	SAY OemToAnsi("Plano") SIZE 18, 7 OF oDlg PIXEL
oPlano	:=	TGet():New( 025, 038, {|u| If(PCount() > 0,cPlanoCV0 := u,cPlanoCV0) }, oDlg, 020, ,"@!",{||U_CSE010VP()},,,,,,.T./*<.pixel.>*/,,,{|| .F. },,,,,,,"cPlanoCV0"/*<(uVar)>*/	,,,)

@ 028,158 	SAY OemToAnsi("Descrição") SIZE 35, 7 OF oDlg PIXEL
oDesc		:=	TGet():New( 025, 198, {|u| If(PCount() > 0,cDescCV0 := u,cDescCV0)  }	, oDlg, 080, ,"@!",						,,,,,,.T./*<.pixel.>*/,,,{|| .F. },,,,,,,"cDescCV0"/*<(uVar)>*/	,,,)

aHeaderCV0	:= CSEA10A(cAlias,,{"CV0_PLANO"})

DbSelectArea(cAlias)
DbSetOrder(1)
If nOpc <> 3
	MsgRun("Carregando dados do plano de entidades contábeis selecionado...",cPlanoCV0+" - "+cDescCV0, {|| GetAcols(cAlias, nReg, @cPlanoCV0, aHeaderCV0, @aColsCV0, @aRecnosCV0) } )
EndIf

//******************************
// Busca utima linha com recno *
//******************************
nLinInc := Len(aRecnosCV0)

oGDItens:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],cGetOpc,"U_CSE010LK()",,"+CV0_ITEM",,,15000,,,"U_CSE010DK()",oDlg,aHeaderCV0,aColsCV0)

Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel,,aButtons)

If nOpcao == 1

	//**********************
	// Inicio da Transacão *
	//**********************
	Begin Transaction

	aColsCV0 := oGDItens:aCols
	DbSelectArea(cAlias)

	Do Case
		Case nOpc == 3
			RecLock("CV0",.T.)
			CV0->CV0_FILIAL	:= xFilial(cAlias)
			CV0->CV0_PLANO	:= cPlanoCV0
			CV0->CV0_DESC	:= cDescCV0  
			MsUnLock()
	 	Case nOpc == 4
		DbGoTo(nReg)
			RecLock("CV0",.F.)
			CV0->CV0_FILIAL	:= xFilial(cAlias)
			CV0->CV0_PLANO	:= cPlanoCV0
			CV0->CV0_DESC	:= cDescCV0
			MsUnLock()
		Case nOpc == 5
		DbGoTo(nReg)
			RecLock("CV0",.F.,.T.)
			DbDelete()
			MsUnLock()
	EndCase
	
	For nX:= 1 to Len(aColsCV0)
		//**************************
		// Procura recno da linha  *
		//**************************
		If nX <= Len(aRecnosCV0)
			DbSelectArea(cAlias)
			DbGoTo(aRecnosCV0[nX])
	
			If !aColsCV0[nX, Len(aHeaderCV0) +1 ] .and. nOpc <> 5
				//*****************************************************
				// Altera linhas não deletadas quando nao for Delete  *
				//*****************************************************
				RecLock("CV0",.F.)
				CV0->CV0_FILIAL	:= xFilial(cAlias)
				CV0->CV0_PLANO	:= cPlanoCV0
				aEval(aHeaderCV0, {|x,y| If(x[10]<>"V",CV0->&(x[2]) := aColsCV0[nX,y],.F.) })
				MsUnLock()				
			Else
				//***********************************************
				// Deleta linhas deletas ou Delete de entidades *
				//***********************************************
				RecLock("CV0",.F.,.T.)
				DbDelete()
				MsUnLock()
			EndIf
		ElseIf !aColsCV0[nX, Len(aHeaderCV0) +1 ]
			//************************
			// Cria linhas sem recno *
			//************************
			RecLock("CV0",.T.)
			CV0->CV0_FILIAL	:= xFilial(cAlias)
			CV0->CV0_PLANO	:= cPlanoCV0
			aEval(aHeaderCV0, {|x,y| If(x[10]<>"V",CV0->&(x[2]) := aColsCV0[Nx,y],.F.) })
			MsUnLock()
					
		EndIf
	Next
	
    CV0->(dbSetOrder(1)) //CV0_FILIAL+CV0_PLANO+CV0_CODIGO
    If CV0->(MsSeek(xFilial("CV0") + cPlanoCV0 ))
    	While CV0->(!EOF()) .And. CV0->(CV0_FILIAL+CV0_PLANO) == xFilial("CV0") + cPlanoCV0
    	    If !Empty(CV0->CV0_CODIGO)
	    	    cItem := Soma1(cItem)
	    	    RecLock("CV0",.F.)
				CV0->CV0_ITEM	:= cItem
	    	    MsUnLock()
    	    EndIf
    		CV0->(dbSkip())
    	EndDo  
    EndIf 
           
	//*******************
	// Fim da Transacão *
	//*******************	
	End Transaction	
	
EndIf

If !lDefTop
	//Executa filtro automaticamente
	DbSelectArea(cAlias)
	dbSetOrder(1)                             
	Eval(bFiltraBrw)
EndIf

SetKey( VK_F4, nil)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010PlanºAutor  ³ TOTVS Protheus     º Data ³  02/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para verificacao e inclusao da linha base do        º±±
±±º          ³ do cadastro da entidade.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSEP010 - INTEGRACAO CADASTRO DE PRODUTOS X ENTIDADE 07    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION CSE010Plano(cCV0_PLAN,cCV0_DESC)

LOCAL aArea 		:= GetArea()
LOCAL cCV0_COD		:= SPACE(TAMSX3("CV0_CODIGO")[1])

DbSelectArea("CV0")
DbSetOrder(1) // CV0_FILIAL+CV0_PLANO+CV0_CODIGO
IF !DbSeek(xFilial("CV0")+cCV0_PLAN+cCV0_COD)		
	RecLock("CV0",.T.)
		CV0->CV0_FILIAL		:= xFilial("CV0")
		CV0->CV0_PLANO 		:= cCV0_PLAN
		CV0->CV0_ITEM  		:= "000000"
		CV0->CV0_CODIGO		:= cCV0_COD
		CV0->CV0_DESC  		:= cCV0_DESC
		CV0->CV0_CLASSE		:= "1"
		CV0->CV0_NORMAL		:= "2"
		CV0->CV0_ENTSUP		:= ""
		CV0->CV0_BLOQUE		:= "2"
		CV0->CV0_DTIBLQ		:= CTOD("")
		CV0->CV0_DTFBLQ		:= CTOD("")
		CV0->CV0_DTIEXI		:= CTOD("01/01/"+STR(Year(dDataBase),4))
		CV0->CV0_DTFEXI		:= CTOD("")
		CV0->CV0_CFGLIV		:= ""
		CV0->CV0_LUCPER		:= ""
		CV0->CV0_PONTE			:= ""
	MsUnlock()		
ENDIF

RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GetAcols ºAutor  ³TOTVS PROTHEUS      º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega o aCols com os dados do CV0                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION GetAcols(cAlias, nReg, cPlanoCV0, aHeaderCV0, aColsCV0, aRecnosCV0)

DEFAULT aColsCV0 := {}

DbSelectArea(cAlias)
DbGoTo(nReg)
cPlanoCV0 := CV0->CV0_PLANO
Do While !(cAlias)->(Eof()) .and. xFilial(cAlias)+cPlanoCV0 == CV0->CV0_FILIAL+CV0->CV0_PLANO
	If !Empty(CV0->CV0_CODIGO)
		aAdd(aRecnosCV0, (cAlias)->(Recno()) )
		aAdd(aColsCV0,Array(Len(aHeaderCV0) + 1))
		AEval(aHeaderCV0, {|x,y| aColsCV0[Len(aColsCV0)][y] := If(Alltrim(x[2])$"CV0_ALI_WT|CV0_REC_WT".OR. x[10]=="V",NIL, CV0->(FieldGet(FieldPos(x[2]))) ) })
		aColsCV0[Len(aColsCV0),Len(aHeaderCV0) + 1] := .F.
	EndIf
	(cAlias)->(DbSkip())
EndDo

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010VP  ºAutor  ³TOTVS PROTHEUS      º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se o plano ja esta cadastrado                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CSE010VP()

Local lRet		:= .T.
Local aSaveArea	:= GetArea()
Local aSaveCV0	:= CV0->(GetArea())

If INCLUI
	DbSelectArea("CV0")
	DbSetOrder(1)
	If DbSeek(xFilial("CV0")+cPlanoCV0)
		lRet := .F. 
		HELP(" ",1,"CSE010VP.01",,"Plano já cadastrado",4,0)
	EndIf
EndIf

RestArea(aSaveCV0)
RestArea(aSaveArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010LK  ºAutor  ³ TOTVS PROTHEUS     º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao da linha da GetDados                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CSE010LK()

Local lRet			:= .T.
Local nX			:= 0
Local nLin			:= oGDItens:nAt //Linha posicionada no aCols
Local nPosCodEnt	:= aScan(oGDItens:aHeader,{|x|AllTrim(Upper(x[2]))=="CV0_CODIGO"}) //Posicao do codigo da entidade
Local nPosCodESp	:= aScan(oGDItens:aHeader,{|x|AllTrim(Upper(x[2]))=="CV0_ENTSUP"}) //Posicao do codigo da entidade superior
Local nPosClasse	:= aScan(oGDItens:aHeader,{|x|AllTrim(Upper(x[2]))=="CV0_CLASSE"}) //Posicao da classe da entidade 1-Sintetica 2-Analitica
Local aColsCV0		:= aClone(oGDItens:aCols)

Do Case

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se a linha estiver deletada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case aColsCV0[nLin][Len(aColsCV0[nLin])]
		Return(lRet)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se o cod. da entidade for igual ao cod. da entidade superior³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case AllTrim(aColsCV0[nLin][nPosCodEnt]) == AllTrim(aColsCV0[nLin][nPosCodESp])
		lRet := .F.
		HELP(" ",1,"CSE010LK.01",,"Codigo da entidade superior deverá ser diferente do codigo do entidade posicionada.",4,0)

EndCase

If lRet
	For nX := 1 To Len(aColsCV0)

		Do Case

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Para nao avaliar a linha posicionada e linhas deletadas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Case nX == nLin .Or. aColsCV0[nX][Len(aColsCV0[nX])]
				Loop

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se o codigo da entidade esta duplicado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Case AllTrim(aColsCV0[nX][nPosCodEnt]) == AllTrim(aColsCV0[nLin][nPosCodEnt])
				lRet := .F.
				HELP(" ",1,"CSE010LK.02",,"Código da entidade já cadastrado",4,0)
				Exit

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se ha entidade superior e valida a estrutura de analita/sintetica³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Case !Empty(aColsCV0[nLin][nPosCodESp]) .And. AllTrim(aColsCV0[nX][nPosCodEnt]) == AllTrim(aColsCV0[nLin][nPosCodESp]) .And.;
					aColsCV0[nX][nPosClasse] == "2"	//Se a entidade superior for analitica
					lRet := .F.						//nao permite que haja entidade inferior
					HELP(" ",1,"CSE010LK.03",,"Entidade superior inválida, confira a classe da conta superior.",4,0)
					Exit
					
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se ha entidade inferior e valida a estrutura de analitica/sintetica³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Case aColsCV0[nLin][nPosClasse] == "2" .And. AllTrim(aColsCV0[nLin][nPosCodEnt]) == AllTrim(aColsCV0[nX][nPosCodESp])
					lRet := .F.						//nao permite que altera a classe para analitica se houver entidade inferior
					HELP(" ",1,"CSE010LK.04",,"Classe inválida, há entidade(s) inferior(es) relacionada(s).",4,0)
					Exit

		EndCase

	Next
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010Dk  ºAutor  ³ TOTVS PROTHEUS     º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a exclusao de linha da GetDados                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION CSE010DK()

Local lRet			:= .T.
Local nX				:= 0
Local nLin			:= oGDItens:nAt //Linha posicionada no aCols
Local nPosCodEnt	:= aScan(oGDItens:aHeader,{|x|AllTrim(Upper(x[2]))=="CV0_CODIGO"}) //Posicao do codigo da entidade
Local nPosCodESp	:= aScan(oGDItens:aHeader,{|x|AllTrim(Upper(x[2]))=="CV0_ENTSUP"}) //Posicao do codigo da entidade superior
Local aColsCV0		:= aClone(oGDItens:aCols)

For nX := 1 To Len(aColsCV0)

	Do Case

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Para nao avaliar a linha posicionada e linhas deletadas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case nX == nLin .Or. aColsCV0[nX][Len(aColsCV0[nX])]
			Loop

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se a entidade deletada eh superior de outra entidade³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case AllTrim(aColsCV0[nX][nPosCodESp]) == AllTrim(aColsCV0[nLin][nPosCodEnt])
			lRet := .F.
			HELP(" ",1,"CSE010DK.01",,"A entidade selecionada possui relacionamento(s) com outra(s) entidade(s)",4,0)
			Exit

	EndCase

Next

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010TK  ºAutor  ³ TOTVS PROTHEUS     º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o preenchimento do cabecalho e dos itens            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION CSE010TK()

Local lRet := .T.

Do Case

	Case Empty(cPlanoCV0)
		HELP(" ",1,"CSE010DTK.01",,"Preencha o campo Plano",4,0)
		lRet := .F.

	Case Empty(cDescCV0)
		HELP(" ",1,"CSE010DTK.02",,"Preencha o campo Descrição",4,0)
		lRet := .F.

	Case !oGDItens:TudoOk()
		lRet := .F.
		
EndCase

Return lRet   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010Tab ºAutor  ³ TOTVS PROTHEUS     º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida a manutenção da tabela                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSE010Tab(cPlano)

Local lRet     := .T.
Local aArea    := GetArea()
Local aAreaCT0 := CT0->(GetArea())

CT0->(dbSetOrder(1)) //CT0_FILIAL+CT0_ID

If CT0->(dbSeek(xFilial("CT0") + cPlano ))
	If Alltrim(CT0->CT0_ALIAS) != "CV0"
		Help("  ",1,"CSE010TAB",,"Entidade relacionada a tabela " + CT0->CT0_ALIAS + " . " +"Por favor, utilize o cadastro padrão desta entidade"  ,1,0)
		lRet := .F.
	EndIf
EndIf

RestArea(aAreaCT0)
RestArea(aArea)
Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE010SN ºAutor  ³ TOTVS Protheus     º Data ³  06/01/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FUNCAO QUE DIRECIONA AS CHAMADAS DOS SINCRONISMOS          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONTABILIDADE GERENCIAL - ORCAMENTO CONTABIL               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION CSE010SN(nOpcCad)

LOCAL aArea := GetArea()

DO CASE	
	CASE nOpcCad == 1

		DbSelectArea("SA1")
		DbSetOrder(1)
		U_CSEP030(6)
		
	CASE nOpcCad == 2

		DbSelectArea("SA2")
		DbSetOrder(1)
		U_CSEP020(6)
		
	CASE nOpcCad == 3

		DbSelectArea("SB1")
		DbSetOrder(1)
		U_CSEP010(6)
		
ENDCASE

RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE010IP ºAutor  ³ TOTVS PROTHEUS     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao de entidade em formato .CSV                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION CSE010IP(cAlias,nOpc,nRecno)

Local aArea		:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)          			    ³
//³ MV_PAR01   - Arquivo a importar:           						     	       ³
//³ MV_PAR02   - Entidade:                         					     	    ³
//³ MV_PAR03   - Plano contabil:                   					     	    ³
//³ MV_PAR04   - Modo de importacao: (Novo cadastro / Atualizar cadastro)   ³
//³ MV_PAR05   - Exibe cadastro para edicao: (Sim / Nao)   						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If CSE010PBI() .AND.;//Parambox da rotina de exportacao do orcamento
	ApMsgNoYes(	"Confirma a importacao do cadastro da entidade selecionada ?","PLANOS DE ENTIDADES CONTABEIS: Importacao")
				MsgRun("Importando cadastro de plano de entidades contabeis...","PLANOS DE ENTIDADES CONTABEIS: Importacao",{|| CSE010IMP(cAlias,nOpc,nRecno)})
ENDIF

RestArea(aArea)
RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE010IMPºAutor  ³ TOTVS PROTHEUS     º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importacao da entidade em formato .CSV                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION CSE010IMP(cAlias,nOpc,nRecno)

Local aArea			:= GetArea()
Local cLine			:=	""
Local aField 		:= {{}}
Local aData   		:= {{}}
Local aTempRead	:= {}
Local aTempData	:= {}
Local nLenFields	:= 0
Local nLenData		:= 0
Local lProcess		:= .T.
Local nModo			:= 0      
Local nX,nY,nZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Identificadores das posicoes dos alias nos arrays de trabalho              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAlias		:= {"CV0"}
Local nPosAlias		:= 0
Local cAliasCab		:= "CV0"
Local aAliasIt		:= {"CV0"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Indica se irah gerar o cadastro de orcamento bloqueado, e qual o campo     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lMsBlQl		:= .T.
Local cFieldBlq	:= "CV0_BLOQUE"//"CV0_MSBLQL"
Local nPosField	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva as variaveis de ambiente                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SaveInter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do processamento                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validacoes preliminares                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF (nHandle := FT_FUse(AllTrim(MV_PAR01)))== -1
	HELP(" ",1,"CSE010IMP.01",,"Nao foi possivel abrir o arquivo selecionado para importacao.",4,0)//"Nao foi possivel abrir o arquivo selecionado para importacao."
	lProcess := .F.
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³1a Etapa: Leitura do arquivo em conversao nos arrays de trabalho ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	WHILE !FT_FEOF()
	
		cLine		:= FT_FREADLN()
		aTempRead 	:= StrtoKarr(cLine,";")
	
		IF 		aTempRead[1] == "0" // Linhas de estrutrua de campos
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(aTempRead[2]) == cAlias})) > 0

				// Elimina as duas primeiras posicoes: Identificador e Alias
				FOR nX := 3 TO LEN(aTempRead)
					AADD(aField[nPosAlias],{aTempRead[nX],X3TIPO(aTempRead[nX])})
				NEXT nX
				
			ELSE
				HELP(" ",1,"CSE010IMP.02",,	"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
											"Alias invalido: "+ALLTRIM(aTempRead[2]),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Alias invalido: "
				lProcess := .F.
				EXIT
			ENDIF
	
		ELSEIF	aTempRead[1] $ "1/2"	// Linha de dados: CV0(1)
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(aTempRead[2]) == cAlias})) > 0

				aTempData := {}
				
				// Elimina as duas primeiras posicoes: Identificador e Alias
				FOR nX := 3 TO LEN(aTempRead)
					AADD(aTempData,aTempRead[nX])			
				NEXT nX		

				AADD(aData[nPosAlias],aClone(aTempData))
				
			ELSE
				HELP(" ",1,"CSE010IMP.03",,	"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
											"Alias invalido: "+ALLTRIM(aTempRead[2]),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Alias invalido: "
				lProcess := .F.
				EXIT
			ENDIF

		ELSE
			HELP(" ",1,"CSE010IMP.04",,	"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
										"Identificador de linha invalido: "+aTempRead[1],4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Identificador de linha invalido: "
			lProcess := .F.
			EXIT
		ENDIF
	
		FT_FSKIP()
		
	END

	FT_FUSE()
	FCLOSE(nHandle)

ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³2a Etapa: Validacao da estrutura de campos e conteudos dos arrays³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.1: Valida se existe no alias de cabecalho o campo para bloqueio³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF lMsBlQl

		nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(cAliasCab)})        

            IF (aAlias[nPosAlias])->(FieldPos(ALLTRIM(cFieldBlq))) == 0

			HELP(" ",1,"CSE010IMP.05",,	"Nao existe no sistema para o arquivo de cabecalho: "+aAlias[nPosAlias]+" "+CRLF+;
										"o campo de bloqueio necessario para o cadastro : "+ALLTRIM(cFieldBlq),4,0)
			lProcess := .F.		
            
            ENDIF

	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.2: Validacao da quantidade de estruturas de campos x Alias     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF LEN(aField) != LEN(aAlias)

		HELP(" ",1,"CSE010IMP.06",,	"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
									"Quantidade de estruturas suportadas/necessarias: "+STRZERO(LEN(aAlias))+CRLF+;
									"Quantidade de estruturas informadas no arquivo : "+STRZERO(LEN(aField))+CRLF,4,0)
		lProcess := .F.		
	
	ELSE

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.3: Validacao do dicionario de dados x estrutura de campos      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FOR nX := 1 TO LEN(aAlias) // 1-> CV0

			FOR nY := 1 TO LEN(aField[nX])

				IF (aAlias[nX])->(FieldPos(aField[nX][nY][1])) == 0

					HELP(" ",1,"CSE010IMP.07",,	"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
												"Campo invalido: "+aField[nX][nY][1],4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Identificador de linha invalido: "
					lProcess := .F.
					EXIT
				
				ENDIF
			
			NEXT nY
		
		NEXT nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.4: Validacao da quantidade de itens das linhas de dados x campos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FOR nX := 1 TO LEN(aAlias)
			
			nLenFields := Len(aField[nX])
			
			FOR nY := 1 TO LEN(aData[nX])

				nLenData := Len(aData[nX][nY])
							
				IF nLenData != nLenFields

					HELP(" ",1,"CSE010IMP.08",,	"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
												"Quantidade de campos invalida: "+CRLF+;
												"Alias: "+aAlias[nX]	+" / Campos: "+STRZERO(nLenFields)+CRLF+;
												"Linha: "+STRZERO(nY)	+" / Campos: "+STRZERO(nLenData)+" .",4,0)
					lProcess := .F.
					EXIT
				
				ENDIF	
			
			NEXT nY
		
		NEXT nX
		
	ENDIF
	
ENDIF
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³3a Etapa: Efetua a gravacao da tabela CV0 conforme o modo        ³
//³definido para a importacao: Novo cadastro ou Atualizar cadastro  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³3.1: Validacao dos parametros de importacao em funcao do modo    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("CV0")
	DbSetOrder(1) //CV0_FILIAL+CV0_PLANO+CV0_CODIGO
	lFind := CV0->(DbSeek(xFilial("CV0")+MV_PAR03))
	DO CASE
		CASE lFind .AND. MV_PAR04 == 1 //Encontrou orcamento e o modo definido foi "Novo Cadastro"

			IF Aviso("Importacao do cadastro de plano de entidades contabeis",;
					 "Existe um plano cadastrado com as informacoes de importacao selecionadas."+CRLF+;
					 "Deseja atualizar o cadastro ou finalizar o processo?",;
					 {"Atualizar","Finalizar"}) == 1
				nModo	 := 2 // Atualizar cadastro jah existente
			ELSE
				lProcess := .F.				
			ENDIF
		
		CASE lFind .AND. MV_PAR04 == 2 //Encontrou cadastro e o modo definido foi "Atualizar"
	
			nModo	 := 2 // Revisao para um orcamento jah existente
		
		CASE !lFind .AND. MV_PAR04 == 1// Nao encontrou orcamento e o modo definido foi "Novo cadastro"

			nModo	 := 1 		// Novo orcamento

		CASE !lFind .AND. MV_PAR04 == 2// Nao encontrou cadastro e o modo definido foi "Atualizar"

			IF Aviso("Importacao do cadastro de plano de entidades contabeis",;
					 "Nao existe um plano cadastrado com as informacoes de importacao selecionadas."+CRLF+;
					 "Deseja incluir um novo plano ou finalizar o processo?",;
					 {"Incluir","Finalizar"}) == 1
				nModo	 := 1 		// Novo orcamento

			ELSE
				lProcess := .F.				
			ENDIF

	END CASE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³3.1.1: Se for modo de atualizacao, exclui os dados atuais do plano ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF lProcess .AND. nModo == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3.1.1.1: Valida para verificar se as entidades possuem movimentacoes ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CV0->(DbSeek(xFilial("CV0")+MV_PAR03))
		WHILE CV0->(!Eof()) .AND. CV0->CV0_PLANO == MV_PAR03
		
			IF !CSEValDel("CV0"/*cArqDel*/, MV_PAR01 /*cEntidade*/, CV0->CV0_CODIGO/*cCodEnt*/, '01'/*cMoeda*/,'1' /*cTpSaldo*/)

				HELP(" ",1,"CSE010IMP.09",,	"Nao foi possivel excluir uma das entidades do cadastro de plano atual"+CRLF+;
											"pois a mesma possui movimentacoes."+CRLF+;
											"Entidade: "+MV_PAR02+" / Plano: "+MV_PAR03+" / Entidade: "+ALLTRIM(CV0->CV0_CODIGO)+CRLF+;
											"O processo sera finalizado.",4,0)

				lProcess := .F.
				Exit
			ENDIF

			CV0->(DbSkip())		
		END      

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3.1.1.2: Continua somente se todas as entidades puderem ser excluidas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF lProcess 
			CV0->(DbSeek(xFilial("CV0")+MV_PAR03))
			WHILE CV0->(!Eof()) .AND. CV0->CV0_PLANO == MV_PAR03
				RecLock("CV0",.F.,.T.)
				DbDelete()
				MsUnLock()
				CV0->(DbSkip())		
			END      
		ENDIF

	ENDIF
	
	IF lProcess
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ INICIO DA TRANSACAO                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BEGIN TRANSACTION

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³3.2: Gravacao dos itens do cadastro do plano de entidades contabeis³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		FOR nX := 1 TO Len(aAliasIt)

			DbSelectArea(aAliasIt[nX])
                                        
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0

				FOR nY := 1 TO Len(aData[nPosAlias])

					RecLock(aAliasIt[nX],.T.)
	
					FOR nZ := 1 TO Len(aField[nPosAlias])
	
						IF (aAliasIt[nX])->(FieldPos(aField[nPosAlias][nZ][1])>0)
						
							IF 		ALLTRIM(aField[nPosAlias][nZ][1]) == "CV0_FILIAL"
						
								FieldPut(FieldPos(aField[nPosAlias][nZ][1]), xFilial(aAliasIt[nX]) )	

							ELSEIF	ALLTRIM(aField[nPosAlias][nZ][1]) == "CV0_PLANO"
							
								FieldPut(FieldPos(aField[nPosAlias][nZ][1]), MV_PAR03 ) 	// PLANO DA ENTIDADE

							ELSE
														
								DO CASE
									CASE aField[nPosAlias][nZ][2] == "C"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])) )
									CASE aField[nPosAlias][nZ][2] == "L"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), IIf( ALLTRIM(aData[nPosAlias][nY][nZ]) == "T", .T., .F. ) )
									CASE aField[nPosAlias][nZ][2] == "D"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), STOD( ALLTRIM(aData[nPosAlias][nY][nZ]) ) )
									CASE aField[nPosAlias][nZ][2] == "N"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), Val( ALLTRIM(aData[nPosAlias][nY][nZ]) ) )
									CASE aField[nPosAlias][nZ][2] == "M"
										FieldPut(FieldPos(aField[nPosAlias][nZ][1]), NoAcento(ALLTRIM(aData[nPosAlias][nY][nZ])) )								
								ENDCASE
						    
						    ENDIF
						    
						ENDIF
				
					NEXT nZ
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³3.2.1: Gravacao do campo de bloqueio dos itens do cadastro do plano³
					//³       Tratamento para garantir o bloqueio mesmo se o campo nao	 ³
					//³       existir no arquivo importado.                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					FieldPut(FieldPos(ALLTRIM(cFieldBlq)), "1" ) // 1-SIM; 2-NAO
					MsUnlock()
				
				NEXT nY

			ELSE
				HELP(" ",1,"CSE010IMP.10",,	"Erro na gravacao dos dados nos arquivos de itens."+CRLF+;
											"Alias de itens: "+aAliasIt[nX],4,0)
				lProcess := .F.
				DisarmTransaction()
				EXIT
			ENDIF				
			
		NEXT nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 3.3. EFETUA A GRAVACAO DA LINHA BASE DO PLANO CASO NAO EXISTA     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CSE010Plano(CT0->CT0_ENTIDA,CT0->CT0_DESC)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ FIM DA TRANSACAO                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		END TRANSACTION
	ENDIF
ENDIF

IF lProcess
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³4.0: Se o cadastro  foi importado com sucesso exibe o mesmo para   ³
	//³     edicao, conforme parametro MV_PAR05, senao encerra.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF MV_PAR05 == 1 // Exibe orcamento para edicao
		CV0->(DbSeek(xFilial("CV0")+MV_PAR03))
		U_CSE010DLG("CV0",CV0->(RECNO()),4)
	ELSE
		Aviso("Processameto concluido",	"Importacao do orcamento efetuada com sucesso."+CRLF+;
										"Favor proceder com a conferencia e liberacao do orcamento.",{"Concluir"})
	ENDIF
									
ELSE
	Aviso("Processamento com criticas","Nao foi possivel efetuar a importacao do orcamento.",{"Concluir"})
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura as variaveis de ambiente                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestInter()
RestArea(aArea)
Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE010EP ºAutor  ³ TOTVS PROTHEUS     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exportacao da entidade em formato .CSV                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION CSE010EP(cAlias,nOpc,nRecno)

Local aArea		:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)          			    ³
//³ MV_PAR01   - Entidade:                         					     	    ³
//³ MV_PAR02   - Plano Contabil:               						     	       ³
//³ MV_PAR03   - Arquivo destino:              						     	       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If CSE010PBE() .AND.;//Parambox da rotina de exportacao do orcamento
	ApMsgNoYes(	"Confirma a exportacao do cadastro da entidade selecionada ?","PLANOS DE ENTIDADES CONTABEIS: Exportacao")
				MsgRun("Exportando cadastro de plano de entidades contabeis...","PLANOS DE ENTIDADES CONTABEIS: Exportacao",{|| CSE010EXP(cAlias,nOpc,nRecno)})
ENDIF

RestArea(aArea)
RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE010EXPºAutor  ³ TOTVS PROTHEUS     º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exportacao da entidade em formato .CSV                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSE010EXP(cAlias,nOpc,nRecno)

Local aArea		:= GetArea()
Local cFile		:= ""
Local cLine		:= ""
Local aTxt		:= {}
Local aStruCV0	:= {}
Local nX,nY

Local lProcess	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva as variaveis de ambiente                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SaveInter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia o processamento da exportacao                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Empty( MV_PAR03 )
	HELP(" ",1,"CSE010EXP.01",,"Nao foi informado o arquivo destino para a exportacao.",4,0)
	lProcess := .F.

ELSE
	
	IF At('.',MV_PAR03) == 0
		cFile	:= ALLTRIM(MV_PAR03)+'.CSV'
	ELSE
		cFile	:= ALLTRIM(MV_PAR03)
	ENDIF	

	IF File( cFile )
		FErase( cFile )
	Endif

	nHandle := FCreate( cFile )

   	If nHandle <= 0
		For nX := 1 To 5
			MsAguarde( {|| Sleep( 2000 ) },  "Exportacao do cadastro de plano de entidades contabeis" , "Criando arquivo destino da exportacao")

			nHandle := FCreate( cFile )
			
			IF nHandle > 0
				Exit
			Endif
		Next

		If nHandle <= 0
			HELP(" ",1,"CSE010EXP.02",,"Nao foi possivel criar o arquivo destino para a exportacao.",4,0)
			lProcess := .F.
		Endif
	EndIf
    
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Garante o posicionamento do CV0 com base  ³
//³nos parametros da PARAMBOX()              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("CV0")
DbSetOrder(1) //CV0_FILIAL+CV0_PLANO+CV0_CODIGO
IF !CV0->(DbSeek(xFilial("CV0")+MV_PAR01))

	HELP(" ",1,"CSE010EXP.03",,"Nao foi possivel localizar o plano de cadastro de entidades contabeis selecionado.",4,0)
	lProcess := .F.

ENDIF

IF lProcess

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exportacao da tabela CV0 - identificador 0³
	//³Plano de entidades contabeis - campos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aEstruCV0 :=	CV0->(DbStruct())

	cLine :="0;CV0;"
	For nX:=1 To Len(aEstruCV0)
		cLine	+=	aEstruCV0[nX,1]+";"
	Next	
	cLine := Substr(cLine,1,Len(cLine)-1) + CRLF
	FWrite(nHandle,cLine,Len(cLine))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exportacao da tabela CV0 - identificador 1³
	//³Plano de entidades contabeis - dados  	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTxt := {}
	DbSelectArea("CV0")
	DbSetOrder(1) //CV0_FILIAL+CV0_PLANO+CV0_CODIGO
	DbSeek(xFilial("CV0")+MV_PAR01)
	While  CV0->(!Eof()) .AND.;
		    CV0->(CV0_FILIAL+CV0_PLANO) == xFilial("CV0")+MV_PAR01

		AAdd(aTxt,{})

		For nX:=1 To Len(aEstruCV0)
			Do Case
			Case aEstruCV0[nX,2] == "C"
				AADd(aTxt[Len(aTxt)],IIF( EMPTY(FieldGet(FieldPos(aEstruCV0[nX,1]))), '""', FieldGet(FieldPos(aEstruCV0[nX,1])) ))
			Case aEstruCV0[nX,2] == "L"
				AADd(aTxt[Len(aTxt)],If(FieldGet(FieldPos(aEstruCV0[nX,1])),"T","F"))
			Case aEstruCV0[nX,2] == "D"
				AADd(aTxt[Len(aTxt)],IIF( EMPTY(Dtos(FieldGet(FieldPos(aEstruCV0[nX,1])))), '""', Dtos(FieldGet(FieldPos(aEstruCV0[nX,1]))) ))
			Case aEstruCV0[nX,2] == "N"
				AADd(aTxt[Len(aTxt)],Str(FieldGet(FieldPos(aEstruCV0[nX,1]))))
			EndCase					
		Next
		CV0->(DbSkip())
	End          

	For nX:= 1 To Len(aTxt)
		cLine	:=	"1;CV0;" 
		For nY:=1 To Len(aTxt[nX])
			cLine  +=   aTxt[nX,nY]+";"
		Next                      
		cLine := Substr(cLine,1,Len(cLine)-1) + CRLF
		FWrite(nHandle,cLine,Len(cLine))                          	
	Next	

	FClose(nHandle)

ENDIF

IF lProcess
	Aviso("Processameto concluido","Exportacao do plano de entidades contabeis efetuado com sucesso.",{"Concluir"})
ELSE
	Aviso("Processamento com criticas","Nao foi possivel efetuar a exportacao do plano de entidades contabeis.",{"Concluir"})
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura as variaveis de ambiente                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestInter()
RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE010VN ºAutor  ³ TOTVS Protheus     º Data ³  06/01/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FUNCAO QUE DIRECIONA AS CHAMADAS DAS VINCULACOES           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONTABILIDADE GERENCIAL - ORCAMENTO CONTABIL               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION CSE010VN(nOpcCad)
LOCAL aArea := GetArea()

DO CASE	

	CASE nOpcCad == 1

		DbSelectArea("CT1")
		DbSetOrder(1)
		CSE010V1PB()
		
	CASE nOpcCad == 2

		DbSelectArea("SB1")
		DbSetOrder(1)

		DbSelectArea("CT1")
		DbSetOrder(1)

		DbSelectArea("CV0")
		DbSetOrder(1)
		CSE010V2PB()

	CASE nOpcCad == 3

		DbSelectArea("SZ2")
		DbSetOrder(1)

		DbSelectArea("CV0")
		DbSetOrder(1)
		CSE010V3PB()

ENDCASE

RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010V1PBºAutor  ³ TOTVS Protheus     º Data ³  06/01/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VINCULA AS CONTAS CONTABEIS AOS TIPOS DE ATIVIDADES (.CSV) º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONTABILIDADE GERENCIAL - ORCAMENTO CONTABIL               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSE010V1PB()

Local aArea		:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)          			³
//³ MV_PAR01   - Arquivo a importar:           						     	³
//³ MV_PAR02   - Entidade contabil:                					     	³
//³ MV_PAR03   - Entidade orcamentaria:            					     	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CSE010PVI(1) .AND.;//Parambox da rotina de exportacao do orcamento
	ApMsgNoYes(	"Confirma a vinculacao do plano de contas aos tipos de atividades conforme regra do arquivo selecionado?","ENTIDADES CONTABEIS x ENTIDADES ORCAMENTARIAS: Vincular")
				MsgRun("Vinculando cadastro de plano de contas ao cadastro de tipos de atividades...","ENTIDADES CONTABEIS x ENTIDADES ORCAMENTARIAS: Vincular",{|| CSE010V1PR()})
ENDIF

RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010V1PRºAutor  ³ TOTVS PROTHEUS     º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Vincula o cadastro de plano de contas com os tp. ativid.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION CSE010V1PR()

Local aArea			:= GetArea()
Local cLine			:=	""
Local aField 		:= {{}}
Local aData   		:= {{}}
Local aTempRead		:= {}
Local aTempData		:= {}
Local nLenFields	:= 0
Local nLenData		:= 0
Local lProcess		:= .T.
Local nModo			:= 0      
Local nX,nY,nZ
Local nPosField		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Identificadores das posicoes dos alias nos arrays de trabalho              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAlias		:= {"CT1"}
Local nPosAlias		:= 0
Local cAliasCab		:= "CT1"
Local aAliasIt		:= {"CT1"}
Local aFieldObr		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis para controle das posicoes dos campos obrigatorios da estrutura  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosCT1CTA	:= 0
Local nPosE06CTA	:= 0
Local nPosE06DSC	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona os campos obrigatorios da estrutura do arquivo para validacao     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aFieldObr,"CT1_CONTA")
AADD(aFieldObr,"CT1_ENT06")
AADD(aFieldObr,"CT1_E06DSC")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva as variaveis de ambiente                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SaveInter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do processamento                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validacoes preliminares                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF (nHandle := FT_FUse(AllTrim(MV_PAR01)))== -1
	HELP(" ",1,"CSE010V1PR.01",,"Nao foi possivel abrir o arquivo selecionado para processamento.",4,0)//"Nao foi possivel abrir o arquivo selecionado para importacao."
	lProcess := .F.
ENDIF

IF MV_PAR02 != 1 // PLANO DE CONTAS
	HELP(" ",1,"CSE010V1PR.02",,"Opcao selecionada invalida. Somente eh permitido vincular ao Plano de Contas",4,0)//"Opcao selecionada invalida. Somente eh permitido vincular ao Plano de Contas"
	lProcess := .F.
ENDIF

IF MV_PAR03 != 1 // TIPO DE ATIVIDADE
	HELP(" ",1,"CSE010V1PR.03",,"Opcao selecionada invalida. Somente eh permitido vincular com Tipo de Atividade",4,0)//"Opcao selecionada invalida. Somente eh permitido vincular com Tipo de Atividade"
	lProcess := .F.
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³1a Etapa: Leitura do arquivo em conversao nos arrays de trabalho ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	WHILE !FT_FEOF()
	
		cLine		:= FT_FREADLN()
		aTempRead 	:= StrtoKarr(cLine,";")
	
		IF 		aTempRead[1] == "0" // Linhas de estrutrua de campos
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(aTempRead[2]) == cAlias})) > 0

				// Elimina as duas primeiras posicoes: Identificador e Alias
				FOR nX := 3 TO LEN(aTempRead)
					AADD(aField[nPosAlias],{aTempRead[nX],X3TIPO(aTempRead[nX])})
				NEXT nX
				
			ELSE
				HELP(" ",1,"CSE010V1PR.04",,"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
											"Alias invalido: "+ALLTRIM(aTempRead[2]),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Alias invalido: "
				lProcess := .F.
				EXIT
			ENDIF
	
		ELSEIF	aTempRead[1] $ "1/2"	// Linha de dados: CT1(1)
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(aTempRead[2]) == cAlias})) > 0

				aTempData := {}
				
				// Elimina as duas primeiras posicoes: Identificador e Alias
				FOR nX := 3 TO LEN(aTempRead)
					AADD(aTempData,aTempRead[nX])			
				NEXT nX		

				AADD(aData[nPosAlias],aClone(aTempData))
				
			ELSE
				HELP(" ",1,"CSE010V1PR.05",,"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
											"Alias invalido: "+ALLTRIM(aTempRead[2]),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Alias invalido: "
				lProcess := .F.
				EXIT
			ENDIF

		ELSE
			HELP(" ",1,"CSE010V1PR.06",,"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
										"Identificador de linha invalido: "+aTempRead[1],4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Identificador de linha invalido: "
			lProcess := .F.
			EXIT
		ENDIF
	
		FT_FSKIP()
		
	END

	FT_FUSE()
	FCLOSE(nHandle)

ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³2a Etapa: Validacao da estrutura de campos e conteudos dos arrays³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.1: Validacao da quantidade de estruturas de campos x Alias     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF LEN(aField) != LEN(aAlias)

		HELP(" ",1,"CSE010V1PR.09",,"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
									"Quantidade de estruturas suportadas/necessarias: "+STRZERO(LEN(aAlias))+CRLF+;
									"Quantidade de estruturas informadas no arquivo : "+STRZERO(LEN(aField))+CRLF,4,0)
		lProcess := .F.		
	
	ELSE

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.2: Validacao do dicionario de dados x estrutura de campos      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FOR nX := 1 TO LEN(aAlias) // 1-> CT1

			FOR nY := 1 TO LEN(aField[nX])

				IF (aAlias[nX])->(FieldPos(aField[nX][nY][1])) == 0

					HELP(" ",1,"CSE010V1PR.10",,"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
												"Campo invalido: "+aField[nX][nY][1],4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Identificador de linha invalido: "
					lProcess := .F.
					EXIT
				
				ENDIF

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.2.1: Salva a posicao dos campos obrigatorios para validacao posterior ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				DO CASE
					CASE aField[nX][nY][1] == "CT1_CONTA"
						nPosCT1CTA := nY

					CASE aField[nX][nY][1] == "CT1_ENT06"
						nPosE06CTA := nY

					CASE aField[nX][nY][1] == "CT1_E06DSC"
						nPosE06DSC := nY											
				ENDCASE

			NEXT nY
		
		NEXT nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.3: Validacao dos campos obrigatorios na estrutura do arquivo     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF 		nPosCT1CTA == 0
			HELP(" ",1,"CSE010V1PR.11",,"Campo obrigatorio nao presente na estrutura do arquivo."+CRLF+;
										"Campo: CT1_CONTA",4,0)
			lProcess := .F.

		ELSEIF 	nPosE06CTA == 0
			HELP(" ",1,"CSE010V1PR.11",,"Campo obrigatorio nao presente na estrutura do arquivo."+CRLF+;
										"Campo: CT1_ENT06",4,0)
			lProcess := .F.

		ELSEIF 	nPosE06DSC == 0
			HELP(" ",1,"CSE010V1PR.11",,"Campo obrigatorio nao presente na estrutura do arquivo."+CRLF+;
										"Campo: CT1_E06DSC",4,0)
			lProcess := .F.
		
		ENDIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.4: Validacao da quantidade de itens das linhas de dados x campos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FOR nX := 1 TO LEN(aAlias)
			
			nLenFields := Len(aField[nX])
			
			FOR nY := 1 TO LEN(aData[nX])

				nLenData := Len(aData[nX][nY])
							
				IF nLenData != nLenFields

					HELP(" ",1,"CSE010V1PR.12",,"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
												"Quantidade de campos invalida: "+CRLF+;
												"Alias: "+aAlias[nX]	+" / Campos: "+STRZERO(nLenFields)+CRLF+;
												"Linha: "+STRZERO(nY)	+" / Campos: "+STRZERO(nLenData)+" .",4,0)
					lProcess := .F.
					EXIT
				
				ENDIF	
			
			NEXT nY
		
		NEXT nX
		
	ENDIF
	
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³3a Etapa: Efetua a gravacao da tabela CT1 atualizando o          ³
//³          vinculo com o cadastro de tipos de atividades          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ INICIO DA TRANSACAO                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BEGIN TRANSACTION

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³3.1: Gravacao dos itens do cadastro do plano de entidades contabeis³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	FOR nX := 1 TO Len(aAliasIt)

		DbSelectArea(aAliasIt[nX])
		DbSetOrder(1)
                                        
		IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0

			FOR nY := 1 TO Len(aData[nPosAlias])

				IF (aAliasIt[nX])->(DbSeek(xFilial(aAliasIt[nX])+ aData[nPosAlias][nY][nPosCT1CTA]))
				
					RecLock(aAliasIt[nX],.F.)
					
						FieldPut(FieldPos("CT1_ENT06") , aData[nPosAlias][nY][nPosE06CTA])
						FieldPut(FieldPos("CT1_E06DSC"), aData[nPosAlias][nY][nPosE06DSC])
						
					MsUnlock()

			    ENDIF

			NEXT nY

		ELSE
			HELP(" ",1,"CSE010V1PR.13",,"Erro na gravacao dos dados nos arquivos de itens."+CRLF+;
										"Alias de itens: "+aAliasIt[nX],4,0)
			lProcess := .F.
			DisarmTransaction()
			EXIT
		ENDIF				
		
	NEXT nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ FIM DA TRANSACAO                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	END TRANSACTION

ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura as variaveis de ambiente                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestInter()
RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010V2PBºAutor  ³ TOTVS Protheus     º Data ³  06/01/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VINCULA OS PRODUTOS OS PRODUTOS COMERCIALIZADOS (.CSV)     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONTABILIDADE GERENCIAL - ORCAMENTO CONTABIL               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSE010V2PB()

Local aArea		:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)          			³
//³ MV_PAR01   - Arquivo a importar:           						     	³
//³ MV_PAR02   - Entidade contabil:                					     	³
//³ MV_PAR03   - Entidade orcamentaria:            					     	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CSE010PVI(2) .AND.;//Parambox da rotina de exportacao do orcamento
	ApMsgNoYes(	"Confirma a atualizacao do vinculo entre o cadastro de produtos e o entidade de produtos comercializados conforme regra do arquivo selecionado?","ENTIDADES SISTEMICAS x ENTIDADES ORCAMENTARIAS: Vincular")
				MsgRun("Vinculando cadastro de produtos ao cadastro de produtos comercializados...","ENTIDADES SISTEMICAS x ENTIDADES ORCAMENTARIAS: Vincular",{|| CSE010V2PR()})
ENDIF

RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010V2PRºAutor  ³ TOTVS PROTHEUS     º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Vincula o cadastro de produtos ao cadastro de prod.comerc. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION CSE010V2PR()

Local aArea			:= GetArea()
Local cLine			:=	""
Local aField 		:= {{}}
Local aData   		:= {{}}
Local aTempRead		:= {}
Local aTempData		:= {}
Local nLenFields	:= 0
Local nLenData		:= 0
Local lProcess		:= .T.
Local nModo			:= 0      
Local nX,nY,nZ
Local nPosField		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Identificadores das posicoes dos alias nos arrays de trabalho              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAlias		:= {"SB1"}
Local nPosAlias		:= 0
Local cAliasCab		:= "SB1"
Local aAliasIt		:= {"SB1"}
Local aFieldObr		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis para controle das posicoes dos campos obrigatorios da estrutura  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosSB1FIL	:= 0
Local nPosSB1COD	:= 0
Local nPosSB1DSC	:= 0
Local nPosE07CTA	:= 0
Local nPosE07DSC	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona os campos obrigatorios da estrutura do arquivo para validacao     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aFieldObr,"B1_FILIAL")
AADD(aFieldObr,"B1_COD")
AADD(aFieldObr,"B1_DESC")
AADD(aFieldObr,"B1_E07CTA")
AADD(aFieldObr,"B1_E07DSC")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva as variaveis de ambiente                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SaveInter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do processamento                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validacoes preliminares                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF (nHandle := FT_FUse(AllTrim(MV_PAR01)))== -1
	HELP(" ",1,"CSE010V2PR.01",,"Nao foi possivel abrir o arquivo selecionado para processamento.",4,0)//"Nao foi possivel abrir o arquivo selecionado para importacao."
	lProcess := .F.
ENDIF

IF MV_PAR02 != 1 // CADASTRO DE PRODUTOS
	HELP(" ",1,"CSE010V2PR.02",,"Opcao selecionada invalida. Somente eh permitido vincular ao Cadastro de Produtos",4,0)//"Opcao selecionada invalida. Somente eh permitido vincular ao Plano de Contas"
	lProcess := .F.
ENDIF

IF MV_PAR03 != 1 // CADASTRO DE PRODUTOS COMERCIALIZADOS
	HELP(" ",1,"CSE010V2PR.03",,"Opcao selecionada invalida. Somente eh permitido vincular com Produtos Comercializados",4,0)//"Opcao selecionada invalida. Somente eh permitido vincular com Tipo de Atividade"
	lProcess := .F.
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³1a Etapa: Leitura do arquivo em conversao nos arrays de trabalho ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	WHILE !FT_FEOF()
	
		cLine		:= FT_FREADLN()
		aTempRead 	:= StrtoKarr(cLine,";")
	
		IF 		aTempRead[1] == "0" // Linhas de estrutrua de campos
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(aTempRead[2]) == cAlias})) > 0

				// Elimina as duas primeiras posicoes: Identificador e Alias
				FOR nX := 3 TO LEN(aTempRead)
					AADD(aField[nPosAlias],{aTempRead[nX],X3TIPO(aTempRead[nX])})
				NEXT nX
				
			ELSE
				HELP(" ",1,"CSE010V2PR.04",,"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
											"Alias invalido: "+ALLTRIM(aTempRead[2]),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Alias invalido: "
				lProcess := .F.
				EXIT
			ENDIF
	
		ELSEIF	aTempRead[1] $ "1/2"	// Linha de dados: CT1(1)
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(aTempRead[2]) == cAlias})) > 0

				aTempData := {}
				
				// Elimina as duas primeiras posicoes: Identificador e Alias
				FOR nX := 3 TO LEN(aTempRead)
					AADD(aTempData,aTempRead[nX])			
				NEXT nX		

				AADD(aData[nPosAlias],aClone(aTempData))
				
			ELSE
				HELP(" ",1,"CSE010V2PR.05",,"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
											"Alias invalido: "+ALLTRIM(aTempRead[2]),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Alias invalido: "
				lProcess := .F.
				EXIT
			ENDIF

		ELSE
			HELP(" ",1,"CSE010V2PR.06",,"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
										"Identificador de linha invalido: "+aTempRead[1],4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Identificador de linha invalido: "
			lProcess := .F.
			EXIT
		ENDIF
	
		FT_FSKIP()
		
	END

	FT_FUSE()
	FCLOSE(nHandle)

ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³2a Etapa: Validacao da estrutura de campos e conteudos dos arrays³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.1: Validacao da quantidade de estruturas de campos x Alias     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF LEN(aField) != LEN(aAlias)

		HELP(" ",1,"CSE010V2PR.09",,"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
									"Quantidade de estruturas suportadas/necessarias: "+STRZERO(LEN(aAlias))+CRLF+;
									"Quantidade de estruturas informadas no arquivo : "+STRZERO(LEN(aField))+CRLF,4,0)
		lProcess := .F.		
	
	ELSE

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.2: Validacao do dicionario de dados x estrutura de campos      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FOR nX := 1 TO LEN(aAlias) // 1-> SB1

			FOR nY := 1 TO LEN(aField[nX])

				IF (aAlias[nX])->(FieldPos(aField[nX][nY][1])) == 0 .AND. aScan( aFieldObr,{ |cField| ALLTRIM(cField) == ALLTRIM( aField[nX][nY][1] ) } ) == 0

					HELP(" ",1,"CSE010V2PR.10",,"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
												"Campo invalido: "+aField[nX][nY][1],4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Identificador de linha invalido: "
					lProcess := .F.
					EXIT
				
				ENDIF

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.2.1: Salva a posicao dos campos obrigatorios para validacao posterior ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				DO CASE
					CASE aField[nX][nY][1] == "B1_FILIAL"
						nPosSB1FIL := nY

					CASE aField[nX][nY][1] == "B1_COD"
						nPosSB1COD := nY

					CASE aField[nX][nY][1] == "B1_DESC"
						nPosSB1DSC := nY

					CASE aField[nX][nY][1] == "B1_E07CTA"
						nPosE07CTA := nY

					CASE aField[nX][nY][1] == "B1_E07DSC"
						nPosE07DSC := nY											
				ENDCASE

			NEXT nY
		
		NEXT nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.3: Validacao dos campos obrigatorios na estrutura do arquivo     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF 		nPosSB1FIL == 0
			HELP(" ",1,"CSE010V2PR.11",,"Campo obrigatorio nao presente na estrutura do arquivo."+CRLF+;
										"Campo: B1_FILIAL",4,0)
			lProcess := .F.

		ELSEIF 	nPosSB1COD == 0
			HELP(" ",1,"CSE010V2PR.11",,"Campo obrigatorio nao presente na estrutura do arquivo."+CRLF+;
										"Campo: B1_COD",4,0)
			lProcess := .F.


		ELSEIF 	nPosSB1DSC == 0
			HELP(" ",1,"CSE010V2PR.11",,"Campo obrigatorio nao presente na estrutura do arquivo."+CRLF+;
										"Campo: B1_DESC",4,0)
			lProcess := .F.

		ELSEIF 	nPosE07CTA == 0
			HELP(" ",1,"CSE010V2PR.11",,"Campo obrigatorio nao presente na estrutura do arquivo."+CRLF+;
										"Campo: B1_E07CTA",4,0)
			lProcess := .F.

		ELSEIF 	nPosE07DSC == 0
			HELP(" ",1,"CSE010V2PR.11",,"Campo obrigatorio nao presente na estrutura do arquivo."+CRLF+;
										"Campo: B1_E07DSC",4,0)
			lProcess := .F.
		
		ENDIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.4: Validacao da quantidade de itens das linhas de dados x campos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FOR nX := 1 TO LEN(aAlias)
			
			nLenFields := Len(aField[nX])
			
			FOR nY := 1 TO LEN(aData[nX])

				nLenData := Len(aData[nX][nY])
							
				IF nLenData != nLenFields

					HELP(" ",1,"CSE010V2PR.12",,"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
												"Quantidade de campos invalida: "+CRLF+;
												"Alias: "+aAlias[nX]	+" / Campos: "+STRZERO(nLenFields)+CRLF+;
												"Linha: "+STRZERO(nY)	+" / Campos: "+STRZERO(nLenData)+" .",4,0)
					lProcess := .F.
					EXIT
				
				ENDIF	
			
			NEXT nY
		
		NEXT nX
		
	ENDIF
	
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³3a Etapa: Efetua a gravacao da tabela CT1 atualizando o          ³
//³          vinculo com o cadastro de tipos de atividades          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ INICIO DA TRANSACAO                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BEGIN TRANSACTION

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³3.1: Gravacao dos itens do cadastro do plano de entidades contabeis³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	FOR nX := 1 TO Len(aAliasIt)

		DbSelectArea(aAliasIt[nX])
		DbSetOrder(1)
                                        
		IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0

			FOR nY := 1 TO Len(aData[nPosAlias])

				IF (aAliasIt[nX])->(DbSeek( aData[nPosAlias][nY][nPosSB1FIL] + aData[nPosAlias][nY][nPosSB1COD] ) )
				
					RecLock(aAliasIt[nX],.F.)
					
						FieldPut(FieldPos("B1_EC07DB"), aData[nPosAlias][nY][nPosE07CTA])
						FieldPut(FieldPos("B1_EC07CR"), aData[nPosAlias][nY][nPosE07CTA])
						
					MsUnlock()
					
					IF CV0->( DbSeek(xFilial("CV0")+"07"+aData[nPosAlias][nY][nPosE07CTA]) )
						RecLock("CV0",.F.)
							
							CV0->CV0_ENT01 		:= SB1->B1_CONTA
							CV0->CV0_E01DSC 	:= GetAdvFVal("CT1","CT1_DESC01",xFilial("CT1")+SB1->B1_CONTA,1,"")
						
						MsUnLock()			    	
					ENDIF
			    
			    ENDIF

			NEXT nY

		ELSE
			HELP(" ",1,"CSE010V2PR.13",,"Erro na gravacao dos dados nos arquivos de itens."+CRLF+;
										"Alias de itens: "+aAliasIt[nX],4,0)
			lProcess := .F.
			DisarmTransaction()
			EXIT
		ENDIF				
		
	NEXT nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ FIM DA TRANSACAO                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	END TRANSACTION

ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura as variaveis de ambiente                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestInter()
RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010V3PBºAutor  ³ TOTVS Protheus     º Data ³  06/01/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VINCULA OS CANAIS DE VENDAS (SZ2) COM O CNV (CV0 - ENT08)  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONTABILIDADE GERENCIAL - ORCAMENTO CONTABIL               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSE010V3PB()

Local aArea		:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)          			³
//³ MV_PAR01   - Arquivo a importar:           						     	³
//³ MV_PAR02   - Entidade sistemica:               					     	³
//³ MV_PAR03   - Entidade orcamentaria:            					     	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CSE010PVI(3) .AND.;//Parambox da rotina de exportacao do orcamento
	ApMsgNoYes(	"Confirma a atualizacao do vinculo entre o cadastro de canais de vendas e a entidade contabil canais de vendas conforrme regra do arquivo selecionado?","ENTIDADES SISTEMICAS x ENTIDADES ORCAMENTARIAS: Vincular")
				MsgRun("Vinculando cadastro de canais de vendas a entidade contabil canal de vendas...","ENTIDADES SISTEMICAS x ENTIDADES ORCAMENTARIAS: Vincular",{|| CSE010V3PR()})
ENDIF

RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSE010V3PRºAutor  ³ TOTVS PROTHEUS     º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ VINCULA O CADASTRO DE CANAIS DE VENDAS (SZ2) AO CNV.EC08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION CSE010V3PR()

Local aArea			:= GetArea()
Local cLine			:=	""
Local aField 		:= {{}}
Local aData   		:= {{}}
Local aTempRead		:= {}
Local aTempData		:= {}
Local nLenFields	:= 0
Local nLenData		:= 0
Local lProcess		:= .T.
Local nModo			:= 0      
Local nX,nY,nZ
Local nPosField		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Identificadores das posicoes dos alias nos arrays de trabalho              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAlias		:= {"SZ2"}
Local nPosAlias		:= 0
Local cAliasCab		:= "SZ2"
Local aAliasIt		:= {"SZ2"}
Local aFieldObr		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis para controle das posicoes dos campos obrigatorios da estrutura  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosSZ2COD	:= 0
Local nPosSZ2CNV	:= 0
Local nPosE08CTA	:= 0
Local nPosE08DSC	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona os campos obrigatorios da estrutura do arquivo para validacao     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aFieldObr,"Z2_CODIGO")
AADD(aFieldObr,"Z2_CANAL")
AADD(aFieldObr,"Z2_E08CTA")
AADD(aFieldObr,"Z2_E08DSC")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva as variaveis de ambiente                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SaveInter()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio do processamento                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validacoes preliminares                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF (nHandle := FT_FUse(AllTrim(MV_PAR01)))== -1
	HELP(" ",1,"CSE010V3PR.01",,"Nao foi possivel abrir o arquivo selecionado para processamento.",4,0)//"Nao foi possivel abrir o arquivo selecionado para importacao."
	lProcess := .F.
ENDIF

IF MV_PAR02 != 1 // CADASTRO DE PRODUTOS
	HELP(" ",1,"CSE010V3PR.02",,"Opcao selecionada invalida. Somente eh permitido vincular ao Cadastro de Canais de Vendas",4,0)//"Opcao selecionada invalida. Somente eh permitido vincular ao Plano de Contas"
	lProcess := .F.
ENDIF

IF MV_PAR03 != 1 // CADASTRO DE PRODUTOS COMERCIALIZADOS
	HELP(" ",1,"CSE010V3PR.03",,"Opcao selecionada invalida. Somente eh permitido vincular com a Entidade Canais de Vendas",4,0)//"Opcao selecionada invalida. Somente eh permitido vincular com Tipo de Atividade"
	lProcess := .F.
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³1a Etapa: Leitura do arquivo em conversao nos arrays de trabalho ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	WHILE !FT_FEOF()
	
		cLine		:= FT_FREADLN()
		aTempRead 	:= StrtoKarr(cLine,";")
	
		IF 		aTempRead[1] == "0" // Linhas de estrutrua de campos
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(aTempRead[2]) == cAlias})) > 0

				// Elimina as duas primeiras posicoes: Identificador e Alias
				FOR nX := 3 TO LEN(aTempRead)
					AADD(aField[nPosAlias],{aTempRead[nX],X3TIPO(aTempRead[nX])})
				NEXT nX
				
			ELSE
				HELP(" ",1,"CSE010V3PR.04",,"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
											"Alias invalido: "+ALLTRIM(aTempRead[2]),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Alias invalido: "
				lProcess := .F.
				EXIT
			ENDIF
	
		ELSEIF	aTempRead[1] $ "1/2"	// Linha de dados: CT1(1)
			
			IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(aTempRead[2]) == cAlias})) > 0

				aTempData := {}
				
				// Elimina as duas primeiras posicoes: Identificador e Alias
				FOR nX := 3 TO LEN(aTempRead)
					AADD(aTempData,aTempRead[nX])			
				NEXT nX		

				AADD(aData[nPosAlias],aClone(aTempData))
				
			ELSE
				HELP(" ",1,"CSE010V3PR.05",,"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
											"Alias invalido: "+ALLTRIM(aTempRead[2]),4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Alias invalido: "
				lProcess := .F.
				EXIT
			ENDIF

		ELSE
			HELP(" ",1,"CSE010V3PR.06",,"Erro na estrutura do arquivo selecionado para importacao."+CRLF+;
										"Identificador de linha invalido: "+aTempRead[1],4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Identificador de linha invalido: "
			lProcess := .F.
			EXIT
		ENDIF
	
		FT_FSKIP()
		
	END

	FT_FUSE()
	FCLOSE(nHandle)

ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³2a Etapa: Validacao da estrutura de campos e conteudos dos arrays³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³2.1: Validacao da quantidade de estruturas de campos x Alias     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF LEN(aField) != LEN(aAlias)

		HELP(" ",1,"CSE010V3PR.09",,"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
									"Quantidade de estruturas suportadas/necessarias: "+STRZERO(LEN(aAlias))+CRLF+;
									"Quantidade de estruturas informadas no arquivo : "+STRZERO(LEN(aField))+CRLF,4,0)
		lProcess := .F.		
	
	ELSE

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.2: Validacao do dicionario de dados x estrutura de campos      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FOR nX := 1 TO LEN(aAlias) // 1-> SB1

			FOR nY := 1 TO LEN(aField[nX])

				IF (aAlias[nX])->(FieldPos(aField[nX][nY][1])) == 0 .AND. aScan( aFieldObr,{ |cField| ALLTRIM(cField) == ALLTRIM( aField[nX][nY][1] ) } ) == 0

					HELP(" ",1,"CSE010V3PR.10",,"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
												"Campo invalido: "+aField[nX][nY][1],4,0)//"Erro na estrutura do arquivo selecionado para importacao."###"Identificador de linha invalido: "
					lProcess := .F.
					EXIT
				
				ENDIF

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³2.2.1: Salva a posicao dos campos obrigatorios para validacao posterior ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				DO CASE
					CASE aField[nX][nY][1] == "Z2_CODIGO"
						nPosSZ2COD := nY

					CASE aField[nX][nY][1] == "Z2_CANAL"
						nPosSZ2CNV := nY

					CASE aField[nX][nY][1] == "Z2_E08CTA"
						nPosE08CTA := nY

					CASE aField[nX][nY][1] == "Z2_E08DSC"
						nPosE08DSC := nY											
				ENDCASE

			NEXT nY
		
		NEXT nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.3: Validacao dos campos obrigatorios na estrutura do arquivo     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF 	nPosSZ2COD == 0
			HELP(" ",1,"CSE010V3PR.11",,"Campo obrigatorio nao presente na estrutura do arquivo."+CRLF+;
										"Campo: Z2_CODIGO",4,0)
			lProcess := .F.


		ELSEIF 	nPosSZ2CNV == 0
			HELP(" ",1,"CSE010V3PR.11",,"Campo obrigatorio nao presente na estrutura do arquivo."+CRLF+;
										"Campo: Z2_CANAL",4,0)
			lProcess := .F.

		ELSEIF 	nPosE08CTA == 0
			HELP(" ",1,"CSE010V3PR.11",,"Campo obrigatorio nao presente na estrutura do arquivo."+CRLF+;
										"Campo: Z2_E08CTA",4,0)
			lProcess := .F.

		ELSEIF 	nPosE08DSC == 0
			HELP(" ",1,"CSE010V3PR.11",,"Campo obrigatorio nao presente na estrutura do arquivo."+CRLF+;
										"Campo: Z2_E08DSC",4,0)
			lProcess := .F.
		
		ENDIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³2.4: Validacao da quantidade de itens das linhas de dados x campos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FOR nX := 1 TO LEN(aAlias)
			
			nLenFields := Len(aField[nX])
			
			FOR nY := 1 TO LEN(aData[nX])

				nLenData := Len(aData[nX][nY])
							
				IF nLenData != nLenFields

					HELP(" ",1,"CSE010V3PR.12",,"Erro na estrutura de campos informada no arquivo selecionado para importacao."+CRLF+;
												"Quantidade de campos invalida: "+CRLF+;
												"Alias: "+aAlias[nX]	+" / Campos: "+STRZERO(nLenFields)+CRLF+;
												"Linha: "+STRZERO(nY)	+" / Campos: "+STRZERO(nLenData)+" .",4,0)
					lProcess := .F.
					EXIT
				
				ENDIF	
			
			NEXT nY
		
		NEXT nX
		
	ENDIF
	
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³3a Etapa: Efetua a gravacao da tabela CT1 atualizando o          ³
//³          vinculo com o cadastro de tipos de atividades          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lProcess

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ INICIO DA TRANSACAO                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BEGIN TRANSACTION

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³3.1: Gravacao dos itens do cadastro do plano de entidades contabeis³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	FOR nX := 1 TO Len(aAliasIt)

		DbSelectArea(aAliasIt[nX])
		DbSetOrder(1)
                                        
		IF (nPosAlias := aScan(aAlias,{|cAlias| ALLTRIM(cAlias) == ALLTRIM(aAliasIt[nX])})) > 0

			FOR nY := 1 TO Len(aData[nPosAlias])

				IF (aAliasIt[nX])->(DbSeek( xFilial("SZ2") + aData[nPosAlias][nY][nPosSZ2COD] ) )
				
					RecLock(aAliasIt[nX],.F.)
					
						FieldPut(FieldPos("Z2_EC08DB"), aData[nPosAlias][nY][nPosE08CTA])
						FieldPut(FieldPos("Z2_EC08CR"), aData[nPosAlias][nY][nPosE08CTA])
						
					MsUnlock()
					
			    ENDIF

			NEXT nY

		ELSE
			HELP(" ",1,"CSE010V3PR.13",,"Erro na gravacao dos dados nos arquivos de itens."+CRLF+;
										"Alias de itens: "+aAliasIt[nX],4,0)
			lProcess := .F.
			DisarmTransaction()
			EXIT
		ENDIF				
		
	NEXT nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ FIM DA TRANSACAO                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	END TRANSACTION

ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura as variaveis de ambiente                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestInter()
RestArea(aArea)
Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE010PBIºAutor  ³ TOTVS PROTHEUS     º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parambox da rotina de importacao do entidades              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION CSE010PBI()

Local aParamBox 	:= {}										// Array de parametros de acordo com a regra da ParamBox
Local cTitulo		:= "Importacao do cadastro de plano de entidades contabeis"	// Titulo da janela de parametros
Local aRet			:= {}										// Array que será passado por referencia e retornado com o conteudo de cada parametro
Local bOk			:= {|| .T.}									// Bloco de codigo para validacao do OK da tela de parametros
Local aButtons		:= {}										// Array contendo a regra para adicao de novos botoes (além do OK e Cancelar) // AADD(aButtons,{nType,bAction,cTexto})
Local lCentered		:= .T.										// Se a tela será exibida centralizada, quando a mesma não estiver vinculada a outra janela
Local nPosx		    										// Posicao inicial -> linha (Linha final: nPosX+274)
Local nPosy													// Posicao inicial -> coluna (Coluna final: nPosY+445)
//Local oMainDlg											// Caso o ParamBox deva ser vinculado a uma outra tela
Local cLoad			:= ""										// Nome do arquivo aonde as respostas do usuário serão salvas / lidas
Local lCanSave		:= .F.										// Se as respostas para as perguntas podem ser salvas
Local lUserSave 	:= .F.										// Se o usuário pode salvar sua propria configuracao
Local nX			:= 0
Local lRet			:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)          			³
//³ MV_PAR01   - Arquivo a importar:           						     	³
//³ MV_PAR02   - Entidade:                         					     	³
//³ MV_PAR03   - Plano contabil:                   					     	³
//³ MV_PAR04   - Modo de importacao: (Novo cadastro / Atualizar cadastro)   ³
//³ MV_PAR05   - Exibe cadastro para edicao: (Sim / Nao)   					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aParamBox,{6,"Arquivo a importar         " ,SPACE(150)					,"",,"",90 ,.T.,"Arquivo .CSV |*.CSV","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
AADD(aParamBox,{1,"Entidade                   " ,CT0->CT0_ID    				,"@!","AllwaysTrue()",,".F.",TamSx3("CT0_ID")[1],.T.})
AADD(aParamBox,{1,"Plano contabil             " ,CT0->CT0_ENTIDA				,"@!","AllwaysTrue()",,".F.",TamSx3("CT0_ENTIDA")[1],.T.})
AADD(aParamBox,{2,"Modo de importacao         " ,2,{"Novo cadastro","Atualizar cadastro"}	,100,"AllwaysTrue()",.T.,.T.})
AADD(aParamBox,{2,"Exibe cadastro para edicao " ,2,{"Sim","Nao"}										,100,"AllwaysTrue()",.T.,.T.})

lRet := ParamBox(aParamBox, cTitulo, aRet, bOk, aButtons, lCentered, nPosx, nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)

IF ValType(aRet) == "A" .AND. Len(aRet) == Len(aParamBox)
	For nX := 1 to Len(aParamBox)
		If aParamBox[nX][1] == 1
			&("MV_PAR"+StrZero(nX,2)) := aRet[nX]
		ElseIf aParamBox[nX][1] == 2 .AND. ValType(aRet[nX]) == "C"
			&("MV_PAR"+StrZero(nX,2)) := aScan(aParamBox[nX][4],{|x| Alltrim(x) == aRet[nX]})
		ElseIf aParamBox[nX][1] == 2 .AND. ValType(aRet[nX]) == "N"
			&("MV_PAR"+StrZero(nX,2)) := aRet[nX]
		Endif	
	Next nX
ENDIF

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE010PBEºAutor  ³ TOTVS PROTHEUS     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parambox da rotina de exportacao de entidades              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION CSE010PBE()

Local aParamBox := {}										// Array de parametros de acordo com a regra da ParamBox
Local cTitulo	:= "Exportacao do cadastro de plano de entidades contabeis"	// Titulo da janela de parametros
Local aRet		:= {}										// Array que será passado por referencia e retornado com o conteudo de cada parametro
Local bOk		:= {|| .T.}									// Bloco de codigo para validacao do OK da tela de parametros
Local aButtons	:= {}										// Array contendo a regra para adicao de novos botoes (além do OK e Cancelar) // AADD(aButtons,{nType,bAction,cTexto})
Local lCentered	:= .T.										// Se a tela será exibida centralizada, quando a mesma não estiver vinculada a outra janela
Local nPosx		    										// Posicao inicial -> linha (Linha final: nPosX+274)
Local nPosy													// Posicao inicial -> coluna (Coluna final: nPosY+445)
//Local oMainDlg											// Caso o ParamBox deva ser vinculado a uma outra tela
Local cLoad		:= ""										// Nome do arquivo aonde as respostas do usuário serão salvas / lidas
Local lCanSave	:= .F.										// Se as respostas para as perguntas podem ser salvas
Local lUserSave := .F.										// Se o usuário pode salvar sua propria configuracao
Local nX		:= 0
Local lRet		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)          			    ³
//³ MV_PAR01   - Entidade:                         					     	    ³
//³ MV_PAR02   - Plano contabil:                   					     	    ³
//³ MV_PAR03   - Arquivo destino:              						     	       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aParamBox,{1,"Entidade         " ,CT0->CT0_ID    			,"@!","AllwaysTrue()",,".F.",TamSx3("CT0_ID")[1],.T.})
AADD(aParamBox,{1,"Plano contabil   " ,CT0->CT0_ENTIDA			,"@!","AllwaysTrue()",,".F.",TamSx3("CT0_ENTIDA")[1],.T.})
AADD(aParamBox,{6,"Arquivo de saida " ,SPACE(150)					,"",,"",90 ,.T.,"Arquivo .CSV |*.CSV","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})

lRet := ParamBox(aParamBox, cTitulo, aRet, bOk, aButtons, lCentered, nPosx, nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)

IF ValType(aRet) == "A" .AND. Len(aRet) == Len(aParamBox)
	For nX := 1 to Len(aParamBox)
		If aParamBox[nX][1] == 1
			&("MV_PAR"+StrZero(nX,2)) := aRet[nX]
		ElseIf aParamBox[nX][1] == 2 .AND. ValType(aRet[nX]) == "C"
			&("MV_PAR"+StrZero(nX,2)) := aScan(aParamBox[nX][4],{|x| Alltrim(x) == aRet[nX]})
		ElseIf aParamBox[nX][1] == 2 .AND. ValType(aRet[nX]) == "N"
			&("MV_PAR"+StrZero(nX,2)) := aRet[nX]
		Endif	
	Next nX
ENDIF

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSE010PVIºAutor  ³ TOTVS PROTHEUS     º Data ³ ----------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parambox da rotina de vincular ent.contabil x ent.orcamto. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION CSE010PVI(nSelPergs)

Local aParamBox 	:= {}									// Array de parametros de acordo com a regra da ParamBox
Local cTitulo		:= ""									// Titulo da janela de parametros
Local aRet			:= {}									// Array que será passado por referencia e retornado com o conteudo de cada parametro
Local bOk			:= {|| .T.}								// Bloco de codigo para validacao do OK da tela de parametros
Local aButtons		:= {}									// Array contendo a regra para adicao de novos botoes (além do OK e Cancelar) // AADD(aButtons,{nType,bAction,cTexto})
Local lCentered		:= .T.									// Se a tela será exibida centralizada, quando a mesma não estiver vinculada a outra janela
Local nPosx		    										// Posicao inicial -> linha (Linha final: nPosX+274)
Local nPosy													// Posicao inicial -> coluna (Coluna final: nPosY+445)
//Local oMainDlg											// Caso o ParamBox deva ser vinculado a uma outra tela
Local cLoad			:= ""									// Nome do arquivo aonde as respostas do usuário serão salvas / lidas
Local lCanSave		:= .F.									// Se as respostas para as perguntas podem ser salvas
Local lUserSave 	:= .F.									// Se o usuário pode salvar sua propria configuracao
Local nX			:= 0
Local lRet			:= .F.

Default nSelPergs 	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Perguntas para parametrizacao da rotina (PARAMBOX)          			³
//³ MV_PAR01   - Arquivo a importar:           						     	³
//³ MV_PAR02   - Entidade contabil:                					     	³
//³ MV_PAR03   - Entidade orcamentaria:            					     	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aParamBox,{6,"Arquivo a importar         " ,SPACE(150)						,"",,"",90 ,.T.,"Arquivo .CSV |*.CSV","",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})

DO CASE

	CASE nSelPergs == 1 
		cTitulo := "Vincular plano de contas aos tipos de atividades"
		AADD(aParamBox,{2,"Entidade Contabil          " ,2,{"Plano de contas"}				,100,"AllwaysTrue()",.T.,.T.})
		AADD(aParamBox,{2,"Entidade Orcamentaria      " ,2,{"Tipo de Atividade"}			,100,"AllwaysTrue()",.T.,.T.})

	CASE nSelPergs == 2
		cTitulo := "Vincular produtos aos produtos comercializados"
		AADD(aParamBox,{2,"Entidade Sistemica         " ,2,{"Produtos"}					,100,"AllwaysTrue()",.T.,.T.})
		AADD(aParamBox,{2,"Entidade Orcamentaria      " ,2,{"Produtos Comercializados"}	,100,"AllwaysTrue()",.T.,.T.})

	CASE nSelPergs == 3
		cTitulo := "Vincular canais de vendas a entidade canais de vendas"
		AADD(aParamBox,{2,"Entidade Sistemica         " ,2,{"Canais de Vendas"}				,100,"AllwaysTrue()",.T.,.T.})
		AADD(aParamBox,{2,"Entidade Orcamentaria      " ,2,{"Entidade Canais de Vendas"}	,100,"AllwaysTrue()",.T.,.T.})

ENDCASE

lRet := ParamBox(aParamBox, cTitulo, aRet, bOk, aButtons, lCentered, nPosx, nPosy, /*oMainDlg*/ , cLoad, lCanSave, lUserSave)

IF ValType(aRet) == "A" .AND. Len(aRet) == Len(aParamBox)
	For nX := 1 to Len(aParamBox)
		If aParamBox[nX][1] == 1
			&("MV_PAR"+StrZero(nX,2)) := aRet[nX]
		ElseIf aParamBox[nX][1] == 2 .AND. ValType(aRet[nX]) == "C"
			&("MV_PAR"+StrZero(nX,2)) := aScan(aParamBox[nX][4],{|x| Alltrim(x) == aRet[nX]})
		ElseIf aParamBox[nX][1] == 2 .AND. ValType(aRet[nX]) == "N"
			&("MV_PAR"+StrZero(nX,2)) := aRet[nX]
		Endif	
	Next nX
ENDIF

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CSEValDel  ³ Autor ³ TOTVS PROTHEUS       ³ Data ³ ----------------  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verificar se pode excluir a entidade do plano de cadastro contabil   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSEA010                                                   		    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CSEValDel(cArqDel, cEntidade, cCodEnt, cMoeda, cTpSaldo)

Local aSaveArea	:= GetArea()
Local lRet		:= .T.
Local cFilBack	:= cFilAnt
Local cModo		:= ""
Local nArqs		:= 0
Local aSM0		:= Iif( FindFunction( "AdmAbreSM0" ) , AdmAbreSM0() , {} )
Local nContFil	:= 0
Local __cFilAnt:= cFilAnt

IF Len( aSM0 ) <= 0
	Help(" ",1,"NOFILIAL")
	Return .F.
Endif

dbSelectarea("SX2")
dbSetOrder(1)

If MsSeek(cArqDel)
	cModo	:= SX2->X2_MODO
EndIf

If cModo == "C"	//Se a tabela do registro a ser excluido for compartilhado, devera ser verificado em todas as filiais
	For nContFil := 1 to Len(aSM0)
		If aSM0[nContFil][SM0_GRPEMP] != cEmpAnt
			Loop
		EndIf
		dbSelectArea("CVX")
		dbSetOrder(2) //CVX_FILIAL+CVX_CONFIG+CVX_MOEDA+CVX_TPSALD+DTOS(CVX_DATA)
		cFilAnt	:= aSM0[nContFil][SM0_CODFIL]
		If MsSeek(xFilial()+cEntidade+cMoeda+cTpSaldo)

			While CVX->(!EOF()) .AND.;
					CVX->(CVX_CONFIG+CVX_MOEDA+CVX_TPSALD) == cEntidade+cMoeda+cTpSaldo
					
					If ALLTRIM(CVX->&("CVX_NIV"+cEntidade)) == ALLTRIM(cCodEnt)
						lRet	:= .F.
						cFilAnt	:= cFilBack
						RestArea(aSaveArea)
						Return(lRet)
 					Endif

					CVX->(dbSkip())					
			End

		EndIf
	Next nContFil
	cFilAnt := __cFilAnt
Else
	dbSelectArea("CVX")
	dbSetOrder(2) //CVX_FILIAL+CVX_CONFIG+CVX_MOEDA+CVX_TPSALD+DTOS(CVX_DATA)
	cFilAnt	:= aSM0[nContFil][SM0_CODFIL]
	If MsSeek(xFilial()+cEntidade+cMoeda+cTpSaldo)

		While CVX->(!EOF()) .AND.;
				CVX->(CVX_CONFIG+CVX_MOEDA+CVX_TPSALD) == cEntidade+cMoeda+cTpSaldo
				
				If ALLTRIM(CVX->&("CVX_NIV"+cEntidade)) == ALLTRIM(cCodEnt)
					lRet	:= .F.
					Exit
				Endif

				CVX->(dbSkip())					
		End

	EndIf

EndIf

RestArea(aSaveArea)
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ X3TIPO   ºAutor  ³ TOTVS Protheus     º Data ³  ---------- º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RETORNA O TIPO DO CAMPO CONFORME DICIONARIO DE DADOS       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION X3TIPO(cCampo)

LOCAL aArea 	:= GetArea() 
LOCAL aAreaSX3 := SX3->(GetArea())
LOCAL cTipo		:= "C"  // RETORNO PADRAO PARA PERMITIR O TRATAMENTO DA INFORMACAO NA ROTINA CHAMADORA

DEFAULT cCampo := ""

IF !Empty(cCampo)

	DbSelectArea("SX3")
	DbSetOrder(2) // X3_CAMPO
	IF DbSeek(ALLTRIM(cCampo))
		cTipo := X3_TIPO
	ENDIF

ENDIF

RestArea(aAreaSX3)
RestArea(aArea)

RETURN cTipo

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ NoAcento ³ Autor ³ TOTVS PROTHEUS        ³ Data ³ -------- ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retira acento dos caracteres                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±      
±±³Retorno   ³ ExpC1: Retorna String sem Acento                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Recebe String com Acento                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION NoAcento(cString)

Local nConta := 0           
Local cLetra := ""        
Local cRet   := ""
cString := Upper(cString)
For nConta:= 1 To Len(cString)	
	cLetra := SubStr(cString, nConta, 1)
	Do Case
		Case (Asc(cLetra) >= 191 .and. Asc(cLetra) <= 198) .or. (Asc(cLetra) >= 223 .and. Asc(cLetra) <= 230)
			cLetra := "A"
		Case (Asc(cLetra) >= 199 .and. Asc(cLetra) <= 204) .or. (Asc(cLetra) >= 231 .and. Asc(cLetra) <= 236)
			cLetra := "E"
		Case (Asc(cLetra) >= 204 .and. Asc(cLetra) <= 207) .or. (Asc(cLetra) >= 235 .and. Asc(cLetra) <= 240)
			cLetra := "I"
		Case (Asc(cLetra) >= 209 .and. Asc(cLetra) <= 215) .or. (Asc(cLetra) == 240) .or. (Asc(cLetra) >= 241 .and. Asc(cLetra) <= 247)
			cLetra := "O"
		Case (Asc(cLetra) >= 216 .and. Asc(cLetra) <= 221) .or. (Asc(cLetra) >= 248 .and. Asc(cLetra) <= 253)
			cLetra := "U"
		Case Asc(cLetra) == 128 .or. Asc(cLetra) == 135 .or. Asc(cLetra) == 199 .or. Asc(cLetra) == 231
			cLetra := "C"
		Case Asc(cLetra) == 35 // "#"
			cLetra := "?"
		Case Asc(cLetra) == 63 // "?"
			cLetra := "?" 
		Case cLetra == '"'
			cLetra := ' '
	EndCase   
	cRet := cRet+cLetra
Next

Return UPPER(cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³-----------------------| Data ³----------³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³	 1 - Pesquisa e Posiciona em um Banco de Dados             ³±±
±±³          ³   2 - Simplesmente Mostra os Campos                        ³±±
±±³          ³   3 - Inclui registros no Bancos de Dados                  ³±±
±±³          ³   4 - Altera o registro corrente                           ³±±
±±³          ³   5 - Remove o registro corrente do Banco de Dados         ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function MenuDef()

Local aRotina 		:= {}
Local aSubRot01 	:= {}
Local aSubRot02 	:= {}
Local aSubRot03 	:= {}

aAdd( aSubRot01 	, { OEMTOANSI("Clientes")			, "U_CSE010SN(1)"		, 0 , 0				, 0,.F. })
aAdd( aSubRot01 	, { OEMTOANSI("Fornecedores")		, "U_CSE010SN(2)"		, 0 , 0				, 0,.F. })
aAdd( aSubRot01 	, { OEMTOANSI("Produtos")			, "U_CSE010SN(3)"		, 0 , 0				, 0,.F. })

//aAdd( aSubRot02 	, { OEMTOANSI("Conta   x TPA")		, "U_CSE010VN(1)"		, 0 , 0				, 0,.F. })
//aAdd( aSubRot02 	, { OEMTOANSI("Produto x PRD")		, "U_CSE010VN(2)"		, 0 , 0				, 0,.F. })
//aAdd( aSubRot02 	, { OEMTOANSI("Canal   x CNV")		, "U_CSE010VN(3)"		, 0 , 0				, 0,.F. })

//aAdd( aSubRot03 	, { OEMTOANSI("Importar")			, "U_CSE010IP"			, 0 , 0				, 0,.F. })
//aAdd( aSubRot03 	, { OEMTOANSI("Exportar")			, "U_CSE010EP"			, 0 , 0				, 0,.F. })

aAdd( aRotina		, { OEMTOANSI("Pesquisar")			, "AxPesqui"			, 0 , 1				, 0,.F. })
aAdd( aRotina		, { OEMTOANSI("Visualizar")			, "U_CSE010DLG"			, 0 , 2				, 0,.F. })
aAdd( aRotina		, { OEMTOANSI("Incluir")			, "U_CSE010DLG"			, 0 , nCSEINCLUI	, 0,.F. })
aAdd( aRotina		, { OEMTOANSI("Alterar")			, "U_CSE010DLG"			, 0 , 4				, 0,.F. })
aAdd( aRotina 		, { OEMTOANSI("Sincronizar")		, aClone(aSubRot01)		, 0 , 3				, 0,.F. })
//aAdd( aRotina 		, { OEMTOANSI("Vincular")			, aClone(aSubRot02)		, 0 , 3				, 0,.F. })
//aAdd( aRotina 		, { OEMTOANSI("Ferramentas")		, aClone(aSubRot03)		, 0 , 3				, 0,.F. })

Return(aRotina)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CSEA10A  ºAutor  ³Guilherme C. Leal   º Data ³  01/28/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que retorna o aHeader de um arquivo especificado    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CSEA10A(cAlias,aCpos,aCposNo,aEnchAuto,aCposVisual,lWalk_Thru)

Local aCampo	 := {}
Local aHeader	 := {}
Local aAreaSX3 := SX3->(GetArea())
Local cPode
Local cObgt
Local lObrigat

Default aCpos     := {}
Default aCposVisual:= {}
Default aCposNo   := {}
Default aEnchAuto := {}
Default lWalk_Thru := .F.

SX3->(DbSetOrder(1))
SX3->(DbSeek(cAlias))

Do While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAlias
	If !x3uso(SX3->X3_USADO) 
		SX3->(DbSkip())
		Loop
	EndIf

	cPode := X3Reserv(SX3->x3_reserv)
	cObgt := Bin2Str(SX3->x3_Obrigat)
	lObrigat := Iif(Substr(cPode,7,1)=="x" .or. Substr(cObgt,1,1)== "x",.T.,.F.)
	lVisual := If(aScan(aCposVisual,Alltrim(SX3->X3_CAMPO))>0,.T.,.F.) 
	
		
	
	aCampo := {Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,			;
		SX3->X3_TAMANHO,SX3->X3_DECIMAL,".T.",SX3->X3_USADO,SX3->X3_TIPO,	;
		SX3->X3_F3,SX3->X3_CONTEXT,If(__LANGUAGE=="SPANISH",SX3->X3_CBOXSPA, ;
		If(__LANGUAGE== "ENGLISH",SX3->X3_CBOXENG, SX3->X3_CBOX)),SX3->X3_RELACAO,".T.",		;
		If(lVisual,"V",SX3->X3_VISUAL),	SX3->X3_VLDUSER, SX3->X3_PICTVAR,lObrigat}
		
	If Len(aCposNo) > 0 .And. ( AScan(aCposNo,{|x| Upper(AllTrim(SX3->X3_CAMPO)) == Upper(AllTrim(x)) }) > 0	)
		Aadd(aEnchAuto,aClone(aCampo))
		SX3->(DbSkip())
		Loop
	EndIf
	
	If Len(aCpos) = 0 .Or. ( Len(aCpos) > 0 .And. AScan(aCpos,{|x| Upper(AllTrim(SX3->X3_CAMPO)) == Upper(AllTrim(x)) }) > 0 )
		Aadd(aHeader,aClone(aCampo))
	EndIf

	SX3->(DbSkip())
	
EndDo

If lWalk_Thru
	PcoHeaderWT(cAlias, aHeader)
EndIf

SX3->(RestArea(aAreaSX3))
Return aHeader