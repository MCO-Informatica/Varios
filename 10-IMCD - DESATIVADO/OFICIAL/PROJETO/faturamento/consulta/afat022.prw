#INCLUDE "PROTHEUS.CH"   
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE ITENSSC6 300

/* **************************************************************************
***Programa  *AFAT022   * Autor * Eneovaldo Roveri Jr.  * Data *20/11/2009***
*****************************************************************************
***Locacao   * Fabr.Tradicional *Contato *                                ***
*****************************************************************************
***Descricao * Botão para consulta de dados de validação do pedido        ***
*****************************************************************************
***Parametros*                                                            ***
*****************************************************************************
***Retorno   *                                                            ***
*****************************************************************************
***Aplicacao *                                                            ***
*****************************************************************************
***Uso       *                                                            ***
*****************************************************************************
***Analista Resp.*  Data  * Bops * Manutencao Efetuada                    ***
*****************************************************************************
***              *  /  /  *      *                                        ***
***              *  /  /  *      *                                        ***
************************************************************************** */


User Function A440BT01()
	Local aArea:= GetArea()
	Local _nTotPed := 0
	Local _nReg5   := SC5->( recno() )
	Local _nReg6   := SC6->( recno() )

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "A440BT01" , __cUserID )

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlg1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10","oSay11")
	SetPrvt("oSay13","oSay14","oSay15","oSay16","oSay17","oSay18","oSay19","oSay20","oSay21","oSay22","oSay23")
	SetPrvt("oSay25","oSay26","oSay27","oSay28","oSay29","oSay30","oSay31","oSay32","oSay33","oSay34","oSay35")
	SetPrvt("oSay37","oSay38","oSay39","oSay40","oSay41","oSay42","oSay43","oSay44","oSay45","oSay46","oSay47")
	SetPrvt("oSay49","oSay50","oSay51","oSay52","oSay53","oSay54","oSay55","oSay56","oSay57","oSay58","oSay59")
	SetPrvt("oSay61","oSay62","oSay63","oSay64","oSay65","oSay66","oSay67","oSay68","oSay69","oSay70","oSay71")
	SetPrvt("oSay73","oSay74","oSay75","oSay76","oSay77","oSay78","oSay79","oSay80","oSay81","oSay82","oSay83")
	SetPrvt("oSay85","oSay86","oSay87","oSay88","oSay89","oSay90","oSay91","oSay92","oSay93","oSay94","oSay95")
	SetPrvt("oSay97","oSay98","oSay99","oSay100","oSay101","oSay102","oSay103","oSay104","oSay105","oSay106")
	SetPrvt("oSay108","oSay109","oSay112","oSay113","oSBtnCanc")

	//U_TPdLicCT( @_nTotPed,,,,,,,,.F. )

	SE4->( dbSeek( xfilial("SE4") + SC5->C5_CONDPAG ) )
	SA4->( dbSeek( xFilial( "SA4" ) + SC5->C5_TRANSP ) )
	SA1->( dbSeek( xFilial( "SA1" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )
	SA2->( dbSeek( xFilial( "SA2" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	if SC5->C5_TIPO == "B" .or. SC5->C5_TIPO == "D"
		oDlg1      := MSDialog():New( 030,089,600,1284,"Consulta Licenças de Fornecedor e Transportadora e Limite da Condição de Pagamento do Pedido "+SC5->C5_NUM,,,.F.,,,,,,.T.,,,.T. )
	else
		oDlg1      := MSDialog():New( 030,089,600,1284,"Consulta Licenças de Cliente e Transportadora e Limite da Condição de Pagamento do Pedido "+SC5->C5_NUM,,,.F.,,,,,,.T.,,,.T. )
	endif
	/*
	oSay4      := TSay():New( 108,008,{||"Total do Pedido"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oSay8      := TSay():New( 108,068,{||AllTrim( Transform(_nTotPed, "@E 99,999,999,999.99") )},oDlg1,,,.F.,.F.,.F.,.T.,iif(SE4->E4_X_VRMIN<=_nTotPed,CLR_BLUE,CLR_HRED),CLR_HGRAY,052,008)
	oSay5      := TSay():New( 128,008,{||"Cd. Pagamento"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay6      := TSay():New( 148,008,{||"Mínimo Faturamento"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oSay9      := TSay():New( 128,068,{||SC5->C5_CONDPAG},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
	oSay10     := TSay():New( 128,092,{||SE4->E4_DESCRI},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,068,008)
	oSay11     := TSay():New( 148,068,{||AllTrim( Transform(SE4->E4_X_VRMIN, "@E 99,999,999,999.99") )},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,052,008)
	*/
	if SC5->C5_TIPO == "B" .or. SC5->C5_TIPO == "D"
		/* Licenças do Fornecedor */

		oSay1      := TSay():New( 002,172,{||"Fornecedor"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
		oSay2      := TSay():New( 002,228,{||SA2->A2_NREDUZ},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)

		oSay12     := TSay():New( 016,172,{||"Controle da Policia Federal:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
		oSay13     := TSay():New( 016,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay14     := TSay():New( 016,340,{|| iif( SA2->A2_POLFED == "S", "SIM", "NÃO") },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay15     := TSay():New( 026,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay16     := TSay():New( 026,228,{|| SA2->A2_PFLIC },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay17     := TSay():New( 036,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay18     := TSay():New( 036,228,{|| SA2->A2_PFVALID },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

		oSay19     := TSay():New( 056,172,{||"Controle da Policia Civil:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
		oSay20     := TSay():New( 056,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay21     := TSay():New( 056,340,{|| iif( SA2->A2_POLCIV == "S", "SIM", "NÃO" ) },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay22     := TSay():New( 066,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
		oSay24     := TSay():New( 066,228,{||SA2->A2_PCLIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay23     := TSay():New( 076,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
		oSay25     := TSay():New( 076,228,{||SA2->A2_PCVALID},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

		oSay26     := TSay():New( 096,172,{||"Controle do Ministério do Exercito:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,082,008)
		oSay27     := TSay():New( 096,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay28     := TSay():New( 096,340,{|| iif( SA2->A2_MINEXE == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay29     := TSay():New( 106,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
		oSay30     := TSay():New( 106,228,{||SA2->A2_MELIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay31     := TSay():New( 116,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
		oSay32     := TSay():New( 116,228,{||SA2->A2_MEVALID},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008) 

		oSay39     := TSay():New( 136,172,{||"Controle Visa LF:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
		oSay38     := TSay():New( 136,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay37     := TSay():New( 136,340,{|| iif( SA2->A2_VISALF == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay36     := TSay():New( 146,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay35     := TSay():New( 146,228,{||SA2->A2_VLFLIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay34     := TSay():New( 156,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay33     := TSay():New( 156,228,{||SA2->A2_VLFVLD},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

		oSay40     := TSay():New( 176,172,{||"Controle Anvisa AFE:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
		oSay41     := TSay():New( 176,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay42     := TSay():New( 176,340,{|| iif( SA2->A2_ANVISA1 == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay43     := TSay():New( 186,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay44     := TSay():New( 186,228,{||SA2->A2_AFELIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay45     := TSay():New( 196,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay46     := TSay():New( 196,228,{||SA2->A2_AFEVLD},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

		oSay53     := TSay():New( 216,172,{||"Controle Anvisa AE:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008) 
		oSay52     := TSay():New( 216,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay51     := TSay():New( 216,340,{|| iif( SA2->A2_ANVISA2 == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay50     := TSay():New( 226,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay49     := TSay():New( 226,228,{||SA2->A2_AELIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay48     := TSay():New( 236,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay47     := TSay():New( 236,228,{||SA2->A2_AEVLD },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

		oSay54     := TSay():New( 256,172,{||"Controle MAPA:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
		oSay55     := TSay():New( 256,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay56     := TSay():New( 256,340,{||iif( SA2->A2_MAPA == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay57     := TSay():New( 266,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay58     := TSay():New( 266,228,{||SA2->A2_MAPALIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay59     := TSay():New( 276,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay60     := TSay():New( 276,228,{||SA2->A2_MAPAVLD},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

	else
		/* Licenças do cliente */
		oSay1      := TSay():New( 002,172,{||"Cliente"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
		oSay2      := TSay():New( 002,228,{||SA1->A1_NREDUZ},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)

		oSay12     := TSay():New( 016,172,{||"Controle da Policia Federal:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
		oSay13     := TSay():New( 016,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay14     := TSay():New( 016,340,{|| iif( SA1->A1_POLFED == "S", "SIM", "NÃO") },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay15     := TSay():New( 026,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay16     := TSay():New( 026,228,{|| SA1->A1_PFLIC },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay17     := TSay():New( 036,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay18     := TSay():New( 036,228,{|| SA1->A1_PFVALID },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

		oSay19     := TSay():New( 056,172,{||"Controle da Policia Civil:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
		oSay20     := TSay():New( 056,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay21     := TSay():New( 056,340,{|| iif( SA1->A1_POLCIV == "S", "SIM", "NÃO" ) },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay22     := TSay():New( 066,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
		oSay24     := TSay():New( 066,228,{||SA1->A1_PCLIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay23     := TSay():New( 076,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
		oSay25     := TSay():New( 076,228,{||SA1->A1_PCVALID},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

		oSay26     := TSay():New( 096,172,{||"Controle do Ministério do Exercito:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,082,008)
		oSay27     := TSay():New( 096,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay28     := TSay():New( 096,340,{|| iif( SA1->A1_MINEXE == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay29     := TSay():New( 106,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
		oSay30     := TSay():New( 106,228,{||SA1->A1_MELIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay31     := TSay():New( 116,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
		oSay32     := TSay():New( 116,228,{||SA1->A1_MEVALID},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008) 

		oSay39     := TSay():New( 136,172,{||"Controle Visa LF:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
		oSay38     := TSay():New( 136,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay37     := TSay():New( 136,340,{|| iif( SA1->A1_VISALF == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay36     := TSay():New( 146,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay35     := TSay():New( 146,228,{||SA1->A1_VLFLIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay34     := TSay():New( 156,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay33     := TSay():New( 156,228,{||SA1->A1_VLFVLD},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

		oSay40     := TSay():New( 176,172,{||"Controle Anvisa AFE:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
		oSay41     := TSay():New( 176,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay42     := TSay():New( 176,340,{|| iif( SA1->A1_ANVISA1 == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay43     := TSay():New( 186,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay44     := TSay():New( 186,228,{||SA1->A1_AFELIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay45     := TSay():New( 196,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay46     := TSay():New( 196,228,{||SA1->A1_AFEVLD},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

		oSay53     := TSay():New( 216,172,{||"Controle Anvisa AE:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008) 
		oSay52     := TSay():New( 216,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay51     := TSay():New( 216,340,{|| iif( SA1->A1_ANVISA2 == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay50     := TSay():New( 226,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay49     := TSay():New( 226,228,{||SA1->A1_AELIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay48     := TSay():New( 236,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay47     := TSay():New( 236,228,{||SA1->A1_AEVLD },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

		oSay54     := TSay():New( 256,172,{||"Controle MAPA:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
		oSay55     := TSay():New( 256,300,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay56     := TSay():New( 256,340,{||iif( SA1->A1_MAPA == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
		oSay57     := TSay():New( 266,172,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay58     := TSay():New( 266,228,{||SA1->A1_MAPALIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
		oSay59     := TSay():New( 276,172,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay60     := TSay():New( 276,228,{||SA1->A1_MAPAVLD},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

	endif

	/* Licenças da Transportadora */
	oSay113    := TSay():New( 002,385,{||"Transportadora"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oSay112    := TSay():New( 002,441,{||SA4->A4_NREDUZ},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)

	oSay61     := TSay():New( 016,385,{||"Controle da Policia Federal:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
	oSay62     := TSay():New( 016,513,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay63     := TSay():New( 016,553,{|| iif( SA4->A4_POLFED == "S", "SIM", "NÃO") },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
	oSay64     := TSay():New( 026,385,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay65     := TSay():New( 026,441,{|| SA4->A4_PFLIC },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
	oSay66     := TSay():New( 036,385,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay67     := TSay():New( 036,441,{|| SA4->A4_PFVALID },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

	oSay68     := TSay():New( 056,385,{||"Controle da Policia Civil:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
	oSay69     := TSay():New( 056,513,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay70     := TSay():New( 056,553,{|| iif( SA4->A4_POLCIV == "S", "SIM", "NÃO" ) },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
	oSay71     := TSay():New( 066,385,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oSay72     := TSay():New( 066,441,{||SA4->A4_PCLIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
	oSay73     := TSay():New( 076,385,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oSay74     := TSay():New( 076,441,{||SA4->A4_PCVALID},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

	oSay75     := TSay():New( 096,385,{||"Controle do Ministério do Exercito:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,082,008)
	oSay76     := TSay():New( 096,513,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay77     := TSay():New( 096,553,{|| iif( SA4->A4_MINEXE == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
	oSay78     := TSay():New( 106,385,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oSay79     := TSay():New( 106,441,{||SA4->A4_MELIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
	oSay80     := TSay():New( 116,385,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oSay81     := TSay():New( 116,441,{||SA4->A4_MEVALID},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008) 

	oSay82     := TSay():New( 136,385,{||"Controle Visa LF:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
	oSay83     := TSay():New( 136,513,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay84     := TSay():New( 136,553,{|| iif( SA4->A4_VISALF == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
	oSay85     := TSay():New( 146,385,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay86     := TSay():New( 146,441,{||SA4->A4_VLFLIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
	oSay87     := TSay():New( 156,385,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay88     := TSay():New( 156,441,{||SA4->A4_VLFVLD},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

	oSay89     := TSay():New( 176,385,{||"Controle Anvisa AFE:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
	oSay90     := TSay():New( 176,513,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay91     := TSay():New( 176,553,{|| iif( SA4->A4_ANVISA1 == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
	oSay92     := TSay():New( 186,385,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay93     := TSay():New( 186,441,{||SA4->A4_AFELIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
	oSay94     := TSay():New( 196,385,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay95     := TSay():New( 196,441,{||SA4->A4_AFEVLD},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

	oSay96     := TSay():New( 216,385,{||"Controle Anvisa AE:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008) 
	oSay97     := TSay():New( 216,513,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay98     := TSay():New( 216,553,{|| iif( SA4->A4_ANVISA2 == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
	oSay99     := TSay():New( 226,385,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay100    := TSay():New( 226,441,{||SA4->A4_AELIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
	oSay101    := TSay():New( 236,385,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay102    := TSay():New( 236,441,{||SA4->A4_AEVLD },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

	oSay103    := TSay():New( 256,385,{||"Controle MAPA:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
	oSay104    := TSay():New( 256,513,{||"É Obrigado:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay105    := TSay():New( 256,553,{||iif( SA4->A4_MAPA == "S", "SIM", "NÃO")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,016,008)
	oSay106    := TSay():New( 266,385,{||"Número da Licença"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay107    := TSay():New( 266,441,{||SA4->A4_MAPALIC},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,128,008)
	oSay108    := TSay():New( 276,385,{||"Validade:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay109    := TSay():New( 276,441,{||SA4->A4_MAPAVLD},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_HGRAY,036,008)

	oSBtnCanc  := tButton():New( 256,008,"Fechar",oDlg1,{||oDlg1:End()},30,10,,,,.T.)

	oDlg1:Activate(,,,.T.)

	SC5->( dbgoto( _nReg5 ) )
	SC6->( dbgoto( _nReg6 ) )
	RestArea(aArea)
Return