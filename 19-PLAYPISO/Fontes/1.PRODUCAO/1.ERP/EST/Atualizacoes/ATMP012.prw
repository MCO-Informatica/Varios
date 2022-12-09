#INCLUDE "RWMAKE.CH"
#include "topconn.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAEST002   บAutor  ณAlexandre Sousa     บ Data ณ  02/13/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTemporario para atualizar com ajustes valorizados o custo   บฑฑ
ฑฑบ          ณdos produtos no estoque.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico clientes INSIGHT.                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AEST002()

	Local oProcess
	
	Private n_ate := 20

	If !msgYesNo("Essa Rotina irแ atualizar atrav้s de movimenta็๕es de estoque o custo de todos os produtos com base no pre็o da ultima compra registrada no produto B1_UPRC. ATENวรO antes de rodar essa rotina fa็a um backup dos arquivos SD3 e SB2. Deseja continuar? ", "A T E N ว ร O")
		Return
	EndIf
	
	Processa({|| Conf1irma() },"Processando... com QTD > 0 ","AJUSTE DE CUSTO")

//	Processa({|| Conf2irma() },"Processando... com QTD < 0 ","AJUSTE DE CUSTO")

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAEST002   บAutor  ณMicrosiga           บ Data ณ  02/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz os ajustes necessarios no SD3                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Conf1irma()

	Local c_Query	:= ''
	Local n_reg		:= 0

	c_Query := " select     B2_VATU1, B2_FILIAL, B1_UM, B2_COD, B2_LOCAL, B2_QATU, B1_UPRC, B2_CM1, B2_VATU1/CASE WHEN B2_QATU = 0 THEN 1 ELSE B2_QATU END as CUNIT, B1_UPRC - B2_CM1 as DIFF "
	c_Query += " from       "+RetSqlName("SB2")+" SB2 "
	c_Query += " inner join "+RetSqlName("SB1")+" SB1 "
	c_Query += " on         B1_COD = B2_COD "
	c_Query += " and        SB1.D_E_L_E_T_ <> '*' "
	c_Query += " where      SB2.D_E_L_E_T_ <> '*' "
	c_Query += " and        B2_VATU1 <> 0 "
//	c_Query += " and        (B1_UPRC - B2_CM1 > 0.01 or  B1_UPRC - B2_CM1 < -0.01) "
	c_Query += " and        B2_FILIAL = '"+xFilial("SB2")+"'  "

	MemoWrite("AEST002.SQL", c_query)

 	If Select("QRY") > 0
		DbSelectArea("QRY")
		DbCloseArea()
	EndIf

	TcQuery c_Query New Alias "QRY"
	
	While QRY->(!EOF())
		n_reg++
		QRY->(DbSkip())
	EndDo
	
	QRY->(DbGotop())

	ProcRegua(n_reg)
	
	While QRY->(!EOF())
	
		IncProc("Fazendo ajustes.. " + AllTrim(QRY->B2_COD)+" "+QRY->B2_LOCAL)
		
		AtuSD3()
		        
		QRY->(DbSkip())
	EndDo
	
	msgAlert('Processado com sucesso!!!! ' + Transform(n_reg, "@E 999999") + " registros.")

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuSD3    บAutor  ณMicrosiga           บ Data ณ  02/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza a movimentacao interna no SD3.                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuSD3()

	Local c_TM		:= Iif(QRY->B2_VATU1 > 0, "504", "003")
	Local n_custo	:= Iif(QRY->B2_VATU1 < 0, QRY->B2_VATU1 * -1, QRY->B2_VATU1)


	aRotAuto := {	{"D3_FILIAL"  ,QRY->B2_FILIAL 	,Nil},;
					{"D3_COD"     ,QRY->B2_COD		,Nil},;
					{"D3_UM"      ,QRY->B1_UM 		,Nil},;
					{"D3_QUANT"   ,0				,Nil},;
					{"D3_LOCAL"   ,QRY->B2_LOCAL 	,Nil},;
					{"D3_EMISSAO" ,dDataBase		,Nil},;
					{"D3_CC" 	  ,"000"			,Nil},;
					{"D3_TM"      ,c_TM				,Nil},;
					{"D3_CUSTO1"  ,n_custo			,Nil}}
			
	nOpc        :=  3 // inclusao
	lMsHelpAuto := .T. // se .t. direciona as mensagens de help para o arq. de log
	lMsErroAuto := .F. //necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros
	
	DbSelectArea("SD3")
	cNumseq		:= ProxNum()
	cNumDoc		:= NextNumero("SD3",2,"D3_DOC",.T.)//BUSCA NUMERACAO DO SD3
			
	aadd(aRotAuto,	{"D3_NUMSEQ"  ,cNumSeq,Nil})
	aadd(aRotAuto,	{"D3_DOC"     ,cNumDoc,Nil})
			
	//GERA O MOVIMENTO NO SD3 DA OUTRA EMPRESA
	MSExecAuto({|x,y| mata240(x,y)},aRotAuto,3)
			
	If lMsErroAuto
		Mostraerro() //Se estiver em uma aplicao normal e ocorrer alguma incosistencia nos parametros passados,mostrar na tela o log informando qual coluna teve a incosistencia
	EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAEST002   บAutor  ณMicrosiga           บ Data ณ  02/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInsere saldo e depois estorna para poder acertar o custo.   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Conf2irma()

	Local c_Query	:= ''
	Local n_reg		:= 0

	Private a_SD3	:= {}

	c_Query := " select     B2_FILIAL, B1_UM, B2_COD, B2_LOCAL, B2_QATU, B1_UPRC, B2_CM1, B2_VATU1/CASE WHEN B2_QATU = 0 THEN 1 ELSE B2_QATU END as CUNIT, B1_UPRC - B2_CM1 as DIFF "
	c_Query += " from       "+RetSqlName("SB2")+" SB2 "
	c_Query += " inner join "+RetSqlName("SB1")+" SB1 "
	c_Query += " on         B1_COD = B2_COD "
	c_Query += " and        SB1.D_E_L_E_T_ <> '*' "
	c_Query += " where      SB2.D_E_L_E_T_ <> '*' "
	c_Query += " and        B2_QATU = 0 "
	c_Query += " and        (B1_UPRC - B2_CM1 > 0.01 or  B1_UPRC - B2_CM1 < -0.01) "
	c_Query += " and        B2_FILIAL = '"+xFilial("SB2")+"'  "

	MemoWrite("AEST002.SQL", c_query)

 	If Select("QRT") > 0
		DbSelectArea("QRT")
		DbCloseArea()
	EndIf

	TcQuery c_Query New Alias "QRT"
	
	While QRT->(!EOF())
		n_reg++
		QRT->(DbSkip())
	EndDo
	
	n_reg := n_reg*3
	ProcRegua(n_reg)
	
	QRT->(DbGotop())
	
	
	n_cont := 0
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza a quantidade dos produtos com 1 unidade.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While QRT->(!EOF())
	
		IncProc("Incluindo Saldos.. " + AllTrim(QRT->B2_COD)+" "+QRT->B2_LOCAL)
		
		GiveSld(1)
		n_cont++
		
		If n_cont > n_ate
			Exit
		EndIf
		        
		
		QRT->(DbSkip())
	EndDo

	c_Query := " select     B2_FILIAL, B1_UM, B2_COD, B2_LOCAL, B2_QATU, B1_UPRC, B2_CM1, B2_VATU1/CASE WHEN B2_QATU = 0 THEN 1 ELSE B2_QATU END as CUNIT, B1_UPRC - B2_CM1 as DIFF "
	c_Query += " from       "+RetSqlName("SB2")+" SB2 "
	c_Query += " inner join "+RetSqlName("SB1")+" SB1 "
	c_Query += " on         B1_COD = B2_COD "
	c_Query += " and        SB1.D_E_L_E_T_ <> '*' "
	c_Query += " where      SB2.D_E_L_E_T_ <> '*' "
	c_Query += " and        B2_QATU > 0 "
	c_Query += " and        (B1_UPRC - B2_CM1 > 0.01 or  B1_UPRC - B2_CM1 < -0.01) "
	c_Query += " and        B2_FILIAL = '"+xFilial("SB2")+"'  "

	MemoWrite("AEST002b.SQL", c_query)

 	If Select("QRY") > 0
		DbSelectArea("QRY")
		DbCloseArea()
	EndIf

	TcQuery c_Query New Alias "QRY"
	QRY->(DbGotop())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz o acerto do custo dos produtos.              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While QRY->(!EOF())
	
		IncProc("Fazendo ajustes.. " + AllTrim(QRY->B2_COD)+" "+QRY->B2_LOCAL)
		
		AtuSD3()
		        
		QRY->(DbSkip())
	EndDo
	
	QRT->(DbGotop())


	n_cont := 0
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVolta a quantididade para zero tirando 1 unidade.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While QRT->(!EOF())
	
		IncProc("Estornando Saldos.. " + AllTrim(QRT->B2_COD)+" "+QRT->B2_LOCAL)
		
		GiveSld(0)
		        
		n_cont++
		
		If n_cont > n_ate
			Exit
		EndIf
		QRT->(DbSkip())
	EndDo

	msgAlert('Processado com sucesso!!!! ' + Transform(n_reg/3, "@E 999999") + " registros.")

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGiveSld   บAutor  ณMicrosiga           บ Data ณ  02/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza a movimentacao interna no SD3.                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GiveSld(n_tipo)

	Local c_TM		:= Iif(n_tipo > 0, "400", "501")
	Local n_custo	:= Iif(QRT->DIFF < 0, QRT->DIFF * -1, QRT->DIFF)*QRT->B2_QATU
	n_custo := Iif(n_tipo > 0, n_custo, 0)


	If n_tipo > 0
		aRotAuto := {	{"D3_FILIAL"  ,QRT->B2_FILIAL 	,Nil},;
						{"D3_COD"     ,QRT->B2_COD		,Nil},;
						{"D3_UM"      ,QRT->B1_UM 		,Nil},;
						{"D3_QUANT"   ,1				,Nil},;
						{"D3_LOCAL"   ,QRT->B2_LOCAL 	,Nil},;
						{"D3_EMISSAO" ,dDataBase		,Nil},;
						{"D3_TM"      ,c_TM				,Nil},;
						{"D3_CUSTO1"  ,n_custo			,Nil}}
		DbSelectArea("SD3")
		cNumseq		:= ProxNum()
//		cNumDoc		:= NextNumero("SD3",2,"D3_DOC",.T.)//BUSCA NUMERACAO DO SD3
				
		aadd(aRotAuto,	{"D3_NUMSEQ"  ,cNumSeq,Nil})
		aadd(aRotAuto,	{"D3_DOC"     ,"999111",Nil})

	Else
		For n_x := 1 to len(a_SD3)
			If a_SD3[n_x, 2] = 0
				Exit
			EndIf
		Next
		
		If n_x > len(a_SD3)
			Return
		EndIf 
		SD3->(DbGoto(a_SD3[n_x, 1]))
		
		aRotAuto := {	{"D3_FILIAL"  ,SD3->D3_FILIAL 	,Nil},;
						{"D3_COD"     ,SD3->D3_COD		,Nil},;
						{"D3_LOCAL"   ,SD3->D3_LOCAL	,Nil},;
						{"D3_QUANT"   ,1				,Nil},;
						{"D3_TM"      ,c_TM				,Nil},;
						{"D3_EMISSAO" ,SD3->D3_EMISSAO	,Nil},;
						{"D3_NUMSEQ"  ,SD3->D3_NUMSEQ	,Nil},;
						{"D3_DOC"     ,SD3->D3_DOC		,Nil}}
	
		cTipo1  := GetMv("MV_ENTRADA")
		cTipo2  := GetMv("MV_SAIDA")

		DbSelectArea("SD3")
		DbSetOrder(4) //D3_FILIAL, D3_NUMSEQ, D3_CHAVE, D3_COD, R_E_C_N_O_, D_E_L_E_T_
		DbSeek(xFilial("SD3")+SD3->D3_NUMSEQ)
		
	EndIf
			
	nOpc        :=  Iif(n_tipo > 0, 3, 5) // inclusao ou estorno
	lMsHelpAuto := .T. // se .t. direciona as mensagens de help para o arq. de log
	lMsErroAuto := .F. //necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros
			
	//GERA O MOVIMENTO NO SD3 DA OUTRA EMPRESA
	
	If n_tipo > 0
		MSExecAuto({|x,y| mata240(x,y)},aRotAuto,nOpc)
	Else
//		MSExecAuto({|x| mata240(x)},aRotAuto,nOpc)
		mata240(,5)		

	EndIf
			
	If lMsErroAuto
		Mostraerro() //Se estiver em uma aplicao normal e ocorrer alguma incosistencia nos parametros passados,mostrar na tela o log informando qual coluna teve a incosistencia
	Else
		If n_tipo > 0
			aadd(a_SD3, {SD3->(Recno()), 0})
		Else
			a_SD3[n_x, 2] := 1
		EndIf
	EndIf

Return