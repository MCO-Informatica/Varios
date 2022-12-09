#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

USER FUNCTION APRECO2()
//----------------------------------------------------------------------------------------------------------------------------//
//                                                                                                                            //
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
//PRIVATE _ncont
//PRIVATE _ncont1
//PRIVATE _ncont2

MSGALERT ("INICIANDO ATUALIZAÇÃO")
//--------------------------------------------------------------------------------------------CAPTURA VALORES ESTRANGEIROS
CQUERY	:=	"SELECT TOP (1) M2_MOEDA2 , M2_MOEDA4, M2_DATA, M2_TXDESP"
CQUERY	+=	"	FROM SM2010"
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
	//-----------------------------------------VERIFICA SE ESTRUTURA ESTÁ PREENCHIDO
	//		ELSEIF 		SB1->B1_ESTRUT = ""
	//			MSGALERT ("PRODUTO "+_cCODIGO+" COM CAMPO ESTRUTURA VAZIO ")
	//		ENDIF
	//-----------------------------------------VERIFICA SE ESTRUTURA ESTÁ PREENCHIDO	
	DBSELECTAREA("SB1")
	DBGOTOP()
	DBSETORDER(1)
	WHILE !EOF()
		IF 		SB1->B1_MSBLQL = "2"
			_cCODIGO := SB1->B1_COD
			IF 		SB1->B1_ESTRUT = ""
				MSGALERT("VERIFICAR O CADASTRO DO PRODUTO COD :"+_cCODIGO+" Estrutura")
			ENDIF
		ENDIF
		dbSelectArea("SB1")
		dbskip()
			_cCODIGO := SB1->B1_COD
	END
	
	//------------------------------------------INICIA A ATUALIZAÇÃO DE PÇS
	DBSELECTAREA("SB1")
	DBGOTOP()
	DBSETORDER(1)
	
	//_ncont := 0
	//_ncont1 := 0
	//_ncont2 := 0
	
	WHILE !EOF()
	If 	SB1->B1_COD = "GI808204"
		MSGALERT("PRODUTO COD :"+_cCODIGO+" Estrutura")
	endif
		
		IF 	SB1->B1_MSBLQL = "2"

			_cCODIGO := SB1->B1_COD

			IF 	SB1->B1_ESTRUT = "3" // ESTRUTURA 3 = PEÇAS

				cCUSTO := SB1->B1_VLCUSTO

				IF SB1->B1_TPMOEDA = "D"
					_MOEDA := _DOLAR
				ELSEIF SB1->B1_TPMOEDA = "E"
					_MOEDA := _EURO
				ELSE
					_MOEDA := 1
				ENDIF
				
				_WFATOR   := SB1->B1_FTLUCRO//SB1->B1_FATOR
				_WGRUPO   := SB1->B1_GRUPO    
	
				dbSelectArea("SBM")
				dbSeek(xFilial()+_WGRUPO)
	
				IF _WFATOR == 0
					_WFATOR := SBM->BM_FATOR
				Endif
				
				IF 	_WFATOR > 0 .AND. cCUSTO > 0 .AND. _MOEDA > 0
					//-------------------------GRAVA
					RECLOCK("SB1",.F.)
					 SB1->B1_VLBRUTO  := 	((cCUSTO *	_WFATOR)*_MOEDA) * _TAX
					 SB1->B1_VLFIM1   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ1)/100)
					 SB1->B1_VLFIM2   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ2)/100)
					 SB1->B1_VLFIM3   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ3)/100)
					 SB1->B1_VLFIM4   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ4)/100)
					 SB1->B1_VLFIM5   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ5)/100)
					 SB1->B1_VLFIM6   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ6)/100)
					 SB1->B1_VLFIM7   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ7)/100)
					MSUNLOCK("SB1")
					//_ncont := _ncont+1
				ELSE
					MSGALERT("VERIFICAR O CADASTRO DO PRODUTO COD :"+_cCODIGO+"  FATOR DE LUCRO, VALOR DE CUSTO E MOEDA")
				END IF
			ENDIF
		ENDIF
		dbSelectArea("SB1")
		dbskip()
		_cCODIGO := SB1->B1_COD
	END
endif
//MSGALERT ("Foram atualizadas "+_ncont+"  peças")

// TRATAMENTO DE SUB-KIT
DbCloseArea("SB1")
DBSELECTAREA("SB1")
DBGOTOP()
DBSETORDER(1)
WHILE !EOF()
	IF 		SB1->B1_MSBLQL = "2"
		_cCODIGO := SB1->B1_COD
		
		//--------------------------------------------------------sub-kit
		IF SB1->B1_ESTRUT = "2"
			
			dbSelectArea("SG1")
			dbSetOrder(1)
			If dbSeek(xFilial("SG1")+_cCODIGO)
				
				CQUERY	:=	"SELECT SUM(B1_VLBRUTO*G1_QUANT) AS _XXX "
				CQUERY	+=	"	FROM SG1020, SB1020 "
				CQUERY	+=	"	WHERE G1_COD = '"+_cCODIGO+"' "
				CQUERY	+=	"	AND G1_COMP = B1_COD "
				CQUERY	+=	"	AND SG1020.D_E_L_E_T_ = '' "
				CQUERY	+=	"	AND SB1020.D_E_L_E_T_ = '' "
				
				MEMOWRIT("RFAT02.SQL", CQUERY)
				TCQUERY CQUERY NEW ALIAS "TOX"
				Dbselectarea("TOX")
				_nVALOR := TOX->_XXX
				TOX->(DBCLOSEAREA())
				
				dbSelectArea("SB1")
				dbSetOrder(1)
				Dbseek(Xfilial("SB1") + _cCODIGO)
				
				cCUSTO := SB1->B1_VLCUSTO
				IF SB1->B1_TPMOEDA = "D"
					_MOEDA := _DOLAR
				ELSEIF SB1->B1_TPMOEDA = "E"
					_MOEDA := _EURO
				ELSE
					_MOEDA := 1
				ENDIF

				IF SB1->B1_FTLUCRO > 0 .AND. cCUSTO > 0 .AND. _MOEDA > 0
					
					RECLOCK("SB1",.F.)
					SB1->B1_TPMOEDA	 :=		"R"
					SB1->B1_VLCUSTO  :=     _nVALOR
					SB1->B1_VERCOM   :=     _nVALOR
					SB1->B1_VLBRUTO  :=		(_nVALOR *SB1->B1_FTLUCRO)
					SB1->B1_VLFIM1   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ1)/100)
					SB1->B1_VLFIM2   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ2)/100)
					SB1->B1_VLFIM3   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ3)/100)
					SB1->B1_VLFIM4   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ4)/100)
					SB1->B1_VLFIM5   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ5)/100)
					SB1->B1_VLFIM6   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ6)/100)
					SB1->B1_VLFIM7   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ7)/100)
					MSUNLOCK("SB1")
					//		_ncont1 := _ncont1 +1
				ELSE
					MSGALERT("VERIFICAR O CADASTRO DO PRODUTO COD :"+_cCODIGO+"  FATOR DE LUCRO, VALOR DE CUSTO E MOEDA")
				END IF
			ENDIF
		EndIf
	EndIf
	dbselectarea("SB1")
	dbskip()
	_cCODIGO := SB1->B1_COD
	_XXX := 0
	_nVALOR :=0
end
//msgalert("Foram atualizados "+_ncont1+"SK")


// TRATAMENTO DE KIT
DbCloseArea("SB1")
DBSELECTAREA("SB1")
DBGOTOP()
DBSETORDER(1)
//-----------------------------------------------------CASO SEJA KIT
WHILE !EOF()
	IF 		SB1->B1_MSBLQL = "2"
		IF	SB1->B1_ESTRUT = "1"
			
			dbSelectArea("SG1")
			dbSetOrder(1)
			If dbSeek(xFilial("SG1")+SB1->B1_COD)

				CQUERY	:=	"SELECT SUM(B1_VLBRUTO*G1_QUANT) AS _XXX "
				CQUERY	+=	"	FROM SG1020, retname(SB1)020 "  //RetSqlName("SD3")
				CQUERY	+=	"	WHERE G1_COD = '"+ALLTRIM(_cCODIGO)+"' "
				CQUERY	+=	"	AND G1_COMP = B1_COD "
				CQUERY	+=	"	AND SG1020.D_E_L_E_T_ = '' "
				CQUERY	+=	"	AND SB1020.D_E_L_E_T_ = '' "
				
				MEMOWRIT("RFAT02.SQL", CQUERY)
				TCQUERY CQUERY NEW ALIAS "TTX"
				Dbselectarea("TTX")
				_nVALOR := TTX->_XXX//-----------------------------------------------pega o valor total do kit
				TTX->(DBCLOSEAREA())
				
				
				dbSelectArea("SB1")
				dbSetOrder(1)
				Dbseek(Xfilial("SB1") + _cCODIGO)
				
				cVLCUSTO := SB1->B1_VLCUSTO

				IF SB1->B1_TPMOEDA = "D"
					_MOEDA := _DOLAR
				ELSEIF SB1->B1_TPMOEDA = "E"
					_MOEDA := _EURO
				ELSE
					_MOEDA := 1
				ENDIF
				
				IF SB1->B1_FTLUCRO > 0 .AND. cCUSTO > 0 .AND. _MOEDA > 0
					
					RECLOCK("SB1",.F.)
					SB1->B1_TPMOEDA	 :=		"R"
					SB1->B1_VLCUSTO  :=     _nVALOR
					SB1->B1_VERCOM   :=     _nVALOR
					SB1->B1_VLBRUTO  :=		(_nVALOR *SB1->B1_FTLUCRO)
					SB1->B1_VLFIM1   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ1)/100)
					SB1->B1_VLFIM2   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ2)/100)
					SB1->B1_VLFIM3   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ3)/100)
					SB1->B1_VLFIM4   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ4)/100)
					SB1->B1_VLFIM5   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ5)/100)
					SB1->B1_VLFIM6   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ6)/100)
					SB1->B1_VLFIM7   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ7)/100)
					MSUNLOCK("SB1")
					//				_ncont2 := _ncont2+1
				ELSE
					MSGALERT("VERIFICAR O CADASTRO DO PRODUTO COD :"+_cCODIGO+"  FATOR DE LUCRO, VALOR DE CUSTO E MOEDA")
				END IF
			ENDIF
		ENDIF                 
	EndIf
	dbselectarea("SB1")
	dbskip()
	_cCODIGO := SB1->B1_COD
	_XXX := 0
	_nVALOR :=0
END
	
//	DBSELECTAREA("SB1")
//	DBSETORDER(1)
//	dbseek (xfilial("SB1")+_cCODIGO)
//	_cCODIGO := SB1->B1_COD
//msgalert("Foram atualizados"+_ncont2+" KT")

SB1->(dbclosearea())
MSGALERT("PRODUTOS ATUALIZADOS COM SUCESSO")

//	MSGALERT("FORAM "+_ncont+" PRODUTOS ATUALIZADOS COM SUCESSO")
//ELSEIF _DOLAR <= 0 .AND. _EURO <= 0
//	MSGALERT("MOEDAS ESTRANGEIRAS DESTUALIZADAS - FAVOR ATUALIZAR")
//ENDIF
Return