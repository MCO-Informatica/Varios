#INCLUDE "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Kfat10r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRUTURA,CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,NVALFAT,NVALNOTA,NQTDFAT,NVALCOMIS,LCLIFOR")
SetPrvt("_CCHAVE,CTITADD1,CABEC1,CABEC2,REGUA1,REGUA2")
SetPrvt("_CINDEX,CAUXVEND,CAUXNAT,DAUXEMISSAO,NTOTFATVEN,NTOTFATNAT")
SetPrvt("NTOTFATEMI,NTOTQTDVEN,NTOTQTDNAT,NTOTQTDEMI,NTOTCOMVEN,NTOTCOMNAT")
SetPrvt("NTOTCOMEMI,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT10R  ³ Autor ³                       ³ Data ³04/05/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Faturamento por Natureza e Vendedor             ³±±
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
DbSetOrder(1)               //----> Pedido

DbSelectArea("SC6")         //----> Itens de Pedidos de Vendas
DbSetOrder(1)               //----> Pedido + Item

DbSelectArea("SD2")         //----> Itens de Notas Fiscais de Saida
DbSetOrder(3)               //----> Nota + Serie + Cliente + Loja

DbSelectArea("SF2")         //----> Cabecalho de Notas Fiscais de Saida 
DbSetOrder(5)               //----> Data de Emissao

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstrutura :={}

AADD(aEstrutura,{"CODVEND ","C",06,0})
AADD(aEstrutura,{"NOMEVEND","C",15,0})
AADD(aEstrutura,{"NATUREZA","C",10,0})
AADD(aEstrutura,{"NOTA    ","C",06,0})
AADD(aEstrutura,{"SERIE   ","C",03,0})
AADD(aEstrutura,{"EMISSAO ","D",08,0})
AADD(aEstrutura,{"CODCLI  ","C",06,0})
AADD(aEstrutura,{"LOJCLI  ","C",02,0})
AADD(aEstrutura,{"NOMECLI ","C",15,0})
AADD(aEstrutura,{"VALFAT  ","N",14,2})
AADD(aEstrutura,{"VALNOTA ","N",14,2})
AADD(aEstrutura,{"PERCOMIS","N",05,2})
AADD(aEstrutura,{"VALCOMIS","N",14,2})
AADD(aEstrutura,{"QTDFAT  ","N",09,2})

cTemp1 := CriaTrab( aEstrutura, .T. )
DbUseArea(.T.,,cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "KFAT10R"
cDesc1    := "Relacao de Faturamento por Vendedor e Natureza  "
cDesc2    := "conforme parametros selecionados.               "
cDesc3    := " "
cString   := "SF2"
lEnd      := .F.
tamanho   := "M"
limite    := 220
titulo    := "Faturamento por Vendedor"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "KFAT10R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT10R    "
nLin      := 8
m_pag     := 1
nValFat   := 0
nValNota  := 0
nQtdFat   := 0
nValComis := 0
lCliFor   := .f.

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da Data         ?                                         *
* mv_par02  ----> Ate a Data      ?                                         *
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
* mv_par15  ----> Uso do Relatorio? (Interno/Externo)                       *
* mv_par16  ----> Indexado por    ? (Vendedor/Natureza/Emissao)             *
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

Processa({||RunProc()},"Organizando Dados do Faturamento")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Organizando Dados do Faturamento")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SF2")

//----> por vendedor       
If mv_par16 == 1
    DbSetOrder(6)
    _cChave := mv_par13 + Dtos(mv_par01)

//----> por natureza
ElseIf mv_par16 == 2
    DbSetOrder(5)
    _cChave := Dtos(mv_par01)

//----> por emissao
ElseIf mv_par16 == 3
    DbSetOrder(5)
    _cChave := Dtos(mv_par01)
EndIf

ProcRegua(RecCount())

DbSeek(xFilial("SF2")+_cChave)
Do While Eof() == .f.
                                          
    IncProc("Processando Nota Fiscal "+SF2->F2_DOC+"/"+SF2->F2_SERIE)

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

    DbSelectArea("SA3")
    DbSetOrder(1)
    DbSeek(xFilial("SA3")+SF2->F2_VEND1)

    //----> filtrando somente intervalo de clientes definido nos parametros
    If SF2->(F2_CLIENTE+F2_LOJA) < mv_par05+mv_par06 .Or. SF2->(F2_CLIENTE+F2_LOJA) > mv_par07+mv_par08
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SA1")
    DbSetOrder(1)
    If !DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA))
        If !SF2->F2_TIPO $ "N/C/I"
            DbSelectArea("SA2")
            DbSetOrder(1)
            DbSeek(xFilial("SA2")+SF2->(F2_CLIENTE+F2_LOJA))
            lCliFor := .t.
        EndIf
    EndIf

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

    //----> filtrando somente intervalo de Naturezas definido nos parametros
    If SC5->C5_NATUREZ < mv_par11 .Or. SC5->C5_NATUREZ > mv_par12
        DbSelectArea("SF2")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SD2")
    While SD2->(D2_DOC+D2_SERIE) == SF2->(F2_DOC+F2_SERIE)

        //----> filtrando somente intervalo de produtos definido nos parametros
        If SD2->D2_COD < mv_par09 .Or. SD2->D2_COD > mv_par10
            DbSkip()
            Loop
        EndIf

        //----> filtrando somente series UNI e 1
        If Alltrim(SD2->D2_SERIE) == "12"
            DbSkip()
            Loop
        EndIf

        DbSelectArea("SF4")
        DbSetOrder(1)
        DbSeek(xFilial("SF4")+SD2->D2_TES)

        //----> verifica se o tes gera duplicata
        If !SF4->F4_DUPLIC == "S"
            nValNota    :=  nValNota + SD2->D2_TOTAL
            nQtdFat     :=  nQtdFat  + SD2->D2_QUANT
        Else
            nValFat     :=  nValFat  + SD2->D2_TOTAL
            nQtdFat     :=  nQtdFat  + SD2->D2_QUANT
        EndIf

        DbSelectArea("SD2")
        DbSkip()
    EndDo

    //----> verifica politica de vendas e quem vai utilizar o relatorio
    If SC5->C5_PAPELET == "O" .And. mv_par15 == 1
        nValFat     :=  nValFat * 2
    EndIf    

    nValComis   :=  nValFat * (SC5->C5_COMIS1/100)

    DbSelectArea("TRB")
    RecLock("TRB",.t.)
      TRB->CODVEND      :=  Iif(!Empty(SF2->F2_VEND1),SF2->F2_VEND1,"999999")
      TRB->NOMEVEND     :=  Iif(!Empty(SF2->F2_VEND1),Iif(!Empty(SA3->A3_NREDUZ),SA3->A3_NREDUZ,LEFT(SA3->A3_NOME,15)),"FORNECEDORES")
      TRB->NATUREZA     :=  SC5->C5_NATUREZ
      TRB->NOTA         :=  SF2->F2_DOC
      TRB->SERIE        :=  SF2->F2_SERIE
      TRB->EMISSAO      :=  SF2->F2_EMISSAO
      TRB->CODCLI       :=  SF2->F2_CLIENTE
      TRB->LOJCLI       :=  SF2->F2_LOJA
      TRB->NOMECLI      :=  Iif(lCliFor,SA2->A2_NREDUZ,SA1->A1_NREDUZ)
      TRB->PERCOMIS     :=  SC5->C5_COMIS1
      TRB->VALFAT       :=  nValFat
      TRB->VALNOTA      :=  nValNota
      TRB->VALCOMIS     :=  nValComis
      TRB->QTDFAT       :=  nQtdFat
    MsUnLock()

    nValNota    :=  0
    nValFat     :=  0
    nQtdfat     :=  0
    nValComis   :=  0
    lCliFor     :=  .f.

    DbSelectArea("SF2")
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

cTitAdd1:= Iif(mv_par16 == 1," - POR VENDEDOR",Iif(mv_par16 == 2," - POR NATUREZA"," - POR EMISSAO"))

cabec1  := "NOTA   SER EMISSAO  CODCLI/LJ CLIENTE                VALOR            %       VALOR              QUANTIDADE                          "
cabec2  := "FISCAL                                               FATURADO      COMISSAO   COMISSAO           FATURADA                            "

//regua1:= "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012"
//regua2:= "         10        20        30        40        50        60        70        80        90       100       110       120       130  "

titulo  := titulo + cTitAdd1

DbSelectArea("TRB")

//----> por vendedor        
If mv_par16 == 1
    _cIndex :=  CriaTrab(Nil,.f.)
    _cChave :=  "TRB->CODVEND+TRB->NATUREZA+DTOS(TRB->EMISSAO)+TRB->NOTA+TRB->SERIE"

//----> por natureza
ElseIf mv_par16 == 2
    _cIndex :=  CriaTrab(Nil,.f.)
    _cChave :=  "TRB->NATUREZA+DTOS(TRB->EMISSAO)+TRB->NOTA+TRB->SERIE"

//----> por emissao
ElseIf mv_par16 == 3
    _cIndex :=  CriaTrab(Nil,.f.)
    _cChave :=  "DTOS(TRB->EMISSAO)+TRB->NOTA+TRB->SERIE"
EndIf

IndRegua("TRB",_cIndex,_cChave,,,"Indexando Dados Relatorio")
DbGoTop()

SetRegua(Lastrec())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

cAuxVend    :=  Space(06)
cAuxNat     :=  Space(10)
dAuxEmissao :=  Ctod("01/01/80")

nTotFatVen  :=  0
nTotFatNat  :=  0
nTotFatEmi  :=  0

nTotQtdVen  :=  0
nTotQtdNat  :=  0
nTotQtdEmi  :=  0

nTotComVen  :=  0
nTotComNat  :=  0
nTotComEmi  :=  0

Do While Eof() == .f.

    IncRegua()

    //----> por vendedor
    If mv_par16 == 1
        If TRB->CODVEND #cAuxVend

            //----> uso externo
            If mv_par15 == 2
                cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
            EndIf

            @ nLin, 000      Psay TRB->CODVEND+" "+TRB->NOMEVEND
            nLin := nLin + 2
        EndIf

        @ nLin, 000         Psay TRB->NATUREZA
        @ nLin, Pcol()+01   Psay TRB->DESCRNAT
        @ nLin, Pcol()+01   Psay TRB->NOTA
        @ nLin, Pcol()+01   Psay TRB->SERIE
        @ nLin, Pcol()+01   Psay Dtoc(TRB->EMISSAO)
        @ nLin, Pcol()+01   Psay TRB->CODCLI+"/"
        @ nLin, Pcol()+01   Psay TRB->LOJCLI
        @ nLin, Pcol()+01   Psay TRB->NOMECLI
        @ nLin, Pcol()+01   Psay TRB->VALFAT    Picture "@E 999,999.99"
        @ nLin, Pcol()+01   Psay TRB->PERCOMIS  Picture "@E 999.99"
        @ nLin, Pcol()+01   Psay TRB->VALCOMIS  Picture "@E 999,999.99"
        @ nLin, Pcol()+01   Psay TRB->QTDFAT    Picture "@E 999,999.99"

    //----> por natureza
    ElseIf mv_par16 == 2
        If TRB->NATUREZA #cAuxNat
            @ nLin, 000      Psay TRB->NATUREZA+" "+TRB->DESCRNAT
            nLin := nLin + 2
        EndIf

        @ nLin, 000         Psay TRB->NOTA
        @ nLin, Pcol()+01   Psay TRB->SERIE
        @ nLin, Pcol()+01   Psay Dtoc(TRB->EMISSAO)
        @ nLin, Pcol()+01   Psay TRB->CODCLI+"/"
        @ nLin, Pcol()+01   Psay TRB->LOJCLI
        @ nLin, Pcol()+01   Psay TRB->NOMECLI
        @ nLin, Pcol()+01   Psay TRB->VALFAT    Picture "@E 999,999.99"
        @ nLin, Pcol()+01   Psay TRB->PERCOMIS  Picture "@E 999.99"
        @ nLin, Pcol()+01   Psay TRB->VALCOMIS  Picture "@E 999,999.99"
        @ nLin, Pcol()+01   Psay TRB->QTDFAT    Picture "@E 999,999.99"
        @ nLin, Pcol()+01   Psay TRB->CODVEND 
        @ nLin, Pcol()+01   Psay TRB->NOMEVEND

    //----> por emissao
    Else
        If TRB->EMISSAO #dAuxEmissao
            @ nLin, 000      Psay Dtoc(TRB->EMISSAO)
            nLin := nLin + 2
        EndIf

        @ nLin, 000         Psay TRB->NOTA
        @ nLin, Pcol()+01   Psay TRB->SERIE
        @ nLin, Pcol()+01   Psay TRB->CODCLI+"/"
        @ nLin, Pcol()+01   Psay TRB->LOJCLI
        @ nLin, Pcol()+01   Psay TRB->NOMECLI
        @ nLin, Pcol()+01   Psay TRB->VALFAT    Picture "@E 999,999.99"
        @ nLin, Pcol()+01   Psay TRB->PERCOMIS  Picture "@E 999.99"
        @ nLin, Pcol()+01   Psay TRB->VALCOMIS  Picture "@E 999,999.99"
        @ nLin, Pcol()+01   Psay TRB->QTDFAT    Picture "@E 999,999.99"
        @ nLin, Pcol()+01   Psay TRB->CODVEND 
        @ nLin, Pcol()+01   Psay TRB->NOMEVEND

    EndIf

    nLin := nLin + 1

    nTotFatVen := nTotFatVen + TRB->VALFAT
    nTotFatNat := nTotFatNat + TRB->VALFAT
    nTotFatEmi := nTotFatEmi + TRB->VALFAT

    nTotQtdVen := nTotQtdVen + TRB->QTDFAT
    nTotQtdNat := nTotQtdNat + TRB->QTDFAT
    nTotQtdEmi := nTotQtdEmi + TRB->QTDFAT

    nTotComVen := nTotComVen + TRB->VALCOMIS
    nTotComNat := nTotComNat + TRB->VALCOMIS
    nTotComEmi := nTotComEmi + TRB->VALCOMIS

    cAuxNat    := TRB->NATUREZA
    cAuxVend   := TRB->CODVEND
    dAuxEmissao:= TRB->EMISSAO

    DbSkip()

    @ nLin, 000 Psay Replicate("-",limite)
    nLin := nLin + 1

    If nLin > 59
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
        nLin := 8
    EndIf
End  

DbSelectArea("TRB")
DbCloseArea("TRB")

Roda(cbCont,"Pedidos",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
EndIf

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

    aadd(aRegs,{cPerg,'01','Da Data         ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate a Data      ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
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
    aadd(aRegs,{cPerg,'15','Uso do Relatorio? ','mv_chf','N',01, 0, 2,'C', '', 'mv_par15','Interno','','','Externo','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'16','Indexado por    ? ','mv_chg','N',01, 0, 3,'C', '', 'mv_par16','Vendedor','','','Natureza','','','Emissao','','','','','','','',''})

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
