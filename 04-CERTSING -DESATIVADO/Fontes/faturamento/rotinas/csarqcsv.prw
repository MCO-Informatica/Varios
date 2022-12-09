#Include "Protheus.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO10    บAutor  ณMicrosiga           บ Data ณ  12/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ler arquivos csv para importa็ใo de informa็๕es บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CSARQCSV()

Local aSay 			:= {}
Local aButton 		:= {}
Local nOpcao 		:= 0
Local aPar 			:= {}
Local aRet 			:= {}
Local bOk 			:= {|| }

Private cCadastro   := "Ler dados em arquivo CSV"
	
//+------------------------------------
//| Monta tela de interacao com usuario
//+------------------------------------
aAdd(aSay,"Este programa irแ importar os arquivos .CSV indicados")
aAdd(aSay,"e gravar de acordo com sua necessidade")
aAdd(aSay,"")
aAdd(aSay,"")
aAdd(aSay,"")

aAdd(aButton, { 1,.T.,{|| nOpcao := 1, FechaBatch() }})
aAdd(aButton, { 2,.T.,{|| FechaBatch() }})

//+---------------------------------------------------------------------
//| FormBatch(<cTitulo>,<aMensagem>,<aBotoes>,<bValid>,nAltura,nLargura)
//+---------------------------------------------------------------------
FormBatch( cCadastro, aSay, aButton, bOk )

//+----------------
//| Se OK processar
//+----------------
If nOpcao == 1
	bOk := {|| Iif(File(mv_par01),MsgYesNo("Confirma o inํcio do processamento?",cCadastro),(MsgAlert("Arquivo nใo localizado, verifique."),.F.)) }
	
	AAdd(aPar,{6,"Informe o arquivo",Space(99),"","","",80,.T.,"CSV (separado por vํrgulas) (*.csv) |*.csv"})
	
	If ParamBox(aPar,"Parโmetros",@aRet,bOk,,,,,,,.F.,.F.)
		Processa({|| CSLEARQ(aRet) },cCadastro,"Processando, aguarde...", .F. )
	Endif
Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO10    บAutor  ณMicrosiga           บ Data ณ  12/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ler arquivos csv para importa็ใo de informa็๕es บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CSLEARQ(aRet)
Local cLinha := 0
Local cFile := RTrim(aRet[1])
Local cSystem := GetSrvProfString("Startpath","")
Local aHead := {}
Local aDados := {}

//--------------------------------------------------------
// Se o arquivo CSV nใo estiver no diret๓rio system copiar
//--------------------------------------------------------
If ! (cSystem $ cFile)
	//-----------------------------------------------------
	// Copiar o arquivo do diret๓rio indicado para o system
	//-----------------------------------------------------
	If ! __CopyFile(cFile,SubStr(cFile,Rat("\",cFile)+1))
		MsgAlert("Problemas em copiar o arquivo do local indicado para o Startpath do Protheus")
		Return
	Endif
Endif

//-----------------------------------
// Capturar somente o nome do arquivo
//-----------------------------------
cFile := SubStr(cFile,Rat("\",cFile)+1)
//----------------------------
// Abrir o arquivo texto (CSV)
//----------------------------
FT_FUSE(cFile)
//----------------------------------------
// Posicionar na primeira linha do arquivo
//----------------------------------------
FT_FGOTOP()	
//----------------------------------------------------
// Ler a 1ช linha que precisa ser o Header da planilha
//----------------------------------------------------
cLinha := FT_FREADLN()
//---------------------------------
// Ir para o pr๓xima linha de dados
//---------------------------------
FT_FSKIP()	
//-----------------------------------------
// Monta o vetor conforme os dados na linha
//-----------------------------------------
aHead := Defrag(cLinha)
//-------------------------------------------------
// Atribuir a quantidade de registros a serem lidos
//-------------------------------------------------
ProcRegua(FT_FLASTREC())
//-------------------------------------------
// Le o arquivo at้ sua ๚ltima linha de dados
//-------------------------------------------
While ! FT_FEOF()
	IncProc()
	//-------------------------
	// Captura a linha de dados
	//-------------------------
	cLinha := FT_FREADLN()
	//-----------------------------------------
	// Monta o vetor conforme os dados na linha
	//-----------------------------------------
      AAdd(aDados,Defrag(cLinha))
      //---------------------------------
      // Ir para o pr๓xima linha de dados
      //---------------------------------
	FT_FSKIP()
End

////////////////////////////////////////////////////////////////////////////////
//Chamada da rotina de grava็ใo das informa็๕es de acordo com o campo do aHead//
////////////////////////////////////////////////////////////////////////////////
FWMsgRun(,{|| CSGRVARQ(aHead,aDados)},,"Gravando informa็๕es...")

//--------------------------
// Fechar o arquivo de dados
//--------------------------
FT_FUSE()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO10    บAutor  ณMicrosiga           บ Data ณ  12/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para ler arquivos csv para importa็ใo de informa็๕es บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Defrag(cLinha)
Local nP 		:= 0
Local aArray 	:= {}
Local cDelim 	:= ";"
Local cTipEnt	:= ""

//----------------------------------------------------------------
// Verificar se hแ o delimitador no final da linha, senใo incluir.
//----------------------------------------------------------------
If Right(cLinha,1) <> cDelim
	cLinha := cLinha + cDelim
Endif

//---------------------------------------------------------
// Ler at้ o final da linha, ou seja, enquanto houver dado.
//---------------------------------------------------------
While ! Empty(cLinha)
	//-------------------------
	// Localizar o delimitador.
	//-------------------------
	nP := At(cDelim,cLinha)
	//---------------------------------------------------------------------------------
	// Se localizar, capturar o dado e refazer a linha somente com o restante de dados.
	//---------------------------------------------------------------------------------
  
	Do Case                                      
		Case AllTrim(Upper(SubStr(cLinha,1,nP - 1))) == "CANAL"
			cTipEnt	:= "1"
		Case AllTrim(Upper(SubStr(cLinha,1,nP - 1))) == "REDEGRUPO"
			cTipEnt	:= "2"
		Case AllTrim(Upper(SubStr(cLinha,1,nP - 1))) == "AR"
			cTipEnt	:= "3"
		Case AllTrim(Upper(SubStr(cLinha,1,nP - 1))) == "POSTO"
			cTipEnt	:= "4"
		Case AllTrim(Upper(SubStr(cLinha,1,nP - 1))) == "GRUPO"
			cTipEnt	:= "5"
		Case AllTrim(Upper(SubStr(cLinha,1,nP - 1))) == "REDE"
			cTipEnt	:= "6"
		Case AllTrim(Upper(SubStr(cLinha,1,nP - 1))) == "REVENDEDOR"
			cTipEnt	:= "7"
		Case AllTrim(Upper(SubStr(cLinha,1,nP - 1))) == "FEDERACAO"
			cTipEnt	:= "8"
		Case AllTrim(Upper(SubStr(cLinha,1,nP - 1))) == "CCRCOMISSAO"
			cTipEnt	:= "9"
	End Case
	
	If nP > 0
		AAdd(aArray,Iif(Empty(cTipEnt),SubStr(cLinha,1,nP - 1),cTipEnt))
		cLinha := SubStr(cLinha,nP + 1)
	Endif
	
	cTipEnt := ""
	
	IncProc()
End

If Len(aArray) == 13
	aAdd(aArray,"")
Endif

Return(aArray)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSARQCSV  บAutor  ณMicrosiga           บ Data ณ  12/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CSGRVARQ(aHead,aDados)

Local cCpoSZ3	:= "Z3_CODFED|Z3_DESFED|Z3_CODAC|Z3_CODCCR|Z3_CCRCOM|Z3_CODCAN|Z3_DESCAN|Z3_CODCAN2|Z3_DESCAII"
Local cDescAc	:= ""
Local lGrv		:= .F.
Local nS			:= 0
Local nA			:= 0
Local nHdl     := 0
Local aRecNo   := {}

SZ3->(DbSetOrder(1))

Begin Transaction 

For nS := 1 To Len(aDados)
	
	If SZ3->(DbSeek(xFilial("SZ3") + PadL(aDados[nS,01],6,"0")))
		lGrv	:= .F.
	Else
		lGrv	:= .T.                        
	EndIf
	
	RecLock("SZ3",lGrv)
	
	For nA := 1 To Len(aHead)
		If AllTrim(aHead[nA]) $ cCpoSZ3
		   If !Empty(AllTrim(aDados[nS,nA]))

				SZ3->(FieldPut( FieldPos( aHead[nA] ), Iif(AllTrim(aHead[nA]) == "Z3_CODCCR",PadL(aDados[nS,09],6,"0"),aDados[nS,nA])))
				
				If AllTrim(aHead[nA]) == "Z3_CODAC"
					////////////////////////////////////////////////////////////////////////////////////////
					//Chamada da rotina para atualiza็ใo do campo de descri็ใo da autoridade certificadora//
					////////////////////////////////////////////////////////////////////////////////////////
					SZ3DESCAC(&("SZ3->" + aHead[nA]),@cDescAc)

					SZ3->Z3_DESAC	:= cDescAc
				EndIf
				
         EndIf
		EndIf
	Next nA

	SZ3->(MsUnLock())
	
	AAdd( aRecNo, LTrim( Str( SZ3->( RecNo() ) ) ) )
	
Next nS        

End Transaction

If Len( aRecNo ) > 0
	nHdl := FCreate("csarqcsv.txt")
	
	AEval( aRecNo, {|p| FWrite( nHdl, p + CRLF ) } )
	
	/*
	For nA := 1 To Len( aRecNo )
		FWrite( nHdl, aRecNo[ nA ] + CRLF )
	Next nA
	*/
	
	FClose( nHdl )
Endif

Return

Static Function SZ3DESCAC(cEnt,cDescAc)

Local aArea	:= GetArea()
Local aAreaSZ3	:= SZ3->(GetArea())


SZ3->(DbSetOrder(1))

If SZ3->(DbSeek(xFilial("SZ3") + cEnt))
	cDescAc := SZ3->Z3_DESENT
EndIf

RestArea(aAreaSZ3)
RestArea(aArea)

Return