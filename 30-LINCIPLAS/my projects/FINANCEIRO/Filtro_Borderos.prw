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

cRet:= " E1_CLIENTE in ( Select A1_COD from SA1010 WHERE A1_BORDERO = '1' AND A1_LOJA = E1_LOJA)" 

Return cRet