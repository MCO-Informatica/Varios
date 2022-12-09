#Include "Totvs.ch"

/*__________________________________________________________/
# E-mail de solicitação de aprovação para a medição.		#
# Renato Ruy - 12/02/2014								    #
/__________________________________________________________*/ 

User Function CSGCT002()

Local cDest 	:= ""
Local cRemet	:= ""
Local cAssunto	:= ""
Local cMensagem	:= ""
Local cAnexo	:= ""

DbSelectArea("CND")
DbGoto( CND->( RECNO() ) )

cRemet := "contratos@certisign.com.br"
cDest  := AllTrim(GetMV("MV_CSGCT02"))

cAssunto := "Sol.Aprovação da Medição " + AllTrim(CND->CND_NUMMED)

cMensagem := " <Html> "
cMensagem += " <body> "
cMensagem += " Solicitação de aprovação do contrato pelo usuário : " + AllTrim(UsrFullName(__cUserId))
cMensagem += " <Br> "
cMensagem += " <Br> "
cMensagem += " <TABLE border=1 cellspacing=0 cellpadding=2 bordercolor='666633'> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Medição: </TD> "
cMensagem += " <TD BGCOLOR=#6495ED>" + AllTrim(CND->CND_NUMMED) + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD> Contrato: </TD> "
cMensagem += " <TD>" + AllTrim(CND->CND_CONTRA) + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Data Vencimento: </TD> " 
cMensagem += " <TD BGCOLOR=#6495ED>" + DtoC(CND->CND_DTVENC) + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD> Valor Medição: </TD> "
cMensagem += " <TD>" + AllTrim(Transform(CND->CND_VLTOT,"@E 999,999,999.99")) + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Cod.Cliente: </TD> " 
cMensagem += " <TD BGCOLOR=#6495ED>" + CND->CND_CLIENT + "</TD> "
cMensagem += " <TR> "
cMensagem += " <TR> "
cMensagem += " <TD>Loja Cliente: </TD> " 
cMensagem += " <TD>" + CND->CND_LOJACL + "</TD> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED> Razão Social: </TD> "
cMensagem += " <TD BGCOLOR=#6495ED>" + AllTrim(Posicione("SA1",1,xFilial("SA1") + CND->CND_CLIENT + CND->CND_LOJACL,"A1_NOME")) + "</TD> "
cMensagem += " </TR> "
cMensagem += " </TR> "
cMensagem += " </TABLE> " 
cMensagem += " </BODY> "
cMensagem += " </Html> " 

//Busca anexo da base de conhecicmento
DbSelectArea("AC9")
DbSetOrder(2)
DbSeek( xFilial("AC9") + "CND" + CND->CND_FILIAL + CND->CND_FILIAL + CND->CND_CONTRA + CND->CND_REVISA + CND->CND_NUMMED )

DbSelectArea("ACB")
DbSetOrder(1)
If DbSeek( xFilial("ACB") + AC9->AC9_CODOBJ )
	cAnexo := "\dirdoc\co01\shared\" + AllTrim(ACB->ACB_OBJETO)
EndIf	

U_CSWF001( cRemet , cDest , cAssunto , cMensagem, cAnexo )

Return()