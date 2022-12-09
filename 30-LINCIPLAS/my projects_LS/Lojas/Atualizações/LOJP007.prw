#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOJP007   ºAutor  ³Antonio Carlos      º Data ³  03/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza gravação dos registros de vendas na tabela SL5      º±±
±±º          ³Resumo de Vendas.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOJP007()

Local cCadastro	:= "Refaz Formas de Pagamento - PA4 X SL4"

Private _nReg	:= 0
Private _dMov1	:= CTOD("  /  /  ")
Private _dMov2	:= CTOD("  /  /  ") 

DEFINE MSDIALOG oDlg FROM 000,000 TO 200,400 TITLE cCadastro PIXEL
			
@ 010,050 SAY "Data de : " PIXEL OF oDlg
@ 010,090 MSGET oDat1 VAR _dMov1 SIZE 15,10 PIXEL OF oDlg

@ 030,050 SAY "Data ate: " PIXEL OF oDlg
@ 030,090 MSGET oDat2 VAR _dMov2 SIZE 15,10 PIXEL OF oDlg

@ 070,055 	BUTTON "Processa"		SIZE 040,015 OF oDlg PIXEL ACTION(Processa( {|lEnd| AtuDados(@lEnd)}, "Aguarde...","Executando rotina.", .T. ) ,oDlg:End()) 
@ 070,110 	BUTTON "Fechar"  		SIZE 040,015 OF oDlg PIXEL ACTION(oDlg:End()) 
  		
ACTIVATE MSDIALOG oDlg CENTERED
		
Return

Static Function AtuDados(lEnd)

Local aArea		:= GetArea()

Local nTotRec1	:= 0
Local nTotRec2	:= 0

If Empty(_dMov1) .Or. Empty(_dMov2)
	MsgStop("Informe os parametros corretamente!")
	Return(.F.)
EndIf

/*
If Select("TMP1") > 0
	DbSelectArea("TMP1")
	DbCloseArea()
EndIf                  
*/

/*
cQry1 := " SELECT L4_FILIAL, L4_NUM "
cQry1 += " FROM "+RetSqlName("SL4")+" SL4 (NOLOCK)"
cQry1 += " INNER JOIN "+RetSqlName("SL1")+" SL1 (NOLOCK)"
cQry1 += " ON L4_FILIAL = L1_FILIAL AND L4_NUM = L1_NUM AND SL1.D_E_L_E_T_ = ''
cQry1 += " WHERE
cQry1 += " L4_FILIAL = '"+xFilial("SL4")+"' AND
cQry1 += " L1_EMISSAO BETWEEN  '"+DTOS(_dMov1)+"' AND '"+DTOS(_dMov2)+"' AND "
cQry1 += " SL4.D_E_L_E_T_ = ''
cQry1 += " ORDER BY L4_FILIAL, L4_NUM "
TcQuery cQry1 NEW ALIAS "TMP1"

Count To nTotRec1
ProcRegua(nTotRec1)

DbSelectArea("TMP1")
TMP1->( DbGoTop() )
If TMP1->( !Eof() )
	
	While TMP1->( !Eof() )
	
		IncProc("Excluindo registros...")
				
		DbSelectArea("SL4")
		SL4->( DbSetOrder(1) )
		If SL4->( DbSeek(xFilial("SL4")+TMP1->L4_NUM) )
			
			While SL4->( !Eof() ) .And. SL4->L4_FILIAL == xFilial("SL4") .And. SL4->L4_NUM == TMP1->L4_NUM
			
				RecLock("SL4",.F.)
				DbDelete()
				SL4->( MsUnLock() )
				
				SL4->( DbSkip() )
			
			EndDo	
				
		EndIf 
		
		TMP1->( DbSkip() ) 

	EndDo		
	*/

	If Select("TMP") > 0
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf

	cQry2 := " SELECT PA4_DATA, PA4_PDV, PA4_NUMCFI, PA4_FORMA, PA4_ADMINI, PA4_VALOR, PA4_TROCO, PA4_CONTA, PA4_NUMCAR, PA4_AGENCI, PA4_CGC, PA4_ADMINI, L1_NUM, L1_OPERADO "
	cQry2 += " FROM "+RetSqlName("PA4")+" PA4 (NOLOCK)"
	cQry2 += " INNER JOIN "+RetSqlName("SL1")+" SL1 (NOLOCK)"
	cQry2 += " ON PA4_FILIAL = L1_FILIAL AND PA4_NUMCFI = L1_DOC AND PA4_PDV = L1_PDV AND SL1.D_E_L_E_T_ = '' "
	cQry2 += " WHERE "
	cQry2 += " PA4_FILIAL = '"+xFilial("PA4")+"' AND
	cQry2 += " PA4_DATA BETWEEN  '"+DTOS(_dMov1)+"' AND '"+DTOS(_dMov2)+"' AND "
	cQry2 += " PA4.D_E_L_E_T_ = '' "
	cQry2 += " ORDER BY PA4_FILIAL, PA4_NUMCFI, PA4_PDV "
	TcQuery cQry2 NEW ALIAS "TMP"  
	
	Count To nTotRec2
	ProcRegua(nTotRec2)
	
	DbSelectArea("TMP")	
	TMP->( DbGoTop() )
	If TMP->( !Eof() )
	
		While TMP->( !Eof() )
		
			IncProc("Gravando registros...")
		
			DbSelectArea("SL4")
			SL4->( DbSetOrder(1) )
			If !SL4->( DbSeek(xFilial("SL4")+TMP->L1_NUM) )
			
				RecLock("SL4",.T.)
										
				SL4->L4_FILIAL    	:= xFilial("SL4")
				SL4->L4_DATA  		:= STOD(TMP->PA4_DATA)
				SL4->L4_PDV	    	:= TMP->PA4_PDV
				SL4->L4_NUMCFIS  	:= TMP->PA4_NUMCFI
				SL4->L4_FORMA		:= TMP->PA4_FORMA
				SL4->L4_ADMINIS 	:= TMP->PA4_ADMINI
				SL4->L4_VALOR 		:= TMP->PA4_VALOR
				SL4->L4_TROCO 		:= TMP->PA4_TROCO
				SL4->L4_CONTA 		:= TMP->PA4_CONTA
				SL4->L4_NUMCART 	:= TMP->PA4_NUMCAR
				SL4->L4_AGENCIA 	:= TMP->PA4_AGENCI
				SL4->L4_CGC 		:= TMP->PA4_CGC
				SL4->L4_INSTITU		:= Posicione("SAE",1,xFilial("SAE")+TMP->PA4_ADMINI,"AE_DESC")
				SL4->L4_OPERADO	    := TMP->L1_OPERADO
				SL4->L4_NUM			:= TMP->L1_NUM
							
				SL4->(MsUnlock())     
				
			EndIf	
				
		
	 	   TMP->( DbSkip() )
		
		EndDo 
		
		MsgInfo("Processamento efetuado com sucesso!")
		
	Else	

		MsgStop("Nao existem registros para processamento!")
		
	EndIf	
		
	
RestArea(aArea)
       
Return 