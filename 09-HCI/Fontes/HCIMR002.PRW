#Include "Protheus.CH"
#Include "TopConn.CH"
#Include "RwMake.CH"
#INCLUDE "FIVEWIN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} HCIMR002
Rotina para impress„o do relatÛrio de CotaÁıes.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		24/08/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
User Function HCIMR002()

	Local _cPerg		:= "HCIMR02"
	Local aOrd    		:= {}
	Local _cDestino		:= "" 
	
	Private cpTamanho	:= "G"
	Private cpTitulo	:= "Impress„o de RelatÛrio - Analise de CotaÁıes"
	Private cpDesc1		:= "Este programa destina-se a impress„o de RelatÛrio de analise de cotaÁıes."
	Private cpDesc2		:= ""
	Private cpDesc3		:= ""
	Private cpWnRel		:= "HCIMR002"
	Private aReturn		:= {"Zebrado",1,"Administracao",2,2,1,"",1}
	Private nLastKey	:= 00
	Private lEnd		:= .F.
	
	If SC8->(FieldPos("C8_XCOST")) != 0 .And. SC8->(FieldPos("C8_XOBSCOT")) != 0
		AjustaSX1(_cPerg)
		If Pergunte(_cPerg,.T.)
			If MV_PAR06 == 1
				_cDestino	:= cGetFile(, "Selecione o Destino do arquivo",0,"",.F.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)
				If !Empty(_cDestino)
					Processa({||_fImpExc(_cDestino)},cpTitulo,,.T.)
				Endif
			Else
				Processa({||_fImpSpo()},cpTitulo,,.T.)
			EndIf 
		EndIf
	EndIf

Return()


//-------------------------------------------------------------------
/*/{Protheus.doc} _fImpExc
FunÁ„o para realizar a impress„o via Planilha em Excel.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		22/07/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fImpExc(_cDestino)

	Local _cNumCot		:= ""
	Local _nHandle		:= 0
	Local _cArq			:= ""
	Local _cXml			:= ""
		
	Private _aCotacao	:= {}
	Private _aAuxCot	:= {}
	Private _nTotI1		:= 0
	Private _nTotSI1	:= 0
	Private _nTotI2		:= 0
	Private _nTotSI2	:= 0
	Private _nTotI3		:= 0
	Private _nTotSI3	:= 0
	Private _aFornece	:= {}
	Private _aPrdFor	:= {}
	Private _cAliasTmp	:= GetNextAlias()
	Private _nArqOk		:= 0
	Private _nArqNOk	:= 0

	_fQryTmp(_cAliasTmp)
	
	ProcRegua(RecCount())
	
	(_cAliasTmp)->(dbGoTop())
	While (_cAliasTmp)->(!EOF())
		
		If _cNumCot <> (_cAliasTmp)->C8_NUM			
			_aFornece	:= _fGetFor((_cAliasTmp)->C8_NUM)
			_fQCXML((_cAliasTmp)->C8_NUM)			
		EndIf
		
		_cNumCot		:= (_cAliasTmp)->C8_NUM	
		
		(_cAliasTmp)->(dbSkip())

	EndDo
	
	For _nI	:= 1 To Len(_aAuxCot)	
		If _cIndice <> _aAuxCot[_nI,14]
			
			If nlLin > 0050
				_fRodPe(_NI,_cComprador,_cGerSup,_cDiretoria)
			EndIf
			         
			_nTotI1		:= _aAuxCot[_nI,10,1,5]
			_nTotSI1	:= _aAuxCot[_nI,10,1,5] - _aAuxCot[_nI,10,1,24]
			_nTotI2		:= _aAuxCot[_nI,10,2,5]
			_nTotSI2	:= _aAuxCot[_nI,10,2,5] - _aAuxCot[_nI,10,2,24]
			_nTotI3		:= _aAuxCot[_nI,10,3,5]
			_nTotSI3	:= _aAuxCot[_nI,10,3,5] - _aAuxCot[_nI,10,3,24]
			
			_cXml	:= '<?xml version="1.0"?>' + CRLF
			_cXml	+= '<?mso-application progid="Excel.Sheet"?>' + CRLF
			_cXml	+= '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF
			_cXml	+= ' xmlns:o="urn:schemas-microsoft-com:office:office"' + CRLF
			_cXml	+= ' xmlns:x="urn:schemas-microsoft-com:office:excel"' + CRLF
			_cXml	+= ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' + CRLF
			_cXml	+= ' xmlns:html="http://www.w3.org/TR/REC-html40">' + CRLF
			_cXml	+= ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' + CRLF
			_cXml	+= '  <Author>Bruna</Author>' + CRLF
			_cXml	+= '  <LastAuthor>Bruna</LastAuthor>' + CRLF
			_cXml	+= '  <Created>2015-07-21T12:48:39Z</Created>' + CRLF
			_cXml	+= '  <LastSaved>2015-07-22T12:04:26Z</LastSaved>' + CRLF
			_cXml	+= '  <Version>12.00</Version>' + CRLF
			_cXml	+= ' </DocumentProperties>' + CRLF
			_cXml	+= ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
			_cXml	+= '  <WindowHeight>3915</WindowHeight>' + CRLF
			_cXml	+= '  <WindowWidth>19155</WindowWidth>' + CRLF
			_cXml	+= '  <WindowTopX>360</WindowTopX>' + CRLF
			_cXml	+= '  <WindowTopY>30</WindowTopY>' + CRLF
			_cXml	+= '  <ProtectStructure>False</ProtectStructure>' + CRLF
			_cXml	+= '  <ProtectWindows>False</ProtectWindows>' + CRLF
			_cXml	+= ' </ExcelWorkbook>' + CRLF
			_cXml	+= ' <Styles>' + CRLF
			_cXml	+= '  <Style ss:ID="Default" ss:Name="Normal">' + CRLF
			_cXml	+= '   <Alignment ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders/>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' + CRLF
			_cXml	+= '   <Interior/>' + CRLF
			_cXml	+= '   <NumberFormat/>' + CRLF
			_cXml	+= '   <Protection/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s16" ss:Name="Separador de milhares">' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63382464">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63382484">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' + CRLF
			_cXml	+= '    ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63382504">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63382524">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63382544">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63382564">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63382584">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63382604">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86771904">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86771924" ss:Parent="s16">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86771944">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86771964">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Left" ss:Vertical="Top"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86771984">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' + CRLF
			_cXml	+= '    ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772544">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772564">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772584">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772604">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772624">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772644">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772664">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772684">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772704">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772724">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772744">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772764">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772784">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772804">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772824">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772844">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63382144">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381824">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381844">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381864">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381884" ss:Parent="s16">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"' + CRLF
			_cXml	+= '    ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381904">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381924">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381944">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381964" ss:Parent="s16">' + CRLF
			_cXml	+= '   <Alignment ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"' + CRLF
			_cXml	+= '    ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381504">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381524">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381544">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381564" ss:Parent="s16">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"' + CRLF
			_cXml	+= '    ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381584">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381604">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381624">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381644">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381664">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m63381684">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"' + CRLF
			_cXml	+= '    ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86773184">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86773204">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86773224">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86773244">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86773264">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772864">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"' + CRLF
			_cXml	+= '    ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772884">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772904">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772924">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772944">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772964">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86772984">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86773004">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="m86773024">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s17">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s18">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s19">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' + CRLF
			_cXml	+= '    ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s20">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' + CRLF
			_cXml	+= '    ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s21">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s22">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s23">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s24">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s25">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s26">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s27" ss:Parent="s16">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s28">' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s29">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s30">' + CRLF
			_cXml	+= '   <Borders/>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s31">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s32">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="0%"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s33">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s34">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s35">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s36">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s37" ss:Parent="s16">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s38" ss:Parent="s16">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s39">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s40">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s41">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s42">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s43">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s44">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s45">' + CRLF
			_cXml	+= '   <Borders/>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s46">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s47">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s48">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s49">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' + CRLF
			_cXml	+= '    ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s130">' + CRLF
			_cXml	+= '   <Alignment ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="0%"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s133" ss:Parent="s16">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s134">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s135">' + CRLF
			_cXml	+= '   <Borders/>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="Short Date"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s136">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="Short Date"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s140" ss:Parent="s16">' + CRLF
			_cXml	+= '   <Borders/>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s141">' + CRLF
			_cXml	+= '   <Borders/>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="0%"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s142" ss:Parent="s16">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s143">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s144">' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s147">' + CRLF
			_cXml	+= '   <Borders/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s148">' + CRLF
			_cXml	+= '   <Alignment ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders/>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' + CRLF
			_cXml	+= '    ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s149">' + CRLF
			_cXml	+= '   <Alignment ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s150">' + CRLF
			_cXml	+= '   <Alignment ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="0%"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s151">' + CRLF
			_cXml	+= '   <Alignment ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="Percent"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s152">' + CRLF
			_cXml	+= '   <Alignment ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="0%"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s153">' + CRLF
			_cXml	+= '   <Alignment ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s154" ss:Parent="s16">' + CRLF
			_cXml	+= '   <Alignment ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s155">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="0%"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s156">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>' + CRLF
			_cXml	+= '   <NumberFormat ss:Format="Percent"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= '  <Style ss:ID="s213">' + CRLF
			_cXml	+= '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>' + CRLF
			_cXml	+= '   <Borders>' + CRLF
			_cXml	+= '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' + CRLF
			_cXml	+= '   </Borders>' + CRLF
			_cXml	+= '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>' + CRLF
			_cXml	+= '  </Style>' + CRLF
			_cXml	+= ' </Styles>' + CRLF
			_cXml	+= ' <Worksheet ss:Name="Plan1">' + CRLF
			_cXml	+= '  <Table ss:ExpandedColumnCount="17" ss:ExpandedRowCount="43" x:FullColumns="1"' + CRLF
			_cXml	+= '   x:FullRows="1" ss:DefaultRowHeight="15">' + CRLF
			_cXml	+= '   <Column ss:Index="3" ss:Width="27"/>' + CRLF
			_cXml	+= '   <Column ss:AutoFitWidth="0" ss:Width="78"/>' + CRLF
			_cXml	+= '   <Column ss:Width="206.25"/>' + CRLF
			_cXml	+= '   <Column ss:Width="27.75"/>' + CRLF
			_cXml	+= '   <Column ss:Width="21.75"/>' + CRLF
			_cXml	+= '   <Column ss:Width="51.75"/>' + CRLF
			_cXml	+= '   <Column ss:Width="61.5"/>' + CRLF
			_cXml	+= '   <Column ss:Width="96.75"/>' + CRLF
			_cXml	+= '   <Column ss:Width="98.25"/>' + CRLF
			_cXml	+= '   <Column ss:Width="61.5"/>' + CRLF
			_cXml	+= '   <Column ss:Width="96.75"/>' + CRLF
			_cXml	+= '   <Column ss:Width="98.25"/>' + CRLF
			_cXml	+= '   <Column ss:Width="61.5"/>' + CRLF
			_cXml	+= '   <Column ss:Width="96.75"/>' + CRLF
			_cXml	+= '   <Column ss:Width="98.25"/>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75"/>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75">' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:StyleID="s22"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s23"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="3" ss:MergeDown="2" ss:StyleID="m86772864"><Data' + CRLF
			_cXml	+= '      ss:Type="String">Analise das Cota√ß√µes</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s25"><Data ss:Type="String">Cliente</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s25"><Data ss:Type="String">AKER</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s26"><Data ss:Type="String">R$ Or√ßado</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s27"><Data ss:Type="Number">34485</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s140"/>' + CRLF
			_cXml	+= '    <Cell ss:Index="15" ss:StyleID="s28"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s28"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s28"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75">' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:StyleID="s29"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s30"/>' + CRLF
			_cXml	+= '    <Cell ss:Index="9" ss:StyleID="s31"><Data ss:Type="String">Emiss√£o</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s136"><Data ss:Type="DateTime">2015-07-08T00:00:00.000</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s26"><Data ss:Type="String">Saving</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s32"><Data ss:Type="Number">0.25</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s141"/>' + CRLF
			_cXml	+= '    <Cell ss:Index="15" ss:StyleID="s28"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s28"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s28"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75">' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:StyleID="s22"><Data ss:Type="String">N¬∫</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s24"><Data ss:Type="Number">2392</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:Index="9" ss:StyleID="s30"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s30"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s135"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s28"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s28"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s28"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s28"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s28"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s28"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75">' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeDown="4" ss:StyleID="m86773184"><Data' + CRLF
			_cXml	+= '      ss:Type="String">Item</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeDown="4" ss:StyleID="m63381584"><Data ss:Type="String">Cod. Carmar</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeDown="4" ss:StyleID="m86773004"><Data ss:Type="String">Descri√ß√£o</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeDown="4" ss:StyleID="m86772984"><Data ss:Type="String">Qtde</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeDown="4" ss:StyleID="m86773024"><Data ss:Type="String">UM</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeDown="4" ss:StyleID="m86772964"><Data ss:Type="String">PN</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="8" ss:StyleID="m86772944"><Data ss:Type="String">EMPRESAS PROPONENTES</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75">' + CRLF
			_cXml	+= '    <Cell ss:Index="9" ss:MergeAcross="2" ss:StyleID="m86772884"><Data' + CRLF
			_cXml	+= '      ss:Type="String">Fornecedor: Pires do R</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772904"><Data ss:Type="String">Fornecedor: OXFER</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772924"><Data ss:Type="String">Fornecedor: A√áOBRIL</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="9" ss:StyleID="s45"><Data ss:Type="String">Contato:</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s45"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s34"><Data ss:Type="String">Carol</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s33"><Data ss:Type="String">Contato:</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s45"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s34"><Data ss:Type="String">Marcos</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s33"><Data ss:Type="String">Contato:</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s45"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s34"><Data ss:Type="String">Sueli</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75">' + CRLF
			_cXml	+= '    <Cell ss:Index="9" ss:StyleID="s45"><Data ss:Type="String">Telefone</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s45"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s34"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s33"><Data ss:Type="String">Telefone</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s45"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s34"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s33"><Data ss:Type="String">Telefone</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s45"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s34"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75">' + CRLF
			_cXml	+= '    <Cell ss:Index="9" ss:StyleID="s46"><Data ss:Type="String">R$ UNITARIO</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s134"><Data ss:Type="String">R$ TOTAL S/ Imposto</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s36"><Data ss:Type="String">R$ TOTAL C/ Imposto</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s35"><Data ss:Type="String">R$ UNITARIO</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s134"><Data ss:Type="String">R$ TOTAL S/ Imposto</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s36"><Data ss:Type="String">R$ TOTAL C/ Imposto</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s35"><Data ss:Type="String">R$ UNITARIO</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s134"><Data ss:Type="String">R$ TOTAL S/ Imposto</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s36"><Data ss:Type="String">R$ TOTAL C/ Imposto</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:StyleID="s47"><Data ss:Type="Number">1</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s48"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s48"><Data ss:Type="String">ANEL 0860 X 0730 X 2.1/2 ASTM A572 GR. 50</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s48"><Data ss:Type="Number">19</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s48"><Data ss:Type="String">P√á</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s48"><Data ss:Type="Number">10152779</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s37"><Data ss:Type="Number">2000</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s133"><Data ss:Type="Number">27645</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s37" ss:Formula="=RC[-2]*RC[-5]"><Data ss:Type="Number">38000</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s37"><Data ss:Type="Number">2625</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s37"><Data ss:Type="Number">36284.06</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s37" ss:Formula="=RC[-2]*RC[-8]"><Data ss:Type="Number">49875</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s37"><Data ss:Type="Number">2014</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s142"><Data ss:Type="Number">27838.52</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s38" ss:Formula="=RC[-2]*RC[-11]"><Data ss:Type="Number">38266</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:StyleID="s39"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s143"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s41"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:StyleID="s39"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s143"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s41"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:StyleID="s39"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s143"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s41"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:StyleID="s39"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s40"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s143"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s41"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75">' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:StyleID="s42"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s43"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s43"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s43"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s43"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s43"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s43"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s43"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s43"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s43"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s43"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s43"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s43"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s144"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s44"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75">' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m86773204"><Data' + CRLF
			_cXml	+= '      ss:Type="String">TOTAL COM IMPOSTOS</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86773224" ss:Formula="=R[-6]C[2]"><Data' + CRLF
			_cXml	+= '      ss:Type="Number">38000</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86773244" ss:Formula="=R[-6]C[2]"><Data' + CRLF
			_cXml	+= '      ss:Type="Number">49875</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86773264" ss:Formula="=R[-6]C[2]"><Data' + CRLF
			_cXml	+= '      ss:Type="Number">38266</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m63381604"><Data' + CRLF
			_cXml	+= '      ss:Type="String">REGIME DE TRIBUTA√á√ÉO - IMPOSTOS</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m63381504"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m63381824"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m63381904"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m63381624"><Data' + CRLF
			_cXml	+= '      ss:Type="String">SIMPLES NACIONAL</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m63381524"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m63381844"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m63381924"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m63381644"><Data' + CRLF
			_cXml	+= '      ss:Type="String">LUCRO REAL/LUCRO PRESUMIDO</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m63381544"><Data ss:Type="String">X</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m63381864"><Data ss:Type="String">X</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m63381944"><Data ss:Type="String">X</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m63381664"><Data' + CRLF
			_cXml	+= '      ss:Type="String">ICMS</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s150"><Data ss:Type="Number">0.18</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s155"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=18%"><Data ss:Type="Number">0.18</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s150"><Data ss:Type="Number">0.18</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s155"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=18%"><Data ss:Type="Number">0.18</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s150"><Data ss:Type="Number">0.18</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s155"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=18%"><Data ss:Type="Number">0.18</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m63382524"><Data' + CRLF
			_cXml	+= '      ss:Type="String">IPI</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s150"><Data ss:Type="Number">0.1</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s155"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=10%"><Data ss:Type="Number">0.1</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s150"><Data ss:Type="Number">0.1</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s155"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=10%"><Data ss:Type="Number">0.1</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s150"><Data ss:Type="Number">0.1</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s155"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=10%"><Data ss:Type="Number">0.1</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m63382544"><Data' + CRLF
			_cXml	+= '      ss:Type="String">PIS</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s151"><Data ss:Type="Number">1.6500000000000001E-2</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s156"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=1.65%"><Data ss:Type="Number">1.6500000000000001E-2</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s151"><Data ss:Type="Number">1.6500000000000001E-2</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s156"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=1.65%"><Data ss:Type="Number">1.6500000000000001E-2</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s151"><Data ss:Type="Number">1.6500000000000001E-2</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s156"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=1.65%"><Data ss:Type="Number">1.6500000000000001E-2</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m63382564"><Data' + CRLF
			_cXml	+= '      ss:Type="String">COFINS</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s151"><Data ss:Type="Number">7.5999999999999998E-2</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s156"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=7.6%"><Data ss:Type="Number">7.5999999999999998E-2</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s151"><Data ss:Type="Number">7.5999999999999998E-2</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s156"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=7.6%"><Data ss:Type="Number">7.5999999999999998E-2</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s151"><Data ss:Type="Number">7.5999999999999998E-2</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s156"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=7.6%"><Data ss:Type="Number">7.5999999999999998E-2</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m63382584"><Data' + CRLF
			_cXml	+= '      ss:Type="String">ISS</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s150"><Data ss:Type="Number">0.05</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s155"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=5%"><Data ss:Type="Number">0.05</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s150"><Data ss:Type="Number">0.05</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s155"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=5%"><Data ss:Type="Number">0.05</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s150"><Data ss:Type="Number">0.05</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s155"><Data ss:Type="String">=</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s154" ss:Formula="=5%"><Data ss:Type="Number">0.05</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75">' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m63382604"><Data' + CRLF
			_cXml	+= '      ss:Type="String">ICMS ST</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s152"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s130"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s153"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s152"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s130"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s153"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s130"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s130"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s153"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Height="19.5">' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m63381684"><Data' + CRLF
			_cXml	+= '      ss:Type="String">TOTAL</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m63381564"><Data ss:Type="Number">27645</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m63381884"><Data ss:Type="Number">36284.06</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m63381964"><Data ss:Type="Number">27838.52</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m86772544"><Data' + CRLF
			_cXml	+= '      ss:Type="String">CONDI√á√ïES COMERCIAIS:</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772744"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772644"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772844"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="1" ss:StyleID="s213"><Data ss:Type="String">N√öMERO DA PROPOSTA</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="3" ss:StyleID="m86772564"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772764"><Data ss:Type="String">CIF</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772664"><Data ss:Type="String">CIF</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86771904"><Data ss:Type="String">FOB</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="1" ss:StyleID="s213"><Data ss:Type="String">PRAZO DO CONTRATO</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="3" ss:StyleID="m86772584"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772784"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772684"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86771924"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="1" ss:StyleID="s213"><Data ss:Type="String">PRAZO DE ENTREGA</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="3" ss:StyleID="m86772604"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772804"><Data ss:Type="String">5 dias</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772704"><Data ss:Type="String">5 dias</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86771944"><Data ss:Type="String">5 dias</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75">' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="1" ss:StyleID="s213"><Data ss:Type="String">CONDI√á√ÉO DE PGTO</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="3" ss:StyleID="m63382144"/>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772824"><Data ss:Type="String">45/60DDL</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772724"><Data ss:Type="String">45/60DDL</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="2" ss:StyleID="m86772624"><Data ss:Type="String">45/60DDL</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="14" ss:MergeDown="4" ss:StyleID="m86771964"><Data' + CRLF
			_cXml	+= '      ss:Type="String">OBSERVA√á√ïES:</Data></Cell>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Index="36" ss:Height="15.75"/>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m86771984"><Data' + CRLF
			_cXml	+= '      ss:Type="String">Comprador</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="4" ss:StyleID="m63382484"><Data ss:Type="String">Comprador</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s19"><Data ss:Type="String">Diretoria</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s49"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s49"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s20"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Height="15.75">' + CRLF
			_cXml	+= '    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m63382464"><Data' + CRLF
			_cXml	+= '      ss:Type="String">Eus√©bio Gomes</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:MergeAcross="4" ss:StyleID="m63382504"><Data ss:Type="String">Alexandre Fernandes</Data></Cell>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s17"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s18"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s18"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s21"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row ss:Index="40">' + CRLF
			_cXml	+= '    <Cell ss:Index="6" ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="6" ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s148"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="6" ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s149"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s149"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '   <Row>' + CRLF
			_cXml	+= '    <Cell ss:Index="6" ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '    <Cell ss:StyleID="s147"/>' + CRLF
			_cXml	+= '   </Row>' + CRLF
			_cXml	+= '  </Table>' + CRLF
			_cXml	+= '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
			_cXml	+= '   <PageSetup>' + CRLF
			_cXml	+= '    <Header x:Margin="0.31496062000000002"/>' + CRLF
			_cXml	+= '    <Footer x:Margin="0.31496062000000002"/>' + CRLF
			_cXml	+= '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' + CRLF
			_cXml	+= '     x:Right="0.511811024" x:Top="0.78740157499999996"/>' + CRLF
			_cXml	+= '   </PageSetup>' + CRLF
			_cXml	+= '   <Print>' + CRLF
			_cXml	+= '    <ValidPrinterInfo/>' + CRLF
			_cXml	+= '    <PaperSizeIndex>9</PaperSizeIndex>' + CRLF
			_cXml	+= '    <HorizontalResolution>-3</HorizontalResolution>' + CRLF
			_cXml	+= '    <VerticalResolution>-3</VerticalResolution>' + CRLF
			_cXml	+= '   </Print>' + CRLF
			_cXml	+= '   <Zoom>80</Zoom>' + CRLF
			_cXml	+= '   <Selected/>' + CRLF
			_cXml	+= '   <DoNotDisplayGridlines/>' + CRLF
			_cXml	+= '   <LeftColumnVisible>1</LeftColumnVisible>' + CRLF
			_cXml	+= '   <Panes>' + CRLF
			_cXml	+= '    <Pane>' + CRLF
			_cXml	+= '     <Number>3</Number>' + CRLF
			_cXml	+= '     <ActiveRow>40</ActiveRow>' + CRLF
			_cXml	+= '     <ActiveCol>15</ActiveCol>' + CRLF
			_cXml	+= '    </Pane>' + CRLF
			_cXml	+= '   </Panes>' + CRLF
			_cXml	+= '   <ProtectObjects>False</ProtectObjects>' + CRLF
			_cXml	+= '   <ProtectScenarios>False</ProtectScenarios>' + CRLF
			_cXml	+= '  </WorksheetOptions>' + CRLF
			_cXml	+= ' </Worksheet>' + CRLF
			_cXml	+= ' <Worksheet ss:Name="Plan2">' + CRLF
			_cXml	+= '  <Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="1" x:FullColumns="1"' + CRLF
			_cXml	+= '   x:FullRows="1" ss:DefaultRowHeight="15">' + CRLF
			_cXml	+= '  </Table>' + CRLF
			_cXml	+= '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
			_cXml	+= '   <PageSetup>' + CRLF
			_cXml	+= '    <Header x:Margin="0.31496062000000002"/>' + CRLF
			_cXml	+= '    <Footer x:Margin="0.31496062000000002"/>' + CRLF
			_cXml	+= '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' + CRLF
			_cXml	+= '     x:Right="0.511811024" x:Top="0.78740157499999996"/>' + CRLF
			_cXml	+= '   </PageSetup>' + CRLF
			_cXml	+= '   <ProtectObjects>False</ProtectObjects>' + CRLF
			_cXml	+= '   <ProtectScenarios>False</ProtectScenarios>' + CRLF
			_cXml	+= '  </WorksheetOptions>' + CRLF
			_cXml	+= ' </Worksheet>' + CRLF
			_cXml	+= ' <Worksheet ss:Name="Plan3">' + CRLF
			_cXml	+= '  <Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="1" x:FullColumns="1"' + CRLF
			_cXml	+= '   x:FullRows="1" ss:DefaultRowHeight="15">' + CRLF
			_cXml	+= '  </Table>' + CRLF
			_cXml	+= '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + CRLF
			_cXml	+= '   <PageSetup>' + CRLF
			_cXml	+= '    <Header x:Margin="0.31496062000000002"/>' + CRLF
			_cXml	+= '    <Footer x:Margin="0.31496062000000002"/>' + CRLF
			_cXml	+= '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' + CRLF
			_cXml	+= '     x:Right="0.511811024" x:Top="0.78740157499999996"/>' + CRLF
			_cXml	+= '   </PageSetup>' + CRLF
			_cXml	+= '   <ProtectObjects>False</ProtectObjects>' + CRLF
			_cXml	+= '   <ProtectScenarios>False</ProtectScenarios>' + CRLF
			_cXml	+= '  </WorksheetOptions>' + CRLF
			_cXml	+= ' </Worksheet>' + CRLF
			_cXml	+= '</Workbook>' + CRLF
			If _fCriaArq(_cNumOP,_cXml,_cDestino,Iif(_cBenef=='S','Beneficiamento',Iif(_cRetCom=='C','ComercializaÁ„o',Iif(_cRetCom=='R','Retrabalho',''))))
				_nArqOk++
			Else
				_nArqNOk++
			EndIf
				
		Else
			
			_nTotI1		+= _aAuxCot[_nI,10,1,5]
			_nTotSI1	+= _aAuxCot[_nI,10,1,5] - _aAuxCot[_nI,10,1,24]
			_nTotI2		+= _aAuxCot[_nI,10,2,5]
			_nTotSI2	+= _aAuxCot[_nI,10,2,5] - _aAuxCot[_nI,10,2,24]
			_nTotI3		+= _aAuxCot[_nI,10,3,5]
			_nTotSI3	+= _aAuxCot[_nI,10,3,5] - _aAuxCot[_nI,10,3,24]
			
			
			
		EndIf
		
		_cIndice :=  _aAuxCot[_nI,14]
		
	Next _nI

	(_cAliasTmp)->(dbCloseArea())

	If _nArqOk > 0 .Or. _nArqNOk > 0
		Aviso("AtenÁ„o",OEMTOANSI("FinalizaÁ„o da rotina de impress„o da planilha de ordem de produÁ„o.") + CRLF +;
						"Pasta selecionada para gravaÁ„o: " +_cDestino + CRLF +;
						"Planilha(s) gerada(s) com sucesso: " + Alltrim(Str(_nArqOk)) + CRLF + " Planhilha(a) n„o gerada(s):" + Alltrim(Str(_nArqNOk)) +  ". "+ CRLF ,{"Ok"},3)
	EndIf

Return()

Static Function _fGetFor(_cNumCot)

	Local _aFornec		:= {}
	Local _cQuery		:= ""
	Local _cAliasFor	:= GetNextAlias()
	
	_cQuery := "SELECT DISTINCT C8_FORNECE, C8_LOJA "
	_cQuery += " FROM " + RetSqlName("SC8")
	_cQuery += " WHERE C8_FILIAL = '" + xFilial("SC8") + "' "
	_cQuery += " AND C8_NUM = '" + _cNumCot + "' "
	_cQuery += " AND D_E_L_E_T_ = ' '"
	TcQuery _cQuery New Alias (_cAliasFor)
	
	If (_cAliasFor)->(!EOF())
		While (_cAliasFor)->(!EOF())
			Aadd(_aFornec,(_cAliasFor)->C8_FORNECE+(_cAliasFor)->C8_LOJA)
			Aadd(_aPrdFor,{})
			(_cAliasFor)->(dbSkip())
		EndDo
	EndIf
	
	(_cAliasFor)->(dbCloseArea())

Return(_aFornec)

//-------------------------------------------------------------------
/*/{Protheus.doc} _fCriaArq
FunÁ„o para criar o arquivo XLS.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		22/07/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fCriaArq(_cNumOP,_cXml,_cDestino,_cAtribM)

	Local _cArq		:= "OP_" + _cNumOP + "_" + DtoS(Date()) + "_" + _cAtribM + "_" + StrTran(Time(),":") + ".XLS"
	Local _nHandle	:= 0
	Local _lOk		:= .F.
	
	_nHandle	:= FCreate(_cDestino+AllTRim(_cArq))												
	If _nHandle <= 0
		Aviso(OEMTOANSI("AtenÁ„o"),OEMTOANSI("N„o foi possÌvel criar o arquivo no diretÛrio especificado. Favor verificar as permissıes do usu·rio ou caracteres especiais no nome do funcion·rio!") + CRLF + "Nomenclatura do arquivo a ser gerado: "+ _cArq,{"Ok"},2)
		_nArqNOk++
	Else
		_lOk	:= .T.
		FWrite(_nHandle,_cXml)
		FClose(_nHandle)
	EndIf

Return(_lOk)

//-------------------------------------------------------------------
/*/{Protheus.doc} _fQryCot
FunÁ„o para filtro dos recursos da CotaÁ„o conforme preenchimento dos par‚metros.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		22/07/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fQCXML(_cNumCot)

	Local _cAliasCot 	:= GetNextAlias()
	Local _cQuery		:= ""
	Local _cProduto		:= ""
	Local _cCliente		:= ""
	Local _lOk			:= .F.	
	Local _nPos			:= 0
	Local _nPos1		:= 0
	Local _nPos2		:= 0
	Local _cIcm			:= ""
	Local _cIPI			:= ""
	Local cTes			:= ""
	Local nValIPI		:= 0
	Local nValICM		:= 0
	Local nValPIS		:= 0
	Local nValCOF		:= 0	
	Local nValISS		:= 0
	Local nValICMST		:= 0
	Local _nAliqICM		:= 0
	Local _nAliqIPI		:= 0
	Local _nAliqPIS		:= 0
	Local _nAliqCOF		:= 0
	Local _nAliqISS		:= 0
	Local _nAliqICMS	:= 0
	Local aRelImp   	:= MaFisRelImp("MT150",{"SC8"})
	Local _aAux			:= {}
	Local _aAux2		:= {}
	Local _nI			:= 0
	Local _nJ			:= 0
	Local _cObsCot		:= ""
	Local _aTipMot		:= {"1=Corretiva","2=Preventiva","3=Maq. Parada","4=Mat. Consumo","5=Atend. Pedido"}
	
	Aadd(_aAux2,{	"",;
					"",;
					"",;
					0,;
					0,;
					"",;
					0,;
					"",;
					"",;
					"",;
					"",;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					"",;
					0 ,;
					""})

  	_cQuery := "  SELECT DISTINCT	SC8.C8_FORNECE, SC8.C8_LOJA, SC8.C8_ITEM, C8_PRODUTO, SC8.C8_NUMPRO, SC8.R_E_C_N_O_ AS CRECSC8, "
 	_cQuery += "  			   		SC8.C8_QUANT, SC8.C8_NUM, SC8.C8_UM, SC8.C8_PRECO, SC8.C8_TOTAL, SC8.C8_NUMPED, "
 	_cQuery += "  			   		SC8.C8_TPFRETE, SC8.C8_TOTFRE, SC8.C8_PRAZO, SC8.C8_COND, SE4.E4_DESCRI, SC8.C8_XCOST, SC8.C8_XSAVING,  "
 	_cQuery += "  			   		SC8.C8_MOEDA, SC8.C8_EMISSAO, SC8.C8_TXMOEDA, SC8.C8_TES, SC8.C8_PICM, SC8.C8_ALIIPI, "
 	_cQuery += "  			   		A2_SIMPNAC, A2_NREDUZ, A2_CONTATO, A2_DDD, A2_TEL,  "
 	_cQuery += "  			   		B1_DESC, B1_PICM, B1_IPI, "
 	_cQuery += "  			   		A1_NREDUZ,  "
 	_cQuery += "  			   		SC1.C1_DESCRI, "
 	_cQuery += "  			   		SB5.B5_CEME "
 	_cQuery += " FROM " + RetSqlName("SC8") + " SC8 " 
   	
 	_cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1  "
 	_cQuery += " ON B1_FILIAL = '" + xFilial("SB1") + "'  "
 	_cQuery += " AND B1_COD = SC8.C8_PRODUTO  "
 	_cQuery += " AND SB1.D_E_L_E_T_ = ' '  "
 	
 	_cQuery += " LEFT JOIN " + RetSqlName("SB5") + " SB5  "
 	_cQuery += " ON B5_FILIAL = '" + xFilial("SB5") + "'  "
 	_cQuery += " AND B5_COD = SC8.C8_PRODUTO  "
 	_cQuery += " AND SB5.D_E_L_E_T_ = ' '  "
   	 
 	_cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2  "
 	_cQuery += " ON A2_FILIAL = '" + xFilial("SA2") + "'  "
 	_cQuery += " AND A2_COD = SC8.C8_FORNECE  "
 	_cQuery += " AND A2_LOJA = SC8.C8_LOJA  "
 	_cQuery += " AND SA2.D_E_L_E_T_ = ' '  "
 
 	_cQuery += " LEFT JOIN " + RetSqlName("SE4") + " SE4 "
 	_cQuery += " ON E4_FILIAL = '" + xFilial("SE4") + "' "
 	_cQuery += " AND E4_CODIGO = SC8.C8_COND "
 	_cQuery += " AND SE4.D_E_L_E_T_ = ' ' "
   	
   	_cQuery += " LEFT JOIN " + RetSqlName("SC1") + " SC1  "
 	_cQuery += " ON C1_FILIAL = '" + xFilial("SC1") + "'  "
 	_cQuery += " AND C1_NUM = SC8.C8_NUMSC  "
 	_cQuery += " AND C1_ITEM = SC8.C8_ITEMSC  "
 	_cQuery += " AND C1_PRODUTO = SC8.C8_PRODUTO  "
 	_cQuery += " AND SC1.D_E_L_E_T_ = ' '  "
   	   	
 	_cQuery += " LEFT JOIN " + RetSqlName("SC6") + " SC6  "
 	_cQuery += " ON C6_FILIAL = '" + xFilial("SC6") + "'  "
 	_cQuery += " AND C6_NUMSC = SC8.C8_NUMSC  "
 	_cQuery += " AND C6_ITEMSC = SC8.C8_ITEMSC  "
 	_cQuery += " AND C6_PRODUTO = SC8.C8_PRODUTO  "
 	_cQuery += " AND SC6.D_E_L_E_T_ = ' '  "
   	
 	_cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1  "
 	_cQuery += " ON A1_FILIAL = '" + xFilial("SA1") + "'  "
 	_cQuery += " AND A1_COD = SC6.C6_CLI  "
 	_cQuery += " AND A1_LOJA = SC6.C6_LOJA  "
 	_cQuery += " AND SA1.D_E_L_E_T_ = ' '  "
   	
 	_cQuery += " WHERE SC8.C8_FILIAL = '" + xFilial("SC8") + "'  "
 	_cQuery += " AND SC8.C8_NUMPRO IN ( SELECT MAX(SC82.C8_NUMPRO) 
 	_cQuery += " 						FROM " + RetSqlName("SC8") + " SC82 "
 	_cQuery += " 						WHERE SC8.C8_FILIAL = '" + xFilial("SC8") + "' AND SC82.C8_NUM = SC8.C8_NUM 
 	_cQuery += " 						AND SC82.C8_FORNECE = SC8.C8_FORNECE AND SC82.C8_LOJA = SC8.C8_LOJA 
 	_cQuery += " 						AND SC82.C8_PRODUTO = C8_PRODUTO ) "
 	_cQuery	+= " AND SC8.C8_NUM = '" + _cNumCot + "' "
 	_cQuery += " AND SC8.D_E_L_E_T_ = ' ' "
 
 	_cQuery += " ORDER BY C8_NUM, C8_PRODUTO, C8_FORNECE "
	
	TcQuery _cQuery New Alias &(_cAliasCot)

	If (_cAliasCot)->(!EOF())
		While (_cAliasCot)->(!EOF())
			If (_cAliasCot)->C8_TOTAL > 0 .And. !Empty((_cAliasCot)->C8_COND) .And. (Empty((_cAliasCot)->C8_NUMPED) .Or. mv_par05 == 1) 

				dbSelectArea("SC8")
				dbSetOrder(1)
				SC8->(dbGoTo((_cAliasCot)->CRECSC8))
				
				_cObsCot	:= AllTrim(SC8->C8_XOBSCOT)   + IIF(!EMPTY(SC8->C8_XTIPMOT),".... Motivo : " + _aTipMot[Val(SC8->C8_XTIPMOT)] + " - " + AllTrim(SC8->C8_DSCMOT) + " ","")  //MSMM(SC8->C8_XOBSCOT)				
				
				_nPos		:= Ascan(_aCotacao, { |x| AllTrim(x[1]) == AllTrim((_cAliasCot)->C8_PRODUTO) .And. AllTrim(x[7]) == AllTrim((_cAliasCot)->A1_NREDUZ)})

				If _nPos == 0 .Or. Len(_aCotacao[_nPos,10]) == 3 //_cProduto <> (_cAliasCot)->C8_PRODUTO .And. _cCliente <> (_cAliasCot)->A1_NREDUZ
					_cDesc	:= Iif(ALLTRIM(MV_PAR06)=="C1_DESCRI",(_cAliasCot)->C1_DESCRI,IIF(ALLTRIM(MV_PAR06)=="B5_CEME",(_cAliasCot)->B5_CEME,(_cAliasCot)->B1_DESC))
					_cDesc	:= Iif(Empty(_cDesc),(_cAliasCot)->B1_DESC,_cDesc)
					Aadd(_aCotacao,{(_cAliasCot)->C8_PRODUTO,;
									_cDesc,;
									(_cAliasCot)->C8_ITEM,;
									(_cAliasCot)->C8_QUANT,;
									(_cAliasCot)->C8_UM,;
									(_cAliasCot)->A1_NREDUZ,;
									(_cAliasCot)->C8_XCOST,;
									(_cAliasCot)->C8_XSAVING,;
									_aPrdFor,;
									"",;
									(_cAliasCot)->C8_NUM,;
									_cObsCot })
				EndIf
				
				cTes := IIF( mv_par03 == 1 , RetFldProd((_cAliasCot)->C8_PRODUTO,"B1_TE") , (_cAliasCot)->C8_TES )
				If cPaisLoc == "BRA"
					_cIcm := IIF( mv_par10 == 1 , (_cAliasCot)->B1_PICM , (_cAliasCot)->C8_PICM   )
					_cIpi := IIF( mv_par11 == 1 , (_cAliasCot)->B1_IPI  , (_cAliasCot)->C8_ALIIPI )
				Endif	
				
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥ Calculo do custo da Cotacao                                            ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				MaFisIni((_cAliasCot)->C8_FORNECE,(_cAliasCot)->C8_LOJA,"F","N","R",aRelImp)
				MaFisIniLoad(1)
				For nY := 1 To Len(aRelImp)
					MaFisLoad(aRelImp[nY][3],SC8->(FieldGet(FieldPos(aRelImp[nY][2]))),1)
				Next nY
				MaFisEndLoad(1)
				MaFisAlt("IT_TES"    ,cTes,1)
				If cPaisLoc == "BRA"
					MaFisAlt("IT_ALIQICM",_cIcm,1)
					MaFisAlt("IT_ALIQIPI",_cIpi,1)
				Endif	
		
				_nItem		:= 1
				
				If cPaisLoc == "BRA"
					If SC8->(FieldPos("C8_MOEDA")<>0)
						nValIPI		:= xMoeda(MaFisRet(_nItem,"IT_VALIPI"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						nValICMS	:= xMoeda(MaFisRet(_nItem,"IT_VALICM"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						nValPIS		:= xMoeda(MaFisRet(_nItem,"IT_VALPS2"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						nValCOF		:= xMoeda(MaFisRet(_nItem,"IT_VALCF2"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						nValISS		:= xMoeda(MaFisRet(_nItem,"IT_VALISS"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						nValICMST	:= xMoeda(MaFisRet(_nItem,"IT_VALSOL"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						_nAliqICM	:= xMoeda(MaFisRet(_nItem,"IT_ALIQICM"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						_nAliqIPI	:= xMoeda(MaFisRet(_nItem,"IT_ALIQIPI"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						_nAliqPIS	:= xMoeda(MaFisRet(_nItem,"IT_ALIQPS2"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						_nAliqCOF	:= xMoeda(MaFisRet(_nItem,"IT_ALIQCF2"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						_nAliqISS	:= xMoeda(MaFisRet(_nItem,"IT_ALIQISS"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						_nAliqICMS	:= xMoeda(MaFisRet(_nItem,"IT_ALIQSOL"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
					Else
						nValIPI  	:= MaFisRet(_nItem,"IT_VALIPI")
						nValICMS 	:= MaFisRet(_nItem,"IT_VALICM")
						nValPIS		:= MaFisRet(_nItem,"IT_VALPS2")
						nValCOF		:= MaFisRet(_nItem,"IT_VALCF2")
						nValISS		:= MaFisRet(_nItem,"IT_VALISS")
						nValICMST	:= MaFisRet(_nItem,"IT_VALSOL")
						_nAliqICM	:= MaFisRet(_nItem,"IT_ALIQICM")
						_nAliqIPI	:= MaFisRet(_nItem,"IT_ALIQIPI")
						_nAliqPIS	:= MaFisRet(_nItem,"IT_ALIQPS2")
						_nAliqCOF	:= MaFisRet(_nItem,"IT_ALIQCF2")
						_nAliqISS	:= MaFisRet(_nItem,"IT_ALIQISS")
						_nAliqICMS	:= MaFisRet(_nItem,"IT_ALIQSOL")
					Endif		
				Endif
				
				_nPos1	:= Ascan(_aFornece, { |x| AllTrim(x) == (_cAliasCot)->C8_FORNECE+(_cAliasCot)->C8_LOJA})
				
				If _nPos == 0 
					Aadd(_aCotacao[Len(_aCotacao),09,_nPos1], {	(_cAliasCot)->C8_FORNECE,;
														(_cAliasCot)->C8_LOJA,;
														(_cAliasCot)->A2_NREDUZ,;
														(_cAliasCot)->C8_PRECO,;
														(_cAliasCot)->C8_TOTAL,;
														Iif((_cAliasCot)->C8_TPFRETE=='C','CIF',Iif((_cAliasCot)->C8_TPFRETE=='F','FOB','')),;
														(_cAliasCot)->C8_PRAZO,;
														Iif(!Empty((_cAliasCot)->C8_COND),(_cAliasCot)->E4_DESCRI,""),;
														(_cAliasCot)->A2_CONTATO,;
														"(" + AllTrim((_cAliasCot)->A2_DDD) + ") - " + (_cAliasCot)->A2_TEL,;
														Iif((_cAliasCot)->A2_SIMPNAC=="S","Sim",Iif((_cAliasCot)->A2_SIMPNAC=="N","N„o","")),;
														nValIPI,;
														nValICMS,;
														nValPIS,;
														nValCOF,;
														nValISS,;
														nValICMST,;
														_nAliqICM,;
														_nAliqIPI,;
														_nAliqPIS,;
														_nAliqCOF,;
														_nAliqISS,;
														_nAliqICMS,;
														nValICMS + nValPIS + nValCOF,;
														(_cAliasCot)->A1_NREDUZ,;
														(_cAliasCot)->C8_TOTFRE,;
														Iif(SubStr((_cAliasCot)->C8_NUMPED,1,1) == "X" .OR. EMPTY((_cAliasCot)->C8_NUMPED) ,"","S")})
													
					_aCotacao[Len(_aCotacao),10]	+= (_cAliasCot)->C8_FORNECE + (_cAliasCot)->C8_LOJA + "|"			
				Else
					Aadd(_aCotacao[_nPos,09,_nPos1], {	(_cAliasCot)->C8_FORNECE,;
														(_cAliasCot)->C8_LOJA,;
														(_cAliasCot)->A2_NREDUZ,;
														(_cAliasCot)->C8_PRECO,;
														(_cAliasCot)->C8_TOTAL,;
														Iif((_cAliasCot)->C8_TPFRETE=='C','CIF',Iif((_cAliasCot)->C8_TPFRETE=='F','FOB','')),;
														(_cAliasCot)->C8_PRAZO,;
														Iif(!Empty((_cAliasCot)->C8_COND),(_cAliasCot)->E4_DESCRI,""),;
														(_cAliasCot)->A2_CONTATO,;
														"(" + AllTrim((_cAliasCot)->A2_DDD) + ") - " + (_cAliasCot)->A2_TEL,;
														Iif((_cAliasCot)->A2_SIMPNAC=="S","Sim",Iif((_cAliasCot)->A2_SIMPNAC=="N","N„o","")),;
														nValIPI,;
														nValICMS,;
														nValPIS,;
														nValCOF,;
														nValISS,;
														nValICMST,;
														_nAliqICM,;
														_nAliqIPI,;
														_nAliqPIS,;
														_nAliqCOF,;
														_nAliqISS,;
														_nAliqICMS,;
														nValICMS + nValPIS + nValCOF,;
														(_cAliasCot)->A1_NREDUZ,;
														(_cAliasCot)->C8_TOTFRE,;
														Iif(SubStr((_cAliasCot)->C8_NUMPED,1,1) == "X" .OR. EMPTY((_cAliasCot)->C8_NUMPED) ,"","S")})
													
					_aCotacao[_nPos,10]	+= (_cAliasCot)->C8_FORNECE + (_cAliasCot)->C8_LOJA + "|"			
				EndIf
			EndIf
			
			_cCliente	:= (_cAliasCot)->A1_NREDUZ
			_cProduto	:= (_cAliasCot)->C8_PRODUTO
			(_cAliasCot)->(dbSkip())			

		EndDo
	EndIF
	
	For _nI := 1 To Len(_aCotacao)
		For _nJ := 1 To Len(_aCotacao[_nI,09])
			If Len(_aCotacao[_nI,09,_nJ]) == 0
				_aCotacao[_nI,09,_nJ] := _aAux2[1]
			EndIf
		Next _nJ	
	Next _nI
	
	
	(_cAliasCot)->(dbCloseArea())  

Return()


//-------------------------------------------------------------------
/*/{Protheus.doc} _fImpSpo
FunÁ„o para impress„o do relatÛrio via Spool.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		24/07/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fImpSpo()

	Local _nTotHrs		:= 0
	Local lSH8			:= .F.
	Local _nLinTotHr	:= 0
	Local _cNumOp		:= ""
	Local _cPrd			:= ""
	Local _cBenef		:= ""
	Local _cRetCom		:= ""
	Local _cOperac		:= ""
	Local _CNUMCOT 		:= ""
	Local _aOP			:= {}
	Local _nI			:= 0
	Local _nJ			:= 0
	Local _nInic		:= 0
	Local _nInic2		:= 0
	Local _cAux			:= ""
	Local _cAux2        := ""
	Local _lOk			:= .F.
	Local _lImpR		:= .F.
	Local _cComprador	:= AllTrim(MV_PAR07) //AllTrim(SuperGetMv("ES_HMR2CMP",,"Eusebio Gomes"))
	Local _cGerSup		:= AllTrim(MV_PAR08) //AllTrim(SuperGetMv("ES_HMR2GSP",,"Alexandre Fernandes"))
	Local _cDiretoria	:= AllTrim(MV_PAR09) //AllTrim(SuperGetMv("ES_HMR2DIR",,""))
	Local _cIndice		:= 0
	Local cConta		:= ""
	Local _cObserv		:= ""
			
	Private _oFonte1	:= TFont():New("Arial",,20,,.T.,,,,,.F.)
	Private _oFonte2	:= TFont():New("Arial",,14,,.T.,,,,,.F.)
	Private _oFonte8	:= TFont():New("Arial",,13,,.T.,,,,,.F.)
	Private _oFonte3	:= TFont():New("Arial",,10,,.F.,,,,,.F.)
	Private _oFonte4	:= TFont():New("Arial",,08,,.T.,,,,,.F.)
	Private _oFonte5	:= TFont():New("Arial",,07,,.F.,,,,,.F.)
	Private _oFonte6	:= TFont():New("Arial",,07,,.T.,,,,,.F.)
	Private _oFonte7	:= TFont():New("Arial",,12,,.T.,,,,,.F.)
	Private _oFonte8	:= TFont():New("Arial",,06,,.F.,,,,,.F.)
	Private _oReport	:= Nil
	Private _cTitulo	:= "Analise das CotaÁıes"
	Private _cAliasTmp	:= GetNextAlias()
	Private aArray		:= {}
	Private _cAliasRec	:= ""
	Private nlLin 		:= 0050
	Private _aCotacao	:= {}
	Private _aAuxCot	:= {}
	Private _nTotI1		:= 0
	Private _nTotSI1	:= 0
	Private _nTotI2		:= 0
	Private _nTotSI2	:= 0
	Private _nTotI3		:= 0
	Private _nTotSI3	:= 0
	Private _nTICM1		:= 0
	Private _nTIPI1		:= 0
	Private _nTCOF1		:= 0
	Private _nTPIS1		:= 0
	Private _nTICMS1	:= 0
	Private _nTICM2		:= 0
	Private _nTIPI2		:= 0
	Private _nTCOF2		:= 0
	Private _nTPIS2		:= 0
	Private _nTICMS2	:= 0
	Private _nTICM3		:= 0
	Private _nTIPI3		:= 0
	Private _nTCOF3		:= 0
	Private _nTPIS3		:= 0
	Private _nTICMS3	:= 0
	Private _nFrete1	:= 0
	Private _nFrete2	:= 0
	Private _nFrete3	:= 0
	Private _lRodPe		:= .F.

	_oReport := TmsPrinter():New("Analise de CotaÁıes")
	_oReport:SetPortrait()
	_oReport:SetLandscape(.T.)
	
	_fQryTmp(_cAliasTmp)
	
	ProcRegua(RecCount())
	
	(_cAliasTmp)->(dbGoTop())
	While (_cAliasTmp)->(!EOF())
		
		If _cNumCot <> (_cAliasTmp)->C8_NUM			
			_aCotacao	:= {}
			_fQryCot((_cAliasTmp)->C8_NUM)			
		EndIf
		
		_cNumCot		:= (_cAliasTmp)->C8_NUM	
		
		(_cAliasTmp)->(dbSkip())

	EndDo

	aSort(_aAuxCot,,, { |x, y| ALLTRIM(STR(X[14]))+x[3] < ALLTRIM(STR(y[14])) +y[3] } )

	For _nI	:= 1 To Len(_aAuxCot)	
		If _cIndice <> _aAuxCot[_nI,14]
			
			If nlLin > 0050
				_fRodPe(_NI,_cComprador,_cGerSup,_cDiretoria)
			EndIf
			_lRodPe	:= .T.
			_oReport:StartPage()
			nlLin := 0050		
			              
			_nTotI1		:= _aAuxCot[_nI,10,1,5]
			_nTotSI1	:= Iif(SubStr(_aAuxCot[_nI,10,1,11],1,1)=="S",_aAuxCot[_nI,10,1,5],(Iif(_aAuxCot[_nI,10,1,5]>0,_aAuxCot[_nI,10,1,5] - _aAuxCot[_nI,10,1,24],_aAuxCot[_nI,10,1,5])))
			_nTotI2		:= _aAuxCot[_nI,10,2,5]
			_nTotSI2	:= Iif(SubStr(_aAuxCot[_nI,10,2,11],1,1)=="S",_aAuxCot[_nI,10,2,5],(Iif(_aAuxCot[_nI,10,2,5]>0,_aAuxCot[_nI,10,2,5] - _aAuxCot[_nI,10,2,24],_aAuxCot[_nI,10,2,5])))
			_nTotI3		:= _aAuxCot[_nI,10,3,5]
			_nTotSI3	:= Iif(SubStr(_aAuxCot[_nI,10,3,11],1,1)=="S",_aAuxCot[_nI,10,3,5],(Iif(_aAuxCot[_nI,10,3,5]>0,_aAuxCot[_nI,10,3,5] - _aAuxCot[_nI,10,3,24],_aAuxCot[_nI,10,3,5])))
			
			_nTICM1		:= _aAuxCot[_nI,10,1,13]
			_nTIPI1		:= _aAuxCot[_nI,10,1,12]
			_nTCOF1		:= _aAuxCot[_nI,10,1,15]
			_nTPIS1		:= _aAuxCot[_nI,10,1,14]
			_nTICMS1	:= _aAuxCot[_nI,10,1,17]
			
			_nTICM2		:= _aAuxCot[_nI,10,2,13]
			_nTIPI2		:= _aAuxCot[_nI,10,2,12]
			_nTCOF2		:= _aAuxCot[_nI,10,2,15]
			_nTPIS2		:= _aAuxCot[_nI,10,2,14]
			_nTICMS2	:= _aAuxCot[_nI,10,2,17]
			
			_nTICM3		:= _aAuxCot[_nI,10,3,13]
			_nTIPI3		:= _aAuxCot[_nI,10,3,12]
			_nTCOF3		:= _aAuxCot[_nI,10,3,15]
			_nTPIS3		:= _aAuxCot[_nI,10,3,14]
			_nTICMS3	:= _aAuxCot[_nI,10,3,17]
			
			_nFrete1	:= _aAuxCot[_nI,10,1,26]
			_nFrete2	:= _aAuxCot[_nI,10,2,26]
			_nFrete3	:= _aAuxCot[_nI,10,3,26]
			
			_oReport:Saybitmap(0080,0040, "lgrl" + cEmpAnt + ".BMP",0180,0120,)
			_oReport:Say(0120		,0482	,_cTitulo																							,_oFonte1)
			_oReport:Line(nlLin		,0015	,nlLin																								,1300)
			_oReport:Line(nlLin		,0015	,nlLin + 0200																						,0015)
			_oReport:Line(nlLin		,1300	,nlLin + 0240																						,1300)
			
			_oReport:Line(nlLin		,1300	,nlLin																								,3350)
			_oReport:Line(nlLin+0040,1300	,nlLin+0040																							,2666)
			_oReport:Line(nlLin+0080,1300	,nlLin+0080																							,1700)
			_oReport:Line(nlLin+0040,1700	,nlLin+0080																							,1700)
			_oReport:Line(nlLin		,1500	,nlLin + 0080																						,1500)
			_oReport:Line(nlLin		,2666	,nlLin + 0120																						,2666)
			_oReport:Line(nlLin		,2923	,nlLin+0120																							,2923)
			_oReport:Line(nlLin+0060,2666	,nlLin+0060																							,3350)
			_oReport:Line(nlLin+0120,2666	,nlLin+0120																							,3350)
			
			_oReport:Say(nlLin+0010	,1305	,"Cliente"																							,_oFonte5)
			_oReport:Say(nlLin+0050	,1305	,"Emiss„o"																							,_oFonte5)
		    _oReport:Say(nlLin+0010	,1505	,_aAuxCot[_nI,07]																					,_oFonte5)
		    _oReport:Say(nlLin+0050	,1505	,SubStr(DtoS(Date()),7,2) + "/" + SubStr(DtoS(Date()),5,2) + "/" + SubStr(DtoS(Date()),1,4)			,_oFonte5)
		    
		    _oReport:Say(nlLin+0010	,2671	,"R$ OrÁado"																						,_oFonte8)
		    _oReport:Say(nlLin+0060	,2671	,"Saving"																							,_oFonte8)
		                                                                                                                                                  
		    _oReport:Say(nlLin+0010	,2928	,Transform(_aAuxCot[_nI,08],PesqPict("SC8","C8_XCOST"))											,_oFonte2)
		    _oReport:Say(nlLin+0060	,2928	,Transform(_aAuxCot[_nI,09],PesqPict("SC8","C8_XSAVING"))											,_oFonte2)
		    
			_oReport:Line(nlLin+210	,0015	,nlLin+210																							,0270)
			_oReport:Line(nlLin		,0270	,nlLin + 0210																						,0270)
			_oReport:Line(nlLin		,3350	,nlLin + 0210																						,3350)
			
			_oReport:Line(nlLin+200	,1300	,nlLin+200																							,3350)
			_oReport:Say(nlLin+0210	,2105	,"EMPRESAS PROPONENTES"																				,_oFonte6)
			_oReport:Line(nlLin+240	,1300	,nlLin+240																							,3350)
			_oReport:Line(nlLin+200	,3350	,nlLin+240																							,3350)
			
			//1∫ Fornecedor
			_oReport:Line(nlLin+240	,1983	,nlLin+1310																							,1983)
			_oReport:Line(nlLin+240	,2666	,nlLin+1310																							,2666)
			_oReport:Line(nlLin+240	,3350	,nlLin+1310																							,3350)
	
			_oReport:Say(nlLin+0250	,1305	,"Fornecedor: " + _aAuxCot[_nI,10,1,3]																					,_oFonte5)
			_oReport:Line(nlLin+280	,1300	,nlLin+280																							,3350)
			_oReport:Say(nlLin+0290	,1305	,"Contato: " + _aAuxCot[_nI,10,1,9]																							,_oFonte5)
			_oReport:Say(nlLin+0330	,1305	,"Tel.: " + _aAuxCot[_nI,10,1,10]																							,_oFonte5)
			_oReport:Line(nlLin+360	,1300	,nlLin+360																							,3350)
			_oReport:Say(nlLin+0370	,1305	,"R$ UNITARIO"																						,_oFonte5)
			_oReport:Line(nlLin+360	,1527	,nlLin+1310																							,1527)
			_oReport:Say(nlLin+0370	,1532	,"R$ TOT. S/ IMP"																					,_oFonte5)
			_oReport:Line(nlLin+360	,1754	,nlLin+1310																							,1754)
			_oReport:Say(nlLin+0370	,1759	,"R$ TOT. C/ IMP"																					,_oFonte5)
			_oReport:Line(nlLin+400	,1300	,nlLin+400																							,3350)
			
			//2∫ Fornecedor
			_oReport:Say(nlLin+0250	,1988	,"Fornecedor: " + Iif(Len(_aAuxCot[_nI,10])>1,_aAuxCot[_nI,10,2,3],"")																						,_oFonte5)
			_oReport:Say(nlLin+0290	,1988	,"Contato: " + Iif(Len(_aAuxCot[_nI,10])>1,_aAuxCot[_nI,10,2,9],"")																							,_oFonte5)
			_oReport:Say(nlLin+0330	,1988	,"Tel.: " + Iif(Len(_aAuxCot[_nI,10])>1,_aAuxCot[_nI,10,2,10],"")																							,_oFonte5)
			_oReport:Say(nlLin+0370	,1988	,"R$ UNITARIO"																						,_oFonte5)
			_oReport:Line(nlLin+360	,2210	,nlLin+1310																							,2210)
			_oReport:Say(nlLin+0370	,2215	,"R$ TOT. S/ IMP"																					,_oFonte5)
			_oReport:Line(nlLin+360	,2437	,nlLin+1310																							,2437)
			_oReport:Say(nlLin+0370	,2442	,"R$ TOT. C/ IMP"																					,_oFonte5)
			
			//3∫ Fornecedor
			_oReport:Say(nlLin+0250	,2671	,"Fornecedor: " + Iif(Len(_aAuxCot[_nI,10])>2,_aAuxCot[_nI,10,3,3],"")																					,_oFonte5)
			_oReport:Say(nlLin+0290	,2671	,"Contato: " + Iif(Len(_aAuxCot[_nI,10])>2,_aAuxCot[_nI,10,3,9],"")																							,_oFonte5)
			_oReport:Say(nlLin+0330	,2671	,"Tel.: " + Iif(Len(_aAuxCot[_nI,10])>2,_aAuxCot[_nI,10,3,10],"")																							,_oFonte5)
			_oReport:Say(nlLin+0370	,2671	,"R$ UNITARIO"																						,_oFonte5)
			_oReport:Line(nlLin+360	,2893	,nlLin+1310																							,2893)
			_oReport:Say(nlLin+0370	,2898	,"R$ TOT. S/ IMP"																					,_oFonte5)
			_oReport:Line(nlLin+360	,3120	,nlLin+1310																							,3120)
			_oReport:Say(nlLin+0370	,3125	,"R$ TOT. C/ IMP"																					,_oFonte5)
			
			nlLin+=200
			_oReport:Say(nlLin+010	,0020	,"N∫ " + _aAuxCot[_nI,12]																								,_oFonte6)
			_oReport:Line(nlLin		,0015	,nlLin + 0040																						,0015)
			_oReport:Line(nlLin		,0270	,nlLin + 0040																						,0270)
			
			nlLin+=040
			
			_oReport:Line(nlLin		,0015	,nlLin																								,1300)
		//	_oReport:Line(nlLin		,0270	,nlLin + 0600																						,1300)
			_oReport:Line(nlLin		,0015	,nlLin+1070																							,0015)
			_oReport:Line(nlLin		,0115	,nlLin+1070																							,0115)
			_oReport:Line(nlLin		,0315	,nlLin+1070																							,0315)
//			_oReport:Line(nlLin		,0715	,nlLin+1070																							,0715)
			_oReport:Line(nlLin		,0915	,nlLin+1070																							,0915)
			_oReport:Line(nlLin		,1015	,nlLin+1070																							,1015)
			_oReport:Line(nlLin		,1300	,nlLin+1070																							,1300)
			
			_oReport:Say(nlLin+0060	,0045	,"Item"																								,_oFonte5)
			_oReport:Say(nlLin+0060	,0200	,"Codigo"																							,_oFonte5)
			_oReport:Say(nlLin+0060	,0500	,"DescriÁ„o"																						,_oFonte5)	
//			_oReport:Say(nlLin+0060	,0790	,"Qtde."																							,_oFonte5)	
			_oReport:Say(nlLin+0060	,0945	,"UM"																								,_oFonte5)	
			_oReport:Say(nlLin+0060	,1135	,"Qtde."																							,_oFonte5)	
			_oReport:Line(nlLin+160	,0015	,nlLin+160																							,1300)
		//	nlLin+=040
		//	_oReport:Line(nlLin		,0015	,nlLin																								,1300)
		
			_nLin	:= nlLin+160
			
			If Len(_aAuxCot[_nI,02]) > 25 .Or. Len(_aAuxCot[_nI,01]) > 10
			
				_nInic	:= 1
				_nInic2	:= 1
				_cAux	:= SubStr(_aAuxCot[_nI,01],_nInic,10)
				_cAux2	:= SubStr(_aAuxCot[_nI,02],_nInic2,40)
				_lOk	:= .F.
				
				While !Empty(_cAux) .Or. !Empty(_cAux2)
					If !_lOk
						_oReport:Line(_nLin-0020		,0015	,_nLin+0040																							,0015)
						_oReport:Line(_nLin-0020		,0115	,_nLin+0040																							,0115)
						_oReport:Line(_nLin-0020		,0315	,_nLin+0040																							,0315)
						_oReport:Line(_nLin-0020		,0915	,_nLin+0040																							,0915)
						_oReport:Line(_nLin-0020		,1015	,_nLin+0040																							,1015)
						_oReport:Line(_nLin-0020		,1300	,_nLin+0040																							,1300)
						_oReport:Line(_nLin-0020		,3350	,_nLin+0040																							,3350)
						_oReport:Line(_nLin-0020		,1527	,_nLin+0040																							,1527)
						_oReport:Line(_nLin-0020		,1754	,_nLin+0040																							,1754)
						_oReport:Line(_nLin-0020		,2210	,_nLin+0040																							,2210)
						_oReport:Line(_nLin-0020		,2437	,_nLin+0040																							,2437)
						_oReport:Line(_nLin-0020		,2893	,_nLin+0040																							,2893)
						_oReport:Line(_nLin-0020		,3120	,_nLin+0040																							,3120)
						_oReport:Line(_nLin-0020	,1983	,_nLin+0040																							,1983)
						_oReport:Line(_nLin-0020	,2666	,_nLin+0040																							,2666)
						_oReport:Line(_nLin-0020	,3350	,_nLin+0040																							,3350)
						_oReport:Say(_nLin+0010	,0020	,_aAuxCot[_nI,03]																					,_oFonte5)
						_oReport:Say(_nLin+0010	,0120	,_cAux																					,_oFonte5)
						_oReport:Say(_nLin+0010	,0320	,_cAux2																					,_oFonte5)	
						_oReport:Say(_nLin+0010	,1135	,Transform(_aAuxCot[_nI,04],PesqPict("SC8","C8_QUANT"))											,_oFonte5)	
						_oReport:Say(_nLin+0010	,0920	,_aAuxCot[_nI,05]																					,_oFonte5)	
//						_oReport:Say(_nLin+0010	,1020	,_aAuxCot[_nI,06]																					,_oFonte5)	
						_lOk	:= .T.
					Else
						_nLin+=0040
						_oReport:Line(_nLin-0020		,0015	,_nLin+0040																							,0015)
						_oReport:Line(_nLin-0020		,0115	,_nLin+0040																							,0115)
						_oReport:Line(_nLin-0020		,0315	,_nLin+0040																							,0315)
//						_oReport:Line(_nLin		,0715	,_nLin+0040																							,0715)
						_oReport:Line(_nLin-0020		,0915	,_nLin+0040																							,0915)
						_oReport:Line(_nLin-0020		,1015	,_nLin+0040																							,1015)
						_oReport:Line(_nLin-0020		,1300	,_nLin+0040																							,1300)
						_oReport:Line(_nLin-0020		,3350	,_nLin+0040																							,3350)
						_oReport:Line(_nLin-0020		,1527	,_nLin+0040																							,1527)
						_oReport:Line(_nLin-0020		,1754	,_nLin+0040																							,1754)
						_oReport:Line(_nLin-0020		,2210	,_nLin+0040																							,2210)
						_oReport:Line(_nLin-0020		,2437	,_nLin+0040																							,2437)
						_oReport:Line(_nLin-0020		,2893	,_nLin+0040																							,2893)
						_oReport:Line(_nLin-0020		,3120	,_nLin+0040																							,3120)

						_oReport:Line(_nLin	,1983	,_nLin+0040																							,1983)
						_oReport:Line(_nLin	,2666	,_nLin+0040																							,2666)
						_oReport:Line(_nLin	,3350	,_nLin+0040																							,3350)
						
						_oReport:Say(_nLin+0010	,0120	,_cAux																					,_oFonte5)
						_oReport:Say(_nLin+0010	,0320	,_cAux2																					,_oFonte5)					
					EndIf
					
					_nInic	+= 10
					_nInic2	+= 40
					_cAux	:= SubStr(_aAuxCot[_nI,01],_nInic,10)
					_cAux2	:= SubStr(_aAuxCot[_nI,02],_nInic2,40)
					
				EndDo
			Else                                       
				_oReport:Line(_nLin-0020		,0015	,_nLin+0040																							,0015)
				_oReport:Line(_nLin-0020		,0115	,_nLin+0040																							,0115)
				_oReport:Line(_nLin-0020		,0315	,_nLin+0040																							,0315)
//				_oReport:Line(_nLin-0020		,0715	,_nLin+0040																							,0715)
				_oReport:Line(_nLin-0020		,0915	,_nLin+0040																							,0915)
				_oReport:Line(_nLin-0020		,1015	,_nLin+0040																							,1015)
				_oReport:Line(_nLin-0020		,1300	,_nLin+0040																							,1300)
				_oReport:Line(_nLin-0020		,3350	,_nLin+0040																							,3350)
				_oReport:Line(_nLin-0020		,1527	,_nLin+0040																							,1527)
				_oReport:Line(_nLin-0020		,1754	,_nLin+0040																							,1754)
				_oReport:Line(_nLin-0020		,2210	,_nLin+0040																							,2210)
				_oReport:Line(_nLin-0020		,2437	,_nLin+0040																							,2437)
				_oReport:Line(_nLin-0020		,2893	,_nLin+0040																							,2893)
				_oReport:Line(_nLin-0020		,3120	,_nLin+0040																							,3120)
						
				_oReport:Line(_nLin	,1983	,_nLin+0040																							,1983)
				_oReport:Line(_nLin	,2666	,_nLin+0040																							,2666)
				_oReport:Line(_nLin	,3350	,_nLin+0040																							,3350)
				_oReport:Say(_nLin+0010	,0020	,_aAuxCot[_nI,03]																					,_oFonte5)
				_oReport:Say(_nLin+0010	,0120	,_aAuxCot[_nI,01]																					,_oFonte5)
				_oReport:Say(_nLin+0010	,0320	,_aAuxCot[_nI,02]																					,_oFonte5)	
				_oReport:Say(_nLin+0010	,1135	,Transform(_aAuxCot[_nI,04],PesqPict("SC8","C8_QUANT"))											,_oFonte5)	
				_oReport:Say(_nLin+0010	,0920	,_aAuxCot[_nI,05]																					,_oFonte5)	
//				_oReport:Say(_nLin+0010	,1020	,_aAuxCot[_nI,06]																					,_oFonte5)	
				
			EndIf
			
			If _aAuxCot[_nI,10,1,27] == "S"
				_oReport:Say(_nLin+0010	,1315	,Transform(_aAuxCot[_nI,10,1,4],PesqPict("SC8","C8_PRECO"))										,_oFonte6)
				_oReport:Say(_nLin+0010	,1592	,Transform(Iif(SubStr(_aAuxCot[_nI,10,1,11],1,1)=="S",_aAuxCot[_nI,10,1,5],(_aAuxCot[_nI,10,1,5] - _aAuxCot[_nI,10,1,24])),PesqPict("SC8","C8_TOTAL"))										,_oFonte6)
				_oReport:Say(_nLin+0010	,1819	,Transform(_aAuxCot[_nI,10,1,5],PesqPict("SC8","C8_TOTAL"))										,_oFonte6)
			Else
				_oReport:Say(_nLin+0010	,1315	,Transform(_aAuxCot[_nI,10,1,4],PesqPict("SC8","C8_PRECO"))										,_oFonte5)
				_oReport:Say(_nLin+0010	,1592	,Transform(Iif(SubStr(_aAuxCot[_nI,10,1,11],1,1)=="S",_aAuxCot[_nI,10,1,5],(_aAuxCot[_nI,10,1,5] - _aAuxCot[_nI,10,1,24])),PesqPict("SC8","C8_TOTAL"))										,_oFonte5)
				_oReport:Say(_nLin+0010	,1819	,Transform(_aAuxCot[_nI,10,1,5],PesqPict("SC8","C8_TOTAL"))										,_oFonte5)
			EndIf
			
			
			If Len(_aAuxCot[_nI,10]) > 1
				If _aAuxCot[_nI,10,2,27] == "S"
					_oReport:Say(_nLin+0010	,1998	,Transform(_aAuxCot[_nI,10,2,4],PesqPict("SC8","C8_PRECO"))									,_oFonte6)
					_oReport:Say(_nLin+0010	,2275	,Transform(Iif(SubStr(_aAuxCot[_nI,10,2,11],1,1)=="S",_aAuxCot[_nI,10,2,5],(_aAuxCot[_nI,10,2,5] - _aAuxCot[_nI,10,2,24])),PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
					_oReport:Say(_nLin+0010	,2502	,Transform(_aAuxCot[_nI,10,2,5],PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
				Else
					_oReport:Say(_nLin+0010	,1998	,Transform(_aAuxCot[_nI,10,2,4],PesqPict("SC8","C8_PRECO"))									,_oFonte5)
					_oReport:Say(_nLin+0010	,2275	,Transform(Iif(SubStr(_aAuxCot[_nI,10,2,11],1,1)=="S",_aAuxCot[_nI,10,2,5],(_aAuxCot[_nI,10,2,5] - _aAuxCot[_nI,10,2,24])),PesqPict("SC8","C8_TOTAL"))									,_oFonte5)
					_oReport:Say(_nLin+0010	,2502	,Transform(_aAuxCot[_nI,10,2,5],PesqPict("SC8","C8_TOTAL"))									,_oFonte5)
				EndIf
			EndIf
			
			If Len(_aAuxCot[_nI,10]) > 2
				If _aAuxCot[_nI,10,3,27] == "S"
					_oReport:Say(_nLin+0010	,2681	,Transform(_aAuxCot[_nI,10,3,4],PesqPict("SC8","C8_PRECO"))									,_oFonte6)
					_oReport:Say(_nLin+0010	,2938	,Transform(Iif(SubStr(_aAuxCot[_nI,10,3,11],1,1)=="S",_aAuxCot[_nI,10,3,5],(_aAuxCot[_nI,10,3,5] - _aAuxCot[_nI,10,3,24])),PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
					_oReport:Say(_nLin+0010	,3185	,Transform(_aAuxCot[_nI,10,3,5],PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
				Else
					_oReport:Say(_nLin+0010	,2681	,Transform(_aAuxCot[_nI,10,3,4],PesqPict("SC8","C8_PRECO"))									,_oFonte5)
					_oReport:Say(_nLin+0010	,2938	,Transform(Iif(SubStr(_aAuxCot[_nI,10,3,11],1,1)=="S",_aAuxCot[_nI,10,3,5],(_aAuxCot[_nI,10,3,5] - _aAuxCot[_nI,10,3,24])),PesqPict("SC8","C8_TOTAL"))									,_oFonte5)
					_oReport:Say(_nLin+0010	,3185	,Transform(_aAuxCot[_nI,10,3,5],PesqPict("SC8","C8_TOTAL"))									,_oFonte5)
				EndIf
			EndIf
			
			_nLin += 30

			_oReport:Say(_nLin+0010	,0020	,"TES"																								,_oFonte5)
			_oReport:Say(_nLin+0010	,0120	,_aAuxCot[_nI,15]																					,_oFonte5)
			_oReport:Say(_nLin+0010	,0320	,GetAdvFval("SF4","F4_TEXTO",xFilial("SF4")+_aAuxCot[_nI,15],1)										,_oFonte5)	
			If _aAuxCot[_nI,10,1,27] == "S"
				_oReport:Say(_nLin+0010	,1819	,Transform(_aAuxCot[_nI,10,1,24]+_aAuxCot[_nI,10,1,17],PesqPict("SC8","C8_TOTAL"))										,_oFonte6)
			Else
				_oReport:Say(_nLin+0010	,1819	,Transform(_aAuxCot[_nI,10,1,24]+_aAuxCot[_nI,10,1,17],PesqPict("SC8","C8_TOTAL"))										,_oFonte5)
			EndIf
			If Len(_aAuxCot[_nI,10]) > 1
				If _aAuxCot[_nI,10,2,27] == "S"
					_oReport:Say(_nLin+0010	,2502	,Transform(_aAuxCot[_nI,10,2,24]+_aAuxCot[_nI,10,2,17],PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
				Else
					_oReport:Say(_nLin+0010	,2502	,Transform(_aAuxCot[_nI,10,2,24]+_aAuxCot[_nI,10,2,17],PesqPict("SC8","C8_TOTAL"))									,_oFonte5)
				EndIf
			EndIf
			
			If Len(_aAuxCot[_nI,10]) > 2
				If _aAuxCot[_nI,10,3,27] == "S"
					_oReport:Say(_nLin+0010	,3185	,Transform(_aAuxCot[_nI,10,3,24]+_aAuxCot[_nI,10,3,17],PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
				Else
					_oReport:Say(_nLin+0010	,3185	,Transform(_aAuxCot[_nI,10,3,24]+_aAuxCot[_nI,10,3,17],PesqPict("SC8","C8_TOTAL"))									,_oFonte5)
				EndIf
			EndIf

			_nLin += 30
            
			cConta:=GetAdvFval("SB1","B1_CONTA",xFilial("SB1")+_aAuxCot[_nI,01],1)
			_oReport:Say(_nLin+0010	,0020	,"C.Contabil"																						,_oFonte5)
			_oReport:Say(_nLin+0010	,0120	,cConta																								,_oFonte5)
			_oReport:Say(_nLin+0010	,0320	,GetAdvFval("CT1","CT1_DESC01",xFilial("CT1")+cConta,1)												,_oFonte5)	

			_nLin += 40
			_oReport:Line(_nLin	,0015	,_nLin																								,3350)
			
				
		Else
			_nLin+=0020
			_nTotI1		+= _aAuxCot[_nI,10,1,5]
			_nTotSI1	+= Iif(SubStr(_aAuxCot[_nI,10,1,11],1,1)=="S",_aAuxCot[_nI,10,1,5],(Iif(_aAuxCot[_nI,10,1,5]>0,_aAuxCot[_nI,10,1,5] - _aAuxCot[_nI,10,1,24],_aAuxCot[_nI,10,1,5])))
			_nTotI2		+= _aAuxCot[_nI,10,2,5]
			_nTotSI2	+= Iif(SubStr(_aAuxCot[_nI,10,2,11],1,1)=="S",_aAuxCot[_nI,10,2,5],(Iif(_aAuxCot[_nI,10,2,5]>0,_aAuxCot[_nI,10,2,5] - _aAuxCot[_nI,10,2,24],_aAuxCot[_nI,10,2,5])))
			_nTotI3		+= _aAuxCot[_nI,10,3,5]
			_nTotSI3	+= Iif(SubStr(_aAuxCot[_nI,10,3,11],1,1)=="S",_aAuxCot[_nI,10,3,5],(Iif(_aAuxCot[_nI,10,3,5]>0,_aAuxCot[_nI,10,3,5] - _aAuxCot[_nI,10,3,24],_aAuxCot[_nI,10,3,5])))
			
			_nTICM1		+= _aAuxCot[_nI,10,1,13]
			_nTIPI1		+= _aAuxCot[_nI,10,1,12]
			_nTCOF1		+= _aAuxCot[_nI,10,1,15]
			_nTPIS1		+= _aAuxCot[_nI,10,1,14]
			_nTICMS1	+= _aAuxCot[_nI,10,1,17]
			
			_nTICM2		+= _aAuxCot[_nI,10,2,13]
			_nTIPI2		+= _aAuxCot[_nI,10,2,12]
			_nTCOF2		+= _aAuxCot[_nI,10,2,15]
			_nTPIS2		+= _aAuxCot[_nI,10,2,14]
			_nTICMS2	+= _aAuxCot[_nI,10,2,17]
			
			_nTICM3		+= _aAuxCot[_nI,10,3,13]
			_nTIPI3		+= _aAuxCot[_nI,10,3,12]
			_nTCOF3		+= _aAuxCot[_nI,10,3,15]
			_nTPIS3		+= _aAuxCot[_nI,10,3,14]
			_nTICMS3	+= _aAuxCot[_nI,10,3,17]
			
			_nFrete1	+= _aAuxCot[_nI,10,1,26]
			_nFrete2	+= _aAuxCot[_nI,10,2,26]
			_nFrete3	+= _aAuxCot[_nI,10,3,26]
			
			If Len(_aAuxCot[_nI,02]) > 25 .Or. Len(_aAuxCot[_nI,01]) > 10
			
				_nInic	:= 1
				_nInic2	:= 1
				_cAux	:= SubStr(_aAuxCot[_nI,01],_nInic,10)
				_cAux2	:= SubStr(_aAuxCot[_nI,02],_nInic2,40)
				_lOk	:= .F.
				
				While !Empty(_cAux) .Or. !Empty(_cAux2)
					If !_lOk
						_oReport:Line(_nLin-0020		,0015	,_nLin+0040																							,0015)
						_oReport:Line(_nLin-0020		,0115	,_nLin+0040																							,0115)
						_oReport:Line(_nLin-0020		,0315	,_nLin+0040																							,0315)
//						_oReport:Line(_nLin		,0715	,_nLin+0040																							,0715)
						_oReport:Line(_nLin-0020		,0915	,_nLin+0040																							,0915)
						_oReport:Line(_nLin-0020		,1015	,_nLin+0040																							,1015)
						_oReport:Line(_nLin-0020		,1300	,_nLin+0040																							,1300)
						_oReport:Line(_nLin-0020		,3350	,_nLin+0040																							,3350)
						
						_oReport:Line(_nLin-0020		,1527	,_nLin+0040																							,1527)
						_oReport:Line(_nLin-0020		,1754	,_nLin+0040																							,1754)
						_oReport:Line(_nLin-0020		,2210	,_nLin+0040																							,2210)
						_oReport:Line(_nLin-0020		,2437	,_nLin+0040																							,2437)
						_oReport:Line(_nLin-0020		,2893	,_nLin+0040																							,2893)
						_oReport:Line(_nLin-0020		,3120	,_nLin+0040																							,3120)
												
						_oReport:Line(_nLin-0020	,1983	,_nLin+0040																							,1983)
						_oReport:Line(_nLin-0020	,2666	,_nLin+0040																							,2666)
						_oReport:Line(_nLin-0020	,3350	,_nLin+0040																							,3350)
						
						_oReport:Say(_nLin+0010	,0020	,_aAuxCot[_nI,03]																					,_oFonte5)
						_oReport:Say(_nLin+0010	,0120	,_cAux																					,_oFonte5)
						_oReport:Say(_nLin+0010	,0320	,_cAux2																					,_oFonte5)	
						_oReport:Say(_nLin+0010	,1135	,Transform(_aAuxCot[_nI,04],PesqPict("SC8","C8_QUANT"))											,_oFonte5)	
						_oReport:Say(_nLin+0010	,0920	,_aAuxCot[_nI,05]																					,_oFonte5)	
//						_oReport:Say(_nLin+0010	,1020	,_aAuxCot[_nI,06]																					,_oFonte5)	
						_lOk	:= .T.
					Else
						_nLin+=0040
						_oReport:Line(_nLin-0020		,0015	,_nLin+0040																							,0015)
						_oReport:Line(_nLin-0020		,0115	,_nLin+0040																							,0115)
						_oReport:Line(_nLin-0020		,0315	,_nLin+0040																							,0315)
//						_oReport:Line(_nLin		,0715	,_nLin+0040																							,0715)
						_oReport:Line(_nLin-0020		,0915	,_nLin+0040																							,0915)
						_oReport:Line(_nLin-0020		,1015	,_nLin+0040																							,1015)
						_oReport:Line(_nLin-0020		,1300	,_nLin+0040																							,1300)
						_oReport:Line(_nLin-0020		,3350	,_nLin+0040																							,3350)
						_oReport:Line(_nLin-0020		,1527	,_nLin+0040																							,1527)
						_oReport:Line(_nLin-0020		,1754	,_nLin+0040																							,1754)
						_oReport:Line(_nLin-0020		,2210	,_nLin+0040																							,2210)
						_oReport:Line(_nLin-0020		,2437	,_nLin+0040																							,2437)
						_oReport:Line(_nLin-0020		,2893	,_nLin+0040																							,2893)
						_oReport:Line(_nLin-0020		,3120	,_nLin+0040																							,3120)
						
						_oReport:Line(_nLin-0020	,1983	,_nLin+0040																							,1983)
						_oReport:Line(_nLin-0020	,2666	,_nLin+0040																							,2666)
						_oReport:Line(_nLin-0020	,3350	,_nLin+0040																							,3350)
						
						_oReport:Say(_nLin+0010	,0120	,_cAux																					,_oFonte5)
						_oReport:Say(_nLin+0010	,0320	,_cAux2																					,_oFonte5)					
					EndIf
					
					_nInic	+= 10
					_nInic2	+= 40
					_cAux	:= SubStr(_aAuxCot[_nI,01],_nInic,10)
					_cAux2	:= SubStr(_aAuxCot[_nI,02],_nInic2,40)
					
				EndDo
			Else
				_oReport:Line(_nLin-0020		,0015	,_nLin+0040																							,0015)
				_oReport:Line(_nLin-0020		,0115	,_nLin+0040																							,0115)
				_oReport:Line(_nLin-0020		,0315	,_nLin+0040																							,0315)
//				_oReport:Line(_nLin		,0715	,_nLin+0040																							,0715)
				_oReport:Line(_nLin-0020		,0915	,_nLin+0040																							,0915)
				_oReport:Line(_nLin-0020		,1015	,_nLin+0040																							,1015)
				_oReport:Line(_nLin-0020		,1300	,_nLin+0040																							,1300)
				_oReport:Line(_nLin-0020		,3350	,_nLin+0040																							,3350)
				_oReport:Line(_nLin-0020		,1527	,_nLin+0040																							,1527)
				_oReport:Line(_nLin-0020		,1754	,_nLin+0040																							,1754)
				_oReport:Line(_nLin-0020		,2210	,_nLin+0040																							,2210)
				_oReport:Line(_nLin-0020		,2437	,_nLin+0040																							,2437)
				_oReport:Line(_nLin-0020		,2893	,_nLin+0040																							,2893)
				_oReport:Line(_nLin-0020		,3120	,_nLin+0040																							,3120)
				
				_oReport:Line(_nLin-0020	,1983	,_nLin+0040																							,1983)
				_oReport:Line(_nLin-0020	,2666	,_nLin+0040																							,2666)
				_oReport:Line(_nLin-0020	,3350	,_nLin+0040																							,3350)
			
				_oReport:Say(_nLin+0010	,0020	,_aAuxCot[_nI,03]																					,_oFonte5)
				_oReport:Say(_nLin+0010	,0120	,_aAuxCot[_nI,01]																					,_oFonte5)
				_oReport:Say(_nLin+0010	,0320	,_aAuxCot[_nI,02]																					,_oFonte5)	
				_oReport:Say(_nLin+0010	,1135	,Transform(_aAuxCot[_nI,04],PesqPict("SC8","C8_QUANT"))											,_oFonte5)	
				_oReport:Say(_nLin+0010	,0920	,_aAuxCot[_nI,05]																					,_oFonte5)	
//				_oReport:Say(_nLin+0010	,1020	,_aAuxCot[_nI,06]																					,_oFonte5)	
				
			EndIf
			
			If _aAuxCot[_nI,10,1,27] == "S"
				_oReport:Say(_nLin+0010	,1315	,Transform(_aAuxCot[_nI,10,1,4],PesqPict("SC8","C8_PRECO"))										,_oFonte6)
				_oReport:Say(_nLin+0010	,1592	,Transform(Iif(SubStr(_aAuxCot[_nI,10,1,11],1,1)=="S",_aAuxCot[_nI,10,1,5],(_aAuxCot[_nI,10,1,5] - _aAuxCot[_nI,10,1,24])),PesqPict("SC8","C8_TOTAL"))										,_oFonte6)
				_oReport:Say(_nLin+0010	,1819	,Transform(_aAuxCot[_nI,10,1,5],PesqPict("SC8","C8_TOTAL"))										,_oFonte6)
			Else
				_oReport:Say(_nLin+0010	,1315	,Transform(_aAuxCot[_nI,10,1,4],PesqPict("SC8","C8_PRECO"))										,_oFonte5)
				_oReport:Say(_nLin+0010	,1592	,Transform(Iif(SubStr(_aAuxCot[_nI,10,1,11],1,1)=="S",_aAuxCot[_nI,10,1,5],(_aAuxCot[_nI,10,1,5] - _aAuxCot[_nI,10,1,24])),PesqPict("SC8","C8_TOTAL"))										,_oFonte5)
				_oReport:Say(_nLin+0010	,1819	,Transform(_aAuxCot[_nI,10,1,5],PesqPict("SC8","C8_TOTAL"))										,_oFonte5)
			EndIf
			
			If Len(_aAuxCot[_nI,10]) > 1
				If _aAuxCot[_nI,10,2,27] == "S"
					_oReport:Say(_nLin+0010	,1998	,Transform(_aAuxCot[_nI,10,2,4],PesqPict("SC8","C8_PRECO"))									,_oFonte6)
					_oReport:Say(_nLin+0010	,2275	,Transform(Iif(SubStr(_aAuxCot[_nI,10,2,11],1,1)=="S",_aAuxCot[_nI,10,2,5],(_aAuxCot[_nI,10,2,5] - _aAuxCot[_nI,10,2,24])),PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
					_oReport:Say(_nLin+0010	,2502	,Transform(_aAuxCot[_nI,10,2,5],PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
				Else
					_oReport:Say(_nLin+0010	,1998	,Transform(_aAuxCot[_nI,10,2,4],PesqPict("SC8","C8_PRECO"))									,_oFonte5)
					_oReport:Say(_nLin+0010	,2275	,Transform(Iif(SubStr(_aAuxCot[_nI,10,2,11],1,1)=="S",_aAuxCot[_nI,10,2,5],(_aAuxCot[_nI,10,2,5] - _aAuxCot[_nI,10,2,24])),PesqPict("SC8","C8_TOTAL"))									,_oFonte5)
					_oReport:Say(_nLin+0010	,2502	,Transform(_aAuxCot[_nI,10,2,5],PesqPict("SC8","C8_TOTAL"))									,_oFonte5)
				EndIf
			EndIf
			
			If Len(_aAuxCot[_nI,10]) > 2
				If _aAuxCot[_nI,10,3,27] == "S"
					_oReport:Say(_nLin+0010	,2681	,Transform(_aAuxCot[_nI,10,3,4],PesqPict("SC8","C8_PRECO"))									,_oFonte6)
					_oReport:Say(_nLin+0010	,2938	,Transform(Iif(SubStr(_aAuxCot[_nI,10,3,11],1,1)=="S",_aAuxCot[_nI,10,3,5],(_aAuxCot[_nI,10,3,5] - _aAuxCot[_nI,10,3,24])),PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
					_oReport:Say(_nLin+0010	,3185	,Transform(_aAuxCot[_nI,10,3,5],PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
				Else
					_oReport:Say(_nLin+0010	,2681	,Transform(_aAuxCot[_nI,10,3,4],PesqPict("SC8","C8_PRECO"))									,_oFonte5)
					_oReport:Say(_nLin+0010	,2938	,Transform(Iif(SubStr(_aAuxCot[_nI,10,3,11],1,1)=="S",_aAuxCot[_nI,10,3,5],(_aAuxCot[_nI,10,3,5] - _aAuxCot[_nI,10,3,24])),PesqPict("SC8","C8_TOTAL"))									,_oFonte5)
					_oReport:Say(_nLin+0010	,3185	,Transform(_aAuxCot[_nI,10,3,5],PesqPict("SC8","C8_TOTAL"))									,_oFonte5)
				EndIf
			EndIf
			
			_nLin += 30

			_oReport:Say(_nLin+0010	,0020	,"TES"																								,_oFonte5)
			_oReport:Say(_nLin+0010	,0120	,_aAuxCot[_nI,15]																					,_oFonte5)
			_oReport:Say(_nLin+0010	,0320	,GetAdvFval("SF4","F4_TEXTO",xFilial("SF4")+_aAuxCot[_nI,15],1)										,_oFonte5)	
			If _aAuxCot[_nI,10,1,27] == "S"
				_oReport:Say(_nLin+0010	,1819	,Transform(_aAuxCot[_nI,10,1,24]+_aAuxCot[_nI,10,1,17],PesqPict("SC8","C8_TOTAL"))										,_oFonte6)
			Else
				_oReport:Say(_nLin+0010	,1819	,Transform(_aAuxCot[_nI,10,1,24]+_aAuxCot[_nI,10,1,17],PesqPict("SC8","C8_TOTAL"))										,_oFonte5)
			EndIf
			If Len(_aAuxCot[_nI,10]) > 1
				If _aAuxCot[_nI,10,2,27] == "S"
					_oReport:Say(_nLin+0010	,2502	,Transform(_aAuxCot[_nI,10,2,24]+_aAuxCot[_nI,10,2,17],PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
				Else
					_oReport:Say(_nLin+0010	,2502	,Transform(_aAuxCot[_nI,10,2,24]+_aAuxCot[_nI,10,2,17],PesqPict("SC8","C8_TOTAL"))									,_oFonte5)
				EndIf
			EndIf
			
			If Len(_aAuxCot[_nI,10]) > 2
				If _aAuxCot[_nI,10,3,27] == "S"
					_oReport:Say(_nLin+0010	,3185	,Transform(_aAuxCot[_nI,10,3,24]+_aAuxCot[_nI,10,3,17],PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
				Else
					_oReport:Say(_nLin+0010	,3185	,Transform(_aAuxCot[_nI,10,3,24]+_aAuxCot[_nI,10,3,17],PesqPict("SC8","C8_TOTAL"))									,_oFonte5)
				EndIf
			EndIf
			
			_nLin += 30
            
			cConta:=GetAdvFval("SB1","B1_CONTA",xFilial("SB1")+_aAuxCot[_nI,01],1)
			_oReport:Say(_nLin+0010	,0020	,"C.Contabil"																						,_oFonte5)
			_oReport:Say(_nLin+0010	,0120	,cConta																								,_oFonte5)
			_oReport:Say(_nLin+0010	,0320	,GetAdvFval("CT1","CT1_DESC01",xFilial("CT1")+cConta,1)												,_oFonte5)	

			_nLin += 40
			_oReport:Line(_nLin	,0015	,_nLin																								,3350)
			
			If 	_nLin >= 1430
/*			
				_oReport:Line(_nLin		,0015	,_nLin+0040																							,0015)
				_oReport:Line(_nLin		,0115	,_nLin+0040																							,0115)
				_oReport:Line(_nLin		,0315	,_nLin+0040																							,0315)
//				_oReport:Line(_nLin		,0715	,_nLin+0040																							,0715)
				_oReport:Line(_nLin		,0915	,_nLin+0040																							,0915)
				_oReport:Line(_nLin		,1015	,_nLin+0040																							,1015)
				_oReport:Line(_nLin		,1300	,_nLin+0040																							,1300)
				_oReport:Line(_nLin		,3350	,_nLin+0040																							,3350)
				_oReport:Line(_nLin		,1527	,_nLin+0040																							,1527)
				_oReport:Line(_nLin		,1754	,_nLin+0040																							,1754)
				_oReport:Line(_nLin		,2210	,_nLin+0040																							,2210)
				_oReport:Line(_nLin		,2437	,_nLin+0040																							,2437)
				_oReport:Line(_nLin		,2893	,_nLin+0040																							,2893)
				_oReport:Line(_nLin		,3120	,_nLin+0040																							,3120)
				
				_oReport:Line(_nLin	,1983	,_nLin+0040																							,1983)
				_oReport:Line(_nLin	,2666	,_nLin+0040																							,2666)
				_oReport:Line(_nLin	,3350	,_nLin+0040																							,3350)
*/				
				If (_nI+1) < Len(_aAuxCot)
					If _cIndice <> _aAuxCot[_nI+1,13]
						_lImpR	:= .T.
					EndIf
				Else
					If _nLin >= 1950 
						_lImpR	:= .T.
					EndIf
				EndIf
				
				If _lImpR
					_lImpR	:= .F.
					_oReport:EndPage()
					_oReport:StartPage()
					_nLin := 0050		
					nlLin := 0050		
					_oReport:Saybitmap(0080,0040, "lgrl" + cEmpAnt + ".BMP",0180,0120,)
					_oReport:Say(0120		,0482	,_cTitulo																							,_oFonte1)
					_oReport:Line(nlLin		,0015	,nlLin																								,1300)
					_oReport:Line(nlLin		,0015	,nlLin + 0200																						,0015)
					_oReport:Line(nlLin		,1300	,nlLin + 0240																						,1300)
					
					_oReport:Line(nlLin		,1300	,nlLin																								,3350)
					_oReport:Line(nlLin+0040,1300	,nlLin+0040																							,2666)
					_oReport:Line(nlLin+0080,1300	,nlLin+0080																							,1700)
					_oReport:Line(nlLin+0040,1700	,nlLin+0080																							,1700)
					_oReport:Line(nlLin		,1500	,nlLin + 0080																						,1500)
					_oReport:Line(nlLin		,2666	,nlLin + 0120																						,2666)
					_oReport:Line(nlLin		,2923	,nlLin+0120																							,2923)
					_oReport:Line(nlLin+0060,2666	,nlLin+0060																							,3350)
					_oReport:Line(nlLin+0120,2666	,nlLin+0120																							,3350)
					
					_oReport:Say(nlLin+0010	,1305	,"Cliente"																							,_oFonte5)
					_oReport:Say(nlLin+0050	,1305	,"Emiss„o"																							,_oFonte5)
				    _oReport:Say(nlLin+0010	,1505	,_aAuxCot[_nI,07]																					,_oFonte5)
				    _oReport:Say(nlLin+0050	,1505	,SubStr(DtoS(Date()),7,2) + "/" + SubStr(DtoS(Date()),5,2) + "/" + SubStr(DtoS(Date()),1,4)			,_oFonte5)
				    
				    _oReport:Say(nlLin+0010	,2671	,"R$ OrÁado"																						,_oFonte8)
				    _oReport:Say(nlLin+0060	,2671	,"Saving"																							,_oFonte8)
				                                                                                                                                                  
				    _oReport:Say(nlLin+0010	,2928	,Transform(_aAuxCot[_nI,08],PesqPict("SC8","C8_XCOST"))											,_oFonte2)
				    _oReport:Say(nlLin+0060	,2928	,Transform(_aAuxCot[_nI,09],PesqPict("SC8","C8_XSAVING"))											,_oFonte2)
				    
					_oReport:Line(nlLin+210	,0015	,nlLin+210																							,0270)
					_oReport:Line(nlLin		,0270	,nlLin + 0210																						,0270)
					_oReport:Line(nlLin		,3350	,nlLin + 0210																						,3350)
					
					_oReport:Line(nlLin+200	,1300	,nlLin+200																							,3350)
					_oReport:Say(nlLin+0210	,2105	,"EMPRESAS PROPONENTES"																				,_oFonte6)
					_oReport:Line(nlLin+240	,1300	,nlLin+240																							,3350)
					_oReport:Line(nlLin+200	,3350	,nlLin+240																							,3350)
					
					//1∫ Fornecedor
					_oReport:Line(nlLin+240	,1983	,nlLin+1310																							,1983)
					_oReport:Line(nlLin+240	,2666	,nlLin+1310																							,2666)
					_oReport:Line(nlLin+240	,3350	,nlLin+1310																							,3350)
			
					_oReport:Say(nlLin+0250	,1305	,"Fornecedor: " + _aAuxCot[_nI,10,1,3]																					,_oFonte5)
					_oReport:Line(nlLin+280	,1300	,nlLin+280																							,3350)
					_oReport:Say(nlLin+0290	,1305	,"Contato: " + _aAuxCot[_nI,10,1,9]																							,_oFonte5)
					_oReport:Say(nlLin+0330	,1305	,"Tel.: " + _aAuxCot[_nI,10,1,10]																							,_oFonte5)
					_oReport:Line(nlLin+360	,1300	,nlLin+360																							,3350)
					_oReport:Say(nlLin+0370	,1305	,"R$ UNITARIO"																						,_oFonte5)
					_oReport:Line(nlLin+360	,1527	,nlLin+1310																							,1527)
					_oReport:Say(nlLin+0370	,1532	,"R$ TOT. S/ IMP"																					,_oFonte5)
					_oReport:Line(nlLin+360	,1754	,nlLin+1310																							,1754)
					_oReport:Say(nlLin+0370	,1759	,"R$ TOT. C/ IMP"																					,_oFonte5)
					_oReport:Line(nlLin+400	,1300	,nlLin+400																							,3350)
					
					//2∫ Fornecedor
					_oReport:Say(nlLin+0250	,1988	,"Fornecedor: " + Iif(Len(_aAuxCot[_nI,10])>1,_aAuxCot[_nI,10,2,3],"")																						,_oFonte5)
					_oReport:Say(nlLin+0290	,1988	,"Contato: " + Iif(Len(_aAuxCot[_nI,10])>1,_aAuxCot[_nI,10,2,9],"")																							,_oFonte5)
					_oReport:Say(nlLin+0330	,1988	,"Tel.: " + Iif(Len(_aAuxCot[_nI,10])>1,_aAuxCot[_nI,10,2,10],"")																							,_oFonte5)
					_oReport:Say(nlLin+0370	,1988	,"R$ UNITARIO"																						,_oFonte5)
					_oReport:Line(nlLin+360	,2210	,nlLin+1310																							,2210)
					_oReport:Say(nlLin+0370	,2215	,"R$ TOT. S/ IMP"																					,_oFonte5)
					_oReport:Line(nlLin+360	,2437	,nlLin+1310																							,2437)
					_oReport:Say(nlLin+0370	,2442	,"R$ TOT. C/ IMP"																					,_oFonte5)
					
					//3∫ Fornecedor
					_oReport:Say(nlLin+0250	,2671	,"Fornecedor: " + Iif(Len(_aAuxCot[_nI,10])>2,_aAuxCot[_nI,10,3,3],"")																					,_oFonte5)
					_oReport:Say(nlLin+0290	,2671	,"Contato: " + Iif(Len(_aAuxCot[_nI,10])>2,_aAuxCot[_nI,10,3,9],"")																							,_oFonte5)
					_oReport:Say(nlLin+0330	,2671	,"Tel.: " + Iif(Len(_aAuxCot[_nI,10])>2,_aAuxCot[_nI,10,3,10],"")																							,_oFonte5)
					_oReport:Say(nlLin+0370	,2671	,"R$ UNITARIO"																						,_oFonte5)
					_oReport:Line(nlLin+360	,2893	,nlLin+1310																							,2893)
					_oReport:Say(nlLin+0370	,2898	,"R$ TOT. S/ IMP"																					,_oFonte5)
					_oReport:Line(nlLin+360	,3120	,nlLin+1310																							,3120)
					_oReport:Say(nlLin+0370	,3125	,"R$ TOT. C/ IMP"																					,_oFonte5)
					
					nlLin+=200
					_oReport:Say(nlLin+010	,0020	,"N∫ " + _aAuxCot[_nI,12]																								,_oFonte6)
					_oReport:Line(nlLin		,0015	,nlLin + 0040																						,0015)
					_oReport:Line(nlLin		,0270	,nlLin + 0040																						,0270)
					
					nlLin+=040
					
					_oReport:Line(nlLin		,0015	,nlLin																								,1300)
					_oReport:Line(nlLin		,0015	,nlLin+1070																							,0015)
					_oReport:Line(nlLin		,0115	,nlLin+1070																							,0115)
					_oReport:Line(nlLin		,0315	,nlLin+1070																							,0315)
	//				_oReport:Line(nlLin		,0715	,nlLin+1070																							,0715)
					_oReport:Line(nlLin		,0915	,nlLin+1070																							,0915)
					_oReport:Line(nlLin		,1015	,nlLin+1070																							,1015)
					_oReport:Line(nlLin		,1300	,nlLin+1070																							,1300)
					
					_oReport:Say(nlLin+0060	,0045	,"Item"																								,_oFonte5)
					_oReport:Say(nlLin+0060	,0200	,"Codigo"																							,_oFonte5)
					_oReport:Say(nlLin+0060	,0500	,"DescriÁ„o"																						,_oFonte5)	
					_oReport:Say(nlLin+0060	,0790	,"Qtde."																							,_oFonte5)	
					_oReport:Say(nlLin+0060	,0945	,"UM"																								,_oFonte5)	
					_oReport:Say(nlLin+0060	,1135	,"PN"																								,_oFonte5)	
					_oReport:Line(nlLin+160	,0015	,nlLin+160																							,1300)
					_nLin	:= nlLin+160
				EndIf
	
			EndIf
			
			If _nI == Len(_aAuxCot)
				If _nLin >= 1430
					_oReport:EndPage()
					_oReport:StartPage()
					_nLin := 0050		
					nlLin := 0050		
					_oReport:Saybitmap(0080,0040, "lgrl" + cEmpAnt + ".BMP",0180,0120,)
					_oReport:Say(0120		,0482	,_cTitulo																							,_oFonte1)
					_oReport:Line(nlLin		,0015	,nlLin																								,1300)
					_oReport:Line(nlLin		,0015	,nlLin + 0200																						,0015)
					_oReport:Line(nlLin		,1300	,nlLin + 0240																						,1300)
					
					_oReport:Line(nlLin		,1300	,nlLin																								,3350)
					_oReport:Line(nlLin+0040,1300	,nlLin+0040																							,2666)
					_oReport:Line(nlLin+0080,1300	,nlLin+0080																							,1700)
					_oReport:Line(nlLin+0040,1700	,nlLin+0080																							,1700)
					_oReport:Line(nlLin		,1500	,nlLin + 0080																						,1500)
					_oReport:Line(nlLin		,2666	,nlLin + 0120																						,2666)
					_oReport:Line(nlLin		,2923	,nlLin+0120																							,2923)
					_oReport:Line(nlLin+0060,2666	,nlLin+0060																							,3350)
					_oReport:Line(nlLin+0120,2666	,nlLin+0120																							,3350)
					
					_oReport:Say(nlLin+0010	,1305	,"Cliente"																							,_oFonte5)
					_oReport:Say(nlLin+0050	,1305	,"Emiss„o"																							,_oFonte5)
				    _oReport:Say(nlLin+0010	,1505	,_aAuxCot[_nI,07]																					,_oFonte5)
				    _oReport:Say(nlLin+0050	,1505	,SubStr(DtoS(Date()),7,2) + "/" + SubStr(DtoS(Date()),5,2) + "/" + SubStr(DtoS(Date()),1,4)			,_oFonte5)
				    
				    _oReport:Say(nlLin+0010	,2671	,"R$ OrÁado"																						,_oFonte8)
				    _oReport:Say(nlLin+0060	,2671	,"Saving"																							,_oFonte8)
				                                                                                                                                                  
				    _oReport:Say(nlLin+0010	,2928	,Transform(_aAuxCot[_nI,08],PesqPict("SC8","C8_XCOST"))											,_oFonte2)
				    _oReport:Say(nlLin+0060	,2928	,Transform(_aAuxCot[_nI,09],PesqPict("SC8","C8_XSAVING"))											,_oFonte2)
				    
					_oReport:Line(nlLin+210	,0015	,nlLin+210																							,0270)
					_oReport:Line(nlLin		,0270	,nlLin + 0210																						,0270)
					_oReport:Line(nlLin		,3350	,nlLin + 0210																						,3350)
					
					_oReport:Line(nlLin+200	,1300	,nlLin+200																							,3350)
					_oReport:Say(nlLin+0210	,2105	,"EMPRESAS PROPONENTES"																				,_oFonte6)
					_oReport:Line(nlLin+240	,1300	,nlLin+240																							,3350)
					_oReport:Line(nlLin+200	,3350	,nlLin+240																							,3350)
					
					//1∫ Fornecedor
					_oReport:Line(nlLin+240	,1983	,nlLin+1310																							,1983)
					_oReport:Line(nlLin+240	,2666	,nlLin+1310																							,2666)
					_oReport:Line(nlLin+240	,3350	,nlLin+1310																							,3350)
			
					_oReport:Say(nlLin+0250	,1305	,"Fornecedor: " + _aAuxCot[_nI,10,1,3]																					,_oFonte5)
					_oReport:Line(nlLin+280	,1300	,nlLin+280																							,3350)
					_oReport:Say(nlLin+0290	,1305	,"Contato: " + _aAuxCot[_nI,10,1,9]																							,_oFonte5)
					_oReport:Say(nlLin+0330	,1305	,"Tel.: " + _aAuxCot[_nI,10,1,10]																							,_oFonte5)
					_oReport:Line(nlLin+360	,1300	,nlLin+360																							,3350)
					_oReport:Say(nlLin+0370	,1305	,"R$ UNITARIO"																						,_oFonte5)
					_oReport:Line(nlLin+360	,1527	,nlLin+1310																							,1527)
					_oReport:Say(nlLin+0370	,1532	,"R$ TOT. S/ IMP"																					,_oFonte5)
					_oReport:Line(nlLin+360	,1754	,nlLin+1310																							,1754)
					_oReport:Say(nlLin+0370	,1759	,"R$ TOT. C/ IMP"																					,_oFonte5)
					_oReport:Line(nlLin+400	,1300	,nlLin+400																							,3350)
					
					//2∫ Fornecedor
					_oReport:Say(nlLin+0250	,1988	,"Fornecedor: " + Iif(Len(_aAuxCot[_nI,10])>1,_aAuxCot[_nI,10,2,3],"")																						,_oFonte5)
					_oReport:Say(nlLin+0290	,1988	,"Contato: " + Iif(Len(_aAuxCot[_nI,10])>1,_aAuxCot[_nI,10,2,9],"")																							,_oFonte5)
					_oReport:Say(nlLin+0330	,1988	,"Tel.: " + Iif(Len(_aAuxCot[_nI,10])>1,_aAuxCot[_nI,10,2,10],"")																							,_oFonte5)
					_oReport:Say(nlLin+0370	,1988	,"R$ UNITARIO"																						,_oFonte5)
					_oReport:Line(nlLin+360	,2210	,nlLin+1310																							,2210)
					_oReport:Say(nlLin+0370	,2215	,"R$ TOT. S/ IMP"																					,_oFonte5)
					_oReport:Line(nlLin+360	,2437	,nlLin+1310																							,2437)
					_oReport:Say(nlLin+0370	,2442	,"R$ TOT. C/ IMP"																					,_oFonte5)
					
					//3∫ Fornecedor
					_oReport:Say(nlLin+0250	,2671	,"Fornecedor: " + Iif(Len(_aAuxCot[_nI,10])>2,_aAuxCot[_nI,10,3,3],"")																					,_oFonte5)
					_oReport:Say(nlLin+0290	,2671	,"Contato: " + Iif(Len(_aAuxCot[_nI,10])>2,_aAuxCot[_nI,10,3,9],"")																							,_oFonte5)
					_oReport:Say(nlLin+0330	,2671	,"Tel.: " + Iif(Len(_aAuxCot[_nI,10])>2,_aAuxCot[_nI,10,3,10],"")																							,_oFonte5)
					_oReport:Say(nlLin+0370	,2671	,"R$ UNITARIO"																						,_oFonte5)
					_oReport:Line(nlLin+360	,2893	,nlLin+1310																							,2893)
					_oReport:Say(nlLin+0370	,2898	,"R$ TOT. S/ IMP"																					,_oFonte5)
					_oReport:Line(nlLin+360	,3120	,nlLin+1310																							,3120)
					_oReport:Say(nlLin+0370	,3125	,"R$ TOT. C/ IMP"																					,_oFonte5)
					
					nlLin+=200
					_oReport:Say(nlLin+010	,0020	,"N∫ " + _aAuxCot[_nI,12]																								,_oFonte6)
					_oReport:Line(nlLin		,0015	,nlLin + 0040																						,0015)
					_oReport:Line(nlLin		,0270	,nlLin + 0040																						,0270)
					
					nlLin+=040
					
					_oReport:Line(nlLin		,0015	,nlLin																								,1300)
					_oReport:Line(nlLin		,0015	,nlLin+1070																							,0015)
					_oReport:Line(nlLin		,0115	,nlLin+1070																							,0115)
					_oReport:Line(nlLin		,0315	,nlLin+1070																							,0315)
	//				_oReport:Line(nlLin		,0715	,nlLin+1070																							,0715)
					_oReport:Line(nlLin		,0915	,nlLin+1070																							,0915)
					_oReport:Line(nlLin		,1015	,nlLin+1070																							,1015)
					_oReport:Line(nlLin		,1300	,nlLin+1070																							,1300)
					
					_oReport:Say(nlLin+0060	,0045	,"Item"																								,_oFonte5)
					_oReport:Say(nlLin+0060	,0200	,"Codigo"																							,_oFonte5)
					_oReport:Say(nlLin+0060	,0500	,"DescriÁ„o"																						,_oFonte5)	
					_oReport:Say(nlLin+0060	,0790	,"Qtde."																							,_oFonte5)	
					_oReport:Say(nlLin+0060	,0945	,"UM"																								,_oFonte5)	
					_oReport:Say(nlLin+0060	,1135	,"PN"																								,_oFonte5)	
					_oReport:Line(nlLin+160	,0015	,nlLin+160																							,1300)
					_nLin	:= nlLin+160
				EndIF
				_fRodPe(_NI,_cComprador,_cGerSup,_cDiretoria)
				_lRodPe := .F.
			EndIf 
			
		EndIf
		
		_cIndice :=  _aAuxCot[_nI,14]
		
	Next _nI
	
	If nlLin > 0050 .and. _lRodPe
		_nI--
		_fRodPe(_NI,_cComprador,_cGerSup,_cDiretoria)
	EndIf
	
	(_cAliasTmp)->(dbCloseArea())

	_oReport:Preview()
 	MS_FLUSH()
 	
Return()                                   

Static Function _fRodPe(_NI,_cComprador,_cGerSup,_cDiretoria)

	Local _cObs		:= ""
	Local _nlLin	:= 0
	Local _cAux		:= ""
	Local _nInic

	nlLin+=1070
	_oReport:Line(nlLin		,0015	,nlLin + 0850																						,0015)
	_oReport:Line(nlLin		,1300	,nlLin + 0600																						,1300)
	_oReport:Line(nlLin		,1983	,nlLin+0600																							,1983)
	_oReport:Line(nlLin		,2666	,nlLin+0600																							,2666)
	_oReport:Line(nlLin		,3350	,nlLin+0850																							,3350)
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0580	,"TOTAL COM IMPOSTOS"																				,_oFonte6)	
	_oReport:Say(nlLin+0010	,1532	,Transform(_nTotI1,PesqPict("SC8","C8_TOTAL"))										,_oFonte6)
	
	If Len(_aAuxCot[_nI,10]) > 1
		_oReport:Say(nlLin+0010	,2215	,Transform(_nTotI2,PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
	EndIf
	
	If Len(_aAuxCot[_nI,10]) > 2
		_oReport:Say(nlLin+0010	,2898	,Transform(_nTotI3,PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
	EndIf
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0530	,"REGIME DE TRIBUTA«√O - IMPOSTOS"																				,_oFonte5)	
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0020	,"SIMPLES NACIONAL"																				,_oFonte5)	
	
	_oReport:Say(nlLin+0010	,1641	,_aAuxCot[_nI,10,1,11]										,_oFonte5)
	
	If Len(_aAuxCot[_nI,10]) > 1
		_oReport:Say(nlLin+0010	,2324	,_aAuxCot[_nI,10,2,11]										,_oFonte5)
	EndIf
	
	If Len(_aAuxCot[_nI,10]) > 2
		_oReport:Say(nlLin+0010	,3007	,_aAuxCot[_nI,10,3,11]										,_oFonte5)
	EndIf
	
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0020	,"LUCRO REAL/LUCRO PRESUMIDO"																				,_oFonte5)	
	_oReport:Say(nlLin+0010	,1646	,Iif(SubStr(_aAuxCot[_nI,10,1,11],1,1)=="S","","X")										,_oFonte5)
	
	If Len(_aAuxCot[_nI,10]) > 1
		_oReport:Say(nlLin+0010	,2329	,Iif(SubStr(_aAuxCot[_nI,10,2,11],1,1)=="S","","X")										,_oFonte5)
	EndIf
	
	If Len(_aAuxCot[_nI,10]) > 2
		_oReport:Say(nlLin+0010	,3012	,Iif(SubStr(_aAuxCot[_nI,10,3,11],1,1)=="S","","X")										,_oFonte5)
	EndIf
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0020	,"ICMS"																				,_oFonte5)	
	_oReport:Say(nlLin+0010	,1305	,Transform(_aAuxCot[_nI,10,1,18],PesqPict("SC8","C8_PICM"))										,_oFonte5)
	_oReport:Say(nlLin+0010	,1645	,"="																								,_oFonte5)
	_oReport:Say(nlLin+0010	,1759	,Transform(_nTICM1,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	
	If Len(_aAuxCot[_nI,10]) > 1
		_oReport:Say(nlLin+0010	,1988	,Transform(_aAuxCot[_nI,10,2,18],PesqPict("SC8","C8_PICM"))										,_oFonte5)
		_oReport:Say(nlLin+0010	,2328	,"="										,_oFonte5)
		_oReport:Say(nlLin+0010	,2442	,Transform(_nTICM2,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	EndIf
	
	If Len(_aAuxCot[_nI,10]) > 2
		_oReport:Say(nlLin+0010	,2671	,Transform(_aAuxCot[_nI,10,3,18],PesqPict("SC8","C8_PICM"))										,_oFonte5)
		_oReport:Say(nlLin+0010	,3011	,"="															,_oFonte5)
		_oReport:Say(nlLin+0010	,3125	,Transform(_nTICM3,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	EndIf
	
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0020	,"IPI"																				,_oFonte5)	
	_oReport:Say(nlLin+0010	,1305	,Transform(_aAuxCot[_nI,10,1,19],PesqPict("SC8","C8_PICM"))										,_oFonte5)
	_oReport:Say(nlLin+0010	,1645	,"="																								,_oFonte5)
	_oReport:Say(nlLin+0010	,1759	,Transform(_nTIPI1,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	
	If Len(_aAuxCot[_nI,10]) > 1
		_oReport:Say(nlLin+0010	,1988	,Transform(_aAuxCot[_nI,10,2,19],PesqPict("SC8","C8_PICM"))										,_oFonte5)
		_oReport:Say(nlLin+0010	,2328	,"="																								,_oFonte5)
		_oReport:Say(nlLin+0010	,2442	,Transform(_nTIPI2,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	EndIf
	
	If Len(_aAuxCot[_nI,10]) > 2
		_oReport:Say(nlLin+0010	,2671	,Transform(_aAuxCot[_nI,10,3,19],PesqPict("SC8","C8_PICM"))										,_oFonte5)
		_oReport:Say(nlLin+0010	,3011	,"="																								,_oFonte5)
		_oReport:Say(nlLin+0010	,3125	,Transform(_nTIPI3,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	EndIf
	
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0020	,"COFINS"																				,_oFonte5)	
	
	_oReport:Say(nlLin+0010	,1305	,Transform(_aAuxCot[_nI,10,1,21],PesqPict("SC8","C8_PICM"))										,_oFonte5)
	_oReport:Say(nlLin+0010	,1645	,"="																								,_oFonte5)
	_oReport:Say(nlLin+0010	,1759	,Transform(_nTCOF1,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	
	If Len(_aAuxCot[_nI,10]) > 1
		_oReport:Say(nlLin+0010	,1988	,Transform(_aAuxCot[_nI,10,2,21],PesqPict("SC8","C8_PICM"))										,_oFonte5)
		_oReport:Say(nlLin+0010	,2328	,"="																								,_oFonte5)
		_oReport:Say(nlLin+0010	,2442	,Transform(_nTCOF2,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	EndIf
	
	If Len(_aAuxCot[_nI,10]) > 2
		_oReport:Say(nlLin+0010	,2671	,Transform(_aAuxCot[_nI,10,3,21],PesqPict("SC8","C8_PICM"))										,_oFonte5)
		_oReport:Say(nlLin+0010	,3011	,"="																								,_oFonte5)
		_oReport:Say(nlLin+0010	,3125	,Transform(_nTCOF3,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	EndIf
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0020	,"PIS"																				,_oFonte5)	
	_oReport:Say(nlLin+0010	,1305	,Transform(_aAuxCot[_nI,10,1,14],PesqPict("SC8","C8_PICM"))										,_oFonte5)
	_oReport:Say(nlLin+0010	,1645	,"="																								,_oFonte5)
	_oReport:Say(nlLin+0010	,1759	,Transform(_nTPIS1,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	
	If Len(_aAuxCot[_nI,10]) > 1
		_oReport:Say(nlLin+0010	,1988	,Transform(_aAuxCot[_nI,10,2,14],PesqPict("SC8","C8_PICM"))										,_oFonte5)
		_oReport:Say(nlLin+0010	,2328	,"="																								,_oFonte5)
		_oReport:Say(nlLin+0010	,2442	,Transform(_nTPIS2,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	EndIf
	
	If Len(_aAuxCot[_nI,10]) > 2
		_oReport:Say(nlLin+0010	,2671	,Transform(_aAuxCot[_nI,10,3,14],PesqPict("SC8","C8_PICM"))										,_oFonte5)
		_oReport:Say(nlLin+0010	,3011	,"="																								,_oFonte5)
		_oReport:Say(nlLin+0010	,3125	,Transform(_nTPIS3,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	EndIf
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0020	,"ICMS ST"																				,_oFonte5)	
	_oReport:Say(nlLin+0010	,1305	,Transform(_aAuxCot[_nI,10,1,17],PesqPict("SC8","C8_PICM"))										,_oFonte5)
	_oReport:Say(nlLin+0010	,1645	,"="																								,_oFonte5)
	_oReport:Say(nlLin+0010	,1759	,Transform(_nTICMS1,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	
	If Len(_aAuxCot[_nI,10]) > 1
		_oReport:Say(nlLin+0010	,1988	,Transform(_aAuxCot[_nI,10,2,17],PesqPict("SC8","C8_PICM"))										,_oFonte5)
		_oReport:Say(nlLin+0010	,2328	,"="																								,_oFonte5)
		_oReport:Say(nlLin+0010	,2442	,Transform(_nTICMS2,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	EndIf
	
	If Len(_aAuxCot[_nI,10]) > 2
		_oReport:Say(nlLin+0010	,2671	,Transform(_aAuxCot[_nI,10,3,17],PesqPict("SC8","C8_PICM"))										,_oFonte5)
		_oReport:Say(nlLin+0010	,3011	,"="																								,_oFonte5)
		_oReport:Say(nlLin+0010	,3125	,Transform(_nTICMS3,PesqPict("SC8","C8_VALICM"))										,_oFonte5)
	EndIf
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0630	,"TOTAL"																				,_oFonte6)	
	_oReport:Say(nlLin+0010	,1532	,Transform(_nTotSI1,PesqPict("SC8","C8_TOTAL"))										,_oFonte6)
	
	If Len(_aAuxCot[_nI,10]) > 1
		_oReport:Say(nlLin+0010	,2215	,Transform(_nTotSI2,PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
	EndIf
	
	If Len(_aAuxCot[_nI,10]) > 2
		_oReport:Say(nlLin+0010	,2898	,Transform(_nTotSI3,PesqPict("SC8","C8_TOTAL"))									,_oFonte6)
	EndIf
	nlLin+=040
	_oReport:Line(nlLin		,0355	,nlLin + 0200																						,0355)
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0020	,"CONDI«’ES COMERCIAIS:"																				,_oFonte5)	
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0020	,"N⁄MERO DA PROPOSTA"																				,_oFonte5)	
	
	_oReport:Say(nlLin+0010	,1305	,_aAuxCot[_nI,10,1,6] 										,_oFonte5)
	_oReport:Say(nlLin+0010	,1759	,Transform(_nFrete1,PesqPict("SC8","C8_TOTFRE"))										,_oFonte5)
	
	If Len(_aAuxCot[_nI,10]) > 1
		_oReport:Say(nlLin+0010	,1988	,_aAuxCot[_nI,10,2,6]										,_oFonte5)
		_oReport:Say(nlLin+0010	,2442	,Transform(_nFrete2,PesqPict("SC8","C8_TOTFRE"))										,_oFonte5)
	EndIf
	
	If Len(_aAuxCot[_nI,10]) > 2
		_oReport:Say(nlLin+0010	,2671	,_aAuxCot[_nI,10,3,6]										,_oFonte5)
		_oReport:Say(nlLin+0010	,3125	,Transform(_nFrete3,PesqPict("SC8","C8_TOTFRE"))										,_oFonte5)
	EndIf
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0020	,"PRAZO DO CONTRATO"																				,_oFonte5)	
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0020	,"PRAZO DE ENTREGA"																				,_oFonte5)	
	
	_oReport:Say(nlLin+0010	,1305	,Alltrim(Str(_aAuxCot[_nI,10,1,7])) + Iif(_aAuxCot[_nI,10,1,7]>1," dias "," dia")										,_oFonte5)
	
	If Len(_aAuxCot[_nI,10]) > 1
		_oReport:Say(nlLin+0010	,1988	,Alltrim(Str(_aAuxCot[_nI,10,2,7])) + Iif(_aAuxCot[_nI,10,2,7]>1," dias "," dia")										,_oFonte5)
	EndIf
	
	If Len(_aAuxCot[_nI,10]) > 2
		_oReport:Say(nlLin+0010	,2671	,Alltrim(Str(_aAuxCot[_nI,10,2,7])) + Iif(_aAuxCot[_nI,10,2,7]>1," dias "," dia")										,_oFonte5)
	EndIf
	
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Say(nlLin+0010	,0020	,"CONDI«√O DE PGTO."																				,_oFonte5)	
	
	_oReport:Say(nlLin+0010	,1305	,_aAuxCot[_nI,10,1,8]										,_oFonte5)
	
	If Len(_aAuxCot[_nI,10]) > 1
		_oReport:Say(nlLin+0010	,1988	,_aAuxCot[_nI,10,2,8]										,_oFonte5)
	EndIf
	
	If Len(_aAuxCot[_nI,10]) > 2
		_oReport:Say(nlLin+0010	,2671	,_aAuxCot[_nI,10,2,8]										,_oFonte5)
	EndIf
	nlLin+=040
	_oReport:Line(nlLin		,0015	,nlLin																								,3350)
	_oReport:Line(nlLin		,3350	,nlLin + 0250												,3350)
	_oReport:Say(nlLin+0010	,0020	,"OBSERVA«’ES:"																				,_oFonte5)	
	
	_cObserv := _aAuxCot[_nI,13]
	
	While .T.
		_cAT   := AT(CHR(13)+CHR(10),_cObserv)
		_cAux2 := AllTrim(SubStr(_cObserv,1,_cAT))	
		_cObserv:=AllTrim(SubStr(_cObserv,_cAT+1)) + " " 
		If Empty(_cObserv)
			Exit
		Endif
	Enddo
//	If Len(_aAuxCot[_nI,13]) > 330
		_nlLin	:= nlLin+0040
		_nInic	:= 1
		
		_cAux	:= AllTrim(SubStr(_aAuxCot[_nI,13],_nInic,330))
		
		While !Empty(_cAux)
			_oReport:Say(_nlLin	,0020	,_cAux																				,_oFonte8)	
			_nlLin+=20
			_nInic	+= 330
			_cAux	:= SubStr(_aAuxCot[_nI,13],_nInic,330)
		EndDo					
//	Else
//		_nlLin	:= nlLin+0040
//		_oReport:Say(_nlLin	,0020	,AllTrim(_aAuxCot[_nI,13])																,_oFonte8)	
//	EndIf
	
	nlLin:=2210
	_oReport:Line(nlLin		,0015	,nlLin														,3350)
	_oReport:Line(nlLin		,0015	,nlLin + 0150												,0015)
	_oReport:Line(nlLin		,3350	,nlLin + 0150												,3350)
	
	_oReport:Say(nlLin+0010	,0025	,"Comprador"												,_oFonte6)
	_oReport:Say(nlLin+0060	,0025	,_cComprador												,_oFonte5)
	
	_oReport:Line(nlLin		,1153	,nlLin + 0150												,1153)

	_oReport:Say(nlLin+0010	,1163	,"Gerente de Suprimentos"									,_oFonte6)
	_oReport:Say(nlLin+0060	,1163	,_cGerSup													,_oFonte5)
	
	_oReport:Line(nlLin		,2256	,nlLin + 0150												,2256)
	_oReport:Say(nlLin+0010	,2266	,"Diretoria"												,_oFonte6)
	_oReport:Say(nlLin+0060	,2266	,_cDiretoria												,_oFonte5)
	
	nlLin+=0150
	_oReport:Line(nlLin		,0015	,nlLin														,3350)
	_oReport:EndPage()

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fQryTmp
FunÁ„o para filtro da analise de cotaÁıes conforme preenchimento dos par‚metros.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		24/07/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fQryTmp(_cAliasTmp)

	Local _cQuery	:= ""
	
 	_cQuery := "SELECT DISTINCT	SC8.C8_FILIAL, SC8.C8_NUM "
 	_cQuery += " FROM "+RetSqlName("SC8")+" SC8 "
 	
 	_cQuery += " WHERE "
 	_cQuery += " SC8.C8_FILIAL='"+xFilial("SC8")+"' AND SC8.D_E_L_E_T_=' ' AND "
 	_cQuery += "SC8.C8_NUM >= '" + mv_par01 + "' AND SC8.C8_NUM <= '" + mv_par02 + "' "

	_cQuery += " ORDER BY SC8.C8_NUM "
	TcQuery _cQuery New Alias &(_cAliasTmp)
	
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} _fQryCot
FunÁ„o para filtro dos recursos da CotaÁ„o conforme preenchimento dos par‚metros.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		22/07/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function _fQryCot(_cNumCot)

	Local _cAliasCot 	:= GetNextAlias()
	Local _cQuery		:= ""
	Local _cProduto		:= ""
	Local _cCliente		:= ""
	Local _lOk			:= .F.	
	Local nlLin			:= 0050
	Local _nLin			:= 0050
	Local _nPos			:= 0
	Local _nPos1		:= 0
	Local _nPos2		:= 0
	Local _cIcm			:= ""
	Local _cIPI			:= ""
	Local cTes			:= ""
	Local nValIPI		:= 0
	Local nValICM		:= 0
	Local nValPIS		:= 0
	Local nValCOF		:= 0	
	Local nValISS		:= 0
	Local nValICMST		:= 0
	Local _nAliqICM		:= 0
	Local _nAliqIPI		:= 0
	Local _nAliqPIS		:= 0
	Local _nAliqCOF		:= 0
	Local _nAliqISS		:= 0
	Local _nAliqICMS	:= 0
	Local aRelImp   	:= MaFisRelImp("MT150",{"SC8"})
	Local _aAux			:= {}
	Local _aAux2		:= {}
	Local _aArray3		:= {}
	Local _aArray2		:= {}
	Local _aArray1		:= {}
	Local _aFornec		:= {}
	Local _nI			:= 0
	Local _nJ			:= 0
	Local _nItem		:= 0
	Local _cObsCot		:= ""
	Local _aTipMot		:= {"1=Corretiva","2=Preventiva","3=Maq. Parada","4=Mat. Consumo","5=Atend. Pedido"}
	
	Aadd(_aAux2,{	"",;
					"",;
					"",;
					0,;
					0,;
					"",;
					0,;
					"",;
					"",;
					"",;
					"",;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					"",;
					0 ,;
					""})

 	_cQuery := "  SELECT DISTINCT	SC8.C8_FORNECE, SC8.C8_LOJA, SC8.C8_ITEM, C8_PRODUTO, SC8.C8_NUMPRO, SC8.R_E_C_N_O_ AS CRECSC8, "
 	_cQuery += "  			   		SC8.C8_QUANT, SC8.C8_NUM, SC8.C8_UM, SC8.C8_PRECO, SC8.C8_TOTAL, SC8.C8_NUMPED, "
 	_cQuery += "  			   		SC8.C8_TPFRETE, SC8.C8_TOTFRE, SC8.C8_PRAZO, SC8.C8_COND, SE4.E4_DESCRI, SC8.C8_XCOST, SC8.C8_XSAVING,  "
 	_cQuery += "  			   		SC8.C8_MOEDA, SC8.C8_EMISSAO, SC8.C8_TXMOEDA, SC8.C8_TES, SC8.C8_PICM, SC8.C8_ALIIPI, "
 	_cQuery += "  			   		A2_SIMPNAC, A2_NREDUZ, A2_CONTATO, A2_DDD, A2_TEL,  "
 	_cQuery += "  			   		B1_DESC, B1_PICM, B1_IPI, "
 	_cQuery += "  			   		A1_NREDUZ,  "
// 	_cQuery += "  			   		SA7.A7_CODCLI, SA7.A7_DESCCLI,  "
 	_cQuery += "  			   		SC1.C1_DESCRI, "
 	_cQuery += "  			   		SB5.B5_CEME "
 	_cQuery += " FROM " + RetSqlName("SC8") + " SC8 " 
   	
 	_cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1  "
 	_cQuery += " ON B1_FILIAL = '" + xFilial("SB1") + "'  "
 	_cQuery += " AND B1_COD = SC8.C8_PRODUTO  "
 	_cQuery += " AND SB1.D_E_L_E_T_ = ' '  "
 	
 	_cQuery += " LEFT JOIN " + RetSqlName("SB5") + " SB5  "
 	_cQuery += " ON B5_FILIAL = '" + xFilial("SB5") + "'  "
 	_cQuery += " AND B5_COD = SC8.C8_PRODUTO  "
 	_cQuery += " AND SB5.D_E_L_E_T_ = ' '  "
   	 
 	_cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2  "
 	_cQuery += " ON A2_FILIAL = '" + xFilial("SA2") + "'  "
 	_cQuery += " AND A2_COD = SC8.C8_FORNECE  "
 	_cQuery += " AND A2_LOJA = SC8.C8_LOJA  "
 	_cQuery += " AND SA2.D_E_L_E_T_ = ' '  "
 
 	_cQuery += " LEFT JOIN " + RetSqlName("SE4") + " SE4 "
 	_cQuery += " ON E4_FILIAL = '" + xFilial("SE4") + "' "
 	_cQuery += " AND E4_CODIGO = SC8.C8_COND "
 	_cQuery += " AND SE4.D_E_L_E_T_ = ' ' "
   	
   	_cQuery += " LEFT JOIN " + RetSqlName("SC1") + " SC1  "
 	_cQuery += " ON C1_FILIAL = '" + xFilial("SC1") + "'  "
 	_cQuery += " AND C1_NUM = SC8.C8_NUMSC  "
 	_cQuery += " AND C1_ITEM = SC8.C8_ITEMSC  "
 	_cQuery += " AND C1_PRODUTO = SC8.C8_PRODUTO  "
 	_cQuery += " AND SC1.D_E_L_E_T_ = ' '  "
   	   	
 	_cQuery += " LEFT JOIN " + RetSqlName("SC6") + " SC6  "
 	_cQuery += " ON C6_FILIAL = '" + xFilial("SC6") + "'  "
 	_cQuery += " AND C6_NUMSC = SC8.C8_NUMSC  "
 	_cQuery += " AND C6_ITEMSC = SC8.C8_ITEMSC  "
 	_cQuery += " AND C6_PRODUTO = SC8.C8_PRODUTO  "
 	_cQuery += " AND SC6.D_E_L_E_T_ = ' '  "
   	
 	_cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1  "
 	_cQuery += " ON A1_FILIAL = '" + xFilial("SA1") + "'  "
 	_cQuery += " AND A1_COD = SC6.C6_CLI  "
 	_cQuery += " AND A1_LOJA = SC6.C6_LOJA  "
 	_cQuery += " AND SA1.D_E_L_E_T_ = ' '  "
   	
/* 	_cQuery += " LEFT JOIN " + RetSqlName("SA7") + " SA7  "
 	_cQuery += " ON A7_FILIAL = '" + xFilial("SA7") + "'  "
 	_cQuery += " AND A7_CLIENTE = SC6.C6_CLI  "
 	_cQuery += " AND A7_LOJA = SC6.C6_LOJA  "
 	_cQuery += " AND A7_PRODUTO = SC6.C6_PRODUTO  "
 	_cQuery += " AND SA7.D_E_L_E_T_ = ' '  "
*/   	
 	_cQuery += " WHERE SC8.C8_FILIAL = '" + xFilial("SC8") + "'  "
 	_cQuery += " AND SC8.C8_NUMPRO IN ( SELECT MAX(SC82.C8_NUMPRO) 
 	_cQuery += " 						FROM " + RetSqlName("SC8") + " SC82 "
 	_cQuery += " 						WHERE SC8.C8_FILIAL = '" + xFilial("SC8") + "' AND SC82.C8_NUM = SC8.C8_NUM 
 	_cQuery += " 						AND SC82.C8_FORNECE = SC8.C8_FORNECE AND SC82.C8_LOJA = SC8.C8_LOJA 
 	_cQuery += " 						AND SC82.C8_PRODUTO = C8_PRODUTO ) "
 	_cQuery	+= " AND SC8.C8_NUM = '" + _cNumCot + "' "
 	_cQuery += " AND SC8.D_E_L_E_T_ = ' ' "
 
 	_cQuery += " ORDER BY C8_NUM, C8_PRODUTO, C8_FORNECE "
	
	TcQuery _cQuery New Alias &(_cAliasCot)

	If (_cAliasCot)->(!EOF())
		While (_cAliasCot)->(!EOF())
			If (_cAliasCot)->C8_TOTAL > 0 .And. !Empty((_cAliasCot)->C8_COND) .And. (Empty((_cAliasCot)->C8_NUMPED) .Or. mv_par04 == 1) 
				_nPos	:= Ascan(_aCotacao, { |x| AllTrim(x[1]) == AllTrim((_cAliasCot)->C8_PRODUTO) .And. AllTrim(x[3]) == AllTrim((_cAliasCot)->C8_ITEM) .And. AllTrim(x[7]) == AllTrim((_cAliasCot)->A1_NREDUZ)})
				
				dbSelectArea("SC8")
				dbSetOrder(1)
				SC8->(dbGoTo((_cAliasCot)->CRECSC8))

				_cObsCot	:= AllTrim(SC8->C8_XOBSCOT)  + IIF(!EMPTY(SC8->C8_XTIPMOT),".... Motivo : " + _aTipMot[Val(SC8->C8_XTIPMOT)] + " - " + AllTrim(SC8->C8_DSCMOT) + " ","") //MSMM(SC8->C8_XOBSCOT)
				
				If _nPos == 0 .Or. Len(_aCotacao[_nPos,10]) == 3 //_cProduto <> (_cAliasCot)->C8_PRODUTO .And. _cCliente <> (_cAliasCot)->A1_NREDUZ
					_cDesc	:= Iif(ALLTRIM(MV_PAR05)=="C1_DESCRI",(_cAliasCot)->C1_DESCRI,IIF(ALLTRIM(MV_PAR05)=="B5_CEME",(_cAliasCot)->B5_CEME,(_cAliasCot)->B1_DESC))
					_cDesc	:= Iif(Empty(_cDesc),(_cAliasCot)->B1_DESC,_cDesc)
					Aadd(_aCotacao,{(_cAliasCot)->C8_PRODUTO,;
									_cDesc,;
									(_cAliasCot)->C8_ITEM,;
									(_cAliasCot)->C8_QUANT,;
									(_cAliasCot)->C8_UM,;
									"",; //(_cAliasCot)->A7_CODCLI,;
									(_cAliasCot)->A1_NREDUZ,;
									(_cAliasCot)->C8_XCOST,;
									(_cAliasCot)->C8_XSAVING,;
									{},;
									"",;
									(_cAliasCot)->C8_NUM,;
									_cObsCot })
				EndIf
				
				cTes := IIF( mv_par03 == 1 , RetFldProd((_cAliasCot)->C8_PRODUTO,"B1_TE") , (_cAliasCot)->C8_TES )
				If cPaisLoc == "BRA"
					_cIcm := IIF( mv_par10 == 1 , (_cAliasCot)->B1_PICM , (_cAliasCot)->C8_PICM   )
					_cIpi := IIF( mv_par11 == 1 , (_cAliasCot)->B1_IPI  , (_cAliasCot)->C8_ALIIPI )
				Endif	
				
				//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥ Calculo do custo da Cotacao                                            ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
				MaFisIni((_cAliasCot)->C8_FORNECE,(_cAliasCot)->C8_LOJA,"F","N","R",aRelImp)
				MaFisIniLoad(1)
				For nY := 1 To Len(aRelImp)
					MaFisLoad(aRelImp[nY][3],SC8->(FieldGet(FieldPos(aRelImp[nY][2]))),1)
				Next nY
				MaFisEndLoad(1)
				MaFisAlt("IT_TES"    ,cTes,1)
				If cPaisLoc == "BRA"
					MaFisAlt("IT_ALIQICM",_cIcm,1)
					MaFisAlt("IT_ALIQIPI",_cIpi,1)
				Endif	
		
	//			nValPres := Ma160Custo("SC8",1)
				_nItem		:= 1 //Val((_cAliasCot)->C8_ITEM)				
				
				If cPaisLoc == "BRA"
					If SC8->(FieldPos("C8_MOEDA")<>0)
						nValIPI		:= xMoeda(MaFisRet(_nItem,"IT_VALIPI"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						nValICMS	:= xMoeda(MaFisRet(_nItem,"IT_VALICM"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						nValPIS		:= xMoeda(MaFisRet(_nItem,"IT_VALPS2"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						nValCOF		:= xMoeda(MaFisRet(_nItem,"IT_VALCF2"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						nValISS		:= xMoeda(MaFisRet(_nItem,"IT_VALISS"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						nValICMST	:= xMoeda(MaFisRet(_nItem,"IT_VALSOL"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						_nAliqICM	:= xMoeda(MaFisRet(_nItem,"IT_ALIQICM"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						_nAliqIPI	:= xMoeda(MaFisRet(_nItem,"IT_ALIQIPI"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						_nAliqPIS	:= xMoeda(MaFisRet(_nItem,"IT_ALIQPS2"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						_nAliqCOF	:= xMoeda(MaFisRet(_nItem,"IT_ALIQCF2"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						_nAliqISS	:= xMoeda(MaFisRet(_nItem,"IT_ALIQISS"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
						_nAliqICMS	:= xMoeda(MaFisRet(_nItem,"IT_ALIQSOL"),(_cAliasCot)->C8_MOEDA,1,(_cAliasCot)->C8_EMISSAO,,If(SC8->(FIELDPOS("C8_TXMOEDA")) > 0,(_cAliasCot)->C8_TXMOEDA,''))
					Else
						nValIPI  	:= MaFisRet(_nItem,"IT_VALIPI")
						nValICMS 	:= MaFisRet(_nItem,"IT_VALICM")
						nValPIS		:= MaFisRet(_nItem,"IT_VALPS2")
						nValCOF		:= MaFisRet(_nItem,"IT_VALCF2")
						nValISS		:= MaFisRet(_nItem,"IT_VALISS")
						nValICMST	:= MaFisRet(_nItem,"IT_VALSOL")
						_nAliqICM	:= MaFisRet(_nItem,"IT_ALIQICM")
						_nAliqIPI	:= MaFisRet(_nItem,"IT_ALIQIPI")
						_nAliqPIS	:= MaFisRet(_nItem,"IT_ALIQPS2")
						_nAliqCOF	:= MaFisRet(_nItem,"IT_ALIQCF2")
						_nAliqISS	:= MaFisRet(_nItem,"IT_ALIQISS")
						_nAliqICMS	:= MaFisRet(_nItem,"IT_ALIQSOL")
					Endif		
				Endif
				
				If _nPos == 0 .Or. Len(_aCotacao[_nPos,10]) == 3
					Aadd(_aCotacao[Len(_aCotacao),10],{	(_cAliasCot)->C8_FORNECE,;
														(_cAliasCot)->C8_LOJA,;
														(_cAliasCot)->A2_NREDUZ,;
														(_cAliasCot)->C8_PRECO,;
														(_cAliasCot)->C8_TOTAL,;
														Iif((_cAliasCot)->C8_TPFRETE=='C','CIF',Iif((_cAliasCot)->C8_TPFRETE=='F','FOB','')),;
														(_cAliasCot)->C8_PRAZO,;
														Iif(!Empty((_cAliasCot)->C8_COND),(_cAliasCot)->E4_DESCRI,""),;
														(_cAliasCot)->A2_CONTATO,;
														"(" + AllTrim((_cAliasCot)->A2_DDD) + ") - " + (_cAliasCot)->A2_TEL,;
														Iif((_cAliasCot)->A2_SIMPNAC=="S","Sim",Iif((_cAliasCot)->A2_SIMPNAC=="N","N„o","")),;
														nValIPI,;
														nValICMS,;
														nValPIS,;
														nValCOF,;
														nValISS,;
														nValICMST,;
														_nAliqICM,;
														_nAliqIPI,;
														_nAliqPIS,;
														_nAliqCOF,;
														_nAliqISS,;
														_nAliqICMS,;
														nValICMS + nValPIS + nValCOF,;
														(_cAliasCot)->A1_NREDUZ,;
														(_cAliasCot)->C8_TOTFRE,;
														Iif(SubStr((_cAliasCot)->C8_NUMPED,1,1) == "X" .OR. EMPTY((_cAliasCot)->C8_NUMPED) ,"","S")})
														
					_aCotacao[Len(_aCotacao),11]	+= (_cAliasCot)->C8_FORNECE + (_cAliasCot)->C8_LOJA + "|"			
				Else
					Aadd(_aCotacao[_nPos,10],{	(_cAliasCot)->C8_FORNECE,;
														(_cAliasCot)->C8_LOJA,;
														(_cAliasCot)->A2_NREDUZ,;
														(_cAliasCot)->C8_PRECO,;
														(_cAliasCot)->C8_TOTAL,;
														Iif((_cAliasCot)->C8_TPFRETE=='C','CIF',Iif((_cAliasCot)->C8_TPFRETE=='F','FOB','')),;
														(_cAliasCot)->C8_PRAZO,;
														Iif(!Empty((_cAliasCot)->C8_COND),(_cAliasCot)->E4_DESCRI,""),;
														(_cAliasCot)->A2_CONTATO,;
														"(" + AllTrim((_cAliasCot)->A2_DDD) + ") - " + (_cAliasCot)->A2_TEL,;
														Iif((_cAliasCot)->A2_SIMPNAC=="S","Sim",Iif((_cAliasCot)->A2_SIMPNAC=="N","N„o","")),;
														nValIPI,;
														nValICMS,;
														nValPIS,;
														nValCOF,;
														nValISS,;
														nValICMST,;
														_nAliqICM,;
														_nAliqIPI,;
														_nAliqPIS,;
														_nAliqCOF,;
														_nAliqISS,;
														_nAliqICMS,;
														nValICMS + nValPIS + nValCOF,;
														(_cAliasCot)->A1_NREDUZ,;
														(_cAliasCot)->C8_TOTFRE,;
														Iif(SubStr((_cAliasCot)->C8_NUMPED,1,1) == "X" .OR. EMPTY((_cAliasCot)->C8_NUMPED) ,"","S")})
														
					_aCotacao[_nPos,11]	+= (_cAliasCot)->C8_FORNECE + (_cAliasCot)->C8_LOJA + "|"
				EndIf
			EndIf
			
			_cCliente	:= (_cAliasCot)->A1_NREDUZ
			_cProduto	:= (_cAliasCot)->C8_PRODUTO
			(_cAliasCot)->(dbSkip())			

		EndDo
	EndIF
	
	(_cAliasCot)->(dbCloseArea())  
	
	_aAux	:= aClone(_aCotacao)
	aSort(_aAux,2,, { |x, y| len(x[10]) > len(y[10]) } )

	For _nI	:= 1 To Len(_aAux)
		Do Case
			Case Len(_aAux[_nI,10]) == 3
				Aadd(_aArray3,_aAux[_nI])
			Case Len(_aAux[_nI,10]) == 2
				Aadd(_aArray2,_aAux[_nI])
			Case Len(_aAux[_nI,10]) == 1
				Aadd(_aArray1,_aAux[_nI])
		End Case
	Next _nI
	
	For _nI := 1 To Len(_aArray3)
		If _nI == 1
			aadd(_aAuxCot,{	_aArray3[_nI,1],_aArray3[_nI,2],_aArray3[_nI,3],_aArray3[_nI,4],_aArray3[_nI,5],_aArray3[_nI,6],_aArray3[_nI,7],;
							_aArray3[_nI,8],_aArray3[_nI,9],_aArray3[_nI,10],_aArray3[_nI,11],_aArray3[_nI,12],_aArray3[_nI,13],_nI,cTES })
		Else
			_nPos	:= Ascan(_aAuxCot, { |x| AllTrim(x[11]) == AllTrim(_aArray3[_nI,11]) .And. AllTrim(x[7]) == AllTrim(_aArray3[_nI,7]) .And. AllTrim(x[12]) == AllTrim(_aArray3[_nI,12])})
			If _nPos == 0
				aadd(_aAuxCot,{	_aArray3[_nI,1],_aArray3[_nI,2],_aArray3[_nI,3],_aArray3[_nI,4],_aArray3[_nI,5],_aArray3[_nI,6],_aArray3[_nI,7],;
								_aArray3[_nI,8],_aArray3[_nI,9],_aArray3[_nI,10],_aArray3[_nI,11],_aArray3[_nI,12],_aArray3[_nI,13],Len(_aAuxCot)+1,cTES })
			Else
				aadd(_aAuxCot,{	_aArray3[_nI,1],_aArray3[_nI,2],_aArray3[_nI,3],_aArray3[_nI,4],_aArray3[_nI,5],_aArray3[_nI,6],_aArray3[_nI,7],;
								_aArray3[_nI,8],_aArray3[_nI,9],_aArray3[_nI,10],_aArray3[_nI,11],_aArray3[_nI,12],_aArray3[_nI,13],_nPos,cTES })
			EndIf
		EndIf
	Next _nI

	If Len(_aArray3) > 0
		For _nI	:= 1 To Len(_aArray2)
			_nPos	:= Ascan(_aAuxCot, { |x| AllTrim(x[11]) == AllTrim(_aArray2[_nI,11]) .And. AllTrim(x[7]) == AllTrim(_aArray3[_nI,7]) .And. AllTrim(x[12]) == AllTrim(_aArray3[_nI,12])})
			If _nPos == 0
				_aAux	:= Separa(_aArray2[_nI,11],"|")
				_nPos	:= Ascan(_aAuxCot, { |x| AllTrim(_aAux[1]) $ AllTrim(x[11]) .And. AllTrim(_aAux[2]) $ AllTrim(x[11]) .And. AllTrim(x[7]) == AllTrim(_aArray3[_nI,7]) .And. AllTrim(x[12]) == AllTrim(_aArray3[_nI,12])})
				_aAux	:= {}
				For _nJ := 1 To 3
					If _nJ < 3
						Aadd(_aAux,_aArray2[_nI,10,_nJ])
					Else
						Aadd(_aAux,_aAux2[1])
					EndIf
				Next _nJ
				If _nPos == 0
					aadd(_aAuxCot,{	_aArray2[_nI,1],_aArray2[_nI,2],_aArray2[_nI,3],_aArray2[_nI,4],_aArray2[_nI,5],_aArray2[_nI,6],_aArray2[_nI,7],;
									_aArray2[_nI,8],_aArray2[_nI,9],_aAux,_aArray2[_nI,11],_aArray2[_nI,12],_aArray2[_nI,13],Len(_aAuxCot)+1,cTES })
				Else
					_aAux	:= Separa(_aArray2[_nI,11],"|")
					_nPos1	:= Ascan(_aAuxCot[_nPos,10], { |x| ALLTRIM(x[1]+x[2]) == AllTrim(_aAux[1]) })
					_nPos2	:= Ascan(_aAuxCot[_nPos,10], { |x| ALLTRIM(x[1]+x[2]) == AllTrim(_aAux[2]) })
					_aAux	:= {}
					
					Do Case
						Case _nPos1 == 1
							If _nPos2 == 2
								aadd(_aAux,{_aArray2[_nI,10,_nPos1],;
											_aArray2[_nI,10,_nPos2],_aAux2[1]})
							Else
								aadd(_aAux,{_aArray2[_nI,10,_nPos1],;
											_aAux2[1],_aArray2[_nI,10,_nPos2]})
							EndIf
						Case _nPos1 == 2
							If _nPos2 == 1
								aadd(_aAux,{_aArray2[_nI,10,_nPos2],;
											_aArray2[_nI,10,_nPos1],_aAux2[1]})
							Else
								aadd(_aAux,{_aAux2[1],;
											_aArray2[_nI,10,_nPos1],_aArray2[_nI,10,_nPos2]})
							EndIf
						Case _nPos1 == 3
							If _nPos2 == 1
								aadd(_aAux,{_aArray2[_nI,10,_nPos2],_aAux2[1],_aArray2[_nI,10,_nPos1]})
							Else
								aadd(_aAux,{_aAux2[1],_aArray2[_nI,10,_nPos1],;
											,_aArray2[_nI,10,_nPos2]})
							EndIf
					EndCase
					aadd(_aAuxCot,{	_aArray2[_nI,1],_aArray2[_nI,2],_aArray2[_nI,3],_aArray2[_nI,4],_aArray2[_nI,5],_aArray2[_nI,6],_aArray2[_nI,7],;
									_aArray2[_nI,8],_aArray2[_nI,9],_aAux[1],_aArray2[_nI,11],_aArray2[_nI,12],_aArray2[_nI,13],_nPos,cTES })
				EndIf
			Else
				_aAux	:= Separa(_aArray2[_nI,11],"|")
				_nPos1	:= Ascan(_aAuxCot[_nPos,10], { |x| ALLTRIM(x[1]+x[2]) == AllTrim(_aAux[1]) })
				_nPos2	:= Ascan(_aAuxCot[_nPos,10], { |x| ALLTRIM(x[1]+x[2]) == AllTrim(_aAux[2]) })
				_aAux	:= {}

				Do Case
					Case _nPos1 == 1
						If _nPos2 == 2
							aadd(_aAux,{_aArray2[_nI,10,_nPos1],;
										_aArray2[_nI,10,_nPos2],_aAux2[1]})
						Else
							aadd(_aAux,{_aArray2[_nI,10,_nPos1],;
										_aAux2[1],_aArray2[_nI,10,_nPos2]})
						EndIf
					Case _nPos1 == 2
						If _nPos2 == 1
							aadd(_aAux,{_aArray2[_nI,10,_nPos2],;
										_aArray2[_nI,10,_nPos1],_aAux2[1]})
						Else
							aadd(_aAux,{_aAux2[1],;
										_aArray2[_nI,10,_nPos1],_aArray2[_nI,10,_nPos2]})
						EndIf
					Case _nPos1 == 3
						If _nPos2 == 1
							aadd(_aAux,{_aArray2[_nI,10,_nPos2],_aAux2[1],_aArray2[_nI,10,_nPos1]})
						Else
							aadd(_aAux,{_aAux2[1],_aArray2[_nI,10,_nPos1],;
										,_aArray2[_nI,10,_nPos2]})
						EndIf
				EndCase					
				aadd(_aAuxCot,{	_aArray2[_nI,1],_aArray2[_nI,2],_aArray2[_nI,3],_aArray2[_nI,4],_aArray2[_nI,5],_aArray2[_nI,6],_aArray2[_nI,7],;
								_aArray2[_nI,8],_aArray2[_nI,9],_aAux[1],_aArray2[_nI,11],_aArray2[_nI,12],_aArray2[_nI,13],_nPos,cTES })
			EndIF
		Next _nI
	Else
		For _nI := 1 To Len(_aArray2)
			_aAux := {}
			For _nJ := 1 To 3
				If _nJ < 3
					Aadd(_aAux,_aArray2[_nI,10,_nJ])
				Else
					Aadd(_aAux,_aAux2[1])
				EndIf
			Next _nJ
	
			If _nI == 1
				aadd(_aAuxCot,{	_aArray2[_nI,1],_aArray2[_nI,2],_aArray2[_nI,3],_aArray2[_nI,4],_aArray2[_nI,5],_aArray2[_nI,6],_aArray2[_nI,7],;
								_aArray2[_nI,8],_aArray2[_nI,9],_aAux,_aArray2[_nI,11],_aArray2[_nI,12],_aArray2[_nI,13],_nI,cTES })
			Else
				_nPos	:= Ascan(_aAuxCot, { |x| AllTrim(x[11]) == AllTrim(_aArray2[_nI,11]) .And. AllTrim(x[7]) == AllTrim(_aArray2[_nI,7]) .And. AllTrim(x[12]) == AllTrim(_aArray2[_nI,12])})
				If _nPos == 0
					_aAux	:= {}
					For _nJ := 1 To 3
						If _nJ < 3
							Aadd(_aAux,_aArray2[_nI,10,_nJ])
						Else
							Aadd(_aAux,_aAux2[1])
						EndIf
					Next _nJ
					aadd(_aAuxCot,{	_aArray2[_nI,1],_aArray2[_nI,2],_aArray2[_nI,3],_aArray2[_nI,4],_aArray2[_nI,5],_aArray2[_nI,6],_aArray2[_nI,7],;
									_aArray2[_nI,8],_aArray2[_nI,9],_aAux,_aArray2[_nI,11],_aArray2[_nI,12],_aArray2[_nI,13],Len(_aAuxCot)+1,cTES })
				Else
					_aAux	:= Separa(_aArray2[_nI,11],"|")
					_nPos1	:= Ascan(_aAuxCot[_nPos,10], { |x| ALLTRIM(x[1]+x[2]) == AllTrim(_aAux[1]) })
					_nPos2	:= Ascan(_aAuxCot[_nPos,10], { |x| ALLTRIM(x[1]+x[2]) == AllTrim(_aAux[2]) })
					_aAux	:= {}

					Do Case
						Case _nPos1 == 1
							If _nPos2 == 2
								aadd(_aAux,{_aArray2[_nI,10,_nPos1],;
											_aArray2[_nI,10,_nPos2],_aAux2[1]})
							Else
								aadd(_aAux,{_aArray2[_nI,10,_nPos1],;
											_aAux2[1],_aArray2[_nI,10,_nPos2]})
							EndIf
						Case _nPos1 == 2
							If _nPos2 == 1
								aadd(_aAux,{_aArray2[_nI,10,_nPos2],;
											_aArray2[_nI,10,_nPos1],_aAux2[1]})
							Else
								aadd(_aAux,{_aAux2[1],;
											_aArray2[_nI,10,_nPos1],_aArray2[_nI,10,_nPos2]})
							EndIf
						Case _nPos1 == 3
							If _nPos2 == 1
								aadd(_aAux,{_aArray2[_nI,10,_nPos2],_aAux2[1],_aArray2[_nI,10,_nPos1]})
							Else
								aadd(_aAux,{_aAux2[1],_aArray2[_nI,10,_nPos1],;
											,_aArray2[_nI,10,_nPos2]})
							EndIf
					EndCase
					aadd(_aAuxCot,{	_aArray2[_nI,1],_aArray2[_nI,2],_aArray2[_nI,3],_aArray2[_nI,4],_aArray2[_nI,5],_aArray2[_nI,6],_aArray2[_nI,7],;
									_aArray2[_nI,8],_aArray2[_nI,9],_aAux[1],_aArray2[_nI,11],_aArray2[_nI,12],_aArray2[_nI,13],_nPos,cTES })
				EndIf
			EndIf
		Next _nI
	EndIf
	
	If Len(_aArray2) > 0
		For _nI	:= 1 To Len(_aArray1)
			_nPos	:= Ascan(_aAuxCot, { |x| AllTrim(x[11]) == AllTrim(_aArray1[_nI,11]) .And. AllTrim(x[7]) == AllTrim(_aArray1[_nI,7]) .And. AllTrim(x[12]) == AllTrim(_aArray1[_nI,12])})
			If _nPos == 0
				_nPos	:= Ascan(_aAuxCot, { |x|  AllTrim(_aArray1[_nI,11]) $ AllTrim(x[11]) })
				_aAux	:= {}
				For _nJ := 1 To 3
					If _nJ == 1
						Aadd(_aAux,_aArray1[_nI,10,_nJ])
					Else
						Aadd(_aAux,_aAux2[1])
					EndIf
				Next _nJ
				If _nPos == 0
					aadd(_aAuxCot,{	_aArray1[_nI,1],_aArray1[_nI,2],_aArray1[_nI,3],_aArray1[_nI,4],_aArray1[_nI,5],_aArray1[_nI,6],_aArray1[_nI,7],;
									_aArray1[_nI,8],_aArray1[_nI,9],_aAux,_aArray1[_nI,11],_aArray1[_nI,12],_aArray1[_nI,13],Len(_aAuxCot)+1,cTES })
				Else
					_nPos2	:= Ascan(_aAuxCot[_nPos,10], { |x| ALLTRIM(x[1]+x[2]) $ AllTrim(_aArray1[_nI,11]) })
					_aAux	:= {}

					Do Case
						Case _nPos2 == 1
							aadd(_aAux,{_aArray1[_nI,10,1],;
										_aAux2[1],_aAux2[1]})
						Case _nPos2 == 2
							aadd(_aAux,{_aAux2[1],_aArray1[_nI,10,1],;
										_aAux2[1]})
						Case _nPos2 == 3
							aadd(_aAux,{_aAux2[1],;
										_aAux2[1],_aArray1[_nI,10,1]})
					EndCase
					aadd(_aAuxCot,{	_aArray1[_nI,1],_aArray1[_nI,2],_aArray1[_nI,3],_aArray1[_nI,4],_aArray1[_nI,5],_aArray1[_nI,6],_aArray1[_nI,7],;
									_aArray1[_nI,8],_aArray1[_nI,9],_aAux[1],_aArray1[_nI,11],_aArray1[_nI,12],_aArray1[_nI,13],_nPos,cTES })
				EndIf
			Else
				_nPos2	:= Ascan(_aAuxCot[_nPos,10], { |x| ALLTRIM(x[1]+x[2]) $ AllTrim(_aArray1[_nI,11]) })
				_aAux	:= {}

				Do Case
					Case _nPos2 == 1
						aadd(_aAux,{_aArray1[_nI,10,1],;
									_aAux2[1],_aAux2[1]})
					Case _nPos2 == 2
						aadd(_aAux,{_aAux2[1],_aArray1[_nI,10,1],;
									_aAux2[1]})
					Case _nPos2 == 3
						aadd(_aAux,{_aAux2[1],;
									_aAux2[1],_aArray1[_nI,10,1]})
				EndCase
				aadd(_aAuxCot,{	_aArray1[_nI,1],_aArray1[_nI,2],_aArray1[_nI,3],_aArray1[_nI,4],_aArray1[_nI,5],_aArray1[_nI,6],_aArray1[_nI,7],;
								_aArray1[_nI,8],_aArray1[_nI,9],_aAux[1],_aArray1[_nI,11],_aArray1[_nI,12],_aArray1[_nI,13],_nPos,cTES })
			EndIF
		Next _nI
	Else
		
		For _nI := 1 To Len(_aArray1)
			_aAux	:= {}
			For _nJ := 1 To 3
				If _nJ == 1
					Aadd(_aAux,_aArray1[_nI,10,1])
				Else
					Aadd(_aAux,_aAux2[1])
				EndIf
			Next _nJ
			If _nI == 1
				aadd(_aAuxCot,{	_aArray1[_nI,1],_aArray1[_nI,2],_aArray1[_nI,3],_aArray1[_nI,4],_aArray1[_nI,5],_aArray1[_nI,6],_aArray1[_nI,7],;
								_aArray1[_nI,8],_aArray1[_nI,9],_aAux,_aArray1[_nI,11],_aArray1[_nI,12],_aArray1[_nI,13],_nI,cTES })
			Else
				_nPos	:= Ascan(_aAuxCot, { |x| ALLTRIM(x[11]) == AllTrim(_aArray1[_nI,11]) .And. AllTrim(x[12]) == AllTrim(_aArray1[_nI,12]) })
				If _nPos == 0
					aadd(_aAuxCot,{	_aArray1[_nI,1],_aArray1[_nI,2],_aArray1[_nI,3],_aArray1[_nI,4],_aArray1[_nI,5],_aArray1[_nI,6],_aArray1[_nI,7],;
									_aArray1[_nI,8],_aArray1[_nI,9],_aAux,_aArray1[_nI,11],_aArray1[_nI,12],_aArray1[_nI,13],Len(_aAuxCot)+1,cTES })
				Else
					_nPos2	:= Ascan(_aAuxCot[_nPos,10], { |x| ALLTRIM(x[1]+x[2]) $ AllTrim(_aArray1[_nI,11]) })
					_aAux	:= {}

					Do Case
						Case _nPos2 == 1
							aadd(_aAux,{_aArray1[_nI,10,1],;
										_aAux2[1],_aAux2[1]})
						Case _nPos2 == 2
							aadd(_aAux,{_aAux2[1],_aArray1[_nI,10,1],;
										_aAux2[1]})
						Case _nPos2 == 3
							aadd(_aAux,{_aAux2[1],;
										_aAux2[1],_aArray1[_nI,10,1]})
					EndCase					
					aadd(_aAuxCot,{	_aArray1[_nI,1],_aArray1[_nI,2],_aArray1[_nI,3],_aArray1[_nI,4],_aArray1[_nI,5],_aArray1[_nI,6],_aArray1[_nI,7],;
									_aArray1[_nI,8],_aArray1[_nI,9],_aAux[1],_aArray1[_nI,11],_aArray1[_nI,12],_aArray1[_nI,13],_nPos,cTES })
				EndIf
			EndIf
		Next _nI
	EndIf

	aSort(_aAuxCot,,, { |x, y| x[14] < y[14] } )
//	Alert("teste")

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} AjustaSX1
FunÁ„o para ajuste das perguntas do relatÛrio.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		22/07/2015
@version 	P11
@obs    	Rotina Especifica HCI - Carmar
/*/
//-------------------------------------------------------------------
Static Function AjustaSX1(_cPerg)

Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

aHelpPor := {'Informe o n˙mero da cotaÁ„o de compra  ','inicial que ser· considerado na seleÁ„o  ', 'dos registros para impressao'}
aHelpEng := {'Informe o n˙mero da cotaÁ„o de compra  ','inicial que ser· considerado na seleÁ„o  ', 'dos registros para impressao'}
aHelpSpa := {'Informe o n˙mero da cotaÁ„o de compra  ','inicial que ser· considerado na seleÁ„o  ', 'dos registros para impressao'}
PutSx1(_cPerg,"01","Da Cotacao ?"			,"øDe Cotizacion ?"				,"From Quotation ?"			,"mv_ch1","C",06,0,0,"G","","SC8NUM","","","mv_par01","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Informe o n˙mero final da cotaÁ„o de ','compra que ser· considerado na seleÁ„o  ', 'dos registros para impressao'}
aHelpEng := {'Informe o n˙mero final da cotaÁ„o de ','compra que ser· considerado na seleÁ„o  ', 'dos registros para impressao'}
aHelpSpa := {'Informe o n˙mero final da cotaÁ„o de ','compra que ser· considerado na seleÁ„o  ', 'dos registros para impressao'}
PutSx1(_cPerg,"02","Ate Cotacao ?"			,"øA  Cotizacion ? "			,"To Quotation ?"			,"mv_ch2","C",06,0,0,"G","","SC8NUM","","","mv_par02","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Informe se deseja que seja sugerido a  ','TES padr„o.  '}
aHelpEng := {'Informe se deseja que seja sugerido a  ','TES padr„o.  '}
aHelpSpa := {'Informe se deseja que seja sugerido a  ','TES padr„o.  '}
PutSx1(_cPerg,"03","Sugere TE Padrao ?"		,"øSugiere TE Estand. ?"		,"Suggest Standard TE ?"	,"mv_ch3","N",01,0,1,"C","","","","","mv_par03","Sim","Si","Yes","" ,"Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Informe se imprime somente as cotaÁıes  ','encerradas ou n„o.  '}
aHelpEng := {'Informe se imprime somente as cotaÁıes  ','encerradas ou n„o.  '}
aHelpSpa := {'Informe se imprime somente as cotaÁıes  ','encerradas ou n„o.  '}
PutSx1(_cPerg,"04","Lista Encerradas ?"		,"øListas Finalizadas ?"		,"Concluded Lists ?"		,"mv_ch4","N",01,0,2,"C","","","","","mv_par04","Sim","Si","Yes","" ,"Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'ForneÁa a descriÁ„o do produto para  ','impress„o do relatÛrio.  '}
aHelpEng := {'ForneÁa a descriÁ„o do produto para  ','impress„o do relatÛrio.  '}
aHelpSpa := {'ForneÁa a descriÁ„o do produto para  ','impress„o do relatÛrio.  '}
PutSx1(_cPerg,"05","Descricao do produto ?"	,"øDescripcion del producto ?"	,"Product Description ? "	,"mv_ch5","C",10,0,0,"G","","","","","mv_par05","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Define o tipo de impress„o do relaÛrio  ','Excel ou Spool.  '}
aHelpEng := {'Define o tipo de impress„o do relaÛrio  ','Excel ou Spool.  '}
aHelpSpa := {'Define o tipo de impress„o do relaÛrio  ','Excel ou Spool.  '}
PutSx1(_cPerg,"06","Imprime em Excel ?","øImprime em Excel ?","Print in Excel ?","mv_ch6","N",1,0,2,"C","","","","","mv_par06","Sim","Si","Yes","" ,"Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Informe o respons·vel pela CotaÁ„o para ','impress„o do relatÛrio.  '}
aHelpEng := {'Informe o respons·vel pela CotaÁ„o para ','impress„o do relatÛrio.  '}
aHelpSpa := {'Informe o respons·vel pela CotaÁ„o para ','impress„o do relatÛrio.  '}
PutSx1(_cPerg,"07","Comprador ?"	,"øComprador?"	,"buyer ? "	,"mv_ch7","C",40,0,0,"G","","","","","mv_par07","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 
    
aHelpPor := {'Informe o respons·vel pela aprovaÁ„o da CotaÁ„o ','para impress„o do relatÛrio.  '}
aHelpEng := {'Informe o respons·vel pela aprovaÁ„o da CotaÁ„o ','para impress„o do relatÛrio.    '}
aHelpSpa := {'Informe o respons·vel pela aprovaÁ„o da CotaÁ„o ','para impress„o do relatÛrio.    '}
PutSx1(_cPerg,"08","Gerente de Suprimentos ?"	,"øGerente de Abastecimiento ?"	,"Supply manager ? "	,"mv_ch8","C",40,0,0,"G","","","","","mv_par08","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor := {'Informe o respons·vel pela Diretoria ','para impress„o do relatÛrio.  '}
aHelpEng := {'Informe o respons·vel pela Diretoria ','para impress„o do relatÛrio.    '}
aHelpSpa := {'Informe o respons·vel pela Diretoria ','para impress„o do relatÛrio.    '}
PutSx1(_cPerg,"09","Diretoria ?"	,"øDirector ?"	,"Directorship ? "	,"mv_ch9","C",40,0,0,"G","","","","","mv_par09","","","","" ,"","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 


If cPaisLoc == "BRA"

	PutSx1(_cPerg, "10", "Listar Aliquota ICMS","Listar Alicuota ICMS","List ICMS Tax Rate","mv_cha","N", 1, 0, 2, "C","","","","","mv_par10","Cadastro de Produtos","Productos","Products","","CotaÁ„o", "Cotazion","Quotation","","","","","","","","","","","","","")
	PutSx1(_cPerg, "11", "Listar Aliquota IPI", "Listar Alicuota IPI", "List IPI Tax Rate", "mv_chb","N", 1, 0, 2, "C","","","","","mv_par11","Cadastro de Produtos","Productos","Products","","CotaÁ„o", "Cotazion","Quotation","","","","","","","","","","","","","")


Else
   dbSelectArea("SX1")
   If dbSeek(PADR(_cPerg,nTamSX1)+"10")
       RecLock("SX1",.F.)
       dbDelete()
       MsUnlock()
   Endif
   If dbSeek(PADR(_cPerg,nTamSX1)+"11")
       RecLock("SX1",.F.)
       dbDelete()
       MsUnlock()
   Endif   
   
Endif	

aHelpPor := {'Define o tipo de impress„o do relaÛrio  ','Excel ou Spool.  '}
aHelpEng := {'Define o tipo de impress„o do relaÛrio  ','Excel ou Spool.  '}
aHelpSpa := {'Define o tipo de impress„o do relaÛrio  ','Excel ou Spool.  '}
PutSx1(_cPerg,"09","Imprime em Excel ?","øImprime em Excel ?","Print in Excel ?","mv_chc","N",1,0,2,"C","","","","","mv_par12","Sim","Si","Yes","" ,"Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} _f002XB
Rotina para criaÁ„o da consulta padr„o de Tipos.

@author 	Bruna Zechetti de Oliveira
@since 		14/01/2015
@version 	P11
@obs    	Rotina Especifica HCI
/*/
//-------------------------------------------------------------------
User Function _fSC8XB()

	Local alEstrut		:= {}
	Local alCampos		:= {}
	Local olChkB		:= Nil
	Local olBtn1		:= Nil
	Local olBtn2		:= Nil
	Local olBtn3		:= Nil
	Local clNomTmp		:= ""
	Local clMarca		:= "X"
	Local llChkB		:= .T.
	Local _nOpc	 		:= 0
	Local _cBusca		:= Space(TamSX3("C8_NUM")[1])
	Local _nIndice		:= 1
	Local _oIndice		:= Nil
	Local _aBusca		:= {"Codigo"}
	Private olMark		:= Nil
	Private _cAliasTMP	:= GetNextAlias()
	
	aAdd(alCampos,{"COTACAO"	,,"Nro Cotacao"		,"@!"})

	aAdd(alEstrut,{"COTACAO"	,"C",TamSX3("C8_NUM")[1]	,TamSX3("C8_NUM")[2]})

	clNomTmp	:= CriaTrab(alEstrut,.T.)
/*	If !(Select("TMPSC8") > 0)
//		TMPSC8->(dbCloseArea())
//	EndIf
		dbUseArea(.T.,,clNomTmp,"TMPSC8",.F.)		
		INDEX ON COTACAO TAG IND1 TO "TMPSC8"
	EndIf
*/
	dbUseArea(.T.,,clNomTmp,_cAliasTMP,.F.)		
	INDEX ON COTACAO TAG IND1 TO &clNomTmp

	FGrvTMP(1)

	(_cAliasTMP)->(dbSetOrder(1))
	(_cAliasTMP)->(dbGoTop())
	
	@000,000 To 440,505 DIALOG olDlgTip TITLE "CotaÁıes"
	
		olMark	:= MsSelect():New((_cAliasTMP),"",,alCampos,,@clMarca,{35,04,200,250})
//		@ 005,004 RADIO _oIndice VAR _nIndice ITEMS "Codigo","Descricao" SIZE 70,10
		_oIndice := TComboBox():New(005,004,{|u|if(PCount()>0,_nIndice:=u,_nIndice)},_aBusca,100,20,olDlgTip,,{||FGrvTMP(_nIndice),(_cAliasTMP)->(dbGoTop()),olMark:oBrowse:Refresh(),olDlgTip:Refresh()},,,,.T.,,,,,,,,,'_nIncide')
		@ 018,004 MSGET _cBusca    							SIZE 150 ,9 OF olDlgTip PIXEL
		@ 004,210 BUTTON olBtn3		PROMPT "Pesquisar" 		SIZE 40,12 ACTION (_fPesqDSP(_nIndice,_cBusca)) 	PIXEL OF olDlgTip
		@ 019,210 BUTTON olBtn3		PROMPT "Limpar Pesq." 	SIZE 40,12 ACTION (FGrvTMP(_nIndice),_cBusca	:= Space(TamSX3("C8_COTACAO")[1]))				PIXEL OF olDlgTip
		@ 205,160 BUTTON olBtn1		PROMPT "Ok" 			SIZE 40,12 ACTION (_nOpc:=1,olDlgTip:End()) 		PIXEL OF olDlgTip
		@ 205,210 BUTTON olBtn2		PROMPT "Cancelar"  		SIZE 40,12 ACTION olDlgTip:End() PIXEL OF olDlgTip

	ACTIVATE DIALOG olDlgTip CENTERED
	
	If _nOpc == 1
		Return((_cAliasTMP)->COTACAO)
	EndIF
	
Return("")

//-------------------------------------------------------------------
/*/{Protheus.doc} _fPesqDSP
FunÁ„o para filtro/pesquisa das despesas.

@author 	Bruna Zechetti de Oliveira
@since 		15/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function _fPesqDSP(_nOpc,_cBusca)

    (_cAliasTMP)->(dbSetOrder(_nOpc))
    (_cAliasTMP)->(dbSeek(_cBusca))
    
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} FGrvTMP
FunÁ„o para gravaÁ„o dos dados da consulta padr„o de Despesas.

@author 	Bruna Zechetti de Oliveira
@since 		14/01/2015
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function FGrvTMP(_nOpc)

	Local _cQuery	:= ""
	Local _cAlias02	:= GetNextAlias()
	Local _nI		:= 0

	If Select((_cAliasTMP)) > 0
		(_cAliasTMP)->(dbGoTop())
		If (_cAliasTMP)->(!Eof())
			While (_cAliasTMP)->(!Eof())
				If RecLock((_cAliasTMP), .F., .T.)
					(_cAliasTMP)->( dbDelete() )
					(_cAliasTMP)->( MsUnLock() )
				EndIf
				(_cAliasTMP)->( dbSkip() )				
			EndDo
		EndIf
	EndIf

	_cQuery	:= "SELECT	DISTINCT C8_NUM "
	_cQuery	+= " FROM " + RetSqlName("SC8") 
	_cQuery	+= " WHERE C8_FILIAL = '" + xFilial("SC8") + "' "
	_cQuery	+= " AND D_E_L_E_T_ = ' '"
    _cQuery	+= " ORDER BY C8_NUM "
	TcQuery _cQuery New Alias &(_cAlias02)	
	
	If (_cAlias02)->(!EOF())
		While (_cAlias02)->(!EOF())
			If RecLock((_cAliasTMP),.T.)
				(_cAliasTMP)->COTACAO	:= (_cAlias02)->C8_NUM
				MsUnLock()
			EndIf		
			(_cAlias02)->(dbSkip())
		EndDO
	EndIf
	(_cAlias02)->(dbCloseArea())
	
    (_cAliasTMP)->(dbSetOrder(1))

Return(Nil)