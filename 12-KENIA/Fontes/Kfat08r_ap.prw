#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Kfat08r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NQTDPRO,_NTOTPRO,_NTOTVEN,_NTOTREV,_NTOTTER")
SetPrvt("_NTOTRET,_NTOTSUC,_NQTDVEN,_NQTDREV,_NQTDTER,_NQTDRET")
SetPrvt("_NQTDSUC,CABEC1,CABEC2,_CINDTRB,_CCHATRB,_DDATA")
SetPrvt("AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT08R  ³ Autor ³                       ³ Data ³09/02/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faturamento Diario e Acumulado - Quantidade e Valor        ³±±
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

DbSelectArea("SD2")         //----> Itens da Nota Fiscal de Saida
DbSetOrder(3)               //----> Numero + Serie + Cliente

DbSelectArea("SF2")         //----> Cabecalho de Notas de Saidas
DbSetOrder(5)               //----> Filial + Data Emissao + Documento + Serie

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"EMISSAO" ,"D",08,0})
AADD(aEstru1,{"QUANT"   ,"N",14,2})
AADD(aEstru1,{"VALFT"   ,"N",14,2})
AADD(aEstru1,{"TIPO"    ,"C",02,0})

_cTemp1 := CriaTrab( aEstru1, .T. )  
dbUseArea(.T.,,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "KFAT08R"
cDesc1    := "Faturamento Diario"
cDesc2    := " "
cDesc3    := " "
cString   := "SD2"
lEnd      := .F.
tamanho   := "P"
limite    := 80
titulo    := "FATURAMENTO DIARIO / ACUMULADO"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "KFAT08R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT08R    "
nLin      := 8
m_pag     := 1
_nQtdPro  := { 0, 0}
_nTotPro  := { 0, 0}
_nTotVen  := 0
_nTotRev  := 0
_nTotTer  := 0
_nTotRet  := 0
_nTotSuc  := 0  
_nQtdVen  := 0
_nQtdRev  := 0
_nQtdTer  := 0
_nQtdRet  := 0
_nQtdSuc  := 0

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Data Inicial   ?                                          *
* mv_par02  ----> Data Final     ?                                          *
* mv_par03  ----> Quanto ao Tes  ?                                          *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Faturamento Diario/Acumulado")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Faturamento Diario/Acumulado")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SF2")
DbSetOrder(5)               //----> Filial + Data Emissao + Documento + Serie

DbSeek(xFilial("SF2")+Dtos(mv_par01),.t.)
ProcRegua(RecCount())

Do While !Eof() .And. SF2->F2_EMISSAO <= mv_par02

    IncProc("Selecionando Dados da Nota: "+SF2->F2_DOC)

    //----> filtrando apenas notas normais
    If SF2->F2_TIPO $ "B/D/I/C"
        dbSkip()
        Loop
    EndIf

    DbSelectArea("SD2")
    DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
    Do While SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA

        DbSelectArea("SF4")
        DbSetOrder(1)
        DbSeek(xFilial("SF4")+SD2->D2_TES)

        //----> verifica se gera financeiro
        If mv_par03 == 1 .And. SF4->F4_DUPLIC <> "S"
            DbSelectArea("SD2")
            DbSkip()
            Loop
        //----> verifica se nao gera financeiro
        ElseIf mv_par03 == 2 .And. SF4->F4_DUPLIC <> "N"
            DbSelectArea("SD2")
            DbSkip()
            Loop
        EndIf

        DbSelectArea("TRB")
        RecLock("TRB",.t.)
          TRB->EMISSAO  :=      SF2->F2_EMISSAO
          If SD2->D2_TES <> "700"
              TRB->QUANT    :=      SD2->D2_QUANT
          Else
              TRB->QUANT    :=      0
          EndIf
          TRB->VALFT    :=      SD2->D2_TOTAL
          If Alltrim(SD2->D2_COD) $ "10017/2218" 
              TRB->TIPO     :=      "05"
          ElseIf Alltrim(SD2->D2_COD) == "110099"
              TRB->TIPO     :=      "04"
          ElseIf Alltrim(SD2->D2_CF) $ "5124/5125/6124/6125"
              TRB->TIPO     :=      "03"
          ElseIf Alltrim(SD2->D2_CF) $ "5101/6101/7101"
              TRB->TIPO     :=      "01"
          ElseIf Alltrim(SD2->D2_CF) $ "5102/6102/7102"
              TRB->TIPO     :=      "02"
          EndIf
        MsUnLock()

        DbSelectArea("SD2")
        DbSkip()
    EndDo

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

cabec1  := Padc("PERIODO DE :"+DTOC(MV_PAR01)+ " A "+DTOC(MV_PAR02),80)
cabec2  := "DATA         QUANT/DIA     FATURAM/DIA           QUANT/ACUM         FATURAM/ACUM "
//REGUA    "012345678901234567890123456789012345678901234567890123456789012345678901234567890"
//REGUA    "         10        20        30        40        50        60        70        80"

DbSelectArea("TRB")
_cIndTRB := CriaTrab(Nil,.f.)
_cChaTRB := "DTOS(TRB->EMISSAO)+TRB->TIPO"

IndRegua("TRB",_cIndTRB,_cChaTRB,,,"Indexando os Registros...")
DbGoTop()

Setregua(Lastrec())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)

Do While !Eof()

    Incregua()

    _ddata := TRB->EMISSAO

    While TRB->EMISSAO == _dData

        _nQtdPro[1] := _nQtdPro[1] + TRB->QUANT
        _nTotPro[1] := _nTotPro[1] + TRB->VALFT

        If TRB->TIPO == "01"
            _nQtdVen    := _nQtdVen    + TRB->QUANT
            _nTotVen    := _nTotVen    + TRB->VALFT
        ElseIf TRB->TIPO == "02"
            _nQtdRev    := _nQtdRev    + TRB->QUANT
            _nTotRev    := _nTotRev    + TRB->VALFT
        ElseIf TRB->TIPO == "03"
            _nQtdTer    := _nQtdTer    + TRB->QUANT
            _nTotTer    := _nTotTer    + TRB->VALFT
        ElseIf TRB->TIPO == "04"
            _nQtdRet    := _nQtdRet    + TRB->QUANT
            _nTotRet    := _nTotRet    + TRB->VALFT
        ElseIf TRB->TIPO == "05"
            _nQtdSuc    := _nQtdSuc    + TRB->QUANT
            _nTotSuc    := _nTotSuc    + TRB->VALFT
        EndIf

        _nQtdPro[2] := _nQtdPro[2] + TRB->QUANT
        _nTotPro[2] := _nTotPro[2] + TRB->VALFT

        DbSkip()
    EndDo

    @ nLin , 000         PSAY Dtoc(_dData)
    @ nLin , pCol()+04   PSAY _nQtdPro[1]   Picture "@E 999,999.99"
    @ nLin , pCol()+02   PSAY _nTotPro[1]   Picture "@E 999,999,999.99"
    @ nLin , pCol()+11   PSAY _nQtdPro[2]   Picture "@E 999,999.99"
    @ nLin , pCol()+07   PSAY _nTotPro[2]   Picture "@E 999,999,999.99"

    nLin := nLin + 1

    _nQtdPro[1] := 0
    _nTotPro[1] := 0

    If nLin > 59
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
        nLin := 8
    Endif
EndDo

nLin := nLin + 2
@nLin , 00    PSAY "TOTAL            "
@nLin , pCol()+32   PSAY _nQtdPro[2]   Picture "@E 999,999.99"
@nLin , pCol()+07   PSAY _nTotPro[2]   Picture "@E 999,999,999.99"
nLin := nLin + 3

@nLin, 00   PSAY Padc("RESUMO POR TIPO DE FATURAMENTO",limite)
nLin := nLin + 2

@nLin, 00   PSAY "VENDA    "
@nLin, pCol()+03    PSAY _nQtdVen                 Picture "@E 999,999.99"
@nLin, pCol()+02    PSAY _nTotVen                 Picture "@E 999,999,999.99"
@nLin, pCol()+15    PSAY (_nTotVen/_nQtdVen)      Picture "@E 999.99"
@nLin, pCol()+10    PSAY "PRECO MEDIO"
nLin := nLin + 2

@nLin, 00   PSAY "REVENDA  "
@nLin, pCol()+03    PSAY _nQtdRev                 Picture "@E 999,999.99"
@nLin, pCol()+02    PSAY _nTotRev                 Picture "@E 999,999,999.99"
@nLin, pCol()+15    PSAY (_nTotRev/_nQtdRev)      Picture "@E 999.99"
@nLin, pCol()+10    PSAY "PRECO MEDIO"
nLin := nLin + 2

@nLin, 00   PSAY "TERCEIROS"
@nLin, pCol()+03    PSAY _nQtdTer                 Picture "@E 999,999.99"
@nLin, pCol()+02    PSAY _nTotTer                 Picture "@E 999,999,999.99"
@nLin, pCol()+15    PSAY (_nTotTer/_nQtdTer)      Picture "@E 999.99"
@nLin, pCol()+10    PSAY "PRECO MEDIO"
nLin := nLin + 2

@nLin, 00   PSAY "RETALHO  "
@nLin, pCol()+03    PSAY _nQtdRet                 Picture "@E 999,999.99"
@nLin, pCol()+02    PSAY _nTotRet                 Picture "@E 999,999,999.99"
@nLin, pCol()+15    PSAY (_nTotRet/_nQtdRet)      Picture "@E 999.99"
@nLin, pCol()+10    PSAY "PRECO MEDIO"
nLin := nLin + 2

@nLin, 00   PSAY "SUCATA   "
@nLin, pCol()+03    PSAY _nQtdSuc                 Picture "@E 999,999.99"
@nLin, pCol()+02    PSAY _nTotSuc                 Picture "@E 999,999,999.99"
@nLin, pCol()+15    PSAY (_nTotSuc/_nQtdSuc)      Picture "@E 999.99"
@nLin, pCol()+10    PSAY "PRECO MEDIO"
nLin := nLin + 2

@nLin, 00   PSAY "TOTAL    "
@nLin, pCol()+03    PSAY (_nQtdVen + _nQtdRev + _nQtdTer + _nQtdRet + _nQtdSuc)     Picture "@E 999,999.99"
@nLin, pCol()+02    PSAY (_nTotVen + _nTotRev + _nTotTer + _nTotRet + _nTotSuc)     Picture "@E 999,999,999.99"
nLin := nLin + 2

Roda(cbCont,"Faturamento",tamanho)

Set Device to Screen
If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

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
    aadd(aRegs,{cPerg,'01','Data Inicial         ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Data Final           ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Quanto ao Tes        ? ','mv_ch3','N',01, 0, 0,'C', '', 'mv_par03','','','','','','','','','','','','','','',''})

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

Return()

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

