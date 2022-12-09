#Include "Rwmake.ch"  
#Include "Topconn.ch"

/*
+------------+---------+--------+---------------+-------+------------+
| Programa:  | RCTBM01 | Autor: |Silverio Bastos| Data: | Abril/2010 |
+------------+---------+--------+---------------+-------+------------+
| Descri็ใo: | Rotina para Apagar os Flag's de Contabiliza็ใo e os   |
|            | Lotes Contแbeis.						                     |
+------------+-------------------------------------------------------+
| Uso:       | Verion ำleo Hidrแulica Ltda.                          |
+------------+-----------------------+-------------------------------+
| Variแveis Utilizadas em Parโmetros |
+----------+-------------------------+
| mv_par01 | Data Inicial       ?    |
| mv_par02 | Data Final         ?    |
| mv_par03 | Qual Contabiliza็ใo?    |
+----------+-------------------------+
*/

User Function FCTBM01

Private cPerg := "FCTM01"
Private _lDel := .f.

// +------------------------------+
// | Cria Dicionแrio de Perguntas |
// +------------------------------+

_fVlPerg()

Pergunte(cPerg,.f.)

// +-------------------------------+
// | Tela Inicial de Processamento |
// +-------------------------------+

@ 190 , 001 to 330 , 380 Dialog oDlgA Title OemToAnsi("Apaga Contabiliza็ใo")
@ 008 , 010 to 046 , 180

@ 016 , 018 Say "Este Programa irแ desfazer a Contabiliza็ใo processada, "
@ 024 , 018 Say "Limpando os Flag's e Apagando os Lan็amentos Feitos. "
@ 032 , 018 Say "Verion OleoHidraulica Ltda."

@ 052 , 088 BmpButton Type 01 Action _fProcessa()
@ 052 , 118 BmpButton Type 02 Action Close(oDlgA)
@ 052 , 148 BmpButton Type 05 Action Pergunte(cPerg,.t.)

Activate Dialog oDlgA Centered  

MsgStop("Processamento Concluํdo, o Usuแrio deverแ Executar o Reprocessamento")

CTBA190()

Return

/*
+------------+------------+--------+---------------+-------+------------+
| Programa:  | _fProcessa | Autor: |Silverio Bastos| Data: | Abril/2010 |
+------------+------------+--------+---------------+-------+------------+
| Uso:       | Verion.								                    |
+------------+----------------------------------------------------------+
*/

Static Function _fProcessa

Processa({|| RunCont() },"Processando...")

//Close(oDlgA)

Return

/*
+------------+---------+--------+---------------+-------+------------+
| Programa:  | RunCont | Autor: |Silverio Bastos| Data: | Abril/2010 |
+------------+---------+--------+---------------+-------+------------+
| Uso:       | Verion.								                 |
+------------+-------------------------------------------------------+
*/

Static Function RunCont

// +-----------------------------------------------------------+
// | Apaga Flag de Contabiliza็ใo das Notas Fiscais de Entrada |
// +-----------------------------------------------------------+

If mv_par03 == 1

	DbSelectArea("SF1")
	_cQrySF1 := "Select SF1.* "
	_cQrySF1 += "From " + RetSqlName("SF1") + " SF1 "
	_cQrySF1 += "Where SF1.F1_DTDIGIT >= '" + DTOS(mv_par01) + "' And SF1.F1_DTDIGIT <= '" + DTOS(mv_par02) + "' "
	_cQrySF1 +=   "And SF1.F1_DTLANC  <> '" + Space(8)       + "' And SF1.D_E_L_E_T_ <> '*' "
	_cQrySF1 += "Order by SF1.F1_FILIAL,SF1.F1_DTDIGIT,SF1.F1_DOC,SF1.F1_SERIE,SF1.F1_FORNECE,SF1.F1_LOJA "

	DbSelectArea("SF1")

	If Select("SF1Q") > 0
		DbSelectArea("SF1Q")
		DbCloseArea()
	EndIf

	TcQuery _cQrySF1 New Alias "SF1Q"

	TcSetField("SF1Q","F1_DTLANC","D")  
	TcSetField("SF1Q","F1_DTDIGIT","D")

	DbSelectArea("SF1Q")

	ProcRegua(RecCount())

	DbGoTop()

	While !Eof()
			IncProc("Nota de Compras: " + SUBS(DTOS(SF1Q->F1_DTDIGIT),7,2) +;
											"/" + SUBS(DTOS(SF1Q->F1_DTDIGIT),5,2) +;
											"/" + SUBS(DTOS(SF1Q->F1_DTDIGIT),1,4) + " - " + SF1Q->F1_DOC)

			DbSelectArea("SF1")
			DbSetOrder(1)
			DbSeek(xFilial("SF1") + SF1Q->F1_DOC + SF1Q->F1_SERIE + SF1Q->F1_FORNECE + SF1Q->F1_LOJA,.f.)

			While !RecLock("SF1",.f.)
			Enddo
			SF1->F1_DTLANC := CTOD("  /  /  ")
			MsUnLock()

			DbSelectArea("SF1Q")
			DbSkip()
	Enddo

EndIf

// +---------------------------------------------------------+
// | Apaga Flag de Contabiliza็ใo das Notas Fiscais de Saida |
// +---------------------------------------------------------+

If mv_par03 == 2

	DbSelectArea("SF2")
	_cQrySF2 := "Select SF2.* "
	_cQrySF2 += "From " + RetSqlName("SF2") + " SF2 "
	_cQrySF2 += "Where SF2.F2_EMISSAO >= '" + DTOS(mv_par01) + "' And SF2.F2_EMISSAO <= '" + DTOS(mv_par02) + "' "
	_cQrySF2 +=   "And SF2.F2_DTLANC  <> '" + Space(8)       + "' And SF2.D_E_L_E_T_ <> '*' "
	_cQrySF2 += "Order by SF2.F2_FILIAL,SF2.F2_EMISSAO,SF2.F2_DOC,SF2.F2_SERIE,SF2.F2_CLIENTE,SF2.F2_LOJA "

	DbSelectArea("SF2")

	If Select("SF2Q") > 0
		DbSelectArea("SF2Q")
		DbCloseArea()
	EndIf

	TcQuery _cQrySF2 New Alias "SF2Q"

	TcSetField("SF2Q","F2_DTLANC","D")
	TcSetField("SF2Q","F2_EMISSAO","D")

	DbSelectArea("SF2Q")

	ProcRegua(RecCount())

	DbGoTop()

	While !Eof()
			IncProc("Nota de Saida: " + SUBS(DTOS(SF2Q->F2_EMISSAO),7,2) +;
										 "/" + SUBS(DTOS(SF2Q->F2_EMISSAO),5,2) +;
										 "/" + SUBS(DTOS(SF2Q->F2_EMISSAO),1,4) + " - " + SF2Q->F2_DOC)

			DbSelectArea("SF2")
			DbSetOrder(1)
			DbSeek(xFilial("SF2") + SF2Q->F2_DOC + SF2Q->F2_SERIE + SF2Q->F2_CLIENTE + SF2Q->F2_LOJA,.f.)

			While !RecLock("SF2",.f.)
			Enddo
			SF2->F2_DTLANC := CTOD("  /  /  ")
			MsUnLock()

			DbSelectArea("SF2Q")
			DbSkip()
	Enddo

EndIf

// +--------------------------------------------+
// | Apaga Flag de Contabiliza็ใo do Financeiro |
// +--------------------------------------------+

If mv_par03 == 3

	DbSelectArea("SE2")
	_cQrySE2 := "Select SE2.* "
	_cQrySE2 += "From " + RetSqlName("SE2") + " SE2 "
	_cQrySE2 += "Where SE2.E2_EMISSAO >= '" + DTOS(mv_par01) + "' And SE2.E2_EMISSAO <= '" + DTOS(mv_par02) + "' "
	_cQrySE2 +=   "And SE2.E2_LA      <> '" + Space(1)       + "' And SE2.E2_ORIGEM   = 'FINA050 ' And SE2.D_E_L_E_T_ <> '*' "
	_cQrySE2 += "Order by SE2.E2_FILIAL,SE2.E2_EMISSAO,SE2.E2_PREFIXO,SE2.E2_NUM,SE2.E2_PARCELA,SE2.E2_TIPO,SE2.E2_FORNECE,SE2.E2_LOJA "

	DbSelectArea("SE2")

	If Select("SE2Q") > 0
		DbSelectArea("SE2Q")
		DbCloseArea()
	EndIf

	TcQuery _cQrySE2 New Alias "SE2Q" 
	TcSetField("SE2Q","E2_EMISSAO","D")

	DbSelectArea("SE2Q")

	ProcRegua(RecCount())

	DbGoTop()

	While !Eof()
			IncProc("Contas a Pagar: " + SUBS(DTOS(SE2Q->E2_EMISSAO),7,2) +;
										  "/" + SUBS(DTOS(SE2Q->E2_EMISSAO),5,2) +;
										  "/" + SUBS(DTOS(SE2Q->E2_EMISSAO),1,4) + " - " + SE2Q->E2_NUM)

			DbSelectArea("SE2")
			DbSetOrder(1)
			DbSeek(xFilial("SE2") + SE2Q->E2_PREFIXO + SE2Q->E2_NUM + SE2Q->E2_PARCELA + SE2Q->E2_TIPO + SE2Q->E2_FORNECE + SE2Q->E2_LOJA,.f.)

			While !RecLock("SE2",.f.)
			Enddo
			SE2->E2_LA := " "
			MsUnLock()

			DbSelectArea("SE2Q")
			DbSkip()
	Enddo

	DbSelectArea("SE1")
	_cQrySE1 := "Select SE1.* "
	_cQrySE1 += "From " + RetSqlName("SE1") + " SE1 "
	_cQrySE1 += "Where SE1.E1_EMISSAO >= '" + DTOS(mv_par01) + "' And SE1.E1_EMISSAO <= '" + DTOS(mv_par02) + "' "
	_cQrySE1 +=   "And SE1.E1_LA      <> '" + Space(1)       + "' And SE1.E1_ORIGEM   = 'FINA040 ' And SE1.D_E_L_E_T_ <> '*' "
	_cQrySE1 += "Order by SE1.E1_FILIAL,SE1.E1_EMISSAO,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_CLIENTE,SE1.E1_LOJA "

	DbSelectArea("SE1")

	If Select("SE1Q") > 0
		DbSelectArea("SE1Q")
		DbCloseArea()
	EndIf

	TcQuery _cQrySE1 New Alias "SE1Q" 
	TcSetField("SE1Q","E1_EMISSAO","D")

	DbSelectArea("SE1Q")

	ProcRegua(RecCount())

	DbGoTop()

	While !Eof()
			IncProc("Contas a Receber: " + SUBS(DTOS(SE1Q->E1_EMISSAO),7,2) +;
											 "/" + SUBS(DTOS(SE1Q->E1_EMISSAO),5,2) +;
											 "/" + SUBS(DTOS(SE1Q->E1_EMISSAO),1,4) + " - " + SE1Q->E1_NUM)

			DbSelectArea("SE1")
			DbSetOrder(1)
			DbSeek(xFilial("SE1") + SE1Q->E1_PREFIXO + SE1Q->E1_NUM + SE1Q->E1_PARCELA + SE1Q->E1_TIPO + SE1Q->E1_CLIENTE + SE1Q->E1_LOJA,.f.)

			While !RecLock("SE1",.f.)
			Enddo
			SE1->E1_LA := " "
			MsUnLock()

			DbSelectArea("SE1Q")
			DbSkip()
	Enddo

	DbSelectArea("SE5")
	_cQrySE5 := "Select SE5.* "
	_cQrySE5 += "From " + RetSqlName("SE5") + " SE5 "
	_cQrySE5 += "Where SE5.E5_DATA >= '" + DTOS(mv_par01) + "'   And SE5.E5_DATA    <= '" + DTOS(mv_par02) + "' "
	_cQrySE5 +=  " And SE5.E5_LA    = 'S' And SE5.D_E_L_E_T_ <> '*' " //And SE5.E5_NUMERO = '" + Space(12) + "' And SE5.E5_TIPOLAN <> ' ' "
	_cQrySE5 += "Order by SE5.E5_FILIAL,SE5.E5_DATA,SE5.E5_PREFIXO,SE5.E5_NUMERO,SE5.E5_PARCELA,SE5.E5_TIPO,SE5.E5_CLIFOR,SE5.E5_LOJA "

	DbSelectArea("SE5")

	If Select("SE5Q") > 0
		DbSelectArea("SE5Q")
		DbCloseArea()
	EndIf

	TcQuery _cQrySE5 New Alias "SE5Q" 
	TcSetField("SE5Q","E5_DATA","D")

	DbSelectArea("SE5Q")

	ProcRegua(RecCount())

	DbGoTop()

	While !Eof()
			IncProc("Movimento Bancแrio: " + SUBS(DTOS(SE5Q->E5_DATA),7,2) +;
												"/" + SUBS(DTOS(SE5Q->E5_DATA),5,2) +;
												"/" + SUBS(DTOS(SE5Q->E5_DATA),1,4) + " - " + SE5Q->E5_NUMERO)

			DbSelectArea("SE5")
			DbSetOrder(7)
			DbSeek(xFilial("SE5") + SE5Q->E5_PREFIXO + SE5Q->E5_NUMERO + SE5Q->E5_PARCELA + SE5Q->E5_TIPO +;
											SE5Q->E5_CLIFOR  + SE5Q->E5_LOJA   + SE5Q->E5_SEQ,.f.)

			While !RecLock("SE5",.f.)
			Enddo
			SE5->E5_LA := "  "
			MsUnLock()

			DbSelectArea("SE5Q")
			DbSkip()
	Enddo

	DbSelectArea("SEF")
	_cQrySEF := "Select SEF.* "
	_cQrySEF += "From " + RetSqlName("SEF") + " SEF "
	_cQrySEF += "Where SEF.EF_DATA >= '" + DTOS(mv_par01) + "' And SEF.EF_DATA   <= '" + DTOS(mv_par02) + "' "
	_cQrySEF +=   "And SEF.EF_LA   <> '" + Space(1)       + "' And SEF.EF_ORIGEM  = 'FINA390AVU' And SEF.D_E_L_E_T_ <> '*' "
	_cQrySEF += "Order by SEF.EF_FILIAL,SEF.EF_DATA "

	DbSelectArea("SEF")

	If Select("SEFQ") > 0
		DbSelectArea("SEFQ")
		DbCloseArea()
	EndIf

	TcQuery _cQrySEF New Alias "SEFQ" 
	TcSetField("SEFQ","EF_DATA","D")

	DbSelectArea("SEFQ")

	ProcRegua(RecCount())

	DbGoTop()

	While !Eof()
			IncProc("Cheque: " + SUBS(DTOS(SEFQ->EF_DATA),7,2) +;
								"/" + SUBS(DTOS(SEFQ->EF_DATA),5,2) +;
								"/" + SUBS(DTOS(SEFQ->EF_DATA),1,4) )

			DbSelectArea("SEF")
			DbSetOrder(1)
			DbSeek(xFilial("SEF") + SEFQ->EF_BANCO + SEFQ->EF_AGENCIA + SEFQ->EF_CONTA + SEFQ->EF_NUM,.f.)

			While !RecLock("SEF",.f.)
			Enddo
			SEF->EF_LA := " "
			MsUnLock()

			DbSelectArea("SEFQ")
			DbSkip()
	Enddo
	
	DbSelectArea("SEU")
	_cQrySEU := "Select SEU.* "
	_cQrySEU += "From " + RetSqlName("SEU") + " SEU "
	_cQrySEU += "Where SEU.EU_DTDIGIT >= '" + DTOS(mv_par01) + "' And SEU.EU_DTDIGIT <= '" + DTOS(mv_par02) + "' "
	_cQrySEU += "  And SEU.EU_LA <> 'N' And SEU.EU_LA <> ' '  And SEU.D_E_L_E_T_ <> '*' "
	_cQrySEU += "Order by SEU.EU_FILIAL,SEU.EU_DTDIGIT,SEU.EU_CAIXA,SEU.EU_NUM "

	DbSelectArea("SEU")

	If Select("SEUQ") > 0
		DbSelectArea("SEUQ")
		DbCloseArea()
	EndIf

	TcQuery _cQrySEU New Alias "SEUQ" 
	TcSetField("SEUQ","EU_DTDIGIT","D")

	DbSelectArea("SEUQ")

	ProcRegua(RecCount())

	DbGoTop()

	While !Eof()
			IncProc("Caixinha: " + SUBS(DTOS(SEUQ->EU_DTDIGIT),7,2) +;
								  "/" + SUBS(DTOS(SEUQ->EU_DTDIGIT),5,2) +;
								  "/" + SUBS(DTOS(SEUQ->EU_DTDIGIT),1,4) + " - " + SEUQ->EU_CAIXA + SEU->EU_NUM)

			DbSelectArea("SEU")
			DbSetOrder(4)
			DbSeek(xFilial("SEU") + SEUQ->EU_CAIXA + DTOS(SEUQ->EU_DTDIGIT) +	SEUQ->EU_NUM,.f.)

			While !RecLock("SEU",.f.)
			Enddo
			SEU->EU_LA := " "
			MsUnLock()

			DbSelectArea("SEUQ")
			DbSkip()
	Enddo

EndIf

// +--------------------------------------------+
// | Apaga Flag de Contabiliza็ใo do Ativo Fixo |
// +--------------------------------------------+

If mv_par03 == 4

	DbSelectArea("SN4")
	_cQrySN4 := "Select SN4.* "
	_cQrySN4 += "From " + RetSqlName("SN4") + " SN4 "
	_cQrySN4 += "Where SN4.N4_DCONTAB >= '" + DTOS(mv_par01) + "' And SN4.N4_DCONTAB <= '" + DTOS(mv_par02) + "' "
	_cQrySN4 += " And SN4.N4_DCONTAB <> '        '  And SN4.D_E_L_E_T_ <> '*' "
	_cQrySN4 += "Order by SN4->N4_FILIAL,SN4.N4_DCONTAB,SN4.N4_CBASE "

	DbSelectArea("SN4")

	If Select("SN4Q") > 0
		DbSelectArea("SN4Q")
		DbCloseArea()
	EndIf

	TcQuery _cQrySN4 New Alias "SN4Q" 
	TcSetField("SN4Q","N4_DCONTAB","D")

	DbSelectArea("SN4Q")

	ProcRegua(RecCount())

	DbGoTop()

	While !Eof()
			IncProc("Bem: " + SUBS(DTOS(SN4Q->N4_DCONTAB),7,2) +;
							"/" + SUBS(DTOS(SN4Q->N4_DCONTAB),5,2) +;
							"/" + SUBS(DTOS(SN4Q->N4_DCONTAB),1,4) + " - " + SN4Q->N4_CBASE)

			DbSelectArea("SN4")
			DbSetOrder(1)
			DbSeek(xFilial("SN4") + SN4Q->N4_CBASE + SN4Q->N4_ITEM + SN4Q->N4_TIPO + SN4Q->N4_DATA + SN4Q->N4_OCORR + SN4Q->N4_SEQ,.f.)

			While !RecLock("SN4",.f.)
			Enddo
			SN4->N4_DCONTAB := CTOD("  /  /  ")
			MsUnLock()

			DbSelectArea("SN4Q")
			DbSkip()
	Enddo

EndIf

// +-----------------------------+
// | Apaga Lan็amentos Contแbeis |
// +-----------------------------+

DbSelectArea("CT2")
_cQryCT2 := "Select Distinct CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC  , CT2_LINHA, CT2_TPSALD, CT2_EMPORI, CT2_FILORI, CT2_MOEDLC, "
_cQryCT2 += 					 "CT6_DATA  , CT6_LOTE, CT6_SBLOTE, CT6_MOEDA, CT6_TPSALD "
_cQryCT2 += "From "       + RetSqlName("CT2") + " CT2 "
_cQryCT2 += "Inner Join " + RetSqlName("CT6") + " CT6 "
_cQryCT2 += " On  CT6_FILIAL = CT2_FILIAL And CT6_LOTE = CT2_LOTE And CT6_SBLOTE = CT2_SBLOTE "
_cQryCT2 += " And CT6_DATA   = CT2_DATA   And CT6.D_E_L_E_T_ <> '*' "
_cQryCT2 += "Where CT2.CT2_DATA   >= '" + DTOS(mv_par01) + "' And CT2.CT2_DATA <= '" + DTOS(mv_par02) + "' "
_cQryCT2 +=   "And CT2.D_E_L_E_T_ <> '*' "
_cQryCT2 += "Order by CT2.CT2_FILIAL,CT2.CT2_DATA,CT2.CT2_LOTE,CT2.CT2_SBLOTE,CT2.CT2_DOC "

If Select("CT2Q") > 0
	DbSelectArea("CT2Q")
	DbCloseArea()
EndIf

TcQuery _cQryCT2 New Alias "CT2Q" 

DbSelectArea("CT2Q")

ProcRegua(RecCount())

DbGoTop()

While !Eof()
		IncProc("Lan็amento Contแbil: " + SUBS(CT2Q->CT2_DATA,7,2) +;
											 "/" + SUBS(CT2Q->CT2_DATA,5,2) +;
											 "/" + SUBS(CT2Q->CT2_DATA,1,4) + " - " + CT2Q->CT2_LOTE)

		DbSelectArea("CT2")
		DbSetOrder(1)
		DbSeek(xFilial("CT2") + CT2Q->CT2_DATA   + CT2Q->CT2_LOTE   + CT2Q->CT2_SBLOTE + CT2Q->CT2_DOC + CT2Q->CT2_LINHA;
									 + CT2Q->CT2_TPSALD + CT2Q->CT2_EMPORI + CT2Q->CT2_FILORI + CT2Q->CT2_MOEDLC,.f.)

		While !RecLock("CT2",.f.)
		Enddo

		_lDel := .f.

		If mv_par03 == 1 .And. CT2->CT2_LOTE == "008810"
			Delete
			_lDel := .t.
		ElseIf mv_par03 == 2 .And. CT2->CT2_LOTE == "008820"
			Delete
			_lDel := .t.
		ElseIf mv_par03 == 3 .And. CT2->CT2_LOTE == "008850" // .And. !(CT2->CT2_LP $ "570/575")
			Delete
			_lDel := .t.
		ElseIf mv_par03 == 4 .And. CT2->CT2_LOTE == "008850" // .And. CT2->CT2_LP $ "570/575"
			Delete
			_lDel := .t.
		ElseIf mv_par03 == 5 .And. CT2->CT2_LOTE == "008860"
			Delete
			_lDel := .t.
		EndIf

		MsUnLock()

		// +----------------------------------------+
		// | Posiciona na Capa de Lote para Excluir |
		// +----------------------------------------+

		If _lDel

			DbSelectArea("CT6")
			DbSetOrder(1)

			If DbSeek(xFilial("CT6") + CT2Q->CT6_DATA + CT2Q->CT6_LOTE + CT2Q->CT6_SBLOTE + CT2Q->CT6_MOEDA + CT2Q->CT6_TPSALD,.f.)

				While !RecLock("CT6",.f.)
				Enddo
				Delete
				MsUnLock()

			EndIf

		EndIf

		DbSelectArea("CT2Q")
		DbSkip()
Enddo

ALERT("TERMINO DE PROCESSAMENTO !!!")

Close(oDlgA)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fVlPerg บAutor  ณSilverio Bastos   บ Data ณ  Abril/2010    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas do SX1                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fVlPerg
// cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
// cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5
PutSx1(cPerg,"01","Data Inicial  ? " ,"Data Inicial  ? " , "Data Inicial  ? " ,"mv_ch1" ,"D",08,0,0,"G","" ,"",,,"MV_PAR01","","","","")
PutSx1(cPerg,"02","Data Final    ? " ,"Data Final    ? " , "Data Final    ? " ,"mv_ch2" ,"D",08,0,0,"G","" ,"",,,"MV_PAR02","","","","")
PutSx1(cPerg,"03","Contabiliza็ใo? " ,"Contabiliza็ใo? " , "Contabiliza็ใo? " ,"mv_ch3" ,"N",01,0,0,"C","" ,"",,,"MV_PAR03","Notas de Compra","Notas de Saida","Financeiro","Ativo Fixo")
	
Return
