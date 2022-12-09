#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao	 ณ RPCPE001 ณ Autor ณ Adriano Leonardo    ณ Data ณ 14/07/2016 ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina desenvolvida para retornar a atividade m้dia dos    บฑฑ
ฑฑบ          ณ ๚ltimos lotes de determinado produto.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ O parโmetro MV_ATIVMD, determina a quantidade de lotes     บฑฑ
ฑฑบ          ณ utilizado no cแlculo da atividade m้dia.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico para a empresa Prozyn               			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function RPCPE001(_cComp)

Local _nRet		:= 0
Local _cQuery	:= ""
Local _cAlias	:= GetNextAlias()
Default _cComp	:= ""

_cQuery := "SELECT ISNULL(AVG(Z1_ATIVIDA),0) AS [ATIV_MED] FROM ( "
_cQuery += "SELECT TOP " + AllTrim(Str(SuperGetMv("MV_ATIVMD",,3))) + " Z1_ATIVIDA FROM " + RetSqlName("SZ1") + " SZ1 "
_cQuery += "WHERE SZ1.Z1_PRODUTO='" + _cComp + "' "
_cQuery += "AND SZ1.Z1_PRODUTO<>'' "
_cQuery += "AND SZ1.D_E_L_E_T_='' "
_cQuery += "AND SZ1.Z1_FILIAL='" + xFilial("SZ1") + "' "
_cQuery += "AND SZ1.Z1_ORIGEM<>'SD1' "
_cQuery += "ORDER BY SZ1.Z1_DATA DESC "
_cQuery += ") AUX "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.F.)

dbSelectArea(_cAlias)
If (_cAlias)->(!EOF())
	_nRet := (_cAlias)->ATIV_MED
EndIf

dbSelectArea(_cAlias)
(_cAlias)->(dbCloseArea())

Return(_nRet)