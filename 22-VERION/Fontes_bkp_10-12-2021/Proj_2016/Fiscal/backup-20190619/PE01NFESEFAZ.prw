#include "protheus.ch"
#INCLUDE "COLORS.CH"	
#INCLUDE "TBICONN.CH"  

/*
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������
������������������������������������������������������������������������������������"��
���Programa  �PE01NFESEFAZ �Autor  � Alex Rodrigues - Adinfo  � Data �  04/09/18    ���
�����������������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para tratar informa��es da NFe enviadas no          ���
���          � arquivo XML para a Sefaz                                             ���
�����������������������������������������������������������������������������������͹��
���Uso       � Faturamento                                                          ���
�����������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������
*/
User Function PE01NFESEFAZ()
Local aProd       := PARAMIXB[1]
Local cMensCli    := PARAMIXB[2]
Local cMensFis    := PARAMIXB[3]
Local aDest       := PARAMIXB[4]
Local aNota       := PARAMIXB[5]
Local aInfoItem   := PARAMIXB[6]
Local aDupl       := PARAMIXB[7]
Local aTransp     := PARAMIXB[8]
Local aEntrega    := PARAMIXB[9]
Local aRetirada   := PARAMIXB[10]
Local aVeiculo    := PARAMIXB[11]
Local aReboque    := PARAMIXB[12]
Local aNfVincRur  := PARAMIXB[13]
Local aEspVol     := PARAMIXB[14]
Local aNfVinc	  := PARAMIXB[15]

//LOCAL aNfe := PARAMIXB
Local aRetorno    := {}

//In�cio Verion


//Tratamento para as mensagens da nota fiscal

// ######################
// # SF2 J� POSICIONADO #
// ######################

If aNota[4] == "1"  //Sa�da

	//POSICIONA SD2
	dbSelectArea("SD2")
	dbSetOrder(3)
	MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	If DbSeek(xFilial("SC5")+aInfoItem[1][1]) 
	
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)        
		
		// Especifico Verion - CUSTOMIZADO
		If !Alltrim(SC5->C5_NUM) $ cMensCli // Inclu�do por Fl�vio Sard�o em 13/09/2010.
			cMensCli += "Ped.Num.: " + Alltrim(SC5->C5_NUM)
		EndIf
	
		If !Alltrim(SC5->C5_VEND1) $ cMensCli // Inclu�do por Fl�vio Sard�o em 13/09/2010.
			cMensCli += " Vendedor: " + Alltrim(SC5->C5_VEND1)
		EndIf						
	                   
		If !AllTrim(SC5->C5_MENNOT1) $ cMensCli   // alterado por Marcus Feixas em 16.01.2010. - Verion - CUSTOMIZADO
			cMensCli += ", " + AllTrim(SC5->C5_MENNOT1)
		EndIf		 
		
		If !Alltrim(SA1->A1_ENDENT) $ cMensCli .And. !Empty(SA1->A1_ENDENT)   // Alterado por Fl�vio Sard�o em 13/09/2010. - Verion - CUSTOMIZADO
			IF  SD2->D2_TIPO $ "DB"
				cMensCli += ", Endere�o de Entrega: "
				cMensCli += Alltrim(SA1->A1_ENDENT) + IIF(Empty(SA1->A1_BAIRROE)," ","-" + Alltrim(SA1->A1_BAIRROE))
	   			cMensCli += Transform(Alltrim(SA1->A1_CEPE),"@R 99999-999") + " - " + Alltrim(SA1->A1_MUNENT) + " - " + SA1->A1_ESTENT
		    Endif
		EndIf	 
		
		If !Alltrim(SC5->C5_VRCOLET) $ cMensCli .And. !Empty(SC5->C5_VRCOLET)  // Inclu�do por Fl�vio Sard�o em 13/09/2010. - Verion - CUSTOMIZADO
			cMensCli += ", " + AllTrim(SC5->C5_VRCOLET)
		EndIf					
		If !Alltrim("-PAGAMENTOS DEVEM SER FEITOS VIA BOLETO OU DEPOSITO") $ cMensCli// Inclu�do por Fabio em 13/04/2014. - Verion - CUSTOMIZADO
		 	cMensCli += "   -PAGAMENTOS DEVEM SER FEITOS VIA BOLETO OU DEPOSITO APENAS EM NOME DE NOSSA EMPRESA - D�VIDAS CONTATAR O FINANCEIRO (11)2100-7400"
		Endif      
	Endif
Else // NF entrada       

	//================================================================
	// CUSTOMIZACAO NA NF DE IMPORTACAO DA VERION
	//================================================================
	// - de acordo com skype envido em 08.12.09 pela Vanderleia, segue o layout desejado...
	//IMp.Importa��o :         340,58-Pis:        55,85-Cofins : 257,96
	//Base ICMS (    3.227,52/0,82)*18% = ICMS ( 708,48)
	//DI 09/169232-3 de 01/12/2009  Num Adi��o: 001
	//CAI001014/09                       
	
	cAliasSD1 := GetNextAlias()
	BeginSql Alias cAliasSD1			
		SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_ITEM,D1_TES,D1_TIPO,D1_NFORI,D1_SERIORI,D1_ITEMORI,
			D1_CF,D1_QUANT,D1_TOTAL,D1_VALDESC,D1_VALFRE,D1_SEGURO,D1_DESPESA,D1_CODISS,D1_VALISS,D1_VALIPI,D1_ICMSRET,
			D1_VUNIT,D1_CLASFIS,D1_VALICM,D1_TIPO_NF,D1_PEDIDO,D1_ITEMPC,D1_VALIMP5,D1_VALIMP6,D1_BASEIRR,D1_VALIRR,D1_LOTECTL,
			D1_NUMLOTE,D1_CUSTO,D1_ORIGLAN,D1_DESCICM,D1_II,D1_FORMUL,D1_VALPS3,D1_ORIGLAN,D1_VALCF3,D1_TESACLA,D1_IDENTB6,
			D1_PICM,D1_ADIC,D1_DIIT,D1_XFABRIC, D1_XDIAD, D1_CIF
		FROM %Table:SD1% SD1
			WHERE
			SD1.D1_FILIAL  = %xFilial:SD1% AND
			SD1.D1_SERIE   = %Exp:SF1->F1_SERIE% AND
			SD1.D1_DOC     = %Exp:SF1->F1_DOC% AND
			SD1.D1_FORNECE = %Exp:SF1->F1_FORNECE% AND
			SD1.D1_LOJA    = %Exp:SF1->F1_LOJA% AND
			SD1.D1_FORMUL  = 'S' AND
			SD1.%NotDel%
		ORDER BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_ITEM,D1_COD
	EndSql	
	
	If SF1->F1_EST = 'EX'
		_nVrBsICms := SF1->F1_VALICM / 0.18 * 0.82
		cMensCli := "Imp. Importacao: "+transform(SF1->F1_II,"999,999,999.99") + " - Pis: " + transform(SF1->F1_VALIMP6,"999,999,999.99")
		cMensCli += "-Cofins : " + transform(SF1->F1_VALIMP5,"999,999,999.99") + chr(13)+chr(10)
		cMensCli += "Base Icms ( " + transform(_nVrBsICms,"999,999,999.99") + " / 0,82) * 18% =' ICMS ( " + transform(SF1->F1_VALICM,"999,999,999.99") + " ) " + chr(13) + chr(10)
		cMensCli += SF1->F1_XMENS1 + chr(13) + chr(10) + " Num Adicao: " + (cAliasSD1)->D1_ADIC + chr(13) + chr(10)
	Endif	
												
Endif

aadd(aRetorno,aProd)     
aadd(aRetorno,cMensCli)
aadd(aRetorno,cMensFis)
aadd(aRetorno,aDest)
aadd(aRetorno,aNota)
aadd(aRetorno,aInfoItem)
aadd(aRetorno,aDupl)
aadd(aRetorno,aTransp)
aadd(aRetorno,aEntrega)
aadd(aRetorno,aRetirada)
aadd(aRetorno,aVeiculo)
aadd(aRetorno,aReboque)            
aadd(aRetorno, aNfVincRur)
aadd(aRetorno, aEspVol)
aadd(aRetorno, aNfVinc)

Return(aRetorno)