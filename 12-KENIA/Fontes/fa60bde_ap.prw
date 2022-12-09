#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function fa60bde()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_AAREA,_NDIAS,_AAREASZR,_NTXCONTRATO,_NTXIOF,_NTXCPMF")
SetPrvt("_NPERCENTUAL,_NDESAGIO,_NIOF,_NCPMF,_AAREASEA,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FA60BDE  ³ Autor ³Ricardo Correa de Souza³ Data ³31/01/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto Entrada Executado na Operacao Desconto (SE1/SE5)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/                                                            

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_aArea := GetArea()

//----> verifica se o titulo foi selecionado para o bordero
If SE1->E1_OK <> cMarca
    Return
EndIf

//----> verifica se o numero do bordero esta vazio
If SE1->E1_NUMBOR == space(6)
    Return
EndIf

//----> verifica se o saldo do titulo ‚ maior que zero
If SE1->E1_SALDO == 0
    Return
EndIf

DbSelectArea("SZR")
_aAreaSZR := GetArea()
DbSetOrder(1)
DbSeek(xFilial("SZR")+SE1->E1_NUMBOR)
If Found()
    _nDias         := (se1->e1_vencrea + szr->zr_float) - dDataBase 
    _nTaxaContrato := szr->zr_contrat

    _nPercentual   := round((szr->zr_contrat * _nDias) / 100,10)
    _nDesagio      := round(SE1->e1_saldo * _nPercentual,2)

    _nPercentual   := round((szr->zr_iof * _nDias) / 100,6)
    _nIof          := round(SE1->e1_saldo * _nPercentual,2)

    _nCpmf         := round(SE1->e1_saldo * round(szr->zr_cpmf / 100,8),2)

    _nDesconto     := _nDesagio    + _nIof + _nCpmf 

    _nTotDesagio   := _nTotDesagio + _nDesconto

    _nTotBordero   := _nTotBordero + SE1->e1_saldo
Else
    RestArea(_aAreaSZR)
    RestArea(_aArea)
    Return
Endif

DbSelectArea("SEA")

_aAreaSEA := GetArea()

DbSetOrder(1)
DbSeek(xFilial("SEA")+;
       SE1->E1_NUMBOR+;
       SE1->E1_PREFIXO+;
       SE1->E1_NUM+;
       SE1->E1_PARCELA+;
       SE1->E1_TIPO)

If Found()
    RecLock("SEA",.f.)
Else
    RecLock("SEA",.t.)
EndIf

_field->EA_FILIAL       := xFilial('SEA')
_field->EA_PREFIXO      := SE1->E1_PREFIXO
_field->EA_NUM          := SE1->E1_NUM
_field->EA_PARCELA      := SE1->E1_PARCELA
_field->EA_TIPO         := SE1->E1_TIPO
_field->EA_NUMBOR       := SE1->E1_NUMBOR
_field->EA_DESAGIO      := _nDesagio
_field->EA_IOF          := _nIof
_field->EA_TARIFA       := SZR->ZR_TARIFA
_field->EA_DOC          := SZR->ZR_DOC
_field->EA_CPMF         := _nCpmf
_field->EA_DIAS         := _nDias
_field->EA_TAC          := SZR->ZR_TAC

MsUnLock()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna a Integridade dos Arquivos Antes da Manipulacao                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

RestArea(_aAreaSZR)
RestArea(_aAreaSEA)
RestArea(_aArea)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
