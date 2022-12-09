#Include "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSTA040   º Autor ³ RENATO RUY BERNARDOº Data ³  06/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PROGRAMA PARA ATUALIZAR CAMPOS DA TABELA DE PRECO          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CERTISIGN                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function CSTA040()

Local nDESAMI := aScan( aHeader,{|p| p[2]=="DA1_DESAMI"})
Local nDESGAR := aScan( aHeader,{|p| p[2]=="DA1_DESGAR"})
Local nCODPRO := aScan( aHeader,{|p| p[2]=="DA1_CODPRO"})
Local nDESCRI := aScan( aHeader,{|p| p[2]=="DA1_DESCRI"})
Local lRet	  := .T.
Local oModelx := FWModelActive() //Abre o modelo ativo MVC
Local oModelxDet := oModelx:GetModel('DA1DETAIL') //Abre o aCols do MVC

PA8->(DbSetOrder(1))
If PA8->(DbSeek(xFilial("PA8")+M->DA1_CODGAR))
	
	oModelxDet:SetValue('DA1_CODGAR',PA8->PA8_CODBPG)
	oModelxDet:SetValue('DA1_CODPRO',PA8->PA8_CODMP8)
	oModelxDet:SetValue('DA1_DESGAR',PadR(PA8->PA8_DESBPG,TamSX3("DA1_DESGAR")[1]," "))
	oModelxDet:SetValue('DA1_DESCRI',PadR(PA8->PA8_DESMP8,TamSX3("DA1_DESCRI")[1]," "))
	oModelxDet:SetValue('DA1_DESAMI',PadR(PA8->PA8_DESMP8,TamSX3("DA1_DESAMI")[1]," "))
		
Endif

Return lRet
