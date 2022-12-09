#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � Lucas Pereira      � Data �  11/04/17   ���
�������������������������������������������������������������������������͹��
���Descricao � ponto de entrada meus pedidos ALTERA QUERRY GRUPOS	      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MP_PRDJSON
local aContas 	:= PARAMIXB[1]	// ARRY COM CONTAS
local cFilMp 	:= PARAMIXB[2]	// FILIAL ATIVA
local cCtaMp	:= PARAMIXB[3]  // CODIGO DA CONTA
local nz	 	:= PARAMIXB[4]	// POSI��O DO ACONTAS
local aItem		:= PARAMIXB[5]	// Item
local cFilComp  := FWModeAccess("SB1",3)
local cFilEnt 	:= iif(cFilComp=='E',cFilMp,XFILIAL("SB1")) 
local cCatId	:= ""   
local cObserv	:= ""
local nEstoque  := aItem[8]
local cNcm		:= ""    
local cUMedida	:= aItem[4]  
local cMultiplo := aItem[7]
local cJson
local cCodBar	:= ""

	if SB1->(DBSETORDER(1),DBSEEK(cFilEnt+aItem[9]))
		cCodBar 	:= SB1->(iif(!empty(B1_EAN13), B1_EAN13, B1_UPC12))
		nEstoque 	:= if( nEstoque > SB1->B1_XMPLIM , SB1->B1_XMPLIM , nEstoque )
		cNcm	 	:= SB1->B1_GRTRIB            
		cObserv	 	:= "Codigo Barras: "+alltrim(cCodBar)
		cCatId 	 	:= U_GetIdEnt(cFilMp,cCtaMp,"GRUPO",alltrim(SB1->B1_XGRIFE))  
		cUMedida 	:= SB1->B1_UMRES   
		cMultiplo   := SB1->B1_QTDMULT 
		cAtivo		:= IIF(SB1->B1_XMPATV=='N','false','true')
	endif
	
	IF cAtivo <> "N"
		cJson := '{'
		cJson += '    "codigo": "'+aItem[1]+'",'
		cJson += '    "nome": "'+aItem[2]+'",'
		cJson += '    "comissao": 0,'
		cJson += '    "preco_tabela": '+cvaltochar(aItem[3])+','
		cJson += '    "preco_minimo": '+cvaltochar(aItem[3])+','
		cJson += '    "ipi": '+IIF(!EMPTY(aItem[8]),cvaltochar(aItem[8]),"null")+','
		cJson += '    "tipo_ipi": "P",'
		cJson += '    "st": null,'
		cJson += '    "grade_tamanhos": null,'
		cJson += '    "moeda": "0",'
		cJson += '    "unidade": "'+cUMedida+'",'
	//	cJson += '    "saldo_estoque": '+cvaltochar(nEstoque)+','
		cJson += '    "observacoes": "'+cObserv+'", '
		cJson += '    "codigo_ncm": "' +cNcm+'",'
		cJson += '    "excluido": '+aItem[10]+','
		cJson += '    "ativo": '+cAtivo+',' 
		cJson += '    "categoria_id":'+iif(empty(cCatId)," null",cCatId)+','
		cJson += '    "multiplo":'+ cvaltochar(cMultiplo)
		cJson += '}'  
	ENDIF


Return(cJson)
