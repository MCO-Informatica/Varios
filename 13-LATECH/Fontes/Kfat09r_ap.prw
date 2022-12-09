#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Kfat09r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,LEND")
SetPrvt("TAMANHO,LIMITE,TITULO,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("ADRIVER,CBCONT,CPERG,NLIN,M_PAG,_NVLRFAT")
SetPrvt("_NVLRCOM,_NVLRREC,_NVLRPAG,_NVLRBOR,_NVLRDEV,CABEC1")
SetPrvt("CABEC2,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT09R  ³ Autor ³                       ³ Data ³11/02/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio Gerencial de Duplicatas                          ³±±
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

DbSelectArea("SZ9")         //----> Controle Gerencial de Duplicatas
DbSetOrder(1)               //----> Data da Ocorrencia

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "KFAT09R"
cDesc1    := "Controle Gerencial de Duplicatas"
cDesc2    := " "
cDesc3    := " "
cString   := "SZ9"
lEnd      := .F.
tamanho   := "M"
limite    := 132
titulo    := "CONTROLE GERENCIAL DE DUPLICATAS"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "KFAT09R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT09R    "
nLin      := 8
m_pag     := 1
_nVlrFat  := 0
_nVlrCom  := 0
_nVlrRec  := 0
_nVlrPag  := 0
_nVlrBor  := 0
_nVlrDev  := 0

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Data Inicial   ?                                          *
* mv_par02  ----> Data Final     ?                                          *
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

cabec1  := Padc("PERIODO DE :"+DTOC(MV_PAR01)+ " A "+DTOC(MV_PAR02),132)
cabec2  := "DATA           SALDO ANTERIOR        FATURAMENTO      BAIXAS BANCOS    BAIXAS CARTEIRA           BORDEROS        SALDO FINAL" 
//REGUA    "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123"
//REGUA    "         10        20        30        40        50        60        70        80"        90      100       110       120   "

DbSelectArea("SZ9")
DbSetOrder(1)
DbSeek(xFilial("SZ9")+Dtos(mv_par01),.t.)

Setregua(Lastrec())

@ 00,00 Psay AvalImp(limite)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

Do While !Eof() .And. SZ9->Z9_DATA <= mv_par02

    Incregua()

    @ nLin , 000         PSAY Dtoc(SZ9->Z9_DATA)
    @ nLin , pCol()+07   PSAY SZ9->Z9_SALANT   Picture "@E 999,999,999.99"
    @ nLin , pCol()+05   PSAY SZ9->Z9_FATURAM  Picture "@E 999,999,999.99"
    @ nLin , pCol()+05   PSAY SZ9->Z9_BXBANCO  Picture "@E 999,999,999.99"
    @ nLin , pCol()+05   PSAY SZ9->Z9_BXCARTE  Picture "@E 999,999,999.99"
    @ nLin , pCol()+05   PSAY SZ9->Z9_BORDERO  Picture "@E 999,999,999.99"
    @ nLin , pCol()+05   PSAY SZ9->Z9_SALFIM   Picture "@E 999,999,999.99"

    nLin := nLin + 1

    /*
    _nVlrFat    :=  _nVlrFat + TRB->VLRFAT
    _nVlrCom    :=  _nVlrCom + TRB->VLRCOM
    _nVlrRec    :=  _nVlrRec + TRB->VLRREC
    _nVlrPag    :=  _nVlrPag + TRB->VLRPAG
    _nVlrBor    :=  _nVlrBor + TRB->VLRBOR
    _nVlrDev    :=  _nVlrDev + TRB->VLRDEV
    */

    DbSkip()

    If nLin > 59
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
        nLin := 8
    Endif
EndDo

nLin := nLin + 1
@nLin , 00 PSAY Replicate("-",limite)
nLin := nLin + 1
@nLin , 00    PSAY "TOTAL GERAL "
@nLin , pCol()+03   PSAY _nVlrFat      Picture "@E 999,999,999.99"
@nLin , pCol()+05   PSAY _nVlrCom      Picture "@E 999,999,999.99"
@nLin , pCol()+05   PSAY _nVlrRec      Picture "@E 999,999,999.99"
@nLin , pCol()+05   PSAY _nVlrPag      Picture "@E 999,999,999.99"
@nLin , pCol()+05   PSAY _nVlrBor      Picture "@E 999,999,999.99"
@nLin , pCol()+05   PSAY _nVlrDev      Picture "@E 999,999,999.99"

Roda(cbCont,"Faturamento",tamanho)

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
    aadd(aRegs,{cPerg,'01','Data Inicial         ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Data Final           ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})

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

