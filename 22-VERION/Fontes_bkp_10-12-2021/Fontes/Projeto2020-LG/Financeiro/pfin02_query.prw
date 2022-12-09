#Include "Rwmake.CH"
#Include "Protheus.ch"
#Include "Topconn.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFIN02    บAutor  ณSilverio Bastos     บ Data ณ  05/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera arquivo de Analise Financeira P/Natureza Financeira                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Verion               	                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function PFIN02()

Local aSays        := {}
Local aButtons     := {}
Local nOpca        := 0
Local cCadastro    := "Gera็ใo de planilha de Analise Financeira P/Natureza Financeira"
Local _cOldData    := dDataBase // Grava a database
Local cDestino     := cGetFile("Arquivos DBF |*.DBF","Selecione o Diret๓rio.",0,"C:\",.F.,GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY)

Private cPerg      := "PFIN02    "
Private _cArq      := "PFIN02.XLS"
Private CR         := Chr(13) + Chr(10)
Private _cFilSE5   := xFilial("SE5")
Private _aDatas    := {} // Matriz no formato [ data , campo ]
Private _aLegPer   := {} // legenda dos periodos
Private _aCpos     := {} // Campos de datas criados no TRB2
Private _nCampos   := 0 // numero de campos de data - len(_aCpos)
Private _nRecSaldo := 0 // Recno da linha de saldo
Private _nSaldoIni := 0
Private _aRegSimul := {} // matriz com os recnos do TRB1 e do SZ6, respectivamente
Private cArqTrb1   := CriaTrab(Nil,.f.) //"PFIN021"
Private cArqTrb2   := CriaTrab(Nil,.f.) //"PFIN022"
Private cArqTrb3   := CriaTrab(Nil,.f.) //"PFIN023"
Private _aGrpSint  := {}
Private _nDiasPer  := 0

ValidPerg()

AADD(aSays,"Este Programa gera Planilha com os Dados para o Anแlise Financeira P/Natureza Financeira de acordo com os ")
AADD(aSays,"Parโmetros fornecidos pelo Usuแrio. O Arquivo gerado pode ser aberto de forma ")
AADD(aSays,"automแtica pelo Excel.")
AADD(aSays,"Movimentos ap๓s a data de refer๊ncia sใo considerados previstos e anteriores ")
AADD(aSays,"ou iguais a ela, realizados.")
AADD(aSays,"")
AADD(aSays," ")
AADD(aButtons,{5,.t.,{|| Pergunte(cPerg,.t.)}})
AADD(aButtons,{1,.t.,{|o| nOpca:= 1,o:oWnd:End()}})
AADD(aButtons,{2,.t.,{|o| o:oWnd:End()}})

FormBatch(cCadastro,aSays,aButtons)

// +-------------------------------+
// | Se confirmado o Processamento |
// +-------------------------------+

If nOpcA == 1

	Pergunte(cPerg,.f.)

	_dDataIni   := mv_par01										// Data inicial
	_dDataFim   := mv_par02										// Data Final
	_dDtRef     := mv_par03										// Data de referencia
	_lPedCompra := mv_par04 == 1								// Considera pedido de compras
	_lPedVenda  := mv_par05 == 1								// Considera pedido de vendas
	_lVencRec   := mv_par06 == 1 .Or. mv_par06 == 3		// Considera Vencidos a receber
	_lVencPag   := mv_par06 == 2 .Or. mv_par06 == 3		// Considera Vencidos a pagar
	_nDiasPer   := Max(1,mv_par07)							// Quantidade de dias por periodo (minimo de 1 dia)
	_lSelBancos := mv_par08 == 1								// Seleciona Bancos

	// +---------------------------------------------------------------+
	// | Faz Consist๊ncias iniciais para permitir a Execu็ใo da Rotina |
	// +---------------------------------------------------------------+

	If !VldParam() .Or. !AbreArq()
		Return
	EndIf

	dDataBase := _dDtRef // muda a database para a data de referencia, para calculo de saldos

	Processa({|| ProcBco(_lSelBancos)},"Processando Bancos") // Calcula saldos bancarios iniciais

	Processa({|| PFin02Real()},"Analise Financeira P/Natureza Financeira Realizado")

	// +----------------------------+
	// | Processa Tํtulos em Aberto |
	// +----------------------------+

	Processa({|| PFIN02TIT()},"Tํtulos em aberto")

	// +--------------------+
	// | Processa Previs๕es |
	// +--------------------+

	If mv_par09 == 1
		Processa({|| PFIN02PREV()},"Processando Previs๕es")
	EndIf

	// +--------------------------------+
	// | Processa os Pedidos de Compras |
	// +--------------------------------+

	If _lPedCompra
		Processa({|| PFIN02PC()},"Pedidos de compra")
	EndIf

	// +--------------------------------+
	// | Processa os Pedidos de Compras |
	// +--------------------------------+

	If _lPedVenda
		Processa({|| PFIN02PV()},"Pedidos de Venda")
	EndIf

	Processa({||PFIN02SINT()},"Gerando arquivo sint้tico.") // *** Funcao de gravacao do arquivo sintetico ***

	MontaTela()

	dDataBase := _cOldData // restaura a database
 
	// +---------------------------------------------------------------+
	// | Grava o Arquivo DBF que serแ utilizado pela Planilha Dinโmica |
	// +---------------------------------------------------------------+

	cDestino1 := cDestino + "TRB1.DBF"
	cArqTrb1  += ".DBF"
	Copy File &cArqTrb1 to (cDestino1)

	If File(cDestino1)
		MsgInfo("Arquivo gerado com sucesso!")
	Else
		MsgStop("Nใo foi possํvel gravar o arquivo no caminho indicado, tente novamente")	
	EndIf

	cDestino3 := cDestino+"BANCOS.DBF"
	cArqTrb3 += ".DBF"
	Copy file &cArqTrb3 to (cDestino3)

	If File(cDestino3)
		MsgInfo("Arquivo gerado com sucesso!")
	Else
		MsgStop("Nใo foi possํvel gravar o arquivo no caminho indicado, tente novamente")	
	EndIf

	TRB1->(dbclosearea())
	TRB11->(dbclosearea())
	TRB2->(dbclosearea())
	BANCOS->(dbclosearea())
EndIf

Return
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROCBCO   บAutor  ณSilverio Bastos   บ Data ณ  05/02/10     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o saldo inicial dos bancos e define bancos usados บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcBco(_lSelBco)

Local cMarca      := GetMark()
Local aCampos     := {{"A6_OK"     ,"C",02,0},;
							 {"A6_COD"    ,"C",03,0},;
							 {"A6_AGENCIA","C",05,0},;
							 {"A6_NUMCON" ,"C",10,0},;
							 {"A6_NREDUZ" ,"C",15,0},;
							 {"A6_SALATU" ,"N",17,2}}
Local aCampos2    := {{"A6_OK"     ,,"  "     ,""},;
							 {"A6_COD"    ,,"Banco"  ,"@X"},;
							 {"A6_AGENCIA",,"Agencia","@X"},;
							 {"A6_NUMCON" ,,"Conta"  ,"@X"},;
							 {"A6_NREDUZ" ,,"Nome"   ,"@X"},;
							 {"A6_SALATU" ,,"Saldo"  ,"@E 9,999,999,999.99"}}
Local oDlg
Local _cQuery     := ""
local lInverte    := .f.
Local _lE8SalReco := SE8->(Fieldpos("E8_SALRECO")) > 0 
Local _nSaldo     := 0

SA6->(dbsetorder(1)) // A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
SE8->(dbsetorder(1)) // E8_FILIAL + E8_BANCO + E8_AGENCIA + E8_CONTA + DTOS(E8_DTSALAT)
	
cArqTrb3 := CriaTrab(aCampos,.t.)
DbUseArea(.t.,,cArqTrb3,"BANCOS",.t.,.f.)
_Ind3    := Criatrab(Nil,.f.)
IndRegua("BANCOS",_ind3,"A6_COD + A6_AGENCIA + A6_NUMCON",,,"Indexando Bancos")

DbSelectArea("SA6")
ProcRegua(Reccount())
	
DbGoTop()

While !Eof()
		IncProc("Processando Banco: " + SA6->A6_COD)
		
		SE8->(DbSeek( xFilial("SE8") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON + DTOS(_dDataIni),.t.))
		SE8->(DbSkip(-1))
		
		If SE8->E8_FILIAL == xFilial("SE8") .and. SE8->(!eof())  .and. SE8->(!bof()) .and. ;
			SE8->(E8_BANCO + E8_AGENCIA + E8_CONTA) == SA6->(A6_COD + A6_AGENCIA + A6_NUMCON)
			_nSaldo := SE8->E8_SALATUA // iif(_lE8SalReco, SE8->E8_SALRECO , SE8->E8_SALATUA)
		Else
			_nSaldo := 0
		EndIf                      

		While !RecLock("BANCOS",.t.)
		Enddo
		BANCOS->A6_COD 		:= SA6->A6_COD
		BANCOS->A6_AGENCIA 	:= SA6->A6_AGENCIA
		BANCOS->A6_NUMCON 	:= SA6->A6_NUMCON
		BANCOS->A6_NREDUZ 	:= SA6->A6_NREDUZ
		BANCOS->A6_SALATU 	:= _nSaldo
		
		If SA6->A6_FLUXCAI <> 'N'
			BANCOS->A6_OK := cMarca
		EndIf
		
		MsUnLock()

		DbSelectArea("SA6")
		DbSkip()
Enddo
	
If _lSelBco
	BANCOS->(DbGotop())
	Define MsDialog oDlg Title "Selecione os Bancos que deverใo ser considerados" From 009,000 To 030,063 Of oMainWnd
	oMark := MsSelect():New("BANCOS","A6_OK","",aCampos2,@lInverte,@cMarca,{20,2,140,248})
	Activate MsDialog oDlg On Init EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 2}) Centered
EndIf

Return
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFIN02REALบAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o Analise Financeira P/Natureza Financeira realizado                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PFIN02REAL()

Local _cQrySE5 := ""
Local _cFilSE2 := xFilial("SE2")
Local _cFilSE5 := xFilial("SE5")
Local _cFilSED := xFilial("SED")
Local _cFilSEF := xFilial("SEF")
Local _cNatureza

SE2->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
SEF->(dbsetorder(1)) // EF_FILIAL + EF_BANCO + EF_AGENCIA + EF_CONTA + EF_NUM
SA1->(dbsetorder(1)) // A1_FILIAL + A1_COD + A1_LOJA
SA2->(dbsetorder(1)) // A2_FILIAL + A2_COD + A2_LOJA
	
ChkFile("SE5",.F.,"SE5Q") // Alias dos movimentos bancarios
IndRegua("SE5Q",CriaTrab(NIL,.f.),"DTOS(E5_DTDISPO) + E5_NATUREZ",,,"Selecionando Registros...")
	
ChkFile("SE5",.F.,"SE5_EC") // Alias para estorno de cheques
IndRegua("SE5_EC",CriaTrab(NIL,.f.),"E5_FILIAL + E5_BANCO + E5_AGENCIA + E5_CONTA + E5_NUMCHEQ",,,"Selecionando Registros...")
                
/*DbSelectArea("SE5")
_cQrySE5 := "Select SE5.* "
_cQrySE5 += "From " + RetSqlName("SE5") + " SE5 "
_cQrySE5 += "Where SE5.E5_DTDISPO >= '" + DTOS(mv_par01) + "' And SE5.E5_DTDISPO <= '" + DTOS(mv_par02) + "' "
_cQrySE5 +=   "And SE5.E5_DATA    >= SE5.E5_VENCTO And Right(ltrim(SE5.E5_NUMCHEQ),1) <> '*' And SE5.E5_SITUACA <> 'C' "
_cQrySE5 +=   "And SE5.E5_VALOR   > 0 And SE5.E5_TIPODOC Not In ('DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','BA') "
_cQrySE5 +=   "And Left(SE5.E5_NUMCHEQ,1) <> '*' And Left(SE5.E5_DOCUMEN,1) = '*' And SE5.E5_TIPODOC = 'EC' And SE5.D_E_L_E_T_ <> '*' "
_cQrySE5 += "Order by SE5.E5_FILIAL,SE5.E5_DTDISPO,SE5.E5_NATUREZ "

DbSelectArea("SE5")

If Select("SE5Q") > 0
	DbSelectArea("SE5Q")
	DbCloseArea()
EndIf

TcQuery _cQrySE5 New Alias "SE5Q"

TcSetField("SE5Q","E5_VENCTO" ,"D")  
TcSetField("SE5Q","E5_DTDISPO","D")*/

DbSelectArea("SE5Q")

ProcRegua(RecCount())

DbSeek(DTOS(_dDataIni),.t.)

//DbGoTop()

While !Eof() .And. DTOS(SE5Q->E5_DTDISPO) <= DTOS(_dDtRef) .And. SE5Q->E5_FILIAL == _cFilSE5
		_cDtMovim := Strzero(Day(SE5Q->E5_DTDISPO),2) + "/" + Strzero(Month(SE5Q->E5_DTDISPO),2) + "/" + Strzero(Year(SE5Q->E5_DTDISPO),4)

		IncProc("Processando Data (SE5): " + _cDtMovim + ", Natureza: " + SE5Q->E5_NATUREZ)

		If BANCOS->(!DbSeek(SE5Q->(E5_BANCO + E5_AGENCIA + E5_CONTA))) .Or. Empty(BANCOS->A6_OK)
			SE5Q->(DbSkip())
			Loop
		EndIf

		If (SE5Q->E5_VENCTO > SE5Q->E5_DATA) .Or.;
			(Right(Alltrim(SE5Q->E5_NUMCHEQ),1) == '*') .Or.;
			(SE5Q->E5_SITUACA == 'C') .Or.;
			(SE5Q->E5_VALOR == 0) .Or.;
			(SE5Q->E5_TIPODOC $ 'DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL/BA') .Or.;
			(SE5Q->E5_MOEDA $ "C1/C2/C3/C4/C5" .And. Empty(SE5Q->E5_NUMCHEQ) .And. !(SE5Q->E5_TIPODOC $ "TR#TE")) .Or.;
			(SE5Q->E5_TIPODOC $ "TR/TE" .And. Empty(SE5Q->E5_NUMERO) .And. !(SE5Q->E5_MOEDA $ "R$/DO/TB/TC/CH")) .Or.;
			(SE5Q->E5_TIPODOC $ "TR/TE" .And. (Substr(SE5Q->E5_NUMCHEQ,1,1) == "*" .Or. Substr(SE5Q->E5_DOCUMEN,1,1) == "*" )) .Or.;
			(SE5Q->E5_MOEDA == "CH" .And. IsCaixaLoja(SE5Q->E5_BANCO)) .Or.;
			(!Empty( SE5Q->E5_MOTBX ) .And. !MovBcoBx( SE5Q->E5_MOTBX )) .Or.;
			(left(SE5Q->E5_NUMCHEQ,1) == "*" .Or. left(SE5Q->E5_DOCUMEN,1) == "*") .Or.;
			 SE5Q->E5_TIPODOC == "EC"  

/*		If (SE5Q->E5_MOEDA $ "C1/C2/C3/C4/C5" .And. Empty(SE5Q->E5_NUMCHEQ) .And. !(SE5Q->E5_TIPODOC $ "TR#TE"))	.Or.;
			(SE5Q->E5_TIPODOC $ "TR/TE" .And. Empty(SE5Q->E5_NUMERO) .And. !(SE5Q->E5_MOEDA $ "R$/DO/TB/TC/CH")) 	.Or.;
			(SE5Q->E5_TIPODOC $ "TR/TE" .And. (Substr(SE5Q->E5_NUMCHEQ,1,1) == "*" .Or. Substr(SE5Q->E5_DOCUMEN,1,1) == "*" )) .Or.;
			(SE5Q->E5_MOEDA == "CH"   .And. IsCaixaLoja(SE5Q->E5_BANCO)) .Or.;
			(!Empty( SE5Q->E5_MOTBX ) .And. !MovBcoBx( SE5Q->E5_MOTBX ))*/

			DbSelectArea("SE5Q")
			Dbskip()
			Loop
		EndIf

		If SED->(DbSeek(_cFilSED + SE5Q->E5_NATUREZ))
			_cNatureza := SED->ED_DESCRIC
		Else
			_cNatureza := "NATUREZA NAO DEFINIDA"
		EndIf

		If SE5Q->E5_RECPAG == "R"

			If SA1->(DbSeek(xFilial("SA1") + SE5Q->E5_CLIFOR + SE5Q->E5_LOJA),.f.)
				_Razao := SUBSTR(SA1->A1_NOME,1,30)
			Else
				_Razao := ""
			EndIf    

		Else

			If SA2->(DbSeek(xFilial("SA2") + SE5Q->E5_CLIFOR + SE5Q->E5_LOJA),.f.)
				_Razao := SUBSTR(SA2->A2_NOME,1,30)
			Else
				_Razao := ""
			EndIf    

		EndIf    

		If Alltrim(SE5Q->E5_TIPODOC) <> "CH"

			While !RecLock("TRB1",.t.)
			Enddo
			TRB1->DATAMOV   := DataValida(SE5Q->E5_DTDISPO)
			TRB1->NATUREZA  := SE5Q->E5_NATUREZ
			TRB1->DESC_NAT  := _cNatureza
			TRB1->CLIFOR    := SE5Q->E5_CLIFOR
			TRB1->LOJA      := SE5Q->E5_LOJA
			TRB1->RAZAO     := _Razao
			TRB1->HISTORICO := SE5Q->E5_HISTOR
			TRB1->VALOR     := IIF(SE5Q->E5_RECPAG == "R",SE5Q->E5_VALOR,(-1) * SE5Q->E5_VALOR)
			TRB1->RECPAG    := SE5Q->E5_RECPAG
			TRB1->TIPO      := "R"
			TRB1->ORIGEM    := "MB"
			TRB1->GRUPONAT  := RetGrupo(TRB1->NATUREZA)
			TRB1->DESCGRUP  := Posicione("SZ5",1,xFilial("SZ5") + TRB1->GRUPONAT,"Z5_DESCRI")
			TRB1->CAMPO     := RetCampo(TRB1->DATAMOV)
			MsUnlock()

		Else // Se for um cheque aglutinado - pesquisa pelos titulos pagos no cheque
			_nRegQry := 0

			If SE5_EC->(DbSeek(SE5Q->(E5_FILIAL + E5_BANCO + E5_AGENCIA + E5_CONTA + E5_NUMCHEQ),.f.))

				While SE5_EC->(!Eof()) .And. SE5Q->(E5_FILIAL + E5_BANCO + E5_AGENCIA + E5_CONTA + E5_NUMCHEQ) == SE5_EC->(E5_FILIAL + E5_BANCO + E5_AGENCIA + E5_CONTA + E5_NUMCHEQ)

						If SE5_EC->E5_SEQ == SE5Q->E5_SEQ .And. SE5_EC->E5_TIPODOC == "EC" .And. SE5_EC->(Recno()) > SE5Q->(Recno())
							_nRegQry++
						EndIf

						SE5_EC->(DbSkip())
				Enddo

			EndIf

			If _nRegQry > 0
				SE5Q->(dbskip())
				Loop
			EndIf

			_cChave := _cFilSEF + SE5Q->E5_BANCO + SE5Q->E5_AGENCIA + SE5Q->E5_CONTA + SE5Q->E5_NUMCHEQ

			If SEF->(Dbseek(_cChave),.f.)

				While SEF->(!Eof()) .And. SEF->EF_FILIAL + SEF->EF_BANCO + SEF->EF_AGENCIA + SEF->EF_CONTA + SEF->EF_NUM == _cChave

						If !Empty(SEF->EF_TITULO) .And. SE2->(DbSeek(_cFilSE2 + SEF->EF_PREFIXO + SEF->EF_TITULO + SEF->EF_PARCELA + SEF->EF_TIPO + SEF->EF_FORNECE + SEF->EF_LOJA,.f.))

							If SED->(DbSeek(_cFilSED + SE2->E2_NATUREZ,.f.))
								_cNatureza := SED->ED_DESCRIC
							Else
								_cNatureza := "NATUREZA NAO DEFINIDA"
							EndIf

							If SA2->(DbSeek(xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA,.f.))
								_Razao := SUBSTR(SA2->A2_NOME,1,30)
							Else
								_Razao := ""
							EndIf    

							While !RecLock("TRB1",.t.)
							Enddo
							TRB1->DATAMOV   := DataValida(SE5Q->E5_DTDISPO)
							TRB1->NATUREZA  := SE2->E2_NATUREZ
							TRB1->DESC_NAT  := _cNatureza //GetAdvFVal("SED","ED_DESCRIC",_cFilSED+SE2->E2_NATUREZ,1,"NATUREZA NAO DEFINIDA")
							TRB1->CLIFOR    := SE2->E2_FORNECE
							TRB1->LOJA      := SE2->E2_LOJA
							TRB1->RAZAO     := _Razao   
							TRB1->HISTORICO := "PAGAMENTO TITULO " + Alltrim(SE2->E2_PREFIXO) + " " + SE2->E2_NUM + " " + Alltrim(SE2->E2_PARCELA) + " " + SE2->E2_TIPO
							TRB1->VALOR     := iif(SE5Q->E5_RECPAG == "R" , SEF->EF_VALOR , -SEF->EF_VALOR)
							TRB1->RECPAG    := SE5Q->E5_RECPAG
							TRB1->TIPO      := "R"
							TRB1->ORIGEM    := "MB"
							TRB1->GRUPONAT  := RetGrupo(TRB1->NATUREZA)
							TRB1->DESCGRUP  := Posicione("SZ5",1,xFilial("SZ5") + TRB1->GRUPONAT,"Z5_DESCRI")
							TRB1->CAMPO     := RetCampo(TRB1->DATAMOV)
							MsUnlock()

						EndIf

						DbSelectArea("SEF")
						Dbskip()
				Enddo

			EndIf

		EndIf

		SE5Q->(DbSkip())
Enddo

SE5Q->(DbCloseArea())
//QUERY->(DbCloseArea())
SE5_EC->(DbCloseArea())
	
Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณPFIN02TIT บAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณProcessa Titulos em aberto                                  บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/

Static Function PFIN02TIT()

	Local _cFilSE1 := xFilial("SE1")
	Local _cFilSE2 := xFilial("SE2")
	Local _cFilSED := xFilial("SED")
	local _cQuery := ""
	local _nSaldo := 0
	local _lNatFluxo := SED->(fieldpos("ED_XFLUXO")) > 0
	
	SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
	
	// TITULOS A RECEBER EM ABERTO
	ChkFile("SE1",.F.,"QUERY") // Alias dos titulos a receber

DbSelectArea("QUERY")
DbSetOrder(7) // E1_FILIAL + DTOS(E1_VENCREA) + E1_NOMCLI + E1_PREFIXO + E1_NUM + E1_PARCELA

ProcRegua(RecCount())

DbSeek(_cFilSE1 + IIF(_lVencRec,"",DTOS(_dDtRef)),.t.)

While !Eof() .and. SE1->E1_FILIAL == _cFilSE1 .and. QUERY->E1_VENCREA <= _dDataFim
		_cDtMovim := Strzero(Day(QUERY->E1_VENCREA),2) + "/" + Strzero(Month(QUERY->E1_VENCREA),2) + "/" + Strzero(Year(QUERY->E1_VENCREA),4)

		IncProc("Processando Data (SE1): " + _cDtMovim + ", Cliente: " + Alltrim(QUERY->E1_NOMCLI))

	//	if 	substr(QUERY->E1_TIPO,3,1) == "-" .or. ;
	//		!(QUERY->E1_SALDO > 0 .OR. dtos(QUERY->E1_BAIXA) > dtos(_dDtRef)) .or. ;
		if	QUERY->E1_EMISSAO > _dDataFim
			QUERY->(dbskip())
			loop
		endif
		
		if SED->(dbseek(_cFilSED+QUERY->E1_NATUREZ))
			_cNatureza := SED->ED_DESCRIC
		else
			_cNatureza := "NATUREZA NAO DEFINIDA"
			if _lNatFluxo .and. SED->ED_XFLUXO == "N"
				QUERY->(dbskip())
				loop
			endif
		endif
		
		_nSaldo :=_CalcSaldo("SE1", QUERY->(recno()))

		if SA1->(dbseek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
   		_Razao := SUBSTR(SA1->A1_NOME,1,30)
		else
			_Razao := ""
	   endif    
		
		if _nSaldo <> 0
			RecLock("TRB1",.T.)
			TRB1->DATAMOV	:= max(DataValida(QUERY->E1_VENCREA), DataValida(_dDtRef)) // A data de previsao tem que ser, no minimo, a data de referencia
			TRB1->NATUREZA	:= QUERY->E1_NATUREZ
			TRB1->DESC_NAT	:= _cNatureza
			TRB1->CLIFOR	:= SE1->E1_CLIENTE
  			TRB1->LOJA		:= SE1->E1_LOJA
			TRB1->RAZAO		:= _Razao   
			TRB1->VALOR		:= _nSaldo
			TRB1->TIPO		:= "P"
			TRB1->RECPAG	:= "R"
			TRB1->ORIGEM	:= "CR"
			TRB1->HISTORICO	:= "Tit. Receber: " + ;
			alltrim(QUERY->E1_PREFIXO + " " + QUERY->E1_NUM + " " + QUERY->E1_PARCELA + " " + QUERY->E1_TIPO) + ;
			iif(!empty(QUERY->E1_HIST) , " - " + QUERY->E1_HIST ,"")
			TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
			TRB1->DESCGRUP := Posicione("SZ5",1,xFilial("SZ5")+TRB1->GRUPONAT,"Z5_DESCRI")
			TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
			TRB1->BANCO		:= SE1->E1_PORTADO
			TRB1->BANCOS	:= Posicione("SA6",1,xFilial("SA6")+TRB1->BANCO+TRB1->AGENC+TRB1->CONTA,"A6_NREDUZ")
			TRB1->AGENC		:= SE1->E1_AGEDEP
			TRB1->CONTA		:= SE1->E1_CONTA
			TRB1->LIMBCO	:= Posicione("SA6",1,xFilial("SA6")+TRB1->BANCO+TRB1->AGENC+TRB1->CONTA,"A6_LIMCRED") 
			TRB1->BANCOS	:= Posicione("SA6",1,xFilial("SA6")+TRB1->BANCO+TRB1->AGENC+TRB1->CONTA,"A6_NREDUZ")
			MsUnlock()
		endif
		
		QUERY->(dbskip())
	enddo
	
	QUERY->(dbclosearea())
	
	// TITULOS A PAGAR EM ABERTO
	ChkFile("SE2",.F.,"QUERY") // Alias dos titulos a pagar
	QUERY->(dbsetorder(3)) // E2_FILIAL + DTOS(E2_VENCREA) + E2_NOMFOR + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO
	QUERY->(dbseek(_cFilSE2+iif(_lVencRec,"",dtos(_dDtRef)),.T.))
	while QUERY->(!eof()) .and. SE2->E2_FILIAL == _cFilSE2 .and. QUERY->E2_VENCREA <= _dDataFim
		
   //	if 	substr(QUERY->E2_TIPO,3,1) == "-" .or. ;
	//	!(QUERY->E2_SALDO > 0 .OR. dtos(QUERY->E2_BAIXA) > dtos(_dDtRef)) .or. ;
	  if	QUERY->E2_EMISSAO > _dDataFim
			QUERY->(dbskip())
			loop
		endif
		
		if SED->(dbseek(_cFilSED+QUERY->E2_NATUREZ))
			_cNatureza := SED->ED_DESCRIC
		else
			_cNatureza := "NATUREZA NAO DEFINIDA"
			if _lNatFluxo .and. SED->ED_XFLUXO == "N"
				QUERY->(dbskip())
				loop
			endif
		endif
		
		_nSaldo :=_CalcSaldo("SE2", QUERY->(recno()))

		if SA2->(dbseek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
   		_Razao := SUBSTR(SA2->A2_NOME,1,30)
		else
			_Razao := ""
	   endif    
		
		if _nSaldo <> 0
			RecLock("TRB1",.T.)
			TRB1->DATAMOV	:= max(DataValida(QUERY->E2_VENCREA), DataValida(_dDtRef)) // A data de previsao tem que ser, no minimo, a data de referencia
			TRB1->NATUREZA	:= QUERY->E2_NATUREZ
			TRB1->DESC_NAT	:= _cNatureza
   		TRB1->CLIFOR	:= SE2->E2_FORNECE
  			TRB1->LOJA		:= SE2->E2_LOJA
			TRB1->RAZAO		:= _Razao   
			TRB1->VALOR		:= _nSaldo
			TRB1->TIPO		:= "P"
			TRB1->RECPAG	:= "P"
			TRB1->ORIGEM	:= "CP"
			TRB1->HISTORICO	:= "Tit. Pagar: " + ;
			alltrim(QUERY->E2_PREFIXO + " " + QUERY->E2_NUM + " " + QUERY->E2_PARCELA + " " + QUERY->E2_TIPO) + ;
			iif(!empty(QUERY->E2_HIST) , " - " + QUERY->E2_HIST ,"")
			TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
			TRB1->DESCGRUP := Posicione("SZ5",1,xFilial("SZ5")+TRB1->GRUPONAT,"Z5_DESCRI")
			TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
			MsUnlock()
		endif
		
		QUERY->(dbskip())
	enddo
	
	QUERY->(dbclosearea())
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณPFIN02PREVบAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณProcessa Previsoes do Analise Financeira P/Natureza Financeira                        บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/

Static function PFIN02PREV()

	local _cQuery := ""
	local _nSaldo := 0
	
	SZ6->(dbsetorder(2)) // Z6_FILIAL + dtos(Z6_DATA) + Z6_GRUPO
	
	SZ6->(dbseek(xFilial("SZ6")+dtos(_dDtRef),.T.))

ProcRegua(RecCount())

While SZ6->(!Eof()) .And. DTOS(SZ6->Z6_DATA) <= DTOS(_dDataFim)
		_cDtMovim := Strzero(Day(SZ6->Z6_DATA),2) + "/" + Strzero(Month(SZ6->Z6_DATA),2) + "/" + Strzero(Year(SZ6->Z6_DATA),4)

		IncProc("Processando Data (SZ6): " + _cDtMovim + ", Grupo: " + Alltrim(SZ6->Z6_GRUPO))
		
		While !RecLock("TRB1",.t.)
		Enddo
		TRB1->DATAMOV	:= SZ6->Z6_DATA
		TRB1->DESC_NAT	:= "SIMULACAO"
		TRB1->HISTORICO	:= SZ6->Z6_HIST
		TRB1->VALOR		:= iif(SZ6->Z6_RECPAG == "P" , -(SZ6->Z6_VALOR) , SZ6->Z6_VALOR)
		TRB1->RECPAG	:= SZ6->Z6_RECPAG
		TRB1->GRUPONAT 	:= SZ6->Z6_GRUPO
		TRB1->DESCGRUP := Posicione("SZ5",1,xFilial("SZ5")+TRB1->GRUPONAT,"Z5_DESCRI")
		TRB1->CAMPO		:= RetCampo(SZ6->Z6_DATA) 
		TRB1->BANCO 	:= SZ6->Z6_BANCO
		TRB1->AGENC 	:= SZ6->Z6_AGENC
		TRB1->CONTA 	:= SZ6->Z6_CONTA
		TRB1->BANCOS 	:= SZ6->Z6_NREDUZ
		TRB1->LIMBCO	:= Posicione("SA6",1,xFilial("SA6")+TRB1->BANCO+TRB1->AGENC+TRB1->CONTA,"A6_LIMCRED") 
		TRB1->SIMULADO	:= "S"
		MsUnlock()
		
		AADD(_aRegSimul, {TRB1->(recno()), SZ6->(recno())})
		
		SZ6->(DbSkip())
Enddo
	
Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ_CalcSaldoบAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Calcula o saldo do titulo na data de referencia            บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/

	static function _CalcSaldo(_cAlias, _nRecno)
	local _nSaldo := 0
	
	if _cAlias == "SE1"
		
		SE1->(dbgoto(_nRecno))
		
		dbselectarea("SE1")
		
		_nSaldo	:= SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,;
		SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,;
		_dDtRef,_dDtRef,SE1->E1_LOJA,_cFilSE5)
		
		dbselectarea("SE1")
		
		_nSaldo -= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,;
		_dDtRef,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_FILIAL)
		
		if SE1->E1_TIPO $ (MV_CRNEG + "/" + MVRECANT) // O normal de um titulo a receber e ser positivo
			_nSaldo := -1 * _nSaldo
		endif
		
	else
		
		SE2->(dbgoto(_nRecno))
		
		dbselectarea("SE2")
		
		_nSaldo	:= SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
		SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,1,;
		_dDtRef,_dDtRef,SE2->E2_LOJA,_cFilSE5)
		
		dbselectarea("SE2")
		
		_nSaldo -= SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",1,;
		_dDtRef,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_FILIAL)
		
		if !(SE2->E2_TIPO $ (MV_CPNEG + "/" + MVPAGANT)) // O normal de um titulo a pagar e ser negativo
			_nSaldo := -1 * _nSaldo
		endif
		
	endif
	
	return(_nSaldo)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณPFIN02PC  บAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณProcessa  Pedidos de compra                                 บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function PFIN02PC()
	local _cQuery 		:= ""
	local _aVencimentos	:= {} // Matriz no formato {Data de vencimento, natureza ,valor, numero do pedido de compra}
	local _aparcelas	:= {}
	local _nValor       := 0
	local _nValIPI      := 0
	local _nPos			:= 0
	local _nConta		:= 0
	local _lNatSC7		:= SC7->(fieldpos("C7_NATUREZ")) > 0
	
	
	cQuery := " SELECT * FROM "+RetSqlName("SC7")+" C7, "+RetSqlName("SE4")+" E4"
	cQuery += " WHERE E4_CODIGO = C7_COND "
	cQuery += " AND C7_QUJE < C7_QUANT AND C7_RESIDUO <> 'S'  AND C7_FLUXO <> 'N' AND C7.D_E_L_E_T_ <> '*'
	
	MemoWrit("PFIN02C7.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
	TcSetField("TRB","C7_DATPRF","D")
	
	COUNT TO nRecCount
	//CASO TENHA DADOS
	If nRecCount = 0
		Return
	EndIf
//	SetRegua(nRecCount)
	dbSelectArea("TRB")
	dbGoTop()
	
	while !eof()
		// Considera o TES do Pedido de Compras e, se ele estiver vazio, considera o do Produto
		cB1Tes := Posicione("SB1",1,xFilial("SB1")+TRB->C7_PRODUTO,"B1_TE")
		_cTES := iif(!empty(TRB->C7_TES), TRB->C7_TES, cB1Tes)
		
		_lTES := !empty(_cTES)
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		
		if _lTES .and. SF4->(dbseek(xFilial()+_cTES))
			if SF4->F4_DUPLIC == "N"
				TRB->(dbskip())
				loop
			endif
		endif
		
		_dDtEnt := Iif( TRB->C7_DATPRF < _dDtRef, _dDtRef, DataValida(TRB->C7_DATPRF))
		
		_nValPC := (1+TRB->E4_ACRSFIN/100) * ((TRB->C7_QUANT-TRB->C7_QUJE)/TRB->C7_QUANT) * (TRB->C7_TOTAL - TRB->C7_VLDESC)
		
		_nValor := iif(str(TRB->C7_MOEDA,1,0) <> "1",xMoeda(_nValPC,TRB->C7_MOEDA,1,_dDtEnt) ,_nValPC)
		if TRB->C7_IPI > 0 .and. (!_lTES .or. SF4->F4_IPI <> "N")
			_nValIPI := (TRB->C7_IPI/100) * _nValor
			if _lTES .and. SF4->F4_BASEIPI > 0
				_nValIPI *= (SF4->F4_BASEIPI/100)
			elseif SF4->F4_IPI == "R"
				_nValIPI := _nValIPI/2
			endif
		endif
		_nValor += _nValIPI
		
		_aParcelas := Condicao(_nValor,TRB->C7_COND,_nValIpi,_dDtEnt)
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+TRB->C7_FORNECE+TRB->C7_LOJA)
		
		_cNatureza := if(_lNatSC7 .and. !empty(TRB->C7_NATUREZ) , TRB->C7_NATUREZ, SA2->A2_NATUREZ)
		
		for _nConta := 1 to len(_aParcelas)
			_nPos := Ascan(_aVencimentos,{|x| x[1]==_aParcelas[_nConta,1] .and. x[2]==_cNatureza .and. x[4]==TRB->C7_NUM})
			if _nPos == 0
				aadd(_aVencimentos, {_aParcelas[_nConta,1],_cNatureza,_aParcelas[_nConta,2],TRB->C7_NUM,TRB->C7_FORNECE,TRB->C7_LOJA})
			else
				_aVencimentos[_nPos,3] += _aParcelas[_nConta,2]
			endif
			
		next _nConta
		
		TRB->(dbskip())
		
	enddo
	TRB->(dbCloseArea())
	
	for _nConta := 1 to len(_aVencimentos)  
		if _aVencimentos[_nConta,1] <= _dDataFim
		   
    		if SA2->(dbseek(xFilial("SA2")+_aVencimentos[_nConta,5]+_aVencimentos[_nConta,6]))
       		_Razao := SUBSTR(SA2->A2_NOME,1,30)
		   else
			   _Razao := ""
	      endif    
		   
			RecLock("TRB1",.T.)
			TRB1->DATAMOV	:= DataValida(_aVencimentos[_nConta,1])
			TRB1->NATUREZA	:= _aVencimentos[_nConta,2]
            TRB1->CLIFOR	:= _aVencimentos[_nConta,5]
  			TRB1->LOJA		:= _aVencimentos[_nConta,6]
			TRB1->RAZAO		:= _Razao   
			TRB1->HISTORICO	:= "PEDIDO DE COMPRA " + _aVencimentos[_nConta,4]
			TRB1->VALOR		:= -_aVencimentos[_nConta,3]
			TRB1->RECPAG	:= "P"
			TRB1->TIPO		:= "P"
			TRB1->ORIGEM	:= "PC"
			TRB1->GRUPONAT 	:= RetGrupo(TRB1->NATUREZA)
			TRB1->DESCGRUP := Posicione("SZ5",1,xFilial("SZ5")+TRB1->GRUPONAT,"Z5_DESCRI")
			TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
			dbSelectarea("SED")
			dbSetOrder(1)
			if SED->(dbseek(xFilial()+_aVencimentos[_nConta,2]))
				TRB1->DESC_NAT := SED->ED_DESCRIC
			else
				TRB1->DESC_NAT := "NATUREZA NAO DEFINIDA"
			endif
			MsUnlock()
		endif
	next _nConta
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณPFIN02PV  บAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณProcessa  Pedidos de venda                                  บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function PFIN02PV()
	local _cQuery 		:= ""
	local _aVencimentos	:= {} // Matriz no formato {Data de vencimento, natureza ,valor, numero do pedido de compra}
	local _aparcelas	:= {}
	local _nValor       := 0
	local _nValIPI      := 0
	local _nPos			:= 0
	local _nConta		:= 0
	
	cQuery := " SELECT C6_ENTREG,E4_ACRSFIN,C6_QTDVEN,C6_QTDENT,C6_QTDVEN,C6_VALOR,C5_MOEDA,C6_PRODUTO,F4_IPI, F4_BASEIPI,C5_CONDPAG,C5_CLIENTE,C5_LOJACLI,C6_NUM"
	cQuery += " FROM "+RetSqlName("SC6")+" C6, "+RetSqlName("SC5")+" C5, "+RetSqlName("SE4")+" E4, "+RetSqlName("SF4")+" F4"
	cQuery += " WHERE C5_NUM = C6_NUM AND E4_CODIGO = C5_CONDPAG AND F4_CODIGO = C6_TES "
	cQuery += " AND C5_TIPO IN ('N','C','P') AND F4_DUPLIC = 'S'  AND C5.D_E_L_E_T_ <> '*' AND C6.D_E_L_E_T_ <> '*' "
	
	MemoWrit("PFIN02C6.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
	TcSetField("TRB","C6_ENTREG","D")
	
	COUNT TO nRecCount
	//CASO TENHA DADOS
	If nRecCount = 0
		Return
	EndIf
//	SetRegua(nRecCount)
	dbSelectArea("TRB")
	dbGoTop()
	
	while !eof()
		
		
		_dDtEnt := max( _dDtRef, (DataValida(TRB->C6_ENTREG)) )
		
		_nValPV := (1+TRB->E4_ACRSFIN/100) * ((TRB->C6_QTDVEN-TRB->C6_QTDENT)/TRB->C6_QTDVEN) * TRB->C6_VALOR
		
		_nValor := iif(str(TRB->C5_MOEDA,1,0) <> "1",xMoeda(_nValPV,TRB->C5_MOEDA,1,_dDtEnt) ,_nValPV)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial()+TRB->C6_PRODUTO)
		
		if SB1->B1_IPI > 0 .and. TRB->F4_IPI <> "N"
			_nValIPI := (SB1->B1_IPI/100) * _nValor
			if TRB->F4_BASEIPI > 0
				_nValIPI *= (TRB->F4_BASEIPI/100)
			endif
		endif
		
		_nValor += _nValIPI
		
		_aParcelas := Condicao(_nValor,TRB->C5_CONDPAG,_nValIpi,_dDtEnt)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+TRB->C5_CLIENTE+TRB->C5_LOJACLI)
		
		for _nConta := 1 to len(_aParcelas)
			_nPos := Ascan(_aVencimentos,{|x| x[1]==_aParcelas[_nConta,1] .and. x[2]==SA1->A1_NATUREZ .and. x[4]==TRB->C6_NUM})
			if _nPos == 0
				aadd(_aVencimentos, {_aParcelas[_nConta,1],SA1->A1_NATUREZ,_aParcelas[_nConta,2],TRB->C6_NUM,TRB->C5_CLIENTE,TRB->C5_LOJACLI})
			else
				_aVencimentos[_nPos,3] += _aParcelas[_nConta,2]
			endif
			
		next _nConta
		
		TRB->(dbskip())
		
	enddo
	
	for _nConta := 1 to len(_aVencimentos)
		if _aVencimentos[_nConta,1] <= _dDataFim
		   
    		if SA1->(dbseek(xFilial("SA1")+_aVencimentos[_nConta,5]+_aVencimentos[_nConta,6]))
       		_Razao := SUBSTR(SA1->A1_NOME,1,30)
		   else
			   _Razao := ""
	      endif    
		   
			RecLock("TRB1",.T.)
			TRB1->DATAMOV	:= DataValida(_aVencimentos[_nConta,1])
			TRB1->NATUREZA	:= _aVencimentos[_nConta,2]
			//TRB1->DESC_NAT	:= GetAdvFVal("SED","ED_DESCRIC",xFilial("SED")+_aVencimentos[_nConta,2],1,"SEM NATUREZA")
         	TRB1->CLIFOR	:= _aVencimentos[_nConta,5]
  			TRB1->LOJA		:= _aVencimentos[_nConta,6]
			TRB1->RAZAO		:= _Razao   
			TRB1->HISTORICO	:= "PEDIDO DE VENDA " + _aVencimentos[_nConta,4]
			TRB1->VALOR		:= _aVencimentos[_nConta,3]
			TRB1->RECPAG	:= "R"
			TRB1->TIPO		:= "P"
			TRB1->ORIGEM	:= "PV"
			TRB1->GRUPONAT := RetGrupo(TRB1->NATUREZA)
			TRB1->DESCGRUP := Posicione("SZ5",1,xFilial("SZ5")+TRB1->GRUPONAT,"Z5_DESCRI")
			TRB1->CAMPO		:= RetCampo(TRB1->DATAMOV)
			if SED->(dbseek(_cFilSED+_aVencimentos[_nConta,2]))
				TRB1->DESC_NAT := SED->ED_DESCRIC
			else
				TRB1->DESC_NAT := "NATUREZA NAO DEFINIDA"
			endif
			MsUnlock()
		endif
	next _nConta
	TRB->(dbCloseArea())
	return
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณPFIN02SINTบAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Gera o Arquivo Sintetico                                   บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function PFIN02SINT()
	local _nPos 	:= 0
	local _cQuery 	:= ""
	local cFiltra 	:= " ORDEM <> '000001' "
	local _nSaldo 	:= 0
	private _cOrdem := "000001"
	
	ProcRegua(SZ5->(reccount())+TRB1->(reccount())+BANCOS->(reccount()))
	
	BANCOS->(dbgotop())
	while BANCOS->(!eof())
		if BANCOS->A6_OK <> ' '
			_nSaldo += BANCOS->A6_SALATU
		endif
		incproc()
		BANCOS->(dbskip())
	enddo
	
	
	RecLock("TRB2",.T.)
	TRB2->DESCRICAO	:= "SALDO INICIAL"
	TRB2->ORDEM		:= _cOrdem
	TRB2->TOTAL 	:= _nSaldo
	FieldPut(TRB2->(fieldpos(_aCpos[1])) , _nSaldo) // Campo do primeiro dia de movimento
	MsUnlock()
	
	_nSaldoIni	:= _nSaldo
	
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	
	_cOrdem := soma1(_cOrdem)
	
	// Gravacao de uma linha para movimentos sem natureza ou grupo de naturezas
	RecLock("TRB2",.T.)
	TRB2->DESCRICAO := "SEM NATUREZA OU GRUPO"
	TRB2->ORDEM		:= _cOrdem
	MsUnlock()
	
	_cOrdem := soma1(_cOrdem)
	
	// Carga com todos os grupos de naturezas existentes
	SZ5->(dbsetorder(1)) // Z5_FILIAL + Z5_GRUPO
	SZ5->(dbgotop())
	while SZ5->(!eof())
		RecLock("TRB2",.T.)
		TRB2->GRUPO 	:= SZ5->Z5_GRUPO
		TRB2->DESCRICAO	:= SZ5->Z5_DESCRI
		TRB2->ORDEM		:= _cOrdem
		TRB2->GRUPOSUP 	:= SZ5->Z5_CODSUP
		MsUnlock()
		if ascan(_aGrpSint,SZ5->Z5_CODSUP) == 0
			aadd(_aGrpSint,SZ5->Z5_CODSUP)
		endif
		SZ5->(dbskip())
		_cOrdem := soma1(_cOrdem)
	enddo
	
	//_cFilTRB1 := TRB1->(dbfilter())
	TRB1->(dbclearfil())
	
	TRB2->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	
	TRB1->(dbgotop())
	while TRB1->(!eof())
		_nPos 	:= TRB2->(fieldpos(TRB1->CAMPO))
		if _nPos > 0
			GravaVlr(TRB1->GRUPONAT,TRB1->VALOR,_nPos)
		endif
		TRB1->(dbskip())
	enddo
	
	//msgstop(_cFilTRB1)
	//TRB1->(dbsetfilter({|| &(_cFilTRB1)} , _cFilTRB1))
	
	TRB2->(dbclearfil())
	
	AtuSaldo()
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณGravaVlr  บAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Grava valor no arquivo sintetico                           บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function GravaVlr(_cGrupo, _nValor, _nPosCpo)
	local _nValAtual := 0
	
	if TRB2->(dbseek(_cGrupo))
		
		_nValAtual := TRB2->(FieldGet(_nPosCpo))
		
		RecLock("TRB2",.F.)
		FieldPut(_nPosCpo , _nValor + _nValAtual)
		TRB2->TOTAL += _nValor
		MsUnlock()
		
	else // Se o grupo nao existir
		
		RecLock("TRB2",.T.)
		TRB2->GRUPO 	:= _cGrupo
		TRB2->DESCRICAO	:= "GRUPO INEXISTENTE"
		TRB2->ORDEM		:= _cOrdem
		FieldPut( _nPosCpo , _nValor )
		TRB2->TOTAL += _nValor
		MsUnlock()
		_cOrdem := soma1(_cOrdem)
		
	endif
	
	if !empty(TRB2->GRUPOSUP)
		GravaVlr(TRB2->GRUPOSUP, _nValor, _nPosCpo)
	endif
	
	AtuSaldo() // Atualiza os saldo iniciais
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณAtuSaldo  บAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Atualiza o Saldo inicial de todos os dias no TRB2          บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function AtuSaldo()
	local _cQuery 	:= ""
	local _aSaldos	:= {}
	local _nPos		:= 0
	
	/*
	for _ni := 1 to _nCampos
	aAdd(_aSaldos,{_aCpos[_ni] ,0})
	next _ni
	
	TRB2->(dbgotop())
	while TRB2->(!eof())
	if TRB2->(recno())<>_nRecSaldo .and. !empty(TRB2->GRUPOSUP) .and. ascan(_aGrpSint,TRB2->GRUPO) == 0 ;
	.or. alltrim(TRB2->DESCRICAO) == "SEM NATUREZA OU GRUPO"
	for _ni := 1 to _nCampos
	_nPos := Ascan(_aSaldos,{|x| x[1]==_aCpos[_ni]})
	if _nPos > 0
	_aSaldos[_nPos,2] += &("TRB2->" + _aCpos[_ni])
	endif
	next _ni
	endif
	TRB2->(dbskip())
	enddo
	
	TRB2->(dbgoto(_nRecSaldo)) // Posiciona no registro de saldo inicial
	
	_nSaldo := _nSaldoIni
	for _ni := 1 to _nCampos-1
	_nSaldo += _aSaldos[_ni,2]
	&("TRB2->" + _aCpos[_ni+1] + " := _nSaldo")  // Grava o saldo inicial do dia seguinte
	next _ni
	
	*/
	
	/* TRECHO NOVO  */
	for _ni := 1 to _nCampos
		aAdd(_aSaldos,{_aCpos[_ni] ,0})
	next _ni
	
	TRB11->(dbgotop())
	while TRB11->(!eof())
		//for _ni := 1 to _nCampos
		_nPos := Ascan(_aSaldos,{|x| x[1]==TRB11->CAMPO})
		if _nPos > 0
			_aSaldos[_nPos,2] += TRB11->VALOR
		endif
		//next _ni
		TRB11->(dbskip())
	enddo
	
	TRB2->(dbgoto(_nRecSaldo)) // Posiciona no registro de saldo inicial
	
	_nSaldo := _nSaldoIni
	for _ni := 1 to _nCampos-1
		_nSaldo += _aSaldos[_ni,2]
		&("TRB2->" + _aCpos[_ni+1] + " := _nSaldo")  // Grava o saldo inicial do dia seguinte
	next _ni
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณMontaTela บAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Monta a tela de visualizacao do Fluxo Sintetico            บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function MontaTela()
	private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
	Private aSize   := MsAdvSize(,.F.,400)
	Private aObjects:= { { 450, 450, .T., .T. } }
	Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
	Private aHeader	:= {}
	Private lRefresh:= .T.
	Private aButton := {}
	Private _oGetDbSint
	Private _oDlgSint
	
	// Monta aHeader do TRB2
	aadd(aHeader, {"Grupo","GRUPO","",06,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Descri็ใo","DESCRICAO","",30,0,"","","C","TRB2","R"})
	for _ni := 1 to len(_aCpos) // Monta campos com as datas
		aadd(aHeader, {_aLegPer[_ni],_aCpos[_ni],"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	next _dData
	aadd(aHeader, {"Total","TOTAL","@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	
	DEFINE MSDIALOG _oDlgSint ;
	TITLE "Analise Financeira P/Natureza Financeira - Sint้tico - de " + dtoc(_dDataIni) + " at้ " + dtoc(_dDataFim) + iif(_nDiasPer > 1, " - Perํodo de " + alltrim(str(_nDiasPer,4,0)) + " dias", " - Diแrio") ;
	From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"
	
	_oGetDbSint := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB2")
	
	_oGetDbSint:oBrowse:BlDblClick := {|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}
	
	aadd(aButton , { "SIMULACAO", { || GerSimul(aheader[_oGetDbSint:oBrowse:ncolpos,2],aheader[_oGetDbSint:oBrowse:ncolpos,1]), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh() }, "Simula็ใo" } )
	aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB2","",aHeader), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )
	
	ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณShowAnalitบAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Abre os arquivos necessarios                               บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function ShowAnalit(_cCampo,_cPeriodo)
	local cFiltra 	:= ""
	
	private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
	Private aSize   := MsAdvSize(,.F.,400)
	Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
	Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
	Private aHeader	:= {}
	Private lRefresh:= .T.
	Private aButton	:= {}
	
	// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada
	if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0 .or. (empty(TRB2->GRUPOSUP) .and. !empty(TRB2->GRUPO))
		return
	endif
	
	// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
	cFiltra := " alltrim(CAMPO) == '" + alltrim(_cCampo) + "' .and. alltrim(GRUPONAT) == '" + alltrim(TRB2->GRUPO) + "' "
	TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	
	// Monta aHeader do TRB1
	aadd(aHeader, {"Data"		,"DATAMOV"	,"",08,0,"","","D","TRB2","R"})
	aadd(aHeader, {"Natureza"	,"NATUREZA"	,"",10,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Descri็ใo"	,"DESC_NAT"	,"",30,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Cli/For"	,"CLIFOR"	,"",06,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Loja"		,"LOJA" 		,"",02,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Razao"		,"RAZAO"		,"",30,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Hist๓rico"	,"HISTORICO","",50,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Valor"		,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})
	
	DEFINE MSDIALOG _oDlgAnalit TITLE "Analise Financeira P/Natureza Financeira - Analํtico - " + _cPeriodo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
	"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")
	
	@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA: MB - Movimento Bancแrio / CR - Contas Receber / CP - Contas Pagar / PC - Pedido de Compras / PV - Pedido de Vendas"
	
	aadd(aButton , { "SIMULACAO", 	{ || (GerSimul(_cCampo,_cPeriodo),TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Simula็ใo" } )
	aadd(aButton , { "EXCLUIR", 	{ || (DelSimul(_cCampo,_cPeriodo),,TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Excluir Simula็ใo" } )
	aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
	
	ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)
	
	TRB1->(dbclearfil())
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ GerSimul บAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Inclui Simulacao no Analise Financeira P/Natureza Financeira                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	Static Function GerSimul(_cCampo, _cPeriodo)
	local _nOpca := 0
	
	// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, retorna
	if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0
		return
	endif
	
	private _nOpcoes 	:= 1
	private _aOpcoes 	:= {"Simula็ใo a Pagar ","Simula็ใo a Receber"}
	private _cGrupo	 	:= TRB2->DESCRICAO
	private _cLegPer 	:= _aLegPer[ascan(_aCpos,_cCampo)]
	private _nValor	 	:= 0
	private _cHistorico	:= space(50)
	
	@ 000,000 To 280,350 Dialog _oDlgSimul Title "Simula็ใo"
	
	@ 010,005 Say "Grupo"
	@ 010,035 Get _cGrupo Size 125,10 When .F.
	
	@ 025,005 Say "Perํodo"
	@ 025,035 Get _cLegPer Size 55,10 When .F.
	
	@ 045,005 Radio _aOpcoes Var _nOpcoes
	
	@ 070,005 Say "Valor"
	@ 070,035 Get _nValor Picture "@E 999,999,999.99" Valid positivo() Size 55,10
	
	@ 085,005 Say "Hist๓rico"
	@ 085,035 Get _cHistorico Picture "@!" Size 125,10
	
	@ 110,110 BmpButton Type 1 Action iif(_nValor > 0, (_nOpca:=1,_oDlgSimul:End()) , _oDlgSimul:End())
	@ 110,140 BmpButton Type 2 Action (_oDlgSimul:End())
	
	Activate Dialog _oDlgSimul centered
	
	if _nOpca == 1 // Se confirmada a inclusao da simulacao
		
		RecLock("TRB1",.T.)
		TRB1->DATAMOV	:= _aDatas[Ascan(_aDatas , { |x| x[2] == _cCampo }),1] // Pega a primeira data do periodo como data da simulacao
		TRB1->DESC_NAT	:= "SIMULACAO"
		TRB1->HISTORICO	:= _cHistorico
		TRB1->VALOR		:= iif(_nOpcoes == 1 , -(_nValor) , _nValor)
		TRB1->RECPAG	:= iif(_nOpcoes == 1 , "P", "R")
		TRB1->GRUPONAT 	:= TRB2->GRUPO
  		TRB1->DESCGRUP := Posicione("SZ5",1,xFilial("SZ5")+TRB1->GRUPONAT,"Z5_DESCRI")
		TRB1->CAMPO		:= _cCampo
        TRB1->SIMULADO	:= "S"
		MsUnlock()
		
		if msgyesno("Deseja guardar essa simula็ใo para consultas futuras?")
			RecLock("SZ6",.T.)
			SZ6->Z6_FILIAL 	:= xFilial("SZ6")
			SZ6->Z6_GRUPO 	:= TRB1->GRUPONAT
			SZ6->Z6_DATA 	:= TRB1->DATAMOV
			SZ6->Z6_HIST 	:= TRB1->HISTORICO
			SZ6->Z6_VALOR	:= abs(TRB1->VALOR)
			SZ6->Z6_RECPAG	:= TRB1->RECPAG
			MsUnlock()
			
			aadd(_aRegSimul, {TRB1->(recno()), SZ6->(recno())} )
			
		endif
		
		// Limpa e recria o Arquivo sintetico - TRB2
		DbSelectArea("TRB2")
		zap
		
		MSAguarde({||PFIN02SINT()},"Gerando arquivo sint้tico.")
		
	endif
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ DelSimul บAutor  ณSilverio Bastos   บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Excluir Simulacao no Analise Financeira P/Natureza Financeira                        บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	Static Function DelSimul()
	local _nOpca := 0
	local _nPos
	local _nRecTRB1
	
	// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, retorna
	if TRB1->SIMULADO <> "S"
		
		MsgStop("Apenas movimentos de simula็ใo podem ser excluํdos.")
		
	elseif msgyesno("Confirma exclusใo do movimento de simula็ใo?")
		
		_nRecTRB1 := TRB1->(recno())
		RecLock("TRB1",.F.)
		dbdelete()
		MsUnlock()
		
		if msgyesno("Deseja excluir essa simula็ใo de consultas futuras?")
			_nPos := Ascan(_aRegSimul,{|x| x[1] == _nRecTRB1})
			if _nPos > 0
				SZ6->(dbgoto(_aRegSimul[_nPos,2]))
				RecLock("SZ6",.F.)
				dbdelete()
				MsUnlock()
			endif
		endif
		
		// Limpa e recria o Arquivo sintetico - TRB2
		DbSelectArea("TRB2")
		zap
		MSAguarde({||PFIN02SINT()},"Gerando arquivo sint้tico.")
		
		//_oDlgAnalit:End()
		TRB1->(dbgotop())
		TRB2->(dbgotop())
		
	endif
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณGeraExcel บAutor  ณSilverio Bastos     บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Gera Arquivo em Excel e abre                               บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function GeraExcel(_cAlias,_cFiltro,aHeader)
	
	MsAguarde({||GeraCSV(_cAlias,_cFiltro,aHeader)},"Aguarde","Gerando Planilha",.F.)
	
	/*
	_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)
	
	if !empty(_cFiltro)
	copy to &(_cArq) VIA "DBFCDXADS" for &(_cFiltro)
	else
	copy to &(_cArq) VIA "DBFCDXADS"
	endif
	
	MsAguarde({||AbreDoc( _cArq ) },"Aguarde","Abrindo Arquivo",.F.)
	*/
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณGeraCSV   บAutor  ณSilverio Bastos     บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Gera Arquivo em Excel e abre                               บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	Static Function geraCSV(_cAlias,_cFiltro,aHeader) //aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar)
	
	local cDirDocs  := MsDocPath()
	Local cArquivo 	:= CriaTrab(,.F.)
	Local cPath		:= AllTrim(GetTempPath())
	Local oExcelApp
	Local nHandle
	Local cCrLf 	:= Chr(13) + Chr(10)
	Local nX
	
	local _cArq		:= ""
	
	_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)
	
	if !empty(_cFiltro)
		(_cAlias)->(dbsetfilter({|| &(_cFiltro)} , _cFiltro))
	endif
	
	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
	
	If nHandle > 0
		
		// Grava o cabecalho do arquivo
		aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
		fWrite(nHandle, cCrLf ) // Pula linha
		
		(_cAlias)->(dbgotop())
		while (_cAlias)->(!eof())
			
			for _ni := 1 to len(aHeader)
				
				_uValor := ""
				
				if aHeader[_ni,8] == "D" // Trata campos data
					_uValor := dtoc(&(_cAlias + "->" + aHeader[_ni,2]))
				elseif aHeader[_ni,8] == "N" // Trata campos numericos
					_uValor := transform(&(_cAlias + "->" + aHeader[_ni,2]),aHeader[_ni,3])
				elseif aHeader[_ni,8] == "C" // Trata campos caracter
					_uValor := &(_cAlias + "->" + aHeader[_ni,2])
				endif
				
				if _ni <> len(aHeader)
					fWrite(nHandle, _uValor + ";" )
				endif
				
			next _ni
			
			fWrite(nHandle, cCrLf )
			
			(_cAlias)->(dbskip())
			
		enddo
		
		fClose(nHandle)
		CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
		
		If ! ApOleClient( 'MsExcel' )
			MsgAlert( 'MsExcel nao instalado')
			Return
		EndIf
		
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	Else
		MsgAlert("Falha na cria็ใo do arquivo")
	Endif
	
	(_cAlias)->(dbclearfil())
	
	Return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณAbreArq   บAutor  ณSilverio Bastos     บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Abre os arquivos necessarios                               บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/

Static Function AbreArq()
	local aStru 	:= {}
	local _dData
	local _nDias	:= 1
	local _cCpoAtu
	local _ni
	
	if file(_cArq) .and. ferase(_cArq) == -1
		msgstop("Nใo foi possํvel abrir o arquivo PFIN02.XLS pois ele pode estar aberto por outro usuแrio.")
		return(.F.)
	endif
	
	_cCpoAtu := "D_" +	strtran(dtoc(DataValida(_dDataIni),"dd/mm/yy"),"/","_") // Primeiro campo que sera criado
	if _nDiasPer == 1 // Se for diario, grava a data
		aadd(_aLegPer , dtoc(DataValida(_dDataIni),"dd/mm/yy"))
	else // Senao grava dd/mm a dd/mm
		aadd(_aLegPer , left(dtoc(DataValida(_dDataIni),"dd/mm/yy"),5) + " a ")
	endif

For _dData := _dDataIni to _dDataFim step 1 // Monta campos com as datas
		
	If _dData == DataValida(_dData) // Apenas dias uteis

		If _nDias > _nDiasPer // Se ja acumulou mais que o necessario

			If _nDiasPer == 1 // Se for diario, grava a data
				AADD(_aLegPer , dtoc(_dData,"dd/mm/yy")) // Grava o dia como label do campo
			Else // Grava a data inicial no campo
				_aLegPer[len(_aLegPer)] += left(dtoc(_aDatas[len(_aDatas),1],"dd/mm/yy"),5)
				AADD(_aLegPer , left(dtoc(_dData,"dd/mm/yy"),5) + " a ")
			EndIf

			_cCpoAtu 	:= "D_" +	strtran(dtoc(_dData,"dd/mm/yy"),"/","_") // gera o nome do campo
			_nDias 		:= 1 // reinicia o contador
		EndIf
			
		_nDias++
			
		AADD(_aDatas,{_dData,_cCpoAtu})
			
		If aScan(_aCpos,_cCpoAtu) == 0
			AADD(_aCpos,_cCpoAtu)
		EndIf

	EndIf

Next _dData

If Len(_aDatas) == 0
	Return(.f.)
EndIf
	
_nCampos := len(_aCpos)
	
if _nDiasPer <> 1
		_aLegPer[len(_aLegPer)] += left(dtoc(_aDatas[len(_aDatas),1],"dd/mm/yy"),5)
	endif
	
	// monta arquivo analitico
	aAdd(aStru,{"DATAMOV"	,"D",08,0}) // Data de movimentacao
	aAdd(aStru,{"NATUREZA"	,"C",10,0}) // Codigo da Natureza
	aAdd(aStru,{"DESC_NAT"	,"C",30,0}) // Descricao da Natureza
	aAdd(aStru,{"CLIFOR"	,"C",6,0}) 		// Codigo Cliente / Fornecedor
	aAdd(aStru,{"LOJA"	,"C",2,0}) 		// Loja
	aAdd(aStru,{"RAZAO"	,"C",30,0}) 	// RAZAO SOCIAL
	aAdd(aStru,{"HISTORICO"	,"C",50,0}) // Historico
	aAdd(aStru,{"VALOR"		,"N",15,2}) // Valor do movimento
	aAdd(aStru,{"RECPAG"	,"C",01,0}) // (R)eceber ou (P)agar
	aAdd(aStru,{"TIPO"		,"C",01,0}) // Tipo - (P)revisto ou (R)ealizado
	aAdd(aStru,{"ORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas receber e CP - Contas pagar)
	aAdd(aStru,{"GRUPONAT"	,"C",06,0}) // Grupos de Natureza
	aAdd(aStru,{"DESCGRUP"	,"C",30,0}) // Descricao Grupo Natureza
	aAdd(aStru,{"CAMPO"		,"C",25,0}) // Campo de gravacao (periodo) no arquivo sintetico
	aAdd(aStru,{"SIMULADO"	,"C",01,0}) // Indica se o registro foi gerado por uma simulacao
	aAdd(aStru,{"BANCO"	,"C",03,0}) // Codigo do Banco
	aAdd(aStru,{"BANCOS","C",15,0}) // Nome do Banco
	aAdd(aStru,{"AGENC"	,"C",05,0}) // Numero da Agencia
	aAdd(aStru,{"CONTA"	,"C",10,0}) // Numero da conta bancaria
	aAdd(aStru,{"LIMBCO","N",16,2}) // Limite de credito do banco.
	
	cArqTrb1 := CriaTrab(aStru,.t.)
	dbUseArea(.T.,,cArqTrb1,"TRB1",.t.,.F.)
	dbUseArea(.T.,,cArqTrb1,"TRB11",.t.,.F.)

//	dbcreate(cArqTrb1,aStru)
//	dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)
//	dbUseArea(.T.,,cArqTrb1,"TRB11",.T.,.F.)
	
	aStru := {}
	aAdd(aStru,{"GRUPO"		,"C",06,0}) // Codigo da Natureza
	aAdd(aStru,{"DESCRICAO"	,"C",30,0}) // Descricao da Natureza
	for _ni := 1 to len(_aCpos) // Monta campos com as datas
		aAdd(aStru,{_aCpos[_ni] ,"N",15,2}) // Valor do movimento no dia
	next _dData
	aAdd(aStru,{"TOTAL"		,"N",15,2}) // Valor total dos movimentos
	aAdd(aStru,{"ORDEM"		,"C",06,0}) // Ordem de apresentacao
	aAdd(aStru,{"GRUPOSUP"	,"C",06,0}) // Codigo do grupo superior
	
	cArqTrb2 := CriaTrab(aStru,.t.)
	dbUseArea(.T.,,cArqTrb2,"TRB2",.f.,.F.)
//	dbcreate(cArqTrb2,aStru)
//	dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
	index on ORDEM to &(cArqTrb2+"2")
	index on GRUPO+DESCRICAO to &(cArqTrb2+"1")
	set index to &(cArqTrb2+"1")
	
	return(.T.)
	
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ RETGRUPO บAutor  ณSilverio Bastos     บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Retorna o grupo de uma determinada natureza                บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function RetGrupo(_cNaturez)
	local _cRet := ""
	
	if empty(_cNaturez)
		_cRet := space(6)
	else
		SED->(dbsetorder(1)) // ED_FILIAL + ED_CODIGO
		if SED->(dbseek(xFilial("SED")+_cNaturez))
			_cRet := SED->ED_XGRUPO
		endif
		
	endif
	
	return(_cRet)
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณ RETCAMPO บAutor  ณSilverio Bastos     บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Retorna o grupo de uma determinada natureza                บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function RetCampo(_dData)
	local _cRet := ""
	
	_nPos := Ascan(_aDatas , { |x| x[1] == _dData })
	
	if _nPos > 0
		_cRet := _aDatas[_nPos,2]
	endif
	
	return(_cRet)
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณVLDPARAM  บAutor  ณSilverio Bastos     บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Valida os parametros digitados                             บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function VldParam()
	
	if empty(_dDataIni) .or. empty(_dDataFim) .or. empty(_dDtRef) // Alguma data vazia
		msgstop("Todas as datas dos parโmetros devem ser informadas.")
		return(.F.)
	endif
	
	if _dDataIni > _dDtRef // Data de inicio maior que data de referencia
		msgstop("A data de inํcio do processamento deve ser menor ou igual a data de refer๊ncia.")
		return(.F.)
	endif
	
	if _dDataFim < _dDtRef // Data de fim menor que data de referencia
		msgstop("A data de final do processamento deve ser maior ou igual a data de refer๊ncia.")
		return(.F.)
	endif
	
	return(.T.)
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณABREDOC   บAutor  ณSilverio Bastos     บ Data ณ  05/02/10   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Abre o XLS com os dados do Analise Financeira P/Natureza Financeira                  บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function AbreDoc( _cFile )
	LOCAL cDrive     := ""
	LOCAL cDir       := ""
	
	cTempPath := "C:\"
	cPathTerm := cTempPath + _cFile
	
	ferase(cTempPath + _cFile)
	
	If CpyS2T( "\SIGAADV\"+_cFile, cTempPath, .T. )
		SplitPath(cPathTerm, @cDrive, @cDir )
		cDir := Alltrim(cDrive) + Alltrim(cDir)
		nRet := ShellExecute( "Open" , cPathTerm ,"", cDir , 3 )
	else
		MsgStop("Ocorreram problemas na c๓pia do arquivo.")
	endif
	
	return
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณVALIDPERG บAutor  ณSilverio Bastos   บ Data ณ  05/02/10     บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Cria as perguntas do SX1                                   บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	static function VALIDPERG()
	// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
	// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
	PutSX1(cPerg,"01","Data Inicial"			,"Data Inicial"			,"Data Inicial"			,"mv_ch1","D",08,0,0,"G","",""		,"",,"mv_par01","","","","","","","","","","","","","","","","",{"Data de inicio do processamento"})
	PutSX1(cPerg,"02","Data Final"				,"Data Final"			,"Data Final"			,"mv_ch2","D",08,0,0,"G","",""		,"",,"mv_par02","","","","","","","","","","","","","","","","",{"Data final do processamento"})
	PutSX1(cPerg,"03","Data de Referencia"		,"Data de Referencia"	,"Data de Referencia"	,"mv_ch3","D",08,0,0,"G","",""		,"",,"mv_par03","","","","","","","","","","","","","","","","",{"Data de referencia do processamento","movimentos apos essa data sao","previstos e o restante, realizados"})
	PutSX1(cPerg,"04","Considera Ped. Compra" 	,"Considera Ped. Compra","Considera Ped. Compra","mv_ch4","N",01,0,0,"C","",""		,"",,"mv_par04","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg,"05","Considera Ped. Venda" 	,"Considera Ped. Venda"	,"Considera Ped. Venda"	,"mv_ch5","N",01,0,0,"C","",""		,"",,"mv_par05","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg,"06","Considera Vencidos"		,"Considera Vencidos"	,"Considera Vencidos"	,"mv_ch6","N",01,0,0,"C","",""		,"",,"mv_par06","A Receber","","","","A Pagar","","","Ambos","","","Nenhum","","","","","")
	PutSX1(cPerg,"07","Dias por periodo"		,"Dias por periodo"		,"Dias por periodo"		,"mv_ch7","N",02,0,0,"G","",""		,"",,"mv_par07","","","","","","","","","","","","","","","","",{"Indica quantos dias serใo considerados","por perํodo (coluna) do relat๓rio"})
	PutSX1(cPerg,"08","Seleciona Bancos"		,"Seleciona Bancos"		,"Seleciona Bancos"		,"mv_ch8","N",01,0,0,"C","",""		,"",,"mv_par08","Sim","","","","Nao","","","","","","","","","","","")
	PutSX1(cPerg,"09","Considera Previsoes"	    ,"Considera Previsoes"	,"Considera Previsoes"	,"mv_ch9","N",01,0,0,"C","",""		,"",,"mv_par09","Sim","","","","Nao","","","","","","","","","","","")
	
	return