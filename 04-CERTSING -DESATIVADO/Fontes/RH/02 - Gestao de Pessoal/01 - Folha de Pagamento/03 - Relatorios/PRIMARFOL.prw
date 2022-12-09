#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "fileio.ch"
#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"                         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESTCONSISTบAutor  ณPrima Informatica   บ Data ณ  13/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGeracao do Arquivo de Integracao com Excel da Planilha de   บฑฑ
ฑฑบ          ณConsist๊ncias da Folha de Pagamento                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณClientes Prima Informatica                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PRIMARFOL

// Declaracao de Variaveis
Private cPerg    := Padr("PRIMARFOL",10)
Private cString  := "SRA"
Private oGeraTxt
Private lcampos := .T. //Campos esperados da Query estao OK

fPriPerg()
pergunte(cPerg,.F.)

dbSelectArea( "SRA" )
dbSetOrder( 1 )

// Montagem da tela de processamento.
DEFINE MSDIALOG oGeraTxt FROM  200,001 TO 410,480 TITLE OemToAnsi( "Planilha Critica da Folha" ) PIXEL
@ 002, 010 TO 095, 230 OF oGeraTxt  PIXEL
@ 010, 018 SAY " Este programa ira gerar o arquivo integrado ao Excel da       " SIZE 200, 007 OF oGeraTxt PIXEL
@ 018, 018 SAY " Planilha de Critica da Folha.                           " SIZE 200, 007 OF oGeraTxt PIXEL
@ 026, 018 SAY "                                                               " SIZE 200, 007 OF oGeraTxt PIXEL
DEFINE SBUTTON FROM 070,128 TYPE 5 ENABLE OF oGeraTxt ACTION (Pergunte(cPerg,.T.))
DEFINE SBUTTON FROM 070,158 TYPE 1 ENABLE OF oGeraTxt ACTION (OkGeraTxt(),oGeraTxt:End())
DEFINE SBUTTON FROM 070,188 TYPE 2 ENABLE OF oGeraTxt ACTION (oGeraTxt:End())
ACTIVATE MSDIALOG oGeraTxt Centered

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOKGERATXT บAutor  ณMicrosiga           บ Data ณ  05/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OkGeraTxt

Processa({|| RunCont() },"Processando...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRUNCONT   บAutor  ณMicrosiga           บ Data ณ  05/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunCont

Local lSetCentury := __SetCentury( "on" )
Local cDirDocs    := MsDocPath()
Local cPath       := AllTrim( GetTempPath() )

Local oExcelApp
Local cNomeArq
Private cLin, nTotReg
Private xAlias, nX, cItem, nPos
Private aInconsist  := {}
Private dDtRef, cFilDe, cFilAte, cMatDe, cMatAte, cCcDe, cCcAte
Private lAll, cRelIncon
Private nHdl
Private n_Hdl

Pergunte(cPerg,.F.)
dDtRef    := mv_par01
cFilDe    := mv_par02
cFilAte   := mv_par03
cMatDe    := mv_par04
cMatAte   := mv_par05
cCcDe     := mv_par06
cCcAte    := mv_par07
dDataRef  := mv_par08

cNomeArq  := CriaTrab(,.F.) + ".CSV"

// Cria Arquivo Texto
nHdl := fCreate( cDirDocs + "\" + cNomeArq )
If nHdl == -1
	MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
EndIf

// Chama a funcao para selecionar as inconsistencias
//aInconsist := U_gpSelDiv()
aInconsist := SelArq()

If Len(aInconsist) = 0
	Return()
Endif

For ny := 1 To len(aInconsist)
	MsAguarde( {|| fGeraTrab( dDtRef, aInconsist[ny][1],ny)}, "Processando...", aInconsist[ny][2]  )
Next ny

//Excel
If mv_par07 = 1
	// Grava Cabecalho do Arquivo Texto
	fGrvCab()
	
	For nX := 1 To Len(aInconsist)
		xAlias := "TMP" + StrZero(nX,3)
		
		If Select( xAlias ) == 0
			Loop
		EndIf
		
		nTotReg := 1
		dbSelectArea( xAlias )
		nTotReg := 20
		dbGoTop()
		ProcRegua( nTotReg )
		
		Do While !Eof()
			IncProc( aInconsist[nx,2] )
			
			// Monta Estrutura do Arquivo Texto
			cLin := "'" + (xAlias)->RA_FILIAL + cSep						// 01 - Filial
			cLin += "'" + (xAlias)->RA_MAT + cSep							// 02 - Matricula
			cLin +=       (xAlias)->RA_NOME + cSep							// 03 - Nome do Funcionario
			If Subs(aInconsist[nx,2],1,3) <= "999"
				cLin += "'" + Subs(aInconsist[nx,2],1,3) + cSep			 			// 04 - Tipo da Inconsistencia
			Else
				cLin += "'" + StrZero(nx,3) + cSep			 			// 04 - Tipo da Inconsistencia
			Endif
			cLin +=       (xAlias)->RA_DESCINC			 					// 05 - Descricao da Inconsistencia
			cLin += cEol
			fGravaTxt( cLin )
			dbSkip()
		EndDo
		(xAlias)->(dbCloseArea())
	Next nX
	
	fClose( nHdl )
	MsAguarde( {|| fStartExcel( cDirDocs, cNomeArq, cPath )}, "Aguarde...", "Integrando Planilha ao Excel..." )
	
	If !lSetCentury
		__SetCentury( "off" )
	EndIf
//Relatorio
Else
	fImpRel()
	fClose( nHdl )
	
	If !lSetCentury
		__SetCentury( "off" )
	EndIf
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfStartExcelบAutor  ณMicrosiga           บ Data ณ  05/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fStartExcel( cDirDocs, cNomeArq, cPath )

CpyS2T( cDirDocs + "\" + cNomeArq , cPath, .T. )

If !ApOleClient( 'MsExcel' )
	MsgAlert( 'MsExcel nao instalado' )
Else
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cNomeArq ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvCab   บAutor  ณMicrosiga           บ Data ณ  05/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGrvCab()

Local cLin

cLin := "Filial" + cSep									// 01 - Filial
cLin += "Matricula" + cSep					 				// 02 - Matricula
cLin += "Funcionแrio" + cSep			   					// 03 - Nome do Funcionario
cLin += "Seq. Inconsist๊ncia" + cSep	 					// 04 - Tipo da Inconsistencia
cLin += "Descri็ใo Inconsist๊ncia" + cSep	 				// 05 - Descricao da Inconsistencia
cLin += cEol
fGravaTxt( cLin )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGravaTxt บAutor  ณMicrosiga           บ Data ณ  05/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGravaTxt( cLin )

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMtaQuery บAutor  ณMicrosiga           บ Data ณ  05/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGeraTrab( dDtRef, cDescTipo, nTmp )

Local cTmp := "TMP"+StrZero(nTmp,3)
Local aCmp := {} //Valida se Todos os campos existem na Query
Private cQuery	:= ""

If Select(cTmp) > 0
	cTmp->(dbCloseArea())
Endif

cQuery  := MemoRead(Alltrim(cDescTipo))
cQuery 	:= MudaTab(cQuery)
cQuery  := ChangeQuery( cQuery )
TCQuery cQuery New Alias &cTmp

//Abre estrutura da Query  para conferir campos esperados
//Campo Esperado/Existe no Select/Tipo do campo eh caracter
AAdd(aCmp,{"RA_FILIAL" ,.F.,.F.}) 						// Filial
AAdd(aCmp,{"RA_MAT"    ,.F.,.F.})							// Matricula
AAdd(aCmp,{"RA_NOME"   ,.F.,.F.})							// Nome
AAdd(aCmp,{"RA_DESCINC",.F.,.F.})						// Descricao da ocorrencia

aStru	:= &(cTmp)->(dbStruct())
For nS 	:= 1 To Len(aStru)
	For nt := 1 to Len(aCmp)
		//Campo Existe
		If Alltrim(aStru[nS][1]) == Alltrim(aCmp[nt][1])
			aCmp[nt][2]	:= .T.		
			//Campo eh caracter
			If ( aStru[nS][2] = "C" )
				aCmp[nt][3]	:= .T.
			Endif
		Endif
	Next nt
Next nS

//mensagens inconsistencias
For ni := 1 to Len(aCmp)
	If !aCmp[ni][2]
		MsgAlert("O campo "+aCmp[ni][1]+" nao existe na Query.","Atencao!")
		lcampos := .F.		
	Elseif !aCmp[ni][3]
		MsgAlert("O campo "+aCmp[ni][1]+" deve ser tipo C-Caracter. Verifique a Query!","Atencao!")	
		lcampos := .F.				
	Endif
Next ni

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPriPerg  บAutor  ณMicrosiga           บ Data ณ  05/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPriPerg()

Local aRegs := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Filial De ?                  ','','','mv_ch1','C',02,0,0,'G','             ','mv_par01','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'02','Filial Ate ?                 ','','','mv_ch2','C',02,0,0,'G','NaoVazio     ','mv_par02','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'03','Matricula De ?               ','','','mv_ch3','C',06,0,0,'G','             ','mv_par03','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'04','Matricula Ate ?              ','','','mv_ch4','C',06,0,0,'G','NaoVazio     ','mv_par04','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'05','Centro Custo De ?            ','','','mv_ch5','C',09,0,0,'G','             ','mv_par05','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'06','Centro Custo Ate ?           ','','','mv_ch6','C',09,0,0,'G','NaoVazio     ','mv_par06','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
Aadd(aRegs,{ cPerg,'07','Tipo Geracao?                ','','','mv_ch7','N',01,0,1,'C','			  ','mv_par07','Excel','Excel','Excel','','','Relatorio','Relatorio','Relatorio','','','','','','','','','','','','','',''	,'','',''   ,'','',''})
aAdd(aRegs,{ cPerg,'08','Data Referencia?             ','','','mv_ch8','D',08,0,0,'G','NaoVazio      ','mv_par08','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'','' })

dbSelectArea("SX1")
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf_sqldeletบAutor  ณMicrosiga           บ Data ณ  05/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function f_sqldelet( aTabDel )

Local nQtde	:= Len(aTabDel)
Local nx	:= 0
Local cRet	:= ""

//-- Verifica se existe conteudo no array
If nQtde > 0
	For nx := 1 to nQtde
		If nx > 1
			cRet	+= " AND"
		Endif
		cRet	+= " "+aTabDel[nx]+".D_E_L_E_T_ = ' ' "
	Next nx
Endif

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณfG265TrocaบAutor  ณPrima Informatica   บ Data ณ  23/07/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEfetua a troca da selecao no ListBox                        บฑฑ
ฑฑบ          ณ(controle Usado/nao usado )                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fTrocaClick( aArray,		; //Array contendo os elementos para troca
cTipo  ,		; //Tipo da Multipla Selecao "M"Marca todos ; "D" Desmarca Todos; "I" Inverte Selecao
nEstou ,		; //oUso:nAt
l1Elem)        //So pode escolher um  unico elemento usado no Array (.t.)

Local nArray	:= 0
Local nX		:= 0
DEFAULT l1Elem	:= .F.

If l1Elem
	nArray:= Len(aArray)
	For nX := 1 To nArray
		IF nX == nEstou
			aArray[nEstou,1]	:= .T.
		Else
			aArray[nX,1]		:= .F.
		EndIF
	Next nX
	oAgrup:SetArray(aArray)
	oAgrup:bLine := { || {if(aArray[oAgrup:nAT,1],oOk,oNo),aArray[oAgrup:nAt,2],aArray[oAgrup:nAt,3]}}
Else
	IF cTipo == "M"
		aEval( aArray , { |x,y| aArray[y,1] := .T. } )
	ElseIF cTipo == "D"
		aEval( aArray , { |x,y| aArray[y,1] := .F. } )
	ElseIF cTipo == "I"
		aEval( aArray , { |x,y| aArray[y,1] := !aArray[y,1] } )
	Else
		aArray[nEstou,1] := !aArray[nEstou,1]
	EndIF
	
Endif

Return aArray

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelArq    บAutor  ณMicrosiga           บ Data ณ  04/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SelArq()

Local aOld := GETAREA()
Local nX   := 0
Local lRet := .T.
Local oOk  := LoadBitmap( GetResources(), "Enable" )
Local oNo  := LoadBitmap( GetResources(), "LBNO" )
Local oSelect
Local l1Elem      := .T.
Local nElemRet    := 1
Local lMultSelect := .T.
Local aDirect     := {}
Local cDirect     := Alltrim(SuperGetMv("PR_DIRFOL",.F.,"C:\TEMP\PRIMARFOL\",cFilAnt))
Local bLine      := { || .T. }
Local cLine      := ""
Local oFont3
Local oFont
Local oFont06
Local oBtnMarcTod
Local oBtnDesmTod
Local oBtnInverte
Local oGroup1
Local oListBox
Local bNIL			:= { || NIL }
Local bSvVK_F4		:= bNIL
Local bSvVK_F5		:= bNIL
Local bSvVK_F6		:= bNIL
Private aArquivos   := {}
Private cRet := ""
Private cIndTmp := Criatrab("",.f.)
Private aret	:= {}

lMsErroAuto := .F.
             
If Right(cDirect,1) <> "\"
	cDirect += "\"
Endif	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se ha TXT a processar                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aDirect := Directory( cDirect + "*.pri" )
For nX := 1 To Len( aDirect )
	Aadd( aArquivos, {.F., aDirect[nX,1]} )
Next nX
//aArquivos := aSort(aArquivos,,,{ |x,y| x[2] > y[2] } )
If Len( aArquivos ) == 0
	Aviso("ATENCAO", "Nao foi encontrado nenhum arquivo no diretorio indicado no parametro MV_DSAPGPE", {"Ok"})
	Return( .F. )
EndIf

SETAPILHA()

aTitCampos := {" ","Descricao"}
cLine := "{If(aArquivos[oListBox:nAt,1],oOk,oNo),aArquivos[oListBox:nAT][2]}"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta dinamicamente o bline do CodeBlock                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
bLine := &( "{ || " + cLine + " }" )

//-- Atualiza Array com os campos agrupados
DEFINE MSDIALOG oDlg4 FROM 05,10 TO 30.5,100 TITLE "Selecao de Arquivos"

@ 035,002 Group oGroup1 To 192,180.5 PROMPT OemToAnsi("Selecao de Arquivos") Of oDlg4 Pixel COLOR CLR_BLUE  //"Selecao de Campos"
@ 12,0 MSPANEL oPanel PROMPT "" SIZE 120,25 OF oDlg4 CENTERED LOWERED //"Botoes"
oPanel:Align := CONTROL_ALIGN_BOTTOM

oListBox := TWBrowse():New( 27,4,243,86,NIL,aTitCampos,NIL,oDlg4,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox:SetArray(aArquivos)
oListBox:bLDblClick := {|| aArquivos[oListBox:nAt][1] := !aArquivos[oListBox:nAt][1], oListBox:DrawSelect()}
oListBox:bLine := bLine
oListBox:Align := CONTROL_ALIGN_ALLCLIENT

//--  Botoes Usado/Nao Usado
@ 175,002.50 BUTTON oBtnMarcTod	PROMPT OemToAnsi("Marca Todos <F4>") FONT oFont06	SIZE 58,13 OF oDlg4	PIXEL  ; //"Marca Todos <F4>"
ACTION (aArquivos:=fTrocaClick(aArquivos,"M"),oListBox:Refresh())

bSvVK_F4 := SetKey(VK_F4,{ || (aArquivos:=fTrocaClick(aArquivos,"M"),oListBox:Refresh()) } )

@ 175,061.50 BUTTON oBtnDesmTod	PROMPT OemToAnsi("Desmarca Todos <F5>") FONT ofont06	SIZE 58,13 OF oDlg4	PIXEL ; //"Desmarca Todos <F5>"
ACTION (aArquivos:=fTrocaClick(aArquivos,"D"),oListBox:Refresh())
bSvVK_F6 := SetKey(VK_F5,{ || (aArquivos:=fTrocaClick(aArquivos,"D"),oListBox:Refresh()) } )

@ 175,121.50 BUTTON oBtnInverte	PROMPT OemToAnsi("Inverte Sele็ไo <F6>") FONT ofont06	SIZE 58,13 OF oDlg4	PIXEL ; //"Inverte Seleo <F6>"
ACTION (aArquivos:=fTrocaClick(aArquivos,"I"),oListBox:Refresh())
bSvVK_F6 := SetKey(VK_F6,{ || (aArquivos:=fTrocaClick(aArquivos,"I"),oListBox:Refresh()) } )

ACTIVATE MSDIALOG oDlg4 CENTERED ON INIT Enchoicebar(oDlg4,{|| nOpt := 1,oDlg4:End()},{|| nOpt := 3,oDlg4:End()})

SETAPILHA()

SetKey( VK_F4	,	IF( Empty( bSvVK_F4 ) , bNIL , bSvVK_F4 ) )
SetKey( VK_F5	,	IF( Empty( bSvVK_F5 ) , bNIL , bSvVK_F5 ) )
SetKey( VK_F6	,	IF( Empty( bSvVK_F6 ) , bNIL , bSvVK_F6 ) )

DeleteObject(oOk)
DeleteObject(oNo)

If !lRet
	Aviso("ATENCAO","NENHUM ARQUIVO SELECIONADO",{"Sair"})
	Return( .F. )
EndIf


//Aeval( aArquivos,{|x| cRet := If(x[1],x[2],cRet)} )
For nx := 1 to Len(aArquivos)
	If aArquivos[nx,1]
		n_Hdl    := fOpen(cDirect + "\" + aArquivos[nx,2],68)
		If n_Hdl == -1
			MsgAlert("O arquivo de nome "+cRet+" nao pode ser aberto! Verifique os parametros.","Atencao!")
			Return(Nil)
		Endif
		AAdd(aret,{cDirect + aArquivos[nx,2],aArquivos[nx,2]})
		fClose( n_Hdl )		
	Endif
Next

//Processa({|| OkLeTxt() },"Processando...")

//Close(oLeTxt)

Return(aret)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ MudaTab  ณ Autor ณ      Prima Info       ณ Data ณ 13.10.08 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Transforma as tabelas em RetSqlname                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MudaTab(_cTexto)
Local lTexto 		:= .t.
Local nPosTxt 		:= 0
Local cTitExe,LinhaCor
Local cTextoNew 	:= _cTexto
Local cTxtMemo 		:= _cTexto
Local nPipeI
Local nPipeF
Local cAnoMesAnt	:= ""
Local cAnoMesSeg	:= ""
While lTexto
	cTxtMemo  := cTextoNew
	//Procura o pipe no texto
	nPipeI := At("|",cTxtMemo)
	//Se encontrar o Pipe abrindo, procura o outro fechando
	If nPipeI > 0
		nPipeF := At("|",Subs(cTxtMemo,nPipeI + 1,10))
		//Separa a tabela e executa o RetSQLName
		If nPipeF > 0
			cTextoNew := Substr(cTxtMemo,1,nPipeI-1)
			cTextoNew += RetSqlName( Subs(AllTrim(Substr(cTxtMemo,nPipeI+1,nPipeF) ),1,3) )
			cTextoNew += Substr(cTxtMemo,nPipeI+nPipeF+1)
		Endif
	Else
		lTexto := .F.
	Endif
	Loop
Enddo

//Variavel AnoMes Anterior
If StrZero(Month(dDataRef),2) == "01"
	cAnoMesAnt := StrZero(Val(AnoMes(dDataRef))-1,4)+"12"
Else
	cAnoMesAnt := AnoMes(dDataRef)+StrZero(Month(dDataRef)-1,2)
Endif

//Variavel AnoMes Seguinte
If StrZero(Month(dDataRef),2) == "12"
	cAnoMesSeg := StrZero(Val(AnoMes(dDataRef))+1,4)+"01"
Else
	cAnoMesSeg := AnoMes(dDataRef)+StrZero(Month(dDataRef)+1,2)
Endif

//MUDA VARIAVEIS DE PARAMETROS
cTextoNew := StrTran(cTextoNew,"AMESANT",cAnoMesAnt)	
cTextoNew := StrTran(cTextoNew,"AMESSEG",cAnoMesSeg)	
cTextoNew := StrTran(cTextoNew,"MV_FOLMES",AnoMes(dDataRef))	
For x := 1 to 6
	cTextoNew := StrTran(cTextoNew,"MV_PAR"+Strzero(x,2),&("MV_PAR"+Strzero(x,2)))
Next x

Return(cTextoNew)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณfImpRel   ณ Autor ณ Prima Informatica     ณ Data ณ 10/10/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Relatorio de divergencias da Folha                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ fImpRel                                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Clientes PrimaInfo                                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fImpRel()

Local cDesc1  := "Relatorio de divergencias da Folha"
Local cDesc2  := "Sera impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := "usuario."
Local cString := ""  					// Alias do arquivo principal (Base)
Local aOrd    := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Private(Basicas)                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aReturn  := {"Zebrado",1,"Administracao",2,2,1,"",1 }	//"Zebrado"###"Administrao"
Private NomeProg := "PRIMARFOL"
Private aLinha   := {}
Private nLastKey := 0
Private aInfo     := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis Utilizadas na funcao IMPR                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private Titulo
Private AT_PRG   := "PRIMARFOL"
Private wCabec0  := 2
Private wCabec1  := "FL  MATRIC  NOME                                      SEQ  DESCRICAO INCONSITENCIA"
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "G"
Private Titulo	:= "Relacao Divergencias da Folha"
Private cTit	:= "Relacao Divergencias da Folha"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia controle para a funcao SETPRINT                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel:="PRIMARFOL"         //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

lEnd	   := .F.

cTit := " RELATORIO DE DIVERGENCIAS DA FOLHA - "
cTit += Subs(AnoMes(dDataRef),5,2)+"/"+Subs(AnoMes(dDataRef),1,4) 

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do Relatorio                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|lEnd| fImprime(@lEnd,wnRel,cString)},cTit)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfImprime  บ Autor ณ AP6 IDE            บ Data ณ  17/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ imprime o relatorio                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ /*/
Static Function fImprime()

For nX := 1 To Len(aInconsist)
	xAlias := "TMP" + StrZero(nX,3)
	
	If Select( xAlias ) == 0
		Loop
	EndIf
	
	nTotReg := 1
	dbSelectArea( xAlias )
	nTotReg := 20
	dbGoTop()
	SetRegua((xAlias)->(RecCount()))
	ProcRegua( nTotReg )
	
	Do While !Eof()
		IncRegua(aInconsist[nx,1])

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Cancela Impresฦo ao se pressionar <ALT> + <A>                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		EndIF
	
		//Imprime Registro
		cLin := (xAlias)->RA_FILIAL + Space(02)		// 01 - Filial
		cLin += (xAlias)->RA_MAT + Space(02)			// 02 - Matricula
		cLin += (xAlias)->RA_NOME + Space(02)			// 03 - Nome do Funcionario
		cLin += StrZero(nx,3)  + Space(02)			 	// 04 - Tipo da Inconsistencia
		cLin += (xAlias)->RA_DESCINC			 		// 05 - Descricao da Inconsistencia
		Impr(cLin,"C")
		dbSkip()
	EndDo
	(xAlias)->(dbCloseArea())
	Impr("","P")
Next nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Termino do Relatorio                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return