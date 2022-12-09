#include "protheus.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � MT410BRW � Autor �     Rafael de Souza     � Data � 08/02/2011 ���
���          �          �       �     MVG Consultoria     �      �            ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Bloqueio do campo c6_prcven(preco unitario) para os Represent. ���
�����������������������������������������������������������������������������Ĵ��
���Observacao� Bloqueio apenas para os representantes                         ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Ricaelle Industria e Comercio Ltda                             ���
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
User Function RFATG11()
Local i:=0
Local _aArea := GetArea()
Local _cGrupo:= ""
Local cMSG:= ""
Local _nValor := aCols[n,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_PRCVEN"  })]
Local _aGrupo := UsrRetGrp(,RetCodUsr())
Local _cGrupo := Iif(__cUserID$"000000","000001",_aGrupo[1])

_nVal :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRUNIT" })]

If Alltrim(_cGrupo)$"000001"
	_nValor :=	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN" })]
	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN" })]	:=_nValor
	//aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCTAB" })]	:=_nValor
	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"  })]	:=A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * _nValor,"C6_VALOR")

Else
	MsgAlert("Usu�rio sem permiss�o para alterar o pre�o de venda.","Aten��o!")
		
	_nValor :=_nVal                                         
	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCVEN" })]	:=_nValor
	//aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_PRCTAB" })]	:=_nValor
	aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_VALOR"  })]	:=A410Arred(aCols[n,aScan(aHeader,{|x| Alltrim(x[2])== "C6_QTDVEN"})] * _nValor,"C6_VALOR")
	
EndIf

RestArea(_aArea)

Return(_nValor)
