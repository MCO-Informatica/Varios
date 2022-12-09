#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function KEST04R()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,NCOUNT,CABEC1,CABEC2,AREGS,I")
SetPrvt("J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KEST04R  ³ Autor ³Ricardo Correa de Souza³ Data ³17/05/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Compara Saldos por Lote com Tabela de Inventario e Lista   ³±±
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

DbSelectArea("SB1")         //----> Cadastro de Produtos
DbSetOrder(1)               //----> Produto

DbSelectArea("SB7")         //----> Inventario          
DbSetOrder(2)               //----> SubLote + Lote + Produto

DbSelectArea("SB8")         //----> Saldos por Lote
DbSetOrder(2)               //----> SubLote + Lote + Produto

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"PROD"     ,"C",15,0})
AADD(aEstru1,{"DESCR"    ,"C",30,0})
AADD(aEstru1,{"SUBLOTE"  ,"C",06,0})
AADD(aEstru1,{"LOTE"     ,"C",10,0})
AADD(aEstru1,{"SALDO"    ,"N",12,2})

_cTemp1 := CriaTrab( aEstru1, .T. )  
dbUseArea(.T.,,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "KEST04R"
cDesc1    := "Este relatorio ira emitir a listagem de divergencias entre "
cDesc2    := "Saldos por Lote e Saldos por Inventario."
cDesc3    := " "
cString   := "SB8"
lEnd      := .F.
tamanho   := "P"
limite    := 80
titulo    := "Divergencias entre Saldos por Lote e Saldos por Inventario"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "KEST04R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "EST04R"
nLin      := 8
m_pag     := 1
nCount    := 0

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

Processa({||RunProc()},"Divergencias Saldos x Inventario")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Divergencias Saldos x Inventario")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("SB8")
DbGoTop()
ProcRegua(RecCount())

Do While !Eof() 

    IncProc("Selecionando Produto "+SB8->B8_PRODUTO+" Lote "+SB8->B8_LOTECTL)

    //----> filtrando somente o intervalo de produts definido nos parametros
    If SB8->B8_PRODUTO < MV_PAR01 .OR. SB8->B8_PRODUTO > MV_PAR02
        DbSkip()
        Loop
    EndIf

    //----> filtrando somente lotes que possuem saldo
    If SB8->B8_SALDO == 0
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SB7")
    If !DbSeek(xFilial("SB7")+"      "+SB8->B8_LOTECTL+SB8->B8_PRODUTO)
        DbSelectArea("TRB")
        RecLock("TRB",.t.)
          TRB->PROD     :=      SB8->B8_PRODUTO
          TRB->DESCR    :=      Posicione("SB1",1,xFilial("SB1")+SB8->B8_PRODUTO,"B1_DESC")
          TRB->LOTE     :=      SB8->B8_LOTECTL
          TRB->SALDO    :=      SB8->B8_SALDO 
        MsUnLock()
    EndIf

    DbSelectArea("SB8")
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

cabec1  := "CODIGO          DESCRICAO                              LOTE                SALDO"
cabec2  := "PRODUTO         PRODUTO                                                          "
//REGUA    "012345678901234567890123456789012345678901234567890123456789012345678901234567890"
//REGUA    "         10        20        30        40        50        60        70        80"


DbSelectArea("TRB")
DbGoTop()
SetRegua(Lastrec())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

Do While !Eof()

    IncRegua()

    @ nLin, 000    Psay TRB->PROD                   
    @ nLin, pCol()+1 Psay TRB->DESCR 
    @ nLin, pCol()+9 Psay TRB->LOTE
    @ nLin, pCol()   Psay TRB->SALDO   Picture "@E 999,999,999.999"
    nLin := nLin + 1
    @ nLin, 000 Psay Repl("-",limite)
    nLin := nLin + 1

    If nLin > 59
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
        nLin := 8
    Endif
    DbSkip()
EndDo


Roda(cbCont,"Divergencia",tamanho)

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

    aadd(aRegs,{cPerg,'01','Do Produto     ? ','mv_ch1','C',15, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'02','Ate o Produto  ? ','mv_ch2','C',15, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','','SB1'})

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

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

