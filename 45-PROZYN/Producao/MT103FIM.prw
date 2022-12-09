#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA |MT103FIM  | AUTOR | Nadia Calcic 		          	|USERS    |     	  | DATA | 07/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO| PE para verificar o TES de cada item e acertar o SB2									    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|                        ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|PROGRAMADOR | DATA   |  CHAMADO  |MOTIVO DA ALTERACAO                                                |±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                        
User Function MT103FIM()
Local nOpcNF   		:= PARAMIXB[1]    
Local cChvPesq 		:= SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
Local aAreaD1  		:= SD1->(GetArea())
Local nConfirma 	:= PARAMIXB[2]

If SF1->F1_TIPO == 'N' .And. nOpcNF == 3 .And. nConfirma == 1 
	dbSelectArea('SB2')
	SB2->(dbSetOrder(1)) 

	dbSelectArea('SF4')
	SF4->(dbSetOrder(1)) 
	
	dbSelectArea('SD1')
	SD1->(dbSetOrder(1)) 
	SD1->(dbSeek(xFilial('SD1')+cChvPesq))
	
	While SD1->(!Eof()) .And. SD1->D1_FILIAL == xFilial('SD1') .And. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == cChvPesq 
		If SF4->(dbSeek(xFilial('SF4')+SD1->D1_TES)) .And. SF4->F4_YTRANCQ == 'S'
			If SB2->(dbSeek(xFilial('SB2')+SD1->D1_COD+SD1->D1_LOCAL))
				RecLock('SB2',.F.)
				SB2->B2_YTRANCQ  += SD1->D1_QUANT 
				SB2->(msUnLock())
			EndIf	
		EndIf
		
		//Atualiza a data de fabricação do produto
		If !Empty(SD1->D1_LOTECTL) .And. !Empty(SD1->D1_FABRIC)
			U_PZCVA005(SD1->D1_COD, SD1->D1_LOCAL, SD1->D1_LOTECTL, SD1->D1_NUMLOTE, SD1->D1_FABRIC)
		EndIf 
		
		SD1->(dbSkip()) 
	EndDo

EndIf

//Envia da devolução por e-mail
If UPPER(Alltrim(SF1->F1_TIPO)) == 'D' .And. nOpcNF == 3 .And. nConfirma == 1
	U_PZCVRM05(SF1->F1_DTDIGIT, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA ) 
EndIf

//Atualiza a natureza na tabela SF1
If nOpcNF == 3 .And. nConfirma == 1
	//Preenchimento da natureza no documento de entrada
	cNat :=	Posicione("SE2",6,xFilial("SE2") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC,"E2_NATUREZ")
	RecLock("SF1",.F.)
	SF1->F1_YNATURE := ALLTRIM(cNat)
	SF1->(MsUnlock())	

	//Impressao de etiqueta de recebimento
	U_PZCVR010(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA)

	//Dados complementares da importação
	U_PZCVA009(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA)

EndIf

//Atualiza a descrição da natureza no titulo financeiro
AtuDNatE2(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA)

//Atualiza o C.Custo na tabela SE2
AtuCCE2(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA)

RestArea(aAreaD1)
Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AtuDNatE2		ºAutor  ³Microsiga	     º Data ³  04/07/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza a descrição da natureza na tabela SE2			  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuDNatE2(cDoc, cSerie, cCodFor, cLoja)

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()

Default cDoc	:= "" 
Default cSerie	:= "" 
Default cCodFor	:= "" 
Default cLoja	:= ""

cQuery := " SELECT SE2.R_E_C_N_O_ RECSE2 FROM "+RetSqlName("SF1")+" SF1 "+CRLF

cQuery += " INNER JOIN "+RetSqlName("SE2")+" SE2 "+CRLF
cQuery += " ON SE2.E2_FILIAL = SF1.F1_FILIAL "+CRLF
cQuery += " AND SE2.E2_PREFIXO = SF1.F1_PREFIXO "+CRLF
cQuery += " AND SE2.E2_NUM = SF1.F1_DUPL "+CRLF
cQuery += " AND SE2.E2_FORNECE = SF1.F1_FORNECE "+CRLF
cQuery += " AND SE2.E2_LOJA = SF1.F1_LOJA "+CRLF
cQuery += " AND SE2.D_E_L_E_T_ = ' ' "+CRLF

cQuery += " WHERE SF1.F1_FILIAL = '"+xFilial("SE2")+"' "+CRLF
cQuery += " AND SF1.F1_DOC = '"+cDoc+"' "+CRLF
cQuery += " AND SF1.F1_SERIE = '"+cSerie+"' "+CRLF
cQuery += " AND SF1.F1_FORNECE = '"+cCodFor+"' "+CRLF
cQuery += " AND SF1.F1_LOJA = '"+cLoja+"' "+CRLF
cQuery += " AND SF1.D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

DbSelectArea("SE2")
DbSetOrder(1)
While (cArqTmp)->(!Eof())
	
	SE2->(DbGoTo((cArqTmp)->RECSE2))
	
	SE2->(RecLock("SE2", .F.))
	SE2->E2_YDESNAT := Posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"ED_DESCRIC")
	SE2->(MsUnLock())
	
	(cArqTmp)->(DbSkip())
EndDo

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AtuCCE2		ºAutor  ³Microsiga	     º Data ³  01/11/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza centro de custo na tabela SE2					  º±±
±±º          ³												              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ap		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuCCE2(cDoc, cSerie, cCodFor, cLoja) 

Local aArea	:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()


Default cDoc	:= "" 
Default cSerie	:= "" 
Default cCodFor	:= "" 
Default cLoja	:= ""

cQuery	:= " SELECT D1_DOC, D1_SERIE, D1_CC, CTT_DESC01, SE2.R_E_C_N_O_ RECSE2 FROM "+RetSqlName("SD1")+" SD1 "+CRLF

cQuery	+= " INNER JOIN "+RetSqlName("SF1")+" SF1 "+CRLF
cQuery	+= " ON SF1.F1_FILIAL = SD1.D1_FILIAL "+CRLF
cQuery	+= " AND SF1.F1_DOC = SD1.D1_DOC "+CRLF
cQuery	+= " AND SF1.F1_SERIE = SD1.D1_SERIE "+CRLF
cQuery	+= " AND SF1.F1_FORNECE = SD1.D1_FORNECE "+CRLF
cQuery	+= " AND SF1.F1_LOJA = SD1.D1_LOJA "+CRLF
cQuery	+= " AND SF1.D_E_L_E_T_ = ' ' "+CRLF

cQuery	+= " INNER JOIN "+RetSqlName("CTT")+" CTT "+CRLF
cQuery	+= " ON CTT.CTT_FILIAL = '"+xFilial("CTT")+"' "+CRLF
cQuery	+= " AND CTT.CTT_CUSTO = SD1.D1_CC "+CRLF
cQuery	+= " AND CTT.D_E_L_E_T_ = ' ' "+CRLF

cQuery	+= " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF
cQuery	+= " ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+CRLF
cQuery	+= " AND SF4.F4_CODIGO = SD1.D1_TES "+CRLF
cQuery	+= " AND SF4.F4_DUPLIC = 'S' "+CRLF
cQuery	+= " AND SF4.D_E_L_E_T_ = ' ' "+CRLF

cQuery	+= " INNER JOIN "+RetSqlName("SE2")+" SE2 "+CRLF
cQuery	+= " ON SE2.E2_FILIAL = '"+xFilial("SE2")+"' "+CRLF
cQuery	+= " AND SE2.E2_PREFIXO = SF1.F1_PREFIXO "+CRLF
cQuery	+= " AND SE2.E2_NUM = SF1.F1_DUPL "+CRLF
cQuery	+= " AND SE2.E2_FORNECE = SF1.F1_FORNECE "+CRLF
cQuery	+= " AND SE2.E2_LOJA = SF1.F1_LOJA "+CRLF
cQuery	+= " AND SE2.E2_CCUSTO = '' "+CRLF
cQuery	+= " AND SE2.D_E_L_E_T_ = ' ' "+CRLF

cQuery	+= " WHERE SD1.D1_FILIAL = '"+xFilial("SE2")+"' "+CRLF
cQuery	+= " AND SD1.D1_DOC = '"+cDoc+"' "+CRLF
cQuery	+= " AND SD1.D1_SERIE = '"+cSerie+"' "+CRLF
cQuery	+= " AND SD1.D1_FORNECE = '"+cCodFor+"' "+CRLF
cQuery	+= " AND SD1.D1_LOJA = '"+cLoja+"' "+CRLF
cQuery	+= " AND SD1.D1_TIPO != 'D' "+CRLF
cQuery	+= " AND SD1.D_E_L_E_T_ = ' ' "+CRLF

//Será atualizado o C.Custo na tabela SE2 senão houver C.Custo diferente nos itens do documento de entrada
cQuery	+= " AND (SELECT COUNT(DISTINCT D1_CC) CONTADOR FROM "+RetSqlName("SD1")+" SD1_2 "+CRLF
cQuery	+= " 	WHERE SD1_2.D1_FILIAL= SD1.D1_FILIAL "+CRLF
cQuery	+= " 	AND SD1_2.D1_DOC = SD1.D1_DOC " +CRLF
cQuery	+= " 	AND SD1_2.D1_SERIE = SD1.D1_SERIE "+CRLF
cQuery	+= " 	AND SD1_2.D1_FORNECE = SD1.D1_FORNECE "+CRLF
cQuery	+= " 	AND SD1_2.D1_LOJA = SD1.D1_LOJA "+CRLF
cQuery	+= " 	AND SD1_2.D_E_L_E_T_ = ' ' "+CRLF
cQuery	+= " 	 ) =1 "+CRLF
cQuery	+= " ORDER BY D1_DOC, D1_SERIE "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

DbSelectArea("SE2")
DbSetOrder(1)
While (cArqTmp)->(!Eof())
	
	SE2->(DbGoTo((cArqTmp)->RECSE2))
	
	SE2->(RecLock("SE2", .F.))
	SE2->E2_CCUSTO	:= (cArqTmp)->D1_CC 
	SE2->E2_YDESCCU	:= (cArqTmp)->CTT_DESC01
	SE2->(MsUnLock())
	
	(cArqTmp)->(DbSkip())
EndDo


If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return
