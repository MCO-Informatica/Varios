#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function KFIN04R()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CCHAVE,CINDEX,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,CABEC1,CABEC2,_CNOMECLI,_CNUMLIQ,AREGS")
SetPrvt("I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFIN04R  ³ Autor ³Ricardo Correa de Souza³ Data ³02/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Titulos Baixados em Liquidacao                  ³±±
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

DbSelectArea("SE1")         //----> Titulos a Receber

cChave := "SE1->E1_NUMLIQ+SE1->E1_BCOCHQ"
cIndex := CriaTrab(Nil,.f.)

IndRegua("SE1",cIndex,cChave,,,"Indice Temporario ...")

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "KFIN04R"
cDesc1    := "Este relatorio ira emitir a listagem de Titulos Baixados"
cDesc2    := "por Liquidacao conforme parametros selecionados."
cDesc3    := " "
cString   := "SE1"
lEnd      := .F.
tamanho   := "P"
limite    := 80 
titulo    := "Titulos Baixados por Liquidacao"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "KFIN04R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FIN04R    "
nLin      := 8
m_pag     := 1
cabec1  := "Nro.  Titulo  Emissao   Vencto    Baixa    Vlr. Receb.  Vlr. Saldo  Cliente     "
cabec2  := "Nro. Cheque  Banco  Agencia  Conta      Bom Para  Vlr. Cheque    Situacao       "
//          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                    10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       200       210       220

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Da Liquidacao    ?                                        *
* mv_par02  ----> Ate a Liquidacao ?                                        *
* mv_par03  ----> Do Prefixo       ?                                        *
* mv_par04  ----> Ate o Prefixo    ?                                        *
* mv_par05  ----> Do Titulo        ?                                        *
* mv_par06  ----> Ate o Titulo     ?                                        *
* mv_par07  ----> Da Parcela       ?                                        *
* mv_par08  ----> Ate a Parcela    ?                                        *
* mv_par09  ----> Do Cliente       ?                                        *
* mv_par10  ----> Da Loja          ?                                        *
* mv_par11  ----> Ate o Cliente    ?                                        *
* mv_par12  ----> Ate a Loja       ?                                        *
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
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

#IFDEF WINDOWS
    RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     RptStatus({|| Execute(Imprime)},titulo)
#ELSE
    Imprime()
#ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

DbSelectArea("SE1")
SetRegua(LastRec())
DbSeek(xFilial("SE1")+MV_PAR01,.T.)

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

Do While !Eof() .And. SE1->E1_NUMLIQ <= MV_PAR02
    IncRegua()
    //----> filtrando intervalo de liquidacoes definido nos parametros
    If SE1->E1_NUMLIQ < MV_PAR01 .Or. SE1->E1_NUMLIQ > MV_PAR02
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de prefixos definido nos parametros
    If SE1->E1_PREFIXO < MV_PAR03 .Or. SE1->E1_PREFIXO > MV_PAR04
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de titulos definido nos parametros
    If SE1->E1_NUM < MV_PAR05 .Or. SE1->E1_NUM > MV_PAR06
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de parcelas definido nos parametros
    If SE1->E1_PARCELA < MV_PAR07 .Or. SE1->E1_PARCELA > MV_PAR08
        DbSkip()
        Loop
    EndIf

    //----> filtrando intervalo de clientes definido nos parametros
    If SE1->E1_CLIENTE + SE1->E1_LOJA < MV_PAR09 + MV_PAR10 .Or. SE1->E1_CLIENTE + SE1->E1_LOJA > MV_PAR11 + MV_PAR12
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SA1")
    DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
    If !Empty(SA1->A1_NREDUZ)
            _cNomeCli := SA1->A1_NREDUZ
        Else
            _cNomeCli := SA1->A1_NOME
        EndIf

    If nLin > 54
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
    EndIf

    @ nLin, 000 PSAY "L i q u i d a c a o :   "+SE1->E1_NUMLIQ
    nLin := nLin + 1

    DbSelectArea("SE1")
    While Empty(SE1->E1_BCOCHQ)
        nLin := nLin + 1
        @ nLin, 000 PSAY SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA
        @ nLin, 014 PSAY Dtoc(SE1->E1_EMISSAO)
        @ nLin, 024 PSAY Dtoc(SE1->E1_VENCTO)
        @ nLin, 034 PSAY Dtoc(SE1->E1_BAIXA)
        @ nLin, 040 PSAY SE1->E1_VALLIQ     Picture "@E 999,999,999.99"
        @ nLin, 053 PSAY SE1->E1_SALDO      Picture "@E 999,999,999.99"
        @ nLin, 069 PSAY _cNomeCli
        nLin := nLin + 1
        @ nLin, 000 PSAY Replicate("-",limite)
        nLin := nLin + 1
        _cNumLiq := SE1->E1_NUMLIQ
        DbSkip()
    EndDo

    While SE1->E1_NUMLIQ == _cNumLiq
        If Alltrim(SE1->E1_TIPO) <> "CH"
            DbSkip()
            Loop
        EndIf

        @ nLin, 000 PSAY SE1->E1_TIPO
        @ nLin, 004 PSAY SE1->E1_NUM
        @ nLin, 013 PSAY SE1->E1_BCOCHQ
        @ nLin, 020 PSAY SE1->E1_AGECHQ
        @ nLin, 029 PSAY SE1->E1_CTACHQ
        @ nLin, 040 PSAY Dtoc(SE1->E1_VENCTO)
        @ nLin, 047 PSAY SE1->E1_VLCRUZ     Picture "@E 999,999,999.99"
        @ nLin, 066 PSAY Iif(!Empty(SE1->E1_BAIXA),"LIQUIDADO","EM ABERTO")
        nLin := nLin + 1
        DbSkip()
    EndDo
    nLin := nLin + 1
    @ nLin, 000 PSAY Replicate("-",limite)
    nLin := nLin + 1
    DbSkip()
EndDo

Roda(cbCont,"Liquidacao",tamanho)

Set Device to Screen

If aReturn[5] == 1 
	Set Printer TO
    dbCommitAll()
    OurSpool(wnrel)
Endif

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

    aadd(aRegs,{cPerg,'01','Da Liquidacao  ? ','mv_ch1','C',06, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate Liquidacao ? ','mv_ch2','C',06, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Do Prefixo     ? ','mv_ch3','C',03, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate o Prefixo  ? ','mv_ch4','C',03, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Do Titulo      ? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'06','Ate o Titulo   ? ','mv_ch6','C',06, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Da Parcela     ? ','mv_ch7','C',01, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'08','Ate a Parcela  ? ','mv_ch8','C',01, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'09','Do Cliente     ? ','mv_ch9','C',06, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'10','Da Loja        ? ','mv_cha','C',02, 0, 0,'G', '', 'mv_par10','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'11','Ate o Cliente  ? ','mv_chb','C',06, 0, 0,'G', '', 'mv_par11','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'12','Ate a Loja     ? ','mv_chc','C',02, 0, 0,'G', '', 'mv_par12','','','','','','','','','','','','','','',''})

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
* Retorna para sua Chamada (KFIN04R)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

