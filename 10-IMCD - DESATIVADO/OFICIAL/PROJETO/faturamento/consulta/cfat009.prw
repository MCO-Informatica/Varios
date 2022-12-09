#Include "Protheus.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CFAT009  บ Autor ณ Microsiga          บ Data ณ 04/02/10    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tela Entrada para Consulta Produto / Grupo                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento / Orcamento                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function CFAT009(cProduto)
	// Declaracao de Variaveis 
	Local aArea := GetArea()

	Private cCad 	 := "Consulta Produto"
	//Private cProduto := IIf(Type("aCols") != "U", aCols[N,2], Space(15))
	Default cProduto := Space(15)

	// Janela
	DEFINE MSDIALOG oDlg Title cCad From 0, 0 To 300, 300 Pixel
	// Fontes
	DEFINE FONT oFnt1 Name "Arial" SIZE 0,18

	// Objetos
	@ 002, 002 To 150, 150 Pixel of oDlg

	@ 023, 015 Say "Produto:" Pixel of oDlg FONT oFnt1
	@ 020, 050 MsGet oProduto Var cProduto F3 "ZB2" Picture "@!" SIZE 70, 10 Pixel of oDlg

	@ 100, 035 Button oBtnOk Prompt "&Ok" SIZE 30,15 Pixel ;
	Action (Campos(cProduto)) of oDlg

	@ 100, 075 Button oBtnSair Prompt "&Sair" SIZE 30,15 Pixel ;
	Action (oDlg:End()) Cancel of oDlg
	ACTIVATE MSDIALOG oDlg Centered

	RestArea(aArea)
Return

Static Function Close()
	oDlg:End()
Return

Static Function Campos(cProduto)

	Processa({|| U_CFAT010(cProduto)},cCad,"",.T.)

Return
