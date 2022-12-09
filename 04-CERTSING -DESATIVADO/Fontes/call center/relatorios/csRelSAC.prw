#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณcsRelSAC    บAutor  ณLeandro Nishihata   บ Data ณ  12/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAnแlise Resultado de Venda						          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user Function csRelSAC()

	Local nHeight
	Local nDiaHei			:= oMainWnd:nClientHeight * .97
	Local nDiaWid			:= oMainWnd:nClientWidth
	Local nHei
	Local nHeiPmid
	Local nWidPmid
	//------------
	
	Local nLinha 	:= 0
	Local nCol1 	:= 5
	Local nCol2 	:= 60
	Local nCol3 	:= 110
	Local nRadio    := Nil
	Local oRadio    := Nil
	Local aRadio    := {}
	Local oanalitico
	Local lanalitico := .T.
	Local osintetico
	Local lsintetico := .F.
	Private oBrowse 	:= nil
	Private oFont18n	:= TFont():New('Courier new',,-18,.T., .t.)
	Private oFont14n	:= TFont():New('Courier new',,-14,.T., .T.)
	Private oFont12 	:= TFont():New('Courier new',,-12,.T., .T.)
	Private oFWLayer	:= NIL
	Private oDlg		:= NIL

	//------------------------parametros mostrados em tela---------------------
	Private DDatade 	:= stod(space(8))
	Private DDataate 	:= stod(space(8))
	Private cDesctipo   := SPACE(200)
	Private Ctipo 		:= SPACE(100)
	Private Cgrpatend 	:= SPACE(255)
	Private Canalista 	:= SPACE(255)
	Private atipo 		:= {}
	Private agrpatend 	:= {}
	Private aanalista 	:= {}
	Private oPanelUP    := nil
	Private oPanelMidL  := nil
	Private oPanelMidR  := nil
	Private oPanelDW    := nil
	Private cCxDados
	Private cCxFiltro
	Private cTitDados 	:= "Dados"
	Private cTitFiltro  := "Filtro a ser realizado"
	Private Afiltro     := array(5)
	//---------------------- markbrow

	Private mudougrupo := .t.

	DEFINE DIALOG oDlg TITLE "Anแlise Resultado de Venda" FROM 000,000 TO nDiaHei,nDiaWid PIXEL

	oFWLayer := FWLayer():New()
	oFWLayer:Init( oDlg, .F., .T. )
	oFWLayer:AddLine( 'CIMA', 10, .F. )
	oFWLayer:AddLine( 'MEIO', 30, .F. )
	oFWLayer:AddLine( 'BAIXO', 60, .F. )
	oFWLayer:AddCollumn( 'COLCIMA', 100, .T., 'CIMA')
	oFWLayer:AddCollumn( 'COLMEIOE', 50, .T., 'MEIO')
	oFWLayer:AddCollumn( 'COLMEIOD', 50, .T., 'MEIO')
	oFWLayer:AddCollumn( 'COLBAIXO', 100, .T., 'BAIXO')
	oPanelUP   := oFWLayer:GetColPanel( 'COLCIMA', 'CIMA' )
	oPanelMidL := oFWLayer:GetColPanel( 'COLMEIOE', 'MEIO' )
	oPanelMidR := oFWLayer:GetColPanel( 'COLMEIOD', 'MEIO' )
	oPanelDW   := oFWLayer:GetColPanel( 'COLBAIXO', 'BAIXO' )

	//-----painel central esquerdo--------------------------------------------------------------
	nHeight		:= oPanelMidL:nClientHeight * .90
	nHei			:= (	(nHeight/2)	/5)

	@ nLinha,190 SAY "Relat๓rio SAC - Anแlise Resultado de Venda " OF oPanelUP PIXEL FONT oFont18n
	@ nLinha,nCol1 Say   "Perํodo de:" 	Size 050,10 COLOR CLR_RED PIXEL OF oPanelMidL
	@ nLinha,nCol2 MSGET oData1 VAR DDatade PICTURE "@D" SIZE 50, 10   PIXEL OF oPanelMidL VALID (Afiltro[1] := DDatade,MontaFiltro() )
	nLinha:=nLinha+nHei

	@ nLinha,nCol1 Say   "Perํodo at้:" 	Size 050,10 COLOR CLR_RED PIXEL OF oPanelMidL
	@ nLinha,nCol2 MSGET oData2 VAR DDataate PICTURE "@D" SIZE 050, 10 OF oPanelMidL PIXEL VALID (Afiltro[2] := DDataate,MontaFiltro() )
	nLinha:=nLinha+nHei

	@ nLinha,nCol1 Say   "Tipo:" 	Size 050,10 COLOR CLR_RED PIXEL OF oPanelMidL
	@ nLinha,nCol2 MSGET otipo VAR Ctipo SIZE 050, 10 OF oPanelMidL PIXEL VALID (if(alltrim(Ctipo)<> '',validtipo("trbtipo"),),if(alltrim(Ctipo)<> '',MontaFiltro(),))

	@ nLinha,nCol3 Button "Pesq. &Tipo"	Size 70,10 Action (btn_tipo() )	Pixel Of oPanelMidL
	nLinha:=nLinha+nHei

	@ nLinha,nCol1 Say   "Grupo Atend:" 	Size 050,10 COLOR CLR_RED PIXEL OF oPanelMidL
	@ nLinha,nCol2 GET ogrpatend VAR Cgrpatend OF oPanelMidL MULTILINE SIZE 050, 10 COLORS 0, 16777215 HSCROLL PIXEL  VALID (if(alltrim(Cgrpatend)<> '',validgrupo("TRBGRUPO"),),if(alltrim(Cgrpatend)<> '',MontaFiltro(),''))

	@ nLinha,nCol3 Button "Pesq. &Grupo"	Size 70,10 Action (btn_grupo() ) Pixel Of oPanelMidL
	nLinha:=nLinha+nHei

	@ nLinha,nCol1 Say   "Analista:" 	Size 050,10 COLOR CLR_RED PIXEL OF oPanelMidL
	@ nLinha,nCol2 GET oanalista VAR Canalista OF oPanelMidL MULTILINE SIZE 050, 10 COLORS 0, 16777215 HSCROLL PIXEL  VALID (if(alltrim(Canalista)<> '',if(empty(Cgrpatend),alert("Por favor, selecionar o grupo de atendimento !!!"),validAnalista("TRBANALISTA")),),if(alltrim(Canalista)<> '',MontaFiltro(),))
	@ nLinha,nCol3 Button "Pesq. &Analista"	Size 70,10 Action (if(empty(Cgrpatend),alert("Por favor, selecionar o grupo de atendimento !!!"), btn_analista() ))		Pixel Of oPanelMidL

	//-----painel central direito--------------------------------------------------------------
	nHeimidR := (oPanelMidR:nClientHeight) *.97
	nWidmidR := (oPanelMidR:nClientWidth) *.97

	aAdd(aRadio,      "Analํtico" )
	//aAdd(aRadio,      "Sint้tico" ) 

	cCxDados := "Perํodo de: "  + Chr(13) + Chr(10)
	cCxDados += "Perํodo at้:" + Chr(13) + Chr(10)
	cCxDados += "Tipo(s):" + Chr(13) + Chr(10)
	cCxDados += "Grupo(s) atend:" + Chr(13) + Chr(10)  + Chr(13) + Chr(10)
	cCxDados += "Analista(s):"

	@ 000,000 GET oTitDados  VAR cTitDados  OF oPanelMidR READONLY MULTILINE SIZE ((nWidmidR/2)*20)/100, 010 COLORS 16777215, 16777215 HSCROLL PIXEL FONT oFont14n
	@ 000,064 GET oTitFiltro VAR cTitFiltro OF oPanelMidR READONLY MULTILINE SIZE ((nWidmidR/2)*80)/100, 010 COLORS 0, 16777215 HSCROLL PIXEL FONT oFont14n
	@ 010,000 GET oCxDados   VAR cCxDados  OF oPanelMidR READONLY MULTILINE SIZE ((nWidmidR/2)*20)/100,065 COLORS 0, 16777215 HSCROLL PIXEL //FONT oFont10
	@ 010,064 GET oCxFiltro  VAR cCxFiltro OF oPanelMidR READONLY MULTILINE SIZE ((nWidmidR/2)*80)/100,065 COLORS 0, 16777215 HSCROLL PIXEL //FONT oFont10
	nRadio := 1
	oRadio := TRadMenu():New (077,000,aRadio,,oPanelMidR,,,,,,,,100,12,,,,.T.,.T.)
	oRadio:bSetGet := {|u|Iif (PCount()==0,nRadio,nRadio:=u)}

	//-----paineldw--------------------------------------------------------------
	ACTIVATE DIALOG oDlg  ON INIT EnchoiceBar(oDlg,{|| imprel()},{|| oDlg:End()}) //Fecha a Area e elimina os arquivos de apoio criados em disco.

return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณbtn_tipo    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ F็ใo do botao pesq. tipo                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function btn_tipo()
	lOCAL nI
	lOCAL _stru
	Local fpgto := ""
	Local lMarcar := .f.
	Local cArq

	if type("oBrowse") = "O"
		oBrowse:DeActivate()
		oBrowse := nil
	endif

	If (Select("Trbtipo") = 0)
		_stru := {}
		AADD(_stru,{"OK"    ,"C" ,2	 ,0		})
		AADD(_stru,{"codigo","C" ,1	 ,0		})
		AADD(_stru,{"Fpgto" ,"C" ,50 ,0		})

		carq := Criatrab(_stru,.T.)
		dbUseArea(.T.,,carq,"Trbtipo",Nil,.F.)

		for nI:=1 to 9
			fpgto := X3Combo("C5_TIPMOV",alltrim(str(ni))) // monta opcoes com base nas opcoes possivels do campo C5_TIPMOV, CAMPO MODIFICADO DURANTE HOMOLOGACAO.....//C5_XFORPGT - CAMPO UTILIZADO CONFORME DOCUMENTACAO
			if !empty(fpgto)
				RecLock("Trbtipo",.t.)
				Trbtipo->Codigo := alltrim(str(ni))
				Trbtipo->Fpgto  := alltrim(fpgto)
				MsunLock()
			endif
		next
	Endif

	oBrowse:= FWMarkBrowse():New()
	oBrowse:SetDescription("Tipo de Pagamento") //Titulo da Janela
	oBrowse:SetAlias("Trbtipo") //Indica o alias da tabela que serแ utilizada no Browse
	oBrowse:SetFieldMark("OK") //Indica o campo que deverแ ser atualizado com a marca no registro
	oBrowse:SetTemporary() //Indica que o Browse utiliza tabela temporแria
	oBrowse:SetOwner( oPanelDW )
	OBrowse:DisableReport() // Desabilita a opcao de imprimir
	OBrowse:DisableConfig()	//Desabilita a utiliza็ใo das configura็๕es do Browse
	OBrowse:DisableFilter() //Desabilita a utiliza็ใo do filtro no Browse
	OBrowse:DisableLocate() //Desabilita a utiliza็ใo do localizador de registro no Browse
	OBrowse:DisableSeek()   //Desabilita a utiliza็ใo da pesquisa no Browse
	OBrowse:DisableSaveConfig() //Desabilita a grava็ใo das configura็๕es realizadas no Browse
	OBrowse:SetSemaphore(.F.)        // Define se utiliza marcacao exclusiva
	oBrowse:bAllMark := { || Inverte(oBrowse:Mark(),lMarcar := !lMarcar,"Trbtipo" ), oBrowse:Refresh(.T.)  }
	OBrowse:bAfterMark := { || mark(oBrowse:Mark(),lMarcar := !lMarcar,"Trbtipo" )  }

	//-------------------------------------------------------------------
	// Adiciona as colunas do Browse
	//-------------------------------------------------------------------

	oBrowse:SetColumns(montagrid("Trbtipo->codigo"	,"C๓digo"		,02,"@!",1,006,0))
	oBrowse:SetColumns(montagrid("Trbtipo->fpgto","Forma de pagamento"				,03,"@!",1,002,0))
	oBrowse:Activate()
	oBrowse:oBrowse:Setfocus() //Seta o foco na grade
	//processa({|| recupera(oBrowse:Mark(),"Trbtipo")} ,"carregando registros")
	recupera(oBrowse:Mark(),"Trbtipo")

return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณbtn_grupo    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ F็ใo do botao pesq. grupo                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function btn_grupo()
	lOCAL nI
	lOCAL _stru
	Local fpgto := ""
	Local lMarcar := .f.
	Local _cArq		:= "T1_"+Criatrab(,.F.)

	if type("oBrowse") = "O"
		oBrowse:DeActivate()
	endif

	If (Select("trbgrupo") = 0)

		cSQL := "SELECT '  ' OK , U0_CODIGO, U0_NOME  FROM "+RetSqlName("SU0")+" WHERE D_E_L_E_T_ = ' ' and U0_FILIAL = '"+xfilial("SU0")+"' ORDER BY U0_CODIGO"

		cSQL := ChangeQuery( cSQL )
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),"trbgrupo",.T.,.F.)
		dbSelectArea("trbgrupo")
		copy to &_carq
		trbgrupo->(dbclosearea())
		dbUseArea( .T.,__LOCALDRIVER, _cArq,"trbgrupo", .T. , .F. )
		dbSelectArea("trbgrupo")
		dbGoTop()

	Endif

	trbgrupo->(DbGoTop())
	oBrowse:= FWMarkBrowse():New()
	oBrowse:SetDescription("Grupo de atendimento") //Titulo da Janela
	oBrowse:SetAlias("trbgrupo") //Indica o alias da tabela que serแ utilizada no Browse
	oBrowse:SetFieldMark("OK") //Indica o campo que deverแ ser atualizado com a marca no registro
	oBrowse:SetTemporary() //Indica que o Browse utiliza tabela temporแria
	oBrowse:SetOwner( oPanelDW )
	OBrowse:DisableReport() // Desabilita a opcao de imprimir
	OBrowse:DisableConfig()	//Desabilita a utiliza็ใo das configura็๕es do Browse
	OBrowse:DisableFilter() //Desabilita a utiliza็ใo do filtro no Browse
	OBrowse:DisableLocate() //Desabilita a utiliza็ใo do localizador de registro no Browse
	OBrowse:DisableSeek()   //Desabilita a utiliza็ใo da pesquisa no Browse
	OBrowse:DisableSaveConfig() //Desabilita a grava็ใo das configura็๕es realizadas no Browse
	OBrowse:SetSemaphore(.F.)        // Define se utiliza marcacao exclusiva

	oBrowse:bAllMark := { || Inverte(oBrowse:Mark(),lMarcar := !lMarcar,"trbgrupo" ), oBrowse:Refresh(.T.)   }
	OBrowse:bAfterMark := { || mark(oBrowse:Mark(),lMarcar := !lMarcar,"trbgrupo" )   }
	OBrowse:DisableReport()          // Desabilita a opcao de imprimir
	OBrowse:SetSemaphore(.F.)        // Define se utiliza marcacao exclusiva

	//-------------------------------------------------------------------
	// Adiciona as colunas do Browse
	//-------------------------------------------------------------------

	oBrowse:SetColumns(montagrid("trbgrupo->U0_CODIGO"	,"C๓digo"				,02,"@!",1,002,0))
	oBrowse:SetColumns(montagrid("trbgrupo->U0_NOME","Grupo de Atendimento" 	,03,"@!",1,080,0))
	oBrowse:Activate()
	oBrowse:oBrowse:Setfocus() //Seta o foco na grade
	processa({|| recupera(oBrowse:Mark(),"trbgrupo")} ,"carregando registros")
	//recupera(oBrowse:Mark(),"trbgrupo")
return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณbtn_analista    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ F็ใo do botao pesq. analista                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function btn_analista()

	lOCAL nI
	lOCAL _stru
	Local fpgto := ""
	Local lMarcar := .f.
	Local _cArq		:= "T2_"+Criatrab(,.F.)

	if type("oBrowse") = "O"
		oBrowse:DeActivate()
	endif

	If Select("Trbanalista") = 0 .or. mudougrupo
		mudougrupo := .F.
		If Select("Trbanalista") > 0
			Trbanalista->(dbclosearea())
		endif

		cSQL := "select '  ' OK, U7_COD, U7_NOME, U7_NREDUZ from "+RetSqlName("SU7")+"  WHERE D_E_L_E_T_ = ' ' and U7_POSTO IN ('" + editin(Cgrpatend) + "') AND U7_FILIAL = '"+xfilial("SU0")+"' ORDER BY U7_NOME"
		cSQL := ChangeQuery( cSQL )
		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cSQL),"Trbanalista",.T.,.F.)
		dbSelectArea("Trbanalista")
		copy to &_carq
		Trbanalista->(dbclosearea())
		dbUseArea( .T.,__LOCALDRIVER, _cArq,"Trbanalista", .T. , .F. )
		dbSelectArea("Trbanalista")
		dbGoTop()

	Endif

	Trbanalista->(DbGoTop())
	oBrowse:= FWMarkBrowse():New()
	oBrowse:SetDescription("Nome do analista no Service-desk") //Titulo da Janela
	oBrowse:SetAlias("Trbanalista") //Indica o alias da tabela que serแ utilizada no Browse
	oBrowse:SetFieldMark("OK") //Indica o campo que deverแ ser atualizado com a marca no registro
	oBrowse:SetTemporary() //Indica que o Browse utiliza tabela temporแria
	oBrowse:SetOwner( oPanelDW )
	OBrowse:DisableReport() // Desabilita a opcao de imprimir
	OBrowse:DisableConfig()	//Desabilita a utiliza็ใo das configura็๕es do Browse
	OBrowse:DisableFilter() //Desabilita a utiliza็ใo do filtro no Browse
	OBrowse:DisableLocate() //Desabilita a utiliza็ใo do localizador de registro no Browse
	OBrowse:DisableSeek()   //Desabilita a utiliza็ใo da pesquisa no Browse
	OBrowse:DisableSaveConfig() //Desabilita a grava็ใo das configura็๕es realizadas no Browse
	OBrowse:SetSemaphore(.F.)   // Define se utiliza marcacao exclusiva
	oBrowse:bAllMark := { || processa({|| Inverte(oBrowse:Mark(),lMarcar := !lMarcar,"Trbanalista" )} ,"Marcando/desmarcando todos os registros."), oBrowse:Refresh(.T.)  }
	OBrowse:bAfterMark := { || mark(oBrowse:Mark(),lMarcar := !lMarcar,"Trbanalista" )  }

	//-------------------------------------------------------------------
	// Adiciona as colunas do Browse
	//-------------------------------------------------------------------

	oBrowse:SetColumns(montagrid("Trbanalista->U7_COD"	,"C๓digo"				,02,"@!",1,006,0))
	oBrowse:SetColumns(montagrid("Trbanalista->U7_NOME","Nome Analista"			,03,"@!",1,040,0))
	oBrowse:SetColumns(montagrid("Trbanalista->U7_NREDUZ","Nome Rereduzido"		,04,"@!",1,015,0))
	oBrowse:Activate()
	oBrowse:oBrowse:Setfocus() //Seta o foco na grade
	oBrowse:Refresh(.T.)
	processa({|| recupera(oBrowse:Mark(),"Trbanalista")} ,"carregando registros")

return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณmontagrid    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para criar as colunas do grid                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function montagrid(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
	Local aColumn
	Local bData 	:= {||}
	Default nAlign 	:= 1
	Default nSize 	:= 20
	Default nDecimal:= 0
	Default nArrData:= 0

	If nArrData > 0
		bData := &("{||" + cCampo +"}")// &("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
	EndIf

	/* Array da coluna
	[n][01] Tํtulo da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Mแscara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	[n][08] Indica se permite a edi็ใo
	[n][09] Code-Block de valida็ใo da coluna ap๓s a edi็ใo
	[n][10] Indica se exibe imagem
	[n][11] Code-Block de execu็ใo do duplo clique
	[n][12] Variแvel a ser utilizada na edi็ใo (ReadVar)
	[n][13] Code-Block de execu็ใo do clique no header
	[n][14] Indica se a coluna estแ deletada
	[n][15] Indica se a coluna serแ exibida nos detalhes do Browse
	[n][16] Op็๕es de carga dos dados (Ex: 1=Sim, 2=Nใo)
	*/
	aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}

Return {aColumn}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInverte    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ seleciona ou deseleciona todos os registros.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Inverte(cMarca,lMarcar,alias)

	Local cAliasSD1 := alias
	Local aAreaSD1  := (cAliasSD1)->( GetArea() )
	ProcRegua(0)

	dbSelectArea(cAliasSD1)
	(cAliasSD1)->( dbGoTop() )

	While !(cAliasSD1)->( Eof() )
		IncProc()
		RecLock( (cAliasSD1), .F. )
		(cAliasSD1)->OK := IIf( lMarcar, cMarca, '  ' )
		MsUnlock()
		retcpo(alias)
		(cAliasSD1)->( dbSkip() )
	EndDo

	RestArea( aAreaSD1 )
	oBrowse:Refresh(.T.)

	Do case
		// tratamento botao tipo de pagamento
		case UPPER(alias) = "TRBTIPO"
		otipo:setfocus()
		case UPPER(alias) = "TRBGRUPO"
		ogrpatend:setfocus()
		case UPPER(alias) = "TRBANALISTA"
		oanalista:setfocus()
	Endcase
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณmark    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ efetua a marcacao do campo mark.               			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function mark(cMarca,lMarcar,alias)

//	lMarcar:= if(alltrim((ALIAS)->OK) = ' ',.F.,.T.)
	RecLock( (ALIAS), .F. )
	(ALIAS)->OK := IIf( lMarcar, cMarca, '  ' )
	MsUnlock()
	retcpo(alias)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณretcpo    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณpreenche caixa de texto com os valores selecionados         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function retcpo(alias)
	Local i := 1

	Do case
		// tratamento botao tipo de pagamento
		case UPPER(alias) = "TRBTIPO"
		ctipo := SPACE(100)
		cDesctipo := ""
		If (ALIAS)->OK = ' '
			if ascan(atipo,(ALIAS)->codigo ) <> 0
				adel(atipo,ascan(atipo,(ALIAS)->codigo ) )
				aSize(atipo,Len(atipo)-1)
			endif
		else
			if ascan(atipo,(ALIAS)->codigo ) = 0
				aadd(atipo,(ALIAS)->codigo )
			endif
		endif
		asort(atipo)
		For i:=1 to len(atipo)
			ctipo := alltrim(ctipo)  + if(empty(ctipo)," ",",") +  alltrim(atipo[i])
			cDesctipo := cDesctipo + if(empty(cDesctipo),"",", ") + X3Combo("C5_TIPMOV",alltrim(atipo[i]))

			ctipoquery  := ""

		next
		Afiltro[3] := cDesctipo

		// tratamento botao grupo
		case UPPER(alias) = "TRBGRUPO"

		mudougrupo:= .T.
		aanalista := {}
		canalista := SPACE(255)
		Afiltro[5]:= canalista
		cgrpatend := SPACE(255)
		cgrpquery := ""

		If (ALIAS)->OK = ' '

			if ascan(agrpatend,alltrim((ALIAS)->U0_CODIGO) ) <> 0
				adel(agrpatend,ascan(agrpatend,alltrim((ALIAS)->U0_CODIGO )) )
				aSize(agrpatend,Len(agrpatend)-1)
			endif

		else

			if ascan(agrpatend,alltrim((ALIAS)->U0_CODIGO )) = 0
				aadd(agrpatend,alltrim((ALIAS)->U0_CODIGO ))
			endif

		endif

		asort(agrpatend)

		For i:=1 to len(agrpatend)
			cgrpatend := alltrim(cgrpatend) + if(empty(cgrpatend),"",",") +  alltrim(agrpatend[i])
			//cgrpquery := cgrpquery + "'"+agrpatend[i]+"',"
		next

		Afiltro[4] := LEFT(cgrpatend,185) + IF(LEN(ALLTRIM(cgrpatend))>185,"(...)"," ")

		// tratamento botao analista
		case UPPER(alias) = "TRBANALISTA"
		Canalista := space(255)
		cdescanalista := ""
		If (ALIAS)->OK = ' '
			if ascan(aanalista,{|x| x[1]=ALLTRIM((ALIAS)->U7_COD)} ) <> 0 // 56
				adel(aanalista,ascan(aanalista,{|x| alltrim(x[1])=ALLTRIM((ALIAS)->U7_COD)} ) )
				aSize(aanalista,Len(aanalista)-1)
			endif
		else
			if ascan(aanalista,{|x| x[1]=ALLTRIM((ALIAS)->U7_COD)} ) = 0
				aadd(aanalista,{ALLTRIM((ALIAS)->U7_COD),(ALIAS)->U7_NREDUZ} )
			endif
		endif

		asort(aanalista)

		For i:=1 to len(aanalista)
			canalista := alltrim(canalista) + if(empty(canalista)," ",",")+ alltrim(aanalista[i][1])
			cdescanalista := cdescanalista + if(empty(cdescanalista)," ",", ")+ alltrim(aanalista[i][2])
			//canalquery  := ""
		next
		Afiltro[5] := LEFT(cdescanalista,260) + IF(LEN(ALLTRIM(cdescanalista))>260,"(...)"," ")

	Endcase
	MontaFiltro()
return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณvalidtipo    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ validacao da caixa de texto (get) tipo                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function validtipo(alias)
	Local cAliasSD1
	Local aAreaSD1
	Local atipo := StrToKArr( ALLTRIM(ctipo), "," )

	btn_tipo()
	cAliasSD1 := alias
	aAreaSD1  := (cAliasSD1)->( GetArea() )
	dbSelectArea(cAliasSD1)
	(cAliasSD1)->( dbGoTop() )

	While !(cAliasSD1)->( Eof() )

		RecLock( (cAliasSD1), .F. )
		(cAliasSD1)->OK :=  if(ascan(atipo,alltrim((cAliasSD1)->codigo)) > 0 ,oBrowse:Mark(),"  ")
		MsUnlock()
		retcpo(alias)

		(cAliasSD1)->( dbSkip() )
	EndDo

	RestArea( aAreaSD1 )
	oBrowse:Refresh(.T.)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณvalidgrupo    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ validacao da caixa de texto (get) grupo                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function validgrupo(alias)
	Local cAliasSD1
	Local aAreaSD1
	Local agrupo := StrToKArr( alltrim(Cgrpatend), "," )

	btn_grupo()
	cAliasSD1 := alias
	aAreaSD1  := (cAliasSD1)->( GetArea() )
	dbSelectArea(cAliasSD1)
	(cAliasSD1)->( dbGoTop() )

	While !(cAliasSD1)->( Eof() )
		//	if ((cAliasSD1)->OK = ' ' .and. ascan(agrupo,alltrim((cAliasSD1)->U0_CODIGO)) > 0 ) .or.((cAliasSD1)->OK <> ' ' .and. ascan(agrupo,alltrim((cAliasSD1)->U0_CODIGO)) < 1 )
		RecLock( (cAliasSD1), .F. )
		(cAliasSD1)->OK :=  if(ascan(agrupo,alltrim((cAliasSD1)->U0_CODIGO)) > 0 ,oBrowse:Mark(),"  ")
		MsUnlock()
		retcpo(alias)
		//	endif
		(cAliasSD1)->( dbSkip() )
	EndDo

	RestArea( aAreaSD1 )
	oBrowse:Refresh(.T.)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณvalidgrupo    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ validacao da caixa de texto (get) analista                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function validAnalista(alias)

	Local cAliasSD1
	Local aAreaSD1
	Local aanalista := StrToKArr( alltrim(Canalista), "," )

	btn_analista()
	cAliasSD1 := alias
	aAreaSD1  := (cAliasSD1)->( GetArea() )
	dbSelectArea(cAliasSD1)
	(cAliasSD1)->( dbGoTop() )

	While !(cAliasSD1)->( Eof() )

		RecLock( (cAliasSD1), .F. )
		(cAliasSD1)->OK :=  if(ascan(aanalista,(cAliasSD1)->U7_COD) > 0 ,oBrowse:Mark(),"  ")
		MsUnlock()
		retcpo(alias)

		(cAliasSD1)->( dbSkip() )
	EndDo

	RestArea( aAreaSD1 )
	oBrowse:Refresh(.T.)
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณrecupera    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ remarca os registros previamente marcados                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function recupera(cMarca,alias)

	Local cAliasSD1 := alias
	Local aAreaSD1  := (cAliasSD1)->( GetArea() )
	ProcRegua(0)
	dbSelectArea(cAliasSD1)
	(cAliasSD1)->( dbGoTop() )
	While !(cAliasSD1)->( Eof() )
		IncProc()
		if (cAliasSD1)->OK <> ' '
			RecLock( (cAliasSD1), .F. )
			(cAliasSD1)->OK :=  cMarca
			MsUnlock()
			retcpo(alias)
		endif
		(cAliasSD1)->( dbSkip() )
	EndDo

	RestArea( aAreaSD1 )
	oBrowse:Refresh(.T.)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaFiltro    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณpreenchimento do campo "filtro a ser realizado"		      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function MontaFiltro()

	cCxFiltro := if(empty(Afiltro[1]),"",formatadata(Afiltro[1])) + Chr(13) + Chr(10)
	cCxFiltro += if(empty(Afiltro[2]),"",formatadata(Afiltro[2])) + Chr(13) + Chr(10)
	cCxFiltro += if(empty(Afiltro[3]),"",Afiltro[3]) + Chr(13) + Chr(10)
	cCxFiltro += if(empty(Afiltro[4]),"",Afiltro[4]) + Chr(13) + Chr(10) + Chr(13) + Chr(10)
	cCxFiltro += if(empty(Afiltro[5]),"",Afiltro[5])

return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณimprel    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณchamada Impressao do relatorio							  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function imprel()

	Local oReport
	If TRepInUse()
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef    บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณconfiguracao da Impressao do relatorio				      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
	Local oReport
	Local oSection1
	Local oSection2

	oReport := TReport():New("csRelSAC","Rela๓rio SAC - Anแlise Resultado de Venda","csRelSAC",{|oReport| PrintReport(@oReport)},"Rela๓rio SAC - Anแlise Resultado de Venda")
	oSection1 := TRSection():New(oReport,"Chamados","ADE")

	oSection2 := TRSection():New(oSection1,"PEDIDOS","SC5")
	TRCell():New(oSection2,"ADE_GRUPO","ADE","GRUPO")
	TRCell():New(oSection2,"ADE_OPERAD","ADE","OPERADOR")
	TRCell():New(oSection2,"U7_NOME ","SU7","NOME_OPERADOR")
	TRCell():New(oSection2,"U7_NREDUZ","SU7","NOME_REDUZIDO")
	TRCell():New(oSection2,"C5_CHVBPAG","SC5","PEDGAR")
	TRCell():New(oSection2,"C5_XNPSITE","SC5","PEDSITE")
	TRCell():New(oSection2,"C5_XORIGPV","SC5","ORIGEM")
	TRCell():New(oSection2,"C5_EMISSAO","SC5","EMISSAO")
	TRCell():New(oSection2,"C5_TIPMOV","SC5","PORMA_PGTO")
	TRCell():New(oSection2,"C5_TOTPED","SC5","TOTAL_PEDIDO")
	TRCell():New(oSection2,"C5_XRECPG","SC5","RECIBO_PGTO")
	TRCell():New(oSection2,"C5_MENNOTA","SC5","MENS_NOTA")
	TRCell():New(oSection2,"C5_KPROTOC","SC5","PROTOCOLO")

	TRFunction():New(oSection2:Cell("C5_TOTPED"),NIL,"SUM")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReport บAutor  ณLeandro Nishihata   บ Data ณ  31/01/17 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao do relatorio				      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintReport(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local analista := " "
	Local atende := " "
	Local tipo := " "

	if !empty(Canalista)
		analista := editin(Canalista)
	endif
	if !empty(Cgrpatend)
		atende := editin(Cgrpatend)
	endif
	if !empty(Ctipo)
		tipo:=	editin(Ctipo)
	endif
	//inicio := time()
	if DDataate < ddatabase-90

		if !msgnoyes("Essa opera็ใo ultarpassa o periodo mแximo de 3 meses, sendo assim, o relat๓rio terแ um grande custo de processamento, resultando em grande tempo de espera, deseja continuar com a impressใo ?")
			return
		else
			oSection1:BeginQuery()
			BeginSql alias "QRYADE"
			SELECT
			C5_CHVBPAG ,
			C5_XNPSITE ,
			C5_XORIGPV ,
			C5_EMISSAO ,
			C5_MENNOTA ,
			C5_TIPMOV ,
			C5_TOTPED ,
			C5_XRECPG ,
			C5_KPROTOC ,
			ADE_OPERAD ,
			ADE_GRUPO,
			U7_NOME,
			U7_NREDUZ
			FROM %Table:SC5% SC5,
			%Table:ADE% ADE,
			%Table:SU7% SU7
			WHERE
			ADE_FILIAL = %xFilial:ADE%
			AND C5_FILIAL = %xFilial:SC5%
			AND U7_FILIAL = %xFilial:SU7%
			AND ADE_CODIGO = C5_KPROTOC
			AND ADE_PEDGAR = C5_CHVBPAG
			AND ADE_XPSITE = C5_XNPSITE
			AND	ADE.%NotDel%
			AND	SC5.%NotDel%
			AND	SU7.%NotDel%
			AND C5_EMISSAO BETWEEN %Exp:DtoS(DDatade)% AND %Exp:DtoS(DDataate)%
			AND C5_EMISSAO = ADE_DATA
			AND TRIM(ADE_OPERAD) = TRIM(U7_COD)
			AND ADE_OPERAD  in (%Exp:analista%)
			AND ADE_GRUPO IN (%Exp:atende%)
			AND C5_TIPMOV IN  (%Exp:tipo%)
			ORDER BY U7_NOME

			EndSql
		endif
	else

		oSection1:BeginQuery()
		BeginSql alias "QRYADE"
		SELECT
		C5_CHVBPAG ,
		C5_XNPSITE ,
		C5_XORIGPV ,
		C5_EMISSAO ,
		C5_MENNOTA ,
		C5_TIPMOV,
		C5_TOTPED ,
		C5_XRECPG ,
		C5_KPROTOC ,
		ADE_OPERAD ,
		ADE_GRUPO,
		U7_NOME,
		U7_NREDUZ
		FROM cssac001 SC5
		WHERE
		C5_EMISSAO BETWEEN %Exp:DtoS(DDatade)% AND %Exp:DtoS(DDataate)%
		AND ADE_OPERAD  in (%Exp:analista%)
		AND ADE_GRUPO IN (%Exp:atende%)
		AND C5_TIPMOV IN  (%Exp:tipo%)
		EndSql

	endif
	oSection1:EndQuery()
	oSection2:SetParentQuery()
	oSection1:Print()

Return

Static function editin(cconteudo)
	Local ret := ""
	Local aret := {}
	Local i:=0
	aret:= StrToKArr( alltrim(cconteudo), "," )

	for i:=1 to len(aret)
		if !empty(aret[i])

			ret := alltrim(alltrim(ret)  + if(empty(ret),"",",") + "'"+alltrim(aret[i])+"'")

		endif

	next
	ret := substr(ret,2,len(ret)-2)
Return ret