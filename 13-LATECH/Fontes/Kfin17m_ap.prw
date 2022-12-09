#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfin17m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,NTOTJUR,NCOUNT,_CNUMDEB,_CCLIAUX,_NRECSE1")
SetPrvt("AREGS,I,J,_NVALOR,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFIN17M  ³ Autor ³Ricardo Correa de Souza³ Data ³01/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gravacao da Nota de Debito                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo Correa³22/02/01³Modificacao da Chave de Indice e Gravacao do Z6³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

DbSelectArea("SA1")             //----> Cadastro de Clientes
DbSetOrder(1)                   //----> Codigo + Loja

DbSelectArea("SZ6")             //----> Cadastro de Notas de Debito
DbSetOrder(1)                   //----> Nota Debito + Titulo Origem

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Variaveis Utilizadas para Parametros                                      *
*                                                                           *
* mv_par01  ----> Valor a Considerar ? (Calculado/Informado)                *
* mv_par02  ----> Taxa Juros Dia     ?                                      *               
* mv_par03  ----> Taxa Bancaria      ?                                      *               
* mv_par04  ----> Quantos Dias Vencto?                                      *               
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

cPerg:= "FIN17M    "

ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

If ! Pergunte(cPerg,.t.)
    Return
EndIf

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Filtrando Dados ...")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Filtrando Dados ...")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

nTotJur  := 0
nCount   := 0

DbSelectArea("SE1")
DbSetOrder(2)
DbGoTop()

ProcRegua(LastRec())
While Eof() == .f.
    IncProc("Selecionando Dados:  "+SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA)

    If !Marked("E1_OKD")
        DbSkip()
        Loop
    EndIf

    _cNumDeb := GetSx8Num("NDB")
    confirmSx8()

    If nCount == 0
        _cCliAux := SE1->E1_CLIENTE+SE1->E1_LOJA
        nCount := 1
    EndIf

    While SE1->E1_CLIENTE+SE1->E1_LOJA == _cCliAux 
        If Empty(SE1->E1_OKD)
            DbSelectArea("SE1")
            DbSkip()
            Loop
        EndIf

        DbSelectArea("SZ6")
        RecLock("SZ6",.t.)
          SZ6->Z6_FILIAL       := xFilial("SZ6")
          SZ6->Z6_NOTADEB      := _cNumDeb
          SZ6->Z6_CLIENTE      := SE1->E1_CLIENTE
          SZ6->Z6_LOJA         := SE1->E1_LOJA
          SZ6->Z6_PREFIXO      := SE1->E1_PREFIXO
          SZ6->Z6_NUMERO       := SE1->E1_NUM
          SZ6->Z6_PARCELA      := SE1->E1_PARCELA
          SZ6->Z6_VALOR        := SE1->E1_VALOR
          SZ6->Z6_VENCTO       := SE1->E1_VENCTO
          SZ6->Z6_BAIXA        := SE1->E1_BAIXA
          SZ6->Z6_DIAS         := SE1->E1_BAIXA - SE1->E1_VENCTO
          If MV_PAR01 == 1
              SZ6->Z6_JUROS    := Round((SZ6->Z6_VALOR * (SZ6->Z6_DIAS * mv_par02)),2)
              SZ6->Z6_TAXA     := mv_par03
          Else
              MontaJur()    //----> tela de entrada de juros
              SZ6->Z6_JUROS := _nValor
              SZ6->Z6_TAXA         := 0
          EndIf
        MsUnLock()

        _cCliAux := SE1->E1_CLIENTE+SE1->E1_LOJA
        
		RecLock("SE1",.F.)
		SE1->E1_X_ND	:=	"S"
		MsUnLock()             
		
        DbSelectArea("SE1")
        DbSkip()
    EndDo

    DbSelectArea("SE1")
    _nRecSe1 := Recno()

    RecLock("SE1",.t.)
      SE1->E1_FILIAL    := xFilial("SE1")
      SE1->E1_PREFIXO   := "UNI"
      SE1->E1_NUM       := SZ6->Z6_NOTADEB
      SE1->E1_PARCELA   := ""
      SE1->E1_NATUREZ   := "0005"
      SE1->E1_TIPO      := "NDC"
      SE1->E1_EMISSAO   := dDataBase
      SE1->E1_VENCTO    := dDataBase + mv_par04
      SE1->E1_VENCREA   := DataValida(SE1->E1_VENCTO)
      SE1->E1_CLIENTE   := SZ6->Z6_CLIENTE
      SE1->E1_LOJA      := SZ6->Z6_LOJA
      SE1->E1_NOMCLI    := Posicione("SA1",1,xFilial("SA1")+SZ6->Z6_CLIENTE+SZ6->Z6_LOJA,"A1_NREDUZ")
      SE1->E1_EMIS1     := dDataBase
      SE1->E1_MOEDA     := 1
      SE1->E1_SITUACA   := "0"
      SE1->E1_STATUS    := "A"
      SE1->E1_FLUXO     := "S"
      SE1->E1_VEND1     := Posicione("SA1",1,xFilial("SA1")+SZ6->Z6_CLIENTE+SZ6->Z6_LOJA,"A1_VEND")

      DbSelectArea("SZ6")
      DbSeek(xFilial("SZ6")+SE1->E1_NUM)
      While SZ6->Z6_NOTADEB == SE1->E1_NUM

          nTotJur := nTotJur + SZ6->Z6_JUROS + SZ6->Z6_TAXA
          DbSkip()
      EndDo

      SE1->E1_VALOR     := nTotJur
      SE1->E1_VLCRUZ    := nTotJur
      SE1->E1_SALDO     := nTotJur

      nTotJur := 0
    MsUnLock()
    
    DbSelectArea("SE1")
    DbGoTo(_nRecSe1)
    DbSkip()
    nCount := 0
EndDo

MsgBox("Nota de débito gerada com o número UNI"+_cNumDeb+"","Nota de Débito","Info")

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(.t.)
Return(.t.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

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

    aadd(aRegs,{cPerg,'01','Vlr  Considerar?  ','mv_ch1','N',01, 0, 2,'C', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Taxa Juros Dia ?  ','mv_ch2','N',06, 4, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'03','Taxa Bancaria  ?  ','mv_ch3','N',06, 2, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'04','Quantos Dias Vcto?','mv_ch4','N',03, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})

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

Return(.t.)



Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function MontaJur
Static Function MontaJur()

_nValor := 0

@ 96,042 TO 333,510 DIALOG oDlg1 TITLE "Valor Juros Nota de Debito"
@ 08,010 TO 093,222
@ 95,196 BMPBUTTON TYPE 1 ACTION Close(oDlg1)
@ 40,014 SAY SZ6->Z6_PREFIXO+" "+SZ6->Z6_NUMERO+" "+SZ6->Z6_PARCELA
@ 60,014 SAY "Digite o Valor do Juros : "
@ 60,100 GET _nValor Picture "@E 999,999,999.99"
@ 99,044 SAY "***  Kenia Industrias Texteis Ltda ***"
ACTIVATE DIALOG oDlg1 Center

Return(.t.)

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

