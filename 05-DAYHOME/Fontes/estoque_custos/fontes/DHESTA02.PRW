#Include 'Protheus.ch'
#Include 'xmlxfun.ch'

//------------------------------------------------------------------------\\
/*/{Protheus.doc} DHESTA02
Importar planilha de n?meros de s?ries
@type Function
@author Claudio Macedo
@since 24/12/2021
@version 1.0
/*/
//------------------------------------------------------------------------\\
User Function DHESTA02()

Local cDirDocs := ''
Local cNomeArq := '' 
Local nRegs    := 0
Local aDados   := {}

Private aOcorrencias := {}
Private lOcorrencias := .F.

cDirDocs := cGetFile( 'Arquivo CSV|*.CSV' , 'Selecione a Pasta', 1, 'C:\', .T., GETF_LOCALHARD, .F., .T. )

If Empty(cDirDocs)
	MsgInfo('Cancelado pelo usu?rio.')
	Return NIl
EndIf

cNomeArq :=	Substring(cDirDocs,RAT('\',cDirDocs)+1,Len(cDirDocs))

If MsgYesNo('Confirma a importa??o do arquivo '+Alltrim(cNomeArq)+' ?')

	FT_FUse(cDirDocs) 

	nRegs := FT_FLASTREC()

	FT_FGOTOP()

	Processa( {|| ImportaCSV(@aDados, nRegs) }, 'Analisando o arquivo ' + cNomeArq, 'Aguarde ...', .F.)

	If lOcorrencias

		If MsgYesNo('Foram encontradas ocorr?ncias de cadastro no arquivo '+cNomeArq+'.'+CRLF+'Deseja imprimir o arquivo de log ?')
			LogCSV(cNomeArq)
		Endif
		
		FT_FUse()
		
		Return Nil
	
	Endif
	
	Processa( {|| GravaSZ4(aDados, nRegs) }, 'Processando arquivo ' + cNomeArq, 'Incluindo registros de n?meros de s?ries ...', .F.)

Endif

Return Nil

//------------------------------------------------------------------------\\
/*/{Protheus.doc} ImportaCSV
Importa arquivo csv
@type function
@author Claudio Macedo
@since 24/12/2021
@version 1.0
@example ImportaCSV(aDados)
/*/
//------------------------------------------------------------------------\\
Static Function ImportaCSV(aDados,nRegs)

Local cProduto  := ''
Local cNumSerie := ''

Local nLinha := 0
Local cErro  := ''
Local cTexto := ''

//-------------------------------------------------------- Layout -------------------------------------------------------\\
// Produto;N?mero de s?rie;Fabricante;Container;N?mero do Pedido;N?mero da DANFE;Data de emiss?o DANFE;Cliente;Observa??es	
// ----------------------------------------------------------------------------------------------------------------------\\

ProcRegua(nRegs)

FT_FGoTop()

While !FT_FEof()
	IncProc('Importando o arquivo CSV ...')
    
   	cLinha := FT_FReadln() 
	aAdd(aDados, Separa(Replace(Replace(cLinha,'.',''),',','.'), ';', .T.))

   	FT_FSkip()

EndDo

ProcRegua(Len(aDados))

For nLinha := 2 to Len(aDados)

    cProduto  := PADR(Alltrim(aDados[nLinha][1]), 15)
    cNumSerie := PADR(Alltrim(aDados[nLinha][2]), 30)
    
    SZ4->(DbSetOrder(1))

    If SZ4->(DbSeek(xFilial('SZ4') + cNumSerie + cProduto))
        Loop
	Endif

    SB1->(DbSetOrder(1))

	If !SB1->(DbSeek(xFilial('SB1') + cProduto))
        cErro  := '1'
        cTexto := 'Produto n?o cadastrado'
        GravaErro(nLinha, cErro, cProduto, cNumSerie, cTexto)
        Loop
	Endif

	SB5->(DbSetOrder(1))

    If !SB5->(DbSeek(xFilial('SB5') + cProduto)) .Or. SB5->B5_XNUMSER <> 'S'
        cErro  := '2'
        cTexto := 'Produto sem controle de numero de serie habilitado'
        GravaErro(nLinha, cErro, cProduto, cNumSerie, cTexto)		
        Loop
	Endif

	IncProc('Analisando o arquivo CSV ...')

Next nLinha

Return

//------------------------------------------------------------------------\\
/*/{Protheus.doc} GravaErro
@TODO Grava erro no array de ocorr?ncias.
@type 	 Function
@author  Claudio Macedo
@since 	 24/12/2021
@version 1.0
@example GravaErro(nLinha, cErro, cProduto, cNumSerie, cTexto)
/*/
//------------------------------------------------------------------------\\
Static Function GravaErro(nLinha, cErro, cProduto, cNumSerie, cTexto)

Local nPos := 0

If cErro == '4'
    nPos := aScan(aOcorrencias, {|x| x[2] + x[3] + x[4] == cErro + cProduto + cNumSerie })   
Else 
    nPos := aScan(aOcorrencias, {|x| x[2] + x[3] == cErro + cProduto })   
Endif

If nPos = 0
    aAdd(aOcorrencias, {nLinha, cErro, cProduto, cNumSerie, cTexto})
    lOcorrencias := .T.
Endif 

Return Nil

//------------------------------------------------------------------------\\
/*/{Protheus.doc} GravaSZ4
Incluir previs?o de venda.
@type 	 Function
@author  Claudio Macedo
@since 	 24/12/2021
@version 1.0
@example GravaSZ4(aDados, nRegs)
/*/
//------------------------------------------------------------------------\\
Static Function GravaSZ4(aDados, nRegs)

Local nLinha := 0

Local cProduto  := ''
Local cNumSerie := ''

ProcRegua(nRegs)

For nLinha := 2 to Len(aDados)             
    
    cProduto  := PADR(Alltrim(aDados[nLinha][1]), 15)
    cNumSerie := PADR(Alltrim(aDados[nLinha][2]), 30)

    SZ4->(DbSetOrder(1))

    If SZ4->(DbSeek(xFilial('SZ4') + cNumSerie + cProduto ))
        Loop
	Endif

    SZ4->(Reclock('SZ4',.T.))

    SZ4->Z4_FILIAL  := xFilial('SZ4')
    SZ4->Z4_CODIGO  := aDados[nLinha,1]
    SZ4->Z4_NUMSERI := aDados[nLinha,2]
    SZ4->Z4_FABRI   := aDados[nLinha,3]
    SZ4->Z4_CONTAIN := aDados[nLinha,4]
    SZ4->Z4_NUMPED  := aDados[nLinha,5]
    SZ4->Z4_NOTA    := aDados[nLinha,6]
    SZ4->Z4_DTNOTA  := Ctod(aDados[nLinha,7])
    SZ4->Z4_CLIENTE := aDados[nLinha,8]
    SZ4->Z4_LOJA    := aDados[nLinha,9]
    SZ4->Z4_OBS     := aDados[nLinha,11]
    
    SZ4->(MsUnlock())

    IncProc()
                  
Next nLinha

MsgInfo('N?meros de s?ries importados com sucesso.')

Return Nil

//------------------------------------------------------------------------\\
/*/{Protheus.doc} LogCSV
Imprime relat?rio de ocorr?ncias
@type function
@author Claudio
@since 14/12/2019
@version 1.0
@example LogCSV()
/*/
//------------------------------------------------------------------------\\
Static Function LogCSV(cNomeArq)

Local cDesc1         	 := 'Este programa tem como objetivo imprimir relatorio '
Local cDesc2         	 := 'de acordo com os parametros informados pelo usuario.'
Local cDesc3         	 := ''
Local titulo         	 := 'Relat?rio de Importa??o: '+cNomeArq
Local nLin           	 := 80
Local aOrd 				 := {}
Private lEnd         	 := .F.
Private lAbortPrint  	 := .F.
Private CbTxt        	 := ''
Private limite           := 80
Private tamanho          := 'M'
Private nomeprog         := 'LogCSV' // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { 'Zebrado', 1, 'Administracao', 1, 2, 1, '', 1}
Private nLastKey         := 0
Private cbcont     		 := 00
Private CONTFL     		 := 01
Private m_pag      		 := 01
Private cPerg       	 := ''
Private wnrel      		 := 'LogCSV' // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString			 := ''

			       //         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
		           //1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		           //999999999999  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 99/99/99  999999999 AAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA  9,999,999,999.99  9,999,999,999.99
Cabec1         	 := 'Linha   Erro   Produto           Numero de Serie                  Ocorr?ncia'
Cabec2         	 := ''

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//?????????????????????????????????????????????????????????????????????Ŀ
//? Processamento. RPTSTATUS monta janela com a regua de processamento. ?
//???????????????????????????????????????????????????????????????????????

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Fun??o    ?RUNREPORT ? Autor ? AP6 IDE            ? Data ?  28/09/09   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descri??o ? Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ???
???          ? monta a janela com a regua de processamento.               ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Programa principal                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nI := 0

SetRegua(Len(aOcorrencias))

If nLin > 60 // Salto de P?gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

For nI := 1 to Len(aOcorrencias)

   If lAbortPrint
      @nLin,00 PSAY '*** CANCELADO PELO OPERADOR ***'
      Exit
   Endif

   If nLin > 60 // Salto de P?gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
	
	@nLin,00 PSAY aOcorrencias[nI,1]
	@nLin,09 PSAY aOcorrencias[nI,2]
	@nLin,16 PSAY aOcorrencias[nI,3]
	@nLin,34 PSAY aOcorrencias[nI,4]
	@nLin,67 PSAY aOcorrencias[nI,5]
	
  	nLin := nLin + 1

Next nI

SET DEVICE TO SCREEN

//?????????????????????????????????????????????????????????????????????Ŀ
//? Se impressao em disco, chama o gerenciador de impressao...          ?
//???????????????????????????????????????????????????????????????????????

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif                              

MS_FLUSH()

Return
