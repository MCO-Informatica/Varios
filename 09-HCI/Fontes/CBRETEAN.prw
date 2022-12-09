
#INCLUDE "Protheus.ch"
#Include "TbiConn.ch"
/*
Padrao Zebra
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CBRETEAN  �Autor  �Luiz Enrique        � Data �  10/12/2007 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada referente ao tratamento da leitura de      ���
���          �Etiquetas			                                          ���
�������������������������������������������������������������������������͹��
���Uso       � HCI		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������  
*/ 
User Function CBRETEAN ()
  
  	//Chamado pela funcao CBRetEtiEAN(cID)
	// o retorno devera ser um array conforme abaixo:
	//{codigo do produto,quantidade,lote,data de validade, numero de serie,Lote Fornecedor}
	Local 	cEti     := Paramixb[01]
	Local 	cProd
	Local 	cLote
	Local	cLoteFor
	Local 	aEtique	:= {} 
	
	cProd	:= 	Substr(cEti,1,15)
	cLote	:= 	Substr(cEti,16,10)
	cLoteFor:=	Substr(cEti,26,18)
	
	aEtique	:= {cProd,0,cLote,"","",cLoteFor}	


Return aEtique