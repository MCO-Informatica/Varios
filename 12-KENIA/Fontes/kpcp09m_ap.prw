#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function kpcp09m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CPRODUTO,_NQTDMETROS,_NQTDSALDO,_NCONVERSAO,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? KPCP09M  ? Autor ?                       ? Data ?11/02/2002낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Transfere Metros de Tecido Tinto para Quilos 110098        낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿢so       ? Kenia Industrias Texteis Ltda                              낢?
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           낢?
굇쳐컴컴컴컴컴컴컫컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?   Analista   ?  Data  ?             Motivo da Alteracao               낢?
굇쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?              ?        ?                                               낢?
굇읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_cProduto    := "110098"
_nQtdMetros  := M->D3_QUANT  
_nQtdSaldo   := 0

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+M->D3_COD)

_nConversao := SB1->B1_PESO

If MsgBox("Para atualizacao do estoque em quilos do produto 110098, clique << SIM >>.","Atualizacao Estoque 110098","YesNo")

    _nQtdMetros := M->D3_QUANT * _nConversao

    DbSelectArea("SD3")
    RecLock("SD3",.T.)
      SD3->D3_FILIAL  :=  xFilial("SD3")
      SD3->D3_COD     :=  _cProduto
      SD3->D3_TM      :=  "004"
      SD3->D3_UM      :=  "KG"
      SD3->D3_QUANT   :=  _nQtdMetros
      SD3->D3_LOCAL   :=  "01"
      SD3->D3_DOC     :=  "MTSKGS"
      SD3->D3_EMISSAO :=  dDataBase
      SD3->D3_CF      :=  "DE0"
      SD3->D3_NUMSEQ  := GETMV("MV_DOCSEQ")  
    MsUnLock()
    
    DbSelectArea("SB2")
    DbSetOrder(1)
    DbSeek(xFilial("SB2")+_cProduto)
    
    _nQtdSaldo := SB2->B2_QATU
    
    RecLock("SB2",.f.)
      SB2->B2_QATU  := _nQtdSaldo + _nQtdMetros 
      SB2->B2_VATU1 := Round(SB2->B2_QATU * SB2->B2_CM1,2)
    MsUnLock()

    MsgBox("Estoque 110098 atualizado com sucesso !!","Confirma Atualizacao","Info")
EndIf

Return(_nQtdMetros)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

