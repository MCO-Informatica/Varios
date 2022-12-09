#include "protheus.ch"
#include 'fileio.ch'

#define X_POS_ATT 		2
#define X_POS_DIRMAIL	3
#define X_POS_JOB		4
#define X_POS_DIRANEXO	5

/*
-------------------------------------------------------------------------------
| Rotina     | CTSDKSVA   | Autor | Gustavo Prudente     | Data | 20.05.2015  |
|-----------------------------------------------------------------------------|
| Descricao  | Realiza cache das informacoes (nTipo=1) e gravacao dos anexos  |
|            | (nTipo=2) do workflow enviado pelo Protheus - Service-Desk     |
|-----------------------------------------------------------------------------|
| Parametros | EXPN1 - Tipo de utilizacao da rotina:                          |
|            |         1 - Realiza cache das informacoes do workflow do       |
|            |             atendimento da thread atualmente em processamento; |
|            |         2 - Efetiva a gravacao dos anexos antes do envio do    |
|            |             workflow do atendimento.                           |
|            | EXPC2 - Codigo do atendimento gerado no Service-Desk           |
|            | EXPC3 - String com o nome dos arquivos anexos                  |
|            | EXPC4 - Pasta de leitura dos arquivos                          |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
User Function CTSDKSVA( nTipo, cCodSDK, cAtt, cDirMail, lJob, cDirFile )
                     
Static aInfoSVA := {}

Local aAnexo	:= {}
Local nPosPath	:= 0           
Local nI		:= 0         
Local nThread	:= 0

// Variaveis de tratamento de path de arquivo
Local cDrive  	:= ""
Local cPath	  	:= ""
Local cFile	  	:= ""
Local cExtent 	:= ""                
Local cLastHtml := ""
Local cDirAnexo := ""

Default lJob    := .T.
             
// Armazena informacoes dos anexos do atendimento atualmente
// processado na thread de chamada da CTSDK12
If nTipo == 1
                      
	nThread := ThreadId()
                                             
 	If AScan( aInfoSVA, { |x| x[ 1 ] == nThread } ) == 0
		AAdd( aInfoSVA, { nThread, cAtt, cDirMail, lJob, cDirFile } ) 
	EndIf

ElseIf nTipo == 2       

    nThread := ThreadId()
	nPosThread := AScan( aInfoSVA, { |x| x[ 1 ] == nThread } )
    
	If nPosThread > 0
		
		cAtt 	  := aInfoSVA[ nPosThread, X_POS_ATT ]
		cDirMail  := aInfoSVA[ nPosThread, X_POS_DIRMAIL ]
		lJob	  := aInfoSVA[ nPosThread, X_POS_JOB ]                    
		cDirAnexo := aInfoSVA[ nPosThread, X_POS_DIRANEXO ]                    
		
		aAnexo 	  := StrToKArr( cAtt, ";" )
		cLastHtml := ""
		
		For nI := 1 to Len( aAnexo )
			AnexarBco( aAnexo[ nI ], cCodSDk, cDirAnexo )
		Next nI
		/*
		For nI := 1 to Len( aAnexo )
			
			SplitPath( aAnexo[ nI ], @cDrive, @cPath, @cFile, @cExtent )
			
			nPosPath := At( cDirMail, cPath )
			
			If nPosPath > 0
				cPath := SubStr( cPath, nPosPath )
			EndIf
		                       
			SvArqSdk( cFile + cExtent, cPath + cFile + cExtent, cCodSDk, lJob, @cLastHtml )
			
		Next nI
		*/
		
		
		ADel(  aInfoSVA, nPosThread )
		ASize( aInfoSVA, Len( aInfoSVA ) - 1 )

	EndIf
			        
EndIf

Return .T. 


/*           
----------------------------------------------------------------------------
| Rotina    | SvArqSdk     | Autor | Gustavo / Opvs   | Data | 20.05.2015  |
|--------------------------------------------------------------------------|
| Descricao | Grava os arquivos anexos no banco de conhecimento            |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function SvArqSdk( cAnexo, cFileName, cCodSDk, lJob, cLastHtml )

Local aArea		:= GetArea()
Local cDirDoc	:= MsDocPath()
Local cRootPath	:= GetSrvProfString( "RootPath","" )
Local cFile		:= ""
Local nCount	:= 0
      
Local cLastHtml  := ""
Local cName	:= ''
Local nVersao := 0

DbSelectArea("ACB")
DbSetOrder(2) 

BeginSql Alias "TRBADF"
	SELECT 
		MAX( ADF_ITEM ) ADF_ITEM
	FROM 
		%Table:ADF%
	WHERE 
		ADF_FILIAL = %xFilial:ADF%
		AND ADF_CODIGO = %Exp:cCodSDk%
		AND %notdel%					
EndSql

cName := Alltrim( NoAcento( AnsiToOem( cAnexo ) ) )
nVersao := ValidVersao( cCodSDk, cName )

cFile := Alltrim( cCodSDk ) + Alltrim( TRBADF->ADF_ITEM ) + "_" +;
		 STUFF( cName, RAT( ".", cName ), 0, "_" + StrZero( nVersao, 3 ) )

//cFile := Alltrim( cCodSDk ) + Alltrim( TRBADF->ADF_ITEM ) + "_" + NoAcento( AnsiToOem( cAnexo ) )	
                                
TRBADF->( DbCloseArea() )

__CopyFile( cFileName, cDirDoc + "\" + cFile )

If Upper( SubStr( cAnexo, Rat( ".", cAnexo ), Len( cAnexo ) ) ) == ".HTML"
	If lJob
		cLastHtml := cDirDoc + "\" + cFile
	Else
		cLastHtml := GetSrvProfString("RootPath","")+cDirDoc + "\" + cFile
	EndIf                                                              
Else
	If !Empty( cLastHtml )
		Carrega_imagem( cLastHtml, Lower( 'src="' + cAnexo + '"' ), Lower( 'src="' + cFile + '"' ) )  	
	Endif                         
Endif
                 
//
// Inclui registro no banco de conhecimento
//
DbSelectArea("ACB")
RecLock("ACB",.T.)
ACB_FILIAL := xFilial("ACB")
ACB_CODOBJ := GetSxeNum("ACB","ACB_CODOBJ")
ACB_OBJETO	:= cFile
ACB_DESCRI	:= cAnexo
MsUnLock()         

ConfirmSx8()
                   
//
// Inclui amarração entre registro do banco e entidade
//
DbSelectArea("AC9")
RecLock("AC9",.T.)
AC9_FILIAL	:= xFilial("AC9")
AC9_FILENT	:= xFilial("ADE")
AC9_ENTIDA	:= "ADE"
AC9_CODENT	:= xFilial("ADE")+cCodSdk
AC9_CODOBJ	:= ACB->ACB_CODOBJ
MsUnLock()         

RestArea( aArea )

Return .T.


/*           
----------------------------------------------------------------------------
| Rotina    | Carrega_imagem | Autor | Gustavo / Opvs | Data | 20.05.2015  |
|--------------------------------------------------------------------------|
| Descricao | Grava arquivo de imagem                                      |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function Carrega_imagem( cLastFilename, cId, cName )

local cArq 		:= ""
Local cHtml		:= ""
Local cLinha	:= ""
local nQtdLinha := 0
local nX		:= 0

cArq		:= MemoRead( cLastFilename )
nQtdLinha	:= MLCount( cArq )

For nX := 1 To nQtdLinha
	cLinha := MemoLine( cArq,, nX )
	If cId $ cLinha
		cLinha := StrTran( cLinha, cId, cName )
	Else
	 	cLinha := cLinha
	EndIf	
	cHtml += cLinha	    
Next nX

MemoWrite( cLastFileName, cHtml )

Return .T.

Static Function ValidVersao( cCodSDk, cName )
	Local cSQL := ''
	Local cTRB := ''
	Local nQTD := 0

	cSQL += "SELECT Count(*) AS NCOUNT " + CRLF
	cSQL += "FROM " + RetSqlName('AC9') + " AC9 " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName('ACB') + " ACB " + CRLF
	cSQL += "               ON ACB_FILIAL = AC9_FILIAL " + CRLF
	cSQL += "                  AND ACB_CODOBJ = AC9_CODOBJ " + CRLF
	cSQL += "                  AND ACB.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "WHERE  AC9.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "       AND AC9_FILIAL = '" + xFilial('AC9') + "' " + CRLF
	cSQL += "       AND AC9_FILENT = '" + xFilial('ADF') + "' " + CRLF
	cSQL += "       AND AC9_ENTIDA = 'ADE' " + CRLF
	cSQL += "       AND AC9_CODENT = '" + xFilial('ADF') + cCodSDk + "' " + CRLF
	cSQL += "       AND ACB_DESCRI = '" + cName + "' " + CRLF

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
	nQTD := (cTRB)->NCOUNT + 1
	
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )

Return( nQTD )

//-----------------------------------------------------------------------
// Rotina | AnexarBco | Autor | Rafael Beghini   | Data | 24.07.2018
//-----------------------------------------------------------------------
// Descr. | Rotina para anexar o documento ao registro de atendimento
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
// Tabelas| AC9 - Relacao de Objetos x Entidades
//          ACB - Bancos de Conhecimentos
//          ACC - Palavras-Chave
//-----------------------------------------------------------------------
Static Function AnexarBco( cArquivo, cCodSDk, cDiretorio )
	Local lRet		:= .T.
	Local cSQL		:= ''
	Local cTRB		:= ''
	Local cFile		:= ''
	Local cExten	:= ''
	Local cObjeto	:= ''
	Local cEntidade	:= 'ADE'
	Local cItem		:= ''
	Local cACB_CODOBJ := ''
	Local cNameOLD  := cArquivo
	Local cDirDocs := MsDocPath()
	
	cSQL += "SELECT MAX( ADF_ITEM ) AS ADF_ITEM FROM " + RetSqlName('ADF') + " ADF " + CRLF
	cSQL += "WHERE ADF.D_E_L_E_T_= ' ' AND ADF_FILIAL = '" + xFilial('ADF') + "' AND " + CRLF
	cSQL += "ADF_CODIGO = '" + cCodSDk + "'"

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cTRB,.F.,.T.)
	cItem := StrZero( Val( (cTRB)->ADF_ITEM ) + 1, 3 )

	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )

	cFile := SubString( cArquivo, RAT( "\", cArquivo ) + 1, Len( cArquivo ) )

	nVersao := Randomize(1,100) //ValidVersao( cCodSDk, cFile )
	cFile := STUFF( cFile, RAT( ".", cFile ), 0, "_" + StrZero( nVersao, 3 ) )
	
	cArquivo := /*cDiretorio +*/ cCodSDk + '_' + cItem + '_' + cFile
	
	__CopyFile( cNameOLD, cDirDocs + "\" + cArquivo )
	lRet := File( cDirDocs + "\" + cArquivo ) 
	
	If lRet 
		SplitPath( cArquivo,,,@cFile, @cExten )
		cObjeto := Left( Upper( cFile + cExten ),Len( cArquivo ) )
		
		cACB_CODOBJ := GetSXENum('ACB','ACB_CODOBJ')
	
		ACB->( RecLock( 'ACB', .T. ) )
		ACB->ACB_FILIAL	:= xFilial( 'ACB' )
		ACB->ACB_CODOBJ	:= cACB_CODOBJ
		ACB->ACB_OBJETO	:= cObjeto
		ACB->ACB_DESCRI	:= cObjeto
		If FindFunction( 'MsMultDir' ) .And. MsMultDir()
			ACB->ACB_PATH	:= MsDocPath( .T. )
		Endif
		ACB->( MsUnLock() )	
		ACB->( ConfirmSX8() )
		
		AC9->( RecLock( 'AC9', .T. ) )
		AC9->AC9_FILIAL	:= xFilial( 'AC9' )
		AC9->AC9_FILENT	:= xFilial( cEntidade )
		AC9->AC9_ENTIDA	:= cEntidade
		AC9->AC9_CODENT	:= xFilial( cEntidade ) + cCodSDk
		AC9->AC9_CODOBJ	:= cACB_CODOBJ
		AC9->AC9_DTGER  := dDataBase
		AC9->( MsUnLock() )
		
		ACC->( RecLock( 'ACC', .T. ) )
		ACC->ACC_FILIAL := xFilial( 'ACC' ) 
		ACC->ACC_CODOBJ := cACB_CODOBJ
		ACC->ACC_KEYWRD := xFilial( cEntidade ) + cCodSDk
		ACC->( MsUnLock() )
	Else
		ConOut('[AnexarBco] - CodSDK: [' + cCodSDk + '], não foi possível anexar no banco de conhecimento.')
	Endif
Return