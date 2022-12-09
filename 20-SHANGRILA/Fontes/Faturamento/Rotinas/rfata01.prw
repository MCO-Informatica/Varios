#INCLUDE "protheus.CH"
#INCLUDE "TOPCONN.CH"
/*
-----------------------------------------------------------------------------
Funcao   : RFatA01        
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Manutencao das Regras de Desconto 
-----------------------------------------------------------------------------
*/
User Function RFatA01()
Local   aCores    := {}
Private cCadastro := "Regras de Desconto"
Private aRotina := {{ "Pesquisar"  ,"AxPesqui"    ,0,1},;	//"Pesquisar"
					{ "Visualizar" ,"U_RFatA01Vis",0,2},;	//"Visual"   
					{ "Incluir"    ,"U_RFatA01Inc",0,3},;	//"Incluir"
					{ "Alterar"    ,"U_RFatA01Alt",0,4},;   //"Alterar"
					{ "Excluir"   ,"U_RFatA01Exc",0,5},;   //"Exclusao"
					{ "Copiar"     ,"U_RFatA01Cop",0,2},;   //"Copiar"
					{ "Legenda"    ,"U_RFatA01Leg",0,2}}    //"Legenda"

Private _aCposSZ1 := {"Z1_VALATE","Z1_DESC1","Z1_DESC2","Z1_DESC3","Z1_DESC4","Z1_DESC5","Z1_DESC6","Z1_PRZMED","Z1_TABPRC"}

Aadd(aCores,{"Z0_ATIVO == '1'","ENABLE"})  	// 1-Ativo
Aadd(aCores,{"Z0_ATIVO == '2'","DISABLE"}) 	// 2-Inativo

mBrowse( 6, 1,22,75,"SZ0",,"Z0_ATIVO",,,,aCores)

Return(.T.)
/*
-----------------------------------------------------------------------------
Funcao   : RFatA01Vis        
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Funcao de Tratamento da Visualizacao              
-----------------------------------------------------------------------------
/*/
User Function RFatA01Vis(cAlias,nReg,nOpcx)

Local aArea     := GetArea()
Local aPosObj   := {} 
Local aObjects  := {}                        
Local aSize     := MsAdvSize() 
Local oGetDad   
Local oDlg
Local nUsado    := 0
Local nCntFor   := 0
Local nOpcA     := 0
Local nPItem    := 0
Local lContinua := .T.
Local lQuery    := .F.
Local cQuery    := ""
Local cTrab     := "SZ1"
Local bWhile    := {|| .T. }

PRIVATE aHEADER := {}
PRIVATE aCOLS   := {}
PRIVATE aGETS   := {}
PRIVATE aTELA   := {}  
/*
----------------------------------------------------------
Montagem da Variaveis de Memoria
----------------------------------------------------------
*/
dbSelectArea("SZ0")
dbSetOrder(1)

For nCntFor := 1 To FCount()
	M->&(FieldName(nCntFor)) := FieldGet(nCntFor)
Next nCntFor
/*
----------------------------------------------------------
Montagem do aHeader                                   
----------------------------------------------------------
*/
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZ1")

While ( !Eof() .And. SX3->X3_ARQUIVO == "SZ1" )
	If  Trim(SX3->X3_CAMPO)=="Z1_CODIGO" .Or.;
		Trim(SX3->X3_CAMPO)=="Z1_GRUPO"  .Or.;
		Trim(SX3->X3_CAMPO)=="Z1_REGIAO" .Or.;
		Trim(SX3->X3_CAMPO)=="Z1_ITEM" 
		
		dbSkip()
		Loop
	EndIf 
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()),;
						TRIM(SX3->X3_CAMPO),;
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
/*
--------------------------- 
Montagem do aCols
---------------------------*/
dbSelectArea("SZ1")
dbSetOrder(1)
#IFDEF TOP
	If ( TcSrvType()!="AS/400" )
		lQuery := .T.
		cQuery := "SELECT SZ1.*,R_E_C_N_O_ SZ1RECNO "
		cQuery += "FROM "+RetSqlName("SZ1")+" SZ1 "
		cQuery += "WHERE SZ1.Z1_FILIAL ='" + xFilial("SZ1") + "' AND "
		cQuery += "SZ1.Z1_CODIGO ='" + SZ0->Z0_CODIGO + "' AND "
		cQuery += "SZ1.Z1_GRUPO  ='" + SZ0->Z0_GRUPO + "' AND "
		cQuery += "SZ1.Z1_REGIAO ='" + SZ0->Z0_CODREG + "' AND " 
		cQuery += "SZ1.Z1_TABPRC ='" + SZ0->Z0_TABELA + "' AND " 
		cQuery += "SZ1.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY "+SqlOrder(SZ1->(IndexKey()))
		
		cQuery := ChangeQuery(cQuery)
		cTrab := "FAT01ARQ"		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTrab,.T.,.T.)

		For nCntFor := 1 To Len(aHeader)
			If aHeader[nCntFor,8] <> "C"
				TcSetField(cTrab,AllTrim(aHeader[nCntFor][2]),aHeader[nCntFor,8],aHeader[nCntFor,4],aHeader[nCntFor,5])
			EndIf 	
		Next nCntFor
    Else
#ENDIF
		SZ1->(MsSeek(xFilial("SZ1")+SZ0->Z0_CODIGO+SZ0->Z0_GRUPO+SZ0->Z0_CODREG+SZ0->Z0_TABELA))
		bWhile := {||   SZ1->Z1_FILIAL == xFilial("SZ1") .And.;
					    SZ1->Z1_CODIGO == SZ0->Z0_CODIGO .And.;
						SZ1->Z1_GRUPO  == SZ0->Z0_GRUPO  .And.;
						SZ1->Z1_TABPRC == SZ0->Z0_TABELA }
#IFDEF TOP
	EndIf	
#ENDIF
While ( !Eof() .And. Eval(bWhile) )
	aadd(aCOLS,Array(nUsado+1))
	For nCntFor	:= 1 To nUsado
		If ( aHeader[nCntFor][10] != "V" )
			aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
		Else
			If ( lQuery )
				SZ1->(MsGoto((cTrab)->SZ1RECNO))
			EndIf		
			aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
		EndIf
	Next nCntFor
	aCOLS[Len(aCols)][Len(aHeader)+1] := .F.
	dbSelectArea(cTrab)
	dbSkip()
EndDo
If ( Empty(aCols) )
	aadd(aCOLS,Array(nUsado+1))
	For nCntFor	:= 1 To nUsado
		aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
	Next nCntFor
	aCOLS[1][Len(aHeader)+1] := .F.
EndIf
If ( lQuery )
	dbSelectArea(cTrab)
	dbCloseArea()
	dbSelectArea(cAlias)
EndIf

aObjects := {} 
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL
EnChoice( cAlias ,nReg, nOpcx, , , , , APOSOBJ[1], , 3 , , ,"A01TudOk()")
oGetDad := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_A01LinOk()","AllwaysTrue","",.T.)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})
RestArea(aArea)

Return(.T.)
/*/
-----------------------------------------------------------------------------
Funcao   : RFatA01Inc
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Manutencao das Regras de Desconto - Inclusao
-----------------------------------------------------------------------------
/*/
User Function RFatA01Inc(cAlias,nReg,nOpcx)
Local aArea      := GetArea()
Local aPosObj    := {} 
Local aObjects   := {}                        
Local aSize      := MsAdvSize() 
Local cOldFilter := ""
Local oGetDad   
Local oDlg
Local nUsado     := 0
Local nCntFor    := 0
Local nOpcA      := 0
Local nPItem     := 0

PRIVATE aHEADER := {}
PRIVATE aCOLS   := {}
PRIVATE aGETS   := {}
PRIVATE aTELA   := {}

INCLUI := .T.
/*
-------------------------------- 
Limpa algum filtro do SZ0
--------------------------------*/
cOldFilter := SZ0->( dbFilter() ) 
SZ0->( dbClearFilter() ) 
/*
--------------------------------
Montagem da Variaveis de Memoria
--------------------------------*/
dbSelectArea("SZ0")
dbSetOrder(1)
For nCntFor := 1 To FCount()
	M->&(FieldName(nCntFor)) := CriaVar(FieldName(nCntFor))
Next nCntFor
/*
--------------------------------
Montagem do aHeader
--------------------------------*/
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZ1")
While ( !Eof() .And. SX3->X3_ARQUIVO == "SZ1" )
	If  Trim(SX3->X3_CAMPO)=="Z1_CODIGO" .Or.;
		Trim(SX3->X3_CAMPO)=="Z1_GRUPO"  .Or.;
		Trim(SX3->X3_CAMPO)=="Z1_REGIAO" .Or.;  
		Trim(SX3->X3_CAMPO)=="Z1_ITEM" 
		
		dbSkip()
		Loop
	EndIf 
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()),;
						TRIM(SX3->X3_CAMPO),;
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
/*
-----------------------------
Montagem do aCols
-----------------------------*/
aadd(aCOLS,Array(nUsado+1))
For nCntFor	:= 1 To nUsado
	aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
Next nCntFor
aCOLS[1][Len(aHeader)+1] := .F.

aObjects := {} 
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL

EnChoice( cAlias ,nReg, nOpcx, , , , , APOSOBJ[1], , 3 )

oGetDad := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_A01LinOk()","AllwaysTrue","",.T.)
ACTIVATE MSDIALOG oDlg ;
	ON INIT EnchoiceBar(oDlg,{||nOpcA:=If(oGetDad:TudoOk().And.A01TudOk().And.Obrigatorio(aGets,aTela),1,0),If(nOpcA==1,oDlg:End(),Nil)},{||oDlg:End()})		
If ( nOpcA == 1 )
	Begin Transaction
		A01Grava(1)
		If ( __lSX8 )
			ConfirmSX8()
		EndIf
		EvalTrigger()
	End Transaction
Else
	If ( __lSX8 )
		RollBackSX8()
	EndIf
EndIf	
MsUnLockAll()       

/*-- Retorna o filtro original --*/
If !Empty( cOldFilter )                                          
	dbSelectArea( cAlias ) 
	SET FILTER TO &cOldFilter
EndIf                     

RestArea(aArea)
Return(.T.)
/*
-----------------------------------------------------------------------------
Funcao   : RFatA01Alt        
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Manutencao das Regras de Desconto - Alteracao
-----------------------------------------------------------------------------
*/
User Function RFatA01Alt(cAlias,nReg,nOpcx)
Local aArea     := GetArea()
Local aPosObj   := {} 
Local aObjects  := {}                        
Local aSize     := MsAdvSize() 
Local oGetDad   
Local oDlg
Local nUsado    := 0
Local nCntFor   := 0
Local nOpcA     := 0
Local nPItem    := 0
Local lContinua := .T.
Local cQuery    := ""
Local cTrab     := "SZ1"
Local bWhile    := {|| .T. }

PRIVATE aHEADER := {}
PRIVATE aCOLS   := {}
PRIVATE aGETS   := {}
PRIVATE aTELA   := {}
/*
--------------------------------
Montagem da Variaveis de Memoria
--------------------------------*/
dbSelectArea("SZ0")
dbSetOrder(1)
lContinua := SoftLock("SZ0")
If ( lContinua )
	For nCntFor := 1 To FCount()
		M->&(FieldName(nCntFor)) := FieldGet(nCntFor)
	Next nCntFor
	/*
	----------------------------------------
	Montagem do aHeader
	----------------------------------------*/
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SZ1")
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SZ1" )
		If  Trim(SX3->X3_CAMPO)=="Z1_CODIGO" .Or.;
			Trim(SX3->X3_CAMPO)=="Z1_GRUPO"  .Or.;
			Trim(SX3->X3_CAMPO)=="Z1_REGIAO" .Or.;
			Trim(SX3->X3_CAMPO)=="Z1_ITEM" 
		
			dbSkip()
			Loop
		EndIf 
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			Aadd(aHeader,{ TRIM(X3Titulo()),;
							TRIM(SX3->X3_CAMPO),;
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
    /*
    ----------------------------------
    Montagem do aCols
    ----------------------------------*/
	dbSelectArea("SZ1")
	dbSetOrder(1)
	#IFDEF TOP
		If ( TcSrvType()!="AS/400" )
			lQuery := .T.
			cQuery := "SELECT SZ1.*,R_E_C_N_O_ SZ1RECNO "
			cQuery += "FROM "+RetSqlName("SZ1")+" SZ1 "
			cQuery += "WHERE SZ1.Z1_FILIAL ='" + xFilial("SZ1") + "' AND "
			cQuery += "SZ1.Z1_CODIGO ='" + SZ0->Z0_CODIGO + "' AND "
			cQuery += "SZ1.Z1_GRUPO  ='" + SZ0->Z0_GRUPO + "' AND "
			cQuery += "SZ1.Z1_REGIAO ='" + SZ0->Z0_CODREG + "' AND "	
			cQuery += "SZ1.Z1_TABPRC ='" + SZ0->Z0_TABELA + "' AND "	
			cQuery += "SZ1.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY "+SqlOrder(SZ1->(IndexKey()))

			cQuery := ChangeQuery(cQuery)
			cTrab := "FAT01ARQ"		
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTrab,.T.,.T.)

			For nCntFor := 1 To Len(aHeader)
				If aHeader[nCntFor,8] <> "C"
					TcSetField(cTrab,AllTrim(aHeader[nCntFor][2]),aHeader[nCntFor,8],aHeader[nCntFor,4],aHeader[nCntFor,5])
				EndIf 	
			Next nCntFor
	    Else
	#ENDIF
		SZ1->(MsSeek(xFilial("SZ1")+SZ0->Z0_CODIGO+SZ0->Z0_GRUPO+SZ0->Z0_CODREG+SZ0->Z0_TABELA))
		bWhile := {||   SZ1->Z1_FILIAL == xFilial("SZ1") .And.;
					    SZ1->Z1_CODIGO == SZ0->Z0_CODIGO .And.;
						SZ1->Z1_GRUPO  == SZ0->Z0_GRUPO  .And.;
						SZ1->Z1_TABPRC == SZ0->Z0_TABELA }
	#IFDEF TOP
		EndIf	
	#ENDIF

	While ( !Eof() .And. Eval(bWhile) )
		aadd(aCOLS,Array(nUsado+1))
		For nCntFor	:= 1 To nUsado
			If ( aHeader[nCntFor][10] != "V" )
				aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
			Else
				If ( lQuery )
					SZ1->(MsGoto((cTrab)->SZ1RECNO))
				EndIf			
				aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
			EndIf
		Next nCntFor
		aCOLS[Len(aCols)][Len(aHeader)+1] := .F.
		dbSelectArea(cTrab)
		dbSkip()
	EndDo

	If ( Empty(aCols) )
		aadd(aCOLS,Array(nUsado+1))
		For nCntFor	:= 1 To nUsado
			aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
		Next nCntFor
		aCOLS[1][Len(aHeader)+1] := .F.
	EndIf
	If ( lQuery )
		dbSelectArea(cTrab)
		dbCloseArea()
		dbSelectArea(cAlias)
	EndIf
EndIf

If ( lContinua )
	aObjects := {} 
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
	aPosObj := MsObjSize( aInfo, aObjects ) 

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL	
	EnChoice( cAlias ,nReg, nOpcx, , , , , APOSOBJ[1], , 3 )
 	//oGetDad := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_A01LinOk()","AllwaysTrue","",.T.)
	oGetDad := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_A01LinOk()","AllwaysTrue","",.T.,_aCposSZ1)

	ACTIVATE MSDIALOG oDlg ;
		ON INIT EnchoiceBar(oDlg,{||nOpca:=If(oGetDad:TudoOk().And.A01TudOk().And.Obrigatorio(aGets,aTela),1,0),If(nOpcA==1,oDlg:End(),Nil)},{||oDlg:End()})
	If ( nOpcA == 1 )
		Begin Transaction
			A01Grava(2)
			If ( __lSX8 )
				ConfirmSX8()
			EndIf
			EvalTrigger()
		End Transaction
	Else
		If ( __lSX8 )
			RollBackSX8()
		EndIf
	EndIf
EndIf
MsUnLockAll()
RestArea(aArea)
Return(.T.)
/*
-----------------------------------------------------------------------------
Funcao   : RFatA01Exc        
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Manutencao das Regras de Desconto - Exclusao
-----------------------------------------------------------------------------
*/
User Function RFatA01Exc(cAlias,nReg,nOpcx)
Local aArea     := GetArea()
Local aPosObj   := {} 
Local aObjects  := {}                        
Local aSize     := MsAdvSize() 
Local oGetDad   
Local oDlg
Local nUsado    := 0
Local nCntFor   := 0
Local nOpcA     := 0
Local nPItem    := 0
Local lContinua := .T.
Local cQuery    := ""
Local cTrab     := "SZ1"
Local bWhile    := {|| .T. }

PRIVATE aHEADER := {}
PRIVATE aCOLS   := {}
PRIVATE aGETS   := {}
PRIVATE aTELA   := {}
/*
---------------------------------------
Montagem da Variaveis de Memoria
---------------------------------------*/
dbSelectArea("SZ0")
dbSetOrder(1)
lContinua := SoftLock("SZ0")
If ( lContinua )
	For nCntFor := 1 To FCount()
		M->&(FieldName(nCntFor)) := FieldGet(nCntFor)
	Next nCntFor
	/*
	-----------------------
	Montagem do aHeader
	-----------------------*/
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SZ1")
	While ( !Eof() .And. SX3->X3_ARQUIVO == "SZ1" )
		If  Trim(SX3->X3_CAMPO)=="Z1_CODIGO" .Or.;
			Trim(SX3->X3_CAMPO)=="Z1_GRUPO"  .Or.;
			Trim(SX3->X3_CAMPO)=="Z1_REGIAO" .Or.; 
			Trim(SX3->X3_CAMPO)=="Z1_ITEM" 
		
			dbSkip()
			Loop
		EndIf 
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			Aadd(aHeader,{ TRIM(X3Titulo()),;
							TRIM(SX3->X3_CAMPO),;
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
    /*
    ----------------------------------
    Montagem do aCols
    ----------------------------------*/
	dbSelectArea("SZ1")
	dbSetOrder(1)
	#IFDEF TOP
		If ( TcSrvType()!="AS/400" )
			lQuery := .T.
			cQuery := "SELECT SZ1.*,R_E_C_N_O_ SZ1RECNO "
			cQuery += "FROM "+RetSqlName("SZ1")+" SZ1 "
			cQuery += "WHERE SZ1.Z1_FILIAL ='" + xFilial("SZ1") + "' AND "
			cQuery += "SZ1.Z1_CODIGO ='" + SZ0->Z0_CODIGO + "' AND "
			cQuery += "SZ1.Z1_GRUPO  ='" + SZ0->Z0_GRUPO + "' AND "
			cQuery += "SZ1.Z1_REGIAO ='" + SZ0->Z0_CODREG + "' AND "	
			cQuery += "SZ1.Z1_TABPRC ='" + SZ0->Z0_TABELA + "' AND "	
			cQuery += "SZ1.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY "+SqlOrder(SZ1->(IndexKey()))
		
			cQuery := ChangeQuery(cQuery)
			cTrab := "FAT01ARQ"		
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTrab,.T.,.T.)

			For nCntFor := 1 To Len(aHeader)
				If aHeader[nCntFor,8] <> "C"
					TcSetField(cTrab,AllTrim(aHeader[nCntFor][2]),aHeader[nCntFor,8],aHeader[nCntFor,4],aHeader[nCntFor,5])
				EndIf 	
			Next nCntFor
	    Else
	#ENDIF
		SZ1->(MsSeek(xFilial("SZ1")+SZ0->Z0_CODIGO+SZ0->Z0_GRUPO+SZ0->Z0_CODREG+SZ0->Z0_TABELA))
		bWhile := {||   SZ1->Z1_FILIAL == xFilial("SZ1") .And.;
					    SZ1->Z1_CODIGO == SZ0->Z0_CODIGO .And.;
						SZ1->Z1_GRUPO  == SZ0->Z0_GRUPO  .And.;
						SZ1->Z1_TABPRC == SZ0->Z0_TABELA }
	#IFDEF TOP
		EndIf	
	#ENDIF

	While ( !Eof() .And. Eval(bWhile) )
		aadd(aCOLS,Array(nUsado+1))
		For nCntFor	:= 1 To nUsado
			If ( aHeader[nCntFor][10] != "V" )
				aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
			Else
				If ( lQuery )
					SZ1->(MsGoto((cTrab)->SZ1RECNO))
				EndIf						
				aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor][2])
			EndIf
		Next nCntFor
		aCOLS[Len(aCols)][Len(aHeader)+1] := .F.
		dbSelectArea(cTrab)
		dbSkip()
	EndDo
	If ( Empty(aCols) )
		aadd(aCOLS,Array(nUsado+1))
		For nCntFor	:= 1 To nUsado
			aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
		Next nCntFor
		aCOLS[1][Len(aHeader)+1] := .F.
	EndIf	
	If ( lQuery )
		dbSelectArea(cTrab)
		dbCloseArea()
		dbSelectArea(cAlias)
	EndIf
EndIf

If ( lContinua ) 
	aObjects := {} 
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
	aPosObj := MsObjSize( aInfo, aObjects ) 
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL	
	EnChoice( cAlias ,nReg, nOpcx, , , , , APOSOBJ[1], , 3 , , ,"A01TudOk()")
	oGetDad := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_A01LinOk()","AllwaysTrue","",.T.)
	ACTIVATE MSDIALOG oDlg ;
		ON INIT EnchoiceBar(oDlg,{||nOpca:=If(oGetDad:TudoOk(),1,0),If(nOpcA==1,oDlg:End(),Nil)},{||oDlg:End()})
	If ( nOpcA == 1 )
		Begin Transaction
			A01Grava(3)
			EvalTrigger()
		End Transaction
	EndIf
EndIf
MsUnLockAll()
RestArea(aArea)
Return(.T.)
/*/
-----------------------------------------------------------------------------
Funcao   : A01LinOk        
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Validacao da Linha
-----------------------------------------------------------------------------
/*/
User Function A01LinOk()
Local lRetorno:= .T.  
nPosValor := Ascan(aHeader,{|x|Alltrim(x[2])=="Z1_VALATE"})

If N > 1
	If aCols[N,nPosValor] <= aCols[N-1,nPosValor] 
		lRetorno:= .F. 
	EndIf
Else
	If aCols[N,nPosValor] < GetMv("MV_XVALMIN")
		lRetorno:= .F. 
	EndIf		
EndIf

If !lRetorno
	MsgAlert("Valor Invalido","Atencao","INFO")
EndIf
Return(lRetorno)
/*
-----------------------------------------------------------------------------
Funcao   : A01TudOk
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Manutencao das Regras de Desconto 
-----------------------------------------------------------------------------
/*/
Static Function A01TudOk()
Local lRetorno := .T.  
Return(lRetorno)
/*
-----------------------------------------------------------------------------
Funcao   : A01Grava
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Gravacao das Regras de Desconto 
-----------------------------------------------------------------------------
Parametros: ExpN1 -> [1] Inclusao 
					 [2] Alteracao
					 [3] Exclusao 
-----------------------------------------------------------------------------
Retorno   : Nenhum
-----------------------------------------------------------------------------
*/  
Static Function A01Grava(nOpc)

Local aArea     := GetArea()
Local nCntFor   := 0
Local nCntFor2  := 0
Local nUsado    := Len(aHeader)
Local aRegistro := {}
Local lGravou   := .F.
Local cQuery    := ""

/*-- Guarda os registros em um array para atualizacao --*/
dbSelectArea("SZ0")
dbSetOrder(1)
dbSelectArea("SZ1")
dbSetOrder(1)          

If nOpc == 3   
	#IFDEF TOP
		If ( TcSrvType()!="AS/400" )
			lQuery := .T.
			cQuery := "SELECT SZ1.*,R_E_C_N_O_ SZ1RECNO "
			cQuery += "FROM "+RetSqlName("SZ1")+" SZ1 "
			cQuery += "WHERE SZ1.Z1_FILIAL ='" + xFilial("SZ1") + "' AND "
			cQuery += "SZ1.Z1_CODIGO ='" + SZ0->Z0_CODIGO + "' AND "
			cQuery += "SZ1.Z1_GRUPO  ='" + SZ0->Z0_GRUPO + "' AND "
			cQuery += "SZ1.Z1_REGIAO ='" + SZ0->Z0_CODREG + "' AND " 
			cQuery += "SZ1.Z1_TABPRC ='" + SZ0->Z0_TABELA + "' AND " 
			cQuery += "SZ1.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY "+SqlOrder(SZ1->(IndexKey()))
		
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"A01Grava",.T.,.T.)
			dbSelectArea("A01Grava")
			While ( !Eof() )
				aadd(aRegistro,SZ1RECNO)
				dbSelectArea("A01Grava")		
				dbSkip()
			EndDo
			dbSelectArea("A01Grava")
			dbCloseArea()
			dbSelectArea("SZ1")
		Else
	#ENDIF
			SZ1->(MsSeek(xFilial("SZ1")+SZ0->Z0_CODIGO+SZ0->Z0_GRUPO+SZ0->Z0_CODREG+SZ0->Z0_TABELA)) 
			While ( !Eof() .And. SZ1->Z1_FILIAL == xFilial("SZ1") .And.;
						    SZ1->Z1_CODIGO == SZ0->Z0_CODIGO .And.;
							SZ1->Z1_GRUPO  == SZ0->Z0_GRUPO  .And.;
							SZ1->Z1_TABPRC == SZ0->Z0_TABELA ) 
							
				aadd(aRegistro,SZ1->(RecNo()))
				dbSelectArea("SZ1")
				dbSkip()
			EndDo
	#IFDEF TOP
		EndIf		
	#ENDIF
EndIf 	

Do Case
	Case nOpc <> 3     //1-Inclusao 2-Alteracao
		/*
		---------------------------------------
		Gravacao do SZ0-Cabecalho das Regras
		---------------------------------------*/
		SZ0->(dbSetOrder(1))
		If SZ0->(!(MsSeek(xFilial("SZ0")+M->Z0_CODIGO+M->Z0_GRUPO+M->Z0_CODREG+M->Z0_TABELA)))
			RecLock("SZ0",.T.)			
	    Else
			RecLock("SZ0",.F.)			
	    EndIf
    
		For nCntFor := 1 To SZ0->(FCount())
			If  FieldName(nCntFor) != "Z0_FILIAL" 
				If nOpc == 2		//Alteracao
					If  FieldName(nCntFor) != "Z0_CODIGO" .And. ;
						FieldName(nCntFor) != "Z0_GRUPO" .And. ;
						FieldName(nCntFor) != "Z0_CODREG" .And. ;
						FieldName(nCntFor) != "Z0_TABELA" 
									
						FieldPut(nCntFor,M->&(FieldName(nCntFor)))
            		EndIf
	            Else	
					FieldPut(nCntFor,M->&(FieldName(nCntFor)))
				EndIf
			EndIf
    	Next nCntFor
		MsUnlock()
		/*
		-------------------------------- 
		Grava Regras de Desconto
		--------------------------------*/                                               
		For nCntFor := 1 To Len(aCols)
			If ( !aCols[nCntFor][nUsado+1] )
				SZ1->(dbSetOrder(1))
				If SZ1->(!(MsSeek(xFilial("SZ1") + M->(Z0_CODIGO+Z0_GRUPO+Z0_CODREG+Z0_TABELA) + StrZero(nCntFor,2))))
					RecLock("SZ1",.T.)			
		    	Else
					RecLock("SZ1",.F.)			
			    EndIf

				For nCntFor2 := 1 To nUsado
					If ( aHeader[nCntFor2][10] != "V" )					
						FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2])
					EndIf				
				Next nCntFor2
			  	/*
			  	--------------------------------
				Grava os campos obrigatorios
				--------------------------------*/
				SZ1->Z1_FILIAL:= xFilial("SZ1")
				SZ1->Z1_CODIGO := M->Z0_CODIGO
				SZ1->Z1_GRUPO  := M->Z0_GRUPO
				SZ1->Z1_REGIAO := M->Z0_CODREG 
				SZ1->Z1_TABPRC := M->Z0_TABELA
				SZ1->Z1_ITEM   := StrZero(nCntFor,2)
	    	EndIf
		Next nCntFor
		MsUnLock()
		/*
	  	----------------------------------------
		Exclusao  Itens e Cabecalho
	    ----------------------------------------*/
	OtherWise
		For nCntFor := 1 To Len(aRegistro)
			SZ1->(MsGoto(aRegistro[nCntFor]))
			RecLock("SZ1")			
			dbDelete()
			MsUnLock()		
		Next nCntFor

		RecLock("SZ0")
		SZ0->( dbDelete() )
		MsUnlock()
EndCase

RestArea(aArea)
Return( .T. )
/*
=============================================================================
Funcao   : RFatA01Cop     |Autor: Gildesio Campos            |Data: 27.03.07
-----------------------------------------------------------------------------
Descricao: Copia Regras de Desconto de um Grupo para outro
-----------------------------------------------------------------------------
Parametros: ExpC1: Alias do arquivo                                    
            ExpN2: Registro do Arquivo                                 
		    ExpN3: Opcao da MBrowse                                    
-----------------------------------------------------------------------------
*/
User Function RFatA01Cop()
Local cTitulo := "Copia Regra de Desconto                                                             "
Local cDesc1  := "Esse procedimento tem como objetivo copiar os atributos de um determinado Grupo para"
Local cDesc2  := "um outro Grupo de Produtos, agilizando o trabalho de inclusao de Regras de Desconto " 
Local cDesc3  := "" 
Local cDesc4  := ""
Local cDesc5  := ""

Local nOpca
Local aSays:={}, aButtons := {}

Private cPerg :=  "RFAT01"

AADD(aSays,OemToAnsi(cDesc1))
AADD(aSays,OemToAnsi(cDesc2))
AADD(aSays,OemToAnsi(cDesc3))
AADD(aSays,OemToAnsi(cDesc4))
AADD(aSays,OemToAnsi(cDesc5))

nOpca := 0
//RfatA01Perg(cPerg)  //--perguntas no SX1 VIA CONFIGURADOR

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )  // Mostra tela para entrada de dados

If nOpca == 1
	Processa({|| RFatA01Copia()}, "Aguarde... Copiando regras")
	TRB->(dbCloseArea())
Endif

Return
/*
-----------------------------------------------------------------------------
Funcao   : RFatA01Copia        
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Copia para os Grupos selecionados
-----------------------------------------------------------------------------
/*/
Static Function RFatA01Copia()
/*
---------------------------------------------------------
Parametros da Rotina
---------------------------------------------------------
mv_par01 - Código
mv_par02 - Grupo
mv_par03 - rEGIAO
mv_par05 - Grupo de Destino
---------------------------------------------------------
*/
Local cQuery   := ""
Local cAlias   := "TRB"

dbSelectArea("SZ0")
dbSetOrder(1)
dbSelectArea("SZ1")
dbSetOrder(1)

cQuery := "SELECT SZ0.*, SZ1.* "
cQuery += "FROM "
cQuery += RetSqlName("SZ1")+" SZ1, "
cQuery += RetSqlName("SZ0")+" SZ0 "
cQuery += "WHERE "
cQuery += "SZ0.Z0_FILIAL ='"+xFilial("SZ0")+"' AND "
cQuery += "SZ1.Z1_FILIAL ='"+xFilial("SZ1")+"' AND "
cQuery += "SZ1.Z1_CODIGO = SZ0.Z0_CODIGO AND "
cQuery += "SZ1.Z1_GRUPO  = SZ0.Z0_GRUPO  AND "
cQuery += "SZ1.Z1_REGIAO = SZ0.Z0_CODREG AND "
cQuery += "SZ1.Z1_TABPRC = SZ0.Z0_TABELA AND "
cQuery += "SZ0.Z0_ATIVO <> 'N' AND "
cQuery += "SZ1.Z1_CODIGO = '" + Mv_Par01 + "' AND "
cQuery += "SZ1.Z1_GRUPO  = '" + Mv_Par02 + "' AND "
cQuery += "SZ1.Z1_REGIAO = '" + StrZero(Mv_Par03,1) + "' AND "
cQuery += "SZ0.D_E_L_E_T_=' ' AND "
cQuery += "SZ1.D_E_L_E_T_=' ' "
cQuery += "ORDER BY Z1_CODIGO,Z1_GRUPO,Z1_REGIAO,Z1_ITEM "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB") 
TRB->(RecCount())
TRB->(dbGoTop())                    

While TRB->(!Eof())
	IncProc()
	cCodigo := TRB->Z0_CODIGO
	cGrupo  := TRB->Z0_GRUPO
	cREGIAO := TRB->Z0_CODREG
	cTabela := TRB->Z0_TABELA
	/*
	-------------------------------------
	Grava Cabecalho da Regra de Desconto
	-------------------------------------*/
	SZ0->(dbSetOrder(1))
	SZ0->(MsSeek(xFilial("SZ0") + TRB->Z0_CODIGO + Mv_Par04 + TRB->Z0_CODREG + TRB->Z0_TABELA))

	If SZ0->(Found())
		TRB->(dbSkip())
		Loop
	EndIf
	RecLock("SZ0",.T.)			
	SZ0->Z0_FILIAL := xFilial("SZ0")
	SZ0->Z0_CODIGO := TRB->Z0_CODIGO
	SZ0->Z0_GRUPO  := Mv_Par04
	SZ0->Z0_CODREG := TRB->Z0_CODREG
	SZ0->Z0_ALQICM := TRB->Z0_ALQICM
	SZ0->Z0_ATIVO  := "1"
	SZ0->Z0_DTAINC := dDataBase
	SZ0->Z0_USER   := Substr(cUsuario,7,15)
	SZ0->Z0_TIPOPER:= TRB->Z0_TIPOPER
	SZ0->Z0_TESOPER:= TRB->Z0_TESOPER
	SZ0->Z0_TABELA := TRB->Z0_TABELA
	MsUnlock()
	/*
	---------------------------------
	Grava Itens da Regra de Desconto
	---------------------------------*/
	While TRB->(!EOF()) .And. TRB->Z0_CODIGO==cCodigo .And. TRB->Z0_GRUPO==cGrupo .And. TRB->Z0_CODREG==cREGIAO .And. TRB->Z0_TABELA ==cTabela  
		RecLock("SZ1",.T.)
		SZ1->Z1_FILIAL := xFilial("SZ1")
		SZ1->Z1_CODIGO := TRB->Z1_CODIGO
		SZ1->Z1_GRUPO  := Mv_Par04
		SZ1->Z1_REGIAO := TRB->Z1_REGIAO
		SZ1->Z1_ITEM   := TRB->Z1_ITEM
		SZ1->Z1_VALATE := TRB->Z1_VALATE
		SZ1->Z1_PRZMED := TRB->Z1_PRZMED
		SZ1->Z1_DESC1  := TRB->Z1_DESC1
		SZ1->Z1_DESC2  := TRB->Z1_DESC2
		SZ1->Z1_DESC3  := TRB->Z1_DESC3
		SZ1->Z1_DESC4  := TRB->Z1_DESC4
		SZ1->Z1_DESC5  := TRB->Z1_DESC5
		SZ1->Z1_DESC6  := TRB->Z1_DESC6
		SZ1->Z1_TABPRC := TRB->Z1_TABPRC
		MsUnlock()
    	
		TRB->(dbSkip())
	End
End
Return
/*
-----------------------------------------------------------------------------
Funcao   : RFatA01Perg        
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Verifica as perguntas incluindo-as caso nao existam
-----------------------------------------------------------------------------
*/
Static Function RFatA01Perg(xPerg)
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))                                                              
aRegs:={}

AADD(aRegs,{cPerg,"01","Código Regra               ?","","","mv_ch1","C",5,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SZ0","","","","",""})
AADD(aRegs,{cPerg,"02","Grupo                      ?","","","mv_ch2","C",4,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","","",""})
AADD(aRegs,{cPerg,"03","Regiao                     ?","","","mv_ch3","C",1,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Grupo de Destino           ?","","","mv_ch4","C",4,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return
/*
-----------------------------------------------------------------------------
Funcao   : RFatA01Leg        
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Legenda
-----------------------------------------------------------------------------
*/
User Function RFatA01Leg()
Private aCorDesc 
aCorDesc := {   {"ENABLE" ,"Regra Ativa"},;
				{"DISABLE","Regra Inativa"}}

BrwLegenda( "Regra de Descontos","Legenda ", aCorDesc )

Return( .T. )
