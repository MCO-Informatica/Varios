#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOJP004   ºAutor  ³Antonio Carlos      º Data ³  05/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza gravação dos registros de vendas na tabela SL5      º±±
±±º          ³Resumo de Vendas.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±    
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOJP004()

Local aArea		:= GetArea()
Local aAreaSM0	:= SM0->( GetArea() )

Local oOk       := LoadBitmap( GetResources(), "LBOK")
Local oNo       := LoadBitmap( GetResources(), "LBNO")

Private oData1
Private oData2
Private oDlg

Private lInvFil		:= .F.
Private lInvGrp		:= .F.
Private aFilial		:= {}

Private _dDatad		:= CTOD("  /  /  ")
Private _dDataa		:= CTOD("  /  /  ")
Private cStrFilia	:= ""
Private cStrFil		:= ""
Private cCadastro	:= "Integra Resumo de Vendas - Protheus"

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 To 430,400 OF oMainWnd PIXEL

@ 10,10 SAY "Data de: " OF oDlg PIXEL
@ 20,10 MSGET oData1 VAR _dDatad SIZE 50,10 OF oDlg PIXEL

@ 10,80 SAY "Data ate: " OF oDlg PIXEL
@ 20,80 MSGET oData2 VAR _dDataa SIZE 50,10 OF oDlg PIXEL

//Group Box de Filiais
@ 50,10  TO 190,197 LABEL "Filiais" OF oDlg PIXEL

//Grid de Filiais
DbSelectArea("SM0")
SM0->( DbGoTop() )
While SM0->( !Eof() )
	If SM0->M0_CODIGO == "01"
		Aadd( aFilial, {.F.,M0_CODFIL,SM0->M0_FILIAL} )
	EndIf	
	SM0->( DbSkip() )
EndDo

RestArea(aAreaSM0)

@ 70,25  LISTBOX  oLstFilial VAR cVarFil Fields HEADER "","Filial","Nome" SIZE 160,110 ON DBLCLICK (aFilial:=LSVTroca(oLstFilial:nAt,aFilial),oLstFilial:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstFilial,oOk,oNo,@aFilial) OF oDlg PIXEL	//"Filial" / "Descricao"
oLstFilial:SetArray(aFilial)
oLstFilial:bLine := { || {If(aFilial[oLstFilial:nAt,1],oOk,oNo),aFilial[oLstFilial:nAt,2],aFilial[oLstFilial:nAt,3]}}

DEFINE SBUTTON FROM 200,060 TYPE 1 ACTION( LjMsgRun("Aguarde..., Importando registros SL5/CMV...",, {|| IntegraSL5(),GeraDados() }) ,oDlg:End()  )  ENABLE OF oDlg
DEFINE SBUTTON FROM 200,110 TYPE 2 ACTION(oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED
	
RestArea(aArea)

Return

Static Function LSVTroca(nIt,aArray)

aArray[nIt,1] := !aArray[nIt,1]

Return aArray

Static Function IntegraSL5(lEnd)  

Local nTotRec2	:= 0
Private aDados	:= {}
Private nTotRec	:= 0
Private _nReg	:= 0

If Empty(_dDatad) .Or. Empty(_dDataa)
	MsgStop("Parametros incorretos!")
	Return(.F.)
EndIf  

AEval(aFilial, {|x| If(x[1]==.T.,cStrFilia+="'"+SubStr(x[2],1,TamSX3("L1_FILIAL")[1])+"'"+",",Nil)})
cStrFil := Substr(cStrFilia,1,Len(cstrFilia)-1)      

If Empty(cStrFil)
	Aviso("Integra Resumo de Vendas","Informe uma filial para o procesamento!",{"Ok"})
	Return(.F.)
EndIf

If ( Month(_dDatad) < 8 .Or. Month(_dDataa) < 8  )
	
	If Select("TMPA") > 0
		DbSelectArea("TMPA")
		DbCloseArea()
	EndIf

	cQry2 := " SELECT PA4_FILIAL, PA4_DATA, PA4_PDV, PA4_NUMCFI, PA4_FORMA, PA4_ADMINI, PA4_VALOR, PA4_TROCO, PA4_CONTA, PA4_NUMCAR, PA4_AGENCI, PA4_CGC, PA4_ADMINI, L1_NUM, L1_OPERADO "
	cQry2 += " FROM "+RetSqlName("PA4")+" PA4 (NOLOCK)"
	cQry2 += " INNER JOIN "+RetSqlName("SL1")+" SL1 (NOLOCK)"
	cQry2 += " ON PA4_FILIAL = L1_FILIAL AND PA4_NUMCFI = L1_DOC AND PA4_PDV = L1_PDV AND SL1.D_E_L_E_T_ = '' "
	cQry2 += " WHERE "
	cQry2 += " PA4_FILIAL IN ("+cStrFil+") AND "
	cQry2 += " PA4_DATA BETWEEN '"+Dtos(_dDatad)+"' AND '"+Dtos(_dDataa)+"' AND "
	cQry2 += " PA4.D_E_L_E_T_ = '' "
	cQry2 += " ORDER BY PA4_FILIAL, PA4_NUMCFI, PA4_PDV "
	Memowrite("LOJP004.SQL",cQry2)
	TcQuery cQry2 NEW ALIAS "TMPA"  
	
	Count To nTotRec2
	ProcRegua(nTotRec2)
	
	DbSelectArea("TMPA")	
	TMPA->( DbGoTop() )
	If TMPA->( !Eof() )
	
		While TMPA->( !Eof() )
	
			IncProc("Gravando registros...")
		
			DbSelectArea("SL4")
			SL4->( DbSetOrder(1) )
			If !SL4->( DbSeek( TMPA->PA4_FILIAL+TMPA->L1_NUM ) )
			
				RecLock("SL4",.T.)
									
				SL4->L4_FILIAL    	:= TMPA->PA4_FILIAL
				SL4->L4_DATA  		:= STOD(TMPA->PA4_DATA)
				SL4->L4_PDV	    	:= TMPA->PA4_PDV
				SL4->L4_NUMCFIS  	:= TMPA->PA4_NUMCFI
				SL4->L4_FORMA		:= TMPA->PA4_FORMA
				SL4->L4_ADMINIS 	:= TMPA->PA4_ADMINI
				SL4->L4_VALOR 		:= TMPA->PA4_VALOR
				SL4->L4_TROCO 		:= TMPA->PA4_TROCO
				SL4->L4_CONTA 		:= TMPA->PA4_CONTA
				SL4->L4_NUMCART 	:= TMPA->PA4_NUMCAR
				SL4->L4_AGENCIA 	:= TMPA->PA4_AGENCI
				SL4->L4_CGC 		:= TMPA->PA4_CGC
				SL4->L4_INSTITU		:= Posicione("SAE",1,xFilial("SAE")+TMPA->PA4_ADMINI,"AE_DESC")
				SL4->L4_OPERADO	    := TMPA->L1_OPERADO
				SL4->L4_NUM			:= TMPA->L1_NUM
				
				SL4->(MsUnlock())     
			
			EndIf	
		
			TMPA->( DbSkip() )
		
		EndDo 
				
	EndIf

EndIf

If Select("TMPB") > 0
	DbSelectArea("TMPB")
	DbCloseArea()
EndIf

cQryB := " SELECT L1_FILIAL, L1_DINHEIR , L1_OPERADO, L1_DINHEIR, L1_CHEQUES, L1_CARTAO, L1_CONVENI, L1_VALES, L1_FINANC, "
cQryB += " L1_OUTROS , L1_VALICM , L1_VALIPI, L1_VALISS , L1_DESCONT AS DESCONTO, " 
cQryB += " L1_VLRLIQ, L1_CREDITO, L1_VLRDEBI, L1_EMISSAO " 

cQryB += " FROM "+RetSqlName("SL1")+" SL1 (NOLOCK)"
cQryB += " WHERE "

cQryB += " L1_FILIAL IN ("+cStrFil+") AND "      	

cQryB += " L1_EMISSAO BETWEEN '"+Dtos(_dDatad)+"' AND '"+Dtos(_dDataa)+"' AND "
cQryB += " SL1.D_E_L_E_T_ = '' "
cQryB += " ORDER BY L1_FILIAL, L1_EMISSAO, L1_OPERADO "  
TcQuery cQryB NEW ALIAS "TMPB"

DbSelectArea("TMPB")
TMPB->( DbGoTop() )
If TMPB->( !Eof() )
	
	While TMPB->( !Eof() ) 
				
		_cFil	:= TMPB->L1_FILIAL	
		_dEmis	:= TMPB->L1_EMISSAO    
	
		While TMPB->( !Eof() ) .And. TMPB->L1_FILIAL == _cFil .And. _dEmis == TMPB->L1_EMISSAO     	
	
			Grava_Dados(@aDados, TMPB->L1_FILIAL, TMPB->L1_OPERADO, TMPB->L1_DINHEIR, TMPB->L1_CHEQUES, TMPB->L1_CARTAO, TMPB->L1_CONVENI,;
					TMPB->L1_VALES, TMPB->L1_FINANC, TMPB->L1_OUTROS , TMPB->L1_VALICM , TMPB->L1_VALIPI, TMPB->L1_VALISS,; 
  					TMPB->DESCONTO, TMPB->L1_VLRLIQ, TMPB->L1_CREDITO, TMPB->L1_VLRDEBI, 0, TMPB->L1_EMISSAO)
		
			TMPB->( DbSkip() )
				
		EndDo
			
		AtuDados()	
		aDados := {}
					
	EndDo
		
EndIf	

If _nReg > 0
	MsgInfo("Processamento efetuado com sucesso!")
Else
	MsgInfo("Cupons marcados como contabilizados. Verificar !")		
EndIf

If Select("TMPA") > 0
	DbSelectArea("TMPA")
	DbCloseArea()
EndIf	

DbSelectArea("TMPB")
DbCloseArea()

Return
							   								    		
Static Function Grava_Dados(aDados, cFil, cCaixa, nDinheiro , nCheques, nCartao, nConveni, nVales  , nFinanc,;
								    		nOutros   , nValICM , nValIPI, nValISS , nDescPro, nVlrLiq,;
											nCredito, nVlrDebi, nVlrDev, dEmissao)

Local aTmp	:= {}
Local nI	:= 0
nI := aScan(aDados, {|aTmp| aTmp[1] == cFil, aTmp[2] == cCaixa})

If nI > 0
	
	//aDados[nI,1] += cFil
	//aDados[nI,2] += cCaixa
	aDados[nI,3] += nDinheiro
	aDados[nI,4] += nCheques
	aDados[nI,5] += nCartao 
	aDados[nI,6] += nConveni
	aDados[nI,7] += nVales 
	aDados[nI,8] += nFinanc 
	aDados[nI,9] += nOutros 
	aDados[nI,10] += nValICM 
	aDados[nI,11] += nValIPI 
	aDados[nI,12] += nValISS 
	aDados[nI,13] += nDescPro
	aDados[nI,14] += nVlrLiq
	aDados[nI,15] += nCredito
	aDados[nI,16] += nVlrDebi
	aDados[nI,17] := nVlrDev
	aDados[nI,18] := dEmissao
	
Else

	aAdd(aDados, {	cFil, cCaixa, nDinheiro	, nCheques, nCartao , nConveni,;
								 nVales		, nFinanc , nOutros , nValICM ,;
								 nValIPI	, nValISS , nDescPro, nVlrLiq ,;
								 nCredito, nVLRDebi, nVlrDev, dEmissao} )
	
EndIf

Return .T.   

Static Function AtuDados()

Local aArea		:= GetArea()
Local _nValor	:= 0

DbSelectArea("SL5") 
SL5->( DbSetOrder(1) )
	
If Len(aDados) > 0

	For nI := 1 to Len(aDados)
	
		If Select("TMPSZ8") > 0
			DbSelectArea("TMPSZ8")
			DbCloseArea()
		EndIf
		
		cQrySZ8 := " SELECT SUM(Z8_VALOR) AS TOTAL "
		cQrySZ8 += " FROM "+RetSqlName("SZ8")+" SZ8 (NOLOCK)"
		cQrySZ8 += " WHERE "
		cQrySZ8 += " Z8_FILIAL = '"+xFilial("SZ8")+"' AND "
		cQrySZ8 += " Z8_DATA = '"+aDados[nI,18]+"' AND "
		cQrySZ8 += " SZ8.D_E_L_E_T_ = '' "             
		
		TcQuery cQrySZ8 NEW ALIAS "TMPSZ8"
		
		DbSelectArea("TMPSZ8")
		TMPSZ8->( DbGoTop() )
		If TMPSZ8->( !Eof() )
			While TMPSZ8->( !Eof() )
				_nValor += TMPSZ8->TOTAL
				TMPSZ8->( DbSkip() )
			EndDo
		EndIf
	
		//lGrava := SL5->( !DbSeek( aDados[nI,1] + DToS(dDataMovto) + aDados[nI,2] ) )
		lGrava := SL5->( !DbSeek( aDados[nI,1] + aDados[nI,18] + aDados[nI,2] ) )
			
		RecLock("SL5",lGrava)	
			
		If Empty(SL5->L5_LA)
		
			_nReg++
			
			Replace L5_FILIAL  With aDados[nI,1]
			Replace L5_OPERADO With aDados[nI,2]
			Replace L5_DATA	   With STOD(aDados[nI,18])
			Replace L5_DINHEIR With aDados[nI, 3]
			Replace L5_CHEQUES With aDados[nI, 4]
			Replace L5_CARTAO  With aDados[nI, 5]
			Replace L5_CONVENI With aDados[nI, 6]
			Replace L5_VALES   With aDados[nI, 7] 
			Replace L5_FINANC  With aDados[nI, 8]
			Replace L5_OUTROS  With aDados[nI, 9]
			Replace L5_VLRICM  With aDados[nI, 10]
			Replace L5_VLRIPI  With aDados[nI, 11]
			Replace L5_VLRISS  With aDados[nI, 12]
			Replace L5_VLRDESC With aDados[nI, 13]
			Replace L5_VLRLIQ  With aDados[nI, 14]
			Replace L5_CREDITO With aDados[nI, 15]
			Replace L5_VLRDEBI With aDados[nI, 16]
			Replace L5_DEVOLV  With _nValor
				
		EndIf	
			
		DbCommit()
		MsUnlock()
				
	Next _nI
	
EndIf	

DbSelectArea("TMPSZ8")
DbCloseArea()
	
RestArea(aArea)
	
Return	

Static Function GeraDados()

Local aArea	:= GetArea()
Local _nReg	:= 0
Local _cFilMov	:= ""
Local _dDatMov	:= Date()
Local _nVlrCont	:= 0
Local _cGrupoMv	:= ""

DbSelectArea("SBM")
DbSetOrder(1)
DbGoTop()                      

DbSelectArea("Z04")
DbSetOrder(1)
DbGoTop()

DbSelectArea("SD2")
DbSetOrder(1)
DbGoTop()

	If Select("TMP") > 0
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf

	cQry := " SELECT D2_FILIAL FILMOV, D2_EMISSAO DATMOV, BM_GRUPO GRUPO, SUM(D2_TOTAL - (D2_VALIPI + D2_VALICM)) AS TOTCMV "
	cQry += " FROM "+RetSqlName("SD2")+" SD2 WITH(NOLOCK) "
	cQry += " INNER JOIN "+RetSqlName("SB1")+" SB1 WITH(NOLOCK) "
	cQry += " ON SB1.B1_COD = SD2.D2_COD AND SB1.D_E_L_E_T_ <> '*' "
	cQry += " INNER JOIN "+RetSqlName("SBM")+" SBM WITH(NOLOCK) "
	cQry += " ON SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.D_E_L_E_T_ <> '*' "
	cQry += " WHERE " 
	cQry += " SD2.D2_FILIAL IN ("+cStrFil+") AND "
	cQry += " SD2.D2_EMISSAO BETWEEN '"+Dtos(_dDatad)+"' AND '"+Dtos(_dDataa)+"' AND "
	cQry += " SD2.D2_ORIGLAN = 'LO' AND "
	cQry += " SD2.D_E_L_E_T_ <> '*' "
	cQry += " GROUP BY D2_FILIAL, SD2.D2_EMISSAO, SBM.BM_GRUPO "

	TcQuery cQry NEW ALIAS "TMP"

	DbSelectArea("TMP") 
	TMP->( DbGoTop() )
	If TMP->( !Eof() )
		While !TMP->( Eof() ) 
			_cFilMov  := TMP->FILMOV
			_dDatMov  := TMP->DATMOV
			_cGrupoMv := TMP->GRUPO
			_nVlrCont := TMP->TOTCMV
			
			DbSelectArea("Z04")
			If !DbSeek(xFilial()+_dDatMov+_cGrupoMv)
			
				RecLock("Z04",.T.)
				Z04->Z04_FILIAL := _cFilMov
				Z04->Z04_DATA   := Ctod(substr(_dDatMov,7,2)+"/"+substr(_dDatMov,5,2)+"/"+substr(_dDatMov,1,4))
				Z04->Z04_GRUPO  := _cGrupoMv
				Z04->Z04_CMV 	:= _nVlrCont
				Z04->( MSUnlock() )
				
			Else
			
				RecLock("Z04",.F.)
				Z04->Z04_CMV := _nVlrCont
				Z04->( MSUnlock() )
			Endif
			
			TMP->( DbSkip() )
		End
		
	EndIf    

	DbSelectArea("TMP")
	DbCloseArea()


cUpdSF2	:= " UPDATE SF2 "
cUpdSF2	+= " SET SF2.F2_DTLANC = SF2.F2_EMISSAO "
cUpdSF2 += " FROM " + RetSQLName("SF2") + " SF2 "
cUpdSF2 += " INNER JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) "
cUpdSF2 += " ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_ORIGLAN = 'LO' AND "
cUpdSF2 += " SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_EMISSAO = SF2.F2_EMISSAO AND SD2.D_E_L_E_T_ <> '*' "
cUpdSF2 += " WHERE "		
cUpdSF2	+= " SF2.F2_FILIAL IN ("+cStrFil+") AND "
cUpdSF2	+= " SF2.F2_EMISSAO BETWEEN '"+DTOS(_dDatad)+"' AND '"+DTOS(_dDataa)+"' AND "
cUpdSF2	+= " SF2.D_E_L_E_T_ <> '*' "

TcSQLExec(cUpdSF2)  

MsgInfo("Processamento efetuado com sucesso!")

Return