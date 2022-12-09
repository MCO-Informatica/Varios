#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQE215MAR  บAutor  ณMarcio Dias         บ Data ณ  11/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclui novo botao na tela de resultados para a inclusao dos บฑฑ
ฑฑบ          ณensaios especificos HCI.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico HCI via QIEA215.PRW (Resultados).                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function QE215MAR()
//Variaveis Locais da Funcao
Local aCombo1	 := {}
Local aCombo2	 := {}
Local aCombo3	 := {}
Local aCombo4	 := {}
Local nItem		 := 0				// Numero do item do combo para gravacao

Private cCombo1	 := QEK->QEK_XTT	// Tratamento termico
Private cCombo2	 := QEK->QEK_XMP	// Material de partida
Private cCombo3  := QEK->QEK_XTCP	// Tipo do corpo de prova
Private cCombo4  := QEK->QEK_XSCP	// Sentido do corpo de prova

// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
Private INCLUI := .F.		// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

DbSelectArea("SX3")
DbSetOrder(2)
DbGoTop()
DbSeek("QE6_XTT")		// Posiciona no grupo de TRATAMENTO TERMICO
While SubStr(SX3->X3_CAMPO,1,7) == "QE6_XTT"		// Enquanto encontrar campos dentro do grupo 
	If QE6->QE6_PRODUT == QEK->QEK_PRODUT .AND. QE6->QE6_REVI == QEK->QEK_REVI .AND. &("QE6->"+(SX3->X3_CAMPO)) == "S"		// verifica se esta marcado na especificacao
		nItem ++
		aAdd(aCombo1,AllTrim(Str(nItem))+"-"+AllTrim(TitSX3(SX3->X3_CAMPO)[1])+" "+SX3->X3_DESCRIC)                                               // insere o item na combobox e grava o numero para controle de gravacao na QEK
		SX3->(DbSkip())
	Else
		SX3->(DbSkip()) 
	EndIf
EndDo    
nItem := 0

DbSelectArea("SX3")
DbSetOrder(2)
DbGoTop()
DbSeek("QE6_XMP")		// Posiciona no grupo de MATERIAL DE PARTIDA
While SubStr(SX3->X3_CAMPO,1,7) == "QE6_XMP"		// Enquanto encontrar campos dentro do grupo 
	If QE6->QE6_PRODUT == QEK->QEK_PRODUT .AND. QE6->QE6_REVI == QEK->QEK_REVI .AND. &("QE6->"+(SX3->X3_CAMPO)) == "S"		// verifica se esta marcado na especificacao
		nItem ++
		aAdd(aCombo2,AllTrim(Str(nItem))+"-"+AllTrim(TitSX3(SX3->X3_CAMPO)[1]))                                               // insere o item na combobox e grava o numero para controle de gravacao na QEK
		SX3->(DbSkip())
	Else
		SX3->(DbSkip()) 
	EndIf
EndDo    
nItem := 0

DbSelectArea("SX3")
DbSetOrder(2)
DbGoTop()
DbSeek("QE6_XCP")		// Posiciona no grupo de CORPO DE PROVA (TIPO)
While SubStr(SX3->X3_CAMPO,1,7) == "QE6_XCP"		// Enquanto encontrar campos dentro do grupo 
	If QE6->QE6_PRODUT == QEK->QEK_PRODUT .AND. QE6->QE6_REVI == QEK->QEK_REVI .AND. &("QE6->"+(SX3->X3_CAMPO)) == "S" ;
	   .AND. (AllTrim(SX3->X3_CAMPO) == "QE6_XCP01" .OR. AllTrim(SX3->X3_CAMPO) == "QE6_XCP02")							// verifica se esta marcado na especificacao e eh do grupo de Tipo
		nItem ++
		aAdd(aCombo3,AllTrim(Str(nItem))+"-"+AllTrim(TitSX3(SX3->X3_CAMPO)[1]))                                               	// insere o item na combobox e grava o numero para controle de gravacao na QEK
		SX3->(DbSkip())
	Else
		SX3->(DbSkip()) 
	EndIf
EndDo 
nItem := 0
      
DbSelectArea("SX3")
DbSetOrder(2)
DbGoTop()
DbSeek("QE6_XCP")		// Posiciona no grupo de CORPO DE PROVA (SENTIDO)
While SubStr(SX3->X3_CAMPO,1,7) == "QE6_XCP"		// Enquanto encontrar campos dentro do grupo 
	If QE6->QE6_PRODUT == QEK->QEK_PRODUT .AND. QE6->QE6_REVI == QEK->QEK_REVI .AND. &("QE6->"+(SX3->X3_CAMPO)) == "S" ;
	   .AND. (AllTrim(SX3->X3_CAMPO) == "QE6_XCP03" .OR. AllTrim(SX3->X3_CAMPO) == "QE6_XCP04" .OR. AllTrim(SX3->X3_CAMPO) == "QE6_XCP05" ;
	   .OR. AllTrim(SX3->X3_CAMPO) == "QE6_XCP06")		// verifica se esta marcado na especificacao e eh do grupo de Sentido
		nItem ++
		aAdd(aCombo4,AllTrim(Str(nItem))+"-"+AllTrim(TitSX3(SX3->X3_CAMPO)[1])) // insere o item na combobox e grava o numero para controle de gravacao na QEK
		SX3->(DbSkip())
	Else
		SX3->(DbSkip()) 
	EndIf
EndDo 
nItem := 0

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Sele็ใo de atributos - HCI") FROM C(178),C(181) TO C(341),C(482) PIXEL

	// Cria Componentes Padroes do Sistema
	@ C(002),C(075) ComboBox cCombo1 Items aCombo1 Size C(072),C(010) PIXEL OF _oDlg
	@ C(005),C(007) Say "Tratamento t้rmico" Size C(047),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(017),C(075) ComboBox cCombo2 Items aCombo2 Size C(072),C(010) PIXEL OF _oDlg
	@ C(020),C(007) Say "Material de partida" Size C(045),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(032),C(075) ComboBox cCombo3 Items aCombo3 Size C(072),C(010) PIXEL OF _oDlg
	@ C(035),C(007) Say "Tipo do corpo de prova" Size C(057),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(047),C(075) ComboBox cCombo4 Items aCombo4 Size C(072),C(010) PIXEL OF _oDlg
	@ C(050),C(007) Say "Sentido do corpo de prova" Size C(065),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(065),C(070) Button OemtoAnsi("&OK") Size C(037),C(012) PIXEL OF _oDlg ACTION GravaCombo()
	@ C(065),C(110) Button OemtoAnsi("&Cancelar") Size C(037),C(012) PIXEL OF _oDlg ACTION _oDlg:End()

ACTIVATE MSDIALOG _oDlg CENTERED 

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravaComboบAutor  ณMarcio Dias         บ Data ณ  11/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava as informacoes digitadas nos combos dos ensaios espec.บฑฑ
ฑฑบ          ณda HCI.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico HCI - Atraves do ponto de entrada QE215MAR.      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

                
Static Function GravaCombo()

RecLock("QEK",.F.)

QEK->QEK_XTT 	:= SubStr(cCombo1,1,1)
QEK->QEK_XMP 	:= SubStr(cCombo2,1,1) 
QEK->QEK_XTCP 	:= SubStr(cCombo3,1,1)	
QEK->QEK_XSCP	:= SubStr(cCombo4,1,1)

QEK->(MsUnlock()) 

_oDlg:End()

Return .T.

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
