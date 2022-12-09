#Include 'Protheus.ch'
#Include 'Topconn.ch'
#Include "rwmake.ch"
#INCLUDE "TBICONN.CH"
//+-------------------------------------------------------------------+
//| Rotina | GARA181A | Autor | Rafael Beghini | Data | 22.04.2016 
//+-------------------------------------------------------------------+
//| Descr. | Programa de exportacao de arquivo TXT em layout 
//|        | especifico para importacao pelo sistema GAR
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
User Function GARA181A(aParSch)
	Local aRET := {}
	Local aPAR := {}

	Private _lJob   := (Select('SX6')==0)
	
	Private cJobEmp := Iif( aParSch == NIL, '01', aParSch[ 1 ] )	
	Private cJobFil := Iif( aParSch == NIL, '02', aParSch[ 2 ] )
	Private DT_FAT_SOFT := ""
	Private DT_FAT_HARD := ""
	Private DT_FATURA   := ""
		
	Conout( "Job GARA181 - Begin Emp("+cJobEmp+"/"+cJobFil+") - ["+ Dtoc(Date()) +" - "+ TIME() +"]" )
	IF _lJob
		RpcSetType(2)
		RpcSetEnv(cJobEmp, cJobFil)
		A181Proc()
	Else
		aAdd( aPAR, {1, "Data de"	 , Ctod(Space(8)), "","",""   ,"",0,.T.})
	    aAdd( aPAR, {1, "Data ate"	 , Ctod(Space(8)), "","",""   ,"",0,.T.})
		IF ParamBox(aPAR,"Pedidos Microsiga",@aRET)
			A181Proc( aRET )
		EndIF
	EndIF
	Conout( "Job GARA181 - End Begin Emp("+cJobEmp+"/"+cJobFil+") - ["+ Dtoc(Date()) +" - "+ TIME() +"]" )
Return
//+-------------------------------------------------------------------+
//| Rotina | A181Proc | Autor | Rafael Beghini | Data | 22.04.2016 
//+-------------------------------------------------------------------+
//| Descr. | Executa a rotina 
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function A181Proc( aRET )
	Local cSQL     := ''
	Local cTRB     := ''
	Local cFileOut := ''
	Local nHandle  := -1
	Local nDiasAnt :=  GetNewPar("MV_GARTXTD", 0)
	Local cFiltraDia  := DtoS(date()-nDiasAnt)
	Local cNameFile  := "\pedidosfaturados\pedidos_microsiga_"+Dtos(DATE())+".txt"
	Local aDADOS	:= {}
	
	Default aRET := {}
	
	Conout( "Job GARA181 - A181PROC" )
	
	IF File( cNameFile )
		Ferase( cNameFile )
	EndIF
	
	nHandle := FCreate( cNameFile )
	
	IF nHandle > 0
		cSQL += "SELECT distinct " + CRLF
		cSQL += "       c5_cliente    AS CLIENTE, " + CRLF
		cSQL += "       Upper(a1_mun) AS MUN, " + CRLF
		cSQL += "       Upper(a1_est) AS EST, " + CRLF
		cSQL += "       c5_chvbpag    AS PEDGAR, " + CRLF
		cSQL += "       d2_pedido     AS PEDIDO, " + CRLF
		cSQL += "       c5_totped     AS VL_FATURAMENTO, " + CRLF
		cSQL += "       ( CASE " + CRLF
		cSQL += "           WHEN c5_tipmov = '1' THEN 'Boleto' " + CRLF
		cSQL += "           WHEN c5_tipmov = '2' THEN 'Cartao Credito' " + CRLF
		cSQL += "           WHEN c5_tipmov = '3' THEN 'Cartao Debito' " + CRLF
		cSQL += "           WHEN c5_tipmov = '4' THEN 'DA' " + CRLF
		cSQL += "           WHEN c5_tipmov = '5' THEN 'DDA' " + CRLF
		cSQL += "           WHEN c5_tipmov = '6' THEN 'Voucher' " + CRLF
		cSQL += "           ELSE 'Outros' " + CRLF
		cSQL += "         END )       DS_FMA_PGTO " + CRLF
		cSQL += "FROM   (SELECT DISTINCT c5_chvbpag, " + CRLF
		cSQL += "                        d2_pedido, " + CRLF
		cSQL += "                        c5_cliente, " + CRLF
		cSQL += "                        d2_emissao, " + CRLF
		cSQL += "                        c5_totped, " + CRLF
		cSQL += "                        c5_tipmov " + CRLF
		cSQL += "        FROM   "+ RetSqlName("SD2") +" SD2 " + CRLF
		cSQL += "               INNER JOIN "+ RetSqlName("SC5") +" SC5 " + CRLF
		cSQL += "                       ON SC5.d_e_l_e_t_ = ' ' " + CRLF
		cSQL += "                          AND SC5.c5_filial = '"+xFilial("SC5")+"' " + CRLF
		cSQL += "                          AND SC5.c5_num = SD2.d2_pedido " + CRLF
		cSQL += "                          AND c5_chvbpag <> '          '" + CRLF

		cSQL += "               INNER JOIN "+ RetSqlName("SC6") +" SC6 " + CRLF
		cSQL += "                       ON SC6.d_e_l_e_t_ = ' ' " + CRLF
		cSQL += "                          AND SC6.C6_FILIAL = SC5.c5_filial " + CRLF
		cSQL += "                          AND SC6.C6_NUM = SC5.c5_num " + CRLF
		cSQL += "                          AND SC6.C6_XOPER <> '53' " + CRLF
		
		cSQL += "               INNER JOIN "+ RetSqlName("SF4") +" SF4 " + CRLF
		cSQL += "                       ON SF4.d_e_l_e_t_ = ' ' " + CRLF
		cSQL += "                          AND SF4.f4_codigo = SD2.d2_tes " + CRLF
		cSQL += "                          AND SF4.f4_duplic = 'S' " + CRLF
		cSQL += "               INNER JOIN "+ RetSqlName("SB1") +" SB1 " + CRLF
		cSQL += "                       ON SB1.d_e_l_e_t_ = ' ' " + CRLF
		cSQL += "                          AND SB1.b1_filial = SD2.d2_filial " + CRLF
		cSQL += "                          AND SB1.b1_cod = SD2.d2_cod " + CRLF
		cSQL += "        WHERE  sd2.d_e_l_e_t_ = ' ' " + CRLF
		cSQL += "               AND SD2.d2_filial = '" + xFilial("SD2") +"' " + CRLF
		IF _lJob
			cSQL += "               AND SD2.d2_emissao >= '"+ cFiltraDia +"'), " + CRLF
		Else
			cSQL += "               AND SD2.d2_emissao >= '"+ dTos( aRET[1] ) +"' AND SD2.d2_emissao <= '"+ dTos( aRET[2] ) +"' ), " + CRLF
		EndIF
		cSQL += "       "+ RetSqlName("SA1") +" SA1 " + CRLF
		cSQL += "WHERE  SA1.d_e_l_e_t_ = ' ' " + CRLF
		cSQL += "       AND a1_filial = ' ' " + CRLF
		cSQL += "       AND a1_cod = c5_cliente" + CRLF
		cSQL += "ORDER  BY c5_chvbpag " + CRLF
		
		dbUseArea(.T. , "TOPCONN", TcGenQry(,,cSQL),"TRBDIAR",.F.,.T.)
	
		TcSetField("TRBDIAR","VL_FATURAMENTO","N",15,2)
		
		nLinPed  := 1  
		nVlrPed  := 0
		cLinFat  := "" 
		cLinFat1 := ""
		cPedido  := TRBDIAR->PEDGAR  
		cLin 	 := ""
		cLinVlr  := ""
		cLinForm := ""
		cLinNfGe := "" 
		cLinMun  := ""
		cLinEst  := ""
		cLinCert := ""
		cLinHad1 := ""
		DT_FAT_SOFT := ""
		DT_FAT_HARD := ""
		
		TRBDIAR->(DbGotop())
		While !TRBDIAR->(Eof())   
			//Informações de Produto Software/Hardware
			cLinCert := A181PED( TRBDIAR->PEDIDO, 'SW' )
			cLinHad1 := A181PED( TRBDIAR->PEDIDO, 'HD' )
			
			cLinFat  := PADR(DT_FAT_SOFT,10," ")
			cLinFat1 := PADR(DT_FAT_HARD,10," ")   
			
			IF cToD(cLinFat) < cToD(cLinFat1)
				DT_FATURA := DT_FAT_HARD
			Else
				DT_FATURA := DT_FAT_SOFT
			EndIF
			
			cPedido := TRBDIAR->PEDGAR
			nVlrPed += TRBDIAR->VL_FATURAMENTO
			cLin 	 := PADR(TRBDIAR->PEDGAR,38," ") + DT_FATURA
			cLinVlr  := PADR(StrTran(alltrim(Str(nVlrPed)),".",","),16," ")
			cLinForm := PADR(TRBDIAR->DS_FMA_PGTO,72," ")
			cLinNfGe := 'S'//PADR(IIF(!Empty(TRBDIAR->DT_FATURAMENTO),'S','N'),10," ")
			cLinMun  := PADR(TRBDIAR->MUN,35," ")    
			cLinEst  := PADR(TRBDIAR->EST,3," ")
		 	    
			TRBDIAR->(DbSkip())
			IF cPedido <> TRBDIAR->PEDGAR
				
				cLin	  := PadR(cLin,48," ")
				cLinVlr  := PadR(cLinVlr,16," ")
				cLinForm := PadR(cLinForm,72," ")
				cLinNfGe := PadR(cLinNfGe,1," ")
				cLinMun  := PadR(cLinMun,35," ")
				cLinEst  := PadR(cLinEst,3," ")
				cLinCert := PadR(cLinCert,144," ")
				cLinHad1 := PadR(cLinHad1,288," ")
				//cLinHad2 := PadR(cLinHad2,144," ")
				cLinFat  := PadR(cLinFat ,10 ," ")
				cLinFat1 := PadR(cLinFat1,10 ," ")
				
				FWrite(nHandle, cLin+cLinVlr+cLinForm+cLinNfGe+cLinMun+cLinEst+cLinCert+cLinHad1+cLinFat+" "+cLinFat1+CRLF )
		
				nLinPed  := 1
				nVlrPed  := 0
				cLin 	 := ""
				cLinVlr  := ""
				cLinForm := ""
				cLinNfGe := ""
				cLinCert := ""
				cLinHad1 := ""
				cLinHad2 := ""  
				cLinMun  := ""
				cLinEst  := ""
				cLinFat  := ""
				cLinFat1 := ""
			EndIF
		End
		TRBDIAR->( dbCloseArea() )
		
		Sleep(50)
		FClose( nHandle )
		//CpyS2T( cNameFile, "C:\TEMP" )
		ApMsgInfo( 'Processo finalizado', '[GARA181A] - Pedidos TXT > GAR')
	Else
		ApMsgInfo( 'Erro na crição do arquivo', '[GARA181A] - Pedidos TXT > GAR')
	EndIF
	
Return
//+-------------------------------------------------------------------+
//| Rotina | A181PED | Autor | Rafael Beghini | Data | 22.04.2016 
//+-------------------------------------------------------------------+
//| Descr. | Retorna os dados do Pedido item a item 
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
Static Function A181PED( cPedido, cTIPO )
	Local cSQL := ''
	Local cTRB := ''
	Local cRet := ''
	Local nReg := 0
	Local cValor  := ''
	Local cDSProd := ''
	Local cDtFat1 := ''
	Local cDtFat2 := ''
	Local cCateg  := IIF( cTIPO == 'SW', '2', '1' )
	Local nValor  := 0
	
	cSQL += "SELECT c6_produto, " + CRLF
	cSQL += "       Upper(b1_desc) AS DS_PROD, " + CRLF
	cSQL += "       c6_valor, " + CRLF
	cSQL += "       f2_emissao " + CRLF
	cSQL += "FROM   "+ RetSqlName("SC6") +" SC6 " + CRLF
	cSQL += "       INNER JOIN "+ RetSqlName("SB1") +" SB1 " + CRLF
	cSQL += "               ON SB1.d_e_l_e_t_ = ' ' " + CRLF
	cSQL += "                  AND b1_filial = '"+xFilial("SB1")+"' " + CRLF
	cSQL += "                  AND SC6.c6_produto = SB1.b1_cod " + CRLF
	cSQL += "                  AND b1_catego = '" + cCateg + "' " + CRLF
	cSQL += "       LEFT JOIN "+ RetSqlName("SF2") +" SF2 " + CRLF
	cSQL += "              ON sf2.d_e_l_e_t_ = ' ' " + CRLF
	cSQL += "                 AND f2_filial = '"+xFilial("SF2")+"' " + CRLF
	cSQL += "                 AND f2_doc = c6_nota " + CRLF
	cSQL += "                 AND f2_serie = c6_serie " + CRLF
	cSQL += "WHERE  SC6.d_e_l_e_t_ = ' ' " + CRLF
	cSQL += "       AND c6_filial = '" + xFilial("SC6") + "' " + CRLF
	cSQL += "       AND c6_num = '" + cPedido + "' " + CRLF
	cSQL += "       AND C6_XOPER <> '53' " + CRLF
	cSQL += "ORDER  BY c6_item " + CRLF
	
	//cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	//PLSQuery( cSQL, cTRB )
	
	dbUseArea(.T. , "TOPCONN", TcGenQry(,,cSQL),"TRBPED",.F.,.T.)
	
	Count To nReg
	
	TRBPED->( dbGotop() )
	While .NOT. TRBPED->( EOF() )
		cValor  := TRBPED->C6_VALOR
		cDSProd := TRBPED->DS_PROD
		IF cTIPO == 'SW'
			IF nReg > 1 //Para casos SAGE que possuem +1 Software
				nValor += TRBPED->C6_VALOR
				cRET := PADR(StrTran(Alltrim(Str(nValor)),".",","),16," ") + PADR(cDSProd,128," ")
			Else
				cRET := PADR(StrTran(Alltrim(Str(cValor)),".",","),16," ") + PADR(cDSProd,128," ")
			EndIF
			cDtFat1 := TRBPED->F2_EMISSAO
			DT_FAT_SOFT := SUBSTRING(cDtFat1,7,2) + "/" + SUBSTRING(cDtFat1,5,2) + "/" + SUBSTRING(cDtFat1,1,4)
			DT_FATURA := DT_FAT_SOFT
		Else
			IF nReg <= 1
				cRET := PADR(StrTran(Alltrim(Str(cValor)),".",","),16," ") + PADR(cDSProd,128," ") + PADR(StrTran(" ",".",","),144," ")
			Else
				cRET += PADR(StrTran(Alltrim(Str(cValor)),".",","),16," ") + PADR(cDSProd,128," ")
			EndIF
			cDtFat2 := TRBPED->F2_EMISSAO
			DT_FAT_HARD := SUBSTRING(cDtFat2,7,2) + "/" + SUBSTRING(cDtFat2,5,2) + "/" + SUBSTRING(cDtFat2,1,4)
			DT_FATURA := DT_FAT_HARD
		EndIF
		TRBPED->( dbSkip() )	
	End
	TRBPED->( dbCloseArea() )
	
	IF Empty(cDtFat1) .And. cTIPO == 'SW'
		DT_FAT_SOFT := ''
		DT_FATURA   := ''
	ElseIF	Empty(cDtFat2) .And. cTIPO == 'HD'
		DT_FAT_HARD := ''
		DT_FATURA   := ''
	EndIF
Return( cRet )

/*==================================================================
Renato Ruy - Comentrio com as posies que devem ser enviadas para
o arquivo que  lido pela rea de banco de dados
==================================================================*/
  /*
V_CD_PEDIDO           := Da posio 001 l os prximos 038 caracteres
V_DT_FATURAMENTO      := Da posio 039 l os prximos 010 caracteres
V_VL_FATURAMENTO      := Da posio 049 l os prximos 016 caracteres
V_DS_FMA_PGTO         := Da posio 065 l os prximos 072 caracteres
V_IC_NOTA_GERADA      := Da posio 137 l os prximos 001 caracteres
V_DS_MUNICIPIO        := Da posio 138 l os prximos 035 caracteres
V_DS_UF               := Da posio 173 l os prximos 003 caracteres
V_VL_CERTIFICADO      := Da posio 176 l os prximos 016 caracteres
V_DS_CERTIFICADO      := Da posio 192 l os prximos 128 caracteres
V_VL_HARDWARE1        := Da posio 320 l os prximos 016 caracteres
V_DS_HARDWARE1        := Da posio 336 l os prximos 128 caracteres
V_VL_HARDWARE2        := Da posio 464 l os prximos 016 caracteres
V_DS_HARDWARE2        := Da posio 480 l os prximos 128 caracteres
V_TMP_DT_FAT_CERTIFIC := Da posio 608 l os prximos 011 caracteres
V_TMP_DT_FAT_HARDWARE := Da posio 619 l os prximos 010 caracteres
*/