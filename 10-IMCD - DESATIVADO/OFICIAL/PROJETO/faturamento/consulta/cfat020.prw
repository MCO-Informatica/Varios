#INCLUDE "PROTHEUS.CH"   
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE ITENSSC6 300

/* **************************************************************************
***Programa  *CFAT020   * Autor * Eneovaldo Roveri Jr.  * Data *03/12/2009***
*****************************************************************************
***Locacao   * Fabr.Tradicional *Contato *                                ***
*****************************************************************************
***Descricao * Consulta dos Ultimos ítens comprados pelo cliente/loja     ***
*****************************************************************************
***Parametros* Cliente                                                    ***
***          * Loja                                                       ***
*****************************************************************************
***Retorno   *                                                            ***
*****************************************************************************
***Aplicacao *                                                            ***
*****************************************************************************
***Uso       *                                                            ***
*****************************************************************************
***Analista Resp.*  Data  * Bops * Manutencao Efetuada                    ***
*****************************************************************************
***              *  /  /  *      *                                        ***
***              *  /  /  *      *                                        ***
************************************************************************** */


User Function CFAT020( cCliente, cLoja )
	Local _aArea:= GetArea()
	Local _lRet := .F.							// Retorno da funcao
	Local cArqQry, lQuery, cQuery
	Local _aAux    := {}
	Local aHeader2 := {}
	Local oLstBox, oDlg
	Local _d
	Local _nReg5   := SC5->( recno() )
	Local _nReg6   := SC6->( recno() )
	Local _cdMaior := ""
	Local _Item    := ""   
	Local aAreaSUA := SUA->(GetArea())
	Local aAreaSUB := SUB->(GetArea())

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "CFAT020" , __cUserID )

	Private aCols     := {}
	Private aPicture  := {}

	SA1->( dbSeek( xFilial( "SA1" ) + cCliente + cLoja ) )

	cArqQry := "QUERYSD2"
	lQuery := .T.
	cQuery := "SELECT SD2.D2_COD, SB1.B1_DESC, SD2.D2_EMISSAO, SD2.D2_QUANT, SD2.D2_UM, SD2.D2_PRCVEN, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_PEDIDO, SD2.D2_ITEMPV "
	cQuery += "FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += "LEFT JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SD2.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ <> '*'"
	cQuery += "WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
	cQuery += "SD2.D2_CLIENTE='"+cCliente+"' AND "
	cQuery += "SD2.D2_LOJA='"+cLoja+"' AND D2_TIPO = 'N' AND " && Incluso o tipo de NF normal, por tratar-se de consulta das últimas NF's do cliente e não existe compra por outro tipo que não seja nota normal.
	cQuery += "SD2.D_E_L_E_T_=' ' "
	cQuery += " ORDER BY SB1.B1_DESC, SD2.D2_COD, SD2.D2_EMISSAO DESC"

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cArqQry,.T.,.F.)


	_cdMaior := ""
	_Item    := ""

	dbSelectArea(cArqQry)

	DbGotop()
	Do While !eof()
		if _Item != (cArqQry)->D2_COD .or. (cArqQry)->D2_EMISSAO == _cdMaior

			SC5->( dbSeek( xFilial("SC5") + (cArqQry)->D2_PEDIDO ) )
			SE4->( dbSeek( xFilial("SE4") + SC5->C5_CONDPAG ) )
			SC6->( dbSeek( xFilial("SC6") + (cArqQry)->D2_PEDIDO + (cArqQry)->D2_ITEMPV ) )

			_Item    := (cArqQry)->D2_COD
			_cdMaior := (cArqQry)->D2_EMISSAO
			_d       := U__ctod( (cArqQry)->D2_EMISSAO )

			_aAux := {}
			aadd(_aAux, (cArqQry)->D2_COD )
			aadd(_aAux, (cArqQry)->B1_DESC )
			//      aadd(_aAux, (cArqQry)->D2_EMISSAO )
			aadd(_aAux, _d )
			aadd(_aAux, (cArqQry)->D2_QUANT )
			aadd(_aAux, (cArqQry)->D2_UM )
			aadd(_aAux, SC6->C6_XMOEDA ) 
			aadd(_aAux, (cArqQry)->D2_PRCVEN )
			If SC6->C6_XMOEDA == 1
				aadd(_aAux, SC6->C6_PRCVEN )    
			Else
				//aadd(_aAux, SC6->C6_XPRCMOE )
				aadd(_aAux, SC6->C6_XPRUNIT )
			Endif
			aadd(_aAux, SE4->E4_DESCRI )
			aadd(_aAux, (cArqQry)->D2_DOC )
			aadd(_aAux, (cArqQry)->D2_SERIE )
			aadd(_aAux, (cArqQry)->D2_PEDIDO )

			aadd(aCols,_aAux)

		endif

		DbSkip()
	Enddo

	//o if abaixo eh para nao dar erro de execucao no ListBox, se o Select nao retornar nenhum registro                 
	if len(aCols) == 0

		_aAux := {}
		aadd(_aAux, space( len( (cArqQry)->D2_COD ) ) )
		aadd(_aAux, space( len( (cArqQry)->B1_DESC ) ) )
		aadd(_aAux, ctod( " " ) )
		aadd(_aAux, 0.00 )
		aadd(_aAux, space( len( (cArqQry)->D2_UM ) ) )
		aadd(_aAux, 0 )
		aadd(_aAux, 0.00 )
		aadd(_aAux, 0.00 )
		aadd(_aAux, space( len( SE4->E4_DESCRI ) ) )
		aadd(_aAux, space( len( (cArqQry)->D2_DOC ) ) )
		aadd(_aAux, space( len( (cArqQry)->D2_SERIE ) ) )
		aadd(_aAux, space( len( (cArqQry)->D2_PEDIDO ) ) )

		aadd(aCols,_aAux)

	endif        

	DEFINE MSDIALOG oDlg FROM  15,6 TO 500,930 TITLE ('Ultimas Compras do Cliente por produtos' ) PIXEL

	@ 014,005 TO 051,460  LABEL '' OF oDlg 	PIXEL

	@ 020,007 SAY "Cliente"           SIZE  21,7 OF oDlg PIXEL
	@ 020,056 SAY cCliente            SIZE  49,8 OF oDlg PIXEL COLOR CLR_BLUE
	@ 030,007 SAY "Nome"              SIZE  32,7 OF oDlg PIXEL
	@ 030,056 SAY SA1->A1_NREDUZ      SIZE 140,8 OF oDlg PIXEL COLOR CLR_BLUE
	@ 040,007 SAY "Loja"              SIZE  49,7 OF oDlg PIXEL
	@ 040,056 SAY cLoja               SIZE  49,8 OF oDlg PIXEL COLOR CLR_BLUE

	aHeader2 := {"Item",;
	"Descrição",;
	"Ult.Compra",;
	"Quantidade",;
	"Unid",;
	"Moeda",;
	"Ult.Preço Praticado",;
	"Preço na Moeda",;
	"Condição de Pagamento",;
	"NF",;
	"Serie",;
	"Pedido" }
	aPicture := {"@!",;
	"@!",;
	"@D",;
	"@E 999,999,999.9999",;
	"@!",;
	"@E 9",;
	"@E 999,999,999.9999",;
	"@E 999,999,999.9999",;
	"@!",;
	"@!",;
	"@!",;
	"@!" }

	EnchoiceBar(oDlg,{||oDlg:End(),Nil},{||oDlg:End()},,)

	//Parametros RDListBox(lin,col,compr,alt, ,  , tamanho das colunas no grid)                       
	oLstBox := RDListBox(4,.80,455,165, aCols, aHeader2,{20,50,20,30,15,15,40,30,35,20,15,20},aPicture)
	//aHeader2 := {"Item",;
	//             "Descrição",;
	//             "Ult.Compra",;
	//             "Quantidade",;
	//             "Unid","Moeda",;
	//             "Ult.Preço Praticado",;
	//             "Preço na Moeda",;
	//             "Condição de Pagamento",;
	//             "NF",;
	//             "Serie","Pedido" }

	ACTIVATE MSDIALOG oDlg CENTERED                           

	dbSelectArea(cArqQry)
	dbCloseArea()

	SC5->( dbgoto( _nReg5 ) )
	SC6->( dbgoto( _nReg6 ) )

	RestArea( _aArea ) 
	RestArea( aAreaSUA)
	RestArea( aAreaSUB)
Return( _lRet )     


User Function _ctod( cDtos )
	Local _d := ctod( " " )
	Local _c := ""

	_c := Substr( cDtos, 1, 4 ) 
	_c := Substr( cDtos, 5, 2 ) + "/" + _c
	_c := Substr( cDtos, 7, 2 ) + "/" + _c

	_d := ctod( _c )

return( _d )