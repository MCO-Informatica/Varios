#include "rwmake.ch"

User Function SCRSNF()

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Define Variaveis                                                 ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	Private aDriver 	:= {}
	Private _nLin       := 0
	Private _cPerg      := padR("SCRSNF",Len(SX1->X1_GRUPO))
	Private _wNrel      := "SCRSNF"
	Private _cNrel      := "SCRSNF"
	Private _cTitulo    := "Emissao Nota Fiscal LSL"
	Private _cDesc1     := "Emissao de N.F. de Saida"
	Private _cDesc2     := "para LSL"
	Private _cDesc3     := ""
	Private aReturn    := {"Especial", 1, "Administracao", 2, 2, 1, "", 1}
	Private _cTamanho   := "M"

	Private _cImpNorm   := chr(18)      	&&impressora - normal
	Private _cImpComp   := chr(15)      	&&             comprimido
	Private _cImp20cpp  := chr(27) + "M"	&&             20cpp CARACTER MAIS FINO
	Private _cImpEsp    := chr(27) + "0"	&&             1/8" altura da linha DISTANCIA ENTRE LINHAS
	Private _cImpOn     := chr(17)      	&&             on-line
	PRivate _cImpOff    := chr(19)      	&&             off-line
	Private _cImpReset  := chr(27) + "@"	&&             reset

	Private nLastKey    := 0
	Private _lContinua  := .T.
	&&Private	_nPosReg    := 0         	&&guarda recno() do 1? item da NF
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
	Private _aNotas    := {}								&&array com as NF큦
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Variaveis utilizadas para parametros                             ?
	&&? mv_par01             && De Nota                                  ?
	&&? mv_par02             && Ate a Nota                               ?
	&&? mv_par03             && Serie                                    ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Valida/Cria Grupo de Perguntas                                   |
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If !Pergunte(_cPerg,.T.)
		ValidPerg()
		If !Pergunte (_cPerg, .T.)
			Return
		EndIf
	EndIf

	If LastKey () == 27 .or. nLastKey == 27 .or. nLastKey == 286
		Return
	EndIf

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Prepara a array para impressao das Notas Fiscais de Saida.       ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Posiciona na nota informada no parametro "De",                   ?
	&&| ou a proxima caso exista.                                        |
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	SF2->(dbSetOrder(1))                 &&filial,documento,serie,cliente,loja

	&&Posiciona na nota informada no parametro "De", ou a proxima caso exista.
	SF2->(dbSeek(xFilial("SF2")+mv_par01+mv_par03,.t.))

	While !SF2->(Eof()) .and. SF2->F2_FILIAL == xFilial("SF2") .and. SF2->F2_DOC <= mv_par02 .And. SF2->F2_SERIE == mv_par03

		If SF2->F2_SERIE <> mv_par03 .Or. Alltrim(SF2->F2_ESPECIE) <> 'SPED'
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&? Monta a interface padrao com o usuario...                           ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	_cNRel := SetPrint("SF2",_cNRel,_cPerg,_cTitulo,_cDesc1,_cDesc2,_cDesc3,.T.,,.T.,_cTamanho,,.T.)

	If LastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
		Return
	EndIf

	SetDefault(aReturn, "SF2")

	If LastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
		Return
	EndIf

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&? Funcao para Processamento e Impressao da NF Saida.                  ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	SCIMPRNF()

	Return

	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿞CIMPRNF  ? Autor ? Paulo Romualdo     ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Funcao para Processamento e Impressao da NF de Saida.      볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? Programa principal                                         볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
	/*/
Static Function SCIMPRNF

	Local _aArea	:= {}

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&? Posiciona Todos os Indices Necessarios.                             ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&?                         PRINCIPAL                                   ?
	&&? Loop para o numero de Notas Fiscais que atendem aos parametros.     ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	For _nIf:=1 to Len (_aNotas)

		If LastKey () == 27 .or. nLastKey == 27 .or. nLastKey == 286
			@ 25, 01 PSAY "** CANCELADO PELO OPERADOR **"
			_lContinua := .F.
			Exit
		EndIf

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		&&? Inicializa Variaveis p/ Nova NF                                  ?
		&&? Ver Descricao das Variaveis no Trecho Define Variaveis           ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		&&? Posiciona o SF2 - Cabecalho da Nota Fiscal de Saida              ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		_cNota := Alltrim(_aNotas[_nIf])
		dbSelectArea("SF2")
		dbSeek(xFilial("SF2")+_cNota+mv_par03)			&& Filial + Nota + Serie

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		&&? Carrega as Variaveis de Cabecalho da NF                          ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		_cTipoNF  := SF2 -> F2_TIPO
		_cNumNF   := SF2 -> F2_DOC
		_cSerNF   := SF2 -> F2_SERIE
		_dEmissao := SF2 -> F2_EMISSAO
		_dDtSaida := SF2 -> F2_EMISSAO
		_cHrSaida := SF2 -> F2_HORNFE

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		&&? Carrega as Variaveis com os Impostos                             ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		&&? Carrega as variaveis de Volumes Transportados                    ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		_cVolu1   := SF2 -> F2_VOLUME1
		_cEspec1  := SF2 -> F2_ESPECI1
		_cMarca   := ''
		_cPlaca   := ''
		_nPBruto  := SF2 -> F2_PBRUTO
		_nPLiqui  := SF2 -> F2_PLIQUI

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		&&? Posiciona o SD2 - Itens da NF                                    ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		_cKey := xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE
		dbSelectArea("SD2")
		dbSeek(_cKey)
		_nPosReg := Recno()		&&guarda posicao do 1? item da NF

		While !Eof () .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE == _cKey

			&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			&&? Chamada da Funcao SCPOSPRD - posicionar no Produto (SB1)      ?
			&&? para carregar as variaveis Descricao, Cod Clas Fiscal, etc    ?
			&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			If !( SCPOSPRD())
				dbSelectArea("SD2")
				dbSkip()
				Loop
			Endif

			&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			&&? Chamada da Funcao SCITEMPV - posicionar no Item do PV (SC6)   ?
			&&? para carregar as variaveis Descricao, Num PV, Nr Ped Cli, etc ?
			&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			SCITEMPV()

			&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			&&? Posicionar no Compl Prod (SB5) para carregar a variavel       ?
			&&? _cDescPrd - Descr Cientifica 						               ?
			&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			&&If Empty(_cDescPr)
			&&	_cDescPr := Posicione("SB5",1,xFilial("SB5")+SD2->D2_COD,"SB5->B5_CEME")
			&&EndiF

			&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			&&? Posiciona o SF4 - TES                                         ?
			&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			SCPOSTES()

			&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			&&? Preenche array dos Itens da N.F.                                                         ?
			&&? Estrutura do array de Itens da NF _aItens[n][m]                                          ?
			&&? n = numero do item                                                                       ?
			&&? m = CodProd, Descr, ClasFis, SitTrib, UniMedida, Quant, PrcUnit, PrcTot, AliqIPI, ValIPI ?
			&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			dbSelectArea("SD2")
			_cCodProd := Alltrim(SD2 -> D2_COD)
			_cUM      := SD2 -> D2_UM
			_nQuant   := SD2 -> D2_QUANT
			_nPesoL   := SD2 -> D2_QUANT * SD2 -> D2_PESO
			_nDesc    := 0
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
					,  D2_PICM										; 	&& 09 - Perc ICM
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

			&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			&&? Verifica nota fiscal de devolu豫o ou poder de terceiro        ?
			&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			If !Empty(SD2->D2_NFORI)
				If !Empty(SD2->D2_IDENTB6)
					&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
					&&? Poder de Terceiro - captura data de emiss?o e valor     ?
					&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
					If !Empty(posicione("SB6", 1, xfilial("SB6") + SD2->D2_COD + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_IDENTB6, "B6_PRODUTO"))
						Aadd(_aNFDev, {SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA, SB6->B6_EMISSAO, SD2->D2_TOTAL,"B"})
					EndIf
				Else
					&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
					&&? Verifica nota de devolu豫o - sem poder de terceiro      ?
					&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
					If !Empty(posicione("SD1", 1, xfilial("SD1") + SD2->D2_NFORI + SD2->D2_SERIORI + SD2->D2_CLIENTE + SD2->D2_LOJA, "D1_DOC"))
						Aadd(_aNFDev, {SD2->D2_NFORI + SD2->D2_SERIORI + SD2->D2_CLIENTE + SD2->D2_LOJA, SD1->D1_EMISSAO, SD2->D2_TOTAL,"D"})
					EndIf
				EndIf

			EndIf
			RestArea(_aArea)

			&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			&&? Acumula Desconto Suframa para apresentar no corpo da NF.      ?
			&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
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

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&? Posiciona SA1 (Cliente) ou SA2 (Fornecedor)                   ?
		&&? Verifica se NF Devolucao ou Beneficiamento                    ?
		&&? Preencher os campos de endereco de cobranca nas variaveis     ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		SCPOSCLI()

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&? Posiciona o SA3 Para Buscar o vendedor                        ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		dbSelectArea("SA3")
		dbSeek(xFilial("SA3")+SF2->F2_VEND1)

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&? Posiciona o SA4 Para Buscar o Redespacho e Transportadora     ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		SCTRANSP()

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&? Posiciona o SA6 Para Buscar o Banco                           ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		dbSelectArea("SA6")
		dbSeek(xFilial("SA6")+SC5->C5_BANCO)

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&? Posiciona o SE4 Para Buscar a Condicao de Pagamento           ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		_cCondPag := Posicione("SE4",1,xFilial("SE4")+SF2->F2_COND,"SE4->E4_DESCRI")

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&? Posiciona e Carrega variaveis referente a Duplicata           ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		SCDUPLIC()

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&? Carrega todas as mensagens no aMenPad2	                     ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		SCCARMSG()

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&? Carrega variaveis para impressao de ISS                       ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		_nVlrIss  := _nVlrIss + SF2->F2_VALISS			&& Acumula o Valor ISS

		If !_lContinua
			Exit
		Endif

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&?                                                               ?
		&&?                          IMPRESSAO                            ?
		&&?                                                               ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&? Impressao do Cabecalho da NF 				                     ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		SCCABEC()

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&? Impressao dos itens da NF - Materiais.                        ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		SCIMPITM()

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&? Impressao do Rodape da NF 				                        ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		IMPRODAPE()

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		&&? Grava o Flag de Impressao				                           ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		dbSelectArea("SF2")
		RecLock("SF2",.F.)
		SF2->F2_FIMP := "T"
		MsUnlock()

	Next _nIF

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Encerra a Impressao da(s) NF(s) e deixa posicionado para proxima ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	_nLin := 0

	If aReturn[5]== 3 .AND. Len(aDriver) > 0		&&Direto na Porta
		SetPrc(0,0)											&&Deixa posicionado para a proxima Nota
		@ 0,0 PSAY " "
		@ 0,Pcol()+1 PSAY &(aDriver[7])				&&-Reset
		@ 0,Pcol()+1 PSAY chr(27)+"@"				&&10cpi
	EndIf

	dbSelectArea("SF2")
	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Set Device To Screen                                             ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If _lContinua
		SetPgEject(.F.)
		If aReturn[5] == 1	&&Relatorio em tela
			Set Printer To
			dbcommitAll()
			ourspool(_wNrel)
		EndIf
		MS_FLUSH()
	EndIf

	Return

	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿞CPOSPRD  ? Autor ? Paulo Romualdo     ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Posiciona no arquivo de produtos e carrega as variaveis    볍?
	굇?          ? contendo Descricao, Clas. Fiscal 						  볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? Programa principal                                         볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿞CITEMPV  ? Autor ? Paulo Romualdo     ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Posiciona no arquivo de Itens do PV e carrega as variaveis 볍?
	굇?          ? contendo Descricao, Nro PV, Nro Ped Cli  				  볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? Programa principal                                         볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
	/*/
Static Function SCITEMPV
	Local _aArea    := GetArea()

	dbSelectArea("SC5")
	dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
	dbSelectArea("SC6")
	dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Carrega variavel com a Descricao do Produto                      ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Verifica se o Pedido ja Foi Considerado.                         ?
	&&? Se For Novo Pedido, Complementa String com Pedidos, Le Pedidos,  ?
	&&? Soma Volumes, Mensagens, Loja de Entrega.                        ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Restaura as area salvas.                                         ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	RestArea(_aArea)

	Return

	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿞CPOSTES  ? Autor ? Paulo Romualdo     ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Posiciona no arquivo de TES para carregar as variaveis     볍?
	굇?          ? Sit. Trib., CFO, Texto, Natureza, etc        			  볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? SigaFat				                                      볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
	/*/
Static Function SCPOSTES
	dbSelectArea("SF4")
	dbSeek(xFilial("SF4")+SD2->D2_TES)

	_cSitrib := If(Empty(SD2->D2_CLASFIS),Substr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB,SD2->D2_CLASFIS)

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Verifica se o CFO ja foi considerado.                            ?
	&&? Se for novo CFO, le TES e complementa string com CFOs.           ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿞CCARMSG  ? Autor ? Paulo Romualdo     ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Carrega todas as mensagens fiscais na variavel aMenPad2    볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? SigaFat				                                      볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
	/*/
Static Function SCCARMSG()
	Local _aArea    := GetArea()
	Local cMsgClas  := ''
	Local nTamClas  := 0
	Local cMsgInsum := ""
	Local cNotaFat  := ""

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Verifica todas as mensagens fiscais gravadas para a nota fiscal. ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Mensagens Classificao Fiscal                                     ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Mensagens do Cabecalho do PV (SC5).                              ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If !Empty(SC5->C5_MENNOTA)
		_nTMens := MLCount(SC5->C5_MENNOTA,60)
		AADD(_aMenPad2,MemoLine(SC5->C5_MENNOTA,60,1))
		For _nI:=2 To _nTMens
			AADD(_aMenPad2,Memoline(SC5->C5_MENNOTA,60,_nI))
		Next _nI
	EndIf

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Mensagem de devolu豫o de nota fiscal (c/ ou s/ poder terceiro).  ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Mensagem de Redespacho.                                          ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	If !Empty(AllTrim(_cNomRed) )
		_nTMens := MLCount(_cNomRed,60)
		AADD(_aMenPad2,MemoLine(_cNomRed,060,1))
		For _nI := 2 To _nTMens
			AADD(_aMenPad2,Memoline(_cNomRed,60,_nI))
		Next _nI
	EndIf

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Armazena pedido do cliente para ser impres. em dados adicion.    ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If Len(_aPedCli) > 0
		_cPedCli := IIf(Len(_aPedCli) == 1,"Pedido : ", "Pedidos : ")+_cPedCli
		_nTMens := mlcount(_cPedCli, 60)
		aadd(_aMenPad2, MemoLine(_cPedCli, 60, 1))
		For _nI := 2 to _nTMens
			Aadd(_aMenPad2, Memoline(_cPedCli, 60, _nI))
		Next
	EndIf

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Mensagens de Vendedor                                            ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If SA3->(Found())
		_cNomeVen := "Vendedor: "+SA3->A3_NOME
		_nTMens := MLCount(_cNomeVen,60)
		AADD(_aMenPad2,MemoLine(_cNomeVen,060,1))
		For _nI := 2 To _nTMens
			AADD(_aMenPad2,Memoline(_cNomeVen,60,_nI))
		Next
	EndIf
	*/
	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Restaura as areas salvas                                         ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	RestArea(_aArea)

	Return

	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿞CPOSCLI  ? Autor ? Paulo Romualdo     ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Posiciona no Cliente/Fornece para carregar as variavies    볍?
	굇?          ? de Dados Pessoais, endereco, end entrega, end cobranca, etc볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? SigaFat				                                      볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
	/*/
Static Function SCPOSCLI()
	Local _aArea    := GetArea()

	If _cTipoNF $ "D;B"		&&NF de devolucao/remessa->fornecedor
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		&&? Dados do Fornecedor                ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		_cNomCli  := SA2->A2_NOME &&+ " (" + SA2->A2_COD+"/"+SA2->A2_LOJA+")"
		_cCGCCli  := SA2->A2_CGC
		_cEndCli  := SA2->A2_END
		_cBaiCli  := SA2->A2_BAIRRO
		_cCEPCli  := SA2->A2_CEP
		_cMunCli  := SA2->A2_MUN
		_cTelCli  := AllTrim(SA2->A2_TEL)
		_cEstCli  := SA2->A2_EST
		_cInsCli  := SA2->A2_INSCR

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		&&? Endereco de entrega do Fornecedor  ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		_cEndEnt := Alltrim(SA2->A2_END)
		_cCepEnt := Alltrim(SA2->A2_CEP)
		_cCidEnt := Alltrim(SA2->A2_MUN)
		_cEstEnt := SA2->A2_EST
		_cTelEnt := SA2->A2_TEL

	Else
		dbSelectArea("SA1")		&&Cadastro de Clientes
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		&&? Dados do cliente                   ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		&&? Endereco Cobranca                  ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If !Empty(SA1 ->A1_ENDCOB)
			_cEndCob := Alltrim(SA1 ->A1_ENDCOB)
			_cEndCob := _cEndCob + " - " + Alltrim(SA1 ->A1_BAIRROC) + ", CEP: " + Alltrim(SA1 ->A1_CEPC)
			_cMunCob := Alltrim (SA1 ->A1_MUNC)
			_cMunCob := _cMunCob + " - " + SA1 ->A1_ESTC
		EndIf

		&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		&&? Endereco Entrega                   ?
		&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Restaura a area salva              ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	RestArea(_aArea)

	Return

	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿞CDUPLIC  ? Autor ? Paulo Romualdo     ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Posiciona o SE1 - Contas a Receber 				          볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? SigaFat				                                      볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Pesquisa pelo Percentual de IRRF   ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Restaura areas salvas              ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	RestArea(_aArea)

	Return

	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿞CTRANSP  ? Autor ? Paulo Romualdo     ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Posiciona o SA4 - Redespacho e Transportadora			  볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? SigaFat				                                      볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&? Posiciona o SA4 Para Buscar a Transportadora e Redespacho     ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	dbSelectArea ("SA4")
	dbSeek (xFilial ("SA4") + SF2 -> F2_TRANSP)
	_cNomTra := SA4 -> A4_NOME
	_cCGCTra := SA4 -> A4_CGC
	_cEndTra := ALLTRIM(SA4 -> A4_END) + " - " + ALLTRIM(SA4->A4_BAIRRO)
	_cMunTra := SA4 -> A4_MUN
	_cEstTra := SA4 -> A4_EST
	_cInETra := SA4 -> A4_INSEST

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Restaura areas salvas              ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	Restarea(_aArea)

	Return

	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿞CCABEC   ? Autor ? Paulo Romualdo     ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Imprime Cabecalho da nota onde as mensagens serao impressas볍?
	굇?          ? no rodape                                                  볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? Programa principal                                         볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
	/*/

Static Function SCCabec()
	Local _cEndEmp:= _cCidEmp:=_cTelEmp:=_cFaxEmp:=Space(75)
	Local _cCepEmp:=_cHomePg:=_cEmail:=Space(75)
	If _lMensg
		_nM   := 1
		_nPag := 1
	else
		_nPag++
	endif

	_nLin := 1
	@ _nLin, 001 PSAY chr(27) + chr(67) + chr(64)
	@ _nLin, 010 PSAY _cImpComp

	_cTelEmp := "FONE: "+AllTrim(SM0->M0_TEL)
	_cFaxEmp := "FAX:  "+AllTrim(SM0->M0_FAX)

	@ _nLin, 145 PSAY _cNumNF
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Dados do cliente ou fornecedor - Parte 1                         ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&? Impressao das Parcelas                                           ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿞CIMPITM  ? Autor ? Paulo Romualdo     ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Imprime o(s) Item(ns) da NF								  볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? Programa principal                                         볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
	/*/
Static Function SCIMPITM
	_nLin     := 22
	_nContLi  := 0
	_lImpCont := .f.
	_xP := 0

	For _nK := 1 To Len (_aItens)

		If _lImpCont
			@ _nLin, 017 PSAY MemoLine (_aItens [_nK-1, 02],60, _nImpCont+1) Picture "@!S60"	&& Descr. Prod
		EndIf

		If _nContLi >= 22
			U_ImpAster()
			_xP := _xP + 1
			_lMensg := .F.
			SCCabec()
			_lMensg := .T.
			_nContLi := 0
			_nLin    := 25
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
					@ _nLin, 155 PSAY Transform(18, '@E 99')
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
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿔MPRODAPE ? Autor ? Paulo Romualdo     ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Imprime rodape da nota.                                    볍?
	굇?          ?                                                            볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? Programa principal                                         볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
	/*/
Static Function ImpRodape()

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&? Valor dos impostos.                                           ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	_nLin := 052
	@ _nLin, 010 PSAY _nBaseICM Picture "@E 999,999,999.99"		&& Base ICMS
	@ _nLin, 040 PSAY _nValIcm  Picture "@E 999,999,999.99"		&& Vlr. ICMS
	@ _nLin, 070 PSAY _nBICMRet Picture "@E 999,999,999.99"		&& Base de Calculo ICMS Retido
	@ _nLin, 110 PSAY _nVICMRet Picture "@E 999,999,999.99"		&& Vlr. ICMS Retido
	If SF2->F2_TIPO <> "I" .and. Len(_aItens) > 0
		@ _nLin, 145 PSAY _nValMerc - SF2->F2_BASEISS Picture "@E 999,999,999.99" && Vlr. Mercadorias (c/ ISS).Ab?lio/Rodrigo S/ ISS
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&? Dados da transportadora                                       ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	_nLin += 3
	If !Empty(_cNomTra)
		@ _nLin, 001 PSAY Alltrim (_cNomTra) Picture "@!S40"
	EndIf

	If _cTpFrete == "C"
		@ _nLin, 075 PSAY "1" &&85
	Else
		@ _nLin, 075 PSAY "2" &&85
	EndIf

	If !Empty(_cPlaca)
		&&@ _nLin, 090 PSAY _cPlaca Picture "@!S10"
		@ _nLin, 090 PSAY 'EKP-0390' Picture "@!S10"
	EndIf
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

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&? Peso Liquido, Peso Bruto, Especie, Volume                     ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	_nLin +=  2
	@ _nLin, 005 PSAY _cVolu1  Picture "9999999999"
	&&If !Empty(_cEspec1)
	If !Empty('CX')
		@ _nLin, 25 PSAY AllTrim('CX') Picture "@S10"
		&&@ _nLin, 019 PSAY AllTrim(_cEspec1) Picture "@S10"
	EndIf
	&&If !Empty(_cMarca)
	If !Empty('Teste')
		&&@ _nLin, 055 PSAY AllTrim(_cMarca) Picture "@S20"
		@ _nLin, 050 PSAY AllTrim('Teste') Picture "@S20"
	EndIf
	&&@ _nLin, 097 PSAY _nPBruto Picture "@E 999,999,999.99"
	&&@ _nLin, 097 PSAY _nPLiqui Picture "@E 999,999,999.99"
	@ _nLin, 110 PSAY 10 Picture "@E 999,999,999.99"
	@ _nLin, 145 PSAY 20 Picture "@E 999,999,999.99"

	_nLin += 3

	While _nM <= 21
		U_ImpMens(1) && Dados Adicionais
	EndDo

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&? Numero da Nota no Rodape                                      ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	_nLin := 74
	@ _nLin, 145 PSAY _cNumNF

	_nLin++
	@ _nLin, 000 PSAY ""

	SetPrc(0,0)

	Return()
	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿔MPASTER  ? Autor ? Paulo Romualdo     ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Imprime asteriscos se houver quebra de nota.               볍?
	굇?          ?                                                            볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? Programa principal                                         볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
	/*/
User Function ImpAster()
	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&쿣alor dos impostos.                                            ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	_nLin := 49
	@ _nLin, 016 PSAY "************"       && Base ICMS
	@ _nLin, 044 PSAY "**************"     && Vlr. ICMS
	@ _nLin, 070 PSAY "**************"     && Base de Calculo ICMS Retido
	@ _nLin, 098 PSAY "**********"         && Vlr. ICMS Retido
	If SF2->F2_TIPO <> "I"
		@ _nLin, 130 PSAY "**************" && Vlr. Mercadorias (c/ ISS).
	EndIf
	_nLin := _nLin + 2
	@ _nLin, 016 PSAY "**********"         && Val. Frete
	@ _nLin, 044 PSAY "**************"     && Val. Seguro
	@ _nLin, 070 PSAY "**************"     && Vlr. Despesas Acessorias
	@ _nLin, 098 PSAY "**************"     && Vlr. IPI
	If SF2->F2_TIPO <> "I"
		@ _nLin, 130 PSAY "**************" && Vlr. Bruto
	EndIf

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&쿏ados da transportadora                                        ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	_nLin := _nLin + 3
	@ _nLin, 004 PSAY "***************************"
	@ _nLin, 090 PSAY "*"
	@ _nLin, 098 PSAY "********"
	@ _nLin, 115 PSAY "**"
	@ _nLin, 125 PSAY "******************"

	_nLin := _nLin + 2
	@ _nLin, 004 PSAY "************************"
	@ _nLin, 078 PSAY "*****************"
	@ _nLin, 115 PSAY "**"
	@ _nLin, 125 PSAY "***************"

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&? Peso Liquido, Peso Bruto, Especie, Volume                     ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	_nLin := _nLin + 2
	@ _nLin, 006 PSAY "******"
	@ _nLin, 020 PSAY "***************"
	@ _nLin, 048 PSAY "***************"
	@ _nLin, 112 PSAY "*********"
	@ _nLin, 132 PSAY "*********"

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	&&? Numero da Nota no Rodape                                      ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
	_nLin := 063
	@ _nLin, 198 PSAY _cNumNF

	&&Soma-se sempre 6 para posicionar na proxima NF
	_nLin := 66
	@ _nLin,000 PSAY ""

	SetPrc(0,0)

	Return()

	/*/
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿔mpMens   ? Autor ?  Paulo Romualdo    ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Imprimir Dados Adicionais da NF. (Mensagem)                볍?
	굇?          ? necessario (caso nao existam).                             볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? Programa principal                                         볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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
	複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	굇?袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
	굇튔un뇙o    쿣ALIDPERG ? Autor ?  Paulo Romualdo    ? Data ?  03/07/08   볍?
	굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽?
	굇튒escri뇙o ? Verifica a existencia das perguntas criando-as caso seja   볍?
	굇?          ? necessario (caso nao existam).                             볍?
	굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽?
	굇튧so       ? Programa principal                                         볍?
	굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선?
	굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
	賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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

	dbSelectArea(_sAlias)

	Return()

	&&旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	&&?                         F  I   M                                 ?
	&&읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
