#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOJP003   ºAutor  ³Antonio Carlos      º Data ³  14/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processa alteração nos registros da tabela SL4 Forma de Pagaº±±
±±º          ³mento ref. vendas PDV, para correção de valores.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOJP003()

Local cCadastro	:= "Ajusta valores Recebimento"
Private _dMov1	:= CTOD("  /  /  ")
Private _dMov2	:= CTOD("  /  /  ")
		
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

Local aArea		:= GetArea()
Local _nDif1	:= 0 
Local _nDif2	:= 0 
Local nTotRec	:= 0
Local _nReg		:= 0

If Empty(_dMov1) .Or. Empty(_dMov2)
	MsgStop("Informe os parametros corretamente!")
	Return(.F.)
EndIf

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQry := " SELECT L4_FILIAL, L4_NUM, ROUND(SUM(L4_VALOR),2) AS VLR_SL4, L1_VALMERC AS VLR_SL1 "//, COUNT(*)
cQry += " FROM "+RetSqlName("SL4")+" SL4 (NOLOCK)"
cQry += " INNER JOIN "+RetSqlName("SL1")+" SL1 (NOLOCK)"
cQry += " ON L4_FILIAL = L1_FILIAL AND L4_NUM = L1_NUM AND SL1.D_E_L_E_T_ = ''"
cQry += " WHERE
cQry += " L4_FILIAL = '"+xFilial("SL4")+"' AND
cQry += " L1_EMISSAO BETWEEN '"+DTOS(_dMov1)+"' AND '"+DTOS(_dMov2)+"' AND
cQry += " SL4.D_E_L_E_T_ = ''
cQry += " GROUP BY L4_FILIAL, L4_NUM, L1_VALMERC
//cQry += " HAVING COUNT(*) > 0 AND ROUND(SUM(L4_VALOR),2) - L1_VALMERC >= 0.01
TcQuery cQry NEW ALIAS "TMP"

Count To nTotRec
ProcRegua(nTotRec)

DbSelectArea("TMP")
TMP->( DbGoTop() )
If TMP->( !Eof() )
	While TMP->( !Eof() )
	    
		IncProc("Processando...")
		
		_nDif1 := TMP->VLR_SL4 - TMP->VLR_SL1
		
		If _nDif1 >= 0.01 .And. _nDif1 <= 0.10
		   
			DbSelectArea("SL4")
			SL4->( DbSetOrder(1) ) 
			If SL4->( DbSeek(xFilial("SL4")+TMP->L4_NUM ) )
				RecLock("SL4",.F.)
				SL4->L4_VALOR := SL4->L4_VALOR - _nDif1	
				MsUnLock()
				_nReg++
			EndIf
			
		EndIf    
		
		_nDif2 := TMP->VLR_SL1 - TMP->VLR_SL4
		
		If _nDif2 >= 0.01 .And. _nDif2 <= 0.10
		   
			DbSelectArea("SL4")
			SL4->( DbSetOrder(1) ) 
			If SL4->( DbSeek(xFilial("SL4")+TMP->L4_NUM ) )
				RecLock("SL4",.F.)
				SL4->L4_VALOR := SL4->L4_VALOR + _nDif2	
				MsUnLock()
				_nReg++
			EndIf
			
		EndIf
		
		_nDif1 := 0
		_nDif2 := 0
		
		TMP->( DbSkip() )
					
	EndDo  
EndIf	

If _nReg > 0
	MsgInfo("Processamento efetuado com sucesso! "+Alltrim(Str(_nReg))+"   registros processados.")
Else 
	MsgStop("Nao existem registros para processamento!")	
EndIf	

DbSelectArea("TMP")
DbCloseArea() 

RestArea(aArea)
		
Return	