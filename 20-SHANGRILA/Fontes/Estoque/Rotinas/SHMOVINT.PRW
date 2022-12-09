#Include "PROTHEUS.Ch"
#Include "TOPCONN.Ch"
#Include "VKEY.ch"
#include "rwmake.ch"

User FuncTion SHMOVINT()
/*
Preciso criar uma rotina que tanto no Mov.Internos ou movimentos internos (mod.02) faça o seguinte:
Preciso fazer uma movimentação de saída valorizada do estoque(SD3) que ao gravar o sistema crie um movimento de entrada valorizado de um outro produto (B1_X_ALTER).
1.	TM
Vou utilizar sempre a TM 601 para a saída, então a entrada será TM201
E quando utilizar a TM602 para saída, então a entrada será TM202

2.	Produto para TM 601
Conforme o produto digitado no movimento de saída o produto de entrada pode ter duas situações: 
1. Se Campo B1_X_ALTER = "branco", o código terá um "Z" na frente (ex: 010004 ficará Z010004)
2. Caso contrario código será o mesmo do (B1_X_ALTER) (ex:0060000106 ficará Z060000106)

2.1	Produto para TM602
Regra será ao contrário  Exemplo Saida Z010004 a entrada vai ser 010004 // ou saída Z060000106 e entrada vai ser 0060000106.

3.	Quantidade 
Será digitada

4.	Unidade / C contábil / Almoxarifado / Grupo
Gatilho padrão(pode ser alterado) 
4.1	Almoxarifado da entrada(TM 201 ou 202) alguns casos não segue padrão(SB1)  terá que mostrar na Tela da saída(601 / 602) para usuário informar.

5.	Custo / Custo moeda 05
Hoje eu consulto e digito o ultimo custo da moeda 01/ custo da moeda 05 do Kardex pela data do lancamento. Preciso que o sistema  traga preenchido esse valor, tem função que acha esse valor?( Não pode ser negativo) com 4 casas decimais.
O Valor da saída (TM601 / 602) será o mesmo da entrada( TM 201 / 202)

Anexo exemplo das duas movimentação que faço manual.

Passe o valor por Whats para eu aprovar caso queira aproveitar o carnaval pra fazer... kkkk

Att.


*/      
Local aCores  := A240aCores()
PRIVATE CCADASTRO := "INTERNOS ESPECIFICO"
PRIVATE aRotina := MenuDef()
PRIVATE aAcho:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao que preenche o array AACHO                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
A240AAcho()

cFiltro :=""


		mBrowse( 6, 1,22,75,"SD3",,,,,,aCores,,,,,,,, IF(!Empty(cFiltro),cFiltro, NIL))
Return

Static Function MenuDef()
Private aRotina := {	{OemToAnsi("Pesquisar"),"AxPesqui"		, 0 , 1,0,.F.},;
						{OemToAnsi("Visualizar"),"A240Visual"	, 0 , 2,0,Nil},;
						{OemToAnsi("Incluir"),"U_SHMOVINC()"	, 0 , 3,0,Nil},;
						{OemToAnsi("Legenda"),"A240Legenda"	    , 0 , 2,0,.F.} }

RETURN (aRotina)

User FuncTion SHMOVINC()

Private cTMO     := "601"
Private nQtd 	 := 0
Private nCusM1 	 := 0
Private nCusM5 	 := 0
Private cProdO   := Space(TamSx3("B1_COD")[1])
Private cProdD   := Space(TamSx3("B1_COD")[1])
Private cLocalO  := Space(TamSx3("B1_LOCPAD")[1])
Private cLocalD  := Space(TamSx3("B1_LOCPAD")[1])
Private cTMD     := Space(3)
Private dEmissao := dDatabase
Private c_DescO  := Space(40)
Private c_DescD  := Space(40)
Private oGet1
Private oGet2
Private oGet3
Private oGet4
Private oGet5
Private oGet6
Private oGet7
Private oGet8
Private oGet9
Private oGeta
Private oGetb

aButtons := {}
aSize := MSADVSIZE()	
// aAdd(aButtons,{"S4WB011N"  ,{|| xWdsPesq(a_Select,oListBox)},"Localizar"})
nOpc := 0
DEFINE MSDIALOG oDlgMap FROM aSize[7],0  TO aSize[6],aSize[5] TITLE OemToAnsi("Internos ") Of oMainWnd PIXEL //

	oPanelB := TPanel():New(0,0,"",oDlgMap,NIL,.T.,.F.,NIL,NIL,0,60,.T.,.F.)
	oPanelB:Align := CONTROL_ALIGN_ALLCLIENT
	//oPanelB:Align := CONTROL_ALIGN_TOP
	
	oPanelC := TPanel():New(0,0,"",oDlgMap,NIL,.T.,.F.,NIL,NIL,0,20,.T.,.F.)
	oPanelC:Align := CONTROL_ALIGN_BOTTOM
	
	
	@ 05,010  Say OemtoAnsi("Tipo Mov. Saida: ")        OF oPanelB Pixel
	@ 05,070  Say OemtoAnsi("Produto: ")          OF oPanelB Pixel
	@ 05,130 Say OemtoAnsi("Descricao: ")         OF oPanelB Pixel
	@ 05,360 Say OemtoAnsi("Quantidade: ")        OF oPanelB Pixel
	@ 05,430 Say OemtoAnsi("Armazem Saida: ")           OF oPanelB Pixel
	
	@ 15,010 MSGET oGet1  VAR cTMO      Picture "@!" F3 "SF5" Valid xVldMov(cTMO) SIZE 50,10 When .T. OF oPanelB PIXEL
	@ 15,070 MSGET oGet2  VAR cProdO    Picture "@!" F3 "SB1" Valid xVldPrd(cProdO) SIZE 55,10 When .T. OF oPanelB PIXEL
	@ 15,130 MSGET oGet3  VAR c_DescO   Picture "@!" SIZE 200,10 When .F. OF oPanelB PIXEL
	@ 15,360 MSGET oGet4  VAR nQtd      Picture X3Picture("D3_QUANT")  Valid xAvalEst() SIZE 55,10 When .T. OF oPanelB PIXEL
	@ 15,430 MSGET oGet5  VAR cLocalO   Picture "@!" SIZE 25,10 When .T. OF oPanelB PIXEL
	
	@ 26,010 Say OemtoAnsi("Tipo Mov Entrada: ") OF oPanelB Pixel
	@ 26,070 Say OemtoAnsi("Produto Destino: ")  OF oPanelB Pixel
	@ 26,130 Say OemtoAnsi("Descricao: ")        OF oPanelB Pixel
	@ 26,430 Say OemtoAnsi("Armazem Entrada: ")  OF oPanelB Pixel
	
	@ 36,010 MSGET oGet6  VAR cTMD      Picture "@!" F3 "SF5" SIZE 50,10 When .F. OF oPanelB PIXEL
	@ 36,070 MSGET oGet7  VAR cProdD    Picture "@!" F3 "SB1" Valid xVldDPrd(cProdD) SIZE 55,10 When .T. OF oPanelB PIXEL
	@ 36,130 MSGET oGet8  VAR c_DescD   Picture "@!" SIZE 200,10 When .F. OF oPanelB PIXEL
	@ 36,430 MSGET oGet9  VAR cLocalD   Picture "@!" SIZE 25,10 When .T. OF oPanelB PIXEL
	
	@ 47,010 Say OemtoAnsi("Custo Moeda 1: ")  OF oPanelB Pixel
	@ 47,080 Say OemtoAnsi("Custo Moeda 5: ")  OF oPanelB Pixel
	
	@ 57,010 MSGET oGeta  VAR nCusM1      Picture X3Picture("B2_CM1") Valid nCusM1 > 0 SIZE 55,10 When .T. OF oPanelB PIXEL
	@ 57,080 MSGET oGetb  VAR nCusM5      Picture X3Picture("B2_CM5") Valid nCusM5 > 0 SIZE 55,10 When .T. OF oPanelB PIXEL
	

	oBtn1 := TButton():New(0,0,"&Ok ",oPanelC,{|| IF(xValidPro(),oDlgMap:End(),nOpc:=0) },30,11,,,.F.,.T.,.F.,,.F.,{||.T.},,.F.)
 	oBtn1:Align := CONTROL_ALIGN_RIGHT

	oBtn2 := TButton():New(0,0,"&Cancela ",oPanelC,{|| nOpc:=0,oDlgMap:End() },30,11,,,.F.,.T.,.F.,,.F.,{||.T.},,.F.)
 	oBtn2:Align := CONTROL_ALIGN_RIGHT


ACTIVATE MSDIALOG oDlgMap CENTERED // If(u_xTdOk(),oDlg:End(),nOpca:=1)

If nOpc == 1
	xMata240()
EndIf

Return

Static FuncTion xValidPro()
Local l_Ret := .T.
nOpc:=1
DbSelectArea("SB1")
DbSetOrder(1)
If ! DbSeek(xFilial("SB1") + cProdD )
	Alert("Produto Destino invalido...")
	nOpc:=0
	l_Ret := .F.
EndIf	
If ! DbSeek(xFilial("SB1") + cProdO )
	Alert("Produto Origem invalido...")
	nOpc:=0
	l_Ret := .F.
EndIf	
	
Return(l_Ret)	

Static FuncTion xVldMov(cTMO)
Local l_Ret := .T.
// 1.	TM
// Vou utilizar sempre a TM 601 para a saída, então a entrada será TM201
// E quando utilizar a TM602 para saída, então a entrada será TM202
If ! cTMO $ "601|602"
	Alert("Utilizar TM 601 ou 602")
	l_Ret := .F.
Else
	If cTMO == "601"
		cTMD := "201"
	EndIf
	If cTMO == "602"
		cTMD := "202"
	EndIf         
	oGet6:Refresh()
EndIf

Return(l_Ret)

Static FuncTion xVldPrd(cProdO)
Local l_Ret := .T.
/*
2.	Produto para TM 601
Conforme o produto digitado no movimento de saída o produto de entrada pode ter duas situações: 
1. Se Campo B1_X_ALTER = "branco", o código terá um "Z" na frente (ex: 010004 ficará Z010004)
Caso contrario código será o mesmo do (B1_X_ALTER) (ex:0060000106 ficará Z060000106)

2.1	Produto para TM602
Regra será ao contrário  Exemplo Saida Z010004 a entrada vai ser 010004 // ou saída Z060000106 e entrada vai ser 0060000106.
*/
n_TamB1_COD := TamSx3("B1_COD")[1]
DbSelectArea("SB1")
DbSetOrder(1)
If ! DbSeek(xFilial("SB1") + cProdO )
	Alert("Produto não cadastrado...")
	l_Ret := .F.
Else
	If cTMO == "601" .And. Substr(cProdO,1,1) == 'Z'
		Alert("Produto Origem não Pode ser: Z para TM 601...")
		l_Ret := .F.
    EndIf
	If l_Ret .And. cTMO == "602" .And. Substr(cProdO,1,1) <> 'Z'
		Alert("Produto Origem tem que ser: Z ,para TM 602 ...")
		l_Ret := .F.      
	Else	
		cLocalO := Posicione("SB1",1,xFilial("SB1") + cProdO, "B1_LOCPAD" )
		c_DescO := Posicione("SB1",1,xFilial("SB1") + cProdO, "B1_DESC" )
		If cTMO == "601"
			cProdD := Posicione("SB1",1,xFilial("SB1") + cProdO, "B1_X_ALTER" )
			If EmpTy(cProdD)
				cProdD := "Z" + cProdO
			EndIf
		Else
			cProdD := Posicione("SB1",1,xFilial("SB1") + cProdO, "B1_X_ALTER" )
			If EmpTy(cProdD)
				cProdD :=  Substr(cProdO,2,Len(cProdO) )
			EndIf	
			cProdD := Substr(cProdD + Space(n_TamB1_COD),1,n_TamB1_COD)
		EndIf
		
		c_DescD := Posicione("SB1",1,xFilial("SB1") + cProdD , "B1_DESC")
		cLocalD := Posicione("SB1",1,xFilial("SB1") + cProdD , "B1_LOCPAD")
		nCusM1  := Posicione("SB2",1,xFilial("SB2") + cProdO + cLocalO , "B2_CM1")
		nCusM5  := Posicione("SB2",1,xFilial("SB2") + cProdO + cLocalO , "B2_CM5")
		
		oGet3:Refresh()
		oGet5:Refresh()
		oGet7:Refresh()
		oGet8:Refresh()
		oGet9:Refresh()
		oGeta:Refresh()
		oGetb:Refresh()
	EndIf	
EndIf

Return(l_Ret)

Static FuncTion xVldDPrd(cProdD)
Local l_Ret := .T.

DbSelectArea("SB1")
DbSetOrder(1)
If ! DbSeek(xFilial("SB1") + cProdD )
	Alert("Produto não cadastrado...")
	l_Ret := .F.
Else
	cLocalD := SB1->B1_LOCPAD
	c_DescD := SB1->B1_DESC
	oGet8:Refresh()
	oGet9:Refresh()
EndIf

Return(l_Ret)

Static Function xMata240()
Local ExpA1 := {}
Local ExpN2 := 3

lMsErroAuto := .F.          

cUnidO := Posicione("SB1",1,xFilial("SB1")+cProdO,"B1_UM")
cUnidD := Posicione("SB1",1,xFilial("SB1")+cProdD,"B1_UM")

nCus1 := nQtd * nCusM1
nCus5 := nQtd *  nCusM5
dEmissao := dDataBase
ConOut(Repl("-",80))
ConOut(PadC("Movimentacoes Internas",80))
ConOut("Inicio: "+Time())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Teste de Inclusao                                            |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   Begin Transaction   	
	   ExpA2 := {} 		
	   ExpA1 := {} 		
        /*
		DbSelectArea("SB2")
		DbSetOrder(1)
		If !SB2->(dbSeek(xFilial("SB2") + cProdO + cLocalO) )
			// CriaSB2(cProdO,cLocalO)
			Reclock("SB2",.T.)
				SB2->B2_FILIAL := xFilial("SB2")
				SB2->B2_COD    := cProdO
				SB2->B2_LOCAL  := cLocalO
			MsUnlock()
		EndIf
         */
	   aadd(ExpA1,{"D3_TM",cTMO,})	
	   aadd(ExpA1,{"D3_COD",cProdO,})	
	   aadd(ExpA1,{"D3_UM",cUnidO,})			
	   aadd(ExpA1,{"D3_LOCAL",cLocalO,})	
	   aadd(ExpA1,{"D3_QUANT",nQtd,})	
	   aadd(ExpA1,{"D3_CUSTO1",nCus1,})	
	   aadd(ExpA1,{"D3_CUSTO5",nCus5,})	
	   aadd(ExpA1,{"D3_EMISSAO",dEmissao,})		        
	   
	   MSExecAuto({|x,y| mata240(x,y)},ExpA1,ExpN2)		
	   If ! lMsErroAuto		
		   ConOut("Incluido com sucesso! "+cTMO + " Produto: " + cProdO )		
	   Else		
		   MostraErro()
		   ConOut("Erro na inclusao!")	
	   EndIf	         
	   /*
		DbSelectArea("SB2")
		DbSetOrder(1)
		If !SB2->(dbSeek(xFilial("SB2") + cProdD + cLocalD) )
			// CriaSB2(cProdD,cLocalD)
			Reclock("SB2",.T.)
				SB2->B2_FILIAL := xFilial("SB2")
				SB2->B2_COD    := cProdD
				SB2->B2_LOCAL  := cLocalD
			MsUnlock()
		EndIf
  		*/
	   aadd(ExpA2,{"D3_TM",cTMD,})	
	   aadd(ExpA2,{"D3_COD",cProdD,})	
	   aadd(ExpA2,{"D3_UM",cUnidD,})			
	   aadd(ExpA2,{"D3_LOCAL",cLocalD,})	
	   aadd(ExpA2,{"D3_QUANT",nQtd,})	
	   aadd(ExpA2,{"D3_CUSTO1",nCus1,})	
	   aadd(ExpA2,{"D3_CUSTO5",nCus5,})	
	   aadd(ExpA2,{"D3_EMISSAO",dEmissao,})		        
	   
	   MSExecAuto({|x,y| mata240(x,y)},ExpA2,ExpN2)		
	   If ! lMsErroAuto		
		   ConOut("Incluido com sucesso! "+cTMD + " Produto: " + cProdD )		
	   Else		
		   ConOut("Erro na inclusao!")	
		   MostraErro()
	   EndIf	
	   ConOut("Fim  : "+Time())	         
   End Transaction

   Return Nil
//   ------------------------------------------------------------------------------------------------------------------------------------------------------
//   Para realizar o Estorno, poderá ser utilizado o mesmo ponto de entrada, porém com as seguinte configuração:- Alterar a linha: 
//   Local ExpN2 := 3   para:  Local ExpN2 := 5- Incluir as linhas:   
//   aadd(ExpA1,{"D3_NUMSEQ","000074",})	// Aqui deverá ser colocado o D3_NUMSEQ do registro que foi incluido e agora                                                                                        esta sendo estornado.   aadd(ExpA1,{"INDEX",3,})	                     // Aqui deverá ser indicado o número do indice da tabela SD3 que será utilizado.Desta forma, o movimento será estornado.


Static FuncTion xAvalEst()
If nQtd <= 0
	Alert("Informe a quantidade...")
	Return .F.
Else	
	dbSelectArea("SB2")
	dbSeek(xFilial()+cProdO+cLocalO)
	dbSelectArea("SD3")
	If SaldoMov(Nil,Nil,Nil,.F.,Nil,Nil,Nil,dEmissao) < nQtd .And. (GetMV("MV_ESTNEG") != "S")
		cHelp:= "Produto: " + AllTrim(SB2->B2_COD) + " Local: " + AllTrim(SB2->B2_LOCAL)
		Help(" ",1,"MA240NEGAT",,cHelp,4,1)
		Return .F.
	EndIf
EndIf
Return .T.
