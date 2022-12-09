#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch" 
#INCLUDE "FWMVCDEF.CH"   
#INCLUDE "TOPCONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA090  º Autor ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³MVC para o cadastro de logs de processamento de cnabs       º±±
±±º          ³tabelas SZP e SZQ                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs / Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VNDA090()

Local oBrowse := FWMBrowse():New()  

oBrowse:SetAlias("SZP")
oBrowse:SetDescription('CNABs de Retorno')       

oBrowse:Activate()

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ModelDef  º Autor ³                    º Data ³  12/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Modelo de dados para Log de Cnabs                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ºUso       ³ Opvs / Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß     
/*/
Static Function ModelDef()

Local oStruCab := FWFormStruct(1,"SZP")    
Local oStruItem := FWFormStruct(1,"SZQ")    

Local oModel                               

Private cArq := ""

oModel:= MPFormModel():New('CNABMVC', , { |oModel| VldCnbOk( oModel ) },{ |oModel| .T. })    

oModel:AddFields('SZPMASTER',/*owner*/,oStruCab)    
oModel:AddGrid('SZQDETAIL','SZPMASTER',oStruItem) 
oModel:SetDescription('Cnabs')
oModel:GetModel('SZPMASTER'):SetDescription('Arquivo')  
oModel:GetModel('SZQDETAIL'):SetDescription( 'Itens' )
oModel:GetModel('SZQDETAIL'):SetMaxLine( 20000 )   


oModel:SetRelation( 'SZQDETAIL', { { 'ZQ_FILIAL', 'xFilial( "SZQ" )' },{ 'ZQ_ID', 'ZP_ID' } },SZQ->( IndexKey( 1 ) ) )
					  
oModel:SetPrimaryKey( { "ZQ_FILIAL", "ZQ_ID"} )

//oModel:SetVldActivate({ |oModel| ValidaArq(oModel)})
//oStruCab:SetProperty('ZP_ARQUIVO', MODEL_FIELD_INIT, {||mv_par01} )  
oStruCab:SetProperty('ZP_STATUS', MODEL_FIELD_INIT, {||'1'} )  
oStruCab:SetProperty('ZP_ID', MODEL_FIELD_INIT, {||GetSxeNum('SZP','ZP_ID')} )
//oStruItem:SetProperty('ZQ_COR', MODEL_FIELD_INIT, {||loadBitmap(nil,'BR_AMARELO')} )


//oStruCab:AddTrigger ('ZP_ARQUIVO','ZP_ID',,{|oModel| leArq(oModel) })

Return oModel


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ViewDef   º Autor ³                    º Data ³  12/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Interface para consulta log de cnabs                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs / Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ViewDef()

Local oModel := FWLoadModel('VNDA090')   


Local oStruCab := FWFormStruct(2,"SZP")     
Local oStruItem := FWFormStruct(2,"SZQ")  
Local oView 

//oStruItem:AddField('ZQ_COR','1','1','1',{'1'},'C')

oView:= FWFormView():New()                           
oView:SetModel(oModel)                               
oView:SetCloseOnOk({|| .T. })

oView:AddField( 'VIEW_CAB', oStruCab, 'SZPMASTER' )        
oView:AddGrid( 'VIEW_ITEM', oStruItem, 'SZQDETAIL' )
oView:AddUserButton( 'Pesquisar', 'PESQUISA', {|oView| Pesquisar(oModel)} )
oView:AddUserButton( 'Tracker', 'BMPVISUAL', {|oView| Tracker(oModel)} )

    
oView:CreateHorizontalBox( 'SUPERIOR', 20 )
oView:CreateHorizontalBox( 'INFERIOR', 80 )

oView:SetOwnerView( 'VIEW_CAB', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_ITEM', 'INFERIOR' )

Return oView
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef   º Autor ³                    º Data ³  12/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Menu para log de cnabs                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs / Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
Static Function MenuDef()  

Local aRotina  := {}

ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.VNDA090' OPERATION 2 ACCESS 0  
ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.VNDA250' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Processar'    Action 'U_VNDA200()' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Conhecimento'    Action "U_MsDocCert('SZP',SZP->(RECNO()),4)" OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Imprimir' Action 'VIEWDEF.VNDA090' OPERATION 8 ACCESS 0


Return aRotina                   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pesquisar º Autor ³                    º Data ³  12/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Pesquisa um registro de acordo com parametro.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs / Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Pesquisar(oModel)

Local cCampo := ""          

IF Pergunte("PESCNAB")

	IF mv_par02 == 1
	
		cCampo := 'ZQ_PEDIDO'
		
	Elseif mv_par02 == 2
	
		cCampo := 'ZQ_NF1'
		
	Elseif mv_par02 == 3
	
		cCampo := 'ZQ_NF2'
		
	Elseif mv_par02 == 4 	
		cCampo := 'ZQ_LINHA'
		
	Else
		cCampo := 'ZQ_STATUS'
		
	Endif  
	

	
	oModel:GetModel('SZQDETAIL'):SeekLine({{cCampo,Alltrim(mv_par01)}})


Endif

Return                                                    



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MsDocument³ Autor ³ Sergio Silveira       ³ Data ³06/12/2000  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Amarracao entidades x documentos                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 -> Entidade                                            ³±±
±±³          ³ ExpN1 -> Registro                                            ³±±
±±³          ³ ExpN2 -> Opcao                                               ³±±
±±³          ³ ExpX1 -> Sem Funcao                                          ³±±
±±³          ³ ExpN5 -> Tipo de Operacao                                    ³±±
±±³          ³ ExpA6 -> Array de referencia retorno dos anexos ( Recno )    ³±±
±±³          ³ ExpL7 -> Flag que indica se abre as planilhas Excel          ³±±
±±³          ³          conectadas ao Protheus.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MsDocCert( cAlias, nReg, nOpc, xVar, nOper, aRecACB , lExcelConnect)

Local aRecAC9      := {}
Local aPosObj      := {}
Local aPosObjMain  := {}
Local aObjects     := {}
Local aSize        := {}
Local aInfo        := {}
Local aGet		   := {}
Local aTravas      := {}
Local aEntidade    := {}
Local aArea        := GetArea()
Local aExclui      := {}
Local aButtons     := {}
Local aUsButtons   := {} 
Local aChave       := {}
Local aButtPE      := {}

Local cCodEnt      := ""
Local cCodDesc     := ""
Local cNomEnt      := ""
Local cEntidade    := "" 
Local cUnico       := "" 

Local lMTCONHEC   := ExistBlock('MTCONHEC')
Local lGravou      := .F.
Local lTravas      := .T.
Local lVisual      := .T. //( aRotina[ nOpc, 4 ] == 2 ) 
Local lAchou       := .F.   
Local lRetCon      := .T.
Local lRet		   := .T.
Local lRemotLin	   := GetRemoteType() == 2 //Checa se o Remote e Linux 

Local nCntFor      := 0
Local nGetCol      := 0
Local nOpcA	       := 0
Local nScan        := 0

Local oDlg
Local oGetD
Local oGet
Local oGet2
Local oOle
Local oScroll, lRetu

Local	cQuery    := ""
Local	cSeek     := ""
Local	cWhile    := ""
Local aNoFields := {"AC9_ENTIDA","AC9_CODENT"}									      // Campos que nao serao apresentados no aCols
Local bCond     := {|| .T.}														      	// Se bCond .T. executa bAction1, senao executa bAction2
Local bAction1  := {|| MsVerAC9(@aTravas,@aRecAC9,@aRecACB,lTravas,nOper) }	// Retornar .T. para considerar o registro e .F. para desconsiderar
Local bAction2  := {|| .F. }
Local lVisPE	:= lVisual															      // Retornar .T. para considerar o registro e .F. para desconsiderar

DEFAULT aRecAC9    		:= {}
DEFAULT aRecACB    		:= {}
DEFAULT nOper      		:= 1
DEFAULT lExcelConnect	:= .F.

PRIVATE aCols      := {}
PRIVATE aHeader    := {}
PRIVATE INCLUI     := .F.           

PRIVATE aRotina := {	{ "Pesquisar",	"AxPesqui", 	0, 1	},;
						{ "Visualizar",	"AxVisual",	0, 2	},;
						{ "Incluir",	"AxInclui",	0, 3	},;
						{ "Alterar",	"AxAltera",	0, 4, 2	},;
					}                                          
Private cCadastro := "Base de Conhecimento"
AAdd( aButtons, { "PRODUTO", { || MsDocSize( @oScroll, @oOle, aPosObjMain, aPosObj[2], @aHide ) }, "" } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada validar o acesso a rotina quando chamada pelo menu |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MTVLDACE")
    lRet := ExecBlock("MTVLDACE",.F.,.F.)
    If ValType(lRetCon) <> "L"
       lRet := .T.
    EndIf
    If !lRet
	    Return .F.
    EndIf	    
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para bloquear o botão "Banco Conhecimento para alguns usuários |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		       
If lMTCONHEC
    lRetCon := ExecBlock('MTCONHEC', .F., .F.)    
	    
    If ValType(lRetCon) <> "L"
       lRetCon := .T.
    EndIf
	    
EndIf
	 
If lRetCon   
	AAdd( aButtons, { "NORMAS" , { || MsDocCall() }, "Abrir", "Banco de Conhecimento" } )  //"Banco de Conhecimento"
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona botoes do usuario na EnchoiceBar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "MSDOCBUT" ) 
	If ValType( aUsButtons := ExecBlock( "MSDOCBUT", .F., .F., { cAlias } ) ) == "A"
		AEval( aUsButtons, { |x| AAdd( aButtons, x ) } ) 	 	
	EndIf 	
EndIf 	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona a entidade                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cEntidade := cAlias

dbSelectArea( cEntidade )
MsGoto( nReg )

aEntidade := MsRelation()

nScan := AScan( aEntidade, { |x| x[1] == cEntidade } )

lAchou := .F. 

If Empty( nScan ) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza a chave unica pelo SX2                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
	SX2->( dbSetOrder( 1 ) ) 
	If SX2->( dbSeek( cEntidade ) )  
	
		If !Empty( SX2->X2_UNICO )       
		   
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Macro executa a chave unica                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
			cUnico   := SX2->X2_UNICO 
			cCodEnt  := &cUnico 
			cCodDesc := Substr( AllTrim( cCodEnt ), TamSX3("A1_FILIAL")[1] + 1 )  
			lAchou   := .T. 
				 
		EndIf 					
	
	EndIf 	   

Else 

	aChave   := aEntidade[ nScan, 2 ]
	cCodEnt  := MaBuildKey( cEntidade, aChave ) 
	
	cCodDesc := AllTrim( cCodEnt ) + "-" + Capital( Eval( aEntidade[ nScan, 3 ] ) )    
	
	lAchou := .T. 
 
EndIf 
	
If lAchou 	

	cCodEnt  := PadR( cCodEnt, TamSX3("AC9_CODENT")[1] )
	
	dbSelectArea("AC9")
	dbSetOrder(2)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Prepara variaveis para FillGetDados                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		cQuery += "SELECT AC9.*,AC9.R_E_C_N_O_ AC9RECNO FROM " + RetSqlName( "AC9" ) + " AC9 "
		cQuery += "WHERE "
		cQuery += "AC9_FILIAL='" + xFilial( "AC9" )     + "' AND "
		cQuery += "AC9_FILENT='" + xFilial( cEntidade ) + "' AND "
		cQuery += "AC9_ENTIDA='" + cEntidade            + "' AND "
		cQuery += "AC9_CODENT='" + cCodEnt              + "' AND "				
		cQuery += "D_E_L_E_T_<>'*' ORDER BY " + SqlOrder( AC9->( IndexKey() ) )
	#ENDIF 
	cSeek  := xFilial( "AC9" ) + cEntidade + xFilial( cEntidade ) + cCodEnt
	cWhile := "AC9->AC9_FILIAL + AC9->AC9_ENTIDA + AC9->AC9_FILENT + AC9->AC9_CODENT"
	
	
	Do Case
	Case nOper == 1

		SX2->( dbSetOrder( 1 ) )
		SX2->( DbSeek( cEntidade ) )

		cNomEnt := Capital( X2NOME() )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do Array do Cabecalho                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek("AA2_CODTEC")
		aadd(aGet,{X3Titulo(),SX3->X3_PICTURE,SX3->X3_F3})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem do aHeader e aCols                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FillGetDados( nOpcx, cAlias, nOrder, cSeekKey, bSeekWhile, uSeekFor, aNoFields, aYesFields, lOnlyYes,		³
		//³				  cQuery, bMountFile, lInclui )																	³
		//³nOpcx			- Opcao (inclusao, exclusao, etc). 															³
		//³cAlias		- Alias da tabela referente aos itens															³
		//³nOrder		- Ordem do SINDEX																				³
		//³cSeekKey		- Chave de pesquisa																				³
		//³bSeekWhile	- Loop na tabela cAlias																			³
		//³uSeekFor		- Valida cada registro da tabela cAlias (retornar .T. para considerar e .F. para desconsiderar 	³
		//³				  o registro)																					³
		//³aNoFields	- Array com nome dos campos que serao excluidos na montagem do aHeader							³
		//³aYesFields	- Array com nome dos campos que serao incluidos na montagem do aHeader							³
		//³lOnlyYes		- Flag indicando se considera somente os campos declarados no aYesFields + campos do usuario	³
		//³cQuery		- Query para filtro da tabela cAlias (se for TOP e cQuery estiver preenchido, desconsidera      ³
		//³	           parametros cSeekKey e bSeekWhiele) 																³
		//³bMountFile	- Preenchimento do aCols pelo usuario (aHeader e aCols ja estarao criados)						³
		//³lInclui		- Se inclusao passar .T. para qua aCols seja incializada com 1 linha em branco					³
		//³aHeaderAux	-																								³
		//³aColsAux		-																								³
		//³bAfterCols	- Bloco executado apos inclusao de cada linha no aCols											³
		//³bBeforeCols	- Bloco executado antes da inclusao de cada linha no aCols										³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("AC9")
		dbSetOrder(2)
		dbGoTop()
		
		If Tcsrvtype()=="AS/400"  //AS/400 para TOP2 e iSeries para AS/400 TOP4
			FillGetDados(nOpc,"AC9",2,cSeek,{|| &cWhile },{{bCond,bAction1,bAction2}},aNoFields,/*aYesFields*/,/*lOnlyYes*/,,/*bMontCols*/,/*Inclui*/,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/,/*bBeforeCols*/)
        Else
        	FillGetDados(nOpc,"AC9",2,cSeek,{|| &cWhile },{{bCond,bAction1,bAction2}},aNoFields,/*aYesFields*/,/*lOnlyYes*/,cQuery,/*bMontCols*/,/*Inclui*/,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/,/*bBeforeCols*/)
        Endif
		If ( lTravas )

			aSize := MsAdvSize( )

			aObjects := {}	
			AAdd( aObjects, { 100, 100, .T., .T. } )

			aInfo       := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
			aPosObjMain := MsObjSize( aInfo, aObjects )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Resolve os objetos lateralmente                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aObjects := {}	            		

			AAdd( aObjects, { 150, 100, .T., .T. } )
			AAdd( aObjects, { 100, 100, .T., .T., .T. } )

			aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 4, 4 }
			aPosObj := MsObjSize( aInfo, aObjects, .T. , .T. )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Resolve os objetos da parte esquerda                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aInfo   := { aPosObj[1,2], aPosObj[1,1], aPosObj[1,4], aPosObj[1,3], 0, 4, 0, 0 }

			aObjects := {}
			AAdd( aObjects, { 100,  53, .T., .F., .T. } )
			AAdd( aObjects, { 100, 100, .T., .T. } )

			aPosObj2 := MsObjSize( aInfo, aObjects )

			aHide := {}
            
			lVisual := ( nOpc == 2 ) 

			If !lVisual .And. ExistBlock("MSDOCVIS")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ MSDOCVIS - Ponto de Entrada utilizado para somente visualizar o Conhecimento  |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lVisual := If(ValType(lVisual:=ExecBlock("MSDOCVIS",.F.,.F.))=='L',lVisual,.F.)
			EndIf	

			INCLUI  := .T.

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Botao do Wizard de inclusao e associacao                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !lVisual
				AAdd( aButtons, { "MPWIZARD" , { || MsDocWizard( @oGetD ) }, "Inclui conhecimento - Wizard", "Wizard" } ) // "Inclui conhecimento - Wizard", "Wizard"
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ PE usado para impedir que usuarios não autorizados e com status diferente 
			//  de somente "visualiza" possa Excluir o conhecimento.
			// Se a Função retornar .F. o usuario pode incluir, excluir. Se voltar .T. 
			// somente pode incluir.
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   			lVisPE	:= lVisual         

			If ExistBlock("MSDOCEXC") .AND. lVisual = .F.
				lVisPE := iF(ValType(lretu:=ExecBlock("MSDOCEXC",.F.,.F.))=='L',lRetu,lVisual)
			EndIf 

			If ExistBlock("MTENCBUT")
		    	aButtPE := ExecBlock("MTENCBUT",.F.,.F.,{aButtons})
			    If ValType(aButtPE) == "A" 
				    aButtons := aButtPE                            
			    EndIf
			EndIf 

			DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

			@ 0, 0 BITMAP oBmp RESOURCE "PROJETOAP" of oDlg SIZE 100,1000 PIXEL

			@ aPosObj2[1,1],aPosObj2[1,2] MSPANEL oPanel PROMPT "" SIZE aPosObj2[1,3],aPosObj2[1,4] OF oDlg CENTERED LOWERED //"Botoes"

			nGetCol := 40

			@ 004,005 SAY "Entidade"        SIZE 040,009 OF oPanel  PIXEL // "Entidade" //"Entidade"
			@ 013,005 GET oGet  VAR cNomEnt  SIZE 090,009 OF oPanel PIXEL WHEN .F.	

			@ 027,005 SAY "Descricao"        SIZE 040,009 OF oPanel PIXEL // "Codigo" //"Descricao"
			@ 036,005 GET oGet2 VAR cCodDesc SIZE aPosObj2[1,3] - 60,009 OF oPanel PIXEL WHEN .F.	

			oGetd:=MsGetDados():New(aPosObj2[2,1],aPosObj2[2,2],aPosObj2[2,3],aPosObj2[2,4], nOpc,"MsDocLok","AlwaysTrue",,!lVisPE,NIL,NIL,NIL,1000)
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ A classe scrollbox esta com o size invertido...                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oScroll := TScrollBox():New( oDlg, aPosObj[2,1], aPosObj[2,2], aPosObj[2,4],aPosObj[2,3])

			oOle    := TOleContainer():New( 0, 0, aPosObj2[2,3],aPosObj2[2,4],oScroll, , "" )
			oOle:Hide()

			oScroll:Cargo := 1                                                                                                                                                                                       

			If !lRemotLin
				@  17.5, aPosObj2[1,3] - 40  BUTTON oButPrev PROMPT "Preview" SIZE 035,012 FONT oDlg:oFont ACTION     ( If( !Empty( AllTrim( GDFieldGet( "AC9_OBJETO" ) ) ), ( oGetd:oBrowse:SetFocus(), MsFlPreview( oOle, @aExclui ) ), .T. ) ) OF oPanel PIXEL     // "Preview"
				If lExcelConnect // Tratamento para abertura de Planilhas Excel conactadas do Protheus - SIGAPCO
					@ 34.5, aPosObj2[1,3] - 40  BUTTON oButOpen PROMPT "Abrir"   SIZE 035,012 FONT oDlg:oFont ACTION ( If( !Empty( AllTrim( GDFieldGet( "AC9_OBJETO" ) ) ), ( oGetd:oBrowse:SetFocus(), PcoXlsOpen( @oOle, @aExclui ) ), .T. ) ) OF oPanel PIXEL     //"Abrir"
				Else
					@ 34.5, aPosObj2[1,3] - 40  BUTTON oButOpen PROMPT "Abrir"   SIZE 035,012 FONT oDlg:oFont ACTION ( If( !Empty( AllTrim( GDFieldGet( "AC9_OBJETO" ) ) ), ( oGetd:oBrowse:SetFocus(), MsDocOpen( @oOle, @aExclui ) ), .T. ) )  OF oPanel PIXEL     //"Abrir"
				EndIf
			Else
				@ 34.5, aPosObj2[1,3] - 40  BUTTON oButOpen PROMPT "Abrir"   SIZE 035,012 FONT oDlg:oFont ACTION ( If( !Empty( AllTrim( GDFieldGet( "AC9_OBJETO" ) ) ), ( oGetd:oBrowse:SetFocus(), MsDocOpen( @oOle, @aExclui ) ), .T. ) )  OF oPanel PIXEL     //"Abrir"
			EndIf
			                                                                                    
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona ao array dos objetos que devem ser escondidos                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AAdd( aHide, oPanel )
			AAdd( aHide, oGetD  )
			If !lRemotLin
				AAdd( aHide, oButPrev )
			EndIf
			AAdd( aHide, oButOpen ) 		

			n := 1

			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()},, aButtons )

			If ( nOpcA == 1 ) .And. !lVisual 
				Begin Transaction
					lGravou := MsDocGrv( cEntidade, cCodEnt, aRecAC9 )
					If ( lGravou )
						EvalTrigger()
						If ( __lSx8 )
							ConfirmSx8()
						EndIf
						If ExistBlock( "MSDOCOK" ) 
			    			ExecBlock("MSDOCOK",.F.,.F.,{cAlias, nReg})
						EndIf 	
					EndIf
				End Transaction
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui os temporarios      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty( aExclui )
				MsDocExclui( aExclui, .F. )
			EndIf 			

		EndIf
		If ( __lSx8 )
			RollBackSx8()
		EndIf
		For nCntFor := 1 To Len(aTravas)
			dbSelectArea(aTravas[nCntFor][1])
			dbGoto(aTravas[nCntFor][2])
			MsUnLock()
		Next nCntFor

	Case nOper == 3
		MsDocGrv( cEntidade, cCodEnt, , .T. )
	Case nOper == 4 	
		MsDocArray( cEntidade, cCodEnt, , , , ,@aRecACB )	
	EndCase

Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se nao inclusao, permite a exibicao de mensagens em tela               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOper == 1
		Aviso( "Atencao !", "Nao existe chave de relacionamento definida para o alias " + cAlias, { "OK" } ) 	 //"Atencao !"###"Nao existe chave de relacionamento definida para o alias "###"Ok"
	EndIf

EndIf

RestArea( aArea )

Return(lGravou)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FtVerAC9  ³ Autor ³ Marco Bianchi         ³ Data ³02/01/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao disparada para validar cada registro da tabela      ³±±
±±³          ³ AC9, adicionar recno no array aRecAC9 utilizado na gravacao³±±
±±³          ³ cao da tabela AC9 e verificar se conseguiu travar AC9.     ³±±
±±³          ³ Se retornar .T. considera o registro.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Logico                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array com numero dos registros da tabela AC8         ³±±
±±³          ³ExpA2: Array coim registros travados do AC8                 ³±±
±±³          ³ExpL3: .T. se conseguiu travar AC8                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MsVerAC9(aTravas,aRecAC9,aRecACB,lTravas,nOper)

Local nTipo := IIf(nOper == 1,2,1)
Local lRet := .T.
Local lMsDocFil := Existblock("MSDOCFIL")
Local nRecNoAC9

#IFDEF TOP
If Upper(tcsrvtype())#"AS/400"
	nRecNoAC9 := AC9RECNO
	AC9->( dbGoto( nRecNoAC9 ) )
Endif
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o Acols para exibicao                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo == 2
	If ( SoftLock("AC9" ) )
		AAdd(aTravas,{ Alias() , RecNo() })
	Else
		lTravas := .F.
	EndIf
EndIf
AAdd(aRecAC9, AC9->( Recno() ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o Array de recnos do banco de conhecimento                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTipo == 1
	ACB->( dbSetOrder( 1 ) )
	If ACB->( dbSeek( xFilial( "ACB" ) + AC9->AC9_CODOBJ ) )
		AAdd( aRecACB, ACB->( RecNo() ) )
	EndIf
	lRet := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada pata filtro do usuario. Se retornar .T. considera o   ³
//³ registro do AC9, senao pula o registro.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMsDocFil
	lRet := ExecBlock("MSDOCFIL",.F.,.F.,{AC9->(Recno())})
	If ValType(lRet) <> "L"
		lRet := .T.
	EndIf
EndIf	

Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tracker   º Autor ³                    º Data ³  12/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tracker para pedido                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs / Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Tracker(oModel)

Local aEnt := {}
Local cPedido := ""
Local nPosItem := 0
Local nLoop := 1
Local cQuery := ""

DbSelectArea("SC5")

//SC5->(DbSetOrder(8))
SC5->(DbOrderNickName("PEDSITE"))//Alterado por LMS em 03-01-2013 para virada de versão
   
IF SC5->(DbSeek(xFilial("SC5")+Alltrim(oModel:GetValue('SZQDETAIL','ZQ_PEDIDO'))))
   
	cQuery := "SELECT SC6.C6_ITEM "
	cQuery += "FROM "
	cQuery += "	"+RetSqlName("SC6")+" SC6 " 
	cQuery += "WHERE SC6.C6_NUM = '"+Alltrim(SC5->C5_NUM)+"' AND SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.D_E_L_E_T_ =' '"
	
	cQuery := ChangeQuery(cQuery)
	TCQUERY cQuery NEW ALIAS "TMPSC6"

	DbSelectArea("TMPSC6")

	If TMPSC6->(!Eof())
		TMPSC6->(DbGoTop())
		While TMPSC6->(!Eof())   
		
			AAdd ( aEnt, {"SC6",Alltrim(SC5->C5_NUM) + TMPSC6->C6_ITEM})
			
			TMPSC6->(DbSkip())
		
		Enddo
	Endif
		
	DbSelectArea("TMPSC6")
	TMPSC6->(DbCloseArea())	
	
	MatrkShow(aEnt)
Else
	MsgAlert("Não foram encontrados Dados para Rastreamento!")
Endif

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldCnbOk  º Autor ³Opvs David          º Data ³  28/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Realiza a gravação do modelo no banco.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs / Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function VldCnbOk(oModel)
Local lRet 		:= .T.
Local cArq		:= oModel:GetValue("SZPMASTER","ZP_ARQUIVO") 
Local cSql		:= ""
Local cIdQry	:= ""

If Empty(cArq)           
    Help( , , 'VldCnbOk', , "Obrigatório informar um Arquivo", 1, 0)
	lRet := .F.
ElseIf !File(cArq)
		Help( , , 'VldCnbOk', , "Arquivo Não Encontrado no Diretório Informado", 1, 0)
		lRet := .F.
Else
	cSql := " SELECT " 
	cSql += "   ZP_ID " 
	cSql += " FROM " 
	cSql += RetSqlName("SZP") 
	cSql += " WHERE 
	cSql += "   ZP_FILIAL = '"+xFilial("SZP")+"' AND 
	cSql += "   UPPER(ZP_ARQUIVO)  = '"+Upper(cArq)+"' AND
	cSql += "   D_E_L_E_T_ = ' '	
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"QRYSZP",.F.,.T.)
	
	If !QRYSZP->(Eof())
	 	QRYSZP->(DbEval({|| cIdQry += " "+QRYSZP->ZP_ID      }))
	
		Help( , , 'VldCnbOk', , "Arquivo já utilizado nos seguintes Códigos:"+cIdQry, 1, 0)
		lRet := .F.
		
	EndIf
	
	QRYSZP->(DbCloseArea())

EndIf

Return(lRet)