#Include "Rwmake.ch"

/*
//����������������������������������������������������������Ŀ
//�Ponto de entrada criado para trazer somente os titulos de �
//�clientes cujo cadastro esta com o campo                   �
//�"A1_BORDERO"= 1 (SIM).                                    �
//������������������������������������������������������������
*/

User Function FA060QRY()

cRet:= ""

IF CPORT060 == "237" //237 - BRADESCO - AGENCIA - CONTA // BASE TESTE
	//	MSGBOX("TESTE IF - ENTROU " + CPORT060)
	cRet := " E1_PORTADO = E1_PORTADO " // trazer tudo
ELSE
	//	MSGBOX("TESTE IF - ELSE " + CPORT060)
	//	cRet := " E1_CLIENTE in ( Select A1_COD from SA1010 WHERE A1_BORDERO = '1' AND A1_LOJA = E1_LOJA)"
	cRet := " E1_PORTAD2 != '237' "
ENDIF


Return cRet