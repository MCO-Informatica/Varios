#Include "Totvs.ch" 

/*__________________________________________________________/
# Envio de solicitação de Geração de caução.				#
# Uso: Gestão de Contrato - Financeiro.						#
# Renato Ruy - 09/04/2014								    #
/__________________________________________________________*/ 

User Function CSGCT007()

Local cDest 	:= ""
Local cRemet	:= ""
Local cAssunto	:= ""
Local cMensagem	:= ""

cRemet := "contratos@certisign.com.br"
cDest  := AllTrim(GetMV("MV_CSGCT07")) //"renato.bernardo@certisign.com.br"

cAssunto := "Solicitação de Caução - Contrato: " + AllTrim(CN9->CN9_NUMERO)

cMensagem := " <Html> "
cMensagem += " <body> "
cMensagem += " Foi solicitada a geração de Caução para o contrato: " + AllTrim(CN9->CN9_NUMERO)
cMensagem += " <Br> "
cMensagem += " <Br> "
cMensagem += " <TABLE border=1 cellspacing=0 cellpadding=2 bordercolor='666633'> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Contrato: </TD> "
cMensagem += " <TD BGCOLOR=#6495ED>" + CN9->CN9_NUMERO + "</TD> "
cMensagem += " </TR> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD> Descrição: </TD> "
cMensagem += " <TD>" + CN9->CN9_DESCRI + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Valor Contrato: </TD> "
cMensagem += " <TD BGCOLOR=#6495ED>" + Transform(CN9->CN9_VLATU, "@E 999,999,999.99") + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD> Data Início: </TD> "
cMensagem += " <TD>" + DtoC(CN9->CN9_DTINIC) + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Data Fim: </TD> "
cMensagem += " <TD BGCOLOR=#6495ED>" + DtoC(CN9->CN9_DTFIM) + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD> Cod.Cliente: </TD> "
cMensagem += " <TD>" + CN9->CN9_CLIENT + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Loja Cliente: </TD> "
cMensagem += " <TD BGCOLOR=#6495ED>" + CN9->CN9_LOJACL + "</TD> "
cMensagem += " <TR> "
cMensagem += " <TD> Razão Social: </TD> "
cMensagem += " <TD>" + Posicione("SA1",1,xFilial("SA1") + CN9->CN9_CLIENT + CN9->CN9_LOJACL,"A1_NOME") + "</TD> "
cMensagem += " </TR> "
cMensagem += " </TR> "
cMensagem += " </TABLE> "
cMensagem += " </BODY> "
cMensagem += " </Html> "

U_CSWF001( cRemet , cDest , cAssunto , cMensagem , "" )

Return()