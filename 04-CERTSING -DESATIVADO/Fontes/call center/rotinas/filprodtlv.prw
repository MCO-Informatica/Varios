#INCLUDE "PROTHEUS.CH"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?FILPRODTLV?Autor  ?Microsiga           ? Data ?  20/08/10   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Filtro de Consulta Padrao de Produtos na Rotina de TLV      ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
+----------------------------------------------------------------------------+
|DATA      |AUTOR             |DESCRI??O DA MANUTEN??O                       |
+----------------------------------------------------------------------------+
|26/06/2013|ROBSON LUIZ - RLEG|NA INSTRU??O DE VERIFICA??O DO FUNNAME FOI    |
|          |                  |PRECISO INCLUIR A FUN??O CSFA110 E CSFA030    |
|          |                  |PARA QUE O FILTRO SEJA CONTEMPLADO NA AGENDA  |
|          |                  |CERTISIGN E ATENDIMENTO DO TELEMARKETING.     |
+----------------------------------------------------------------------------+
*/

User Function FILPRODTLV()      
	Local _cRet	:= "@#.T.@#"
	If (FunName() == "TMKA271" .And. TkGetTipoAte() $ "245") .Or. (FunName() $ "CSFA030|CSFA110" .And. TkGetTipoAte() $ "125")
		SU7->(dbSetOrder(4))
		If SU7->(DbSeek(xFilial("SU7")+__cUserId)) .And. SU7->U7_TIPO <> "2"
			_cRet := "@#B1_XTLV == '1'@#"
		Endif
	Endif	
Return( _cRet )