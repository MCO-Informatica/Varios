#INCLUDE "rwmake.ch"

/*
* Funcao		:	M030INC
* Autor			:	João Zabotto
* Data			: 	07/02/2014
* Descricao		:	Ponto de entrada responsável por incluir a item contábil, ao efetuar o cadastro do fornecedor.
* Retorno		: 	Logico
*/	
User Function M020Inc
	Local aArea    := GetArea()

	GRVCTHFOR()

	RestArea(aArea)
Return

/*
* Funcao		:	
* Autor			:	João Zabotto
* Data			: 	09/01/2015
* Descricao		:	
* Retorno		: 	
*/
Static Function GRVCTHFOR()
	Local aArea    := GetArea()
	Local cFornecedor := ""
	Local cItem     := ""
	Local aDadosAuto:= {}
	local aSX6		:= {}
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	
	aAdd( aSX6, { ;
		'  '																	, ; //X6_FIL
	'ZZ_ITESFOR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Identificacao do codigo para o fornecedor'								, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'F'											, ; //X6_CONTEUD
	'F'											, ; //X6_CONTSPA
	'F'											, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		} ) //X6_PYME
			
	cItem     := AllTrim(SuperGetMv("ZZ_ITESFOR",.F.,"F"))
	
	cFornecedor := cItem + SA2->A2_COD + SA2->A2_LOJA
	
	CTH->(DbSetOrder(1))
	If !CTH->(DbSeek(xFilial('CTH') + cFornecedor))
		aDadosAuto:= {	{'CTH_CLVL'          , cFornecedor	, Nil},;
			{'CTH_CLASSE'    , "2"			         , Nil},;
			{'CTH_NORMAL'    , "0"			         , Nil},;
			{'CTH_DESC01'    , ALLTRIM(SA2->A2_NOME) , Nil},;
			{'CTH_BLOQ'  , "2"		              	 , Nil},;
			{'CTH_DTEXIS' , STOD('19800101')   	     , Nil},;
			{'CTH_ITSUP'  , cItem			         , Nil}}

		MSExecAuto({|x, y| CTBA060(x, y)},aDadosAuto, 3)

		If lMsErroAuto
			MostraErro()
		EndIf
	EndIf
	
	RestArea(aArea)
Return