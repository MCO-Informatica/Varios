#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Ajustefi()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CPERG,AREGS,I,J,")

Processa({||RunPRoc()},"Ajustando Filial")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunPRoc)},"Ajustando Filial")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()

* mv_par01    ----> Da Emissao
* mv_par02    ----> Ate a Emissao

cPerg := "AJUFIL"

ValidPerg()

Pergunte(cPerg,.t.)

DbUseArea( .T. ,"TOPCONN" , "SF2030" , "NSF2", .T., .F. )  // Abre arquivo Kenia - Matriz empresa 03
DbUseArea( .T. ,"TOPCONN" , "SD2030" , "NSD2", .T., .F. )  // Abre arquivo Kenia - Filial empresa 03
DbUseArea( .T. ,"TOPCONN" , "SE1030" , "NSE1", .T., .F. )  // Abre arquivo Kenia - Matriz empresa 03
DbUseArea( .T. ,"TOPCONN" , "SE3030" , "NSE3", .T., .F. )  // Abre arquivo Kenia - Filial empresa 03

DbSelectArea("SF2")
DbSetOrder(5)
DbSeek(xFilial("SF2")+Dtos(mv_par01),.t.)

ProcRegua(LastRec())
While Eof() == .f. .And. Dtos(SF2->F2_EMISSAO) <= Dtos(mv_par02)

    IncProc("Processando Dados Nota Fiscal "+SF2->F2_DOC+"-"+SF2->F2_SERIE)

    DbSelectArea("SD2")
    DbSetOrder(3)
    If !DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
        DbSelectArea("SF2")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SE1")
    DbSetOrder(1)
    If !DbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC)
        DbSelectArea("SF2")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SE3")
    DbSetOrder(1)
    If !DbSeek(xFilial("SE3")+SE1->E1_PREFIXO+SE1->E1_NUM)
        DbSelectArea("SF2")
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SC5")
    DbSetOrder(1)
    If !DbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
        DbSelectArea("SF2")
        DbSkip()
        Loop
    EndIf

    If SC5->C5_PAPELET == "O"
        DbSelectArea("NSF2")
        DbSetOrder(1)
        If !DbSeek( xFilial("NSF2") + SF2->F2_DOC + SF2->F2_SERIE )
            RecLock("NSF2", .t. )
                NSF2->F2_FILIAL  := SF2->F2_FILIAL 
                NSF2->F2_DOC     := SF2->F2_DOC
                NSF2->F2_SERIE   := SF2->F2_SERIE
                NSF2->F2_CLIENTE := SF2->F2_CLIENTE
                NSF2->F2_LOJA    := SF2->F2_LOJA
                NSF2->F2_COND    := SF2->F2_COND
                NSF2->F2_DUPL    := SF2->F2_DUPL
                NSF2->F2_EMISSAO := SF2->F2_EMISSAO
                NSF2->F2_EST     := SF2->F2_EST
                NSF2->F2_FRETE   := SF2->F2_FRETE
                NSF2->F2_SEGURO  := SF2->F2_SEGURO
                NSF2->F2_ICMFRET := SF2->F2_ICMFRET
                NSF2->F2_TIPOCLI := SF2->F2_TIPOCLI
                NSF2->F2_VALBRUT := SF2->F2_VALBRUT
                NSF2->F2_VALICM  := SF2->F2_VALICM
                NSF2->F2_BASEICM := SF2->F2_BASEICM
                NSF2->F2_VALIPI  := SF2->F2_VALIPI
                NSF2->F2_BASEIPI := SF2->F2_BASEIPI
                NSF2->F2_VALMERC := SF2->F2_VALMERC
                NSF2->F2_NFORI   := SF2->F2_NFORI
                NSF2->F2_DESCONT := SF2->F2_DESCONT
                NSF2->F2_SERIORI := SF2->F2_SERIORI
                NSF2->F2_TIPO    := SF2->F2_TIPO 
                NSF2->F2_ESPECI1 := SF2->F2_ESPECI1
                NSF2->F2_ESPECI2 := SF2->F2_ESPECI2
                NSF2->F2_ESPECI3 := SF2->F2_ESPECI3
                NSF2->F2_ESPECI4 := SF2->F2_ESPECI4
                NSF2->F2_VOLUME1 := SF2->F2_VOLUME1
                NSF2->F2_VOLUME2 := SF2->F2_VOLUME2
                NSF2->F2_VOLUME3 := SF2->F2_VOLUME3
                NSF2->F2_VOLUME4 := SF2->F2_VOLUME4
                NSF2->F2_ICMSRET := SF2->F2_ICMSRET
                NSF2->F2_PLIQUI  := SF2->F2_PLIQUI
                NSF2->F2_PBRUTO  := SF2->F2_PBRUTO
                NSF2->F2_TRANSP  := SF2->F2_TRANSP
                NSF2->F2_REDESP  := SF2->F2_REDESP
                NSF2->F2_VEND1   := SF2->F2_VEND1
                NSF2->F2_VEND2   := SF2->F2_VEND2
                NSF2->F2_VEND3   := SF2->F2_VEND3
                NSF2->F2_VEND4   := SF2->F2_VEND4
                NSF2->F2_VEND5   := SF2->F2_VEND5
                NSF2->F2_OK      := SF2->F2_OK
                NSF2->F2_FIMP    := SF2->F2_FIMP
                NSF2->F2_DTLANC  := SF2->F2_DTLANC
                NSF2->F2_DTREAJ  := SF2->F2_DTREAJ
                NSF2->F2_REAJUST := SF2->F2_REAJUST
                NSF2->F2_DTBASE0 := SF2->F2_DTBASE0
                NSF2->F2_FATORB0 := SF2->F2_FATORB0
                NSF2->F2_DTBASE1 := SF2->F2_DTBASE1
                NSF2->F2_FATORB1 := SF2->F2_FATORB0
                NSF2->F2_VARIAC  := SF2->F2_VARIAC
                NSF2->F2_BASEISS := SF2->F2_BASEISS
                NSF2->F2_VALISS  := SF2->F2_VALISS
                NSF2->F2_VALFAT  := SF2->F2_VALFAT
                NSF2->F2_CONTSOC := SF2->F2_CONTSOC
                NSF2->F2_BRICMS  := SF2->F2_BRICMS
                NSF2->F2_FRETAUT := SF2->F2_FRETAUT
                NSF2->F2_ICMAUTO := SF2->F2_ICMAUTO
                NSF2->F2_DESPESA := SF2->F2_DESPESA
                NSF2->F2_NEXTDOC := SF2->F2_NEXTDOC
                NSF2->F2_ESPECIE := SF2->F2_ESPECIE
                NSF2->F2_PDV     := SF2->F2_PDV
                NSF2->F2_MAPA    := SF2->F2_MAPA
                NSF2->F2_ECF     := SF2->F2_ECF
                NSF2->F2_FLSERV  := SF2->F2_FLSERV
                NSF2->F2_PREFIXO := SF2->F2_PREFIXO
                NSF2->F2_BASIMP1 := SF2->F2_BASIMP1
                NSF2->F2_BASIMP2 := SF2->F2_BASIMP2
                NSF2->F2_BASIMP3 := SF2->F2_BASIMP3
                NSF2->F2_BASIMP4 := SF2->F2_BASIMP4
                NSF2->F2_BASIMP5 := SF2->F2_BASIMP5
                NSF2->F2_BASIMP6 := SF2->F2_BASIMP6
                NSF2->F2_VALIMP1 := SF2->F2_VALIMP1
                NSF2->F2_VALIMP2 := SF2->F2_VALIMP2
                NSF2->F2_VALIMP3 := SF2->F2_VALIMP3
                NSF2->F2_VALIMP4 := SF2->F2_VALIMP4
                NSF2->F2_VALIMP5 := SF2->F2_VALIMP5
                NSF2->F2_VALIMP6 := SF2->F2_VALIMP6
                NSF2->F2_ORDPAGO := SF2->F2_ORDPAGO
                NSF2->F2_NFCUPOM := SF2->F2_NFCUPOM
                NSF2->F2_VALINSS := SF2->F2_VALINSS
                NSF2->F2_HORA    := SF2->F2_HORA
            MsUnLock()
        EndIf

        DbSelectArea("SD2")
        While SD2->D2_FILIAL == xFilial("SD2") .and. ;
              SD2->D2_DOC == SF2->F2_DOC .and. ;
              SD2->D2_SERIE == SF2->F2_SERIE

            DbSelectArea("NSD2")
            DbSetOrder(3)
            If !DbSeek( xFilial("NSD2") + SF2->F2_DOC + SF2->F2_SERIE )
                RecLock("NSD2" , .t. )
                    NSD2->D2_FILIAL := SD2->D2_FILIAL 
                    NSD2->D2_COD    := SD2->D2_COD
                    NSD2->D2_UM     := SD2->D2_UM
                    NSD2->D2_SEGUM  := SD2->D2_SEGUM
                    NSD2->D2_QUANT  := SD2->D2_QUANT
                    NSD2->D2_PRCVEN := SD2->D2_PRCVEN
                    NSD2->D2_TOTAL  := SD2->D2_TOTAL
                    NSD2->D2_VALIPI := SD2->D2_VALIPI
                    NSD2->D2_VALICM := SD2->D2_VALICM
                    NSD2->D2_TES    := SD2->D2_TES
                    NSD2->D2_CF     := SD2->D2_CF
                    NSD2->D2_DESC   := SD2->D2_DESC
                    NSD2->D2_IPI    := SD2->D2_IPI
                    NSD2->D2_PICM   := SD2->D2_PICM
                    NSD2->D2_PESO   := SD2->D2_PESO
                    NSD2->D2_CONTA  := SD2->D2_CONTA
                    NSD2->D2_OP     := SD2->D2_OP
                    NSD2->D2_PEDIDO := SD2->D2_PEDIDO
                    NSD2->D2_ITEMPV := SD2->D2_ITEMPV
                    NSD2->D2_CLIENTE := SD2->D2_CLIENTE
                    NSD2->D2_LOJA    := SD2->D2_LOJA
                    NSD2->D2_LOCAL   := SD2->D2_LOCAL
                    NSD2->D2_DOC     := SD2->D2_DOC
                    NSD2->D2_EMISSAO := SD2->D2_EMISSAO
                    NSD2->D2_GRUPO   := SD2->D2_GRUPO
                    NSD2->D2_TP      := SD2->D2_TP
                    NSD2->D2_SERIE   := SD2->D2_SERIE
                    NSD2->D2_CUSTO1  := SD2->D2_CUSTO1
                    NSD2->D2_CUSTO2  := SD2->D2_CUSTO2
                    NSD2->D2_CUSTO3  := SD2->D2_CUSTO3
                    NSD2->D2_CUSTO4  := SD2->D2_CUSTO4
                    NSD2->D2_CUSTO5  := SD2->D2_CUSTO5
                    NSD2->D2_PRUNIT  := SD2->D2_PRUNIT
                    NSD2->D2_QTSEGUM := SD2->D2_QTSEGUM
                    NSD2->D2_NUMSEQ  := SD2->D2_NUMSEQ
                    NSD2->D2_EST     := SD2->D2_EST
                    NSD2->D2_DESCON  := SD2->D2_DESCON
                    NSD2->D2_TIPO    := SD2->D2_TIPO
                    NSD2->D2_NFORI   := SD2->D2_NFORI
                    NSD2->D2_SERIORI := SD2->D2_SERIORI
                    NSD2->D2_QTDEDEV := SD2->D2_QTDEDEV
                    NSD2->D2_VALDEV  := SD2->D2_VALDEV
                    NSD2->D2_ORIGLAN := SD2->D2_ORIGLAN
                    NSD2->D2_NUMLOTE := SD2->D2_NUMLOTE
                    NSD2->D2_BASEORI := SD2->D2_BASEORI
                    NSD2->D2_BASEICM := SD2->D2_BASEICM
                    NSD2->D2_VALACRS := SD2->D2_VALACRS
                    NSD2->D2_IDENTB6 := SD2->D2_IDENTB6
                    NSD2->D2_ITEM    := SD2->D2_ITEM
                    NSD2->D2_CODISS  := SD2->D2_CODISS
                    NSD2->D2_GRADE   := SD2->D2_GRADE
                    NSD2->D2_SEQCALC := SD2->D2_SEQCALC
                    NSD2->D2_ICMSRET := SD2->D2_ICMSRET
                    NSD2->D2_BRICMS  := SD2->D2_BRICMS
                    NSD2->D2_COMIS1  := SD2->D2_COMIS1
                    NSD2->D2_COMIS2  := SD2->D2_COMIS2
                    NSD2->D2_COMIS3  := SD2->D2_COMIS3
                    NSD2->D2_COMIS4  := SD2->D2_COMIS4
                    NSD2->D2_COMIS5  := SD2->D2_COMIS5
                    NSD2->D2_LOTECTL := SD2->D2_LOTECTL
                    NSD2->D2_DTVALID := SD2->D2_DTVALID
                    NSD2->D2_DESCZFR := SD2->D2_DESCZFR
                    NSD2->D2_PDV     := SD2->D2_PDV
                    NSD2->D2_NUMSERI := SD2->D2_NUMSERI
                    NSD2->D2_DTLCTCT := SD2->D2_DTLCTCT
                    NSD2->D2_CUSFF1  := SD2->D2_CUSFF1
                    NSD2->D2_CUSFF2  := SD2->D2_CUSFF2
                    NSD2->D2_CUSFF3  := SD2->D2_CUSFF3
                    NSD2->D2_CUSFF4  := SD2->D2_CUSFF4
                    NSD2->D2_CUSFF5  := SD2->D2_CUSFF5
                    NSD2->D2_CLASFIS := SD2->D2_CLASFIS
                    NSD2->D2_FLSERV  := SD2->D2_FLSERV
                    NSD2->D2_BASIMP1 := SD2->D2_BASIMP1
                    NSD2->D2_BASIMP2 := SD2->D2_BASIMP2
                    NSD2->D2_BASIMP3 := SD2->D2_BASIMP3
                    NSD2->D2_BASIMP4 := SD2->D2_BASIMP4
                    NSD2->D2_BASIMP5 := SD2->D2_BASIMP5
                    NSD2->D2_BASIMP6 := SD2->D2_BASIMP6
                    NSD2->D2_VALIMP1 := SD2->D2_VALIMP1
                    NSD2->D2_VALIMP2 := SD2->D2_VALIMP2
                    NSD2->D2_VALIMP3 := SD2->D2_VALIMP3
                    NSD2->D2_VALIMP4 := SD2->D2_VALIMP4
                    NSD2->D2_VALIMP5 := SD2->D2_VALIMP5
                    NSD2->D2_VALIMP6 := SD2->D2_VALIMP6
                    NSD2->D2_ITEMORI := SD2->D2_ITEMORI
                    NSD2->D2_CODFAB  := SD2->D2_CODFAB
                    NSD2->D2_LOJAFA  := SD2->D2_LOJAFA
                MsUnLock()
            EndIf

            DbSelectArea("SD2")
            DbSkip()
        EndDo

        DbSelectArea("SE1")
        While SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM ==  xFilial("SE1") + SF2->F2_SERIE + SF2->F2_DOC .AND. !Eof()
    
            DbSelectArea("NSE1")  
            DbSetOrder(1)
            If !DbSeek(xFilial("NSE1")+SE1->E1_PREFIXO+SE1->E1_NUM)
                RecLock("NSE1", .t. )
                    NSE1->E1_FILIAL  := SE1->E1_FILIAL
                    NSE1->E1_PREFIXO := SE1->E1_PREFIXO
                    NSE1->E1_NUM     := SE1->E1_NUM
                    NSE1->E1_PARCELA := SE1->E1_PARCELA
                    NSE1->E1_TIPO    := SE1->E1_TIPO
                    NSE1->E1_NATUREZ := SE1->E1_NATUREZ
                    NSE1->E1_PORTADO := SE1->E1_PORTADO
                    NSE1->E1_CLIENTE := SE1->E1_CLIENTE
                    NSE1->E1_LOJA    := SE1->E1_LOJA
                    NSE1->E1_NOMCLI  := SE1->E1_NOMCLI
                    NSE1->E1_EMISSAO := SE1->E1_EMISSAO
                    NSE1->E1_VENCTO  := SE1->E1_VENCTO
                    NSE1->E1_VENCREA := SE1->E1_VENCREA
                    NSE1->E1_VALOR   := SE1->E1_VALOR
                    NSE1->E1_IRRF    := SE1->E1_IRRF
                    NSE1->E1_ISS     := SE1->E1_ISS
                    NSE1->E1_BAIXA   := SE1->E1_BAIXA
                    NSE1->E1_HIST    := SE1->E1_HIST
                    NSE1->E1_SITUACA := SE1->E1_SITUACA
                    NSE1->E1_SALDO   := SE1->E1_SALDO
                    NSE1->E1_SUPERVI := SE1->E1_SUPERVI
                    NSE1->E1_VEND1   := SE1->E1_VEND1
                    NSE1->E1_VEND2   := SE1->E1_VEND2
                    NSE1->E1_VEND3   := SE1->E1_VEND3
                    NSE1->E1_VEND4   := SE1->E1_VEND4
                    NSE1->E1_VEND5   := SE1->E1_VEND5
                    NSE1->E1_COMIS1  := SE1->E1_COMIS1
                    NSE1->E1_COMIS2  := SE1->E1_COMIS2
                    NSE1->E1_COMIS3  := SE1->E1_COMIS3
                    NSE1->E1_COMIS4  := SE1->E1_COMIS4
                    NSE1->E1_COMIS5  := SE1->E1_COMIS5
                    NSE1->E1_DESCONT := SE1->E1_DESCONT
                    NSE1->E1_MULTA   := SE1->E1_MULTA
                    NSE1->E1_JUROS   := SE1->E1_JUROS
                    NSE1->E1_VALLIQ  := SE1->E1_VALLIQ
                    NSE1->E1_VLCRUZ  := SE1->E1_VLCRUZ
                    NSE1->E1_MOEDA   := SE1->E1_MOEDA
                    NSE1->E1_BASCOM1 := SE1->E1_BASCOM1
                    NSE1->E1_BASCOM2 := SE1->E1_BASCOM2
                    NSE1->E1_BASCOM3 := SE1->E1_BASCOM3
                    NSE1->E1_BASCOM4 := SE1->E1_BASCOM4
                    NSE1->E1_BASCOM5 := SE1->E1_BASCOM5
                    NSE1->E1_FATURA  := SE1->E1_FATURA
                    NSE1->E1_OK      := SE1->E1_OK
                    NSE1->E1_VALCOM1 := SE1->E1_VALCOM1
                    NSE1->E1_VALCOM2 := SE1->E1_VALCOM2
                    NSE1->E1_VALCOM3 := SE1->E1_VALCOM3
                    NSE1->E1_VALCOM4 := SE1->E1_VALCOM4
                    NSE1->E1_VALCOM5 := SE1->E1_VALCOM5
                    NSE1->E1_PEDIDO  := SE1->E1_PEDIDO
                    NSE1->E1_STATUS  := SE1->E1_STATUS
//                    NSE1->E1_ORIGEM  := SE1->E1_ORIGEM
//                    NSE1->E1_DESCFIN := SE1->E1_DESCFIN
                    NSE1->E1_DIADESC := SE1->E1_DIADESC
                MsUnLock()
            EndIf

            DbSelectArea("SE1")
            DbSkip()
        EndDo

     DbSelectArea("SE3")  
     While SE3->E3_FILIAL == xFilial("SE3") .and. ;
           SE3->E3_PREFIXO == SF2->F2_SERIE .AND. ;
           SE3->E3_NUM == SF2->F2_DOC .and. !Eof()
	     
        DbSelectArea("NSE3")
        DbSetOrder(1)
        If !DbSeek(xFilial("NSE3")+SE3->E3_PREFIXO+SE3->E3_NUM)
            RecLock("NSE3", .t.)
                NSE3->E3_FILIAL  := SE3->E3_FILIAL
                NSE3->E3_VEND    := SE3->E3_VEND   
                NSE3->E3_PREFIXO := SE3->E3_PREFIXO
                NSE3->E3_NUM     := SE3->E3_NUM
                NSE3->E3_EMISSAO := SE3->E3_EMISSAO
                NSE3->E3_SERIE   := SE3->E3_SERIE
                NSE3->E3_CODCLI  := SE3->E3_CODCLI
                NSE3->E3_LOJA    := SE3->E3_LOJA
                NSE3->E3_BASE    := SE3->E3_BASE
                NSE3->E3_PORC    := SE3->E3_PORC
                NSE3->E3_COMIS   := SE3->E3_COMIS
                NSE3->E3_DATA    := SE3->E3_DATA
                NSE3->E3_PARCELA := SE3->E3_PARCELA
                NSE3->E3_TIPO    := SE3->E3_TIPO
                NSE3->E3_BAIEMI  := SE3->E3_BAIEMI
                NSE3->E3_PEDIDO  := SE3->E3_PEDIDO
                NSE3->E3_AJUSTE  := SE3->E3_AJUSTE
                NSE3->E3_SEQ     := SE3->E3_SEQ
                NSE3->E3_ORIGEM  := SE3->E3_ORIGEM
            MsUnlock()
        EndIf 

        DbSelectArea("SE3")
        DbSkip()
    EndDo
    EndIf
    DbSelectArea("SF2")
    DbSkip()
EndDo

DbSelectArea("NSE1")
DbCloseArea("NSE1")

DbSelectArea("NSD2")
DbCloseArea("NSD2")
   
DbSelectArea("NSF2")
DbCloseArea("NSF2")

DbSelectArea("NSE3")
DbCloseArea("NSE3")

__RetProc()


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)

    aRegs := {}

    aadd(aRegs,{cPerg,'01','Da Emissao     ? ','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
    aadd(aRegs,{cPerg,'02','Ate Emissao    ? ','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})

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

__RetProc()

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

