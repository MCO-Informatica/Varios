Function S_CALCPLAN(cPdRot)
    Local CCODFORANT := GetValType('C')
    Local CTPFORNANT := GetValType('C')
    Local CTPPLANO := GetValType('C')
    Local CCODPLANO := GetValType('C')
    Local APLANDEP := GetValType('A')
    Local ADEPAUX := GetValType('A')
    Local NCNT := GetValType('N')
    Local LAUX1 := GetValType('L')
    Local LAUX2 := GetValType('L')
    Local CANOMESINT := GetValType('C')
    Local CANOMESFIT := GetValType('C')
    Local NVLRFUNC := GetValType('N')
    Local NVLREMPR := GetValType('N')
    Local CPDDAGR := GetValType('C')
    Local LRBPLSAUDE := GetValType('L')
    Local LRET := GetValType('L')
    Local CTPLAN := GetValType('C')
    
    cVerbaRot := If(ValType('cPdRot')<>'U',cPdRot,'')
    
    Begin Sequence
        If ( AbortProc() )
            Break
        EndIf
    
        IF ( P_SALINC )
    
            FSALINC(@NSALARIO,@NSALMES,@SALHORA,@SALDIA)
    
        EndIF
    
    
        IF ( !P_SALINC )
    
            FSALARIO(@NSALARIO,@SALHORA,@SALDIA,@NSALMES,"A")
    
        EndIF
    
    
        RHK->(DBGOTOP())
    
        RHK->(DBSEEK( SRA->RA_FILIAL + SRA->RA_MAT, .F. ))
    
        CCODFORANT:=""
    
        CTPFORNANT:=""
    
        CTPPLANO:=""
    
        CCODPLANO:=""
    
        ALOG:={}
    
        APLANDEP:={}
    
        ADEPAUX:={}
    
        NCNT:=0
    
        LAUX1:=.F.
    
        LAUX2:=.F.
    
        AADD( ALOG, {} )
    
        AADD( ALOG, {} )
    
        AADD( ALOG, {} )
    
        AADD( ALOG, {} )
    
        AADD( ALOG, {} )
    
        AADD( ALOG, {} )
    
        While ( RHK->( !EOF() ) .AND. RHK->RHK_FILIAL + RHK->RHK_MAT == SRA->RA_FILIAL + SRA->RA_MAT )
            IF ( AbortProc() )
                Break
            EndIF
    
    
            CANOMESINT:=SUBSTR(RHK->RHK_PERINI,3,4) + SUBSTR(RHK->RHK_PERINI,1,2)
    
            CANOMESFIT:=SUBSTR(RHK->RHK_PERFIM,3,4) + SUBSTR(RHK->RHK_PERFIM,1,2)
    
            IF ( RHK->RHK_TPFORN == CTPFORNANT .AND. RHK->RHK_CODFOR == CCODFORANT .AND. RHK->RHK_TPPLAN == CTPPLANO .AND. RHK->RHK_PLANO == CCODPLANO )
    
                IF ( LEN( ALOG[3] ) == 0 .OR. ASCAN( ALOG[3], { |X| X == SUBSTR( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) } ) == 0 )
    
                    AADD( ALOG[3], SUBSTR( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) )
    
                EndIF
    
    
            EndIF
    
    
            IF ( !(RHK->RHK_TPFORN==CTPFORNANT .AND. RHK->RHK_CODFOR==CCODFORANT .AND. RHK->RHK_TPPLAN==CTPPLANO .AND. RHK->RHK_PLANO==CCODPLANO                                                                                                                     ) )
    
                CCODFORANT:=RHK->RHK_CODFOR
    
                CTPFORNANT:=RHK->RHK_TPFORN
    
                CTPPLANO:=RHK->RHK_TPPLAN
    
                CCODPLANO:=RHK->RHK_PLANO
    
            EndIF
    
    
            IF ( (( CANOMESINT > CANOMES ) .OR. ( CANOMESINT <= CANOMES .AND. ! EMPTY( CANOMESFIT ) .AND. CANOMESFIT < CANOMES )) )
    
                RHK->(DBSKIP())
    
                Loop
    
            EndIF
    
    
            NVLRFUNC := 0
    
            NVLREMPR := 0
    
            IF ( FCALCPLANO(1, RHK->RHK_TPFORN, RHK->RHK_CODFOR, RHK->RHK_TPPLAN, RHK->RHK_PLANO, DDATAREF, SRA->RA_NASC, @NVLRFUNC, @NVLREMPR, SRA->RA_FILIAL ) )
    
                FGRAVACALC("1", SPACE(GETSX3CACHE("RHR_CODIGO", "X3_TAMANHO")), "1", RHK->RHK_TPFORN, RHK->RHK_CODFOR, RHK->RHK_TPPLAN, RHK->RHK_PLANO, RHK->RHK_PD, NVLRFUNC, NVLREMPR )
    
            EndIF
    
    
            CPDDAGR:=RHK->RHK_PDDAGR
    
            SRB->(DBSETORDER( RETORDEM( "SRB", "RB_FILIAL+RB_MAT" ) ))
    
            IF ( SRB->(DBSEEK( SRA->RA_FILIAL + SRA->RA_MAT, .F. )	) )
    
                While ( SRB->( !EOF() ) .AND. SRB->RB_FILIAL + SRB->RB_MAT  == SRA->RA_FILIAL + SRA->RA_MAT )
                            IF ( AbortProc() )
                                        Break
                            EndIF
    
    
                    LRBPLSAUDE:=SRB->RB_PLSAUDE == "1" .AND. RHK->RHK_TPFORN == "1"
    
                    IF ( ASCAN(ADEPAUX, SRA->RA_MAT) == 0 )
    
                        APLANDEP:=FBUSPLDEP(SRA->RA_MAT,RHK->RHK_TPFORN,RHK->RHK_CODFOR,SRB->RB_COD)
    
                        AADD(ADEPAUX, SRA->RA_MAT)
    
                    EndIF
    
    
                    IF ( LEN(APLANDEP) > 0 )
    
                        NCNT:=1
    
                        While ( NCNT <= LEN(APLANDEP) )
                                            IF ( AbortProc() )
                                                                Break
                                            EndIF
    
    
                            LAUX1:=(CANOMES >= SUBSTR(RHL->RHL_PERINI,3,4)+SUBSTR(RHL->RHL_PERINI,1,2)) .AND. EMPTY( RHL->RHL_PERFIM)
    
                            LAUX2:=(CANOMES >= SUBSTR(RHL->RHL_PERINI,3,4)+SUBSTR(RHL->RHL_PERINI,1,2)) .AND. (CANOMES <=  SUBSTR(RHL->RHL_PERFIM,3,4)+SUBSTR(RHL->RHL_PERFIM,1,2))
    
                            IF ( LAUX1 .OR. LAUX2 )
    
                                NVLRFUNC:=0
    
                                NVLREMPR:=0
    
                                LRET:=FCALCPLANO(2, APLANDEP[NCNT][1], APLANDEP[NCNT][2], APLANDEP[NCNT][5], APLANDEP[NCNT][6], DDATAREF, SRB->RB_DTNASC, @NVLRFUNC, @NVLREMPR, SRA->RA_FILIAL )
    
                                IF ( LRET .AND. ROUND(NVLRFUNC,2) > 0 .OR. ROUND(NVLREMPR,2) > 0 )
    
                                    FGRAVACALC("2", APLANDEP[NCNT][3], "1", APLANDEP[NCNT][1], APLANDEP[NCNT][2], APLANDEP[NCNT][5], APLANDEP[NCNT][6], CPDDAGR, NVLRFUNC, NVLREMPR )
    
                                EndIF
    
    
                                IF ( LRET .AND. ROUND(NVLRFUNC,2) <= 0 .AND. ROUND(NVLREMPR,2) <= 0 )
    
                                    AADD( ALOG[2], SUBSTR(SRA->RA_FILIAL + "  " + SRA->RA_MAT + "-" + SRA->RA_NOME,1,45) + " -  CÓDIGO  - " + APLANDEP[I][3] )
    
                                EndIF
    
    
                            EndIF
    
    
                            NCNT:=NCNT + 1
    
    
                        End
    
                    EndIF
    
    
                    IF ( LEN(APLANDEP) == 0 .AND. LRBPLSAUDE .AND. ASCAN(ADEPAUX, SRA->RA_MAT) == 0 )
    
                        AADD( ALOG[2], SUBSTR(SRA->RA_FILIAL + "  " + SRA->RA_MAT + "-" + SRA->RA_NOME,1,45) + " - CADASTRO DE DEPENDENTES COM INFORMAÇÃO DE QUE POSSUI PLANO DE SAÚDE, PORÉM NÃO EXISTE PLANO ATIVO." )
    
                    EndIF
    
    
                    APLANDEP:={}
    
                    SRB->(DBSKIP())
    
    
                End
    
            EndIF
    
    
            RHM->(DBSETORDER( RETORDEM( "RHM", "RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO" ) ))
    
            IF ( RHM->(DBSEEK( SRA->RA_FILIAL + SRA->RA_MAT + RHK->RHK_TPFORN + RHK->RHK_CODFOR, .F. )) )
    
                While ( RHM->( !EOF() ) .AND. RHM->RHM_FILIAL + RHM->RHM_MAT + RHM->RHM_TPFORN + RHM->RHM_CODFOR == SRA->RA_FILIAL + SRA->RA_MAT + RHK->RHK_TPFORN + RHK->RHK_CODFOR )
                            IF ( AbortProc() )
                                        Break
                            EndIF
    
    
                    IF ( ((CANOMES >= SUBSTR(RHM->RHM_PERINI,3,4)+SUBSTR(RHM->RHM_PERINI,1,2)) .AND. EMPTY( RHM->RHM_PERFIM) .OR. (CANOMES >= SUBSTR(RHM->RHM_PERINI,3,4)+SUBSTR(RHM->RHM_PERINI,1,2)) .AND. (CANOMES <=  SUBSTR(RHM->RHM_PERFIM,3,4)+SUBSTR(RHM->RHM_PERFIM,1,2))) )
    
                        NVLRFUNC:=0
    
                        NVLREMPR:=0
    
                        LRET:=FCALCPLANO(3, RHM->RHM_TPFORN, RHM->RHM_CODFOR, RHM->RHM_TPPLAN, RHM->RHM_PLANO, DDATAREF, RHM->RHM_DTNASC, @NVLRFUNC, @NVLREMPR, SRA->RA_FILIAL )
    
                        IF ( LRET .AND. ROUND(NVLRFUNC,2) > 0 .OR. ROUND(NVLREMPR,2) > 0 )
    
                            FGRAVACALC("3", RHM->RHM_CODIGO, "1", RHM->RHM_TPFORN, RHM->RHM_CODFOR, RHM->RHM_TPPLAN, RHM->RHM_PLANO, CPDDAGR, NVLRFUNC, NVLREMPR )
    
                        EndIF
    
    
                        IF ( LRET .AND. ROUND(NVLRFUNC,2) <= 0 .AND. ROUND(NVLREMPR,2) <= 0 )
    
                            AADD( ALOG[2], SUBSTR(SRA->RA_FILIAL + "  " + SRA->RA_MAT + "-" + SRA->RA_NOME,1,45) + " - CÓDIGO - " + RHM->RHM_CODIGO )
    
                        EndIF
    
    
                    EndIF
    
    
                    RHM->(DBSKIP())
    
    
                End
    
            EndIF
    
    
            RHK->(DBSKIP())
    
    
        End
    
        RHO->(DBSETORDER( RETORDEM( "RHO", "RHO_FILIAL+RHO_MAT+RHO_COMPPG" ) ))
    
        IF ( RHO->(DBSEEK( SRA->RA_FILIAL + SRA->RA_MAT + CANOMES, .F. )) )
    
            While ( RHO->( !EOF() ) .AND. RHO->( RHO_FILIAL + RHO_MAT + RHO_COMPPG ) == SRA->( RA_FILIAL + RA_MAT ) + CANOMES )
                    IF ( AbortProc() )
                            Break
                    EndIF
    
    
                CTPLAN:=IF( RHO->RHO_TPLAN == "1", "2", "3")
    
                FGRAVACALC(RHO->RHO_ORIGEM, RHO->RHO_CODIGO, CTPLAN, RHO->RHO_TPFORN, RHO->RHO_CODFOR, SPACE(GETSX3CACHE("RHK_TPPLAN", "X3_TAMANHO")), SPACE(GETSX3CACHE("RHK_PLANO", "X3_TAMANHO")), RHO->RHO_PD, RHO->RHO_VLRFUN, RHO->RHO_VLREMP, .T. )
    
                IF ( LPLANOATIV==.F. )
    
                    IF ( LEN( ALOG[6] ) == 0 .OR. ASCAN( ALOG[6], { |X| X == SUBSTR( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME, 1, 45 ) } ) == 0 )
    
                        AADD( ALOG[6], 	SUBSTR( SRA->RA_FILIAL + "  " + SRA->RA_MAT + " - " + SRA->RA_NOME , 1, 45 ) + "FORNECEDOR: "+ RHO->RHO_CODFOR +" DATA DE OCORRENCIA: "+ DTOC(RHO->RHO_DTOCOR) +" OBSERVAÇÃO: " + SUBSTR(RHO->RHO_OBSERV,1,45))
    
                    EndIF
    
    
                EndIF
    
    
                RHO->(DBSKIP())
    
    
            End
    
        EndIF
    
    
        FLOGPLS(ALOG)
    
    End Sequence
Return
