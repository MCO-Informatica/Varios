#Include "Totvs.ch"

/*__________________________________________________________/
# E-mail de solicitação de aprovação para o contrato.		#
# Renato Ruy - 12/02/2014								    #
/__________________________________________________________*/                        

User Function CSGCT001()

Local cDest 	:= ""
Local cRemet	:= ""
Local cAssunto	:= ""
Local cMensagem	:= ""
Local cAnexo	:= ""

cRemet := "contratos@certisign.com.br"
cDest  := AllTrim(GetMV("MV_CSGCT01")) //"renato.bernardo@certisign.com.br"

cAssunto := "Sol.Aprovação do Contrato " + AllTrim(M->CN9_NUMERO)

cMensagem := " <Html> "
cMensagem += " <Head>Solicitação de aprovação </Head> "
cMensagem += " <body> "
cMensagem += " Solicitação de aprovação do contrato: " + AllTrim(UsrFullName(__cUserId))
cMensagem += " <Br> "
cMensagem += " <Br> "
cMensagem += " <TABLE border=1 cellspacing=0 cellpadding=2 bordercolor='666633'> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Contrato: </TD> "
cMensagem += " <TD BGCOLOR=#6495ED>" + M->CN9_NUMERO + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD> Data Início: </TD> "
cMensagem += " <TD>" + DtoC(M->CN9_DTINIC) + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Data Fim: </TD> " 
cMensagem += " <TD BGCOLOR=#6495ED>" + DtoC(M->CN9_DTFIM) + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD> Cod.Cliente: </TD> "
cMensagem += " <TD>" + M->CN9_CLIENT + "</TD> "
cMensagem += " </TR> "
cMensagem += " <TR> "
cMensagem += " <TD BGCOLOR=#6495ED>Loja Cliente: </TD> " 
cMensagem += " <TD BGCOLOR=#6495ED>" + M->CN9_LOJACL + "</TD> "
cMensagem += " <TR> "
cMensagem += " <TD> Razão Social: </TD> "
cMensagem += " <TD>" + Posicione("SA1",1,xFilial("SA1") + M->CN9_CLIENT + M->CN9_LOJACL,"A1_NOME") + "</TD> "
cMensagem += " </TR> "
cMensagem += " </TR> "
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