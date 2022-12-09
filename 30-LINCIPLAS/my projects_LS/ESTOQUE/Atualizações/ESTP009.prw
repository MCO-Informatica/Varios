#INCLUDE "PROTHEUS.CH"    
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                             
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

User Function ESTP009()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aSays		:= {}
Private aButtons	:= {}
Private	nOpca		:= 0 
Private cCadastro	:= "Atualiza NF Entrada"
Private cPerg		:= Padr("ESTP09",len(SX1->X1_GRUPO)," ")
Private _cLocal		
Private dDatad		
Private dDataa		:= CTOD("  /  /  ")
Private lMsErroAuto	:= .F.
ValidPerg()
Pergunte(cPerg, .F.)

AADD(aSays,"Este programa tem o objetivo de atualizar os registros")
AADD(aSays,"da tabela SD1 (Itens NF de Entrada) onde o campo custo")
AADD(aSays,"nao foi gravado corretamente.")
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

_cLocal := "CUSTO"+xFilial("SD3")+DTOS(dDataa)

If File(Alltrim(_cLocal))
	MsgStop("Arquivo existente!")
	Return
Endif

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

DbCreate(_cLocal,aStru)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo temporario.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbUseArea(.T.,,Alltrim(_cLocal),"TMP",.F.,.F.) 
IndRegua("TMP",_cLocal,"D3_EMISSAO",,,"Ordenando por Filial")

dDatad := DTOS(dDataa)
dDatad := Substr(dDatad,1,6)+"01"


cQry := " SELECT D1_FILIAL AS FILIAL, '001' AS TM, D1_COD AS COD, 0 AS QUANT, ((B1_PRV2*D1_QUANT)* 0.5) AS CUSTO, '01' AS LOCA, SPACE(9) AS CC, "
cQry += " CASE WHEN SUBSTRING(D1_DTDIGIT,7,2) = '01' THEN D1_DTDIGIT "
cQry += " ELSE "
cQry += " SUBSTRING(D1_DTDIGIT,1,6)+CAST((DAY(D1_DTDIGIT)-1)AS CHAR(2)) "
cQry += " END AS EMISSAO "
cQry += " FROM "+RetSqlName("SD1")+"  SD1 (NOLOCK)"
cQry += " INNER JOIN "+RetSqlName("SB1")+"  SB1 (NOLOCK)"
cQry += " ON D1_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
cQry += " WHERE "
cQry += " D1_FILIAL = '"+xFilial("SD1")+"' AND "
cQry += " D1_DTDIGIT BETWEEN '"+dDatad+"' AND '"+DTOS(dDataa)+"' AND "
cQry += " D1_VUNIT <= 0.50 AND "
cQry += " SD1.D_E_L_E_T_ = '' "

cQry += " UNION ALL "

cQry += " SELECT D3_FILIAL, '001' AS TM, D3_COD, 0 AS QUANT, "
cQry += " CASE WHEN B9_VINI1 <> 0 THEN (B9_VINI1/B9_QINI)*D3_QUANT ELSE "
cQry += " CASE WHEN MAX(B6_CUSTO1) <> 0 THEN (B6_CUSTO1/B6_QUANT)*D3_QUANT ELSE "
cQry += " CASE WHEN MAX(D1_CUSTO) <> 0 THEN (D1_CUSTO / D1_QUANT)*D3_QUANT ELSE "
cQry += " CASE WHEN B1_UPRC <> 0 THEN B1_UPRC*D3_QUANT ELSE 0 "
cQry += " END END END END AS CUSTO, '01' AS LOCA, SPACE(9) AS CC, D3_EMISSAO "
cQry += " FROM "+RetSqlName("SD3")+" SD3 (NOLOCK)"
cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK)"
cQry += " ON D3_COD = B1_COD AND SB1.D_E_L_E_T_ = '' "
cQry += " LEFT JOIN "+RetSqlName("SB9")+" SB9 (NOLOCK)"
cQry += " ON D3_FILIAL = B9_FILIAL AND D3_COD = B9_COD AND B9_DATA = '"+DTOS(dDataa)+"' AND SB9.D_E_L_E_T_ = '' "
cQry += " LEFT JOIN "+RetSqlName("SD1")+" SD1 (NOLOCK)"
cQry += " ON ( D1_FILIAL = D3_FILIAL AND D1_COD = D3_COD AND D1_DTDIGIT BETWEEN '"+dDatad+"' AND '"+DTOS(dDataa)+"' AND SD1.D_E_L_E_T_ = '' ) "
cQry += " LEFT JOIN "+RetSqlName("SB6")+" SB6 (NOLOCK)"
cQry += " ON (B6_FILIAL = D3_FILIAL AND B6_PRODUTO = D3_COD AND B6_DTDIGIT BETWEEN '"+dDatad+"' AND '"+DTOS(dDataa)+"' AND  B6_PODER3 = 'R' AND SB6.D_E_L_E_T_ = '') "
cQry += " WHERE "
cQry += " D3_FILIAL = '"+xFilial("SD3")+"' AND "
cQry += " D3_EMISSAO BETWEEN '"+dDatad+"' AND '"+DTOS(dDataa)+"' AND " 
cQry += " CONVERT(decimal(10,2),D3_QUANT) > 0 AND "
cQry += " CONVERT(decimal(10,2),D3_CUSTO1)/CONVERT(decimal(10,2),D3_QUANT) BETWEEN 0.01 AND 0.1 AND "
cQry += " SD3.D_E_L_E_T_ = '' "
cQry += " GROUP BY D3_FILIAL, D3_COD,D3_EMISSAO,D3_CUSTO1,D3_QUANT,B9_VINI1,B9_QINI,B1_UPRC, B6_CUSTO1, B6_QUANT,D1_CUSTO, D1_QUANT "

TcQuery cQry NEW ALIAS "QRY"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Conta a quantidade de registros do arquivo.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄSÄÄÄÄÄÙ

DbSelectArea("QRY")
QRY->( DbGoTop() )
While QRY->( !Eof() )
	
	DbSelectArea("TMP")
	
	RecLock("TMP",.T.)
	Replace TMP->D3_FILIAL	With QRY->FILIAL
	Replace TMP->D3_COD 	With QRY->COD
	Replace TMP->D3_QUANT	With QRY->QUANT
	Replace TMP->D3_CUSTO1 	With QRY->CUSTO
	Replace TMP->D3_LOCAL	With QRY->LOCA
	Replace TMP->D3_TM 		With QRY->TM	
	Replace TMP->D3_CC 		With QRY->CC
	Replace TMP->D3_EMISSAO	With STOD(QRY->EMISSAO)
	TMP->( MsUnLock() )
	
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
DbCloseArea()

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