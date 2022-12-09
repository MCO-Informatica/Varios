#include "AP5MAIL.ch"
#include "Protheus.ch"
#include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA415END  �Autor  �Fernando Macieira   � Data � 14/Mar/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para validar Orcamentos, quando situacao   ���
���          �de clientes = E                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Verion                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA415END()

Local cMailDestino,cAssunto,cTexto,cAnexos,cRisco

cMailDestino := GetMv("MV_XVMAIL")
cAssunto     := "Or�amento com Cliente Risco E"
cTexto       := "Cliente: " +AllTrim(M->CJ_CLIENTE)+"/"+AllTrim(M->CJ_LOJA) + Chr(13)+Chr(10)
cTexto       += "Raz�o Social: " +AllTrim(Posicione("SA1",1,xFilial("SA1")+M->(CJ_CLIENTE+CJ_LOJA),"A1_NOME")) + Chr(13)+Chr(10)
cTexto       += "Or�amento: " +M->CJ_NUM + Chr(13)+Chr(10)
cTexto       += "Login: " +AllTrim(cUserName)
cAnexos      := ""
cRisco       := ""

cRisco       := Posicione("SA1",1,xFilial("SA1")+M->(CJ_CLIENTE+CJ_LOJA),"A1_X_RISCO")

If cRisco=="E"
	msgStop("Cliente est� com Risco Financeiro","Aten��o")
	u_vEnvMail(cMailDestino,cAssunto,cTexto,cAnexos,.t.)
EndIf

Return
