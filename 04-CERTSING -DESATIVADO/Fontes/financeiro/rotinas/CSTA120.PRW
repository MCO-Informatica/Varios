#Include "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSTA100   º Autor ³ RENATO RUY BERNARDOº Data ³  17/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ VALIDAÇÃO PARA NÃO EXISTIR DUPLICIDADE ENTRE GRUPOS        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CERTISIGN                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function CSTA120()

Local nCODGAR := aScan( aHeader,{|p| AllTrim(p[2])=="DA1_CODGAR"})
Local nATIVO  := aScan( aHeader,{|p| AllTrim(p[2])=="DA1_ATIVO"})
Local nCodTab := aScan( aHeader,{|p| AllTrim(p[2])=="DA1_CODTAB"})
Local lRet	  := .T.
Local cCodTabF:= ""
Local cQuery  := ""
Local oModelx 	:= FWModelActive() //Abre o modelo ativo MVC
//Campos do cabecalho
Local oModelxDet1:= oModelx:GetModel('DA0MASTER')
Local cCodTab := If(ValType(oModelxDet1:GetValue("DA0_CODTAB")) == "U",aCols[N,nCodTab] ,oModelxDet1:GetValue("DA0_CODTAB"))
//Campos do Acols
Local oModelxDet2:= oModelx:GetModel('DA1DETAIL') 
Local cCodGar := If(ValType(oModelxDet2:GetValue("DA1_CODGAR",N)) =="U",aCols[N,nCODGAR],oModelxDet2:GetValue("DA1_CODGAR",N))
Local cAtivo  := If(ValType(oModelxDet2:GetValue("DA1_ATIVO",N)) =="U" ,aCols[N,nATIVO] ,oModelxDet2:GetValue("DA1_ATIVO",N))


if !Empty(cCodGar) .And. cAtivo == "1" .And. !Empty(cCodTab)
		
	//Renato Ruy - 31/05/2016
	//Consultar se o produto pode ser ativado, caso nao exista vinculo em outro grupo
	cQuery := " SELECT Z3_CODENT, Z3_CODTAB FROM " + RetSqlName("SZ3")
	cQuery += " WHERE "
	cQuery += " Z3_FILIAL = '"+xFilial("SZ3")+"' AND "
	cQuery += " Z3_CODTAB LIKE '%"+cCodTab+"%' AND "
	cQuery += " Z3_TIPENT IN ('2','5') AND "
	cQuery += " D_E_L_E_T_ = ' ' "
	
	cQuery := ChangeQuery(cQuery)
	If Select("TMPGRU") > 0
		DbSelectArea("TMPGRU")
		TMPGRU->(DbCloseArea())
	EndIf
	dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery),"TMPGRU", .F., .T.) 
	
	While !TMPGRU->(EOF())
	    
		cCodTabF := "% " + FormatIn(StrTran(StrTran(RTrim(TMPGRU->Z3_CODTAB),RTrim(cCodTab),""),",,",","),",") + " %"
		
		//Verifica se o item ja esta ativo em outra tabela.
		If Select("TMPDUP") > 0
			DbSelectArea("TMPDUP")
			TMPDUP->(DbCloseArea())
		EndIf
		BeginSql Alias "TMPDUP"
			SELECT MAX(DA1_CODTAB) CODTAB, COUNT(*) CONTA FROM %TABLE:DA1%
			WHERE
			DA1_FILIAL = %XFILIAL:DA1% AND
			DA1_CODGAR = %EXP:cCodGar% AND
			DA1_ATIVO = '1' AND
			DA1_CODTAB IN %EXP:cCodTabF% AND
			%NOTDEL%
		Endsql
		
		If TMPDUP->CONTA > 0
			Alert("O produto está vinculado na tabela: "+TMPDUP->CODTAB+" e vinculado no grupo: "+TMPGRU->Z3_CODENT)
			lRet := .F.
			Exit
		Endif
		
		TMPGRU->(DbSkip())
	Enddo
		
Endif

Return lRet
