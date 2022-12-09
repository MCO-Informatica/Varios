#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Kfat12r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("DINICIAL,CGRUPO,CDESC,ATOTAISP,ATOTAISA,ATOTGERAL")
SetPrvt("NTAMANHO,NLIMITE,CTITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CBCONT,ARETURN,NOMEPROG,CPERG,LCONTINUA,NLIN")
SetPrvt("WNREL,CSTRING,NLASTKEY,M_PAG,LABORTPRINT,CABEC1")
SetPrvt("CABEC2,AESTRUT,CNOMEARQ,CINDEX,CCHAVE,AREGS")
SetPrvt("I,J,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � KFAT12R  � Autor �                       � Data �22/06/2002���
�������������������������������������������������������������������������Ĵ��
���Descricao � Estatistica de Vendas e Faturamento por Grupo de Produto   ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Kenia Industrias Testeis Ltda                              ���
�������������������������������������������������������������������������Ĵ��
���            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ���
�������������������������������������������������������������������������Ĵ��
���   Analista   �  Data  �             Motivo da Alteracao               ���
�������������������������������������������������������������������������Ĵ��
���              �        �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==>     #DEFINE PSAY SAY
#ENDIF

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas nos Parametros                                       *
*                                                                           *
* mv_par01                Da Emissao        ?                               *
* mv_par02                Ate a Emissao     ?                               *
* mv_par03                Inicio Acumulado  ?                               *
* mv_par04                Do Cliente        ?                               *
* mv_par05                Ate o Cliente     ?                               *
* mv_par06                Do Vendedor       ?                               *
* mv_par07                Ate o Vendedor    ?                               *
* mv_par08                Tes de Vendas     ?                               *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

dInicial    := mv_par01
cGrupo      := Space(05)              // grupo acumulador
cDesc       := Space(25)              // descricao do grupo
aTotaisP    := { 0, 0 }               // quantidade pedido e quantidade faturada - periodo
aTotaisA    := { 0, 0 }               // quantidade pedido e quantidade faturada - acumulado
aTotGeral   := { 0, 0, 0, 0 }         // quantidade total geral
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

nTamanho    := "M"
nLimite     := 132
cTitulo     := "Vendas e Faturamento por Artigo"
cDesc1      := "Este programa emitira relatorio estatistico"
cDesc2      := "Vendas X Faturamento por Artigo"
cDesc3      := ""
cbCont      := 0
aReturn     := { "Especial", 1, "Administracao", 1, 1, 1, "", 1 }
nomeprog    := "KFAT12R" 
cPerg       := "FAT12R    "
lContinua   := .t.
nLin        := 7
wnrel       := "KFAT12R"
cString     := "SC5"
nLastKey    := 0
m_Pag       := 1
lAbortPrint := .f.
cabec1      := "ARTIGO  DESCRICAO                  QTD VEN           QTD FAT           QTD VEN ACUM          QTD FAT ACUM"
cabec2      := ""

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstrut  := {{"TMP_GRUPO"  ,"C",03,0},; 
             {"TMP_DESC"   ,"C",30,0},;
             {"TMP_PROD"   ,"C",15,0},;
             {"TMP_QTD_VP" ,"N",12,2},;
             {"TMP_QTD_VA" ,"N",12,2},;
             {"TMP_QTD_FP" ,"N",12,2},;
             {"TMP_QTD_FA" ,"N",12,2}}

cNomeArq := CriaTrab( aEstrut, .t. )
DbUseArea( .T., , cNomeArq, "TRB", .T., .F. )   

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos Utilizados no Processamento                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SB1")                 //----> Produtos
DbSetOrder(1)                       //----> Codigo

DbSelectArea("SC5")                 //----> Pedidos de Venda
DbSetOrder(2)                       //----> Data Emissao + Numero Pedido

DbSelectArea("SC6")                 //----> Itens dos Pedidos
DbSetOrder(1)                       //----> Produto + Pedido + Item

DbSelectArea("SD2")                 //----> Itens das Notas de Saida
DbSetOrder(3)                       //----> Produto + Local + Sequencia

DbSelectArea("SF2")                 //----> Cabe�alho de Notas Fiscais Saida
DbSetOrder(6)                       //----> Emissao + Nota + Serie

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()

Pergunte( cPerg, .f. )

wnrel := SetPrint( cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3, .F. )

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|| Imprime()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(Imprime)})
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

//----> busca as quantidades vendidas
dInicial := mv_par03

DbSelectArea("TRB")
cIndex := CriaTrab(Nil,.f.)
cChave := "TRB->TMP_PROD+TRB->TMP_GRUPO"

IndRegua( "TRB", cIndex, cChave, , , "" )
   
DbSelectArea("SC5")
DbSetOrder(2)
If !DbSeek(xFilial("SC5")+Dtos(dInicial))
    Do While dInicial <= mv_par02
        dInicial := dInicial + 1
        If DbSeek(xFilial("SC5") + Dtos(dInicial))
            Exit
        EndIf
    EndDo
EndIf

SetRegua(LastRec())

Do While !Eof() .And. SC5->C5_EMISSAO <= mv_par02 .And. !lAbortPrint

    IncRegua()

    //----> filtrando apenas intervalo de clientes selecionado nos parametros
    If SC5->C5_CLIENTE < mv_par04 .OR. SC5->C5_CLIENTE > mv_par05
        DbSkip()
        Loop
    EndIf

    //----> filtrando apenas intervalo de vendedores selecionado nos parametros
    If SC5->C5_VEND1 < mv_par06 .OR. SC5->C5_VEND1 > mv_par07
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC6")
    DbSeek( xFilial("SC6") + SC5->C5_NUM )

    Do While SC6->C6_NUM == SC5->C5_NUM

        //----> filtrando apenas os tes selecionado nos parametros
        If !SC6->C6_TES $Alltrim(mv_par08)
            DbSkip()
            Loop
        EndIf

        DbSelectArea("SB1")
        DbSeek( xFilial("SB1") + SC6->C6_PRODUTO )

        If !Empty(SB1->B1_X_ARTG)
            cGrupo := Subs(SC6->C6_PRODUTO,1,3)
        Else
            cGrupo := "XXX"
        EndIf

        DbSelectArea("TRB")
        If DbSeek(SD2->D2_COD,.f.)
            RecLock( "TRB",.f. )
              If SC5->C5_EMISSAO < mv_par01
                  TRB->TMP_QTD_VP   :=   0
              Else
                  TRB->TMP_QTD_VP   :=   SC6->C6_QTDVEN
              EndIf

              TRB->TMP_QTD_FA :=   SC6->C6_QTDVEN
            MsUnLock()
        Else
            RecLock( "TRB", .t. )
              TRB->TMP_GRUPO  :=   cGrupo
              TRB->TMP_DESC   :=   SB1->B1_X_ARTG
              TRB->TMP_PROD   :=   SC6->C6_PRODUTO

              If SC5->C5_EMISSAO < mv_par01
                  TRB->TMP_QTD_VP   :=   0
              Else
                  TRB->TMP_QTD_VP   :=   SC6->C6_QTDVEN
              EndIf

              TRB->TMP_QTD_VA :=   SC6->C6_QTDVEN
            MsUnLock()
        EndIf

        DbSelectArea("SC6")
        DbSkip()
    EndDo

    DbSelectArea("SC5")
    DbSkip()
EndDo

//----> busca as quantidades faturadas
dInicial := mv_par03

DbSelectArea("TRB")
cIndex := CriaTrab(Nil,.f.)
cChave := "TRB->TMP_PROD+TRB->TMP_GRUPO"

IndRegua( "TRB", cIndex, cChave, , , "" )

DbSelectArea("SF2")
DbSetOrder(6)
If !DbSeek( xFilial("SF2") + Dtos(dInicial) )
    Do While dInicial <= mv_par02
        dInicial := dInicial + 1
        If DbSeek( xFilial("SF2") + Dtos(dInicial) )
            Exit
        EndIf
    EndDo
EndIf

Do While !Eof() .AND. SF2->F2_EMISSAO <= mv_par02 .And. !lAbortPrint

    IncRegua()

    //----> filtrando apenas intervalo de clientes selecionado nos parametros
    If SF2->F2_CLIENTE < mv_par04 .OR. SF2->F2_CLIENTE > mv_par05
        DbSkip()
        Loop
    EndIf

    //----> filtrando apenas intervalo de vendedores selecionado nos parametros
    If SF2->F2_VEND1 < mv_par06 .OR. SF2->F2_VEND1 > mv_par07
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SD2")
    DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE )

    Do While SD2->D2_DOC == SF2->F2_DOC
      
        //----> filtrando apenas os tes selecionado nos parametros
        If !SD2->D2_TES $mv_par08
            DbSkip()
            Loop
        EndIf

        DbSelectArea("SB1")
        DbSeek( xFilial("SB1") + SD2->D2_COD )

        If !Empty(SB1->B1_X_ARTG)
            cGrupo := Subs(SD2->D2_COD,1,3 )
        Else
            cGrupo := "XXX"
        EndIf

        DbSelectArea("TRB")
        If DbSeek(SD2->D2_COD,.f.)
            RecLock( "TRB",.f. )
              If SF2->F2_EMISSAO < mv_par01
                  TRB->TMP_QTD_FP   :=   0
              Else
                  TRB->TMP_QTD_FP   :=   SD2->D2_QUANT
              EndIf

              TRB->TMP_QTD_FA :=   SD2->D2_QUANT
            MsUnLock()
        Else
            RecLock( "TRB", .t. )
              TRB->TMP_GRUPO  :=   cGrupo
              TRB->TMP_DESC   :=   SB1->B1_X_ARTG
              TRB->TMP_PROD   :=   SD2->D2_COD    

              If SF2->F2_EMISSAO < mv_par01
                  TRB->TMP_QTD_FP   :=   0
              Else
                  TRB->TMP_QTD_FP   :=   SD2->D2_QUANT
              EndIf

              TRB->TMP_QTD_FA :=   SD2->D2_QUANT 
            MsUnLock()
        EndIf

        DbSelectArea("SD2")
        DbSkip()
    EndDo

    DbSelectArea("SF2")
    DbSkip()
EndDo

//----> Impressao do Relatorio
DbSelectArea("TRB")

cIndex := CriaTrab(Nil,.f.)
cChave := "TRB->TMP_GRUPO+TRB->TMP_PROD"

IndRegua( "TRB", cIndex, cChave, , , "Preparando para Imprimir..." )

@ nLin, 000 PSAY AvalImp( nLimite )

Cabec(cTitulo,Cabec1,Cabec2,nomeprog,nTamanho,15)

SetRegua( LastRec() )
DbGoTop()

Do While !Eof()

    cGrupo  := TRB->TMP_GRUPO
    cDesc   := TRB->TMP_DESC    
    aTotaisP := { 0, 0 }         
    aTotaisA := { 0, 0 }         

    @ nLin, 000       PSAY cGrupo
    @ nLin, Pcol()+04 PSAY cDesc

    nLin := nLin + 2

    Do While TRB->TMP_GRUPO == cGrupo

        IncRegua()

        @ nLin, 000         PSAY TRB->TMP_PROD
        @ nLin, Pcol()+06   PSAY TRB->TMP_QTD_VP   Picture"@E 999,999.99"
        @ nLin, Pcol()+06   PSAY TRB->TMP_QTD_VA   Picture"@E 999,999.99"
        @ nLin, Pcol()+06   PSAY TRB->TMP_QTD_FP   Picture"@E 999,999.99"
        @ nLin, Pcol()+06   PSAY TRB->TMP_QTD_FA   Picture"@E 999,999.99"

        aTotaisP[1]  := aTotaisP[1]  + TRB->TMP_QTD_VP
        aTotaisA[1]  := aTotaisA[1]  + TRB->TMP_QTD_VA
        aTotGeral[1] := aTotGeral[1] + TRB->TMP_QTD_VP
        aTotGeral[3] := aTotGeral[3] + TRB->TMP_QTD_VA

        aTotaisP[2]  := aTotaisP[2]  + TRB->TMP_QTD_FP
        aTotaisA[2]  := aTotaisA[2]  + TRB->TMP_QTD_FA
        aTotGeral[2] := aTotGeral[2] + TRB->TMP_QTD_FP
        aTotGeral[4] := aTotGeral[4] + TRB->TMP_QTD_FA

        nLin := nLin + 1

        DbSelectArea("TRB")
        DbSkip()
    EndDo

    nLin := nLin + 1

    @ nLin, 000 PSAY "Total "+cGrupo
    @ nLin, Pcol()+06 PSAY aTotaisP[1]          Picture"@E 999,999.99"
    @ nLin, Pcol()+06 PSAY aTotaisP[2]          Picture"@E 999,999.99"
    @ nLin, Pcol()+06 PSAY aTotaisA[1]          Picture"@E 999,999.99"
    @ nLin, Pcol()+06 PSAY aTotaisA[2]          Picture"@E 999,999.99"

    nLin := nLin + 1

    @ nLin , 000  PSAY Replicate( "-", nLimite )

    nLin := nLin + 1

    If nLin > 60
        Cabec(cTitulo,Cabec1,Cabec2,nomeprog,nTamanho,15)
        nLin := 7
    EndIf

    aTotaisP[1]  := 0
    aTotaisA[1]  := 0
    aTotaisP[2]  := 0
    aTotaisA[2]  := 0

EndDo

nLin := nLin + 1

@ nLin, 000 PSAY "Total Geral "

@ nLin, Pcol()+06 PSAY aTotGeral[1]          Picture"@E 999,999.99"
@ nLin, Pcol()+06 PSAY aTotGeral[2]          Picture"@E 999,999.99"
@ nLin, Pcol()+06 PSAY aTotGeral[3]          Picture"@E 999,999.99"
@ nLin, Pcol()+06 PSAY aTotGeral[4]          Picture"@E 999,999.99"

nLin := nLin + 2

Roda(CbCont,"Estatistica","M")

DbSelectArea("TRB")     
DbCloseArea("TRB")

fErase( cNomeArq+".dbf" )
fErase( cNomeArq+".idx" )
fErase( cNomeArq+".mem" )

If aReturn[5] == 1
   Set Printer To
   OurSpool(wnrel)
EndIf

Ms_Flush()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Criacao do Grupo de Perguntas                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)

aRegs :={}

Aadd(aRegs,{cPerg,"01","Da Emissao              ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Ate a Emissao           ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Inicio Acumulado        ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Do Cliente              ?","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Ate o Cliente           ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Do Vendedor             ?","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Ate o Vendedor          ?","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Tes de Vendas           ?","mv_ch8","C",30,0,0,"G","","mv_par08","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !DbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    EndIf
Next

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim da Funcao                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
