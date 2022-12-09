#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Mt010inc()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CORDEM,_CARTIGO,_CFW,_CCOMP,_CLARG,_CPESO")
SetPrvt("_CTGMNT,_LSAIR,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT010INC ³ Autor ³                       ³ Data ³13/06/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Forca a Inclusao da Composicao no Cadastramento do Produto ³±±
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

