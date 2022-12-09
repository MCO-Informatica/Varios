#INCLUDE "protheus.ch"
#INCLUDE "TopConn.ch"

User Function SuperSQL

// Vari?veis do Programa
Private nRet			:= -1
Private nI				:= 0
Private nLineErrSize	:= 120
Private cError
Private oDlg
Private aAdvSize		:= {}
Private lDlgPadSiga   	:= .f.
Private aObjects 		:= {}
Private aSize    		:= MsAdvSize( .T. )
Private aPosObj  		:= {}
Private aInfo    		:= {}

Private _aHeader		:= {}
Private _aData			:= {}
Private _oGetDados

Private oFnt, oTela, oTexto

Private _cPic			:= ""
Private _cArq
Private _cArqTxt	  	:= ""
Private _cQryArq		:= ""
Private _aTF  			:= {}
Private _nTF			:= 0
Private _cCampo 		:= ""
Private _cTitXML 		:= ""
Private _cPlaXML 		:= ""
Private _lShowQry 		:= .f.
Private _cArqXML 		:= "SUPERSQL.XML"

lDlgPadSiga	:= .F.
aAdvSize	:= MsAdvSize( NIL , lDlgPadSiga )

_cArqTxt := "XMLTEMP.XML"
_cArq 	 := fCreate(_cArqTxt,0)

CursorWait()

// Carrega di?logo de abertura de arquivo.
_cQryArq := cGetFile("Script SQL|*.SQL|Todos os Arquivos|*.*",OemToAnsi("Abrir Script SQL..."),1,"",.T.)

// Sai da rotina se o nome do arquivo n?o for escolhido.
If Empty(_cQryArq)
	Return
EndIf

// Carrega a query do arquivo escolhido.
cQuery := ""
LerScript(_cQryArq)

// Sai da rotina se n?o houver dados na Query.
If Empty(cQuery)
	Return
EndIF

// Caso configurou para mostrar Query.
If _lShowQry
	MsgInfo(cQuery,"Dados da Query")
EndIf

// Valida query
nRet := TCSQLExec(cQuery)

// Verifica se ocorreu erro e mostra quais as ocorr?ncias ao usu?rio.
If nRet < 0
	
	cError := TCSQLError()
	
	_aHeader		:= {{	'ERRO', 'ERRO', '@!', nLineErrSize, 0,"AllWaysTrue()",	"??????????????", "C",,,1,, }}
	For nI := 1 to MLCount(cError,nLineErrSize)
		aadd(_aData, { AllTrim(MemoLine(cError,nLineErrSize,nI)),.F.} )
	Next nI
	
	// Executa query criando a tabela tempor?rio caso n?o tenha ocorrido erro.
Else
	TcQuery cQuery New Alias "QRYEDITOR"
	If Len(_aTF)>0
		For _nTF := 1 to Len(_aTF)
			TcSetField("QRYEDITOR", _aTF[_nTF][1], _aTF[_nTF][2], _aTF[_nTF][3], _aTF[_nTF][4])
		Next
	EndIf
	
	// Monta o cabecalho do Result Set
	For nI:=1 To QRYEDITOR->( FCount() )
		
		cNomeCampo	:= QRYEDITOR->( FieldName(nI) )
		_cCampo := ("QRYEDITOR->("+cNomeCampo+")")
		cTipoCampo	:= ValType(&(_cCampo))
		
		If "R_E_C" $ cNomeCampo .or. "D_E_L_" $ cNomeCampo
			// Skip
		Else
			
			If cTipoCampo == "C"
				nTamanCampo	:= Len(&(_cCampo))
				If nTamanCampo < Len(cNomeCampo)
					nTamanCampo :=  Len(cNomeCampo)
				EndIf
				nDecimCampo	:= 0
				_cPic := "@!"
				cTipoCampo := "C"
			ElseIf cTipoCampo == "D"
				nTamanCampo	:= 15
				nDecimCampo	:= 0
				_cPic := "@!"
			ElseIf cTipoCampo == "N"
				nTamanCampo	:= 15
				nDecimCampo	:= 2
				_cPic := "@E 999,999,999.99"
			Else
				nTamanCampo	:= 15
				nDecimCampo	:= 2
				_cPic := "@!"
				cTipoCampo := "N"
			Endif
			
			//               T?tulo      Nome do Campo  Pic    Tamanho      Decimais    Valid            Usado             Tipo F3                 cBos Rela??o
			AADD(_aHeader, {	cNomeCampo, cNomeCampo, _cPic, nTamanCampo, nDecimCampo,"",	"??????????????", cTipoCampo,,,,, } )
			
		EndIf
		
	Next nI
	
	// Carrega os dados da query
	Do While !QRYEDITOR->(Eof())
		AADD(_aData,Array(QRYEDITOR->( FCount() )+1))
		For nI:=1 To QRYEDITOR->( FCount() )
			_aData[Len(_aData),nI] := FieldGet(FieldPos(QRYEDITOR->( FieldName(nI) )))
		Next nI
		_aData[Len(_aData),QRYEDITOR->( FCount() )+1] := .F.
		QRYEDITOR->(dbSkip())
	Enddo
	
	// Fecha tab.tempor?ria.
	QRYEDITOR->(dbCloseArea())
	
Endif

DEFINE MSDIALOG oDlg  FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] PIXEL TITLE "SUPER SQL"
AAdd( aObjects, { 100, 100 , .T., .T. })
aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects)
//oGetDados1:= MsNewGetDados():New(nSuperior    ,nEsquerda    ,nInferior    ,nDireita     ,nOpc ,cLinOk,cTudoOk,cIniCpos  ,aAlter,nFreeze,nMax          ,cFieldOk,cSuperDel   ,cDelOk   ,oWnd,aHead    ,aCol)
_oGetDados:=  MsNewGetDados():New(aPosObj[1][1]+10,aPosObj[1][2],aPosObj[1][3],aPosObj[1][4],0    ,      ,       ,          ,      ,       ,Len(_aData),        ,/*superdel*/,/*delok*/,oDlg,_aHeader,_aData)
oDlg:Refresh()
CursorArrow()
@005,005 BUTTON "Gerar XML" SIZE 30,13 FONT oDlg:oFont ACTION Processa({|| GeraXML() }) OF oDlg PIXEL
@005,050 BUTTON "Sair"      SIZE 30,13 FONT oDlg:oFont ACTION oDlg:End() OF oDlg PIXEL
Activate MsDialog oDlg Centered

Return


Static Function GeraXML()

Local _cLinXML := "4"
Local _cColXML := "3"
Local _nAuxXML1:= 0
Local _nAuxXML2:= 0
Local _cTipoXML:= ""

_cColXML := Alltrim(Str(Len(_aHeader)))
_cLinXML := Alltrim(Str(3 + Len(_aData)))

ExpTxt('<?xml version="1.0"?>')
ExpTxt('<?mso-application progid="Excel.Sheet"?>')
ExpTxt('<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"')
ExpTxt(' xmlns:o="urn:schemas-microsoft-com:office:office"')
ExpTxt(' xmlns:x="urn:schemas-microsoft-com:office:excel"')
ExpTxt(' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"')
ExpTxt(' xmlns:html="http://www.w3.org/TR/REC-html40">')
ExpTxt(' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">')
ExpTxt('  <Author>jdsilva</Author>')
ExpTxt('  <LastAuthor>jdsilva</LastAuthor>')
ExpTxt('  <Created>2008-04-27T05:28:31Z</Created>')
ExpTxt('  <Version>12.00</Version>')
ExpTxt(' </DocumentProperties>')
ExpTxt(' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">')
ExpTxt('  <WindowHeight>8100</WindowHeight>')
ExpTxt('  <WindowWidth>15135</WindowWidth>')
ExpTxt('  <WindowTopX>120</WindowTopX>')
ExpTxt('  <WindowTopY>60</WindowTopY>')
ExpTxt('  <ProtectStructure>False</ProtectStructure>')
ExpTxt('  <ProtectWindows>False</ProtectWindows>')
ExpTxt(' </ExcelWorkbook>')
ExpTxt(' <Styles>')
ExpTxt('  <Style ss:ID="Default" ss:Name="Normal">')
ExpTxt('   <Alignment ss:Vertical="Bottom"/>')
ExpTxt('   <Borders/>')
ExpTxt('   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>')
ExpTxt('   <Interior/>')
ExpTxt('   <NumberFormat/>')
ExpTxt('   <Protection/>')
ExpTxt('  </Style>')

// Data
ExpTxt('  <Style ss:ID="s64">')
ExpTxt('   <Borders>')
ExpTxt('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('   </Borders>')
ExpTxt('   <NumberFormat ss:Format="dd/mm/yy;@"/>')
ExpTxt('  </Style>')

// N?mero
ExpTxt('  <Style ss:ID="s66">')
ExpTxt('   <Borders>')
ExpTxt('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('   </Borders>')
ExpTxt('   <NumberFormat ss:Format="Standard"/>')
ExpTxt('  </Style>')

// Data
ExpTxt('  <Style ss:ID="s67">')
ExpTxt('   <Borders>')
ExpTxt('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('   </Borders>')
ExpTxt('   <NumberFormat ss:Format="@"/>')
ExpTxt('  </Style>')

ExpTxt('  <Style ss:ID="s70">')
ExpTxt('   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="18" ss:Color="#000000"')
ExpTxt('    ss:Bold="1"/>')
ExpTxt('  </Style>')
ExpTxt('  <Style ss:ID="s71">')
ExpTxt('   <Borders>')
ExpTxt('    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>')
ExpTxt('   </Borders>')
ExpTxt('   <Interior ss:Color="#00B0F0" ss:Pattern="Solid"/>')
ExpTxt('  </Style>')
ExpTxt(' </Styles>')
ExpTxt(' <Worksheet ss:Name="'+_cPlaXML+'">')
ExpTxt('  <Table ss:ExpandedColumnCount="'+_cColXML+'" ss:ExpandedRowCount="'+_cLinXML+'" x:FullColumns="1"')
ExpTxt('   x:FullRows="1" ss:DefaultRowHeight="15">')
ExpTxt('   <Column ss:AutoFitWidth="0" ss:Width="56.25"/>')
ExpTxt('   <Column ss:AutoFitWidth="0" ss:Width="82.5"/>')
ExpTxt('   <Row ss:Height="23.25">')
ExpTxt('    <Cell ss:StyleID="s70"><Data ss:Type="String">'+_cTitXML+'</Data></Cell>')
ExpTxt('   </Row>')

// T?tulos das Colunas
ExpTxt('   <Row ss:Index="3">')
For _nAuxXML1 :=1 to Val(_cColXML)
	ExpTxt('    <Cell ss:StyleID="s71"><Data ss:Type="String">'+_aHeader[_nAuxXML1][1]+'</Data></Cell>')
Next
ExpTxt('   </Row>')

// Insere os Dados
ProcRegua(Len(_aData))
For _nAuxXML1 := 1 to Len(_aData) //Lin
	IncProc("Aguarde, gerando XML...")
	ExpTxt('   <Row>')
	For _nAuxXML2 := 1 to Val(_cColXML) // Coluna
		_cTipoXML := ValType(_aData[_nAuxXML1][_nAuxXML2])
		
		If _cTipoXML=="C"
			ExpTxt('    <Cell ss:StyleID="s67"><Data ss:Type="String">'+XMLAcento(_aData[_nAuxXML1][_nAuxXML2],.f.,.f.)+'</Data></Cell>')
		ElseIf _cTipoXML=="N"
			ExpTxt('    <Cell ss:StyleID="s66"><Data ss:Type="Number">'+Alltrim(Str(_aData[_nAuxXML1][_nAuxXML2]))+'</Data></Cell>')
		ElseIf _cTipoXML=="D"
			ExpTxt('    <Cell ss:StyleID="s64"><Data ss:Type="DateTime">'+DataToXML(_aData[_nAuxXML1][_nAuxXML2])+'</Data></Cell>')
		Else
			ExpTxt('    <Cell ss:StyleID="s67"><Data ss:Type="String">'+_aData[_nAuxXML1][_nAuxXML2]+'</Data></Cell>')
		EndIf
	Next
	ExpTxt('   </Row>')
Next

// Simples Anota??o
/*
ExpTxt('    <Cell ss:StyleID="s64"><Data ss:Type="DateTime">2008-06-28T00:00:00.000</Data></Cell>')
ExpTxt('    <Cell ss:StyleID="s66"><Data ss:Type="Number">1000000</Data></Cell>')
ExpTxt('    <Cell ss:StyleID="s67"><Data ss:Type="String">TESTE</Data></Cell>')
*/

// Finaliza??o da planilha.
ExpTxt('  </Table>')
ExpTxt('  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">')
ExpTxt('   <PageSetup>')
ExpTxt('    <Header x:Margin="0.31496062000000002"/>')
ExpTxt('    <Footer x:Margin="0.31496062000000002"/>')
ExpTxt('    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"')
ExpTxt('     x:Right="0.511811024" x:Top="0.78740157499999996"/>')
ExpTxt('   </PageSetup>')
ExpTxt('   <Print>')
ExpTxt('    <ValidPrinterInfo/>')
ExpTxt('    <PaperSizeIndex>9</PaperSizeIndex>')
ExpTxt('    <HorizontalResolution>600</HorizontalResolution>')
ExpTxt('    <VerticalResolution>0</VerticalResolution>')
ExpTxt('   </Print>')
ExpTxt('   <Selected/>')
ExpTxt('   <DoNotDisplayGridlines/>')
ExpTxt('   <Panes>')
ExpTxt('    <Pane>')
ExpTxt('     <Number>3</Number>')
ExpTxt('     <ActiveRow>1</ActiveRow>')
ExpTxt('    </Pane>')
ExpTxt('   </Panes>')
ExpTxt('   <ProtectObjects>False</ProtectObjects>')
ExpTxt('   <ProtectScenarios>False</ProtectScenarios>')
ExpTxt('  </WorksheetOptions>')
ExpTxt(' </Worksheet>')
ExpTxt(' <Worksheet ss:Name="Plan2">')
ExpTxt('  <Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="1" x:FullColumns="1"')
ExpTxt('   x:FullRows="1" ss:DefaultRowHeight="15">')
ExpTxt('  </Table>')
ExpTxt('  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">')
ExpTxt('   <PageSetup>')
ExpTxt('    <Header x:Margin="0.31496062000000002"/>')
ExpTxt('    <Footer x:Margin="0.31496062000000002"/>')
ExpTxt('    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"')
ExpTxt('     x:Right="0.511811024" x:Top="0.78740157499999996"/>')
ExpTxt('   </PageSetup>')
ExpTxt('   <ProtectObjects>False</ProtectObjects>')
ExpTxt('   <ProtectScenarios>False</ProtectScenarios>')
ExpTxt('  </WorksheetOptions>')
ExpTxt(' </Worksheet>')
ExpTxt(' <Worksheet ss:Name="Plan3">')
ExpTxt('  <Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="1" x:FullColumns="1"')
ExpTxt('   x:FullRows="1" ss:DefaultRowHeight="15">')
ExpTxt('  </Table>')
ExpTxt('  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">')
ExpTxt('   <PageSetup>')
ExpTxt('    <Header x:Margin="0.31496062000000002"/>')
ExpTxt('    <Footer x:Margin="0.31496062000000002"/>')
ExpTxt('    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"')
ExpTxt('     x:Right="0.511811024" x:Top="0.78740157499999996"/>')
ExpTxt('   </PageSetup>')
ExpTxt('   <ProtectObjects>False</ProtectObjects>')
ExpTxt('   <ProtectScenarios>False</ProtectScenarios>')
ExpTxt('  </WorksheetOptions>')
ExpTxt(' </Worksheet>')
ExpTxt('</Workbook>')
fClose(_cArq)

MsgInfo("XML Gerado. Abrindo Excel... (Obs.: todos os acentos/caracteres especiais foram removidos)")

// Copia o arquivo para a m?quina do usu?rio. ??? Melhoria: obter fun??o que retorna o caminho o system.
__COPYFILE ("\system\" + "XMLTEMP.XML", "C:\" + _cArqXML)
If ApOleClient( "MsExcel" )
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:open("C:\" + _cArqXML)
	oExcelApp:setVisible(.T.)
Else
	MsgStop( "MsExcel Nao instalado !" )
	Return
EndIf

Return


Static Function ExpTxt(_cTexto)

fWrite(_cArq,_cTexto + Chr(13) + Chr(10))

Return

Static Function ConvTxt(_nNumber)

// Vari?veis do programa.
Local _cRet

_cRet := Alltrim(Str(_nNumBer))

Return(_cRet)

Static Function DataToXML(_dData)

Local _cRet

_cRet := dtos(_dData)
_cRet := Left(_cRet,4)+"-"+SubStr(_cRet,5,2)+"-"+Right(_cRet,2)

Return(_cRet)


Static FUNCTION LerScript( cFile)

// Vari?veis do Programa.
Local cLin := ""

FT_FUSE(cFile)
FT_FGotop()
While ( !FT_FEof() )
	cLin := AllTrim(FT_FREADLN())
	If Left(cLin,2)<>"--"
		If Left(cLin,11)=="[TOPFIELDD]"
			aAdd(_aTF,{Right(cLin,Len(cLin)-11),"D",8,0})
		ElseIf Left(cLin,11)=="[TOPFIELDN]"
			aAdd(_aTF,{Right(cLin,Len(cLin)-17),"N",Val(subStr(cLin,13,2)),Val(subStr(cLin,15,2))})
		ElseIf Left(cLin,8)=="[TITULO]"
			_cTitXML := XMLAcento(Right(cLin,Len(cLin)-8),.f.,.f.)
		ElseIf Left(cLin,10)=="[PLANILHA]"
			_cPlaXML := XMLAcento(Right(cLin,Len(cLin)-10),.f.,.f.)
		ElseIf Left(cLin,12)=="[RETSQLNAME]"
			cQuery += &("RetSqlName('"+Right(cLin,Len(cLin)-12)+"')")
			cQuery += " "
		ElseIf Left(cLin,10)=="[NODELETE]"
			cQuery += "D_E_L_E_T_=' '"
			cQuery += " "
		ElseIf Left(cLin,6)=="[SHOW]"
			_lShowQry := .t.
		ElseIf Left(cLin,8)=="[ARQXML]"
			_cArqXML := &(Right(cLin,Len(cLin)-8))
		Else
			cQuery += cLin
			cQuery += " "
		EndIf
	EndIf
	FT_FSKIP()
EndDo
FT_FUse()
Return


Static Function XMLAcento(cCpoLmp,lCarPont,lUnder)

Local cAcentos  := "?????????????????????????????????????????????????è???? ?¶?ê?????ëç?????íß??£Å???%$???∞??¨"
Local cAcSubst  := "cCCcaeiouAEIOUaeiouAEIOUaeiouAEIOUaeiouAEIOUaoAOAAAAaaaaaaEEeeeIiiOOooooooUuuuNnPScoiooaq"
Local cCaraPont := "/\.,;:!@#$%&*()-+='[]{}~<>|?®`"
Local nI        := 0
Local nPos      := 0

cCpoLmp 		:= AllTrim( cCpoLmp )
cCpoLmp 		:= NoAcento( OemToAnsi( cCpoLmp ) )

*???????????????
*≥Troca Acentos≥
*???????????????
For nI := 1 To Len( cCpoLmp )
	If ( nPos := At( SubStr( cCpoLmp, nI, 1 ), cAcentos ) ) > 0
		cCpoLmp := SubStr( cCpoLmp, 1, nI - 1 ) + SubStr( cAcSubst, nPos, 1 ) +  SubStr( cCpoLmp, nI + 1 )
	EndIf
Next nI

*??????????????????????????????
*≥Tira Caracteres de pontuacao≥
*??????????????????????????????
If lCarPont
	For nI := 1 To Len( cCpoLmp )
		If ( nPos := At( SubStr( cCpoLmp, nI, 1 ), cCaraPont ) ) > 0
			cCpoLmp := SubStr( cCpoLmp, 1, nI - 1 ) + '#' + SubStr( cCpoLmp, nI + 1 )
		EndIf
	Next nI
EndIf

If lUnder
	cCpoLmp := StrTran( cCpoLmp, '"', "" )
	cCpoLmp := StrTran( cCpoLmp, "#", "" )
	
	cCpoLmp := StrTran( cCpoLmp, " " , "_" )
	cCpoLmp := StrTran( cCpoLmp, "-" , "_" )
	cCpoLmp := StrTran( cCpoLmp, "__", "_" )
EndIf

Return( cCpoLmp )

Static Function Limpa

_aData:={}

_oGetDados:=  MsNewGetDados():New(aPosObj[1][1],aPosObj[1][2],aPosObj[1][3],aPosObj[1][4],0    ,      ,       ,          ,      ,       ,Len(_aData),        ,/*superdel*/,/*delok*/,oDlg,_aHeader,_aData)

_oGetDados:Refresh()
oDlg:Refresh()
_oGetDados:Refresh()

Return

/*
?????????????????????????????????????????????????????????????????????????????
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±????????????????????????????????????????????????????????????????????????ª±±
±±?Programa  ≥NOVO2     ?Autor  ≥Microsiga           ? Data ≥  01/18/08   ?±±
±±?????????????????????????????????????????????????????????????????????????±±
±±?Desc.     ≥                                                            ?±±
±±?          ≥                                                            ?±±
±±?????????????????????????????????????????????????????????????????????????±±
±±?Uso       ≥ AP                                                         ?±±
±±?????????????????????????????????????????????????????????????????????????±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
?????????????????????????????????????????????????????????????????????????????
*/

/*

User Function EKBCUSTO()

// variaveis da MsNewGetDados()
Local aCpoGDa   := {"Z7_CODIGO", "Z7_CODFOR", "Z7_LOJFOR", "Z7_NOMFOR", "Z7_DATA", "Z7_MOEDA", "Z7_VALBASE", "Z7_IMPOSTO", "Z7_DESPESA", "Z7_RECALCU", "Z7_VALFINA", "Z7_VALEXPO"}

// vetor com os campos que poderao ser alterados
Local aAlter    := {"Z7_CODIGO", "Z7_CODFOR", "Z7_LOJFOR", "Z7_NOMFOR", "Z7_DATA", "Z7_MOEDA", "Z7_VALBASE", "Z7_IMPOSTO", "Z7_DESPESA", "Z7_RECALCU", "Z7_VALFINA", "Z7_VALEXPO"}
Local nSuperior := C(022)         // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda := C(005)         // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior := C(223)         // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita  := C(390)         // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem

// posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
Local nOpc      := GD_UPDATE + GD_INSERT + GD_DELETE
Local cLinOk    := "AllwaysTrue"  // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk   := "AllwaysTrue"  // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos  := ""             // Nome dos campos do tipo caracter que utilizarao incremento automatico.
// Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do
// segundo campo>+..."
Local nFreeze   := 001            // Campos estaticos na GetDados.
Local nMax      := 9999           // Numero maximo de linhas permitidas. Valor padrao 99
Local cFieldOk  := "AllwaysTrue"  // Funcao executada na validacao do campo
Local cSuperDel := ""             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cDelOk    := "AllwaysTrue"  // Funcao executada para validar a exclusao de uma linha do aCols

// objeto no qual a MsNewGetDados ser? criada
Local oWnd      := oDlg
Local aHead     := {}             // Array a ser tratado internamente na MsNewGetDados como aHeader
Local aCol      := {}             // Array a ser tratado internamente na MsNewGetDados como aCols

// carrega aHead
DbSelectArea("SX3")
SX3->(DbSetOrder(2)) // Campo
For nX := 1 to Len(aCpoGDa)
If SX3->(DbSeek(aCpoGDa[nX]))
Aadd(aHead,{ AllTrim(X3Titulo()),;
SX3->X3_CAMPO	,;
SX3->X3_PICTURE,;
SX3->X3_TAMANHO,;
SX3->X3_DECIMAL,;
""	,; //SX3->X3_VALID
SX3->X3_USADO	,;
SX3->X3_TIPO	,;
SX3->X3_F3 		,;
SX3->X3_CONTEXT,;
SX3->X3_CBOX	,;
SX3->X3_RELACAO})
Endif
Next

dbSelectArea("SZ7")
dbSetOrder(1)
//dbSeek(xFilial("SZ7") + cReferencia)

While !Eof() .And. SZ7->Z7_FILIAL == xFilial("SZ7") //.And. SZ7->Z7_DATA == cReferencia

aAux := {}

AAdd(aAux, SZ7->Z7_CODIGO)
AAdd(aAux, SZ7->Z7_CODFOR)
AAdd(aAux, SZ7->Z7_LOJFOR)
AAdd(aAux, SZ7->Z7_NOMFOR)
AAdd(aAux, SZ7->Z7_MOEDA)
AAdd(aAux, SZ7->Z7_VALBASE)
AAdd(aAux, SZ7->Z7_IMPOSTO)
AAdd(aAux, SZ7->Z7_DESPESA)
AAdd(aAux, SZ7->Z7_RECALCU)
AAdd(aAux, SZ7->Z7_VALFINA)
AAdd(aAux, SZ7->Z7_VALEXPO)
AAdd(aAux, .F.)
AAdd(aCol, aAux)

SZ7->(dbSkip())
Enddo

oGetDados1:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinOk,cTudoOk,cIniCpos,;
aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oWnd,aHead,aCol)
*/





/*
oGetMail     := MsNewGetDados():New(002,02,097,338,nOpcGD,{||Q100MAILOk()},,"+QUI_ITEM",,,9999,,,,oFolder:aDialogs[4],aHeadSav[5],aDadosAud[5])
*/

/*???????????????????????????????????????????????????????????????????????????
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±?????????????????????????????????????????????????????????????????????????±±
±±≥Fun??o    ≥Q100MAILOk≥ Autor ≥ Paulo Emidio de Barros≥ Data ≥01/11/2000≥±±
±±?????????????????????????????????????????????????????????????????????????±±
±±≥Descri??o ≥ Valida a linha corrente do e-mail associado				  ≥±±
±±?????????????????????????????????????????????????????????????????????????±±
±±≥Sintaxe   ≥ Q100MAILOk()												  ≥±±
±±?????????????????????????????????????????????????????????????????????????±±
±±≥Retorno   ≥ .t. ou .f.												  ≥±±
±±?????????????????????????????????????????????????????????????????????????±±
±±≥ Uso      ≥ QADA100                                                    ≥±±
±±?????????????????????????????????????????????????????????????????????????±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
???????????????????????????????????????????????????????????????????????????*/
/*
Function Q100MAILOk()

Local lRetorno  := .T.
Local nX        := 0
Local nOcoUseNam:= 0

nUsado := Len(aHeader)

For nX := 1 To Len(aCols)
If !(aCols[N,nUsado+1])
If aCols[nX,nPosUseNam] == aCols[N,nPosUseNam]
If !(aCols[nX,nUsado+1])
nOcoUseNam++
EndIf
EndIf
EndIf
Next

If nOcoUseNam > 1
Help("",1,"100EXISMAIL",,OemToAnsi(STR0046)+Chr(13)+OemToAnsi(STR0047),1) // "Exitem email's cadastrados em duplicidade" ### "para esta auditoria."
lRetorno := .F.
Else
If Empty(aCols[N,nOcoUseNam])
If !(aCols[N,nUsado+1])
Help("",1,"100UNUSER")
lRetorno := .F.
EndIf
EndIf
EndIf

Return(lRetorno)
*/


// Melhorias
// apagar arquivo tempor?rio.
// Bot?o para abrir Scripts
// Mostrar os scripts em um listbox
// Bot?o para mostrar Query
// Possibilidade de execu??o on-line de query
// N?o deixar fazer UPDATE, DROP
// N?o deixar abrir arquivos da folha?
