#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

USER FUNCTION NEWPREC2()
//----------------------------------------------------------------------------------------------------------------------------//
//									AVDTEC  -  YURI PORTO - 26/10/2013                                                        //
//----------------------------------------------------------------------------------------------------------------------------//
// o programa tem a função de alimetar os campos B1_VLFIM1,B1_VLFIM2,B1_VLFIM3,B1_VLFIM4,B1_VLFIM5,B1_VLFIM6,B1_VLFIM7        //
// O SEGUINTE PROCEDIMENTO SERA EXECUTADO:                                                                                    //
// 1-	ALIMENTA O CAMPO B1_VLMOEDA 	- PEGA O VALOR DAS MOEDAS EXTRANGEIRAS, CALCULA O FATOR = MOEDA_ESTRANGEIRA / POR REAL//
// 2-	ALIMENTA O CAMPO B1_VL cVALOR	(CONVERTENDO PARA MOEDA NACIONAL)- B1_VLCUSTO * FTLUCRO * MOEDA                       //
// 3-	ALIMENTA OS CAMPOS B1_VLFIM1 A B1_VLFIM7	- EX. B1_VLFIM1 = B1_VLBRUTO) * ALIQ1+ 1)                                 //
// 4-	O PROGRAMA DEVE ATUALIZAR OS PREÇOS NAS ESTRUTURAS - NA SEQUENCIA - PC, SK ,KT                                        //
// 5-   PRIMEIRO TRATAR AS PC DEPOIS OS KITS                                                                                  //
//----------------------------------------------------------------------------------------------------------------------------//
Private _cCODIGO:= ""
Private _nVALOR := 0
PRIVATE cCUSTO
PRIVATE _VERVEN
PRIVATE CQUERY
PRIVATE _MOEDA
PRIVATE _DOLAR
PRIVATE _EURO
PRIVATE _XXX

MSGALERT ("INICIANDO ATUALIZAÇÃO")

//     CAPTURA VALORES ESTRANGEIROS - MOEDAS/DESPESA     //
CQUERY	:=	"SELECT TOP (1) M2_MOEDA2 , M2_MOEDA4, M2_DATA, M2_TXDESP"
CQUERY	+=	"	FROM SM2010 WITH (NOLOCK)"
CQUERY	+=	"	WHERE SM2010.D_E_L_E_T_ = '' and M2_DATA = '"+dtos(ddatabase)  +"' "
CQUERY	+=	"   ORDER BY M2_DATA DESC"

MEMOWRIT("RFAT02.SQL", CQUERY)
TCQUERY CQUERY NEW ALIAS "MOX"

Dbselectarea("MOX")
If EOF()
	MSGALERT("Nao encontrada valor para moeda na data "+DtoC(ddatabase))
ELSE
	_DOLAR := MOX->M2_MOEDA2
	_EURO  := MOX->M2_MOEDA4
	_TAX   := 1+(MOX->M2_TXDESP/100)
Endif

MOX->(DBCLOSEAREA())

//------------------------VERIFICA SE OS VALORES DE MOEDA ESTÃO PREENCHIDOS
IF _DOLAR > 0 .AND. _EURO > 0
	Processa({|| Runpec() },"Processando Peças...")
ENDIF

IF _DOLAR > 0 .AND. _EURO > 0
	Processa({|| Runsub() },"Processando Sub-Kit...")
ENDIF

IF _DOLAR > 0 .AND. _EURO > 0
	Processa({|| Runkit() },"Processando Kit...")
ENDIF

MSGALERT("PRODUTOS ATUALIZADOS COM SUCESSO")
RETURN


Static Function Runpec()
Local nAtual := 0
// INICIA A ATUALIZAÇÃO DE PÇS  ==> B1_ESTRUT = 3 - PECAS
DBSELECTAREA("SB1")
DBGOTOP()

CQUER1	:=	"SELECT B1_COD,B1_MSBLQL,B1_ESTRUT,B1_VERCOM,B1_CUSTD,B1_UPRC,B1_VLCUSTO,B1_TPMOEDA,B1_FATOR,B1_GRUPO,B1_ALIQ1,B1_ALIQ2,B1_ALIQ3,B1_ALIQ4,B1_ALIQ5,B1_ALIQ6,B1_ALIQ7,B1_FTLUCRO "
CQUER1	+=	"	FROM "+RetSqlName("SB1")+" B1P WITH (NOLOCK)"
CQUER1	+=	"	WHERE B1_MSBLQL = '2' "
CQUER1	+=	"	AND B1_ESTRUT = '3'   "
CQUER1	+=	"	AND B1P.D_E_L_E_T_ = '' "
CQUER1	+=	"	ORDER BY B1_COD "

MEMOWRIT("NEW_PREC_PECA.SQL", CQUER1)
TCQUERY CQUER1 NEW ALIAS "SB1P"
Dbselectarea("SB1P")
DBGOTOP()

ProcRegua(Contar("SB1P","!Eof()"))


WHILE !EOF()
	IncProc("Codigo: " + SB1P->B1_COD)
	
	If 	SB1P->B1_COD = "GI808204"
		//			MSGALERT("PRODUTO COD :"+_cCODIGO+" Estrutura")
	Endif
	
	IF 	SB1P->B1_MSBLQL = "2"
		_cCODIGO := SB1P->B1_COD
		
		IF 	SB1P->B1_ESTRUT = "3" // ESTRUTURA 3 = PEÇAS
			
			// TRATAMENTO VERION
			IF SM0->M0_CODIGO == "01"
				cCUSTO :=  IIF(SB1P->B1_VERCOM > 0,SB1P->B1_VERCOM,IIF(SB1P->B1_CUSTD > 0,SB1P->B1_CUSTD,IIF(SB1P->B1_UPRC > 0,SB1P->B1_UPRC,0)))
			ELSE
				cCUSTO := SB1P->B1_VLCUSTO
			ENDIF
			
			IF SB1P->B1_TPMOEDA = "D"
				_MOEDA := _DOLAR
			ELSEIF SB1P->B1_TPMOEDA = "E"
				_MOEDA := _EURO
			ELSE
				_MOEDA := 1
			ENDIF
			
			_WFATOR   := SB1P->B1_FATOR
			_WGRUPO   := SB1P->B1_GRUPO
			
			dbSelectArea("SBM")
			dbSeek(xFilial()+_WGRUPO)
			
			IF _WFATOR == 0
				_WFATOR := SBM->BM_FATOR
			Endif
			
			// TRATAMENTO DE MOEDAS VERION
			IF SM0->M0_CODIGO == "01" .AND. EMPTY(SB1P->B1_TPMOEDA)
				IF SBM->BM_MOEDA = "D"
					_MOEDA := _DOLAR
				ELSEIF SBM->BM_MOEDA = "E"
					_MOEDA := _EURO
				ELSE
					_MOEDA := 1
				ENDIF
			ENDIF
			
			IF 	_WFATOR > 0 .AND. cCUSTO > 0 .AND. _MOEDA > 0
				DBSELECTAREA("SB1")
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("SB1")+_cCODIGO)
					RECLOCK("SB1",.F.)
					SB1->B1_VLBRUTO  := 	((cCUSTO *	_WFATOR)*_MOEDA) * _TAX
					SB1->B1_VLFIM1   := 	SB1->B1_VLBRUTO / ((100-SB1P->B1_ALIQ1)/100)
					SB1->B1_VLFIM2   := 	SB1->B1_VLBRUTO / ((100-SB1P->B1_ALIQ2)/100)
					SB1->B1_VLFIM3   := 	SB1->B1_VLBRUTO / ((100-SB1P->B1_ALIQ3)/100)
					SB1->B1_VLFIM4   := 	SB1->B1_VLBRUTO / ((100-SB1P->B1_ALIQ4)/100)
					SB1->B1_VLFIM5   := 	SB1->B1_VLBRUTO / ((100-SB1P->B1_ALIQ5)/100)
					SB1->B1_VLFIM6   := 	SB1->B1_VLBRUTO / ((100-SB1P->B1_ALIQ6)/100)
					SB1->B1_VLFIM7   := 	SB1->B1_VLBRUTO / ((100-SB1P->B1_ALIQ7)/100)
					MSUNLOCK("SB1")
				ENDIF
			ELSE
				//					MSGALERT("VERIFICAR O CADASTRO DO PRODUTO COD :"+_cCODIGO+"  FATOR DE LUCRO, VALOR DE CUSTO E MOEDA - PECAS")
			ENDIF
		ENDIF
	ENDIF
	dbSelectArea("SB1P")
	dbskip()
	_cCODIGO := SB1P->B1_COD
	nAtual++
    IncProc("Analisando registro " + cValToChar(nAtual) + " de " + cValToChar(RecCount()) + "...")
Enddo
SB1P->(DBCLOSEAREA())
return


Static Function Runsub()
// TRATAMENTO DE SUB-KIT
DBSELECTAREA("SB1")
DBGOTOP()

CQUER2	:=	"SELECT B1_COD,B1_MSBLQL,B1_ESTRUT,B1_VERCOM,B1_CUSTD,B1_UPRC,B1_VLCUSTO,B1_TPMOEDA,B1_FATOR,B1_GRUPO,B1_ALIQ1,B1_ALIQ2,B1_ALIQ3,B1_ALIQ4,B1_ALIQ5,B1_ALIQ6,B1_ALIQ7,B1_FTLUCRO "
CQUER2	+=	"	FROM "+RetSqlName("SB1")+" B1S WITH (NOLOCK)"
CQUER2	+=	"	WHERE B1_MSBLQL = '2' "
CQUER2	+=	"	AND B1_ESTRUT = '2'  "
CQUER2	+=	"	AND B1S.D_E_L_E_T_ = '' "
CQUER2	+=	"	ORDER BY B1_COD "

MEMOWRIT("NEW_PREC_SUB.SQL", CQUER2)
TCQUERY CQUER2 NEW ALIAS "SB2P"
Dbselectarea("SB2P")
DBGOTOP()
ProcRegua(RecCount())


WHILE !EOF()
	IncProc("Codigo: " + SB2P->B1_COD)
	IF SB2P->B1_MSBLQL = "2"
		
		_cCODIGO := SB2P->B1_COD
		
		IF SB2P->B1_ESTRUT = "2"
			
			dbSelectArea("SG1")
			dbSetOrder(1)
			If dbSeek(xFilial("SG1")+_cCODIGO)
				
				CQUERY	:=	"SELECT SUM(B1_VLBRUTO*G1_QUANT) AS _XXX "
				CQUERY	+=	"	FROM "+RetSqlName("SG1")+" G1, "+RetSqlName("SB1")+" B1"
				CQUERY	+=	"	WHERE G1_COD = '"+_cCODIGO+"' "
				CQUERY	+=	"	AND G1_COMP = B1_COD "
				CQUERY	+=	"	AND G1.D_E_L_E_T_ = '' "
				CQUERY	+=	"	AND B1.D_E_L_E_T_ = '' "
				
				MEMOWRIT("RFAT02_SUB.SQL", CQUERY)
				TCQUERY CQUERY NEW ALIAS "TOX"
				Dbselectarea("TOX")
				_nVALOR := TOX->_XXX
				TOX->(DBCLOSEAREA())
				
				CCUSTO := _nVALOR
				
				IF SB2P->B1_TPMOEDA = "D"
					_MOEDA := _DOLAR
				ELSEIF SB2P->B1_TPMOEDA = "E"
					_MOEDA := _EURO
				ELSE
					_MOEDA := 1
				ENDIF
				
				// INCLUSAO 22_06_2017 - ANTES NAO TINHA ESTA LINHA
				_WFATOR   := SB2P->B1_FATOR
				_WGRUPO   := SB2P->B1_GRUPO
				
				dbSelectArea("SBM")
				dbSeek(xFilial()+_WGRUPO)
				
				IF _WFATOR == 0
					_WFATOR := SBM->BM_FATOR
				Endif
				
				// TRATAMENTO DE MOEDAS VERION
				IF SM0->M0_CODIGO == "01" .AND. EMPTY(SB2P->B1_TPMOEDA)
					IF SBM->BM_MOEDA = "D"
						_MOEDA := _DOLAR
					ELSEIF SBM->BM_MOEDA = "E"
						_MOEDA := _EURO
					ELSE
						_MOEDA := 1
					ENDIF
				ENDIF
				
				IF 	_WFATOR > 0 .AND. cCUSTO > 0 .AND. _MOEDA > 0
					
					DBSELECTAREA("SB1")
					DBSETORDER(1)
					IF DBSEEK(XFILIAL("SB1")+_cCODIGO)
						RECLOCK("SB1",.F.)
						SB1->B1_VLCUSTO  :=     _nVALOR
						IF SUBSTR(_WGRUPO,1,2) $ "VB|Y-"
							SB1->B1_VERCOM   :=     _nVALOR
						ENDIF
						SB1->B1_VLBRUTO  :=		(_nVALOR * iif(SB2P->B1_FTLUCRO=0,1,SB2P->B1_FTLUCRO))
						SB1->B1_VLFIM1   := 	SB1->B1_VLBRUTO / ((100-SB2P->B1_ALIQ1)/100)
						SB1->B1_VLFIM2   := 	SB1->B1_VLBRUTO / ((100-SB2P->B1_ALIQ2)/100)
						SB1->B1_VLFIM3   := 	SB1->B1_VLBRUTO / ((100-SB2P->B1_ALIQ3)/100)
						SB1->B1_VLFIM4   := 	SB1->B1_VLBRUTO / ((100-SB2P->B1_ALIQ4)/100)
						SB1->B1_VLFIM5   := 	SB1->B1_VLBRUTO / ((100-SB2P->B1_ALIQ5)/100)
						SB1->B1_VLFIM6   := 	SB1->B1_VLBRUTO / ((100-SB2P->B1_ALIQ6)/100)
						SB1->B1_VLFIM7   := 	SB1->B1_VLBRUTO / ((100-SB2P->B1_ALIQ7)/100)
						MSUNLOCK("SB1")
					ELSE
						//					    MSGALERT("VERIFICAR O CADASTRO DO PRODUTO COD :"+_cCODIGO+"  FATOR DE LUCRO, VALOR DE CUSTO E MOEDA - SUB_KIT")
					ENDIF
				ENDIF
			EndIf
		EndIf
	endif
	dbselectarea("SB2P")
	dbskip()
	_cCODIGO := SB2P->B1_COD
	_XXX     := 0
	_nVALOR  := 0
End
SB2P->(DBCLOSEAREA())
return

Static Function Runkit()
// TRATAMENTO DE KIT
DbCloseArea("SB1")
DBSELECTAREA("SB1")
DBGOTOP()
CQUER3	:=	"SELECT B1_COD,B1_MSBLQL,B1_ESTRUT,B1_VERCOM,B1_CUSTD,B1_UPRC,B1_VLCUSTO,B1_TPMOEDA,B1_FATOR,B1_GRUPO,B1_ALIQ1,B1_ALIQ2,B1_ALIQ3,B1_ALIQ4,B1_ALIQ5,B1_ALIQ6,B1_ALIQ7,B1_FTLUCRO "
CQUER3	+=	"	FROM "+RetSqlName("SB1")+" B1K WITH (NOLOCK)"
CQUER3	+=	"	WHERE B1_MSBLQL = '2' "
CQUER3	+=	"	AND B1_ESTRUT = '1'  "
CQUER3	+=	"	AND B1K.D_E_L_E_T_ = '' "
CQUER3	+=	"	ORDER BY B1_COD "

MEMOWRIT("NEW_PREC_KIT.SQL", CQUER3)
TCQUERY CQUER3 NEW ALIAS "SB1K"
Dbselectarea("SB1K")
DBGOTOP()
ProcRegua(RecCount())


WHILE !EOF()
	IncProc("Codigo: " + SB1K->B1_COD)
	IF SB1K->B1_MSBLQL = "2"
		IF	SB1K->B1_ESTRUT = "1"
			
			_cCODIGO := SB1K->B1_COD
			
			dbSelectArea("SG1")
			dbSetOrder(1)
			If dbSeek(xFilial("SG1")+SB1K->B1_COD)
				
				CQUERY	:=	"SELECT SUM(B1_VLBRUTO*G1_QUANT) AS _XXX "
				CQUERY	+=	"	FROM "+RetSqlName("SG1")+" G1, "+RetSqlName("SB1")+" B1"
				CQUERY	+=	"	WHERE G1_COD = '"+ALLTRIM(_cCODIGO)+"' "
				CQUERY	+=	"	AND G1_COMP = B1_COD "
				CQUERY	+=	"	AND G1.D_E_L_E_T_ = '' "
				CQUERY	+=	"	AND B1.D_E_L_E_T_ = '' "
				
				MEMOWRIT("RFAT02_KIT.SQL", CQUERY)
				TCQUERY CQUERY NEW ALIAS "TTX"
				Dbselectarea("TTX")
				_nVALOR := TTX->_XXX
				TTX->(DBCLOSEAREA())
				
				CCUSTO    := _nVALOR
				_WFATOR   := SB1K->B1_FATOR
				_WGRUPO   := SB1K->B1_GRUPO
				
				dbSelectArea("SBM")
				dbSeek(xFilial()+_WGRUPO)
				
				IF _WFATOR == 0
					_WFATOR := SBM->BM_FATOR
				Endif
				
				IF SB1K->B1_TPMOEDA = "D"
					_MOEDA := _DOLAR
				ELSEIF SB1K->B1_TPMOEDA = "E"
					_MOEDA := _EURO
				ELSE
					_MOEDA := 1
				ENDIF
				
				IF _WFATOR > 0 .AND. cCUSTO > 0 .AND. _MOEDA > 0
					
					DBSELECTAREA("SB1")
					DBSETORDER(1)
					IF DBSEEK(XFILIAL("SB1")+_cCODIGO)
						RECLOCK("SB1",.F.)
						SB1->B1_VLCUSTO  :=     _nVALOR
						IF SUBSTR(_WGRUPO,1,2) $ "VB|Y-"
							SB1->B1_VERCOM   :=     _nVALOR
						ENDIF
						SB1->B1_VLBRUTO  :=		_nVALOR
						SB1->B1_VLFIM1   := 	SB1->B1_VLBRUTO / ((100-SB1K->B1_ALIQ1)/100)
						SB1->B1_VLFIM2   := 	SB1->B1_VLBRUTO / ((100-SB1K->B1_ALIQ2)/100)
						SB1->B1_VLFIM3   := 	SB1->B1_VLBRUTO / ((100-SB1K->B1_ALIQ3)/100)
						SB1->B1_VLFIM4   := 	SB1->B1_VLBRUTO / ((100-SB1K->B1_ALIQ4)/100)
						SB1->B1_VLFIM5   := 	SB1->B1_VLBRUTO / ((100-SB1K->B1_ALIQ5)/100)
						SB1->B1_VLFIM6   := 	SB1->B1_VLBRUTO / ((100-SB1K->B1_ALIQ6)/100)
						SB1->B1_VLFIM7   := 	SB1->B1_VLBRUTO / ((100-SB1K->B1_ALIQ7)/100)
						MSUNLOCK("SB1")
					ELSE
						//						MSGALERT("VERIFICAR O CADASTRO DO PRODUTO COD :"+_cCODIGO+"  FATOR DE LUCRO, VALOR DE CUSTO E MOEDA - KIT")
					ENDIF
				ENDIF
			ENDIF
		EndIf
	endif
	
	dbselectarea("SB1K")
	dbskip()
	_cCODIGO := SB1K->B1_COD
	_XXX := 0
	_nVALOR :=0
END
SB1K->(DBCLOSEAREA())
return
