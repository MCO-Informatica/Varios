#INCLUDE 'Protheus.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE 'FWMVCDEF.CH' // Obrigatorio esse include para MVC

//---------------------------------------------------------------------------------
// Rotina | CSFA743     | Autor | Rafael Beghini              | Data | 10.12.2018
//---------------------------------------------------------------------------------
// Descr. | Movimentação financeira (EEFI) - Chamada FWExecView CSFA742
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CSFA743()
	Local oDlg      := NIL  
    Local oMainWnd  := NIL
    Local cSQL      := ''
    Local cPicture  := X3Picture("PBT_VALOR")
    Local cTRB      := GetNextAlias()
    Local aIndex    := {'PBT_FILIAL','PBT_PVMAT','PBT_PV','PBT_NUMDOC'}
    Local aSeek		:= {{ 'Ordem pagamento', {{"","C",11,0,'PBT_NUMDOC',,}} }}
    Local aTipoTr   := {}
    Local aBandei	:= {}
    Local aSize     := {}
    Local bTipoTR   := {|| nPos := AScan( aTipoTr, {|x| Left(x,1) == PBT_TIPOTR} ), Iif( nPos > 0, SubStr(aTipoTr[nPos],3), '' ) }
    Local bBandeira := {|| nPos := AScan( aBandei, {|x| Left(x,1) == PBT_BANDEI} ), Iif( nPos > 0, SubStr(aBandei[nPos],3), '' ) }
    
    Private oBrowse   := NIL
    
    dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	IF dbSeek( 'PBT_TIPOTR' )   
		aTipoTr := StrToKarr( X3CBox(), ';' )
	EndIF
	IF dbSeek( 'PBT_BANDEI' )   
		aBandei := StrToKarr( X3CBox(), ';' )
	EndIF
    
    // Obtém a a área de trabalho e tamanho da dialog
    aSize := MsAdvSize()
    
    cSQL := "SELECT PBT_FILIAL, PBT_PVMAT, PBT_PV, PBT_NUMDOC, PBT_DATARV, PBT_VALOR, PBT_BANDEI, PBT_TIPOTR, PBT_PARCEL " + CRLF
    cSQL += "FROM " + RETSQLNAME("PBT") + " PBT " + CRLF
    cSQL += "WHERE PBT.D_E_L_E_T_= ' ' " + CRLF
    cSQL += " AND PBT_FILIAL = '" + XFILIAL('PBT') + "' " + CRLF
    cSQL += "AND PBT_TIPO = 'C' " + CRLF
    cSQL += "order by pbt_filial, pbt_pvmat, pbt_pv, pbt_datarv, pbt_numdoc " + CRLF
    
    DEFINE MSDIALOG oDlg TITLE 'Movimentação financeira' From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL
        oBrowse := FWFormBrowse():New()
        oBrowse:SetDescription('Clicando 2 vezes em cima de um registro será aberto uma janela para visualização.')
        oBrowse:SetAlias(cTRB)
        oBrowse:SetDataQuery()
        oBrowse:SetQuery(cSQL)
        oBrowse:SetOwner(oDlg)
        oBrowse:SetDoubleClick({ || A743Show(oBrowse) })
        
        oBrowse:AddButton( OemTOAnsi('Finalizar')		, {|| oDlg:End() } 			,, 2 )
        oBrowse:AddButton( OemTOAnsi('Rel. Analítico')	, {|| A743ImpA(oBrowse) } 	,, 2 )
        oBrowse:AddButton( OemTOAnsi('Rel. Sintético')	, {|| A743ImpS(oBrowse) } 	,, 2 )
	
        oBrowse:DisableDetails()
        oBrowse:SetQueryIndex(aIndex)
        oBrowse:SetSeek({||.T.},aSeek)

        ADD COLUMN oColumn DATA { || PBT_PVMAT 	}       				TITLE 'Matriz'	        SIZE 05 OF oBrowse
        ADD COLUMN oColumn DATA { || PBT_PV 	}       				TITLE 'Ponto Venda'     SIZE 05 OF oBrowse
        ADD COLUMN oColumn DATA { || PBT_NUMDOC }       				TITLE 'Ordem pagamento'	SIZE 10 OF oBrowse
        ADD COLUMN oColumn DATA { || STOD(PBT_DATARV) } 				TITLE 'Data'	        SIZE 08 OF oBrowse
        ADD COLUMN oColumn DATA { || TransForm(PBT_VALOR,cPicture) 	}	TITLE 'Valor'	 	    SIZE 10 OF oBrowse
        ADD COLUMN oColumn DATA bBandeira       						TITLE 'Bandeira'	 	SIZE 15 OF oBrowse
        ADD COLUMN oColumn DATA bTipoTR       							TITLE 'Transação'	 	SIZE 15 OF oBrowse
        ADD COLUMN oColumn DATA { || PBT_PARCEL }       				TITLE 'Parcela(s)'	 	SIZE 10 OF oBrowse
        
        oBrowse:Activate()
    ACTIVATE MSDIALOG oDlg CENTERED
Return

Static Function A743Show(oBrowse)
    Local nRet	:= 0
    Local nOper	:= 3
	Local cSeek	:= (oBrowse:Alias())->(PBT_FILIAL + PBT_PV + PBT_NUMDOC)
	
	oModel := FwLoadModel("CSFA742")
	oModel:SetOperation(nOper)
	oModel:Activate()
     
    PBT->( dbSetOrder(2) )
    IF PBT->( dbSeek( cSeek ) )
    	FWExecView('Arquivo retorno [EEFI]','VIEWDEF.CSFA742', MODEL_OPERATION_VIEW, , { || .T. })
    Else
    	MsgAlert('Erro, verifique com sistemas','CSFA743')
    EndIF	     
Return

//---------------------------------------------------------------------------------
// Rotina | A743ImpA    | Autor | Rafael Beghini     | Data | 12.12.2018
//---------------------------------------------------------------------------------
// Descr. | Impressão do Movimento financeiro analítico
//---------------------------------------------------------------------------------
Static Function A743ImpA()
    Private oReport  := Nil
	Private oSecCab	 := Nil
    Private oSecItem := Nil
    Private oBreak   := Nil
	ReportDef()
	oReport	:PrintDialog()
Return NIL

//---------------------------------------------------------------------------------
// Rotina | ReportDef    | Autor | Rafael Beghini     | Data | 12.12.2018
//---------------------------------------------------------------------------------
// Descr. | Definição da estrutura do relatório.
//---------------------------------------------------------------------------------
Static Function ReportDef()
                           
	Local cPicture := "@E 999,999,999.99"
	Local cPict1   := "@E 999.99"
	
	oReport := TReport():New("A743ImpA","Movimento financeiro",'',;
			   {|oReport| PrintReport(oReport)},"Este relatório irá imprimir o Movimento financeiro conforme posicionado.")
	
	oReport:cFontBody:= 'Consolas'
	oReport:nFontBody:= 7
	oReport:nLineHeight:= 30
	oReport:SetPortrait(.T.)  //Retrato - oReport:SetLandscape(.T.) //Paisagem
	
	oSecCab := TRSection():New( oReport , "Movimento financeiro", {"QRY"} )

    TRCell():New( oSecCab, "PBT_TIPO"   , "QRY", 'Tipo'             )
    TRCell():New( oSecCab, "PBT_PV"     , "QRY", 'Ponto de Venda'   )
    TRCell():New( oSecCab, "PBT_RV"     , "QRY", 'Resumo de Venda'  )
    TRCell():New( oSecCab, "PBT_DATA"   , "QRY", 'Data'             )
    TRCell():New( oSecCab, "PBT_NUMDOC" , "QRY", 'Ordem pagamento'  )
    TRCell():New( oSecCab, "PBT_VALOR"  , "QRY", 'Valor'            )
    TRCell():New( oSecCab, "PBT_BANDEI" , "QRY", 'Bandeira'         )
    TRCell():New( oSecCab, "PBT_TIPOTR" , "QRY", 'Transação'        )
    TRCell():New( oSecCab, "PBT_PARCEL" , "QRY", 'Parcela'          )
    
    oSecItem := TRSection():New( oReport , "Itens", {"QRY"} )

	TRCell():New( oSecItem, "PBT_TIPO"   , "QRY", 'Tipo'  , )
	TRCell():New( oSecItem, "PBS_PSITE"  , "QRY", 'Pedido SITE'  , )
	TRCell():New( oSecItem, "PBS_CARTAO" , "QRY", 'Num. Cartão'  , )
	TRCell():New( oSecItem, "PBS_NSU"    , "QRY", 'CV/NSU'       , )
	TRCell():New( oSecItem, "PBS_CODAUT" , "QRY", 'Nº autorizaçõ', )
	TRCell():New( oSecItem, "PBS_TID"    , "QRY", 'Num. TID'     , )
	TRCell():New( oSecItem, "PBS_VALOR"  , "QRY", 'Valor'        , cPicture)
    TRCell():New( oSecItem, "PBS_VLDESC" , "QRY", 'Vlr desconto' , cPicture)
    TRCell():New( oSecItem, "PBS_VALLIQ" , "QRY", 'Vlr liquido'  , cPicture)
    TRCell():New( oSecItem, "PBS_DTLCTO" , "QRY", 'Data lancto'  , )
    TRCell():New( oSecItem, "PBT_TIPORE" , "QRY", 'Tipo registro', )
    TRCell():New( oSecItem, "PBT_TPAJUS" , "QRY", 'Tipo ajuste'  , )
    TRCell():New( oSecItem, "PBT_DESCAJ" , "QRY", 'Descrição'    , )

    oReport:SetTotalInLine(.F.)
	
	//Aqui, farei uma quebra  por seção
	oSecCab:SetPageBreak(.F.)
	oSecCab:SetTotalInLine(.F.)
	oSecCab:SetTotalText(" ")

Return Nil

//---------------------------------------------------------------------------------
// Rotina | PrintReport    | Autor | Rafael Beghini     | Data | 12.12.2018
//---------------------------------------------------------------------------------
// Descr. | Definição da estrutura do relatório.
//---------------------------------------------------------------------------------
Static Function PrintReport(oReport)

	Local cSQL  := ''
    Local cNcm  := ''
    Local cCOD  := ''
    Local cBandeira	:= ''
    Local aCombo	:= {}
    
    Local bTipoTR   := {|| nPos := AScan( aCombo, {|x| Left(x,1) == PBT_TIPOTR} ), Iif( nPos > 0, SubStr(aCombo[nPos],3), '' ) }

    dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	IF dbSeek( 'PBT_TIPOTR' )   
		aCombo := StrToKarr( X3CBox(), ';' )
	EndIF
	
    cSQL += "SELECT PBT_FILIAL, PBT_TIPO, PBT_PVMAT, PBT_PV, PBT_RV, PBT_DATA, PBT_NUMDOC, PBT_VALOR, PBT_BANDEI, PBT_TIPOTR, PBT_PARCEL, " + CRLF
    cSQL += "       PBS_PSITE, PBS_CARTAO, PBS_NSU, PBS_CODAUT, PBS_TID, PBS_VALOR, PBS_VLDESC, PBS_VALLIQ, PBS_DTLCTO, " + CRLF
    cSQL += "       '' PBT_TIPORE, '' PBT_TPAJUS, '' PBT_DESCAJ " + CRLF
    cSQL += "FROM   " + RetSqlName("PBT") + " PBT " + CRLF
    cSQL += "       LEFT JOIN " + RetSqlName("PBS") + " PBS " + CRLF
    cSQL += "              ON PBS_FILIAL = PBT_FILIAL " + CRLF
    cSQL += "                 AND PBS_PVMAT = PBT_PVMAT " + CRLF
    cSQL += "                 AND PBS_PV = PBT_PV " + CRLF
    cSQL += "                 AND PBS_RV = PBT_RV " + CRLF
    cSQL += "                 AND PBS_NUMDOC = PBT_NUMDOC " + CRLF
    cSQL += "                 AND PBS.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "                 AND PBS_PARCEL = TO_NUMBER(SUBSTR(PBT_PARCEL, 1, 2), '99') " + CRLF
    cSQL += "WHERE  PBT.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "       AND PBT_FILIAL  = '" + xFilial('PBT') + "' " + CRLF
    cSQL += "       AND PBT_PVMAT 	= '" + (oBrowse:Alias())->PBT_PVMAT + "' " + CRLF
	cSQL += "       AND PBT_PV 		= '" + (oBrowse:Alias())->PBT_PV + "' " + CRLF
	cSQL += "       AND PBT_NUMDOC  = '" + (oBrowse:Alias())->PBT_NUMDOC + "' " + CRLF
    cSQL += "       AND PBT_TIPO = 'C' " + CRLF
    cSQL += "UNION " + CRLF
    cSQL += "SELECT PBT_FILIAL, PBT_TIPO, PBT_PVMAT, PBT_PV, PBT_RV, PBT_DATA, PBT_NUMDOC, PBT_VALOR, PBT_BANDEI, PBT_TIPOTR, PBT_PARCEL, " + CRLF
    cSQL += "       '' PBS_PSITE, PBT_CARTAO, PBT_NSU, PBT_CODAUT, '' PBS_TID, 0 PBS_VALOR, 0 PBS_VLDESC, PBT_VALOR PBS_VALLIQ, " + CRLF
    cSQL += "       PBT_DATARV, PBT_TIPORE, PBT_TPAJUS, PBT_DESCAJ " + CRLF
    cSQL += "FROM   " + RetSqlName("PBT") + " PBT " + CRLF
    cSQL += "WHERE  PBT.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "       AND PBT_FILIAL  = '" + xFilial('PBT') + "' " + CRLF
    cSQL += "       AND PBT_PVMAT 	= '" + (oBrowse:Alias())->PBT_PVMAT + "' " + CRLF
	cSQL += "       AND PBT_PV 		= '" + (oBrowse:Alias())->PBT_PV + "' " + CRLF
	cSQL += "       AND PBT_NUMDOC  = '" + (oBrowse:Alias())->PBT_NUMDOC + "' " + CRLF
    cSQL += "       AND PBT_TIPO = 'D' " + CRLF
    cSQL += "ORDER  BY PBT_TIPO " + CRLF

    cSQL := ChangeQuery(cSQL)
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf
	
	TcQuery cSQL New Alias "QRY"
	
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
					
		cNcm    := QRY->( PBT_FILIAL + PBT_PVMAT + PBT_PV + PBT_RV + PBT_NUMDOC )
		
        IncProc( "Imprimindo movimento financeiro " + QRY->PBT_NUMDOC )
		
		PBU->( dbSetOrder(1) )
		PBU->( dbSeek( xFilial('PBU') + QRY->PBT_BANDEI ) )
		cBandeira := rTrim( PBU->PBU_DESC )
		
		nPos := AScan( aCombo, {|x| Left(x,1) == QRY->PBT_TIPOTR } )
	
		//imprimo a primeira seção				
		oSecCab:Cell("PBT_PV"):SetValue(QRY->PBT_PV)
		oSecCab:Cell("PBT_RV"):SetValue(QRY->PBT_RV)
		oSecCab:Cell("PBT_DATA"):SetValue(StoD(QRY->PBT_DATA))
		oSecCab:Cell("PBT_NUMDOC"):SetValue(QRY->PBT_NUMDOC)
		oSecCab:Cell("PBT_VALOR"):SetValue(QRY->PBT_VALOR)
		oSecCab:Cell("PBT_BANDEI"):SetValue(cBandeira)
        oSecCab:Cell("PBT_TIPOTR"):SetValue( Iif( nPos > 0, SubStr(aCombo[nPos],3),  QRY->PBT_TIPOTR) )
        oSecCab:Cell("PBT_PARCEL"):SetValue(QRY->PBT_PARCEL)
		oSecCab:Printline()
		
		//inicializo a segunda seção
		oSecItem:init()
		
		While QRY->( PBT_FILIAL + PBT_PVMAT + PBT_PV + PBT_RV + PBT_NUMDOC ) == cNcm
			oReport:IncMeter()		
		
			//IncProc("Imprimindo produto "+alltrim(TRBNCM->B1_COD))
			oSecItem:Cell("PBT_TIPO"):SetValue(QRY->PBT_TIPO)
			oSecItem:Cell("PBS_PSITE"):SetValue(QRY->PBS_PSITE)
			oSecItem:Cell("PBS_CARTAO"):SetValue(QRY->PBS_CARTAO)
			oSecItem:Cell("PBS_NSU"):SetValue(QRY->PBS_NSU)
			oSecItem:Cell("PBS_CODAUT"):SetValue(QRY->PBS_CODAUT)
			oSecItem:Cell("PBS_TID"):SetValue(QRY->PBS_TID)
			oSecItem:Cell("PBS_VALOR"):SetValue(QRY->PBS_VALOR)
            oSecItem:Cell("PBS_VLDESC"):SetValue(QRY->PBS_VLDESC)
			oSecItem:Cell("PBS_VALLIQ"):SetValue(QRY->PBS_VALLIQ)
			oSecItem:Cell("PBS_DTLCTO"):SetValue(StoD(QRY->PBS_DTLCTO))
            oSecItem:Cell("PBT_TIPORE"):SetValue(QRY->PBT_TIPORE)
            oSecItem:Cell("PBT_TPAJUS"):SetValue(QRY->PBT_TPAJUS)
            oSecItem:Cell("PBT_DESCAJ"):SetValue(QRY->PBT_DESCAJ)
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
// Rotina | A743ImpS    | Autor | Rafael Beghini     | Data | 18.12.2018
//---------------------------------------------------------------------------------
// Descr. | Impressão do Movimento financeiro sintético
//---------------------------------------------------------------------------------
Static Function A743ImpS()
    Local aPAR       := {}
    Private oReport  := Nil
	Private oSecCab	 := Nil
    Private oBreak   := Nil
    Private aRET     := {}

    aAdd(aPAR,{1,"Data de" ,dDataBase,"","","","",20,.F.})
    aAdd(aPAR,{1,"Data ate",dDataBase,"","","","",20,.T.})

    IF ParamBox(aPAR,"Parâmetros",@aRET)
	    ReportSinte()
	    oReport	:PrintDialog()
    EndIF
Return NIL

//---------------------------------------------------------------------------------
// Rotina | ReportSinte    | Autor | Rafael Beghini     | Data | 18.12.2018
//---------------------------------------------------------------------------------
// Descr. | Definição da estrutura do relatório.
//---------------------------------------------------------------------------------
Static Function ReportSinte()
                           
	Local cPicture := "@E 999,999,999.99"
	
	oReport := TReport():New("A743ImpS","Movimento financeiro",'',;
			   {|oReport| PrintSinte(oReport)},"Este relatório irá imprimir o Movimento financeiro SINTÉTICO conforme parâmetros.")
	
	oReport:cFontBody:= 'Consolas'
	oReport:nFontBody:= 7
	oReport:nLineHeight:= 30
	oReport:SetPortrait(.T.)  //Retrato - oReport:SetLandscape(.T.) //Paisagem
	
	oSecCab := TRSection():New( oReport , "Movimento financeiro", {"QRY"} )

    TRCell():New( oSecCab, "TIPO"       , "QRY", 'Tipo'             )
    TRCell():New( oSecCab, "PBT_PV"     , "QRY", 'Ponto de Venda'   )
    TRCell():New( oSecCab, "PBT_RV"     , "QRY", 'Resumo de Venda'  )
    TRCell():New( oSecCab, "PBT_DATA"   , "QRY", 'Data'             )
    TRCell():New( oSecCab, "PBT_NUMDOC" , "QRY", 'Num documento'    )
    TRCell():New( oSecCab, "PBT_VALOR"  , "QRY", 'Valor' , cPicture )
    TRCell():New( oSecCab, "PBT_BANDEI" , "QRY", 'Bandeira'         )
    TRCell():New( oSecCab, "PBT_TIPOTR" , "QRY", 'Transação'        )
    TRCell():New( oSecCab, "PBT_PARCEL" , "QRY", 'Parcela'          )
    TRCell():New( oSecCab, "PBT_FILE"   , "QRY", 'Arquivo importado')
    
    oBreak:=TRBreak():New( oSecCab,oSecCab:Cell("TIPO"),      ,.F.         ,"Tipo",          )
	
	TRFunction():New(oSecCab:Cell("PBT_VALOR"),/*cId*/,"SUM"       ,oBreak    ,/*cTitle*/,cPicture,/*uFormula*/,.T.            ,.F.           ,.F.         ,oSecCab)

    oReport:SetTotalInLine(.F.)
	
	//Aqui, farei uma quebra  por seção
	oSecCab:SetPageBreak(.F.)
	oSecCab:SetTotalInLine(.F.)
	oSecCab:SetTotalText("Total...")

Return Nil

//---------------------------------------------------------------------------------
// Rotina | PrintSinte    | Autor | Rafael Beghini     | Data | 18.12.2018
//---------------------------------------------------------------------------------
// Descr. | Definição da estrutura do relatório SINTÉTICO
//---------------------------------------------------------------------------------
Static Function PrintSinte(oReport)

	Local cSQL  := ''
    Local cNcm  := ''
    Local cCOD  := ''
    Local cBandeira	:= ''
    Local aCombo	:= {}
    
    Local bTipoTR   := {|| nPos := AScan( aCombo, {|x| Left(x,1) == PBT_TIPOTR} ), Iif( nPos > 0, SubStr(aCombo[nPos],3), '' ) }

    dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	IF dbSeek( 'PBT_TIPOTR' )   
		aCombo := StrToKarr( X3CBox(), ';' )
	EndIF
	
    cSQL += "SELECT * " + CRLF
    cSQL += "FROM   (SELECT 'C' AS TIPO, " + CRLF
    cSQL += "               PBT_FILIAL, " + CRLF
    cSQL += "               PBT_PVMAT, " + CRLF
    cSQL += "               PBT_PV, " + CRLF
    cSQL += "               PBT_RV, " + CRLF
    cSQL += "               PBT_DATA, " + CRLF
    cSQL += "               PBT_NUMDOC, " + CRLF
    cSQL += "               PBT_VALOR, " + CRLF
    cSQL += "               PBT_DATARV, " + CRLF
    cSQL += "               PBT_BANDEI, " + CRLF
    cSQL += "               PBT_TIPOTR, " + CRLF
    cSQL += "               PBT_PARCEL, " + CRLF
    cSQL += "               PBT_FILE " + CRLF
    cSQL += "        FROM   " + RetSqlName("PBT") + " PBT " + CRLF
    cSQL += "        WHERE  PBT.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "               AND PBT_FILIAL = '" + xFilial('PBT') + "' " + CRLF
    cSQL += "               AND PBT_DATA >= '" + dToS( aRET[1] ) + "' " + CRLF
    cSQL += "               AND PBT_DATA <= '" + dToS( aRET[2] ) + "' " + CRLF
    cSQL += "               AND PBT_TIPO = 'C' " + CRLF
    cSQL += "        UNION " + CRLF
    cSQL += "        SELECT 'D' AS TIPO, " + CRLF
    cSQL += "               PBT_FILIAL, " + CRLF
    cSQL += "               PBT_PVMAT, " + CRLF
    cSQL += "               PBT_PV, " + CRLF
    cSQL += "               PBT_RV, " + CRLF
    cSQL += "               PBT_DATA, " + CRLF
    cSQL += "               PBT_NUMDOC, " + CRLF
    cSQL += "               Sum(PBT_VALOR), " + CRLF
    cSQL += "               PBT_DATARV, " + CRLF
    cSQL += "               PBT_BANDEI, " + CRLF
    cSQL += "               PBT_TIPOTR, " + CRLF
    cSQL += "               PBT_PARCEL, " + CRLF
    cSQL += "               PBT_FILE " + CRLF
    cSQL += "        FROM   " + RetSqlName("PBT") + " PBT " + CRLF
    cSQL += "        WHERE  PBT.D_E_L_E_T_ = ' ' " + CRLF
    cSQL += "               AND PBT_FILIAL = '" + xFilial('PBT') + "' " + CRLF
    cSQL += "               AND PBT_DATA >= '" + dToS( aRET[1] ) + "' " + CRLF
    cSQL += "               AND PBT_DATA <= '" + dToS( aRET[2] ) + "' " + CRLF
    cSQL += "               AND PBT_TIPO = 'D' " + CRLF
    cSQL += "        GROUP  BY PBT_FILIAL, " + CRLF
    cSQL += "                  PBT_PVMAT, " + CRLF
    cSQL += "                  PBT_PV, " + CRLF
    cSQL += "                  PBT_RV, " + CRLF
    cSQL += "                  PBT_DATA, " + CRLF
    cSQL += "                  PBT_NUMDOC, " + CRLF
    cSQL += "                  PBT_DATARV, " + CRLF
    cSQL += "                  PBT_BANDEI, " + CRLF
    cSQL += "                  PBT_TIPOTR, " + CRLF
    cSQL += "                  PBT_PARCEL, " + CRLF
    cSQL += "                  PBT_FILE) " + CRLF
    cSQL += "ORDER  BY PBT_FILIAL, " + CRLF
    cSQL += "          PBT_PVMAT, " + CRLF
    cSQL += "          PBT_PV, " + CRLF
    cSQL += "          TIPO, " + CRLF
    cSQL += "          PBT_RV, " + CRLF
    cSQL += "          PBT_DATA, " + CRLF
    cSQL += "          PBT_NUMDOC " + CRLF

    cSQL := ChangeQuery(cSQL)
	
	If Select("QRY") > 0
		Dbselectarea("QRY")
		QRY->(DbClosearea())
	EndIf
	
	TcQuery cSQL New Alias "QRY"
	
	oSecCab:BeginQuery()
	oSecCab:EndQuery({{"QRY"},cSQL})    
	oSecCab:Print()

Return Nil