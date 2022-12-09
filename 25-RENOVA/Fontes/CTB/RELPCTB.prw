#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELPCTB  ºAutor  ³Microsiga           º Data ³  04/18/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Retorna o conteúdo desejado no LP                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ pLP - Código do LP                                         º±±
±±º          ³ pSeq - Sequencia                                           º±±
±±º          ³ pOPC - Opção = CD-Conta Debito                             º±±
±±º          ³                CC-Conta Credito                            º±±
±±º          ³                VL-Valor                                    º±±
±±º          ³                HS-Historico                                º±±
±±º          ³                1D- Centro de Custo Debito                  º±±
±±º          ³                1C- Centro de Custo Credito                 º±±
±±º          ³                2D- Item Contábil Debito                    º±±
±±º          ³                2C- Item Contábil Credito                   º±±
±±º          ³                3D- Classe de Valor Debito                  º±±
±±º          ³                3C- Classe de Valor Credito                 º±±
±±º          ³                5D- Entidade 5 Debito                       º±±
±±º          ³                5C- Entidade 5 Credito                      º±±
±±º          ³                6D- Entidade 6 Debito                       º±±
±±º          ³                6C- Entidade 6 Credito                      º±±
±±º          ³                7D- Entidade 7 Debito                       º±±
±±º          ³                7C- Entidade 7 Credito                      º±±
±±º          ³                8D- Entidade 8 Debito                       º±±
±±º          ³                8C- Entidade 8 Credito                      º±±
±±º          ³ pPar - Conteudo adicional                                  º±±
±±º          ³ U_LPCTB("610","001","CD","")								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

/*********************************** Contabilização de Retenção de ISS Documento de Entrada*/                          
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

/*********************************** Contabilização de Retenção de INSS Documento de Entrada*/                          
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

/*********************************** Contabilização de Retenção de IRRF Documento de Entrada*/                          
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