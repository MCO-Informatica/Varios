#include "rwmake.ch"
//
// Programa		MTA650I
// Autor		Carlos Puerta
// Data			03/01/2018
// Descricao	Ponto de Entrada apos gravacao do SC2.
// Finalidade	Gravar conteudo dos campos de usuarios conforme OP do produto PAI (Seq. 001)
// Uso			Especifico para Clientes Microsiga - Linciplas
//
User Function MTA650I()
Private _aArea     := GetArea()
Private _aAreaC2   := {}
Private _cC2Num    := SC2->C2_NUM
Private _cC2Item   := SC2->C2_ITEM
Private _cC2Sequen := SC2->C2_SEQUEN

If SC2->C2_SEQUEN == "001"
    Return
EndIf

Private _cDescPro  := GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+SC2->C2_PRODUTO,1,"")
Private _cCodCli   := GetAdvFVal("SB1","B1_LCODCLI",xFilial("SB1")+SC2->C2_PRODUTO,1,"")
Private _nCiclo    := GetAdvFVal("SB1","B1_LCICLO",xFilial("SB1")+SC2->C2_PRODUTO,1,0.00)
Private _nCavidad  := GetAdvFVal("SB1","B1_LCAV",xFilial("SB1")+SC2->C2_PRODUTO,1,0)
Private _nUtiliza  := GetAdvFVal("SB1","B1_LUTILI",xFilial("SB1")+SC2->C2_PRODUTO,1,0)
Private _cMaquina  := GetAdvFVal("SB1","B1_LMAQ",xFilial("SB1")+SC2->C2_PRODUTO,1,Space(15))
Private _cCor      := TABELA("EE",Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_CORPRI"),.F.)
Private _nMolde    := Val(GetAdvFVal("SB1","B1_MOLDE",xFilial("SB1")+SC2->C2_PRODUTO,1,0))
Private _nPeso     := GetAdvFVal("SB1","B1_PESBRU",xFilial("SB1")+SC2->C2_PRODUTO,1,0.00000000)

Private _cCliente  := Space(06)
Private _cLoja     := Space(02)
Private _cDescCli  := Space(60)
Private _nTempoEs  := 0
Private _nTempoTe  := 0

dbSelectArea("SC2")
_aAreaC2 := GetArea()
dbSetOrder(1)
If dbSeek(xFilial("SC2")+SC2->C2_NUM+SC2->C2_ITEM+"001"+"  ")
	_cCliente := SC2->C2_CLIENTE
	_cLoja    := SC2->C2_LOJA
	_cDescCli := SC2->C2_DESCCLI
	_nTempoEs := SC2->C2_TEMPOES
	_nTempoTe := SC2->C2_TEMPOTE
EndIf

RestArea(_aAreaC2)
RecLock("SC2",.F.)
SC2->C2_DESCPRO  := _cDescPro
SC2->C2_CLIENTE  := _cCliente
SC2->C2_LOJA     := _cLoja
SC2->C2_DESCCLI  := _cDescCli
SC2->C2_CODCLI   := _cCodCli
SC2->C2_CICLO    := _nCiclo
SC2->C2_CAVIDAD  := _nCavidad
SC2->C2_UTILIZA  := _nUtiliza
SC2->C2_MAQUINA  := _cMaquina
SC2->C2_COR      := _cCor
SC2->C2_MOLDE    := _nMolde
SC2->C2_PESO     := _nPeso
SC2->C2_TEMPOES  := _nTempoEs
SC2->C2_TEMPOTE  := _nTempoTe
MsUnlock()

RestArea(_aArea)
Return