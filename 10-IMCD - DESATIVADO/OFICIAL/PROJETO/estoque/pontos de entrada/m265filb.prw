#include "Protheus.ch"
#include "Topconn.ch"

//PONTO DE ENTRADA PARA PREENCHER A DESCRIÇÃO DO PRODUTO NA ABERTURA DO BROWSER DE ENDEREÇAMENTO
//LUIZ TOTVS

User function M265FILB()



Local cRet := " "

//atualização da descrição do produto
_cQuery  := "SELECT * FROM "+RETSQLNAME("SDA")+" SDA INNER JOIN "+RETSQLNAME("SB1")+" SB1 ON DA_PRODUTO = B1_COD "
_cQuery  += " WHERE DA_DESC = ' ' AND SDA.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' "
If Select("QRX")>0
	DbSelectArea("QRX")
	DbCloseArea()
Endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QRX",.T.,.T.)

dbSelectArea("QRX")
DbGoTop()
While !eof()
	
	dbselectarea("SDA")
	dbsetorder(1)
	dbgotop()
	dbseek(QRX->DA_FILIAL + QRX->DA_PRODUTO + QRX->DA_LOCAL + QRX->DA_NUMSEQ + QRX->DA_DOC  + QRX->DA_SERIE)
	
	RECLOCK("SDA",.F.)
	SDA->DA_DESC := POSICIONE("SB1", 1, xFilial("SB1") + QRX->DA_PRODUTO, "B1_DESC")
	MSUNLOCK()
	
	DbSelectarea("QRX")
	DbSkip()
EndDo

Return cRet
