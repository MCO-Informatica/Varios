#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"


#DEFINE  CADASTRO "Pré Ordem de Servico"
#DEFINE  NUMITENS 999

Static cPictureTot		//Picture dos campos de Totais do rodape da tela
Static oDlg				//Objeto dialog principal
Static oSay1			//Obj. Say do Total geral 
Static oSay2			//Obj. Say do Total cliente
Static oSay3			//Obj. Say do Total fabricante 

/*/
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Função    ¦U_HCIA100 ¦ Autor ¦ Alexandre Circenis    ¦ Data ¦ 23.02.15  ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Programa de atualizacao das Pré O.S.                        ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Sintaxe   ¦ U_HCIA100                                                   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico                                                    ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
User Function HCIA100()

Local bFiltraBrw	:= {||}		// Bloco de c=digo para executpo do filtro
Local aIndexAB6		:= {}		// Indice do AB1
Local cFiltraAB6	:= ""		// Filtro utilizado no bloco de c=digo executado para ativar o filtro
Local aCores		:= {}
Local aCoresNew := {}
Private cCadastro := CADASTRO

Private aRotina := MenuDef()

Private cRoda 							              
Private aAutoCab
Private aAutoItens
Private aAutoApont
Private cOSAuto		:= ""

aCores	:= { { "AB6_XPREOS =='1'" , 'ENABLE' },{ "AB6_XPREOS <>'1'" , 'DISABLE' } }
							
dbSelectArea("AB6")   

If ( AMIIn(28) )
	//+--------------------------------------------------------------+
	//¦ Verifica a existencia de Filtros na mBrowse                  ¦
	//+--------------------------------------------------------------+
	AB6->(DbSetOrder(1))		
	    //cFiltraAB6 := ""
		//bFiltraBrw 	:= {|| FilBrowse("AB6",@aIndexAB6,@cFiltraAB6) }
		//Eval(bFiltraBrw)
	
	DbSetOrder(1)
	DbSeek(xFilial())
	mBrowse( 6, 1,22,75,"AB6",,,,,,aCores)
EndIf
DbSelectArea("AB6")
DbSetOrder(1)
Return(.T.)

/*/
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funtpo    ¦MenuDef   ¦ Autor ¦ Alexandre Circenis    ¦ Data ¦ 08.12.06 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Definição do aRotina (Menu funcional)                      ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe   ¦ MenuDef()                                                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TECA450                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function MenuDef()
//+--------------------------------------------------------------+
//¦ Define Array contendo as Rotinas a executar do programa      ¦
//¦ ----------- Elementos contidos por dimensao ------------     ¦
//¦ 1. Nome a aparecer no cabecalho                              ¦
//¦ 2. Nome da Rotina associada                                  ¦
//¦ 3. Usado pela rotina                                         ¦
//¦ 4. Tipo de Transação a ser efetuada                          ¦
//¦    1 - Pesquisa e Posiciona em um Banco de Dados             ¦
//¦    2 - Simplesmente Mostra os Campos                         ¦
//¦    3 - Inclui registros no Bancos de Dados                   ¦
//¦    4 - Altera o registro corrente                            ¦
//¦    5 - Remove o registro corrente do Banco de Dados          ¦
//+--------------------------------------------------------------+
Local aRotina := {	{"Pesquisar"	,"AxPesqui"		,0	,1	,0	,.F.	}	,;	
					{"Visualizar"	,"U_HCI100VI"	,0	,2	,0	,.T.	}	,;	
					{"Incluir"		,"U_HCI100IN"	,0	,3	,0	,.T.	}	,;	
					{"Alterar"		,"U_HCI100AL"	,0	,4	,0	,.T.	}	,;	
					{"Exclui"		,"U_HCI100EX"	,0	,5	,0	,.T.	}	,;	
					{"Legenda"		,"U_HCI100LE"  	,0	,2	,0	,.T.	}	} 	
Local aRotAdic    := {}  //aRotina adicional para o ponto de entrada						

Return(aRotina)

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦U_HC100IN¦ Autor ¦ Alexandre Circenis     ¦ Data ¦ 24.02.15 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Programa de Inclusao de Ordem de Servico                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe e ¦ Void U_HC100IN(ExpC1,ExpN1,ExpN2)                          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦ ExpC1 = Alias do arquivo                                   ¦¦¦
¦¦¦          ¦ ExpN1 = Numero do registro                                 ¦¦¦
¦¦¦          ¦ ExpN2 = Opcao selecionada                                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TECA450                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
User Function HCI100IN(cAlias,nReg,nOpcx)

Local nUsado	:= 0
Local nPosItem	:= 0
Local nOpcA		:= 0
Local uCampo	:= ""
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
Local n2     	:= 0				//Total Cliente
Local n3 		:= 0				//Total Fabricante
Local aNoEncho  := {"AB6_CODCLI","AB6_LOJA","AB6_CONPAG","AB6_GPI","AB6_GESTR","AB6_GOP","AB6_OK"}
Local aEncho    := {}

Private aTela		:= {}
Private aGets		:= {}
Private aHeader		:= {}
Private aHeaderAB8	:= {}
Private aHeaderAB7	:= {}
Private aCols		:= {}
Private aColsAB8	:= {}

If aRotina == Nil
	aRotina := MenuDef()
EndIf

//+--------------------------------------------------------------+
//¦ Inicializa as Variaveis da Enchoice                          ¦
//+--------------------------------------------------------------+
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("AB6")                      
aEncho := {}
While ( !Eof() .And. SX3->X3_ARQUIVO == "AB6" )
	uCampo := SX3->X3_CAMPO
	If Alltrim(uCampo) == "AB6_NUMOS"
    	M->&(uCampo) := GetNumAB6()
   	Else
		M->&(uCampo) := CriaVar(uCampo,.T.)
	EndIf
	M->AB6_XPREOS := '1' // Incluindo uma Pre OS
	if Ascan(aNoEncho,Upper(Alltrim(uCampo))) =0
		Aadd(aEncho, SX3->X3_CAMPO)
	endif	    	               
	DbSelectArea("SX3")
	DbSkip()
EndDo
Aadd(aEncho,"NOUSER")

//+--------------------------------------------------------------+
//¦ Monta aHeader                                                ¦
//+--------------------------------------------------------------+         
HC100Monta()

//+--------------------------------------------------------------+
//¦ Monta aCols                                                  ¦
//+--------------------------------------------------------------+
aHeader  := aClone(aHeaderAB7)
nUsado   := Len(aHeader)
nPosItem := aScan(aHeaderAB7,{|x| AllTrim(x[2])=="AB7_ITEM"})
aAdd(aCols,Array(nUsado+1))
For nCntFor := 1 To nUsado
	If IsHeadRec(aHeader[nCntFor][2])
		aCols[1][nCntFor] := 0
	Elseif IsHeadAlias(aHeader[nCntFor][2])
		aCols[1][nCntFor] := "AB7"
	Else
		aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
	Endif
Next nCntFor
aCols[1][nPosItem] := "01"
aCols[1][nUsado+1] := .F.

//+------------------+
//¦ Atualiza picture ¦
//+------------------+
cPictureTot	:= PesqPict("AB8","AB8_TOTAL",14,M->AB6_MOEDA) 

	aSizeAut := MsAdvSize()
	                                    
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
	
	EnChoice( "AB6", nReg, nOpcx, , , , aEncho, aPosObj[1],,3,,,,,,.T.)
	oGetD := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,/*"AT450LinOk"*/,/*"AT450TudOk"*/,"+AB7_ITEM",.T.,,,,NUMITENS)
	
	nLinIni := aPosObj[ 3, 1 ] 
	
	aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],310,;
				{{005,065,105,165,205,265}} )
	
	@ nLinIni,aPosGet[1,1] SAY "Total: " SIZE 60,09 OF oDlg PIXEL //
	@ nLinIni,aPosGet[1,2] SAY oSay1 VAR Transform(n1, cPictureTot) SIZE 40,09 OF oDlg PIXEL 
	@ nLinIni,aPosGet[1,3] SAY "Total do Cliente: " SIZE 60,09 OF oDlg PIXEL //
	@ nLinIni,aPosGet[1,4] SAY oSay2 VAR Transform(n2, cPictureTot) SIZE 40,09 OF oDlg PIXEL 
	@ nLinIni,aPosGet[1,5] SAY "Total do Fabricante: "SIZE 60,09 OF oDlg PIXEL //
	@ nLinIni,aPosGet[1,6] SAY oSay3 VAR Transform(n3, cPictureTot) SIZE 40,09 OF oDlg PIXEL 
	oDlg:Cargo := {|n1,n2,n3| 	oSay1:SetText( Transform(n1, cPictureTot) ),;
								oSay2:SetText( Transform(n2, cPictureTot) ),;
								oSay3:SetText( Transform(n3, cPictureTot) ) }
	At450Total(oDlg,.F.)
	ACTIVATE MSDIALOG oDlg ON INIT AT450Bar(oDlg,{||nOpca:=1,if(oGetD:TudoOk().And.Obrigatorio(aGets,aTela),oDlg:End(),nOpca:=0)},{||oDlg:End()},nOpcx,oGetD)

If ( nOpcA == 1 )      

	If lGrava 	
		Begin Transaction
			If ( HC100Grava(1) )
				EvalTrigger()
				While ( GetSX8Len() > nSaveSx8 )
					ConfirmSX8()
				EndDo
			EndIf
		End Transaction
	EndIf 	
		
EndIf

While ( GetSX8Len() > nSaveSx8 )
	RollBackSX8()
EndDo

Return(.T.)

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦U_HC100VI¦ Autor ¦ Alexandre Circenis     ¦ Data ¦ 24.02.15 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Programa de Visualizacao de Pre Ordem de Servico           ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe e ¦ Void U_HC100Vi(ExpC1,ExpN1,ExpN2)                         ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦ ExpC1 = Alias do arquivo                                   ¦¦¦
¦¦¦          ¦ ExpN1 = Numero do registro                                 ¦¦¦
¦¦¦          ¦ ExpN2 = Opcao selecionada                                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TECA450                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
User Function HCI100Vi(cAlias,nReg,nOpcx)

Local nUsado	:= 0
Local nCntFor2	:= 0
Local nOpcA		:= 0
Local aArea		:= { Alias(), IndexOrd() , Recno() }
Local uCampo	:= ""
Local aAux		:= {}
Local nPosItem	:= 0
Local oGetD		:= Nil
Local aObjects	:= {} 
Local aPosObj	:= {} 
Local aSizeAut	:= MsAdvSize()
Local aPosGet	:= {} 
Local nCntFor	:= 0
Local n1		:= 0				//Total Geral
Local n2		:= 0				//Total Cliente
Local n3		:= 0				//Total Fabricante


Private aTela		:= {}
Private aGets		:= {}
Private aHeader		:= {}
Private aHeaderAB8	:= {}
Private aHeaderAB7	:= {}
Private aCols		:= {}
Private aColsAB8	:= {}



If aRotina == Nil
	aRotina := MenuDef()
EndIf

If Type("cCadastro") == "U"
	cCadastro := CADASTRO + " - " + Upper("Visualizar")	//"Ordem de Servico"##
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

//+--------------------------------------------------------------+
//¦ Monta aHeader                                                ¦
//+--------------------------------------------------------------+
HC100Monta()

//+--------------------------------------------------------------+
//¦ Monta aCols                                                  ¦
//+--------------------------------------------------------------+
aHeader  := aClone(aHeaderAB7)
nUsado   := Len(aHeader)
nPosItem := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_SUBITE"})
DbSelectArea("AB7")
DbSetOrder(1)
DbSeek(xFilial("AB7")+AB6->AB6_NUMOS)
While ( !Eof() .And. xFilial("AB7")    == AB7->AB7_FILIAL .And.;
							AB6->AB6_NUMOS == AB7->AB7_NUMOS )
	aAdd(aCols,Array(nUsado))
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
	aAux := {}
	DbSelectArea("AB8")
	DbSetOrder(1)
	If ( DbSeek(xFilial("AB8")+AB6->AB6_NUMOS+AB7->AB7_ITEM) )
		While ( !Eof() .And. xFilial("AB8") == AB8->AB8_FILIAL .And.;
									M->AB6_NUMOS   == AB8->AB8_NUMOS .And.;
									AB7->AB7_ITEM== AB8->AB8_ITEM )
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
		aAux[Len(aAux)][nPosItem] := "01"
		aAux[Len(aAux)][Len(aHeaderAB8)+1] := .F.
		aAdd(aColsAB8,aClone(aAux))
	EndIf
	DbSelectArea("AB7")
	DbSkip()
EndDo

aObjects := {} 
aAdd( aObjects, { 315,  70, .T., .t. } )
aAdd( aObjects, { 100, 100, .t., .t. } )
aAdd( aObjects, { 100,   7, .t., .f. } )
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

//+------------------+
//¦ Atualiza picture ¦
//+------------------+
cPictureTot	:= PesqPict("AB8","AB8_TOTAL",14,M->AB6_MOEDA) 

//+------------------------------------------------------------------------+
//¦Monta tela de entrada                                                   ¦
//+------------------------------------------------------------------------+
DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] PIXEL 

EnChoice( "AB6" ,nReg,nOpcx,,,,,aPosObj[1],,3,,,,,,.T.)
oGetD := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,/*"AT450LinOk"*/,/*"AT450TudOk"*/,"+AB7_ITEM",.F.)

nLinIni := aPosObj[3,1] 

aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],310,;
			{{005,065,105,165,205,265}} )

@ nLinIni,aPosGet[1,1] SAY "Total: " SIZE 60,09 OF oDlg PIXEL //
@ nLinIni,aPosGet[1,2] SAY oSay1 VAR Transform(n1, cPictureTot) SIZE 40,09 OF oDlg PIXEL 
@ nLinIni,aPosGet[1,3] SAY "Total do Cliente: " SIZE 60,09 OF oDlg PIXEL //
@ nLinIni,aPosGet[1,4] SAY oSay2 VAR Transform(n2, cPictureTot) SIZE 40,09 OF oDlg PIXEL 
@ nLinIni,aPosGet[1,5] SAY "Total do Fabricante: " SIZE 60,09 OF oDlg PIXEL //"Total do Fabricante: "
@ nLinIni,aPosGet[1,6] SAY oSay3 VAR Transform(n3, cPictureTot) SIZE 40,09 OF oDlg PIXEL 
oDlg:Cargo := {|n1,n2,n3| 	oSay1:SetText( Transform(n1, cPictureTot) ),;
							oSay2:SetText( Transform(n2, cPictureTot) ),;
							oSay3:SetText( Transform(n3, cPictureTot) ) }
At450Total(oDlg,.F.)
ACTIVATE MSDIALOG oDlg ON INIT AT450Bar(oDlg,{||oDlg:End()},{||oDlg:End()},nOpcx,oGetD)

DbSelectArea(aArea[1])
DbSetOrder(aArea[2])
DbGoTo(aArea[3])
Return(.T.)

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦U_HCI100Alt¦ Autor ¦ Alexandre Circenis   ¦ Data ¦24.02.15  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Programa de Alteracao de Ordem de Servico                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe e ¦ Void U_HCI100Al(ExpC1,ExpN1,ExpN2)                         ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦ ExpC1 = Alias do arquivo                                   ¦¦¦
¦¦¦          ¦ ExpN1 = Numero do registro                                 ¦¦¦
¦¦¦          ¦ ExpN2 = Opcao selecionada                                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TECA450                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
User Function HCI100Al(cAlias,nReg,nOpcx)

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
Local aNoEncho  := {"AB6_CODCLI","AB6_LOJA","AB6_CONPAG","AB6_GPI","AB6_GESTR","AB6_GOP","AB6_OK"}
Local aEncho    := {}

Private aTela		:= {}
Private aGets		:= {}
Private aHeader		:= {}
Private aHeaderAB8	:= {}
Private aHeaderAB7	:= {}
Private aCols		:= {}
Private aColsAB8	:= {}

If aRotina == Nil
	aRotina := MenuDef()
EndIf


//+----------------------------------------------------------+
//¦Se existir funcionalidade de entrega e montagem e o campo ¦
//¦que indica que foi criado pelo m=dulo de Controle de Lojas¦
//¦estiver preenchido, npo permite a alteratpo da OS.        ¦
//+----------------------------------------------------------+
If FindFunction("Lj7HasDtEM") .And. Lj7HasDtEM()
	If !Empty(AB6->AB6_NUMLOJ)
		Alert( "Npo é possível alterar essa ordem de servito pois ela foi criada pelo m=dulo 'Controle de Lojas'" ) // 
		Return .F.
	EndIf
EndIf

If AB6->AB6_XPREOS <> '1'
	Alert( "Não é possível alterar pois não é uma PRE Ordem, acessar a rotina de Ordem de Servico para alterar." ) // 
	Return .F.
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
	if Ascan(aNoEncho,Alltrim(SX3->X3_CAMPO)) =0
		M->AB6_GPI   := .F.
		M->AB6_GESTR := .F.
		M->AB6_GOP   := .F.
		Aadd(aEncho, SX3->X3_CAMPO)
	endif	    	               
	DbSelectArea("SX3")
	DbSkip()
EndDo
Aadd(aEncho,"NOUSER")

//+------------------------------------------------------------------------+
//¦Trava Registros                                                         ¦
//+------------------------------------------------------------------------+
If ( !AtTravaReg("AB6", aTravas) )
	lTravas := .F.
Endif

//+--------------------------------------------------------------+
//¦ Monta aHeader                                                ¦
//+--------------------------------------------------------------+
HC100Monta()

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
//+------------------+
//¦ Atualiza picture ¦
//+------------------+
cPictureTot	:= PesqPict("AB8","AB8_TOTAL",14,M->AB6_MOEDA) 

If ( lTravas )
		
		aSizeAut := MsAdvSize()	

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
		EnChoice( "AB6", nReg, nOpcx, , , , aEncho, aPosObj[1],,3,,,,,,.T.)
		oGetD := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,/*"AT450LinOk"*/,/*"AT450TudOk"*/,"+AB7_ITEM",.T.,,,,NUMITENS)
		
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
		ACTIVATE MSDIALOG oDlg ON INIT AT450Bar(oDlg,{||nOpca:=1,if(oGetD:TudoOk().And.Obrigatorio(aGets,aTela),oDlg:End(),nOpca:=0)},{||oDlg:End()},nOpcx,oGetD)
EndIf
If ( nOpcA == 1 )
	
	If lGrava 		
		Begin Transaction           
			If ( HC100Grava(2)  )
				EvalTrigger()
				While ( GetSX8Len() > nSaveSx8 )
					ConfirmSX8()
				EndDo
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

Return(.T.)

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦U_HCI100Ex¦ Autor ¦ Alexandre Circenis    ¦ Data ¦03.10.98  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Programa de Exclusao  de Ordem de Servico                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe e ¦ Void U_HCI100Ex(ExpC1,ExpN1,ExpN2)                         ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦ ExpC1 = Alias do arquivo                                   ¦¦¦
¦¦¦          ¦ ExpN1 = Numero do registro                                 ¦¦¦
¦¦¦          ¦ ExpN2 = Opcao selecionada                                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TECA450                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
User Function HCI100Ex(cAlias,nReg,nOpcx)

Local nUsado	:= 0
Local nCntFor2	:= 0
Local nOpcA		:= 0
Local aArea		:= { Alias(), IndexOrd() , Recno() }
Local uCampo	:= ""
Local aAux		:= {}
Local aTravas	:= {}
Local lTravas	:= .T.
Local lExclui	:= .T.
Local nPosItem	:= 0
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
Local n2     	:= 0				//Total Cliente
Local n3 		:= 0				//Total Fabricante  
Local cAliasABF := ""
Local cQuery	:= "" 

Private aTela		:= {}
Private aGets		:= {}
Private aHeader		:= {}
Private aHeaderAB8	:= {}
Private aHeaderAB7	:= {}
Private aCols		:= {}
Private aColsAB8	:= {}


If aRotina == Nil
	aRotina := MenuDef()
EndIf


If ( Eof() .Or. Bof() )
	Return(.F.)
EndIf 

//+----------------------------------------------------------+
//¦Se existir funcionalidade de entrega e montagem e o campo ¦
//¦que indica que foi criado pelo m=dulo de Controle de Lojas¦
//¦estiver preenchido, npo permite a alteratpo da OS.        ¦
//+----------------------------------------------------------+
If FindFunction("Lj7HasDtEM") .And. Lj7HasDtEM()
	If !Empty(AB6->AB6_NUMLOJ)
		Alert( "Não é possível excluir essa ordem de serviço pois ela foi criada pelo módulo 'Controle de Lojas'" ) // 
		Return .F.
	EndIf
EndIf 

If AB6->AB6_XPREOS <> '1'
	Alert( "Não é possível excluir pois não é uma PRE Ordem acessar a rotina de Ordem de Servico para excluir." ) // 
	Return .F.
EndIf 


#IFDEF TOP		
	cAliasABF := GetNextAlias()
	cQuery := "SELECT COUNT(*) QTD_REQ "
	cQuery += "FROM " + RetSqlName("ABF")+ " ABF "
	cQuery += "WHERE "
	cQuery += "ABF_FILIAL='"+xFilial("ABF")+"' AND "
	cQuery += "ABF_NUMOS='"+AB6->AB6_NUMOS+"' AND "
	cQuery += "ABF.D_E_L_E_T_=' '"
	
	cQuery := ChangeQuery(cQuery)
	dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasABF,.F.,.T.)	
	
	If (cAliasABF)->QTD_REQ > 0
	  Help(" ",1,"NODELETA",,"Esta O.S. esta sendo utilizado por uma tabela - Requisições da O.S. e nao podera ser excluida.",2,0) //  
	  Return .F.				
	Endif     	
	(cAliasABF)->(DbCloseArea()) 	
#ENDIF  

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
HC100Monta()

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
							AB6->AB6_NUMOS == AB7->AB7_NUMOS .And. lExclui )
	If ( AtTravaReg("AB7", aTravas) )
		If ( AB7->AB7_TIPO<>"1" )
			lExclui := .F.
			Help(" ",1,"AT450DEL01")
		EndIf
	Else
		lTravas := .F.
	EndIf
	aAdd(aCols,Array(nUsado))
	aAdd(aColsAB8,aClone(aAux))
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
	aAux := {}
	DbSelectArea("AB8")
	DbSetOrder(1)
	If ( DbSeek(xFilial("AB8")+AB6->AB6_NUMOS+AB7->AB7_ITEM) )
		While ( !Eof() .And. xFilial("AB8") == AB8->AB8_FILIAL .And.;
									M->AB6_NUMOS   == AB8->AB8_NUMOS .And.;
									AB7->AB7_ITEM== AB8->AB8_ITEM )
			If ( !AtTravaReg("AB8" , aTravas) )
				lTravas := .F.
			EndIf
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
		aAux[Len(aAux)][nPosItem] := "01"
		aAux[Len(aAux)][Len(aHeaderAB8)+1] := .F.
		aAdd(aColsAB8,aClone(aAux))
	EndIf
	DbSelectArea("AB7")
	DbSkip()
EndDo

//+------------------+
//¦ Atualiza picture ¦
//+------------------+
cPictureTot	:= PesqPict("AB8","AB8_TOTAL",14,M->AB6_MOEDA) 

If ( lTravas .And. lExclui )

		aSizeAut := MsAdvSize()	
		
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
		
		EnChoice( "AB6" ,nReg,nOpcx,,,,,aPosObj[1],,3,,,,,,.T.)
		oGetD := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,/*"AT450LinOk"*/,/*"AT450TudOk"*/,"+AB7_ITEM",.F.)
		
		nLinIni := aPosObj[ 3, 1 ] 
		
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
		ACTIVATE MSDIALOG oDlg ON INIT AT450Bar(oDlg,{||nOpca:=1,oDlg:End()},{||oDlg:End()},nOpcx,oGetD)
EndIf
If ( nOpcA == 1 )
	If lGrava
		Begin Transaction     	
			If ( HC100Grava(3)  )
				EvalTrigger()
				While ( GetSX8Len() > nSaveSx8 )
					ConfirmSX8()
				EndDo
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

Return(.T.)


/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦HC100Monta  ¦ Autor ¦ Alexandre Circenis  ¦ Data ¦ 03.10.98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Monta aHeader                                              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe   ¦ Void HC100Monta(Void)                                      ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TECA450                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function HC100Monta()

Local nUsado   := 0
Local aArea    := { Alias() , IndexOrd() , Recno() }
Local aAreaAB7 := { AB7->(IndexOrd()), AB7->(Recno()) }
Local aAreaAB8 := { AB8->(IndexOrd()), AB8->(Recno()) }
Local aHeader  := {}
Local aNoGD := {"AB7_CUSUNI", "AB7_TS","AB7_TE","AB7_CUSTOT"}
                                                        
//+--------------------------------------------------------------+
//¦ Monta aHeader do AB7                                         ¦
//+--------------------------------------------------------------+
aHeader := {}
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("AB7")
nUsado := 0
While ( !Eof() .And. SX3->X3_ARQUIVO == "AB7" )
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL ) .and. Ascan(aNoGD, Upper(AllTrim(SX3->X3_CAMPO))) = 0 
		aAdd(aHeader,{ AllTrim(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_ARQUIVO,;
							SX3->X3_CONTEXT } )
	Endif
	DbSkip()
EndDo

// Inclui coluna de registro atraves de funcao generica
ADHeadRec("AB7", aHeader)

nUsado := Len(aHeader)
aHeaderAB7 := aClone(aHeader)

//+--------------------------------------------------------------+
//¦ Monta aHeader do AB8                                         ¦
//+--------------------------------------------------------------+
aHeader := {}
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("AB8")
nUsado := 0
While ( !Eof() .And. SX3->X3_ARQUIVO == "AB8" )
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
		aAdd(aHeader,{ AllTrim(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_ARQUIVO,;
							SX3->X3_CONTEXT } )
	Endif
	DbSkip()
EndDo

// Inclui coluna de registro atraves de funcao generica
ADHeadRec("AB8", aHeader)

nUsado := Len(aHeader)
aHeaderAB8 := aClone(aHeader)

DbSelectArea("AB7")
DbSetOrder(aAreaAB7[1])
DbGoTo(aAreaAB7[2])

DbSelectArea("AB8")
DbSetOrder(aAreaAB8[1])
DbGoTo(aAreaAB8[2])

DbSelectArea(aArea[1])
DbSetOrder(aArea[2])
DbGoTo(aArea[3])
Return(.T.)

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦AT450LinOk  ¦ Autor ¦ Vendas Clientes     ¦ Data ¦ 03.10.98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Validacao da Linha na GetDados                             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe   ¦ Logical AT450LinOk(Void)                                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TECA450                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Function AT450LinOk(oGet)

Local lRetorno := .T.
Local nUsado   := Len(aHeader)
Local nPosIt   := aScan(aHeader,{|x| AllTrim(x[2])=="AB7_ITEM"})
Local nPosPrd  := aScan(aHeader,{|x| AllTrim(x[2])=="AB7_CODPRO"})
Local nPosnSer := aScan(aHeader,{|x| AllTrim(x[2])=="AB7_NUMSER"})
Local nPosPrb  := aScan(aHeader,{|x| AllTrim(x[2])=="AB7_CODPRB"})
Local nPosTipo := aScan(aHeader,{|x| AllTrim(x[2])=="AB7_TIPO"})
Local nCntFor  := 0
Local lOSxCtrt := SuperGetMv("MV_OSXCTRT",.F.,.F.)        // Amarracao O/S X Contrato

If ( !aCols[n][nUsado+1] .And. ( Len(aCols) > 1.Or.!Empty(aCols[n][nPosPrd]) ))
	If (  Empty(aCols[n][nPosPrd]) .Or.;
			Empty(aCols[n][nPosnSer]) .Or.;
			Empty(aCols[n][nPosPrb]) )
		lRetorno := .F.
		Help(" ",1,"AT450LIN01")
	EndIf
	If ( lRetorno )
		For nCntFor := 1 To Len(aCols)
			If (  aCols[n][nPosPrd]+aCols[n][nPosNSer]+aCols[n][nPosPrb]==;
					aCols[nCntFor][nPosPrd]+aCols[nCntFor][nPosNSer]+aCols[nCntFor][nPosPrb] .And.;
					n <> nCntFor .And. !aCols[nCntFor][nUsado+1])
				Help(" ",1,"AT450LIN02")
				lRetorno := .F.
			EndIf
		Next nCntFor
	EndIf
Else
	If ( aCols[n][nPosTipo] $ "234" )
		Help(" ",1,"AT450LIN04")
		lRetorno := .F.
	EndIf
EndIf

At450Total(oGet:oWnd,.F.)

Return(lRetorno)
/*/

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦AT450TudOk  ¦ Autor ¦ Vendas Clientes     ¦ Data ¦ 03.10.98 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Validacao da GetDados                                      ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sintaxe   ¦ Logical AT450TudOk(Void)                                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TECA450                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
Function AT450TudOk()

Local lRetorno := .T.
Local nPosIt   := aScan(aHeader,{|x| AllTrim(x[2])=="AB7_ITEM"})
Local nPosPrd  := aScan(aHeader,{|x| AllTrim(x[2])=="AB7_CODPRO"})
Local nPosnSer := aScan(aHeader,{|x| AllTrim(x[2])=="AB7_NUMSER"})
Local nCntFor  := 0
Local lOSxCtrt := SuperGetMv("MV_OSXCTRT",.F.,.F.)        // Amarracao O/S X Contrato

If INCLUI .And. AB6->(DbSeek(xFilial("AB6")+M->AB6_NUMOS))      
	Help(" ",1,"NODELETA",,STR0088,2,0)
	lRetorno := .F. 
EndIf


If ( ( AAH->(FieldPos('AAH_STATUS')) > 0 ) .AND. lOSxCtrt  ) .And. lRetorno
	
	If lRetorno
		
		If ( !Empty(M->AB6_TPCONT) .AND. !Empty(M->AB6_CONTRT) )
			lRetorno := At450VCtrt()
		ElseIf	( !Empty(M->AB6_TPCONT) .AND. Empty(M->AB6_CONTRT) )
		
			//"Atentpo"##"N·mero do contrato npo informado."##"OK"
			Aviso(STR0055,STR0056,{STR0057},1)
			lRetorno := .F.
			
		EndIf
		
	EndIf
	
EndIf

Return(lRetorno)
/*/

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
Local cCodMontagem:= SuperGetMv("MV_LJOCOMO",,.F.)    //Codigo da ocorrencia no SIGATMK que corresponde a montagem.

If ( nOpc <> 5 )
	aAdd(aButtons,{"S4SB014N" , {|| At450Aloc(oGetD)} , "Programação da OS", "Prog OS" }) //"Programação da OS"
	aAdd(aButtons,{"RELATORIO", {|| At450Laudo(oGetD)}, "Atendimento da OS", "Aten OS" }) //
endif
	
If nOpc == 2 .And. !AtIsRotina("AT450TRACK") 	
	aAdd(aButtons,{"bmpord1",{|| At450Track()}, "System Tracker", "Sys Track" }) // "System Tracker"
EndIf 	

If !lTECA450
	aAdd(aButtons,{"IMPRESSAO", {|| TECR450(M->AB6_NUMOS)}, "Impressao da OS gravada", "Imp OS"}) //"Impressao da OS gravada"
EndIf   
 
If !Empty(cCodMontagem)
	aAdd(aButtons,{"Imp.uMov", {|| HisImpUMov(M->AB6_NUMLOJ,@oGetD)},"Visualiza","Imp.uMov" })//##
Endif
//+------------------------------------------------------------------------+
//¦ Adiciona botoes do usuario na EnchoiceBar                              ¦
//+------------------------------------------------------------------------+
Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))


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

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funcao    ¦At450Aloc ¦ Autor ¦ Vendas Clientes       ¦ Data ¦28.01.99  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Demonstra as alocacoes da Ordem de Servico.                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Retorno   ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦oGetd : Objeto da Getdados                                  ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function AT450Aloc(oGetd)

Local aArea		:= GetArea()
Local oDlg		:= Nil
Local oGetd2	:= Nil
Local cCadastro	:= "Programação da OS"
Local aSavCols	:= aClone(aCols)
Local aSavHead	:= aClone(aHeader)
Local nSavN		:= If(Type("N")=="U",1,N)
Local cSeek		:= ""			// Seek para montagem da aCols
Local cWhile	:= ""			// While para montagem da aHeader

Private aCols	:= {}
Private aHeader	:= {}
Private INCLUI	:= .F.
Private ALTERA	:= .F.
Private dData	:= dDataBase

oGetD:oBrowse:lDisablePaint:= .T.

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+M->AB6_CODCLI+M->AB6_LOJA)

//+-----------------------+
//¦Montagem aHeader, aCols¦
//+-----------------------+
cSeek	:= xFilial("ABB")+M->AB6_NUMOS
cWhile	:= "ABB->ABB_FILIAL+ABB->ABB_NUMOS"

FillGetDados(	2   			,"ABB"			,3				,cSeek				,;
  				{|| &(cWhile) }	,{|| .T. }		,/*aNoFields*/	,/*aYesFields*/		,; 
				/*lOnlyYes*/	,/*cQuery*/		,/*bMontCols*/	,/*lEmpty*/			,;
				/*aHeaderAux*/	,/*aColsAux*/	,/*bAfterCols*/	,/*bBeforeCols*/	)

//+-------------------------------------------------+
//¦ Se a 1a. linha estiver em branco, limpa o aCols ¦
//+-------------------------------------------------+
If Len(aCols) > 0 .AND. Empty( aCols[1][GdFieldPos("ABB_NUMOS")] )
	aCols := {}
EndIf	

If ( Len(aCols) <> 0 )
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 09,0 TO 28,80 OF oMainWnd
	@ 015,010 SAY   RetTitle("AB6_CODCLI") 	SIZE 040,009 	OF oDlg PIXEL
	@ 015,050 MSGET SA1->A1_NOME					SIZE 136,009 	OF oDlg PIXEL WHEN .F.
	oGetd2:=MsGetDados():New(030,005,138,314,1,"","","",.F.)
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})
Else
	Help(" ",1,"AT450NALO") //Hedit2
EndIf

//+------------------------------------------------------------------------+
//¦Restaura a entrada da rotina                                            ¦
//+------------------------------------------------------------------------+
aCols 	:= aClone(aSavCols)
aHeader	:= aClone(aSavHead)
N		:= nSavN
oGetD:oBrowse:lDisablePaint:= .F.

RestArea(aArea)

Return(Nil)

/*
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Função    ¦AT450Bar2 ¦ Autor ¦ Vendas Clientes       ¦ Data ¦ 29.01.99 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Mostra a EnchoiceBar na tela                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TECA450                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
Static Function AT450Bar2(oDlg,bOk,bCancel,nOpc,oGetD)

Local aButtons := {}

aAdd(aButtons,{"PESQUISA",{ || At450Laud2(oGetD)}, "Visualizar", "Visualizar"}) //

//+------------------------------------------------------------------------+
//¦ Adiciona botoes do usuario na EnchoiceBar                              ¦
//+------------------------------------------------------------------------+
If ExistBlock( "AT450BU2" ) 
	aUsButtons := ExecBlock( "AT450BU2", .F., .F. ) 
	aEval( aUsButtons, { |x| aAdd( aButtons, x ) } ) 	 	
EndIf 	

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funcao    ¦At450Laud2¦ Autor ¦ Vendas Clientes       ¦ Data ¦ 29.01.99 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦Visualizacao Individual do Laudo ( TECA460 )                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Retorno   ¦Nenhum                                                      ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦ExcO1 : Objeto Getdados                                     ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function AT450Laud2(oGetD)

Local aArea 		:= { Alias() , IndexOrd() , RecNo() }
Local aSavHeader	:= aClone(aHeader)
Local aSavCols    := aClone(aCols)
Local nSavN			:= If(Type("N")=="U",1,N)
Local nPosNumOs   := aScan(aHeader,{|x| AllTrim(x[2])=="AB9_NUMOS"})
Local cLaudo      := aCols[nSavN][nPosNumOs] + GDFieldGet( "AB9_CODTEC", nSavN ) + GDFieldGet( "AB9_SEQ", nSavN ) 

oGetD:oBrowse:lDisablePaint := .T.

DbSelectArea("AB9")
DbSetOrder(1)
If ( DbSeek(xFilial("AB9")+cLaudo) )
	At460Visua("AB9",AB9->(RecNo()),2)
EndIf

//+------------------------------------------------------------------------+
//¦Restaura a Rotina                                                       ¦
//+------------------------------------------------------------------------+
aHeader := aClone(aSavHeader)
oGetD:oBrowse:lDisablePaint := .F.

DbSelectArea(aArea[1])
DbSetOrder(aArea[2])
DbGoTo(aArea[3])

Return(Nil)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funcao    ¦At450Track¦ Autor ¦ Vendas Clientes       ¦ Data ¦09/01/2002¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Faz o tratamento da chamada do System Tracker              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Retorno   ¦ .T.                                                        ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦ Nenhum                                                     ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
Static Function AT450Track() 

Local aEnt     := {}								// Itens para rastreamento
Local cNumOs   := M->AB6_NUMOS 						// Numero da OS
Local nPosItem := GDFieldPos( "AB7_ITEM" ) 		    // Posicao do item AB7_ITEM
Local nLoop    := 0 								// Utilizado no loop
Local oOldDlg        := oDlg						// Salva as variaveis estaticas
Local oOldSay1       := oSay1						// Salva as variaveis estaticas
Local oOldSay2       := oSay2                  		// Salva as variaveis estaticas
Local oOldSay3       := oSay3						// Salva as variaveis estaticas
Local cOldPictureTot := cPictureTot					// Salva as variaveis estaticas

//+---------------------------------------------+
//¦ Carrega os itens para rastreamento          ¦
//+---------------------------------------------+
For nLoop := 1 To Len( aCols ) 
	aAdd( aEnt, { "AB7", cNumOs + aCols[ nLoop, nPosItem ] } ) 
Next nLoop 

MaTrkShow( aEnt ) 

//+--------------------------------------------------------+
//¦Restaura as variaveis estaticas, pois a rotina MaTrShow ¦
//¦reabre a janela TECA450 novamente, caso solicitado pelo ¦
//¦usuario.                                                ¦
//+--------------------------------------------------------+
oDlg		:= oOldDlg
oSay1		:= oOldSay1
oSay2		:= oOldSay2
oSay3		:= oOldSay3
cPictureTot	:= cOldPictureTot
           
Return( .T. ) 

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Program   ¦ HC100Leg ¦ Autor ¦ Vendas Clientes       ¦ Data ¦12/04/2006¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriç¦o ¦ Exibe a legenda da Ordem de Servico                        ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Retorno   ¦ Nil                                                        ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Parametros¦ Nenhum                                                     ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
User Function HCI100Le() 

Local aCoresNew := {}
Local aCores    := {}


aCores    := {	{ "ENABLE"	   	,  "Pre Ordem de Serviço" },;
				{ "BR_VERMELHO"	,  "Ordem de Serviço" } }	

BrwLegenda(cCadastro,"Legenda",aCores)

Return( Nil ) 

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Program   ¦ AT450Bar3 ¦ Autor ¦ Caio Sergio Ferreira ¦ Data ¦14/12/2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriç¦o ¦ Mostra a EnchoiceBar na tela                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso      ¦ TECA450                                                     ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
Static Function AT450Bar3(oDlg,bOk,bCancel,nOpc,oGetD)

Local aButtons := {}

//+------------------------------------------------------------------------+
//¦ Adiciona botoes do usuario na EnchoiceBar                              ¦
//+------------------------------------------------------------------------+
If ExistBlock( "AT450BU3" ) 
	aUsButtons := ExecBlock( "AT450BU3", .F., .F. ) 
	aEval( aUsButtons, { |x| aAdd( aButtons, x ) } ) 	 	
EndIf 	

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))

/*
_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦Função    ¦At460AjAco¦ Autor ¦ Rodrigo Toledo        ¦ Data ¦ 27/05/2011 ¦¦¦
¦¦+----------+--------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Ajusta o acols para gravar o conteudo das informacoes nas 	¦¦¦ 
¦¦¦			 ¦ tabelas AB8 e AAR.											¦¦¦ 
¦¦+----------+--------------------------------------------------------------¦¦¦
¦¦¦Sintaxe   ¦ At460AjAco(ExpC1,ExpC2,ExpC3,ExpC4)                          ¦¦¦
¦¦+----------+--------------------------------------------------------------¦¦¦
¦¦¦Parametros¦ ExpC1 -> Codigo do contrato                                	¦¦¦ 
¦¦¦			 ¦ ExpC2 -> Numero da OS                                		¦¦¦ 
¦¦¦			 ¦ ExpC3 -> Item da OS	                                		¦¦¦ 
¦¦+----------+--------------------------------------------------------------¦¦¦
¦¦¦Retorno   ¦ Nil						            						¦¦¦
¦¦+----------+--------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ At460AjAco                                                   ¦¦¦
¦¦+-------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/ 

Static Function At450AjAco(cContrato,cNumOs,cItem)
Local aAreaAAR := AAR->(GetArea())		
Local aAreaAAQ := AAQ->(GetArea())		
Local nPos	   := 0
Local nNovoSal := 0  
Local nSaldo   := 0
Local nLoop	   := 0
Local nX	   := 0
Local aProd    := {}
Local cMaxItem := ""
Local nPosSubI := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_SUBITE"})
Local nPosProd := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_CODPRO"})
Local nPosServ := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_CODSER"})
Local nPosQtde := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_QUANT"})
Local nPosDesc := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_DESPRO"})
Local nPosLoca := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_LOCAL"})
Local nPosUnit := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_VUNIT"})
Local nPosTota := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_TOTAL"})
Local nPosPCLi := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_PRCLIS"})

AAQ->(DbSetOrder(1))
AAR->(DbSetOrder(1))   
AB8->(DbSetOrder(1))

For nLoop := 1 To Len(aCols)
	If (nPos := aScan(aProd,{|x| x[1] == aCols[nLoop,nPosProd]})) == 0
		aAdd(aProd,{aCols[nLoop,nPosProd],Array(2)})
		nPos := Len(aProd)
	EndIf
	If AtBuscServ(cContrato,.T.) == aCols[nLoop,nPosServ]
		aProd[nPos,2,1] := nLoop
	ElseIf AtBuscServ(cContrato,.F.) == aCols[nLoop,nPosServ]
		aProd[nPos,2,2] := nLoop
	EndIf
Next nLoop   

For nLoop := 1 To Len(aProd)
	If Empty(aProd[nLoop,2,1]) .Or. !AAQ->(DbSeek(xFilial("AAR")+cContrato+aProd[nLoop,1]))
		Loop
	EndIf		      
	AB8->(DbSeek(xFilial("AB8")+cNumOs+cItem+aCols[nLoop,nPosSubI]))
	If AAQ->AAQ_MODLIB == "1"
		If AAR->(!DbSeek(xFilial("AAR")+cContrato+aProd[nLoop,1]))
			nNovoSal := AAQ->AAQ_QTDLIB - aCols[aProd[nLoop,2,1],nPosQtde]
		Else			
			nSaldo 	 := ABS(AAR->AAR_SALDO + AB8->AB8_QUANT)
			nNovoSal := nSaldo - aCols[aProd[nLoop,2,1],nPosQtde]
		EndIf
	ElseIf AAQ->AAQ_MODLIB == "2"
		If AAR->(!DbSeek(xFilial("AAR")+cContrato+aProd[nLoop,1]+LEFT(DTOS(dDataBase),6)))
			nNovoSal := AAQ->AAQ_QTDLIB - aCols[aProd[nLoop,2,1],nPosQtde]
		Else
			nSaldo 	 := ABS(AAR->AAR_SALDO + AB8->AB8_QUANT)
			nNovoSal := nSaldo - aCols[aProd[nLoop,2,1],nPosQtde]
		EndIf
	EndIf
	
	If nNovoSal >= 0
		If !Empty(aProd[nLoop,2,2])
			If !(aCols[aProd[nLoop,2,2],Len(aHeader)+1])
				aCols[aProd[nLoop,2,1],nPosQtde] += Min(nNovoSal,aCols[aProd[nLoop,2,2],nPosQtde])
				aCols[aProd[nLoop,2,1],nPosTota] := aCols[aProd[nLoop,2,1],nPosQtde] * aCols[aProd[nLoop,2,1],nPosUnit]
				If nNovoSal >= aCols[aProd[nLoop,2,2],nPosQtde]
					nNovoSal -= aCols[aProd[nLoop,2,2],nPosQtde]
			   		aCols[aProd[nLoop,2,2],Len(aHeader)+1]	:= .T.
				Else
					aCols[aProd[nLoop,2,2],nPosQtde] -= nNovoSal
				EndIf
			EndIf 
		EndIf		
	ElseIf nNovoSal < 0
		aCols[aProd[nLoop,2,1],nPosQtde] += nNovoSal 
		aCols[aProd[nLoop,2,1],nPosTota] := aCols[aProd[nLoop,2,1],nPosQtde] * aCols[aProd[nLoop,2,1],nPosUnit]
		If !Empty(aProd[nLoop,2,2])
			If (aCols[aProd[nLoop,2,2],Len(aHeader)+1])
				aCols[aProd[nLoop,2,2],Len(aHeader)+1]	:= .F.
				aCols[aProd[nLoop,2,2],nPosQtde] := 0
			EndIf
			aCols[aProd[nLoop,2,2],nPosQtde] += ABS(nNovoSal)
		Else
			aEval(aCols,{|x| If(x[nPosSubI] > cMaxItem,cMaxItem := x[nPosSubI],NIL)})
			aAdd(aCols,Array(Len(aHeader)+1))
			For nX := 1 To Len(aHeader)
				If IsHeadRec(aHeader[nx,2])
					ATAIL(aCols)[nX] := 0
				ElseIf IsHeadAlias(aHeader[nx,2])
					ATAIL(aCols)[nX] := "AB8"
				Else
					ATAIL(aCols)[nX] := CriaVar(aHeader[nX,2],.T.)
				EndIf
			Next nX						
			ATAIL(aCols)[nPosSubI] := Soma1(cMaxItem)
		 	ATAIL(aCols)[nPosProd] := aProd[nLoop,1]
		 	ATAIL(aCols)[nPosDesc] := Posicione("SB1",1,xFilial("SB1")+aProd[nLoop,1],"B1_DESC")
		  	ATAIL(aCols)[nPosServ] := AtBuscServ(AA3->AA3_CONTRT,.F.)
		  	ATAIL(aCols)[nPosQtde] := ABS(nNovoSal)
		  	ATAIL(aCols)[nPosLoca] := RetFldProd(aProd[nLoop,1],"B1_LOCPAD")
		  	ATAIL(aCols)[nPosUnit] := aCols[nLoop, nPosUnit]
		  	ATAIL(aCols)[nPosTota] := (ABS(nNovoSal) * aCols[nLoop, nPosUnit])
		  	ATAIL(aCols)[nPosPCLi] := aCols[nLoop,nPosPCLi]
			ATAIL(aCols)[Len(aHeader)+1] := .F.
		Endif			
	EndIf	
Next nLoop

RestArea(aAreaAAR)
RestArea(aAreaAAQ)
Return()

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Program   ¦GetNumAB6 ¦ Autor ¦Vendas e CRM           ¦ Data ¦ 02/08/13 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦Inicializa o Numero de Ordem de Servito                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Retorno   ¦Numero da Ordem de Servito                                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function GetNumAB6()
Local aArea		:= GetArea()
Local aAreaAB6	:= AB6->(GetArea())
Local cNum		:= GetSx8Num("AB6","AB6_NUMOS")
Local nSaveSX8 := GetSX8Len()

dbSelectArea("AB6")
dbSetOrder(1)
While AB6->(DbSeek(xFilial("AB6")+cNum))
	While ( GetSX8Len() > nSaveSX8 )
		ConfirmSX8()
	EndDo
	cNum := GetSx8Num("AB6","AB6_NUMOS")
EndDo

RestArea(aAreaAB6)
RestArea(aArea)
Return(cNum)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³HC100GRAVA  ³ Autor ³Alexandre Circenis   ³ Data ³ 25.02.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava as Ordens de Servicos                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void HC100Grava(ExpN1,ExpA2,ExpA3,ExpA4)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 : 1 - Inclusao / 2 - Alteracao / 3 - Excluir         ³±±
±±³          ³ ExpA2 : Numero do Chamado                                  ³±±
±±³          ³ ExpA3 : Numero do Orcamento                                ³±± 
±±³          ³ ExpA4 : Numero do Help Desk                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TECA450                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                             	
STATIC Function HC100Grava(nOpcx,aChamado,aOrcamento,aHelpDesk )

Local aAreaAb6   := AB6->(GetArea())				//Area do arquivo AB6
Local aAreaAb7   := AB7->(GetArea())				//Area do arquivo AB7
Local aAreaAb8   := AB8->(GetArea())				//Area do arquivo AB8
Local aArea      := (GetArea())           			//Area da tabela corrente
Local aInfoABL   := {}								//Array com o status da fila de help-desk
Local aPlano     := {}                    			//Array com os dados do Plano
Local aItGrPed   := {}      						//Array dos itens da OS que gerarao PV
Local aGerouPV   := {}       						//Array dos itens que gerou PV
Local aUserCpoPv := {}								//Array dos campos de usuario do PV
Local aDadosCFO  := {}								//Array com os dados do Cod. Fiscal de Operacao
Local aAux       := {}								//Array auxiliar
Local aHeadC6    := {}								//Array com o Header do SC6
Local aColsC6    := {}								//Array com as colunas/campos do SC6 
Local aColsF     := {}								//Array com as colunas do PV do Fabricante
Local aFabric    := {}								//Array com os dados do Fabric.

Local bCampo     := {|x| FieldName(x) }				//Codeblock a ser executado

Local cTipoAnt   := ""								//Tipo anterior
Local cItSc6     := ""								//Item do SC6
Local cCond      := ""								//Cond. Pagto
Local cCfo       := ""								//Cod. CFO
Local cSeekAA3   := ""       						//Expressao (chave) de pesquisa no AA3
Local cEstado    := SuperGetMV("MV_ESTADO")			//Estado
Local cMenNota   := ""								//Mensagem da Nota
Local cQuery     := "" 								//Expressao da query a executar
Local lT450PVOS  := ExistBlock("T450PVOS")			//Indica se existe o PE T450PVOS
Local lPVtmp     := .F.
Local lPv        := .F.								//Indica se deve gerar o PV
Local lGravou    := .F.								//Indica se gravou OS
Local lTecXSC5   := (ExistBlock("TECXSC5"))			//Indica se existe o PE TECXSC5
Local lAtCpPvOs  := (ExistBlock("ATCPPVOS"))		//Indica se existe o PE ATCPPVOS
Local lAt410Grv  := (ExistBlock("AT410GRV"))		//Indica se existe o PE AT410GRV
Local lGerouPV   := .F.								//Indica se gerou o PV
Local lInclBack  := .F. 							//Backup da variav. INCLUI
Local lAT450GIT  := ExistBlock( "AT450GIT" ) 		//Indica se existe o PE AT450GIT
Local lFoundAB6  := .F. 							//Indica se encontrou registro no AB6

Local nCntFor    := 0								//Usada em lacos For...Next
Local nCntFor2   := 0								//Usada em lacos For...Next
Local nCntFor3   := 0								//Usada em lacos For...Next
Local nPIteAB7   := aScan(aHeaderAB7,{|x| AllTrim(x[2])=="AB7_ITEM"})		//Posicao do campo AB7_ITEM
Local nPPrdAB7   := aScan(aHeaderAB7,{|x| AllTrim(x[2])=="AB7_CODPRO"})	//Posicao do campo AB7_CODPRO
Local nPMem1AB7  := aScan(aHeaderAB7,{|x| AllTrim(x[2])=="AB7_MEMO2"})		//Posicao do campo AB7_MEMO2
Local nPMem2AB7  := aScan(aHeaderAB7,{|x| AllTrim(x[2])=="AB7_MEMO4"})		//Posicao do campo AB7_MEMO4
Local nPPrdAB8   := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_CODPRO"})	//Posicao do campo AB8_CODPRO
Local nPIteAB8   := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_SUBITE"})	//Posicao do campo AB8_SUBITE
Local nPSerAB8   := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_CODSER"})	//Posicao do campo AB8_CORSER
Local nPQtdAB8   := aScan(aHeaderAB8,{|x| AllTrim(x[2])=="AB8_QUANT"})		//Posicao do campo AB8_QUANT
Local nUsadoAB7  := Len(aHeaderAB7)					//Tamanho do Header do AB7
Local nUsadoAB8  := Len(aHeaderAB8)					//Tamanho do Header do AB8
Local nRecAB7Ant := 0								//Nr. do registro do AB7 anterior
Local nOpcAB7    := 0								//Opcao do AB7 (1=inclusao/2=alteracao)
Local nPosUsrCpo := 0								//Posicao do campo de usuario no array
Local nAcolC6    := 0								//Indice do aCols do SC6
Local nItSc6     := 0								//Posicao do campo Item no aCols do SC6
Local nFabric    := 0								//Posicao do fabricante encontrada no array aFabric
Local nFieldPos  := 0								//Posicao do campo no arquivo
Local nRecnoAB6  := 0 								//Nr. do registro atual no AB6

Local cCampo   	:= ""										//Nome do campo
Local cParcela 	:= "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0"	//Possiveis numeros de parcelas
Local cMv1Dup  	:= SuperGetMV( "MV_1DUP" )					//Primeira duplicata
Local nParcelas	:= SuperGetMV("MV_NUMPARC")					//Nr. de parcelas
Local nMaxTipo9	:= 26										//Nr. maximo do tipo 9
Local nPos1    	:= 0										//Posicao do campo no AB6
Local nAcrsFin 	:= 0										//Acrescimo financ. da cond. de pagto
Local nValor   	:= 0										//Valor a ser convertido pela xMoeda()
Local nMoeda	:= 0										//Moeda a ser gravada no PV
Local nDecs	  	:= 0										//Nr. de casas decimais da Moeda
Local lTaxa		:= ( AB6->( FieldPos("AB6_TXMOED") ) > 0 )	//Indica se existe o campo AB6_TXMOED
Local cNrCham	:= ""										//Nr. do chamado tecnico 
Local nValorPRC  := 0 
Local cEventID      := ""                              // Id do Evento a ser disparado pelo Event Viewer
Local cMensagem     := ""                              // Mensagem que sera enviada por e-mail ou RSS pelo Event Viewer
Local lCarga	:= .T.                                     // Controla a carga do rateio
Local aSocios	:= {} 										// Array para armazenar os socios do grupo societario	
Local aQtdXAB8 	:= {}                                      // Array que controla a quantidade dos itens da tabela AB8
Local lRateio 	:= .F.									   // Define se o Pedido de Venda será rateado
Local nX		:= 0									   // Incremento utilizado no laco for
Local nQuant	:= 0									   // Quantidade Rateada

Local cAliasPesq										// Variável para setar a Tabela a ser pesquisada - Contrato 
Local cTipoCont	:= "0"									// Definição do tipo de contrato para saber qual tabela usar 1- Manutençao (AAH) 2- Prestaçao de Servico (AAM)

Private INCLUI 	:= ( nOpcx == 1 ) 							//Indica se inclui

If ( nOpcx <> 3 )
	nMoeda := IIf(!Empty(M->AB6_MOEDA), M->AB6_MOEDA, 1)
Else
	nMoeda := 1
EndIf

nDecs := MsDecimais(nMoeda)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se pode estender a tipo 9 ate 36 parcelas                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len( cMv1Dup ) > 1 .AND. Len( cMv1Dup ) == Len( SE1->E1_PARCELA ) .AND. cMv1Dup == ( Replicate( "0", Len( SE1->E1_PARCELA ) - 1 ) + "1" )
	nMaxTipo9 := 36
EndIf

If nParcelas > nMaxTipo9
   nParcelas := nMaxTipo9
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ nOpcx: 1 - Inclusao de Registros                     ³
//³ nOpcx: 2 - Alteracao de Registros                    ³
//³ nOpcx: 3 - Exclusao de Registros                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( nOpcx <> 3 ) // Inclusao e Alteracao

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se possui um item valido no acols                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 	lGravou := !Empty( AScan( aCols, { |x| !x[nUsadoAB7+1] .AND. !Empty(x[nPPrdAB7] ) } ) )  

	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+M->AB6_CODCLI+M->AB6_LOJA)
	DbSelectArea("AB6")
	DbSetOrder(1)
	DbSeek(xFilial("AB6")+M->AB6_NUMOS)
	
	lFoundAB6 := AB6->( Found() )    
	
	If lFoundAB6 
		nRecnoAB6 := AB6->( Recno() ) 
	EndIf 	
	
	If ( lGravou )            
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua a inclusao do cabecalho da OS                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("AB6",!Found())
		For nCntFor := 1 To FCount()
			If ( "FILIAL"$Field(nCntFor) )
				FieldPut(nCntFor,xFilial("AB6"))
			Else
				FieldPut(nCntFor,M->&(EVAL(bCampo,nCntFor)))
			EndIf
		Next nCntFor

		AB6->AB6_ATEND	:= Upper(AB6->AB6_ATEND)
		AB6->AB6_REGIAO := SA1->A1_REGIAO
		AB6->AB6_CONPAG := If(Empty(AB6->AB6_CONPAG),cCond,AB6->AB6_CONPAG)
		
		nRecnoAB6	:= AB6->( Recno() )
		cOSAuto		:= AB6->AB6_NUMOS		
		AB6->( FKCommit() ) 
		
	EndIf 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Acerta o AcolsAB8                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( Empty(aColsAB8) .OR. Len(aColsAB8)<=Len(aCols) )
		aadd(aAux,Array(nUsadoAB8+1))
		For nCntFor := 1 To nUsadoAB8
			If IsHeadRec(aHeaderAB8[nCntFor][2])
				aAux[1][nCntFor] := 0
			Elseif IsHeadAlias(aHeaderAB8[nCntFor][2])
				aAux[1][nCntFor] := "AB8"
			Else
				aAux[1][nCntFor] := CriaVar(aHeaderAB8[nCntFor][2],.T.)
			Endif
		Next nCntFor
		aAux[1][nUsadoAB8+1] := .T.
		For nCntFor := 1 To Len(aCols)
			aadd(aColsAB8,aClone(aAux))
		Next nCntFor
	EndIf     
	
	At450Ab8()
	nCntFor := Len(aCols)+1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua a Gravacao do Itens                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCntFor := 1 To Len(aCols)
		If ( !aCols[nCntFor][nUsadoAB7+1] .AND. !Empty(aCols[nCntFor][nPPrdAB7]) )
			DbSelectArea("AB7")
			DbSetOrder(1)
			If ( DbSeek(xFilial("AB7")+M->AB6_NUMOS+aCols[nCntFor][nPIteAB7]) )
				nOpcAB7 := 2
				RecLock("AB7",.F.)
				cTipoAnt := AB7->AB7_TIPO
			Else           
				nOpcAB7 := 1 
				RecLock("AB7",.T.)
				cTipoAnt := "0"
			EndIf
			For nCntFor2 := 1 To nUsadoAB7
				If !Empty( nFieldPos := AB7->( FieldPos(aHeaderAB7[nCntFor2][2] ) ) ) .And. ValType(aCols[nCntFor][nCntFor2]) <> "U"
					AB7->(FieldPut( nFieldPos,aCols[nCntFor][nCntFor2]))
				EndIf 					
			Next nCntFor2

			
			AB7->AB7_FILIAL   := xFilial("AB7")
			AB7->AB7_NUMOS    := M->AB6_NUMOS
			AB7->AB7_NRCHAM   := If(aChamado<>Nil,aChamado[nCntFor],AB7->AB7_NRCHAM)
			AB7->AB7_NUMORC   := If(aOrcamento<>Nil,aOrcamento[nCntFor],AB7->AB7_NUMORC)
			AB7->AB7_NUMHDE   := If(ValType(aHelpDesk)=="A",aHelpDesk[nCntFor],AB7->AB7_NUMHDE)		
			AB7->AB7_CODCLI   := M->AB6_CODCLI
			AB7->AB7_LOJA     := M->AB6_LOJA
			AB7->AB7_EMISSA   := M->AB6_EMISSA
			
			MSMM(AB7->AB7_MEMO1,,,aCols[nCntFor][nPMem1AB7],1,,,"AB7","AB7_MEMO1") //campo de observação
			MSMM(AB7->AB7_MEMO3,,,aCols[nCntFor][nPMem2AB7],1,,,"AB7","AB7_MEMO3") //campo de solução
			
			AB7->( FKCommit() ) 
			
//			AtEqStatus("TECA450",.F.)        
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Efetua a Gravacao dos Sub-Itens                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nCntFor2 := 1 To Len(aColsAB8[nCntFor])
				If ( !aColsAB8[nCntFor][nCntFor2][nUsadoAB8+1] .AND. !Empty(aColsAB8[nCntFor][nCntFor2][nPPrdAB8]))
					DbSelectArea("AB8")
					DbSetOrder(1)
					If ( DbSeek(xFilial("AB8")+M->AB6_NUMOS+aCols[nCntFor][nPIteAB7]+aColsAB8[nCntFor][nCntFor2][nPIteAB8]) )
						RecLock("AB8")
					Else
						RecLock("AB8",.T.)
					EndIf
					
					For nCntFor3 := 1 To nUsadoAB8
						If !Empty( nFieldPos := AB8->( FieldPos(aHeaderAB8[nCntFor3][2] ) ) )
							AB8->(FieldPut( nFieldPos,aColsAB8[nCntFor][nCntFor2][nCntFor3]))
						EndIf 							
					Next nCntFor3
					AB8->AB8_FILIAL   := xFilial("AB8")
					AB8->AB8_NUMOS := M->AB6_NUMOS
					If Type("lAt450Auto")=="U" .Or. !lAt450Auto
						AB8->AB8_ITEM  := aCols[nCntFor][nPIteAB7]
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Os campos abaixa sao redundantes na base para otimiza ³
					//³ cao de query's atraves de indices                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					AB8->AB8_CODCLI:= M->AB6_CODCLI
					AB8->AB8_LOJA  := M->AB6_LOJA
					AB8->AB8_CODPRD:= AB7->AB7_CODPRO
					AB8->AB8_NUMSER:= AB7->AB7_NUMSER
					AB8->AB8_TIPO  := AB7->AB7_TIPO

					DbSelectArea("AA5")
					DbSetOrder(1)
					DbSeek(xFilial("AA5")+AB8->AB8_CODSER)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Cria o Almoxarifado se nao existir.                                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea("SF4")
					DbSetOrder(1)
					If ( DbSeek(xFilial("SF4")+AA5->AA5_TES) .AND. SF4->F4_ESTOQUE=="S" )
						CriaSB2(AB8->AB8_CODPRO,AB8->AB8_LOCAL)
					EndIf
				Else
					DbSelectArea("AB8")
					DbSetOrder(1)
					If ( DbSeek(xFilial("AB8")+M->AB6_NUMOS+aCols[nCntFor][nPIteAB7]+aColsAB8[nCntFor][nCntFor2][nPIteAB8]) )
						RecLock("AB8")
						DbDelete()
					EndIf
				EndIf
			Next nCntFor2
			
			AB8->( FKCommit() ) 
			
		Else
			DbSelectArea("AB8")
			DbSetOrder(1)
			If DbSeek(xFilial("AB8")+M->AB6_NUMOS+aCols[nCntFor][nPIteAB7])
				While ( !Eof() .AND. AB8->AB8_FILIAL   ==    xFilial("AB8") .AND.;
											AB8->AB8_NUMOS    ==    M->AB6_NUMOS   .AND.;
											AB8->AB8_ITEM     ==    aCols[nCntFor][nPIteAB7])
																
					RecLock("AB8")
					DbDelete()
					DbSelectArea("AB8")
					DbSkip()
				EndDo
				AB8->( FKCommit() )    
			EndIf 	
			
			DbSelectArea("AB7")
			DbSetOrder(1)
			If ( DbSeek(xFilial("AB7")+M->AB6_NUMOS+aCols[nCntFor][nPIteAB7]) )
    
				MSMM(AB7->AB7_MEMO1,,,,2)
				MSMM(AB7->AB7_MEMO3,,,,2)
				RecLock("AB7",.F.)
				DbDelete()
				MsUnLock()
				
				AB7->( FKCommit()) 
				
  //				AtEqStatus("TECA450",.T.)
			EndIf
		EndIf 
	
	Next nCntFor                                

	If ( lGravou )

		AB6->( MsGoto( nRecnoAB6 ) ) 
		AB6->AB6_STATUS := AtOsStatus(AB6_NUMOS)
		
	   //	AtAtuTMK( AB6->AB6_NUMOS, AB6->AB6_STATUS )
		
	Else            
	
		If lFoundAB6                 
			AB6->( MsGoto( nRecnoAB6 ) ) 
			RecLock("AB6")
			AB6->( DbDelete() ) 
		EndIF
	EndIf

	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua a Exclusao dos Itens                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("AB8")
	DbSetOrder(1)
	If DbSeek(xFilial("AB8")+AB6->AB6_NUMOS)
		While ( !Eof() .AND. AB8->AB8_FILIAL   ==    xFilial("AB8") .AND.;
									AB8->AB8_NUMOS ==    AB6->AB6_NUMOS )
			RecLock("AB8")
			DbDelete()
			DbSelectArea("AB8")
			DbSkip()
		EndDo
		AB8->( FKCommit() ) 	      	
	EndIf 	
			
	DbSelectArea("AB7")
	DbSetOrder(1)
	If DbSeek(xFilial("AB7")+AB6->AB6_NUMOS)
		While ( !Eof() .AND. AB7->AB7_FILIAL   ==    xFilial("AB7") .AND.;
									AB6->AB6_NUMOS    ==    AB7->AB7_NUMOS )
			 
			MSMM(AB7->AB7_MEMO1,,,,2)
			MSMM(AB7->AB7_MEMO3,,,,2)
			
			cSeekAA3 := xFilial("AA3")+AB6->AB6_CODCLI+AB6->AB6_LOJA+AB7->AB7_CODPRO+AB7->AB7_NUMSER
			
			RecLock("AB7")
			DbDelete()
	
			DbSelectArea("AB7")
			DbSkip()
		EndDo
	     
		AB7->( FKCommit() ) 
	EndIf	
		
	RecLock("AB6")
	DbDelete()
EndIf

RestArea(aAreaAb6)
RestArea(aAreaAb7)
RestArea(aAreaAb8)
RestArea(aArea)
Return(lGravou)

