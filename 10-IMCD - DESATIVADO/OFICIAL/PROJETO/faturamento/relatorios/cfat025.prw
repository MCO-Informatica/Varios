#include "PROTHEUS.CH"
#include "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   ³ CFAT025  ºAutor  ³  Daniel   Gondran  º Data ³  14/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.      ³ Relatorio Sequencia NF Saida                               º±±
±±º           ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso        ³ Makeni                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Data      ³                          Manutencao                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º 12/07/2018³ Ajustado para buscar notas pelo Totvs Colaboracao          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CFAT025
Local cPerg := "CFAT025"

Private lUsaColab := UsaColaboracao("1")
Private aCabec := {"SERIE / NUMERO","DATA TRANSM","HORA TRANSM","PROTOCOLO","INFO","DATA EMISSAO","HORA EMISSAO","AMBIENTE","MODALIDADE","TIPO"}
Private aDados :={}

If .NOT. Pergunte( cPerg, .T.)
	RETURN()
endif


IF lUsaColab
	Processa( { || IMPC25COL() }, "Processando Relatório de Sequencia NF, VIA TOTVS COLABORACAO. Aguarde..." )
ELSE
	Processa( { || IMPC25() }, "Processando Relatório de Sequencia NF, VIA TSS. Aguarde..." )
ENDIF

IF LEN(aDados) > 0
	DlgToExcel({ {"ARRAY", "SEQUENCIA DADOS", aCabec, aDados} })
ELSE
	ALERT("NÃO HÁ DADOS. rEVISAR OS PARAMETROS")
ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Impc25    ºAutor  ³  Daniel   Gondran  º Data ³  14/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta dados a serem exibidos                               º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IMPC25()
Local aAreaAtu := GetArea()
Local cQuery:=""

Local cOrigem
Local cHora  := ''
Local cData  := ''
Local cTipo  := ''

Local cAlias   := GetNextAlias()

cQuery := "SELECT DISTINCT SPED054.NFE_ID, DTREC_SEFR, HRREC_SEFR, SPED054.NFE_PROT, XMOT_SEFR, F2_EMISSAO, F2_HORA, AMBIENTE, MODALIDADE "
cQuery += " FROM SPED050, SPED054 "
cQuery += " LEFT JOIN SF2010 ON "
cQuery += " F2_SERIE = SUBSTRING(SPED054.NFE_ID,1,3) AND F2_DOC = SUBSTRING(SPED054.NFE_ID,4,9) "
cQuery += "  WHERE DATE_ENFE  >= '" + DTOS(MV_PAR01) +  "' AND DATE_ENFE  <= '" + DTOS(MV_PAR02) + "' "
cQuery += "  AND SPED050.NFE_ID = SPED054.NFE_ID "
cQuery += "  AND SPED050.NFE_PROT = SPED054.NFE_PROT "
cQuery += " ORDER BY DTREC_SEFR, HRREC_SEFR "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"NOTAS",.F.,.T.)
dbSelectArea("NOTAS")
dbGotop()
Do While !Notas->(EOF())
	If Empty(NOTAS->F2_EMISSAO)
		dbSelectArea("SF1")
		dbSetOrder(1)
		dbSeek(xFilial("SF1") + Substr(NOTAS->NFE_ID,4,9) + Substr(NOTAS->NFE_ID,1,3))
		lAchou := .F.
		do While !lAchou .and. !Eof() .and. SF1->F1_DOC == Substr(NOTAS->NFE_ID,4,9) .and. SF1->F1_SERIE == Substr(NOTAS->NFE_ID,1,3)
			cData 	:= F1_EMISSAO
			cFormul := F1_FORMUL
			If cData >= MV_PAR01 .and. cData <= MV_PAR02 .and. cFormul == "S"
				lAchou := .T.
			Endif
			dbSkip()
		Enddo
		dbSelectArea("NOTAS")
		If !lAchou
			NOTAS->(dbSkip())
			Loop
		Endif
		cData := Dtos(cData)
		cData := SUBSTR(cData,7,2)+"/"+SUBSTR(cData,5,2)+"/"+Substr(cData,1,4)
		cHora := Posicione("SF1",1,xFilial("SF1") + Substr(NOTAS->NFE_ID,4,9) + Substr(NOTAS->NFE_ID,1,3),"F1_HORA")
		cTipo := "ENTRADA"
	Else
		If LEFT(NOTAS->XMOT_SEFR,1) <> "I"
			If NOTAS->F2_EMISSAO < DTOS(MV_PAR01) .or. NOTAS->F2_EMISSAO > DTOS(MV_PAR02)
				NOTAS->(dbSkip())
				Loop
			Endif
		Endif
		cData := SUBSTR(NOTAS->F2_EMISSAO,7,2)+"/"+SUBSTR(NOTAS->F2_EMISSAO,5,2)+"/"+Substr(NOTAS->F2_EMISSAO,1,4)
		cHora := NOTAS->F2_HORA
		cTipo := "SAIDA"
	Endif
	
	Aadd(aDados,{AllTrim(NOTAS->NFE_ID),;
	Substr(NOTAS->DTREC_SEFR,7,2)+"/"+Substr(NOTAS->DTREC_SEFR,5,2)+"/"+Substr(NOTAS->DTREC_SEFR,1,4),;
	NOTAS->HRREC_SEFR,;
	"'"+ NOTAS->NFE_PROT,;
	NOTAS->XMOT_SEFR,;
	cData,;
	cHora,;
	IIF(NOTAS->AMBIENTE==1,"Produção","Homologação"),;
	IIF(NOTAS->MODALIDADE==1,"Normal","Contingência"),;
	cTipo})
	DBSKIP()
ENDDO


//DlgToExcel({ {"ARRAY", "SEQUENCIA DADOS", aCabec, aDados} })

If Select("Notas") > 0
	Notas->( dbCloseArea() )
EndIf

Return


Static Function IMPC25COL() // USANDO COLABORACAO


Local aParametro := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}
Local aRetorno :={}


Local cURL	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)

Local cIdEnt	 := ""
Local cModelo 	 := '55'
Local nTpMonitor :=  1
Local lMsg		 := .T.
Local lCTE		 := .F.
Local lMDFe		 := .F.
Local lTMS		 := .F.
Local cAviso 	:= ""
Local cAlias   := GetNextAlias()

cQuery := "SELECT F2_FILIAL, F2_DOC DOC, F2_SERIE SERIE , F2_EMISSAO EMISSAO, F2_HORA HORA, 'SAIDA' TIPO "
cQuery += " FROM "+RETSQLNAME("SF2")
cQuery += " WHERE F2_EMISSAO  BETWEEN  '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "'
cQuery += " AND F2_FILIAL = '"+XFILIAL("SF2")+"' "

cQuery += " UNION ALL "

cQuery += " SELECT F1_FILIAL, F1_DOC DOC, F1_SERIE SERIE, F1_EMISSAO EMISSAO, F1_HORA HORA, 'ENTRADA' TIPO "
cQuery += " FROM "+RETSQLNAME("SF1")
cQuery += " WHERE F1_EMISSAO  BETWEEN  '" + DTOS(MV_PAR01) +  "' AND '" + DTOS(MV_PAR02) +  "'
cQuery += " AND F1_FORMUL = 'S'
cQuery += " AND F1_FILIAL = '"+XFILIAL("SF1")+"' "
cQuery += " ORDER BY 1, 3, 2

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"NOTAS",.F.,.T.)
//TCSetField( "NOTAS","EMISSAO","D",08,0 )


dbSelectArea("NOTAS")
dbGotop()
ProcRegua( NOTAS->(RecCount()))

Do While !Notas->(EOF())
	
	aParametro[01] := NOTAS->SERIE	//serie
	aParametro[02] := NOTAS->DOC	//nota inicial
	aParametro[03] := NOTAS->DOC	//nota final
	
	aRetorno := colNfeMonProc( aParametro, nTpMonitor, cModelo, lCte, @cAviso, lMDfe, lTMS ,lUsaColab )

	
	IF LEN(aRetorno) > 0
		IncProc('Processando Notas '+aRetorno[1,1]+', aguarde...')   
		cDtTrans := DTOS(aRetorno[1,15,6])
		cDtTrans := SUBSTR(cDtTrans,7,2)+"/"+SUBSTR(cDtTrans,5,2)+"/"+Substr(cDtTrans,1,4)
		cDtGer := SUBSTR(NOTAS->EMISSAO,7,2)+"/"+SUBSTR(NOTAS->EMISSAO,5,2)+"/"+Substr(NOTAS->EMISSAO,1,4)
		Aadd(aDados,{aRetorno[1,1],;
		cDtTrans,;
		SUBSTR(aRetorno[1,15,5],1,8),;
		"'"+aRetorno[1,4],;
		alltrim(aRetorno[1,6]),;
		cDtGer,;
		NOTAS->HORA,;
		IIF(aRetorno[1][7]==1,"Produção","Homologação"),;
		IIF(aRetorno[1][8]==1,"Normal","Contingência"),;
		NOTAS->TIPO })
	ENDIF
	NOTAS->(DBSKIP())
	
ENDDO

//DlgToExcel({ {"ARRAY", "SEQUENCIA DADOS", aCabec, aDados} })

If Select("NOTAS") > 0
	NOTAS->( DBCLOSEAREA() )
EndIf

Return()
