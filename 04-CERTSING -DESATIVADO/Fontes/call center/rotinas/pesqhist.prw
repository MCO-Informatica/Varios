#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

#DEFINE TOT_PAGINA		10

// Posicoes do vetor de resultados da pesquisa (aPesqResult)
#DEFINE POS_NUMPROT		2

// Posicoes do array de configuracoes das colunas 
#DEFINE COL_REF			1
#DEFINE COL_CPO			2
#DEFINE COL_TIT			3
#DEFINE COL_STS         4
#DEFINE COL_ORD         5

// Posicoes do vetor aTabInfo passado para a funcao CriaQuery()
#DEFINE QRY_ALIAS		1
#DEFINE QRY_NOME 		2
#DEFINE QRY_FILIAL		3
#DEFINE QRY_STATUS		4
#DEFINE QRY_CHVALIAS	5
#DEFINE QRY_CHAVE		6
#DEFINE QRY_FUNCNAME	7

// Total de niveis de pesquisa
#DEFINE TOT_NIVEIS		7

// Posicao das filiais no vetor aFilSDK
#DEFINE XFIL_ADE		1
#DEFINE XFIL_SZT		2
#DEFINE XFIL_ACH		3
#DEFINE XFIL_SA1		4
#DEFINE XFIL_SU5		5
#DEFINE XFIL_SUS		6
#DEFINE XFIL_SZ3		7
#DEFINE XFIL_SU0		8
#DEFINE XFIL_ADF		9
#DEFINE XFIL_SU7		10
#DEFINE XFIL_SU9		11

// Posicao das tabelas no vetor aTabSQL
#DEFINE XTAB_ADE		1
#DEFINE XTAB_ADF		2
#DEFINE XTAB_SA1		3
#DEFINE XTAB_SUS		4
#DEFINE XTAB_SU5		5
#DEFINE XTAB_SZ3		6
#DEFINE XTAB_ACH		7
#DEFINE XTAB_SZT		8

Static xNLIN := 0

/*
---------------------------------------------------------------------------
| Rotina    | PesqHist     | Autor | Gustavo Prudente | Data | 20.05.2013 |
|-------------------------------------------------------------------------|
| Descricao | Pesquisa de Historico de Atendimentos - Service Desk        |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function PesqHist( lDebug, cOpcFld, cChvPesq, lGatPesq )

Local oFolder, oBkpGetd
Local oPanelBt1, oPanelBt2
Local oLayOrd, oLayButCfg, oLayColCfg
Local oBtnUp, oBtnDown, oGetPesq, oBtnPesq
Local oPanelTit1, oPanelTit2, oPanelTit3
Local oPanelMemo1, oPanelMemo2, oPanelMemo3
Local oTMenuIt1, oMenu, oLbxColCfg, oOrdPesq
Local oPColLeft, oPColRight, oPColCfg01, oPColCfg02
Local oPanelADE, oPanelADF, oPanelEsq, oPanelDir
Local oPanelLn1, oPanelLn2 , oPanelLn3, oPanelLn4
Local oPnlOrdBut, oPnlOrdList, oCfgCBEditar, oCfgCBAcoes

Local oFontDlg		:= TFont():New( "Tahoma",, -11 )
Local oFontMsg		:= TFont():New( "Tahoma",, -12 )

Local oOk			:= LoadBitMaps( nil, "BR_VERDE_MDI" )
Local oNo			:= LoadBitMaps( nil, "BR_VERMELHO_MDI" )
Local oDes			:= LoadBitMaps( nil, "BR_CINZA_MDI" )

Local aBusca		:= {}
Local aPos	 		:= {}
Local aCpoADF		:= {}
Local aRetChv		:= {}
Local aMemADE		:= {}
Local aMemADF		:= {}
Local aGrpPesq		:= {}                               
Local aNewCols		:= {}
Local aColCfg		:= {}
Local aOpcPesq		:= {}           
Local aCpoInfo		:= {}
Local aArea			:= GetArea()
Local aSize			:= MsAdvSize( .F. )

Local nLinha		:= 0
Local nX			:= 0
Local nOpcPesq		:= 1
Local nTamItem		:= 0
Local nPosCfg		:= 0
Local nOrdCol		:= 0
Local nTmpCol		:= 0
Local nPosCol		:= 0
Local nOpcFld		:= 1
Local nRemoteType	:= GetRemoteType()

Local cTmpCol		:= ""
Local cX3Campo		:= ""
Local cColuna		:= ""
Local cColStatus	:= ""
Local cTitCol		:= ""
Local cRefCol		:= ""
Local cColCfg		:= ""
Local cColSts		:= ""
Local cColOrd		:= ""
Local cChvDef		:= ""
Local cPesq			:= Space( 200 )

Local lBtnBuscar	:= .F.
Local lEdita		:= .F.
Local lEdtSup		:= .F.
Local lAcoes		:= .T.
Local lUsaCol		:= .T.
Local lSalvar		:= .F.
Local lColMark		:= .T.
Local lTemGetd		:= ( Type( "oGetd" ) <> "U" )

Private oLayer
Private oDlgPesq
Private oSayMsg

Private oGetDADF
Private oMemo1, oMemo2, oMemo3
Private oBtnEdit, oBtnSair, oBtnOk, oBtnAcoes

Private oFldPesq
Private oBmpAlert, oBmpBusca
Private oBtnProx , oBtnAnt, oBtnSalvar
Private oBtn1Pesq, oBtn2Pesq, oBtn3Pesq, oBtn4Pesq

Private oSplitter, oListResult

Private cObservacao	:= ""
Private cIncidente	:= ""
Private cObsItem  	:= ""
Private cObsGetD  	:= ""
Private cFileDef	:= ""

Private aLinResult	:= {}
Private aChaves		:= {}
Private aHeadADF	:= {}
Private aColsADF	:= {}
                 
// Array com as informacoes das colunas e ordenacao que deve ser exibido no resultado
Private aPesqCols	:= { 	{ "PESQ_STT", { .F., "STATUS"  , .F. }, "Status"   			, 1, 1 } , ;
							{ "PESQ_PRT", { .F., "NUMPROT" , .F. }, "Protocolo"			, 1, 2 } , ;
							{ "PESQ_DTA", { .F., "DATA"    , .F. }, "Data"   		  	, 1, 3 } , ;
							{ "PESQ_GRP", { .T., "GRUPO"   , .F. }, "Grupo"    			, 1, 4 } , ;
							{ "PESQ_CHV", { .F., "CHAVE"   , .F. }, "Chave de Pesquisa"	, 1, 5 } , ;
							{ "PESQ_CPF", { .T., "PESQ_CPF", .F. }, "CPF/CNPJ"			, 1, 6 }   }

Private aPesqResult	:= { { { 0, "" } } }
Private aTotalPesq	:= {}
Private aFilSDK		:= {} 		// Vetor com as filiais das tabelas do Service-Desk
Private aGrpSDK		:= {}		// Grupos de atendimento cadastrados no Service-Desk

Private aTELA[0,0], aGETS[0]

Default lDebug		:= .F.
Default lGatPesq	:= .F.
Default cOpcFld 	:= ""
Default cChvPesq 	:= cPesq

If lDebug
	RpcSetType( 3 )
//	RpcSetEnv( "01", "02" )
  	RpcSetEnv( "99", "01" )
	aPos := { 5, 5, 541, 961 }                                                                           
Else
	If nRemoteType # 5
		aPos := { 5, 5, aSize[6], aSize[5] }
	Else
		aPos := { 5, 5, aSize[6] - 35, aSize[5] - 30 }
	EndIf
EndIf
               
// Cria vetor de cache com as filiais das tabelas do Service-Desk utilizadas em dbSeek, para 
// evitar a chamada de xFilial() a cada dbSeek
aFilSDK := {	xFilial( "ADE" ) , ;
				xFilial( "SZT" ) , ;
				xFilial( "ACH" ) , ;
				xFilial( "SA1" ) , ;
				xFilial( "SU5" ) , ;
				xFilial( "SUS" ) , ;
				xFilial( "SZ3" ) , ;
				xFilial( "SU0" ) , ;
				xFilial( "ADF" ) , ;
				xFilial( "SU7" ) , ;
				xFilial( "SU9" )   }
                         
// Cria vetor com cache do nome das tabelas para utilizacao em Query               
aTabSQL := { 	RetSQLName( "ADE" ) , ;
				RetSQLName( "ADF" ) , ;
				RetSQLName( "SA1" ) , ;
				RetSQLName( "SUS" ) , ;
				RetSQLName( "SU5" ) , ;
				RetSQLName( "SZ3" ) , ;
				RetSQLName( "ACH" ) , ;
				RetSQLName( "SZT" )   }

// Salva variaveis de memoria do atendimento (cabecalho e itens)
aMemADE := XSaveMem( "ADE" )                                    
aMemADF := XSaveMem( "ADF" )
                        
// Guarda objeto GetDados anterior, caso exista
If lTemGetd
	oBkpGetd := oGetd	 
EndIf	

SaveInter()

SetKey( VK_F6, { || } )
                     
//
// Cria array de configuracao de colunas padrao, conforme array aPesqCols
//
// aColCfg[ n, 1 ] - Objeto que indica se a coluna esta habilitada/desabilitada ou desativada
// aColCfg[ n, 2 ] - Ordem da coluna no resultado da pesquisa
// aColCfg[ n, 3 ] - Titulo da coluna que sera apresentado no resultado da pesquisa
// aColCfg[ n, 4 ] - Indica se a coluna esta habilitada (.T.) ou desabilitada (.F.)
// aColCfg[ n, 5 ] - Referencia da coluna para a rotina de pesquisa. "PESQ_" para colunas 
//					 padrão e "ADE_" para campos da tabela de atendimentos
// aColCfg[ n, 6 ] - Indica se a coluna esta desativada (.F.) ou ativada (.T.)

aColCfg := {	{ oOk, 1, "Status"				, .T., "PESQ_STT", .T. } , ;
				{ oOk, 2, "Protocolo"			, .T., "PESQ_PRT", .T. } , ;
				{ oOk, 3, "Data"				, .T., "PESQ_DTA", .T. } , ;
				{ oOk, 4, "Grupo"				, .T., "PESQ_GRP", .T. } , ;
				{ oOk, 5, "Chave de Pesquisa"	, .T., "PESQ_CHV", .T. } , ;
				{ oOk, 6, "CPF/CNPJ"			, .T., "PESQ_CPF", .T. }   } 

// Cria arquivo de definicao da pesquisa por grupo se necessario
cFileDef := CriaArqDef( aColCfg )

// Busca configuracao do botao editar e acoes relacionadas
cChvDef	:= LeArqDef( cFileDef, "Button", "Editar" )
lEdita	:= ( cChvDef == "1" .Or. Empty( cChvDef ) )

cChvDef	:= LeArqDef( cFileDef, "Button", "Acoes"  )
lAcoes	:= ( cChvDef == "1" .Or. Empty( cChvDef ) )

cChvDef	:= LeArqDef( cFileDef, "Button", "EdtSup"  )
lEdtSup := ( cChvDef == "1" )

// Le as colunas configuradas para exibicao dos resultados
nTmpCol := 1
cTmpCol := LeArqDef( cFileDef, "Result", "Colunas" + StrZero( nTmpCol, 2 ) )

Do While ! Empty( cTmpCol )
	cColCfg += cTmpCol + ","
	nTmpCol ++
	cTmpCol := LeArqDef( cFileDef, "Result", "Colunas" + StrZero( nTmpCol, 2 ) )
EndDo

// Cria array com as configuracoes das colunas de acordo com o arquivo PESQHIST.INI
If ! Empty( cColCfg )
	
	// Le configuracao de status e ordem das colunas
	cColSts := LeArqDef( cFileDef, "Result", "Status" )
	cColOrd := LeArqDef( cFileDef, "Result", "Ordem" )                                                                            
                                                   
	aArqCol := { StrToKArr( cColCfg, "," ), StrToKArr( cColSts, "," ), StrToKArr( cColOrd, "," ) }

	// Percorre array de configuracoes das colunas      
	For nX := 1 To Len( aArqCol[ 1 ] )
	       
		nPosCol := AScan( aPesqCols, { |x| x[ COL_REF ] == aArqCol[ 1, nX ] } )

		// Caso ja exista, atualiza ordem e status
		If nPosCol > 0
			aPesqCols[ nPosCol, COL_STS ] := Val( aArqCol[ 2, nX ] )
			aPesqCols[ nPosCol, COL_ORD ] := Val( aArqCol[ 3, nX ] )
		Else            
			// Cria vetor com as informacoes de busca do resultado da coluna          
			aCpoInfo := { .T., aArqCol[ 1, nX ], "ADE_" $ aArqCol[ 1, nX ] }
		                
			// Se nao existir, cria nova coluna de acordo com as informacoes do arquivo de configuracoes
			AAdd( aPesqCols, {	aArqCol[ 1, nX ], ;
								aCpoInfo, ;
								GetSX3Cache( aArqCol[ 1, nX ], "X3_TITULO" ), ;
								Val( aArqCol[ 2, nX ] ), ;
								Val( aArqCol[ 3, nX ] ) } )
		EndIf
	
	Next nX
	
	aPesqCols := ASort( aPesqCols,,, { |x,y| x[ 5 ] < y[ 5 ] } )

EndIf	

// Realiza tratamento no array aPesqResult
aPesqResult := { { { } } }
AAdd( aPesqResult[ 1, 1 ], 0 )	
AAdd( aPesqResult[ 1, 1 ], "" )	
                               
For nX := 1 To Len( aPesqCols )
	AAdd( aPesqResult[ 1, 1 ], "" )
Next nX  

// Cria array com as chaves de pesquisa, de acordo com a ordem definida em aBusca - funcao AbasPesquisa()
aRetChv := AClone( CriaArrChv( AClone( AbasPesquisa() ) ) )

aChaves := AClone( aRetChv[ 1 ] )	// Array de chaves (campos) das entidades para pesquisa
aBusca  := AClone( aRetChv[ 2 ] )	// Array com as opcoes de busca
                         
// Retorna grupos de atendimento utilizados no Service-Desk
aGrpSDK := RetGrpSDK()
                    
// Cria array com o(s) grupo(s) configurados para exibir ou bloquear atendimentos nos resultados
aGrpPesq := RetGrpPesq()

If nRemoteType # 5
	cPesq := "PESQUISAR POR " + Upper( SubStr( aBusca[ 1 ], 2, Len( aBusca[ 1 ] ) ) ) + "..." + Space( 200 )
EndIf

AAdd( aLinResult, { "1ADE", 0, "ADE", "ATENDIMENTO" } )
AAdd( aLinResult, { "2SA1", 0, "SA1", "CLIENTE"     } )
AAdd( aLinResult, { "3SUS", 0, "SUS", "PROSPECT"    } )
AAdd( aLinResult, { "4SU5", 0, "SU5", "CONTATO"     } )
AAdd( aLinResult, { "5SZ3", 0, "SZ3", "POSTOS"      } )
AAdd( aLinResult, { "6ACH", 0, "ACH", "SUSPECTS"    } )
AAdd( aLinResult, { "7SZT", 0, "SZT", "COMMON NAME" } )

aTotalPesq := Array( Len( aLinResult ) )
AFill( aTotalPesq, 0 )

aCpoADF := { "ADF_ITEM", "ADF_CODSU9", "ADF_NMSU9", "ADF_CODSUQ", "ADF_NMSUQ", "ADF_CODSU7", "ADF_NMSU7", "ADF_OBS", "ADF_DATA", "ADF_HORA", "ADF_HORAF" }

// Define dialogo principal
oDlgPesq	:= MSDialog():New( aPos[1], aPos[2], aPos[3], aPos[4], "Pesquisa Histórico de Atendimentos - " + TK091Titulo( TkOperador() ),,, .F.,, rgb( 0, 50, 100 ), rgb( 241, 241, 251 ),,, .T.,,, .T. )
oDlgPesq:SetFont( oFontDlg )

// Define folder de Pesquisa e Configuracoes
oFolder 		:= TFolder():New( 00, 00, XOpcPesq(),, oDlgPesq,,,, .T.,, ( aPos[ 4 ] / 2 ) - 3, ( aPos[ 3 ] / 2 ) )
oFolder:Align	:= CONTROL_ALIGN_ALLCLIENT

// Define folder de pesquisa das opcoes definidas para Historico de Chamados
oFldPesq		:= TFolder():New( 00, 00, aBusca,, oFolder:aDialogs[1],,, CLR_WHITE, .T.,,,33 )
oFldPesq:Align	:= CONTROL_ALIGN_TOP

// Painel de mensagens da pesquisa
oPanelMsg		 := tPanel():New( 01, 01, "", oDlgPesq,,.T.,,,, 1, 12, .F., .F. )
oPanelMsg:Align	 := CONTROL_ALIGN_BOTTOM

oBtnSair := TButton():New( 02, 02, "&Sair", oPanelMsg, { || oDlgPesq:End() }, 040, 012,,,,.T.,,"",,,,.F. )
oBtnSair:Align := CONTROL_ALIGN_RIGHT

//
// Caso tenha a opcao de "Configuracoes" (modo supervisor), cria os objetos e as opcoes necessarias
//
If Len( oFolder:aDialogs ) > 1                      

	// Cria vetor com as colunas que podem ser exibidas no resultado da pesquisa
	For nX := 1 To Len( aPesqCols )                                 
                  
		nPosCfg := AScan( aColCfg, { |x| x[ 5 ] == aPesqCols[ nX, COL_REF ] } )

		cRefCol	:= aPesqCols[ nX, COL_REF ]
		cTitCol	:= aPesqCols[ nX, COL_TIT ]
		nOrdCol := aPesqCols[ nX, COL_ORD ]
		lUsaCol	:= NToL( aPesqCols[ nX, COL_STS ] )			// 1-Habilitada; 0-Desabilitada

		// Atualiza array do listabox de configuracao de colunas
		If nPosCfg == 0		
			AAdd( aColCfg, { 	Iif( lUsaCol, oOk, oNo )	, ;		// Objeto para habilitado ou desabilitado
								nOrdCol						, ;		// Ordem da coluna na apresentacao do resultado
								cTitCol						, ;		// Titulo da coluna
								lUsaCol	   		        	, ;		// Indica se a coluna esta habilitada ou desabilitada
								cRefCol						, ;		// Nome de referencia da coluna (nome do campo)
								.T.							} )		// Indica se a coluna esta desativada (.F.) ou ativada (.T.)
		Else           
			aColCfg[ nPosCfg, 1 ] := Iif( lUsaCol, oOk, oNo )  
			aColCfg[ nPosCfg, 2 ] := nOrdCol
			aColCfg[ nPosCfg, 4 ] := lUsaCol
		EndIf
			
	Next nX
                                                     
	aColCfg := ASort( aColCfg,,, { |x,y| x[ 2 ] < y[ 2 ] } )

	// Cria vetor com as opcoes de pesquisa para permitir ordenacao na Listbox
	aOpcPesq := {}       
	
	For nX := 1 To Len( aBusca )
		AAdd( aOpcPesq, StrTran( aBusca[ nX ], "&", "" ) )
	Next nX
                                                                
    //
    // Monta objetos na aba "Configurações"
    //      
   	oLayer := FWLayer():New()

   	oLayer:Init( oFolder:aDialogs[ 2 ], .F. )                                      
   	
	oLayer:AddCollumn( "Esq01", 50, .F. )
	oLayer:AddCollumn( "Dir01", 50, .F. )
	
	oLayer:AddWindow( "Esq01", "WinEsq01", "Ordenar Opções"    , 47, .F., .F. )
	oLayer:AddWindow( "Esq01", "WinEsq02", "Configurar Botões" , 47, .F., .F. )
	oLayer:AddWindow( "Dir01", "WinDir01", "Configurar Colunas", 47, .F., .F. )
	     
	// Objetos das janelas de configuracoes FWLayer
	oLayOrd		:= oLayer:GetWinPanel( "Esq01", "WinEsq01" )
	oLayButCfg	:= oLayer:GetWinPanel( "Esq01", "WinEsq02" )
	oLayColCfg	:= oLayer:GetWinPanel( "Dir01", "WinDir01" )
     
	//
	// Objetos da area de ordenacao das opcoes de pesquisa
	//
	oPnlOrdBut 			 := tPanel():New( 00, 00, "", oLayOrd,,.T.,,,, 14, 14, .F., .T. )
	oPnlOrdBut:Align	 := CONTROL_ALIGN_LEFT
	
	oPnlOrdList	 		 := tPanel():New( 00, 00, "", oLayOrd,,.T.,,,, 100, 12, .F., .F. )
	oPnlOrdList:Align	 := CONTROL_ALIGN_LEFT

	@ 00, 00 LISTBOX oOrdPesq FIELDS aOpcPesq HEADER "Opções de Pesquisa" SIZE 200, 200 OF oPnlOrdList PIXEL

	oOrdPesq:LHScroll := .F.
	oOrdPesq:SetArray( aOpcPesq )                                          
	oOrdPesq:Align := CONTROL_ALIGN_ALLCLIENT
	oOrdPesq:bLine := { || { aOpcPesq[ oOrdPesq:nAt ] } }
	
	oBtnUp := TBtnBmp2():New( 01, 01, 25, 22, "TRIUP"  ,,,, { || OrdOpcPesq( 1, oOrdPesq, @aOpcPesq, oOrdPesq:nAt ) }, ;
					oPnlOrdBut, "Move acima o item selecionado",, .T. )
					
	oBtnDown := TBtnBmp2():New( 01, 01, 25, 22, "TRIDOWN",,,, { || OrdOpcPesq( 2, oOrdPesq, @aOpcPesq, oOrdPesq:nAt ) }, ;
					oPnlOrdBut, "Move abaixo o item selecionado",, .T. )
	
	oBtnUp:Align 	:= CONTROL_ALIGN_TOP
	oBtnDown:Align	:= CONTROL_ALIGN_TOP

	//
	// Objetos da area de configuração de botões
	//
	@ 01, 00 CHECKBOX oCfgCBEditar VAR lEdita PROMPT 'Habilitar a opção "Editar"' PIXEL OF oLayButCfg SIZE 100, 50 ;
				MESSAGE 'Habilitar ou desabilitar a opção "Editar"' ON CLICK .T.
	
	@ 11, 00 CHECKBOX oCfgCBAcoes VAR lAcoes PROMPT 'Habilitar a opção "Ações Relacionadas"' PIXEL OF oLayButCfg SIZE 110, 50 ;
				MESSAGE 'Habilitar ou desabilitar a opção "Ações Relacionadas"' ON CLICK .T.

	@ 21, 00 CHECKBOX oCfgCBEdtSup VAR lEdtSup PROMPT 'Opção "Editar" somente para supervisor' PIXEL OF oLayButCfg SIZE 110, 50 ;
				MESSAGE 'Restringir a opção "Editar" somente para supervisores' ON CLICK .T.

	// Desabilita CSS para uso no smartclient HTML
	If nRemoteType # 5
		oCfgCBAcoes:SetCss( "QPushButton{}" )
		oCfgCBEditar:SetCss( "QPushButton{}" )
		oCfgCBEdtSup:SetCss( "QPushButton{}" )
	EndIf

	oBtnSalvar := TButton():New( 02, 02, "Sal&var", oPanelMsg, { || ;
						GrvCfgPesq( cFileDef, { lAcoes, lEdita, lEdtSup }, aOpcPesq, aColCfg ), lSalvar := .T. }, ;
						040, 012,,,, .T.,, "",,,, .F. )
						
	oBtnSalvar:Align := CONTROL_ALIGN_RIGHT
	oBtnSalvar:Hide()	

	//
	// Objetos da area de configuração de colunas
	//                                                                                 
	oPColLeft := tPanel():New( 00, 00, "", oLayColCfg,,.T.,,,, 14, 14, .F., .T. )
	oPColLeft:Align := CONTROL_ALIGN_LEFT

	oPColRight := tPanel():New( 00, 00, "", oLayColCfg,,.T.,,,, 00, 100, .F., .F. )
	oPColRight:Align := CONTROL_ALIGN_ALLCLIENT

	oPColCfg01 := tPanel():New( 00, 00, "", oPColRight,,.T.,,,, 00, 75, .F., .F. )
	oPColCfg01:Align := CONTROL_ALIGN_ALLCLIENT

	oPColCfg02 := tPanel():New( 00, 00, "", oPColRight,,.T.,,,, 00, 11, .F., .T. )
	oPColCfg02:Align := CONTROL_ALIGN_BOTTOM

	// Botoes para ordenacao das colunas de resultado
	oBtnColUp := TBtnBmp2():New( 01, 01, 25, 22, "TRIUP"  ,,,, { || OrdColRes( 1, oLbxColCfg, @aColCfg, oLbxColCfg:nAt ) }, ;
						oPColLeft, "Move acima o item selecionado",, .T. )
							
	oBtnColDown := TBtnBmp2():New( 01, 01, 25, 22, "TRIDOWN",,,, { || OrdColRes( 2, oLbxColCfg, @aColCfg, oLbxColCfg:nAt ) }, ;
						oPColLeft, "Move abaixo o item selecionado",, .T. )

	// Botao para habilitar ou desabilitar todas as colunas do resultado
	lColMark := .T.

	oBtnColAdic := TBtnBmp2():New( 01, 01, 25, 22, "SUMARIO_MDI.BMP"   ,,,, ;
						{ || CfgColMark( lColMark, oOk, oNo, @aColCfg ), lColMark := ! lColMark, oLbxColCfg:Refresh() }, ;
						oPColLeft, "Habilitar ou desabilitar todos os itens",, .T. )
							
	// Botao para adicionar novas colunas no resultado da pesquisa a partir das informacoes do cabecalho do atendimento
	oBtnColMark := TBtnBmp2():New( 01, 01, 25, 22, "BMPINCLUIR_MDI.BMP",,,, ;
						{ || Iif( CfgAdicCols( oLbxColCfg, oDes, @aColCfg ), oBtnColMark:Disable(), .F. ), oLbxColCfg:Refresh() }, ;
						oPColLeft, "Adiciona colunas a partir do cabeçalho do atendimento",, .T. )
	
	oBtnColUp:Align 	:= CONTROL_ALIGN_TOP
	oBtnColDown:Align	:= CONTROL_ALIGN_TOP
	oBtnColAdic:Align	:= CONTROL_ALIGN_TOP
	oBtnColMark:Align	:= CONTROL_ALIGN_TOP

	// Cria componente para exibir as colunas de resultado da pesquisa
	@ 00, 00 LISTBOX oLbxColCfg FIELDS aColCfg HEADER " ", "Ordem", "Coluna", "Descrição" SIZE 90, 75 OF oPColCfg01 PIXEL

	oLbxColCfg:Align := CONTROL_ALIGN_ALLCLIENT
	oLbxColCfg:SetArray( aColCfg )

	oLbxColCfg:bLine := { || { 	aColCfg[ oLbxColCfg:nAt, 1 ] , ;
	                   			aColCfg[ oLbxColCfg:nAt, 2 ] , ;
	                   			aColCfg[ oLbxColCfg:nAt, 3 ] , ;
	                   			CfgDesCol( aColCfg, oLbxColCfg:nAt ) } }

	oLbxColCfg:bLDblClick := { || CfgDblClick( oLbxColCfg, @aColCfg, oNo, oOk ) }
              
	// Cria legenda para habilitar ou desabilitar colunas
	TSay():New( 02, 01, { || "Legenda:" }, oPColCfg02,,,,,, .T., CLR_BLUE, CLR_WHITE, 200, 08 )
	
	TBitmap():New( 02, 027, 260, 184,, "BR_VERDE"   , .T., oPColCfg02, ,, .F., .F.,,, .F.,, .T.,, .F. )
	TBitmap():New( 02, 083, 260, 184,, "BR_VERMELHO", .T., oPColCfg02, ,, .F., .F.,,, .F.,, .T.,, .F. )
	TBitmap():New( 02, 145, 260, 184,, "BR_CINZA"   , .T., oPColCfg02, ,, .F., .F.,,, .F.,, .T.,, .F. )

	TSay():New( 02, 036, { || "Coluna habilitada"   }, oPColCfg02,,,,,, .T., CLR_BLACK, CLR_WHITE, 200, 08 )
	TSay():New( 02, 092, { || "Coluna desabilitada" }, oPColCfg02,,,,,, .T., CLR_BLACK, CLR_WHITE, 200, 08 )
	TSay():New( 02, 154, { || "Coluna desativada"   }, oPColCfg02,,,,,, .T., CLR_BLACK, CLR_WHITE, 200, 08 )	
	
EndIf

// Botao buscar resultados
oBtnPesq := TButton():New( 	038, 338, "&Buscar", oDlgPesq, ;
	{ || Iif( ValidaPesquisa( cPesq ), ;
	FwMsgRun( oFldPesq, { |oSay| lBtnBuscar := BtnPesq( cPesq, aBusca, nOpcPesq, .T., oSay, aGrpPesq ) } ), .T. ) }, 040, 012,,,, .T.,, "",,,, .F. )

// Get e Botao de pesquisa do conteudo
oGetPesq := TGet():New( 38, 03, { |x| Iif( Pcount() > 0, cPesq := x, cPesq ) }, oDlgPesq, 333, 010, "@!", { || oBtnPesq:SetFocus(), .T. },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cPesq,,,, )

// Botoes de tipo de pesquisa: Esquerda, Centro, Direita e Justificado
oBtn1Pesq := TBtnBmp2():New( 76, 760, 25, 25, "TEXTLEFT"   ,,,, { || nOpcPesq := BtnTipPesq( cPesq, aBusca, 1, lBtnBuscar, aGrpPesq ) }, oDlgPesq )
oBtn2Pesq := TBtnBmp2():New( 76, 783, 25, 25, "TEXTCENTER" ,,,, { || nOpcPesq := BtnTipPesq( cPesq, aBusca, 2, lBtnBuscar, aGrpPesq ) }, oDlgPesq )
oBtn3Pesq := TBtnBmp2():New( 76, 806, 25, 25, "TEXTRIGHT"  ,,,, { || nOpcPesq := BtnTipPesq( cPesq, aBusca, 3, lBtnBuscar, aGrpPesq ) }, oDlgPesq )
oBtn4Pesq := TBtnBmp2():New( 76, 829, 25, 25, "TEXTJUSTIFY",,,, { || nOpcPesq := BtnTipPesq( cPesq, aBusca, 4, lBtnBuscar, aGrpPesq ) }, oDlgPesq )

// Divide a area do TFolder "Pesquisar", em area de GetDados e campos Memo
oSplitter 		:= tSplitter():New( 01, 01, oFolder:aDialogs[1], 100, 100 )
oSplitter:Align := CONTROL_ALIGN_ALLCLIENT

//
// Painel esquerdo - GetDados dos atendimentos e itens do atendimento
//
oPanelEsq		:= tPanel():New( 01, 01, "", oSplitter,,.T.,,,, 320, 1, .F., .F. )
oPanelEsq:Align	:= CONTROL_ALIGN_LEFT

oPanelADE		:= tPanel():New( 01, 01, "", oPanelEsq,,.T.,,,CLR_WHITE, 1, 105, .F., .F. )
oPanelADE:Align	:= CONTROL_ALIGN_TOP

@ 00, 00 LISTBOX oListResult FIELDS HEADER "Status" SIZE 1, 1 OF oPanelADE PIXEL

oListResult:aHeaders 			:= RetCfgCols( aPesqCols )
oListResult:Align 				:= CONTROL_ALIGN_ALLCLIENT
oListResult:lUseDefaultColors	:= .T.

oListResult:bChange := { || Iif( aPesqResult[ 1, 1, 1 ] == 0, .T., AtuObjPesq() ) }

// Atualiza objeto com o array de resultado da pesquisa
SetListResult( Len( aPesqResult ) )

oPanelLn1 		:= tPanel():New( 01, 01, "", oPanelEsq,,.T.,,,CLR_WHITE, 1, 02, .F., .F. )
oPanelLn1:Align	:= CONTROL_ALIGN_TOP

oPanelBt1		:= tPanel():New( 01, 01, "", oPanelEsq,,.T.,,,CLR_WHITE, 1, 12, .F., .F. )
oPanelBt1:Align	:= CONTROL_ALIGN_TOP

oPanelLn2 		:= tPanel():New( 01, 01, "", oPanelEsq,,.T.,,,CLR_WHITE, 1, 02, .F., .F. )
oPanelLn2:Align	:= CONTROL_ALIGN_TOP

// Cria Menu
oMenu := TMenu():New( 0, 0, 0, 0, .T. )

// Adiciona itens no Menu
oTMenuIt1 := TMenuItem():New( oPanelBt1, "Banco",,,, { || VisBanco() },,,,,,,,, .T. )

oMenu:Add( oTMenuIt1 )

oBtnAcoes		:= TButton():New( 02, 02, "Ações Relacionadas", oPanelBt1, { || .T. }, 065, 012,,,, .T. )
oBtnAnt 		:= TButton():New( 02, 02, "<< &Voltar" , oPanelBt1, { || VoltaPagina() }, 040, 012,,,,.T. )
oBtnProx 		:= TButton():New( 02, 02, "&Avançar >>", oPanelBt1, { || ProxPagina( cPesq, nOpcPesq, aGrpPesq, oFldPesq:nOption ) }, 040, 012,,,,.T. )

oBtnProx:Disable()
oBtnAnt:Disable()

oBtnProx:Align	:= CONTROL_ALIGN_RIGHT
oBtnAnt:Align	:= CONTROL_ALIGN_RIGHT
oBtnAcoes:Align := CONTROL_ALIGN_LEFT

oBtnAcoes:SetPopupMenu( oMenu )

oPanelADF		:= tPanel():New( 01, 01, "", oPanelEsq,,.T.,,,CLR_WHITE, 1, 120, .F., .F. )
oPanelADF:Align	:= CONTROL_ALIGN_ALLCLIENT

oPanelLn3		:= tPanel():New( 01, 01, "", oPanelEsq,,.T.,,,CLR_WHITE, 1, 02, .F., .F. )
oPanelLn3:Align	:= CONTROL_ALIGN_BOTTOM

oPanelBt2		:= tPanel():New( 01, 01, "", oPanelEsq,,.T.,,,CLR_WHITE, 1, 12, .F., .F. )
oPanelBt2:Align	:= CONTROL_ALIGN_BOTTOM

oPanelLn4 		:= tPanel():New( 01, 01, "", oPanelEsq,,.T.,,,CLR_WHITE, 1, 02, .F., .F. )
oPanelLn4:Align	:= CONTROL_ALIGN_BOTTOM

oBtnOk			:= TButton():New( 02, 02, "&Confirmar", oPanelBt2, { || BtnOk()     }, 040, 012,,,,.T.,,"",,,, .F. )
oBtnEdit 		:= TButton():New( 02, 02, "&Editar"   , oPanelBt2, { || BtnEditar(), oGetD := AClone( oGetDADF ) }, 040, 012,,,,.T.,,"",, /*{ || ChkBtnEdit() }*/,, .F. )

oBtnOk:Align	:= CONTROL_ALIGN_RIGHT
oBtnEdit:Align	:= CONTROL_ALIGN_RIGHT

oBtnOk:Disable()

//
// Painel direito - Campos memo do atendimento e itens do atendimento
//
oPanelDir		:= tPanel():New( 01, 01, "", oSplitter,,.T.,,,, 280, 1, .F., .F. )
oPanelDir:Align	:= CONTROL_ALIGN_RIGHT

oPanelTit1 			:= tPanel():New( 01, 01, "Observação", oPanelDir,,.F.,,,CLR_WHITE, 1, 07, .F., .F. )
oPanelTit1:Align	:= CONTROL_ALIGN_TOP

oPanelMemo1			:= tPanel():New( 01, 01, "", oPanelDir,,.T.,,,CLR_WHITE, 65, 65 )
oPanelMemo1:Align	:= CONTROL_ALIGN_TOP

oMemo1 				:= TMultiget():New( 01, 01, { |u| Iif( Pcount() > 0, cObservacao := u, cObservacao ) }, oPanelMemo1, 10, 10,,,,,, .T.,,,,,, .T. )
oMemo1:Align		:= CONTROL_ALIGN_ALLCLIENT

oPanelTit2 			:= tPanel():New( 01, 01, "Incidente", oPanelDir,,.F.,,,CLR_WHITE, 1, 07, .F., .F. )
oPanelTit2:Align	:= CONTROL_ALIGN_TOP

oPanelMemo2			:= tPanel():New( 01, 01, "", oPanelDir,,.T.,,,CLR_WHITE, 65, 65 )
oPanelMemo2:Align	:= CONTROL_ALIGN_ALLCLIENT

oMemo2 				:= TMultiget():New( 01, 01, { |u| Iif( Pcount() > 0, cIncidente := u, cIncidente ) }, oPanelMemo2, 10, 10,,,,,, .T.,,,,,, .T. )
oMemo2:Align		:= CONTROL_ALIGN_ALLCLIENT

oPanelMemo3			:= tPanel():New( 01, 01, "", oPanelDir,,.T.,,,CLR_WHITE, 65, 65 )
oPanelMemo3:Align	:= CONTROL_ALIGN_BOTTOM

oPanelTit3 			:= tPanel():New( 01, 01, "Observação do Item", oPanelDir,,.F.,,,CLR_WHITE, 1, 07, .F., .F. )
oPanelTit3:Align	:= CONTROL_ALIGN_BOTTOM

oMemo3 				:= TMultiget():New( 01, 01, { |u| Iif( Pcount() > 0, cObsItem := u, cObsItem ) }, oPanelMemo3, 10, 10,,,,,, .T.,,,,,, .T. )
oMemo3:Align		:= CONTROL_ALIGN_ALLCLIENT

// Mudar a descricao do GET conforme navegacao nas abas
oFldPesq:bChange := { || ChangeFldPesq( @cPesq, aBusca, oGetPesq, @lBtnBuscar ) }

// Desabilitar campos de pesquisa
oFolder:bChange	 := { |nFolder| ChangeFolder( nFolder, @oGetPesq, @oBtnPesq, lSalvar, oOrdPesq ) }

oPanelLn5		 := tPanel():New( 01, 01, "", oDlgPesq,,.T.,,,, 1, 02, .F., .F. )
oPanelLn5:Align	 := CONTROL_ALIGN_BOTTOM

// Objeto para impressao de mensagens no painel oPanelMsg
oSayMsg			 := tSay():New( 03, 16, { || .T. }, oPanelMsg,, oFontMsg,,,, .T., RGB( 255, 127, 39 ),, 250, 20 )

oBmpSucess		 := TBtnBmp2():New( 00, 00, 30, 25, 'CHECKOK' , 'CHECKOK' ,,,, oPanelMsg,,, .T. )
oBmpAlert		 := TBtnBmp2():New( 00, 00, 30, 25, 'PMSINFO' , 'PMSINFO' ,,,, oPanelMsg,,, .T. )
oBmpBusca		 := TBtnBmp2():New( 00, 00, 30, 30, 'BRW_LUPA', 'BRW_LUPA',,,, oPanelMsg,,, .T. )

//
// Atualiza dados do aColsADF e aHeader do Cabecalho de Atendimento - ADE
//
dbSelectArea( "SX3" )
dbSetOrder( 2 )  // Campo

For nX := 1 to Len( aCpoADF )
	
	If dbSeek( aCpoADF[nX] )
		
		aAdd( aHeadADF, { AlLTrim( X3Titulo() )	, ; 	// 01 - Titulo
		SX3->X3_CAMPO							, ;		// 02 - Campo
		SX3->X3_PICTURE							, ;		// 03 - Picture
		SX3->X3_TAMANHO							, ;		// 04 - Tamanho
		SX3->X3_DECIMAL							, ;		// 05 - Decimal
		SX3->X3_VALID 							, ;		// 06 - Valid
		SX3->X3_USADO  							, ;		// 07 - Usado
		SX3->X3_TIPO   							, ;		// 08 - Tipo
		SX3->X3_F3								, ;		// 09 - F3
		SX3->X3_CONTEXT 						} )		// 10 - Contexto
		                        		
		If	AllTrim( aCpoADF[ nX ] ) == "ADF_CODSU9"
			aHeadADF[ Len( aHeadADF ), 6 ] := "u_GetDValSU9( '" + SX3->X3_VALID + "' )"
		EndIf
		
	EndIf
	
Next nX

aAdd( aColsADF, Array( Len( aHeadADF ) + 1 ) )
nLinha++

For nX := 1 To Len( aHeadADF )
	cX3Campo := AllTrim( aHeadADF[ nX, 2 ] )
	If aHeadADF[ nX, 10 ] == 'V'
		aColsADF[ nLinha, nX ] := CriaVar( cX3Campo, .T. )
	Else
		aColsADF[ nLinha, nX ] := &( 'ADF->' + cX3Campo )
	EndIf
Next

aColsADF[ nLinha, Len( aHeadADF ) + 1 ] := .F.

nTamItem := TamSX3( "ADF_ITEM" )[ 1 ]

oGetDADF := MsNewGetDados():New( 000, 002, 002, 1, 0, /*"u_GetDLinOk()"/*cLinOk*/, /*cTudoOk*/, /*cIniCpos*/ , ;
				{ "ADF_CODSU9", "ADF_CODSUQ", "ADF_OBS" }/*aAlter*/, /*nFreeze*/, Len( aColsADF ), /*cFieldOk*/, /*cSuperDel*/, /*cDelOk*/, ;
				oPanelADF, aHeadADF, aColsADF )

oGetDADF:lUpdate 			:= .F.	// Não permite edicao

oGetDADF:oBrowse:Align 		:= CONTROL_ALIGN_ALLCLIENT
oGetDADF:oBrowse:bChange	:= { || PesqMemos( .F. ) }
oGetDADF:oBrowse:blDblClick := { || GetDblClick() }

// Limpa mensagem e oculta objetos de tela ate a confirmacao da pesquisa
MsgStatus()
Oculta()

// Carrega as imagens de tipos de pesquisa, ao lado do botao "Buscar"
XLoadBitmaps( nOpcPesq )
          
oGetPesq:SetFocus()

// Se deve gatilhar a pesquisa e foi passada a chave (campo) de pesquisa, entao
// verifica qual a pasta deve selecionar para processar a busca
If lGatPesq .And. ! Empty( cChvPesq )
	cPesq := cChvPesq      
	If ! Empty( cOpcFld )
		nX 		:= 1
		nOpcFld := 0
		// Seta variavel nOpcFld com a pasta em que deve ser realizada a busca da chave
		Do While nX <= Len( aChaves ) .And. nOpcFld == 0
			nOpcFld := AScan( aChaves[ nX ], cOpcFld )
			nX ++
		EndDo
	EndIf
EndIf

// Configura o evento de ativacao da dialog para chamar a pesquisa para a string de busca
// passada como parametro, caso seja uma pesquisa com gatilho.
oDlgPesq:Activate( ,,, GetScreenRes()[1] > 800,,, ;
			{ || Iif( lGatPesq .And. ValidaPesquisa( cPesq ), ( oFldPesq:nOption := nOpcFld, cPesq := cChvPesq, ;
			FwMsgRun( oFldPesq, { |oSay| lBtnBuscar := BtnPesq( cPesq, aBusca, nOpcPesq, .T., oSay, aGrpPesq, nOpcFld ) } ) ), .T. ) } )

SetKey( VK_F6, { || U_PESQHIST() } )
                 
// Restaura objeto de GetDados
If lTemGetd
	oGetd := oBkpGetd
EndIf
                                   
// Restaura variaveis do cabecalho da tela de atendimento 
If Len( aMemADE ) > 0
	For nX := 1 To Len( aMemADE )
		cVar 		:= aMemADE[ nX, 1 ]	
		&( cVar )	:= aMemADE[ nX, 2 ]
	Next nX
EndIf

// Restaura variaveis dos itens da tela de atendimento
If Len( aMemADF ) > 0
	For nX := 1 To Len( aMemADF )
		cVar 		:= aMemADF[ nX, 1 ]	
		&( cVar )	:= aMemADF[ nX, 2 ]
	Next nX
EndIf

RestInter()
RestArea( aArea )

Return( .T. )

/*
---------------------------------------------------------------------------
| Rotina    | AbasPesquisa | Autor | Gustavo Prudente | Data | 20.05.2013 |
|-------------------------------------------------------------------------|
| Descricao | Cria configuracao de abas utilizadas na pesquisa de         |
|           | historico de atendimentos.                                  |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function AbasPesquisa()

Return( StrTokArr( LeArqDef( cFileDef, "Folder", "Nomes" ), "," ) )

/*
---------------------------------------------------------------------------
| Rotina    | BtnPesq      | Autor | Gustavo Prudente | Data | 27.06.2013 |
|-------------------------------------------------------------------------|
| Descricao | Prepara chamada para rotina de pesquisa por entidade        |
|-------------------------------------------------------------------------|
| Parametros| EXPC1 - String para pesquisa e pesquisa por entidade        |
|           | EXPA2 - Vetor com o titulo das abas de opcao de pesquisa    |
|           | EXPN3 - Opcao de tipo de pesquisa selecionada.              |
|           |         1 - Pesquisa a esquerda da chave.                   |
|           |         2 - Pesquisa ao centro da chave.                    |
|           |         3 - Pesquisa a direita da chave.                    |
|           |         4 - Pesquisa em qualquer parte da chave.            |
|           | EXPL4 - Indica se foi chamado do botao "Buscar"             |
|           |         .T. - Chamado pelo botao buscar                     |
|           |         .F. - Chamado pelas opcoes de pesquisa - "Esquerda" |
|           |               "Direita", "Centro" ou "Todos"                |
|		    | EXPO5 - Objeto de mensagens da pesquisa                     |
|           | EXPA6 - Vetor com os grupos que devem retornar atendimentos |
|           |         no resultado da pesquisa.                           |
|           | EXPN7 - Forca a pesquisa por uma das opcoes de pasta        |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function BtnPesq( cStr, aBusca, nOpcPesq, lBtnBuscar, oSay, aGrpPesq, nOpcFld )

Local nTotItens	:= 0
Local nTotPesq	:= 0

Default lBtnBuscar	:= .F.
Default nOpcFld		:= oFldPesq:nOption

XLoadBitMaps( nOpcPesq )

If lBtnBuscar
	
	oSay:cCaption := "Aguarde ... "
	ProcessMessages()
	
	// Desabilita botoes de navegacao
	oBtnProx:Disable()
	oBtnAnt:Disable()
	oBtnOk:Disable()
	
	MsgStatus()
	
	// Zerando as linhas de resultado das entidades
	AEval( aLinResult, { |x| x[ 2 ] := 0 } )
	
	aPesqResult := { { } }             
	
	// Caso a opcao de busca do objeto seja diferente da opcao desejada, atualiza objeto folder
	If nOpcFld <> oFldPesq:nOption
		oFldPesq:Refresh()        
	EndIf		
		
	If ! BuscaResult( cStr, nOpcPesq, , aGrpPesq, nOpcFld )
		
		Oculta()
		MsgStatus( SubStr( aBusca[ oFldPesq:nOption ], 2, Len( aBusca[ oFldPesq:nOption ] ) ) + ' "' + AllTrim( cStr ) + '" Não Encontrado!' )
		
	Else
		
		// Atualiza objetos com o novo resultado da pesquisa
		AtuObjPesq()
		
		// Verifica e habilita botão "Avancar" se necessario
		AEval( aTotalPesq , { |x| Iif( x > nTotItens, nTotItens := x, .T. ) } )
		AEval( aPesqResult, { |x| nTotPesq  += Len( x ) } )
		
		If nTotItens > nTotPesq
			oBtnProx:Enable()
		EndIf
		
		Exibe()
		
		oListResult:SetFocus()
		
	Endif
	
EndIf

Return( lBtnBuscar )

/*
-----------------------------------------------------------------------------
| Rotina    | MsgStatus    | Autor | Gustavo Prudente | Data | 27.06.2013   |
|---------------------------------------------------------------------------|
| Descricao | Mostra mensagens de aviso na tela de pesquisa de atendimentos |
|---------------------------------------------------------------------------|
| Parametros| EXPC1 - Mensagem para exibicao na barra de status             |
|           | EXPN2 - Tipo de mensagem: 1-Alerta; 2-Pesquisa                |
|---------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                           |
-----------------------------------------------------------------------------
*/
Static Function MsgStatus( cMsg, nTipo )

Default cMsg	:= ""
Default nTipo	:= 1

oSayMsg:cCaption := cMsg

If ! Empty( cMsg )
	// Mostra o texto de cMsg na barra de mensagem
	oSayMsg:Show()
	If nTipo == 1
		oBmpAlert:Show()	// Alerta
	ElseIf nTipo == 2
		oBmpBusca:Show()	// Lupa
	ElseIf nTipo == 3
		oBmpSucess:Show()	// Sucesso
	EndIf
Else
	// Oculta objetos da barra de mensagem
	oSayMsg:Hide()
	oBmpAlert:Hide()
	oBmpBusca:Hide()
	oBmpSucess:Hide()
EndIf

oSayMsg:Refresh()
oSayMsg:SetFocus()

Return( .T. )

/*
------------------------------------------------------------------------------
| Rotina     | BuscaResult    | Autor | Gustavo Prudente | Data | 28.06.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Rotina de pesquisa da string informada nos atendimentos e     |
|            | entidades relacionadas.                                       |
|----------------------------------------------------------------------------|
| Parametros | EXPC1 - String de pesquisa para busca nos atendimentos.       |
|            | EXPN2 - Opcao de tipo de pesquisa selecionada.                |
|            |         1 - Pesquisa a esquerda da chave.                     |
|            |         2 - Pesquisa ao centro da chave.                      |
|            |         3 - Pesquisa a direita da chave.                      |
|            |         4 - Pesquisa em qualquer parte da chave.              |
|            | EXPL3 - Indica que deve montar resultado de pesquisa para     |
|            | EXPA4 - Vetor com os grupos que devem retornar atendimentos   |
|            |         no resultado da pesquisa.                             |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function BuscaResult( cStr, nOpcPesq, lNovaPag, aGrpPesq, nOpcFld )

Local nPos			:= 0
Local nOption		:= nOpcFld
Local nX            := 0
Local nY			:= 0
Local nTotQry		:= 0
Local nNivel		:= 0
Local nIndPesq 		:= 0

Local cQry 			:= ""                 
Local cWhereGrp		:= ""  
Local cLinha		:= ""

Local aArea			:= GetArea()
Local aAbasPesq		:= AbasPesquisa()
Local aUsaFuncao	:= {}
Local aContinua 	:= {}
Local aCountPesq	:= {}   
Local aTotNvPesq	:= {}	// Total de chaves encontradas individualmente em cada nivel
Local aCposADE		:= {	{ "ADE_CODIGO", "NUMPROT", { .F. } }, ;
							{ "ADE_DATA"  , "DATA"   , { .T., "D", 8 } }, ;
							{ "ADE_GRUPO" , "GRUPO"  , { .F. } } }

Local bFechaQuery	:= { |cAlias| Iif( Select( cAlias ) > 0, ( DbSelectArea( cAlias ), DbCloseArea() ), .T. ) }

Default lNovaPag	:= .F.
Default nOpcPesq	:= 1

// Se nao retornou grupos e nao pode pesquisar todos os grupos, entao as regras 
// bloqueiam todos os grupos, nao deve realizar a pesquisa
If Empty( aGrpPesq[ 1 ] ) .And. ! aGrpPesq[ 2 ]
	Return .F.                                            
Else	
	cWhereGrp := aGrpPesq[ 1 ]	// Continua com os grupos permitidos
EndIf

// Define o tipo de pesquisa que sera realizada
cStr := RetPesq( cStr, nOpcPesq )

// Indica se o proximo nivel deve continuar a busca (processamento da Query de selecao)
aContinua 	:= { 	.T., ;		// Nivel Atendimentos
					.F., ;      // Nivel Clientes
					.F., ;		// Nivel Prospects
					.F., ;		// Nivel Contatos
					.F., ;		// Nivel Postos de Atendimento
					.F., ;		// Nivel Suspects
					.F., ;		// Nivel Common Name
					.F.  }		// Proximo Nivel (a definir)
                                
// Array com as informacoes da tabela referente ao nivel da pesquisa
aTabNivel	:= { 	{ "ADE", aTabSQL[ XTAB_ADE ], "ADE_FILIAL", "ATENDIMENTO", "1ADE" 									} , ;
					{ "SA1", aTabSQL[ XTAB_SA1 ], "A1_FILIAL" , "CLIENTE"    , "2SA1", "SA1.A1_COD || SA1.A1_LOJA" 		} , ;
					{ "SUS", aTabSQL[ XTAB_SUS ], "US_FILIAL" , "PROSPECT"   , "3SUS", "SUS.US_COD || SUS.US_LOJA" 		} , ;
					{ "SU5", aTabSQL[ XTAB_SU5 ], "U5_FILIAL" , "CONTATO"    , "4SU5", "SU5.U5_CODCONT" 				} , ;
					{ "SZ3", aTabSQL[ XTAB_SZ3 ], "Z3_FILIAL" , "POSTO"      , "5SZ3", "SZ3.Z3_CODENT" 					} , ;
					{ "ACH", aTabSQL[ XTAB_ACH ], "ACH_FILIAL", "SUSPECT"    , "6ACH", "ACH.ACH_CODIGO || ACH.ACH_LOJA" } , ;
					{ "SZT", aTabSQL[ XTAB_SZT ], "ZT_FILIAL" , "COMMON NAME", "7SZT", "SZT.ZT_CODIGO", "LIKE" 			}   }

// Armazena a quantidade acumulativa de chaves encontradas em cada nivel da pesquisa.
aCountPesq := Array( Len( aLinResult ) )
AFill( aCountPesq, 0 )

// Armazena a quantidade de chaves encontradas no nivel da pesquisa, sem acumular todos os niveis
aTotNvPesq := Array( Len( aLinResult ) )
AFill( aTotNvPesq, 0 )

If ! lNovaPag
	// Inicializa quantidades de chaves encontradas, se nao for uma nova pagina.
	// Acumula a partir do total acumulativo de chaves encontradas no nivel da pesquisa (aCountPesq)
	aTotalPesq := Array( Len( aLinResult ) )
	AFill( aTotalPesq, 0 )
Else
	AAdd( aPesqResult, {} )
EndIf

// Indica se deve utilizar funcao UPPER do Oracle ou outra funcao para comparacao
// entre o campo chave de pesquisa e a string informada
aIndFuncao := {	.T., ;		// Nome
				.F., ;		// CPF/CNPJ
				.T., ;  	// E-mail
				.T., ;		// Common Name
				.T., ;   	// Palavra Chave
				.F., ;		// Pedido GAR
				.F., ;		// Protocolo Atendimento
				.F.  }		// Pedido Site

aUsaFuncao := Array( Len( aIndFuncao ) )

For nX := 1 To Len( aAbasPesq )
	nIndPesq := Val( SubStr( aAbasPesq[ nX ], 1, 1 ) )
	aUsaFuncao[ nX ] := aIndFuncao[ nIndPesq ]
Next nX

For nX := 1 to 2  // x==1 para Contador de registros; x==2 para selecionar os registros
	
	//
	//	Seleciona Atendimentos (ADE) - aChaves[1]
	//
	nNivel := 1	// Atendimentos
	
	If Empty( aChaves[ nNivel, nOption ] )
		aContinua[ 2 ] := .T.
	Else
		
		// Fecha query da consulta da entidade anterior
		Eval( bFechaQuery, Iif( nX == 1, "TRB2", "TRB" ) )
		
		If nX == 1

			nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, 0 )

			// Se nao tem total, verifica se existem resultados no nivel de pesquisa
			If nTotQry == 0

				// Monta consulta para tabela de atendimentos (ADE)
				cQry := CriaQuery(	cStr, nX, nOption, nOpcPesq, nNivel, .F., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
				
				AbreQuery( "TRB2", cQry, aCposADE )
				   
				nTotQry := TRB2->COUNT
				If nTotQry > 0
					nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, nTotQry )
				EndIf
				
			EndIf
			
			nTotQry -= aLinResult[ nNivel, 2 ]
			
			aCountPesq[ nNivel ] := nTotQry
			aTotNvPesq[ nNivel ] := nTotQry
			aTotalPesq[ nNivel ] := Iif( aTotalPesq[ nNivel ] == 0, aCountPesq[ nNivel ], aTotalPesq[ nNivel ] )
			
			//Caso tenha menos que TOT_PAGINA registros em tela, então continuo a pesquisa para preencher a primeira pagina
			aContinua[ 2 ] := aCountPesq[ nNivel ] < TOT_PAGINA
			
			If ! aContinua[ 2 ]
				Loop
			EndIf

		Else
			
			If aTotNvPesq[ nNivel ] > 0 
			
				If Len( aPesqResult[ Len( aPesqResult ) ] ) >= TOT_PAGINA
					aAdd( aPesqResult, {} )
				EndIf

				// Monta consulta para tabela de atendimentos (ADE)
				cQry := CriaQuery( 	cStr, nX, nOption, nOpcPesq, nNivel, .F., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
									
				AbreQuery( "TRB", cQry, aCposADE )
				PopulaResult()	// Gera vetor aPesqResult com os atendimentos encontrados

			EndIf
			
		Endif
		
	EndIf
	
	// Verifica se deve processar o proximo nivel de aChaves
	If nX == 2 .And. ! aContinua[ 2 ]
		Exit
	EndIf
	
	//
	//	Seleciona Clientes (SA1) - aChaves[ 2 ]
	//
	nNivel := 2		// Clientes
	
	If Empty( aChaves[ nNivel, nOption ] )
		aContinua[ 3 ] := .T.
	Else
		
		// Fecha query da consulta da entidade anterior
		Eval( bFechaQuery, Iif( nX == 1, "TRB2", "TRB" ) )
		
		If nX == 1
			
			nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, 0 )
			
			// Se nao tem total, verifica se existem resultados no nivel de pesquisa
			If nTotQry == 0
				
				// Monta consulta para tabela de Clientes (SA1) - aChaves[ 2 ]
				cQry := CriaQuery( 	cStr, nX, nOption, nOpcPesq, nNivel, .T., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
				
				AbreQuery( "TRB2", cQry, aCposADE )
				
				nTotQry := TRB2->COUNT
				If nTotQry > 0
					nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, nTotQry )
				EndIf

			EndIf
			
			nTotQry -= aLinResult[ nNivel, 2 ]
			
			aCountPesq[ nNivel ] := nTotQry + aCountPesq[ 1 ]
			aTotNvPesq[ nNivel ] := nTotQry
			aTotalPesq[ nNivel ] := Iif( aTotalPesq[ nNivel ] == 0, aCountPesq[ nNivel ], aTotalPesq[ nNivel ] )
			
			// Caso tenha menos que TOT_PAGINA registros em tela, então continuo a pesquisa para preencher a primeira pagina
			aContinua[ 3 ] := aCountPesq[ nNivel ] < TOT_PAGINA
			If ! aContinua[ 3 ]
				Loop
			EndIf
			
		Else
			
			If aTotNvPesq[ nNivel ] > 0 
			
				If Len( aPesqResult[ Len( aPesqResult ) ] ) >= TOT_PAGINA
					aAdd( aPesqResult, {} )
				EndIf

				// Monta consulta para tabela de Clientes (SA1) - aChaves[ 2 ]
				cQry := CriaQuery( 	cStr, nX, nOption, nOpcPesq, nNivel, .T., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
									
				AbreQuery( "TRB", cQry, aCposADE )
				PopulaResult()	// Gera vetor aPesqResult com os clientes encontrados

			EndIf
			
		Endif
		
	EndIf
	
	// Verifica se deve processar o proximo nivel de aChaves
	If nX == 2 .And. ! aContinua[ 3 ]
		Exit
	EndIf
	
	//
	//	Seleciona Prospects (SUS) - aChaves[ 3 ]
	//
	nNivel := 3		// Prospects
	
	If Empty( aChaves[ nNivel, nOption ] )
		aContinua[ 4 ] := .T.
	Else
		
		// Fecha query da consulta da entidade anterior
		Eval( bFechaQuery, Iif( nX == 1, "TRB2", "TRB" ) )
		
		If nX == 1
			
			nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, 0 )
			
			// Se nao tem total, verifica se existem resultados no nivel de pesquisa
			If nTotQry == 0
				
				// Monta consulta para tabela de Prospects (SUS) - aChaves[ 3 ]
				cQry := CriaQuery( 	cStr, nX, nOption, nOpcPesq, nNivel, .T., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
				
				AbreQuery( "TRB2", cQry, aCposADE )
				
				nTotQry := TRB2->COUNT
				
				If nTotQry > 0
					nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, nTotQry )
				EndIf

			EndIf
			
			nTotQry -= aLinResult[ nNivel, 2 ]
			
			aCountPesq[ nNivel ] := nTotQry + aCountPesq[ 2 ]
			aTotNvPesq[ nNivel ] := nTotQry
			aTotalPesq[ nNivel ] := Iif( aTotalPesq[ nNivel ] == 0, aCountPesq[ nNivel ], aTotalPesq[ nNivel ] )
			
			// Caso tenha menos que TOT_PAGINA registros em tela, então continuo a pesquisa para preencher a primeira pagina
			aContinua[ 4 ] := aCountPesq[ nNivel ] < TOT_PAGINA
			If ! aContinua[ 4 ]
				Loop
			EndIf
			
		Else
			
			If aTotNvPesq[ nNivel ] > 0 
			
				If Len( aPesqResult[ Len( aPesqResult ) ] ) >= TOT_PAGINA
					aAdd( aPesqResult, {} )
				EndIf

				// Monta consulta para tabela de Prospects (SUS) - aChaves[ 3 ]
				cQry := CriaQuery( 	cStr, nX, nOption, nOpcPesq, nNivel, .T., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
									
				AbreQuery( "TRB", cQry, aCposADE )
				PopulaResult()	// Gera vetor aPesqResult com os Prospects encontrados
				
			EndIf
			
		Endif
		
	EndIf
	
	// Verifica se deve processar o proximo nivel de aChaves
	If nX == 2 .And. ! aContinua[ 4 ]
		Exit
	EndIf
	
	//
	//	Seleciona Contatos (SU5) - aChaves[ 4 ]
	//
	nNivel := 4		// Contatos
	
	If Empty( aChaves[ nNivel, nOption ] )
		aContinua[ 5 ] := .T.
	Else
		
		// Fecha query da consulta da entidade anterior
		Eval( bFechaQuery, Iif( nX == 1, "TRB2", "TRB" ) )
		
		If nX == 1
			
			nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, 0 )
			
			// Se nao tem total, verifica se existem resultados no nivel de pesquisa
			If nTotQry == 0
				
				// Monta consulta para tabela de Contatos (SU5) - aChaves[ 4 ]
				cQry := CriaQuery(	cStr, nX, nOption, nOpcPesq, nNivel, .T., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )				
				
				AbreQuery( "TRB2", cQry, aCposADE )
				
				nTotQry := TRB2->COUNT

				If nTotQry > 0
					nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, nTotQry )
				EndIf

			EndIf
			
			nTotQry -= aLinResult[ nNivel, 2 ]
			
			aCountPesq[ nNivel ] := nTotQry + aCountPesq[ 3 ]
			aTotNvPesq[ nNivel ] := nTotQry
			aTotalPesq[ nNivel ] := Iif( aTotalPesq[ nNivel ] == 0, aCountPesq[ nNivel ], aTotalPesq[ nNivel ] )
			
			// Caso tenha menos que TOT_PAGINA registros em tela, então continuo a pesquisa para preencher a primeira pagina
			aContinua[ 5 ] := aCountPesq[ nNivel ] < TOT_PAGINA
			If ! aContinua[ 5 ]
				Loop
			EndIf
			
		Else
			
			If aTotNvPesq[ nNivel ] > 0 
			
				If Len( aPesqResult[ Len( aPesqResult ) ] ) >= TOT_PAGINA
					aAdd( aPesqResult, {} )
				EndIf
			
				// Monta consulta para tabela de Contatos (SU5) - aChaves[ 4 ]
				cQry := CriaQuery(	cStr, nX, nOption, nOpcPesq, nNivel, .T., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
				
				AbreQuery( "TRB", cQry, aCposADE )				
				PopulaResult()	// Gera vetor aPesqResult com os Contatos encontrados
				
			EndIf
			
		Endif
		
	EndIf
	
	// Verifica se deve processar o proximo nivel de aChaves
	If nX == 2 .And. ! aContinua[ 5 ]
		Exit
	EndIf
	
	//
	//	Seleciona Postos de Atendimento (SZ3) - aChaves[ 5 ]
	//
	nNivel := 5		// Postos de Atendimento
	
	If Empty( aChaves[ nNivel, nOption ] )
		aContinua[ 6 ] := .T.
	Else
		
		// Fecha query da consulta da entidade anterior
		Eval( bFechaQuery, Iif( nX == 1, "TRB2", "TRB" ) )
		
		If nX == 1
			
			nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, 0 )
			
			// Verifica se existem resultados no nivel de pesquisa
			If nTotQry == 0
				
				// Monta consulta para tabela de Postos de Atendimento (SZ3) - aChaves[ 5 ]
				cQry := CriaQuery(	cStr, nX, nOption, nOpcPesq, nNivel, .T., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
				
				AbreQuery( "TRB2", cQry, aCposADE )
				
				nTotQry := TRB2->COUNT
				
				If nTotQry > 0
					nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, nTotQry )
				EndIf
				
			EndIf
			
			nTotQry -= aLinResult[ nNivel, 2 ]
			
			aCountPesq[ nNivel ] := nTotQry + aCountPesq[ 4 ]
			aTotNvPesq[ nNivel ] := nTotQry
			aTotalPesq[ nNivel ] := Iif( aTotalPesq[ nNivel ] == 0, aCountPesq[ nNivel ], aTotalPesq[ nNivel ] )
			
			// Caso tenha menos que TOT_PAGINA registros em tela, então continuo a pesquisa para preencher a primeira pagina
			aContinua[ 6 ] := aCountPesq[ nNivel ] < TOT_PAGINA
			If ! aContinua[ 6 ]
				Loop
			EndIf
			
		Else

			If aTotNvPesq[ nNivel ] > 0 
			
				If Len( aPesqResult[ Len( aPesqResult ) ] ) >= TOT_PAGINA
					aAdd( aPesqResult, {} )
				EndIf
			
				// Monta consulta para tabela de Postos de Atendimento (SZ3) - aChaves[ 5 ]
				cQry := CriaQuery(	cStr, nX, nOption, nOpcPesq, nNivel, .T., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
									
				AbreQuery( "TRB", cQry, aCposADE )
				PopulaResult() 	// Gera vetor aPesqResult com os postos encontrados
				
			EndIf
			
		Endif
		
	EndIf
	
	// Verifica se deve processar o proximo nivel de aChaves
	If nX == 2 .And. ! aContinua[ 6 ]
		Exit
	EndIf
	
	//
	//	Seleciona Suspects (ACH) - aChaves[ 6 ]
	//
	nNivel := 6		// Suspects
	
	If Empty( aChaves[ nNivel, nOption ] )
		aContinua[ 7 ] := .T.
	Else
		
		// Fecha query da consulta da entidade anterior
		Eval( bFechaQuery, Iif( nX == 1, "TRB2", "TRB" ) )
		
		If nX == 1
			
			nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, 0 )
			
			// Verifica se existem resultados no nivel de pesquisa
			If nTotQry == 0
				
				// Monta consulta para tabela de Suspects (ACH) - aChaves[ 6 ]
				cQry := CriaQuery(	cStr, nX, nOption, nOpcPesq, nNivel, .T., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
				
				AbreQuery( "TRB2", cQry, aCposADE )
				
				nTotQry := TRB2->COUNT

				If nTotQry > 0
					nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, nTotQry )
				EndIf
				
			EndIf
			
			nTotQry -= aLinResult[ nNivel, 2 ]
			
			aCountPesq[ nNivel ] := nTotQry + aCountPesq[ 5 ]
			aTotNvPesq[ nNivel ] := nTotQry
			aTotalPesq[ nNivel ] := Iif( aTotalPesq[ nNivel ] == 0, aCountPesq[ nNivel ], aTotalPesq[ nNivel ] )
			
			// Caso tenha menos que TOT_PAGINA registros em tela, então continuo a pesquisa para preencher a primeira pagina
			aContinua[ 7 ] := aCountPesq[ nNivel ] < TOT_PAGINA
			If ! aContinua[ 7 ]
				Loop
			EndIf
			
		Else

			If aTotNvPesq[ nNivel ] > 0 
			
				If Len( aPesqResult[ Len( aPesqResult ) ] ) >= TOT_PAGINA
					aAdd( aPesqResult, {} )
				EndIf

				// Monta consulta para tabela de Suspects (ACH) - aChaves[ 6 ]
				cQry := CriaQuery(	cStr, nX, nOption, nOpcPesq, nNivel, .T., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
									
				AbreQuery( "TRB", cQry, aCposADE )
				PopulaResult()	// Gera vetor aPesqResult com os Suspects encontrados

			EndIf
			
		Endif
		
	EndIf
	
	// Verifica se deve processar o proximo nivel de aChaves
	If nX == 2 .And. ! aContinua[ 7 ]
		Exit
	EndIf
	
	//
	//	Seleciona Common Name (SZT) - aChaves[ 7 ]
	//
	nNivel := 7 	// Common Name
	
	If Empty( aChaves[ nNivel, nOption ] )
		aContinua[ 8 ] := .T.
	Else
		
		// Fecha query da consulta da entidade anterior
		Eval( bFechaQuery, Iif( nX == 1, "TRB2", "TRB" ) )
		
		If nX == 1
			
			nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, 0 )
			
			// Verifica se existem resultados no nivel de pesquisa
			If nTotQry == 0
				
				// Monta consulta para tabela de Common Name (SZT) - aChaves[ 7 ]
				cQry := CriaQuery(	cStr, nX, nOption, nOpcPesq, nNivel, .T., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
				
				AbreQuery( "TRB2", cQry, aCposADE )
				
				nTotQry := TRB2->COUNT

				If nTotQry > 0
					nTotQry := TotQuery( cStr, nOption, nOpcPesq, nNivel, nTotQry )
				EndIf
				
			EndIf
			
			nTotQry -= aLinResult[ nNivel, 2 ]
			
			aCountPesq[ nNivel ] := nTotQry + aCountPesq[ 6 ]
			aTotNvPesq[ nNivel ] := nTotQry
			aTotalPesq[ nNivel ] := Iif( aTotalPesq[ nNivel ] == 0, aCountPesq[ nNivel ], aTotalPesq[ nNivel ] )
			
			// Caso tenha menos que TOT_PAGINA registros em tela, então continuo a pesquisa para preencher a primeira pagina
			aContinua[ 8 ] := aCountPesq[ nNivel ] < TOT_PAGINA
			If ! aContinua[ 8 ]
				Loop
			EndIf
			
		Else
			
			If aTotNvPesq[ nNivel ] > 0 
			
				If Len( aPesqResult[ Len( aPesqResult ) ] ) >= TOT_PAGINA
					aAdd( aPesqResult, {} )
				EndIf
				
				// Monta consulta para tabela de Common Name (SZT) - aChaves[ 7 ]
				cQry := CriaQuery(	cStr, nX, nOption, nOpcPesq, nNivel, .T., aCposADE, aTabNivel[ nNivel ], aUsaFuncao, cWhereGrp )
				
				AbreQuery( "TRB", cQry, aCposADE )
				PopulaResult()	// Gera vetor aPesqResult com os Commom names encontrados
			
			EndIf
				
		EndIf
		
	EndIf
	
	// Verifica se deve processar o proximo nivel de aChaves
	If nX == 2 .And. ! aContinua[ 8 ]
		Exit
	EndIf
	
Next

AFill( aCountPesq, 0 )
AFill( aContinua, .F. )

aContinua[ 1 ] := .T.

If Len( aPesqResult[ Len( aPesqResult ) ] ) == 0
	AEval( aPesqCols, { |x| Iif( NtoL( x[ COL_STS ] ), cLinha += '"",', .T. ) } )
	cLinha := SubStr( cLinha, 1, Len( cLinha ) - 1 )
	oListResult:bLine := { || StrToKArr( cLinha, "," ) }
Else
	SetListResult( Len( aPesqResult ) )
EndIf

RestArea( aArea )

Return( ! Empty( aPesqResult[ Len( aPesqResult ) ] ) )

/*
------------------------------------------------------------------------------
| Rotina     | ValidaPesquisa | Autor | Gustavo Prudente | Data | 28.06.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Realiza a validacao da string informada para pesquisa.        |
|----------------------------------------------------------------------------|
| Parametros | EXPC1 - String de pesquisa para busca nos atendimentos.       |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function ValidaPesquisa( cStr )

Local lRet		:= .F.
Local cStr		:= AllTrim( cStr )
Local aInvalido	:= { '"', "'", "<", ">" }
Local nX		:= 0

If Len( cStr ) > 2
	lRet := .T.
	For nX := 1 To Len( aInvalido )
		If aInvalido[ nX ] $ cStr
			lRet := .F.
			MsgStatus( "Pesquisa inválida - Favor remover o caracter " + aInvalido[ nX ] )
			Exit
		EndIf
	Next
Else
	MsgStatus( "Pesquisa inválida - Digite no mínimo 3 caracteres!" )
EndIf

If !lRet
	Oculta()
EndIf

Return( lRet )


/*
------------------------------------------------------------------------------
| Rotina     | PopulaResult   | Autor | Gustavo Prudente | Data | 28.06.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Atualiza lista com os resultados da pesquisa.                 |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function PopulaResult()

Local nPos    		:= 0
Local nLinhas 		:= 0
Local nPagina 		:= RetPagina()
Local nPosGrp 		:= 0                     
Local nX			:=0
Local aLinRes		:= {}

Local cNomeGrp		:= ""

Do While ! Eof()
	                                                  
	nPos := Ascan( aLinResult, { |x| x[ 1 ] == ALIAS } )
	
	// Controle de linha encontrada na pesquisa por nivel de pesquisa
	If nPos > 0 .And. LINHA > aLinResult[ nPos, 2 ]
		aLinResult[ nPos, 2 ] := LINHA
	EndIf
	
	If Len( aPesqResult ) > 1
		nLinhas := Len( aPesqResult[ Len( aPesqResult ) ] ) + aPesqResult[ nPagina, TOT_PAGINA, 1 ] + 1
	Else
		nLinhas := Len( aPesqResult[ Len( aPesqResult ) ] ) + 1
	EndIf

	// Cria vetor temporario de conteudo de linha	
	aLinRes := {}            
	
	// Adiciona duas colunas fixas de total de linhas e numero de protocolo
	AAdd( aLinRes, nLinhas )
	AAdd( aLinRes, NUMPROT )
	                        
	// Percorre array de colunas de pesquisa buscando as informacoes para apresentar
	For nX := 1 To Len( aPesqCols )
	                                       
		// Somente adiciona nos resultados as colunas habilitadas
		If NtoL( aPesqCols[ nX, COL_STS ] )
			If aPesqCols[ nX, COL_CPO, 1 ]	// Se usa funcao GetCol
			    AAdd( aLinRes, GetCol( NUMPROT, aPesqCols[ nX, COL_CPO, 2 ], aPesqCols[ nX, COL_CPO, 3 ] ) )
			Else
				AAdd( aLinRes, &( aPesqCols[ nX, COL_CPO, 2 ] ) )
			EndIf
		EndIf		

	Next nX                 
	
	//Renato Ruy - 10/08/2017
	//OTRS: 2017072010002219 
	//Caso não exista o protocolo no array, adiciona.
	If AScan( aPesqResult[1], {|a| a[2] == aLinRes[2] }) = 0
		AAdd( aPesqResult[ Len( aPesqResult ) ], aLinRes )
	Endif
	
	DbSkip()
	                                                                        
EndDo

Return( .T. )

/*
------------------------------------------------------------------------------
| Rotina     | GetCol     | Autor | Gesse / Gustavo      | Data | 10.02.2014 |
|----------------------------------------------------------------------------|
| Descricao  | Busca o informacoes do atendimento a partir do numero do      |
|            | protocolo da pesquisa principal.                              |
|----------------------------------------------------------------------------|
| Parametros | EXPC1 - Numero do protocolo do atendimento                    |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function GetCol( cNumProt, cRef, lCpoADE )

Local uRet	 		:= ""

Local lErro			:= .F.
Local bError 		:= ErrorBlock( { || lErro := .T. } )

Local cContext		:= ""                                              
Local cX3IniBrw	    := ""
Local cAlias 		:= Alias()

Local nPosGrp		:= 0

If ! Empty( cNumProt )
                            
	// Posiciona no protocolo do resultado da pesquisa
	ADE->( DbSetOrder( 1 ) )	
	If ADE->( DbSeek( aFilSDK[ XFIL_ADE ] + cNumProt ) )
            
		// Buscar informacoes da tabela ADE
		If lCpoADE          

			uRet := "0-Não conforme"

			Begin Sequence            
				cContext := GetSX3Cache( cRef, "X3_CONTEXT" )
				If cContext == "R"
					// Retorna conteudo do campo da ADE posicionada
					uRet := &( "ADE->" + cRef )
				ElseIf cContext == "V"	
					cX3IniBrw := GetSX3Cache( cRef, "X3_INIBRW" )
					If Empty( cX3IniBrw )
						uRet := "0-Não identificado"
					Else	                                       
						// Executa a expressao do campo X3_INIBRW
						uRet := &( cX3IniBrw )
					EndIf	
				Else
					uRet := "0-Não identificado"
				EndIf		            
			End Sequence

			// Realiza tratamento caso nao consiga executar a macro
			ErrorBlock( bError )           

		// Usa funcoes ou monta expressao especifica para apresentar o resultado
		Else

			If cRef == "PESQ_CPF"
				// Pesquisa CPF/CNPJ em todas as entidades possiveis do atendimento
				uRet := GetCpf( AllTrim( ADE->ADE_ENTIDA ), AllTrim( ADE->ADE_CHAVE ) )

			ElseIf cRef == "GRUPO"

				// Pesquisa codigo do grupo e apresenta a descricao
			 	nPosGrp := AScan( aGrpSDK, { |x| x[ 1 ] == GRUPO } )
				If nPosGrp == 0           
					uRet := "0-Não identificado"
				Else
					uRet := aGrpSDK[ nPosGrp, 2 ]
				EndIf

			EndIf	

		EndIf

	EndIf

EndIf

dbSelectArea( cAlias ) 

Return( Iif( lErro, "0-Não conforme", uRet ) )

/*
------------------------------------------------------------------------------
| Rotina     | VoltaPagina    | Autor | Gustavo Prudente | Data | 19.07.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Executa acao do botao voltar para navegacao no resultado      |
|            | da pesquisa principal.                                        |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function VoltaPagina()

Local nPagina 	:= 0
Local nTotPesq	:= 0

nPagina := RetPagina() - 1

If nPagina == 1
	oBtnAnt:Disable()
	// Habilita o botao "Avancar" se existirem mais itens do que o total de uma pagina
	AEval( aPesqResult, { |x| nTotPesq += Len( x ) } )
	If nTotPesq > TOT_PAGINA
		oBtnProx:Enable()
	EndIf
ElseIf nPagina < Len( aPesqResult )
	oBtnProx:Enable()
EndIf

SetListResult( nPagina )

// Atualiza objetos com o novo resultado da pesquisa
AtuObjPesq()

Return( .T. )

/*
------------------------------------------------------------------------------
| Rotina     | ProxPagina     | Autor | Gustavo Prudente | Data | 23.07.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Controla avanco de pagina na navegacao dos resultados         |
|----------------------------------------------------------------------------|
| Parametros | EXPC1 - Chave para pesquisa e geracao de uma nova pagina      |
|            | EXPN2 - Tipo de pesquisa selecionado                          |
|            | EXPA3 - Vetor com os grupos que devem retornar atendimentos   |
|            |         no resultado da pesquisa.                             |
|            | EXPA4 - Opcao de pesquisa forcada por outra rotina            |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function ProxPagina( cStr, nOpcPesq, aGrpPesq, nOpcFld )

Local nTotItens := 0
Local nPagina	:= 0
Local nTotPesq	:= 0
                      
Default nOpcFld	:= oFldPesq:nOption
Default cStr	:= ""

nPagina := RetPagina()
lNovos  := ! Empty( cStr ) .And. nPagina == Len( aPesqResult )

// Se informou alguma string para pesquisa e eh a ultima pagina, busca novos resultados
If lNovos
	MsgStatus( "Aguarde ...", 2 )
	CursorWait()
	BuscaResult( cStr, nOpcPesq, .T., aGrpPesq, nOpcFld )
EndIf

// Realiza controles dos botoes "Voltar" e "Avancar"
nPagina ++

AEval( aTotalPesq , { |x| nTotItens += x } )
AEval( aPesqResult, { |x| nTotPesq  += Len( x ) } )

If nTotItens >= nTotPesq .And. Len( aPesqResult[ Len( aPesqResult ) ] ) == TOT_PAGINA
	oBtnProx:Enable()
	If nPagina > 1
		oBtnAnt:Enable()
	EndIf
Else
	// Desabilita botao para avancar pagina se ja estiver na ultima linha do array de resultados
	If nPagina == Len( aPesqResult )
		oBtnProx:Disable()
	EndIf
	oBtnAnt:Enable()
EndIf

// Caso existam novos resultados, atualiza objetos com o novo resultado da pesquisa.
SetListResult( nPagina )
AtuObjPesq()

If lNovos
	CursorArrow()
	MsgStatus()
EndIf

Return( .T. )

/*
------------------------------------------------------------------------------
| Rotina     | RetPagina      | Autor | Gustavo Prudente | Data | 23.07.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Retorna pagina atualmente posicionada                         |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function RetPagina()

Local nX     		:= 0
Local nItem  		:= 0
Local nLinha 		:= 0
Local nLbxPosLin	:= 0
Local nResPosLin	:= 0
              
If Len( oListResult:aArray ) > 0
	nLinha := oListResult:aArray[ oListResult:nAt, 1 ]
EndIf

For nX := 1 To Len( aPesqResult )                  
	nItem := AScan( aPesqResult[ nX ], { |x| x[ 1 ] == nLinha } )
	If nItem > 0
		Exit
	EndIf
Next nX

Return( nX )

/*
------------------------------------------------------------------------------
| Rotina     | SetListResult  | Autor | Gustavo Prudente | Data | 24.07.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Atualiza vetor com os itens de resultado da pesquisa          |
|----------------------------------------------------------------------------|
| Parametros | EXPN1 - Numero da pagina que deve ter a lista de resultados   |
|            |         atualizada.                                           |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function SetListResult( nPagina )

Local nX		:= 0               
Local nCol		:= 3		// Comeca apos a posicao da coluna de total de linhas e numero de protocolo
Local cLinha	:= ""
                                   
For nX := 1 To Len( aPesqCols )
	If NToL( aPesqCols[ nX, COL_STS ] )                                                    
		cLinha += "aPesqResult[nPagina,oListResult:nAt," + AllTrim( Str( nCol ) ) + "], "
		nCol ++		
	EndIf	
Next nX            

cLinha := AllTrim( cLinha )
cLinha := "{ || { " + SubStr( cLinha, 1, Len( cLinha ) - 1 ) + " } }"

oListResult:SetArray( aPesqResult[ nPagina ] )

oListResult:bLine := &cLinha
oListResult:Refresh() 

Return( .T. )


/*
------------------------------------------------------------------------------
| Rotina     | ChangeFldPesq  | Autor | Gustavo Prudente | Data | 26.07.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Atualiza objetos da tela de pesquisa na mudanca de folder     |
|----------------------------------------------------------------------------|
| Parametros | EXPC1 - String para pesquisa esquisa na mudanca de folder     |
|            | EXPA2 - Abas do folter de pesquisa customizadas               |
|            | EXPO3 - Objeto de preenchimento da string para pesquisa       |
|            | EXPL4 - Indica se eh chamado do botao Buscar                  |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function ChangeFldPesq( cPesq, aBusca, oGetPesq, lBtnBuscar )
                       
Local nRemoteType	:= GetRemoteType()

lBtnBuscar	:= .F.
aPesqResult	:= { { } }

If nRemoteType # 5
	cPesq := "PESQUISAR POR " + Upper( SubStr( aBusca[ oFldPesq:nOption ], 2, Len( aBusca[ oFldPesq:nOption ] ) ) ) + "..." + Space( 200 )
EndIf

oListResult:bLine := { || { 0, "", "", "", "", "", "" } }

SetListResult( Len( aPesqResult ) )

Oculta()
MsgStatus()

oGetPesq:Refresh()
oGetPesq:SetFocus()

Return( .T. )


/*
------------------------------------------------------------------------------
| Rotina     | Oculta         | Autor | Gustavo Prudente | Data | 26.07.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Inibe objetos da tela de pesquisa de atendimentos, para       |
|            | evitar utilização dos controles em caso de nao encontrar      |
|            | resultado.                                                    |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function Oculta()

oGetDADF:Hide()

oMemo1:Hide()
oMemo2:Hide()
oMemo3:Hide()

oBtnEdit:Hide()
oBtnOk:Hide()
oBtnProx:Hide()
oBtnAnt:Hide()

oListResult:Hide()
oSplitter:Hide()

Return( .T. )


/*
------------------------------------------------------------------------------
| Rotina     | Exibe          | Autor | Gustavo Prudente | Data | 26.07.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Exibe objetos da tela de pesquisa de atendimentos, para       |
|            | permitir utilização dos controles.                            |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function Exibe()

oGetDADF:Show()

oMemo1:Show()
oMemo2:Show()
oMemo3:Show()

oBtnEdit:Show()
oBtnOk:Show()
oBtnProx:Show()
oBtnAnt:Show()

oListResult:Show()
oSplitter:Show()

Return( .T. )

/*
------------------------------------------------------------------------------
| Rotina     | XLoadBitmaps   | Autor | Gustavo Prudente | Data | 29.07.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Atualiza imagens dos botoes de tipo de pesquisa selecionada   |
|----------------------------------------------------------------------------|
| Parametros | EXPN1 - Opcao de tipo de pesquisa atualmente selecionada      |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function XLoadBitmaps( nAtu )

Static nOld

Local aLegendas := { { "TEXTLEFT", "ESQTIC" }, { "TEXTCENTER", "CENTIC" }, { "TEXTRIGHT", "DIRTIC" }, { "TEXTJUSTIFY", "JUSTIC" } }

nOld := Iif( nOld == NIL, 1, nOld )

&( "oBtn" + CValToChar( nOld ) + "Pesq" ):LoadBitmaps( aLegendas[ nOld, 1 ] )
&( "oBtn" + CValToChar( nAtu ) + "Pesq" ):LoadBitmaps( aLegendas[ nAtu, 2 ] )

nOld := nAtu

Return( .T. )


/*
------------------------------------------------------------------------------
| Rotina     | RetPesq        | Autor | Gustavo Prudente | Data | 29.07.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Retorna string formatada com a chave para pesquisa de acordo  |
|            | com a o tipo de pesquisa selecionada.                         |
|----------------------------------------------------------------------------|
| Parametros | EXPC1 - String a ser pesquisada na base de atendimentos       |
|            | EXPN2 - Tipo de pesquisa atualmente selecionada.              |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function RetPesq( cStr, nOpcPesq )

Default cStr := ""
Default nOpcPesq := 1

If ! Empty( cStr )
	
	If nOpcPesq == 1
		cStr := AllTrim( cStr ) + "%"
		
	ElseIf nOpcPesq == 2
		cStr := "%" + AllTrim( cStr ) + "%"
		
	ElseIf nOpcPesq == 3
		cStr := "%" + Alltrim( cStr )
		
	ElseIf nOpcPesq == 4
		cStr := "%" + StrTran( Alltrim( cStr ), " ", "%" ) + "%"
	EndIf
	
EndIf

Return( cStr )


/*
------------------------------------------------------------------------------
| Rotina     | AbreQuery        | Autor | Gustavo Prudente | Data | 01.08.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Abre Query da entidade do nivel e executa TCSetField em campos|
|            | da Query                                                      |
|----------------------------------------------------------------------------|
| Parametros | EXPC1 - Alias da tabela que tera os campos tratados.          |
|            | EXPC2 - Query criada para buscar os resultados da entidade    |
|            | EXPA3 - Array com os campos que devem ser tratados por        |
|            |         TCSetField.                                           |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function AbreQuery( cAlias, cQuery, aCampos )

Local nX := 0

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAlias, .F., .T. )

For nX := 1 To Len( aCampos )
	// Sera verdadeiro se precisa executar TCSetField
	If aCampos[ nX, 3, 1 ]
		TCSetField( cAlias, aCampos[ nX, 2 ], aCampos[ nX, 3, 2 ], aCampos[ nX, 3, 3 ]  )
	EndIf
Next nY

Return( .T. )


/*
------------------------------------------------------------------------------
| Rotina     | ItensADF       | Autor | Gustavo Prudente | Data | 02.08.2013 |
|----------------------------------------------------------------------------|
| Descricao  | Atualiza itens do atendimento posicionado.                    |
|----------------------------------------------------------------------------|
| Parametros | EXPL1 - Indica se eh inclusao de um novo item de atendimento. |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function ItensADF( lNovo )

Local cProtocolo	:= ""
Local cX3Campo		:= ""
Local cProxItem		:= ""
Local cCampos		:= ""
Local cAlias		:= Alias()
Local cOperador		:= ""

Local nLinha		:= 0
Local nX			:= 0
Local nItem	 		:= oListResult:nAt
Local nPagina		:= RetPagina()
Local nLenHeadADF	:= Len( aHeadADF )
Local aADFNew     := {}
Local n1          := 0

Default lNovo		:= .F.

If lNovo
	
	INCLUI := .T.
	ALTERA := .F.
	
	cOperador := AllTrim( TkOperador() )
	cProxItem := Soma1( aColsADF[ Len( aColsADF ), 1 ] )
	
	AAdd( aColsADF, Array( nLenHeadADF + 1 ) )
	
	nLinha := Len( aColsADF )
	
	For nX := 1 To nLenHeadADF
		cX3Campo := AllTrim( aHeadADF[ nX, 2 ] )
		If nX == 1
			aColsADF[ nLinha, nX ] := cProxItem
		Else
			// Atualiza analista e data no novo item de interacao no atendimento
			If cX3Campo == "ADF_CODSU7"
				aColsADF[ nLinha, nX ] := cOperador
			ElseIf cX3Campo == "ADF_NMSU7"
				aColsADF[ nLinha, nX ] := Posicione( "SU7", 1, aFilSDK[ XFIL_SU7 ] + cOperador, "U7_NOME" )
			ElseIf cX3Campo == "ADF_DATA"
				aColsADF[ nLinha, nX ] := Iif( ! IsInCallStack( "GenRecurrence" ), Date(), dDatabase )
			ElseIf cX3Campo == "ADF_HORA"
				aColsADF[ nLinha, nX ] := Time()
			Else
				aColsADF[ nLinha, nX ] := CriaVar( cX3Campo, .F. )
			EndIf
		EndIf
	Next
	
	aColsADF[ nLinha, nLenHeadADF + 1 ] := .F.
	
	oGetDADF:SetArray( aColsADF )
	oGetDADF:GoBottom()
	oGetDADF:oBrowse:nAt := Len( aColsADF )
	
Else
	
	aColsADF	:= {}
	cProtocolo	:= aPesqResult[ nPagina, nItem, POS_NUMPROT ]
	
	cCampos += "ADF.ADF_CODIGO, "
	
	AEval( aHeadADF, { |aCpoHead| Iif( aCpoHead[ 10 ] # "V" .And. aCpoHead[ 2 ] # "ADF_OBS", cCampos += "ADF." + AllTrim( aCpoHead[ 2 ] ) + ", ", .T. ) } )
	
	cCampos += "ADF.ADF_CODOBS, SUQ.UQ_DESC, SU7.U7_NOME, ADF.ADF_DATA"
	cCampos := "%" + cCampos + "%"
	
	BeginSql Alias "TRBADF"
		
		Column ADF_DATA AS Date
		
		SELECT %Exp:cCampos%
		FROM %Table:ADF% ADF
		LEFT	JOIN %Table:SUQ% SUQ ON
			SUQ.UQ_FILIAL  = %xFilial:SUQ%  AND
			SUQ.UQ_SOLUCAO = ADF.ADF_CODSUQ AND
			SUQ.%notDel%
		LEFT	JOIN %Table:SU7% SU7 ON
			SU7.U7_FILIAL = %xFilial:SU7%  AND
			SU7.U7_COD    = ADF.ADF_CODSU7 AND
			SU7.%notDel%
		WHERE
			ADF.ADF_FILIAL = %xFilial:ADF%    AND
			ADF.ADF_CODIGO = %Exp:cProtocolo% AND
			ADF.%notDel%
		ORDER BY ADF.ADF_CODIGO, ADF.ADF_ITEM
		
	EndSql
	
	While ! EoF()
		
		AAdd( aColsADF, Array( nLenHeadADF + 1 ) )
		
		nLinha := Val( TRBADF->ADF_ITEM )
		
		IF nLinha <> Len( aColsADF )
			AAdd( aColsADF, Array( nLenHeadADF + 1 ) )
		EndIF
		
		For nX := 1 To nLenHeadADF
			
			cX3Campo := AllTrim( aHeadADF[ nX, 2 ] )
			
			If cX3Campo == "ADF_NMSU9"
				aColsADF[ nLinha, nX ] := Posicione( "SU9", 2, aFilSDK[ XFIL_SU9 ] + TRBADF->ADF_CODSU9, "U9_DESC" )
			ElseIf cX3Campo == "ADF_NMSUQ"
				aColsADF[ nLinha, nX ] := TRBADF->UQ_DESC
			ElseIf cX3Campo == "ADF_NMSU7"
				aColsADF[ nLinha, nX ] := TRBADF->U7_NOME
			ElseIf cX3Campo == "ADF_OBS"
				aColsADF[ nLinha, nX ] := MSMM( TRBADF->ADF_CODOBS )
			EndIf
			
			If aHeadADF[ nX, 10 ] # "V"
				aColsADF[ nLinha, nX ] := FieldGet( FieldPos( cX3Campo ) )
			EndIf
			
		Next
		
		aColsADF[ nLinha, nLenHeadADF + 1 ] := .F.
		
		dbSkip()
		
	EndDo
	
	oGetDADF:SetArray( aColsADF )
	
	TRBADF->( DbCloseArea() )
	dbSelectArea( cAlias )
	
EndIf

oGetDADF:Refresh()

Return( .T. )


/*
--------------------------------------------------------------------------------
| Rotina     | CriaQuery      | Autor | Gustavo Prudente | Data | 07.08.2013   |
|------------------------------------------------------------------------------|
| Descricao  | Executa query para pesquisa dos resultados da funcao            |
|            | BuscaResult()                                                   |
|------------------------------------------------------------------------------|
| Parametros | EXPC1  - String para pesquisa nas chaves das tabelas            |
|            | EXPN2  - 1-Conta quantidade de linhas do resultado da pesquisa  |
|            |          2-Retorna os resultados da pesquisa                    |
|            | EXPN3  - Opcao de chave de pesquisa selecionada 				   |
|            | EXPN4  - Tipo de pesquisa selecionado                           |
|            | EXPN5  - Nivel de pesquisa atualmente realizada, de acordo      |
|            |          com a chamada em BuscaResult()                         |
|            | EXPL6  - Indica se deve fazer o join entre a tabela em pesquisa |
|            |          atualmente posicionada e a tabela de atendimentos      |
|            | EXPA7  - Array com equivalencia de campos entre ADE e Query     |
|            | EXPA8  - Array com as informacoes que compoem o resultado da    |
|            |          pesquisa em tela, extraidas da tabela de atendimentos  |
|            | EXPA9  - Array com as informacoes da tabela do nivel atual      |
|            |          em pesquisa na rotina BuscaResult()                    |
|            | EXPA10 - Grupos que podem retornar resultados na pesquisa, de   |
|            |          acordo com a configuracao dos grupos do operador.      |
|------------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                             |
--------------------------------------------------------------------------------
*/
Static Function CriaQuery( 	cStr, nCont, nOption, nOpcPesq, nNivel, lJoinADE, ;
							aCposADE, aTabInfo, aUsaFuncao, cWhereGrp )

Local cFilAlias	 := xFilial( aTabInfo[ QRY_ALIAS ] )
Local cQry		 := ""
Local cChave	 := ""
Local nX		 := 0
Local nChv		 := 0
Local nTotChv	 := 1

Default cWhereGrp := ""

// Verifica se foi passado mais de um campo como chave para pesquisa
If Valtype( aChaves[ nNivel, nOption ] ) == "A"
	nTotChv := Len( aChaves[ nNivel, nOption ] )
EndIf

For nChv := 1 To nTotChv
	
	If nTotChv == 1
		cChave := aChaves[ nNivel, nOption ]
	Else
		cChave := aChaves[ nNivel, nOption, nChv ]
		If nCont == 1 .And. nChv == 1
			cQry += "SELECT SUM( COUNT ) AS COUNT FROM ( "
		EndIf
	EndIf
	
	If nCont == 1
		cQry += "SELECT COUNT( LINHA ) AS COUNT FROM ( "
		cQry += "SELECT ROWNUM AS LINHA FROM " + aTabInfo[ QRY_NOME ] + " " + aTabInfo[ QRY_ALIAS ] + " "
	Else
		// Primeiro campo de chave, deve iniciar todos os niveis de SELECT
		If nChv == 1
			cQry += "SELECT * FROM (
			cQry += "SELECT ALIAS, CHAVE, NUMPROT, DATA, STATUS, GRUPO, LINHA, ROWNUM AS TOTLINPAG FROM ( "
			cQry += "SELECT ALIAS, CHAVE, NUMPROT, DATA, STATUS, GRUPO, ROWNUM AS LINHA FROM ( "
		EndIf
		
		cQry += "SELECT " + aTabInfo[ QRY_ALIAS ] + "." + cChave + " AS CHAVE, "
		
		For nX := 1 To Len( aCposADE )
			cQry += " ADE." + aCposADE[ nX, 1 ] + " AS " + aCposADE[ nX, 2 ] + ", "
		Next nX
		
		cQry += " '" + aTabInfo[ QRY_STATUS ] + "' AS STATUS, " + " '" + aTabInfo[ QRY_CHVALIAS ] + "' AS ALIAS "
		cQry += " FROM " + aTabInfo[ QRY_NOME ] + " " + aTabInfo[ QRY_ALIAS ] + " "
	Endif
	
	If lJoinADE
		cQry += "INNER JOIN " + aTabSQL[ XTAB_ADE ] + " ADE ON "
		cQry += "ADE.ADE_FILIAL = '" + aFilSDK[ XFIL_ADE ] + "' AND "
		cQry += "ADE.ADE_ENTIDA = '" + aTabInfo[ QRY_ALIAS ]    + "' AND "
		If aTabInfo[ QRY_ALIAS ] == "SU5"
			cQry += "ADE.ADE_CODCON = " + aTabInfo[ QRY_CHAVE ] + " AND "
		Else
			If Len( aTabInfo ) >= QRY_FUNCNAME .And. ! Empty( aTabInfo[ QRY_FUNCNAME ] )
				cQry += "ADE.ADE_CHAVE "   + aTabInfo[ QRY_FUNCNAME ] + " " + aTabInfo[ QRY_CHAVE ] + " || '%' AND "
			Else
				cQry += "ADE.ADE_CHAVE = " + aTabInfo[ QRY_CHAVE ]    + " AND "
			EndIf
		EndIf
		cQry += "ADE.D_E_L_E_T_ = ' ' "
	EndIf
	
	// Monta clausula Where na tabela do nivel atual de pesquisa, conforme array aLinResult
	cQry += " WHERE "

	// Filtro por filial
	cQry += aTabInfo[ QRY_ALIAS ] + "." + aTabInfo[ QRY_FILIAL ] + " = '" + cFilAlias + "' AND "
	                    
	// Monta a clausula LIKE com funcao ou somente LIKE
	If aUsaFuncao[ nOption ]
		If nOpcPesq == 3
			cQry += " UPPER( TRIM( " + aTabInfo[ QRY_ALIAS ] + "." + cChave + " ) ) LIKE '" + cStr + "' "
		Else
			cQry += " UPPER( " + aTabInfo[ QRY_ALIAS ] + "." + cChave + " ) LIKE '" + cStr + "' "
		EndIf
	Else
		cQry += aTabInfo[ QRY_ALIAS ] + "." + cChave + " LIKE '" + cStr + "' "
	EndIf
	   
	// Seleciona somente atendimentos que o grupo do operador permitir
	If ! Empty( cWhereGrp )
		
		cQry += " AND ( SELECT COUNT( ADF.R_E_C_N_O_ ) "
        cQry += " FROM " + aTabSQL[ XTAB_ADF ] + " ADF "
		cQry += " WHERE	"
		cQry += " ADF.ADF_FILIAL = '" + aFilSDK[ XFIL_ADF ] + "' AND "
		cQry += " ADF.ADF_CODIGO = ADE.ADE_CODIGO AND "
 		
 		If At( ",", cWhereGrp ) > 0
	 		cQry += " ADF.ADF_CODSU0 IN " + FormatIn( cWhereGrp, "," ) + " AND "
	 	Else
	 		cQry += " ADF.ADF_CODSU0 = '" + cWhereGrp + "' AND "
	 	EndIf	
		
		cQry += " ADF.D_E_L_E_T_ = ' ' ) > 0 "
		
	EndIf
	
	cQry += " AND " + aTabInfo[ QRY_ALIAS ] + ".D_E_L_E_T_ = ' ' "
	
	If nCont == 1
		cQry += " )"
		// Se existem mais campos chave, cria proximas querys com Union
		If nChv < nTotChv
			cQry += " UNION "
		EndIf
	Else
		// 1o. SELECT: Total de resultados encontrados por ordem de data, atendimento mais novo para o mais antigo
		cQry += "AND ROWNUM <= " + CValToChar( aTotalPesq[ nNivel ] )
		// Se existem mais campos chave, cria proximas querys com Union
		If nChv < nTotChv
			cQry += " UNION "
		Else                   
			cQry += " ORDER BY DATA DESC ) ) "			
			// 2o. SELECT: So as linhas que estao faltando para completar os resultados no listbox da entidade atual
			If aLinResult[ nNivel, 2 ] > 0
				cQry += " WHERE LINHA > " + CValToChar( aLinResult[ nNivel, 2 ] )
			EndIf
			// 3o. SELECT: Quantas linhas devo trazer para completar a pagina atual
			cQry += " ) WHERE TOTLINPAG <= " + CValToChar( TOT_PAGINA - Len( aPesqResult[ Len( aPesqResult ) ] ) )
		EndIf
	EndIf
	
Next nChv

cQry := ChangeQuery( cQry )

Return( cQry )


/*
-------------------------------------------------------------------------------
| Rotina     | PesqMemos      | Autor | Gustavo Prudente | Data | 09.08.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Pesquisa conteudo dos campos memo e atualiza resultado em tela |
|-----------------------------------------------------------------------------|
| Parametros | EXPL1 - Indica se deve atualizar os campos memos do cabecalho  |
|            |         do atendimento.                                        |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function PesqMemos( lAtuCabec )

Local nItem      := oListResult:nAt
Local nPagina    := RetPagina()
Local nPosCodObs := AScan( aHeadADF, { |x| AllTrim( x[ 2 ] ) == "ADF_OBS" } )
Local cAlias     := Alias()
Local cItem      := Strzero(oGetDADF:oBrowse:nAt,3)
Local aColsTmp   := oGetDADF:aCols

Default lAtuCabec := .T.		// Indica se deve atualizar somente a observacao do item

cProtocolo := aPesqResult[ nPagina, nItem, POS_NUMPROT ]

// Busca campos memo de Observacao e Incidente, se deve atualizar o cabecalho
If lAtuCabec
	
	dbSelectArea( "ADE" )
	dbSetOrder( 1 )
	dbSeek( aFilSDK[ XFIL_ADE ] + cProtocolo )
	
	cObservacao := MSMM( ADE_OBSCOD )
	cIncidente  := MSMM( ADE_CODINC )
	
	oMemo1:Refresh()
	oMemo2:Refresh()
	
EndIf

// Se estiver em modo de edicao, atualiza com o memo preenchido na GetDados
If oGetDADF:lUpdate .And. cItem == aColsTmp[ Len( aColsTmp ), 1 ]
	
	cObsItem := aColsTmp[ Len( aColsTmp ), nPosCodObs ]
	oMemo3:Refresh()
Else
	// Busca campo memo de observacao do item na tabela ADF
	dbSelectArea( "ADF" )
	dbSetOrder( 1 )
	
	If dbSeek( aFilSDK[ XFIL_ADF ] + cProtocolo + cItem )
		cObsItem := MSMM( ADF_CODOBS )
		oMemo3:Refresh()
	Else
		cObsItem := 'Não encontrado.'
		oMemo3:Refresh()
	EndIF
EndIf

dbSelectArea( cAlias )

Return( .T. )

/*
-------------------------------------------------------------------------------
| Rotina     | RetGrupo       | Autor | Gustavo Prudente | Data | 09.08.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Retorna o grupo do usuario logado no Call Center               |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function RetGrupo( lTodos )

Local cCodUser	:= TkOperador()
Local cGrupo	:= ""
Local cFilAG9	:= xFilial( "AG9" )

Default lTodos := .F.

SU7->( DbSetOrder( 1 ) )
SU7->( DbSeek( xFilial() + cCodUser ) )

cGrupo := SU7->U7_POSTO

If lTodos
	
	cGrupo := ""
	
	AG9->( DbSetOrder( 1 ) )
	AG9->( DbSeek( cFilAG9 + cCodUser ) )
	
	Do While AG9->( ! EoF() ) .And. AG9->AG9_FILIAL == cFilAG9 .And. AllTrim(AG9->AG9_CODSU7) == AllTrim(cCodUser)
		cGrupo += AG9->AG9_CODSU0 + "/"
		AG9->( DbSkip() )
	EndDo
	
	cGrupo := SubStr( cGrupo, 1, Len( cGrupo ) - 1 )
	
EndIf

Return( cGrupo )


/*
-------------------------------------------------------------------------------
| Rotina     | BtnEditar      | Autor | Gustavo Prudente | Data | 13.08.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Gera nova linha para interacao no atendimento e permite edicao |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function BtnEditar()

Local nItem		 := oListResult:nAt
Local nPagina	 := RetPagina()
Local nPosCodSU9 := AScan( aHeadADF, { |x| Upper( AllTrim( x[ 2 ] ) ) == "ADF_CODSU9" } )
Local cProtocolo := aPesqResult[ nPagina, nItem, POS_NUMPROT ]
Local cAlias     := Alias()

// Atualiza itens do atendimento posicionado
ItensADF( .T. )

// Atualiza controles de tela - Botoes
oBtnOk:Enable()
oBtnEdit:Disable()

// Inicializa campo memo de observacao
cObsItem := ""
oMemo3:Refresh()

// Atualiza controles da GetDados
oGetDADF:lUpdate 		:= .T.
oGetDADF:oBrowse:ColPos := nPosCodSU9	// Posiciona no codigo da ocorrencia
oGetDADF:oBrowse:SetFocus()

// Atualiza variaveis de memoria com os dados do cabecalho do atendiemnto
dbSelectArea( "ADE" )
dbSetOrder( 1 )
dbSeek( xFilial() + cProtocolo )

RegToMemory( "ADE", .F., .T., .F. )

dbSelectArea( cAlias )

Return( .T. )


/*
-------------------------------------------------------------------------------
| Rotina     | BtnOk          | Autor | Gustavo Prudente | Data | 13.08.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Confirma a gravação da interacao no atendimento posicionado    |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function BtnOk()

Local nPosSU9	  := AScan( aHeadADF, { |x| AllTrim( x[ 2 ] ) == "ADF_CODSU9" } )
Local nPosSUQ	  := AScan( aHeadADF, { |x| AllTrim( x[ 2 ] ) == "ADF_CODSUQ" } )
Local nPosSU7	  := AScan( aHeadADF, { |x| AllTrim( x[ 2 ] ) == "ADF_CODSU7" } )
Local nPosOBS	  := AScan( aHeadADF, { |x| AllTrim( x[ 2 ] ) == "ADF_OBS"    } )
Local nPagina     := RetPagina()
Local nNovo		  := 0

Local aCabec	  := {}
Local aLinha	  := {}
Local aItens	  := {}
Local aArea	      := GetArea()

Local cProtocolo  := aPesqResult[ nPagina, oListResult:nAt, POS_NUMPROT ]
Local cPosto	  := ""
Local cOcorrencia := ""
Local cAcao		  := ""

Local lOk 		  := .T.

Private aHeader   := {}
Private aCols	  := {}

CursorWait()

// Atualiza aHeader e aCols que sera utilizado com o aCols e aHeader da GetDados da tabela ADF
aHeader 	:= AClone( aHeadADF )
aCols   	:= AClone( oGetDADF:aCols )

nNovo		:= Len( aCols )
cPosto	    := Posicione( "SU7", 1, xFilial( "SU7") + aCols[ nNovo, nPosSU7 ], "U7_POSTO" )
cOcorrencia	:= aCols[ nNovo, nPosSU9  ]
cAcao		:= aCols[ nNovo, nPosSUQ  ]
cObsItem 	:= aCols[ nNovo, nPosOBS ] 

//Renato Ruy - 17/01/17
//Grava a ocorrencia atual informada pelo usuario.
If ADE->(Reclock("ADE",.F.))
	ADE->ADE_ASSUNT := Posicione("SU9",2,xFilial("SU9")+cOcorrencia,"U9_ASSUNTO")
	ADE->(MsUnlock())
Endif

RegToMemory( "ADE", .F., .T., .F. )

ADF->( dbSetOrder( 1 ) )
ADF->( dbSeek( xFilial( "ADF" ) + cProtocolo ) )

TkUpdCall(	/* cFilial */ 				   				, ;
			cAcao /* cCodAction */						, ;
			/* cCodReview */							, ;
			cObsItem									, ;
			/* cTPACAO */								, ;
			aCols[ nNovo, nPosSU7  ] /*cOper*/			, ;
			cPosto	/*Grupo*/							, ;
			""											, ;
			/* dPrazo */								, ;
			Iif( ! 	IsInCallStack( "GenRecurrence" )	, ;
			Date()										, ;
			dDatabase )									, ;
			cProtocolo									, ;
			cOcorrencia )

// Carrega itens do atendimento posicionado
ItensADF()
CursorArrow()

// Informa se a nova interacao foi gravada com sucesso ou houve alguma nao-conformidade
MsgStatus( "Interação gravada com sucesso. Protocolo: " + AllTrim( cProtocolo  ), 3 )

oBtnOk:Disable()
ChkBtnEdit()

oGetDADF:lUpdate 		:= .F.
oGetDADF:oBrowse:ColPos := 1
oGetDADF:oBrowse:nAt	:= Len( oGetDADF:aCols )

oGetDADF:oBrowse:SetFocus()
                   
RestArea( aArea )

Return( .T. )


/*
-------------------------------------------------------------------------------
| Rotina     | GetDblClick    | Autor | Gustavo Prudente | Data | 20.08.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Executa regras especificas por campo da GetDados ao selecionar |
|            | duplo clique em um item de atendimento.                        |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function GetDblClick()

Local nPosCodSU9 := AScan( aHeadADF, { |x| Upper( AllTrim( x[ 2 ] ) ) == "ADF_CODSU9" } )
Local nItem		 := oListResult:nAt
Local nPagina	 := RetPagina()
Local cProtocolo := aPesqResult[ nPagina, nItem, POS_NUMPROT ]
Local cAlias     := Alias()

Private oGetd 

// Edita coluna da GetDados se estiver em modo de edicao
If 	oGetDADF:lUpdate
	If oGetDADF:oBrowse:ColPos == nPosCodSU9
		dbSelectArea( "ADE" )
		dbSetOrder( 1 )
		dbSeek( aFilSDK[ XFIL_ADE ] + cProtocolo )
		RegToMemory( "ADE", .F., .T., .F. )
	EndIf
	If oGetDADF:oBrowse:nAt == Len( oGetDADF:aCols )
		oGetd := oGetDADF
		oGetDADF:EditCell()
	EndIf
EndIf

DbSelectArea( cAlias )

Return( .T. )


/*
-------------------------------------------------------------------------------
| Rotina     | AtuObjPesq     | Autor | Gustavo Prudente | Data | 22.08.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Atualiza objetos com o novo resultado da pesquisa              |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function AtuObjPesq()

// Caso esteja em modo de edicao, desabilita botao confirmar e sai do modo de edicao
If oGetDADF:lUpdate
	oGetDADF:lUpdate := .F.
	oBtnOk:Disable()
EndIf

// Limpa mensagem
MsgStatus()

// Carrega itens do atendimento posicionado
ItensADF()

// Atualiza informacoes dos campos memo do atendimento posicionado
PesqMemos()

// Atualiza controle do botao editar e acoes relacionadas conforme grupo de atendimento
ChkBtnEdit()
ChkBtnAcoes()

Return( .T. )


/*
-------------------------------------------------------------------------------
| Rotina     | GetDValSU9     | Autor | Gustavo Prudente | Data | 02.09.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Realiza validacao de código de ocorrência.                     |
|-----------------------------------------------------------------------------|
| Parametros | EXPC1 - Expressao de validacao do campo ADF_CODSU9 padrao (SX3)|
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
User Function GetDValSU9( cValid )

Local lRet 		 	:= .T.
Local nPosCodSU9 	:= Ascan( aHeadADF, { |x| AllTrim( x[ 2 ] ) == "ADF_CODSU9" } )
Local nItem		 	:= oListResult:nAt
Local nPagina	 	:= RetPagina()
Local cCodOco		:= &( ReadVar() )
Local cProtocolo 	:= aPesqResult[ nPagina, nItem, POS_NUMPROT ]
Local cAlias		:= Alias()
Local cADEAssu		:= ""
                           
Default cValid		:= .T.

// Valida preenchimento da ocorrência
If oGetDADF:oBrowse:ColPos == nPosCodSU9

	If Empty( cCodOco )

		MsgStatus( "Informar uma ocorrencia válida." )
		// Forca edicao do campo Codigo da Ocorrencia
		oGetDADF:oBrowse:ColPos := nPosCodSU9
		oGetDADF:oBrowse:SetFocus()
		lRet := .F.

	Else

		// Atualiza variaveis de memoria com as informacoes do cabecalho do atendimento posicionado
		dbSelectArea( "ADE" )
		dbSetOrder( 1 )
		dbSeek( aFilSDK[ XFIL_ADE ] + cProtocolo )
		
		cADEAssu := ADE->ADE_ASSUNT
		
		//Renato Ruy - 16/01/17
		//Atualiza o codigo do assunto para possibilitar a validacao padrao.
		If ADE->(Reclock("ADE",.F.))
			ADE->ADE_ASSUNT := Posicione("SU9",2,xFilial("SU9")+cCodOco,"U9_ASSUNTO")
			ADE->(MsUnlock())
		Endif
		
		RegToMemory( "ADE", .F., .T., .F. )
		
		// Executa expressao de validacao padrao, com as informacoes do atendimento posicionado em memoria
		lRet := &( cValid )
		        
	EndIf                               
	
EndIf

If lRet
	MsgStatus()
Else
	//Somente grava o novo assunto no botao confirmar
	If ADE->(Reclock("ADE",.F.)) .And. !Empty(cADEAssu)
		ADE->ADE_ASSUNT := cADEAssu
		ADE->(MsUnlock())
	Endif
EndIf

DbSelectArea( cAlias )

Return( lRet )



/*
-------------------------------------------------------------------------------
| Rotina     | ChkBtnEdit     | Autor | Gustavo Prudente | Data | 06.09.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Habilita ou desabilita botao editar conforme regra definida    |
|            | para o atendimento posicionado.                                |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function ChkBtnEdit()

Local cGrupo	:= ""
Local cEdita	:= ""
Local cEdtSup	:= ""
Local cOperador	:= ""
Local cTipoOper	:= ""

Local lEdita	:= .F.
Local lEdtSup	:= .F.

If Len( oListResult:aArray ) > 0
	
	cEdita	:= LeArqDef( cFileDef, "Button", "Editar" )
	lEdita	:= ( cEdita == "1" )

	cEdtSup	:= LeArqDef( cFileDef, "Button", "EdtSup" )
	lEdtSup	:= ( cEdtSup == "1" )	
	         
	// Se habilitou o botao editar
	If lEdita

		// Verifica se somnete deve editar se for supervisor
	    If lEdtSup
	    	
	    	// Busca o tipo do operador
	    	cOperador := AllTrim( TkOperador() )
	    	cTipoOper := Posicione( "SU7", 1, xFilial( "SU7" ) + cOperador, "U7_TIPO" )
	    	                   
	    	If cTipoOper == "2"		// Supervisor
				oBtnEdit:Enable()
			Else					// Operador
				oBtnEdit:Disable()
			EndIf
			
		Else
			oBtnEdit:Enable()
		EndIf

	Else

		oBtnEdit:Disable()

	EndIf
	
	oBtnEdit:Refresh()
	
EndIf

Return .T.
      


/*
-------------------------------------------------------------------------------
| Rotina     | ChkBtnAcoes    | Autor | Gustavo Prudente | Data | 13.08.2014  |
|-----------------------------------------------------------------------------|
| Descricao  | Habilita ou desabilita botao acoes relacionadas conforme regra |
|            | definida para o grupo de atendimentos                          |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function ChkBtnAcoes()
          
Local cAcoes := ""
Local lAcoes := .T.

If Len( oListResult:aArray ) > 0
	
	cAcoes := LeArqDef( cFileDef, "Button", "Acoes" )
	lAcoes := ( cAcoes == "1" .Or. Empty( cAcoes ) )
	
	If lAcoes
		oBtnAcoes:Enable()
	Else
		oBtnAcoes:Disable()
	EndIf
	
	oBtnAcoes:Refresh()
	
EndIf

Return( .T. )



/*
-------------------------------------------------------------------------------
| Rotina     | BtnTipPesq     | Autor | Gustavo Prudente | Data | 10.09.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Habilita ou desabilita botao editar conforme regra definida    |
|            | para o atendimento posicionado.                                |
|-----------------------------------------------------------------------------|
| Parametros | EXPC1 - String para pesquisa                                   |
|            | EXPA2 - Array com a configuracao das abas para pesquisa        |
|            | EXPN3 - Opcao de tipo de pesquisa selecionada.                 |
|            |         1 - Pesquisa a esquerda da chave.                      |
|            |         2 - Pesquisa ao centro da chave.                       |
|            |         3 - Pesquisa a direita da chave.                       |
|            |         4 - Pesquisa em qualquer parte da chave.               |
|            | EXPL4 - Indica se foi chamado do botao "Buscar"                |
|            |         .T. - Chamado pelo botao buscar                        |
|            |         .F. - Chamado pelas opcoes de pesquisa - "Esquerda"    |
|            |               "Direita", "Centro" ou "Todos"                   |
|            | EXPA5 - Vetor com os grupos que devem retornar atendimentos    |
|            |         no resultado da pesquisa.                              |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function BtnTipPesq( cPesq, aBusca, nOpcPesq, lBtnBuscar, aGrpPesq )

Local lRet := .T.

Default nOpcPesq := 1

If ValidaPesquisa( cPesq ) .And. lBtnBuscar
	FwMsgRun( oFldPesq, { |oSay| BtnPesq( cPesq, aBusca, nOpcPesq, lBtnBuscar, oSay, aGrpPesq ) } )
EndIf

Return nOpcPesq


/*
-------------------------------------------------------------------------------
| Rotina     | CriaArrChv     | Autor | Gustavo Prudente | Data | 11.09.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Cria array com as chaves de pesquisa de acordo com a ordem     |
|            | definida no arquivo de configuracao de abas da pesquisa        |
|-----------------------------------------------------------------------------|
| Parametros | EXPA1 - Array com as abas de pesquisa, selecionadas a partir   |
|            | do arquivo de configuracoes.                                   |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function CriaArrChv( aBusca )

Local nMax 		:= 0
Local nX		:= 0
Local ny		:= 0
Local nIndChv	:= 0
Local aRetChv	:= {}
Local aRetAbas	:= {}
Local aChaves	:= {}                       
Local aADECPF	:= { "ADE_XCPFTI", "ADE_XCNPJC" }

AEval( aBusca, { |x| Iif( Val( SubStr( x, 1, 1 ) ) > nMax, nMax := Val( SubStr( x, 1, 1 ) ), .T. ) } )

aRetChv  := Array( TOT_NIVEIS, nMax )
aRetAbas := Array( nMax )

AAdd( aChaves, { ""			 , aADECPF		, "ADE_XMAILT", ""			 , "ADE_PLVCHV"	, "ADE_PEDGAR"	, "ADE_CODIGO"	, "ADE_XPSITE" 	} )	// Atendimentos
AAdd( aChaves, { "A1_NOME"	 , "A1_CGC"		, "A1_EMAIL"  , "A1_HPAGE"	 , ""  			, ""			, ""			, ""			} )	// Clientes
AAdd( aChaves, { "US_NOME"	 , "US_CGC"		, "US_EMAIL"  , "US_URL"	 , "" 		  	, ""  			, ""			, "" 			} )	// Prospects
AAdd( aChaves, { "U5_CONTAT" , "U5_CPF"		, "U5_EMAIL"  , "U5_URL"	 , ""  			, "" 			, ""			, ""			} )	// Contatos
AAdd( aChaves, { "Z3_DESENT" , "Z3_CGC"		, ""          , "" 			 , ""  			, ""			, "" 			, ""			} )	// Postos de Atendimento
AAdd( aChaves, { "ACH_RAZAO" , "ACH_CGC" 	, "ACH_EMAIL" , "ACH_URL"	 , ""  			, ""			, "" 			, ""			} )	// Suspects
AAdd( aChaves, { "ZT_EMPRESA", "ZT_CNPJ" 	, "ZT_CONTTEC", "ZT_COMMON"	 , ""			, ""			, ""			, "" 			} )	// Common Name

For nY := 1 To Len( aBusca )
	
	nIndChv  := Val( SubStr( aBusca[ nY ], 1, 1 ) )
	
	aRetAbas[ nIndChv ] := "&" + SubStr( aBusca[ nY ], 2, Len( aBusca[ nY ] ) )
	
	For nX := 1 To Len( aChaves )
		aRetChv[ nX, nIndChv ] := aChaves[ nX, nY ]
	Next nX
	
Next nY

Return( { aRetChv, aRetAbas } )


/*
-------------------------------------------------------------------------------
| Rotina     | VisBanco       | Autor | Gustavo Prudente | Data | 21.10.2013  |
|-----------------------------------------------------------------------------|
| Descricao  | Opção que permite visualizar o banco de conhecimento do        |
|            | atendimento posicionado.                                       |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function VisBanco()

Local nPagina		:= RetPagina()
Local cProtocolo 	:= ""
Local cGrpOper		:= RetGrupo( .T. )

Private aRotina 	:= {}
Private cCadastro	:= "Conhecimento"

Aadd( aRotina, { "Conhecimento", "MsDocument", 0, 2 } )

cProtocolo := aPesqResult[ nPagina, oListResult:nAt, POS_NUMPROT ]

If ! Empty( cProtocolo )
	
	ADE->( DbSetOrder( 1 ) )
	
	If ADE->( DbSeek( aFilSDK[ XFIL_ADE ] + cProtocolo ) )
		MsDocument( "ADE", ADE->( RecNo() ), 1 )
	Else
		MsgStatus( "Não existe banco de conhecimento para o atendimento selecionado." )
	EndIf
	
EndIf

Return( .T. )

/*
----------------------------------------------------------------------------
| Rotina    | CriaArqDef   | Autor | Gustavo Prudente | Data | 31.10.2013  |
|--------------------------------------------------------------------------|
| Descricao | Cria arquivo .INI com as configuracoes da pesquisa por grupo |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function CriaArqDef( aColCfg )

Local aRet		:= {}
Local cDir1		:= '\PESQCERT'
Local cDir2		:= '\GRUPO'
Local cDir3		:= '\'
Local cFileINI 	:= '\DEFHIST.INI'
Local cPath 	:= ""
Local x

cDir3 += AllTrim( RetGrupo() )
cPath := cDir1 + cDir2 + cDir3

If ! ( ExistDir( cDir1 ) )
	MakeDir( cDir1 )
Endif

If ! ( ExistDir( cDir1 + cDir2 ) )
	MakeDir( cDir1 + cDir2 )
Endif

If ! ( ExistDir( cDir1 + cDir2 + cDir3 ) )
	MakeDir( cDir1 + cDir2 + cDir3 )
Endif

If ! File( cPath + cFileINI )
	GrvArqDef( cPath + cFileINI, aColCfg )
Endif

Return( cPath + cFileINI )


/*
----------------------------------------------------------------------------
| Rotina    | LeArqDef     | Autor | Gustavo Prudente | Data | 31.10.2013  |
|--------------------------------------------------------------------------|
| Descricao | Le informacoes do arquivo de configuracoes por grupo         |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function LeArqDef( cFileDef, cSecao, cChave )

Local cTexto  	:= MemoRead( cFileDef )
Local cRet 		:= ""
Local cDefSec   := ""
Local cLinha	:= ""

Local nLinhas	:= MLCount( cTexto )
Local nX		:= 1
Local nIniSec	:= 0
Local nFimSec	:= 0
Local nOperChv  := 0

Local lTemSecao := .F.

// Varre todas as linhas do arquivo de configuracao
Do While nX <= nLinhas .And. Empty( cRet )
	
	cLinha := AllTrim( MemoLine( cTexto, 254, nX ) )
	
	nIniSec := At( "[", cLinha )
	nFimSec := At( "]", cLinha )
	
	If 	nIniSec > 0 .And. nIniSec == 1 .And. ;
		nFimSec > 0 .And. nFimSec == Len( cLinha )
		
		cDefSec := Upper( SubStr( cLinha, nIniSec + 1, Len( cLinha ) - 2 ) )
		lTemSecao := ( cDefSec == Upper( cSecao ) )
		
	EndIf
	
	If lTemSecao
		nOperChv := At( "=", cLinha )
		If nOperChv > 0 .And. cChave $ cLinha
			cRet := SubStr( cLinha, nOperChv + 1, Len( cLinha ) )
		EndIf
	EndIf
	
	nX ++
	
EndDo

Return( cRet )


/*
----------------------------------------------------------------------------
| Rotina    | GrvArqDef    | Autor | Gustavo Prudente | Data | 31.10.2013  |
|--------------------------------------------------------------------------|
| Descricao | Grava informacoes no arquivo de configuracoes por grupo      |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function GrvArqDef( cFileDef, aColCfg, cChvOrdPesq, aChvBut )
                
Local aColunas	:= {}
Local aOrdPesq  := {}

Local nX 		:= 0
Local nTotDes	:= 0

Local cColCfg	:= ""
Local cColSts	:= ""
Local cColOrd	:= ""

Local cLinAbas	:= ""
Local cLinBto	:= ""
Local cLinCol	:= ""
Local cTmpCol   := ""

Default cChvOrdPesq	:= "1Nome,2CPF/CNPJ,3E-mail,4Common Name,5Palavra Chave,6Pedido GAR,7Protocolo,8Pedido Site"

Default aChvBut := { "1", "2", "2" }

// Cria chaves da secao [Resultado] a partir da configuracao realizada
For nX := 1 To Len( aColCfg )
	If aColCfg[ nX, 6 ]
		cColSts += Iif( aColCfg[ nX, 4 ], "1", "0" ) + ","		// Cria chave de colunas habilitadas/desabilitadas
		cColOrd += AllTrim( Str( nX - nTotDes ) ) + ","			// Cria chave de ordem das colunas
	Else
		nTotDes ++	
	EndIf
Next nX

cColSts := SubStr( cColSts, 1, Len( cColSts ) - 1 )
cColOrd := SubStr( cColOrd, 1, Len( cColOrd ) - 1 )
                       
// Prepara gravacao das colunas
For nX := 1 To Len( aColCfg )
	
	// Considera somente colunas ativadas
	If aColCfg[ nX, 6 ]
	    cTmpCol += AllTrim( aColCfg[ nX, 5 ] ) + ","
	EndIf              
	
	If Len( cTmpCol ) > 235
		AAdd( aColunas, "Colunas" + StrZero( Len( aColunas ) + 1, 2 ) + "=" + SubStr( cTmpCol, 1, Len( cTmpCol ) - 1 ) )
		cTmpCol := ""
	EndIf
	
Next nX

If ! Empty( cTmpCol )
	AAdd( aColunas, "Colunas" + StrZero( Len( aColunas ) + 1, 2 ) + "=" + SubStr( cTmpCol, 1, Len( cTmpCol ) - 1 ) )
EndIf

For nX := 1 To Len( aColunas )                          
	cColCfg += Iif( nX > 1, CRLF, "" )
	cColCfg += aColunas[ nX ]
Next nX                        
                               
// Verifica se todas as opcoes de pesquisa serao gravadas
aOrdPesq := StrToKArr( "1Nome,2CPF/CNPJ,3E-mail,4Common Name,5Palavra Chave,6Pedido GAR,7Protocolo,8Pedido Site", "," )
                                
For nX := 1 To Len( aOrdPesq )
       
	If At( SubStr( aOrdPesq[ nX ], 2, Len( aOrdPesq[ nX ] ) ), cChvOrdPesq ) == 0	
		cChvOrdPesq += "," + AllTrim( Str( nX ) ) + SubStr( aOrdPesq[ nX ], 2, Len( aOrdPesq[ nX ] ) )	
	EndIf
	
Next nX                       
                       
// Realiza gravacao das secoes e chaves do arquivo de configuracao                       
cLinAbas := "[Folder]" + CRLF + "Nomes=" + cChvOrdPesq + CRLF + CRLF 
cLinBto  := "[Button]" + CRLF + "Acoes=" + aChvBut[ 1 ] + CRLF + "Editar=" + aChvBut[ 2 ] + CRLF + "EdtSup=" + aChvBut[ 3 ] + CRLF + CRLF
cLinCol  := "[Result]" + CRLF + cColCfg + CRLF + "Ordem=" + cColOrd + CRLF + "Status=" + cColSts + CRLF

MemoWrite( cFileDef, cLinAbas + cLinBto + cLinCol )

Return( ! ( FError() # 0 ) )


/*
----------------------------------------------------------------------------
| Rotina    | TotQuery     | Autor | Gustavo Prudente | Data | 12.12.2013  |
|--------------------------------------------------------------------------|
| Descricao | Totaliza resultado da string de pesquisa na opcao e nivel    |
|           | selecionados.                                                |
|--------------------------------------------------------------------------|
| Parametros| EXPC1 - String de pesquisa                                   |
|           | EXPN2 - Opcao de pesquisa por Nome, CNPJ, E-Mail, etc.       |
|           | EXPN3 - Tipo de pesquisa a esquerda, meio, direita e just.   |
|           | EXPN4 - Nivel de alias para pesquisa: ADE/SA1/SUS/ACH/SZ3    |
|           | EXPN5 - Total do nivel, opcao e chave de pesquisa            |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function TotQuery( cStr, nOption, nOpcPesq, nNivel, nTotal )

Static aTotChv := {}

Local nPosChv  := 0

// Guarda total da chave e nivel de pesquisa para evitar nova contagem em proximas
// solicitacoes de resultado do mesmo nivel e chave
nPosChv := AScan( aTotChv, { |x| x[ 1 ] == cStr .And. x[ 2 ] == nOption .And. x[ 3 ] == nOpcPesq .And. x[ 4 ] == nNivel } )

If nPosChv == 0 .And. nTotal > 0
	AAdd( aTotChv, { cStr, nOption, nOpcPesq, nNivel, nTotal } )
	nPosChv := Len( aTotChv )
EndIf

// Total do nivel, opcao e chave de pesquisa
Return Iif( nPosChv > 0, aTotChv[ nPosChv, 5 ], 0 )

              

/*
----------------------------------------------------------------------------
| Rotina    | XSaveMem     | Autor | Gustavo Prudente | Data | 16.07.2014  |
|--------------------------------------------------------------------------|
| Descricao | Grava as informacoes das variaveis do alias passado em um    |
|           | array. 													   |
|--------------------------------------------------------------------------|
| Parametros| EXPC1 - Alias da tabela para criar array com conteúdo das    |
|           | variaveis de memoria										   |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function XSaveMem( cAlias )

Local nX 	 	:= 0
Local nTotCpo	:= (cAlias)->( FCount() )

Local aRet		:= {}                           
Local aArea		:= GetArea()     

Local cVar		:= ""

DbSelectArea( cAlias )
            
For nX := 1 To nTotCpo

	cVar := "M->" + FieldName( nX ) 
                                                          
	If Type( cVar ) <> "U"
		AAdd( aRet, { cVar, &( cVar ) } )
	EndIf	
	
Next nX

If cAlias == "ADE"
	If Type( "M->ADE_OBSERV" ) <> "U"
		AAdd( aRet, { "M->ADE_OBSERV", M->ADE_OBSERV } )
	EndIf
	If Type( "M->ADE_INCIDE" ) <> "U"
		AAdd( aRet, { "M->ADE_INCIDE", M->ADE_INCIDE } )
	EndIf
EndIf

If cAlias == "ADF"
	If Type( "M->ADF_OBS" ) <> "U"
		AAdd( aRet, { "M->ADF_OBS", M->ADF_OBS } )
	EndIf
EndIf

RestArea( aArea )

Return( aRet )

             

/*
----------------------------------------------------------------------------
| Rotina    | RetGrpPesq   | Autor | Gustavo Prudente | Data | 21.07.2014  |
|--------------------------------------------------------------------------|
| Descricao | Retorna grupos de atendimentos cadastrados em formato para   |
|           | permitir o filtro no resultado da pesquisa                   |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function RetGrpPesq()

Local aGrpPesq	:= {}
Local aArea		:= GetArea()

Local nTotLib	:= 0
Local nTotBlq	:= 0
Local nX		:= 0

Local cRet		:= ""

Local lTodos  	:= .F.	// Indica se a pesquisa pode retornar todos os grupos

For nX := 1 To Len( aGrpSDK )
	// Monta o array de grupos de atendimentos 
	AAdd( aGrpPesq, {	aGrpSDK[ nX, 1 ], 	;		// Codigo do grupo
						.T. 	 		  } ) 		// Indica se permite pesquisar atendimentos deste grupo
Next nX
                          
// Retorna array com os grupos validados de acordo com as regras de exibicao dos grupos do 
// operador e as regras de bloqueio de todos os grupos                
aGrpPesq := VldGrpPesq( aGrpPesq )

// Se a mesma quantidade de grupos retornaram da validacao, entao nao existe regra
// de exibicao e bloqueio cadastradas, deve exibir qualquer atendimento
AEval( aGrpPesq, { |x| Iif( x[ 2 ], nTotLib ++, nTotBlq ++ ) } )
   
lTodos	:= ( Len( aGrpPesq ) == nTotLib )

// Se o total de grupos for igual ao total liberado, nao ha necessidade de filtro por grupo
If lTodos

	cRet := ""

Else

	// Transforma para o formato de Query todos os grupos que podem ter
	// atendimentos exibidos nos resultados  
	AEval( aGrpPesq, { |x| Iif( x[ 2 ], cRet += x[ 1 ] + ",", .T. ) } )  
	                    
	If At( ",", cRet ) > 0
		cRet := SubStr( cRet, 1, Len( cRet ) - 1 )
	EndIf

EndIf

RestArea( aArea )

Return( { cRet, lTodos } )
                  
                                    

/*
----------------------------------------------------------------------------
| Rotina    | VldGrpPesq   | Autor | Gustavo Prudente | Data | 22.07.2014  |
|--------------------------------------------------------------------------|
| Descricao | Valida grupos de atendimento de acordo com a informacao dos  |
|           | campos de grupos para exibicao na pesquisa e grupos com      |
|           | bloqueio de visualizacao.                                    |
|--------------------------------------------------------------------------|
| Parametros| EXPA1 - Vetor com os grupos de atendimento que liberados e   |
|           |         com bloqueio para exibicao na pesquisa.              |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function VldGrpPesq( aGrpPesq )
              
Local cXGrpHis	:= ""	// Regra com grupos permitidos do grupo do operador
Local cFilSU0	:= xFilial( "SU0" )  

Local aGrpOper	:= {}	// Grupos do operador
Local aGrpBlq	:= {}	// Grupos com regra de bloqueio
Local aArea		:= GetArea()

Local nX		:= 0
Local nY		:= 0
Local nPosBlq	:= 0
       
Local lXGrpBlq	:= SU0->( FieldPos( "U0_XGRPBLQ" ) > 0 )       
                     
aGrpOper := StrToKArr( RetGrupo( .T. ), "/" )                     
                       
// Elenca todos os grupos de atendimento que tem regra de bloqueio
If lXGrpBlq          

	BeginSql Alias "TRBSU0"
		
		SELECT SU0.U0_CODIGO, SU0.U0_XGRPBLQ
		FROM %Table:SU0% SU0
		WHERE	SU0.U0_FILIAL = %xFilial:SU0% AND
				SU0.U0_XGRPBLQ > ' ' AND
				SU0.%notDel%
		
	EndSql

	// Monta vetor com todos os grupos com regra de bloqueio
	Do While ! TRBSU0->(EoF())
		AAdd( aGrpBlq, { TRBSU0->U0_CODIGO, AllTrim( TRBSU0->U0_XGRPBLQ ) } )
		TRBSU0->(DbSkip())
	EndDo	                

 	DbCloseArea()

EndIf

DbSelectArea( "SU0" )
                                 
// Percorre todos os grupos do operador                      
For nX := 1 To Len( aGrpOper )

	// Aplica a regra dos grupos que podem ter atendimentos exibidos nos resultados
	DbSetOrder( 1 )
	DbSeek( cFilSU0 + aGrpOper[ nX ] )

	// Lista dos grupos que podem ter atendimentos exibidos nos resultados
	cXGrpHis := AllTrim( SU0->U0_XGRPHIS )                        
	                                                                      
	// Somente restringe a exibicao se preencheu a regra do grupo
	If ! Empty( cXGrpHis )              
		AEval( aGrpPesq, { |x| x[ 2 ] := ( x[ 1 ] $ cXGrpHis ) } )
	EndIf

	// Aplica a regra dos grupos que bloqueiam a exibição dos atendimentos
	If lXGrpBlq
				                     
		// Percorre a lista de grupos com bloqueio				                                                
		For nY := 1 To Len( aGrpBlq )				
				
	    	// Se o grupo do operador esta na lista de bloqueios de algum grupo com regra
	    	// cadastrada, desabilita a selecao de atendimentos do grupo com a regra
			If aGrpOper[ nX ] $ aGrpBlq[ nY, 2 ]
	           
				nPosBlq := AScan( aGrpPesq, { |x| x[1] == aGrpBlq[ nY, 1 ] } )

				If nPosBlq > 0
					aGrpPesq[ nPosBlq, 2 ] := .F.
				EndIf

			EndIf

		Next nY		
	           
	EndIf

Next nX

RestArea( aArea )
	
Return( aGrpPesq )

/*
----------------------------------------------------------------------------
| Rotina    | XOpcPesq     | Autor | Gustavo Prudente | Data | 18.07.2014  |
|--------------------------------------------------------------------------|
| Descricao | Retorna array com as opcoes da pesquisa, de acordo com o     |
|           | tipo do operador, se supervisor ou operador.                 |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function XOpcPesq()

Local aRet	:= { "Pesquisar" }                          
Local cOper	:= TkOperador()
              
SU7->( DbSetOrder( 1 ) )
SU7->( DbSeek( aFilSDK[ XFIL_SU7 ] + cOper ) )

If SU7->U7_TIPO == "2"	// Supervisor
	aRet := { "Pesquisar", "Configurar" }
EndIf	

Return( aRet )

  
/*
----------------------------------------------------------------------------
| Rotina    | ChangeFolder | Autor | Gustavo Prudente | Data | 18.07.2014  |
|--------------------------------------------------------------------------|
| Descricao | Funcao para executar regras ao navegar entre as pastas       |
|           | "Pesquisar" e "Configurar".                                  |
|--------------------------------------------------------------------------|
| Parametros| EXPN1 - Indica se eh a aba 1-"Pesquisar" ou 2-"Configurar"   |
|           | EXPO2 - Objeto do get de string para pesquisa                |
|           | EXPO3 - Objeto do botao "Buscar"                             |
|           | EXPL4 - Indica se mudou de aba apos salvar as configuracoes  |
|           | EXPO5 - Objeto da lista de ordenacao das opcoes da pesquisa  |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function ChangeFolder( nFolder, oGetPesq, oBtnPesq, lSalvar, oOrdPesq )
                                     
If nFolder == 1		// Pesquisar

	// Exibe objetos da dialog utilizados da aba "Pesquisar"
	oGetPesq:Show()
	
	oBtnPesq:Show()
	oBtn1Pesq:Show()
	oBtn2Pesq:Show()
	oBtn3Pesq:Show()
	oBtn4Pesq:Show()        

	oBtnSalvar:Hide()       

	MsgStatus()

	oBtnPesq:SetFocus()                                           
	
	If lSalvar
		MsgAlert( "Para que as alterações salvas tenham efeito, é necessário reiniciar a pesquisa." )
	EndIf	

Else

	// Limpa barra de mensagens
	MsgStatus()

	// Oculta objetos da dialog utilizados da aba "Pesquisar"
	oGetPesq:Hide()
	
	oBtnPesq:Hide()
	oBtn1Pesq:Hide()
	oBtn2Pesq:Hide()
	oBtn3Pesq:Hide()
	oBtn4Pesq:Hide() 

    oBtnSalvar:Show()    
                 
   	oOrdPesq:nAt := 1
    oOrdPesq:SetFocus()
             
EndIf

Return( .T. )

             
/*
----------------------------------------------------------------------------
| Rotina    | CfgColMark   | Autor | Gustavo Prudente | Data | 31.07.2014  |
|--------------------------------------------------------------------------|
| Descricao | Funcao para habilitar ou desabilitar todas as colunas do     |
|           | resultado da pesquisa.                                       |
|--------------------------------------------------------------------------|
| Parametros| EXPL1 - Indicar se deve marcar ou desmarcar todas as colunas |
|           | EXPO2 - Objeto que indica coluna habilitada                  |
|           | EXPO3 - Objeto que indica coluna deshabilitada               |
|           | EXPA4 - Array com as colunas que permitem ser configuradas   |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function CfgColMark( lMark, oOk, oNo, aColCfg )
         
Local nX := 0

// Percorre o array do listbox de configuracao das colunas, atualizando a informacao de status
For nX := 1 To Len( aColCfg )
	If aColCfg[ nX, 6 ]
		aColCfg[ nX, 1 ] := Iif( lMark, oOk, oNo )
		aColCfg[ nX, 4 ] := lMark
	EndIf
Next nX

Return( .T. )


/*
------------------------------------------------------------------------------
| Rotina    | OrdOpcPesq   | Autor | Gustavo Prudente | Data | 01.08.2014    |
|----------------------------------------------------------------------------|
| Descricao | Executa a acao de ordernar o listbox com as opções da pesquisa |
|----------------------------------------------------------------------------|
| Parametros| EXPN1 - Indicar se deve ordenar acima (1) ou abaixo (2)        |
|           | EXPO2 - Objeto da lista de opcoes de pesquisa                  |
|           | EXPA3 - Array com as opcoes da pesquisa                        |
|           | EXPN4 - Ordem da opcao de pesquisa atual na lista              |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
Static Function OrdOpcPesq( nTipo, oOrdPesq, aOpcPesq, nOrdPesq )

Local nOrdNew := nOrdPesq
Local cOpcNew := ""

If nTipo == 1 .And. nOrdPesq > 1
	nOrdNew --
ElseIf nTipo == 2 .And. nOrdPesq < Len( aOpcPesq )
	nOrdNew ++
EndIf

If nOrdNew # nOrdPesq

	cOpcNew := aOpcPesq[ nOrdNew ]
                         
	aOpcPesq[ nOrdNew  ] := aOpcPesq[ nOrdPesq ]
	aOpcPesq[ nOrdPesq ] := cOpcNew
                        
	oOrdPesq:SetArray( aOpcPesq )	

	oOrdPesq:bLine	:= { || { aOpcPesq[ oOrdPesq:nAt ] } }
	oOrdPesq:nAt	:= nOrdNew
	                                   
EndIf

Return( .T. )


/*
---------------------------------------------------------------------------------
| Rotina    | GrvCfgPesq   | Autor | Gustavo Prudente | Data | 01.08.2014       |
|-------------------------------------------------------------------------------|
| Descricao | Compatibiliza e grava as configuracoes da pesquisa para o grupo   |
|-------------------------------------------------------------------------------|
| Parametros| EXPC1 - Arquivo de definicoes da pesquisa (DEFHIST.INI)           |
|           | EXPA2 - Vetor com a configuracao dos botoes da pesquisa           |
|           | EXPA3 - Vetor com a configuracao da ordem das opcoes de pesquisa  |
|           | EXPA4 - Vetor com as colunas que devem ser exibidas no resuultado |
|-------------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                               |
---------------------------------------------------------------------------------
*/
Static Function GrvCfgPesq( cFileDef, aCfgBut, aOpcPesq, aColCfg )

Local nX 		:= 0
Local nPos		:= 0
Local cOpcPesq	:= ""

// Limpa possiveis mensagens da barra de status                                
MsgStatus()

// Compatibiliza informacoes dos botoes para gravacao no arquivo de definicoes                 
aCfgBut := { 	Iif( aCfgBut[ 1 ], "1", "2" ) , ;		// Botao acoes relacionadas
			    Iif( aCfgBut[ 2 ], "1", "2" ) , ;		// Botao editar
			    Iif( aCfgBut[ 3 ], "1", "2" )   }		// Botao editar somente para supervisor
      
// Compatibiliza ordem das opcoes de pesquisa conforme configuracao realizada
For nX := 1 To Len( aOpcPesq )

	If nX == 1		// Nome
		nPos := AScan( aOpcPesq, { |x| x == "Nome" } )
    ElseIf nX == 2	// CPF/CNPJ
    	nPos := AScan( aOpcPesq, { |x| x == "CPF/CNPJ" } )
	ElseIf nX == 3	// E-mail
    	nPos := AScan( aOpcPesq, { |x| x == "E-mail" } )
    ElseIf nX == 4	// Common Name	
    	nPos := AScan( aOpcPesq, { |x| x == "Common Name" } )
    ElseIf nX == 5	// Palavra Chave
    	nPos := AScan( aOpcPesq, { |x| x == "Palavra Chave" } )    	
    ElseIf nX == 6	// Pedido GAR
    	nPos := AScan( aOpcPesq, { |x| x == "Pedido GAR" } )    	
    ElseIf nX == 7	// Protocolo
    	nPos := AScan( aOpcPesq, { |x| x == "Protocolo" } )
    ElseIf nX == 8  // Pedido Site
    	nPos := AScan( aOpcPesq, { |x| x == "Pedido Site" } )
	EndIf
	
	cOpcPesq += AllTrim( Str( nPos ) ) + aOpcPesq[ nPos ] + ","
		
Next nX                                                      
              
cOpcPesq := SubStr( cOpcPesq, 1, Len( cOpcPesq) - 1 )

// Efetiva a gravacao no arquivo de configuracoes
If GrvArqDef( cFileDef, aColCfg, cOpcPesq, aCfgBut )
	MsgStatus( "Alterações gravadas com sucesso!", 3 )
Else
	MsgStatus( "A gravação das configurações não pode ser realizada. Tente novamente mais tarde.", 1 )
EndIf

Return


/*           
----------------------------------------------------------------------------
| Rotina    | RetGrpSDK    | Autor | Gustavo Prudente | Data | 04.08.2014  |
|--------------------------------------------------------------------------|
| Descricao | Retorna array com os grupos cadastrados e utilizados no      |
|           | modulo Service-Desk                                          |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function RetGrpSDK()
              
Local aRet   := {}      
Local cAlias := Alias()      

DbSelectArea( "SU0" )
DbSetOrder( 1 )
DbGoTop()

Do While ! EoF()
	// Monta o array de grupos de atendimentos 
	AAdd( aRet, { U0_CODIGO, Upper( AllTrim( U0_NOME ) ) } )	// Codigo do grupo e descricao
	DbSkip()
EndDo

DbSelectArea( cAlias )      

Return( aRet )


/*           
----------------------------------------------------------------------------
| Rotina    | RetCfgCols   | Autor | Gustavo Prudente | Data | 07.08.2014  |
|--------------------------------------------------------------------------|
| Descricao | Retorna array com o titulo das colunas s e utilizados no      |
|           | modulo Service-Desk                                          |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function RetCfgCols( aPesqCols )

Local aRet := {}
              
AEval( aPesqCols, { |x| Iif( NToL( x[ COL_STS ] ), AAdd( aRet, x[ COL_TIT ] ), .T. ) } )

Return( aRet )


/*           
----------------------------------------------------------------------------            
| Rotina    | CfgAdicCols  | Autor | Gustavo Prudente | Data | 07.08.2014  |
|--------------------------------------------------------------------------|
| Descricao | Adiciona colunas extras da tabela de atendimentos no listbox |
|           | de selecao de colunas do resultado da pesquisa.              |
|--------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto do listbox de configuracao das colunas
|			| EXPO2 - Objeto que indica a coluna desabilitada              |
|           | EXPA3 - Array com as configuracoes das colunas de resultado  |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function CfgAdicCols( oColCfg, oDes, aColCfg )
                                      
Local cAlias  := Alias() 
Local nPosCol := 0                                   
Local nOrdem  := Len( aColCfg ) + 1		// Proxima ordem para atualizacao do vetor
      
DbSelectArea( "SX3" )
DbSetOrder( 1 )
DbSeek( "ADE" )

Do While !Eof() .And. SX3->X3_ARQUIVO == "ADE"
                                           
	// Se a coluna ainda nao foi adicionada, realiza atualizacao do array aColCfg                          
	If X3Uso( SX3->X3_USADO ) .And. cNivel >= SX3->X3_NIVEL
			AAdd( aColCfg, { 	oDes		   	  , ;
					            nOrdem			  , ;
								Trim( X3Titulo() ), ;
								.F.		   	      , ;
								SX3->X3_CAMPO	  , ;
								.F.			      } )
	EndIf           
	
	nOrdem ++

	DbSkip()

EndDo                              

oColCfg:SetArray( aColCfg )
oColCfg:bLine := { || { aColCfg[ oColCfg:nAt, 1 ] , ;
						aColCfg[ oColCfg:nAt, 2 ] , ;
                   		aColCfg[ oColCfg:nAt, 3 ] , ;
						CfgDesCol( aColCfg, oColCfg:nAt ) } }
oColCfg:Refresh()

DbSelectArea( cAlias )

Return( .T. )


/*           
----------------------------------------------------------------------------            
| Rotina    | CfgDblClick  | Autor | Gustavo Prudente | Data | 08.08.2014  |
|--------------------------------------------------------------------------|
| Descricao | Adiciona colunas extras da tabela de atendimentos no listbox |
|           | de selecao de colunas do resultado da pesquisa.              |
|--------------------------------------------------------------------------|
| Parametros| EXPO1 - Objeto da lista de configuracao de colunas           |
|           | EXPA2 - Array com as configuracoes das colunas de resultado  |
|           | EXPO3 - Objeto que indica coluna desabilitada                |
|           | EXPO4 - Objeto que indica coluna habilitada                  |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function CfgDblClick( oLbxColCfg, aColCfg, oNo, oOk )
                   
Local nX		:= 0             
Local nPosNew	:= 0               
Local nPosCol	:= 0
Local nPosAtu	:= aColCfg[ oLbxColCfg:nAt, 2 ]
   
Local aColTmp	:= {}
Local aItemTmp	:= {}                                                                          

Local cColunas	:= ""

MsgStatus()
                                      
// Somente pode editar se a coluna estiver habilitada e posicionado na 2a. coluna
If oLbxColCfg:nColPos == 2 .And. aColCfg[ oLbxColCfg:nAt, 6 ]
	
	// Edita o campo ordem da coluna
	If lEditCell( aColCfg, oLbxColCfg, "999", 2 )
		
		// Guarda a nova ordem da coluna informada
		nPosNew := oLbxColCfg:aArray[ oLbxColCfg:nAt, 2 ]
		                                 
		// Somente reordena se a posicao atual for diferente da nova posicao e nao for informado caracter invalido
		If nPosNew # nPosAtu
		                                   
			// Evita tentativa de ordenacao para posicao que nao existe
			If Len( aColCfg ) < nPosNew .Or. nPosNew == 0

				MsgStatus( "A coluna na ordem informada não existe.", 1 )
				oLbxColCfg:aArray[ oLbxColCfg:nAt, 2 ] := nPosAtu
				
			ElseIf ! oLbxColCfg:aArray[ nPosNew, 6 ]	// Somente colunas ativadas
				    
				MsgStatus( "A coluna na ordem informada está desativada.", 1 )
				oLbxColCfg:aArray[ oLbxColCfg:nAt, 2 ] := nPosAtu
					
			Else                                                        
				
		    	// Percorre o vetor de configuracao de colunas refazendo a ordem das colunas
				For nX := 1 To Len( aColCfg )                                                                      
				             
					If nPosAtu == nX          
						If Len( aItemTmp ) == 0
							aItemTmp := AClone( aColCfg[ nX ] )
							AAdd( aColTmp, aColCfg[ nPosNew ] )
						Else
							AAdd( aColTmp, aItemTmp )
						EndIf	
					ElseIf nPosNew == nX
						If Len( aItemTmp ) == 0
							aItemTmp := AClone( aColCfg[ nX ] )
							AAdd( aColTmp, aColCfg[ nPosAtu ] )
						Else
							AAdd( aColTmp, aItemTmp )
						EndIf	  
					Else	
						AAdd( aColTmp, aColCfg[ nX ] )
					EndIf
					aColTmp[ nX, 2 ] := nX		

				Next nX  
             
				aColCfg := AClone( aColTmp )

			EndIf
		    
		EndIf
		                  
	EndIf
	    
Else    
                         
	// Se a coluna estiver ativada
	If aColCfg[ oLbxColCfg:nAt, 6 ]                         
		                              
		// Se a coluna estiver habilitada, desabilita
		If aColCfg[ oLbxColCfg:nAt, 4 ]
			aColCfg[ oLbxColCfg:nAt, 1 ] := oNo
			aColCfg[ oLbxColCfg:nAt, 4 ] := .F.
			aColCfg[ oLbxColCfg:nAt, 6 ] := .T.
		Else	
			// Se estiver desabilitada, habilita a coluna
			aColCfg[ oLbxColCfg:nAt, 1 ] := oOk
			aColCfg[ oLbxColCfg:nAt, 4 ] := .T.
			aColCfg[ oLbxColCfg:nAt, 6 ] := .T.
		EndIf                                  
	
	Else                          
	                     
		// Somnete habilita a coluna uma vez
		nPosCol := AScan( aColCfg, { |x| x[ 5 ] == aColCfg[ oLbxColCfg:nAt, 5 ] .And. x[ 6 ] } )
		
		If nPosCol > 0
			         
	    	MsgStatus( 'A coluna "' + aColCfg[ oLbxColCfg:nAt, 3 ] + '" já está ativa na ordem "' + AllTrim( Str( nPosCol ) ) + '".', 1 )
			oLbxColCfg:aArray[ oLbxColCfg:nAt, 2 ] := nPosAtu
	         
		Else
		                             
			// Ativa a coluna e coloca na ultima posicao
			For nX := 1 To Len( aColCfg )
	
				// Ao encontrar a primeira coluna desativada
				If ! aColCfg[ nX, 6 ]
					                                        
					// Insere o novo elemento e habilita a coluna  
					AAdd( aColCfg, nil )
					AIns( aColCfg, nX )
					
					aColCfg[ nX    ] := AClone( aColCfg[ oLbxColCfg:nAt + 1 ] )
					aColCfg[ nX, 1 ] := oOk
					aColCfg[ nX, 4 ] := .T.
					aColCfg[ nX, 6 ] := .T.
	
					oLbxColCfg:nAt := nX 
					
					Exit
					
				EndIf                                           
	
			Next nX	
	               
	        // Reordena proximas colunas desativadas      
			For nX := oLbxColCfg:nAt To Len( aColCfg )
	
				If nX # aColCfg[ nX, 2 ]
					aColCfg[ nX, 2 ] := nX
				EndIf
	
			Next nX
	
    	EndIf
	
	EndIf
	
EndIf

oLbxColCfg:Refresh()

Return( .T. )


/*
------------------------------------------------------------------------------
| Rotina    | OrdColRes   | Autor | Gustavo Prudente  | Data | 11.08.2014    |
|----------------------------------------------------------------------------|
| Descricao | Executa a acao de ordernar o listbox com as colunas do         |
|           | resultado da pesquisa.                                         |
|----------------------------------------------------------------------------|
| Parametros| EXPN1 - Indicar se deve ordenar acima (1) ou abaixo (2)        |
|           | EXPO2 - Objeto da lista de opcoes de pesquisa                  |
|           | EXPA3 - Array com as opcoes da pesquisa                        |
|           | EXPN4 - Ordem da opcao de pesquisa atual na lista              |
|----------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                            |
------------------------------------------------------------------------------
*/
Static Function OrdColRes( nTipo, oColCfg, aColCfg, nOrdem )

Local oSttNew                                       
Local oSttAtu

Local nOrdNew := nOrdem

Local cOpcNew := ""
Local cRefNew := ""

Local lHabNew := .F.

If nTipo == 1 .And. nOrdem > 1
	nOrdNew --
ElseIf nTipo == 2 .And. nOrdem < Len( aColCfg )
	nOrdNew ++
EndIf

If nOrdNew # nOrdem

	// Somente reordena se a coluna estiver ativada
	If oColCfg:aArray[ nOrdNew, 6 ]
                        
		// Guarda informacoes para atualizacao correta das colunas apos a reordenacao
		oSttNew := aColCfg[ nOrdem , 1 ]

		oSttAtu := aColCfg[ nOrdNew, 1 ]
		cOpcNew := aColCfg[ nOrdNew, 3 ]
		lHabNew := aColCfg[ nOrdNew, 4 ]
		cRefNew := aColCfg[ nOrdNew, 5 ]

		// Atualiza status e nome das colunas na nova ordem
		aColCfg[ nOrdNew, 1 ] := oSttNew
		aColCfg[ nOrdNew, 3 ] := aColCfg[ nOrdem, 3 ]
		aColCfg[ nOrdNew, 4 ] := aColCfg[ nOrdem, 4 ]
		aColCfg[ nOrdNew, 5 ] := aColCfg[ nOrdem, 5 ]
		
		aColCfg[ nOrdem, 1  ] := oSttAtu
		aColCfg[ nOrdem, 3  ] := cOpcNew       
		aColCfg[ nOrdem, 4  ] := lHabNew
		aColCfg[ nOrdem, 5  ] := cRefNew
                                                           
		// Atualiza array no objeto do listbox apos reordenar as colunas
		oColCfg:SetArray( aColCfg )

		oColCfg:bLine := { || { aColCfg[ oColCfg:nAt, 1 ] , ;
								aColCfg[ oColCfg:nAt, 2 ] , ;
                		   		aColCfg[ oColCfg:nAt, 3 ] , ;
								CfgDesCol( aColCfg, oColCfg:nAt ) } }

		oColCfg:nAt := nOrdNew 
		oColCfg:Refresh()

	EndIf

EndIf
		
Return( .T. )

                
/*
------------------------------------------------------------------------------
| Rotina     | GetCPF     | Autor | Gesse Santos         | Data | 10.02.2014 |
|----------------------------------------------------------------------------|
| Descricao  | Busca o CPF/CNPJ do contato a partir do protocolo             |
|            | da pesquisa principal.                                        |
|----------------------------------------------------------------------------|
| Parametros | EXPC1 - Codigo da entidade para busca do CPF/CNPJ             |
|            | EXPC2 - Chave para pesquisa da entidade                       |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function GetCpf( cEntidade, cChave )
                
local __cCpf := "9-Nao Identificado"

if cEntidade $ "SZT*ACH*SA1*SU5*SUS*SZ3"
	do case
		case cEntidade == "SZT"  
		    szt->(dbsetorder(1))
			szt->(dbseek( aFilSDK[ XFIL_SZT ] + cChave , .t. ))
			__cCpf := szt->zt_cnpj 
			
		case cEntidade == "ACH" 
		    ach->(dbsetorder(1))
		    ach->(dbseek( aFilSDK[ XFIL_ACH ] + cChave, .t. ))
			__cCpf := ach->ach_cgc
			
		case cEntidade == "SA1"  				     
		    sa1->(dbsetorder(1))
		    sa1->(dbseek( aFilSDK[ XFIL_SA1 ] + cChave, .t. ))
			__cCpf := sa1->a1_cgc                             
			
		case cEntidade == "SU5"   
		    su5->(dbsetorder(1))
		    su5->(dbseek( aFilSDK[ XFIL_SU5 ] + cChave, .t. ))
			__cCpf := su5->u5_cpf
			
		case cEntidade == "SUS"
		    sus->(dbsetorder(1))
		    sus->(dbseek( aFilSDK[ XFIL_SUS ] + cChave, .t. ))
			__cCpf := sus->us_cgc
			
		case cEntidade == "SZ3"
		    sz3->(dbseek( aFilSDK[ XFIL_SZ3 ] + cChave, .t. ))
			__cCpf := sz3->z3_cgc
			
	endcase
	if !empty(__cCpf) 
	    
		if len(alltrim(__cCpf)) > 11
			__cCpf := transform(__cCpf,"@R 99.999.999/9999-99")
		else
			__cCpf := transform(__cCpf,"@R 999.999.999-99")
		endif
	else       
	    
		__cCpf     := "0-Não Identificado"
	endif
else
	__cCpf     := "1-Não Identificado"
endif
       
Return( __cCpf )


      
/*
------------------------------------------------------------------------------
| Rotina     | CfgDesCol  | Autor | Gustavo Prudente     | Data | 13.08.2014 |
|----------------------------------------------------------------------------|
| Descricao  | Busca descricao da coluna no dicionario SX3                   |
|----------------------------------------------------------------------------|
| Parametros | EXPA1 - Array com a configuracao das colunas exibidas nos     |
|            |         resultados da pesquisa                                |
|            | EXPN2 - Item atualmente posicionado na lista de colunas       |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function CfgDesCol( aColCfg, nItem )

Local cRet := aColCfg[ nItem, 3 ]

// Busca a descricao do campo no dicionario SX3
If "ADE_" $ aColCfg[ nItem, 5 ]
	cRet := GetSX3Cache( aColCfg[ nItem, 5 ], "X3_DESCRIC" )
EndIf

Return( cRet )