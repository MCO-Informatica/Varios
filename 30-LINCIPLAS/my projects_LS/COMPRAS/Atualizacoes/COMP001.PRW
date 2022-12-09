#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#INCLUDE "FONT.CH"
#INCLUDE "TCBROWSE.CH"

/*
+===============================================================+
|Programa: COMP001 |Autor: Antonio Carlos |Data:14/09/2008      |
+===============================================================+
|Descricao: Rotina utilizada para efetuar consulta de produto.  |
+===============================================================+
|Uso: Especifico Laselva (CONSULTA LASELVA)                     |
+===============================================================+
*/

User Function COMP001(cProduto)


Private cProd 		:= cProduto
Private _cPlata		:= ""
Private lInvFil		:= .F.

_cFiliais := '' 
_cFiltro  := "B1_COD = '" + cProduto + "'"
_cGrupo   := ""
_cFilOri  := ''

U_TRANS177(_cGrupo,SB1->B1_COD) // calculo do transito do produto para todas as filiais que tem registro no SB2

VReparte()


Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConProd   บAutor  ณAntonio Carlos      บ Data ณ14/09/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConProd(_lPlat,_cPlata,lInvFil,_nOpc)


Local nI
Local nUsado	:= 0
Local nLinha	:= 0
Local nDescon	:= 0
Local _nSldEst  := 0
Local _nEstSup	:= 0
Local _nEstMin  := 0
Local _nEstMax  := 0
Local _nSldPed	:= 0
Local _nSldRes	:= 0 //Incluido por Sidney
Local _nSldx	:= 0 //Incluido por Sidney
Local _nEstSa   := 0
Local _nMes01	:= 0
Local _nMes02	:= 0
Local _nMes03	:= 0
Local _nMes04	:= 0
Local _nMes05	:= 0
Local _nMes06	:= 0
Local _nQtde	:= 0
Local _nVendMes	:= 0
Local _nTotVend	:= 0
Local nCol		:= 0
Local _cDataIni := StrZero(Year(dDataBase)-1,4) + StrZero(Month(dDataBase),2)+STRZERO(Day(dDataBase),2)
Local _aTitulo	:= {}
Local _aVendas	:= {}
Local _aMes		:= {"Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
Local aCpoGDa	:= {"BZ_FILIAL","BZ_PERFIL","BZ_EMAX","BZ_EMIN","B2_QATU","B2_XTRANSI","B2_XRESERV","B2_RESERVA","BZ_PRV1","BZ_UPRC"} //trocado pela Tatiane de Oliveira 04/02/2016

aHeader	:= {}
aCols	:= {}

Aadd(_aVendas,{"","","","","","","",""})

DbSelectArea("SB1")
SB1->( DbSetOrder(1) )
SB1->( DbSeek(xFilial("SB1")+cProd ) )

cQry := " SELECT CONVERT(VARCHAR(8),GETDATE(),112)AS MES1, "
cQry += " SUBSTRING(CONVERT(VARCHAR(8),dateadd(mm,-1,getdate()),112),1,8) AS MES2, "
cQry += " SUBSTRING(CONVERT(VARCHAR(8),dateadd(mm,-2,getdate()),112),1,8) AS MES3, "
cQry += " SUBSTRING(CONVERT(VARCHAR(8),dateadd(mm,-3,getdate()),112),1,8) AS MES4, "
cQry += " SUBSTRING(CONVERT(VARCHAR(8),dateadd(mm,-4,getdate()),112),1,8) AS MES5, "
cQry += " SUBSTRING(CONVERT(VARCHAR(8),dateadd(mm,-5,getdate()),112),1,8) AS MES6  "

IF SELECT("QRY") > 0
	QRY->(dbSelectArea("QRY"))
	QRY->(dbCloseArea())
ENDIF

TcQuery cQry NEW ALIAS "QRY"

DbSelectArea("QRY")
QRY->( DbGoTop() )
If QRY->( !Eof() )
	While !QRY->( Eof() )
		
		Aadd(_aTitulo,{QRY->MES1,QRY->MES2,QRY->MES3,QRY->MES4,QRY->MES5,QRY->MES6})
		
		QRY->( DbSkip() )
		
	EndDo
EndIf
DbCloseArea()

_cMes1 := _aMes[Val(Substr(_aTitulo[1,1],5,2))]+"-"+Substr(_aTitulo[1,1],3,2)
_cMes2 := _aMes[Val(Substr(_aTitulo[1,2],5,2))]+"-"+Substr(_aTitulo[1,2],3,2)
_cMes3 := _aMes[Val(Substr(_aTitulo[1,3],5,2))]+"-"+Substr(_aTitulo[1,3],3,2)
_cMes4 := _aMes[Val(Substr(_aTitulo[1,4],5,2))]+"-"+Substr(_aTitulo[1,4],3,2)
_cMes5 := _aMes[Val(Substr(_aTitulo[1,5],5,2))]+"-"+Substr(_aTitulo[1,5],3,2)
_cMes6 := _aMes[Val(Substr(_aTitulo[1,6],5,2))]+"-"+Substr(_aTitulo[1,6],3,2)

If Select("QRYVEN") > 0
	DbSelectArea("QRYVEN")
	DbCloseArea()
EndIf

If SB1->B1_GRUPO $ "0004/0006" .AND. !empty(SB1->B1_EDICAO)
	cQryVen := " SELECT D2_FILIAL, sum(QTDE) as QTDE, MES FROM REPARTES_SBZ "
	If _nOpc == 1
		If !Empty(_cPlata) .And. !lInvFil
			cQryVen	+= " INNER JOIN SIGA.dbo.sigamat_copia ON M0_CODFIL = D2_FILIAL AND CodSetor IN ("+_cPlata+") AND codestabelecimento NOT IN (13,89) AND M0_CODFIL <> '' AND ativo_pdv = 1 "
		EndIf
	EndIf
	cQryVen	+= " WHERE "
	cQryVen	+= " COD_REV = '"+Substr(alltrim(cProd),1,len(alltrim(cProd))-4)+"' "
	If _nOpc == 2 .and. !empty(_cPlata)
		cQryVen	+= " AND D2_FILIAL IN (" + _cPlata + ") "
	EndIf
	cQryVen	+= " GROUP BY D2_FILIAL, MES "
	cQryVen	+= " ORDER BY D2_FILIAL, MES DESC "
Else
	cQryVen := " SELECT D2_FILIAL, sum(QTDE) as QTDE, MES FROM REPARTES_SBZ "
	If _nOpc == 1
		If !Empty(_cPlata) .And. !lInvFil
			cQryVen	+= " INNER JOIN SIGA.dbo.sigamat_copia ON M0_CODFIL = D2_FILIAL AND CodSetor IN ("+_cPlata+") AND codestabelecimento NOT IN (13,89) AND M0_CODFIL <> '' AND ativo = 1 "
		EndIf
	EndIf
	cQryVen	+= " WHERE "
	cQryVen	+= " D2_COD = '"+cProd+"' "
	If _nOpc == 2
		If !Empty(_cPlata) .And. !lInvFil
			cQryVen	+= " AND D2_FILIAL IN ("+_cPlata+") "
		EndIf
	EndIf
	cQryVen	+= " GROUP BY D2_FILIAL, MES "
	cQryVen	+= " ORDER BY D2_FILIAL, MES DESC "
EndIf

TcQuery cQryVen NEW ALIAS "QRYVEN"

DbSelectArea("QRYVEN")
QRYVEN->( DbGoTop() )
If QRYVEN->( !Eof() )
	While QRYVEN->( !Eof() )
		
		If Empty(_aVendas[1,8])
			
			_aVendas[1,1] := QRYVEN->D2_FILIAL+"-"+Posicione("SM0",1,Substr(cNumEmp,1,2)+QRYVEN->D2_FILIAL,"M0_FILIAL")
			_aVendas[1,8] := QRYVEN->D2_FILIAL
			
			If Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,1],5,2)
				nCol := 2
				_nMes01 += QRYVEN->QTDE
			ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,2],5,2)
				nCol := 3
				_nMes02 += QRYVEN->QTDE
			ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,3],5,2)
				nCol := 4
				_nMes03 += QRYVEN->QTDE
			ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,4],5,2)
				nCol := 5
				_nMes04 += QRYVEN->QTDE
			ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,5],5,2)
				nCol := 6
				_nMes05 += QRYVEN->QTDE
			ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,6],5,2)
				nCol := 7
				_nMes06 += QRYVEN->QTDE
			EndIf
			
			_aVendas[1,nCol] := str(QRYVEN->QTDE)
			
			_nQtde := 0
			
		Else
			
			nPos := aScan(_aVendas,{|x| x[8] == QRYVEN->D2_FILIAL })
			
			If nPos > 0
				
				If Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,1],5,2)
					nCol := 2
					_nMes01 += QRYVEN->QTDE
				ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,2],5,2)
					nCol := 3
					_nMes02 += QRYVEN->QTDE
				ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,3],5,2)
					nCol := 4
					_nMes03 += QRYVEN->QTDE
				ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,4],5,2)
					nCol := 5
					_nMes04 += QRYVEN->QTDE
				ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,5],5,2)
					nCol := 6
					_nMes05 += QRYVEN->QTDE
				ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,6],5,2)
					nCol := 7
					_nMes06 += QRYVEN->QTDE
				EndIf
				
				_nQtde := Val(_aVendas[nPos,nCol])+QRYVEN->QTDE
				
				_aVendas[nPos,nCol] := str(_nQtde)
				
			Else
				
				Aadd(_aVendas,{"","","","","","","",""})
				_aVendas[Len(_aVendas),1] := QRYVEN->D2_FILIAL+"-"+Posicione("SM0",1,Substr(cNumEmp,1,2)+QRYVEN->D2_FILIAL,"M0_FILIAL")
				_aVendas[Len(_aVendas),8] := QRYVEN->D2_FILIAL
				
				If Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,1],5,2)
					nCol := 2
					_nMes01 += QRYVEN->QTDE
				ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,2],5,2)
					nCol := 3
					_nMes02 += QRYVEN->QTDE
				ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,3],5,2)
					nCol := 4
					_nMes03 += QRYVEN->QTDE
				ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,4],5,2)
					nCol := 5
					_nMes04 += QRYVEN->QTDE
				ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,5],5,2)
					nCol := 6
					_nMes05 += QRYVEN->QTDE
				ElseIf Substr(QRYVEN->MES,1,2) == Substr(_aTitulo[1,6],5,2)
					nCol := 7
					_nMes06 += QRYVEN->QTDE
				EndIf
				
				_aVendas[Len(_aVendas),nCol] := str(QRYVEN->QTDE)
				
			EndIf
			
		EndIf
		
		QRYVEN->( DbSkip() )
		
	EndDo
	
	Aadd(_aVendas,{"","","","","","","",""})
	_aVendas[Len(_aVendas),1] := "Total:"
	
	_aVendas[Len(_aVendas),3] := Transform(_nMes01,PesqPict("SD2","D2_QUANT"))
	_aVendas[Len(_aVendas),4] := Transform(_nMes02,PesqPict("SD2","D2_QUANT"))
	_aVendas[Len(_aVendas),5] := Transform(_nMes03,PesqPict("SD2","D2_QUANT"))
	_aVendas[Len(_aVendas),6] := Transform(_nMes04,PesqPict("SD2","D2_QUANT"))
	_aVendas[Len(_aVendas),7] := Transform(_nMes05,PesqPict("SD2","D2_QUANT"))
	_aVendas[Len(_aVendas),8] := Transform(_nMes06,PesqPict("SD2","D2_QUANT"))
	
EndIf

dbSelectArea( "SX3" )
SX3->( dbSetOrder( 2 ) ) // Campo

For nI := 1 to Len( aCpoGDa )
	If SX3->( dbSeek( aCpoGDa[nI] ) )
		aAdd( aHeader, { 	IIf(Alltrim(X3_CAMPO)=="BZ_PRV1","Preco PDV",IIf(Alltrim(X3_CAMPO)=="BZ_PRV2","Promocao",IIf(Alltrim(X3_CAMPO)=="B2_XTRANSI","Transito" ,	AlLTrim( X3Titulo() ))))	,;
		SX3->X3_CAMPO		,;
		IIf(Alltrim(X3_CAMPO)$"B2_QATU/B2_XTRANSI/BZ_EMAX/BZ_EMIN",'@E 99999999',IIf(Alltrim(X3_CAMPO)$"BZ_PRV1/BZ_UPRC","999,999.99",SX3->X3_Picture)) ,;
		SX3->X3_TAMANHO		,;
		IIf(Alltrim(X3_CAMPO)$"B2_XTRANSI/B2_RESERVA/B2_XRESERV",0,SX3->X3_DECIMAL)	,;
		SX3->X3_Valid		,;
		SX3->X3_USADO		,;
		SX3->X3_TIPO		,;
		SX3->X3_F3 			,;
		SX3->X3_CONTEXT		,;
		SX3->X3_CBOX		,;
		SX3->X3_RELACAO } )
	EndIf
Next nI

aAdd( aHeader, { 'Margem'	, 'MARGEM'	, '@E 999.99'	, 6, 2,,, 'N',,  ,  ,  , , ,  } )
aAdd( aHeader, { _cMes1		, 'MES01'	, '@E 9,999,999', 8, 0,,, 'N',,  ,  ,  , , ,  } )
aAdd( aHeader, { _cMes2		, 'MES02'	, '@E 9,999,999', 8, 0,,, 'N',,  ,  ,  , , ,  } )
aAdd( aHeader, { _cMes3		, 'MES03'	, '@E 9,999,999', 8, 0,,, 'N',,  ,  ,  , , ,  } )
aAdd( aHeader, { _cMes4		, 'MES04'	, '@E 9,999,999', 8, 0,,, 'N',,  ,  ,  , , ,  } )
aAdd( aHeader, { _cMes5		, 'MES05'	, '@E 9,999,999', 8, 0,,, 'N',,  ,  ,  , , ,  } )
aAdd( aHeader, { _cMes6		, 'MES06'	, '@E 9,999,999', 8, 0,,, 'N',,  ,  ,  , , ,  } )

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQryRpt	:= " SELECT BZ_FILIAL, BZ_COD, BZ_PERFIL, BZ_EMIN, BZ_EMAX, COALESCE(B2_QATU,0) AS B2_QATU, COALESCE(BZ_PRV1,0) AS BZ_PRV1, "
cQryRpt	+= " COALESCE(B2_XTRANSI,0) AS B2_XTRANSI, "
cQryRpt	+= " COALESCE(B2_RESERVA,0) AS B2_RESERVA, "
cQryRpt	+= " COALESCE(B2_XRESERV,0) AS B2_XRESERV, "
cQryRpt	+= " CASE WHEN BZ_UPRC <> 0 THEN BZ_UPRC ELSE "
cQryRpt	+= " CASE WHEN B1_UPRC <> 0 THEN B1_UPRC ELSE 0 END END AS BZ_UPRC, B1_UPRC "
cQryRpt	+= " FROM "+RetSqlName("SBZ")+" SBZ WITH(NOLOCK) "
cQryRpt	+= " LEFT JOIN "+RetSqlName("SB2")+" SB2 WITH(NOLOCK) "
cQryRpt	+= " 									ON SB2.B2_LOCAL ='01' AND BZ_FILIAL = B2_FILIAL AND BZ_COD = B2_COD AND SB2.D_E_L_E_T_ = '' "
cQryRpt	+= " LEFT JOIN "+RetSqlName("SB1")+" SB1 WITH(NOLOCK) "
cQryRpt	+= " 									ON BZ_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
cQryRpt	+= " INNER JOIN SIGA.dbo.sigamat_copia ON M0_CODFIL = BZ_FILIAL AND M0_CODFIL <> '' AND ativo = 1 "
cQryRpt	+= " WHERE "
If _nOpc == 2
	If !Empty(_cPlata) .And. !lInvFil
		cQryRpt	+= " BZ_FILIAL IN ("+_cPlata+") AND "
	EndIf
EndIf
cQryRpt	+= " BZ_COD 		= '"+cProd+"' 	AND "
cQryRpt	+= " BZ_LOCPAD 		='01' 			AND "
cQryRpt	+= " SBZ.D_E_L_E_T_ = '' "
cQryRpt	+= " GROUP BY BZ_FILIAL, BZ_COD, BZ_PERFIL, BZ_EMIN, BZ_EMAX, B2_QATU, B2_XTRANSI, B2_RESERVA,B2_XRESERV, B1_PRV1, BZ_UPRC, B1_UPRC, BZ_PRV1, BZ_DATA1, B1_UPRC "
cQryRpt	+= " ORDER BY BZ_FILIAL "

TcQuery cQryRpt NEW ALIAS "TMP"

DbSelectArea("TMP")
TMP->( DbGoTop() )
If TMP->( !Eof() )
	
	While TMP->( !Eof() )
		
		aAdd( aCols, Array( Len( aHeader ) + 1 ) )
		nLinha++
		
		For nI := 1 To Len( aHeader )
			cX3Campo := AllTrim( aHeader[nI][2] )
			If aHeader[nI][10] == 'V'
				aCols[nLinha][nI] := CriaVar( cX3Campo, .T. )
			ElseIf Alltrim(aHeader[nI][2]) == "BZ_FILIAL"
				aCols[nLinha][nI] := TMP->BZ_FILIAL+"-"+Posicione("SM0",1,Substr(cNumEmp,1,2)+TMP->BZ_FILIAL,"M0_FILIAL")
			ElseIf Alltrim(aHeader[nI][2]) == "BZ_UPRC"
				If SB1->B1_GRUPO $ ("0003/0007")
					aCols[nLinha][nI] := TMP->B1_UPRC
				Else
					aCols[nLinha][nI] := TMP->BZ_UPRC
				EndIf
			ElseIf aHeader[nI][2] == "MARGEM"
				nDescon  	:= (((SB1->B1_PRV1 - aCols[ nLinha, 9 ]) / SB1->B1_PRV1)*100)
				aCols[nLinha][nI] := nDescon
			ElseIf Substr(aHeader[nI][2],1,3) $ "MES"
				nPos := aScan(_aVendas,{|x| x[8] == TMP->BZ_FILIAL })
				If nPos > 0
					aCols[nLinha][nI] := Val(_aVendas[nPos,Val(Substr(cX3Campo,4,2))+1])
				Else
					aCols[nLinha][nI] := 0
				EndIf
			Else
				aCols[nLinha][nI] := &( 'TMP->' + cX3Campo )
			EndIf
		Next nI
		
		aCols[nLinha][Len( aHeader ) + 1] := .F.
		
		_nEstMax += TMP->BZ_EMAX
		_nEstMin += TMP->BZ_EMIN
		_nSldEst += TMP->B2_QATU
		_nSldPed += iif (TMP->B2_XTRANSI<0,0,TMP->B2_XTRANSI)
		_nSldRes += TMP->B2_RESERVA
		_nSldx += iif (TMP->B2_XRESERV<0,0,TMP->B2_XRESERV)
		
		TMP->( DbSkip() )
		
	EndDo
	
	aAdd( aCols, Array( Len( aHeader ) + 1 ) )
	nLinha++
	
	aCols[nLinha][1]	:= "Total:"
	aCols[nLinha][3]	:= _nEstMax
	aCols[nLinha][4]	:= _nEstMin
	aCols[nLinha][5]	:= _nSldEst
	
	aCols[nLinha][6]	:= _nSldPed
	aCols[nLinha][7]	:= _nSldx
	aCols[nLinha][8]	:= _nSldRes
	
	aCols[nLinha][9]	:= 1
	aCols[nLinha][10]	:= 1
	
	aCols[nLinha][12]	:= _nMes01
	aCols[nLinha][13]	:= _nMes02
	aCols[nLinha][14]	:= _nMes03
	aCols[nLinha][15]	:= _nMes04
	aCols[nLinha][16]	:= _nMes05
	aCols[nLinha][17]	:= _nMes06
	
	aCols[nLinha][Len( aHeader ) + 1] := .F.
	
EndIf

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVReparte  บAutor  | Antonio Carlos     บ Data ณ14/09/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VReparte()


Local aPosObj  := {}
Local aObjects := {}
Local aSize    := {}
Local aPosGet  := {}
Local aInfo    := {}

Local cTitulo	:= "Consulta de Produtos - Laselva"
Local aButtons 	:= {}

DbSelectArea('SB1')
_cObserva := MSMM(SB1->B1_CODOBS,60)

aAdd(aButtons, {"DBG12"		, {||PesqPC()	},"PC"			})
aAdd(aButtons, {"PRECO"		, {||AtuPreco()	},"Preco"		})
aAdd(aButtons, {"PRODUTO"	, {||DeVisual()	},"Plataforma"	})
If !empty(_cObserva)
	aAdd(aButtons, {"OBJETIVO"	, {||Aviso('OBSERVAวีES',_cObserva,{'OK'},3,'Observa็๕es')},"Observa็๕es"	})
EndIf

Private oCombo
Private cCombo
Private oDlgCupom
Private oGetDados
Private _nQtdTot	:= 0
//Private cProd 		:= cProduto
Private lRefresh	:= .T.

Private aHeader		:= {}
Private aCols		:= {}
Private aRotina		:= {{"Pesquisar"	, "AxPesqui", 0, 1},;
{"Visualizar"	, "AxVisual", 0, 2},;
{"Incluir"		, "AxInclui", 0, 3},;
{"Alterar"		, "AxAltera", 0, 4},;
{"Excluit"		, "AxDeleta", 0, 5}}

aSize	:= MsAdvSize(,.F.,400)

aObjects := {}

AAdd( aObjects, { 0,    61, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 0,    15, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

//
_cArq := "\system\comp001\"+RetCodUsr()+".txt"

If File(_cArq)
	
	FT_FUSE(_cArq)
	FT_FGotop()
	
	nLin := 1
	
	While ( !FT_FEof() )
		
		cLinha  := FT_FREADLN()
		
		If nLin == 1
			nOpcao := Alltrim(cLinha)
		ElseIf nLin == 2
			_cPlata := Alltrim(cLinha)
		EndIf
		
		FT_FSkip()
		nLin++
		
	EndDo
	
	LjMsgRun("Aguarde..., Consultando base...",, {|| ConProd(.T.,_cPlata,lInvFil,Val(nOpcao) ) })
	
Else
	LjMsgRun("Aguarde..., Consultando base...",, {|| ConProd(.F.) })
EndIf
//

DEFINE MSDIALOG oDlgCupom TITLE cTitulo From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

DEFINE FONT oFontBold   NAME 'Times New Roman' SIZE 10, 12 Bold

@ 15, 008 SAY "Produto:" Font oFontBold PIXEL OF oDlgCupom
@ 25, 008 MSGET oCodigo VAR SB1->B1_COD SIZE 100,7 WHEN .F. PIXEL Font oFontBold OF oDlgCupom

@ 15, 120 SAY "Cod.Barras:" Font oFontBold PIXEL OF oDlgCupom
@ 25, 120 MSGET oCodBar VAR SB1->B1_CODBAR SIZE 100,7 WHEN .F. PIXEL Font oFontBold OF oDlgCupom

@ 15, 232 SAY "Descricao:" Font oFontBold PIXEL OF oDlgCupom
@ 25, 232 MSGET oDescri VAR Substr(SB1->B1_DESC,1,30) SIZE 210,7 WHEN .F. PIXEL Font oFontBold OF oDlgCupom

@ 35, 008 SAY "Grupo:" Font oFontBold PIXEL OF oDlgCupom
@ 45, 008 MSGET oGrupo VAR Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DESC") SIZE 100,7 WHEN .F. PIXEL Font oFontBold OF oDlgCupom

@ 35, 120 SAY "Assunto:" Font oFontBold PIXEL OF oDlgCupom
@ 45, 120 MSGET oAssunto VAR Posicione("SZ1",1,xFilial("SZ1")+SB1->B1_CODASS,"Z1_DESC") SIZE 140,7 WHEN .F. PIXEL Font oFontBold OF oDlgCupom

@ 35, 272 SAY "Sub-Assunto:" Font oFontBold PIXEL OF oDlgCupom
@ 45, 272 MSGET oSubAss VAR Posicione("SZ2",1,xFilial("SZ2")+SB1->B1_CODSA,"Z2_DESC") SIZE 170,7 WHEN .F. PIXEL Font oFontBold OF oDlgCupom

@ 55, 008 SAY "Preco Laselva:" Font oFontBold PIXEL OF oDlgCupom
@ 65, 008 MSGET oPreco2 VAR SB1->B1_PRV1 PICTURE "@E 9,999,999.99" SIZE 50,7 WHEN .F. PIXEL Font oFontBold OF oDlgCupom

@ 55, 70 SAY "Preco Forn.:" Font oFontBold PIXEL OF oDlgCupom
@ 65, 70 MSGET oPreco2 VAR SB1->B1_PRV2 PICTURE "@E 9,999,999.99" SIZE 50,7 WHEN .F. PIXEL Font oFontBold OF oDlgCupom

@ 55, 130 SAY "Fornecedor:" Font oFontBold PIXEL OF oDlgCupom
@ 65, 130 MSGET oFornece VAR Posicione("SA2",1,xFilial("SA2")+SB1->B1_PROC+SB1->B1_LOJPROC,"A2_NOME") SIZE 200,7 WHEN .F. PIXEL Font oFontBold OF oDlgCupom

@ 55, 340 SAY "Referencia:" Font oFontBold PIXEL OF oDlgCupom
@ 65, 340 MSGET oRefere VAR SB1->B1_CODBAR SIZE 80,7 WHEN .F. PIXEL Font oFontBold OF oDlgCupom



oGetDados	:= MSGetDados():New(aPosObj[2,1]+20,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],4,"U_LINHAOK",,,.T.,{"BZ_PERFIL","BZ_SUPPLY","BZ_EMAX","BZ_EMIN"},,,,"U_FIELDOK","U_SUPERDEL",,"U_DELOK",)

ACTIVATE MSDIALOG oDlgCupom CENTERED ON INIT EnchoiceBar( oDlgCupom, { || GrvSBZ() }, { ||  oDlgCupom:End() },, aButtons )

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPesqPC    บAutor  | Antonio Carlos     บ Data ณ14/09/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PesqPC()

Local _aPedidos := {}

cQry := " SELECT DISTINCT (C7_NUM), C7_EMISSAO, C7_FORNECE, C7_LOJA, A2_NOME "
cQry += " FROM " +RetSqlName("SC7")+" SC7 "
cQry += " INNER JOIN " +RetSqlName("SA2")+" SA2 ""
cQry += " ON A2_COD+A2_LOJA = C7_FORNECE+C7_LOJA AND SA2.D_E_L_E_T_ <> '*' "
cQry += " WHERE "
cQry += " C7_PRODUTO = '"+cProd+"' AND "
cQry += " (C7_QUANT-C7_QUJE-C7_QTDACLA)>0 AND "
cQry += " SC7.D_E_L_E_T_ <> '*' "

TcQuery cQry NEW ALIAS "TRB"

DbSelectArea("TRB")
TRB->( DbGoTop() )
If TRB->( !Eof() )
	
	While TRB->( !Eof() )
		Aadd(_aPedidos,{TRB->C7_NUM,;
		Substr(TRB->C7_EMISSAO,7,2)+"/"+Substr(TRB->C7_EMISSAO,5,2)+"/"+Substr(TRB->C7_EMISSAO,1,4),;
		TRB->C7_FORNECE,;
		TRB->C7_LOJA,;
		TRB->A2_NOME})
		TRB->( DbSkip() )
	EndDo
	
	DEFINE MSDIALOG oDlgP TITLE "Pedido de Compra" FROM 200,000 TO 400,650 OF oMainWnd PIXEL
	
	@ 020,008 LISTBOX  oLstPed VAR cVarFil Fields HEADER "Pedido","Emissao","Fornecedor","Loja","Nome" SIZE 300,70 OF oDlgP PIXEL
	oLstPed:SetArray(_aPedidos)
	oLstPed:bLine := { || { _aPedidos[oLstPed:nAt,1],_aPedidos[oLstPed:nAt,2],_aPedidos[oLstPed:nAt,3],_aPedidos[oLstPed:nAt,4],_aPedidos[oLstPed:nAt,5]}}
	oLstPed:Refresh()
	
	ACTIVATE MSDIALOG oDlgP CENTERED ON INIT EnchoiceBar(oDlgP,{|| oDlgP:End()}, {|| oDlgP:End()})
	
Else
	
	MsgStop("Nao existem pedidos de compra para esse produto!")
	
EndIf

DbSelectArea("TRB")
DbCloseArea()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIELDOK   บAutor  | Antonio Carlos     บ Data ณ14/09/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณLaselva                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIELDOK()


Local aRetUsu		:= {}
Private  _lRet		:= .F.
Private cCTGrpUser	:= ""

PswOrder(2)
If PSWSEEK(cUserName,.T.)
	PswOrder(3)
	aRetUsu := PswRet()
	For nX := 1 to Len(aRetUsu[1][10])
		cCTGrpUser += "/" + IIF(!EMPTY(ALLTRIM(CTGrpUser(aRetUsu[1][10][nX]))),CTGrpUser(aRetUsu[1][10][nX]),aRetUsu[1][10][nX]) + "/"
	Next nX
EndIf

If ("PRODUTOS" $ cCTGrpUser) .Or. ("000027" $ cCTGrpUser) .Or. ("Administrador" $ cUserName ) .or. (__cUserId $ GetMv('LA_PODER'))
	_lRet := .T.
Else
	MsgStop("Usuario sem permissao para realizar alteracao!")
EndIf


Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLINHAOK   บAutor  | Antonio Carlos     บ Data ณ14/09/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณLaselva                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LINHAOK()


Local _lRet := .T.

If aCols[n][4] > aCols[n][3]
	MsgStop("Reparte Minino superior ao Maximo!")
	_lRet := .F.
EndIf

Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTGrpUser บAutor  | Antonio Carlos     บ Data ณ14/09/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o nome do grupo de usuarios                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณLaselva                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function CTGrpUser(cCodGrup)


Local cName   := Space(15)
Local aGrupo  := {}

PswOrder(1)
IF	PswSeek(cCodGrup,.F.)
	aGrupo   := PswRet()
	cNameGrp := Upper(Alltrim(aGrupo[1,2]))
	cNameGrp := iif(empty(cNameGrp),Upper(Alltrim(aGrupo[1,1])),cNameGrp)
EndIF
IF cCodGrup == "******"
	cNameGrp := "Todos"
EndIF

Return(cNameGrp)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |GrvSBZ    บAutor  | Antonio Carlos     บ Data ณ14/09/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ									                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณLaselva                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvSBZ()


Local aArea 		:= GetArea()
Local _nCont		:= 0
Local aRetUsu		:= {}
Private cCTGrpUser	:= ""

PswOrder(2)
If PSWSEEK(cUserName,.T.)
	PswOrder(3)
	aRetUsu := PswRet()
	For nX := 1 to Len(aRetUsu[1][10])
		cCTGrpUser += "/" + IIF(!EMPTY(ALLTRIM(CTGrpUser(aRetUsu[1][10][nX]))),CTGrpUser(aRetUsu[1][10][nX]),aRetUsu[1][10][nX]) + "/"
	Next nX
EndIf

If ("PRODUTOS" $ cCTGrpUser) .Or. ("000027" $ cCTGrpUser) .Or. ("Administrador" $ cUserName ) .or. (__cUserId $ GetMv('LA_PODER'))
	
	For _nI := 1 To Len(aCols)
		If aCols[n][4] > aCols[n][3]
			_nCont++
		EndIf
	Next _nI
	
	If _nCont > 0
		MsgStop("Existem repartes Minino superior ao Maximo, favor corrigir!")
	Else
		
		For _nI := 1 To Len(aCols)
			
			DbSelectArea("SBZ")
			SBZ->( DbSetOrder(1) )
			If SBZ->( DbSeek(Substr(aCols[_nI][1],1,2)+cProd ) )
				RecLock("SBZ",.F.)
				SBZ->BZ_PERFIL	:= aCols[_nI][2]
				SBZ->BZ_EMAX	:= aCols[_nI][3]
				SBZ->BZ_EMIN	:= aCols[_nI][4]
				SBZ->( MsUnLock() )
			EndIf
			
		Next _nI
		
		MsgInfo("Alteracao efetuada com sucesso!")
		
	EndIf
Else
	MsgStop("Usuario sem permissao para efetuar alteracao!")
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |AtuPreco  บAutor  | Antonio Carlos     บ Data ณ14/09/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ									                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณLaselva                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuPreco()


U_COMP004(cProd)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |C         บAutor  | Antonio Carlos     บ Data ณ14/09/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ									                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณLaselva                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function C(nTam)


Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor

If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento para tema "Flat"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If "MP10" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf

Return Int(nTam)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |DeVisual  บAutor  | Antonio Carlos     บ Data ณ14/09/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ									                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณLaselva                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DeVisual()


Private oRadio
Private nRadio
Private nOpca := 1
Private oDlgVD

DEFINE MSDIALOG oDlgVD FROM  94,1 TO 273,293 TITLE OemToAnsi("Consulta Plataformas/Lojas") PIXEL

@ 10,17 Say OemToAnsi("Selecione:") SIZE 150,7 OF oDlgVD PIXEL

@ 27,07 TO 72, 140 OF oDlgVD  PIXEL

@ 35,10 Radio 	oRadio VAR nRadio;
ITEMS 	"Plataformas",;
"Lojas";
3D SIZE 100,10 OF oDlgVD PIXEL

DEFINE SBUTTON FROM 75,085 TYPE 1 ENABLE OF oDlgVD ACTION ( DeAtu(nOpca) )
DEFINE SBUTTON FROM 75,115 TYPE 2 ENABLE OF oDlgVD ACTION ( oDlgVD:End() )

ACTIVATE MSDIALOG oDlgVD CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |DeAtu     บAutor  | Antonio Carlos     บ Data ณ14/09/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ									                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณLaselva                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DeAtu()
///////////////////////

If nOpca == 1
	If nRadio == 1
		
		VPlataf(1)
		
	ElseIf nRadio == 2
		
		VPlataf(2)
		
	EndIf
	
EndIf

oDlgVD:End()

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VPlataf(nOpc)
/////////////////////////////

Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")

Private oDlg
Private oChkInvFil

Private aPlata		:= {}
Private cStrPlata	:= ""
Private cCadastro	:= IIf(nOpc==1,"Seleciona Plataforma","Seleciona Lojas")

_cLabel	:= IIf(nOpc==1,"Plataformas","Lojas")

lInvFil := .F.

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 To 380,400 OF oMainWnd PIXEL

//Group Box de Plataforma
@ 10,10  TO 150,197 LABEL _cLabel OF oDlg PIXEL

//Grid de Plataformas/Lojas

If Select("TMPLAT") > 0
	DbSelectArea("TMPLAT")
	DbCloseArea()
EndIf

If nOpc == 1
	cQryPlat := " SELECT CONVERT(VARCHAR(3),Codsetor) AS CODIGO, Descricao AS NOME FROM informatica.dbo.Setor (NOLOCK) ORDER BY Codsetor "
Else
	
	cQryPlat := " SELECT BZ_FILIAL AS CODIGO, M0_FILIAL AS NOME "
	cQryPlat += " FROM "+RetSqlName("SBZ")+" SBZ (NOLOCK) "
	cQryPlat += " INNER JOIN SIGA.dbo.sigamat_copia ON M0_CODFIL = BZ_FILIAL"  // retirada a condi็ใo ativo = 1, por solicita็ใo de danieljg em26/3/12 - #53905
	//cQryPlat += " INNER JOIN SIGA.dbo.sigamat_copia ON M0_CODFIL = BZ_FILIAL AND ativo = 1 "
	cQryPlat += " WHERE "
	cQryPlat += " BZ_COD = '"+cProd+"' AND "
	cQryPlat += " SBZ.D_E_L_E_T_ = '' "
	cQryPlat += " ORDER BY BZ_FILIAL "
	
EndIf

TcQuery cQryPlat NEW ALIAS "TMPLAT"

DbSelectArea("TMPLAT")
TMPLAT->( DbGoTop() )
While TMPLAT->( !Eof() )
	Aadd( aPlata, { .F.,TMPLAT->CODIGO,TMPLAT->NOME } )
	TMPLAT->( DbSkip() )
EndDo

/*
If !lInvFil
VConfig()
EndIf
*/

//@ 60,30  CHECKBOX oChkInvFil VAR lInvFil PROMPT "Inverter Selecao" SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(aPlata , {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oLstPlata:Refresh(.F.)) //"Inverter Selecao"
@ 20,30  CHECKBOX oChkInvFil VAR lInvFil PROMPT "Visualiza todas" SIZE 50, 10 OF oDlg PIXEL
@ 30,25  LISTBOX  oLstPlata VAR cVarPlat Fields HEADER "","Codigo",IIf(nOpc==1,"Plataforma","Loja") SIZE 160,110 ON DBLCLICK (aPlata:=LSVTroca(oLstPlata:nAt,aPlata),oLstPlata:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstPlata,oOk,oNo,@aPlata) OF oDlg PIXEL
oLstPlata:SetArray(aPlata)
oLstPlata:bLine := { || {If(aPlata[oLstPlata:nAt,1],oOk,oNo),aPlata[oLstPLata:nAt,2],aPLata[oLstPLata:nAt,3] }}

DEFINE SBUTTON FROM 160,060 TYPE 1 ACTION( AtuDados(nOpc),oDlg:End() )  ENABLE OF oDlg
DEFINE SBUTTON FROM 160,110 TYPE 2 ACTION( oDlg:End() ) ENABLE OF oDlg

oChkInvFil:Refresh()

ACTIVATE MSDIALOG oDlg CENTERED

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LSVTroca(nIt,aArray)
////////////////////////////////////

aArray[nIt,1] := !aArray[nIt,1]

Return aArray

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AtuDados(nOpcao)
////////////////////////////////

AEval(aPlata, {|x| If(x[1]==.T.,cStrPlata+="'"+SubStr(x[2],1,TamSX3("B1_FILIAL")[1])+"'"+",",Nil)})
_cPlata	:= Substr(cStrPlata,1,Len(cStrPlata)-1)
//_cPlata := Substr(cStrPlata,1,Len(cStrPlata)-1)

//_cPlata := StrTran(_cTPla,'', )

If Empty(_cPlata) .And. !lInvFil
	MsgStop("Selecione uma plataforma para processamento!")
	Return()
EndIf

//
_cArq := "\system\comp001\"+RetCodUsr()+".txt"

If File(_cArq)
	
	FT_FUSE(_cArq)
	FT_FGotop()
	
	FT_FUse()
	FErase(_cArq)
	
EndIf

If !lInvFil
	_cArq := "\system\comp001\"+RetCodUsr()+".txt"
	nFal := fCreate(_cArq)
	
	If nFal == -1
		MsgAlert("O arquivo "+_cArq+" nao pode ser criado! ","Atencao!")
		Return
	EndIf
	
	cLin := Alltrim(Str(nOpcao)) + CHR(13)+CHR(10)
	fWrite(nFal,cLin,Len(cLin))
	cLin := _cPlata + CHR(13)+CHR(10)
	fWrite(nFal,cLin,Len(cLin))
	
	fClose(nFal)
EndIf
//

LjMsgRun("Aguarde..., Consultando base...",, {|| ConProd(.T.,_cPlata,lInvFil,nOpcao) })

oGetDados:oBrowse:Refresh()

If Select("TMPLAT") > 0
	DbSelectArea("TMPLAT")
	DbCloseArea()
EndIf

Return

//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VConfig()
/////////////////////////

Local _cCampo	:= ""
Local _aFilx	:= {}

_cArq := "\system\comp001\"+RetCodUsr()+".txt"

If File(_cArq)
	
	FT_FUSE(_cArq)
	FT_FGotop()
	
	nLin := 1
	
	While ( !FT_FEof() )
		
		cLinha  := FT_FREADLN()
		
		If nLin == 1
			_nOpcv := Alltrim(cLinha)
		ElseIf nLin == 2
			_cPlatv := Alltrim( StrTran(cLinha,"'"," ")	)
		EndIf
		
		FT_FSkip()
		nLin++
		
	EndDo
	
	For _nI := 1 To Len(_cPlatv)
		If Subs(_cPlatv,_nI,1) == ","
			Aadd(_aFilx, { Alltrim(_cCampo) } )
			_cCampo := ""
		Else
			_cCampo += Subs(_cPlatv,_nI,1)
		EndIf
	Next _nI
	
	If !Empty(_cCampo)
		Aadd(_aFilx, { Alltrim(_cCampo) } )
		_cCampo := ""
	EndIf
	
	For _nI := 1 To Len(_aFilx)
		nPos := aScan( aPlata ,{ |x| Alltrim(x[2]) == _aFilx[_nI,1] } )
		
		If nPos > 0
			aPlata[nPos,1] := .T.
		EndIf
		
	Next _nI
	
EndIf

Return
