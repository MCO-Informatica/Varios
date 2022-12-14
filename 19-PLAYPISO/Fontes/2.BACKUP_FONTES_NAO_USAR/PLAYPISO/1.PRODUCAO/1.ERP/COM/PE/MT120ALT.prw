/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MT120ALT  ?Autor  ?Alexandre Sousa     ? Data ?  11/08/10   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Ponto de entrada durante a manutencao do pedido de compras  ???
???          ?utilizado para validar a aprovacao finanaceira do mesmo.    ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?Especifico LISONDA.                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function MT120ALT()

	If VerRot("U_ACOM016")
		Return .T.
	EndIf
	
	If SC7->C7_XSTATFI = 'P'
		msgAlert('O pedido de compras encontra-se pendente de libera??o financeira. Favor solicitar a libera??o do mesmo ao respons?vel.', 'A T E N ? ?O')
		Return .F.
	EndIf

Return .T.
/*
????????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????ͻ??
???Programa   ? VerRot   ? Autor ? Jaime Wikanski            ?Data?04.11.2002???
????????????????????????????????????????????????????????????????????????????͹??
???Descricao  ? Verifica se estou na rotina desejada                         ???
????????????????????????????????????????????????????????????????????????????ͼ??
????????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????????
*/
Static Function VerRot(cRotina)
//?????????????????????????????????????????????????????????????????????????Ŀ
//? Declaracao de variaveis                     						  		 	 ?
//???????????????????????????????????????????????????????????????????????????
Local nActive   	:= 1
Local lExecRot 	:= .F.

//?????????????????????????????????????????????????????????????????????????Ŀ
//? Verifica a origem da rotina               								       ?
//???????????????????????????????????????????????????????????????????????????
While !(PROCNAME(nActive)) == ""
   If Alltrim(Upper(PROCNAME(nActive))) $ Alltrim(Upper(cRotina))
      lExecRot := .T.
      Exit
   Endif
   nActive++
Enddo

Return(lExecRot)
