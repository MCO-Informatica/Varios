#include "rwmake.ch"

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  � CADP003� Autor �Edu Felipe/Marcelo Sciba� Data �  08/01/08     ���
�����������������������������������������������������������������������������͹��
���Descricao � Envia e-mail para respons�veis de cada �rea alimentar o 		  ���
���          � cadastro de produtos.										  ���
�����������������������������������������������������������������������������͹��
���Uso       � Livraria Laselva         									  ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
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
cMensagem += "nesta data. Favor atualizar as informa��es referente "
cMensagem += "ao seu departamento, para que o cadastro seja efetivado.</h2>"
cMensagem += "<FONT face='Verdana' size='2'<h2>Att,</h2>"
cMensagem += "<FONT face='Verdana' size='2'<h2>Depto. Produtos ("  + cUserName + ")</h2>"

U_EnvMail(cPara,cAssunto, cMensagem,)

Return Nil
