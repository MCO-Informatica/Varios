#include "Protheus.ch"
#INCLUDE "TopConn.ch"  
#INCLUDE "RWMAKE.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A175GRV     ºAutor  ³ Mateus Hengle      ºData  ³ 13/07/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de Entrada após a gravação da Liberação\Estorno do CQ º±±
±±º          ³Grava o Lote na SD4 e empenha a quantidade na SB8           º±±
±±º          ³TOTVS TRIAH     										   	  º±±
±±º          ³   										            	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A175GRV()

Private aAreaSD4  := SD4->(GetArea())
Private aAreaSB8  := SB8->(GetArea())

Private cSequen := "" 
Private cTipo   := ""
Private cLote   := "" 
Private cProd   := ""
Private cOP     := "" 
Private cQuant  := "" 
Private dData   := DATE()

Private cLoteD7  := ALLTRIM(SD7->D7_LOTECTL)
Private cProd    := ALLTRIM(SD7->D7_PRODUTO)


If cEmpAnt <> '01' // se nao for empresa 01 Return
	Return .T.
Endif


cOpmanu := SUBSTR(cLoteD7, 1, 1)

cQry:= " SELECT TOP 1 D7_SEQ, D7_TIPO, D7_PRODUTO, D7_LOTECTL, D7_QTDE, H6_OP, D7_LOCDEST " // PEGA A ULTIMA LINHA NA TABELA SD7 DO LOTE E PRODUTO
cQry+= " FROM "+RETSQLNAME("SD7")+" SD7"
cQry+= " INNER JOIN "+RETSQLNAME("SH6")+" SH6"
cQry+= " ON D7_FILIAL = H6_FILIAL AND D7_PRODUTO = H6_PRODUTO AND D7_LOTECTL = H6_LOTECTL"
cQry+= " WHERE D7_LOTECTL = '"+cLoteD7+"'"
cQry+= " AND D7_PRODUTO = '"+cProd+"'"
cQry+= " AND SD7.D_E_L_E_T_=''"
cQry+= " AND SH6.D_E_L_E_T_=''"
cQry+= " ORDER BY SD7.R_E_C_N_O_ DESC "

If Select("TRDTEMP") > 0
	TRDTEMP->(dbCloseArea())
EndIf

TCQUERY cQry New Alias "TRDTEMP"

cSequen := ALLTRIM(TRDTEMP->D7_SEQ)    // PEGA ALGUNS CAMPOS DO RESULTADO DA QUERY
cTipo   := TRDTEMP->D7_TIPO
cProd   := ALLTRIM(TRDTEMP->D7_PRODUTO)
cLote   := ALLTRIM(TRDTEMP->D7_LOTECTL)
cQuant  := TRDTEMP->D7_QTDE
cOP     := ALLTRIM(TRDTEMP->H6_OP)                                                            
cLocal  := TRDTEMP->D7_LOCDEST

TRDTEMP->(dbCloseArea())

// GRAVA O LOTE DO PI NA PA DA TABELA SD4
dbselectarea("SD4") // posiciona na D4
DBSETORDER(4)
IF DBSEEK(XFILIAL("SD4") + cOP )// PUXA PELO CAMPO D4_OPORIG QUE EH PI
	cLoteCTL := SUBSTR(SD4->D4_OP,1,8)
		
	If RecLock("SD4",.f.)
		SD4->D4_LOTECTL := Iif(cTipo==1,cLoteCTL,'')  // grava o numero da OP e item no campo do LOTE
		SD4->D4_DTVALID := Iif(cTipo==1,dData,CtoD(''))
		SD4->(MSUNLOCK())
	Endif
Endif

// QUERY PARA PEGAR A ULTIMA LINHA NA TABELA SB8

cQry1 := " SELECT TOP 1 SB8.R_E_C_N_O_ AS RECNOB8 "
cQry1 += " FROM "+RETSQLNAME("SB8")+" SB8"
cQry1 += " INNER JOIN "+RETSQLNAME("SD7")+" SD7"
cQry1 += " ON D7_FILIAL = B8_FILIAL AND D7_PRODUTO = B8_PRODUTO AND D7_LOTECTL = B8_LOTECTL"
cQry1 += " WHERE B8_LOTECTL = '"+cLoteD7+"'"
cQry1 += " AND B8_PRODUTO = '"+cProd+"'"
cQry1 += " AND SD7.D_E_L_E_T_=''"
cQry1 += " AND SB8.D_E_L_E_T_='' "
cQry1 += " ORDER BY SB8.R_E_C_N_O_ DESC "

If Select("TRETEMP") > 0
	TRETEMP->(dbCloseArea())
EndIf

TCQUERY cQry1 New Alias "TRETEMP"

cRecnoB8 := TRETEMP->RECNOB8

TRETEMP->(dbCloseArea())

// IF PRA GRAVAR A(QTDE DA D7) EMPENHO NA B8 SE FOR LIBERACAO, E PRA LIMPAR O EMPENHO  SE FOR ESTORNO   

cGetmv := GETMV("MV_OPMANU")  // SE COMECAR COM : C - H - M - S - P - V - I - B

nQtd := 0

// QUERY PARA PEGAR A ULTIMA LINHA NA TABELA SB8

cQry1 := " SELECT SUM(D7_QTDE) TOTAL "
cQry1 += " FROM "+RETSQLNAME("SD7")+" SD7"
cQry1 += " WHERE D7_LOTECTL = '"+cLoteD7+"'"
cQry1 += " AND D7_PRODUTO = '"+cProd+"'"
cQry1 += " AND D7_LOCDEST = '"+cLocal+"'"
cQry1 += " AND D7_ESTORNO = '' "
cQry1 += " AND SD7.D_E_L_E_T_=''"
cQry1 += " AND D7_TIPO = '" + AllTrim(CVALTOCHAR(cTipo)) + "' "

If Select("TRETEMP") > 0
	TRETEMP->(dbCloseArea())
EndIf

TCQUERY cQry1 New Alias "TRETEMP"

nQtd := TRETEMP->TOTAL 

TRETEMP->(dbCloseArea())


IF cTipo = 1 .AND. !(cOpmanu $ cGetmv) // TESTA SE EH OP MANUAL, SE FOR NAO EMPENHA
	c_UPDQry  := "  UPDATE "+RETSQLNAME("SB8")"
	c_UPDQry  += "  SET B8_EMPENHO = '"+CVALTOCHAR(nQtd)+"', "
	c_UPDQry  += "      B8_QTDORI  = B8_SALDO "
	c_UPDQry  += "	WHERE R_E_C_N_O_ = '"+CVALTOCHAR(cRecnoB8)+"'" "
	c_UPDQry  += "  AND B8_PRODUTO = '"+cProd+"'"
	c_UPDQry  += "  AND B8_LOTECTL = '"+cLote+"'"
	c_UPDQry  += "  AND D_E_L_E_T_='' "
	
	TcSqlExec(c_UPDQry)
	
	//MsgInfo("Foi feito o empenho Total de "+CVALTOCHAR(nQtd)+"  peças ! ")
	
ELSEIF cTipo = 6.AND. !(cOpmanu $ cGetmv)
	
	cUPDQry2  := "  UPDATE "+RETSQLNAME("SB8")"
	cUPDQry2  += "  SET B8_EMPENHO = '' "
	cUPDQry2  += "	WHERE R_E_C_N_O_ = '"+CVALTOCHAR(cRecnoB8)+"'" "
	cUPDQry2  += "  AND B8_PRODUTO = '"+cProd+"'"
	cUPDQry2  += "  AND B8_LOTECTL = '"+cLote+"'"
	cUPDQry2  += "  AND D_E_L_E_T_='' "
	
	TcSqlExec(cUPDQry2)
	
	//MsgInfo("O Empenho foi desfeito com sucesso !")
	
ENDIF

RestArea(aAreaSD4)
RestArea(aAreaSB8)

Return