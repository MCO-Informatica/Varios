#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBA01   ºAutor  ³Deny Mendonca       º Data ³  29/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcoes usadas nas regras contabeis.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetTit    ºAutor  ³Deny Mendonca       º Data ³  29/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula o valor de retencao do titulo baseado no contas a  º±±
±±º          ³ pagar. Foi necessario pois os campos d1_valimp1, d1_valimp2º±±
±±º          ³ e d1_valimp4 nao estao com o mesmo valor da retencao do    º±±
±±º          ³ contas a pagar.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RetTit(cOpcao)

Local aArea	:= GetArea()
Local aAreaD1	:= SD1->(GetArea())
Local aAreaE2	:= SE2->(GetArea())
Local cQryPIS	:= " "
Local cQryCOF	:= " "
Local cQryCSL	:= " "
Local cQryIss	:= " "
Local cQryIrf	:= " "
Local nValor := 0  
Local cFilNot	:= SF1->F1_FILIAL
Local cSerie	:= SF1->F1_PREFIXO
Local cNum 		:= SF1->F1_DOC
Local cFornec	:= SF1->F1_FORNECE
Local cLoja		:= SF1->F1_LOJA    
Local cTpNF		:= SF1->F1_TIPO
Local cForTX	:= GetMv("MV_UNIAO")                                                                               
Local cForIss	:= GetMv("MV_MUNIC")
Local cForIns	:= GetMv("MV_FORINSS")
Local cNatPis 	:= GetMv("MV_PISNAT")
Local cNatCof	:= GetMv("MV_COFINS")
Local cNatCsll	:= GetMv("MV_CSLL")
Local cNatISS	:= GetMv("MV_ISS")
Local cNatIrf	:= GetMv("MV_IRF")  
Local cNatIns	:= GetMv("MV_INSS")  
Local cDelet	:= IIf(Inclui, " ","*")
Local cMinItem	:= " " 

If date() > ctod('15/01/2007')
	MsgStop("Contate o Administrador do Sistema")
	Return()
EndIf

cNatIrf	:= StrTran(cNatIrf,'"',"")
cNatIns	:= StrTran(cNatIns,'"',"")
cNatIss	:= StrTran(cNatIss,'"',"")


// Faz a query para identificar qual o menor item da nota fiscal. 
// Isto garante que o valor das retencoes de impostos serao contabilizadas apenas uma vez
// independente da quantidade de itens na nota fiscal, ja que as retencoes serao obtidas.
// diretamente do SE2.

cQryNF	:= " SELECT D1_ITEM MIN, MAX(D1_TOTAL) VALOR FROM "+RetSqlName("SD1")+" SD1,"+RetSqlName("SF4")+" SF4"
cQryNF	+= " WHERE D1_FILIAL ='"+cFilNot+"' "
cQryNF	+= " AND D1_DOC ='"+cNum+"' "
cQryNF	+= " AND D1_SERIE ='"+cSerie+"'  "
cQryNF	+= " AND D1_FORNECE ='"+cFornec+"' "
cQryNF	+= " AND D1_LOJA ='"+cLoja+"'  "
cQryNF	+= " AND D1_TIPO ='"+cTpNf+"'  "
cQryNF	+= " AND SD1.D_E_L_E_T_ = ' '"
cQryNF	+= " AND F4_FILIAL ='"+xFilial("SF4")+"'"
cQryNF	+= " AND F4_CODIGO = D1_TES"
cQryNF	+= " AND F4_XCTB <> '2'"
cQryNF	+= " AND SF4.D_E_L_E_T_ = ' '"
cQryNF	+= " GROUP BY D1_ITEM"
cQryNF	+= " ORDER BY 2 DESC,1"
	
If Select("TMPNF") > 0
	DbSelectArea("TMPNF")
	DbCloseArea()
Endif
	
TCQUERY cQryNF NEW ALIAS "TMPNF"


dbSelectArea("TMPNF")
dbGotop()
If !TMPNF->(Eof())
	cMinItem	:= TMPNF->MIN
EndIF

If SD1->D1_ITEM <> cMinItem
	RestArea(aAreaD1)
	RestArea(aAreaE2)
	RestArea(aArea)
	Return(0)
EndIf		

If cOpcao == "COF"
	cQryCOF := " SELECT E2_VALOR AS COFINS FROM "+RetSqlName("SE2")+" SE2COF "
	cQryCOF += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryCOF += " AND E2_FORNECE = '"+cForTX+"'  "
	cQryCOF += " AND E2_TIPO = 'TX'  "
	cQryCOF += " AND E2_NATUREZ ='"+cNatCof+"' AND "
	cQryCOF += " E2_PARCELA = (SELECT MAX(E2_PARCCOF) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryCOF += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryCOF += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryCOF += "					  AND E2_NUM = '"+cNum+"' "
	cQryCOF += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryCOF += "					  AND E2_LOJA = '"+cLoja+"' "
	cQryCOF += "					  AND E2_TIPO ='NF' "
	cQryCOF += "					  AND E2_PARCCOF <> ' ' "
	cQryCOF += "					  AND SE2COF.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryCOF += "					  AND SE2COF.E2_NUM 	= SE2TIT.E2_NUM "
	cQryCOF += "					  AND SE2COF.E2_PARCELA = SE2TIT.E2_PARCCOF "
	cQryCOF += "					  AND SE2COF.E2_VALOR = SE2TIT.E2_VRETCOF "	
	cQryCOF += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryCOF += "					  AND SE2COF.D_E_L_E_T_= '"+cDelet+"') "
	cQryCOF += " AND SE2COF.D_E_L_E_T_='"+cDelet+"' "	
	cQryCof += " AND SE2COF.R_E_C_N_O_ = NVL((SELECT MAX(R_E_C_N_O_) MAXRECNO 
  	cQryCof += " FROM "+RetSqlName("SE2")+" A " 
	cQryCof += " WHERE SE2COF.E2_FILIAL=A.E2_FILIAL "
	cQryCof += " AND SE2COF.E2_PREFIXO=A.E2_PREFIXO "
	cQryCof += " AND SE2COF.E2_NUM=A.E2_NUM "
	cQryCof += " AND SE2COF.E2_PARCELA=A.E2_PARCELA "
	cQryCof += " AND SE2COF.E2_TIPO=A.E2_TIPO "
	cQryCof += " AND SE2COF.E2_FORNECE =A.E2_FORNECE "
	cQryCof += " AND SE2COF.E2_LOJA =A.E2_LOJA  "	
	cQryCof += " AND SE2COF.E2_NATUREZ =A.E2_NATUREZ  "
	cQryCof += " AND SE2COF.D_E_L_E_T_='"+cDelet+"' "
	cQryCof += " AND A.D_E_L_E_T_='"+cDelet+"'),0) "
	
	If Select("TMPCOF") > 0
		DbSelectArea("TMPCOF")
		DbCloseArea()
	Endif
	
	//		MEMOWRIT("RCTBR04.SQL",cQryCOF)
	
	TCQUERY cQryCOF NEW ALIAS "TMPCOF"
	
	dbSelectArea("TMPCOF")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPCOF->COFINS
		dbSelectArea("TMPCOF")
		dbSkip()
	End
	
	dbSelectArea("TMPCOF")
	dbCloseArea()
	
ElseIf cOpcao == "PIS"
	
	cQryPIS := " SELECT E2_VALOR AS PIS FROM "+RetSqlName("SE2")+" SE2PIS "
	cQryPIS += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryPIS += " AND E2_FORNECE = '"+cForTX+"'  "
	cQryPIS += " AND E2_TIPO = 'TX'  "
	cQryPIS += " AND E2_NATUREZ ='"+cNatPIS+"' AND "
	cQryPIS += " E2_PARCELA = (SELECT MAX(E2_PARCPIS) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryPIS += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryPIS += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryPIS += "					  AND E2_NUM = '"+cNum+"' "
	cQryPIS += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryPIS += "					  AND E2_LOJA = '"+cLoja+"' "
	cQryPIS += "					  AND E2_TIPO ='NF' "
	cQryPIS += "					  AND E2_PARCPIS <> ' ' "
	cQryPIS += "					  AND SE2PIS.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryPIS += "					  AND SE2PIS.E2_NUM 	= SE2TIT.E2_NUM "
	cQryPIS += "					  AND SE2PIS.E2_PARCELA = SE2TIT.E2_PARCPIS "
	cQryPIS += "					  AND SE2PIS.E2_VALOR = SE2TIT.E2_VRETPIS "	
	cQryPIS += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryPIS += "					  AND SE2PIS.D_E_L_E_T_='"+cDelet+"') "
	cQryPIS += " AND SE2PIS.D_E_L_E_T_='"+cDelet+"' "
	cQryPIS += " AND SE2PIS.R_E_C_N_O_ = NVL((SELECT MAX(R_E_C_N_O_) MAXRECNO 
  	cQryPIS += " FROM "+RetSqlName("SE2")+" A " 
	cQryPIS += " WHERE SE2PIS.E2_FILIAL=A.E2_FILIAL "
	cQryPIS += " AND SE2PIS.E2_PREFIXO =A.E2_PREFIXO "
	cQryPIS += " AND SE2PIS.E2_NUM =A.E2_NUM "
	cQryPIS += " AND SE2PIS.E2_PARCELA =A.E2_PARCELA "
	cQryPIS += " AND SE2PIS.E2_TIPO =A.E2_TIPO "
	cQryPIS += " AND SE2PIS.E2_FORNECE =A.E2_FORNECE "	
	cQryPIS += " AND SE2PIS.E2_LOJA =A.E2_LOJA  "
	cQryPIS += " AND SE2PIS.E2_VALOR =A.E2_VALOR  "	
	cQryPIS += " AND SE2PIS.E2_NATUREZ =A.E2_NATUREZ  "
	cQryPIS += " AND SE2PIS.D_E_L_E_T_='"+cDelet+"' "
	cQryPIS += " AND A.D_E_L_E_T_='"+cDelet+"'),0) "
	
	If Select("TMPPIS") > 0
		DbSelectArea("TMPPIS")
		DbCloseArea()
	Endif
	
	TCQUERY cQryPIS NEW ALIAS "TMPPIS"
	
	dbSelectArea("TMPPIS")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPPIS->PIS
		dbSelectArea("TMPPIS")
		dbSkip()
	End
	
	dbSelectArea("TMPPIS")
	dbCloseArea()
	
	
ElseIf cOpcao == "CSL"
	
	cQryCSL := " SELECT E2_VALOR AS CSL FROM "+RetSqlName("SE2")+" SE2CSL "
	cQryCSL += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryCSL += " AND E2_FORNECE = '"+cForTX+"'  "
	cQryCSL += " AND E2_TIPO = 'TX'  "
	cQryCSL += " AND E2_NATUREZ ='"+cNatCSLL+"' AND "
	cQryCSL += " E2_PARCELA = (SELECT MAX(E2_PARCSLL) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryCSL += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryCSL += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryCSL += "					  AND E2_NUM = '"+cNum+"' "
	cQryCSL += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryCSL += "					  AND E2_LOJA = '"+cLoja+"' "
	cQryCSL += "					  AND E2_TIPO ='NF' "
	cQryCSL += "					  AND E2_PARCSLL <> ' ' "
	cQryCSL += "					  AND SE2CSL.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryCSL += "					  AND SE2CSL.E2_NUM 	= SE2TIT.E2_NUM "
	cQryCSL += "					  AND SE2CSL.E2_PARCELA = SE2TIT.E2_PARCSLL "
	cQryCSL += "					  AND SE2CSL.E2_VALOR = SE2TIT.E2_VRETCSL "
	cQryCSL += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryCSL += "					  AND SE2CSL.D_E_L_E_T_='"+cDelet+"' )"
	cQryCSL += " AND SE2CSL.D_E_L_E_T_='"+cDelet+"' "
	cQryCSL += " AND SE2CSL.R_E_C_N_O_ = NVL((SELECT MAX(R_E_C_N_O_) MAXRECNO 
  	cQryCSL += " FROM "+RetSqlName("SE2")+" A " 
	cQryCSL += " WHERE SE2CSL.E2_FILIAL=A.E2_FILIAL "
	cQryCSL += " AND SE2CSL.E2_PREFIXO =A.E2_PREFIXO "
	cQryCSL += " AND SE2CSL.E2_NUM =A.E2_NUM "
	cQryCSL += " AND SE2CSL.E2_PARCELA =A.E2_PARCELA "
	cQryCSL += " AND SE2CSL.E2_TIPO =A.E2_TIPO "
	cQryCSL += " AND SE2CSL.E2_FORNECE =A.E2_FORNECE "
	cQryCSL += " AND SE2CSL.E2_LOJA =A.E2_LOJA  "
	cQryCSL += " AND SE2CSL.E2_VALOR =A.E2_VALOR  "
	cQryCSL += " AND SE2CSL.E2_NATUREZ =A.E2_NATUREZ  "
	cQryCSL += " AND SE2CSL.D_E_L_E_T_='"+cDelet+"' "
	cQryCSL += " AND A.D_E_L_E_T_='"+cDelet+"'),0) "
	
	If Select("TMPCSL") > 0
		DbSelectArea("TMPCSL")
		DbCloseArea()
	Endif
	
	TCQUERY cQryCSL NEW ALIAS "TMPCSL"
	
	dbSelectArea("TMPCSL")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPCSL->CSL
		dbSelectArea("TMPCSL")
		dbSkip()
	End
	
	dbSelectArea("TMPCSL")
	dbCloseArea()

ElseIf cOpcao == "ISS"
	cQryISS := " SELECT E2_VALOR AS ISS FROM "+RetSqlName("SE2")+" SE2ISS "
	cQryISS += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryISS += " AND E2_FORNECE = '"+cForISS+"'  "
	cQryISS += " AND E2_TIPO = 'ISS'  "
	cQryISS += " AND E2_NATUREZ ='"+cNatISS+"' AND "
	cQryISS += " E2_PARCELA = (SELECT MAX(E2_PARCISS) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryISS += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryISS += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryISS += "					  AND E2_NUM = '"+cNum+"' "
	cQryISS += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryISS += "					  AND E2_LOJA = '"+cLoja+"' "
	cQryISS += "					  AND E2_TIPO ='NF' "
	cQryISS += "					  AND E2_PARCISS <> ' ' "
	cQryISS += "					  AND SE2ISS.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryISS += "					  AND SE2ISS.E2_NUM 	= SE2TIT.E2_NUM "
	cQryISS += "					  AND SE2ISS.E2_PARCELA = SE2TIT.E2_PARCISS "
	cQryISS += "					  AND SE2ISS.E2_VALOR = SE2TIT.E2_ISS "	
	cQryISS += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryISS += "					  AND SE2ISS.D_E_L_E_T_= '"+cDelet+"') "
	cQryISS += " AND SE2ISS.D_E_L_E_T_='"+cDelet+"' "
	cQryISS += " AND SE2ISS.R_E_C_N_O_ = NVL((SELECT MAX(R_E_C_N_O_) MAXRECNO 
  	cQryISS += " FROM "+RetSqlName("SE2")+" A " 
	cQryISS += " WHERE SE2ISS.E2_FILIAL=A.E2_FILIAL " 
	cQryISS += " AND SE2ISS.E2_PREFIXO =A.E2_PREFIXO "		
	cQryISS += " AND SE2ISS.E2_NUM =A.E2_NUM "
	cQryISS += " AND SE2ISS.E2_PARCELA =A.E2_PARCELA "
	cQryISS += " AND SE2ISS.E2_TIPO =A.E2_TIPO "
	cQryISS += " AND SE2ISS.E2_FORNECE =A.E2_FORNECE "
	cQryISS += " AND SE2ISS.E2_LOJA =A.E2_LOJA  "
	cQryISS += " AND SE2ISS.E2_VALOR =A.E2_VALOR  "		
	cQryISS += " AND SE2ISS.E2_NATUREZ =A.E2_NATUREZ  "
	cQryISS += " AND SE2ISS.D_E_L_E_T_='"+cDelet+"' "
	cQryISS += " AND A.D_E_L_E_T_='"+cDelet+"'),0) "

	
	If Select("TMPISS") > 0
		DbSelectArea("TMPISS")
		DbCloseArea()
	Endif
		       
		MEMOWRIT("RCTBR04.SQL",cQryISS)
		
	TCQUERY cQryISS NEW ALIAS "TMPISS"
	
	dbSelectArea("TMPISS")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPISS->ISS
		dbSelectArea("TMPISS")
		dbSkip()
	End
	
	dbSelectArea("TMPISS")
	dbCloseArea()

ElseIf cOpcao == "IRF"

	cQryIRF := " SELECT E2_VALOR AS IRF FROM "+RetSqlName("SE2")+" SE2IRF "
	cQryIRF += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryIRF += " AND E2_FORNECE = '"+cForTX+"'  "
	cQryIRF += " AND E2_TIPO = 'TX'  "
	cQryIRF += " AND E2_NATUREZ ='"+cNatIRF+"' AND "
	cQryIRF += " E2_PARCELA = (SELECT MAX(E2_PARCIR) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryIRF += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryIRF += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryIRF += "					  AND E2_NUM = '"+cNum+"' "
	cQryIRF += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryIRF += "					  AND E2_LOJA = '"+cLoja+"' "
	cQryIRF += "					  AND E2_TIPO ='NF' "
	cQryIRF += "					  AND E2_PARCIR <> ' ' "
	cQryIRF += "					  AND SE2IRF.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryIRF += "					  AND SE2IRF.E2_NUM 	= SE2TIT.E2_NUM "
	cQryIRF += "					  AND SE2IRF.E2_PARCELA = SE2TIT.E2_PARCIR "
	cQryIRF += "					  AND SE2IRF.E2_VALOR = SE2TIT.E2_IRRF "
	cQryIRF += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryIRF += "					  AND SE2IRF.D_E_L_E_T_= '"+cDelet+"') "
	cQryIRF += " AND SE2IRF.D_E_L_E_T_='"+cDelet+"' "
	cQryIRF += " AND SE2IRF.R_E_C_N_O_ = NVL((SELECT MAX(R_E_C_N_O_) MAXRECNO 
  	cQryIRF += " FROM "+RetSqlName("SE2")+" A " 
	cQryIRF += " WHERE SE2IRF.E2_FILIAL=A.E2_FILIAL "
	cQryIRF += " AND SE2IRF.E2_PREFIXO =A.E2_PREFIXO "
	cQryIRF += " AND SE2IRF.E2_NUM =A.E2_NUM "
	cQryIRF += " AND SE2IRF.E2_PARCELA =A.E2_PARCELA "
	cQryIRF += " AND SE2IRF.E2_TIPO =A.E2_TIPO "
	cQryIRF += " AND SE2IRF.E2_FORNECE =A.E2_FORNECE "
	cQryIRF += " AND SE2IRF.E2_LOJA =A.E2_LOJA  "
	cQryIRF += " AND SE2IRF.E2_VALOR =A.E2_VALOR "	
	cQryIRF += " AND SE2IRF.E2_NATUREZ =A.E2_NATUREZ  "
	cQryIRF += " AND SE2IRF.D_E_L_E_T_='"+cDelet+"' "
	cQryIRF += " AND A.D_E_L_E_T_='"+cDelet+"'),0) "

	
	If Select("TMPIRF") > 0
		DbSelectArea("TMPIRF")
		DbCloseArea()
	Endif

		
	TCQUERY cQryIRF NEW ALIAS "TMPIRF"
	
	dbSelectArea("TMPIRF")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPIRF->IRF
		dbSelectArea("TMPIRF")
		dbSkip()
	End
	
	dbSelectArea("TMPIRF")
	dbCloseArea()


ElseIf cOpcao == "INS"

	cQryINS := " SELECT E2_VALOR AS INS FROM "+RetSqlName("SE2")+" SE2INS "
	cQryINS += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryINS += " AND E2_FORNECE = '"+cForIns+"'  "
	cQryINS += " AND E2_TIPO = 'INS'  "
	cQryINS += " AND E2_NATUREZ ='"+cNatIns+"' AND "
	cQryINS += " E2_PARCELA = (SELECT MAX(E2_PARCINS) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryINS += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryINS += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryINS += "					  AND E2_NUM = '"+cNum+"' "
	cQryINS += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryINS += "					  AND E2_LOJA = '"+cLoja+"' "
	cQryINS += "					  AND E2_TIPO ='NF' "
	cQryINS += "					  AND E2_PARCINS <> ' ' "
	cQryINS += "					  AND SE2INS.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryINS += "					  AND SE2INS.E2_NUM 	= SE2TIT.E2_NUM "
	cQryINS += "					  AND SE2INS.E2_PARCELA = SE2TIT.E2_PARCINS "  
	cQryINS += "					  AND SE2INS.E2_VALOR = SE2TIT.E2_INSS "  		
	cQryINS += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryINS += "					  AND SE2INS.D_E_L_E_T_= '"+cDelet+"') "
	cQryINS += " AND SE2INS.D_E_L_E_T_='"+cDelet+"' "
	cQryINS += " AND SE2INS.R_E_C_N_O_ = NVL((SELECT MAX(R_E_C_N_O_) MAXRECNO 
  	cQryINS += " FROM "+RetSqlName("SE2")+" A " 
	cQryINS += " WHERE SE2INS.E2_FILIAL=A.E2_FILIAL "
	cQryINS += " AND SE2INS.E2_PREFIXO =A.E2_PREFIXO "
	cQryINS += " AND SE2INS.E2_NUM =A.E2_NUM "
	cQryINS += " AND SE2INS.E2_PARCELA =A.E2_PARCELA "
	cQryINS += " AND SE2INS.E2_TIPO =A.E2_TIPO "
	cQryINS += " AND SE2INS.E2_FORNECE =A.E2_FORNECE "
	cQryINS += " AND SE2INS.E2_LOJA =A.E2_LOJA  "
	cQryINS += " AND SE2INS.E2_VALOR =A.E2_VALOR "	
	cQryINS += " AND SE2INS.E2_NATUREZ =A.E2_NATUREZ  "
	cQryINS += " AND SE2INS.D_E_L_E_T_='"+cDelet+"' "
	cQryINS += " AND A.D_E_L_E_T_='"+cDelet+"'),0) "

	
	If Select("TMPINS") > 0
		DbSelectArea("TMPINS")
		DbCloseArea()
	Endif

		
	TCQUERY cQryINS NEW ALIAS "TMPINS"
	
	dbSelectArea("TMPINS")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPINS->INS
		dbSelectArea("TMPINS")
		dbSkip()
	End
	
	dbSelectArea("TMPINS")
	dbCloseArea()
		
EndIf

RestArea(aAreaD1)
RestArea(aAreaE2)
RestArea(aArea)

Return(nValor)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³CtbCheque ³ Monta valor dos juros, desconto, multa quando título não     º±±
±±º             ³          ³ esta posicionado.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³          ³Especifico                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³          ³ Almir Bandina                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ ??.??.?? ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil.                                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil.                                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ ??.??.?? - Nome - Descrição                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CtbCheque(cTpDoc)

Local aAreaAtu	:= GetArea()
Local nRet		:= 0
Local cQry		:= ""
Local cPrefixo	:= SE2->E2_PREFIXO
Local cNumero	:= SE2->E2_NUM
Local cParcela	:= SE2->E2_PARCELA
Local cTipo		:= SE2->E2_TIPO
Local cFornece	:= SE2->E2_FORNECE
Local cLoja		:= SE2->E2_LOJA
Local cCheque   := NUMCHEQUE

Default cTpDoc	:= " "
If date() > ctod('15/01/2007')
	MsgStop("Contate o Administrador do Sistema")
	Return()
EndIf

// Define a select para apurar o valor de desconto, juros e multa
cQry	+= "SELECT"
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC = 'DC' THEN E5.E5_VALOR ELSE 0 END) AS DESCON,"
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC = 'JR' THEN E5.E5_VALOR ELSE 0 END) AS JUROS,"
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC = 'MT' THEN E5.E5_VALOR ELSE 0 END) AS MULTA,"
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC = 'CM' THEN E5.E5_VALOR ELSE 0 END) AS CORREC, "
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC IN ('VL','BA') THEN E5.E5_VRETPIS ELSE 0 END) AS VRETPIS, "
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC IN ('VL','BA') THEN E5.E5_VRETCOF ELSE 0 END) AS VRETCOF, "
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC IN ('VL','BA') THEN E5.E5_VRETCSL ELSE 0 END) AS VRETCSL "
cQry	+= " FROM "+RetSqlName("SE5")+" E5 WHERE"
cQry	+= " E5.E5_FILIAL = '"+xFilial("SE5")+"' AND"
cQry	+= " E5.E5_PREFIXO = '"+cPrefixo+"' AND"
cQry	+= " E5.E5_NUMERO = '"+cNumero+"' AND"
cQry	+= " E5.E5_PARCELA = '"+cParcela+"' AND"
cQry	+= " E5.E5_TIPO = '"+cTipo+"' AND"
cQry	+= " E5.E5_CLIFOR = '"+cFornece+"' AND"
cQry	+= " E5.E5_LOJA = '"+cLoja+"' AND" 
cQry	+= " E5.E5_NUMCHEQ = '"+cCheque+"' AND" 
cQry	+= " E5.D_E_L_E_T_ <> '*'"

// Verifica se o alias esta em uso
If Select("TMP590") > 0
	dbSelectArea("TMP590")
	dbCloseArea()
EndIf

//MEMOWRIT("CTBCHQ.SQL",cQry)

// Roda a query
TCQUERY cQry NEW ALIAS "TMP590"

// Define o valor do retorno
If cTpDoc == "DC"					// Desconto
	nRet	:= TMP590->DESCON
ElseIf cTpDoc == "JR"				// Juros
	nRet	:= TMP590->JUROS
ElseIf cTpDoc == "MT"				// Multa
	nRet	:= TMP590->MULTA	
ElseIf cTpDoc == "CM"
	nRet	:= TMP590->CORREC		// correcao monetaria
ElseIf cTpDoc == "PIS"
	nRet	:= TMP590->VRETPIS		// Pis
ElseIf cTpDoc == "COF"
	nRet	:= TMP590->VRETCOF		// Cofins
ElseIf cTpDoc == "CSL"
	nRet	:= TMP590->VRETCSL		// Csll	
Else
	nRet	:= 0					// Força Zero
EndIf

//Restaura a integridade dos arquivos
dbSelectArea("TMP590")
dbCloseArea()
RestArea(aAreaAtu)

Return(nRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CtbBx     ³ Autor ³Deny Mendonca           º Data ³  29/11/06º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Indica se havera contabilizacao para a baixa                ³±±
±±³            Necessario para utilizacao do parametro MV_CTBAIXA = A      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CtBx(cOpcao)

Local lCtb	:=.t.
If date() > ctod('15/01/2007')
	MsgStop("Contate o Administrador do Sistema")
	Return()
EndIf

If cOpcao == NIL
	cOpcao := "INC"
EndIf	

//lCtb   := IIF(UPPER(TRIM(FUNNAME()))<>"FINA290".AND.((SE5->E5_MOTBX=="NOR".AND. SE5->E5_TIPODOC=="VL" .AND. empty(SE2->E2_NUMBCO)).OR.SE5->E5_MOTBX<>"NOR".OR.SE5->E5_TIPODOC=="VL"),.t.,.f.)
//lCtb   := IIF(lCtb .And.SE5->E5_MOTBX=="DEB".And.Alltrim(SE2->E2_TIPO)$'PA/NDF',.f.,.t.)
If cOpcao == "INC"
	lCtb   := IIF(UPPER(TRIM(FUNNAME()))<>"FINA290".AND.((SE5->E5_MOTBX=="NOR".AND. SE5->E5_TIPODOC=="VL" .AND. empty(SE2->E2_NUMBCO)).OR.SE5->E5_MOTBX<>"NOR".OR.SE5->E5_TIPODOC=="VL"),.t.,.f.)
ElseIf cOpcao == "CANC"
	lCtb   := IIF(UPPER(TRIM(FUNNAME()))<>"FINA290".AND.((SE5->E5_MOTBX=="NOR".AND. SE5->E5_TIPODOC=="VL" .AND. empty(SE5->E5_NUMCHEQ)).OR.SE5->E5_MOTBX<>"NOR"),.t.,.f.)	
EndIf	

Return(lCtb)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³VlrOrig   ³ Autor ³ ³Deny Mendonca         º Data ³  29/11/06º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Busca o valo do custo de entrada. Sera usado no lancamento  ³±±
±±³            padrao de devolucao de compras.                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VlrOrig()

Local aArea	:= GetArea()
Local aArSd2:= SD2->(GetArea())
Local aArSd1:= SD1->(GetArea())
Local cCusto	:= 0
If date() > ctod('15/01/2007')
	MsgStop("Contate o Administrador do Sistema")
	Return()
EndIf
                             
If SD2->D2_TIPO == "D"		 
	DbSelectArea("SD1")
	DbSetOrder(1)
	If MsSeek(xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_ITEMORI)
		cCusto	:= SD1->D1_CUSTO
	EndIf	          
EndIf	
	
RestArea(aArSd2)
RestArea(aArSd1)
RestArea(aArea)

Return(cCusto)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CtaOrig   ³ Autor ³ ³Deny Mendonca         º Data ³  29/11/06º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Busca a conta contabil de origem da entrada. Sera usado no LP±±
±±³            padrao de devolucao de compras.                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CtaOrig()

Local aArea	:= GetArea()
Local aArSd2:= SD2->(GetArea())
Local aArSd1:= SD1->(GetArea())
Local cCtaOrig	:= " "
If date() > ctod('15/01/2007')
	MsgStop("Contate o Administrador do Sistema")
	Return()
EndIf
                             
If SD2->D2_TIPO == "D"		 
	DbSelectArea("SD1")
	DbSetOrder(1)
	If MsSeek(xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_ITEMORI)
		cCtaOrig	:= SD1->D1_CONTA
	EndIf	          
EndIf	
	
RestArea(aArSd2)
RestArea(aArSd1)
RestArea(aArea)

Return(cCtaOrig)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CcOrig    ³ Autor ³ ³Deny Mendonca       º Data ³  29/11/06   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Busca o centro de custo   origem da entrada. Sera usado no LP±±
±±³            padrao de devolucao de compras.                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CcOrig()

Local aArea	:= GetArea()
Local aArSd2:= SD2->(GetArea())
Local aArSd1:= SD1->(GetArea())
Local cCcOri:= " "
If date() > ctod('15/01/2007')
	MsgStop("Contate o Administrador do Sistema")
	Return()
EndIf
                             
If SD2->D2_TIPO == "D"		 
	DbSelectArea("SD1")
	DbSetOrder(1)
	If MsSeek(xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_ITEMORI)
		cCcOri:= SD1->D1_CC
	EndIf	          
EndIf	
	
RestArea(aArSd2)
RestArea(aArSd1)
RestArea(aArea)

Return(cCcOri)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³SumAbtImp ³ Autor ³ ³Deny Mendonca       º Data ³  29/11/06   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Busca os abatimentos relativos aos impostos do contas a     ³±±
±±³            receber.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³parametros³cPrefixo: prefixo do titulo                                  ³±±
±±³          ³cNumero : numero do titulo                                   ³±±
±±³          ³cParcela: parcela do titulo                                  ³±±
±±³          ³nMoeda  : moeda                                              ³±±
±±³          ³dData   : data do abatimento                                 ³±±
±±³          ³cTpImp  : qual o imposto     IR- : impostos de renda		   ³±±
±±³          ³                             IN- : INSS                      ³±±
±±³          ³                             PI- : PIS                       ³±±
±±³          ³                             CF- : Cofins                    ³±±
±±³          ³                             CS- : CSLL                      ³±±
±±³										   TD  : Todos os impostos         ³±±
±±³          ³                                                             ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//User Function SumAbtImp(cPrefixo,cNumero,cParcela,nMoeda,dData,cTpImp)
User Function SumAbtImp(cTpImp)

Local aArSE1:= SE1->(GetArea())
Local aArea	:= GetArea()
Local nTotAbat:=0      
Local cPrefixo	:= SE1->E1_PREFIXO
Local cNumero	:= SE1->E1_NUM
Local cParcela	:= SE1->E1_PARCELA
Local nMoeda	:= SE1->E1_MOEDA
Local dData		:= dDataBase
If date() > ctod('15/01/2007')
	MsgStop("Contate o Administrador do Sistema")
	Return()
EndIf

DbSelectArea("SE1")
dbSetOrder(1)
MsSeek(xFilial("SE1")+cPrefixo+cNumero+cParcela )
While !Eof() .And. E1_FILIAL == xFilial("SE1") .And. E1_PREFIXO == cPrefixo .And.;
		E1_NUM == cNumero .And. E1_PARCELA == cParcela
	If cTpImp == "TD" .and. E1_TIPO $ MVIRABT+"/"+MVINABT+"/"+MVCSABT+"/"+MVCFABT+"/"+MVPIABT
		nTotAbat+=xMoeda(SE1->E1_VALOR,E1_MOEDA, nMoeda,dData)
	EndIf		
		
	If Alltrim(E1_TIPO) $ cTpImp 		
		nTotAbat+=xMoeda(SE1->E1_VALOR,E1_MOEDA, nMoeda,dData)
	EndIf
	
	DbSelectArea("SE1")
	dbSkip()
Enddo

RestArea(aArSe1)
RestArea(aArea)

Return(NoRound(nTotAbat))


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³SumAbtImp ³ Autor ³ ³Deny Mendonca       º Data ³  29/11/06   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Busca os abatimentos relativos aos impostos do contas a     ³±±
±±³            receber.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³parametros³cPrefixo: prefixo do titulo                                  ³±±
±±³          ³cNumero : numero do titulo                                   ³±±
±±³          ³cParcela: parcela do titulo                                  ³±±
±±³          ³nMoeda  : moeda                                              ³±±
±±³          ³dData   : data do abatimento                                 ³±±
±±³          ³cTpImp  : qual o imposto     IR- : impostos de renda		   ³±±
±±³          ³                             IN- : INSS                      ³±±
±±³          ³                             PI- : PIS                       ³±±
±±³          ³                             CF- : Cofins                    ³±±
±±³          ³                             CS- : CSLL                      ³±±
±±³										   TD  : Todos os impostos         ³±±
±±³          ³                                                             ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//User Function SumAbtImp(cPrefixo,cNumero,cParcela,nMoeda,dData,cTpImp)
User Function SumAbtCmp(cTpImp)

Local aArSE1:= SE1->(GetArea())
Local aArea	:= GetArea()
Local nTotAbat:=0      
Local cPrefixo	:= " "
Local cNumero	:= " "
Local cParcela	:= " "
Local nMoeda	:= " "
Local dData		:= dDataBase
Local nTamTit	:= TAMSX3("E1_PREFIXO")[1]+TAMSX3("E1_NUM")[1]+TAMSX3("E1_PARCELA")[1]
Local nTamParc	:= TAMSX3("E1_PARCELA")[1]
Local nRecAtu	:= SE1->(Recno())
If date() > ctod('15/01/2007')
	MsgStop("Contate o Administrador do Sistema")
	Return()
EndIf

If "RA"$Substr(STRLCTPAD,nTamTit+1,3)
	cPrefixo := SE1->E1_PREFIXO
	cNumero	 := SE1->E1_NUM
	cParcela := SE1->E1_PARCELA
Else
	cPrefixo := Substr(STRLCTPAD,1,3)
	cNumero	 := Substr(STRLCTPAD,4,6)
	cParcela := Substr(STRLCTPAD,10,nTamParc)
EndIf	

DbSelectArea("SE1")
dbSetOrder(1)
MsSeek(xFilial("SE1")+cPrefixo+cNumero+cParcela )
While !Eof() .And. E1_FILIAL == xFilial("SE1") .And. E1_PREFIXO == cPrefixo .And.;
		E1_NUM == cNumero .And. E1_PARCELA == cParcela
	If cTpImp == "TD" .and. E1_TIPO $ MVIRABT+"/"+MVINABT+"/"+MVCSABT+"/"+MVCFABT+"/"+MVPIABT
		nTotAbat+=xMoeda(SE1->E1_VALOR,E1_MOEDA, 1,dData)
	EndIf		
		
	If Alltrim(E1_TIPO) $ cTpImp 		
		nTotAbat+=xMoeda(SE1->E1_VALOR,E1_MOEDA, 1,dData)
	EndIf
	
	DbSelectArea("SE1")
	dbSkip()
Enddo

DbSelectArea("SE1")
DbGoTo(nRecAtu)

RestArea(aArSe1)
RestArea(aArea)

Return(NoRound(nTotAbat))


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³DadTit()  ³ Autor ³ ³Deny Mendonca       º Data ³  29/11/06   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Obtem as informacoes para contabilizacao dos titulos de cta ³±±
±±³            pagar.  Necessario devido ao uso de Multiplas Naturezas     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³                                                             ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function DadTit(cOpcao)

Local aArea	:= GetArea()
Local aArSe2 := SE2->(GetArea())
Local aArSeV := SEV->(GetArea())
Local aArSeD := SED->(GetArea())
Local xRetorno := " "              
Local nRecAtu	:= 0
If date() > ctod('15/01/2007')
	MsgStop("Contate o Administrador do Sistema")
	Return()
EndIf

If cOpcao == "CTDEB"
	
	If SE2->E2_MULTNAT == "2"		// TITULO SEM MULTIPLAS NATUREZAS
		DbSelectArea("SED")
		DbSetOrder(1)
		If MsSeek(xFilial("SED")+SE2->E2_NATUREZ)
			If Empty(SE2->E2_DEBITO)
				xRetorno := IIF(VAL(SED->ED_DEBITO)=0 .AND. !EMPTY(SED->ED_DEBITO),&(SED->ED_DEBITO),SED->ED_DEBITO)
			Else
				xRetorno := SE2->E2_DEBITO
			EndIf	
		Else
			xRetorno	:= SE2->E2_DEBITO
		EndIf
	Else
		DbSelectArea("SED")
		DbSetOrder(1)
		If MsSeek(xFilial("SED")+SEV->EV_NATUREZ)
		
			DbSelectArea("SE2")
			DbSetOrder(1)
			MSSeek(xFilial("SE2")+SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA)
			If Empty(SED->ED_DEBITO)						
				xRetorno := IIF(VAL(SED->ED_DEBITO)=0 .AND. !EMPTY(SED->ED_DEBITO),&(SED->ED_DEBITO),SED->ED_DEBITO)
			Else	
				xRetorno := SED->ED_DEBITO
			EndIf	
		Else
			xRetorno	:= " "
		EndIf    
	EndIf	

ElseIf cOpcao == "CTCRE"

	If SE2->E2_MULTNAT == "2"		// TITULO SEM MULTIPLAS NATUREZAS
		DbSelectArea("SED")
		DbSetOrder(1)
		If MsSeek(xFilial("SED")+SE2->E2_NATUREZ)
			If Empty(SE2->E2_CREDIT)
				xRetorno := IIF(EMPTY(SED->ED_CREDIT),SA2->A2_CONTA,IIF(VAL(SED->ED_CREDIT)=0,&(SED->ED_CREDIT),SED->ED_CREDIT))
			Else	
				xRetorno := SE2->E2_CREDIT
			EndIf	
		Else
			xRetorno	:= SE2->E2_CREDIT
		EndIf
	Else 
		DbSelectArea("SED")
		DbSetOrder(1)
		If MsSeek(xFilial("SED")+SEV->EV_NATUREZ)		
			DbSelectArea("SE2")
			DbSetOrder(1)
			MSSeek(xFilial("SE2")+SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA)		
			If Empty(SE2->E2_CREDIT)
				xRetorno := IIF(EMPTY(SED->ED_CREDIT),SA2->A2_CONTA,IIF(VAL(SED->ED_CREDIT)=0,&(SED->ED_CREDIT),SED->ED_CREDIT))
			Else
				xRetorno := SE2->E2_CREDIT
			EndIf		
		Else	
	        xRetorno := " "  
	    EndIf    
	EndIf

ElseIf cOpcao == "MCTCRE"

	If SE2->E2_MULTNAT == "2"		// TITULO SEM MULTIPLAS NATUREZAS
		DbSelectArea("SED")
		DbSetOrder(1)
		If MsSeek(xFilial("SED")+SE2->E2_NATUREZ)
			If Empty(SE2->E2_CREDIT)
				xRetorno := IIF(EMPTY(SED->ED_CREDIT),SA2->A2_CONTA,IIF(VAL(SED->ED_CREDIT)=0,&(SED->ED_CREDIT),SED->ED_CREDIT))
			Else
				xRetorno := SE2->E2_CREDIT
			EndIf	
		Else
			xRetorno	:= SE2->E2_CREDIT
		EndIf
	Else 
		DbSelectArea("SED")
		DbSetOrder(1)
		If MsSeek(xFilial("SED")+SEZ->EZ_NATUREZ)
			DbSelectArea("SE2")
			DbSetOrder(1)
			MSSeek(xFilial("SE2")+SEZ->EZ_PREFIXO+SEZ->EZ_NUM+SEZ->EZ_PARCELA+SEZ->EZ_TIPO+SEZ->EZ_CLIFOR+SEZ->EZ_LOJA)				
			If Empty(SE2->E2_CREDIT)
				xRetorno := IIF(EMPTY(SED->ED_CREDIT),SA2->A2_CONTA,IIF(VAL(SED->ED_CREDIT)=0,&(SED->ED_CREDIT),SED->ED_CREDIT))
			Else
				xRetorno := SE2->E2_CREDIT
			EndIf		
		Else	
	        xRetorno := " "  
	    EndIf    
	EndIf       
                 
ElseIf cOpcao == "MCTDEB"

	If SE2->E2_MULTNAT == "2"		// TITULO SEM MULTIPLAS NATUREZAS
		DbSelectArea("SED")
		DbSetOrder(1)
		If MsSeek(xFilial("SED")+SE2->E2_NATUREZ)
			If Empty(SE2->E2_DEBITO)
				xRetorno := IIF(VAL(SED->ED_DEBITO)=0 .AND. !EMPTY(SED->ED_DEBITO),&(SED->ED_DEBITO),SED->ED_DEBITO)
			Else
				xRetorno := SE2->E2_DEBITO
			EndIf	
		Else
			xRetorno	:= SE2->E2_DEBITO
		EndIf
	Else 
		DbSelectArea("SED")
		DbSetOrder(1)
		If MsSeek(xFilial("SED")+SEZ->EZ_NATUREZ)
			DbSelectArea("SE2")
			DbSetOrder(1)
			MSSeek(xFilial("SE2")+SEZ->EZ_PREFIXO+SEZ->EZ_NUM+SEZ->EZ_PARCELA+SEZ->EZ_TIPO+SEZ->EZ_CLIFOR+SEZ->EZ_LOJA)						
			If Empty(SE2->E2_DEBITO)
				xRetorno := IIF(VAL(SED->ED_DEBITO)=0 .AND. !EMPTY(SED->ED_DEBITO),&(SED->ED_DEBITO),SED->ED_DEBITO)
			Else
				xRetorno := SE2->E2_DEBITO
			EndIf	
		Else	
	        xRetorno := " "  
	    EndIf    
	EndIf       

ElseIf cOpcao == "HRAT"		// Historico do rateio

		nRecAtu	:= SE2->(Recno())
		
		DbSelectArea("SE2")
		dbGoTo(STRLCTPAD)		// Nesta variavel esta guardada a informacao do recno original do SE2.
		
		xRetorno := "INC TIT PAG "+SE2->E2_PREFIXO+" "+SE2->E2_NUM+" "+Alltrim(SA2->A2_NOME)
		
		DbSelectArea("SE2")
		dbGoTo(nRecAtu)		// Volta o SE2 como estava ao entrar na rotina

ElseIf cOpcao == "ORAT"		// Origem do rateio

		nRecAtu	:= SE2->(Recno())
		
		DbSelectArea("SE2")
		dbGoTo(STRLCTPAD)		// Nesta variavel esta guardada a informacao do recno original do SE2.
		
		xRetorno := SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
		
		DbSelectArea("SE2")
		dbGoTo(nRecAtu)		// Volta o SE2 como estava ao entrar na rotina
			
Endif
					
RestArea(aArSe2)
RestArea(aArSeV)
RestArea(aArSeD)
RestArea(aArea)

Return(xRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DelCtbCh  ºAutor  ³³Deny Mendonca       º Data ³  29/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para contabilizacao da exclusao do cheque.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DelCtbCh(cTpDoc)

Local aAreaAtu	:= GetArea()
Local nRet		:= 0
Local cQry		:= ""
Local cPrefixo	:= SEF->EF_PREFIXO
Local cNumero	:= SEF->EF_TITULO
Local cParcela	:= SEF->EF_PARCELA
Local cTipo		:= SEF->EF_TIPO
Local cFornece	:= SEF->EF_FORNECE
Local cLoja		:= SEF->EF_LOJA
Local cSeq	    := SEF->EF_SEQUENC

Default cTpDoc	:= " "
If date() > ctod('15/01/2007')
	MsgStop("Contate o Administrador do Sistema")
	Return()
EndIf

// Define a select para apurar o valor de desconto, juros e multa
cQry	+= "SELECT"
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC = 'DC' THEN E5.E5_VALOR ELSE 0 END) AS DESCON,"
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC = 'JR' THEN E5.E5_VALOR ELSE 0 END) AS JUROS,"
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC = 'MT' THEN E5.E5_VALOR ELSE 0 END) AS MULTA,"
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC = 'CM' THEN E5.E5_VALOR ELSE 0 END) AS CORREC, "
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC IN ('VL','BA') THEN E5.E5_VRETPIS ELSE 0 END) AS VRETPIS, "
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC IN ('VL','BA') THEN E5.E5_VRETCOF ELSE 0 END) AS VRETCOF, "
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC IN ('VL','BA') THEN E5.E5_VRETCSL ELSE 0 END) AS VRETCSL "
cQry	+= " FROM "+RetSqlName("SE5")+" E5 WHERE"
cQry	+= " E5.E5_FILIAL = '"+xFilial("SE5")+"' AND"
cQry	+= " E5.E5_PREFIXO = '"+cPrefixo+"' AND"
cQry	+= " E5.E5_NUMERO = '"+cNumero+"' AND"
cQry	+= " E5.E5_PARCELA = '"+cParcela+"' AND"
cQry	+= " E5.E5_TIPO = '"+cTipo+"' AND"
cQry	+= " E5.E5_CLIFOR = '"+cFornece+"' AND"
cQry	+= " E5.E5_LOJA = '"+cLoja+"' AND" 
cQry	+= " E5.E5_SEQ = '"+cSeq+"' AND" 
cQry	+= " E5.D_E_L_E_T_ <> '*'"

// Verifica se o alias esta em uso
If Select("TMP590") > 0
	dbSelectArea("TMP590")
	dbCloseArea()
EndIf

// Roda a query
TCQUERY cQry NEW ALIAS "TMP590"

// Define o valor do retorno
If cTpDoc == "DC"					// Desconto
	nRet	:= TMP590->DESCON
ElseIf cTpDoc == "JR"				// Juros
	nRet	:= TMP590->JUROS
ElseIf cTpDoc == "MT"				// Multa
	nRet	:= TMP590->MULTA	
ElseIf cTpDoc == "CM"
	nRet	:= TMP590->CORREC		// correcao monetaria
ElseIf cTpDoc == "PIS"
	nRet	:= TMP590->VRETPIS		// Pis
ElseIf cTpDoc == "COF"
	nRet	:= TMP590->VRETCOF		// Cofins
ElseIf cTpDoc == "CSL"
	nRet	:= TMP590->VRETCSL		// Csll	
Else
	nRet	:= 0					// Força Zero
EndIf

//Restaura a integridade dos arquivos
dbSelectArea("TMP590")
dbCloseArea()
RestArea(aAreaAtu)

Return(nRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ECMPCR    ºAutor  ³³Deny Mendonca       º Data ³  29/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Dados para lancamento contabil na exclusao/estorno da       º±±
±±º          ³compensacao Contas a Receber                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ECMPCR(cOpcao)
                                          
Local aArea	:= GetArea()
Local cReturn	:= " "
If date() > ctod('15/01/2007')
	MsgStop("Contate o Administrador do Sistema")
	Return()
EndIf

If cOpcao == "ORIAD"	// Origem da compensacao - perna do adiantamento

	If "RA" $ STRLCTPAD
		cReturn	:= STRLCTPAD
	Else
		cReturn	:= SE5->E5_DOCUMEN
    EndIf

Elseif cOpcao == "ORITI"	// Origem da compensacao - perna do titulo

	If "RA" $ STRLCTPAD
		cReturn	:= SE5->E5_DOCUMEN
	Else
		cReturn	:= STRLCTPAD
    EndIf
EndIf

RestArea(aArea)

Return(cReturn)
                       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DESCGRP   ºAutor  ³Deny Mendonca       º Data ³  29/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Descricao do grupo de produto para uso no historico da      º±±
±±º          ³contabilizacao das vendas.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DescGrp()

Local aArea	:= GetArea()
Local cDescGrp	:= " "

DbSelectArea("SBM")
DbSetOrder(1)
If MsSeek(xfilial("SBM")+SB1->B1_GRUPO)
	cDescGrp	:= Alltrim(SBM->BM_DESC)
EndIf	
	
RestArea(aArea)

Return(cDescGrp)
