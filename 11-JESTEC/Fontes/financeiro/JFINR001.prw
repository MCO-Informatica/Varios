#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JFINR001   º Autor ³ Felipe Valenca     º Data ³  10-07-12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Contas a Pagar customizado.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function JFINR001


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
    Local cDesc2         := "de acordo com os parametros informados pelo usuario."
    Local cDesc3         := "Contas a Pagar"
    Local cPict          := ""
    Local titulo       := "Contas a Pagar"
    Local nLin         := 80

    Local Cabec1       := " Data          Contr.            Historico                                Credito           Debito              Saldo"
//          1         2         3         4         5         6         7         8         9         100       110       120       130
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//" Data          Contr.            Historico                                Credito          Debito          Saldo" 
    Local Cabec2       := ""
    Local imprime      := .T.
    Local aOrd := {}
    Private lEnd         := .F.
    Private lAbortPrint  := .F.
    Private CbTxt        := ""
    Private limite           := 132
    Private tamanho          := "M"
    Private nomeprog         := "JFINR001" // Coloque aqui o nome do programa para impressao no cabecalho
    Private nTipo            := 18
    Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
    Private nLastKey        := 0
    Private cPerg       := "JFINR001"
    Private cbtxt      := Space(10)
    Private cbcont     := 00
    Private CONTFL     := 01
    Private m_pag      := 01
    Private wnrel      := "JFINR001" // Coloque aqui o nome do arquivo usado para impressao em disco

    Private cString := "SE2"

    Private nSldIni := 0

    dbSelectArea("SE2")
    dbSetOrder(1)


    ValidPerg()

    If !pergunte(cPerg,.T.)
        Return
    Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

    If nLastKey == 27
        Return
    Endif

    SetDefault(aReturn,cString)

    If nLastKey == 27
        Return
    Endif

    nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
    ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
    ±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10-07-12   º±±
    ±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
    ±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
    ±±º          ³ monta a janela com a regua de processamento.               º±±
    ±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
    ±±ºUso       ³ Programa principal                                         º±±
    ±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

    Local nTotDeb	:= 0
    Local nTotCrd	:= 0
    Local nSaldo	:= 0

    cQuery := "Select E2_EMISSAO EMISSAO, E2_VENCTO VECNTO, E2_NUM, E2_SALDO, E2_VALOR, E2_HIST, E2_TIPO, E2_PREFIXO, E2_PARCELA, E2_FORNECE,E2_LOJA, E2_NATUREZ from SE2010 "
    cQuery += "Where D_E_L_E_T_ = '' And E2_EMISSAO BetWeen '"+DtoS(MV_PAR01)+"' And '"+DtoS(MV_PAR02)+"' "
    cQuery += "And E2_VENCTO BetWeen '"+DtoS(MV_PAR03)+"' And '"+DtoS(MV_PAR04)+"' And E2_TIPO IN ('VA','PA') "
    cQuery += "And E2_FORNECE BetWeen '"+MV_PAR05+"' And '"+MV_PAR06+"' "
    cQuery += "Order By E2_EMISSAO, E2_NUM "

    If Select("TRB") > 0
        dbSelectArea("TRB")
        dbCloseArea()
    Endif

    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
    TcSetField("TRB","EMISSAO","D")
    TcSetField("TRB","VENCTO","D")

    dbSelectArea("TRB")
    SetRegua(RecCount())
    dbGoTop()

    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    nLin := 8

    xSldIni()


    @nLin,0001 pSay "COLABORADOR :"+Posicione("SA2",1,xFilial("SA2")+TRB->E2_FORNECE+TRB->E2_LOJA,"A2_NOME")+"          SALDO INICIAL --->"
    @nLin,0104 pSay Transform(nSldIni, "@E 999,999,999.99")
    nLin++

    nSaldo	:=  nSldIni

    While !TRB->(EOF())

        If lAbortPrint
            @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
            Exit
        Endif

        If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
            Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
            nLin := 8
        Endif
        //nSaldo	:=SaldoTit(TRB->E2_PREFIXO,TRB->E2_NUM,TRB->E2_PARCELA,TRB->E2_TIPO,TRB->E2_NATUREZ,"P",TRB->E2_FORNECE,1,TRB->EMISSAO,,TRB->E2_LOJA )

        nSaldo	:=  Iif(TRB->E2_TIPO = 'PA ',nSaldo+TRB->E2_VALOR,nSaldo-TRB->E2_VALOR)
        @nLin,0001 pSay DtoC(TRB->EMISSAO)
        @nLin,Pcol()+004 pSay TRB->E2_NUM
        @nLin,Pcol()+009 pSay SUBSTR(TRB->E2_HIST,1,35)
        //@nLin,Pcol()+010 pSay Iif(TRB->E2_TIPO == 'PA ',Transform(TRB->E2_VALOR, "@E 999,999,999.99"),Space(12)) //Credito -- alteração Sergio Junior
        //@nLin,Pcol()+005 pSay Iif(TRB->E2_TIPO == 'VA ',Transform(TRB->E2_VALOR, "@E 999,999,999.99"),Space(12)) //Debito -- alteração Sergio Junior
        @nLin,068 pSay Iif(TRB->E2_TIPO == 'PA ',Transform(TRB->E2_VALOR, "@E 999,999,999.99"),Space(12)) //Credito
        @nLin,085 pSay Iif(TRB->E2_TIPO == 'VA ',Transform(TRB->E2_VALOR, "@E 999,999,999.99"),Space(12)) //Debito
        @nLin,105 pSay Transform(nSaldo, "@E 999,999,999.99")
        //@nLin,Pcol()+005 pSay Transform(nSaldo, "@E 999,999,999.99") -- alteração Sergio Junior



        If TRB->E2_TIPO $ 'PA '
//		Alert("Entrou")
            nTotCrd += TRB->E2_VALOR
//		Alert(nTotCrd)
        Else
//		Alest("Debito")
            nTotDeb += TRB->E2_VALOR
//		Alert(nTotDeb)
        Endif

        nLin := nLin + 1 // Avanca a linha de impressao
        TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo

    EndDo
    @nLin,00 Psay __PrtThinLine()
    nLin++
    @nLin,0000 	Psay "TOTAL DO MOVIMENTO:"
    @nLin,0051	pSay Transform(nSldIni, "@E 999,999,999.99")
    @nLin,pCol()+003 pSay Transform(nTotCrd, "@E 999,999,999.99")
    @nLin,pCol()+003 pSay Transform(nTotDeb, "@E 999,999,999.99")
    @nLin,pCol()+005 pSay Transform(nSldIni+nTotCrd-nTotDeb, "@E 999,999,999.99")


    nTotCrd := 0
    nTotDeb := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    If aReturn[5]==1
        dbCommitAll()
        SET PRINTER TO
        OurSpool(wnrel)
    Endif

    MS_FLUSH()

Return


    *---------------------------------*
Static Function ValidPerg()
    *---------------------------------*

    Local _sAlias := Alias()
    Local aRegs := {}
    Local i,j

    DBSelectArea("SX1") ; DBSetOrder(1)
    cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
    AADD(aRegs,{cperg,"01","Emissao de:"			,"","","mv_ch1","D", 8,0,0,"G","","mv_par01"})
    AADD(aRegs,{cperg,"02","Emissao ate:"			,"","","mv_ch2","D", 8,0,0,"G","","mv_par02"})
    AADD(aRegs,{cperg,"03","Vencimento de:"			,"","","mv_ch3","D", 8,0,0,"G","","mv_par03"})
    AADD(aRegs,{cperg,"04","Vencimento ate:"			,"","","mv_ch4","D", 8,0,0,"G","","mv_par04"})
    For i:=1 to Len(aRegs)
        If !dbSeek(cPerg+aRegs[i,2])

            RecLock("SX1",.T.)
            For j:=1 to FCount()
                If j <= Len(aRegs[i])
                    FieldPut(j,aRegs[i,j])
                EndIf
            Next
            MsUnlock()


        EndIf
    Next

    dBSelectArea(_sAlias)

Return

Static Function xSldIni

    nSldIni := 0

    cQry := "select E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_FORNECE, E2_EMISSAO EMISSAO,E2_LOJA,E2_VALOR from SE2010 where E2_TIPO IN ('PA','VA') AND D_E_L_E_T_ = '' "
    cQry += "And E2_EMISSAO < '"+DtoS(MV_PAR01)+"' "
    cQry += "And E2_VENCTO BetWeen '"+DtoS(MV_PAR03)+"' And '"+DtoS(MV_PAR04)+"' "
    cQry += "And E2_FORNECE BetWeen '"+MV_PAR05+"' And '"+MV_PAR06+"' "
    cQry += "Order By E2_EMISSAO, E2_NUM "

    If Select("TRB2") > 0
        dbSelectArea("TRB2")
        dbCloseArea()
    Endif

    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'TRB2', .F., .T.)
    TcSetField("TRB2","EMISSAO","D")

    Do While !TRB2->(Eof())

        nSldIni := Iif(TRB2->E2_TIPO = 'PA ',nSldIni+TRB2->E2_VALOR,nSldIni-TRB2->E2_VALOR)
        TRB2->(dbSkip())
    EndDo

Return