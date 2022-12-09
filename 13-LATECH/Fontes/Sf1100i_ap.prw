#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Sf1100i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CMOTIVO1,_CMOTIVO2,_CTRANSP,_CNOMETRANSP,_NVOLUME,_NPBRUTO")
SetPrvt("_LSAIR,_LRETORNO,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SF1100I  ³ Autor ³Ricardo Correa de Souza³ Data ³06/10/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monta Tela de Observacoes para Notas de Entrada            ³±±
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

_cMotivo1   :=  Space(50)
_cMotivo2   :=  Space(50)
_cTransp    :=  Space(06)
_cNomeTransp:=  Space(30)
_nVolume    :=  0
_nPBruto    :=  0
_lSair      :=  .F.

While .t.

    @ 025,005 To 500,605 Dialog janela1 Title OemToAnsi("Observacoes da Nota Fiscal de Entrada")

    @ 010,010 Say OemToAnsi("Nota Fiscal") 
    @ 010,045 Get SF1->F1_DOC Picture "@!" When .f.
    @ 010,090 Say OemToAnsi("Serie") 
    @ 010,119 Get SF1->F1_SERIE Picture "@!" When .f.
    @ 010,150 Say OemToAnsi("Emissao") 
    @ 010,180 Get SF1->F1_EMISSAO When .f.
    @ 010,227 Say OemToAnsi("Entrada") 
    @ 010,258 Get SF1->F1_DTDIGIT When .f.
    If SF1->F1_TIPO$"D/B"
        @ 025,010 Say OemToAnsi("Cliente") 
        @ 025,045 Get SF1->F1_FORNECE When .f.
        @ 025,090 Say OemToAnsi("Loja") 
        @ 025,125 Get SF1->F1_LOJA When .f.
        @ 035,045 Get SA1->A1_NOME When .f.
    Else
        @ 025,010 Say OemToAnsi("Fornecedor") 
        @ 025,045 Get SF1->F1_FORNECE When .f.
        @ 025,090 Say OemToAnsi("Loja") 
        @ 025,125 Get SF1->F1_LOJA When .f.
        @ 035,045 Get SA2->A2_NOME When .f.
    EndIf
    @ 055,010 Say OemToAnsi("Transportadora") Size 37,8
    @ 055,050 Get _cTransp F3 "SA4" Picture "@!" Valid BuscaTransp()        // Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     @ 055,050 Get _cTransp F3 "SA4" Picture "@!" Valid Execute(BuscaTransp)        
    @ 065,050 Get _cNomeTransp Picture "@!"  When .f.

    @ 095,010 Say OemToAnsi("Volume") Size 37,8
    @ 095,030 Get _nVolume Picture "999"        

    @ 095,210 Say OemToAnsi("Peso Bruto") Size 37,8
    @ 095,240 Get _nPBruto Picture "@E 999,999,999.99"

    @ 125,010 Say OemToAnsi("Observacao 1") Size 37,8
    @ 135,010 Get _cMotivo1 Picture "@!"         

    @ 155,010 Say OemToAnsi("Observacao 2") Size 37,8
    @ 165,010 Get _cMotivo2 Picture "@!"         
	
    @ 195,110 Say OemToAnsi("Clique no botao <<OK>> para gravar os dados ---------->") 
    @ 195,260 BmpButton Type 1 Action GravaObs()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     @ 195,260 BmpButton Type 1 Action Execute(GravaObs)

    @ 220,040 Say OemToAnsi("***** Os campos acima sao importantes para o controle do Seguro de Cargas Transportadas *****")
    Activate Dialog janela1
   
    If _lSair
        Exit
    EndIf
EndDo

//MarkBRefresh()

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

RecLock("SF1",.f.)
  SF1->F1_X_TRANS   :=  _cTransp 
  SF1->F1_X_VOLUM   :=  _nVolume 
  SF1->F1_X_PESOB   :=  _nPBruto 
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

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function BuscaTransp
Static Function BuscaTransp()

DbSelectArea("SA4")
DbSetOrder(1)
If DbSeek(xFilial("SA4")+_cTransp,.f.)
   _cNomeTransp    := SA4->A4_NOME
   _lRetorno := .t.
Else
    MsgBox("O codigo digitado nao existe no Cadastro de Transportadoras. Informe um codigo valido.","Valida Transportadora","Stop")
    _lRetorno := .f.
EndIF

SysRefresh()

Return(_lRetorno)


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

