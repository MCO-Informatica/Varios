#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFIMPORT  �Autor  �Microsiga           � Data �  08/15/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Nota Fiscal Importa��o                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Verion                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LIXO()


_aCab1 :={ 	{"F1_FILIAL"	 	, xFilial("SF1"),NIL},;
			{"F1_TIPO"		 	, "N"			,NIL},;
		   	{"F1_FORMUL"	 	, "N"			,NIL},;
		   	{"F1_DOC"		 	, "112233"  	,NIL},;
			{"F1_SERIE"		 	, "111"			,NIL},;
			{"F1_EMISSAO"	 	, dDataBase		,NIL},;
	    	{"F1_FORNECE"	 	, "001"      	,NIL},;		
	    	{"F1_LOJA"	     	, "01"        	,NIL},;		
	    	{"F1_ESPECIE"	 	, "SPED"   		,NIL}}


	_aItem1 := {}
	_aItens  := {}
	AADD(_aItem1,{"D1_FILIAL"		,xFilial("SD1")		,NIL})
	AADD(_aItem1,{"SD1->D1_ITEM"	,"0001"	,NIL})
	AADD(_aItem1,{"SD1->D1_COD"		,"001"		,NIL})
	AADD(_aItem1,{"SD1->D1_QUANT"	,1			,NIL})
	AADD(_aItem1,{"SD1->D1_VUNIT"	,1,NIL})
	AADD(_aItem1,{"SD1->D1_TOTAL"	,1,NIL})
	AADD(_aItem1,{"SD1->D1_TES"	,"254",NIL}) // com ipi, COM majora��o
	aAdd(_aItens,_aItem1)
	
	lMsErroAuto := .F.                 
	lMostra     := .T.
	MATA103(_aCab1,_aItens,3,lMostra)   

	If lMsErroAuto
		Mostraerro()
		DisarmTransaction()
		break             
	EndIf

	
Return
