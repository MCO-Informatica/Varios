#include "protheus.ch"
#include "fwmvcdef.ch"
#include "TopConn.ch"

#define MVC_TITLE "Cadastro de Contatos"
#define MVC_ALIAS "SZ2"
#define MVC_VIEWDEF_NAME "VIEWDEF.ContatoTB"

//-------------------------------------------------------------------
/*/{Protheus.doc} U_ContatoTB
Fun��o principal da rotina MVC

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
user function ContatoTB(nOpcao)
	//Default nOpcao := 3

	Local aArea := GetArea()
	Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	DbSelectArea("SZ2")

	//If nOpcao == 1
//Visualiza��o - Verificar os itens inclu�dos
	//FWExecView( getTitle(MODEL_OPERATION_VIEW), MVC_VIEWDEF_NAME, MODEL_OPERATION_VIEW)

	//ElseIf nOpcao == 2
//Inser��o - Inclus�o de itens
	//FWExecView( getTitle(MODEL_OPERATION_INSERT), MVC_VIEWDEF_NAME, MODEL_OPERATION_INSERT)

	//ElseIf nOpcao == 3
//Altera��o - Por ser um grid, a altera��o j� vai permitir a exclus�o
	FWExecView( getTitle(MODEL_OPERATION_UPDATE), MVC_VIEWDEF_NAME, MODEL_OPERATION_UPDATE, , { || .T. }, , ,aButtons )

	//ElseIf nOpcao == 4
//Visualiza��o - Verificar os itens adicionados, alterados ou excluidos
	//FWExecView( getTitle(MODEL_OPERATION_VIEW), MVC_VIEWDEF_NAME, MODEL_OPERATION_VIEW)

	//EndIf

	RestArea(aArea)

return

//-------------------------------------------------------------------
/*/{Protheus.doc} getTitle
Retorna o t�tulo para a janela MVC, conforme opera��o

@param nOperation - Opera��o do modelo

@return cTitle - String com o t�tulo da janela

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function getTitle(nOperation)
	local cTitle as char
	cTitle := ""

	if nOperation == MODEL_OPERATION_INSERT
		cTitle := "Inclus�o"
	elseif nOperation == MODEL_OPERATION_UPDATE
		cTitle := "Altera��o"
	else
		cTitle := "Visualiza��o"
	endif

return cTitle

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Montagem do modelo dados para MVC

@return oModel - Objeto do modelo de dados

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function ModelDef()
	local oModel as object
	local oStrField as object
	local oStrGrid as object
	Local bCommit := {|| U_CmtSZ2()}

// Estrutura Fake de Field
	oStrField := FWFormModelStruct():New()

	oStrField:addTable("", {"C_STRING1"}, MVC_TITLE, {|| ""})
	oStrField:addField("String 01", "Campo de texto", "C_STRING1", "C", 15)

//Estrutura de Grid, alias Real presente no dicion�rio de dados
	oStrGrid := FWFormStruct(1, MVC_ALIAS)
	oModel := MPFormModel():New("MIDMAIN", /*< bPre >*/, /*< bPost >*/, bCommit /*< bCommit >*/, /*< bCancel >*/)

	oModel:addFields("CABID", /*cOwner*/, oStrField, /*bPre*/, /*bPost*/, {|oMdl| loadHidFld()})

	oModel:addGrid("GRIDID", "CABID", oStrGrid, /*bLinePre*/, /*bLinePost*/, /*bPre*/, /*bPost*/, {|oMdl| loadGrid(oMdl)})

	//oModel:GetModel("GRIDID"):SetUniqueline({"Z2_COD"}) //o intuito � que este campo n�o se repita

	oModel:setDescription(MVC_TITLE)

	//oModel:GetModel("GRIDID"):SetUseOldGrid(.T.) //Finalizo setando o modelo antigo de Grid, que permite pegar aHeader e aCols

// � necess�rio que haja alguma altera��o na estrutura Field
	oModel:setActivate({ |oModel| onActivate(oModel)})

	oModel:GetModel("GRIDID"):SetUseOldGrid(.T.)

return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} onActivate
Fun��o est�tica para o activate do model

@param oModel - Objeto do modelo de dados

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function onActivate(oModel)

//S� efetua a altera��o do campo para inser��o
	if oModel:GetOperation() == MODEL_OPERATION_INSERT
		FwFldPut("C_STRING1", "FAKE" , /*nLinha*/, oModel)
	endif

return

//-------------------------------------------------------------------
/*/{Protheus.doc} loadGrid
Fun��o est�tica para efetuar o load dos dados do grid

@param oModel - Objeto do modelo de dados

@return aData - Array com os dados para exibi��o no grid

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function loadGrid(oModel)
	local aData as array
	//local cAlias as char
	//local cWorkArea as char
	//local cTablename as char
	Local cSql := ""
/*
	cWorkArea := Alias()
	cAlias := GetNextAlias()
	cTablename := "%" + RetSqlName(MVC_ALIAS) + "%"

	BeginSql Alias cAlias
    SELECT *, R_E_C_N_O_ RECNO
      FROM %exp:cTablename%
    WHERE D_E_L_E_T_ = ' '
	EndSql
*/
	If INCLUI

		cSql := "SELECT * FROM "+RetSqlName("SZ2")+" SZ2 WHERE SZ2.Z2_CLIENTE = '"+M->(A1_COD+A1_LOJA)+"' AND SZ2.D_E_L_E_T_<>'*' AND SZ2.Z2_FILIAL = '"+xFilial("SA1")+"' "

	else

		cSql := "SELECT * FROM "+RetSqlName("SZ2")+" SZ2 WHERE SZ2.Z2_CLIENTE = '"+SA1->(A1_COD+A1_LOJA)+"' AND SZ2.D_E_L_E_T_<>'*' AND SZ2.Z2_FILIAL = '"+xFilial("SA1")+"' "


	Endif

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	TCQuery ChangeQuery(cSql) New Alias "QRY"


	aData := FwLoadByAlias(oModel, "QRY" /*cAlias*/, MVC_ALIAS, /*"Z2_CLIENTE"*/, /*lCopy*/, .T.)

	//(cAlias)->(DBCloseArea())


	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf
/*
	if !Empty(cWorkArea) .And. Select(cWorkArea) > 0
		DBSelectArea(cWorkArea)
	endif
*/

return aData

//-------------------------------------------------------------------
/*/{Protheus.doc} loadHidFld
Fun��o est�tica para load dos dados do field escondido

@param oModel - Objeto do modelo de dados

@return Array - Dados para o load do field do modelo de dados

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function loadHidFld(oModel)
return {""}

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Fun��o est�tica do ViewDef

@return oView - Objeto da view, interface

@author Daniel Mendes
@since 10/07/2020
@version 1.0
/*/
//-------------------------------------------------------------------
static function viewDef()
	local oView as object
	local oModel as object
	local oStrCab as object
	local oStrGrid as object

// Estrutura Fake de Field
	oStrCab := FWFormViewStruct():New()

	oStrCab:addField("C_STRING1", "01" , "String 01", "Campo de texto", , "C" )

//Estrutura de Grid
	oStrGrid := FWFormStruct(2, MVC_ALIAS )
	oModel := FWLoadModel("ContatoTB")
	oView := FwFormView():New()

	oView:AddUserButton( 'Imprimir', 'CLIPS', {|oView| U_RELSZ2() } )

	//oStrGrid:SetProperty("Z2_CLIENTE",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'SA1->A1_COD+SA1->A1_LOJA'))

	oView:setModel(oModel)
	oView:addField("CAB", oStrCab, "CABID")
	oView:addGrid("GRID", oStrGrid, "GRIDID")

	oView:AddIncrementField("GRIDID","Z2_COD") //Soma 1 ao campo de Item

	oView:createHorizontalBox("TOHIDE", 0 )
	oView:createHorizontalBox("TOSHOW", 100 )
	oView:setOwnerView("CAB", "TOHIDE" )
	oView:setOwnerView("GRID", "TOSHOW")

	oView:setDescription( MVC_TITLE )

return oView



User Function CmtSZ2()
	Local aArea     := GetArea()

//Vari�vel de controle da grava��o, por enquanto est� TRUE mas poder� ser FALSE
	Local lRet      := .T.

//Capturo o modelo ativo, no caso o objeto de modelo(oModel) que est� sendo manipulado em nossa aplica��o
	Local oModel        := FwModelActive()

//Criar modelo de dados MASTER/CABE�ALHO com base no model geral que foi capturado acima
//Carregando o modelo do CABE�ALHO

	Local oModelItem     := oModel:GetModel("GRIDID")

/*
Capturo os valores que est�o no CABE�ALHO, atrav�s do m�todo GetValue
Carrego os campos dentro das vari�veis, estas vari�veis ser�o utilizadas para
inserir o que foi digitao na tela, dentro do banco
*/
	Local cFilSZ2   :=  xFilial("SZ2")
	Local cCli      :=  SA1->A1_COD+SA1->A1_LOJA

//Vari�veis que far�o a captura dos dados com base no aHeader e aCols
	Local aHeaderAux    := oModelItem:aHeader //Captura o aHeader do Grid
	Local aColsAux      := oModelItem:aCols   //Captura o aCols do Grid

/*Precisamos agora pegar a posi��o de cada campo dentro do grid
Lembrando que neste caso, s� precisamos pegar a posi��o dos campos que n�o
est�o no cabe�alho, somente os campos da GRID
*/
	Local nPosCod     :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z2_COD")})
	Local nPosNome    :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z2_NOME")})
	Local nPosDDD     :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z2_DDD")})
	Local nPosTel     :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z2_TELEFON")})
	Local nPosFax     :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z2_FAX")})
	Local nPosDDDC    :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z2_DDDC")})
	Local nPosCel     :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z2_CELULAR")})
	Local nPosMail    :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z2_EMAIL")})
	Local nPosDepto   :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z2_DEPTO")})
	Local nPosFunc    :=  aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z2_FUNCAO")})

//Preciso pegar a linha atual que o usu�rio est� posicionado, para isso usarei uma vari�vel
//Esta vari�vel ir� para dentro do FOR
	Local nLinAtu       := 0


//Preciso identificar qual o tipo de opera��o que o usu�rio est� fazendo(INCLUS�O/ALTERA��O/EXCLUS�O)
	//Local cOption       := oModelCabec:GetOperation()

/*Fazemos a sele��o da nossa �rea que ser� manipulada, ou seja, 
colocamos a tabela SZ2, em evid�ncia juntamente com um �ndice de ordena��o

OU SEJA...->>> VOC� FALA PAR A O PROTHEUS O SEGUINTE: 
"-E a� cara a partir de agora eu vou modificar a SZ2"=
*/

	DbSelectArea("SZ2")
	SZ2->(DbSetOrder(1)) //�NDICE FILIAL+CLIENTE+CODIGO


	For nLinAtu:= 1 to Len(aColsAux) //Mede o tamanho do aCOls, ou seja quantos itens existem no grid
		//Por�eeeeeem, antes de tentar inserir, eu devo verificar, se a linha est� deletada
		IF aColsAux[nLinAtu][Len(aHeaderAux)+1] //Express�o para verificar se uma linha est� exclu�da no aCols(SE ESTIVER EXCLU�DA ELE VERIFICA SE EST� NO BANCO
			//Se a linha estiver deletada, eu ainda preciso verificar se a linha deletada est� inclusa ou n�o no sistema
			SZ2->(DbSetOrder(1)) //�NDICE FILIAL+NUMEROPEDIDO+ITEM
			IF SZ2->(DbSeek(AllTrim(cFilSZ2) + cCli + aColsAux[nLinAtu,nPosCod])) //Faz a busca, se encontrar, ele deve deletar do banco
				RECLOCK("SZ2",.F.)
				DbDelete()
				SZ2->(MSUNLOCK())
			ENDIF

		ELSE //SE A LINHA N�O ESTIVER EXCLU�DA, FA�O A ALTERA��O
        /*EMBORA SEJA UMA ALTERA��O, EU POSSO TER NOVOS ITENS INCLUSOS NO MEU PEDIDO
        SENDO ASSIM, PRECISO VALIDAR SE ESTES ITENS EXISTEM NO BANCO DE DADOS OU N�O
        CASO ELES N�O EXISTAM, EU FA�O UMA INCLUS�O RECLOCK("SZ2",.T.)
        */
			SZ2->(DbSetOrder(1)) //�NDICE FILIAL+NUMEROPEDIDO+ITEM
			IF SZ2->(DbSeek(AllTrim(cFilSZ2) + cCli + aColsAux[nLinAtu,nPosCod])) //Faz a busca, se encontrar, ele FAR� UMA ALTERA��O
				RecLock("SZ2",.F.) //.T. para inclus�o .F. para altera��o/exclus�o
				//DADOS DO CABE�ALHO
				Z2_FILIAL       :=  cFilSZ2 //Vari�vel com o dado da filial no cabe�alho
				Z2_CLIENTE      :=  cCli  //vari�vel com o dado do numero do pedido no cabe�alho
				Z2_NOME         :=  U_RmvChEsp(aColsAux[nLinAtu,nPosNome])
				Z2_COD          :=  aColsAux[nLinAtu,nPosCod] //array acols, posicionado na linha atual
				Z2_DDD          :=  aColsAux[nLinAtu,nPosDDD]
				Z2_TELEFON      :=  aColsAux[nLinAtu,nPosTel]
				Z2_DDDC	        :=  aColsAux[nLinAtu,nPosDDDC]
				Z2_CELULAR      :=  aColsAux[nLinAtu,nPosCel]
				Z2_FAX          :=  aColsAux[nLinAtu,nPosFax]
				Z2_EMAIL        :=  aColsAux[nLinAtu,nPosMail]
				Z2_DEPTO        :=  aColsAux[nLinAtu,nPosDepto]
				Z2_FUNCAO       :=  aColsAux[nLinAtu,nPosFunc]
				SZ2->(MSUNLOCK())
			ELSE //SE ELE N�O ACHAR, � PORQUE O ITEM N�O EXISTE AINDA NA BASE DE DADOS, LOGO IR� INCLUIR
				RecLock("SZ2",.T.) //.T. para inclus�o .F. para altera��o/exclus�o
				//DADOS DO CABE�ALHO
				Z2_FILIAL       :=  cFilSZ2 //Vari�vel com o dado da filial no cabe�alho
				Z2_CLIENTE      :=  cCli  //vari�vel com o dado do numero do pedido no cabe�alho
				Z2_NOME         :=  U_RmvChEsp(aColsAux[nLinAtu,nPosNome])
				Z2_COD          :=  aColsAux[nLinAtu,nPosCod] //array acols, posicionado na linha atual
				Z2_DDD          :=  aColsAux[nLinAtu,nPosDDD]
				Z2_TELEFON      :=  aColsAux[nLinAtu,nPosTel]
				Z2_DDDC	        :=  aColsAux[nLinAtu,nPosDDDC]
				Z2_CELULAR      :=  aColsAux[nLinAtu,nPosCel]
				Z2_FAX          :=  aColsAux[nLinAtu,nPosFax]
				Z2_EMAIL        :=  aColsAux[nLinAtu,nPosMail]
				Z2_DEPTO        :=  aColsAux[nLinAtu,nPosDepto]
				Z2_FUNCAO       :=  aColsAux[nLinAtu,nPosFunc]
				SZ2->(MSUNLOCK())
			ENDIF
		ENDIF
	Next n //Incremento de linha do for

	RestArea(aArea)

Return .T.



User Function SeqCntTB()
	Local cSql := ""
	Local cRet := ""

	If INCLUI

		cSql := "SELECT MAX(Z2_COD) COD FROM "+RetSqlName("SZ2")+" SZ2 WHERE SZ2.Z2_CLIENTE = '"+M->(A1_COD+A1_LOJA)+"' AND SZ2.D_E_L_E_T_<>'*' AND SZ2.Z2_FILIAL = '"+xFilial("SA1")+"' "

	else

		cSql := "SELECT MAX(Z2_COD) COD FROM "+RetSqlName("SZ2")+" SZ2 WHERE SZ2.Z2_CLIENTE = '"+SA1->(A1_COD+A1_LOJA)+"' AND SZ2.D_E_L_E_T_<>'*' AND SZ2.Z2_FILIAL = '"+xFilial("SA1")+"' "


	Endif

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	TCQuery ChangeQuery(cSql) New Alias "QRY"

	cRet := Soma1(QRY->COD)

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

Return cRet
