#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
// Programa.: A140EXC()
// Autor....: Alexandre Dalpiaz
// Data.....: 31/01/2011
// Descrição: PE na exclusao da pré-nota de entrada - altera status do romaneio e apaga nro da nota de entrada.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function A140EXC()
///////////////////////
Local aAlias	:= GetArea()

_cQuery := "UPDATE " + RetSqlName('PA6')
_cQuery += _cEnter + "SET PA6_NFE = '', PA6_STATUS = '05'"
_cQuery += _cEnter + "WHERE PA6_FILDES = '" + xFilial('SF1') + "' AND "
_cQuery += _cEnter + "PA6_FILORI = '" + SF1->F1_LOJA + "' AND "
_cQuery += _cEnter + "PA6_NFE = '" + SF1->F1_DOC + "'"
TcSqlExec(_cQuery)

RecLock('SF1',.f.)
SF1->F1_USUACLA := 'exc ' + upper(cUserName)
MsUnLock() 

// Muda o status referente a importa;'ao xml   
if  TCCanOpen( "UZQ" + cempant  +'0' ) 

	// Verifica se a NF existe no cadastro de XML e altera o status
	UZQ->( DbSetOrder( 3 ))
	If UZQ->( DbSeek( xFilial( "UZQ" ) + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
		If UZQ->UZQ_STATUS $ "2|6"   // Se status como pré-nota a classificar
			RecLock( "UZQ", .F. )
			UZQ_STATUS := "1"  		// Status passa a ser XML Importado.
			UZQ_NFGER  := ""
			UZQ_SERGER := ""
			//UZQ_CODFOR := ""
			//UZQ_LOJFOR := ""
			MsUnLock()
		Endif
	Endif 
	
Endif

_cQuery := "UPDATE " + RetSqlName('SC7')
_cQuery += _cEnter + " SET C7_NFISCAL = '', C7_ITEMNF = ''"
_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
_cQuery += _cEnter + " WHERE SC7010.D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND D1_FILIAL = '" + SF1->F1_FILIAL + "'"
_cQuery += _cEnter + " AND D1_DOC = '" + SF1->F1_DOC + "'"
_cQuery += _cEnter + " AND D1_SERIE = '" + SF1->F1_SERIE + "'"
_cQuery += _cEnter + " AND D1_FORNECE = '" + SF1->F1_FORNECE + "'"
_cQuery += _cEnter + " AND D1_LOJA = '" + SF1->F1_LOJA + "'"
_cQuery += _cEnter + " AND C7_FILENT = D1_FILIAL"
_cQuery += _cEnter + " AND C7_NUM = D1_PEDIDO"
_cQuery += _cEnter + " AND C7_ITEM = D1_ITEMPC"
_cQuery += _cEnter + " AND C7_PRODUTO = D1_COD"
_cQuery += _cEnter + " AND C7_NFISCAL = D1_DOC + D1_SERIE"
_cQuery += _cEnter + " AND C7_ITEMNF = D1_ITEM"
TcSqlExec(_cQuery)

RestArea(aAlias)
Return(.t.)
