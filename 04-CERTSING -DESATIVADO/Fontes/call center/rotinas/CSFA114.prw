#INCLUDE "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSFA114   º Autor ³ Renato Ruy      	 º Data ³  11/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Facilitador de consulta na tela da agenda do operador.	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign - Agenda do Operador                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSFA114

Local aPergs := {}
Local cCodVou:= Space(12)
Local aRet 	 := {}
Local cMsg 	 := ""
Local lRet 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


aAdd( aPergs ,{1,"Código do Voucher : ",cCodVou,"@!",'.T.',"SZF",'.T.',80,.F.})

If ParamBox(aPergs ,"Parametros ",aRet)      
	SZF->(DbSetOrder(2))
	//Me posiciono no voucher informado.
	If SZF->(DbSeek(xFilial("SZF")+aRet[1]))
		cMsg := "Código do Voucher: " + SZF->ZF_COD + CRLF
		cMsg += "Tipo do Voucher: "   + Posicione("SZH",1,xFilial("SZH")+SZF->ZF_TIPOVOU,"ZH_DESCRI") + CRLF
		cMsg += "Saldo: "			  + Transform(SZF->ZF_SALDO,"@E 9999") + CRLF
		
		//Verifica se tem consumo.
        If SZF->ZF_SALDO == 0
        	
        	//verifica se o arquivo está aberto
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
		
		//Copia conteúdo para área de transferência
		CopytoClipboard(cMsg)
		
		MsgInfo(cMsg,"Agenda Certisign")		
	Else
		MsgInfo("O Código de voucher não foi localizado na base!")
	EndIf
Else
	Alert("Rotina Cancelada!")
EndIf

Return
