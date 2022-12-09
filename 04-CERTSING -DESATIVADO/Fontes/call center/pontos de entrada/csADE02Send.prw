#include "PROTHEUS.CH"
#include "TOPCONN.CH"

static cADE_KPROD := ""

//-----------------------------------------------------------------------
/*/{Protheus.doc} csADE02Send()
Este fonte tem por objetivo atraves da Consulta SXB ser exibido uma
Tela para o usuario com dados do PRODUTO conforme o retorno do 
campo Grupo(ADE_KGRUPO).


@author	Douglas Parreja
@since	13/05/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function csADE02Send()

	local cQuery, cRetQuery := ""
	  
	cQuery 		:= csQuery()
	cRetQuery 	:= u_csADE03xFun( 1, cQuery )	
	csProcess( cRetQuery )	

return .T.

//-----------------------------------------------------------------------
/*/{Protheus.doc} csProcess()
Funcao responsavel por realizar o processamento dos dados da Query 
passado como parametro e chamar funcao de exibicao da Tela.

@param	cRetQuery	Retorno da Query realizada.

@author	Douglas Parreja
@since	13/05/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csProcess( cRetQuery )

	local cCabecalho 	:= "Itens tabela Preço"
	local aDados		:= {} 
	local nX			:= 0 
	
	default cRetQuery	:= "" 
	
	if !empty( cRetQuery )
	
		while !(cRetQuery)->( eof() )
			nX++
			(cRetQuery)->( aAdd(aDados, { ;
											alltrim(DA1_CODPRO)		,;	//1-Cod. Produto
											DA1_DESGAR					,; 	//2-Desc. Produto
											alltrim(DA0_DESCRI)		,;	//3-Desc. Campanha
											u_csValor(DA1_PRCVEN)	,;	//4-Valor
											strZero(nX,4,0)			,;	//5-Item
											alltrim(DA1_CODGAR)		,;	//6-Cod. GAR
											alltrim(DA0_CODTAB) 	}))	//7-Cod. Tabela Produto X SZ3(Z3_CODTAB)
			(cRetQuery)->( dbSkip() )
		end
		(cRetQuery)->(dbCloseArea())		
	
		//----------------------------------------
		// Montagem da Tela
		//----------------------------------------
		if len( aDados ) > 0
			u_csADE03xFun( 3, cCabecalho, aDados, "PROD" )						
		endif
				
	else
		MsgInfo('Não foi possível encontrar registros de produtos e/ou Não foi preenchido o campo Grupo.', cCabecalho)
	endif


return

//---------------------------------------------------------------
/*/{Protheus.doc} csQueryProd
Funcao responsavel para realizar a Query nas tabelas:
	* DA0 - Tabela de Precos
	* DA1 - Itens da Tabela de Precos
	* SB1 - Produto
						  			  
@return	cQuery		Retorna a String da Query a ser processada.						

@author	Douglas Parreja
@since	13/05/2016
@version	11.8
/*/
//---------------------------------------------------------------
static function csQuery()

	local cQuery, cZ3_CODTAB, cCodTab := ""
	local lGrTab := .F.

	cQuery := " SELECT 				"
	cQuery += " DA1_CODPRO, 		"   
	cQuery += " DA1_DESGAR, 			" 	
	cQuery += " DA0_DESCRI, 		"	
	cQuery += " DA1_PRCVEN, 		"	
	cQuery += " DA1_ITEM,   		"
	cQuery += " DA1_CODGAR, 		" 
	cQuery += " DA0_CODTAB			"
	
	cQuery += " FROM " +RetSqlName("DA0")+" DA0 "
		cQuery += " INNER JOIN "+RetSqlName("DA1")+ " DA1 " 
			cQuery += " ON DA1_FILIAL = DA0_FILIAL "
			cQuery += " AND DA1_CODTAB = DA0_CODTAB "
			cQuery += " AND DA1_ATIVO = '1' "
		cQuery += " INNER JOIN "+RetSqlName("SB1")+ " SB1 "
			cQuery += " ON B1_FILIAL = '"+xFilial("SB1")+"' "
			cQuery += " AND B1_COD = DA1_CODPRO 
			cQuery += " AND SB1.D_E_L_E_T_= ' ' "
	cQuery += " WHERE "
	cQuery += " DA0_ATIVO = '1' "
	cQuery += " AND DA0.D_E_L_E_T_= ' ' "
	cQuery += " AND DA1.D_E_L_E_T_= ' ' "
	cQuery += " AND SB1.D_E_L_E_T_= ' ' "
	if !empty( cGrupo )
		dbSelectArea("SZ3")
		SZ3->(dbSetOrder(4))
		if dbSeek(xFilial("SZ3") + alltrim(cGrupo) )
			while !SZ3->(eof()) 
				if SZ3->Z3_TIPENT = '5'
					cZ3_CODTAB := alltrim(SZ3->(Z3_CODTAB))
					cCodTab := "'" + StrTran( cZ3_CODTAB, "," , "','") + "'" 
					cQuery += " AND DA0_CODTAB IN "+"("+cCodTab+")"
					lGrTab	:= .T.	
					exit				
				endif
				SZ3->(dbSkip())
			endDo
		endif
	endif
	
	if !( lGrTab )
		cQuery += " AND DA0_CODTAB IN ('') "
	endif
			
	cQuery += " ORDER BY DA0_CODTAB, DA1_ITEM "
	
return (cQuery)

//---------------------------------------------------------------
/*/{Protheus.doc} csQueryProd
Funcao responsavel para retornar no padrao SXB.
						  			  
@return	cQuery		Retorna caracter do campo a ser exibido.						

@author	Douglas Parreja
@since	13/05/2016
@version	11.8
/*/
//---------------------------------------------------------------
user function csADE02Receive()
return (cADE_KPROD)

