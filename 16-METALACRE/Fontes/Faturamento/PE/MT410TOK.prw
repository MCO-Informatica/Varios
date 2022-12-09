#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"                                                                                                         
#INCLUDE "COLORS.CH"     
#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"   

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT410CPY Autor   � Jonas                 � Data � 20/08/12 ���
�������������������������������������������������������������������������Ĵ��
���Objetivo  �Ponto de entrada executado na op��o de copia de pedidos     ���
���	para tratamento de reutilizacao de numeracao de						  ���
���	lacres para pedidos com devolucao.									  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � METALACRE                                                  ���
���                                                                       ���
���                                                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION MT410TOK()  

Local aArea 		:= GetArea()
Local lRet 			:= .T.
Local nPosITEM 		:= GDFIELDPOS("C6_ITEM")
Local nPosLACRE 	:= GDFIELDPOS("C6_XLACRE")
Local nPosQTDVEN 	:= GDFIELDPOS("C6_QTDVEN")
Local nPosPRCVEN 	:= GDFIELDPOS("C6_PRCVEN")
Local nPosVALOR 	:= GDFIELDPOS("C6_VALOR")
Local nPosRECALC 	:= GDFIELDPOS("C6_RECALC")
Local nPosTES 		:= GDFIELDPOS("C6_TES")
Local nPosCF 		:= GDFIELDPOS("C6_CF")
Local nPosStandy	:= GDFIELDPOS('C6_XSTAND')// Bruno Abrigo em 12.06.12
Local nPosPed   	:= GDFIELDPOS("C6_NUM")           
Local nPosCOD   	:= GDFIELDPOS("C6_PRODUTO")   
Local nPosCTR   	:= GDFIELDPOS("C6_CONTRAT")   
Local nPosItCTR   	:= GDFIELDPOS("C6_ITEMCON")   
Local nPosPdCli   	:= GDFIELDPOS("C6_PEDCLI")   
Local nPosItCli   	:= GDFIELDPOS("C6_ITEMCLI")   
Local nPosItEnt   	:= GDFIELDPOS("C6_ENTREG")   
Local QTDENT	 	:= GDFIELDPOS("C6_QTDENT")
Local nx 			:= 1
Local bCampo
Local nPosLacreIni  := GDFIELDPOS("C6_XINIC")
Local nPosLacreFim  := GDFIELDPOS("C6_XFIM")


If cEmpAnt <> '01'
	Return lRet
Endif

If Type("_lReap") == "U"
	Public _lReap := .F. 
endif
   
If Type("_cPedRep") == "U"
	Public _cPedRep := ''
Endif            

if !_lReap 
//	aCols[nX][nPosRECALC] := '1' // Bruno Abrigo em 02/05/12 - Trata copia de pedido com status de nao recalcula
endif

// Se Volume N�o Estiver Preenchido ent�o Recalculo Pesos e Volume
If Empty(M->C5_VOLUME1) .And. SC5->(FieldPos("C5_PEDWEB")) > 0 .And. Empty(M->C5_PEDWEB)
	U_CalcPeso('')
Endif

If SC5->(FieldPos("C5_XCONTRA")) > 0
	lContrato	:=	!Empty(M->C5_XCONTRA)
	lFalhaCtr	:=	.f.
Else
	lContrato	:=  .f.
	lFalhaCtr	:=	.f.
Endif

// Limpa Coluna Stand By

For nx := 1 To Len(aCols)
	If !aCols[nx,Len(aHeader)+1] // se o acols n�o estiver deleta processa.
		If lContrato
			If Empty(aCols[nx,nPosCTR])
				lFalhaCtr	:=	.t.
				lRet := .f.
			Endif
		Endif
			
		If !AvaliaLacre('', aCols[nx,nPosITEM], aCols[nx,nPosCOD], aCols[nx,nPosQTDVEN], aCols[nx,nPosLACRE], M->C5_NUM, aCols[nx,nPosITEM], aCols[nx,nPosLacreIni], aCols[nx,nPosLacreFim], _lReap) // FUNCAO QUE Avalia o Calculo de NUMERACAO DOS LACRES 
			MsgStop("Aten��o o Item " + aCols[nx,nPosITEM] + " Ir� Gerar Numera��o Invalida em Lacres, Verifique !")
			lRet := .f.
		Endif
		
		// Valida Personalizacao X Cliente
		
		If !Empty(aCols[nx,nPosLACRE]) .And. !Z02->(dbSetOrder(3), dbSeek(xFilial("Z02")+aCols[nx,nPosLACRE]+M->C5_CLIENTE+M->C5_LOJACLI))
			MsgAlert('Personalizacao ' + aCols[nx,nPosLACRE] + ' N�o Localizada Para Este Cliente !! '+CRLF+" Item " + aCols[nx,nPosITEM] + " Favor Cadastrar ! ")
			lRet := .F.
		Endif
	Endif
Next nx

// Valida Entrega

// Limpa Coluna Stand By

dEntCab := M->C5_FECENT

lEntrega := .T.

For nx := 1 To Len(aCols)
	If !aCols[nx,Len(aHeader)+1] // se o acols n�o estiver deleta processa.
		dEntrega := aCols[nx,nPosItEnt]
		
		If dEntrega > dEntCab
			dEntCab	:=	dEntrega
		Endif
		
		If !GetNewPAR("MV_MTLEFDS",.T.)	// Bloqueia Entregas aos Fins de Semana .F. N�o Libera .T. Libera
			If Dow(dEntrega) == 1 .Or. Dow(dEntrega) == 7	// Domingo ou Sabado
				MsgStop("Aten��o dia " + DtoC(dEntrega) + " Trata-se de Domingo ou S�bado !")
				lEntrega := .F.
				Exit
			Endif
		Endif

		// Verifica se � feriado
		
		If SP3->(dbSetOrder(2), dbSeek(xFilial("SP3")+StrZero(Month(dEntrega),2)+StrZero(Day(dEntrega),2))) .And. SP3->P3_FIXO == 'S'
			MsgStop("Aten��o dia " + DtoC(dEntrega) + " Trata-se de Feriado (" + AllTrim(Capital(SP3->P3_DESC)) + "), Impossivel Agendar Entregas !")
			lEntrega := .F.
			Exit
		Else
			If SP3->(dbSetOrder(1), dbSeek(xFilial("SP3")+DtoS(dEntrega))) .And. SP3->P3_FIXO == 'N'
				MsgStop("Aten��o dia " + DtoC(dEntrega) + " Trata-se de Feriado (" + AllTrim(Capital(SP3->P3_DESC)) + "), Impossivel Agendar Entregas !")
				lEntrega := .F.
				Exit
			Endif
		Endif
	Endif
Next nx

If !lEntrega
	Return .F.
Endif

// Atualiza Data de Entrega do Cabe�alho do Pedido
// Caso a maior data de entrega dos itens seja superior a data de entrega do
// cabe�alho ent�o altera, caso contr�rio permanece a data informada.

M->C5_FECENT	:=	dEntCab

If GetEnvServer()$"VALIDACAO"
	Return .t.
Endif

// Valida Pedido e Item Pedido Cliente

lFalhaPdCli	:=	.F.
If M->C5_TIPO == 'N' .And. lRet
	For nx := 1 To Len(aCols)
		If !aCols[nx,Len(aHeader)+1] // se o acols n�o estiver deleta processa.

			If Empty(aCols[nx,nPosPdCli]) .Or. Empty(aCols[nx,nPosItCli])
				lFalhaPdCli	:=	.t.
				lRet := .f.
			Endif
			
			cItem	:=	StrZero(nX,3)
			cCFOP	:=	aCols[nx,nPosCF]

			If AllTrim(GetMV("MV_ESTADO")) <> AllTrim(SA1->A1_EST)
				If SA1->A1_EST=='EX' .And. Left(cCFOP,1)<>'7'
					MsgStop("Aten��o o Item " + cItem + " Esta com CFOP Exterior Errado, Redigite o Tipo de Saida (TES), Verifique !")
					lRet := .f.
					Exit
				ElseIf Left(cCFOP,1)<>'6' .And. SA1->A1_EST<>'EX'
					MsgStop("Aten��o o Item " + cItem + " Esta com CFOP Fora do Estado Errado, Redigite o Tipo de Saida (TES), Verifique !")
					lRet := .f.
					Exit
				Endif  						
			ElseIf AllTrim(GetMV("MV_ESTADO")) == AllTrim(SA1->A1_EST)
				If Left(cCFOP,1)<>'5'
					MsgStop("Aten��o o Item " + cItem + " Esta com CFOP Dentro do Estado Errado, Redigite o Tipo de Saida (TES), Verifique !")
					lRet := .f.
					Exit
				Endif  						
			Endif

			If cEmpAnt == '01'
	    		lRet := U_VldCarga(aCols[nx,nPosCOD],aCols[nx,nPosQTDVEN],aCols[nx,nPosItEnt],aCols[nx,nPosItem])
	    		If !lRet
					MsgStop("Aten��o o Item " + cItem + " Esta com Saldo Estourado na Entrega Programada, Verifique !")
					Exit
				Endif 
			Endif
		Endif
	Next nx
Endif

If !lRet
	Return lRet
Endif

If lFalhaPdCli
	MsgStop("Aten��o Para Pedidos de Vendas Normal, � Obrigat�rio o Preenchimento dos Campos [Pedido Cliente] e [Item Pedido Cliente] !")
Endif

// Validacao de Pedidos de Vendas Gerados Pelo CallCenter N�o Poderam ser Alterados

If Altera .And. lRet
	If SUA->(dbSetOrder(8), dbSeek(xFilial("SUA")+M->C5_NUM))
		For nCol := 1 To Len(aCols)
			If aCols[nCol,Len(aHeader)+1] // se o acols estiver deletada j� � falha
				lRet := .f.
				Exit
			Else
				If SUB->(dbSetOrder(3), dbSeek(xFilial("SUB")+M->C5_NUM+aCols[nCol][nPosITEM]))
					If aCols[nCol][nPosQTDVEN]<>SUB->UB_QUANT
						lRet := .f.;Exit
					Endif
					If aCols[nCol][nPosPRCVEN]<>SUB->UB_VRUNIT
						lRet := .f.;Exit
					Endif
					If aCols[nCol][nPosTES]<>SUB->UB_TES
						lRet := .f.;Exit
					Endif
					If aCols[nCol][nPosCOD]<>SUB->UB_PRODUTO
						lRet := .f.;Exit
					Endif
				Else
					lRet := .f.;Exit
				Endif
			Endif
		Next
	Endif
	
	If !lRet .And. !_lReap
		MsgStop("Aten��o Detectada Altera��o no Pedido Original, Comparando o Or�amento, Favor Cancelar tal Altera��o !")
	Else
		lRet := .t.
	Endif
Endif

// Atualiza��o Campo EMAIL1 (Financeiro) Cadastro de Cliente

If Empty(SA1->A1_EMAIL1) .And. lRet .And. M->C5_TIPO=='N'
	U_AtuMailCli()
Endif

If !Inclui .And. !Altera
	lRet := .T.
Else
	If lFalhaCtr .And. !_lReap .And. !Altera
		MsgStop("Aten��o Detectada Falha na R�plica de Itens de Contrato, " + Chr(13) + "o Mesmo dever� ser Utilizado com a Tecla F11, " + Chr(13) + "Delete os Itens Divergentes com o Campo N.Contrato Vazio !")
		lRet := .f.               
	Else
		lRet := .t.
	Endif
Endif
                                                                                             
// Vendas MetalSeal ou MPM

If M->C5_CLIENTE+M->C5_LOJACLI$GetNewPar("MV_MTLCVN",'00132001*01140401') .And. (Empty(M->C5_CLIMTS) .Or. Empty(M->C5_LOJMTS))
	MsgStop("Aten��o Para Vendas MetalSeal ou MPM, o Campo Cliente e Loja MTS Deve Ser Preenchido Obrigatoriamente !")
	lRet := .f.               
Endif

RestArea(aArea)
RETURN lRet





/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcLacre � Autor �Mateus Hengle       � Data � 21/10/2013  ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao que Calcula o Lacre Inicial e Final				  ���
�������������������������������������������������������������������������͹��
���          � 													          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AvaliaLacre(cNumX, cItem, cProd, nQtde, cLacre, cNumAT, cItemAT, nLacreIni, nLacreFim, lCopia)
Local aArea := GetArea()
Local nNumLacre := 0
DEFAULT nLacreIni := 0
DEFAULT nLacreFim := 0

If !lCopia
	IF !EMPTY(cLacre) .And. Empty(nLacreIni) // SE O CAMPO LACRE ESTIVER VAZIO ELE NAO CALCULA A NUMERACAO
		If !Z00->(dbSetOrder(1), dbSeek(xFilial("Z00")+cLacre))
			RestArea(aArea)
			Return .f.
		Endif
	
		nNumLacre 	:= Z00->Z00_LACRE	// Numera��o Atual do Lacre
		nLacreIni	:= nNumLacre
		nLacreFim	:= (nNumLacre + nQtde) - 1
	
		If !ValLacre(cLacre,nLacreIni,nLacreFim,cItem,cNumAT)
			RestArea(aArea)
			Return .f.
		Endif
		
		IF Z00->Z00_PDINME == 'S'
			IF LEN(ALLTRIM(STR(nLacreFim))) > 6  .OR. nLacreFim > 999999
				MSGALERT("A numera��o do lacre do item " + cProd + " atingiu o numero de caracteres configurado na tabela de personaliza��o.")
				MSGALERT("Favor incluir uma NOVA personaliza��o para o cliente " + ALLTRIM(M->C5_CLIENTE)  + ", LOJA " + M->C5_LOJACLI + ".") 
				RestArea(aArea)
				Return .f.
			ENDIF	
	   	ELSE
			IF LEN(ALLTRIM(STR(nLacreFim ))) > Z00->Z00_TMLACRE
				MSGALERT("A numera��o do lacre do item " + cProd + " atingiu o numero de caracteres configurado na tabela de personaliza��o.")
				MSGALERT("Favor verificar a personaliza��o " + cLacre + " e aumente o numero do campo Tamanho do lacre.")
				RestArea(aArea)
				Return .f.
			ENDIF
		ENDIF
	ENDIF
Endif
RestArea(aArea)
Return .t.

Static Function ValLacre(cPerso,nInicio,nFim,cItem,cNumSc5)
Local aArea := GetArea()

cQry:= " SELECT *"
cQry+= " FROM "+RETSQLNAME("Z01")+" Z01"
cQry+= " WHERE Z01_COD = '"+cPerso+"' "
cQry+= " AND Z01.D_E_L_E_T_='' "
cQry+= " AND Z01.Z01_PV <> '" + cNumSc5 + "' "
cQry+= " AND (" + AllTrim(Str(nInicio)) + " BETWEEN Z01_INIC AND Z01_FIM OR "
cQry+= " 	  " + AllTrim(Str(nFim))    + " BETWEEN Z01_INIC AND Z01_FIM)   "

If Select("TRF") > 0
	TRF->(dbCloseArea())
EndIf
TCQUERY cQry New Alias "TRF"    

Count To nRecTot

If !Empty(nRecTot)                               
	Alert("Aten��o Item " + cItem + " Com Lacre Inicial e Final J� Utilizado na Personaliza��o " + cPerso + " Verifique !!! ")
	TRF->(dbCloseArea())
	RestArea(aArea)
	Return .f.     
Endif
TRF->(dbCloseArea())
RestArea(aArea)
Return .t.     


