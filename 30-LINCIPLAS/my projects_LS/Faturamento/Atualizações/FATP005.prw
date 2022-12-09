#INCLUDE "PROTHEUS.CH"   

User Function FATP005()

/*
Local cCadastro    	:= "Acerto de Consignacao - Coligadas"  
Local aSays        	:= {}
Local aButtons     	:= {}
Local nOpc        	:= 0 
Local oDlg  
Private oProcess

AADD(aSays,OemToAnsi("Este programa tem o objetivo de processar automaticamente"))
AADD(aSays,OemToAnsi("o acerto da Laselva X Coligadas."))

AADD(aButtons, { 1,.T.,{|o| nOpc:= 1,If(MsgYesNo(OemToAnsi("Confirma processamento?"),OemToAnsi("Aten豫o")),o:oWnd:End(),nOpc:=0) } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons,,200,405 )
	
If nOpc == 1
	LjMsgRun("Aguarde..., Processando registros...",, {|| ProcFecha() }) 
EndIf

Return
*/   
  
Local oLbx
Local oOk	:= LoaDbitmap( GetResources(), "LBOK" )
Local oNo	:= LoaDbitmap( GetResources(), "LBNO" )

Local cCadastro := "Acerto Coligadas" 

Local lInvFil 		:= .F. 
Local lInvGrp 		:= .F.  


Local aFilial		:= {} 
Private _aPedidos	:= {}
Private cPath		:= "\CONSIGNACAO\01\"
Private aFiles 		:= Directory(cPath+"*.*")
Private lMsErroAuto	:= .F.    

For _nI := 1 To Len(aFiles)
	Aadd(aFilial,{.F.,aFiles[_nI][1]})
Next _nI   

If Len(aFiles) > 0

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 To 410,420 OF oMainWnd PIXEL

//Group Box de Filiais  
@ 30,10  TO 180,197 LABEL "Filiais" OF oDlg PIXEL 

@ 40,30  CHECKBOX oChkInvFil VAR lInvFil PROMPT "Inverter Selecao"  SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(aFilial , {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oLstFilial:Refresh(.F.)) //"Inverter Selecao"
@ 50,25  LISTBOX  oLstFilial VAR cVarFil Fields HEADER "","Arquivo" SIZE 160,110 ON DBLCLICK (aFilial:=LSVTroca(oLstFilial:nAt,aFilial),oLstFilial:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstFilial,oOk,oNo,@aFilial) OF oDlg PIXEL	//"Filial" / "Descricao"
oLstFilial:SetArray(aFilial)
oLstFilial:bLine := { || {If(aFilial[oLstFilial:nAt,1],oOk,oNo),aFilial[oLstFilial:nAt,2]}}   

DEFINE SBUTTON FROM 190,70 TYPE 1 ACTION(Processa({|lEnd| ProcAcerto(aFilial)},"Aguarde","Processando registros...",.T.))  ENABLE OF oDlg
DEFINE SBUTTON FROM 190,120 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg  

Else 
	MsgStop("Nao existem arquivos para processamento!")
	Return(.F.)
EndIf

ACTIVATE MSDIALOG oDlg CENTERED

Return   

Static Function LSVTroca(nIt,aArray)
	aArray[nIt,1] := !aArray[nIt,1]
Return aArray    

Static Function ProcAcerto(aVetor) 

Local _cTes		
Local _cNumPed	:= Space(6)
Local cLinha	:= "" 
Local nItens	:= "0001" 
Local _nReg		:= 0
Local _nQtde	:= 0
Local _nVlrUnit	:= 0
Local _nVlrItem	:= 0
Local _aPedidos	:= {}
Local _aCabPv	:= {}
Local _aItemTemp:= {}
Local _aItemPv	:= {}
Local _aArea	:= GetArea()

For I := 1 to Len(aVetor)
	
	If aVetor[I][1] == .T.
	
	FT_FUSE(cPath+aVetor[I][2])
	FT_FGotop()
	
	While ( !FT_FEof() )
		
		IncProc()
		
		cLinha  := FT_FREADLN()
		
		If Subs(cLinha,1,1)== "1"
			DbSelectArea("SA1")
			DbSetOrder(9)
			DbSeek(Subs(cLinha,2,14)+Subs(cLinha,16,2)) 
			
			cEstado := SA1->A1_EST
		EndIf
				
		If Empty(_cNumPed)
			
			_cNumPed := GetSxeNum("SC5","C5_NUM")
			While .T.
				DbSelectArea("SC5")
				DbSetOrder(1)
				If DbSeek(xFilial("SC5")+_cNumPed)
					ConfirmSX8()
					_cNumPed := GetSxeNum("SC5","C5_NUM")
					Loop
				Else
					Exit
				EndIf
			EndDo	
		
									
			_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
			{"C5_NUM"		,   _cNumPed					,Nil},;
			{"C5_TIPO"		,   'N'							,Nil},;
			{"C5_CLIENTE"	,	SA1->A1_COD					,Nil},;
			{"C5_LOJACLI"	,	SA1->A1_LOJA				,Nil},;
			{"C5_TIPOCLI"	,	SA1->A1_TIPO				,Nil},;
			{"C5_TRANSP"	,	SA1->A1_TRANSP				,Nil},;
			{"C5_TPFRETE"	,	'F'							,Nil},;
			{"C5_MOEDA"		,	1							,Nil},;
			{"C5_CONDPAG"	,	SA1->A1_COND				,Nil},;
			{"C5_STATUS"	,	'01'						,Nil},;
			{"C5_EMISSAO"	,	dDataBase					,Nil},;
			{"C5_DATA"		,	dDataBase					,Nil},;
			{"C5_HORA"		,	Time()						,Nil},;
			{"C5_VEND1"		,	"000001"					,Nil}} 
		
			Aadd(_aPedidos,{_cNumPed})		 
						
		EndIf
		
		If Subs(cLinha,1,1)== "2"			
		
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+Subs(cLinha,6,15))
			
			_nQtde		:= Round(Val(Subs(cLinha,21,14))/100,4)
			_nVlrUnit	:= Round(Val(Subs(cLinha,35,14))/100,4)
			_nVlrItem   := Round((_nQtde * _nVlrUnit),4)
			
			If SB1->B1_GRUPO $ GetMv("MV_GRPLIVR")
				_cTes := "607" 
			Else
				_cTes := "504" 
			EndIf          
			
			cCf	:= Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_CF")
		
			If SM0->M0_ESTENT <> cEstado
				cCf := "6"+Substr(cCf,2,3)			
			EndIf	
		
			_aItemTemp := {{"C6_NUM"	,	_cNumPed			,Nil},;
			{"C6_FILIAL"	,	xFilial("SC6")					,Nil},;
			{"C6_ITEM"		,	nItens							,Nil},;	
			{"C6_PRODUTO"	,	SB1->B1_COD						,Nil},;
			{"C6_DESCRI"	,	SB1->B1_DESC					,Nil},;	  
			{"C6_UM"		,	SB1->B1_UM						,Nil},;
			{"C6_QTDVEN"	,	_nQtde							,Nil},; 
			{"C6_QTDEMP"	,	_nQtde							,Nil},;	 
			{"C6_QTDLIB"	,	_nQtde							,Nil},;	 
	   		{"C6_PRUNIT"	,	_nVlrUnit						,Nil},;	
			{"C6_PRCVEN"	,	_nVlrUnit						,Nil},;
			{"C6_VALOR"		,	_nVlrItem						,Nil},;
			{"C6_TES"		,	_cTes							,Nil},;	
			{"C6_CF"		,	cCf								,Nil},;
			{"C6_LOCAL"		,	SB1->B1_LOCPAD					,Nil},;	
			{"C6_CLI"		,	SA1->A1_COD		 				,Nil},;
			{"C6_ENTREG"	,	dDataBase						,Nil},;	
		   	{"C6_LOJA"		,	SA1->A1_LOJA					,Nil}}
   	    
			aAdd(_aItemPv,aClone(_aItemTemp))        
			
			nItens := Soma1(nItens)
			_nReg++
		
		EndIf
				
		If Subs(cLinha,1,1) == "3" .Or. _nReg == 99
			
			MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,3)
			If lMsErroAuto
				MostraErro()
				If ( __lSX8)
					RollBackSX8()
				EndIf
				DisarmTransaction()
			Else		
				If ( __lSX8)
					ConfirmSX8()
				EndIf
			
				LibPedid(_cNumPed)
						
				_cNumPed	:= ""
				nItens 		:= "0001" 
				_nReg		:= 0
				_aCabPv		:= {}
				_aItemPv	:= {}	
			EndIf		
			
		EndIf
		
		FT_FSkip()
		
	EndDo  
	
	If _nReg > 0
		MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,3)
		If lMsErroAuto
			MostraErro()
			If ( __lSX8)
				RollBackSX8()
			EndIf
			DisarmTransaction()
		Else		
			If ( __lSX8)
				ConfirmSX8()
			EndIf
		
			LibPedid(_cNumPed)
					
			_cNumPed	:= ""
			nItens 		:= "0001" 
			_nReg		:= 0
			_aCabPv		:= {}
			_aItemPv	:= {}	
		EndIf 
	EndIf	
	
	FT_FUse()
	COPY File &("\CONSIGNACAO\"+aFiles[I][1]) TO &("\PROCESSADOS\"+aFiles[I][1])	
    FErase("\CONSIGNACAO\"+aFiles[I][1])
    
    EndIf
Next I 

Aviso("Acerto Coligadas","Processo efetuado com sucesso!",{"Ok"})	

DEFINE MSDIALOG oDlgPC FROM 000,000 TO 240,230 TITLE "Pedidos de Compra" PIXEL
			
@ 10,8 LISTBOX oLbx FIELDS HEADER "Nr. Pedido" SIZE 100,80 NOSCROLL OF oDlgPC PIXEL
oLbx:SetArray(_aPedidos)
oLbx:bLine:={|| {_aPedidos[oLbx:nAt,1]}}

@ 100,065 BUTTON "Fechar"  SIZE 040,015 OF oDlgPC PIXEL ACTION(oDlgPC:End()) 
 		
ACTIVATE MSDIALOG oDlgPC CENTERED			                                                                                  	

FT_FUse()

RestArea(_aArea)
             
Return   

Static Function LibPedid(cNumPed)

Local aArea		:= GetArea()
Local nX		:= 0
Local lLiberOk  := .T.
Local lCredito  := .T.
Local lEstoque  := .T.
Local lLiber    := .T.
Local lTransf   := .F.

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Posiciona no SC5 e SC6                                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
DbSelectArea("SC9")
DbSetOrder(1) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
If DbSeek(xFilial("SC9")+cNumPed)
	While SC9->(!Eof()) .and. SC9->C9_PEDIDO==cNumPed
		SC9->(a460Estorna(.T.))
		SC9->(dbskip())
	EndDo
EndIF

DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek(xFilial("SC5")+cNumPed)
	
	DbSelectArea("SC6")
	DbSetOrder(1)
	If  DbSeek(xFilial()+cNumPed)
		While SC6->(!Eof()) .and. SC6->C6_NUM==cNumPed
			MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,@lCredito,@lEstoque,.T.,.T.,lLiber,lTransf)
			a450Grava(1,.T.,.T.)
			SC6->(dbskip())
		EndDo
		
	EndIf
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿌tualiza do C5_LIBEROK e C5_STATUS                                      �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_LIBEROK := "S"
	MsUnlock()
	
EndIf

RestArea(aArea)

Return()

/*
Static Function ProcFecha() 

Local cLinha	 := "" 
Local _cTes		 := GetMv("MV_TESVCO")
Local _nReg		 := 0
Local _nQtde	 := 0
Local _nVlrUnit  := 0
Local _nVlrItem  := 0
Local _aCabPv    := {}
Local _aItemTemp := {}
Local _aItemPv   := {}
Local cPath      := IIf(SM0->M0_CODFIL == "81",GetMv("MV_LSVCONS")+"81\",GetMv("MV_LSVCONS")+"01\")
Local aFiles     := Directory(cPath+"*.*")
Private lMsErroAuto := .F.

For I := 1 to Len(aFiles)
	
	FT_FUSE(cPath+aFiles[I][1])
	FT_FGotop()
	
	While ( !FT_FEof() )
		cLinha  := FT_FREADLN()
		
		If Subs(cLinha,1,1)== "1"
			
			_cNumPed := GetSxeNum("SC5","C5_NUM")
			While .T.
				DbSelectArea("SC5")
				DbSetOrder(1)
				If DbSeek(xFilial("SC5")+_cNumPed)
					ConfirmSX8()
					_cNumPed := GetSxeNum("SC5","C5_NUM")
					Loop
				Else
					Exit
				EndIf
			EndDo	
			
			DbSelectArea("SA1")
			DbSetOrder(3)
			DbSeek(xFilial("SA1")+Subs(cLinha,2,14)) 
				
			dEmissao := CTOD(Subs(cLinha,16,2)+"/"+Subs(cLinha,19,2)+"/"+Subs(cLinha,22,2))
			
			_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
			{"C5_NUM"		,   _cNumPed					,Nil},;
			{"C5_TIPO"		,   "N"	  						,Nil},;
			{"C5_CLIENTE"	,	SA1->A1_COD					,Nil},;
			{"C5_LOJACLI"	,	SA1->A1_LOJA				,Nil},;
			{"C5_TIPOCLI"	,	"R"							,Nil},;
			{"C5_TRANSP"	,	SA1->A1_TRANSP				,Nil},;
			{"C5_TPFRETE"	,	'F'							,Nil},;
			{"C5_MOEDA"		,	1							,Nil},;
			{"C5_CONDPAG"	,	SA1->A1_COND				,Nil},;
			{"C5_EMISSAO"	,	dEmissao 	  	 			,Nil},;
			{"C5_DATA"		,	dEmissao	  	 			,Nil},;
			{"C5_HORA"		,	Time()		  				,Nil},;
			{"C5_VEND1"		,	"000001"					,Nil}}
			
		EndIf
		
		If Subs(cLinha,1,1)== "2"			
		
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+Subs(cLinha,4,15))
			
			_nQtde		:= Round(Val(Subs(cLinha,19,9))/100,2)
			_nVlrUnit	:= Round(Val(Subs(cLinha,28,11))/100,2)
			_nVlrItem   := Round((_nQtde * _nVlrUnit),2)
				
			_aItemTemp := {{"C6_NUM"	,	_cNumPed			,Nil},;
			{"C6_FILIAL"	,	xFilial("SC6")					,Nil},;
			{"C6_ITEM"		,	Subs(cLinha,2,2)				,Nil},;	
			{"C6_PRODUTO"	,	SB1->B1_COD						,Nil},;
			{"C6_DESCRI"	,	SB1->B1_DESC					,Nil},;	  
			{"C6_UM"		,	SB1->B1_UM						,Nil},;
			{"C6_QTDVEN"	,	_nQtde							,Nil},; 
			{"C6_QTDEMP"	,	_nQtde							,Nil},;	 
	   		{"C6_PRUNIT"	,	_nVlrUnit						,Nil},;	
			{"C6_PRCVEN"	,	_nVlrUnit						,Nil},;
			{"C6_VALOR"		,	_nVlrItem						,Nil},;
			{"C6_TES"		,	_cTes							,Nil},;	
			{"C6_CF"		,	Posicione("SF4", 1,xFilial("SF4")+_cTes,"F4_CF")		,Nil},;
			{"C6_LOCAL"		,	SB1->B1_LOCPAD											,Nil},;	
			{"C6_CLASFIS"	,	SB1->B1_ORIGEM + Posicione("SF4", 1,xFilial("SF4")+_cTes,"F4_SITTRIB") ,Nil},;
			{"C6_CLI"		,	SA1->A1_COD		 				,Nil},;
			{"C6_ENTREG"	,	dEmissao						,Nil},;	
		   	{"C6_LOJA"		,	SA1->A1_LOJA					,Nil}}
   	    
			aAdd(_aItemPv,aClone(_aItemTemp))
		
		EndIf
				
		If Subs(cLinha,1,1)== "3"
			
			MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,3)
			If lMsErroAuto
				MostraErro()
				If ( __lSX8)
					RollBackSX8()
				EndIf
				DisarmTransaction()
			Else		
				If ( __lSX8)
					ConfirmSX8()
				EndIf
			//U_LibPedid(_cNumPed)
			//U_FATP003(_cNumPed)
			
			_aCabPv		:= {}
			_aItemPv	:= {}	
			EndIf		
			
		EndIf
		
		FT_FSkip()
		
	EndDo   
	
	FT_FUse()
	COPY File &(cPath+aFiles[I][1]) TO &(cPath+"\Processados\"+aFiles[I][1])	
    FErase(cPath+aFiles[I][1])				
    
Next I

Aviso("FATP005","Acerto processado com sucesso!",{"Ok"})

FT_FUse()
             
Return               
*/