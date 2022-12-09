#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXXX       บAutor  ณMarcio Dias         บ Data ณ  19/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclui botao na tela de resultados para associac. de certif.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico HCI - Sera chamado via QIEA215 (aResultados)     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function QE215ROT()

// Ponto de Entrada para Incluir Botoes no aRotina

Return({{"Certificados"		,"U_CERFOR()" , 0 , 5}})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCERFOR    บAutor  ณMarcio Dias         บ Data ณ  19/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclui certificado do fornecedor para o lote selecionado.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico HCI - Sera chamado via QIEA215 (aResultados)     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CERFOR()

//Variaveis Locais da Funcao

// Defina aqui os Botoes da sua EnchoiceBar
// Exemplo: Aadd(aButtons,{"USER", {|| Alert("Inclua a Acao")}, "Contatos"})     

Local aButtons	:= {} 
Local lConfirma := .f. 
Local n			:= 0


// Variaveis Private da Funcao
Private _oDlg			// Dialog Principal
Private INCLUI := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao
// Privates das NewGetDados
Private oGet1

Private cProduto	:= QEK->QEK_PRODUT
Private cRevi		:= QEK->QEK_REVI
Private cLote		:= QEK->QEK_LOTE 
Private cFornec		:= QEK->QEK_FORNEC 
Private cLoja		:= QEK->QEK_LOJFOR    
     
QE6->(DbSetOrder(1))
If QE6->(DbSeek(xFilial("QE6") + QEK->QEK_PRODUT + Inverte(QEK->QEK_REVI)))
	If QE6->QE6_XVALV <> "S"
		MsgAlert("Certificado disponํvel somente para vแlvulas")
		Return .t.
	Endif
Endif

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Associacao de Certificados") FROM C(178),C(181) TO C(645),C(763) PIXEL

	// Cria Componentes Padroes do Sistema
	@ C(014),C(005) Say "Produto: "+AllTrim(cProduto)+" Rev: "+AllTrim(cRevi)+" Lote: "+AllTrim(cLote) Size C(284),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

	// Chamadas das GetDados do Sistema
	CERFORGET()

ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {|| lConfirma := .t.,_oDlg:End() },{||_oDlg:End()},,aButtons)
                                                                             
If lConfirma
	
	DbSelectArea("QZ1")
	DbSetOrder(1)			// Produto + Revisao + Lote + Fornecedor + Loja + Peca
	DbGoTop()
	
	For n:= 1 to Len(oGet1:aCols)
		
		If !QZ1->(DbSeek(xFilial("QZ1")+cProduto+cRevi+cLote+cFornec+cLoja+oGet1:aCols[n][1]+oGet1:aCols[n][3]))
			RecLock("QZ1",.T.)
        Else
        	RecLock("QZ1",.F.)
        EndIf
        
        If oGet1:aCols[n][5] != .F.
        	QZ1->(DbDelete())
        EndIf
         
        QZ1->QZ1_FILIAL	:= xFilial("QZ1")
		QZ1->QZ1_XPROD	:= cProduto
		QZ1->QZ1_XREV	:= cRevi
		QZ1->QZ1_XLOTE	:= cLote
		QZ1->QZ1_XFORN	:= cFornec
		QZ1->QZ1_XLOJA	:= cLoja
		QZ1->QZ1_XPECA	:= oGet1:aCols[n][1]		// PECA
		QZ1->QZ1_XCORRI	:= oGet1:aCols[n][3]		// CORRIDA
		QZ1->QZ1_XCERT	:= oGet1:aCols[n][4]		// CERTIFICADO
		QZ1->(MsUnlock())
	
	Next
Endif

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCERFORGET    บAutor  ณMarcio Dias      บ Data ณ  19/07/06   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGet dados da tela de inclusao de certificados (CERFOR)      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico HCI - Sera chamado via CERFOR()                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CERFORGET()          

// Variaveis deste Form                                                                                                         
Local nX			:= 0                                                                                                              
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da MsNewGetDados()      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Vetor responsavel pela montagem da aHead
Local aCpoGDa       	:= {"QZ1_XPECA","QZ1_XDESCO","QZ1_XCORRI","QZ1_XCERT"}                                                                                                 
// Vetor com os campos que poderao ser alterados                                                                                
Local aAlter       	:= {"QZ1_XPECA","QZ1_XCORRI","QZ1_XCERT"}
Local nSuperior    	:= C(022)           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= C(004)           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior    	:= C(229)           // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= C(290)           // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
Local cLinhaOk     	:= "U_ValLinha()"    			// Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= ""    			// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                         // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                         // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "" // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

// Objeto no qual a MsNewGetDados sera criada                                      
Local oWnd         	:= _oDlg                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHead                    
Local aCol         	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols     

DbSelectArea("QZ1")           // TESTE
                                                                                                                                
// Carrega aHead                                                                                                                
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
For nX := 1 to Len(aCpoGDa)                                                                                                     
	If SX3->(DbSeek(aCpoGDa[nX]))                                                                                                 
		Aadd(aHead,{ AllTrim(X3Titulo()),;                                                                                         
			SX3->X3_CAMPO	,;                                                                                                       
			SX3->X3_PICTURE,;                                                                                                       
			SX3->X3_TAMANHO,;                                                                                                       
			SX3->X3_DECIMAL,;                                                                                                       
			SX3->X3_VALID	,;                                                                                                       
			SX3->X3_USADO	,;                                                                                                       
			SX3->X3_TIPO	,;                                                                                                       
			SX3->X3_F3 		,;                                                                                                       
			SX3->X3_CONTEXT,;                                                                                                       
			SX3->X3_CBOX	,;                                                                                                       
			SX3->X3_RELACAO})                                                                                                       
	Endif                                                                                                                         
Next nX                                                                                                                         

If QZ1->(DbSeek(xFilial("QZ1")+cProduto+cRevi+cLote+cFornec+cLoja))
	While QZ1->QZ1_XPROD == cProduto .AND. QZ1->QZ1_XREV == cRevi .AND. QZ1->QZ1_XLOTE == cLote .AND. QZ1->QZ1_XFORN == cFornec .AND. QZ1->QZ1_XLOJA == cLoja
		aAdd(aCol,{QZ1->QZ1_XPECA,Posicione("SB1",1,xFilial("SB1")+QZ1->QZ1_XPECA,"B1_DESC"),QZ1->QZ1_XCORRI,QZ1->QZ1_XCERT,.F.})
		QZ1->(DbSkip())
	EndDo
Else
	aAux := {}                                                                                                                      
	For nX := 1 to Len(aCpoGDa)                                                                                                     
		If DbSeek(aCpoGDa[nX])                                                                                                        
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
		Endif                                                                                                                         
	Next nX                                                                                                                         
	Aadd(aAux,.F.)                                                                                                                  
	Aadd(aCol,aAux)                                                                                                                 
EndIf

oGet1 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,cTudoOk,cIniCpos,;                               
                             aAlter,,,,cSuperApagar,cApagaOk,oWnd,aHead,aCol)                                   
Return Nil                                                                                                                      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()      ณ Autor ณ Norbert Waage Junior  ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolu็ใo horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor      
Do Case                                                                         
	Case nHRes == 640	//Resolucao 640x480                                         
		nTam *= 0.8                                                                
	Case nHRes == 800	//Resolucao 800x600                                         
		nTam *= 1                                                                  
	OtherWise			//Resolucao 1024x768 e acima                                
		nTam *= 1.28                                                               
EndCase                                                                         
If "MP8" $ oApp:cVersion                                                        
  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                               
  //ณTratamento para tema "Flat"ณ                                               
  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               
  If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                          
       	nTam *= 0.90                                                            
  EndIf                                                                         
EndIf                                                                           
Return Int(nTam) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValLinha  บAutor  ณMarcio Dias         บ Data ณ  07/20/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida linha da aCols do Get1 para obrigar o preenchimento  บฑฑ
ฑฑบ          ณdos campos                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico HCI			                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

                                    
User Function ValLinha()
Local lOk		:= .T.  
Local i			:= 0       

If Empty(oGet1:aCols[n][1]) .OR. Empty(oGet1:aCols[n][3]) .OR. Empty(oGet1:aCols[n][4]) 
	Alert("Existem campos obrigat๓rios nใo preenchidos. Verifique!")
	lOk := .F. 
EndIf     

For i:= 1 to Len(aCols)
	If i != n
		If aCols[i][1] == aCols[n][1]
			If aCols[i][3] == aCols[n][3]
				Alert("Corrida da pe็a jแ cadastrada para este lote")
				lOk := .F.
			EndIf
		EndIf
	EndIf
Next i

Return lOk

