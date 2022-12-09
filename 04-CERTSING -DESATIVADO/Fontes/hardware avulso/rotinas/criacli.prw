#INCLUDE "PROTHEUS.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRIACLI   บAutor  ณMicrosiga           บ Data ณ  07/20/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao criada para incluir cliente de faturamento do site   บฑฑ
ฑฑบ          ณhardware avulso, na base do Protheus.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs X Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CriaCli(nOpc,cCodigo,cLoja,cPessoa,cNome,cNomeReduz,cTipo,cEndereco,cBairro,cCEP,cMunicipio,cEstado,cPais,cDescPais,cDDD,cTelefone,cCGC,cRG,cEmail,cInEst,cInMun,cSufra)

Local aClient	:= {}
Local lRet 		:= .T.
Local cMsg 		:= ""
Local cGrpTrib	:= ""  
Local cContrib  := ""
Local cObserv	:= iif(nOpc = 3, "INCLUIDO EM "+DtoC(Date())+" AS "+Time(),"ALTERADO EM "+DtoC(Date())+" AS "+Time())
Local nI        := 0

Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()
Private lMsErroAuto := .F.   

cObserv := "FONTE: "+ProcName(1)+" - "+cObserv

If SubStr(AllTrim(Upper(cInEst)),1,3) = "ISE"   
	cInEst := "ISENTO"
EndIF 

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

//Valida CEP na Tabela PA7
PA7->( DbSetOrder(1) )		// PA7_FILIAL + PA7_CODCEP
If !PA7->( MsSeek( xFilial("PA7")+cCEP ) )

	VldCep(cCEP)
	
EndIf

If nOpc = 3                                                                                                                                                                   	
	aClient:={	{"A1_COD"       ,cCodigo           ,Nil},; // Codigo do Cliente
			    {"A1_LOJA"      ,cLoja             ,Nil},; // Codigo que identifica a loja do Cliente. 
			    {"A1_PESSOA"    ,cPessoa           ,Nil},; // Pessoa Fisica/Juridica
			    {"A1_NOME"      ,cNome             ,Nil},; // Nome ou razao social do cliente.  
			    {"A1_NREDUZ"    ,cNomeReduz	       ,Nil},; // O nome reduzido pelo qual o cliente e mais conhecido dentro da empresa.
			    {"A1_TIPO"      ,cTipo			   ,Nil},; // Tipo de Cliente: L - Produtor Rural; F - Cons.Final;R - Revendedor; S - ICMS Solidario sem IPI na base; X - Exporta็ใo.
			    {"A1_END"       ,cEndereco         ,Nil},; // Endereco do cliente.
			    {"A1_BAIRRO"    ,cBairro		   ,Nil},; // Bairro do cliente
			    {"A1_CEP"       ,cCEP	           ,Nil},; // Codigo de enderecamento postal do cliente. 
				{"A1_MUN"       ,cMunicipio        ,Nil},; // Municipio do Cliente 
				{"A1_EST"       ,cEstado		   ,Nil},; // Unidade da federacao do cliente.
				{"A1_PAIS"      ,cPais			   ,Nil},; // Codigo do pais de localizacao do cliente
				{"A1_PAISDES"   ,cDescPais		   ,Nil},; // Nome do pais do cliente  
				{"A1_DDD"       ,cDDD			   ,Nil},; // Codigo do DDD do cliente.
				{"A1_TEL"       ,cTelefone	       ,Nil},; // Numero do telefone do cliente. 
				{"A1_CGC"       ,cCGC              ,Nil},; // CNPJ (Cadastro Nacional da Pessoa Juridica) ou CPF  (Cadastro de Pessoa Fisica) do cliente.
				{"A1_PFISIC"    ,cRG	           ,Nil},; // Cedula de Cidadania, Cedula  de Estrangeiro ou Cartao de Identidade do Cliente
				{"A1_EMAIL"     ,cEmail            ,Nil},; // E-Mail do Cliente.
				{"A1_INSCR"     ,cInEst            ,Nil},; // Incricao Estadual
				{"A1_INSCRM"    ,cInMun            ,Nil},; // Incricao Municipal
				{"A1_SUFRAMA"   ,iif(Val(cSufra) > 0,cSufra,""),Nil},; // Suframa
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
				{"A1_RECCOFI"	,"N"				,NIL},;
				{"A1_RECCSLL"	,"N"				,NIL},;
				{"A1_RECPIS"	,"N"				,NIL},;
				{"A1_CODPAIS"	,"01058"			,NIL},;
				{"A1_OBSERV"	,cObserv			,NIL}}  
Else
	aClient:={	{"A1_COD"       ,cCodigo           ,Nil},; // Codigo do Cliente
			    {"A1_LOJA"      ,cLoja             ,Nil},; // Codigo que identifica a loja do Cliente. 
			    {"A1_PESSOA"    ,cPessoa           ,Nil},; // Pessoa Fisica/Juridica
			    {"A1_NOME"      ,cNome             ,Nil},; // Nome ou razao social do cliente.  
			    {"A1_NREDUZ"    ,cNomeReduz	       ,Nil},; // O nome reduzido pelo qual o cliente e mais conhecido dentro da empresa.
			    {"A1_TIPO"      ,cTipo			   ,Nil},; // Tipo de Cliente: L - Produtor Rural; F - Cons.Final;R - Revendedor; S - ICMS Solidario sem IPI na base; X - Exporta็ใo.
			    {"A1_END"       ,cEndereco         ,Nil},; // Endereco do cliente.
			    {"A1_BAIRRO"    ,cBairro		   ,Nil},; // Bairro do cliente
			    {"A1_CEP"       ,cCEP	           ,Nil},; // Codigo de enderecamento postal do cliente. 
				{"A1_MUN"       ,cMunicipio        ,Nil},; // Municipio do Cliente 
				{"A1_EST"       ,cEstado		   ,Nil},; // Unidade da federacao do cliente.
				{"A1_PAIS"      ,cPais			   ,Nil},; // Codigo do pais de localizacao do cliente
				{"A1_PAISDES"   ,cDescPais		   ,Nil},; // Nome do pais do cliente  
				{"A1_DDD"       ,cDDD			   ,Nil},; // Codigo do DDD do cliente.
				{"A1_TEL"       ,cTelefone	       ,Nil},; // Numero do telefone do cliente. 
				{"A1_CGC"       ,cCGC              ,Nil},; // CNPJ (Cadastro Nacional da Pessoa Juridica) ou CPF  (Cadastro de Pessoa Fisica) do cliente.
				{"A1_PFISIC"    ,cRG	           ,Nil},; // Cedula de Cidadania, Cedula  de Estrangeiro ou Cartao de Identidade do Cliente
				{"A1_EMAIL"     ,cEmail            ,Nil},; // E-Mail do Cliente.
				{"A1_INSCR"     ,cInEst            ,Nil},; // Incricao Estadual
				{"A1_INSCRM"    ,cInMun            ,Nil},; // Incricao Municipal
				{"A1_SUFRAMA"   ,iif(Val(cSufra) > 0,cSufra,""),Nil},; // Suframa
				{"A1_GRPTRIB"	,cGrpTrib			,NIL},;   
				{"A1_CONTRIB"   ,cContrib           ,NIL},;
				{"A1_OBSERV"	,cObserv			,NIL}}  

EndIf
	
MSExecAuto({|x,y| MATA030(x,y)},aClient,nOpc) // Executa a inclusao da funcao do cadastro de cliente
               
If lMsErroAuto //Apresenta a mesagem de erro 
 	MOSTRAERRO()
 	lRet := .F.
	cMsg := 'Cliente nใo p๔de ser incluํdo. '
	
	cAutoErr := "SA1, --> Erro de inclusใo de cliente no sistema Protheus MSExecAuto({|x,y| MATA030(x,y)},aClient,nOpc)" + CRLF + CRLF
	cAutoErr += VarInfo("",aClient,,.f.,.f.)+ CRLF + CRLF
	aAutoErr := GetAutoGRLog()
	For nI := 1 To Len(aAutoErr)
		cAutoErr += aAutoErr[nI] + CRLF
	Next nI
	cMsg += cAutoErr
	DisarmTransaction()
Else
	cMsg := 'Cliente cadastrado com sucesso.'
EndIf   

Return({lRet,cMsg})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldCep   บAutor  ณOpvs (David)        บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Caso CEP nao seja encontrado Tabela PA7, via Mashup, veri- บฑฑ
ฑฑบ          ณ fica existenia do mesmo e insere na tabela                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldCep(cCep)
Local aVldCep	:= {}
Local aDadCep	:= {}

//Valida็ใo via mashup
aVldCep := U_VlCepMsh(cCep)

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
// Caso Seja encontrada inconsistencia loga informa็ใo no console do Protheus
Else
	aDadCep := {"Inconsist๊ncia na Valida็ใo de CEP via Mashup Totvs","Cep C๓digo: "+cCep,"Inconsist๊ncia: "+aVldCep[2]}	
    varinfo("-->",aDadCep)
EndIF

Return
