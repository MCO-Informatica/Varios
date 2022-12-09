#INCLUDE "PROTHEUS.CH"
#INCLUDE "REPORT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CRPR010  บ Autor ณ Tatiana Pontes 	   บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Emissao dos valores apurados nos lancamentos para 	      บฑฑ
ฑฑบ          ณ de remuneracao de parceiros							      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                             

User Function CRPR010()

	Local aSay := {}
	Local aButton := {}
	Local nOpcao := 0
	
	Private l010Query := .F. 
	Private cDescriRel := "Previsใo de remunera็ใo a pagar"

	SetKey( VK_F12 , {|| l010Query := MsgYesNo('Exportar a string da query principal?',cCadastro ) } )

	AAdd( aSay, "Emite uma rela็ใo das previs๕es dos valores de remunera็ใo" )
	AAdd( aSay, "a pagar com base nos lan็amentos em aberto." )
	AAdd( aSay, "" )   
	AAdd( aSay, "A emissใo ocorrerแ baseada nos parโmetros do relat๓rio." )
	
	AAdd( aButton, { 01, .T., { || nOpcao := 1, FechaBatch() } } )
	AAdd( aButton, { 22, .T., { || FechaBatch() } } )
	
	FormBatch( cDescriRel, aSay, aButton )
	
	SetKey( VK_F12 , NIL )

	If nOpcao==1
		R010Param()
	Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ R010Param บ Autor ณ Tatiana Pontes 	   บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de parametros para usuario informar		 	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                             

Static Function R010Param()

	Local aPar := {}
	Local aRet := {}
	Local aOpcVisao := {}	
	
	Local nI := 0
	
	Local cDado := ''
	Local cFunc := ''
	
	Private nFont := 0
	Private n010Visao := 0
	Private nColSpace := 0   
	
	Private cFont := ''
	Private cOrient := ''
	Private c010Visao := ''
	Private c010EntDe := ''
	Private c010EntAte := ''
	Private c010Rede := ''
	Private c010CCR	:= ''
	Private d010PerDe := Ctod(Space(8))
	Private d010PerAte := Ctod(Space(8))
	
	Private aCab := {}
	Private aDados := {}
	Private aDados2 := {}
	Private aAlign := {}
	Private aParam := {}
	Private aSizeCol := {}
	Private aPicture := {}
	
	aOpcVisao := {'Por Produto Sint้tico',;                                 	// 1
	              'Por Campanha Contador e Clube Revendedor',;					// 2
	              'Por Posto Sint้tico',;										// 3
	              'Por Produto Analํtico com Campanha Contador',;				// 4
	              'Por Posto Analํtico com Impostos',;							// 5
	              'Por Produto Analํtico com Campanha Contador',;				// 6
	              'Por Posto com Campanha Contador',;							// 7
	              'Por Data de Verifica็ใo'}									// 8

	AAdd( aPar, { 3, 'Qual visใo'                              		,1 , aOpcVisao                     	, 99, '', .T. } )
	AAdd( aPar, { 1, 'Perํodo de'	,Ctod(Space(8))            		,'',''                    ,''      	, '', 50, .F. } )
	AAdd( aPar, { 1, 'Perํodo at้'	,Ctod(Space(8))            		,'','(mv_par03>=mv_par02)',''      	, '', 50, .T. } )
	AAdd( aPar, { 1, 'Entidade de'	,Space(Len(SZ3->Z3_CODENT))	,'',''                    ,'SZ3'   	, '', 50, .F. } )
	AAdd( aPar, { 1, 'Entidade at้'	,Space(Len(SZ3->Z3_CODENT))	,'','(mv_par05>=mv_par04)','SZ3'   	, '', 50, .T. } )
	AAdd( aPar, { 1, 'Rede'			,Space(Len(SZA->ZA_CODCLA))	,'',''					  ,'SZA'   	, '', 50, .F. } )        
	AAdd( aPar, { 1, 'AR Comissใo'	,Space(Len(SZ3->Z3_CCRCOM))	,'',''					  ,'SZ3CCR'	, '', 50, .F. } )        	
	
	//cAux := __cUserID 
	//__cUserID := '000000'
	If !ParamBox( aPar, 'Parโmetros de processamento',@aRet) //,,,,,,,,.F.,.F.)
		Return                                              
	Endif
	//__cUserID := cAux
    
	c010Visao   := aOpcVisao[ aRet[ 1 ] ]
	n010Visao   := aRet[1]
	d010PerDe   := aRet[2]
	d010PerAte	:= aRet[3]
	c010EntDe  	:= aRet[4]
	c010EntAte	:= aRet[5]
	c010Rede   	:= aRet[6]
	c010CCR   	:= aRet[7]

	If n010Visao == 1
		cFunc := 'A010ProdSin()'
	Elseif n010Visao == 2
		cFunc := 'A010CCont()'
	Elseif n010Visao == 3
		cFunc := 'A010PostSin()'
	Elseif n010Visao == 4
		cFunc := 'A010ProdAna()'
	Elseif n010Visao == 5
		cFunc := 'A010PostAna()'
	Elseif n010Visao == 6      
		cFunc := 'A010ProdCC()'
	Elseif n010Visao == 7  
		cFunc := 'A010PostCC()'
	Elseif n010Visao == 8
		cFunc := 'A010DtVer()'
	Else
		MsgAlert('Nใo hแ processamento para esta visใo.',cCadastro)
	Endif
	
	Processa( {|| &(cFunc) }, cDescriRel,"Aguarde, processando os dados...", .F. ) 

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ A010ProdSin บ Autor ณ Tatiana Pontes    บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de processamento - (1) Por produto Sintetico        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A010ProdSin()

	Local cSQL 		:= ''
	Local cTRB 		:= ''
	Local cPrdGar 	:= ""
  	Local cDesProd	:= ""
	Local nElem 	:= 0

	Local cChvGar	:= ""
	Local nQtdVer 	:= 0
	Local nTotSw 	:= 0 
	Local nImpSw 	:= 0 
	Local nLiqSw 	:= 0
	Local nTotHw 	:= 0
	Local nImpHw 	:= 0
	Local nLiqHw 	:= 0
	Local nTotCom 	:= 0

	Local nT_QtdVer	:= 0
	Local nT_TotSw 	:= 0 
	Local nT_ImpSw 	:= 0 
	Local nT_LiqSw 	:= 0
	Local nT_TotHw 	:= 0
	Local nT_ImpHw 	:= 0
	Local nT_LiqHw 	:= 0
	Local nT_TotCom	:= 0
	
	Private oReport

	cSQL :=	" SELECT      	SZ5.Z5_PRODGAR, SZ5.Z5_DESPRO, SZ5.Z5_VALORSW, SZ5.Z5_VALORHW, SZ6.Z6_VLRPROD," +;
	        "    			SZ6.Z6_BASECOM, SZ6.Z6_VALCOM, SZ6.Z6_CATPROD, SZ5.Z5_PEDGAR, SZ4.Z4_IMPSOFT, SZ4.Z4_IMPHARD " +;
			" FROM        	" + RetSqlName("SZ5") + " SZ5 " +;
			" INNER JOIN  	" + RetSqlName("SZ6") + " SZ6 ON SZ5.Z5_PEDGAR = SZ6.Z6_PEDGAR " +;
			" INNER JOIN  	" + RetSqlName("SZ3") + " SZ3 ON SZ6.Z6_CODENT = SZ3.Z3_CODENT " +;
			" INNER JOIN	" + RetSqlName("SZ4") + " SZ4 ON SZ3.Z3_CODENT = SZ4.Z4_CODENT " +;
			" WHERE       	SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' AND " +;
			"				SZ6.Z6_FILIAL = '" + xFilial("SZ6") + "' AND " +;
	  		"				SZ5.Z5_COMISS = '2' AND " +;
	    	"				SZ5.Z5_DATVER BETWEEN "+ValToSql( d010PerDe )+" AND "+ValToSql( d010PerAte )+" AND " +;
	       	"     	  		SZ6.Z6_CODENT BETWEEN "+ValToSql( c010EntDe )+" AND "+ValToSql( c010EntAte )+" AND " 
		                                  
	If !Empty(c010Rede)
		cSQL +=	"     		SZ3.Z3_CLASSI = " +ValToSql( c010Rede )+ " AND "
	Endif

	If !Empty(c010CCR)
		cSQL +=	"      		SZ3.Z3_CCRCOM = " +ValToSql( c010CCR )+ " AND "
	Endif
 
	cSQL +=	"				SZ6.Z6_TIPO NOT IN ('CAMPCO','VERPAR') AND " +;
			"         		SZ5.D_E_L_E_T_ = ' ' AND SZ6.D_E_L_E_T_ = ' ' AND SZ3.D_E_L_E_T_ = ' ' AND SZ4.D_E_L_E_T_ = ' ' " +;
			" ORDER BY    	SZ5.Z5_PRODGAR, SZ5.Z5_PEDGAR"
	
	If l010Query
		A010Script( cSQL )   
	Endif

	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,"Extraindo informa็๕es...")	
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Nใo foi possํvel encontrar registros com os parโmetros informados.', cDescriRel)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	nColSpace := 2
	cFont := 'Courier New'
	nFont := 8
	cOrient := 'PAISAGEM'                                                                                                                               
	aCab := {'PRODUTO','DESCRIวรO PRODUTO','QTD','TOTAL SOFTWARE','IMP SOFT 5,65%','VALOR LIQ SOFT','TOTAL HARDWARE','IMPHARD 16,25%','VALOR LIQ HARD','  TOTAL REPASSE'}
	aAlign := {'LEFT','LEFT','LEFT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT'}
	aPicture := {'@!','@!','@E 9999','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99'}
	aSizeCol := {20,30,4,13,13,13,13,13,13,13}
	//           |  |  |  |  |  |  |  |  |  |
	//           |  |  |  |  |  |  |  |  |  +--> TOTAL REPASSE
	//           |  |  |  |  |  |  |  |  +-----> VAL LIQ HW
	//           |  |  |  |  |  |  |  +--------> IMP HW (16,25%)
	//           |  |  |  |  |  |  +-----------> TOTAL HW
	//           |  |  |  |  |  +--------------> VAL LIQ SW
	//           |  |  |  |  +-----------------> IMP SW (5,65%)
	//           |  |  |  +--------------------> TOTAL SW
	//           |  |  +-----------------------> QTD
	//           |  +--------------------------> DESCRICAO PRODUTO
	//           +-----------------------------> PRODUTO

	ProcRegua(0)

	cProdGar 	:= (cTRB)->Z5_PRODGAR     
	cDesProd	:= (cTRB)->Z5_DESPRO      
		
	While (cTRB)->( !Eof() )                  
	
		IncProc()

		If cChvGar <> (cTRB)->Z5_PEDGAR + (cTRB)->Z5_PRODGAR     
 			nQtdVer++
			cChvGar	:= (cTRB)->Z5_PEDGAR + (cTRB)->Z5_PRODGAR     		
		Endif
		
		nTotCom += (cTRB)->Z6_VALCOM		
		
		If (cTRB)->Z6_CATPROD $ "2" // Software
			nTotSw += (cTRB)->Z6_VLRPROD 
			If !Empty((cTRB)->Z4_IMPSOFT)
				nImpSw += (cTRB)->Z6_VLRPROD * ((cTRB)->Z4_IMPSOFT / 100)
			Endif
		Endif
		
		If (cTRB)->Z6_CATPROD $ "1" // Hardware
			nTotHw += (cTRB)->Z6_VLRPROD
			If !Empty((cTRB)->Z4_IMPHARD)    
				nImpHw += (cTRB)->Z6_VLRPROD * ((cTRB)->Z4_IMPHARD / 100)
			Endif                               
		Endif

		(cTRB)->( DbSkip() )

 		If cProdGar <> (cTRB)->Z5_PRODGAR
 		
 			nLiqSw		:= nTotSw - nImpSw
 			nLiqHw		:= nTotHw - nImpHw
			nT_QtdVer 	+= nQtdVer 
			nT_TotSw  	+= nTotSw 
			nT_ImpSw 	+= nImpSw 
			nT_LiqSw 	+= nLiqSw
			nT_TotHw 	+= nTotHw
			nT_ImpHw 	+= nImpHw
			nT_LiqHw 	+= nLiqHw
			nT_TotCom 	+= nTotCom
                                                                                                                                  
			AAdd( aDados, { cProdGar, cDesProd, nQtdVer, nTotSw, nImpSw, nLiqSw, nTotHw, nImpHw, nLiqHw, nTotCom } ) 
			
			cProdGar 	:= (cTRB)->Z5_PRODGAR    
			cDesProd	:= (cTRB)->Z5_DESPRO    
			nQtdVer 	:= 0
			nTotSw 		:= 0 
			nImpSw 		:= 0 
			nLiqSw 		:= 0
			nTotHw 		:= 0
			nImpHw 		:= 0
			nLiqHw 		:= 0
			nTotCom 	:= 0

		Endif
		
	End

	(cTRB)->( DbCloseArea() )
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'LINHA'
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL GERAL'
	aDados[ nElem, 3 ] := nT_QtdVer
	aDados[ nElem, 4 ] := nT_TotSw
	aDados[ nElem, 5 ] := nT_ImpSw
	aDados[ nElem, 6 ] := nT_LiqSw
	aDados[ nElem, 7 ] := nT_TotHw
	aDados[ nElem, 8 ] := nT_ImpHw
	aDados[ nElem, 9 ] := nT_LiqHw
	aDados[ nElem, 10 ] := nT_TotCom

	oReport := A010Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ A010CCont   บ Autor ณ Tatiana Pontes    บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de processamento - (2) Por Campanha do Contador     บฑฑ
ฑฑบ          ณ e Clube do Revendedor  									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A010CCont()

	Local cSQL 		:= ''
	Local cTRB 		:= ''
	Local nElem 	:= 0
	
	Local cNompar 	:= ''
	Local cPedgar 	:= ''
	Local cDatped 	:= ''
	Local cDatpag 	:= ''
	Local cDatver 	:= ''
	Local cProdgar 	:= ''
	Local cNomvend 	:= ''
	Local nTotSw	:= 0
	Local nTotHw	:= 0
	Local nVlrprod 	:= 0
	Local nValcom 	:= 0

	Local nT_TotPrd	:= 0 
	Local nT_TotCom	:= 0
	
	Private oReport

	cSQL :=	" SELECT      	SZ5.Z5_NOMPAR, SZ5.Z5_PEDGAR, SZ5.Z5_DATPED, SZ5.Z5_DATPAG, SZ5.Z5_PEDGAR, SZ5.Z5_DATVER, " +;
	        "    			SZ5.Z5_PRODGAR, SZ5.Z5_NOMVEND, SZ6.Z6_VLRPROD, SZ6.Z6_VALCOM, SZ6.Z6_CATPROD " +;
			" FROM        	" + RetSqlName("SZ5") + " SZ5 " +;
			" INNER JOIN  	" + RetSqlName("SZ6") + " SZ6 ON SZ5.Z5_PEDGAR = SZ6.Z6_PEDGAR " +;
			" INNER JOIN  	" + RetSqlName("SZ3") + " SZ3 ON SZ6.Z6_CODENT = SZ3.Z3_CODENT " +;
			" WHERE       	SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' AND " +;
			"				SZ6.Z6_FILIAL = '" + xFilial("SZ6") + "' AND " +;
	  		"				SZ5.Z5_COMISS = '2' AND " +;
	    	"				SZ5.Z5_DATVER BETWEEN "+ValToSql( d010PerDe )+" AND "+ValToSql( d010PerAte )+" AND " +;
	       	"     	  		SZ6.Z6_CODENT BETWEEN "+ValToSql( c010EntDe )+" AND "+ValToSql( c010EntAte )+" AND " 
		                                  
	If !Empty(c010Rede)
		cSQL +=	"     		SZ3.Z3_CLASSI = " +ValToSql( c010Rede )+ " AND "
	Endif

	If !Empty(c010CCR)
		cSQL +=	"      		SZ3.Z3_CCRCOM = " +ValToSql( c010CCR )+ " AND "
	Endif
 
	cSQL +=	"				SZ6.Z6_TIPO = 'CAMPCO' AND " +;
			"         		SZ5.D_E_L_E_T_ = ' ' AND SZ6.D_E_L_E_T_ = ' ' AND SZ3.D_E_L_E_T_ = ' ' " +;
			" ORDER BY    	SZ5.Z5_PEDGAR"
	
	If l010Query
		A010Script( cSQL )   
	Endif

	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,"Extraindo informa็๕es...")	
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Nใo foi possํvel encontrar registros com os parโmetros informados.', cDescriRel)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	nColSpace := 2
	cFont := 'Courier New'
	nFont := 8
	cOrient := 'PAISAGEM'                                                                                                                               
	aCab := {'PARCEIRO','PEDIDO','DATA PEDIDO','DATA CREDITO','DATA VERIFICAวรO','PRODUTO','VENDEDOR','VALOR PRODUTO','TOTAL REPASSE'}
	aAlign := {'LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','RIGHT','RIGHT'}
	aPicture := {'@!','@!','@!','@!','@!','@!','@!','@E 99,999,999.99','@E 99,999,999.99'}
	aSizeCol := {30,7,8,8,8,20,30,13,13}
	//           |  |  |  |  |  |  |  |  |
	//           |  |  |  |  |  |  |  |  +--> TOTAL REPASSE
	//           |  |  |  |  |  |  |  +-----> VALOR PRODUTO
	//           |  |  |  |  |  |  +--------> VENDEDOR
	//           |  |  |  |  |  +-----------> PRODUTO
	//           |  |  |  |  +--------------> DATA VERIFICACAO
	//           |  |  |  +-----------------> DATA CREDITO
	//           |  |  +--------------------> DATA PEDIDO
	//           |  +-----------------------> PEDIDO
	//           +--------------------------> PARCEIRO

	ProcRegua(0)                                                  		

	cKey := (cTRB)->Z5_PEDGAR 
	
	While (cTRB)->( !Eof() )                  
	
		IncProc()

		If (cTRB)->Z6_CATPROD $ "2" // Software
			nTotSw += (cTRB)->Z6_VLRPROD 
			nValcom += (cTRB)->Z6_VALCOM
		Endif
		
		If (cTRB)->Z6_CATPROD $ "1" // Hardware
			nTotHw += (cTRB)->Z6_VLRPROD
			nValcom += (cTRB)->Z6_VALCOM
		Endif

		cNompar 	:= (cTRB)->Z5_NOMPAR
		cPedgar 	:= (cTRB)->Z5_PEDGAR
		cDatped 	:= (cTRB)->Z5_DATPED
		cDatpag 	:= (cTRB)->Z5_DATPAG
		cDatver 	:= (cTRB)->Z5_DATVER
		cProdgar 	:= (cTRB)->Z5_PRODGAR
		cNomvend 	:= (cTRB)->Z5_NOMVEND
		nVlrprod 	:= nTotSw + nTotHw

		(cTRB)->( dbSkip() )

		If cKey <> (cTRB)->Z5_PEDGAR
		
			AAdd( aDados, { cNompar, cPedgar, cDatped, cDatpag, cDatver, cProdgar, cNomvend, nVlrprod, nValcom } ) 
	
			nT_TotPrd	+= nVlrprod 
			nT_TotCom	+= nValcom    

			nValcom := 0			
			nTotSw 	:= 0 
			nTotHw 	:= 0
			
			cKey := (cTRB)->Z5_PEDGAR
	    
	    Endif
	    
	End

	(cTRB)->( DbCloseArea() )
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'LINHA'
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL GERAL'
	aDados[ nElem, 8 ] := nT_TotPrd
	aDados[ nElem, 9 ] := nT_TotCom

	oReport := A010Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ A010PostSin บ Autor ณ Tatiana Pontes    บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de processamento - (3) Por Posto Sintetico   	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A010PostSin()

	Local cSQL 			:= ''
	Local cTRB 			:= ''
	Local cKey			:= ''      
	Local cPosto		:= ''
	Local nElem 		:= 0
	Local nTotCom		:= 0
	Local cDesPos 		:= ''
	Local cNomAge 		:= ''
	Local cProdGar 		:= ''
	Local cPedGar 		:= '' 
	Local dDatPed  		:= CtoD("  /  /  ")
	Local dDatVer 		:= CtoD("  /  /  ")
	Local nValor 		:= 0
	Local nValorSw 		:= 0
	Local nValorHw 		:= 0
	Local nT_TotPrd		:= 0 
	Local nT_TotSw 		:= 0 
	Local nT_TotHw 		:= 0
	Local nT_TotCom		:= 0    
	Local nT_EntPrd		:= 0 
	Local nT_EntSw 		:= 0 
	Local nT_EntHw 		:= 0
	Local nT_EntCom		:= 0

		
	Private oReport

	cSQL :=	" SELECT      	SZ5.Z5_CODPOS, SZ5.Z5_DESPOS, SZ5.Z5_NOMAGE, SZ5.Z5_PRODGAR, SZ5.Z5_PEDGAR, SZ5.Z5_DATPED, " +;
	        "    			SZ5.Z5_DATVER, SZ5.Z5_VALOR, SZ5.Z5_VALORSW, SZ5.Z5_VALORHW, SZ6.Z6_VALCOM, SZ6.Z6_TIPO " +;
			" FROM        	" + RetSqlName("SZ5") + " SZ5 " +;
			" INNER JOIN  	" + RetSqlName("SZ6") + " SZ6 ON SZ5.Z5_PEDGAR = SZ6.Z6_PEDGAR " +;
			" INNER JOIN  	" + RetSqlName("SZ3") + " SZ3 ON SZ6.Z6_CODENT = SZ3.Z3_CODENT " +;
			" WHERE       	SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' AND " +;
			"				SZ6.Z6_FILIAL = '" + xFilial("SZ6") + "' AND " +;
	  		"				SZ5.Z5_COMISS = '2' AND " +;
	    	"				SZ5.Z5_DATVER BETWEEN "+ValToSql( d010PerDe )+" AND "+ValToSql( d010PerAte )+" AND " +;
	       	"     	  		SZ6.Z6_CODENT BETWEEN "+ValToSql( c010EntDe )+" AND "+ValToSql( c010EntAte )+" AND " 
		                                  
	If !Empty(c010Rede)
		cSQL +=	"     		SZ3.Z3_CLASSI = " +ValToSql( c010Rede )+ " AND "
	Endif

	If !Empty(c010CCR)
		cSQL +=	"      		SZ3.Z3_CCRCOM = " +ValToSql( c010CCR )+ " AND "
	Endif
 
	cSQL +=	"				SZ6.Z6_TIPO NOT IN ('CAMPCO','VERPAR') AND " +;
			"         		SZ5.D_E_L_E_T_ = ' ' AND SZ6.D_E_L_E_T_ = ' ' AND SZ3.D_E_L_E_T_ = ' ' " +;
			" ORDER BY    	SZ5.Z5_CODPOS, SZ5.Z5_PEDGAR "
	
	If l010Query
		A010Script( cSQL )   
	Endif

	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,"Extraindo informa็๕es...")	
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Nใo foi possํvel encontrar registros com os parโmetros informados.', cDescriRel)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	nColSpace := 2
	cFont := 'Courier New'
	nFont := 7
	cOrient := 'PAISAGEM'                                                                                                                               
	aCab := {'POSTO','AGENTE','PRODUTO','PEDIDO','DT PEDIDO','DT VERIFI','VALOR PRODUTOS','VALOR SOFTWARE','VALOR HARDWARE','TOTAL REPASSE'}
	aAlign := {'LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','RIGHT','RIGHT','RIGHT','RIGHT'}
	aPicture := {'@!','@!','@!','@!','@!','@!','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99'}
	aSizeCol := {30,30,20,7,8,8,13,13,13,13}
	//           |  |  |  |  |  |  |  |  |  |
	//           |  |  |  |  |  |  |  |  |  +--> TOTAL REPASSE
	//           |  |  |  |  |  |  |  |  +-----> TOTAL HARDWARE
	//           |  |  |  |  |  |  |  +--------> TOTAL SOFTWARE
	//           |  |  |  |  |  |  +-----------> VALOR TOTAL
	//           |  |  |  |  |  +--------------> DATA VERIFICACAO
	//           |  |  |  |  +-----------------> DATA PEDIDO
	//           |  |  |  +--------------------> PEDIDO
	//           |  |  +-----------------------> PRODUTO
	//           |  +--------------------------> AGENTE
	//           +-----------------------------> POSTO

	ProcRegua(0)                                          
	
	cKey := (cTRB)->Z5_CODPOS + (cTRB)->Z5_PEDGAR
	cPosto := (cTRB)->Z5_CODPOS
    
	While (cTRB)->( !Eof() ) 
	
		IncProc()                                                                                                                                         		

		nTotCom 	+= (cTRB)->Z6_VALCOM		
		cDesPos 	:= (cTRB)->Z5_DESPOS 
		cNomAge 	:= (cTRB)->Z5_NOMAGE 
		cProdGar 	:= (cTRB)->Z5_PRODGAR 
		cPedGar 	:= (cTRB)->Z5_PEDGAR 
		dDatPed 	:= (cTRB)->Z5_DATPED 
		dDatVer 	:= (cTRB)->Z5_DATVER 
		nValor 		:= (cTRB)->Z5_VALOR 
		nValorSw 	:= (cTRB)->Z5_VALORSW 
		nValorHw 	:= (cTRB)->Z5_VALORHW
		
		(cTRB)->( dbSkip() )
		
		If cKey <> ((cTRB)->Z5_CODPOS + (cTRB)->Z5_PEDGAR)
		
			AAdd( aDados, { cDESPOS, cNOMAGE, cPRODGAR, cPEDGAR, dDATPED, dDATVER, nVALOR, nVALORSW, nVALORHW, nTotCom } ) 
			    
			nT_EntPrd	+= nVALOR 
			nT_EntSw	+= nVALORSW
			nT_EntHw	+= nVALORHW
			nT_EntCom	+= nTotCom     

			cKey := (cTRB)->Z5_CODPOS + (cTRB)->Z5_PEDGAR			
			nTotCom := 0
			
			If cPosto <> (cTRB)->Z5_CODPOS              

				AAdd( aDados, Array( Len( aCab ) ) )
				nElem := Len( aDados )
				
				aDados[ nElem, 1 ] := 'LINHA'
			
				AAdd( aDados, Array( Len( aCab ) ) )
				nElem := Len( aDados )
				
				aDados[ nElem, 1 ] 	:= 'TOTAL ENTIDADE'
				aDados[ nElem, 7 ] 	:= nT_EntPrd
				aDados[ nElem, 8 ] 	:= nT_EntSw
				aDados[ nElem, 9 ] 	:= nT_EntHw
				aDados[ nElem, 10 ]	:= nT_EntCom       
				
				AAdd( aDados, Array( Len( aCab ) ) )
				AAdd( aDados, Array( Len( aCab ) ) )
				
				cPosto := (cTRB)->Z5_CODPOS
				
				nT_TotPrd	+= nT_EntPrd 
				nT_TotSw	+= nT_EntSw
				nT_TotHw	+= nT_EntHw
				nT_TotCom	+= nT_EntCom     

				nT_EntPrd	:= 0 
				nT_EntSw	:= 0
				nT_EntHw	:= 0
				nT_EntCom	:= 0				
		
			Endif
	        
		Endif                 
		
	End

	(cTRB)->( DbCloseArea() )
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'LINHA'

	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'TOTAL GERAL'
	aDados[ nElem, 7 ] := nT_TotPrd
	aDados[ nElem, 8 ] := nT_TotSw
	aDados[ nElem, 9 ] := nT_TotHw
	aDados[ nElem, 10 ] := nT_TotCom
   	
	oReport := A010Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ A010ProdAna บ Autor ณ Tatiana Pontes    บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de processamento - (4) Por Produto Analitico com    บฑฑ
ฑฑบ          ณ com Campanha do Contador.								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A010ProdAna()

	Local cSQL 		:= ''
	Local cTRB 		:= ''
	Local cProdGar 	:= ""
  	Local cDesProd	:= ""
	Local nElem 	:= 0

	Local cChvGar	:= ""
	Local nQtdVer 	:= 0
	Local nTotSw 	:= 0 
	Local nImpSw 	:= 0 
	Local nLiqSw 	:= 0
	Local nTotHw 	:= 0
	Local nImpHw 	:= 0
	Local nLiqHw 	:= 0
	Local nTotCom 	:= 0
	Local nTotCC	:= 0

	Local nT_QtdVer	:= 0
	Local nT_TotSw 	:= 0 
	Local nT_ImpSw 	:= 0 
	Local nT_LiqSw 	:= 0
	Local nT_TotHw 	:= 0
	Local nT_ImpHw 	:= 0
	Local nT_LiqHw 	:= 0
	Local nT_TotCom	:= 0
	
	Private oReport

	cSQL :=	" SELECT      	SZ5.Z5_PRODGAR, SZ5.Z5_DESPRO, SZ5.Z5_VALORSW, SZ5.Z5_VALORHW, SZ6.Z6_TIPO, SZ6.Z6_VLRPROD, " +;
	        "    			SZ6.Z6_BASECOM, SZ6.Z6_VALCOM, SZ6.Z6_CATPROD, SZ5.Z5_PEDGAR, SZ4.Z4_IMPSOFT, SZ4.Z4_IMPHARD " +;
			" FROM        	" + RetSqlName("SZ5") + " SZ5 " +;
			" INNER JOIN  	" + RetSqlName("SZ6") + " SZ6 ON SZ5.Z5_PEDGAR = SZ6.Z6_PEDGAR " +;
			" INNER JOIN  	" + RetSqlName("SZ3") + " SZ3 ON SZ6.Z6_CODENT = SZ3.Z3_CODENT " +;
			" INNER JOIN  	" + RetSqlName("SZ4") + " SZ4 ON SZ3.Z3_CODENT = SZ4.Z4_CODENT " +;
			" WHERE       	SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' AND " +;
			"				SZ6.Z6_FILIAL = '" + xFilial("SZ6") + "' AND " +;
	  		"				SZ5.Z5_COMISS = '2' AND " +;
	    	"				SZ5.Z5_DATVER BETWEEN "+ValToSql( d010PerDe )+" AND "+ValToSql( d010PerAte )+" AND " +;
	       	"     	  		SZ6.Z6_CODENT BETWEEN "+ValToSql( c010EntDe )+" AND "+ValToSql( c010EntAte )+" AND " 
		                                  
	If !Empty(c010Rede)
		cSQL +=	"     		SZ3.Z3_CLASSI = " +ValToSql( c010Rede )+ " AND "
	Endif

	If !Empty(c010CCR)
		cSQL +=	"      		SZ3.Z3_CCRCOM = " +ValToSql( c010CCR )+ " AND "
	Endif
 
	cSQL +=	"				SZ6.Z6_TIPO <> 'VERPAR' AND " +;
			"         		SZ5.D_E_L_E_T_ = ' ' AND SZ6.D_E_L_E_T_ = ' ' AND SZ3.D_E_L_E_T_ = ' ' AND SZ4.D_E_L_E_T_ = ' ' " +;
			" ORDER BY    	SZ6.Z6_TIPO, SZ5.Z5_PRODGAR, SZ5.Z5_PEDGAR"
	
	If l010Query
		A010Script( cSQL )   
	Endif

	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,"Extraindo informa็๕es...")	
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Nใo foi possํvel encontrar registros com os parโmetros informados.', cDescriRel)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	nColSpace := 2
	cFont := 'Courier New'
	nFont := 8
	cOrient := 'PAISAGEM'                                                                                                                               
	aCab := {'PRODUTO','DESCRIวรO PRODUTO','QTD','TOTAL SOFTWARE','IMP SOFT 5,65%','VALOR LIQ SOFT','TOTAL HARDWARE','IMPHARD 16,25%','VALOR LIQ HARD','  TOTAL REPASSE'}
	aAlign := {'LEFT','LEFT','LEFT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT'}
	aPicture := {'@!','@!','@E 9999','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99'}
	aSizeCol := {20,30,4,13,13,13,13,13,13,13}
	//           |  |  |  |  |  |  |  |  |  |
	//           |  |  |  |  |  |  |  |  |  +--> TOTAL REPASSE
	//           |  |  |  |  |  |  |  |  +-----> VAL LIQ HW
	//           |  |  |  |  |  |  |  +--------> IMP HW (16,25%)
	//           |  |  |  |  |  |  +-----------> TOTAL HW
	//           |  |  |  |  |  +--------------> VAL LIQ SW
	//           |  |  |  |  +-----------------> IMP SW (5,65%)
	//           |  |  |  +--------------------> TOTAL SW
	//           |  |  +-----------------------> QTD
	//           |  +--------------------------> DESCRICAO PRODUTO
	//           +-----------------------------> PRODUTO

	ProcRegua(0)

	While (cTRB)->( !Eof() )                  
	
		IncProc()

		If (cTRB)->Z6_TIPO == 'CAMPCO'
			
			nTotCC += (cTRB)->Z6_VALCOM		    
			
			(cTRB)->( DbSkip() )

		Else	

			If Empty(cProdGar)
				cProdGar 	:= (cTRB)->Z5_PRODGAR     
				cDesProd	:= (cTRB)->Z5_DESPRO      
        	Endif
        	
			If cChvGar <> (cTRB)->Z5_PEDGAR + (cTRB)->Z5_PRODGAR     
	 			nQtdVer++
				cChvGar	:= (cTRB)->Z5_PEDGAR + (cTRB)->Z5_PRODGAR     		
			Endif
			
			nTotCom += (cTRB)->Z6_VALCOM		
			
			If (cTRB)->Z6_CATPROD $ "2" // Software
				nTotSw += (cTRB)->Z6_VLRPROD 
				If !Empty((cTRB)->Z4_IMPSOFT)
					nImpSw += (cTRB)->Z6_VLRPROD * ((cTRB)->Z4_IMPSOFT / 100)
				Endif
			Endif
			
			If (cTRB)->Z6_CATPROD $ "1" // Hardware
				nTotHw += (cTRB)->Z6_VLRPROD
				If !Empty((cTRB)->Z4_IMPHARD)
					nImpHw += (cTRB)->Z6_VLRPROD * ((cTRB)->Z4_IMPHARD / 100)
				Endif                               
			Endif
	
			(cTRB)->( DbSkip() )
	
	 		If cProdGar <> (cTRB)->Z5_PRODGAR
	 		
	 			nLiqSw		:= nTotSw - nImpSw
	 			nLiqHw		:= nTotHw - nImpHw
				nT_QtdVer 	+= nQtdVer 
				nT_TotSw  	+= nTotSw 
				nT_ImpSw 	+= nImpSw 
				nT_LiqSw 	+= nLiqSw
				nT_TotHw 	+= nTotHw
				nT_ImpHw 	+= nImpHw
				nT_LiqHw 	+= nLiqHw
				nT_TotCom 	+= nTotCom
	                                                                                                                                  
				AAdd( aDados, { cProdGar, cDesProd, nQtdVer, nTotSw, nImpSw, nLiqSw, nTotHw, nImpHw, nLiqHw, nTotCom } ) 
				
				cProdGar 	:= (cTRB)->Z5_PRODGAR    
				cDesProd	:= (cTRB)->Z5_DESPRO    
				nQtdVer 	:= 0
				nTotSw 		:= 0 
				nImpSw 		:= 0 
				nLiqSw 		:= 0
				nTotHw 		:= 0
				nImpHw 		:= 0
				nLiqHw 		:= 0
				nTotCom 	:= 0
	
			Endif

		Endif		

	End

	(cTRB)->( DbCloseArea() )
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'LINHA'
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL VERIFICAวีES'
	aDados[ nElem, 3 ] := nT_QtdVer
	aDados[ nElem, 4 ] := nT_TotSw
	aDados[ nElem, 5 ] := nT_ImpSw
	aDados[ nElem, 6 ] := nT_LiqSw
	aDados[ nElem, 7 ] := nT_TotHw
	aDados[ nElem, 8 ] := nT_ImpHw
	aDados[ nElem, 9 ] := nT_LiqHw
	aDados[ nElem, 10 ] := nT_TotCom

	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'LINHA'
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'CAMPANHA DO CONTADOR'
	aDados[ nElem, 10 ] := nTotCC

	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'LINHA'
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL GERAL'
	aDados[ nElem, 10 ] := nTotCC + nT_TotCom
	
	oReport := A010Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ A010PostAna บ Autor ณ Tatiana Pontes    บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de processamento - (5) Posto Analitico com Impostos บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A010PostAna()

	Local cSQL 		:= ''
	Local cTRB 		:= ''
  	Local cPosto	:= ''
  	Local cDescPos	:= ''
	Local nElem 	:= 0

	Local cKey		:= ''  
	Local cKey2		:= ''
	Local cKeyQtd	:= ''     
	Local nQtdVer 	:= 0
	Local nTotSw 	:= 0 
	Local nImpSw 	:= 0 
	Local nLiqSw 	:= 0
	Local nTotHw 	:= 0
	Local nImpHw 	:= 0
	Local nLiqHw 	:= 0
	Local nTotIR	:= 0
	Local nTotCom 	:= 0

	Local nT_QtdVer	:= 0
	Local nT_TotSw 	:= 0 
	Local nT_ImpSw 	:= 0 
	Local nT_LiqSw 	:= 0
	Local nT_TotHw 	:= 0
	Local nT_ImpHw 	:= 0
	Local nT_LiqHw 	:= 0
	Local nT_TotIR	:= 0
	Local nT_TotCom	:= 0                
	Local nT_GerQtd	:= 0
	Local nT_GerCom	:= 0
	
	Private oReport

	cSQL :=	" SELECT      	SZ5.Z5_CODPOS, SZ5.Z5_DESPOS, SZ5.Z5_VALORSW, SZ5.Z5_VALORHW, SZ6.Z6_VLRPROD, SZ6.Z6_BASECOM, " +;
	        "    			SZ6.Z6_VALCOM, SZ6.Z6_CATPROD, SZ5.Z5_PEDGAR, SZ6.Z6_TIPO, SZ4.Z4_IMPSOFT, SZ4.Z4_IMPHARD, SZ4.Z4_PORIR" +;
			" FROM        	" + RetSqlName("SZ5") + " SZ5 " +;
			" INNER JOIN  	" + RetSqlName("SZ6") + " SZ6 ON SZ5.Z5_PEDGAR = SZ6.Z6_PEDGAR " +;
			" INNER JOIN  	" + RetSqlName("SZ3") + " SZ3 ON SZ6.Z6_CODENT = SZ3.Z3_CODENT " +;
			" INNER JOIN  	" + RetSqlName("SZ4") + " SZ4 ON SZ3.Z3_CODENT = SZ4.Z4_CODENT " +;
			" WHERE       	SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' AND " +;
			"				SZ6.Z6_FILIAL = '" + xFilial("SZ6") + "' AND " +;
	  		"				SZ5.Z5_COMISS = '2' AND " +;
	    	"				SZ5.Z5_DATVER BETWEEN "+ValToSql( d010PerDe )+" AND "+ValToSql( d010PerAte )+" AND " +;
	       	"     	  		SZ6.Z6_CODENT BETWEEN "+ValToSql( c010EntDe )+" AND "+ValToSql( c010EntAte )+" AND " 
		                                  
	If !Empty(c010Rede)
		cSQL +=	"     		SZ3.Z3_CLASSI = " +ValToSql( c010Rede )+ " AND "
	Endif

	If !Empty(c010CCR)
		cSQL +=	"      		SZ3.Z3_CCRCOM = " +ValToSql( c010CCR )+ " AND "
	Endif
 
	cSQL +=	"				SZ6.Z6_TIPO <> 'VERPAR' AND " +;
			"         		SZ5.D_E_L_E_T_ = ' ' AND SZ6.D_E_L_E_T_ = ' ' AND SZ3.D_E_L_E_T_ = ' ' AND SZ4.D_E_L_E_T_ = ' ' " +;
			" ORDER BY    	SZ6.Z6_TIPO, SZ5.Z5_CODPOS, SZ5.Z5_PEDGAR"
	
	If l010Query
		A010Script( cSQL )   
	Endif

	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,"Extraindo informa็๕es...")	
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Nใo foi possํvel encontrar registros com os parโmetros informados.', cDescriRel)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	nColSpace := 2
	cFont := 'Courier New'
	nFont := 8
	cOrient := 'PAISAGEM'                                                                                                                               
	aCab := {'POSTO','QTD ','TOTAL SOFTWARE','IMP SOFT 5,65%','VALOR LIQ SOFT','TOTAL HARDWARE','IMPHARD 16,25%','VALOR LIQ HARD','IMPOSTO RENDA','TOTAL REPASSE'}
	aAlign := {'LEFT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT'}
	aPicture := {'@!','@E 9999','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99'}
	aSizeCol := {30,4,13,13,13,13,13,13,13,13}
	//           |  |  |  |  |  |  |  |  |  |
	//           |  |  |  |  |  |  |  |  |  +--> TOTAL REPASSE
	//           |  |  |  |  |  |  |  |  +-----> IR
	//           |  |  |  |  |  |  |  +--------> VAL LIQ HW
	//           |  |  |  |  |  |  +-----------> IMP HW (16,25%)
	//           |  |  |  |  |  +--------------> TOTAL HW
	//           |  |  |  |  +-----------------> VAL LIQ SW
	//           |  |  |  +--------------------> IMP SW (5,65%)
	//           |  |  +-----------------------> TOTAL SW
	//           |  +--------------------------> QTD
	//           +-----------------------------> PRODUTO

	ProcRegua(0)

	cKey		:= (cTRB)->Z6_TIPO + (cTRB)->Z5_CODPOS
	cKey2		:= (cTRB)->Z6_TIPO
	cDescPos	:= (cTRB)->Z5_DESPOS
	
	While (cTRB)->( !Eof() )                  
	
		IncProc()

		nTotCom += (cTRB)->Z6_VALCOM		
				
		If (cTRB)->Z6_CATPROD $ "2" // Software
			nTotSw += (cTRB)->Z6_VLRPROD 
			If !Empty((cTRB)->Z4_IMPSOFT)
				nImpSw += (cTRB)->Z6_VLRPROD * ((cTRB)->Z4_IMPSOFT / 100)
			Endif
		Endif
		
		If (cTRB)->Z6_CATPROD $ "1" // Hardware
			nTotHw += (cTRB)->Z6_VLRPROD
			If !Empty((cTRB)->Z4_IMPHARD)
				nImpHw += (cTRB)->Z6_VLRPROD * ((cTRB)->Z4_IMPHARD / 100)
			Endif                               
		Endif
		
		If !Empty((cTRB)->Z4_PORIR)
			nTotIR	+= (cTRB)->Z6_VLRPROD * ((cTRB)->Z4_PORIR / 100)		
		Endif
		
		If cKeyQtd <> ((cTRB)->Z5_CODPOS + (cTRB)->Z5_PEDGAR)
			nQtdVer++                                    
			cKeyQtd	:= (cTRB)->Z5_CODPOS + (cTRB)->Z5_PEDGAR
		Endif		
		 
		(cTRB)->( DbSkip() )

		If cKey <> (cTRB)->Z6_TIPO + (cTRB)->Z5_CODPOS

 			nLiqSw		:= nTotSw - nImpSw
 			nLiqHw		:= nTotHw - nImpHw
			nT_QtdVer 	+= nQtdVer 
			nT_TotSw  	+= nTotSw 
			nT_ImpSw 	+= nImpSw 
			nT_LiqSw 	+= nLiqSw
			nT_TotHw 	+= nTotHw
			nT_ImpHw 	+= nImpHw
			nT_LiqHw 	+= nLiqHw
			nT_TotIR 	+= nTotIR
			nT_TotCom 	+= nTotCom
                                                                                                                                  
			AAdd( aDados, { cDescPos, nQtdVer, nTotSw, nImpSw, nLiqSw, nTotHw, nImpHw, nLiqHw, nTotIR, nTotCom } ) 

			If cKey2 <> (cTRB)->Z6_TIPO 			

				AAdd( aDados, Array( Len( aCab ) ) )
				nElem := Len( aDados )
				
				aDados[ nElem, 1 ] := 'LINHA'
				
				AAdd( aDados, Array( Len( aCab ) ) )
				nElem := Len( aDados )
	
				aDados[ nElem, 1 ] := IIF(cKey2 == 'CAMPCO','TOTAL CAMPANHA CONTADOR','TOTAL VERIFICAวีES')
				aDados[ nElem, 2 ] := nT_QtdVer
				aDados[ nElem, 3 ] := nT_TotSw
				aDados[ nElem, 4 ] := nT_ImpSw
				aDados[ nElem, 5 ] := nT_LiqSw
				aDados[ nElem, 6 ] := nT_TotHw
				aDados[ nElem, 7 ] := nT_ImpHw
				aDados[ nElem, 8 ] := nT_LiqHw
				aDados[ nElem, 9 ] := nT_TotIR
				aDados[ nElem, 10 ] := nT_TotCom
	
				AAdd( aDados, Array( Len( aCab ) ) )
				
				nT_GerQtd	+= nT_QtdVer
				nT_GerCom	+= nT_TotCom
				
				cKey2 := (cTRB)->Z6_TIPO

				nT_QtdVer 	:= 0 
				nT_TotSw  	:= 0 
				nT_ImpSw 	:= 0 
				nT_LiqSw 	:= 0
				nT_TotHw 	:= 0
				nT_ImpHw 	:= 0
				nT_LiqHw 	:= 0
				nT_TotIR 	:= 0
				nT_TotCom 	:= 0   

			Endif			

			nQtdVer 	:= 0
			nTotSw 		:= 0 
			nImpSw 		:= 0 
			nLiqSw 		:= 0
			nTotHw 		:= 0
			nImpHw 		:= 0
			nLiqHw 		:= 0
			nTotIR		:= 0
			nTotCom 	:= 0

			cKey		:= (cTRB)->Z6_TIPO + (cTRB)->Z5_CODPOS
			cDescPos	:= (cTRB)->Z5_DESPOS
		
		Endif
		
	End

	(cTRB)->( DbCloseArea() )
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'LINHA'
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL GERAL'
	aDados[ nElem, 2 ] := nT_GerQtd
	aDados[ nElem, 10 ] := nT_GerCom

	oReport := A010Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ A010ProdCC  บ Autor ณ Tatiana Pontes    บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de processamento - (6) Por Produto Sintetico        บฑฑ
ฑฑบ          ณ com Campanha do Contador									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A010ProdCC()              

	Local cSQL 		:= ''
	Local cTRB 		:= ''
	Local cProdGar 	:= ""
  	Local cDesProd	:= ""
	Local nElem 	:= 0

	Local cKey		:= ""
	Local cKey2		:= ""
	Local nQtdVer 	:= 0
	Local nTotSw 	:= 0 
	Local nImpSw 	:= 0 
	Local nLiqSw 	:= 0
	Local nTotHw 	:= 0
	Local nImpHw 	:= 0
	Local nLiqHw 	:= 0
	Local nTotCom 	:= 0
	Local nTotCC	:= 0

	Local nT_QtdVer	:= 0
	Local nT_TotSw 	:= 0 
	Local nT_ImpSw 	:= 0 
	Local nT_LiqSw 	:= 0
	Local nT_TotHw 	:= 0
	Local nT_ImpHw 	:= 0
	Local nT_LiqHw 	:= 0
	Local nT_TotCom	:= 0
	Local nT_GerCom	:= 0
		
	Private oReport

	cSQL :=	" SELECT      	SZ5.Z5_PRODGAR, SZ5.Z5_DESPRO, SZ5.Z5_VALORSW, SZ5.Z5_VALORHW, SZ6.Z6_TIPO, SZ6.Z6_VLRPROD," +;
	        "    			SZ6.Z6_BASECOM, SZ6.Z6_VALCOM, SZ6.Z6_CATPROD, SZ5.Z5_PEDGAR, SZ4.Z4_IMPSOFT, SZ4.Z4_IMPHARD " +;
			" FROM        	" + RetSqlName("SZ5") + " SZ5 " +;
			" INNER JOIN  	" + RetSqlName("SZ6") + " SZ6 ON SZ5.Z5_PEDGAR = SZ6.Z6_PEDGAR " +;
			" INNER JOIN  	" + RetSqlName("SZ3") + " SZ3 ON SZ6.Z6_CODENT = SZ3.Z3_CODENT " +;
			" INNER JOIN	" + RetSqlName("SZ4") + " SZ4 ON SZ3.Z3_CODENT = SZ4.Z4_CODENT " +;
			" WHERE       	SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' AND " +;
			"				SZ6.Z6_FILIAL = '" + xFilial("SZ6") + "' AND " +;
	  		"				SZ5.Z5_COMISS = '2' AND " +;
	    	"				SZ5.Z5_DATVER BETWEEN "+ValToSql( d010PerDe )+" AND "+ValToSql( d010PerAte )+" AND " +;
	       	"     	  		SZ6.Z6_CODENT BETWEEN "+ValToSql( c010EntDe )+" AND "+ValToSql( c010EntAte )+" AND " 
		                                  
	If !Empty(c010Rede)
		cSQL +=	"     		SZ3.Z3_CLASSI = " +ValToSql( c010Rede )+ " AND "
	Endif

	If !Empty(c010CCR)
		cSQL +=	"      		SZ3.Z3_CCRCOM = " +ValToSql( c010CCR )+ " AND "
	Endif
 
	cSQL +=	"				SZ6.Z6_TIPO <> 'VERPAR' AND " +;
			"         		SZ5.D_E_L_E_T_ = ' ' AND SZ6.D_E_L_E_T_ = ' ' AND SZ3.D_E_L_E_T_ = ' ' AND SZ4.D_E_L_E_T_ = ' ' " +;
			" ORDER BY    	SZ6.Z6_TIPO, SZ5.Z5_PRODGAR, SZ5.Z5_PEDGAR"
	
	If l010Query
		A010Script( cSQL )   
	Endif

	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,"Extraindo informa็๕es...")	
	
	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Nใo foi possํvel encontrar registros com os parโmetros informados.', cDescriRel)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	nColSpace := 2
	cFont := 'Courier New'
	nFont := 8
	cOrient := 'PAISAGEM'                                                                                                                               
	aCab := {'PRODUTO','DESCRIวรO PRODUTO','QTD','TOTAL SOFTWARE','IMP SOFT 5,65%','VALOR LIQ SOFT','TOTAL HARDWARE','IMPHARD 16,25%','VALOR LIQ HARD','  TOTAL REPASSE'}
	aAlign := {'LEFT','LEFT','LEFT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT','RIGHT'}
	aPicture := {'@!','@!','@E 9999','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99'}
	aSizeCol := {20,30,4,13,13,13,13,13,13,13}
	//           |  |  |  |  |  |  |  |  |  |
	//           |  |  |  |  |  |  |  |  |  +--> TOTAL REPASSE
	//           |  |  |  |  |  |  |  |  +-----> VAL LIQ HW
	//           |  |  |  |  |  |  |  +--------> IMP HW (16,25%)
	//           |  |  |  |  |  |  +-----------> TOTAL HW
	//           |  |  |  |  |  +--------------> VAL LIQ SW
	//           |  |  |  |  +-----------------> IMP SW (5,65%)
	//           |  |  |  +--------------------> TOTAL SW
	//           |  |  +-----------------------> QTD
	//           |  +--------------------------> DESCRICAO PRODUTO
	//           +-----------------------------> PRODUTO

	ProcRegua(0)

	While (cTRB)->( !Eof() )                  
	
		IncProc()

		If (cTRB)->Z6_TIPO == 'CAMPCO'
			
			nTotCC += (cTRB)->Z6_VALCOM		    
			
			(cTRB)->( DbSkip() )

		Else	
            
			If Empty(cProdGar)
				cKey2 		:= (cTRB)->Z6_TIPO
				cProdGar	:= (cTRB)->Z5_PRODGAR
				cDesProd	:= (cTRB)->Z5_DESPRO      
			Endif
								
			If cKey <> (cTRB)->Z5_PEDGAR + (cTRB)->Z5_PRODGAR  + (cTRB)->Z6_TIPO
	 			nQtdVer++
				cKey	:= (cTRB)->Z5_PEDGAR + (cTRB)->Z5_PRODGAR  + (cTRB)->Z6_TIPO     		
			Endif
			
			nTotCom += (cTRB)->Z6_VALCOM		
			
			If (cTRB)->Z6_CATPROD $ "2" // Software
				nTotSw += (cTRB)->Z6_VLRPROD 
				If !Empty((cTRB)->Z4_IMPSOFT)
					nImpSw += (cTRB)->Z6_VLRPROD * ((cTRB)->Z4_IMPSOFT / 100)
				Endif
			Endif
			
			If (cTRB)->Z6_CATPROD $ "1" // Hardware
				nTotHw += (cTRB)->Z6_VLRPROD
				If !Empty((cTRB)->Z4_IMPHARD)
					nImpHw += (cTRB)->Z6_VLRPROD * ((cTRB)->Z4_IMPHARD / 100)
				Endif                               
			Endif
	
			(cTRB)->( DbSkip() )
	
	 		If cProdGar <> (cTRB)->Z5_PRODGAR
	 		
	 			nLiqSw		:= nTotSw - nImpSw
	 			nLiqHw		:= nTotHw - nImpHw
				nT_QtdVer 	+= nQtdVer 
				nT_TotSw  	+= nTotSw 
				nT_ImpSw 	+= nImpSw 
				nT_LiqSw 	+= nLiqSw
				nT_TotHw 	+= nTotHw
				nT_ImpHw 	+= nImpHw
				nT_LiqHw 	+= nLiqHw
				nT_TotCom 	+= nTotCom
	                                                                                                                                  
				AAdd( aDados, { cProdGar, cDesProd, nQtdVer, nTotSw, nImpSw, nLiqSw, nTotHw, nImpHw, nLiqHw, nTotCom } ) 

				cProdGar 	:= (cTRB)->Z5_PRODGAR
				cDesProd	:= (cTRB)->Z5_DESPRO    
				nQtdVer 	:= 0
				nTotSw 		:= 0 
				nImpSw 		:= 0 
				nLiqSw 		:= 0
				nTotHw 		:= 0
				nImpHw 		:= 0
				nLiqHw 		:= 0
				nTotCom 	:= 0
				
				If cKey2 <> (cTRB)->Z6_TIPO

					AAdd( aDados, Array( Len( aCab ) ) )
					nElem := Len( aDados )
					
					aDados[ nElem, 1 ] := 'LINHA'
					
					AAdd( aDados, Array( Len( aCab ) ) )
					nElem := Len( aDados )
                                                                                         
					aDados[ nElem, 1 ] := IIF(cKey2 == 'VERIFI', 'TOTAL VERIFICAวีES', 'TOTAL VENDA C.CONT.')
					aDados[ nElem, 3 ] := nT_QtdVer
					aDados[ nElem, 4 ] := nT_TotSw
					aDados[ nElem, 5 ] := nT_ImpSw
					aDados[ nElem, 6 ] := nT_LiqSw
					aDados[ nElem, 7 ] := nT_TotHw
					aDados[ nElem, 8 ] := nT_ImpHw
					aDados[ nElem, 9 ] := nT_LiqHw
					aDados[ nElem, 10 ] := nT_TotCom
				
					AAdd( aDados, Array( Len( aCab ) ) )

					nT_GerCom	+= nT_TotCom
					
					nT_QtdVer 	:= 0
					nT_TotSw  	:= 0
					nT_ImpSw 	:= 0
					nT_LiqSw 	:= 0
					nT_TotHw 	:= 0
					nT_ImpHw 	:= 0
					nT_LiqHw 	:= 0
					nT_TotCom 	:= 0
						
					cKey2 := (cTRB)->Z6_TIPO
								
				Endif
	
			Endif

		Endif		

	End

	(cTRB)->( DbCloseArea() )

	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'LINHA'
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL CAMP. CONT.'
	aDados[ nElem, 10 ] := nTotCC

	AAdd( aDados, Array( Len( aCab ) ) )
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'LINHA'
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL GERAL'
	aDados[ nElem, 10 ] := nTotCC + nT_GerCom

	oReport := A010Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ A010PostCC  บ Autor ณ Tatiana Pontes    บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de processamento - (7) Por Posto Campanha Contador  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A010PostCC()

	Local cSQL 		:= ''
	Local cTRB 		:= ''
	Local nElem 	:= 0

	Local cKey		:= ''
	Local cKey2		:= ''
  	Local cDescPos	:= ''
	Local nTotSw 	:= 0 
	Local nTotHw 	:= 0
	Local nTotCom 	:= 0

	Local cNomAge 	:= ''
	Local cProdGar	:= ''
	Local cPedGar	:= ''
	Local dDatPed	:= CtoD('  /  /  ')
	Local dDatVer	:= CtoD('  /  /  ')

	Local nT_TotCom	:= 0
	Local nT_PosPrd := 0
	Local nT_PosSw 	:= 0 
	Local nT_PosHw 	:= 0
	Local nT_PosCom	:= 0
	
	Private oReport

	cSQL :=	" SELECT      	SZ5.Z5_CODPOS, SZ5.Z5_DESPOS, SZ5.Z5_NOMAGE, SZ5.Z5_PEDGAR, SZ5.Z5_PRODGAR, SZ5.Z5_DATPED, SZ5.Z5_DATVER, " +;
	        "    			SZ6.Z6_VLRPROD, SZ5.Z5_VALORSW, SZ5.Z5_VALORHW, SZ6.Z6_VALCOM, SZ6.Z6_CATPROD, SZ6.Z6_TIPO " +;
			" FROM        	" + RetSqlName("SZ5") + " SZ5 " +;
			" INNER JOIN  	" + RetSqlName("SZ6") + " SZ6 ON SZ5.Z5_PEDGAR = SZ6.Z6_PEDGAR " +;
			" INNER JOIN  	" + RetSqlName("SZ3") + " SZ3 ON SZ6.Z6_CODENT = SZ3.Z3_CODENT " +;
			" WHERE       	SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' AND " +;
			"				SZ6.Z6_FILIAL = '" + xFilial("SZ6") + "' AND " +;
	  		"				SZ5.Z5_COMISS = '2' AND " +;
	    	"				SZ5.Z5_DATVER BETWEEN "+ValToSql( d010PerDe )+" AND "+ValToSql( d010PerAte )+" AND " +;
	       	"     	  		SZ6.Z6_CODENT BETWEEN "+ValToSql( c010EntDe )+" AND "+ValToSql( c010EntAte )+" AND " 
		                                  
	If !Empty(c010Rede)
		cSQL +=	"     		SZ3.Z3_CLASSI = " +ValToSql( c010Rede )+ " AND "
	Endif

	If !Empty(c010CCR)
		cSQL +=	"      		SZ3.Z3_CCRCOM = " +ValToSql( c010CCR )+ " AND "
	Endif
 
	cSQL +=	"				SZ6.Z6_TIPO <> 'VERPAR' AND " +;
			"         		SZ5.D_E_L_E_T_ = ' ' AND SZ6.D_E_L_E_T_ = ' ' AND SZ3.D_E_L_E_T_ = ' ' " +;
			" ORDER BY    	SZ5.Z5_CODPOS, SZ6.Z6_TIPO, SZ5.Z5_PEDGAR"
	
	If l010Query
		A010Script( cSQL )   
	Endif

	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,"Extraindo informa็๕es...")	

	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Nใo foi possํvel encontrar registros com os parโmetros informados.', cDescriRel)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	nColSpace := 2
	cFont := 'Courier New'
	nFont := 7
	cOrient := 'PAISAGEM'                                                  
	aCab := {'POSTO','AGENTE','PRODUTO','PEDIDO','DT PEDIDO','DT VERIFICA','VALOR PRODUTO','TOTAL SOFTWARE','TOTAL HARDWARE','TOTAL REPASSE'}
	aAlign := {'LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','RIGHT','RIGHT','RIGHT','RIGHT'}
	aPicture := {'@!','@!','@!','@!','@!','@!','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99'}
	aSizeCol := {30,30,20,7,8,8,13,13,13,13}
	//           |  |  |  |  |  |  |  |  |  |
	//           |  |  |  |  |  |  |  |  |  +--> TOTAL REPASSE
	//           |  |  |  |  |  |  |  |  +-----> TOTAL HW
	//           |  |  |  |  |  |  |  +--------> TOTAL SW
	//           |  |  |  |  |  |  +-----------> VALOR TOTAL
	//           |  |  |  |  |  +--------------> DATA VERIFICACAO
	//           |  |  |  |  +-----------------> DATA PEDIDO
	//           |  |  |  +--------------------> PEDIDO
	//           |  |  +-----------------------> PRODUTO
	//           |  +--------------------------> AGENTE
	//           +-----------------------------> POSTO

	ProcRegua(0)

	cKey		:= (cTRB)->Z5_PEDGAR 
	cKey2		:= (cTRB)->Z5_CODPOS + (cTRB)->Z6_TIPO 
	cDescPos	:= (cTRB)->Z5_DESPOS

	While (cTRB)->( !Eof() )                  
	
		IncProc()

		nTotCom += (cTRB)->Z6_VALCOM		
		
		If (cTRB)->Z6_CATPROD $ "2" // Software
			nTotSw += (cTRB)->Z6_VLRPROD
		Endif
		
		If (cTRB)->Z6_CATPROD $ "1" // Hardware
			nTotHw += (cTRB)->Z6_VLRPROD
		Endif
		
		cNomAge 	:= (cTRB)->Z5_NOMAGE
		cProdGar	:= (cTRB)->Z5_PRODGAR
		cPedGar		:= (cTRB)->Z5_PEDGAR    
		dDatPed		:= (cTRB)->Z5_DATPED
		dDatVer		:= (cTRB)->Z5_DATVER

		(cTRB)->( DbSkip() )

		If cKey <> (cTRB)->Z5_PEDGAR 
            
			nT_PosPrd	+= nTotSw + nTotHw
			nT_PosSw  	+= nTotSw 
			nT_PosHw 	+= nTotHw
			nT_PosCom 	+= nTotCom
			                                                                                                                                  
			AAdd( aDados, { cDescPos, cNomAge, cProdGar, cPedGar, dDatPed, dDatVer, nTotSw+nTotHw, nTotSw, nTotHw, nTotCom } ) 
			
			nTotSw 		:= 0 
			nTotHw 		:= 0
			nTotCom 	:= 0

			cKey		:= (cTRB)->Z5_PEDGAR
			
			If cKey2 <> (cTRB)->Z5_CODPOS + (cTRB)->Z6_TIPO

				AAdd( aDados, Array( Len( aCab ) ) )
				nElem := Len( aDados )
				
				aDados[ nElem, 1 ] := 'LINHA'
				
				AAdd( aDados, Array( Len( aCab ) ) )
				nElem := Len( aDados )
			
				aDados[ nElem, 1 ] := IIF(SubStr(cKey2,21) == 'VERIFI','TOTAL VERIFICAวรO','TOTAL CAMPANHA DO CONTADOR')
				aDados[ nElem, 7 ] := nT_PosPrd
				aDados[ nElem, 8 ] := nT_PosSw
				aDados[ nElem, 9 ] := nT_PosHw
				aDados[ nElem, 10 ] := nT_PosCom    
				
				AAdd( aDados, Array( Len( aCab ) ) )

				nT_TotCom 	+= nT_PosCom
	
				nT_PosPrd	:= 0
				nT_PosSw  	:= 0
				nT_PosHw 	:= 0
				nT_PosCom 	:= 0
	
				cKey2 		:= (cTRB)->Z5_CODPOS + (cTRB)->Z6_TIPO
				cDescPos	:= (cTRB)->Z5_DESPOS
			
			Endif
		
		Endif
		
	End

	(cTRB)->( DbCloseArea() )
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'LINHA'
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL GERAL'
	aDados[ nElem, 10 ] := nT_TotCom

	oReport := A010Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ A010DtVer   บ Autor ณ Tatiana Pontes    บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de processamento - (8) Por data de verificacao      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A010DtVer()

	Local cSQL 		:= ''
	Local cTRB 		:= ''
	Local nElem 	:= 0

	Local cKey		:= ''    
	Local cMesAno	:= ''
  	Local cDescPos	:= ''
	Local nTotSw 	:= 0 
	Local nTotHw 	:= 0
	Local nTotCom 	:= 0
	Local cNomAge 	:= ''
	Local cProdGar	:= ''
	Local cPedGar	:= ''
	Local dDatPed	:= CtoD('  /  /  ')
	Local dDatVer	:= CtoD('  /  /  ')

	Local nT_TotPrd := 0
	Local nT_TotSw 	:= 0 
	Local nT_TotHw 	:= 0
	Local nT_TotCom	:= 0

	Local nT_MesPrd	:= 0
	Local nT_MesSw 	:= 0
	Local nT_MesHw 	:= 0
	Local nT_MesCom	:= 0
	
	Private oReport

	cSQL :=	" SELECT      	SZ5.Z5_CODPOS, SZ5.Z5_DESPOS, SZ5.Z5_NOMAGE, SZ5.Z5_PEDGAR, SZ5.Z5_PRODGAR, SZ5.Z5_DATPED, " +;
	        "    			SZ5.Z5_DATVER, SZ6.Z6_VLRPROD, SZ5.Z5_VALORSW, SZ5.Z5_VALORHW, SZ6.Z6_VALCOM, SZ6.Z6_CATPROD " +;
			" FROM        	" + RetSqlName("SZ5") + " SZ5 " +;
			" INNER JOIN  	" + RetSqlName("SZ6") + " SZ6 ON SZ5.Z5_PEDGAR = SZ6.Z6_PEDGAR " +;
			" INNER JOIN  	" + RetSqlName("SZ3") + " SZ3 ON SZ6.Z6_CODENT = SZ3.Z3_CODENT " +;
			" WHERE       	SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' AND " +;
			"				SZ6.Z6_FILIAL = '" + xFilial("SZ6") + "' AND " +;
	  		"				SZ5.Z5_COMISS = '2' AND " +;
	    	"				SZ5.Z5_DATVER BETWEEN "+ValToSql( d010PerDe )+" AND "+ValToSql( d010PerAte )+" AND " +;
	       	"     	  		SZ6.Z6_CODENT BETWEEN "+ValToSql( c010EntDe )+" AND "+ValToSql( c010EntAte )+" AND " 
		                                  
	If !Empty(c010Rede)
		cSQL +=	"     		SZ3.Z3_CLASSI = " +ValToSql( c010Rede )+ " AND "
	Endif

	If !Empty(c010CCR)
		cSQL +=	"      		SZ3.Z3_CCRCOM = " +ValToSql( c010CCR )+ " AND "
	Endif
 
	cSQL +=	"				SZ6.Z6_TIPO NOT IN ('CAMPCO','VERPAR') AND " +;
			"         		SZ5.D_E_L_E_T_ = ' ' AND SZ6.D_E_L_E_T_ = ' ' AND SZ3.D_E_L_E_T_ = ' ' " +;
			" ORDER BY    	SZ5.Z5_DATVER, SZ5.Z5_PEDGAR"
	
	If l010Query
		A010Script( cSQL )   
	Endif

	cTRB := GetNextAlias()
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,"Extraindo informa็๕es...")	

	If (cTRB)->(BOF()) .And. (cTRB)->(EOF())
		MsgInfo('Nใo foi possํvel encontrar registros com os parโmetros informados.', cDescriRel)
		(cTRB)->(dbCloseArea())
		Return(.F.)
	Endif
	
	nColSpace := 2
	cFont := 'Courier New'
	nFont := 7
	cOrient := 'PAISAGEM'                                                  
	aCab := {'POSTO','AGENTE','PRODUTO','PEDIDO','DT PEDIDO','DT VERIFICA','VALOR PRODUTO','TOTAL SOFTWARE','TOTAL HARDWARE','TOTAL REPASSE'}
	aAlign := {'LEFT','LEFT','LEFT','LEFT','LEFT','LEFT','RIGHT','RIGHT','RIGHT','RIGHT'}
	aPicture := {'@!','@!','@!','@!','@!','@!','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99','@E 99,999,999.99'}
	aSizeCol := {30,30,20,7,8,8,13,13,13,13}
	//           |  |  |  |  |  |  |  |  |  |
	//           |  |  |  |  |  |  |  |  |  +--> TOTAL REPASSE
	//           |  |  |  |  |  |  |  |  +-----> TOTAL HW
	//           |  |  |  |  |  |  |  +--------> TOTAL SW
	//           |  |  |  |  |  |  +-----------> VALOR TOTAL
	//           |  |  |  |  |  +--------------> DATA VERIFICACAO
	//           |  |  |  |  +-----------------> DATA PEDIDO
	//           |  |  |  +--------------------> PEDIDO
	//           |  |  +-----------------------> PRODUTO
	//           |  +--------------------------> AGENTE
	//           +-----------------------------> POSTO

	ProcRegua(0)

	cKey		:= (cTRB)->Z5_PEDGAR
	cDescPos	:= (cTRB)->Z5_DESPOS
	cMesAno		:= UPPER(MesExtenso((cTRB)->Z5_DATVER)) + "/" + Year2Str((cTRB)->Z5_DATVER)
	
	While (cTRB)->( !Eof() )                  
	
		IncProc()

		nTotCom += (cTRB)->Z6_VALCOM		
		
		If (cTRB)->Z6_CATPROD $ "2" // Software
			nTotSw += (cTRB)->Z6_VLRPROD
		Endif
		
		If (cTRB)->Z6_CATPROD $ "1" // Hardware
			nTotHw += (cTRB)->Z6_VLRPROD
		Endif
		
		cNomAge 	:= (cTRB)->Z5_NOMAGE
		cProdGar	:= (cTRB)->Z5_PRODGAR
		cPedGar		:= (cTRB)->Z5_PEDGAR    
		dDatPed		:= (cTRB)->Z5_DATPED
		dDatVer		:= (cTRB)->Z5_DATVER

		(cTRB)->( DbSkip() )

		If cKey <> (cTRB)->Z5_PEDGAR

	   		dDataFim	:= dDatVer
		   	dDataFim	:= LastDay(dDatVer,0)
            
			nT_TotPrd	+= nTotSw + nTotHw
			nT_TotSw  	+= nTotSw 
			nT_TotHw 	+= nTotHw
			nT_TotCom 	+= nTotCom

			nT_MesPrd	+= nTotSw + nTotHw
			nT_MesSw  	+= nTotSw 
			nT_MesHw 	+= nTotHw
			nT_MesCom 	+= nTotCom
                                                                                                                                  
			AAdd( aDados, { cDescPos, cNomAge, cProdGar, cPedGar, dDatPed, dDatVer, nTotSw+nTotHw, nTotSw, nTotHw, nTotCom } ) 
			
			nTotSw 		:= 0 
			nTotHw 		:= 0
			nTotCom 	:= 0

			cKey		:= (cTRB)->Z5_PEDGAR
			cDescPos	:= (cTRB)->Z5_DESPOS
			
			If cMesAno <> UPPER(MesExtenso((cTRB)->Z5_DATVER)) + "/" + Year2Str((cTRB)->Z5_DATVER)

				AAdd( aDados, Array( Len( aCab ) ) )
				nElem := Len( aDados )
				
				aDados[ nElem, 1 ] := 'LINHA'
				
				AAdd( aDados, Array( Len( aCab ) ) )
				nElem := Len( aDados )
			
				aDados[ nElem, 1 ] := 'TOTAL MสS ' + cMesAno
				aDados[ nElem, 7 ] := nT_MesPrd
				aDados[ nElem, 8 ] := nT_MesSw
				aDados[ nElem, 9 ] := nT_MesHw
				aDados[ nElem, 10 ] := nT_MesCom

				AAdd( aDados, Array( Len( aCab ) ) )
				
				nT_MesPrd	:= 0
				nT_MesSw  	:= 0
				nT_MesHw 	:= 0
				nT_MesCom 	:= 0
				cMesAno		:= UPPER(MesExtenso((cTRB)->Z5_DATVER)) + "/" + Year2Str((cTRB)->Z5_DATVER)
			
			Endif
		
		Endif
		
	End

	(cTRB)->( DbCloseArea() )
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )
	
	aDados[ nElem, 1 ] := 'LINHA'
	
	AAdd( aDados, Array( Len( aCab ) ) )
	nElem := Len( aDados )

	aDados[ nElem, 1 ] := 'TOTAL GERAL'
	aDados[ nElem, 7 ] := nT_TotPrd
	aDados[ nElem, 8 ] := nT_TotSw
	aDados[ nElem, 9 ] := nT_TotHw
	aDados[ nElem, 10 ] := nT_TotCom

	oReport := A010Report( aDados, aCab )
	oReport:PrintDialog()
	oReport:FreeAllObjs()
	
Return()             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ A010Script  บ Autor ณ Tatiana Pontes    บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para apresentar o script de instru็ใo SQL na tela   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A010Script( cSQL )

	Local cNomeArq := ''
	Local nHandle := 0
	Local lEmpty := .F.
	AutoGrLog('ativar para apagar')
	cNomeArq := NomeAutoLog()
	lEmpty := Empty( cNomeArq )
	If !lEmpty
		nHandle := FOpen( cNomeArq, 2 )
		FClose( nHandle )
		FErase( cNomeArq )
	Endif
	AutoGrLog( cSQL )
	MostraErro()
	If !lEmpty
		FClose( nHandle )
		FErase( cNomeArq )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ A010Report  บ Autor ณ Tatiana Pontes    บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de prepara็ใo para imprimir usando TReport		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A010Report( aCOLS, aHeader )

	Local oCell := NIL
	Local oReport
	Local oSection 
	
	Local nLen := Len(aHeader)
	Local nX := 0
	Local nCol := 0
	Local nElem := 0	
	Local nLargura := 0
	Local nSizeCol := Len( aSizeCol )

	oReport := TReport():New( FunName(),;
	                          cDescriRel + ' - Perํodo de ' + Dtoc(d010PerDe)+' at้ ' + Dtoc(d010PerAte), , ;
	                          {|oReport| A010Impr( oReport, aCOLS )}, ;
	                          cDescriRel + ' - Visใo ' + c010Visao + '.' )
	
	oReport:DisableOrientation() // Desabilita a sele็ใo da orienta็ใo (Retrato/Paisagem).
	oReport:SetEnvironment(2)    // Ambiente selecionado. Op็๕es: 1-Server e 2-Cliente.
	oReport:cFontBody := cFont   // Fonte definida para impressใo do relat๓rio (Consolas/Courier New)
	oReport:nFontBody	:= nFont   // Tamanho da fonte definida para impressใo do relat๓rio.
	oReport:nLineHeight := 30    // Altura da linha.
	
	If cOrient == 'RETRATO'
		oReport:SetPortrait()
	Elseif cOrient == 'PAISAGEM'
		oReport:SetLandscape()
	Else
		oReport:SetLandscape()
	Endif
	
	DEFINE SECTION oSection OF oReport TITLE cDescriRel TOTAL IN COLUMN
	
	For nX := 1 To nLen
		If nSizeCol > 0
			If nX <= nSizeCol
				nLargura := aSizeCol[ nX ]
			Else
				nLargura := 20
			Endif
		Else
			nLargura := 20
		Endif
		
		DEFINE CELL oCell NAME "CEL"+Alltrim(Str(nX-1)) OF oSection SIZE nLargura TITLE aHeader[ nX ]
		// Tem alinhamento?
		If Len( aAlign ) > 0
			// O elemento do vetor do alinhamento ้ suficiente em rela็ใo ao vetor principal?
			If nX <= Len( aAlign )
				oCell:SetAlign( aAlign[ nX ] )
			Endif
		Endif
	Next nX

	oSection:SetColSpace(nColSpace) // Define o espa็amento entre as colunas.
	oSection:nLinesBefore := 2    // Quantidade de linhas a serem saltadas antes da impressใo da se็ใo.
	oSection:SetLineBreak(.F.)      // Define que a impressใo poderแ ocorrer emu ma ou mais linhas no caso das colunas exederem o tamanho da pแgina.

Return( oReport )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ A010Impr    บ Autor ณ Tatiana Pontes    บ Data ณ 25/06/13  บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de impressใo das c้lulas TReport					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign Certificadora Digital                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function A010Impr( oReport, aCOLS )

	Local oSection := oReport:Section(1)
	Local nX := 0
	Local nY := 0

	oReport:SetMsgPrint('Aguarde, imprimindo...')
	oReport:SetMeter( Len( aCOLS ) )	
	oSection:Init()
	
	oSection:PrintLine()
		
	For nX := 1 To Len( aCOLS )
		If oReport:Cancel()
			Exit
		Endif
		If aCOLS[ nX, 1 ] == 'LINHA'
			oReport:SkipLine()
			oReport:FatLine()            
		Else
			For nY := 1 To Len(aCOLS[ nX ])
			   If ValType( aCOLS[ nX, nY ] ) == 'D'
			   	oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + Dtoc( aCOLS[ nX, nY ] ) + "'}") )
			   Elseif ValType( aCOLS[ nX, nY ] ) == 'N'
			   	oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + LTrim( TransForm( aCOLS[ nX, nY ], aPicture[ nY ] ) ) + "'}") )
			   Elseif ValType( aCOLS[ nX, nY ] ) == 'C'
			   	aCOLS[ nX, nY ] := StrTran( aCOLS[ nX, nY ], "'", "" )
			   	oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &( "{ || '" + aCOLS[ nX, nY ] + "'}" ) )
			   Else
			   	oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &( "{ || ' '}" ) )
			   Endif
			Next
			oSection:PrintLine()
		Endif
		oReport:IncMeter()
	Next
	oSection:Finish()

Return