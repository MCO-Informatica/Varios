/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FATA002  ³Autor  ³Paulo C T de Oliveira  ³ Data ³ 28/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡†o ³ Acerta cadastro de contas contabeis                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Contabilidade                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Arquivos  ³ SI1, CT1                                                   ³±±
±±³Utilizados³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#include "rwmake.ch"   

User Function cont001()

Local _aArea :=	GetArea()

_cAlias:=Alias()
_nOrder:=IndexOrd()
_nRecno:=Recno()

dbSelectArea("CT1")
dbSetOrder(1)

dbSelectArea("SI1")
dbSetOrder(1)
dbGoTop()

While !EOF() 
 

   dbSelectArea("CT1")
   Reclock("CT1",.T.)
   Replace CT1_FILIAL With "",CT1_CONTA WITH SI1->I1_CODIGO,CT1_DESC01 WITH SI1->I1_DESC
   IF SI1->I1_CLASSE == "S"
      Replace CT1_CLASSE WITH "1"
   ELSEIF SI1->I1_CLASSE == "A"
      Replace CT1_CLASSE WITH "2"
   ENDIF
   Replace CT1_DC WITH SI1->I1_DC,CT1_CTLALU WITH SI1->I1_CTASUP,CT1_CVD02 WITH "1"
   Replace CT1_CVD03 WITH "1",CT1_CVD04 WITH "1",CT1_CVD05 WITH "1"
   Replace CT1_CVC02 WITH "1",CT1_CVC03 WITH "1",CT1_CVC04 WITH "1",CT1_CVC05 WITH "1"
   Replace CT1_ACITEM WITH "1",CT1_ACCUST WITH "1",CT1_ACCLVL WITH "1",CT1_BLOQ WITH "2"
   Replace CT1_AGLSLD WITH "2",CT1_CCOBRG WITH "2",CT1_ITOBRG WITH "2",CT1_CLOBRG WITH "2"
   Replace CT1_LALUR WITH "0",CT1_RES WITH SI1->I1_RES,CT1_NCUSTO WITH 0,CT1_DTEXIS WITH CTOD("28/10/05")
   IF SI1->I1_NORMAL == "D"
      Replace CT1_NORMAL WITH "1"
   ELSEIF SI1->I1_NORMAL =="C"
      Replace CT1_NORMAL WITH "2"
   ENDIF
   MsUnlock()

   dbSelectArea("SI1")
   DbSkip()

End

dbSelectArea(_cAlias)
dbSetOrder(_nOrder)
dbGoto(_nRecno)

RestArea(_aArea)


Return(nIL)
