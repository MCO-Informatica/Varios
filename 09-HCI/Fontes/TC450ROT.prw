#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TC450ROT  ºAutor  ³ROBSON BUENO        º Data ³  24/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada PARA LIQUIDACAO EM MASSA DE OS             º±±
±±º          ³Inclui Botoes Socios e Documentos no menu da rotina         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TC450ROT()
local aRet := {}

aadd(aRet, {"Bx.Sequenc."	    ,"U_TC450RO1()" , 0 , 6})
aadd(aRet, {"Cancela OS"	    ,"U_TC450RO2()" , 0 , 7})
aadd(aRet, {"Efetivar Pre OS"	,"U_TC450RO3" , 0 , 3})

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TC450R01  ºAutor  ³ROBSON BUENO        º Data ³  24/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³TRATAMENTO PARA ROTINA DE LIQUIDACAO EM MASSA               º±±
±±º          ³Inclui Botoes Socios e Documentos no menu da rotina         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TC450RO1()

Local oDlgl
Local cOsi :=Space(6)
Local cOsf :=Space(6)

@ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("BAIXA DE ORDEM DE SERVICO")
@ 003,008 To 85,200 Title OemToAnsi("Digite a Faixa de Movimentacao?")

@ 015,015 Say OemToAnsi("Inicio:") OF Odlgl PIXEL
@ 015,045 msget cOsi Picture "@!" SIZE 60,10 OF Odlgl PIXEL
@ 035,015 Say OemToAnsi("Fim:") OF Odlgl PIXEL
@ 035,045 msget cOsf Picture "@!" SIZE 60,10 OF Odlgl PIXEL
@ 055,030 BMPBUTTON TYPE 1 ACTION OkProc(odlg1,cosi,cosf)
@ 055,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)

Activate Dialog Odlg1 CENTER


Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OkProc    ºAutor  ³Robson Bueno        º Data ³ 18/04/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento no banco de dados da acao solicitada e confir º±±
±±º          ³mada                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³HCI                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OkProc(odlg1,cosi,cosf)
Local cAliasSCP := GetArea()
Local aArea     := (GetArea())
Local cReg:=Space(6)
Local lContinue := .T.

If MsgYesNo("Esta rotina processa a baixa de todas as Ordens de Servico, inclusive as pendencias de amarracoes com PV, dentro da faixa estipulada. Deseja Processar?")
	for nx=val(cOsi) to val(cOsf)
		IF LEN(ALLTRIM(STR(NX)))>5
			cReg:=str(nx)
		else
			cReg:="0"+ALLTRIM(STR(NX))
		ENDIF
		dbSelectArea("AB6")
		DbSetOrder(1)
		if MsSeek(xFilial("AB6")+cReg)
			if AB6->AB6_XPREOS = '1'
				lContinue := .F.
			else
				Reclock("AB6",.F.)
	  			AB6->AB6_STATUS:="E"
				MSUnlock()
			endif
		ENDIF
		if lContinue
			dbSelectArea("AB7")
			DbSetOrder(1)
			if MsSeek(xFilial("AB7")+cReg)
				Reclock("AB7",.F.)
				AB7->AB7_TIPO:="5"
				MSUnlock()
			endif
			dbSelectArea("SZK")
			DbSetOrder(1)
			if MsSeek(xFilial("SZK")+"OS"+cReg)
				Reclock("SZK",.F.)
				SZK->ZK_DT_BX  :=DATE()
				SZK->ZK_QTS    := 0
				SZK->ZK_STATUS :="4"
				MSUnlock()
			ENDIF
			dbSelectArea("SZK")
			DbSetOrder(4)
			if MsSeek(xFilial("SZK")+"OS"+cReg)
				Reclock("SZK",.F.)
				SZK->ZK_DT_BX  :=DATE()
				SZK->ZK_QTS    := 0
				SZK->ZK_STATUS :="4"
				MSUnlock()
			ENDIF
		endif
	next
endif
Close(Odlg1)
RestArea(cAliasSCP)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Finaliza  ºAutor  ³Robson Bueno        º Data ³ 18/04/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Finalizacao do Objeto                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³HCI                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Finaliza(Odlg1)

Close(Odlg1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TC450R01  ºAutor  ³ROBSON BUENO        º Data ³  24/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³TRATAMENTO PARA ROTINA CANCELAMENTO DE OS                   º±±
±±º          ³Inclui Botoes Socios e Documentos no menu da rotina         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TC450RO2()

// DECLARACOES

// CANCELAMENTO DE PV

// CANCELAMENTO DE OP

// CANCELAMENTO DA OS

// CANCELAMENTO DA AMARRACAO OSXPV



Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TC450R03  ºAutor  ³Alexandre Circenis  º Data ³  26/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Afetivação da Pre OS para OS                                º±±
±±º          ³Informado os Campos que estão faltando         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TC450RO3(cAlias,nReg,nOpcx)

Local nUsado	:= 0
Local nCntFor2	:= 0
Local nOpcA		:= 0
Local aArea		:= { Alias(), IndexOrd() , Recno() }
Local uCampo	:= ""
Local aAux		:= {}
Local aTravas	:= {}
Local lTravas	:= .T.
Local nPosItem	:= 0
Local nPosSubI  := 0
Local oGetD		:= Nil
Local lGrava	:= .T.
Local lBlockRet	:= Nil
Local aObjects	:= {}
Local aPosObj	:= {}
Local aSizeAut	:= {}
Local aPosGet	:= {}
Local nSaveSX8	:= GetSX8Len()
Local nCntFor	:= 0
Local n1		:= 0				//Total Geral
Local n2		:= 0				//Total Cliente
Local n3		:= 0				//Total Fabricante
Local lHasLocEquip := ( FindFunction('At800FechOs') .And. AliasInDic('TEW') )

Private aTela		:= {}
Private aGets		:= {}
Private aHeader		:= {}
Private aHeaderAB8	:= {}
Private aHeaderAB7	:= {}
Private aCols		:= {}
Private aColsAB8	:= {}
Private nOpcF4		:= nOpcX

If aRotina == Nil
	aRotina := MenuDef()
EndIf

if AB6->AB6_XPREOS <> '1'
	Alert("Somente Pre Ordem de Servicos podem ser efetivadas")
	Return .F.
endif

//+----------------------------------------------------------+
//¦Se existir funcionalidade de entrega e montagem e o campo ¦
//¦que indica que foi criado pelo m=dulo de Controle de Lojas¦
//¦estiver preenchido, npo permite a alteratpo da OS.        ¦
//+----------------------------------------------------------+
If FindFunction("Lj7HasDtEM") .And. Lj7HasDtEM()
	If !Empty(AB6->AB6_NUMLOJ)
		Alert( "Não é possível alterar essa ordem de serviço pois ela foi criada pelo módulo 'Controle de Lojas'" )
		Return .F.
	EndIf
EndIf

//+--------------------------------------------------------------+
//¦ Inicializa as Variaveis da Enchoice                          ¦
//+--------------------------------------------------------------+
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("AB6")
While ( !Eof() .And. SX3->X3_ARQUIVO == "AB6" )
	uCampo := SX3->X3_CAMPO
	If ( SX3->X3_CONTEXT == "V" )
		M->&(uCampo) := CriaVar(uCampo,.T.)
	Else
		M->&(uCampo) := AB6->(FieldGet(FieldPos(uCampo)))
	EndIf
	DbSelectArea("SX3")
	DbSkip()
EndDo

//+------------------------------------------------------------------------+
//¦Trava Registros                                                         ¦
//+------------------------------------------------------------------------+
If ( !AtTravaReg("AB6", aTravas) )
	lTravas := .F.
Endif

//+--------------------------------------------------------------+
//¦ Monta aHeader                                                ¦
//+--------------------------------------------------------------+
AT450Monta()

nPosSubI  := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_SUBITE"})

//+--------------------------------------------------------------+
//¦ Monta aCols                                                  ¦
//+--------------------------------------------------------------+
aHeader  := aClone(aHeaderAB7)
nUsado   := Len(aHeader)
nPosItem := aScan(aHeaderAB7,{|x| AllTrim(x[2])=="AB7_ITEM"})
DbSelectArea("AB7")
DbSetOrder(1)
DbSeek(xFilial("AB7")+AB6->AB6_NUMOS)
While ( !Eof() .And. xFilial("AB7")    == AB7->AB7_FILIAL .And.;
	AB6->AB6_NUMOS == AB7->AB7_NUMOS )
	If ( !AtTravaReg("AB7", aTravas) )
		lTravas := .F.
	Endif
	
	aAdd(aCols,Array(nUsado+1))
	For nCntFor := 1 To nUsado
		If IsHeadRec(aHeader[nCntFor][2])
			aCols[Len(aCols)][nCntFor] := AB7->(RecNo())
		Elseif IsHeadAlias(aHeader[nCntFor][2])
			aCols[Len(aCols)][nCntFor] := "AB7"
		Elseif ( aHeader[nCntFor][10] <> "V" )
			aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
		Else
			aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
		EndIf
	Next nCntFor
	aCols[Len(aCols)][nUsado+1] := .F.
	aAux := {}
	DbSelectArea("AB8")
	DbSetOrder(1)
	If ( DbSeek(xFilial("AB8")+AB6->AB6_NUMOS+AB7->AB7_ITEM) )
		While ( !Eof() .And. xFilial("AB8") == AB8->AB8_FILIAL .And.;
			M->AB6_NUMOS   == AB8->AB8_NUMOS .And.;
			AB7->AB7_ITEM== AB8->AB8_ITEM )
			If ( !AtTravaReg("AB8", aTravas) )
				lTravas := .F.
			Endif
			
			aAdd(aAux,Array(Len(aHeaderAB8)+1))
			For nCntFor := 1 To Len(aHeaderAB8)
				If IsHeadRec(aHeaderAB8[nCntFor][2])
					aAux[Len(aAux)][nCntFor] := AB8->(RecNo())
				Elseif IsHeadAlias(aHeaderAB8[nCntFor][2])
					aAux[Len(aAux)][nCntFor] := "AB8"
				Elseif ( aHeaderAB8[nCntFor][10] <> "V" )
					aAux[Len(aAux)][nCntFor] := FieldGet(FieldPos(aHeaderAB8[nCntFor][2]))
				Else
					aAux[Len(aAux)][nCntFor] := CriaVar(aHeaderAB8[nCntFor][2])
				EndIf
			Next nCntFor
			aAux[Len(aAux)][Len(aHeaderAB8)+1] := .F.
			DbSelectArea("AB8")
			DbSkip()
		EndDo
		aAdd(aColsAB8,aClone(aAux))
	Else
		aAdd(aAux,Array(Len(aHeaderAB8)+1))
		For nCntFor := 1 To Len(aHeaderAB8)
			If IsHeadRec(aHeaderAB8[nCntFor][2])
				aAux[Len(aAux)][nCntFor] := 0
			Elseif IsHeadAlias(aHeaderAB8[nCntFor][2])
				aAux[Len(aAux)][nCntFor] := "AB8"
			Else
				aAux[Len(aAux)][nCntFor] := CriaVar(aHeaderAB8[nCntFor][2])
			Endif
		Next nCntFor
		aAux[Len(aAux)][nPosSubI] := "01"
		aAux[Len(aAux)][Len(aHeaderAB8)+1] := .F.
		aAdd(aColsAB8,aClone(aAux))
	EndIf
	DbSelectArea("AB7")
	DbSkip()
EndDo

//+--------------------------------------------------------------+
//¦ Posiciona o cliente                                          ¦
//+--------------------------------------------------------------+
SA1->( DbSetOrder( 1 ) )
SA1->( DbSeek( xFilial( "SA1" ) + M->AB6_CODCLI + M->AB6_LOJA ) )

//+------------------+
//¦ Atualiza picture ¦
//+------------------+
cPictureTot	:= PesqPict("AB8","AB8_TOTAL",14,M->AB6_MOEDA)

If ( lTravas )
	If Type("lAt450Auto")=="U" .Or. !lAt450Auto
		
		aSizeAut := MsAdvSize()
		
		//+--------------------------------------------------------------+
		//¦ Habilita a Tecla F4                                          ¦
		//+--------------------------------------------------------------+
		SetKey(VK_F4,{||AT450F4(oGetD)})
		
		aObjects := {}
		aAdd( aObjects, { 315,  70, .T., .t. } )
		aAdd( aObjects, { 100, 100, .t., .t. } )
		aAdd( aObjects, { 100,   7, .t., .f. } )
		aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )
		
		//+------------------------------------------------------------------------+
		//¦Monta tela de entrada                                                   ¦
		//+------------------------------------------------------------------------+
		DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] PIXEL
		
		// DEFINE MSDIALOG oDlg TITLE CADASTRO From 9,0 to 28,80
		EnChoice( "AB6" ,nReg,nOpcx,,,,,aPosObj[1],,3,,,,,,.T.)
		oGetD := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"AT450LinOk","AT450TudOk","+AB7_ITEM",.T.,,,,999)
		
		nLinIni := aPosObj[3,1]
		
		aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],310,;
		{{005,065,105,165,205,265}} )
		
		@ nLinIni,aPosGet[1,1] SAY "Total: " SIZE 60,09 OF oDlg PIXEL //
		@ nLinIni,aPosGet[1,2] SAY oSay1 VAR Transform(n1, cPictureTot) SIZE 40,09 OF oDlg PIXEL
		@ nLinIni,aPosGet[1,3] SAY "Total do Cliente: " SIZE 60,09 OF oDlg PIXEL //
		@ nLinIni,aPosGet[1,4] SAY oSay2 VAR Transform(n2, cPictureTot) SIZE 40,09 OF oDlg PIXEL
		@ nLinIni,aPosGet[1,5] SAY "Total do Fabricante: " SIZE 60,09 OF oDlg PIXEL //
		@ nLinIni,aPosGet[1,6] SAY oSay3 VAR Transform(n3, cPictureTot) SIZE 40,09 OF oDlg PIXEL
		oDlg:Cargo := {|n1,n2,n3| 	oSay1:SetText( Transform(n1, cPictureTot) ),;
		oSay2:SetText( Transform(n2, cPictureTot) ),;
		oSay3:SetText( Transform(n3, cPictureTot) ) }
		At450Total(oDlg,.F.)
		ACTIVATE MSDIALOG oDlg ON INIT AT450Bar(oDlg,{||nOpca:=1,INCLUI:=.F.,if(oGetD:TudoOk().And.Obrigatorio(aGets,aTela),(INCLUI:=.T.,oDlg:End()),(INCLUI:=.T.,nOpca:=0))},{||oDlg:End()},nOpcx,oGetD)
		//+--------------------------------------------------------------+
		//¦ Desabilita a Tecla F4                                        ¦
		//+--------------------------------------------------------------+
		SetKey(VK_F4,Nil)
	Else
		If EnchAuto(cAlias,aAutoCab,{|| Obrigatorio(aGets,aTela)}) .And.;
			MsGetDAuto(aAutoItens,"AT450LinOk",{|| AT450TudOk() },aAutoCab,aRotina[nOpcX][4]) .And. At450F4()
			nOpcA := 1
		EndIf
	EndIf
EndIf
If ( nOpcA == 1 )

	M->AB6_XPREOS := '2'	
	
	If lGrava
		Begin Transaction
		If ( AT450Grava(2)  )
			EvalTrigger()
			While ( GetSX8Len() > nSaveSx8 )
				ConfirmSX8()
			EndDo
			
			// Faz atualizatpo do movimento de locacao de equipamentos
			//If lHasLocEquip
				//lGrava := At450AtuEqloc()
			//EndIf
		EndIf
		End Transaction
	EndIf
EndIf
While ( GetSX8Len() > nSaveSx8 )
	RollBackSX8()
EndDo

//+----------------------------------------------+
//¦Efetua o destravamento dos registros travados.¦
//+----------------------------------------------+
AtDestravaReg( aTravas )

DbSelectArea(aArea[1])
DbSetOrder(aArea[2])
DbGoTo(aArea[3])
//Abandona o Laço de Inclusão
MbrChgLoop(.f.)

Return(.T.)

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funcao    ¦At450Total¦ Autor ¦ Vendas Clientes       ¦ Data ¦ 07.01.98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦Totalizacao da Janela                                       ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Retorno   ¦Nenhum                                                      ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦oDlg    : Objeto da Janela                                  ¦¦¦
¦¦¦          ¦nItem   : Item da Getdados Principal                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function AT450Total(oDlg,lF4)

Local nUsado	:= Len(aHeaderAb8)
Local nCntFor	:= 0
Local nCntFor2	:= 0
Local nPosProd := aScan(aHeaderAb8,{|x| AllTrim(x[2])=="AB8_CODPRO"})
Local nPosTotal:= aScan(aHeaderAb8,{|x| AllTrim(x[2])=="AB8_TOTAL"})
Local nPosSer	:= aScan(aHeaderAb8,{|x| AllTrim(x[2])=="AB8_CODSER"})
Local nTotGer	:= 0
Local nTotCli	:= 0
Local nTotFab	:= 0

If ( lF4 )
	For nCntFor := 1 To Len(aCols)
		If ( Len(aCols[nCntFor])==nUsado .Or. !aCols[nCntFor][nUsado+1] )
			nTotCli	+= AtVlrPagto(aCols[nCntFor][nPosSer],aCols[nCntFor][nPosTotal],"C")
			nTotFab	+= AtVlrPagto(aCols[nCntFor][nPosSer],aCols[nCntFor][nPosTotal],"F")
			nTotGer  += aCols[nCntFor][nPosTotal]
		EndIf
	Next nCntFor
Else
	For nCntFor := 1 To Len(aColsAB8)
		For nCntFor2 := 1 To Len(aColsAB8[nCntFor])
			If ( Len(aColsAB8[nCntFor][nCntFor2])==nUsado .Or. !aColsAB8[nCntFor][nCntFor2][nUsado+1] )
				nTotCli	+= AtVlrPagto(aColsAB8[nCntFor][nCntFor2][nPosSer],aColsAB8[nCntFor][nCntFor2][nPosTotal],"C")
				nTotFab	+= AtVlrPagto(aColsAB8[nCntFor][nCntFor2][nPosSer],aColsAB8[nCntFor][nCntFor2][nPosTotal],"F")
				nTotGer  += aColsAB8[nCntFor][nCntFor2][nPosTotal]
			EndIf
		Next nCntFor2
	Next nCntFor
EndIf
Eval(oDlg:Cargo,nTotGer,nTotCli,nTotFab)
Return(.T.)

/*
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Função    ¦AT450Bar  ¦ Autor ¦ Vendas Clientes       ¦ Data ¦ 21.09.98  ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Mostra a EnchoiceBar na tela                                ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TECA450                                                     ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
Static Function AT450Bar(oDlg,bOk,bCancel,nOpc,oGetD)
Local aButtons   := {}
Local aUsButtons := {}
Local lTECA450 := AtIsRotina("ATC010CON").Or.AtIsRotina("ATC020CON")

If ( nOpc <> 5 )
	aAdd(aButtons,{"S4SB014N" , {|| At450Aloc(oGetD)} , "Programação da OS", "Programação da OS"}) //
	aAdd(aButtons,{"RELATORIO", {|| At450Laudo(oGetD)}, "Atendimento da OS", "Atendimento da OS" }) //"Atendimento da OS"
	aAdd(aButtons,{"PRODUTO"  , {|| AT450F4(oGetD)   }, "Apontamento...", "Apontamento..." }) //"Apontamento..."
EndIf

If nOpc == 2 .And. !AtIsRotina("AT450TRACK")
	aAdd(aButtons,{"bmpord1",{|| At450Track()}, "System Tracker", "System Tracker" }) //
EndIf

If !lTECA450
	aAdd(aButtons,{"IMPRESSAO", {|| TECR450(M->AB6_NUMOS)}, "Impressao da OS gravada", "Impressao da OS gravada"}) //"Impressao da OS gravada"
EndIf

//+------------------------------------------------------------------------+
//¦ Adiciona botoes do usuario na EnchoiceBar                              ¦
//+------------------------------------------------------------------------+

If ExistBlock( "AT450BUT" )
	aUsButtons := ExecBlock( "AT450BUT", .F., .F. )
	aEval( aUsButtons, { |x| aAdd( aButtons, x ) } )
EndIf

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons)) 
