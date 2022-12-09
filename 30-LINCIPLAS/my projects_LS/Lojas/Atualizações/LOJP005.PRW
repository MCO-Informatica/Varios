#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOJP002   ºAutor  ³Antonio Carlos      º Data ³  05/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza gravação dos registros de vendas na tabela SL5      º±±
±±º          ³Resumo de Vendas.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOJP005()

Private cCadastro	:= "Refaz SL4 x PA4"

Private _cNumOrc	:= Space(6)

DEFINE MSDIALOG oDlg FROM 000,000 TO 200,400 TITLE cCadastro PIXEL
			
@ 010,050 SAY "Orcamento: " PIXEL OF oDlg
@ 010,090 MSGET oNumOrc VAR _cNumOrc SIZE 10,10 PIXEL OF oDlg

@ 060,060 	BUTTON "Processa"		SIZE 040,015 OF oDlg PIXEL ACTION(LjMsgRun("Aguarde..., Alterando registros...",, {|| AtuDados() }) ,oDlg:End()) 
@ 060,110 	BUTTON "Fechar"  		SIZE 040,015 OF oDlg PIXEL ACTION(oDlg:End()) 
  		
ACTIVATE MSDIALOG oDlg CENTERED
		
Return

Static Function AtuDados()

Local aArea		:= GetArea()

If Empty(_cNumOrc) 
	MsgStop("Informe os parametros corretamente!")
	Return(.F.)
EndIf

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQry := " SELECT L1_FILIAL, L1_NUM, L1_DOC, L1_SERIE, L1_PDV, L1_OPERADO "
cQry += " FROM "+RetSqlName("SL1")+" SL1 (NOLOCK)"
cQry += " WHERE "
cQry += " L1_FILIAL = '"+xFilial("SL1")+"' AND "
cQry += " L1_NUM = '"+_cNumOrc+"' AND "
cQry += " SL1.D_E_L_E_T_ = '' "
cQry += " ORDER BY L1_EMISSAO "
TcQuery cQry NEW ALIAS "TMP"

DbSelectArea("TMP")
TMP->( DbGoTop() )
If TMP->( !Eof() )
	
	While TMP->( !Eof() )
				
		DbSelectArea("SL4")
		SL4->( DbSetOrder(1) )
		If SL4->( DbSeek(xFilial("SL4")+TMP->L1_NUM) )
			While SL4->( !Eof() ) .And. SL4->L4_FILIAL == xFilial("SL4") .And. SL4->L4_NUM == TMP->L1_NUM
			
				RecLock("SL4",.F.)
				DbDelete()
				SL4->( MsUnLock() )
				
				SL4->( DbSkip() )
			
			EndDo	
				
		EndIf
		
		If Select("TMPA") > 0
			DbSelectArea("TMPA")
			DbCloseArea()
		EndIf
		
		cQryA := " SELECT * "
		cQryA += " FROM "+RetSqlName("PA4")+" PA4 (NOLOCK)"
		cQryA += " WHERE "
		cQryA += " PA4_FILIAL = '"+xFilial("SL1")+"' AND "
		cQryA += " PA4_NUMCFI = '"+TMP->L1_DOC+"' AND "
		cQryA += " PA4_PDV = '"+TMP->L1_PDV+"' AND "
		cQryA += " PA4.D_E_L_E_T_ = '' "                  
		
		TcQuery cQryA NEW ALIAS "TMPA"
		
		DbSelectArea("TMPA")
		TMPA->( DbGoTop() )
		If TMPA->( !Eof() )
		
			While TMPA->( !Eof() )
			
				DbSelectArea("SL4")
		
				RecLock("SL4",.T.)
									
				SL4->L4_FILIAL    	:= xFilial("SL4")
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
				SL4->L4_OPERADO	    := TMP->L1_OPERADO
				SL4->L4_NUM			:= TMP->L1_NUM
						
				SL4->(MsUnlock())     
				
				TMPA->( DbSkip() )
					
			EndDo	
		
		EndIf
		
		TMP->( DbSkip() )
		
	EndDo
	
	MsgInfo("Processamento realizado com sucesso!")
	
Else

	MsgStop("Nao existem registros para processamento!")	

EndIf

DbSelectArea("TMP")
DbCloseArea() 

DbSelectArea("TMPA")
DbCloseArea()

RestArea(aArea)
       
Return 