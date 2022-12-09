#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Kfat06r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NTOTQTD,NTOTVAL,APREFIXO,ANUM,APARCELA,AVENCTO")
SetPrvt("ASALDO,ACHAVE,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,CNOTA,CABEC1,CABEC2,NPOS,I")
SetPrvt("AREGS,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFAT06R  ³ Autor ³Ricardo Correa de Souza³ Data ³18/10/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relacao de Devolucoes de Vendas                            ³±±
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
* Variaveis Utilizadas no Processamento                                     *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

nTotQtd   := 0          //----> armazena a quantidade total devolvida
nTotVal   := 0          //----> armazena o valor total devolvido
aPrefixo  := {}
aNum      := {}
aParcela  := {}
aVencto   := {}
aSaldo    := {}
aChave    := {}

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SA1")         //----> Cadastro de Clientes
DbSetOrder(1)               //----> Codigo + Loja

DbSelectArea("SB1")         //----> Cadastro de Produtos
DbSetOrder(1)               //----> Codigo

DbSelectArea("SD1")         //----> Itens de Nota de Entrada
DbSetOrder(6)               //----> Data de Digitacao

DbSelectArea("SD2")         //----> Itens de Nota de Entrada
DbSetOrder(3)               //----> Nota + Serie + Cliente + Loja

DbSelectArea("SF1")         //----> Cabecalho de Nota de Entrada
DbSetOrder(1)               //----> Nota + Serie + Fornecedor + Loja

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas no Relatorio                                         *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

wnrel     := "KFAT06R"
cDesc1    := "Este relatorio ira emitir a listagem das Devolucoes de Vendas"
cDesc2    := "conforme parametros definidos pelo usuario."
cDesc3    := " "
cString   := "SD1"
lEnd      := .F.
tamanho   := "G"
limite    := 220
titulo    := "Relacao das Devolucoes de Vendas"
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog  := "KFAT06R"
nLastKey  := 0
aDriver   := ReadDriver()
cbCont    := 00
cPerg     := "FAT06R    "
nLin      := 8
m_pag     := 1
cNota     := Space(6)
cabec1    := "NOTA    SERIE  PRODUTO         DESCRICAO                      QUANTIDADE   PRC UNIT        VALOR   CODIGO/LJ CLIENTE      DT DEVOL  NF ORI SERIE OBSERVACOES                                                  "
cabec2    := ""
//regua1    0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//regua2              10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       200       210       220

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Digitacao de   ?                                          *
* mv_par02  ----> Digitacao Ate  ?                                          *
* mv_par03  ----> Do Cliente     ?                                          *
* mv_par04  ----> Ate o Cliente  ?                                          *
* mv_par05  ----> Da Loja        ?                                          *
* mv_par06  ----> Ate a Loja     ?                                          *
* mv_par07  ----> Do Cliente     ?                                          *
* mv_par08  ----> Do Cfop        ?                                          *
* mv_par09  ----> Ate o Cfop     ?                                          *
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

#IFDEF WINDOWS
    RptStatus({|| Imprime()},titulo)// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     RptStatus({|| Execute(Imprime)},titulo)
#ELSE
    Imprime()
#ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

DbSelectArea("SD1")
DbSeek(xFilial("SD1")+Dtos(mv_par01),.t.)

SetRegua(Lastrec())

@ 00,00 Psay AvalImp(limite)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

Do While !Eof() .And. SD1->D1_DTDIGIT <= mv_par02
    
    IncRegua()

    //----> filtrando somente notas referente a devolucao de vendas
    If SD1->D1_TIPO #"D"
	DbSkip()
	Loop
    EndIf

    //----> filtrando intervalo de clientes definido nos parametros
    If SD1->D1_FORNECE+SD1->D1_LOJA < mv_par03+mv_par05 .Or. SD1->D1_FORNECE+SD1->D1_LOJA >mv_par04+mv_par06
	DbSkip()
	Loop
    EndIf

    //----> filtrando intervalo de cfop definido nos parametros
    If SD1->D1_CF < mv_par07 .Or. SD1->D1_CF > mv_par08
	DbSkip()
	Loop
    EndIf

    cNota := SD1->D1_DOC
    
    DbSelectArea("SF1")
    DbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE)

    DbSelectArea("SB1")
    DbSeek(xFilial("SB1")+SD1->D1_COD)
    
    DbSelectArea("SA1")
    DbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA)
    
    While SD1->D1_DOC == cNota
	
	DbSelectArea("SE1") 
	If DbSeek(xFilial("SE1")+SD1->D1_SERIORI+SD1->D1_NFORI)
	    While SE1->E1_PREFIXO+SE1->E1_NUM == SD1->D1_SERIORI+SD1->D1_NFORI
		 
		nPos := Ascan(aChave,SE1->E1_NUM+SE1->E1_PARCELA)

		If nPos <> 0
		Else
		    Aadd(aChave  ,SE1->E1_NUM+SE1->E1_PARCELA)
		    Aadd(aPrefixo,SE1->E1_PREFIXO)
		    Aadd(aNum    ,SE1->E1_NUM    )
		    Aadd(aParcela,SE1->E1_PARCELA)
		    Aadd(aVencto ,SE1->E1_VENCTO )
		    Aadd(aSaldo  ,SE1->E1_SALDO  ) 
		EndIf

		DbSelectArea("SE1")
		DbSkip()
	    EndDo
	EndIf

    DbSelectArea("SD2")
    DbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD)

    @ nLin, 000      Psay SD1->D1_DOC
	@ nLin, Pcol()+2 Psay SD1->D1_SERIE
	@ nLin, Pcol()+4 Psay SD1->D1_COD        
    @ nLin, Pcol()+1 Psay Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"Subs(SB1->B1_DESC,1,30)")    
    @ nLin, Pcol()+1 Psay SD1->D1_QUANT                    Picture "@E 999,999.99"
    @ nLin, Pcol()+1 Psay SD2->D2_PRCVEN                   Picture "@E 999,999.99"
    @ nLin, Pcol()+3 Psay (SD1->D1_QUANT*SD2->D2_PRCVEN)   Picture "@E 999,999.99"
	@ nLin, Pcol()+3 Psay SD1->D1_FORNECE
	@ nLin, Pcol()+1 Psay SD1->D1_LOJA
    @ nLin, Pcol()+1 Psay Posicione("SA1",1,xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA,"Subs(SA1->A1_NREDUZ,1,10)")
	@ nLin, Pcol()+3 Psay SD1->D1_DTDIGIT
	@ nLin, Pcol()+2 Psay SD1->D1_NFORI
	@ nLin, Pcol()+1 Psay SD1->D1_SERIORI        
	@ nLin, Pcol()+4 Psay SF1->F1_OBSDEV1+" "+SF1->F1_OBSDEV2

	nLin := nLin + 1

	nTotQtd := nTotQtd + SD1->D1_QUANT
    nTotVal := nTotVal + (SD1->D1_QUANT * SD2->D2_PRCVEN)
	cNota   := SD1->D1_DOC

	DbSelectArea("SD1")
	DbSkip()
	
	If nLin > 59
	    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	    nLin := 8
	Endif
    EndDo
    
    @ nLin, 000 Psay Repli("-",Limite)

    nLin := nLin + 1

    @ nLin, 000 Psay "Total da Nota "+cNota+" ---->"
    @ nLin, Pcol()+32 Psay nTotQtd Picture "@E 999,999,999.99"
    @ nLin, Pcol()+10 Psay nTotVal Picture "@E 999,999,999.99"
    
    nTotQtd := 0
    nTotVal := 0
    
    nLin := nLin + 2
    
    @ nLin, 000 Psay Padc("DUPLICATAS DA NOTA FISCAL DE SAIDA",220)
      
    nLin := nLin + 1
    
    @ nLin, 000       Psay "PRF"      
    @ nLin, Pcol()+02 Psay "NUMERO"
    @ nLin, Pcol()+02 Psay "P"        
    @ nLin, Pcol()+02 Psay "VENCTO"  
    @ nLin, Pcol()+13 Psay "SALDO"  
    
    For i := 1 to Len(aNum)
	
	nLin := nLin + 1
    
	@ nLin, 000      Psay aPrefixo[i]
	@ nLin, Pcol()+2 Psay aNum[i]
	@ nLin, Pcol()+2 Psay aParcela[i]
	@ nLin, Pcol()+2 Psay aVencto[i]
	@ nLin, Pcol()+2 Psay aSaldo[i]     Picture "@E 999,999,999.99"
      
	If nLin > 59
	    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	    nLin := 8
	Endif
    Next
    
    aPrefixo  := {}
    aNum      := {}
    aParcela  := {}
    aVencto   := {}
    aSaldo    := {}
    
    nLin := nLin + 1
    
    @ nLin, 000 Psay Repli("-",Limite)

    nLin := nLin + 1
    
    If nLin > 59
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	nLin := 8
    Endif
    
    DbSelectArea("SD1")
EndDo

Roda(cbCont,"Devolucao",tamanho)

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

    aadd(aRegs,{cPerg,'01','Digitacao De   ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Digitacao Ate  ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Do Cliente     ? ','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Ate o Cliente  ? ','mv_ch4','C',06, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'05','Da Loja        ? ','mv_ch5','C',02, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'06','Ate a Loja     ? ','mv_ch6','C',02, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'07','Do Cfop        ? ','mv_ch7','C',04, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'08','Ate o Cfop     ? ','mv_ch8','C',04, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})

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
* Retorna para sua Chamada (KFAT06R)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

