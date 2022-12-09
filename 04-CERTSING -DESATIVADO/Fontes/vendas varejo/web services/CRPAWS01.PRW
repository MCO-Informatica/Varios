#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.CH"

/*/{Protheus.doc} EREST_01
Ensinando Rest em ADVPL
@author Renato Ruy
@since 14/03/2018
@version undefined
@type function
/*/
User Function EREST01()	
Return
/*/{Protheus.doc} pedidos
Definição da estrutura do webservice
@author Renato Ruy
@since 14/03/2018
@type class
/*/
WSRESTFUL pedidos DESCRIPTION "Serviço REST para manipulação de pedidos"
WSDATA CPF As String //String que vamos receber via URL
WSDATA PERIODO As String //String que vamos receber via URL
WSDATA SENHA   As String //String que vamos receber via URL
 
WSMETHOD GET 	DESCRIPTION "Retorna o produto informado na URL" WSSYNTAX "/pedidos || /pedidos/{CPF}{PERIODO}" //Disponibilizamos um método do tipo GET
WSMETHOD POST 	DESCRIPTION "Atualiza senha do usuario" 		 WSSYNTAX "/pedidos/{SENHA}" //Disponibilizamos um método do tipo GET
 
END WSRESTFUL

WSRESTFUL periodos DESCRIPTION "Serviço REST para manipulação de pedidos"
WSDATA CPF As String //String que vamos receber via URL
WSDATA SENHA   As String //String que vamos receber via URL
 
WSMETHOD GET 	DESCRIPTION "Retorna os periodos de um parceiro" WSSYNTAX "/periodos || /periodos/{CPF}" //Disponibilizamos um método do tipo GET
 
END WSRESTFUL
/*/{Protheus.doc} GET
Processa as informações e retorna o json
@author Renato Ruy
@since 14/03/2018
@version undefined
@param oSelf, object, Objeto contendo dados da requisição efetuada pelo cliente, tais como:
   - Parâmetros querystring (parâmetros informado via URL)
   - Objeto JSON caso o requisição seja efetuada via Request Post
   - Header da requisição
   - entre outras ...
@type Method
/*/
WSMETHOD GET WSRECEIVE CPF WSSERVICE pedidos
//--> Recuperamos o produto informado via URL 
//--> Podemos fazer dessa forma ou utilizando o atributo ::aUrlParms, que é um array com os parâmetros recebidos via URL (QueryString)
Local cHeader	 := ::getheader('Authorization')
Local cCpf 	 := Self:CPF
Local cPeriodo := Self:PERIODO
Local aArea	 := GetArea()
Local oObjProd := Nil
Local cStatus	 := ""
Local cJson	 := ""
Local oDados	 := {}
Local cAuth	 := RTrim(GetMv("MV_CRPAWS1")) //Usuario e senha em base 64
Local cHref	 := RTrim(GetNewPar("MV_CRPAWSA","http://10.0.14.172:80/"))+cPeriodo+"/"
Local lRetorno := .T.

// define o tipo de retorno do método
::SetContentType("application/json")

//--------------------------------------
// Verifica usuario e senha do rest
//--------------------------------------
If ValType(cHeader)=="U"
	::SetHeader('WWW-Authenticate','Basic realm="myRealm"')
	SetRestFault(401,"A autenticação basic no header deve ser informada!")
	conout("A autenticação basic no header deve ser informada!")
	Return .F.
Endif

cHeader := StrTran(cHeader,"Basic ")

If cHeader <> cAuth
    lRetorno := .F.
    ::SetResponse('{"codigo": 1, "msg": "Usuario sem acesso!"}')
    conout("Usuario sem acesso!")
    Return .t.
EndIf

// define o tipo de retorno do método
::SetContentType("application/json")

If Select("TMPRED") > 0
	DbSelectArea("TMPRED")
	TMPRED->(DbCloseArea())
Endif

//Obter os dados das planilhas do usuario
Beginsql Alias "TMPRED"

	SELECT  ZZG_FILHO PARCEIRO,
			 ZZG_PERIOD PERIODO,
			 ZZG_CODENT CODENT,
			 Z3_DESENT DESCRICAO,
			 DECODE(ZZG_TIPO,1,'CANAL',
	                        2,'AC',
	                        4,'POSTO',
	                        7,'CAMPANHA',
	                        8,'FEDERACAO',
	                        10,'CLUBE') TIPO,
	        ZZG_NOMARQ LINK,
	        ZZG_VERSAO VERSAO,
	        ZZG_TOTAL TOTAL
	FROM %Table:ZZF% ZZF
	JOIN %Table:ZZG% ZZG 
	ON ZZG_FILIAL = %xFilial:ZZG% AND ZZG_CODENT = ZZF_CODENT AND
	   ZZG_ATIVO = '1' AND ZZG_PERIOD = %Exp:cPeriodo% AND ZZG.%NOTDEL%
	JOIN %Table:SZ3% SZ3 
	ON Z3_FILIAL = %xFilial:SZ3% AND Z3_CODENT = ZZG_CODENT AND
	   Z3_TIPENT IN ('1','2','4','7','8','9','10') AND SZ3.%NOTDEL%
	JOIN %Table:ZZ6% ZZ6 
	ON ZZ6_FILIAL = %xFilial:ZZ6% AND ZZ6_CODENT = ZZG_CODENT AND ZZ6_PERIOD = ZZG_PERIOD AND ZZ6_SALDO > 0 AND ZZ6.%NOTDEL%
	WHERE
	ZZF_FILIAL = %xFilial:ZZF% AND
	ZZF_CPF = %Exp:cCPF% AND
	ZZF.%NOTDEL%

Endsql

If TMPRED->(EOF())
	lRetorno := .F.
	conout("Sem informações cadastradas!")
	::SetResponse('{"codigo": 2, "msg": "Sem informações cadastradas!"}')
    Return .t.
Endif

//Cria um objeto da classe pedidos para fazer a serialização na função FWJSONSerialize
While !TMPRED->(EOF())
	oObjProd := pedidos():New(	RTrim(TMPRED->PERIODO),;
									RTrim(TMPRED->PARCEIRO),;
									RTrim(TMPRED->CODENT),;
								  	RTrim(TMPRED->DESCRICAO),;
								  	RTrim(TMPRED->TIPO),;
									cHref+AllTrim(TMPRED->LINK),;
									TMPRED->VERSAO,;
									TMPRED->TOTAL)
	AADD(oDados,oObjProd) 
	TMPRED->(DbSkip())
Enddo

//Fecha o arquivo para liberar o uso
TMPRED->(DbCloseArea())

// --> Transforma o objeto de pedidos em uma string json
cJson := FWJsonSerialize(oDados)

//Efetua formatações
cJson := StrTran(cJson,'"_classname":"PEDIDOS",',"")
cJson := StrTran(cJson,"PERIODO"	,"periodo")
cJson := StrTran(cJson,"PARCEIRO"	,"parceiro")
cJson := StrTran(cJson,"ENTIDADE"	,"entidade")
cJson := StrTran(cJson,"DESCRICAO" ,"descricao")
cJson := StrTran(cJson,"TIPO"		,"tipo")
cJson := StrTran(cJson,"LINK"		,"link")
cJson := StrTran(cJson,"VERSAO"		,"versao")
cJson := StrTran(cJson,"TOTAL"		,"total")

// --> Envia o JSON Gerado para a aplicação Client
::SetResponse(cJson)
RestArea(aArea)
ConOut("Retorno JSON: "+cJson)
Return(lRetorno)

WSMETHOD POST WSSERVICE pedidos
	Local cHeader	 := ::getheader('Authorization')
	Local cAuth	 := RTrim(GetMv("MV_CRPAWS1")) //Usuario e senha em base 64
	Local cNovaSenh:= Self:aQueryString[1,2]
	
	// define o tipo de retorno do método
	::SetContentType("application/json")
	
	//--------------------------------------
	// Verifica usuario e senha do rest
	//--------------------------------------
	If ValType(cHeader)=="U"
		::SetHeader('WWW-Authenticate','Basic realm="myRealm"')
		SetRestFault(401,"A autenticação basic no header deve ser informada!")
		conout("A autenticação basic no header deve ser informada!")
		Return .F.
	Endif
	
	cHeader := StrTran(cHeader,"Basic ")
	
	If cHeader <> cAuth
	    lRetorno := .F.
	    conout("Usuário sem acesso!")
	    ::SetResponse('{"codigo": 1, "msg": "Usuário sem acesso!"}')
    	Return .t.
	EndIf
	
	//Verifica se o padrao base64 está correto
	If !(":" $ Decode64(cNovaSenh))
		conout("usuário e senha informado não está no padrão base64")
	   ::SetResponse('{"codigo": 3, "msg": "usuário e senha informado não está no padrão base64"}')
    	Return .t.
	Endif
		 
	// Exemplo de retorno de erro
	If Putmv("MV_CRPAWS1",cNovaSenh)
	   // insira aqui o código para operação inserção
	   // exemplo de retorno de um objeto JSON
	   ::SetResponse('{"Response":"A senha foi alterada com sucesso"}')
	Else
	   ::SetResponse('{"codigo": 4, "msg": "não foi alterar a senha!"}')
	EndIf
Return(.T.)

//Classe de pedidos para realizar a serialização do objeto de produto
Class pedidos
	Data periodo		As String
	Data parceiro		As String
	Data entidade		As String
	Data descricao	As String
	Data tipo	  		As String
	Data link		 	As String
	Data versao		AS Integer
	Data total			AS Float
	
	Method New(periodo, parceiro, entidade, tipo, link, versao, total) Constructor 
EndClass

Method New(cperiodo, cParceiro, cEntidade, cDescricao, cTipoEnt, cLinkArq, nVersaoArq, nTotalArq) Class pedidos

::periodo	:= cperiodo
::parceiro	:= cParceiro
::entidade	:= cEntidade
::descricao:= cDescricao
::tipo		:= cTipoEnt
::link		:= cLinkArq
::versao	:= nVersaoArq
::total	:= nTotalArq

Return(Self)

/*/{Protheus.doc} GET
Processa as informações e retorna o json
@author Renato Ruy
@since 14/03/2018
@version undefined
@param oSelf, object, Objeto contendo dados da requisição efetuada pelo cliente, tais como:
   - Parâmetros querystring (parâmetros informado via URL)
   - Objeto JSON caso o requisição seja efetuada via Request Post
   - Header da requisição
   - entre outras ...
@type Method
/*/
WSMETHOD GET WSRECEIVE CPF WSSERVICE PERIODOS
//--> Recuperamos o produto informado via URL 
//--> Podemos fazer dessa forma ou utilizando o atributo ::aUrlParms, que é um array com os parâmetros recebidos via URL (QueryString)
Local cHeader	 := ::getheader('Authorization')
Local cCpf 	 := Self:CPF
Local aArea	 := GetArea()
Local oObjProd := Nil
Local cStatus	 := ""
Local cJson	 := ""
Local oDados	 := {}
Local cAuth	 := RTrim(GetMv("MV_CRPAWS1")) //Usuario e senha em base 64
Local lRetorno := .T.

// define o tipo de retorno do método
::SetContentType("application/json")

//--------------------------------------
// Verifica usuario e senha do rest
//--------------------------------------
If ValType(cHeader)=="U"
	::SetHeader('WWW-Authenticate','Basic realm="myRealm"')
	SetRestFault(401,"A autenticação basic no header deve ser informada!")
	conout("A autenticação basic no header deve ser informada!")
	Return .F.
Endif

cHeader := StrTran(cHeader,"Basic ")

If cHeader <> cAuth
    lRetorno := .F.
    conout("Usuario sem acesso!")
    ::SetResponse('{"codigo": 1, "msg": "Usuario sem acesso!"}')
    Return .T.
EndIf

If Select("TMPPER") > 0
	DbSelectArea("TMPPER")
	TMPPER->(DbCloseArea())
Endif

//Obter os dados das planilhas do usuario
Beginsql Alias "TMPPER"

	SELECT  ZZG_PERIOD
	FROM %Table:ZZF% ZZF
	JOIN %Table:ZZG% ZZG 
	ON ZZG_FILIAL = %xFilial:ZZG% AND ZZG_CODENT = ZZF_CODENT AND
	   ZZG_ATIVO = '1' AND ZZG.%NOTDEL%
	JOIN %Table:ZZ6% ZZ6 
	ON ZZ6_FILIAL = %xFilial:ZZ6% AND ZZ6_CODENT = ZZG_CODENT AND ZZ6_PERIOD = ZZG_PERIOD AND ZZ6_SALDO > 0 AND ZZ6.%NOTDEL%
	WHERE
	ZZF_FILIAL = %xFilial:ZZF% AND
	ZZF_CPF = %Exp:cCPF% AND
	ZZF.%NOTDEL%
	GROUP BY ZZG_PERIOD

Endsql

If TMPPER->(EOF())
	lRetorno := .F.
	conout("Sem informações cadastradas!")
	::SetResponse('{"codigo": 2, "msg": "Sem informações cadastradas!"}')
    Return .T.
Endif

//cria JSon para response
cJson := '['
While !TMPPER->(EOF())
	cJson += iif("periodo"$cJson,",","")
	cJson += '{"periodo":"'+ TMPPER->ZZG_PERIOD+'"}'
	AADD(oDados,oObjProd) 
	TMPPER->(DbSkip())
Enddo
cJson += ']'

//Fecha o arquivo para liberar o uso
TMPPER->(DbCloseArea())

// --> Envia o JSON Gerado para a aplicação Client
::SetResponse(cJson)
conout("Resposta JSON: "+cJson)
RestArea(aArea)
Return(lRetorno)
