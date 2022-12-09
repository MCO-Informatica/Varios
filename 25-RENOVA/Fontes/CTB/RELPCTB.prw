#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RELPCTB  �Autor  �Microsiga           � Data �  04/18/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Retorna o conte�do desejado no LP                         ���
�������������������������������������������������������������������������͹��
���Parametros� pLP - C�digo do LP                                         ���
���          � pSeq - Sequencia                                           ���
���          � pOPC - Op��o = CD-Conta Debito                             ���
���          �                CC-Conta Credito                            ���
���          �                VL-Valor                                    ���
���          �                HS-Historico                                ���
���          �                1D- Centro de Custo Debito                  ���
���          �                1C- Centro de Custo Credito                 ���
���          �                2D- Item Cont�bil Debito                    ���
���          �                2C- Item Cont�bil Credito                   ���
���          �                3D- Classe de Valor Debito                  ���
���          �                3C- Classe de Valor Credito                 ���
���          �                5D- Entidade 5 Debito                       ���
���          �                5C- Entidade 5 Credito                      ���
���          �                6D- Entidade 6 Debito                       ���
���          �                6C- Entidade 6 Credito                      ���
���          �                7D- Entidade 7 Debito                       ���
���          �                7C- Entidade 7 Credito                      ���
���          �                8D- Entidade 8 Debito                       ���
���          �                8C- Entidade 8 Credito                      ���
���          � pPar - Conteudo adicional                                  ���
���          � U_LPCTB("610","001","CD","")								  ���
�������������������������������������������������������������������������͹��
���Uso       � Renova                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION LPCTB(pLP, pSEQ, pOPC, pPAR)
LOCAL _RET
LOCAL aAREA := GETAREA()

PRIVATE cLP := IF(VALTYPE(pLP)=="C" ,pLP ,"")
PRIVATE cSEQ:= IF(VALTYPE(pSEQ)=="C",pSEQ,"")
PRIVATE cOPC:= IF(VALTYPE(pOPC)=="C",pOPC,"")
PRIVATE cPAR:= IF(VALTYPE(pPAR)=="C",pPAR,"")

IF EMPTY(cLP)
	RETURN("")
ENDIF


DO CASE
	CASE cLP == "660" .and. cSEQ == "001"
		_RET := _LP660001()		
	CASE cLP == "660" .and. cSEQ == "002"
		_RET := _LP660002()		
	CASE cLP == "660" .and. cSEQ == "003"
		_RET := _LP660003()   
	CASE cLP == "665" .and. cSEQ == "015"    
		_RET := _LP660004() 
ENDCASE

RESTAREA(aAREA)

RETURN(_RET)

/*********************************** Contabiliza��o de Reten��o de ISS Documento de Entrada*/                          
Static Function _LP660001()

Local xRET := 0
Local _E2TMP1  := GetNextAlias()	//CriaTrab(nil,.F.)	//GetNextAlias()

Do Case
	CASE cOPC == "VL"
			
			IF ALLTRIM(SF4->F4_DUPLIC)='S'
				
				_cQuery := " SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_FORNECE, E2_LOJA, E2_TIPO, E2_VALOR, E2_ISS FROM "+ RetsqlName("SE2")
				_cQuery += " WHERE E2_FILIAL = '"+xFilial("SF1")+ "'"
				_cQuery += " AND E2_PREFIXO = '"+SF1->F1_SERIE+ "'"
				_cQuery += " AND E2_NUM = '"+SF1->F1_DOC+ "'"
				_cQuery += " AND E2_FORNECE = '"+SF1->F1_FORNECE+ "'"
				_cQuery += " AND E2_LOJA = '"+SF1->F1_LOJA+ "'"
				_cQuery += " AND E2_TIPO = 'NF'"
				_cQuery += " AND D_E_L_E_T_ <> '*'"
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_E2TMP1,.T.,.T.)
				
				DbSelectArea(_E2TMP1)
				(_E2TMP1)->(DbGotop())
				
				xRet := (_E2TMP1)->E2_ISS
				
				(_E2TMP1)->(DbCloseArea())
				
			EndIf
			
EndCase

Return(xRet)

/*********************************** Contabiliza��o de Reten��o de INSS Documento de Entrada*/                          
Static Function _LP660002()

Local xRET := 0
Local _E2TMP2  := GetNextAlias()	//CriaTrab(nil,.F.)	//GetNextAlias()

Do Case
	CASE cOPC == "VL" 
		IF ALLTRIM(SF4->F4_DUPLIC)='S'

			_cQuery := " SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_FORNECE, E2_LOJA, E2_TIPO, E2_VALOR, E2_INSS FROM "+ RetsqlName("SE2")
			_cQuery += " WHERE E2_FILIAL = '"+xFilial("SF1")+ "'"
			_cQuery += " AND E2_PREFIXO = '"+SF1->F1_SERIE+ "'"
			_cQuery += " AND E2_NUM = '"+SF1->F1_DOC+ "'"
			_cQuery += " AND E2_FORNECE = '"+SF1->F1_FORNECE+ "'"
			_cQuery += " AND E2_LOJA = '"+SF1->F1_LOJA+ "'"
			_cQuery += " AND E2_TIPO = 'NF'"
			_cQuery += " AND D_E_L_E_T_ <> '*'"
	
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_E2TMP2,.T.,.T.)
	
			DbSelectArea(_E2TMP2)
			(_E2TMP2)->(DbGotop())
	
			xRet := (_E2TMP2)->E2_INSS
	
			(_E2TMP2)->(DbCloseArea())
	
		EndIf
EndCase            

Return(xRet)

/*********************************** Contabiliza��o de Reten��o de IRRF Documento de Entrada*/                          
Static Function _LP660003()

Local xRET := 0
Local _E2TMP3  := GetNextAlias()	//CriaTrab(nil,.F.)	//GetNextAlias()

Do Case
	CASE cOPC == "VL" 
		IF ALLTRIM(SF4->F4_DUPLIC)='S'

			_cQuery := " SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_FORNECE, E2_LOJA, E2_TIPO, E2_VALOR, E2_IRRF FROM "+ RetsqlName("SE2")
			_cQuery += " WHERE E2_FILIAL = '"+xFilial("SF1")+ "'"
			_cQuery += " AND E2_PREFIXO = '"+SF1->F1_SERIE+ "'"
			_cQuery += " AND E2_NUM = '"+SF1->F1_DOC+ "'"
			_cQuery += " AND E2_FORNECE = '"+SF1->F1_FORNECE+ "'"
			_cQuery += " AND E2_LOJA = '"+SF1->F1_LOJA+ "'"
			_cQuery += " AND E2_TIPO = 'NF'"
			_cQuery += " AND D_E_L_E_T_ <> '*'"
	
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_E2TMP3,.T.,.T.)
	
			DbSelectArea(_E2TMP3)
			(_E2TMP3)->(DbGotop())
	
			(_E2TMP3)->(DbCloseArea())
	
		EndIf
EndCase            

Return(xRet) 

//////////////////****** CONTABILIZACAO DO FORNECEDOR LP 665-015

Static Function _LP660004()

Local xRET := 0
Local _E2TMP4  := GetNextAlias()	//CriaTrab(nil,.F.)	//GetNextAlias()

Do Case
	CASE cOPC == "VL" 
		IF ALLTRIM(SF4->F4_DUPLIC)='S'

			_cQuery := " SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_FORNECE, E2_LOJA, E2_TIPO, E2_VALOR, E2_IRRF FROM "+ RetsqlName("SE2")
			_cQuery += " WHERE E2_FILIAL = '"+xFilial("SF1")+ "'"
			_cQuery += " AND E2_PREFIXO = '"+SF1->F1_SERIE+ "'"
			_cQuery += " AND E2_NUM = '"+SF1->F1_DOC+ "'"
			_cQuery += " AND E2_FORNECE = '"+SF1->F1_FORNECE+ "'"
			_cQuery += " AND E2_LOJA = '"+SF1->F1_LOJA+ "'"
			_cQuery += " AND E2_TIPO = 'NF'"
			_cQuery += " AND D_E_L_E_T_ <> '*'"
	
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_E2TMP4,.T.,.T.)
	
			DbSelectArea(_E2TMP4)
			(_E2TMP4)->(DbGotop())
	
			xRet := (_E2TMP4)->E2_VALOR
	
			(_E2TMP4)->(DbCloseArea())
	
		EndIf
EndCase            

Return(xRet)