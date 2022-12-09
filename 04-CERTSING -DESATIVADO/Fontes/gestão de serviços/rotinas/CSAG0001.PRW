#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSAG0001    ºAutor  ³Claudio Henrique Corrêaº Data ³        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Agendamento Externo                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSAG0001()
	
Local aCoors := FWGetDialogSize( oMainWnd )
Local oPanel := NIL 
Local oFWLayer := NIL
Local oDlg := NIL

Static cHoraAgenda := ""
Static cOs := ""
Static cMail := ""

Private oBrowse := NIL
Private aRotina := MenuDef()
Private cCadastro := ''
Private cAr := ''
Private cRN := ""
Private dDataVen := Date()
Private cLocal    := MsDocPath()
Private aModel := {}
Private lPag := .T.
   
/*
 aSize[1] = 1 -> Linha inicial área trabalho.
 aSize[2] = 2 -> Coluna inicial área trabalho.
 aSize[3] = 3 -> Linha final área trabalho.
 aSize[4] = 4 -> Coluna final área trabalho.
 aSize[5] = 5 -> Coluna final dialog (janela).
 aSize[6] = 6 -> Linha final dialog (janela).
 aSize[7] = 7 -> Linha inicial dialog (janela).
 */
Private aSize		:= MsAdvSize(.f.)
Private lFoiAlterado:= .F.

Private oFont1 := TFont():New( "Arial",0,-19,,.F.,0,,400,.F.,.F.,,,,,, )
Private oFont2 := TFont():New( "Arial",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
Private oFont3 := TFont():New( "Arial",0,-11,,.T.,0,,400,.F.,.F.,,,,,, )

DEFINE MSDIALOG oDlg Title "Solicitação de Atendimento"  From aSize[7],0 To aSize[6],aSize[5] Of oMainWnd COLOR CLR_BLACK,CLR_WHITE Pixel

oFWLayer := FWLayer():New()
oFWLayer:Init( oDlg, .F., .T. )

oFWLayer:AddLine( 'UP', 90, .F. ) 
oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )

oPanel := oFWLayer:GetColPanel( 'ALL', 'UP' )

oBrowse:= FWmBrowse():New()
oBrowse:SetOwner( oPanel )
oBrowse:DisableDetails()
oBrowse:SetDescription( 'Solicitação de Atendimento' )
oBrowse:SetAlias( 'PA0' )
oBrowse:SetProfileID( '1' )
oBrowse:SetExecuteDef( 7 )
oBrowse:ForceQuitButton()
//oBrowse:SetTimer({||oBrowse:Refresh()}, 5)

	//Legenda
	
/*
"BR_AMARELO","Pendente Pagamento"
"BR_LARANJA","Pendente Tecnico"
"ENABLE","Liberado"
"DISABLE","OS Suspensa"
"BR_PINK","OS Aberta Automaticamente"
"BR_BRANCO","OS Finalizada com Pendencias"
"BR_AZUL","Finalizada"
"BR_PRETO","Cancelada"
*/
			
oBrowse:AddLegend("PA0_STATUS == '1'","BR_AMARELO","Pendente Pagamento")
oBrowse:AddLegend("PA0_STATUS == '2'","BR_LARANJA","Pendente Agendamento Tecnico")
oBrowse:AddLegend("PA0_STATUS == '3'","ENABLE","Liberado para Execução")
oBrowse:AddLegend("PA0_STATUS == '4'","DISABLE" ,"Atendimento Suspenso")
oBrowse:AddLegend("PA0_STATUS == '5'","BR_AZUL","Finalizada")
oBrowse:AddLegend("PA0_STATUS == 'F'","BR_PRETO","Cancelada")
oBrowse:AddLegend("PA0_STATUS == '6'","BR_PINK","OS Aberta Automaticamente")
oBrowse:AddLegend("PA0_STATUS == '7'","BR_BRANCO","OS Finalizada com Pendencias")

oBrowse:Activate()

Activate MsDialog oDlg ON INIT CSAGBARRA(@oDlg,{|| .F.},{|| oDlg:End()},@oBrowse) Centered                 
	
Return

Static Function MenuDef() // Criação do Menu Funcional

Local aRotina := {}

ADD OPTION aRotina TITLE "Pesquisar" 		ACTION 'PESQBRW'					OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE "Visualizar"   	ACTION "VIEWDEF.CSAG0001"			OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE "Incluir"			ACTION "VIEWDEF.CSAG0001"			OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE "Alterar"			ACTION "VIEWDEF.CSAG0001"			OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Cancelar"		ACTION "VIEWDEF.CSAG0001"			OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE "Copiar"			ACTION "VIEWDEF.CSAG0001"			OPERATION 6 ACCESS 0
ADD OPTION aRotina TITLE "Legenda"			ACTION 'U_CSAGLEGE()' 				OPERATION 7 ACCESS 0
ADD OPTION aRotina TITLE "Conhecimento"	ACTION 'MSDOCUMENT.CSAG0001'		OPERATION 8 ACCESS 0
//ADD OPTION aRotina TITLE "Consulta Agenda"	ACTION 'U_CSAGAGEN(@oBrowse)'	OPERATION 9 ACCESS 0	//Relatorio Claudio
ADD OPTION aRotina TITLE "Consulta Agenda"	ACTION 'U_csAGRel(@oBrowse)'		OPERATION 9 ACCESS 0	//Relatorio Douglas

Return aRotina

Static Function ModelDef()

Local oStruPA0 := FWFormStruct(1,'PA0')
Local oStruPA1 := FWFormStruct(1,'PA1')
Local oModel := NIL
Local cCond := GETNEWPAR("MV_AGCONDP","030")
Private oModel

//oModel := MPFormModel():New('CSAGMVC',,,{ |oModel| CSAGPOS( oModel ) })
oModel := MPFormModel():New('CSAGMVC',,,{ |oModel| CSAGPOS( @oModel ) })
//oModel := MPFormModel():New('CSAGMVC',,,{ |oModel| CSAGPOS( mdl ) })

oModel:AddFields('PA0MASTER',/*cOwner*/,oStruPA0)
oModel:AddGrid('PA1DETAIL','PA0MASTER',oStruPA1)

oModel:SetPrimaryKey({'PA0_FILIAL','PA0_OS'})

oModel:SetRelation('PA1DETAIL',{ { 'PA1_FILIAL', 'xFilial("PA1")'},;
								 { 'PA1_OS', 'PA0_OS' } }, PA1->( IndexKey( 1 )))
								 
aPA1Produ := {}
aPA1Produ := FwStruTrigger('PA1_PRODUT' , 'PA1_DESCRI' , 'SB1->B1_DESC',.T.,'SB1',1,'xFilial("SB1")+PA1_PRODUT')

oStruPA1:AddTrigger( ;
aPA1Produ[1] , ; // [01] identificador (ID) do campo de origem
aPA1Produ[2] , ; // [02] identificador (ID) do campo de destino
aPA1Produ[3] , ; // [03] Bloco de código de validação da execução do gatilho
aPA1Produ[4] ) // [04] Bloco de código de execução do gatilho

oModel:SetDescription('Solicitação de Atendimento')

oModel:GetModel( 'PA1DETAIL' ):SetOptional( .T. )

oModel:GetModel( 'PA1DETAIL' ):SetMaxLine( 20 )

oModel:GetModel('PA0MASTER'):SetDescription('Cabeçalho Solicitação de Atendimento')

oModel:GetModel('PA1DETAIL'):SetDescription('Detalhes Solicitação de Atendimento')

Return oModel

Static Function ViewDef()

Local oModel := FWLoadModel('CSAG0001')
Local oStruPA0:= FWFormStruct(2,'PA0')
Local oStruPA1:= FWFormStruct(2,'PA1')
Local oViewDef:= FWFormView():New()

oViewDef:SetModel(oModel)

oViewDef:AddField('VIEW_PA0',oStruPA0,'PA0MASTER')

oViewDef:AddGrid('VIEW_PA1',oStruPA1,'PA1DETAIL')

oViewDef:AddIncrementField( 'VIEW_PA1', 'PA1_ITEM' )

oViewDef:CreateHorixontalBox('UP',50)

oViewDef:CreateHorixontalBox('DN',50)

oViewDef:SetOwnerView('VIEW_PA0','UP')

oViewDef:SetOwnerView('VIEW_PA1','DN')

Return oViewDef

Static Function CSAGPOS( oModel, oBrowse )

Local aRet := {}
Local nOperation := oModel:GetOperation()
Local cTip := ""
Local lRet := .F.
Local cAssuntoEm := ""
Local cCase := ""
Local aRetBol := {}     
local cMVBolReg		:= GetNewPar("MV_BOLETRG","2")        
local lErro			:= .F.
local cLink			:= ""
Local y :=0

aModel := oModel:aAllSubModels[1]:ADATAMODEL[2][1][2]
cOs := oModel:aAllSubModels[1]:ADATAMODEL[1][2][2]
cCodAr := oModel:aAllSubModels[1]:ADATAMODEL[1][21][2]
cRegiao := oModel:aAllSubModels[1]:ADATAMODEL[1][22][2]
cMail := oModel:aAllSubModels[1]:ADATAMODEL[1][43][2]

//ADEL(aModel,LEN(aModel))
Do Case
	
	Case nOperation == 3
	
	cAssuntoEm := 'Solicitação de validação em domicílio - Boleto para pagamento' //'Solicitação de atendimento - Envio do boleto por E-mail'
	
	nMark := 0
	
	For y := 1 to Len(aModel)
			
		If aModel[y][1][1][12] == "S"
				
			lPag := .T.
			
			nMark++
				
		Else
				
			If aModel[y][1][1][12] == "N" .Or. aModel[y][1][1][12] == "F" .Or. aModel[y][1][1][12] == "C" .Or. aModel[y][1][1][12] == "P"
			
				If nMark == 0 
					
					lPag := .F.
					
				End If
						
			End If
				
		End If
				
	Next y
	
	aOk := U_CSAG0010(cOs, aModel, cRegiao, cCodAr)
	
	If aOk[1] == .T.
		
		cHoraAgenda := aOk[2]
		
	Else
	
		Help( ,, 'HELP',, 'É necessário realizar o pré-agendamento para prosseguir.', 1, 0) 
	
		Return(lRet)
	
	End If				
	
	If FUNNAME() == "CSAG0001"

		aRet := U_CSAG0003(3,oModel)
	
	Else

		aAdd(aRet,{.T., M->ADE_CODIGO})
	
	Endif
	
	If aRet[1][1] == .T.
	
		FWFormCommit( oModel )
		
		If lPag == .F.
		
			aAdd(aRetBol,{.T.,"","",""})
			
			dDataVen := Date()
			
		Else 
		
			If lPag == .T.
				
				aRetBol := CSAGGBOL()
			
				dDataVen := aRetBol[1][2]
			
			End If
			
		End If
			
		If aRetBol[1][1] == .T.
		
			cOs := oModel:aAllSubModels[1]:ADATAMODEL[1][2][2]
				
			cAnexo := cOs+".PDF"
                //--------------------------------------------------------------------
			// Condicao para enviar e-mail com Boleto (legado) ou Link (ShopLine)
			// @autor: Douglas Parreja
			// @Since: 19/12/2016
                //--------------------------------------------------------------------
			if !empty( cMVBolReg )
				if cMVBolReg == "1" 
					cFileName := cLocal+"\"+cAnexo
				elseif cMVBolReg == "2" 
					if len( aRetBol[1][4] ) > 0
						cFileName := alltrim( aRetBol[1][4] )
					else
						cFileName := "Link não gerado, verifique o campo Fatura identificara se sera gerado boleto, caso esteja SIM por gentileza entre em contato com Sistemas Corporativos."  
						lErro := .T.
					endif
				endif
			endif
			
			cRN := aRetBol[1][3]
			
			If lPag == .T.
			
				cCase := "ABERTURA"
				
				If lRet := U_CSFSEmail(cOs, cFileName, cMail, cAssuntoEm, cCase, lErro)
					
					If lRet := CSAGRAVA(aRet[1][2])
						
						Aviso( "Solicitação de Atendimento", "OS incluida com sucesso", {"Ok"} )
						
					Else
						
						Processa( {|| CSAGROLL() }, "Aguarde...", "Desfazendo as alterações ja realizadas",.F.)
						oModel:GetModel():SetErrorMessage(,,oModel:GetId(),"","Agend. Externo","Falha ao incluir a O.S. (Ordem de Serviço).","Por gentileza, refazer o processo, caso persista o incidente acione Contato Sistemas Corporativos")	
						Return
						
					End If
					
				Else
					//----------------------------------------------------------------
					// Alterado porque na minha visao e validado com a Area BackOffice 
					// e Operacoes, quando neste caso eh retornado algum erro, eh 
					// para manter o historico exibindo para usuario.
					// Comentado Processa-CSAGROLL().
					// @autor: Douglas Parreja
					// @Since: 24/02/2017
					//----------------------------------------------------------------
					//Processa( {|| CSAGROLL() }, "Aguarde...", "Desfazendo as alterações ja realizadas",.F.)
					oModel:GetModel():SetErrorMessage(,,oModel:GetId(),"","Agend. Externo","Falha ao enviar e-mail","Por gentileza, refazer o processo, caso persista o incidente acione Contato Sistemas Corporativos")							
					Return .T.
			
				End If
				
			Else
			
				If lRet := CSAGRAVA(aRet[1][2])
						
					Aviso( "Solicitação de Atendimento", "OS incluida com sucesso", {"Ok"} )
						
				Else
						
					Processa( {|| CSAGROLL() }, "Aguarde...", "Desfazendo as alterações ja realizadas",.F.)
					oModel:GetModel():SetErrorMessage(,,oModel:GetId(),"","Agend. Externo","Falha ao incluir a O.S. (Ordem de Serviço).","Por gentileza, refazer o processo, caso persista o incidente acione Contato Sistemas Corporativos")		
					Return
						
				End If
				
			End If		
				
		Else
			//----------------------------------------------------------------
			// Alterado porque na minha visao e validado com a Area BackOffice 
			// e Operacoes, quando neste caso eh retornado algum erro, eh 
			// para manter o historico das tabelas ADE e ADF, porem para as 
			// tabelas PA0, PA1 e PAW eh para ser deletada porque sera gerado
			// outro registro.
			// Na funcao CSAGROLL() informado o parametro 1.
			// @autor: Douglas Parreja
			// @Since: 24/02/2017
			//----------------------------------------------------------------
			Processa( {|| CSAGROLL(1) }, "Aguarde...", "Desfazendo as alterações ja realizadas",.F.)
			oModel:GetModel():SetErrorMessage(,,oModel:GetId(),"","Agend. Externo","Na validação do Schema, foi identificado que possui divergências.","Será preciso realizar as alterações conforme sugerido para que possa gerar o Boleto.")				
			Return 
		
		End If

	End If
		
	Case nOperation == 4
	
		FWFormCommit( oModel )
		
		lRet := .T.
				
	Case nOperation == 5
	
		lRet := CSAGCAN(oModel)
		
End Case

Return lRet

Static Function CSAGRAVA(cProtocolo)

local ENVIADO := "1" 
local cMVBolReg		:= GetNewPar("MV_BOLETRG","2")     

IF FUNNAME() == "CSAG0001"				
			
	DbSelectArea("ADE")
	DbSetOrder(1)
	DbSeek(xFilial("ADE")+cProtocolo)
	
	BEGIN TRANSACTION                         
		RecLock("ADE",.F.)
		ADE->ADE_XDVLD := PAW->PAW_DATA 
		MsUnlock()
	END TRANSACTION	
	
End If

cPA1Fat := "000"
					
DbSelectArea("PA0")
DbSetOrder(1)
DbSeek(xFilial("PA0")+cOs)
				
If PA0->(Found())

	DbSelectArea("PA1")
	DbSetOrder(1)
	DbSeek(xFilial("PA1")+cOs)
	
	While PA1->(!EOF()) .and. PA1->PA1_OS == cOs 
	
		If TRIM(PA1->PA1_PRODUT) == "SV010001" .And. PA1->PA1_FATURA == "P"
		
			cPA1Fat := "030"
			
		Else
		
			cPA1Fat := "000"
			
		End If
	    PA1->(DbSkip())
	End
		
	BEGIN TRANSACTION                         
		RecLock("PA0",.F.)
		
		PA0->PA0_AR 	:= PAW->PAW_AR
		PA0->PA0_DTAGEN := PAW->PAW_DATA 
		PA0->PA0_HRAGEN	:= cHoraAgenda
		PA0->PA0_STATUS := IIF(lPag == .T., "1", "2")
		PA0->PA0_DTINC 	:= dDataBase
		PA0->PA0_CONDPA := cPA1Fat
		PA0->PA0_TIPATE := IIF(FUNNAME() == "CSAG0001", "ADM", "BKF")
		PA0->PA0_LINDIG := cRN
		PA0->PA0_DTEBOL := dDataBase
		PA0->PA0_DTVBOL := dDataVen
		
		IIF(FUNNAME() == "CSAG0001",PA0->PA0_PROTOC := cProtocolo,PA0->PA0_PROTOC:= M->ADE_CODIGO)
		
		PA0->PA0_DTABER		:= dDataBase
		PA0->PA0_HORABR		:= TIME()
        
		//----------------------------------------------------------------
		// Boleto Registrado - ShopLine 
		// Incluido dois campos para controle:
		// PA0_LINK   -> Link do ShopLine 
		// PA0_STMAIL -> Status do Envio do e-mail (1-enviado/2-reenviado)
		//
		// @autor: Douglas Parreja
		// @Since: 21/12/2016
		//----------------------------------------------------------------
		PA0->PA0_LINK	:= iif( !empty(cFileName), alltrim(cFileName), "" )          
		PA0->PA0_STMAIL	:= ENVIADO 
		
		MsUnlock() 
		
		//--------------------------------------------------------------------
		// Alterado regra, quando incluir um novo atendimento, gerarei um 
		// registro no historico (tabela ZZV), para que seja possivel gerar
		// novo Boleto com a mesma numeracao da O.S.     
		// Por se tratar do primeiro registro, sera 99+Ordem Servico.
		// @autor: Douglas Parreja
		// @Since: 31/01/2017
        //--------------------------------------------------------------------
		if !empty( cMVBolReg )
			if cMVBolReg == "2" 
				cLink := iif( !empty(cFileName), alltrim(cFileName), "" )
				u_csGravaZZV( alltrim(cOs), "99"+alltrim(cOs), dDataVen, cLink  )   
			endif
		endif
		
	END TRANSACTION	
					
	lRet := .T.
			
Else
				
	lRet := .F.
				
	Processa( {|| CSAGROLL() }, "Aguarde...", "Desfazendo as alterações ja realizadas",.F.)
	oModel:GetModel():SetErrorMessage(,,oModel:GetId(),"","Agend. Externo","Falha ao incluir a O.S. (Ordem de Serviço).","Por gentileza, refazer o processo, caso persista o incidente acione Contato Sistemas Corporativos")			
End If		

Return (lRet)

Static Function CSAGGBOL()

Local cClifat := IIF(Empty(PA0->PA0_CLIFAT),PA0->PA0_CLILOC,PA0->PA0_CLIFAT)
Local cCliloj := POSICIONE("SA1",1,xFILIAL("SA1")+cClifat, "A1_LOJA")
Local nTotReg := 0
Local aRet := {}
Local nSoma:= v := 0
Local aVal := {}
Local cProduto := GETNEWPAR("MV_CSPRODU","SV010001")
Local nMVQtdDiasBol := GetNewPar("MV_XDIASBLT",2) //Quantidade de dias anteriores ao agendamento para vencimento do Boleto.

cPA1OS := cOs
	
dbSelectArea("PA1")
dbSetOrder(1)
dbSeek(xFilial("PA1")+cOs)

If PA1->(Found())
   
	While PA1->(!EOF())  .and. PA1->PA1_OS == cOs
	
		If PA1->PA1_FATURA == "S" .and. ALLTRIM(PA1->PA1_PRODUT) == cProduto
	
				AADD(aVal,PA1->PA1_VALOR)
			
		End If
			
		PA1->(DbSkip()) 
   
   	End
   	
   	For v := 1 to  Len(aVal)			
			
		nSoma += aVal[v]
			
	Next v
   	
Else 

	If PA1->PA1_FATURA == "N" .Or. PA1->PA1_FATURA == "P" .Or. PA1->PA1_FATURA == "C"  

		aAdd(aRet,{.T.,"",""})
		
	Else
	
		MsgAlert("Deve haver no minimo um prouto com Fatura Sim ou Fatura Não")
 	
		aAdd(aRet,{.F.,"",""})
	
	End If
	
End If

dbSelectArea("PAW")
dbSetOrder(4)
dbSeek(xFilial("PAW")+cOs)

If PAW->(Found())

	dDataV := DataValida(DaySub(PAW->PAW_DATA , nMVQtdDiasBol ) ,.F.)                                     
	
	aRet := U_CSFSGBOL(cClifat,cPA1OS,cCliloj,nSoma,dDataV) //CHAMA A ROTINA DE GERAÇÃO DE BOLETO
			
	if len(aRet) > 0
		
		If aRet[1][1] == .T.
			
			cRN := aRet[1][3] 
			dDataVen := aRet[1][2]
					
			aParam:= {"",aRet[1][3],""}
	  	
			U_GTPUTIN(cOs, "O","",.T.,{""},"",aParam)	
				
		End If		
					
	Endif
	
Else

	MsgAlert("Não há agendamento relacionado a este atendimento, contate o administrador do sistema!")
	
End If
	
Return (aRet)

User Function CSAGLEGE()
BrwLegenda("Solicitação de Atendimento","Solicitação de Atendimento",{;
{"BR_AMARELO","Pendente Pagamento"},;
{"BR_LARANJA","Pendente Agendamento Tecnico"},;
{"ENABLE","Liberado para Execução"},;
{"DISABLE","Atendimento Suspenso"},;
{"BR_PINK","OS Aberta Automaticamente"},;
{"BR_BRANCO","OS Finalizada com Pendencias"},;
{"BR_AZUL","Finalizada"},;
{"BR_PRETO","Cancelada"}})
Return(.T.)

Static Function CSAGCAN(oModel)

Local lRet := .F.
//Valida cancelamento de OSs Postecipados
Local lPostecipado := .F.

dbSelectArea("PA1")
dbSetOrder(1)
dbSeek(xFilial("PA1")+cOs)

If PA1->(Found())

	While PA1->(!EOF()) .And. PA1->PA1_OS == cOs
	
		If ALLTRIM(PA1->PA1_PRODUT) == "SV010001"
	
			If PA1->PA1_FATURA  <> "S" 
			
				lPostecipado := .T.
			
			End If
			
		End If

		PA1->(dbSkip())
	
	End

End If

If PA0->PA0_STATUS == "7" .Or. PA0->PA0_STATUS == "F" .Or. PA0->PA0_STATUS == "5" .Or. PA0->PA0_STATUS == "4"     

 	MsgAlert("Status da OS para cancelamento invalido")
 	
 	lRet := .F.
 	
 	Return lRet
 	
 End If

If PA0->PA0_STATUS == '1' .Or. lPostecipado == .T. // Cancela OS que ainda não foram pagas os demais status que não envolvem faturamento
	
	DbSelectArea("PA0")
	DbSetOrder(1)
	DbSeek(xFilial("PA0")+cOs)
			
	If PA0->(Found())
	
		BEGIN TRANSACTION
		
			RecLock("PA0",.F.)
			PA0->PA0_STATUS := "F"
			MsUnlock()
	
		END TRANSACTION
	
	Else
				
		lRet := .F.
		
		MsgAlert("OS não encontrada, favor entrar em contato com sistemas corporativos")
				
		Return lRet
				
	Endif
							
	DbSelectArea("ADE")
	DbSetOrder(1)
	DbSeek(xFilial("ADE")+PA0->PA0_PROTOC)
	
	cCodigo := ADE->ADE_CODIGO
			
	If ADE->(Found())
		
		BEGIN TRANSACTION                         
	
			RecLock("ADE",.F.)	
			ADE->ADE_STATUS := "3"				
			MsUnlock()
	
		END TRANSACTION
			
		cOcor	:= "006451"
		cAcao	:= "000406"
			
		dbSelectArea("ADF")
		dbSetOrder(1)
		dbSeek(xFilial("ADF")+cCodigo)
			
		ADF->(DbGoBottom())
			
		cItem := ADF->ADF_ITEM++			
			
		BEGIN TRANSACTION                         
	
			RecLock("ADF",.T.)
			ADF->ADF_CODIGO		:= cCodigo
			ADF->ADF_ITEM 		:= cItem
			ADF->ADF_CODSU9 	:= cOcor
			ADF->ADF_CODSUQ		:= cAcao
			ADF->ADF_CODSU7		:= "000001"
			ADF->ADF_CODSU0		:= "9G"
			ADF->ADF_DATA		:= dDataBase
			ADF->ADF_HORA		:= Time()	
			ADF->ADF_HORAF		:= Time()
			ADF->ADF_OS			:= cOs	
			MsUnlock()
	
		END TRANSACTION
				
	Endif
		
	DbSelectArea("PAW")
	DbSetOrder(4)
	DbSeek(xFilial("PAW")+cOs)
	
	If PAW->(Found())
	
		BEGIN TRANSACTION
	
			RecLock("PAW",.F.)
			DbDelete()
			MsUnlock()
	
		END TRANSACTION
				
	Endif
		
	DbSelectArea("PA2")
	DbSetOrder(2)
	DbSeek(xFilial("PA2")+cOs)
	
	If PA2->(Found())
		
		While PA2->(!EOF()) .and. PA2->PA2_NUMOS == cOs
	
			RecLock("PA2",.F.)
			DbDelete()
			MsUnlock()
				
			PA2->(dbSkip())
				
		End
				
	Endif
	
	ConOut("Ordem de Serviço Cancelada! Codigo=" + cCodigo)		

	lRet := .T.
			
	Aviso( "Solicitação de Atendimento", "OS Cancelada com sucesso", {"Ok"} )
		
Else
		
	MsgAlert("Não é possivel cancelar a OS, pois a mesma não se encontra pendente")
		
	lRet := .F.
			
Endif	

Return (lRet)

Static Function CSAGBARRA(oDlg,bOk,bCancel,oBrowse)
Local oBar, oBtOk, oBtCan, aBtn := {}
Local lPyme    := Iif(Type("__lPyme") <> "U",__lPyme,.F.)

DEFINE BUTTONBAR oBar 3D TOP OF oDlg

DEFINE BUTTON RESOURCE "S4WB008N"		OF oBar ACTION Calculadora()											PROMPT ""	TOOLTIP "Calculadora"
DEFINE BUTTON RESOURCE "GRAF3D"			OF oBar ACTION LostFocus() .And. U_CSAGC001(@oBrowse) 					PROMPT ""	TOOLTIP "Consulta Movimentos" 
DEFINE BUTTON RESOURCE "PMSPRINT"		OF oBar	ACTION LostFocus() .And. U_CSAG0009(PA0->(RECNO()))				PROMPT ""	TOOLTIP "Imprimir Ordem de Serviço"
DEFINE BUTTON RESOURCE "BTCALEND"		OF oBar	ACTION LostFocus() .And. U_CSAG0012(@oBrowse)					PROMPT ""	TOOLTIP "Agendamento"
DEFINE BUTTON RESOURCE "SDUSETDEL"		OF oBar	ACTION LostFocus() .And. U_CSAG0008(PA0->(RECNO()),@oBrowse)	PROMPT ""	TOOLTIP "Finalizar Ordem de Serviço" 
DEFINE BUTTON RESOURCE "BUDGET"			OF oBar	ACTION LostFocus() .And. U_CSAG0015(PA0->(RECNO()),@oBrowse)	PROMPT ""	TOOLTIP "Geração de Boleto"
DEFINE BUTTON RESOURCE "BR_CANCEL"		OF oBar	ACTION LostFocus() .And. U_CSAG0021(PA0->(RECNO()),@oBrowse)	PROMPT ""	TOOLTIP "Suspensão de OS" 
DEFINE BUTTON RESOURCE "DESTINOS"	   	OF oBar	ACTION LostFocus() .And. u_csReenvEmail(PA0->(RECNO()),@oBrowse)	PROMPT ""	TOOLTIP "Reenvio de e-mail"

Return

Static Function LostFocus()


oBrowse:SetFocus()


Return .T.

Static Function CSAGROLL( nProcess )

Local lRet := .F.

//----------------------------------------------------------------------
// Criado variavel nProcess para setar quando for Boleto Registrado.
// nProcess == 1 (Boleto Registrado)
// @autor: Douglas Parreja
// @Since: 23/02/2017
//----------------------------------------------------------------------
default nProcess := 0 
	
DbSelectArea("PA0")
DbSetOrder(1)
DbSeek(xFilial("PA0")+PA0->PA0_OS)

			
If Found()

	DbSelectArea("PA1")
	DbSetOrder(1)
	DbSeek(xFilial("PA1")+PA0->PA0_OS)
	
	If Found()
	
		Do While !Eof("PA1") .and. PA1->PA1_OS == PA0->PA0_OS
	
			BEGIN TRANSACTION
			RecLock("PA1",.F.)
			DbDelete()
			MsUnlock()
			END TRANSACTION
			
			PA1->(DbSkip())
		
		End Do
		
	Else
				
		lRet := .F.
				
	Endif
	
Else
					
	lRet := .F.
				
Endif

//----------------------------------------------------------------------
// Boleto Registrado
// Criado a variavel nProcess para setar quando for Boleto Registrado,
// no Processo legado, ao retornar .F. qualquer operacao eh realizado
// RoolBack em todo o processo, porem, nao concordo realizar RoolBack
// no Atendimento sendo que deixarei o Processo parado na rotina
// Agendamento Externo (CSAG0001).
// @autor: Douglas Parreja
// @Since: 23/02/2017
//----------------------------------------------------------------------
if nProcess <> 1

	DbSelectArea("PA0")
	DbSetOrder(1)
	if DbSeek(xFilial("PA0")+PA0->PA0_OS)
		if Found()	
			BEGIN TRANSACTION
			RecLock("PA0",.F.)
			DbDelete()
			MsUnlock()
			END TRANSACTION				
		else				
			lRet := .F.					
		endif
	else				
		lRet := .F.					
	endif
							
	DbSelectArea("ADE")
	DbSetOrder(28)
	DbSeek(xFilial("ADE")+PA0->PA0_OS)
				
	If Found()
			
		BEGIN TRANSACTION
		RecLock("ADE",.F.)
		DbDelete()
		MsUnlock()
		END TRANSACTION
		
		DbSelectArea("ADF")
		DbSetOrder(1)
		DbSeek(xFilial("ADF")+ADE->ADE_CODIGO)
		
		If Found()
		
			Do While !Eof("ADF") .and. ADE->ADE_CODIGO == ADF->ADF_CODIGO
		
				BEGIN TRANSACTION
				RecLock("ADF",.F.)
				DbDelete()
				MsUnlock()
				END TRANSACTION
	
				ADF->(DbSkip())
		
			End Do
		
		Else
					
			lRet := .F.
					
		Endif
			
	Else
				
		lRet := .F.
					
	Endif
	
endif
	
DbSelectArea("PAW")
DbSetOrder(4)
DbSeek(xFilial("PAW")+PA0->PA0_OS)
	
If Found()
	
	Do While !Eof("PAW") .and. PAW->PAW_OS == PA0->PA0_OS
	
		BEGIN TRANSACTION
		RecLock("PAW",.F.)
		DbDelete()
		MsUnlock()
		END TRANSACTION

		PAW->(DbSkip())
	
	End Do
	
Else
				
	lRet := .F.
				
Endif

Return (lRet)