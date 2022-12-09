#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA650POKºAutor  ³ Adriano Leonardo    º Data ³  10/06/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado na geração de ordem de produção º±±
±±º          ³ por vendas.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MTA650POK()    



Local _aSavArea := GetArea()                            
Local _aSavSA1	:= SA1->(GetArea())
Local _cRotina	:= "MA440VLD"
Local _lRet		:= .T. //Default .T.
Local _cQry		:= ""
Local _cAliasTmp:= GetNextAlias() //Retorna um nome de alias disponível
Local _nDiasTol := SuperGetMV("MV_DIASTOL",,15) //Dias para tolerância de atraso médio para liberação do pedido
Local _cMarca	:= PARAMIXB[02]

_cQry := "SELECT DISTINCT C5_NUM, C5_CLIENT, C5_LOJACLI FROM " + RetSqlName("SC5") + " SC5 "
_cQry += "INNER JOIN " + RetSqlName("SC6") + " SC6 "
_cQry += "ON SC5.D_E_L_E_T_='' " 
_cQry += "AND SC5.C5_FILIAL='" + xFilial("SC5") + "' "
_cQry += "AND SC6.D_E_L_E_T_='' "
_cQry += "AND SC6.C6_FILIAL='" + xFilial("SC6") + "' "
_cQry += "AND SC6.C6_NUMOP='' "
_cQry += "AND SC5.C5_NUM=SC6.C6_NUM "
_cQry += "AND SC6.C6_OK='" + _cMarca + "' "
_cQry += "AND (SELECT COUNT(*) FROM " + RetSqlName("SA7") + " SA7 WHERE SA7.D_E_L_E_T_='' AND SA7.A7_FILIAL='" + xFilial("SA7") + "' AND SA7.A7_PRODUTO=SC6.C6_PRODUTO AND SA7.A7_CLIENTE<>SC5.C5_CLIENT AND SA7.A7_LOJA=SC5.C5_LOJACLI)=0 " 

//Cria tabela temporária com base no resultado da query 7
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)

dbSelectArea(_cAliasTmp)

While (_cAliasTmp)->(!EOF())

	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1")+(_cAliasTmp)->C5_CLIENT+(_cAliasTmp)->C5_LOJACLI)
		
		//Chamada dos parâmetros da rotina FINA410 (Refaz dados do cliente/fornecedor)
		Pergunte("AFI410",.F.)
		
		MV_PAR01 := 2 //Recalcular: Ambos|Cliente|Fornecedor (Clientes)
		MV_PAR02 := 1 //Refaz dados históricos: Sim|Nao (Sim)
		MV_PAR03 := SC6->C6_CLI //De cliente (Cliente do pedido de venda)
		MV_PAR04 := SC6->C6_CLI //Até cliente (Cliente do pedido de venda)
		MV_PAR05 := Space(TamSX3("A2_COD")[01]) //De fornecedor (Nenhum)
		MV_PAR06 := Space(TamSX3("A2_COD")[01]) //Até fornecedor (Nenhum)
		
		Processa({|lEnd| fa410Processa()}) // Chamada da funcao de recalculos de dados do cliente/fornecedor (FINA410 - Padrão)
		
		If SA1->A1_METR > _nDiasTol .And. SA1->A1_ATR>0
			MsgStop("Cliente com título(s) em atraso, a geração da ordem de produção não será permitida nesse momento!",_cRotina+"_001")
			_lRet := .F.
			Exit
		EndIf
	Else
		MsgStop("Falha na identificação do cliente, informe ao Administrador!",_cRotina+"_002")
		_lRet := .F.
		Exit
	EndIf
	
	dbSelectArea(_cAliasTmp)
	dbSkip()
EndDo

U_MA650TOK()

dbSelectArea(_cAliasTmp)
(_cAliasTmp)->(dbCloseArea())

RestArea(_aSavSA1)
RestArea(_aSavArea)

Return(_lRet)