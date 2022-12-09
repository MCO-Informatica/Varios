#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Cest18i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NCUSTOUNIT,_NCUSTOITEM,_NCUSTOTOTAL,_CPERG,CPRODUTO,AREGS")
SetPrvt("I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CEST18I  ³ Autor ³Ricardo Correa de Souza³ Data ³22/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Custo Standard para Estrutura de Produtos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Coel Controles Eletricos Ltda                              ³±±
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
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_nCustoUnit  := 0   //----> custo unitario do componente
_nCustoItem  := 0   //----> 
_nCustoTotal := 0
_cPerg       := "EST18I" 

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Inicio do Processamento                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()

//----> verifica se o usuario cancelou a execucao
If ! Pergunte(_cPerg,.t.)
    Return
EndIf

Processa({||RunProc()},"Atualiza Custo Standard Produtos")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Atualiza Custo Standard Produtos")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SG1")
DbSetOrder(1)
ProcRegua(LastRec())

cProduto := SG1->G1_COD

While Eof() == .f. 

    IncProc("Processando Produtos "+SG1->G1_COD)

    DbSelectArea("SB1")
    DbSetOrder(1)
    If ! DbSeek(xFilial("SB1")+cProduto)
        DbSelectArea("SG1")
        DbSkip()
        Loop
    EndIf

    //----> selecionando tipos de produtos informado nos parametros
    If SB1->B1_TIPO < mv_par01 .AND. SB1->B1_TIPO > mv_par02
        DbSelectArea("SG1")
        DbSkip()
        Loop
    EndIf

    //----> varrendo toda a estrutura do produto
    While SG1->G1_COD == cProduto

        DbSelectArea("SB1")
        DbSetOrder(1)
        If DbSeek(xFilial("SB1")+SG1->G1_COMP)
            _nCustoUnit  := SB1->B1_CUSTD
            _nCustoItem  := noRound(SG1->G1_QUANT * _nCustoUnit,4)
            _nCustoTotal := noRound(_nCustoTotal  + _nCustoItem,4)
        EndIf

        DbSelectArea("SG1")
        DbSkip()
    EndDo

    DbSelectArea("SB1")
    DbSetOrder(1)
    DbSeek(xFilial("SB1")+cProduto)
    RecLock("SB1",.f.)
      SB1->B1_CUSTD := noRound(_nCustoTotal,4)
    MsUnLock()

    _nCustoTotal := 0

    DbSelectArea("SG1")
    cProduto := SG1->G1_COD
EndDo

DbSelectArea("SG1")
DbSetOrder(1)
DbGoTop()

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)

aRegs :={}
Aadd(aRegs,{_cPerg,"01","Do Tipo                 ?","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","   "})
Aadd(aRegs,{_cPerg,"02","Ate o Tipo              ?","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","   "})
Aadd(aRegs,{_cPerg,"03","Do Produto              ?","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SB1"})
Aadd(aRegs,{_cPerg,"04","Ate o Produto           ?","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","SB1"})

For i:=1 to Len(aRegs)
    If !DbSeek(_cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    EndIf
Next

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao ValidPerg                                                   *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

