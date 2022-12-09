#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function kfat04r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("M_PAG,CBCONT,NLIN,WNREL,CSTRING,CABEC1")
SetPrvt("CABEC2,AESTRU1,_CTEMP1,CINDEX,CCHAVE,CVEND")
SetPrvt("NCOUNT,CNOMEVEND,CDATA,AREGS,I,J")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT04R  ³ Autor ³Ricardo Correa de Souza³ Data ³09/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Clientes Inavivos por Vendedor                  ³±±
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
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> 	#DEFINE PSAY SAY
#ENDIF

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Parametros Utilizados no Relatorio                                        *
* mv_par01      //----> Do Cliente     ?                                    *
* mv_par02      //----> Da Loja        ?                                    *
* mv_par03      //----> Ate o Cliente  ?                                    *
* mv_par04      //----> Ate a Loja     ?                                    *
* mv_par05      //----> Do Vendedor    ?                                    *
* mv_par06      //----> Ate o Vendedor ?                                    *
* mv_par07      //----> Inativos Desde ?                                    *
* mv_par08      //----> Tira o Vendedor?                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

tamanho:= "M"
Limite := 132 
titulo := PADC("Relatorio de Cliente Inativos por Vendedor",74)
cDesc1 := PADC("Este programa ira emitir a relacao de clientes inativos por vendedor",74)
cDesc2 := PADC("",74)
cDesc3 := PADC("Kenia Industrias Texteis Ltda",74)
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 1, 1,"",1 }
nomeprog  := "KFAT04R"
cPerg     := "FAT04R    "
nLastKey  := 0 
lContinua := .T.
m_pag     := 1
cbCont    := 00
nLin      := 8
wnrel     := "KFAT04R"
cString   := "SA1"
titulo    := "Relatorio de Cliente Inativos"
cabec1    := "CODIGO LJ   NOME DO                           TELEFONE        CONTATO         ULTIMA         VALOR DA          "
cabec2    := "            CLIENTE                                                           COMPRA         MAIOR COMPRA      "
//           "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
//           "         10        20        30        40        50        60        70        80        90       100       110"

ValidPerg()     //----> verifica se existe grupo de perguntas no SX1

Pergunte( cPerg, .F. )

wnrel := SetPrint( cString, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .T. )

If nLastKey == 27
   Return
Endif

SetDefault( aReturn, cString )

If nLastKey == 27
   Return
Endif

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivo Temporario                                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

aEstru1 :={}
AADD(aEstru1,{"CODIGO"  ,"C",06,0})
AADD(aEstru1,{"LOJA"    ,"C",02,0})
AADD(aEstru1,{"NOME"    ,"C",30,0})
AADD(aEstru1,{"ULTCOM"  ,"D",08,0})
AADD(aEstru1,{"VALOR"   ,"N",12,2})
AADD(aEstru1,{"VEND"    ,"C",06,0})
AADD(aEstru1,{"STATUS"  ,"C",01,0})
AADD(aEstru1,{"TELEF"   ,"C",15,0})
AADD(aEstru1,{"CONTATO" ,"C",15,0})

_cTemp1 := CriaTrab( aEstru1, .T. )  
dbUseArea(.T.,,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos Utilizados no Processamento                                      *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SA1")         //----> Cadastro de Clientes
DbSetOrder(1)               //----> Codigo + Loja

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||Clientes()},"Selecionando Dados Clientes Inativos")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(Clientes)},"Selecionando Dados Clientes Inativos")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Clientes
Static Function Clientes()

DbSelectArea("SA1")
DbGoTop()
ProcRegua(LastRec())

While Eof() == .f. 

    IncProc("Processando dados cliente "+SA1->A1_COD+"/"+SA1->A1_LOJA)

    //----> filtrando apenas clientes selecionado nos parametros  
    If SA1->A1_COD+SA1->A1_LOJA < mv_par01+mv_par02 .Or. SA1->A1_COD+SA1->A1_LOJA > mv_par03+mv_par04
        DbSkip()
        Loop
    EndIf

    //----> filtrando apenas vendedores selecionado nos parametros
    If SA1->A1_VEND < mv_par05 .Or. SA1->A1_VEND > mv_par06
        DbSkip()
        Loop
    EndIf

    //----> filtrando apenas datas menores ou iguais as selecionada nos parametros
    If Dtos(SA1->A1_ULTCOM) >= Dtos(mv_par07) 
        //----> muda status para ativo
        RecLock("SA1")
        SA1->A1_STATUS  :=  "A"
        MsUnLock()

        DbSkip()
        Loop
    EndIf

    DbSelectArea("TRB")
    RecLock("TRB",.t.)
      TRB->CODIGO       :=      SA1->A1_COD
      TRB->LOJA         :=      SA1->A1_LOJA
      TRB->NOME         :=      SA1->A1_NOME 
      TRB->ULTCOM       :=      SA1->A1_ULTCOM
      TRB->VALOR        :=      SA1->A1_MCOMPRA 
      TRB->VEND         :=      SA1->A1_VEND  
      TRB->STATUS       :=      SA1->A1_STATUS
      TRB->TELEF        :=      SA1->A1_TEL   
      TRB->CONTATO      :=      SA1->A1_CONTATO
    MsUnLock()

    DbSelectArea("SA1")
    DbSkip()
EndDo

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Impressao do Relatorio                                                    *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

RptStatus({|| RunProc()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(RunProc)})
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

DbSelectArea("TRB")
cIndex := CriaTrab(Nil,.f.)
cChave := "TRB->VEND+TRB->CODIGO+TRB->LOJA" 

IndRegua("TRB",cIndex,cChave,,,"Indice Temporario")

SetRegua(LastRec())

@ nLin, 000 Psay AvalImp(Limite)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)

cVend  := TRB->VEND 
nCount := 0

DbGoTop()
While Eof() == .f.

    IncRegua()

    cNomeVend := Posicione("SA3",1,xFilial("SA1")+cVend,"A3_NOME")
    cData     := Dtoc(mv_par07)

    @ nLin, 000      Psay PADC("Inativos desde : "+cData,limite)
    nLin:= nLin + 1
    @ nLin, 000      Psay PADC("Vendedor : "+Alltrim(cVend)+" - "+Alltrim(cNomeVend),limite)
    nLin:= nLin + 2

    While TRB->VEND == cVend

        nCount := nCount + 1

        @ nLin, 000       Psay TRB->CODIGO
        @ nLin, Pcol()+1  Psay TRB->LOJA
        @ nLin, Pcol()+3  Psay TRB->NOME
        @ nLin, Pcol()+4  Psay TRB->TELEF
        @ nLin, Pcol()+1  Psay TRB->CONTATO
        @ nLin, Pcol()+1  Psay Dtoc(TRB->ULTCOM)
        @ nLin, Pcol()+5  Psay TRB->VALOR       Picture "@E 999,999,999.99"

        nLin := nLin + 1

        DbSelectArea("SA1")
        DbSetOrder(1)
        DbSeek(xFilial("SA1")+TRB->CODIGO+TRB->LOJA)

        //----> mudando o status do cliente para inativo
        RecLock("SA1",.f.)
          SA1->A1_STATUS    :=  "I"
          If mv_par08 == 1
              SA1->A1_VEND  :=  Space(6)
          EndIf
        MsUnLock()

        DbSelectArea("TRB")
        DbSkip()

        If nLin > 58
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
            nLin := 8
        EndIf
    EndDo

    @ nLin, 000       Psay Repli("-",limite)
    nLin := nLin + 1
    @ nLin, 000       Psay "Total de Clientes : "
    @ nLin, Pcol()+1  Psay nCount               Picture "@E 9999"

    cVend  := TRB->VEND
    nCount := 0

    If Eof() == .f.
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
        nLin := 8
    EndIf

EndDo

Roda(cbCont,"Inativos",tamanho)

Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

DbSelectArea("TRB")
DbCloseArea("TRB")

Ferase(_cTemp1+".dbf")

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

    aadd(aRegs,{cPerg,'01','Do Cliente     ? ','mv_ch1','C',06, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'02','Da Loja        ? ','mv_ch2','C',02, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','','   '})
    aadd(aRegs,{cPerg,'03','Ate o Cliente  ? ','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','','SA1'})
    aadd(aRegs,{cPerg,'04','Ate a Loja     ? ','mv_ch4','C',02, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','','   '})
    aadd(aRegs,{cPerg,'05','Do Vendedor    ? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'06','Ate o Vendedor ? ','mv_ch6','C',06, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','','SA3'})
    aadd(aRegs,{cPerg,'07','Inativo Desde  ? ','mv_ch7','D',08, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','','   '})
    aadd(aRegs,{cPerg,'08','Muda o Vendedor? ','mv_ch8','N',01, 0, 1,'C', '', 'mv_par08','Sim','','','Nao','','','','','','','','','','','   '})

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

