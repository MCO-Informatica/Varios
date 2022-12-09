#INCLUDE "PROTHEUS.CH"

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½GARA183   ï¿½Autor  ï¿½OPVS (David)        ï¿½ Data ï¿½  06/02/10   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Desc.     ï¿½ Programa de exportacao de arquivo TXT em layout especifico ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½ para importacao pelo sistema GAR                           ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ JOB executado em horario especificado em parametro        ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

User Function GARA183(aParSch)
	Local aRET := {}
	Local aPAR := {}
	Private cJobEmp	:= Iif( aParSch == NIL, '01', aParSch[ 1 ] )	
	Private cJobFil	:= Iif( aParSch == NIL, '02', aParSch[ 2 ] )
	Private _lJob 	:= (Select('SX6')==0)

	Conout("Job GARA183 - Begin Emp("+cJobEmp+"/"+cJobFil+")" )
	If _lJob
		RpcSetType(2)
		RpcSetEnv(cJobEmp, cJobFil)
		A183Proc()
	Else
		aAdd( aPAR, {1, "Data de"	 , Ctod(Space(8)), "","",""   ,"",0,.T.})
		aAdd( aPAR, {1, "Data ate"	 , Ctod(Space(8)), "","",""   ,"",0,.T.})
		IF ParamBox(aPAR,"Faturamento Diário",@aRET)
			A183Proc( aRET )
		EndIF
	EndIF
	Conout("Job GARA183- End Begin Emp("+cJobEmp+"/"+cJobFil+")" )
Return

Static Function A183Proc( aRET )
	Local cTime :=  time()
	Local _cSql 	:= ""
	Local cFileOut  := ""
	Local nHandle	:= -1 
	Local cValor	:= ""
	Local cHrExec	:= ""
	Local nTotRec	:= 0
	Local nTotRec	:= 0
	Local nTotRec	:= 0
	Local lForce    :=.F.

	Default aRET := {}

	cHrExec 	:=  GetNewPar("MV_GARTXTH", "00:01")
	nDiasAnt 	:=  GetNewPar("MV_GARTXTD", 0)      
	cCanalVen 	:=  GetNewPar("MV_GARTXCN", "000001,000003")
	cSegProd 	:=  GetNewPar("MV_GARTXSG", "000001,000004")

	Conout("Job GARA183 - Início do EXECUTE Emp("+cJobEmp+"/"+cJobFil+") - hora atual " +Substr(time(),1,5) +" hora do parametro" + cHrExec )

	While !File("\pedidosfaturados\faturamento_diario_"+Dtos(DATE())+".txt")
		
		Conout("Job GARA183 - Executa o Select " + Time())
		_cSql := "SELECT "																								+Chr(13)+Chr(10)
		_cSql += "SUBSTR(C6_DATFAT,7,2) || '/' || SUBSTR(C6_DATFAT,5,2) || '/' || SUBSTR(C6_DATFAT,1,4) AS DT_FATURAMENTO, 	"	+Chr(13)+Chr(10)
		_cSql += "CASE A3_XCANAL  		WHEN  '000001' THEN 'VD' 		ELSE 'CO' 	END AS TIPO, 	"							+Chr(13)+Chr(10)
		_cSql += "SUM(C6_QTDVEN) AS QT_PRODUTO, 	"																			+Chr(13)+Chr(10)
		_cSql += "SUM(C6_VALOR) AS VL_PRODUTO,"																					+Chr(13)+Chr(10)
		_cSql += "UPPER(A1_MUN) A1_MUN,"																						+Chr(13)+Chr(10)  // Retornar para voltar o mun e estado.
		_cSql += "UPPER(A1_EST)  A1_EST"																						+Chr(13)+Chr(10)
		_cSql += "FROM  	"																									+Chr(13)+Chr(10)
		_cSql += " "+RetSqlName("SA1")+" SA1  INNER JOIN "+RetSqlName("SC5")+" SC5 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI "		+Chr(13)+Chr(10)
		_cSql += "            INNER JOIN "+RetSqlName("SC6")+" SC6 ON  	C5_NUM = C6_NUM "										+Chr(13)+Chr(10)
		_cSql += "            INNER JOIN "+RetSqlName("SA3")+" SA3 ON  	C5_VEND1 = A3_COD "										+Chr(13)+Chr(10)
		_cSql += "            INNER JOIN "+RetSqlName("SB1")+" SB1 ON  	C6_PRODUTO = B1_COD "									+Chr(13)+Chr(10)
		_cSql += "WHERE  	"																									+Chr(13)+Chr(10)
		_cSql += "C5_FILIAL = '"+xFilial("SC5")+"' "																			+Chr(13)+Chr(10)
		_cSql += "AND  	SC5.D_E_L_E_T_ = ' ' "																					+Chr(13)+Chr(10)
		_cSql += "AND  	C6_FILIAL = '"+xFilial("SC6")+"' "																		+Chr(13)+Chr(10)
		_cSql += "AND  	C6_PEDGAR = '" + Space(TamSX3("C6_PEDGAR")[1]) + "' "													+Chr(13)+Chr(10)
		IF _lJob
			_cSql += "AND   C6_DATFAT >= '"+DtoS(DATE()-nDiasAnt)+"' "															+Chr(13)+Chr(10)
		Else
			_cSql += "AND   C6_DATFAT >= '" + dTos( aRET[1] ) + "' AND C6_DATFAT <= '"+ dTos( aRET[2] ) + "' "					+Chr(13)+Chr(10)
		EndIF
		_cSql += "AND   C6_XOPER <> '53' "																						+Chr(13)+Chr(10)
		_cSql += "AND    SC6.D_E_L_E_T_ = ' ' "																					+Chr(13)+Chr(10)
		_cSql += "AND  	A3_FILIAL = '"+xFilial("SA3")+"' "																		+Chr(13)+Chr(10)
		_cSql += "AND  	A3_XCANAL IN ('"+StrTran(cCanalVen,",","','")+"') "														+Chr(13)+Chr(10)
		_cSql += "AND  	SA3.D_E_L_E_T_ = ' ' "																					+Chr(13)+Chr(10)
		_cSql += "AND  	B1_FILIAL = '"+xFilial("SB1")+"' "																		+Chr(13)+Chr(10)
		_cSql += "AND   	B1_XSEG IN ('"+StrTran(cSegProd,",","','")+"') "													+Chr(13)+Chr(10)
		_cSql += "AND  	SB1.D_E_L_E_T_ = ' '	"																				+Chr(13)+Chr(10)
	   	_cSql += "GROUP BY  	C6_DATFAT,  	A3_XCANAL ,UPPER(A1_MUN),UPPER(A1_EST) "										+Chr(13)+Chr(10)   // Voltar a linha e apagar a linha de baixo. 
	  	_cSql += "ORDER BY 	C6_DATFAT "																							+Chr(13)+Chr(10)
			
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSql),"TRBDIAR",.F.,.T.)
		
		TcSetField("TRBDIAR","VL_PRODUTO","N",15,2)
		TcSetField("TRBDIAR","QT_PRODUTO","N",4,0)
		
		//Path da pasta onde os arquivos gerados serao salvos \\192.168.16.30\t$\Totvs\Protheus_Data10\pedidosfaturados	
		cFileOut := "\pedidosfaturados\faturamento_diario_"+Dtos(DATE())+".txt"
		
		nHandle := FCREATE(cFileOut) 
		
		Conout("Job GARA183 - Iniciou gravaçao do arquivo " + Time())
	
		If nHandle != -1


													//PADL(alltrim(TRBDIAR->A1_MUN),35)+;    //Colar este informacao na linha 113
													//PADL(alltrim(TRBDIAR->A1_EST),2)+;
				
			TRBDIAR->(DbEval({||	nTotRec := nTotRec+1,;
									cValor  := Str(TRBDIAR->VL_PRODUTO),;
									FWrite(nHandle,	PADL(TRBDIAR->TIPO,2)+;	
													PADL(alltrim(Str(TRBDIAR->QT_PRODUTO)),10)+;
													PADL(StrTran(alltrim(cValor),".",","),16)+;   
													PADL(TRBDIAR->DT_FATURAMENTO,10)+;
													PADL(alltrim(TRBDIAR->A1_MUN),35)+;   
													PADL(alltrim(TRBDIAR->A1_EST),2)+;
													CRLF ) }) )		
		
			fclose(nHandle)
			Conout("Job GARA183 - Finalizou gravaçao do arquivo " + Time())

		Else

			Conout("Job GARA183 - Falhou a gravaçao do arquivo " + Time())
	
		Endif
		
		TRBDIAR->(DbCloseArea())
	EndDo

	Conout("Job GARA183 - Fim    do EXECUTE Emp("+cJobEmp+"/"+cJobFil+") - hora atual " +Substr(time(),1,5) +" hora do parametro" + cHrExec )

	Conout("Job GARA183- End Begin Emp("+cJobEmp+"/"+cJobFil+")" )
	ApMsgInfo( 'Processo finalizado', '[GARA183] - Faturamento diário')
Return