#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

// 21/05/2020 - Luiz
// Correção da impressão de observação - incluido no item e retirado do rodape
// Correção da impressão dos dados do fornecedor que não estava sendo impresso se mais de um pedido

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������                     
�������������������������������������������������������������������������ͻ��
���Programa  � LC13R    �Autor �Luis Henrique Robusto� Data �  25/10/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � PEDIDO DE COMPRAS (Emissao em formato Grafico)             ���
�������������������������������������������������������������������������͹��
���Uso       � Compras                                                    ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// alterar o parametro MV_PCOMPRA e colocar PEDGRF para substituir a impress�o padr�o.

User Function XPEDGRF()
Private	lEnd		:= .f.,;
		aAreaSC7	:= SC7->(GetArea()),;
		aAreaSA2	:= SA2->(GetArea()),;
		aAreaSA5	:= SA5->(GetArea()),;   
		aAreaSF4	:= SF4->(GetArea()),;
	 	cPerg		:= Padr('PEDGRF',10),;
        _nT         := 0
        


	 	//	aAreaSZF	:= SZF->(GetArea()),;

		//�����������������������
		//�Ajusta os parametros.�
		//�����������������������
		AjustaSX1(cPerg)

		// Se a Impress�o N�o Vier da Tela de Pedido de Compras ent�o Efetua Pergunta de Par�metros
		// Caso contr�rio ent�o posiciona no pedido que foi clicado a op��o imprimir.

		If Upper(ProcName(2)) <> 'A120IMPRI'
           	If !Pergunte(cPerg,.t.)
           		Return
           	Endif

			Private	cPedIni  	:= mv_par01			// Numero do Pedido de Compras
			Private	cPedFim  	:= mv_par02			// Numero do Pedido de Compras
			Private	lImpPrc		:= (MV_PAR03==2)	// Imprime os Precos ?
			Private	nTitulo 	:= MV_PAR04			// Titulo do Relatorio ?
			Private	cObserv1	:= MV_PAR05			// 1a Linha de Observacoes
			Private	cObserv2	:= MV_PAR06			// 2a Linha de Observacoes
			Private	cObserv3	:= MV_PAR07			// 3a Linha de Observacoes
			Private	cObserv4	:= MV_PAR08			// 4a Linha de Observacoes
			Private	lPrintCodFor:= (MV_PAR09==1)	// Imprime o Cvvvvvvvvvvvvvvvvvvvvvvvvvvvodigo do produto no fornecedor ?
			Private _nPag		:= 0

  		Else

			Private	cPedIni  	:= SC7->C7_NUM		// Numero do Pedido de Compras
			Private	cPedFim  	:= SC7->C7_NUM		// Numero do Pedido de Compras
			Private	lImpPrc		:= .t.	// Imprime os Precos ?
			Private	nTitulo 	:= 2			// Titulo do Relatorio ?
			Private	cObserv1	:= ''			// 1a Linha de Observacoes
			Private	cObserv2	:= ''			// 2a Linha de Observacoes
			Private	cObserv3	:= ''			// 3a Linha de Observacoes
			Private	cObserv4	:= ''			// 4a Linha de Observacoes
			Private	lPrintCodFor:= .f.	// Imprime o Codigo do produto no fornecedor ?
			Private _nPag		:= 0
		  Endif

		DbSelectArea('SC7')
		SC7->(DbSetOrder(1))
		If	( ! SC7->(DbSeek(xFilial('SC7') + cPedIni)) )
			Help('',1,'PEDGRF',,OemToAnsi('Pedido n�o encontrado.'),1)
			Return .f.
		EndIf

		//������������������������������Ŀ
		//�Executa a rotina de impressao �
		//��������������������������������
		Processa({ |lEnd| xPrintRel(),OemToAnsi('Gerando o relat�rio.')}, OemToAnsi('Aguarde...'))
		
		//��������������������������������������������Ŀ
		//�Restaura a area anterior ao processamento. !�
		//����������������������������������������������
		RestArea(aAreaSC7)
		RestArea(aAreaSA2)
		RestArea(aAreaSA5)
	 //	RestArea(aAreaSZF)
		RestArea(aAreaSF4)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � xPrintRel�Autor �Luis Henrique Robusto� Data �  10/09/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime a Duplicata...                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xPrintRel()

Private lEmail		:= .f.
Private	lFlag		:= .t.,;	// Controla a impressao do fornecedor
		nLinha		:= 3000,;	// Controla a linha por extenso
		nLinFim		:= 0,;		// Linha final para montar a caixa dos itens
		lPrintDesTab:= .f.,;	// Imprime a Descricao da tabela (a cada nova pagina)
		cRepres		:= Space(80)

Private	_nQtdReg	:= 0,;		// Numero de registros para intruir a regua
		_nValMerc 	:= 0,;		// Valor das mercadorias
		_nValIPI	:= 0,;		// Valor do I.P.I.
		_nValDesc	:= 0,;		// Valor de Desconto
		_nTotAcr	:= 0,;		// Valor total de acrescimo
		_nTotSeg	:= 0,;		// Valor de Seguro
		_nTotFre	:= 0,;		// Valor de Frete
		_nTotIcmsRet:= 0		// Valor do ICMS Retido


		If Alltrim(cFilAnt)$"0101"
			cLogo := "logo01.bmp"
		elseif Alltrim(cFilAnt)$"0102"
			cLogo := "logo02.bmp"
		elseif Alltrim(cFilAnt)$"0103"
			cLogo := "logo03.bmp"
		else
			cLogo := "logo04.bmp"
		EndIf

	
		//�������������������������������������Ŀ
		//�Posiciona nos arquivos necessarios. !�
		//���������������������������������������
		DbSelectArea('SA2')
		SA2->(DbSetOrder(1))
		If	! SA2->(DbSeek(xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA)))
			Help('',1,'REGNOIS')
			Return .f.
		EndIf
		
		/*If MsgYesNo("Deseja Enviar Pedido de Compra por Email ?") 
			lEmail := .t.
		Endif*/

		lViewPDF := !lEmail
		
		//���������������������������������������Ŀ
		//�Define que a impressao deve ser RETRATO�
		//�����������������������������������������
		lAdjustToLegacy := .T.   //.F.
		lDisableSetup  := .T.
		cFilename := Criatrab(Nil,.F.)
		oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup,,,,,,,lViewPDF)
	//	oPrint:Setup()
		oPrint:SetResolution(78)
		oPrint:SetLandscape()
		oPrint:SetPaperSize(DMPAPER_A4)  
		oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior 
		oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impress�o em IMP_PDF 
		cDiretorio := oPrint:cPathPDF
        //oPrint		:= TMSPrinter():New(OemToAnsi('Pedido de Compras')),;
		
Private	oBrush		:= TBrush():New(,4),;
		oPen		:= TPen():New(0,5,CLR_BLACK),;
		cFileLogo	:= GetSrvProfString('Startpath','') + cLogo,;
		oFont07		:= TFont():New( "Arial",,07,,.t.,,,,,.f. )
		oFont08		:= TFont():New( "Arial",,08,,.f.,,,,,.f. )
		oFont08n    := TFont():New( "Arial",,08,,.t.,,,,,.f. )
		oFont09		:= TFont():New( "Arial",,09,,.f.,,,,,.f. )
		oFont10		:= TFont():New( "Arial",,10,,.f.,,,,,.f. )
		oFont10n	:= TFont():New( "Arial",,10,,.t.,,,,,.f. )
		oFont11		:= TFont():New( "Arial",,11,,.f.,,,,,.f. )
		oFont12		:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
		oFont12n	:= TFont():New( "Arial",,13,,.t.,,,,,.f. )
		oFont14		:= TFont():New( "Arial",,14,,.f.,,,,,.f. )
		oFont15		:= TFont():New( "Arial",,15,,.f.,,,,,.f. )
		oFont18		:= TFont():New( "Arial",,18,,.f.,,,,,.f. )
		oFont16		:= TFont():New( "Arial",,16,,.f.,,,,,.f. )
		oFont20		:= TFont():New( "Arial",,20,,.f.,,,,,.f. )
		oFont22		:= TFont():New( "Arial",,22,,.f.,,,,,.f. )

	
		//�������������Ŀ
		//�Monta query !�    //SC7.C7_CODPRF, 
		//���������������
		cSELECT :=	'SC7.C7_FILIAL, SC7.C7_ITEM, SC7.C7_NUM, SC7.C7_EMISSAO, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_COND, SC7.C7_CONTATO, SC7.C7_OBS, SC7.C7_CC, SC7.C7_CLVL, '+;
					'SC7.C7_ITEM, SC7.C7_UM, SC7.C7_SEGUM, SC7.C7_PRODUTO, SC7.C7_DESCRI, SC7.C7_QUANT, SC7.C7_QTSEGUM, SC7.C7_OP, '+;
					'SC7.C7_PRECO, SC7.C7_IPI, SC7.C7_TOTAL, SC7.C7_VLDESC, SC7.C7_DESPESA, '+;
					'SC7.C7_SEGURO, SC7.C7_VALFRE, SC7.C7_TES, SC7.C7_ICMSRET, SC7.C7_DATPRF, SC7.C7_USER '

		cFROM   :=	RetSqlName('SC7') + ' SC7 '

		cWHERE  :=	'SC7.D_E_L_E_T_ <>   '+CHR(39) + '*'            +CHR(39) + ' AND '+;
					'SC7.C7_FILIAL  =    '+CHR(39) + xFilial('SC7') +CHR(39) + ' AND '+;
					'SC7.C7_NUM     BETWEEN   '+CHR(39) + cPedIni   +CHR(39) + ' AND '+CHR(39) + cPedFim   +CHR(39);

		cORDER  :=	'SC7.C7_FILIAL, SC7.C7_NUM, SC7.C7_ITEM '

		cQuery  :=	' SELECT '   + cSELECT + ; 
					' FROM '     + cFROM   + ;
					' WHERE '    + cWHERE  + ;
					' ORDER BY ' + cORDER

		TCQUERY cQuery NEW ALIAS 'TRA'   
		
		TcSetField('TRA','C7_DATPRF','D')
		TcSetField('TRA','C7_EMISSAO','D')

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf

		DbSelectArea('TRA')
		Count to _nQtdReg
		ProcRegua(_nQtdReg)
		TRA->(DbGoTop())

		cCompr := TRA->C7_USER
		
		cTipoSC7	:= IIF((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"PC","AE")
		cComprador 	:= UsrFullName(SC7->C7_USER)
		cAlter	 	:= ''
		cAprov	 	:= ''

		If !Empty(SC7->C7_GRUPCOM)
			dbSelectArea("SAJ")
			dbSetOrder(1)
			dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM)
			While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
				If SAJ->AJ_USER != SC7->C7_USER
					cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
				EndIf
				dbSelectArea("SAJ")
				dbSkip()
			EndDo
		EndIf

		// Aprovadores
		
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoSC7+SC7->C7_NUM)
		While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM) == xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO == cTipoSC7
			cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["
			Do Case
				Case SCR->CR_STATUS=="03" //Liberado
					cAprov += "Ok"
				Case SCR->CR_STATUS=="04" //Bloqueado
					cAprov += "BLQ"
				Case SCR->CR_STATUS=="05" //Nivel Liberado
					cAprov += "##"
				OtherWise                 //Aguar.Lib
					cAprov += "??"
			EndCase
			cAprov += "] - "
			dbSelectArea("SCR")
			dbSkip()
		Enddo

      	cObServ   := ''
      	_cObsItem := ''
      	_cObsMemo := ''
		_cDescClvl:= ''
		_cDescCC  := ''
	
	
		While TRA->( ! Eof() )

		    DbSelectArea('SA2')
		    SA2->(DbSetOrder(1))
		    If	! SA2->(DbSeek(xFilial('SA2')+TRA->(C7_FORNECE+C7_LOJA)))
			    Help('',1,'REGNOIS')
		    EndIf

            dbSelectArea("TRA")

			SC7->(dbSetOrder(1), dbSeek(xFilial("SC7")+TRA->C7_NUM+TRA->C7_ITEM))

			_cChave := TRA->C7_NUM
				
			_nPag     := 0

			_nValMerc 	:= 0		// Valor das mercadorias
			_nValIPI	:= 0		// Valor do I.P.I.
			_nValDesc	:= 0		// Valor de Desconto
			_nTotAcr	:= 0		// Valor total de acrescimo
			_nTotSeg	:= 0		// Valor de Seguro
			_nTotFre	:= 0		// Valor de Frete
			_nTotIcmsRet:= 0		// Valor do ICMS Retido

			While TRA->C7_NUM == _cChave

				xVerPag()

				If lFlag
					//����������Ŀ
					//�Fornecedor�
					//������������
					oPrint:Say(0530,0100,OemToAnsi('Fornecedor:'),oFont10)
					oPrint:Say(0520,0430,AllTrim(SA2->A2_NOME) + '  ('+AllTrim(SA2->A2_COD)+'/'+AllTrim(SA2->A2_LOJA)+')',oFont11)
					oPrint:Say(0580,0100,OemToAnsi('Endere�o:'),oFont10)
					oPrint:Say(0580,0430,SA2->A2_END,oFont11)
					oPrint:Say(0630,0100,OemToAnsi('Munic�pio/U.F.:'),oFont10)
					oPrint:Say(0630,0430,AllTrim(SA2->A2_MUN)+'/'+AllTrim(SA2->A2_EST),oFont11)
					oPrint:Say(0630,1100,OemToAnsi('CEP:'),oFont10)
					oPrint:Say(0630,1270,TransForm(SA2->A2_CEP,'@R 99.999-999'),oFont11)
					oPrint:Say(0680,0100,OemToAnsi('Telefone:'),oFont10)
					oPrint:Say(0680,0430,SA2->A2_TEL,oFont11)
					oPrint:Say(0680,1100,OemToAnsi('CNPJ:'),oFont10)
					oPrint:Say(0680,1270,Transform(SA2->A2_CGC,'@R 99.999.999/9999-99'),oFont11)
					oPrint:Say(0730,0100,OemToAnsi('Contato:'),oFont10)
					oPrint:Say(0730,0430,SC7->C7_CONTATO,oFont11)
					oPrint:Say(0730,1100,OemToAnsi('Email:'),oFont10)
					oPrint:Say(0730,1270,SA2->A2_EMAIL,oFont11)
					oPrint:Say(0780,0100,OemToAnsi('Prazo Pagamento:'),oFont12)
					If !Empty(SC7->C7_COND)
						If SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+SC7->C7_COND))
							oPrint:Say(0780,0500,SE4->E4_CODIGO + ' - ' + SE4->E4_DESCRI,oFont12n)
						Endif
					Endif
				
					//��������������Ŀ
					//�Numero/Emissao�
					//����������������
					oPrint:Box(0500,2550,0700,3000)
					oPrint:Say(0550,2650,OemToAnsi('N�mero Documento'),oFont10n)
					oPrint:Say(0600,2700,SC7->C7_NUM,oFont18)
					oPrint:Say(0650,2700,Dtoc(SC7->C7_EMISSAO),oFont12n)
					lFlag := .f.
				EndIf
					
				If	( lPrintDesTab )
					oPrint:Box(nLinha-30,100,nLinha+40,3000) 
					oPrint:Say(nLinha+10,0120,OemToAnsi('It'),oFont12n)
					oPrint:Say(nLinha+10,0180,OemToAnsi('C�digo'),oFont12n)
					oPrint:Say(nLinha+10,0420,OemToAnsi('Descri��o'),oFont12n)
					oPrint:Say(nLinha+10,1180,OemToAnsi('Un'),oFont12n)
					oPrint:Say(nLinha+10,1300,OemToAnsi('Entrg'),oFont12n)
					oPrint:Say(nLinha+10,1500,OemToAnsi('Qtde 1Un'),oFont12n)
					oPrint:Say(nLinha+10,1700,OemToAnsi('Qtde 2Un'),oFont12n)
					oPrint:Say(nLinha+10,1900,OemToAnsi('Vlr.Unit.'),oFont12n)
					oPrint:Say(nLinha+10,2110,OemToAnsi('Ipi %'),oFont12n)
					oPrint:Say(nLinha+10,2280,OemToAnsi('Valor Total'),oFont12n)
					oPrint:Say(nLinha+10,2500,OemToAnsi('C Custo'),oFont12n)
					oPrint:Say(nLinha+10,2700,OemToAnsi('Projeto'),oFont12n)
					lPrintDesTab := .f.
					nLinha += 70

					xVerPag()

				EndIf

				oPrint:Say(nLinha,0120,Right(TRA->C7_ITEM,2),oFont10n)
				cCodPro := ''
				If	( lPrintCodFor )
					DbSelectArea('SA5')
					SA5->(DbSetOrder(1))
					If	SA5->(DbSeek(xFilial('SA5') + SA2->A2_COD + SA2->A2_LOJA + TRA->C7_PRODUTO)) .and. ( ! Empty(SA5->A5_CODPRF) )
						cCodPro := SA5->A5_CODPRF
					Else
						cCodPro := TRA->C7_PRODUTO
					EndIf
				Else
					cCodPro := TRA->C7_PRODUTO
				EndIf	
				oPrint:Say(nLinha,1180,TRA->C7_UM,oFont10)
				oPrint:Say(nLinha,1300,DtoC(TRA->C7_DATPRF),oFont10n,,,,1)
				oPrint:Say(nLinha,1500,Alltrim(TransForm(TRA->C7_QUANT,'@E 99,999,999')),oFont10n,,,,1)
				oPrint:Say(nLinha,1600,TRA->C7_UM,oFont10n)
				oPrint:Say(nLinha,1700,Alltrim(TransForm(TRA->C7_QTSEGUM,'@E 99,999,999')),oFont10n,,,,1)
				oPrint:Say(nLinha,1800,TRA->C7_SEGUM,oFont10n)

				If	( lImpPrc )
					oPrint:Say(nLinha,1900,AllTrim(TransForm(TRA->C7_PRECO,'@E 999,999.999999')),oFont10n,,,,1)
					oPrint:Say(nLinha,2150,AllTrim(TransForm(TRA->C7_IPI,'@E 99.9')),oFont10n,,,,1)
					oPrint:Say(nLinha,2350,AllTrim(TransForm(TRA->C7_TOTAL,'@E 999,999.99')),oFont10n,,,,1)
				EndIf

				oPrint:Say(nLinha,2500,TRA->C7_CC,oFont10n)
				oPrint:Say(nLinha,2700,TRA->C7_OP,oFont10n)
					
				SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+TRA->C7_PRODUTO))
				If !SB5->(dbSetOrder(1), dbSeek(xFilial("SB5")+TRA->C7_PRODUTO))
					cDesc := AllTrim(SB1->B1_DESC)
				Else
					cDesc := AllTrim(SB5->B5_CEME)
				Endif
					
				_cObsItem := Iif(!Empty(AllTrim(TRA->C7_OBS)),'('+AllTrim(TRA->C7_OBS)+')','')
				_cObsMemo := Posicione("SC7",1,xFilial("SC7")+TRA->C7_NUM+TRA->C7_ITEM,"C7_OBSM")

				nLinCod := MlCount(AllTrim(cCodPro),10)

				_nLinhas := MlCount(AllTrim(cDesc),60)

				_nLinObs := MlCount(_cObsItem,60)
				_nLinMem := MlCount(_cObsMemo,200)

				For _nT := 1 To Max(_nLinhas,nLinCod)
					If _nT <= nLinCod .And. !Empty(MemoLine(cCodPro,10,_nT))
						oPrint:Say(nLinha,0180,MemoLine(cCodPro,10,_nT),oFont10)
					Endif
					If _nT <= _nLinhas .And. !Empty(Capital(MemoLine(cDesc,60,_nT)))
						oPrint:Say(nLinha,0420,Capital(MemoLine(cDesc,60,_nT)),oFont10,,0)
					Endif
					nLinha+=40
						
					xVerPag()

				Next _nT
		
				// Observacao Item

				For __nI := 1 To _nLinObs
					oPrint:Say(nLinha,0450,Capital(MemoLine(_cObsItem,60,__nI)),oFont10,,0)
					nLinha+=40

					xVerPag()
				Next

				For __nI := 1 To _nLinMem
					oPrint:Say(nLinha,0450,Capital(MemoLine(_cObsMemo,200,__nI)),oFont10,,0)
					nLinha+=40

					xVerPag()
				Next

				oPrint:Line(nLinha,100,nLinha,3000)

				nLinha+=30

				xVerPag()

				_nValMerc 		+= TRA->C7_TOTAL
				_nValIPI		+= (TRA->C7_TOTAL * TRA->C7_IPI) / 100
				_nValDesc		+= TRA->C7_VLDESC
				_nTotAcr		+= TRA->C7_DESPESA
				_nTotSeg		+= TRA->C7_SEGURO
				_nTotFre		+= TRA->C7_VALFRE

				If	( Empty(TRA->C7_TES) )
					_nTotIcmsRet	+= TRA->C7_ICMSRET
				Else
					DbSelectArea('SF4')
					SF4->(DbSetOrder(1))
					If	SF4->(DbSeek(xFilial('SF4') + TRA->C7_TES))
						If	( AllTrim(SF4->F4_INCSOL) == 'S' )
							_nTotIcmsRet	+= TRA->C7_ICMSRET
						EndIf
					EndIf
				EndIf

				IncProc()
				TRA->(DbSkip())	
			END

			xVerPag()

			nLinha-=30

			xVerPag()

			//����������������������������Ŀ
			//�Imprime TOTAL DE MERCADORIAS�
			//������������������������������
			If	( lImpPrc )
				oPrint:Line(nLinha,2100,nLinha+80,2100)
				oPrint:Line(nLinha,2550,nLinha+80,2550)
				oPrint:Line(nLinha,3000,nLinha+80,3000)
				oPrint:Say(nLinha+50,2150,'Valor Mercadorias ',oFont12)
				oPrint:Say(nLinha+50,2700,TransForm(_nValMerc,'@E 9,999,999.99'),oFont11,,,,1)
				nLinha += 80
				oPrint:Line(nLinha,2100,nLinha,3000)
			EndIf

			xVerPag()

			//������������������������Ŀ
			//�Imprime TOTAL DE I.P.I. �
			//��������������������������
			If	( lImpPrc ) .and. ( _nValIpi > 0 )
				oPrint:Line(nLinha,2100,nLinha+80,2100)
				oPrint:Line(nLinha,2550,nLinha+80,2550)
				oPrint:Line(nLinha,3000,nLinha+80,3000)
				oPrint:Say(nLinha+50,2150,'Valor de I. P. I. (+)',oFont12)
				oPrint:Say(nLinha+50,2700,TransForm(_nValIpi,'@E 9,999,999.99'),oFont11,,,,1)
				nLinha += 80
				oPrint:Line(nLinha,2100,nLinha,3000)
			EndIf

			xVerPag()

			//�������������������������Ŀ
			//�Imprime TOTAL DE DESCONTO�
			//���������������������������
			If	( lImpPrc ) .and. ( _nValDesc > 0 )
				oPrint:Line(nLinha,2100,nLinha+80,2100)
				oPrint:Line(nLinha,2550,nLinha+80,2550)
				oPrint:Line(nLinha,3000,nLinha+80,3000)
				oPrint:Say(nLinha+50,2150,'Valor de Desconto (-)',oFont12)
				oPrint:Say(nLinha+50,2700,TransForm(_nValDesc,'@E 9,999,999.99'),oFont11,,,,1)
				nLinha += 80
				oPrint:Line(nLinha,2100,nLinha,3800)
			EndIf

			xVerPag()

			//���������������������������Ŀ
			//�Imprime TOTAL DE ACRESCIMO �
			//�����������������������������
			If	( lImpPrc ) .and. ( _nTotAcr > 0 )
				oPrint:Line(nLinha,2100,nLinha+80,2100)
				oPrint:Line(nLinha,2550,nLinha+80,2550)
				oPrint:Line(nLinha,3000,nLinha+80,3000)
				oPrint:Say(nLinha+50,2150,'Valor de Acresc. (+)',oFont12)
				oPrint:Say(nLinha+50,2700,TransForm(_nTotAcr,'@E 9,999,999.99'),oFont11,,,,1)
				nLinha += 80
				oPrint:Line(nLinha,2100,nLinha,3000)
			EndIf

			xVerPag()

			//������������������������Ŀ
			//�Imprime TOTAL DE SEGURO �
			//��������������������������
			If	( lImpPrc ) .and. ( _nTotSeg > 0 )
				oPrint:Line(nLinha,2100,nLinha+80,2100)
				oPrint:Line(nLinha,2550,nLinha+80,2550)
				oPrint:Line(nLinha,3000,nLinha+80,3000)
				oPrint:Say(nLinha+50,2150,'Valor de Seguro (+)',oFont12)
				oPrint:Say(nLinha+50,2700,TransForm(_nTotSeg,'@E 9,999,999.99'),oFont11,,,,1)
				nLinha += 80
				oPrint:Line(nLinha,2100,nLinha,3000)
			EndIf

			xVerPag()

			//�����������������������Ŀ
			//�Imprime TOTAL DE FRETE �
			//�������������������������
			If	( lImpPrc ) .and. ( _nTotFre > 0 )
				oPrint:Line(nLinha,2100,nLinha+80,2100)
				oPrint:Line(nLinha,2550,nLinha+80,2550)
				oPrint:Line(nLinha,3000,nLinha+80,3000)
				oPrint:Say(nLinha+50,2150,'Valor de Frete (+)',oFont12)
				oPrint:Say(nLinha+50,2700,TransForm(_nTotFre,'@E 9,999,999.99'),oFont11,,,,1)
				nLinha += 80
				oPrint:Line(nLinha,2100,nLinha,3000)
			EndIf

			xVerPag()

			//�����������������������Ŀ
			//�Imprime ICMS RETIDO    �
			//�������������������������
			If	( lImpPrc ) .and. ( _nTotIcmsRet > 0 )
				oPrint:Line(nLinha,2100,nLinha+80,2100)
				oPrint:Line(nLinha,2550,nLinha+80,2550)
				oPrint:Line(nLinha,3000,nLinha+80,3000)
				oPrint:Say(nLinha+50,2150,'Valor de ICMS Retido',oFont12)
				oPrint:Say(nLinha+50,2700,TransForm(_nTotIcmsRet,'@E 9,999,999.99'),oFont11,,,,1)
				nLinha += 80
				oPrint:Line(nLinha,2100,nLinha,3000)
			EndIf

			xVerPag()

			//�����������������������Ŀ
			//�Imprime o VALOR TOTAL !�
			//�������������������������
	        //oPrint:FillRect({nLinha,1390,nLinha+80,3800},oBrush)
			oPrint:Line(nLinha,2100,nLinha+80,2100)
			oPrint:Line(nLinha,2550,nLinha+80,2550)
			oPrint:Line(nLinha,3000,nLinha+80,3000)
			oPrint:Say(nLinha+50,2150,'Valor Total ',oFont12)
			If	( lImpPrc )
				oPrint:Say(nLinha+50,2700,TransForm(_nValMerc + _nValIPI - _nValDesc + _nTotAcr	+ _nTotSeg + _nTotFre + _nTotIcmsRet,'@E 9,999,999.99'),oFont11,,,,1)
			EndIf
			nLinha += 80
			xVerPag()

			oPrint:Line(nLinha,2100,nLinha,3000)
			nLinha += 70

			xVerPag()

			//����������������������������������������Ŀ
			//�Imprime as observacoes dos parametros. !�
			//������������������������������������������
				
			cObserv1 := Left(cObserv,70)
			cObserv2 := SubStr(cObserv,71,70)
			cObserv3 := SubStr(cObserv,141,70)
			cObserv4 := SubStr(cObserv,211,70)
				
			oPrint:Say(nLinha,0100,OemToAnsi('Observa��es/USO:'),oFont12)

			// Impressao Observacao Itens

			/*For _nT := 1 To _nLinObs
				oPrint:Say(nLinha,0500,Capital(MemoLine(_cObsItem,100,_nT)),oFont12n,,0)
				nLinha+=60
				xVerPag()
			Next
		
			// Impressao Observacao
			//For _nT := 1 To _nLinMem
			//	oPrint:Say(nLinha,0500,Capital(MemoLine(_cObsMemo,60,_nT)),oFont12n,,0)
			//	nLinha+=60
			//
			//	xVerPag()
			//Next
			/*
			oPrint:Say(nLinha,0500,cObserv1,oFont12n)
			nLinha += 60
			xVerPag()
			If	( ! Empty(cObserv2) )
				oPrint:Say(nLinha,0500,cObserv2,oFont12n)
				nLinha += 60
				xVerPag()
			EndIf	
			If	( ! Empty(cObserv3) )
				oPrint:Say(nLinha,0500,cObserv3,oFont12n)
				xVerPag()
				nLinha += 60
			EndIf	
			If	( ! Empty(cObserv4) )
				oPrint:Say(nLinha,0500,cObserv4,oFont12n)
				xVerPag()
				nLinha += 60
				xVerPag()
			EndIf
		    */
			//�����������������������������������������������Ŀ
			//�Imprime o Representante comercial do fornecedor�
			//�������������������������������������������������   
			/*
			DbSelectArea('SZF')
			SZF->(DbSetOrder(1))
			If	SZF->(DbSeek(xFilial('SZF') + SA2->A2_COD + SA2->A2_LOJA))
				If	( ! Empty(SZF->ZF_REPRES) )
					oPrint:Say(nLinha,0100,OemToAnsi('Representante:'),oFont12)
					oPrint:Say(nLinha,0500,AllTrim(SZF->ZF_REPRES) + Space(5) + AllTrim(SZF->ZF_TELREPR) + Space(5) + AllTrim(SZF->ZF_FAXREPR),oFont12n)
					nLinha += 60
					xVerPag()
				EndIf
			EndIf	
			*/

			//�������������������������������������������Ŀ
			//�Imprime a linha de prazo pagamento/entrega!�
			//���������������������������������������������
			//�����������������������������������Ŀ
			//�Imprime a linha de transportadora !�
			//�������������������������������������
	        /*
			oPrint:Say(nLinha,0100,OemToAnsi('Transportadora:'),oFont12)
			oPrint:Say(nLinha,0500,'____________________________________________________',oFont12n)
			*/

			oPrint:Line(nLinha,0100,nLinha,3000)

			nLinha += 50
			xVerPag()

			xRodape()

			nLinha:= 2300

		End

		TRA->(DbCloseArea())

		
/*		If !Empty(_nQtdReg)
			U_EPed(cPedIni,'')					
		Endif
  */		
		//���������������������������������������������
		//�Imprime em Video, e finaliza a impressao. !�
		//���������������������������������������������	
		oPrint:Preview()
		
		If lEmail
			U_XPedMai()
		Endif
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � xCabec() �Autor �Luis Henrique Robusto� Data �  25/10/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime o Cabecalho do relatorio...                        ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA �  MOTIVO                                         ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xCabec()

		//���������������������������������Ŀ
		//�Imprime o cabecalho da empresa. !�
		//�����������������������������������
		oPrint:SayBitmap(-115,100,cFileLogo,400,400)
		oPrint:Say(050,1100,AllTrim(Upper(SM0->M0_NOMECOM)),oFont16)
		oPrint:Say(135,1100,AllTrim(SM0->M0_ENDCOB),oFont11)
		oPrint:Say(180,1100,Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) + '  -  ' + AllTrim(SM0->M0_TEL),oFont11)
		//oPrint:Say(225,1100,AllTrim('www.hgrextrusoras.com.br'),oFont11)
		//oPrint:Line(265,1100,265,2270)
		oPrint:Say(225,1100,"CNPJ "+TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99'),oFont12)
		oPrint:Say(225,1650,SM0->M0_INSC,oFont12)

		oPrint:Line(300,0100,300,3000)
		
		//�������������������Ŀ
		//�Titulo do Relatorio�
		//���������������������
		If	( nTitulo == 1 ) // Cotacao
			oPrint:Say(0400,2520,OemToAnsi('Cota��o de Compra'),oFont22)
		Else
			oPrint:Say(0400,2520,OemToAnsi('Pedido de Compra'),oFont22)
		EndIf

		//����������Ŀ
		//�Fornecedor�
		//������������
		oPrint:Say(0530,0100,OemToAnsi('Fornecedor:'),oFont10)
		oPrint:Say(0520,0430,AllTrim(SA2->A2_NOME) + '  ('+AllTrim(SA2->A2_COD)+'/'+AllTrim(SA2->A2_LOJA)+')',oFont11)
		oPrint:Say(0580,0100,OemToAnsi('Endere�o:'),oFont10)
		oPrint:Say(0580,0430,SA2->A2_END,oFont11)
		oPrint:Say(0630,0100,OemToAnsi('Munic�pio/U.F.:'),oFont10)
		oPrint:Say(0630,0430,AllTrim(SA2->A2_MUN)+'/'+AllTrim(SA2->A2_EST),oFont11)
		oPrint:Say(0630,1100,OemToAnsi('CEP:'),oFont10)
		oPrint:Say(0630,1270,TransForm(SA2->A2_CEP,'@R 99.999-999'),oFont11)
		oPrint:Say(0680,0100,OemToAnsi('Telefone:'),oFont10)
		oPrint:Say(0680,0430,SA2->A2_TEL,oFont11)
		oPrint:Say(0680,1100,OemToAnsi('CNPJ:'),oFont10)
		oPrint:Say(0680,1270,Transform(SA2->A2_CGC,'@R 99.999.999/9999-99'),oFont11)
		oPrint:Say(0730,0100,OemToAnsi('Contato:'),oFont10)
		oPrint:Say(0730,0430,SC7->C7_CONTATO,oFont11)
		oPrint:Say(0730,1100,OemToAnsi('Email:'),oFont10)
		oPrint:Say(0730,1270,SA2->A2_EMAIL,oFont11)
		oPrint:Say(0780,0100,OemToAnsi('Prazo Pagamento:'),oFont12)
		If !Empty(SC7->C7_COND)
			If SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+SC7->C7_COND))
				oPrint:Say(0780,0500,SE4->E4_CODIGO + ' - ' + SE4->E4_DESCRI,oFont12n)
			Endif
		Endif

		//��������������Ŀ
		//�Numero/Emissao�
		//����������������
		oPrint:Box(0500,2550,0700,3000)
		oPrint:Say(0550,2650,OemToAnsi('N�mero Documento'),oFont10n)
		oPrint:Say(0600,2700,SC7->C7_NUM,oFont18)
		oPrint:Say(0650,2700,DTOC(SC7->C7_EMISSAO),oFont12n)
		

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � xRodape()�Autor �Luis Henrique Robusto� Data �  25/10/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime o Rodape do Relatorio....                          ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA �  MOTIVO                                         ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xRodape()

nLinha := 1900

xVerPag()

oPrint:Say(1950,0100,'1) S� ACEITAREMOS A MERCADORA SE NA SUA NOTA FISCAL CONSTAR O N�MERO DO NOSSO PEDIDO DE COMPRA. ',oFont12n)
oPrint:Say(2000,0100,'2) TODOS OS MATERIAIS DEVEM SER IDENTIFICADOS COM ETIQUETA, CONTENDO O C�DIGO E DESCRI��O DO PRODUTO, QUANTIDADE E NOTA FISCAL. ',oFont12n)
oPrint:Say(2050,0100,'3) SOLICITAMOS A TODOS OS FORNECEDORES DE COMPONENTES QUE ENVIEM OS CERTIFICADOS DE QUALIDADE A CADA LOTE FORNECIDO.',oFont12n)
oPrint:Say(2100,0100,'4) MATERIAL SUJEITO A DEVOLU��O CASO AS SOLICITA��ES ACIMA N�O SEJAM ATENDIDAS.',oFont12n)

oPrint:Line(2200,0100,2200,3000)   

oPrint:Say(2300,0100,"Comprador Respons�vel  : "+Substr(cComprador,1,60),oFont11)

oPrint:Say(2400,2780,"P�gina: "+Str(_nPag) ,oFont11)

_nPag:= 0
oPrint:EndPage()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � xVerPag()�Autor �Luis Henrique Robusto� Data �  25/10/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se deve ou nao saltar pagina...                   ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA �  MOTIVO                                         ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xVerPag()

	//�������������������������������Ŀ
	//�Inicia a montagem da impressao.�
	//���������������������������������
	If	( nLinha >= 2200 )

		If	( ! lFlag )
			//xRodape()
			oPrint:Say(2400,2780,"P�gina: "+Str(_nPag) ,oFont11)
			oPrint:EndPage()
			nLinha:= 900
		Else
			nLinha:= 900
		EndIf

		_nPag++

		oPrint:StartPage()
		xCabec()

		lPrintDesTab := .t.

	EndIf
	

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AjustaSX1�Autor �Luis Henrique Robusto� Data �  25/10/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ajusta o SX1 - Arquivo de Perguntas..                      ���
�������������������������������������������������������������������������͹��
���Uso       � Funcao Principal                                           ���
�������������������������������������������������������������������������͹��
���DATA      � ANALISTA � MOTIVO                                          ���
�������������������������������������������������������������������������͹��
���          �          �                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AjustaSX1(cPerg)
Local	aRegs   := {},;
		_sAlias := Alias(),;
		nX

		//���������������������������Ŀ
		//�Campos a serem grav. no SX1�
		//�aRegs[nx][01] - X1_GRUPO   �
		//�aRegs[nx][02] - X1_ORDEM   �
		//�aRegs[nx][03] - X1_PERGUNTE�
		//�aRegs[nx][04] - X1_PERSPA  �
		//�aRegs[nx][05] - X1_PERENG  �
		//�aRegs[nx][06] - X1_VARIAVL �
		//�aRegs[nx][07] - X1_TIPO    �
		//�aRegs[nx][08] - X1_TAMANHO �
		//�aRegs[nx][09] - X1_DECIMAL �
		//�aRegs[nx][10] - X1_PRESEL  �
		//�aRegs[nx][11] - X1_GSC     �
		//�aRegs[nx][12] - X1_VALID   �
		//�aRegs[nx][13] - X1_VAR01   �
		//�aRegs[nx][14] - X1_DEF01   �
		//�aRegs[nx][15] - X1_DEF02   �
		//�aRegs[nx][16] - X1_DEF03   �
		//�aRegs[nx][17] - X1_F3      �
		//�����������������������������

		//��������������������������������������������Ŀ
		//�Cria uma array, contendo todos os valores...�
		//����������������������������������������������
		aAdd(aRegs,{cPerg,'01','Numero do Pedido   ?','Numero do Pedido   ?','Numero do Pedido   ?','mv_ch1','C', 6,0,0,'G','','mv_par01','','','','SC7'})
		aAdd(aRegs,{cPerg,'02','Imprime precos     ?','Imprime precos     ?','Imprime precos     ?','mv_ch2','N', 1,0,1,'C','','MV_PAR03',OemToAnsi('N�o'),'Sim','',''})
		aAdd(aRegs,{cPerg,'03','Titulo do Relatorio?','Titulo do Relatorio?','Titulo do Relatorio?','mv_ch3','N', 1,0,1,'C','','MV_PAR04',OemToAnsi('Cota��o'),'Pedido','',''})
		aAdd(aRegs,{cPerg,'04',OemToAnsi('Observa��es'),'Observa��es         ','Observa��es         ','mv_ch4','C',70,0,1,'G','','MV_PAR05','','','',''})
		aAdd(aRegs,{cPerg,'05','                    ','                    ','                    ','mv_ch5','C',70,0,1,'G','','MV_PAR06','','','',''})
		aAdd(aRegs,{cPerg,'06','                    ','                    ','                    ','mv_ch6','C',70,0,0,'G','','MV_PAR07','','','',''})
		aAdd(aRegs,{cPerg,'07','                    ','                    ','                    ','mv_ch7','C',70,0,0,'G','','MV_PAR08','','','',''})
		aAdd(aRegs,{cPerg,'08','Imp. Cod. Prod. For?','Imp. Cod. Prod. For?','Imp. Cod. Prod. For?','mv_ch8','N', 1,0,1,'C','','MV_PAR09',OemToAnsi('Sim'),OemToAnsi('N�o'),'',''})

		DbSelectArea('SX1')
		SX1->(DbSetOrder(1))

		For nX:=1 to Len(aRegs)
			If !SX1->(DbSeek(aRegs[nx][01]+aRegs[nx][02]))
				RecLock('SX1',.t.)
				Replace SX1->X1_GRUPO		With aRegs[nx][01]
				Replace SX1->X1_ORDEM   	With aRegs[nx][02]
				Replace SX1->X1_PERGUNTE	With aRegs[nx][03]
				Replace SX1->X1_PERSPA		With aRegs[nx][04]
				Replace SX1->X1_PERENG		With aRegs[nx][05]
				Replace SX1->X1_VARIAVL		With aRegs[nx][06]
				Replace SX1->X1_TIPO		With aRegs[nx][07]
				Replace SX1->X1_TAMANHO		With aRegs[nx][08]
				Replace SX1->X1_DECIMAL		With aRegs[nx][09]
				Replace SX1->X1_PRESEL		With aRegs[nx][10]
				Replace SX1->X1_GSC			With aRegs[nx][11]
				Replace SX1->X1_VALID		With aRegs[nx][12]
				Replace SX1->X1_VAR01		With aRegs[nx][13]
				Replace SX1->X1_DEF01		With aRegs[nx][14]
				Replace SX1->X1_DEF02		With aRegs[nx][15]
				Replace SX1->X1_DEF03		With aRegs[nx][16]
				Replace SX1->X1_F3   		With aRegs[nx][17]
				MsUnlock('SX1')
			Endif
		Next nX

Return

User Function XPedMai()
Private _PedCom
Private nTarget:=0
Private cFOpen :=""
Private nOpc   := 0
Private bOk    := {||nOpc:=1,_PedCom:End()}
Private bCancel:= {||nOpc:=0,_PedCom:End()} 
Private lCheck1:=.F.
Private lCheck2:=.T.
Private lCheck3:=.f.


_cPara   :=SA2->A2_EMAIL
_cContato:=PadR(SA2->A2_CONTATO,30)

mCorpo := 'Sr.(a): ' + _cContato +Chr(13)+Chr(10)+Chr(13)+Chr(10)
mCorpo += 'Segue Anexo Pedido de Compras: ' + cPedIni +Chr(13)+Chr(10)+Chr(13)+Chr(10)
mCorpo += SM0->M0_NOMECOM+Chr(13)+Chr(10)
mCorpo += 'Fone: '+SM0->M0_TEL+Chr(13)+Chr(10)
mCorpo += 'Comprador: '+cComprador+Chr(13)+Chr(10)

Define MsDialog _PedCom Title "Pedido de Compras por Email" From 127,037 To 531,774 Pixel 
@ 013,006 To 053,357 Title OemToAnsi("  Dados do Pedido ") 
@ 020,010 Say "Pedido:" Color CLR_HBLUE // Size 25,8 
@ 020,040 Get cPedIni Picture "@!" When .f.
@ 020,097 Say "Email:" Color CLR_HBLUE //Size 25,8 
@ 020,125 Get _cPara Picture "@" Size 150,08
@ 030,010 Say "Fornecedor: " Color CLR_HBLUE
@ 030,042 Say SA2->A2_NOME Color CLR_HRED Object oCliente //Size 19,8 
@ 040,010 Say "Contato: " Color CLR_HBLUE //Size 25,8 
@ 040,042 Say _cContato Object oAutor
@ 040,042 Get _cContato Picture "@" Size 150,08

@ 80,010 To 182,360
@ 88,015 Get mCorpo MEMO Size 340,90

Activate MsDialog _PedCom On Init EnchoiceBar(_PedCom,bOk,bCancel,,) Centered
If nOpc == 1
	cAnexo := 'C:\TEMP\'+cFilename+'.PDF'
	EnvMail(cAnexo, cPedIni, _cPara, _cContato, mCorpo)
EndIf
Return .t.




Static Function EnvMail(cAnexo,cPedIni,cPara,cContato,mCorpo)
Private cAssunto     := 'Pedido de Compras - No. ' + cPedIni
Private nLineSize    := 60
Private nTabSize     := 3
Private lWrap        := .T. 
Private nLine        := 0
Private cTexto       := ""
Private lServErro	   := .T.
Private cServer  := Trim(GetMV("MV_RELSERV")) 
Private cDe 	:= Trim(GetMV("MV_RELACNT"))
Private cPass    := Trim(GetMV("MV_RELPSW"))  
Private lAutentic	:= GetMv("MV_RELAUTH",,.F.)
Private aTarget  :={cAnexo}
Private nTarget := 0
Private lCheck1 := .F.
Private lCheck2 := .f.

cCC := UsrRetMail(RetCodUsr())
cAnexos:=cAnexo
CPYT2S(cAnexos,GetSrvProfString("Startpath", "")+'emailanexos\',.T.)
cAnexos:=GetSrvProfString("Startpath", "")+'emailanexos\'+SubStr(AllTrim(cAnexos),RAT('\',AllTrim(cAnexos))+1)
lServERRO 	:= .F.
                    
CONNECT SMTP                         ;
SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
ACCOUNT  cDe; 	// Nome da conta a ser usada no e-mail
PASSWORD cPass; 	// Senha
Result lConectou    

lRet := .f.
lEnviado := .f.
If lAutentic
	lRet := Mailauth(cDe,cPass)
Endif
If lRet  
	cPara   := Rtrim(cPara)
	cCC		:= Rtrim(cCC)    
	cAssunto:= Rtrim(cAssunto)  
	
//	    	    BCC 'diretoria@metalacre.com.br;gerencia@metalacre.com.br';

	SEND MAIL 	FROM cDe ;
		 		To cPara ;
	    	    CC cCc;
		 		SUBJECT	cAssunto ; 
		 		Body mCorpo;		
		 		ATTACHMENT cAnexos;
		 		RESULT lEnviado

	DISCONNECT SMTP SERVER
Endif
If !lConectou .Or. !lEnviado
	cMensagem := ""
	GET MAIL ERROR cMensagem 
	Alert(cMensagem)
Endif          
FERASE(cAnexos)
Return                      
