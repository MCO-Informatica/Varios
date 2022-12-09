#include "rwmake.ch"
#include "protheus.ch"

User Function RESTA012()
Local _nValor	:= 0
Local _dData 	:= LastDate(MonthSub(_dDataCtb,1))
Local _dDataIni := FirstDate(_dData)
Local _dDataFim := LastDate(_dData)
Local aArea     := GetArea()

MsAguarde({|| _nValor:=fResta012(_dDataIni,_dDataFim) },"Processando...","Aguarde, Processando Produzido... ")

RestArea(aArea)
Return _nValor

Static Function fResta012(_dDataIni,_dDataFim)
Local _nValor	:= 0
Local _dData 	:= _dDataCtb //LastDate(MonthSub(dDataBase,1))
Local _dDataIni := FirstDate(_dData)
Local _dDataFim := LastDate(_dData)

_cQuery := ""
_cQuery += "SELECT SUM(D3_QUANT) D3_QUANT FROM " + RetSqlName("SD3") + " SD3 (NOLOCK) "
_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK) ON "
_cQuery += "B1_COD = D3_COD "
_cQuery += "AND B1_TIPO = 'PA' "
_cQuery += "AND B1_FILIAL = D3_FILIAL "
_cQuery += "AND SB1.D_E_L_E_T_ = '' "
_cQuery += "WHERE D3_EMISSAO BETWEEN '"+Dtos(_dDataIni)+"' AND '"+Dtos(_dDataFim)+"' "
_cQuery += "AND SUBSTRING(D3_CF,1,2) = 'PR' "
_cQuery += "AND SD3.D_E_L_E_T_= '' "
_cQuery += "AND SD3.D3_FILIAL = '" + xFilial("SD3") + "' "


DbUseArea(.t., "TOPCONN", TcGenQry(,, _cQuery), "PRD", .t., .t.)

_nValor	:= PRD->D3_QUANT

PRD->(DbCloseArea())

Return(_nValor)