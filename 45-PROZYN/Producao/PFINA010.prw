#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

#Define ENTER Chr(13)+Chr(10)

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  |  pfina010.prw        | AUTOR | Daniel Paulo | DATA | 31/08/2018 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - PFINA010()                                             |//
//|           | Cadastro das regras de comissionamento							|//
//|           | Específico Prozyn								                |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////



User Function pfina010()

Private cCadastro := "Regra de Comissionamento - Prozyn"
Private aRotina := {}

aAdd( aRotina, {"Pesquisar"  ,"AxPesqui"    ,0,1})
aAdd( aRotina, {"Visualizar" ,'u_Mod2Visual',0,2})
aAdd( aRotina, {"Incluir"    ,'u_Mod2Inclui',0,3})
aAdd( aRotina, {"Alterar"    ,'u_Mod2Altera',0,4})
aAdd( aRotina, {"Excluir"    ,'u_Mod2Exclui',0,5})

//U_xGeraBase()

If Empty(Posicione("SX3",1,"SZS","X3_ARQUIVO"))
   Help("",1,"","NOX3X2IX","NÃO É POSSÍVEL EXECUTAR, FALTA"+ENTER+"X3, X2, IX E X7",1,0)
   RETURN
Endif

dbSelectArea("SZS")
dbSetOrder(1)
dbGoTop()

mBrowse(,,,,"SZS")

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  |  pfina010.prw        | AUTOR | Daniel Paulo | DATA | 31/08/2018 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Mod2Visual()                                         |//
//|           | Cadastro das regras de comissionamento - Visualizar     		|//
//|           | Específico Prozyn								                |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2Visual( cAlias, nRecNo, nOpcX )
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local nOpcA    := 0
Local oTPane1
Local oTPane2

Private cCodigo := SZS->ZS_CODREG
Private cNome   := SZS->ZS_DESCREG
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

dbSelectArea(cAlias)
If RecCount() == 0
	Return
Endif

dbSetOrder(1)
dbSeek( xFilial("SZS") + cCodigo )

Sx3->(DbSelectArea("Sx3"))
Sx3->(DbSetOrder(1))
Sx3->( dbGoTop() )
Sx3->(dbSeek(cAlias)) 

While !EOF() .And. SX3->X3_ARQUIVO == cAlias
	IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. !ALLTRIM(SX3->X3_CAMPO) $ ('ZS_FILIAL |  ZS_CODREG | ZS_DESCREG')
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               SX3->X3_CAMPO         ,;
		               SX3->X3_PICTURE       ,;
		               SX3->X3_TAMANHO       ,;
		               SX3->X3_DECIMAL       ,;
		               SX3->X3_VALID         ,;
		               SX3->X3_USADO         ,;
		               SX3->X3_TIPO          ,;
		               SX3->X3_ARQUIVO       ,;
		               SX3->X3_CONTEXT       })
	Endif
	SX3->( dbSkip() )
End

dbSelectArea(cAlias)
dbSeek( xFilial("SZS") + cCodigo )

While !Eof() .And. SZS->ZS_FILIAL + SZS->ZS_CODREG == xFilial("SZS") + cCodigo
   
   aAdd( aCOLS, Array(Len(aHeader)))
   
	nUsado:=0
	Sx3->(DbSelectArea("Sx3"))
	Sx3->(dbSeek(cAlias))
	While !EOF() .And. SX3->X3_ARQUIVO == cAlias
		If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. !ALLTRIM(SX3->X3_CAMPO) $ ('ZS_FILIAL |  ZS_CODREG | ZS_DESCREG')
			nUsado++
			cVarTemp := cAlias+"->"+(SX3->X3_CAMPO)
			If SX3->X3_CONTEXT # "V"
				aCOLS[Len(aCOLS),nUsado] := &cVarTemp
			ElseIf X3_CONTEXT == "V"
				aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(SX3->X3_CAMPO))
			Endif
		Endif
		SX3->( dbSkip() )
	End
	dbSelectArea(cAlias)
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	oTPane1:NCLRPANE := 14803406
	
	@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oTPane1
//	@ 4, 166 SAY "Emissao:" SIZE 70,7 PIXEL OF oTPane1

	@ 3, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oTPane1
	@ 3, 100 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oTPane1
	//@ 3, 192 MSGET dData   When .F. SIZE 40,7 PIXEL OF oTPane1
	
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	oTPane2:NCLRPANE := 14803406
	
	oGet := MSGetDados():New(0,0,0,0,nOpcX)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  |  pfina010.prw        | AUTOR | Daniel Paulo | DATA | 31/08/2018 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Mod2Inclui()                                         |//
//|           | Cadastro das regras de comissionamento - incluir				|//
//|           | Específico Prozyn								                |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2Inclui(cAlias,nReg,nOpcX)
Local nOpcA     := 0
Local oDlg      := Nil
Local oGet      := Nil
Local oTPane1
Local oTPane2

Private cCodigo := Space(Len(SZS->ZS_CODREG))
Private cNome   := Space(Len(SZS->ZS_DESCREG))
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0



dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cAlias )
While !EOF() .And. X3_ARQUIVO == cAlias
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .AND. !ALLTRIM(X3_CAMPO) $ ('ZS_FILIAL |  ZS_CODREG | ZS_DESCREG')
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO    ,;
		               X3_PICTURE  ,;
		               X3_TAMANHO  ,;
		               X3_DECIMAL  ,;
		               X3_VALID    ,;
		               X3_USADO    ,;
		               X3_TIPO     ,;
		               X3_ARQUIVO  ,;
		               X3_CONTEXT  })
	Endif
	dbSkip()
End

aAdd( aCOLS,Array(Len(aHeader)+1))

dbSelectArea("SX3")
dbSeek(cAlias)
nUsado:=0
While !EOF() .And. X3_ARQUIVO == cAlias
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .AND. !ALLTRIM(X3_CAMPO) $ ('ZS_FILIAL |  ZS_CODREG | ZS_DESCREG')
		nUsado++
		IF X3_TIPO == "C"
			If Trim(aHeader[nUsado][2]) == "ZS_SEQ"
				aCOLS[1][nUsado] := "001"
			Else
				aCOLS[1][nUsado] := SPACE(x3_tamanho)
			Endif
		ELSEIF X3_TIPO == "N"
			aCOLS[1][nUsado] := 0
		ELSEIF X3_TIPO == "D"
			aCOLS[1][nUsado] := dDataBase
		ELSEIF X3_TIPO == "M"
			aCOLS[1][nUsado] := CriaVar(AllTrim(X3_CAMPO))
		ELSE
			aCOLS[1][nUsado] := .F.
		Endif
		If X3_CONTEXT == "V"
			aCols[1][nUsado] := CriaVar(AllTrim(X3_CAMPO))
		Endif
	Endif
	dbSkip()
End

dbSelectArea(cAlias)
dbSetOrder(1)

aCOLS[1][nUsado+1] := .F.

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	oTPane1:NCLRPANE := 14803406

	@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oTPane1


	@ 3, 026 MSGET cCodigo F3 "SZS" PICTURE "@!" VALID U_PesqSZS(cCodigo) SIZE 030,7 PIXEL OF oTPane1
	@ 3, 100 MSGET cNome 			PICTURE "@!" SIZE 78,7 PIXEL OF oTPane1


	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	oTPane2:NCLRPANE := 14803406

	oGet := MSGetDados():New(0,0,0,0,nOpcX,"u_Mod2LinOk()","u_Mod2TudOk()","+ZS_SEQ",.T.)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Mod2TudOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1
	Begin Transaction
	   U_Mod2Grava(cAlias)
	End Transaction
Endif
dbSelectArea(cAlias)
Return                                        

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  |  pfina010.prw        | AUTOR | Daniel Paulo | DATA | 31/08/2018 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Mod2Altera()                                         |//
//|           | Cadastro das regras de comissionamento - Alteração   			|//
//|           | Específico Prozyn								                |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2Altera( cAlias, nRecNo, nOpcX )
Local nOpcA    := 0
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local oTPane1
Local oTPane2

Private cCodigo := SZS->ZS_CODREG
Private cNome   := SZS->ZS_DESCREG
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := 0

dbSelectArea(cAlias)
If RecCount() == 0
	Return
Endif

dbSetOrder(1)
dbSeek( xFilial("SZS") + cCodigo )


Sx3->(DbSelectArea("Sx3"))
Sx3->(DbSetOrder(1))
Sx3->( dbGoTop() )
Sx3->(dbSeek(cAlias))


While !EOF() .And. SX3->X3_ARQUIVO == cAlias
	IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. !ALLTRIM(SX3->X3_CAMPO) $ ('ZS_FILIAL |  ZS_CODREG | ZS_DESCREG')
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               SX3->X3_CAMPO         ,;
		               SX3->X3_PICTURE       ,;
		               SX3->X3_TAMANHO       ,;
		               SX3->X3_DECIMAL       ,;
		               SX3->X3_VALID         ,;
		               SX3->X3_USADO         ,;
		               SX3->X3_TIPO          ,;
		               SX3->X3_ARQUIVO       ,;
		               SX3->X3_CONTEXT       })
	Endif
	SX3->( dbSkip() )
End

dbSelectArea(cAlias)
dbSeek( xFilial("SZS") + cCodigo )

While !EOF() .And. SZS->ZS_FILIAL + SZS->ZS_CODREG == xFilial("SZS") + cCodigo
   
   aAdd( aCOLS, Array(Len(aHeader)+1))
   
	nUsado:=0
	Sx3->(DbSelectArea("Sx3"))
	Sx3->(dbSeek(cAlias))
	While !EOF() .And. SX3->X3_ARQUIVO == cAlias
		IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND. !ALLTRIM(SX3->X3_CAMPO) $ ('ZS_FILIAL |  ZS_CODREG | ZS_DESCREG')
			nUsado++
			cVarTemp := cAlias+"->"+(SX3->X3_CAMPO)
			If SX3->X3_CONTEXT # "V"
				aCOLS[Len(aCOLS),nUsado] := &cVarTemp
			ElseIF SX3->X3_CONTEXT == "V"
				aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(SX3->X3_CAMPO))
			Endif
		Endif
		SX3->( dbSkip() )
	EndDo
	aCOLS[Len(aCOLS),nUsado+1] := .F.
	dbSelectArea(cAlias)
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	oTPane1:NCLRPANE := 14803406

	@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oTPane1


	@ 3, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oTPane1
	@ 3, 100 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oTPane1
		
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	oTPane2:NCLRPANE := 14803406

	oGet := MSGetDados():New(0,0,0,0,nOpcX,"u_Mod2LinOk()","u_Mod2TudOk()","ZS_SEQ",.T.)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_Mod2TudOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

If nOpcA == 1
   Begin Transaction
      U_Mod2Grava(cAlias)
   End Transaction
Endif

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  |  pfina010.prw        | AUTOR | Daniel Paulo | DATA | 31/08/2018 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Mod2Exclui()                                         |//
//|           | Cadastro das regras de comissionamento - Exclusão				|//
//|           | Específico Prozyn								                |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2Exclui( cAlias, nRecNo, nOpcX )
Local cVarTemp := ""
Local oDlg     := Nil
Local oGet     := Nil
Local nOpcA    := 0
Local nX       := 0
Local oTPane1
Local oTPane2

Private cCodigo := SZS->ZS_CODREG
Private cNome   := SZS->ZS_DESCREG
Private aHeader := {}
Private aCOLS   := {}
Private nUsado  := {}

dbSelectArea(cAlias)
If RecCount() == 0
	Return
Endif

//Fazer pesquisar para saber se o(s) registro(s) pode(m) ser excluídos

dbSetOrder(1)
dbSeek( xFilial("SZS") + cCodigo )

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cAlias )
While !EOF() .And. X3_ARQUIVO == cAlias
	If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .AND. !ALLTRIM(X3_CAMPO) $ ('ZS_FILIAL |  ZS_CODREG | ZS_DESCREG')
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		               X3_CAMPO         ,;
		               X3_PICTURE       ,;
		               X3_TAMANHO       ,;
		               X3_DECIMAL       ,;
		               X3_VALID         ,;
		               X3_USADO         ,;
		               X3_TIPO          ,;
		               X3_ARQUIVO       ,;
		               X3_CONTEXT       })
	Endif
	dbSkip()
End

dbSelectArea(cAlias)
dbSeek( xFilial("SZS") + cCodigo )

While !Eof() .And. SZS->ZS_FILIAL + SZS->ZS_CODREG == xFilial("SZS") + cCodigo 
   aAdd( aCOLS, Array(Len(aHeader)+1))
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek( cAlias )
	While !EOF() .And. X3_ARQUIVO == cAlias
		If X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL .AND. !ALLTRIM(X3_CAMPO) $ ('ZS_FILIAL |  ZS_CODREG | ZS_DESCREG')
			nUsado++
			cVarTemp := cAlias+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS[Len(aCOLS),nUsado] := &cVarTemp
			ElseIf X3_CONTEXT == "V"
				aCOLS[Len(aCOLS),nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	dbSelectArea(cAlias)
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP
	oTPane1:NCLRPANE := 14803406

	@ 4, 006 SAY "Codigo:"  SIZE 70,7 PIXEL OF oTPane1
	@ 4, 062 SAY "Nome:"    SIZE 70,7 PIXEL OF oTPane1


	@ 3, 026 MSGET cCodigo When .F. SIZE 30,7 PIXEL OF oTPane1
	@ 3, 100 MSGET cNome   When .F. SIZE 78,7 PIXEL OF oTPane1

	
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
	oTPane2:NCLRPANE := 14803406
	
	oGet := MSGetDados():New(0,0,0,0,nOpcX)
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()})

If nOpcA == 1
	Begin Transaction
	dbSelectArea(cAlias)
	dbSetOrder(1)
	For nX = 1 to Len(aCols)
		dbSeek( xFilial("SZS") + cCodigo+aCols[nX,GdFieldPos("ZS_SEQ")] )
		RecLock(cAlias,.F.)
		dbDelete()
	Next nx
	MsUnLock(cAlias)
	End Transaction
Endif

Return

//+------------------------------------------------------------------------------+
//|******************************************************************************|
//|******************+---------------------------------------+*******************|
//|******************| FUNCOES GENEREICAS PARA ESTE PROGRAMA |*******************|
//|******************+---------------------------------------+*******************|
//|******************************************************************************|
//+------------------------------------------------------------------------------+

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  |  pfina010.prw        | AUTOR | Daniel Paulo | DATA | 31/08/2018 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - ModLinOk()                                             |//
//|           | Cadastro das regras de comissionamento - Valid. linha no Acols	|//
//|           | Específico Prozyn								                |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2LinOk()
Local lRet := .T.
Local cMsg := ""

//+----------------------------------------------------
//| Verifica se o codigo esta em branco, se ok bloqueia
//+----------------------------------------------------
//| Se a linha nao estiver deletada.
If !aCOLS[n,Len(aHeader)+1]
   If Empty(aCOLS[n,GdFieldPos("ZS_SEQ")])
      cMsg := "Nao sera permitido linhas sem sequencia"
      Help("",1,"","Mod2LinOk",cMsg,1,0)
      lRet := .F.
   Endif
Endif

Return( lRet )

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  |  pfina010.prw        | AUTOR | Daniel Paulo | DATA | 31/08/2018 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod2TudOk()                                            |//
//|           | Cadastro das regras de comissionamento							|//
//|           | Específico Prozyn								                |//
//|           | Validar se todas as linhas estao OK                             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2TudOk()
Local lRet := .T.

lRet := u_Mod2LinOk()

Return( lRet )

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  |  pfina010.prw        | AUTOR | Daniel Paulo | DATA | 31/08/2018 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Mod2Grava()                                            |//
//|           | Cadastro das regras de comissionamento							|//
//|           | Específico Prozyn								                |//
//|           | Funcao de para gravar os dados                                  |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Mod2Grava(cAlias)
Local lRet := .T.
Local nI := 0
Local nY := 0
Local cVar := ""
Local lOk := .T.
Local cMsg := ""

dbSelectArea(cAlias)
dbSetOrder(1)

For nI := 1 To Len(aCols)
   dbSeek( xFilial(cAlias) + cCodigo + aCOLS[nI,GdFieldPos("ZS_SEQ")] )

   If !aCOLS[nI,Len(aHeader)+1]            
      If Found()
         RecLock(cAlias,.F.)
      Else
         RecLock(cAlias,.T.)
      Endif
      
      SZS->ZS_FILIAL 	:= xFilial(cAlias)
      SZS->ZS_CODREG 	:= cCodigo
      SZS->ZS_DESCREG	:= cNome
                 
      For nY = 1 to Len(aHeader)
         If aHeader[nY][10] # "V"
            cVar := Trim(aHeader[nY][2])
            Replace &cVar. With aCOLS[nI][nY]
         Endif
      Next nY
      MsUnLock(cAlias)      
   Else
      If !Found()
         Loop
      Endif
      //Fazer pesquisa para saber se o item poderar ser deletado e
      If lOk
         RecLock(cAlias,.F.)
            dbDelete()
         MsUnLock(cAlias)
      Else
         cMsg := "Nao foi possivel deletar o item "+aCols[nI,GdFieldPos("ZS_SEQ")]+", o mesmo possui amarracao"
         Help("",1,"","NAOPODE",cMsg,1,0)
      Endif
   Endif
Next nI

Return( lRet )

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  |  pfina010.prw        | AUTOR | Daniel Paulo | DATA | 31/08/2018 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - PesqSZS()                                              |//
//|           | Cadastro das regras de comissionamento							|//
//|           | Específico Prozyn								                |//
//|           | Validar se o codigo existe                                      |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function PesqSZS(cCodigo)
Local lRet := .T.

dbSelectArea("SZS")
dbSetOrder(1)
If dbSeek( xFilial("SZS") + cCodigo )
   alert("Esta Regra de comissao já Existe =>" +cCodigo)
   lRet := .F.
Endif

Return( lRet )