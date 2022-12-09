#INCLUDE 'PROTHEUS.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ MCTBM001 บAutor  ณ Jos้ Mauricio      บ Data ณ  12/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Refaz o CT2 เ partir do CTK                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Prot-Cap                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MCTBM001
// Variaveis de Tela
Local   aSay      := {}
Local   aButton   := {}
Local   nOpc      := 1
Local   Titulo    := 'GERAวรO DE CONTABILIZAวรO'
Local   cPerg     := 'MCTBM'
Local 	lContinua := .T.
Local   aRegErr   := {}
Private cDesc1    := 'Esta rotina ira gerar os registros da contabiliza็ใo CT2 apartir do arquivo '
Private cDesc2    := ' CTK - Contra-Prova.'
Private cDesc3    := ''

CriaSX1( cPerg )
Pergunte( cPerg, .F. )

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

aAdd( aButton, { 5, .T., { || Pergunte( cPerg, .T. )  } } )
aAdd( aButton, { 1, .T., { || FechaBatch()             } } )
aAdd( aButton, { 2, .T., { || nOpc := 0,FechaBatch()  } } )

FormBatch( Titulo, aSay, aButton )

If nOpc  <>  1
	Return NIL
EndIf

Processa( { || MCTBMP() }, Titulo , 'Processando ...', .F. )


ApMsgInfo( 'Processo terminado.', 'ATENวรO' )

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ MCTBMP   บAutor  ณ Jos้ Mauricio      บ Data ณ  12/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para gera็ใo do CT2 apartir do CTK                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Prot-Cap                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MCTBMP
LOCAL cQuery := ""
LOCAL cSeq   := ""
LOCAL nLinha := 0
LOCAL nDoc   := VAL(MV_PAR03)
LOCAL cLote  := STRZERO(VAL(MV_PAR02),6)
LOCAL nSeqHis:= 0                  

cQuery := "SELECT * FROM "+RetSqlName("CTK")+" WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND CTK_DATA = '"+DTOS(MV_PAR01)+"'"
cQuery += " AND CTK_LOTE = '"+MV_PAR02+"'"
cQuery += " ORDER BY CTK_SEQUEN"
cQuery := ChangeQuery( cQuery )
dBUseArea( .T., 'TOPCONN', TCGENQRY( ,, cQuery ), 'XCTK', .F., .T. )
                             
XCTK->(DBGOTOP())
WHILE XCTK->(!EOF())

    cSeq := XCTK->CTK_SEQUEN

	cQ2 := "SELECT * FROM "+RetSqlName("CT2")+" WHERE D_E_L_E_T_ <> '*' "
	cQ2 += " AND CT2_SEQUEN = '"+XCTK->CTK_SEQUEN+"'"
    cQ2 := ChangeQuery( cQ2 )	
    dBUseArea( .T., 'TOPCONN', TCGENQRY( ,, cQ2 ), 'XCT2', .F., .T. )    
    IF XCT2->(EOF())
       nLinha := 0             
       nDoc++
       
       Begin Transaction
       
       WHILE XCTK->(!EOF()) .AND. XCTK->CTK_SEQUEN == cSeq
             nLinha += 1           
             IF nLinha > 999
                nLinha := 1
                nDoc++
             ENDIF

             CT2->(DBSETORDER(1))
             IF CT2->(DBSEEK(XFILIAL("CT2")+XCTK->CTK_DATA+cLote+"001"+STRZERO(nDoc,6)+STRZERO(nLinha,3)))
                nLinha := 999
                LOOP
             ENDIF
                  
             IF XCTK->CTK_DC == "4" 
                nSeqHis++
             ELSE
                nSeqHis := 1
             ENDIF
            
             DBSELECTAREA("CT2")
             RECLOCK("CT2",.T.)
             CT2->CT2_FILIAL := XFILIAL("CT2")
             CT2->CT2_DATA   := STOD(XCTK->CTK_DATA)
             CT2->CT2_LOTE   := cLote
             CT2->CT2_SBLOTE := "001"
             CT2->CT2_DOC    := STRZERO(nDoc,6)
             CT2->CT2_LINHA  := STRZERO(nLinha,3)
             CT2->CT2_MOEDLC := "01" //XCTK->CTK_MOEDLC
             CT2->CT2_DC     := XCTK->CTK_DC
             CT2->CT2_DEBITO := XCTK->CTK_DEBITO
             CT2->CT2_CREDIT := XCTK->CTK_CREDIT
             CT2->CT2_DCD    := CRIAVAR("CT2_DCD")
             CT2->CT2_DCC    := CRIAVAR("CT2_DCC")             
             CT2->CT2_VALOR  := XCTK->CTK_VLR01
             CT2->CT2_MOEDAS := XCTK->CTK_MOEDAS
//             CT2->CT2_HP     := 
             CT2->CT2_HIST   := XCTK->CTK_HIST
             CT2->CT2_CCD    := XCTK->CTK_CCD
             CT2->CT2_CCC    := XCTK->CTK_CCC
             CT2->CT2_ITEMD  := XCTK->CTK_ITEMD
             CT2->CT2_ITEMC  := XCTK->CTK_ITEMC
             CT2->CT2_CLVLDB := XCTK->CTK_CLVLDB
             CT2->CT2_CLVLCR := XCTK->CTK_CLVLCR
             CT2->CT2_ATIVDE := XCTK->CTK_ATIVCR
             CT2->CT2_ATIVCR := XCTK->CTK_ATIVCR
             CT2->CT2_EMPORI := cEmpAnt
             CT2->CT2_FILORI := cFilAnt
             CT2->CT2_INTERC := XCTK->CTK_INTERC
//             CT2->CT2_IDENTC := 
             CT2->CT2_TPSALD := "1"
             CT2->CT2_SEQUEN := XCTK->CTK_SEQUEN
             CT2->CT2_MANUAL := "2"
             CT2->CT2_ORIGEM := XCTK->CTK_ORIGEM
             CT2->CT2_ROTINA := XCTK->CTK_ROTINA
             CT2->CT2_AGLUT  := "2"
             CT2->CT2_LP     := XCTK->CTK_LP
             CT2->CT2_SEQHIS := STRZERO(nSeqHis,3)
             CT2->CT2_SEQLAN := STRZERO(nLinha,3)
             CT2->CT2_DTVENC := STOD(XCTK->CTK_DTVENC)
//             CT2->CT2_SLBASE := 
//             CT2->CT2_DTLP   := 
//             CT2->CT2_DATATX := 
//             CT2->CT2_TAXA   := 
             CT2->CT2_VLR01  := XCTK->CTK_VLR01
             CT2->CT2_VLR02  := XCTK->CTK_VLR02
             CT2->CT2_VLR03  := XCTK->CTK_VLR03
             CT2->CT2_VLR04  := XCTK->CTK_VLR04
             CT2->CT2_VLR05  := XCTK->CTK_VLR05
             CT2->CT2_CRCONV := "1"
//             CT2->CT2_CRITER := 
             CT2->CT2_KEY    := XCTK->CTK_KEY
//             CT2->CT2_SEGOFI := 
             CT2->CT2_DTCV3  := STOD(XCTK->CTK_DATA)
//             CT2->CT2_SEQIDX := 
			 MsUnlock()
       
       		XCTK->(DBSKIP())
       END
       
       End Transaction   
    
	ELSE
       WHILE XCTK->(!EOF()) .AND. XCTK->CTK_SEQUEN == cSeq	
			XCTK->(DBSKIP())    
	   END			
    ENDIF
    XCT2->(DBCLOSEAREA())
END
XCTK->(DBCLOSEAREA())
RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaSX1   บAutor  ณJos้ Mauricio       บ Data ณ  12/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCriacao das perguntas utilizadas nesta rotina               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณProt-Cap                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSX1( cPerg )
Local aRegs := {}

IF SX1->(!DBSEEK(cPerg))
	Aadd( aRegs, {cPerg, '01', 'Data ?', 'Data ?', 'Data ?', 'mv_ch1', 'D', 8, 0, 0, 'G', '', 'mv_par01', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''} )
	Aadd( aRegs, {cPerg, '02', 'Lote ?', 'Lote ?', 'Lote ?', 'mv_ch2', 'C', 6, 0, 0, 'G', '', 'mv_par02', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''} )
	Aadd( aRegs, {cPerg, '03', 'Documento ?', 'Documento ?', 'Documento ?', 'mv_ch3', 'C', 06, 0, 0, 'G', '', 'mv_par03', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''} )
	ValidPerg( aRegs, cPerg )																																																										
ENDIF	

Return NIL