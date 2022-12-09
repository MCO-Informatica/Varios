#include 'protheus.ch'

#DEFINE LINE_FORNECEDOR		1
#DEFINE LINE_LOJA			2
#DEFINE LINE_PARCEIRO 		3
#DEFINE LINE_PREFIXO		4
#DEFINE LINE_TIPO_TITULO 	5
#DEFINE LINE_NATUREZA		6
#DEFINE LINE_DATA_EMISSAO 	7
#DEFINE LINE_DATA_VENCTO  	8
#DEFINE LINE_HISTORICO		9
#DEFINE LINE_BANCO			10
#DEFINE LINE_AGENCIA		11
#DEFINE LINE_CONTA			12
#DEFINE LINE_VALOR			13
#DEFINE LINE_PARCELA		14
#DEFINE LINE_VLR_PERIODO1	15
#DEFINE LINE_VLR_PERIODO2	16
#DEFINE LINE_VLR_PERIODO3	17
#DEFINE LINE_SOMATORIA		18
#DEFINE LINE_PERCENTUAL		19
#DEFINE LINE_PERIODO		20

/*/{Protheus.doc} TituloRemuneracao
Classe para controle do Titulo de Adiantamento aos Parceiros 
no processo de Remuneração de Parceiros do Protheus
@author    yuri.volpe
@since     13/07/2020
@version   1.0
/*/
Class TituloRemuneracao 

	Data numeroTitulo As String
	Data fornecedor As String
	Data lojaFornecedor As String
	Data codigoEntidade As String
	Data prefixo As String 
	Data tipoTitulo As String
	Data natureza As String 
	Data dataEmissao As Date
	Data dataVencimento As Date 
	Data historico As String
	Data banco As String 
	Data agencia As String
	Data conta As String 
	Data valor As Float
	Data parcela As String
	Data valorPeriodo1 As Float
	Data valorPeriodo2 As Float
	Data valorPeriodo3 As Float
	Data somatoria As Float
	Data percentual As Float
	Data periodo As String
	Data mensagemSave As String
	Data validaDados As Logic
	Data validaTituloGerado As Logic 
	
	Method new() Constructor
	Method loadFromObject(oObject) 
	Method loadFromArray(aLinha)
	Method save()
	Method validaCampos()
	Method openTables()
	Method getNumeroTitulo()
	Method getFromParceiro(cCodPar)
	Method getFromPeriodoParceiro(cPeriodo, cParceiro)
	Method toCSV()
	Static Method toCSVHeader()
	Static Method toArrayHeader()
	Method toArray(cObsExtra)
	Method podeGerar()

EndClass

/*/{Protheus.doc} new
Metodo construtor, inicializa valores e obtém parâmetros para controle
de validações.
@author    yuri.volpe
@since     13/07/2020
@version   1.0
/*/
Method new() Class TituloRemuneracao

	::numeroTitulo		:= ""
	::fornecedor 		:= ""
	::lojaFornecedor 	:= ""
	::codigoEntidade 	:= "" 
	::prefixo 			:= ""   
	::tipoTitulo 		:= "" 
	::natureza 			:= ""   
	::dataEmissao 		:= CToD("//") 
	::dataVencimento 	:= CToD("//")  
	::historico			:= ""
	::banco 			:= ""  
	::agencia 			:= "" 
	::conta 			:= ""  
	::valor 			:= 0.0 
	::parcela 			:= "" 
	::valorPeriodo1 	:= 0.0
	::valorPeriodo2 	:= 0.0 
	::valorPeriodo3 	:= 0.0 
	::somatoria			:= 0.0
	::percentual		:= 0.0
	::periodo			:= cValToChar(Year(dDataBase)) + StrZero(Month(dDataBase),2)
	::validaDados		:= GetNewPar("MV_XVTIREM",.T.)
	::validaTituloGerado:= GetNewPar("MV_XVTGERA",.T.)

Return

/*/{Protheus.doc} loadFromArray
//Carrega os dados no objeto a partir de array com a estrutura
//pré-definida.
@author yuri.volpe
@since 16/07/2020
@version 1.0
@param aLinha, array, Array contendo a estrutura.
@type function
/*/
Method loadFromArray(aLinha) Class TituloRemuneracao

	::fornecedor 		:= Padr(aLinha[LINE_FORNECEDOR]	 , TamSX3("A2_COD"		)[1])
	::lojaFornecedor 	:= Padr(aLinha[LINE_LOJA]		 , TamSX3("A2_LOJA"		)[1])
	::codigoEntidade 	:= Padr(aLinha[LINE_PARCEIRO]	 , TamSX3("Z3_CODENT"	)[1]) 
	::prefixo 			:= Padr(aLinha[LINE_PREFIXO]	 , TamSX3("E2_PREFIXO"	)[1])   
	::tipoTitulo 		:= Padr(aLinha[LINE_TIPO_TITULO] , TamSX3("E2_TIPO"		)[1]) 
	::natureza 			:= Padr(aLinha[LINE_NATUREZA]	 , TamSX3("E2_NATUREZA"	)[1])   
	::historico			:= Padr(aLinha[LINE_HISTORICO]	 , TamSX3("E2_HIST"		)[1])
	::parcela 			:= Padr(aLinha[LINE_PARCELA]	 , TamSX3("E2_PARCELA"	)[1]) 
	::banco 			:= Padr(aLinha[LINE_BANCO]		 , TamSX3("A6_COD"		)[1])
	::agencia 			:= Padr(aLinha[LINE_AGENCIA]	 , TamSX3("A6_AGENCIA"	)[1])
	::conta 			:= Padr(aLinha[LINE_CONTA]		 , TamSX3("A6_NUMCON"	)[1])
	::periodo			:= Padr(aLinha[LINE_PERIODO]	 , TamSX3("Z6_PERIODO"	)[1])
	::dataEmissao 		:= CTOD(aLinha[LINE_DATA_EMISSAO]) 
	::dataVencimento 	:= CTOD(aLinha[LINE_DATA_VENCTO])  
	::valor 			:= Val(aLinha[LINE_VALOR]) 
	::valorPeriodo1 	:= Val(aLinha[LINE_VLR_PERIODO1])
	::valorPeriodo2 	:= Val(aLinha[LINE_VLR_PERIODO2])
	::valorPeriodo3 	:= Val(aLinha[LINE_VLR_PERIODO3])
	::somatoria			:= Val(aLinha[LINE_SOMATORIA])
	::percentual		:= Val(aLinha[LINE_PERCENTUAL])

Return

/*/{Protheus.doc} loadFromObject
//Permite alimentar o objeto TituloRemuneracao com outro objeto
//que contenha os campos necessários.
@author yuri.volpe
@since 13/07/2020
@version 1.0
@param oObject, object, Objeto que contém a estrutura necessária
@type function
/*/
Method loadFromObject(oObject) Class TituloRemuneracao

	::fornecedor 		:= Padr(oObject:fornecedor 		, TamSX3("A2_COD"		)[1])
	::lojaFornecedor 	:= Padr(oObject:lojaFornecedor 	, TamSX3("A2_LOJA"		)[1])
	::codigoEntidade 	:= Padr(oObject:codigoEntidade 	, TamSX3("Z3_CODENT"	)[1]) 
	::prefixo 			:= Padr(oObject:prefixo 		, TamSX3("E2_PREFIXO"	)[1])   
	::tipoTitulo 		:= Padr(oObject:tipoTitulo 	 	, TamSX3("E2_TIPO"		)[1]) 
	::natureza 			:= Padr(oObject:natureza 		, TamSX3("E2_NATUREZA"	)[1])   
	::historico			:= Padr(oObject:historico		, TamSX3("E2_HIST"		)[1])
	::parcela 			:= Padr(oObject:parcela 		, TamSX3("E2_PARCELA"	)[1]) 
	::banco 			:= Padr(oObject:banco 			, TamSX3("A6_COD"		)[1])
	::agencia 			:= Padr(oObject:agencia 		, TamSX3("A6_AGENCIA"	)[1])
	::conta 			:= Padr(oObject:conta 		 	, TamSX3("A6_NUMCON"	)[1])
	::periodo			:= Padr(oObject:periodo			, TamSX3("Z6_PERIODO"	)[1])
	::dataEmissao 		:= CTOD(oObject:dataEmissao) 
	::dataVencimento 	:= CTOD(oObject:dataVencimento)
	::valor 			:= Val(oObject:valor)
	::valorPeriodo1 	:= Val(oObject:valorPeriodo1)
	::valorPeriodo2 	:= Val(oObject:valorPeriodo2)
	::valorPeriodo3 	:= Val(oObject:valorPeriodo3)
	::somatoria			:= Val(oObject:somatoria)
	::percentual		:= Val(oObject:percentual)
	::numeroTitulo		:= ::getNumeroTitulo()

Return

/*/{Protheus.doc} getFromParceiro
//Método não implementado.
//Carrega os dados a partir de um determinado parceiro, considerando o 
//período corrente
@author yuri.volpe
@since 16/07/2020
@version 1.0
@param cCodPar, characters, Código do parceiro cadastrado na SZ3
@type function
/*/
Method getFromParceiro(cCodPar) Class TituloRemuneracao

Return

/*/{Protheus.doc} getFromPeriodoParceiro
Método não implementado.
Carrega os dados a partir de um determinado parceiro, considerando o 
período informado no parâmetro
@author yuri.volpe
@since 16/07/2020
@version 1.0
@param cPeriodo, characters, Período para pesquisa
@param cParceiro, characters, Código do parceiro cadastrado na SZ3
@type function
/*/
Method getFromPeriodoParceiro(cPeriodo, cParceiro) class TituloRemuneracao

Return

/*/{Protheus.doc} save
//Realiza a inclusão do título financeiro, utilizando a função MsExecAuto
//para a rotina padrão FINA050. Grava também as informações necessárias nas
//tabelas ZZ6 e ZZ7
@author yuri.volpe
@since 13/07/2020
@version 1.0
@type function
/*/
Method save() Class TituloRemuneracao

	Local aRetValid 	:= {}
	Local lCamposOk 	:= .F.
	Local cMsgValid 	:= ""
	Local cE2_Num		:= ""
	Local cE2_Fornece	:= ""
	Local cE2_Loja		:= ""
	Local cE2_Hist		:= ""
	Local cE2_BcoForn	:= ""
	Local cE2_AgeForn	:= ""
	Local cE2_CtaForn	:= ""
	Local cE2_Naturez	:= ""
	Local cE2_Tipo		:= ""
	Local cE2_Prefixo	:= ""
	Local cE2_Parcela	:= ""
	Local dE2_Vencto	:= CTOD("//")
	Local dE2_VencRea	:= CTOD("//")
	Local dE2_Emissao	:= CTOD("//")
	Local nPerAdianta	:= 0
	Local nE2_Valor		:= 0
	Local aArray		:= {}
	Local lFoundZZ6		:= .F.
	Local lFoundZZ7		:= .F.
	Local cNomeParc		:= AllTrim(GetAdvFVal("SZ3", "Z3_DESENT", xFilial("SZ3") + ::codigoEntidade, 1, ::codigoEntidade, .T.))
	Local cBcoPA		:= GetMV("MV_XBCOADT")
	Local cAgencPA		:= GetMV("MV_XAGEADT")
	Local cCtaPA		:= GetMV("MV_XCTAADT")
	Local nDiaVenc		:= GetMV("MV_XREMDTV")
	Local Nj			:= 0
	
	::mensagemSave := "" 
	
	Private lMsErroAuto := .F.
	
	If ::validaDados
		If !::validaCampos()
			Return .F.
		EndIf
	EndIf
	
	If ::validaTituloGerado
		If !::podeGerar()
			Return .F.
		EndIf
	EndIf
	
	If Empty(::numeroTitulo)
		::getNumeroTitulo()
	EndIf
	
	//Inicia variaveis
	cE2_Prefixo := ::prefixo
	cE2_Num		:= ::numeroTitulo
	cE2_Tipo	:= ::tipoTitulo
	cE2_Naturez := ::natureza
	cE2_Fornece := ::fornecedor
	cE2_Loja	:= ::lojaFornecedor
	dE2_Emissao := ::dataEmissao
	dE2_Vencto	:= ::dataVencimento
	dE2_VencRea := DataValida(::dataVencimento)
	cE2_Hist	:= ::historico
	cE2_BcoForn	:= ::banco
	cE2_AgeForn	:= ::agencia
	cE2_CtaForn	:= ::conta
	nE2_Valor	:= ::valor
	cE2_Parcela := ::parcela
	nPerAdianta := ::percentual
	nE2_Moeda	:= 1 //A Certisign não opera em outras moedas

	//Array do Titulo Provisório
	aArray := { { "E2_PREFIXO"  , cE2_Prefixo	, NIL },;
	            { "E2_NUM"      , cE2_Num		, NIL },;
				{ "E2_PARCELA"	, cE2_Parcela	, NIL },;		
	            { "E2_TIPO"     , cE2_Tipo		, NIL },;
	            { "E2_NATUREZ"  , cE2_Naturez	, NIL },;
	            { "E2_FORNECE"  , cE2_Fornece	, NIL },;
	            { "E2_LOJA" 	, cE2_Loja		, NIL },;
	            { "E2_EMISSAO"  , dE2_Emissao	, NIL },;
	            { "E2_VENCTO"   , dE2_Vencto	, NIL },;
	            { "E2_VENCREA"  , dE2_VencRea	, NIL },;
	            { "E2_HIST"	    , cE2_Hist		, NIL },;
				{ "E2_MOEDA"	, nE2_Moeda		, NIL },;
	            { "E2_FORBCO"	, cE2_BcoForn	, NIL },;
	            { "E2_FORAGE"	, cE2_AgeForn	, NIL },;
	            { "E2_FORCTA"	, cE2_CtaForn	, NIL },;
				{ "AUTBANCO"	, cBcoPA		, NIL },;
				{ "AUTAGENCIA"	, cAgencPA		, NIL },;
				{ "AUTCONTA"	, cCtaPA		, NIL },;
	            { "E2_VALOR"    , nE2_Valor		, NIL } }
	            
	MsAguarde({|| MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)},"Título Adiantamento","Gerando título parceiro " + AllTrim(cNomeParc))
					
	If lMsErroAuto
		
	    aErroAuto := GetAutoGRLog()
	    ::mensagemSave := "Erro na execução do MsExecAuto: " + CHR(13) + CHR(10)
	    
	    For Nj := 1 To Len(aErroAuto)
	    	::mensagemSave += aErroAuto[Nj] + CHR(13) + CHR(10)
	    Next
	    
	    If Len(aErroAuto) == 0
	    	::mensagemSave += MostraErro()
	    EndIf
	    
	    lMsErroAuto := .F.
	    Return .F.
	Else
	    
	    ZZ6->(dbSetOrder(1))
	    lFoundZZ6 := ZZ6->(!dbSeek(xFilial("ZZ6") + ::periodo + ::codigoEntidade))
		    RecLock("ZZ6", lFoundZZ6)
				ZZ6->ZZ6_PREFIX	:= SE2->E2_PREFIXO 
				ZZ6->ZZ6_NUM	:= SE2->E2_NUM
				ZZ6->ZZ6_PARCEL	:= SE2->E2_PARCELA 
				ZZ6->ZZ6_TIPO	:= SE2->E2_TIPO
				ZZ6->ZZ6_FORNEC	:= SE2->E2_FORNECE
				ZZ6->ZZ6_LOJA	:= SE2->E2_LOJA
				ZZ6->ZZ6_PER1	:= ::valorPeriodo1
				ZZ6->ZZ6_PER2	:= ::valorPeriodo2
				ZZ6->ZZ6_PER3	:= ::valorPeriodo3
				ZZ6->ZZ6_SOMA	:= ::somatoria
		    ZZ6->(MsUnlock())
	    
	    ZZ7->(dbSetOrder(1))
	    lFoundZZ7 := ZZ7->(!dbSeek(xFilial("ZZ7") + ::codigoEntidade  + ::periodo ))
	    
	    RecLock("ZZ7", lFoundZZ7)
	    	ZZ7->ZZ7_FILIAL := xFilial("ZZ7")
	    	ZZ7->ZZ7_CODPAR := ZZ6->ZZ6_CODENT
	    	ZZ7->ZZ7_PARCEL := SE2->E2_PARCELA
	    	ZZ7->ZZ7_VALOR  := SE2->E2_VALOR
	    	ZZ7->ZZ7_SALDO	:= SE2->E2_VALOR
	    	ZZ7->ZZ7_PRETIT := SE2->E2_PREFIXO
	    	ZZ7->ZZ7_TITULO := SE2->E2_NUM
	    	ZZ7->ZZ7_PERIOD := ZZ6->ZZ6_PERIOD
	    ZZ7->(MsUnlock())
	    
	    ::mensagemSave := "Título Incluído com sucesso: " + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA + CHR(13) + CHR(10)
	    ::mensagemSave += "Registro " + Iif(lFoundZZ6,"alterado","incluído") + " na tabela ZZ6. Recno: " + cValToChar(ZZ6->(Recno())) + CHR(13) + CHR(10)
	    ::mensagemSave += "Registro " + Iif(lFoundZZ7,"alterado","incluído") + " na tabela ZZ7. Recno: " + cValToChar(ZZ7->(Recno())) + CHR(13) + CHR(10)
	    
	Endif

Return .T.

/*/{Protheus.doc} validaCampos
//Valida os campos de cadastro informados para inclusão do título
@author yuri.volpe
@since 13/07/2020
@version 1.0

@type function
/*/
Method validaCampos() Class TituloRemuneracao

	//#==================================================
	//#= Abre as tabelas
	//#==================================================
	::openTables()

	//#==================================================
	//#= Verifica inicialmente se os cadastros estão ok
	//#==================================================
	SA2->(dbSetOrder(1))
	If !SA2->(dbSeek(xFilial("SA2") + ::fornecedor + ::lojaFornecedor))
		::mensagemSave 	:= "O título não foi incluído: O Fornecedor informado não existe. Código: " + ::fornecedor + "/Loja: " + ::lojaFornecedor
		Return .F.
	EndIf
	
	SA6->(dbSetOrder(1))
	If !SA6->(dbSeek(xFilial("SA6") + ::banco + ::agencia + ::conta))
		::mensagemSave := "O título não foi incluído: O Banco informado não existe. Banco: " + ::banco + " - Ag.: " + ::agencia + " - Conta: " + ::conta
		Return .F. 
	EndIf
	
	SZ3->(dbSetOrder(1))
	If !SZ3->(dbSeek(xFilial("SZ3") + ::codigoEntidade))
		::mensagemSave := "O título não foi incluído: O Parceiro informado não existe. Código: " + ::codigoEntidade 
		Return .F.
	EndIf

	//#==================================================
	//#= Verifica amarrações das entidades
	//#==================================================
	If SZ3->(Found()) .And. SA6->(Found()) .And. SA2->(Found())
		If SZ3->Z3_CODFOR != SA2->A2_COD
			::mensagemSave := "O título não foi incluído: O Fornecedor cadastrado no CCR é diferente do informado." 
			Return .F.
		EndIf
		
		If SA2->A2_BANCO != SA6->A6_COD .Or. SA2->A2_AGENCIA != SA6->A6_AGENCIA .Or. SA2->A2_NUMCON != SA6->A6_NUMCON
			::mensagemSave := "O título não foi incluído: O Banco vinculado ao Fornecedor é diferente do informado." 
			Return .F.
		EndIf
	EndIf


Return .T.

/*/{Protheus.doc} openTables
//Abre as tabelas necessárias para o Processo
@author yuri.volpe
@since 13/07/2020
@version 1.0

@type function
/*/
Method openTables() Class TituloRemuneracao

	dbSelectArea("SA2") //Fornecedor
	dbSelectArea("SA6") //Bancos
	dbSelectArea("SE2") //Títulos
	dbSelectArea("SZ3") //Parceiros
	dbSelectArea("ZZ6") //Fechamento Remuneração
	dbSelectArea("ZZ7") //Antecipação de Remuneração

Return

/*/{Protheus.doc} getNumeroTitulo
//Recupera o último título incluído no financeiro e devolve
//num atributo para uso da rotina de inclusão de títulos
@author yuri.volpe
@since 16/07/2020
@version 1.0

@type function
/*/
Method getNumeroTitulo() Class TituloRemuneracao

	If Select("TMPCNTTIT") > 0
		TMPCNTTIT->(dbCloseArea())
	EndIf
	
	BeginSql Alias "TMPCNTTIT"
		SELECT MAX(E2_NUM) ULTIMO_TITULO
		FROM SE2010
			WHERE E2_FILIAL = ' '
			AND E2_TIPO = 'PA'
			AND E2_PREFIXO = 'REM'
			AND D_E_L_E_T_ = ' '
	EndSql

	::numeroTitulo := Soma1(TMPCNTTIT->ULTIMO_TITULO)
	
	TMPCNTTIT->(dbCloseArea())

Return

/*/{Protheus.doc} podeGerar
//Valida se não há titulos gerados para o parceiro e se há fechamento
//no mês para o parceiro.
@author yuri.volpe
@since 16/07/2020
@version 1.0

@type function
/*/
Method podeGerar() Class TituloRemuneracao

	dbSelectArea("ZZ6")
	ZZ6->(dbSetOrder(1))
	If ZZ6->(dbSeek(xFilial("ZZ6") + ::periodo + ::codigoEntidade))
		If !Empty(ZZ6->ZZ6_PREFIX) .And. !Empty(ZZ6->ZZ6_NUM)
			::mensagemSave := "Já existe um título criado para a entidade no período indicado: " + ZZ6->ZZ6_PREFIX + ZZ6->ZZ6_NUM + ZZ6->ZZ6_PARCEL + ZZ6->ZZ6_TIPO
			Return .F.
		EndIf
	Else
		::mensagemSave := "O título não foi criado, pois não existe registro de fechamento para o Parceiro. Verifique a importação do arquivo consolidado. " +;
		 	::codigoEntidade + " - " + AllTrim(GetAdvFVal("SZ3", "Z3_DESENT", xFilial("SZ3") + ::codigoEntidade, 1, ::codigoEntidade, .T.))
		Return .F.
	EndIf	
	
Return .T.

/*/{Protheus.doc} toCSVHeader
//Retorna o cabeçalho dos dados do título em formato CSV
@author yuri.volpe
@since 16/07/2020
@version 1.0

@type function
/*/
Method toCSVHeader() Class TituloRemuneracao
Return "Prefixo;NumeroTitulo;Parcela;TipoTitulo;Parceiro;Fornecedor;Loja;ValorPeriodo1;ValorPeriodo2;ValorPeriodo3;Somatoria;Percentual;Valor;Observação"

/*/{Protheus.doc} toCSV
//Retorna o objeto em formato CSV
@author yuri.volpe
@since 16/07/2020
@version 1.0

@type function
/*/
Method toCSV() Class TituloRemuneracao
Return ::prefixo + ";" + ::numeroTitulo + ";" + ::parcela + ";" + ::tipoTitulo + ";" + ::codigoEntidade + ";" +;
		::fornecedor + ";" + ::lojaFornecedor + ";" + cValToChar(::valorPeriodo1) + ";" + cValToChar(::valorPeriodo2) + ";" + cValToChar(::valorPeriodo3) + ";" +;
		cValToChar(::somatoria) + ";" + cValToChar(::percentual) + ";" + cValToChar(::valor) 
		
/*/{Protheus.doc} toArrayHeader
//Retorna o Header em formato Array
@author yuri.volpe
@since 16/07/2020
@version 1.0

@type function
/*/
Method toArrayHeader() Class TituloRemuneracao
Return StrTokArr2(TituloRemuneracao():toCSVHeader(),";",.T.)

/*/{Protheus.doc} toArray
//Retorna o Objeto em formato Array e possibilita a inclusão de 
//uma observação no último campo.
@author yuri.volpe
@since 16/07/2020
@version 1.0
@param cObsExtra, characters, String com observação adicional
@type function
/*/
Method toArray(cObsExtra) Class TituloRemuneracao

	Local aRet := StrTokArr2(::toCSV(),";",.T.) 
	Default cObsExtra := ""
	
	aAdd(aRet, cObsExtra)
	
Return aRet