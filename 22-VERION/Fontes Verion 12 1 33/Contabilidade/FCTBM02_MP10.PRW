#Include "Rwmake.ch"

/*
+------------+---------+--------+---------------+-------+-------------+
| Programa:  | FCTBM02 | Autor: | Flávio Sardão | Data: | Agosto/2010 |
+------------+---------+--------+---------------+-------+-------------+
| Descrição: | Importação de Lançamentos Contábeis de Arquivo TXT.    |
+------------+--------------------------------------------------------+
| Uso:       | Verion Óleo Hidráulica Ltda.                           |
+------------+----------------------------------+---------------------+
| Variáveis de Usuário Utilizadas em Parâmetros |
+----------+------------------------------------+
| mv_par01 | Arquivo a Importar      ?          |
| mv_par02 | Lote Contábil a Iniciar ?          |
| mv_par03 | Pos.Inicial Data        ?          |
| mv_par04 | Tamanho Data            ?          |
| mv_par05 | Pos.Inicial Cta.Débito  ?          |
| mv_par06 | Tamanho Conta Cta.Débit ?          |
| mv_par07 | Pos.Inicial Cta.Crédito ?          |
| mv_par08 | Tamanho Cta.Crédito     ?          |
| mv_par09 | Pos.Inicial Valor       ?          |
| mv_par10 | Tamanho Valor           ?          |
| mv_par11 | Pos.Inicial Histórico   ?          |
| mv_par12 | Tamanho Histórico       ?          |
| mv_par13 | Pos.Inicial C.C.Débito  ?          |
| mv_par14 | Tamanho C.C.Débito      ?          |
| mv_par15 | Pos.Inicial C.Crédito   ?          |
| mv_par16 | Tamanho C.C.Crédito     ?          |
+----------+------------------------------------+
*/

User Function FCTBM02 

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _aArea    := GetArea()

Private cPerg   := "FCTBM02   "
Private oDlgA
Private cString := "CT2"

// +----------------------------------------+
// | Verifica e cria as Perguntas da Rotina |
// +----------------------------------------+

_fValPerg()

// +-----------------------------------+
// | Montagem da Tela de Processamento |
// +-----------------------------------+

@ 190 , 001 to 330 , 380 Dialog oDlgA Title OemToAnsi("Importação Contábil TXT")
@ 008 , 010 to 046 , 180

@ 016 , 018 Say "Este Programa irá Importar os Lançamentos Contábeis de um "
@ 024 , 018 Say "Arquivo TXT num Padrão Pré-Definido pelo Usuário."
@ 032 , 018 Say "Verion Óleo Hidráulica Ltda."

@ 052 , 088 BmpButton Type 01 Action _fProcessa()
@ 052 , 118 BmpButton Type 02 Action Close(oDlgA)
@ 052 , 148 BmpButton Type 05 Action Pergunte(cPerg,.t.)

Activate Dialog oDlgA Centered

MsgStop("Processamento Concluído, EXECUTE REPROCESSAMENTO")

CTBA190()

// +----------------------------+
// | Restaura Ambiente Original |
// +----------------------------+

RestArea(_aArea)

Return

/*
+---------+------------+--------+---------------+-------+-------------+
| Função: | _fProcessa | Autor: | Flávio Sardão | Data: | Agosto/2010 |
+---------+------------+--------+---------------+-------+-------------+
| Uso:    | Verion Óleo Hidráulica Ltda.                              |
+---------+-----------------------------------------------------------+
*/

Static Function _fProcessa

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Private nHdl := fOpen(mv_par01,68)
Private cEol := "Chr(13) + Chr(10)"

// +------------------------+
// | Verifica os Parâmetros |
// +------------------------+

If mv_par03 == 0 .Or. mv_par04 == 0 .Or. mv_par05 == 0 .Or. mv_par06 == 0 .Or.;
	mv_par07 == 0 .Or. mv_par08 == 0 .Or. mv_par09 == 0 .Or. mv_par10 == 0 .Or.;
	mv_par11 == 0 .Or. mv_par12 == 0
	MsgStop("Problema nos Parâmetros de Posicionamento, Verifique !!")
	Return
EndIf

// +---------------------------+
// | Abertura do Arquivo Texto |
// +---------------------------+

If Empty(cEol)
	cEol := Chr(13) + Chr(10)
Else
	cEol := Alltrim(cEol)
	cEol := &cEol
EndIf

If nHdl == -1
	MsgAlert("O Arquivo: " + mv_par01 + ", não pode ser aberto!, Verifique os Parâmetros.","Atenção!")
	Return
EndIf

// +-------------------------------------+
// | Inicializa a Régua de Processamento |
// +-------------------------------------+

Processa({|| RunCont()},"Processando...")

Return

/*
+---------+---------+--------+---------------+-------+-------------+
| Função: | RunCont | Autor: | Flávio Sardão | Data: | Agosto/2010 |
+---------+---------+--------+---------------+-------+-------------+
| Uso:    | Verion Óleo Hidráulica Ltda.                           |
+---------+--------------------------------------------------------+
*/

Static Function RunCont

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local nTamFile, nTamLin, cBuffer, nBtLidos
Local _nSbLote := _nDoc  := _nLinha := 1
Local _dData   := CTOD("  /  /  ")
Local _aStru1  := {}
Local _cArq1   := _cInd1 := ""
Local _nIndice := 1

// +-------------------------+
// | Cria Arquivo Temporário |
// +-------------------------+

If Select("TRB1") > 0
	DbSelectArea("TRB1")
	DbCloseArea()
	DbSelectArea("SA1")
EndIf

AADD(_aStru1,{"INDICE" ,"C",010,0})
AADD(_aStru1,{"MBUFFER","C",200,0})

_cArq1 := CriaTrab(_aStru1,.t.)
DbUseArea(.t.,,_cArq1,"TRB1",.f.,.f.)
_cInd1 := CriaTrab(Nil,.f.)
IndRegua("TRB1",_cInd1,"INDICE",,,"Aguarde selecao dos registros...")

// +---------------------------------+
// | Lê o Arquivo TXT, Linha a Linha |
// +---------------------------------+

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 500 + Len(cEol)
cBuffer  := Space(nTamLin)
nBtLidos := fRead(nHdl,@cBuffer,nTamLin)

ProcRegua(nTamFile)
y := cBuffer

While nBtLidos >= nTamLin - 480
		IncProc()

		If (z := At(Chr(13) + Chr(10), y)) == 0
			nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da próxima Linha do Arquivo Texto
			y += cBuffer
			Loop
		EndIf

		If z > 0
			_nEol := at(chr(13) + chr(10),y)

			DbSelectArea("TRB1")

			While !RecLock("TRB1",.t.)
			Enddo
			TRB1->INDICE  := Strzero(_nIndice,10)
			TRB1->MBUFFER := SUBS(y,1,_nEol - 1)
			MsUnLock()

			_nIndice += 1
			y        := SUBS(y,z + 2,Len(y))
		Else
			y        := ""
		EndIf

Enddo

DbSelectArea("TRB1")
ProcRegua(RecCount())
DbGotop()

While !Eof()
		IncProc()

		// +-------------------------------------------+
		// | Grava Lançamentos lidos para a Tabela CT2 |
		// +-------------------------------------------+

		_cData   := SUBS(TRB1->MBUFFER,007,004) + SUBS(TRB1->MBUFFER,004,002) + SUBS(TRB1->MBUFFER,001,002)
		_dData   := CTOD(SUBS(TRB1->MBUFFER,mv_par03,mv_par04))
		_cDebito := Alltrim(SUBS(TRB1->MBUFFER,mv_par05,mv_par06))
		_cCredit := Alltrim(SUBS(TRB1->MBUFFER,mv_par07,mv_par08))
		_nValor  := Val(Alltrim(SUBS(TRB1->MBUFFER,mv_par09,mv_par10)))
		_cHist   := Alltrim(SUBS(TRB1->MBUFFER,mv_par11,mv_par12))
		_cCCD    := Alltrim(SUBS(TRB1->MBUFFER,mv_par13,mv_par14))
		_cCCC    := Alltrim(SUBS(TRB1->MBUFFER,mv_par15,mv_par16))

		DbSelectArea("CT2")
		DbSetOrder(1)

		If !DbSeek(xFilial("CT2") + _cData + mv_par02 + Strzero(_nSbLote,3) + Strzero(_nDoc,6) + Strzero(_nLinha,3) + "1" + "01" + "01" + "01",.f.)

			While !RecLock("CT2",.t.)
			Enddo
			CT2->CT2_FILIAL := xFilial("CT2")
			CT2->CT2_DATA   := _dData
			CT2->CT2_LOTE   := mv_par02
			CT2->CT2_SBLOTE := Strzero(_nSbLote,3)
			CT2->CT2_DOC    := Strzero(_nDoc   ,6)
			CT2->CT2_LINHA  := Strzero(_nLinha ,3)
			CT2->CT2_MOEDLC := "01"
			CT2->CT2_DC     := "3"
			CT2->CT2_DEBITO := _cDebito
			CT2->CT2_CREDIT := _cCredit
			CT2->CT2_VALOR  := _nValor
			CT2->CT2_MOEDAS := "12222"
			CT2->CT2_HIST   := _cHist
			CT2->CT2_CCD    := _cCCD
			CT2->CT2_CCC    := _cCCC
			CT2->CT2_EMPORI := "01"
			CT2->CT2_FILORI := "01"
			CT2->CT2_TPSALD := "1"
			CT2->CT2_MANUAL := "1"
			CT2->CT2_ROTINA := "CTBA102"
			CT2->CT2_AGLUT  := "2"
			CT2->CT2_SEQHIS := "001"
			CT2->CT2_SEQLAN := "001"
			CT2->CT2_CRCONV := "1"
			CT2->CT2_DTCV3  := _dData
			MsUnLock()

		Else
			MsgStop("ARQUIVO JÁ IMPORTADO OU COM PROBLEMAS NA ORDEM (PRECISA ESTAR ORDENADO POR DATA) !!!")
			MsgStop("PODE TER HAVIDO ALGUMA IMPORTAÇÃO, POR SEGURANÇA EXCLUA OS MOVIMENTOS E REPITA A OPERAÇÃO !!!")
			Return
		EndIf

		DbSelectArea("TRB1")
		DbSkip()

		// +---------------------------------------------------+
		// | Montagem do Número de Sub-Lote, Documento e Linha |
		// +---------------------------------------------------+

		If _dData == CTOD(SUBS(TRB1->MBUFFER,mv_par03,mv_par04))

			If _nLinha < 999
				_nLinha += 1
			Else
				_nLinha := 1
				_nDoc   += 1

				If _nDoc < 999999
					_nDoc    += 1
				Else
					_nDoc    := 1
					_nSbLote += 1
				EndIf
        
			EndIf

		Else
			_nSbLote := _nDoc := _nLinha := 1
		EndIf
      
Enddo 

// +---------------------+
// | Fecha o Arquivo TXT |
// +---------------------+

fClose(nHdl)
Close(oDlgA)

Return

/*
+---------+-----------+--------+---------------+-------+-------------+
| Função: | _fValPerg | Autor: | Flávio Sardão | Data: | Agosto/2010 |
+---------+-----------+--------+---------------+-------+-------------+
| Uso:    | Verion Óleo Hidráulica Ltda.                             |
+---------+----------------------------------------------------------+
*/

Static Function _fValPerg

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek(cPerg + "01",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Arquivo a Importar      ?"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 30
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "02",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Lote Contábil a Iniciar ?"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "03",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Pos.Inicial Data        ?"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "04",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Tamanho Data            ?"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "05",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Pos.Inicial Cta.Débito  ?"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "06",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Tamanho Conta Cta.Débit ?"
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par06"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "07",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Pos.Inicial Cta.Crédito ?"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par07"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "08",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "08"
	SX1->X1_PERGUNT := "Tamanho Cta.Crédito     ?"
	SX1->X1_VARIAVL := "mv_ch8"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par08"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "09",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "09"
	SX1->X1_PERGUNT := "Pos.Inicial Valor       ?"
	SX1->X1_VARIAVL := "mv_ch9"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par09"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "10",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "10"
	SX1->X1_PERGUNT := "Tamanho Valor           ?"
	SX1->X1_VARIAVL := "mv_cha"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par10"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "11",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "11"
	SX1->X1_PERGUNT := "Pos.Inicial Histórico   ?"
	SX1->X1_VARIAVL := "mv_chb"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par11"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "12",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "12"
	SX1->X1_PERGUNT := "Tamanho Histórico       ?"
	SX1->X1_VARIAVL := "mv_chc"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par12"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "13",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "13"
	SX1->X1_PERGUNT := "Pos.Inicial C.C.Débito  ?"
	SX1->X1_VARIAVL := "mv_chd"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par13"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "14",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "14"
	SX1->X1_PERGUNT := "Tamanho C.C.Débito      ?"
	SX1->X1_VARIAVL := "mv_che"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par14"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "15",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "15"
	SX1->X1_PERGUNT := "Pos.Inicial C.C.Crédito ?"
	SX1->X1_VARIAVL := "mv_chf"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par15"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

If !DbSeek(cPerg + "16",.f.)

	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "16"
	SX1->X1_PERGUNT := "Tamanho C.C.Crédito     ?"
	SX1->X1_VARIAVL := "mv_chg"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par16"
	SX1->X1_F3      := ""
	MsUnLock()

EndIf

Return
