#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'    

/*???????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ? VALIDCLI    ? Autor ? Osmair Stellzer  ? Data ? 07/03/2018 ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Validador de Tipo de Pedido de Venda						  ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Espec?fico para a empresa Prozyn               			  ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????P???????????????????????????*/

User Function VALIDCLI()
	
	If (M->C5_TIPO == 'B') .Or. (M->C5_TIPO == 'D')
			M->C5_NOMECLI := Posicione("SA2",1,xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI,"A2_NREDUZ")
			Else
			M->C5_NOMECLI := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_NREDUZ")                           
	EndIf 

Return M->C5_NOMECLI