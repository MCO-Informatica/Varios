#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function kpcp04m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CCOMP,CTRT,NQUANT,NPERDA,DINI,DFIM")
SetPrvt("NNIV,CNIV,COBSERV,CFIXVAR,NNIVINV,CNIVINV")
SetPrvt("CREVFIM,NRECNO,CPERG,CETAPA,AREGS,I")
SetPrvt("J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KPCP04M  ³ Autor ³Ricardo Correa de Souza³ Data ³31/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Exclui Receita da Estrutura e Acerta Produtos Quimicos     ³±±
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
* Variaveis Utilizadas nos Parametros                                       *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

//mv_par01     ----> Produto Pai                                            *
//mv_par02     ----> Componente                                             *

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cComp   :=  Space(15)       //----> codigo do componente na estrutura
cTrt    :=  Space(03)       //----> sequencia do componente na estrutura
nQuant  :=  0               //----> quantidade utilizada na estrutura
nPerda  :=  0               //----> quantidade de perda utilizada na estrutura
dIni    :=  dDataBase       //----> data inicial da estrutura
dFim    :=  dDataBase       //----> data validade da estrutura
nNiv    :=  0               //----> variavel auxilial no calculo do nivel
cNiv    :=  Space(02)       //----> nivel do componente na estrutura
cObserv :=  Space(45)       //----> observacoes da estrutura
cFixVar :=  Space(01)       //----> indicador de quantidade fixa ou variavel
nNivInv :=  0               //----> variavel auxilial no calculo do nivel invertido
cNivInv :=  Space(02)       //----> nivel invertido do componente na estrutura
cRevFim :=  Space(03)       //----> ultima revisao da estrutura
nRecno  :=  0               //----> variavel que armazena o numero do registro atual

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({|| RunProc()},"Exclui o Produto Receita da Estrutura")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({|| Execute(RunProc)},"Exclui o Produto Receita da Estrutura")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

cPerg := "PCP04M    "

ValidPerg()     //----> verifica se existe grupo de perguntas no SX1

Pergunte( cPerg, .t. )

DbSelectArea("SG1")
DbSetOrder(1)
If !DbSeek(xFilial("SG1")+mv_par02)
    MsgBox("Sr(a) "+Alltrim(Subs(cUsuario,7,14))+", o Produto Receita "+Alltrim(mv_par02)+" nao foi encontrado. Provavelmente este produto ja foi excluido da estrutura, favor verificar","Valida Produto Receita","Alert")
Else

    ProcRegua(LastRec())

    While Eof() == .f. .And. SG1->G1_COD  == mv_par02

        IncProc("Acertando Receita do Produto "+SG1->G1_COD)

        //----> armazenando os dados dos componentes do produto RECEITA
        cComp   :=  SG1->G1_COMP
        cTrt    :=  SG1->G1_TRT
        nQuant  :=  SG1->G1_QUANT
        nPerda  :=  SG1->G1_PERDA
        dIni    :=  SG1->G1_INI
        dFim    :=  SG1->G1_FIM
        nNiv    :=  Val(SG1->G1_NIV) - 1
        cNiv    :=  StrZero(nNiv,2)
        cObserv :=  SG1->G1_OBSERV
        cFixVar :=  SG1->G1_FIXVAR
        nNivInv :=  Val(SG1->G1_NIVINV) + 1
        cNivInv :=  StrZero(nNivInv,2)
        cRevFim :=  SG1->G1_REVFIM
        cEtapa  :=  SG1->G1_ETAPA

        nRecno  := Recno()
    
        //----> deletando o produto RECEITA da estrutura
        RecLock("SG1",.f.)
          DbDelete()
        MsUnLock()

        //----> gravando os componentes da receita embaixo do produto ACABADO
        RecLock("SG1",.t.)
          SG1->G1_FILIAL    :=  xFilial("SG1")
          SG1->G1_COD       :=  mv_par01
          SG1->G1_COMP      :=  cComp
          SG1->G1_TRT       :=  cTrt
          SG1->G1_QUANT     :=  nQuant
          SG1->G1_PERDA     :=  nPerda
          SG1->G1_INI       :=  dIni
          SG1->G1_FIM       :=  dFim 
          SG1->G1_NIV       :=  cNiv
          SG1->G1_OBSERV    :=  cObserv 
          SG1->G1_FIXVAR    :=  cFixVar
          SG1->G1_NIVINV    :=  cNivInv 
          SG1->G1_REVFIM    :=  cRevFim 
          SG1->G1_ETAPA     :=  cEtapa
        MsUnLock()

        DbGoTo(nRecno)
        DbSkip()
    EndDo
EndIf

//----> deletando o produto RECEITA do nivel abaixo do produto ACABADO
DbSelectArea("SG1")
If !DbSeek(xFilial("SG1")+mv_par01+mv_par02)
Else
    RecLock("SG1",.f.)
      DbDelete()
    MsUnLock()
EndIf

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)

aRegs := {}

aadd(aRegs,{cPerg,'01','Produto Acabado  ','mv_ch1','C',15, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
aadd(aRegs,{cPerg,'02','Receita a Excluir','mv_ch2','C',15, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})

For i:=1 to Len(aRegs)
    DbSeek(cPerg+StrZero(i,2))
    If Found() == .f.
        RecLock("SX1",.t.)
        For j:=1 to fCount()
            FieldPut(j,aRegs[i,j])
        Next
        MsUnLock()
    EndIf
Next

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao ValidPerg                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
