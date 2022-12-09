#INCLUDE "PROTHEUS.CH"

USER FUNCTION MKCADSE2()
	Local aFixo := {}
	Local aTam  := {}

	PRIVATE cCadastro := "TÍTULOS A PAGAR - "+SM0->M0_NOMECOM
	PRIVATE aRotina   := MenuDef()
	PRIVATE aRotAlt   := {|| SOALTSD2() }
	PRIVATE nOldValor := 0  
	PRIVATE nOldSaldo := 0
	PRIVATE nOldIss	:= 0
	PRIVATE nOldIrr	:= 0
	PRIVATE nOldInss  := 0
	PRIVATE nOldSEST  := 0
	PRIVATE nValorAnt := 0
	PRIVATE nMaxParc  := 0
	PRIVATE nOldPis	:= 0
	PRIVATE nOldCofins:= 0
	PRIVATE nOldCsll	:= 0
	PRIVATE nOldCID   := 0
	PRIVATE nVlRetPis	:= 0
	PRIVATE nVlRetCof := 0
	PRIVATE nVlRetCsl	:= 0 
	PRIVATE aColsSev	:= {} // Utilizada em MultNat2 e GravaSev
	PRIVATE aHeaderSev:= {} // Utilizada em MultNat2 e GravaSev
	PRIVATE lIRProg	:= "2"
	Private Valor5 := 0
	Private Valor6 := 0
	Private Valor7 := 0
	PRIVATE cModRetPIS := GetNewPar( "MV_RT10925", "1" )
	PRIVATE nIndexSE2 := ""
	PRIVATE aDadosRef := Array(7)
	PRIVATE aDadosRet := Array(7)
	PRIVATE aDadosImp := Array(3)
	PRIVATE cIndexSE2 := ""
	Private cOldNaturez
	PRIVATE lAlterNat := .F.
	Private nRecnoNdf := 0
	Private nDifPcc   := 0
	Private nOldValorPg := 0
	PRIVATE lAltValor := .F.
	PRIVATE aTrocaF3  := {}
	Private cSE2TpDsd := ""  // variável utilizada pelo PMS
	Private cTipoParaAbater := ""
	PRIVATE lIntegracao := IF(GetMV("MV_EASY")=="S",.T.,.F.)
	//Campo para alimentar o campo E2_EMIS1
	PRIVATE dDataEmis1	:= Nil	
	mBrowse( 6 , 1 , 22 , 75 , "SE2" ,  )
RETURN


STATIC FUNCTION MenuDef()
	Local aRotina   := {{ "Pesquisa"         , "AxPesqui" , 0 , 1  },;
	{ "Visualizar"       , "AxVisual" , 0 , 2  },;
	{ "Incluir"       	 , " "        , 0 , 3  },;
	{ "Alterar"          , "EVAL(aRotAlt)" , 0 , 4  }}                      
RETURN aRotina


STATIC FUNCTION SOALTSD2()
	Local aVisCpo   := {}
	Local aCampoSD2 := {"E2_VENCREA"}
	Local aSX3E2    := {}
	Local nDic      := 0

	Private lAltera := .T.
	Private DVENCREAANT := SE2->E2_VENCREA
	Private NOLDVALOR := SE2->E2_VALOR
	PRIVATE aDadosImp := Array(3)

	If Alltrim(SE2->E2_PREFIXO) == "EIC"
		aSX3E2 := FWSX3UTIL():GETALLFIEDS("SE2",.F.)
		FOR nDic := 1 to len(aSX3E2)
			If X3USO(GETSX3CACHE(aSX3X2[nDic],"X3_USADO"))
				aAdd( aVisCpo , GETSX3CACHE(aSX3X2[nDic],"X3_CAMPO"))
			Endif
		next nDic
		AxAltera("SE2" , SE2->(RECNO()) , 4 , aVisCpo , aCampoSD2 )
	Endif

RETURN