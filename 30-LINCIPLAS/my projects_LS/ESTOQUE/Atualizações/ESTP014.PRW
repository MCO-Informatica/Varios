#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"   
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*
+==============================================================+
|Programa: ESTP014 |Autor: Antonio Carlos |Data: 28/08/09      |
+==============================================================+
|Descrição: Rotina responsavel pela inclusão de ajsutes via    |
|TM (rotina automatica) com base em uma "View" disponibilizada |
|pela Laselva para processar as "Perdas" por encalhe.          |
+==============================================================+
|Uso: Laselva                                                  |
+==============================================================+
*/

User Function ESTP015()

Private oDlg
Private _nReg		:= 0
Private lMsErroAuto := .F.
Private _dData		:= CTOD("  /  /  ")
Private cCadastro	:= "Ajusta Estoque - Encalhe"

DEFINE MSDIALOG oDlg FROM 000,000 TO 220,400 TITLE cCadastro PIXEL

@ 05,05 TO 80,200 PIXEL			

@ 010,010 SAY "Esta rotina tem por objetivo incluir lancamentos de forma automatica     " PIXEL OF oDlg 
@ 020,010 SAY "referente perdas por motivo de encalhe.                                  " PIXEL OF oDlg                              

@ 050,050 SAY "Data : " PIXEL OF oDlg
@ 050,090 MSGET oData VAR _dData SIZE 15,10 PIXEL OF oDlg

@ 90,055 	BUTTON "Processa"		SIZE 040,015 OF oDlg PIXEL ACTION( LjMsgRun("Aguarde..., Processando ajustes...",, {|| AtuDados() }) ) 
@ 90,110 	BUTTON "Fechar"  		SIZE 040,015 OF oDlg PIXEL ACTION( oDlg:End() ) 
  		
ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function AtuDados()
	
Local aEmpFil  := {}
Local nHdlLock := 0
Local cArqLock := "estp014.lck"
Local aparam   := {"01","01"}
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa ambiente.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RpcSetType(3)
IF FindFunction('WFPREPENV')
	WfPrepEnv( aParam[1], aParam[2])
Else
	Prepare Environment Empresa aParam[1] Filial aParam[2]
EndIF
ChkFile("SM0")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona filiais.   						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SM0")
SM0->( DbSetOrder(1) )
SM0->( DbGoTop() )
While SM0->( !Eof() )

	If  SM0->M0_CODIGO == "01" 
		Aadd(aEmpFil,{SM0->M0_CODIGO,SM0->M0_CODFIL,Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)})	
	EndIf
	
	SM0->( DbSkip() )
	
EndDo
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha filial corrente.						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Reset Environment
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa rotinas por Empresa/filial.  			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 To Len(aEmpFil)
		
	RpcSetType(3)
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre a respectiva filial.            				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF FindFunction('WFPREPENV')
		WfPrepEnv( aEmpFil[nX,1], aEmpFil[nX,2])
	Else
		Prepare Environment Empresa aEmpFil[nX,1] Filial aEmpFil[nX,2]
	EndIF
	ChkFile("SM0")
		
	GeraMov()
		
	Reset Environment
Next

If _nReg > 0
	MsgInfo("Processamento realizado com sucesso! "+Alltrim(Str(_nReg))+" processados!")
	oDlg:End()
Else     
	MsgStop("Nao existem registros para processamento!")
	oDlg:End()	
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cancela o Lock de gravacao da rotina                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FClose(nHdlLock)
FErase(cArqLock)
	
Return(.T.)

Static Function GeraMov()

Local lAtualiza	:= .F.	
Local aTotitem	:= {}
Local aItens	:= {}
Local aVetor	:= {}

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQry := " SELECT * FROM  ARROMBA_ESTOQUE WHERE M0_CODFIL = '"+xFilial("SD3")+"' AND B1_ENCALHE <= '"+DTOS(_dData)+"' "
TcQuery cQry NEW ALIAS "TMP"

DbSelectArea("TMP")
TMP->( DbGoTop() )
If !TMP->( Eof() )
	
	While !TMP->( Eof() )		
		
		lMsErroAuto := .F.
			
		aVetor:={{"D3_TM",TMP->TM,NIL},;
		{"D3_COD",TMP->B1_COD,NIL},;
		{"D3_LOCAL","01",NIL},;
		{"D3_EMISSAO",STOD(TMP->B1_ENCALHE),NIL},;
		{"D3_QUANT",TMP->PERDA_GANHO,NIL},;
		{"D3_CUSTO1",TMP->CUSTO,NIL}}
		
		MSExecAuto({|x,y| mata240(x,y)},aVetor,3) //Inclusao
	
	    If lMsErroAuto 
	    	MostraErro()
	    Else            
	    	_nReg++
	    EndIf
	    
	    TMP->( DbSkip() )
	    
	EndDo	    
	
	cQry1 := " DELETE ARROMBA_ESTOQUE WHERE M0_CODFIL = '"+xFilial("SD3")+"' "
	TcSQLExec(cQry1) 
		
EndIf

Return

/*
	While !TMP->( Eof() )
	     
		//IncProc("Incluindo itens... ")                                                                      
	
		cTm 	:= Alltrim(TMP->TM)
		
		lAtualiza := .T.		
		
		aCab 	:= { {"D3_TM" ,Alltrim(TMP->TM),NIL},;
				{"D3_CC" ," " ,NIL},;
				{"D3_EMISSAO" ,_dData ,NIL}}
	
		DbSelectArea("SF5")
		SF5->( DbSetOrder(1) )
		If SF5->( DbSeek(xFilial("SF5")+Alltrim(TMP->TM)) )
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			If SB1->( DbSeek(xFilial("SB1")+Alltrim(TMP->B1_COD)) )
				Aadd(aItens, {"D3_COD"    	,Alltrim(TMP->B1_COD),NIL})                                            
				Aadd(aItens, {"D3_UM"    	,SB1->B1_UM    ,NIL})                                            
				Aadd(aItens, {"D3_QUANT"  	,TMP->PERDA_GANHO  ,NIL})
				Aadd(aItens, {"D3_LOCAL"  	,SB1->B1_LOCPAD,NIL})
	    		
		    	If SF5->F5_VAL = "S"
					Aadd(aItens, {"D3_CUSTO1"	,TMP->CUSTO ,NIL})
  				EndIf
  				
	  		Else	
				lAtualiza := .F.  			
  			EndIf	
  			
		Else
   			lAtualiza := .F.
		EndIf  

		Aadd(aTotitem,aItens)
		aItens:={}
		
		TMP->( DbSkip() )
	
	EndDo
	
	If lAtualiza
		MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aTotitem,3)
	EndIf

	If lMsErroAuto
		MostraErro()
	Else
		_nReg++	
	EndIf	
	*/