#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOJP006   ºAutor  ³Antonio Carlos      º Data ³  23/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Refaz os registros da SL4 de acordo com a PA4.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOJP006()

Local cCadastro	:= "Importa registros SL5"

Private _nReg	:= 0
Private _dMov1	:= CTOD("  /  /  ")
Private _dMov2	:= CTOD("  /  /  ") 

Private _aDados	:= {}
		
DEFINE MSDIALOG oDlg FROM 000,000 TO 200,400 TITLE cCadastro PIXEL
			
@ 010,050 SAY "Data de : " PIXEL OF oDlg
@ 010,090 MSGET oDat1 VAR _dMov1 SIZE 15,10 PIXEL OF oDlg

@ 030,050 SAY "Data ate: " PIXEL OF oDlg
@ 030,090 MSGET oDat2 VAR _dMov2 SIZE 15,10 PIXEL OF oDlg

@ 070,055 	BUTTON "Processa"		SIZE 040,015 OF oDlg PIXEL ACTION(LjMsgRun("Aguarde..., Processando registros...",, {|| AtuDados() }) ,oDlg:End()) 
@ 070,110 	BUTTON "Fechar"  		SIZE 040,015 OF oDlg PIXEL ACTION(oDlg:End()) 
  		
ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function AtuDados()

cQry := " SELECT PA4_FILIAL, PA4_DATA, PA4_PDV, PA4_NUMCFI, PA4_OPERAD, COUNT(*) AS CONTAS "
cQry += " FROM "+RetSqlName("PA4")+" PA4 WITH(NOLOCK) "
cQry += " WHERE " 
cQry += " PA4_FILIAL = '"+xFilial("PA4")+"' AND "
cQry += " PA4_DATA BETWEEN '"+DTos(_dMov1)+"' AND '"+DTos(_dMov2)+"' AND PA4_NUMCFI = '070575' AND "
cQry += " PA4.D_E_L_E_T_ = '' "
cQry += " GROUP BY PA4_FILIAL, PA4_DATA, PA4_PDV, PA4_NUMCFI, PA4_OPERAD "
cQry += " HAVING COUNT(*) >= 2 "
cQry += " ORDER BY PA4_DATA "
TcQuery cQry NEW ALIAS "TMPPA4"

DbSelectArea("TMPPA4")
TMPPA4->( DbGoTop() )
If TMPPA4->( !Eof() )
	
	While TMPPA4->( !Eof() ) 
    	
    	DbSelectArea("PA4")
    	PA4->( DbSetOrder(2) ) 
    	If DbSeek( xFilial("PA4")+TMPPA4->PA4_DATA+TMPPA4->PA4_OPERAD+TMPPA4->PA4_PDV+TMPPA4->PA4_NUMCFI )
    	
    		_aDados := {}
    		
    		While PA4->( !Eof() ) .And. TMPPA4->PA4_DATA+TMPPA4->PA4_OPERAD+TMPPA4->PA4_PDV+TMPPA4->PA4_NUMCFI == DTOS(PA4->PA4_DATA)+PA4->PA4_OPERAD+PA4->PA4_PDV+PA4->PA4_NUMCFI	                      
  		
  		 		Aadd(_aDados,{PA4->PA4_NUMCFI,PA4->PA4_PDV,PA4_FORMA})
  		 		PA4->( DbSkip() )
  		
  	   		EndDo
  	   		
  	   		AltDados()
    	
    	EndIf
  
  		TMPPA4->( DbSkip() )
  			          
	EndDo 
 
	MsgInfo("Processamento efetuado com sucesso!")

Else
    
	MsgStop("Nao existem registros para processamento!")
	
EndIf	

DbSelectArea("TMPPA4")
DbCloseArea()

Return

Static Function AltDados()

Local aArea	:= GetArea()
Local nPos	:= 0

nPos := aScan(_aDados, {|x| Alltrim(x[3]) $ "E$/U$"})

If nPos > 0

	cQry1 := " SELECT * "
	cQry1 += " FROM "+RetSqlName("SL1")+" SL1 WITH(NOLOCK) "
	cQry1 += " WHERE " 
	cQry1 += " L1_FILIAL = '"+xFilial("SL1")+"' AND "
	cQry1 += " L1_DOC = '"+_aDados[1,1]+"' AND "
	cQry1 += " L1_PDV = '"+_aDados[1,2]+"' AND "
	cQry1 += " SL1.D_E_L_E_T_ = '' "
	TcQuery cQry1 NEW ALIAS "TMPSL1"	
	
	DbSelectArea("TMPSL1")
	TMPSL1->( DbGoTop() )
	If TMPSL1->( !Eof() )
	
		_cNumOrc	:= TMPSL1->L1_NUM 
		_cOperad	:= TMPSL1->L1_OPERADO 	
		
		While TMPSL1->( !Eof() )
		
		    DbSelectArea("SL4")
		    SL4->( DbSetOrder(1) ) 
		    If SL4->( DbSeek(xFilial("SL4")+_cNumOrc) ) 
		    
		    	While SL4->( !Eof() ) .And. SL4->L4_FILIAL == xFilial("SL4") .And. SL4->L4_NUM == _cNumOrc
		    	
		    		RecLock("SL4",.F.)
		    		DbDelete()
		    		SL4->(MsUnlock())  
		    		
		    		SL4->( DbSkip() )
		    	
		    	EndDo
		    
		    EndIf
		     
			TMPSL1->( DbSkip() )	
		
		EndDo 
		
		cQry2 := " SELECT * "
		cQry2 += " FROM "+RetSqlName("PA4")+" PA4 (NOLOCK)"
		cQry2 += " WHERE "
		cQry2 += " PA4_FILIAL = '"+xFilial("PA4")+"' AND "
		cQry2 += " PA4_NUMCFI = '"+_aDados[1,1]+"' AND "
		cQry2 += " PA4_PDV = '"+_aDados[1,2]+"' AND "
		cQry2 += " PA4.D_E_L_E_T_ = '' "
		TcQuery cQry2 NEW ALIAS "TMPA"
		
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
				SL4->L4_OPERADO	    := _cOperad
				SL4->L4_NUM			:= _cNumOrc
						
				SL4->(MsUnlock())     
				
				TMPA->( DbSkip() )
					
			EndDo	
		
		EndIf
		
	EndIf
	
EndIf

If Select("TMPSL1") > 0
	DbSelectArea("TMPSL1")
	DbCloseArea()
EndIf	

If Select("TMPA") > 0
	DbSelectArea("TMPA")
	DbCloseArea()
EndIf	

RestArea(aArea)

Return