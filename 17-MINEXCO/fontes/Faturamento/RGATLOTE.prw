#Include "PROTHEUS.CH"        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RGATLOTE �Autor  � Daniel Salese      � Data �  13/03/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para Lote (Utilizavel em tablets)                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Minexco                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RGATLOTE()      

nPosLote        := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE"})
nPosLotCtl      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"})
nPosDValid      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DTVALID"})
nPosPotenc      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_POTENCI"})   
nPosCod         := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})   
nPosLocal       := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})   
F4Lote(,,,"A440",aCols[n,nPosCod],aCols[n,nPosLocal])
	
Return(aCols[n,nPosLotCtl])