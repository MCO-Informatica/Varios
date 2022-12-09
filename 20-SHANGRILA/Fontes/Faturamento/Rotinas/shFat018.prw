#Include 'Protheus.ch'
#include "TopConn.ch"

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 24/09/2014 - 14:24:25
* @description: Ajuste dos campos C6_ZPECUB e C6_ZCUBAGE. 
*/ 
User Function shFat018()

	local aArea 	:= getArea()
	local cDataDe 	:= ""
	local cDataAte	:= ""
	local lContinua	:= .F.
	
	private cAlias:= "ZZZ"
	
	//Tela de perguntas
	lContinua := retData()
	
	if lContinua
		cDataDe := DToS(MV_PAR01)
		cDataAte:= DToS(MV_PAR02)
		
		//Consulta SQL
		retDados(cDataDe,cDataAte)
		
		//Atualizando os campos C6_ZPECUB e C6_ZCUBAGE
		Processa({|| atuSC6()},"Atualizando os campos C6_ZPECUB e C6_ZCUBAGEM")
	endIf
	restArea(aArea)

Return

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 24/09/2014 - 14:41:36
* @description: Consulta SQL para verificar os dados a serem atualizado na tabela SC6. 
*/ 
static function retDados(cDataDe,cDataAte)
	
	local cQry	:= ""
	local cData	:= DToS(dDataBase)
	
	cQry := "SELECT C6_NUM,C6_ITEM,C6_PRODUTO,C6_QTDVEN"+CRLF
	cQry += " FROM "+retSQLTab("SC5")+CRLF
	cQry += " INNER JOIN "+retSQLTab("SC6")+CRLF
	cQry += " ON C5_NUM = C6_NUM"+CRLF
	cQry += " 	AND C6_FILIAL = '"+xFilial("SC6")+"'"+CRLF
	cQry += " 	AND "+retSQLDel("SC6")
	cQry += " WHERE C5_FILIAL = '"+xFilial("SC5")+"'"+CRLF
	cQry += " 	AND "+retSQLDel("SC5")
	cQry += " 	AND C5_EMISSAO BETWEEN '"+cDataDe+"' AND '"+cDataAte+"'
	
	TcQuery cQry New Alias &cAlias
	
return 

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 24/09/2014 - 14:44:00
* @description: Data para ser utilizada na atualização dos campos C6_ZPECUB e C6_ZCUBAGE. 
*/ 
static function retData()
		
		Local aRet		:= {}
		Local aParBox 	:= {}
		local lRet		:= .F.
		local cPerg		:= "shFat001"
		
		AADD(aParBox,{1,"Data De"				,dDataBase						,""					,""	,""		,""											,050,.T.})	// MV_PAR01
		AADD(aParBox,{1,"Data Ate"				,dDataBase						,""					,""	,""		,""											,050,.T.})	// MV_PAR02
		
		if ParamBox(aParBox,cPerg,,,,,,,,cPerg,.T.,.T.)
			lRet := .T.
		else
			lRet := .F.
		endIf
				
return lRet

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 24/09/2014 - 15:32:22
* @description: Atualizando os dados da tabela SC6, campos C6_ZPECUB e C6_ZCUBAGEM. 
*/ 
static function atuSC6()
	
	local nRegs			:= 0
	local nC6_ZPECUB	:= 0
	local nC6_ZCUBAGE	:= 0
	
	Count to nRegs
	
	ProcRegua(nRegs)
	
	(cAlias)->(DbGoTop())
	
	SB5->(DbSetOrder(1))
	SC6->(DbSetOrder(1))
		
	while !(cAlias)->(eof())
				
		IncProc()
		
		if SC6->(DbSeek(xFilial("SB6")+padR((cAlias)->C6_NUM,tamSX3("C6_NUM")[1])+padR((cAlias)->C6_ITEM,tamSX3("C6_ITEM")[1])+padR((cAlias)->C6_PRODUTO,tamSX3("C6_PRODUTO")[1])))
		
			if SB5->(DbSeek(xFilial("SB5")+padR(SC6->C6_PRODUTO,tamSX3("B5_COD")[1])))
				nC6_ZPECUB  := round(SC6->C6_QTDVEN * (((SB5->B5_COMPRLC * SB5->B5_LARGLC * SB5->B5_ALTURLC)/100)*0.03),4)
				nC6_ZCUBAGE := round((SC6->C6_QTDVEN * ((SB5->B5_COMPRLC * SB5->B5_LARGLC * SB5->B5_ALTURLC)/100))/1000000,4)							 
			
				recLock("SC6",.F.)
				SC6->C6_ZPECUB	:= nC6_ZPECUB
				SC6->C6_ZCUBAGEM:= nC6_ZCUBAGE
				
				SC6->(MsUnlock())
			endIf 
			
		endIf
		
		(cAlias)->(dbSkip())
			
	end
		
return
