#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfat09m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,NSALANT,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT09M  ³ Autor ³                       ³ Data ³23/02/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alimenta Tabela de Controle Gerencial de Duplicatas        ³±±
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
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SE1")         //----> Titulos a Receber
DbSetOrder(21)              //----> Data da Baixa             

DbSelectArea("SE2")         //----> Titulos a Pagar              
DbSetOrder(10)              //----> Data da Baixa

DbSelectArea("SE5")         //----> Movimentacao Financeira      
DbSetOrder(1)               //----> Data da Movimentacao

DbSelectArea("SEA")         //----> Borderos
DbSetOrder(2)               //----> Data do Bordero

DbSelectArea("SF2")         //----> Notas Fiscais de Saida       
DbSetOrder(5)               //----> Data da Saida  

DbSelectArea("SZ9")         //----> Controle Gerencial de Duplicatas
DbSetOrder(1)               //----> Data da Movimentacao

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Data  ?                                                   *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cPerg := "FAT09M    "

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

If ! Pergunte(cPerg,.T.)
    Return
EndIf

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Atualizacao do Controle Gerencial de Duplicatas")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Atualizacao do Controle Gerencial de Duplicatas")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()
  
//----> buscando dados de saldo anterior
DbSelectArea("SZ9")
DbGoBottom()

nSalAnt := SZ9->Z9_SALFIM

RecLock("SZ9",.t.)
  SZ9->Z9_DATA      :=  mv_par01
  SZ9->Z9_FILIAL    :=  xFilial("SZ9")
  SZ9->Z9_SALANT    :=  nSalAnt
MsUnLock()
  
//----> buscando dados de faturamento

DbSelectArea("SF2")
DbSeek(xFilial("SF2")+Dtos(mv_par01),.t.)
ProcRegua(RecCount())

Do While !Eof() .And. SF2->F2_EMISSAO == mv_par01

    IncProc("Processando Faturamento do Dia "+Dtoc(SF2->F2_EMISSAO))

    //----> filtrando apenas notas normais
    If SF2->F2_TIPO $ "B/D/I/C"
        dbSkip()
        Loop
    EndIf

    DbSelectArea("SZ9")
    If DbSeek(xFilial("SZ9")+Dtos(SF2->F2_EMISSAO))
        RecLock("SZ9",.f.)
          SZ9->Z9_FATURAM   :=  SZ9->Z9_FATURAM + SF2->F2_VALFAT
        MsUnLock()
    Else
        RecLock("SZ9",.t.)
          SZ9->Z9_FILIAL    :=  xFilial("SZ9")
          SZ9->Z9_DATA      :=  SF2->F2_EMISSAO
          SZ9->Z9_FATURAM   :=  SF2->F2_VALFAT
        MsUnLock()
    EndIf

    DbSelectArea("SF2")
    DbSkip()
EndDo

//----> buscando dados de baixas efetuadas em bancos e carteira

DbSelectArea("SE5")
DbSeek(xFilial("SE5")+Dtos(mv_par01),.t.)
ProcRegua(RecCount())

Do While !Eof() .And. SE5->E5_DATA == mv_par01

    IncProc("Processando Baixas Receber do Dia "+Dtoc(SE5->E5_DATA))

    //----> filtrando apenas baixas a receber
    If Empty(SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA)
        DbSkip()
        Loop
    EndIf

    If !SE5->E5_RECPAG $ "R"
        DbSkip()
        Loop
    EndIf

    If !SE5->E5_TIPODOC $ "VL"
        DbSkip()
        Loop
    EndIf

    //----> filtra baixas por bancos
    If SE5->E5_BANCO $ "001/151/237/341/347/353/422/479"
        DbSelectArea("SZ9")
        If DbSeek(xFilial("SZ9")+Dtos(SE5->E5_DATA))
            RecLock("SZ9",.f.)
              SZ9->Z9_BXBANCO   :=  SZ9->Z9_BXBANCO + SE5->E5_VALOR 
            MsUnLock()
        Else
            RecLock("SZ9",.t.)
              SZ9->Z9_FILIAL    :=  xFilial("SZ9")
              SZ9->Z9_DATA      :=  SE5->E5_DATA   
              SZ9->Z9_BXBANCO   :=  SE5->E5_VALOR 
            MsUnLock()
        EndIf
    //----> filtra baixas por carteira
    ElseIf SE5->E5_BANCO $ "8  /207/CX1"
        DbSelectArea("SZ9")
        If DbSeek(xFilial("SZ9")+Dtos(SE5->E5_DATA))
            RecLock("SZ9",.f.)
              SZ9->Z9_BXCARTE   :=  SZ9->Z9_BXCARTE + SE5->E5_VALOR 
            MsUnLock()
        Else
            RecLock("SZ9",.t.)
              SZ9->Z9_FILIAL    :=  xFilial("SZ9")
              SZ9->Z9_DATA      :=  SE5->E5_DATA   
              SZ9->Z9_BXCARTE   :=  SE5->E5_VALOR 
            MsUnLock()
        EndIf
    EndIf

    DbSelectArea("SE5")
    DbSkip()
EndDo

//----> buscando dados de borderos emitidos

DbSelectArea("SEA")
DbSeek(xFilial("SEA")+Dtos(mv_par01),.t.)
ProcRegua(RecCount())

Do While !Eof() .And. SEA->EA_DATABOR == mv_par01

    IncProc("Processando Borderos do Dia "+Dtoc(SEA->EA_DATABOR))

    //----> filtrando apenas notas normais
    If SEA->EA_CART $"P"
        dbSkip()
        Loop
    EndIf

    DbSelectArea("SE1")
    DbSetOrder(1)
    DbSeek(xFilial("SE1")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO)

    DbSelectArea("SZ9")
    If DbSeek(xFilial("SZ9")+Dtos(SEA->EA_DATABOR))
        RecLock("SZ9",.f.)
          SZ9->Z9_BORDERO :=  SZ9->Z9_BORDERO + SE1->E1_VALOR
        MsUnLock()
    Else
        RecLock("SZ9",.t.)
          SZ9->Z9_FILIAL    :=  xFilial("SZ9")
          SZ9->Z9_DATA    :=  SEA->EA_DATABOR
          SZ9->Z9_BORDERO :=  SE1->E1_VALOR
        MsUnLock()
    EndIf

    DbSelectArea("SEA")
    DbSkip()
EndDo

DbSelectArea("SZ9")
DbGoTop()
ProcRegua(LastRec())

While Eof() == .f.

    IncProc("Reorganizando Controle de Duplicatas no Dia "+Dtoc(SZ9->Z9_DATA))

    RecLock("SZ9",.f.)
      SZ9->Z9_SALFIM    :=  SZ9->Z9_SALANT + SZ9->Z9_FATURAM - SZ9->Z9_BORDERO
    MsUnLock()

    DbSkip()
EndDo

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
    aadd(aRegs,{cPerg,'01','Data Processamento   ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})

    For i:=1 to len(aRegs)
        Dbseek(cPerg+strzero(i,2))
        If found() == .f.
            RecLock("SX1",.t.)
            For j:=1 to fcount()
                FieldPut(j,aRegs[i,j])
            Next
            MsUnLock()
        EndIf
    Next
EndIf

Return
