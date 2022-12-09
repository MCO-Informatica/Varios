#include "rwmake.ch"

User Function SCRSNF()

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Define Variaveis                                                 ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aDriver 	:= {}
	Private _nLin       := 0
	Private _cPerg      := padR("NFFFM",Len(SX1->X1_GRUPO))
	Private _wNrel      := "NFFFM"
	Private _cNrel      := "NFFFM"
	Private _cTitulo    := "Emissao Nota Fiscal FFM"
	Private _cDesc1     := "Emissao de N.F. de Saida"
	Private _cDesc2     := "para FFM"
	Private _cDesc3     := ""
	Private aReturn    := {"Especial", 1, "Administracao", 2, 2, 1, "", 1}
	Private _cTamanho   := "M"

	Private _cImpNorm   := chr(18)      	&&impressora - normal
	Private _cImpComp   := chr(15)      	&&             comprimido
	Private _cImp20cpp  := chr(27) + "g"	&&             20cpp CARACTER MAIS FINO
	Private _cImpEsp    := chr(27) + "0"	&&             1/8" altura da linha DISTANCIA ENTRE LINHAS
	Private _cImpOn     := chr(17)      	&&             on-line
	PRivate _cImpOff    := chr(19)      	&&             off-line
	Private _cImpReset  := chr(27) + "@"	&&             reset

	Private nLastKey    := 0
	Private _lContinua  := .T.
	&&Private	_nPosReg    := 0         	&&guarda recno() do 1§ item da NF
	Private _cKey       := ""           	&&auxiliar p/ chaves de acesso
	Private _aItens     := {}           	&&array p/ itens da NF
	Private _aServ      := {}                                                         		&&array p/ servicos da NF
	Private _cNat       := ""                                                         		&&string p/ naturezas da operacao
	Private _aNatOper   := {}                                                         		&&array para armazenar diferentes naturezas
	Private _aCFO       := {}                                                          		&&array p/controle de CF ja considerados
	Private _cNomCli := _cCGCCli := _cEndCli := _cBaiCli := ""                        		&&variaveis do cliente
	Private _cCEPCli := _cMunCli := _cTelCli := _cEstCli := _cInsCli := ""            		&&variaveis do cliente
	Private _cNomTra := _cCGCTra := _cEndTra := _cMunTra := _cEstTra := _cInETra := ""		&&Variaveis da transportadora
	Private _cTpFrete := ""
	Private _cEndEnt    := _cEndCob := space(80)	&&endereco de entrega/cobranca
	Private _cCidEnt   := ""								&&cidade de entrega
	Private _cFoneEnt  := ""								&&fone de entrega
	Private _cCepEnt   := ""								&&cep de entrega
	Private _cMunCob   := ""								&&municipio de entrega/cobranca
	Private _aNumPed   := {}								&&array  p/ numeros de nossos pedidos
	Private _cNumPed   := ""								&&string p/ impressao de num.ped
	Private _aMenPad1  := {}								&&Array p/ codigo da msg. padrao do TES.
	Private _aMenPad2  := {}								&&Array p/ textos da msg. padrao do TES.
	Private _aDupl     := {}								&&array p/ desdobramento de duplicatas
	Private _nTD       := 22								&&num.de colunas p/ descricao do produto
	Private _cRedesp   := ""								&&nome do redespacho
	Private _cPedCli   := ""								&&pedido do cliente
	Private _aPedCli   := {}								&&array com os nros do Pedido do Cliente
	Private _aNotas    := {}								&&array com as NF´s
	Private _cCont     := "A"								&&contador a ser utilizado na impressao da Classificacao fiscal
	Private _nKy       := 0
	Private _nTotServ  := 0
	Private _nValISS   := 0
	Private _nIrrf     := 0
	Private _nInss     := 0
	Private _nTotImp   := 0
	Private _cSuframa  := ""								&& - Codigo Suframa e flag do calculo de desconto para Suframa (A1_SUFRAMA e A1_CALCSUF).
	Private _nVlrSufr  := 0									&& Desconto Suframa ICMS
	Private _nVlrSPIS  := 0									&& Desconto Suframa PIS
	Private _nVlrSCOF  := 0									&& Desconto Suframa COFINS
	Private _nVlrIss   := 0
	Private _nValMerc  := 0
	Private _nPSufr    := 0
	Private _cSitrib   := ""
	Private _cNomRed   := ""
	Private _nLped     := 0
	Private _nCped     := 0
	Private _cHrEmis   := ""
	Private _nValorT   := 0
	Private _nValUni   := 0									&& Valor Unitario Itens
	Private _nValTot   := 0									&& Valor Total Itens
	Private _nM 	   := 1
	Private _lMensg    := .T.
	Private _nPag	   := 1
	Private nVlTotCons := 0
	Private nVlTotInd  := 0

    If cFilAnt <> '0701'
       
       Return( NIL )

    Else

       U_NFSDAGSTD( dTos( dDataBase ), dTos( dDataBase ), .F. )
       U_CtaRcGstq( '  ', dTos( dDataBase ), dTos( dDataBase ) , ' ', .T. )
       U_CtaRcGstq( 'BV', dTos( dDataBase ), dTos( dDataBase ) , ' ', .T. )
    
    End

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Variaveis utilizadas para parametros                             ³
	&&³ mv_par01             && De Nota                                  ³
	&&³ mv_par02             && Ate a Nota                               ³
	&&³ mv_par03             && Serie                                    ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Valida/Cria Grupo de Perguntas                                   |
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ValidPerg()
	If ! Pergunte (_cPerg, .T.)
		Return( NIL )
	End

	If LastKey () == 27
		Return
	EndIf

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Prepara a array para impressao das Notas Fiscais de Saida.       ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Posiciona na nota informada no parametro "De",                   ³
	&&| ou a proxima caso exista.                                        |
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SF2->(dbSetOrder(1))                 &&filial,documento,serie,cliente,loja

	&&Posiciona na nota informada no parametro "De", ou a proxima caso exista.
	SF2->(dbSeek(xFilial("SF2")+mv_par01+mv_par03,.T.))

	While !SF2->(Eof()) .and. SF2->F2_FILIAL == xFilial("SF2") .and. SF2->F2_DOC <= mv_par02 .And. SF2->F2_SERIE == mv_par03

		If Alltrim(SF2->F2_SERIE) <> Alltrim(mv_par03)
			SF2->(dbSkip())
			Loop
		EndIf
		lOpca := .t.

		If !Empty(SF2->F2_FIMP)
			lOpca := MsgBox("Nota " + SF2 -> F2_DOC + "/" + SF2->F2_SERIE + " ja emitida. Deseja emiti-la novamente ?", "Atencao!!!", "YESNO")
		EndIf

		If lOpca == .t.
			aAdd(_aNotas, SF2->F2_DOC)
		EndIf
		SF2->(dbSkip())
	EndDo

	If Len(_aNotas) == 0
		MsgBox("Nao ha Notas Fiscais a imprimir para os parametros informados.")
		Return
	EndIf

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Monta a interface padrao com o usuario...                           ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cNRel := SetPrint("SF2",_cNRel,_cPerg,@_cTitulo,_cDesc1,_cDesc1,_cDesc3,.F.,"",,_cTamanho)&&SetPrint("SF2",_cNRel,_cPerg,_cTitulo,_cDesc1,_cDesc2,_cDesc3,.T.,,.T.,_cTamanho,,.T.)

	If LastKey() == 27
		dbClearFilter()
		Return
	EndIf

	SetDefault(aReturn, "SF2")

	If LastKey() == 27
		dbClearFilter()
		Return
	EndIf

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Funcao para Processamento e Impressao da NF Saida.                  ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RptStatus({|| SCIMPRNF()})


	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³SCIMPRNF  º Autor ³ Paulo Romualdo     º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Funcao para Processamento e Impressao da NF de Saida.      º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function SCIMPRNF
Local := 0
Local _nIf := 0
	Local _aArea	:= {}

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Posiciona Todos os Indices Necessarios.                             ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA1")			&&Clientes
	dbSetOrder(1)      			&&filial,codigo,loja
	dbSelectArea("SA3")			&&Vendedores
	dbSetOrder(1)      			&&filial,codigo
	dbSelectArea("SA4")			&&Transportadoras
	dbSetOrder(1)      			&&filial,codigo transport.
	dbSelectArea("SA7")			&&Amarracao ProdutoxCliente
	dbSetOrder(1)
	dbSelectArea("SB1")			&&Produtos
	dbSetOrder(1)      			&&filial,codigo produto
	dbSelectArea("SC5")			&&Pedidos de Venda
	dbSetOrder(1)      			&&filial, pedido
	dbSelectArea("SC6")			&&Itens dos Pedidos de Venda
	dbSetOrder(1)      			&&filial, pedido, item
	dbSelectArea("SD1")			&&Itens da NF de Entrada
	dbSetOrder(1)      			&&filial,doc,serie,fornece
	dbSelectArea("SD2")			&&Itens de Venda da NF
	dbSetOrder(3)      			&&filial,doc,serie,cliente,loja,cod
	dbSelectArea("SE1")			&&Contas a Receber
	dbSetOrder(1)      			&&filial,prefixo,num,parcela,tipo
	dbSelectArea("SE4")			&&Cond. Pagamento
	dbSetOrder(1)      			&&filial,codigo
	dbSelectArea("SF1")			&&NF de Entrada
	dbSetOrder(1)      			&&filial,doc,serie,cliente e loja
	dbSelectArea("SF2")			&&NF de Saida
	dbSetOrder(1)      			&&filial,doc,serie,cliente e loja
	dbSelectArea("SF4")			&&Tipos de Entrada e Saida
	dbSetOrder(1)      			&&filial,codigo

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³                         PRINCIPAL                                   ³
	&&³ Loop para o numero de Notas Fiscais que atendem aos parametros.     ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nIf:=1 to Len (_aNotas)

		If LastKey () == 27 .or. nLastKey == 27 .or. nLastKey == 286
			@ 25, 01 PSAY "** CANCELADO PELO OPERADOR **"
			_lContinua := .F.
			Exit
		EndIf

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Inicializa Variaveis p/ Nova NF                                  ³
		&&³ Ver Descricao das Variaveis no Trecho Define Variaveis           ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_aNFDev     := {}
		_aItens		:= {}
		_aServ		:= {}
		_aCFO       := {}
		_aNatOper   := {}
		_cNat       := ""
		_aNumPed    := {}
		_cNumPed    := ""
		_aMenPad1   := {}
		_aMenPad2   := {}
		_cEndEnt    := _cEndCob := space(80)
		_cMunCob    := ""
		_cDesc1     := _cDesc2 := ""
		_cRedesp    := ""
		_cPedCli    := ""
		_aPedCli    := {}
		_cDescPr    := ""
		_cDesServ   := ""
		_nVlrIss    := 0
		_nKy        := 0
		_aDupl      := {} 
		_nPesoL     := 0
		_nTotServ   := 0
		_nValISS    := 0
		_dEmissao   := CToD("  /  /  ")
		_cChave     := ""
		_cNomCli 	:= _cCGCCli := _cEndCli := _cBaiCli := ""						&&variaveis do CLIENTE
		_cCEPCli 	:= _cMunCli := _cTelCli := _cEstCli := _cInsCli := ""		&&variaveis do CLIENTE
		_cEndEnt    := ""
		_cCidEnt    := ""
		_cFoneEnt   := ""
		_cCepEnt    := ""
		_nDesc      := 0
		_nPerIrrf   := 0
		_nPerInss 	:= 0
		_cCont      := "A"
		_cClasFis   := ""
		_aClasFis   := {}
		_nIrrf      := 0
		_nInss      := 0
		_nTotImp    := 0
		_nVlrSufr   := 0
		_nVlrSPIS   := 0
		_nVlrSCOF   := 0
		_nPSufr     := 0
		_cSitrib    := ""
		_cCodProd   := ""
		_cNomRed    := ""
		_cNomTra 	:= _cCGCTra := _cEndTra := _cMunTra := _cEstTra := _cInETra := ""		&&Variaveis da TRANSPORTADORA
		_cTpFrete 	:= ""
		_cItem		:= ""
		_cPed	    := ""   				&&CLEMBER
		_nTotIns    := 0   				&&CLEMBER

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Posiciona o SF2 - Cabecalho da Nota Fiscal de Saida              ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cNota := _aNotas[_nIf]
		dbSelectArea("SF2")
		dbSeek(xFilial("SF2")+_cNota+mv_par03)			&& Filial + Nota + Serie

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Carrega as Variaveis de Cabecalho da NF                          ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cTipoNF  := SF2 -> F2_TIPO
		_cNumNF   := SF2 -> F2_DOC
		_cSerNF   := SF2 -> F2_SERIE
		_dEmissao := SF2 -> F2_EMISSAO
		_dDtSaida := SF2 -> F2_EMISSAO
		_cHrSaida := SF2 -> F2_HORNFE

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Carrega as Variaveis com os Impostos                             ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_nBaseIcm := SF2 -> F2_BASEICM
		_nValIcm  := SF2 -> F2_VALICM
		&&_nBICMRet := SF2 -> F2_BRICMS - Cliente nao utiliza
		_nBICMRet := 0
		&&_nVICMRet := SF2 -> F2_ICMSRET - Cliente nao utiliza
		_nVICMRet := 0
		_nBaseISS := SF2 -> F2_BASEISS
		_nValISS  := SF2 -> F2_VALISS
		_nValMerc := SF2 -> F2_VALMERC
		_nValFret := SF2 -> F2_FRETE
		_nValSeg  := SF2 -> F2_SEGURO
		_nVlrDesp := SF2 -> F2_DESPESA
		_nValIPI  := SF2 -> F2_VALIPI
		_nValBrut := SF2 -> F2_VALFAT		&& Valor Total da Fatura
		If _nValBrut == 0
			_nValBrut := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
		EndIf

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Carrega as variaveis de Volumes Transportados                    ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cVolu1   := SF2 -> F2_VOLUME1
		_cEspec1  := SF2 -> F2_ESPECI1
		_cMarca   := ''
		_cPlaca   := SF2->F2_VEICUL1
		_nPBruto  := SF2->F2_PBRUTO
		_nPLiqui  := SF2->F2_PLIQUI

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Posiciona o SD2 - Itens da NF                                    ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cKey := xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE
		dbSelectArea("SD2")
		dbSeek(_cKey)
		_nPosReg := Recno()		&&guarda posicao do 1§ item da NF

		While !Eof () .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE == _cKey

			&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			&&³ Chamada da Funcao SCPOSPRD - posicionar no Produto (SB1)      ³
			&&³ para carregar as variaveis Descricao, Cod Clas Fiscal, etc    ³
			&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !( SCPOSPRD())
				dbSelectArea("SD2")
				dbSkip()
				Loop
			Endif

			&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			&&³ Chamada da Funcao SCITEMPV - posicionar no Item do PV (SC6)   ³
			&&³ para carregar as variaveis Descricao, Num PV, Nr Ped Cli, etc ³
			&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SCITEMPV()

			&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			&&³ Posicionar no Compl Prod (SB5) para carregar a variavel       ³
			&&³ _cDescPr - Descr Cientifica 						               ³
			&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			&&If Empty(_cDescPr)
			&&	_cDescPr := Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"SB5->B5_CEME")
			&&EndiF

			&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			&&³ Posiciona o SF4 - TES                                         ³
			&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SCPOSTES()

			&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			&&³ Preenche array dos Itens da N.F.                                                         ³
			&&³ Estrutura do array de Itens da NF _aItens[n][m]                                          ³
			&&³ n = numero do item                                                                       ³
			&&³ m = CodProd, Descr, ClasFis, SitTrib, UniMedida, Quant, PrcUnit, PrcTot, AliqIPI, ValIPI ³
			&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD2")
			_cCodProd := Alltrim(SD2 -> D2_COD)
			_cDescPr  := if( Empty( SD2->D2_DESCR ), _cDescPr, rTrim( SD2->D2_DESCR ) )
			_cUM      := SD2 -> D2_UM
			_nQuant   := SD2 -> D2_QUANT
			_nPesoL   := SD2 -> D2_QUANT * SD2 -> D2_PESO
			_nDesc    := 0

            _cNumPed := ' '//If(Empty(_cNumPed),"Pedido: ",_cNumPed + "-" )+Alltrim(SD2->D2_PEDIDO)
       		_nPedCli := ' '
	      	_cTpFrete := '1'

			If SF2->F2_TIPO != "I"
				If SD2->D2_DESCZFR > 0
					_nValUni := ( SD2->D2_DESCZFR + SD2->D2_TOTAL ) / SD2->D2_QUANT
					_nValTot := ( SD2->D2_DESCZFR + SD2->D2_TOTAL )
				Else
					_nValUni :=  SD2->D2_PRCVEN
					_nValTot :=  SD2->D2_TOTAL
				Endif
			Else
				_nValUni :=  0
				_nValTot :=  0
			Endif

			If !Empty(SD2->D2_CLASFIS)
				_cSitrib := SD2->D2_CLASFIS
			EndIf

			If Empty(D2_CODISS)
				_nP  := ASCAN(_aItens,{|X|Substr(X[1],1,15)==_cCodProd .AND. X[14]==D2_LOTECTL .AND. x[7] == _nValUnI } )
				If _nP == 0
					AAdd (_aItens, {_cCodProd						;	&& 01 - Cod Produto
					,  _cDescPr										; 	&& 02 - Descricao Prd
					,  _cClasFis									; 	&& 03 - Classificacao Fiscal
					,  _cSiTrib										; 	&& 04 - Situacao Tributaria
					,  _cUM											; 	&& 05 - Unidade Medida
					,  _nQuant										; 	&& 06 - Quantidade
					,  _nValUni										; 	&& 07 - Preco Unitario
					,  _nValTot										; 	&& 08 - Total
					,  0    										; 	&& 09 - Perc ICM
					,  D2_IPI										; 	&& 10 - Perc IPI
					,  D2_VALIPI									; 	&& 11 - Valor IPI
					,  SB1->B1_PESO									; 	&& 12 - Peso
					,  _nDesc										; 	&& 13 - Desconto
					,  D2_LOTECTL									; 	&& 14 - LOTE
					, _cItem										;	&& 15 - Numero do Item
					, _cPed                                         ;   && 17 - Numero do Pedido
					, D2_PEDIDO                                		;   && 18 - Numero do Pedido				&&CLEMBER
					})
				Else
					_aItens[_nP,06] += _nQuant
					_aItens[_nP,08] += D2_TOTAL
					_aItens[_nP,11] += D2_VALIPI
				EndIf

			Else

				AAdd (_aServ, {_cDescPr								;  && 01 - Descricao Prd
				, _cUM												;  && 02 - Unidade Medida
				, _nQuant											;  && 03 - Quantidade
				, SD2->D2_PRCVEN									;  && 04 - Preco Unitario
				, SD2->D2_TOTAL										;  && 05 - Total
				})

				_nTotServ  := _nTotServ + SD2->D2_TOTAL			&& Acumula Total do ISS

			EndIf

			_aArea := GetArea()

			&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			&&³ Verifica nota fiscal de devolução ou poder de terceiro        ³
			&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(SD2->D2_NFORI)
				If !Empty(SD2->D2_IDENTB6)
					&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					&&³ Poder de Terceiro - captura data de emissão e valor     ³
					&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(posicione("SB6", 1, xfilial("SB6") + SD2->D2_COD + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_IDENTB6, "B6_PRODUTO"))
						Aadd(_aNFDev, {SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA, SB6->B6_EMISSAO, SD2->D2_TOTAL,"B"})
					EndIf
				Else
					&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					&&³ Verifica nota de devolução - sem poder de terceiro      ³
					&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(posicione("SD1", 1, xfilial("SD1") + SD2->D2_NFORI + SD2->D2_SERIORI + SD2->D2_CLIENTE + SD2->D2_LOJA, "D1_DOC"))
						Aadd(_aNFDev, {SD2->D2_NFORI + SD2->D2_SERIORI + SD2->D2_CLIENTE + SD2->D2_LOJA, SD1->D1_EMISSAO, SD2->D2_TOTAL,"D"})
					EndIf
				EndIf

			EndIf
			RestArea(_aArea)

			&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			&&³ Acumula Desconto Suframa para apresentar no corpo da NF.      ³
			&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			&&If SD2->D2_DESCZFR > 0					&&ICMS
			&&	_nVlrSufr += SD2->D2_DESCZFR
			&&	_nPSufr   := SD2->D2_PICM
			&&EndIf
			&&If SD2->D2_DESCZFP > 0					&&PIS
			&&	_nVlrSPIS += SD2->D2_DESCZFP
			&&EndIf
			&&If SD2->D2_DESCZFC > 0					&&COFINS
			&&	_nVlrSCOF += SD2->D2_DESCZFC
			&&EndIf

			dbSelectArea("SD2")
			dbSkip()
		EndDo


		Go _nPosReg										&&reposiciona no primeiro item da NF

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Posiciona SA1 (Cliente) ou SA2 (Fornecedor)                   ³
		&&³ Verifica se NF Devolucao ou Beneficiamento                    ³
		&&³ Preencher os campos de endereco de cobranca nas variaveis     ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SCPOSCLI()

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Posiciona o SA3 Para Buscar o vendedor                        ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA3")
		dbSeek(xFilial("SA3")+SF2->F2_VEND1)

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Posiciona o SA4 Para Buscar o Redespacho e Transportadora     ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SCTRANSP()

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Posiciona o SA6 Para Buscar o Banco                           ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA6")
		dbSeek(xFilial("SA6")+SC5->C5_BANCO)

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Posiciona o SE4 Para Buscar a Condicao de Pagamento           ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cCondPag := Posicione("SE4",1,xFilial("SE4")+SF2->F2_COND,"SE4->E4_DESCRI")

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Posiciona e Carrega variaveis referente a Duplicata           ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SCDUPLIC()

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Carrega todas as mensagens no aMenPad2	                     ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SCCARMSG()

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Carrega variaveis para impressao de ISS                       ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_nVlrIss  := _nVlrIss + SF2->F2_VALISS			&& Acumula o Valor ISS

		If !_lContinua
			Exit
		Endif

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³                                                               ³
		&&³                          IMPRESSAO                            ³
		&&³                                                               ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Impressao do Cabecalho da NF 				                     ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SCCABEC()

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Impressao dos itens da NF - Materiais.                        ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SCIMPITM()

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Impressao do Rodape da NF 				                        ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IMPRODAPE()

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Grava o Flag de Impressao				                           ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*dbSelectArea("SF2")
RecLock("SF2",.F.)
SF2->F2_FIMP := "T"
MsUnlock()*/

	Next _nIF

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Encerra a Impressao da(s) NF(s) e deixa posicionado para proxima ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLin := 0

	If aReturn[5]== 3 .AND. Len(aDriver) > 0		&&Direto na Porta
		SetPrc(0,0)											&&Deixa posicionado para a proxima Nota
		@ 0,0 PSAY " "
		@ 0,Pcol()+1 PSAY &(aDriver[7])				&&-Reset
		@ 0,Pcol()+1 PSAY chr(27)+"@"				&&10cpi
	EndIf

	dbSelectArea("SF2")
	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Set Device To Screen                                             ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _lContinua
		If aReturn[5] == 1	&&Relatorio em tela
			SetPgEject(.T.)
			Set Printer TO
			dbcommitAll()
			ourspool(_wNrel)
		EndIf
		MS_FLUSH()
	EndIf

	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³SCPOSPRD  º Autor ³ Paulo Romualdo     º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Posiciona no arquivo de produtos e carrega as variaveis    º±±
	±±º          ³ contendo Descricao, Clas. Fiscal 						  º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function SCPOSPRD
	Local _aArea 	:= GetArea()
	Local _lRet 	:= .t.

	dbSelectArea("SB1")
	dbSeek(xFilial("SB1")+SD2->D2_COD)
	If !Found()
		msginfo("O produto " + SD2->D2_COD + ", informado na NF " + SD2->D2_SERIE + "/" + SD2->D2_DOC + ", nao existe no cadastro de Produtos!")
		Return(.f.)
	Endif

	&&_cDescPr := Alltrim(SB1->B1_DESC)

	nI := Ascan (_aClasFis, {|X|SubStr (X[1], 1, 10) == SB1 -> B1_POSIPI})
	If nI == 0                               		&& Posicao IPI nao existente
		aAdd (_aClasFis, {B1_POSIPI, _cCont})		&& Adiciona Posicao IPI ao Array
		_cCont := Soma1 (_cCont)
		_nKy := _nKy + 1
		_cClasFis := _aClasFis [_nKy, 2]
	Else
		_cClasFis := _aClasFis [nI, 2]
	EndIf

	RestArea(_aArea)

	Return(_lRet)

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³SCITEMPV  º Autor ³ Paulo Romualdo     º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Posiciona no arquivo de Itens do PV e carrega as variaveis º±±
	±±º          ³ contendo Descricao, Nro PV, Nro Ped Cli  				  º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function SCITEMPV
	Local _aArea    := GetArea()

	dbSelectArea("SC5")
	dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
	dbSelectArea("SC6")
	dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Carrega variavel com a Descricao do Produto                      ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	&&If Empty(_cDescPr)
	&&	If SF2->F2_TIPO <>"I"
	&&		_cDescPr := Alltrim(SC6->C6_DESCRI)+" Pedido Nro.: " + Alltrim(SC6->C6_PEDCLI) && +Alltrim(SB1->B1_ZZONU)+Alltrim(SB1->B1_ZZCLAS)
	&&	Else
	&&		_cDescPr := Alltrim(SC6->C6_DESCRI)
	&&	Endif
	&&EndIf
	_cDescPr := AllTrim(SC6->C6_DESCRI)+ IIF(!Empty(SD2->D2_LOTECTL), " Lote " + AllTrim(SD2->D2_LOTECTL), "")

	_cItem	 := SC6->C6_ITEM
	_cPed  := SC6->C6_NUM

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Verifica se o Pedido ja Foi Considerado.                         ³
	&&³ Se For Novo Pedido, Complementa String com Pedidos, Le Pedidos,  ³
	&&³ Soma Volumes, Mensagens, Loja de Entrega.                        ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nI := Ascan (_aNumPed, SD2->D2_PEDIDO)

	If nI == 0			&& Novo pedido.
		aAdd(_aNumPed, SD2->D2_PEDIDO)

		_cNumPed := If(Empty(_cNumPed),"Pedido: ",_cNumPed + "-" )+Alltrim(SD2->D2_PEDIDO)

		_nPedCli := aScan(_aPedCli, SC6->C6_PEDCLI)
		If _nPedCli == 0
			aAdd(_aPedCli, SC6->C6_PEDCLI)
			_cPedCli := If(!Empty(_cPedCli),_cPedCli + "-","")+SC6->C6_PEDCLI
		EndIf

		_cTpFrete := SC5->C5_TPFRETE

	EndIf

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Restaura as area salvas.                                         ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestArea(_aArea)

	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³SCPOSTES  º Autor ³ Paulo Romualdo     º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Posiciona no arquivo de TES para carregar as variaveis     º±±
	±±º          ³ Sit. Trib., CFO, Texto, Natureza, etc        			  º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ SigaFat				                                      º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function SCPOSTES
	dbSelectArea("SF4")
	dbSeek(xFilial("SF4")+SD2->D2_TES)

	_cSitrib := If(Empty(SD2->D2_CLASFIS),Substr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB,SD2->D2_CLASFIS)

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Verifica se o CFO ja foi considerado.                            ³
	&&³ Se for novo CFO, le TES e complementa string com CFOs.           ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nI := Ascan(_aCFO, Alltrim(SD2->D2_CF))

	If nI == 0
		AADD(_aCFO, Alltrim (SD2->D2_CF))
		_nTemNat := ASCAN(_aNatOper, Alltrim(SF4->F4_TEXTO))
		If _nTemNat == 0
			AADD(_aNatOper, Alltrim(SubStr(SF4->F4_TEXTO,1,20)))
		EndIf
	EndIf

	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³SCCARMSG  º Autor ³ Paulo Romualdo     º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Carrega todas as mensagens fiscais na variavel aMenPad2    º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ SigaFat				                                      º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function SCCARMSG()
	Local _aArea    := GetArea()
	Local cMsgClas  := ''
	Local nTamClas  := 0
	Local cMsgInsum := ""
	Local cNotaFat  := ""
	Local _nI := 0
	Local _nSeq := 0

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Verifica todas as mensagens fiscais gravadas para a nota fiscal. ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Mensagens Classificao Fiscal                                     ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nI:= 1 to Len(_aClasFis)
		If !Empty( _aClasFis[_nI, 1] )
			cMsgClas += AllTrim(_aClasFis[_nI, 2]+"-"+_aClasFis[_nI, 1])+Space(2)
		endif
	Next
	_nTMens := mlcount(cMsgClas, 60)
	aadd(_aMenPad2, memoLine(cMsgClas, 60, 1))
	For _nI:=2 to _nTMens
		aadd(_aMenPad2, memoline(cMsgClas, 60, _nI))
	Next

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Mensagens do Cabecalho do PV (SC5).                              ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SC5->C5_MENNOTA)
		_nTMens := MLCount(SC5->C5_MENNOTA,60)
		AADD(_aMenPad2,MemoLine(SC5->C5_MENNOTA,60,1))
		For _nI:=2 To _nTMens
			AADD(_aMenPad2,Memoline(SC5->C5_MENNOTA,60,_nI))
		Next _nI
	EndIf

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Mensagem de devolução de nota fiscal (c/ ou s/ poder terceiro).  ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(_aNFDev)
		For _nSeq := 1 to len(_aNFDev)

			If _aNFDev[_nSeq,4] == "B"
				_cStr := "Retorno da NF "+SubStr(_aNFDev[_nSeq,1],1,6)+"/"+AllTrim(SubStr(_aNFDev[_nSeq,1],7,3))
				_cStr += " de "+Dtoc(_aNFDev[_nSeq,2])
			ElseIf _aNFDev[_nSeq,4] == "D"
				_cStr := "Devolucao da NF "+SubStr(_aNFDev[_nSeq,1],1,6)+"/"+AllTrim(SubStr(_aNFDev[_nSeq,1],7,3))
				_cStr += " de "+Dtoc(_aNFDev[_nSeq,2])
			EndIf

			_nTMens := mlcount(_cStr, 60)
			aadd(_aMenPad2, memoLine(_cStr, 60, 1))
			For _nI:=2 to _nTMens
				aadd(_aMenPad2, memoline(_cStr, 60, _nI))
			Next
		Next

	EndIf

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Mensagem de Redespacho.                                          ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !Empty(AllTrim(_cNomRed) )
		_nTMens := MLCount(_cNomRed,60)
		AADD(_aMenPad2,MemoLine(_cNomRed,060,1))
		For _nI := 2 To _nTMens
			AADD(_aMenPad2,Memoline(_cNomRed,60,_nI))
		Next _nI
	EndIf

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Armazena pedido do cliente para ser impres. em dados adicion.    ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(_aPedCli) > 0
		_cPedCli := IIf(Len(_aPedCli) == 1,"Pedido : ", "Pedidos : ")+_cPedCli
		_nTMens := mlcount(_cPedCli, 60)
		aadd(_aMenPad2, MemoLine(_cPedCli, 60, 1))
		For _nI := 2 to _nTMens
			Aadd(_aMenPad2, Memoline(_cPedCli, 60, _nI))
		Next
	EndIf
 
	AADD(_aMenPad2,"EMPRESA OPTANTE DO SIMPLES NACIONAL NAO GERA CREDITO DE ICMS E IPI")

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Restaura as areas salvas                                         ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestArea(_aArea)

	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³SCPOSCLI  º Autor ³ Paulo Romualdo     º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Posiciona no Cliente/Fornece para carregar as variavies    º±±
	±±º          ³ de Dados Pessoais, endereco, end entrega, end cobranca, etcº±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ SigaFat				                                      º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function SCPOSCLI()
	Local _aArea    := GetArea()

	If _cTipoNF $ "D;B"		&&NF de devolucao/remessa->fornecedor
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Dados do Fornecedor                ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cNomCli  := SA2->A2_NOME &&+ " (" + SA2->A2_COD+"/"+SA2->A2_LOJA+")"
		_cCGCCli  := SA2->A2_CGC
		_cEndCli  := SA2->A2_END
		_cBaiCli  := SA2->A2_BAIRRO
		_cCEPCli  := SA2->A2_CEP
		_cMunCli  := SA2->A2_MUN
		_cTelCli  := AllTrim(SA2->A2_TEL)
		_cEstCli  := SA2->A2_EST
		_cInsCli  := SA2->A2_INSCR

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Endereco de entrega do Fornecedor  ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cEndEnt := Alltrim(SA2->A2_END)
		_cCepEnt := Alltrim(SA2->A2_CEP)
		_cCidEnt := Alltrim(SA2->A2_MUN)
		_cEstEnt := SA2->A2_EST
		_cTelEnt := SA2->A2_TEL

	Else
		dbSelectArea("SA1")		&&Cadastro de Clientes
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Dados do cliente                   ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cNomCli  := AllTrim(SA1 -> A1_NOME)&& + " (" + SA1->A1_COD+"/"+SA1->A1_LOJA+")"
		_cCGCCli  := SA1->A1_CGC
		If !Empty(SA1->A1_ENDENT)
			_cEndCli  := SA1->A1_ENDENT
			_cBaiCli  := SA1->A1_BAIRROE
			_cEstCli  := SA1->A1_ESTE
			_cMunCli  := SA1->A1_MUNE
			_cCEPCli  := SA1->A1_CEPE
		else
			_cEndCli  := SA1->A1_END
			_cBaiCli  := SA1->A1_BAIRRO
			_cEstCli  := SA1->A1_EST
			_cMunCli  := SA1->A1_MUN
			_cCEPCli  := SA1->A1_CEP
		endif
		_cTelCli  := AllTrim(SA1->A1_TEL)

		If !Empty(SA1->A1_FAX)
			_cTelCli  := _cTelCli  + "/" + AllTrim(SA1 -> A1_FAX)
		EndIf

		If !Empty(SA1->A1_INSCR)
			_cInsCli  := SA1 -> A1_INSCR
		Else
			_cInsCli  := SA1 -> A1_INSCRUR
		EndIf

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Endereco Cobranca                  ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SA1 ->A1_ENDCOB)
			_cEndCob := Alltrim(SA1 ->A1_ENDCOB)
			_cEndCob := _cEndCob + " - " + Alltrim(SA1 ->A1_BAIRROC) + ", CEP: " + Alltrim(SA1 ->A1_CEPC)
			_cMunCob := Alltrim (SA1 ->A1_MUNC)
			_cMunCob := _cMunCob + " - " + SA1 ->A1_ESTC
		EndIf

		&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		&&³ Endereco Entrega                   ³
		&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SA1 ->A1_ENDENT)
			_cEndEnt := Alltrim (SA1 ->A1_ENDENT)
		Endif

		If !Empty(SA1 ->A1_MUNE)
			_cEndEnt := _cEndEnt + " "+Alltrim (SA1 ->A1_MUNE)
		EndIf

		If !Empty(SA1 ->A1_ESTE)
			_cEndEnt := _cEndEnt + "-" + SA1 ->A1_ESTE
		EndIf

		If !Empty(SA1 ->A1_CEPE)
			_cEndEnt := _cEndEnt + " CEP: " + Alltrim (SA1 ->A1_CEPE)
		EndIf

		If !Empty(SA1 ->A1_TEL)
			_cEndEnt := _cEndEnt + " F.: " + AllTrim(SA1 ->A1_TEL)
		EndIf

	EndIf

	dbSelectArea("SA1")
	dbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)

	_cSuframa := SA1->A1_SUFRAMA
	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Restaura a area salva              ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestArea(_aArea)

	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³SCDUPLIC  º Autor ³ Paulo Romualdo     º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Posiciona o SE1 - Contas a Receber 				          º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ SigaFat				                                      º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function SCDUPLIC
	Local _cKey   := xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC
	Local _aArea  := GetArea()
	Local _nValor := 0
	Local _nImpostos := 0
	Local cValExt := ""

	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSeek(_cKey)

	While SE1->(!Eof()) .and. E1_FILIAL + E1_PREFIXO + E1_NUM == _cKey
		If SubStr(SE1->E1_TIPO, 1, 2) == "NF"
			_nImpostos :=  E1_CSLL + E1_COFINS + E1_PIS
			_nValor    :=  E1_VALOR - _nImpostos
			Aadd(_aDupl , {E1_NUM+"/"+SE1->E1_PARCELA, _nValor, E1_VENCTO	})
			_nTotImp  += _nImpostos
		EndIf
		cValExt := ""
/*If SubStr (SE1 -> E1_TIPO, 1, 2) == "NF"
&&nDup ++
_nRecno := RecNo()
_nValor :=  E1_VALOR
cValExt := AllTrim(Extenso(_nValor))
AADD(_aDupl, {E1_NUM+IIF(!Empty(SE1->E1_PARCELA),"/"+SE1->E1_PARCELA,SE1->E1_PARCELA),_nValor,E1_VENCTO,cValExt})
&&_nTotImp  += _nImpostos
Elseif 	SE1 -> E1_TIPO == "CF-" .or. SE1 -> E1_TIPO == "CS-" .or. SE1 -> E1_TIPO == "PI-"
_nTotImp  += SE1->E1_VALOR
EndIf*/
		If SubStr(SE1->E1_TIPO,1,3) == "IR-"
			_nIrrf :=  _nIrrf + E1_VALOR
		EndIf
		If SubStr(SE1->E1_TIPO,1,3) == "IN-"
			_nInss :=  _nInss + E1_VALOR
		EndIf
		SE1->(dbSkip())
	EndDo

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Pesquisa pelo Percentual de IRRF   ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	&&If !Empty(_nIrrf)
	If _nIrrf > 0 .or. _nInss > 0
		If !Empty(SA1->A1_NATUREZ)
			dbSelectArea("SED")
			dbSeek(xFilial("SED")+SA1->A1_NATUREZ)
			_nPerIrrf := If(SED->ED_CALCIRF == "S",SED->ED_PERCIRF,0)
			_nPerInss := If(SED->ED_DEDINSS == "1",SED->ED_PERCINS,0)
		Else
			_nPerIrrf :=  GetMv("MV_ALIQIRF")
		EndIF
	EndIf

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Restaura areas salvas              ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestArea(_aArea)

	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³SCTRANSP  º Autor ³ Paulo Romualdo     º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Posiciona o SA4 - Redespacho e Transportadora			  º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ SigaFat				                                      º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function SCTRANSP()
	Local _aArea := GetArea()

	If !Empty(SF2->F2_REDESP)
		dbSelectArea("SA4")
		dbSeek(xFilial("SA4")+SF2->F2_REDESP)
		If Found()
			_cNomRed := "REDESPACHO: "+ AllTrim(SA4->A4_NOME )
			If !Empty(SA4->A4_END)
				_cNomRed := _cNomRed + " "+ AllTrim(SA4->A4_END) +" "+ AllTrim(SA4->A4_MUN)+ " / "+SA4->A4_EST
			EndIf
			If !Empty(SA4->A4_CEP)
				_cNomRed := _cNomRed + " CEP: "+ AllTrim(SA4->A4_CEP)
			EndIf
			If !Empty(SA4->A4_TEL)
				_cNomRed := _cNomRed + " F.: "+AllTrim(SA4->A4_TEL)
			EndIf
			If !Empty(SA4->A4_CGC)
				_cNomRed := _cNomRed + " CGC: " +SA4->A4_CGC
			EndIf
		EndIf
	EndIf

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Posiciona o SA4 Para Buscar a Transportadora e Redespacho     ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SF2->F2_TRANSP <> '000970'

       dbSelectArea ("SA4")
       dbSeek (xFilial ("SA4") + SF2 -> F2_TRANSP)
       _cNomTra := SA4 -> A4_NOME
       _cCGCTra := SA4 -> A4_CGC
       _cEndTra := ALLTRIM(SA4 -> A4_END) + " - " + ALLTRIM(SA4->A4_BAIRRO)
       _cMunTra := SA4 -> A4_MUN
       _cEstTra := SA4 -> A4_EST
       _cInETra := SA4 -> A4_INSEST

	Else

       _cNomTra := UPPER(SA1->A1_NOME)
       _cCGCTra := SA1->A1_CGC
       _cEndTra := ALLTRIM(SA1->A1_END) + " - " + ALLTRIM(SA1->A1_BAIRRO)
       _cMunTra := UPPER(SA1->A1_MUN)
       _cEstTra := UPPER(SA1->A1_EST)
       _cInETra := SA1->A1_INSCR
	
	End

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Restaura areas salvas              ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Restarea(_aArea)

	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³SCCABEC   º Autor ³ Paulo Romualdo     º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Imprime Cabecalho da nota onde as mensagens serao impressasº±±
	±±º          ³ no rodape                                                  º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/

Static Function SCCabec()
	Local _nSeq := 0
	Local _cEndEmp:= _cCidEmp:=_cTelEmp:=_cFaxEmp:=Space(75)
	Local _nCont := 0
	Local _cCepEmp:=_cHomePg:=_cEmail:=Space(75)
	If _lMensg
		_nM   := 1
		_nPag := 1
	else
		_nPag++
	endif


	@ 01, 000 PSAY chr(27) + "M" + chr(27)  + "C" + chr( 77 )
	_nLin := 1
	&&@ _nLin, 001 PSAY chr(27) + chr(67) + chr(64)
	&&@ _nLin, 010 PSAY _cImpComp  + _cImp20cpp

	_cTelEmp := "FONE: "+AllTrim(SM0->M0_TEL)
	_cFaxEmp := "FAX:  "+AllTrim(SM0->M0_FAX)

	@ _nLin, 145 PSAY Chr(14)+Alltrim(Str(Val(_cNumNF),10,0))
	_nLin := 2
	@ _nLin, 098 PSAY "X"

	_cCFO := ""
	For _nCont := 1 to Len (_aCFO)
		_cCFO := _cCFO + _aCFO [_nCont]
		if _nCont < len (_aCFO)
			_cCFO := _cCFO + "/"
		endif
	next
	_cNat := ""
	for _nCont := 1 to len (_aNatOper)
		_cNat := _cNat + _aNatOper [_nCont]
		if _nCont < len (_aNatOper)
			_cNat := _cNat + "/"
		endif
	next

	_nLin += 5

	@ _nLin, 001 PSAY substr (_cNat, 1, 85)
	@ _nLin, 045 PSAY _cCFO

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Dados do cliente ou fornecedor - Parte 1                         ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLin += 3
	If !Empty(_cNomCli)
		@ _nLin, 001 PSAY Alltrim (_cNomCli)
	EndIf
	If Len (Alltrim (_cCGCCli)) > 11
		@_nLin, 095 PSAY _cCGCCli Picture "@R 99.999.999/9999-99"
	Else
		@_nLin, 095 PSAY _cCGCCli Picture "@R 999.999.999-99"
	EndIf
	If !Empty(_dEmissao)
		@ _nLin, 143 PSAY _dEmissao
	Endif
	_nLin += 2

	If !Empty(_cEndCli)
		@ _nLin, 001 PSAY _cEndCli Picture "@!"
	EndIf
	If !Empty(_cBaiCli)
		@ _nLin, 076 PSAY Substr (_cBaiCli, 1, 27) Picture "@!S27"
	EndIf
	If !Empty(_cCEPCli)
		@ _nLin, 107 PSAY Substr (_cCEPCli, 1, 5) + "-" + Substr (_cCEPCli, 6, 3) Picture "@!"
	EndIf
	If !Empty(_dDtSaida)
		@ _nLin, 143 PSAY _dDtSaida
	endif

	_nLin += 2

	If !Empty(_cMunCli)
		@ _nLin, 001 PSAY _cMunCli 	    Picture "@!S30"
	EndIf
	If !Empty(AllTrim(_cTelCli))
		@ _nLin, 048 PSAY AllTrim(_cTelCli)  Picture "@!S25"
	EndIf
	If !Empty(_cEstCli)
		@ _nLin, 082 PSAY _cEstCli Picture "@!"
	EndIf
	If !Empty(_cInsCli)
		@ _nLin, 095 PSAY _cInsCli Picture "@R 999.999.999.999"
	EndIf
	If !Empty(_cHrSaida)
		@ _nLin, 110 PSAY _cHrSaida
	Endif
	_nLin += 2

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Impressao das Parcelas                                           ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nSeq:=1 to Len(_aDupl)
		If _nSeq <= 3
			If _aDupl[_nSeq][2] > 0
				&&			@ _nLin, 060  psay MemoLine( _aDupl[_nSeq][4],60)              && Valor por Extenso
				@ _nLin, 001  psay _aDupl[_nSeq][1]                            && Numero do Titulo
				@ _nLin, 020  psay _aDupl[_nSeq][2] picture "@E 99,999,999.99" && valor do titulo
				@ _nLin, 035  psay _aDupl[_nSeq][3]                            && vencimento
			Endif
			_nLin += 1
		endif
	Next

	Return()

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³SCIMPITM  º Autor ³ Paulo Romualdo     º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Imprime o(s) Item(ns) da NF								  º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function SCIMPITM
	Local _nY := 0
	Local _nK := 0
	_nLin     := 22
	_nContLi  := 0
	_lImpCont := .f.
	_xP       := 0
	_nLen     := Len (_aItens)

	For _nK := 1 To _nLen

		If _lImpCont
			@ _nLin, 017 PSAY MemoLine (_aItens [_nK-1, 02],60, _nImpCont+1) Picture "@!S60"	&& Descr. Prod
		EndIf

		If _nContLi >= 28
			U_ImpAster()
			_xP := _xP + 1
			_lMensg := .F.
			SCCabec()
			_lMensg := .T.
			_nContLi := 0
			_nLin    := 22
		EndIf
		_nTamItem := MLCount (Alltrim (_aItens [_nK, 02]),60)

		If _nTamItem >= 1		&& Com quebra de item para impressao da descricao.
			For _nY := 1 To _nTamItem
				If _nY == 1
					@ _nLin, 001 PSAY _aItens [_nK, 1]                     Picture "@!"					&& Codigo do Produto
					@ _nLin, 021 PSAY MemoLine (_aItens [_nK, 02],60, _nY) Picture "@!S60"				&& Descr. Prod
					@ _nLin, 095 PSAY _aItens [_nK, 04]                    Picture "@!!"				&& Sit. Trib.
					@ _nLin, 102 PSAY _aItens [_nK, 05]                    Picture "@!"					&& Unidade
					@ _nLin, 108 PSAY Round(_aItens [_nK, 06],2)           Picture "@E 9999999.99"		&& Quantidade
					@ _nLin, 120 PSAY Round(_aItens [_nK, 07],2)           Picture "@E 999,999,999.99"	&& Vlr Unit
					@ _nLin, 139 PSAY Round(_aItens [_nK, 08],2)           Picture "@E 999,999,999.99"	    && Vlr Tot
					@ _nLin, 155 PSAY Transform(_aItens [_nK, 09], '@E 99')
				Else
					@ _nLin, 021  PSAY MemoLine (_aItens [_nK, 02],60, _nY) Picture "@!S60"				&& Descr. Prod
					_nY := _nY + 1
				Endif
				_nLin := _nLin + 1
				_nContLi++
				_lImpCont := .f.
				_nImpCont := 0
				If (_nY < _nTamItem) .and. _nContLi >= 22
					_lImpCont := .t.
					_nImpCont := _nY
				EndIf

			Next
		Endif
	Next
	_nLin++
	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³IMPRODAPE º Autor ³ Paulo Romualdo     º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Imprime rodape da nota.                                    º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function ImpRodape()

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Valor dos impostos.                                           ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLin := 052
	@ _nLin, 010 PSAY _nBaseICM Picture "@E 999,999,999.99"		&& Base ICMS
	@ _nLin, 040 PSAY _nValIcm  Picture "@E 999,999,999.99"		&& Vlr. ICMS
	@ _nLin, 070 PSAY _nBICMRet Picture "@E 999,999,999.99"		&& Base de Calculo ICMS Retido
	@ _nLin, 110 PSAY _nVICMRet Picture "@E 999,999,999.99"		&& Vlr. ICMS Retido
	If SF2->F2_TIPO <> "I" .and. Len(_aItens) > 0
		@ _nLin, 145 PSAY _nValMerc - SF2->F2_BASEISS Picture "@E 999,999,999.99" && Vlr. Mercadorias (c/ ISS).Abílio/Rodrigo S/ ISS
	Else
		If _nVlrIss == 0
			@ _nLin, 098 PSAY _nVlrIss Picture "@E 999,999,999.99"
		EndIf
	EndIf
	_nLin := _nLin + 2
	@ _nLin, 010 PSAY _nValFret Picture "@E 999,999,999.99"		&& Val. Frete
	@ _nLin, 040 PSAY _nValSeg  Picture "@E 999,999,999.99"		&& Val. Seguro
	@ _nLin, 070 PSAY _nVlrDesp Picture "@E 999,999,999.99"		&& Vlr. Despesas Acessorias
	@ _nLin, 110 PSAY _nValIPI  Picture "@E 999,999,999.99"		&& Vlr. IPI
	If SF2->F2_TIPO <> "I"
		@ _nLin, 145 PSAY _nValBrut Picture "@E 999,999,999.99"	&& Vlr. Bruto - Vlr. Total da Nota
	EndIf

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Dados da transportadora                                       ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLin += 3
	If !Empty(_cNomTra)
		@ _nLin, 001 PSAY Alltrim (_cNomTra) Picture "@!S40"
	EndIf

	If _cTpFrete == "C"
		@ _nLin, 075 PSAY "1" &&85
	Else
		@ _nLin, 075 PSAY "2" &&85
	EndIf

//	If Empty(_cPlaca)
		@ _nLin, 090 PSAY _cPlaca Picture "@!S10"
//		@ _nLin, 090 PSAY '' Picture "@!S10"
//	EndIf
	If !Empty(_cEstTra)
		@ _nLin, 115 PSAY _cEstTra Picture "!!"
	EndIf

	&&If Len (Alltrim (_cCGCTra)) > 11
	If Len (Alltrim ('09155061000190')) > 11
		&&@ _nLin, 140 PSAY _cCGCTra Picture "@R 99.999.999/9999-99"
		@ _nLin, 140 PSAY '09155061000190' Picture "@R 99.999.999/9999-99"
	Else
		@ _nLin, 140 PSAY _cCGCTra Picture "@R 999.999.999-99"
	EndIf

	_nLin +=  2
	If !Empty(_cEndTra)
		@ _nLin, 001 PSAY Alltrim (_cEndTra) Picture "@!S70"
	EndIf
	If !Empty(_cMunTra)
		@ _nLin, 060 PSAY Alltrim (_cMunTra) Picture "@!S15"
	EndIf
	If !Empty(_cEstTra)
		@ _nLin, 115 PSAY _cEstTra    Picture "!!"
	EndIf
	If empty(_cInETra)
		@ _nLin, 140 PSAY _cInETra    Picture "!!!!!!!!!!"
	Else
		@ _nLin, 140 PSAY _cInETra    Picture "@R 999.999.999.999"
	Endif

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Peso Liquido, Peso Bruto, Especie, Volume                     ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLin +=  2
	@ _nLin, 005 PSAY _cVolu1  Picture "9999999999"
	&&If !Empty(_cEspec1)
	If !Empty('CX')
		@ _nLin, 025 PSAY AllTrim(_cEspec1) Picture "@S10"
	EndIf
	&&If !Empty(_cMarca)
	If !Empty('Teste')
		&&@ _nLin, 050 PSAY AllTrim(_cMarca) Picture "@S20"
	EndIf
	@ _nLin, 110 PSAY _nPBruto Picture "@E 999,999,999.99"
	@ _nLin, 145 PSAY _nPLiqui Picture "@E 999,999,999.99"

	_nLin += 3

	While _nM <= 21
		U_ImpMens(1) && Dados Adicionais
	EndDo

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Numero da Nota no Rodape                                      ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLin := 74
	@ _nLin, 145 PSAY Chr(14)+Alltrim(Str(Val(_cNumNF),10,0))

	_nLin == 0

	Return()
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³IMPASTER  º Autor ³ Paulo Romualdo     º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Imprime asteriscos se houver quebra de nota.               º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/

User Function ImpAster()
	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³Valor dos impostos.                                            ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLin := 52
	@ _nLin, 010 PSAY "************"       && Base ICMS
	@ _nLin, 040 PSAY "************"     && Vlr. ICMS
	@ _nLin, 070 PSAY "************"     && Base de Calculo ICMS Retido
	@ _nLin, 110 PSAY "**********"         && Vlr. ICMS Retido
	If SF2->F2_TIPO <> "I"
		@ _nLin, 145 PSAY "**************" && Vlr. Mercadorias (c/ ISS).
	EndIf
	_nLin := _nLin + 2
	@ _nLin, 010 PSAY "**********"         && Val. Frete
	@ _nLin, 040 PSAY "**************"     && Val. Seguro
	@ _nLin, 070 PSAY "**************"     && Vlr. Despesas Acessorias
	@ _nLin, 110 PSAY "**************"     && Vlr. IPI
	If SF2->F2_TIPO <> "I"
		@ _nLin, 145 PSAY "**************" && Vlr. Bruto
	EndIf

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³Dados da transportadora                                        ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLin := _nLin + 3
	@ _nLin, 001 PSAY "***************************"
	@ _nLin, 075 PSAY "*"
	@ _nLin, 090 PSAY "********"
	@ _nLin, 115 PSAY "**"
	@ _nLin, 140 PSAY "******************"

	_nLin := _nLin + 2
	@ _nLin, 004 PSAY "************************"
	@ _nLin, 060 PSAY "*****************"
	@ _nLin, 115 PSAY "**"
	@ _nLin, 140 PSAY "***************"

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Peso Liquido, Peso Bruto, Especie, Volume                     ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLin := _nLin + 2
	@ _nLin, 005 PSAY "******"
	@ _nLin, 025 PSAY "***************"
	@ _nLin, 050 PSAY "***************"
	@ _nLin, 110 PSAY "*********"
	@ _nLin, 145 PSAY "*********"


	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³ Numero da Nota no Rodape                                      ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLin := 73
	@ _nLin, 145 PSAY _cNumNF

	_nLin == 0

	Return()

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³ImpMens   º Autor ³  Paulo Romualdo    º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Imprimir Dados Adicionais da NF. (Mensagem)                º±±
	±±º          ³ necessario (caso nao existam).                             º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/

User Function ImpMens(nIncLinha)
	&&IncLinha = 1 Pula linha
	&&nIncLinha = 2 Nao Pula linha
	If Len(_aMenPad2) >= _nM
		@ _nLin,001 PSAY _aMenPad2[_nM]	Picture "@!S60"
	EndIf
	If nIncLinha = 1
		_nLin := _nLin + 1
	endif
	_nM++

	Return

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³VALIDPERG º Autor ³  Paulo Romualdo    º Data ³  03/07/08   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
	±±º          ³ necessario (caso nao existam).                             º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Programa principal                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
Static Function ValidPerg()

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	&&_cPerg := PADR(_cPerg,6)

	&& Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{_cPerg,"01","Da N.Fiscal " ,"Da N.Fiscal " ,"Da N.Fiscal " ,"mv_ch1","C",09,0,0,"G",""        ,"mv_par01","","","","","","","","","","","","","",""})
	aAdd(aRegs,{_cPerg,"02","Ate N.Fiscal" ,"Ate N.Fiscal" ,"Ate N.Fiscal" ,"mv_ch2","C",09,0,0,"G",""        ,"mv_par02","","","","","","","","","","","","","",""})
	aAdd(aRegs,{_cPerg,"03","Serie       " ,"Serie       " ,"Serie       " ,"mv_ch3","C",03,0,0,"G",""        ,"mv_par03","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(_cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	If ! (Empty( _sAlias ))

	   dbSelectArea(_sAlias)

	End

	Return()

	&&ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	&&³                         F  I   M                                 ³
	&&ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
