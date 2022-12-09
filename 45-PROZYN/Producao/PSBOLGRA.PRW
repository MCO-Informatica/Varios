#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Font.ch"
#INCLUDE "RPTDEF.CH"
#include "rwmake.ch"
#include "ap5mail.ch"
#include "tbicode.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ BOLGRA   ณ Impressใo do boleto bancแrio em formato grแfico e PDF com    บฑฑ
ฑฑบ             ณ          ณ opcao de um unico PDF ou um PDF por titulo.                  บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 12.12.14 ณ Fabio Jadao Caires                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function psBOLGRA()

	Local aRegs			:= {}
	Local aTamSX3		:= {}
	Local cPerg			:= "BOLGRA    "
	Private Titulo		:= "Boleto de Cobran็a com C๓digo de Barras"
	Private aReturn		:= {"Banco", 1,"Financeiro", 2, 2, 1, "",1 }
	Private nLastKey	:= 0
	Private aLst		:= {}

	Private lPDF		:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria array com as perguntas da rotina ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aTamSX3	:= TAMSX3("E1_PREFIXO")
	aAdd(aRegs,{cPerg,"01","Do Prefixo"				,"","","mv_ch1",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR01",""   ,	""   ,	""   ,	""                    	,"",""		,""		,""		,"","","","","","","","","","","","","","","","",""		,"",""		,"",""})
	aAdd(aRegs,{cPerg,"02","Ate Prefixo"			,"","","mv_ch2",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR02",""   ,	""   ,	""   ,	Replic('Z',aTamSX3[1])	,"",""		,""		,""		,"","","","","","","","","","","","","","","","",""		,"",""		,"",""})

	aTamSX3	:= TAMSX3("E1_NUM")
	aAdd(aRegs,{cPerg,"03","Do Numero"				,"","","mv_ch3",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR03",""   ,	""   ,	""   ,	""                    	,"",""		,""		,""		,"","","","","","","","","","","","","","","","",""		,"",""		,"",""})
	aAdd(aRegs,{cPerg,"04","Ate Numero"				,"","","mv_ch4",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR04",""   ,	""   ,	""   ,	Replic('Z',aTamSX3[1])	,"",""		,""		,""		,"","","","","","","","","","","","","","","","",""		,"",""		,"",""})

	aTamSX3	:= TAMSX3("E1_PARCELA")
	aAdd(aRegs,{cPerg,"05","Da Parcela"				,"","","mv_ch5",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR05",""   ,	""   ,	""   ,	""                    	,"",""		,""		,""		,"","","","","","","","","","","","","","","","",""		,"","011"	,"",""})
	aAdd(aRegs,{cPerg,"06","Ate Parcela"			,"","","mv_ch6",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR06",""   ,	""   ,	""   ,	Replic('Z',aTamSX3[1])	,"",""		,""		,""		,"","","","","","","","","","","","","","","","",""		,"","011"	,"",""})

	aTamSX3	:= TAMSX3("E1_CLIENTE")
	aAdd(aRegs,{cPerg,"07","Do Cliente"				,"","","mv_ch7",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR07",""   ,	""   ,	""   ,	""                    	,"",""		,""		,""		,"","","","","","","","","","","","","","","","","SA1"	,"","001"	,"",""})
	aAdd(aRegs,{cPerg,"08","Ate Cliente"			,"","","mv_ch8",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR08",""   ,	""   ,	""   ,	Replic('Z',aTamSX3[1])	,"",""		,""		,""		,"","","","","","","","","","","","","","","","","SA1"	,"","001"	,"",""})

	aTamSX3	:= TAMSX3("E1_LOJA")
	aAdd(aRegs,{cPerg,"09","Da Loja"				,"","","mv_ch9",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR09",""   ,	""   ,	""   ,	""                    	,"",""		,""		,""		,"","","","","","","","","","","","","","","","",""		,"","002"	,"",""})
	aAdd(aRegs,{cPerg,"10","Ate Loja"				,"","","mv_chA",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR10",""   ,	""   ,	""   ,	Replic('Z',aTamSX3[1])	,"",""		,""		,""		,"","","","","","","","","","","","","","","","",""		,"","002"	,"",""})

	aTamSX3	:= TAMSX3("EE_CODIGO")
	aAdd(aRegs,{cPerg,"11","Banco Cobranca"			,"","","mv_chB",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR11",""   ,	""   ,	""   ,	"033"                 	,"",""		,""		,""		,"","","","","","","","","","","","","","","","","SA6"	,"","007"	,"",""})

	aTamSX3	:= TAMSX3("EE_AGENCIA")
	aAdd(aRegs,{cPerg,"12","Agencia Cobranca"		,"","","mv_chC",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR12",""   ,	""   ,	""   ,	""                    	,"",""		,""		,""		,"","","","","","","","","","","","","","","","",""		,"","008"	,"",""})

	aTamSX3	:= TAMSX3("EE_CONTA")
	aAdd(aRegs,{cPerg,"13","Conta Cobranca"			,"","","mv_chD",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR13",""   ,	""   ,	""   ,	""                    	,"",""		,""		,""		,"","","","","","","","","","","","","","","","",""		,"","009"	,"",""})

	aTamSX3	:= TAMSX3("EE_SUBCTA")
	aAdd(aRegs,{cPerg,"14","Sub Conta"				,"","","mv_chE",aTamSX3[3]	,aTamSx3[1]	,aTamSX3[2]	,	0,"G","","MV_PAR14",""   ,	""   ,	""   ,	""                    	,"",""		,""		,""		,"","","","","","","","","","","","","","","","",""		,"",""		,"",""})
	aAdd(aRegs,{cPerg,"15","Re-Impressao"          	,"","","mv_chF","N"			,01			,00			,	2,"C","","MV_PAR15","Sim",	"Sim",	"Sim",	"2"                  	,"","Nao"	,"Nao"	,"Nao"	,"","","","","","","","","","","","","","","","",""		,"",""		,"",""})
	aAdd(aRegs,{cPerg,"16","Considera Bco Cliente"	,"","","mv_chG","N"			,01			,00			,	2,"C","","MV_PAR16","Sim",	"Sim",	"Sim",	"2"                    	,"","Nao"	,"Nao"	,"Nao"	,"","","","","","","","","","","","","","","","",""		,"",""		,"",""})
	aAdd(aRegs,{cPerg,"17","Traz Titulos Marcados"	,"","","mv_chH","N"			,01			,00			,	2,"C","","MV_PAR17","Sim",	"Sim",	"Sim",	"2"                    	,"","Nao"	,"Nao"	,"Nao"	,"","","","","","","","","","","","","","","","",""		,"",""		,"",""})
	aAdd(aRegs,{cPerg,"18","Imprime APENAS marcados?"	,"","","mv_chH","N"			,01			,00			,	2,"C","","MV_PAR18","Sim",	"Sim",	"Sim",	"2"                    	,"","Nao"	,"Nao"	,"Nao"	,"","","","","","","","","","","","","","","","",""		,"",""		,"",""})
//aAdd(aRegs,{cPerg,"18","Modo de Impressao"		,"","","mv_chI","N"			,01			,00			,	2,"C","","MV_PAR18","Arquivo ฺnico","Arquivo ฺnico","Arquivo ฺnico" ,"2","","Arq. por boleto","Arq. por boleto","Arq. por boleto","","","","","","","","","","","","","","","","","","","","",""})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria SX1 se nใo existir ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CriaSx1(aRegs)

	If !Pergunte(cPerg, .T.)
		Return(Nil)
	EndIf

	IF MV_PAR18 == 2
		IF !MSGYESNO("Aten็ใo: Voc๊ estแ prestes a iniciar a impressใo de boletos de TODOS os tํtulos. Deseja continuar?")
			return(Nil)
		endif
	ENDIF
	aAreaSA6 := SA6->( GetArea() )
	SA6->( dbSetOrder( 1 ) )
	SA6->( dbGoTop() )
	If !SA6->( dbSeek( xFilial( "SA6" ) + MV_PAR11 + MV_PAR12 + MV_PAR13 ) )
		MsgStop( "O banco nใo cadastrado para a gera็ใo do Boleto!" )
		RestArea( aAreaSA6 )
		Return
	Endif
	RestArea( aAreaSA6 )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chama a rotina para carregar os dados a serem processados ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Processa( { |lEnd| CallLst() }, "Selecionando dados a processar", Titulo )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se hแ dados a serem exibidos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(aLst) > 0
		Processa( { |lEnd| CallMark(aLst) }, "Selecionando dados a processar", Titulo )
	Else
		Aviso(	Titulo,;
			"Nใo existem dados a serem impressos. Verifique os parโmetros.",;
			{"&Continua"},,;
			"Sem Dados" )
	EndIf

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ CallLst  ณ Carrega os registros a serem processados                     บฑฑ
ฑฑบ             ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Solicitante ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 12.12.14 ณ Fabio Jadao Caires                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CallLst()

	Local aAreaAtu	:= GetArea()
	Local aTamSX3	:= {}
	Local nCnt		:= 0
	Local cQry	    := ""
/* Local nRegSD2	:= 0
Local cxmensa   :=""
Local axsc5 */

// Faz query para buscar os titulos que serao emitidos
cQry	:= "SELECT SE1.R_E_C_N_O_ AS REGSE1,"
cQry	+= "       SE1.E1_PREFIXO,SE1.E1_NUM   ,SE1.E1_PARCELA,SE1.E1_TIPO  ,SE1.E1_CLIENTE,"
cQry	+= "       SE1.E1_LOJA   ,SE1.E1_NOMCLI,SE1.E1_EMISSAO,SE1.E1_VENCTO,SE1.E1_VENCREA,SE1.E1_VALOR,SE1.E1_PORTADO,"
cQry	+= "       SE1.E1_NUMBCO ,SE1.E1_FILIAL "

cQry	+= "FROM "+ RetSqlName("SE1") +" SE1 "
cQry	+= "     INNER JOIN "+ RetSqlName("SA1") +" SA1 "
cQry	+= "     ON SA1.A1_FILIAL  = '"+xFilial("SA1")+"' "
cQry	+= "    AND SA1.A1_COD     = SE1.E1_CLIENTE "
cQry	+= "    AND SA1.A1_LOJA    = SE1.E1_LOJA "
cQry	+= "    AND SA1.D_E_L_E_T_ = ' ' "

cQry	+= "WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
cQry	+= "  AND SE1.E1_SALDO > 0"
cQry	+= "  AND SE1.E1_PREFIXO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
cQry	+= "  AND SE1.E1_NUM BETWEEN '"    +mv_par03+"' AND '"+mv_par04+"'"
cQry	+= "  AND SE1.E1_PARCELA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
//cQry	+= "  AND SE1.E1_TIPO = 'NF'"
cQry	+= "  AND SE1.E1_CLIENTE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
cQry	+= "  AND SE1.E1_LOJA BETWEEN '"   +mv_par09+"' AND '"+mv_par10+"'"

	If 	mv_par15 == 1
	cQry+= "  AND SE1.E1_NUMBCO <> '" + Space(TAMSX3("E1_NUMBCO")[1])+"'"
	cQry+= "  AND SE1.E1_PORTADO = '" + mv_par11+"'"
	cQry+= "  AND SE1.E1_AGEDEP  = '" + mv_par12+"'"
	cQry+= "  AND SE1.E1_CONTA   = '" + mv_par13+"'"
	Else
	cQry+= "  AND SE1.E1_NUMBCO = '"+Space(TAMSX3("E1_NUMBCO")[1])+"'"
	cQry+= "  AND SE1.E1_PORTADO in ('   ', '"+mv_par11+"')"
	Endif

cQry	+= "  AND SE1.D_E_L_E_T_ <> '*'"

cQry	+= "ORDER BY SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_CLIENTE, SE1.E1_LOJA "


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se existir o alias temporแrio, fecha para nใo dar erro ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Select("RFINR99A") > 0
	dbSelectArea("RFINR99A")
	dbCloseArea()
	RFINR99A->( dbCloseArea() )
	EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa a select no banco para pegar os registros a processar ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TCQUERY cQry NEW ALIAS "RFINR99A"
dbSelectArea("RFINR99A")
dbGoTop()
RFINR99A->( dbGotop() )


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Compatibiliza os campos com a TopField ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aTamSX3	:= TAMSX3("E1_EMISSAO")
TCSETFIELD("RFINR99A", "E1_EMISSAO",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
aTamSX3	:= TAMSX3("E1_VENCTO")
TCSETFIELD("RFINR99A", "E1_VENCTO",		aTamSX3[3], aTamSX3[1], aTamSX3[2])
aTamSX3	:= TAMSX3("E1_VENCREA")
TCSETFIELD("RFINR99A", "E1_VENCREA",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
aTamSX3	:= TAMSX3("E1_VALOR")
TCSETFIELD("RFINR99A", "E1_VALOR",		aTamSX3[3], aTamSX3[1], aTamSX3[2])

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Conta os registros a serem processados ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RFINR99A->( dbGotop() )
RFINR99A->( dbEval( { || nCnt++ },,{ || !Eof() } ) )

dbGoTop()

RFINR99A->( dbGotop() )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alimenta array com os dados a serem exibidos na tela de marca็ใo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SC5->( dbSetOrder( 1 ) )
dbSelectArea("RFINR99A")
dbGoTop()
RFINR99A->( dbGotop() )

ProcRegua( nCnt )
RFINR99A->( dbGotop() )


	While !Eof()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Movimenta regua de Impressใo ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤadminฤฤฤฤฤฤฤู
	IncProc( "Tํtulo: " + RFINR99A->E1_PREFIXO +"/"+ RFINR99A->E1_NUM +"/"+ RFINR99A->E1_PARCELA )
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria o elemento no array ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aLst, {	(mv_par17 == 1)		,;
	RFINR99A->E1_PREFIXO,;
	RFINR99A->E1_NUM	,;
	RFINR99A->E1_PARCELA,;
	RFINR99A->E1_TIPO	,;
	RFINR99A->E1_CLIENTE,;
	RFINR99A->E1_LOJA	,;
	RFINR99A->E1_NOMCLI	,;
	RFINR99A->E1_EMISSAO,;
	RFINR99A->E1_VENCTO	,;
	RFINR99A->E1_VENCREA,;
	RFINR99A->E1_VALOR	,;
	RFINR99A->E1_PORTADO,;
	RFINR99A->REGSE1 	,;
	RFINR99A->E1_NUMBCO 	})
	
	dbSelectArea("RFINR99A")
	dbSkip()
	EndDo

/***************************************************************
** Fim rotina												  **
***************************************************************/


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fecha a แrea de trabalho ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("RFINR99A")
dbCloseArea()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura แrea original ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea(aAreaAtu)

Return(Nil)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ CallMark ณ Monta a tela de impressใo grแfica                            บฑฑ
ฑฑบ             ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Solicitante ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 12.12.14 ณ Fabio Jadao Caires                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CallMark()

	Local oLst
	Local oDlg
	Local oOk			:= LoadBitMap(GetResources(), "LBOK")	// "CHECKED"
	Local oNo			:= LoadBitMap(GetResources(), "LBNO")	// "UNCHECKED"
	Local lExec			:= .F.
	Local lProc			:= .F.
	Local nLoop			:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta interface com usuแrio para efetuar a marca็ใo dos tํtulos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oDlg TITLE "Sele็ใo de Tํtulos" FROM 000,000 TO 400,700 OF oDlg PIXEL
	@ 005,003	LISTBOX oLst ;
		FIELDS 	;
		HEADER	" ",;
		"Prefixo",;
		"N๚mero",;
		"Parcela",;
		"Tipo",;
		"Cliente",;
		"Loja",;
		"Nome",;
		"Emissใo",;
		"Vencimento",;
		"Venc.Real",;
		"Valor",;
		"Portador" ,;
		"Nosso Numero" ,;
		COLSIZES GetTextWidth(0,"BB"),;
		GetTextWidth(0,"BBBB"),;
		GetTextWidth(0,"BBBBB"),;
		GetTextWidth(0,"BB"),;
		GetTextWidth(0,"BB"),;
		GetTextWidth(0,"BBBB"),;
		GetTextWidth(0,"BB"),;
		GetTextWidth(0,"BBBBBBBBBBBB"),;
		GetTextWidth(0,"BBBB"),;
		GetTextWidth(0,"BBBB"),;
		GetTextWidth(0,"BBBB"),;
		GetTextWidth(0,"BBBBBBBBB"),;
		GetTextWidth(0,"BBB"), ;
		GetTextWidth(0,"BBBBBBBBBB") ;
		ON DBLCLICK(	aLst[oLst:nAt,1] := !aLst[oLst:nAt,1],;
		oLst:Refresh() ) ;
		SIZE 345,170 OF oDlg PIXEL

	oLst:SetArray(aLst)
	oLst:bLine := { || {	If(aLst[oLst:nAt,01], oOk, oNo),;			// Marca
	aLst[oLst:nAt,02],;							// Prefixo
	aLst[oLst:nAt,03],;							// Numero
	aLst[oLst:nAt,04],;							// parcela
	aLst[oLst:nAt,05],;							// Tipo
	aLst[oLst:nAt,06],;							// Cliente
	aLst[oLst:nAt,07],;							// Loja
	aLst[oLst:nAt,08],;							// Nome
	DToC(aLst[oLst:nAt,09]),;				   		// Emissใo
	DToC(aLst[oLst:nAt,10]),;						// Vencimento
	DToC(aLst[oLst:nAt,11]),;						// Vencimento real
	Transform(aLst[oLst:nAt,12], "@E 999,999,999.99"),;	// Valor
	aLst[oLst:nAt,13], ;							// Portador
	aLst[oLst:nAt,15] ;							// NOSSO NUMERO
	} }

	DEFINE SBUTTON oBtnOk	FROM 180,310 TYPE 1 ACTION(lExec := .T., oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON oBtnCan	FROM 180,275 TYPE 2 ACTION(lExec := .F., ODLG:end()) ENABLE OF oDlg

	ACTIVATE DIALOG oDlg CENTERED

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se teclou no botใo confirma ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lExec
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica se tem algum tํtulo marcado ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For nLoop := 1 To Len(aLst)
			If aLst[nLoop,1] .or. MV_PAR18 == 2
				lProc	:= .T.
				Exit
			EndIf
		Next nLoop

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Avisa usuแrio que nใo hแ tํtulo marcado ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !lProc
			Aviso(	Titulo,;
				"Nenhum tํtulo foi marcado. Nใo hแ dados a serem impressos.",;
				{"&Continua"},,;
				"Sem Dados" )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Chama a rotina que irแ montar e imprimir o relat๓rio ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Else
			Processa( { |lEnd| MontaPDF() }, "Montando Imagem do Relat๓rio.", Titulo )
		Endif
	EndIf


Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ MontaPDF ณ Monta a imagem do relat๓rio a ser impresso um PDF por        บฑฑ
ฑฑบ             ณ          ณ boleto em um diretorio selecionado pelo usuario              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Solicitante ณ 17.01.07 ณ Luiz Carlos Ianhez                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 21.01.07 ณ Almir Bandina                                                บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaPDF(_lJob,cPDFPath)

	Local oPrint
	Local aDadEmp	:= {}
	Local aDadBco	:= {}
	Local aDadBkp	:= {}
	Local aDadTit	:= {}
	Local aDadCli	:= {}
	Local aBarra	:= {}
	Local nTpImp	:= 0
	Local nLoop		:= 0
//Local nfaixa	:= 0
	Local lPDFOk	        := .F.
    Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup 	:= .T.
	Default cPDFPath	    := ""
	Default _lJob           := .F.

	nTpImp 	:= 2
	lPDF	:= .T.
	Conout("MontaPDF Inicio")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posiciona no Banco ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SA6")
	dbSetOrder(1)
	If !dbSeek( xFilial("SA6") + mv_par11 + mv_par12 + mv_par13 )
		Aviso(	Titulo,;
			"Banco/Ag๊ncia/Conta: "+ AllTrim(mv_par11) +"/"+ AllTrim(mv_par12) +"/"+ AllTrim(mv_par13) +Chr(13)+Chr(10)+;
			"O registro nใo foi localizado no arquivo. Serแ desconsiderado.",;
			{"&Continua"},2,;
			"Registro Invแlido" )
		Conout("O registro nใo foi localizado no arquivo. Serแ desconsiderado.")
		Return .F.
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posiciona no Parโmetro do Banco ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SEE")
	dbSetOrder(1)
	If !dbSeek(xFilial("SEE")+mv_par11+mv_par12+mv_par13+mv_par14)
		Aviso(	Titulo,;
			"Banco/Ag๊ncia/Conta/Carteira: "+ AllTrim(mv_par11) +"/"+ AllTrim(mv_par12) +"/"+ AllTrim(mv_par13) +"/"+ AllTrim(mv_par14) + Chr(13) + Chr(10) +;
			"Os parโmetros do banco nใo foram localizados. Serแ desconsiderado.",;
			{"&Continua"},2,;
			"Registro Invแlido" )
		Conout("Os parโmetros do banco nใo foram localizados. Serแ desconsiderado.")
		Return .F.
	Else
		If (Val(SEE->EE_FAXFIM) - Val(SEE->EE_FAXATU)) < 1000
			Alert("Faixa de n๚mero bancแrio abaixo de 1000. Entrar em contato com o financeiro com urg๊ncia.")
		Endif

		If (Val(SEE->EE_FAXFIM) - Val(SEE->EE_FAXATU)) < 10
			Alert("Faixa esgotada. Entrar em contato com o financeiro")
			Conout("Faixa esgotada. Entrar em contato com o financeiro")
			Return .F.
		Endif

	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chama rotina que pega os dados do banco e empresa ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !TCDadBco(aDadEmp, aDadBco)
		Aviso(	Titulo,;
			"Banco/Ag๊ncia/Conta: "+ AllTrim(mv_par11) +"/"+ AllTrim(mv_par12) +"/"+ AllTrim(mv_par13) +"/"+ Chr(13) + Chr(10) +;
			"Banco do cliente: "+ SA1->A1_BCO1 + Chr(13) + Chr(10) + ;
			"Nใo foi possํvel obter os dados do banco.",;
			{"&Continua"},2,;
			"Registro Invแlido" )
		Conout("Nใo foi possํvel obter os dados do banco.")
		Return .F.
	EndIf

	IF EMPTY(cPDFPath)
		cPDFPath := cGetFile("*.pdf","Selecione o local para a gravacao do(s) arquivo(s) PDF",0,,.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY) //SUPERGETMV("MV_XPDFDIR")//"E:\Prosimulador\"//cGetFile("*.pdf","Selecione o local para a gravacao do(s) arquivo(s) PDF",0,,.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)
		ProcRegua(Len(aLst))
	Endif

	For nLoop := 1 To Len(aLst)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Movimenta r้gua de impressใo ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		IF !_lJob
			IncProc( "Tํtulo: " + aLst[nLoop,02] +"/"+ aLst[nLoop,03] + "." + ALLTRIM(STR(NLOOP)) + " DE " + ALLTRIM(STR(LEN(ALST))))
		EndIf
		Conout("Inicio TMSPrinter")

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ S๓ processa se estiver marcado ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If 	aLst[nLoop,01] .or. MV_PAR18 == 2

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Seta as configura็ใo do objeto print ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

			lAdjustToLegacy := .F.
			lDisableSetup  	:= .T.

			//oPrint := FWMSPrinter():New(Alltrim(aLst[nLoop,02])+"_"+Alltrim(aLst[nLoop,03])+"_"+Alltrim(aLst[nLoop,04]),6,.T.,,.T.,,,,,,.F.,.F.)
			oPrint := FWMSPrinter():New(UPPER(Alltrim(aLst[nLoop,06])+"_"+"0"+alltrim(aLst[nLoop,02])+alltrim(aLst[nLoop,03])+alltrim(aLst[nLoop,04])),6,.T.,,.T.,,,,,,.F.,.F.) // nome do arquivo
			//oPrint := FWMSPrinter():New("teste",6,.T.,,.T.,,,,,,.F.,.F.)
			// Ordem obrigแtoria de configura็ใo do relat๓rio
			oPrint:cPathPDF := cPDFPath	//"c:\directory\" // Caso seja utilizada impressใo em IMP_PDF
			oPrint:SetPortrait() // ou SetLandscape()
			_cNameFile := UPPER(Alltrim(aLst[nLoop,06])+"_"+"0"+alltrim(aLst[nLoop,02])+alltrim(aLst[nLoop,03])+alltrim(aLst[nLoop,04]))
			IF File(cPDFPath+_cNameFile+".pdf")
				fErase( cPDFPath+_cNameFile+".bak")
				fRename(cPDFPath+_cNameFile+".pdf", cPDFPath+_cNameFile+".bak")
			Endif



			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Posiciona no tํtulo ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			dbSelectArea("SE1")
			dbSetOrder(1)
			dbGoTo(aLst[nLoop,14])
			If 	Eof() .Or. Bof() .AND.  !_lJob
				Aviso(	Titulo,;
					"Tํtulo :"+ aLst[nLoop,02] +"/"+ aLst[nLoop,03] +"/"+ aLst[nLoop,04] +"/"+ aLst[nLoop,05] +Chr(13)+Chr(10)+;
					"O tํtulo nใo foi localizado no arquivo. Serแ desconsiderado.",;
					{"&Continua"},2,;
					"Registro Invแlido" )
				Loop
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Posiciona no Cliente ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			dbSelectArea("SA1")
			dbSetOrder(1)
			If !MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA) .AND.  !_lJob
				Aviso(	Titulo,;
					"Tํtulo :"+ aLst[nLoop,02] +"/"+ aLst[nLoop,03] +"/"+ aLst[nLoop,04] +"/"+ aLst[nLoop,05] +Chr(13)+Chr(10)+;
					"Cliente/Loja: "+ SE1->E1_CLIENTE +"/"+ SE1->E1_LOJA +Chr(13)+Chr(10)+;
					"O cliente nใo foi localizado no arquivo. Serแ desconsiderado.",;
					{"&Continua"},2,;
					"Registro Invแlido" )
				Loop
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Verifica se o considera o banco definido no cadastro do cliente e ณ
			//ณ se o banco do parโmetro ้ o mesmo do cadastro                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If mv_par16 == 1 .And. !Empty(SA1->A1_BCO1) .And. SA1->A1_BCO1 <> mv_par11 .AND. !_lJob
				Aviso(	Titulo,;
					"Tํtulo :"+ aLst[nLoop,02] +"/"+ aLst[nLoop,03] +"/"+ aLst[nLoop,04] +"/"+ aLst[nLoop,05] +Chr(13)+Chr(10)+;
					"Banco/Ag๊ncia/Conta: "+ mv_par11 +"/"+ mv_par12 +"/"+ mv_par13 +Chr(13)+Chr(10)+;
					"Banco do cliente: "+ SA1->A1_BCO1 +Chr(13)+Chr(10)+ ;
					"O Banco do cadastro ้ diferente do parโ,etro. Serแ desconsiderado.",;
					{"&Continua"},2,;
					"Registro Invแlido" )
				Loop
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Posiciona no Tํtulo ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			dbSelectArea("SE1")

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Define a carteira de cobran็a ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cCarteira	:= "101"

			aDadBkp	:= aClone( aDadBco )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Chama rotina que pega os dados do tํtulo e cliente ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If !TCDadTit(aDadTit, aDadCli, aBarra, aDadBco) .AND. !_lJob
				Aviso(	Titulo,;
					"Tํtulo :"+ aLst[nLoop,02] +"/"+ aLst[nLoop,03] +"/"+ aLst[nLoop,04] +"/"+ aLst[nLoop,05] +Chr(13)+Chr(10)+;
					"Nใo foi possํvel obter os dados do tํtulo. serแ desconsiderado.",;
					{"&Continua"},2,;
					"Registro Invแlido" )
				Loop
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Chama a fun็ใo de impressใo do boleto ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			TCImpBol33(oPrint,aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp)

			aDadBco := aClone( aDadBkp )
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Atualiza o tํtulo com o nosso n๚mero ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If mv_par15 == 2 //Reimpressใo - 1=Sim;2=Nao

//			cQuery := " SELECT EE_FAXATU "
				///			cQuery += " FROM "+RetSqlName("SEE")+" "
//			cQuery += " WHERE  D_E_L_E_T_ = '' " 
				//			cQuery += " AND  EE_CODIGO ='"+mv_par11+"'"
				//			cQuery += " AND  EE_AGENCIA ='"+mv_par12+"'"
//			cQuery += " AND  EE_CONTA ='"+mv_par13+"'"   
				//			cQuery += " AND  EE_SUBCTA ='"+mv_par14+"'"

				//			If Select("TRB") > 0
				//				dbSelectArea("TRB")
				//				dbCloseArea()
				//			Endif

//			TCQUERY cQuery NEW ALIAS "TRB"			
//			cQuery := ChangeQuery(cQuery)
//			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)

				//		   	cFaixaAtu := StrZero(Val(Alltrim(TRB->EE_FAXATU))+1,8)//atualizo o valor da faixa

				//			_cNumBco  := Alltrim(TRB->EE_FAXATU) //valor nosso numero

				DbSelectArea("SE1")

				RecLock("SE1",.F.)

				_cNumBco := aBarra[3]
				_cNumBco := StrTran(_cNumBco,"-","")
				_cNumBco := StrTran(_cNumBco,"/","")

				SE1->E1_NUMBCO	:= _cNumBco//StrTran(aBarra[4],"-","")//aBarra[3]

				If FieldPos("E1_BCOBOL") > 0
					SE1->E1_BCOBOL	 := aDadBco[1]
				Else
					SE1->E1_PORTADO  := mv_par11
					SE1->E1_AGEDEP	 := mv_par12
					SE1->E1_CONTA	 := mv_par13
				EndIf

				//	Quando a cobran็a for atrav้s do Bradesco ou BBM preenche o E1_IDCNAB com o
				// Prefixo+Numero+Parcela para viabilizar o protesto.

				MsUnlock()

//			DbSelectArea("SEE")
//		    DbSetOrder(1)
//		    If DbSeek(xFilial("SEE")+mv_par11+mv_par12+mv_par13+mv_par14)
//	            cNossoNum := StrZero(Val(Alltrim(SEE->EE_FAXATU))+1,11)
//	            RecLock("SEE",.f.)
//	            SEE->EE_FAXATU := cNossoNum
//	            MsUnlock()
//
//            Endif

			ELSE
				_cNumBco := aBarra[3]
				_cNumBco := StrTran(_cNumBco,"-","")
				_cNumBco := StrTran(_cNumBco,"/","")


			Endif

			Conout("Fim TMSPrinter -- "+cPDFPath+_cNameFile+".pdf")
			oPrint:Print()
			lPDFOk := .T.
			CpyT2S( cPDFPath+_cNameFile+".pdf", "\system\boletosp" )
		EndIf
	Next nLoop

	IF  !_lJob
		If 	lPDFOk
			Msginfo( "Boletos marcados gerados em formato PDF em "+Alltrim(cPDFPath)+"." )
		Else
			Alert( "Nenhum PDF foi gerado !" )
		EndIf
	EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a chamada da SetPrint ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MS_FLUSH()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ TCDadBco ณ Retorna array com os dados do banco e da empresa             บฑฑ
ฑฑบ             ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 12.12.14 ณ Fabio Jadao Caires                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpA1 = Array vazio passado por refer๊ncia para ser atualizado com os   บฑฑ
ฑฑบ             ณ         dados do cadastro de empresa (SigaMat)                          บฑฑ
ฑฑบ             ณ ExpA2 = Array Vazio passado por refer๊ncia para ser atualizado com os   บฑฑ
ฑฑบ             ณ         dados so cadastro do banco (SA6)                                บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ ExpL1 = .T. montou os arrays corretamento, .F. nใo montou os arrays     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ Os arquivos devem estar posicionados SM0, SA6, SEE                      บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TCDadBco(aDadEmp, aDadBco, aCorres)

	Local aAreaAtu	:= GetArea()
	Local lRet		:= .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se passou os parโmetros para a fun็ใo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (aDadEmp == Nil .Or. ValType(aDadEmp) <> "A") .Or. (aDadBco == Nil .Or. ValType(aDadBco) <> "A")
		Aviso(	"Biblioteca de Fun็๕es",;
			"Os parโmetros passados por refer๊ncia estใo fora dos padr๕es."+Chr(13)+Chr(10)+;
			"Verifique a chamada da fun็ใo no programa de origem.",;
			{"&Continua"},2,;
			"Chamada Invแlida" )
		lRet	:= .F.
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se os arquivos estใo posicionados ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If SM0->(Eof()) .Or. SM0->(Bof())
		Aviso(	"Biblioteca de Fun็๕es",;
			"O arquivo de Empresas nใo esta posicionado.",;
			{"&Continua"},,;
			"Registro Invแlido" )
		lRet	:= .F.
	EndIf

	If SA6->(Eof()) .Or. SA6->(Bof())
		Aviso(	"Biblioteca de Fun็๕es",;
			"O arquivo de Bancos nใo esta posicionado.",;
			{"&Continua"},,;
			"Registro Invแlido" )
		lRet	:= .F.
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria array vazio para que nใo d๊ erro se nใo encontrar dados ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aDadEmp	:= {	"",;	// [1] Nome da Empresa
	"",;	// [2] Endere็o
	"",;	// [3] Bairro
	"",;	// [4] Cidade
	"",;	// [5] Estado
	"",;	// [6] Cep
	"",;	// [7] Telefone
	"",;	// [8] Fax
	"",;	// [9] CNPJ
	"" ;	// [10]Inscri็ใo Estadual
	}

	aDadBco	:= {	"",;	// [1] C๓digo do Banco
	"",;	// [2] Dํgito do Banco
	"",;	// [3] C๓digo da Ag๊ncia
	"",;	// [4] Dํgito da Ag๊ncia
	"",;	// [5] N๚mero da Conta Corrente
	"",;	// [6] Dํgito da Conta Corrente
	"",;	// [7] Nome Completo do Banco
	"",;	// [8] Nome Reduzido do Banco
	"",;	// [9] Nome do Arquivo com o Logotipo do Banco
	0,;		// [10]Taxa de juros a ser utilizado no cแlculo de juros de mora
	0,;		// [11]Taxa de multa a ser impressa no boleto
	0,;		// [12]N๚mero de dias para envio do tํtulo ao cart๓rio
	"",;	// [13]Dado para o campo "Uso do Banco"
	"",;	// [14]Dado para o campo "Esp้cie do Documento"
	"",;	// [15]C๓digo do Cedente
	"",;	// [16]Mensagem Livre1 para o Cedente
	"";	// [17]Mensagem Livre2 para o Cedente
	}

	If 	lRet
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Alimenta array com os dados da Empresa ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_aAreaSM0 := SM0->( GetArea() )

//	DbSelectArea("SM0")
//	SM0->( DbGoTop() )
//	SM0->( DbSeek(cEmpAnt+"01") )

		aDadEmp[1]	:= SM0->M0_NOMECOM

		If !Empty(SM0->M0_ENDCOB)
			aDadEmp[2]	:= SM0->M0_ENDCOB
			aDadEmp[3]	:= SM0->M0_BAIRCOB
			aDadEmp[4]	:= SM0->M0_CIDCOB
			aDadEmp[5]	:= SM0->M0_ESTCOB
			aDadEmp[6]	:= SM0->M0_CEPCOB
		Else
			aDadEmp[2]	:= SM0->M0_ENDENT
			aDadEmp[3]	:= SM0->M0_BAIRENT
			aDadEmp[4]	:= SM0->M0_CIDENT
			aDadEmp[5]	:= SM0->M0_ESTENT
			aDadEmp[6]	:= SM0->M0_CEPENT
		EndIf

		aDadEmp[7]	:= SM0->M0_TEL
		aDadEmp[8]	:= SM0->M0_FAX
		aDadEmp[9]	:= SM0->M0_CGC
		aDadEmp[10]	:= SM0->M0_INSC

		RestArea( _aAreaSM0	)


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Alimenta array com os dados do Banco ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aDadBco[1]	:= SA6->A6_COD 
		aDadBco[2]	:= "7"
		aDadBco[3]	:= Alltrim(SA6->A6_AGENCIA)
		aDadBco[4]	:= ""
		aDadBco[5]	:= Left( AllTrim( SA6->A6_NUMCON ), Len(AllTrim( SA6->A6_NUMCON ))-1 ) //AG em 05/06/2008
		aDadBco[6]	:= Right( AllTrim( SA6->A6_NUMCON ), 1 )
		aDadBco[7]	:= SA6->A6_NOME
		aDadBco[8]	:= SA6->A6_NREDUZ

		If 	SA6->(FieldPos("A6_NREDUZ")) > 0
			aDadBco[9]	:= Alltrim(aDadBco[8])+".BMP"
		Else
			aDadBco[9]	:= ""
		EndIf

		aDadBco[10]	:= 0.033
		aDadBco[11]	:= 2
		aDadBco[12]	:= 0
		aDadBco[14]	:= "DM"
		//aDadBco[15]	+= AllTrim(aDadBco[3])+"/"+AllTrim(aDadBco[5])+"-"+AllTrim(aDadBco[6])
		aDadBco[15]	:= AllTrim(aDadBco[3])+"/"+AllTrim(SEE->EE_CODEMP)

	EndIf

	RestArea(aAreaAtu)

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ TCDadTit ณ Retorna array com os dados do tํtulo e do cliente            บฑฑ
ฑฑบ             ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 12.12.14 ณ Fabio Jadao Caires                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpA1 = Array vazio passado por refer๊ncia para ser atualizado com os   บฑฑ
ฑฑบ             ณ         dados do cadastro do tํtulo (SE1)                               บฑฑ
ฑฑบ             ณ ExpA2 = Array Vazio passado por refer๊ncia para ser atualizado com os   บฑฑ
ฑฑบ             ณ         dados so cadastro do cliente (SA1)                              บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ ExpL1 = .T. montou os arrays corretamento, .F. nใo montou os arrays     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ Os arquivos devem estar posicionados SE1, SA1, SEE, SA6                 บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TCDadTit(aDadTit, aDadCli, aBarra, aDadBco)

	Local aAreaAtu	:= GetArea()
	Local lRet		:= .T.
	Local nSaldo	:= 0
	Local cNumDoc	:= ""
	Local cMensag1	:= ""
	Local cMensag2	:= ""
	Local cMensag3	:= ""
	Local cMensag4	:= ""
	Local cMensag5	:= ""
	Local cMensag6	:= ""
	Local nLts

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se passou os parโmetros para a fun็ใo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If 	(aDadTit == Nil .Or. ValType(aDadTit) <> "A") .Or.;
			(aDadCli == Nil .Or. ValType(aDadCli) <> "A") .Or.;
			(aBarra  == Nil .Or. ValType(aBarra)  <> "A")

		Aviso(	"Biblioteca de Fun็๕es",;
			"Os parโmetros passados por refer๊ncia estใo fora dos padr๕es."+Chr(13)+Chr(10)+;
			"Verifique a chamada da fun็ใo no programa de origem.",;
			{"&Continua"},2,;
			"Chamada Invแlida" )
		lRet	:= .F.
	EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se os arquivos estใo posicionados ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If 	SE1->(Eof()) .Or. SE1->(Bof())
		Aviso(	"Biblioteca de Fun็๕es",;
			"O arquivo de Tํtulos a Receber nใo esta posicionado.",;
			{"&Continua"},,;
			"Registro Invแlido" )
		lRet	:= .F.
	EndIf

	If 	SA1->(Eof()) .Or. SA1->(Bof())
		Aviso(	"Biblioteca de Fun็๕es",;
			"O arquivo de Clientes nใo esta posicionado.",;
			{"&Continua"},,;
			"Registro Invแlido" )
		lRet	:= .F.
	EndIf


	aDadTit	:= {	"",;					// [1] Prefixo do Tํtulo
	"",;					// [2] N๚mero do Tํtulo
	"",;					// [3] Parcela do Tํtulo
	"",;					// [4] Tipo do tํtulo
	CToD("  /  /  "),;		// [5] Data de Emissใo do tํtulo
	CToD("  /  /  "),;		// [6] Data de Vencimento do Tํtulo
	CToD("  /  /  "),;		// [7] Data de Vencimento Real
	0,;						// [8] Valor Lํquido do Tํtulo
	"",;					// [9] C๓digo do Barras Formatado
	"",;					// [10]Carteira de Cobran็a
	"",;					// [11]1.a Linha de Mensagens Diversas
	"",;					// [12]2.a Linha de Mensagens Diversas
	"",;					// [13]3.a Linha de Mensagens Diversas
	"",;					// [14]4.a Linha de Mensagens Diversas
	"",;					// [15]5.a Linha de Mensagens Diversas
	"",;					// [16]6.a Linha de Mensagens Diversas
	0 ;						// [17] Valor Multa Mora
	}


	aDadCli	:= {	"",;					// [1] C๓digo do cliente
	"",;					// [2] Loja do Cliente
	"",;					// [3] Nome Completo do Cliente
	"",;					// [4] CNPJ do Cliente
	"",;					// [5] Inscri็ใo Estadual do cliente
	"",;					// [6] Tipo de Pessoa do Cliente
	"",;					// [7] Endere็o
	"",;					// [8] Bairro
	"",;					// [9] Municํpio
	"",;					// [10] Estado
	"" ;					// [11] Cep
	}


	aBarra	:= {	"",;					// [1] C๓digo de barras (Banco+"9"+Dํgito+Fator+Valor+Campo Livre
	"",;					// [2] Linha Digitแvel
	"",;					// [3] Nosso N๚mero sem formata็ใo
	"" ;					// [4] Nosso N๚mero Formatado
	}

	If 	lRet
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Alimenta array com os dados do cliente ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aDadCli[1]	:= SA1->A1_COD
		aDadCli[2]	:= SA1->A1_LOJA
		aDadCli[3]	:= SA1->A1_NOME
		aDadCli[4]	:= SA1->A1_CGC
		aDadCli[5]	:= SA1->A1_INSCR
		aDadCli[6]	:= SA1->A1_PESSOA

		If !Empty(SA1->A1_ENDCOB) //.And. !( "MESMO" $ UPPER( SA1->A1_ENDCOB ) )
			aDadCli[7]	:= SA1->A1_ENDCOB
			aDadCli[8]	:= SA1->A1_BAIRROC
			aDadCli[9]	:= SA1->A1_MUNC
			aDadCli[10]	:= SA1->A1_ESTC
			aDadCli[11]	:= SA1->A1_CEPC
		Else
			aDadCli[7]	:= SA1->A1_END
			aDadCli[8]	:= SA1->A1_BAIRRO
			aDadCli[9]	:= SA1->A1_MUN
			aDadCli[10]	:= SA1->A1_EST
			aDadCli[11]	:= SA1->A1_CEP
		Endif

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Monta o saldo do tํtulo ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nSaldo	:= SE1->E1_SALDO
//	nSaldo -= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		nSaldo	-= SE1->E1_IRRF
		nSaldo	-= SE1->E1_DECRESC
//	nSaldo -= SE1->E1_VRETIRF
		nSaldo -= SE1->E1_PIS
		nSaldo -= SE1->E1_COFINS
		nSaldo -= SE1->E1_CSLL
		nSaldo	+= SE1->E1_ACRESC

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Pega ou monta o nosso n๚mero ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If !Empty(SE1->E1_NUMBCO)
			cNumDoc	:= SE1->E1_NUMBCO
		Else
			cNumDoc	:= STRZERO(VAL(NOSSONUM()),08)//robes
		EndIf

		aBarra	:= GetBarra(aDadBco[1],aDadBco[3],aDadBco[4],aDadBco[5],aDadBco[6],cCarteira,cNumDoc,nSaldo,SE1->E1_VENCTO,SEE->EE_CODEMP)
		If SE1->E1_FILIAL == '01'
			_cLinha := Alltrim(POSICIONE("SC5",1,XFILIAL("SC5")+SE1->E1_PEDIDO,"C5_MENNOTA"))
			aPos:= {}

			For nLts:=1 to Len(_cLinha)
				If SubStr(_cLinha,nLts,1) == '|'
					Aadd(aPos,nLts)
				EndIf
			Next
			//Alterado Leonardo ROBES
		/*If Len(_cLinha) > 0
			cMensag1	:= SubStr(Alltrim(_cLinha),1,(aPos[1]-1))//Alltrim(POSICIONE("SC5",1,XFILIAL("SC5")+SE1->E1_PEDIDO,"C5_MENNOTA")) //Alltrim(POSICIONE("SC5",1,XFILIAL("SC5")+SE1->E1_PEDIDO,"C5_MENNOTA"))+ IIF(Empty(SE1->E1_PARCELA),""," - PARCELA "+ Alltrim(SE1->E1_PARCELA)) //"PROSIMULADOR - "   
		ELSE
			cMensag1	:= Alltrim(POSICIONE("SC5",1,XFILIAL("SC5")+SE1->E1_PEDIDO,"C5_MENNOTA")) //Alltrim(POSICIONE("SC5",1,XFILIAL("SC5")+SE1->E1_PEDIDO,"C5_MENNOTA"))+ IIF(Empty(SE1->E1_PARCELA),""," - PARCELA "+ Alltrim(SE1->E1_PARCELA)) //"PROSIMULADOR - "   		
		ENDIF
	ELSE
		cMensag1	:= Alltrim(POSICIONE("SC5",1,XFILIAL("SC5")+SE1->E1_PEDIDO,"C5_MENNOTA")) //Alltrim(POSICIONE("SC5",1,XFILIAL("SC5")+SE1->E1_PEDIDO,"C5_MENNOTA"))+ IIF(Empty(SE1->E1_PARCELA),""," - PARCELA "+ Alltrim(SE1->E1_PARCELA)) //"PROSIMULADOR - "   
	*/
	EndIf
//	cMensag2	:= "SR.(A) CAIXA, APำS O VENCIMENTO, COBRAR MULTA DE " +Alltrim(STR(aDadBco[11])) + "% MAIS JUROS DE " + AllTrim(Transform(aDadBco[10],"@E 9.999%")) + " AO DIA"
//	cMensag3	:= "NรO CONCEDER DESCONTO."
	cMensag1 := "MULTA APOS "+dtoc(SE1->E1_VENCREA)+" R$"+alltrim(str(SE1->E1_SALDO*2/100,14,2))
	cMensag2 := "COMISSAO PERMANENCIA AO DIA R$"+alltrim(str(SE1->E1_SALDO*2/100/30,14,2))
	IF ALLTRIM(MV_PAR13) == "130005703" .OR. ALLTRIM(MV_PAR13) == "130005033"
		cMensag3 := "REFERENTE A ROYALTIES "+Alltrim(STRZERO(Month(SE1->E1_VENCREA)-1,2))+"/"+Alltrim(Strzero(Year(SE1->E1_VENCREA),4))
	ELSEIF ALLTRIM(MV_PAR13) == "130006261"
		cMensag3 := "REFERENTE FUNDO DE PROMOCAO "+Alltrim(STRZERO(Month(SE1->E1_VENCREA)-1,2))+"/"+Alltrim(Strzero(Year(SE1->E1_VENCREA),4))
	ENDIF

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Alimenta array com os dados do tํtulo ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aDadTit[1]	:= SE1->E1_PREFIXO		// [1] Prefixo do Tํtulo
	aDadTit[2]	:= SE1->E1_NUM			// [2] N๚mero do Tํtulo
	aDadTit[3]	:= SE1->E1_PARCELA		// [3] Parcela do Tํtulo
	aDadTit[4]	:= SE1->E1_TIPO			// [4] Tipo do tํtulo
	aDadTit[5]	:= SE1->E1_EMISSAO		// [5] Data de Emissใo do tํtulo
	IF EMPTY(SE1->E1_BAIXA)
		aDadTit[6]	:= IF(SE1->E1_VENCTO>dDataBase,SE1->E1_VENCTO,dDataBase)//SE1->E1_VENCTO		// [6] Data de Vencimento do Tํtulo
		aDadTit[7]	:= IF(SE1->E1_VENCREA>dDataBase,SE1->E1_VENCREA,dDataBase)//SE1->E1_VENCREA		// [7] Data de Vencimento Real
	ELSE
		aDadTit[6]	:= SE1->E1_VENCTO		// [6] Data de Vencimento do Tํtulo
		aDadTit[7]	:= SE1->E1_VENCREA		// [7] Data de Vencimento Real
	ENDIF
	aDadTit[8]	:= nSaldo//IF(!EMPTY(SE1->E1_BAIXA),SE1->E1_VALOR,nSaldo)				// [8] Valor Lํquido do Tํtulo
	aDadTit[9]	:= aBarra[4]			// [9] C๓digo do Barras Formatado
	aDadTit[10]	:= cCarteira			// [10]Carteira de Cobran็a
	aDadTit[11]	:= cMensag1				// [11]1a. Linha de Mensagem diversas
	aDadTit[12]	:= cMensag2				// [11]2a. Linha de Mensagem diversas
	aDadTit[13]	:= cMensag3				// [11]3a. Linha de Mensagem diversas
	aDadTit[14]	:= cMensag4				// [11]4a. Linha de Mensagem diversas
	aDadTit[15]	:= cMensag5				// [11]5a. Linha de Mensagem diversas
	aDadTit[16]	:= cMensag6				// [11]6a. Linha de Mensagem diversas
	IF EMPTY(SE1->E1_BAIXA)
		aDadTit[17]	:= U_CALCMORA(aDadTit[8],CalcTxJr(aDadTit[6]),"BOL")				// [17] Multa Mora
	ELSE
		aDadTit[17]	:= 0
	ENDIF

	If aDadTit[17] > 0
		aDadTit[8]	:= nSaldo+aDadTit[17]
		aBarra	:= GetBarra(aDadBco[1],aDadBco[3],aDadBco[4],aDadBco[5],aDadBco[6],cCarteira,cNumDoc,aDadTit[8],aDadTit[7],SEE->EE_CODEMP)
		aDadTit[9]	:= aBarra[4]			// [9] C๓digo do Barras Formatado
	Endif

EndIf

RestArea(aAreaAtu)

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ TCImpBol33 ณ Efetua a impressใo do boleto bancแrio(Santander)           บฑฑ
ฑฑบ             ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 13.12.14 ณ Fabio Jadao Caires                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpO1 = Objeto print                                                    บฑฑ
ฑฑบ             ณ ExpA1 = Array com os dados da Empresa                                   บฑฑ
ฑฑบ             ณ ExpA2 = Array com os dados do Banco                                     บฑฑ
ฑฑบ             ณ ExpA3 = Array com os dados do Tํtulo                                    บฑฑ
ฑฑบ             ณ ExpA4 = Array com os dados do Cliente                                   บฑฑ
ฑฑบ             ณ ExpA5 = Array com os dados do C๓digo de Barras                          บฑฑ
ฑฑบ             ณ ExpN1 = Tipo de configura็ใo a ser utilizado (1=Polegadas/2=Centํmetros)บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TCImpBol33(oPrint,aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp)

	Local oFont8
	Local oFont10
	Local oFont11c
	Local oFont14
	Local oFont14n
	Local oFont15
	Local oFont15n
	Local oFont16n
	Local oFont20
	Local oFont21
	Local oFont24
	Local nLin			:= 0
	Local nLoop			:= 0
	Local cLinha1		:= ""
	Local cLinha2		:= ""
	Local cLinha3		:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta string com os textos do boleto atraves dos   ณ
//ณ parametros MV_DSCBLT1, MV_DSCBLT2 e MV_DSCBLT3     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(SA6->A6_TELEX)
		cLinha1 := GetNewPar("ES_DSCBLT1","")
		cLinha2 := GetNewPar("ES_DSCBLT2","")
		cLinha3 := GetNewPar("ES_DSCBLT3","")
	Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define as fontes a serem utilizadas ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//Size,   ,bold
	oFont8		:= TFont():New("Arial",			9,12,.T.,.F.,5,.T.,5,.T.,.F.)	// Cedente
	oFont10		:= TFont():New("Arial",			9,14,.T.,.T.,5,.T.,5,.T.,.F.)	// Recibo do sacado
	oFont11c	:= TFont():New("Arial",			9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14		:= TFont():New("Arial",			9,14,.T.,.T.,5,.T.,5,.T.,.F.)	// Nome do banco
	oFont14n	:= TFont():New("Arial",			9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15		:= TFont():New("Arial",			9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15n	:= TFont():New("Arial",			9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n	:= TFont():New("Arial",			9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont20		:= TFont():New("Arial",			9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont21		:= TFont():New("Arial",			9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont21n	:= TFont():New("Arial",			9,12,.T.,.T.,5,.T.,5,.T.,.F.)	// Nome do banco
	oFont24		:= TFont():New("Arial",			9,21,.T.,.F.,5,.T.,5,.T.,.F.)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicia uma nova pแgina ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrint:StartPage()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define o Primeiro Bloco - Logotipo da Empresa + Texto Fixo      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrint:Say (nLin+525,0800,cLinha1 , oFont21n)
	oPrint:Say (nLin+600,0800,cLinha2 , oFont21)
	oPrint:Say (nLin+650,0800,cLinha3 , oFont21n)

	oPrint:SayBitMap(nLin+0120,0100,"\system\Logoret.bmp",700,300)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Pontilhado separador ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nLin+= 001
	For nLoop := 100 to 2300 Step 50
		oPrint:Line(nLin+0500, nLoop,nLin+0500, nLoop+30)							// Linha pontilhada
	Next nI

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define o Segundo Bloco - Recibo do Sacado ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oPrint:Line (nLin+0610,0100,nLin+0610,2300)										// Quadro
	oPrint:Line (nLin+0610,0500,nLin+0540,0500)										// Quadro
	oPrint:Line (nLin+0610,0710,nLin+0540,0710)										// Quadro


	If !Empty(aDadBco[9])
		//oPrint:SayBitMap(nLin+0520,0100,AllTrim(GetSrvProfString("StartPath",""))+aDadBco[9],200,080)													// Logotipo do Banco
		oPrint:SayBitMap(nLin+0520,0100,"\system\logo_santander.jpg",300,080)													// Logotipo do Banco
	Else
		oPrint:Say  (nLin+0590,0100,	aDadBco[7],											oFont14)	// Nome do Banco
	EndIf

	oPrint:Say  (nLin+0590,0513,	aDadBco[1]+"-"+aDadBco[2],						oFont14)	// Numero do Banco + Dํgito
//oPrint:Say  (nLin+0550,1900,	"Recibo do Sacado",								oFont10)	// Texto Fixo
	oPrint:Say  (nLin+0550,0750,	AllTrim(aDadEmp[1])+" - CNPJ: "+Transform(aDadEmp[9], "@R 99.999.999/9999-99"),								oFont10)	// Texto Fixo
	oPrint:Say  (nLin+0590,0750,	AllTrim(aDadEmp[2])+" - "+AllTrim(aDadEmp[3])+" - "+AllTrim(aDadEmp[4])+" - "+AllTrim(aDadEmp[5])+" - CEP: "+Transform(aDadEmp[6], "@R 99999-999"),								oFont10)	// Texto Fixo

	oPrint:Line (nLin+0710,1800,nLin+0710,2300)										// Quadro
	oPrint:Line (nLin+0800,1800,nLin+0800,2300)										// Quadro
	oPrint:Line (nLin+0890,1800,nLin+0890,2300)										// Quadro
	oPrint:Line (nLin+0980,1800,nLin+0980,2300)										// Quadro

	oPrint:Line (nLin+0610,1800,nLin+710,1800)										// Quadro novo vencimento
	oPrint:Line (nLin+0860,1800,nLin+960,1800)										// Quadro
	oPrint:Line (nLin+0800,1800,nLin+860,1800)										// Quadro
	oPrint:Line (nLin+0710,1800,nLin+860,1800)										// Quadro
	oPrint:Line (nLin+0960,1800,nLin+1070,1800)										// Quadro


	oPrint:Say  (nLin+0650,0100,	"Recibo do Sacado",										oFont8)		// Texto Fixo
/*If aDadBco[1] <> SEE->EE_CODIGO
	oPrint:Say  (nLin+0780,0100,	aDadBco[7],									oFont10)	// "BANCO SAFRA"
Else
	oPrint:Say  (nLin+0780,0100,	AllTrim(aDadEmp[1])+" - CNPJ: "+Transform(aDadEmp[9], "@R 99.999.999/9999-99")	,oFont10)	// Nome + CNPJ
EndIf*/

oPrint:Say  (nLin+0650,1810,	"Vencimento",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+0690,1900,StrZero(Day(aDadTit[6]),2) +"/"+;
StrZero(Month(aDadTit[6]),2) +"/"+;
StrZero(Year(aDadTit[6]),4),													oFont10)	// Vencimento

oPrint:Say  (nLin+1100,0100,	"Sacado",										oFont8)		// Texto Fixo
oPrint:Say  (nLin+1130,0100, aDadCli[3]	,										oFont10)	// Data do Documento*/
If aDadCli[6] = "J"
	oPrint:Say  (nLin+1160,0100,	"CNPJ: "+Transform(aDadCli[4],"@R 99.999.999/9999-99"),;
	oFont10)	// CGC
Else
	oPrint:Say  (nLin+1160,0100,	"CPF: "+Transform(aDadCli[4],"@R 999.999.999-99"),;
	oFont10)	// CPF
EndIf


oPrint:Say  (nLin+0830,1810,	"Nro.Documento",								oFont8)		// Texto Fixo
oPrint:Say  (nLin+0870,1900,	aDadTit[1]+aDadTit[2]+aDadTit[3],				oFont10)	// Prefixo + Numero + Parcela

oPrint:Say  (nLin+0750,1810,	"Nosso N๚mero",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+0790,1900,	aBarra[4],										oFont10)	// Nosso N๚mero

oPrint:Say  (nLin+0930,1810,	"Ag๊ncia/C๓digo Cedente",						oFont8)		// Texto Fixo
oPrint:Say  (nLin+0970,1900,	aDadBco[15],									oFont10)	// Nosso N๚mero

oPrint:Say  (nLin+1010,1810,	"Valor Documento",								oFont8)		// Texto Fixo
oPrint:Say  (nLin+1050,1900,	Transform(aDadTit[8],"@E 9999,999,999.99"),		oFont10)	// Nosso N๚mero
//oPrint:Say  (nLin+880,0100,	"Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do cedente)",;
//oFont8)

// Segundo bloco
oPrint:Line (nLin+1070,0100,nLin+1070,2300)													// Quadro

// Texto Fixo
oPrint:Say  (nLin+1100,1750,"Autentica็ใo Mecโnica",		oFont10)

//	oPrint:Say  (nLin+1250,0100,"Recebimento atrav้s do cheque nบ                          do Banco" ,	oFont10)
//	oPrint:Say  (nLin+1290,0100,"Esta quita็ใo s๓ terแ validade ap๓s pagamento do cheque",  			oFont10)
//	oPrint:Say  (nLin+1330,0100, "pelo banco sacado: ",													oFont10)
//	oPrint:Say  (nLin+1410,0100,	"Sacador/Avalista",													oFont8)		// Texto Fixo
If aDadBco[1] <> SEE->EE_CODIGO
	oPrint:Say  (nLin+1450, 100, AllTrim(aDadEmp[1])+" - CNPJ: "+Transform(aDadEmp[9], "@R 99.999.999/9999-99"), oFont10 )	// Sacador, quando for correspondente bancario
EndIf

//oPrint:Line (nLin+1420,0100,nLin+1420,2300)															// Quadro

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Pontilhado separador ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLin := 1210
For nLoop := 100 to 2300 Step 50
	oPrint:Line(nLin+0500, nLoop,nLin+0500, nLoop+30)												// Linha pontilhada
Next nI

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define o Segundo Bloco - Recibo do Sacado ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Line (nLin+0610,0100,nLin+0610,2300)															// Quadro
oPrint:Line (nLin+0610,0500,nLin+0540,0500)															// Quadro
oPrint:Line (nLin+0610,0710,nLin+0540,0710)															// Quadro

If !Empty(aDadBco[9])
	oPrint:SayBitMap(nLin+0520,0100,"\system\logo_santander.jpg",300,080)													// Logotipo do Banco
Else
	oPrint:Say  (nLin+0590,0100,	aDadBco[7],											oFont14)	// Nome do Banco
EndIf
oPrint:Say  (nLin+0590,0513,	aDadBco[1]+"-"+aDadBco[2],								oFont15n)	// Numero do Banco + Dํgito
oPrint:Say  (nLin+0590,0755,	aBarra[2],												oFont24)	// Linha Digitavel do Codigo de Barras

oPrint:Line (nLin+0700,0100,nLin+0700,2300)															// Quadro
oPrint:Line (nLin+0790,0100,nLin+0790,2300)															// Quadro
oPrint:Line (nLin+0850,0100,nLin+0850,2300)															// Quadro
oPrint:Line (nLin+0910,0100,nLin+0910,2300)															// Quadro

oPrint:Line (nLin+0790,1000,nLin+0790,1000)															// Quadro
oPrint:Line (nLin+0790,1390,nLin+0790,1390)															// Quadro

oPrint:Line (nLin+0610,1800,nLin+1220,1800)

oPrint:Line (nLin+0790,0500,nLin+0850,0500)															// Quadro Carteira
oPrint:Line (nLin+0850,0750,nLin+0910,0750)															// Quadro Especie
oPrint:Line (nLin+0790,1000,nLin+0910,1000)															// Quadro
oPrint:Line (nLin+0790,1300,nLin+0850,1300)															// Quadro
oPrint:Line (nLin+0790,1480,nLin+0910,1480)															// Quadro


oPrint:Line (nLin+0970,1800,nLin+0970,2300)															// Quadro
oPrint:Line (nLin+1040,1800,nLin+1040,2300)															// Quadro
oPrint:Line (nLin+1100,1800,nLin+1100,2300)															// Quadro
oPrint:Line (nLin+1160,1800,nLin+1160,2300)															// Quadro

oPrint:Line (nLin+1220,0100,nLin+1220,2300)															// Quadro


oPrint:Say  (nLin+0630,0100,	"Local de Pagamento",										oFont8)	// Texto Fixo
oPrint:Say  (nLin+0670,0100,	"PAGAR PREFERENCIALMENTE NO BANCO SANTANDER.",	oFont10)// Texto Fixo
oPrint:Say  (nLin+0630,1810,	"Vencimento",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+0670,1900,	StrZero(Day(aDadTit[6]),2)+"/"+;
StrZero(Month(aDadTit[6]),2)+"/"+;
StrZero(Year(aDadTit[6]),4),															oFont10)	// Vencimento

oPrint:Say  (nLin+0725,0100,	"Cedente",												oFont8)		// Texto Fixo

If aDadBco[1] <> SEE->EE_CODIGO
	oPrint:Say  (nLin+0765,0100,	aDadBco[7],											oFont10)	// "BANCO SAFRA"
Else
	oPrint:Say  (nLin+0765,0100,	AllTrim(aDadEmp[1])+" - CNPJ: "+Transform(aDadEmp[9], "@R 99.999.999/9999-99")	,oFont10)	// Nome + CNPJ
EndIf

oPrint:Say  (nLin+0725,1810,	"Ag๊ncia/C๓digo Cedente",								oFont8)		// Texto Fixo
oPrint:Say  (nLin+0765,1900,	aDadBco[15]				,								oFont10)	// Agencia + C๓d.Cedente + Dํgito
oPrint:Say  (nLin+0810,0100,	"Data do Documento",									oFont8)		// Texto Fixo
oPrint:Say	(nLin+0840,0100, 	StrZero(Day(aDadTit[5]),2)+"/"+ ;
StrZero(Month(aDadTit[5]),2)+"/"+ ;
StrZero(Year(aDadTit[5]),4),		 													oFont10)	// Vencimento

oPrint:Say  (nLin+0810,0505,	"Nro.Documento",										oFont8)		// Texto Fixo
oPrint:Say  (nLin+0840,0605,	aDadTit[1]+aDadTit[2]+aDadTit[3],						oFont10)	// Prefixo + Numero + Parcela

oPrint:Say  (nLin+0810,1005,	"Esp้cie Doc.",						   					oFont8)		// Texto Fixo
oPrint:Say  (nLin+0840,1050,	aDadBco[14],											oFont10)	// Tipo do Titulo

oPrint:Say  (nLin+0810,1305,	"Aceite",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+0840,1400,	"N",													oFont10)	// Texto Fixo

oPrint:Say  (nLin+0810,1485,	"Data do Processamento",								oFont8)		// Texto Fixo
oPrint:Say  (nLin+0840,1550,	StrZero(Day(dDataBase),2)+"/"+ ;
StrZero(Month(dDataBase),2)+"/"+ ;
StrZero(Year(dDataBase),4),																oFont10)	// Data impressao

oPrint:Say  (nLin+0810,1810,	"Nosso N๚mero",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+0840,1900,	aBarra[4],												oFont10)	// Nosso N๚mero
                                                                                                                 
oPrint:Say  (nLin+0875,0100,	"Carteira", 											oFont8)		// Texto Fixo
//oPrint:Say  (nLin+0875,0100,	"Uso do Banco",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+0905,0150,	"COBRANCA SIMPLES - RCR",											oFont10)	// Texto Fixo

//oPrint:Say  (nLin+0875,0505,	"Carteira",												oFont8)		// Texto Fixo
//oPrint:Say  (nLin+0905,0555,	aDadTit[10],											oFont10)

oPrint:Say  (nLin+0875,0755,	"Esp้cie",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+0905,0805,	"REAL",													oFont10)	// Texto Fixo

oPrint:Say  (nLin+0875,1005,	"Quantidade",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+0875,1485,	"Valor",												oFont8)		// Texto Fixo

oPrint:Say  (nLin+0875,1810,	"Valor do Documento",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+0905,1900,	Transform(aDadTit[8]	, "@E 9999,999,999.99"),			oFont10)	// Valor do Documento

oPrint:Say  (nLin+0930,0100,	"Instru็๕es (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do cedente)",;
oFont8)		// Texto Fixo
oPrint:Say  (nLin+0980,0100,	aDadTit[11],											oFont10)	// 1a. Linha Instru็ใo
oPrint:Say  (nLin+1020,0100,	aDadTit[12],											oFont10)	// 2a. Linha Instru็ใo
oPrint:Say  (nLin+1060,0100,	aDadTit[13],											oFont10)	// 3a. Linha Instru็ใo
oPrint:Say  (nLin+1100,0100,	aDadTit[14],											oFont10)	// 4a. Linha Instru็ใo
oPrint:Say  (nLin+1140,0100,	aDadTit[15],											oFont10)	// 5a. Linha Instru็ใo
oPrint:Say  (nLin+1180,0100,	aDadTit[16],											oFont10)	// 6a. Linha Instru็ใo

oPrint:Say  (nLin+0930,1810,	"(-)Desconto/Abatimento",								oFont8)		// Texto Fixo
oPrint:Say  (nLin+0995,1810,	"(-)Outras Dedu็๕es",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+1060,1810,	"(+)Mora/Multa",										oFont8)		// Texto Fixo
//oPrint:Say  (nLin+1090,1900,	Transform(aDadTit[17], "@E 9999,999,999.99")		,	oFont10)	// Valor Multa/Mora
oPrint:Say  (nLin+1120,1810,	"(+)Outros Acr้scimos",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+1185,1810,	"(=)Valor Cobrado",										oFont8)		// Texto Fixo

oPrint:Say  (nLin+1245,0100,	"Sacado",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+1260,0220,	" ("+aDadCli[1]+"-"+aDadCli[2]+") "+aDadCli[3],			oFont10)	// Nome Cliente + C๓digo

If aDadCli[6] = "J"
	oPrint:Say  (nLin+1260,1850,	"CNPJ: "+Transform(aDadCli[4],"@R 99.999.999/9999-99"),;
	oFont10)	// CGC
Else
	oPrint:Say  (nLin+1260,1850,	"CPF: "+Transform(aDadCli[4],"@R 999.999.999-99"),;
	oFont10)	// CPF
EndIf

oPrint:Say  (nLin+1310,0220,	Alltrim(aDadCli[7])+" "+AllTrim(aDadCli[8]),			oFont10)	// Endere็o
oPrint:Say  (nLin+1350,0220,	Transform(aDadCli[11],"@R 99999-999")+" - "+;
AllTrim(aDadCli[9])+" - "+AllTrim(aDadCli[10]),											oFont10)	// CEP + Cidade + Estado

oPrint:Say  (nLin+1350,1850,	aBarra[4],												oFont10)	// Carteira + Nosso N๚mero

oPrint:Line (nLin+1370,0100,nLin+1370,2300)															// Quadro

oPrint:Say  (nLin+1395,0100,	"Sacador/Avalista",										oFont8)		// Texto Fixo
If aDadBco[1] <> SEE->EE_CODIGO
	oPrint:Say  (nLin+1410, 100, AllTrim(aDadEmp[1])+" - CNPJ: "+Transform(aDadEmp[9], "@R 99.999.999/9999-99"), oFont10 )	// Sacador, quando for correspondente bancario
EndIf


oPrint:Say  (nLin+1420,1500,	"Autentica็ใo Mecโnica - Ficha de Compensa็ใo",			oFont8)		// Texto Fixo


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Calculos para definir o centimetro de impressใo por modelo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nCalcPix := 1        //1 Centimetro
nClcPixV := 1        //1 Centimetro

oPrint:Cmtr2Pix(@nCalcPix,@nClcPixV,.F.) //Retorna o valor de centimetro em pixel da impressora

nPix2Cm := ( nLin + 5900 ) / nCalcPix   //Transforma os pixel em centimetro Horizontal
nPix2CmV := 250 / nClcPixV     //Transforma os pixel em centimetro Vertical

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do codigo de barras ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:FWMSBAR("INT25",nPix2Cm,nPix2CmV, aBarra[1],oPrint,.F.,Nil,.T.,0.0225,1.5,.F.,Nil,NIL,.F.,1,1,.F.)

oPrint:EndPage() // Finaliza a pแgina

//FErase("C:\"+aDadBco[9])

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ CriaSx1  ณ Verifica e cria um novo grupo de perguntas com base nos      บฑฑ
ฑฑบ             ณ          ณ parโmetros fornecidos                                        บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Solicitante ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 12.12.14 ณ Fabio Jadao Caires                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ 99.99.99 ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpA1 = array com o conte๚do do grupo de perguntas (SX1)                บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99/99/99 - Consultor - Descricao da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSx1(aRegs)

	Local aAreaAtu	:= GetArea()
	Local aAreaSX1	:= SX1->(GetArea())
	Local nJ		:= 0
	Local nY		:= 0

	dbSelectArea("SX1")
	dbSetOrder(1)

	For nY := 1 To Len(aRegs)
		If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
			RecLock("SX1",.T.)
			For nJ := 1 To FCount()
				If nJ <= Len(aRegs[nY])
					FieldPut(nJ,aRegs[nY,nJ])
				EndIf
			Next nJ
			MsUnlock()
		EndIf
	Next nY

	RestArea(aAreaSX1)
	RestArea(aAreaAtu)

Return(Nil)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ GetBarra ณ Cแlcula o c๓digo de barras, linha digitแvel e dํgito do      บฑฑ
ฑฑบ             ณ          ณ nosso n๚mero                                                 บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 12.12.14 ณ Fabio Jadao Caires                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpC1 = C๓digo do Banco                                                 บฑฑ
ฑฑบ             ณ ExpC2 = N๚mero da Ag๊ncia                                               บฑฑ
ฑฑบ             ณ ExpC3 = Dํgito da Ag๊ncia                                               บฑฑ
ฑฑบ             ณ ExpC4 = N๚mero da Conta Corrente                                        บฑฑ
ฑฑบ             ณ ExpC5 = Dํgito da Conta Corrente                                        บฑฑ
ฑฑบ             ณ ExpC6 = Carteira                                                        บฑฑ
ฑฑบ             ณ ExpC7 = Nosso N๚mero sem dํgito                                         บฑฑ
ฑฑบ             ณ ExpN1 = Valor do Tํtulo                                                 บฑฑ
ฑฑบ             ณ ExpD1 = Data de Vencimento                                              บฑฑ
ฑฑบ             ณ ExpC8 = N๚mero do Contrato                                              บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ ExpL1 = .T. montou os arrays corretamento, .F. nใo montou os arrays     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ Os arquivos devem estar posicionados SE1, SA1, SEE, SA6                 บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetBarra(cBanco,cAgencia,cDigAgencia,cConta,cDigConta,cCarteira,cNNum,nValor,dVencto,cContrato)

	Local cValorFinal	:= StrZero(Int(NoRound(nValor*100)),10)
	Local cDvCB			:= 0
	Local cDv			:= 0
	Local cNN			:= ""
	Local cNNForm		:= ""
	Local cRN			:= ""
	Local cCB			:= ""
	Local cS			:= ""
	Local cDvNN			:= ""
	Local cFator		:= StrZero(dVencto - CToD("07/10/97"),4)
	Local cCpoLivre		:= Space(25)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ                 Definicao do NOSSO NฺMERO E CAMPO LIVRE                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//20-20	- (01) Fixo “9”
//21-27 - (07) C๓digo do cedente padrใo Santander
//28-40 - (13) Nosso N๚mero
//41-41 - (01) IOS – Seguradoras (Se 7% informar 7. Limitado a 9%)
//             Demais clientes usar 0 (zero)
//42-44 - (03) Tipo de Modalidade Carteira
//             101-Cobran็a Simples Rแpida COM Registro
//             102- Cobran็a simples – SEM Registro
//             201- Penhor Rแpida com Registro

	cS			:= cNNum
	cDvNN		:= Mod11033( cS )
	cNN			:= Alltrim(cS) + Alltrim(cDvNN)
	cNNForm		:= Alltrim(cS) + "-" + cDvNN
	cCpoLivre	:= "9" + LEFT(AllTrim(SEE->EE_CODEMP), 7) + StrZero(val(Alltrim(cNN)),13) + "0" + cCarteira

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ                  Definicao do DอGITO CODIGO DE BARRAS                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cS		:= cBanco+"9"+cFator+cValorFinal+cCpoLivre
	cDvCB	:= Modulo11(cS)
	cCB		:= cBanco+"9"+cDVCB+cFator+cValorFinal+cCpoLivre

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ                  Definicao da LINHA DIGITมVEL                           ณ
//ณ Campo 1       Campo 2        Campo 3        Campo 4   Campo 5           ณ
//ณ AAABC.CCCCX   CCCCC.CCCCCY   CCCCC.CCCCCZ   W	      UUUUVVVVVVVVVV    ณ
//ณฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤณ
//ณ AAA                       = C๓digo do Banco na Cโmara de Compensa็ใo    ณ
//ณ B                         = C๓digo da Moeda, sempre 9                   ณ
//ณ CCCCCCCCCCCCCCCCCCCCCCCCC = Campo Livre                                 ณ
//ณ X                         = Digito Verificador do Campo 1               ณ
//ณ Y                         = Digito Verificador do Campo 2               ณ
//ณ Z                         = Digito Verificador do Campo 3               ณ
//ณ W                         = Digito Verificador do Codigo de Barras      ณ
//ณ UUUU                      = Fator de Vencimento                         ณ
//ณ VVVVVVVVVV                = Valor do Tํtulo                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CALCULO DO DอGITO VERIFICADOR DO CAMPO 1                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cS		:= cBanco + "9"+Substr(cCpoLivre,1,5)
	cDv		:= modulo10(cS)
	cRN1	:= SubStr(cS, 1, 5) + "." + SubStr(cS, 6, 4) + cDv

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CALCULO DO DอGITO VERIFICADOR DO CAMPO 2                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cS		:= Substr(cCpoLivre,6,10)
	cDv		:= modulo10(cS)
	cRN2	:= cS + cDv
	cRN2	:= SubStr(cS, 1, 5) + "." + Substr(cS, 6, 5) + cDv

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CALCULO DO DอGITO VERIFICADOR DO CAMPO 3                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cS		:= Substr(cCpoLivre,16,10)
	cDv		:= modulo10(cS)
	cRN3	:= SubStr(cS, 1, 5) + "." + Substr(cS, 6, 5) + cDv

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CALCULO DO CAMPO 4                                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cRN4	:= cDvCB

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CALCULO DO CAMPO 5                                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cRN5	:= cFator + cValorFinal

	cRN		:= cRN1 + " " + cRN2 + ' '+ cRN3 + ' ' + cRN4 + ' ' + cRN5

Return({cCB,cRN,cNNum,cNNForm,cDvNN})


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ Modulo10 ณ Efetua o cแlculo do dํgito veririficador com base 10         บฑฑ
ฑฑบ             ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 12.12.14 ณ Fabio Jadao Caires                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpC1 = String com o c๓digo a ser calculado                             บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ ExpC1 = String com o Dํgito Verificador                                 บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Modulo10(cData)

	Local L	:= Len(cData)
	Local D	:= 0
	Local P := 0
	Local B	:= .T.

	While L > 0
		P := Val(SubStr(cData, L, 1))

		If 	(B)
			P := P * 2

			If 	P > 9
				P := P - 9
			EndIf

		EndIf

		D := D + P
		L := L - 1
		B := !B
	EndDo

	D := 10 - (Mod(D,10))

	If 	D = 10
		D := 0
	EndIf

Return(AllTrim(Str(D,1)))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ Modulo11 ณ Efetua o cแlculo do dํgito veririficador com base 11         บฑฑ
ฑฑบ             ณ          ณ                                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 23.01.07 ณ Almir Bandina                                                บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpC1 = String com o c๓digo a ser calculado                             บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ ExpC1 = String com o Dํgito Verificador                                 บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99.99.99 - Consultor - Descri็ใo da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Modulo11(cData)

	Local L	:= Len(cData)
	Local D	:= 0
	Local P	:= 1

	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If 	P = 9
			P := 1
		EndIf
		L := L - 1
	EndDo

	D := 11 - (mod(D,11))

	If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
		D := 1
	EndIf

Return(AllTrim(Str(D,1)))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTOPCONCNABบAutor  ณMicrosiga           บ Data ณ  01/14/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function Mod11033(cData)

	Local nResult	:= 0
	Local nSoma		:= 0
//Local cDc		:= ""
	Local i			:= 0
//Local nTam		:= 13
	Local nDc		:= 0
	Local nAlg		:= 2
	Local nCalNum	:= space(13)

	nCalNum:= AllTrim(cData)

	For i := Len(nCalNum) To 1 Step -1

		nSoma   := Val(Substr(nCalNum,i,1))*nAlg
		nResult := nResult + nSoma
		nAlg    := nAlg + 1

		If 	nAlg > 9
			nAlg := 2
		Endif

	Next i

	nDC  := MOD(nResult,11)

	IF 	nDC == 10
		cDig := "1"

	ElseIf nDC == 1 .or. nDC == 0
		cDig := "0"

	Else
		cDig := STR(11 - nDC,1)

	EndIF

Return(Alltrim(cDig))



	*---------------------------------------------------------------*
User Function CALCMORA(_nSaldo,_nTaxa,_cTpRet)
	*---------------------------------------------------------------*
	Local _xRet := 0//""

	If _nTaxa <=0
		Return  0
	Endif

	_xRet := Round(_nSaldo*0.02	,2)
	_nSaldo := _nSaldo+(_nSaldo*0.02)

	If 	_cTpRet == "BOL"
		//_xRet := AllTrim(Transform( Round( ( _nSaldo * (_nTaxa/100) ) , 2), "@E 999,999,999.99"))
		_xRet +=  Round( ( _nSaldo * (_nTaxa/100) ) , 2)
	ElseIf _cTpRet == "CNAB"
		//_xRet:= STRZERO(Round( ( _nSaldo * (_nTaxa/100) ) , 2) * 100 ,13)
		_xRet+= Round( ( _nSaldo * (_nTaxa/100) ) , 2) * 100
	Endif

Return(_xRet)


	*-----------------------------------------------------------------------------------------*
USER FUNCTION BOLST(_cDirPDF)
	*-----------------------------------------------------------------------------------------*
	Local _lRet := .T.
	Private aLst := {}
	Private Titulo := ""
	Default _cDirPDF := GetSrvProfString("Startpath","")+"boletos\"//"C:\TEMP\"//SUPERGETMV("MV_XPDFDIR")
//SE1->(DBGOTO(7751))

	_dDataVencto := SE1->E1_VENCREA

	IF dDataBase > _dDataVencto
		_dDataVencto := dDataBase
	Endif
//Conout("Inicio --->"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA)
	SEA->(DBSETORDER(1))
	IF !SEA->(DBSEEK(xFILIAL("SEA")+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO	))
		Conout("Bordero nao encontrado --->"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA)
		Return .F.
	ENDIF
	SEE->(DBSETORDER(1))
	IF !SEE->(DBSEEK(xFILIAL("SEE")+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON))
		Conout("Banco nao Encontrado --->"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA)
		Return .F.
	ENDIF
	mv_par11 := SEA->EA_PORTADO//_cBanco
	mv_par12 := SEA->EA_AGEDEP//_cAgencia
	mv_par13 := SEA->EA_NUMCON//_cConta
	mv_par14 := SEE->EE_SUBCTA
	mv_par16 := 2
	mv_par18 := 2
	mv_par15 := 1

	aAdd(aLst, {	.T.		,;
		SE1->E1_PREFIXO,;
		SE1->E1_NUM	,;
		SE1->E1_PARCELA,;
		SE1->E1_TIPO	,;
		SE1->E1_CLIENTE,;
		SE1->E1_LOJA	,;
		SE1->E1_NOMCLI	,;
		SE1->E1_EMISSAO,;
		SE1->E1_VENCTO	,;
		_dDataVencto,;
		SE1->E1_VALOR	,;
		SE1->E1_PORTADO,;
		SE1->(RECNO()) 	,;
		SE1->E1_NUMBCO 	})


	_lRet := MontaPdf(.T.,_cDirPDF)
	Conout("*** Fim ***")
Return _lRet
	*------------------------------------------------*
Static Function CalcTxJr(_dDtVenc)
	*------------------------------------------------*
	_nRet := 0
	IF SE1->E1_VENCREA < _dDtVenc
		_nRet := (0.033*( _dDtVenc - SE1->E1_VENCREA))
	EndIf

Return _nRet
