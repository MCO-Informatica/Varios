#Include "Protheus.ch"
#Include "TopConn.ch"
#include "rwmake.ch"
//Constantes
#Define STR_PULA    Chr(13)+Chr(10) // auxilia formatacao do sql para caso de uso do memowrite



User Function CSFTR010()
	Local cDesc1      	:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Extra็ใo de LOG de proposta"
	Local cPict          := ""
	Local titulo       	:= "LOG de proposta"
	Local nLin        	:= 80
	Local Cabec1      	:= "OPORTUNIDADE      COD.VEND.        NOME VEND.          DT. INICIO         DT. TERMINO                      ENTIDADE   COD. ENTID.         PROCESSO          ESTAGIO         QTD. PROP.        LOG GER. PROP."
	Local Cabec2			:= ""
	Local imprime     	:= .T.
	Local aOrd 			:= {}
	
	Private lEnd        	:= .F.
	Private lAbortPrint 	:= .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "CSFTR010"
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1 }
	Private nLastKey     := 0
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "CSFTR010"
	Private cString 		:= ""
	Private cPerg			:= "FTR010A"
	
	If !Pergunte(cPerg,.T.)
		Return
	Else
		Processa({|| RunReport()} ,"Gerando relat๓rio, aguarde...")
	EndIf

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณRunReport บAutor: ณDouglas Mello          บData: ณ16/12/2009 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณFuncao auxiliar chamada pela RPTSTATUS. A funcao.            บฑฑ
ฑฑบ           ณRPTSTATUS monta a janela com a regua de processamento.       บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local aArea      := GetArea()
	Local cQuery     := ""
	Local oFWMsExcel
	Local oExcel
	Local cArquivo   := GetTempPath()+"LogProp_" + dToS(Date())+"-"+ StrTran(time(),":","") + ".xml"
	Local cCli       := ""
	Local cPro       := ""
		
	ProcRegua(0)
	
	//Selecionando dados
	cQuery := " SELECT AD1.AD1_NROPOR, " 
	cQuery += "        AD1.AD1_VEND, " 
	cQuery += "        SA3.A3_NOME, "
	cQuery += "        AD1.AD1_DTINI, " 
	cQuery += "        AD1.AD1_DTFIM, "
	
	If mv_par07 == 1 .Or. mv_par07 == 3  
		cQuery += "        AD1.AD1_CODCLI, "
	EndIf
	
	If mv_par07 == 2 .Or. mv_par07 == 3
		cQuery += "        AD1.AD1_PROSPE, "
	EndIf 
	 
	cQuery += "        AD1.AD1_STAGE, " 
	cQuery += "        AD1.AD1_XQTDPR, "
	cQuery += "        NVL(UTL_RAW.CAST_TO_VARCHAR2(AD1_XLOGQP),' ') AS AD1_XLOGQP " 
	cQuery += " FROM   AD1010 AD1 " 
	cQuery += "        LEFT JOIN SA3010 SA3 " 
	cQuery += "               ON AD1_VEND = A3_COD "
	cQuery += " WHERE AD1.AD1_NROPOR BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery += "       AND AD1.AD1_VEND BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cQuery += "       AND AD1.AD1_DTINI BETWEEN '" + dToS(mv_par05) + "' AND '" + dToS(mv_par06) + "' "
	
	If mv_par07 == 1 .Or. mv_par07 == 3
		cQuery += "       AND AD1.AD1_CODCLI BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' "
		cQuery += "       AND AD1.AD1_CODCLI <> ' ' "
	EndIf
	
	If mv_par07 == 2 .Or. mv_par07 == 3 
		cQuery += "       AND AD1.AD1_PROSPE BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' "
		cQuery += "       AND AD1.AD1_PROSPE <> ' ' "
	EndIf
	
	cQuery += "       AND Ad1.AD1_STAGE BETWEEN '" + mv_par10 + "' AND '" + mv_par11 + "' "
	cQuery += " ORDER BY AD1.AD1_NROPOR"


	TCQuery cQuery New Alias "QRYPRO" 	

	//Criando o objeto que irแ gerar o conte๚do do Excel
	oFWMsExcel := FWMSExcel():New()

	//Aba 01 - Parceiros

	oFWMsExcel:AddworkSheet("PROPOSTAS")
	//Criando a Tabela
	oFWMsExcel:SetTitleSizeFont(15)
	oFWMsExcel:AddTable("PROPOSTAS","Relat๓rio - Log de Proposta")
	
	oFWMsExcel:AddColumn("PROPOSTAS" ,"Relat๓rio - Log de Proposta" ,"Oportunidade"   ,1)
	oFWMsExcel:AddColumn("PROPOSTAS" ,"Relat๓rio - Log de Proposta" ,"Cod. Vendedor"  ,1)
	oFWMsExcel:AddColumn("PROPOSTAS" ,"Relat๓rio - Log de Proposta" ,"Nome Vendedor"  ,1)
	oFWMsExcel:AddColumn("PROPOSTAS" ,"Relat๓rio - Log de Proposta" ,"Data Inicio"    ,1)
	oFWMsExcel:AddColumn("PROPOSTAS" ,"Relat๓rio - Log de Proposta" ,"Data T้rmino"   ,1)
	oFWMsExcel:AddColumn("PROPOSTAS" ,"Relat๓rio - Log de Proposta" ,"Entidade"       ,1)
	
	If mv_par07 == 1 .Or. mv_par07 == 3
		oFWMsExcel:AddColumn("PROPOSTAS" ,"Relat๓rio - Log de Proposta" ,"Nome Cliente" ,1)
	EndIf
	
	If mv_par07 == 2 .Or. mv_par07 == 3
		oFWMsExcel:AddColumn("PROPOSTAS" ,"Relat๓rio - Log de Proposta" ,"Nome Prospect" ,1)
	EndIf
	
	oFWMsExcel:AddColumn("PROPOSTAS" ,"Relat๓rio - Log de Proposta" ,"Estแgio"        ,1)
	oFWMsExcel:AddColumn("PROPOSTAS" ,"Relat๓rio - Log de Proposta" ,"Qtd. Proposta"  ,1)
	oFWMsExcel:AddColumn("PROPOSTAS" ,"Relat๓rio - Log de Proposta" ,"Log de Gera็ใo" ,1)

	//-- Criando as Linhas... Enquanto nao for fim da query
	While !(QRYPRO->(EoF()))
		
		//-- Inicia processamento.
		IncProc()
		
		//-- Se for setado Cliente ou Prospect. Senao entra na condicao de Ambos.
		If mv_par07 == 1 .Or. mv_par07 == 2
			
			If mv_par07 == 1
				DbSelectArea("SA1")
				DbSetOrder(1)
				If SA1->(DbSeek(xFilial( "SA1" ) + QRYPRO->(AD1_CODCLI)))
					cCli := AllTrim(SA1->A1_NOME)
				EndIf
			Else
				cPro := Posicione( "SUS", 1, xFilial( "SUS" ) + QRYPRO->(AD1_PROSPE), "US_NOME" )
			EndIf
			
			//-- Adiciona uma nova linha no excel.
			oFWMsExcel:AddRow("PROPOSTAS","Relat๓rio - Log de Proposta"			,;
									 { 	QRYPRO->(AD1_NROPOR)							,;
								  		QRYPRO->(AD1_VEND)							,;
								  		QRYPRO->(A3_NOME)								,;
								  		QRYPRO->(AD1_DTINI)							,;
								  		QRYPRO->(AD1_DTFIM)							,;
								  		Iif(mv_par07 == 1, "Cliente", "Prospect")	,;
								  		Iif(mv_par07 == 1, cCli, cPro)				,;
								  		QRYPRO->(AD1_STAGE)							,;
								  		QRYPRO->(AD1_XQTDPR)							,;
							 	  		QRYPRO->(AD1_XLOGQP) })
							 	  		
							 	  	
		Else
			//-- Adiciona uma nova linha no excel.
			oFWMsExcel:AddRow("PROPOSTAS","Relat๓rio - Log de Proposta"	                                       ,;
									 { 	QRYPRO->(AD1_NROPOR)                                                      ,;
								  		QRYPRO->(AD1_VEND)                                                        ,;
								  		QRYPRO->(A3_NOME)                                                         ,;
								  		QRYPRO->(AD1_DTINI)                                                       ,;
								  		QRYPRO->(AD1_DTFIM)                                                       ,;
								  		"Cliente/Prospect"                                                        ,;
								  		Posicione( "SA1", 1, xFilial( "SA1" ) + QRYPRO->(AD1_CODCLI), "A1_NOME" ) ,;
								  		Posicione( "SUS", 1, xFilial( "SUS" ) + QRYPRO->(AD1_PROSPE), "US_NOME" ) ,;
								  		QRYPRO->(AD1_STAGE)                                                       ,;
								  		QRYPRO->(AD1_XQTDPR)                                                      ,;
							 	  		QRYPRO->(AD1_XLOGQP) })
		EndIf
		
		//-- Proximo registro.
		QRYPRO->(DbSkip())
		
	EndDo

	//-- Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//-- Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()			//-- Abre uma nova conexใo com Excel
	oExcel:WorkBooks:Open(cArquivo)		//-- Abre uma planilha
	oExcel:SetVisible(.T.)				//-- Visualiza a planilha
	oExcel:Destroy()						//-- Encerra o processo do gerenciador de tarefas

	QRYPRO->(DbCloseArea())
	RestArea(aArea)

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณCriaSx1   บAutor: ณRafael Beghini         บData: ณ04/03/2016 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณCria as Perguntas usadas no parametro.                       บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CriaSx1( cPerg )
	
	Local aP     := {}
	Local i      := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp  := {}
	
	/***
	Caracterํstica do vetor p/ utiliza็ใo da fun็ใo SX1
	---------------------------------------------------
	[n,1] --> texto da pergunta
	[n,2] --> tipo do dado
	[n,3] --> tamanho
	[n,4] --> decimal
	[n,5] --> objeto G=get ou C=choice
	[n,6] --> validacao
	[n,7] --> F3
	[n,8] --> definicao 1
	[n,9] --> definicao 2
	[n,10] -> definicao 3
	[n,11] -> definicao 4
	[n,12] -> definicao 5
	***/
	
	aAdd( aP ,{"Oportunidade de?"   ,"C" ,06 ,0 ,"G" ,"" ,"   " ,""        ,""         ,""      ,"" ,""} )
	aAdd( aP ,{"Oportunidade ate?"  ,"C" ,06 ,0 ,"G" ,"" ,"   " ,""        ,""         ,""      ,"" ,""} )
	aAdd( aP ,{"Vend. oport. de?"   ,"C" ,06 ,0 ,"G" ,"" ,"SA3" ,""        ,""         ,""      ,"" ,""} )
	aAdd( aP ,{"Vend. oport. ate?"  ,"C" ,06 ,0 ,"G" ,"" ,"SA3" ,""        ,""         ,""      ,"" ,""} )
	aAdd( aP ,{"Data inicio de?"    ,"D" ,08 ,0 ,"G" ,"" ,"   " ,""        ,""         ,""      ,"" ,""} )
	aAdd( aP ,{"Data inicio ate?"   ,"D" ,08 ,0 ,"G" ,"" ,"   " ,""        ,""         ,""      ,"" ,""} )
	aAdd( aP ,{"Entidade?"          ,"C" ,01 ,0 ,"G" ,"" ,"   " ,"Cliente" ,"Prospect" ,"Ambos" ,"" ,""} )
	aAdd( aP ,{"Cod. entidade de?"  ,"C" ,06 ,0 ,"G" ,"" ,"   " ,""        ,""         ,""      ,"" ,""} )
	aAdd( aP ,{"Cod. entidade ate?" ,"C" ,06 ,0 ,"G" ,"" ,"   " ,""        ,""         ,""      ,"" ,""} )
	aAdd( aP ,{"Processo?"          ,"N" ,01 ,0 ,"C" ,"" ,"   " ,""        ,""         ,""      ,"" ,""} )
	aAdd( aP ,{"Estagio de?"        ,"C" ,06 ,0 ,"G" ,"" ,"   " ,""        ,""         ,""      ,"" ,""} )
	aAdd( aP ,{"Estagio ate?"       ,"C" ,06 ,0 ,"G" ,"" ,"   " ,""        ,""         ,""      ,"" ,""} )
	
		
	aAdd( aHelp ,{"Informe a oportunidade inicial."							} )
	aAdd( aHelp ,{"Informe a oportunidade final."								} )	
	aAdd( aHelp ,{"Informe o vendedor da oportunidade."						} )
	aAdd( aHelp ,{"Informe o vendedor da oportunidade."						} )
	aAdd( aHelp ,{"Informe a data de inicio."									} )
	aAdd( aHelp ,{"Informe a data final."										} )
	aAdd( aHelp ,{"Informe a entidade."										} )
	aAdd( aHelp ,{"Informe o codigo da entidade inicial."					} )
	aAdd( aHelp ,{"Informe o codigo da entidade final"						} )
	aAdd( aHelp ,{"Informe o processo."										} )
	aAdd( aHelp ,{"Informe o estagio inicial."								} )
	aAdd( aHelp ,{"Informe o estagio final."									} )
	
	
	For i := 1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par" + cSeq
		cMvCh  := "mv_ch" + IIF(i<=9,Chr(i+48),Chr(i+87))
		
		PutSx1(	cPerg							,;
					cSeq							,;
					aP[i,1],aP[i,1],aP[i,1]		,;
					cMvCh							,;
					aP[i,2]						,;
					aP[i,3]						,;
					aP[i,4]						,;
					0								,;
					aP[i,5]						,;
					aP[i,6]						,;
					aP[i,7]						,;
					""								,;
					""								,;
					cMvPar							,;	
					aP[i,8],aP[i,8],aP[i,8]		,;
					""								,;
					aP[i,9],aP[i,9],aP[i,9]		,;
					aP[i,10],aP[i,10],aP[i,10]	,;
					aP[i,11],aP[i,11],aP[i,11]	,;
					aP[i,12],aP[i,12],aP[i,12]	,;
					aHelp[i]						,;
					{}								,;
					{}								,;
					"" )
	Next i
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณMFat7Opc  บAutor: ณRafael Beghini         บData: ณ04/03/2016 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณOpcoes para selecionar o canal de venda no pergunte.         บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function FTR10Opc()
	
	Local lOk   := .F.
	Local lMark := .F.
	Local oDlg
	Local oLbx
	Local oPanelBot
	Local oPanelAll
	Local oCancel 
	Local oConfirm
	
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	
	Private cCadastro := 'Canais de Venda'
	Private aDADOS    := {}
	
	SZ2->( dbSetOrder(1) )
	SZ2->( dbGotop() )
	While .NOT. SZ2->( EOF() )
		aAdd( aDADOS, {lMark,SZ2->Z2_CODIGO,SZ2->Z2_CANAL} )
		SZ2->( dbSkip() )
	End
	
	If Empty( aDADOS )
		MsgInfo('Nใo foi possํvel encontrar registros de canal de venda, verifique.', cCadastro)
		Return( cRet )
	Endif

	DEFINE MSDIALOG oDlg FROM  31,58 TO 350,500 TITLE cCadastro PIXEL
			oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

			@ 40,05 LISTBOX oLbx FIELDS HEADER 'x','C๓digo','Nome do canal de venda' SIZE 350, 90 OF oPanelAll PIXEL ON ;
			dblClick(aDADOS[oLbx:nAt,1]:=!aDADOS[oLbx:nAt,1])
			oLbx:Align := CONTROL_ALIGN_ALLCLIENT
			oLbx:SetArray(aDADOS)
			oLbx:bLine := { || {Iif(aDADOS[oLbx:nAt,1],oOk,oNo),aDADOS[oLbx:nAt,2],aDADOS[oLbx:nAt,3]}}
			oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
			FWMsgRun(,{|| AEval(aDADOS, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os canais...') }
			
			oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelBot:Align := CONTROL_ALIGN_BOTTOM
	
			@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION Iif(MFat7Seek(aDADOS,@lOk),oDlg:End(),NIL)
			@ 1,44 BUTTON oCancel  PROMPT 'Sair'  SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	
Return( .T. )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณMFat7Seek บAutor: ณRafael Beghini         บData: ณ04/03/2016 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณRotina para retornar o codigo do Canal conforme posicionado. บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MFat7Seek( aDADOS, lOk )
	
	Local cRet   := ''
	Local cCanal := ''
	Local nLin   := 0
	Local nPos   := 0
	Local nP     := 1
	Local nY     := 0
	Local nMv    := 0
	Local aMvPar := {}
	Local lRet   := .T.
	
	nPos := AScan( aDADOS, {|X| X[1]==.T. } )
	If nPos==0
		lRet := .F.
		MsgAlert('Nใo foi selecionado nenhum canal de venda.',cCadastro)
	Else
		For nMv := 1 To 40
			AAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
		Next nMv
		
	   For nY := 1 To Len(aDADOS)
	   		cRet += Iif(aDADOS[nY,1],aDADOS[nY,2],'')
	   Next
	   
	   //////////////////////////////////////
	   For nLin := 1 To Len( cRet ) / 6
			If Len(cCanal) == 0
			  cCanal += Substring(cRet,nP,6)
			  nP += 6
			Else
			  cCanal += ";"+Substring(cRet,nP,6)
			  nP += 6
			EndIf
		Next nLin
		cRet := cCanal
	   	//////////////////////////////////////
		
		For nMv := 1 To Len( aMvPar )
			&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
		Next nMv
		
		MV_PAR16 := cRet
		lOk      := lRet
	Endif
	
Return( lRet )