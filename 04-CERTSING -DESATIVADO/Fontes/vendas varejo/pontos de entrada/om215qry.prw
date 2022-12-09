#Include 'Protheus.ch'

/*/{Protheus.doc} OM215QRY

Ponto de Entrada executado no momento da geração da carga para terceiros

@author Totvs SM - David
@since 08/08/2014

/*/

User Function om215qry()
	Local cSqlCarga	:=  paramixb[1]
	Local cRet		:= nil
	Local sErro		:= ""
	Local sSql		:= ""
	
	cSqlCarga := StrTran(cSqlCarga,"AND SC5.C5_FILIAL = SC9.C9_FILIAL","AND SC5.C5_FILIAL ='"+xFilial("SC5")+"' ")
	cSqlCarga := StrTran(cSqlCarga,"AND SC6.C6_FILIAL = SC9.C9_FILIAL","AND SC6.C6_FILIAL ='"+xFilial("SC6")+"' ")
	cSqlCarga := StrTran(cSqlCarga,"AND SC5.C5_TRANSP <> '"+Space(Len(SC5->C5_TRANSP))+"'","")
	cSqlCarga := StrTran(cSqlCarga,"SELECT","SELECT /*+ INDEX (SC9 SC90101) */ ")

	If !Empty(cSqlCarga)
		cRet := cSqlCarga
		conout(cRet)
	Endif
Return(cRet)