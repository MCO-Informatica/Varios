#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MTA650I ³ Autor ³ Carlos Puerta/Daniel  ³ Data ³ 11/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada apos gravacao do SC2.                     ³±±
±±³          ³ Geracao de OP por Vendas.                                  ³±±
±±³          ³ Nao permite gerar OP com data de Inicio/Fim anterior a data³±±
±±³          ³ Base.                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga - Securit S.A.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTA650I()
Private _aArea    := GetArea()
Private _aAreaB1  := {}
Private _aAreaC2  := {}
Private _cCliente := Space(06)
Private _cLoja    := Space(02)
Private _cDescCli := Space(60)

If !(SC2->C2_SEQUEN == "001")
    dbSelectArea("SC2")
    _aAreaC2 := GetArea()
    dbSetOrder(1)
    If dbSeek(xFilial("SC2")+SC2->C2_NUM+SC2->C2_ITEM+"001"+"  ")
        _cCliente := SC2->C2_CLIENTE
        _cLoja    := SC2->C2_LOJA
        _cDescCli := SC2->C2_DESCCLI
    EndIf
    RestArea(_aAreaC2)

    dbSelectArea("SB1")
    _aAreaB1 := GetArea()
    dbSetOrder(1)
    If dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
        RecLock("SC2",.F.)
        SC2->C2_CLIENTE  := _cCliente
        SC2->C2_LOJA     := _cLoja
        SC2->C2_DESCCLI  := _cDescCli

        SC2->C2_DESCPRO  := SB1->B1_DESC
        SC2->C2_CODCLI   := SB1->B1_LCODCLI
        SC2->C2_CICLO    := SB1->B1_LCICLO
        SC2->C2_CAVIDAD  := SB1->B1_LCAV
        SC2->C2_UTILIZA  := SB1->B1_LUTILI
        SC2->C2_MAQUINA  := SB1->B1_LMAQ
        SC2->C2_COR      := TABELA("EE",SB1->B1_CORPRI,.F.)
        SC2->C2_MOLDE    := VAL(SB1->B1_MOLDE)
        SC2->C2_PESO     := SB1->B1_PESBRU
        SC2->C2_TEMPOES  := 0
        SC2->C2_TEMPOTE  := 0
        MsUnlock()
    EndIf
    RestArea(_aAreaB1)
EndIf

RestArea(_aArea)
Return