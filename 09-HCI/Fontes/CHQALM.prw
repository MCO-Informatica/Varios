#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CHQALM    �Autor  �ROBSON BUENO        � Data �  19/03/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para Verificacao e cadastro de Almoxarifado        ���
���          �com base em demanda                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CHQALM()             
  Local aAreaAtu	:= GetArea()
  Local nPProduto	:= aScan(aHeader,{|x| Trim(x[2]) == "C6_PRODUTO"} )
  Local nPAlmo  	:= aScan(aHeader,{|x| Trim(x[2]) == "C6_LOCAL"} )
  Local lRet		:=.T.
  dbSelectArea("SB2")
  cEntr		:=xfilial("SB2")
  dbSetOrder(1)
  If !MsSeek(cEntr+aCols[n,nPProduto]+aCols[n,nPAlmo],.F.)
	TONE(3500,1)
    If MsgYesNo("Deseja Criar Almoxarifado:-->"+ aCols[n,nPAlmo] + "   Para o Produto:-->" +aCols[n,nPProduto]) 
      CriaSB2(aCols[n,nPProduto],aCols[n,nPAlmo],cEntr)
	Else
	  lRet:=.F.
	EndIf             
  EndIf	
  RestArea(aAreaAtu)

Return lRet 
                    
 