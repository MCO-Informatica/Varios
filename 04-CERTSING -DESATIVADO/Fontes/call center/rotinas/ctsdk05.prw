#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSDK05   บAutor  ณOpvs (David)        บ Data ณ  07/07/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta Dados do GAR                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTSDK05(nPedGar,lJob)

Local aDadosPedido := {}
Local lRet		:= .T. 
Local cAcDesc	:= "" // Descricao AC
Local cArDesc	:= "" // Descricao AR
Local cArId		:= "" // Id Ar
Local cArVld	:= "" // Ar Vld
Local cArVldDesc:= "" // Descricao Ar Vld
Local cDtEmis	:= "" // Data + hora Emissao
Local cDtVld	:= "" // Data + Hora Validacao
Local cDtVrf	:= "" // Data + Hora Verificacao
Local cDesPar	:= "" // Descricao Parceiro
Local cDesRev	:= "" // Descricao Revendedor
Local cMailTit	:= "" // E-mail Titular
Local cGrupo	:= "" // Codigo Grupo
Local cGrupoDesc:= "" // Decricao Grupo
Local cAgVld	:= "" // Nome Agente de Validacao
Local cAgVrf	:= "" // Nome Agente de Verirficacao
Local cTitular  := "" // Nome Titular
Local cPstVlDesc:= "" // Descricao Posto Validacao
Local cPstVrDesc:= "" // Descricao Posto Validacao
Local cProd		:= "" // Codigo Produto
Local cProdDesc	:= "" // Descricao Produto
Local cRzCert	:= "" // Decricao Raxzao Social Cert
Local cRede		:= "" // Rede
Local cStatus	:= "" // Codigo Status
Local cStatusDes:= "" // Descricao do Status
Local cGrpOper	:= "" // Grupo do operador
Local cExibeGar	:= "1" // Campo do grupo de atendimento que indica se deve exibir as informacoes do pedido GAR (WebService)
Local lExibeGar	:= "" // Indica se deve exibir as informacoes do pedido GAR (WebService)
Local cCnpjCert	:= 0  // Cnpj
Local cCodParc	:= 0  // Codigo Parceiro
Local cCodRev	:= 0  // Codigo Revendedor
Local cComisHw	:= 0  // Comissao Hardware
Local cComisSw	:= 0  // Comissao Software
Local cCpfAgVld	:= 0  // Cfp Agente Validacao
Local cCpfAgVrf	:= 0  // Cfp Agente Verificacao
Local cCpfTit	:= 0  // Cpf Titular Certificado
Local cPedido	:= 0  // Numero Pedido
Local cPedAnt	:= 0  // Numero Pedido Antigo
Local cPstVldId	:= 0  // Id de Posto de Validacao     
Local cPstVrfId	:= 0  // Id de Posto de Verificacao
Local cTipoParc	:= 0  // Codigo tipo Parceiro
Local aCoord	:= FwGetDialogSize( oMainWnd )
Local aButtons	:= {}
Local nOpca		:= 0
Local bKeyF6		:= { || Iif( FunName() == "TMKA510A", SetKey( VK_F6, { || U_PESQHIST() } ), .F. ) }
Local cCheckGAR := GetNewPar( "MV_XCHKGAR", "0" ) 

Default lJob:= .T.

If cCheckGAR == "0"
	lRet 	:= .T.
	MsgStop("Consulta ao GAR temporariamente desativada.")
	Return(lRet)
EndIf
    
// Atualiza campo pedido GAR do atendimento com os caracteres e espacos removidos
M->ADE_PEDGAR := nPedGar

// Transforma numero de pedido em valor
nPedGar := iif(valtype(nPedGar) == "C",val(nPedGar),nPedGar)

If !lJob
	// Se deixou em branco, zera total de atendimentos e retorna
	If Vazio()
		M->ADE_XTOTAT := 0
		Return .T.
	EndIf	
	// Se foi chamado da tela de atendimento, desabilita tecla F6 de consulta hist๓rico
	// enquanto realiza comunica็ใo com o GAR via WebService
	If FunName() == "TMKA510A"
		SetKey( VK_F6, { || } )
	EndIf
	FWMsgRun(, { || aDadosPedido := u_ProcWSGAR( nPedGar ) },, "Conectando ao GAR ..." )
Else
	aDadosPedido := u_ProcWSGAR( nPedGar )
EndIf	

cAcDesc		:= aDadosPedido[1]
cArDesc		:= aDadosPedido[2]
cArId		:= aDadosPedido[3]
cArVld		:= aDadosPedido[4]
cArVldDesc	:= aDadosPedido[5]
cDtEmis		:= aDadosPedido[6]
cDtVld		:= aDadosPedido[7]
cDtVrf		:= aDadosPedido[8]
cDesPar		:= aDadosPedido[9]
cDesRev		:= aDadosPedido[10]
cMailTit	:= aDadosPedido[11]
cGrupo		:= aDadosPedido[12]
cGrupoDesc	:= aDadosPedido[13]
cAgVld		:= aDadosPedido[14]
cAgVrf		:= aDadosPedido[15]
cTitular  	:= aDadosPedido[16]
cPstVlDesc	:= aDadosPedido[17]
cPstVrDesc	:= aDadosPedido[18]
cProd		:= aDadosPedido[19]
cProdDesc	:= aDadosPedido[20]
cRzCert		:= aDadosPedido[21]
cRede		:= aDadosPedido[22]
cStatus		:= aDadosPedido[23]
cStatusDes	:= aDadosPedido[24]
cCnpjCert	:= aDadosPedido[25]
cCodParc	:= aDadosPedido[26]
cCodRev		:= aDadosPedido[27]
cComisHw	:= aDadosPedido[28]
cComisSw	:= aDadosPedido[29]
cCpfAgVld	:= aDadosPedido[30]
cCpfAgVrf	:= aDadosPedido[31]
cCpfTit		:= aDadosPedido[32]
cPedido		:= aDadosPedido[33]
cPedAnt		:= aDadosPedido[34]
cPstVldId	:= aDadosPedido[35]
cPstVrfId	:= aDadosPedido[36]
cTipoParc	:= aDadosPedido[37]

If !lJob

	// Atualiza total de atendimentos
	M->ADE_XTOTAT := XTotGar( cPedido )
	
	//Caso numero de pedido exista ้ mostrada tela com a consulta
	If !Empty(cPedido)
                                                       
		// Verifica no grupo de atendimento do operador se exibe tela com dados do pedido GAR
		If SU0->( FieldPos( "U0_XEXBGAR" ) ) > 0
			cGrpOper	:= u_RTmkRetGrp()
			cExibeGAR	:= Posicione( "SU0", 1, xFilial("SU0") + cGrpOper, "U0_XEXBGAR" )
		EndIf

		//Confirma Consulta do pedido Gar, quando o mesmo proviniente da rotina de importacao de mainling.
		//Para as outras situacoes, chamar a interface - Opvs(warleson) - 03/07/12
		If !(FunName() == "IMPORTACAO") .And. cExibeGar <> "2"

			DEFINE MSDIALOG oDlg TITLE "Informa็๕es Pedidos Gar" FROM aCoord[1],aCoord[2] TO aCoord[3], aCoord[4] PIXEL
	
			EnchoiceBar(oDlg, {|| nOpca := 1, oDlg:End() }, {|| nOpca := 2,oDlg:End() },,aButtons)
			                 
			// Cria Objeto de Layer
			oLayer1 := FWLayer():New()
			oLayer1:Init(oDlg,.F.,.T.) 
			
			//Monta as Janelas
			oLayer1:addLine("LINHA1", 100, .F.)
			
			//FATURA
			oLayer1:AddCollumn("Jan",100,.F.,"LINHA1")
			oLayer1:AddWindow("Jan","oJan","Dados do Pedido ",100,.T.,.F.,{ || },"LINHA1",{|| })
			oJan := oLayer1:GetWinPanel("Jan","oJan","LINHA1")  
			
			oTreePed 		:= xTree():New(0,0,0,0,oJan)
			oTreePed:Align 	:= CONTROL_ALIGN_ALLCLIENT
			
			oTreePed:AddTree("Pedido Gar "+cPedido, "FOLDER5","FOLDER6","ID_PRINCIPAL",,,{||})
			
				//Dados Gerais
				oTreePed:TreeSeek("Dados Gerais")
				oTreePed:AddTree("Dados Gerais","BMPVISUAL","BMPVISUAL","dados_gerais",,,)
					oTreePed:AddTreeItem("Ac			: "+cAcDesc					,"UNCHECKED","1.1",,,)
					oTreePed:AddTreeItem("Ar			: "+cArId+"-"+cArDesc		,"UNCHECKED","1.2",,,)
					oTreePed:AddTreeItem("Emissใo		: "+cDtEmis					,"UNCHECKED","1.3",,,)
					oTreePed:AddTreeItem("Cpf Titular	: "+cCpfTit					,"UNCHECKED","1.4",,,)
					oTreePed:AddTreeItem("Email Titular	: "+cMailTit				,"UNCHECKED","1.5",,,)
					oTreePed:AddTreeItem("Nome Titular	: "+cTitular				,"UNCHECKED","1.6",,,)
					oTreePed:AddTreeItem("Produto		: "+cProd+"- "+cProdDesc	,"UNCHECKED","1.7",,,)
					oTreePed:AddTreeItem("Razใo Social	: "+cRzCert					,"UNCHECKED","1.8",,,)
					oTreePed:AddTreeItem("Status		: "+cStatus+"-"+cStatusDes	,"UNCHECKED","1.9",,,)
					oTreePed:AddTreeItem("Cnpj Certif.	: "+cCnpjCert				,"UNCHECKED","1.10",,,)
					oTreePed:AddTreeItem("Pedido Antigo	: "+cPedAnt					,"UNCHECKED","1.11",,,)
				oTreePed:EndTree() 
	
				//Dados Validacao
				oTreePed:TreeSeek("Dados Validacao")
				oTreePed:AddTree("Dados Valida็ใo","BMPVISUAL","BMPVISUAL","dados_validacao",,,)
					oTreePed:AddTreeItem("Ar			: "+cArVld+"- "+cArVldDesc	,"UNCHECKED","1.2",,,)
					oTreePed:AddTreeItem("Data			: "+cDtVld					,"UNCHECKED","1.3",,,)
					oTreePed:AddTreeItem("Agente		: "+cCpfAgVld+"- "+cAgVld		,"UNCHECKED","1.4",,,)
					oTreePed:AddTreeItem("Posto			: "+cPstVldId+"- "+cPstVlDesc,"UNCHECKED","1.5",,,)
				oTreePed:EndTree()
				
				//Dados Verificacao
				oTreePed:TreeSeek("Dados Verificacao")
				oTreePed:AddTree("Dados Verifica็ใo","BMPVISUAL","BMPVISUAL","dados_verificacao",,,)
					oTreePed:AddTreeItem("Data			: "+cDtVrf					,"UNCHECKED","1.3",,,)
					oTreePed:AddTreeItem("Agente		: "+cCpfAgVrf+"- "+cAgVrf		,"UNCHECKED","1.4",,,)
					oTreePed:AddTreeItem("Posto			: "+cPstVrfId+"- "+cPstVrDesc,"UNCHECKED","1.5",,,)
				oTreePed:EndTree()			
				
					
			oTreePed:EndTree()
			
			// Habilita pesquisa F6 para permitir pesquisar hist๓rico de informa็๕es do pedido GAR
			Eval( bKeyF6 )
			
			ACTIVATE MSDIALOG oDlg CENTERED
		Else
			//Confirma Consulta do pedido Gar, quando o mesmo proviniente da rotina de importacao de mainling Opvs(warleson) - 03/07/12
			nOpca := 1
		Endif
		
		If nOpca == 1
		
			If ReadVar() == "M->ADE_PEDGAR"
			
				M->ADE_XAC   	:= cAcDesc 
				M->ADE_XAR 		:= cArId+"-"+cArDesc  
				M->ADE_XDEMIS	:= CtoD(SubStr(cDtEmis,1,10))
				M->ADE_XHEMIS	:= Right(cDtEmis,8)
				M->ADE_XCPFTI	:= cCpfTit
				M->ADE_XMAILT	:= cMailTit
				M->ADE_XNOMTI	:= cTitular
				M->ADE_XPRODG 	:= cProd+"- "+cProdDesc
				M->ADE_XRZSOC  	:= cRzCert
				M->ADE_XSTATG   := cStatus+"-"+cStatusDes
				M->ADE_XCNPJC   := cCnpjCert 
				M->ADE_PEDANT   := cPedAnt
				M->ADE_XARVLD   := cArVld+"- "+cArVldDesc
				M->ADE_XDVLD    := CtoD(SubStr(cDtVld,1,10))
				M->ADE_XHVLD    := Right(cDtVld,8)
				M->ADE_XAGTVL   := cCpfAgVld+"- "+cAgVld
				M->ADE_XPSTVL   := cPstVldId+"- "+cPstVlDesc
				M->ADE_XDTVRF   := CtoD(SubStr(cDtVrf,1,10))
				M->ADE_XHRVRF   := Right(cDtVrf,8)
				M->ADE_XAGTVR  	:= cCpfAgVrf+"- "+cAgVrf
				M->ADE_XPSTVR  	:= cPstVrfId+"- "+cPstVrDesc
				M->ADE_CODSB1	:= Posicione('PA8',1,xFILIAL('PA8')+alltrim(cProd),"PA8_CODMP8") 
				M->ADE_NMPROD	:= Posicione('PA8',1,xFILIAL('PA8')+alltrim(cProd),"PA8_DESMP8") 
				M->ADE_CODPA8	:= alltrim(cProd)
			    
				/*
				dbselectarea('SC5')
				
				SC5->(DbOrderNickName("BPAG")) // Filial+C5_CHVBPAG
				
				If dbseek(xfilial("SC5")+M->ADE_PEDGAR)
					
					dbselectarea('SA1')
					SC5->(dbsetorder(1))
					If dbseek(xfilial("SA1")+SC5->C5_CLIENT+SC5->C5_LOJACLIENT)
						
					Endif
				Endif
				*/		
			EndIf
		
		EndIf 

		lRet := .T.
	Else
		MsgAlert('Pedido GAR n๚mero '+Alltrim(Str(nPedGar))+' nใo encontrado.')
		lRet := .F.
		// Habilita pesquisa F6 para permitir pesquisar hist๓rico de informa็๕es do pedido GAR
		Eval( bKeyF6 )
	EndIf
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSDK05VLD   บAutor  ณMicrosiga           บ Data ณ  08/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que valida pedido gar com ocorrencia SDK            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SDK05VLD(nPedGar,cStatus)
Local lRet 		:= .T.
Local cStatusGar:= ""
Local DesStatGar:= ""
Local cMsg		:= ""
Local oObj

nPedGar := iif(valtype(nPedGar) == "C",val(nPedGar),nPedGar)

WsDldbgLevel(2)

oWs := WSIntegracaoGARERPImplService():New()
oWs:findDadosPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
					 eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
					 nPedGar )

If oWs:oWSdadosPedido:nPedido <> NIL .and. !Empty(cStatus)
	cStatusGar 	:= Alltrim(oWs:oWSdadosPedido:cStatus)
	DesStatGAr	:= Alltrim(oWs:oWSdadosPedido:cStatusDesc)

	If cStatusGar <> cStatus
		cMsg := "Status GAR diferente do Infomado na Ocorr๊ncia."+CRLF
		cMsg += "Status GAR - "+cStatusGar+" - "+DesStatGar+CRLF
		cMsg += "Status Ocorr๊ncia - "+cStatus+" - "+GetcBox('U9_STTGAR',cStatus)+CRLF
		Help(" ",1,"STGARDIF",,cMsg,1,0 )
		lRet := .F.
	EndIf
EndIf
Return(lRet)     
                                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetcBox   บAutor  ณMicrosiga           บ Data ณ  03/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que retorna a decricao ecolhida em um campo         บฑฑ
ฑฑบ          ณ Busca dados em  - (SU9) Tabela de Ocorrencias              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function GetcBox(_cCampo,_cValue)

local nPos
local aRetSx3Box 	:= {}
local nSavOrd 		:= SX3->(IndexOrd())
	SX3->(DbsetOrder(2))
	If SX3->(dbseek(Rtrim(_cCAmpo)))
		aRetSx3Box:= RetSx3Box(X3cBox(),,,1,)
			IF(nPos := Ascan(aRetSx3Box,{|x| x[2] == _cValue })) > 0
			_cValue:= alltrim(aRetSx3Box[nPos,3])
		Endif
	Endif
	SX3->(DbSetOrder(nSavOrd))

Return _cValue


/*
---------------------------------------------------------------------------
| Rotina    | ProcWSGAR    | Autor | Gustavo Prudente | Data | 26.03.2014 |
|-------------------------------------------------------------------------|
| Descricao | Realiza conexao com o GAR e retorna consulta do Webservice  |
|           | de consulta de pedidos.                                     |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function ProcWSGAR( nPedGar )

Local oWs	 		 := nil
Local oDadosPedido	 := nil
Local oObj

Local bVldCtd	:= {|a,b| Iif( a == nil, "", Iif( b == "N", Alltrim( Str( a ) ), a ) )  } // Valida Conteudo 
Local aRet 	:= {}

// Ativa mensagens de LOG no console do server
// WsDldbgLevel( 2 )

//Consulta WebService GAR
oWs := WSIntegracaoGARERPImplService():New()

//Executa M้todo Webservice
oWs:findDadosPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
					 eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
					 nPedGar )

oDadosPedido := oWs:oWsDadosPedido

AAdd( aRet, Eval(bVldCtd,oDadosPedido:cAcDesc,"C" ) )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cArDesc,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cArId,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cArValidacao,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cArValidacaoDesc,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cDataEmissao,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cDataValidacao,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cDataVerificacao,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cDescricaoParceiro,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cDescricaoRevendedor,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cEmailTitular,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cGrupo,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cGrupoDescricao,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cNomeAgenteValidacao,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cNomeAgenteVerificacao,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cNomeTitular,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cPostoValidacaoDesc,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cPostoVerificacaoDesc,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cProduto,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cProdutoDesc,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cRazaoSocialCert,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cRede,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cStatus,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:cStatusDesc,"C") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nCnpjCert,"N") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nCodigoParceiro,"N") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nCodigoRevendedor,"N") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nComissaoParceiroHw,"N") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nComissaoParceiroSw,"N") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nCpfAgenteValidacao,"N") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nCpfAgenteVerificacao,"N") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nCpfTitular,"N") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nPedido,"N") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nPedidoAntigo,"N") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nPostoValidacaoId,"N") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nPostoVerificacaoId,"N") )
AAdd( aRet, Eval(bVldCtd,oDadosPedido:nTipoParceiro,"N") )

Return( aRet )


/*
------------------------------------------------------------------------------
| Rotina    | RemoveChr   | Autor | Gustavo Prudente  | Data | 20.08.2014    |
|----------------------------------------------------------------------------|
| Descricao | Remove espacos e caracteres especiais do numero do pedido GAR  |
|----------------------------------------------------------------------------|
| Parametros| EXPN1 - Numero do pedido GAR                                   |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
Static Function RemoveChr( nPedGar )
                          
// Vetor com caracteres especiais a serem retirados do numero do pedido GAR
Local aChr	:= {	"/", ";", ":", "?", "ฐ", "|", "\", "}", "]", "^", "~", "{", ;
					"[", "`", "ด", "+", "=", "_", "-", ")", "(", "*", "&", "จ", ;
					"ฌ", "ข", "%", "$", "ฃ", "#", "ณ", "@", "ฒ", "!", "น", "'", ;
					"ช", "บ", "<", ",", ">", ".", '"' }

Local nX	:= 0             
Local nLen	:= Len( aChr )
                   
// Remove espacos e caracteres do numero do pedido GAR
nPedGar := LTrim( nPedGar )

For nX := 1 To Len( aChr )   
	If At( aChr[ nX ], nPedGar ) > 0
		nPedGar := StrTran( nPedGar, aChr[ nX ], "" )
	EndIf	
Next nX

Return( nPedGar )



/*
------------------------------------------------------------------------------
| Rotina    | XTotGar     | Autor | Gustavo Prudente  | Data | 16.09.2014    |
|----------------------------------------------------------------------------|
| Descricao | Totaliza atendimentos do pedido GAR informado.                 |
|----------------------------------------------------------------------------|
| Parametros| EXPN1 - Numero do pedido GAR                                   |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
Static Function XTotGar( cPedGar )

Local nRet	 := 0
Local cAlias := Alias()

Default cPedGar := ""

If ! Empty( cPedGar )
	
	BeginSql Alias "TOTGAR"
	
		SELECT COUNT( R_E_C_N_O_ ) AS TOTAL
		FROM %Table:ADE%
		WHERE	ADE_FILIAL = %xFilial:ADE% AND
				ADE_PEDGAR = %Exp:cPedGar% AND
				%notDel%
	
	EndSql
	
	nRet := TOTGAR->TOTAL
	
	TOTGAR->( DbCloseArea() )

EndIf

DbSelectArea( cAlias )

Return( nRet )