#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �CN120PED  � Autor � RICARDO CAVALINI      � Data �18/10/2016���
�������������������������������������������������������������������������Ĵ��
���          � PONTO DE ENTRADA DO MODULO CONTRATOS PARA GERACAO DO PEDIDO���
���Descricao � DE VENDA COM OS CAMPOS DE USUARIO.                         ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.� Data   � Bops � Manutencao Efetuada                    ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �      �                                        ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
*/
User Function CN120PED()
Local ExpA1 := PARAMIXB[1]
Local ExpA2 := PARAMIXB[2]
Local ExpC3 := PARAMIXB[3]

//Valida��es do usu�rio.
AAdd(ExpA1, {"C5_VKGFAT" , "S"             , Nil})
AAdd(ExpA1, {"C5_DTTXREF", Ddatabase       , Nil})

Return {ExpA1,ExpA2}