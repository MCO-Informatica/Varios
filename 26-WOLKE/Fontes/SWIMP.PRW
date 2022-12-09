#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TOPCONN.CH"
#Include "TbiConn.ch"

/*/{Protheus.doc}  SWIMP
Importa็ใo de Tabela de Pre็os Vendas

/*/

User Function SWIMP()
	Local oImportaTxt
	
	@ 200,001 TO 380,380 DIALOG oImportaTxt TITLE OemToAnsi("Gera็ใo de Arquivo Texto ")
	@ 002,002 TO 090,190
	@ 010,018 Say " Este programa irแ importar a tabela de pre็os, conforme valores do arquivo."
	@ 070,098 BMPBUTTON TYPE 01 ACTION (Processa({|| SWIMP01(),Close(oImportaTxt) },"Processando...","Arquivo Texto..."))
	@ 070,128 BMPBUTTON TYPE 02 ACTION Close(oImportaTxt)
	
	Activate Dialog oImportaTxt Centered
	
	
Return

Static Function SWIMP01()
	cPath   := ""
	
	GetArq(@cPath)
	
	If !File(cPath) .and. !Empty(cPath)
		MsgAlert("Arquivo Nใo Encontrado no Local de Origem Indicado!")
		Return
	Endif
	
	nHdl := fOpen(cPath,0)
	
	If nHdl == -1
		If !Empty(cPath)
			MsgAlert("O arquivo de nome " + cPath + " nใo pode ser aberto! Verifique os parโmetros.", "Aten็ใo!")
		Endif
		Return
	Endif
	
	nHandle	:= FT_FUSE(cPath)
	
	Processa( {|lEnd| SWIMP02() } , "Lendo Arquivo... ")
	
Return(.T.)

Static Function SWIMP02()
	
	Local aEmpresas := {}
	Local nCont		:= 0
	Local nI
	Local nX
	Local nPos := 1
	Local cPRODUTO
	Local nPRECO
	Local nDESC
	Local nDESC1
	Local nDESC2
	Local nDESC3
	Local nDESC4
	Local aValor := {}
	Local cCPF
	
	Private aDadosRet  := {}
	Private aVetPosCpo := {}
	Private cBuffer    := ""
	Private nAchei     := 0
	Private aDePara    := {}
	
	Private cCodForn
	Private cLoja
	Private cCodTab
	
	FT_FGOTOP()
	
	While !FT_FEOF()
		nPos := 1
		cBuffer := FT_FREADLN()  
		aValor := {}
		
		For nX := 1 to 4
			IF !(nX == 4)
		   		aadd(aValor,{ SUBSTR(cBuffer,nPos,at(";",substr(cBuffer,nPos,len(cBuffer)))-1) })
				nPos += at(";",substr(cBuffer,nPos,len(cbuffer)))
			else
				aadd(aValor,{ substr(cBuffer,nPos,len(cBuffer)) })
			endif
		Next
		
		AADD(aDadosRet,	{ aValor[1][1],;   //DA1_CODPRO
		aValor[2][1],;  // DA1_PRCCUS
		aValor[3][1],;  // DA1_PRCLIQ
		aValor[4][1],;  // DA1_PRCVEN
			})
		
		FT_FSKIP(1)
		
	EndDo
	
	Processa( {|lEnd| GravaDA1() } , "Lendo Arquivo... ")
	
Return(.T.)


Static Function GravaDA1()
	
	Local nY := 1
	
	BEGIN TRANSACTION
	
		DbSelectArea("DA1")
		DBSETORDER(1)
		
		For nY := 1 To Len(aDadosRet)
			
			IF DBSEEK(xFilial("DA1")+"003"+ALLTRIM(aDadosRet[nY][1]))
			
			RecLock("DA1",.F.)
			    DA1_PRCCUS := VAL(STRTRAN(aDadosRet[nY][2],",","."))
				DA1_PRCLIQ := VAL(STRTRAN(aDadosRet[nY][3],",","."))   
				DA1_PRCVEN := VAL(STRTRAN(aDadosRet[nY][4],",","."))
			MsUnLock()
			
			endif
		Next
		
	END TRANSACTION
	
	MSGINFO("Arquivo importado com sucesso!!")
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GetArq   บ Autor ณ Microsiga          บ Data ณ  16/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetArq(cFile)
	
	cFile:= cGetFile( "Arquivo (*.csv) | *.csv", "Selecione o Arquivo",,'',.F.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE) ) //Exerga Unidade Mapeadas
	
Return cFile
