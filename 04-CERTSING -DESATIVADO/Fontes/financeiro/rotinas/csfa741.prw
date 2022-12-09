#INCLUDE 'Protheus.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'FWMVCDEF.CH' // Obrigatorio esse include para MVC

//---------------------------------------------------------------------------------
// Rotina | CSFA741     | Autor | Rafael Beghini              | Data | 29.11.2018
//---------------------------------------------------------------------------------
// Descr. | Resumo de Vendas
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CSFA741()
    Local oBrowse := FwmBrowse():NEW() 
	Private cCadastro := 'Resumo de Vendas'
	    
    oBrowse:SetAlias("PBR")
    oBrowse:SetDescription(cCadastro)
    oBrowse:Activate()
	
Return( NIL )
//---------------------------------------------------------------------------------------------

Static Function MenuDef()
	Local aBotao := {}
	aAdd(aBotao,{ "Análise"		, "VIEWDEF.CSFA741"	, 0, 2, 0, NIL } )
	aAdd(aBotao,{ "Relatório"   , "U_A741Imp()"		, 0, 6, 0, NIL } )	
	aAdd(aBotao,{ "Bandeiras"   , "U_A741Band()"	, 0, 7, 0, NIL } )	
Return aBotao
//-------------------------------------------------------------------

Static Function ModelDef()
    Local oModel    := NIL
    Local oStruCab  := NIL
    Local oStruGrd  := NIL
	Local bPost		:= {|| .T. }
	Local bCommit	:= {|| .T. }

    //-- Cria a primeira estrutura - Resumo Venda
    oStruCab    := FWFormStruct(1,'PBR')

    //-- Cria a segunda estrutura (Grid) Base conciliação
    oStruGrd    := FWFormStruct(1,'PBS')

	oModel		:= MPFormModel():New( "RV", /*bPre*/ , bPost, bCommit, /*bCancel*/ )

    //-- Adiciona Objetos Criados à Model
	oModel:AddFields('MdFieldCab',,oStruCab)
	
	//-- Sintaxe:
	//--  :AddGrid(< cId >    , < cOwner > , < oModelStruct >, < bLinePre >, < bLinePost >, < bPre >, < bLinePost >, < bLoad >)
	oModel:AddGrid('MdGridTRB','MdFieldCab', oStruGrd        ,             ,              ,         ,              ,  )

    //-- Seta Descrição Para Cada Divisão Da Model
	oModel:GetModel('MdFieldCab' ):SetDescription('STR0004')
	oModel:GetModel('MdGridTRB'):SetDescription('STR0005')
	oModel:SetDescription('Resumo de Venda')
	
	//-- Adiciona Restrições Aos Objetos Da Model
	oModel:GetModel( 'MdGridTRB' ):SetNoInsertLine( .T. )
	oModel:GetModel( 'MdGridTRB' ):SetNoDeleteLine( .T. )
	oModel:GetModel( 'MdGridTRB' ):SetOptional( .T. )
	
	//-- Seta Chave Primária Da Model
	oModel:SetPrimaryKey({'PBR_FILIAL','PBR_PVMAT','PBR_PV','PBR_RV','PBR_DATA'})  

    oModel:SetRelation('MdGridTRB', { {'PBS_FILIAL',"xFilial('PBS')"}, {'PBS_PVMAT','PBR_PVMAT'}, {'PBS_PV','PBR_PV'},;
                                        {'PBS_RV','PBR_RV'}, {'PBS_DATA','PBR_DATA'} }, PBS->(IndexKey(1)) )
    
	//-- Ativação Da Model
	oModel:SetActivate( )	

Return(oModel)

//-------------------------------------------------------------------
Static Function ViewDef()
    Local oView   	:= NIL		// Recebe o objeto da View
	Local oModel  	:= NIL		// Objeto do Model
	Local oStruCab 	:= NIL   	// Recebe a Estrutura cabecalho
	Local oStruGrd 	:= NIL  	// Recebe a Estrutura
	
    oModel  := ModelDef()

    //-- Cria Primeira Estrutura (Field) Na Parte Superior Da Tela
    oStruCab := FWFormStruct(2, 'PBR')

    //-- Cria Segunda Estrutura (Grid) Na Parte inferior Da Tela
	oStruGrd := FWFormStruct(2, 'PBS')

	//-- Cria o objeto de View
	oView := FwFormView():New()

    //-- Define qual o Modelo de dados será utilizado na View
	oView:SetModel(oModel)

    //-- Alteração de propriedades do campo
	oStruGrd:SetProperty( '*', MVC_VIEW_CANCHANGE,.F.) //-- Bloqueia Todos Os Campos Da Grid
	
    //-- Adiciona botões
    oView:AddUserButton( 'Movimento financeiro (F9)','CLIPS'	, { |oView| A741MovFi() 	  }	, , 120 ) //-- VK_F9
    oView:AddUserButton( 'Pesquisar (F10)'			,'PESQUISA'	, {	|oView| Pesquisar(oModel) }	, , 121 ) //-- VK_F10
    
    //-- Adiciona Os Objetos Criados à View
	oView:AddField('VwFieldCab', oStruCab , 'MdFieldCab') 
	oView:AddGrid('VwGridTRB'  , oStruGrd , 'MdGridTRB' )
		
	//-- Dimensiona a Tela Da View
	oView:CreateHorizontalBox('CABECALHO' ,50)
	oView:CreateHorizontalBox('GRID'	  ,50)
	
    oView:EnableTitleView( 'VwFieldCab',"Resumo de venda" )
	
    //-- Seta Os Objetos para Cada Dimensão Criada
    oView:SetOwnerView('VwFieldCab','CABECALHO')
    oView:SetOwnerView('VwGridTRB' ,'GRID'     )
    
    oView:EnableTitleView( 'VwGridTRB', 'Base conciliação' )
    
	//-- Não Permite Abertura Da Tela De "Salvar Dados Do Formulário"
	oView:SetViewAction("ASKONCANCELSHOW",{||.F.})

    //-- Remove campos da Grid
    oStruGrd:RemoveField("PBS_PVMAT")
    oStruGrd:RemoveField("PBS_PV")
    oStruGrd:RemoveField("PBS_RV")
    oStruGrd:RemoveField("PBS_DATA")

Return(oView)

//---------------------------------------------------------------------------------
// Rotina | A741MovFi    | Autor | Rafael Beghini     | Data | 29.11.2018
//---------------------------------------------------------------------------------
// Descr. | Tela de consulta do movimento financeiro
//        | Utilizado a classe FWFormBrowse
//---------------------------------------------------------------------------------
Static Function A741MovFi()
    Local oMdl      := FWModelActive()
    Local oDlg      := NIL  
    Local oBrowse   := NIL
    Local cSQL      := ''
    Local cPicture  := X3Picture("PBT_VALOR")
    Local cTRB      := GetNextAlias()
    Local cMatriz   := oMdl:GetModel('MdFieldCab'):GetValue('PBR_PVMAT')
    Local cPV       := oMdl:GetModel('MdFieldCab'):GetValue('PBR_PV')
    Local cRV       := oMdl:GetModel('MdFieldCab'):GetValue('PBR_RV')
    Local aIndex    := {'PBT_FILIAL','PBT_PVMAT','PBT_PV','PBT_RV'}
    Local aSeek		:= {{ 'Ordem de pagamento', {{"","C",15,0,'PBT_NUMDOC',,}} }}
    Local aCombo    := {}
    Local bTipoTR   := {|| nPos := AScan( aCombo, {|x| Left(x,1) == PBT_TIPOTR} ), Iif( nPos > 0, SubStr(aCombo[nPos],3), '' ) }

    dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	IF dbSeek( 'PBT_TIPOTR' )   
		aCombo := StrToKarr( X3CBox(), ';' )
	EndIF

    cSQL := " SELECT " + CRLF
    cSQL += " PBT_FILIAL, PBT_PVMAT, PBT_PV, PBT_RV, PBT_DATA, PBT_NUMDOC, PBT_VALOR, PBT_TIPO, PBT_TIPOTR, PBT_PARCEL, PBT_TPAJUS, PBT_DESCAJ, PBT_FILE" + CRLF
    cSQL += " FROM " + RetSqlName("PBT") + " PBT " + CRLF
    cSQL += " WHERE PBT.D_E_L_E_T_= ' ' " + CRLF
    cSQL += " AND PBT_PVMAT = '" + cMatriz + "' " + CRLF
    cSQL += " AND PBT_PV = '" + cPV + "' " + CRLF
    cSQL += " AND PBT_RV = '" + cRV + "' " + CRLF

    DEFINE MSDIALOG oDlg TITLE 'Movimento financeiro' FROM 0,0 TO 460,1000 PIXEL
        oBrowse := FWFormBrowse():New()
        oBrowse:SetDescription('A seguir, dados de retorno do Movimento financeiro')
        oBrowse:SetAlias(cTRB)
        oBrowse:SetDataQuery()
        oBrowse:SetQuery(cSQL)
        oBrowse:SetOwner(oDlg)
        //oBrowse:SetDoubleClick({ || MsgALert('oi') })
        oBrowse:AddButton( OemTOAnsi('Confirmar')	, {|| oDlg:End() } ,, 2 ) //"Confirmar"
        oBrowse:DisableDetails()
        oBrowse:SetQueryIndex(aIndex)
        oBrowse:SetSeek({||.T.},aSeek)

        ADD COLUMN oColumn DATA { || STOD(PBT_DATA) }                   TITLE 'Data'                SIZE 05 OF oBrowse
        ADD COLUMN oColumn DATA { || PBT_NUMDOC }                       TITLE 'Ordem pagamento'     SIZE 05 OF oBrowse
        ADD COLUMN oColumn DATA { || TransForm(PBT_VALOR,cPicture) }    TITLE 'Valor'               SIZE 10 OF oBrowse
        ADD COLUMN oColumn DATA { || PBT_TIPO   }                       TITLE 'Tipo'                SIZE 04 OF oBrowse
        ADD COLUMN oColumn DATA bTipoTR                                 TITLE 'Transação'           SIZE 10 OF oBrowse
        ADD COLUMN oColumn DATA { || PBT_PARCEL }                       TITLE 'Parcela'             SIZE 05 OF oBrowse
        ADD COLUMN oColumn DATA { || PBT_TPAJUS }                       TITLE 'Ajuste'              SIZE 05 OF oBrowse
        ADD COLUMN oColumn DATA { || PBT_DESCAJ }                       TITLE 'Descrição'           SIZE 10 OF oBrowse
        ADD COLUMN oColumn DATA { || PBT_FILE   }                       TITLE 'Arquivo importado'   SIZE 05 OF oBrowse
        
        oBrowse:Activate()
    ACTIVATE MSDIALOG oDlg CENTERED        
Return

//---------------------------------------------------------------------------------
// Rotina | A741Imp    | Autor | Rafael Beghini     | Data | 29.11.2018
//---------------------------------------------------------------------------------
// Descr. | Impressão do Resumo de Venda
//---------------------------------------------------------------------------------
User Function A741Imp()
    Private oReport  := Nil
	Private oSecCab	 := Nil
    Private oSecItem := Nil
	Private oBreak   := Nil
	ReportDef()
	oReport	:PrintDialog()
Return NIL

//---------------------------------------------------------------------------------
// Rotina | ReportDef    | Autor | Rafael Beghini     | Data | 29.11.2018
//---------------------------------------------------------------------------------
// Descr. | Definição da estrutura do relatório.
//---------------------------------------------------------------------------------
Static Function ReportDef()
                           
	Local cPicture := "@E 999,999,999.99"
	Local cPict1   := "@E 999.99"
	
	oReport := TReport():New("A741Imp","Resumo de Vendas",'',;
			   {|oReport| PrintReport(oReport)},"Este relatório irá imprimir o resumo de vendas conforme posicionado.")
	
	oReport:cFontBody:= 'Consolas'
	oReport:nFontBody:= 7
	oReport:nLineHeight:= 30
	oReport:SetPortrait(.T.)  //Retrato - oReport:SetLandscape(.T.) //Paisagem
	
	oSecCab := TRSection():New( oReport , "Resumo de Vendas", {"QRY"} )

    TRCell():New( oSecCab, "PBR_PV"     , "QRY", 'Ponto de Venda'   )
    TRCell():New( oSecCab, "PBR_RV"     , "QRY", 'Resumo de Venda'  )
    TRCell():New( oSecCab, "PBR_DATA"   , "QRY", 'Data'             )
    TRCell():New( oSecCab, "PBR_BANDEI" , "QRY", 'Bandeira'         )
    
    oSecItem := TRSection():New( oReport , "Resumo de Vendas", {"QRY"} )

	TRCell():New( oSecItem, "PBS_VLRNSU" , "QRY", 'Valor CV/NSU' , cPicture)     
	//TRCell():New( oSecCab, "PBS_NUMSEQ" , "QRY", 'Quantidade CV', )   
	TRCell():New( oSecItem, "PBS_CARTAO" , "QRY", 'Num. Cartão'  , )
	TRCell():New( oSecItem, "PBS_NSU"    , "QRY", 'CV/NSU'       , )
	TRCell():New( oSecItem, "PBS_CODAUT" , "QRY", 'Nº autorizaçõ', )
	TRCell():New( oSecItem, "PBS_TID"    , "QRY", 'Num. TID'     , )
	TRCell():New( oSecItem, "PBS_PSITE"  , "QRY", 'Pedido SITE'  , )
	TRCell():New( oSecItem, "PBS_PARCEL" , "QRY", 'Num. parcela' , )
	//TRCell():New( oSecCab, "PBS_QTPARC" , "QRY", 'Qtd parcela'  , )
    TRCell():New( oSecItem, "PBS_VALOR"  , "QRY", 'Valor'        , cPicture)
    TRCell():New( oSecItem, "PBS_VLDESC" , "QRY", 'Vlr desconto' , cPicture)
    TRCell():New( oSecItem, "PBS_VALLIQ" , "QRY", 'Vlr liquido'  , cPicture)
    TRCell():New( oSecItem, "PBS_TAXA"   , "QRY", 'Taxa (%)'     , cPict1)
    TRCell():New( oSecItem, "PBS_TERMIN" , "QRY", 'Num. terminal', )
    TRCell():New( oSecItem, "PBS_NUMDOC" , "QRY", 'Ordem crédito', )
    TRCell():New( oSecItem, "PBS_DTLCTO" , "QRY", 'Data lancto'  , )
	TRCell():New( oSecItem, "PBS_NUMCAN" , "QRY", 'Ordem débito' , )
    TRCell():New( oSecItem, "PBS_DTCANC" , "QRY", 'Data lancto'  , )

    oReport:SetTotalInLine(.F.)
	
	//Aqui, farei uma quebra  por seção
	oSecCab:SetPageBreak(.F.)
	oSecCab:SetTotalInLine(.F.)
	oSecCab:SetTotalText(" ")

Return Nil

//---------------------------------------------------------------------------------
// Rotina | PrintReport    | Autor | Rafael Beghini     | Data | 29.11.2018
//---------------------------------------------------------------------------------
// Descr. | Definição da estrutura do relatório.
//---------------------------------------------------------------------------------
Static Function PrintReport(oReport)

	Local cQuery     := ""
	
	cQuery += " SELECT " + CRLF 
	cQuery += "     PBS_VLRNSU " + CRLF   
    cQuery += "     ,PBS_NUMSEQ" + CRLF 
    cQuery += "     ,PBS_CARTAO" + CRLF 
    cQuery += "     ,PBS_NSU   " + CRLF 
    cQuery += "     ,PBS_CODAUT" + CRLF 
    cQuery += "     ,PBS_TID   " + CRLF 
    cQuery += "     ,PBS_PSITE " + CRLF 
    cQuery += "     ,PBS_PARCEL" + CRLF 
    cQuery += "     ,PBS_QTPARC" + CRLF 
    cQuery += "     ,PBS_VALOR " + CRLF 
    cQuery += "     ,PBS_VLDESC" + CRLF 
    cQuery += "     ,PBS_VALLIQ" + CRLF 
    cQuery += "     ,PBS_TAXA  " + CRLF 
    cQuery += "     ,PBS_TERMIN" + CRLF 
    cQuery += "     ,PBS_NUMDOC" + CRLF 
    cQuery += "     ,PBS_DTLCTO" + CRLF 
    cQuery += "     ,PBS_NUMCAN" + CRLF 
    cQuery += "     ,PBS_DTCANC" + CRLF 
    cQuery += "     ,PBR_PVMAT" + CRLF 
    cQuery += "     ,PBR_PV" + CRLF 
    cQuery += "     ,PBR_RV" + CRLF 
    cQuery += "     ,PBR_BANDEI" + CRLF 
    cQuery += "     ,PBR_DATA" + CRLF
    cQuery += "     ,PBU_DESC" + CRLF
	cQuery += " FROM " + RetSqlName("PBS") + " PBS " + CRLF 

    cQuery += "  	INNER JOIN " + RetSqlName("PBR") + " PBR " + CRLF 
	cQuery += "     ON PBR_FILIAL = PBS_FILIAL " + CRLF
	cQuery += "   	AND PBR_PVMAT = PBS_PVMAT " + CRLF 
	cQuery += "   	AND PBR_PV = PBS_PV " + CRLF 
	cQuery += "   	AND PBR_RV = PBS_RV " + CRLF 
	cQuery += "   	AND PBR.D_E_L_E_T_ = ' ' " + CRLF

    cQuery += "  	LEFT JOIN " + RetSqlName("PBU") + " PBU " + CRLF 
	cQuery += "     ON PBU_FILIAL = '" + xFilial('PBU') + "' " + CRLF
	cQuery += "   	AND PBU_COD = PBR_BANDEI " + CRLF

	cQuery += " WHERE PBS.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += "   AND PBS_FILIAL 	= '" + PBR->PBR_FILIAL + "' " + CRLF
	cQuery += "   AND PBS_PVMAT 	= '" + PBR->PBR_PVMAT + "' " + CRLF
	cQuery += "   AND PBS_PV 		= '" + PBR->PBR_PV + "' " + CRLF
	cQuery += "   AND PBS_RV 		= '" + PBR->PBR_RV + "' " + CRLF

	cQuery := ChangeQuery(cQuery)
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf
	
	TcQuery cQuery New Alias "QRY"
	
	dbSelectArea("QRY")
	QRY->(dbGoTop())
	
	oReport:SetMeter(QRY->(LastRec()))	

	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSecCab:Init()

		oReport:IncMeter()
					
		cNcm 	:= QRY->( PBR_PVMAT + PBR_PV + PBR_RV )
		IncProc( "Imprimindo resumo de venda " + QRY->PBR_RV )
		
		//imprimo a primeira seção				
		oSecCab:Cell("PBR_PV"):SetValue(QRY->PBR_PV)
		oSecCab:Cell("PBR_RV"):SetValue(QRY->PBR_RV)
		oSecCab:Cell("PBR_DATA"):SetValue(StoD(QRY->PBR_DATA))
		oSecCab:Cell("PBR_BANDEI"):SetValue(rTrim(QRY->PBU_DESC))
		oSecCab:Printline()
		
		//inicializo a segunda seção
		oSecItem:init()
		
		While QRY->( PBR_PVMAT + PBR_PV + PBR_RV ) == cNcm
			oReport:IncMeter()		
		
			//IncProc("Imprimindo produto "+alltrim(TRBNCM->B1_COD))
			oSecItem:Cell("PBS_VLRNSU"):SetValue(QRY->PBS_VLRNSU)
			oSecItem:Cell("PBS_CARTAO"):SetValue(QRY->PBS_CARTAO)
			oSecItem:Cell("PBS_NSU"):SetValue(QRY->PBS_NSU)			
			oSecItem:Cell("PBS_CODAUT"):SetValue(QRY->PBS_CODAUT)			
			oSecItem:Cell("PBS_TID"):SetValue(QRY->PBS_TID)			
			oSecItem:Cell("PBS_PSITE"):SetValue(QRY->PBS_PSITE)			
			oSecItem:Cell("PBS_PARCEL"):SetValue(QRY->PBS_PARCEL)
			oSecItem:Cell("PBS_VALOR"):SetValue(QRY->PBS_VALOR)
			oSecItem:Cell("PBS_VLDESC"):SetValue(QRY->PBS_VLDESC)
			oSecItem:Cell("PBS_VALLIQ"):SetValue(QRY->PBS_VALLIQ)
			oSecItem:Cell("PBS_TAXA"):SetValue(QRY->PBS_TAXA)
			oSecItem:Cell("PBS_TERMIN"):SetValue(QRY->PBS_TERMIN)
			oSecItem:Cell("PBS_NUMDOC"):SetValue(QRY->PBS_NUMDOC)
			oSecItem:Cell("PBS_DTLCTO"):SetValue(StoD(QRY->PBS_DTLCTO))
			oSecItem:Cell("PBS_NUMCAN"):SetValue(QRY->PBS_NUMCAN)
			oSecItem:Cell("PBS_DTCANC"):SetValue(StoD(QRY->PBS_DTCANC))
			oSecItem:Printline()
	
 			QRY->(dbSkip())
 		EndDo		
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSecItem:Finish()
 		//imprimo uma linha para separar uma NCM de outra
 		oReport:ThinLine()
 		//finalizo a primeira seção
		oSecCab:Finish()
	Enddo

Return Nil

//---------------------------------------------------------------------------------
// Rotina | Pesquisar    | Autor | Rafael Beghini     | Data | 05.12.2018
//---------------------------------------------------------------------------------
// Descr. | Função para pesquisar o conteúdo na GRID
//---------------------------------------------------------------------------------
Static Function Pesquisar(oModel)
	Local cField	:= ''
	Local cOpc		:= ''
	Local aPAR		:= {}
	Local aRET		:= {}
	Local aOPC		:= {"1.Pedido Site","2.Num Cartão"}

	aAdd( aPAR, {1, "Conteúdo", Space(40), "","",""   ,"",60,.T.})
	aAdd( aPAR, {2,	"Opção"	  ,	1,	aOPC,50,"",.F.})

	IF ParamBox(aPAR,'Pesquisa',@aRET)
		cOpc := IIf( ValType( aRET[2] ) == 'C', Subs(aRET[2],1,1), LTrim( Str( aRET[2], 1, 0 ) ) )	
		IF cOpc == '1'
			cField := 'PBS_PSITE'
		Else
			cField := 'PBS_CARTAO'
		EndIF
		oModel:GetModel('MdGridTRB'):SeekLine( { { cField, Alltrim( aRET[ 1 ] ) } } )
    EndIF
Return

//---------------------------------------------------------------------------------
// Rotina | A741Band    | Autor | Rafael Beghini     | Data | 06.12.2018
//---------------------------------------------------------------------------------
// Descr. | Relação das bandeiras utilizadas
//---------------------------------------------------------------------------------
User Function A741Band()
	Local oDlg      := NIL  
    Local oBrowse   := NIL
    Local cSQL      := ''
    Local cTRB      := GetNextAlias()
    Local aIndex    := {'PBU_FILIAL','PBU_COD'}
    Local aSeek		:= {{ 'Código Bandeira', {{"","C",01,0,'PBU_COD',,}} }}
    Local aCombo    := {}

    cSQL := " SELECT " + CRLF
    cSQL += " PBU_FILIAL, PBU_COD, PBU_DESC, PBU_BANCO, PBU_AGENCI, PBU_CONTA " + CRLF
    cSQL += " FROM " + RetSqlName("PBU") + " PBU " + CRLF
    cSQL += " WHERE PBU.D_E_L_E_T_= ' ' " + CRLF
    cSQL += " AND PBU_FILIAL = '" + xFilial('PBU') + "' " + CRLF
    

    DEFINE MSDIALOG oDlg TITLE 'Relação de bandeiras' FROM 0,0 TO 500,800 PIXEL
        oBrowse := FWFormBrowse():New()
        //oBrowse:SetDescription('A seguir, dados de retorno do Movimento financeiro')
        oBrowse:SetAlias(cTRB)
        oBrowse:SetDataQuery()
        oBrowse:SetQuery(cSQL)
        oBrowse:SetOwner(oDlg)
        //oBrowse:SetDoubleClick({ || MsgALert('oi') })
        oBrowse:AddButton( OemTOAnsi('Fechar')	, {|| oDlg:End() } ,, 2 ) //"Confirmar"
        oBrowse:DisableDetails()
        oBrowse:SetQueryIndex(aIndex)
        oBrowse:SetSeek({||.T.},aSeek)

        ADD COLUMN oColumn DATA { || PBU_COD 	} TITLE 'Código'	SIZE 05 OF oBrowse
        ADD COLUMN oColumn DATA { || PBU_DESC 	} TITLE 'Descrição' SIZE 10 OF oBrowse
        ADD COLUMN oColumn DATA { || PBU_BANCO 	} TITLE 'Banco'	 	SIZE 05 OF oBrowse
        ADD COLUMN oColumn DATA { || PBU_AGENCI } TITLE 'Agência'	SIZE 05 OF oBrowse
        ADD COLUMN oColumn DATA { || PBU_CONTA 	} TITLE 'Conta'	 	SIZE 05 OF oBrowse
        
        oBrowse:Activate()
    ACTIVATE MSDIALOG oDlg CENTERED
Return