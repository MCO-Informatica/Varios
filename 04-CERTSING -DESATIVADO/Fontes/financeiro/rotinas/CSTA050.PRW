#Include "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSTA040   º Autor ³ RENATO RUY BERNARDOº Data ³  07/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PROGRAMA PARA ATUALIZAR CAMPOS DA TABELA DE PRECO          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CERTISIGN                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function CSTA050()

Local aPar	  := {}
Local aProd	  := {}
Local aRet 	  := {}
Local cProd	  := ""
Local bValid  := {|| .T. }
Local lRet	  := .T.
Local oModelx := FWModelActive() //Abre o modelo ativo MVC
Local oModelxDet := oModelx:GetModel('DA1DETAIL') //Abre o aCols do MVC

Local nCODGAR := aScan( aHeader,{|p| p[2]=="DA1_CODGAR"})
Local nDESGAR := aScan( aHeader,{|p| p[2]=="DA1_DESGAR"})
Local nDESCRI := aScan( aHeader,{|p| p[2]=="DA1_DESCRI"})
Local nDESAMI := aScan( aHeader,{|p| p[2]=="DA1_DESAMI"})
Local nATIVO  := aScan( aHeader,{|p| p[2]=="DA1_ATIVO"})
Local nCODPRO := aScan( aHeader,{|p| p[2]=="DA1_CODPRO"})
Local nDATVIG := aScan( aHeader,{|p| p[2]=="DA1_DATVIG"})

//Seta o acols
PA8->(DbSetOrder(2))

If AllTrim(oModelxDet:GetValue("DA1_CODGAR")) == AllTrim(PA8->PA8_CODBPG)
	oModelxDet:SetValue('DA1_CODPRO',PA8->PA8_CODMP8)
	oModelxDet:SetValue('DA1_DESGAR',PadR(PA8->PA8_DESBPG,TamSX3("DA1_DESGAR")[1]," "))
	oModelxDet:SetValue('DA1_DESCRI',PadR(PA8->PA8_DESMP8,TamSX3("DA1_DESCRI")[1]," "))
	oModelxDet:SetValue('DA1_DESAMI',PadR(PA8->PA8_DESMP8,TamSX3("DA1_DESAMI")[1]," "))
ElseIf PA8->(DbSeek(xFilial("PA8")+M->DA1_CODPRO))
	cProd := PA8->PA8_CODBPG
	
	//Renato Ruy - 14/11/2017
	//Caso o codigo seja igual ao informado, na chama tela novamente
	If AllTrim(PA8->PA8_DESMP8) == AllTrim(M->DA1_CODPRO)
		Return .T.
	Endif
	 
	While !PA8->(EOF()) .And. PA8->PA8_CODMP8 == M->DA1_CODPRO
		AADD(aProd,PA8->PA8_CODBPG+"="+PA8->PA8_DESBPG)	
		PA8->(DbSkip())
	Enddo
	
	//Utilizo parambox para selecionar o produto gar
	aAdd( aPar,{ 2  ,"Produto Gar" 	 	,cProd ,aProd, 250,'.T.',.T.})
	If ParamBox( aPar, 'Parâmetros', @aRet, bValid, , , , , ,"CSTA050" , .T., .F. )
		
		PA8->(DbSetOrder(1))
		If PA8->(DbSeek(xFilial("PA8")+aRet[1])) .And. !Empty(aRet[1])
			oModelxDet:SetValue('DA1_CODGAR',PA8->PA8_CODBPG)
			oModelxDet:SetValue('DA1_DESGAR',PadR(PA8->PA8_DESBPG,TamSX3("DA1_DESGAR")[1]," "))
			oModelxDet:SetValue('DA1_DESCRI',PadR(PA8->PA8_DESMP8,TamSX3("DA1_DESCRI")[1]," "))
			oModelxDet:SetValue('DA1_DESAMI',PadR(PA8->PA8_DESMP8,TamSX3("DA1_DESAMI")[1]," "))
		Endif
	Else
		lRet := .F.
		MsgInfo("Um produto deve ser selecionado, a rotina não pode continuar!") 
	Endif
Else
	lRet := .F.
	MsgInfo("O produto Protheus deve ser cadastrado no De-Para, a rotina não pode continuar!") 
Endif

For nI := 1 To Len(aCols)
	if nI != N .And. aCols[N,nCODPRO] == aCols[nI,nCODPRO] .And. aCols[N,nDatVig] == aCols[nI,nDatVig]
		aCols[N,nDatVig] := aCols[N,nDatVig] - 1
		oModelxDet:SetValue('DA1_DATVIG',aCols[N,nDatVig])
		nI := 1
	endif
Next
Return lRet
