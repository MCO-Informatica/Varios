#Include "Protheus.ch"
#Include "TopConn.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: MTA200   | Autor: Celso Ferrone Martins   | Data: 19/03/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | PE na validacao do componente do cadastro de estrutura     |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
/*
(oTree:cArqTree)->T_IDLIST	É um numero sequencial e único para cada registro
(oTree:cArqTree)->T_IDTREE	Representa o Node Pai
(oTree:cArqTree)->T_IDCODE	Representa o Item do Tree
(oTree:cArqTree)->T_ISTREE	"S" se for um NODE
(oTree:cArqTree)->T_PROMPT	Descrição a ser apresentada
(oTree:cArqTree)->T_CARGO	Campo Auxiliar para permitir Localizar e Alterar o Prompt do Tree. No Exemplo CARGO contem um número sequencial de acordo com o número de item no Tree. Nesse caso saberei que o ?Item 009? sempre terá T_CARGO como #0013. Utilizado, internamente, pelo metodo TreeSeek para localizar um item do dbTree.
(oTree:cArqTree)->T_BMP001	Armazena o Número da Imagem 1 utilizada na apresentação do dbTree para o Item em questão. Por exemplo, se o Tree for de uma árvore de diretórios imagem de uma ?pasta fechada? quando ?recolhido?.
(oTree:cArqTree)->T_BMP002	Armazena o Número da Imagem 2 utilizada na apresentação do dbTree para o Item em questão. Por exemplo, se o Tree for de uma árvore de diretórios imagem de uma ?pasta fechada? quando ?expandido?.
(oTree:cArqTree)->T_CLIENT	Flag que identifica se o Client já foi atualizado com a informação corrente. Utilizado internamente para otimização na montagem da imagem referente ao Tree.

Ordem	Chave
1		T_IDLIST
2		T_IDTREE
3		T_IDCODE
4		T_IDCARGO

ClassMethArr( oTree )

Private nIndex   := 1
Private nQtdBasePai
Private cRevisao := CriaVar('B1_REVATU')

Private cProduto   := CriaVar('G1_COD')
Private cCodSim    := CriaVar('G1_COD')
Private cUm        := CriaVar('B1_UM')
Private nQtdBase   := CriaVar('B1_QB')

*/
User Function MTA200()

Local lRet       := .T.
Local cOpc       := ParamIxb
Local aAreaTRE   := GetArea()
Local aAreaSB1   := SB1->(GetArea())

Local _cCodPai   := ""  // Produto Pai
Local _cTrt      := ""  // Sequencia
Local _cCodComp  := ""  // Componente
Local _cRecno    := ""  // Recno
Local _cIndex    := ""	// Index
Local _cTipo     := ""  // Tipo

Local nTamG1Cod  := TamSX3("G1_COD")[1]
Local nTamG1Trt  := TamSX3("G1_TRT")[1]
Local nTamG1Comp := TamSX3("G1_COMP")[1]
Local nTamRecno  := 9
Local nTamIndex  := 9
Local nTamTipo   := 4

Local nPosIni    := 1

Local lTemMp     := .F.
Local lTemEm     := .F.
Local lTem2Mp    := .F.

Local TotalMp    := 0
Local cTipoCod   := ""//If(cOpc!="E",Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_TIPO"),"")
Local cTipoComp  := ""//If(cOpc!="E",Posicione("SB1",1,xFilial("SB1")+M->G1_COMP,"B1_TIPO"),"")

Local aEstrut    := {}
Local aTipos     := {}
Local cEol       := CHR(13)+CHR(10)

If AllTrim(FunName()) $ "MATA010"
	Return(lRet)
EndIf

If ValType(cOpc) == "C"
	If cOpc != "E"
		
		aAreaTRE   := If(cOpc!="E",(oTree:cArqTree)->(GetArea()),"")
		cTipoCod   := If(cOpc!="E",Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_TIPO"),"")
		cTipoComp  := If(cOpc!="E",Posicione("SB1",1,xFilial("SB1")+M->G1_COMP,"B1_TIPO"),"")
		
		aEstrut := U_CfmMta200(cOpc)
		//	If Posicione("SB1",1,xFilial("SB1")+cCodPai,"B1_TIPO") == "EM"
		//	   MsgAlert("Produto embalagem n?o pode conter componentes.","Erro de Estrutura")
		//	   Return(.F.)
		//	Endif
		
	EndIf
EndIf

If Len(aEstrut) > 0
	
	/*
	aEstrut[nX][1] // Produto Pai
	aEstrut[nX][2] // Tipo
	aEstrut[nX][3] // Quantidade
	aEstrut[nX][4] // Tipos de Componente
	
	aEstrut[nX][5][nY][1] // Componente
	aEstrut[nX][5][nY][2] // Tipo
	aEstrut[nX][5][nY][3] // Quantidade
	aEstrut[nX][5][nY][4] // T_CARGO
	aEstrut[nX][5][nY][5] // T_PROMPT
	*/
	
	nPosIni   := 1
	_cCodPai  := SubStr((oTree:cArqTree)->T_CARGO,nPosIni,nTamG1Cod)
	nPosIni   += nTamG1Cod
	_cTrt     := SubStr((oTree:cArqTree)->T_CARGO,nPosIni,nTamG1Trt)
	nPosIni   += nTamG1Trt
	_cCodComp := SubStr((oTree:cArqTree)->T_CARGO,nPosIni,nTamG1Comp)
	nPosIni   += nTamG1Comp
	_cRecno   := SubStr((oTree:cArqTree)->T_CARGO,nPosIni,nTamRecno)
	nPosIni   += nTamRecno
	_cIndex   := SubStr((oTree:cArqTree)->T_CARGO,nPosIni,nTamIndex)
	nPosIni   += nTamIndex
	_cTipo    := SubStr((oTree:cArqTree)->T_CARGO,nPosIni,nTamTipo)
	nPosIni   += nTamTipo
	If cOpc == "I"
		//		If _cTipo == "CODI"
		//			_cCodPai  := SubStr((oTree:cArqTree)->T_CARGO,1,15)
		//		Else
		//			_cCodPai  := SubStr((oTree:cArqTree)->T_PROMPT,1,15)
		//		EndIf
		_cCodPai  := SubStr(AllTrim(SubStr((oTree:cArqTree)->T_PROMPT,1,At('-',(oTree:cArqTree)->T_PROMPT)-2))+Space(15),1,15)
		_cCodComp := M->G1_COMP
	EndIf
	
	SB1->(DbSeek(xFilial("SB1")+_cCodComp))
	
	nPos := aScan(aEstrut,{|x|x[1]==_cCodPai})
	If nPos > 0
		If Len(aEstrut[nPos]) == 5
			aEstrut2 := aClone(aEstrut[nPos][5])
			If !Empty(aEstrut[nPos][4])
				aTipos := &(StrTran(StrTran(FormatIn(Alltrim(aEstrut[nPos][4]),"|"),"(","{"),")","}"))
			EndIf
			If aEstrut[nPos][2] == "MP"
				If lRet .And. SB1->B1_TIPO != "MP"
					lRet := .F.
					MsgAlert("Para o produto pai "+_cCodPai+" so e permitido produtos do tipo MP","Inconsistencia na estrutura!!!")
				ElseIf lRet .And. SB1->B1_TIPO == "MP"
					nTotalMp := M->G1_QUANT
					For nX := 1 To Len(aEstrut2)
						If M->G1_COMP != aEstrut2[nX][1]
							nTotalMp += aEstrut2[nX][3]
						EndIf
					Next nX
					If nTotalMp > aEstrut[nPos][3]
						lRet := .F.
						MsgAlert("Quantidade das MP nao pode ser diferente que a Quantidade Base do produto Pai."+cEol+cEol+;
						"Produto Pai: "+aEstrut[nPos][1]+cEol+;
						"Qtde. Base:"+AllTrim(Str(aEstrut[nPos][3]))+cEol+;
						"Qtde. na Estrutura:"+AllTrim(Str(nTotalMp-M->G1_QUANT)),"Inconsistencia na estrutura!!!")
					EndIf
				EndIf
			ElseIf aEstrut[nPos][2] == "PA"
				lTemMp := .F.
				lTemEm := .F.
				For nX := 1 To Len(aEstrut2)
					If aEstrut2[nX][2] == "MP" .And. aEstrut2[nX][1] != _cCodComp
						lTemMp := .T.
					ElseIf aEstrut2[nX][2] == "EM" .And. aEstrut2[nX][1] != _cCodComp
						lTemEm := .T.
					EndIf
				Next nX
				If lRet .And. lTemMp .And. SB1->B1_TIPO == "MP"
					lRet := .F.
					MsgAlert("Para o produto pai "+_cCodPai+" nao e permitido mais de 1 produto do tipo MP","Inconsistencia na estrutura!!!")
				EndIf
				If lRet .And. lTemEm .And. SB1->B1_TIPO == "EM"
					lRet := .F.
					MsgAlert("Para o produto pai "+_cCodPai+" nao e permitido mais de 1 produto do tipo EM","Inconsistencia na estrutura!!!")
				EndIf
				If lRet .And. SB1->B1_TIPO == "MP" .And. nQtdBase != M->G1_QUANT
					lRet := .F.
					MsgAlert("Quantidade da Materia prima tem que ser a mesma do PA.","Inconsistencia na estrutura!!!")
				EndIf
				If lRet .And. SB1->B1_TIPO == "EM" .And. nQtdBase != SB1->B1_VQ_ECAP
//					lRet := .F.
//					MsgAlert("Capacidade da embalagem diferente da quantidade do produto.","Inconsistencia na estrutura!!!")
					//Nelson Junior | 10/06/2014
					lRet := MsgYesNo("A capacidade da embalagem informada na estrutura está diferente da informada no produto. Deseja continuar?",;
					"Inconsistência na Estrutura")
					//
				EndIf
				If lRet .And. SB1->B1_TIPO == "EM" .And. M->G1_QUANT != 1
					lRet := .F.
					MsgAlert("Quantidade da embalagem tem que ser igual a 1.","Inconsistencia na estrutura!!!")
				EndIf
			EndIf
			
		EndIf
		
	ElseIf nPos == 0
		
		_cTipoPai := Posicione("SB1",1,xFilial("SB1")+_cCodPai,"B1_TIPO")
		If _cTipoPai == "MP"
			If lRet .And. SB1->B1_TIPO != "MP"
				lRet := .F.
				MsgAlert("Para o produto pai "+_cCodPai+" so e permitido produtos do tipo MP","Inconsistencia na estrutura!!!")
			EndIf
			If lRet .And. SB1->B1_TIPO == "MP" .And. _cCodPai != cProduto
				lRet := .F.
				MsgAlert("Nao e permitido criar um segundo nivel de estrutura nessa tela."+cEol+;
				"Crie a estrutura do produto "+_cCodPai+" e depois adcione nessa estrutura.","Inconsistencia na estrutura!!!")
			EndIf
		EndIf
		
	EndIf
	
EndIf

SB1->(RestArea(aAreaSB1))

lRet := .T. 

Return(lRet)

/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+--------------------------------+------------------+||
||| Programa: CfmMta200 | Autor: Celso Ferrone Martins   | Data: 09/04/2014 |||
||+-----------+---------+--------------------------------+------------------+||
||| Descricao | Retorno uma Array com os dados da estrutura na tela MATA200 |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/
User Function CfmMta200(cOpc)

/*
aEstrut[nX][1] // Produto Pai
aEstrut[nX][2] // Tipo
aEstrut[nX][3] // Quantidade
aEstrut[nX][4] // Tipos de Componente

aEstrut[nX][5][nY][1] // Componente
aEstrut[nX][5][nY][2] // Tipo
aEstrut[nX][5][nY][3] // Quantidade
aEstrut[nX][5][nY][4] // T_CARGO
aEstrut[nX][5][nY][5] // T_PROMPT
*/

Local _cCodPai   := ""  // Produto Pai
Local _cTrt      := ""  // Sequencia
Local _cCodComp  := ""  // Componente
Local _cRecno    := ""  // Recno
Local _cIndex    := ""	// Index
Local _cTipo     := ""  // Tipo

Local nTamG1Cod  := TamSX3("G1_COD")[1]
Local nTamG1Trt  := TamSX3("G1_TRT")[1]
Local nTamG1Comp := TamSX3("G1_COMP")[1]
Local nTamRecno  := 9
Local nTamIndex  := 9
Local nTamTipo   := 4

Local cT_IdList  := ""//If(cOpc!="E",(oTree:cArqTree)->T_IDLIST,"")
Local cT_IdTree  := ""//If(cOpc!="E",(oTree:cArqTree)->T_IDTREE,"")
Local cT_IdCode  := ""//If(cOpc!="E",(oTree:cArqTree)->T_IDCODE,"")
//Local cT_IdCargo := If(cOpc!="E",(oTree:cArqTree)->T_IDCARGO,"")

Local aEstrut := {}

Default cOpc := ""

cT_IdList  := If(cOpc!="E",(oTree:cArqTree)->T_IDLIST,"")
cT_IdTree  := If(cOpc!="E",(oTree:cArqTree)->T_IDTREE,"")
cT_IdCode  := If(cOpc!="E",(oTree:cArqTree)->T_IDCODE,"")

(oTree:cArqTree)->(DbGoTop())
If !(oTree:cArqTree)->(Eof())
	
	While !(oTree:cArqTree)->(Eof())
		
		//T_CARGo == SG1->G1_COD+SG1->G1_TRT+SG1->G1_COMP+StrZero(SG1->(Recno()),9)+StrZero(nIndex ++, 9)+'COMP'
		nPosIni   := 1
		_cCodPai  := SubStr((oTree:cArqTree)->T_CARGO,nPosIni,nTamG1Cod)
		nPosIni   += nTamG1Cod
		_cTrt     := SubStr((oTree:cArqTree)->T_CARGO,nPosIni,nTamG1Trt)
		nPosIni   += nTamG1Trt
		_cCodComp := SubStr((oTree:cArqTree)->T_CARGO,nPosIni,nTamG1Comp)
		nPosIni   += nTamG1Comp
		_cRecno   := SubStr((oTree:cArqTree)->T_CARGO,nPosIni,nTamRecno)
		nPosIni   += nTamRecno
		_cIndex   := SubStr((oTree:cArqTree)->T_CARGO,nPosIni,nTamIndex)
		nPosIni   += nTamIndex
		_cTipo    := SubStr((oTree:cArqTree)->T_CARGO,nPosIni,nTamTipo)
		nPosIni   += nTamTipo
		
		If _cTipo $ "NOVO/CODI"
			
			//			cTipoComp := Posicione("SB1",1,xFilial("SB1")+_cCodComp,"B1_TIPO")
			cTipoPai  := Posicione("SB1",1,xFilial("SB1")+_cCodPai,"B1_TIPO")
			nQBasePai := iIf(cProduto==_cCodPai,nQtdBase,Posicione("SB1",1,xFilial("SB1")+_cCodPai,"B1_QB"))
			aAdd(aEstrut,{_cCodPai,cTipoPai,nQBasePai,"",{}})
			
		ElseIf _cTipo == "COMP"
			
			nPosIni := At("QTDE:",(oTree:cArqTree)->T_PROMPT)//+5
			nQtde := 0
			If nPosIni > 0
				nPosIni += 5
				nPosFim :=Len((oTree:cArqTree)->T_PROMPT)-nPosIni
				nQtde := Val(SubStr((oTree:cArqTree)->T_PROMPT,nPosIni,nPosFim))
			EndIf
			
			cTipoComp := Posicione("SB1",1,xFilial("SB1")+_cCodComp,"B1_TIPO")
			nPos := aScan(aEstrut,{|x|x[1] == _cCodPai})
			
			If nPos == 0
				cTipoPai  := Posicione("SB1",1,xFilial("SB1")+_cCodPai,"B1_TIPO")
				nQBasePai := iIf(cProduto==_cCodPai,nQtdBase,Posicione("SB1",1,xFilial("SB1")+_cCodPai,"B1_QB"))
				aAdd(aEstrut,{_cCodPai,cTipoPai,nQBasePai,cTipoComp,{{_cCodComp,cTipoComp,nQtde,(oTree:cArqTree)->T_CARGO,(oTree:cArqTree)->T_PROMPT}}})
			Else
				If ! cTipoComp $ aEstrut[nPos][4]
					aEstrut[nPos][4] += iif(Empty(aEstrut[nPos][4]),"","|")+cTipoComp
				EndIf
				aAdd(aEstrut[nPos][5],{_cCodComp,cTipoComp,nQtde,(oTree:cArqTree)->T_CARGO,(oTree:cArqTree)->T_PROMPT})
			EndIf
			
		EndIf
		
		(oTree:cArqTree)->(DbSkip())
		
	EndDo
	(oTree:cArqTree)->(DbSeek(cT_IdCode))
EndIf

Return(aEstrut)