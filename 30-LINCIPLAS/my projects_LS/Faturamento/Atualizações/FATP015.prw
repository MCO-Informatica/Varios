#INCLUDE "Protheus.ch"   
#INCLUDE "topconn.ch"   
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATP015   º Autor ³ Antonio Carlos     º Data ³  05/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsavel pela geração dos Pedids de Vendas ref.  º±±
±±º          ³ Devolucao de Merc.Consignada para o Fornecedor.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATP015()

Local nOpca 	:= 0 
Local _cPFor	
Local _cPLoj	
Local aSays 	:= {}
Local aButtons  := {}

Private cCadastro	:= "Devolucao de Consignacao - Fornecedor"
Private cPerg		:= Padr("FAT015",len(SX1->X1_GRUPO)," ")
Pergunte(cPerg, .F.)

AADD(aSays,OemToAnsi( "Este programa tem como objetivo gerar Pedidos de Vendas") ) 
AADD(aSays,OemToAnsi( "referente devolução de consignação junto ao Fornecedor" ) )

AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca <> 1
	Return NIL
Else
	If Pergunte(cPerg, .T.)
		Processa( {|lEnd| PAcerto(@lEnd,MV_PAR01,MV_PAR02)}, "Aguarde...","Processando registros...", .T. )
	Endif
EndIf

Return Nil

Static Function PAcerto(lEnd,cFornece,cLoja)

Local aArea		:= GetArea()   
Local aAreaSC5	:= SC5->( GetArea() )
Local aAreaSC6	:= SC6->( GetArea() ) 
Local aAreaSC9	:= SC9->( GetArea() )

Local _nVlrUnit	:= 0 
Local _nVlrItem := 0
Local _nReg		:= 0 
Local _nCont	:= 0
Local _nQtdAux	:= 0
Local _nQtdPag	:= 0

Local _lFaz		:= .T.
	
Local nItePV	:= "0001"  
Local nItOri	:= "0001"
Local _cTes		:= "626" 

Local _aCabPv		:= {}
Local _aItemTemp	:= {}  
Local _aItemPv		:= {}

Local _cUser		:= RetCodUsr()

Private _aPedidos	:= {}
Private _cNumPV 	:=  Space(6)

Private oDlgPC

If Empty(cFornece) .Or. Empty(cLoja)
	MsgStop("Informe os parametros Fornecedor/Loja !!!")
	Return(.F.)
EndIf

cQry := " SELECT B6_DOC, B6_SERIE, B6_IDENT, B6_PRUNIT, B6_SALDO, B6_PRODUTO "
cQry += " FROM "+RetSqlName("SB6")+" SB6 (NOLOCK)"
cQry += " WHERE "
cQry += " B6_FILIAL = '"+xFilial("SB6")+"' AND "
cQry += " B6_CLIFOR = '"+cFornece+"' AND " 
cQry += " B6_LOJA = '"+cLoja+"' AND " 			
cQry += " B6_PODER3 = 'R' AND "
cQry += " B6_SALDO > 0 AND "
cQry += " B6_ATEND <> 'S' AND "
cQry += " B6_TPCF = 'F' AND "
cQry += " SB6.D_E_L_E_T_ = '' "
cQry += " ORDER BY B6_EMISSAO, B6_PRODUTO "			

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), "TMP", .F., .T.) 

Count To nTotRec
ProcRegua(nTotRec)

DbSelectArea("TMP") 
TMP->(DbGoTop())
If TMP->(!Eof())
	While !TMP->(Eof()) 
		
			IncProc("Processando...")
				
			If Empty(_cNumPV)
	    	
		    	_cNumPV := GetSxeNum("SC5","C5_NUM")
				While .T.
					DbSelectArea("SC5")
					DbSetOrder(1)
					If DbSeek(xFilial("SC5")+_cNumPV)
						ConfirmSX8()
						_cNumPV := GetSxeNum("SC5","C5_NUM")
						Loop
					Else
						Exit
					EndIf
				EndDo	
						
				DbSelectArea("SA2")
				SA2->( DbSetOrder(1) )
				DbSeek( xFilial("SA2")+cFornece+cLoja ) 
				
				_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
				{"C5_NUM"		,   _cNumPV				  		,Nil},;
				{"C5_TIPO"		,   'B'							,Nil},;
				{"C5_CLIENTE"	,	SA2->A2_COD					,Nil},;
				{"C5_LOJACLI"	,	SA2->A2_LOJA				,Nil},;
				{"C5_TIPOCLI"	,	"R"							,Nil},;
				{"C5_TRANSP"	,	"000001"					,Nil},;
				{"C5_TPFRETE"	,	'F'							,Nil},;
				{"C5_MOEDA"		,	1							,Nil},;
				{"C5_CONDPAG"	,	SA2->A2_COND				,Nil},;
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
			
			DbSelectArea("SB1")
			SB1->( DbSetOrder(1) )
			DbSeek( xFilial("SB1")+TMP->B6_PRODUTO )
		
			_nVlrUnit	:= Round(TMP->B6_PRUNIT,2)
			_nVlrItem   := Round((TMP->B6_SALDO * _nVlrUnit),2) 
					
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
			{"C6_CF"		,	Posicione("SF4", 1,xFilial("SF4")+_cTes,"F4_CF")		,Nil},;
			{"C6_LOCAL"		,	SB1->B1_LOCPAD											,Nil},;	
			{"C6_CLASFIS"	,	SB1->B1_ORIGEM + Posicione("SF4", 1,xFilial("SF4")+_cTes,"F4_SITTRIB") ,Nil},;
			{"C6_CLI"		,	SA2->A2_COD		 				,Nil},;
			{"C6_ENTREG"	,	dDataBase						,Nil},;	
		   	{"C6_LOJA"		,	SA2->A2_LOJA					,Nil},;
		   	{"C6_OP"		,	'02'							,Nil},;
		   	{"C6_TPOP"		,	'F'								,Nil},;
		   	{"C6_SUGENTR"	,	dDataBase						,Nil},;
			{"C6_NFORI "	,	TMP->B6_DOC    					,Nil},;
		   	{"C6_SERIORI "	,	TMP->B6_SERIE  					,Nil},;
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
				MsUnlock()
				
				//Grava o SC6
				DbSelectArea("SC6")
				For nX:= 1 to Len(_aItemPv)
					Reclock("SC6",.T.)
						For nZ := 1 to Len(_aItemPv[nX])
							cVar := Trim(_aItemPv[nX][nZ][1])
							Replace &cVar. With _aItemPv[nX][nZ][2]
						Next nZ
						Replace C6_FILIAL With xFilial("SC6")
							
					MsUnlock()
					DbCommit()
				Next nX
						
				End Transaction
						
				_aCabPv		:= {}
				_aItemPv	:= {}
				_cNumPV		:= Space(6)
				_nReg		:= 0
				nItePV		:= "0001"	 
								
			EndIf
						   		                                                                                                                  
			TMP->(DbSkip())
			
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
		MsUnlock()
				
		//Grava o SC6
		DbSelectArea("SC6")
		For nX:= 1 to Len(_aItemPv)
			Reclock("SC6",.T.)
			
			For nZ := 1 to Len(_aItemPv[nX])
				cVar := Trim(_aItemPv[nX][nZ][1])
				Replace &cVar. With _aItemPv[nX][nZ][2]
			Next nZ
			Replace C6_FILIAL With xFilial("SC6")
			
			MsUnlock()
			DbCommit()
		Next nX	 
		
		End Transaction 
		 	
		aCabPC		:= {}
		aItemPC		:= {}
		_aCabPv		:= {}
		_aItemPv	:= {}
		_cNumPV		:= Space(6)
		_cNumPC		:= Space(6)
		_nReg		:= 0
		nItePV		:= "0001"	 
		nItePC		:= "0001" 			
						
	EndIf     
	
	RestArea(aArea)
	RestArea(aAreaSC5)
	RestArea(aAreaSC6) 
	RestArea(aAreaSC9)
		
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
						   	
	EndIf	
	   	
Else

	Aviso("Devolucao de Consignacao","Nao ha registros para processamento!",{"Ok"})			

EndIf
	
DbSelectArea("TMP")
DbCloseArea()  
		
Return 