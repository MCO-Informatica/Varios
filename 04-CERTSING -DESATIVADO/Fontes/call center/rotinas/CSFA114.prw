#INCLUDE "totvs.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSFA114   � Autor � Renato Ruy      	 � Data �  11/07/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Facilitador de consulta na tela da agenda do operador.	  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign - Agenda do Operador                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSFA114

Local aPergs := {}
Local cCodVou:= Space(12)
Local aRet 	 := {}
Local cMsg 	 := ""
Local lRet 


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


aAdd( aPergs ,{1,"C�digo do Voucher : ",cCodVou,"@!",'.T.',"SZF",'.T.',80,.F.})

If ParamBox(aPergs ,"Parametros ",aRet)      
	SZF->(DbSetOrder(2))
	//Me posiciono no voucher informado.
	If SZF->(DbSeek(xFilial("SZF")+aRet[1]))
		cMsg := "C�digo do Voucher: " + SZF->ZF_COD + CRLF
		cMsg += "Tipo do Voucher: "   + Posicione("SZH",1,xFilial("SZH")+SZF->ZF_TIPOVOU,"ZH_DESCRI") + CRLF
		cMsg += "Saldo: "			  + Transform(SZF->ZF_SALDO,"@E 9999") + CRLF
		
		//Verifica se tem consumo.
        If SZF->ZF_SALDO == 0
        	
        	//verifica se o arquivo est� aberto
        	If Select("BUSVOU") > 0
        		DbselectArea("BUSVOU")
        		BUSVOU->(DbCloseArea())
        	EndIf
        	
        	//busca dados adicionais do voucher.
        	Beginsql Alias "BUSVOU"
        		SELECT ZG_NUMPED, ZG_PEDSITE FROM PROTHEUS.SZG010
				WHERE
				ZG_FILIAL = %xFilial:SZG% AND
				ZG_NUMVOUC = %EXP:AllTrim(SZF->ZF_COD)% AND
				%NotDel%
        	Endsql
        	
			cMsg += "Pedido Gar: "	    + BUSVOU->ZG_NUMPED + CRLF
			cMsg += "Pedido Site: "		+ BUSVOU->ZG_PEDSITE
		EndIf
		
		//Copia conte�do para �rea de transfer�ncia
		CopytoClipboard(cMsg)
		
		MsgInfo(cMsg,"Agenda Certisign")		
	Else
		MsgInfo("O C�digo de voucher n�o foi localizado na base!")
	EndIf
Else
	Alert("Rotina Cancelada!")
EndIf

Return
