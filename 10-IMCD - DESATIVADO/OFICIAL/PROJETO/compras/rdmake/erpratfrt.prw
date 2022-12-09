#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ERPRATFRT ºAutor  ³ Junior Carvalho    º Data ³ 12/06/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rateio o Valor do CTE conforme as Notas informadas         º±±
±±º          ³ no Documento de entrada (MATA103)                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa chamado no PE MA103BUT                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ERPRATFRT()

Local nX := 0
Local nUsado := 0
Local aButtons := {}
Local aCpoEnch := {}
Local aArea := GetArea()

Local nPosPRD		:= aScan(aHeader,{|x| Alltrim(x[2])=="D1_COD"})
Local nPosPed		:= aScan(aHeader,{|x| Alltrim(x[2])=="D1_PEDIDO"})
Local nPosQTD		:= aScan(aHeader,{|x| Alltrim(x[2])=="D1_QUANT"})
Local nPosTes       := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
Local nPosVUnit  	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_VUNIT"})
Local nPosTotal  	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_TOTAL"})
Local aAlterEnch := {}
Local aPos := {000,000,080,400}
Local nModelo := 3
Local lF3 := .F.
Local lMemoria := .T.
Local lColumn := .F.
Local caTela := ""
Local lNoFolder := .F.
Local lProperty := .F.
Local aCpoGDa := {}

Local nSuperior := 050
Local nEsquerda := 000
Local nInferior := 090
Local nDireita  := 150
Local cLinOk := "AllwaysTrue"
Local cTudoOk := "AllwaysTrue"
Local cIniCpos := " " //"F2_DOC"
Local nFreeze := 000
Local nMax := 010
Local cFieldOk := "AllwaysTrue"
Local cSuperDel := ""
Local cDelOk := "AllwaysFalse"
Local aHeadTMP := {}
Local aColsTMP := {}
Local aAlterGDa := {"D1_NFRSAI","D1_SERSAI"}

Local lRet := .F.
Local aPeso :={}
Local aPergs := {}
Local cTitulo := "Rateio Nota de Frete"
Local aRet := {}
Local nPesoTotal := 0
Local nPeso	 := 0

local aFields as array
local nI as numeric
local cCampo as char
Local nLin as numeric


Private oDlg
Private oGetD
Private oEnch
Private aTELA[0][0]
Private aGETS[0]

IF ALLTRIM(CESPECIE) $ 'CTE|CTR'
	if !(Empty(Acols[1][nPosPRD])) .AND. !(Empty(Acols[1][nPosPed]))
		aAdd(aPergs,{1,"Valor Nota ",0,"@E 999,999.99",'.T.',"","",100,.F.}) // Tipo numérico

		If ParamBox(aPergs ," Parametro - "+cTitulo,aRet)

// Respectivamente na posição  49 , 50 do vetor aFields
			aCampos :={"D1_NFRSAI","D1_SERSAI"}
			nUsado:=0 

			DbSelectArea("SX3")

			aFilds := {}

			aFields := FwSX3Util():GetAllFields('SD1')

			For nX := 1 To Len(aCampos)
				for nI := 1 to Len(aFields)
					IF aCampos[nX] ==aFields[nI]
						nUsado++
						AADD(aHeadTMP,{GetSx3Cache(aCampos[nX],AllTrim("X3_TITULO")),;
						GetSx3Cache(aCampos[nX],"X3_CAMPO"),;
						GetSx3Cache(aCampos[nX],"X3_PICTURE"),;
						GetSx3Cache(aCampos[nX],"X3_TAMANHO"),;
						GetSx3Cache(aCampos[nX],"X3_DECIMAL"),;
						"ALLWAYSTRUE()",;
						GetSx3Cache(aCampos[nX],"X3_USADO"),;
						GetSx3Cache(aCampos[nX],"X3_TIPO"),;
						GetSx3Cache(aCampos[nX],"X3_F3"),;
						GetSx3Cache(aCampos[nX],"X3_CONTEXT")})
					Endif
				next nI
			Next nX

			aColsTMP:= Array(Len(Acols),nUsado+1)
			
			For nLin := 1 To Len(Acols)

				For nX:=1 to nUsado
					aColsTMP[nLin,nX]:=CriaVar(aHeadTMP[nX,2])
				Next
				nX := 1
				aColsTMP[nLin,LEN(aColsTMP[1])]:=.F.
			
			Next nLin

			aAlterGDa := aClone(aCampos)
			nOpc := GD_UPDATE + GD_DELETE //GD_INSERT +

			nAlt := 300
			nDir := 350
			oDlg := MSDIALOG():New(000,000,nAlt,nDir, "Rateio Frete",,,,,,,,,.T.)

			nSuperior := 040 //065
			nEsquerda := 005
			nInferior := 150
			nDireita  := 175

			oGetD:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita, nOpc,;
			cLinOk,cTudoOk,cIniCpos,aAlterGDa,nFreeze,nMax,cFieldOk, cSuperDel,;
			cDelOk, oDLG, aHeadTMP, aColsTMP)

			oGetD:oBrowse:lUseDefaultColors := .T.
			oDlg:bInit := {|| EnchoiceBar(oDlg, {|| lRet := .T. ,oDlg:End()}, {||oDlg:End()}, , aButtons, ,,.F. ,.F.,.F.,.T.,.F.)}

			oDlg:Activate()

			if lRet

				For nX:= 1 To Len(oGetD:ACOLS)
					IF !(oGetD:ACOLS[1][LEN(oGetD:ACOLS[NX])])
						If Empty(oGetD:ACOLS[nX,1]) .and. Empty(oGetD:ACOLS[nX,2])
							Alert("Não foi informada Nota de saida da Linha "+Str(nX))
							lRet := .F.
						Else
							nPeso := BSCPESO( oGetD:ACOLS[nX,1],oGetD:ACOLS[nX,2])
							aAdd(aPeso, {nPeso,0} )
							nPesoTotal += nPeso
						Endif
					ENDIF
				Next nX
				IF lRet .AND. nPeso > 0
					nVlrLanc := 0
					For nX:= 1 To Len(Acols)
						N:= NX
						IF !(Acols[1][LEN(ACOLS[NX])])
							if nX < Len(Acols)
								nVlrTt := ROUND(((aRet[1]/nPesoTotal ) * aPeso[nX,1]),2)
							else
								nVlrTt := aRet[1] - nVlrLanc
							endif

							GdFieldPut('D1_QUANT',nVlrTt,N)
							MCMExecX3( 'D1_QUANT', N )

							GdFieldPut('D1_VUNIT',1,nX)
							MCMExecX3( 'D1_VUNIT', N )

							GdFieldPut('D1_TOTAL',nVlrTt,N)
							MCMExecX3( 'D1_TOTAL', N )

							GdFieldPut('D1_NFRSAI',oGetD:ACOLS[nX,1],N)
							GdFieldPut('D1_SERSAI',oGetD:ACOLS[nX,2],N)
							nVlrLanc+=nVlrTt
						ENDIF
					Next nX
				ENDIF

			Endif
		Endif
	ELSE

		Alert("Esolha o Pedido / Item de compra primeiro.")

	ENDIF

ELSE

	Alert("Programa só rateia Especie CTE / CTR")

ENDIF

oGetDados:oBrowse:Refresh()
RestArea(aArea)
Return .T.

Static Function BSCPESO(cNota,cSerie)
Local cAliasSD2 := GetNextAlias()
Local nPeso := 0

cQuery := "SELECT D2_QUANT FROM "+RETSQLNAME("SD2")
cQuery += " WHERE D2_DOC = '"+cNota+"' "
cQuery += " AND D2_SERIE = '"+cSerie+"' "
cQuery += " AND D2_EMISSAO >= '20180101' "
cQuery += " AND D_E_L_E_T_ <> '*'
cQuery := ChangeQuery(cQuery)

PLSQuery(cQuery,cAliasSD2)

DbSelectArea(cAliasSD2)
(cAliasSD2)->(DbGoTop())
While !(cAliasSD2)->(EOF())
	nPeso += 	(cAliasSD2)->D2_QUANT
	(cAliasSD2)->(DbSkip())
EndDo
(cAliasSD2)->(DbCloseArea())
MsErase(cAliasSD2)

if nPeso <= 0
	alert("A emissão da nota é inferior 01/01/2018. ")
Endif

Return(nPeso)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MCMExecX3 ºAutor  ³Ivan Morelatto Tore º Data ³  18/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa Valid, Valid de Usuario e Trigger do campo         º±±
±±º          ³ informado                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MCOM002                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MCMExecX3( cCpoInf, nCntFor1 )

Local aAreaAtu := GetArea()
Local aAreaSX3 := SX3->( GetArea() )
Local cOldVar	:= __ReadVar

local cValid as char 
local cVAlidUser as char 

local aFields := {}

cVAlidUser := GetSx3Cache(cCpoInf,"X3_VLDUSER")
cValid := GetSx3Cache(cCpoInf,"X3_VALID")

aFields := FwSX3Util():GetAllFields('SD1')

cCpoInf := Left( cCpoInf + Space(10), 10 )

__ReadVar := "M->" + cCpoInf
&( "M->" + cCpoInf ) := GDFieldGet( cCpoInf, nCntFor1 )

SX3->( dbSetOrder( 2 ) )
SX3->( dbSeek( cCpoInf ) )
&( cVAlidUser )
&( cValid ) 

IF !("D1_QUANT" $ cCpoInf )
	RunTrigger( 2 )
Endif

__ReadVar := cOldVar

RestArea( aAreaSX3 )
RestArea( aAreaAtu )

Return
