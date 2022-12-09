#Include 'Protheus.ch'

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/07/2014 - 11:19:52
* @description: Tela para inclusão e alteração dos dados nas tabelas ZRM e SX5. 
*/ 
User Function SHPCP002(cAlias,nReg,nOpc)

	local oDlg,oEnc	
	Local aExibe   := {"ZRM_CHAVE|ZRM_DESCRI|ZRM_RMETAS"}	// Campos exibidos na Enchoice()
	Local bOk			:= {|| atualiza(cAlias,nReg,nOpc), oDlg:End()} //Efetua a gravacao de aCols
	Local bCancel		:= {|| RollBackSx8(), oDlg:End()}
	local cCadastro		:= "Resumo de Metas"
	local aArea			:= getArea()
	
	private aAltera  	:= {"ZRM_CHAVE","ZRM_DESCRI","ZRM_RMETAS"}
	private cCampo		:= ""
	
	Private aSize	  := MsAdvSize(, .F., 430)
	Private aObjects  := {} 
	Private aPosObj   := {} 
	Private aSizeAut  := MsAdvSize() // devolve o tamanho da tela atualmente no micro do usuario

	AAdd( aObjects, { 315,  70, .T., .T. } )
	AAdd( aObjects, { 115, 100, .T., .T. } )

	aInfo := {aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3}
	aPosObj := MsObjSize( aInfo, aObjects ) 
	aPosObj[1][3] := 125

	RegToMemory(cAlias, If(nOpc==3, .T., .F.))
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	oEnc := MsMGet():New(cAlias, nReg, nOpc,,,,aExibe,aPosObj[1],aAltera,,,,,oDlg,,.T.)
	
	Activate MsDialog oDlg Centered on Init EnchoiceBar(oDlg,bOK,bCancel)
	
	restArea(aArea)
	
Return

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/07/2014 - 11:31:40
* @description: Inclusão dos dados da ZRM. 
*/ 
static Function atualiza(cAlias,nReg,nOpc)
	
	
	cChave := M->ZRM_CHAVE
	cDescri:= M->ZRM_DESCRI
	cRMetas:= M->ZRM_RMETAS	
	
	DbSelectArea(cAlias)
	DbSelectArea("SX5")
	//inclusao
	if nOpc == 3
		inclusao()
		
	//alteração		
	elseIf nOpc == 4
		alteracao()
		
	//exclusao	
	elseIf nOpc == 5
		exclusao()
				
	endIf
	
return

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/07/2014 - 13:35:58
* @description: Campos editaveis na enchoice. 
*/ 
static function campoEdit()
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("ZRM")
	While (!Eof() .And. SX3->X3_ARQUIVO == "ZRM")
		If x3uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
			cCampo := SX3->X3_CAMPO
			If	(SX3->X3_CONTEXT == "V" .Or. INCLUI)
				M->&(cCampo) := CriaVar(SX3->X3_CAMPO)
			Else   
				M->&(cCampo) := SZO->(FieldGet(FieldPos(SX3->X3_CAMPO)))
			EndIf
			if SX3->X3_PROPRI == "U"
				aAdd(aAltera, Alltrim(SX3->X3_CAMPO))
			endif
		EndIf
	
		DbSelectArea("SX3")
		DbSkip()
	EndDo
return

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/07/2014 - 15:08:35
* @description: Realiza a inclusao dos dados na ZRM e XX5. 
*/ 
static function inclusao()
	
	if RecLock("ZRM",.T.) //INCLUSÃO
		ZRM->ZRM_FILIAL	:= xFilial("ZRM")
		ZRM->ZRM_CHAVE	:= cChave
		ZRM->ZRM_DESCRI	:= cDescri
		ZRM->ZRM_RMETAS	:= cRMetas
		
		ZRM->(MsUnLock())
	endIf
	
	//inclusao na SX5
	if RecLock("SX5",.T.) //INCLUSÃO
		SX5->X5_FILIAL	:= xFilial("SX5")
		SX5->X5_TABELA	:= "44"
		SX5->X5_CHAVE	:= cChave
		SX5->X5_DESCRI	:= cDescri
				
		SX5->(MsUnLock())
	endIf
	
return

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/07/2014 - 15:09:12
* @description: Realiza a alteração dos dados na SX5 e ZRM. 
*/ 
static function alteracao()
		
		//alterando os dados na ZRM
		ZRM->(DbSetOrder(1))
		
		if ZRM->(DbSeek(xFilial("ZRM")+padR(ZRM->ZRM_CHAVE,tamSX3("ZRM_CHAVE")[1])))
			if RecLock("ZRM",.F.) //alteração
				ZRM->ZRM_FILIAL	:= xFilial("ZRM")
				ZRM->ZRM_CHAVE	:= cChave
				ZRM->ZRM_DESCRI	:= cDescri
				ZRM->ZRM_RMETAS	:= cRMetas
				
				ZRM->(MsUnLock())
			endIf	
		else
			Alert("Registro não localizado na tabela ZRM!")
		endIf
		
		//alterando os dados na SX5
		SX5->(DbSetOrder(1))
		
		if SX5->(DbSeek(xFilial("SX5")+"44"+padr(ZRM->ZRM_CHAVE,tamSX3("X5_CHAVE")[1])))
			if RecLock("SX5",.F.) 
				SX5->X5_FILIAL	:= xFilial("SX5")
				SX5->X5_CHAVE	:= cChave
				SX5->X5_DESCRI	:= cDescri
								
				SX5->(MsUnLock())
			endIf	
		endIf
				
return

/**
*
* @author: Bruno Ricardo de Oliveira
* @since: 18/07/2014 - 15:10:23
* @€description: Realiza a exclusão dos dados na SX5 e ZRM. 
*/ 
static function exclusao()

	ZRM->(DbSetOrder(1))
	
	if ZRM->(DbSeek(xFilial("ZRM")+padR(ZRM->ZRM_CHAVE,tamSX3("ZRM_CHAVE")[1])))
		if RecLock("ZRM",.F.) //exclusao
			ZRM->(DbDelete())
			
			ZRM->(MsUnLock())
		endIf	
	else
		Alert("Registro não localizado na tabela ZRM!")
	endIf
	
	//Exclusao da SX5
	SX5->(DbSetOrder(1))
		
	if SX5->(DbSeek(xFilial("SX5")+"44"+padr(ZRM->ZRM_CHAVE,tamSX3("X5_CHAVE")[1])))
		if RecLock("SX5",.F.) 
			SX5->(DbDelete())
			
			SX5->(MsUnLock())
		endIf
		
	endIf
		
return