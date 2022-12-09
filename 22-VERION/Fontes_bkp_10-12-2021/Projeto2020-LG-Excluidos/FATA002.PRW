#include "rwmake.ch"   
User Function fata002()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FATA002  ³Autor  ³Paulo C T de Oliveira  ³ Data ³ 21/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡†o ³ Alteracao do Preco de Venda                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Arquivos  ³ SB1                                                        ³±±
±±³Utilizados³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

_cAlias:=Alias()
_nOrder:=IndexOrd()
_nRecno:=Recno()
cPerg    := 'ALTENT    '
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Perguntas Utilizadas para Parametros ³
//³ CodGru De := mv_par01                         ³
//³ CodGru Ate:= mv_par02                         ³
//³ CodCf     := mv_par03                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ValidPerg(cPerg)

//pergunte("ALTENT", .T.)

Pergunte(cPerg, .T.)

if MV_PAR03 == 2
   Return
endif         

dbSelectArea("SBM")
dbSetOrder(1)

dbSelectArea("SM2")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)
Set Filter to SB1->B1_GRUPO >= MV_PAR01 .and. SB1->B1_GRUPO <= MV_PAR02
dbGoTop()

While !EOF() .and. SB1->B1_GRUPO >= MV_PAR01 .and. SB1->B1_GRUPO <= MV_PAR02
   _WTIPICMS := SB1->B1_FATOR
   _WMOEDA   := SB1->B1_TPMOEDA
   _WGRUPO   := SB1->B1_GRUPO
   
   dbSelectArea("SBM")
   dbSeek(xFilial()+_WGRUPO)
   
   If _WTIPICMS == 0
      _WTIPICMS := SBM->BM_FATOR
   Endif                        

   If _WMOEDA = SPACE(1)
      _WMOEDA := SBM->BM_MOEDA
   Endif                        
   
   dbSelectArea("SM2")
   dbSeek(SB1->B1_DATREF)

   IF _WMOEDA == "D"
      _WAA := SB1->B1_VERCOM * SM2->M2_MOEDA2 * _WTIPICMS
   ELSE
      _WAA := SB1->B1_VERCOM * SM2->M2_MOEDA4 * _WTIPICMS
   ENDIF

   Reclock("SB1",.F.)
   Replace B1_VERVEN With _WAA
   MsUnlock()

   DbSkip()

End

dbSelectArea(_cAlias)
dbSetOrder(_nOrder)
dbGoto(_nRecno)

//__Return(nIL)
Return(nIL)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VALIDPERG ³ Autor ³  Luiz Carlos Vieira   ³ Data ³ 03/07/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas incluindo-as caso nao existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico - Figrot.prx                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Grupo Inicial      ?","","","mv_cha","C",04,0,0,"G","","mv_par01","","","","MC  ","","","","","","","","","","","","","","","","","","","","","","S","","",""})
AADD(aRegs,{cPerg,"02","Grupo Final        ?","","","mv_chb","C",04,0,0,"G","","mv_par02","","","","MC  ","","","","","","","","","","","","","","","","","","","","","","S","","",""})
AADD(aRegs,{cPerg,"03","Efetua o Calculo   ?","","","mv_chc","N",01,0,1,"C","","mv_par03","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","S","","",""})
For i:=1 to Len(aRegs)
   If !dbSeek(cPerg+aRegs[i,2])
      RecLock("SX1",.T.)
      For j:=1 to FCount()
         FieldPut(j,aRegs[i,j])
      Next
      MsUnlock()
   Endif
Next

dbSelectArea(_sAlias)

Return
