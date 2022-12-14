#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Mt010inc()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_CORDEM,_CARTIGO,_CFW,_CCOMP,_CLARG,_CPESO")
SetPrvt("_CTGMNT,_LSAIR,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? MT010INC ? Autor ?                       ? Data ?13/06/2002낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Forca a Inclusao da Composicao no Cadastramento do Produto 낢?
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
If SB1->B1_TIPO == "PA"
    DbSelectArea("SZ1")
    DbSetOrder(1)
    If DbSeek(xFilial("SZ1")+Subs(SB1->B1_COD,1,3),.F.)
        Return
    Else
        _cOrdem   := space(03)
        _cArtigo  := space(20)
        _cFW      := space(01)
        _cComp    := space(90)
        _cLarg    := space(10)
        _cPeso    := space(10)
        _cTgmnt   := space(10)
        _lSair    := .F.  
    
        While .t.
    
            @ 025,005 To 400,780 Dialog janela1 Title OemToAnsi("Cadastro de Composicao Kenia")

            @ 050,010 Say OemToAnsi("Ordem     ") Size 37,8
            @ 050,055 Say OemToAnsi("Artigo    ") Size 37,8

            @ 080,010 Say OemToAnsi("F/W       ") Size 37,8
            @ 080,055 Say OemToAnsi("Composicao") Size 37,8
    
            @ 110,010 Say OemToAnsi("Largura   ") Size 37,8
            @ 110,110 Say OemToAnsi("Peso      ") Size 37,8
            @ 110,210 Say OemToAnsi("Tingimento") Size 37,8
    
            @ 060,010 Get _cOrdem   Picture "@!"         
            @ 060,055 Get _cArtigo  Picture "@!"         
    
            @ 090,010 Get _cFW      Picture "@!"
            @ 090,055 Get _cComp    Picture "@!"
	
            @ 120,010 Get _cLarg    Picture "@!"
            @ 120,110 Get _cPeso    Picture "@!"
            @ 120,210 Get _cTgmnt   Picture "@!"

            @ 165,340 BmpButton Type 1 Action Composicao()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>             @ 165,340 BmpButton Type 1 Action Execute(Composicao)

            Activate Dialog janela1
    
            If _lSair
                Exit
            EndIf
        EndDo

        MarkBRefresh()
    EndIf
EndIf

Return   

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Composicao
Static Function Composicao()

RecLock("SZ1",.t.)
  SZ1->Z1_FILIAL    :=  xFilial("SZ1")
  SZ1->Z1_ORDEM     :=  _cOrdem  
  SZ1->Z1_ARTIGO    :=  _cArtigo 
  SZ1->Z1_FW        :=  _cFW     
  SZ1->Z1_COMP      :=  _cComp   
  SZ1->Z1_LARG      :=  _cLarg   
  SZ1->Z1_PESO      :=  _cPeso   
  SZ1->Z1_TGMNT     :=  _cTgmnt  
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

