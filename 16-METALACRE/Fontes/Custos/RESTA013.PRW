#include "rwmake.ch"
#include "protheus.ch"

User Function RESTA013()
Local _nValor	:= 0
Local _dData 	:= _dDataCtb //LastDate(MonthSub(dDataBase,1))
Local _dDataIni := FirstDate(_dData)
Local _dDataFim := LastDate(_dData)
Local aArea     := GetArea()

MsAguarde({|| _nValor:=fResta013(_dDataIni,_dDataFim) },"Processando...","Aguarde, Processando Faturado... ")

RestArea(aArea)
Return _nValor
               
Static Function fResta013(_dDataIni,_dDataFim)
_cQuery := ""
_cQuery += "SELECT SUM(D2_QUANT-D2_QTDEDEV) D2_QUANT FROM " + RetSqlName("SD2") + " SD2 (NOLOCK) "
_cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4 (NOLOCK) ON "
_cQuery += "F4_CODIGO = D2_TES "
_cQuery += "AND F4_FILIAL = D2_FILIAL "
_cQuery += "AND F4_DUPLIC = 'S' "
_cQuery += "AND SF4.D_E_L_E_T_ = '' "
_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK) ON "
_cQuery += "SB1.D_E_L_E_T_ = '' "
_cQuery += "AND B1_COD = D2_COD "
_cQuery += "AND B1_FILIAL = D2_FILIAL "
_cQuery += "AND B1_TIPO = 'PA' "
_cQuery += "WHERE SD2.D_E_L_E_T_ = '' "
_cQuery += "AND D2_EMISSAO BETWEEN '"+Dtos(_dDataIni)+"' AND '"+Dtos(_dDataFim)+"' "
_cQuery += "AND D2_FILIAL = '" + xFilial("SD2") + "' "


DbUseArea(.t., "TOPCONN", TcGenQry(,, _cQuery), "FAT", .t., .t.)

_nValor	:= FAT->D2_QUANT

FAT->(DbCloseArea())       

Return(_nValor)