#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH" 
#INCLUDE "Rwmake.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA120BUT  บAutor  ณROBSON BUENO        บ Data ณ  13/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada na Ordem de Compra (PC) para agregar       บฑฑ
ฑฑบ          ณobservacoes especificas do negocio HCI (VIA CONTRATO)       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA120BUT()             
STATIC _oDlg        
Local	cEnvUsuario := GetEnvServer()
Local   aUsuBut:= {}                 	

IF cPaisLoc == "BRA"
  //	Aadd(aUsuBut, {"PARAMETROS",{|| u_ATUACOM()}, OemToAnsi("Importar") }) 
	Aadd(aUsuBut, {"PARAMETROS",{|| u_MA120B1()}, OemToAnsi("O.Compra") })
	Aadd(aUsuBut, {"PARAMETROS",{|| u_MA120B6()}, OemToAnsi("PServ.OC.") })
	Aadd(aUsuBut, {"PARAMETROS",{|| u_MA120B3()}, OemToAnsi("OC x PV") }) 
	Aadd(aUsuBut, {"PARAMETROS",{|| u_MA120B4()}, OemToAnsi("F.CUSTO") })
	Aadd(aUsuBut, {"PARAMETROS",{|| u_MA120B5()}, OemToAnsi("TECNICO") }) 
  Aadd(aUsuBut, {"PARAMETROS",{|| u_MA120B7()}, OemToAnsi("N.Prazo") })   
ELSE  
//	Aadd(aUsuBut, {"PARAMETROS",{|| u_ATUACOM()}, OemToAnsi("Importar") })                                                                      
	Aadd(aUsuBut, {"PARAMETROS",{|| u_MA120B1()}, OemToAnsi("O.Compra") })
	Aadd(aUsuBut, {"PARAMETROS",{|| u_MA120B3()}, OemToAnsi("OC x PV") }) 
	Aadd(aUsuBut, {"PARAMETROS",{|| u_MA120B4()}, OemToAnsi("F.CUSTO") })
ENDIF	
Return(aUsuBut)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA120B1   บAutor  ณRobson Bueno        บ Data ณ  13/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAmarrar Observacao na OC                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA120B1(cAlias, nRecno, nOpc)
Local aArea		:= GetArea()
Local lConfirma := .f.
			
Private INCLUI := .F.	
Private oGet1 
Private cCodForn :=""
Private cLoja    :="" 
Private cDesForn :=""
Private cOc      :=""     
PRIVATE aColsAnt := aClone(Acols)
PRIVATE aHeaderAnt := aClone(aHeader)
PRIVATE nElemAnt := n


DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Observacoes para OC") FROM C(178),C(181) TO C(645),C(763) PIXEL
cOc:=cA120Num
dbselectarea("SC7") 
SC7->(DbSetOrder(1))
if SC7->(DbSeek(xFilial("SC7")+cOc))
  cOc:=SC7->C7_NUM   
endif
cCodForn:=SC7->C7_FORNECE
cLoja   :=SC7->C7_LOJA
DbSelectArea("SA2")
SA2->(DbSetOrder(1))
if SA2->(DbSeek(xFilial("SA2")+cCodForn))
   cDesForn:=SA2->A2_NOME
endif 
/*
DbSelectArea("SC7")
SC7->(DbSetOrder(1))
*/
@ C(014),C(005) Say "OC.: " + cOc + " - " + "Cod. Forn/Loja/Des. Forn --> " + cCodForn + "/" + cLoja + "/" + cDesForn Size C(284),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

GetDocs()

ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {|| If(oGet1:TudoOk(), (lConfirma := .t.,_oDlg:End()), nil) },{||_oDlg:End()},,)
                                                                                 
If lConfirma
	
	SZB->(DbSetOrder(1))
	For n:= 1 to Len(oGet1:aColS)
		           
		// Linha Deletada
        If oGet1:aColS[n][3] 
	        If SZB->(DbSeek(xFilial("SZB")+ cOc + oGet1:aColS[n][1]))
	        	RecLock("SZB",.F.)
		       	SZB->(DbDelete())
				SZB->(MsUnlock())
	        EndIf
		// Linha Normal
		Else
	        If !SZB->(DbSeek(xFilial("SZB")+ cOc +  oGet1:aColS[n][1]))
				RecLock("SZB",.T.)
	        Else
	        	RecLock("SZB",.F.)
	        EndIf
        
			SZB->ZB_FILIAL	:= xFilial("SZB")
			SZB->ZB_XOC		:= cOc  
			SZB->ZB_XCOD	:= oGet1:aColS[n][1]
			SZB->ZB_XDESCR	:= oGet1:aColS[n][2]		// Codigo Documento
			SZB->(MsUnlock())
		Endif
	Next
Endif
RestArea(aArea)
aCols := aClone(aColsAnt)
aHeader := aClone(aHeaderAnt)
n := nElemAnt
Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณGetDocs()   ณ Autor ณ Robson Bueno          ณ Data ณ13/02/07  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Montagem da GetDados - Observacoes                           ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetDocs()
Local nX			:= 0                                                                                                              
Local aCpoGDa      	:= {"ZB_XCOD","ZB_XDESCR"}                                                                                                 
Local aAlter       	:= {"ZB_XCOD","ZB_XDESCR"}
Local nSuperior    	:= C(022)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(229)           
Local nDireita     	:= C(290)           

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "U_TudoObs()"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                        // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                        // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

Local oWnd         	:= _oDlg                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aColAR       	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      
                                                                                                                                
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

// Carrega aCol                                                                                         
                                                                                                          
If SZB->(DbSeek(xFilial("SZB")+SC7->C7_NUM))
	While xFilial("SZB") == SZB->ZB_FILIAL .and. ! SZB->(Eof()) .and. SZB->ZB_XOC == SC7->C7_NUM  
		aAdd(aColAR,{SZB->ZB_XCOD, SZB->ZB_XDESCR,.F.})
		SZB->(DbSkip())
	EndDo 
                                                                                                
Else
    aAux := {}
    For nX := 1 to Len(aCpoGDa)                                                                                                     
		If DbSeek(aCpoGDa[nX])                                                                                                        
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
		Endif                                                                                                                         
	Next nX                                                                                                                         
    Aadd(aAux,.F.)
    Aadd(aColAR,aAux)                                                                                                            
Endif
                                                                    
oGet1 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,{|| U_TudoObs()},cIniCpos,;                               
                             aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aColAR)                                   
Return Nil                                                                                                                      
     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTudoObs   บAutor  ณRobson Bueno        บ Data ณ  13/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTudoOk de Observacoes                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TudoObs()

Local nConta 	:= 1
Local nConta1	:= 1
    
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                               
//ณVarre acols verificando existe Observacoes estao duplicados ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               
For nConta := 1 To Len(oGet1:aColS)
	For nConta1 := 1 To Len(oGet1:aColS)
		If nConta <> nConta1
			If oGet1:aColS[nConta,1] == oGet1:aColS[nConta1,1]
				MsgInfo("Observacao " + oGet1:aColS[nConta,1] + " duplicada. Verifique")
				Return .f.
			Endif
		Endif
	Next nConta1
Next nConta

Return .t.






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA120B3   บAutor  ณRobson Bueno        บ Data ณ  13/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAmarrar Oc a PV                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA120B3(cAlias, nRecno, nOpc)
Local aArea		:= GetArea()
Local lConfirma := .f.
Static cRegistro
sTATIC oBold
Static nSdep :=0 
Static cC7Tpc:="OC"		// TIPO2 
Static cC7Num			// NUMERO OC
Static cC7Item			// ITEM Oc
Static cC7Nfor			// FORNECEDOR
Static nC7Qtd 			// QUANTIDADE CASADA
Static dC7Prz			// PRAZO ENTRADA
Static cCod				// Codigo do Produto da OC
Private INCLUI := .F.	
Private oGet2 
Private cCodForn:=""
Private cLoja   :="" 
Private cDesForn:=""
Private cOc     :=""     
PRIvATE cItemOc := acols[n,1]
PRIVATE aColsAnt1:= aClone(Acols)
PRIVATE aHeaderAnt1:= aClone(aHeader)
PRIVATE nElemAnt1:= n
DEFINE FONT oBold NAME "MS Sans Serif" SIZE 0, -9 BOLD
DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Processos Amarrados ao Item da Compra") FROM C(178),C(181) TO C(645),C(763) PIXEL
cOc:=cA120Num
dbselectarea("SC7") 
SC7->(DbSetOrder(1))
if SC7->(DbSeek(xFilial("SC7")+cOc+cItemOc))
  cOc:=SC7->C7_NUM   
endif
cCodForn:=SC7->C7_FORNECE
cLoja   :=SC7->C7_LOJA
DbSelectArea("SA2")
SA2->(DbSetOrder(1))
if SA2->(DbSeek(xFilial("SA2")+cCodForn+cLoja))
   cDesForn:=SA2->A2_NOME
endif 
// CARREGANDO DADOS DA OC PARA POSSIVEL GRAVACAO DE AMARRACAO DE OC COM PV
cC7Num	:=cOc
cC7Item	:=cItemOc
cC7Nfor	:=SA2->A2_NREDUZ
nC7Qtd 	:=SC7->C7_QUANT-SC7->C7_QUJE
dC7Prz	:=SC7->C7_DATPRF
cCod	:=SC7->C7_PRODUTO
/*
DbSelectArea("SC7") aColsAnt1[nElemAnt1,1]
SC7->(DbSetOrder(1))
*/
@ C(014),C(005) Say "OC.  : " + cOc + " - " + "Fornecedor : " + cCodForn + "-" + cLoja + "-" + cDesForn Size C(284),C(008) FONT oBold COLOR CLR_BLACK PIXEL OF _oDlg
@ C(024),C(005) Say "Item.: " + SC7->C7_ITEM + " - " + "Codigo: " + SC7->C7_PRODUTO + " - Descr: " + SC7->C7_DESCRI + " - SALDO: " + STR(SC7->C7_QUANT-SC7->C7_QUJE) + " - Prazo: "+ SUBSTR(DTOS(SC7->C7_DATPRF),7,2)+"/"+SUBSTR(DTOS(SC7->C7_DATPRF),5,2)+"/"+SUBSTR(DTOS(SC7->C7_DATPRF),1,4) Size C(284),C(008) COLOR CLR_BLUE PIXEL OF _oDlg

nSdep:=SC7->C7_QUANT-SC7->C7_QUJE

GetDoc2()

@ C(221),C(165) Say "Saldo a Empenhar: " + STR(nSdep) Size C(284),C(008) FONT oBold COLOR CLR_RED PIXEL OF _oDlg

//ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {||_oDlg:End()},{||_oDlg:End()},,)
ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {|| (lConfirma := .t.,_oDlg:End())},{||_oDlg:End()},,)                                                                                 
If lConfirma
   FOR nLin:=1 to len(oGet2:acols)
     IF oGet2:ACOLS[nLin,10]="MAN" .OR. oGet2:ACOLS[nLin,7]>0 
       dbSelectArea("SZK")
       DbSetOrder(4) // ZK_FILIAL+ZK_TIPO2+ZK_OC+ZK_ITEM+ZK_TIPO+ZK_REF+ZK_REFITEM                                                                                                      
       IF MsSeek(xFilial("SZK")+"OC"+cC7num+substr(cC7Item,2,3)+"PV"+oGet2:ACOLS[nLin,2]+oGet2:ACOLS[nLin,3])
         Reclock("SZK",.F.)
       ELSE
         Reclock("SZK",.T.)
         SZK->ZK_DT_VINC:=date()          				// DATA DA VINCULACAO
       ENDIF
       SZK->ZK_FILIAL :=xfilial("SZK") 
       SZK->ZK_TIPO   :="PV"                        	// TIPO 
       SZK->ZK_REF    :=oGet2:ACOLS[nLin,2]           	// PEDIDO
       SZK->ZK_REFITEM:=oGet2:ACOLS[nLin,3]           	// ITEM PEDIDO
       SZK->ZK_NOME   :=oGet2:ACOLS[nLin,4]           	// CLIENTE
       SZK->ZK_COD    :=oGet2:ACOLS[nLin,9]            // CODIGO PRODUTO
       SZK->ZK_DESCRI :=oGet2:ACOLS[nLin,10]           // DESCRICAO
       SZK->ZK_QTD    :=oGet2:ACOLS[nLin,5]            // QUANTIDADE VENDA
       SZK->ZK_PRAZO  :=oGet2:ACOLS[nLin,6] 	        // PRAZO VENDA
       SZK->ZK_TIPO2  :="OC"            	           	// TIPO2 
       SZK->ZK_OC     :=cC7num			             	// NUMERO OS
       SZK->ZK_ITEM   :=substr(cC7Item,2,3)           	// ITEM OS
       SZK->ZK_FORN   :=cC7Nfor   			         	// FORNECEDOR
       SZK->ZK_QTC    :=oGet2:ACOLS[nLin,7]  	        // QUANTIDADE CASADA
       SZK->ZK_PRAZOC :=dC7Prz			             	// PRAZO ENTRADA
       IF oGet2:ACOLS[nLin,8]=0
         SZK->ZK_QTS    :=0                      	    // QUANTIDADE PENDENTE
         SZK->ZK_DT_BX  :=DATE()
         SZK->ZK_STATUS :="4"							// STATUS DA OS
       ELSE
         SZK->ZK_QTS    :=oGet2:ACOLS[nLin,8]         	// QUANTIDADE PENDENTE
         SZK->ZK_STATUS :="1"
       ENDIF
       SZK->ZK_CONTROL:="MAN"							// METODO
       MsUnLock()
       
     ENDIF
     // TRATA CONTROLE DE PROCESSO
     dbselectarea("PC2")
     dbSetOrder(4)
     MsSeek(xfilial("PC2")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2)+"000005")
     if PC2->PC2_QTDORI-PC2->PC2_QTD>0 .and. PC2->PC2_NUM=SZK->ZK_REF .AND. SUBSTRING(SZK->ZK_REFITEM,1,2)=PC2->PC2_ITEM .AND. PC2->PC2_SEQ="000005"
       cRegistro:=PC2->PC2_CTR
       // 1 BAIXA SOLICITACAO DE COMPRA E POR EM ORDEM DE COMPRA 
       U_HCICTPR(SZK->ZK_REF,SUBSTRING(SZK->ZK_REFITEM,1,2),"000005","000007",SZK->ZK_QTC,"Aguardando Amarracao","","","Ok Disposto Comprar",cRegistro) 
       MsSeek(xfilial("PC2")+SZK->ZK_REF+SUBSTRING(SZK->ZK_REFITEM,1,2)+"000007")
       cRegistro:=PC2->PC2_CTR
       // 2 BAIXA ORDEM DE COMPRA E POE EM AGUARDANDO RECEBIMENTO
       U_HCICTPR(SZK->ZK_REF,SUBSTRING(SZK->ZK_REFITEM,1,2),"000007","000010",SZK->ZK_QTC,"Aguardando Recebimento","","","OC:"+cC7num+" - "+cC7Item+" - "+cC7Nfor,cRegistro,SZK->ZK_PRAZO) 
     endif
     // FIM DE TRATAMENTO 
     dbSelectArea("SZK")
   next
ENDIF
RestArea(aArea)
aCols := aClone(aColsAnt1)
aHeader := aClone(aHeaderAnt1)
n := nElemAnt1
Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณGetDocs1()  ณ Autor ณ Robson Bueno          ณ Data ณ13/02/07  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Montagem da GetDados - Compras Casadas                       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetDoc2()
Local nX			:= 0                                                                                                              
Local aCpoGDa      	:= {"ZK_TIPO","ZK_REF","ZK_REFITEM","ZK_NOME","ZK_QTD","ZK_PRAZO","ZK_QTC","ZK_QTS", "ZK_COD","ZK_DESCRI","ZK_CONTROL"}                                                                                                
Local aAlter       	:= {"ZK_TIPO","ZK_REF","ZK_REFITEM","ZK_NOME","ZK_QTD","ZK_PRAZO","ZK_QTC","ZK_QTS", "ZK_COD","ZK_DESCRI","ZK_CONTROL"} 
Local nSuperior    	:= C(034)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(219)           
Local nDireita     	:= C(290)           

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_UPDATE                                                                          
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "U_TdObs1()"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                        // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                        // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

Local oWnd         	:= _oDlg                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aCola       	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      
                                                                                                                                
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
	ENDIF                                                                                                                         
Next nX                                                                                                                         
// Carrega aCol                                                                                         
DbSelectArea("SZK")                                                                                                             
SZK->(DbSetOrder(4)) // Campo                                                                                                   
if SZK->(DbSeek(xFilial("SZK")+"OC" + SC7->C7_NUM + SUBSTR(aCols[n,1],2,3)))
	While xFilial("SZK") == SZK->ZK_FILIAL .and. ! SZK->(Eof()) .and. SZK->ZK_OC == SC7->C7_NUM  .AND. SUBSTR(aCols[n,1],2,3)==SZK->ZK_ITEM
		aAdd(aCola,{SZK->ZK_TIPO,SZK->ZK_REF,SZK->ZK_REFITEM,SZK->ZK_NOME,SZK->ZK_QTD,SZK->ZK_PRAZO,SZK->ZK_QTC,SZK->ZK_QTS,ZK_COD,ZK_DESCRI,ZK_CONTROL,.F.})
		nSdep:=nSdep-SZK->ZK_QTS
		SZK->(DbSkip())
	EndDo 
                                                                                                
Else
    aAux := {}
    DbSelectArea("SX3")                                                                                                             
    SX3->(DbSetOrder(2)) // Campo  
    For nX := 1 to Len(aCpoGDa)                                                                                                     
		If DbSeek(aCpoGDa[nX])                                                                                                        
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
		Endif                                                                                                                         
	Next nX                                                                                                                         
    Aadd(aAux,.F.)
    Aadd(aColA,aAux)                                                                                                            
Endif
                                                                    
oGet2 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,NOPC,cLinhaOk,{|| U_TdObs1()},cIniCpos,;                               
                             aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aColA)                                   
Return Nil                                                                                                                      
     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTudoObs   บAutor  ณRobson Bueno        บ Data ณ  13/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTudoOk de Observacoes                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TdObs1()

Local nConta 	:= 1
Local nConta1	:= 1
    


Return .t.




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


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณMA120A1   ณ Autor ณ ROBSON BUENO          ณ Data ณ02.10.07  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณALIMENTA CAMPOS CONFORME PARAMETROS INFORMADOS              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณExpL1: Sempre .T.                                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณNenhuma                                                     ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao Efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MA120A1()
  LOCAL lRet:=.T.
  Local aArea     := GetArea()  
  LOCAL cVar
  Local nPVS:=0
  IF FunName()=="MATA121"
    dbSelectArea("SZK")
    DbSetOrder(1)
    MsSeek(xFilial("SZK")+"PV"+ACOLS[N,2]+ACOLS[N,3])
    While (!Eof() .And. ACOLS[N,2]==SZK->ZK_REF .And. ACOLS[N,3]==SZK->ZK_REFITEM)
      nPVS:=nPVS+SZK->ZK_QTC
      dbSkip()
    ENDDO
    cVar:="PV"
    DbSelectArea("SC5")
    DbSetOrder(1)
    MsSeek(xFilial("SC5")+ACOLS[N,2])
    DbSelectArea("SC6")
    DbSetOrder(1)
    MsSeek(xFilial("SC6")+ACOLS[N,2]+SUBSTR(ACOLS[N,3],1,2))
	iF (!Eof())
	  IF nPVS>=SC6->C6_QTDVEN
	    MsgInfo("Pedido N." + ACOLS[N,2] +"/"+ ACOLS[N,3] + ". Ja esta amarrado na sua totalidade")
	    lRet:=.F.
	  ENDIF  
	ENDIF
	iF (!Eof()) .AND. LRET=.T.
	  FOR nA:=1 to len(acols)-1
	    if acols[n,2]=acols[nA,2] .and. acols[n,3]=acols[nA,3]
	       lret:=.F.
	    else
	    ENDIF  
	  next
	  IF LRET=.F.
	    MsgInfo("Pedido N." + ACOLS[N,2] +"/"+ ACOLS[N,3] + ". Ja esta amarrado com este processo")
	  endif
	  if cCod==SC6->C6_PRODUTO .and. lret=.T.
		  ACOLS[N,4]:=SC5->C5_XNREDUZ
		  ACOLS[N,5]:=SC6->C6_QTDVEN-SC6->C6_QTDENT
		  ACOLS[N,6]:=SC6->C6_ENTREG
          ACOLS[N,7]:=SC6->C6_QTDVEN-SC6->C6_QTDENT
          ACOLS[N,8]:=SC6->C6_QTDVEN-SC6->C6_QTDENT          
          ACOLS[N,9]:= SC6->C6_PRODUTO
		  ACOLS[N,10]:=SC6->C6_DESCRI
          @ C(221),C(165) Say "Saldo a Empenhar: " + STR(nSdep) Size C(284),C(008) FONT oBold COLOR CLR_WHITE PIXEL OF _oDlg
          _oDlg:REFRESH()
          nSdep:=SC7->C7_QUANT-SC7->C7_QUJE
          FOR nA:=1 to len(acols)-1
	        nSdep:=nSdep-SZK->ZK_QTS
	      next
          nSdep:=nSdep-(SC6->C6_QTDVEN-SC6->C6_QTDENT)
          IF nSdep<0 
             MsgInfo("Atencao. O saldo nao atende toda a venda, sera empenhado "  + str(SC6->C6_QTDVEN-SC6->C6_QTDENT+nSdep) +" Pcs")
             ACOLS[N,5]:=SC6->C6_QTDVEN-SC6->C6_QTDENT+nSdep
             ACOLS[N,7]:=SC6->C6_QTDVEN-SC6->C6_QTDENT+nSdep
             ACOLS[N,8]:=SC6->C6_QTDVEN-SC6->C6_QTDENT+nSdep          
             nSdep:=0
          endif
          @ C(221),C(165) Say "Saldo a Empenhar: " + STR(nSdep) Size C(284),C(008) FONT oBold COLOR CLR_RED PIXEL OF _oDlg
          _oDlg:REFRESH()
          IF ACOLS[N,5]=0 
            MsgInfo("Pedido/OS N." + ACOLS[N,2] +"/"+ ACOLS[N,3] + " nao tem saldo")
            lRet:=.F.
          ENDIF
      ELSE 
          MsgInfo("Pedido/OS N." + ACOLS[N,2] +"/"+ ACOLS[N,3] + ". Tem codigo diferente da compra")
          lret=.f.
      endif  
    ENDIF
    
    RestArea(aArea)
  ENDIF
RETURN (LRET) 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณMA120A2   ณ Autor ณ ROBSON BUENO          ณ Data ณ02.10.07  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณVerifica se pode casar ou nao com pv na sc7                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณExpL1: Sempre .T.                                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณNenhuma                                                     ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao Efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MA120C7(cPedido,cItem)

	LOCAL lRet:=.T.
 	Local aArea     := GetArea()  
  	LOCAL cVar
  	Local nPVS:=0
  	dbSelectArea("SZK")
  	DbSetOrder(1)
  	MsSeek(xFilial("SZK")+"PV"+cPedido+cItem)
  	While (!Eof() .And. cPedido==SZK->ZK_REF .And. cItem==SZK->ZK_REFITEM)
  	  nPVS:=nPVS+SZK->ZK_QTC
      dbSkip()
  	ENDDO
  	DbSelectArea("SC5")
  	DbSetOrder(1)
  	MsSeek(xFilial("SC5")+cPedido)
  	DbSelectArea("SC6")
  	DbSetOrder(1)
  	MsSeek(xFilial("SC6")+cPedido+SUBSTR(cItem,1,2))
  	if (!Eof())
  	  IF nPVS>=SC6->C6_QTDVEN
  	    MsgInfo("Pedido N." + ACOLS[N,2] +"/"+ ACOLS[N,3] + ". Ja esta amarrado na sua totalidade")
  	    lRet:=.F.
  	  ENDIF  
  	ENDIF
  	RestArea(aArea)
RETURN (LRET) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA120B4   บAutor  ณROBSON BUENO        บ Data ณ  24/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInsersao devalores para nacionalizacao de Imp               บฑฑ
ฑฑบ          ณortacoes de materiais  (ajuste p/ atender Cons Rapida       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA120B4()

Local oDlgl
Local nFator :=0

@ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("Fator de Nacionalizacao")
@ 003,008 To 85,200 Title OemToAnsi("Digite o Fator  de Nacionalizacao da OC")

@ 015,015 Say OemToAnsi("Fator:") OF Odlgl PIXEL
@ 015,045 msget nFator Picture "@e 999,999.99" SIZE 60,10 OF Odlgl PIXEL

@ 055,030 BMPBUTTON TYPE 1 ACTION OkProc(odlg1,nFator)
@ 055,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)

Activate Dialog Odlg1 CENTER
 
   
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOkProc    บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento no banco de dados da acao solicitada e confir บฑฑ
ฑฑบ          ณmada                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OkProc(odlg1,nFator)
Local cAliasSCP := GetArea()
Local aArea     := (GetArea())
Local cRef      :=cA120Num
dbSelectArea("SC7")
DbSetOrder(1)
MsSeek(xFilial("SC7")+cRef)
do while (!Eof() .And. cRef==SC7->C7_NUM)
  Reclock("SC7",.F.)
  SC7->C7_DESIMPO:=nFator 
  MsUnLock()
  dbSkip()
enddo
Close(Odlg1)
RestArea(cAliasSCP)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Finaliza(Odlg1)

Close(Odlg1)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOkProc    บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento no banco de dados da acao solicitada e confir บฑฑ
ฑฑบ          ณmada                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA120B5()
Local cAliasSCP := GetArea()
Local aArea     := (GetArea())
Local cRef      :=cA120Num
dbSelectArea("SC7")
DbSetOrder(1)
MsSeek(xFilial("SC7")+cRef)
do while (!Eof() .And. cRef==SC7->C7_NUM)
  Reclock("SC7",.F.)
  SC7->C7_TECNICO:=U_MATATEC(SC7->C7_PRODUTO)                                                                             
  MsUnLock()
  dbSkip()
enddo
RestArea(cAliasSCP)
Return
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA120B6   บAutor  ณRobson Bueno        บ Data ณ  13/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAmarrar Produtos envolvidos no servico                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA120B6(cAlias, nRecno, nOpc)
Local aArea		:= GetArea()
Local lConfirma := .f.
sTATIC oBold
Static nSdep :=0 
Static cC7Tpc:="OC"		// TIPO2 
Static cC7Num			// NUMERO OC
Static cC7Item			// ITEM Oc
Static cC7Nfor			// FORNECEDOR
Static nC7Qtd 			// QUANTIDADE CASADA
Static dC7Prz			// PRAZO ENTRADA
Static cCod				// Codigo do Produto da OC
Private INCLUI := .F.	
Private oGet3 
Private cCodForn:=""
Private cLoja   :="" 
Private cDesForn:=""
Private cOc     :=""     
PRIvATE cItemOc := acols[n,1]
PRIVATE aColsAnt2:= aClone(Acols)
PRIVATE aHeaderAnt2:= aClone(aHeader)
PRIVATE nElemAnt2:= n
DEFINE FONT oBold NAME "MS Sans Serif" SIZE 0, -9 BOLD
DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Produtos Amarrados ao Item da Compra") FROM C(178),C(181) TO C(645),C(763) PIXEL
cOc:=cA120Num
dbselectarea("SC7") 
SC7->(DbSetOrder(1))
if SC7->(DbSeek(xFilial("SC7")+cOc+cItemOc))
  cOc:=SC7->C7_NUM   
endif
cCodForn:=SC7->C7_FORNECE
cLoja   :=SC7->C7_LOJA
DbSelectArea("SA2")
SA2->(DbSetOrder(1))
if SA2->(DbSeek(xFilial("SA2")+cCodForn))
   cDesForn:=SA2->A2_NOME
endif 
// CARREGANDO DADOS DA OC PARA POSSIVEL GRAVACAO DE AMARRACAO DE OC COM PV
cC7Num	:=cOc
cC7Item	:=cItemOc
cC7Nfor	:=SA2->A2_NREDUZ
nC7Qtd 	:=SC7->C7_QUANT-SC7->C7_QUJE
dC7Prz	:=SC7->C7_DATPRF
cCod	:=SC7->C7_PRODUTO
/*
DbSelectArea("SC7") aColsAnt1[nElemAnt1,1]
SC7->(DbSetOrder(1))
*/
@ C(014),C(005) Say "OC.  : " + cOc + " - " + "Fornecedor : " + cCodForn + "-" + cLoja + "-" + cDesForn Size C(284),C(008) FONT oBold COLOR CLR_BLACK PIXEL OF _oDlg
@ C(024),C(005) Say "Item.: " + SC7->C7_ITEM + " - " + "Codigo: " + SC7->C7_PRODUTO + " - Descr: " + SC7->C7_DESCRI + " - SALDO: " + STR(SC7->C7_QUANT-SC7->C7_QUJE) + " - Prazo: "+ SUBSTR(DTOS(SC7->C7_DATPRF),7,2)+"/"+SUBSTR(DTOS(SC7->C7_DATPRF),5,2)+"/"+SUBSTR(DTOS(SC7->C7_DATPRF),1,4) Size C(284),C(008) COLOR CLR_BLUE PIXEL OF _oDlg

nSdep:=SC7->C7_QUANT-SC7->C7_QUJE

GetDoc3()


//ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {||_oDlg:End()},{||_oDlg:End()},,)
ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {|| (lConfirma := .t.,_oDlg:End())},{||_oDlg:End()},,)                                                                                 
If lConfirma
   FOR nLin:=1 to len(oGet3:acols)
     dbSelectArea("SZR")
     DbSetOrder(1)
     If oGet3:aColS[nLin][7] 
	   // LINHA DELETADA
	   If SZR->(DbSeek(xFilial("SZR")+ cOc + oGet3:aColS[nLin][2]))
	     	RecLock("SZR",.F.)
	       	SZR->(DbDelete())
			SZR->(MsUnlock())
	   EndIf
	 ELSE  
		// Linha Normal
        IF MsSeek(xFilial("SZR")+cC7num+cC7Item)
          Reclock("SZR",.F.)
        ELSE
          Reclock("SZR",.T.)
        ENDIF
        SZR->ZR_FILIAL :=xfilial("SZR") 
        SZR->ZR_OC     :=oGet3:ACOLS[nLin,1]                        	// TIPO 
        SZR->ZR_ITEM   :=oGet3:ACOLS[nLin,2]           	// PEDIDO
        SZR->ZR_COD    :=oGet3:ACOLS[nLin,3]           	// ITEM PEDIDO
        SZR->ZR_DESCRI :=oGet3:ACOLS[nLin,4]           	// CLIENTE
        SZR->ZR_QTD    :=oGet3:ACOLS[nLin,5]            // CODIGO PRODUTO
        SZR->ZR_DET    :=oGet3:ACOLS[nLin,6]              	// DESCRICAO
        MsUnLock()
     ENDIF
   next
ENDIF
RestArea(aArea)
aCols := aClone(aColsAnt2)
aHeader := aClone(aHeaderAnt2)
n := nElemAnt2
Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณGetDocs1()  ณ Autor ณ Robson Bueno          ณ Data ณ13/02/07  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Montagem da GetDados - Compras Casadas                       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetDoc3()
Local nX			:= 0
Local nCOLS  := 0                                                                                                              
Local aCpoGDa      	:= {"ZR_OC","ZR_ITEM","ZR_COD","ZR_DESCRI","ZR_QTD","ZR_DET"}                                                                                                
Local aAlter       	:= {"ZR_OC","ZR_ITEM","ZR_COD","ZR_DESCRI","ZR_QTD","ZR_DET"}                                                                                                
Local nSuperior    	:= C(034)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(219)           
Local nDireita     	:= C(290)           

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_UPDATE+GD_DELETE                                                                          
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "U_TdObs2()"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                        // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                        // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

Local oWnd         	:= _oDlg                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aCola       	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      
                                                                                                                                
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
			                                                                                                     
	ENDIF                                                                                                                         
Next nX                                                                                                                         
// Carrega aCol                                                                                         
DbSelectArea("SZR")                                                                                                             
SZR->(DbSetOrder(1)) // Campo                                                                                                   
if SZR->(DbSeek(xFilial("SZR")+SC7->C7_NUM))
	While xFilial("SZR") == SZR->ZR_FILIAL .and. ! SZR->(Eof()) .and. SZR->ZR_OC == SC7->C7_NUM 
		aAdd(aCola,{SZR->ZR_OC,SZR->ZR_ITEM,SZR->ZR_COD,SZR->ZR_DESCRI,SZR->ZR_QTD,SZR->ZR_DET,.F.})
		SZR->(DbSkip())
	EndDo 
                                                                                                
Else
    aAux := {}
    DbSelectArea("SX3")                                                                                                             
    SX3->(DbSetOrder(2)) // Campo  
     For nX := 1 to Len(aCpoGDa)                                                                                                     
		If DbSeek(aCpoGDa[nX])                                                                                                        
    	Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
		Endif                                                                                                                         
	Next nX                                                                                                                         
    //aAdd(aAux,Array(Len(aHeader)+1))
    Aadd(aAux,.F.)
    Aadd(aColA,aAux)                                                                                                            
Endif
                                                                    
oGet3 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,NOPC,cLinhaOk,{|| U_TdObs2()},cIniCpos,;                               
                             aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aColA)                                   
Return Nil                                                                                                                      
     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTudoObs   บAutor  ณRobson Bueno        บ Data ณ  13/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTudoOk de Observacoes                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TdObs2()

Local nConta 	:= 1
Local nConta1	:= 1
    


Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTudoObs   บAutor  ณRobson Bueno        บ Data ณ  13/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTudoOk de Observacoes                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿     
*/
User Function MA120F1()
  LOCAL lRet:=.T.
  Local aArea     := GetArea()  
  LOCAL cVar
  Local nPVS:=0
  ACOLS[N,4]:=Posicione("SB1",1,xFilial("SB1")+ACOLS[N,3],"B1_DESC")
  RestArea(aArea)

RETURN (LRET) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA120B4   บAutor  ณROBSON BUENO        บ Data ณ  24/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInsersao devalores para nacionalizacao de Imp               บฑฑ
ฑฑบ          ณortacoes de materiais  (ajuste p/ atender Cons Rapida       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA120B7()

Local oDlgl
Local dVencto :=ctod(" /  /  ")

@ 000,000 To 180,400 Dialog Odlg1 Title OemToAnsi("Prazo Padronizado")
@ 003,008 To 85,200 Title OemToAnsi("Digite o Vencimento Padronizado")

@ 015,015 Say OemToAnsi("Data:") OF Odlgl PIXEL
@ 015,045 msget dVencto Picture "@D 99/99/99" SIZE 60,10 OF Odlgl PIXEL

@ 055,030 BMPBUTTON TYPE 1 ACTION OkPro7(odlg1,dVencto)
@ 055,060 BMPBUTTON TYPE 2 ACTION Finaliz7(odlg1)

Activate Dialog Odlg1 CENTER
 
   
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOkProc    บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento no banco de dados da acao solicitada e confir บฑฑ
ฑฑบ          ณmada                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OkPro7(odlg1,dVencto)
Local cAliasSCP := GetArea()
Local aArea     := (GetArea())
Local cRef      :=cA120Num
dbSelectArea("SC7")
DbSetOrder(1)
MsSeek(xFilial("SC7")+cRef)
do while (!Eof() .And. cRef==SC7->C7_NUM)
  Reclock("SC7",.F.)
  SC7->C7_DATPRF:=dVencto 
  MsUnLock()
  dbSkip()
enddo
Close(Odlg1)
RestArea(cAliasSCP)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Finaliz7(Odlg1)

Close(Odlg1)

Return
