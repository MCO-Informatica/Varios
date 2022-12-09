#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} VNDA110

Funcao criada para incluir cliente de faturamento do site na base protheus.

@author Totvs SM - David
@since 20/07/2011
@version P11

/*/

User Function VNDA110(	nOpc,	cCodigo,	cLoja,		cPessoa,	cNome,		cNomeReduz,;
cTipo,	cEndereco,	cBairro,	cCEP,		cMunicipio,	cEstado,;
cPais,	cDescPais,	cDDD,		cTelefone,	cCGC,		cRG,;
cEmail,	cInEst,		cInMun,		cSufra,		cNpSite,	cId,;
aDadEnt, cPedLog, cIbge, cLograd)

Local aClient	:= {}
Local lRet 		:= .T.
Local cMsg 		:= ""
Local cGrpTrib	:= ""
Local cContrib  := ""
Local cObserv	:= iif(nOpc = 3, "INCLUIDO EM "+DtoC(Date())+" AS "+Time(),"ALTERADO EM "+DtoC(Date())+" AS "+Time())
Local lPA7		:= .F.

Local nI 		:= 0
Local aAutoErr  := {}    
Local aMun		:= {}
Local cCodMun   :=' '
local cCodMunE  :=' '

Private lMsErroAuto 	:= .F.
Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()

DEFAULT cNpSite := ""
DEFAULT cPedLog := ""
DEFAULT aDadEnt	:= {"", "", "", "", "", "", "", ""}

cObserv := "FONTE: "+ProcName(1)+" - "+cObserv

If Val(cSufra) = 0
	cSufra := ""
EndIf

//Renato Ruy - 14/08/2017
//Solicitante: Giovanni
//Quando a inscricao e preenchida por 0, retorna ISENTO
//Quando Bairro ou endereco esta em branco, grava CENTRO.
If Val(cInEst) == 0
	cInEst := "ISENTO"
Endif

If Empty(cEndereco) .Or. cEndereco == ",SN"
	cEndereco := "CENTRO"
Endif

If Empty(cBairro)
	cBairro := "CENTRO"
Endif
//Renato Ruy - 14/08/2017 - Fim da alteracao

If  (Upper(AllTrim(cInEst)) == "ISENTO")  .OR. (Upper(AllTrim(cInEst))== "ISENTA")  .OR. (Upper(AllTrim(cInEst))== ".")
	cContrib := "2"
Else
	cContrib := "1"
Endif


Do Case
	Case Alltrim(cEstado) == "SP"
		cGrpTrib := "001"
		
	Case !Empty(cEstado) .AND.Alltrim(cEstado) <> "SP" .AND. cPessoa == "F" .AND. ( Empty(cInEst) .OR. Upper(AllTrim(cInEst)) == "ISENTO" )
		cGrpTrib := "002"
		
	Case !Empty(cEstado) .AND. Alltrim(cEstado) <> "SP" .AND. cPessoa == "F" .AND. !Empty(cInEst) .AND. Upper(AllTrim(cInEst)) <> "ISENTO"
		cGrpTrib := "003"
		
	Case !Empty(cEstado) .AND. Alltrim(cEstado) <> "SP" .AND. cPessoa == "J" .AND. ( Empty(cInEst) .OR. Upper(AllTrim(cInEst)) == "ISENTO" )
		cGrpTrib := "002"
		
	Case !Empty(cEstado) .AND. Alltrim(cEstado) <> "SP" .AND. cPessoa == "J" .AND. !Empty(cInEst) .AND. Upper(AllTrim(cInEst)) <> "ISENTO"
		cGrpTrib := "003"
		
	Otherwise
		cGrpTrib := "999"
		
Endcase

If Empty(aDadEnt[5])
	lEntEndPri := .T.
Else
	lEntEndPri := .F.
EndIf

//Valida CEP na Tabela PA7
PA7->( DbSetOrder(1) )		// PA7_FILIAL + PA7_CODCEP
lPA7 := !PA7->( MsSeek( xFilial("PA7")+cCEP ) )
//Endereco do cliente
VldCep(cCEP, cLograd, cBairro, cMunicipio, cEstado, cIbge, lPA7)
cCodMun := PA7->PA7_CODMUN

//Endereco de entrega
//aDadEnt[1] cEndEnt
//aDadEnt[2] cBaiEnt
//aDadEnt[3] cNumEnt
//aDadEnt[4] cComEnt
//aDadEnt[5] cCepEnt
//aDadEnt[6] cCidEnt
//aDadEnt[7] cUfEnt
//aDadEnt[8] cIbge
//Valida CEP na Tabela PA7

if lEntEndPri

	PA7->( DbSetOrder(1) )		// PA7_FILIAL + PA7_CODCEP
	lPA7 := !PA7->( MsSeek( xFilial("PA7")+aDadEnt[5] ) )
	VldCep(aDadEnt[5], aDadEnt[1]+ space(1)+ aDadEnt[3], aDadEnt[2], aDadEnt[6], aDadEnt[7], aDadEnt[8], lPA7)
	cCodMunE:= PA7->PA7_CODMUN

Endif
	
If cEstado == 'BA'
	cInEst := StrTran( cInEst, ".", "" )
	
	If ! ( "ISENTO" $ Upper( cInEst ) )
		cInEst := Strzero(val(cInEst),9)
	EndIf
EndIf

If cEstado == 'MG'
	cInEst := StrTran( cInEst, ".", "" )
	If ! ( "ISENTO" $ Upper( cInEst ) )
		cInEst := Strzero(val(cInEst),13)
	EndIf
EndIf

//Renato Ruy - 16/12/13 - Formatar a inscrição estadual para Goias/SP.
If cEstado == 'GO' .Or. cEstado == 'ES' .Or. cEstado == 'AM' .Or. cEstado == 'RN'
	cInEst := StrTran( cInEst, ".", "" )
	If ! ( "ISENTO" $ Upper( cInEst ) )
		cInEst := Strzero(val(cInEst),9)
	EndIf
EndIf

If cEstado == 'RS'
	cInEst := StrTran( cInEst, ".", "" )
	If ! ( "ISENTO" $ Upper( cInEst ) )
		cInEst := Strzero(val(cInEst),10)
	EndIf
EndIf

If cEstado == 'SP'
	cInEst := StrTran( cInEst, ".", "" )
	If ! ( "ISENTO" $ Upper( cInEst ) )
		cInEst := Strzero(val(cInEst),12)
	EndIf
EndIf

//Tratativa do Campo Nome Cliente - Rafael Beghini TOTVS 07/08/2015
cNome := STRTRAN(cNome, ';', ' ')
cNome := STRTRAN(cNome, '|', ' ')
cNome := STRTRAN(cNome, "'", ' ')

cNomeReduz := STRTRAN(cNomeReduz, ';', ' ')
cNomeReduz := STRTRAN(cNomeReduz, '|', ' ')
cNomeReduz := STRTRAN(cNomeReduz, "'", ' ')

If nOpc == 3
	aClient:={	{"A1_COD"       ,cCodigo           ,Nil},; // Codigo do Cliente
	{"A1_LOJA"      ,cLoja             ,Nil},; // Codigo que identifica a loja do Cliente.
	{"A1_PESSOA"    ,cPessoa           ,Nil},; // Pessoa Fisica/Juridica
	{"A1_NOME"      ,Alltrim(cNome)    ,Nil},; // Nome ou razao social do cliente.
	{"A1_NREDUZ"    ,Alltrim(cNomeReduz),Nil},; // O nome reduzido pelo qual o cliente e mais conhecido dentro da empresa.
	{"A1_TIPO"      ,cTipo			   ,Nil},; // Tipo de Cliente: L - Produtor Rural; F - Cons.Final;R - Revendedor; S - ICMS Solidario sem IPI na base; X - Exportação.
	{"A1_CGC"       ,cCGC              ,Nil},; // CNPJ (Cadastro Nacional da Pessoa Juridica) ou CPF  (Cadastro de Pessoa Fisica) do cliente.
	{"A1_CEP"       ,cCEP	           ,Nil},; // Codigo de enderecamento postal do cliente.
	{"A1_BAIRRO"    ,cBairro		   ,Nil},; // Bairro do cliente			//  {"A1_BAIRRO"    ,cBairro		   ,Nil},; // Bairro do cliente
	{"A1_EST"       ,cEstado		   ,Nil},; // Unidade da federacao do cliente.
	{"A1_MUN"       ,cMunicipio        ,Nil},; // Municipio do Cliente
	{"A1_END"       ,cEndereco         ,Nil},; // Endereco do cliente.
	{"A1_DDD"       ,cDDD			   ,Nil},; // Codigo do DDD do cliente.
	{"A1_TEL"       ,cTelefone	       ,Nil},; // Numero do telefone do cliente.
	{"A1_PFISICA"   ,cRG	           ,Nil},; // Cedula de Cidadania, Cedula  de Estrangeiro ou Cartao de Identidade do Cliente
	{"A1_EMAIL"     ,cEmail            ,Nil},; // E-Mail do Cliente.
	{"A1_INSCR"     ,cInEst            ,Nil},; // Incricao Estadual
	{"A1_INSCRM"    ,cInMun            ,Nil},; // Incricao Municipal
	{"A1_SUFRAMA"   ,cSufra            ,Nil},; // Suframa
	{"A1_CONTA"		,GetNewPar("MV_XCTACON", "110301001"),	NIL},;
	{"A1_NATUREZ"	,GetNewPar("MV_XNATCLI", "FT010010"),	NIL},;
	{"A1_RISCO"		,"A"				,NIL},;
	{"A1_LC"		,999999999.99		,NIL},;
	{"A1_CLASSE"	,"A"				,NIL},;
	{"A1_LCFIN"		,999999999.99		,NIL},;
	{"A1_MOEDALC"	,1					,NIL},;
	{"A1_VENCLC"	,CtoD("31/12/2030")	,NIL},;
	{"A1_GRPTRIB"	,cGrpTrib			,NIL},;
	{"A1_CONTRIB"   ,cContrib           ,NIL},;
	{"A1_STATVEN"	,"1"				,NIL},;
	{"A1_RECISS"	,"2"				,NIL},;
	{"A1_INCISS"	,"S"				,NIL},;
	{"A1_ALIQIR"	,IIF(cPessoa == "J", 1.5, 0 ),NIL},;
	{"A1_RECIRRF"	,IIF(cPessoa == "J", "1","2"),NIL},;
	{"A1_RECINSS"	,"N"				,NIL},;
	{"A1_RECCOFI"	,IIF(cPessoa == "J","S","N")				,NIL},; // Solicitação efetuada no chamado 2015070710000866
	{"A1_RECCSLL"	,IIF(cPessoa == "J","S","N")				,NIL},; // Solicitação efetuada no chamado 2015070710000866
	{"A1_RECPIS"	,IIF(cPessoa == "J","S","N")	,NIL},; // Solicitação efetuada no chamado 2015070710000866
	{"A1_COD_MUN"	,cCodMun				,NIL},;
	{"A1_CEPE"		,iif( lEntEndPri, cCEP		, aDadEnt[5])		, NIL},;
	{"A1_ENDENT"	,iif( lEntEndPri, cEndereco	, aDadEnt[1]+","+aDadEnt[3]+" "+aDadEnt[4])	,NIL},;
	{"A1_XNUMENT"	,iif( lEntEndPri, 0			, Val(aDadEnt[3]))	, NIL},;
	{"A1_XCOMPEN"	,iif( lEntEndPri, ""		, aDadEnt[4])	  	, NIL},;
	{"A1_BAIRROE"	,iif( lEntEndPri, cBairro	, aDadEnt[2])	 	, NIL},;
	{"A1_MUNE"		,iif( lEntEndPri, cMunicipio, aDadEnt[6])		, NIL},;
	{"A1_ESTE"		,iif( lEntEndPri, cEstado	, aDadEnt[7])		, NIL},;
	{"A1_CODMUNE"	,iif( lEntEndPri, cCodMun	, cCodMunE ), NIL},;
	{"A1_MSBLQL"	,"2"				,NIL},;
	{"A1_OBSERV"	,cObserv			,NIL}}
	
Else
	aClient:={	{"A1_COD"       ,cCodigo           ,Nil},; // Codigo do Cliente
	{"A1_LOJA"      ,cLoja             ,Nil},; // Codigo que identifica a loja do Cliente.
	{"A1_PESSOA"    ,cPessoa           ,Nil},; // Pessoa Fisica/Juridica
	{"A1_NOME"      ,Alltrim(cNome)    ,Nil},; // Nome ou razao social do cliente.
	{"A1_NREDUZ"    ,Alltrim(cNomeReduz),Nil},; // O nome reduzido pelo qual o cliente e mais conhecido dentro da empresa.
	{"A1_TIPO"      ,cTipo			   ,Nil},; // Tipo de Cliente: L - Produtor Rural; F - Cons.Final;R - Revendedor; S - ICMS Solidario sem IPI na base; X - Exportação.
	{"A1_CGC"       ,cCGC              ,Nil},; // CNPJ (Cadastro Nacional da Pessoa Juridica) ou CPF  (Cadastro de Pessoa Fisica) do cliente.
	{"A1_CEP"       ,cCEP	           ,Nil},; // Codigo de enderecamento postal do cliente.
	{"A1_BAIRRO"    ,cBairro		   ,Nil},; // Bairro do cliente			//  {"A1_BAIRRO"    ,cBairro		   ,Nil},; // Bairro do cliente
	{"A1_EST"       ,cEstado		   ,Nil},; // Unidade da federacao do cliente.
	{"A1_MUN"       ,cMunicipio        ,Nil},; // Municipio do Cliente
	{"A1_END"       ,cEndereco         ,Nil},; // Endereco do cliente.
	{"A1_DDD"       ,cDDD			   ,Nil},; // Codigo do DDD do cliente.
	{"A1_TEL"       ,cTelefone	       ,Nil},; // Numero do telefone do cliente.
	{"A1_PFISICA"   ,cRG	           ,Nil},; // Cedula de Cidadania, Cedula  de Estrangeiro ou Cartao de Identidade do Cliente
	{"A1_EMAIL"     ,cEmail            ,Nil},; // E-Mail do Cliente.
	{"A1_INSCR"     ,cInEst            ,Nil},; // Incricao Estadual
	{"A1_INSCRM"    ,cInMun            ,Nil},; // Incricao Municipal
	{"A1_SUFRAMA"   ,cSufra            ,Nil},; // Suframa
	{"A1_CONTA"		,GetNewPar("MV_XCTACON", "110301001"),	NIL},;
	{"A1_NATUREZ"	,GetNewPar("MV_XNATCLI", "FT010010"),	NIL},;
	{"A1_GRPTRIB"	,cGrpTrib			,NIL},;
	{"A1_CONTRIB"   ,cContrib           ,NIL},;
	{"A1_COD_MUN"	,cCodMun			,NIL},;
	{"A1_CEPE"		,iif( lEntEndPri, cCEP		, aDadEnt[5] ), NIL},;
	{"A1_ENDENT"	,iif( lEntEndPri, cEndereco	, aDadEnt[1]+","+aDadEnt[3]+" "+aDadEnt[4])	,NIL},;
	{"A1_XNUMENT"	,iif( lEntEndPri, 0			, Val(aDadEnt[3])),NIL},;
	{"A1_XCOMPEN"	,iif( lEntEndPri, ""		, aDadEnt[4] ), NIL},;
	{"A1_BAIRROE"	,iif( lEntEndPri, cBairro	, aDadEnt[2] ), NIL},;
	{"A1_MUNE"		,iif( lEntEndPri, cMunicipio, aDadEnt[6] ), NIL},;
	{"A1_ESTE"		,iif( lEntEndPri, cEstado	, aDadEnt[7] ), NIL},;
	{"A1_CODMUNE"	,iif( lEntEndPri, cCodMun	, cCodMunE ), NIL},;
	{"A1_MSBLQL"	,"2"				,NIL},;
	{"A1_OBSERV"	,cObserv			,NIL}}

	//----------------------------------------------------------------------------	
	// Criado array para armazenar os valores atuais antes de deixar vazio.  
	// Caso der erro no ExecAuto, eh possivel retornar os valores para os campos.   
	// Alteracao : Douglas Parreja
	//----------------------------------------------------------------------------	
	aAdd( aMun, alltrim(SA1->A1_EST)   )
	aAdd( aMun, alltrim(SA1->A1_INSCR) )
	aAdd( aMun, alltrim(SA1->A1_MUN)   )
	
	// Zera os campos para ser realizado atraves do ExecAuto
	//Renato Ruy - 18/09/2018
	//Quando não existir lock, entra para efetuar gravacao.
	If SA1->(RLock())
		Reclock('SA1',.F.)
		SA1->A1_EST	:=' '
		SA1->A1_INSCR :=' '
		SA1->A1_MUN	:=' '
		SA1->(MsUnlock())      
	Endif
EndIf

U_GTPutIN(cID,"C",cPedLog,.T.,{"U_VNDA110", ProcName(1), cPedLog,iif(nOpc == 3,"Incluindo Cliente","Alterando Cliente"),aClient},cNpSite)

MSExecAuto({|x,y| MATA030(x,y)},aClient,nOpc) // Executa a inclusao da funcao do cadastro de cliente

//Renato Ruy - 07/07/2017
//Por problemas na execAuto forca a tentativa de encontrar o registro
//Quando nao encontra efetua gravacao manual.
SA1->(DbSetOrder(1))
If !lMsErroAuto .And. !SA1->(DbSeek(xFilial("SA1")+cCodigo+cLoja)) .And. !Empty(cCodigo) .And. nOpc == 3

	If Reclock("SA1",.T.)
			SA1->A1_COD		:= cCodigo 				// Codigo do Cliente
			SA1->A1_LOJA	:= cLoja   				// Codigo que identifica a loja do Cliente.
			SA1->A1_PESSOA	:= cPessoa 				// Pessoa Fisica/Juridica
			SA1->A1_NOME	:= Alltrim(cNome)		// Nome ou razao social do cliente.
			SA1->A1_NREDUZ	:= Alltrim(cNomeReduz) // O nome reduzido pelo qual o cliente e mais conhecido dentro da empresa.
			SA1->A1_TIPO	:= cTipo			    // Tipo de Cliente: L - Produtor Rural; F - Cons.Final;R - Revendedor; S - ICMS Solidario sem IPI na base; X - Exportação.
			SA1->A1_CGC		:= cCGC    				// CNPJ (Cadastro Nacional da Pessoa Juridica) ou CPF  (Cadastro de Pessoa Fisica) do cliente.
			SA1->A1_CEP		:= cCEP	 				// Codigo de enderecamento postal do cliente.
			SA1->A1_BAIRRO	:= cBairro		    	// Bairro do cliente			//  {"A1_BAIRRO"    ,cBairro		    // Bairro do cliente
			SA1->A1_EST		:= cEstado		    	// Unidade da federacao do cliente.
			SA1->A1_MUN		:= cMunicipio         	// Municipio do Cliente
			SA1->A1_END 	:= cEndereco          	// Endereco do cliente.
			SA1->A1_DDD		:= cDDD			    	// Codigo do DDD do cliente.
			SA1->A1_TEL		:= cTelefone	        // Numero do telefone do cliente.
			SA1->A1_PFISICA	:= cRG	 				// Cedula de Cidadania, Cedula  de Estrangeiro ou Cartao de Identidade do Cliente
			SA1->A1_EMAIL   := cEmail  				// E-Mail do Cliente.
			SA1->A1_INSCR	:= cInEst  				// Incricao Estadual
			SA1->A1_INSCRM	:= cInMun  				// Incricao Municipal
			SA1->A1_SUFRAMA	:= cSufra  				// Suframa
			SA1->A1_CONTA	:= GetNewPar("MV_XCTACON", "110301001")
			SA1->A1_NATUREZ	:= GetNewPar("MV_XNATCLI", "FT010010")
			SA1->A1_RISCO	:= "A"				
			SA1->A1_LC		:= 999999999.99		
			SA1->A1_CLASSE  := "A"				
			SA1->A1_LCFIN	:= 999999999.99		
			SA1->A1_MOEDALC := 1					
			SA1->A1_VENCLC  := CtoD("31/12/2030")	
			SA1->A1_GRPTRIB := cGrpTrib			
			SA1->A1_CONTRIB := cContrib
			SA1->A1_STATVEN := "1"				
			SA1->A1_RECISS  := "2"				
			SA1->A1_INCISS  := "S"				
			SA1->A1_ALIQIR  := IIF(cPessoa == "J", 1.5, 0 )
			SA1->A1_RECIRRF := IIF(cPessoa == "J", "1","2")
			SA1->A1_RECINSS := "N"				
			SA1->A1_RECCOFI := IIF(cPessoa == "J","S","N")	 // Solicitação efetuada no chamado 2015070710000866
			SA1->A1_RECCSLL := IIF(cPessoa == "J","S","N")	 // Solicitação efetuada no chamado 2015070710000866
			SA1->A1_RECPIS  := IIF(cPessoa == "J","S","N")	 // Solicitação efetuada no chamado 2015070710000866
			SA1->A1_COD_MUN := cCodMun				
			SA1->A1_CEPE	:= iif( lEntEndPri, cCEP		, aDadEnt[5] )			
			SA1->A1_ENDENT	:= iif( lEntEndPri, cEndereco	, aDadEnt[1]+","+aDadEnt[3]+" "+aDadEnt[4])	
			SA1->A1_XNUMENT := iif( lEntEndPri, 0			, Val(aDadEnt[3]))
			SA1->A1_XCOMPEN := iif( lEntEndPri, ""			, aDadEnt[4] )
			SA1->A1_BAIRROE := iif( lEntEndPri, cBairro		, aDadEnt[2] )			
			SA1->A1_MUNE 	:= iif( lEntEndPri, cMunicipio	, aDadEnt[6] )			
			SA1->A1_ESTE 	:= iif( lEntEndPri, cEstado		, aDadEnt[7] )
			SA1->A1_COD_MUNE := cCodMunE				
			SA1->A1_MSBLQL	:= "2" 
			SA1->A1_CODPAIS	:= "01058"				
			SA1->A1_B2B		:= "2"				
			SA1->A1_PAIS	:= "105"
			SA1->A1_CEPC	:= cCEP
			SA1->A1_ENDCOB	:= cEndereco
			SA1->A1_BAIRROC	:= cBairro
			SA1->A1_MUNC	:= cMunicipio
			SA1->A1_ESTC	:= cEstado
			SA1->A1_COD_EST	:= Posicione("PA7",1,xFilial("PA7")+cCEP,"PA7_CODUF")
			SA1->A1_OBSERV	:= "MANUAL- " + cObserv
		SA1->(MsUnlock())
		
		cMsg := "SA1 --> Erro na inclusão do cliente na rotina padrão, foi necessario inserir manualmente" + CRLF + CRLF
		
		U_GTPutOUT(cID,"C",cPedLog,{{"CLIENTE",{.F.,"E00004",cPedLog,ProcName(1),cMsg}}},cNpSite)
		
	Endif

Endif
	

If lMsErroAuto
	
	cMsg := "SA1 --> Erro de inclusão de cliente na rotina padrão do sistema Protheus MSExecAuto({|x, y| MATA030(x, y)}, aCliente, nOpc)" + CRLF + CRLF
	aAutoErr := GetAutoGRLog()
	For nI := 1 To Len(aAutoErr)
		cMsg += aAutoErr[nI] + CRLF
	Next nI
	lRet := .F.
	U_GTPutOUT(cID,"C",cPedLog,{{"CLIENTE",{.F.,"E00004",cPedLog,ProcName(1),cMsg}}},cNpSite)     

	//----------------------------------------------------------------------------	
	// Para caso ocorreu erro, voltar a informacao que constava		
	// Alteracao : Douglas Parreja
	//----------------------------------------------------------------------------     
	if len(aMun) > 0
		dbSelectArea("SA1")
		dbSetOrder(1) //A1_FILIAL+A1_COD+A1_LOJA
		if DbSeek( xFilial("SA1") + cCodigo + cLoja ) 
			Reclock('SA1',.F.)
			SA1->A1_EST		:= aMun[1]
			SA1->A1_INSCR	:= aMun[2]
			SA1->A1_MUN		:= aMun[3]
			SA1->(MsUnlock())   
		endif
	endif
				
Else
	cMsg := 'Cliente cadastrado com sucesso'
	
	U_GTPutOUT(cID,"C",cPedLog,{"CLIENTE",{.T.,"M00001",cPedLog,ProcName(1),cMsg}},cNpSite)     
	 
Endif   

//----------------------------------------------------------------------------
// Tratamento indifere se o ExecAuto deu erro ou nao
//----------------------------------------------------------------------------
dbSelectArea("SA1")
dbSetOrder(1) //A1_FILIAL+A1_COD+A1_LOJA  
if DbSeek( xFilial("SA1") + cCodigo + cLoja ) 
	
	IF EMPTY(SA1->A1_COD_MUN)
		//Valida CEP na Tabela PA7
		PA7->( DbSetOrder(1) )		// PA7_FILIAL + PA7_CODCEP
		If PA7->( MsSeek( xFilial("PA7")+cCEP ) )
			Reclock('SA1',.F.)
			SA1->A1_COD_MUN := PA7->PA7_CODMUN
			SA1->(MsUnlock())
		EndIf
	ENDIF
	//----------------------------------------------------------------------------
	// Identificar caso o campo esteja vazio, voltar a informacao que constava, 
	// devido que na transmissao de NFSe nao estava constando o Estado.
	// Alteracao : Douglas Parreja  
	//----------------------------------------------------------------------------	
	if len(aMun) > 0      
	       
		// Campos vazio A1_EST, A1_INSCR e A1_MUN
		if Empty(alltrim(SA1->A1_EST)) .and. Empty(alltrim(SA1->A1_INSCR)) .and. Empty(alltrim(SA1->A1_MUN))
			Reclock('SA1',.F.)
			SA1->A1_EST		:= aMun[1]
			SA1->A1_INSCR	:= aMun[2]
			SA1->A1_MUN		:= aMun[3]
			SA1->(MsUnlock())			                                                                       
		endif
		//Somente o A1_EST esta vazio
		if Empty(alltrim(SA1->A1_EST)) 
			Reclock('SA1',.F.)
			SA1->A1_EST := aMun[1] 
			SA1->(MsUnlock())
		endif
		//Somente o A1_INSCR esta vazio
		if Empty(alltrim(SA1->A1_INSCR))
			Reclock('SA1',.F.)
			SA1->A1_INSCR := aMun[2]           
			SA1->(MsUnlock())
		endif
		//Somente o A1_MUN esta vazio
		if Empty(alltrim(SA1->A1_MUN))
			Reclock('SA1',.F.)
			SA1->A1_EST := aMun[3]			
			SA1->(MsUnlock())
		endif   	
	endif
endif	

Return({lRet,cMsg})

//  {"A1_BAIRRO"    ,cBairro		   ,Nil},; // Bairro do cliente
//	{"A1_MUN"       ,cMunicipio        ,Nil},; // Municipio do Cliente
//	{"A1_EST"       ,cEstado		   ,Nil},; // Unidade da federacao do cliente.


/*/{Protheus.doc} VldCep

Funcao criada para Caso CEP nao seja encontrado Tabela PA7, via Mashup, verifica existenia do mesmo e insere na tabela

@author Totvs SM - David
@since 20/07/2011
@version P11

/*/
Static Function VldCep(cCep, cLograd, cBairro, cMunicipio, cEstado, cIbge, lPA7)
Local aDadCep	:= {}
Local lCC2		:= .F.
Local aAreaCC2  := CC2->(GetArea())

//Renato Ruy - 16/11/2017
//Considera a informacao recebida pelo Hub como a real.
/*
//Validação via mashup
aVldCep := U_VNDA460(cCep)

// Caso consulta tenha ocorrido sem problemas atualiza PA7
If aVldCep[1]
	aDadCep := aVldCep[2]
	
	PA7->( RecLock("PA7",.T.) )
	PA7->PA7_FILIAL	:= xFilial("PA7")
	PA7->PA7_CODCEP	:= cCep
	PA7->PA7_LOGRA	:= aDadCep[2,2]
	PA7->PA7_BAIRRO	:= aDadCep[3,2]
	PA7->PA7_MUNIC	:= aDadCep[4,2]
	PA7->PA7_ESTADO	:= aDadCep[5,2]
	PA7->PA7_CODPAI	:= "105"
	PA7->PA7_CODMUN	:= Posicione("CC2", 2, xFilial("CC2")+Alltrim(aDadCep[4,2]),"CC2_CODMUN" )
	PA7->( MsUnLock() )
	// Caso Seja encontrada inconsistencia loga informação no console do Protheus
Else
	aDadCep := {"Inconsistência na Validação de CEP via Mashup Totvs","Cep Código: "+cCep,"Inconsistência: "+aVldCep[2]}
	varinfo("-->",aDadCep)
EndIF
*/

//Cria semaforo
sleep(Randomize( 1, 1000 ))

If !LockByName("VALCEP"+cCep)
	Conout("[VALCEP] - O CEP: "+ cCep +" ja esta em processamento!")
	RestArea(aAreaCC2)
	return
Endif

If Empty(cCep) .Or. valtype("cLograd") == "U" .Or. valtype("cBairro") == "U" .Or. valtype("cMunicipio") == "U" .Or. valtype("cEstado") == "U" .Or. valtype("cIbge") == "U" 
	aDadCep := {"TAG EMDERECO INCOMPLETA - VERIFIQUE CODIGO DO CEP, EST,MUN, BAIRRO,LOGRADOURO!"}
	varinfo("-->",aDadCep)
Else
	PA7->( RecLock("PA7",lPA7) )
		PA7->PA7_FILIAL	:= xFilial("PA7")
		PA7->PA7_CODCEP	:= cCep
		PA7->PA7_LOGRA	:= Upper(cLograd)
		PA7->PA7_BAIRRO	:= Upper(cBairro)
		PA7->PA7_MUNIC	:= Upper(cMunicipio)
		PA7->PA7_ESTADO	:= Upper(cEstado)
		PA7->PA7_CODPAI	:= "105"
		PA7->PA7_CODMUN	:= Substr(cIbge,3,5)
		PA7->PA7_CODUF	:= Substr(cIbge,1,2)
		PA7->PA7_PAIS	:= "BRASIL"
	PA7->( MsUnLock() )
Endif


//Filial + Codigo Municipio
CC2->(DbSetOrder(1))
lCC2 := !CC2->(DbSeek(xFilial("CC2")+AllTrim(cEstado)+Substr(cIbge,3,5)))

If Empty(cIbge) .Or. valtype("cMunicipio") == "U" .Or. valtype("cEstado") == "U"
	aDadCep := {"TAG EMDERECO INCOMPLETA - VERIFIQUE CODIGO DO IBGE, MUM, EST!"}
	varinfo("-->",aDadCep)
Else
	CC2->(Reclock("CC2", lCC2))
		CC2->CC2_EST	:= Upper(cEstado)
		CC2->CC2_CODMUN := Substr(cIbge,3,5)
		CC2->CC2_MUN	:= Upper(cMunicipio)
	CC2->(MsUnlock())
Endif

UnLockByName("VALCEP"+cCep)
RestArea(aAreaCC2)

Return
