/* LAY-OUT DO RELATÓRIO
-----------------------------------------------------------------------------------------------------------------------------------
0   4         14 17  21           34               51       60           73         84         95         106          119         
-----------------------------------------------------------------------------------------------------------------------------------
PRF NUMERO    PC BENEFICIARIO     CNPJ/CPF         VENCTO    VALOR BRUTO  ACRESCIMO DECRESCIMO   RETENCAO COMPENS.CART        VALOR
    TITULO                                                                                       IMPOSTOS ADIANTAMENTO      LIQUIDO
-----------------------------------------------------------------------------------------------------------------------------------
123 123456789 12 1234567890123456 63293976/0001-33 11/11/11 99999.999,99 999.999,99 999.999,99 999.999,99 99999.999,99 99999.999,99
-----------------------------------------------------------------------------------------------------------------------------------
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
0         1         2         3         4         5         6         7         8         9         10        11        12        13
-----------------------------------------------------------------------------------------------------------------------------------

E5_TIPODOC
VL - Baixa de título
BA - Baixa de título
CP - Compensação
*/

//---------------------------------------------------------------------------------
// Rotina    | CSFA540 | Autor | Robson Gonçalves               | Data | 04.02.2015
//---------------------------------------------------------------------------------
// Descrição | Borderô de pagamento.
//           | Esta rotina é uma cópia da FINR710 modelo SetPrint customizado o
//           | lay-out e dados que são apresentados.
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
#Include "PROTHEUS.CH"
#xtranslate FWGETTAMFILIAL => Iif ( FindFunction("FWSIZEFILIAL"), FWSizeFilial(), 2)
#xtranslate FWGETCODFILIAL => Iif ( FindFunction("FWCODFIL"), FWCodFil(), SM0->M0_CODFIL)
Static lFWCodFil := FindFunction("FWCodFil")

User Function CSFA540()
	Local wnrel
	Local cDesc1 := "Rotina para gerar o borderô de pagamentos de compromisso. Específico CERTISIGN."
	Local cDesc2 := "" 
	Local cDesc3 :=""
	Local Tamanho:="M"
	Local cString:="SEA"

	Private titulo	:= "Emissão de borderôs de pagamentos"
	Private cabec1	:= ""
	Private cabec2	:= ""
	Private aReturn:= { "Zebrado", 1, "Administracao", 1, 2, 1, "",1 }
	Private nomeprog:="CSFA540"
	Private aLinha	:= { }
	Private nLastKey := 0
	Private cPerg	:="CSFA540"
	
	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)
		
	dbSelectArea("SX1")
	If dbSeek (Padr( cPerg, Len( X1_GRUPO ) , ' ' )+"03")
		Reclock("SX1",.F.)
		Replace X1_CNT01 With "'"+dtoc(dDataBase)+"'"
		MsUnlock()
	Endif
		
	wnrel := nomeprog
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
		
	If nLastKey == 27
		Return
	Endif
		
	SetDefault(aReturn,cString)
		
	If nLastKey == 27
		Return
	Endif
		
	RptStatus({|lEnd| A540Imp(@lEnd,wnRel,cString,Tamanho)},titulo)
Return

//---------------------------------------------------------------------------------
// Rotina    | A540Imp | Autor | Robson Gonçalves               | Data | 04.02.2015
//---------------------------------------------------------------------------------
// Descrição | Rotina de processamento.
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A540Imp(lEnd,wnRel,cString, Tamanho)
	Local CbCont,CbTxt
	Local cModelo
	Local nTotValor		:= 0
	Local lCheque		:= .f.
	Local lBaixa		:= .f.
	Local nTipo
	Local nColunaTotal
	Local cNumConta		:= CriaVar("EA_NUMCON")
	Local lNew			:= .F.
	Local cNumBor
	Local lAbatimento 	:= .F.
	Local nAbat 		:= 0
	Local lFirst 		:= .T.
	Local cChave
	Local aArea			:= {}
	Local sFilial
	Local cFilOrig
	Local cFilDe
	Local cFilAte
	Local aSM0		:= AdmAbreSM0()
	Local nInc
	Local aFilProc	:= {}
	Local cFilAux
	Local nVlrPagar := 0
	Local nVlrAbat := 0
	Local nSaldoTit := 0
	Local nBaixa := 0
	
	Local nVlrRet := 0
	Local nVlrLiq := 0
	
	Local aVlrAbat := {}
	Local aSeveral := {}
	Local aTotais := Array(5)
	Local nTotOutro := 0
	Local cModelo
	Local cMV_A540MOD := 'MV_A540MOD'
	
	Private nJuros	:= 0
	Private dBaixa	:= CriaVar("E2_BAIXA")
	
	If .NOT. SX6->( ExisteSX6( cMV_A540MOD ) )
		CriarSX6( cMV_A540MOD, 'C', 'Modelos de CNAB que irão utilizar no relatório. CSFA540.prw', "CC/01/03/04/05/10/41/43/30/31/35" )
	Endif
	
	// Capturar o conteúdo do parâmetro.
	cMV_A540MOD := GetMv( cMV_A540MOD )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cbtxt 	:= SPACE(10)
	cbcont	:= 0
	li 		:= 80
	m_pag 	:= 1
	
	nTipo := aReturn[4]
	nContador := 0
	
	SetRegua(RecCount())
	lNew := .T.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atribui valores as variaveis ref a filiais                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par08 == 2
		cFilDe  := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		cFilAte := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	Else
		cFilDe := mv_par09	// Todas as filiais
		cFilAte:= mv_par10
	Endif
	
	AFILL( aTotais, 0 )
	cFilAux := cFilAnt
	
	For nInc := 1 To Len( aSM0 )
		
		cFilAnt := aSM0[nInc][2]
		c_Empant:= aSM0[nInc][1]
		
		If aSM0[nInc][1] == cEmpAnt .AND. (aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte) .and.  AScan( aFilProc, c_Empant+xFilial("SEA") ) == 0
			dbSelectArea("SEA")
			dbSetOrder( 1 )
			dbSeek(cFilial+mv_par01,.T.)
			
			While !Eof() .And. cFilial == EA_FILIAL .And. EA_NUMBOR <= mv_par02
				
				cNumBor := SEA->EA_NUMBOR
				
				IF lEnd
					@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
					Exit
				EndIF
				
				IncRegua()
				
				IF Empty(EA_NUMBOR)
					dbSkip()
					Loop
				Endif
				
				IF SEA->EA_CART != "P"
					dbSkip()
					Loop	
				Endif
				
				lCheque := .f.
				lBaixa  := .f.
				cModelo := SEA->EA_MODELO
				dbSelectArea( "SE2" )
				cLoja := Iif ( Empty(SEA->EA_LOJA) , "" , SEA->EA_LOJA )
				
				SE2->(dbSelectArea( "SA2" ))
				SE2->(DbSeek(FwxFilial("SE2",SEA->EA_FILORIG)+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)))
				
				// Borderos gerados em versao anterior
				IF Empty(SEA->EA_FILORIG) .AND. !Empty(xFilial("SE2"))
					cChave := xFilial("SE2")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+cLoja
					cFilOrig	:= xFilial("SE2")
				Else //Borderos gerados a partir da versao 7.10
					cChave := FwxFilial("SE2",SEA->EA_FILORIG)+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)
					cFilOrig	:= SEA->EA_FILORIG
				Endif
				
				aArea:=GetArea()
				DbSelectArea("SE2")
				dbSetOrder( 1 )
				dbSeek(cChave)
				
				IF MV_PAR05 == 2 .And. SE2->E2_MOEDA <> MV_PAR04
					dbSelectArea("SEA")
					dbSkip()
					Loop
				Endif
				
				MsSeek( cChave )
				dbSelectArea( "SE5" )
				dbSetOrder( 2 )
				dbSeek( cFilOrig+"VL"+SE2->E2_FILORIG+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE+SE2->E2_LOJA )
				
				While !Eof() .and. ;
					E5_FILIAL	== cFilOrig			.and. ;
					E5_TIPODOC	== "VL"            	.and. ;
					E5_PREFIXO	== SE2->E2_PREFIXO 	.and. ;
					E5_NUMERO	== SE2->E2_NUM 	 	.and. ;
					E5_PARCELA	== SE2->E2_PARCELA 	.and. ;
					E5_TIPO		== SE2->E2_TIPO	 	.and. ;
					E5_DATA		== SE2->E2_BAIXA	.and. ;
					E5_CLIFOR	== SE2->E2_FORNECE 	.and. ;
					E5_LOJA		== cLoja
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ S¢ considera baixas que nao possuem estorno   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
						If SubStr( E5_DOCUMEN,1,6 ) == cNumBor .And. E5_MOTBX != "PCC"
							lBaixa := .t.
							Exit
						Endif
					EndIf
					dbSkip()
				Enddo
				
				If !lBaixa
					If ( !Empty( xFilial("SE2") ) .and. !Empty( xFilial("SE5") )) .or. (Empty( xFilial("SE2") ) .and. !Empty( xFilial("SE5") ))
						sFilial := SE2->E2_FILIAL
					Else
						sFilial := xFilial("SE5")
					EndIf
					If (dbSeek( sFilial+"BA"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE+SE2->E2_LOJA))
						While !Eof() .and. ;
							E5_FILIAL	== sFilial 			.and. ;
							E5_TIPODOC	== "BA"            	.and. ;
							E5_PREFIXO	== SE2->E2_PREFIXO 	.and. ;
							E5_NUMERO	== SE2->E2_NUM 	 	.and. ;
							E5_PARCELA	== SE2->E2_PARCELA 	.and. ;
							E5_TIPO		== SE2->E2_TIPO	 	.and. ;
							E5_DATA		== SE2->E2_BAIXA	.and. ;
							E5_CLIFOR	== SE2->E2_FORNECE 	.and. ;
							E5_LOJA		== SE2->E2_LOJA
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ S¢ considera baixas que nao possuem estorno   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
								If SubStr( E5_DOCUMEN,1,6 ) == cNumBor .And. E5_MOTBX != "PCC"
									lBaixa := .t.
									Exit
								Endif
							EndIf
							dbSkip()
						Enddo
					Endif
				Endif
				
				dbSelectArea( "SEF" )
				If (!Empty(SE5->E5_NUMCHEQ) .And. dbSeek( cFilial+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SE5->E5_NUMCHEQ))
					lCheque := .t.
				Endif
				
				// Localiza o fornecedor do titulo que esta no bordero
				SE2->(dbSelectArea( "SA2" ))
				SE2->(DbSeek(FwxFilial("SE2",SEA->EA_FILORIG)+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)))
				
				// Borderos gerados em versao anterior
				IF Empty(SEA->EA_FILORIG) .AND. !Empty(xFilial("SA2"))
					cChave := xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA
				Else //Borderos gerados a partir da versao 7.10
					If !Empty(SEA->EA_FILORIG) .AND. !Empty(xFilial("SA2"))
						cChave := FwxFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA
					Else
						cChave := xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA
					Endif
				Endif
				MsSeek( cChave )
				
				dbSelectArea( "SEA" )
				
				IF li > 55 .Or. lNew
					A540Cabec( SEA->EA_MODELO, nTipo, Tamanho, @lFirst)
					m_pag++
					lNew := .F.
				Endif
								
				lAbatimento := SEA->EA_TIPO $ MV_CPNEG .or. SEA->EA_TIPO $ MVABATIM
				If lAbatimento
					nAbat	:= SE2->E2_SALDO
				Else
					nAbat := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,dDataBase,SE2->E2_FORNECE,SE2->E2_LOJA, SE2->E2_FILIAL)
				EndIf
				
				If ! lAbatimento
					li++
					@li, 0 PSAY SEA->EA_PREFIXO
					@li, 4 PSAY SEA->EA_NUM
					@li,14 PSAY SEA->EA_PARCELA
				EndIf
				
				SA6->( dbSetOrder( 1 ) )
				SA6->( dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON)) )
				
				cNumConta := RTrim(SEA->EA_NUMCON) + Iif( !Empty(SA6->A6_DVCTA), "-", "" ) + SA6->A6_DVCTA
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Efetua calculo dos juros do titulo posicionado ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				fa080Juros(1)
				
				dbSelectArea( "SA2" )
				dbSeek( xFilial("SA2")+SEA->(EA_FORNECE+EA_LOJA))
				
				If SEA->EA_MODELO $ "CH/02"
					dbSelectArea( "SEA" )
					If ! lAbatimento
						If lCheque
							@li,20 PSAY SubStr(SEF->EF_BENEF,1, 33)
						Elseif lBaixa
							@li,20 PSAY SubStr(SE5->E5_BENEF,1, 33)
						Else
							@li,20 PSAY SubStr(SA2->A2_NOME,1, 33)
						Endif
					EndIf
					
					dbSelectArea( "SA6" )
					DbSeek(FwxFilial("SA6",SEA->EA_FILORIG)+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
					
					If lBaixa
						dbSeek( xFilial("SA6")+SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA))
					Else
						dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
					Endif
					
					dbSelectArea( "SEA" )
					If ! lAbatimento
						@li,55 PSAY Left(SA6->A6_NREDUZ,15)
						@li,71 PSAY SE2->E2_VENCREA
						If lCheque
							@li,82 PSAY "CH. " + SEF->EF_NUM
						Endif
					EndIf
					nColunaTotal := 102
				Elseif SEA->EA_MODELO $ "CT"
					If ! lAbatimento
						@li,20 PSAY SubStr(SA2->A2_NOME,1, 33)
						@li,55 PSAY SE2->E2_VENCREA
						If lCheque
							@li,78 PSAY SEF->EF_NUM
						Endif
					EndIf
					nColunaTotal := 94
				Elseif SEA->EA_MODELO $ "CP"
					If ! lAbatimento
						@li,20 PSAY SubStr(SA2->A2_NOME,1, 33)
					EndIf
					dbSelectArea( "SA6" )
					dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
					dbSelectArea( "SEA" )
					If ! lAbatimento
						@li,55 PSAY Left(SA6->A6_NREDUZ,15)
						@li,71 PSAY SE2->E2_VENCREA
						@li,83 PSAY SE2->E2_NUMBCO
						
						nVlrLiq := Round(NoRound(xMoeda(SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,SEA->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1))
						
						@li,99 PSAY nVlrLiq Picture "@E 99,999,999.99"
						
					EndIf
					nColunaTotal := 99
				Elseif SEA->EA_MODELO $ cMV_A540MOD
					dbSelectArea( "SA6" )
					If SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON) <> SA2->(A2_BANCO+A2_AGENCIA+A2_NUMCON) .And. !Empty(SA2->(A2_BANCO+A2_AGENCIA+A2_NUMCON))
						dbSeek( xFilial("SA6")+SA2->(A2_BANCO+A2_AGENCIA+A2_NUMCON))
					Else
						dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
					EndIf
					If ! lAbatimento
						If .NOT. lAbatimento
							If MV_PAR07==1
								nVlrPagar := Round(NoRound(xMoeda(SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,SEA->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1))
							Else
								nVlrPagar := Round(NoRound(xMoeda(SE2->E2_VALOR-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,SEA->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1))
							Endif
                  			Endif
                  
		                  //---------------------------------------------------
		                  // Calular o saldo do título e logo o valor de baixa.
		                  //---------------------------------------------------
		                  nSaldoTit := 0
		                  nBaixa := 0
		                  
		                  nSaldoTit := SE2->E2_SALDO 
		                  //Retirado a funcao para pegar direto o E2_SALDO - Rafael Totvs em 16.10.2015
		                  //SaldoTit( SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_NATUREZ, 'P', SE2->E2_FORNECE )
		                  
		                  If SE2->E2_VALOR > nSaldoTit
		                  	aBaixaSE5 := {}
		                  	Sel080Baixa('VL /BA /CP /DC ',SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,0,.F.,SE2->E2_FORNECE,SE2->E2_LOJA,.F.,.F.,.F.,0,.F.,.T.,.T.)
		                  	For nI := 1 To Len( aBaixaSE5 )
		                  		nBaixa += aBaixaSE5[ nI, 8 ]
		                  	Next nI
	                  		Endif
                  
						//------------------------------------------
						// Calcular o valor de impostos de retenção.
						//------------------------------------------
						nVlrAbat := 0
						
						If .NOT. (SE2->E2_TIPO $ MVTXA+"/"+MVTAXA)
							aSeveral := { GetArea(), SA2->( GetArea() ), SE2->( GetArea() ), SEA->( GetArea() ), SE5->( GetArea() ), SEF->( GetArea() ), SA6->( GetArea() ) }
							aVlrAbat := XImpCta()
							AEval( aVlrAbat, {|p| nVlrAbat += p[ 6 ] } )
							AEval( aVlrAbat, {|p| nVlrRet += p[ 6 ] } )
							AEval( aSeveral, {|xArea| RestArea( xArea ) } )
						Endif
					
						If nJuros > 0
							nVlrAbat := nVlrAbat + nJuros
						Endif
						
/* 
LAY-OUT DO RELATÓRIO
-----------------------------------------------------------------------------------------------------------------------------------
0   4         14 17               34               51       60           73         84         95         106          119         
-----------------------------------------------------------------------------------------------------------------------------------
PRF NUMERO    PC BENEFICIARIO     CNPJ/CPF         VENCTO    VALOR BRUTO  ACRESCIMO DECRESCIMO   RETENCAO COMPENS.CART        VALOR
    TITULO                                                                                       IMPOSTOS ADIANTAMENTO      LIQUIDO
-----------------------------------------------------------------------------------------------------------------------------------
123 123456789 12 1234567890123456 63293976/0001-33 11/11/11 99999.999,99 999.999,99 999.999,99 999.999,99 99999.999,99 99999.999,99
-----------------------------------------------------------------------------------------------------------------------------------
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
0         1         2         3         4         5         6         7         8         9         10        11        12        13
-----------------------------------------------------------------------------------------------------------------------------------
*/
						//@ li, 17 PSAY SA2->A2_BANCO 
						//@ li, 21 PSAY RTrim( SA2->A2_AGENCIA ) + Iif( Empty (SA2->A2_DVAGEN ), ' ', '-' + RTrim( SA2->A2_DVAGEN ) )
						//@ li, 30 PSAY RTrim(SA2->A2_NUMCON ) + Iif( Empty( SA2->A2_DGCTAC ), ' ', '-' + RTrim( SA2->A2_DGCTAC ) )
						@ li, 17 PSAY SubStr(SA2->A2_NOME, 1, 16 ) //20 )
						@ li, 34 PSAY SA2->A2_CGC PICTURE Iif(Empty(SA2->A2_CGC),'@!',Iif( Len( RTrim( SA2->A2_CGC ) ) > 11, "@R 99999999/9999-99", "@R 999999999-99" ))
						@ li, 51 PSAY SE2->E2_VENCREA
						//@ li, 91 PSAY nVlrAbat+nAbat+nVlrPagar+nBaixa PICTURE "@E 99,999,999.99"
						//@ li,105 PSAY nVlrAbat+nAbat+nBaixa PICTURE "@E 99,999,999.99"
						@ li, 60 PSAY SE2->E2_VALOR + nVlrRet PICTURE "@E 99999,999.99"
						@ li, 73 PSAY SE2->E2_ACRESC  PICTURE "@E 999,999.99"
						@ li, 84 PSAY SE2->E2_DECRESC PICTURE "@E 999,999.99"
						@ li, 95 PSAY nVlrRet         PICTURE "@E 999,999.99"
						@ li,106 PSAY nBaixa          PICTURE "@E 99999,999.99"
						
						
						nVlrLiq := ( SE2->E2_VALOR + SE2->E2_ACRESC + nVlrRet ) - ( SE2->E2_DECRESC + nVlrRet + nBaixa )
						nVlrLiq := Round(NoRound(xMoeda(nVlrLiq,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,SEA->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1))
						
						@ li,119 PSAY nVlrLiq         PICTURE "@E 99999,999.99"
						
						aTotais[ 1 ] += SE2->E2_VALOR + nVlrRet
						aTotais[ 2 ] += SE2->E2_ACRESC
						aTotais[ 3 ] += SE2->E2_DECRESC
						aTotais[ 4 ] += nVlrRet
						aTotais[ 5 ] += nBaixa
						
					EndIf
					nColunaTotal := 119
				Else
					If ! lAbatimento
						@li,20 PSAY SubStr(SA2->A2_NOME,1,16)
					EndIf
					dbSelectArea( "SA6" )
					dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
					dbSelectArea( "SEA" )
					If ! lAbatimento
						@li,55 PSAY Left(SA6->A6_NREDUZ,15)
						@li,71 PSAY SE2->E2_VENCREA
						@li,84 PSAY SE2->E2_NUMBCO
					EndIf
					nColunaTotal := 100
				Endif
				
				dbSelectArea( "SA2" )
				dbSeek( xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA))
				
				If ! lAbatimento
					If mv_par07 == 1
						//@li,nColunaTotal PSAY Round(NoRound(xMoeda(SE2->E2_VALOR-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,SEA->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1)) Picture "@E 99,999,999.99"
						
					Else
						//@li,nColunaTotal PSAY Round(NoRound(xMoeda(SE2->E2_VALOR-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,SEA->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1)) Picture "@E 99,999,999.99"
					EndIf
				EndIf
				If lAbatimento
					//nTotValor -= Round(NoRound(xMoeda(SE2->E2_SALDO+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,SEA->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1))
					nTotValor -= nVlrLiq
				Else
					//nTotValor += Round(NoRound(xMoeda(Iif(mv_par07==1,SE2->E2_SALDO,SE2->E2_VALOR)-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,SEA->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1))
					nTotValor += nVlrLiq
				Endif
				
				nVlrRet := 0
				nVlrLiq := 0
				
				dbSelectArea( "SEA" )
				dbSkip()
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se n„o h  mais registros v lidos a analisar.    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DO WHILE !Eof() .And. cFilial == EA_FILIAL .And. EA_NUMBOR <= mv_par02 .and. (Empty(EA_NUMBOR) .or. SEA->EA_CART != "P")
					dbSkip()
				ENDDO
				
				If cNumBor != SEA->EA_NUMBOR
					lNew := .T.
					If li != 80
						li+=2
						@li,	00 PSAY __PrtThinLine()
						li++
						
						//@li, 85 PSAY "TOTAL GERAL ..... " 
						@li, 34 PSAY "TOTAL GERAL ..... " 
						
						IF cModelo $ "CP/CT"
							 
							@li,nColunaTotal PSAY nTotValor Picture "@E 99,999,999.99"
							
							cExtenso := Extenso( nTotValor, .F., MV_PAR04 )
							li+=2
							@li,	1 PSAY Trim(SubStr(cExtenso,1,100))
							If Len(Trim(cExtenso)) > 100
								li++
								@li, 0 PSAY SubStr(cExtenso,101,Len(Trim(cExtenso))-100)
							Endif
						Else
							@ li, 60 PSAY aTotais[ 1 ] PICTURE "@E 99999,999.99"
							@ li, 73 PSAY aTotais[ 2 ] PICTURE "@E 999,999.99"
							@ li, 84 PSAY aTotais[ 3 ] PICTURE "@E 999,999.99"
							@ li, 95 PSAY aTotais[ 4 ] PICTURE "@E 999,999.99"
							@ li,106 PSAY aTotais[ 5 ] PICTURE "@E 99999,999.99"
							
							@li,nColunaTotal PSAY nTotValor	Picture "@E 99,999,999.99"
							cExtenso := Extenso( nTotValor, .F., MV_PAR04 )
							li+=2
							@li,	1 PSAY Trim(SubStr(cExtenso,1,100))
							If Len(Trim(cExtenso)) > 100
								li++
								@li, 0 PSAY SubStr(cExtenso,101,Len(Trim(cExtenso))-100)
							Endif
							
							AFILL( aTotais, 0 )
						EndIF
						
						li+=2
						If cModelo $ "CH/02"
							@li, 0 PSAY "AUTORIZAMOS V.SAS. A EMITIR OS CHEQUES NOMINATIVOS AOS BENEFICIARIOS EM REFERENCIA,"
							li++
							@li, 0 PSAY "DEBITANDO EM NOSSA CONTA CORRENTE NO DIA " + DtoC( mv_par03 )
							li++
							@li, 0 PSAY "PELO VALOR ACIMA TOTALIZADO."
						Elseif cModelo $ "CT/30"
							@li, 0 PSAY "AUTORIZAMOS V.SAS. A PAGAR OS TITULOS ACIMA RELACIONADOS EM NOSSA"
							li++
							@li, 0 PSAY "CONTA MOVIMENTO NO DIA " + DtoC( mv_par03 ) + ", PELO VALOR ACIMA TOTALIZADO."
						Elseif cModelo $ "CP/31"
							@li, 0 PSAY "AUTORIZAMOS V.SAS. A PAGAR OS TITULOS EM REFERENCIA, LEVANDO A DEBITO DE NOSSA"
							li++
							@li, 0 PSAY "CONTA CORRENTE NUM. " + cNumConta + " NO DIA " + DtoC( mv_par03 ) + " PELO VALOR ACIMA TOTALIZADO."
						Elseif cModelo $ "CC/01/03/04/05/10/41/43"
							@li, 0 PSAY "AUTORIZAMOS V.SAS. A EMITIREM ORDEM DE PAGAMENTO, OU DOC PARA OS BANCOS/CONTAS ACIMA."
							li++
							@li, 0 PSAY "DOS TITULOS RESPECTIVOS DEBITANDO EM NOSSA C/CORRENTE NUM " + cNumConta
							li++
							@li, 0 PSAY "NO DIA " + dToC( mv_par03 ) + " PELO VALOR ACIMA TOTALIZADO."
						Else
							@li, 0 PSAY "AUTORIZAMOS V.SAS. A PAGAR OS TITULOS EM REFERENCIA, LEVANDO A DEBITO DE NOSSA"
							li++
							@li, 0 PSAY "CONTA CORRENTE NUM. "  + cNumConta + " NO DIA " + DtoC( mv_par03 ) + " PELO VALOR ACIMA TOTALIZADO."
						Endif
						li+=3
						@li,60 PSAY "-----------------------------------"
						li++
						@li,60 PSAY SM0->M0_NOMECOM
						li++
						@li, 0 PSAY " "
						nTotValor := 0
					Endif
				EndIf
				dbSelectArea("SEA")
			Enddo
			
		Endif
		If Empty(xFilial("SEA")) .AND. aSM0[nInc][1] == cEmpAnt
			Exit
		Endif
		AAdd( aFilProc, c_Empant+xFilial("SEA"))
	Next
	
	cFilAnt := cFilAux
	
	Set Device To Screen
	
	dbSelectArea("SE5")
	dbSetOrder( 1 )
	
	dbSelectArea("SE2")
	dbSetOrder(1)
	
	Set Filter To
	If aReturn[5] = 1
		Set Printer To
		dbCommit()
		Ourspool(wnrel)
	Endif
	
	MS_FLUSH()
Return

//---------------------------------------------------------------------------------
// Rotina    | A540Cabec | Autor | Robson Gonçalves             | Data | 04.02.2015
//---------------------------------------------------------------------------------
// Descrição | Rotina de processamento.
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function A540Cabec( cModelo, nTipo, Tamanho, lFirst)
	Local cCabecalho := ''
	Local cCabec2 := ''
	Local cCabec2 := ''
	Local cTexto
	
	If cModelo $ "CH/02"
		cTexto := Tabela("58",@cModelo)
		cCabecalho := "PRF NUMERO       PC  B E N E F I C I A R I O           BANCO           DT.VENC    HISTORICO              VALOR A PAGAR"
	Elseif cModelo $ "CT"
		cTexto := Tabela("58",@cModelo)
		cCabecalho := "PRF NUMERO       PC  B E N E F I C I A R I O           DT.VENC                                  VALOR A PAGAR"
	Elseif cModelo $ "CP"
		cTexto := Tabela("58",@cModelo)
		cCabecalho := "PRF NUMERO       PC  B E N E F I C I A R I O           BANCO           DT.VENC     NUM.CHEQUE         VALOR A PAGAR"
	ElseIf cModelo $ "CC/01/03/04/05/10/41/43/30/31"
		cTexto := Tabela("58",@cModelo)
		//cCabecalho := "PRF NUMERO    PC BCO AGENCIA  CTA. CORRENTE BENEFICIARIO             CNPJ/CPF        VENCTO     VLR. BRUTO DES/ABAT/IMP  VLR.LIQUIDO"
		cCabecalho := "PRF NUMERO    PC BENEFICIARIO     CNPJ/CPF         VENCTO    VALOR BRUTO  ACRESCIMO DECRESCIMO   RETENCAO COMPENS.CART        VALOR"
		cCabec2    := "    TITULO                                                                                       IMPOSTOS ADIANTAMENTO      LIQUIDO" 
	Else
		cTexto := Tabela("58",@cModelo)
		cCabecalho := "PRF NUMERO       PC  B E N E F I C I A R I O           BANCO           DT.VENC      NUM.CHEQUE         VALOR A PAGAR"
	Endif
	
	dbSelectArea( "SA6" )
	dbSeek( cFilial+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON )
	
	aCabec := {Sm0->M0_nome,;
	PadC("AUTORIZACAO PARA PAGAMENTO DE COMPROMISSOS",97),;
	"EMISSAO : "+DtoC(dDataBase),;
	PadC(cTexto,97),;
	"BORDERO : "+SEA->EA_NUMBOR,;
	Pad("AO " + SA6->A6_NOME,130),;
	Pad("AGENCIA : " + RTrim(SA6->A6_AGENCIA) + Iif( !Empty(SA6->A6_DVAGE),"-","") + SA6->A6_DVAGE +;
	" - C/C " + RTrim(SA6->A6_NUMCON) + Iif( !Empty(SA6->A6_DVCTA),"-","") + SA6->A6_DVCTA, 130),;
	Pad(SA6->A6_END + " "  + SA6->A6_MUN + " " + SA6->A6_EST,130)}
	
	Cabec1 := cCabecalho
	
	li := Cabec540(Titulo,Cabec1,NomeProg,tamanho,Iif(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")), aCabec, @lFirst, cCabec2)
Return

//---------------------------------------------------------------------------------
// Rotina    | A540DtDeb | Autor | Robson Gonçalves             | Data | 04.02.2015
//---------------------------------------------------------------------------------
// Descrição | Validacao da data de d‚bito para o bordero
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function A540DtDeb()
	Local lRet := .T.
	lRet := IIf (mv_par03 < dDataBase, .F. , .T. )
Return lRet

//---------------------------------------------------------------------------------
// Rotina    | Cabec540 | Autor | Robson Gonçalves              | Data | 04.02.2015
//---------------------------------------------------------------------------------
// Descrição | Validacao da data de d‚bito para o bordero
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function Cabec540(cTitulo,cCabec1,cNomPrg,nTamanho,nChar,aCustomText,lFirst,cCabec2)
	Local cAlias,nLargura,nLin:=0, aDriver := ReadDriver(),nCont:= 0, cVar,uVar,cPicture
	Local lWin := .f.
	Local nRow, nCol
	Local nProxLin := 14
	
	nLin := 15	
	
	// Parâmetro que se passado suprime o texto padrao desta função por outro customizado
	Default aCustomText := Nil
	
	#DEFINE INIFIELD    Chr(27)+Chr(02)+Chr(01)
	#DEFINE FIMFIELD    Chr(27)+Chr(02)+Chr(02)
	#DEFINE INIPARAM    Chr(27)+Chr(04)+Chr(01)
	#DEFINE FIMPARAM    Chr(27)+Chr(04)+Chr(02)
	
	lPerg := If(GetMv("MV_IMPSX1") == "S" ,.T.,.F.)
	
	cNomPrg := Alltrim(cNomPrg)
	
	Private cSuf:=""
	
	DEFAULT lFirst := .t.
	
	If TYPE("__DRIVER") == "C"
		If "DEFAULT"$__DRIVER
			lWin := .t.
		EndIf
	EndIf
	
	nLargura:=132
	
	IF aReturn[5] == 1  // imprime em disco
		lWin := .f.    	// Se eh disco , nao eh windows
	Endif
	
	If lFirst
		nRow := PRow()
		nCol := PCol()
		SetPrc(0,0)
		If aReturn[5] <> 2 // Se nao for via Windows manda os caracteres para setar a impressora
			If nChar == NIL .and. !lWin .and. __cInternet == Nil
				@ 0,0 PSAY &(If(aReturn[4]=1,aDriver[3],aDriver[4]))
			ElseIf !lWin .and. __cInternet == Nil
				If nChar == 15
					@ 0,0 PSAY &(If(aReturn[4]=1,aDriver[3],aDriver[4]))
				Else
					@ 0,0 PSAY &(aDriver[4])
				EndIf
			EndIf
		EndIF
		If GetMV("MV_CANSALT",,.T.) // Saltar uma página na impressão
			If GetMv("MV_SALTPAG",,"S") != "N"
				Setprc(nRow,nCol)
			EndIf
		Endif
	Endif
	
	// Impressão da lista de parametros quando solicitada
	// Cabecalho.
	FinCgcCabec(Titulo, Cabec1, cabec2, nomeprog, nChar, mv_par03, aCustomText)
	
	@ 05,00 PSAY __PrtLeft(aCustomText[1])		// Empresa
	@ 05,00 PSAY __PrtCenter(aCustomText[2])	// Titulo do relatorio
	@ 05,00 PSAY __PrtRight(aCustomText[3])	// Data EmissÆo
	@ 06,00 PSAY __PrtCenter(aCustomText[4])	// Descri‡Æo do tipo de bordero
	@ 06,00 PSAY __PrtRight(aCustomText[5])	// Nro do bordero
	@ 09,00 PSAY __PrtLeft(aCustomText[6])		// Ao Banco
	@ 10,00 PSAY __PrtLeft(aCustomText[7])		// Agencia - Conta Corrente
	@ 11,00 PSAY __PrtLeft(aCustomText[8])		// Endereco Banco
	
	If LEN(Trim(cCabec1)) != 0
		@ 12,00  PSAY __PrtThinLine()
		@ 13,00  PSAY cCabec1
		If Len( RTrim( cCabec2 ) ) <> 0
			@ 14,00 PSAY cCabec2
			nLin := 16
			nProxLin := 15		
		Endif
		@ nProxLin,00  PSAY __PrtThinLine()
	EndIf
	
	m_pag++
	lFirst := .f.
	
	If Subs(__cLogSiga,4,1) == "S"
		__LogPages()
	EndIf	
Return nLin

//---------------------------------------------------------------------------------
// Rotina    | FinCGCCabec | Autor | Robson Gonçalves           | Data | 04.02.2015
//---------------------------------------------------------------------------------
// Descrição | Monta cabeçalho do relatório.
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function FinCgcCabec(Titulo, Cabec1, cabec2, nomeprog, nTam, dDataRef, aCustomText, lFirst)
	Local Tamanho := "M"
	Local aCabec
	
	nTam 	 := 130
	dDataRef := If(dDataRef = Nil, mv_par01, dDataBase)
	
	aCabec :=	{"","__LOGOEMP__"}
	
	cabec(Titulo,"","","",tamanho,	nTam, aCabec)
Return .T.

//---------------------------------------------------------------------------------
// Rotina    | AjustaSX1 | Autor | Robson Gonçalves             | Data | 04.02.2015
//---------------------------------------------------------------------------------
// Descrição | Criar grupo de perguntas no SX1.
//---------------------------------------------------------------------------------
// Uso       | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
Static Function AjustaSX1()
	Local aP := {}
	Local i := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp := {}

	/*
	---------------------------------------------------
	Característica do vetor p/ utilização da função SX1
	---------------------------------------------------
	[n,1] --> texto da pergunta
	[n,2] --> tipo do dado
	[n,3] --> tamanho
	[n,4] --> decimal
	[n,5] --> objeto G=get ou C=choice
	[n,6] --> validacao
	[n,7] --> F3
	[n,8] --> definicao 1
	[n,9] --> definicao 2
	[n,10] -> definicao 3
	[n,11] -> definicao 4
	[n,12] -> definicao 5
	[n,13] -> Cnt01
	*/
	AAdd(aP,{"Bordero incial?"  ,"C", 06,0,"G",""                    ,"SEATRK","","","","","",""})
	AAdd(aP,{"Bordero final?"   ,"C", 06,0,"G","(mv_par02>=mv_par01)","SEATRK","","","","","",""})
	AAdd(aP,{"Data para debito?","D", 08,0,"G","U_A540DtDeb()"       ,"","","","","","",""})
	AAdd(aP,{"Qual moeda?"      ,"N",  2,0,"G","VerifMoeda(mv_par04)","","","","","","",""})
	AAdd(aP,{"Outras moedas?"   ,"N",  1,0,"C",""                    ,"","Converter","Nao imprimir","","","",""})
	AAdd(aP,{"Converter por?"   ,"N",  1,0,"C",""                    ,"","Data bordero","Data base","","","",""})
	AAdd(aP,{"Compoe saldo por?","N",  1,0,"C",""                    ,"","Saldo atual","Valor original","","","",""})
	AAdd(aP,{"Considera filial?","N",  1,0,"C",""                    ,"","Sim","Nao","","","",""})
	AAdd(aP,{"Da filial?"       ,"C", 02,0,"G",""                    ,"SM0","","","","","",""})
	AAdd(aP,{"Ate a filial?"    ,"C", 02,0,"G",""                    ,"SM0","","","","","",""})

	AAdd(aHelp,{"Informe o número inicial do intervalo de","números de borderôs gerados pelo","sistema, a serem considerados para a","emissão do relatório."})
	AAdd(aHelp,{"Informe o número final do intervalo de","números de borderôs gerados pelo","sistema, a serem considerados para a","emissão do relatório."})
	AAdd(aHelp,{"Informe a data para autorização do","débito dos pagamentos listados no","borderô de pagamento. Por default, o","sistema traz a data base."})
	AAdd(aHelp,{"Selecione em qual moeda deve ser emitido","o relatório."})
	AAdd(aHelp,{"Selecione a opção “Converter” caso","queira que títulos a pagar em outras","moedas tenham seu valores convertidos","para a moeda escolhida no parâmetro","“Qual moeda”, ou “Não imprimir”, caso","queira que os titulos em outras moedas","sejam desconsiderados na geração do","relatório"})
	AAdd(aHelp,{"Selecione qual a data a ser utilizada","para converter os valores de títulos","vencidos em moedas diferentes da","selecionada na pergunta “Qual Moeda?”.","Selecione  “Data Base”, caso a data a","ser considerada  para a cotação da moeda","seja a database do sistema, ou  pela","“Data de Venc.”, caso data a ser","considerada  para a cotação da moeda","seja a da data de vencimento do título."})
	AAdd(aHelp,{"Selecione a forma de composicao do saldo","dos títulos, que pode ser por saldo ","atual ou valor original dos títulos."})
	AAdd(aHelp,{"Selecione a opção 'Sim' para que a ","geração do relatório considere as ","filiais a serem informadas nos campos ","a seguir, ou 'Não' caso deseja imprimir ","apenas os dados da filial atual."})
	AAdd(aHelp,{"Caso a resposta do parâmetro anterior ","'Considera Filiais?' seja igual  a 'Sim',","Informe o código inicial do intervalo de ","números de filiais da sua empresa, a serem ","considerados na geração do relatório."})
	AAdd(aHelp,{"Caso a resposta do parâmetro anterior ","'Considera Filiais?' seja igual  a 'Sim',","Informe o código final do intervalo de ","números de filiais da sua empresa, a serem ","considerados na geração do relatório."})
 
	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		PutSx1(cPerg,;
		cSeq,;
		aP[i,1],aP[i,1],aP[i,1],;
		cMvCh,;
		aP[i,2],;
		aP[i,3],;
		aP[i,4],;
		0,;
		aP[i,5],;
		aP[i,6],;
		aP[i,7],;
		"",;
		"",;
		cMvPar,;
		aP[i,8],aP[i,8],aP[i,8],;
		aP[i,13],;
		aP[i,9],aP[i,9],aP[i,9],;
		aP[i,10],aP[i,10],aP[i,10],;
		aP[i,11],aP[i,11],aP[i,11],;
		aP[i,12],aP[i,12],aP[i,12],;
		aHelp[i],;
		{},;
		{},;
		"")
	Next i
Return

Static Function XImpCta()
LOCAL aArea     := GetArea()
LOCAL aImpGer   := {}
LOCAL cPrefixo
LOCAL cNum
LOCAL cParcIR   := ""
LOCAL cParcISS  := ""
LOCAL cParcINS  := ""
LOCAL cParcCSS  := ""
LOCAL cParcSES  := ""
LOCAL cParcPIS  := ""
LOCAL cParcCOF  := ""
LOCAL cParCSLL  := ""
LOCAL lPagAnt   := .F.
LOCAL lPCCBaixa := IIF(cPaisLoc == "BRA",SuperGetMv("MV_BX10925",.T.,"2") == "1",.F.)
Local cQuery := ""
Local cAliasQry	:=	GetNextAlias()
Local cTipoImp := ""
Local nTamTitPai := TamSx3("E2_TITPAI")[1]
Local cParcINP	:= " "
Local lGetParINP	:= FindFunction("GetParcINP")

// Soh efetua a varredura, caso não seja Tx.
If (SE2->E2_TIPO $ MVTXA+"/"+MVTAXA)
	Return aImpGer
ElseIf (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) // Sendo PA
	lPagAnt := .T.
Endif

// Carrega as variaveis para pesquisa dos titulos de impostos.
cPrefixo := SE2->E2_PREFIXO
cNum     := SE2->E2_NUM

cParcIR := SE2->E2_PARCIR
cParcISS := SE2->E2_PARCISS
cParcINS := SE2->E2_PARCINS
cParcCSS := SE2->E2_PARCCSS
cParcSES := SE2->E2_PARCSES
cParcPIS := SE2->E2_PARCPIS
cParcCOF := SE2->E2_PARCCOF
cParCSLL := SE2->E2_PARCSLL

// INSS Patronal
If lGetParINP
	GetParcINP(@cParcINP)
EndIf

cQuery := " SELECT E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_VALOR,E2_SALDO,E2_NUMBOR "
cQuery += " FROM " + RetSqlName("SE2")
cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") +"' AND "
cQuery += " E2_TITPAI = '" + Substr(SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),1, nTamTitPai) + "' AND " 
cQuery += " D_E_L_E_T_ = ' '" 
cQuery := ChangeQuery(cQuery) 
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.T.)				
	

If (cAliasQry)->(!Eof())

	cTipoImp := If(lPCCBaixa.And.lPagAnt,MVTXA,MVTAXA)+"|"+"ISS|INS"
	While (cAliasQry)->(!Eof())
		If (cAliasQry)->E2_TIPO $  cTipoImp 
			Aadd(aImpGer,{(cAliasQry)->E2_PREFIXO,(cAliasQry)->E2_NUM,(cAliasQry)->E2_PARCELA,(cAliasQry)->E2_TIPO,(cAliasQry)->E2_NATUREZ,(cAliasQry)->E2_VALOR,(cAliasQry)->E2_SALDO,(cAliasQry)->E2_NUMBOR})
		EndIf
	
		(cAliasQry)->(DbSkip())
	EndDo
Endif

Return aImpGer