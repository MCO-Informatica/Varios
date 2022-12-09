
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK271COR  ºAutor  ³Nelson Junior       º Data ³  15/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE para alteração das cores do MBROWSE na tela de Call      º±±
±±º          ³Center.                                                     º±± 
±±º Alterado Por:| Danilo Alves Del Busso 				|Data: 31/07/2015 º±± 	  
±±º Descriação:	 | Ajustadas as condições da variavel aCores para exibir  º±± 
±±º	tambem as legendas para códigos de bloqueio por REGRA e VERBA		  º±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Tk271Cor(cPasta)

Local aArea  := GetArea()
Local aCores := {}

If cPasta == "2" //Televendas
	//   
	_cCorBlq := "POSICIONE('SC5',1,XFILIAL('SC5')+SUA->UA_NUMSC5,'C5_BLQ')" 
	_cUsrLib1 := "POSICIONE('SC5',1,XFILIAL('SC5')+SUA->UA_NUMSC5,'C5_VQ_USL1')"    
	_cBlCred := "POSICIONE('SC9',1,XFILIAL('SC9')+SUA->UA_NUMSC5,'C9_BLCRED')"
	_cBlEst  := "POSICIONE('SC9',1,XFILIAL('SC9')+SUA->UA_NUMSC5,'C9_BLEST')"
	//
		aCores := { {"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. Empty(SUA->UA_DOC)) .AND. Empty("+_cCorBlq+") .AND. U_DBVPCRED()", "BR_LARANJA"	},; // Bloqueado por Regra - LARANJA		  
					{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. Empty(SUA->UA_DOC)) .AND. Empty("+_cCorBlq+") .AND. U_DBVPATEN()"	 , "BR_AMARELO"	},; // Bloqueado por Estoque
					{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. Empty(SUA->UA_DOC)) .AND. ("+_cCorBlq+"=='1' .OR. Empty("+_cUsrLib1+")) "	 , "BR_PINK"	},; // Bloqueado por Regra - ROSA
					{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. Empty(SUA->UA_DOC)) .AND. Empty("+_cCorBlq+")"	 , "BR_VERDE"	},; // Faturamento - VERDE
					{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 1 .AND. !Empty(SUA->UA_DOC))"							 , "BR_VERMELHO"},; // Faturado - VERMELHO
   					{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 2)"													 , "BR_AZUL"	},;	// Orcamento - AZUL
   					{"(EMPTY(SUA->UA_CODCANC) .AND. VAL(SUA->UA_OPER) == 3)"		 											 , "BR_MARRON"	},; // Atendimento - MARRON
   					{"(!EMPTY(SUA->UA_CODCANC))"																				 , "BR_PRETO"	}}  // Cancelado - PRETO
	//
EndIf

RestArea(aArea)

Return(aCores)


                  
User Function DBVPCRED()   
Local lRet := .F.

DbSelectArea("SC9"); DbSetOrder(1)
If SC9->(DbSeek(xFilial("SC9")+SUA->UA_NUMSC5))
     While !EoF() .AND. SC9->C9_PEDIDO = SUA->UA_NUMSC5
     		If AllTrim(SC9->C9_BLCRED) $ '01/02/04/05/06/09'
     			lRet := .T.
     		EndIf
     	DbSkip()
     EndDo
EndIf


Return lRet


User Function DBVPATEN()
Local lRet := .F.
         
DbSelectArea("SC9"); DbSetOrder(1)
If SC9->(DbSeek(xFilial("SC9")+SUA->UA_NUMSC5))
     While !EoF() .AND. SC9->C9_PEDIDO = SUA->UA_NUMSC5
     		If AllTrim(SC9->C9_BLEST) $ '02/03'
     			lRet := .T.
     		EndIf
     	DbSkip()
     EndDo
EndIf

Return lRet
