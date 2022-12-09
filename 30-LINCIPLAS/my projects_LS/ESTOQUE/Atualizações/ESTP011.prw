#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ESTP009   ³Autor³ Antonio Carlos         ³ Data ³ 23/04/09 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ajuste de estoque atraves de arquivo dbf.    			  º±±
±±ºÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄº±±
±±ºModulos   ³ Estoque/Custos                                             º±±
±±ºÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄº±±
±±ºUso       ³ Especifico - Laselva Bookstore                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ESTP011()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aSays		:= {}
Private aButtons	:= {}
Private	nOpca		:= 0 
Private cCadastro	:= "Gera Movimentacao Interna"
Private cPerg		:= Padr("ESTP11",len(SX1->X1_GRUPO)," ") 
Private _cLocal		
Private dDatad		
Private dDataa		:= CTOD("  /  /  ")
Private lMsErroAuto	:= .F.
ValidPerg()
Pergunte(cPerg, .F.)

AADD(aSays,"Este programa tem o objetivo de gerar lançamentos via ")
AADD(aSays,"Movimentação Interna (SD3) para atualização do campo  ")
AADD(aSays,"custo ref. Movimentação de Saida.")
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons )
	
If nOpcA == 1
 	If Pergunte(cPerg,.T.)
	 	dDataa := MV_PAR01
	 	LjMsgRun("Aguarde..., Processando registros...",, {|| CriaArq() })	
	 EndIf	
EndIf		
		
Return

Static Function CriaArq()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local nQtdReg   := 0
Local lLog      := .F.
Local cItem     := ""
Local lAtuMsg   := .T.
Local nPosOri   := 0
Local lStruct   := .F.
Local nUsado    := 0
Local lValid    := .F.
Local nPos      := 0
Local lOk       := .F. 
Local lAtualiza	:= .F.
Local nLin      := 0                                          
Local x         := 0
Local y         := 0
Local z         := 0
Local nx        := 0      
Local dDtAtu    := CTOD("")
Local aStru		:= {}
Private cHora   := Time()

If Empty(dDataa)
	MsgStop("Data invalida!")
	Return	
EndIf                    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Aadd(aStru, {"D3_FILIAL"	,		"C",	2,	0})
Aadd(aStru, {"D3_TM"		,		"C",	3,	0})
Aadd(aStru, {"D3_COD"		,		"C",	15,	0})
Aadd(aStru, {"D3_QUANT"		,		"N",	11,	2})
Aadd(aStru, {"D3_CUSTO1"	,		"N",	14,	2})
Aadd(aStru, {"D3_LOCAL"		,		"C",	2,	0})
Aadd(aStru, {"D3_CC"		,		"C",	9,	0})    
Aadd(aStru, {"D3_EMISSAO"	,		"D",	8,	0})    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo temporario.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArqD3   := CriaTrab( aStru, .T. )
dbUseArea(.T.,"DBFCDX", cArqD3, "TMP", .F. )

dDatad := DTOS(dDataa)
dDatad := Substr(dDatad,1,6)+"01"

/*
cQry := " SELECT DISTINCT(D2_COD) AS COD, D2_CUSTO1, B2_CM1, 
cQry += " CASE WHEN (MAX(D1_CUSTO) <> 0 OR MAX(D1_CUSTO) IS NOT NULL) THEN ROUND((MAX(D1_CUSTO)/MAX(D1_QUANT)),2) ELSE 
cQry += " CASE WHEN (MAX(D3_CUSTO1) <> 0) THEN ROUND((MAX(D3_CUSTO1)/MAX(D3_QUANT)),2) ELSE 
cQry += " ROUND(B1_PRV1 * 0.6,2) 
cQry += " END END AS CUSTO 
cQry += " FROM "+RetSqlName("SD2")+"  SD2 WITH(NOLOCK) " 
cQry += " INNER JOIN "+RetSqlName("SB1")+"  SB1 WITH(NOLOCK) " 
cQry += " ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = '' 
cQry += " INNER JOIN "+RetSqlName("SB2")+"  SB2 WITH(NOLOCK) " 
cQry += " ON D2_FILIAL = B2_FILIAL AND D2_COD = B2_COD AND SB2.D_E_L_E_T_ = '' 
cQry += " INNER JOIN "+RetSqlName("SF4")+"  SF4 WITH(NOLOCK) " 
cQry += " ON F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = '' AND F4_ESTOQUE = 'S' 
cQry += " LEFT JOIN "+RetSqlName("SD1")+"  SD1 WITH(NOLOCK) " 
cQry += " ON D1_FILIAL = D2_FILIAL AND D1_COD = D2_COD AND D1_DTDIGIT > '"+DTOS(dDataa)+"' AND SD1.D_E_L_E_T_ = ''
cQry += " LEFT JOIN "+RetSqlName("SD3")+"  SD3 WITH(NOLOCK) " 
cQry += " ON D3_FILIAL = D2_FILIAL AND D3_COD = D2_COD AND SD3.D_E_L_E_T_<>'*'
cQry += " WHERE 
cQry += " D2_FILIAL = '"+xFilial("SD2")+"' AND 
cQry += " D2_EMISSAO BETWEEN '"+dDatad+"' AND '"+DTOS(dDataa)+"' AND "
cQry += " D2_TIPO = 'N' AND 
cQry += " D2_CUSTO1 = 0 AND 
cQry += " SD2.D_E_L_E_T_ = ''  
cQry += " GROUP BY D2_COD, D2_CUSTO1, B2_CM1, B1_PRV1 
cQry += " ORDER BY D2_COD
*/

/*
cQry := " SELECT DISTINCT(D2_COD) AS COD, D2_CUSTO1, B2_CM1, "
cQry += " CASE WHEN (MAX(D1_CUSTO) <> 0 OR MAX(D1_CUSTO) IS NOT NULL) THEN ROUND((MAX(D1_CUSTO)/MAX(D1_QUANT)),2) ELSE " 
cQry += " CASE WHEN (MAX(D3_CUSTO1) <> 0) THEN ROUND((MAX(D3_CUSTO1)/MAX(D3_QUANT)),2) ELSE ROUND(B1_PRV1*0.7,2) END END AS CUSTO "
cQry += " FROM "+RetSqlName("SD2")+" SD2 WITH(NOLOCK) "
cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 WITH(NOLOCK) "
cQry += " ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
cQry += " INNER JOIN "+RetSqlName("SB2")+" SB2 WITH(NOLOCK) "
cQry += " ON D2_FILIAL = B2_FILIAL AND D2_COD = B2_COD AND SB2.D_E_L_E_T_ = '' "
cQry += " INNER JOIN "+RetSqlName("SF4")+" SF4 WITH(NOLOCK) "
cQry += " ON F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = '' AND F4_ESTOQUE = 'S' "
cQry += " LEFT JOIN "+RetSqlName("SD1")+" SD1 WITH(NOLOCK) "
cQry += " ON D1_FILIAL = D2_FILIAL AND D1_COD = D2_COD AND D1_DTDIGIT > '20081031' AND SD1.D_E_L_E_T_ = '' "
cQry += " LEFT JOIN "+RetSqlName("SD3")+" SD3 WITH(NOLOCK) "
cQry += " ON D3_FILIAL = D2_FILIAL AND D3_COD = D2_COD AND SD3.D_E_L_E_T_<>'*' "
cQry += " WHERE "
cQry += " D2_FILIAL = '"+xFilial("SD2")+"' AND MONTH(D2_EMISSAO) = '10' AND YEAR(D2_EMISSAO)='2008' AND D2_TIPO = 'N' AND SD2.D_E_L_E_T_ = '' "
cQry += " AND SD2.D2_COD NOT IN (SELECT DISTINCT(D1_COD) FROM SD1010 WHERE D1_FILIAL='"+xFilial("SD1")+"' AND MONTH(D1_DTDIGIT)='10' AND YEAR(D1_DTDIGIT)='2008') "
cQry += " AND SD2.D2_COD NOT IN (SELECT DISTINCT(D3_COD) FROM SD3010 WHERE D3_FILIAL='"+xFilial("SD3")+"' AND MONTH(D3_EMISSAO)='10' AND YEAR(D3_EMISSAO)='2008' AND D3_TM<'500' AND D3_CUSTO1<>0) "
cQry += " GROUP BY D2_COD, D2_CUSTO1, B2_CM1, B1_PRV1 ORDER BY D2_COD "
*/

/*
cQry := " SELECT DISTINCT(D2_COD) AS COD, D2_CUSTO1, B2_CM1, "
cQry += " CASE WHEN (AVG(D1_CUSTO) <> 0 OR AVG(D1_CUSTO) IS NOT NULL) "
cQry += " THEN ROUND((AVG(D1_CUSTO)/MAX(D1_QUANT)),2) "
cQry += " ELSE CASE WHEN (AVG(D3_CUSTO1) <> 0) "
cQry += " THEN ROUND((AVG(D3_CUSTO1)/MAX(D3_QUANT)),2) "
cQry += " ELSE ROUND(B1_PRV1*0.7,2) END END AS CUSTO "
 
cQry += " FROM "+RetSqlName("SD2")+" SD2 WITH(NOLOCK) "
cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 WITH(NOLOCK) "
cQry += " ON D2_COD = B1_COD AND SB1.D_E_L_E_T_='' "
cQry += " INNER JOIN "+RetSqlName("SB2")+" SB2 WITH(NOLOCK) "
cQry += " ON D2_FILIAL = B2_FILIAL AND D2_COD = B2_COD AND SB2.D_E_L_E_T_='' "
cQry += " INNER JOIN "+RetSqlName("SF4")+" SF4 WITH(NOLOCK) "
cQry += " ON F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ ='' AND F4_ESTOQUE = 'S' "
cQry += " LEFT JOIN "+RetSqlName("SD1")+" SD1 WITH(NOLOCK) "
cQry += " ON D1_FILIAL = D2_FILIAL AND D1_COD = D2_COD AND D1_DTDIGIT > '20081031' AND SD1.D_E_L_E_T_ ='' "
cQry += " LEFT JOIN "+RetSqlName("SD3")+" SD3 WITH(NOLOCK) "
cQry += " ON D3_FILIAL = D2_FILIAL AND D3_COD = D2_COD AND SD3.D_E_L_E_T_='' "
 
cQry += " WHERE  D2_FILIAL = '"+xFilial("SD2")+"' AND MONTH(D2_EMISSAO) = '10' AND YEAR(D2_EMISSAO)='2008' AND D2_TIPO = 'N' AND SD2.D_E_L_E_T_ ='' "
cQry += " AND SD2.D2_COD NOT IN "
cQry += " (SELECT DISTINCT(D1_COD) FROM SD1010 INNER JOIN SF4010 ON D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND SF4010.D_E_L_E_T_ = '' WHERE D1_FILIAL='"+xFilial("SD2")+"' AND MONTH(D1_DTDIGIT)='10' AND YEAR(D1_DTDIGIT)='2008' AND D_E_L_E_T_='' ) "
cQry += " AND SD2.D2_COD NOT IN "
cQry += " (SELECT DISTINCT(D3_COD) FROM SD3010 WHERE D3_FILIAL='"+xFilial("SD2")+"' AND MONTH(D3_EMISSAO)='10' AND YEAR(D3_EMISSAO)='2008' AND D3_TM<'500' AND D3_TM <> '300' AND D3_CUSTO1 > 0 AND D3_CUSTO1<>0 AND D_E_L_E_T_='') "
 
cQry += " GROUP BY D2_COD, D2_CUSTO1, B2_CM1, B1_PRV1 "
cQry += " ORDER BY D2_COD "

Memowrite("ESTP011.SQL",cQry)

TcQuery cQry NEW ALIAS "QRY"
*/
/*
cQry := " SELECT DISTINCT(D2_COD) AS COD, COALESCE(D2_CUSTO1,0), COALESCE(B2_CM1,0), "
cQry += " CASE WHEN (AVG(coalesce(D1_CUSTO,0)/coalesce(D1_QUANT,1)) > 0) THEN ROUND( AVG(coalesce(D1_CUSTO,0)/coalesce(D1_QUANT,1)) ,2) "
cQry += " ELSE CASE WHEN ( AVG(coalesce(D3_CUSTO1,0)/coalesce(D3_QUANT,1)) > 0 ) THEN ROUND( AVG(coalesce(D3_CUSTO1,0)/coalesce(D3_QUANT,1)) ,2) "
cQry += " ELSE ROUND( COALESCE(B1_PRV1,0)*0.7,2) END END AS CUSTO "
cQry += " FROM "+RetSqlName("SD2")+" SD2 WITH(NOLOCK) "
cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 WITH(NOLOCK) "
cQry += " ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
cQry += " INNER JOIN "+RetSqlName("SB2")+" SB2 WITH(NOLOCK) "
cQry += " ON D2_FILIAL = B2_FILIAL AND D2_COD = B2_COD AND SB2.D_E_L_E_T_ = '' "
cQry += " INNER JOIN "+RetSqlName("SF4")+" SF4 WITH(NOLOCK) "
cQry += " ON F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = '' AND F4_ESTOQUE = 'S' "
cQry += " LEFT JOIN "+RetSqlName("SD1")+" SD1 WITH(NOLOCK) "
cQry += " ON D1_FILIAL = D2_FILIAL AND D1_COD = D2_COD AND D1_DTDIGIT > '20081031' AND SD1.D_E_L_E_T_ = '' "
cQry += " LEFT JOIN "+RetSqlName("SD3")+" SD3 WITH(NOLOCK) "
cQry += " ON D3_FILIAL = D2_FILIAL AND D3_COD = D2_COD AND SD3.D_E_L_E_T_<>'*' AND D3_QUANT>0 "
cQry += " WHERE D2_FILIAL = '"+xFilial("SD2")+"' AND "
cQry += " MONTH(D2_EMISSAO) = '10' AND YEAR(D2_EMISSAO)='2008' AND D2_TIPO = 'N' AND SD2.D_E_L_E_T_ = '' "
cQry += " AND SD2.D2_COD NOT IN "
cQry += " (SELECT DISTINCT(D1_COD) FROM SD1010 WITH(NOLOCK) INNER JOIN SF4010 WITH(NOLOCK) ON D1_TES = F4_CODIGO AND F4_ESTOQUE='S' "
cQry += " WHERE D1_FILIAL='"+xFilial("SD1")+"' AND MONTH(D1_DTDIGIT)='10' AND YEAR(D1_DTDIGIT)='2008' AND SD1010.D_E_L_E_T_='' AND D1_CUSTO>0 "
cQry += " UNION ALL "
cQry += " SELECT DISTINCT(D3_COD) FROM SD3010 WITH(NOLOCK) WHERE D3_FILIAL='"+xFilial("SD3")+"' AND MONTH(D3_EMISSAO)='10' AND YEAR(D3_EMISSAO)='2008' "
cQry += " AND D3_TM<>'300' AND D3_TM<'500' AND D3_CUSTO1>0 AND SD3010.D_E_L_E_T_='') "
cQry += " GROUP BY D2_COD, D2_CUSTO1, B2_CM1, B1_PRV1 ORDER BY D2_COD "

Memowrite("ESTP011.SQL",cQry)

TcQuery cQry NEW ALIAS "QRY"
*/

//cQry := " SELECT * FROM  retorna_custo('"+xFilial("SD2")+"','20081001','20081031') "
cQry := " SELECT * FROM  retorna_custo('"+xFilial("SD2")+"','"+dDatad+"','"+DTOS(dDataa)+"') "

Memowrite("ESTP011.SQL",cQry)

TcQuery cQry NEW ALIAS "QRY"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Conta a quantidade de registros do arquivo.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄSÄÄÄÄÄÙ

DbSelectArea("QRY")
QRY->( DbGoTop() )
While QRY->( !Eof() )
	
	DbSelectArea("TMP")
	
	For _nI := 1 To 2
		
		RecLock("TMP",.T.)
		Replace TMP->D3_FILIAL	With xFilial("SD2")
		Replace TMP->D3_COD 	With QRY->D2_COD
		Replace TMP->D3_QUANT	With 1
		Replace TMP->D3_CUSTO1 	With QRY->CUSTO
		Replace TMP->D3_LOCAL	With "01"
		Replace TMP->D3_TM 		With IIf(_nI==1,"001","600")
		Replace TMP->D3_CC 		With Space(9)
		Replace TMP->D3_EMISSAO	With IIf(_nI==1,STOD(dDatad),dDataa)
		TMP->( MsUnLock() )
	
	Next _nI
	    
	nQtdReg++
	
	QRY->( DbSkip() )
	
EndDo

If nQtdReg > 0

	ProcRegua( nQtdReg )
	
	aCab 	:= {}
	aItens	:= {}
	aTotitem:= {}
	
	DbSelectArea("TMP")
	TMP->( DbGoTop() )
	While TMP->( !Eof() )
	
		aTotitem	:= {}
		aItens		:= {}
		dDtAtu 		:= TMP->D3_EMISSAO
		
		While TMP->( !Eof() ) .And. TMP->D3_FILIAL == xFilial("SD3") .And. TMP->D3_EMISSAO == dDtAtu            
		
			IncProc("Incluindo itens... ")                                                                      
	
			cTm 	:= Alltrim(TMP->D3_TM)
			cCC 	:= Alltrim(TMP->D3_CC)

			lAtualiza := .T.		
		
			aCab 	:= { {"D3_TM" ,Alltrim(TMP->D3_TM),NIL},;
					{"D3_CC" ,TMP->D3_CC ,NIL},;
					{"D3_EMISSAO" ,TMP->D3_EMISSAO ,NIL}}
	
			DbSelectArea("SF5")
			SF5->( DbSetOrder(1) )
			If SF5->( DbSeek(xFilial("SF5")+Alltrim(TMP->D3_TM)) )
			
				DbSelectArea("SB1")
				DbSetOrder(1)
				If SB1->( DbSeek(xFilial("SB1")+Alltrim(TMP->D3_COD)) )
					Aadd(aItens, {"D3_COD"    	,Alltrim(TMP->D3_COD),NIL})                                            
					Aadd(aItens, {"D3_UM"    	,SB1->B1_UM    ,NIL})                                            
					Aadd(aItens, {"D3_QUANT"  	,TMP->D3_QUANT  ,NIL})
					Aadd(aItens, {"D3_LOCAL"  	,Alltrim(TMP->D3_LOCAL),NIL})
	    		
		    		If SF5->F5_VAL = "S"
						Aadd(aItens, {"D3_CUSTO1"	,TMP->D3_CUSTO1 ,NIL})
  					EndIf
  				
	  			Else	
					lAtualiza := .F.  			
  				EndIf	
  			
			Else
   				lAtualiza := .F.
			EndIf  

		    Aadd(aTotitem,aItens)
			aItens:={}
		
			If cTm <> Alltrim(TMP->D3_TM) .OR. cCC <> Alltrim(TMP->D3_CC)
				lAtualiza := .F.
	    	EndIf
    
	    	cTm := Alltrim(TMP->D3_TM)
		    cCC	:= Alltrim(TMP->D3_CC)
	
			TMP->( DbSkip() )

		EndDo                  
		
		If lAtualiza
			MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aTotitem,3)
		Else
			Aviso("Atenção","O arquivo possui campos que não pertencem a estrutura da TMPela ou formato está divergente. Contate o"+;
			" administrador do sistema ou verifique se o arquivo foi criado corretamente.",{"OK"},1,"Falha de estrutura!")
		EndIf

		If lMsErroAuto
			MostraErro()
		EndIf
		
	EndDo
	
	Aviso("Atenção","Processamento efetuado com sucesso!",{"OK"},1,"Finalizado!")	
		
Else

	Aviso("Atenção","Nao existem registros para processamento!",{"OK"},1,"Arquivo vazio!")
	
EndIf	

DbSelectArea("TMP")
DbCloseArea()

QRY->(DbCloseArea())


Return

Static Function ValidPerg()

nXX      := 0
aPerg    := {}

/*01*/aAdd(aPerg,{ "Data de Fechamento:        	 " , "D" , 08 , 00 , "G" , "" , "" , "" , "" , "","" })

For nXX := 1 to Len( aPerg )
	If !SX1->( DbSeek( cPerg + StrZero( nXX , 2 ) ) )
		RecLock( "SX1" , .T. )
		SX1->X1_GRUPO     := cPerg
		SX1->X1_ORDEM     := StrZero( nXX , 2 )
		SX1->X1_VARIAVL   := "mv_ch"  + Chr( nXX + 96 )
		SX1->X1_VAR01     := "mv_par" + Strzero( nXX , 2 )
		SX1->X1_PRESEL    := 1
		SX1->X1_PERGUNT   := aPerg[ nXX , 01 ]
		SX1->X1_TIPO      := aPerg[ nXX , 02 ]
		SX1->X1_TAMANHO   := aPerg[ nXX , 03 ]
		SX1->X1_DECIMAL   := aPerg[ nXX , 04 ]
		SX1->X1_GSC       := aPerg[ nXX , 05 ]
		SX1->X1_DEF01     := aPerg[ nXX , 06 ]
		SX1->X1_DEF02     := aPerg[ nXX , 07 ]
		SX1->X1_DEF03     := aPerg[ nXX , 08 ]
		SX1->X1_DEF04     := aPerg[ nXX , 09 ]
		SX1->X1_DEF05     := aPerg[ nXX , 10 ]
		SX1->X1_F3        := aPerg[ nXX , 11 ]
		SX1->( MsUnlock() )
	EndIf
Next nXX

Return