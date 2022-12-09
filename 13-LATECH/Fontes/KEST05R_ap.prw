#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function KEST05R()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,LEND")
SetPrvt("TAMANHO,LIMITE,TITULO,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("ADRIVER,CBCONT,CPERG,NLIN,M_PAG,NCOUNT")
SetPrvt("CABEC1,CABEC2,AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KEST05R  ³ Autor ³Ricardo Correa de Souza³ Data ³29/06/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Lista Produtos que nao Possui Estrutura                    ³±±
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

DbSelectArea("SG1")         //----> Inventario          
DbSetOrder(1)               //----> Codigo + Componente       

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "KEST05R"
cDesc1    := "Este relatorio ira emitir a listagem de produtos que nao "
cDesc2    := "possuem estrutura-receita."
cDesc3    := " "
cString   := "SB1"
lEnd      := .F.
tamanho   := "P"
limite    := 80
titulo    := "Produtos que nao possuem Receita - Estrutura"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "KEST05R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "EST05R    "
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

cabec1  := "CODIGO          DESCRICAO        "
cabec2  := "PRODUTO         PRODUTO          "
//REGUA    "012345678901234567890123456789012"
//REGUA    "         10        20        30  "

DbSelectArea("SB1")
DbGoTop()
SetRegua(RecCount())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

Do While !Eof()

    IncRegua()

    //----> filtrando somente o intervalo de produtos definido nos parametros
    If SB1->B1_COD < MV_PAR01 .OR. SB1->B1_COD > MV_PAR02
        DbSkip()
        Loop
    EndIf

    //----> filtrando somente o intervalo de tipos definido nos parametros
    If SB1->B1_TIPO < MV_PAR03 .OR. SB1->B1_TIPO > MV_PAR04
        DbSkip()
        Loop
    EndIf

    //---->filtrando somente tecido cru
    If MV_PAR05 == 1
        If Right(Alltrim(SB1->B1_COD),3) #"000"
            DbSkip()
            Loop
        EndIf
    EndIf

    DbSelectArea("SG1")
    If !DbSeek(xFilial("SG1")+SB1->B1_COD)

        @ nLin, 000      Psay SB1->B1_COD                 
        @ nLin, pCol()+1 Psay SB1->B1_DESC
        nLin := nLin + 1
        @ nLin, 000 Psay Repl("-",limite)
        nLin := nLin + 1

        If nLin > 59
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
            nLin := 8
        Endif
    EndIf
    DbSelectArea("SB1")
    DbSkip()
EndDo

Roda(cbCont,"Divergencia",tamanho)

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

    aadd(aRegs,{cPerg,'01','Do Produto     ? ','mv_ch1','C',15, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'02','Ate o Produto  ? ','mv_ch2','C',15, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','','SB1'})
    aadd(aRegs,{cPerg,'03','Do Tipo        ? ','mv_ch3','C',02, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate o Tipo     ? ','mv_ch4','C',02, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Somente Cru    ? ','mv_ch5','N',01, 0, 0,'C', '', 'mv_par05','Sim','','','Nao','','','','','','','','','','',''})

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

