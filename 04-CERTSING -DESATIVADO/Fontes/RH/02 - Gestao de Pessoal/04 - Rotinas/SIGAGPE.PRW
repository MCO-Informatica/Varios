#INCLUDE "rwmake.ch"
/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? SIGAGPE  ? Autor ? Marco - Primainfo  ? Data ?  14/04/19   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Ponto Entrada SIGAGPE.PRW - Acesso modulo 07               ???
???          ? Ira Exibir as pendencias dos funcionarios                  ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? P12                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
User Function SIGAGPE

Private dDataVer := GetMV("GP_DTGPEAV")
Private cVerifica:= DTOS(Date())
Private lProcessa:= .F.

If SIX->(dbSeek("ZXC"))
	
	//Parametro de controle para exibir somente 1 vez ao dia
	If SubStr(dDataVer,1,8) == cVerifica
		If !(RetCodUsr() $ dDataVer)
			PutMV("GP_DTGPEAV",dDataVer + "|" + RetCodUsr())
			lProcessa := .T.
		EndIf
	Else
		PutMV("GP_DTGPEAV",cVerifica + "|" + RetCodUsr())
		lProcessa := .T.
	EndIf
	
	If lProcessa
		U_GPPRIAVPEN()
	Endif
	
Endif

Return