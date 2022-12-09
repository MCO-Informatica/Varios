//////////////////////////////////////////////////////////////////////////////////////////////
//+----------------------------------------------------------------------------------------+//
//| CSAGVACL  | Cadastro de Contatos e Busca | AUTOR | Claudio Correa  | DATA | 12/11/2015 |//
//+----------------------------------------------------------------------------------------+//
//| DESCRICAO | Função para Busca e Cadastro de Contato                                    |//
//+----------------------------------------------------------------------------------------+//
//////////////////////////////////////////////////////////////////////////////////////////////

#include "Protheus.ch"
#include "Topconn.ch"

static cAc8 := ''

User Function CSAGVACL()

Local bRet := .F.
Local aHeader := {}

If Empty(M->PA0_CLILOC)

	Aviso( "Favor preencher o campo Cliente", "Não existe dados a consultar", {"Ok"} )

	Return .F.
	
Endif	

Private nPosEnt := aScan(aHeader, {|x| alltrim(x[2]) == "AC8_CODENT"})
Private nPosCont := aScan(aHeader, {|x| alltrim(x[2]) == "AC8_CODCON"})
Private cCodigo := Alltrim(&(ReadVar()))
 
bRet := FiltraAC8()

Return(bRet)

Static Function FiltraAC8()

Local cQuery
Local oLstAC8 := nil

Private oDlgAC8 := nil
Private _bRet := .F.
Private aDadosAC8 := {} 

//Query de contatos X clientes por entidade filtrada

cQuery := " SELECT * "
cQuery += " FROM "+RetSQLName("AC8")
cQuery += " WHERE AC8_FILIAL = '" + xFilial("AC8") + "' AND AC8_CODENT = '"+ M->PA0_CLILOC+M->PA0_LOJLOC+"'"
cQuery += " AND D_E_L_E_T_= ' ' " 

cAlias1:= CriaTrab(Nil,.F.) 

DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.) 

(cAlias1)->(DbGoTop()) 

If (cAlias1)->(Eof())

	Aviso( "Cadastro de Contatos", "Não existe dados a consultar", {"Ok"} )

	Return .F.

Endif

Do While (cAlias1)->(!Eof())

	cNome := POSICIONE('SU5',1,xFILIAL('SU5') + (cAlias1)->AC8_CODCON, 'U5_CONTAT')

	aAdd( aDadosAC8, { (cAlias1)->AC8_CODENT, (cAlias1)->AC8_CODCON, cNome } )
	
	(cAlias1)->(DbSkip())

Enddo 

DbCloseArea(cAlias1)

nList := aScan(aDadosAC8, {|x| alltrim(x[3]) == alltrim(cCodigo)}) 

iif(nList = 0,nList := 1,nList)

//--Montagem da Tela

Define MsDialog oDlgAC8 Title "Busca de Contatos por Cliente" From 0,0 To 280, 500 Of oMainWnd Pixel
@ 5,5 LISTBOX oLstAC8 ;
VAR lVarMat ;
Fields HEADER "Cod. Entidade", "Cod. Contato", "Nome Contato" ;
SIZE 245,110 On DblClick ( ConfAC8(oLstAC8:nAt, @aDadosAC8, @_bRet) ) ;
OF oDlgAC8 PIXEL

	oLstAC8:SetArray(aDadosAC8)

	oLstAC8:nAt := nList

	oLstAC8:bLine := { || {aDadosAC8[oLstAC8:nAt,1], aDadosAC8[oLstAC8:nAt,2], aDadosAC8[oLstAC8:nAt,3]}}

	DEFINE SBUTTON FROM 122,5 TYPE 1 ACTION ConfAC8(oLstAC8:nAt, @aDadosAC8, @_bRet) ENABLE OF oDlgAC8 

	DEFINE SBUTTON FROM 122,40 TYPE 2 ACTION oDlgAC8:End() ENABLE OF oDlgAC8 

Activate MSDialog oDlgAC8 Centered

Return _bRet


Static Function ConfAC8(_nPos, aDadosAC8, _bRet)

Local aCols := {}
Local aCpoRet := {}
Local n := 1
Private cCodigo

cCodigo := aDadosAC8[_nPos,2]

cAc8 := cCodigo

_bRet := .T.

aAdd(aCpoRet,{cCodigo})

oDlgAC8:End()

Return

User Function CSRETUR()

Return (cAc8) 