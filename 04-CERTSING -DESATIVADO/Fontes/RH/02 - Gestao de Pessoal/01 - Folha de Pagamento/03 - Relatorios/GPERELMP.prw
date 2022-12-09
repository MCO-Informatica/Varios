#Include 'Protheus.ch'
#INCLUDE 'FILEIO.CH' 
#include 'topconn.ch'
#Include "MSOle.Ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPERELMP  ºAutor  ³Rafael Beghini - Totvs SM º Data ³ 06/12/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao do relatorio de Movimentacao de Pessoal                 º±±
±±º          ³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Recursos Humanos                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function GPERELMP()

Local nOpc := 0

Private cCadastro := "Integração Protheus com Ms-Word"
Private aSay := {}
Private aButton := {}

aAdd( aSay, "Esta rotina irá imprimir o relatorio de Movimentação de Pessoal conforme parâmetros")
aAdd( aSay, "informados pelo usuário." )
aAdd( aSay, "Utilizado modelo DOT para impressão, verificar o diretório do arquivo e selecioná-lo.")
aAdd( aSay, "")
aAdd( aSay, "Obs.: O arquivo gerado será gravado no mesmo diretório do arquivo modelo .DOT")

aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSay, aButton )

If nOpc == 1
	Processa( {|| ImpWord() }, cCadastro, "Gerando Relatório..." )
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpWord   ºAutor  ³Rafael Beghini - Totvs SM º Data ³ 06/12/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa a impressao.							                    º±±
±±º          ³                                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Recursos Humanos                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpWord()

Local oWord := Nil

Local cFileSave := ""
Local cPICTURE := "@E 99,999,999.99" 

Local aPARAM := {}
Local aRET := {}
Local aCargoAtu := {}
Local aCargoIni := {}
Local aHistorico := {}
Local aTempoEmp := {}
Local aTempFunc := {}

Local aSaida  := {'1-Imprimir','2-Salvar formato DOC','3-Nenhum'}

Local caliasA := GetNextAlias()
Local caliasB := GetNextAlias()

Local pLinha  := chr(13) + chr(10)  

Local cAdmissa  := cAno := cCadastro := cCargo := cCargo1 := cCargoAtu := cCargoIni := cCC := cDCargo := cDCargoIni  :=;
		cDescCC   := cDia := cFil := cFileOpen := cLocal := cMat := cMes := cNome := cQry := cQry1 := cSalario := cSalIni     :=;
		cTempEmp  := cTempFunc := cTpContr := cTpContra := cXForma2 := ''     
		
Local nAnteum   := nConta := nI := nItem := nPorcent := nReajuste := nSaida := nSalario := nSalIni := 0



aAdd( aPARAM, { 1, "Filial: " , Space(2) , ""    , "", "SM0", "" , 0  , .T. }) 
aAdd( aPARAM, { 1, "Matrícula: " , Space(6) , ""    , "", "SRA", "" , 0  , .T. })
aAdd( aPARAM, { 6, "Arquivo Modelo Word", Space(50), ""    , "", ""   , 50 , .T., "Modelo MS-Word |*.dot", /*cMainPath*/ })
aAdd( aPARAM, { 2, "Qual saída"         , 1        , aSaida, 80, ""   , .F.})

If !ParamBox(aPARAM,"Parâmetros",@aRET)
	Return
Endif

cFileOpen := aRET[3]

If !File(cFileOpen)
	MsgInfo("Arquivo não localizado",cCadastro)
	Return
Endif

cFil := aRET[1]
cMat := aRET[2]

dbSelectArea("SRA")
dbSetOrder(1)
If !dbSeek( xFilial("SRA") + cMat )
	MsgInfo("Funcionário não encontrado",cCadastro)
	Return
Endif

nSaida := Iif( ValType( aRET[ 4 ] ) == 'N',aRET[ 4 ], AScan( aSaida, {|e| e==aRET[ 4 ] } ) )


cQry := "SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CC, RA_ADMISSA, RA_CODFUNC, RA_SALARIO, RA_TPCONTR, RA_XFORMA2"+pLinha
cQry += "FROM "+RetSqlName("SRA") + " RA "+pLinha
cQry += "WHERE RA.D_E_L_E_T_ = '' AND RA_DEMISSA = '' "+pLinha
cQry += "AND RA_FILIAL = '"+cFil+"'"+pLinha
cQry += "AND RA_MAT = '"+cMat+"'"+pLinha

cQry := ChangeQuery(cQry)

TCQUERY cQry NEW ALIAS (cAliasA)

dbSelectArea(cAliasA)
If (cAliasA)->(!EoF())
	cNome     := (cAliasA)->RA_NOME
	cCC       := (cAliasA)->RA_CC
	cAdmissa  := (cAliasA)->RA_ADMISSA
	cCargo    := (cAliasA)->RA_CODFUNC
	nSalario  := (cAliasA)->RA_SALARIO
	cTpContra := (cAliasA)->RA_TPCONTR
	cXForma2  := (cAliasA)->RA_XFORMA2
EndIf

cSalario := Transform(nSalario,"@E 999,999.99")

If cFil == "06"
	cLocal := "Rio de Janeiro"
ElseIf cFil == "07"
	cLocal := "São Paulo"
EndIf

If cTpContra == "1"
	cTpContr := "Indeterminado"
Else
	cTpContr := "Determinado"
EndIf	

dbSelectArea("CTT")
dbSetOrder(1)
dbSeek( xFilial("CTT") + cCC )
	cDescCC := CTT->CTT_DESC01

dbSelectArea("SRJ")
dbSetOrder(1)
dbSeek( xFilial("SRJ") + cCargo )
	cDCargo := SRJ->RJ_DESC  
	

cQry1 := "SELECT R7_FILIAL, R7_MAT, R7_DATA, R7_SEQ, R7_TIPO, R7_FUNCAO, R3_VALOR"+pLinha
cQry1 += "FROM "+RetSqlName("SR7") + " R7 "+pLinha

cQry1 += "INNER JOIN "+RetSqlName("SR3") + " R3 "+pLinha
cQry1 += "ON R7_FILIAL = R3_FILIAL AND R7_MAT = R3_MAT AND R7_DATA = R3_DATA AND R7_SEQ = R3_SEQ "+pLinha
cQry1 += "AND R7_TIPO = R3_TIPO AND R3.D_E_L_E_T_ = '' "+pLinha

cQry1 += "WHERE R7.D_E_L_E_T_ = ''"+pLinha
cQry1 += "AND R7_FILIAL = '"+cFil+"'"+pLinha
cQry1 += "AND R7_MAT = '"+cMat+"'"+pLinha

cQry1 += "ORDER BY R7_FILIAL, R7_MAT, R7_DATA, R7_SEQ ASC"

cQry1 := ChangeQuery(cQry1)

TCQUERY cQry1 NEW ALIAS (cAliasB)

dbSelectArea(cAliasB)
If (cAliasB)->(!EoF())
	While (cAliasB)->(!Eof())
		If (cAliasB)->R7_TIPO == "001"
  			nAnteum := (cAliasB)->R3_VALOR
  			nSalIni := nAnteum
  			cCargoIni := (cAliasB)->R7_FUNCAO
  			cCargo1   := cCargoIni
  			aCargoIni := {}
			aAdd(aCargoIni, { cCargo1, StoD((cAliasB)->R7_DATA) } ) 
  		Else                    
  			  		
  			nItem++	
  			nReajuste := (cAliasB)->R3_VALOR - nAnteum
  			cCargoIni := (cAliasB)->R7_FUNCAO
  			nConta    := (nReajuste / nAnteum) * 100
  			nPorcent  := IIF(nConta < 100, STRZERO(nConta,2), STRZERO(nConta,3))
			
			aAdd( aHistorico, {	nItem, StoD((cAliasB)->R7_DATA), LTrim(TransForm(nAnteum,cPICTURE)), LTrim(TransForm(nReajuste,cPICTURE)),;
									   nPorcent, LTrim(TransForm((cAliasB)->R3_VALOR,cPICTURE)),; 
									   Posicione("SX5",1,xFilial("SX5")+"41"+(cAliasB)->R7_TIPO,"X5_DESCRI"),;
									   Posicione("SRJ",1,xFilial("SRJ")+cCargoIni,"RJ_DESC")})  
									   
			nAnteum := (cAliasB)->R3_VALOR
			
			If cCargo1 != (cAliasB)->R7_FUNCAO
				cCargoAtu := (cAliasB)->R7_FUNCAO
				aCargoAtu := {}
				aAdd(aCargoAtu, { cCargoAtu, StoD((cAliasB)->R7_DATA) } ) 
			EndIf
			cCargo1 := cCargoIni
			nConta := 0
			nPorcent := 0
			
  		EndIf
  		cCargoIni := ""
  	(cAliasB)->(dbSkip())
  	End
EndIf


If Len( aHistorico ) == 0

	cSalIni    := Transform(nSalario,"@E 999,999.99")
	cCargoIni  := cCargo
	cDCargoIni := Posicione("SRJ",1,xFilial("SRJ")+cCargoIni,"RJ_DESC")

	aTempoEmp := DateDiffYMD(date(), Stod(cAdmissa)) 

	If !Empty(aTempoEmp[1])
		cAno := Alltrim(STR(aTempoEmp[1])) + " Ano (s), " 
	EndIf

	If !Empty(aTempoEmp[2])
		cMes := Alltrim(STR(aTempoEmp[2])) + " Mês (s), " 
	EndIf

	If !Empty(aTempoEmp[3])
		cDia := Alltrim(STR(aTempoEmp[3])) + " Dia (s)." 
	EndIf

	cTempEmp := cAno+cMes+cDia

	cTempFunc := cTempEmp

Else
    
	cSalIni    := Transform(nSalIni,"@E 999,999.99")
	If  !Empty(aCargoIni)
		cCargoIni  := aCargoIni[1][1]
	EndIf
	cDCargoIni := Posicione("SRJ",1,xFilial("SRJ")+cCargoIni,"RJ_DESC")

	aTempoEmp := DateDiffYMD(date(), Stod(cAdmissa)) 

	If !Empty(aTempoEmp[1])
		cAno := Alltrim(STR(aTempoEmp[1])) + " Ano (s), " 
	EndIf

	If !Empty(aTempoEmp[2])
		cMes := Alltrim(STR(aTempoEmp[2])) + " Mês (s), " 
	EndIf

	If !Empty(aTempoEmp[3])
		cDia := Alltrim(STR(aTempoEmp[3])) + " Dia (s)." 
	EndIf

	cTempEmp := cAno+cMes+cDia
	
	cAno := ""
	cMes := ""
	cDia := ""

	If Empty(aCargoAtu)
		aTempFunc := DateDiffYMD(date(), aCargoIni[1][2])
	Else
		aTempFunc := DateDiffYMD(date(), aCargoAtu[1][2])
	EndIf	

	If !Empty(aTempFunc[1])
   		cAno := Alltrim(STR(aTempFunc[1])) + " Ano (s), " 
	EndIf

	If !Empty(aTempFunc[2])
		cMes := Alltrim(STR(aTempFunc[2])) + " Mês (s), " 
	EndIf

	If !Empty(aTempFunc[3])
		cDia := Alltrim(STR(aTempFunc[3])) + " Dia (s)." 
	EndIf

	cTempFunc := cAno+cMes+cDia

	cAno := ""
	cMes := ""
	cDia := "" 

EndIf              

If nSaida <> 3
	// Criar o link do Protheus com o Word.
	oWord := OLE_CreateLink()

	// Cria um novo baseado no modelo.
	OLE_NewFile( oWord, cFileOpen )

	// Exibe ou oculta a janela da aplicacao Word no momento em que estiver descarregando os valores.
	OLE_SetProperty( oWord, oleWdVisible, .F. )

	// Exibe ou oculta a aplicacao Word.
	OLE_SetProperty( oWord, oleWdWindowState, '1' )

	// Atribui os valores as variáveis.
	OLE_SetDocumentVar( oWord, 'w_RA_NOME'   , cNome      )
	OLE_SetDocumentVar( oWord, 'w_RA_CC'     , cCC        )
	OLE_SetDocumentVar( oWord, 'w_AREA'      , cDescCC    )
	OLE_SetDocumentVar( oWord, 'w_LOCAL'     , cLocal     )
	OLE_SetDocumentVar( oWord, 'w_RA_ADMISSA', sToD(cAdmissa) )
	OLE_SetDocumentVar( oWord, 'w_TEMPEMP'   , cTempEmp   )
	OLE_SetDocumentVar( oWord, 'w_TEMPFUNC'  , cTempFunc  )
	OLE_SetDocumentVar( oWord, 'w_CARGO'     , cDCargo    ) 
	OLE_SetDocumentVar( oWord, 'w_RA_SALARIO', cSalario   ) 
	OLE_SetDocumentVar( oWord, 'w_RA_TPCONTR', cTpContr   )  
	OLE_SetDocumentVar( oWord, 'w_RA_XFORMA2', cXForma2   ) 
	OLE_SetDocumentVar( oWord, 'w_SALARIOINI', cSalIni    )
	OLE_SetDocumentVar( oWord, 'w_CARGOINI'  , cDCargoIni )

	OLE_SetDocumentVar( oWord, 'w_NumItens'  , LTrim( Str( Len( aHistorico ) ) ) )

	For nI := 1 To Len( aHistorico )
		OLE_SetDocumentVar( oWord, 'w_ITEM'    + LTrim(Str(nI)), aHistorico[nI,1] )
		OLE_SetDocumentVar( oWord, 'w_data'    + LTrim(Str(nI)), aHistorico[nI,2] ) 
		OLE_SetDocumentVar( oWord, 'w_Anteum'  + LTrim(Str(nI)), aHistorico[nI,3] )
		OLE_SetDocumentVar( oWord, 'w_Reajuste'+ LTrim(Str(nI)), aHistorico[nI,4] )
		OLE_SetDocumentVar( oWord, 'w_Porcent' + LTrim(Str(nI)), aHistorico[nI,5] )
		OLE_SetDocumentVar( oWord, 'w_Salario' + LTrim(Str(nI)), aHistorico[nI,6] )
		OLE_SetDocumentVar( oWord, 'w_Motivo'  + LTrim(Str(nI)), aHistorico[nI,7] )
		OLE_SetDocumentVar( oWord, 'w_Funcao'  + LTrim(Str(nI)), aHistorico[nI,8] )
	Next nI

	// Executa a macro do Word.
	OLE_ExecuteMacro( oWord , "MovimentacaoPessoal" )

	// Atualiza todos os campos.
	OLE_UpDateFields( oWord )

	If nSaida == 1
		// 1-Imprimir
		// Ativa ou desativa impressao em segundo plano. (opcional)
		OLE_SetProperty( oWord, oleWdPrintBack, .F. )
		//Caso fosse parcial a impressão informar o intervalo e trocar ALL por PART.
		OLE_PrintFile( oWord, 'ALL', /*pag_inicial*/, /*pag_final*/, /*Num_Vias*/ )
		// Esperar 2 segundos para imprimir.
		Sleep( 2000 )
	Else
		cFileSave := SubStr(cFileOpen,1,At(".",Trim(cFileOpen))-1)

		OLE_SaveAsFile( oWord, cFileSave+"-"+cMat+".doc" )
	  
		// Fecha o documento.
		OLE_CloseFile( oWord )
	Endif
	
Endif

// Fechar o link com a aplicação.
OLE_CloseLink( oWord, .F. )

Return