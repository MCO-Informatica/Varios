#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function pretras()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CPERG,_APERGUNTAS,_NLACO,")

***  RETRAS.PRW
***  RETIRAR RASTRO DO PRODUTO DESEJADO.
***  AUTOR: SERGIO OLIVEIRA. 

If SM0->M0_CODIGO != "01"
   MSGBOX("SOMENTE NA EMPRESA OFICIAL")
   __RETPROC()
EndIf

_cPerg := "KALDO0"

ValidPerg()

Pergunte(_cPerg,.t.)

DbSelectArea("SB1")
DbSetOrder(1)

If DbSeek(xFilial()+ALLTRIM(MV_PAR01),.F.)
   RecLock("SB1",.f.)
   SB1->B1_RASTRO  := "L"
   SB1->B1_FORMLOT := "003"
   MsUnLock()
Else 
   MsgBox("Produto nao encontrado","Atencao","ALERT")
EndIf
__RetProc()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ PERGUNTAS³ Autor ³ MARCOS GOMES          ³ Data ³ 29/09/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria grupo de perguntas no SX1.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Exclusivo para Clientes Microsiga - Kenia                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION VALIDPERG
Static FUNCTION VALIDPERG()

_aPerguntas:= {}

//                  1       2          3                 4       5  6  7 8  9  10     11       12      13 14     15    16 17    18   19 20 21 22 23 24 25  26
AADD(_aPerguntas,{"KALDO0","01","Qual Produto       ?","mv_ch1","C",15,0,0,"G","","mv_par01","       ","","","       ","","","     ","","","","","","","","SB1",})

DbSelectArea("SX1")

FOR _nLaco:=1 to LEN(_aPerguntas)
   If !DbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
        RecLock("SX1",.T.)
           SX1->X1_Grupo     := _aPerguntas[_nLaco,01]
           SX1->X1_Ordem     := _aPerguntas[_nLaco,02]
           SX1->X1_Pergunt   := _aPerguntas[_nLaco,03]
           SX1->X1_Variavl   := _aPerguntas[_nLaco,04]
           SX1->X1_Tipo      := _aPerguntas[_nLaco,05]
           SX1->X1_Tamanho   := _aPerguntas[_nLaco,06]
           SX1->X1_Decimal   := _aPerguntas[_nLaco,07]
           SX1->X1_Presel    := _aPerguntas[_nLaco,08]
           SX1->X1_Gsc       := _aPerguntas[_nLaco,09]
           SX1->X1_Valid     := _aPerguntas[_nLaco,10]
           SX1->X1_Var01     := _aPerguntas[_nLaco,11]
           SX1->X1_Def01     := _aPerguntas[_nLaco,12]
           SX1->X1_Cnt01     := _aPerguntas[_nLaco,13]
           SX1->X1_Var02     := _aPerguntas[_nLaco,14]
           SX1->X1_Def02     := _aPerguntas[_nLaco,15]
           SX1->X1_Cnt02     := _aPerguntas[_nLaco,16]
           SX1->X1_Var03     := _aPerguntas[_nLaco,17]
           SX1->X1_Def03     := _aPerguntas[_nLaco,18]
           SX1->X1_Cnt03     := _aPerguntas[_nLaco,19]
           SX1->X1_Var04     := _aPerguntas[_nLaco,20]
           SX1->X1_Def04     := _aPerguntas[_nLaco,21]
           SX1->X1_Cnt04     := _aPerguntas[_nLaco,22]
           SX1->X1_Var05     := _aPerguntas[_nLaco,23]
           SX1->X1_Def05     := _aPerguntas[_nLaco,24]
           SX1->X1_Cnt05     := _aPerguntas[_nLaco,25]
           SX1->X1_F3        := _aPerguntas[_nLaco,26]
        MsUnLock()
   EndIf
NEXT
__RetProc()

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

