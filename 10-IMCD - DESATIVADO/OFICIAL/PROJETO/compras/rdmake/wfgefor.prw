#include "protheus.ch"
#include "parmtype.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � WFGEFOR   �Autor  �  Junior Carvalho   � Data � 18/09/2019  ���
�������������������������������������������������������������������������͹��
���Desc.     � Gerar o e-mail de altera��o do Fornecedor                  ���
�������������������������������������������������������������������������͹��
���Uso       � MATA020                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WFGEFOR(aDadosBco)
Local nX:= 0 
Private cForn := aDadosBco[1,1]+' '+aDadosBco[1,2]+' - '+aDadosBco[1,3]
Private cAssunto := 'Altera��o dados Banc�rios . Fornecedor ' + cForn

cTO := ''
cCc := ''
cBcc := ''
cBody := CORPOEMAIL(aDadosBco)
aAttach := {}
cUsuarios := GetMv("ES_MAILFOR") // 000556

aUsuarios := StrToArray( cUsuarios, ";")

For nX:= 1 TO Len(aUsuarios)
	
	cTO += alltrim(UsrRetMail(aUsuarios[nX]))+';'
	
Next nX



U_ENVMAILIMCD(cTO,cCc,cBcc, cAssunto,cBody,aAttach)

Return()

Static Function CORPOEMAIL( aDadosBco )

Local cMensagem := ' '

cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
cMensagem += '<head>'
cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cMensagem += '<title> '+cAssunto+'</title>'
cMensagem += '</head>'
cMensagem += '<body>'

cMensagem += '<p>Os dados Banc�rios do Fornecedor: <strong>'+cForn+'</strong>, foram alterados, confira abaixo as Altera��es.</p>'
cMensagem += '<p>O Fornecedor est� bloqueado para gera��o de Border�s de pagamento</p>
cMensagem += '<p>Para desbloquear acesse o Protheus e realize a libera��o no Cadastro do Fornecedor.</p>

cMensagem += '<table border="1" cellpadding="1" cellspacing="1" style="width: 800px">'
cMensagem += '	<thead>'
cMensagem += '	<tr>'
cMensagem += '	<th scope="col"> </th>'
cMensagem += '	<th scope="col">Banco</th>'
cMensagem += '	<th scope="col">Ag�ncia</th>'
cMensagem += '	<th scope="col">Conta</th>'
cMensagem += '	</tr>'
cMensagem += '	</thead>'
cMensagem += '<tbody>'

cMensagem += '<tr>'
cMensagem += '<td>De</td>'
cMensagem += '<td>'+aDadosBco[2][3]+'�</td>
cMensagem += '<td>'+aDadosBco[3][3]+'</td>
cMensagem += '<td>'+aDadosBco[4][3]+'</td>
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td>Para�</td>'
cMensagem += '<td>'+aDadosBco[2][2]+'�</td>
cMensagem += '<td>'+aDadosBco[3][2]+'</td>
cMensagem += '<td>'+aDadosBco[4][2]+'</td>
cMensagem += '</tr>'

cMensagem += '</tbody>'
cMensagem += '</table>'

cMensagem += '<p>Data da Altera��o: <strong>'+DTOC(DDATABASE)+'</strong></p>'

cMensagem += '<p>Usu�rio : <strong>'+UsrFullName(__CUSERID)+'</strong> '

cMensagem += '<p>* Este e-mail foi enviado automaticamente pelo Sistema PROTHEUS - WFGRFOR. Favor n�o responder.</p>'
cMensagem += '</body> '
cMensagem += '</html>'

Return(cMensagem)
