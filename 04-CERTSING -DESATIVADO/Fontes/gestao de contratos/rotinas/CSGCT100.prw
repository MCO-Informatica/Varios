#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "topconn.ch"
#Include 'FWMVCDef.ch'

//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+
//| Data       | Desenvolvedor | Descricao                                                                        | Versao | Jira     |
//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+
//| 14/08/2020 | Bruno Nunes   | Desenvolvida rotina de altera��o do campo descri��o do contrato.                 | 1.00   | PROT-157 |
//| 14/08/2020 | Bruno Nunes   | Melhorada rotina para altera��o da situ��o quando for 04-Vig�ncia.               | 1.01   | PROT-140 |
//+------------+---------------+----------------------------------------------------------------------------------+--------+----------+

#Define nFORM_STRUCT_MODEL 1
#Define nFORM_STRUCT_VIEW  2

//Vari�veis Est�ticas
Static cTitulo := "Gest�o de Contratos - Manuten��o exclusiva"

/*/{Protheus.doc} CSGCT100
Rotina MVC para controla alguns campos da CN9
@author Bruno Nunes
@since 14/08/2020
@version 1.0
@return Nil, Fun��o n�o tem retorno
/*/
User Function CSGCT100()

	local oBrowse as object
	if ignorarVld()
		oBrowse := FWLoadBrw("CSGCT100")
		oBrowse:Activate()
		oBrowse:DeActivate()
		oBrowse:Destroy()
		FreeObj( oBrowse )
		oBrowse := nil
	else
		msgAlert( "Seu grupo de contrato n�o permite acesso a essa rotina", "Restri��o")
	endif
Return Nil

/*/{Protheus.doc} BrowseDef
Rotina para funcionar o MVC, configura��o padr�o
@author Bruno Nunes
@since 14/08/2020
@version 1.0
@return Nil, Fun��o n�o tem retorno
/*/
static function BrowseDef()
	local oBrowse as object

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("CN9")
	oBrowse:SetDescription( cTitulo )

return oBrowse

/*/{Protheus.doc} MenuDef
Rotina para funcionar o MVC, configura��o padr�o
@author Bruno Nunes
@since 14/08/2020
@version 1.0
@return Nil, Fun��o n�o tem retorno
/*/
static function MenuDef()
	local aRotina := {}

	Add Option aRotina Title "Visualizar" 	   Action "ViewDef.CSGCT100" Operation OP_VISUALIZAR 	Access 0
	Add Option aRotina Title "Alterar" 		   Action "ViewDef.CSGCT100" Operation OP_ALTERAR 		Access 0
	Add Option aRotina Title "Trocar Situa��o" Action "u_SituaCN9()" 	     Operation OP_ALTERAR 		Access 0

return aRotina

/*/{Protheus.doc} ModelDef
Rotina para funcionar o MVC, configura��o padr�o
@author Bruno Nunes
@since 14/08/2020
@version 1.0
@return Nil, Fun��o n�o tem retorno
/*/
Static Function ModelDef()
	Local oModel := Nil //Cria��o do objeto do modelo de dados
	Local oStruct := Nil

	oStruct := FWFormStruct( nFORM_STRUCT_MODEL, "CN9" , { |x| ALLTRIM(x) $ 'CN9_FILIAL, CN9_NUMERO, CN9_REVISA, CN9_DESCRI, CN9_SITUAC' } ) //Cria��o da estrutura de dados utilizada na interface

	oModel := MPFormModel():New("MODEL_CN9",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) //Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres 
	oModel:AddFields("FIELDS_CN9",/*cOwner*/, oStruct) //Atribuindo formul�rios para o modelo

Return oModel

/*/{Protheus.doc} ViewDef
Rotina para funcionar o MVC, configura��o padr�o
@author Bruno Nunes
@since 14/08/2020
@version 1.0
@return Nil, Fun��o n�o tem retorno
/*/
Static Function ViewDef()
	Local oModel  := Nil
	Local oStruct := Nil
	Local oView   := Nil //Criando oView como nulo

	oModel  := FWLoadModel("CSGCT100") //Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	oStruct := FWFormStruct( nFORM_STRUCT_VIEW, "CN9", { |x| ALLTRIM(x) $ 'CN9_FILIAL, CN9_NUMERO, CN9_REVISA, CN9_DESCRI, CN9_SITUAC' } )  //Cria��o da estrutura de dados utilizada na interface do cadastro de Autor pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SBM_NOME|SBM_DTAFAL|'}

	oView   := FWFormView():New() //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
	oView:SetModel( oModel )
	oView:AddField( "VIEW_CN9", oStruct, "FIELDS_CN9" ) //Atribuindo formul�rios para interface
Return oView

/*/{Protheus.doc} SituaCN9
Rotina chamada no bot�o outras a��es, server para altera��o situa��o do contrato quando a situa��o for 04 para 05
@author Bruno Nunes
@since 14/08/2020
@version 1.0
@return Nil, Fun��o n�o tem retorno
/*/
user function SituaCN9()
	if CN9->CN9_SITUAC == "04"
		reclock( "CN9", .F. ) 
		CN9->CN9_SITUAC := "05"
		msunlock() 
		msgInfo( "Situa��o alterada para 05 - Vigente", "Situa��o")
	else
		msgInfo( "Somente altera quando a situa��o � 04 - Aprova��o", "Situa��o")
	endif
return

/*/{Protheus.doc} ignorarVld
Ignora a validacao quando o usuario faz parte do grupo juridico
@author Bruno Nunes
@since 14/08/2020
@version 1.0
@return Nil, Fun��o n�o tem retorno
/*/
static function ignorarVld()
	#define cSX6_GRUPO "GCT_GRUPOJUR" //Codigo do parametro SX6

	local lIgnora := .F. //Retorno da rotina
	local cGrupo  := ""  //Grupo do juridico que pode lan�ar planilha fixa
	local aGrp 	  := UsrRetGrp(UsrRetName(RetCodUsr())) //Array com grupos do usu�rio logado

	//Cria parametro caso nao exista
	if !GetMv( cSX6_GRUPO, .T. )
		CriarSX6( cSX6_GRUPO, 'C', 'CUSTOMIZADO. GRUPO DE APROVACAO TOTAL DO GCT', '000291' )
	endif
	cGrupo := GetMv( cSX6_GRUPO, .F. ) //C�digo do grupo do juridico

	//Busca no array o codigo do juridico
	lIgnora := ( aScan( aGrp, {|x| x == cGrupo } ) > 0)
return lIgnora
