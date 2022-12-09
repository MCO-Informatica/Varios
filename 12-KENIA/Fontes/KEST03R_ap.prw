#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function KEST03R()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NQTDPED,_NQTDFAT,_NQTDSAL,_NVALPED,_NVALFAT")
SetPrvt("_NVALSAL,_NTOTQTDP,_NTOTQTDF,_NTOTQTDS,_NTOTPED,_NTOTFAT")
SetPrvt("_NTOTSAL,_CNOMECLI,_CMUNICLI,_CESTACLI,_CTRANSP,_CCONDPAG")
SetPrvt("_CDESCPRO,_NALIQPRO,CABEC1,CABEC2,CTITADD,_CINDEX")
SetPrvt("_CCHAVE,_CAUXPED,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KEST03R  ³ Autor ³Ricardo Correa de Souza³ Data ³18/01/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Pedidos de Vendas por Vendedor X Cliente x Prod ³±±
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
DbSetOrder(1)               //----> Pedido + Item

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"PROD"    ,"C",15,0})
AADD(aEstru1,{"DESCR"   ,"C",30,0})
AADD(aEstru1,{"PEDIDO"  ,"C",06,0})
AADD(aEstru1,{"NOTA  "  ,"C",06,0})
AADD(aEstru1,{"DTFAT "  ,"D",08,0})
AADD(aEstru1,{"DTENT "  ,"D",08,0})
AADD(aEstru1,{"EMISSAO" ,"D",08,0})
AADD(aEstru1,{"QUANT"   ,"N",09,2})
AADD(aEstru1,{"QTDFAT"  ,"N",09,2})
AADD(aEstru1,{"UNIT"    ,"N",12,2})
AADD(aEstru1,{"TES"     ,"C",03,0})
AADD(aEstru1,{"CFO"     ,"C",04,0})
AADD(aEstru1,{"VEND  "  ,"C",06,0})
AADD(aEstru1,{"NOMEC"   ,"C",10,0})
AADD(aEstru1,{"MUNIC"   ,"C",10,0})
AADD(aEstru1,{"UF"      ,"C",02,0})
AADD(aEstru1,{"TRANSP " ,"C",15,0})
AADD(aEstru1,{"CONDPAG" ,"C",15,0})
AADD(aEstru1,{"RESIDUO" ,"C",01,0})
AADD(aEstru1,{"CHAPELE" ,"C",01,0})
AADD(aEstru1,{"OBS    " ,"C",40,0})
AADD(aEstru1,{"NATUREZ" ,"C",04,0})

_cTemp1 := CriaTrab( aEstru1, .T. )  
dbUseArea(.T.,,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "KEST03R"
cDesc1    := "Este relatorio ira emitir a listagem dos Pedidos de Pilotagem"
cDesc2    := "conforme parametros definidos pelo usuario."
cDesc3    := " "
cString   := "SC6"
lEnd      := .F.
tamanho   := "G"
limite    := 220
titulo    := "Pedidos de Vendas/Notas Fiscais - Pilotagem"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "KEST03R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "EST03R    "
nLin      := 8
m_pag     := 1

_nQtdPed := 0
_nQtdFat := 0
_nQtdSal := 0

_nValPed := 0
_nValFat := 0
_nValSal := 0

_nTotQtdP := 0
_nTotQtdF := 0
_nTotQtdS := 0

_nTotPed := 0
_nTotFat := 0
_nTotSal := 0

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da Data        ?                                          *
* mv_par02  ----> Ate a Data     ?                                          *
* mv_par03  ----> Do Vendedor    ?                                          *
* mv_par04  ----> Ate o Vendedor ?                                          *
* mv_par05  ----> Do Pedido      ?                                          *
* mv_par06  ----> Ate o Pedido   ?                                          *
* mv_par07  ----> Do Cliente     ?                                          *
* mv_par08  ----> Da Loja        ?                                          *
* mv_par09  ----> Ate o Cliente  ?                                          *
* mv_par10  ----> Ate Loja       ?                                          *
* mv_par11  ----> Do Produto     ?                                          *
* mv_par12  ----> Ate o Produto  ?                                          *
* mv_par13  ----> Quais TES      ?                                          *
* mv_par14  ----> Situacao Pedido?                                          *
* mv_par15  ----> Da Emissao Nota?                                          *
* mv_par16  ----> Ate Emissao Not?                                          *
* mv_par17  ----> Quais Naturezas?                                          *
* mv_par18  ----> Lista por      ? (Pedido/Produto/Vendedor)                *
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

Processa({||RunProc()},"Filtrando Dados ...")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Filtrando Dados ...")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SC5")
ProcRegua(RecCount())
DbSeek(xFilial("SC5")+Dtos(mv_par01),.t.)

Do While !Eof() .And. SC5->C5_EMISSAO <= mv_par02
    IncProc("Selecionando Dados do Pedido: "+SC5->C5_NUM)

    //----> filtrando somente pedidos de vendas
    If SC5->C5_TIPO #"N"
	DbSkip()
	Loop
    EndIf

    //----> filtrando intervalo de pedidos definido nos parametros
    If SC5->C5_NUM < mv_par05 .Or. SC5->C5_NUM > mv_par06
	DbSkip()
	Loop
    EndIf

    //----> filtrando intervalo de vendedores definido nos parametros
    If SC5->C5_VEND1 < mv_par03 .Or. SC5->C5_VEND1 > mv_par04
	DbSkip()
	Loop
    EndIf

    //----> filtrando intervalo de clientes definido nos parametros
    If SC5->C5_CLIENTE + SC5->C5_LOJACLI < mv_par07 + mv_par08 .Or. SC5->C5_CLIENTE +SC5->C5_LOJACLI > mv_par09 + mv_par10
	DbSkip()
	Loop
    EndIf

    //----> filtrando intervalo de naturezas definido nos parametros
    If !Empty(mv_par17)
        If !Alltrim(SC5->C5_NATUREZ) $ Alltrim(mv_par17)
        DbSkip()
        Loop
        EndIf
    EndIf

    DbSelectArea("SC6")
    DbSeek(xFilial("SC6")+SC5->C5_NUM)
    Do While SC6->C6_NUM == SC5->C5_NUM

    /* desabilitado o bloco abaixo
    //----> filtrando intervalo de data de faturamento definido nos parametros
    If SC6->C6_DATFAT < mv_par15 .Or. SC6->C6_DATFAT > mv_par16
	    DbSkip()
	    Loop
	EndIf
    */

	//----> filtrando intervalo de produtos definido nos parametros
	If SC6->C6_PRODUTO < mv_par11 .Or. SC6->C6_PRODUTO > mv_par12
	    DbSkip()
	    Loop
	EndIf

	//----> filtrando intervalo de TES definido nos parametros
    If !Empty(mv_par13)
       If !SC6->C6_TES $mv_par13
          DbSkip()
          Loop
       EndIf
    EndIf

	//----> filtrando formato do relatorio (pedidos abertos/pedidos faturados/todos)
	If MV_PAR14 == 1
	    //----> pedidos em aberto
	    If (SC6->C6_QTDVEN - SC6->C6_QTDENT) <= 0 
		DbSkip()
		Loop
	    EndIf
	    //----> trata pedidos eliminados por residuo
	    If Alltrim(SC6->C6_BLQ) == "R"
		DbSkip()
		Loop
	    EndIf
	ElseIf MV_PAR14 == 2
	    //----> pedidos faturados
	    If SC6->C6_QTDENT <= 0
		DbSkip()
		Loop
	    EndIf
	Else  
	    //----> todos os pedidos - eliminados por residuo total
	    If Alltrim(C6_BLQ) == "R" .And. SC6->C6_QTDENT <= 0
		DbSkip()
		Loop
	    EndIf
	EndIf

	DbSelectArea("SA1")
	DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	If !Empty(SA1->A1_NREDUZ)
	    _cNomeCli := SA1->A1_NREDUZ
	Else
	    _cNomeCli := SA1->A1_NOME
	EndIf
	_cMuniCli := SA1->A1_MUN
	_cEstaCli := SA1->A1_EST

	DbSelectArea("SA4")
	DbSeek(xFilial("SA4")+SC5->C5_TRANSP)
	_cTransp := SA4->A4_NREDUZ

	DbSelectArea("SE4")
	DbSeek(xFilial("SE4")+SC5->C5_CONDPAG)
	_cCondPag := SE4->E4_DESCRI

	DbSelectArea("SB1")
	DbSeek(xFilial("SB1")+SC6->C6_PRODUTO)
	_cDescPro := SB1->B1_DESC
	_nAliqPro := SB1->B1_IPI

	DbSelectArea("TRB")
	RecLock("TRB",.t.)
	  TRB->PROD     :=      SC6->C6_PRODUTO
	  TRB->PEDIDO   :=      SC6->C6_NUM
	  TRB->EMISSAO  :=      SC5->C5_EMISSAO
	  TRB->DTENT    :=      SC6->C6_ENTREG
	  TRB->QUANT    :=      SC6->C6_QTDVEN
	  TRB->QTDFAT   :=      SC6->C6_QTDENT
	  TRB->UNIT     :=      SC6->C6_PRCVEN
	  TRB->NOTA     :=      SC6->C6_NOTA
	  TRB->DTFAT    :=      SC6->C6_DATFAT
	  TRB->TES      :=      SC6->C6_TES
	  TRB->CFO      :=      SC6->C6_CF
	  TRB->VEND     :=      SC5->C5_VEND1
	  TRB->NOMEC    :=      _cNomeCli
	  TRB->MUNIC    :=      _cMuniCli
	  TRB->UF       :=      _cEstaCli
	  TRB->TRANSP   :=      _cTransp      
	  TRB->CONDPAG  :=      _cCondPag     
	  TRB->RESIDUO  :=      Iif(Alltrim(SC6->C6_BLQ)=="R","R","")
	  TRB->CHAPELE  :=      SC5->C5_PAPELET
	  TRB->OBS      :=      SC5->C5_MENNOTA
      TRB->NATUREZ  :=      Alltrim(SC5->C5_NATUREZ)
	MsUnLock()

	DbSelectArea("SC6")
	DbSkip()
    EndDo

    DbSelectArea("SC5")
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


If mv_par18 == 1
    cabec1  := "Pedido  Produto    Emissao   Entrega     Qtd Ped    Qtd Fat    Qtd Sal   Nota   Data Nota  Prc Un  Tes  Cfo  Vended Cliente    Municipio  Uf Transportadora  Cond.Pagto.     P Natureza  Observacoes                      "
    //          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    //                    10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       200       210       220
    cabec2  := ""
ElseIf mv_par18 == 2
    cabec1  := "Produto  Pedido    Emissao   Entrega     Qtd Ped    Qtd Fat    Qtd Sal   Nota   Data Nota  Prc Un  Tes  Cfo  Vended Cliente    Municipio  Uf Transportadora  Cond.Pagto.     P Natureza  Observacoes                      "
    //          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    //                    10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       200       210       220
    cabec2  := ""
Else
    cabec1  := "Vended  Produto    Pedido   Emissao   Entrega     Qtd Ped    Qtd Fat    Qtd Sal   Nota   Data Nota  Prc Un  Tes  Cfo  Cliente    Municipio  Uf Transportadora  Cond.Pagto.     P Natureza  Observacoes                      "
    //          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    //                    10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       200       210       220
    cabec2  := ""
EndIf

If MV_PAR14 == 1
    cTitAdd := " - Pedidos em Aberto"
ElseIf MV_PAR14 == 2
    cTitAdd := " - Pedidos Faturados"
Else
    cTitAdd := " - Todos os Pedidos"
EndIf

titulo  := titulo + cTitAdd

DbSelectArea("TRB")

If MV_PAR14 == 1 .Or. MV_PAR14 == 3
    If mv_par18 == 1
        _cIndex := CriaTrab(Nil,.f.)
        _cChave := "DTOS(TRB->DTENT)+TRB->PEDIDO+TRB->PROD"
    ElseIf mv_par18 == 2
        _cIndex := CriaTrab(Nil,.f.)
        _cChave := "DTOS(TRB->DTENT)+TRB->PROD+TRB->PEDIDO"
    Else
        _cIndex := CriaTrab(Nil,.f.)
        _cChave := "DTOS(TRB->DTENT)+TRB->VEND+TRB->PROD+TRB->PEDIDO"
    EndIf
ElseIf MV_PAR14 == 2
    If mv_par18 == 1
        _cIndex := CriaTrab(Nil,.f.)
        _cChave := "DTOS(TRB->DTFAT)+TRB->PEDIDO+TRB->PROD"
    ElseIf mv_par18 == 2
        _cIndex := CriaTrab(Nil,.f.)
        _cChave := "DTOS(TRB->DTFAT)+TRB->PROD+TRB->PEDIDO"
    Else
        _cIndex := CriaTrab(Nil,.f.)
        _cChave := "DTOS(TRB->DTFAT)+TRB->VEND+TRB->PROD+TRB->PEDIDO"
    EndIf
Else
    If mv_par18 == 1
        _cIndex := CriaTrab(Nil,.f.)
        _cChave := "DTOS(TRB->DTENT)+TRB->PEDIDO+TRB->PROD"
    ElseIf mv_par18 == 2
        _cIndex := CriaTrab(Nil,.f.)
        _cChave := "DTOS(TRB->DTENT)+TRB->PROD+TRB->PEDIDO"
    Else
        _cIndex := CriaTrab(Nil,.f.)
        _cChave := "DTOS(TRB->DTENT)+TRB->VEND+TRB->PROD+TRB->PEDIDO"
    EndIf
EndIf

IndRegua("TRB",_cIndex,_cChave,,,"")

SetRegua(Lastrec())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

If mv_par18 == 1

Do While !Eof()

    IncRegua()

    @ nLin, 000      Psay TRB->PEDIDO
    @ nLin, Pcol()+2 Psay Subs(TRB->PROD,1,9)
    @ nLin, Pcol()+2 Psay Dtoc(TRB->EMISSAO)
    @ nLin, Pcol()+2 Psay Dtoc(TRB->DTENT)
    @ nLin, Pcol()+1 Psay TRB->QUANT                  Picture "@E 999,999.99"
    @ nLin, Pcol()+1 Psay TRB->QTDFAT                 Picture "@E 999,999.99"
    @ nLin, Pcol()+1 Psay Iif(!Empty(TRB->RESIDUO),0,(TRB->QUANT - TRB->QTDFAT))  Picture "@E 999,999.99"
    @ nLin, Pcol()+3 Psay TRB->NOTA  
    @ nLin, Pcol()+1 Psay TRB->DTFAT
    @ nLin, Pcol()+1 Psay TRB->UNIT                   Picture "@E 9,999.99"
    @ nLin, Pcol()+2 Psay TRB->TES   
    @ nLin, Pcol()+2 Psay TRB->CFO   
    @ nLin, Pcol()+1 Psay TRB->VEND
    @ nLin, Pcol()+1 Psay TRB->NOMEC  
    @ nLin, Pcol()+1 Psay TRB->MUNIC  
    @ nLin, Pcol()+1 Psay TRB->UF     
    @ nLin, Pcol()+1 Psay TRB->TRANSP 
    @ nLin, Pcol()+1 Psay TRB->CONDPAG
    @ nLin, Pcol()+1 Psay TRB->CHAPELE
    @ nLin, Pcol()+1 Psay TRB->NATUREZ
    @ nLin, Pcol()+5 Psay TRB->OBS    

    nLin := nLin + 1

    _cAuxPed := TRB->PEDIDO

    //----> totalizando as quantidades (total pedido)
    _nQtdPed := _nQtdPed + TRB->QUANT
    _nQtdFat := _nQtdFat + TRB->QTDFAT
    _nQtdSal := _nQtdSal + Iif(!Empty(TRB->RESIDUO),0,(TRB->QUANT - TRB->QTDFAT))

    DbSkip()

    //----> totaliza total do pedido
    If TRB->PEDIDO #_cAuxPed
	nLin := nLin + 1
	@ nLin, 000 Psay "Total do Pedido "+_cAuxPed+" ---->"
	@ nLin, Pcol()+10 Psay _nQtdPed Picture "@E 999,999.99"
    @ nLin, Pcol()+01 Psay _nQtdFat Picture "@E 999,999.99"
    @ nLin, Pcol()+01 Psay _nQtdSal Picture "@E 999,999.99"

	nLin := nLin + 1
	@ nLin, 000 Psay Replicate("-",limite)

	//----> totalizando as quantidades (total geral)
	_nTotQtdP := _nTotQtdP + _nQtdPed
	_nTotQtdS := _nTotQtdS + _nQtdSal
	_nTotQtdF := _nTotQtdF + _nQtdFat

	_nQtdPed := 0
	_nQtdFat := 0
	_nQtdSal := 0

	nLin := nLin + 1
    EndIf

    If nLin > 59
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	nLin := 8
    Endif

EndDo

//----> totaliza total geral do relatorio
nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1
@ nLin, 000 Psay "Total Geral"+" ---->"
@ nLin, Pcol()+21 Psay _nTotQtdP   Picture "@E 999,999.99"
@ nLin, Pcol()+01 Psay _nTotQtdF   Picture "@E 999,999.99"
@ nLin, Pcol()+01 Psay _nTotQtdS   Picture "@E 999,999.99"

ElseIf mv_par18 == 2
Do While !Eof()

    IncRegua()

    @ nLin, 000      Psay Subs(TRB->PROD,1,9)
    @ nLin, Pcol()+2 Psay TRB->PEDIDO
    @ nLin, Pcol()+2 Psay Dtoc(TRB->EMISSAO)
    @ nLin, Pcol()+2 Psay Dtoc(TRB->DTENT)
    @ nLin, Pcol()+1 Psay TRB->QUANT                  Picture "@E 999,999.99"
    @ nLin, Pcol()+1 Psay TRB->QTDFAT                 Picture "@E 999,999.99"
    @ nLin, Pcol()+1 Psay Iif(!Empty(TRB->RESIDUO),0,(TRB->QUANT - TRB->QTDFAT))  Picture "@E 999,999.99"
    @ nLin, Pcol()+3 Psay TRB->NOTA  
    @ nLin, Pcol()+1 Psay TRB->DTFAT
    @ nLin, Pcol()+1 Psay TRB->UNIT                   Picture "@E 9,999.99"
    @ nLin, Pcol()+2 Psay TRB->TES   
    @ nLin, Pcol()+2 Psay TRB->CFO   
    @ nLin, Pcol()+1 Psay TRB->VEND
    @ nLin, Pcol()+1 Psay TRB->NOMEC  
    @ nLin, Pcol()+1 Psay TRB->MUNIC  
    @ nLin, Pcol()+1 Psay TRB->UF     
    @ nLin, Pcol()+1 Psay TRB->TRANSP 
    @ nLin, Pcol()+1 Psay TRB->CONDPAG
    @ nLin, Pcol()+1 Psay TRB->CHAPELE
    @ nLin, Pcol()+1 Psay TRB->NATUREZ
    @ nLin, Pcol()+5 Psay TRB->OBS    

    nLin := nLin + 1

    _cAuxPed := TRB->PROD

    //----> totalizando as quantidades (total pedido)
    _nQtdPed := _nQtdPed + TRB->QUANT
    _nQtdFat := _nQtdFat + TRB->QTDFAT
    _nQtdSal := _nQtdSal + Iif(!Empty(TRB->RESIDUO),0,(TRB->QUANT - TRB->QTDFAT))

    DbSkip()

    //----> totaliza total do pedido
    If TRB->PROD #_cAuxPed
	nLin := nLin + 1
    @ nLin, 000 Psay "Total do Produto "+Subs(_cAuxPed,1,9)+" ---->"
    @ nLin, Pcol()+06 Psay _nQtdPed Picture "@E 999,999.99"
    @ nLin, Pcol()+01 Psay _nQtdFat Picture "@E 999,999.99"
    @ nLin, Pcol()+01 Psay _nQtdSal Picture "@E 999,999.99"

	nLin := nLin + 1
	@ nLin, 000 Psay Replicate("-",limite)

	//----> totalizando as quantidades (total geral)
	_nTotQtdP := _nTotQtdP + _nQtdPed
	_nTotQtdS := _nTotQtdS + _nQtdSal
	_nTotQtdF := _nTotQtdF + _nQtdFat

	_nQtdPed := 0
	_nQtdFat := 0
	_nQtdSal := 0

	nLin := nLin + 1
    EndIf

    If nLin > 59
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	nLin := 8
    Endif

EndDo

//----> totaliza total geral do relatorio
nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1
@ nLin, 000 Psay "Total Geral"+" ---->"
@ nLin, Pcol()+21 Psay _nTotQtdP   Picture "@E 999,999.99"
@ nLin, Pcol()+01 Psay _nTotQtdF   Picture "@E 999,999.99"
@ nLin, Pcol()+01 Psay _nTotQtdS   Picture "@E 999,999.99"

Else
Do While !Eof()

    IncRegua()

    @ nLin, 000      Psay TRB->VEND
    @ nLin, Pcol()+2 Psay Subs(TRB->PROD,1,9)
    @ nLin, Pcol()+2 Psay TRB->PEDIDO
    @ nLin, Pcol()+3 Psay Dtoc(TRB->EMISSAO)
    @ nLin, Pcol()+2 Psay Dtoc(TRB->DTENT)
    @ nLin, Pcol()+1 Psay TRB->QUANT                  Picture "@E 999,999.99"
    @ nLin, Pcol()+1 Psay TRB->QTDFAT                 Picture "@E 999,999.99"
    @ nLin, Pcol()+1 Psay Iif(!Empty(TRB->RESIDUO),0,(TRB->QUANT - TRB->QTDFAT))  Picture "@E 999,999.99"
    @ nLin, Pcol()+3 Psay TRB->NOTA  
    @ nLin, Pcol()+1 Psay TRB->DTFAT
    @ nLin, Pcol()+1 Psay TRB->UNIT                   Picture "@E 9,999.99"
    @ nLin, Pcol()+2 Psay TRB->TES   
    @ nLin, Pcol()+2 Psay TRB->CFO   
    @ nLin, Pcol()+1 Psay TRB->NOMEC  
    @ nLin, Pcol()+1 Psay TRB->MUNIC  
    @ nLin, Pcol()+1 Psay TRB->UF     
    @ nLin, Pcol()+1 Psay TRB->TRANSP 
    @ nLin, Pcol()+1 Psay TRB->CONDPAG
    @ nLin, Pcol()+1 Psay TRB->CHAPELE
    @ nLin, Pcol()+1 Psay TRB->NATUREZ
    @ nLin, Pcol()+5 Psay TRB->OBS    

    nLin := nLin + 1

    _cAuxPed := TRB->VEND

    //----> totalizando as quantidades (total pedido)
    _nQtdPed := _nQtdPed + TRB->QUANT
    _nQtdFat := _nQtdFat + TRB->QTDFAT
    _nQtdSal := _nQtdSal + Iif(!Empty(TRB->RESIDUO),0,(TRB->QUANT - TRB->QTDFAT))

    DbSkip()

    //----> totaliza total do pedido
    If TRB->VEND   #_cAuxPed
	nLin := nLin + 1
    @ nLin, 000 Psay "Total do Vendedor "+_cAuxPed+" ---->"
    @ nLin, Pcol()+16 Psay _nQtdPed Picture "@E 999,999.99"
	@ nLin, Pcol()+1  Psay _nQtdFat Picture "@E 999,999.99"
	@ nLin, Pcol()+1  Psay _nQtdSal Picture "@E 999,999.99"

	nLin := nLin + 1
	@ nLin, 000 Psay Replicate("-",limite)

	//----> totalizando as quantidades (total geral)
	_nTotQtdP := _nTotQtdP + _nQtdPed
	_nTotQtdS := _nTotQtdS + _nQtdSal
	_nTotQtdF := _nTotQtdF + _nQtdFat

	_nQtdPed := 0
	_nQtdFat := 0
	_nQtdSal := 0

	nLin := nLin + 1
    EndIf

    If nLin > 59
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	nLin := 8
    Endif

EndDo

//----> totaliza total geral do relatorio
nLin := nLin + 1
@ nLin, 000 Psay Replicate("-",limite)
nLin := nLin + 1
@ nLin, 000 Psay "Total Geral"+" ---->"
@ nLin, Pcol()+30 Psay _nTotQtdP   Picture "@E 999,999.99"
@ nLin, Pcol()+01 Psay _nTotQtdF   Picture "@E 999,999.99"
@ nLin, Pcol()+01 Psay _nTotQtdS   Picture "@E 999,999.99"

EndIf

Roda(cbCont,"Pedidos",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

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

    aadd(aRegs,{cPerg,'01','Da Emissao     ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate Emissao    ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Do Vendedor    ? ','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'04','Ate o Vendedor ? ','mv_ch4','C',06, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'05','Do Pedido      ? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','SC5'})
    aadd(aRegs,{cPerg,'06','Ate o Pedido   ? ','mv_ch6','C',06, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','','SC5'})
    aadd(aRegs,{cPerg,'07','Do Cliente     ? ','mv_ch7','C',06, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'08','Da Loja        ? ','mv_ch8','C',02, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Ate o Cliente  ? ','mv_ch9','C',06, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'10','Ate a Loja     ? ','mv_cha','C',02, 0, 0,'G', '', 'mv_par10','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'11','Do Produto     ? ','mv_chb','C',15, 0, 0,'G', '', 'mv_par11','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'12','Ate o Produto  ? ','mv_chc','C',15, 0, 0,'G', '', 'mv_par12','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'13','Quais Tes      ? ','mv_chd','C',30, 0, 0,'G', '', 'mv_par13','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'14','Formato (A/F/T)? ','mv_che','N',01, 0, 2,'C', '', 'mv_par14','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'15','Da Emissao Nota? ','mv_chf','D',08, 0, 0,'G', '', 'mv_par15','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'16','Ate Emissao Not? ','mv_chg','D',08, 0, 0,'G', '', 'mv_par16','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'17','Quais Naturezas? ','mv_chh','C',30, 0, 0,'G', '', 'mv_par17','','','','','','','','','','','','','','',''})

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
* Retorna para sua Chamada (KEST03R)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

