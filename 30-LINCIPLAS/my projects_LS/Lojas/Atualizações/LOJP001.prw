#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLOJP001   บAutor  ณAntonio Carlos      บ Data ณ  05/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza grava็ใo dos registros de vendas na tabela SL5      บฑฑ
ฑฑบ          ณResumo de Vendas.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Laselva                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LOJP001(aParam)

Local nHdlLock	:= 0
//Local aParam	:= {"99","01"}
Local cArqLock 	:= "LSVIMPSF.lck"
Private _dMov	:= CTOD("  /  /  ")
Private _cFilD	:= Space(2)
Private _cFilA	:= Space(2)
Private _lJob	:= (aParam <> Nil .Or. ValType(aParam) == "A")

If _lJob
	
	Conout("Parametros recebidos => Empresa "+aParam[1]+" Filial "+aParam[2])

	//====================================================//
	//Efetua o Lock de gravacao da Rotina - Monousuario   //    
	//====================================================//
	
	FErase(cArqLock)
	nHdlLock := MsFCreate(cArqLock)
	If nHdlLock < 0
		Conout("Rotina "+FunName()+" ja em execu็ใo.")
		Return(.T.)
	EndIf

	If FindFunction('WFPREPENV')
 		Conout("Preparando Environment")
		WfPrepENV(aParam[1], aParam[2])
	Else
		Prepare Environment Empresa aParam[1]Filial aParam[2] Tables "SL1,SL5"
	EndIf	
	
	Conout("Iniciando LOJP001")
	Conout(Replicate("_",50))

	IntegraSL5()
	
	Conout("Finalizando LSVIMPSF")
	Conout(Replicate("_",50))

	Reset Environment
	
	//==========================================//
	// Cancela o Lock de gravacao da rotina     //
	//==========================================//
	
	FClose(nHdlLock)
	FErase(cArqLock)

Else
	
	AtuDados()      

EndIf	

Return    

Static Function AtuDados()

Local aSays		:= {}
Local aButtons	:= {}
Local nOpca		:= 0
Local cCadastro	:= "Importa registros SL5"
Private cPerg	:= Padr("LOJP01",len(SX1->X1_GRUPO)," ")
Pergunte(cPerg, .F.)

AADD(aSays,"Este programa tem o objetivo de alimentar a tabela")
AADD(aSays,"SL5 (Resumo de Vendas) que sera utilizada para efetuar")
AADD(aSays,"a contabilizacao das vendas do PDV")
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )
	
If nOpcA == 1
	If Pergunte(cPerg, .T.)                                         
		
		_dMov	:= MV_PAR01
		_cFilD	:= MV_PAR02
		_cFilA	:= MV_PAR03			
		
		LjMsgRun("Aguarde..., Processando registros...",, {|| IntegraSL5() }) 
		
	EndIf
EndIf
		
Return

Static Function IntegraSL5()  

Local aArea		:= GetArea()
Local _cFilAux	:= ""	
Local _cFilEr	:= "" 
Local aDados	:= {}     
Local lGrava	:= .T.
Local _nReg		:= 0 
Local nCupom	:= 0
Local nTotal	:= 0
Private dDataMovto	 

If _lJob
	dDataMovto	:= dDataBase-1	
Else
	dDataMovto	:= _dMov
EndIf

If Select("TMPA") > 0
	DbSelectArea("TMPA")
	DbCloseArea()
EndIf

cQryA := " SELECT L1_FILIAL "
cQryA += " FROM "+RetSqlName("SL1")+" SL1 (NOLOCK)"
cQryA += " WHERE "
cQryA += " L1_EMISSAO = '"+Dtos(dDataMovto)+"' AND "
cQryA += " L1_SITUA IN ('ER','RX') AND "
cQryA += " SL1.D_E_L_E_T_ = '' "
cQryA += " GROUP BY L1_FILIAL "
cQryA += " ORDER BY L1_FILIAL "
TcQuery cQryA NEW ALIAS "TMPA"

DbSelectArea("TMPA")
TMPA->( DbGoTop() )
If TMPA->( !Eof() )
	While TMPA->( !Eof() )
		_cFilAux += "'"+TMPA->L1_FILIAL+"'"+","
		TMPA->( DbSkip() )
	EndDo
EndIf
       
If !Empty(_cFilAux)
	_cFilEr := Substr(_cFilAux,1,Len(_cFilAux)-1)     
EndIf	

If Select("TMPB") > 0
	DbSelectArea("TMPB")
	DbCloseArea()
EndIf
	
cQryB := " SELECT L1_FILIAL, L1_DINHEIR , L1_OPERADO, L1_DINHEIR, L1_CHEQUES, L1_CARTAO, L1_CONVENI, L1_VALES, L1_FINANC, "
//cQryB += " L1_OUTROS , L1_VALICM , L1_VALIPI, L1_VALISS , (SELECT SUM(L2_DESCPRO) FROM SL2010 WHERE L2_FILIAL = L1_FILIAL AND L2_NUM = L1_NUM) AS DESCONTO, " 
cQryB += " L1_OUTROS , L1_VALICM , L1_VALIPI, L1_VALISS , L1_DESCONT AS DESCONTO, " 
cQryB += " L1_VLRLIQ, L1_CREDITO, L1_VLRDEBI,  " 
cQryB += " COALESCE((SELECT SUM(Z8_VALOR) FROM "+RetSqlName("SZ8")+" SZ8 (NOLOCK) "
cQryB += " WHERE Z8_FILIAL = L1_FILIAL AND Z8_DATA = '"+Dtos(dDataMovto)+"' AND SZ8.D_E_L_E_T_ = '' ),0) AS DEVOLUCAO "

cQryB += " FROM "+RetSqlName("SL1")+" SL1 (NOLOCK) "
cQryB += " WHERE "

If !_lJob
	cQryB += " L1_FILIAL BETWEEN '"+_cFilD+"' AND '"+_cFilA+"' AND "      	
EndIf

If !Empty(_cFilEr)
	cQryB += " L1_FILIAL NOT IN ("+_cFilEr+") AND "      
EndIf	

cQryB += " L1_EMISSAO = '"+Dtos(dDataMovto)+"' AND "
cQryB += " SL1.D_E_L_E_T_ = '' "
cQryB += " ORDER BY L1_FILIAL, L1_EMISSAO, L1_OPERADO "  
TcQuery cQryB NEW ALIAS "TMPB"

DbSelectArea("TMPB")
TMPB->( DbGoTop() )
If TMPB->( !Eof() )
	While TMPB->( !Eof() )
	
		Grava_Dados(@aDados, TMPB->L1_FILIAL, TMPB->L1_OPERADO, TMPB->L1_DINHEIR, TMPB->L1_CHEQUES, TMPB->L1_CARTAO, TMPB->L1_CONVENI,;
					TMPB->L1_VALES, TMPB->L1_FINANC, TMPB->L1_OUTROS , TMPB->L1_VALICM , TMPB->L1_VALIPI, TMPB->L1_VALISS,; 
  					TMPB->DESCONTO, TMPB->L1_VLRLIQ, TMPB->L1_CREDITO, TMPB->L1_VLRDEBI, TMPB->DEVOLUCAO)
			
		TMPB->( DbSkip() )
					
	EndDo
		
	DbSelectArea("SL5") 
	SL5->( DbSetOrder(1) )
	
	If Len(aDados) > 0

		For nI := 1 to Len(aDados)
	
			lGrava := SL5->( !DbSeek( aDados[nI,1] + DToS(dDataMovto) + aDados[nI,2] ) )
			
			RecLock("SL5",lGrava)	
			
			If Empty(SL5->L5_LA)
		
				_nReg++
				
				Replace L5_FILIAL  With aDados[nI,1]
				Replace L5_OPERADO With aDados[nI,2]
				Replace L5_DATA	   With dDataMovto
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
				Replace L5_DEVOLV  With aDados[nI, 17]
				
			EndIf	
			
			DbCommit()
			MsUnlock()
				
		Next _nI	
		
		If _nReg > 0
			
			If _lJob
				Conout("Processamento efetuado com sucesso!")		
			Else 
				MsgStop("Processamento efetuado com sucesso!")		
			EndIf			
			
		Else
		 	
		 	If _lJob
				Conout("Nao existem registros para processamento!")		
			Else 
				MsgStop("Nao existem registros para processamento!")		
			EndIf
		
		EndIf
		
	Else
		
		If _lJob
			Conout("Nao existem registros para processamento!")		
		Else 
			MsgStop("Nao existem registros para processamento!")		
		EndIf	
		
	EndIf

Else
		If _lJob
			Conout("Nao existem registros para processamento!")		
		Else 
			MsgStop("Nao existem registros para processamento!")		
		EndIf		
		
EndIf  

If !Empty(_cFilEr)
	
	If Select("TMPC") > 0
		DbSelectArea("TMPC")
		DbCloseArea()
	EndIf
	
	cQryA := " SELECT L1_FILIAL, L1_DOC, L1_SERIE, L1_EMISSAO, L1_VALMERC "
	cQryA += " FROM "+RetSqlName("SL1")+" SL1 (NOLOCK) "
	cQryA += " WHERE "
	cQryA += " L1_EMISSAO = '"+Dtos(dDataMovto)+"' AND "
	cQryA += " L1_SITUA IN ('ER','RX') AND "
	cQryA += " SL1.D_E_L_E_T_ = '' "
	cQryA += " ORDER BY L1_FILIAL, L1_NUM "
	TcQuery cQryA NEW ALIAS "TMPC"   
	
	DbSelectArea("TMPC") 
	TMPC->( DbGoTop() )
	If TMPC->( !Eof() )   
	
		MsgInfo("Existem pendencias em algumas filias, favor analisar e-mail!!!")

		While TMPC->( !Eof() )
	
			oProcess := TWFProcess():New( "LOJP001", "Resumo de Vendas" )
			oProcess:NewTask( "Importacao", "\WORKFLOW\HTML\LOJP001.HTM" )

			oProcess:cSubject	:= "Importacao Resumo de Vendas"	
			oHTML := oProcess:oHTML
				
			oHtml:ValByname("EMPRESA", "LASELVA")
			oHtml:ValByName( "MOVIMENTO", dDataMovto )
	
			While TMPC->( !Eof() )
	
				nCupom++
				nTotal += TMPC->L1_VALMERC
		
				Aadd( (oHtml:ValByName( "IT.FILIAL" )),TMPC->L1_FILIAL )
				Aadd( (oHtml:ValByName( "IT.DOCTO" )),TMPC->L1_DOC)
				Aadd( (oHtml:ValByName( "IT.SERIE" )),TMPC->L1_SERIE )
				Aadd( (oHtml:ValByName( "IT.TOTAL" )),TRANSFORM( TMPC->L1_VALMERC,'@E 999,999,999.99' ) )
			
				TMPC->( DbSkip() )
		
			EndDo
	
			oHtml:ValByName( "QTD" ,TRANSFORM( nCupom,'@E 999,999,999.99' ) )
			oHtml:ValByName( "LBTOTAL" ,TRANSFORM( nTotal,'@E 999,999,999.99') )
			
			oProcess:cTo := GetMv("MV_LOJP001")
			//oProcess:UserSiga := aUsrM[2]			
			oProcess:Start() 
			
		EndDo	
		
	EndIf   
	
EndIf	

RestArea(aArea)

Return     
							   								    		
Static Function Grava_Dados(aDados, cFil, cCaixa, nDinheiro , nCheques, nCartao, nConveni, nVales  , nFinanc,;
								    		nOutros   , nValICM , nValIPI, nValISS , nDescPro, nVlrLiq,;
											nCredito, nVlrDebi, nVlrDev)

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
	
Else

	aAdd(aDados, {	cFil, cCaixa, nDinheiro	, nCheques, nCartao , nConveni,;
								 nVales		, nFinanc , nOutros , nValICM ,;
								 nValIPI	, nValISS , nDescPro, nVlrLiq ,;
								 nCredito, nVLRDebi, nVlrDev} )
	
EndIf

Return .T.