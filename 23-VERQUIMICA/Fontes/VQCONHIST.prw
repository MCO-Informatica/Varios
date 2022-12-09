#Include "TopConn.ch"
#Include "Protheus.ch"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VQCONVEN  �Autor  � Felipe - Armi      � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function VQCONHIST()

Local aSize, aObjects, aInfo

Local bOk      := {|| oDlg:End()}
Local bCancel  := {|| oDlg:End()}
Local cTitle   := "Consulta Historico Preco"
Local oGetdb
Local nBoxSize := 0
Local aButtons := {{"IMPRESSAO",{|| Imprime() },               "Imprimir"} }

Private cEof := Chr(13) + Chr(10)

Private oDlg
Private aPosObj

Private oGetDados
Private aHeader := {}
Private aCols   := {}

Private oGCodPrd
Private cGCodPrd := CriaVar("B1_COD", .F.)
Private oGNomPrd
Private cGNomPrd

Private oGCodGrp
Private cGCodGrp := CriaVar("BM_GRUPO", .F.)
Private oGNomGrp
Private cGNomGrp

Private oBFiltro
Private lEdit     := .F.

Private nColAnt := 0
Private cOrdAnt := "C"

/*
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpA1 := MsAdvSize( [ ExpL1 ], [ ExpL2 ], [ ExpN1 ] )      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1 -> Enchoicebar .T. ou .F.                            ���
���          � ExpL2 -> Retorna janela padrao siga                        ���
���          � ExpN1 -> Tamanho minimo ( altura )                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpA1 -> Dimensoes da janela / area de trabalho            ���
���          �     1 -> Linha inicial area trabalho                       ���
���          �     2 -> Coluna inicial area trabalho                      ���
���          �     3 -> Linha final area trabalho                         ���
���          �     4 -> Coluna final area trabalho                        ���
���          �     5 -> Coluna final dialog                               ���
���          �     6 -> Linha final dialog                                ���
���          �     7 -> Linha inicial dialog                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � GENERICO                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

aSize    := MsAdvSize()

If aSize[3] < 495  // for�o tamanho da tela para 1024 x 768
	aSize[3] := 495
	aSize[4] := 283
	aSize[5] := 990
	aSize[6] := 597
	aSize[7] := 17
EndIf

aObjects := {{ 100, 040, .T., .F. },;
{ 100, 100, .T., .T. },;
{ 100, 022, .T., .F. }}

aInfo    := { aSize[1],;
aSize[2],;
aSize[3],;
aSize[4],;
3,;
3 }


/*
��������������������������������������������������������������������������ٱ�
���Sintaxe   � ExpA1 := MsObjSize( ExpA2, ExpA3, [ ExpL1 ], [ ExpL2 ] )   ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA2 -> Area de trabalho                                  ���
���          � ExpA3 -> Definicoes de objetos                             ���
���          �    1 - Tamanho X    / 2 - Tamanho Y  / 3 - Dimensiona X    ���
���          �    4 - Dimensiona Y / 5 - Retorna dimensoes X e Y ao inves ���
���          �       de linha / coluna final                              ���
���          � ExpL1 -> Mantem a proporcao dos objetos                    ���
���          � ExpL2 -> Indica calculo de objetos horizontais             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � ExpA1 -> Array com as posicoes de cada objeto              ���
���          �     1 -> Linha inicial                                     ���
���          �     2 -> Coluna inicial                                    ���
���          �     3 -> Linha final                                       ���
���          �     4 -> Coluna final Ou:                                  ���
���          �     Caso seja passado o elemento 5 de cada definicao de    ���
���          �     objetos como .t. o retorno sera:                       ���
���          �     3 -> Tamanho da dimensao X                             ���
���          �     4 -> Tamanho da dimensao Y                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � GENERICO                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

aPosObj  := MsObjSize(aInfo, aObjects)

Define MsDialog oDlg Title cTitle From aSize[7], 0 To aSize[6], aSize[5] Of oMainWnd Pixel

@ aPosObj[1][1], aPosObj[1][2] To aPosObj[1][3]+28, aPosObj[1][4] Prompt "Filtro" Of oDlg Pixel

//@ aPosObj[1][1]+10, aPosObj[1][2]+004 Say "Pesquisa" Of oDlg Pixel
//@ aPosObj[1][1]+08, aPosObj[1][2]+032 ComboBox oPesqu Var cPesqu Items aPesqu Valid fValCon(.T.) Size 40, 50 When lEditPesq Of oDlg Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+077 Say "Produto" Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+105 MSGet oGCodPrd Var cGCodPrd Valid Iif(Vazio() .or. ExistCpo("SB1", cGCodPrd, 1), (cGNomPrd := GetAdvFVal("SB1","B1_DESC",XFILIAL("SB1")+cGCodPrd,1,""),.T.),.F.) Size 30, 09 F3 "SB1" When lEdit Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+140 MSGet oGNomPrd Var cGNomPrd Size 100, 09 When .F. Of oDlg Pixel

@ aPosObj[1][1]+10, aPosObj[1][2]+250 Say "Grupo" Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+278 MSGet oGCodGrp Var cGCodGrp Valid Iif(Vazio() .or. ExistCpo("SBM", cGCodGrp, 1), (cGNomGrp := GetAdvFVal("SBM","BM_DESC",XFILIAL("SBM")+cGCodGrp,1,""),.T.),.F.) Size 30, 09 F3 "SBM" When lEdit Of oDlg Pixel
@ aPosObj[1][1]+08, aPosObj[1][2]+313 MSGet oGNomGrp Var cGNomGrp Size 70, 09 When .F. Of oDlg Pixel

@ aPosObj[1][1]+53, aPosObj[1][2]+458 Button oBFiltro Prompt "Filtrar" Size 42, 11 Action BtnFiltro() Of oDlg Pixel

oGetDados := MsNewGetDados():New(aPosObj[2][1]+6+20, aPosObj[2][2]+3, aPosObj[2][3]-3, aPosObj[2][4]-3, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDlg, aHeader, aCols)

oGetDados:lInsert := .F.
oGetDados:lDelete := .F.
oGetDados:lUpdate := .F.

nBoxSize := (aPosObj[3][4]-aPosObj[3][2])/11

//Activate MsDialog oDlg On Init (EnchoiceBar(oDlg, bOk, bCancel,, aButtons), ButWhen(@oDlg)) Centered
Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,{||lOk:=.T.,oDlg:End()},{||oDlg:End()},,@aButtons))


Return(Nil)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BtnFiltro �Autor  �Microsiga           � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcal Botao Filtrar                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function BtnFiltro

Local _nI

Do Case
	
	Case lEditPesq
		
		lEdit     := .F.
		lEditPesq := .F.
		lEditComp := .F.
		lEditVend := .F.

		oBFiltro:cTitle := "Limpar"
		
		MsAguarde({|| FilAnual() }, "Aguarde", "Gerando Consulta ...", .F.)
		
		oGetDados := MsNewGetDados():New(aPosObj[2][1]+6+20, aPosObj[2][2]+3, aPosObj[2][3]-3, aPosObj[2][4]-3, GD_INSERT+GD_DELETE+GD_UPDATE,,,,  ,, 99,,,, oDlg, aHeader, aCols)
		oGetDados:lInsert := .F.
		oGetDados:lDelete := .F.
		oGetDados:lUpdate := .F.
		oGetDados:lActive := .F.
		oGetDados:oBrowse:bHeaderClick := {|obj,col| fOrdTemp(obj,col)}

	Otherwise
		
		oBFiltro:cTitle := "Filtrar"
		lEditPesq := .T.
//		fValCon()

		oGetDados:aCols := {}
				
EndCase

Return(Nil)

/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+------------------------------+------------------+||
||| Programa: fOrdTemp  | Autor: Celso Ferrone Martins | Data: 17/04/2014 |||
||+-----------+---------+------------------------------+------------------+||
||| Descricao | Organiza MsSelect. Altera o indice de selecao             |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function fOrdTemp(obj, col)

Local aTmpCols  := {}
Local aTmpTotal := {}

If nColAnt != col
	nColAnt := col
	cOrdAnt := "C"
Else
	If cOrdAnt == "C"
		cOrdAnt := "D"
	Else
		cOrdAnt := "C"
	EndIf
EndIf

nPosTos := Len(oGetDados:ACOLS)

For nX := 1 To nPosTos -1
	aadd(aTmpCols,aClone(oGetDados:ACOLS[nX]))
Next nX

aAdd(aTmpTotal,aClone(oGetDados:ACOLS[nPosTos]))

oGetDados:ACOLS := aClone(aTmpCols)

If cOrdAnt == "C"
	oGetDados:ACOLS := aSort(oGetDados:ACOLS,,,{|x,y| x[col] < y[col]})
Else
	oGetDados:ACOLS := aSort(oGetDados:ACOLS,,,{|x,y| x[col] > y[col]})
EndIf

aAdd(oGetDados:ACOLS,aClone(aTmpTotal[1]))

oGetDados:oBrowse:Refresh(.T.)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VQCONVEN  �Autor  �Microsiga           � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza Filtro na base de dados conf. parametros           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FilAnual()

Local cSQL := cSQLP := cSQLD := ""
Local nOpcRank
Local _nI := _nAux := 0
Local _aMeses    := {}
Local _dGDatDe
Local _dGetdtAte
Local nLenAnt
Local aEstru
Local cCod
Local nOpcPerc

Local _cCod    := ""
Local _cDesc   := ""
Local _cPicCod := ""
Local _cPicDes := ""
Local _nTGrp   := 0
Local _cQryCod := ""
Local _cQryDes := ""

Private	_cQryCod := "  "
Private	_cQryDes := "  "

nOpTipo := aScan( aCTipo, cCTipo)

aHeader := {}


Aadd(aHeader,{"Produto"	   ,"Z15_COD"    		,PesqPict("Z15","Z15_COD"),TamSX3("Z15_COD")[1],0,"",USADO,"C",,""})
Aadd(aHeader,{"Descricao"  ,"B1_DESC"   		,PesqPict("SB1","B1_DESC"),TamSX3("B1_DESC")[1],0,"",USADO,"C",,""})

Aadd(aHeader,{"Revisao"       	,"Z15_REVISA" 	,PesqPict("Z15","Z15_REVISA"),TamSX3("Z15_REVISA")[1],0,"",USADO,"N",,""})
Aadd(aHeader,{"UM"        		,"Z15_UM"  		,PesqPict("Z15","Z15_UM")	,TamSX3("Z15_UM")[1],0,"",USADO,"N",,""})
Aadd(aHeader,{"Moeda"      		,"Z15_MOEDA" 	,PesqPict("Z15","Z15_MOEDA"),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Tx Moeda"   		,"Z15_TXMOED" 	,PesqPict("Z15","Z15_TXMOEDA"),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Data Alt"     	,"Z15_DATAAL" 	,PesqPict("Z15","Z15_DATAAL"),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Densidade"		,"Z15_DENSID" 	,PesqPict("Z15","Z15_DENSID"),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Ref. Com"		,"Z15_REFCOM" 	,PesqPict("Z15","Z15_REFCOM"),14,4,"",USADO,"N",,""})
Aadd(aHeader,{"Frete C" 		,"Z15_FRETEC" 	,PesqPict("Z15","Z15_FRETEC"),14,4,"",USADO,"N",,""})

_cQry := " "

_cQry += " SELECT                                                                         " + cEof
_cQry += " * 							                                                  " + cEof
_cQry += "    FROM "+RetSQlName("Z15")+" Z15                                              " + cEof
_cQry += "     WHERE                                                                      " + cEof
_cQry += "       Z15.D_E_L_E_T_ <> '*'                                                    " + cEof
_cQry += "       AND Z15.Z15_FILIAL = '"+xFilial("Z15")+"'                                " + cEof
_cQry += "      AND Z15.Z15_COD = '"+cGCodPrd+"'                                          " + cEof

_cQry += " ORDER BY Z15_DATAAL, Z15_REVISA  						                      " + cEof

If "Administrador"$cUserName .And. !EECVIEW(@_cQry)
	RETURN
EndIf

_cQry := ChangeQuery(_cQry)

TCQUERY _cQry NEW ALIAS "TABTMP"


// aCols
aCols := {}
Dbselectarea("TABTMP")
//TABTMP->(dbGoTop())

While TABTMP->(!Eof())
	
	aAdd( aCols, { TABTMP->&(StrTran(_cQryCod,",","+' - '+")) , ;
	TABTMP->&_cQryDes,;
	TABTMP->QTDTOT_KG,;
	TABTMP->QTDTOT_LT,;
	TABTMP->TOTTOT_RE,;
	TABTMP->TOTTOT_DO,;
	ROUND(TABTMP->TOTTOT_RE/TABTMP->QTDTOT_KG,2),;
	ROUND(TABTMP->TOTTOT_DO/TABTMP->QTDTOT_KG,2),;
	TABTMP->QTDREG2,;
	.F. } )
	
	TABTMP->(DbSkip())
EndDo


TABTMP->(dbCloseArea())


Return(Nil)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VQCONVEN  �Autor  �Microsiga           � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Imprime()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL cDesc1   := "Relatorio"

PRIVATE nomeprog := "VQCONVEN"
PRIVATE titulo   := "Relatorio de Vendas - De " + DtoC(dGDatDe) + " a " + DtoC(dGDatAte)
Private aFiltros := {}

U_ConVenTRep( Titulo , cDesc1 , nomeprog , aFiltros )

Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VQCONVEN  �Autor  �Microsiga           � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Desabilita / Habilita botao da barra                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function ButWhen(_oObj)

Local _nPosImp

If ( _nPosImp := AScan(_oObj:aControls, { |x| x:cTitle == "Imprimir" } ) ) > 0
	_oObj:aControls[_nPosImp]:lActive := !lEdit
	_oObj:aControls[_nPosImp]:bWhen   := { || !lEdit }
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ConVenTRep�Autor  �Microsiga           � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Imprime relatorio TReport com base na Acols               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ConVenTRep( cTitulo , cDescri , cReport , aFilt , aHeaderx , aColsx )

Local   oReport
Local   oSection1
Default cDescri   := ""
Default cReport   := "Relatorio de Vendas"
Default cTitulo   := "Relatorio de Vendas"
Default aFilt     := {}
Private aFilter   := aFilt


If ValType( aHeaderx ) = "A"
	Private aHeader := aHeaderx
EndIf
If ValType( aColsx ) = "A"
	Private aCols := aColsx
EndIf

//�������������������������������������������Ŀ
//�Se nao passou os parametros para fun��o e  �
//�nao existe 'aHeader' ou 'aCols' declarados.�
//���������������������������������������������
If Type( "aHeader" ) = "U"
	Private aHeader := {}
EndIf
If Type( "aCols" ) = "U"
	Private aCols := {}
EndIf

Begin Sequence

//���������������������
//� Cria objeto TReport�
//���������������������
oReport  := TReport():New( cReport, cTitulo ,, { |oReport| ReportPrint( oReport ) } , cDescri )

oReport:SetLandscape()

//������������������������
//�Cria se��o do Relat�rio�
//������������������������
oSection1 := TRSection():New( oReport, "Parametros do Relatorio"  )
oSection2 := TRSection():New( oReport, "Campos do Relatorio"  )

SX3->( DbSetOrder( 2 ) )

//�����������������������������������������������������Ŀ
//� Define c�lulas que ser�o carregadas na impress�o�
//�������������������������������������������������������
For i := 1 To Len( aHeader )
	If !Empty( aHeader[ i ][ 1 ] )
		TRCell():New( oSection2                     ,;
		aHeader[ i ][ 2 ]              ,;
		/* cAlias */                   ,;
		aHeader[ i ][ 1 ] /*Titulo*/   ,;
		aHeader[ i ][ 3 ] /*Picture*/  ,;
		aHeader[ i ][ 4 ] /*Tamanho*/  ,;
		/*lPixel*/   ,;
		/*CodeBlock*/                   ;
		)
	EndIf
Next


TRCell():New( oSection1 , "PARAMETROS" ,, "Parametros do Relatorio" , "" , 200 )

//���������������������������������������Ŀ
//�Define o cabecalho da secao como padrao�
//�����������������������������������������
oSection1:SetHeaderPage()

//�������������������������������������0�
//�Define em 'Arquivo' a sa�da default.�
//�������������������������������������0�
oReport:nDevice := 1

oReport:PrintDialog()


End Sequence

Return( cReport )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportPrint  �Autor  �Microsiga        � Data �  03/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Funcao auxiliar para impressao do relatorio               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


Static Function ReportPrint( oReport )

Local oSection1 := oReport:Section( 1 )
Local oSection2 := oReport:Section( 2 )
Local i
Local j
Local cFilter   := ""
Local lExcel    := oReport:nDevice = 4
Local xValue
Local nPos

oReport:SetMeter( Len( aCols ) )
//��������������������������������������������������������������Ŀ
//�Se o destino nao for para uma planilha, imprime se��o de parametros.�
//����������������������������������������������������������������
If !lExcel
	For i := 1 To Len( aFilter )
		If Empty( aFilter[ i ][ 2 ] )
			Loop
		EndIf
		If !Empty( cFilter )
			cFilter += " <> "
		EndIf
		cFilter += aFilter[ i ][ 1 ] + ":" + aFilter[ i ][ 2 ]
	Next
	If !Empty( cFilter )
		oSection1:Init()
		oSection1:Cell( "PARAMETROS" ):SetValue( cFilter )
		oSection1:PrintLine()
		oSection1:Finish()
	EndIf
EndIf

//��������������������������������������������������������������������������Ŀ
//�Desabilita o cabe�alho da se��o de parametros, para imprimir somente na�
//�primeira pagina.                                        �
//����������������������������������������������������������������������������
oSection1:SetHeaderSection( .F. )

//��������������������������������������������
//�Inicializa impressao da se��o do relatorio.�
//��������������������������������������������
oSection2:Init()
For i := 1 To Len( aCols )
	If oReport:Cancel()
		Exit
	EndIf
	oReport:IncMeter()
	For j := 1 To Len( oSection2:aCell )
		xValue := GdFieldGet( oSection2:aCell[ j ]:cName , i )
		If !Empty( oSection2:aCell[ j ]:aCBox ) .And. !Empty( xValue )
			If ( nPos := Ascan( oSection2:aCell[ j ]:aCBox , { | x | x[ 1 ] == xValue } ) ) > 0
				oSection2:aCell[ j ]:nSize := Len( oSection2:aCell[ j ]:aCBox[ nPos ][ 2 ] )
				oSection2:Cell( oSection2:aCell[ j ]:cName ):SetValue( oSection2:aCell[ j ]:aCBox[ nPos ][ 2 ] )
			EndIf
		Else
			oSection2:Cell( oSection2:aCell[ j ]:cName ):SetValue( xValue )
			
		EndIf
	Next
	oSection2:PrintLine()
	
	//�����������������������������������������������������������������Ŀ
	//�Quando imprimir em planilha, mostrar o cabe�alho somente uma vez.�
	//�������������������������������������������������������������������
	If lExcel .And. i = 1
		oSection2:SetHeaderSection( .F. )
	EndIf
Next
oSection2:Finish()

Return
