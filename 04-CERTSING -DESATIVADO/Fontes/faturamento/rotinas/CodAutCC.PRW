#Include 'Protheus.ch'

User Function CodAutCC(aParam)
  Local lJob 		:= ( Select( "SX6" ) == 0 )
	Local cJobEmp	:= Iif( aParam == NIL, '01' , aParam[ 1 ] )
	Local cJobFil	:= Iif( aParam == NIL, '02' , aParam[ 2 ] )

  If lJob
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil )
	EndIf

	CodAutCC1()
	CodAutCC2()
	
Return

Static Function CodAutCC1()

Local cXml 			  := ""
Local lOk			    := .T.
Local oWsObj
Local cSvcError		:= ""
Local cSoapFCode	:= ""
Local cSoapFDescr	:= ""
Local cSql			  := ""
Local cAux			  := ""
Local nAux1			  := 0
Local nAux2			  := 0
Local dDtOld		  := nil

If .NOT. GetMv( 'MV_CSAUTCC', .T. )
	CriarSX6( 'MV_CSAUTCC', 'C', 'Dias para retroceder na query. CodAutCC.prw', '7' )
Endif

dDtOld := dDataBase - Val( GetMv( 'MV_CSAUTCC', .F. ) )

BeginSql Alias "BASE"
	
  SELECT RECNO_SC5, RECNO_GTIN, PEDIDO,EMIS_PED, XNPSITE,  XDATE, XCODAUT, XDOCUME,XTIDCC, XCARTAO, XOPER, EMIS_PR,TOTALPED, GTCARTAO, GTCODAUT, CODCONFIR, DOCUMEN
  
       FROM
      
       (
          SELECT RECNO_SC5, RECNO_GTIN, PEDIDO,EMIS_PED, XNPSITE,  XDATE, XCODAUT, XDOCUME,XTIDCC, XCARTAO, XOPER, EMIS_PR, TOTALPED, GTCARTAO,
          SUBSTR(CODAUT,POSINI_CODAUT,POSFIN_CODAUT-POSINI_CODAUT) GTCODAUT,
               SUBSTR(CODAUT,POSINI_CODCONFIR,POSFIN_CODCONFIR-POSINI_CODCONFIR) CODCONFIR,
               SUBSTR(CODAUT,POSINI_DOCUMEN,POSFIN_DOCUMEN-POSINI_DOCUMEN) DOCUMEN,
                 CODAUT

          FROM
                  (
                  SELECT RECNO_SC5, RECNO_GTIN, PEDIDO,EMIS_PED, XNPSITE, XDATE, XCODAUT, XDOCUME ,XTIDCC, XCARTAO, XOPER, EMIS_PR,TOTALPED,
                  INSTR(CODAUT,'[C5_XCODAUT]')+54 POSINI_CODAUT,
                  INSTR(CODAUT,'[C5_XCODAUT]')+60 POSFIN_CODAUT,
                  INSTR(CODAUT,'[C5_XTIDCC]')+53 POSINI_CODCONFIR ,
                  INSTR(CODAUT,'[C5_XTIDCC]')+73 POSFIN_CODCONFIR,
                  INSTR(CODAUT,'[C5_XDOCUME]')+54 POSINI_DOCUMEN ,
                  INSTR(CODAUT,'[C5_XDOCUME]')+60 POSFIN_DOCUMEN,
                  CODAUT,
                  GTCARTAO
                  
                  FROM
                          (
                          
                          SELECT
                            SC5.R_E_C_N_O_ RECNO_SC5,
                            GTIN.R_E_C_N_O_ RECNO_GTIN,
                            SC5.C5_XCARTAO XCARTAO, 
                            (SELECT MAX (SC6.C6_XOPER)   FROM PROTHEUS.SC6010 SC6 WHERE C6_FILIAL=SC5.C5_FILIAL AND C6_NUM=SC5.C5_NUM AND SC6.%NOTDEL%)  AS XOPER,
                            (SELECT MIN (SE1.E1_EMISSAO) FROM PROTHEUS.SE1010 SE1 WHERE E1_FILIAL=' ' AND E1_PEDIDO=C5_NUM AND SE1.%NOTDEL% AND SE1.E1_TIPO='PR')  AS EMIS_PR,
                            SC5.C5_EMISSAO EMIS_PED,
                            SC5.C5_NUM PEDIDO,
                            SC5.C5_TOTPED+SC5.C5_FRETE TOTALPED,
                            SC5.C5_XCODAUT XCODAUT,
                            SC5.C5_XDOCUME XDOCUME,
                            SC5.C5_XTIDCC XTIDCC,
                            GT_ID GTID,
                            GT_XNPSITE XNPSITE,
                            SC5.C5_XNPSITE C5XNPSITE,
                            GT_PEDGAR PEDGAR,
                            SC5.C5_CHVBPAG C5PEDGAR,
                            GT_DATE XDATE,
                            UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM,2000,6000)) CODAUT,
                            GT_CARTAO GTCARTAO
                          FROM PROTHEUS.GTIN GTIN, PROTHEUS.SC5010 SC5
                          WHERE
                          C5_FILIAL='  ' 
                          AND C5_EMISSAO >= %Exp:dDtOld%
                          AND SC5.%NOTDEL%
                          AND C5_XNPSITE > ' '
                          AND (C5_XCARTAO=' ' OR C5_XTIDCC=' ' OR  C5_XDOCUME=' '  OR C5_XCODAUT=' ')
                          //AND C5_XCARTAO<>' '
                          AND (C5_XNPSITE = GT_XNPSITE)
                          AND GT_TYPE ='P'
                          AND GTIN.%NOTDEL%
                          AND UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM,2000,6000)) LIKE  '%C5_XTIDCC%'

                          )
                  WHERE
                  //EMIS_PR IS NULL AND
                  CODAUT LIKE '%C5_XTIDCC%'
                  )
          ) BASE
       WHERE
         (XTIDCC =' ' AND BASE.CODCONFIR NOT LIKE '%]%')
      OR (XCODAUT=' ' AND BASE.GTCODAUT  NOT LIKE '%]%')
      OR (XDOCUME=' ' AND BASE.DOCUMEN   NOT LIKE '%]%')
      OR (XCARTAO=' ' AND BASE.GTCARTAO  NOT LIKE '%]%')
     
ENDSQL


WHILE BASE->(!Eof())

	
			cXml :="<notificaProcessamentoCartao>" + CRLF
			cXml +="   <pedido>" + CRLF
			cXml +="     <numero>" + Alltrim(BASE->XNPSITE) +"</numero>" + CRLF 
			cXml +="   </pedido>"  + CRLF
			cXml +="   <confirmacao>" + CRLF   
			cXml +="     <tipo>0</tipo>" + CRLF   
			cXml +="     <cartao>" + Alltrim(BASE->GTCARTAO) + "</cartao>" + CRLF    
			cXml +="     <documento>"         + IIF(SUBSTR(BASE->DOCUMEN  ,1,1)=="]",Alltrim(BASE->XDOCUME),Alltrim(BASE->DOCUMEN)   ) + "</documento>" + CRLF    
			cXml +="     <codigoConfirmacao>" + IIF(SUBSTR(BASE->CODCONFIR,1,1)=="]",Alltrim(BASE->XTIDCC) ,Alltrim(BASE->CODCONFIR) ) + "</codigoConfirmacao>" + CRLF   
			cXml +="     <autorizacao>"       + IIF(SUBSTR(BASE->GTCODAUT ,1,1)=="]",Alltrim(BASE->XCODAUT),Alltrim(BASE->GTCODAUT)  ) + "</autorizacao>" + CRLF 
			cXml +="    </confirmacao>" + CRLF
			cXml +="</notificaProcessamentoCartao>" + CRLF

      oWsObj := WSHARDWAREAVULSOPROVIDER():New()
	
			//Envia Xml para gerar o PR
			lOk := oWsObj:faturaCC(cXml)
	
			If !lOk
				cSvcError   := GetWSCError()  // Resumo do erro
				cSoapFCode  := GetWSCError(2)  // Soap Fault Code
				cSoapFDescr := GetWSCError(3)  // Soap Fault Description
			EndIf
      
		BASE->(DBSKIP())        
ENDDO
    
BASE->(DbCloseArea())
	
Return


Static Function CodAutCC2()

Local cXml 			  := ""
Local lOk			    := .T.
Local oWsObj
Local cSvcError		:= ""
Local cSoapFCode	:= ""
Local cSoapFDescr	:= ""
Local cSql			  := ""
Local cAux			  := ""
Local nAux1			  := 0
Local nAux2			  := 0
Local dDtOld		  := nil

If .NOT. GetMv( 'MV_CSAUTCC', .T. )
	CriarSX6( 'MV_CSAUTCC', 'N', 'Dias para retroceder na query. CodAutCC.prw', '7' )
Endif

dDtOld := dDataBase - Val( GetMv( 'MV_CSAUTCC', .F. ) )

BeginSql Alias "BASE"
	
  SELECT XNPSITE, TOTALPED, min(RECNO_GTIN) RECNO_GTIN
       FROM
       (
          SELECT RECNO_SC5, RECNO_GTIN, PEDIDO,EMIS_PED, XNPSITE,  XDATE, XCODAUT, XCARTAO, XOPER, EMIS_PR,TOTALPED,
                 SUBSTR(CODAUT,POSINI_CODAUT,POSFIN_CODAUT-POSINI_CODAUT) GTCODAUT,
                 SUBSTR(CODAUT,POSINI_CODCONFIR,POSFIN_CODCONFIR-POSINI_CODCONFIR) CODCONFIR,
                 SUBSTR(CODAUT,POSINI_DOCUMEN,POSFIN_DOCUMEN-POSINI_DOCUMEN) DOCUMEN,
                 CODAUT

          FROM
                  (
                  SELECT RECNO_SC5, RECNO_GTIN, PEDIDO,EMIS_PED, XNPSITE, XDATE, XCODAUT, XCARTAO, XOPER, EMIS_PR,TOTALPED,
                  INSTR(CODAUT,'autorizacao')+12 POSINI_CODAUT,
                  INSTR(CODAUT,'</autorizacao') POSFIN_CODAUT,
                  INSTR(CODAUT,'codigoConfirmacao')+18 POSINI_CODCONFIR ,
                  INSTR(CODAUT,'</codigoConfirmacao') POSFIN_CODCONFIR,
                  INSTR(CODAUT,'documento')+10 POSINI_DOCUMEN ,
                  INSTR(CODAUT,'</documento') POSFIN_DOCUMEN,
                  CODAUT
                  FROM
                          (
                          SELECT
                            SC5.R_E_C_N_O_ RECNO_SC5,
                            GTIN.R_E_C_N_O_ RECNO_GTIN,
                            SC5.C5_XCARTAO XCARTAO, 
                            (SELECT MAX (SC6.C6_XOPER)   FROM PROTHEUS.SC6010 SC6 WHERE C6_FILIAL=SC5.C5_FILIAL AND C6_NUM=SC5.C5_NUM AND SC6.%NOTDEL%)  AS XOPER,
                            (SELECT MIN (SE1.E1_EMISSAO) FROM PROTHEUS.SE1010 SE1 WHERE E1_FILIAL=' ' AND E1_PEDIDO=C5_NUM AND SE1.%NOTDEL% AND SE1.E1_TIPO='PR')  AS EMIS_PR,
                            SC5.C5_EMISSAO EMIS_PED,
                            SC5.C5_NUM PEDIDO,
                            SC5.C5_TOTPED+SC5.C5_FRETE TOTALPED,
                            SC5.C5_XCODAUT XCODAUT,
                            GT_ID GTID,
                            GT_XNPSITE XNPSITE,
                            SC5.C5_XNPSITE C5XNPSITE,
                            GT_PEDGAR PEDGAR,
                            SC5.C5_CHVBPAG C5PEDGAR,
                            GT_DATE XDATE,
                            UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM,2000,1)) CODAUT
                          FROM PROTHEUS.GTIN GTIN, PROTHEUS.SC5010 SC5
                          WHERE
                          C5_FILIAL=%xFilial:SC5% 
                          AND C5_EMISSAO >= %Exp:dDtOld%
                          AND SC5.%NOTDEL%
                          AND C5_XNPSITE > ' '
                          AND (C5_XNPSITE = GT_XNPSITE)
                          AND GT_TYPE ='N'
                          AND GTIN.%NOTDEL%
                          AND UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM,2000,1)) LIKE  '%autorizacao%'

                          )
                  WHERE
                  CODAUT LIKE '%autorizacao%'

                  )
          WHERE
          POSINI_CODAUT<>POSFIN_CODAUT
          ) BASE
       WHERE
       BASE.GTCODAUT IS NOT NULL AND 
      (
        (BASE.EMIS_PR IS NULL AND BASE.XOPER IN('61','62','01') AND XCODAUT <>'TEF ITAU')// --tem autorização no SC5 mas nao tem PR
      
         OR //-- que
      
        (BASE.XCODAUT =' ') //--nao gravou autorização no sc5
      
      )
      Group By XNPSITE,TOTALPED

ENDSQL


WHILE BASE->(!Eof())

        //Coleta dados do campo memo no GTIN
		cSql := "SELECT "
		cSql += " NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM,2000,1)),'') GT_PARAM, GT_DATE XDATE "
		cSql += "FROM "
		cSql += "   PROTHEUS.GTIN "
		cSql += "WHERE "
		cSql += "   GT_TYPE = 'N' AND "
		cSql += "   R_E_C_N_O_ = "+STR(BASE->RECNO_GTIN)+" AND"
		cSql += "   NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(GT_PARAM,2000,1)),'') LIKE '% [FATURACC]%' "

		PlsQuery(cSql,"TRBGT")

		If TRBGT->(!Eof())
	        
			//Prepara strutura do campo memo 
			cGtParam := StrTran( TRBGT->GT_PARAM,CHR(13)+CHR(10),'')
			cGtParam := Alltrim(cGtParam)
	        
	        //Ajusta data Base para inclusão do PR
	        dDataBase:=StoD(TRBGT->XDATE)
	
			nAux1 	:= At("<notificaProcessamentoCartao>",cGtParam)
			nAux2 	:= RAt("</notificaProcessamentoCartao>",cGtParam)
	
	
			cXml := SubStr(cGtParam,nAux1,nAux2-77)
	
			oWsObj := WSHARDWAREAVULSOPROVIDER():New()
	
			//Envia Xml para gerar o PR
			lOk := oWsObj:faturaCC(cXml)
	
			If !lOk
				cSvcError   := GetWSCError()  // Resumo do erro
				cSoapFCode  := GetWSCError(2)  // Soap Fault Code
				cSoapFDescr := GetWSCError(3)  // Soap Fault Description
			EndIf
		
			TRBGT->(DBSKIP())	
		EndIf
	
		TRBGT->(DbCloseArea())
		
		BASE->(DBSKIP())        
ENDDO
    
BASE->(DbCloseArea())
	
Return