#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "fileio.ch"
#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPRIMARVP12บAutor  ณPrima Informatica   บ Data ณ  25/11/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Verbas Protheus 12                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณClientes Prima Informatica                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PRIMARVP12

// Declaracao de Variaveis
Private cPerg    := "PRIMARVP12"
Private cString  := "SRA"
Private oGeraTxt

fPriPerg()
pergunte(cPerg,.F.)

dbSelectArea( "SRA" )
dbSetOrder( 1 )

// Montagem da tela de processamento.
DEFINE MSDIALOG oGeraTxt FROM  200,001 TO 410,480 TITLE OemToAnsi( "Relatorio de Verbas Protheus 12" ) PIXEL
@ 002, 010 TO 095, 230 OF oGeraTxt  PIXEL
@ 010, 018 SAY " Este programa ira gerar o relatorio de verbas da folha         " SIZE 200, 007 OF oGeraTxt PIXEL
@ 018, 018 SAY " Conforme Parametros do usuario.                               " SIZE 200, 007 OF oGeraTxt PIXEL
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

Pergunte(cPerg,.F.)

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

Local cDirDocs    := MsDocPath()
Local cPath       := AllTrim( GetTempPath() )

Local oExcelApp
Local n_Conta	:= 0
Local xz,xg
Private cLin, nTotReg
Private nHdl
Private c_Rot 		:= fSqlIn(mv_par03,3)
Private c_Per 		:= mv_par01
Private c_NumPg		:= mv_par02
Private c_Verbas	:= Alltrim(mv_par04)
Private n_Verbas	:= Len(c_Verbas) / 3
Private cFilDe    	:= mv_par05
Private cFilAte   	:= mv_par06
Private cMatDe    	:= mv_par07
Private cMatAte   	:= mv_par08
Private cCcDe     	:= mv_par09
Private cCcAte    	:= mv_par10
Private c_Situaca   := fSqlIn(mv_par11,1)
Private c_Categ     := fSqlIn(mv_par12,1)
Private n_Tipo		:= mv_par13
Private n_Gera		:= mv_par14
Private a_Verbas	:= {}
Private cNomeArq  	:= ""
Private c_PDS		:= fSqlIN(c_Verbas,3)	//Verbas
Private a_Cabec		:= ""
Private n_ImpTot	:= mv_par15
Private n_AnaSin	:= mv_par16
Private n_SaltaCC	:= mv_par17
Private n_SaltaFil	:= mv_par18
Private n_ImprEmp	:= mv_par19
Private n_TpVH		:= mv_par20

//Prepara arquivo em excel
If n_Gera == 1
	
	//Se excel, somente analitico
	If n_AnaSin = 2
		MsgAlert("Para geracao em Excel, escolha opcao analitrico")
		Return
	Endif
	
	cNomeArq  	:= CriaTrab(,.F.) + ".CSV"
	// Cria Arquivo Texto
	nHdl := fCreate( cDirDocs + "\" + cNomeArq )
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	EndIf
	
	//Carrega Cabecalho Basico
	a_Cabec := {"FILIAL","MATRICULA","CENTRO DE CUSTO","DESCR.CCUSTO","NOME","ADMISSAO","DEMISSAO","SIT","CAT","PROCESSO","PERIODO","ROT","PGT"}
	
	
	//Carrega Verbas a Gerar
	n_Conta := 1
	For xz := 1 to n_Verbas
		AAdd(a_Verbas,Subs(c_Verbas,n_Conta,3))
		
		//Consiste Verbas e Adiciona Descricao no Array
		dbSelectArea("SRV")
		dbSetorder(1)
		If !dbSeek(xFilial("SRV")+Subs(c_Verbas,n_Conta,3))
			MsgAlert("Verba "+Subs(c_Verbas,n_Conta,3) + " nao existe no cadastro de Verbas. Verifique!")
			Return
		Endif
		
		AAdd(a_Cabec,Subs(c_Verbas,n_Conta,3)+" "+ Alltrim(SRV->RV_DESC))
		
		n_Conta := n_Conta + 3
	Next xz
	
	If n_ImpTot = 1
		AAdd(a_Cabec,"TOTAL")
	Endif
	
	
	//Faz a Query
	MsAguarde( {|| fGeraTrab()}, "Gerando Planilha Excel...", ""  )
	
	dbSelectArea("WTPM")
	If !WTPM->(Eof())
		// Grava Cabecalho do Arquivo Texto
		cLin := ""
		For xg := 1 to Len(a_Cabec)
			cLin += a_Cabec[xg] + cSep
		Next
		cLin += cEol
		fGravaTxt( cLin )
		
		//Varre a Query
		nTotReg := 0
		ProcRegua( nTotReg )
		While !WTPM->(Eof())
			IncProc( WTPM->FILIAL + "-"+ WTPM->MATRIC+"-"+WTPM->NOME)
			
			cLin := ""
			cLin += WTPM->FILIAL + cSep
			cLin += WTPM->MATRIC + cSep
			cLin += WTPM->CCUSTO + cSep
			cLin += WTPM->DESCCC + cSep
			cLin += WTPM->NOME + cSep
			cLin += DTOC(STOD(WTPM->ADMISSA)) + cSep
			cLin += DTOC(STOD(WTPM->DEMISSA)) + cSep
			cLin += WTPM->SITFOLH + cSep
			cLin += WTPM->CAT + cSep
			cLin += WTPM->PROCESSO + cSep
			cLin += WTPM->PERIODO + cSep
			cLin += WTPM->ROTEIRO + cSep
			cLin += WTPM->SEMANA + cSep
			n_total := 0
			For xg := 1 to Len(a_Verbas)
				cLin += Transform(&("WTPM->VB"+a_Verbas[xg]),"@E 9,999,999.99") + cSep
				If n_ImpTot = 1
					n_total += &("WTPM->VB"+a_Verbas[xg])
				Endif
			Next xg
			If n_ImpTot = 1
				cLin += Transform(n_total,"@E 9,999,999.99") + cSep
			Endif
			
			cLin += cEol
			fGravaTxt( cLin )
			WTPM->(dbSkip())
		Enddo
		
		fClose( nHdl )
		
		MsAguarde( {|| fStartExcel( cDirDocs, cNomeArq, cPath )}, "Aguarde...", "Gerando Relatorio..." )
		
		//Relatorio
		WTPM->(dbCloseArea())
	Else
		WTPM->(dbCloseArea())
	Endif
Else
	fImpRel()
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
Static Function fGeraTrab()

Local cQuery := ""
Local xg
//RGB
If n_Tipo == 1
	cQuery  += " SELECT DISTINCT RA_FILIAL FILIAL,RA_CC CCUSTO,CTT_DESC01 DESCCC,RA_MAT MATRIC,RA_NOME NOME,RA_ADMISSA ADMISSA,RA_DEMISSA DEMISSA,RA_SITFOLH SITFOLH,RA_CATFUNC CAT,RA_PROCES PROCESSO, RGB_PERIOD PERIODO, RGB_ROTEIR ROTEIRO, RGB_SEMANA SEMANA"
	For xg := 1 to len(a_Verbas)
		cQuery  += " ,nvl((SELECT SUM(RGB_"+IIf(n_TpVH = 2,"HORAS","VALOR")+") FROM "+RetSqlName("RGB")+" C WHERE C.D_E_L_E_T_ = ' ' AND RGB_FILIAL = RA_FILIAL AND RGB_MAT = RA_MAT AND C.RGB_PERIOD = B.RGB_PERIOD AND C.RGB_ROTEIR = B.RGB_ROTEIR AND  C.RGB_SEMANA = B.RGB_SEMANA AND RGB_PD = '"+a_Verbas[xg]+"'),0) VB"+a_Verbas[xg]
	Next xg
	cQuery  += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("RGB")+"  B, "+RetSqlName("CTT")+" C"
	cQuery  += " WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' AND C.D_E_L_E_T_ = ' '
	cQuery  += " AND RA_FILIAL = RGB_FILIAL
	cQuery  += " AND RA_MAT = RGB_MAT
	cQuery  += " AND RGB_PERIOD = '"+c_Per+"'
	cQuery  += " AND RGB_ROTEIR IN (" + c_Rot + ") "  //= '"+c_Rot+"'
	cQuery  += " AND RGB_SEMANA = '"+c_NumPg+"'
	cQuery  += " AND RGB_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
	cQuery  += " AND RGB_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"'"
	cQuery  += " AND RA_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"'"
	cQuery  += " AND RA_SITFOLH IN (" + c_Situaca + ") "
	cQuery  += " AND RA_CATFUNC IN (" + c_Categ + ") "
	cQuery  += " AND RGB_PD IN (" + c_PDS + ") "
	cQuery  += " AND CTT_CUSTO = RA_CC
	
	//SRC
ElseIf n_Tipo == 2
	cQuery  += " SELECT DISTINCT RA_FILIAL FILIAL,RA_CC CCUSTO,CTT_DESC01 DESCCC,RA_MAT MATRIC,RA_NOME NOME,RA_ADMISSA ADMISSA,RA_DEMISSA DEMISSA,RA_SITFOLH SITFOLH,RA_CATFUNC CAT,RA_PROCES PROCESSO, RC_PERIODO PERIODO, RC_ROTEIR ROTEIRO, RC_SEMANA SEMANA"
	For xg := 1 to len(a_Verbas)
		cQuery  += " ,nvl((SELECT SUM(RC_"+IIf(n_TpVH = 2,"HORAS","VALOR")+") FROM "+RetSqlName("SRC")+" C WHERE C.D_E_L_E_T_ = ' ' AND RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT AND C.RC_PERIODO = B.RC_PERIODO AND C.RC_ROTEIR = B.RC_ROTEIR AND  C.RC_SEMANA = B.RC_SEMANA AND RC_PD = '"+a_Verbas[xg]+"'),0) VB"+a_Verbas[xg]
	Next xg
	cQuery  += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRC")+"  B, "+RetSqlName("CTT")+" C"
	cQuery  += " WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' AND C.D_E_L_E_T_ = ' '
	cQuery  += " AND RA_FILIAL = RC_FILIAL
	cQuery  += " AND RA_MAT = RC_MAT
	cQuery  += " AND RC_PERIODO = '"+c_Per+"'
	cQuery  += " AND RC_ROTEIR IN (" + c_Rot + ") "  //= '"+c_Rot+"'
	cQuery  += " AND RC_SEMANA = '"+c_NumPg+"'
	cQuery  += " AND RC_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
	cQuery  += " AND RC_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"'"
	cQuery  += " AND RA_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"'"
	cQuery  += " AND RA_SITFOLH IN (" + c_Situaca + ") "
	cQuery  += " AND RA_CATFUNC IN (" + c_Categ + ") "
	cQuery  += " AND RC_PD IN (" + c_PDS + ") "
	cQuery  += " AND CTT_CUSTO = RA_CC
	//SRD
ElseIf n_Tipo == 3
	cQuery  += " SELECT DISTINCT RA_FILIAL FILIAL,RA_CC CCUSTO,CTT_DESC01 DESCCC,RA_MAT MATRIC,RA_NOME NOME,RA_ADMISSA ADMISSA,RA_DEMISSA DEMISSA,RA_SITFOLH SITFOLH,RA_CATFUNC CAT,RA_PROCES PROCESSO, RD_PERIODO PERIODO, RD_ROTEIR ROTEIRO, RD_SEMANA SEMANA"
	For xg := 1 to len(a_Verbas)
		cQuery  += " ,nvl((SELECT SUM(RD_"+IIf(n_TpVH = 2,"HORAS","VALOR")+") FROM "+RetSqlName("SRD")+" C WHERE C.D_E_L_E_T_ = ' ' AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND C.RD_PERIODO = B.RD_PERIODO AND C.RD_ROTEIR = B.RD_ROTEIR AND  C.RD_SEMANA = B.RD_SEMANA AND RD_PD = '"+a_Verbas[xg]+"'),0) VB"+a_Verbas[xg]
	Next xg
	cQuery  += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRD")+"  B, "+RetSqlName("CTT")+" C"
	cQuery  += " WHERE A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' AND C.D_E_L_E_T_ = ' '
	cQuery  += " AND RA_FILIAL = RD_FILIAL
	cQuery  += " AND RA_MAT = RD_MAT
	cQuery  += " AND RD_PERIODO = '"+c_Per+"'
	cQuery  += " AND RD_ROTEIR IN (" + c_Rot + ") "  //= '"+c_Rot+"'
	cQuery  += " AND RD_SEMANA = '"+c_NumPg+"'
	cQuery  += " AND RD_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
	cQuery  += " AND RD_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"'"
	cQuery  += " AND RA_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"'"
	cQuery  += " AND RA_SITFOLH IN (" + c_Situaca + ") "
	cQuery  += " AND RA_CATFUNC IN (" + c_Categ + ") "
	cQuery  += " AND RD_PD IN (" + c_PDS + ") "
	cQuery  += " AND CTT_CUSTO = RA_CC
	
Endif
If n_Gera == 1
	cQuery  += " ORDER BY 1,4
Else
	If nOrdem = 1
		cQuery  += " ORDER BY 1,4
	Elseif nOrdem = 2
		cQuery  += " ORDER BY 1,5
	Elseif nOrdem = 3
		cQuery  += " ORDER BY 1,2,4
	Elseif nOrdem = 4
		cQuery  += " ORDER BY 1,2,5
	Endif
Endif
TCQuery cQuery New Alias "WTPM"

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
Local j,i

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Periodo             ?','','','mv_ch1','C',06,0,0,'G',''				,'mv_par01','' ,'','','','','','','','','','','','','','','','','','','','','','','' ,'RCH','' })
aAdd(aRegs,{ cPerg,'02','Num.Pagto           ?','','','mv_ch2','C',02,0,0,'G',''				,'mv_par02','' ,'','','','','','','','','','','','','','','','','','','','','','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'03','Roteiros            ?','','','mv_ch3','C',30,0,0,'G','fRoteiro'   	,'mv_par03','' ,'','','','','','','','','','','','','','','','','','','','','','','' ,'SRY','' })
aAdd(aRegs,{ cPerg,'04','Verbas              ?','','','mv_ch4','C',90,0,0,'G',''				,'mv_par04','' ,'','','','','','','','','','','','','','','','','','','','','','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'05','Filial De ?          ','','','mv_ch5','C',02,0,0,'G','             '	,'mv_par05','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'06','Filial Ate ?         ','','','mv_ch5','C',02,0,0,'G','NaoVazio     '	,'mv_par06','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0','' })
aAdd(aRegs,{ cPerg,'07','Matricula De ?       ','','','mv_ch7','C',06,0,0,'G','             '	,'mv_par07','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'08','Matricula Ate ?      ','','','mv_ch8','C',06,0,0,'G','NaoVazio     '	,'mv_par08','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA','' })
aAdd(aRegs,{ cPerg,'09','Centro Custo De ?    ','','','mv_ch9','C',09,0,0,'G','             '	,'mv_par09','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'10','Centro Custo Ate ?   ','','','mv_cha','C',09,0,0,'G','NaoVazio     '	,'mv_par10','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT','' })
aAdd(aRegs,{ cPerg,'11','Situacoes           ?','','','mv_chb','C',05,0,0,'G','fSituacao  ','mv_par11','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
aAdd(aRegs,{ cPerg,'12','Categorias          ?','','','mv_chc','C',15,0,0,'G','fCategoria ','mv_par12','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
Aadd(aRegs,{ cPerg,'13','Relatorio de         ','','','mv_chd','N',01,0,1,'C','			  '	,'mv_par13','RGB-Lancamentos','RGB-Lancamentos','RGB-Lancamentos','','','SRC-Calculo','SRC-Calculo','SRC-Calculo','','','SRD-Acumulado','SRD-Acumulado','SRD-Acumulado','','','','','','','','',''	,'','',''   ,'','',''})
Aadd(aRegs,{ cPerg,'14','Tipo Geracao         ','','','mv_che','N',01,0,1,'C','			  '	,'mv_par14','Excel','Excel','Excel','','','Relatorio','Relatorio','Relatorio','','','','','','','','','','','','','',''	,'','',''   ,'','',''})
Aadd(aRegs,{ cPerg,'15','Coluna Total        ?','','','mv_chf','N',01,0,1,'C','			  '	,'mv_par15','Sim','Sim','Sim','','','Nao','Nao','Nao','','','','','','','','','','','','','',''	,'','',''   ,'','',''})
Aadd(aRegs,{ cPerg,'16','Analitico/Sintetico ?','','','mv_chg','N',01,0,1,'C','			  '	,'mv_par16','Analitico','Analitico','Analitico','','','Sintetico','Sintetico','Sintetico','','','','','','','','','','','','','',''	,'','',''   ,'','',''})
Aadd(aRegs,{ cPerg,'17','Salta Pagina C.Custo?','','','mv_chh','N',01,0,1,'C','			  '	,'mv_par17','Sim','Sim','Sim','','','Nao','Nao','Nao','','','','','','','','','','','','','',''	,'','',''   ,'','',''})
Aadd(aRegs,{ cPerg,'18','Salta Pagina Filial ?','','','mv_chi','N',01,0,1,'C','			  '	,'mv_par18','Sim','Sim','Sim','','','Nao','Nao','Nao','','','','','','','','','','','','','',''	,'','',''   ,'','',''})
Aadd(aRegs,{ cPerg,'19','Impr. Total Empresa ?','','','mv_chj','N',01,0,1,'C','			  '	,'mv_par19','Sim','Sim','Sim','','','Nao','Nao','Nao','','','','','','','','','','','','','',''	,'','',''   ,'','',''})
Aadd(aRegs,{ cPerg,'20','Valor/Horas          ','','','mv_chk','N',01,0,1,'C','			  '	,'mv_par20','Valor','Valor','Valor','','','Horas','Horas','Horas','','','','','','','','','','','','','',''	,'','',''   ,'','',''})

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
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณfImpRel   ณ Autor ณ Prima Informatica     ณ Data ณ 10/10/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Relatorio de verbas da Folha                               ณฑฑ
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

Local cDesc1  := "Relatorio de verbas da Folha"
Local cDesc2  := "Sera impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := "usuario."
Local cString := "SRA"  					// Alias do arquivo principal (Base)
Local aOrd    := {"Matricula","Nome","Centro Custo + Matricula","Centro Custo + Nome"}
Local xz

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis Private(Basicas)                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aReturn  := {"Zebrado",1,"Administracao",2,2,1,"",1 }	//"Zebrado"###"Administrao"
Private NomeProg := "PRIMARVP12"
Private nLastKey := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis Utilizadas na funcao IMPR                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private AT_PRG   := "PRIMARVP12"
Private wCabec0  := 2
Private wCabec1  := "FIL MATRIC  CENTRO DE CUSTO                            NOME                            ADMISSAO  DEMISSAO  SIT CAT PROC.  ROT  "
Private wCabec2  := Repl(" ",Len(wCabec1))
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "G"
Private Titulo	:= "Relacao Verbas da Folha. Roteiro:"+ c_Rot +" - Periodo:"+ c_Per + " - Num.Pagto:" + c_NumPg
Private cTit	:= "Relacao Verbas da Folha. Roteiro:"+ c_Rot +" - Periodo:"+ c_Per + " - Num.Pagto:" + c_NumPg

If n_Verbas > 6
	MsgAlert("Nao e permitido mais de 6 verbas no formato relatorio. Escolha opcao Excel")
	Return
Endif

//Carrega Verbas a Gerar
n_Conta := 1
For xz := 1 to n_Verbas
	AAdd(a_Verbas,Subs(c_Verbas,n_Conta,3))
	wCabec1 += "    VERBA "+ Subs(c_Verbas,n_Conta,3)
	
	//Consiste Verbas e Adiciona Descricao no Array
	dbSelectArea("SRV")
	dbSetorder(1)
	If !dbSeek(xFilial("SRV")+Subs(c_Verbas,n_Conta,3))
		MsgAlert("Verba "+Subs(c_Verbas,n_Conta,3) + " nao existe no cadastro de Verbas. Verifique!")
		Return
	Endif
	
	wCabec2 += " "+Padr(SRV->RV_DESC,12)
	
	n_Conta := n_Conta + 3
Next xz

If n_ImpTot = 1
	wCabec1 += Space(08)+"TOTAL"
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia controle para a funcao SETPRINT                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel:="PRIMARVP12"         //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho,,.F.)

lEnd	   := .F.
cTit := " RELATORIO DE VERBAS DA FOLHA - "

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define a Ordem do Relatorio                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nOrdem := aReturn[8]

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do Relatorio                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|lEnd| fImprx(@lEnd,wnRel,cString)},cTit)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfImprx    บ Autor ณ AP6 IDE            บ Data ณ  17/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ imprime o relatorio                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ /*/
Static Function fImprx()

Local a_totFil 	:= {}
Local a_totEmp 	:= {}
Local a_totCC  	:= {}
Local c_FilAnt	:= ""
Local c_CCAnt	:= ""
Local aInfo		:= {}
Local c_DesCC	:= ""
Local xg

//Faz a Query
MsAguarde( {|| fGeraTrab()}, "Gerando Relatorio...", ""  )

nTotReg := 1
SetRegua(WTPM->(RecCount()))
ProcRegua( 20 )

c_FilAnt	:= WTPM->FILIAL
c_CCAnt		:= WTPM->FILIAL + WTPM->CCUSTO
a_totFil 	:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}//Tamanho 30 - Maximo
a_totEmp 	:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}//Tamanho 30 - Maximo
a_totCC  	:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}//Tamanho 30 - Maximo


While !WTPM->(Eof())
	IncRegua(WTPM->FILIAL + "-"+ WTPM->MATRIC+"-"+WTPM->NOME)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cancela Impresฦo ao se pressionar <ALT> + <A>                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIF
	
	//Imprime Registro
	cLin := ""
	cLin += WTPM->FILIAL + Space(02)
	cLin += WTPM->MATRIC + Space(02)
	cLin += Padr(Alltrim(WTPM->CCUSTO) + Space(01) + WTPM->DESCCC,41) + Space(02)
	c_DesCC := Alltrim(WTPM->CCUSTO) + Space(01) + WTPM->DESCCC
	cLin += Subs(WTPM->NOME,1,30) + Space(02)
	cLin += Subs(WTPM->ADMISSA,7,2)+"/"+Subs(WTPM->ADMISSA,5,2)+"/"+Subs(WTPM->ADMISSA,3,2) + Space(02)
	cLin += Subs(WTPM->DEMISSA,7,2)+"/"+Subs(WTPM->DEMISSA,5,2)+"/"+Subs(WTPM->DEMISSA,3,2) + Space(03)
	cLin += WTPM->SITFOLH + Space(03)
	cLin += WTPM->CAT + Space(02)
	cLin += WTPM->PROCESSO + Space(02)
	cLin += WTPM->ROTEIRO + Space(02)
	n_total := 0
	For xg := 1 to n_Verbas
		cLin += Transform(&("WTPM->VB"+a_Verbas[xg]),"@E 99,999,999.99")
		If n_ImpTot = 1
			n_total += &("WTPM->VB"+a_Verbas[xg])
		Endif
		
		//Total da Empresa
		a_totEmp[xg] += &("WTPM->VB"+a_Verbas[xg])
		
		//Total da Filial
		a_totFil[xg] += &("WTPM->VB"+a_Verbas[xg])
		
		//Total do Centro de Custo
		If nOrdem = 3 .Or. nOrdem = 4
			a_totCC[xg] += &("WTPM->VB"+a_Verbas[xg])
		Endif
	Next xg
	If n_ImpTot = 1
		cLin += Transform(n_total,"@E 99,999,999.99")
	Endif
	If n_AnaSin	== 1
		Impr(cLin,"C")
	Endif
	WTPM->(dbSkip())
	
	//Imprime Total do Centro de Custo
	If nOrdem = 3 .Or. nOrdem = 4
		
		n_total := 0
		
		If c_CCAnt <> WTPM->FILIAL + WTPM->CCUSTO .Or. WTPM->(Eof())
			cLin := Repl("-",220)
			Impr(cLin,"C")
			cLin := Padr("Total Centro de Custo: " + Alltrim(c_DesCC),127)
			For xg := 1 to n_Verbas
				cLin += Transform(a_totCC[xg],"@E 99,999,999.99")
				If n_ImpTot = 1
					n_total += a_totCC[xg]
				Endif
			Next xg
			If n_ImpTot = 1
				cLin += Transform(n_total,"@E 99,999,999.99")
			Endif
			Impr(cLin,"C")
			cLin := Repl("-",220)
			Impr(cLin,"C")
			c_CCAnt := WTPM->FILIAL + WTPM->CCUSTO
			a_totCC 	:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}//Tamanho 30 - Maximo
			If n_SaltaCC == 1
				Impr("","P")
			Endif
		Endif
	Endif
	//Imprime Total da Filial
	n_total := 0
	If c_FilAnt	<> WTPM->FILIAL .Or. WTPM->(Eof())
		If fInfo(@aInfo,c_FilAnt)
			cLin := Repl("-",220)
			Impr(cLin,"C")
			cLin := Padr("Total da Filial: " + c_FilAnt + "-" + Alltrim(aInfo[01]),127)
			For xg := 1 to n_Verbas
				cLin += Transform(a_totFil[xg],"@E 99,999,999.99")
				If n_ImpTot = 1
					n_total += a_totFil[xg]
				Endif
			Next xg
			If n_ImpTot = 1
				cLin += Transform(n_total,"@E 99,999,999.99")
			Endif
			Impr(cLin,"C")
			cLin := Repl("-",220)
			Impr(cLin,"C")
			c_FilAnt	:= WTPM->FILIAL
			a_totFil 	:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}//Tamanho 30 - Maximo
			
			If n_SaltaFil == 1
				Impr("","P")
			Endif
			
		Endif
	Endif
	
	n_total := 0
	If WTPM->(Eof()) .And. n_ImprEmp == 1
		//Total da Empresa
		cLin := Repl("-",220)
		Impr(cLin,"C")
		cLin := Padr("Total da Empresa: "+Alltrim(aInfo[03]),127)
		For xg := 1 to n_Verbas
			cLin += Transform(a_totEmp[xg],"@E 99,999,999.99")
			If n_ImpTot = 1
				n_total += a_totEmp[xg]
			Endif
			
		Next xg
		If n_ImpTot = 1
			cLin += Transform(n_total,"@E 99,999,999.99")
		Endif
		
		Impr(cLin,"C")
		cLin := Repl("-",220)
		Impr(cLin,"C")
	Endif
EndDo

WTPM->(dbCloseArea())
Impr("","P")

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
