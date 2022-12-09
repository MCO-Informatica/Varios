#include "Protheus.ch"
#include "TopConn.ch"
#include "Rwmake.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} M460FIM
Ponto de entrada para preenchimento do campo de classificação fiscal, de acordo 
preenhcimento do campo D2_CLASFIS. De acordo com a aplicação do Patch, a rotina
padrão não está informando corretamento o contéudo do campo.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		24/07/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
user function M460FIM()

	Local _aArea	:= GetArea()
	Local aDadosSE1 := {}

	dbSelectArea("SD2")
	SD2->(dbSetOrder(3))
	SD2->(dbGOTOP())
	If SD2->(dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		While SD2->(!EOF()) .And. SD2->( D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA ) == xFilial( "SD2" ) + SF2->( F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA )
			dbSelectArea("SFT") 
			SFT->(dbSetOrder(1))//FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO  
			If SFT->(dbSeek(xFilial("SFT") + PADR("S",TAMSX3("FT_TIPOMOV")[1]) + SD2->D2_SERIE + SD2->D2_DOC + SD2->D2_CLIENTE + SD2->D2_LOJA + PADR(SD2->D2_ITEM,TAMSX3("FT_ITEM")[1]) + SD2->D2_COD))
				RecLock("SFT",.F.)
				SFT->FT_CLASFIS	  	:= SD2->D2_CLASFIS	
				SFT->FT_CONTA		:= Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_CONTA")
				SFT->FT_POSIPI		:= Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_POSIPI")
				MSUNLOCK()
			EndIf
			
			dbSelectArea("CD2") 
			CD2->(dbSetOrder(1))
			If CD2->(dbSeek(xFilial("CD2") + "S" + SD2->D2_SERIE + SD2->D2_DOC + SD2->D2_CLIENTE + SD2->D2_LOJA + PADR(SD2->D2_ITEM,TAMSX3("CD2_ITEM")[1]) + SD2->D2_COD))//CD2_FILIAL+CD2_TPMOV+CD2_SERIE+CD2_DOC+CD2_CODCLI+CD2_LOJCLI+CD2_ITEM+CD2_CODPRO+CD2_IMP
				While SD2->D2_SERIE == CD2->CD2_SERIE .And. SD2->D2_DOC == CD2->CD2_DOC .And. SD2->D2_CLIENTE == CD2->CD2_CODCLI .And. SD2->D2_LOJA == CD2->CD2_LOJCLI .And. ALLTRIM(SD2->D2_ITEM) == ALLTRIM(CD2->CD2_ITEM) .And. SD2->D2_COD == CD2->CD2_CODPRO .And. CD2->CD2_TPMOV == "S" .And. CD2->CD2_FILIAL == xFilial("CD2")
					If ALLTRIM(CD2->CD2_IMP) == "ICM" .OR. ALLTRIM(CD2->CD2_IMP) == "SOL"
						RecLock("CD2",.F.)
						CD2->CD2_ORIGEM	:= SUBSTRING(SD2->D2_CLASFIS,1,1)
						CD2->CD2_CST	:= SUBSTRING(SD2->D2_CLASFIS,2,2)
						MSUNLOCK()
					EndIf
					CD2->(DBSKIP())
				EndDo
			EndIF
			SD2->(dbSkip())
		EndDo
	EndIf
	
	RestArea(_aArea)


//----> TRATATIVA DAS NOTAS COMPLEMENTARES DE ICMS
IF SF2->F2_TIPO$"I"
	If MsgYesNo("Deseja gerar contas a receber para essa nota complementar de ICMS?","Financeiro")
		AAdd(aDadosSE1,{SF2->F2_SERIE,;  	// 1
		SF2->F2_DOC,;				// 2
		SF2->F2_CLIENTE,;			// 3
		SF2->F2_LOJA,;				// 4
		"1308",;			// 5
		SF2->F2_EMISSAO,;			// 6
		SF2->F2_EMISSAO,;			// 7
		SF2->F2_EMISSAO,;			// 8
		SF2->F2_VALICM,;			// 9
		"DP",;				        // 10
		"1",;						// 11
		SF2->F2_VEND1,;         	// 12
		SC5->C5_NUM,;		        // 15
		SA1->A1_NREDUZ,;         	// 16
		"NF COMPL ICMS"})      		// 17
				
		If !Empty(Len(aDadosSE1))
			
			For nItem := 1 To Len(aDadosSE1)
				
				aPArc	:= Condicao(SF2->F2_VALICM,SF2->F2_COND,,dDataBase)
				
				If nItem <= Len(aParc)
					
					aDados := {}
					AADD( aDados, { "E1_FILIAL" 	, xFilial("SE1")		, Nil } )
					AADD( aDados, { "E1_PREFIXO" 	, aDadosSE1[nItem,1]	, Nil } )
					AADD( aDados, { "E1_NUM"     	, aDadosSE1[nItem,2]	, Nil } )
					AADD( aDados, { "E1_PARCELA"   	, aDadosSE1[nItem,11]	, Nil } )
					AADD( aDados, { "E1_TIPO"    	, aDadosSE1[nItem,10]	, Nil } )
					AADD( aDados, { "E1_CLIENTE"	, aDadosSE1[nItem,3]	, Nil } )
					AADD( aDados, { "E1_LOJA"    	, aDadosSE1[nItem,4]	, Nil } )
					AADD( aDados, { "E1_NATUREZ"    , "1308"			    , Nil } )
					AADD( aDados, { "E1_EMISSAO"   	, aDadosSE1[nItem,6]	, Nil } )
					AADD( aDados, { "E1_VENCTO"    	, aPArc[nItem,1]		, Nil } )
					AADD( aDados, { "E1_VENCREA"   	, aPArc[nItem,1]		, Nil } )
					AADD( aDados, { "E1_VALOR"    	, aPArc[nItem,2] 		, nIL})//nValor , Nil } )
					AADD( aDados, { "E1_SALDO"    	, aPArc[nItem,2] 		, nIL})//nValor , Nil } )
					AADD( aDados, { "E1_PEDIDO"     , aDadosSE1[nItem,15]	, Nil } )
					AADD( aDados, { "E1_HIST"    	, "NF COMPL ICMS -> "+aDadosSE1[nItem,2]+"/"+aDadosSE1[nItem,1]	, Nil } )
					AADD( aDados, { "E1_ORIGEM"    	, "MANUAL"				, Nil} )
					AADD( aDados, { "E1_VEND1"    	, aDadosSE1[nItem,12]	, Nil } )
					
					lMsErroAuto 	:= .F.
					MSExecAuto({|x, y| FINA040(x,y)}, aDados, 3)
					
					If lMsErroAuto
						MostraErro()
					EndIf
				EndIf
			Next
		Endif
	EndIf
EndIf
return()
