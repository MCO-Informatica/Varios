/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?GFAT001   ?Autor  ?Alexandre Sousa     ? Data ?  10/26/10   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Gatilho utilizado para verificar se o pedido de vendas      ???
???          ?foi incluido ou nao pelo depto financeiro.                  ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?Especifico LISONDA.                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function GFAT001()

	Local c_usuario := GetMv('MV_XUSRFIN')
	
	If __cuserid $ c_usuario
		Return 'S'
	EndIf


Return 'N'