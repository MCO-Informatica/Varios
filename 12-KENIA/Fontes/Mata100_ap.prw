#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Mata100()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CMOTIVO1,_CMOTIVO2,_LSAIR,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? MATA100  ? Autor 쿝icardo Correa de Souza? Data ?06/10/2001낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Monta Tela de Observacoes para Notas de Devolucao          낢?
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

//----> verifica se trata-se de notas fiscais de devolucao
If cTipo == "D"

    _cMotivo1 := space(50)
    _cMotivo2 := space(50)
    _lSair    := .F.  

    While .t.

        @ 025,005 To 400,600 Dialog janela1 Title OemToAnsi("Observacoes Nota Fiscal de Devolucao")

        @ 050,010 Say OemToAnsi("Motivo 1") Size 37,8
        @ 080,010 Say OemToAnsi("Motivo 2") Size 37,8
    
        @ 060,010 Get _cMotivo1 Picture "@!"         
        @ 090,010 Get _cMotivo2 Picture "@!"         
	
        @ 165,220 BmpButton Type 1 Action GravaObs()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>         @ 165,220 BmpButton Type 1 Action Execute(GravaObs)
        //@ 165,260 BmpButton Type 2 Action CloseJan()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>         //@ 165,260 BmpButton Type 2 Action Execute(CloseJan)

        Activate Dialog janela1
    
        If _lSair
            Exit
        EndIf
    EndDo

    MarkBRefresh()

EndIf

Return()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
/*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CloseJan
Static Function CloseJan()

_lSair := .T.

Close(janela1)

Return()
*/
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao CloseJan                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function GravaObs
Static Function GravaObs()

DbSelectArea("SF1")
DbSetOrder(1)
DbSeek(xFilial("SF1")+CNFISCAL+CSERIE+CA100FOR+CLOJA)

RecLock("SF1",.f.)
  SF1->F1_OBSDEV1   :=  _cMotivo1
  SF1->F1_OBSDEV2   :=  _cMotivo2
MsUnLock()

_lSair := .T.

Close(janela1)

Return()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao GravaObs                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

