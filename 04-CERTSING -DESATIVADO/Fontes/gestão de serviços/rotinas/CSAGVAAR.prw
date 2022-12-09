//////////////////////////////////////////////////////////////////////////////////////////////
//+----------------------------------------------------------------------------------------+//
//| CSAGVAAR  | Busca de Regiões por AR | AUTOR | Claudio Correa  | DATA | 11/11/2016      |//
//+----------------------------------------------------------------------------------------+//
//| DESCRICAO | Função para Busca e Cadastro de Contato                                    |//
//+----------------------------------------------------------------------------------------+//
//////////////////////////////////////////////////////////////////////////////////////////////

#include "Protheus.ch"
#include "Topconn.ch"

static cPA4 := ''

User Function CSAGVAAR()

Local bRet := .F.
Local aHeader := {}


If Empty(M->PA0_AR)

	Aviso( "Favor preencher o campo AR", "Não existe dados a consultar", {"Ok"} )

	Return .F.
	
Endif
	
Private nPosCont := aScan(aHeader, {|x| alltrim(x[1]) == "PA4_REGIAO"})
Private cCodigo := Alltrim(&(ReadVar()))
 
bRet := FiltraPA4()

Return(bRet)

Static Function FiltraPA4()

Local cQuery
Local oLstPA4 := nil
local cCabecalho := "Busca de Regiões por AR"
Private oDlgPA4 := nil
Private _bRet := .F.
Private aDadosPA4 := {} 

//Query de regiões por AR filtrada

cQuery := " SELECT * "
cQuery += " FROM "+RetSQLName("PA4")
cQuery += " WHERE PA4_FILIAL = '" + xFilial("PA4") + "' AND PA4_AR = '"+ M->PA0_AR +"'"
cQuery += " AND D_E_L_E_T_= ' ' "
cQuery += " ORDER BY PA4_DESCRI " 

cAlias1:= CriaTrab(Nil,.F.) 

DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.) 

(cAlias1)->(DbGoTop()) 

If (cAlias1)->(Eof())

	Aviso( "Cadastro de Contatos", "Não existe dados a consultar", {"Ok"} )
	 
	Return .F.

Endif

Do While (cAlias1)->(!Eof())

	aAdd( aDadosPA4, { (cAlias1)->PA4_REGIAO, (cAlias1)->PA4_DESCRi, (cAlias1)->PA4_AR  } )
	
	(cAlias1)->(DbSkip())

Enddo 

DbCloseArea(cAlias1)

nList := aScan(aDadosPA4, {|x| alltrim(x[2]) == alltrim(cCodigo)}) 

iif(nList = 0,nList := 1,nList)

//------------------------------
// Indice por Codigo
//------------------------------

if ( !empty( cCabecalho ) .and. len( aDadosPA4 ) > 0 )
	csMontaTela( cCabecalho, aDadosPA4, @_bRet )
else
	Aviso( "Consulta", "Não existe dados a consultar", {"Ok"} )
endif

Return _bRet

/* 
Alterado por Douglas Parreja - 11/01/2017
Abaixo segue a tela desenvolvida por Claudio Correa.
Devido a solicitacao de melhoria dos usuarios, analisei e realmente achei 
necessario a criacao do filtro e busca para facilitar a inclusao, ao inves
de ir item a item.

//--Montagem da Tela

Define MsDialog oDlgPA4 Title "Busca de Regiões por AR" From 0,0 To 280, 500 Of oMainWnd Pixel
@ 5,5 LISTBOX oLstPA4 ;
VAR lVarMat ;
Fields HEADER "Cod. Regiaõ", "Descrição" ;
SIZE 245,110 On DblClick ( ConfPA4(oLstPA4:nAt, @aDadosPA4, @_bRet) ) ;
OF oDlgPA4 PIXEL

	oLstPA4:SetArray(aDadosPA4)

	oLstPA4:nAt := nList

	oLstPA4:bLine := { || {aDadosPA4[oLstPA4:nAt,1], aDadosPA4[oLstPA4:nAt,2]}}

	DEFINE SBUTTON FROM 122,5 TYPE 1 ACTION ConfPA4(oLstPA4:nAt, @aDadosPA4, @_bRet) ENABLE OF oDlgPA4 

	DEFINE SBUTTON FROM 122,40 TYPE 2 ACTION oDlgPA4:End() ENABLE OF oDlgPA4
	
Activate MSDialog oDlgPA4 Centered

Return _bRet*/


Static Function ConfPA4(_nPos, aDadosPA4, _bRet)

Local aCols := {}
Local aCpoRet := {}
Local n := 1
Private cCodigo

cCodigo := aDadosPA4[_nPos,1]

cPA4 := cCodigo

_bRet := .T.

aAdd(aCpoRet,{cCodigo})

oDlgPA4:End()

Return

User Function CSRETAR()

Return (cPA4) 

//-----------------------------------------------------------------------
/*/{Protheus.doc} csMontaTela
Funcao responsavel para receber os dados e exibir a Tela para o usuario.

@param	cCabecalho	Cabecalho a ser exibido na tela
		aDados		Array contendo o retorno conforme Query herdada.
		_bRet		Retorno .T. para que o campo seja setado com o valor.

@author	Douglas Parreja
@since	11/01/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csMontaTela( cCabecalho, aDados, _bRet )

	local oDlg, oLbx, oOrdem, oSeek, oPesq, oPnlTop, oPnlAll, oPnlBot, ONOMRK, oMrk
	local cRet, cOrdem := ''
	local cSeek   		:= Space(60)
	local aIndice 		:= {}	
	local nOrd    		:= 1
	local nOpc    		:= 0
	
	default aDados 	:= {}
	default cCabecalho	:= ""
	
	aAdd( aIndice, 'Cod.Região'	)
	aAdd( aIndice, 'Desc. Região'	)
	
	if ( len( aDados ) > 0 .and. len( aIndice ) > 0 )
		
		DEFINE MSDIALOG oDlg TITLE cCabecalho FROM 0,0 TO 308,600 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
		oDlg:lEscClose := .F.
		
		oPnlTop := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlTop:Align := CONTROL_ALIGN_TOP
		
		@ 1,001 COMBOBOX oOrdem VAR cOrdem ITEMS aIndice SIZE 70,36 ON CHANGE (nOrd:=oOrdem:nAt) PIXEL OF oPnlTop
		@ 1,082 MSGET    oSeek  VAR cSeek SIZE 160,9 PIXEL OF oPnlTop
		@ 1,247 BUTTON   oPesq  PROMPT 'Pesquisar' SIZE 50,11 PIXEL OF oPnlTop ACTION (csPesq(nOrd,cSeek,@oLbx))
		
		oPnlAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
		oPnlBot:Align := CONTROL_ALIGN_BOTTOM
		
		oLbx := TwBrowse():New(0,0,1000,1020,,{'Código Região','Região','Código AR'},,oPnlAll,,,,,,,,,,,,.F.,,.T.,,.F.)
		
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aDados )
		
		if len(aDados[oLbx:nAt]) > 2
			oLbx:bLine := {|| { aDados[oLbx:nAt,1], aDados[oLbx:nAt,2], aDados[oLbx:nAt,3] } }
		endif
			
		oLbx:bLDblClick := {|| Iif(csSeek(oLbx,@nOpc,@cRet,oLbx:nAt),oDlg:End(),NIL) }
		   
		@ 1,1  BUTTON oConfirm PROMPT 'Confirmar'  SIZE 40,11 PIXEL OF oPnlBot ACTION Iif(csSeek(oLbx,@nOpc,@cRet,oLbx:nAt),oDlg:End(),NIL)
		@ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPnlBot ACTION (oDlg:End())
		
		ACTIVATE MSDIALOG oDlg CENTER
		
		if nOpc == 1
			if !empty( cRet )
				cPA4 := cRet	// Nao alterar a variavel cPA4, visto que ela eh o retorno conforme SXB.
			else
				msgAlert("Não foi possível retornar o código da Região")
			endif	
			
		endif
	
	endif

	_bRet := .T.

return 

//-----------------------------------------------------------------------
/*/{Protheus.doc} csSeek
Funcao para retornar a descricao do Registro conforme posicionado.

@param	oLbx		Objeto da tela.
		nOpc		Opcao.
		cRet		Retorna descricao do registro posicionado.
		nLin		Linha posicionada na Tela.
		 	
@return	lRet	Retorna se foi selecionado registro na tela.				

@author	Douglas Parreja
@since	11/01/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csSeek( oLbx, nOpc, cRet, nLin )

	local lRet := .T.
	
	if ValType( oLbx ) <> "U"
		if len( oLbx:aArray ) > 0 			
			if (len(oLbx:aArray[nLin] ) > 0)
				if (len(oLbx:aArray[nLin,1]) > 0)
					cRet 	:= alltrim( oLbx:aArray[nLin,1] )
				endif					
			endif			
		endif
	endif
	nOpc := 1

return(lRet)

//-----------------------------------------------------------------------
/*/{Protheus.doc} csPesq
Funcao para posicionar no registro conforme o indice de busca informado.

@param	nOrd		Ordem de indice solicitado.
		cPesq		Pavalra digitada para busca.
		oLbx		Objeto da tela.

@author	Douglas Parreja
@since	16/05/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csPesq( nOrd,cPesq,oLbx )
	
	local nCol	:= nOrd
	local nP 	:= 0
	
	cPesq := Upper( alltrim( cPesq ) )
		
	if nCol > 0		
		//------------------------------
		// Indice por Codigo
		//------------------------------
		if nOrd == 1
			nP:= Ascan( oLbx:aArray, { |x| alltrim(x[1]) $ cPesq } )
		//------------------------------
		// Indice por Descricao
		//------------------------------			
		elseif nOrd == 2
			nP:= Ascan( oLbx:aArray, { |x| cPesq $ alltrim(x[2]) } )
		endif
		
		if nP > 0
			oLbx:nAt := nP
			oLbx:Refresh()
			oLbx:SetFocus()
		else
			msgInfo('Informação não localizada.','Pesquisar')
		endif
	else
		msgAlert('Opção de pesquisa inválida.','Pesquisar')
	endif

return