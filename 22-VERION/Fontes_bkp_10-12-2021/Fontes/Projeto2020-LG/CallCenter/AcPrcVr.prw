#Include "Rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
* Manutencao na formacao de preco individual
* R.Cavalini
* Ricardo Cavalini --> 03/04/2018
*/

User Function AcPrcVr()

Dbselectarea("SB1")
DbsetOrder(1)

aRotina:={{"Pesquisar"   ,"AxPesqui"    ,0,1},;
{"Calcular"    ,"U_ArCalVr()" ,0,4}}

mBrowse( 6,1,22,75,"SB1",,,,,,,,)

Dbselectarea("SB1")
DbSetOrder(1)

return

/*
Fun��o de ajuste de data limite.
*/
User Function ArCalVr()
_cPrdto := SB1->B1_COD
_cEstrt := SB1->B1_ESTRUT
_DOLAR  := 0
_EURO   := 0
_TAX    := 0
cCUSTO  := 0
_MOEDA  := 0
_WFATOR := 0
_WGRUPO := ""

//     CAPTURA VALORES ESTRANGEIROS - MOEDAS/DESPESA     //
CQUERY	:=	"SELECT TOP (1) M2_MOEDA2 , M2_MOEDA4, M2_DATA, M2_TXDESP"
CQUERY	+=	"	FROM " + RetSqlName("SM2") + " SM2010 "
CQUERY	+=	"	WHERE SM2010.D_E_L_E_T_ = '' and M2_DATA = '"+dtos(ddatabase)  +"' "
CQUERY	+=	"   ORDER BY M2_DATA DESC"

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

// INICIO DE RECALCULO
IF _cEstrt == '3'  // ===> CALCULO DE PECAS
	__prcpca(_cPrdto)
ELSE
	
	// SEPARA PECA E SUBKIT
	__prcskt(_cPrdto)
	
	// CALCULA PRODUTO PRINCIPAL
	__pKITVB(_cPrdto)
ENDIF


Return

// tratamento para calculo de PECAS E SUB KIT
static function __prcskt(_cverprd)
 Local RC
 Local GL
__APECAS  := {}
__ASBKIT  := {}
__AKITVB  := {}
__cQUER01 := ""

__cQUER01 := "SELECT G1_COD,G1_COMP,B1_ESTRUT  FROM " + RetSqlName("SG1") + " G11B "
__cQUER01 += " INNER JOIN " + RetSqlName("SB1") + " B11B ON B11B.B1_COD = G11B.G1_COMP AND B11B.B1_ESTRUT IN ('1','2','3') AND B11B.D_E_L_E_T_ = '' "
__cQUER01 += " WHERE G1_COD =  ' " + _cverprd + "' AND G11B.D_E_L_E_T_ = '' "
__cQUER01 += " UNION ALL "
__cQUER01 += " SELECT G1_COD,G1_COMP,B1_ESTRUT  FROM " + RetSqlName("SG1") + "  G11A "
__cQUER01 += " INNER JOIN " + RetSqlName("SB1") + " B11A ON B11A.B1_COD = G11A.G1_COMP AND B11A.B1_ESTRUT IN ('1','2','3') AND B11A.D_E_L_E_T_ = '' "
__cQUER01 += " WHERE G1_COD IN ( SELECT G1_COMP FROM " + RetSqlName("SG1") + " G11B "
__cQUER01 += " INNER JOIN " + RetSqlName("SB1") + " B11B ON B11B.B1_COD = G11B.G1_COMP AND B11B.B1_ESTRUT IN ('1','2') AND B11B.D_E_L_E_T_ = '' "
__cQUER01 += " WHERE G1_COD =  ' " + _cverprd + "' AND G11B.D_E_L_E_T_ = '') "
__cQUER01 += " UNION ALL "
__cQUER01 += " SELECT G1_COD,G1_COMP,B1_ESTRUT  FROM " + RetSqlName("SG1") + " (NOLOCK) "
__cQUER01 += " INNER JOIN " + RetSqlName("SB1") + " B12B ON B12B.B1_COD = G12B.G1_COMP AND B12B.B1_ESTRUT IN ('1','2','3') AND B12B.D_E_L_E_T_ = '' "
__cQUER01 += " WHERE G1_COD IN (SELECT G1_COMP FROM " + RetSqlName("SG1") + "  G11A "
__cQUER01 += " INNER JOIN " + RetSqlName("SB1") + " B11A ON B11A.B1_COD = G11A.G1_COMP AND B11A.B1_ESTRUT IN ('1','2') AND B11A.D_E_L_E_T_ = '' "
__cQUER01 += " WHERE G1_COD IN ( SELECT G1_COMP FROM " + RetSqlName("SG1") + " G11B "
__cQUER01 += " INNER JOIN " + RetSqlName("SB1") + " B11B ON B11B.B1_COD = G11B.G1_COMP AND B11B.B1_ESTRUT IN ('1','2') AND B11B.D_E_L_E_T_ = '' "
__cQUER01 += " WHERE G1_COD =  ' " + _cverprd + "' AND G11B.D_E_L_E_T_ = '') AND G11A.D_E_L_E_T_ = '')  AND G12B.D_E_L_E_T_ = '' "
__cQUER01 += " ORDER BY 1 "

TCQUERY __cQUER01 NEW ALIAS "CCSKT"

DBSELECTAREA("CCSKT")
DBGOTOP()
WHILE !EOF()
	
	IF ALLTRIM(CCSKT->B1_ESTRUT) == "3" // PECAS
		
		If Ascan(AADD(__APECAS,{CCSKT->G1_COMP})) == 0
			AADD(__APECAS,{CCSKT->G1_COMP})
		ENDIF
		
	ELSEIF ALLTRIM(CCSKT->B1_ESTRUT) == "2"  // SUB KIT
		
		If Ascan(AADD(__ASBKIT,{CCSKT->G1_COMP})) == 0
			AADD(__ASBKIT,{CCSKT->G1_COMP})
		ENDIF
		
	ELSEIF ALLTRIM(CCSKT->B1_ESTRUT) == "1"  // KIT
		
		If Ascan(AADD(__AKITVB,{CCSKT->G1_COMP})) == 0
			AADD(__AKITVB,{CCSKT->G1_COMP})
		ENDIF
		
	ENDIF
	
	DBSELECTAREA("CCSKT")
	DBSKIP()
	LOOP
END


// CALCULA AS PECAS
IF LEN(__APECAS) > 0
	FOR RC := 1 TO LEN(__APECAS)
		__CPRXCV := __APECAS[RC,1]
		__prcpca(__CPRXCV)
	NEXT
ENDIF

// CALCULO OS SUB KIT
IF LEN(__ASBKIT) > 0
	FOR GL := 1 TO LEN(__ASBKIT)
		__CPRXKT := __ASBKIT[GL,1]
		__prXSKT(__CPRXKT)
	NEXT
ENDIF


// CALCULO OS SUB KIT
IF LEN(__AKITVB) > 0
	FOR GL := 1 TO LEN(__AKITVB)
		__CPRXKT := __AKITVB[GL,1]
		__pKITVB(__CPRXKT)
	NEXT
ENDIF

RETURN


// CALCULO DE PECAS (( PADRAO ))
static function __prcpca(_cverprd)
cCUSTO  := 0
_MOEDA  := 0
_WFATOR := 0
_WGRUPO := ""

DBSELECTAREA("SB1")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SB1")+_cverprd)
	
	
	// TRATAMENTO VERION
	IF SM0->M0_CODIGO == "01"
		cCUSTO :=  IIF(SB1->B1_VERCOM > 0,SB1->B1_VERCOM,IIF(SB1->B1_CUSTD > 0,SB1->B1_CUSTD,IIF(SB1->B1_UPRC > 0,SB1->B1_UPRC,0)))
	ELSE
		cCUSTO := SB1->B1_VLCUSTO
	ENDIF
	
	IF SB1->B1_TPMOEDA = "D"
		_MOEDA := _DOLAR
	ELSEIF SB1->B1_TPMOEDA = "E"
		_MOEDA := _EURO
	ELSE
		_MOEDA := 1
	ENDIF
	
	_WFATOR   := SB1->B1_FATOR
	_WGRUPO   := SB1->B1_GRUPO
	
	dbSelectArea("SBM")
	dbSeek(xFilial()+_WGRUPO)
	
	IF _WFATOR == 0
		_WFATOR := SBM->BM_FATOR
	Endif
	
	// TRATAMENTO DE MOEDAS VERION
	IF SM0->M0_CODIGO == "01" .AND. EMPTY(SB1->B1_TPMOEDA)
		IF SBM->BM_MOEDA = "D"
			_MOEDA := _DOLAR
		ELSEIF SBM->BM_MOEDA = "E"
			_MOEDA := _EURO
		ELSE
			_MOEDA := 1
		ENDIF
	ENDIF
	
	IF 	_WFATOR > 0 .AND. cCUSTO > 0 .AND. _MOEDA > 0
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
		
	ELSE
		
		IF _WFATOR = 0
			MSGSTOP("Fator zerado, impossivel de fazer calculo !!!")
		ENDIF
		
		IF CCUSTO = 0
			MSGSTOP("Valor de base de calculo zerado, impossivel de fazer calculo !!!")
		ENDIF
		
		IF _MOEDA = 0
			MSGSTOP("Valor de Moeda nao cadastrado, impossivel de fazer calculo !!!")
		ENDIF
	ENDIF
ELSE
	MSGSTOP("Produto nao encontrado....")
ENDIF
Return


// CALCULO DE SUB KIT (( PADRAO ))
static function __prXSKT(_cverprd)
cCUSTO  := 0
_MOEDA  := 0
_WFATOR := 0
_nVALOR := 0
_WGRUPO := ""
CQUERY	:= ""

CQUERY	:=	"SELECT SUM(B1_VLBRUTO*G1_QUANT) AS _XXX "
CQUERY	+=	"	FROM "+RetSqlName("SG1")+" G1, "+RetSqlName("SB1")+" B1 "
CQUERY	+=	"	WHERE G1_COD = '" + _cverprd + "' "
CQUERY	+=	"	AND G1_COMP = B1_COD "
CQUERY	+=	"	AND G1.D_E_L_E_T_ = '' "
CQUERY	+=	"	AND B1.D_E_L_E_T_ = '' "

TCQUERY CQUERY NEW ALIAS "TOX"

Dbselectarea("TOX")
_nVALOR := TOX->_XXX

TOX->(DBCLOSEAREA())

dbSelectArea("SB1")
dbSetOrder(1)
Dbseek(Xfilial("SB1") + _cverprd)

CCUSTO := _nVALOR

IF SB1->B1_TPMOEDA = "D"
	_MOEDA := _DOLAR
ELSEIF SB1->B1_TPMOEDA = "E"
	_MOEDA := _EURO
ELSE
	_MOEDA := 1
ENDIF

// INCLUSAO 22_06_2017 - ANTES NAO TINHA ESTA LINHA
_WFATOR   := SB1->B1_FATOR
_WGRUPO   := SB1->B1_GRUPO

dbSelectArea("SBM")
dbSeek(xFilial()+_WGRUPO)

IF _WFATOR == 0
	_WFATOR := SBM->BM_FATOR
Endif

// TRATAMENTO DE MOEDAS VERION
IF SM0->M0_CODIGO == "01" .AND. EMPTY(SB1->B1_TPMOEDA)
	IF SBM->BM_MOEDA = "D"
		_MOEDA := _DOLAR
	ELSEIF SBM->BM_MOEDA = "E"
		_MOEDA := _EURO
	ELSE
		_MOEDA := 1
	ENDIF
ENDIF

IF 	_WFATOR > 0 .AND. cCUSTO > 0 .AND. _MOEDA > 0
	
	RECLOCK("SB1",.F.)
	
	SB1->B1_VLCUSTO  :=     _nVALOR
	IF SUBSTR(_WGRUPO,1,2) $ "VB|Y-"
		SB1->B1_VERCOM   :=     _nVALOR
	ENDIF
	SB1->B1_VLBRUTO  :=		(_nVALOR * iif(SB1->B1_FTLUCRO=0,1,SB1->B1_FTLUCRO))
	SB1->B1_VLFIM1   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ1)/100)
	SB1->B1_VLFIM2   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ2)/100)
	SB1->B1_VLFIM3   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ3)/100)
	SB1->B1_VLFIM4   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ4)/100)
	SB1->B1_VLFIM5   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ5)/100)
	SB1->B1_VLFIM6   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ6)/100)
	SB1->B1_VLFIM7   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ7)/100)
	MSUNLOCK("SB1")
ELSE
	IF _WFATOR = 0
		MSGSTOP("Fator zerado, impossivel de fazer calculo !!!")
	ENDIF
	
	IF CCUSTO = 0
		MSGSTOP("Valor de base de calculo zerado, impossivel de fazer calculo !!!")
	ENDIF
	
	IF _MOEDA = 0
		MSGSTOP("Valor de Moeda nao cadastrado, impossivel de fazer calculo !!!")
	ENDIF
	
ENDIF
Return

// CALCULO DO PRODUTO PRINCIPAL
static function __pKITVB(_cverprd)
cCUSTO  := 0
_MOEDA  := 0
_WFATOR := 0
_nVALOR := 0
_WGRUPO := ""
CQUERY	:= ""

dbSelectArea("SG1")
dbSetOrder(1)
If dbSeek(xFilial("SG1")+_cverprd)
	
	CQUERY	:=	"SELECT SUM(B1_VLBRUTO*G1_QUANT) AS _XXX "
	CQUERY	+=	"	FROM "+RetSqlName("SG1")+" G1, "+RetSqlName("SB1")+" B1 "
	CQUERY	+=	"	WHERE G1_COD = '"+ALLTRIM(_cverprd)+"' "
	CQUERY	+=	"	AND G1_COMP = B1_COD "
	CQUERY	+=	"	AND G1.D_E_L_E_T_ = '' "
	CQUERY	+=	"	AND B1.D_E_L_E_T_ = '' "
	
	MEMOWRIT("RFAT02.SQL", CQUERY)
	TCQUERY CQUERY NEW ALIAS "TTX"
	Dbselectarea("TTX")
	_nVALOR := TTX->_XXX //-----------------------------------------------pega o valor total do kit
	TTX->(DBCLOSEAREA())
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	Dbseek(Xfilial("SB1") + _cverprd)
	
	//cCUSTO := SB1->B1_VLCUSTO
	CCUSTO := _nVALOR
	
	// INCLUSAO 22_06_2017 - ANTES NAO TINHA ESTA LINHA
	_WFATOR   := SB1->B1_FATOR
	_WGRUPO   := SB1->B1_GRUPO
	
	dbSelectArea("SBM")
	dbSeek(xFilial()+_WGRUPO)
	
	IF _WFATOR == 0
		_WFATOR := SBM->BM_FATOR
	Endif
	
	IF SB1->B1_TPMOEDA = "D"
		_MOEDA := _DOLAR
	ELSEIF SB1->B1_TPMOEDA = "E"
		_MOEDA := _EURO
	ELSE
		_MOEDA := 1
	ENDIF
	
	IF _WFATOR > 0 .AND. cCUSTO > 0 .AND. _MOEDA > 0
		RECLOCK("SB1",.F.)
		//SB1->B1_TPMOEDA	 :=		"R"
		SB1->B1_VLCUSTO  :=     _nVALOR
		IF SUBSTR(_WGRUPO,1,2) $ "VB|Y-"
			SB1->B1_VERCOM   :=     _nVALOR
		ENDIF
		SB1->B1_VLBRUTO  :=		_nVALOR   //(_nVALOR * iif(SB1->B1_FTLUCRO=0,1,SB1->B1_FTLUCRO))
		SB1->B1_VLFIM1   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ1)/100)
		SB1->B1_VLFIM2   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ2)/100)
		SB1->B1_VLFIM3   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ3)/100)
		SB1->B1_VLFIM4   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ4)/100)
		SB1->B1_VLFIM5   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ5)/100)
		SB1->B1_VLFIM6   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ6)/100)
		SB1->B1_VLFIM7   := 	SB1->B1_VLBRUTO / ((100-SB1->B1_ALIQ7)/100)
		MSUNLOCK("SB1")
	ELSE
		IF _WFATOR = 0
			MSGSTOP("Fator zerado, impossivel de fazer calculo !!!")
		ENDIF
		
		IF CCUSTO = 0
			MSGSTOP("Valor de base de calculo zerado, impossivel de fazer calculo !!!")
		ENDIF
		
		IF _MOEDA = 0
			MSGSTOP("Valor de Moeda nao cadastrado, impossivel de fazer calculo !!!")
		ENDIF
	ENDIF
Endif
Return