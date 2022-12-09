#include "PROTHEUS.CH"
#include "TOPCONN.CH"

static cADE_KGRUPO := ""

//-----------------------------------------------------------------------
/*/{Protheus.doc} csADE01Send()
Este fonte tem por objetivo atraves da Consulta SXB ser exibido uma
Tela para o usuario com dados do GRUPO.


@author	Douglas Parreja
@since	17/05/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function csADE01Send()

	local cQuery, cRetQuery := ""
	private aRetTela := {}
	  
	csTelaGrupo()
	if len( aRetTela ) > 0  
		cQuery 		:= csQuery()
		cRetQuery 	:= u_csADE03xFun( 1, cQuery )
		csProcess( cRetQuery )	
	endif

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

	local cCabecalho 	:= "Consulta dos Grupos
	local aDados		:= {} 
	
	default cRetQuery := "" 
	
	if !empty( cRetQuery )
		while !(cRetQuery)->( eof() )
			(cRetQuery)->( aAdd( aDados, { 	Z3_CODENT ,;
											Z3_DESENT ,;
											Z3_CODGAR ,;
											Z3_CODTAB ,;
											Z3_TIPENT  } ) )
			(cRetQuery)->( dbSkip() )
		end
		(cRetQuery)->(dbCloseArea())
		
		//----------------------------------------
		// Montagem da Tela
		//----------------------------------------
		if len( aDados ) > 0
			u_csADE03xFun( 2, cCabecalho, aDados, "GRUPO" )
			u_csADE02Send()
		endif
				
	else
		MsgInfo('Não foi possível encontrar registros de GRUPO.', cCabecalho)
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
@version 11.8
/*/
//---------------------------------------------------------------
static function csQuery()

	local cQuery 	:= ""
	local cCodTab	:= ""
	local cMVGrupo	:= alltrim(getMv('MV_SERVGRU'))		
	
	cQuery := " SELECT 
	cQuery += " Z3_CODENT,						"
	cQuery += " Z3_DESENT, 						"
	cQuery += " Z3_CODGAR,						"
	cQuery += " Z3_CODTAB,   					"
	cQuery += " Z3_TIPENT						"
	cQuery += " FROM " +RetSqlName("SZ3")+" SZ3	"
	cQuery += " WHERE Z3_TIPENT = '5' AND		"
	if len( aRetTela ) > 0
		//----------------------------------------
		// Parametrizado
		//----------------------------------------
		if aRetTela[1] == 1
			if !empty(cMVGrupo)
				cCodTab := "'" + StrTran( cMVGrupo, "," , "','") + "'"
				cQuery += " SZ3.Z3_CODGAR IN "+"("+ alltrim(cCodTab) +") AND "
			else
				msgAlert("Não será possível realizar a consulta através de 'Parametrização', pois o Parâmetro (MV_SERVGRU) não está preenchido.", "Atenção")
			endif
		endif
	endif
	cQuery += " SZ3.D_E_L_E_T_= ' '				" 
	cQuery += " ORDER BY Z3_DESENT ASC 			"
	
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
user function csADE01Receive()
cADE_KGRUPO := U_CSADE03G()
return (cADE_KGRUPO)

//---------------------------------------------------------------
/*/{Protheus.doc} csTelaGrupo
Funcao responsavel para exibir a Tela para que o usuario possa
realizar dois tipos de consulta:

1. Selecionar o Grupo de Entidades por forma de consulta rapida, 
ou seja, ja definida no parametro MV_SERVGRU o Grupo da SZ3,
que realizara a consulta atraves do campo Z3_CODGAR.
2. Caso escolha a opcao Todos, sera exibido para o usuario
todos os Grupos de Entidades, conforme a Query acima.						  			  			

@author	Douglas Parreja
@since	18/07/2016
@version 11.8
/*/
//---------------------------------------------------------------
static function csTelaGrupo()
 
	Local oDlg
	Local aItens := {}
	Local nRadio := 0
	Local oRadio
	Local bBlock := { |x| Iif( ValType( x ) == 'U', nRadio, nRadio:=x ) }
	
	
	DEFINE DIALOG oDlg TITLE "GRUPO - Entidades" FROM 180,180 TO 400,580 PIXEL    
		@ 010,010 SAY   "Escolha abaixo por qual modo deseja exibir os Grupos:" SIZE 500, 07 OF oDlg PIXEL
		@ 060,010 SAY   " * Parametrizado : Exibe apenas o(s) Grupo(s) informado no parâmetro. " SIZE 500, 07 OF oDlg PIXEL
		@ 070,010 SAY   " * Todos : Exibe todos os Grupos do Cadastro de Entidades.  " SIZE 500, 07 OF oDlg PIXEL
		nRadio := 1                         
		aItens := {'Parametrizado','Todos' }    
		oRadio := TRadMenu():New (30,50,aItens,bBlock,oDlg,,,,,,,,100,12,,,,.T.)     
			
		@ 90,60 BUTTON "&Confirmar" SIZE 32,10 PIXEL ACTION iif(csRadio(nRadio),oDlg:End(), csRadio(nRadio) ) 
		@ 90,100 BUTTON "&Sair"     SIZE 32,10 PIXEL ACTION oDlg:End()  
	ACTIVATE DIALOG oDlg CENTERED 
    
Return

//---------------------------------------------------------------
/*/{Protheus.doc} csRadio
Funcao responsavel para retornar que opcao o usuario selecionou.		

@author	Douglas Parreja
@since	18/07/2016
@version 11.8
/*/
//---------------------------------------------------------------
static function csRadio( nRadio )

	local lRet	:= .F.
	default nRadio := 0
	
	if nRadio > 0
		aAdd( aRetTela, nRadio )
		lRet := .T.
	endif
	
return lRet 