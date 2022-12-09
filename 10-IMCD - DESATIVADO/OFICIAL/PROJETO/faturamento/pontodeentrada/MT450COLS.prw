#include 'protheus.ch'    
#INCLUDE "rwmake.ch"   
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT450COLS º Autor ³ Giane - ADV Brasil º Data ³  20/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para incluir informacoes na tela da anali-º±±
±±º          ³ se do credito do pedido.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI / faturamento                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT450COLS()   

Local cStatus 	:= ""
Local cPos 		:= ""  
Local aDados 	:= aClone(Paramixb[2])     
Local nTam 		:= LEN(Paramixb[2])

Local cQuery 	:= ''
Local cAlias 	:= GetNextAlias()
Local aArea 	:= GetArea()
Local _cCli		:= SC5->C5_CLIENTE
Local _cLoja	:= SC5->C5_LOJACLI 
Local _cPedido  := SC5->C5_NUM
Local dMax		
Local nUlt		:= 0
Local nSaldo	:= 0
Local cMsg		:= ""

cPos :=  Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_POSCLI")                                  
Do case 
   case cPos == "L"
      cStatus := "Liberado"
   case cPos == "B"   
      cStatus := "Bloqueado"
   case cPos == "A"
      cStatus := "A Vista"
   case cPos == "M"
      cStatus := "Monitorado"
Endcase                                             

aDados[nTam,5] := 'Pos.Credito Cliente'                                                                            
aDados[nTam,6] := space(06) + cStatus

// Apuração do saldo do LC
nSaldo := IIF(SA1->A1_MOEDALC==1,SA1->A1_LC,XMOEDA(SA1->A1_LC,2,1))
nSaldo := nSaldo - SA1->A1_SALDUP

// Query para pegar a data da maior compra
cQuery := "Select SF2.F2_EMISSAO EMISSAO, MAX(SF2.F2_VALBRUT) TOTAL"
cQuery += "  From " + RetSqlName('SF2') + " SF2 "
cQuerY += " Where SF2.F2_CLIENTE = '" 	+ _cCli + "'"
cQuery += "   and SF2.F2_LOJA = '" 		+ _cLoja + "'"
cQuery += "   and SF2.D_E_L_E_T_ = ' ' "
cQuery += " Group by SF2.F2_EMISSAO "
cQuery += " Order by 2 DESC"
                            
If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), cAlias, .F., .T.)
TcSetField(cAlias,'EMISSAO','D',8)
dMax := DtoC((cAlias)->EMISSAO)
(cAlias)->(DbCloseArea())        

// Query para pegar o valor da ultima compra 
cAlias 	:= GetNextAlias()
aArea 	:= GetArea()

cQuery := "Select SF2.F2_EMISSAO EMISSAO, SF2.F2_VALBRUT TOTAL"
cQuery += "  From " + RetSqlName('SF2') + " SF2 "
cQuerY += " Where SF2.F2_CLIENTE = '" 	+ _cCli + "'"
cQuery += "   and SF2.F2_LOJA = '" 		+ _cLoja + "'"
cQuery += "   and SF2.D_E_L_E_T_ = ' ' "
cQuery += " Order by F2_EMISSAO DESC"
                            
If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), cAlias, .F., .T.)
TcSetField(cAlias,'TOTAL','N',14,2)
nUlt := (cAlias)->TOTAL
(cAlias)->(DbCloseArea())        

// Query para pegar as mensagens referentes a Liberacao
cAlias := GetNextAlias()
aArea  := GetArea()

cQuery := "SELECT SZ4.Z4_USUARIO, SZ4.Z4_DATA, SZ4.Z4_HORA, SZ4.Z4_MOTIVO "
cQuery += "FROM	" + RetSqlName('SZ4') + " SZ4 "
cQuery += "WHERE SZ4.Z4_PEDIDO = '" + _cPedido + "' AND "
cQuery += 		"SZ4.Z4_EVENTO =  '1.Liberacao Credito' "  //'Liberacao Pedido' "
cQuery += "ORDER BY Z4_DATA, Z4_HORA" 

If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), cAlias, .F., .T.)

While (!((cAlias)->(Eof())))
    If Len(AllTrim((cAlias)->Z4_MOTIVO)) > 1
	    cMsg += DTOC(STOD((cAlias)->Z4_DATA)) + ", "
	    cMsg += SubString((cAlias)->Z4_HORA, 1, 5) + Chr(09)
	    cMsg += AllTrim((cAlias)->Z4_MOTIVO) + Chr(13) + Chr(10)
	EndIf
	(cAlias)->(DbSkip())
EndDo
(cAlias)->(DbCloseArea())        

aDados[3,5]		:= 'Última Compra'
aDados[3,6]		:= Space(10) + Dtoc(SA1->A1_ULTCOM)
aDados[4,5]		:= 'Maior Compra'
aDados[4,6]		:= Space(10) + dMax
aDados[8,1] 	:= 'Maior Compra' 
IF SA1->A1_MOEDALC==1
	aDados[8,2]		:= Transform(SA1->A1_MCOMPRA,"@E 99,999,999,999.99")
	aDados[8,3]		:= Transform(xMoeda(SA1->A1_MCOMPRA,1,2),"@E 99,999,999,999.99")
Else                                                                    
	aDados[8,2]		:= Transform(xMoeda(SA1->A1_MCOMPRA,2,1),"@E 99,999,999,999.99")
	aDados[8,3]		:= Transform(SA1->A1_MCOMPRA,"@E 99,999,999,999.99")
Endif
aDados[9,1]		:= 'Última Compra'                                       
aDados[9,2]		:= Transform(nUlt,"@E 99,999,999,999.99")
aDados[9,3]		:= Transform(xMoeda(nUlt,1,2),"@E 99,999,999,999.99")
          
// Saldo do LC
aDados[4,2]		:= Transform(nSaldo,"@E 99,999,999,999.99")
aDados[4,3]		:= Transform(xMoeda(nSaldo,1,2),"@E 99,999,999,999.99")

// MsgBox Mensagens Liberacao
//If Len(AllTrim(cMsg)) > 1
//	MSGInfo(cMsg, "Obs.Pedido nº " + _cPedido)
//EndIf 

if !empty(SC5->C5_OBSFIN) .or. (Len(AllTrim(cMsg)) > 1) //mensagem do pedido para o financeiro + mensagens da liberacao do pedido
	MSGInfo(alltrim(SC5->C5_OBSFIN)+chr(13)+chr(10) + alltrim(cMsg), "Observação Pedido nº " + _cPedido)
endif

Return(aDados)