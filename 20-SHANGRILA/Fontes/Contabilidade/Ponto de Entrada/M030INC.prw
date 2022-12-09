#INCLUDE "rwmake.ch"

/*
* Funcao		:	M030INC
* Autor			:	João Zabotto
* Data			: 	07/02/2014
* Descricao		:	Ponto de entrada responsável por incluir a item contábil, ao efetuar o cadastro do cliente.
* Retorno		: 	Logico
*/
User Function M030Inc
Local aArea    := GetArea()

If Type('PARAMIXB') <> 'U'
	If PARAMIXB==0
		Alert("Por favor, adicione um contato")
		FtContato( Alias(),Recno(), 4)
	EndIf
EndIf


GRVCTHCLI()

RestArea(aArea)
Return

/*
* Funcao		:
* Autor			:	João Zabotto
* Data			: 	09/01/2015
* Descricao		:
* Retorno		:
*/
Static Function GRVCTHCLI()
Local aArea    := GetArea()
Local aDadosAuto:= {}
Local aSX6		:= {}
Local cCliente := ""
Local cItem     := ""
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

aAdd( aSX6, { ;
'  '																	, ; //X6_FIL
'ZZ_ITESCLI'															, ; //X6_VAR
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
'C'																		, ; //X6_CONTEUD
'C'																		, ; //X6_CONTSPA
'C'																		, ; //X6_CONTENG
'U'																		, ; //X6_PROPRI
''																		} ) //X6_PYME

cItem     := AllTrim(SuperGetMv("ZZ_ITESCLI",.F.,"C"))

cCliente := cItem + SA1->A1_COD + SA1->A1_LOJA


CTH->(DbSetOrder(1))
If !CTH->(DbSeek(xFilial('CTH') + cCliente ))
	aDadosAuto:= {	{'CTH_CLVL'          , cCliente	, Nil},;
	{'CTH_CLASSE'    , "2"			         , Nil},;
	{'CTH_NORMAL'    , "0"			         , Nil},;
	{'CTH_DESC01'    , ALLTRIM(SA1->A1_NOME) , Nil},;
	{'CTH_BLOQ'  , "2"		              	 , Nil},;
	{'CTH_DTEXIS' , STOD('19800101')         , Nil},;
	{'CTH_ITSUP'  , cItem			         , Nil}}
	
	MSExecAuto({|x, y| CTBA060(x, y)},aDadosAuto, 3)
	
	If lMsErroAuto
		MostraErro()
	EndIf
EndIf
RestArea(aArea)
Return
 
