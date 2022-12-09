#INCLUDE 'Protheus.ch'
#INCLUDE 'TopConn.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GERFAT    �Autor  �Darcio R. Sporl     � Data �  25/05/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao criada para gerar o faturamento automatico, apos a   ���
���          �devolucao do poder de terceiros.                            ���
�������������������������������������������������������������������������͹��
���Parametros� 1- cPedido     - Numero do pedido                          ���
���          � 2- nIdJob      - Faz a funcao de semaforo                  ���
���          � 3- lFat        - Indica se e faturamento do item de fatura-���
���          �                - mento ou do item de entrega.              ���
�������������������������������������������������������������������������͹��
���Uso       � OPVS / Certsign                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GERFAT(cPedido, nIdJob, lFat)
Local aArea			:= GetArea()
Local nQtdLib 		:= 0
Local nQtdVen		:= 0
Local cMensagem		:= ""
Local cCategoSFW	:= GetNewPar("MV_GARSFT", "2")
Local cCategoHRD	:= GetNewPar("MV_GARHRD", "1")
Local cQueryHrd		:= ""
Local cQuerySfw		:= ""
Local cNotaHrd		:= ""
Local cNotaSfw		:= ""
Local nRecSF2Sfw	:= 0
Local nRecSF2Hrd	:= 0
Local aRetTrans		:= {}
Local aRetEspelho	:= {}
Local nTime			:= 0
Local cRandom		:= ""
Local nWait			:= 0
Local nRecC6		:= 0
Local lRet			:= .T.
Local cPosto		:= ""
Local cCliente		:= ""
Local cLojaCli		:= ""
Local cNumDoc		:= ""

Default nIdJob		:= 1 //->Numero pedido do site
Default lFat		:= .T.

If lFat
	//���������������������������������������������������������������������������Ŀ
	//�Faturamento de Hardware - NOTA FISCAL DE PRODUTO - SEFAZ                   �
	//�����������������������������������������������������������������������������
	cQueryHrd:=	" SELECT  SC6.R_E_C_N_O_ RECHRD " +;
	" FROM    " + RetSQLName("SC6") + " SC6, " + RetSQLName("SB1") + " SB1 " +;
	" WHERE   SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND " +;
	"         SC6.C6_NUM = '" + cPedido + "' AND " +;
	"         SC6.C6_NOTA = ' ' AND " +;
	"         SC6.C6_SERIE = ' ' AND " +;
	"         SC6.C6_XOPER = '52' AND " +;
	"         SC6.D_E_L_E_T_ = ' ' AND " +;
	"         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND " +;
	"         SB1.B1_COD = SC6.C6_PRODUTO AND " +;
	"         SB1.B1_CATEGO = '" + cCategoHRD + "' AND " +;
	"         SB1.D_E_L_E_T_ = ' ' "
	PLSQuery( cQueryHrd, "QRYHRD" )
	
	//	Conout("Query Hardware: " + cQueryHrd)
	
	If QRYHRD->(!Eof())
		DbSelectArea("SC6")
		DbSetOrder(1)
		
		nRecC6 := QRYHRD->RECHRD
		
		While QRYHRD->(!EOF())
			
			DbGoto(QRYHRD->RECHRD)
			
			RecLock("SC6")
			Begin Transaction
			nQtdLib += MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.,.F.,.F.,.F.,.F.)
			nQtdVen += SC6->C6_QTDVEN
			End Transaction
			SC6->(MsUnLock())
			
			Begin Transaction
			SC6->(MaLiberOk({cPedido},.F.))
			End Transaction
			
			QRYHRD->(dbskip())
			
		EndDo
		
		FtJobNFs("SC9",GetNewPar("MV_GARSHRD","2  "),.F.,.F.,.F.,.F.,.F.,0,0,0,.F.,.F.,cPedido,nIdJob)
		
		// Reposiciono no pedido que acabou de ser faturado para pegar o numero da nota
		DbSelectArea("SC6")
		DbSetOrder(1)
		SC6->(DbGoTo(nRecC6))
		
		DbSelectArea("SF2")
		DbSetOrder(1)
		If DbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE)
			
			U_GTPutIN(Alltrim(Str(nIdJob)),"N",Alltrim(Str(nIdJob)),.T.,{"U_GerFat",Alltrim(Str(nIdJob))})
			
			nRecSF2Hrd := SF2->(Recno())
			
			If nRecSF2Hrd > 0
				
				// Se chegou nota de hardware, transmite e gera espelho tb
				
				SF2->( DbGoto(nRecSF2Hrd) )
				
				// Transmite a nota eletronica para o SEFAZ e aguarda a resposta da efetivacao
				aRetTrans := U_Transmitenfe(SF2->F2_DOC,SF2->F2_SERIE,cPedido)
				varinfo("aRetTrans -- ", aRetTrans)
				// 000132 - Codigo referente a dados com erro, naum adiante tentar retransmitir.
				// os demais codigos sao referentes a falhas na comunicacao.
				If aRetTrans[1]
					
					// Se nao transmitiu, envio para o JOB de retransmissao
					//U_RetranNFE(aRetTrans,SF2->F2_DOC,SF2->F2_SERIE)
					
					// TESTE - REMOVER DEPOIS...
					// Espera um minuto
					// WaitTime(60)
					// TESTE - REMOVER DEPOIS...
					
					nTime := Seconds()
					//					Conout("ESPELHO -- Iniciando ...")
					
					While .T.
						
						// Gera o arquivo espelho da nota fiscal
						SF2->( DbGoto(nRecSF2Hrd) )
						
						SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
						SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )
						
						SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
						SC5->( MsSeek( xFilial("SC5")+SC6->C6_NUM ) )
						
						aRetEspelho := U_GARR010(aRetTrans,@cRandom)
						
						If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
							
							If aRetTrans[1] .AND. (!SF2->F2_FIMP $ "D")
								SF2->( DbGoto(nRecSF2Hrd) )
								SF2->( RecLock("SF2",.F.) )
								SF2->F2_FIMP := "S"
								SF2->( MsUnLock() )
							EndIf
							
							// Enviou / Gerou certinho ? Pode sair
							U_Mystatus2("ESPELHO -- saindo 001 - gerou o espelho : "+str(Seconds()-nTime))
							Exit
						Else
							U_Mystatus2("ESPELHO -- Tentou gerar o espelho e falhou : "+str(Seconds()-nTime))
						Endif
						
						If Len(aRetEspelho) > 1 .AND. aRetEspelho[2] == "000134"
							// Ocorrencia 000134, pode sair
							// ( Impressao fora de job , uso com remote por exemplo )
							U_Mystatus2("ESPELHO -- saindo 002 - Impressao fora de job , uso com remote por exemplo : "+str(Seconds()-nTime))
							Exit
						Endif
						
						If !aRetTrans[1]
							// Se nao transmitiu nao adiante insistir na impressao do PDF, entao pode sair
							U_Mystatus2("ESPELHO -- saindo 003 - nao transmitiu para o SEFAZ : "+str(Seconds()-nTime))
							Exit
						Endif
						
						// Verifica quanto tempo esta tentando enviar ...
						// Se passou da 00:00, recalcula tempo
						nWait := Seconds()-nTime
						If nWait < 0
							nWait += 86400
						Endif
						
						If nWait > GetNewPar("MV_TIMESP", 120 )
							// Passou de 2 minutos tentando ? Desiste !
							U_Mystatus2("ESPELHO -- saindo 004 - time out : "+str(Seconds()-nTime))
							EXIT
						Endif
						
						// Espera um pouco ( 5 segundos ) para tentar novamente
						
						Sleep(5000)
						U_Mystatus2("ESPELHO -- dormindo 5 segundos... zzzzz...  : "+str(Seconds()-nTime))
						
					EndDo
					U_Mystatus2("ESPELHO -- fora do loop  : "+str(Seconds()-nTime))
					
					If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
						// Se gerou espelho, recupera URI do espelho
						cNotaHrd := aRetEspelho[4]
					Else
						lRet := .f.
						cMensagem += "Inconsist�ncia ao Gerar Danfe de Produto "
					Endif
				Endif
			Endif
		Else
			lRet := .f.
			cMensagem += "Inconsist�ncia ao Gerar Nota de Produto "
		EndIf
	ELSE
		
		//VERIFICA SE EXISTE NOTA E ATUALIZA O FLAG DE STATUS DO PEDIDO PARA APLICA��O JAVA.
		SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
		SC5->( MsSeek( xFilial("SC5")+cPedido) )
		
		IF Empty(SC5->C5_XNFHRD)
			
			While .T.
				
				SC6->( DbSetOrder(1) )
				SC6->( MsSeek( xFilial("SC6")+cPedido) )
				
				nRecSF2Hrd:=0
				
				While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM==xFilial("SC6")+cPedido
					
					If SC6->C6_XOPER == '52' .And. !Empty(SC6->C6_NOTA)
						DbSelectArea("SF2")
						DbSetOrder(1)
						If DbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE)
							nRecSF2Hrd:=Recno()
							Exit
						Endif
					Endif
					
					SC6->(DbSkip())
				EndDo
				
				If nRecSF2Hrd > 0
					
					// Gera o arquivo espelho da nota fiscal
					SF2->( DbGoto(nRecSF2Hrd) )
					
					SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
					SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) ) 
					
					Aadd( aRetTrans, .T. )
					Aadd( aRetTrans, "000131")
					Aadd( aRetTrans, IF(!Empty(SC5->C5_XNPSITE),SC5->C5_XNPSITE, SC5->C5_CHVBPAG))
					Aadd( aRetTrans, "NF HARDWARE : "+SF2->(F2_DOC+F2_SERIE))
					
					aRetEspelho := U_GARR010(aRetTrans,@cRandom)
					
					If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
						
						If (!SF2->F2_FIMP $ "D")
							SF2->( DbGoto(nRecSF2Hrd) )
							SF2->( RecLock("SF2",.F.) )
							SF2->F2_FIMP := "S"
							SF2->( MsUnLock() )
						EndIf                      �
						
						// Enviou / Gerou certinho ? Pode sair
						U_Mystatus2("ESPELHO -- saindo 001 - gerou o espelho : "+str(Seconds()-nTime))
						Exit
					Else
						U_Mystatus2("ESPELHO -- Tentou gerar o espelho e falhou : "+str(Seconds()-nTime))
					Endif
					
					If Len(aRetEspelho) > 1 .AND. aRetEspelho[2] == "000134"
						// Ocorrencia 000134, pode sair
						// ( Impressao fora de job , uso com remote por exemplo )
						U_Mystatus2("ESPELHO -- saindo 002 - Impressao fora de job , uso com remote por exemplo : "+str(Seconds()-nTime))
						Exit
					Endif
					
					If !aRetTrans[1]
						// Se nao transmitiu nao adiante insistir na impressao do PDF, entao pode sair
						U_Mystatus2("ESPELHO -- saindo 003 - nao transmitiu para o SEFAZ : "+str(Seconds()-nTime))
						Exit
					Endif
					
					// Verifica quanto tempo esta tentando enviar ...
					// Se passou da 00:00, recalcula tempo
					nWait := Seconds()-nTime
					If nWait < 0
						nWait += 86400
					Endif
					
					If nWait > GetNewPar("MV_TIMESP", 120 )
						// Passou de 2 minutos tentando ? Desiste !
						U_Mystatus2("ESPELHO -- saindo 004 - time out : "+str(Seconds()-nTime))
						EXIT
					Endif
					
					// Espera um pouco ( 5 segundos ) para tentar novamente
					
					Sleep(5000)
					U_Mystatus2("ESPELHO -- dormindo 5 segundos... zzzzz...  : "+str(Seconds()-nTime))
				Else
					U_Mystatus2("ESPELHO -- saindo 005 - Nota n�o encontrada : "+str(Seconds()-nTime))
					EXIT
				Endif
				
				
			EndDo
			
			
			U_Mystatus2("ESPELHO -- fora do loop  : "+str(Seconds()-nTime))
			
			If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
				// Se gerou espelho, recupera URI do espelho
				cNotaHrd := aRetEspelho[4]
			Else
				lRet := .f.
				cMensagem += "Inconsist�ncia ao Gerar Danfe de Produto "
			Endif
		
		ELSE
			RecLock("SC5", .F.)
			Replace SC5->C5_XFLAGEN With ''
			SC5->(MsUnLock())
		Endif
	EndIf
	
	//	Conout("Nota Fiscal Hardware: " + cNotaHrd)
	
	If !Empty(cNotaHrd)
		SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
		SC5->( MsSeek( xFilial("SC5")+cPedido ) )
		RecLock("SC5", .F.)
		Replace SC5->C5_XNFHRD With cNotaHrd
		Replace SC5->C5_XFLAGEN With ''
		SC5->(MsUnLock())
	EndIf
	
	DbSelectArea("QRYHRD")
	DbCloseArea()
	
	//���������������������������������������������������������������������������Ŀ
	//�Faturamento de Software - NOTA FISCAL DE SERVICO - PREFEITURA DE SAO PAULO �
	//�����������������������������������������������������������������������������
	cQuerySfw:=	" SELECT  SC6.R_E_C_N_O_ RECSFW " +;
	" FROM    " + RetSQLName("SC6") + " SC6, " + RetSQLName("SB1") + " SB1 " +;
	" WHERE   SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND " +;
	"         SC6.C6_NUM = '" + cPedido + "' AND " +;
	"         SC6.C6_NOTA = ' ' AND " +;
	"         SC6.C6_SERIE = ' ' AND " +;
	"         SC6.C6_XOPER = '51' AND " +;
	"         SC6.D_E_L_E_T_ = ' ' AND " +;
	"         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND " +;
	"         SB1.B1_COD = SC6.C6_PRODUTO AND " +;
	"         SB1.B1_CATEGO = '" + cCategoSFW + "' AND " +;
	"         SB1.D_E_L_E_T_ = ' ' "
	PLSQuery( cQuerySfw, "QRYSFW" )
	
	If QRYSFW->(!Eof())
		DbSelectArea("SC6")
		DbSetOrder(1)
		
		nRecC6 := QRYSFW->RECSFW
		
		While QRYSFW->(!EOF())
			
			SC6->(DbGoTo(QRYSFW->RECSFW))
			
			RecLock("SC6")
			Begin Transaction
			nQtdLib += MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.,.F.,.F.,.F.,.F.)
			nQtdVen += SC6->C6_QTDVEN
			End Transaction
			SC6->(MsUnLock())
			
			Begin Transaction
			SC6->(MaLiberOk({cPedido},.F.))
			End Transaction
			
			
			QRYSFW->(dbskip())
			
		End
		
		FtJobNFs("SC9",GetNewPar("MV_GARSSFW","RP2"),.F.,.F.,.F.,.F.,.F.,0,0,0,.F.,.F.,cPedido,nIdJob)
		
		// Reposiciono no pedido que acabou de ser faturado para pegar o numero da nota
		DbSelectArea("SC6")
		DbSetOrder(1)
		SC6->(DbGoTo(nRecC6))
		
		DbSelectArea("SF2")
		DbSetOrder(1)
		If DbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE)
			
			nRecSF2Sfw := SF2->(Recno())
			
			If nRecSF2Sfw > 0
				
				// Se chegou uma nota de servi�o executa a transmissao para a PMSP
				
				SF2->( DbGoto(nRecSF2Sfw) )
				
				// A Totvs nao disponibilizou a transmi��o da RPS para a prefeitura via WEBSERVICES.
				// Esta funcao sempre vai retornar TRUE ateh que a funcao da tranmiss�o seja criada
				aRetTraPMSP := U_TransPMSP(SF2->F2_DOC,SF2->F2_SERIE,aDadosSC5[nPC5_CHVBPAG][2])
				
				If !aRetTraPMSP[1]
					// Se nao transmitiu, envio para o JOB de retransmissao
					U_RetranPMSP(aRetTraPMSP,SF2->F2_DOC,SF2->F2_SERIE,aDadosSC5[nPC5_CHVBPAG][2])
				Endif
				
				// Gera o arquivo espelho da nota de servico
				aRetEspPMSP := U_GARR020(aRetTraPMSP,.T.)
				
				If aRetEspPMSP[1]
					// Se o espelho foi gerado, recupera URI do espelho
					cNotaSfw := aRetEspPMSP[4]
				Else
					lRet := .f.
					cMensagem += "Inconsist�ncia ao Gerar RPS de Servi�o "
				Endif
			Endif
		Else
			lRet := .F.
			cMensagem += "Inconsist�ncia ao Gerar Nota de Servi�o "
		EndIf
	Else
		//VERIFICA SE EXISTE NOTA E ATUALIZA O FLAG DE STATUS DO PEDIDO PARA APLICA��O JAVA.
		SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
		SC5->( MsSeek( xFilial("SC5")+cPedido) )
		
		IF Empty(SC5->C5_XNFSFW)
			
			SC6->( DbSetOrder(1) )
			SC6->( MsSeek( xFilial("SC6")+cPedido) ) 
			
			nRecSF2Hrd:=0
			
			While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM==xFilial("SC6")+cPedido
				
				If SC6->C6_XOPER == '51' .And. !Empty(SC6->C6_NOTA)
					DbSelectArea("SF2")
					DbSetOrder(1)
					If DbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE)
						nRecSF2Hrd:=Recno()
						Exit
					Endif
				Endif
				
				SC6->(DbSkip())
			EndDo
			
			If nRecSF2Hrd > 0    
			
				Aadd( aRetTraPMSP, .T. )
				Aadd( aRetTraPMSP, "000131")
				Aadd( aRetTraPMSP, IF(Empty(SC5->C5_XNPSITE),SC5->C5_XNPSITE, SC5->C5_CHVBPAG))
				Aadd( aRetTraPMSP, "NF SOFTWARE : "+SF2->(F2_DOC+F2_SERIE))

				// Gera o arquivo espelho da nota de servico
				aRetEspPMSP := U_GARR020(aRetTraPMSP,.T.)
				
				If aRetEspPMSP[1]
					// Se o espelho foi gerado, recupera URI do espelho
					cNotaSfw := aRetEspPMSP[4]
				Else
					lRet := .f.
					cMensagem += "Inconsist�ncia ao Gerar RPS de Servi�o "
				Endif
			Endif
		Endif
	EndIf
	
	//	Conout("Nota Fiscal Software: " + cNotaSfw)
	
	If !Empty(cNotaSfw)
		SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
		SC5->( MsSeek( xFilial("SC5")+SC6->C6_NUM ) )
		RecLock("SC5", .F.)
		Replace SC5->C5_XNFSFW With cNotaSfw
		SC5->(MsUnLock())
	EndIf
	
	DbSelectArea("QRYSFW")
	DbCloseArea()
	
	If !Empty(SC6->C6_XNUMVOU)
		U_MovVoucher(SC6->C6_NUM, SC6->C6_XNUMVOU, SC6->C6_XQTDVOU, SC6->C6_ITEM)
	EndIf
	
	/*
	If nQtdLib == nQtdVen
	cMensagem += "Inconsist�ncia ao Gerar Nota de Produto"
	Else
	cMensagem := "Foram Encontrados Inconsist�ncias na Libera��o. Entre em contato com a �rea Responsavel!"
	EndIf
	*/
	
	//	Conout("Pedido: " + cPedido)
Else	//Nota Fiscal de entrega
	
	DbSelectArea("SC5")
	SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
	SC5->( MsSeek( xFilial("SC5") + cPedido ) )
	
	cPosto := SC5->C5_XPOSTO
	
	DbSelectArea("SZ3")
	SZ3->( DbSetOrder(4) )
	SZ3->( DbSeek(xFilial("SZ3") + cPosto) )
	
	cCliente := SZ3->Z3_CLIENTE
	cLojaCli := SZ3->Z3_LOJACLI
	
	//���������������������������������������������������������������������������Ŀ
	//�Faturamento de Hardware - NOTA FISCAL DE PRODUTO - SEFAZ - ENTREGA         �
	//�����������������������������������������������������������������������������
	cQueryHrd:=	" SELECT  SC6.R_E_C_N_O_ RECHRD " +;
	" FROM    " + RetSQLName("SC6") + " SC6, " + RetSQLName("SB1") + " SB1 " +;
	" WHERE   SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND " +;
	"         SC6.C6_NUM = '" + cPedido + "' AND " +;
	"         SC6.C6_NOTA = ' ' AND " +;
	"         SC6.C6_SERIE = ' ' AND " +;
	"         SC6.C6_XOPER = '53' AND " +;
	"         SC6.D_E_L_E_T_ = ' ' AND " +;
	"         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND " +;
	"         SB1.B1_COD = SC6.C6_PRODUTO AND " +;
	"         SB1.B1_CATEGO = '" + cCategoHRD + "' AND " +;
	"         SB1.D_E_L_E_T_ = ' ' "
	PLSQuery( cQueryHrd, "QRYHRD" )
	
	//	Conout("Query Hardware: " + cQueryHrd)
	
	If QRYHRD->(!Eof())
		
		nRecC6 := QRYHRD->RECHRD
		
		While QRYHRD->(!EOF())
			
			DbSelectArea("SC6")
			DbSetOrder(1)
			DbGoto(QRYHRD->RECHRD)
			
			RecLock("SC6")
			Begin Transaction
//			U_PodTer(cCliente, cLojaCli, SC6->C6_PRODUTO, SC6->C6_QTDVEN)
			nQtdLib += MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.,.F.,.F.,.F.,.F.)
			nQtdVen += SC6->C6_QTDVEN
			End Transaction
			SC6->(MsUnLock())
			
			Begin Transaction
			SC6->(MaLiberOk({cPedido},.F.))
			End Transaction
			
			QRYHRD->(dbskip())
			
		End
		
		FtJobNFs("SC9",GetNewPar("MV_GARSHRD","2  "),.F.,.F.,.F.,.F.,.F.,0,0,0,.F.,.F.,cPedido,nIdJob)
		
		// Reposiciono no pedido que acabou de ser faturado para pegar o numero da nota
		DbSelectArea("SC6")
		DbSetOrder(1)
		SC6->(DbGoTo(nRecC6))
		
		DbSelectArea("SF2")
		DbSetOrder(1)
		If DbSeek(xFilial("SF2") + SC6->C6_NOTA + SC6->C6_SERIE)
			
			U_GTPutIN(Alltrim(Str(nIdJob)),"N",Alltrim(Str(nIdJob)),.T.,{"U_GerFat",Alltrim(Str(nIdJob))})
			
			nRecSF2Hrd := SF2->(Recno())
			
			If nRecSF2Hrd > 0
				
				// Se chegou nota de hardware, transmite e gera espelho tb
				
				SF2->( DbGoto(nRecSF2Hrd) )
				
				// Transmite a nota eletronica para o SEFAZ e aguarda a resposta da efetivacao
				aRetTrans := U_Transmitenfe(SF2->F2_DOC,SF2->F2_SERIE,cPedido)
				varinfo("aRetTrans -- ", aRetTrans)
				// 000132 - Codigo referente a dados com erro, naum adiante tentar retransmitir.
				// os demais codigos sao referentes a falhas na comunicacao.
				If aRetTrans[1]
					
					// Se nao transmitiu, envio para o JOB de retransmissao
					//U_RetranNFE(aRetTrans,SF2->F2_DOC,SF2->F2_SERIE)
					
					// TESTE - REMOVER DEPOIS...
					// Espera um minuto
					// WaitTime(60)
					// TESTE - REMOVER DEPOIS...
					
					nTime := Seconds()
					//					Conout("ESPELHO -- Iniciando ...")
					
					While .T.
						
						// Gera o arquivo espelho da nota fiscal
						SF2->( DbGoto(nRecSF2Hrd) )
						
						SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
						SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )
						
						SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
						SC5->( MsSeek( xFilial("SC5")+SC6->C6_NUM ) )
						
						aRetEspelho := U_GARR010(aRetTrans,@cRandom)
						
						If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
							
							If aRetTrans[1] .AND. (!SF2->F2_FIMP $ "D")
								SF2->( DbGoto(nRecSF2Hrd) )
								SF2->( RecLock("SF2",.F.) )
								SF2->F2_FIMP := "S"
								SF2->( MsUnLock() )
							EndIf
							
							// Enviou / Gerou certinho ? Pode sair
							U_Mystatus2("ESPELHO -- saindo 001 - gerou o espelho : "+str(Seconds()-nTime))
							Exit
						Else
							U_Mystatus2("ESPELHO -- Tentou gerar o espelho e falhou : "+str(Seconds()-nTime))
						Endif
						
						If Len(aRetEspelho) > 1 .AND. aRetEspelho[2] == "000134"
							// Ocorrencia 000134, pode sair
							// ( Impressao fora de job , uso com remote por exemplo )
							U_Mystatus2("ESPELHO -- saindo 002 - Impressao fora de job , uso com remote por exemplo : "+str(Seconds()-nTime))
							Exit
						Endif
						
						If !aRetTrans[1]
							// Se nao transmitiu nao adiante insistir na impressao do PDF, entao pode sair
							U_Mystatus2("ESPELHO -- saindo 003 - nao transmitiu para o SEFAZ : "+str(Seconds()-nTime))
							Exit
						Endif
						
						// Verifica quanto tempo esta tentando enviar ...
						// Se passou da 00:00, recalcula tempo
						nWait := Seconds()-nTime
						If nWait < 0
							nWait += 86400
						Endif
						
						If nWait > GetNewPar("MV_TIMESP", 120 )
							// Passou de 2 minutos tentando ? Desiste !
							U_Mystatus2("ESPELHO -- saindo 004 - time out : "+str(Seconds()-nTime))
							EXIT
						Endif
						
						// Espera um pouco ( 5 segundos ) para tentar novamente
						
						Sleep(5000)
						U_Mystatus2("ESPELHO -- dormindo 5 segundos... zzzzz...  : "+str(Seconds()-nTime))
						
					EndDo
					U_Mystatus2("ESPELHO -- fora do loop  : "+str(Seconds()-nTime))
					
					If Len(aRetEspelho) > 0 .AND. aRetEspelho[1]
						// Se gerou espelho, recupera URI do espelho
						cNotaHrd := aRetEspelho[4]
					Else
						lRet := .f.
						cMensagem += "Inconsist�ncia ao Gerar Danfe de Produto "
					Endif
				Endif
			Endif
		Else
			lRet := .f.
			cMensagem += "Inconsist�ncia ao Gerar Nota de Produto "
		EndIf
	EndIf
	
	//	Conout("Nota Fiscal Hardware: " + cNotaHrd)
	
	If !Empty(cNotaHrd)
		SC5->( DbSetOrder(1) )		// C5_FILIAL+C5_NUM
		SC5->( MsSeek( xFilial("SC5")+SC6->C6_NUM ) )
		RecLock("SC5", .F.)
		Replace SC5->C5_XNFHRE With cNotaHrd
		Replace SC5->C5_STENTR With "1"
		Replace SC5->C5_XFLAGEN With Space(TamSX3("C5_XFLAGEN")[1])
		SC5->(MsUnLock())
	EndIf
	
	DbSelectArea("QRYHRD")
	DbCloseArea()
EndIf

RestArea(aArea)
Return({lRet,cMensagem})

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GERFATP    �Autor  �Microsiga           � Data �  17/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Faturamento de Pedidos Manualmente                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GERFATP(cEmpP,cFilP,nRecPed)

//Abre empresa para Faturamento
IF !Empty(cEmpP)
	RpcSetType(2)
	RpcSetEnv(cEmpP,cFilP)
Endif
//Posiciona no Pedido
DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(DbGoTo(nRecPed))

//Processa Faturamento
U_GERFAT(SC5->C5_NUM, Val(SC5->C5_XNPSITE),.T.)

Return
