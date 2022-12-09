#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/12/01

User Function SHETIQ2()        // incluido pelo assistente de conversao do AP5 IDE em 13/12/01

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ SHETIQ2  ³ Autor ³Jaime Ranulfo Leite F. ³ Data ³ 02/07/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Emissao de Etiquetas para Produto                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Shangrila                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Arquivos ³ SB1                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo   := "Emissao de Etiquetas para Produto"
cDesc1   := "Emite as etiquetas de codigos de barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SB1"
wnrel    := "SHETIQ"
limite   := 80
nLin     := 99
nPag     := 0
lContinua := .T.
lEnd      := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis padrao de todos os relatorios                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aReturn := { "Especial", 1,"Administracao", 2, 2, 1,"",1 }

nLastKey:= 0
cPerg := PADR("SHETQ2",LEN(SX1->X1_GRUPO))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()
pergunte(cPerg,.T.)

cMsg := "Já transferiu o Logotipo ? "
cTit := "Impressão"
cTip := "YESNO"
//
#IFDEF WINDOWS
	If !MsgBox(cMsg, cTit, cTip)
		Return (.T.)
	Endif
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,"P")

nLastKey:=IIf(LastKey()==27,27,nLastKey)
If nLastKey == 27
    Return
Endif
SetDefault(aReturn,cString)
nLastKey:=IIf(LastKey()==27,27,nLastKey)
If nLastKey == 27
    Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Dbselectarea("SM0")
Dbsetorder(1)
Dbseek(SM0->M0_CODIGO+"01",.F.)

WCGC := Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
cEmp := SM0->M0_CODIGO

Dbselectarea("SB1")
Dbsetorder(1)
Dbseek(xFilial("SB1")+MV_PAR01,.F.)

WDES := SB1->B1_DESC

If Empty(MV_PAR04)
//If ALLTRIM(MV_PAR01) == 'X'
   WPRO := substr(MV_PAR01,3,4)
Else
//   WPRO := Right(allTrim(MV_PAR01),4)
   WPRO := MV_PAR04
Endif

//If MV_PAR05 = 1
If cEmp == '01' 
   WCBA := "7896771"    // Numero do codigo de barra EAN - Shangrila Matriz
Else
   WCBA := "7895040"    // Numero do codigo de barra EAN - Capela
Endif           

WCOP := (INT(MV_PAR02/4))
//WCOP := (VAL(MV_PAR02)/4)
NLIN := 1 

@ NLIN,00 PSAY "~L"
NLIN := NLIN + 1
@ NLIN,00 PSAY "D11"
NLIN := NLIN + 1
@ NLIN,00 PSAY "H10"

NLIN := NLIN + 1
@ NLIN,00 PSAY "1Y1100000550039"+Trim(MV_PAR03)
NLIN := NLIN + 1
@ NLIN,00 PSAY "210200000500083"+"Cod."+WPRO
NLIN := NLIN + 1
@ NLIN,00 PSAY "200200000800070"+WCGC+" - SP"
NLIN := NLIN + 1
@ NLIN,00 PSAY "210200001400005"+WDES
NLIN := NLIN + 1
@ NLIN,00 PSAY "2F2204001200020"+WCBA+Right(Trim(MV_PAR01),5)

NLIN := NLIN + 1
@ NLIN,00 PSAY "1Y1100000550147"+Trim(MV_PAR03)
NLIN := NLIN + 1
@ NLIN,00 PSAY "210200000500191"+"Cod."+WPRO
NLIN := NLIN + 1                              	
@ NLIN,00 PSAY "200200000800179"+WCGC+" - SP"
NLIN := NLIN + 1
@ NLIN,00 PSAY "210200001400115"+WDES
NLIN := NLIN + 1
@ NLIN,00 PSAY "2F2204001200129"+WCBA+Right(Trim(MV_PAR01),5)
         
NLIN := NLIN + 1
@ NLIN,00 PSAY "1Y1100000550257"+Trim(MV_PAR03)
NLIN := NLIN + 1
@ NLIN,00 PSAY "210200000500302"+"Cod."+WPRO
NLIN := NLIN + 1
@ NLIN,00 PSAY "200200000800290"+WCGC+" - SP"
NLIN := NLIN + 1
@ NLIN,00 PSAY "210200001400225"+WDES
NLIN := NLIN + 1
@ NLIN,00 PSAY "2F2204001200240"+WCBA+Right(Trim(MV_PAR01),5)

NLIN := NLIN + 1
@ NLIN,00 PSAY "1Y1100000550365"+Trim(MV_PAR03)
NLIN := NLIN + 1
@ NLIN,00 PSAY "210200000500407"+"Cod."+WPRO
NLIN := NLIN + 1
@ NLIN,00 PSAY "200200000800400"+WCGC+" - SP"
NLIN := NLIN + 1
@ NLIN,00 PSAY "210200001400335"+WDES
NLIN := NLIN + 1
@ NLIN,00 PSAY "2F2204001200350"+WCBA+Right(Trim(MV_PAR01),5)

NLIN := NLIN + 1
@ NLIN,00 PSAY "Q"+STRZERO(WCOP,4)
NLIN := NLIN + 1
@ NLIN,00 PSAY "E"

Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
    OurSpool(wnrel)
Endif
MS_FLUSH()
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ValidPerg ³ Autor ³ Jaime Ranulfo Leite F ³ Data ³ 29/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cria SX1                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

Static Function ValidPerg

_sAlias := Alias()
cPerg   := Padr(cPerg, 6)
aRegs   := {}
//
DbSelectArea("SX1")
DbSetOrder(1)

Aadd(aRegs,{cPerg,"01","Produto            ?","","","mv_ch1","C",15,0,0,"G","",;
"Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""})
Aadd(aRegs,{cPerg,"02","Quantidade         ?","","","mv_ch2","N",06,0,0,"G","",;
"Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Arquivo Logotipo   ?","","","mv_ch3","C",30,0,0,"G","",;
"Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Código p/ Impressão?","","","mv_ch4","C",05,0,0,"G","",;
"Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"05","Modelo             ?","","","mv_ch5","N",01,0,0,"C","",;
//"Mv_Par01","[7896771]","","","","","[7895040]","","","","","","","","","","","","","","","","","","","","","",""})
//
For i := 1 To Len(aRegs)
	//
	If !DbSeek(cPerg + aRegs[i, 2])
		//
		RecLock("SX1", .T.)
		For j := 1 To FCount()
			FieldPut(j, aRegs[i, j])
		Next
		MsUnlock()
		//
	Endif
	//
Next
//
DbSelectArea(_sAlias)
//
Return (.T.)
