#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

// Programa: ms_gereti
// Autor...: Alexandre Dalpiaz
// Data....: 14/03/05
// Função..: Definição de etiquetas/relatório gráfico a partir de um cadastro/configuração de objetos
// Uso.....: Laselva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_GERETI()
/////////////////////////

Private cCadastro := "Configurador de Etiquetas"
Private aRotina   := {}
Private cPerg
Private _xRet     := ""
Private _xPar1    := ""
Private _xPar2    := ""
Private _xPar3    := ""
Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString   := "Z16"
Private _aTpFonte := {}
Private _aNmFonte := {}
Private _aTpBarra := {}
Private _lPro     := .f.

aAdd(_aTpFonte,'Times New Roman')
aAdd(_aTpFonte,'Arial')
aAdd(_aTpFonte,'Courier New')

aAdd(_aNmFonte,'TimesNewRoman')
aAdd(_aNmFonte,'Arial')
aAdd(_aNmFonte,'CourierNew')

aAdd(_aTpBarra,'EAN13')
aAdd(_aTpBarra,'EAN8')
aAdd(_aTpBarra,'UPCA')
aAdd(_aTpBarra,'SUP5')
aAdd(_aTpBarra,'CODE128')
aAdd(_aTpBarra,'INT25')
aAdd(_aTpBarra,'MAT25')
aAdd(_aTpBarra,'IND25')
aAdd(_aTpBarra,'CODBAR')
aAdd(_aTpBarra,'CODE3_9')

aAdd(aRotina, { "Pesquisar"  , "AxPesqui" , 0 , 1 } )
aAdd(aRotina, { "Visualizar" , "u_lsgereti(2)" , 0 , 2 } )
aAdd(aRotina, { "Incluir"    , "u_lsgereti(3)" , 0 , 3 } )
aAdd(aRotina, { "Alterar"    , "u_lsgereti(4)" , 0 , 4 } )
aAdd(aRotina, { "Copiar"     , "u_lsgereti(6)" , 0 , 3 } )
aAdd(aRotina, { "Excluir"    , "u_lsgereti(5)" , 0 , 5 } )
aAdd(aRotina, { "Pré-visualização" , "u_lspreview(1)" , 0 , 5 } )
aAdd(aRotina, { "Imprimir"   , "u_lspreview(2)" , 0 , 5 } )

dbSelectArea("Z16")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSGerEti(_xPar)
/////////////////////////////

_xFuncao := _xPar
RegToMemory ("Z16", (_xFuncao == 3))
// Montagem do aHeader e aCols para a MSGetDados

aHeader := {}
_cBranco := ''
DbSelectArea('SX3')
DbSetOrder(2)
DbSeek('Z17_ITEM'   ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_OBJETO' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_LININI' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_COLINI' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_LINFIM' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_COLFIM' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_TEXTO'  ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_FONTE'  ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_TAMANH' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_NEGRIT' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_SUBLIN' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_ALINHA' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_TPBARR' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_SENTID' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_BANNER' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSeek('Z17_CONTEU' ) ; aAdd(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,X3_TAMANHO, X3_DECIMAL, '',X3_USADO, X3_TIPO, X3_ARQUIVO } )

_Z17ITEM    := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_ITEM"})
_Z17OBJETO  := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_OBJETO"})
_Z17LININI  := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_LININI"})
_Z17COLINI  := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_COLINI"})
_Z17LINFIM  := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_LINFIM"})
_Z17COLFIM  := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_COLFIM"})
_Z17TEXTO   := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_TEXTO"})
_Z17FONTE   := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_FONTE"})
_Z17TAMANHO := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_TAMANH"})
_Z17NEGRITO := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_NEGRIT"})
_Z17SUBLINH := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_SUBLIN"})
_Z17ALINHA  := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_ALINHA"})
_Z17TPBARRA := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_TPBARR"})
_Z17SENTIDO := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_SENTID"})
_Z17BANNER  := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_BANNER"})
_Z17CONTEUD := aScan(aHeader, {|x| AllTrim(x[2])=="Z17_CONTEU"})

// Montando aCols
aCols    := {}
_aRecnos := {}
DbSelectArea('Z17')
Z17->(DbSetOrder(1))
Z17->(DbSeek(xFilial("Z17") + Z16->Z16_ETIQUET , .f.))
Do While !Z17->(eof()) .and. xFilial("Z17") + Z16->Z16_ETIQUET == Z17->Z17_FILIAL + Z17->Z17_ETIQUE .and. _xFuncao <> 3
	
	aAdd(aCols, Array(len(aHeader) + 1))
	
	For _nCampo := 1 to len(aCols[1]) - 1
		aCols[len(aCols), _nCampo] := Z17->(FieldGet(FieldPos(aHeader[_nCampo, 2])))
	Next
	aCols[len(aCols), len(aCols[1])] := .F.  // Marca linha como nao deletada
	
	// Guardo o recno para poder encontrar o registro mais tarde no Z17, pois
	// vai ser permitido ao usuario alterar campos chave
	aAdd(_aRecnos, Z17->(Recno()))
	Z17->(DbSkip())
	
EndDo

// Nao posso aceitar uma etiqueta sem itens
If len(aCols) == 0
	aAdd(aCols, Array(len(aHeader) + 1))
	
	For _nCampo := 1 to len(aCols[1]) - 1
		aCols[len(aCols), _nCampo] := CriaVar(aHeader[_nCampo,2])
	Next
	aCols[len(aCols), len(aCols[1])] := .F.  // Marca linha como nao deletada
EndIf
If _xFuncao == 6
	M->Z16_ETIQUET := '    '
EndIf
CursorArrow ()

cAliasEnchoice := "Z16"
cAliasGetD     := "Z17"
cLinOk         := "AllwaysTrue()"
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Modelo3	  ³ Autor ³ Wilson		        ³ Data ³ 17/03/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Enchoice e GetDados										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lRet:=Modelo3(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk, 	  ³±±
±±³			 ³ cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze,aAlter)³±±
±±³			 ³lRet=Retorno .T. Confirma / .F. Abandona					  ³±±
±±³			 ³cTitulo=Titulo da Janela 									  ³±±
±±³			 ³cAlias1=Alias da Enchoice									  ³±±
±±³			 ³cAlias2=Alias da GetDados									  ³±±
±±³			 ³aMyEncho=Array com campos da Enchoice						  ³±±
±±³			 ³cLinOk=LinOk 												  ³±±
±±³			 ³cTudOk=TudOk 												  ³±±
±±³			 ³nOpcE=nOpc da Enchoice									  ³±±
±±³			 ³nOpcG=nOpc da GetDados									  ³±±
±±³			 ³cFieldOk=validacao para todos os campos da GetDados 		  ³±±
±±³			 ³lVirtual=Permite visualizar campos virtuais na enchoice	  ³±±
±±³			 ³nLinhas=Numero Maximo de linhas na getdados			 	  ³±±
±±³			 ³aAltEnchoice=Array com campos da Enchoice Alteraveis		  ³±±
±±³			 ³nFreeze=Congelamento das colunas.                           ³±±
±±³			 ³aAlter =Campos do GetDados a serem alterados.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³FINA540													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data   ³ BOPS ³  Motivo da Alteracao                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³EDUARDO MOTTA³11/05/00³XXXXXX³Colocar campos alteraveis no GetDados    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
_lRet     := .f.
_nOpca    := 0

Altera    := .t.
Inclui    := .t.
lRefresh  := .t.
aTELA     := Array(0,0)
aGets     := Array(0)
bCampo    := {|nCPO|Field(nCPO)}
nPosAnt   := 9999
nColAnt   := 9999
nPosAtu   := 0

nOpcE     := iif(_xFuncao == 6,4, _xFuncao)
nOpcG     := iif(_xFuncao == 6,4, _xFuncao)
lVirtual  := .f.
nLinhas   := iif(_xFuncao == 6,len(aCols),999)
_nAltura  := oMainWnd:nClientHeight-100
_nLargura := oMainWnd:nClientWidth-10

cAlias1 := 'Z16'
cAlias2 := 'Z17'
nReg    := Z16->(Recno())

Define MsDialog oDlg From 0,0 to _nAltura, _nLargura of oMainWnd pixel Title 'Configurador de Etiquetas'
EnChoice(cAlias1,nReg,nOpcE,,,,,{15,0,_nAltura/6-5,_nLargura/2},,3,,,,,,lVirtual)
oGetDados := MsGetDados():New(_nAltura/6,0,_nAltura/2,_nLargura/2,nOpcG,cLinOk,cTudOk,"",.T.,,2,,nLinhas)
Activate MsDialog oDlg On Init EnchoiceBar(oDlg,{||_nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),_nOpca := 0,oDlg:End()),_nOpca := 0)},{||_nOpca :=0,oDlg:End()}) centered

_lRet := (_nOpca==1)

If !_lRet
	Return()
EndIf

_nLinha    := 0
_nCampo    := 0
_nPos      := 0
_bCampo    := {|_nCPO| Field (_nCPO)}

If _xFuncao == 2	//	visualizacao
	Return()
EndIf

CursorWait ()

// Gravacao dos campos da enchoice no Z16

RecLock("Z16", (_xFuncao == 3 .or. _xFuncao == 6))
If _xFuncao == 5
	DbDelete()
Else
	
	For _nCampo := 1 to Z16->(FCount())
		FieldPut(_nCampo, M->&(EVAL(_bCampo,_nCampo)))
	Next
	Z16->Z16_FILIAL  := xFilial('Z16')
	Z16->Z16_ETIQUET := M->Z16_ETIQUET
	Z16->Z16_DESCRI  := M->Z16_DESCRI
	Z16->Z16_LINHAS  := M->Z16_LINHAS
	Z16->Z16_COLUNAS := M->Z16_COLUNAS
	Z16->Z16_ALTURA  := M->Z16_ALTURA
	Z16->Z16_LARGURA := M->Z16_LARGURA
	Z16->Z16_LAYOUT  := M->Z16_LAYOUT
	
EndIf
Z16->(MsUnLock())

// Gravacao dos campos do aCols
For _nLinha := 1 to len(aCols)
	
	// Reposiciona no mesmo registro. Assim, posso alterar campos chave.
	If _nLinha <= len(_aRecnos)
		Z17->(dbgoto (_aRecnos [_nLinha]))
	EndIf
	
	If (_xFuncao==3 .or. _xFuncao == 6 .or. (_xFuncao == 4 .and. _nLinha > len(_aRecnos))) .and. !GdDeleted(_nLinha)
		RecLock("Z17", .t.)
	Else
		RecLock('Z17',.f.)
	EndIf
	
	If _xFuncao == 5 .or. (_xFuncao == 4 .and. GdDeleted(_nLinha) .and. _nLinha <= len(_aRecnos))
		DbDelete()
	ElseIf !GdDeleted(_nLinha)
		Z17->Z17_FILIAL  := xFilial('Z17')
		Z17->Z17_ETIQUET := M->Z16_ETIQUET
		For _nCampo := 1 to len(aHeader)
			_nPos  := Z17->(FieldPos (aHeader[_nCampo, 2]))
			Z17->(FieldPut (_nPos, aCols[_nLinha, _nCampo]))
		Next
	EndIf
	Z17->(MsUnLock())
Next

DbSelectArea('Z16')
CursorArrow ()
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSPreview(_xPar)
//////////////////////////////

Private _aTpFonte := {}
Private _aNmFonte := {}
Private _aTpBarra := {}
Private _lPro     := .f.

aAdd(_aTpFonte,'Times New Roman')
aAdd(_aTpFonte,'Arial')
aAdd(_aTpFonte,'Courier New')

aAdd(_aNmFonte,'TimesNewRoman')
aAdd(_aNmFonte,'Arial')
aAdd(_aNmFonte,'CourierNew')

aAdd(_aTpBarra,'EAN13')
aAdd(_aTpBarra,'EAN8')
aAdd(_aTpBarra,'UPCA')
aAdd(_aTpBarra,'SUP5')
aAdd(_aTpBarra,'CODE128')
aAdd(_aTpBarra,'INT25')
aAdd(_aTpBarra,'MAT25')
aAdd(_aTpBarra,'IND25')
aAdd(_aTpBarra,'CODBAR')
aAdd(_aTpBarra,'CODE3_9')

cPerg := left(Z16->Z16_FUNCAO,10)
_nTCopias := 1	// controla quantidade de cópias da "etiqueta"

If !empty(Z16->Z16_FUNCAO) .and. _xPar == 2 
	_cAlias := ''
	Processa({|| ExecBlock(Z16->Z16_FUNCAO,.f.,.f.,_xPar)})
EndIf

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSImpEtq(_xPar)
/////////////////////////

DbSelectArea('Z17')
DbSeek(xFilial('Z17') + Z16->Z16_ETIQUET,.F.)

_oPrn  := TMSPrinter():new()		//_oPrn := FWMSPrinter():New("DANFE", 1)
_oPrn:Setup()
_aFontes := {}
_oFontes := {}

Do While !eof() .and. Z16->Z16_ETIQUET == Z17->Z17_ETIQUET
	
	If Z17->Z17_OBJETO $ '15'
		
		_cFonte := _aNmFonte[val(Z17->Z17_FONTE)] + strzero(Z17->Z17_TAMANH,3)
		_cFonte += iif(Z17->Z17_NEGRIT == 'S','N','')
		_cFonte += iif(Z17->Z17_SUBLIN == 'S','S','')
		_cFonte += iif(Z17->Z17_SUBLIN+Z17->Z17_NEGRIT == 'NN','X','')
		If aScan(_aFontes,_cFonte) == 0
			aAdd(_aFontes,_cFonte)
			&_cFonte := tFont():new( _aTpFonte[val(Z17->Z17_FONTE)] ,9,Z17->Z17_TAMANH,,Z17->Z17_NEGRIT == 'S',,,,,Z17->Z17_SUBLINADO == 'S' )
			aAdd(_oFontes,&_cFonte)
		EndIf
		
	EndIf
	
	DbSkip()
	
EndDo

If Z16->Z16_LAYOUT == 'R'
	_oPrn:SetPortrait()
Else
	_oPrn:SetLandscape()
EndIf

DbSelectArea(_cAlias)

Do While !eof() .or. _xPar == 1
	
	_nCopias := 0
	_nCol    := 0
	_nLin    := 0
	             
	_nColB   := 0   	// para o codigo de barras - em centimetros
	_nLinB   := 0

	_oPrn:StartPage()
	//nHPage := _oPrn:nHorzRes()
	//nVPage := _oPrn:nVertRes()

	For _nI := 1 to Z16->Z16_LINHAS
		
		For _nJ := 1 to Z16->Z16_COLUNAS
			
			DbSelectArea('Z17')
			DbSeek(xFilial('Z17') + Z16->Z16_ETIQUET,.F.)
			
			Do While !eof() .and. Z16->Z16_ETIQUET == Z17->Z17_ETIQUET
				
				If Z17->Z17_OBJETO == '1'			// texto
					
					Do While .t.
						_cFonte := _aNmFonte[val(Z17->Z17_FONTE)] + strzero(Z17->Z17_TAMANH,3)
						_cFonte += iif(Z17->Z17_NEGRIT == 'S','N','')
						_cFonte += iif(Z17->Z17_SUBLIN == 'S','S','')
						_cFonte += iif(Z17->Z17_SUBLIN+Z17->Z17_NEGRIT == 'NN','X','')
						_nPosic := aScan(_aFontes,_cFonte)
						
						_cTexto := alltrim(Z17->Z17_TEXTO)
						If _xPar == 2 .and. Z17->Z17_CONTEU == 'V'    
							_cTexto := iif(valtype(&_cTexto) == 'C',&_cTexto,_cTexto)
						EndIf                                         
						
						If Z17->Z17_ALINHA == 'D'
							_cTexto := PadE(alltrim(_cTexto),len(alltrim(_cTexto)),' ')
						ElseIf Z17->Z17_ALINHA == 'C'   
							_cTexto := PadC(alltrim(_cTexto),len(alltrim(_cTexto)),' ')
						EndIf
						If Z17->Z17_SENTID == 'V'
							_oPrn:Say(_nLin + Z17->Z17_LININI*118 , _nCol + Z17->Z17_COLINI*118 , _cTexto         , _oFontes[_nPosic] , , ,270 )
							//oDanfe:Say(nLine+448                ,Txt+14                       ,"TRANSPORTADOS"  ,oFont08N:oFont     , , CLR_WHITE, 270 )
						Else
							_oPrn:Say(_nLin + Z17->Z17_LININI*118 , _nCol + Z17->Z17_COLINI*118 , _cTexto , _oFontes[_nPosic] , 100)
						EndIf
						If Z17->Z17_LINFIM > 0
							(_cAlias)->(DbSkip())
							loop
						Else
							Exit
						EndIf
					EndDo
				ElseIf Z17->Z17_OBJETO == '2'		// figura
					
					_cTexto := alltrim(Z17->Z17_TEXTO)
					If _xPar == 2 .and. Z17->Z17_CONTEU == 'V'
						//If substr(_cTexto,2,2) <> ':\'
						//_cTexto := alltrim(GetMv('MS_DESENHO')) + _cTexto
						_cTexto := &_cTexto
						//EndIf
					EndIf
					_oPrn:SayBitMap(_nLin + Z17->Z17_LININI*118 , _nCol + Z17->Z17_COLINI*118 , _cTexto , Z17->Z17_COLFIM*118 , Z17->Z17_LINFIM*118)
					
				ElseIf Z17->Z17_OBJETO == '3'		// linhas
					_oPrn:Line(_nLin + Z17->Z17_LININI*118 , _nCol + Z17->Z17_COLINI*118 , _nLin + Z17->Z17_LINFIM*118 , _nCol + Z17->Z17_COLFIM*118)
				ElseIf Z17->Z17_OBJETO == '4'		// box
					_oPrn:Box(_nLin + Z17->Z17_LININI*118 , _nCol + Z17->Z17_COLINI*118 , _nLin + Z17->Z17_LINFIM*118 , _nCol + Z17->Z17_COLFIM*118)
				ElseIf Z17->Z17_OBJETO == '5'		// barra
					_cFonte := _aNmFonte[val(Z17->Z17_FONTE)] + strzero(Z17->Z17_TAMANH,3)
					_cFonte += iif(Z17->Z17_NEGRIT == 'S','N','')
					_cFonte += iif(Z17->Z17_SUBLIN == 'S','S','')
					_cFonte += iif(Z17->Z17_SUBLIN+Z17->Z17_NEGRIT == 'NN','X','')
					_nPosic := aScan(_aFontes,_cFonte)
					
					_cTexto := alltrim(Z17->Z17_TEXTO)
					If _xPar == 2 .and. Z17->Z17_CONTEU == 'V'
						_cTexto := alltrim(iif(valtype(&_cTexto) <> 'U',&_cTexto,_cTexto))
					EndIf      
                    /*
					_xLinB   := _nLinB + Z17->Z17_LININI/2         //1.95
					_xColb   := _nColB + Z17->Z17_COLINI/2
					_xEspaco := iif(Z17->Z17_LINFIM==0,0.011,Z17->Z17_LINFIM/7.5)
					_xAltura := Z17->Z17_COLFIM/2
					*/
					_xLinB := _nLinB + Z17->Z17_LININI 
					_xColb := _nColB + Z17->Z17_COLINI
					_xEspaco := iif(Z17->Z17_LINFIM==0,0.021,Z17->Z17_LINFIM/10)
					_xAltura := Z17->Z17_COLFIM
					MSBar(_aTpBarra[val(Z17->Z17_TPBARR)], _xLinb, _xColb, _cTexto             , _oPrn, .f.,, (Z17->Z17_SENTID=='H'), _xEspaco, _xAltura, (Z17->Z17_BANNER=='S'),_aFontes[_nPosic],,.F.)
				EndIf
				
				DbSelectArea('Z17')
				DbSkip()
				
			EndDo
			
			DbSelectArea('Z17')
			
			_nCol  += Z16->Z16_LARGURA*118
			//_nColB += Z16->Z16_LARGURA
			_nColB += Z16->Z16_LARGURA/2
			
		Next
		
		_nCol  := 0
		_nColB := 0
		_nLin  += Z16->Z16_ALTURA*118
		//_nLinB += Z16->Z16_ALTURA
		_nLinB += Z16->Z16_ALTURA/2   //1.95
	
		If _xPar == 2
			DbSelectArea(_cAlias)	
			If ++_nCopias >= _nTCopias
				DbSkip()
			EndIf        
		EndIf
	
	Next
	
	_oPrn:EndPage()
	
	If _xPar == 1
		exit
	EndIf

EndDo
_oPrn:Preview()
_oPrn:End()

Return()

