#Include "Totvs.ch"

/*__________________________________________________________/
# E-mail de aviso de encerramento da medição.				#
# Renato Ruy - 12/02/2014								    #
/__________________________________________________________*/ 

User Function CSGCT004()

Local cDest 	:= ""
Local cRemet	:= ""
Local cAssunto	:= ""
Local cMensagem	:= ""
Local cAnexo	:= ""

cRemet := "contratos@certisign.com.br"
cDest  := AllTrim(GetMV("MV_CSGCT04")) //"renato.bernardo@certisign.com.br"

cAssunto := "Medição Encerrada " + AllTrim(CND->CND_NUMMED)

cMensagem := " <Html> "
cMensagem += " <body> "
cMensagem += " A medição foi encerrada pelo usuário: " + AllTrim(UsrFullName(__cUserId))
cMensagem += " <Br> "
cMensagem += " <Br> "
cMensagem += " <TABLE border=1 cellspacing=0 cellpadding=2 bordercolor='666633'> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Medição: </TD> "
cMensagem += " <TD BGCOLOR=#6495ED>" + AllTrim(CND->CND_NUMMED) + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD> Data Início: </TD> "
cMensagem += " <TD>" + DtoC(CND->CND_DTINIC) + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Data Fim: </TD> " 
cMensagem += " <TD BGCOLOR=#6495ED>" + DtoC(CND->CND_DTFIM) + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD> Cod.Cliente: </TD> "
cMensagem += " <TD>" + CND->CND_CLIENT + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Loja Cliente: </TD> " 
cMensagem += " <TD BGCOLOR=#6495ED>" + CND->CND_LOJACL + "</TD> "
cMensagem += " <TR> "
cMensagem += " <TD> Razão Social: </TD> "
cMensagem += " <TD>" + Posicione("SA1",1,xFilial("SA1") + CND->CND_CLIENT + CND->CND_LOJACL,"A1_NOME") + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Valor da Medição: </TD> " 
cMensagem += " <TD BGCOLOR=#6495ED>" + AllTrim(Transform(CND->CND_VLTOT,"@E 999,999,999.99")) + "</TD> "
cMensagem += " </TR> "
If CNL->CNL_XGRPD == "1"
cMensagem += " <TR> "
cMensagem += " <TD>Número do Pedido: </TD> " 
cMensagem += " <TD>" + SC5->C5_NUM + "</TD> "
cMensagem += " </TR> "
EndIf
cMensagem += " </TABLE> " 
cMensagem += " </BODY> "
cMensagem += " </Html> " 

//Busca anexo da base de conhecicmento
DbSelectArea("AC9")
DbSetOrder(2)
DbSeek( xFilial("AC9") + "CN9" + CN9->CN9_FILIAL + CN9->CN9_NUMERO + CN9->CN9_REVISA )

DbSelectArea("ACB")
DbSetOrder(1)
If DbSeek( xFilial("ACB") + AC9->AC9_CODOBJ )
	cAnexo := "\dirdoc\co01\shared\" + AllTrim(ACB->ACB_OBJETO)
EndIf

U_CSWF001( cRemet , cDest , cAssunto , cMensagem , cAnexo )

Return()