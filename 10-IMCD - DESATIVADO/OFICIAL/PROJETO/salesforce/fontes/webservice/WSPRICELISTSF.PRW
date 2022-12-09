#INCLUDE "protheus.ch"
#INCLUDE "restful.ch"
#include "json.ch"

/*/{Protheus.doc} WSPRICELISTSF
//Webservice que retorna informações referente
//à lista de preços 
@author marcio.katsumata
@since 13/02/2020
@version 1.0
/*/
WSRESTFUL WSPRICELISTSF Description "Webservice of price list"
	WSDATA product    AS STRING
	WSDATA quantity   AS INTEGER 
	WSDATA list       AS STRING 
	WSDATA currency       AS STRING 

	WSMETHOD POST    DESCRIPTION "Return price list/cost of product"   WSSYNTAX "/WSPRICELISTSF"

	
END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} POST
Retorna o preço de lista e custo do produto
@author  marcio.katsumata
@since   05/12/2019
@version 1.0
@param   product , character , código do produto
@param    quantity , number    , quantidade
@param    list, character , código da tabela de preços
/*/
//-------------------------------------------------------------------
WSMETHOD POST WSSERVICE WSPRICELISTSF
	local lPost     as logical
	local cJsonReq as character
	local cAliasDA0 as character
	local oSfUtils as object
	local aInfWeb  as array
	local oServer  as object
	local lOtherSrv as logical
	Local oParser as object

	cJsonReq:= self:getContent()
	oParser := JSON():New( cJsonReq)
	oParser := oParser:Parse()
	If oParser:IsJSON()
   		// "John"
   		self:product := oParser:Object()[#'product'] 
		self:quantity := oParser:Object()[#'quantity']
		self:list     := oParser:Object()[#'list']    
		cEmpChk := substr(self:product,at("_",self:product)+2, len(self:product) - at("_",self:product)+1)
		cMsgError:= ""
		cAliasDA0 := getNextAlias()
		oSfUtils := SFUTILS():new()
		lOtherSrv := .F.
		aInfWeb := oSfUtils:getIni(.T.)
		lPost     := .T. 
		nPosInf := aScan(aInfWeb, {|aEmp|cEmpChk $ aEmp[1]})
		cIpiEnd := ""
		nPort   := 0
		cEnv    := ""
		cEmpAtu := ""
		cFilAtu := ""


		if nPosInf  > 0
			//-----------------------------
			//Escolha da empresa DE/PARA
			//-----------------------------
    		nQtdPar := len(aInfWeb[nPosInf][3])

			if nQtdPar == 5
				cIpiEnd :=  alltrim(aInfWeb[nPosInf][3][1])
				nPort   :=  val(aInfWeb[nPosInf][3][2])
				cEnv    :=  alltrim(aInfWeb[nPosInf][3][3])
				cEmpAtu :=  alltrim(aInfWeb[nPosInf][3][4])
				cFilAtu :=  alltrim(aInfWeb[nPosInf][3][5])
			endif 

			if !(alltrim(GetServerIP()) == cIpiEnd  .and. alltrim(GETENVSERVER()) == cEnv)

				//----------------------------------------
				//Prepara o objeto de conexão ao ambiente.
				//----------------------------------------
				oServer := TRPC():new( cEnv)
				lPost := oServer:connect( cIpiEnd, nPort) 
				lOtherSrv := .T.

			endif
		endif

		if !empty(cEmpAtu) .and. lPost
			if lOtherSrv
				aRetProc := oServer:callProc("U_WSPRICESF", cEmpAtu, cFilAtu, self:list, self:product, self:quantity )
			else
				aRetProc := U_WSPRICESF( cEmpAtu, cFilAtu, self:list, self:product, self:quantity )
			endif

			if aRetProc[1]
				//--------------------------------------
				//Retorna como resposta o JSON do Model
				//--------------------------------------
				if !empty(aRetProc[2])
					//------------------------------------
					// define o tipo de retorno do método
					//------------------------------------
					::SetContentType("application/json; charset=UTF-8")
					self:setResponse(aRetProc [2])
				else
					cMsgError := "Error JSON build."
					lPost := .F.
				endif	
			else
				cMsgError := aRetProc[3]
				lPost := .F.
			endif
		else
			cMsgError := "Invalid company. Empresa/Company: "+cEmpChk
			lPost := .F.

		endif

		if lOtherSrv
			oServer:disconnect()
		endif
	else
		cMsgError := "Invalid JSON. "
		lPost := .F.
	endif
	if !lPost
		SetRestFault(400, cMsgError, .t.)
	endif
Return lPost


user function WSPRICESF(cEmpAtu, cFilAtu, cList, cProductId, nQuantity)

	local aRetProc as array
	local lPost     as logical
	local cJson    as character
	local oJson    as object
	local oResult  as object
	local nPrcVen  as numeric
	local cCodTab  as character
	local cProduto as character
	local nRecDA0  as numeric
	local cAliasDA0 as character
	local aTabela  as array

	aRetProc := {}
	RpcClearEnv()
	RpcSetType(3)
	RPCSetEnv(cEmpAtu,cFilAtu)

	//-------------------------
	//Instância do json object
	//-------------------------
	oJson := JsonBld():new()

	cList := PADR(UPPER(cList), tamSx3("DA0_DESCRI")[1])
	cProductId:= PADR(substr(cProductId,1,at("_",cProductId)-1), tamSx3("B1_COD")[1])
	nPrcVen  := 0
	cProduto := ""
	cCodTab  := ""
	nRecDA0  := 0
	aTabela  := {}
	cAliasDA0 := getNextAlias()
	lPost := .T.

	dbSelectArea("ACY")
	//ACY->(dbSetOrder(3))
	DBOrderNickname("LOB1")

	dbSelectArea("DA0")
	DA0->(dbSetOrder(1))

	dbSelectArea("DA1")
	DA1->(dbSetOrder(1)) 

	dbSelectArea ("SB1")
	SB1->(dbSetOrder(1))

	if ACY->(dbSeek(xFilial("ACY")+PADR(cList,tamsx3("ACY_XDESC")[1])))


		//---------------------------------------------
		//Validando o código do produto
		//---------------------------------------------
		if SB1->(dbSeek(xFilial("SB1")+cProductId ))
			cProduto := SB1->B1_COD
		else
			cMsgError := "Invalid product :"+cProductId
			lPost := .F.
		endif

		//------------------------------------------
		//Validação da tabela de preço
		//------------------------------------------
		if lPost
			beginSql alias cAliasDA0
				SELECT R_E_C_N_O_ AS REGISTRO 
				FROM %table:DA0% DA0
				WHERE DA0.DA0_CODTAB = %exp:ACY->ACY_CODTAB% AND
					  DA0.DA0_ATIVO  = '1' AND
					  DA0.%notDel%
			endSql

			if (cAliasDA0)->(!eof())
				nRecDA0 := (cAliasDA0)->REGISTRO
			else
				lPost := .f.
				cMsgError := "Invalid price list . Price list: "+cList
			endif

			(cAliasDA0)->(dbCloseArea())
		endif

		//------------------------------------------
		//Validação da vigência da tabela de preço
		//------------------------------------------
		if lPost 
			DA0->(dbGoTo(nRecDA0))
			if (empty(DA0->DA0_DATDE) .or. (!empty(DA0->DA0_DATDE) .and. DA0->DA0_DATDE <= dDataBase));
					 .and. (empty(DA0->DA0_DATATE) .or. (!empty(DA0->DA0_DATATE) .and. dDataBase<= DA0->DA0_DATATE))
				cCodTab := DA0->DA0_CODTAB

			else
				cMsgError := "Invalid price list -  out of date. Price list: "+cList
				lPost := .F.
			endif
		endif
		//--------------------------------------------------------------------------
		//Validação do produto na tabela de preço e resgata o preço/custo do produto
		//--------------------------------------------------------------------------
		if lPost .and.  DA1->(dbSeek(xFilial("DA1") + cCodTab + cProduto))
			while (DA1->(DA1_FILIAL + DA1_CODTAB + DA1_CODPRO) ==  xFilial("DA1") + cCodTab + cProduto) .AND. empty(nPrcVen)
				if DA1->DA1_ATIVO == '1'
					aTabela := U_BSCMARG(cCodTab,cProduto,nQuantity,3)
				endif
				DA1->(dbSkip())
			enddo
			if empty(aTabela) 
				cMsgError := "Invalid price list. Price list: "+cList+" product :"+cProduto
				lPost := .F.
			endif
		else
			if empty(cMsgError)
				cMsgError := "Invalid price list. Price list: "+cList+" product :"+cProduto
			endif
			lPost := .F.
		endif


		if lPost


			oJson[#'product']  := alltrim(cProduto)
			oJson[#'list']     := alltrim(cList)
			oJson[#'listCode'] := cCodTab
			oJson[#'quantity'] := nQuantity
			oJson[#'CurrencyIsoCode'] := aTabela[1]
			oJson[#'unitPrice']:= aTabela[2]
			oJson[#'unitCost'] := aTabela[3]
			oJson[#'MargIdeal'] := aTabela[4]
			oJson[#'MargMin'] := aTabela[5]

			//----------------------------------
			//Convertendo JSON Object em string
			//----------------------------------
			oResult := JSON():New( oJson )
			cJson := oResult:Stringify()

			//------------------------------------
			//Convertendo em UTF8 o JSON
			//------------------------------------
			cJson := encodeUtf8(cJson)


			aSize(aTabela,0)
			freeObj(oJson)

		endif
	else
		cMsgError := "Invalid price list. Price list: "+cList
		lPost := .F.
	endif

	aadd(aRetProc ,lPost)
	aadd(aRetProc ,cJson)
	aadd(aRetProc ,cMsgError)
	
return aRetProc

User function start_debug()

StartJob("HTTP_START",getEnvServer(),.f.)
Alert("fica parado")


Return
