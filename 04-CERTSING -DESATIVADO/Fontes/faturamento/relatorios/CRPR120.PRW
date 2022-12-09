#Include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma: CRPR120  บAutor  ณRenato Ruy Bernardo    บ Data ณ  12/08/2015บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio de Regras de Remunera็ใo.					      บฑฑ
ฑฑบ          ณ 			                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CRPR120()

Private cPerg       := "CRP120"

ValidPerg()
pergunte(cPerg,.T.)

If Empty(MV_PAR04)
	Alert("O relat๓rio foi cancelado!")
	Return
EndIf

Processa( {|| GerReg() }, "Selecionando registros...")

Return

//Processamento do relat๓rio

Static Function GerReg

Local oExcel 		:= FWMSEXCEL():New()
Local cAcAnt		:= ""
Local cNomArq		:= ""
Local cCcrAnt		:= ""
Local cTipEnt		:= ""
Local nQtd			:= 0

If Select("QCRPR120") > 0
	QCRPR120->(DbCloseArea())
EndIf

If MV_PAR03 == 1
	cNomArq := "CCR"
ElseIf MV_PAR03 == 2
	cTipEnt := "2"
	cNomArq := "AC"
ElseIf MV_PAR03 == 3
	cTipEnt := "1"       
	cNomArq := "Canal"
ElseIf MV_PAR03 == 4
	cTipEnt := "8"
	cNomArq := "Federacao"
EndIf

If MV_PAR03 == 1

	BeginSql Alias "QCRPR120"
	
		SELECT DISTINCT Z3_CODAC, 
		                Z3_CODCCR, 
		                Z3_CCRCOM, 
		                Z4_CATPROD, 
		                Z4_CATDESC,
		                (SELECT MAX(Z3_REMCAM) FROM PROTHEUS.SZ3010 WHERE Z3_FILIAL = ' ' AND Z3_TIPENT = '9' AND Z3_CODENT = SZ3.Z3_CODCCR AND D_E_L_E_T_ = ' ') Z3_REMCAM, 
		                Z4_PORSOFT, 
		                Z4_IMPSOFT, 
		                Z4_PORHARD, 
		                Z4_IMPHARD,
		                Z4_PORIR,
		                Z4_PARHW,
		                Z4_PARSW,
		                Z4_VALSOFT,
		                Z4_VALHARD
		FROM PROTHEUS.SZ3010 SZ3
		LEFT JOIN PROTHEUS.SZ4010 SZ4 ON Z4_FILIAL = ' ' AND Z4_CODENT = Z3_CODCCR AND SZ4.D_E_L_E_T_ = ' '
		WHERE
		Z3_FILIAL = ' ' AND
		Z3_TIPENT = '4' AND
		Z3_CODCCR > ' ' AND
		Z3_CODCCR Between %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND
		SZ3.D_E_L_E_T_ = ' '
		ORDER BY Z3_CODAC, Z3_CODCCR
	
	EndSQL
Else
	
	BeginSql Alias "QCRPR120"
		SELECT DISTINCT Z3_CODENT, 
		                Z3_DESENT, 
		                Z4_CATPROD, 
		                Z4_CATDESC, 
		                Z3_REMCAM,
		                Z4_PORSOFT, 
		                Z4_IMPSOFT, 
		                Z4_PORHARD, 
		                Z4_IMPHARD,
		                Z4_PORIR,
		                Z4_PARHW,
		                Z4_PARSW,
		                Z4_VALSOFT,
		                Z4_VALHARD
		FROM PROTHEUS.SZ3010 SZ3
		LEFT JOIN PROTHEUS.SZ4010 SZ4 ON Z4_FILIAL = ' ' AND Z4_CODENT = Z3_CODENT AND SZ4.D_E_L_E_T_ = ' '
		WHERE
		Z3_FILIAL = ' ' AND
		Z3_TIPENT = %Exp:cTipEnt% AND
		Z3_CODENT Between %Exp:MV_PAR01% AND %Exp:MV_PAR02% AND
		SZ3.D_E_L_E_T_ = ' '
		ORDER BY Z3_CODENT, Z4_CATPROD
	
	EndSQL
EndIf
	
DbSelectArea("QCRPR120")
QCRPR120->(DbGoTop())

If MV_PAR03 == 1
	//Cria nova aba
	oExcel:AddworkSheet("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4))
	
	//Cria Cabecalho da tabela
	oExcel:AddTable ("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4))
	
	//Adiciona cabecalho dos itens
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Cod. CCR"  		, 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Desc. CCR" 		, 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Cat. Prod."		, 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Desc.Prod."		, 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Abate Campanha?"	, 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Porc.Soft."		, 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Imp. Soft."		, 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Porc.Hard."		, 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Imp. Hard."		, 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Porc. IR"  		, 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Porc. SW Campanha", 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Porc. HW Campanha", 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Val.Fixo SW"		, 2,1)
	oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Val.Fixo HW"		, 2,1)
	
	cAcAnt := SubStr(QCRPR120->Z3_CODAC,1,4)
	
	While !EOF("QCRPR120")
	
		If cAcAnt <> SubStr(QCRPR120->Z3_CODAC,1,4)
	
		    cAcAnt := SubStr(QCRPR120->Z3_CODAC,1,4)
			cCcrAnt := QCRPR120->Z3_CODCCR
			
			//Cria nova aba
			oExcel:AddworkSheet("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4))
			
			//Cria Cabecalho da tabela
			oExcel:AddTable ("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4))
			
			//Adiciona cabecalho dos itens
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Cod. CCR"  		, 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Desc. CCR" 		, 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Cat. Prod."		, 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Desc.Prod."		, 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Abate Campanha?"	, 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Porc.Soft."		, 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Imp. Soft."		, 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Porc.Hard."		, 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Imp. Hard."		, 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Porc. IR"  		, 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Porc. SW Campanha", 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Porc. HW Campanha", 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Val.Fixo SW"		, 2,1)
			oExcel:AddColumn("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"Val.Fixo HW"		, 2,1)
		EndIf
		
		nQtd += 1
		
		IncProc( "Processo " + AllTrim(Str(nQtd)) + " --> Entidade: " + QCRPR120->Z3_CODCCR + " - " + QCRPR120->Z3_CCRCOM)
		ProcessMessage()
		
		//Adiciona Itens
		oExcel:AddRow("AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),"AC: " + SubStr(QCRPR120->Z3_CODAC,1,4),{ QCRPR120->Z3_CODCCR, ;
										                		QCRPR120->Z3_CCRCOM, ;
												                QCRPR120->Z4_CATPROD,; 
												                QCRPR120->Z4_CATDESC,; 
												                Iif(AllTrim(QCRPR120->Z3_REMCAM) == "S", "SIM","NAO"),; 
												                QCRPR120->Z4_PORSOFT,; 
												                QCRPR120->Z4_IMPSOFT,; 
												                QCRPR120->Z4_PORHARD,; 
												                QCRPR120->Z4_IMPHARD,;
												                QCRPR120->Z4_PORIR,  ;
												                QCRPR120->Z4_PARSW,  ;
												                QCRPR120->Z4_PARHW,  ;
												                QCRPR120->Z4_VALSOFT,;
												                QCRPR120->Z4_VALHARD})
			
		QCRPR120->(DbSkip())
	EndDo
Else
	//Cria nova aba
	oExcel:AddworkSheet(cNomArq)
			
	//Cria Cabecalho da tabela
	oExcel:AddTable (cNomArq,cNomArq)
			
	//Adiciona cabecalho dos itens
	oExcel:AddColumn(cNomArq,cNomArq,"Cod. Ent."  		, 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Desc. Ent." 		, 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Cat. Prod."		, 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Desc.Prod."		, 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Abate Campanha?"	, 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Porc.Soft."		, 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Imp. Soft."		, 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Porc.Hard."		, 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Imp. Hard."		, 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Porc. IR"  		, 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Porc. SW Campanha", 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Porc. HW Campanha", 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Val.Fixo SW"		, 2,1)
	oExcel:AddColumn(cNomArq,cNomArq,"Val.Fixo HW"		, 2,1)


	While !EOF("QCRPR120")
	
		nQtd += 1
		
		IncProc( "Processo " + AllTrim(Str(nQtd)) + " --> Entidade: " + QCRPR120->Z3_CODENT + " - " + QCRPR120->Z3_DESENT)
		ProcessMessage()
	
		//Adiciona Itens
		oExcel:AddRow(cNomArq,cNomArq,{ QCRPR120->Z3_CODENT, ;
				                		QCRPR120->Z3_DESENT, ;
						                QCRPR120->Z4_CATPROD,; 
						                QCRPR120->Z4_CATDESC,; 
						                Iif(AllTrim(QCRPR120->Z3_REMCAM) == "S", "SIM","NAO"),; 
						                QCRPR120->Z4_PORSOFT,; 
						                QCRPR120->Z4_IMPSOFT,; 
						                QCRPR120->Z4_PORHARD,; 
						                QCRPR120->Z4_IMPHARD,;
						                QCRPR120->Z4_PORIR,  ;
						                QCRPR120->Z4_PARSW,  ;
						                QCRPR120->Z4_PARHW,  ;
						                QCRPR120->Z4_VALSOFT,;
						                QCRPR120->Z4_VALHARD})
			
		QCRPR120->(DbSkip())
	EndDo
EndIf
	
//Salva o Arquivo
oExcel:Activate()
oExcel:GetXMLFile(MV_PAR04 + cNomArq + " - Regras.xml") 

MsgInfo("Arquivo Exportado para: " + MV_PAR04 + cNomArq + " - Regras.xml")

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ValidPerg บAutor  ณRenato Ruy Bernardo    บ Data ณ  04/06/2013บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo Responsavel por criar as perguntas utilizadas no    บฑฑ
ฑฑบ          ณ Relat๓rio.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()
Local aHelp		:=	{}


cPerg := PADR( cPerg, Len(SX1->X1_GRUPO) )


//    ( [ cGrupo ] 	[ cOrdem ] 	[ cPergunt ] 				[ cPerSpa ] 				[ cPerEng ] 				[ cVar ] 	[ cTipo ] 	[ nTamanho ] 	[ nDecimal ] 	[ nPresel ] [ cGSC ] 	[ cValid ] 	[ cF3 ] 	[ cGrpSxg ] [ cPyme ] 	[ cVar01 ] 	[ cDef01 ] 			[ cDefSpa1 ] 		[ cDefEng1 ] 		[ cCnt01 ] [ cDef02 ] 		[ cDefSpa2 ] 	[ cDefEng2 ] 	[ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] 	[ cDef04 ] 	[ cDefSpa4 ] 	[ cDefEng4 ] 	[ cDef05 ] 	[ cDefSpa5 ] 	[ cDefEng5 ] 	 [ aHelpPor ] 	[ aHelpEng ] 	 	[ aHelpSpa ] 		[ cHelp ] 	)
PutSX1(	cPerg		,"01" 		,"Entidade De?"		  		,"AC De?"	 		  		,"AC De?"	 		  		,"mv_ch1" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par01"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"02" 		,"Entidade Ate?"	  		,"Entidade Ate?"	  		,"Entidade Ate?"	  		,"mv_ch2" 	,"C" 		,06     		,0      		,0     		,"G"		,""          ,""	    ,""         ,"S"        ,"mv_par02"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   			,""   		,""   			,""   		    ,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"03" 		,"Tipo Entidade ?"	  		,"Tipo Entidade ?"	  		,"Tipo Entidade ?"	  		,"mv_ch3" 	,"N" 		,01     		,0      		,0     		,"C"		,""          ,""	    ,""         ,"S"        ,"mv_par03"	,"CCR"   			,"CCR"   			,"CCR"   			,""   		,"AC"    		,"AC"    		,"AC"  			,"Canal"    ,"Canal"    ,"Canal"    	,"Federa็ใo","Federa็ใo"	,"Federa็ใo"	,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)
PutSX1(	cPerg		,"04" 		,"Diretorio ?"	  			,"Diretorio ?"		  		,"Diretorio ?"		  		,"mv_ch4" 	,"C" 		,75     		,0      		,0     		,"C"		,"U_CRPR120A",""	    ,""         ,"S"        ,"mv_par04"	,""        			,""           		,""          		,""   		,""             ,""             ,""             ,""   		,""   		,""   		  	,""   		,""   			,""   			,""         ,""   			,""   			, {""}		  ,	 {""}  				, {""} 				,""   		)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA01   บAutor  ณMicrosiga           บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CRPR120A()
Local cAux := ""
Local cDirIn := ""

MV_PAR04 := IIF(!Empty(cAux:=(cGetFile("\", "Diret๓rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

Return(.T.)