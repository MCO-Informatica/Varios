#INCLUDE "PROTHEUS.CH"
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? M030INC  ?Autor  ? TOTVS Protheus     ? Data ?  02/12/2013 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Ponto de entrada ao termino da inclusao do cadastro de     ???
???          ? clientes.                                                  ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? MATA030 - CADASTRO DE CLIENTES                             ???
?????????????????????????????????????????????????????????????????????????͹??
???Paramixb	 ? PARAMIXB := nOpcA                                          ???
?????????????????????????????????????????????????????????????????????????͹??
???Retorno 	 ? Nenhum                                                     ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
USER FUNCTION M030INC()
//???????????????????????????????????????????????????????????????????????????Ŀ
//?Parametros disponibilizados pelo fonte chamador (MATA030) via ParamIXB     ?
//?????????????????????????????????????????????????????????????????????????????
//Local nOpcA := PARAMIXB
//???????????????????????????????????????????????????????????????????????????Ŀ
//?CERTISIGN: Verificacao das funcoes especificas a serem executadas no P.E.  ?
//?????????????????????????????????????????????????????????????????????????????
Local lCSEP030	:= FindFunction( "U_CSEP030" )

//???????????????????????????????????????????????????????????????????????????Ŀ
//?CERTISIGN: Execucao de funcoes especificas no ponto de entrada             ?
//?           As funcoes devem ser chamadas neste ponto e serem tratadas      ?
//?           em seus respectivos fontes.                                     ?
//?????????????????????????????????????????????????????????????????????????????
//???????????????????????????????????????????????????????????????????????????Ŀ
//?01. CSEP030(): Integracao com entidades contabeis orcamentarias            ?
//?????????????????????????????????????????????????????????????????????????????
IF lCSEP030
	U_CSEP030(3/*nOpcX*/) 
ENDIF

//???????????????????????????????????????????????????????????????????????????Ŀ
//?Retorno esperado pelo fonte chamador (MATA030): Nenhum                     ?
//?????????????????????????????????????????????????????????????????????????????
RETURN Nil