#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Kfat07r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NTOTQTD,_NTOTFAT,_NTOTSAL,_NTOTVLR,_NTQTD")
SetPrvt("_NTFAT,_NTSAL,_NTVLR,_CCHAVE,I,_CNOMECLI")
SetPrvt("_NQTDSALDO,CTITADD1,CABEC1,CABEC2,REGUA1,REGUA2")
SetPrvt("_CINDEX,_LFLAGNAT,_CDESCNATU,_CPEDLINHA,_CAUXCLI,_CAUXPRO")
SetPrvt("_CAUXPED,_DAUXDAT,_CAUXNAT,AREGS,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT07R  ³ Autor ³                       ³ Data ³07/02/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Pedidos de Vendas em Aberto por Natureza        ³±±
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
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SA1")         //----> Cadastro de Clientes
DbSetOrder(1)               //----> Codigo + Loja

DbSelectArea("SA3")         //----> Cadastro de Vendedores
DbSetOrder(1)               //----> Codigo

DbSelectArea("SB1")         //----> Cadastro de Produtos
DbSetOrder(1)               //----> Codigo

DbSelectArea("SC5")         //----> Cabecalho de Pedidos de Vendas
DbSetOrder(2)               //----> Data de Emissao + Pedido

DbSelectArea("SC6")         //----> Itens de Pedidos de Vendas

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"PROD"    ,"C",15,0})
AADD(aEstru1,{"PEDIDO"  ,"C",06,0})
AADD(aEstru1,{"ITEMPV"  ,"C",02,0})
AADD(aEstru1,{"ENTREGA" ,"D",08,0})
AADD(aEstru1,{"EMISSAO" ,"D",08,0})
AADD(aEstru1,{"QUANT"   ,"N",09,2})
AADD(aEstru1,{"QTDFAT"  ,"N",09,2})
AADD(aEstru1,{"QTDSAL"  ,"N",09,2})
AADD(aEstru1,{"VLRSAL"  ,"N",12,2})
AADD(aEstru1,{"CLIENTE" ,"C",06,0})
AADD(aEstru1,{"LOJA"    ,"C",02,0})
AADD(aEstru1,{"NOMEC"   ,"C",13,0})
AADD(aEstru1,{"NATUREZ" ,"C",04,0})
AADD(aEstru1,{"PAPELET" ,"C",01,0})
_cTemp1 := CriaTrab( aEstru1, .T. )  
dbUseArea(.T.,,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "KFAT07R"
cDesc1    := "Emissao dos pedidos de em aberto considerando a"
cDesc2    := "natureza, conforme parametros selecionados.     "
cDesc3    := " "
cString   := "SC6"
lEnd      := .F.
tamanho   := "M"
limite    := 132
titulo    := "Pedidos de Vendas em Aberto"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "KFAT07R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT07R    "
nLin      := 8
m_pag     := 1
_nTotQtd  := 0
_nTotFat  := 0
_nTotSal  := 0
_nTotVlr  := 0
_nTQtd    := 0
_nTFat    := 0
_nTSal    := 0
_nTVlr    := 0

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da Data        ?                                          *
* mv_par02  ----> Ate a Data     ?                                          *
* mv_par03  ----> Do Pedido      ?                                          *
* mv_par04  ----> Ate o Pedido   ?                                          *
* mv_par05  ----> Do Cliente     ?                                          *
* mv_par06  ----> Da Loja        ?                                          *
* mv_par07  ----> Ate o Cliente  ?                                          *
* mv_par08  ----> Ate Loja       ?                                          *
* mv_par09  ----> Do Produto     ?                                          *
* mv_par10  ----> Ate o Produto  ?                                          *
* mv_par11  ----> Indexado por   ? (Entrega/Pedido/Produto/Cliente)         *
* mv_par12  ----> Quais Naturezas?                                          *
* mv_par13  ----> Do Vendedor    ?                                          *
* mv_par14  ----> Ate o Vendedor ?                                          *
* mv_par15  ----> Nome Arquivo DBF?                                         *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Set Filter To
    DbSelectArea("TRB")
    DbCloseArea("TRB")
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
    DbSelectArea("TRB")
    DbCloseArea("TRB")
	Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Pedidos de Venda em Aberto")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Pedidos de Venda em Aberto")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC6")

//----> por data de entrega
If mv_par11 == 1
    DbSetOrder(3)
    _cChave := Dtos(mv_par01)

//----> por pedido
ElseIf mv_par11 == 2
    DbSetOrder(1)
    _cChave := mv_par03

//----> por produto
ElseIf mv_par11 == 3
    DbSetOrder(2)
    _cChave := mv_par09

//----> por cliente
ElseIf mv_par11 == 4
    DbSetOrder(5)
    _cChave := mv_par05+mv_par06
EndIf

ProcRegua(RecCount())
If !DbSeek(xFilial("SC6")+_cChave)
    If mv_par11 == 1
        For i:= 1 to 365
            _cChave := mv_par01+i
            If DbSeek(xFilial("SC6")+Dtos(_cChave))
                Exit
            EndIf
        Next
    EndIf
    DbGoTop()
EndIf

Do While !Eof()
                                          
    IncProc("Selecionando Dados do Pedido: "+SC6->C6_NUM)
    //----> filtrando intervalo de datas definido nos parametros
    If SC6->C6_ENTREG < mv_par01 .Or. SC6->C6_ENTREG > mv_par02
        DbSkip()
        Loop
    EndIf

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

    DbSelectArea("SA1")
    DbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA)
    _cNomeCli := SA1->A1_NREDUZ

    _nQtdSaldo := SC6->C6_QTDENT - SC6->C6_QTDVEN

    //----> filtrando somente pedidos que possuem saldo em aberto
    If _nQtdSaldo == 0 .Or. Alltrim(SC6->C6_BLQ) == "R"
        DbSelectArea("SC6")
        DbSkip()
        Loop
    EndIf

    //----> verifica se quantidade entregue e maior que quantidade vendida
    If SC6->C6_QTDENT > SC6->C6_QTDVEN
        DbSelectArea("SC6")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC5")
    DbSetOrder(1)
    DbSeek(xFilial("SC5")+SC6->C6_NUM)

    //----> filtrando somente interlavo de naturezas definida no parametro
    If !Empty(mv_par12)
        If !Alltrim(SC5->C5_NATUREZ) $ Alltrim(mv_par12)
            DbSelectArea("SC6")
            DbSkip()
            Loop
        EndIf
    EndIf

    //----> LEITAO
    //----> filtrando intervalo de vendedores definido nos parametros
    If SC5->C5_VEND1 < mv_par13 .Or. SC5->C5_VEND1 > mv_par14
        DbSelectArea("SC6")
        DbSkip()
        Loop
    EndIf


    DbSelectArea("TRB")
    RecLock("TRB",.t.)
      TRB->ITEMPV   :=      SC6->C6_ITEM
      TRB->EMISSAO  :=      SC5->C5_EMISSAO
      TRB->QUANT    :=      SC6->C6_QTDVEN
      TRB->QTDFAT   :=      SC6->C6_QTDENT
      TRB->QTDSAL   :=      (SC6->C6_QTDVEN - SC6->C6_QTDENT )
      If SC5->C5_PAPELET == "O"
          TRB->VLRSAL   :=      Iif(Dtos(SC5->C5_EMISSAO) > "20030907",((TRB->QTDSAL * SC6->C6_PRCVEN) * 4),((TRB->QTDSAL * SC6->C6_PRCVEN) * 2))
      Else
          TRB->VLRSAL   :=      TRB->QTDSAL * SC6->C6_PRCVEN
      EndIf
      TRB->CLIENTE  :=      SC6->C6_CLI
      TRB->LOJA     :=      SC6->C6_LOJA
      TRB->NOMEC    :=      _cNomeCli
      TRB->ENTREGA  :=      SC6->C6_ENTREG
      TRB->EMISSAO  :=      SC5->C5_EMISSAO
      TRB->PEDIDO   :=      SC6->C6_NUM
      TRB->PROD     :=      SC6->C6_PRODUTO
      TRB->NATUREZ  :=      SC5->C5_NATUREZ
      TRB->PAPELET  :=      SC5->C5_PAPELET
    MsUnLock()

    DbSelectArea("SC6")
    DbSkip()
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

cTitAdd1:= Iif(mv_par11 == 1," - POR DATA ENTREGA",Iif(mv_par11 == 2," - POR PEDIDO",Iif(mv_par11 == 3," - POR PRODUTO"," - POR CLIENTE")))

cabec1  := "NUMERO IT     DATA DE       CODIGO    NOME DO        CODIGO                QTDE       QTDE       QTDE             VALOR  DATA DE   P "
cabec2  := "PEDIDO        ENTREGA       CLIENTE   CLIENTE        PRODUTO               PEDI       FATU       PEND          PENDENTE  EMISSAO   P "

//regua1:= "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012"
//regua2:= "         10        20        30        40        50        60        70        80        90       100       110       120       130  "
titulo  := titulo + cTitAdd1

DbSelectArea("TRB")

//----> por data de entrega
If mv_par11 == 1
    _cIndex :=  CriaTrab(Nil,.f.)
    _cChave :=  "TRB->NATUREZ+DTOS(TRB->ENTREGA)+TRB->PEDIDO+TRB->ITEMPV+TRB->PROD"

//----> por pedido
ElseIf mv_par11 == 2
    _cIndex :=  CriaTrab(Nil,.f.)
    _cChave :=  "TRB->NATUREZ+TRB->PEDIDO+TRB->ITEMPV+TRB->PROD+DTOS(TRB->ENTREGA)"

//----> por produto
ElseIf mv_par11 == 3
    _cIndex :=  CriaTrab(Nil,.f.)
    _cChave :=  "TRB->NATUREZ+TRB->PROD+TRB->PEDIDO+TRB->ITEMPV+DTOS(TRB->ENTREGA)"

//----> por cliente
ElseIf mv_par11 == 4
    _cIndex :=  CriaTrab(Nil,.f.)
    _cChave :=  "TRB->NATUREZ+TRB->CLIENTE+TRB->LOJA+TRB->PEDIDO+TRB->ITEMPV+DTOS(TRB->ENTREGA)"
EndIf

IndRegua("TRB",_cIndex,_cChave,,,"Indexando Dados Relatorio")
DbGoTop()
SetRegua(Lastrec())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

_lFlagNat := .t.

Do While !Eof()

    IncRegua()

    If _lFlagNat
        _cDescNatu := Posicione("SED",1,xFilial("SED")+TRB->NATUREZ,"SED->ED_DESCRIC")
        @ nLin, 000      Psay Padc("*  *  *  *  *     NATUREZA : "+TRB->NATUREZ+" - "+Alltrim(_cDescNatu)+"     *  *  *  *  *",limite)
        nLin := nLin + 2
        _lFlagNat := .f.
    EndIf

    @ nLin, 000      Psay TRB->PEDIDO+"/"+TRB->ITEMPV
    @ nLin, Pcol()+5 Psay DTOC(TRB->ENTREGA)
    @ nLin, Pcol()+6 Psay TRB->CLIENTE+"/"+TRB->LOJA
    @ nLin, Pcol()+1 Psay TRB->NOMEC  
    @ nLin, Pcol()+2 Psay TRB->PROD 
    @ nLin, Pcol()+1 Psay TRB->QUANT                Picture "@E 999,999.99"
    @ nLin, Pcol()+1 Psay TRB->QTDFAT               Picture "@E 999,999.99"
    @ nLin, Pcol()+1 Psay TRB->QTDSAL               Picture "@E 999,999.99"
    @ nLin, Pcol()+4 Psay TRB->VLRSAL               Picture "@E 999,999,999.99"
    @ nLin, Pcol()+2 Psay Dtoc(TRB->EMISSAO)
    @ nLin, Pcol()+2 Psay TRB->PAPELET

    nLin := nLin + 1

    //----> totaliza o relatorio
    _nTotQtd := _nTotQtd + TRB->QUANT
    _nTotFat := _nTotFat + TRB->QTDFAT
    _nTotSal := _nTotSal + TRB->QTDSAL
    _nTotVlr := _nTotVlr + TRB->VLRSAL

    _nTQtd := _nTQtd + TRB->QUANT
    _nTFat := _nTFat + TRB->QTDFAT
    _nTSal := _nTSal + TRB->QTDSAL
    _nTVlr := _nTVlr + TRB->VLRSAL

    _cPedLinha  := TRB->PEDIDO
    _cAuxCli    := TRB->CLIENTE+TRB->LOJA
    _cAuxPro    := TRB->PROD
    _cAuxPed    := TRB->PEDIDO 
    _dAuxDat    := TRB->ENTREGA 
    _cAuxNat    := TRB->NATUREZ

    DbSkip()

    //----> separa naturezas 
    If TRB->NATUREZ #_cAuxNat
        _lFlagNat := .t.
        nLin := nLin + 1
    EndIf

    //----> totaliza por data de entrega
    If TRB->ENTREGA #_dAuxDat .And. mv_par11 == 1
        @ nLin, 000 Psay "Total do Dia     ----> "
        @ nLin, 023 Psay Dtoc(_dAuxDat)
        @ nLin, 069 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 080 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 091 Psay _nTSal                      Picture "@E 999,999.99"
        @ nLin, 105 Psay _nTVlr                      Picture "@E 999,999,999.99"
        nLin := nLin + 1

        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1

        _nTQtd := 0
        _nTFat := 0
        _nTSal := 0
        _nTVlr := 0
    EndIf

    //----> totaliza por pedido
    If TRB->PEDIDO #_cAuxPed .And. mv_par11 == 2
        @ nLin, 000 Psay "Total do Pedido  ----> "
        @ nLin, 023 Psay _cAuxPed
        @ nLin, 069 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 080 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 091 Psay _nTSal                      Picture "@E 999,999.99"
        @ nLin, 105 Psay _nTVlr                      Picture "@E 999,999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1

        _nTQtd := 0
        _nTFat := 0
        _nTSal := 0
        _nTVlr := 0
    EndIf

    //----> totaliza por produto
    If TRB->PROD #_cAuxPro .And. mv_par11 == 3
        @ nLin, 000 Psay "Total do Produto ----> "
        @ nLin, 023 Psay _cAuxPro                    
        @ nLin, 069 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 080 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 091 Psay _nTSal                      Picture "@E 999,999.99"
        @ nLin, 105 Psay _nTVlr                      Picture "@E 999,999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1

        _nTQtd := 0
        _nTFat := 0
        _nTSal := 0
        _nTVlr := 0
    EndIf

    //----> totaliza por cliente
    If TRB->CLIENTE+TRB->LOJA #_cAuxCli .And. mv_par11 == 4
        @ nLin, 000 Psay "Total do Cliente ----> "
        @ nLin, 023 Psay _cAuxCli
        @ nLin, 069 Psay _nTQtd                      Picture "@E 999,999.99"
        @ nLin, 080 Psay _nTFat                      Picture "@E 999,999.99"
        @ nLin, 091 Psay _nTSal                      Picture "@E 999,999.99"
        @ nLin, 105 Psay _nTVlr                      Picture "@E 999,999,999.99"
        nLin := nLin + 1
        @ nLin, 000 Psay Replicate("-",limite)
        nLin := nLin + 1

        _nTQtd := 0
        _nTFat := 0
        _nTSal := 0
        _nTVlr := 0
    EndIf

    If nLin > 59
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
        nLin := 9
    Endif
EndDo

//----> totaliza total geral do relatorio
nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1
@ nLin, 000 Psay "Total Geral ---->"
@ nLin, 069 Psay _nTotQtd   Picture "@E 999,999.99"
@ nLin, 080 Psay _nTotFat   Picture "@E 999,999.99"
@ nLin, 091 Psay _nTotSal   Picture "@E 999,999.99"
@ nLin, 105 Psay _nTotVlr   Picture "@E 999,999,999.99"

//----> cria um arquivo dbf para importacao no excel
If !Empty(MV_PAR15)
	_cNomeDbf := AllTrim(MV_PAR15)
	Copy To &_cNomeDbf
	
	//----> seleciono o SX1 para limpar a 15 pergunta para geracao do dbf para excel
	DbSelectArea('SX1')
	If DbSeek('FAT07R15')
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := ''
		MsUnLock()
	EndIf
EndIf


Roda(cbCont,"Pedidos",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

DbSelectArea("SC6")
RetIndex("SC6")

DbSelectArea("TRB")
DbCloseArea("TRB")
Ferase(_cTemp1+".dbf")
Ferase(_cTemp1+".idx")
Ferase(_cTemp1+".mem")

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

    aadd(aRegs,{cPerg,'01','Da Entrega     ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate a Entrega  ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Do Pedido      ? ','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate o Pedido   ? ','mv_ch4','C',06, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Do Cliente     ? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'06','Da Loja        ? ','mv_ch6','C',02, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Ate o Cliente  ? ','mv_ch7','C',06, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'08','Ate a Loja     ? ','mv_ch8','C',02, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Do Produto     ? ','mv_ch9','C',15, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'10','Ate o Produto  ? ','mv_cha','C',15, 0, 0,'G', '', 'mv_par10','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'11','Indexado por   ? ','mv_chb','N',01, 0, 0,'C', '', 'mv_par11','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'12','Quais Naturezas? ','mv_chc','C',30, 0, 0,'G', '', 'mv_par12','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'13','Nome Arquivo DBF?','mv_chc','C',30, 0, 0,'G', '', 'mv_par13','','','','','','','','','','','','','','',''})

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

Return()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna para sua Chamada (KFAT07R)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

