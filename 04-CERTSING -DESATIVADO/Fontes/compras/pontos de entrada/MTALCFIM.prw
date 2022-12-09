//--------------------------------------------------------------------------
// Rotina | MTALCFIM   | Autor | Robson Goncalves       | Data | 24.03.2016
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada acionado no final da fun��o MaAlcDoc o objetivo
//        | � controlar a al�ada dos documentos. 
//--------------------------------------------------------------------------
// Retorno| N�o retornar nada para n�o interferir no processo padr�o.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
#Include 'Protheus.ch'
User Function MTALCFIM()
	Local aParam := {}
	Local lRet := NIL
		
	// aParam = { aDocto, dDataRef, nOper, cDocSF1, lResiduo }
	// aDocto = [1,01] N�mero do documento
	//        = [1,02] Tipo de Documento 
	//        = [1,03] Valor do Documento 
	//        = [1,04] C�digo do Aprovador
	//        = [1,05] C�digo do Usu�rio
	//        = [1,06] Grupo do Aprovador
	//        = [1,07] Aprovador Superior
	//        = [1,08] Moeda do Documento
	//        = [1,09] Taxa da Moeda 
	//        = [1,10] Data de Emiss�o do Documento
	//        = [1,11] Grupo de Compras
	aParam := AClone( ParamIXB )
	If aParam[ 3 ] == 2
		// aParam[ 1, 1 ] - N�mero do documento
		// aParam[ 1, 2 ] - Tipo do documento
		U_A610GLTr( aParam[ 1, 1 ], aParam[ 1, 2 ] )
	Endif
	
	//---------------------------------------------------------------------------//
	// Ap�s atualizar para o Protheus 12 identificamos que o primeiro aprovador  //
	// est� liberando totalmento o pedido de compras, enquanto o chamado est�    //
	// sendo atendido na TOTVS constru�mos este paliativo para sanar o problema. //
	// Autor: Robson Gon�alves - Data: 05/03/2018                                //
	//---------------------------------------------------------------------------//
	If aParam[ 3 ] == 4 // Aprovacao do documento
		// Param[1,1] N�mero do documento
		// Param[1,2] Tipo do documento
		lRet := AvalLibPC( aParam[ 1, 1 ], aParam[ 1, 2 ] )
	Endif 
Return( lRet )

/******
 *
 * Rotina para for�ar o bloqueio do PC - Solu��o de contorno.
 *
 ***/
Static Function AvalLibPC( cDoc, cTpDoc )
	Local cSQL := ''
	Local cTRB := GetNextAlias()
	
	Local lAlcada := .F.
	Local lRet := .T.
	
	// Localizar a al�ada. H� libera�a para fazer? Sim.
	// For�ar o bloqueio do pedido.
	
	cSQL := "SELECT COUNT(*) AS SCR_COUNT " 
	cSQL += "FROM   "+RetSqlName("SCR")+ " SCR " 
	cSQL += "WHERE  CR_FILIAL = "+ValToSql( xFilial( "SCR" ) )+" " 
	cSQL += "       AND CR_NUM = "+ValToSql( cDoc )+" "
	cSQL += "       AND CR_TIPO = "+ValToSql( cTpdoc )+" "
	cSQL += "       AND ( CR_STATUS = '01' OR CR_STATUS = '02' )"
	cSQL += "       AND SCR.D_E_L_E_T_ = ' ' "
	
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,, cSQL ), cTRB, .F., .T. )
	lAlcada := (cTRB)->( SCR_COUNT ) > 0
	(cTRB)->( dbCloseArea() )
	
	// Devolver o valor falso para que a rotina n�o libere o PC.
	If lAlcada
		lRet := .F.
	Endif
Return( lRet )