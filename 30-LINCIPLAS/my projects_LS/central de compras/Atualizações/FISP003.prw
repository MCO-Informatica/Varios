#Include "Protheus.ch"

/*
+=========================================================+
|Programa: FISP003|Autor: Antonio Carlos |Data: 16/09/10  |
+=========================================================+
|Descrição: Rotina responsavel pela manutenção dos Tipos  |
|de Entrada/Saida a serem gravados na tabela Indicador de |
|Produtos (SBZ) na inclusão de um produto.                |
+=========================================================+
|Uso: Laselva                                             |
+=========================================================+
*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FISP003()
///////////////////////

Local aArea		:= GetArea()
Local cAlias  	:= "SZQ"

Private aRotina    := {}
Private cCadastro  := "Manutencao Tipo Entrada/Saida por Grupo"

Aadd(aRotina,{"Pesquisar" 			,"AxPesqui"	   		,0,1 })
Aadd(aRotina,{"Visualizar"  		,"U_Fisp03" 		,0,2 })
Aadd(aRotina,{"Incluir"  			,"U_Fisp03"			,0,3 })
Aadd(aRotina,{"Alterar"  			,"U_Fisp03" 		,0,4 })
Aadd(aRotina,{"Excluir"  			,"U_Fisp03" 		,0,5 })

mBrowse( 7, 4,20,74,cAlias,,,,,,)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cAlias)
RestArea(aArea)

Return(.T.)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FISP03(cAlias,nReg,nOpc)
//////////////////////////////////////

Private _cGrupo	:= SZQ->ZQ_GRUPO
Private aHeader	:= {}
Private aCols	:= {}
Private aRotina	:= {	{"Pesquisar"	, "AxPesqui", 0, 1},;
						{"Visualizar"	, "AxVisual", 0, 2},;
						{"Incluir"		, "AxInclui", 0, 3},;
						{"Alterar"		, "AxAltera", 0, 4},;
						{"Excluir"		, "AxDeleta", 0, 5}}
Private oGetDados

If nOpc == 5
	Alert("Opcao indisponivel!")
	Return(.F.)
EndIf

DbSelectArea("SX3")
SX3->( DbSetorder(1) )
MsSeek("SZQ")
While SX3->( !Eof() ) .And. (SX3->X3_ARQUIVO == "SZQ")
	
	If Alltrim(SX3->X3_CAMPO) $ "ZQ_TPEMP/ZQ_GRUPO/ZQ_TE/ZQ_TS/ZQ_TEC/ZQ_TSC/ZQ_TE_FORN/ZQ_TS_FORN/"
		
		If (cNivel >= SX3->X3_NIVEL)
			Aadd(aHeader,{Alltrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
			SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,".T."})
		EndIf
		
	EndIf
	
	SX3->( DbSkip() )
	
EndDo

If nOpc == 3
	
	aCols := {}
	Aadd(aCols,Array(Len(aHeader)+1))
	
	For nY := 1 To Len(aHeader)
		If ( aHeader[nY][10] <> "V" )
			aCols[Len(aCols),nY] := CriaVar(aHeader[nY][2])
		EndIf
	Next nY
	
	aCols[Len(aCols),Len(aHeader)+1] := .F.
	
Else
	
	DbSelectArea("SZQ")
	SZQ->( DbsetOrder(1) )
	If SZQ->( DbSeek(_cGrupo) )
		
		While SZQ->( !Eof() ) .And. _cGrupo == SZQ->ZQ_GRUPO
			
			Aadd(aCols,Array(Len(aHeader)+1))
			
			For nY	:= 1 To Len(aHeader)
				aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
			Next nY
			
			aCols[Len(aCols)][Len(aHeader)+1] := .F.
			
			SZQ->( DbSkip() )
			
		EndDo
		
	EndIf
	
EndIf

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 8,0 TO 300, 650 PIXEL

oGetDados := MsGetDados():New(20, 10, 130, 310, nOpc,"U_FI03LOk()", , , .T., , , .F., 200, , , ,  , oDlg)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg, { || AtuDados() }, { ||  oDlg:End() } )

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function CTGrpUser(cCodGrup)
///////////////////////////////////

Local cName   := Space(15)
Local aGrupo  := {}

PswOrder(1)
IF	PswSeek(cCodGrup,.F.)
	aGrupo   := PswRet()
	cNameGrp := Upper(Alltrim(aGrupo[1,2]))
EndIF
IF cCodGrup == "******"
	cNameGrp := "Todos"
EndIF

Return(cNameGrp)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AtuDados()
//////////////////////////

Local 	_nCont		:= 0
Local 	aRetUsu		:= {}
Private cCTGrpUser	:= ""


PswOrder(2)
If PSWSEEK(cUserName,.T.)
	PswOrder(3)
	aRetUsu := PswRet()
	For nX := 1 to Len(aRetUsu[1][10])
		cCTGrpUser += "/" + CTGrpUser(aRetUsu[1][10][nX]) + "/"
	Next nX
EndIf

_lGrava := U_FI03LOk()

If _lGrava
	
	//If ("FISCAL" $ cCTGrpUser)
	
	For nX := 1 To Len(aCols)
		
		DbSelectArea("SZQ")
		SZQ->( DbSetOrder(1) )
		_lAchou := SZQ->( DbSeek( aCols[nX,1]+aCols[nX,2] ) )
		cGrupo	:= aCols[nX,1]
		
		If aCols[nX,Len(aHeader)+1]
			
			If _lAchou
				
				RecLock("SZQ",.F.)
				DbDelete()
				SZQ->( MsUnLock() )
				
			EndIf
			
		Else
			
			If _lAchou
				RecLock("SZQ",.F.)
			Else
				RecLock("SZQ",.T.)
			EndIf
			
			For nX2 := 1 To Len(aHeader)
				If ( aHeader[nX2][10] != "V" )
					FieldPut(FieldPos(aHeader[nX2][2]),aCols[nX][nX2])
				EndIf
			Next
			
			SZQ->( MsUnLock() )
			
		EndIf
		
	Next nX
	
	LjMsgRun("Aguarde..., Atualizando SBZ... (Isto pode levar alguns minutos.)",, {|| UpdateSBZ(cGrupo) })
	MsgInfo("Atualizacao efetuada com sucesso!")
	oDlg:End()
	//Else
	
	//MsgStop("Usuario sem permissao!")
	
	//EndIf
	
EndIf

Return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±+-------------+----------------+------------------+-------+-------------+±±
±±|Função 		|  UpdateSBZ()	 |Connit - Vanilson	| Data	|29/08/2011	  |±±
±±+-------------+----------------+------------------+-------+-------------+±±
±±|Descrição 	| Atualização dos dados da tabela SZB, conforme dados     |±±
±±|             | gravados na tabela SZQ 			                      |±±
±±+-------------+---------------------------------------------------------+±±
±±|Sintaxe      | UpdateSBZ(cGrupo)										  |±±
±±+-------------+---------------------------------------------------------+±±
±±|Parâmetros   | cGrupo - grupo de produtos que será atualizado          |±±
±±|             | 		   na tabela SBZ. 								  |±±
±±|				|  														  |±±
±±|				| 														  |±±
±±+-------------+---------------------------------------------------------+±±
±±|Retorno      | Não tem								  				  |±±
±±+-------------+---------------------------------------------------------+±±
±±|Uso          | Especifico para Laselva			                      |±±
±±+-------------+---------------------------------------------------------+±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function UpdateSBZ(cGrupo)
/////////////////////////////////

Private cQuery := ""

_cQuery:= "UPDATE SBZ SET "
_cQuery += _cEnter +  " SBZ.BZ_TE 		= (CASE WHEN S.tipoempresa = 'M' OR S.tipoempresa = 'F' THEN SZQ.ZQ_TE ELSE SZQ.ZQ_TEC END),"
_cQuery += _cEnter +  " SBZ.BZ_TS 		= (CASE WHEN S.tipoempresa = 'M' OR S.tipoempresa = 'F' THEN SZQ.ZQ_TS ELSE SZQ.ZQ_TSC END),"
_cQuery += _cEnter +  " SBZ.BZ_TE_FORN 	= SZQ.ZQ_TE_FORN,"
_cQuery += _cEnter +  " SBZ.BZ_TS_FORN 	= SZQ.ZQ_TS_FORN,"
_cQuery += _cEnter +  " SBZ.BZ_TEC 		= (CASE WHEN tipoempresa = 'M' THEN SZQ.ZQ_TEC ELSE '' END),"
_cQuery += _cEnter +  " SBZ.BZ_TSC 		= (CASE WHEN tipoempresa = 'M' THEN SZQ.ZQ_TSC ELSE '' END)"

_cQuery += _cEnter +  "FROM " + RetSqlName('SBZ') + " SBZ WITH(NOLOCK)"

_cQuery += _cEnter +  " INNER JOIN " + RetSqlName('SB1') + " SB1 WITH(NOLOCK) "
_cQuery += _cEnter +  " ON SB1.B1_COD = SBZ.BZ_COD"
_cQuery += _cEnter +  " AND B1_CODLAN = '1'"
_cQuery += _cEnter +  " AND SB1.D_E_L_E_T_ = '' "

_cQuery += _cEnter +  " INNER JOIN MARTE.SIGA.dbo.sigamat_copia S  WITH(NOLOCK) "
_cQuery += _cEnter +  " ON S.M0_CODFIL = SBZ.BZ_FILIAL "

_cQuery += _cEnter +  " INNER JOIN " + RetSqlName('SZQ') + " SZQ WITH(NOLOCK) "
_cQuery += _cEnter +  " ON SB1.B1_GRUPO = SZQ.ZQ_GRUPO"
_cQuery += _cEnter +  " AND SZQ.ZQ_TPEMP = tipoempresa"
_cQuery += _cEnter +  " AND SZQ.D_E_L_E_T_ = '' "

_cQuery += _cEnter +  "WHERE SZQ.ZQ_GRUPO = '" + cGrupo + "'"

 TcSqlExec(_cQuery)

Return

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FI03LOk()
///////////////////////

Local _lRet		:= .T.
Local _nCont	:= 0
Local nPosTPE	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZQ_TPEMP"})
Local nPosTEF	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZQ_TE"})
Local nPosTSF	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZQ_TS"})
Local nPosTEC	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZQ_TEC"})
Local nPosTSC	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZQ_TSC"})
Local nPosTE_   := aScan(aHeader,{|x| AllTrim(x[2])=="ZQ_TE_FORN"})
Local nPosTS_   := aScan(aHeader,{|x| AllTrim(x[2])=="ZQ_TS_FORN"})

For _nI := 1 To Len(aCols)
	
	If !aCols[_nI,Len(aHeader)+1]
		If aCols[_nI,1] = aCols[n,1] .And. aCols[_nI,2] = aCols[n,2]
			_nCont++
		EndIf
	EndIf
	
Next _nI

If _nCont > 1
	
	MsgStop("Itens duplicados!!!")
	_lRet := .F.
	
EndIf

If !aCols[n,Len(aHeader)+1]
	If aCols[n,nPosTPE] == "F" .And. ( Empty(aCols[n,nPosTEF]) .Or. Empty(aCols[n,nPosTSF]) )
		_lRet := .F.
		MsgStop("Informe os campos de Tipo Entrada/Saida!")
	EndIf
EndIf

If !aCols[n,Len(aHeader)+1]
	If aCols[n,nPosTPE] == "C" .And. ( Empty(aCols[n,nPosTEC]) .Or. Empty(aCols[n,nPosTSC]) )
		_lRet := .F.
		MsgStop("Informe os campos de Tipo Entrada/Saida!")
	EndIf
EndIf

If !aCols[n,Len(aHeader)+1]
	If aCols[n,nPosTPE] == "M" .And. ( Empty(aCols[n,nPosTEF]) .Or. Empty(aCols[n,nPosTSF]) .Or. Empty(aCols[n,nPosTEC]) .Or. Empty(aCols[n,nPosTSC]) )
		_lRet := .F.
		MsgStop("Informe os campos de Tipo Entrada/Saida!")
	EndIf
EndIf

Return(_lRet)
