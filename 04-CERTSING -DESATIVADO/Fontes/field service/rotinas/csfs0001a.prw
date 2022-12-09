#include "PROTHEUS.CH"
#include "TBICONN.CH"
#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFS001    ºAutor  ³Rodrigo Seiti Mitaniº Data ³  19/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de solicitação de atendimento CS                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSFS0001()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aCores := {}
Private cString   := "PA0"
Private cCadastro := "Solicitação de Atendimento"
Private aRotina   := {  {"Pesquisar" ,"AxPesqui"  ,0,1},;
{ "Visualizar" ,'ExecBlock("CSF01VIS",.T.,.T.)',0,2}, ;
{ "Incluir"    ,'ExecBlock("CSF01INC",.T.,.T.)',0,3}, ;
{ "Alterar"    ,'ExecBlock("CSF01ALT",.T.,.T.)',0,4},;
{ "Excluir"    ,'ExecBlock("CSF01EXC",.T.,.T.)',0,5},;
{ "Fechamento",'ExecBlock("CSF01FEC",.T.,.T.)',0,6},;
{ "Confirmar"   ,'ExecBlock("CSF01COF",.T.,.T.)',0,7},;
{ "Legenda"   ,'ExecBlock("CSF01LEG",.T.,.T.)',0,8}}
//{ "Ger.Ped"   ,'ExecBlock("CSF01PED",.T.,.T.)',0,7},;

aCores := {{"PA0_STATUS == 'A'.And.PA0_SITUAC == 'L'",'ENABLE' },;
{ "PA0_STATUS == 'A'.And.PA0_SITUAC == 'B'",'DISABLE'},;
{ "PA0_STATUS == 'R'.And.PA0_SITUAC == 'R'",'BR_AMARELO'},;
{ "PA0_STATUS == 'F'.And.PA0_SITUAC == 'L'",'BR_AZUL'},;
{ "PA0_STATUS == 'F'.And.PA0_SITUAC == 'B'",'BR_MARROM'},;
{ "PA0_STATUS == 'P'.And.PA0_SITUAC == 'P'",'BR_PRETO'},;
{ "PA0_STATUS == 'C'.And.PA0_SITUAC == 'L'",'BR_LARANJA'},;
{ "PA0_STATUS == 'C'.And.PA0_SITUAC == 'B'",'BR_LARANJA'}}

dbSelectArea(cString)
PA0->(dbSetOrder(1))
MBrowse(6,1,22,75,cString,,,,,,aCores)


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSF01INC  ºAutor  ³Rodrigo Seiti Mitaniº Data ³  19/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclusão de solicitação de atendimento CS                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSF01INC()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aPosObj 	:= {}
Local aObjects := {}
Local aSize		:= {}
Local aPosGet	:= {}
Local aInfo		:= {}              	
Local _nOpca 	:= 0
Local nUsado	:= 0

Private aTela[0][0]
Private aGets[0]
Private nUsado	:= 0
Private aHeader	:= {}
Private aCols	:= {}
//Private nUsado	:= 0
//aGets[0]
Private _numped

_numped	:= GETSXENUM("PA0","PA0_OS")
//ConfirmSX8()	

aButtons := {}

aAdd(aButtons, {"LINE",{|| U_CSF03Par()},"Agenda"})

dbSelectArea("PA0")
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa desta forma para criar uma nova instancia de variaveis private ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "PA0", .T., .F. )

M->PA0_OS := _numped

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa aCols   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("PA1")

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("PA1")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "PA1") )
	If X3USO(SX3->X3_USADO)
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo
aadd(aCOLS,Array(nUsado+1))
For nCntFor	:= 1 To nUsado
	aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
	If ( AllTrim(aHeader[nCntFor][2]) == "PA1_ITEM" )
		aCols[1][nCntFor] := "0001"
	EndIf
	
Next nCntFor
aCols[1][Len(aHeader)+1] := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona os objetos na tela
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
{{003,033,160,200,240,263}} )

DEFINE MSDIALOG oDlg TITLE "Solicitação de Atendimento" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

EnChoice( "PA0", , 3, , , , , aPosObj[1], , 3, , , , , ,.T., , , ,.T. )

oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],3    ,"U_GeraInte",        ,"+PA1_ITEM",.T.     ,      ,       ,      , 50 ,        ,         ,,      ,    )
//  METHOD          New(nT          ,nL          ,          nB,         nR ,nOpc ,cLinhaOk ,cTudoOk ,cIniCpos ,lDeleta ,aAlter,nFreeze,lEmpty,nMax,cFieldOk,cSuperDel,,cDelOk,oWnd)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||_nOpcA:=1,If(!obrigatorio(aGets,aTela),_nOpcA:=0,If(oGetd:TudoOk(),oDlg:End(),_nOpcA:=0))},{||oDlg:End()},,aButtons)

If _nOpcA == 0 // Cancelar
	PA0->(RollBackSXE())
	PA0->(RollbackSXF())
EndIf
If _nOpcA == 1 // Confirmar
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Localiza a posição dos campos no acols³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
	nPosDel   := Len( aHeader ) + 1
	nPosItem  := GDFieldPos( "PA1_ITEM"   )
	nPosProd  := GDFieldPos( "PA1_PRODUT" )
	nPosDesc  := GDFieldPos( "PA1_DESCRI" )
	nPosQtd   := GDFieldPos( "PA1_QUANT"  )
	nPosPrc   := GDFieldPos( "PA1_PRCUNI" )
	nPosTot   := GDFieldPos( "PA1_VALOR"  )
	nPosCnpj  := GDFieldPos( "PA1_CNPJ"   )
	//nPosTes   := GDFieldPos( "PA1_TES"    )
	nPosFat   := GDFieldPos( "PA1_FATURA" )
	nPosPed   := GDFieldPos( "PA1_PEDIDO" )
	nPosLoc   := GDFieldPos( "PA1_VOUCHE"  ) //campo incluido conforme solicitação da Elaine Pompilio
//	nPosGer   := GDFieldPos( "PA1_GERADO" )	

	_STD := 'L'
	For _i := 1 To Len(aCols)
		If !aCols[_i,nPosDel] .and. !Empty(aCols[_i,nPosProd])
			If aCols[_i,nPosFat ]  == 'N'
				_STD := 'B'
			End If
		End If
	Next _i
	
	DbSelectArea("PA0")
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava cabeçalho da solicitação de atendimento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	DbSetOrder(1)
	RecLock("PA0",.T.)
	PA0->PA0_FILIAL := xFilial("PA0")
	PA0->PA0_OS     := M->PA0_OS
	PA0->PA0_CLIFAT := M->PA0_CLIFAT
	PA0->PA0_LOJAFA := M->PA0_LOJAFA
	PA0->PA0_CLFTNM := M->PA0_CLFTNM
	PA0->PA0_CLILOC := M->PA0_CLILOC
	PA0->PA0_LOJLOC := M->PA0_LOJLOC
	PA0->PA0_CLLCNO := M->PA0_CLLCNO
	PA0->PA0_END    := M->PA0_END
	PA0->PA0_BAIRRO := M->PA0_BAIRRO
	PA0->PA0_CEP    := M->PA0_CEP
	PA0->PA0_CIDADE := M->PA0_CIDADE
	PA0->PA0_ESTADO := M->PA0_ESTADO
	PA0->PA0_DDD    := IIF( ValType(M->PA0_DDD)=='N', M->PA0_DDD, Val(M->PA0_DDD) )
	PA0->PA0_TEL    := M->PA0_TEL
	PA0->PA0_RAMAL  := M->PA0_RAMAL
	PA0->PA0_CONDPA := M->PA0_CONDPA
	//	PA0->PA0_NUMPED:= M->PA0_NUMPED
	PA0->PA0_PROJET := M->PA0_PROJET
	PA0->PA0_HRAGEN := M->PA0_HRAGEN
	PA0->PA0_REGIAO := M->PA0_REGIAO
	PA0->PA0_DTAGEN := M->PA0_DTAGEN
	PA0->PA0_TPSERV := M->PA0_TPSERV
	PA0->PA0_OBS    := M->PA0_OBS
	PA0->PA0_DESLOC := M->PA0_DESLOC
	PA0->PA0_CONTAT := M->PA0_CONTAT
	PA0->PA0_STATUS := "C"
	PA0->PA0_SITUAC := _STD
	PA0->PA0_AR     := M->PA0_AR
	MsUnlock()
	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava itens da solicitação de atendimento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	For _i := 1 To Len(aCols)
		If !aCols[_i,nPosDel] .and. !Empty(aCols[_i,nPosProd])
			
			DbSelectArea("PA1")
			DbSetOrder(1)
			RecLock("PA1",.T.)
			
			PA1->PA1_FILIAL 	:= xFilial("PA1")
			PA1->PA1_OS     	:= M->PA0_OS
			PA1->PA1_ITEM   	:= aCols[_i,nPosItem]
			PA1->PA1_PRODUT	:= aCols[_i,nPosProd]
			PA1->PA1_DESCRI	:= aCols[_i,nPosDesc]
			PA1->PA1_QUANT	:= aCols[_i,nPosQtd ]
			PA1->PA1_PRCUNI	:= aCols[_i,nPosPrc ]
			PA1->PA1_VALOR	:= aCols[_i,nPosTot ]
			PA1->PA1_CNPJ		:= aCols[_i,nPosCnpj]
			PA1->PA1_TES		:= "903"
			PA1->PA1_FATURA	:= aCols[_i,nPosFat ]
			PA1->PA1_PEDIDO	:= aCols[_i,nPosPed ]
			PA1->PA1_VOUCHE 	:= aCols[_i,nPosLoc ]
//			PA1->PA1_GERADO	:= aCols[_i,nPosGer ]			

			MsUnlock()
			
		End If
	Next _i
  	ConfirmSX8()
	U_CSF01AGE(M->PA0_DTAGEN,M->PA0_HRAGEN)
End If
        
//RollBackSXE()
//RollbackSXF()
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSF01Exc  ºAutor  ³Rodrigo Seiti Mitaniº Data ³  19/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exclusão de solicitação de atendimento CS                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSF01Exc()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aTela[0][0]
Private aGets[0]
Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:= 0
_nOpca := 0

If PA0->PA0_STATUS $ 'A/R/C'
	dbSelectArea("PA0")
	dbSetOrder(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa desta forma para criar uma nova instancia de variaveis private ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RegToMemory( "PA0", .F., .F. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa aCols   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbSelectArea("PA1")
	
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("PA1")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "PA1") )
		If X3USO(SX3->X3_USADO)
			nUsado++
			Aadd(aHeader,{ TRIM(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea("TRB")
	End If
	

BeginSql Alias "TRB"
%noparser%
Select * From %Table:PA1% PA1
Where PA1_OS = %Exp:PA0->PA0_OS% and PA1_FILIAL = %Exp:xFilial("PA1")%
and PA1.%NotDel%
EndSql


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega o acols com as informações do registro posicionado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	Do While !Eof("TRB")
		AADD(aCols,Array(Len(aHeader)+1))
		For nCntFor:=1 To Len(aHeader)
			If ( aHeader[nCntFor,10] <>  "V" )
				aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
			Else
				aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
			EndIf
		Next nCntFor
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		DbSkip()
	End Do
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona os objetos na tela
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
	{{003,033,160,200,240,263}} )
	
	DEFINE MSDIALOG oDlg TITLE "Solicitação de Atendimento" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	EnChoice( "PA0", ,5, , , , , aPosObj[1],,3,,,)
	
	oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],5    ,         ,        ,"",.T.     ,      ,       ,      , 50 ,        ,         ,,      ,    )
	//  METHOD          New(nT          ,nL          ,          nB,         nR ,nOpc ,cLinhaOk ,cTudoOk ,cIniCpos ,lDeleta ,aAlter,nFreeze,lEmpty,nMax,cFieldOk,cSuperDel,,cDelOk,oWnd)
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||_nOpcA:=1,oDlg:End()},{||oDlg:End()},,)
	
	If _nOpcA == 1
		
		/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Deleta cabeçalho da solicitação de atendimento³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		DbSelectArea("PA0")
		DbSetOrder(1)
		DbSeek(xFilial("PA0")+M->PA0_OS)
		If Found()
			RecLock("PA0",.F.)
			DbDelete()
			MsUnlock()
		End If
		
		/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Deleta intens da solicitação de atendimento³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		DbSelectArea("PA1")
		DbSetOrder(1)
		DbSeek(xFilial("PA1")+M->PA0_OS)
		If Found()
			Do While !Eof("PA1") .and. PA1->PA1_OS == M->PA0_OS
				RecLock("PA1",.F.)
				DbDelete()
				MsUnlock()
				DbSkip()
			End Do
		End If
		
		/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Deleta agenda da solicitação de atendimento³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		DbSelectArea("PA2")
		DbSetOrder(3)
		DbSeek(xFilial("PA2")+M->PA0_OS)
		If Found()
			Do While !Eof("PA2") .and. PA2->PA2_NUMOS == M->PA0_OS
				RecLock("PA2",.F.)
				DbDelete()
				MsUnlock()
				DbSkip()
			End Do
		End If
		
	End If
Else
	Alert("Pedido Fechado")
End If

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSF01VIS  ºAutor  ³Rodrigo Seiti Mitaniº Data ³  19/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Visualiza solicitação de atendimento CS                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSF01VIS()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aTela[0][0]
Private aGets[0]
Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:= 0
_nOpca := 0


dbSelectArea("PA0")
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa desta forma para criar uma nova instancia de variaveis private ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "PA0", .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa aCols   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("PA1")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "PA1") )
	If X3USO(SX3->X3_USADO)
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea("TRB")
End If


BeginSql Alias "TRB"
%noparser%
Select * From %Table:PA1% PA1
Where PA1_OS = %Exp:PA0->PA0_OS% and PA1_FILIAL = %Exp:xFilial("PA1")%
and PA1.%NotDel%
EndSql

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega o acols com as informações do registro posicionado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Do While !Eof("TRB")
	AADD(aCols,Array(Len(aHeader)+1))
	For nCntFor:=1 To Len(aHeader)
		If ( aHeader[nCntFor,10] <>  "V" )
			aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
		Else
			aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
		EndIf
	Next nCntFor
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	DbSkip()
End Do

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona os objetos na tela
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
{{003,033,160,200,240,263}} )

DEFINE MSDIALOG oDlg TITLE "Solicitação de Atendimento" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

EnChoice( "PA0", ,2, , , , , aPosObj[1],,3,,,)

oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],2    ,         ,        ,"",.T.     ,      ,       ,      , 50 ,        ,         ,,      ,    )
//  METHOD          New(nT          ,nL          ,          nB,         nR ,nOpc ,cLinhaOk ,cTudoOk ,cIniCpos ,lDeleta ,aAlter,nFreeze,lEmpty,nMax,cFieldOk,cSuperDel,,cDelOk,oWnd)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSF01ALT  ºAutor  ³Rodrigo Seiti Mitaniº Data ³  19/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alteração da solicitação de atendimento CS                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSF01ALT()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aTela[0][0]
Private aGets[0]
Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:= 0
_nOpca := 0

If PA0->PA0_STATUS $ 'A/R/C'
	
	dbSelectArea("PA0")
	dbSetOrder(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa desta forma para criar uma nova instancia de variaveis private ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RegToMemory( "PA0", .F., .F. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa aCols   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("PA1")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "PA1") )
		If X3USO(SX3->X3_USADO)
			nUsado++
			Aadd(aHeader,{ TRIM(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea("TRB")
	End If
	

BeginSql Alias "TRB"
%noparser%
Select * From %Table:PA1% PA1
Where PA1_OS = %Exp:PA0->PA0_OS% and PA1_FILIAL = %Exp:xFilial("PA1")%
and PA1.%NotDel%
EndSql

	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega o acols com as informações do registro posicionado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
	Do While !Eof("TRB")
		AADD(aCols,Array(Len(aHeader)+1))
		For nCntFor:=1 To Len(aHeader)
			If ( aHeader[nCntFor,10] <>  "V" )
				aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
			Else
				aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
			EndIf
		Next nCntFor
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		DbSkip()
	End Do
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona os objetos na tela
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
	{{003,033,160,200,240,263}} )
	
	DEFINE MSDIALOG oDlg TITLE "Solicitação de Atendimento" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	EnChoice( "PA0", ,4, , , , , aPosObj[1],,3,,,)
	
	oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],4    ,"U_GeraInte" ,        ,"+PA1_ITEM",.T.     ,      ,       ,      , 50 ,        ,         ,,      ,    )
	//  METHOD          New(nT          ,nL          ,          nB,         nR ,nOpc ,cLinhaOk ,cTudoOk ,cIniCpos ,lDeleta ,aAlter,nFreeze,lEmpty,nMax,cFieldOk,cSuperDel,,cDelOk,oWnd)
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||_nOpcA:=1,oDlg:End()},{||oDlg:End()},,)
	
	If _nOpcA == 1
		
		/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Localiza a posição dos campos no acols³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		_ClrAgen:= .F.
		nPosDel   := Len( aHeader ) + 1
		nPosItem  := GDFieldPos( "PA1_ITEM"   )
		nPosProd  := GDFieldPos( "PA1_PRODUT" )
		nPosDesc  := GDFieldPos( "PA1_DESCRI" )
		nPosQtd   := GDFieldPos( "PA1_QUANT"  )
		nPosPrc   := GDFieldPos( "PA1_PRCUNI" )
		nPosTot   := GDFieldPos( "PA1_VALOR"  )
		nPosCnpj  := GDFieldPos( "PA1_CNPJ"   )
		//nPosTes   := GDFieldPos( "PA1_TES"    )
		nPosFat   := GDFieldPos( "PA1_FATURA" )
		nPosPed   := GDFieldPos( "PA1_PEDIDO" )
		nPosLoc   := GDFieldPos( "PA1_VOUCHE"  )
//		nPosGer   := GDFieldPos( "PA1_GERADO" )	
		
		_STD := 'L'
		For _i := 1 To Len(aCols)
			If !aCols[_i,nPosDel] .and. !Empty(aCols[_i,nPosProd])
				If aCols[_i,nPosFat ]  == 'N'
					_STD := 'B'
				End If
			End If
		Next _i
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Efetua a gravação da alterações realizados no cabeçalho da solicitação de atendimento³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		DbSelectArea("PA0")
		DbSetOrder(1)
		DbSeek(xFilial("PA0")+M->PA0_OS)
		If Found()
			If PA0->PA0_DTAGEN <> M->PA0_DTAGEN .or. PA0->PA0_HRAGEN <> M->PA0_HRAGEN
				_ClrAgen:= .T.
			End If
			RecLock("PA0",.F.)
			PA0->PA0_CLIFAT:= M->PA0_CLIFAT
			PA0->PA0_LOJAFA:= M->PA0_LOJAFA
			PA0->PA0_CLFTNM:= M->PA0_CLFTNM
			PA0->PA0_END   := M->PA0_END
			PA0->PA0_BAIRRO:= M->PA0_BAIRRO
			PA0->PA0_CEP   := M->PA0_CEP
			PA0->PA0_CIDADE:= M->PA0_CIDADE
			PA0->PA0_ESTADO:= M->PA0_ESTADO
			PA0->PA0_DDD   := IIF( ValType(M->PA0_DDD)=='N', M->PA0_DDD, Val(M->PA0_DDD) )
			PA0->PA0_TEL   := M->PA0_TEL
			PA0->PA0_RAMAL := M->PA0_RAMAL
			PA0->PA0_CONDPA:= M->PA0_CONDPA
			PA0->PA0_CONTAT:= M->PA0_CONTAT
			PA0->PA0_PROJET:= M->PA0_PROJET
			PA0->PA0_HRAGEN:= M->PA0_HRAGEN
			PA0->PA0_REGIAO:= M->PA0_REGIAO
			PA0->PA0_DTAGEN:= M->PA0_DTAGEN
			PA0->PA0_TPSERV:= M->PA0_TPSERV
			PA0->PA0_OBS   := M->PA0_OBS
			PA0->PA0_DESLOC:= M->PA0_DESLOC
			PA0->PA0_STATUS:= "C"
			PA0->PA0_SITUAC:= _STD
			PA0->PA0_AR		:=M->PA0_AR
			MsUnlock()
		End If
		
		
		DbSelectArea("PA1")
		DbSetOrder(1)
		For _i := 1 To Len(aCols)
			
			DbGoTop()
			DbSeek(xFilial("PA1")+M->PA0_OS+aCols[_i,nPosItem])
			
			If Found()
				
				RecLock("PA1",.F.)
				If !aCols[_i,nPosDel] .and. !Empty(aCols[_i,nPosProd])
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Grava alterações nos itens da solicitação de atendimento³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					PA1->PA1_PRODUT	:= aCols[_i,nPosProd]
					PA1->PA1_DESCRI	:= aCols[_i,nPosDesc]
					PA1->PA1_QUANT	:= aCols[_i,nPosQtd ]
					PA1->PA1_PRCUNI	:= aCols[_i,nPosPrc ]
					PA1->PA1_VALOR	:= aCols[_i,nPosTot ]
					PA1->PA1_CNPJ	:= aCols[_i,nPosCnpj]
					PA1->PA1_TES	:= "903"
					PA1->PA1_FATURA	:= aCols[_i,nPosFat ]
					PA1->PA1_PEDIDO	:= aCols[_i,nPosPed ]
					PA1->PA1_VOUCHE 	:= aCols[_i,nPosLoc ]
//					PA1->PA1_GERADO	:= aCols[_i,nPosGer ]
					
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Deleta os itens deletados na alteração da solicitação de atendimento³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					DbDelete()
				End If
				MsUnlock()
			Else
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Grava novos itens da solicitação de atendimento³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !aCols[_i,nPosDel] .and. !Empty(aCols[_i,nPosProd])
					RecLock("PA1",.T.)
					
					PA1->PA1_FILIAL := xFilial("PA1")
					PA1->PA1_OS     := M->PA0_OS
					PA1->PA1_ITEM   := aCols[_i,nPosItem]
					PA1->PA1_PRODUT	:= aCols[_i,nPosProd]
					PA1->PA1_DESCRI	:= aCols[_i,nPosDesc]
					PA1->PA1_QUANT	:= aCols[_i,nPosQtd ]
					PA1->PA1_PRCUNI	:= aCols[_i,nPosPrc ]
					PA1->PA1_VALOR	:= aCols[_i,nPosTot ]
					PA1->PA1_CNPJ	:= aCols[_i,nPosCnpj]
					PA1->PA1_TES	:= "903"
					PA1->PA1_FATURA	:= aCols[_i,nPosFat ]
					PA1->PA1_PEDIDO	:= aCols[_i,nPosPed ]
					PA1->PA1_VOUCHE 	:= aCols[_i,nPosLoc ]
//					PA1->PA1_GERADO	:= aCols[_i,nPosGer ]
					
					MsUnlock()
				End If
			End If
		Next _i
		
		If _ClrAgen
			Alert("A data do agendamento foi alterada, agendar tecnicos novamente")
			/*
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Deleta agenda da solicitação de atendimento³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			*/
			
			DbSelectArea("PA2")
			DbSetOrder(3)
			DbSeek(xFilial("PA2")+M->PA0_OS)
			If Found()
				Do While !Eof("PA2") .and. PA2->PA2_NUMOS == M->PA0_OS
					RecLock("PA2",.F.)
					DbDelete()
					MsUnlock()
					DbSkip()
				End Do
			End If
			U_CSF01AGE(M->PA0_DTAGEN,M->PA0_HRAGEN)
		Else
			If Aviso("Agenda","Deseja alterar agendamento?",{"Sim","Não"},,) == 1
				DbSelectArea("PA2")
				DbSetOrder(3)
				DbSeek(xFilial("PA2")+M->PA0_OS)
				If Found()
					Do While !Eof("PA2") .and. PA2->PA2_NUMOS == M->PA0_OS
						RecLock("PA2",.F.)
						DbDelete()
						MsUnlock()
						DbSkip()
					End Do
				End If
				U_CSF01AGE(M->PA0_DTAGEN,M->PA0_HRAGEN)
			End If
		End If
		
	End If
Else
	Alert("Pedido Fechado")
End If

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSF01FEC  ºAutor  ³Rodrigo Seiti Mitaniº Data ³  20/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fechamento das solicitações de atendimento                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSF01FEC()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aTela[0][0]
Private aGets[0]
Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:= 0
_nOpca := 0

If PA0->PA0_STATUS == 'A' .and. PA0->PA0_SITUAC == 'L'
	
	dbSelectArea("PA0")
	dbSetOrder(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa desta forma para criar uma nova instancia de variaveis private ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RegToMemory( "PA0", .F., .F. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa aCols   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("PA1")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "PA1") )
		If X3USO(SX3->X3_USADO)
			nUsado++
			Aadd(aHeader,{ TRIM(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea("TRB")
	End If
	

BeginSql Alias "TRB"
%noparser%
Select * From %Table:PA1% PA1
Where PA1_OS = %Exp:PA0->PA0_OS% and PA1_FILIAL = %Exp:xFilial("PA1")%
and PA1.%NotDel%
EndSql

	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega o acols com as informações do registro posicionado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
	Do While !Eof("TRB")
		AADD(aCols,Array(Len(aHeader)+1))
		For nCntFor:=1 To Len(aHeader)
			If ( aHeader[nCntFor,10] <>  "V" )
				aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
			Else
				aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
			EndIf
		Next nCntFor
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		DbSkip()
	End Do
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona os objetos na tela
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
	{{003,033,160,200,240,263}} )
	
	DEFINE MSDIALOG oDlg TITLE "Solicitação de Atendimento" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	EnChoice( "PA0", ,4, , , , , aPosObj[1],,3,,,)
	
	oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],4    ,         ,        ,"+PA1_ITEM",.T.     ,      ,       ,      , 50 ,        ,         ,,      ,    )
	//  METHOD          New(nT          ,nL          ,          nB,         nR ,nOpc ,cLinhaOk ,cTudoOk ,cIniCpos ,lDeleta ,aAlter,nFreeze,lEmpty,nMax,cFieldOk,cSuperDel,,cDelOk,oWnd)
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||_nOpcA:=1,oDlg:End()},{||oDlg:End()},,)
	
	If _nOpcA == 1
		
		/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Localiza a posição dos campos no acols³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		nPosDel   := Len( aHeader ) + 1
		nPosItem  := GDFieldPos( "PA1_ITEM"   )
		nPosProd  := GDFieldPos( "PA1_PRODUT" )
		nPosDesc  := GDFieldPos( "PA1_DESCRI" )
		nPosQtd   := GDFieldPos( "PA1_QUANT"  )
		nPosPrc   := GDFieldPos( "PA1_PRCUNI" )
		nPosTot   := GDFieldPos( "PA1_VALOR"  )
		nPosCnpj  := GDFieldPos( "PA1_CNPJ"   )
		//nPosTes   := GDFieldPos( "PA1_TES"    )
		nPosFat   := GDFieldPos( "PA1_FATURA" )
		nPosPed   := GDFieldPos( "PA1_PEDIDO" )
		nPosLoc   := GDFieldPos( "PA1_VOUCHE"  )
//		nPosGer   := GDFieldPos( "PA1_GERADO" )	
		
		_STD := 'L'

		
		
		DbSelectArea("PA1")
		DbSetOrder(1)
		For _i := 1 To Len(aCols)
			
			DbGoTop()
			DbSeek(xFilial("PA1")+M->PA0_OS+aCols[_i,nPosItem])

			If Found()
				
				RecLock("PA1",.F.)
				If !aCols[_i,nPosDel] .and. !Empty(aCols[_i,nPosProd])
					/*
					DbSelectArea("SB1")
					DbSetOrder(1)
					DbGoTop()
					DbSeek(xFilial("SB1")+aCols[_i,nPosProd])


					aItensTMDE :={}  
					aadd(aItensTMDE,{"D3_TM"     ,GETMV("MV_XTMARDE") 							,NIL})
					aadd(aItensTMDE,{"D3_COD"    ,aCols[_i,nPosProd] 							,NIL})
					aadd(aItensTMDE,{"D3_UM"     ,SB1->B1_UM        							,NIL})
					aadd(aItensTMDE,{"D3_LOCAL"  ,GETMV("MV_XARZFAT")							,NIL})
					aadd(aItensTMDE,{"D3_QUANT"  ,aCols[_i,nPosQtd ]							,NIL})
					aadd(aItensTMDE,{"D3_EMISSAO",dDataBase          							,NIL})
					aadd(aItensTMDE,{"D3_DOC"    ,""           									,NIL})
					aadd(aItensTMDE,{"D3_GRUPO"  ,SB1->B1_GRUPO									,NIL})
					aadd(aItensTMDE,{"D3_QTSEGUM",CriaVar("D3_QTSEGUM",.F.)					,NIL})
					aadd(aItensTMDE,{"D3_SEGUM"  ,SB1->B1_SEGUM									,NIL})
					aadd(aItensTMDE,{"D3_TIPO"   ,SB1->B1_TIPO									,NIL})
					aadd(aItensTMDE,{"D3_CONTA"  ,SB1->B1_CONTA									,NIL})
					aadd(aItensTMDE,{"D3_USUARIO",SubStr(cUsuario,7,15) 						,NIL})
					aadd(aItensTMDE,{"D3_NUMLOTE",CriaVar("D3_NUMLOTE",.F.)					,NIL})
					aadd(aItensTMDE,{"D3_LOTECTL",CriaVar("D3_LOTECTL",.F.)				 	,NIL})
					aadd(aItensTMDE,{"D3_DTVALID",CriaVar("D3_DTVALID",.F.)					,NIL})
					lMsErroAuto := .F.
					msExecAuto({|x| mata240(x)},aItensTMDE)	 	   	 	   
					If lMsErroAuto            
						MostraErro()
					EndIf  

					aItensTMDE :={}  
					aadd(aItensTMDE,{"D3_TM"     ,GETMV("MV_XTMARRE") 							,NIL})
					aadd(aItensTMDE,{"D3_COD"    ,aCols[_i,nPosProd] 							,NIL})
					aadd(aItensTMDE,{"D3_UM"     ,SB1->B1_UM        							,NIL})
					aadd(aItensTMDE,{"D3_LOCAL"  ,aCols[_i,nPosLoc]								,NIL})
					aadd(aItensTMDE,{"D3_QUANT"  ,aCols[_i,nPosQtd ]							,NIL})
					aadd(aItensTMDE,{"D3_EMISSAO",dDataBase          							,NIL})
					aadd(aItensTMDE,{"D3_DOC"    ,""           									,NIL})
					aadd(aItensTMDE,{"D3_GRUPO"  ,SB1->B1_GRUPO									,NIL})
					aadd(aItensTMDE,{"D3_QTSEGUM",CriaVar("D3_QTSEGUM",.F.)					,NIL})
					aadd(aItensTMDE,{"D3_SEGUM"  ,SB1->B1_SEGUM									,NIL})
					aadd(aItensTMDE,{"D3_TIPO"   ,SB1->B1_TIPO									,NIL})
					aadd(aItensTMDE,{"D3_CONTA"  ,SB1->B1_CONTA									,NIL})
					aadd(aItensTMDE,{"D3_USUARIO",SubStr(cUsuario,7,15) 						,NIL})
					aadd(aItensTMDE,{"D3_NUMLOTE",CriaVar("D3_NUMLOTE",.F.)					,NIL})
					aadd(aItensTMDE,{"D3_LOTECTL",CriaVar("D3_LOTECTL",.F.)				 	,NIL})
					aadd(aItensTMDE,{"D3_DTVALID",CriaVar("D3_DTVALID",.F.)					,NIL})
					lMsErroAuto := .F.
					msExecAuto({|x| mata240(x)},aItensTMDE)	 	   	 	   
					If lMsErroAuto            
						MostraErro()
					EndIf  
               */
					If PA1->PA1_FATURA <> aCols[_i,nPosFat ]
						
						If aCols[_i,nPosFat ]  == 'N'
							_STD := 'B'
						End If
						
					End If
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Grava alterações nos itens da solicitação de atendimento³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					PA1->PA1_PRODUT	:= aCols[_i,nPosProd]
					PA1->PA1_DESCRI	:= aCols[_i,nPosDesc]
					PA1->PA1_QUANT		:= aCols[_i,nPosQtd ]
					PA1->PA1_PRCUNI	:= aCols[_i,nPosPrc ]
					PA1->PA1_VALOR		:= aCols[_i,nPosTot ]
					PA1->PA1_CNPJ		:= aCols[_i,nPosCnpj]
					PA1->PA1_TES		:= "903"
					PA1->PA1_FATURA	:= aCols[_i,nPosFat ]
					PA1->PA1_PEDIDO	:= aCols[_i,nPosPed ]
//					PA1->PA1_LOCAL 	:= aCols[_i,nPosLoc ]
//					PA1->PA1_GERADO	:= aCols[_i,nPosGer ]
					
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Deleta os itens deletados na alteração da solicitação de atendimento³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					DbDelete()
				End If
				MsUnlock()
			Else
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Grava novos itens da solicitação de atendimento³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !aCols[_i,nPosDel] .and. !Empty(aCols[_i,nPosProd])


					RecLock("PA1",.T.)
					
					If aCols[_i,nPosFat ]  == 'N'
						_STD := 'B'
					End If
					
					PA1->PA1_FILIAL := xFilial("PA1")
					PA1->PA1_OS     := M->PA0_OS
					PA1->PA1_ITEM   := aCols[_i,nPosItem]
					PA1->PA1_PRODUT	:= aCols[_i,nPosProd]
					PA1->PA1_DESCRI	:= aCols[_i,nPosDesc]
					PA1->PA1_QUANT	:= aCols[_i,nPosQtd ]
					PA1->PA1_PRCUNI	:= aCols[_i,nPosPrc ]
					PA1->PA1_VALOR	:= aCols[_i,nPosTot ]
					PA1->PA1_CNPJ	:= aCols[_i,nPosCnpj]
					PA1->PA1_TES	:= "903"
					PA1->PA1_FATURA	:= aCols[_i,nPosFat ]
					PA1->PA1_PEDIDO	:= aCols[_i,nPosPed ]
//					PA1->PA1_LOCAL 	:= aCols[_i,nPosLoc ]
//					PA1->PA1_GERADO	:= aCols[_i,nPosGer ]
					
					MsUnlock()
				End If
			End If
		Next _i
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Efetua a gravação da alterações realizados no cabeçalho da solicitação de atendimento³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		
		DbSelectArea("PA0")
		DbSetOrder(1)
		DbSeek(xFilial("PA0")+M->PA0_OS)
		If Found()
			RecLock("PA0",.F.)
			PA0->PA0_CLIFAT:= M->PA0_CLIFAT
			PA0->PA0_LOJAFA:= M->PA0_LOJAFA
			PA0->PA0_CLFTNM:= M->PA0_CLFTNM
			PA0->PA0_END   := M->PA0_END
			PA0->PA0_BAIRRO:= M->PA0_BAIRRO
			PA0->PA0_CEP   := M->PA0_CEP
			PA0->PA0_CIDADE:= M->PA0_CIDADE
			PA0->PA0_ESTADO:= M->PA0_ESTADO
			PA0->PA0_DDD   := M->PA0_DDD
			PA0->PA0_TEL   := M->PA0_TEL
			PA0->PA0_RAMAL := M->PA0_RAMAL
			PA0->PA0_CONDPA:= M->PA0_CONDPA
			//		PA0->PA0_NUMPED:= M->PA0_NUMPED
			PA0->PA0_PROJET:= M->PA0_PROJET
			PA0->PA0_HRAGEN:= M->PA0_HRAGEN
			PA0->PA0_TRANSP:= M->PA0_TRANSP
			PA0->PA0_CUSTRA:= M->PA0_CUSTRA
			PA0->PA0_HRCHEG:= M->PA0_HRCHEG
			PA0->PA0_HRINIC:= M->PA0_HRINIC
			PA0->PA0_HRTERM:= M->PA0_HRTERM
			PA0->PA0_REGIAO:= M->PA0_REGIAO
			PA0->PA0_DTAGEN:= M->PA0_DTAGEN
			PA0->PA0_TPSERV:= M->PA0_TPSERV
			PA0->PA0_OBS   := M->PA0_OBS
			PA0->PA0_DESLOC:= M->PA0_DESLOC
			PA0->PA0_STATUS:= "F"
			PA0->PA0_SITUAC:= _STD
			
			MsUnlock()
		End If
		
	End If
		lMsErroAuto := .F.
      
      If lMsErroAuto        
      	MostraErro()    
         Return
      EndIf  
	
Else
	Alert("Pedido Fechado/bloqueado/rejeitado")
End If

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSF01LEG  ºAutor  ³Rodrigo Seiti Mitaniº Data ³  20/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esta rotina monta uma dialog com a descricao das cores da   º±±
±±º          ³Mbrowse.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSF01LEG()
BrwLegenda("Solicitação de Atendimento","Solicitação de Atendimento",{	{ "BR_LARANJA","Aguardando confirmação"},;
{"ENABLE","Aberto/Liberado"},;
{"DISABLE","Aberto/Bloqueado"},;
{"BR_AMARELO","Aberto/Rejeitado"},;
{"BR_AZUL","Fechado/Liberado"},;
{"BR_MARROM","Fechado/Bloqueado"},;
{"BR_PRETO","Pedido de venda"}})
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSF01COF  ºAutor  ³Rodrigo Seiti Mitaniº Data ³  20/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Confirmação da solicitação de atendimento                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSF01COF()
If PA0->PA0_STATUS == 'C'
	If Aviso("Confirmação de atendimento","Atendimeto Confirmado?",{"Sim","Não"},,) == 1
		DbSelectArea("PA0")
		DbSetOrder(1)
		DbSeek(xFilial("PA0")+PA0->PA0_OS)
		If Found()
			RecLock("PA0",.F.)
			PA0->PA0_STATUS:= "A"
			MsUnlock()
		End If
	End If
Else
	Alert("Este atendimento não está pendente de confirmação.")
End If
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSF01PED  ºAutor  ³Rodrigo Seiti Mitaniº Data ³  20/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Confirmação da solicitação de atendimento                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
User Function CSF01PED()
ValidPerg("CSFPED")
Pergunte("CSFPED")

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea("TRB")
End If

BeginSql Alias "TRB"
Select  PA0_OS
From %Table:PA0% PA0, %Table:PA2% PA2 
Where PA0.%NotDel% and PA2.%NotDel%
and PA0_OS = PA2_NUMOS 
and PA0_OS Between %Exp:MV_PAR01% and %Exp:MV_PAR02%
and PA0_CLILOC Between %Exp:MV_PAR05% and %Exp:MV_PAR06%
and PA0_DTAGEN Between %Exp:DToS(MV_PAR07)% and %Exp:DToS(MV_PAR08)%
and PA2_CODTEC Between %Exp:MV_PAR03% and %Exp:MV_PAR04%
and PA0_STATUS = 'F' and  PA0_SITUAC = 'L'
EndSql

DbSelectArea("TRB")

ProcRegua( LastRec() )
DbGoTop()
Do While !Eof("TRB")

	_aItens	:= {}
	_aCab 	:= {}
	_ncount	:= 1
	_numped	:= GETSXENUM("SC5","C5_NUM")
	If Select("DET") > 0
		DbSelectArea("DET")
		DbCloseArea("DET")
	End If

BeginSql Alias "DET"
%NoParser%
Select * From %Table:PA1% PA1 Where PA1_OS = %Exp:TRB->PA0_OS%
and PA1.%NotDel%
EndSql


	DbSelectArea("DET")
	DbGoTop()
	Do While !Eof("DET")
		If TRB->PA1_FATURA == 'S'
			_aRet := {}
			aAdd( _aRet, {"C6_FILIAL"	, xFilial("SC6")											 								, NIL})
			aAdd( _aRet, {"C6_NUM"		, 	_numped													 								, NIL})
			aAdd( _aRet, {"C6_ITEM"		, StrZero(_ncount,2)									 	 								, NIL})
			aAdd( _aRet, {"C6_PRODUTO"	, DET->PA1_PRODUT											 								, NIL})
			aAdd( _aRet, {"C6_DESCRI"	, Posicione("SB1",1 ,xFilial("SB1") + DET->PA1_PRODUT,  "B1_DESC")		, NIL})
			aAdd( _aRet, {"C6_UM" 		, Posicione("SB1",1 ,xFilial("SB1") + DET->PA1_PRODUT,  "B1_UM") 		, NIL})
			aAdd( _aRet, {"C6_QTDVEN" 	, DET->PA1_QUANT 																			, NIL})
			aAdd( _aRet, {"C6_PRCVEN"	, DET->PA1_PRCUNI																			, NIL})
			aAdd( _aRet, {"C6_TES"		, DET->PA1_TES            										 						, "ALLWAYSTRUE()"})
			aAdd( _aRet, {"C6_PRUNIT"	, DET->PA1_PRCUNI																			, NIL})
			aAdd( _aRet, {"C6_VALOR"	, DET->PA1_VALOR   											 							, NIL})
			aAdd( _aRet, {"C6_COMIS1"	, 0											 												, NIL})
			aAdd( _aRet, {"C6_ENTREG"	, dDataBase													 								, NIL})
			aAdd( _aRet, {"C6_LOCAL"	, "00" 																						, "ALLWAYSTRUE()"})
			aAdd( _aRet, {"C6_QTDLIB"	, DET->PA1_QUANT																			, NIL})
			aAdd( _aItens, _aRet)
			
			_ncount:= _ncount + 1
		End If
		DbSelectArea("TRB")
		DbSkip()
	End Do
	
	If Select("CAB") > 0
		DbSelectArea("CAB")
		DbCloseArea("CAB")
	End If

BeginSql Alias "CAB"
%NoParser%
Select * From %Table:PA0% PA0 Where PA0_OS = %Exp:TRB->PA0_OS%
and PA0.%NotDel%
EndSql
	
	_aCab := {}
	aAdd( _aCab,{"C5_FILIAL"	, xFilial("SC5")		              														, NIL})
	aAdd( _aCab,{"C5_NUM"		, _numped				     																 	, NIL})
	aAdd( _aCab,{"C5_TIPO"		, "N"			    																			 	, NIL})
	aAdd( _aCab,{"C5_TIPOCLI"	, Posicione("SA1",1 ,xFilial("SA1") + CAB->PA0_CLIFAT + CAB->PA0_LOJAFA	, "A1_TIPO")	, NIL})
	aAdd( _aCab,{"C5_CLIENTE"	, CAB->PA0_CLIFAT		           														 	, NIL})
	aAdd( _aCab,{"C5_LOJACLI"	, CAB->PA0_LOJAFA		           															, NIL})
	aAdd( _aCab,{"C5_VEND1"  	, " "				  		                   												, "ALLWAYSTRUE()"})
	aAdd( _aCab,{"C5_CONDPAG"	, CAB->PA0_CONDPA			                    											, NIL})
	aAdd( _aCab,{"C5_TPFRETE"	, "F"									 															, NIL})
	aAdd( _aCab,{"C5_EMISSAO"	, dDATABASE      																   			, NIL})
	aAdd( _aCab,{"C5_MOEDA"  	, 1		     																	   			, NIL})
	aAdd( _aCab,{"C5_XNATURE" 	, "SA010001"		     																	 	, NIL})
	aAdd( _aCab,{"C5_VEND1" 	, "CC0001"		     																	  		, NIL})
	
	lMsHelpAuto := .t.
	lMsErroAuto := .f.
	
	MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCab,_aItens,3)
	
	If lMsErroAuto

		MostraErro()
	Else
	
		DbSelectArea("PA0")
		DbSetOrder(1)
		DbSeek(xFilial("PA0")+PA0->PA0_OS)
		If Found()
			RecLock("PA0",.F.)
			PA0->PA0_SITUAC := 'P'
			PA0->PA0_STATUS := 'P'
			MsUnlock()
		End If
	Alert("Pedido nº"+ _numped +"gerado com sucesso.")
	End If
Else
	Alert("Este atendimento não está liberado para faturamento.")
End If
DbSelectArea("TRB")
DbSkip()
EndDo()
Return(.T.)
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSF01AGE  ºAutor  ³Rodrigo Seiti Mitaniº Data ³  20/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Agendamento da solicitação de atendimento                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSF01AGE(_DATA,_HORA)


Private nUsado	:= " "
Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:= " "
Private _aVet	:= {}
_vetor 	:= {}
_op		:= " "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("AA1")


nUsado  := 0
aHeader := {}


DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("AA1_CODTEC")
AADD(aHeader,{TRIM(x3_titulo),x3_campo,x3_picture,15,0,"U_PPCP006(8)",x3_usado,x3_tipo,x3_arquivo,"V"})
DbSeek("AA1_NOMTEC")
AADD(aHeader,{TRIM(x3_titulo),x3_campo,x3_picture,x3_tamanho,x3_decimal,"U_PPCP006(1)",x3_usado,x3_tipo,x3_arquivo,x3_context})

aCols:={{CriaVar("AA1_CODTEC"),;
CriaVar("AA1_NOMTEC"),.f.}}


If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
End If


BeginSql Alias "BRT"
%noparser%
Select AA1_CODTEC,AA1_NOMTEC From %Table:AA1% AA1 Where AA1.%NotDel% and AA1_CODTEC
Not In(Select PA2_CODTEC From %Table:PA2% PA2 Where PA2.%NotDel% and
(%Exp:_DATA% <= PA2_DTFIM And %Exp:_HORA% <= PA2_HRFIM And %Exp:_DATA% >= PA2_DTINI And %Exp:_HORA% >= PA2_HRINI ))
EndSql

/*
Select AA1_CODTEC,AA1_NOMTEC From %Table:AA1% AA1 Where AA1.%NotDel% and AA1_CODTEC
Not In(Select PA2_CODTEC From %Table:PA2% PA2 Where PA2.%NotDel% and
(%Exp:_DATA% <= PA2_DTFIM And %Exp:_HORA% <= PA2_HRFIM And %Exp:_DATA% >= PA2_DTINI And %Exp:_HORA% >= PA2_HRINI ) Or
(%Exp:_DATA% <= PA2_DTFIM And %Exp:_HORA% <= PA2_HRFIM And %Exp:_DATA% >= PA2_DTINI And %Exp:_HORA% >= PA2_HRINI ))
*/

If !Empty(BRT->AA1_NOMTEC)
	
	DbSelectArea("BRT")
	
	DbGoTop()
	nCt:=0
	Do While !Eof()
		
		nCt := nCt + 1
		If nCt>1
			
			_aLinha := Aclone(Acols[nCt-1])
			AADD(Acols,_aLinha)
		Endif
		
		Acols[nCt,ASCAN(aHeader,{|aCampo| Trim(aCampo[2])=="AA1_CODTEC"})]  := BRT->AA1_CODTEC
		Acols[nCt,ASCAN(aHeader,{|aCampo| Trim(aCampo[2])=="AA1_NOMTEC"})]	:= BRT->AA1_NOMTEC
		Dbskip()
	Enddo
	
	@ 200,400 TO 440,780 Dialog libera Title OemToAnsi("Tecnicos Disponiveis")
	@ 10,10 TO 80,180 MULTILINE OBJECT oDLG2
	@ 90,10  Button("Agenda") Action Cons()
	@ 90,120 Button(" Sair ") Action Close(libera)
	Activate Dialog libera Centered
	
	
Else
	Alert("Não há agente disponivel para este agendamento")
End If

Return(.T.)

/*
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Posiciona no cadastro de tecnico para efetuar o agendamento º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
*/

Static Function Cons()

DbSelectArea("AA1")
DbSetOrder(1)
DbSeek(xFilial("AA1")+aCols[n,1])

If Found()
	U_CSF03AGE()
	n:=1
End If

Return()




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Cristian Gutierrez  º Data ³  17/01/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica a existencia das perguntas criando-as caso nao    º±±
±±º          ³ existam                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GeraInte()
Local aArea		:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSG1	:= SG1->(GetArea())
Local lRet		:= .T.       
Local cProdAtu	:= BuscaCols("PA1_PRODUT") 		// Codigo do produto atual (linha posicionada)
Local nQtdePed	:= BuscaCols("PA1_QUANT")			// Quantidade no item do pedido (linha posicionada)
Local aProdInt	:= {}
Local aProdInt2:= {}
Local nX			:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se o produto possui estrutura                                      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SG1")
dbSetOrder(1)
If	dbSeek(xFilial("SG1") + cProdAtu)
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso o produto atenda as necessidades verifica se o usuario quer a exploscao |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Aviso("Componentes do Kit","Deseja gerar linhas com os componentes do kit?",{"Ok","Não"}) == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada da funcao para geracao dos itens do pedido (PA)                      |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aProdInt	:= U_GeraItens(cProdAtu, nQtdePed)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada da funcao para geracao dos itens do pedido (PI's)                    |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aProdInt) > 0
			For nX := 1 to Len(aProdInt)
				aProdInt2	:= U_GeraItens(aProdInt[nX,1],aProdInt[nX,2])
			Next nX
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada da funcao para geracao dos itens do pedido (PI's)                    |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aProdInt2) > 0
			For nX := 1 to Len(aProdInt)
				U_GeraItens(aProdInt[nX,1],aProdInt[nX,2])
			Next nX
		EndIf
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna conteudo default para o linha ok e da refresh na getdados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RestArea(aAreaSB1)
RestArea(aAreaSG1)
RestArea(aArea)

oGetD:oBrowse:Refresh()       

Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraItens º Autor ³ Cristian Gutierrez º Data ³  13/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina auxiliar para geracao efetiva dos itens             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para o cliente Certisign                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GERAITENS(cProdAtu, nQtdePed)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Local aArea			:= GetArea()
//Local aAreaSB1		:= SB1->(GetArea())
//Local aAreaSF4		:= SF4->(GetArea())
//Local aAreaSA1		:= SA1->(GetArea())
Local aAreaSG1		:= SG1->(GetArea())
Local cQuery		:= ""
Local aProdInt		:= {}
//Local cAlmoxTer	:= AllTrim(GetMv("MV_XLOCTER"))
//Local cTesDev3		:= AllTrim(GetMv("MV_XTESD3"))
Local cProdAtu	:= BuscaCols("PA1_PRODUT") 		// Codigo do produto atual (linha posicionada)
Local nQtdePed	:= BuscaCols("PA1_QUANT")			// Quantidade no item do pedido (linha posicionada)
Local nValFat	:= BuscaCols("PA1_FATURA")			// Quantidade no item do pedido (linha posicionada)


Local nPosProd		:= aScan(aHeader, {|x|Alltrim(x[2]) == "PA1_PRODUT" 	})
Local nPosDescPro	:= aScan(aHeader, {|x|Alltrim(x[2]) == "PA1_DESCRI" 	})
//Local nPosUM		:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_UM"		 	})
Local nPosQtdVen	:= aScan(aHeader, {|x|Alltrim(x[2]) == "PA1_QUANT" 	})
Local nPosPrcVen	:= aScan(aHeader, {|x|Alltrim(x[2]) == "PA1_PRCUNI" 	})
Local nPosValor		:= aScan(aHeader, {|x|Alltrim(x[2]) == "PA1_VALOR"	 	})
Local nPosFat		:= aScan(aHeader, {|x|Alltrim(x[2]) == "PA1_FATURA"	 	})
Local nPosLocal	:= aScan(aHeader, {|x|Alltrim(x[2]) == "PA1_VOUCHE"	 	})    
/*
Local nPosTes		:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_TES"		})
Local nPosQtdLib	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_QTDLIB" 	})
Local nPosLocal	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_LOCAL"	 	})
Local nPosCf		:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_CF"		 	})
Local nPosEntreg	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_ENTREG" 	})
Local nPosNfOri	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_NFORI" 	})
Local nPosSeriOri	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_SERIORI" 	})
Local nPosItemori	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_ITEMORI" 	})
Local nPosIdentB6	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_IDENTB6" 	})
Local nPosLoteCtl	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_LOTECTL" 	})
Local nPosdtValid	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_DTVALID" 	})
Local nPosTpOp		:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_TPOP"	 	})
Local nPosNumOp	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_NUMOP"	 	})
Local nPosSegUm  	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_SEGUM"	 	})
Local nPosUnsVen 	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_UNSVEN" 	})
Local nPosClasFis	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_CLASFIS" 	})
Local nPosQtdLib2	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_QTDLIB2" 	})	
Local nPosItemOp	:= aScan(aHeader, {|x|Alltrim(x[2]) == "C6_ITEMOP" 	})                  
Local cEstSol		:= ""
Local cEstCli		:= ""
Local cCF			:= ""
Local cSitTrib		:= "" //Posicione("SF4",1,xFilial("SF4") + cTesDev3,"F4_SITTRIB")

*/
Local nPosDel		:= Len(aHeader) + 1 //Coluna de controle de delecao

Local nX				:= Len(aCols) 			//Quantidade de itens no pedido
Local nY				:= 0
Local nZ				:= 0

Local nQtdDev		:= 0
Local nPrcVen		:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Loop principal da rotina na estrutura do produto para geracao dos itens no pedido |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols[n,(Len(aHeader)+1)] := .T.
dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial("SG1") + cProdAtu)

While !(SG1->(EOF())) .and. SG1->G1_COD == cProdAtu

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se esta na linha do produto acabado na rotina                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	If SG1->G1_COD == cProdAtu
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o item atual na estrutura  for o produto que originou a rotina descarta...     |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		SG1->(dbSkip())

	EndIf
	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para realizar recursividade na rotina para considerar PI's             |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	dbSelectArea("SG1")
	dbSetOrder(1)
	If	dbSeek(xFilial("SG1") + SG1->G1_COMP)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Proporcionaliza a quantidade do produto intermediario, conforme pedido de venda.  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD(aProdInt, {TMP->D3_COD, (SG1->G1_QUANT * nQtdePed)})	
	EndIf
	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se a ultima linha esta em branco ou gera nova linha no pedido            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   _PLINE := GetAdvFVal("SB1","B1_EXPLINE",xFilial("SB1")+SG1->G1_COMP,1,)
	If _PLINE == 'S'
	For _i := 1 To (SG1->G1_QUANT * nQtdePed)

	If !(Empty(Alltrim(aCols[nX,nPosProd])))
		CriaCols()
		nX	:= Len(aCols) //Regrava a quantidade atual de itens no pedido...
	EndIf
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula Quantidade a ser devolvida                                                |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	nQtdeDev	:= SG1->G1_QUANT * nQtdePed
//	nQtdeDev	:= SG1->G1_QUANT / nQtdePed

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Alimenta posicoes com conteudos conforme arquivo componente do kit                |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1") + SG1->G1_COMP)
	
	aCols[nX, nPosProd]		:= SB1->B1_COD
	aCols[nX, nPosDescProd]	:= SB1->B1_DESC
//	aCols[nX, nPosUM]		:= SB1->B1_UM
	aCols[nX, nPosQtdVen]	:= 1
	aCols[nX, nPosPrcVen]	:= nPrcVen
	aCols[nX, nPosValor]	:= Round(1 * nPrcVen,2)
	aCols[nX, nPosFat]		:= nValFat
Next _i	
Else
	nQtdeDev	:= SG1->G1_QUANT * nQtdePed

	If !(Empty(Alltrim(aCols[nX,nPosProd])))
		CriaCols()
		nX	:= Len(aCols) //Regrava a quantidade atual de itens no pedido...
	EndIf
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula Quantidade a ser devolvida                                                |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	nQtdeDev	:= SG1->G1_QUANT * nQtdePed
//	nQtdeDev	:= SG1->G1_QUANT / nQtdePed

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Alimenta posicoes com conteudos conforme arquivo componente do kit                |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1") + SG1->G1_COMP)
	
	aCols[nX, nPosProd]		:= SB1->B1_COD
	aCols[nX, nPosDescProd]	:= SB1->B1_DESC
//	aCols[nX, nPosUM]		:= SB1->B1_UM
	aCols[nX, nPosQtdVen]	:= nQtdeDev
	aCols[nX, nPosPrcVen]	:= nPrcVen
	aCols[nX, nPosValor]	:= Round(nQtdeDev * nPrcVen,2)
	aCols[nX, nPosFat]		:= nValFat

/*
	aCols[nX, nPosTes]		:= ""
	aCols[nX, nPosQtdLib]	:= nQtdeDev
	aCols[nX, nPosLocal]	:= ""
	aCols[nX, nPosNumOp]	:= ""
	aCols[nX, nPosItemOp]	:= ""
	aCols[nX, nPosSegUm]	:= SB1->B1_SEGUM
	aCols[nX, nPosUnsVen]	:= Iif(SB1->B1_TIPCONV == "D",nQtdeDev / SB1->B1_CONV,nQtdeDev * SB1->B1_CONV)
	aCols[nX, nPosClasFis]	:= AllTrim(SB1->B1_ORIGEM) + AllTrim(cSitTrib)
	aCols[nX, nPosQtdLib2]	:= 0
	aCols[nX, nPosEntreg]	:= dDataBase
	aCols[nX, nPosNfOri]	:= ""
	aCols[nX, nPosSeriOri]	:= ""
	aCols[nX, nPosIdentB6]	:= ""
	aCols[nX, nPosLoteCtl]	:= ""
	aCols[nX, nPosDtValid]	:= ""
	aCols[nX, nPosTpOp]		:= ""                             
	aCols[nX, nPosxOp]		:= ""
*/	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera o codigo fiscal para o item conforme tipo de operacao                        |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    /*
	cEstSol	:= SM0->M0_ESTCOB
	cEstCli	:= Posicione("SA1", 1, xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI, "A1_EST") //Estes pedidos sempre são para o cliente, por isso nao verificada a necessidade de se utilizar o fornecedor
	cCF		:= Posicione("SF4", 1, xFilial("SF4") + cTesDev3, "F4_CF")
	
	If cEstCli == "EX"
		cCF	:= "7" + Substr(cCF,2,3)
		
	ElseIf cEstCli == cEstSol
		cCF	:= "5" + Substr(cCF,2,3)
		
	Else
		cCF	:= "6" + Substr(cCF,2,3)
	EndIf
	aCols[nX, nPosCF]			:= cCF
	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Salta registro no temporario e retorna loop principal...                          |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
End If
	SG1->(dbSkip())

EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura areas e sai da rotina                                                    |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
RestArea(aAreaSB1)
RestArea(aAreaSF4)
RestArea(aAreaSB6)
RestArea(aAreaSC2)
RestArea(aAreaSA1)
RestArea(aAreaSD1)
RestArea(aAreaSG1)
RestArea(aAreaSD3)
RestArea(aArea)
*/
Return(aProdInt)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaCols  º Autor ³ Cristian Gutierrez º Data ³  26/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Gera linha em branco no aCols para gravacao dos itens novos º±±
±±º          ³no pedido de vendas                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para o cliente Solucia                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CriaCols
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPosItem		:= aScan(aHeader, {|x|Alltrim(x[2]) == "PA1_ITEM"	 	})
Local nX			:= Len(aHeader) + 1 //quantidade de campos na linha (cabecalho)
Local nY			:= Len(aCols) + 1   //quantidade de linhas no pedido + 1 para nova linha
Local nZ			:= 0
Local nW			:= 0
Local nDif			:= 0
Local cNumItem		:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao de linha em branco no aCols para gravacao dos dados                       |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aCols, Array(nX))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimenta posicoes com conteudos conforme inicializadores padrao dos campos        |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nZ := 1 to (nX - 1)
	aCols[nY,nZ] := CriaVar(aHeader[nZ,2],.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria numero do item para o item novo do pedido                                    |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nZ	== nPosItem
		If nY <= 99
			aCols[nY,nZ] := StrZero(nY,4)
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamento esquisito porem necessario para garantir o numero alfa com dois digitos|
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nDif 		:= nY - 99
			cNumItem := "9999"
			For nW := 1 to nDif
				cNumItem := Soma1(cNumItem)
			Next nW
			aCols[nY,nZ] := cNumItem
		EndIf
	EndIf
Next nZ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimenta controle de deletados no aCols                                           |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols[nY,nX] := .F.

Return
