#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ                                  DBM SYSTEM S/C/ LTDA                                 บฑฑ
ฑฑฬออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบPrograma    ณRFINA01 ณInterface com Contas a Pagar - Arquivo Texto de pagamento a      บฑฑ
ฑฑบ            ณ        ณfuncionแrios                                                     บฑฑ
ฑฑฬออออออออออออุออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบProjeto/PL  ณ                                                                          บฑฑ
ฑฑฬออออออออออออุออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSolicitante ณ05.03.08ณVanderleia                                                       บฑฑ
ฑฑฬออออออออออออุออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAutor       ณ06.03.08ณAlmir Bandina                                                    บฑฑ
ฑฑฬออออออออออออุออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetros  ณNil                                                                       บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno     ณNil.                                                                      บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObserva็๕es ณ                                                                          บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAltera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da Altera็ใo                            บฑฑ
ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function RFINA01()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define as variแveis da rotina                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aAreaAtu		:= GetArea()
Local aSays     	:= {}
Local aButtons  	:= {}
Local nOpca     	:= 0
Local cPerg			:= PadR( "FINA01", If( AllTrim( cVersao ) == "P10", 10, 6 ) )

Private cCadastro  	:= OemToAnsi( "Interface Tํtulos a Pagar - Contabilidade" )
Private cArq		:= ""
Private cNomArq		:= ""
Private lEnd		:= .F.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface inicial com o usuแrio                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aSays, OemToAnsi( "Este programa tem como objetivo efetuar a importa็ใo dos tํtulos a pagar"	))
aAdd( aSays, OemToAnsi( "de funcionแrios, atrav้s de arquivo do tipo texto e com base em lay-out"	))
aAdd( aSays, OemToAnsi( " pr้-definido fornecido pelo usuแrio."				 						))
aAdd( aSays, OemToAnsi( ""																			))
aAdd( aSays, OemToAnsi( "Clique no botใo parโmetros para selecionar o arquivo texto de interface."	))
aAdd( aButtons, { 5,	.T.	,	{ |o| ( CallPerg( cPerg ), o:oWnd:Refresh() )	} } )
aAdd( aButtons, { 14,	.T.	,	{ |o| ( AbreArq(), o:oWnd:Refresh() )			} } )
aAdd( aButtons, { 1,	.T.	,	{ |o| ( ImpArq( cPerg ),o:oWnd:End() ) 		} } )
aAdd( aButtons, { 2,	.T.	,	{ |o| o:oWnd:End()								} } )
FormBatch( cCadastro, aSays, aButtons )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura as แreas originais dos arquivos                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea(aAreaAtu)

Return(Nil)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ                                  DBM SYSTEM S/C/ LTDA                                 บฑฑ
ฑฑฬออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบPrograma    ณCallPergณCria o grupo de perguntas se nใo existir                         บฑฑ
ฑฑบ            ณ        ณ                                                                 บฑฑ
ฑฑฬออออออออออออุออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetros  ณExpC1 = Alias do grupo de perguntas                                       บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno     ณNil.                                                                      บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObserva็๕es ณ                                                                          บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAltera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da Altera็ใo                            บฑฑ
ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CallPerg( cPerg )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define as variแveis da rotina                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )
Local aTamSX3	:= {}
Local aHelp		:= {}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                                                    ณ
//ณ mv_par01        // Natureza Adiantamento                                                ณ
//ณ mv_par02 	    // Natureza Folha                                                       ณ
//ณ mv_par03        // Natureza 13o.                                                        ณ
//ณ mv_par04 	    // Natureza Pr๓ Labore                                                  ณ
//ณ mv_par05        // C.Contabil Adiantamento                                              ณ
//ณ mv_par06 	    // C.Contabil Folha                                                     ณ
//ณ mv_par07        // C.Contabil 13o.                                                      ณ
//ณ mv_par08 	    // C.Contabil Pro Labore                                                ณ
//ณ mv_par09 	    // Tipo Adiantamento                                                    ณ
//ณ mv_par10 	    // Tipo Folha                                                           ณ
//ณ mv_par11 	    // Tipo 13o.                                                            ณ
//ณ mv_par12 	    // Tipo Pr๓ Labore                                                      ณ
//ณ mv_par13 	    // Data de Vencimento                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define os tํtulos e Help das perguntas                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//				"XXXXXXXXXXWWWWWWWWWWXXXXXXXXXX",	"", "",		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
aAdd(aHelp,{	"Natureza Adiantamento",			"",	"", {	"Informe a natureza a ser utilizada na   ",	"cria็ใo de tํtulos de adiantamento de   ",	"salแrio.                                " }, {""}, {""} } )
aAdd(aHelp,{	"Natureza Folha",					"",	"", {	"Informe a natureza a ser utilizada na   ",	"cria็ใo de tํtulos de pagamento de      ",	"salแrio.                                " }, {""}, {""} } )
aAdd(aHelp,{	"Natureza 13o.Salario",				"",	"", {	"Informe a natureza a ser utilizada na   ",	"cria็ใo de tํtulos de 13o. salแrio.     ",	"                                        " }, {""}, {""} } )
aAdd(aHelp,{	"Natureza Pro-Labore",				"",	"", {	"Informe a natureza a ser utilizada na   ",	"cria็ใo de tํtulos de pro-labore.       ",	"                                        " }, {""}, {""} } )
aAdd(aHelp,{	"C.Contabil Adiantamento",			"",	"", {	"Informe a conta contแbil a ser utilizada",	"na cria็ใo de tํtulos de adiantamento de",	"adiantamento de salแrio.                " }, {""}, {""} } )
aAdd(aHelp,{	"C.Contabil Folha",					"",	"", {	"Informe a conta contแbil a ser utilizada",	"na cria็ใo de tํtulos de pagamento de   ",	"salแrio.                                " }, {""}, {""} } )
aAdd(aHelp,{	"C.Contabil 13o.Salario",			"",	"", {	"Informe a conta contแbil a ser utilizada",	"na cria็ใo de tํtulos de 13o. salแrio.  ",	"                                        " }, {""}, {""} } )
aAdd(aHelp,{	"C.Contabil Pro-Labore",			"",	"", {	"Informe a conta contแbil a ser utilizada",	"na cria็ใo de tํtulos de pro-labore.    ",	"                                        " }, {""}, {""} } )
aAdd(aHelp,{	"Tipo Adiantamento",				"",	"", {	"Informe o tipo de tํtulos a ser         ",	"utilizado na cria็ใo de tํtulos de      ",	"adiantamento de salแrio.                " }, {""}, {""} } )
aAdd(aHelp,{	"Tipo Folha",						"",	"", {	"Informe o tipo de tํtulo a ser          ",	"utilizado na cria็ใo de tํtulos de      ",	"pagamento de salแrio.                   " }, {""}, {""} } )
aAdd(aHelp,{	"Tipo 13o. Salario",				"",	"", {	"Informe o tipo de tํtulo a ser          ",	"utilizado na cria็ใo de tํtulos de      ",	"13o. salแrio.                           " }, {""}, {""} } )
aAdd(aHelp,{	"Tipo Pro-Labore",					"",	"", {	"Informe o tipo de tํtulo a ser          ",	"utilizado na cria็ใo de tํtulos de      ",	"pro-labore.                             " }, {""}, {""} } )
aAdd(aHelp,{	"Data de Vencimento",				"",	"", {	"Informe a data de vencimento do tํtulo. ",	"                                        ",	"                                        " }, {""}, {""} } )
aAdd(aHelp,{	"Tipo de Importacao",				"",	"", {	"Informe o tipo de importa็ใo esta sendo ",	"executado.                              ",	"                                        " }, {""}, {""} } )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Grava as perguntas no arquivo SX1                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aTamSX3	:= TAMSX3( "ED_CODIGO" )
//		cGrupo	cOrde	cDesPor			cDesSpa			cDesEng			cVar		cTipo		cTamanho	cDecimal	nPreSel	cGSC	cValid	cF3			cGrpSXG	cPyme	cVar01		cDef1Por		cDef1Spa	cDef1Eng	cCnt01	  					cDef2Por	cDef2Spa	cDef2Eng	cDef3Por	cDef3Spa	cDef3Eng	cDef4Por		cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor		aHelpEng		aHelpSpa		cHelp)
PutSx1(	cPerg,	"01",	aHelp[01,1],	aHelp[01,2],	aHelp[01,3],	"mv_ch1",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"SED",		"",		"N",	"mv_par01",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[01,4],	aHelp[01,5],	aHelp[01,6],	"" )
PutSx1(	cPerg,	"02",	aHelp[02,1],	aHelp[02,2],	aHelp[02,3],	"mv_ch2",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"SED",		"",		"N",	"mv_par02",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[02,4],	aHelp[02,5],	aHelp[02,6],	"" )
PutSx1(	cPerg,	"03",	aHelp[03,1],	aHelp[03,2],	aHelp[03,3],	"mv_ch3",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"SED",		"",		"N",	"mv_par03",	"",				"",			"",			"", 						"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[03,4],	aHelp[03,5],	aHelp[03,6],	"" )
PutSx1(	cPerg,	"04",	aHelp[04,1],	aHelp[04,2],	aHelp[04,3],	"mv_ch4",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"SED",		"",		"N",	"mv_par04",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[04,4],	aHelp[04,5],	aHelp[04,6],	"" )
aTamSX3	:= TAMSX3( "CT1_CONTA" )
PutSx1(	cPerg,	"05",	aHelp[05,1],	aHelp[05,2],	aHelp[05,3],	"mv_ch5",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"CT1",		"",		"N",	"mv_par05",	"",				"",			"",			"",		 					"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[05,4],	aHelp[05,5],	aHelp[05,6],	"" )
PutSx1(	cPerg,	"06",	aHelp[07,1],	aHelp[07,2],	aHelp[07,3],	"mv_ch7",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"CT1",		"",		"N",	"mv_par07",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[07,4],	aHelp[07,5],	aHelp[07,6],	"" )
PutSx1(	cPerg,	"07",	aHelp[06,1],	aHelp[06,2],	aHelp[06,3],	"mv_ch6",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"CT1",		"",		"N",	"mv_par06",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[06,4],	aHelp[06,5],	aHelp[06,6],	"" )
PutSx1(	cPerg,	"08",	aHelp[08,1],	aHelp[08,2],	aHelp[08,3],	"mv_ch8",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"CT1",		"",		"N",	"mv_par08",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[08,4],	aHelp[08,5],	aHelp[08,6],	"" )
aTamSX3	:= TAMSX3( "E1_TIPO" )
PutSx1(	cPerg,	"09",	aHelp[09,1],	aHelp[09,2],	aHelp[09,3],	"mv_ch9",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"05",		"",		"N",	"mv_par09",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[09,4],	aHelp[09,5],	aHelp[09,6],	"" )
PutSx1(	cPerg,	"10",	aHelp[10,1],	aHelp[12,2],	aHelp[10,3],	"mv_chA",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"05",		"",		"N",	"mv_par10",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[10,4],	aHelp[10,5],	aHelp[10,6],	"" )
PutSx1(	cPerg,	"11",	aHelp[11,1],	aHelp[11,2],	aHelp[11,3],	"mv_chB",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"05",		"",		"N",	"mv_par11",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[11,4],	aHelp[11,5],	aHelp[11,6],	"" )
PutSx1(	cPerg,	"12",	aHelp[12,1],	aHelp[12,2],	aHelp[12,3],	"mv_chC",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"05",		"",		"N",	"mv_par12",	"",				"",			"",			"",							"",			"",			"",			"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[12,4],	aHelp[12,5],	aHelp[12,6],	"" )
aTamSX3	:= TAMSX3( "E1_VENCTO" )
PutSx1(	cPerg,	"13",	aHelp[13,1],	aHelp[13,2],	aHelp[13,3],	"mv_chD",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"G",	"",		"",			"",		"N",	"mv_par09",	"",				"",			"",			"",							"",			"",			"",	  		"",				"",			"",			"",				"",			"",			"",			"",			"",			aHelp[13,4],	aHelp[13,5],	aHelp[13,6],	"" )
PutSx1(	cPerg,	"14",	aHelp[14,1],	aHelp[14,2],	aHelp[14,3],	"mv_chE",	aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,		"C",	"",		"",			"",		"N",	"mv_par09",	"Adiantamento",	"",			"",			"",							"Folha",	"",			"",	  		"13o.Salario",	"",			"",			"Pro-Lanore",	"",			"",			"",			"",			"",			aHelp[13,4],	aHelp[13,5],	aHelp[13,6],	"" )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Interface com o usuแrio                                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Pergunte( cPerg, .T. )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Salva as แreas originais                                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return( Nil )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ                                  DBM SYSTEM S/C/ LTDA                                 บฑฑ
ฑฑฬออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบPrograma    ณAbreArq ณFaz a interface com o usuแrio para sele็ใo do arquivo            บฑฑ
ฑฑบ            ณ        ณ                                                                 บฑฑ
ฑฑฬออออออออออออุออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetros  ณNil                                                                       บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno     ณNil.                                                                      บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObserva็๕es ณ                                                                          บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAltera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da Altera็ใo                            บฑฑ
ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AbreArq()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define as variแveis da rotina                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cType		:=	"Arquivos TXT|*.TXT|Todos os Arquivos|*.*"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Interface com usuแrio                                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cArq := cGetFile(	cType,;
					OemToAnsi( "Selecione o arquivo de interface" ),;
					0,;
					"SERVIDOR\SYSTEM\INTERFACE\",;
					.T.,;
					GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ;
					)

Return( Nil )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ                                  DBM SYSTEM S/C/ LTDA                                 บฑฑ
ฑฑฬออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบPrograma    ณImpArq  ณPrepara o processo de importa็ใo                                 บฑฑ
ฑฑบ            ณ        ณ                                                                 บฑฑ
ฑฑฬออออออออออออุออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetros  ณNil                                                                       บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno     ณNil.                                                                      บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObserva็๕es ณ                                                                          บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAltera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da Altera็ใo                            บฑฑ
ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ImpArq( cPerg )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define as variแveis da rotina                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cQry		:= ""
Local lRet		:= .T.

Private lLog	:= .T.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Limpa espa็os em branco do arquivo                                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cArq	:= AllTrim( cArq )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida se o arquivo existe                                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet .And. Empty( cArq )
	Aviso(	cCadastro,;
			"O Arquivo para importa็ใo nใo foi selecionado !" + Chr(13) + Chr(10) +;
			"Rotina nใo poderแ ser executada.",;
   			{ "&Retorna" },2,;
   			"Arquivo: " + cArq )
   lRet	:= .F.
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida se o arquivo existe                                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet .And. !File( cArq )
	Aviso(	cCadastro,;
			"O Arquivo para importa็ใo selecionado nใo foi localizado !" + Chr(13) + Chr(10) +;
			"Rotina nใo poderแ ser executada.",;
   			{ "&Retorna" },2,;
   			"Arquivo: " + cArq )
   lRet	:= .F.
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se o arquivo esta correto prepara para processamento                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Carrega as perguntas                                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !( Pergunte( cPerg, .T. ) )
		lRet	:= .F.
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Obtem o nome do arquivo                                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cNomArq	:= SubStr( cArq, Rat( "\", cArq ) + 1, Len( cArq ) )
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Valida se a data de vencimento ้ igual ou posterior a data base                 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If mv_par13 < dDataBase
			Aviso(	cCadastro,;
					"A data de vencimento definida no parโmetro ้ menor que a data base do sistema." + Chr(13) + Chr(10) +;
					"Rotina nใo poderแ ser executada.",;
					{ "&Retorna" },2,;
					"Data Vencimento: " + DToC( mv_par13 ) )
			lRet	:= .F.
		Else
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Executa a chamada do processamento de im porta็ใo                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			Processa( { |lEnd| Importa( @lLog ) }, "Lendo arquivo texto" )
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Se nใo houve erro no processo fecha o processamento com mensagem                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If !lLog
				Aviso(	cCadastro,;
						"Processo de importa็ใo finalizado com sucesso.",;
						{ "&Continua" },,;
						"Final de Processamento" )
			Else
				lRet	:= .F.
			EndIf
		EndIf
	EndIf
EndIf

Return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ                                  DBM SYSTEM S/C/ LTDA                                 บฑฑ
ฑฑฬออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบPrograma    ณImporta ณEfetua a leitura e importa็ใo dos dados                          บฑฑ
ฑฑบ            ณ        ณ                                                                 บฑฑ
ฑฑฬออออออออออออุออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetros  ณExpL1 = Variแvel de controle de log                                       บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno     ณNil.                                                                      บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObserva็๕es ณ                                                                          บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAltera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da Altera็ใo                            บฑฑ
ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function Importa( lLog )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define as variแveis da rotina                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aTitulos	:= {}
Local lRet		:= .T.
Local lGrvOk	:= .T.
Local nHdl		:= 0
Local nLinha	:= 0
Local nValor	:= 0
Local cBuffer	:= ""
Local cNome		:= ""
Local cTitulo	:= ""
Local cTipo		:= ""
Local cNat		:= ""
Local cConta	:= ""
Local cHist		:= ""
Local cEOL		:= CHR(13)+CHR(10)
Local cArqLog	:= SubStr( cNomArq, 1, At( ".", cNomArq ) - 1 ) + ".LOG"
Local cArqTmp	:= ""
Local cLog		:= ""
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Grava inํcio do arquivo de log                                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cLog += "PROCESSAMENTO DO ARQUIVO " + cEOL
cLog += AllTrim( cNomArq )	+ cEOL
//GrvLog( cLog )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ ESTRUTURA DO ARQUIVO TEXTO FORNECIDO                                                    ณ
//ณ Ag๊ncia          - 001 a 004 - (9)  - C๓digo da ag๊ncia bancแria                        ณ
//ณ Conta            - 005 a 010 - (9)  - N๚mero da Conta Corrente                          ณ
//ณ Nome Funcionแrio - 011 a 050 - (A)  - Nome do Funcionแrio                               ณ
//ณ Valor do Tํtulo  - 051 a 060 - (9)2 - Valor do Tํtulo                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abre o arquivo texto                                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nHdl 	:= FT_FUSE(cArq)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Valida se conseguiu abrir o arquivo texto                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nHdl <> Nil .and. nHdl <= 0
	Aviso(	cCadastro,;
			"Nใo foi possํvel obter a abertura exclusiva do arquivo texto !",;
			{ "&Retorna" },,;
			"Arquivo: " + AllTrim( cArq ) )
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha o arquivo texto                                                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	FT_FUSE()
	lRet	:= .F.
Endif

If lRet
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define as variแveis fixas                                                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    If mv_par14 == 1
		cTitulo	:= "AD" + SubStr( DToS( mv_par13 ), 3, 4 )
		cNat	:= mv_par01
		cConta	:= mv_par05
		cTipo	:= mv_par09
		cHist	:= "ADIANTAMENTO SALARIO"
	ElseIf mv_par14 == 2
		cTitulo	:= "FO" + SubStr( DToS( mv_par13 ), 3, 4 )
		cNat	:= mv_par02
		cConta	:= mv_par06
		cTipo	:= mv_par10
		cHist	:= "PAGAMENTO SALARIO"
	ElseIf mv_par14 == 3
		cTitulo	:= "13" + SubStr( DToS( mv_par13 ), 3, 4 )
		cNat	:= mv_par03
		cConta	:= mv_par07
		cTipo	:= mv_par11
		cHist	:= "13o. SALARIO"
	ElseIf mv_par14 == 4
		cTitulo	:= "PL" + SubStr( DToS( mv_par13 ), 3, 4 )
		cNat	:= mv_par04
		cConta	:= mv_par08
		cTipo	:= mv_par12
		cHist	:= "PRO-LABORE"
	Else
		cTitulo	:= "DV" + SubStr( DToS( mv_par13 ), 3, 4 )
		cNat	:= PadL( "", TAMSX3( "ED_CODIGO" )[1] )
		cConta	:= PadL( "", TAMSX3( "CT1_CONTA" )[1] )
		cTipo	:= PadR( "NF", TAMSX3( "E2_TIPO" )[1] )
		cHist	:= "OUTROS PAGAMENTOS"
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se a natureza informada existe                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !( SED->( MsSeek( xFilial( "SED" ) + cNat ) ) )
		cLog += "Natureza: "
		cLog += AllTrim( cNat )
		cLog += " nใo localizada no cadastro."
		cLog += cEOL
		//GrvLog( cLog )
		lGrvOk	:= .F.
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se a natureza informada existe                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !( CT1->( MsSeek( xFilial( "CT1" ) + cConta ) ) )
		cLog += "Conta Contแbil: "
		cLog += AllTrim( cConta )
		cLog += " nใo localizada no cadastro."
		//GrvLog( cLog )
		lGrvOk	:= .F.
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se a natureza informada existe                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !( SX5->( MsSeek( xFilial( "SX5" ) + "05" + cTipo ) ) )
		cLog += "Tipo do Tํtulo: "
		cLog += AllTrim( cTipo )
		cLog += " nใo localizado no cadastro."
		cLog += cEOL
		//GrvLog( cLog )
		lGrvOk	:= .F.
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se nใo tem erro, processa o arquivo                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lGrvOk
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Define a quantidade de registros a processar                                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ProcRegua(FT_FLASTREC())
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Posiciona no inํcio do arquivo                                                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		FT_FGOTOP()
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Executa a leitura sequencial do arquivo texto                                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		While !FT_FEOF() .And. lRet
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Efetua a leitura da linha do arquivo                                        ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cBuffer := FT_FREADLN()
			nLinha	++
		    cNome	:= PadR( Substr( cBuffer, 11, 40 ), TAMSX3( "A2_NOME" )[1] )
		    nValor	:= Round( Val( SubStr( cBuffer, 51, 10 ) ) / 100, 2 )
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Movimenta a regua de processamento                                          ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			IncProc("Lendo linha " + AllTrim( Str( nLinha ) ) + " do arquivo." )
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Se valor igual a zero, nใo importa                                          ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If nValor <= 0
				cLog += "Linha: "
				cLog += Alltrim( Str( nLinha ) )
				cLog += " - Valor: "
				cLog += AllTrim( Transform(nValor, "@E 999,999,999.99") )
				cLog += " nใo ้ vแlido."
				cLog += cEOL
				//GrvLog( cLog )
				lGrvOk	:= .F.
				FT_FSKIP()
				Loop
			EndIf
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Pesquisa se o funcionแrio esta cadastrado como cliente                      ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		 	dbSelectArea( "SA2" )
		 	dbSetOrder( 2 )				// FILIAL + NOME + LOJA
		 	If !( MsSeek( xFilial( "SA2" ) + cNome, .F. ) )
				cLog += "Linha: "
				cLog += Alltrim( Str( nLinha ) )
				cLog += " - Cliente: "
				cLog += AllTrim( cNome )
				cLog += " nใo localizado no cadastro."
				cLog += cEOL
				//GrvLog( cLog )
				lGrvOk	:= .F.
				FT_FSKIP()
				Loop
			EndIf
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Valida se existe o centro de custo para o funcionแrio                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If Empty( SA2->A2_CCUSTO )
				cLog += "Linha: "
				cLog += Alltrim( Str( nLinha ) )
				cLog += " - Centro de Custo nใo informado para o fornecedor: "
				cLog += AllTrim( SA2->A2_COD ) + "/" + AllTrim( SA2->A2_LOJA ) +"."
				cLog += cEOL
				//GrvLog( cLog )
				lGrvOk	:= .F.
				FT_FSKIP()
				Loop
			EndIf
			If !( ExistCpo( "CTT", SA2->A2_CCUSTO, .F. ) )
				cLog += "Linha: "
				cLog += Alltrim( Str( nLinha ) )
				cLog += " - Centro de Custo: "
				cLog += AllTrim( SA2->A2_CCUSTO )
				cLog += "nใo localizado no cadastro."
				cLog += cEOL
				//GrvLog( cLog )
				lGrvOk	:= .F.
				FT_FSKIP()
				Loop
			EndIf
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Alimenta array com os tํtulos a serem processados                           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aAdd( aTitulos, {	{ "E2_FILIAL",	xFilial( "SE2" ),		Nil },;		// Filial
								{ "E2_PREFIXO",	"FOL",					Nil },;		// Prefixo
								{ "E2_NUM",		cTitulo,				Nil },;		// N๚mero do Tํtulo
								{ "E2_PARCELA",	"",						Nil },;		// Parcela
								{ "E2_TIPO",	cTipo,					Nil },;		// Tipo
								{ "E2_NATUREZ",	cNat,					Nil },;		// Natureza
								{ "E2_FORNECE",	SA2->A2_COD,			Nil },;		// Codigo Fornecedor
								{ "E2_LOJA",	SA2->A2_LOJA,			Nil },;		// Loja Fornecedor
								{ "E2_NOMFOR",	SA2->A2_NREDUZ,			Nil },;		// Nome Reduzido
								{ "E2_EMISSAO",	dDataBase,				Nil },;		// Data Emissใo
								{ "E2_VENCTO",	mv_par13,				Nil },;		// Data de Vencimento
								{ "E2_VENCREA",	DataValida( mv_par13 ),	Nil },;		// Data Vencimento Real
								{ "E2_VALOR",	nValor,					Nil },;		// Valor do Tํtulo
								{ "E2_ISS",		0,						Nil },;		// Valor do ISS
								{ "E2_PARCISS",	" ",					Nil },;		// Parcela do ISS
								{ "E2_IRRF",	0,						Nil },;		// Valor do IRRF
								{ "E2_PARCIR",	" ",					Nil },;		// Parcela do IRRF
								{ "E2_EMIS1",	dDataBase,				Nil },;		// Data de Emissใo Original
								{ "E2_HIST",	cHist,					Nil },;		// Hist๓rico
								{ "E2_SALDO",	nValor,					Nil },;		// Saldo do Tํtulo
								{ "E2_VENCORI",	mv_par13,				Nil },;		// Vencimento Original
								{ "E2_MOEDA",	1,						Nil },;		// Moeda
								{ "E2_VLCRUZ",	nValor,					Nil },;		// Valor Original
								{ "E2_FLUXO",	"S",					Nil },;		// Fluxo de Caixa
								{ "E2_ORIGEM",	"FINA050",				Nil },;		// Origem Lan็amento
								{ "E2_DESDOBR",	"N",					Nil },;		// Desdobramento de duplicatas
								{ "E2_INSS",	0,						Nil },;		// Valor do INSS
								{ "E2_PARCINS",	" ",					Nil },;		// Parcela do INSS
								{ "E2_MULTNAT", "2",					Nil },;		// Multiplas Naturezas
								{ "E2_DIRF",	"2",					Nil },;		// Controle da Dirf
								{ "E2_CODRET",	" ",					Nil },;		// C๓digo de Reten็ใo Dirf
								{ "E2_CONTAD",	cConta,					Nil },;		// Conta Contแbil
								{ "E2_CCD",		SA2->A2_CCUSTO,			Nil },;		// Centro de Custo
								{ "E2_LA",		"N",					Nil } ;		// Flag de Contabiliza็ใo
								} )
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Posiciona na proxima linha                                                  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			FT_FSKIP()
		EndDo
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha o arquivo texto                                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	FT_FUSE()
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Grava e mostra o arquivo de log                                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lGrvOk
	lLog	:= .T.
	lRet	:= .F.
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ inaliza o arquivo de log                                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//AutoGrLog(" ")
	//AutoGrLog("*** ERROS NO PROCESSAMENTO - ARQUIVO NรO FOI PROCESSADO ***")
	//AutoGrLog(" ")
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Copia para temporแrio o log do arquivo                                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//cArqTmp	:= NomeAutoLog()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Delata o arquivo de log                                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If File( cArqLog )
		FErase( cArqLog )
	EndIf
	nHdlLog	:= fCreate( cArqLog, 0 )

	If nHdlLog < 0
		Aviso( cCadastro,;
		"Nใo foi possํvel criar o arquivo de log.",;
		{ "&Retorna" },,;
		"Arquivo: " + cArqLog )
	Else
		fWrite( nHdlLog, cLog, Len( cLog ) )
		fClose( nHdlLog )
		Aviso(	cCadastro,;
				"Ocorreram diverg๊ncias no processo de importa็ใo." + Chr(13) + Chr(10) +;
				"Verificar arquivo de log no disret๓rio \SYSTEM\.",;
				{ "&Continua" },,;
				"Arquivo: " + cArqLog )
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Copia o arquivo temporแrio completo para o arquivo de log                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//__CopyFile( cArqTmp, cArqLog )
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Faz interface com usuแrio para perguntar se mosta ou nใo o log em tela              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//If Aviso(	cCadastro,;
	//			"Ocorreram diverg๊ncias na leitura do arquivo texto." + Chr(13) + Chr(10) +;
	//			"Deseja verificar as diverg๊ncias ?",;
   	//			{ "&Sim", "&Nใo" },2,;
	//   			"Diverg๊ncia" ) == 1
	//	MostraErro(, cArqLog )
	//EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processa a importa็ใo dos dados                                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Else
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processa a MsExecAuto                                                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Processa( { |lEnd| lGrvOk := GrvTit( aTitulos ) }, "Efetuando Grava็ใo dos Titulos", cCadastro )
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se nใo deu erro na MsExecAuto move o arquivo para diret๓rio de processados          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lGrvOk
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Monta o path de destino para arquivo processado                                 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cArqProc	:= AllTrim( GetSrvProfString( 'StartPath', '' ) )
		cArqProc	+= If( SubStr( cArqProc, Len( cArqProc ), 1 ) $ "\", "", "\") + "INTERFACE\" + cNomArq
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Copia o arquivo lido para o novo destino                                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		__CopyFile( cArq, cArqProc )
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Se a c๓pia foi bem sucedida deleta o arquivo no diret๓rio de recebidos          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !File( cArqProc )
			Aviso(	cCadastro,;
					"Nใo foi possํvel efetuar a c๓pia do arquivo para o diret๓rio de processados." + Chr(13) + Chr(10) +;
					"O arquivo permanecerแ no diret๓rio para novo processamento.",;
					{ "&Continua" },2,;
					"Arquivo: " + cArqProc )
		Else
			FErase( cArq )
		EndIf
	EndIf
Endif

Return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ                                  DBM SYSTEM S/C/ LTDA                                 บฑฑ
ฑฑฬออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบPrograma    ณGrvLog  ณFun็ใo de grava็ใo do log de processamento                       บฑฑ
ฑฑบ            ณ        ณ                                                                 บฑฑ
ฑฑฬออออออออออออุออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetros  ณExpC1 = Mensagem a ser gravada                                            บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno     ณNil.                                                                      บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObserva็๕es ณ                                                                          บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAltera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da Altera็ใo                            บฑฑ
ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GrvLog( cMsg )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define as variแveis utilizadas na rotina                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
lLog	:= .T.
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Grava a mensagem de log                                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AutoGrLog( cMsg )

Return(Nil)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ                                  DBM SYSTEM S/C/ LTDA                                 บฑฑ
ฑฑฬออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบPrograma    ณGrvTit  ณFun็ใo de grava็ใo dos pedidos de venda                          บฑฑ
ฑฑบ            ณ        ณ                                                                 บฑฑ
ฑฑฬออออออออออออุออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetros  ณExpA1 = array com os titulos a serem gravados                             บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno     ณNil.                                                                      บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObserva็๕es ณ                                                                          บฑฑ
ฑฑฬออออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAltera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da Altera็ใo                            บฑฑ
ฑฑศออออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GrvTit( aTitulos )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define as variแveis utilizadas na rotina                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lGravaOk 	:= .T.
Local nLoop1	:= 0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Seta a regua de processamento                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ProcRegua( Len( aTitulos ) )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicia o controle de transacao                                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Begin Transaction
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Varre todo o array de tํtulos                                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nLoop1	:= 1 To Len( aTitulos )
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Movimenta a regua de processamento                                                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IncProc( "Processando Fornecedor: " + aTitulos[nLoop1, 09, 02] )
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Inicializa variแveis da rotina automแtica                                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lMsErroAuto	:= .F.
		lMsHelpAuto	:= .F.
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Executa rotina automแtica                                                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		MsExecAuto( { |x,y,z| FINA050( x, y, z ) }, aTitulos[nLoop1], 3 )
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Se teve erro avisa usuแrio                                                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lMsErroAuto
			Aviso(	cCadastro,;
					"Erro na inlcusใo do tํtulo." + Chr(13) + Chr(10) +;
					"Verifique o arquivo de log da rotina de inclusใo de tํtulo.",;
					{ "&Continua" },2,;
					"Erro na Rotina Automแtica" )
			lGravaOk	:= .F.
		EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Inicializa variแveis da rotina automแtica                                           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		lMsErroAuto	:= .F.
		lMsHelpAuto	:= .F.
	Next nLoop1
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza o controle de transa็ใo                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
End Transaction

Return(lGravaOk)
