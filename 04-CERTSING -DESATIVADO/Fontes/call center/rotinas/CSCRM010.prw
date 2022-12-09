#Include 'Totvs.ch'
#Include 'Protheus.ch'

Static cDA1_DESC := Space( Len(ADJ->ADJ_PROD) )

//-------------------------------------------------------------------------
// Rotina | CSCRM010     | Autor | Rafael Beghini     | Data | 01.10.2015
//-------------------------------------------------------------------------
// Descr. | Rotina para buscar a descrição Amigavel do Produto atraves da
//        | tabela de preço. É executado através do F3 no campo produto
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
User Function CSCRM010()
	
	Local aProd   := {}
	Local aOrdem  := {}
	
	Local cSQL    := ''
	Local cTRB    := ''
	Local cOrdem  := ''
	Local cRet    := ''
	Local cCodTab := ''
	Local cSeek   := Space(60)
	
	Local lRet    := .T.
	
	Local nOrd    := 1
	Local nOpc    := 0
	
	Local oDlg
	Local oLbx
	Local oOrdem
	Local oSeek
	Local oPesq
	Local oPnlTop
	Local oPnlAll
	Local oPnlBot
	Local ONOMRK
	Local oMrk
	
	Private cCadastro := 'Itens tabela de Preço'
	Private aTrocaF3  := {"ADJ_PROD", "ADJ01"}
	
	If FunName() == "FATA310"
		cCodTab := Posicione('AD1', 1, xFilial('AD1') + M->AD5_NROPOR, 'AD1_TABELA')
	
		If Empty(cCodTab)
			MsgStop("Favor informar o numero da oportunidade.")
			Return( .F. )
		EndIf
	
		AAdd( aOrdem, 'Descrição Amigável' )
		AAdd( aOrdem, 'Produto'            )
		AAdd( aOrdem, 'Descrição'          )
	ElseIf FunName() = "FATA300"
		cCodTab := M->AD1_TABELA
	EndIf
	
	//-- Construção da Query.
	cSQL := " SELECT DA1.DA1_ITEM, " 											+ CRLF
	cSQL += "        DA1.DA1_CODTAB, "											+ CRLF
	cSQL += "        DA1.DA1_CODPRO, "											+ CRLF
	cSQL += "        B1.B1_DESC, "												+ CRLF
	cSQL += "        DA1_DESAMI  "												+ CRLF
	cSQL += " FROM   " + RetSqlName("DA1") + " DA1 "							+ CRLF
	cSQL += "        INNER JOIN " + RetSqlName("SB1") + " B1 "					+ CRLF
	cSQL += "                ON DA1.DA1_CODPRO = B1.B1_COD "					+ CRLF
	cSQL += " WHERE  DA1.DA1_FILIAL = " + ValToSql(xFilial("DA1")) + " "		+ CRLF
	cSQL += "        AND B1.B1_FILIAL = " + ValToSql(xFilial("SB1")) + " "		+ CRLF
	cSQL += "        AND DA1.DA1_CODTAB = '" + cCodTab + "' "					+ CRLF
	
	If FunName() == "FATA300" .Or. FunName() == "FATA310"
		cSQL += "    AND DA1.DA1_ATIVO  = '1' "									+ CRLF
	EndIf
	
	cSQL += "        AND DA1.D_E_L_E_T_ = ' ' "									+ CRLF
	cSQL += "        AND B1.D_E_L_E_T_ = ' ' "									+ CRLF
	cSQL += " ORDER  BY DA1_FILIAL,DA1_CODTAB,DA1_CODPRO "						+ CRLF
	
	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Buscando produtos, aguarde...')
	
	If (cTRB)->( BOF() .And. EOF() )
		MsgInfo('Não foi possível encontrar registros de produtos.', cCadastro)
		Return( cRet )
	Else
		While .NOT. (cTRB)->( EOF() )
			(cTRB)->( AAdd( aProd, { DA1_DESAMI, DA1_CODPRO, B1_DESC, DA1_CODTAB  } ) )
			(cTRB)->( dbSkip() )
		End
		(cTRB)->(dbCloseArea())
	Endif
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 308,770 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
	   oDlg:lEscClose := .F.
		
	   oPnlTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
	   oPnlTop:Align := CONTROL_ALIGN_TOP
		
	   @ 1,001 COMBOBOX oOrdem VAR cOrdem ITEMS aOrdem SIZE 80,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPnlTop
	   @ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPnlTop
	   @ 1,247 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 50,11 PIXEL OF oPnlTop ACTION (A010Pesq(nOrd,cSeek,@oLbx))
		
	   oPnlAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
	   oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT
		
	   oPnlBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
	   oPnlBot:Align := CONTROL_ALIGN_BOTTOM
		
	   oLbx := TwBrowse():New(0,0,1000,1020,,{'Desc. Amigável','Produto','Descrição','Tabela'},,oPnlAll,,,,,,,,,,,,.F.,,.T.,,.F.)
	   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx:SetArray( aProd )
	   oLbx:bLine := {|| { aProd[oLbx:nAt,1], aProd[oLbx:nAt,2], aProd[oLbx:nAt,3], aProd[oLbx:nAt,4] } }

	   oLbx:bLDblClick := {|| Iif(A010Seek(oLbx,@nOpc,@cRet,oLbx:nAt),oDlg:End(),NIL) }
	   
	   @ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPnlBot ACTION Iif(A010Seek(oLbx,@nOpc,@cRet,oLbx:nAt),oDlg:End(),NIL)
	   @ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPnlBot ACTION { || oDlg:End(), lRet := .F. } 
	
	ACTIVATE MSDIALOG oDlg CENTER
	
	IF nOpc == 1
		cDA1_DESC := cRet	
	EndIF	
	
Return( lRet )


//-------------------------------------------------------------------------
// Rotina | A010Pesq     | Autor | Rafael Beghini     | Data | 01.10.2015
//-------------------------------------------------------------------------
// Descr. | Rotina para pesquisar a informação Digitada e posicionar.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
Static Function A010Pesq( nOrd,cPesq,oLbx )
	
	Local bAScan := {|| .T. }
	Local nCol   := nOrd
	Local nBegin := nEnd := nP := 0
	
	cPesq := Upper( AllTrim( cPesq ) )
		
	If nCol > 0
		nBegin := Min( oLbx:nAt + 1, Len( oLbx:aArray ) )
		nEnd   := Len( oLbx:aArray )
		
		If oLbx:nAt == Len( oLbx:aArray )
			nBegin := 1
		Endif
		
		bAScan := {|p| Upper(AllTrim( cPesq ) ) $ AllTrim( p[nCol] ) } 
		
		nP := AScan( oLbx:aArray, bAScan, nBegin, nEnd )
		
		If nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
			oLbx:SetFocus()
		Else
			MsgInfo('Informação não localizada.','Pesquisar')
		Endif
	Else
		MsgAlert('Opção de pesquisa inválida.',cCadastro)
	Endif
	
Return


//-------------------------------------------------------------------------
// Rotina | A010Seek     | Autor | Rafael Beghini     | Data | 01.10.2015
//-------------------------------------------------------------------------
// Descr. | Rotina para retornar o código do Produto conforme posicionado.
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
Static Function A010Seek( oLbx, nOpc, cRet, nLin )
	
	Local lRet := .T.
	cRet := Alltrim( oLbx:aArray[nLin,2] )
	nOpc := Iif(lRet,1,0)
	
Return(lRet)


//-------------------------------------------------------------------------
// Rotina | CSCrm10Ret     | Autor | Rafael Beghini     | Data | 01.10.2015
//-------------------------------------------------------------------------
// Descr. | Código do produto no retorno da consulta padrão (ADJ01)
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
User Function CSCrm10Ret()
Return(cDA1_DESC)