#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE 'TopConn.ch'                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFIN001   บAutor  ณMicrosiga           บ Data ณ  11/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณprevisใo de receita e gastos x resumo da obra, faz parte do บฑฑ
ฑฑบ          ณRFIN011                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AFIN001()


Private cAno
Private oAno1
Private cAno1     := Str(Year(dDataBase),4)        //ano de referencia

Private oCodObra
Private cCodObra  := Space(09)               //codigo da obra

Private oCstobra
Private nCstObra := 0                       //valor do custo da obra

Private oDescObra
Private cDescObra := ""                     //descricao da obra

Private oFatJan
Private nFatJan := 0
Private oFatFev
Private nFatFev := 0
Private oFatMar
Private nFatMar := 0
Private oFatAbr
Private nFatAbr := 0
Private oFatMai
Private nFatMai := 0
Private oFatJun
Private nFatJun := 0
Private oFatJul
Private nFatJul := 0
Private oFatAgo
Private nFatAgo := 0
Private oFatSet
Private nFatSet := 0
Private oFatOut
Private nFatOut := 0
Private oFatNov
Private nFatNov := 0
Private oFatDez
Private nFatDez := 0


Private oReal01
Private oReal02
Private oReal03
Private oReal04
Private oReal05
Private oReal06
Private oReal07
Private oReal08
Private oReal09
Private oReal10
Private oReal11
Private oReal12

Private nReal01 := 0
Private nReal02 := 0
Private nReal03 := 0
Private nReal04 := 0
Private nReal05 := 0
Private nReal06 := 0
Private nReal07 := 0
Private nReal08 := 0
Private nReal09 := 0
Private nReal10 := 0
Private nReal11 := 0
Private nReal12 := 0

Private oGstJan
Private nGstJan := 0
Private oGstFev
Private nGstFev := 0
Private oGstMar
Private nGstMar := 0
Private oGstAbr
Private nGstAbr := 0
Private oGstMai
Private nGstMai := 0
Private oGstJun
Private nGstJun := 0
Private oGstJul
Private nGstJul := 0
`Private oGstAgo
Private nGstAgo := 0
Private oGstSet
Private nGstSet := 0
Private oGstOut
Private nGstOut := 0
Private oGstNov
Private nGstNov := 0
Private oGstDez
Private nGstDez := 0
Private oSldJan
Private nSldJan := 0
Private oSldFev
Private nSldFev := 0
Private oSldMar
Private nSldMar := 0
Private oSldAbr
Private nSldAbr := 0
Private oSldMai
Private nSldMai := 0
Private oSldJun
Private nSldJun := 0
Private oSldJul
Private nSldJul := 0
Private oSldAgo
Private nSldAgo := 0
Private oSldSet
Private nSldSet := 0
Private oSldOut
Private nSldOut := 0
Private oSldNov
Private nSldNov := 0
Private oSldDez
Private nSldDez := 0
Private oFDJan
Private nFDJan := 0
Private oFDFev
Private nFDFev := 0
Private oFDMar
Private nFDMar := 0
Private oFDAbr
Private nFDAbr := 0
Private oFDMai
Private nFDMai := 0
Private oFDJun
Private nFDJun := 0
Private oFDJul
Private nFDJul := 0
Private oFDAgo
Private nFDAgo := 0
Private oFDSet
Private nFDSet := 0
Private oFDOut
Private nFDOut := 0
Private oFDNov
Private nFDNov := 0
Private oFDDez
Private nFDDez := 0

Private lWhenJan := .T.
Private lWhenFev := .T.
Private lWhenMar := .T.
Private lWhenAbr := .T.
Private lWhenMai := .T.
Private lWhenJun := .T.
Private lWhenJul := .T.
Private lWhenAgo := .T.
Private lWhenSet := .T.
Private lWhenOut := .T.
Private lWhenNov := .T.
Private lWhenDez := .T.
Private oDstFat
Private nDstFat   := 0
Private oDstGst
Private nDstGst   := 0

Private oPrvFat
Private nPrvFat   := 0
Private oPrvGst
Private nPrvGst     := 0
Private nPrvFat_A   := 0
Private nPrvGst_A   := 0
Private oTotFat
Private nTotFat   := 0
Private oTotGst
Private nTotGst   := 0
Private oTotFD
Private nTotFD    := 0
Private nVlrObr
Private oVlrObra
Private nVlrObra  := 0
Private oFatDir
Private nFatDir   := 0
Private oBt_Canc
Private oBt_Ok
Private oPanel1
Private oSay1
Private oSay10
Private oSay11
Private oSay12
Private oSay13
Private oSay14
Private oSay15
Private oSay16
Private oSay17
Private oSay18
Private oSay2
Private oSay3
Private oSay4
Private oSay5
Private oSay6
Private oSay7
Private oSay8
Private oSay9
Private oFont1   := TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
Private oFont2   := TFont():New("MS Sans Serif",,018,,.T.,,,,,.F.,.F.)
Private oFont3   := TFont():New("Courier New"  ,,017,,.T.,,,,,.F.,.F.)
Private oFont4   := TFont():New("MS Sans Serif",,016,,.F.,,,,,.F.,.F.)
Private nCount   := 0
Private cOpc     := ""
Private dDtSrv   := GetRmtDate()
Private cAnoSrv  := Str(Year(GetRmtDate()),4)
Private cMesSrv  := StrZero(Month(GetRmtDate()),2)
Private a_rdados := {}
Private a_pdados := {}
//Private a_saldo  := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}
Private a_dtprev := {stod(''),stod(''),stod(''),stod(''),stod(''),stod(''),stod(''),stod(''),stod(''),stod(''),stod(''),stod('')}

Static oDlg

DEFINE MSDIALOG oDlg TITLE "Previsใo de Faturamento e de Despesas" FROM 000, 000  TO 655, 1262 COLORS 0, 16777215 PIXEL

@ 003, 000 MSPANEL oPanel1 PROMPT "" SIZE 630, 370 OF oDlg COLORS 0, 11206655 FONT oFont1 CENTERED LOWERED
@ 107, 010 MSPANEL oPanel2 PROMPT "" SIZE 611, 125 OF oDlg COLORS 0, 4760831  FONT oFont1 CENTERED RAISED

@ 005, 055 GROUP oGroup1 TO 050, 565 PROMPT "[ Parโmetros ]" OF oPanel1 COLOR 8388608, 16777215 PIXEL

@ 016, 068 SAY   oSay5     PROMPT "Obra"         SIZE 025, 010 OF oPanel1 FONT oFont1 COLORS 8388608, 16777215 PIXEL
@ 013, 088 MSGET oCodObra  VAR    cCodObra       SIZE 050, 010 OF oPanel1 FONT oFont1 COLORS 8388608, 16777215 PIXEL Picture "@!"F3 "CTT" VALID Vld_Obra()
@ 016, 148 SAY   oDescObra PROMPT cDescObra      SIZE 200, 010 OF oPanel1 FONT oFont2 COLORS 8388608, 16777215 PIXEL
@ 033, 068 SAY   cAno      PROMPT "Ano"          SIZE 022, 010 OF oPanel1 FONT oFont1 COLORS 8388608, 16777215 PIXEL
@ 031, 088 MSGET oAno1     VAR    cAno1          SIZE 030, 010 OF oPanel1 FONT oFont1 COLORS 8388608, 16777215 PIXEL Picture "9999" VALID Previsao().And.Realizado()

@ 053, 055 GROUP oGroup1 TO 101, 161 PROMPT "[ Contrato ]"      OF oPanel1 COLOR 8388608, 16777215 PIXEL
@ 053, 186 GROUP oGroup1 TO 101, 292 PROMPT "[ A Distribuir ]"  OF oPanel1 COLOR 8388608, 16777215 PIXEL
@ 053, 317 GROUP oGroup1 TO 101, 433 PROMPT "[ Previsใo ]"      OF oPanel1 COLOR 8388608, 16777215 PIXEL
@ 053, 458 GROUP oGroup1 TO 101, 565 PROMPT "[ Realizado ]"     OF oPanel1 COLOR 8388608, 16777215 PIXEL

@ 065, 063 SAY   nVlrObr   PROMPT "Valor Obra" SIZE 030, 010 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 065, 103 SAY   nVlrObra                      SIZE 070, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL Picture "@RE 99,999,999.99"
@ 077, 063 SAY   oSay6     PROMPT "Custo Obra" SIZE 032, 010 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 077, 103 SAY   nCstObra                      SIZE 070, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL Picture "@RE 99,999,999.99"
@ 089, 063 SAY   oSay6     PROMPT "Fat.Direto" SIZE 032, 010 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 089, 103 SAY   nFatDir                       SIZE 070, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL Picture "@RE 99,999,999.99"
//A Distribuir
@ 065, 192 SAY   oSay15    PROMPT "Medi็ใo"    SIZE 085, 010 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 065, 233 SAY   oDstFat   Prompt nDstFat      SIZE 070, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL Picture "@RE 99,999,999.99"
@ 077, 192 SAY   oSay16    PROMPT "Despesa"    SIZE 070, 010 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 077, 233 SAY   oDstGst   Prompt nDstGst      SIZE 070, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL Picture "@RE 99,999,999.99"
//Previsใo
@ 065, 323 SAY   oSay15    PROMPT "Medi็ใo"    SIZE 085, 010 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 065, 375 SAY   oPrvFat   Prompt nPrvFat      SIZE 070, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL Picture "@RE 99,999,999.99"
@ 077, 323 SAY   oSay16    PROMPT "Despesa"    SIZE 070, 010 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 077, 375 SAY   oPrvGst   Prompt nPrvGst      SIZE 070, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL Picture "@RE 99,999,999.99"
//Realizado
@ 065, 464 SAY   oSay17    PROMPT "Medi็ใo"    SIZE 070, 010 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 065, 505 SAY   oTotFat   Prompt nTotFat      SIZE 070, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL Picture "@RE 99,999,999.99"
@ 077, 464 SAY   oSay18    PROMPT "Despesa"    SIZE 060, 010 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 077, 505 SAY   oTotGst   Prompt nTotGst      SIZE 070, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL Picture "@RE 99,999,999.99"
@ 089, 464 SAY   oSay18    PROMPT "Fat.Direto" SIZE 060, 010 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 089, 505 SAY   oTotFD    Prompt nTotFD       SIZE 070, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL Picture "@RE 99,999,999.99"

@ 000, 001 GROUP oGroup2 TO 123, 610 PROMPT "[ PREVISีES MENSAIS ]" OF oPanel2 COLOR 8388608, 0 PIXEL
@ 007, 004 GROUP oGroup2 TO 120, 607 PROMPT ""                      OF oPanel2 COLOR 0, 16777215 PIXEL

a_colsay := {021, 121, 221, 321, 421, 521}
a_colmes := {014, 114, 214, 314, 414, 514}
a_colget := {049, 149, 249, 349, 449, 549}

n_lin := 008
@ n_lin, a_colmes[01] SAY   oSay1 PROMPT "Janeiro"   SIZE 039, 006 OF oPanel2 FONT oFont1 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colmes[02] SAY   oSay2 PROMPT "Fevereiro" SIZE 039, 006 OF oPanel2 FONT oFont1 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colmes[03] SAY   oSay3 PROMPT "Mar็o"     SIZE 039, 006 OF oPanel2 FONT oFont1 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colmes[04] SAY   oSay4 PROMPT "Abril"     SIZE 039, 006 OF oPanel2 FONT oFont1 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colmes[05] SAY   oSay7 PROMPT "Maio"      SIZE 039, 006 OF oPanel2 FONT oFont1 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colmes[06] SAY   oSay8 PROMPT "Junho"     SIZE 039, 006 OF oPanel2 FONT oFont1 COLORS 8388608, 16777215 PIXEL

n_lin += 5
@ n_lin, a_colget[01] MSGET oFatjan VAR nFatjan      SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenJan VALID Saldo() .and. fValLim()
@ n_lin, a_colget[02] MSGET oFatFev VAR nFatFev      SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenFev VALID Saldo() .and. fValLim()
@ n_lin, a_colget[03] MSGET oFatMar VAR nFatMar      SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenMar VALID Saldo() .and. fValLim()
@ n_lin, a_colget[04] MSGET oFatAbr VAR nFatAbr      SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenAbr VALID Saldo() .and. fValLim()
@ n_lin, a_colget[05] MSGET oFatMai VAR nFatMai      SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenMai VALID Saldo() .and. fValLim()
@ n_lin, a_colget[06] MSGET oFatJun VAR nFatJun      SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenJun VALID Saldo() .and. fValLim()

n_lin += 2
@ n_lin, a_colsay[01] SAY   oSay4 PROMPT "Medi็ใo"   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[02] SAY   oSay4 PROMPT "Medi็ใo"   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[03] SAY   oSay4 PROMPT "Medi็ใo"   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[04] SAY   oSay4 PROMPT "Medi็ใo"   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[05] SAY   oSay4 PROMPT "Medi็ใo"   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[06] SAY   oSay4 PROMPT "Medi็ใo"   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL

n_lin  += 8
odtjan := nil

@ n_lin, a_colget[01] MSGET odtjan VAR a_dtprev[01] SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL WHEN lWhenJan //  //VALID Saldo() .and. fValLim()
@ n_lin, a_colget[02] MSGET odtjan VAR a_dtprev[02] SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL WHEN lWhenFev //PICTURE "@RE 99,999,999.99" //VALID Saldo() .and. fValLim()
@ n_lin, a_colget[03] MSGET odtjan VAR a_dtprev[03] SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL WHEN lWhenMar //PICTURE "@RE 99,999,999.99"  //VALID Saldo() .and. fValLim()
@ n_lin, a_colget[04] MSGET odtjan VAR a_dtprev[04] SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL WHEN lWhenAbr //PICTURE "@RE 99,999,999.99" WHEN lWhenJan //VALID Saldo() .and. fValLim()
@ n_lin, a_colget[05] MSGET odtjan VAR a_dtprev[05] SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL WHEN lWhenMai //PICTURE "@RE 99,999,999.99" WHEN lWhenJan //VALID Saldo() .and. fValLim()
@ n_lin, a_colget[06] MSGET odtjan VAR a_dtprev[06] SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL WHEN lWhenJun //PICTURE "@RE 99,999,999.99" WHEN lWhenJan //VALID Saldo() .and. fValLim()

n_lin += 2
@ n_lin, a_colsay[01] SAY   oSaya PROMPT "Dt.Prev."   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[02] SAY   oSaya PROMPT "Dt.Prev."   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[03] SAY   oSaya PROMPT "Dt.Prev."   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[04] SAY   oSaya PROMPT "Dt.Prev."   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[05] SAY   oSaya PROMPT "Dt.Prev."   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[06] SAY   oSaya PROMPT "Dt.Prev."   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL

n_lin += 8

@ n_lin, a_colget[01] MSGET oGstJan VAR nGstJan      SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenJan VALID Saldo()
@ n_lin, a_colget[02] MSGET oGstFev VAR nGstFev      SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenFev VALID Saldo()
@ n_lin, a_colget[03] MSGET oGstMar VAR nGstMar      SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenMar VALID Saldo()
@ n_lin, a_colget[04] MSGET oGstAbr VAR nGstAbr      SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenAbr VALID Saldo()
@ n_lin, a_colget[05] MSGET oGstMai VAR nGstMai      SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenMai VALID Saldo()
@ n_lin, a_colget[06] MSGET oGstJun VAR nGstJun      SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenJun VALID Saldo()

n_lin += 2
@ n_lin, a_colsay[01] SAY   oSay4 PROMPT "Despesa"   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[02] SAY   oSay4 PROMPT "Despesa"   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[03] SAY   oSay4 PROMPT "Despesa"   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[04] SAY   oSay4 PROMPT "Despesa"   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[05] SAY   oSay4 PROMPT "Despesa"   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[06] SAY   oSay4 PROMPT "Despesa"   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL

n_lin += 008
@ n_lin, a_colsay[01] SAY   oSay4 PROMPT "Saldo"     SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[02] SAY   oSay4 PROMPT "Saldo"     SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[03] SAY   oSay4 PROMPT "Saldo"     SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[04] SAY   oSay4 PROMPT "Saldo"     SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[05] SAY   oSay4 PROMPT "Saldo"     SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[06] SAY   oSay4 PROMPT "Saldo"     SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL

@ n_lin, a_colget[01] SAY   oSldJan PROMPT nSldJan   SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[02] SAY   oSldFev PROMPT nSldFev   SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[03] SAY   oSldMar PROMPT nSldMar   SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[04] SAY   oSldAbr PROMPT nSldAbr   SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[05] SAY   oSldMai PROMPT nSldMai   SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[06] SAY   oSldJun PROMPT nSldJun   SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"

n_lin += 008
@ n_lin, a_colsay[01] SAY   oSay4 PROMPT "Med. Real" SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[02] SAY   oSay4 PROMPT "Med. Real" SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[03] SAY   oSay4 PROMPT "Med. Real" SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[04] SAY   oSay4 PROMPT "Med. Real" SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[05] SAY   oSay4 PROMPT "Med. Real" SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[06] SAY   oSay4 PROMPT "Med. Real" SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL

@ n_lin, a_colget[01] SAY   oReal01 PROMPT nReal01 SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[02] SAY   oReal02 PROMPT nReal02 SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[03] SAY   oReal03 PROMPT nReal03 SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[04] SAY   oReal04 PROMPT nReal04 SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[05] SAY   oReal05 PROMPT nReal05 SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[06] SAY   oReal06 PROMPT nReal06 SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"

n_lin := 064
@ n_lin, a_colmes[01] SAY   oSay9  PROMPT "Julho"    SIZE 039, 006 OF oPanel2 FONT oFont1 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colmes[02] SAY   oSay10 PROMPT "Agosto"   SIZE 039, 006 OF oPanel2 FONT oFont1 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colmes[03] SAY   oSay11 PROMPT "Setembro" SIZE 039, 006 OF oPanel2 FONT oFont1 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colmes[04] SAY   oSay12 PROMPT "Outubro"  SIZE 039, 006 OF oPanel2 FONT oFont1 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colmes[05] SAY   oSay13 PROMPT "Novembro" SIZE 039, 006 OF oPanel2 FONT oFont1 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colmes[06] SAY   oSay14 PROMPT "Dezembro" SIZE 039, 006 OF oPanel2 FONT oFont1 COLORS 8388608, 16777215 PIXEL

n_lin += 5
@ n_lin, a_colget[01] MSGET oFatJul VAR nFatJul      SIZE 053, 010 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenJul VALID Saldo() .and. fValLim()
@ n_lin, a_colget[02] MSGET oFatAgo VAR nFatAgo      SIZE 053, 010 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenAgo VALID Saldo() .and. fValLim()
@ n_lin, a_colget[03] MSGET oFatSet VAR nFatSet      SIZE 053, 010 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenSet VALID Saldo() .and. fValLim()
@ n_lin, a_colget[04] MSGET oFatOut VAR nFatOut      SIZE 053, 010 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenOut VALID Saldo() .and. fValLim()
@ n_lin, a_colget[05] MSGET oFatNov VAR nFatNov      SIZE 053, 010 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenNov VALID Saldo() .and. fValLim()
@ n_lin, a_colget[06] MSGET oFatDez VAR nFatDez      SIZE 053, 010 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenDez VALID Saldo() .and. fValLim()

n_lin += 2 // := 079
@ n_lin, a_colsay[01] SAY   oSay4  PROMPT "Medi็ใo"  SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[02] SAY   oSay4  PROMPT "Medi็ใo"  SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[03] SAY   oSay4  PROMPT "Medi็ใo"  SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[04] SAY   oSay4  PROMPT "Medi็ใo"  SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[05] SAY   oSay4  PROMPT "Medi็ใo"  SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[06] SAY   oSay4  PROMPT "Medi็ใo"  SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL

n_lin += 08 // := 090

@ n_lin, a_colget[01] MSGET odtjan VAR a_dtprev[07] SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL WHEN lWhenJul //  //VALID Saldo() .and. fValLim()
@ n_lin, a_colget[02] MSGET odtjan VAR a_dtprev[08] SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL WHEN lWhenAgo //PICTURE "@RE 99,999,999.99" //VALID Saldo() .and. fValLim()
@ n_lin, a_colget[03] MSGET odtjan VAR a_dtprev[09] SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL WHEN lWhenSet //PICTURE "@RE 99,999,999.99"  //VALID Saldo() .and. fValLim()
@ n_lin, a_colget[04] MSGET odtjan VAR a_dtprev[10] SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL WHEN lWhenOut //PICTURE "@RE 99,999,999.99" WHEN lWhenJan //VALID Saldo() .and. fValLim()
@ n_lin, a_colget[05] MSGET odtjan VAR a_dtprev[11] SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL WHEN lWhenNov //PICTURE "@RE 99,999,999.99" WHEN lWhenJan //VALID Saldo() .and. fValLim()
@ n_lin, a_colget[06] MSGET odtjan VAR a_dtprev[12] SIZE 053, 004 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL WHEN lWhenDez //PICTURE "@RE 99,999,999.99" WHEN lWhenJan //VALID Saldo() .and. fValLim()

n_lin += 2
@ n_lin, a_colsay[01] SAY   oSaya PROMPT "Dt.Prev."   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[02] SAY   oSaya PROMPT "Dt.Prev."   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[03] SAY   oSaya PROMPT "Dt.Prev."   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[04] SAY   oSaya PROMPT "Dt.Prev."   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[05] SAY   oSaya PROMPT "Dt.Prev."   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[06] SAY   oSaya PROMPT "Dt.Prev."   SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL

n_lin += 08 // := 090
@ n_lin, a_colget[01] MSGET oGstJul VAR nGstJul      SIZE 053, 010 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenJul VALID Saldo()
@ n_lin, a_colget[02] MSGET oGstAgo VAR nGstAgo      SIZE 053, 010 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenAgo VALID Saldo()
@ n_lin, a_colget[03] MSGET oGstSet VAR nGstSet      SIZE 053, 010 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenSet VALID Saldo()
@ n_lin, a_colget[04] MSGET oGstOut VAR nGstOut      SIZE 053, 010 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenOut VALID Saldo()
@ n_lin, a_colget[05] MSGET oGstNov VAR nGstNov      SIZE 053, 010 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenNov VALID Saldo()
@ n_lin, a_colget[06] MSGET oGstDez VAR nGstDez      SIZE 053, 010 OF oPanel2 FONT oFont1 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99" WHEN lWhenDez VALID Saldo()


n_lin += 2 // := 092
@ n_lin, a_colsay[01] SAY   oSay4  PROMPT "Despesa"  SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[02] SAY   oSay4  PROMPT "Despesa"  SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[03] SAY   oSay4  PROMPT "Despesa"  SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[04] SAY   oSay4  PROMPT "Despesa"  SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[05] SAY   oSay4  PROMPT "Despesa"  SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[06] SAY   oSay4  PROMPT "Despesa"  SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL

n_lin += 009 // := 105

@ n_lin, a_colsay[01] SAY   oSay4  PROMPT "Saldo"    SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[02] SAY   oSay4  PROMPT "Saldo"    SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[03] SAY   oSay4  PROMPT "Saldo"    SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[04] SAY   oSay4  PROMPT "Saldo"    SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[05] SAY   oSay4  PROMPT "Saldo"    SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[06] SAY   oSay4  PROMPT "Saldo"    SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL

@ n_lin, a_colget[01] SAY   oSldJul VAR nSldJul      SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[02] SAY   oSldAgo VAR nSldAgo      SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[03] SAY   oSldSet VAR nSldSet      SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[04] SAY   oSldOut VAR nSldOut      SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[05] SAY   oSldNov VAR nSldNov      SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[06] SAY   oSldDez VAR nSldDez      SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"

n_lin += 08
@ n_lin, a_colsay[01] SAY   oSay4  PROMPT "Med. Real" SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[02] SAY   oSay4  PROMPT "Med. Real" SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[03] SAY   oSay4  PROMPT "Med. Real" SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[04] SAY   oSay4  PROMPT "Med. Real" SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[05] SAY   oSay4  PROMPT "Med. Real" SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ n_lin, a_colsay[06] SAY   oSay4  PROMPT "Med. Real" SIZE 039, 006 OF oPanel2 FONT oFont4 COLORS 8388608, 16777215 PIXEL

@ n_lin, a_colget[01] SAY   oReal07 VAR nReal07 SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[02] SAY   oReal08 VAR nReal08 SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[03] SAY   oReal09 VAR nReal09 SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[04] SAY   oReal10 VAR nReal10 SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[05] SAY   oReal11 VAR nReal11 SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ n_lin, a_colget[06] SAY   oReal12 VAR nReal12 SIZE 053, 010 OF oPanel2 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"


@ 237, 010 GROUP oGroup2 TO 280, 620 PROMPT "[ Faturamento Direto ]" OF oPanel1 COLOR 8388608, 16777215 PIXEL

@ 249, 024 SAY   oSay1  PROMPT "Janeiro"   SIZE 039, 006 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 249, 124 SAY   oSay2  PROMPT "Fevereiro" SIZE 039, 006 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 249, 224 SAY   oSay3  PROMPT "Mar็o"     SIZE 039, 006 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 249, 324 SAY   oSay4  PROMPT "Abril"     SIZE 039, 006 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 249, 424 SAY   oSay7  PROMPT "Maio"      SIZE 039, 006 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 249, 524 SAY   oSay8  PROMPT "Junho"     SIZE 039, 006 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 249, 050 SAY   oFDJan PROMPT nFDJan      SIZE 053, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ 249, 150 SAY   oFDFev PROMPT nFDFev      SIZE 053, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ 249, 250 SAY   oFDMar PROMPT nFDMar      SIZE 053, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ 249, 350 SAY   oFDAbr PROMPT nFDAbr      SIZE 053, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ 249, 450 SAY   oFDMai PROMPT nFDMai      SIZE 053, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ 249, 550 SAY   oFDJun PROMPT nFDJun      SIZE 053, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ 264, 024 SAY   oSay9  PROMPT "Julho"     SIZE 039, 006 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 264, 124 SAY   oSay10 PROMPT "Agosto"    SIZE 039, 006 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 264, 224 SAY   oSay11 PROMPT "Setembro"  SIZE 039, 006 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 264, 324 SAY   oSay12 PROMPT "Outubro"   SIZE 039, 006 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 264, 424 SAY   oSay13 PROMPT "Novembro"  SIZE 039, 006 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 264, 524 SAY   oSay14 PROMPT "Dezembro"  SIZE 039, 006 OF oPanel1 FONT oFont4 COLORS 8388608, 16777215 PIXEL
@ 264, 050 SAY   oFDJul PROMPT nFDJul      SIZE 053, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ 264, 150 SAY   oFDAgo PROMPT nFDAgo      SIZE 053, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ 264, 250 SAY   oFDSet PROMPT nFDSet      SIZE 053, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ 264, 350 SAY   oFDOut PROMPT nFDOut      SIZE 053, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ 264, 450 SAY   oFDNov PROMPT nFDNov      SIZE 053, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"
@ 264, 550 SAY   oFDDez PROMPT nFDDez      SIZE 053, 010 OF oPanel1 FONT oFont3 COLORS 0      , 16777215 PIXEL PICTURE "@RE 99,999,999.99"

@ 295, 380 BUTTON oButton1  PROMPT "Confirmar"    SIZE 050, 020 OF oDlg ACTION (Bt_Act1(),oDlg:End()) PIXEL MESSAGE "Confirmar Previs๕es"
@ 295, 460 BUTTON oButton2  PROMPT "Cancelar"     SIZE 050, 020 OF oDlg ACTION oDlg:End()              PIXEL MESSAGE "Cancelar a Manuten็ใo das Previs๕es"

ACTIVATE MSDIALOG oDlg CENTERED

Return




//confirmar as previsoes
Static Function Bt_Act1()
Local nI

a_receita := {nFatJan, nFatFev, nFatMar, nFatAbr, nFatMai, nFatJun, nFatJul, nFatAgo, nFatSet, nFatOut, nFatNov, nFatDez}
a_despesa := {nGstJan, nGstFev, nGstMar, nGstAbr, nGstMai, nGstJun, nGstJul, nGstAgo, nGstSet, nGstOut, nGstNov, nGstDez}

If MsgBox("Deseja confirmar as previs๕es ?","Previsใo","YESNO")
	If cOpc = "I"
		For nI := 1 To 12
			RecLock('SZE',.T.)
			SZE->ZE_VERSAO	:= '001'
			SZE->ZE_OBRA	:= cCodObra
			SZE->ZE_ANO 	:= cAno1
			SZE->ZE_MES		:= StrZero(nI,2)
			SZE->ZE_DATA	:= a_dtprev[nI]
			SZE->ZE_RECEITA	:= a_receita[nI]
			SZE->ZE_DESPESA := a_despesa[nI]
			MsUnLock()
			RecLock("SZ9",.T.)
			SZ9->Z9_OBRA	:= cCodObra
			SZ9->Z9_ANO		:= cAno1
			SZ9->Z9_MES		:= StrZero(nI,2)
			SZ9->Z9_DATA	:= a_dtprev[nI]
			SZ9->Z9_RECEITA	:= a_receita[nI]
			SZ9->Z9_DESPESA	:= a_despesa[nI]
			MsUnLock()
		Next
	Else
		For nI := 1 To 12
			DbSelectArea("SZE")
			DbSetOrder(1) //ZE_FILIAL+ZE_OBRA+ZE_ANO+ZE_MES+ZE_VERSAO
			DbSeek(xFilial("SZE")+cCodObra+cAno1+StrZero(nI,2))
			c_versao:= '001'
			d_dtSZE	:= stod('')
			n_reSZE	:= 0
			n_deSZE	:= 0
			
			While SZE->(!EOF()) .and. SZE->(ZE_FILIAL+ZE_OBRA+ZE_ANO+ZE_MES) = xFilial("SZE")+cCodObra+cAno1+StrZero(nI,2)
				c_versao:= SZE->ZE_VERSAO
				d_dtSZE	:= SZE->ZE_DATA
				n_reSZE	:= SZE->ZE_RECEITA
				n_deSZE	:= SZE->ZE_DESPESA
				SZE->(DbSkip())
			EndDo
			
			If d_dtSZE <> a_dtprev[nI] .or. n_reSZE <> a_receita[nI] .or. n_deSZE <> a_despesa[nI]
				c_versao := soma1(c_versao)
				RecLock('SZE', .T.)
				SZE->ZE_VERSAO	:= c_versao
				SZE->ZE_OBRA	:= cCodObra
				SZE->ZE_ANO 	:= cAno1
				SZE->ZE_MES		:= StrZero(nI,2)
				SZE->ZE_DATA	:= a_dtprev[nI]
				SZE->ZE_RECEITA	:= a_receita[nI]
				SZE->ZE_DESPESA := a_despesa[nI]
				MsUnLock()
			EndIf
			
			DbSelectArea("SZ9")
			DbSeek(xFilial("SZ9")+cCodObra+cAno1+StrZero(nI,2))
			RecLock("SZ9",.F.)
			SZ9->Z9_DATA := a_dtprev[nI]
			SZ9->Z9_RECEITA := a_receita[nI]
			SZ9->Z9_DESPESA := a_despesa[nI]
			MsUnLock()
		Next
		oDlg:End()
	EndIf
Endif

Return



//valida codigo da obra
Static Function Vld_Obra()

Local aColAux


cDescObra := Space(40)
oDescObra:Refresh()

nFatJan := 0
nFatFev := 0
nFatMar := 0
nFatAbr := 0
nFatMai := 0
nFatJun := 0
nFatJul := 0
nFatAgo := 0
nFatSet := 0
nFatOut := 0
nFatNov := 0
nFatDez := 0

nGstJan := 0
nGstFev := 0
nGstMar := 0
nGstAbr := 0
nGstMai := 0
nGstJun := 0
nGstJul := 0
nGstAgo := 0
nGstSet := 0
nGstOut := 0
nGstNov := 0
nGstDez := 0
nSldJan := 0
nSldFev := 0
nSldMar := 0
nSldAbr := 0
nSldMai := 0
nSldJun := 0
nSldJul := 0
nSldAgo := 0
nSldSet := 0
nSldOut := 0
nSldNov := 0
nSldDez := 0

lWhenJan := .T.
lWhenFev := .T.
lWhenMar := .T.
lWhenAbr := .T.
lWhenMai := .T.
lWhenJun := .T.
lWhenJul := .T.
lWhenAgo := .T.
lWhenSet := .T.
lWhenOut := .T.
lWhenNov := .T.
lWhenDez := .T.

nDstFat   := 0
nDstGst   := 0
nPrvFat   := 0
nPrvGst   := 0
nPrvFat_A := 0
nPrvGst_A := 0
nTotFat   := 0
nTotGst   := 0
nVlrObra  := 0
oDstFat:nClrText := 0
oDstGst:nClrText := 0
oPrvFat:nClrText := 0
oDstGst:nClrText := 0
oTotFat:nClrText := 0
oTotGst:nClrText := 0
oDstFat:Refresh()
oDstGst:Refresh()
oPrvFat:Refresh()
oPrvGst:Refresh()
oTotFat:Refresh()
oTotGst:Refresh()

oFatJan:Refresh()
oFatFev:Refresh()
oFatMar:Refresh()
oFatAbr:Refresh()
oFatMai:Refresh()
oFatJun:Refresh()
oFatJul:Refresh()
oFatAgo:Refresh()
oFatSet:Refresh()
oFatOut:Refresh()
oFatNov:Refresh()
oFatDez:Refresh()
oGstJan:Refresh()
oGstFev:Refresh()
oGstMar:Refresh()
oGstAbr:Refresh()
oGstMai:Refresh()
oGstJun:Refresh()
oGstJul:Refresh()
oGstAgo:Refresh()
oGstSet:Refresh()
oGstOut:Refresh()
oGstNov:Refresh()
oGstDez:Refresh()

oReal01:Refresh()
oReal02:Refresh()
oReal03:Refresh()
oReal04:Refresh()
oReal05:Refresh()
oReal06:Refresh()
oReal07:Refresh()
oReal08:Refresh()
oReal09:Refresh()
oReal10:Refresh()
oReal11:Refresh()
oReal12:Refresh()

oSldJan:nClrText := 0
oSldFev:nClrText := 0
oSldMar:nClrText := 0
oSldAbr:nClrText := 0
oSldMai:nClrText := 0
oSldJun:nClrText := 0
oSldJul:nClrText := 0
oSldAgo:nClrText := 0
oSldSet:nClrText := 0
oSldOut:nClrText := 0
oSldNov:nClrText := 0
oSldDez:nClrText := 0

oSldJan:Refresh()
oSldFev:Refresh()
oSldMar:Refresh()
oSldAbr:Refresh()
oSldMai:Refresh()
oSldJun:Refresh()
oSldJul:Refresh()
oSldAgo:Refresh()
oSldSet:Refresh()
oSldOut:Refresh()
oSldNov:Refresh()
oSldDez:Refresh()

a_dtprev := {stod(''),stod(''),stod(''),stod(''),stod(''),stod(''),stod(''),stod(''),stod(''),stod(''),stod(''),stod('')}

DbSelectArea("AF8")
DbOrderNickName("CODBRA")
If !DbSeek(xFilial("AF8")+cCodObra)
	MsgBox("C๓digo da obra nใo encontrada","Previsใo","ALERT")
	Return(.F.)
EndIf
If AF8->AF8_ENCPRJ = "1"
	MsgBox("Projeto Encerrado","Previsใo","ALERT")
	Return(.F.)
EndIf
cCodObra := Substr(AF8->AF8_CODOBR,1,9)
cCodProj := AF8->AF8_PROJET
cRevisao := AF8->AF8_REVISA

nCstObra := 0
If DbSeek(xFilial('AF8')+cCodObra)
	Do While AF8->AF8_CODOBR = cCodObra
		nCstObra += fRetCusto(AF8->AF8_PROJET, AF8->AF8_REVISA)
		AF8->(DbSkip())
	EndDo
EndIf

If !Empty(cCodObra)
	DbSelectArea("AF9")
	DbSetOrder(1)
	If DbSeek(xFilial("AF9")+cCodProj+cRevisao)
		DbSelectArea("CTT")
		If DbSeek(xFilial("CTT")+cCodObra)
			cDescObra := CTT->CTT_DESC01
			If CTT->CTT_MSBLQL = "1"
				MsgBox("Obra BLOQUEADA no cadastro de Obra. Verificar com Depto.Financeiro","Previsใo", "ALERT")
				Return(.F.)
			EndIf
			nVlrObra := CTT->CTT_XVLR
			nFatDir  := CTT->CTT_XFATD
		Else
			MsgBox("Obra nใo cadastrada na Tabela CTT. Existe inconsist๊ncia AF8 x CTT","Previsใo","ALERT")
			Return(.F.)
		EndIf
	EndIf
Else
	If Empty(cCodObra)
		MsgBox("C๓digo da obra indefinida.","Previsใo","ALERT")
		Return(.F.)
	EndIf
EndIf

Return .T.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRetCusto บAutor  ณAlexandre Sousa     บ Data ณ  11/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o custo do orcamento.                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fRetCusto(c_prj, c_rev)

Local n_Ret := 0

c_query := " select * from "+RetSqlName('AFC')+" "
c_query += " where AFC_PROJET = '"+c_prj+"' "
c_query += " and   AFC_REVISA = '0001'"
c_query += " and   D_E_L_E_T_ = '' "
c_query += " and   AFC_NIVEL = '001' "
c_query += " and   AFC_FILIAL = '"+xFilial('AFC')+"' "

MemoWrite("AFIN001_AFC",c_query)

If Select("TRP") > 0
	DbSelectArea("TRP")
	DbCloseArea()
EndIf

TcQuery c_Query New Alias "TRP"

If TRP->(!EOF())
	n_Ret := TRP->AFC_CUSTO
EndIf


Return n_Ret






Static Function Previsao()

Local cQuery
Local lRet    := .T.
Local nCount1 := 0

cQuery := "SELECT * "
cQuery += "FROM "+RetSqlName('SZ9')+" "
cQuery += "WHERE Z9_FILIAL = '"+xFilial('SZ9')+"' "
cQuery += "      AND Z9_OBRA = '"+cCodObra+"' "
cQuery += "      AND Z9_ANO = '"+cAno1+"' "
cQuery += "      AND D_E_L_E_T_ = '' "
cQuery += "ORDER BY Z9_MES "

MemoWrite("AFIN001_prv2",cQuery)

If Select("Z9TMP") > 0
	DbSelectArea("Z9TMP")
	DbCloseArea()
EndIf

TcQuery cQuery New Alias "Z9TMP"

TcSetField("Z9TMP","Z9_DATA","D",8)

nCount  := 0

DbGoTop()
DbeVal({||nCount++})
If nCount > 0
	cOpc    := "A"
	DbGoTop()
	Do While !Eof()
		Do Case
			Case Z9TMP->Z9_MES = "01"
				nFatJan   := Z9TMP->Z9_RECEITA
				nGstJan   := Z9TMP->Z9_DESPESA
				a_dtprev[VAL(Z9TMP->Z9_MES)]:= Z9TMP->Z9_DATA
				lWhenJan  := If(cAnoSrv+cMesSrv > Z9TMP->Z9_ANO + Z9TMP->Z9_MES  .or. nReal01 <> 0,.F.,If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
				cCorAtv01 := If(lWhenJan,"8388608","12632256")
			Case Z9TMP->Z9_MES = "02"
				nFatFev			:= Z9TMP->Z9_RECEITA
				nGstFev			:= Z9TMP->Z9_DESPESA
				a_dtprev[VAL(Z9TMP->Z9_MES)]:= Z9TMP->Z9_DATA
				lWhenFev := If(cAnoSrv+cMesSrv > Z9TMP->Z9_ANO + Z9TMP->Z9_MES  .or. nReal02 <> 0,.F.,If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
				cCorAtv02 := If(lWhenJan,"8388608","12632256")
			Case Z9TMP->Z9_MES = "03"
				nFatMar  := Z9TMP->Z9_RECEITA
				nGstMar  := Z9TMP->Z9_DESPESA
				a_dtprev[VAL(Z9TMP->Z9_MES)]:= Z9TMP->Z9_DATA
				lWhenMar := If(cAnoSrv+cMesSrv > Z9TMP->Z9_ANO + Z9TMP->Z9_MES  .or. nReal03 <> 0,.F.,If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
				cCorAtv03 := If(lWhenJan,"8388608","12632256")
			Case Z9TMP->Z9_MES = "04"
				nFatAbr  := Z9TMP->Z9_RECEITA
				nGstAbr  := Z9TMP->Z9_DESPESA
				a_dtprev[VAL(Z9TMP->Z9_MES)]:= Z9TMP->Z9_DATA
				lWhenAbr := If(cAnoSrv+cMesSrv > Z9TMP->Z9_ANO + Z9TMP->Z9_MES  .or. nReal04 <> 0,.F.,If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
				cCorAtv04 := If(lWhenJan,"8388608","12632256")
			Case Z9TMP->Z9_MES = "05"
				nFatMai  := Z9TMP->Z9_RECEITA
				nGstMai  := Z9TMP->Z9_DESPESA
				a_dtprev[VAL(Z9TMP->Z9_MES)]:= Z9TMP->Z9_DATA
				lWhenMai := If(cAnoSrv+cMesSrv > Z9TMP->Z9_ANO + Z9TMP->Z9_MES  .or. nReal05 <> 0,.F.,If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
				cCorAtv05 := If(lWhenJan,"8388608","12632256")
			Case Z9TMP->Z9_MES = "06"
				nFatJun  := Z9TMP->Z9_RECEITA
				nGstJun  := Z9TMP->Z9_DESPESA
				a_dtprev[VAL(Z9TMP->Z9_MES)]:= Z9TMP->Z9_DATA
				lWhenJun := If(cAnoSrv+cMesSrv > Z9TMP->Z9_ANO + Z9TMP->Z9_MES  .or. nReal06 <> 0,.F.,If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
				cCorAtv06 := If(lWhenJan,"8388608","12632256")
			Case Z9TMP->Z9_MES = "07"
				nFatJul  := Z9TMP->Z9_RECEITA
				nGstJul  := Z9TMP->Z9_DESPESA
				a_dtprev[VAL(Z9TMP->Z9_MES)]:= Z9TMP->Z9_DATA
				lWhenJul := If(cAnoSrv+cMesSrv > Z9TMP->Z9_ANO + Z9TMP->Z9_MES  .or. nReal07 <> 0,.F.,If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
				cCorAtv07 := If(lWhenJan,"8388608","12632256")
			Case Z9TMP->Z9_MES = "08"
				nFatAgo  := Z9TMP->Z9_RECEITA
				nGstAgo  := Z9TMP->Z9_DESPESA
				a_dtprev[VAL(Z9TMP->Z9_MES)]:= Z9TMP->Z9_DATA
				lWhenAgo := If(cAnoSrv+cMesSrv > Z9TMP->Z9_ANO + Z9TMP->Z9_MES  .or. nReal08 <> 0,.F.,If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
				cCorAtv08 := If(lWhenJan,"8388608","12632256")
			Case Z9TMP->Z9_MES = "09"
				nFatSet  := Z9TMP->Z9_RECEITA
				nGstSet  := Z9TMP->Z9_DESPESA
				a_dtprev[VAL(Z9TMP->Z9_MES)]:= Z9TMP->Z9_DATA
				lWhenSet := If(cAnoSrv+cMesSrv > Z9TMP->Z9_ANO + Z9TMP->Z9_MES  .or. nReal09 <> 0,.F.,If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
				cCorAtv09 := If(lWhenJan,"8388608","12632256")
			Case Z9TMP->Z9_MES = "10"
				nFatOut  := Z9TMP->Z9_RECEITA
				nGstOut  := Z9TMP->Z9_DESPESA
				a_dtprev[VAL(Z9TMP->Z9_MES)]:= Z9TMP->Z9_DATA
				lWhenOut := If(cAnoSrv+cMesSrv > Z9TMP->Z9_ANO + Z9TMP->Z9_MES  .or. nReal10 <> 0,.F.,If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
				cCorAtv10 := If(lWhenJan,"8388608","12632256")
			Case Z9TMP->Z9_MES = "11"
				nFatNov  := Z9TMP->Z9_RECEITA
				nGstNov  := Z9TMP->Z9_DESPESA
				a_dtprev[VAL(Z9TMP->Z9_MES)]:= Z9TMP->Z9_DATA
				lWhenNov := If(cAnoSrv+cMesSrv > Z9TMP->Z9_ANO + Z9TMP->Z9_MES  .or. nReal11 <> 0,.F.,If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
				cCorAtv11 := If(lWhenJan,"8388608","12632256")
			Case Z9TMP->Z9_MES = "12"
				nFatDez  := Z9TMP->Z9_RECEITA
				nGstDez  := Z9TMP->Z9_DESPESA
				a_dtprev[VAL(Z9TMP->Z9_MES)]:= Z9TMP->Z9_DATA
				lWhenDez := If(cAnoSrv+cMesSrv > Z9TMP->Z9_ANO + Z9TMP->Z9_MES  .or. nReal12 <> 0,.F.,If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
				cCorAtv12 := If(lWhenJan,"8388608","12632256")
		EndCase
		DbSkip()
	EndDo
	
   nPrvFat_A := 0
   nPrvGst_A := 0

	If Ctod("15/01/"+cAno1) >= dDtSrv .and. nReal01 = 0
	   nPrvFat_A += nFatJan - nReal01 
	   nPrvGst_A += nGstJan 
	EndIf        
	If Ctod("15/02/"+cAno1) >= dDtSrv .and. nReal02 = 0
	   nPrvFat_A += nFatFev - nReal02
	   nPrvGst_A += nGstFev 
	EndIf   
	If Ctod("15/03/"+cAno1) >= dDtSrv .and. nReal03 = 0
	   nPrvFat_A += nFatMar  - nReal03
	   nPrvGst_A += nGstMar
	EndIf   
	If Ctod("15/04/"+cAno1) >= dDtSrv .and. nReal04 = 0
	   nPrvFat_A += nFatAbr  - nReal04
	   nPrvGst_A += nGstAbr 
    EndIf	   
	If Ctod("15/05/"+cAno1) >= dDtSrv .and. nReal05 = 0
	   nPrvFat_A += nFatMai - nReal05
	   nPrvGst_A += nGstMai
	EndIf   
	If Ctod("15/06/"+cAno1) >= dDtSrv .and. nReal06 = 0
	   nPrvFat_A += nFatJun - nReal06
	   nPrvGst_A += nGstJun
	EndIf   
	If Ctod("15/07/"+cAno1) >= dDtSrv .and. nReal07 = 0
	   nPrvFat_A += nFatJul - nReal07
	   nPrvGst_A += nGstJul
    EndIf	   
	If Ctod("15/08/"+cAno1) >= dDtSrv .and. nReal08 = 0
	   nPrvFat_A += nFatAgo - nReal08
	   nPrvGst_A += nGstAgo
	EndIf   
    If Ctod("15/09/"+cAno1) >= dDtSrv .and. nReal09 = 0
	   nPrvFat_A += nFatSet - nReal09
	   nPrvGst_A += nGstSet
	EndIf   
	If Ctod("15/10/"+cAno1) >= dDtSrv .and. nReal10 = 0
	   nPrvFat_A += nFatOut - nReal10
	   nPrvGst_A += nGstOut
	EndIf   
	If Ctod("15/11/"+cAno1) >= dDtSrv .and. nReal11 = 0
	   nPrvFat_A += nFatNov - nReal11
	   nPrvGst_A += nGstNov
	EndIf
	If Ctod("15/12/"+cAno1) >= dDtSrv .and. nReal12 = 0
	   nPrvFat_A += nFatDez - nReal12
	   nPrvGst_A += nGstDez
	EndIf   
    nPrvFat := nPrvFat_A
    nPrvGst := nPrvGst_A
	Saldo()
Else
	cOpc    := "I"
	nFatjan := 0
	nFatFev := 0
	nFatMar := 0
	nFatAbr := 0
	nFatMai := 0
	nFatJun := 0
	nFatJul := 0
	nFatAgo := 0
	nFatSet := 0
	nFatOut := 0
	nFatNov := 0
	nFatDez := 0
	nGstJan := 0
	nGstFev := 0
	nGstMar := 0
	nGstAbr := 0
	nGstMai := 0
	nGstJun := 0
	nGstJul := 0
	nGstAgo := 0
	nGstSet := 0
	nGstOut := 0
	nGstNov := 0
	nGstDez := 0
	nSldJan := 0
	nSldFev := 0
	nSldMar := 0
	nSldAbr := 0
	nSldMai := 0
	nSldJun := 0
	nSldJul := 0
	nSldAgo := 0
	nSldSet := 0
	nSldOut := 0
	nSldNov := 0
	nSldDez := 0
	nDstFat := 0
	nDstGst := 0
	nPrvFat := 0
	nPrvGst := 0
	
	lWhenJan := If(cAnoSrv+cMesSrv > cAno1 + "01",.F.,If(cAnoSrv+cMesSrv = cAno1 + "01".And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	lWhenFev := If(cAnoSrv+cMesSrv > cAno1 + "02",.F.,If(cAnoSrv+cMesSrv = cAno1 + "02".And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	lWhenMar := If(cAnoSrv+cMesSrv > cAno1 + "03",.F.,If(cAnoSrv+cMesSrv = cAno1 + "03".And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	lWhenAbr := If(cAnoSrv+cMesSrv > cAno1 + "04",.F.,If(cAnoSrv+cMesSrv = cAno1 + "04".And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	lWhenMai := If(cAnoSrv+cMesSrv > cAno1 + "05",.F.,If(cAnoSrv+cMesSrv = cAno1 + "05".And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	lWhenJun := If(cAnoSrv+cMesSrv > cAno1 + "06",.F.,If(cAnoSrv+cMesSrv = cAno1 + "06".And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	lWhenJul := If(cAnoSrv+cMesSrv > cAno1 + "07",.F.,If(cAnoSrv+cMesSrv = cAno1 + "07".And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	lWhenAgo := If(cAnoSrv+cMesSrv > cAno1 + "08",.F.,If(cAnoSrv+cMesSrv = cAno1 + "08".And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	lWhenSet := If(cAnoSrv+cMesSrv > cAno1 + "09",.F.,If(cAnoSrv+cMesSrv = cAno1 + "09".And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	lWhenOut := If(cAnoSrv+cMesSrv > cAno1 + "10",.F.,If(cAnoSrv+cMesSrv = cAno1 + "10".And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	lWhenNov := If(cAnoSrv+cMesSrv > cAno1 + "11",.F.,If(cAnoSrv+cMesSrv = cAno1 + "11".And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	lWhenDez := If(cAnoSrv+cMesSrv > cAno1 + "12",.F.,If(cAnoSrv+cMesSrv = cAno1 + "12".And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	
EndIf

lWhenJan := .T.
lWhenFev := .T.
lWhenMar := .T.
lWhenAbr := .T.
lWhenMai := .T.
lWhenJun := .T.
lWhenJul := .T.
lWhenAgo := .T.
lWhenSet := .T.
lWhenOut := .T.
lWhenNov := .T.
lWhenDez := .T.

oFatJan:Refresh()
oFatFev:Refresh()
oFatMar:Refresh()
oFatAbr:Refresh()
oFatMai:Refresh()
oFatJun:Refresh()
oFatJul:Refresh()
oFatAgo:Refresh()
oFatSet:Refresh()
oFatOut:Refresh()
oFatNov:Refresh()
oFatDez:Refresh()
oGstJan:Refresh()
oGstFev:Refresh()
oGstMar:Refresh()
oGstAbr:Refresh()
oGstMai:Refresh()
oGstJun:Refresh()
oGstJul:Refresh()
oGstAgo:Refresh()
oGstSet:Refresh()
oGstOut:Refresh()
oGstNov:Refresh()
oGstDez:Refresh()

oReal01:Refresh()
oReal02:Refresh()
oReal03:Refresh()
oReal04:Refresh()
oReal05:Refresh()
oReal06:Refresh()
oReal07:Refresh()
oReal08:Refresh()
oReal09:Refresh()
oReal10:Refresh()
oReal11:Refresh()
oReal12:Refresh()

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFIN001   บAutor  ณMicrosiga           บ Data ณ  11/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Saldo()

Local nPrvFat_1 := 0
Local nPrvGst_1 := 0
Local nprvftant := 0

a_prvfat := {nFatJan, nFatFev, nFatMar, nFatAbr, nFatMai, nFatJun, nFatJul, nFatAgo, nFatSet, nFatOut, nFatNov, nFatDez}
a_prvgst := {nGstJan, nGstFev, nGstMar, nGstAbr, nGstMai, nGstJun, nGstJul, nGstAgo, nGstSet, nGstOut, nGstNov, nGstDez}
a_nreali := {nReal01, nReal02, nReal03, nReal04, nReal05, nReal06, nReal07, nReal08, nReal09, nReal10, nReal11, nReal12}

If cAno1 > substr(dtos(dDatabase),1,4)
	cQuery := "SELECT * "
	cQuery += "FROM "+RetSqlName('SZ9')+" "
	cQuery += "WHERE Z9_FILIAL = '"+xFilial('SZ9')+"' "
	cQuery += "      AND Z9_OBRA = '"+cCodObra+"' "
	cQuery += "      AND Z9_ANO < '"+cAno1+"' "
	cQuery += "      AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY Z9_MES "
	
	If Select("QRY") > 0
		DbSelectArea("QRY")
		DbCloseArea()
	EndIf
	
	TcQuery cQuery New Alias "QRY"
	
	While QRY->(!EOF())
		If QRY->(Z9_ANO+Z9_MES) > substr(dtos(dDatabase),1,6)
			nprvftant += QRY->Z9_RECEITA
		EndIf
		QRY->(DbSkip())
	EndDo
EndIf
	
For n_x := 1 to 12
	If cAno1+strzero(n_x,2)+"15" >= dtos(dDtSrv) .and. a_nreali[n_x] = 0
		nPrvFat_1 += a_prvfat[n_x] - a_nreali[n_x]
		nPrvGst_1 += a_prvgst[n_x]
	EndIf
Next

//previsao
nPrvFat   := nPrvFat_1 + nprvftant   //atualizando a previsao do medicao
nPrvGst   := nPrvGst_1   //atualizando a previsao do gasto

//a distribuir
nDstFat   := nVlrObra - nTotFat - nPrvFat  //medicao a distribuir
nDstGst   := nCstObra - nTotGst - nPrvGst  //medicao a distribuir

If nVlrObra - nPrvFat < 0
	oPrvFat:nClrText := 255
	Tone(100,3)
Else
	oPrvFat:nClrText := 0
EndIf
oPrvFat:Refresh()

If nCstObra - nPrvGst < 0
	oPrvGst:nClrText := 255
	Tone(100,3)
Else
	oPrvGst:nClrText := 0
EndIf
oPrvGst:Refresh()

If nDstFat < 0      //medicao a distribuir negativo
	oDstFat:nClrText := 255
	Tone(100,3)
Else
	oDstFat:nClrText := 0
EndIf
oDstFat:Refresh()

If nDstGst < 0      //gasto a distribuir negativo
	oDstGst:nClrText := 255
	Tone(100,3)
Else
	oDstGst:nClrText := 0
EndIf
oDstGst:Refresh()

nSldJan := nFatJan-nGstJan
If nSldJan < 0
	oSldJan:nClrText := 255
	Tone(100,3)
Else
	oSldJan:nClrText := 0
EndIf
oSldJan:Refresh()

nSldFev := nFatFev-nGstFev
If nSldFev < 0
	oSldFev:nClrText := 255
	Tone(100,3)
Else
	oSldFev:nClrText := 0
EndIf
oSldFev:Refresh()

nSldMar := nFatMar-nGstMar
If nSldMar < 0
	oSldMar:nClrText := 255
	Tone(100,3)
Else
	oSldMar:nClrText := 0
EndIf
oSldMar:Refresh()

nSldAbr := nFatAbr-nGstAbr
If nSldAbr < 0
	oSldAbr:nClrText := 255
	Tone(100,3)
Else
	oSldAbr:nClrText := 0
EndIf
oSldAbr:Refresh()

nSldMai := nFatMai-nGstMai
If nSldMai < 0
	oSldMai:nClrText := 255
	Tone(100,3)
Else
	oSldMai:nClrText := 0
EndIf
oSldMai:Refresh()

nSldJun := nFatJun-nGstJun
If nSldJun < 0
	oSldJun:nClrText := 255
	Tone(100,3)
Else
	oSldJun:nClrText := 0
EndIf
oSldJun:Refresh()

nSldJul := nFatJul-nGstJul
If nSldJul < 0
	oSldJul:nClrText := 255
	Tone(100,3)
Else
	oSldJul:nClrText := 0
EndIf
oSldJul:Refresh()

nSldAgo := nFatAgo-nGstAgo
If nSldAgo < 0
	oSldAgo:nClrText := 255
	Tone(100,3)
Else
	oSldAgo:nClrText := 0
EndIf
oSldAgo:Refresh()

nSldSet := nFatSet-nGstSet
If nSldSet < 0
	oSldSet:nClrText := 255
	Tone(100,3)
Else
	oSldSet:nClrText := 0
EndIf
oSldSet:Refresh()

nSldOut := nFatOut-nGstOut
If nSldOut < 0
	oSldOut:nClrText := 255
	Tone(100,3)
Else
	oSldOut:nClrText := 0
EndIf
oSldOut:Refresh()

nSldNov := nFatNov-nGstNov
If nSldNov < 0
	oSldNov:nClrText := 255
	Tone(100,3)
Else
	oSldNov:nClrText := 0
EndIf
oSldNov:Refresh()

nSldDez := nFatDez-nGstDez
If nSldDez < 0
	oSldDez:nClrText := 255
	Tone(100,3)
Else
	oSldDez:nClrText := 0
EndIf
oSldDez:Refresh()

oPrvFat:Refresh()
oPrvGst:Refresh()

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRealizado บAutor  ณAlexandre Sousa     บ Data ณ  11/07/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para carregar valores acumulados.                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Realizado()
	
	Local oProcess
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCria arquivo de trabalho                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oProcess := MsNewProcess():New({|lEnd| U_RFIN011a(oProcess,CTT->CTT_CUSTO, cAno1, .T.,"A")},"Processando informa็๕es da Obra","Preparando . . .",.T.)
	oProcess:Activate()

	DbSelectArea('TRAB')
	DbSeek('015') // FATURAMENTO DIRETO
//	@nLin,a_pos2[02] PSAY transform(TRAB->TRB_TOT, '@E 999,999,999.99')

	c_nat := ''

	nTotFD := TRAB->TRB_TOT
	oTotFD:Refresh()
	nFDJan := TRAB->TRB_M01
	oFDJan:Refresh()
	nFDFev := TRAB->TRB_M02
	oFDFev:Refresh()
	nFDMar := TRAB->TRB_M03
	oFDMar:Refresh()
	nFDAbr := TRAB->TRB_M04
	oFDAbr:Refresh()
	nFDMai := TRAB->TRB_M05
	oFDMai:Refresh()
	nFDJun := TRAB->TRB_M06
	oFDJun:Refresh()
	nFDJul := TRAB->TRB_M07
	oFDJul:Refresh()
	nFDAgo := TRAB->TRB_M08
	oFDAgo:Refresh()
	nFDSet := TRAB->TRB_M09
	oFDSet:Refresh()
	nFDOut := TRAB->TRB_M10
	oFDOut:Refresh()
	nFDNov := TRAB->TRB_M11
	oFDNov:Refresh()
	nFDDez := TRAB->TRB_M12
	oFDDez:Refresh()

	If nFatDir - nTotFD < 0
		oTotFD:nClrText := 255
		Tone(100,3)
	Else
		oTotFD:nClrText := 0
	EndIf
	oTotFD:Refresh()

	nReal01 := 0
	nReal02 := 0
	nReal03 := 0
	nReal04 := 0
	nReal05 := 0
	nReal06 := 0
	nReal07 := 0
	nReal08 := 0
	nReal09 := 0
	nReal10 := 0
	nReal11 := 0
	nReal12 := 0

	n_totrec := 0
	DbSelectArea('TRAB')
	DbSeek('010') // RECEITAS
	While TRAB->(!EOF()) .and. TRAB->TRB_GRPO = '010'
		If !(alltrim(subStr(TRAB->TRB_NAT,1,4)) $ 'INSS/ISS/PIS/COFINS/CSLL/IRF')
			nReal01 += 	Iif(substr(dtos(dDatabase),5,2) = '01', TRAB->(TRB_VENC+TRB_ABER+TRB_REAL)+TRAB->TRB_M01,TRAB->TRB_M01)
			nReal02 += 	Iif(substr(dtos(dDatabase),5,2) = '02', TRAB->(TRB_VENC+TRB_ABER+TRB_REAL)+TRAB->TRB_M02,TRAB->TRB_M02)
			nReal03 += 	Iif(substr(dtos(dDatabase),5,2) = '03', TRAB->(TRB_VENC+TRB_ABER+TRB_REAL)+TRAB->TRB_M03,TRAB->TRB_M03)
			nReal04 += 	Iif(substr(dtos(dDatabase),5,2) = '04', TRAB->(TRB_VENC+TRB_ABER+TRB_REAL)+TRAB->TRB_M04,TRAB->TRB_M04)
			nReal05 += 	Iif(substr(dtos(dDatabase),5,2) = '05', TRAB->(TRB_VENC+TRB_ABER+TRB_REAL)+TRAB->TRB_M05,TRAB->TRB_M05)
			nReal06 += 	Iif(substr(dtos(dDatabase),5,2) = '06', TRAB->(TRB_VENC+TRB_ABER+TRB_REAL)+TRAB->TRB_M06,TRAB->TRB_M06)
			nReal07 += 	Iif(substr(dtos(dDatabase),5,2) = '07', TRAB->(TRB_VENC+TRB_ABER+TRB_REAL)+TRAB->TRB_M07,TRAB->TRB_M07)
			nReal08 += 	Iif(substr(dtos(dDatabase),5,2) = '08', TRAB->(TRB_VENC+TRB_ABER+TRB_REAL)+TRAB->TRB_M08,TRAB->TRB_M08)
			nReal09 += 	Iif(substr(dtos(dDatabase),5,2) = '09', TRAB->(TRB_VENC+TRB_ABER+TRB_REAL)+TRAB->TRB_M09,TRAB->TRB_M09)
			nReal10 += 	Iif(substr(dtos(dDatabase),5,2) = '10', TRAB->(TRB_VENC+TRB_ABER+TRB_REAL)+TRAB->TRB_M10,TRAB->TRB_M10)
			nReal11 += 	Iif(substr(dtos(dDatabase),5,2) = '11', TRAB->(TRB_VENC+TRB_ABER+TRB_REAL)+TRAB->TRB_M11,TRAB->TRB_M11)
			nReal12 += 	Iif(substr(dtos(dDatabase),5,2) = '12', TRAB->(TRB_VENC+TRB_ABER+TRB_REAL)+TRAB->TRB_M12,TRAB->TRB_M12)
			n_totrec += TRAB->TRB_TOT
		EndIf
		TRAB->(DbSkip())
	EndDo

	oReal01:Refresh()
	oReal02:Refresh()
	oReal03:Refresh()
	oReal04:Refresh()
	oReal05:Refresh()
	oReal06:Refresh()
	oReal07:Refresh()
	oReal08:Refresh()
	oReal09:Refresh()
	oReal10:Refresh()
	oReal11:Refresh()
	oReal12:Refresh()

	nTotFat := n_totrec
	If nVlrObra - nTotFat < 0
		oTotFat:nClrText := 255
		Tone(100,3)
	Else
		oTotFat:nClrText := 0
	EndIf
	oTotFat:Refresh()            

	nDstFat := nVlrObra - nTotFat - nPrvFat
	If nDstFat < 0      //medicao a distribuir negativo
		oDstFat:nClrText := 255
		Tone(100,3)
	Else
		oDstFat:nClrText := 0
	EndIf
	oDstFat:Refresh()

	DbSelectArea('TRAB')
	DbSeek('028') // TOTAL DE DESPESAS ACUMULADAS.
	nTotGst := TRAB->TRB_TOT
	If nCstObra - nTotGst < 0
		oTotGst:nClrText := 255
		Tone(100,3)
	Else
		oTotGst:nClrText := 0
	EndIf
	oTotGst:Refresh() 

	nDstGst := nCstObra - nTotGst - nPrvGst
	If nDstGst < 0      //gasto a distribuir negativo
		oDstGst:nClrText := 255
		Tone(100,3)
	Else
		oDstGst:nClrText := 0
	EndIf
	oDstGst:Refresh()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtualiza novamente os controles de edicao dos campos de faturamento                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lWhenJan := If(nReal01 <> 0,.F.,lWhenJan) //If(cAnoSrv+cMesSrv = Z9TMP->Z9_ANO + Z9TMP->Z9_MES.And.dDtSrv>Ctod("15/"+cMesSrv+"/"+cAnoSrv),.F.,.T.))
	lWhenFev := If(nReal02 <> 0,.F.,lWhenFev)
	lWhenMar := If(nReal03 <> 0,.F.,lWhenMar)
	lWhenAbr := If(nReal04 <> 0,.F.,lWhenAbr)
	lWhenMai := If(nReal05 <> 0,.F.,lWhenMai)
	lWhenJun := If(nReal06 <> 0,.F.,lWhenJun)
	lWhenJul := If(nReal07 <> 0,.F.,lWhenJul)
	lWhenAgo := If(nReal08 <> 0,.F.,lWhenAgo)
	lWhenSet := If(nReal09 <> 0,.F.,lWhenSet)
	lWhenOut := If(nReal10 <> 0,.F.,lWhenOut)
	lWhenNov := If(nReal11 <> 0,.F.,lWhenNov)
	lWhenDez := If(nReal12 <> 0,.F.,lWhenDez)

	Saldo()
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfValLim   บAutor  ณAlexandre Sousa     บ Data ณ  11/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica os valores de previsoes para nao ultrapassar o     บฑฑ
ฑฑบ          ณlimite disponivel para distribuicao.                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fValLim()
                         
	Local l_Ret := .T.
	
	If nDstFat < 0 
		msgAlert('Aten็ใo a previsใo de medi็ใo nใo pode ser maior que o saldo a distribuir', 'A T E N ว ร O')
		l_Ret := .F.
	EndIf

Return l_Ret