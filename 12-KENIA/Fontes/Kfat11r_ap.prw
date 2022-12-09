#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Kfat11r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AFAT,CTEMPFAT,APED,CTEMPPED,WNREL,CDESC1")
SetPrvt("CDESC2,CDESC3,CSTRING,LEND,TAMANHO,LIMITE")
SetPrvt("TITULO,ARETURN,NOMEPROG,NLASTKEY,ADRIVER,CBCONT")
SetPrvt("CPERG,NLIN,M_PAG,NQTDFAT,NQTDPED,NQTDSALDO")
SetPrvt("CPRODUTO,CCLIENTE,CTITADD1,CABEC1,CABEC2,REGUA1")
SetPrvt("REGUA2,_CINDEX,_CCHAVE,CAUXVEND,AREGS,I")
SetPrvt("J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT11R  ³ Autor ³Ricardo Correia        ³ Data ³09/05/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Faturamento e Pedidos em Aberto por Vendedor    ³±±
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

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==>     #DEFINE PSAY SAY
#ENDIF

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aFat :={}

AADD(aFat,{"CODVEND ","C",06,0})
AADD(aFat,{"NOMEVEND","C",15,0})
AADD(aFat,{"NOTA    ","C",06,0})
AADD(aFat,{"PEDIDO  ","C",06,0})
AADD(aFat,{"PEDCLI  ","C",06,0})
AADD(aFat,{"CODCLI  ","C",06,0})
AADD(aFat,{"LOJCLI  ","C",02,0})
AADD(aFat,{"NOMECLI ","C",15,0})
AADD(aFat,{"PRODUTO ","C",15,0})
AADD(aFat,{"QTDFAT  ","N",09,2})
AADD(aFat,{"VALUNIT ","N",09,2})
AADD(aFat,{"DATFAT  ","D",08,0})
AADD(aFat,{"DATPED  ","D",08,0})
AADD(aFat,{"DATENT  ","D",08,0})
AADD(aFat,{"COMISS  ","N",05,2})

cTempFat := CriaTrab( aFat, .T. )
DbUseArea(.T.,,cTempFat,"FAT",IF(.T. .OR. .F., !.F., NIL), .F. )

aPed :={}

AADD(aPed,{"CODVEND ","C",06,0})
AADD(aPed,{"NOMEVEND","C",15,0})
AADD(aPed,{"PEDIDO  ","C",06,0})
AADD(aPed,{"PEDCLI  ","C",06,0})
AADD(aPed,{"EMISSAO ","D",08,0})
AADD(aPed,{"ENTREGA ","D",08,0})
AADD(aPed,{"CODCLI  ","C",06,0})
AADD(aPed,{"LOJCLI  ","C",02,0})
AADD(aPed,{"NOMECLI ","C",15,0})
AADD(aPed,{"PRODUTO ","C",15,0})
AADD(aPed,{"QTDPED  ","N",09,2})
AADD(aPed,{"VALUNIT ","N",09,2})
AADD(aPed,{"COMISS  ","N",05,2})

cTempPed := CriaTrab( aPed, .T. )
DbUseArea(.T.,,cTempPed,"PED",IF(.T. .OR. .F., !.F., NIL), .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "KFAT11R"
cDesc1    := "Relacao de Faturamento e Pedidos em Aberto      "
cDesc2    := "por Vendedor.                                   "
cDesc3    := " "
cString   := "SF2"
lEnd      := .F.
tamanho   := "M"
limite    := 132
titulo    := "Faturamento e Pedidos em Aberto"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "KFAT11R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT11R    "
nLin      := 8
m_pag     := 1

nQtdFat   := 0  
nQtdPed   := 0  
nQtdSaldo := 0  

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Data Fat Inicial?                                         *
* mv_par02  ----> Data Fat Final  ?                                         *
* mv_par03  ----> Do Pedido       ?                                         *
* mv_par04  ----> Ate o Pedido    ?                                         *
* mv_par05  ----> Do Cliente      ?                                         *
* mv_par06  ----> Da Loja         ?                                         *
* mv_par07  ----> Ate o Cliente   ?                                         *
* mv_par08  ----> Ate Loja        ?                                         *
* mv_par09  ----> Do Produto      ?                                         *
* mv_par10  ----> Ate o Produto   ?                                         *
* mv_par11  ----> Da Natureza     ?                                         *
* mv_par12  ----> Ate a Natureza  ?                                         *
* mv_par13  ----> Do Vendedor     ?                                         *
* mv_par14  ----> Ate o Vendedor  ?                                         *
* mv_par15  ----> Entrega Ped Ini ?                                         *
* mv_par16  ----> Entrega Ped Fim ?                                         *
* mv_par17  ----> Uso do Relatorio? (Interno/Externo)                       *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Set Filter To

    DbSelectArea("FAT")
    DbCloseArea("FAT")

    DbSelectArea("PED")
    DbCloseArea("PED")

    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to

    DbSelectArea("FAT")
    DbCloseArea("FAT")

    DbSelectArea("PED")
    DbCloseArea("PED")

    Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Processando Faturamento e Pedidos em Aberto")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Processando Faturamento e Pedidos em Aberto")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

//----> o bloco abaixo processa os faturamentos

DbSelectArea("SF2")
DbSetOrder(6)
If !DbSeek(xFilial("SF2")+mv_par13+Dtos(mv_par01),.T.)
    DbGoTop()
EndIf

ProcRegua(RecCount())

Do While Eof() == .f.
                                          
    IncProc("Processando Nota Fiscal "+SF2->F2_DOC+"/"+SF2->F2_SERIE)

    //----> filtrando somente notas fiscais de faturamento
    If !SF2->F2_TIPO $ "N"
        DbSkip()
        Loop
    EndIf

    //----> filtrando somente intervalo de datas definido nos parametros
    If Dtos(SF2->F2_EMISSAO) < Dtos(mv_par01) .Or. Dtos(SF2->F2_EMISSAO) > Dtos(mv_par02)
        DbSkip()
        Loop
    EndIf

    //----> filtrando somente intervalo de vendedores definido nos parametros
    If SF2->F2_VEND1 < mv_par13 .Or. SF2->F2_VEND1 > mv_par14
        DbSkip()
        Loop
    EndIf

    //----> filtrando somente intervalo de clientes definido nos parametros
    If SF2->(F2_CLIENTE+F2_LOJA) < mv_par05+mv_par06 .Or. SF2->(F2_CLIENTE+F2_LOJA) > mv_par07+mv_par08
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SA3")
    DbSetOrder(1)
    DbSeek(xFilial("SA3")+SF2->F2_VEND1)

    DbSelectArea("SA1")
    DbSetOrder(1)
    DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA))

    DbSelectArea("SD2")
    DbSetOrder(3)
    DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))

    //----> filtrando somente intervalo de pedidos definido nos parametros
    If SD2->D2_PEDIDO < mv_par03 .Or. SD2->D2_PEDIDO > mv_par04
        DbSelectArea("SF2")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC5")
    DbSetOrder(1)
    DbSeek(xFilial("SC5")+SD2->D2_PEDIDO)

    //----> filtrando somente intervalo de naturezas definido nos parametros
    If SC5->C5_NATUREZ < mv_par11 .Or. SC5->C5_NATUREZ > mv_par12
        DbSelectArea("SF2")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC6")
    DbSetOrder(1)
    DbSeek(xFilial("SC6")+SD2->D2_PEDIDO)

    DbSelectArea("SD2")
    While SD2->(D2_DOC+D2_SERIE) == SF2->(F2_DOC+F2_SERIE)

        //----> filtrando series diferente de "12/22/13/23"
        If Alltrim(SD2->D2_SERIE) $ "12.13.22.23" .And. mv_par17 == 2
            DbSkip()
            Loop
        EndIf

        //----> filtrando somente intervalo de produtos definido nos parametros
        If SD2->D2_COD < mv_par09 .Or. SD2->D2_COD > mv_par10
            DbSkip()
            Loop
        EndIf

        DbSelectArea("SF4")
        DbSetOrder(1)
        DbSeek(xFilial("SF4")+SD2->D2_TES)

        //----> verifica se o tes gera duplicata
        If !SF4->F4_DUPLIC == "S"
            DbSelectArea("SD2")
            DbSkip()
            Loop
        EndIf

        cProduto := SD2->D2_COD
        cCliente := SD2->D2_CLIENTE+SD2->D2_LOJA   

        DbSelectArea("FAT")
        RecLock("FAT",.t.)
          FAT->CODVEND      :=  SF2->F2_VEND1
          FAT->NOMEVEND     :=  SA3->A3_NREDUZ
          FAT->NOTA         :=  SF2->F2_DOC   
          FAT->PEDIDO       :=  SC5->C5_NUM   
          FAT->PEDCLI       :=  SC5->C5_PEDCLI 
          FAT->CODCLI       :=  SF2->F2_CLIENTE
          FAT->LOJCLI       :=  SF2->F2_LOJA
          FAT->NOMECLI      :=  SA1->A1_NREDUZ
          FAT->PRODUTO      :=  Iif(SC5->C5_PAPELET == "O","1"+SD2->D2_COD,SD2->D2_COD)   
          FAT->VALUNIT      :=  SD2->D2_PRCVEN
          FAT->DATFAT       :=  SF2->F2_EMISSAO
          FAT->DATPED       :=  SC5->C5_EMISSAO
          FAT->DATENT       :=  SC6->C6_ENTREG 
          FAT->COMISS       :=  SC5->C5_COMIS1

          //----> soma as quantidades faturadas por produto da mesma nota
          DbSelectArea("SD2")
          While SD2->D2_DOC == SF2->F2_DOC .and. SD2->D2_SERIE == SF2->F2_SERIE .and. SD2->D2_COD == cProduto .And. SD2->D2_CLIENTE+SD2->D2_LOJA == cCliente
              
		        //----> filtrando series diferente de "12/22/13/23"
        		If Alltrim(SD2->D2_SERIE) $ "12.13.22.23" .And. mv_par17 == 2
				      nQtdFat :=  nQtdFat + 0
        		Else
				      nQtdFat :=  nQtdFat + SD2->D2_QUANT
        		EndIf
       		    
       		    DbSkip()
          EndDo

          DbSelectArea("FAT")
          FAT->QTDFAT       :=  nQtdFat
        MsUnLock()

        nQtdFat := 0

        DbSelectArea("SD2")
    EndDo

    DbSelectArea("SF2")
    DbSkip()
EndDo


//----> o bloco abaixo processa os pedidos em aberto

DbSelectArea("SC6")
DbSetOrder(3)           //----> por data de entrega
DbSeek(xFilial("SC6")+Dtos(mv_par15),.t.)

ProcRegua(RecCount())

Do While !Eof() .And. Dtos(SC6->C6_ENTREG) <= Dtos(mv_par16)
                                          
    IncProc("Processando o Pedido "+SC6->C6_NUM)

    //----> filtrando intervalo de pedidos definido nos parametros
    If SC6->C6_NUM < mv_par03 .Or. SC6->C6_NUM > mv_par04
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de clientes definido nos parametros
    If SC6->C6_CLI+SC6->C6_LOJA < mv_par05+mv_par06 .Or. SC6->C6_CLI+SC6->C6_LOJA > mv_par07+mv_par08
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de produtos definido nos parametros
    If SC6->C6_PRODUTO < mv_par09 .Or. SC6->C6_PRODUTO > mv_par10
        DbSkip()
        Loop
    EndIf

    nQtdSaldo := SC6->C6_QTDENT - SC6->C6_QTDVEN

    //----> filtrando somente pedidos que possuem saldo em aberto
    If nQtdSaldo == 0 .Or. Alltrim(SC6->C6_BLQ) == "R"
        DbSelectArea("SC6")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC5")
    DbSetOrder(1)
    DbSeek(xFilial("SC5")+SC6->C6_NUM)

    //----> filtrando somente pedidos que tratam-se de venda
    If !SC5->C5_TIPO $"N"
        DbSelectArea("SC6")
        DbSkip()
        Loop
    EndIf


    //----> filtrando somente interlavo de naturezas definida no parametro
    If SC5->C5_NATUREZ < mv_par11 .Or. SC5->C5_NATUREZ > mv_par12
        DbSelectArea("SC6")
        DbSkip()
        Loop
    EndIf

    //----> filtrando somente interlavo de naturezas definida no parametro
    If SC5->C5_VEND1 < mv_par13 .Or. SC5->C5_VEND1 > mv_par14
        DbSelectArea("SC6")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SF4")
    DbSetOrder(1)
    DbSeek(xFilial("SF4")+SC6->C6_TES)

    //----> verifica se o tes gera duplicata
    If !SF4->F4_DUPLIC == "S"
        DbSelectArea("SC6")
        DbSkip()
        Loop
    EndIf

    cProduto := SC6->C6_PRODUTO
    cCliente := SC6->C6_CLI+SC6->C6_LOJA

    DbSelectArea("SA1")
    DbSetOrder(1)
    DbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA)

    DbSelectArea("SA3")
    DbSetOrder(1)
    DbSeek(xFilial("SA3")+SC5->C5_VEND1)

    DbSelectArea("PED")
    RecLock("PED",.t.)
      PED->CODVEND      :=  SC5->C5_VEND1
      PED->NOMEVEND     :=  SA3->A3_NREDUZ
      PED->PEDIDO       :=  SC5->C5_NUM   
      PED->PEDCLI       :=  SC5->C5_PEDCLI 
      PED->CODCLI       :=  SC6->C6_CLI     
      PED->LOJCLI       :=  SC6->C6_LOJA
      PED->NOMECLI      :=  SA1->A1_NREDUZ
      PED->PRODUTO      :=  Iif(SC5->C5_PAPELET == "O","1"+SC6->C6_PRODUTO,SC6->C6_PRODUTO)
      PED->VALUNIT      :=  SC6->C6_PRCVEN
      PED->EMISSAO      :=  SC5->C5_EMISSAO
      PED->ENTREGA      :=  SC6->C6_ENTREG 
      PED->COMISS       :=  SC5->C5_COMIS1

      //----> soma as quantidades vendidas por produto do mesmo pedido
      DbSelectArea("SC6")
      While SC6->C6_PRODUTO == cProduto .And. SC6->C6_CLI+SC6->C6_LOJA == cCliente
          nQtdPed :=  nQtdPed + (SC6->C6_QTDVEN - SC6->C6_QTDENT)
          DbSkip()
      EndDo

      DbSelectArea("PED")
      PED->QTDPED       :=  nQtdPed
    MsUnLock()

    nQtdPed := 0

    DbSelectArea("SC6")
EndDo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

#IFDEF WINDOWS
    RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     RptStatus({|| Execute(Imprime)},titulo)
#ELSE
    Imprime()
#ENDIF


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

cTitAdd1:= " - POR VENDEDOR"

cabec1  := "NOTA    DATA DE   PEDIDO   PEDIDO   EMISSAO  ENTREGA  CODIGO     NOME DO          CODIGO           METRAGEM   PRECO UN    %    VALOR"
cabec2  := "FISCAL  FATURAM   INTERNO  CLIENTE  PEDIDO   PEDIDO   CLIENTE    CLIENTE          PRODUTO          FAT/VEND   FAT/VEND   COM   COMIS"

//regua1:= "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012"
//regua2:= "         10        20        30        40        50        60        70        80        90       100       110       120       130  "

titulo  := titulo + cTitAdd1

//----> imprime dados de faturamento

DbSelectArea("FAT")

_cIndex :=  CriaTrab(Nil,.f.)
_cChave :=  "FAT->CODVEND+FAT->PEDCLI+FAT->PRODUTO"

IndRegua("FAT",_cIndex,_cChave,,,"Indexando Dados Relatorio - FATURAMENTO")
DbGoTop()

SetRegua(Lastrec())

@ 00,00 Psay AvalImp(limite)

If mv_par17 == 1
    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
EndIf

cAuxVend    :=  "999999"

Do While Eof() == .f.

    IncRegua()

    If FAT->CODVEND #cAuxVend
        //----> uso externo
        If mv_par17 == 2
            m_pag:= 1
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
            nLin := 8

            @ nLin, 000      Psay Padc("D  A  D  O  S     D  E     F  A  T  U  R  A  M  E  N  T  O",limite)
            nLin := nLin + 2
        EndIf

        If mv_par17 == 1
            nLin := nLin + 1
        EndIf

        @ nLin, 000      Psay FAT->CODVEND+" "+FAT->NOMEVEND
        nLin := nLin + 2
    EndIf

    @ nLin, 000         Psay FAT->NOTA
    @ nLin, Pcol()+01   Psay Dtoc(FAT->DATFAT)
    @ nLin, Pcol()+01   Psay FAT->PEDIDO  
    @ nLin, Pcol()+02   Psay FAT->PEDCLI    
    @ nLin, Pcol()+02   Psay Dtoc(FAT->DATPED)
    @ nLin, Pcol()+00   Psay Dtoc(FAT->DATENT)
    @ nLin, Pcol()+00   Psay FAT->CODCLI 
    @ nLin, Pcol()+00   Psay FAT->LOJCLI 
    @ nLin, Pcol()+01   Psay FAT->NOMECLI
    @ nLin, Pcol()+01   Psay FAT->PRODUTO
    @ nLin, Pcol()+00   Psay FAT->QTDFAT    Picture "@E 99,999.99"
    @ nLin, Pcol()+04   Psay FAT->VALUNIT   Picture "@E 999.99"
    @ nLin, Pcol()+00   Psay FAT->COMISS    Picture "@E 99.99"
    @ nLin, Pcol()+00   Psay ((FAT->QTDFAT * FAT->VALUNIT) * (FAT->COMISS/100))   Picture "@E 9,999.99"

    nLin := nLin + 1

    cAuxVend    :=  FAT->CODVEND

    DbSkip()

    If nLin > 58
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
        nLin := 8
    EndIf
EndDo

DbSelectArea("FAT")
DbCloseArea("FAT")

//----> imprime dados de pedidos em aberto

DbSelectArea("PED")

_cIndex :=  CriaTrab(Nil,.f.)
_cChave :=  "PED->CODVEND+PED->PEDCLI+PED->PRODUTO"

IndRegua("PED",_cIndex,_cChave,,,"Indexando Dados Relatorio - PEDIDOS")
DbGoTop()

SetRegua(Lastrec())

cAuxVend    :=  "999999"

Do While Eof() == .f.

    IncRegua()

    If PED->CODVEND #cAuxVend
        //----> uso externo
        If mv_par17 == 2
            m_pag:= 1
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
            nLin := 8

            @ nLin, 000      Psay Padc("D  A  D  O  S     D  E     P  E  D  I  D  O  S     A     F  A  T  U  R  A  R",limite)
            nLin := nLin + 2
        EndIf

        If mv_par17 == 1
            nLin := nLin + 1
        EndIf

        @ nLin, 000      Psay PED->CODVEND+" "+PED->NOMEVEND
        nLin := nLin + 2
    EndIf

    @ nLin, 018         Psay PED->PEDIDO  
    @ nLin, Pcol()+02   Psay PED->PEDCLI    
    @ nLin, Pcol()+02   Psay Dtoc(PED->EMISSAO)
    @ nLin, Pcol()+00   Psay Dtoc(PED->ENTREGA)
    @ nLin, Pcol()+00   Psay PED->CODCLI 
    @ nLin, Pcol()+00   Psay PED->LOJCLI 
    @ nLin, Pcol()+01   Psay PED->NOMECLI
    @ nLin, Pcol()+01   Psay PED->PRODUTO
    @ nLin, Pcol()+00   Psay PED->QTDPED    Picture "@E 99,999.99"
    @ nLin, Pcol()+04   Psay PED->VALUNIT   Picture "@E 999.99"
    @ nLin, Pcol()+00   Psay PED->COMISS    Picture "@E 99.99"
    @ nLin, Pcol()+00   Psay ((PED->QTDPED * PED->VALUNIT) * (PED->COMISS/100))   Picture "@E 9,999.99"
 
    nLin := nLin + 1

    cAuxVend    :=  PED->CODVEND

    DbSkip()

    If nLin > 58
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
        nLin := 8
    EndIf
EndDo

DbSelectArea("PED")
DbCloseArea("PED")

Roda(cbCont,"Pedidos",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
EndIf

fErase(cTempFat+".dbf")
fErase(cTempFat+".idx")
fErase(cTempFat+".mem")

fErase(cTempPed+".dbf")
fErase(cTempPed+".idx")
fErase(cTempPed+".mem")

MS_FLUSH()

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
If !DbSeek(cPerg)

    aRegs := {}

    aadd(aRegs,{cPerg,'01','Data Fat Inicial? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Data Fat Final  ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Do Pedido       ? ','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate o Pedido    ? ','mv_ch4','C',06, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Do Cliente      ? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'06','Da Loja         ? ','mv_ch6','C',02, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Ate o Cliente   ? ','mv_ch7','C',06, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'08','Ate a Loja      ? ','mv_ch8','C',02, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Do Produto      ? ','mv_ch9','C',15, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'10','Ate o Produto   ? ','mv_cha','C',15, 0, 0,'G', '', 'mv_par10','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'11','Da Natureza     ? ','mv_chb','C',10, 0, 0,'G', '', 'mv_par11','','','','','','','','','','','','','','','SED'})
    aadd(aRegs,{cPerg,'12','Ate a Natureza  ? ','mv_chc','C',10, 0, 0,'G', '', 'mv_par12','','','','','','','','','','','','','','','SED'})
    aadd(aRegs,{cPerg,'13','Do Vendedor     ? ','mv_chd','C',06, 0, 0,'G', '', 'mv_par13','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'14','Ate o Vendedor  ? ','mv_che','C',06, 0, 0,'G', '', 'mv_par14','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'15','Entrega Ped Ini ? ','mv_chf','D',08, 0, 0,'G', '', 'mv_par15','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'16','Entrega Ped Fim ? ','mv_chg','D',08, 0, 0,'G', '', 'mv_par16','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'17','Uso do Relatorio? ','mv_chh','N',01, 0, 2,'C', '', 'mv_par17','Interno','','','Externo','','','','','','','','','','',''})

    For i:=1 to Len(aRegs)
	Dbseek(cPerg+StrZero(i,2))
	If found() == .f.
	    RecLock("SX1",.t.)
	    For j:=1 to Fcount()
		FieldPut(j,aRegs[i,j])
	    Next
	    MsUnLock()
	EndIf
    Next
EndIf

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna para sua Chamada (KFAT10R)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
