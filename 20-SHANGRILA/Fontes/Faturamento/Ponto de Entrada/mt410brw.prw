#include "protheus.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � MT410BRW � Autor �     Ricardo Souza       � Data � 11/05/2012 ���
���          �          �       �     MVG Consultoria     �      �            ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Filtra os Pedidos de Acordo com o Perfil do Usuario            ���
�����������������������������������������������������������������������������Ĵ��
���Observacao� Filtragem apenas para os representantes                        ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Shangri-la Comercio de Espanadores Ltda                        ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
���              �        �                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function MT410BRW()

Local _aArea := GetArea()
Local _cGrupo:= ""
Local _daduser:=_grupo:={}
Local _nomeuser:=substr(cusuario,7,15)  
Public _nomeuser2:=substr(cusuario,7,06)  

psworder(2)
             	
if pswseek(_nomeuser,.t.)
        _daduser:=pswret(1)
        _grupo:=Array(len(_daduser[1,10]))
        psworder(1)
        for i:=1 to len(_daduser[1,10])
            if pswseek(_daduser[1,10,i],.f.)
               _grupo[i]:=pswret(NIL)
               _cGrupo := _grupo[i,1,2]
            endif
        next
endif

If Alltrim(_cGrupo)$"REPRESENTANTE" 
    dbSelectArea("SC5")
	Set Filter To SC5->C5_VEND1 $ _nomeuser2
Else
    dbSelectArea("SC5")
	Set Filter To
EndIf

RestArea(_aArea)

Return()