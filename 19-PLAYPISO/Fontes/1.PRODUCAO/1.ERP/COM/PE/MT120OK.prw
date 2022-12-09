#INCLUDE "Fileio.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Ponto de  �MT120OK   |Autor  �Cosme da Silva Nunes   |Data  �12/08/2008|��
���Entrada   �          �       �                       �      |          ���
�������������������������������������������������������������������������Ĵ��
���Programa  �MATA120                                                     ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Ponto de Entrada para exibir tela de checkup do custo       ���
���          |standard, esperando a confirma��o do usu�rio.               ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao�Chamada de rotinas personalizada                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Observac. �                                                            ���
�������������������������������������������������������������������������Ĵ��
���           Atualizacoes sofridas desde a constru�ao inicial            ���
�������������������������������������������������������������������������Ĵ��
���Programador �Data      �Motivo da Altera�ao                            ���
�������������������������������������������������������������������������Ĵ��
���Cosme da    |14/08/2008|Soma do valor do IPI para formacao do novo     ���
���Silva Nunes |          |custo standard                                 ���
���	     	   |          |	                                              ���
���	     	   |          |	                                              ���
���	     	   |          |	                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                    
User Function MT120OK()

// Variaveis da Funcao de Controle e GertArea/RestArea
Local lReturn 		:= .T.  
Local _aArea   		:= {}
Local _aAlias  		:= {}
Local unLPC  	:= 0
Local ucProduto := ""
Local unCuStd   := 0
Local unQtd     := 0
Local unPrc     := 0
Local unIPI		:= 0
Local unNovCS   := 0

// Defina aqui a chamada dos Aliases para o GetArea
U_CtrlArea(1,@_aArea,@_aAlias,{"SA2","SA5","SB1","SB2","SB5","SC1","SC3","SC7","SC8","SCR","SCY","SE4","SF4","SY1","SX5"}) // GetArea

For unLPC := 1 To Len(Acols)

    If !aCols[unLPC][Len(aHeader)+1] //If para nao pegar deletados
		ucProduto := aCols[unLPC, Ascan(aHeader,{|x|AllTrim(x[2])=="C7_PRODUTO"})]
		unCuStd   := Posicione("SB1",1,xFilial("SB1")+ucProduto,"B1_CUSTD")
		unQtd	  := aCols[unLPC, Ascan(aHeader,{|x|AllTrim(x[2])=="C7_QUANT"})]		
		unPrc	  := aCols[unLPC, Ascan(aHeader,{|x|AllTrim(x[2])=="C7_PRECO"})]
		unIPI	  := aCols[unLPC, Ascan(aHeader,{|x|AllTrim(x[2])=="C7_VALIPI"})]
		unNovCS	  := (unPrc + (unIPI / unQtd)) //(Preco + (Valor do IPI / Quantidade))
		
		U_RCOMM01(ucProduto,unCuStd,unNovCS)
	Endif
	
Next

U_CtrlArea(2,_aArea,_aAlias) // RestArea

Return(lReturn)