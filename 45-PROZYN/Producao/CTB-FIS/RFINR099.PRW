#Include "Rwmake.ch"
#Include "TBICONN.ch"
#Include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFINR099  บAutor  ณ                    บ Data ณ  16/10/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relat๓rio de Fluxo de caixa analํtico com o realizado e a  บฑฑ
ฑฑบ          ณ realizar                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFINR099()
Private cPerg := "RFINR099"
ValidPerg()
If !Pergunte(cPerg,.T.)
	Return
EndIf
                    
Processa({||Gera(),"Processando..."})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFINR099  บAutor  ณMicrosiga           บ Data ณ  16/10/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gera()


cQry := "SELECT 'A REALIZAR' ORIGEM,E1_VENCTO VENCIMENTO,CONVERT(CHAR(8),DATEADD(d,1,CONVERT(DATE,E1_VENCREA)),112) VENCREAL,E1_PREFIXO+'-'+E1_NUM+CASE WHEN E1_PARCELA='' THEN '' ELSE '-'+E1_PARCELA END DOCUMENTO "
cQry += ",'' BANCO, '' AGENCIA, '' CONTA , E1_NATUREZ NATUREZA,A1_NOME NOME,E1_HIST HISTORICO,0 PAGAR "
cQry += ", E1_SALDO RECEBER,0 ACUMULADO, E1_SALDO RECPAG, E1_TIPO, SE1.R_E_C_N_O_, 'SE1' TABELA "
cQry += "FROM "+retsqlname("SE1")+" SE1 "
cQry += "	LEFT JOIN "+retsqlname("SA1")+"  SA1 ON SA1.D_E_L_E_T_<>'*' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA "
cQry += "	LEFT JOIN "+retsqlname("SED")+"  SED ON SED.D_E_L_E_T_<>'*' AND ED_CODIGO=E1_NATUREZ "
cQry += "WHERE SE1.D_E_L_E_T_<>'*'AND E1_SALDO>0 AND CONVERT(CHAR(8),DATEADD(d,1,CONVERT(DATE,E1_VENCREA)),112) BETWEEN '"+dtos(mv_par01)+"' and '"+dtos(mv_par01+mv_par03)+"' "
cQry += "AND E1_SITUACA<>'2' AND E1_FILIAL BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
cQry += "UNION ALL  "
cQry += "SELECT 'A REALIZAR' ORIGEM,E2_VENCTO VENCIMENTO,CONVERT(CHAR(8),CONVERT(DATE,E2_VENCREA),112) VENCREAL ,E2_PREFIXO+'-'+E2_NUM+CASE WHEN E2_PARCELA='' THEN'' ELSE '-'+E2_PARCELA END "
cQry += ",'' BANCO, '' AGENCIA, '' CONTA ,E2_NATUREZ NATUREZA,A2_NOME ,E2_HIST,E2_SALDO PAGAR, 0, 0, E2_SALDO*-1 RECPAG, E2_TIPO, SE2.R_E_C_N_O_, 'SE2' TABELA "
cQry += "FROM "+retsqlname("SE2")+"  SE2 "
cQry += "	LEFT JOIN "+retsqlname("SA2")+" SA2 ON SA2.D_E_L_E_T_<>'*' AND A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA "
cQry += "	LEFT JOIN "+retsqlname("SED")+"  SED ON SED.D_E_L_E_T_<>'*' AND ED_CODIGO=E2_NATUREZ "
cQry += "WHERE SE2.D_E_L_E_T_<>'*' AND E2_SALDO>0 AND E2_VENCREA between '"+dtos(mv_par01)+"' and '"+dtos(mv_par01+mv_par03)+"' AND E2_FILIAL BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
cQry += " UNION ALL  "
cQry += " SELECT 'REALIZADO' ORIGEM,'19010101' VENCIMENTO,CONVERT(CHAR(8),CONVERT(DATE,E5_DTDISPO),112) VENCREAL ,E5_PREFIXO+'-'+E5_NUMERO+CASE WHEN E5_PARCELA='' THEN'' ELSE '-'+E5_PARCELA END DOCUMENTO "
cQry += ",E5_BANCO BANCO, E5_AGENCIA AGENCIA, E5_CONTA CONTA, E5_NATUREZ NATUREZA " 
cQry += ",CASE WHEN E5_FORNECE<>'' THEN A2_NOME ELSE A1_NOME END NOME,E5_HISTOR "
cQry += ",CASE WHEN E5_RECPAG='P' THEN E5_VALOR ELSE 0 END PAGO "
cQry += ",CASE WHEN E5_RECPAG='R' THEN E5_VALOR ELSE 0 END RECEBIDO " 
cQry += ", 0 ACUMULADO,CASE WHEN E5_RECPAG='P' THEN E5_VALOR*-1 ELSE E5_VALOR END RECPAG, E5_TIPO, SE5.R_E_C_N_O_, 'SE5' TABELA  "
cQry += "FROM "+retsqlname("SE5")+" SE5 "
cQry += "	LEFT JOIN "+retsqlname("SA1")+"  SA1 ON SA1.D_E_L_E_T_<>'*' AND A1_COD=E5_CLIENTE AND A1_LOJA=E5_LOJA "
cQry += "	LEFT JOIN "+retsqlname("SA2")+"  SA2 ON SA2.D_E_L_E_T_<>'*' AND A2_COD=E5_FORNECE AND A2_LOJA=E5_LOJA "
cQry += "	LEFT JOIN "+retsqlname("SED")+"  SED ON SED.D_E_L_E_T_<>'*' AND ED_CODIGO=E5_NATUREZ "
cQry += "WHERE SE5.D_E_L_E_T_<>'*' AND E5_DTDISPO between  '"+dtos(mv_par01-mv_par02)+"' AND '"+dtos(mv_par01)+"' " 
cQry += "AND (SELECT COUNT(*) 
cQry +=  "FROM "+retsqlname("SE5")+" S " 
cQry +=  "WHERE S.E5_FILIAL=SE5.E5_FILIAL AND S.E5_PREFIXO=SE5.E5_PREFIXO " 
cQry +=  " AND S.E5_NUMERO=SE5.E5_NUMERO AND S.E5_PARCELA=SE5.E5_PARCELA AND S.E5_TIPO=SE5.E5_TIPO " 
cQry +=  " AND S.E5_CLIFOR=SE5.E5_CLIFOR AND S.E5_LOJA=SE5.E5_LOJA "
cQry +=  " AND S.E5_SEQ=SE5.E5_SEQ AND S.E5_TIPODOC='ES' "
cQry +=  " AND S.D_E_L_E_T_<>'*')=0 AND E5_RECONC='x' AND E5_BANCO<>'' AND E5_FILIAL BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
cQry += "ORDER BY VENCREAL "
MEMOWRITE('RFINR001_QRY1.TXT',CQRY)
TcQuery cQry New Alias "QRY1"


cQry := "SELECT CONVERT(CHAR(8),CONVERT(DATE,E1_EMISSAO),112) EMISSAO,CONVERT(CHAR(8),DATEADD(d,1,CONVERT(DATE,E1_VENCREA)),112) VENCTO,E1_PREFIXO+'-'+E1_NUM+CASE WHEN E1_PARCELA='' THEN '' ELSE '-'+E1_PARCELA END DOCUMENTO,A1_NOME NOME,A1_CGC CNPJ,E1_SITUACA CARTEIRA,E1_HIST HISTORICO"
cQry += ",E1_SALDO 'SLD_ATUAL',E1_SALDO+E1_SALDO*0.02+E1_SALDO*DATEDIFF(d,convert(DATE,E1_VENCREA),CONVERT(DATE,'"+DTOS(MV_PAR01-1)+"'))*0.006 'SLD_CORR',DATEDIFF(d,convert(DATE,E1_VENCREA),CONVERT(DATE,'"+DTOS(MV_PAR01-1)+"')) DIAS_ATRASO "
cQry += "FROM "+retsqlname("SE1")+" SE1 "
cQry += "	LEFT JOIN "+retsqlname("SA1")+"  SA1 ON SA1.D_E_L_E_T_<>'*' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA "
cQry += "WHERE SE1.D_E_L_E_T_<>'*'AND E1_SALDO>0 AND CONVERT(CHAR(8),DATEADD(d,1,CONVERT(DATE,E1_VENCREA)),112) BETWEEN '' and '"+dtos(mv_par01-1)+"' "
cQry += "AND E1_SITUACA<>'2' "
cQry += "ORDER BY VENCTO "
MEMOWRITE('RFINR001_QRY2.TXT',CQRY)
TcQuery cQry New Alias "QRY2"

cQry := "SELECT CONVERT(CHAR(8),CONVERT(DATE,E1_EMISSAO),112) EMISSAO,CONVERT(CHAR(8),CONVERT(DATE,E1_VENCREA),112) VENCTO,E1_PREFIXO+'-'+E1_NUM+CASE WHEN E1_PARCELA='' THEN '' ELSE '-'+E1_PARCELA END DOCUMENTO,A1_NOME NOME,A1_CGC CNPJ,E1_SITUACA CARTEIRA,E1_HIST HISTORICO"
cQry += ", E1_SALDO SALDO "
cQry += "FROM "+retsqlname("SE1")+" SE1 "
cQry += "	LEFT JOIN "+retsqlname("SA1")+"  SA1 ON SA1.D_E_L_E_T_<>'*' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA "
cQry += "WHERE SE1.D_E_L_E_T_<>'*'AND E1_SALDO>0 AND CONVERT(CHAR(8),DATEADD(d,1,CONVERT(DATE,E1_VENCREA)),112) BETWEEN '"+dtos(mv_par01+mv_par03+1)+"' and '20491231' "
cQry += "AND E1_SITUACA<>'2' "
cQry += "ORDER BY VENCTO "
MEMOWRITE('RFINR001_QRY3.TXT',CQRY)
TcQuery cQry New Alias "QRY3"

cQry := "SELECT CONVERT(CHAR(8),CONVERT(DATE,E2_EMISSAO),112) EMISSAO,CONVERT(CHAR(8),DATEADD(d,1,CONVERT(DATE,E2_VENCREA)),112) VENCTO,E2_PREFIXO+'-'+E2_NUM+CASE WHEN E2_PARCELA='' THEN '' ELSE '-'+E2_PARCELA END DOCUMENTO,A2_NOME NOME,E2_HIST HISTORICO "
cQry += ",E2_SALDO SALDO "
cQry += "FROM "+retsqlname("SE2")+" SE2 "
cQry += "	LEFT JOIN "+retsqlname("SA2")+"  SA2 ON SA2.D_E_L_E_T_<>'*' AND A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA "
cQry += "	LEFT JOIN "+retsqlname("SED")+"  SED ON SED.D_E_L_E_T_<>'*' AND ED_CODIGO=E2_NATUREZ "
cQry += "WHERE SE2.D_E_L_E_T_<>'*'AND E2_SALDO>0 AND CONVERT(CHAR(8),DATEADD(d,1,CONVERT(DATE,E2_VENCREA)),112) BETWEEN '' and '"+dtos(mv_par01-1)+"' "
cQry += "ORDER BY VENCTO "
MEMOWRITE('RFINR001_QRY4.TXT',CQRY)
TcQuery cQry New Alias "QRY4"

cQry := "SELECT 'REALIZADO' ORIGEM,'19010101' VENCIMENTO,CONVERT(CHAR(10),CONVERT(DATE,E5_DTDISPO),103) VENCREAL , E5_PREFIXO+'-'+E5_NUMERO+CASE WHEN E5_PARCELA='' THEN'' ELSE '-'+E5_PARCELA END DOCUMENTO "
cQry += ",E5_BANCO BANCO, E5_AGENCIA AGENCIA, E5_CONTA CONTA, E5_NATUREZ,CASE WHEN E5_FORNECE<>'' THEN A2_NOME ELSE A1_NOME END NOME,E5_HISTOR,0 PAGO, 0 RECEBIDO, 0 ACUMULADO "
cQry += ",CASE WHEN E5_TIPO IN ('RA','PA') THEN E5_VALOR ELSE E5_VALOR*-1 END RECPAG, E5_TIPO, SE5.R_E_C_N_O_, 'SE5' TABELA FROM "+retsqlname("SE5")+" SE5 "
cQry += "LEFT JOIN "+retsqlname("SA2")+" SA2 ON A2_COD=E5_FORNECE AND A2_LOJA=E5_LOJA "
cQry += "LEFT JOIN "+retsqlname("SA1")+" SA1 ON A1_COD=E5_FORNECE AND A1_LOJA=E5_LOJA "
cQry += "WHERE SE5.D_E_L_E_T_<>'*' AND E5_DTDISPO BETWEEN '"+dtos(mv_par01-mv_par02)+"' AND '"+dtos(mv_par01)+"' AND E5_MOTBX='CMP' "
MEMOWRITE('RFINR001_QRY5.TXT',CQRY)
TcQuery cQry New Alias "QRY5"


_nSaldoAnt := 0

DbSelectArea("SA6")
DbSetOrder(1)
DbGotop()
While !SA6->(Eof())
	If SA6->A6_FLUXCAI == "S"
		cQry := "SELECT TOP 1 E8_SALRECO "
		cQry += "FROM "+retsqlname("SE8")+" SE8 "
		cQry += "WHERE SE8.D_E_L_E_T_<>'*' AND E8_BANCO='"+SA6->A6_COD+"' AND E8_AGENCIA='"+SA6->A6_AGENCIA+"' AND E8_CONTA='"+SA6->A6_NUMCON+"' "
		cQry += "AND E8_DTSALAT<='"+DTOS(MV_PAR01-MV_PAR02-1)+"' "
		cQry += "ORDER BY E8_DTSALAT DESC "
		MEMOWRITE('RFINR099_saldo.TXT',CQRY)
		TcQuery cQry New Alias "SE8X"
		DbSelectArea("SE8X")
		DbGotop()
		If !SE8X->(Eof())
			_nSaldoAnt += SE8X->E8_SALRECO
		EndIf
		SE8X->(DbCloseArea())
	EndIf
	SA6->(DbSkip())
EndDo


DbSelectArea("QRY1")
DbGotop()
ProcRegua(QRY1->(RecCount()))
If !QRY1->(Eof())
	_aStru := QRY1->(DbStruct())
	oExcel    := FWMSEXCEL():New()
	oExcel:AddworkSheet("FLUXO DE CAIXA")
	oExcel:AddTable ("FLUXO DE CAIXA","FLUXO DE CAIXA")
	For _x := 1 to Len(_aStru)
		If _aStru[_x,2] == "N"
			oExcel:AddColumn("FLUXO DE CAIXA","FLUXO DE CAIXA",_aStru[_x,1],3,2)//numeros
		ElseIf _aStru[_x,2] == "C"
			If Alltrim(_aStru[_x,1]) == "DATA"
				oExcel:AddColumn("FLUXO DE CAIXA","FLUXO DE CAIXA",_aStru[_x,1],1,4) //data
			Else
				oExcel:AddColumn("FLUXO DE CAIXA","FLUXO DE CAIXA",_aStru[_x,1],1,1)//texto
			EndIf
		EndIf
	Next
	_aLinha := Array(Len(_aStru))
	For _x := 1 To Len(_aStru)
		_cCpo := Alltrim(_aStru[_x,1])
		If _cCpo $ "DATA/VENCIMENTO/VENCREAL"
			_aLinha[_x] := MV_PAR01-MV_PAR02-1
		ElseIf _cCpo == "ACUMULADO"
			_aLinha[_x] := _nSaldoAnt
		ElseIf _cCpo == "ORIGEM"
			_aLinha[_x] := 'SALDO ANTERIOR'
		Else
			_aLinha[_x] := ""
		EndIf
	Next
	oExcel:AddRow("FLUXO DE CAIXA","FLUXO DE CAIXA",_aLinha)


	While !QRY1->(Eof())
		IncProc("Gerando Excel....")
		_aLinha := Array(Len(_aStru))
		For _x := 1 To Len(_aStru)
			_cCpo := Alltrim(_aStru[_x,1])
			If _cCpo $ "DATA/VENCIMENTO/VENCREAL"
				_aLinha[_x] := STOD(QRY1->&(_cCpo))
			ElseIf _cCpo == "ACUMULADO"
				_nSaldoAnt += QRY1->(RECEBER-PAGAR)
				_aLinha[_x] := _nSaldoAnt
			Else
				_aLinha[_x] := QRY1->&(_cCpo)
			EndIf
		Next
		
		oExcel:AddRow("FLUXO DE CAIXA","FLUXO DE CAIXA",_aLinha)
		QRY1->(DbSkip())
	EndDo
	//QRY2 - INICIO
	_aStru := QRY2->(DbStruct())
	
	oExcel:AddworkSheet("CR VENCIDOS")
	oExcel:AddTable ("CR VENCIDOS","CR VENCIDOS")
	For _x := 1 to Len(_aStru)
		If _aStru[_x,2] == "N"
			oExcel:AddColumn("CR VENCIDOS","CR VENCIDOS",_aStru[_x,1],3,2)//numeros
		ElseIf _aStru[_x,2] == "C"
			If Alltrim(_aStru[_x,1]) $ "EMISSAO/VENCTO"
				oExcel:AddColumn("CR VENCIDOS","CR VENCIDOS",_aStru[_x,1],1,4) //data
			Else
				oExcel:AddColumn("CR VENCIDOS","CR VENCIDOS",_aStru[_x,1],1,1)//texto
			EndIf
		EndIf
	Next

	While !QRY2->(Eof())
		IncProc("Gerando Excel....")
		_aLinha := Array(Len(_aStru))
		For _x := 1 To Len(_aStru)
			_cCpo := Alltrim(_aStru[_x,1])
			If _cCpo $ "EMISSAO/VENCTO"
				_aLinha[_x] := STOD(QRY2->&(_cCpo))
			Else
				_aLinha[_x] := QRY2->&(_cCpo)
			EndIf
		Next
		
		oExcel:AddRow("CR VENCIDOS","CR VENCIDOS",_aLinha)
		QRY2->(DbSkip())
	EndDo
	//QRY2 - FIM

	//QRY3 - INICIO
	_aStru := QRY3->(DbStruct())
	
	oExcel:AddworkSheet("A VENCER APOS")
	oExcel:AddTable ("A VENCER APOS","A VENCER APOS")
	For _x := 1 to Len(_aStru)
		If _aStru[_x,2] == "N"
			oExcel:AddColumn("A VENCER APOS","A VENCER APOS",_aStru[_x,1],3,2)//numeros
		ElseIf _aStru[_x,2] == "C"
			If Alltrim(_aStru[_x,1]) $ "EMISSAO/VENCTO"
				oExcel:AddColumn("A VENCER APOS","A VENCER APOS",_aStru[_x,1],1,4) //data
			Else
				oExcel:AddColumn("A VENCER APOS","A VENCER APOS",_aStru[_x,1],1,1)//texto
			EndIf
		EndIf
	Next

	While !QRY3->(Eof())
		IncProc("Gerando Excel....")
		_aLinha := Array(Len(_aStru))
		For _x := 1 To Len(_aStru)
			_cCpo := Alltrim(_aStru[_x,1])
			If _cCpo $ "EMISSAO/VENCTO"
				_aLinha[_x] := STOD(QRY3->&(_cCpo))
			ElseIf _cCpo == "ACUMULADO"
				_nSaldoAnt += QRY3->SALDO
				_aLinha[_x] := _nSaldoAnt
			Else
				_aLinha[_x] := QRY3->&(_cCpo)
			EndIf
		Next
		
		oExcel:AddRow("A VENCER APOS","A VENCER APOS",_aLinha)
		QRY3->(DbSkip())
	EndDo
	//QRY3 - FIM	

	//QRY4 - INICIO
	_aStru := QRY4->(DbStruct())
	
	oExcel:AddworkSheet("CP VENCIDOS")
	oExcel:AddTable ("CP VENCIDOS","CP VENCIDOS")
	For _x := 1 to Len(_aStru)
		If _aStru[_x,2] == "N"
			oExcel:AddColumn("CP VENCIDOS","CP VENCIDOS",_aStru[_x,1],3,2)//numeros
		ElseIf _aStru[_x,2] == "C"
			If Alltrim(_aStru[_x,1]) $ "EMISSAO/VENCTO"
				oExcel:AddColumn("CP VENCIDOS","CP VENCIDOS",_aStru[_x,1],1,4) //data
			Else
				oExcel:AddColumn("CP VENCIDOS","CP VENCIDOS",_aStru[_x,1],1,1)//texto
			EndIf
		Else
			oExcel:AddColumn("CP VENCIDOS","CP VENCIDOS",_aStru[_x,1],1,1)//texto
		EndIf
	Next

	While !QRY4->(Eof())
		IncProc("Gerando Excel....")
		_aLinha := Array(Len(_aStru))
		For _x := 1 To Len(_aStru)
			_cCpo := Alltrim(_aStru[_x,1])
			If _cCpo $ "EMISSAO/VENCTO"
				_aLinha[_x] := STOD(QRY4->&(_cCpo))
			Else
				_aLinha[_x] := QRY4->&(_cCpo)
			EndIf
		Next
		
		oExcel:AddRow("CP VENCIDOS","CP VENCIDOS",_aLinha)
		QRY4->(DbSkip())
	EndDo
	//QRY4 - FIM

	//QRY5 - INICIO
	_aStru := QRY5->(DbStruct())
	oExcel:AddworkSheet("COMPENSADOS")
	oExcel:AddTable ("COMPENSADOS","COMPENSADOS")
	For _x := 1 to Len(_aStru)
		If _aStru[_x,2] == "N"
			oExcel:AddColumn("COMPENSADOS","COMPENSADOS",_aStru[_x,1],3,2)
		ElseIf _aStru[_x,2] == "C"
			If "/" $ _aStru[_x,1]
				oExcel:AddColumn("COMPENSADOS","COMPENSADOS",_aStru[_x,1],1,4)
			Else
				oExcel:AddColumn("COMPENSADOS","COMPENSADOS",_aStru[_x,1],1,1)
			EndIf
		EndIf
	Next
	
	While !QRY5->(Eof())
		IncProc("Gerando Excel....")
		_aLinha := Array(Len(_aStru))
		For _x := 1 To Len(_aStru)
			_cCpo := Alltrim(_aStru[_x,1])
			_aLinha[_x] := QRY5->&(_cCpo)
		Next
		
		oExcel:AddRow("COMPENSADOS","COMPENSADOS",_aLinha)
		QRY5->(DbSkip())
	EndDo

/*	
	oExcel:AddworkSheet("CR DESCONTADOS")
	oExcel:AddTable ("CR DESCONTADOS","CR DESCONTADOS")
	For _x := 1 to Len(_aStru)
		If _aStru[_x,2] == "N"
			oExcel:AddColumn("CR DESCONTADOS","CR DESCONTADOS",_aStru[_x,1],3,2)//numeros
		ElseIf _aStru[_x,2] == "C"
			If Alltrim(_aStru[_x,1]) $ "EMISSAO/VENCTO"
				oExcel:AddColumn("CR DESCONTADOS","CR DESCONTADOS",_aStru[_x,1],1,4) //data
			Else
				oExcel:AddColumn("CR DESCONTADOS","CR DESCONTADOS",_aStru[_x,1],1,1)//texto
			EndIf
		EndIf
	Next

	While !QRY5->(Eof())
		IncProc("Gerando Excel....")
		_aLinha := Array(Len(_aStru))
		For _x := 1 To Len(_aStru)
			_cCpo := Alltrim(_aStru[_x,1])
			If _cCpo $ "EMISSAO/VENCTO"
				_aLinha[_x] := STOD(QRY5->&(_cCpo))
			Else
				_aLinha[_x] := QRY5->&(_cCpo)
			EndIf
		Next
		
		oExcel:AddRow("CR DESCONTADOS","CR DESCONTADOS",_aLinha)
		QRY5->(DbSkip())
	EndDo
	//QRY5 - FIM
*/
	oExcel:Activate()
	_cFile := (CriaTrab(NIL, .F.) + ".xml")
	While File(_cFile)
		_cFile := (CriaTrab(NIL, .F.) + ".xml")
	EndDo
	oExcel:GetXMLFile(_cFile)
	oExcel:DeActivate()
	If !(File(_cFile))
		_cFile := ""
		QRY1->(DbCloseArea())
		Break
	EndIf
	_cFileTMP := (GetTempPath() + _cFile)
	If !(__CopyFile(_cFile , _cFileTMP))
		fErase( _cFile )
		_cFile := ""
		QRY1->(DbCloseArea())
		Break
	EndIf
	__CopyFile(_cFile , _cFileTMP)
	fErase(_cFile)
	_cFile := _cFileTMP
	If !(File(_cFile))
		_cFile := ""
		QRY1->(DbCloseArea())
		Break
	EndIf
	oMsExcel := MsExcel():New()
	oMsExcel:WorkBooks:Open(_cFile)
	oMsExcel:SetVisible(.T.)
	oMsExcel := oMsExcel:Destroy()
	
	FreeObj(oExcel)
	oExcel := NIL
	
EndIf
QRY1->(DbCloseArea())
QRY2->(DbCloseArea())
QRY3->(DbCloseArea())
QRY4->(DbCloseArea())

Return

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR001  บAutor  ณMicrosiga           บ Data ณ  06/13/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()
 
_sAlias := GetArea()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg   := PADR(cPerg,10)
aRegs   := {}

aAdd(aRegs,{cPerg,"01","Data Base              ?","","","mv_ch1","D",08,0,0,"G","naovazio()","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Dias atras             ?","","","mv_ch2","N",03,0,0,"G","naovazio()","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Dias a frente:         ?","","","mv_ch3","N",03,0,0,"G","naovazio()","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","De Filial:             ?","","","mv_ch4","C",02,0,0,"G","naovazio()","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"05","At้ Filial:            ?","","","mv_ch5","C",02,0,0,"G","naovazio()","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
 
RestArea(_sAlias)
 
Return