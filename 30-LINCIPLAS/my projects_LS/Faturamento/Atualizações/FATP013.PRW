#INCLUDE "PROTHEUS.CH"   
#INCLUDE "topconn.ch"   
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATP013   บ Autor ณ Antonio Carlos     บ Data ณ  05/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina responsavel pela gera็ใo dos Pedidos de Venda ref.  บฑฑ
ฑฑบ          ณ Devolu็ใo Simbolica - Acerto Consigna็ใo Coligadas.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FATP013()

Local nOpca 		:= 0
Local aSays 		:= {}
Local aButtons  	:= {}
Private cCadastro	:= "Devolucao Simbolica - Coligadas"

Aadd(aSays,OemToAnsi( "Esta rotina tem com objetivo gerar os Pedidos de Venda referente" ) ) 
Aadd(aSays,OemToAnsi( "Devolucao Simbolica dos Acerto de Consigacao das Coligadas." ) )
Aadd(aSays,OemToAnsi( " " ) )

Aadd(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
Aadd(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca <> 1
	Return Nil
EndIf

Processa( {|lEnd| PAcerto()(@lEnd)}, "Aguarde...","Gerando Pedidos de Venda", .T. )

Return Nil

Static Function PAcerto(lEnd)

Local aArea		:= GetArea()   

Local nTotRec	:= 0
Local _nVlrUnit	:= 0 
Local _nVlrItem := 0
Local _nReg		:= 0 
Local _nCont	:= 0
Local _nQtdAux	:= 0
Local _nQtdPag	:= 0

Local _lFaz		:= .T.
	
Local nItePV	:= "0001"  
Local nItOri	:= "0001"
Local _cTes		:= "600" 
Local _cCond	
Local _cCf
Local cEstado

Local aLinha		:= {}   
Local _aCabPv		:= {}
Local _aItemTemp	:= {}  
Local _aItemPv		:= {}

Local _cUser		:= RetCodUsr()

Private _aPedidos	:= {}
Private _cNumPV 	:=  Space(6)

Private oDlgPC

If Select("TMP") > 0
	DbSelectArea("TMP")	
	DbCloseArea()
EndIf

cQry := " SELECT B6_DOC, B6_SERIE, B6_IDENT, B6_PRUNIT, B6_SALDO, B6_PRODUTO "
cQry += " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK)"
cQry += " WHERE "
cQry += " B6_FILIAL = '"+xFilial("SB6")+"' AND "
cQry += " B6_CLIFOR = '000001' AND " 
cQry += " B6_LOJA = '01' AND " 						
cQry += " B6_PODER3 = 'R' AND "
cQry += " B6_ATEND <> 'S' AND "
cQry += " B6_TPCF = 'F' AND "
cQry += " B6_SALDO > 0 AND "
cQry += " SB6.D_E_L_E_T_ = '' "
cQry += " ORDER BY B6_EMISSAO "			

TcQuery cQry NEW ALIAS "TMP" 

Count To nTotRec
ProcRegua(nTotRec)

DbSelectArea("TMP") 
TMP->( DbGoTop() )
If TMP->( !Eof() )
	
	While TMP->( !Eof() ) 
		
		IncProc("Processando...")
				
		If Empty(_cNumPV)
	    	
			_cNumPV := GetSxeNum("SC5","C5_NUM")
			While .T.
				DbSelectArea("SC5")
				DbSetOrder(1)
				If DbSeek(xFilial("SC5")+_cNumPV)
					RollBackSX8()
					_cNumPV := GetSxeNum("SC5","C5_NUM")
				Else
					ConfirmSX8()
					Exit
				EndIf
			EndDo
						
			DbSelectArea("SA2")
			SA2->( DbSetOrder(1) )
			DbSeek( xFilial("SA2")+"000001"+"01" ) 
			
			If !Empty( SA2->A2_COND )
				_cCond := SA2->A2_COND		
			Else
				_cCond := '002'
			EndIf
				
			_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
			{"C5_NUM"		,   _cNumPV				  		,Nil},;
			{"C5_TIPO"		,   'B'							,Nil},;
			{"C5_CLIENTE"	,	SA2->A2_COD					,Nil},;
			{"C5_LOJACLI"	,	SA2->A2_LOJA				,Nil},;
			{"C5_TIPOCLI"	,	"R"							,Nil},;
			{"C5_TRANSP"	,	"000001"					,Nil},;
			{"C5_TPFRETE"	,	'F'							,Nil},;
			{"C5_MOEDA"		,	1							,Nil},;
			{"C5_CONDPAG"	,	_cCond						,Nil},;
			{"C5_STATUS"	,	'01'						,Nil},;
			{"C5_EMISSAO"	,	dDataBase					,Nil},;
			{"C5_DATA"		,	dDataBase					,Nil},;
			{"C5_HORA"		,	Time()						,Nil},;
			{"C5_MOEDA"		,	1							,Nil},;						
			{"C5_TIPLIB"	,	'1'							,Nil},;
			{"C5_TXMOEDA"	,	1							,Nil},;
			{"C5_TPCARGA"	,	'2'							,Nil},;
			{"C5_VEND1"		,	"000001"					,Nil}}
			
	    	Aadd(_aPedidos,{_cNumPV})
	    
		EndIf
		
		cEstado := SA2->A2_EST
		
		_cCf := Posicione("SF4", 1,xFilial("SF4")+_cTes,"F4_CF")
		
		If SM0->M0_ESTENT <> cEstado
			_cCf := "6"+Substr(_cCf,2,3)			
		EndIf
		
		_nVlrUnit   := Round(TMP->B6_PRUNIT,4)
		_nVlrItem   := Round((_nVlrUnit * TMP->B6_SALDO),4)
		
		DbSelectArea("SB1")
		SB1->( DbSetOrder(1) )
		SB1->( DbSeek(xFilial("SB1")+TMP->B6_PRODUTO) )
				
		_aItemTemp := {{"C6_NUM"	,	_cNumPV				,Nil},;
		{"C6_FILIAL"	,	xFilial("SC6")					,Nil},;
		{"C6_ITEM"		,	nItePV							,Nil},;	
		{"C6_PRODUTO"	,	SB1->B1_COD						,Nil},;
		{"C6_DESCRI"	,	SB1->B1_DESC					,Nil},;	  
		{"C6_UM"		,	SB1->B1_UM						,Nil},;
		{"C6_QTDVEN"	,	TMP->B6_SALDO					,Nil},; 
		{"C6_PRUNIT"	,	_nVlrUnit						,Nil},;	
		{"C6_PRCVEN"	,	_nVlrUnit						,Nil},;
		{"C6_VALOR"		,	_nVlrItem						,Nil},;
		{"C6_TES"		,	_cTes							,Nil},;	
		{"C6_CF"		,	_cCf							,Nil},;
		{"C6_LOCAL"		,	SB1->B1_LOCPAD					,Nil},;	
		{"C6_CLASFIS"	,	SB1->B1_ORIGEM + Posicione("SF4", 1,xFilial("SF4")+_cTes,"F4_SITTRIB") ,Nil},;
		{"C6_CLI"		,	SA2->A2_COD		 				,Nil},;
		{"C6_ENTREG"	,	dDataBase						,Nil},;	
		{"C6_LOJA"		,	SA2->A2_LOJA					,Nil},;
		{"C6_OP"		,	'02'							,Nil},;
		{"C6_TPOP"		,	'F'								,Nil},;
		{"C6_SUGENTR"	,	dDataBase						,Nil},;
		{"C6_NFORI "	,	TMP->B6_DOC    					,Nil},;
		{"C6_SERIORI "	,	TMP->B6_SERIE   				,Nil},;
		{"C6_ITEMORI "	,	nItOri         					,Nil},;
	   	{"C6_IDENTB6 "	,	TMP->B6_IDENT		 			,Nil}}
	   			
		_nReg++ 
		_nCont++
		nItePV := Soma1(nItePV)
		nItOri := Soma1(nItOri)
		aAdd(_aItemPv,aClone(_aItemTemp))
										
		If _nReg == 99   
					
			Begin Transaction 
						
			//Grava o SC5
			DbSelectArea("SC5")
			Reclock("SC5",.T.)
			For ny := 1 to Len(_aCabPv)
				cVar := Trim(_aCabPv[ny][1])
				Replace &cVar. With _aCabPv[nY][2]
			Next ny
			SC5->( MsUnlock() )
				
			//Grava o SC6
			DbSelectArea("SC6")
			For nX:= 1 to Len(_aItemPv)
				Reclock("SC6",.T.)
							
				For nZ := 1 to Len(_aItemPv[nX])
					cVar := Trim(_aItemPv[nX][nZ][1])
					Replace &cVar. With _aItemPv[nX][nZ][2]
				Next nZ
				Replace C6_FILIAL With xFilial("SC6")
				
				SC6->( MsUnlock() )
						
			Next nX
					
			End Transaction
						
			_aCabPv		:= {}
			_aItemPv	:= {}
			_cNumPV		:= Space(6)
			_nReg		:= 0
			nItePV		:= "0001"	 
								
		EndIf
					
		TMP->( DbSkip() )
			
	EndDo	
	
	If _nReg > 0
					
		Begin Transaction 
						
		//Grava o SC5
		DbSelectArea("SC5")
		Reclock("SC5",.T.)
		For ny := 1 to Len(_aCabPv)
			cVar := Trim(_aCabPv[ny][1])
			Replace &cVar. With _aCabPv[nY][2]
		Next ny
		SC5->( MsUnlock() )
			
		//Grava o SC6
		DbSelectArea("SC6")
		For nX:= 1 to Len(_aItemPv)
			Reclock("SC6",.T.)
	
			For nZ := 1 to Len(_aItemPv[nX])
				cVar := Trim(_aItemPv[nX][nZ][1])
				Replace &cVar. With _aItemPv[nX][nZ][2]
			Next nZ
			Replace C6_FILIAL With xFilial("SC6")
						
			SC6->( MsUnlock() )
		Next nX
						
		End Transaction
						
		_aCabPv		:= {}
		_aItemPv	:= {}
		_cNumPV		:= Space(6)
		_nReg		:= 0
		nItePV		:= "0001"	 
	
	EndIf	
									
	If _nCont > 0    
	
		For _nI := 1 To Len(_aPedidos)
			U_LibPedAuto(_aPedidos[_nI,1])
		Next _nI
			                                                                                                
		DEFINE MSDIALOG oDlgPC FROM 000,000 TO 240,265 TITLE "Pedidos Venda" PIXEL
	
		@ 10,8 LISTBOX oLbx FIELDS HEADER "Pedido de Venda" SIZE 120,80 NOSCROLL OF oDlgPC PIXEL
			
		oLbx:SetArray(_aPedidos)
		oLbx:bLine:={|| {_aPedidos[oLbx:nAt,1]}}

		@ 100,050 BUTTON "Fechar"  SIZE 040,015 OF oDlgPC PIXEL ACTION(oDlgPC:End()) 
   	
		ACTIVATE MSDIALOG oDlgPC CENTERED
							
	Else
	   	
		MsgStop("Foram encontrados erros durante o processamnto!!!")	
   	
	EndIf	
	   	
Else
		Aviso("Acerto de Consignacao","Nao ha registros para processamento!",{"Ok"})			

EndIf

RestArea(aArea)
			
Return  