#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
+=============================================================+
|Programa: LAPROD03 |Autor: Antonio Carlos |Data: 28/12/10    |
+=============================================================+
|Descrição: Esta rotina tem como objetivo processar o cadastro|
|dos itens que apresentaram divegencia na importação.         |
+=============================================================+
|Uso: Especifico Laselva                                      |
+=============================================================+
*/

User Function LAPROD03()

Local oCombo
Local _aFor		:= {"DINAP","CHINAGLIA"}
Private _aItCad	:= {}
Private oLetxt
Private cCombo

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivos Textos") 
@ 02,10 TO 080,190 PIXEL OF oLetxt

@ 10,018 Say " Esta rotina tem como objetivo efetuar o cadastro de produtos" PIXEL OF oLetxt
@ 18,018 Say " dos itens que apresentaram inconsistencias no processo de " PIXEL OF oLetxt
@ 28,018 Say " importacao dos arquivos texto DINAP e Chinaglia. " PIXEL OF oLetxt
@ 45,018 Say "Escolha o Fornecedor   " PIXEL OF oLetxt
@ 43,080 COMBOBOX oCombo VAR cCombo ITEMS _aFor SIZE 80,05 PIXEL OF oLetxt

@ 70,128 BMPBUTTON TYPE 01 ACTION ( OkLeTxt(), Close(oLeTxt) )
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return()

Static Function OkLeTxt()                

Local cAux, nTam
Local nPos, _cDrive	:= ''
Local _cNomArq		:= ''           
Local _aArea		:= GetArea()
Local _lFilial		:= .t.  
Local cDirectory	:= ""
Local nArq			:= 0

Private cArqTxt
Private nHdl
Private _ArqFal    
Private _aItens		:= {}
Private _aNaoPro	:= {}
Private _aProd		:= {}  
Private _aProces	:= {}
Private _aLinha		:= {}
Private _cForn		:= ""
Private _cLoja		:= ""
Private _cNumPed	:= ""
Private _cCond		:= ""
Private _cFilAtu	:= ""  
PRIVATE aParamFile	:= ARRAY(1)
Private _cCota		:= ""  
Private aArquivos	:= {}

If cCombo == "DINAP"
	cExt := "*.LCT"
Else
	cExt := "*.RTX"
EndIf
         
cDirectory := ALLTRIM(cGetFile("Escolha o Diretorio" ,'Importação '+cCombo, 0,'', .T., GETF_OVERWRITEPROMPT + GETF_LOCALHARD + GETF_NETWORKDRIVE+ GETF_RETDIRECTORY,.T.))
If empty(cDirectory)
	RestArea(_aArea)
	Return
Endif

aArquivos := Directory(cDirectory+"R_*.*") 
lProcessa := MARKFILE(aArquivos,cDirectory,cExt,.t.)
If !lProcessa
	RestArea(_aArea)
	Return
Endif

For nArq := 1 To Len(aArquivos)

	If !aArquivos[nArq][1]
		Loop
	EndIf
       
	_cPath  := alltrim(aArquivos[nArq][3])
	cArqTxt := _cPath + alltrim(aArquivos[nArq][2])

   _cDrive :=  _cPath + "\processados\"
	//_cNomArq := alltrim(aArquivos[nArq][2])  
	//_ArqFal := _cPath + '\R_' + _cNomArq		   
	//_ArqPro := _cDrive + _cNomArq

	If !ExistDir(_cDrive)
		MsgAlert("Criar a pasta:  " + upper(_cDrive) + "  antes de processar arquivo!  ","Atencao!")
		RestArea(_aArea)
		Return   
	EndIf

	nHdl := ft_fuse(cArqTxt)

	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
		Loop
	EndIf       

	If cCombo == "DINAP"	
		MsgRun("Aguarde...  Processando Arquivo Dinap " + _cNomArq, "Aguarde", {|| fDinap()} )
	Else 
		//CHINAGLIA 
		//MsgRun("Aguarde...  Processando Arquivo Chinaglia " + _cNomArq, "Aguarde", {|| fChinag()} )
		Return
	Endif

	ft_fuse()        
	
Next

If Len(_aItCad) > 0
	CadProd()
EndIf

MsgAlert("Processamento finalizado!","Atenção")

RestArea(_aArea)

Return

Static Function MARKFILE(aArquivos,cDiretorio,cDriver,lSelecao)

Local aChaveArq	:= {}
Local cTitulo	:= "Arquivos para importação: "
Local bCondicao := {|| .T.}
// Variáveis utilizadas na seleção de categorias
Local oChkQual,lQual,oQual,cVarQ
// Carrega bitmaps
Local oOk	:= LoadBitmap( GetResources(), "LBOK")
Local oNo	:= LoadBitmap( GetResources(), "LBNO")
// Variáveis utilizadas para lista de filiais
Local nx	:= 0
Local nAchou:= 0

For nX := 1 to Len(aArquivos)  
	// aChaveArq - Contem os arquivos que serão exibidos para seleção
	cExt := right(aArquivos[nX][1],3)
	If upper(cExt) == right(cDriver,3)
		AADD(aChaveArq,{.F.,aArquivos[nX][1],cDiretorio})
	EndIf
Next nX

If len(aChaveArq) == 0
	AADD(aChaveArq,{.F.,"       ",cDiretorio})
EndIf

//+--------------------------------------------------------------------+
//| Monta tela para seleção dos arquivos contidos no diretório |
//+--------------------------------------------------------------------+

DEFINE MSDIALOG oDlg TITLE cTitulo STYLE DS_MODALFRAME From 145,0 To 445,628 OF oMainWnd PIXEL

oDlg:lEscClose := .F.
If cDriver == "R_*.LCT"
	@ 05,15 TO 125,300 LABEL "DINAP" OF oDlg PIXEL
Else
	@ 05,15 TO 125,300 LABEL "CHINAGLIA" OF oDlg PIXEL
EndIf

@ 15,20 CHECKBOX oChkQual VAR lQual PROMPT "Marcar / Desmarcar" SIZE 60, 10 OF oDlg PIXEL;
ON CLICK (AEval(aChaveArq, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual:Refresh(.F.))

@ 30,20 LISTBOX oQual VAR cVarQ Fields HEADER "","Código","Descrição" SIZE 273,090 ON DBLCLICK (aChaveArq:=Troca(oQual:nAt,aChaveArq),oQual:Refresh());
NoScroll OF oDlg PIXEL
oQual:SetArray(aChaveArq)
oQual:bLine := { || {If(aChaveArq[oQual:nAt,1],oOk,oNo),aChaveArq[oQual:nAt,2],aChaveArq[oQual:nAt,3]}}

DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION IIF(MarcaOk(aChaveArq),(lSelecao := .T., oDlg:End(),.T.),.F.) ENABLE OF oDlg
DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION (lSelecao := .F., oDlg:End());
ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED                                     
aArquivos := aChaveArq

Return lSelecao

Static Function Troca(nIt,aArray)

aArray[nIt,1] := !aArray[nIt,1]

Return aArray

Static Function fDinap()

Local cBuffer, _cDescr2
Private _cCGC, _cEdicao, _cCodBarra, _cDescr
Private _nQuant, _cEditora, _nCusto, _nCstTot
Private _cTipo,  _cRef
Private _cLinha 
Private _cProd		:= ''
Private _cAssunto	:= ''
Private _cItem		:= ""
Private _aAuxIte := {}

_aLinha := {}
                
ft_fgotop()
While !ft_feof()
	
	_cLinha  := ft_freadln()	
	cBuffer  := _cLinha	
	
	_cCota     := Substr( cBuffer, 19,4) 
	_cRef      := Substr( cBuffer, 36, 8)
	_cEdicao   := Substr( cBuffer,  44, 04) 
	_cCodBarra := ALLTRIM(Substr( cBuffer,  48, 18))
	_cDescr    := alltrim(Substr( cBuffer,  66, 30))
	_nQuant	   := val(Substr( cBuffer,  100, 04)+ '.00')
	_cEditora  := Substr( cBuffer, 104, 30)
	_cCusto	   := Substr( cBuffer, 144, 05)
	_nCusto    := val(left(_cCusto,3) + '.' + right(_cCusto,2))
	_cDescr2   := alltrim(Substr( cBuffer, 159, 30))
	
	If !empty(_cDescr2)
		_cDescr += " - " +  _cDescr2
	EndIf                                    
  	
  	_nCstTot := _nQuant * _nCusto  	
  	
	DbSelectArea("SZH")
	If DbSeek(xFilial("SZH")+"1"+_cCota)
		cFilAnt := SZH->ZH_CODFIL
		_cForn := SZH->ZH_FORNEC
		_cLoja := SZH->ZH_LOJA
		_cCond := Posicione("SA2", 1, xFilial("SA2") + _cForn + _cLoja ,"A2_COND")  	
  	   
		If _nQuant <= 0   	
			aadd(_aProd,{cFilAnt, _cCota, _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, "Quantidade = 0 (zero)."} )
			ft_fskip()
			Loop
		EndIf
  	
		If _nCusto <= 0   	
			aadd(_aProd,{cFilAnt, _cCota, _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, "Custo unitario = 0 (zero)."} )
			ft_fskip()
			Loop
		EndIf
  	   
		ChkDados()
    	
	Else
		aadd(_aNaoPro, _cLinha) 
		aadd(_aProd,{ ,_cCota,"Dinap " , , _cRef, _cEdicao, _cCodBarra, _cDescr, "COTA NAO CADASTRADA EM COTAxFILIAL"} )
	EndIf  	                             
	
	ft_fskip()
EndDo         
                 
Return

Static Function ChkDados()

Local _aArea	:= GetArea()
Local _lProd	:= .f.
Local _lRet		:= .f.
Local _cEdAux	:= 0
Local _dDataAnt	:= ctod('')
Local _nTam		:= len(_cCodBarra) - 4
Local _cChave	:= left(_cCodBarra,13)   
Local _nReg		:= 0
Local _cBloq	:= " "
             
If Empty(_cCodBarra)
	//caso alguma linha do arquivo texto venha sem o codigo de barras
	aadd(_aProd,{cFilAnt,_cCota, _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, 'OBS: SEM COD.BARRAS NO ARQUIVO'} )   
	Return _lRet
EndIf

If Len(_cEdicao) > 4
	//edição diferente do padrão
	aadd(_aProd,{cFilAnt,_cCota, _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, 'EDIÇÃO FORA DO PADRÃO'} )
	Return _lRet
EndIf

//verificar se produto ja esta cadastrado, senao cadastrar com base na ultima edicao dele cadastrada.
DbSelectArea("SB1")
DbSetOrder(9)
If !SB1->( DbSeek( xFilial("SB1")+_cRef ) )
	aadd(_aNaoPro, _cLinha) 
	If .not. empty( _cAssunto )
		aadd(_aProd,{cFilAnt,_cCota , _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, _cAssunto} )
	Else
		aadd(_aProd,{cFilAnt,_cCota , _cForn, _cLoja,_cRef, _cEdicao, _cCodBarra, _cDescr, 'COD.BARRAS SEM EDIÇÕES CADASTRADAS' } )
	EndIf
	_cProd := ''
Else
	_cProd := SB1->B1_COD
	_cProdNew	:= Left(_cProd, Len( Alltrim( _cProd ) ) - 4 ) + _cEdicao
	Aadd(_aItCad, {_cProdNew, _cDescr,_cCodBarra,_cRef} )																	
EndIf

Return _lRet

Static Function MarcaOk(aArray)

Local lRet	:=.F.
Local nx	:=0

// Checa marcações efetuadas
For nx:=1 To Len(aArray)
	If aArray[nx,1]
		lRet:=.T.
	EndIf
Next nx
// Checa se existe algum item marcado na confirmação

If !lRet
	HELP("SELFILE",1,"HELP","SEL. FILE","Não existem itens marcados",1,0)
EndIf

Return lRet      

Static Function CadProd()

Local nLinha		:= 0
Local aCpoGDa		:= {"B1_COD","B1_DESC","B1_CODBAR","B1_COMPDES"}
Private oDlgCad
Private aHeader		:= {}
Private aCols		:= {}
Private aRotina		:= {{"Pesquisar"	, "AxPesqui", 0, 1},;
	                    {"Visualizar"	, "AxVisual", 0, 2},;
	                    {"Incluir"		, "AxInclui", 0, 3},;
	                    {"Alterar"		, "AxAltera", 0, 4},;
    	                {"Excluit"		, "AxDeleta", 0, 5}}
    	                
DbSelectArea( "SX3" )
SX3->( DbSetOrder( 2 ) )

For nI := 1 to Len( aCpoGDa )
	If SX3->( dbSeek( aCpoGDa[nI] ) )
		aAdd( aHeader, { AlLTrim( X3Titulo() )	,;
		SX3->X3_CAMPO		,;
		SX3->X3_Picture 	,;	
		SX3->X3_TAMANHO		,;
		SX3->X3_DECIMAL		,;
		""					,;
		SX3->X3_USADO		,;
		SX3->X3_TIPO		,;
		SX3->X3_F3 			,;
		SX3->X3_CONTEXT		,;
		SX3->X3_CBOX		,;
		"" } )
	EndIf
Next nI    	                

For _nI := 1 To Len(_aItCad)

	aAdd( aCols, Array( Len( aHeader ) + 1 ) )
	nLinha++
	
	For nI := 1 To Len( aHeader )
		
		If Alltrim(aHeader[nI][2]) == "B1_COD"
 			aCols[nLinha][nI] := _aItCad[_nI,1]
 		ElseIf Alltrim(aHeader[nI][2]) == "B1_DESC"	
			aCols[nLinha][nI] := _aItCad[_nI,2] 			
		ElseIf Alltrim(aHeader[nI][2]) == "B1_CODBAR"	
			aCols[nLinha][nI] := _aItCad[_nI,3] 				
		ElseIf Alltrim(aHeader[nI][2]) == "B1_COMPDES"
			aCols[nLinha][nI] := _aItCad[_nI,4] 							
		EndIf
		
	Next nI
	
	aCols[nLinha][Len( aHeader ) + 1] := .F.		

Next _nI
    	                
aSize	:= MsAdvSize(,.F.,400)
		
aObjects := {}

AAdd( aObjects, { 0,    61, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 0,    15, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
   	                
DEFINE MSDIALOG oDlgCad TITLE "Importa Revistas" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL    	                

DEFINE FONT oFontBold   NAME 'Times New Roman' SIZE 10, 12 Bold

//oGetDados	:= MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],4,"U_LINHAOK",,,.T.,{"BZ_PERFIL","BZ_SUPPLY","BZ_EMAX","BZ_EMIN"},,,,"U_FIELDOK","U_SUPERDEL",,"U_DELOK",)
oGetDados	:= MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],4,,,,.T.,{"B1_CODBAR"},,,,,,,,)

ACTIVATE MSDIALOG oDlgCad CENTERED ON INIT EnchoiceBar( oDlgCad, { || oDlgCad:End() }, { ||  oDlgCad:End() },,  )

If Len(_aProd) > 0
	U_RelDiv()
EndIf	

Return

User Function RelDiv()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "com os produtos que devem ser cadastrados"
Local cDesc3       := "Produtos a serem Cadastrados"
Local cPict        := ""
Local titulo       := "PRODUTOS A SEREM CADASTRADOS / INCONSISTENCIAS " 
Local nLin         := 80

Local Cabec1       := "Fil  Cota  Fornec  Loja  Referencia Edicao Cod.Barra            Descricao                                                    Assunto"
                      //"Fornecedor/Loja: "  + _cForn + space(02) + _cLoja + space(02)+ Posicione("SA2", 1, xFilial("SA2") + _cForn + _cLoja ,"A2_NREDUZ")
Local Cabec2       := ""
              //        99  9999  123456   99   01234567   1234   12345678901234567890 123456789012345678901234567890123456789012345678901234567890 123456789012345678901234567890 
              //       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890   
              //                 1         2         3         4         5         6         7         8         9         10        11        12        13
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RELHQ03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELHQ03" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunRel03(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREL03  º Autor ³ AP6 IDE            º Data ³  13/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunRel03(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

SetRegua(RecCount())

For _nx := 1 to len(_aProd)
  
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   
   If nLin > 55 
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 10
   Endif    
                               
   @ nLin,01 PSAY _aProd[_nx,1] //filial
   @ nLin,05 PSAY _aProd[_nx,2] //cota
   @ nLin,11 PSAY _aProd[_nx,3] //fornec      
   @ nLin,20 PSAY _aProd[_nx,4] //loja
   @ nLin,25 PSAY _aProd[_nx,5] //referencia
   @ nLin,36 PSAY _aProd[_nx,6] //edicao 
   @ nLin,43 PSAY _aProd[_nx,7] // cod barra
   @ nLin,64 PSAY Left(_aProd[_nx,8],60) //descricao
   @ nLin,125 PSAY _aProd[_nx,9] //assunto
      
   nLin := nLin + 1 
   
Next _nx

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return     

Static Function GrvNPro()

Local cEOL := "CHR(13)+CHR(10)"  
Local _NewArq, nFal, _n, cLin               
          
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

if file(_ArqFal)
   _NewArq := left(_ArqFal, len(_ArqFal) - 3) + "ant"
   rename _ArqFal to _NewArq
endif

nFal := fCreate(_ArqFal)
if nFal == -1
   MsgAlert("O arquivo "+_ArqFal+" nao pode ser criado! ","Atencao!")
   Return
endif
      
For _n := 1 to len(_aProd)
                       
   cLin := _aProd[_n] + cEOL
         
   If fWrite(nFal,cLin,Len(cLin)) != Len(cLin)
      MsgAlert("Erro na gravacao do arquivo " + upper(_ArqFal) ,"Atencao!")
      Exit
   Endif
      
Next    
      
fClose(nFal)

Return