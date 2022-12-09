#Include "Rwmake.ch" 

Static _cRepDb	:= GetSrvProfString("RepositInDataBase","")
Static _cRep	:= SuperGetMv("MV_REPOSIT",.F.,"1")
Static _lRepDb	:= ( _cRepDb == "1" .And. _cRep == "2" )

//+------------------------------------------------------------------+
//| Rotina | GP260FOTO | Autor | Rafael Beghini | Data | 17/07/2014  |
//+------------------------------------------------------------------+
//| Descr. | Exibe a foto do funcionário na consulta da Ficha de     |
//|        | registro e impressão.                                   |
//+------------------------------------------------------------------+
//| Uso    | Administração de Pessoal	                             |
//+------------------------------------------------------------------+

User Function GP260FOTO()  

	Private Dlg_Foto,Bmp_Foto,Bt_Encerra 
	Private cFoto := '' 
	
	Dlg_Foto := MSDIALOG():Create()
	Dlg_Foto:cName := "Dlg_Foto"
	Dlg_Foto:cCaption := Capital(SRA->RA_NOME)
	Dlg_Foto:nLeft := 0
	Dlg_Foto:nTop := 0
	Dlg_Foto:nWidth := 280
	Dlg_Foto:nHeight := 380
	Dlg_Foto:lShowHint := .F.
	Dlg_Foto:lCentered := .T.
	
	Bmp_Foto := TBITMAP():Create(Dlg_Foto)
	Bmp_Foto:cName := "Bmp_Foto"
	Bmp_Foto:nLeft := 6
	Bmp_Foto:nTop := 6
	Bmp_Foto:nWidth := 147
	Bmp_Foto:nHeight := 150
	Bmp_Foto:lShowHint := .F.
	Bmp_Foto:lReadOnly := .T.
	Bmp_Foto:Align := 5
	Bmp_Foto:lVisibleControl := .T.
	Bmp_Foto:cBmpFile := fFoto()
	Bmp_Foto:lStretch := .T.
	Bmp_Foto:lAutoSize := .F.
	
	Dlg_Foto:Activate()   
	
	Ferase( cFoto )

Return

//+--------------------------------------------------------------+
//| Rotina | fFoto | Autor | Rafael Beghini | Data | 17/07/2014  |
//+--------------------------------------------------------------+
//| Descr. | Carrega a foto para mostrar na tela e no relatorio. |
//|        | 					                                 |
//+--------------------------------------------------------------+
//| Uso    | Administração de Pessoal                            |
//+--------------------------------------------------------------+
Static Function fFoto()

	Local aArea		:= GetArea()
	Local cAlias	:= "PROTHEUS_REPOSIT"
	Local cBmpPict	:= ""
	Local cPath		:= GetSrvProfString("Startpath","")
	Local lFile		
	Local oDlg8
	Local oBmp 
	Local oPrint
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Carrega a Foto do Funcionario								   ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	cBmpPict := Upper( AllTrim( SRA->RA_BITMAP)) 
	cPathPict 	:= ( cPath + cBmpPict ) 
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Para impressao da foto eh necessario abrir um dialogo para   ³
	³ extracao da foto do repositorio.No entanto na impressao,nao  |
	³ ha a necessidade de visualiza-lo( o dialogo).Por esta razao  ³
	³ ele sera montado nestas coordenadas fora da Tela             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	DEFINE MSDIALOG oDlg8   FROM -1000000,-4000000 TO -10000000,-8000000  PIXEL 
	@ -10000000, -1000000000000 REPOSITORY oBmp SIZE -6000000000, -7000000000 OF oDlg8  
	
	If _lRepDb
		dbSelectArea(cAlias)
		(cAlias)->( dbSeek(cBmpPict) )
	EndIf
	
	// Verifica se a imagem existe no repositorio
	If oBMP:ExistBMP(cBmpPict)
		If !_lRepDb
			oBmp:LoadBmp(cBmpPict)
		EndIf
		
		IF !Empty( cBmpPict := Upper( AllTrim( SRA->RA_BITMAP ) ) )
			lFile:=oBmp:Extract(cBmpPict, cPathPict)
			If lFile 
				If File(cPathPict+".BMP") 
					cFoto := cPathPict + ".BMP"
				ElseIf File(cPathPict+".JPG")
					cFoto := cPathPict + ".JPG"
				EndIf
			EndIf	
		EndIf	
	EndIf
	ACTIVATE MSDIALOG oDlg8 ON INIT (oBmp:lStretch := .T., oDlg8:End())
	
	RestArea(aArea)

Return cFoto