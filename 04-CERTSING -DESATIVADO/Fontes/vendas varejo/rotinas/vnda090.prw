#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch" 
#INCLUDE "FWMVCDEF.CH"   
#INCLUDE "TOPCONN.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA090  � Autor �                    � Data �             ���
�������������������������������������������������������������������������͹��
���Descricao �MVC para o cadastro de logs de processamento de cnabs       ���
���          �tabelas SZP e SZQ                                           ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function VNDA090()

Local oBrowse := FWMBrowse():New()  

oBrowse:SetAlias("SZP")
oBrowse:SetDescription('CNABs de Retorno')       

oBrowse:Activate()

Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ModelDef  � Autor �                    � Data �  12/12/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Modelo de dados para Log de Cnabs                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���          �                                                            ���
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������     
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ViewDef   � Autor �                    � Data �  12/12/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Interface para consulta log de cnabs                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   � Autor �                    � Data �  12/12/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Menu para log de cnabs                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Pesquisar � Autor �                    � Data �  12/12/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Pesquisa um registro de acordo com parametro.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Programa  �MsDocument� Autor � Sergio Silveira       � Data �06/12/2000  ���
���������������������������������������������������������������������������Ĵ��
���Descricao � Amarracao entidades x documentos                             ���
���������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                       ���
���������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 -> Entidade                                            ���
���          � ExpN1 -> Registro                                            ���
���          � ExpN2 -> Opcao                                               ���
���          � ExpX1 -> Sem Funcao                                          ���
���          � ExpN5 -> Tipo de Operacao                                    ���
���          � ExpA6 -> Array de referencia retorno dos anexos ( Recno )    ���
���          � ExpL7 -> Flag que indica se abre as planilhas Excel          ���
���          �          conectadas ao Protheus.                             ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                     ���
���������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
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

//���������������������������������������������������������������������Ŀ
//� Ponto de entrada validar o acesso a rotina quando chamada pelo menu |
//�����������������������������������������������������������������������
If ExistBlock("MTVLDACE")
    lRet := ExecBlock("MTVLDACE",.F.,.F.)
    If ValType(lRetCon) <> "L"
       lRet := .T.
    EndIf
    If !lRet
	    Return .F.
    EndIf	    
EndIf

//��������������������������������������������������������������������������������Ŀ
//�Ponto de entrada para bloquear o bot�o "Banco Conhecimento para alguns usu�rios |
//����������������������������������������������������������������������������������
		       
If lMTCONHEC
    lRetCon := ExecBlock('MTCONHEC', .F., .F.)    
	    
    If ValType(lRetCon) <> "L"
       lRetCon := .T.
    EndIf
	    
EndIf
	 
If lRetCon   
	AAdd( aButtons, { "NORMAS" , { || MsDocCall() }, "Abrir", "Banco de Conhecimento" } )  //"Banco de Conhecimento"
EndIf


//������������������������������������������������������������������������Ŀ
//� Adiciona botoes do usuario na EnchoiceBar                              �
//��������������������������������������������������������������������������
If ExistBlock( "MSDOCBUT" ) 
	If ValType( aUsButtons := ExecBlock( "MSDOCBUT", .F., .F., { cAlias } ) ) == "A"
		AEval( aUsButtons, { |x| AAdd( aButtons, x ) } ) 	 	
	EndIf 	
EndIf 	

//������������������������������������������������������������������������Ŀ
//� Posiciona a entidade                                                   �
//��������������������������������������������������������������������������
cEntidade := cAlias

dbSelectArea( cEntidade )
MsGoto( nReg )

aEntidade := MsRelation()

nScan := AScan( aEntidade, { |x| x[1] == cEntidade } )

lAchou := .F. 

If Empty( nScan ) 

	//������������������������������������������������������������������������Ŀ
	//� Localiza a chave unica pelo SX2                                        �
	//��������������������������������������������������������������������������  
	SX2->( dbSetOrder( 1 ) ) 
	If SX2->( dbSeek( cEntidade ) )  
	
		If !Empty( SX2->X2_UNICO )       
		   
			//������������������������������������������������������������������������Ŀ
			//� Macro executa a chave unica                                            �
			//��������������������������������������������������������������������������  
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
	
	//������������������������������������������������������������������������Ŀ
	//�Prepara variaveis para FillGetDados                                     �
	//��������������������������������������������������������������������������
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

		//������������������������������������������������������������������������Ŀ
		//�Montagem do Array do Cabecalho                                          �
		//��������������������������������������������������������������������������
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek("AA2_CODTEC")
		aadd(aGet,{X3Titulo(),SX3->X3_PICTURE,SX3->X3_F3})

		//�������������������������������������������������������Ŀ
		//� Montagem do aHeader e aCols                           �
		//���������������������������������������������������������    
		//�������������������������������������������������������������������������������������������������������������Ŀ
		//�FillGetDados( nOpcx, cAlias, nOrder, cSeekKey, bSeekWhile, uSeekFor, aNoFields, aYesFields, lOnlyYes,		�
		//�				  cQuery, bMountFile, lInclui )																	�
		//�nOpcx			- Opcao (inclusao, exclusao, etc). 															�
		//�cAlias		- Alias da tabela referente aos itens															�
		//�nOrder		- Ordem do SINDEX																				�
		//�cSeekKey		- Chave de pesquisa																				�
		//�bSeekWhile	- Loop na tabela cAlias																			�
		//�uSeekFor		- Valida cada registro da tabela cAlias (retornar .T. para considerar e .F. para desconsiderar 	�
		//�				  o registro)																					�
		//�aNoFields	- Array com nome dos campos que serao excluidos na montagem do aHeader							�
		//�aYesFields	- Array com nome dos campos que serao incluidos na montagem do aHeader							�
		//�lOnlyYes		- Flag indicando se considera somente os campos declarados no aYesFields + campos do usuario	�
		//�cQuery		- Query para filtro da tabela cAlias (se for TOP e cQuery estiver preenchido, desconsidera      �
		//�	           parametros cSeekKey e bSeekWhiele) 																�
		//�bMountFile	- Preenchimento do aCols pelo usuario (aHeader e aCols ja estarao criados)						�
		//�lInclui		- Se inclusao passar .T. para qua aCols seja incializada com 1 linha em branco					�
		//�aHeaderAux	-																								�
		//�aColsAux		-																								�
		//�bAfterCols	- Bloco executado apos inclusao de cada linha no aCols											�
		//�bBeforeCols	- Bloco executado antes da inclusao de cada linha no aCols										�
		//���������������������������������������������������������������������������������������������������������������
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

			//������������������������������������������������������������������������Ŀ
			//� Resolve os objetos lateralmente                                        �
			//��������������������������������������������������������������������������
			aObjects := {}	            		

			AAdd( aObjects, { 150, 100, .T., .T. } )
			AAdd( aObjects, { 100, 100, .T., .T., .T. } )

			aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 4, 4 }
			aPosObj := MsObjSize( aInfo, aObjects, .T. , .T. )

			//������������������������������������������������������������������������Ŀ
			//� Resolve os objetos da parte esquerda                                   �
			//��������������������������������������������������������������������������
			aInfo   := { aPosObj[1,2], aPosObj[1,1], aPosObj[1,4], aPosObj[1,3], 0, 4, 0, 0 }

			aObjects := {}
			AAdd( aObjects, { 100,  53, .T., .F., .T. } )
			AAdd( aObjects, { 100, 100, .T., .T. } )

			aPosObj2 := MsObjSize( aInfo, aObjects )

			aHide := {}
            
			lVisual := ( nOpc == 2 ) 

			If !lVisual .And. ExistBlock("MSDOCVIS")
				//�������������������������������������������������������������������������������Ŀ
				//� MSDOCVIS - Ponto de Entrada utilizado para somente visualizar o Conhecimento  |
				//���������������������������������������������������������������������������������
				lVisual := If(ValType(lVisual:=ExecBlock("MSDOCVIS",.F.,.F.))=='L',lVisual,.F.)
			EndIf	

			INCLUI  := .T.

			//������������������������������������������������������������������������Ŀ
			//� Botao do Wizard de inclusao e associacao                               �
			//��������������������������������������������������������������������������
			If !lVisual
				AAdd( aButtons, { "MPWIZARD" , { || MsDocWizard( @oGetD ) }, "Inclui conhecimento - Wizard", "Wizard" } ) // "Inclui conhecimento - Wizard", "Wizard"
			EndIf

			//������������������������������������������������������������������������Ŀ
			//� PE usado para impedir que usuarios n�o autorizados e com status diferente 
			//  de somente "visualiza" possa Excluir o conhecimento.
			// Se a Fun��o retornar .F. o usuario pode incluir, excluir. Se voltar .T. 
			// somente pode incluir.
			//��������������������������������������������������������������������������
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
		
			//������������������������������������������������������������������������Ŀ
			//� A classe scrollbox esta com o size invertido...                        �
			//��������������������������������������������������������������������������
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
			                                                                                    
			//������������������������������������������������������������������������Ŀ
			//� Adiciona ao array dos objetos que devem ser escondidos                 �
			//��������������������������������������������������������������������������
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

			//����������������������������Ŀ
			//� Exclui os temporarios      �
			//������������������������������
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
	//������������������������������������������������������������������������Ŀ
	//� Se nao inclusao, permite a exibicao de mensagens em tela               �
	//��������������������������������������������������������������������������
	If nOper == 1
		Aviso( "Atencao !", "Nao existe chave de relacionamento definida para o alias " + cAlias, { "OK" } ) 	 //"Atencao !"###"Nao existe chave de relacionamento definida para o alias "###"Ok"
	EndIf

EndIf

RestArea( aArea )

Return(lGravou)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FtVerAC9  � Autor � Marco Bianchi         � Data �02/01/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao disparada para validar cada registro da tabela      ���
���          � AC9, adicionar recno no array aRecAC9 utilizado na gravacao���
���          � cao da tabela AC9 e verificar se conseguiu travar AC9.     ���
���          � Se retornar .T. considera o registro.                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Logico                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpA1: Array com numero dos registros da tabela AC8         ���
���          �ExpA2: Array coim registros travados do AC8                 ���
���          �ExpL3: .T. se conseguiu travar AC8                          ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//������������������������������������������������������������������������Ŀ
//� Cria o Acols para exibicao                                             �
//��������������������������������������������������������������������������
If nTipo == 2
	If ( SoftLock("AC9" ) )
		AAdd(aTravas,{ Alias() , RecNo() })
	Else
		lTravas := .F.
	EndIf
EndIf
AAdd(aRecAC9, AC9->( Recno() ) )

//������������������������������������������������������������������������Ŀ
//� Cria o Array de recnos do banco de conhecimento                        �
//��������������������������������������������������������������������������
If nTipo == 1
	ACB->( dbSetOrder( 1 ) )
	If ACB->( dbSeek( xFilial( "ACB" ) + AC9->AC9_CODOBJ ) )
		AAdd( aRecACB, ACB->( RecNo() ) )
	EndIf
	lRet := .F.
EndIf

//������������������������������������������������������������������������Ŀ
//� Ponto de entrada pata filtro do usuario. Se retornar .T. considera o   �
//� registro do AC9, senao pula o registro.                                �
//��������������������������������������������������������������������������
If lMsDocFil
	lRet := ExecBlock("MSDOCFIL",.F.,.F.,{AC9->(Recno())})
	If ValType(lRet) <> "L"
		lRet := .T.
	EndIf
EndIf	

Return(lRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Tracker   � Autor �                    � Data �  12/12/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Tracker para pedido                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function Tracker(oModel)

Local aEnt := {}
Local cPedido := ""
Local nPosItem := 0
Local nLoop := 1
Local cQuery := ""

DbSelectArea("SC5")

//SC5->(DbSetOrder(8))
SC5->(DbOrderNickName("PEDSITE"))//Alterado por LMS em 03-01-2013 para virada de vers�o
   
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
	MsgAlert("N�o foram encontrados Dados para Rastreamento!")
Endif

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldCnbOk  � Autor �Opvs David          � Data �  28/09/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Realiza a grava��o do modelo no banco.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function VldCnbOk(oModel)
Local lRet 		:= .T.
Local cArq		:= oModel:GetValue("SZPMASTER","ZP_ARQUIVO") 
Local cSql		:= ""
Local cIdQry	:= ""

If Empty(cArq)           
    Help( , , 'VldCnbOk', , "Obrigat�rio informar um Arquivo", 1, 0)
	lRet := .F.
ElseIf !File(cArq)
		Help( , , 'VldCnbOk', , "Arquivo N�o Encontrado no Diret�rio Informado", 1, 0)
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
	
		Help( , , 'VldCnbOk', , "Arquivo j� utilizado nos seguintes C�digos:"+cIdQry, 1, 0)
		lRet := .F.
		
	EndIf
	
	QRYSZP->(DbCloseArea())

EndIf

Return(lRet)