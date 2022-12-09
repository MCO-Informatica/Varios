#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "FILEIO.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณADVOrdGD  ณ Autor ณ Alexandre B. Silva    ณ Data ณ 31/07/08 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณReordena aCols de acordo com o campo sequencia              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe e ณADVOrdGD(oObjGet,aHeadTmp,aColsTmp,cCpoOrd)                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Parametros : 	oObjGet -> Objeto MsGetDados ativo
aHeadTmp -> aHeader da MsGetDados (default = aHeader)
aColsTmp -> aCols da MsGetDados (default = aCols)
cCpoOrd -> Campo a ser utilizado na ordenacao
/*/

User Function ADVOrdGD(oObjGet,aHeadTmp,aColsTmp,cCpoOrd)

Local nLenCol	:= 0
Local nInd		:= 1
Local nPosDel	:= 0
Local nPosCpo	:= 0
Local nTamCpo	:= 0

DEFAULT aColsTmp := aClone(aCols)
DEFAULT aHeadTmp := aClone(aHeader)


If (nPosCpo := GDFieldPos(cCpoOrd,aHeadTmp)) > 0
	
	nLenCol	:= Len( aColsTmp )
	nPosDel	:= Len( aHeadTmp ) + 1
	nTamCpo := TamSX3(cCpoOrd)[1]
	
	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณOrdena็ใo automแtica da aCols, permitindo a altera็ใo da ordemณ
	//ณdas linhas pelo usuแrio.                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
	
	// Adiciona ao campo sequencia o ํndice invertido do aCols
	aEval(aColsTmp, {|x,y| aColsTmp[y][nPosCpo] := StrZero(Val(x[nPosCpo]),nTamCpo) + StrZero(If(x[nPosDel],Val(x[nPosCpo]),nLenCol--),nTamCpo) } )
	// Ordena aCols
	aSort(aColsTmp,,, {|x,y| x[nPosCpo] < y[nPosCpo]} )
	// Renumera o campo sequencia do aCols
	aEval(aColsTmp, {|x,y| aColsTmp[y][nPosCpo] := StrZero(If(x[nPosDel],Val(Left(x[nPosCpo],nTamCpo)),nInd++),nTamCpo) } )
	// Atualiza tela
	oObjGet:Refresh()
	
EndIf

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMsgHBox   บAutor  ณ Fernando Salvatori บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibe uma mensagem no padrao Help.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MsgHBox( cMensagem, cTipoHelp )
Local aMsg  := {}
Local cText := ""
Local nMemo := 0

Default cTipoHelp := ProcName(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuebro o texto em 40 posicoesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Q_MemoArray( cMensagem, @aMsg, 40 )

For nMemo := 1 to Len( aMsg )
	cText += aMsg[nMemo]+Chr(13)+Chr(10)
Next nMemo

Help(" ",1,"NVAZIO",cTipoHelp,cText,1,0)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A1MAXCOD บAutor  ณ Adilson Gomes      บ Data ณ 22/08/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para Retornar o ultimo codigo de cliente.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A1MAXCOD()
Local aGetArea := GetArea()
Local cQry     := ""
Local nTmSA1   := TamSX3("A1_COD")[1]
Local cMayA1   := ""
Local _cRet    := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Query para selacao do ultimo numero disponivel ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQry := "SELECT MAX(A1_COD) A1_COD FROM "+RetSQLName("SA1")+" WHERE A1_FILIAL = '"+xFilial("SA1")+"' AND D_E_L_E_T_ = ' '"

If Select("TMPA1") > 0
	TMPA1->( dbCloseArea() )
EndIf

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQry), "TMPA1", .T., .F. )

cMayA1 := Soma1(PadR(TMPA1->A1_COD, nTmSA1))

FreeUsedCode()
while !MayIUseCode(cMayA1)
	FreeUsedCode()
	cMayA1 := Soma1(cMayA1)
End

_cRet := cMayA1

TMPA1->( dbCloseArea() )

RestArea( aGetArea )
Return _cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA1CODJUR  บAutor  ณIvan Morelatto Tore บ Data ณ  01/27/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Codifica Cadastro de Clientes com Tipo Pessoal Juridica.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gatilho SX7                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A1CODJUR

Local aAreaAtu	:= GetArea()
Local cCNPJ  	:= &( ReadVar() )
Local cQuery    := ""
Local cCodigo   := ""
Local cLoja     := ""
Local nTamCod   := TamSX3( "A1_COD" )[1]
Local nTamLoj   := TamSX3( "A1_LOJA" )[1]

If Inclui .and. M->A1__PESCLI == "2" .and. !Empty( cCNPJ )
	
	cQuery += "SELECT Max( A1_COD || A1_LOJA ) A1_CODLJ"
	cQuery += "  FROM " + RetSQLName( "SA1" )
	cQuery += " WHERE SUBSTR( A1_CGC, 1 , 8 ) = '" + SubStr( cCNPJ, 1, 8 ) + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	If Select( "TMP_SA1") > 0
		TMP_SA1->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SA1", .T., .F. )
	If TMP_SA1->( !Eof() )
		cCodigo := SubStr( TMP_SA1->A1_CODLJ, 1, nTamCod )
		cLoja   := Soma1( SubStr( TMP_SA1->A1_CODLJ, nTamCod + 1, nTamLoj ), nTamLoj )
	Endif
	TMP_SA1->( dbCloseArea() )
	
	If !Empty( cCodigo ) .and. !Empty( cLoja )
		M->A1_COD 	:= cCodigo
		M->A1_LOJA 	:= cLoja
	Endif
	
Endif

RestArea( aAreaAtu )

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvLog    บAutor  ณIvan Morelatto Tore บ Data ณ  22/03/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera arquivo de Log para informar se alguma coisa nao       บฑฑ
ฑฑบ          ณfuncionou corretamente no processamento.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณGrvLog( ExpC1, ExpC2 )                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณExpC1 - Path e nome do arquivo para gerar o log             บฑฑ
ฑฑบ          ณExpC2 - Texto a ser gravado no arquivo de log.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GrvLog( cArquivo, cTexto )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de Variaveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nHdl     := 0			// Handle do arquivo texto

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o arquivo Existeณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !File( cArquivo )
	nHdl := FCreate( cArquivo )
Else
	nHdl := FOpen( cArquivo, 2 )
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua grava็ใo do textoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FSeek( nHdl, 0, FS_END )
cTexto += Chr(13) + Chr(10)
FWrite( nHdl, cTexto, Len(cTexto) )
FClose( nHdl )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetErroEA บAutor  ณIvan Morelatto Tore บ Data ณ  01/15/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para obter o error informado por MsExecAuto          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ VOID                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GetErroEA

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variavel para guardar o erro do execauto ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cErrLog		:= ""
Local _cErrLogA	:= ""
Local _cFilLog 	:= NomeAutoLog()
Local aErros    	:= {}
Local nAux		:= 0

If ValType( _cFilLog ) == "C" .and. !Empty( _cFilLog )
	MostraErro(GetSrvProfString("StartPath",""), "I"+_cFilLog)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grava o erro em disco ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cErrLog := MemoRead(GetSrvProfString("StartPath","")+"I"+_cFilLog)
	_cErrLogA:= ""
	For nAux := 1 to Len(_cErrLog)
		If (SubStr(_cErrLog,nAux,1) == Chr(10) .or. SubStr(_cErrLog,nAux,1) == Chr(13)) .and. !Empty(_cErrLogA)
			_cErrLogA := StrTran( _cErrLogA, Chr(10), "")
			_cErrLogA := StrTran( _cErrLogA, Chr(13), "")
			aAdd(aErros, _cErrLogA)
			_cErrLogA := ""
		Else
			_cErrLogA += SubStr(_cErrLog,nAux,1)
		EndIf
	Next nAux
	
	If !Empty(_cErrLogA)
		aAdd(aErros, _cErrLogA)
		_cErrLogA := ""
	EndIf
	
	_cErrLog := ""
	
	If AScan( aErros, { |x| "invalido" $ lower( x ) } ) > 0
		
		For nAux := 1 to Len(aErros)
			If "Invalido" $ aErros[nAux]
				_cErrLog += AllTrim(aErros[nAux])+", "
			EndIf
		Next nAux
		
	Else
		
		For nAux := 1 to Len(aErros)
			_cErrLog += AllTrim(aErros[nAux])+", "
		Next nAux
		
	EndIf
	
	//If Empty(_cErrLog)
	//	_cErrLog := "Ver arquivo " + GetSrvProfString("StartPath","")+"I"+_cFilLog
	//Else
	fErase(GetSrvProfString("StartPath","")+"I"+_cFilLog)
	_cErrLog := Left(_cErrLog, Len(_cErrLog) - 2)
	//Endif
EndIf

Return AllTrim( _cErrLog )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAllCpoObr บAutor  ณIvan Morelatto Tore บ Data ณ  XX/XX/XX   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se todos os campos obrigatorios de um Alias       บฑฑ
ฑฑบ          ณ existem em uma tabela temporaria                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Void                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AllCpoObr( cTableMS, cTableInt )

Local lRet		:= .T.
Local aAreaAtu 	:= GetArea()
Local aAreaSX3 	:= GetArea()
Local aCpoObr	:= {}
Local nCntFor	:= 0
Local aSX3      := {}
Local nX        := 0

aSX3 := FWSx3Util():GetAllFields(cTableMS , .F.)
If len(aSX3) > 0
	for nX := 1 to len(aSX3)
		If GetSx3Cache(aSX3[nX],"X3_CONTEXT") != "V" .and. !( "_FILIAL" $ GetSx3Cache(aSX3[nX],"X3_CAMPO") ) .and. Upper( Alltrim(GetSx3Cache(aSX3[nX],"X3_CAMPO")) ) != "A1_CDRDES" .and. X3Obrigat(GetSx3Cache(aSX3[nX],"X3_CAMPO"))
			aAdd( aCpoObr, Upper( AllTrim(GetSx3Cache(aSX3[nX],"X3_CAMPO")) ) )
		Endif
		
	next nX
	
	For nCntFor := 1 To Len( aCpoObr )
		If (cTableInt)->( FieldPos( aCpoObr[nCntFor] ) ) == 0
			lRet := .F.
		Endif
	Next nCntFor
	
	If lRet
		For nCntFor := 1 to Len( aCpoObr )
			If Empty( (cTableInt)->( &( aCpoObr[nCntFor] ) ) )
				lRet := .F.
			Endif
		Next nCntFor
	Endif
Else
	lRet  := .F.
Endif

RestArea( aAreaAtu )
RestArea( aAreaSX3 )

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณFNMGetMailณ Autor ณ Adilson Gomes         ณ Data ณ05/06/2007ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ Parceiros        ณContato ณ adilson.gomes@advbrasil.com.br ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Rotina responsavel pelo envio de e-mail.                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Generico                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ Bops ณ Manutencao Efetuada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ        ณ      ณ                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User function FNMGetMail(aCtaTo,cAstoMail,cMsgMail,aAnexo,ccc)
Local cCtaMail		:= GetMV("MV_RELFROM")									//Conta de envio.
Local cCtaAutMail	:= GetMV("MV_RELACNT")									//Conta de autenticacao.
Local lAutMail		:= GetMV("MV_RELAUTH")									//Verifica se a autenticacao.
Local cPswMail		:= GetMV("MV_RELPSW")									//Senha para o envio do e-mail.
Local cServerMail	:= GetMV("MV_RELSERV")									//Servidor smtp.
Local cCtaAudit		:= GetMV("MV_MAILADT")									//Conta oculta de auditoria.
Local lSmtpOk		:= MailSmtpOn(cServerMail, cCtaAutMail, cPswMail)		//Conecta com o servidor de e-mail.
Local aCC			:= {}
Local aCtaAudit		:= {}
Local cErrSend		:= " "
Local lAutOk		:= .F.
Local lSendOk		:= .F.
Local nAt			:= 0

Default aCtaTo		:= {}
Default aAnexo		:= {}
Default cAstoMail	:= "Sem Assunto"
Default cMsgMail	:= "Sem Texto"
Default ccc		    := ""

Aadd(acc,GetMV("MV_EMAILCO") + Iif(Empty(ccc) , "" , ccc))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se houve conexao com o servidor de e-mail ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ! lSmtpOk
	cErrSend := MailGetErr()
	Help(" ",1,"GetMail_01",, cErrSend, 4, 5)
	Return lSendOk
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se o servidor necessita de autenticacao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lAutMail
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Efetua a autenticacao no servidor de e-mail ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lAutOk := MailAuth(cCtaAutMail, cPswMail)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se nao conseguiu fazer a Autenticacao usando o E-mail ณ
	//ณ completo, tenta fazer a autenticacao usando apenas o  ณ
	//ณ nome de usuario do E-mail.                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ! lAutOk
		nAt			:= At("@",cCtaAutMail)
		cCtaAutMail	:= If(nAt > 0, SubStr(cCtaAutMail, 1, nAt-1), cCtaAutMail)
		lAutOk		:= MailAuth(cCtaAutMail, cPswMail)
	EndIf
Else
	lAutOk := .T.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica a conexao com o servidor e a autenticacao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lSmtpOk .and. lAutOk
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se existe conta de auditoria ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty(cCtaAudit)
		aCtaAudit := StrToArray( cCtaAudit, ";")
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Envio do e-mail ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lSendOk := MailSend(cCtaMail, aCtaTo/*From*/, aCc, aCtaAudit/*aBcc*/, cAstoMail, cMsgMail, aAnexo)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se o e-mail foi enviado ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ! lSendOk
		cErrSend := MailGetErr()
		If ! lBlind
			Help(" ",1,"GetMail_02",, cErrSend, 4, 5)
		Else
			cMsg := "Erro de conexใo ao banco AS3."
			FWLogMsg("INFO", "", "BusinessObject", "FNMGetMail", "", "", cErrSend, 0, 0)
		EndIf
	Endif
Else
	cErrSend := MailGetErr()
	If ! lBlind
		Help(" ",1,"GetMail_03",, cErrSend, 4, 5)
	Else
		cMsg := "Erro de conexใo ao banco AS3."
		FWLogMsg("INFO", "", "BusinessObject", "FNMGetMail", "", "", cErrSend, 0, 0)
	EndIf
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Encerra a conexao com o servidor de e-mail ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lSmtpOk
	MailSmtpOff()
EndIf

Return lSendOk

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ FTCONAS3 ณ Autor ณ Adilson Gomes         ณ Data ณ21/03/2009ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ Parceiros        ณContato ณ adilson.gomes@advbrasil.com.br ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Rotina para conexao via TCLink                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Generico                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ Bops ณ Manutencao Efetuada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ      ณ                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User function FTCONAS3(lDescon, cAssDB, cAliasDB, cServerAS3)
Local nLinkCD      := 0
Default cAssDB     := "ORACLE"
Default cAliasDB   := "oracledb"
Default cServerAS3 := GetNewPar("MV_XIP-AS3","192.168.0.15" )
Default lDescon    := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processo para desconectar do oracledb ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lDescon
	TCSetConn( ADVConnection() )
	Return 0
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processo de conexao com o banco oracledb ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If ( nLinkCD := TCLink(cAssDB+"/"+cAliasDB, cServerAS3) )< 0
	If ! _lBlind
		MsgStop( "Erro de conexใo ao banco AS3." )
	Else
		cMsg := "Erro de conexใo ao banco AS3."
		FWLogMsg("INFO", "", "BusinessObject", "FTCONAS3", "", "", cMsg, 0, 0)

	EndIf
	
	TCSetConn( ADVConnection() )
	Return
Endif

Return nLinkCD

#Include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ M4MENPAD ณ Autor ณ Adilson Gomes         ณ Data ณ21/03/2009ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ Parceiros        ณContato ณ adilson.gomes@advbrasil.com.br ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Rotina para utilizacao no SM4.                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Generico                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ Bops ณ Manutencao Efetuada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ      ณ                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function M4MENPAD(cNumNota)
Local aGetArea := GetArea()
local cRetFun  := ""

Default cNumNota := ""
If Empty(cNumNota)
	Return
EndIf

SZ0->( dbSetOrder(1) )
If SZ0->( dbSeek(xFilial("SZ0")+cNumNota) )
	cRetFun := SZ0->Z0_DESCRI
EndIf

RestArea( aGetArea )
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ INCMENPD ณ Autor ณ Adilson Gomes         ณ Data ณ01/04/2009ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ Parceiros        ณContato ณ adilson.gomes@advbrasil.com.br ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Rotina para inclusao da tabela de mensagem da NF           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Generico                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ Bops ณ Manutencao Efetuada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ      ณ                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function INCMENPD(cNumNota, cDescri)
Local aGetArea := GetArea()
local lChkSZ0  := .F.

Default cNumNota := ""
Default cDescri  := ""

If Empty(cNumNota)
	Return
EndIf

If Empty(cDescri)
	Return
EndIf

dbSelectArea("SZ0")
SZ0->( dbSetOrder(1) )
lChkSZ0 := !SZ0->( dbSeek(xFilial("SZ0")+cNumNota) )
SZ0->( RecLock("SZ0", lChkSZ0) )
SZ0->Z0_FILIAL  := xFilial("SZ0")
SZ0->Z0_NFISCAL := cNumNota
SZ0->Z0_DESCRI  := cDescri
SZ0->( MsUnLock() )

RestArea( aGetArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  04/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ATUSB5SB1

Local cQuery := ""
Local lConf  := .F.
Local aNCM   := {}
Local nLoop  := 0

lConf := MsgYesNo( "Confirma atualiza็ใo do complemento do produto para gera็ใo dos mapas?" )

If !lConf
	MsgStop( "Opera็ใo Cancelada!" )
	Return
Endif

aAdd( aNCM, { "ACETATO DE BUTILA", "29153300",	99.00,	0.88 } )
aAdd( aNCM, { "ACETATO DE ETILA", "29153100",	99.00,	0.90 } )
aAdd( aNCM, { "ACETATO DE N-PROPILA", "29153931",	99.00,	0.89 } )
aAdd( aNCM, { "ACETONA", "29141100",	99.00,	0.79 } )
aAdd( aNCM, { "ACIDO ACETICO", "29152100",	99.00,	1.05 } )
aAdd( aNCM, { "ACIDO BENZOICO", "29163110",	99.00,	1.32 } )
aAdd( aNCM, { "ACIDO FORMICO", "29151100",	84.00,	1.20 } )
aAdd( aNCM, { "ACIDO FORMICO S-A", "29151100",	94.00,	1.20 } )
aAdd( aNCM, { "ANIDRIDO ACETICO GLACIAL", "29152400",	99.00,	1.08 } )
aAdd( aNCM, { "BARRILHA LEVE", "29362010",	99.00,	2.53 } )
aAdd( aNCM, { "CAFEINAS", "29393000",	98.00,	1.00 } )
aAdd( aNCM, { "CLORETO DE METILENO", "29031200",	99.00,	1.32 } )
aAdd( aNCM, { "DIACETONA ALCOOL (DAA)", "29144010",	98.00,	0.94 } )
aAdd( aNCM, { "HEXANO", "29011000",	98.00,	0.67 } )
aAdd( aNCM, { "HIDROCARBONETOS", "27101110",	95.00,	0.67 } )
aAdd( aNCM, { "ISOBUTANOL", "29051410",	99.00,	0.80 } )
aAdd( aNCM, { "METIL ETIL KETONE (MEK)", "29141200",	99.00,	0.81 } )
aAdd( aNCM, { "METILISOBUTILCETONA (MIBK)", "29141300",	99.00,	0.80 } )
aAdd( aNCM, { "N-BUTANOL", "29051300",	99.00,	0.81 } )
aAdd( aNCM, { "N-PROPANOL", "29051210",	99.00,	0.81 } )
aAdd( aNCM, { "SODA CAUSTICA ESCAMA", "28151100",	97.00,	2.13 } )
aAdd( aNCM, { "SODA CAUSTICA PEROLAS 99%", "28151100",	99.00,	2.13 } )
aAdd( aNCM, { "SODA CAUSTICA LIQUIDA", "28151200",	49.00,	1.53 } )
aAdd( aNCM, { "TOLUENO", "29023000",	98.00,	0.86 } )

For nLoop := 1 To Len( aNCM )
	
	cQuery := "UPDATE " + RetSQLName( "SB1" )
	cQuery += "   SET B1_CONCENT = " + AllTrim( Str( aNCM[nLoop][3] ) )
	cQuery += " WHERE B1_POSIPI  = '" + aNCM[nLoop][2] + "' "
	cQuery += "   AND B1_CONCENT = 0 "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	TCSQLExec( cQuery )
	TcRefresh( 'SB1' )
	
	cQuery := "UPDATE " + RetSQLName( "SB1" )
	cQuery += "   SET B1_DENSID  = " + AllTrim( Str( aNCM[nLoop][4] ) )
	cQuery += " WHERE B1_POSIPI  = '" + aNCM[nLoop][2] + "' "
	cQuery += "   AND B1_DENSID  = 0 "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	TCSQLExec( cQuery )
	TcRefresh( 'SB1' )
	
Next

cQuery := "UPDATE " + RetSQLName( "SB5" )
cQuery += "   SET B5_MAPIV   = '2' "
cQuery += " WHERE D_E_L_E_T_ = ' ' "
TCSQLExec( cQuery )
TcRefresh( 'SB5' )

cQuery := "UPDATE " + RetSQLName( "SB5" )
cQuery += "   SET B5_PRODPF  = Nvl( ( SELECT B1_POLFED FROM " + RetSQLName( "SB1" ) + " WHERE B1_FILIAL = B5_FILIAL AND B1_COD = B5_COD AND D_E_L_E_T_ = ' ' ), 'N' ) "
cQuery += " WHERE D_E_L_E_T_ = ' ' "
TCSQLExec( cQuery )
TcRefresh( 'SB5' )

cQuery := "UPDATE " + RetSQLName( "SB5" )
cQuery += "   SET B5_PRODCON = Nvl( ( SELECT B1_POLCIV FROM " + RetSQLName( "SB1" ) + " WHERE B1_FILIAL = B5_FILIAL AND B1_COD = B5_COD AND D_E_L_E_T_ = ' ' ), 'N' ) "
cQuery += " WHERE D_E_L_E_T_ = ' ' "
TCSQLExec( cQuery )
TcRefresh( 'SB5' )

cQuery := "UPDATE " + RetSQLName( "SB5" )
cQuery += "   SET B5_PRODME  = Nvl( ( SELECT B1_MINEXEC FROM " + RetSQLName( "SB1" ) + " WHERE B1_FILIAL = B5_FILIAL AND B1_COD = B5_COD AND D_E_L_E_T_ = ' ' ), 'N' ) "
cQuery += " WHERE D_E_L_E_T_ = ' ' "
TCSQLExec( cQuery )
TcRefresh( 'SB5' )

cQuery := "UPDATE " + RetSQLName( "SB5" )
cQuery += "   SET B5_DENSID  = Nvl( ( SELECT B1_DENSID  FROM " + RetSQLName( "SB1" ) + " WHERE B1_FILIAL = B5_FILIAL AND B1_COD = B5_COD AND D_E_L_E_T_ = ' ' ), 0 ) "
cQuery += " WHERE D_E_L_E_T_ = ' ' "
TCSQLExec( cQuery )
TcRefresh( 'SB5' )

cQuery := "UPDATE " + RetSQLName( "SB5" )
cQuery += "   SET B5_CONCENT = Nvl( ( SELECT B1_CONCENT FROM " + RetSQLName( "SB1" ) + " WHERE B1_FILIAL = B5_FILIAL AND B1_COD = B5_COD AND D_E_L_E_T_ = ' ' ), 0 ) "
cQuery += " WHERE D_E_L_E_T_ = ' '
TCSQLExec( cQuery )
TcRefresh( 'SB5' )

Aviso( "MAPAS", "Atualiza็ใo do Complemento do Produto Efetuada com Sucesso!", { "Ok" } )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  07/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AGLMAPAS( aTRBS, dDataIni, dDataFim )

Local aNCM	:= {}

Local aTPR	:= {}
Local aTMV	:= {}
Local aTSP	:= {}
Local aTPF	:= {}
Local aTIE 	:= {}
Local aTAM	:= {}
Local aTMA  := {}
Local aTRE	:= {}

Local nPosTMP := 0
Local nPosNCM := 0
Local nLoop   := 0

Local nUtiliz  := 0
Local nEvapora := 0

Local nEntDiv  := 0
Local nSaiDiv  := 0

Local cQuery := ""

Local cDescProd := ""

MsgInfo( "Inicio Aglutina็ใo" )

aAdd( aNCM, { "ACETATO DE BUTILA", "29153300",	99.00,	0.88 } )
aAdd( aNCM, { "ACETATO DE ETILA", "29153100",	99.00,	0.90 } )
aAdd( aNCM, { "ACETATO DE N-PROPILA", "29153931",	99.00,	0.89 } )
aAdd( aNCM, { "ACETONA", "29141100",	99.00,	0.79 } )
aAdd( aNCM, { "ACIDO ACETICO", "29152100",	99.00,	1.05 } )
aAdd( aNCM, { "ACIDO BENZOICO", "29163110",	99.00,	1.32 } )
aAdd( aNCM, { "ACIDO FORMICO", "29151100",	84.00,	1.20 } )
aAdd( aNCM, { "ACIDO FORMICO S-A", "29151100",	94.00,	1.20 } )
aAdd( aNCM, { "ANIDRIDO ACETICO GLACIAL", "29152400",	99.00,	1.08 } )
aAdd( aNCM, { "BARRILHA LEVE", "29362010",	99.00,	2.53 } )
aAdd( aNCM, { "CAFEINAS", "29393000",	98.00,	1.00 } )
aAdd( aNCM, { "CLORETO DE METILENO", "29031200",	99.00,	1.32 } )
aAdd( aNCM, { "DIACETONA ALCOOL (DAA)", "29144010",	98.00,	0.94 } )
aAdd( aNCM, { "HEXANO", "29011000",	98.00,	0.67 } )
aAdd( aNCM, { "HIDROCARBONETOS", "27101110",	95.00,	0.67 } )
aAdd( aNCM, { "ISOBUTANOL", "29051410",	99.00,	0.80 } )
aAdd( aNCM, { "METIL ETIL KETONE (MEK)", "29141200",	99.00,	0.81 } )
aAdd( aNCM, { "METILISOBUTILCETONA (MIBK)", "29141300",	99.00,	0.80 } )
aAdd( aNCM, { "N-BUTANOL", "29051300",	99.00,	0.81 } )
aAdd( aNCM, { "N-PROPANOL", "29051210",	99.00,	0.81 } )
aAdd( aNCM, { "SODA CAUSTICA ESCAMA", "28151100",	97.00,	2.13 } )
aAdd( aNCM, { "SODA CAUSTICA PEROLAS 99%", "28151100",	99.00,	2.13 } )
aAdd( aNCM, { "SODA CAUSTICA LIQUIDA", "28151200",	49.00,	1.53 } )
aAdd( aNCM, { "TOLUENO", "29023000",	98.00,	0.86 } )

/*
TPR
*/
TPR->( dbGoTop() )
While TPR->( !Eof() )
	
	nPosTMP := aScan( aTPR, { |x| x[3] == TPR->NCM } )
	
	If nPosTMP > 0
		aTPR[nPosTMP][07] += TPR->QT_EST_ANT
		aTPR[nPosTMP][08] += TPR->QT_PRODUZ
		aTPR[nPosTMP][09] += TPR->QT_TRANSF
		aTPR[nPosTMP][10] += TPR->QT_UTILIZ
		aTPR[nPosTMP][11] += TPR->QT_COMPRAS
		aTPR[nPosTMP][12] += TPR->QT_VENDAS
		aTPR[nPosTMP][13] += TPR->QT_RECICLA
		aTPR[nPosTMP][14] += TPR->QT_REAPROV
		aTPR[nPosTMP][15] += TPR->QT_IMPORT
		aTPR[nPosTMP][16] += TPR->QT_EXPORT
		aTPR[nPosTMP][17] += TPR->QT_PERDAS
		aTPR[nPosTMP][18] += TPR->QT_EVAPORA
		aTPR[nPosTMP][19] += TPR->QT_ENT_DIV
		aTPR[nPosTMP][20] += TPR->QT_SAI_DIV
		aTPR[nPosTMP][21] += TPR->QT_EST_ATU
	Else
		nPosNCM := aScan( aNCM, { |x| AllTrim( x[2] ) == AllTrim( TPR->NCM ) } )
		
		If At( " - ", TPR->DESCR_PROD ) > 1
			cDescProd := SubStr( TPR->DESCR_PROD, 1, At( " - ", TPR->DESCR_PROD ) - 1 )
		Else
			cDescProd := TPR->DESCR_PROD
		Endif
		
		aAdd( aTPR, { 	TPR->NCM,;
		TPR->NCM,;
		TPR->NCM,;
		Iif( nPosNCM > 0, aNCM[nPosNCM][1], cDescProd ),;
		Iif( nPosNCM > 0, aNCM[nPosNCM][3], TPR->CONCENT ),;
		Iif( nPosNCM > 0, aNCM[nPosNCM][4], TPR->DENSID ),;
		TPR->QT_EST_ANT,;
		TPR->QT_PRODUZ,;
		TPR->QT_TRANSF,;
		TPR->QT_UTILIZ,;
		TPR->QT_COMPRAS,;
		TPR->QT_VENDAS,;
		TPR->QT_RECICLA,;
		TPR->QT_REAPROV,;
		TPR->QT_IMPORT,;
		TPR->QT_EXPORT,;
		TPR->QT_PERDAS,;
		TPR->QT_EVAPORA,;
		TPR->QT_ENT_DIV,;
		TPR->QT_SAI_DIV,;
		TPR->QT_EST_ATU,;
		TPR->UN,;
		TPR->GRUPO,;
		TPR->EMISS } )
	Endif
	
	TPR->( dbSkip() )
Enddo

TPR->( dbGoTop() )
While TPR->( !Eof() )
	RecLock( "TPR", .F. )
	TPR->( dbDelete() )
	TPR->( MsUnLock() )
	
	TPR->( dbSkip() )
End

For nLoop := 1 To Len( aTPR )
	
	nUtiliz := 0
	cQuery := "SELECT NVL( SUM( D3_QUANT ), 0 ) D3_QUANT "
	cQuery += "  FROM " + RetSQLName( "SD3" )
	cQuery += " WHERE D3_FILIAL  = '" + xFilial( "SD3" ) + "' "
	cQuery += "   AND D3_COD     IN ( SELECT G1_COMP "
	cQuery += "                         FROM " + RetSQLName( "SG1" )
	cQuery += "                        WHERE G1_FILIAL = '" + xFilial( "SG1" ) + "' "
	cQuery += "                          AND G1_COD    IN ( SELECT B1_COD "
	cQuery += "                                               FROM " + RetSQLName( "SB1" )
	cQuery += "                                              WHERE B1_FILIAL  = '" + xFilial( "SB1" ) + "' "
	cQuery += "                                                AND B1_DESC    LIKE 'MISS%' "
	cQuery += "                                                AND D_E_L_E_T_ = ' ' ) "
	cQuery += "                           AND D_E_L_E_T_ = ' ' ) "
	cQuery += "   AND D3_COD     IN ( SELECT B1_COD "
	cQuery += "                         FROM " + RetSQLName( "SB1" )
	cQuery += "                        WHERE B1_FILIAL  = '" + xFilial( "SB1" ) + "' "
	cQuery += "                          AND B1_POLFED  = 'S' "
	cQuery += "                          AND B1_POSIPI  = '" + aTPR[nLoop][03] + "' "
	cQuery += "                          AND D_E_L_E_T_ = ' ' ) "
	cQuery += "   AND D3_EMISSAO BETWEEN '" + DtoS( dDataIni ) + "' AND '" + DtoS( dDataFim ) + "' "
	cQuery += "   AND D3_OP      != ' ' "
	cQuery += "   AND D3_ESTORNO != 'S' "
	cQuery += "   AND D3_OP      IN ( SELECT C2_NUM || C2_ITEM || C2_SEQUEN "
	cQuery += "                         FROM " + RetSQLName( "SC2" )
	cQuery += "                        WHERE C2_FILIAL = '" + xFilial( "SC2" ) + "' "
	cQuery += "                          AND C2_PRODUTO IN ( SELECT B1_COD "
	cQuery += "                                                FROM " + RetSQLName( "SB1" )
	cQuery += "                                               WHERE B1_FILIAL  = '" + xFilial( "SB1" ) + "' "
	cQuery += "                                                 AND B1_DESC    LIKE 'MISS%' "
	cQuery += "                                                 AND D_E_L_E_T_ = ' ' ) "
	cQuery += "                          AND D_E_L_E_T_  = ' ' ) "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	If Select( "MAP_SD3" ) > 0
		MAP_SD3->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "MAP_SD3", .T. , .F. )
	nUtiliz := MAP_SD3->D3_QUANT
	MAP_SD3->( dbCloseArea() )
	
	nEvapora := 0
	cQuery := "SELECT NVL( SUM( D3_QUANT ), 0 ) D3_QUANT "
	cQuery += "  FROM " + RetSQLName( "SD3" )
	cQuery += " WHERE D3_FILIAL  = '" + xFilial( "SD3" ) + "' "
	cQuery += "   AND D3_COD     IN ( SELECT B1_COD "
	cQuery += "                         FROM " + RetSQLName( "SB1" )
	cQuery += "                        WHERE B1_FILIAL  = '" + xFilial( "SB1" ) + "' "
	cQuery += "                          AND B1_POLFED  = 'S' "
	cQuery += "                          AND B1_POSIPI  = '" + aTPR[nLoop][03] + "' "
	cQuery += "                          AND D_E_L_E_T_ = ' ' )
	cQuery += "   AND D3_EMISSAO  BETWEEN '" + DtoS( dDataIni ) + "' AND '" + DtoS( dDataFim ) + "' "
	cQuery += "   AND D3_TM       IN ( '600' )
	cQuery += "   AND D_E_L_E_T_  = ' '
	If Select( "MAP_SD3" ) > 0
		MAP_SD3->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "MAP_SD3", .T. , .F. )
	nEvapora := MAP_SD3->D3_QUANT
	MAP_SD3->( dbCloseArea() )
	
	nEntDiv := 0
	cQuery := "SELECT NVL( SUM( D1_QUANT ), 0 ) D1_QUANT"
	cQuery += "  FROM " + RetSQLName( "SD1" )
	cQuery += " WHERE D1_FILIAL  = '" + xFilial( "SD1" ) + "' "
	cQuery += "   AND D1_COD     IN ( SELECT B1_COD "
	cQuery += "                         FROM " + RetSQLName( "SB1" )
	cQuery += "                        WHERE B1_FILIAL  = '" + xFilial( "SB1" ) + "' "
	cQuery += "                          AND B1_POLFED  = 'S' "
	cQuery += "                          AND B1_POSIPI  = '" + aTPR[nLoop][03] + "' "
	cQuery += "                          AND D_E_L_E_T_ = ' ' ) "
	cQuery += "   AND D1_DTDIGIT  BETWEEN '" + DtoS( dDataIni ) + "' AND '" + DtoS( dDataFim ) + "' "
	cQuery += "   AND D1_CF       IN ( '1917', '2917', '1910', '2910', '1401', '2402', '2202' ) "
	cQuery += "   AND D_E_L_E_T_  = ' ' "
	If Select( "MAP_SD1" ) > 0
		MAP_SD1->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "MAP_SD1", .T. , .F. )
	nEntDiv := MAP_SD1->D1_QUANT
	MAP_SD1->( dbCloseArea() )
	
	cQuery := "SELECT NVL( SUM( D3_QUANT ), 0 ) D3_QUANT "
	cQuery += "  FROM " + RetSQLName( "SD3" )
	cQuery += " WHERE D3_FILIAL  = '" + xFilial( "SD3" ) + "' "
	cQuery += "   AND D3_COD     IN ( SELECT B1_COD "
	cQuery += "                         FROM " + RetSQLName( "SB1" )
	cQuery += "                        WHERE B1_FILIAL  = '" + xFilial( "SB1" ) + "' "
	cQuery += "                          AND B1_POLFED  = 'S' "
	cQuery += "                          AND B1_POSIPI  = '" + aTPR[nLoop][03] + "' "
	cQuery += "                          AND D_E_L_E_T_ = ' ' )
	cQuery += "   AND D3_EMISSAO  BETWEEN '" + DtoS( dDataIni ) + "' AND '" + DtoS( dDataFim ) + "' "
	cQuery += "   AND D3_TM       IN ( '004', '100' )
	cQuery += "   AND D_E_L_E_T_  = ' '
	If Select( "MAP_SD3" ) > 0
		MAP_SD3->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "MAP_SD3", .T. , .F. )
	nEntDiv +=  MAP_SD3->D3_QUANT
	MAP_SD3->( dbCloseArea() )
	
	nSaiDiv := 0
	cQuery := "SELECT NVL( SUM( D2_QUANT ), 0 ) D2_QUANT "
	cQuery += "  FROM " + RetSQLName( "SD2" )
	cQuery += " WHERE D2_FILIAL  = '" + xFilial( "SD2" ) + "' "
	cQuery += "   AND D2_COD     IN ( SELECT B1_COD "
	cQuery += "                         FROM " + RetSQLName( "SB1" )
	cQuery += "                        WHERE B1_FILIAL  = '" + xFilial ( "SB1" ) + "' "
	cQuery += "                          AND B1_POLFED  = 'S' "
	cQuery += "                          AND B1_POSIPI  = '" + aTPR[nLoop][03] + "' "
	cQuery += "                          AND D_E_L_E_T_ = ' ' ) "
	cQuery += "   AND D2_EMISSAO  BETWEEN '" + DtoS( dDataIni ) + "' AND '" + DtoS( dDataFim ) + "' "
	cQuery += "   AND D2_CF       IN ( '5949','6949', '5917', '6917', '5910', '6910', '5401', '6402', '6202' ) "
	cQuery += "   AND D_E_L_E_T_  = ' ' "
	If Select( "MAP_SD2" ) > 0
		MAP_SD2->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "MAP_SD2", .T. , .F. )
	nSaiDiv := MAP_SD2->D2_QUANT
	MAP_SD2->( dbCloseArea() )
	
	nProduz := 0
	cQuery := "SELECT NVL( SUM( D1_QUANT ), 0 ) D1_QUANT"
	cQuery += "  FROM " + RetSQLName( "SD1" )
	cQuery += " WHERE D1_FILIAL  = '" + xFilial( "SD1" ) + "' "
	cQuery += "   AND D1_COD     IN ( SELECT B1_COD "
	cQuery += "                         FROM " + RetSQLName( "SB1" )
	cQuery += "                        WHERE B1_FILIAL  = '" + xFilial( "SB1" ) + "' "
	cQuery += "                          AND B1_POLFED  = 'S' "
	cQuery += "                          AND B1_POSIPI  = '" + aTPR[nLoop][03] + "' "
	cQuery += "                          AND D_E_L_E_T_ = ' ' ) "
	cQuery += "   AND D1_DTDIGIT  BETWEEN '" + DtoS( dDataIni ) + "' AND '" + DtoS( dDataFim ) + "' "
	cQuery += "   AND D1_CF       IN ( '1124', '2124' ) "
	cQuery += "   AND D_E_L_E_T_  = ' ' "
	If Select( "MAP_SD1" ) > 0
		MAP_SD1->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "MAP_SD1", .T. , .F. )
	nProduz := MAP_SD1->D1_QUANT
	MAP_SD1->( dbCloseArea() )
	
	nTransf := 0
	cQuery := "SELECT NVL( SUM( D2_QUANT ), 0 ) D2_QUANT "
	cQuery += "  FROM " + RetSQLName( "SD2" )
	cQuery += " WHERE D2_FILIAL  = '" + xFilial( "SD2" ) + "' "
	cQuery += "   AND D2_COD     IN ( SELECT B1_COD "
	cQuery += "                         FROM " + RetSQLName( "SB1" )
	cQuery += "                        WHERE B1_FILIAL  = '" + xFilial ( "SB1" ) + "' "
	cQuery += "                          AND B1_POLFED  = 'S' "
	cQuery += "                          AND B1_POSIPI  = '" + aTPR[nLoop][03] + "' "
	cQuery += "                          AND D_E_L_E_T_ = ' ' ) "
	cQuery += "   AND D2_EMISSAO  BETWEEN '" + DtoS( dDataIni ) + "' AND '" + DtoS( dDataFim ) + "' "
	cQuery += "   AND D2_CF       IN ( '5901', '6901' ) "
	cQuery += "   AND D_E_L_E_T_  = ' ' "
	If Select( "MAP_SD2" ) > 0
		MAP_SD2->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "MAP_SD2", .T. , .F. )
	nTransf := MAP_SD2->D2_QUANT
	MAP_SD2->( dbCloseArea() )
	
	nPerda := 0
	cQuery := "SELECT NVL( SUM( D1_QUANT ), 0 ) D1_QUANT"
	cQuery += "  FROM " + RetSQLName( "SD1" )
	cQuery += " WHERE D1_FILIAL  = '" + xFilial( "SD1" ) + "' "
	cQuery += "   AND D1_COD     IN ( SELECT B1_COD "
	cQuery += "                         FROM " + RetSQLName( "SB1" )
	cQuery += "                        WHERE B1_FILIAL  = '" + xFilial( "SB1" ) + "' "
	cQuery += "                          AND B1_POLFED  = 'S' "
	cQuery += "                          AND B1_POSIPI  = '" + aTPR[nLoop][03] + "' "
	cQuery += "                          AND D_E_L_E_T_ = ' ' ) "
	cQuery += "   AND D1_DTDIGIT  BETWEEN '" + DtoS( dDataIni ) + "' AND '" + DtoS( dDataFim ) + "' "
	cQuery += "   AND D1_CF       IN ( '1949','2949' ) "
	cQuery += "   AND D_E_L_E_T_  = ' ' "
	If Select( "MAP_SD1" ) > 0
		MAP_SD1->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "MAP_SD1", .T. , .F. )
	nPerda := MAP_SD1->D1_QUANT
	MAP_SD1->( dbCloseArea() )
	
	
	RecLock( "TPR", .T. )
	TPR->COD_PROD	:= aTPR[nLoop][01]
	TPR->CODPESQ	:= aTPR[nLoop][02]
	TPR->NCM		:= aTPR[nLoop][03]
	TPR->DESCR_PROD	:= aTPR[nLoop][04]
	TPR->CONCENT	:= aTPR[nLoop][05]
	TPR->DENSID		:= aTPR[nLoop][06]
	TPR->QT_EST_ANT	:= aTPR[nLoop][07]
	TPR->QT_PRODUZ	:= nProduz 					//aTPR[nLoop][08]
	TPR->QT_TRANSF	:= nTransf					//aTPR[nLoop][09]
	TPR->QT_UTILIZ	:= nUtiliz
	TPR->QT_COMPRAS	:= aTPR[nLoop][11]
	TPR->QT_VENDAS	:= aTPR[nLoop][12]
	TPR->QT_RECICLA	:= aTPR[nLoop][13]
	TPR->QT_REAPROV	:= aTPR[nLoop][14]
	TPR->QT_IMPORT	:= aTPR[nLoop][19]		//aTPR[nLoop][15]
	TPR->QT_EXPORT	:= aTPR[nLoop][16]
	TPR->QT_PERDAS	:= nPerda					//aTPR[nLoop][17]
	TPR->QT_EVAPORA	:= nEvapora
	TPR->QT_ENT_DIV	:= nEntDiv
	TPR->QT_SAI_DIV	:= nSaiDiv				//aTPR[nLoop][20]
	TPR->QT_EST_ATU	:= aTPR[nLoop][21]
	If !Empty( aTPR[nLoop][22] )
		If AllTrim( aTPR[nLoop][22] ) == "G"
			TPR->UN := "KG"
		ElseIf AllTrim( aTPR[nLoop][22] ) == "ML"
			TPR->UN := "L"
		Else
			TPR->UN := aTPR[nLoop][22]
		Endif
	Else
		TPR->UN := "KG"
	Endif
	TPR->GRUPO		:= aTPR[nLoop][23]
	TPR->EMISS		:= aTPR[nLoop][24]
	TPR->( MsUnLock() )
	
Next nLoop

/*
TMV
*/
TMV->( dbGoTop() )
While TMV->( !Eof() )
	
	nPosNCM := aScan( aNCM, { |x| AllTrim( x[2] ) == AllTrim( TMV->NCM ) } )
	
	If At( " - ", TMV->DESCR_PROD ) > 1
		cDescProd := SubStr( TMV->DESCR_PROD, 1, At( " - ", TMV->DESCR_PROD ) - 1 )
	Else
		cDescProd := TMV->DESCR_PROD
	Endif
	
	
	RecLock( "TMV", .F. )
	TMV->COD_PROD 	:= TMV->NCM
	TMV->CODPESQ  	:= TMV->NCM
	TMV->CONCENT 	:= If( nPosNCM > 0, aNCM[nPosNCM][3], TMV->CONCENT )
	TMV->DESCR_PROD	:= If( nPosNCM > 0, aNCM[nPosNCM][1], cDescProd )
	TMV->( MsUnLock() )
	
	TMV->( dbSkip() )
End

/*
TSP
*/
TSP->( dbGoTop() )
While TSP->( !Eof() )
	
	nPosNCM := aScan( aNCM, { |x| AllTrim( x[2] ) == AllTrim( TSP->NCM ) } )
	
	If At( " - ", TSP->DESCR_PROD ) > 1
		cDescProd := SubStr( TSP->DESCR_PROD, 1, At( " - ", TSP->DESCR_PROD ) - 1 )
	Else
		cDescProd := TSP->DESCR_PROD
	Endif
	
	
	RecLock( "TSP", .F. )
	TSP->CODPESQ  	:= TSP->NCM
	TSP->CODIGO   	:= TSP->NCM
	TSP->CONCENT 	:= If( nPosNCM > 0, aNCM[nPosNCM][3], TSP->CONCENT )
	TSP->DESCR_PROD	:= If( nPosNCM > 0, aNCM[nPosNCM][1], cDescProd )
	TSP->( MsUnLock() )
	
	TSP->( dbSkip() )
End

/*
TPF
*/
TPF->( dbGoTop() )
While TPF->( !Eof() )
	
	nPosNCM := aScan( aNCM, { |x| AllTrim( x[2] ) == AllTrim( TPF->NCM ) } )
	
	If At( " - ", TPF->DESCR_PROD ) > 1
		cDescProd := SubStr( TPF->DESCR_PROD, 1, At( " - ", TPF->DESCR_PROD ) - 1 )
	Else
		cDescProd := TPF->DESCR_PROD
	Endif
	
	RecLock( "TPF", .F. )
	TPF->CODPESQ  	:= TPF->NCM
	TPF->CODIGO   	:= TPF->NCM
	TPF->CONCENT 	:= If( nPosNCM > 0, aNCM[nPosNCM][3], TPF->CONCENT )
	TPF->DESCR_PROD	:= If( nPosNCM > 0, aNCM[nPosNCM][1], cDescProd )
	TPF->DENSID    	:= If( nPosNCM > 0, aNCM[nPosNCM][4], TPF->DENSID )
	TPF->( MsUnLock() )
	
	TPF->( dbSkip() )
End

/*
TIE
*/
TIE->( dbGoTop() )
While TIE->( !Eof() )
	
	nPosNCM := aScan( aNCM, { |x| AllTrim( x[2] ) == AllTrim( TIE->NCM ) } )
	
	If At( " - ", TIE->DESCR_PROD ) > 1
		cDescProd := SubStr( TIE->DESCR_PROD, 1, At( " - ", TIE->DESCR_PROD ) - 1 )
	Else
		cDescProd := TIE->DESCR_PROD
	Endif
	
	RecLock( "TIE", .F. )
	TIE->COD_PROD 	:= TIE->NCM
	TIE->CODPESQ  	:= TIE->NCM
	TIE->CONCENT 	:= If( nPosNCM > 0, aNCM[nPosNCM][3], TIE->CONCENT )
	TIE->DESCR_PROD	:= If( nPosNCM > 0, aNCM[nPosNCM][1], TIE->DESCR_PROD )
	TIE->( MsUnLock() )
	
	If TIE->QTDE <= 0
		RecLock( "TIE", .F. )
		TIE->( dbDelete() )
		TIE->( MsUnLock() )
	Endif
	
	TIE->( dbSkip() )
End

/*
TAM
*/
TAM->( dbGoTop() )
While TAM->( !Eof() )
	
	nPosTMP := aScan( aTAM, { |x| x[3] == TAM->NCM } )
	
	If At( " - ", TAM->DESCR_PROD ) > 1
		cDescProd := SubStr( TAM->DESCR_PROD, 1, At( " - ", TAM->DESCR_PROD ) - 1 )
	Else
		cDescProd := TAM->DESCR_PROD
	Endif
	
	
	If nPosTMP > 0
		aTAM[nPosTMP][06] += TAM->QT_EST_ANT
		aTAM[nPosTMP][07] += TPR->QT_EST_ATU
	Else
		nPosNCM := aScan( aNCM, { |x| AllTrim( x[2] ) == AllTrim( TPR->NCM ) } )
		
		aAdd( aTAM, { 	TAM->NCM,;
		TAM->NCM,;
		TAM->NCM,;
		Iif( nPosNCM > 0, aNCM[nPosNCM][1], cDescProd ),;
		Iif( nPosNCM > 0, aNCM[nPosNCM][3], TAM->CONCENT ),;
		TAM->QT_EST_ANT,;
		TAM->QT_EST_ATU,;
		TAM->UN,;
		TAM->CNPJ,;
		TAM->EMISS } )
	Endif
	
	TAM->( dbSkip() )
End

TAM->( dbGoTop() )
While TAM->( !Eof() )
	RecLock( "TAM", .F. )
	TAM->( dbDelete() )
	TAM->( MsUnLock() )
	
	TAM->( dbSkip() )
End

For nLoop := 1 To Len( aTAM )
	
	RecLock( "TAM", .T. )
	TAM->COD_PROD	:= aTAM[nLoop][01]
	TAM->CODPESQ	:= aTAM[nLoop][02]
	TAM->NCM		:= aTAM[nLoop][03]
	TAM->DESCR_PROD	:= aTAM[nLoop][04]
	TAM->CONCENT	:= aTAM[nLoop][05]
	TAM->QT_EST_ANT	:= aTAM[nLoop][06]
	TAM->QT_EST_ATU	:= aTAM[nLoop][07]
	TAM->UN       	:= Iif( !Empty( aTAM[nLoop][08] ), aTAM[nLoop][08], "KG" )
	TAM->CNPJ     	:= aTAM[nLoop][09]
	TAM->EMISS    	:= aTAM[nLoop][10]
	TAM->( MsUnLock() )
	
Next nLoop

/*
TMA
*/
TMA->( dbGoTop() )
While TMA->( !Eof() )
	
	nPosNCM := aScan( aNCM, { |x| AllTrim( x[2] ) == AllTrim( TMA->NCM ) } )
	
	If At( " - ", TMA->RAZSOC ) > 1
		cDescProd := SubStr( TMA->RAZSOC, 1, At( " - ", TMA->RAZSOC ) - 1 )
	Else
		cDescProd := TMA->RAZSOC
	Endif
	
	RecLock( "TMA", .F. )
	TMA->COD_PROD 	:= TMA->NCM
	TMA->CODPESQ  	:= TMA->NCM
	TMA->CONCENT 	:= If( nPosNCM > 0, aNCM[nPosNCM][3], TMA->CONCENT )
	TMA->RAZSOC    	:= If( nPosNCM > 0, aNCM[nPosNCM][1], cDescProd )
	TMA->( MsUnLock() )
	
	TMA->( dbSkip() )
End

/*
TRE
*/

MsgInfo( "Fim Aglutina็ใo" )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  07/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MCOMDEC

Local nOpcA       := 0
Local aSays       := {}
Local aButtons    := {}
Local cCadastro   := "Comdec"
Local cPerg       := "MCOMDEC"
Local aPergs := {}

aAdd( aPergs, { "Ano Referencia          ?","                         ","                         ","mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Pergunte( cPerg, .F.)

aAdd( aSays, "Essa rotina gera relat๓rio COMDEC" )
aAdd( aSays, "Especifico - "+SM0->M0_NOMECOM )

aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T.) } } )
aAdd( aButtons, { 1, .T., { || ( FechaBatch(), nOpcA := 1 ) } } )
aAdd( aButtons, { 2, .T., { || FechaBatch() } } )
FormBatch( cCadastro, aSays, aButtons )

If nOpcA == 1
	Processa( { || MCOMDECProc( mv_par01 ) }, "Gerando Relat๓rio..." )
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  07/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MCOMDECProc( cAnoRef )

Local aAreaAtu := GetArea()

Local cQuery	:= ""
Local nCount	:= 0

Local cArqExcel := "C:\TEMP\MAPAS\"+CriaTrab(Nil,.F.)+".CSV"

Local cLinha	:= '"CำDIGO ONU";"CLASSE DE RISCO";"DESCRIวรO PRODUTO";"GRUPO DE EMBALAGEM";"CำDIGO DA EMBALAGEM";"BAIRRO";"CIDADE";"UF";"REFERENCIA (Endere็o)";"VOLUME ANUAL";"UNIDADE DE MEDIDA";'

cQuery := "SELECT B1_DESC, B1__CODONU, B1_CLARIS, Z2_DESC, D2_QUANT, D2_UM, A1_BAIRRO, A1_MUN, A1_EST "
cQuery += "  FROM " + RetSQLName( "SD2" ) + " SD2 "
cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL = '" + xFilial( "SB1" ) + "' AND B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SA1" ) + " SA1 ON A1_FILIAL = '" + xFilial( "SB1" ) + "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SD2.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SZ2" ) + " SZ2 ON Z2_FILIAL = '" + xFilial( "SZ2" ) + "' AND Z2_COD = B1_EMB AND SZ2.D_E_L_E_T_ = ' ' "
cQuery += " WHERE D2_FILIAL                 = '" + xFilial( "SD2" ) + "' "
cQuery += "   AND SUBSTR( D2_EMISSAO, 1, 4) = '" + cAnoRef + "' "
cQuery += "   AND B1_COMDEC                 = 'S' "
cQuery += "   AND SD2.D_E_L_E_T_            = ' ' "
cQuery += " ORDER BY B1_DESC "
If Select( "TMP_COM" ) > 0
	TMP_COM->( dbCloseArea() )
Endif
dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_COM", .T., .F. )
TMP_COM->( dbGoTop() )
TMP_COM->( dbEval( { || nCount++ } ) )
TMP_COM->( dbGoTop() )

If Empty( nCount )
	TMP_COM->( dbCloseArea() )
	MsgStop( "Nใo existem registros para o relat๓rio. Verifique!" )
	RestArea( aAreaAtu )
	Return
Endif

ProcRegua( nCount )

u_AcaLogx( cArqExcel, "REGISTRO COMDEC" )
u_AcaLogx( cArqExcel, "ANO DE REFERENCIA: " + cAnoRef )
u_AcaLogx( cArqExcel, "CNPJ: 45.725.009/0005-21 " )
u_AcaLogx( cArqExcel, "RAZรO SOCIAL: "+SM0->M0_NOMECOM )
u_AcaLogx( cArqExcel, "BAIRRO: Piraporinha " )
u_AcaLogx( cArqExcel, "CIDADE: Diadema " )
u_AcaLogx( cArqExcel, "UF: SP " )
u_AcaLogx( cArqExcel, "ENDEREวO: AVENIDA PRESIDENTE JUSCELINO, 570 " )
u_AcaLogx( cArqExcel, cLinha )

While TMP_COM->( !Eof() )
	
	IncProc( "Gerando Relat๓rio" )
	
	cLinha := 	'=("' + TMP_COM->B1__CODONU + '");' +;
	'=("' + TMP_COM->B1_CLARIS + '");' +;
	'=("' + TMP_COM->B1_DESC + '");' +;
	'=("' + TMP_COM->Z2_DESC + '");' +;
	'=("' + Space(10) + '");' +;
	'=("' + TMP_COM->A1_BAIRRO + '");' +;
	'=("' + TMP_COM->A1_MUN + '");' +;
	'=("' + TMP_COM->A1_EST + '");' +;
	'=("' + Space(10) + '");' +;
	'=("' + TransForm( TMP_COM->D2_QUANT, "@E 99999999.99" ) + '");' +;
	'=("' + TMP_COM->D2_UM + '")'
	
	u_AcaLogx( cArqExcel, cLinha )
	
	TMP_COM->( dbSkip() )
End

TMP_COM->( dbCloseArea() )

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(cArqExcel)
oExcelApp:SetVisible(.T.)

cQuery	:= ""
nCount	:= 0

cArqExcel := "C:\TEMP\MAPAS\"+CriaTrab(Nil,.F.)+".CSV"

cLinha	:= '"RAZรO SOCIAL";"C.N.P.J."'

cQuery := "SELECT DISTINCT A4_NOME, A4_CGC "
cQuery += "  FROM " + RetSQLName( "SD2" ) + " SD2 "
cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL = '" + xFilial( "SB1" ) + "' AND B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SA1" ) + " SA1 ON A1_FILIAL = '" + xFilial( "SB1" ) + "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SD2.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SZ2" ) + " SZ2 ON Z2_FILIAL = '" + xFilial( "SZ2" ) + "' AND Z2_COD = B1_EMB AND SZ2.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SF2" ) + " SF2 ON F2_FILIAL = '" + xFilial( "SF2" ) + "' AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND SF2.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SA4" ) + " SA4 ON A4_FILIAL = '" + xFilial( "SA4" ) + "' AND A4_COD = F2_TRANSP AND SA4.D_E_L_E_T_ = ' ' "
cQuery += " WHERE D2_FILIAL                 = '" + xFilial( "SD2" ) + "' "
cQuery += "   AND SUBSTR( D2_EMISSAO, 1, 4) = '" + cAnoRef + "' "
cQuery += "   AND B1_COMDEC                 = 'S' "
cQuery += "   AND SD2.D_E_L_E_T_            = ' ' "
cQuery += " ORDER BY A4_NOME "
If Select( "TMP_COM" ) > 0
	TMP_COM->( dbCloseArea() )
Endif
dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_COM", .T., .F. )
TMP_COM->( dbGoTop() )
TMP_COM->( dbEval( { || nCount++ } ) )
TMP_COM->( dbGoTop() )

If Empty( nCount )
	TMP_COM->( dbCloseArea() )
	MsgStop( "Nใo existem registros para o relat๓rio. Verifique!" )
	RestArea( aAreaAtu )
	Return
Endif

ProcRegua( nCount )

u_AcaLogx( cArqExcel, "Rela็ใo das Transportadoras - Movimento de " + cAnoRef )
u_AcaLogx( cArqExcel, cLinha )

While TMP_COM->( !Eof() )
	
	IncProc( "Gerando Relat๓rio" )
	
	cLinha := 	'=("' + TMP_COM->A4_NOME + '");' +;
	'=("' + TMP_COM->A4_CGC + '")'
	
	u_AcaLogx( cArqExcel, cLinha )
	
	TMP_COM->( dbSkip() )
End

TMP_COM->( dbCloseArea() )

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(cArqExcel)
oExcelApp:SetVisible(.T.)

RestArea( aAreaAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  07/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MDENIT

Local nOpcA       := 0
Local aSays       := {}
Local aButtons    := {}
Local cCadastro   := "DENIT"
Local cPerg       := "MDENIT"
Local aPergs := {}

aAdd( aPergs, { "Ano Referencia          ?","                         ","                         ","mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Pergunte( cPerg, .F.)

aAdd( aSays, "Essa rotina gera relat๓rio DENIT" )
aAdd( aSays, "Especifico - "+SM0->M0_NOMECOM )

aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T.) } } )
aAdd( aButtons, { 1, .T., { || ( FechaBatch(), nOpcA := 1 ) } } )
aAdd( aButtons, { 2, .T., { || FechaBatch() } } )
FormBatch( cCadastro, aSays, aButtons )

If nOpcA == 1
	Processa( { || MDENITProc( mv_par01 ) }, "Gerando Relat๓rio..." )
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  07/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MDENITProc( cAnoRef )

Local aAreaAtu := GetArea()

Local cQuery	:= ""
Local nCount	:= 0

Local cArqExcel := "C:\TEMP\MAPAS\"+CriaTrab(Nil,.F.)+".CSV"

Local cLinha	:= '"MUNICอPIO DE ORIGEM";"UF";"MUNICอPIO DE DESTINO";"UF2";"PRINCIPAIS RODOVIAS DO PERCURSO (SIGLA)";"TON/ANO";"INC. EXC."'
Local cDet  	:= ''

Local cQuebra   := ""

cQuery := "SELECT B1_DESC, B1__CODONU, B1_CLARIS, A1_MUN, A1_EST, A1_ROTAPRI, SUM( D2_QUANT/1000 ) D2_QUANT, ' ' INCEXC "
cQuery += "  FROM " + RetSQLName( "SD2" ) + " SD2 "
cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL = '" + xFilial( "SB1" ) + "' AND B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SA1" ) + " SA1 ON A1_FILIAL = '" + xFilial( "SB1" ) + "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SD2.D_E_L_E_T_ = ' ' "
cQuery += " WHERE D2_FILIAL                 = '" + xFilial( "SD2" ) + "' "
cQuery += "   AND SUBSTR( D2_EMISSAO, 1, 4) = '" + cAnoRef + "' "
cQuery += "   AND B1_DENIT                  = 'S' "
cQuery += "   AND SD2.D_E_L_E_T_            = ' ' "
cQuery += " GROUP BY B1_DESC, B1__CODONU, B1_CLARIS, A1_MUN, A1_EST, A1_ROTAPRI "
cQuery += " ORDER BY B1_DESC, A1_MUN, A1_EST "

If Select( "TMP_COM" ) > 0
	TMP_COM->( dbCloseArea() )
Endif
dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_COM", .T., .F. )
TMP_COM->( dbGoTop() )
TMP_COM->( dbEval( { || nCount++ } ) )
TMP_COM->( dbGoTop() )

If Empty( nCount )
	TMP_COM->( dbCloseArea() )
	MsgStop( "Nใo existem registros para o relat๓rio. Verifique!" )
	RestArea( aAreaAtu )
	Return
Endif

ProcRegua( nCount )

u_AcaLogx( cArqExcel, "MINISTษRIO DOS TRANSPORTES" )
u_AcaLogx( cArqExcel, "Departamento Nacional de Infra-estrutura de Transportes" )
u_AcaLogx( cArqExcel, "Coleta Anual de Dados " + cAnoRef )
u_AcaLogx( cArqExcel, "Transporte de Produtos Perigosos" )

While TMP_COM->( !Eof() )
	
	cQuebra := TMP_COM->B1_DESC
	
	u_AcaLogx( cArqExcel, "" )
	u_AcaLogx( cArqExcel, '"EXPEDIDOR:";"'+SM0->M0_NOMECOM+'";"";"";"";"DATA:";"' + Dtoc( dDataBase ) + '"' )
	u_AcaLogx( cArqExcel, '"CNPJ:";"45.725.009/00005-21";"LOCAL:";"AV. PRESIDENTE JUSCELINO, 570 - PIRAPORINHA - DIADEMA - SP";"";"";""' )
	u_AcaLogx( cArqExcel, '"PRODUTO";"' + AllTrim( cQuebra ) + '";"No. ONU:";"' + TMP_COM->B1__CODONU + '";"CLASSE RISCO";"' + TMP_COM->B1_CLARIS + '";""')
	u_AcaLogx( cArqExcel, "" )
	u_AcaLogx( cArqExcel, cLinha )
	
	While TMP_COM->( !Eof() ) .and. TMP_COM->B1_DESC == cQuebra
		
		IncProc( "Gerando Relat๓rio" )
		
		cDet   := 	'=("DIADEMA");' +;
		'=("SP");' +;
		'=("' + TMP_COM->A1_MUN + '");' +;
		'=("' + TMP_COM->A1_EST + '");' +;
		'=("' + TMP_COM->A1_ROTAPRI + '");' +;
		'=("' + TransForm( TMP_COM->D2_QUANT, "@E 99999999.99" ) + '");' +;
		'=(" ")'
		
		u_AcaLogx( cArqExcel, cDet )
		TMP_COM->( dbSkip() )
	End
	
End

TMP_COM->( dbCloseArea() )

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(cArqExcel)
oExcelApp:SetVisible(.T.)

RestArea( aAreaAtu )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  07/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MIBAMA

Local nOpcA       := 0
Local aSays       := {}
Local aButtons    := {}
Local cCadastro   := "IBAMA"
Local cPerg       := "MIBAMA"
Local aPergs := {}

aAdd( aPergs, { "Ano Referencia          ?","                         ","                         ","mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Pergunte( cPerg, .F.)

aAdd( aSays, "Essa rotina gera relat๓rio IBAMA" )
aAdd( aSays, "Especifico - "+SM0->M0_NOMECOM )

aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T.) } } )
aAdd( aButtons, { 1, .T., { || ( FechaBatch(), nOpcA := 1 ) } } )
aAdd( aButtons, { 2, .T., { || FechaBatch() } } )
FormBatch( cCadastro, aSays, aButtons )

If nOpcA == 1
	Processa( { || MIBAMAProc( mv_par01 ) }, "Gerando Relat๓rio..." )
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  07/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MIBAMAProc( cAnoRef )

Local aAreaAtu := GetArea()

Local cQuery	:= ""
Local nCount	:= 0

Local cArqExcel := "C:\TEMP\MAPAS\"+CriaTrab(Nil,.F.)+".CSV"

Local cLinha	:= '"Descri็ใo";"Status"'
Local cDet  	:= ''

if !existDir("C:\TEMP")
	makeDir("C:\TEMP")
endif

if !existDir("C:\TEMP\MAPAS")
	makeDir("C:\TEMP\MAPAS")	
endif

cQuery := "SELECT SUBSTR( B1_DESC, 1, INSTR( B1_DESC, '-' ) - 1 ) DESCRICAO,
cQuery += "       Z1_DESC,
cQuery += "       SUM( D2_QUANT ) D2_QUANT,
cQuery += "       B1_UM,
cQuery += "       B1_TPARM ARMAZEN,
cQuery += "       CASE WHEN B1_NACION = '0' THEN 'NACIONAL' ELSE 'IMPORTADO' END NAC,
cQuery += "       'TERCEIRO' ORIGEM,
cQuery += "       'NAO' MONTREAL
cQuery += "  FROM " + RetSQLName( "SD2" ) + " SD2 "
cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL = '" + xFilial( "SB1" ) + "' AND B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SZ1" ) + " SZ1 ON Z1_FILIAL = '" + xFilial( "SZ1" ) + "' AND Z1_COD = B1_FAM AND SZ1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SA1" ) + " SA1 ON A1_FILIAL = '" + xFilial( "SB1" ) + "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SD2.D_E_L_E_T_ = ' ' "
cQuery += " WHERE D2_FILIAL                 = '" + xFilial( "SD2" ) + "' "
cQuery += "   AND SUBSTR( D2_EMISSAO, 1, 4) = '" + cAnoRef + "' "
cQuery += "   AND B1_IBAMA                  = 'S' "
cQuery += "   AND SD2.D_E_L_E_T_            = ' ' "
cQuery += " GROUP BY SUBSTR( B1_DESC, 1, INSTR( B1_DESC, '-' ) - 1 ), Z1_DESC, B1_UM, B1_TPARM, B1_NACION"
cQuery += " ORDER BY DESCRICAO "
If Select( "TMP_COM" ) > 0
	TMP_COM->( dbCloseArea() )
Endif
dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_COM", .T., .F. )
TMP_COM->( dbGoTop() )
TMP_COM->( dbEval( { || nCount++ } ) )
TMP_COM->( dbGoTop() )

If Empty( nCount )
	TMP_COM->( dbCloseArea() )
	MsgStop( "Nใo existem registros para o relat๓rio. Verifique!" )
	RestArea( aAreaAtu )
	Return
Endif

ProcRegua( nCount )

u_AcaLogx( cArqExcel, "RELATORIO ANUAL DE ATIVIDADES IBAMA -  EXERCICIO " + cAnoRef )
u_AcaLogx( cArqExcel, "" )
u_AcaLogx( cArqExcel, "COMERCIANTE DE PRODUTOS QUอMICOS PERIGOSOS E COMBUSTอVEIS:"  )

While TMP_COM->( !Eof() )
	
	IncProc( "Gerando Relat๓rio" )
	
	u_AcaLogx( cArqExcel, cLinha )
	
	cDet   := 	'=("Produto comercializado  :    ");' +;
	'=("' + TMP_COM->DESCRICAO + '")'
	u_AcaLogx( cArqExcel, cDet )
	
	cDet   := 	'=("Aplica็ใo:");' +;
	'=("' + Z1_DESC + '")'
	u_AcaLogx( cArqExcel, cDet )
	
	cDet   := 	'=("Quantidade comercializada no Ano : ");' +;
	'=("' + TransForm( TMP_COM->D2_QUANT, "@E 99999999.99" ) + '")'
	u_AcaLogx( cArqExcel, cDet )
	
	cDet   := 	'=("Unidade de Medida : ");' +;
	'=("' + TMP_COM->B1_UM + '")'
	u_AcaLogx( cArqExcel, cDet )
	
	If TMP_COM->ARMAZEN == "1"
		cDet   := 	'=("Tipo de Armazenamento (c้u aberto/แrea coberta/tanques):");' +;
		'=("c้u aberto")'
	ElseIf TMP_COM->ARMAZEN == "2"
		cDet   := 	'=("Tipo de Armazenamento (c้u aberto/แrea coberta/tanques):");' +;
		'=("แrea coberta")'
	Else
		cDet   := 	'=("Tipo de Armazenamento (c้u aberto/แrea coberta/tanques):");' +;
		'=("tanques")'
	Endif
	u_AcaLogx( cArqExcel, cDet )
	
	cDet   := 	'=("Proced๊ncia do produto (nac/imp): ");' +;
	'=("' + TMP_COM->NAC + '")'
	u_AcaLogx( cArqExcel, cDet )
	
	cDet   := 	'=("Origem do Produto (pr๓pria/terceiros): ");' +;
	'=("' + TMP_COM->ORIGEM + '")'
	u_AcaLogx( cArqExcel, cDet )
	
	cDet   := 	'=("Produto sujeito เ Legisla็ใo ambiental e/ou conven็ใo especํfica (Protocolo de Montreal) ?");' +;
	'=("' + TMP_COM->MONTREAL + '")'
	u_AcaLogx( cArqExcel, cDet )
	
	u_AcaLogx( cArqExcel, "" )
	
	TMP_COM->( dbSkip() )
	
End

TMP_COM->( dbCloseArea() )

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(cArqExcel)
oExcelApp:SetVisible(.T.)

RestArea( aAreaAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  07/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MPCTRAN

Local nOpcA       := 0
Local aSays       := {}
Local aButtons    := {}
Local cCadastro   := "MAPA TRIMESTRAL DE TRANSPORTES"
Local cPerg       := "MPCTRAN"
Local aPergs := {}

aAdd( aPergs, { "Data Inicial            ?","                         ","                         ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd( aPergs, { "Data Final              ?","                         ","                         ","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Pergunte( cPerg, .F.)

aAdd( aSays, "Essa rotina gera MAPA TRIMESTRAL DE TRANSPORTES Policia Civil em Excel" )
aAdd( aSays, "Especifico - "+SM0->M0_NOMECOM )

aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T.) } } )
aAdd( aButtons, { 1, .T., { || ( FechaBatch(), nOpcA := 1 ) } } )
aAdd( aButtons, { 2, .T., { || FechaBatch() } } )
FormBatch( cCadastro, aSays, aButtons )

If nOpcA == 1
	Processa( { || MPCTRANProc( mv_par01, mv_par02 ) }, "Gerando Relat๓rio..." )
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  07/14/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MPCTRANProc( dDataIni, dDataFim )

Local aAreaAtu := GetArea()

Local cQuery	:= ""
Local nCount	:= 0

Local cArqExcel := "C:\TEMP\MAPAS\"+CriaTrab(Nil,.F.)+".CSV"
Local cLinha	:= '"NOME DO PRODUTO";"NOME DO EMBARCADOR";"ENDEREวO DO EMBARCADOR";"NOME DO DESTINATมRIO";"ENDEREวO DO DESTINมTARIO";"BAIRRO DO DESTINมTARIO";"MUNICIPIO DO DESTINATมRIO";"UF DO DESTINATมRIO"'

cQuery += "SELECT B1_DESC,  A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST "
cQuery += "  FROM " + RetSQLName( "SD2" ) + " SD2 "
cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL = '" + xFilial( "SB1" ) + "' AND B1_COD = D2_COD AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "  JOIN " + RetSQLName( "SA1" ) + " SA1 ON A1_FILIAL = '" + xFilial( "SA1" ) + "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SA1.D_E_L_E_T_ = ' ' "
cQuery += " WHERE D2_FILIAL  = '" + xFilial( "SD2" ) + "' "
cQuery += "   AND D2_EMISSAO BETWEEN '" + DtoS( dDataIni ) + "' AND '" + DtoS( dDataFim ) + "' "
cQuery += "   AND B1_POLCIV  = 'S' "
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY B1_DESC,  A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST "
cQuery += " ORDER BY B1_DESC "

If Select( "TMP_TRA" ) > 0
	TMP_TRA->( dbCloseArea() )
Endif
dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_TRA", .T., .F. )
TMP_TRA->( dbGoTop() )
TMP_TRA->( dbEval( { || nCount++ } ) )
TMP_TRA->( dbGoTop() )

If Empty( nCount )
	TMP_TRA->( dbCloseArea() )
	MsgStop( "Nใo existem registros para o relat๓rio. Verifique!" )
	RestArea( aAreaAtu )
	Return
Endif

ProcRegua( nCount )

u_AcaLogx( cArqExcel, "MAPA TRIMESTRAL DE TRANSPORTES POLICIA CIVIL - " + DtoC( dDataIni ) + " - " + DtoC( dDataFim ) )
u_AcaLogx( cArqExcel, cLinha )

While TMP_TRA->( !Eof() )
	
	IncProc( "Gerando Relat๓rio" )
	
	cLinha := 	'=("' + SubStr( TMP_TRA->B1_DESC, 1, At( " - ", TMP_TRA->B1_DESC ) - 1 ) + '");' +;
	'=("'+SM0->M0_NOMECOM+'");' +;
	'=("AV.PRES.JUSCELINO,570 - DIADEMA - SP - CEP:09950-370");' +;
	'=("' + TMP_TRA->A1_NOME + '");' +;
	'=("' + TMP_TRA->A1_END + '");' +;
	'=("' + TMP_TRA->A1_BAIRRO + '");' +;
	'=("' + TMP_TRA->A1_MUN + '");' +;
	'=("' + TMP_TRA->A1_EST + '")'
	
	u_AcaLogx( cArqExcel, cLinha )
	
	TMP_TRA->( dbSkip() )
End

TMP_TRA->( dbCloseArea() )

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(cArqExcel)
oExcelApp:SetVisible(.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  04/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AEST900

AxCadastro( "ZAA", "Cadastro Incompatibilidade ONU", Nil, "U_AEST900Vld()" )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  04/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AEST900Vld

Local aAreaAtu := GetArea()

If M->ZAA_ONU1 == M->ZAA_ONU2
	MsgStop( "C๓digo 1 igual a Codigo 2" )
	Return .F.
Endif

ZAA->( dbSetOrder( 1 ) )
If ZAA->( dbSeek( xFilial( "ZAA" ) + M->( ZAA_ONU1 + ZAA_ONU2 ) ) )
	MsgStop( "Registro jแ Cadastrado" )
	Return .F.
Endif

If ZAA->( dbSeek( xFilial( "ZAA" ) + M->( ZAA_ONU2 + ZAA_ONU1 ) ) )
	MsgStop( "Registro jแ Cadastrado" )
	Return .F.
Endif


ZAA->( dbSetOrder( 2 ) )
If ZAA->( dbSeek( xFilial( "ZAA" ) + M->( ZAA_ONU1 + ZAA_ONU2 ) ) )
	MsgStop( "Registro jแ Cadastrado" )
	Return .F.
Endif

If ZAA->( dbSeek( xFilial( "ZAA" ) + M->( ZAA_ONU2 + ZAA_ONU1 ) ) )
	MsgStop( "Registro jแ Cadastrado" )
	Return .F.
Endif

RestArea( aAreaAtu )

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  04/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function OM200OK

Local aAreaAtu := GetArea()

Local aArrayMan 	:= ParamIXB[1]
Local aArrayCarga	:= ParamIXB[2]
Local nPosCarga		:= ParamIXB[3]

Local cTexto    	:= ""
Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"

Local cPedidos		:= ""
Local cQuery		:= ""

Local cONU1			:= ""
Local cONU2			:= ""

Local cLinha1		:= ""
Local cLinha2		:= ""

Local lRet      := .F.

TRBPED->( dbGoTop() )
While TRBPED->( !Eof() )
	If !Empty( TRBPED->PED_MARCA )
		cPedidos += TRBPED->PED_PEDIDO+TRBPED->PED_ITEM + "','"
	Endif
	TRBPED->( dbSkip() )
End

If !Empty( cPedidos )
	
	cQuery := "SELECT * "
	cQuery += "  FROM " + RetSQLName( "SC9" )
	cQuery += " WHERE C9_FILIAL  = '" + xFilial( "SC9" ) + "' "
	cQuery += "   AND C9_PEDIDO||C9_ITEM IN ('" + cPedidos + "') "
	cQuery += "   AND C9_CARGA   = ' ' "
	cQuery += "   AND C9_NFISCAL = ' ' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cQuery += "	ORDER BY C9_PEDIDO "
	If Select( "TMP_SC9" ) > 0
		TMP_SC9->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SC9", .T., .F. )
	While TMP_SC9->( !Eof() )
		
		cONU1 	:= Posicione( "SB1", 1, xFilial( "SB1" ) + TMP_SC9->C9_PRODUTO, "B1__CODONU" )
		cLinha1 := Posicione( "SB1", 1, xFilial( "SB1" ) + TMP_SC9->C9_PRODUTO, "B1_SEGMENT" )
		
		cQuery := "SELECT * "
		cQuery += "  FROM " + RetSQLName( "SC9" )
		cQuery += " WHERE C9_FILIAL  = '" + xFilial( "SC9" ) + "' "
		cQuery += "   AND C9_PEDIDO||C9_ITEM  IN ('" + cPedidos + "') "
		cQuery += "   AND C9_CARGA    = ' ' "
		cQuery += "   AND C9_NFISCAL  = ' ' "
		cQuery += "   AND D_E_L_E_T_  = ' ' "
		cQuery += "   AND R_E_C_N_O_ != " + AllTrim( Str( TMP_SC9->R_E_C_N_O_ ) )
		cQuery += "	ORDER BY C9_PEDIDO "
		If Select( "TMP_COMP" ) > 0
			TMP_COMP->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_COMP", .T., .F. )
		While TMP_COMP->( !Eof() )
			
			cONU2 	:= Posicione( "SB1", 1, xFilial( "SB1" ) + TMP_COMP->C9_PRODUTO, "B1__CODONU" )
			cLinha2 := Posicione( "SB1", 1, xFilial( "SB1" ) + TMP_COMP->C9_PRODUTO, "B1_SEGMENT" )
			
			If cLinha1 $ "000005|000006|000007" .and. !Empty( cONU2 ) .and. cLinha1 <> cLinha2
				cTexto += "Pedido: " + TMP_SC9->C9_PEDIDO + " Produto: " + TMP_SC9->C9_PRODUTO + " Incompativel Com Pedido: " + TMP_COMP->C9_PEDIDO + " Produto: " + TMP_COMP->C9_PRODUTO + Chr( 13 ) + Chr( 10 )
				TMP_COMP->( dbSkip() )
				Loop
			Endif
			
			If cLinha2 $ "000005|000006|000007" .and. !Empty( cONU1 ) .and. cLinha1 <> cLinha2
				cTexto += "Pedido: " + TMP_SC9->C9_PEDIDO + " Produto: " + TMP_SC9->C9_PRODUTO + " Incompativel Com Pedido: " + TMP_COMP->C9_PEDIDO + " Produto: " + TMP_COMP->C9_PRODUTO + Chr( 13 ) + Chr( 10 )
				TMP_COMP->( dbSkip() )
				Loop
			Endif
			
			ZAA->( dbSetOrder( 1 ) )
			If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU1 + cONU2 ) )
				cTexto += "Pedido: " + TMP_SC9->C9_PEDIDO + " Produto: " + TMP_SC9->C9_PRODUTO + " Incompativel Com Pedido: " + TMP_COMP->C9_PEDIDO + " Produto: " + TMP_COMP->C9_PRODUTO + Chr( 13 ) + Chr( 10 )
				TMP_COMP->( dbSkip() )
				Loop
			Endif
			
			If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU2 + cONU1 ) )
				cTexto += "Pedido: " + TMP_SC9->C9_PEDIDO + " Produto: " + TMP_SC9->C9_PRODUTO + " Incompativel Com Pedido: " + TMP_COMP->C9_PEDIDO + " Produto: " + TMP_COMP->C9_PRODUTO + Chr( 13 ) + Chr( 10 )
				TMP_COMP->( dbSkip() )
				Loop
			Endif
			
			ZAA->( dbSetOrder( 2 ) )
			If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU1 + cONU2 ) )
				cTexto += "Pedido: " + TMP_SC9->C9_PEDIDO + " Produto: " + TMP_SC9->C9_PRODUTO + " Incompativel Com Pedido: " + TMP_COMP->C9_PEDIDO + " Produto: " + TMP_COMP->C9_PRODUTO + Chr( 13 ) + Chr( 10 )
				TMP_COMP->( dbSkip() )
				Loop
			Endif
			
			If ZAA->( dbSeek( xFilial( "ZAA" ) + cONU2 + cONU1 ) )
				cTexto += "Pedido: " + TMP_SC9->C9_PEDIDO + " Produto: " + TMP_SC9->C9_PRODUTO + " Incompativel Com Pedido: " + TMP_COMP->C9_PEDIDO + " Produto: " + TMP_COMP->C9_PRODUTO + Chr( 13 ) + Chr( 10 )
				TMP_COMP->( dbSkip() )
				Loop
			Endif
			
			TMP_COMP->( dbSkip() )
		End
		TMP_COMP->( dbCloseArea() )
		
		TMP_SC9->( dbSkip() )
	End
	TMP_SC9->( dbCloseArea() )
	
Endif

If !Empty( cTexto )
	cTexto := "Incompatibilidade de Codigos ONU"+CHR(13)+CHR(10)+cTexto
	__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
	Define Font oFont Name "Mono AS" Size 5,12
	Define MsDialog oDlg Title "Incompatibilidade" From 3,0 To 340,417 Pixel
	@ 5,5 Get oMemo Var cTexto MEMO Size 200,145 Of oDlg Pixel
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont
	Define sButton From 153,175 Type 1 Action oDlg:End() Enable Of oDlg Pixel
	Define sButton From 153,145 Type 13 Action (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) Enable Of oDlg Pixel
	Activate MsDialog oDlg Center
Else
	APMsgInfo( "Nใo existem problemas de Incompatibilidade")
Endif

RestArea( aAreaAtu )

lRet := Empty(cTexto)  // Valida็ใo anterior
//lRet := U_GetFrInf() .And. lRet  // Valida็ใo adicionada

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  04/13/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DL200BRW

Local aRet := aClone( ParamIXB )

aAdd( aRet, { "PED_COMP", Nil , "Compartimento" } )

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  04/13/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DL200TRB

Local aRet := aClone( ParamIXB )

aAdd( aRet, { "PED_COMP", "N" , 1, 0 } )

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCFGXFUN  บAutor  ณMicrosiga           บ Data ณ  04/13/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MGRVCOMP

Local nCompart := 0

If Empty( PED_MARCA )
	MsgStop( "O Pedido Nใo Estแ Selecionado. Selecione o Pedido!" )
	Return
Endif

If MsgGet2("Compartimento", "Informe o Compartimento:", @nCompart, Nil, {|| nCompart >= 0 .and. nCompart <= 6 } )
	RecLock( "TRBPED", .F. )
	TRBPED->PED_COMP := nCompart
	TRBPED->( MsUnLock() )
Endif

Return


user Function AcaLogx( cArquivo, cTexto )
Local nHdl   := 0

If !File(cArquivo)
	nHdl := FCreate(cArquivo)
Else
	nHdl := FOpen(cArquivo, FO_READWRITE)
Endif

FSeek(nHdl,0,FS_END)
cTexto += Chr(13)+Chr(10)
FWrite(nHdl, cTexto, Len(cTexto))
FClose(nHdl)

Return