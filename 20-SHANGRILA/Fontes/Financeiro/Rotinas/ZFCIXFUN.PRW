#INCLUDE "PROTHEUS.CH"

#DEFINE PULALINHA CHR(13)+CHR(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} xFciIniEnv

Inicializacao do ambiente da rotina

@param	aWizard		-> Array com conteudo dos campos preenchidos na wizard
					   da Rotina (Referencia)
		lMultFil	-> Indica se o processamento sera feito utilizando selecao
					   de filiais (Referencia)
		aLisFil		-> Array com as filiais que serao processadas (Referencia)
		cFilDe		-> Filial Inicial (Referencia)
		cFilAte		-> Filial Final (Referencia)
		aError		-> Verificacao de possiveis erros na inicializacao da rotina

@return	lRet	->	Continua processamento da rotina

@owner	SIGAFIS - Livros Fiscais

@author Luccas Curcio                                         	
@since 26/03/2013
@version 1.0
/*/
//-------------------------------------------------------------------
User Function ZxFciIniEnv( aWizard , lMultFil , aLisFil , cFilDe , cFilAte , aError )
	Local	lRet	:=	.F.
	Local	nX		:=	0
	Local	cMsgErro:=	""
	
	If aScan( aError, {|x| x[1] } ) == 0

		If Len( aWizard	:=	ZxFciWizard() ) > 0
		
			lRet	:=	.T.
	
		//------------------------------------------------------
		// Abertua de tabelas utilizadas no processamento
		//------------------------------------------------------
			DbSelectArea("SD3")
			SD3->(DbSetOrder(1))	//D3_FILIAL+D3_OP+D3_COD+D3_LOCAL
			DbSelectArea("SD1")
			SD1->(DbSetOrder(7))	//D1_FILIAL+D1_COD+D1_LOCAL+DTOS(D1_DTDIGIT)+D1_NUMSEQ
			DbSelectArea("CFD")
			CFD->(DbSetOrder(2))	//CFD_FILIAL+CFD_COD+CFD_PERCAL+CFD_PERVEN
			DbSelectArea("SF2")
			SF2->(DbSetOrder(1))	//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
			DbSelectArea("SD2")
			SD2->(DbSetOrder(3))	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))	//B1_FILIAL+B1_COD
			DbSelectArea("SA8")
			SA8->(DbSetOrder(1))	//A8_FILIAL+A8_COD+A8_PERIOD
		
		//------------------------------------------------------
		// Selecao de filiais
		//------------------------------------------------------
			lMultFil	:=	Substr( aWizard[1][5] , 1 , 1 ) $ "1"
		
		//------------------------------------------------------------------------------------------------------------
		//
		//
		//								Selecao de filiais que serao processadas na rotina
		//
		//
		//------------------------------------------------------------------------------------------------------------
			If lMultFil
		
				aLisFil		:=	MatFilCalc(.T.)
			
				If !Empty(aLisFil)
					cFilDe	:=	PadR("",FWGETTAMFILIAL)
					cFilAte	:=	Repl("Z",FWGETTAMFILIAL)
				Else
					MsgAlert( OemToAnsi( "Nenhuma filial foi selecionada para o processamento. Sera considerada a filial corrente" ) )	//"Nenhuma filial foi selecionada para o processamento. Sera considerada a filial corrente"
				
				//Para considerar a filial corrente, preciso alem de atribuir o cFilAnt, preciso forcar a
				//opcao .F. na variavel que indica opcao de Multi Filiais
					lMultFil	:=	.F.
					cFilDe		:=	cFilAnt
					cFilAte		:=	cFilAnt
				EndIf
			Else
				cFilDe	:=	cFilAnt
				cFilAte	:=	cFilAnt
			EndIf
		Endif

	Else

		cMsgErro	:=	"Para correta execução da rotina, verificar ocorrências abaixo:" + CRLF + CRLF	//"Para correta execução da rotina, verificar ocorrências abaixo:"
	
	// -----------------------------------------------------------
// Listo todos os erros encontrados na pre-validacao da rotina
	// -----------------------------------------------------------
		For nX := 1 To Len( aError )
			If aError[nX][1]
				cMsgErro	+=	aError[nX][2] + CRLF
			Endif
		Next nX
	
		MsgInfo( cMsgErro , "Aviso!" )	//"Aviso!"
	
	Endif


Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CIxOrigem

Retorna o codigo da origem conforme Conteudo de Importacao informado
como parametro

@param	nCI		->	Percentual do Conteudo de Importacao

@return cOrigem	->	Codigo da Origem

@owner	SIGAFIS - Livros Fiscais

@author Luccas Curcio 
@since 04/09/2013
@version 11.0

/*/
//-------------------------------------------------------------------
User Function ZCIxOrigem( nCI )
	Local	cOrigem	:=	""

	Do Case
	// 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8
	Case nCI == 0
		cOrigem := "0"
		
	// 1 - Estr.(Importacao Direta)
	Case nCI == 100
		cOrigem := "1"
	
	// 3 - Nacional-Mer/bem Cont de Import sup 40% e inf/igual 70%	
	Case nCI > 40 .And. nCI <= 70
		cOrigem := "3"
	
	// 5 - Nacional-Merc/bem com Cont de Import inf ou igual a 40%	
	Case nCI > 0 .And. nCI < 40
		cOrigem := "5"
	
	// 8 - Nacional-Merc/bem com Cont de Import superior a 70%	
	Case nCI > 70
		cOrigem := "8"
	End Case

Return cOrigem

//-------------------------------------------------------------------
/*/{Protheus.doc} XFciX6ToQry

Valida conteudo dos parametros da rotina

@param	cContent->	Conteudo do parametro

@return cRet	->	Conteudo que sera utilizado nos processamentos

@owner	SIGAFIS - Livros Fiscais

@author Luccas Curcio 
@since 02/09/2013
@version 11.0

/*/

//-------------------------------------------------------------------
User Function ZXFciX6ToQry( cContent )
	Local cRet	:=	""
	Local nX	:=	0

	If Len( cContent ) > 0
	
	//Inserindo aspas e virgulas para a query
		cRet := "'"
	
		For nX := 1 To Len( cContent )
			If SubStr( cContent , nX , 1 ) $ ";,-_|./"
				cRet += "','"
			Else
				cRet += SubStr( cContent , nX , 1 )
			Endif
		Next
	
		cRet += "'"
	Endif

Return cRet

//-------------------------------------------------------------------
/*/{Protheus.doc} XFciFileName

Retorna nome do arquivo do relatorio

@return cFileName	->	Nome do arquivo

@owner	SIGAFIS - Livros Fiscais

@author Luccas Curcio 
@since 19/08/2013
@version 11.0

/*/

//-------------------------------------------------------------------
User Function ZXFciFileName()
	Local	cFileName	:=	Nil
	Local	cAux		:=	Nil

	cFileName	:=	"TOTVSFCI_"
	cFileName	+=	DToS( Date() ) + "_"

	cAux	:=	Time()
	cAux	:=	StrTran( cAux , ":" , "" )

	cFileName	:=	cFileName + cAux

Return cFileName

//-------------------------------------------------------------------
/*/{Protheus.doc} ZxFciWizard

Wizard principal da rotina

Funcao que monta wizard para preenchimento das informacoes que serao
utilizadas no processamento do arquivo da FCI

@param	Nil
 	   
@return	aWizard	->	Array com conteudo preenchido na wizard

@owner	SIGAFIS - Livros Fiscais

@author Luccas Curcio
@since 26/03/2013
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ZxFciWizard()
	Local	aFirstTxt	:=	{}
	Local	aGetParam	:=	{}
	Local	aWizard		:=	{}
	Local	cNameWiz	:=	"FSA061NW"+FWGETCODFILIAL


	aAdd (aFirstTxt, "Rotina de Processamento do Arquivo Magnético da FCI.")
	aAdd (aFirstTxt, "")
	aAdd (aFirstTxt, "Preencha corretamente as perguntas para processamento da rotina.")
	aAdd (aFirstTxt, "Informações necessárias para o processamento do Arquivo Magnético da FCI.")


	aAdd (aGetParam, {})
	aAdd (aGetParam[1], "Preencha corretamente as informações solicitadas.")
	aAdd (aGetParam[1], "Parâmetros para Processamento")
	aAdd (aGetParam[1], {})

	aAdd (aGetParam[1][3], {1,"Data de",,,,,,})
	aAdd (aGetParam[1][3], {2,,,3,,,,,,,,{"xMagGetCon",1}})

	aAdd (aGetParam[1][3], {0,"",,,,,,})
	aAdd (aGetParam[1][3], {0,"",,,,,,})

	aAdd (aGetParam[1][3], {1,"Data Até",,,,,,})
	aAdd (aGetParam[1][3], {2,,,3,,,,,,,,{"xMagGetCon",1}})

	aAdd (aGetParam[1][3], {0,"",,,,,,})
	aAdd (aGetParam[1][3], {0,"",,,,,,})

	aAdd (aGetParam[1][3], {1,"Produto De",,,,,,})
	aAdd (aGetParam[1][3], {2,,Replicate("X",TamSX3("B1_COD")[1]),1,,,,TamSX3("B1_COD")[1],,,"SB1"})

	aAdd (aGetParam[1][3], {0,"",,,,,,})
	aAdd (aGetParam[1][3], {0,"",,,,,,})

	aAdd (aGetParam[1][3], {1,"Produto Até",,,,,,})
	aAdd (aGetParam[1][3], {2,,Replicate("X",TamSX3("B1_COD")[1]),1,,,,TamSX3("B1_COD")[1],,,"SB1"})

	aAdd (aGetParam[1][3], {0,"",,,,,,})
	aAdd (aGetParam[1][3], {0,"",,,,,,})

	aAdd (aGetParam[1][3], {1,"Seleciona Filiais?",,,,,,})
	aAdd (aGetParam[1][3], {3,,,,,{"1 - Sim" , "2 - Não"},,})

	aAdd (aGetParam[1][3], {0,"",,,,,,})
	aAdd (aGetParam[1][3], {0,"",,,,,,})

	aAdd (aGetParam[1][3], {1,"Versão",,,,,,})
	aAdd (aGetParam[1][3], {2,,Replicate("X",4),1,,,,4})


	If xMagWizard (aFirstTxt, aGetParam, cNameWiz)
		xMagLeWiz(cNameWiz,@aWizard,.T.)
	Endif

Return aWizard

//-------------------------------------------------------------------
/*/{Protheus.doc} XFciGetOrigem

Retorna codigo de origem e codigo da fci conforme produto e periodo
enviados como parametro

@param	cCodProd	->	Codigo do Produto
		dDtEmissao	->	Data de Emissao do movimento

@return Array	->	1 - Codigo da Origem
					2 - Codigo da FCI

@owner	SIGAFIS - Livros Fiscais

@author Luccas Curcio 
@since 09/09/2013
@version 11.0

/*/
//-------------------------------------------------------------------
Static Function ZXFciGetOrigem( cCodProd , dDtEmissao )
	Local cPeriod := Alltrim( StrZero( Month( dDtEmissao ) , 2 ) ) + Alltrim( Str( Year( dDtEmissao ) ) )
	Local cOrigem := ""
	Local cFciCod := ""

	If AliasInDic( "CFD" ) .And. CFD->( FieldPos( "CFD_ORIGEM" ) ) > 0
		CFD->( DbSetOrder( 2 ) )	//PRODUTO + PERIODO
		If CFD->( MsSeek( xFilial( "CFD" ) + cCodProd + cPeriod ) )
			cOrigem := CFD->CFD_ORIGEM
			cFciCod	:= CFD->CFD_FCICOD
		Else
			cOrigem := Space( TamSX3( "CFD_ORIGEM" )[1] )
			cFciCod := Space( TamSX3( "CFD_FCICOD" )[1] )
		Endif
	Endif

Return { cOrigem , cFciCod }

//-------------------------------------------------------------------
/*/{Protheus.doc} ZXFciVIEnt

Retorna a formula a ser utilizada para calculo da Parcela Importada de
acordo com a configuracao do campo F4_AGREG

@param	cTpAgreg	->	Configuracao utilizada no campo F4_AGREG

@return cRet	->	String com formula a ser aplicada

@owner	SIGAFIS - Livros Fiscais

@author Luccas Curcio 
@since 09/09/2013
@version 11.0

/*/
//-------------------------------------------------------------------
User Function ZXFciVIEnt( cTpAgreg )
	Local	cRet	:=	''

// --------------------------------------------------------------------------------------------
// S - O valor da mercadoria será agregado ao total do documento.
// --------------------------------------------------------------------------------------------
	If cTpAgreg == 'S'
		cRet	:=	'( ( ( D1_TOTAL+D1_VALFRE+D1_SEGURO ) - D1_II ) / D1_QUANT )'
	
// --------------------------------------------------------------------------------------------	
// I - O valor da mercadoria não contém o valor do ICMS, portanto, o valor do ICMS e da
// mercadoria será agregado ao total do documento.
// --------------------------------------------------------------------------------------------
	Elseif cTpAgreg == 'I'
		cRet	:=	'( ( ( D1_TOTAL+D1_VALFRE+D1_SEGURO ) - ( D1_II ) ) / D1_QUANT )'

// --------------------------------------------------------------------------------------------
// A - O valor da mercadoria não contém o valor do ICMS, mas somente o valor da mercadoria
// será agregado ao total do documento. Note que a base de cálculo do ICMS sofrerá
// a incorporação do valor do ICMS.
// --------------------------------------------------------------------------------------------
	Elseif cTpAgreg == 'A'
		cRet	:=	'( ( D1_TOTAL+D1_VALFRE+D1_SEGURO ) / D1_QUANT )'

// --------------------------------------------------------------------------------------------
// N - O valor da mercadoria não será agregado ao total do documento. Esse valor poderá
// ser escriturado, ou não, conforme a parametrização do sistema.
// --------------------------------------------------------------------------------------------
	Elseif cTpAgreg == 'N'
		cRet	:=	'( ( D1_TOTAL+D1_VALFRE+D1_SEGURO ) / D1_QUANT )'

// --------------------------------------------------------------------------------------------
// B - O valor da mercadoria não contém o valor do ICMS, portanto, o valor do ICMS e da
// mercadoria será agregado ao total do documento. Este agregador de valor não calcula
// nenhum imposto, mantendo-se o que for informado pelo usuário ou transmitido por outro sistema
// --------------------------------------------------------------------------------------------
	Elseif cTpAgreg == 'B'
		cRet	:=	'( ( ( D1_TOTAL+D1_VALFRE+D1_SEGURO ) - ( D1_II ) ) / D1_QUANT )'

// --------------------------------------------------------------------------------------------
// C - O valor da mercadoria não contém o valor do ICMS, mas somente o valor da mercadoria será
// agregado ao total do documento. Note que a base de cálcu do ICMS sofrerá a incorporação do valor
// do ICMS. Este agregador de valor não calcula nenhum imposto, mantendo-se o q for informado
// pelo usuário ou transmitid por outro sistema.
// --------------------------------------------------------------------------------------------
	Elseif cTpAgreg == 'C'
		cRet	:=	'( ( ( D1_TOTAL+D1_VALFRE+D1_SEGURO ) - ( D1_II ) ) / D1_QUANT )'

// --------------------------------------------------------------------------------------------
// H - Somente o valor do ICMS Retido será agregado ao total do documento fiscal.
// --------------------------------------------------------------------------------------------
	Elseif cTpAgreg == 'H'
		cRet	:=	'( ( ( D1_TOTAL+D1_VALFRE+D1_SEGURO ) - ( D1_ICMSRET ) ) / D1_QUANT )'

// --------------------------------------------------------------------------------------------
// R - Deduz o valor do ICMS do valor unitario da mercadoria nos casos de redução de base de cálculo.
// --------------------------------------------------------------------------------------------
	Elseif cTpAgreg == 'R'
		cRet	:=	'( ( D1_TOTAL+D1_VALFRE+D1_SEGURO ) / D1_QUANT )'

// -- Formula Generica	
	Else
		cRet	:=	'( ( ( D1_TOTAL+D1_VALFRE+D1_SEGURO ) - ( D1_VALICM+D1_II ) ) / D1_QUANT )'
	
	Endif

Return cRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |FciUltPr   ºAutor  ³Anieli Rodrigues   º Data ³  29/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Verifica qual o ultimo periodo no qual houve entrada  	  º±±
±±º			 ³do produto antes do periodo informado 					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpA1: cProduto - Produto a ser avaiado                     º±±
±±º			 ³ExpA2: cMes	  - Mes a ser avaliado				          º±±
±±º			 ³ExpA3: cAno	  - Ano a ser avaliado				          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno	 ³cPeriodo: Mes e Ano. String 000000 caso nenhuma entrada     º±±
±±º			 ³seja localizada							                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       |FISA061 - Materiais                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                

Static Function ZFciUltPr(cProduto,cMes,cAno)

	Local aAreaSD1	:= SD1->(GetArea())
	Local cAlias 	:= ""
	Local cDbType	:= TCGetDB()
	Local cFuncNull	:= ""
	Local cQuery 	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Nome da funcao do banco de dados que substitui NULL por 0³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
	Case cDbType $ "DB2/POSTGRES"
		cFuncNull	:= "COALESCE"
	Case "ORACLE" $ cDbType
		cFuncNull	:= "NVL"
	Otherwise
		cFuncNull	:= "ISNULL"
	EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua query para retornar o periodo no qual houve a ultima entrada de nota para o produto|
//| Caso nao localize, o retorno sera a string 000000										  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cAlias := GetNextAlias()
	cQuery	:= "SELECT " + cFuncNull + " (SUBSTRING(MAX(SD1.D1_EMISSAO),1,6),'000000') AS PERIODO"
	cQuery += "FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += " WHERE (SD1.D1_FILIAL = '"+xFilial('SD1')+"')"
	cQuery += " AND (SD1.D1_COD = '"+cProduto+"' AND SUBSTRING(SD1.D1_EMISSAO,1,6) <= '"+cAno+cMes+"' "
	cQuery += " AND D1_TIPO = 'N' AND D_E_L_E_T_ = '')"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	cMes := Substr((cAlias)->(PERIODO),5,2)
	cAno := Substr((cAlias)->(PERIODO),1,4)

	cQryZ1 +=  cQuery + PULALINHA

	(cAlias)->(DbCloseArea())

	RestArea(aAreaSD1)

Return cMes+cAno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ZFciMedEnt(  ºAutor  ³Anieli Rodrigues   º Data ³  03/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Grava a media do valor importado para os produtos comprados º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpA1: cMes		- Mes a ser calculado  			          º±±
±±º			 ³ExpA2: cAno		- Ano a ser calculado  	 		          º±±
±±º			 ³ExpA3: cProdDe 	- Range de produtos 				      º±±
±±º			 ³ExpA4: cProdAte	- Range de produtos                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       |FISA061 - Materiais                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                

Static Function ZFciMedEnt(cMes,cAno,cProdDe,cProdAte)

	Local aAreaSD1	:= SD1->(GetArea())
	Local cQuery 	:= ""
	Local cDbType	:= TCGetDB()
	Local cFuncNull := ""

/*                                    
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Tabela A - Origem da Mercadoria ou Servico                                                                                                    |
|																																				|
|0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8																						|
|1 - Estrangeira - Importação direta, exceto a indicada no código 6;																			|
|2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;																	|
|3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% (quarenta por cento) e inferior ou igual a 70% (setenta por cento);  |
|4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam o Decreto-Lei nº 288/67,        |
|e as Leis nº 8.248/91, 8.387/91, 10.176/01 e 11.484/07;                                                                                        |
|5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40% (quarenta por cento);                                       |
|6 - Estrangeira - Importação direta, sem similar nacional, constante em lista de Resolução CAMEX e gás natural;                                |
|7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista de Resolução CAMEX e gás natural.                     |
|8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70% (setenta por cento).													|
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

	cAlias := GetNextAlias()

	Do Case
	Case cDbType $ "DB2/POSTGRES"
		cFuncNull	:= "COALESCE"
	Case "ORACLE" $ cDbType
		cFuncNull	:= "NVL"
	Otherwise
		cFuncNull	:= "ISNULL"
	EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua query para retornar todos as entradas de materia prima do periodo, agrupadas		  |
//| por codigo de produto. 																	  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := "SELECT SUM(SD1.D1_QUANT) AS QUANTIDADE, "
	cQuery += "SUM("
	cQuery +="CASE WHEN SF4.F4_AGREG IN ('I','S') THEN ((SD1.D1_TOTAL+SD1.D1_VALFRE+SD1.D1_SEGURO)-(SD1.D1_II)) "
	cQuery += "WHEN SF4.F4_AGREG IN ('C','B') THEN ((SD1.D1_TOTAL+SD1.D1_VALFRE+SD1.D1_SEGURO)- " + cFuncNull + " (SWN.WN_IIVAL,SD1.D1_II)) "
	cQuery += "WHEN SF4.F4_AGREG IN ('A','N','R') THEN ((SD1.D1_TOTAL+SD1.D1_VALFRE+SD1.D1_SEGURO)) "
	cQuery += "WHEN SF4.F4_AGREG = 'H' THEN ((SD1.D1_TOTAL+SD1.D1_VALFRE+SD1.D1_SEGURO)-(SD1.D1_ICMSRET)) "
	cQuery += "ELSE ((SD1.D1_TOTAL+SD1.D1_VALFRE+SD1.D1_SEGURO)-(SD1.D1_VALICM+SD1.D1_II)) END"
	cQuery += "*(CASE WHEN SUBSTRING(SD1.D1_CLASFIS,1,1) = '5' THEN 0 "
	cQuery += "WHEN SUBSTRING(SD1.D1_CLASFIS,1,1) = '3' THEN 0.5 "
	cQuery += "WHEN SUBSTRING(SD1.D1_CLASFIS,1,1) = '0' THEN 0 "
	cQuery += "WHEN SUBSTRING(SD1.D1_CLASFIS,1,1) = '8' THEN 1 "
	cQuery += "WHEN SUBSTRING(SD1.D1_CLASFIS,1,1) = '2' THEN 1 "
	cQuery += "WHEN SUBSTRING(SD1.D1_CLASFIS,1,1) = '1' THEN 1 ELSE 0 END)) AS VI, "
	cQuery += "SD1.D1_COD "
	cQuery += "FROM "+RetSqlName("SD1")+" SD1 JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_FILIAL = '"+xFilial('SF4')+"' "
	cQuery += "AND SF4.F4_CODIGO = SD1.D1_TES "
	cQuery += "AND SF4.D_E_L_E_T_ = '' "
	cQuery += "LEFT JOIN " + RetSqlName ("SWN") + " SWN ON SWN.WN_FILIAL = SD1.D1_FILIAL "
	cQuery += "AND SWN.WN_DOC = SD1.D1_DOC AND SWN.WN_SERIE = SD1.D1_SERIE AND (SWN.WN_TEC+SWN.WN_EX_NCM+SWN.WN_EX_NBM) = SD1.D1_TEC "
	cQuery += "AND SWN.WN_FORNECE = SD1.D1_FORNECE AND SWN.WN_LOJA = SD1.D1_LOJA AND SWN.WN_PRODUTO = SD1.D1_COD AND SWN.WN_ITEM = SD1.D1_ITEM "
	cQuery += " AND SWN.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE SD1.D1_FILIAL = '"+xFilial('SD1')+"' AND SUBSTRING(SD1.D1_EMISSAO,1,6) = '"+cAno+cMes
	cQuery += "' AND SD1.D_E_L_E_T_ = '' AND SD1.D1_COD >= '"+cProdDe+"' AND SD1.D1_COD <= '"+cProdAte+"'"+" AND SD1.D1_TIPO = 'N' "
	cQuery += "GROUP BY SD1.D1_COD"

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	cQryZ1 +=  cQuery + PULALINHA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava todos os VIs localizados na tabela SA8.											  |
//| Formula do VI:  (D1_TOTAL + D1_VALFRE + D1_SEGURO ) -  (D1_VALICM + D1_VALIPI) / D1_QUANT | 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	While !(cAlias)->(Eof())
		DbSelectArea('SA8')
		SA8->(DbSetOrder(1))
		If !MsSeek(xFilial('SA8')+(cAlias)->D1_COD+cMes+cAno)
			RecLock('SA8',.T.)
			Replace A8_FILIAL 	With xFilial('SA8'),;
				A8_COD 		With(cAlias)->D1_COD,;
				A8_PERIOD	With cMes+cAno,;
				A8_VLRVI 	With (cAlias)->(VI)/(cAlias)->(QUANTIDADE),;
				A8_PROCOM	With "C"
			SA8->(MsUnlock())
		Else
			RecLock('SA8',.F.)
			Replace   A8_VLRVI 	With (cAlias)->VI/(cAlias)->QUANTIDADE,;
				A8_PROCOM	With "C"
			SA8->(MsUnlock())
		EndIf
		(cAlias)->(DbSkip())
	EndDo

	(cAlias)->(DbCloseArea())

	RestArea(aAreaSD1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |FciMedPr	 ºAutor  ³Anieli Rodrigues   º Data ³  03/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Grava a media do valor importado para os produtos fabricadosº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpA1: cMes		- Mes a ser calculado  			          º±±
±±º			 ³ExpA2: cAno		- Ano a ser calculado  	 		          º±±
±±º			 ³ExpA3: cProdDe 	- Range de produtos 				      º±±
±±º			 ³ExpA4: cProdAte	- Range de produtos                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       |FISA061 - Materiais                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    

Static Function ZFciMedPr(cMes,cAno,cProdDe,cProdAte)

	Local aAreaSD3	:= SD3->(GetArea())
	Local cAliasSB1 := ""
	Local cQuery 	:= ""

	cAliasSB1 := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua query para obter o periodo da ultima producao de todos os produtos acabados.		  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := "SELECT SUBSTRING(MAX(SD3.D3_EMISSAO),1,6) AS PERIODO, "
	cQuery += "D3_COD PRODUTO FROM "+RetSqlName("SD3")+" SD3 LEFT JOIN "+RetSqlName("SB1")+" SB1 "
	cQuery += "ON B1_FILIAL = '"+xFilial('SB1')+"' AND SB1.B1_COD = SD3.D3_COD "
	cQuery += "WHERE SD3.D3_CF IN ('PR0','PR1') "
	cQuery += "AND SD3.D3_COD >= '"+cProdDe+"' AND SD3.D3_COD <= '"+cProdAte+"' "
	cQuery += "AND SUBSTRING((SD3.D3_EMISSAO),1,6) <= '" + cAno+cMes +"' "
	cQuery += "AND SD3.D_E_L_E_T_ = '' AND SD3.D3_ESTORNO = '' "
	cQuery += "AND SB1.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY SD3.D3_COD "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)

	cQryZ1 +=  cQuery + PULALINHA

	While !(cAliasSB1)->(Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o produto foi produzido em periodo anterior ao que esta sendo calculado       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Substr((cAliasSB1)->PERIODO,5,2)+Substr((cAliasSB1)->PERIODO,1,4) < cMes+cAno
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se ja existe registro na SA8 para o produto e periodo|
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SA8->(DbSetOrder(1))
			If SA8->(MsSeek(xFilial("SA8")+(cAliasSb1)->PRODUTO+Substr((cAliasSB1)->PERIODO,5,2)+Substr((cAliasSB1)->PERIODO,1,4)))
				(cAliasSB1)->(DbSkip())
				Loop
			Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se nao localizado na SA8, sera necessario apurar sua media |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ZFciMedPer((cAliasSb1)->PRODUTO,Substr((cAliasSB1)->PERIODO,5,2),Substr((cAliasSB1)->PERIODO,1,4))
				(cAliasSB1)->(DbSkip())
				Loop
			EndIf
		Else
			ZFciMedPer((cAliasSb1)->PRODUTO,Substr((cAliasSB1)->PERIODO,5,2),Substr((cAliasSB1)->PERIODO,1,4))
			(cAliasSB1)->(DbSkip())
		EndIf
	EndDo

	RestArea(aAreaSD3)
                                       
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |FciExplReq ºAutor  ³Anieli Rodrigues   º Data ³  04/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Explode as requisicoes e devolve o somatorio do VI de cada  º±±
±±º			 ³materia prima utilizada na requisicao. (Recursiva) 		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpA1: cOp  - Op a ter as requisicoes explodidas  	      º±±
±±º			 ³ExpA2: cMes - Mes a ser avaliado					          º±±
±±º			 ³ExpA3: cAno - Ano a ser avaliado				  	          º±±
±±º			 ³ExpA4: cProd - Produto pai da ordem de producao 	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³nVi : Valor da parcela importada do produto acabado 	      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       |FISA061 - Materiais                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
Static Function ZFciExplReq(cOp,cMes,cAno,cProd)

	Local cAliasReq := GetNextAlias()
	Local cAliasPi	:= GetNextAlias()
	Local cAliasSD3 := SD3->(GetArea())
	Local cCccusto 	:= Criavar("B1_CCCUSTO",.F.)
	Local cPeriodo 	:= ""
	Local cQuery 	:= ""
	Local nVi 		:= 0
	Default cProd 	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua query para localizar todas as requisicoes realizadas para a OP        			  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT SUM(D3_QUANT) AS QUANTIDADE, SD3.D3_COD "
	cQuery += "FROM "+RetSqlName("SD3")+" SD3 JOIN "+RetSqlName("SB1")+" SB1 "
	cQuery += "ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SD3.D3_COD "
	cQuery += "WHERE SD3.D3_FILIAL = '"+xFilial('SD3')+"' "
	cQuery += "AND SD3.D_E_L_E_T_ = '' AND SD3.D3_ESTORNO = '' "
	cQuery += "AND SD3.D3_OP = '"+cOP+"' AND SD3.D3_CF LIKE ('RE%') "
	cQuery += "AND SUBSTRING (SB1.B1_COD,1,3) <> 'MOD' "
	cQuery += "AND SB1.B1_CCCUSTO = '"+cCccusto+"' "
	cQuery += "GROUP BY D3_COD ORDER BY SD3.D3_COD"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasReq,.T.,.T.)

	cQryZ1 +=  cQuery + PULALINHA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua query para avaliar se o produto requisitado foi produzido ou fabricado   			  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !(cAliasReq)->(Eof())
		cProd := (cAliasReq)->D3_COD
		cQuery := "SELECT SUBSTRING(MAX(SD3.D3_EMISSAO),1,6) AS PERIODO "
		cQuery += " FROM "+RetSqlName("SD3")+" SD3"
		cQuery += "WHERE SD3.D3_FILIAL = '"+xFilial('SD3')+"' "
		cQuery += "AND SD3.D_E_L_E_T_ = '' AND SD3.D3_ESTORNO = '' "
		cQuery += "AND SD3.D3_CF IN ('PR0','PR1') AND SD3.D3_COD = '" +cProd+"' "
		cQuery += "AND SUBSTRING (SD3.D3_EMISSAO,1,6) <= '"+cAno+cMes+"'"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasPi,.T.,.T.)
	
		cQryZ1 +=  cQuery + PULALINHA
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso o produto requisitado tenha sido produzido, calcula a media de suas producoes no periodo   |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty((cAliasPI)->PERIODO)
			ZFciMedPr(Substr((cAliasPi)->PERIODO,5,2),Substr((cAliasPi)->PERIODO,1,4),cProd,cProd)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Apos calcular a media, recupera o valor gravado na SA8							               |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SA8->(MsSeek(xFilial('SA8')+cProd+Substr((cAliasPi)->PERIODO,5,2)+Substr((cAliasPi)->PERIODO,1,4)))
				nVi += SA8->A8_VLRVI*(cAliasReq)->QUANTIDADE
			EndIf
		Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso o produto requisitado tenha sido comprado, localiza se existe SA8 para o periodo           |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SA8->(DbSetOrder(1))
			If SA8->(MsSeek(xFilial('SA8')+(cAliasReq)->D3_COD+cMes+cAno))
				nVi += SA8->A8_VLRVI*(cAliasReq)->QUANTIDADE
			Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se nao houver SA8, verifica quando foi a ultimo aquisicao do produto.       					   |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cPeriodo := ZFciUltPr((cAliasReq)->D3_COD,cMes,cAno)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se nao houve compra para o produto, pode ser utilizado o ponto de entrada 'FCIINFVI' para 	   |
			//³informacao do valor. Caso contrario, sera assumido que a parcela de importacao eh zero	 	   |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cPeriodo == "000000"
					If ExistBlock('FCIINFVI')
						nVi += ExecBlock('FCIINFVI',.F.,.F.,{(cAliasReq)->D3_COD,cMes,cAno})
					Else
						nVi += 0
					EndIf
				Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se houve compra em mes anterior, verifica que se o VI deste mes ja esta apurado na SA8. 		   |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SA8->(MsSeek(xFilial('SA8')+(cAliasReq)->D3_COD+cPeriodo))
						nVi += SA8->A8_VLRVI*(cAliasReq)->QUANTIDADE
					Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se nao ha SA8 processa sua gravacao e obtencao do VI do mes correspondente. 					   |
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						ZFciMedEnt(Substr(cPeriodo,1,2),Substr(cPeriodo,3,4),(cAliasReq)->D3_COD,(cAliasReq)->D3_COD)
						If SA8->(MsSeek(xFilial('SA8')+(cAliasReq)->D3_COD+cPeriodo))
							nVi += SA8->A8_VLRVI*(cAliasReq)->QUANTIDADE
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		(cAliasPI)->(DbCloseArea())
		(cAliasReq)->(DbSkip())
	End
	(cAliasReq)->(DbCloseArea())
	RestArea(cAliasSD3)

Return nVi

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |FciMatCalc ºAutor  ³Anieli Rodrigues   º Data ³  06/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Processamento principal do FCI                              º±±
±±º			 ³ A tabela SA8 sera alimentada para produtos comprados e     º±±
±±º			 ³produzidos para ser utiliza na apuracao da FCI              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpC1: cMes     - Mes a processar                           º±±
±±º			 ³ExpC2: cAno     - Ano a processar                           º±±
±±º			 ³ExpC3: cProdDe  - Do Produto                                º±±
±±º			 ³ExpC4: cProdAte - Ate o produto                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       |FISA061 - Materiais                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                                
User Function ZFciMatCalc(cMes,cAno,cProdDe,cProdAte)

	Private aProc  	:= {}
	Static cTexto  	:= "Existem produtos com recursividade na estrutura obtida através da movimentacao. Abaixo serao listadas as ordens de producao cujo calculo da parcela importada foi comprometido por este motivo: "+PULALINHA //"Existem produtos com recursividade na estrutura obtida através da movimentacao. Abaixo serao listadas as ordens de producao cujo calculo da parcela importada foi comprometido por este motivo: "+PULALINHA //"Existem produtos com recursividade na estrutura obtida através da movimentacao. Abaixo serao listadas as ordens de producao cujo calculo da parcela importada foi comprometido por este motivo: "+PULALINHA //"Existem produtos com recursividade na estrutura obtida através da movimentacao. Abaixo serao listadas as ordens de producao cujo calculo da parcela importada foi comprometido por este motivo: "
	Static lErro	:= .F.

	cProdDe  := PadR(cProdDe,tamsx3('D3_COD')[1])
	cProdAte := PadR(cProdAte,tamsx3('D3_COD')[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Deleta registros jah existentes na SA8 para o periodo processado              			  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZFCIDelRec(cMes,cAno)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Zera campo D3_VLRVI para o periodo processado              			                      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	ZFCIZeraD3(cMes,cAno)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Processa todas as entradas de materia prima para o periodo correspondente				  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZFciMedEnt(cMes,cAno,PadR('',tamsx3('D3_COD')[1]),PadR('Z',tamsx3('D3_COD')[1]),'Z')
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//|Processa as ordens de producao do periodo de acordo com o range de produtso informado      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZFciMedPr(cMes,cAno,cProdDe,cProdAte)

	aProc := {}

	If lErro
		ZFCIGravaLog(cTexto)
	EndIf

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³FCIMediaP ³ Autor ³ Robson Sales           ³ Data ³03.09.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao responsavel pelo calculo da media ponderada do perc. ³±±
±±³          ³ de componentes importados de um produto (FCI).              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Filial para pesquisa                                ³±±
±±³          ³ ExpC2 = Codigo do produto acabado                           ³±±
±±³          ³ ExpD1 = Data inicial do periodo da pesquisa                 ³±±
±±³          ³ ExpD2 = Data final do periodo da pesquisa                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ZFCIMediaP(cFil,cProduto,dDtIni,dDtFim)

	Local aArea  	:= GetArea()
	Local cAlias 	:= GetNextAlias()
	Local cPeriodo	:= ""
	Local cQry		:= ""
	Local nRet		:= 0
                       
	cPeriodo := ZFciUltProd(cFil,cProduto,dDtIni,dDtFim)
                                                             
	If cPeriodo != "000000"
		cQry := "SELECT SUM(D3_QUANT*D3_PERIMP)/SUM(D3_QUANT) AS MEDIA"
		cQry += " FROM "+RetSqlName("SD3")
		cQry += " WHERE D3_FILIAL = '"+xFilial("SD3",cFil)+"'"
		cQry += " AND D3_COD = '"+cProduto+"'"
		cQry += " AND SUBSTRING(D3_EMISSAO,1,6) = '"+Substr(cPeriodo,3)+Substr(cPeriodo,1,2)+"'"
		cQry += " AND D3_ESTORNO <> 'S' "
		cQry += " AND D3_CF IN ('DE4','DE7','PR0') "
		cQry += " AND D_E_L_E_T_ = ''"
		cQry := ChangeQuery(cQry)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)
		nRet := (cAlias)->MEDIA
		(cAlias)->(dbCloseArea())
	EndIf
	RestArea(aArea)
	cQryZ1 +=  cQuery + PULALINHA
Return nRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±                             
±±³Fun‡ao    ³ZFCIDelRec ³ Autor ³ Anieli Rodrigues       ³ Data ³28.09.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao responsavel pela delecao dos registros gerados na SA8³±±
±±³          ³ caso a apuracao ja tenha sido realizada anteriormente       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: cMes     - Mes a processar                           ³±±
±±³          ³ ExpC2: cAno     - Ano a processar                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ZFCIDelRec(cMes,cAno)

	Local aArea  	:= GetArea()
	Local aAreaSA8 	:= SA8->(GetArea())

	SA8->(DbSetOrder(2))
	If SA8->(MsSeek(xFilial("SA8")+cMes+cAno))
		While SA8->A8_FILIAL == xFilial("SA8") .And. SA8->A8_PERIOD == cMes+cAno
			RecLock('SA8',.F.)
			SA8->(DbDelete())
			SA8->(MsUnLock())
			SA8->(DbSkip())
		EndDo
	EndIf

	RestArea(aArea)
	RestArea(aAreaSA8)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ZFCIZeraD3 ³ Autor ³ Anieli Rodrigues       ³ Data ³28.09.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao responsavel pela delecao dos valores registrados na  ³±±
±±³          ³ SD3 caso a apuracao ja tenha sido realizada anteriormente   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: cMes     - Mes a processar                           ³±±
±±³          ³ ExpC2: cAno     - Ano a processar                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ZFCIZeraD3(cMes,cAno)

	Local aArea  	:= GetArea()
	Local aAreaSD3 	:= SD3->(GetArea())
	Local cQuery    := ""

	cQuery := "UPDATE "
	cQuery += RetSqlName("SD3")+" "
	cQuery += "SET D3_VLRVI = 0 "
	cQuery += "WHERE D3_FILIAL='"+xFilial("SD3")+"' AND "
	cQuery += "D_E_L_E_T_= ' ' AND "
	cQuery += "D3_ESTORNO <> 'S' AND "
	cQuery += "D3_CF IN ('PR0','PR1') AND SUBSTRING (D3_EMISSAO,1,6) = '"+cAno+cMes+"'""

	cQryZ1 +=  cQuery + PULALINHA

	TcSqlExec(cQuery)

	RestArea(aArea)
	RestArea(aAreaSD3)

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ZFciUltProd³ Autor ³ Anieli Rodrigues       ³ Data ³23.10.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao responsavel por obter o ultimo período para o qual   ³±±
±±³          ³ houve movimentacao de entrada do produto (producao,         ³±±
±±³          ³ transferencia ou desmontagem.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Filial para pesquisa                                ³±±
±±³          ³ ExpC2 = Codigo do produto acabado                           ³±±
±±³          ³ ExpD1 = Data inicial do periodo da pesquisa                 ³±±
±±³          ³ ExpD2 = Data final do periodo da pesquisa                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ZFciUltProd(cFil,cProduto,dDtIni,dDtFim)

	Local aAreaSD3	:= SD3->(GetArea())
	Local cAlias 	:= ""
	Local cDbType	:= TCGetDB()
	Local cFuncNull	:= ""
	Local cQuery 	:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Nome da funcao do banco de dados que substitui NULL por 0³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
	Case cDbType $ "DB2/POSTGRES"
		cFuncNull	:= "COALESCE"
	Case "ORACLE" $ cDbType
		cFuncNull	:= "NVL"
	Otherwise
		cFuncNull	:= "ISNULL"
	EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua query para retornar o periodo no qual houve a ultima entrada de producacao, transferencia ou desmontagem|									  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cAlias := GetNextAlias()
	cQuery	:= "SELECT " + cFuncNull + " (SUBSTRING(MAX(SD3.D3_EMISSAO),1,6),'000000') AS PERIODO"
	cQuery += "FROM "+RetSqlName("SD3")+" SD3 "
	cQuery += " WHERE SD3.D3_FILIAL = '"+xFilial('SD3')+"'"
	cQuery += " AND SD3.D3_COD = '"+cProduto+"'"
	cQuery += " AND SD3.D3_EMISSAO <= '"+dtos(dDtFim)+"'"
	cQuery += " AND D3_ESTORNO <> 'S' "
	cQuery += " AND D3_CF IN ('DE4','DE7','PR0') "
	cQuery += " AND D_E_L_E_T_ = ''"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	cQryZ1 +=  cQuery + PULALINHA

	cMes := Substr((cAlias)->(PERIODO),5,2)
	cAno := Substr((cAlias)->(PERIODO),1,4)

	(cAlias)->(DbCloseArea())

	RestArea(aAreaSD3)

Return cMes+cAno
                     

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ZFciMedPer ³ Autor ³ Anieli Rodrigues       ³ Data ³23.10.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao responsavel por calcular a media do VI para o produto³±±
±±³          ³ produzido no periodo.								       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto acabado                           ³±±
±±³          ³ ExpC2 = Mes para calculo da media 			               ³±±
±±³          ³ ExpC3 = Ano para calculo da media			               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ZFciMedPer(cProduto,cMes,cAno)

	Local aAreaSD3 	:= SD3->(GetArea())
	Local aAreaSA8	:= SA8->(GetArea())
	Local cAlias   	:= ""
	Local cOp		:= ""
	Local lAchou	:= .F.
	Local lRecursiv := .F.
	Local nQuantTot	:= 0
	Local nVi 		:= 0
	Local nViTotal	:= 0

	cAlias := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿      
//³ Efetua query para obter todas as ordens de producao do periodo para o produto |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := "SELECT SUM(D3_QUANT) AS QUANTIDADE, D3_OP,D3_COD "
	cQuery += "FROM "+RetSqlName("SD3")+" SD3 "
	cQuery += "WHERE SD3.D3_FILIAL = '"+xFilial('SD3')+"' AND SD3.D3_COD = '"+cProduto+"' "
	cQuery += "AND SD3.D_E_L_E_T_ = '' AND SD3.D3_ESTORNO = '' "
	cQuery += "AND SD3.D3_OP <> '' AND SD3.D3_CF IN ('PR0','PR1') AND SUBSTRING (SD3.D3_EMISSAO,1,6) = '"+cAno+cMes+"'"
	cQuery += "GROUP BY D3_OP,D3_COD ORDER BY SD3.D3_COD"

	cQryZ1 +=  cQuery + PULALINHA

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	While !(cAlias)->(Eof())
		cOp := (cAlias)->D3_OP
		cProduto := (cAlias)->D3_COD
		lRecursiv := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o VI deste produto ja foi calculado por outra chamada             			  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SA8->(DbSetOrder(1))
		lAchou := SA8->(MsSeek(xFilial('SA8')+cProduto+cMes+cAno))
	
		If !lAchou .Or. (lAchou .And. SA8->A8_PROCOM = "C")
		                                                
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adiciona produto pai no array aProc (controle de recursividade na estrutura)				  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If Ascan(aProc,{|x| x[1] == cProduto})>0
				lErro := .T.
				cTexto += "Ordem de Producao" + aProc[Len(aProc)][2] + "Produto" + aProc[Len(aProc)][1] + "Periodo" +cMes+cAno+PULALINHA //"Ordem de Producao: - Produto - Periodo:
				lRecursiv := .T.
			Else
				AADD(aProc,{cProduto,cOP})
			EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Obtem o VI atraves da composicao dos VIs dos produtos requisitados para a OP. 			  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lRecursiv
				nVi 		:= ZFciExplReq(cOp,cMes,cAno,cProduto)
			EndIf
			nViTotal 	+= nVi
			nVi    		:= nVi/(cAlias)->QUANTIDADE
			nQuantTot 	+= (cAlias)->QUANTIDADE
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o VI no registro de producao da SD3.									 			  |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea('SD3')
			SD3->(DbSetOrder(1))
			If SD3->(MsSeek(xFilial('SD3')+cOp))
				While SD3->D3_FILIAL = xFilial('SD3') .And. SD3->D3_OP = cOP
					If SD3->D3_CF == 'PR0' .And. SD3->D3_ESTORNO != "S"
						RecLock('SD3',.F.)
						Replace D3_VLRVI with nVi*D3_QUANT
						SD3->(MsUnlock())
					EndIf
					SD3->(DbSkip())
				End
			EndIf
			(cAlias)->(DbSkip())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ao processar todas as Ops, registra o VI do produto acabado na tabela SA8   |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (cAlias)->(Eof())
				DbSelectArea('SA8')
				SA8->(DbSetOrder(1))
				If !MsSeek(xFilial('SA8')+cProduto+cMes+cAno)
					RecLock('SA8',.T.)
					Replace A8_FILIAL 	With xFilial('SA8'),;
						A8_COD 		With cProduto,;
						A8_PERIOD	With cMes+cAno,;
						A8_VLRVI 	With nViTotal/nQuantTot,;
						A8_PROCOM	With "P"
					SA8->(MsUnlock())
				Else
					RecLock('SA8',.F.)
					Replace   A8_VLRVI 	With nViTotal/nQuantTot,;
						A8_PROCOM	With "P"
					SA8->(MsUnlock())
				EndIf
				nViTotal := 0
				nQuantTot:= 0
			EndIf
		Else
			(cAlias)->(DbSkip())
		EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|Retira produto pai no array aProc (controle de recursividade na estrutura)				  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		ASize(aProc,len(aProc)-1)
	End

	(cAlias)->(DbCloseArea())

	RestArea(aAreaSA8)
	RestArea(aAreaSD3)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ZFCIGravaLog³ Autor ³Anieli Rodrigues      ³ Data ³10/12/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao utilizada para gravacao do Log                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FCIXFUN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ZFCIGravaLog(cTexto)
	Local cFile  := ''

	cFile := 'RECFCI'+Right(CriaTrab(, .F.), 3)+'.LOG'
	lRet := MemoWrite(cFile, cTexto)
	If lRet
		Aviso("", cTexto+PULALINHA+""+cFile+"aa", {'Ok'},3)
	Else
		Aviso("", cTexto+PULALINHA+""+cFile+"aa", {'Ok'},3)
	EndIf

Return Nil
