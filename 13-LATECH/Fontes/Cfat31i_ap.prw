#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Cfat31i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CNUMPEDSP,_CNUMPED,_CITEMSP,_CPRODSP,_CUMSP,_NQTDSP")
SetPrvt("_NPRCSP,_CLOCSP,_DENTSP,_CDESSP,_CCLASP,_CESPSP")
SetPrvt("_CCLISP,_CLOJSP,ASC5,_CTEMPSC5,ASC6,_CTEMPSC6")

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±³ Programa   ³ CFAT31I   ³ Autor ³Ricardo Correa de Souza³ Data ³25.07.2000³±
±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±³ Funcao     ³ Replicar os Pedidos de Vendas da Coel Sao Paulo para Coel   ³±
±³            ³ Sao Roque como Pedidos de Vendas (Transferencia)            ³±
±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±³ Uso        ³ Especifico Coel Controles Eletricos Ltda (Sao Roque)        ³±
±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±
±³            ³           ³ Autor ³                       ³ Data ³          ³±
±³ Alteracoes ÃÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±³            ³                                                             ³±
±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Definicao de Variaveis                                                     *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

_cNumPedSP:= ""         //----> Armazena numero pedido Sao Paulo
_cNumPed  := ""         //----> Armazena numero pedido extraido GETSX8NUM()
_cItemSP  := ""         //----> Armazena item do pedido Sao Paulo
_cProdSP  := ""         //----> Armazena produto do pedido Sao Paulo
_cUmSP    := ""         //----> Armazena unidade de medida produto Sao Paulo
_nQtdSP   := 0          //----> Armazena quantidade do produto Sao Paulo
_nPrcSP   := 0          //----> Armazena preco de lista produto Sao Paulo
_cLocSP   := ""         //----> Armazena local produto Sao Paulo
_dEntSP   := 01/01/00   //----> Armazena data de entrega produto Sao Paulo
_cDesSP   := ""         //----> Armazena descricao produto Sao Paulo
_cClaSP   := ""         //----> Armazena classificacao fiscal Sao Paulo
_cEspSP   := ""         //----> Armazena caso especial produto Sao Paulo
_cCliSP   := ""         //----> Armazena cliente pedido Sao Paulo
_cLojSP   := ""         //----> Armazena loja do cliente pedido Sao Paulo

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Cria arquivos temporarios para gravacao dos dados                          *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

//----> Arquivo Temporario para SC5
aSC5 := {} //----> Matriz vazia para armazenar estrutura do arquivo

Aadd(aSC5,{"C5_FILIAL   ","C",2 ,0})
Aadd(aSC5,{"C5_NUM      ","C",6 ,0})
Aadd(aSC5,{"C5_TIPO     ","C",1 ,0})
Aadd(aSC5,{"C5_CLIENTE  ","C",6 ,0})
Aadd(aSC5,{"C5_LOJAENT  ","C",2 ,0})
Aadd(aSC5,{"C5_LOJACLI  ","C",2 ,0})
Aadd(aSC5,{"C5_CLPEDCL  ","C",10,0})
Aadd(aSC5,{"C5_CLNOMCL  ","C",10,0})
Aadd(aSC5,{"C5_CLOS     ","C",1 ,0})
Aadd(aSC5,{"C5_CLPARC   ","C",1 ,0})
Aadd(aSC5,{"C5_CLANTE   ","C",1 ,0})
Aadd(aSC5,{"C5_CLATEND  ","C",20,0})
Aadd(aSC5,{"C5_TRANSP   ","C",6 ,0})
Aadd(aSC5,{"C5_TIPOCLI  ","C",1 ,0})
Aadd(aSC5,{"C5_CONDPAG  ","C",3 ,0})
Aadd(aSC5,{"C5_TABELA   ","C",1 ,0})
Aadd(aSC5,{"C5_VEND1    ","C",6 ,0})
Aadd(aSC5,{"C5_DESC1    ","N",5 ,0})
Aadd(aSC5,{"C5_EMISSAO  ","D",8 ,0})
Aadd(aSC5,{"C5_TPFRETE  ","C",1 ,0})
Aadd(aSC5,{"C5_MOEDA    ","N",1 ,0})
Aadd(aSC5,{"C5_TIPLIB   ","C",1 ,0})

_cTempSC5 := CriaTrab( aSC5, .T. ) 
DbUseArea(.T.,__cRdd,_cTempSC5,"TB5",IF(.T. .OR. .F., !.F., NIL), .F. )

//----> Arquivo Temporario para SC6
aSC6 := {} //----> Matriz vazia para armazenar estrutura do arquivo

Aadd(aSC6,{"C6_FILIAL   ","C",2 ,0})
Aadd(aSC6,{"C6_ITEM     ","C",2 ,0})
Aadd(aSC6,{"C6_PRODUTO  ","C",15,0})
Aadd(aSC6,{"C6_UM       ","C",2 ,0})
Aadd(aSC6,{"C6_QTDVEN   ","N",9 ,2})
Aadd(aSC6,{"C6_PRCVEN   ","N",14,4})
Aadd(aSC6,{"C6_VALOR    ","N",12,2})
Aadd(aSC6,{"C6_TES      ","C",3 ,0})
Aadd(aSC6,{"C6_CF       ","C",3 ,0})
Aadd(aSC6,{"C6_LOCAL    ","C",2 ,0})
Aadd(aSC6,{"C6_CLI      ","C",6 ,0})
Aadd(aSC6,{"C6_ENTREG   ","D",8 ,0})
Aadd(aSC6,{"C6_LOJA     ","C",2 ,0})
Aadd(aSC6,{"C6_NUM      ","C",6 ,0})
Aadd(aSC6,{"C6_PEDCLI   ","C",9 ,0})
Aadd(aSC6,{"C6_DESCRI   ","C",30,0})
Aadd(aSC6,{"C6_PRUNIT   ","N",14,4})
Aadd(aSC6,{"C6_CLASFIS  ","C",3 ,0})
Aadd(aSC6,{"C6_CLESPEC  ","C",1 ,0})
Aadd(aSC6,{"C6_CLPEDSP  ","C",6 ,0})
Aadd(aSC6,{"C6_CLITPSP  ","C",2 ,0})
Aadd(aSC6,{"C6_CLCLISP  ","C",6 ,0})
Aadd(aSC6,{"C6_CLLOJSP  ","C",2 ,0})

_cTempSC6 := CriaTrab( aSC6, .T. ) 
DbUseArea(.T.,__cRdd,_cTempSC6,"TB6",IF(.T. .OR. .F., !.F., NIL), .F. )

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Arquivos utilizados no processamento                                       *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

Processa({||RunProc()},"Selecionando Registros Pedidos Vendas")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Selecionando Registros Pedidos Vendas")
__RetProc()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC5")
DbGoTop()           
ProcRegua(LastRec())

While Eof() == .f. 

    IncProc("Processando Pedido "+SC5->C5_NUM)

    If !Marked("C5_OK")
        DbSkip()
        Loop
    Else
        //----> guardando dados pedido Sao Paulo
        _cNumPedSP := SC5->C5_NUM
    
        //----> gravando dados pedido transferencia Sao Roque para Sao Paulo
        DbSelectArea("TB5")
        RecLock("TB5",.T.)
            _cNumPed := GetSX8Num("SC5") //----> buscando a numeracao do pedido
            ConfirmSX8()                 //----> a ser gravado

            TB5->C5_FILIAL      := xFilial("SC5")
            TB5->C5_NUM         := _cNumPed
            TB5->C5_TIPO        := "N"
            TB5->C5_CLIENTE     := "000649"
            TB5->C5_LOJAENT     := "01"
            TB5->C5_LOJACLI     := "01"
            TB5->C5_CLNOMCL     := "COEL SP"
            TB5->C5_CLOS        := "N"
            TB5->C5_CLPARC      := "N"
            TB5->C5_CLANTE      := "N"
            TB5->C5_CLATEND     := "TRANSF.P/SP"
            TB5->C5_TRANSP      := "100002"
            TB5->C5_TIPOCLI     := "R"
            TB5->C5_CONDPAG     := "999"
            TB5->C5_TABELA      := "1"
            TB5->C5_VEND1       := "90001"
            TB5->C5_DESC1       := 70
            TB5->C5_EMISSAO     := dDataBase
            TB5->C5_TPFRETE     := "C"
            TB5->C5_MOEDA       := 1
            TB5->C5_TIPLIB      := "2"
        MsUnLock()
    
        DbSelectArea("SC5")
        RecLock("SC5",.f.)
            SC5->C5_PVTOK       := "S"
            SC5->C5_OK          := Space(02)
        MsUnLock()

        DbSelectArea("SC6")
        DbSeek(xFilial("SC6")+_cNumPedSP) //----> pesquisando pedido de Sao Paulo
        While Eof() == .f. .and. SC6->C6_NUM == _cNumPedSP
    
            //----> guardando dados itens pedido Sao Paulo
            _cItemSP := SC6->C6_ITEM
            _cProdSP := SC6->C6_PRODUTO
            _cUmSP   := SC6->C6_UM
            _nQtdSP  := SC6->C6_QTDVEN
            _nPrcSP  := SC6->C6_PRUNIT
            _cLocSP  := SC6->C6_LOCAL
            _dEntSP  := SC6->C6_ENTREG
            _cDesSP  := SC6->C6_DESCRI
            _cClaSP  := SC6->C6_CLASFIS
            _cEspSP  := SC6->C6_CLESPEC
            _cCliSP  := SC6->C6_CLI
            _cLojSP  := SC6->C6_LOJA
    
            //----> gravando itens pedidos transferencia Sao Roque para Sao Paulo
            DbSelectArea("TB6")
            RecLock("TB6",.t.)
                TB6->C6_FILIAL      := xFilial("SC6")
                TB6->C6_ITEM        := _cItemSP
                TB6->C6_PRODUTO     := _cProdSP
                TB6->C6_UM          := _cUmSP
                TB6->C6_QTDVEN      := _nQtdSP
                TB6->C6_PRCVEN      := ( _nPrcSP * 0.30 ) //----> valor transferencia
                TB6->C6_VALOR       := ( _nQtdSP * ( _nPrcSP * 0.30 ))
                TB6->C6_TES         := "511"
                TB6->C6_CF          := "521"
                TB6->C6_LOCAL       := _cLocSP
                TB6->C6_CLI         := "000649"
                TB6->C6_LOJA        := "01"
                TB6->C6_ENTREG      := _dEntSP
                TB6->C6_NUM         := _cNumPed
                TB6->C6_PRUNIT      := _nPrcSP
                TB6->C6_DESCRI      := _cDesSP
                TB6->C6_CLASFIS     := _cClaSP
                TB6->C6_CLESPEC     := _cEspSP
                TB6->C6_CLPEDSP     := _cNumPedSP
                TB6->C6_CLITPSP     := _cItemSP
                TB6->C6_CLCLISP     := _cCliSP
                TB6->C6_CLLOJSP     := _cLojSP
                TB6->C6_PEDCLI      := _cNumPedSP+"/"+_cItemSP
            MsUnLock()

            DbSelectArea("SC6")
            DbSkip()
        End

        DbSelectArea("SC5")
        DbSkip()
    EndIf
End

DbSelectArea("TB5")
DbGoTop()
While Eof() == .f.

    DbSelectArea("SC5")
    RecLock("SC5",.t.)
        SC5->C5_FILIAL      := TB5->C5_FILIAL
        SC5->C5_NUM         := TB5->C5_NUM
        SC5->C5_TIPO        := TB5->C5_TIPO
        SC5->C5_CLIENTE     := TB5->C5_CLIENTE
        SC5->C5_LOJAENT     := TB5->C5_LOJAENT
        SC5->C5_LOJACLI     := TB5->C5_LOJACLI
        SC5->C5_CLNOMCLI    := TB5->C5_CLNOMCLI
        SC5->C5_CLOS        := TB5->C5_CLOS
        SC5->C5_CLPARC      := TB5->C5_CLPARC
        SC5->C5_CLANTE      := TB5->C5_CLANTE
        SC5->C5_CLATEND     := TB5->C5_CLATEND
        SC5->C5_TRANSP      := TB5->C5_TRANSP
        SC5->C5_TIPOCLI     := TB5->C5_TIPOCLI
        SC5->C5_CONDPAG     := TB5->C5_CONDPAG
        SC5->C5_TABELA      := TB5->C5_TABELA
        SC5->C5_VEND1       := TB5->C5_VEND1
        SC5->C5_DESC1       := TB5->C5_DESC1
        SC5->C5_EMISSAO     := TB5->C5_EMISSAO
        SC5->C5_TPFRETE     := TB5->C5_TPFRETE
        SC5->C5_MOEDA       := TB5->C5_MOEDA
        SC5->C5_TIPLIB      := TB5->C5_TIPLIB
    MsUnLock()
        
    DbSelectArea("TB5")
    DbSkip()
End

DbCloseArea()

DbSelectArea("TB6")
DbGoTop()
While Eof() == .f.
    DbSelectArea("SC6")
    RecLock("SC6",.t.)
        SC6->C6_FILIAL      := TB6->C6_FILIAL
        SC6->C6_ITEM        := TB6->C6_ITEM
        SC6->C6_PRODUTO     := TB6->C6_PRODUTO
        SC6->C6_UM          := TB6->C6_UM
        SC6->C6_QTDVEN      := TB6->C6_QTDVEN
        SC6->C6_PRCVEN      := TB6->C6_PRCVEN 
        SC6->C6_VALOR       := TB6->C6_VALOR
        SC6->C6_TES         := TB6->C6_TES
        SC6->C6_CF          := TB6->C6_CF
        SC6->C6_LOCAL       := TB6->C6_LOCAL
        SC6->C6_CLI         := TB6->C6_CLI
        SC6->C6_LOJA        := TB6->C6_LOJA
        SC6->C6_ENTREG      := TB6->C6_ENTREG
        SC6->C6_NUM         := TB6->C6_NUM
        SC6->C6_PRUNIT      := TB6->C6_PRUNIT
        SC6->C6_DESCRI      := TB6->C6_DESCRI
        SC6->C6_CLASFIS     := TB6->C6_CLASFIS
        SC6->C6_CLESPEC     := TB6->C6_CLESPEC
        SC6->C6_CLPEDSP     := TB6->C6_CLPEDSP
        SC6->C6_CLITPSP     := TB6->C6_CLITPSP
        SC6->C6_CLCLISP     := TB6->C6_CLCLISP
        SC6->C6_CLLOJSP     := TB6->C6_CLLOJSP
        SC6->C6_PEDCLI      := TB6->C6_PEDCLI 
    MsUnLock()

    DbSelectArea("TB6")
    DbSkip()
End

DbCloseArea()

Ferase(_cTempSC5+".dbf")
Ferase(_cTempSC5+".idx")
Ferase(_cTempSC5+".mem")
Ferase(_cTempSC6+".dbf")
Ferase(_cTempSC6+".idx")
Ferase(_cTempSC6+".mem")

//MsgBox("Pedidos de Transferencia gerados com sucesso !!!","Pedidos de Transferencia","Alert")

__RetProc()

*----------------------------------------------------------------------------*
* Fim                                                                        *
*----------------------------------------------------------------------------*


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

