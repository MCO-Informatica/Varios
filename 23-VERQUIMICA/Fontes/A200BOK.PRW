#Include "Protheus.ch"
#Include "TopConn.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: A200BOK  | Autor: Celso Ferrone Martins   | Data: 09/04/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | PE no botao OK da rotina MATA200. Validacao da Estrutura   |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function A200BOK()

Local lRet  := .T.
Local aRegs := PARAMIXB[1]
Local cCod  := PARAMIXB[2]

Local aEstrut    := {}
Local aVersolve  := {}
Local cEol       := CHR(13)+CHR(10)

Local cT_IdList  := (oTree:cArqTree)->T_IDLIST
Local cT_IdTree  := (oTree:cArqTree)->T_IDTREE
Local cT_IdCode  := (oTree:cArqTree)->T_IDCODE

Local aAreaSb1   := SB1->(GetArea("SB1"))

DbSelectArea("SB1") ; DbSetOrder(1)

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

If !Empty(cT_IdList)
	aEstrut := U_CfmMta200()
	If len(aEstrut) > 0
		For nX := 1 To Len(aEstrut)
			If Len(aEstrut[nX][5]) > 0
				
				If aEstrut[nX][2] == "PA"
					lTemMp := .F.
					lTemEm := .F.
					For nY := 1 To Len(aEstrut[nX][5])
						If aEstrut[nX][5][nY][2] == "MP"
							lTemMp := .T.
							If aEstrut[nX][5][nY][3] <> nQtdBase
								MsgAlert("A quantidade da matéria prima tem que ser a mesma do PA.","Inconsistência na Estrutura")
								Return(.F.)
							EndIf
							//
						ElseIf aEstrut[nX][5][nY][2] == "EM"
							lTemEm := .T.
						EndIf
					Next nY
					If !lTemMp
						MsgAlert("Para o produto pai "+aEstrut[nX][1]+" nao e permitido mais de 1 produto do tipo MP","Inconsistencia na estrutura!!!")
						Return(.F.)
					EndIf
					If !lTemEm
						MsgAlert("Para o produto pai "+aEstrut[nX][1]+" nao e permitido mais de 1 produto do tipo EM","Inconsistencia na estrutura!!!")
						Return(.F.)
					EndIf
				ElseIf aEstrut[nX][2] == "MP"
					If aEstrut[nX][3] == 0
						MsgAlert("Para o segundo nivel de estrutura so e permitido a alteracao."+cEol+"Crie a estrutura do produto "+aEstrut[nX][1]+" e depois inclua nessa estrutura.","Inconsistencia na estrutura!!!")
						Return(.F.)
					EndIf
					nTotalMp := 0
					For nY := 1 To Len(aEstrut[nX][5])

						If aEstrut[nX][5][nY][2] != "MP"
							MsgAlert("Para o produto pai "+aEstrut[nX][1]+" so e permitido produtos do tipo MP","Inconsistencia na estrutura!!!")
							Return(.F.)
						EndIf                  

						nTotalMp += aEstrut[nX][5][nY][3]

						SB1->(DbSeek(xFilial("SB1")+aEstrut[nX][5][nY][1]))
						aDadosVer := {}
						Aadd(aDadosVer,aEstrut[nX][5][nY][1])	//01 - Codigo Produto
						Aadd(aDadosVer,SB1->B1_UM)				//02 - Um
						Aadd(aDadosVer,SB1->B1_CONV)			//03 - Densidade
						Aadd(aDadosVer,aEstrut[nX][5][nY][3])	//04 - Quantidade
						Aadd(aDadosVer,0)						//05 - % do produto

						SB1->(DbSeek(xFilial("SB1")+aEstrut[nX][1]))
						nPos := aScan(aVersolve,{|x|x[1]==aEstrut[nX][1]})

						If nPos == 0
							Aadd(aVersolve,{;
								aEstrut[nX][1]				,; //01 - Codigo Produto Pai
								SB1->B1_UM					,; //02 - Um
								0							,; //03 - Densidade
								aEstrut[nX][3]				,; //03 - Quantidade Base
								{aDadosVer}})
						Else
							Aadd(aVersolve[nPos][5],aDadosVer)
						EndIf

					Next nY

					If nTotalMp != aEstrut[nX][3]
						MsgAlert("Total dos componentes do produto "+aEstrut[nX][1]+" divergente com a Quantidade Base","Inconsistencia na estrutura!!!")
						MsgAlert("Quantidade das MP nao pode ser diferente que a Quantidade Base do produto Pai."+cEol+cEol+;
						"Produto Pai: "+aEstrut[nX][1]+cEol+;
						"Qtde. Base:"+AllTrim(Str(aEstrut[nX][3]))+cEol+;
						"Qtde. na Estrutura:"+AllTrim(Str(nTotalMp)),"Inconsistencia na estrutura!!!")
						If !MsgYesNo("Deseja continuar com a divergencia de quantidade ?","Atencao!!!")
							Return(.F.)
						EndIf
					EndIf
				EndIf

			EndIf
		Next nX
	EndIf
EndIf

nValor := 0

_nQbase := 200
If Len(aVersolve) > 0

	For nX := 1 To Len(aVersolve)
		nFatCon := 0
		For nY := 1 To Len(aVersolve[nX][5])
//			nPerc   := (aVersolve[nX][5][nY][4] * 100  ) / aVersolve[nX][4]
			nPerc   := (aVersolve[nX][5][nY][4]/aVersolve[nX][5][nY][3])/(_nQbase/100)
			nFatCon += (aVersolve[nX][5][nY][3] * nPerc) / 100
		Next nY
		aVersolve[nX][3] := nFatCon
	Next nX
	
	For nX := 1 To Len(aVersolve)
		If SB1->(DbSeek(xFilial("SB1")+aVersolve[nX][1]))
			RecLock("SB1",.F.)
			SB1->B1_CONV    := aVersolve[nX][3] 
			MsUnLock()
		EndIf
	Next nX
EndIf

SB1->(RestArea(aAreaSb1))

Return(lRet)