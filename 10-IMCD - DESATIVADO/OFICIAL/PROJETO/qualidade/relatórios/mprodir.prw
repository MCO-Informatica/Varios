#INCLUDE "PROTHEUS.CH"
#include 'msmgadd.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณIvan Morelatto Tore บ Data ณ  11/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Apresenta o ProDir da Makeni                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Void                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MPRODIR

	Local nOpcA       := 0
	Local aSays       := {}
	Local aButtons    := {}                                                                 	
	Local cCadastro   := "Indicadores PRODIR"
	Local cPerg       := "MPRODIR"
	Local aPergs := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MPRODIR" , __cUserID )

	aAdd( aPergs, { "Ano Referencia (AAAA)   ?","Ano Referencia (AAAA)    ","Ano Referencia (AAAA)    ","mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	Pergunte( cPerg, .F.)

	aAdd( aSays, "Essa rotina apresenta dos Indicadores PRODIR" )
	aAdd( aSays, "Especifico - "+SM0->M0_NOMECOM )

	aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T.) } } )
	aAdd( aButtons, { 1, .T., { || ( FechaBatch(), nOpcA := 1 ) } } )
	aAdd( aButtons, { 2, .T., { || FechaBatch() } } )
	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1
		Processa( { || MPRODIRProc() }, "Gerando Informa็๕es..." )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณIvan Morelatto Tore บ Data ณ  11/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Apresenta o ProDir da Makeni                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Void                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MPRODIRProc

	Local oTree
	Local oDlg
	Local oFont
	Local oPanel

	Local aSize     := MsAdvSize()
	Local nTop      := 23
	Local nLeft     := 5
	Local nBottom   := aSize[6]
	Local nRight    := aSize[5]
	LOCAL nOldEnch	:= 1

	LOCAL aEnch[20]
	Local bChange 	:= {|| Nil }
	Local aButtons	:= {}

	Local cCadastro := "Indicadores PRODIR"

	Local aInfo		:=  {}
	Local lEdit		:= .F.

	Local aButtons	:= { 	{ PmsBExcel()[1], { || PDExcel( oTree, aDados ) }, "Excel", "Excel" },; 
	{ PmsBExcel()[1], { || PDDetal( oTree ) }		 , "Detalhes", "Detalhes" },;
	{ "NOTE"		, { || PDIncApr( oTree ) }		 , "Inc. Aprov.", "Inc. Aprov." },;
	{ "S4WB007N"	, { || PDVisApr( oTree ) }   	 , "Vis. Aprov.", "Vis. Aprov." } }

	Local aDados := {}

	CarregaSM0( aInfo )
	RegToMemory( "SM0", .F., .F., .F. )

	DEFINE FONT oFont NAME "Arial" SIZE 0, -10
	DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd PIXEL FROM nTop, nLeft TO nBottom, nRight

	oFolder := TFolder():New( 12, 0, {"Dados"}, {}, oDlg,,,, .T., .F., nRight-nLeft, nBottom-nTop-12, )
	oFolder:aDialogs[1]:oFont := oDlg:oFont

	oPanel := TPanel():New(2,160,'',oFolder:aDialogs[1], oDlg:oFont, .T., .T.,, ,(nRight-nLeft)/2-160,((nBottom-nTop)/2)-25,.T.,.T. )

	lOneColumn 		:= If((nRight-nLeft)/2-178>312,.F.,.T.)

	aEnch[1]		:= MsMGet():New( "SM0", SM0->(RecNo()),2,,,,,{0,0,((nBottom-nTop)/2)-25,(nRight-nLeft)/2-160},,,,,,oPanel,,,.T.,,,,aInfo,{ 'Dados Gerais', 'Endere็o Fiscal/Entrega', 'Endereco de Cobran็a', 'Complementos', 'Adicionais'} )

	oTree 			:= dbTree():New(2, 2,((nBottom-nTop)/2)-24,159,oFolder:aDialogs[1],,,.T.)
	oTree:bChange 	:= {|| ProDirDlgV( @oTree, @aEnch, {0,0,((nBottom-nTop)/2)-24,(nRight-nLeft)/2-160}, @nOldEnch, @oPanel, aInfo, nTop, nLeft, nBottom, nRight, @aDados ) }

	oTree:lShowHint	:= .F.
	oTree:SetFont(oFont)

	MPRODIRTree( @oTree )

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,aButtons)

	Release Object oTree

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  04/13/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MPRODIRTree( oTree )

	Local cOldCargo	:= oTree:GetCargo()

	oTree:BeginUpdate()
	oTree:TreeSeek("")
	oTree:AddItem( SM0->M0_NOMECOM + Space(30), "01SM0" + StrZero( SM0->( Recno() ), 12 ), "PMSEDT3", "PMSEDT3", , , 1 )

	oTree:TreeSeek( "01SM0" + StrZero( SM0->(Recno() ), 12 ) )
	oTree:AddItem( "Requisitos Legais", "02SM0" + StrZero( 0, 12 ), "PMSEDT3", "PMSEDT3", , , 2 )

	oTree:TreeSeek( "02SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Cadastro", "02SM0" + StrZero( 1, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "01SM0" + StrZero( SM0->(Recno() ), 12 ) )
	oTree:AddItem( "Gerenciamento de Risco", "03SM0" + StrZero( 0, 12 ), "PMSEDT3", "PMSEDT3", , , 2 )

	oTree:TreeSeek( "03SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Acidentes", "03SM0" + StrZero( 1, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "03SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Perdas", "03SM0" + StrZero( 2, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "03SM0" + StrZero( 2, 12 ) )
	oTree:AddItem( "Cadastro", "03SM0" + StrZero( 9, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "03SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Resํduos", "03SM0" + StrZero( 3, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "01SM0" + StrZero( SM0->(Recno() ), 12 ) )
	oTree:AddItem( "Treinamento", "04SM0" + StrZero( 0, 12 ), "PMSEDT3", "PMSEDT3", , , 2 )

	oTree:TreeSeek( "04SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Cadastro - Horas Treinamento Terceiros", "04SM0" + StrZero( 1, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "01SM0" + StrZero( SM0->(Recno() ), 12 ) )
	oTree:AddItem( "Intera็ใo com Comunidade", "05SM0" + StrZero( 0, 12 ), "PMSEDT3", "PMSEDT3", , , 2 )

	oTree:TreeSeek( "05SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Cadastro", "05SM0" + StrZero( 1, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "01SM0" + StrZero( SM0->(Recno() ), 12 ) )
	oTree:AddItem( "Consumo", "06SM0" + StrZero( 0, 12 ), "PMSEDT3", "PMSEDT3", , , 2 )

	oTree:TreeSeek( "06SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Cadastro", "06SM0" + StrZero( 1, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "01SM0" + StrZero( SM0->(Recno() ), 12 ) )
	oTree:AddItem( "Embalagens", "07SM0" + StrZero( 0, 12 ), "PMSEDT3", "PMSEDT3", , , 2 )

	oTree:TreeSeek( "01SM0" + StrZero( SM0->(Recno() ), 12 ) )
	oTree:AddItem( "Transportes", "08SM0" + StrZero( 0, 12 ), "PMSEDT3", "PMSEDT3", , , 2 )

	oTree:TreeSeek( "08SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Cadastro - Check Lists Efetuados", "08SM0" + StrZero( 1, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "08SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Cadastro - Check Lists Reprovados", "08SM0" + StrZero( 2, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "01SM0" + StrZero( SM0->(Recno() ), 12 ) )
	oTree:AddItem( "Vendas", "09SM0" + StrZero( 0, 12 ), "PMSEDT3", "PMSEDT3", , , 2 )

	oTree:TreeSeek( "01SM0" + StrZero( SM0->(Recno() ), 12 ) )
	oTree:AddItem( "Incidentes", "10SM0" + StrZero( 0, 12 ), "PMSEDT3", "PMSEDT3", , , 2 )

	oTree:TreeSeek( "01SM0" + StrZero( SM0->(Recno() ), 12 ) )
	oTree:AddItem( "Anแlise de Desempenho", "11SM0" + StrZero( 0, 12 ), "PMSEDT3", "PMSEDT3", , , 2 )

	oTree:TreeSeek( "11SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Cadastro", "11SM0" + StrZero( 1, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "01SM0" + StrZero( SM0->(Recno() ), 12 ) )
	oTree:AddItem( "Outros Indicadores", "12SM0" + StrZero( 0, 12 ), "PMSEDT3", "PMSEDT3", , , 2 )

	oTree:TreeSeek( "12SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Resumo de Movimenta็ใo do RH", "12SM0" + StrZero( 1, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "12SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Identifica็ใo de forma็ใo", "12SM0" + StrZero( 2, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "12SM0" + StrZero( 0, 12 ) )
	oTree:AddItem( "Ensaios efetuados durante o ano", "12SM0" + StrZero( 3, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "12SM0" + StrZero( 3, 12 ) )
	oTree:AddItem( "Ensaios Realizados por M๊s", "12SM0" + StrZero( 1231, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "12SM0" + StrZero( 1231, 12 ) )
	oTree:AddItem( "Cadastro", "12SM0" + StrZero( 1239, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:TreeSeek( "12SM0" + StrZero( 3, 12 ) )
	oTree:AddItem( "Ensaios Realizados por Ano", "12SM0" + StrZero( 1232, 12 ), "PMSDOC", "PMSDOC", , , 2 )

	oTree:EndUpdate()
	oTree:Refresh()

	oTree:TreeSeek( "01SM0" + StrZero( SM0->(Recno() ), 12 ) )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  04/13/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CarregaSM0( aInfo )

	Local nI

	ADD FIELD aInfo	TITULO "Empresa" 					CAMPO "M0_CODIGO"	TIPO "C" TAMANHO 02 DECIMAL 0 VALID xCFGVldEmpFil(M->M0_CODIGO,M->M0_CODFIL) OBRIGAT NIVEL 1 FOLDER 1 WHEN lEdit
	ADD FIELD aInfo	TITULO "Filial"  					CAMPO "M0_CODFIL"	TIPO "C" TAMANHO 02 DECIMAL 0 VALID xCFGVldEmpFil(M->M0_CODIGO,M->M0_CODFIL) OBRIGAT NIVEL 1 FOLDER 1 WHEN lEdit
	ADD FIELD aInfo	TITULO "Nome" 						CAMPO "M0_NOME"		TIPO "C" TAMANHO 15 DECIMAL 0 OBRIGAT NIVEL 1 FOLDER 1 WHEN lEdit
	ADD FIELD aInfo	TITULO "Filial" 					CAMPO "M0_FILIAL"	TIPO "C" TAMANHO 15 DECIMAL 0 OBRIGAT NIVEL 1 FOLDER 1 WHEN lEdit
	ADD FIELD aInfo	TITULO "Nome Completo da Empresa" 	CAMPO "M0_NOMECOM"	TIPO "C" TAMANHO 40 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 1
	ADD FIELD aInfo	TITULO "Telefone"					CAMPO "M0_TEL"		TIPO "C" TAMANHO 14 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 1
	ADD FIELD aInfo	TITULO "FAX"						CAMPO "M0_FAX"		TIPO "C" TAMANHO 14 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 1
	ADD FIELD aInfo	TITULO "Equipe"						CAMPO "M0_EQUIP"		TIPO "C" TAMANHO 01 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 1
	ADD FIELD aInfo	TITULO "CGC/CNPJ"					CAMPO "M0_CGC"		TIPO "C" TAMANHO 14 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 1
	ADD FIELD aInfo	TITULO "Inscri็ใo Estadual"			CAMPO "M0_INSC"		TIPO "C" TAMANHO 14 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 1
	ADD FIELD aInfo	TITULO "Rua/Avenida"				CAMPO "M0_ENDENT"	TIPO "C" TAMANHO 30 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 2
	ADD FIELD aInfo	TITULO "Complemento" 				CAMPO "M0_COMPENT"	TIPO "C" TAMANHO 12 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 2
	ADD FIELD aInfo	TITULO "Bairro"						CAMPO "M0_BAIRENT"	TIPO "C" TAMANHO 20 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 2
	ADD FIELD aInfo	TITULO "Cidade"						CAMPO "M0_CIDENT"	TIPO "C" TAMANHO 20 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 2
	ADD FIELD aInfo	TITULO "Estado"						CAMPO "M0_ESTENT"	TIPO "C" TAMANHO 02 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 2
	ADD FIELD aInfo	TITULO "CEP"						CAMPO "M0_CEPENT"	TIPO "C" TAMANHO 08 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 2
	ADD FIELD aInfo	TITULO "Rua/Avenida"				CAMPO "M0_ENDCOB"	TIPO "C" TAMANHO 30 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 3
	ADD FIELD aInfo	TITULO "Complemento"				CAMPO "M0_COMPCOB"	TIPO "C" TAMANHO 12 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 3
	ADD FIELD aInfo	TITULO "Bairro"						CAMPO "M0_BAIRCOB"	TIPO "C" TAMANHO 20 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 3
	ADD FIELD aInfo	TITULO "Cidade"						CAMPO "M0_CIDCOB"	TIPO "C" TAMANHO 20 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 3
	ADD FIELD aInfo	TITULO "Estado"						CAMPO "M0_ESTCOB"	TIPO "C" TAMANHO 02 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 3
	ADD FIELD aInfo	TITULO "CEP"						CAMPO "M0_CEPCOB"	TIPO "C" TAMANHO 08 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 3
	ADD FIELD aInfo	TITULO "Tp Inscri็ใo" 				CAMPO "M0_TPINSC"	TIPO "C" TAMANHO 01 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 4 //BOX "1=CEI;2=CGC/CNPJ;3=CPF;4=INCRA" 
	ADD FIELD aInfo	TITULO "Produtor Rural"				CAMPO "M0_PRODRUR"	TIPO "C" TAMANHO 01 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 4 //BOX "1=Fํsica;2=Juridica;3=Segurado Especial" 
	ADD FIELD aInfo	TITULO "C๓d FPAS" 					CAMPO "M0_FPAS"		TIPO "C" TAMANHO 04 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 4
	ADD FIELD aInfo	TITULO "Nat.Juridica"				CAMPO "M0_NATJUR"	TIPO "C" TAMANHO 04 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 4
	ADD FIELD aInfo	TITULO "Dt. Base"					CAMPO "M0_DTBASE"	TIPO "C" TAMANHO 02 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 4
	ADD FIELD aInfo	TITULO "C๓d. CNAE"					CAMPO "M0_CNAE"		TIPO "C" TAMANHO 07 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 4
	ADD FIELD aInfo	TITULO "Cd.Acid.Trb."				CAMPO "M0_ACTRAB"	TIPO "C" TAMANHO 08 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 4
	ADD FIELD aInfo	TITULO "N Prop."					CAMPO "M0_NUMPROP"	TIPO "N" TAMANHO 02 DECIMAL 0 NIVEL 1 FOLDER 4
	ADD FIELD aInfo	TITULO "Endere็o"					CAMPO "M0_MODEND"	TIPO "L" TAMANHO 01 DECIMAL 0 NIVEL 1 FOLDER 4
	ADD FIELD aInfo	TITULO "Tp Insc CNPJ/CPI"			CAMPO "M0_MODINSC"	TIPO "L" TAMANHO 01 DECIMAL 0 NIVEL 1 FOLDER 4
	ADD FIELD aInfo	TITULO "Causas Reais"				CAMPO "M0_CAUSA"	TIPO "C" TAMANHO 01 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 4
	ADD FIELD aInfo	TITULO  "Insc.Anterior"				CAMPO "M0_INSCANT"	TIPO "C" TAMANHO 14 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 4
	ADD FIELD aInfo	TITULO "Cod.Municipio"				CAMPO "M0_CODMUN"	TIPO "C" TAMANHO 07 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 4
	ADD FIELD aInfo	TITULO "Tp. Estab."					CAMPO "M0_TPESTAB"	TIPO "C" TAMANHO 02 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 4
	ADD FIELD aInfo	TITULO "Tel. Importador"			CAMPO "M0_TEL_IMP"	TIPO "C" TAMANHO 22 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 5
	ADD FIELD aInfo	TITULO "Fax Importador"				CAMPO "M0_FAX_IMP"	TIPO "C" TAMANHO 22 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 5
	ADD FIELD aInfo	TITULO "Tipo" 						CAMPO "M0_IMP_CON"	TIPO "C" TAMANHO 01 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 5 //BOX "1=Importador;2=Consignatแrio" 
	ADD FIELD aInfo	TITULO "Tel. Contato"				CAMPO "M0_TEL_PO"	TIPO "C" TAMANHO 22 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 5
	ADD FIELD aInfo	TITULO "Fax Contato"				CAMPO "M0_FAX_PO"	TIPO "C" TAMANHO 22 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 5
	ADD FIELD aInfo	TITULO "Cod. Z.Sec"					CAMPO "M0_CODZOSE"	TIPO "C" TAMANHO 12 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 5
	ADD FIELD aInfo	TITULO "Des. Z.Sec"					CAMPO "M0_DESZOSE"	TIPO "C" TAMANHO 30 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 5
	ADD FIELD aInfo	TITULO "Cod. Atividade"				CAMPO "M0_COD_ATV"	TIPO "C" TAMANHO 05 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 5
	ADD FIELD aInfo	TITULO "Insc. Suframa"				CAMPO "M0_INS_SUF"	TIPO "C" TAMANHO 12 DECIMAL 0 PICTURE "@!" NIVEL 1 FOLDER 5

	For nI := 1 To Len(aInfo)
		cField := aInfo[nI][2]
		If ( Alltrim(Upper(cField)) == "M0_TPINSC" )
			M->&(cField) := Str(('SM0')->&(cField))
		ElseIf ( Alltrim(Upper(cField)) == "M0_MODEND" .Or. Alltrim(Upper(cField)) == "M0_MODINSC"  )
			If ( Upper(('SM0')->&(cField)) == 'S' )
				M->&(cField) := .T.
			Else
				M->&(cField) := .F.
			EndIf
		ElseIf ( Alltrim(Upper(cField)) == "M0_PRODRUR" )
			If ( Upper(('SM0')->&(cField)) == 'F' )
				M->&(cField) := '1'
			ElseIf ( Upper(('SM0')->&(cField)) == 'J' )
				M->&(cField) := '2'
			Else
				M->&(cField) := '3'
			EndIf
		Else
			M->&(cField) := ('SM0')->&(cField)
		EndIf
	Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProDirDlgV( oTree, aEnch, aPos, nOldEnch, oPanel, aInfo, nTop, nLeft, nBottom, nRight, aDados )

	Local cCargo := SubStr( oTree:GetCargo(), 1, 2 )
	Local cNivel := Right( oTree:GetCargo(), 4 )

	Local oScroll

	aDados := {}

	oPanel:Hide()
	oPanel:FreeChildren()

	If cCargo == "01"
		MsMGet():New( "SM0", SM0->(RecNo()),2,,,,,{0,0,((nBottom-nTop)/2)-25,(nRight-nLeft)/2-160},,,,,,oPanel,,,.T.,,,,aInfo,{ 'Dados Gerais', 'Endere็o Fiscal/Entrega', 'Endereco de Cobran็a', 'Complementos', 'Adicionais'} )

	ElseIf cCargo == "02"
		If cNivel == "0000"
			MsgRun("Montando Dados...", "", { || GetDad02( @aDados ) } )
			PDDispBox( aDados, 15, "", { 400, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)	

		Else
			AxCadastro( "ZAC", "Requisitos Legais", ".T.", ".T." )
		Endif 

	ElseIf cCargo == "03"

		If cNivel == "0001"
			MsgRun("Montando Dados...", "", { || GetDad031( @aDados ) } )
			PDDispBox( aDados, 15, "", { 400, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)	

		ElseIf cNivel == "0002"
			MsgRun("Montando Dados...", "", { || GetDad032( @aDados ) } )
			PDDispBox( aDados, 15, "", { 400, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)

		ElseIf cNivel == "0003"
			MsgRun("Montando Dados...", "", { || GetDad033( @aDados ) } )
			PDDispBox( aDados, 15, "", { 400, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)

		ElseIf cNivel == "0009"
			AxCadastro( "ZAH", "Horas Terceiros", ".T.", ".T." )

		Endif 

	ElseIf cCargo == "04"

		If cNivel == "0000"
			MsgRun("Montando Dados...", "", { || GetDad04( @aDados ) } )
			PDDispBox( aDados, 15, "", { 400, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)

		Else
			AxCadastro( "ZAJ", "Horas Treinamento Terceiro", ".T.", ".T." )

		Endif

	ElseIf cCargo == "05"

		If cNivel == "0000"
			MsgRun("Montando Dados...", "", { || GetDad05( @aDados ) } )
			PDDispBox( aDados, 15, "", { 400, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)	

		Else
			AxCadastro( "ZAB", "Integra็๕es com a Comunidade", ".T.", ".T." )
		Endif 

	ElseIf cCargo == "06"

		If cNivel == "0000"
			MsgRun("Montando Dados...", "", { || GetDad06( @aDados ) } )
			PDDispBox( aDados, 15, "", { 400, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)
		Else
			AxCadastro( "ZAD", "Consumo Agua M3", ".T.", ".T." )
		Endif

	ElseIf cCargo == "07"
		MsgRun("Montando Dados...", "", { || GetDad07( @aDados ) } )
		PDDispBox( aDados, 15, "", { 400, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)

	ElseIf cCargo == "08"
		If cNivel == "0000"
			MsgRun("Montando Dados...", "", { || GetDad08( @aDados ) } )
			PDDispBox( aDados, 15, "", { 400, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)

		ElseIf cNivel == "0001"
			AxCadastro( "ZAG", "Numero Checklists Efetuados", ".T.", ".T." )

		ElseIf cNivel == "0002"		
			AxCadastro( "ZAI", "Numero Checklists Reprovados", ".T.", ".T." )

		Endif

	ElseIf cCargo == "09"
		MsgRun("Montando Dados...", "", { || GetDad09( @aDados ) } )
		PDDispBox( aDados, 15, "", { 400, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)

	ElseIf cCargo == "10"
		MsgRun("Montando Dados...", "", { || GetDad10( @aDados ) } )
		PDDispBox( aDados, 15, "", { 600, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)

	ElseIf cCargo == "11"

		If cNivel == "0000"
			MsgRun("Montando Dados...", "", { || GetDad11( @aDados ) } )
			PDDispBox( aDados, 5, "", { 400, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)
		Else
			AxCadastro( "ZAF", "Analise de Desempenho - Metas", ".T.", ".T." )
		Endif

	ElseIf cCargo == "12"

		If cNivel == "0001"
			MsgRun("Montando Dados...", "", { || GetDad121( @aDados ) } )
			PDDispBox( aDados, 12, "", { 400, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)

		Elseif cNivel == "0002"
			MsgRun("Montando Dados...", "", { || GetDad122( @aDados ) } )
			PDDispBox( aDados, 7, "", { 400, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)

		Elseif cNivel == "1231"
			MsgRun("Montando Dados...", "", { || GetDad1231( @aDados ) } )
			PDDispBox( aDados, 15, "", { 400, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)

		Elseif cNivel == "1232"
			MsgRun("Montando Dados...", "", { || GetDad1232( @aDados ) } )
			PDDispBox( aDados, 5, "", { 400, 100, 100, 100, 100 },,,,,@oPanel,,,,,"", aPos)

		Elseif cNivel == "1239"
			AxCadastro( "ZAE", "Ensaios M๊s", ".T.", ".T." )

		Endif

	Endif

	oPanel:Show()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PDirMatScrDisp( aInfo, oScroll, oPanel, aPos, aCoresCols, aCoresLines )

	Local nX,ny,nAchou
	Local cCor,cCorDefault:=CLR_BLACK
	Local nCols   :=1,nSomaCols:=0
	Local nLinAtu := 5
	Local nColAtu := 45
	Local nColIni := 0
	Local oBmp
	DEFAULT aCoresCols:={}
	DEFAULT aCoresLines:={}
	DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
	If Len(aInfo) > 0
		oScroll:= TScrollBox():New(oPanel,aPos[1],aPos[2],aPos[3],aPos[4])
		@ 0,0 BITMAP oBmp RESNAME "LOGIN" oF oScroll SIZE 45,aPos[3] ADJUST NOBORDER WHEN .F. PIXEL
		nCols:=Len(aInfo[1])
		For nx := 1 to Len(aInfo)
			For ny := 1 to nCols
				If CalcFieldSize("C",Len(aInfo[nx,ny]),0) > nSomaCols
					nSomaCols:=CalcFieldSize("C",Len(aInfo[nx,ny]),0)
				EndIf	
			Next ny
		Next
		ny := 1
		For nx := 1 to Len(aInfo)
			nAchou  := Ascan(aCoresLines,{|x| x[1]== nx})
			If nAchou > 0
				cCor:=aCoresLines[nAchou,2]			
			Else
				cCor:=cCorDefault			 	
			EndIf
			nAchou  := Ascan(aCoresCols,{|x| x[1]== ny})
			If nAchou > 0
				cCor:=aCoresCols[nAchou,2]			
			EndIf
			cTextSay:= "{||' "+STRTRAN(aInfo[nx][ny],"'",'"')+" '}"
			oSay    := TSay():New(nLinAtu,nColAtu,MontaBlock(cTextSay),oScroll,,oFont,,,,.T.,cCor,,,,,,,,)
			nLinAtu += 9
		Next
		nLinAtu := 5
		aEval(aInfo, {|z| nColIni := Max(nColIni, CalcFieldSize("C",Len(z[1]),0))})
		nColIni := nColIni * 0.9
		nColAtu := nColIni
		For nx := 1 to Len(aInfo)
			For ny := 2 to nCols
				nAchou  := Ascan(aCoresLines,{|x| x[1]== nx})
				If nAchou > 0
					cCor:=aCoresLines[nAchou,2]			
				Else
					cCor:=cCorDefault			 	
				EndIf
				nAchou  := Ascan(aCoresCols,{|x| x[1]== ny})
				If nAchou > 0
					cCor:=aCoresCols[nAchou,2]			
				EndIf
				cTextSay:= "{||' "+STRTRAN(aInfo[nx][ny],"'",'"')+" '}"
				oSay    := TSay():New(nLinAtu,nColAtu,MontaBlock(cTextSay),oScroll,,oFont,,.T.,,.T.,cCor,,,,,,,,)
				nColAtu += nSomaCols
			Next ny
			nLinAtu += 9
			nColAtu := nColIni
		Next
	EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad04( aDados, aCabec, lDetal )

	Local cQuery 	:= ""

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Local nMeses    := Month( Date() )

	Default aCabec := {}
	Default lDetal := .F.

	If lDetal
		cQuery := "SELECT * "
	Else
		cQuery := "SELECT SUBSTR( RA4_DATAIN, 5, 2 ) RA4_DATAIN, COUNT( RA4_MAT ) RA4_QTD, NVL( SUM( RA4_HORAS ), 0 ) RA4_HORAS "
	Endif

	cQuery += "  FROM " + RetSQLName( "RA4" )
	cQuery += " WHERE SUBSTR( RA4_DATAIN, 1, 4 )  = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_ 				  = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( RA4_DATAIN, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( RA4_DATAIN, 5, 2 )"
	Endif

	If Select( "TMP_RA4" ) > 0
		TMP_RA4->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_RA4", .T., .F. )

	If lDetal
		GetCabec( "TMP_RA4", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_RA4", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_RA4->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_RA4->( FCount() )
				aAdd( aAux, &( "TMP_RA4->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_RA4->( dbSkip() )
		End

	Else
		aAdd( aDados, { "Total Treinamentos", "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ", "Media", "Total" } )
		aAdd( aDados, { "Nบ Total de Horas de Treinamento (Funcionแrios + Terceiros)                ", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )
		aAdd( aDados, { "Nบ total de colaboradores relacionados ao PRODIR (funcionแrios + terceiros)", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )

		While TMP_RA4->( !Eof() )
			aDados[2][Val( TMP_RA4->RA4_DATAIN ) + 1] := Transform( Val( aDados[2][Val( TMP_RA4->RA4_DATAIN ) + 1] ) + TMP_RA4->RA4_HORAS, "@E 9999999.99" )
			TMP_RA4->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.99" )

	Endif

	If lDetal
		cQuery := "SELECT '1' E1_TIPO, ZAJ.* "
	Else
		cQuery := "SELECT SUBSTR( ZAJ_ANOMES, 5, 2 ) ZAJ_ANOMES, NVL( SUM( ZAJ_QUANT ), 0 ) ZAJ_QUANT "
	Endif

	cQuery += "  FROM " + RetSQLName( "ZAJ" ) + " ZAJ "
	cQuery += " WHERE ZAJ_FILIAL                 = '" + xFilial( "ZAJ" ) + "' "
	cQuery += "   AND SUBSTR( ZAJ_ANOMES, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_                 = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( ZAJ_ANOMES, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( ZAJ_ANOMES, 5, 2 )"
	Endif

	If Select( "TMP_ZAJ" ) > 0
		TMP_ZAJ->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAJ", .T., .F. )

	If lDetal
		GetCabec( "TMP_ZAJ", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_ZAJ", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_ZAJ->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_ZAJ->( FCount() )
				aAdd( aAux, &( "TMP_ZAJ->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_ZAJ->( dbSkip() )
		End

	Else
		While TMP_ZAJ->( !Eof() )
			aDados[2][Val( TMP_ZAJ->ZAJ_ANOMES ) + 1] := Transform( Val( aDados[2][Val( TMP_ZAJ->ZAJ_ANOMES ) + 1] ) + TMP_ZAJ->ZAJ_QUANT, "@E 9999999.99" )
			TMP_ZAJ->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.99" )
	Endif

	TMP_ZAJ->( dbCloseArea() )

	If !lDetal
		For nLoop := 1 To nMeses

			cQuery := "SELECT COUNT(*) RA_QTD "
			cQuery += "  FROM " + RetSQLName( "SRA" )
			cQuery += " WHERE SUBSTR( RA_ADMISSA, 1, 6 ) <= '" + MV_PAR01 + StrZero( nLoop, 2 ) + "' "
			cQuery += "   AND RA_DEMISSA                  = ' ' "
			cQuery += "   AND RA_CATFUNC                  = 'M' "
			cQuery += "   AND D_E_L_E_T_                  = ' ' "
			If Select( "TMP_SRA" ) > 0
				TMP_SRA->( dbCloseArea() )
			Endif
			dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRA", .T., .F. )
			If TMP_SRA->( !Eof() )
				aDados[3][nLoop+1] := Transform( TMP_SRA->RA_QTD + GetNewPar( "MV_TCOLPD", 30 ), "@E 9999999.99" )
			End
			TMP_SRA->( dbCloseArea() )

		Next nLoop

		RecalDados( @aDados, "@E 9999999.99" )

	Endif

	TMP_RA4->( dbCloseArea() )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad06( aDados, aCabec, lDetal )

	Local cQuery 	:= ""

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	If lDetal
		cQuery := "SELECT '1' E1_TIPO, SFU.* "
	Else
		cQuery := "SELECT SUBSTR( F1_DTDIGIT, 5, 2 ) F1_DTDIGIT, NVL( SUM( FU_CONSTOT ), 0 ) FU_CONSTOT "
	Endif

	cQuery += "  FROM " + RetSQLName( "SFU" ) + " SFU "
	cQuery += "  JOIN " + RetSQLName( "SF1" ) + " SF1 ON F1_FILIAL = '" + xFilial( "SF1" ) + "' AND F1_DOC = FU_DOC AND F1_SERIE = FU_SERIE AND F1_FORNECE = FU_CLIFOR AND F1_LOJA = FU_LOJA AND SF1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE FU_FILIAL                  = '" + xFilial( "SFU" ) + "' "
	cQuery += "   AND SUBSTR( F1_DTDIGIT, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND SFU.D_E_L_E_T_             = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( F1_DTDIGIT, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( F1_DTDIGIT, 5, 2 )"
	Endif

	If Select( "TMP_SFU" ) > 0
		TMP_SFU->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SFU", .T., .F. )

	If lDetal
		GetCabec( "TMP_SFU", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SFU", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_SFU->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SFU->( FCount() )
				aAdd( aAux, &( "TMP_SFU->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SFU->( dbSkip() )
		End

	Else
		aAdd( aDados, { "Total Consumo", "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ", "Media", "Total" } )
		aAdd( aDados, { "Consumo de energia el้trica (KWH)", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )
		aAdd( aDados, { "Volume de แgua captada (Mณ)      ", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )

		While TMP_SFU->( !Eof() )
			aDados[2][Val( TMP_SFU->F1_DTDIGIT ) + 1] := Transform( Val( aDados[2][Val( TMP_SFU->F1_DTDIGIT ) + 1] ) + TMP_SFU->FU_CONSTOT, "@E 9999999.99" )
			TMP_SFU->( dbSkip() )
		End

	Endif
	TMP_SFU->( dbCloseArea() )

	If lDetal
		cQuery := "SELECT '1' E1_TIPO, ZAD.* "
	Else
		cQuery := "SELECT SUBSTR( ZAD_ANOMES, 5, 2 ) ZAD_ANOMES, NVL( SUM( ZAD_QUANT ), 0 ) ZAD_QUANT "
	Endif

	cQuery += "  FROM " + RetSQLName( "ZAD" ) + " ZAD "
	cQuery += " WHERE ZAD_FILIAL                 = '" + xFilial( "ZAD" ) + "' "
	cQuery += "   AND SUBSTR( ZAD_ANOMES, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_                 = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( ZAD_ANOMES, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( ZAD_ANOMES, 5, 2 )"
	Endif

	If Select( "TMP_ZAD" ) > 0
		TMP_ZAD->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAD", .T., .F. )

	If lDetal
		GetCabec( "TMP_ZAD", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_ZAD", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_ZAD->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_ZAD->( FCount() )
				aAdd( aAux, &( "TMP_ZAD->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_ZAD->( dbSkip() )
		End

	Else

		While TMP_ZAD->( !Eof() )
			aDados[3][Val( TMP_ZAD->ZAD_ANOMES ) + 1] := Transform( Val( aDados[3][Val( TMP_ZAD->ZAD_ANOMES ) + 1] ) + TMP_ZAD->ZAD_QUANT, "@E 9999999.99" )
			TMP_ZAD->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.99" )

	Endif

	TMP_ZAD->( dbCloseArea() )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad07( aDados, aCabec, lDetal )

	Local cQuery 	:= ""


	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	If lDetal
		cQuery := "SELECT '1' E1_TIPO, SD3.* "
	Else
		cQuery := "SELECT SUBSTR( D3_EMISSAO, 5, 2 ) D3_EMISSAO, NVL( SUM( D3_QUANT ), 0 ) D3_QUANT "
	Endif

	cQuery += "  FROM " + RetSQLName( "SD3" ) + " SD3 "
	cQuery += " WHERE D3_FILIAL                  = '" + xFilial( "SD3" ) + "' " 
	cQuery += "   AND SUBSTR( D3_EMISSAO, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND D3_EMBAVAR                 = 'S' "
	cQuery += "   AND D_E_L_E_T_                 = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( D3_EMISSAO, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( D3_EMISSAO, 5, 2 )"
	Endif

	If Select( "TMP_SD3" ) > 0
		TMP_SD3->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SD3", .T., .F. )

	If lDetal
		GetCabec( "TMP_SD3", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SD3", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_SD3->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SD3->( FCount() )
				aAdd( aAux, &( "TMP_SD3->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SD3->( dbSkip() )
		End

	Else
		aAdd( aDados, { "Total Embalagens", "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ", "Media", "Total" } )
		aAdd( aDados, { "Nบ total de embalagens avariadas ", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } ) 
		aAdd( aDados, { "Nบ total de embalagens utilizadas", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )

		While TMP_SD3->( !Eof() )
			aDados[2][Val( TMP_SD3->D3_EMISSAO ) + 1] := Transform( Val( aDados[2][Val( TMP_SD3->D3_EMISSAO ) + 1] ) + TMP_SD3->D3_QUANT, "@E 9999999.99" )
			TMP_SD3->( dbSkip() )
		End

	Endif
	TMP_SD3->( dbCloseArea() )

	If lDetal
		cQuery := "SELECT '2' E1_TIPO, SD3.* "
	Else
		cQuery := "SELECT SUBSTR( D3_EMISSAO, 5, 2 ) D3_EMISSAO, NVL( SUM( D3_QUANT ), 0 ) D3_QUANT "
	Endif

	cQuery += "  FROM " + RetSQLName( "SD3" ) + " SD3 "
	cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL = '" + xFilial( "SB1" ) + "' AND B1_COD = D3_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE D3_FILIAL                  = '" + xFilial( "SD3" ) + "' "
	cQuery += "   AND SUBSTR( D3_EMISSAO, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND B1_SEGMENT                 = '000014' "
	cQuery += "   AND SD3.D_E_L_E_T_             = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( D3_EMISSAO, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( D3_EMISSAO, 5, 2 )"
	Endif

	If Select( "TMP_SD3" ) > 0
		TMP_SD3->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SD3", .T., .F. )

	If lDetal
		GetCabec( "TMP_SD3", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SD3", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_SD3->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SD3->( FCount() )
				aAdd( aAux, &( "TMP_SD3->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SD3->( dbSkip() )
		End

	Else

		While TMP_SD3->( !Eof() )
			aDados[3][Val( TMP_SD3->D3_EMISSAO ) + 1] := Transform( Val( aDados[3][Val( TMP_SD3->D3_EMISSAO ) + 1] ) + TMP_SD3->D3_QUANT, "@E 9999999.99" )
			TMP_SD3->( dbSkip() )
		End

	Endif

	TMP_SD3->( dbCloseArea() )

	If !lDetal
		RecalDados( @aDados, "@E 9999999.99" )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad05( aDados, aCabec, lDetal )

	Local cQuery 	:= ""

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	If lDetal
		cQuery := "SELECT '1' E1_TIPO, ZAB.* "
	Else
		cQuery := "SELECT SUBSTR( ZAB_ANOMES, 5, 2 ) ZAB_ANOMES, NVL( SUM( ZAB_QUANT ), 0 ) ZAB_QUANT "
	Endif
	cQuery += "  FROM " + RetSQLName( "ZAB" ) + " ZAB "
	cQuery += " WHERE ZAB_FILIAL                 = '" + xFilial( "ZAB" ) + "' "
	cQuery += "   AND SUBSTR( ZAB_ANOMES, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_                 = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( ZAB_ANOMES, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( ZAB_ANOMES, 5, 2 )"
	Endif

	If Select( "TMP_ZAB" ) > 0
		TMP_ZAB->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAB", .T., .F. )

	If lDetal
		GetCabec( "TMP_ZAB", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_ZAB", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_ZAB->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_ZAB->( FCount() )
				aAdd( aAux, &( "TMP_ZAB->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_ZAB->( dbSkip() )
		End

	Else
		aAdd( aDados, { "Total Int. comunidade", "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ", "Media", "Total" } )
		aAdd( aDados, { "Nบ total de a็๕es com a comunidade", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )

		While TMP_ZAB->( !Eof() )
			aDados[2][Val( TMP_ZAB->ZAB_ANOMES ) + 1] := Transform( Val( aDados[2][Val( TMP_ZAB->ZAB_ANOMES ) + 1] ) + TMP_ZAB->ZAB_QUANT, "@E 9999999.99" )
			TMP_ZAB->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.99" )	

	Endif

	TMP_ZAB->( dbCloseArea() )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad02( aDados, aCabec, lDetal )

	Local cQuery 	:= ""

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	If lDetal
		cQuery := "SELECT '1' E1_TIPO, ZAC.* "
	Else
		cQuery := "SELECT SUBSTR( ZAC_ANOMES, 5, 2 ) ZAC_ANOMES, NVL( SUM( ZAC_QUANT ), 0 ) ZAC_QUANT "
	Endif

	cQuery += "  FROM " + RetSQLName( "ZAC" ) + " ZAC "
	cQuery += " WHERE ZAC_FILIAL                 = '" + xFilial( "ZAC" ) + "' "
	cQuery += "   AND SUBSTR( ZAC_ANOMES, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_                 = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( ZAC_ANOMES, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( ZAC_ANOMES, 5, 2 )"
	Endif

	If Select( "TMP_ZAC" ) > 0
		TMP_ZAC->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAC", .T., .F. )

	If lDetal
		GetCabec( "TMP_ZAC", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_ZAC", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_ZAC->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_ZAC->( FCount() )
				aAdd( aAux, &( "TMP_ZAC->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_ZAC->( dbSkip() )
		End

	Else
		aAdd( aDados, { "Total Requisitos Legais", "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ", "Media", "Total" } )
		aAdd( aDados, { "Nบ total de autua็๕es/multas/interven็๕es/embargos ", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )

		While TMP_ZAC->( !Eof() )
			aDados[2][Val( TMP_ZAC->ZAC_ANOMES ) + 1] := Transform( Val( aDados[2][Val( TMP_ZAC->ZAC_ANOMES ) + 1] ) + TMP_ZAC->ZAC_QUANT, "@E 9999999.99" )
			TMP_ZAC->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.99" )

	Endif

	TMP_ZAC->( dbCloseArea() )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad08( aDados, aCabec, lDetal )

	Local cQuery 	:= ""

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.


	If lDetal
		cQuery := "SELECT '1' E1_TIPO, ZAI.* "
	Else
		cQuery := "SELECT SUBSTR( ZAI_ANOMES, 5, 2 ) ZAI_ANOMES, NVL( SUM( ZAI_QUANT ), 0 ) ZAI_QUANT "
	Endif

	cQuery += "  FROM " + RetSQLName( "ZAI" ) + " ZAI "
	cQuery += " WHERE ZAI_FILIAL                 = '" + xFilial( "ZAI" ) + "' "
	cQuery += "   AND SUBSTR( ZAI_ANOMES, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_                 = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( ZAI_ANOMES, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( ZAI_ANOMES, 5, 2 )"
	Endif

	If Select( "TMP_ZAI" ) > 0
		TMP_ZAI->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAI", .T., .F. )

	If lDetal
		GetCabec( "TMP_ZAI", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_ZAI", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_ZAI->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_ZAI->( FCount() )
				aAdd( aAux, &( "TMP_ZAI->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_ZAI->( dbSkip() )
		End

	Else
		aAdd( aDados, { "Total Transportes", "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ", "Media", "Total" } )
		aAdd( aDados, { "Nบ de avalia็๕es (check lists) efetuados em veํculos transportadores ", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )
		aAdd( aDados, { "Nบ de veํculos transportadores reprovados na avalia็ใo (check list)  ", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )
		aAdd( aDados, { "Nบ total de embarques efetuados (CIF + FOB)                          ", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )

		While TMP_ZAI->( !Eof() )
			aDados[3][Val( TMP_ZAI->ZAI_ANOMES ) + 1] := Transform( Val( aDados[3][Val( TMP_ZAI->ZAI_ANOMES ) + 1] ) + TMP_ZAI->ZAI_QUANT, "@E 9999999.99" )
			TMP_ZAI->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.99" )
	Endif

	TMP_ZAI->( dbCloseArea() )

	/*
	If lDetal
	cQuery := "SELECT '2' E1_TIPO, ZA2.* "
	Else
	cQuery := "SELECT SUBSTR( ZA2_DATA, 5, 2 ) ZA2_DATA, COUNT(*) ZA2_QTD "
	Endif

	cQuery += "  FROM " + RetSQLName( "ZA2" ) + " ZA2 "
	cQuery += " WHERE ZA2_FILIAL               = '" + xFilial( "ZA2" ) + "' "
	cQuery += "   AND SUBSTR( ZA2_DATA, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "

	If !lDetal
	cQuery += " GROUP BY SUBSTR( ZA2_DATA, 5, 2 )"
	cQuery += " ORDER BY SUBSTR( ZA2_DATA, 5, 2 )"
	Endif

	If Select( "TMP_ZA2" ) > 0
	TMP_ZA2->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZA2", .T., .F. )

	If lDetal
	GetCabec( "TMP_ZA2", @aCabec, @aStruct )
	aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_ZA2", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
	While TMP_ZA2->( !Eof() )

	aAux := {}
	For nLoop := 1 To TMP_ZA2->( FCount() )
	aAdd( aAux, &( "TMP_ZA2->" + ( FieldName( nLoop ) ) ) )
	Next nLoop

	aAdd( aDados, aClone( aAux ) )

	TMP_ZA2->( dbSkip() )
	End

	Else

	While TMP_ZA2->( !Eof() )
	aDados[3][Val( TMP_ZA2->ZA2_DATA ) + 1] := Transform( Val( aDados[3][Val( TMP_ZA2->ZA2_DATA ) + 1] ) + TMP_ZA2->ZA2_QTD, "@E 9999999.99" )
	TMP_ZA2->( dbSkip() )
	End

	Endif
	TMP_ZA2->( dbCloseArea() )
	*/

	If lDetal
		cQuery := "SELECT '1' E1_TIPO, ZAG.* "
	Else
		cQuery := "SELECT SUBSTR( ZAG_ANOMES, 5, 2 ) ZAG_ANOMES, NVL( SUM( ZAG_QUANT ), 0 ) ZAG_QUANT "
	Endif

	cQuery += "  FROM " + RetSQLName( "ZAG" ) + " ZAG "
	cQuery += " WHERE ZAG_FILIAL                 = '" + xFilial( "ZAG" ) + "' "
	cQuery += "   AND SUBSTR( ZAG_ANOMES, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_                 = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( ZAG_ANOMES, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( ZAG_ANOMES, 5, 2 )"
	Endif

	If Select( "TMP_ZAG" ) > 0
		TMP_ZAG->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAG", .T., .F. )

	If lDetal
		GetCabec( "TMP_ZAG", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_ZAG", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_ZAG->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_ZAG->( FCount() )
				aAdd( aAux, &( "TMP_ZAG->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_ZAG->( dbSkip() )
		End

	Else

		While TMP_ZAG->( !Eof() )
			aDados[2][Val( TMP_ZAG->ZAG_ANOMES ) + 1] := Transform( Val( aDados[2][Val( TMP_ZAG->ZAG_ANOMES ) + 1] ) + TMP_ZAG->ZAG_QUANT, "@E 9999999.99" )
			TMP_ZAG->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.99" )
	Endif

	TMP_ZAG->( dbCloseArea() )

	If lDetal
		cQuery := "SELECT SF2.* "
	Else
		cQuery := "SELECT SUBSTR( F2_EMISSAO, 5, 2 ) F2_EMISSAO, COUNT( DISTINCT F2_DOC ) F2_QTD "
	Endif
	cQuery += "  FROM " + RetSQLName( "SF2" ) + " SF2 "
	cQuery += "  JOIN " + RetSQLName( "SD2" ) + " SD2 ON D2_FILIAL = '" + xFilial( "SD2" ) + "' AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSQLName( "SF4" ) + " SF4 ON F4_FILIAL = '" + xFilial( "SF4" ) + "' AND F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE F2_FILIAL                  = '" + xFilial( "SF2" ) + "' "
	cQuery += "   AND SUBSTR( F2_EMISSAO, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND F4_ESTOQUE                 = 'S' "
	cQuery += "   AND SF2.D_E_L_E_T_             = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( F2_EMISSAO, 5, 2 ) "
		cQuery += " ORDER BY SUBSTR( F2_EMISSAO, 5, 2 ) "
	Endif

	If Select( "TMP_SF2" ) > 0
		TMP_SF2->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SF2", .T., .F. )

	If lDetal
		GetCabec( "TMP_SF2", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SF2", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_SF2->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SF2->( FCount() )
				aAdd( aAux, &( "TMP_SF2->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SF2->( dbSkip() )
		End

	Else
		While TMP_SF2->( !Eof() )
			aDados[4][Val( TMP_SF2->F2_EMISSAO ) + 1] := Transform( Val( aDados[4][Val( TMP_SF2->F2_EMISSAO ) + 1] ) + TMP_SF2->F2_QTD, "@E 9999999.99" )
			TMP_SF2->( dbSkip() )
		End

	Endif

	TMP_SF2->( dbCloseArea() )

	If !lDetal
		RecalDados( @aDados, "@E 9999999.99" )
	Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad09( aDados, aCabec, lDetal )

	Local cQuery 	:= ""

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	If lDetal
		cQuery := "SELECT '1' E1_TIPO, SD2.* "
	Else
		cQuery := "SELECT SUBSTR( D2_EMISSAO, 5, 2 ) D2_EMISSAO, NVL( SUM( D2_QUANT ), 0 ) / 1000 D2_QUANT "
	Endif
	cQuery += "  FROM " + RetSQLName( "SD2" ) + " SD2 "
	cQuery += "  JOIN " + RetSQLName( "SC5" ) + " SC5 ON C5_FILIAL = '" + xFilial( "SC5" ) + "' AND C5_NUM    = D2_PEDIDO AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL = '" + xFilial( "SB1" ) + "' AND B1_COD    = D2_COD    AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSQLName( "SF4" ) + " SF4 ON F4_FILIAL = '" + xFilial( "SF4" ) + "' AND F4_CODIGO = D2_TES    AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE D2_FILIAL                   = '" + xFilial( "SD2" ) + "' "
	cQuery += "   AND SUBSTR( D2_EMISSAO, 1, 4 )  = '" + MV_PAR01 + "' "
	cQuery += "   AND C5_TPFRETE                  = 'C' "
	cQuery += "   AND B1__CODONU                 != ' ' "
	cQuery += "   AND F4_DUPLIC                   = 'S' "
	cQuery += "   AND SF4.F4_ISS                 != 'S' "
	cQuery += "   AND SD2.D_E_L_E_T_              = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( D2_EMISSAO, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( D2_EMISSAO, 5, 2 )"
	Endif

	If Select( "TMP_SD2" ) > 0
		TMP_SD2->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SD2", .T., .F. )

	If lDetal
		GetCabec( "TMP_SD2", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SD2", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_SD2->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SD2->( FCount() )
				aAdd( aAux, &( "TMP_SD2->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SD2->( dbSkip() )
		End

	Else
		aAdd( aDados, { "Total Vendas", "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ", "Media", "Total" } )
		aAdd( aDados, { "Quantidade (TON) de produtos quํmicos (perigosos) - CIF           ", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )
		aAdd( aDados, { "Quantidade (TON) de produtos quํmicos (perigosos) - FOB           ", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )
		aAdd( aDados, { "Quantidade (TON) de produtos quํmicos (nใo perigosos) - FOB + CIF ", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )

		While TMP_SD2->( !Eof() )
			aDados[2][Val( TMP_SD2->D2_EMISSAO ) + 1] := Transform( Val( aDados[2][Val( TMP_SD2->D2_EMISSAO ) + 1] ) + TMP_SD2->D2_QUANT, "@E 9999999.99" )
			TMP_SD2->( dbSkip() )
		End

	Endif
	TMP_SD2->( dbCloseArea() )

	If lDetal
		cQuery := "SELECT '2' E1_TIPO, SD2.* "
	Else
		cQuery := "SELECT SUBSTR( D2_EMISSAO, 5, 2 ) D2_EMISSAO, NVL( SUM( D2_QUANT ), 0 ) / 1000 D2_QUANT "
	Endif

	cQuery += "  FROM " + RetSQLName( "SD2" ) + " SD2 "
	cQuery += "  JOIN " + RetSQLName( "SC5" ) + " SC5 ON C5_FILIAL = '" + xFilial( "SC5" ) + "' AND C5_NUM = D2_PEDIDO AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL = '" + xFilial( "SB1" ) + "' AND B1_COD = D2_COD    AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSQLName( "SF4" ) + " SF4 ON F4_FILIAL = '" + xFilial( "SF4" ) + "' AND F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE D2_FILIAL                   = '" + xFilial( "SD2" ) + "' "
	cQuery += "   AND SUBSTR( D2_EMISSAO, 1, 4 )  = '" + MV_PAR01 + "' "
	cQuery += "   AND C5_TPFRETE                  = 'F' "
	cQuery += "   AND B1__CODONU                 != ' ' "
	cQuery += "   AND F4_DUPLIC                   = 'S' "
	cQuery += "   AND SF4.F4_ISS                 != 'S' "
	cQuery += "   AND SD2.D_E_L_E_T_              = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( D2_EMISSAO, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( D2_EMISSAO, 5, 2 )"
	Endif

	If Select( "TMP_SD2" ) > 0
		TMP_SD2->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SD2", .T., .F. )

	If lDetal
		GetCabec( "TMP_SD2", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SD2", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_SD2->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SD2->( FCount() )
				aAdd( aAux, &( "TMP_SD2->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SD2->( dbSkip() )
		End

	Else
		While TMP_SD2->( !Eof() )
			aDados[3][Val( TMP_SD2->D2_EMISSAO ) + 1] := Transform( Val( aDados[3][Val( TMP_SD2->D2_EMISSAO ) + 1] ) + TMP_SD2->D2_QUANT, "@E 9999999.99" )
			TMP_SD2->( dbSkip() )
		End
	Endif
	TMP_SD2->( dbCloseArea() )

	If lDetal
		cQuery := "SELECT '3' E1_TIPO, SD2.* "
	Else
		cQuery := "SELECT SUBSTR( D2_EMISSAO, 5, 2 ) D2_EMISSAO, NVL( SUM( D2_QUANT ), 0 ) / 1000 D2_QUANT "
	Endif

	cQuery += "  FROM " + RetSQLName( "SD2" ) + " SD2 "
	cQuery += "  JOIN " + RetSQLName( "SC5" ) + " SC5 ON C5_FILIAL = '" + xFilial( "SC5" ) + "' AND C5_NUM = D2_PEDIDO AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSQLName( "SB1" ) + " SB1 ON B1_FILIAL = '" + xFilial( "SB1" ) + "' AND B1_COD = D2_COD    AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSQLName( "SF4" ) + " SF4 ON F4_FILIAL = '" + xFilial( "SF4" ) + "' AND F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE D2_FILIAL                   = '" + xFilial( "SD2" ) + "' "
	cQuery += "   AND SUBSTR( D2_EMISSAO, 1, 4 )  = '" + MV_PAR01 + "' "
	cQuery += "   AND B1__CODONU                  = ' ' "
	cQuery += "   AND F4_DUPLIC                   = 'S' "
	cQuery += "   AND SF4.F4_ISS                 != 'S' "
	cQuery += "   AND SD2.D_E_L_E_T_              = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( D2_EMISSAO, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( D2_EMISSAO, 5, 2 )"
	Endif

	If Select( "TMP_SD2" ) > 0
		TMP_SD2->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SD2", .T., .F. )

	If lDetal
		GetCabec( "TMP_SD2", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SD2", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_SD2->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SD2->( FCount() )
				aAdd( aAux, &( "TMP_SD2->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SD2->( dbSkip() )
		End

	Else
		While TMP_SD2->( !Eof() )
			aDados[4][Val( TMP_SD2->D2_EMISSAO ) + 1] := Transform( Val( aDados[4][Val( TMP_SD2->D2_EMISSAO ) + 1] ) + TMP_SD2->D2_QUANT, "@E 9999999.99" )
			TMP_SD2->( dbSkip() )
		End
	Endif
	TMP_SD2->( dbCloseArea() )

	If !lDetal
		RecalDados( @aDados, "@E 9999999.99" )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad122( aDados, aCabec, lDetal )

	Local cQuery := ""

	Local nPos	 := 0
	Local nTotal := 0

	Local nTotal1 := 0
	Local nTotal2 := 0
	Local nTotal3 := 0

	Local nLoop	 := 0

	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	If lDetal

		cQuery := "SELECT SUBSTR( RA_ADMISSA, 1, 4 ) RD_DATARQ, RA_MAT, RA_NOME, RA_GRINRAI, X5_DESCRI AS DESCRI, RA_DEMISSA "
		cQuery += "  FROM " + RetSQLName( "SRA" ) + " SRA "
		cQuery += "  JOIN " + RetSQLName( "SX5" ) + " SX5 ON X5_FILIAL = '" + xFilial( "SX5" ) + "' AND X5_TABELA = '26' AND X5_CHAVE = RA_GRINRAI AND SX5.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE SUBSTR( RA_ADMISSA, 1, 4 ) <= '" + MV_PAR01 + "' "
		cQuery += "   AND RA_DEMISSA                  = ' ' "
		cQuery += "   AND RA_CATFUNC                  = 'M' "
		cQuery += "   AND SRA.D_E_L_E_T_              = ' ' "
		cQuery += " ORDER BY SUBSTR( RA_ADMISSA, 1, 4 ) "

		If Select( "TMP_SRA" ) > 0
			TMP_SRA->( dbCloseArea() )
		Endif

		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRA", .T., .F. )

		GetCabec( "TMP_SRA", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SRA", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )

		While TMP_SRA->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SRA->( FCount() )
				aAdd( aAux, &( "TMP_SRA->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SRA->( dbSkip() )
		End

	Else
		aAdd( aDados, { "Total Ident. de Forma็ใo", "QTD. " + AllTrim( Str( Val( MV_PAR01 ) - 2 ) ), "PER. " + AllTrim( Str( Val( MV_PAR01 ) - 2 ) ) , "QTD." + AllTrim( Str( Val( MV_PAR01 ) - 1 ) ), "PER." + AllTrim( Str( Val( MV_PAR01 ) - 1 ) ), "QTD." + MV_PAR01, "PER." + MV_PAR01 } )
		nTotal := 0
		cQuery := "SELECT RA_GRINRAI, X5_DESCRI AS DESCRI, COUNT(*) RA_QTD "
		cQuery += "  FROM " + RetSQLName( "SRA" ) + " SRA "
		cQuery += "  JOIN " + RetSQLName( "SX5" ) + " SX5 ON X5_FILIAL = '" + xFilial( "SX5" ) + "' AND X5_TABELA = '26' AND X5_CHAVE = RA_GRINRAI AND SX5.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE SUBSTR( RA_ADMISSA, 1, 4 ) <= '" + AllTrim( Str( Val( MV_PAR01 ) - 2 ) )  + "' "
		cQuery += "   AND RA_DEMISSA                  = ' ' "
		cQuery += "   AND RA_CATFUNC                  = 'M' "
		cQuery += "   AND SRA.D_E_L_E_T_                  = ' ' "
		cQuery += " GROUP BY RA_GRINRAI, X5_DESCRI "
		cQuery += " ORDER BY X5_DESCRI "
		If Select( "TMP_SRA" ) > 0
			TMP_SRA->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRA", .T., .F.)
		TMP_SRA->( dbGoTop() )
		TMP_SRA->( dbEval( { || nTotal += TMP_SRA->RA_QTD } ) )
		TMP_SRA->( dbGoTop() )

		While TMP_SRA->( !Eof() )

			nPos := aScan( aDados, { |x| Left( x[1], 2 ) == TMP_SRA->RA_GRINRAI } )

			If Empty( nPos )
				aAdd( aDados, { TMP_SRA->RA_GRINRAI + " - " + TMP_SRA->DESCRI,;
				Transform( TMP_SRA->RA_QTD, "@E 999999" ),;
				Transform( ( TMP_SRA->RA_QTD / nTotal ) * 100, "@E 99.99" ) + "%",;
				"",;
				"",;
				"",;
				"" } )
			Else
				aDados[nPos][2] := Transform( Val( aDados[nPos][2] ) + TMP_SRA->RA_QTD, "@E 999999" )
				aDados[nPos][3] := Transform( ( Val( aDados[nPos][2] ) / nTotal ) * 100, "E@ 99.99" ) + "%"
			Endif

			nTotal1 += TMP_SRA->RA_QTD

			TMP_SRA->( dbSkip() )
		End
		TMP_SRA->( dbCloseArea() )

		nTotal := 0
		cQuery := "SELECT RA_GRINRAI, X5_DESCRI AS DESCRI, COUNT(*) RA_QTD "
		cQuery += "  FROM " + RetSQLName( "SRA" ) + " SRA "
		cQuery += "  JOIN " + RetSQLName( "SX5" ) + " SX5 ON X5_FILIAL = '" + xFilial( "SX5" ) + "' AND X5_TABELA = '26' AND X5_CHAVE = RA_GRINRAI AND SX5.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE SUBSTR( RA_ADMISSA, 1, 4 ) <= '" + AllTrim( Str( Val( MV_PAR01 ) - 1 ) ) + "' "
		cQuery += "   AND RA_DEMISSA                  = ' ' "
		cQuery += "   AND RA_CATFUNC                  = 'M' "
		cQuery += "   AND SRA.D_E_L_E_T_                  = ' ' "
		cQuery += " GROUP BY RA_GRINRAI, X5_DESCRI "
		cQuery += " ORDER BY X5_DESCRI "
		If Select( "TMP_SRA" ) > 0
			TMP_SRA->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRA", .T., .F.)
		TMP_SRA->( dbGoTop() )
		TMP_SRA->( dbEval( { || nTotal += TMP_SRA->RA_QTD } ) )
		TMP_SRA->( dbGoTop() )

		While TMP_SRA->( !Eof() )

			nPos := aScan( aDados, { |x| Left( x[1], 2 ) == TMP_SRA->RA_GRINRAI } )

			If Empty( nPos )
				aAdd( aDados, { TMP_SRA->RA_GRINRAI + " - " + TMP_SRA->DESCRI,;
				"",;
				"",;
				Transform( TMP_SRA->RA_QTD, "@E 999999" ),;
				Transform( ( TMP_SRA->RA_QTD / nTotal ) * 100, "@E 99.99" ) + "%",;
				"",;
				"" } )
			Else
				aDados[nPos][4] := Transform( Val( aDados[nPos][4] ) + TMP_SRA->RA_QTD, "@E 999999" )
				aDados[nPos][5] := Transform( ( Val( aDados[nPos][4] ) / nTotal ) * 100, "@E 99.99" ) + "%"
			Endif

			nTotal2 += TMP_SRA->RA_QTD

			TMP_SRA->( dbSkip() )
		End
		TMP_SRA->( dbCloseArea() )

		nTotal := 0
		cQuery := "SELECT RA_GRINRAI, X5_DESCRI AS DESCRI, COUNT(*) RA_QTD "
		cQuery += "  FROM " + RetSQLName( "SRA" ) + " SRA "
		cQuery += "  JOIN " + RetSQLName( "SX5" ) + " SX5 ON X5_FILIAL = '" + xFilial( "SX5" ) + "' AND X5_TABELA = '26' AND X5_CHAVE = RA_GRINRAI AND SX5.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE SUBSTR( RA_ADMISSA, 1, 4 ) <= '" + MV_PAR01 + "' "
		cQuery += "   AND RA_DEMISSA                  = ' ' "
		cQuery += "   AND RA_CATFUNC                  = 'M' "
		cQuery += "   AND SRA.D_E_L_E_T_                  = ' ' "
		cQuery += " GROUP BY RA_GRINRAI, X5_DESCRI "
		cQuery += " ORDER BY X5_DESCRI "
		If Select( "TMP_SRA" ) > 0
			TMP_SRA->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRA", .T., .F.)
		TMP_SRA->( dbGoTop() )
		TMP_SRA->( dbEval( { || nTotal += TMP_SRA->RA_QTD } ) )
		TMP_SRA->( dbGoTop() )

		While TMP_SRA->( !Eof() )

			nPos := aScan( aDados, { |x| Left( x[1], 2 ) == TMP_SRA->RA_GRINRAI } )

			If Empty( nPos )
				aAdd( aDados, { TMP_SRA->RA_GRINRAI + " - " + TMP_SRA->DESCRI,;
				"",;
				"",;
				"",;
				"",;
				Transform( TMP_SRA->RA_QTD, "@E 999999" ),;
				Transform( ( TMP_SRA->RA_QTD / nTotal ) * 100, "@E 99.99" ) + "%" } )
			Else
				aDados[nPos][6] := Transform( Val( aDados[nPos][6] ) + TMP_SRA->RA_QTD, "@E 999999" )
				aDados[nPos][7] := Transform( ( Val( aDados[nPos][6] ) / nTotal ) * 100, "@E 99.99" ) + "%"
			Endif

			nTotal3 += TMP_SRA->RA_QTD

			TMP_SRA->( dbSkip() )
		End
		TMP_SRA->( dbCloseArea() )

		aAdd( aDados, { "TOTAIS", Transform( nTotal1, "@E 999999" ), "100%" , Transform( nTotal2, "@E 999999" ), "100%", Transform( nTotal3, "@E 999999" ), "100%" } )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PDDispBox(aInfo,nCols,cText,aCols,cBackColor,nStyle,cClrLegend,cClrData,oDlg,nColIni,nLinIni,lAllClient,cDescri,cTextSay, aPos)

	Local cColorSay     := CLR_BLACK
	Local lCriaDlg		:= (oDlg==Nil)
	Local nDlgX			:= 4
	Local aArea			:= GetArea()
	Local nDlgY         := If(Len(aInfo)>2,(Len(aInfo)*12)+6,45)
	Local nX            := 0
	Local nY            := 0
	Local oSay, cSay, oPanel
	Local aColorSay, aBackColor, aClrLegend, aClrData, nLinSay
	Local nPixelsW	:= 0
	Local aoSay := {}

	DEFAULT cBackColor	:= CLR_WHITE
	DEFAULT nStyle		:= 1
	DEFAULT cClrLegend	:= PcoRetRGB(120, 190, 120)
	DEFAULT cClrData	:= PcoRetRGB(230,230,230)
	DEFAULT nColIni		:= 0
	DEFAULT nLinIni		:= 0
	DEFAULT lAllClient	:= .F.
	DEFAULT cDescri		:= ""

	aBackColor := ConvRGB(cBackColor)
	cBackColor := ""
	aEval(aBackColor, {|x|cBackColor+=Dec2Hex(x)})

	aClrLegend := ConvRGB(cClrLegend)
	cClrLegend := ""
	aEval(aClrLegend, {|x|cClrLegend+=Dec2Hex(x)})

	aClrData := ConvRGB(cClrData)
	cClrData := ""
	aEval(aClrData, {|x|cClrData+=Dec2Hex(x)})

	For nx := 1 to Len(aCols)
		nDlgX += aCols[nx]
	Next

	If lCriaDlg
		DEFINE MSDIALOG oDlg TITLE cText OF oMainWnd PIXEL FROM 0,0 TO MAX(MIN(nDlgY*2,460),130),MIN(nDlgX*2,670) //STYLE nOR(WS_VISIBLE,WS_POPUP)
	EndIf

	DEFINE FONT oFont NAME "Arial" SIZE 0, -10

	oPanel := TScrollBox():New( oDlg, aPos[1], aPos[2], aPos[3], aPos[4] )
	If lAllClient
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT
	EndIf
	nLin := 5
	nCol := 3
	If !Empty(cDescri)
		cTextSay := "{||' "+STRTRAN(cDescri,"'",'"')+" '}"
		oSay := TSay():New( 2,nCol, MontaBlock(cTextSay) , oPanel, ,oFont,,,,.T.,cColorSay,,400,15,,,,)
		nLin += 15
	EndIf
	nLinSay := nLin

	aColorSay := ConvRGB(cColorSay)
	cColorSay := "" 
	aEval(aColorSay, {|x|cColorSay+=Dec2Hex(x)})

	For nx := 1 to Len(aInfo)

		aAdd(aoSay, TSay():New())

		cSay:='<table cellpadding="2" bgcolor="#'+cClrData+'" cellspacing="1" border="0">' 
		cSay += CRLF

		If nX == 1
			cColor := cClrLegend
			cSay+='<tr bgcolor="#'+cColor+'"  ALIGN="center" >'
		Else
			cColor := cClrLegend//cClrData
			cSay+='<tr  ALIGN="right" >'
		EndIf

		For ny := 1 to nCols
			Do Case
				Case nStyle == 1
				If ny == 1
					cColor := cClrLegend
				Else
					cColor := cClrData
				EndIf
				Case nStyle == 2
				If nx == 1
					cColor := cClrLegend
				Else
					cColor := cClrData
				EndIf
				Case nStyle == 3
				If nx == 1 .Or. ny == 1
					cColor := cClrLegend
				Else
					cColor := cClrData
				EndIf
			EndCase
			If ValType(aInfo[nx][ny])=="C"
				cTextSay := STRTRAN(aInfo[nx][ny],"'",'"')
				cColorSay := CLR_BLACK
				aColorSay := ConvRGB(cColorSay)
				cColorSay := "" ; aEval(aColorSay, {|x|cColorSay+=Dec2Hex(x)})
			Else
				cTextSay := STRTRAN(aInfo[nx][ny][1],"'",'"')
				cColorSay := aInfo[nx][ny][2]
				aColorSay := ConvRGB(cColorSay)
				cColorSay := "" ; aEval(aColorSay, {|x|cColorSay+=Dec2Hex(x)})
			EndIf
			cTextSay := PadR(Alltrim(cTextSay),Int(aCols[ny]/3))
			If nX == 1
				cSay+='<th valign="top" Width="'+If(nY==1, AllTrim( Str( aCols[1] + 100 ) ),"130")+'">'+StrTran(cTextSay,Space(1),'&nbsp;')+'</TH>'
				nPixelsW	+=	Len(cTextSay)*8
			Else
				If nY == 1
					cSay+='<td ALIGN="left" bgcolor="#'+cColor+'" Width="'+If(nY==1, AllTrim( Str( aCols[1] + 100 ) ),"130")+'">'+cTextSay+"</TD>"
				Else	
					cSay+='<td Width="130">'+Alltrim(cTextSay)+"</TD>"
				EndIf	
			EndIf
			nCol += aCols[ny]
		next ny
		cSay += CRLF
		nLin += 9
		nCol := 3
		cSay+='</table>'

		@ nLin,1 SAY aoSay[nX] VAR "" OF oPanel FONT oFont PIXEL SIZE nPixelsW,2300 HTML
		aoSay[nX]:cCaption := cSay
		aoSay[nX]:cTitle := cSay	

	Next

	If lCriaDlg
		nLin += 20
		@ nLin,20 			BUTTON "Fechar" SIZE 35 ,10  ACTION {||oDlg:End()}  OF oPanel PIXEL
		@ nLin,(nDlgX)-80 	BUTTON "Fechar" SIZE 35 ,10  ACTION {||oDlg:End()}  OF oPanel PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED
	EndIf

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad121( aDados, aCabec, lDetal )

	Local cQuery := ""

	Local nPos	 := 0
	Local nTotal := 0
	Local nLoop	 := 0

	Local nColAux := 0

	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	If lDetal
		cQuery := "SELECT RA_MAT, RA_NOME, RA_ADMISSA, RA_DEMISSA "
		cQuery += "  FROM " + RetSQLName( "SRA" ) + " SRA "
		cQuery += " WHERE SUBSTR( RA_ADMISSA, 1, 4 ) <= '" + MV_PAR01 + "' "
		cQuery += "   AND SRA.D_E_L_E_T_              = ' ' "
		cQuery += " ORDER BY RA_MAT "

		If Select( "TMP_SRA" ) > 0
			TMP_SRA->( dbCloseArea() )
		Endif

		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRA", .T., .F. )

		GetCabec( "TMP_SRA", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SRA", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )

		While TMP_SRA->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SRA->( FCount() )
				aAdd( aAux, &( "TMP_SRA->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SRA->( dbSkip() )
		End

	Else
		aAdd( aDados, { "Areas/Meses", "E. Admin", "E. Comer", "E. Operac", "Tot. Ent.", "S. Admin", "S. Comerc", "S. Operac", "Tot.Saidas", "Pedido", "Dispensa", "Tot. Colab." } )

		aAdd( aDados, { "JAN", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )
		aAdd( aDados, { "FEV", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )
		aAdd( aDados, { "MAR", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )
		aAdd( aDados, { "ABR", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )
		aAdd( aDados, { "MAI", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )
		aAdd( aDados, { "JUN", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )
		aAdd( aDados, { "JUL", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )
		aAdd( aDados, { "AGO", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )
		aAdd( aDados, { "SET", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )
		aAdd( aDados, { "OUT", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )
		aAdd( aDados, { "NOV", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )
		aAdd( aDados, { "DEZ", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )

		aAdd( aDados, { "Total", Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ) } )

		cQuery := "SELECT SUBSTR( RA_ADMISSA, 5, 2 ) RA_ADMISSA, SUBSTR( RA_CC, 1, 1 ) RA_CC,  COUNT(*) RA_QTD "
		cQuery += "  FROM " + RetSQLName( "SRA" )
		cQuery += " WHERE SUBSTR( RA_ADMISSA, 1, 4 ) = '" + MV_PAR01 + "' "
		cQuery += "   AND D_E_L_E_T_                 = ' ' "
		cQuery += " GROUP BY SUBSTR( RA_ADMISSA, 5, 2 ), SUBSTR( RA_CC, 1, 1 ) "
		If Select( "TMP_SRA" ) > 0
			TMP_SRA->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRA", .T., .F. )
		While TMP_SRA->( !Eof() )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ1/4 - Administrativoณ
			//ณ2/3 - Comercial     ณ
			//ณ5   - Operacional   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If TMP_SRA->RA_CC $ "1/4"
				nColAux := 2

			ElseIf TMP_SRA->RA_CC $ "2/3"
				nColAux := 3

			ElseIf TMP_SRA->RA_CC = "5"
				nColAux := 4
			Endif

			aDados[ Val(TMP_SRA->RA_ADMISSA) + 1 ][nColAux] := Transform( Val( aDados[ Val(TMP_SRA->RA_ADMISSA) + 1 ][nColAux] ) + TMP_SRA->RA_QTD, "@E 9999999999" )
			aDados[ Val(TMP_SRA->RA_ADMISSA) + 1 ][5] := Transform( Val( aDados[ Val(TMP_SRA->RA_ADMISSA) + 1 ][2] ) + Val( aDados[ Val(TMP_SRA->RA_ADMISSA) + 1 ][3] ) + Val( aDados[ Val(TMP_SRA->RA_ADMISSA) + 1 ][4] ), "@E 9999999999" )

			aDados[14][nColAux] := Transform( 0, "@E 9999999999" )
			For nLoop := 2 To 13
				aDados[14][nColAux] :=  Transform( Val( aDados[14][nColAux] ) + Val( aDados[nLoop][nColAux] ), "@E 9999999999" )
			Next nLoop
			aDados[14][5] := Transform( Val( aDados[14][2] ) + Val( aDados[14][3] ) + Val( aDados[14][4] ), "@E 9999999999" )

			TMP_SRA->( dbSkip() )
		End
		TMP_SRA->( dbCloseArea() )

		cQuery := "SELECT SUBSTR( RA_DEMISSA, 5, 2 ) RA_DEMISSA, SUBSTR( RA_CC, 1, 1 ) RA_CC,  COUNT(*) RA_QTD "
		cQuery += "  FROM " + RetSQLName( "SRA" )
		cQuery += " WHERE SUBSTR( RA_DEMISSA, 1, 4 ) = '" + MV_PAR01 + "' "
		cQuery += "   AND D_E_L_E_T_                 = ' ' "
		cQuery += " GROUP BY SUBSTR( RA_DEMISSA, 5, 2 ), SUBSTR( RA_CC, 1, 1 ) "
		If Select( "TMP_SRA" ) > 0
			TMP_SRA->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRA", .T., .F. )
		While TMP_SRA->( !Eof() )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ1/4 - Administrativoณ
			//ณ2/3 - Comercial     ณ
			//ณ5   - Operacional   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If TMP_SRA->RA_CC $ "1/4"
				nColAux := 6

			ElseIf TMP_SRA->RA_CC $ "2/3"
				nColAux := 7

			ElseIf TMP_SRA->RA_CC = "5"
				nColAux := 8
			Endif

			aDados[ Val(TMP_SRA->RA_DEMISSA) + 1 ][nColAux] := Transform( Val( aDados[ Val(TMP_SRA->RA_DEMISSA) + 1 ][nColAux] ) + TMP_SRA->RA_QTD, "@E 9999999999" )
			aDados[ Val(TMP_SRA->RA_DEMISSA) + 1 ][9] := Transform( Val( aDados[ Val(TMP_SRA->RA_DEMISSA) + 1 ][6] ) + Val( aDados[ Val(TMP_SRA->RA_DEMISSA) + 1 ][7] ) + Val( aDados[ Val(TMP_SRA->RA_DEMISSA) + 1 ][8] ), "@E 9999999999" )

			aDados[14][nColAux] := Transform( 0, "@E 9999999999" )
			For nLoop := 2 To 13
				aDados[14][nColAux] :=  Transform( Val( aDados[14][nColAux] ) + Val( aDados[nLoop][nColAux] ), "@E 9999999999" )
			Next nLoop
			aDados[14][9] := Transform( Val( aDados[14][6] ) + Val( aDados[14][7] ) + Val( aDados[14][8] ), "@E 9999999999" )

			TMP_SRA->( dbSkip() )
		End
		TMP_SRA->( dbCloseArea() )

		cQuery := "SELECT SUBSTR( RA_DEMISSA, 5, 2 ) RA_DEMISSA, RG_TIPORES,  COUNT(*) RA_QTD "
		cQuery += "  FROM " + RetSQLName( "SRA" ) + " SRA "
		cQuery += "  JOIN " + RetSQLName( "SRG" ) + " SRG ON RG_MAT = RA_MAT AND SRG.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE SUBSTR( RA_DEMISSA, 1, 4 ) = '" + MV_PAR01 + "' "
		cQuery += "   AND SRA.D_E_L_E_T_             = ' ' "
		cQuery += " GROUP BY SUBSTR( RA_DEMISSA, 5, 2 ), RG_TIPORES "
		If Select( "TMP_SRA" ) > 0
			TMP_SRA->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRA", .T., .F. )
		While TMP_SRA->( !Eof() )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณDISPENSA = 01/02/03/06/07/08/10/11/12/13/14ณ
			//ณPEDIDO   = 04/05/09/15                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If TMP_SRA->RG_TIPORES $ "04/05/09/15"
				nColAux := 10
			Else
				nColAux := 11
			Endif

			aDados[ Val(TMP_SRA->RA_DEMISSA) + 1 ][nColAux] := Transform( Val( aDados[ Val(TMP_SRA->RA_DEMISSA) + 1 ][nColAux] ) + TMP_SRA->RA_QTD, "@E 9999999999" )

			aDados[14][nColAux] := Transform( 0, "@E 9999999999" )
			For nLoop := 2 To 13
				aDados[14][nColAux] :=  Transform( Val( aDados[14][nColAux] ) + Val( aDados[nLoop][nColAux] ), "@E 9999999999" )
			Next nLoop

			TMP_SRA->( dbSkip() )
		End
		TMP_SRA->( dbCloseArea() )

		For nLoop := 1 To 12

			cQuery := "SELECT COUNT(*) RA_QTD "
			cQuery += "  FROM " + RetSQLName( "SRA" )
			cQuery += " WHERE SUBSTR( RA_ADMISSA, 1, 6 ) <= '" + MV_PAR01 + StrZero( nLoop, 2 ) + "' "
			cQuery += "   AND RA_DEMISSA                  = ' ' "
			cQuery += "   AND RA_CATFUNC                  = 'M' "
			cQuery += "   AND D_E_L_E_T_                  = ' ' "
			If Select( "TMP_SRA" ) > 0
				TMP_SRA->( dbCloseArea() )
			Endif
			dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRA", .T., .F. )
			If TMP_SRA->( !Eof() )
				aDados[nLoop+1][12] := Transform( TMP_SRA->RA_QTD, "@E 9999999999" )
			End
			TMP_SRA->( dbCloseArea() )

		Next nLoop

		aDados[14][12] := Space( 10 )

	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PDExcel( oTree, aDados )

	Local cCargo := SubStr( oTree:GetCargo(), 1, 2 )
	Local cNivel := Right( oTree:GetCargo(), 4 )
	Local aCabec := {}

	If !( cCargo + cNivel $ "020000|030001|030002|030003|040000|050000|060000|070000|080000|090000|100000|110000|120001|120002|121231|121232" )
		MsgStop( "Este nivel da arvore nao permite exporta็ใo para Excel" )
		Return
	Endif

	If Empty( aDados )
		Return
	Endif

	aCabec := Array( Len( aDados[1] ) )

	aFill( aCabec, "" )

	DlgToExcel( { {"ARRAY", "PRODIR - Exporta็ใo Excel", aCabec, aDados } } )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad031( aDados, aCabec, lDetal )

	Local cQuery  := ""

	Local nAux := 0

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	If lDetal
		cQuery := "SELECT * " 
	Else
		cQuery := "SELECT SUBSTR( TNC_DTACID, 5, 2 ) TNC_DTACID, TNC_TIPACI, COUNT(*) TNC_QTD "
	Endif

	cQuery += "  FROM " + RetSQLName( "TNC" )
	cQuery += " WHERE TNC_FILIAL = '" + xFilial( "TNC" ) + "' "
	cQuery += "   AND TNC_TIPACI IN ( 	'ACID-TRA0001', "
	cQuery += "							'ACID-TRA0002', "
	cQuery += "							'ACID-SIT0001', "
	cQuery += "							'ACID-SIT0002', "
	cQuery += "							'ACID-SIT0003', "
	cQuery += "							'ACID-SIT0004', "
	cQuery += "		  					'ACID-TER0001', "
	cQuery += "							'ACID-SIT0005', "
	cQuery += "							'ACID-CLI0001') "
	cQuery += "   AND SUBSTR( TNC_DTACID, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( TNC_DTACID, 5, 2 ), TNC_TIPACI "
		cQuery += " ORDER BY SUBSTR( TNC_DTACID, 5, 2 ), TNC_TIPACI "
	Endif

	If Select( "TMP_TNC" ) > 0
		TMP_TNC->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_TNC", .T., .F. )

	If lDetal
		GetCabec( "TMP_TNC", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_TNC", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_TNC->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_TNC->( FCount() )
				aAdd( aAux, &( "TMP_TNC->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_TNC->( dbSkip() )
		End
	Else

		aAdd( aDados, { "Tot. Ger. de Risco - Acidentes", "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ", "Media", "Total" } )
		aAdd( aDados, { "Nบ Tot.Acid. no transporte envolvendo produto quํmico perigoso 														", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )
		aAdd( aDados, { "Nบ Tot.Acid. no transporte envolvendo produto quํmico nใo perigoso												    	", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )
		aAdd( aDados, { "Nบ Tot.Acid. no site - manuseio e armazenagem, envolvendo produto quํmico(matriz + filial + armaz้m terceirizado)		", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )
		aAdd( aDados, { "Nบ Tot.Acid. no site - manuseio e armazenagem, envolvendo produto quํmico(somente matriz + filial)                 	", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )
		aAdd( aDados, { "Nบ Tot.Acid. no site - sem envolvimento de produto quํmico														    	", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )
		aAdd( aDados, { "Nบ Tot.Acid. em terceiros - envolvendo produto quํmico (armaz้ns / dep๓sitos terceirizados)							", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )
		aAdd( aDados, { "Nบ Tot.Acid. no site - carga e descarga, envolvendo vazamento de produto quํmico, e relatado เs autoridades locais    	", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )
		aAdd( aDados, { "Nบ Tot.Acid. no cliente - carga e descarga, envolvendo vazamento de produto quํmico, e relatado เs autoridades locais 	", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )

		While TMP_TNC->( !Eof() )

			nAux := 0
			If TMP_TNC->TNC_TIPACI $ "ACID-TRA0001"
				nAux := 2

			ElseIf TMP_TNC->TNC_TIPACI $ "ACID-TRA0002"
				nAux := 3

			ElseIf TMP_TNC->TNC_TIPACI $ "ACID-SIT0001|ACID-SIT0002|ACID-SIT0003"
				nAux := 4

			ElseIf TMP_TNC->TNC_TIPACI $ "ACID-SIT0001|ACID-SIT0002"
				nAux := 5

			ElseIf TMP_TNC->TNC_TIPACI $ "ACID-SIT0004"
				nAux := 6

			ElseIf TMP_TNC->TNC_TIPACI $ "ACID-TER0001"
				nAux := 7

			ElseIf TMP_TNC->TNC_TIPACI $ "ACID-SIT0005"
				nAux := 8

			ElseIf TMP_TNC->TNC_TIPACI $ "ACID-CLI0001"
				nAux := 9

			Endif

			If !Empty( nAux )
				aDados[nAux][Val(TMP_TNC->TNC_DTACID)+1] := Transform( Val( aDados[nAux][Val(TMP_TNC->TNC_DTACID)+1] ) + TMP_TNC->TNC_QTD, "@E 9999999" )
			Endif

			TMP_TNC->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999" )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad032( aDados, aCabec, lDetal )

	Local cQuery  := ""

	Local nAux := 0

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	If lDetal
		cQuery := "	SELECT SRA.RA_NOME, SR8.*
	Else
		cQuery := "	SELECT SUBSTR( R8_DATAFIM, 5, 2 ) R8_DATAFIM, SUM( R8_DURACAO * RCF_HRSDIA ) R8_DURACAO
	Endif
	cQuery += "  FROM " + RetSQLName( "SR8" ) + " SR8 "
	cQuery += "  JOIN " + RetSQLName( "RCF" ) + " RCF ON RCF_MES = SUBSTR( R8_DATAFIM, 5, 2 ) AND RCF_ANO = '2011' AND RCF.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSQLName( "SRA" ) + " SRA ON RA_MAT = R8_MAT AND SRA.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SUBSTR( R8_DATAFIM, 1, 4 )  = '" + MV_PAR01 + "' "
	cQuery += "   AND R8_TIPO                    NOT IN ( 'F', 'Q' ) "
	cQuery += "   AND R8_DURACAO                 >= 3 "
	cQuery += "   AND RA_SITFOLH                 != 'D' "
	cQuery += "   AND SR8.D_E_L_E_T_              = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( R8_DATAFIM, 5, 2 ) "
		cQuery += " ORDER BY SUBSTR( R8_DATAFIM, 5, 2 ) "
	Endif

	If Select( "TMP_SR8" ) > 0
		TMP_SR8->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SR8", .T., .F. )

	If lDetal
		GetCabec( "TMP_SR8", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SR8", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_SR8->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SR8->( FCount() )
				aAdd( aAux, &( "TMP_SR8->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SR8->( dbSkip() )
		End
	Else

		aAdd( aDados, { "Total Gerenciamento de Risco - Perdas", "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ", "Media", "Total" } )
		aAdd( aDados, { "Nบ total de horas perdidas por colaboradores, por afastamento de 3 ou mais dias(Nใo considerar terceiros)	", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )
		aAdd( aDados, { "Nบ total de horas trabalhadas no m๊s - funcionแrios														", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )
		aAdd( aDados, { "Nบ total de horas trabalhadas no m๊s - funcionแrios + terceiros											", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )
		aAdd( aDados, { "Nบ total de fatalidades (acidentes com mortes)(Nใo considerar terceiros)									", Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ), Transform( 0, "@E 9999999.99" ) } )

		While TMP_SR8->( !Eof() )
			aDados[2][Val(TMP_SR8->R8_DATAFIM)+1] := Transform( Val( aDados[2][Val(TMP_SR8->R8_DATAFIM)+1] ) + TMP_SR8->R8_DURACAO, "@E 9999999.99" )
			TMP_SR8->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.99" )
	Endif
	TMP_SR8->( dbCloseArea() )

	If lDetal
		cQuery := "SELECT RD_FILIAL, RD_MAT, RD_PD, RD_TIPO1, RD_HORAS "
	Else
		cQuery := "SELECT RD_MES, SUM( CASE WHEN RD_PD = '101' THEN RD_HORAS * RCF_HRSDIA ELSE RD_HORAS END ) RD_HORAS "
	Endif
	cQuery += "  FROM " + RetSQLName( "SRD" ) + " SRD "
	cQuery += "  JOIN " + RetSQLName( "RCF" ) + " RCF ON RCF_MES = RD_MES AND RCF_ANO = '" + MV_PAR01 + "' AND RCF.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SUBSTR( RD_DATARQ, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND RD_PD IN ( '101', '136', '137', '138', '139', '147', '156', '167', '168', '169', '207', '384' ) "
	cQuery += "   AND SRD.D_E_L_E_T_ = ' ' "

	If !lDetal
		cQuery += " GROUP BY RD_MES "
		cQuery += " ORDER BY RD_MES "
	Endif

	If Select( "TMP_SRD" ) > 0
		TMP_SRD->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRD", .T., .F. )

	If lDetal
		GetCabec( "TMP_SRD", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SRD", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_SRD->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SRD->( FCount() )
				aAdd( aAux, &( "TMP_SRD->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SRD->( dbSkip() )
		End
	Else

		While TMP_SRD->( !Eof() )
			aDados[3][Val(TMP_SRD->RD_MES)+1] := Transform( Val( aDados[2][Val(TMP_SRD->RD_MES)+1] ) + TMP_SRD->RD_HORAS, "@E 9999999.99" )
			TMP_SRD->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.99" )
	Endif
	TMP_SRD->( dbCloseArea() )

	If lDetal
		cQuery := "SELECT RD_FILIAL, RD_MAT, RD_PD, RD_TIPO1, RD_HORAS "
	Else
		cQuery := "SELECT RD_MES, SUM( CASE WHEN RD_PD IN ( '416', '480' ) THEN RD_HORAS * RCF_HRSDIA ELSE RD_HORAS END ) RD_HORAS "
	Endif
	cQuery += "  FROM " + RetSQLName( "SRD" ) + " SRD "
	cQuery += "  JOIN " + RetSQLName( "RCF" ) + " RCF ON RCF_MES = RD_MES AND RCF_ANO = '" + MV_PAR01 + "' AND RCF.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SUBSTR( RD_DATARQ, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND RD_PD IN ( '416', '433', '478', '480', '481' ) "
	cQuery += "   AND SRD.D_E_L_E_T_ = ' ' "

	If !lDetal
		cQuery += " GROUP BY RD_MES "
		cQuery += " ORDER BY RD_MES "
	Endif

	If Select( "TMP_SRD" ) > 0
		TMP_SRD->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRD", .T., .F. )

	If lDetal
		GetCabec( "TMP_SRD", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SRD", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_SRD->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SRD->( FCount() )
				aAdd( aAux, &( "TMP_SRD->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SRD->( dbSkip() )
		End
	Else

		While TMP_SRD->( !Eof() )
			aDados[3][Val(TMP_SRD->RD_MES)+1] := Transform( Val( aDados[3][Val(TMP_SRD->RD_MES)+1] ) - TMP_SRD->RD_HORAS, "@E 9999999.99" )
			TMP_SRD->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.99" )
	Endif
	TMP_SRD->( dbCloseArea() )

	If lDetal
		cQuery := "SELECT '3' E1_TIPO, ZAH.* "
	Else
		For nLoop := 2 To 13
			aDados[4][nLoop] := aDados[3][nLoop]
		Next nLoop

		cQuery := "SELECT SUBSTR( ZAH_ANOMES, 5, 2 ) ZAH_ANOMES, NVL( SUM( ZAH_QUANT ), 0 ) ZAH_QUANT "
	Endif

	cQuery += "  FROM " + RetSQLName( "ZAH" ) + " ZAH "
	cQuery += " WHERE ZAH_FILIAL                 = '" + xFilial( "ZAH" ) + "' "
	cQuery += "   AND SUBSTR( ZAH_ANOMES, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_                 = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( ZAH_ANOMES, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( ZAH_ANOMES, 5, 2 )"
	Endif

	If Select( "TMP_ZAH" ) > 0
		TMP_ZAH->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAH", .T., .F. )

	If lDetal
		GetCabec( "TMP_ZAH", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_ZAH", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_ZAH->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_ZAH->( FCount() )
				aAdd( aAux, &( "TMP_ZAH->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_ZAH->( dbSkip() )
		End

	Else

		While TMP_ZAH->( !Eof() )
			aDados[4][Val( TMP_ZAH->ZAH_ANOMES ) + 1] := Transform( Val( aDados[4][Val( TMP_ZAH->ZAH_ANOMES ) + 1] ) + TMP_ZAH->ZAH_QUANT, "@E 9999999.99" )
			TMP_ZAH->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.99" )

	Endif
	TMP_ZAH->( dbCloseArea() )

	If lDetal
		cQuery := "SELECT '5' E1_TIPO, SRG.* "
	Else
		cQuery := "SELECT SUBSTR( RG_DATADEM, 5, 2 ) RG_DATADEM, COUNT(*) RG_QTD "
	Endif

	cQuery += "  FROM " + RetSQLName( "SRG" ) + " SRG "
	cQuery += " WHERE SUBSTR( RG_DATADEM, 5, 2 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND RG_TIPORES                 IN ( '06', '07' ) "
	cQuery += "   AND D_E_L_E_T_                 = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( RG_DATADEM, 5, 2 )"
		cQuery += " ORDER BY SUBSTR( RG_DATADEM, 5, 2 )"
	Endif

	If Select( "TMP_SRG" ) > 0
		TMP_SRG->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRG", .T., .F. )

	If lDetal
		GetCabec( "TMP_SRG", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SRG", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_SRG->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SRG->( FCount() )
				aAdd( aAux, &( "TMP_SRG->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SRG->( dbSkip() )
		End

	Else

		While TMP_SRG->( !Eof() )
			aDados[4][Val( TMP_SRG->RG_DATADEM ) + 1] := Transform( Val( aDados[4][Val( TMP_SRG->RG_DATADEM ) + 1] ) + TMP_SRG->RG_QTD, "@E 9999999.99" )
			TMP_SRG->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.99" )

	Endif

	TMP_SRG->( dbCloseArea() )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad033( aDados, aCabec, lDetal )

	Local cQuery  := ""

	Local nAux := 0

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	If lDetal
		cQuery := "SELECT * " 
	Else
		cQuery := "SELECT SUBSTR( B9_DATA, 5, 2 ) B9_DATA, B9_COD, SUM( B9_QINI / 1000 ) B9_QINI "
	Endif

	cQuery += "  FROM " + RetSQLName( "SB9" ) + " SB9 "
	cQuery += " WHERE B9_FILIAL = '" + xFilial( "SB9" ) + "' "
	cQuery += "   AND B9_COD    IN ( 'REM1M1000000001', "
	cQuery += "		 			     'REM3M3000000000', "
	cQuery += "					     'REM3M3000000001', "
	cQuery += "					     'REM7M7000000000', "
	cQuery += "					     'REMAM1400000000', "
	cQuery += "					     'REM3M1400000001', "
	cQuery += "					     'REM1M1000000000', "
	cQuery += "					     'REM6M6000000000', "
	cQuery += "					     'REM5M5000000000', "
	cQuery += "					     'REM2M2000000000', "
	cQuery += "					     'REM2M2000000001', "
	cQuery += "					     'REM2M2000000002', "
	cQuery += "					     'REM2M2000000003', "
	cQuery += "					     'REM8M8000000001', "
	cQuery += "					     'REM3M1400000000', "
	cQuery += "					     'REM8M1400000000', "
	cQuery += "					     'REM4M4000000000' ) "
	cQuery += "   AND SUBSTR( B9_DATA, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( B9_DATA, 5, 2 ), B9_COD "
		cQuery += " ORDER BY SUBSTR( B9_DATA, 5, 2 ), B9_COD "
	Endif

	If Select( "TMP_SB9" ) > 0
		TMP_SB9->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SB9", .T., .F. )

	If lDetal
		GetCabec( "TMP_SB9", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_SB9", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_SB9->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_SB9->( FCount() )
				aAdd( aAux, &( "TMP_SB9->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_SB9->( dbSkip() )
		End
	Else
		aAdd( aDados, { "Tot.Ger.de Risco - Resํduos", "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ", "Media", "Total" } )
		aAdd( aDados, { "Qtd (TON) de resํduo perigoso gerado sem reuso ou reciclagem						", Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ) } )
		aAdd( aDados, { "Qtd (TON) de resํduo perigoso gerado para reuso ou reciclagem						", Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ) } )
		aAdd( aDados, { "Qtd (TON) de resํduo nใo perigoso gerado sem reuso ou reciclagem					", Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ) } )
		aAdd( aDados, { "Qtd (TON) de resํduo nใo perigoso gerado para reuso ou reciclagem					", Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ) } )
		aAdd( aDados, { "Qtd (TON) de resํduo gerado pelo cliente, com disposi็ใo final por conta da "+SM0->M0_NOMECOM, Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ) } )
		aAdd( aDados, { "Vol (Mณ) de resํduos/efluentes lํquidos perigosos gerados						    ", Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ), Transform( 0, "@E 9999999.9999" ) } )

		While TMP_SB9->( !Eof() )

			nAux := 0
			If TMP_SB9->B9_COD $ "REM1M1000000001|REM3M3000000000|REM3M3000000001|REM7M7000000000|REMAM1400000000"
				nAux := 2

			ElseIf TMP_SB9->B9_COD $ "REM3M1400000001"
				nAux := 3

			ElseIf TMP_SB9->B9_COD $ "REM1M1000000000|REM6M6000000000|REM5M5000000000"
				nAux := 4

			ElseIf TMP_SB9->B9_COD $ "REM2M2000000000|REM2M2000000001|REM2M2000000002|REM2M2000000003|REM8M8000000001"
				nAux := 5

			ElseIf TMP_SB9->B9_COD $ "REM3M1400000000|REM8M1400000000"
				nAux := 6

			ElseIf TMP_SB9->B9_COD $ "REM4M4000000000"
				nAux := 7

			Endif

			If !Empty( nAux )
				aDados[nAux][Val(TMP_SB9->B9_DATA)+1] := Transform( Val( aDados[nAux][Val(TMP_SB9->B9_DATA)+1] ) + TMP_SB9->B9_QINI, "@E 9999999.9999" )
			Endif

			TMP_SB9->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999.9999" )
	Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad10( aDados, aCabec, lDetal )

	Local cQuery  := ""

	Local nAux := 0

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	If lDetal
		cQuery := "SELECT * " 
	Else
		cQuery := "SELECT SUBSTR( TNC_DTACID, 5, 2 ) TNC_DTACID, TNC_TIPACI, COUNT(*) TNC_QTD "
	Endif

	cQuery += "  FROM " + RetSQLName( "TNC" )
	cQuery += " WHERE TNC_FILIAL = '" + xFilial( "TNC" ) + "' "
	cQuery += "   AND TNC_TIPACI IN ( 	'INC-SIT0001', "
	cQuery += "   						'INC-TRA0001', "
	cQuery += "   						'INC-TER0001', "
	cQuery += "   						'INC-CLI0001', "
	cQuery += "   						'INC-SIT0002' ) "
	cQuery += "   AND SUBSTR( TNC_DTACID, 1, 4 ) = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "

	If !lDetal
		cQuery += " GROUP BY SUBSTR( TNC_DTACID, 5, 2 ), TNC_TIPACI "
		cQuery += " ORDER BY SUBSTR( TNC_DTACID, 5, 2 ), TNC_TIPACI "
	Endif

	If Select( "TMP_TNC" ) > 0
		TMP_TNC->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_TNC", .T., .F. )

	If lDetal
		GetCabec( "TMP_TNC", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_TNC", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_TNC->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_TNC->( FCount() )
				aAdd( aAux, &( "TMP_TNC->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_TNC->( dbSkip() )
		End
	Else
		aAdd( aDados, { "Total Incidentes", "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ", "Media", "Total" } )
		aAdd( aDados, { "Nบ Tot.Incid. ocorridos durante as opera็๕es de carga e descarga de produtos quํmicos, perigosos e nใo perigosos, dentro da empresa		  ", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )
		aAdd( aDados, { "Nบ Tot.Incid. envolvendo veํculo pr๓prio, agregado, de transportador CIF e FOB																  ", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )
		aAdd( aDados, { "Nบ Tot.Incid. ocorridos durante as opera็๕es de carga e descarga de produtos quํmicos perigosos e nใo perigosos nas instala็๕es do contratado", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )
		aAdd( aDados, { "Nบ Tot.Incid. ocorridos durante as opera็๕es de carga e descarga de produtos quํmicos perigosos e nใo perigosos nas instala็๕es do cliente	  ", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )
		aAdd( aDados, { "Nบ Tot.Incid. ocorridos dentro da empresa sem envolvimento de produtos quํmicos															  ", Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ), Transform( 0, "@E 9999999" ) } )

		While TMP_TNC->( !Eof() )

			nAux := 0
			If TMP_TNC->TNC_TIPACI $ "INC-SIT0001 "
				nAux := 2

			ElseIf TMP_TNC->TNC_TIPACI $ "INC-TRA0001 "
				nAux := 3

			ElseIf TMP_TNC->TNC_TIPACI $ "INC-TER0001 "
				nAux := 4

			ElseIf TMP_TNC->TNC_TIPACI $ "INC-CLI0001 "
				nAux := 5

			ElseIf TMP_TNC->TNC_TIPACI $ "INC-SIT0002 "
				nAux := 6

			Endif

			If !Empty( nAux )
				aDados[nAux][Val(TMP_TNC->TNC_DTACID)+1] := Transform( Val( aDados[nAux][Val(TMP_TNC->TNC_DTACID)+1] ) + TMP_TNC->TNC_QTD, "@E 9999999" )
			Endif

			TMP_TNC->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999" )
	Endif

	Return



Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad1231( aDados, aCabec, lDetal )

	Local cQuery 	:= ""

	Local nAux	:= 0

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	cQuery := "SELECT * "
	cQuery += "  FROM " + RetSQLName( "ZAE" ) 
	cQuery += " WHERE ZAE_FILIAL = '" + xFilial( "ZAE" ) + "' "
	cQuery += "   AND ZAE_ANO    = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY ZAE_CODIGO "

	If Select( "TMP_ZAE" ) > 0
		TMP_ZAE->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAE", .T., .F. )

	If lDetal
		GetCabec( "TMP_ZAE", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_ZAE", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_ZAE->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_ZAE->( FCount() )
				aAdd( aAux, &( "TMP_ZAE->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_ZAE->( dbSkip() )
		End
	Else
		aAdd( aDados, { "Meses", "JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ", "Media", "Total" } )

		While TMP_ZAE->( !Eof() )

			aAdd( aDados, { TMP_ZAE->ZAE_DESCRI, 	Transform( TMP_ZAE->ZAE_01, "@E 9999999999" ),;
			Transform( TMP_ZAE->ZAE_02, "@E 9999999999" ),;
			Transform( TMP_ZAE->ZAE_03, "@E 9999999999" ),;
			Transform( TMP_ZAE->ZAE_04, "@E 9999999999" ),;
			Transform( TMP_ZAE->ZAE_05, "@E 9999999999" ),;
			Transform( TMP_ZAE->ZAE_06, "@E 9999999999" ),;
			Transform( TMP_ZAE->ZAE_07, "@E 9999999999" ),;
			Transform( TMP_ZAE->ZAE_08, "@E 9999999999" ),;
			Transform( TMP_ZAE->ZAE_09, "@E 9999999999" ),;
			Transform( TMP_ZAE->ZAE_10, "@E 9999999999" ),;
			Transform( TMP_ZAE->ZAE_11, "@E 9999999999" ),;
			Transform( TMP_ZAE->ZAE_12, "@E 9999999999" ),;
			Transform( 0, "@E 9999999999" ),;
			Transform( 0, "@E 9999999999" ) } )

			TMP_ZAE->( dbSkip() )
		End

		RecalDados( @aDados, "@E 9999999999" )
	Endif

	TMP_ZAE->( dbCloseArea() )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad1232( aDados, aCabec, lDetal )

	Local cQuery := ""

	Local nAux	:= 0

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	If !lDetal

		cQuery := "SELECT * "
		cQuery += "  FROM " + RetSQLName( "ZAE" ) 
		cQuery += " WHERE ZAE_FILIAL = '" + xFilial( "ZAE" ) + "' "
		cQuery += "   AND ZAE_ANO    = '" + MV_PAR01 + "' "
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY ZAE_CODIGO "

		If Select( "TMP_ZAE" ) > 0
			TMP_ZAE->( dbCloseArea() )	
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAE", .T., .F. )

		aAdd( aDados, { "Anแlise					", AllTrim( Str( Val( MV_PAR01 ) - 2 ) ), AllTrim( Str( Val( MV_PAR01 ) - 1 ) ), MV_PAR01, AllTrim( Str( Val( MV_PAR01 ) - 1 ) ) + " x " + MV_PAR01 } )
		While TMP_ZAE->( !Eof() )
			aAdd( aDados, { TMP_ZAE->ZAE_DESCRI, Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 9999999999" ), Transform( 0, "@E 99.99" ) + "%" } )
			TMP_ZAE->( dbSkip() )
		End
		TMP_ZAE->( dbCloseArea() )

		cQuery := "SELECT * "
		cQuery += "  FROM " + RetSQLName( "ZAE" ) 
		cQuery += " WHERE ZAE_FILIAL = '" + xFilial( "ZAE" ) + "' "
		cQuery += "   AND ZAE_ANO    = '" + AllTrim( Str( Val( MV_PAR01 ) - 2 ) ) + "' "
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY ZAE_CODIGO "

		If Select( "TMP_ZAE" ) > 0
			TMP_ZAE->( dbCloseArea() )	
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAE", .T., .F. )

		nAux := 1
		While TMP_ZAE->( !Eof() )
			nAux++

			aDados[nAux][2] := 	Transform( ;
			TMP_ZAE->ZAE_01 + ;
			TMP_ZAE->ZAE_02 + ;
			TMP_ZAE->ZAE_03 + ;
			TMP_ZAE->ZAE_04 + ;
			TMP_ZAE->ZAE_05 + ;
			TMP_ZAE->ZAE_06 + ;
			TMP_ZAE->ZAE_07 + ;
			TMP_ZAE->ZAE_08 + ;
			TMP_ZAE->ZAE_09 + ;
			TMP_ZAE->ZAE_10 + ;
			TMP_ZAE->ZAE_11 + ;
			TMP_ZAE->ZAE_12, "@E 9999999999" )

			TMP_ZAE->( dbSkip() )
		End
		TMP_ZAE->( dbCloseArea() )	

		cQuery := "SELECT * "
		cQuery += "  FROM " + RetSQLName( "ZAE" ) 
		cQuery += " WHERE ZAE_FILIAL = '" + xFilial( "ZAE" ) + "' "
		cQuery += "   AND ZAE_ANO    = '" + AllTrim( Str( Val( MV_PAR01 ) - 1 ) ) + "' "
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY ZAE_CODIGO "

		If Select( "TMP_ZAE" ) > 0
			TMP_ZAE->( dbCloseArea() )	
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAE", .T., .F. )

		nAux := 1
		While TMP_ZAE->( !Eof() )
			nAux++

			aDados[nAux][3] := 	Transform( ;
			TMP_ZAE->ZAE_01 + ;
			TMP_ZAE->ZAE_02 + ;
			TMP_ZAE->ZAE_03 + ;
			TMP_ZAE->ZAE_04 + ;
			TMP_ZAE->ZAE_05 + ;
			TMP_ZAE->ZAE_06 + ;
			TMP_ZAE->ZAE_07 + ;
			TMP_ZAE->ZAE_08 + ;
			TMP_ZAE->ZAE_09 + ;
			TMP_ZAE->ZAE_10 + ;
			TMP_ZAE->ZAE_11 + ;
			TMP_ZAE->ZAE_12, "@E 9999999999" )							

			TMP_ZAE->( dbSkip() )
		End
		TMP_ZAE->( dbCloseArea() )	

		cQuery := "SELECT * "
		cQuery += "  FROM " + RetSQLName( "ZAE" ) 
		cQuery += " WHERE ZAE_FILIAL = '" + xFilial( "ZAE" ) + "' "
		cQuery += "   AND ZAE_ANO    = '" + MV_PAR01 + "' "
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY ZAE_CODIGO "

		If Select( "TMP_ZAE" ) > 0
			TMP_ZAE->( dbCloseArea() )	
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAE", .T., .F. )

		nAux := 1
		While TMP_ZAE->( !Eof() )
			nAux++

			aDados[nAux][4] := 	Transform( ;
			TMP_ZAE->ZAE_01 + ;
			TMP_ZAE->ZAE_02 + ;
			TMP_ZAE->ZAE_03 + ;
			TMP_ZAE->ZAE_04 + ;
			TMP_ZAE->ZAE_05 + ;
			TMP_ZAE->ZAE_06 + ;
			TMP_ZAE->ZAE_07 + ;
			TMP_ZAE->ZAE_08 + ;
			TMP_ZAE->ZAE_09 + ;
			TMP_ZAE->ZAE_10 + ;
			TMP_ZAE->ZAE_11 + ;
			TMP_ZAE->ZAE_12, "@E 9999999999" )

			TMP_ZAE->( dbSkip() )
		End
		TMP_ZAE->( dbCloseArea() )	



		For nLoop := 2 To Len( aDados )

			If Val( aDados[nLoop][3] ) > Val( aDados[nLoop][4] )
				nAux := ( Val( aDados[nLoop][4] ) / Val( aDados[nLoop][3] ) ) * 100
			ElseIf Val( aDados[nLoop][3] ) < Val( aDados[nLoop][4] )
				nAux := ( Val( aDados[nLoop][3] ) / Val( aDados[nLoop][4] ) ) * 100
			Else
				nAux := 0
			Endif

			aDados[nLoop][5] := Transform( nAux, "@E 999.99" ) + "%"

		Next nLoop

	Else

		cQuery := "SELECT * "
		cQuery += "  FROM " + RetSQLName( "ZAE" ) 
		cQuery += " WHERE ZAE_FILIAL = '" + xFilial( "ZAE" ) + "' "
		cQuery += "   AND ZAE_ANO    IN ( '" + AllTrim( Str( Val( MV_PAR01 ) - 2 ) ) + "','" + AllTrim( Str( Val( MV_PAR01 ) - 1 ) ) + "','" + MV_PAR01 + "' )"
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY ZAE_ANO, ZAE_CODIGO "

		If Select( "TMP_ZAE" ) > 0
			TMP_ZAE->( dbCloseArea() )	
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAE", .T., .F. )

		GetCabec( "TMP_ZAE", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_ZAE", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_ZAE->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_ZAE->( FCount() )
				aAdd( aAux, &( "TMP_ZAE->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_ZAE->( dbSkip() )
		End

		TMP_ZAE->( dbCloseArea() )	

	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDad11( aDados, aCabec, lDetal )

	Local cQuery := ""

	Local nAux	:= 0

	Local nLoop     := 0
	Local aAux		:= ""

	Local aStruct	:= {}

	Default aCabec := {}
	Default lDetal := .F.

	cQuery := "SELECT * "
	cQuery += "  FROM " + RetSQLName( "ZAF" )
	cQuery += " WHERE ZAF_FILIAL = '" + xFilial( "ZAF" ) + "' "
	cQuery += "   AND ZAF_ANO    = '" + MV_PAR01 + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	If Select( "TMP_ZAF" ) > 0
		TMP_ZAF->( dbCloseArea() )
	Endif
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_ZAF", .T., .F. )

	If !lDetal

		aAdd( aDados, { "Nบ - Indicador", "M้dia", "Meta", "Min/Max", "Atingida?" } )
		aAdd( aDados, { "01 - IQF de clientes												", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "02 - Embarques CIF (%)												", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "03 - Embarques FOB (%)												", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "04 - Gera็ใo de efluente lํquido (mณ/ton)							", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "05 - Embalagens avariadas / total de embalagens (%)				", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "06 - Embalagens avariadas /ton de produto vendido (%)				", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "07 - อndice de treinamentos (% horas de treinamento)				", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "08 - Absenteํsmo													", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "09 - อndice de gera็ใo de resํduo s๓lido reciclแvel (kg/t vendida)	", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "10 - อndice de consumo de แgua (mณ/t vendida)						", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "11 - อndice de consumo de energia el้trica (kwh/t vendida)			", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "12 - อndice de fuma็a (%)											", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "13 - Pedidos incorretos / total de pedidos inseridos no sistema (%)", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )
		aAdd( aDados, { "14 - Varia็ใo no recebimento de granel								", Transform( 0, "@E 999,999,999.9999" ), Transform( 0, "@E 999,999,999.9999" ), Space(2), Space(3) } )

		If TMP_ZAF->( !Eof() )

			For nLoop := 1 To 14

				aDados[nLoop+1][2] := GetCal11( nLoop )
				aDados[nLoop+1][3] := Transform( &("TMP_ZAF->ZAF_" + StrZero( nLoop, 2 ) + "META"), "@E 999,999,999.9999" )

				If &("TMP_ZAF->ZAF_" + StrZero( nLoop, 2 ) + "MM" ) == "1"
					aDados[nLoop+1][4] := "Mํnimo"

					If Val( aDados[nLoop+1][2] ) >= Val( aDados[nLoop+1][3] )
						aDados[nLoop+1][5] := "Sim"
					Else
						aDados[nLoop+1][5] := "Nใo"
					Endif

				Else
					aDados[nLoop+1][4] := "Mแximo"

					If Val( aDados[nLoop+1][2] ) <= Val( aDados[nLoop+1][3] )
						aDados[nLoop+1][5] := "Sim"
					Else
						aDados[nLoop+1][5] := "Nใo"
					Endif

				Endif

			Next nLoop

		EndIf

	Else
		GetCabec( "TMP_ZAF", @aCabec, @aStruct )
		aEval( aStruct, { |_e| If( _e[2] != "C", TCSetField( "TMP_ZAF", _e[1], _e[2], _e[3], _e[4] ), Nil ) } )
		While TMP_ZAF->( !Eof() )

			aAux := {}
			For nLoop := 1 To TMP_ZAF->( FCount() )
				aAdd( aAux, &( "TMP_ZAF->" + ( FieldName( nLoop ) ) ) )
			Next nLoop

			aAdd( aDados, aClone( aAux ) )

			TMP_ZAF->( dbSkip() )
		End

	Endif	

	TMP_ZAF->( dbCloseArea() )	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PDDetal( oTree )

	Local cCargo := SubStr( oTree:GetCargo(), 1, 2 )
	Local cNivel := Right( oTree:GetCargo(), 4 )

	Local aCabec := {}
	Local aDados := {}

	If !( cCargo + cNivel $ "020000|030001|030002|030003|040000|050000|060000|070000|080000|090000|100000|110000|120001|120002|121231|121232" )
		MsgStop( "Este nivel da arvore nao permite detalhamento para Excel" )
		Return
	Endif

	If cCargo == "02"
		If cNivel == "0000"
			MsgRun("Montando Dados...", "", { || GetDad02( @aDados, @aCabec, .T. ) } )
		Endif

	ElseIf cCargo == "03"

		If cNivel == "0001"
			MsgRun("Montando Dados...", "", { || GetDad031( @aDados, @aCabec, .T. ) } )

		ElseIf cNivel == "0002"
			MsgRun("Montando Dados...", "", { || GetDad032( @aDados, @aCabec, .T. ) } )

		ElseIf cNivel == "0003"
			MsgRun("Montando Dados...", "", { || GetDad033( @aDados, @aCabec, .T. ) } )

		Endif 

	ElseIf cCargo == "04"
		MsgRun("Montando Dados...", "", { || GetDad04( @aDados, @aCabec, .T. ) } )

	ElseIf cCargo == "05"

		If cNivel == "0000"
			MsgRun("Montando Dados...", "", { || GetDad05( @aDados, @aCabec, .T. ) } )
		Endif 

	ElseIf cCargo == "06"
		MsgRun("Montando Dados...", "", { || GetDad06( @aDados, @aCabec, .T. ) } )

	ElseIf cCargo == "07"
		MsgRun("Montando Dados...", "", { || GetDad07( @aDados, @aCabec, .T. ) } )

	ElseIf cCargo == "08"
		MsgRun("Montando Dados...", "", { || GetDad08( @aDados, @aCabec, .T. ) } )

	ElseIf cCargo == "09"
		MsgRun("Montando Dados...", "", { || GetDad09( @aDados, @aCabec, .T. ) } )

	ElseIf cCargo == "10"
		MsgRun("Montando Dados...", "", { || GetDad10( @aDados, @aCabec, .T. ) } )

	ElseIf cCargo == "11"
		MsgRun("Montando Dados...", "", { || GetDad11( @aDados, @aCabec, .T. ) } )

	ElseIf cCargo == "12"

		If cNivel == "0001"
			MsgRun("Montando Dados...", "", { || GetDad121( @aDados, @aCabec, .T. ) } )

		Elseif cNivel == "0002"
			MsgRun("Montando Dados...", "", { || GetDad122( @aDados, @aCabec, .T. ) } )

		Elseif cNivel == "1231"
			MsgRun("Montando Dados...", "", { || GetDad1231( @aDados, @aCabec, .T. ) } )

		Elseif cNivel == "1232"
			MsgRun("Montando Dados...", "", { || GetDad1232( @aDados, @aCabec, .T. ) } )

		Endif

	Endif

	If Empty( aDados )
		Return
	Endif

	DlgToExcel( { {"ARRAY", "PRODIR - Exporta็ใo Excel - Detalhamento", aCabec, aDados } } )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetCabec( cArea, aCabec, aStruct )

	Local aAreaAtu := GetArea()
	Local aAreaSX3 := GetArea()
	Local nLoop := 0
	Local aSX3  := {}

	aSX3 := FWSX3Util():GetAllFields( cArea , .F. )

	For nLoop := 1 To len(cArea)
			aAdd( aCabec, (X3Titulo() ) )
			aAdd( aStruct, { AllTrim( GetSX3Cache(aSX3[nLoop],"X3_CAMPO") ), GetSX3Cache(aSX3[nLoop],"X3_TIPO"), GetSX3Cache(aSX3[nLoop],"X3_TAMANHO"), GetSX3Cache(aSX3[nLoop],"X3_DECIMAL") } )
	Next nLoop

	RestArea( aAreaSX3 )
	RestArea( aAreaAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RecalDados( aDados, cPict )

	Local nMes := Month( Date() )

	Local nLoop1 := 0
	Local nLoop2 := 0

	Local nAux   := 0

	For nLoop1 := 2 To Len( aDados )
		nAux := 0
		For nLoop2 := 2 To 13
			nAux += Val( StrTran( aDados[nLoop1][nLoop2], ",", "." ) )
		Next nLoop2 
		aDados[nLoop1][15] := Transform( nAux, cPict )
		aDados[nLoop1][14] := Transform( nAux / nMes, cPict )
	Next nLoop1

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PDIncApr( oTree )

	Local cCargo := SubStr( oTree:GetCargo(), 1, 2 )
	Local cNivel := Right( oTree:GetCargo(), 4 )

	Local cObs	 := Space( 300 )

	Local aProDir := {}

	If !( cCargo + cNivel $ "020000|030001|030002|030003|040000|050000|060000|070000|080000|090000|100000|110000|120001|120002|121231|121232" )
		MsgStop( "Este nivel da arvore nao permite Aprova็ใo" )
		Return
	Endif

	aAdd( aProDir, { "020000", "Requisitos Legais" } )
	aAdd( aProDir, { "030001", "Gerenciamento de Risco - Acidentes" } )
	aAdd( aProDir, { "030002", "Gerenciamento de Risco - Perdas" } )
	aAdd( aProDir, { "030003", "Gerenciamento de Risco - Resํduos" } )
	aAdd( aProDir, { "040000", "Treinamento" } )
	aAdd( aProDir, { "050000", "Intera็ใo com Comunidade" } )
	aAdd( aProDir, { "060000", "Consumo" } )
	aAdd( aProDir, { "070000", "Embalagens" } )
	aAdd( aProDir, { "080000", "Transportes" } )
	aAdd( aProDir, { "090000", "Vendas" } )
	aAdd( aProDir, { "100000", "Incidentes" } )
	aAdd( aProDir, { "110000", "Anแlise de Desempenho" } )
	aAdd( aProDir, { "120001", "Resumo de Movimenta็ใo do RH" } )
	aAdd( aProDir, { "120002", "Identifica็ใo de forma็ใo" } )
	aAdd( aProDir, { "121231", "Ensaios Realizados por M๊s" } )
	aAdd( aProDir, { "121232", "Ensaios Realizados por Ano" } )

	If MsgYesNo( "Deseja Efetuar a Aprova็ใo dos Dados do Nivel Posicionado?. Serแ registrado o nivel posicionado, usuario, data, hora e observa็ใo sobre a aprova็ใo. Confirma?" )
		If MsgGet2("Observa็๕es", "Observa็๕es:", @cObs, , { || .T. } )

			RecLock( "ZAL", .T. )
			ZAL->ZAL_FILIAL	:= xFilial( "ZAL" )
			ZAL->ZAL_ID		:= cCargo + cNivel
			ZAL->ZAL_DESCID	:= aProDir[ aScan( aProDir, { |x| x[1] == cCargo + cNivel } ) ][2]
			ZAL->ZAL_USUARI	:= __cUserID
			ZAL->ZAL_NOMUSR	:= SubStr( cUsuario, 7, 15 )
			ZAL->ZAL_DATA  	:= Date()
			ZAL->ZAL_HORA  	:= Time()
			ZAL->ZAL_MOTIVO	:= cObs
			ZAL->( MsUnLock() )

		Endif

	Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PDVisApr( oTree )

	Local aAreaAtu := GetArea()

	Private cCadastro := "Log Aprova็ใo ProDir"
	Private aRotina   := { 	{ "Pesquisar" , "PesqBrw"    , 0, 1, 0, .F. },;
	{ "Visualizar", "AxVisual"   , 0, 2, 0, .F. } }

	MBrowse( Nil, Nil, Nil, Nil, "ZAL" )

	RestArea( aAreaAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPRODIR   บAutor  ณMicrosiga           บ Data ณ  05/19/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetCal11( nIndic )

	Local cMes := AllTrim( Str( Month( Date() ) ) )
	Local cQuery := ""

	Local aDados 	:= {}
	Local nCntFor  	:= 0

	Local nRet := 0

	Local nAux := 0

	Local nCIF := 0
	Local nFOB := 0

	If nIndic == 1
		nRet := TMP_ZAF->ZAF_01IQF

	ElseIf nIndic == 2 .or. nIndic == 3

		cQuery := "SELECT COUNT( DISTINCT F2_DOC ) / " + cMes + " F2_QTD "
		cQuery += "  FROM " + RetSQLName( "SF2" ) + " SF2 "
		cQuery += "  JOIN " + RetSQLName( "SD2" ) + " SD2 ON D2_FILIAL = '" + xFilial( "SD2" ) + "' AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND SD2.D_E_L_E_T_ = ' ' "
		cQuery += "  JOIN " + RetSQLName( "SF4" ) + " SF4 ON F4_FILIAL = '" + xFilial( "SF4" ) + "' AND F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = ' ' "
		cQuery += "  JOIN " + RetSQLName( "SC6" ) + " SC6 ON C6_FILIAL = '" + xFilial( "SC6" ) + "' AND C6_NUM = D2_PEDIDO AND SC6.D_E_L_E_T_ = ' ' "
		cQuery += "  JOIN " + RetSQLName( "SC5" ) + " SC5 ON C5_FILIAL = '" + xFilial( "SC5" ) + "' AND C5_NUM = C6_NUM AND SC5.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE F2_FILIAL                  = '" + xFilial( "SF2" ) + "' "
		cQuery += "   AND SUBSTR( F2_EMISSAO, 1, 4 ) = '" + MV_PAR01 + "' "
		cQuery += "   AND F4_ESTOQUE                 = 'S' "
		cQuery += "   AND C5_TPFRETE                 = 'C' "
		cQuery += "   AND SF2.D_E_L_E_T_             = ' ' "
		cQuery += " UNION "
		cQuery += "SELECT COUNT( DISTINCT F2_DOC ) / " + cMes + " F2_QTD "
		cQuery += "  FROM " + RetSQLName( "SF2" ) + " SF2 "
		cQuery += "  JOIN " + RetSQLName( "SD2" ) + " SD2 ON D2_FILIAL = '" + xFilial( "SD2" ) + "' AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND SD2.D_E_L_E_T_ = ' ' "
		cQuery += "  JOIN " + RetSQLName( "SF4" ) + " SF4 ON F4_FILIAL = '" + xFilial( "SF4" ) + "' AND F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = ' ' "
		cQuery += "  JOIN " + RetSQLName( "SC6" ) + " SC6 ON C6_FILIAL = '" + xFilial( "SC6" ) + "' AND C6_NUM = D2_PEDIDO AND SC6.D_E_L_E_T_ = ' ' "
		cQuery += "  JOIN " + RetSQLName( "SC5" ) + " SC5 ON C5_FILIAL = '" + xFilial( "SC5" ) + "' AND C5_NUM = C6_NUM AND SC5.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE F2_FILIAL                  = '" + xFilial( "SF2" ) + "' "
		cQuery += "   AND SUBSTR( F2_EMISSAO, 1, 4 ) = '" + MV_PAR01 + "' "
		cQuery += "   AND F4_ESTOQUE                 = 'S' "
		cQuery += "   AND C5_TPFRETE                 = 'F' "
		cQuery += "   AND SF2.D_E_L_E_T_             = ' ' "
		If Select( "TMP_SF2" ) > 0
			TMP_SF2->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SF2", .T., .F. )
		TMP_SF2->( dbGoTop() )
		TMP_SF2->( dbEval( { || nAux += TMP_SF2->F2_QTD } ) )
		TMP_SF2->( dbGoTop() )

		If !Empty( nAux )
			nFOB := TMP_SF2->F2_QTD

			TMP_SF2->( dbSkip() )

			nCIF := TMP_SF2->F2_QTD

			If nIndic == 2
				nRet := ( nCIF / nAux ) * 100

			Else
				nRet := ( nFOB / nAux ) * 100

			Endif

		Endif
		TMP_SF2->( dbCloseArea() )

	ElseIf nIndic == 4
		GetDad09( @aDados )
		For nCntFor := 2 To Len( aDados )
			nAux += Val( StrTran( aDados[nCntFor][14], ",", "." ) )
		Next nCntFor

		aDados:= {}
		GetDad033( @aDados )
		nRet := Val( StrTran( aDados[7][14], ",", "." ) )
		nRet := ( nRet / nAux ) * 100

	ElseIf nIndic == 5
		GetDad07( @aDados )
		nRet := ( Val( StrTran( aDados[2][14], ",", "." ) ) / Val( StrTran( aDados[3][14], ",", "." ) ) ) * 100

	ElseIf nIndic == 6
		GetDad09( @aDados )
		For nCntFor := 2 To Len( aDados )
			nAux += Val( StrTran( aDados[nCntFor][14], ",", "." ) )
		Next nCntFor

		aDados := {}
		GetDad07( @aDados )
		nRet := Val( StrTran( aDados[2][14], ",", "." ) )
		nRet := ( nRet / nAux ) * 100

	ElseIf nIndic == 7
		GetDad04( @aDados )
		nAux := Val( StrTran( aDados[2][14], ",", "." ) )

		aDados := {}
		GetDad032( @aDados )
		nRet := Val( StrTran( aDados[4][14], ",", "." ) )

		nRet := ( nAux / nRet ) * 100

	ElseIf nIndic == 8
		cQuery := "SELECT RD_MES, SUM( CASE WHEN RD_PD = '101' THEN RD_HORAS * RCF_HRSDIA ELSE RD_HORAS END ) RD_HORAS "
		cQuery += "  FROM " + RetSQLName( "SRD" ) + " SRD "
		cQuery += "  JOIN " + RetSQLName( "RCF" ) + " RCF ON RCF_MES = RD_MES AND RCF_ANO = '" + MV_PAR01 + "' AND RCF.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE SUBSTR( RD_DATARQ, 1, 4 ) = '" + MV_PAR01 + "' "
		cQuery += "   AND RD_PD IN ( '101', '136', '137', '138', '139', '147', '156', '167', '168', '169', '207', '384' ) "
		cQuery += "   AND SRD.D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY RD_MES "
		cQuery += " ORDER BY RD_MES "
		If Select( "TMP_SRD" ) > 0
			TMP_SRD->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRD", .T., .F. )
		While TMP_SRD->( !Eof() )
			nAux += TMP_SRD->RD_HORAS
			TMP_SRD->( dbSkip() )
		End
		TMP_SRD->( dbCloseArea() )

		cQuery := "SELECT RD_MES, SUM( CASE WHEN RD_PD IN ( '416', '480' ) THEN RD_HORAS * RCF_HRSDIA ELSE RD_HORAS END ) RD_HORAS "
		cQuery += "  FROM " + RetSQLName( "SRD" ) + " SRD "
		cQuery += "  JOIN " + RetSQLName( "RCF" ) + " RCF ON RCF_MES = RD_MES AND RCF_ANO = '" + MV_PAR01 + "' AND RCF.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE SUBSTR( RD_DATARQ, 1, 4 ) = '" + MV_PAR01 + "' "
		cQuery += "   AND RD_PD IN ( '416', '433', '478', '480', '481' ) "
		cQuery += "   AND SRD.D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY RD_MES "
		cQuery += " ORDER BY RD_MES "
		If Select( "TMP_SRD" ) > 0
			TMP_SRD->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SRD", .T., .F. )
		While TMP_SRD->( !Eof() )
			nRet += TMP_SRD->RD_HORAS
			TMP_SRD->( dbSkip() )
		End
		nAux := nAux / Month( Date() )
		nRet := nRet / Month( Date() )
		nRet := ( nRet / nAux ) * 100

	ElseIf nIndic == 9
		GetDad09( @aDados )
		For nCntFor := 2 To Len( aDados )
			nAux += Val( StrTran( aDados[nCntFor][14], ",", "." ) )
		Next nCntFor

		aDados:= {}
		GetDad033( @aDados )
		nRet := Val( StrTran( aDados[5][14], ",", "." ) )
		nRet := nRet / nAux

	ElseIf nIndic == 10
		GetDad09( @aDados )
		For nCntFor := 2 To Len( aDados )
			nAux += Val( StrTran( aDados[nCntFor][14], ",", "." ) )
		Next nCntFor

		aDados:= {}
		GetDad06( @aDados )
		nRet := Val( StrTran( aDados[3][14], ",", "." ) )
		nRet := nRet / nAux

	ElseIf nIndic == 11
		GetDad09( @aDados )
		For nCntFor := 2 To Len( aDados )
			nAux += Val( StrTran( aDados[nCntFor][14], ",", "." ) )
		Next nCntFor

		aDados:= {}
		GetDad06( @aDados )
		nRet := Val( StrTran( aDados[2][14], ",", "." ) )
		nRet := nRet / nAux

	ElseIf nIndic == 12
		nRet := TMP_ZAF->ZAF_12IF

	ElseIf nIndic == 13
		cQuery := "SELECT COUNT( DISTINCT C5_NUM ) C5_QTD "
		cQuery += "  FROM " + RetSQLName( "SC5" )
		cQuery += " WHERE C5_FILIAL                  = '" + xFilial( "SC5" ) + "' "
		cQuery += "   AND SUBSTR( C5_EMISSAO, 1, 4 ) = '" + MV_PAR01 + "' "
		cQuery += "   AND D_E_L_E_T_                 = ' ' "
		If Select( "TMP_SC5" ) > 0
			TMP_SC5->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SC5", .T., .F. )
		nAux := TMP_SC5->C5_QTD
		TMP_SC5->( dbCloseArea() )

		cQuery := "SELECT COUNT( DISTINCT QI2_FNC ) QI2_QTD "
		cQuery += "  FROM " + RetSQLName( "QI2" )               
		cQuery += " WHERE QI2_FILIAL = '" + xFilial( "QI2" ) + "' "
		cQuery += "   AND QI2_ANO    = '" + MV_PAR01 + "' "
		cQuery += "   AND QI2_CODCAU IN ( 'PC00015','PC00023','PC00024','PC00025','PC00026','PC00027','PC00028','PC00029','PC00030','PC00031','PC00032','PC00033','PC00034','PC00035' ) "
		cQuery += "   AND D_E_L_E_T_ = ' ' "
		If Select( "TMP_QI2" ) > 0
			TMP_QI2->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_QI2", .T., .F. )
		nRet := TMP_QI2->QI2_QTD
		TMP_QI2->( dbCloseArea() )

		nRet := ( nRet / nAux ) * 100

	ElseIf nIndic == 14

		cQuery := "SELECT SUM( PESOREC ) PESOREC, SUM( CASE WHEN QTDVARIA > 0 THEN QTDVARIA ELSE 0 END ) SOBRA, ABS( SUM( CASE WHEN QTDVARIA < 0 THEN QTDVARIA ELSE 0 END ) ) FALTA "
		cQuery += "  FROM ( "
		cQuery += "		SELECT SD1.D1_DTDIGIT, D1_DOC, D1_COD, "
		cQuery += "		       SUM( SB1.B1_PESO * SD1.D1_QUANT ) PESOORI, "
		cQuery += "		       SUM( SZI.ZI_PESINI - SZI.ZI_PESFIM) PESOREC, "
		cQuery += "		       SUM( (SZI.ZI_PESINI - SZI.ZI_PESFIM) - (SB1.B1_PESO * SD1.D1_QUANT) ) QTDVARIA, "
		cQuery += "		       DECODE( ABS( SUM( (SZI.ZI_PESINI - SZI.ZI_PESFIM) - (SB1.B1_PESO * SD1.D1_QUANT) ) * 100) / SUM( SB1.B1_PESO * SD1.D1_QUANT ), NULL, 0,  ABS(SUM( (SZI.ZI_PESINI - SZI.ZI_PESFIM) - (SB1.B1_PESO * SD1.D1_QUANT) )*100) / SUM( SB1.B1_PESO * SD1.D1_QUANT ) ) PERCVARIA, "
		cQuery += "		       COUNT(DISTINCT SD1.D1_COD) QTDPROD "
		cQuery += "	      FROM " + RetSQLName( "SD1" ) + " SD1 "
		cQuery += "		  LEFT JOIN " + RetSQLName( "SZI" ) + " SZI ON SZI.ZI_FILIAL = '" + xFilial( "SZI" ) + "' AND SZI.ZI_DOC = SD1.D1_DOC AND SZI.ZI_SERIE = SD1.D1_SERIE   AND SZI.ZI_ITEM = SD1.D1_ITEM   AND SZI.ZI_FORNECE = SD1.D1_FORNECE AND SZI.ZI_LOJA = SD1.D1_LOJA   AND SZI.D_E_L_E_T_ = ' ' "
		cQuery += "	     INNER JOIN " + RetSQLName( "SB1" ) + " SB1 ON SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.B1_COD = SD1.D1_COD   AND SB1.D_E_L_E_T_ = ' ' "
		cQuery += "	     INNER JOIN " + RetSQLName( "SF1" ) + " SF1 ON SF1.F1_FILIAL = '" + xFilial( "SF1" ) + "' AND SF1.F1_DOC = SD1.D1_DOC   AND SF1.F1_SERIE = SD1.D1_SERIE  AND SF1.D_E_L_E_T_ = ' '   AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA "
		cQuery += "	     WHERE SD1.D1_FILIAL  = '" + xFilial( "SD2" ) + "' "
		cQuery += "	       AND SD1.D_E_L_E_T_ = ' ' "
		//	cQuery += "	       AND SD1.D1_DTDIGIT BETWEEN '20110511' AND '20110519'
		//	cQuery += "	       AND SZI.ZI_DTINI   BETWEEN '20110511' AND '20110519'
		cQuery += "	       AND SUBSTR(SD1.D1_DTDIGIT,1,4) = '" + MV_PAR01 + "' "
		cQuery += "	       AND SUBSTR(SZI.ZI_DTINI ,1,4) = '" + MV_PAR01 + "' "
		cQuery += "	       AND SD1.D1_TIPO    = 'N' "
		cQuery += "	       AND SB1.B1_TIPCAR  = '000001' "
		cQuery += "	     GROUP BY SD1.D1_DTDIGIT, D1_DOC, D1_COD "
		cQuery += "	     ORDER BY SD1.D1_DTDIGIT, D1_DOC, D1_COD "
		cQuery += "		 ) "
		If Select( "TMP_VAR" ) > 0
			TMP_VAR->( dbCloseArea() )
		Endif
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_VAR", .T., .F. )
		nRet := ( ( TMP_VAR->SOBRA + TMP_VAR->FALTA ) / TMP_VAR->PESOREC ) * 100
		TMP_VAR->( dbCloseArea() )

	Endif

Return Transform( nRet, "@E 999,999,999.9999" ) 