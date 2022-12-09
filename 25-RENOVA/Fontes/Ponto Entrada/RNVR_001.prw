#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
#INCLUDE "PROTDEF.CH"

User Function RNVR_001()
Local cPerg := "RNVR001"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros utilizados                                                                      ³
//³ MV_PAR01 - Matricula De ?                                                                  ³
//³ MV_PAR02 - Matricula Ate ?                                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa imprime relatorio de Planejamento Estrategico "
Local cDesc2       := ""
Local cDesc3       := ""

Private wnrel      := "RNVR_001"
Private cString    := ""
Private aOrd       := Nil
Private limite     := 220
Private tamanho    := "G"
Private titulo     := "Planejamento Estrategico"
Private aReturn    := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nTipo      := 18 //Fixo pois este relatorio somente sera impresso comprimido
Private nLastKey   := 0
Private lEnd       := .F.

AjustaSX1(cPerg)

If ! Pergunte(cPerg)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho,,.F.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica ordem a ser impressa                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a janela com a regua de processamento                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|lEnd| RNVR_001Imp() },Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function RNVR_001Imp
Local nMaxLinhas := 64
Local nLin       := 90
Local cAliasTop  := GetNextAlias()
Local cQuery     := Nil
Local aRela      := {}
Local oRela      := Nil

Local cQuebra    := Nil
Local bQuebra    := Nil
Local Cabec1     := ""

Private M_PAG    := 1     



cQuery := " SELECT * FROM " + RetSqlName("SZ4") + " SZ4 " + ;
          " WHERE SZ4.Z4_FUNC BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND " + ;
          "       SZ4.D_E_L_E_T_ <> '*' AND SZ4.Z4_FILIAL = '" + xFilial("SZ4") + "' "

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery), cAliasTop, .F., .T.)
Cabec1   := "Metas                     Peso      Metrica       Acima      Alvo     Abaixo"
aRela := {	{"Metas"                      , {|| (cAliasTop)->Z4_METAS                      }}, ;
			{"Peso"                       , {|| (cAliasTop)->Z4_PESO                       }, "999"},;
			{"Metrica"                    , {|| (cAliasTop)->Z4_METRICA                    }},;
			{"Acima"                      , {|| (cAliasTop)->Z4_ACIMA                      }},;
			{"Alvo"                       , {|| (cAliasTop)->Z4_ALVO                       }},;
			{"Abaixo"                     , {|| (cAliasTop)->Z4_ABAIXO                     }}}

SetRegua(LastRec())

oRela    := miTMsRela():New(aRela,, .T.)

dbSelectArea(cAliasTop)
dbGoTop()

bQuebra := {|| (cAliasTop)->Z4_FUNC}

Do while (! Eof()) .And. (! lEnd)

	cQuebra := Eval(bQuebra)

	If nLin > (nMaxLinhas - 10) // Comparo com nMaxLinhas para caber o cabecalho senao pulo de pagina
		nLin := Cabec(Titulo, oRela:cCabec1, oRela:cCabec2,wnrel,Tamanho,ntipo) + 1
	Else
		nLin += 3
	Endif

	@ nLin ++, 10 PSAY "Funcionario : " + (cAliasTop)->Z4_FUNC + " - " + (cAliasTop)->Z4_NFUNC
	@ nLin ++, 10 PSAY "Cargo       : " + (cAliasTop)->Z4_CARGO
	@ nLin ++, 10 PSAY "Departamento: " + (cAliasTop)->Z4_DEPTO
	nLin += 2

	Do While (! Eof()) .And. Eval(bQuebra) == cQuebra

		IncRegua()

		If nLin > nMaxLinhas // Comparo com nMaxLinhas para caber o cabecalho senao pulo de pagina
			nLin := Cabec(Titulo, oRela:cCabec1, oRela:cCabec2,wnrel,Tamanho,ntipo) + 1
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lEnd
			@ Prow()+1, 00 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif

		@ nLin ++, 00 PSAY oRela:Detalhe(.T.)

		dbSkip()
	Enddo

Enddo

(cAliasTop)->(dbCloseArea())


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Classe TMsRela³ Autor ³ Marcelo Iuspa     ³ Data ³ 22/02/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Imprime as colunas do relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cliente   ³ VMT/Commcenter                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Class miTMsRela
	DATA cCabec
	DATA cCabec1
	DATA cCabec2
	DATA lQuebraCabec
	DATA cRisco
	DATA aColunas
	DATA nColunas
	DATA nQuant
	DATA cSeparador
	DATA cArqCsv
	DATA lGeraCSV
	DATA nHandleCSV
	DATA lSubTotal
	DATA lTotal

	METHOD New() Constructor
	METHOD Detalhe()
	METHOD PosColuna(nColuna)
	METHOD Traco()
	METHOD Total()
	METHOD ZeraSubTotal()
	METHOD ZeraTotal()
	METHOD CloseCsv()
	METHOD TxtSoma()
	METHOD MontaRel()
EndClass

METHOD ZeraTotal() CLASS miTMsRela
aEval(::aColunas, {|z, w| ::aColunas[w, 7] := 0})
::lTotal := .F.
Return(.T.)

METHOD ZeraSubTotal() CLASS miTMsRela
aEval(::aColunas, {|z, w| ::aColunas[w, 8] := 0})
::lSubTotal := .F.
Return(.T.)

METHOD New(_aColunas, _cSeparador, _lQuebraCabec, _cArqCsv) CLASS miTMsRela
Local uResult := Nil
Local nLoop
Local nCorte
Local nPosSpace
Local bMontaCabec

Default _cSeparador   := Space(2)
Default _lQuebraCabec := .F.

::cSeparador   := _cSeparador
::lQuebraCabec := _lQuebraCabec
::aColunas     := aClone(_aColunas)
::nColunas     := Len(::aColunas)
::cCabec       := ""
::cCabec1      := ""
::cCabec2      := ""
::nQuant       := 0
::cArqCsv      := _cArqCsv

::lTotal       := .F.
::lSubTotal    := .F.
If ::cArqCsv # Nil
/*
	If ! "\" $ ::cArqCsv
		::cArqCsv := "\RELATO\" + ::cArqCsv
	Endif
*/
	If ::lGeraCSV := (::nHandleCSV := Fcreate(::cArqCsv, 0)) > 0
		For nLoop := 1 To Len(::aColunas)
			Fwrite(::nHandleCSV, ::aColunas[nLoop, 1] + If(nLoop < ::nColunas, ";", Chr(13) + Chr(10)))
		Next
	Endif
Endif

/*
	aColunas
	1) Cabecalho
	2) Bloco de codigo com expressao
	3) Picture
	4) Somar (T/F)
*/

For nLoop := 1 To Len(::aColunas)
	aSize(::aColunas[nLoop], 16)
	Default ::aColunas[nLoop, 3] := ""
	Default ::aColunas[nLoop, 4] := .F.
	Default ::aColunas[nLoop, 5] := -1   // -1=Cabecalho alinhado a esquerda; 0=Cabecalho centralizado; 1=Cabecalho alinhado a direita;
	Default ::aColunas[nLoop, 7] := 0     // Total
	Default ::aColunas[nLoop, 8] := 0     // Subtotal
	Default ::aColunas[nLoop, 9] := 0     // Subtotal2

	uResult := Eval(::aColunas[nLoop, 2])
	nCorte  := Nil

	::aColunas[nLoop,  9] := ValType(uResult)                                         // Tipo de dado da coluna
	::aColunas[nLoop, 10] := Len(Transform(uResult, ::aColunas[nLoop, 3]))            // Tamanho do detalhe
	::aColunas[nLoop, 11] := Max(Len(::aColunas[nLoop, 1]), ::aColunas[nLoop, 10])    // Tamanho da coluna

	If ::lQuebraCabec
		If Len(::aColunas[nLoop, 1]) > ::aColunas[nLoop, 10] .And. At(" ", ::aColunas[nLoop, 1]) > 0
			nCorte := Len(::aColunas[nLoop, 1]) / 2
			nCorte += Mod(nCorte, 2) // Forco numero PAR
	
			For nPosSpace := 1 to nCorte
				If Substr(::aColunas[nLoop, 1], nCorte - nPosSpace, 1) == " "
					nCorte := nCorte - nPosSpace
					Exit
				Endif	
	
				If Substr(::aColunas[nLoop, 1], nCorte + nPosSpace, 1) == " "
					nCorte := nCorte + nPosSpace
					Exit
				Endif	
			Next	
			::aColunas[nLoop, 11] := Max(nCorte, ::aColunas[nLoop, 10])     // Tamanho da coluna		
			::aColunas[nLoop, 11] := Max(Len(Substr(::aColunas[nLoop, 1], nCorte + 1)), ::aColunas[nLoop, 11])
		Endif
	Endif

	If ::lGeraCSV
		If ::aColunas[nLoop, 9] == "D"
			::aColunas[nLoop, 12] := {|uResult| Ctod(uResult)}
		ElseIf ::aColunas[nLoop, 9] == "N"
			::aColunas[nLoop, 12] := {|uResult| Alltrim(Transform(uResult, "@E 9999999999999999999.999999"))}
		ElseIf ::aColunas[nLoop, 9] == "C"
			::aColunas[nLoop, 12] := {|uResult| Alltrim(uResult)}
		Else
			::aColunas[nLoop, 12] := {|uResult| Alltrim(Transform(uResult, ""))}
		Endif
	Endif

	If     ::aColunas[nLoop, 5] == -1  // Cabecalho alinhado a esquerda
		bMontaCabec := {|cCabec, nSize| Pad( Alltrim(cCabec), nSize)}
	ElseIf ::aColunas[nLoop, 5] == 0   // Cabecalho centralizado
		bMontaCabec := {|cCabec, nSize| Padc(Alltrim(cCabec), nSize)}
	ElseIf ::aColunas[nLoop, 5] == 1   // Cabecalho alinhado a direita
		bMontaCabec := {|cCabec, nSize| Padl(Alltrim(cCabec), nSize)}
	Endif

	::cCabec += Eval(bMontaCabec, ::aColunas[nLoop, 1],  ::aColunas[nLoop, 11]) + If(nLoop < ::nColunas, ::cSeparador, "")

	If nCorte # Nil
		::cCabec1 += Eval(bMontaCabec, Substr(::aColunas[nLoop, 1], 1, nCorte) ,  ::aColunas[nLoop, 11]) + If(nLoop < ::nColunas, ::cSeparador, "")
		::cCabec2 += Eval(bMontaCabec, Substr(::aColunas[nLoop, 1], nCorte + 1),  ::aColunas[nLoop, 11]) + If(nLoop < ::nColunas, ::cSeparador, "")
	Else
		::cCabec1 += Eval(bMontaCabec, ""                  ,  ::aColunas[nLoop, 11]) + If(nLoop < ::nColunas, ::cSeparador, "")
		::cCabec2 += Eval(bMontaCabec, ::aColunas[nLoop, 1],  ::aColunas[nLoop, 11]) + If(nLoop < ::nColunas, ::cSeparador, "")
	Endif		
Next

::cRisco := Replicate("-", Len(::cCabec))

Return SELF

METHOD Detalhe(lSoma) CLASS miTMsRela
Local nLoop   := Nil
Local cLinha  := ""
Local uResult := Nil

Default lSoma := .F.

For nLoop := 1 to ::nColunas
	uResult := Eval(::aColunas[nLoop, 2])
	cLinha  += Pad(Transform(uResult, ::aColunas[nLoop, 3]), ::aColunas[nLoop, 11])
	cLinha  += If(nLoop < ::nColunas, ::cSeparador, "")
	If lSoma
		::lSubTotal := .T.
		::lTotal    := .T.
		If ::aColunas[nLoop, 4] .And. ValType(uResult) == "N"
			::aColunas[nLoop, 7] += uResult
			::aColunas[nLoop, 8] += uResult
		Endif
	Endif

	If ::lGeraCSV
		Fwrite(::nHandleCSV, Eval(::aColunas[nLoop, 12], uResult) + If(nLoop < ::nColunas, ";", Chr(13) + Chr(10)))
	Endif

Next

Return(cLinha)

METHOD PosColuna(nColuna) CLASS miTMsRela
Local nLoop    := Nil
Local nSomaCol := 0

nColuna --

If nColuna > ::nColunas .Or. nColuna == 0
	Return(0)
Endif	

For nLoop := 1 To nColuna
	nSomaCol += ::aColunas[nLoop, 11] + Len(If(nLoop < ::nColunas, ::cSeparador, ""))
Next
Return(nSomaCol)

METHOD Total(lSubTotal) CLASS miTMsRela
Local nLoop   := Nil
Local cLinha  := ""

Default lSubTotal := .F.

For nLoop := 1 to ::nColunas
	If ::aColunas[nLoop, 4]
		cLinha  += Pad(Transform(::aColunas[nLoop, If(lSubTotal, 8, 7)], ::aColunas[nLoop, 3]), ::aColunas[nLoop, 11])
	Else
		cLinha += Space(::aColunas[nLoop, 11])
	Endif
	cLinha  += If(nLoop < ::nColunas, ::cSeparador, "")
Next
Return(cLinha)

METHOD Traco() CLASS miTMsRela
Local nLoop   := Nil
Local cLinha  := ""

For nLoop := 1 to ::nColunas
	If ::aColunas[nLoop, 4]
		cLinha  += Pad(Replicate("-", ::aColunas[nLoop, 10]), ::aColunas[nLoop, 11])
	Else
		cLinha += Space(::aColunas[nLoop, 11])
	Endif
	cLinha  += If(nLoop < ::nColunas, ::cSeparador, "")
Next
Return(cLinha)

METHOD CloseCsv() CLASS miTMsRela                 


If ::lGeraCSV
	Fclose(::nHandleCSV)
/*
	CpyS2T(::cArqCsv, "C:\", .T. )   // Copia arquivo CSV do Server para o Remote
*/
Endif
Return

METHOD TxtSoma(cFile) CLASS miTMsRela
Local cTexto  := ""
Local nLoop   := Nil
Local nHandle := Nil
Local cTab    := Chr(9)
Local cEnter  := Chr(13) + Chr(10)

For nLoop := 1 to ::nColunas
	If ::aColunas[nLoop, 7] == "N"
		cTexto += ::aColunas[nLoop, 1] + cTab + GetCBSource(::aColunas[nLoop, 2]) + cTab + ::aColunas[nLoop, 3] + cTab + Transform(::aColunas[nLoop, 5], ::aColunas[nLoop, 3]) + cEnter
	Endif
Next
nHandle := fCreate(cFile)
fWrite(nHandle, cTexto)
fClose(nHandle)
Return

METHOD MontaRel() CLASS miTMsRela
Local cTexto := ""
Local nLoop  := Nil
Local cEnter := Chr(13) + Chr(10)

If ::lQuebraCabec
	cTexto += 	'cCabec1 := "' + ::cCabec1 + '"' + cEnter + ;
				'cCabec2 := "' + ::cCabec2 + '"' + cEnter
Else				
	cTexto += 	'cCabec  := "' + ::cCabec  + '"' + cEnter
Endif

For nLoop := 1 to ::nColunas
	cTexto += "@ nLin, " + StrZero(::PosColuna(nLoop), 3) + " PSAY Transform(Eval(" + GetCBSource(::aColunas[nLoop, 2]) + '), "' + ::aColunas[nLoop, 3] + '")' + cEnter
Next	

MemoWrit("MsRela.txt", cTexto)


/*
=====================
Fim da classe TMsRela
=====================
*/


Static Function AjustaSX1(cPerg)
Local aRegs := {}

Aadd(aRegs,{cPerg, "01", "Matricula De ? ", "¿Matricula De ?", "Subscription from ?", "mv_ch1", "C", 6, 0, 0, "G", "        ", "MV_PAR01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA", "S", ""})
Aadd(aRegs,{cPerg, "02", "Matricula Ate ?", "¿Matricula A ? ", "Subscription to ?  ", "mv_ch2", "C", 6, 0, 0, "G", "naovazio", "MV_PAR02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA", "S", ""})

LValidPerg(aRegs)
Return

