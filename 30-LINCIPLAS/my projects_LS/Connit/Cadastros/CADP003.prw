#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CADP003บ Autor ณEdu Felipe/Marcelo Scibaบ Data ณ  08/01/08     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Envia e-mail para responsแveis de cada แrea alimentar o 		  บฑฑ
ฑฑบ          ณ cadastro de produtos.										  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Livraria Laselva         									  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CADP003(cCodigo,cDescr,cOpcao)

Local cAssunto	:= cOpcao + " DO PRODUTO ("+Alltrim(cCodigo)+")"
Local cPara		:= GETMV("MV_EMAIL")
Local cMensagem	:= ""

cMensagem += "<TR>"
cMensagem += "<FONT face='Verdana' size='2'<h2>Ao departamento :</h2>"
cMensagem += "<TR>"
cMensagem += "<FONT face='Verdana' size='2'<h2><b>Fiscal;</b></h2>"
cMensagem += "<TR>"
cMensagem += "<FONT face='Verdana' size='2'<h2>Informamos a "+cOpcao+" do produto "
cMensagem += "<b>'"+Alltrim(cCodigo)+" - "+Alltrim(cDescr)+"'</b/> "
cMensagem += "nesta data. Favor atualizar as informa็๕es referente "
cMensagem += "ao seu departamento, para que o cadastro seja efetivado.</h2>"
cMensagem += "<FONT face='Verdana' size='2'<h2>Att,</h2>"
cMensagem += "<FONT face='Verdana' size='2'<h2>Depto. Produtos ("  + cUserName + ")</h2>"

U_EnvMail(cPara,cAssunto, cMensagem,)

Return Nil
