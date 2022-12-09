#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rqg014  			 Ricardo Felipelli   º Data ³  03/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ grava item na tabela sx5 quando a mesma for exclusiva      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rqg014()
Local _Opcao := .f.

If MsgYesNO("Inclui dados na tabelas exclusiva na SX5 ??  ","executa")
	Processa({|| CorrSX5()},"Processando...")
EndIf

Return nil


Static Function CorrSX5()

DbSelectArea("SX5")
Dbsetorder(01)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utiliza	das para parametros                      ³
//³ mv_par01               TABELA                                ³
//³ mv_par02               Ate Filial                            ³
//³ mv_par03               Da Data                               ³
//³ mv_par04               Ate Data                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPerg   := padr("RQG014",len(SX1->X1_GRUPO)," ")
_pergunt()
pergunte(cPerg,.T.)


SX5->(dbseek(xFilial("SX5")	+ mv_par01 + mv_par02))
if SX5->(!found())
	RecLock("SX5",.T.)
	SX5->X5_FILIAL  := xFilial("SX5")
	SX5->X5_TABELA  := mv_par01
	SX5->X5_CHAVE   := mv_par02
	SX5->X5_DESCRI  := mv_par03
	SX5->X5_DESCSPA := mv_par04
	SX5->X5_DESCENG := mv_par05
else
	RecLock("SX5",.F.)
	SX5->X5_DESCRI  := mv_par03
	SX5->X5_DESCSPA := mv_par04
	SX5->X5_DESCENG := mv_par05
endif

MsUnLock()


return nil


*****
Static function _pergunt()
***********************

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+"01")
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "X5_TABELA         ?"
SX1->X1_VARIAVL := "mv_ch1"
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 2
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par01"
MsUnLock()
dbCommit()


dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+"02")
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "X5_CHAVE           ?"
SX1->X1_VARIAVL := "mv_ch2"
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 2
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par02"
MsUnLock()
dbCommit()


dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+"03")
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "X5_DESCRI         ?"
SX1->X1_VARIAVL := "mv_ch3"
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 55
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par03"
MsUnLock()
dbCommit()


dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+ "04")
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "X5_DESCSPA         ?"
SX1->X1_VARIAVL := "mv_ch4"
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 55
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par04"
MsUnLock()
dbCommit()


dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+ "05")
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "X5_DESCENG         ?"
SX1->X1_VARIAVL := "mv_ch5"
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 55
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par05"
MsUnLock()
dbCommit()


return nil

