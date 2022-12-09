#include"rwmake.ch"        
#include'IMPESP.CH'
#include"PROTHEUS.CH"
#include"RPTDEF.CH"  
#include"FWPrintSetup.ch"
#include"APWIZARD.CH"
#include"FILEIO.CH"
#include"TOTVS.CH"
#include"PARMTYPE.CH"
#include"TBICONN.CH"
#INCLUDE "COLORS.CH"


#DEFINE VBOX      080
#DEFINE VSPACE    008
#DEFINE HSPACE    010
#DEFINE SAYVSPACE 008
#DEFINE SAYHSPACE	 008
#DEFINE HMARGEM   030
#DEFINE VMARGEM   030
#DEFINE MAXITEM   022                                                // Máximo de produtos para a primeira página
#DEFINE MAXITEMP2 068                                                // Máximo de produtos para a pagina 2 (caso nao utilize a opção de impressao em verso)
#DEFINE MAXITEMP3 025                                                // Máximo de produtos para a pagina 2 (caso utilize a opção de impressao em verso) - Tratamento implementado para atender a legislacao que determina que a segunda pagina de ocupar 50%.
#DEFINE MAXITEMC  022                                                // Máxima de caracteres por linha de produtos/serviços
#DEFINE MAXMENLIN 080                                                // Máximo de caracteres por linha de dados adicionais
#DEFINE MAXMSG    013                                                // Máximo de dados adicionais por página

Static aUltChar2pix
Static aUltVChar2pix

#IFNDEF DEFAULT
#xcommand DEFAULT	<uVar1> := <uVal1> ;
[, <uVarN> := <uValN> ] => ;
<uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
[ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]
#endif

#define Imp_Spool      	2
#define ALIGN_H_LEFT   	0
#define ALIGN_H_RIGHT  	1
#define ALIGN_H_CENTER 	2
#define ALIGN_V_CENTER 	0
#define ALIGN_V_TOP	   	1
#define ALIGN_V_BOTTON 	2
#define oFontT 			TFont():New( "Verdana", 12, 12, , .T., , , , .T., .F. )//Titulo
#define oFontP 			TFont():New( "Verdana", 10, 10, , .T., , , , .T., .F. )//Linhas
#define oFontP2			TFont():New( "Verdana", 06, 06, , .T., , , , .T., .F. )//Linhas -- CERTISIGN.
#define oFontM 			TFont():New( "Verdana", 08, 08, , .F., , , , .T., .F. )//Marcacoes
#define oFont06 		TFont():New( "Verdana", 06, 06, , .T., , , , .T., .F. )//CodeBar

#define cCARGO_CONFIANCA "99"

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | GeraEspe       | Autor | David Moraes	         | Data | 09.09.2014|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Gera PDF do espelho de ponto				                        |
+-----------+-------------------------------------------------------------------+
| Uso       | Certisign Certificadora Digital S/A                               |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|02.03.2016 | Alexandre AS - OPVS - A rotina passa a zerar a variavel aCertFlow |
|           | Com isso, cada espelho é gerado e enviado separadamente ao        |
|           | CERTILOW.                                                         |
+-----------+-------------------------------------------------------------------+
|27.06.2016 | Bruno Nunes - OPVS - Alterada a rotina para gerar espelho de ponto|
|           | atraves da tabela PB7.                                            |
|           | Alterado o rodape para demontras eventos gerados na SPC.          |
|           | Retirado rodape por banco de horas.                               |
+-----------+-------------------------------------------------------------------+
|19.12.2017 | Alexandre Alves - CERTISIGN - Inovação na rotina com adequação ao |
|           | novo layout do Espelho de Ponto, implementado a partir da versão  |
|           | 12 do sistema. A partir dessa inovação, a rotina passa a gerar    |
|           | Espelhos de Ponto de periodos já fechados, além de apresentar um  |
|           | layout mais amigável e intelegivel.                               |
+-----------+-------------------------------------------------------------------+
|08.01.2020 | Bruno Nunes - CERTISIGN - Alterada a varíavel para lSemMarc .T.   |
|           | Essa alteração visa enviar espelho de ponto para funcionários     |
|           | sem marcação na SP8, para admitidos nos mês ou funcionáris em     |
|           | férias, esta enviando folha em branco.                            |
|           | OBS.: Orientar o analista RH para colocar regra de apontamento    |
|           | até regra 90, pois a regra 99 visa funcionários que não batem     |
|           | ponto.                                                            |
+-----------+-------------------------------------------------------------------+
*/
User function GeraEspe( lTerminal , cFilTerminal , cMatTerminal , cPerAponta, lPortal, aRetPortal, aFalhas, aFunProc, aCertFlow, aWS )
	local aArea		 := {}
	local aOrdem     := {}
	local cHtml		 := " "
	local cAviso	
	local aFilesOpen := {"SP5", "SPN", "SP8", "SPG","SPB","SPL","SPC", "SPH", "SPF"}
	local bCloseFiles:= {}
	local oPrinter
	local oSetup
	local cSession	 := " "
	local cDestino	 := ""
	local cDevice    := "PDF"
	local lPula      := .F. //-> Controla se avança processamento.
	local cRootPath  := " "
	local cFile      := ""
	local cLinha 	 := ""

	//->Utilizado apenas em debug. Deixar comentado.
	//RpcSetType(3)
	//RpcSetEnv("01", "07")

	aArea		:= GetArea()
	aOrdem      := {STR0004 , STR0005 , STR0006 , STR0007, STR0038, STR0060, STR0061  } // 'Matricula'###'Centro de Custo'###'Nome'###'Turno'###'C.Custo + Nome'###'Departamento'###'Departamento + Nome'
	bCloseFiles := {|cFiles| If( Select(cFiles) > 0, (cFiles)->( DbCloseArea() ), NIL) }
	cSession	:= GetPrinterSession()
	//nFlags   	:= PD_ISTOTVSPRINTER + PD_DISABLEORIENTATION
	//nFlags := PD_ISTOTVSPRINTER+ PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
	cRootPath   := GetSrvProfString("RootPath","")

	//-> Define Variaveis Private(Basicas).	
	private nomeprog := 'PONR010'
	private nLastKey := 0
	private cPerg    := 'PNR010'

	//->Define variaveis private utilizadas no programa RDMAKE.
	private aImp      := {}
	private aTotais   := {}
	private aAbonados := {}
	private nImpHrs   := 0

	//-> Variaveis Utilizadas na funcao IMPR.
	private Titulo   := OemToAnsi(STR0001 ) // 'Espelho do Ponto'

	//->Define Variaveis Private(Programa).
	private dPerIni  := Ctod("//")
	private dPerFim  := Ctod("//")
	private cMenPad1 := Space(30)
	private cMenPad2 := Space(19)
	private cFilSPA	 := xFilial("SPA", SRA->RA_FILIAL)
	private nOrdem   := 1
	private aInfo    := {}
	private aTurnos  := {}
	private aPrtTurn := {}
	private nColunas := 0
	private aNaES	 := {}
	private nCol	 := 0
	private nColTot	 := 0
	private nLinTot	 := 0
	private aMargRel := {}
	private nLin	 := 0
	private nPxData	 :=	0
	private nPxSemana:= 0
	private nPxAbonos:= 0
	private nPxHe	 := 0
	private nPxFalta := 0
	private nPxAdnNot:= 0
	private nPxObser := 0
	private lImpMarc := .T.
	private lCodeBar := .F.
	private lBigLine := .T.

	/*
	-> Pra testar no modo JOB, com apenas uma matricula.
	-> Na PRODUÇÃO deixar comentado.
	*/
	//cFilTerminal := "07"
	//cMatTerminal := "003764"
	//cPerAponta   := "2019101620191115"

	default cFilTerminal := ""
	default cMatTerminal := ""
	default cPerAponta   := ""
	default lTerminal    := .F.
	default lPortal      := .F.
	default aWS := {}

	//Posiciona na SRA
	if  !empty(cFilTerminal) .And. !empty(cMatTerminal) 
		SRA->(dbSetOrder(1))
		if SRA->(!dbSeek(cFilTerminal + cMatTerminal))
			aAdd(aFalhas,{"GERAESPE.PRW - NAO CONSEGUI ENCONTRAR A MATRICULA "+cMatTerminal+" - "+cMatTerminal+" NO CADASTRO DE FUNCIONARIOS. VERIFIQUE!."})
			lPula := .T.
		endif
	else
		lPula := .T.
	endif

	if lPula //-> Salta o registro do funcionario que não foi encontrado.
		return()
	endif

	lPortal   := IF( lPortal == nil , .F. , lPortal )   
	
	//cDestino := iif( lTerminal, "c:\temp\", "\certiflow_protheus\")
	cDestino := "c:\temp\"
	U_CriarDir( cDestino )
	FErase( cDestino+"\"+AllTrim(cFilTerminal + cMatTerminal)+".pdf" )
	
	//->Parametro MV_COLMARC.
	nColunas := SuperGetmv("MV_COLMARC")
	if ( nColunas == nil )
		aAdd(aFalhas,{"GERAESPE.PRW - O PARAMETRO MV_COLMARC NAO ESTA DEFINIDO NO CONFIGURADOR. DEFINIDO 2 COLUNAS POR PADRAO.VERIFIQUE!."})
	endif

	nColunas *= 2 //-> O numero de colunas eh sempre aos pares.

	//-> Envia controle para a funcao SETPRINT.
	if !( lTerminal )
		//-> Define os Tipos de Impressao validos.
		aDevice := {}	
		aAdd(aDevice,"DISCO") 
		aAdd(aDevice,"SPOOL") 
		aAdd(aDevice,"EMAIL") 
		aAdd(aDevice,"EXCEL") 
		aAdd(aDevice,"HTML" ) 
		aAdd(aDevice,"PDF"  )  

		//-> Realiza as configuracoes necessarias para a impressao.
		nPrintType := aScan(aDevice,{|x| x == cDevice }) 
		nlocal     := IIf( fWGetProfString( cSession, "LOCAL", "SERVER", .T. ) == "SERVER", 1, 2 )                                                                                                                                                                                                                          

		/*
		oSetup := FWPrintSetup():New(nFlags, Titulo)
		oSetup:SetUserParms( {|| Pergunte(cPerg, .T.) } ) 
		oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
		oSetup:SetPropert(PD_ORIENTATION , 2) 
		oSetup:SetPropert(PD_DESTINATION , nLocal)
		oSetup:SetPropert(PD_MARGIN      , {10,10,10,10})
		oSetup:SetPropert(PD_PAPERSIZE   , 2)
		oSetup:SetPropert(PD_PREVIEW,.T.)
		oSetup:SetOrderParms(aOrdem,@nOrdem)
		
		if cDevice == "PDF"
			oSetup:aOptions[PD_VALUETYPE] := cDestino
		endif
		*/

		//FWMSPrinter():New(
		//                  cFilePrintert - Caracter	Nome do arquivo de relatório a ser criado.	 
		//                  nDevice       - Numérico	Tipos de Saída aceitos:
		//                                            - IMP_SPOOL Envia para impressora.
		//                                            - IMP_PDF Gera arquivo PDF à partir do relatório.default é IMP_SPOOL	 	 
		//                  lAdjustToLegacy - Lógico	Se .T. recalcula as coordenadas para manter o legado de proporções com a classe TMSPrinter. 
		//                  default é .T.
		//                  OBS - Este calculos não funcionam corretamen quando houver retângulos do tipo BOX e FILLRECT no relatório,
		//                              podendo haver distorções de algumas pixels o que acarretará no encavalamento dos retângulos no momento 
		//                              da impressão.	 	 
		//                  cPathInServer - Caracter	Diretório onde o arquivo de relatório será salvo	 	 
		//                  lDisabeSetup  - Lógico	Se .T. não exibe a tela de Setup, ficando à cargo do programador definir quando e se será 
		//                                            feita sua chamada. default é .F.	 	 
		//                  lTReport      - Lógico	Indica que a classe foi chamada pelo TReport. default é .F.	 	 
		//                  oPrintSetup   - Objeto	Objeto FWPrintSetup instanciado pelo usuário.	 	
		//                  cPrinter      - Caracter	Impressora destino "forçada" pelo usuário. default é ""	 	 
		//                  lServer       - Lógico	Indica impressão via Server (.REL Não será copiado para o Client). default é .F.	 	 
		//                  lPDFAsPNG     - Lógico	.T. Indica que será gerado o PDF no formato PNG. O default é .T.	 	 
		//                  lRaw          - Lógico	.T. indica impressão RAW/PCL, enviando para o dispositivo de impressão caracteres binários(RAW) ou 
		//                                             caracteres programáveis específicos da impressora(PCL)	 	 
		//                  lViewPDF      - Lógico	Quando o tipo de impressão for PDF, define se arquivo será exibido após a impressão. 
		//                                            O default é .T.	 	 
		//                  nQtdCopy      - Numérico	Define a quantidade de cópias a serem impressas quando utilizado o metodo de impressão 
		//                                            igual a SPOOL. Recomendavel em casos aonde a utilização da classe FwMsPrinter se da por meio 
		//                                            de eventos sem a intervenção do usuario (JOBs / Schedule por exemplo)Obs: Aplica-se apenas a 
		//                                            ambientes que possuam o fonte FwMsPrinter.prw com data igual ou superior a 03/05/2012.
		oPrinter := FWMSPrinter():New(AllTrim(cFilTerminal + cMatTerminal),; //-> cFilePrintert
		IMP_PDF,;                              //-> nDevice
		.F.,;                                  //-> lAdjustToLegacy
		cDestino ,;                          //-> cPathInServer
		.T.,;                                  //-> lDisabeSetup
		.F.,;                                  //-> lTReport
		oSetup,;                               //-> oPrintSetup
		"",;                                   //-> cPrinter
		!lTerminal,;                                  //-> lServer
		.F.,;                                  //-> lPDFAsPNG
		.F.,;                                  //-> lRaw
		.F.,;                                  //-> lViewPDF
		1)                                    //-> nQtdCopy


		oPrinter:cPathPDF := cDestino
		oPrinter:lServer := !lTerminal
		oPrinter:lInJob   	:= !lTerminal
		oPrinter:SetLandscape()
		
		/*
		COMENTADO O TRATAMENTO DO DISPLAY DA TELA DE SELEÇÃO DO MEIO DE IMPRESSÃO.
		if !(oSetup:Activate() == PD_OK)
		oPrinter:Deactivate() 
		return
		endif
		*/

		//oPrinter:lServer := oSetup:GetProperty( PD_DESTINATION ) == AMB_SERVER                      
		oPrinter:SetResolution( 75 )
		aMargRel := {10,10,10,10}
		
		/*
		if oSetup:GetProperty( PD_ORIENTATION ) == 2
			oPrinter:SetLandscape()
		else
			oPrinter:SetPortrait()
		endif

		oPrinter:SetPaperSize( oSetup:GetProperty( PD_PAPERSIZE ) )
		oPrinter:SetMargin(oSetup:GetProperty( PD_MARGIN )[1],oSetup:GetProperty( PD_MARGIN )[2],oSetup:GetProperty( PD_MARGIN )[3],oSetup:GetProperty( PD_MARGIN )[4])
		aMargRel := {oSetup:GetProperty( PD_MARGIN )[1],oSetup:GetProperty( PD_MARGIN )[2],oSetup:GetProperty( PD_MARGIN )[3],oSetup:GetProperty( PD_MARGIN )[4]}

		fwWriteProfString(cSession,"LOCAL", If(oSetup:GetProperty(PD_DESTINATION)==1,"SERVER","LOCAL"), .T.)
		fwWriteProfString(cSession,"PRINTTYPE", aDevice[oSetup:GetProperty( PD_PRINTTYPE )], .T.)

		if oSetup:GetProperty( PD_PRINTTYPE ) == Imp_Spool  

			oPrinter:nDevice := Imp_Spool
			fwWriteProfString(cSession,"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
			oPrinter:cPrinter := oSetup:aOptions[PD_VALUETYPE]

		elseif oSetup:GetProperty( PD_PRINTTYPE ) == IMP_PDF

			oPrinter:nDevice := IMP_PDF
			fwWriteProfString(cSession,"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)	
			oPrinter:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
			oPrinter:SetViewPDF(.F.)

		endif
		*/
	endif

	//-> Verifica as perguntas selecionadas.
	Pergunte( cPerg , .F. )

	//->Carregando variaveis MV_PAR?? para Variaveis do Sistema.
	FilialDe	:= SRA->RA_FILIAL			//Filial  De
	FilialAte	:= SRA->RA_FILIAL			//Filial  Ate
	CcDe		:= SRA->RA_CC   			//Centro de Custo De
	CcAte		:= SRA->RA_CC    			//Centro de Custo Ate
	TurDe		:= SRA->RA_TNOTRAB			//Turno De
	TurAte		:= SRA->RA_TNOTRAB			//Turno Ate
	MatDe		:= SRA->RA_MAT				//Matricula De
	MatAte		:= SRA->RA_MAT				//Matricula Ate
	NomDe		:= SRA->RA_NOME				//Nome De
	NomAte		:= SRA->RA_NOME				//Nome Ate
	cSit		:= fSituacao( nil , .F. )	//Situacao
	cCat		:= fCategoria( nil , .F. )	//Categoria
	nImpHrs		:= 3 						//Imprimir horas Calculadas/Inform/Ambas/NA
	nImpAut		:= 1 						//Demonstrar horas Autoriz/Nao Autorizadas
	nCopias		:= 1                        //N£mero de C¢pias
	lSemMarc	:= .T. 				        //Imprime para Funcion rios sem Marca‡oes
	cMenPad1	:= ""						//Mensagem padr„o anterior a Assinatura
	cMenPad2	:= "" 						//Mens. padr„o anterior a Assinatura(Cont.)
	dPerIni     := Stod( Subst( cPerAponta , 1 , 8 ) )	//Data Contendo o Inicio do Periodo de Apontamento
	dPerFim     := Stod( Subst( cPerAponta , 9 , 8 ) )	//Data Contendo o Fim  do Periodo de Apontamento
	lSexagenal	:= .T.                      //Horas em  (Sexagenal/Centesimal)
	lImpRes		:= .F.	    				//Imprime eventos a partir do resultado ?
	lImpTroca   := .F.	     				//Imprime Descricao Troca de Turnos ou o Atual 
	lImpExcecao := .F.	    				//Imprime Descricao da Excecao no Lugar da do Afastamento  
	DeptoDe		:= SRA->RA_DEPTO   			//Departamento De
	DeptoAte	:= SRA->RA_DEPTO   			//Departamento Ate
	lImpMarc 	:= .T.   		 		    //Imprime marcações? .T.
	lCodeBar 	:= .F.       				//Imprime código de barras? .F.
	lBigLine 	:= .T.       				//Destaca linhas? .T.

	//-> Redefine o Tamanho das Mensagens Padroes.
	cMenpad1 := IF(Empty( cMenPad1 ) , Space( 30 ) , cMenPad1 )
	cMenpad2 := IF(Empty( cMenPad2 ) , Space( 19 ) , cMenPad2 )

	Begin Sequence

		if ( lTerminal )
			//-- Verifica se foi possivel abrir os arquivos sem exclusividade
			if Pn090Open(@cHtml, @cAviso)
				cHtml := ""	
				cHtml := Pnr010Imp( nil , lTerminal, lPortal, aRetPortal  )

				/*+-----------------------------------------------------------+
				| Apos a obtencao da consulta solicitada fecha os arquivos  |
				| utilizados no fechamento mensal para abertura exclusiva   |
				+-----------------------------------------------------------+*/

				Aeval(aFilesOpen, bCloseFiles)
			else
				cHtml := HtmlDefault( cAviso , cHtml )   
			endif    
		elseif !( nLastKey == 27 )

			if Pn090Open(@cHtml, @cAviso)

				if Empty( dPerIni ) .or. Empty( dPerFim )
					aAdd(aFalhas,{"GERAESPE.PRW - O PERIODO DE APONTAMENTO SELECIONADO E INVALIDO.VERIFIQUE!."})
				endif

				if !( nLastKey == 27 )
					Pnr010Imp(lTerminal, lPortal, aRetPortal, oPrinter)
				endif
			else
				aAdd(aFalhas,{"GERAESPE.PRW - NAO FOI POSSIVEL ABRIR OS ARQUIVOS DAS MARCACOES.VERIFIQUE!."})
				cHtml := ""
			endif

		endif

	End Sequence

	if !lTerminal
		//oPrinter:Preview()
		oPrinter:Print()
		//Valida arquivo criado, para nao enviar arquivo em branco para assinatura
		cFile := cDestino+"\"+AllTrim(cFilTerminal + cMatTerminal)+".pdf"
		sleep(1000)
		lSucess := arqValido( cFile )
		
		aAdd( aWS, {cFilTerminal, cMatTerminal, cDestino, AllTrim(cFilTerminal + cMatTerminal)+".pdf" } )
		
		/*
		if arqValido( cFile )
			//Grava no servidor o pdf gerado
			lSucess := CpyT2S( cFile, "\certiflow_protheus", .F.)
		endif
		*/
	endif    

	//Controle de envio do certiflow
	if lSucess

		aAdd(aFunProc ,{cFilTerminal,cMatTerminal})
		
		SRA->( DbSetOrder( 1 ) )
		if SRA->( dbSeek( cFilTerminal+cMatTerminal ) )

			cLinha 	 := Alltrim( SRA->RA_EMAIL) +";"+;
					AllTrim(cFilTerminal + cMatTerminal)+".pdf;"+;
					FWCodEmp()+SRA->RA_FILIAL+";"+;
					cMatTerminal +";"+;
					cPerAponta+"; 0"

			aAdd( aCertFlow, cLinha )
		endif

		u_GerarArq( "GerouArquivo;" + cLinha, "C:\temp\certiflow.txt" )

		//FErase( cDestino+"\"+AllTrim(cFilTerminal + cMatTerminal)+".pdf" )
		lDocs := .T. //-> Flega que ao menos um Espelho de Ponto foi gerado com sucesso. Usado pela rotina ENVIACERTIFLOW.PRW.
		ShellExecute( "open", "C:\temp\certiflow.bat", "C:\temp\"+AllTrim(cFilTerminal + cMatTerminal)+".pdf", "", 0 )
		Freeobj( oPrinter )
		/*
		BEGIN TRANSACTION

			//if !Empty(POSICIONE("SRA",1,cMatricula,"RA_EMAIL"))
			if SRA->(AllTrim(RA_FILIAL+RA_MAT)) = AllTrim(cFilTerminal + cMatTerminal) .And.;
			SRA->(!Empty(RA_EMAIL))


				PAN->(DbSelectArea("PAN"))
				PAN->(DbSetOrder(1))

				lNewer := PAN->(!DbSeek( xFilial("PAN") + AllTrim(cFilTerminal + cMatTerminal) + cPerAponta ))

				PAN->(RecLock("PAN",lNewer))

				PAN->PAN_FILIAL := xFilial("PAN")
				PAN->PAN_FILMAT := cFilTerminal
				PAN->PAN_MAT    := cMatTerminal
				PAN->PAN_NOME   := SRA->RA_NOME
				PAN->PAN_STATUS := "3"//Aguardando aprovação   {1 = Aprovado; 2=Reprovado; 3=Aguardando Aprovacao; 4=Nao Enviado}
				PAN->PAN_PONMES := cPerAponta
				PAN->PAN_ENCERR := "0"
				PAN->(MsUnlock())     // Destrava o registro

				PAO->(DbSelectArea("PAO"))
				PAO->(DbSetOrder(1))

				lNewer := PAO->(!dbSeek( xFilial("PAO") + AllTrim(cFilTerminal + cMatTerminal) + cPerAponta ))   //PAO_FILIAL+PAO_FILMAT+PAO_MAT+PAO_PONMES

				PAO->(RecLock("PAO",lNewer))

				PAO->PAO_FILIAL := xFilial("PAO")
				PAO->PAO_FILMAT := cFilTerminal
				PAO->PAO_MAT    := cMatTerminal
				PAO->PAO_STATUS := "3"//Aguardando aprovação
				PAO->PAO_OBS    := FwNoAccent("Enviado -- Aguardando aprovação")
				PAO->PAO_DATA   := DATE()
				PAO->PAO_USER   := RetCodUsr()
				PAO->PAO_PONMES := cPerAponta
				PAO->PAO_ENCERR := "0"

				PAO->(MsUnlock())// Destrava o registro

				aAdd(aCertFlow, Alltrim( SRA->RA_EMAIL) +";"+;
				AllTrim(cFilTerminal + cMatTerminal)+".pdf;"+;
				FWCodEmp()+PAO->PAO_FILMAT+" ;"+;
				cMatTerminal +" ;"+;
				cPerAponta+"; 0")

			elseif SRA->(AllTrim(RA_FILIAL+RA_MAT)) = AllTrim(cFilTerminal + cMatTerminal)

				aAdd(aFalhas,{"GERAESPE.PRW - NAO HA E-MAIL CADASTRADO PARA "+SRA->("Filial.: "+RA_FILIAL+" Matricula.: "+RA_MAT)+". VERIFIQUE!."})

				PAN->(DbSelectArea("PAN"))
				PAN->(DbSetOrder(1))

				lNewer := PAN->(!DbSeek(xFilial("PAN") + cMatTerminal + cPerAponta ))

				PAN->(RecLock("PAN",lNewer))
				PAN->PAN_FILIAL := xFilial("PAN")
				PAN->PAN_FILMAT := cFilTerminal
				PAN->PAN_MAT    := cMatTerminal
				PAN->PAN_NOME   := SRA->RA_NOME 
				PAN->PAN_STATUS := "4"//Não Enviado.
				PAN->PAN_PONMES := cPerAponta
				PAN->PAN_ENCERR := "0"
				PAN->(MsUnlock())

				PAO->(DbSelectArea("PAO"))
				PAO->(DbSetOrder(1))

				lNewer := PAO->(!dbSeek( xFilial("PAO") + cMatTerminal + cPerAponta ))   //PAO_FILIAL+PAO_FILMAT+PAO_MAT+PAO_PONMES

				PAO->(RecLock("PAO",lNewer))
				PAO->PAO_FILIAL := xFilial("PAO")
				PAO->PAO_FILMAT := cFilTerminal
				PAO->PAO_MAT    := cMatTerminal
				PAO->PAO_STATUS := "4"//Não Enviado.
				PAO->PAO_OBS    := FwNoAccent("Não Enviado -- Problemas com E-Mail.")
				PAO->PAO_DATA   := DATE()
				PAO->PAO_USER   := RetCodUsr()
				PAO->PAO_PONMES := cPerAponta
				PAO->PAO_ENCERR := "0"
				PAO->(MsUnlock())// Destrava o registro

			else
				aAdd(aFalhas,{"GERAESPE.PRW - MATRICULA NAO LOCALIZADA "+;
				cFilTerminal+" - "+;
				cMatTerminal+" NO CADASTRO DE FUNCIONARIOS. VERIFIQUE!."})
			endif
		END TRANSACTION
		*/
	endif
return( cHtml )

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | POR010Imp      | Autor | TOTVS	             | Data | 19.12.2017|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Espelho do Ponto.         				                        |
+-----------+-------------------------------------------------------------------+
| Uso       | Certisign Certificadora Digital S/A                               |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|19.12.2017 | Alexandre Alves - CERTISIGN - Inovação na rotina com adequação ao |
|           | novo layout do Espelho de Ponto, implementado a partir da versão  |
|           | 12 do sistema. A partir dessa inovação, a rotina passa a gerar    |
|           | Espelhos de Ponto de periodos já fechados, além de apresentar um  |
|           | layout mais amigável e intelegivel.                               |
+-----------+-------------------------------------------------------------------+
*/
static function Pnr010Imp(lTerminal, lPortal, aRetPortal, oPrinter)
	local aAbonosPer	:= {}
	local cOrdem		:= ""
	local cWhere		:= ""
	local cSituacao		:= ""
	local cCategoria	:= ""
	local cLastFil		:= "__cLastFil__"
	local cSeq			:= ""
	local cTurno		:= ""
	local cHtml			:= ""
	local cAliasSRA		:= GetnextAlias()
	local cAliasQTD		:= GetnextAlias()
	local lSPJExclu		:= !Empty( xFilial("SPJ") )
	local lSP9Exclu		:= !Empty( xFilial("SP9") )
	local nCount		:= 0.00
	local nX			:= 0.00
	local lMvAbosEve	:= .F.
	local lMvSubAbAp	:= .F.

	private aFuncFunc  := {SPACE(1), SPACE(1), SPACE(1), SPACE(1), SPACE(1), SPACE(1)}		
	private aMarcacoes := {}
	private aTabPadrao := {}
	private aTabCalend := {}
	private aPeriodos  := {}
	private aId		   := {}
	private aResult	   := {}
	private aBoxSPC	   := LoadX3Box("PC_TPMARCA") 
	private aBoxSPH	   := LoadX3Box("PH_TPMARCA")
	private cCodeBar   := ""
	private dIniCale   := Ctod("//")	//-- Data Inicial a considerar para o Calendario
	private dFimCale   := Ctod("//")	//-- Data Final a considerar para o calendario
	private dMarcIni   := Ctod("//")	//-- Data Inicial a Considerar para Recuperar as Marcacoes
	private dMarcFim   := Ctod("//")	//-- Data Final a Considerar para Recuperar as Marcacoes
	private dIniPonMes := Ctod("//")	//-- Data Inicial do Periodo em Aberto 
	private dFimPonMes := Ctod("//")	//-- Data Final do Periodo em Aberto 
	private lImpAcum   := .F.

	/*+----------------------------------------------------------------+
	| Como a Cada Periodo Lido reinicializamos as Datas Inicial e Fi-|
	| nal preservamos-as nas variaveis: dCaleIni e dCaleFim.         |
	+----------------------------------------------------------------+*/
	dIniCale   := dPerIni   //-- Data Inicial a considerar para o Calendario
	dFimCale   := dPerFim   //-- Data Final a considerar para o calendario

	for nX:=1 to Len(cSit)
		if Subs(cSit,nX,1) <> "*"
			cSituacao += "'"+Subs(cSit,nX,1)+"'"
			if ( nX+1 ) <= Len(cSit)
				cSituacao += "," 
			endif
		endif
	next nX     

	for nX:=1 to Len(cCat)
		if Subs(cCat,nX,1) <> "*"
			cCategoria += "'"+Subs(cCat,nX,1)+"'"
			if ( nX+1 ) <= Len(cCat)
				cCategoria += "," 
			endif
		endif
	next nX

	//-> Inicializa Variaveis Static.
	( CarExtAut() , RstGetTabExtra() )

	//--Seleciona funcionários de acordo com filtros
	cWhere += "%"
	cWhere += "SRA.RA_FILIAL >= '" + FilialDe + "' AND "
	cWhere += "SRA.RA_FILIAL <= '" + FilialAte + "' AND "
	cWhere += "SRA.RA_CC >= '" + CCDe + "' AND "
	cWhere += "SRA.RA_CC <= '" + CCAte + "' AND "
	cWhere += "SRA.RA_TNOTRAB >= '" + TurDe + "' AND "
	cWhere += "SRA.RA_TNOTRAB <= '" + TurAte + "' AND "
	cWhere += "SRA.RA_MAT >= '" + MatDe + "' AND "
	cWhere += "SRA.RA_MAT <= '" + MatAte + "' AND "
	cWhere += "SRA.RA_NOME >= '" + NomDe + "' AND "
	cWhere += "SRA.RA_NOME <= '" + NomAte + "' AND "
	cWhere += "SRA.RA_DEPTO >= '" + DeptoDe + "' AND "
	cWhere += "SRA.RA_DEPTO <= '" + DeptoAte + "'"
	if !Empty( cSituacao )
		cWhere += " AND SRA.RA_SITFOLH IN ( " + cSituacao + ") " 
	endif
	if !Empty(cCategoria)
		cWhere += " AND SRA.RA_CATFUNC IN ( " + cCategoria + ") "
	endif
	cWhere += " AND SRA.D_E_L_E_T_ = ' ' " 
	cWhere += "%"

	//'Matricula'###'Centro de Custo'###'Nome'###'Turno'###'C.Custo + Nome'###'Departamento'###'Departamento + Nome'
	if ( ( nOrdem == 1 ) .or. ( lTerminal ) )
		cOrdem := "%SRA.RA_FILIAL, SRA.RA_MAT%"
	elseif ( nOrdem == 2 )
		cOrdem := "%SRA.RA_FILIAL, SRA.RA_CC%"
	elseif ( nOrdem == 3 )
		cOrdem := "%SRA.RA_FILIAL, SRA.RA_NOME, SRA.RA_MAT%"
	elseif ( nOrdem == 4 )
		cOrdem := "%SRA.RA_FILIAL, SRA.RA_TNOTRAB%"
	elseif ( nOrdem == 5 )
		cOrdem := "%SRA.RA_FILIAL, SRA.RA_CC, SRA.RA_NOME%"
	elseif ( nOrdem == 6 )
		cOrdem := "%SRA.RA_FILIAL, SRA.RA_DEPTO, SRA.RA_MAT%"
	elseif ( nOrdem == 7 )
		cOrdem := "%SRA.RA_FILIAL, SRA.RA_DEPTO, SRA.RA_NOME%"
	endif

	BeginSql Alias cAliasSRA

		SELECT SRA.RA_FILIAL, SRA.RA_MAT
		FROM 
		%Table:SRA% SRA
		WHERE %Exp:cWhere%
		ORDER BY %Exp:cOrdem%	

	EndSql 	

	//-> Inicializa Regua de Impressao.
	if !( lTerminal )
		BeginSql Alias cAliasQTD

			SELECT Count(*) AS QTDREG
			FROM 
			%Table:SRA% SRA
			WHERE %Exp:cWhere%
		EndSql

		//SetRegua( (cAliasQTD)->QTDREG )
		(cAliasQTD)->(DbCloseArea())
	endif

	if lCodeBar
		DbSelectArea("RS4")
		DbSetOrder(1)
	endif

	dbSelectArea('SRA')
	SRA->( dbSetOrder( 1 ) )	

	//->Processa o Cadastro de Funcionarios.
	while (cAliasSRA)->( !Eof() )

		//Posiciona no funcionário atual
		SRA->(DbSeek((cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT))

		//-> So Faz Validacoes Quando nao for Terminal.
		if !( lTerminal ) 

			/*+---------------------------------------------------------------+
			|Consiste a data de Demissao.								      |
			|Se o Funcionario Foi Demitido Anteriormente ao Inicio do Perio |
			|do Solicitado Desconsidera-o								      |
			+---------------------------------------------------------------+*/
			if !Empty(SRA->RA_DEMISSA) .and. ( SRA->RA_DEMISSA < dIniCale )
				(cAliasSRA)->( dbSkip() )
				Loop
			endif

			//Não enviar para funcionarios com regra 99
			if SRA->RA_REGRA == cCARGO_CONFIANCA
				(cAliasSRA)->( dbSkip() )
				loop
			endif
		endif

		//->Verifica a Troca de Filial.
		if !( SRA->RA_FILIAL == cLastFil )

			//-> Alimenta as variaveis com o conteudo dos MV_'S correspondetes.		
			lMvAbosEve	:= ( Upper(AllTrim(SuperGetMv("MV_ABOSEVE",NIL,"N",cLastFil))) == "S" )	//--Verifica se Deduz as horas abonadas das horas do evento Sem a necessidade de informa o Codigo do Evento no motivo de abono que abona horas
			lMvSubAbAp	:= ( Upper(AllTrim(SuperGetMv("MV_SUBABAP",NIL,"N",cLastFil))) == "S" )	//--Verifica se Quando Abono nao Abonar Horas e Possuir codigo de Evento, se devera Gera-lo em outro evento e abater suas horas das Horas Calculadas

			//->Atualiza a Filial Corrente.
			cLastFil := SRA->RA_FILIAL

			//-> Carrega periodo de Apontamento Aberto.
			//if !CheckPonMes( @dPerIni , @dPerFim , .F. , .T. , .F. , cLastFil )
			//	Exit
			//endif


			//-> Obtem datas do Periodo em Aberto.
			GetPonMesDat( @dIniPonMes , @dFimPonMes , cLastFil )

			//-> Atualiza o Array de Informa‡”es sobre a Empresa.
			aInfo := {}
			fInfo( @aInfo , cLastFil )

			//-> Carrega as Tabelas de Horario Padrao.
			if ( lSPJExclu .or. Empty( aTabPadrao ) )
				aTabPadrao := {}
				fTabTurno( @aTabPadrao , If( lSPJExclu , cLastFil , nil ) )
			endif

			//-> Carrega TODOS os Eventos da Filial.
			if ( Empty( aId ) .or. ( lSP9Exclu ) )
				aId := {}
				CarId( fFilFunc("SP9") , @aId , "*" )
			endif

		endif

		//->Retorna Periodos de Apontamentos Selecionados.
		if ( lTerminal )
			dPerIni	:= dIniCale
			dPerFim := dFimCale
		endif

		aPeriodos := Monta_per( dIniCale , dFimCale , cLastFil , SRA->RA_MAT , dPerIni , dPerFim )

		//-> Corre Todos os Periodos.
		naPeriodos := Len( aPeriodos )
		for nX := 1 To naPeriodos

			/*+-----------------------------------------------------------+
			|Reinicializa as Datas Inicial e Final a cada Periodo Lido. |
			|Os Valores de dPerIni e dPerFim foram preservados nas      |
			|variaveis: dCaleIni e dCaleFim.                            |
			+-----------------------------------------------------------+*/
			dPerIni		:= aPeriodos[ nX , 1 ]
			dPerFim		:= aPeriodos[ nX , 2 ] 

			//-> Obtem as Datas para Recuperacao das Marcacoes.
			dMarcIni	:= aPeriodos[ nX , 3 ]
			dMarcFim	:= aPeriodos[ nX , 4 ]

			//-> Verifica se Impressao eh de Acumulado.
			lImpAcum := ( dPerFim < dIniPonMes )

			//-> Retorna Turno/Sequencia das Marca‡”es Acumuladas.
			if ( lImpAcum )
				if SPF->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + Dtos( dPerIni) ) ) .and. !Empty(SPF->PF_SEQUEPA)
					cTurno	:= SPF->PF_TURNOPA
					cSeq	:= SPF->PF_SEQUEPA
				else
					//-> Tenta Achar a Sequencia Inicial utilizando RetSeq().
					if !RetSeq(cSeq,@cTurno,dPerIni,dPerFim,dDataBase,aTabPadrao,@cSeq) .or. Empty( cSeq )

						cSeq := fQualSeq( nil , aTabPadrao , dPerIni , @cTurno ) //-> Tenta Achar a Sequencia Inicial utilizando fQualSeq().
					endif
				endif

				if ( Empty(cTurno) )
					SPF->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) ) )
					Do while	( !EOF() ) .AND.;
					( SRA->RA_FILIAL + SRA->RA_MAT == SPF->PF_FILIAL + SPF->PF_MAT )
						if ( SPF->PF_DATA >= dPerIni .AND. SPF->PF_DATA <= dPerFim )						
							cTurno	:= SPF->PF_TURNOPA
							cSeq	:= SPF->PF_SEQUEPA
							Exit
						else
							SPF->( dbSkip() )
						endif
					end
				endif

				//->  Obtem Codigo e Descricao da Funcao do Trabalhador na Epoca.
				fBuscaCC(dMarcFim, @aFuncFunc[1], @aFuncFunc[2], Nil, .F. , .T.  ) 
				aFuncFunc[2]:= Substr(aFuncFunc[2], 1, 25)
				//TODO - esta com bug fBuscaFunc(dMarcFim, @aFuncFunc[3], @aFuncFunc[4],20, @aFuncFunc[5], @aFuncFunc[6],25, .F. )
				aFuncFunc[3]:= SRA->RA_CODFUNC 
				aFuncFunc[4]:= DescFun(SRA->RA_CODFUNC , SRA->RA_FILIAL)
				aFuncFunc[6]:= DescCateg(SRA->RA_CATFUNC , 25)
			else
				//->  Considera a Sequencia e Turno do Cadastro.
				cTurno	:= SRA->RA_TNOTRAB
				cSeq	:= SRA->RA_SEQTURN  

				//-> Obtem Codigo e Descricao da Funcao do Trabalhador. 
				aFuncFunc[1]:= SRA->RA_CC
				aFuncFunc[2]:= DescCc(aFuncFunc[1], SRA->RA_FILIAL, 25)
				aFuncFunc[3]:= SRA->RA_CODFUNC 
				aFuncFunc[4]:= DescFun(SRA->RA_CODFUNC , SRA->RA_FILIAL)
				aFuncFunc[6]:= DescCateg(SRA->RA_CATFUNC , 25)
			endif

			/*+---------------------------------------------------------------+
			| Carrega Arrays com as Marca‡”es do Periodo (aMarcacoes), com  |
			| o Calendario de Marca‡”es do Periodo (aTabCalend) e com    as |	
			| Trocas de Turno do Funcionario (aTurnos)					  |
			+---------------------------------------------------------------+*/
			( aMarcacoes := {} , aTabCalend := {} , aTurnos := {} )

			if lImpMarc   
				/*+------------------------------------------------------------+
				| Importante:                                                |
				| O periodo fornecido abaixo para recuperar as marcacoes cor | 
				| respondente ao periodo de apontamentoo Calendario de Marca | 
				| coes do Periodo ( aTabCalend ) e com as Trocas de Turno do | 	
				| Funcionario ( aTurnos ) integral afim de criar o calendario| 	
				| com as ordens correspondentes as gravadas nas marcacoes    |
				+------------------------------------------------------------+*/
				if !GetMarcacoes(	@aMarcacoes					,;	//Marcacoes dos Funcionarios
				@aTabCalend					,;	//Calendario de Marcacoes
				@aTabPadrao					,;	//Tabela Padrao
				@aTurnos					,;	//Turnos de Trabalho
				dPerIni 					,;	//Periodo Inicial
				dPerFim						,;	//Periodo Final
				SRA->RA_FILIAL				,;	//Filial
				SRA->RA_MAT					,;	//Matricula
				cTurno						,;	//Turno
				cSeq						,;	//Sequencia de Turno
				SRA->RA_CC					,;	//Centro de Custo
				If(lImpAcum,"SPG","SP8")	,;	//Alias para Carga das Marcacoes
				NIL							,;	//Se carrega Recno em aMarcacoes
				.T.							,;	//Se considera Apenas Ordenadas
				.T.    						,;	//Se Verifica as Folgas Automaticas
				.F.    			 			 ;	//Se Grava Evento de Folga Automatica Periodo Anterior
				)
					Loop
				endif
			endif					 

			aPrtTurn:={}
			Aeval(aTurnos, {|x| If( x[2] >= dPerIni .AND. x[2]<= dPerFim, aAdd(aPrtTurn, x),nil )} ) 

			//-> Reinicializa os Arrays aToais e aAbonados.
			( aTotais := {} , aAbonados := {} )

			//-> Carrega os Abonos Conforme Periodo.
			if 	lImpMarc
				fAbonosPer( @aAbonosPer , dPerIni , dPerFim , cLastFil , SRA->RA_MAT )
			endif

			//-> Carrega os Totais de Horas e Abonos.
			if 	lImpMarc	
				CarAboTot( @aTotais , @aAbonados , aAbonosPer, lMvAbosEve, lMvSubAbAp )
			endif

			/*+-------------------------------------------------------------------------------+
			| Carrega o Array a ser utilizado na Impressao                                  |
			| aPeriodos[nX,3] --> Inicio do Periodo para considerar as  marcacoes e tabela  |
			| aPeriodos[nX,4] --> Fim do Periodo para considerar as   marcacoes e tabela    |
			+-------------------------------------------------------------------------------+*/
			if ( !fMontaAimp( aTabCalend, aMarcacoes, @aImp,dMarcIni,dMarcFim, lTerminal, lImpAcum) .and. !( lSemMarc ) )
				Loop
			endif

			//-> Imprime o Espelho para um Funcionario.
			for nCount := 1 To nCopias
				if !( lTerminal )
					oPrinter:StartPage()
					if lCodeBar
						cCodeBar := cEmpAnt + SRA->RA_FILIAL + SRA->RA_MAT + DtoS(dPerIni) + DtoS(dPerFim) + DtoS(dDataBase) + StrTran(Time(),":","")
					endif
					fImpFun( aImp , nColunas, ,oPrinter )
					if lCodeBar //Grava o código de barras gerado na tabela RS4
						RecLock("RS4",.T.)
						RS4->RS4_FILIAL := xFilial("RS4")
						RS4->RS4_MAT	:= SRA->RA_MAT
						RS4->RS4_PER	:= DtoS(dPerIni) + DtoS(dPerFim) 
						RS4->RS4_DATAI	:= dPerIni
						RS4->RS4_DATAF	:= dPerFim
						RS4->RS4_CODEBA	:= cCodeBar
						RS4->RS4_STATUS	:= "2" //Pendente
						MsUnLock()
					endif
					oPrinter:EndPage()				
				else
					if lPortal					
						aRetPortal  := aClone(aImp)
					else
						cHtml := fImpFun( aImp , nColunas , lTerminal )
					endif
				endif		    
			next nCount

			//-> Reinicializa Variaveis.
			aImp      := {}
			aTotais   := {}
			aAbonados := {}

		next nX
		(cAliasSRA)->( dbSkip() )
	End while
	(cAliasSRA)->(DbCloseArea())
return( cHtml )

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | FImpFun        | Autor | J.Ricardo	         | Data | 09.04.1996|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Imprime o espelho do ponto do funcionario				            |
+-----------+-------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                     |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|           |                                                                   |
+-----------+-------------------------------------------------------------------+
*/
static function fImpFun( aImp , nColunas , lTerminal, oPrinter )
	local cHtml			:= ""    
	local cOcorr		:= ""   
	local cAbHora		:= ""
	local lZebrado		:= .F.
	local nX        	:= 0.00
	local nY        	:= 0.00
	local nColMarc  	:= 0.00
	local nTamLin   	:= 0.00
	local nMin			:= 0.00
	local nLenImp		:= 0.00
	local nLenImpnX		:= 0.00
	local nTamAuxlin	:= 0.00   
	local nAbHora		:= 0
	local nPosES		:= 0
	local nValAux		:= 0
	local nContEve		:= 0
	local oBrushC	    := TBrush():New( ,  RGB(228, 228, 228)  )
	local oBrushI	    := TBrush():New( ,  RGB(242, 242, 242)  )
	local lBrush		:= .F.

	//-- Define o tamanho da linha com base no MV_ColMarc.
	aEval(aImp, { |x| nColMarc := If(Len(x)-3>nColMarc, Len(x)-3, nColMarc) } )
	nColMarc += If(nColMarc%2 == 0, 0, 1)

	//-- Calcula a Maior das Qtdes de Colunas existentes
	nColunas := Max(nColunas, nColMarc)

	//-- Define configuracoes da impressao
	nTamAuxLin	:= 19+(nColunas*6)+50
	nTamLin    	:= If(nTamAuxLin <= 80,80,If(nTamAuxLin<=132,132,220))

	if ( lTerminal )

		//-> Inicio da Estrutura do Codigo HTML.
		cHtml += HtmlProcId() + CRLF
		cHtml += '<html>'  + CRLF
		cHtml += 	'<head>'  + CRLF
		cHtml += 		'<title>RH Online</title>'  + CRLF
		cHtml +=		'<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'  + CRLF
		cHtml +=		'<link rel="stylesheet" href="css/rhonline.css" type="text/css">'  + CRLF
		cHtml +=	'</head>'  + CRLF
		cHtml +=	'<body bgcolor="#FFFFFF" text="#000000">' + CRLF
		cHtml +=		'<table width="515" border="0" cellspacing="0" cellpadding="0">'  + CRLF
		cHtml +=			'<tr>'  + CRLF
		cHtml +=				'<td class="titulo">'  + CRLF
		cHtml +=					'<p>' + CRLF
		cHtml +=						'<img src="'+TcfRetDirImg()+'/icone_titulo.gif" width="7" height="9">' + CRLF
		cHtml +=							'<span class="titulo_opcao">' + CRLF
		cHtml +=								STR0040 + CRLF	//'Consultar Marca&ccedil;&otilde;es'
		cHtml +=							'</span>' + CRLF
		cHtml +=							'<br><br>' + CRLF
		cHtml +=					'</p>' + CRLF
		cHtml +=				'</td>' + CRLF
		cHtml +=			'</tr>' + CRLF
		cHtml +=			'<tr>' + CRLF
		cHtml +=				'<td>' + CRLF
		cHtml +=					'<table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
		cHtml +=						'<tr>' + CRLF
		cHtml +=							'<td background="'+TcfRetDirImg()+'/tabela_conteudo_1.gif" width="10">&nbsp;</td>' + CRLF
		cHtml +=							'<td class="titulo" width="498">' + CRLF
		cHtml +=								'<table width="498" border="0" cellspacing="2" cellpadding="1">' + CRLF
		cHtml += Imp_Cabec( nTamLin , nColunas , lTerminal )
	else
		//-- Imprime Cabecalho Especifico.
		Imp_Cabec( nTamLin , nColunas ,  lTerminal, 1, oPrinter )
	endif

	//-- Imprime Marcações
	nLenImp := Len(aImp)
	for nX := 1 To nLenImp
		if !( lTerminal )
			nLin += 12

			if nLin > nLinTot - 40
				fImpSign(oPrinter)
				oPrinter:EndPage()
				oPrinter:StartPage()
				Imp_Cabec( nTamLin , nColunas ,  lTerminal, 1, oPrinter )
			endif

			oPrinter:Box( nLin, nCol	, nLin+13, nColTot, "-6" )			// Caixa da linha total

			if lBigLine .and. nX%2 == 0 //Pinta somente as linhas pares
				oPrinter:Fillrect( {nLin+1, nCol+1, nLin+12, nColTot-1 }, oBrushI, "-2") // Quadro na Cor Cinza
			endif

			oPrinter:Line( nLin, nPxData	, nLin+13, nPxData	, 0 , "-6") 	// Linha Pos Data

			oPrinter:SayAlign(nLin,nCol+2,DtoC(aImp[nX,1]),oFontM,500,100,,ALIGN_H_LEFT)
			oPrinter:SayAlign(nLin,nPxData+2,DiaSemana(aImp[nX,1],8),oFontM,nPxSemana-nPxData,100,,ALIGN_H_LEFT)

			nMin := Len(aImp[nX]) -1

			if Len(aImp[nX]) >= 5 .or. !lImpMarc //if Len(aImp[nX]) >= 4 .or. !lImpMarc

				for nPosES := 1 to Len(aNaES)
					oPrinter:Line( nLin, aNaES[nPosES]-6, nLin+13, aNaES[nPosES]-6, 0 , "-6")	
					nY := nPosES + 3
					if lImpMarc .and. nY <= nMin
						oPrinter:SayAlign(nLin,aNaES[nPosES]+2,aImp[nX,nY],oFontM,500,100,,ALIGN_H_LEFT)
					endif
				next nPosES
			else
				oPrinter:Line( nLin, aNaES[1]-6, nLin+13, aNaES[1]-6, 0 , "-6")
				oPrinter:SayAlign(nLin,aNaES[1],aImp[nX,2],oFontM,Len(aNaES)*40,100,,ALIGN_H_CENTER)
			endif

			oPrinter:Line( nLin, nPxAbonos-6, nLin+13	, nPxAbonos-6, 0, "-6")
			oPrinter:Line( nLin, nPxHE-6	, nLin+13	, nPxHE-6    , 0, "-6")
			oPrinter:Line( nLin, nPxFalta-6	, nLin+13	, nPxFalta-6 , 0, "-6")
			oPrinter:Line( nLin, nPxAdnNot-6, nLin+13	, nPxAdnNot-6, 0, "-6")
			oPrinter:Line( nLin, nPxObser	, nLin+13	, nPxObser   , 0, "-6")

			if lImpMarc //Imprime abonos,He,Faltas,adicionais apenas se for para imprimir marcações.
				if ValType(aImp[nX,3]) == "A"
					oPrinter:SayAlign(nLin,nPxAbonos+2,aImp[nX,3,2],oFontM,500,100,,ALIGN_H_LEFT)
					oPrinter:SayAlign(nLin,nPxObser+2,aImp[nX,3,1],oFontM,500,100,,ALIGN_H_LEFT)
				else
					if Len(aImp[nX]) < 5 .and. Empty(aImp[nX,2]) 
						oPrinter:SayAlign(nLin,aNaES[1],aImp[nX,3],oFontM,Len(aNaES)*40,100,,ALIGN_H_CENTER)
					else
						oPrinter:SayAlign(nLin,nPxObser+2,aImp[nX,3],oFontM,500,100,,ALIGN_H_LEFT)
					endif
				endif

				if Len(aResult) > 0
					nValAux := 0
					Aeval(aResult, {|x| If( x[1] == DtoS(aImp[nX,1]) .and. x[2] == "1" /*.and. x[4] == aImp[nX][Len(aImp[nX])]*/, nValAux += x[3],nil )} )
					if nValAux > 0
						oPrinter:SayAlign(nLin,nPxHE+2,StrTran(StrZero(nValAux,5,2),'.',':'),oFontM,500,100,,ALIGN_H_LEFT)
						nValAux := 0
					endif
					Aeval(aResult, {|x| If( x[1] == DtoS(aImp[nX,1]) .and. x[2] == "2" .and. x[4] == aImp[nX][Len(aImp[nX])], nValAux += x[3],nil )} )
					if nValAux > 0
						oPrinter:SayAlign(nLin,nPxFalta+2,StrTran(StrZero(nValAux,5,2),'.',':'),oFontM,500,100,,ALIGN_H_LEFT)
						nValAux := 0
					endif
					Aeval(aResult, {|x| If( x[1] == DtoS(aImp[nX,1]) .and. x[2] == "3" .and. x[4] == aImp[nX][Len(aImp[nX])], nValAux += x[3],nil )} )
					if nValAux > 0
						oPrinter:SayAlign(nLin,nPxAdnNot+2,StrTran(StrZero(nValAux,5,2),'.',':'),oFontM,500,100,,ALIGN_H_LEFT)
						nValAux := 0
					endif
				endif
			endif							                                                                   
		else
			//-> Detalhes do Codigo HTML.
			if ( lZebrado := ( nX%2 == 0.00 ) )
				cHtml += '<tr bgcolor="#FAFBFC">' + CRLF
				cHtml += 	'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="center">' + CRLF
				cHtml += 		Dtoc(aImp[nX,1]) + CRLF
				cHtml += 	'</td>' + CRLF
				cHtml += 	'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="left">' + CRLF
				cHtml +=		DiaSemana(aImp[nX,1]) + CRLF
				cHtml += 	'</td>' + CRLF
			else
				cHtml += '<tr>' + CRLF
				cHtml += 	'<td class="dados_2" nowrap><div align="center">' + CRLF
				cHtml += 		Dtoc(aImp[nX,1]) + CRLF
				cHtml += 	'</td>' + CRLF
				cHtml += 	'<td class="dados_2" nowrap><div align="left">' + CRLF
				cHtml +=		DiaSemana(aImp[nX,1]) + CRLF
				cHtml += 	'</td>' + CRLF
			endif
			if ( nLenImpnX := Len(aImp[nX]) ) < ( ( nColunas + nLenImpnX ) - 1 )
				for nY := Len(aImp[nX]) To ( ( nColunas + 3 ) - 1 )
					aAdd(aImp[nX] , Space(05) )
				next nY
			endif
			nLenImpnX := Len(aImp[nX])
			for nY := 4 To nLenImpnX
				if ( lZebrado )
					cHtml += 	'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="center">' + CRLF
					cHtml += 		aImp[nX,nY] + CRLF
					cHtml += 	'</td>' + CRLF
				else
					cHtml += 	'<td class="dados_2" nowrap><div align="center">' + CRLF
					cHtml += 		aImp[nX,nY] + CRLF
					cHtml += 	'</td>' + CRLF
				endif	
			next nY

			//-- Trata Abonos e Excecoes
			if ValType(aImp[nX,3]) == "A"
				nAbHora:=  At( ":" , aImp[nX,3,2] )
			else
				nAbHora:=  At( ":" , aImp[nX,3] )
			endif

			if nAbHora > 0 
				cOcorr :=	Capital( if (ValType(aImp[nX,3]) == "A",aImp[nX,3,1],SubStr( aImp[nX,3] , 1 , nAbHora - 3 )) ) 
				cAbHora:= 	Capital( if (ValType(aImp[nX,3]) == "A",aImp[nX,3,2],SubStr( aImp[nX,3] , nAbHora - 2 ) ) ) 
			else                                                                      
				cOcorr :=	Capital( if (ValType(aImp[nX,3]) == "A",aImp[nX,3,1],AllTrim( aImp[nX,3] ) ))
				cAbHora:= 	'&nbsp;'	
			endif                                                

			if ( lZebrado )
				cHtml += 		'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="center">' + CRLF
				cHtml +=			Capital( AllTrim( aImp[nX,2] ) )
				cHtml += 		'</td>' + CRLF
				cHtml += 		'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="left">' + CRLF
				cHtml +=	 		cOcorr   						
				cHtml += 		'</td>' + CRLF
				cHtml += 		'<td class="dados_2" bgcolor="#FAFBFC" nowrap><div align="left">' + CRLF
				cHtml +=	 		cAbHora	
				cHtml += 		'</td>' + CRLF
			else
				cHtml += 		'<td class="dados_2" nowrap><div align="center">' + CRLF
				cHtml +=			Capital( AllTrim( aImp[nX,2] ) )
				cHtml += 		'</td>' + CRLF
				cHtml += 		'<td class="dados_2" nowrap><div align="left">' + CRLF
				cHtml +=	 		cOcorr   						
				cHtml += 		'</td>' + CRLF
				cHtml += 		'<td class="dados_2" nowrap><div align="left">' + CRLF
				cHtml +=			cAbHora
				cHtml += 		'</td>' + CRLF
			endif	
		endif
	next nX

	if !( lTerminal )
		nLin += 35	
		//-- Se existirem totais, e se for selecionada sua impress„o, ser„o impressos.
		if lImpMarc .and. Len(aTotais) > 0 .and. nImpHrs # 4
			if nLin > nLinTot - 40
				fImpSign(oPrinter)
				oPrinter:EndPage()
				oPrinter:StartPage()
				Imp_Cabec( nTamLin , nColunas ,  lTerminal, 0, oPrinter )
				nLin+=20
			endif

			oPrinter:Box( nLin, nCol , nLin+13, nColTot, "-6" )			// Caixa da linha total

			nTamCol	 := (nColTot - nCol) / 21
			nColCod1 := nCol + nTamCol
			nColDesc1:= nColCod1 + (nTamCol*4)
			nColCalc1:= nColDesc1 + nTamCol
			nColInf1 := nColCalc1 + nTamCol
			nColCod2 := nColInf1 + nTamCol
			nColDesc2:= nColCod2 + (nTamCol*4)
			nColCalc2:= nColDesc2 + nTamCol
			nColInf2 := nColCalc2 + nTamCol
			nColCod3 := nColInf2 + nTamCol
			nColDesc3:= nColCod3 + (nTamCol*4)
			nColCalc3:= nColDesc3 + nTamCol

			if lBigLine
				oPrinter:Fillrect( {nLin+1, nCol+1, nLin+13, nColTot-1 }, oBrushC, "-2") // Quadro na Cor Cinza
			endif		 

			oPrinter:Line( nLin, nColCod1	, nLin+13, nColCod1		, 0 , "-6")
			if nImpHrs == 1 .or. nImpHrs == 3
				oPrinter:Line( nLin, nColDesc1	, nLin+13, nColDesc1	, 0 , "-6")
			endif
			oPrinter:Line( nLin, nColCalc1	, nLin+13, nColCalc1	, 0 , "-6")
			oPrinter:Line( nLin, nColInf1	, nLin+13, nColInf1		, 0 , "-6")
			oPrinter:Line( nLin, nColCod2	, nLin+13, nColCod2		, 0 , "-6")
			if nImpHrs == 1 .or. nImpHrs == 3
				oPrinter:Line( nLin, nColDesc2	, nLin+13, nColDesc2	, 0 , "-6")
			endif
			oPrinter:Line( nLin, nColCalc2	, nLin+13, nColCalc2	, 0 , "-6")
			oPrinter:Line( nLin, nColInf2	, nLin+13, nColInf2		, 0 , "-6")
			oPrinter:Line( nLin, nColCod3	, nLin+13, nColCod3		, 0 , "-6")
			if nImpHrs == 1 .or. nImpHrs == 3
				oPrinter:Line( nLin, nColDesc3	, nLin+13, nColDesc3	, 0 , "-6")
			endif
			oPrinter:Line( nLin, nColCalc3	, nLin+13, nColCalc3	, 0 , "-6")

			oPrinter:SayAlign(nLin,nCol+2,STR0064,oFontP2,500,100,,ALIGN_H_LEFT)				//Codigo
			oPrinter:SayAlign(nLin,nColCod1+2,STR0065,oFontP2,500,100,,ALIGN_H_LEFT)			//Descrição

			if nImpHrs == 1 .or. nImpHrs == 3
				oPrinter:SayAlign(nLin,nColDesc1+2,STR0066,oFontP2,500,100,,ALIGN_H_LEFT)	//Calculado
			endif

			oPrinter:SayAlign(nLin,nColCalc1+2,STR0067,oFontP2,500,100,,ALIGN_H_LEFT)		//Informado

			oPrinter:SayAlign(nLin,nColInf1+2,STR0064,oFontP2,500,100,,ALIGN_H_LEFT)			//Codigo
			oPrinter:SayAlign(nLin,nColCod2+2,STR0065,oFontP2,500,100,,ALIGN_H_LEFT)			//Descrição

			if nImpHrs == 1 .or. nImpHrs == 3		
				oPrinter:SayAlign(nLin,nColDesc2+2,STR0066,oFontP2,500,100,,ALIGN_H_LEFT)	//Calculado
			endif
			oPrinter:SayAlign(nLin,nColCalc2+2,STR0067,oFontP2,500,100,,ALIGN_H_LEFT)		//Informado

			oPrinter:SayAlign(nLin,nColInf2+2,STR0064,oFontP2,500,100,,ALIGN_H_LEFT)			//Codigo
			oPrinter:SayAlign(nLin,nColCod3+2,STR0065,oFontP2,500,100,,ALIGN_H_LEFT)			//Descrição

			if nImpHrs == 1 .or. nImpHrs == 3		
				oPrinter:SayAlign(nLin,nColDesc3+2,STR0066,oFontP2,500,100,,ALIGN_H_LEFT)	//Calculado
			endif
			oPrinter:SayAlign(nLin,nColCalc3+2,STR0067,oFontP2,500,100,,ALIGN_H_LEFT)		

			nMetade := nLin
			nContEve:= 1
			for nX := 1 To Len(aTotais)
				if nContEve == 1
					nMetade+=12
					if nMetade > nLinTot - 40
						fImpSign(oPrinter)
						oPrinter:EndPage()
						oPrinter:StartPage()
						Imp_Cabec( nTamLin , nColunas ,  lTerminal, 2, oPrinter )
						nLin+=12
					endif
					oPrinter:Box(  nMetade, nCol	, nMetade+13, nColTot	, "-6" )
					if lBigLine .and. lBrush
						oPrinter:Fillrect( {nMetade+1, nCol+1, nMetade+12, nColTot-1 }, oBrushI, "-2") // Quadro na Cor Cinza
						lBrush := .F.
					else
						lBrush := .T.
					endif				
					oPrinter:Line( nMetade, nColCod1	, nMetade+13, nColCod1	, 0 , "-6")
					oPrinter:Line( nMetade, nColDesc1	, nMetade+13, nColDesc1	, 0 , "-6")
					oPrinter:Line( nMetade, nColCalc1	, nMetade+13, nColCalc1	, 0 , "-6")
					oPrinter:Line( nMetade, nColInf1	, nMetade+13, nColInf1	, 0 , "-6")
					oPrinter:Line( nMetade, nColCod2	, nMetade+13, nColCod2	, 0 , "-6")
					oPrinter:Line( nMetade, nColDesc2	, nMetade+13, nColDesc2	, 0 , "-6")
					oPrinter:Line( nMetade, nColCalc2	, nMetade+13, nColCalc2	, 0 , "-6")
					oPrinter:Line( nMetade, nColInf2	, nMetade+13, nColInf2	, 0 , "-6")
					oPrinter:Line( nMetade, nColCod3	, nMetade+13, nColCod3	, 0 , "-6")
					oPrinter:Line( nMetade, nColDesc3	, nMetade+13, nColDesc3	, 0 , "-6")
					oPrinter:Line( nMetade, nColCalc3	, nMetade+13, nColCalc3	, 0 , "-6")

					oPrinter:SayAlign(nMetade,nCol+2,aTotais[nX,1],oFontM,500,100,,ALIGN_H_LEFT)
					oPrinter:SayAlign(nMetade,nColCod1+2,aTotais[nX,2],oFontM,500,100,,ALIGN_H_LEFT)
					oPrinter:SayAlign(nMetade,nColDesc1,aTotais[nX,3],oFontM,500,100,,ALIGN_H_LEFT)
					oPrinter:SayAlign(nMetade,nColCalc1,aTotais[nX,4],oFontM,500,100,,ALIGN_H_LEFT)
					nContEve++
				elseif nContEve == 2
					oPrinter:SayAlign(nMetade,nColInf1+2,aTotais[nX,1],oFontM,500,100,,ALIGN_H_LEFT)
					oPrinter:SayAlign(nMetade,nColCod2+2,aTotais[nX,2],oFontM,500,100,,ALIGN_H_LEFT)
					oPrinter:SayAlign(nMetade,nColDesc2,aTotais[nX,3],oFontM,500,100,,ALIGN_H_LEFT)
					oPrinter:SayAlign(nMetade,nColCalc2,aTotais[nX,4],oFontM,500,100,,ALIGN_H_LEFT)
					nContEve++
				elseif nContEve == 3
					oPrinter:SayAlign(nMetade,nColInf2+2,aTotais[nX,1],oFontM,500,100,,ALIGN_H_LEFT)
					oPrinter:SayAlign(nMetade,nColCod3+2,aTotais[nX,2],oFontM,500,100,,ALIGN_H_LEFT)
					oPrinter:SayAlign(nMetade,nColDesc3,aTotais[nX,3],oFontM,500,100,,ALIGN_H_LEFT)
					oPrinter:SayAlign(nMetade,nColCalc3,aTotais[nX,4],oFontM,500,100,,ALIGN_H_LEFT)			
					nContEve++
				endif
				if nContEve > 3
					nContEve := 1
				endif
				nLin := nMetade
			next nX
		endif

		fImpSign(oPrinter)
	else
		//-> Final da Estrutura do Codigo HTML.
		cHtml +=									'<tr>' + CRLF
		cHtml +=										'<td colspan="' + AllTrim( Str( nColunas + 5 ) ) + '" class="etiquetas_1" bgcolor="#FAFBFC"><hr size="1"></td>' + CRLF 
		cHtml +=									'</tr>' + CRLF
		cHtml +=								'</table>' + CRLF
		cHtml +=							'</td>' + CRLF
		cHtml +=							'<td background="'+TcfRetDirImg()+'/tabela_conteudo_2.gif" width="7">&nbsp;</td>' + CRLF
		cHtml +=						'</tr>' + CRLF
		cHtml +=					'</table>' + CRLF
		cHtml +=				'</td>' + CRLF
		cHtml +=			'</tr>' + CRLF
		cHtml +=		'</table>' + CRLF
		cHtml +=		'<p align="right"><a href="javascript:self.print()"><img src="'+TcfRetDirImg()+'/imprimir.gif" width="90" height="28" hspace="20" border="0"></a></p>' + CRLF
		cHtml +=	'</body>' + CRLF
		cHtml += '</html>' + CRLF
	endif
return( cHtml )

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | FMontaaIMP     | Autor | TOTVS     	         | Data | 09.04.1996|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Monta o Vetor aImp , utilizado na impressao do espelho            |
+-----------+-------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                     |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|           |                                                                   |
+-----------+-------------------------------------------------------------------+
*/
static function FMontaAimp(aTabCalend, aMarcacoes, aImp,dInicio,dFim, lTerminal, lImpAcum)
	local aDescAbono := {}
	local cTipAfas   := ""
	local cDescAfas  := ""
	local cOcorr     := ""
	local cOrdem     := ""
	local cTipDia    := ""
	local dData      := Ctod("//")
	local dDtBase    := dFim
	local lRet       := .T.
	local lFeriado   := .T.
	local lTrabaFer  := .F.
	local lAfasta    := .T.   
	local nX         := 0
	local nDia       := 0
	local nMarc      := 0
	local nLenMarc	 := Len( aMarcacoes )
	local nLenDescAb := Len( aDescAbono )
	local nTab       := 0
	local nContMarc  := 0
	local nDias		 := 0 
	local nY         := 0
	local nPsTotDt   := 0
	local aTotDt     := {}

	//-- Variaveis ja inicializadas.
	aImp := {}

	nDias := ( dDtBase - dInicio )
	for nDia := 0 To nDias

		//-- Reinicializa Variaveis.
		dData      := dInicio + nDia
		aDescAbono := {}
		cOcorr     := ""
		cTipAfas   := ""
		cDescAfas  := ""
		cOcorr	   := ""

		if !lImpMarc	
			//-- Adiciona Nova Data a ser impressa.
			aAdd(aImp,{})
			aAdd(aImp[Len(aImp)], dData)
			aAdd(aImp[Len(aImp)], Space(1))
			nContMarc++
			Loop 
		endif	

		//-- o Array aTabcalend ‚ setado para a 1a Entrada do dia em quest„o.
		if ( nTab := aScan(aTabCalend, {|x| x[1] == dData .and. x[4] == '1E' }) ) == 0.00
			Loop
		endif

		//-- o Array aMarcacoes ‚ setado para a 1a Marca‡„o do dia em quest„o.
		nMarc := aScan(aMarcacoes, { |x| x[3] == aTabCalend[nTab, 2] })

		//-- Consiste Afastamentos, Demissoes ou Transferencias.
		if ( ( lAfasta := aTabCalend[ nTab , 24 ] ) .or. SRA->( RA_SITFOLH $ 'DúT' .and. dData > RA_DEMISSA ) )
			lAfasta		:= .T.
			cTipAfas	:= IF(!Empty(aTabCalend[ nTab , 25 ]),aTabCalend[ nTab , 25 ],fDemissao(SRA->RA_SITFOLH, SRA->RA_RESCRAI) )
			cDescAfas	:= fDescAfast( cTipAfas, Nil, Nil, SRA->( RA_SITFOLH == 'D' .and. dData > RA_DEMISSA ), aTabCalend[ nTab , 47 ] )
		endif

		//Verifica Regra de Apontamento ( Trabalha Feriado ? )
		lTrabaFer := ( PosSPA( aTabCalend[ nTab , 23 ] , cFilSPA , "PA_FERIADO" , 01 ) == "S" )

		//-- Consiste Feriados.
		if ( lFeriado := aTabCalend[ nTab , 19 ] )  .AND. !lTrabaFer
			cOcorr := aTabCalend[ nTab , 22 ]
		endif

		//-- Carrega Array aDescAbono com os Abonos ocorridos no Dia
		nLenDescAb := Len(aAbonados)
		for nX := 1 To nLenDescAb
			if aAbonados[nX,1] == dData
				aAdd(aDescAbono, { aAbonados[nX,2] , aAbonados[nX,3] , aAbonados[nX,4] })
			endif
		next nX

		//-- Ordem e Tipo do dia em quest„o.
		cOrdem  := aTabCalend[nTab,2]
		cTipDia := aTabCalend[nTab,6]

		//-- Se a Data da marcacao for Posterior a Admissao
		if dData >= SRA->RA_ADMISSA
			//-- Se Afastado
			if ( lAfasta  .AND. aTabCalend[nTab,10] <> 'E' ) .OR. ( lAfasta  .AND. aTabCalend[nTab,10] == 'E' .AND. ( !lImpExcecao .OR. !aTabCalend[nTab,32] ) )
				cOcorr := cDescAfas 
				//-- Se nao for Afastado
			else                    

				//-- Se tiver EXCECAO para o Dia  ------------------------------------------------
				if aTabCalend[nTab,10] == 'E'			
					//-- Se excecao trabalhada
					if cTipDia == 'S'  
						//-- Se nao fez Marcacao
						if Empty(nMarc)
							cOcorr := STR0020  // '** Ausente **'	
							//-- Se fez marcacao	 
						else
							//-- Motivo da Marcacao
							if !Empty(aTabCalend[nTab,11])
								cOcorr := AllTrim(aTabCalend[nTab,11])
							else
								cOcorr := STR0018  // '** Excecao nao Trabalhada **'
							endif
						endif	 
						//-- Se excecao outros dias (DSR/Compensado/Nao Trabalhado)
					else
						//-- Motivo da Marcacao
						if !Empty(aTabCalend[nTab,11])
							cOcorr := AllTrim(aTabCalend[nTab,11])
						else
							cOcorr := STR0018  // '** Excecao nao Trabalhada **'  
						endif
					endif	

					//-- Se nao Tiver Excecao  no Dia ---------------------------------------------------
				else    
					//-- Se feriado 
					if lFeriado 
						//-- Se nao trabalha no Feriado
						if !lTrabaFer 
							cOcorr := If(!Empty(cOcorr),cOcorr,STR0019 ) // '** Feriado **' 
							//-- Se trabalha no Feriado
						else                  
							//-- Se Dia Trabalhado e Nao fez Marcacao
							if cTipDia == 'S' .and. Empty(nMarc)
								cOcorr := STR0020  // '** Ausente **'
							elseif cTipDia == 'D'
								cOcorr := STR0021  // '** D.S.R. **'  
							elseif cTipDia == 'C'
								cOcorr := STR0022  // '** Compensado **'
							elseif cTipDia == 'N'
								cOcorr := STR0023  // '** Nao Trabalhado **'
							endif
						endif
					else                                    
						//-- Se Dia Trabalhado e Nao fez Marcacao
						if cTipDia == 'S' .and. Empty(nMarc)
							cOcorr := STR0020  // '** Ausente **'
						elseif cTipDia == 'D'
							cOcorr := STR0021  // '** D.S.R. **'
						elseif cTipDia == 'C'
							cOcorr := STR0022  // '** Compensado **'
						elseif cTipDia == 'N'
							cOcorr := STR0023  // '** Nao Trabalhado **'
						endif

					endif	
				endif
			endif
		endif	    

		nLenDescAb := Len(aDescAbono) 

		//-- Adiciona Nova Data a ser impressa.
		aAdd(aImp,{})
		aAdd(aImp[Len(aImp)], aTabCalend[nTab,1])

		//-- Ocorrencia na Data.
		if (lTerminal) 
			aAdd( aImp[Len(aImp)], cOcorr) 
		endif	

		//-- Abono na Data.
		if ( nLenDescAb  > 0 )
			if !( lTerminal)
				if cOcorr == STR0020  // '** Ausente **'
					aAdd( aImp[Len(aImp)], cOcorr ) // '** Ausente **'
				else
					if !empty(cOcorr)
						aAdd( aImp[Len(aImp)],	Space(01)) 
						aAdd( aImp[Len(aImp)], cOcorr )
						aAdd( aImp,{})
						aAdd( aImp[Len(aImp)], aTabCalend[nTab,1])
						aAdd( aImp[Len(aImp)],	Space(01) )
					else                                   
						aAdd( aImp[Len(aImp)],	Space(01)) 
					endif	
				endif
			endif
			for nX := 1 To nLenDescAb
				if nX == 1
					aAdd( aImp[Len(aImp)], aDescAbono[nX])
				else
					aAdd(aImp, {})
					aAdd(aImp[Len(aImp)], aTabCalend[nTab,1]		)
					aAdd(aImp[Len(aImp)], Space(01)			 	)
					aAdd(aImp[Len(aImp)], aDescAbono[nX]			)
				endif
			next nX
		else
			if ( lTerminal ) 
				aAdd( aImp[Len(aImp)], '' )
			else
				if cOcorr == STR0020  // '** Ausente **'
					aAdd( aImp[Len(aImp)], cOcorr) 
					aAdd( aImp[Len(aImp)], Space(01)) 
				else
					aAdd( aImp[Len(aImp)], Space(01)) 
					aAdd( aImp[Len(aImp)], cOcorr )
				endif	
			endif		
		endif

		//-- Marca‡oes ocorridas na data.
		if nMarc > 0
			while nMarc <= nLenMarc .and. cOrdem == aMarcacoes[nMarc,3]
				nContMarc ++
				aAdd( aImp[Len(aImp)], StrTran(StrZero(aMarcacoes[nMarc,2],5,2),'.',':') + If(aMarcacoes[nMarc,28]<>"O","*","") ) //Se nao for original, inclui asterisco na frente da marcacao
				nMarc ++
			End while
		endif
	next nDia

	//-> Acrescentando um indexador de data em aImp.
	for nY := 1 To Len(aImp)
		nPsTotDt := aScan(aTotDt,{|x| x[1] = aImp[nY][1] })
		if nPsTotDt > 0
			aTotDt[nPsTotDt][2] ++
		else
			aAdd(aTotDt,{aImp[nY][1] , 1 })
		endif

		aAdd(aImp[nY], If(nPsTotDt > 0, aTotDt[nPsTotDt][2], aTotDt[Len(aTotDt)][2]) )
	next nY

	if lImpMarc .and. !lTerminal //Carrega o array aResult para exibicao das HE, faltas e adc. noturno.
		aResult := {}
		fGetApo(@aResult, dInicio, dFim, lImpAcum)

		for nX := 1 To Len(aResult)
			aResult[nX,3]:= __TimeSum( __TimeSum( aResult[ nX , 3 ] , 0 ) , 0 )
		next nX
	endif
	lRet := If(nContMarc>=1,.T.,.F.)
return( lRet )

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | Imp_Cabec      | Autor | EQUIPE DE RH          | Data | 09.04.1996|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Imprime o cabecalho do espelho do ponto                           |
+-----------+-------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                     |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|           |                                                                   |
+-----------+-------------------------------------------------------------------+
*/
static function Imp_Cabec(nTamLin ,nColunas, lTerminal, nTipoCab, oPrinter )
	local cDet			:= ""
	local cHtml			:= ""
	local lImpTurnos	:=.F.
	local nVezes		:= ( nColunas / 2 )
	local nQtdeTurno	:= 0.00
	local nX			:= 0.00
	local nTamTno		:= ( Min(TamSx3("R6_DESC")[1], nTamLin) ) - 1
	local nSizePage		:= 0
	local nColCab12		:= 0
	local nColCab13		:= 0
	local nVarAux		:= 0
	local nESAux		:= 0
	local oBrush		:= TBrush():New( ,  RGB(228, 228, 228)  )

	default lTerminal := .F.
	default nTipoCab  := 3 // 1 - Cab para as Marcacoes / 2 - Totais / 3 - Sem Cab Auxiliar

	lImpTurnos := nTipoCab <> 2

	if !( lTerminal )

		nSizePage	:= oPrinter:nPageWidth / oPrinter:nFactorHor //Largura da página em cm dividido pelo fator horizontal, retorna tamanho da página em pixels
		nLin		:= aMargRel[2] + 10
		nCol		:= aMargRel[1] + 10
		nPxData	 	:= nCol+50
		nPxSemana	:= nPxData+50
		nVarAux		:= nPxSemana
		nColTot		:= nSizePage-(aMargRel[1]+aMargRel[3])
		nLinTot		:= (oPrinter:nPageHeight / oPrinter:nFactorVert) - (aMargRel[2]+aMargRel[4])
		nColCab12	:= nColTot / 3
		nColCab13	:= ( nColTot / 3 ) * 2
		aNaES		:= Array(nColunas)

		for nX := 1 to Len(aNaES)
			aNaES[nX] := nVarAux
			nVarAux += 40	
		next nX

		nPxAbonos 	:= nVarAux
		nPxHe	 	:= nPxAbonos + 40
		nPxFalta 	:= nPxHe + 40
		nPxAdnNot	:= nPxFalta + 40
		nPxObser  	:= nPxAdnNot + 40 

		if lCodeBar
			if lBigLine
				oPrinter:Fillrect( {nLin, nCol, nLin+17, nColTot-210 }, oBrush, "-2") 	// Quadro na Cor Cinza
			endif
			oPrinter:SayAlign(nLin+2,nCol,STR0001,oFontT,nColTot-210,100,,ALIGN_H_CENTER)  	// 'Espelho do Ponto'	

			oPrinter:Box( nLin+3, nColTot-200	, nLin+38, nColTot-5, "-6" )				// Caixa da linha total
			oPrinter:Code128c(nLin+30, nColTot-176, cCodeBar, 20)
			oPrinter:SayAlign(nLin+30,nColTot-200,cCodeBar,oFont06,(nColTot-(nColTot-200)),100,,ALIGN_H_CENTER)
		else
			if lBigLine
				oPrinter:Fillrect( {nLin, nCol, nLin+17, nColTot }, oBrush, "-2") 	// Quadro na Cor Cinza
			endif
			oPrinter:SayAlign(nLin+2,nCol,STR0001,oFontT,nColTot,100,,ALIGN_H_CENTER)  	// 'Espelho do Ponto'	
		endif

		nLin += 18	

		cDet := STR0071  + PADR( If(Len(aInfo)>0,aInfo[03],SM0->M0_NomeCom) , 50)  // 'Empresa: '
		oPrinter:SayAlign(nLin,nCol,cDet,oFontP,500,100,,ALIGN_H_LEFT)

		cDet := STR0075  + PADR(Transform( If(Len(aInfo)>0,aInfo[08],SM0->M0_CGC),'@R ##.###.###/####-##'),50)   // 'CGC: '
		oPrinter:SayAlign(nLin,nColCab12,cDet,oFontP,500,100,,ALIGN_H_LEFT)

		nLin += 13
		cDet := PADR( If(Len(aInfo)>0,aInfo[04],SM0->M0_EndCob) , 50)
		oPrinter:SayAlign(nLin,nCol,cDet,oFontP,500,100,,ALIGN_H_LEFT)

		nLin += 13

		oPrinter:Line(nLin,nCol,nLin,nColTot)

		nLin += 5
		cDet := STR0072  + AllTrim(SRA->RA_FILIAL) + ' - ' + SRA->RA_MAT  // ' Matr..: '
		oPrinter:SayAlign(nLin,nCol,cDet,oFontP,500,100,,ALIGN_H_LEFT)

		cDet := STR0074  + SRA->RA_Nome  // ' Nome..: '
		oPrinter:SayAlign(nLin,nColCab12,cDet,oFontP,500,100,,ALIGN_H_LEFT)

		cDet := STR0073  + SRA->RA_Chapa // '  Chapa : '
		oPrinter:SayAlign(nLin,nColCab13,cDet,oFontP,500,100,,ALIGN_H_LEFT)

		nLin += 13
		cDet := STR0078  + aFuncFunc[6] // ' Categ.: '
		oPrinter:SayAlign(nLin,nCol,cDet,oFontP,500,100,,ALIGN_H_LEFT)

		cDet := STR0077  + PADR(AllTrim(aFuncFunc[1]) + ' - ' + aFuncFunc[2] , 50) // 'C.C...: '
		oPrinter:SayAlign(nLin,nColCab12,cDet,oFontP,500,100,,ALIGN_H_LEFT)

		cDet := STR0076  + AllTrim(aFuncFunc[3]) + ' - ' + aFuncFunc[4]  // 'Funcao: '
		oPrinter:SayAlign(nLin,nColCab13,cDet,oFontP,500,100,,ALIGN_H_LEFT)

		nLin += 13
		oPrinter:Line(nLin,nCol,nLin,nColTot)

		nLin += 5

		//-- Imprime Trocas de turnos
		nQtdeTurno:=Len(aPrtTurn)

		if !lImpTroca .OR. nQtdeTurno<2   //-- Imprime Somente a descricao do turno atual
			if !lImpTroca .OR. nQtdeTurno == 0 //-- Periodo Atual ou Superior
				cDet := STR0079  + AllTrim(SRA->RA_TnoTrab) + ' ' + fDescTno(SRA->RA_FILIAL,SRA->RA_TnoTrab, nTamTno) 
			else	 //Periodo Anterior 
				cDet := STR0079  + AllTrim(Alltrim(aPrtTurn[1,1])) + ' ' + fDescTno(SRA->RA_FILIAL,aPrtTurn[1,1], nTamTno)
			endif
			oPrinter:SayAlign(nLin,nColCab12,cDet,oFontP,500,100,,ALIGN_H_LEFT)
			cDet := STR0060 + ": " + AllTrim(SRA->RA_DEPTO) + " - " + fDesc("SQB",SRA->RA_DEPTO,"QB_DESCRIC")
			oPrinter:SayAlign(nLin,nCol,cDet,oFontP,500,100,,ALIGN_H_LEFT)
		else
			if lImpTurnos // Se for o mesmo funcionario nao imprime trocas de turnos a partir da 2 pagina
				//-- Imprime Trocas de Turnos no Periodo
				for nX := 1 To nQtdeTurno
					cDet:= If(nX==1,STR0049,SPACE(Len(STR0049)))
					cDet:= cDet+DTOC(aPrtTurn[nX,2])+" "+STR0048+Alltrim(aPrtTurn[nX,1])+": "+fDescTno( SRA->RA_FILIAL, aPrtTurn[nX,1], nTamTno)
					oPrinter:SayAlign(nLin,nColCab12,cDet,oFontP,500,100,,ALIGN_H_LEFT)
					if nX == 1
						cDet := ' ' + STR0060 + ": " + AllTrim(SRA->RA_DEPTO)  + " - " + fDesc("SQB",SRA->RA_DEPTO,"QB_DESCRIC") // 'Departamento: '
						oPrinter:SayAlign(nLin,nCol,cDet,oFontP,500,100,,ALIGN_H_LEFT)
					endif
				next nX 
			endif	
		endif

		if nTipoCab==1 //Monta e Imprime Cabecalho das Marcacoes

			// Desenho do cabecalho //
			oPrinter:Box( nLin+=18, nCol	, nLin+20, nColTot, "-6" )				// Caixa da linha total

			if lBigLine
				oPrinter:Fillrect( {nLin+1, nCol+1, nLin+17, nColTot-1 }, oBrush, "-2") // Quadro na Cor Cinza
			endif

			oPrinter:Line( nLin, nPxData	, nLin+20, nPxData	, 0 , "-6") 		// Linha Pos Data

			for nX := 1 to Len(aNaES)
				oPrinter:Line( nLin, aNaES[nX]-6	, nLin+20	, aNaES[nX]-6, 0 , "-6")			// Linha Pos Na. Entrada/Saída
			next nX

			oPrinter:Line( nLin, nPxAbonos-6	, nLin+20	, nPxAbonos-6, 0 , "-6")
			oPrinter:Line( nLin, nPxHe-6		, nLin+20	, nPxHe-6, 0 , "-6")
			oPrinter:Line( nLin, nPxFalta-6		, nLin+20	, nPxFalta-6, 0 , "-6")
			oPrinter:Line( nLin, nPxAdnNot-6	, nLin+20	, nPxAdnNot-6, 0 , "-6")

			oPrinter:Line( nLin, nPxObser	, nLin+20	, nPxObser, 0 , "-6")

			oPrinter:SayAlign( nLin+=3 , nCol+5		, STR0042	, oFontP, nPxData, 150 , , ALIGN_H_LEFT ) //Data
			oPrinter:SayAlign( nLin, nPxData+6	, STR0043		, oFontP, nPxSemana, 150 , , ALIGN_H_LEFT ) //Semana

			nESAux := 1
			for nX := 1 to Len(aNaES)
				if nX%2 == 0
					oPrinter:SayAlign( nLin, aNaES[nX], AllTrim(Str(nESAux)) + STR0036, oFontP, aNaES[nX]+40, 150 , , ALIGN_H_LEFT ) //Saida
					nESAux++
				else
					oPrinter:SayAlign( nLin, aNaES[nX], AllTrim(Str(nESAux)) + STR0035, oFontP, aNaES[nX]+40, 150 , , ALIGN_H_LEFT ) //Entrada
				endif
			next nX

			oPrinter:SayAlign( nLin, nPxAbonos	, STR0062		, oFontP, 500, 150 , , ALIGN_H_LEFT ) //Abonos
			oPrinter:SayAlign( nLin, nPxHe		, STR0068		, oFontP, 500, 150 , , ALIGN_H_LEFT ) //H.E.
			oPrinter:SayAlign( nLin, nPxFalta	, STR0069		, oFontP, 500, 150 , , ALIGN_H_LEFT ) //Falt/Atra
			oPrinter:SayAlign( nLin, nPxAdnNot	, STR0070		, oFontP, 500, 150 , , ALIGN_H_LEFT ) //Ad. Not.
			oPrinter:SayAlign( nLin, nPxObser+6	, STR0063		, oFontP, 500, 150 , , ALIGN_H_LEFT ) //Observação
		elseif nTipoCab == 2
			nLin += 18
			oPrinter:Box( nLin, nCol , nLin+13, nColTot, "-6" )			// Caixa da linha total

			nTamCol	 := (nColTot - nCol) / 21
			nColCod1 := nCol + nTamCol
			nColDesc1:= nColCod1 + (nTamCol*4)
			nColCalc1:= nColDesc1 + nTamCol
			nColInf1 := nColCalc1 + nTamCol
			nColCod2 := nColInf1 + nTamCol
			nColDesc2:= nColCod2 + (nTamCol*4)
			nColCalc2:= nColDesc2 + nTamCol
			nColInf2 := nColCalc2 + nTamCol
			nColCod3 := nColInf2 + nTamCol
			nColDesc3:= nColCod3 + (nTamCol*4)
			nColCalc3:= nColDesc3 + nTamCol

			if lBigLine
				oPrinter:Fillrect( {nLin+1, nCol+1, nLin+13, nColTot-1 }, oBrush, "-2") // Quadro na Cor Cinza
			endif		 

			oPrinter:Line( nLin, nColCod1	, nLin+13, nColCod1		, 0 , "-6")
			if nImpHrs == 1 .or. nImpHrs == 3
				oPrinter:Line( nLin, nColDesc1	, nLin+13, nColDesc1	, 0 , "-6")
			endif
			oPrinter:Line( nLin, nColCalc1	, nLin+13, nColCalc1	, 0 , "-6")
			oPrinter:Line( nLin, nColInf1	, nLin+13, nColInf1		, 0 , "-6")
			oPrinter:Line( nLin, nColCod2	, nLin+13, nColCod2		, 0 , "-6")
			if nImpHrs == 1 .or. nImpHrs == 3
				oPrinter:Line( nLin, nColDesc2	, nLin+13, nColDesc2	, 0 , "-6")
			endif
			oPrinter:Line( nLin, nColCalc2	, nLin+13, nColCalc2	, 0 , "-6")
			oPrinter:Line( nLin, nColInf2	, nLin+13, nColInf2		, 0 , "-6")
			oPrinter:Line( nLin, nColCod3	, nLin+13, nColCod3		, 0 , "-6")
			if nImpHrs == 1 .or. nImpHrs == 3
				oPrinter:Line( nLin, nColDesc3	, nLin+13, nColDesc3	, 0 , "-6")
			endif
			oPrinter:Line( nLin, nColCalc3	, nLin+13, nColCalc3	, 0 , "-6")		

			oPrinter:SayAlign(nLin,nCol+2,STR0064,oFontP,500,100,,ALIGN_H_LEFT) //Codigo
			oPrinter:SayAlign(nLin,nColCod1+2,STR0065,oFontP,500,100,,ALIGN_H_LEFT) //Descricao

			if nImpHrs == 1 .or. nImpHrs == 3 //Calculado
				oPrinter:SayAlign(nLin,nColDesc1+2,STR0066,oFontP,500,100,,ALIGN_H_LEFT)
			endif

			oPrinter:SayAlign(nLin,nColCalc1+2,STR0067,oFontP,500,100,,ALIGN_H_LEFT) //Informado

			oPrinter:SayAlign(nLin,nColInf1+2,STR0064,oFontP,500,100,,ALIGN_H_LEFT) //Codigo
			oPrinter:SayAlign(nLin,nColCod2+2,STR0065,oFontP,500,100,,ALIGN_H_LEFT) //Descricao

			if nImpHrs == 1 .or. nImpHrs == 3 //Calculado		
				oPrinter:SayAlign(nLin,nColDesc2+2,STR0066,oFontP,500,100,,ALIGN_H_LEFT)
			endif
			oPrinter:SayAlign(nLin,nColCalc2+2,STR0067,oFontP,500,100,,ALIGN_H_LEFT) //Informado
			oPrinter:SayAlign(nLin,nColInf2+2,STR0064,oFontP,500,100,,ALIGN_H_LEFT) //Codigo
			oPrinter:SayAlign(nLin,nColCod3+2,STR0065,oFontP,500,100,,ALIGN_H_LEFT) //Descricao
			if nImpHrs == 1 .or. nImpHrs == 3 //Calculado		
				oPrinter:SayAlign(nLin,nColDesc3+2,STR0066,oFontP,500,100,,ALIGN_H_LEFT)
			endif
			oPrinter:SayAlign(nLin,nColCalc3+2,STR0067,oFontP,500,100,,ALIGN_H_LEFT)//Informado
		endif
	else

		//-> Monta o Cabecalho das Marcacoes.
		cHtml +=									'<tr>' + CRLF
		cHtml +=										'<td colspan="' + AllTrim( Str( nColunas + 5 ) ) + '" class="etiquetas_1" bgcolor="#FAFBFC"><hr size="1"></td>' + CRLF
		cHtml +=									'</tr>' + CRLF
		cHtml +=									'<tr>' + CRLF
		cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
		cHtml +=												'<div align="left">' + CRLF
		cHtml +=													STR0042 + CRLF	//'Data'
		cHtml +=												'</div>' + CRLF
		cHtml +=											'</td>' + CRLF
		cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
		cHtml +=												'<div align="left">' + CRLF
		cHtml +=													STR0043 + CRLF	//'Dia'
		cHtml +=												'</div>' + CRLF
		cHtml +=											'</td>' + CRLF
		for nX := 1 To nVezes
			cHtml +=										'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
			cHtml +=											'<div align="center">' + CRLF
			cHtml +=												StrZero(nX,If(nX<10,1,2)) + STR0044 + CRLF	// '&#170;E.'
			cHtml +=											'</div>' + CRLF
			cHtml +=										'</td>' + CRLF
			cHtml +=										'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
			cHtml +=											'<div align="center">' + CRLF
			cHtml +=												StrZero(nX,If(nX<10,1,2)) + STR0045 + CRLF	//'&#170;S.'
			cHtml +=											'</div>' + CRLF
			cHtml +=										'</td>' + CRLF
		next nX
		cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
		cHtml +=												'<div align="left">' + CRLF
		cHtml +=													STR0046 + CRLF //'Observa&ccedil;&otilde;s
		cHtml +=												'</div>' + CRLF
		cHtml +=											'</td>' + CRLF
		cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
		cHtml +=												'<div align="left">' + CRLF
		cHtml +=													STR0041 + CRLF	//'Motivo de Abono           Horas  Tipo da Marca&ccedil;&atilde;o'
		cHtml +=												'</div>' + CRLF
		cHtml +=											'</td>' + CRLF
		cHtml +=											'<td class="etiquetas_1" bgcolor="#FAFBFC" nowrap>' + CRLF
		cHtml +=												'<div align="left">' + CRLF
		cHtml +=													STR0047 + CRLF	//'Horas  Tipo da Marca&ccedil;&atilde;o'
		cHtml +=												'</div>' + CRLF
		cHtml +=											'</td>' + CRLF
		cHtml +=									'</tr>' + CRLF
		cHtml +=									'<tr>' + CRLF
		cHtml +=										'<td colspan="' + AllTrim( Str( nColunas + 5 ) ) + '" class="etiquetas_1" bgcolor="#FAFBFC"><hr size="1"></td>' + CRLF
		cHtml +=									'</tr>' + CRLF
	endif
return( cHtml )

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | CarAboTot      | Autor | TOTVS     	         | Data | 09.04.1996|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Carrega os totais do SPC e os abonos                              |
+-----------+-------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                     |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|           |                                                                   |
+-----------+-------------------------------------------------------------------+
*/
static function CarAboTot( aTotais , aAbonados , aAbonosPer, lMvAbosEve, lMvSubAbAp ) 
	local aTotSpc		:= {} //-- 1-SPC->PC_PD/2-SPC->PC_QUANTC/3-SPC->PC_QUANTI/4-SPC->PC_QTABONO
	local aCodAbono		:= {}
	local cFilSP9   	:= xFilial( "SP9" , SRA->RA_FILIAL )
	local cFilSRV		:= xFilial( "SRV" , SRA->RA_FILIAL )
	local cImpHoras 	:= If(nImpHrs==1,"C",If(nImpHrs==2,"I","*")) //-- Calc/Info/Ambas
	local cAutoriza 	:= If(nImpAut==1,"A",If(nImpAut==2,"N","*")) //-- Aut./N.Aut./Ambas
	local cAliasRes		:= IF( lImpAcum , "SPL" , "SPB" )
	local cAliasApo		:= IF( lImpAcum , "SPH" , "SPC" )
	local bAcessaSPC 	:= &("{ || " + ChkRH("PONR010","SPC","2") + "}")
	local bAcessaSPH 	:= &("{ || " + ChkRH("PONR010","SPH","2") + "}")
	local bAcessaSPB 	:= &("{ || " + ChkRH("PONR010","SPB","2") + "}")
	local bAcessaSPL 	:= &("{ || " + ChkRH("PONR010","SPL","2") + "}")
	local bAcessRes		:= IF( lImpAcum , bAcessaSPH , bAcessaSPC )
	local bAcessApo		:= IF( lImpAcum , bAcessaSPL , bAcessaSPB )
	local nColSpc   	:= 0.00
	local nCtSpc    	:= 0.00
	local nPass     	:= 0.00
	local nHorasCal 	:= 0.00
	local nHorasInf 	:= 0.00
	local nX        	:= 0.00

	if ( lImpRes )
		//Totaliza Codigos a partir do Resultado
		fTotalSPB(;
		@aTotSpc		,;
		SRA->RA_FILIAL	,;
		SRA->RA_Mat		,;
		dMarcIni		,;
		dMarcFim		,;
		bAcessRes		,;
		cAliasRes		 ;
		)
		//-- Converte as horas para sexagenal quando impressao for a partir do resultado
		if ( lSexagenal )	// Sexagenal
			for nCtSpc := 1 To Len(aTotSpc)
				for nColSpc := 2 To 4
					aTotSpc[nCtSpc,nColSpc]:=fConvHr(aTotSpc[nCtSpc,nColSpc],'H')
				next nColSpc
			next nCtSpc
		endif
	endif

	//Totaliza Codigos a partir do Movimento
	fTotaliza(;
	@aTotSpc,;
	SRA->RA_FILIAL,;
	SRA->RA_MAT,;
	bAcessApo,;
	cAliasApo,;
	cAutoriza,;
	@aCodAbono,;
	aAbonosPer,;
	lMvAbosEve,;
	lMvSubAbAp;
	)
	//-- Converte as horas para Centesimal quando impressao for a partir do apontamento
	if !( lImpRes ) .and. !( lSexagenal ) // Centesimal
		for nCtSpc :=1 To Len(aTotSpc)
			for nColSpc :=2 To 4
				aTotSpc[nCtSpc,nColSpc]:=fConvHr(aTotSpc[nCtSpc,nColSpc],'D')
			next nColSpc
		next nCtSpc
	endif

	//-- Monta Array com Totais de Horas
	if nImpHrs # 4  //-- Se solicitado para Listar Totais de Horas
		for nPass := 1 To Len(aTotSpc)
			if ( lImpRes ) //Impressao dos Resultados
				//-- Se encontrar o Codigo da Verba ou for um codigo de hora extra valido de acordo com o solicitado  
				if PosSrv( aTotSpc[nPass,1] , cFilSRV , nil , 01 )
					nHorasCal 	:= aTotSpc[nPass,2] //-- Calculado - Abonado
					nHorasInf 	:= aTotSpc[nPass,3] //-- Informado
					if nHorasCal > 0 .and. cImpHoras $ 'Cú*' .or. nHorasInf > 0 .and. cImpHoras $ 'Iú*'
						cHorCal := If(cImpHoras$'Cú*',Transform(nHorasCal, '@E 999.99'),Space(9)) + Space(1)
						cHorInf := If(cImpHoras$'Iú*',Transform(nHorasInf, '@E 999.99'),Space(9))
						aAdd(aTotais, { aTotSpc[nPass,1], SRV->RV_DESC , cHorCal, cHorInf } )
					endif	
				endif
			elseif PosSP9( aTotSpc[nPass,1] , cFilSP9 , nil , 01 )
				//-- Impressao a Partir do Movimento
				nHorasCal 	:= aTotSpc[nPass,2] //-- Calculado - Abonado
				nHorasInf 	:= aTotSpc[nPass,3] //-- Informado
				if nHorasCal > 0 .and. cImpHoras $ 'Cú*' .or. nHorasInf > 0 .and. cImpHoras $ 'Iú*'
					cHorCal := If(cImpHoras$'Cú*',Transform(nHorasCal, '@E 999.99'),Space(9)) + Space(1)
					cHorInf := If(cImpHoras$'Iú*',Transform(nHorasInf, '@E 999.99'),Space(9))
					aAdd(aTotais, { aTotSpc[nPass,1] , DescPDPon(aTotSpc[nPass,1], cFilSP9 ) , cHorCal, cHorInf } )
				endif  
			endif
		next nPass

		//-- Acrescenta as informacoes referentes aos eventos associados aos motivos de abono
		//-- Condicoes: Se nao for Impressao de Resultados 
		//-- 			e Se for para Imprimir Horas Calculadas ou Ambas
		if !( lImpRes ) .and. (nImpHrs == 1 .or. nImpHrs == 3) 
			for nX := 1 To Len(aCodAbono) 
				// Converte as horas para Centesimal
				if !( lSexagenal ) // Centesimal
					aCodAbono[nX,2]:=fConvHr(aCodAbono[nX,2],'D')
				endif
				aAdd(aTotais, { aCodAbono[nX,1] , DescPDPon(aCodAbono[nX,1], cFilSP9) , '  0,00'  , Transform(aCodAbono[nX,2],'@E 999.99') } )
			next nX
		endif
	endif
return( nil )

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | fTotaliza     | Autor | TOTVS     	         | Data | 27.05.2002|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Totalizar as Verbas do SPC (Apontamentos) /SPH (Acumulado)        |
+-----------+-------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                     |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|10.05.2018 | Alexandre Alves - Inclusão da verificação do evento 027N - Adici- |
+-----------+ onal de Hora Extra Não Autorizada, em função da regra de negocio  |
| especifica CERTISIGN, onde TODAS as Horas Extras são apontadas automaticamente|
| com Não Autorizadas, passando pelo crivo dos gestores para autorizá-las via   |
| Portal de Manutenção de Marcações (tb. específico), mas o Adicional Noturno   |
| sobre as Horas Extras devem ser pagos e assim autorizados, automaticamente.   |
| A checagem do evento foi incluida na linha 2056 do filtro de eventos para to- |
| talização. Desse modo, o evento passa a ser apresentado no rodapé do Espelho  |
| de Ponto enviado via CERTIFLOW.                                               |
+-----------+-------------------------------------------------------------------+
*/
static function fTotaliza(	aTotais		,;
	cFil		,;
	cMat		,;
	bAcessa 	,;
	cAlias		,;
	cAutoriza	,;
	aCodAbono	,;
	aAbonosPer	,;
	lMvAbosEve	,;
	lMvSubAbAp 	 ;
	)

	local aJustifica	:= {}
	local cCodigo		:= ""
	local cPrefix		:= SubStr(cAlias,-2)
	local cTno			:= ""
	local cCodExtras	:= ""
	local cEvento		:= ""
	local cPD			:= ""
	local cPDI			:= ""
	local cCC			:= ""
	local cTPMARCA		:= ""
	local lExtra		:= .T.
	local lAbHoras		:= .T.
	local nQuaSpc		:= 0.00
	local nX			:= 0.00 
	local nEfetAbono	:= 0.00
	local nQUANTC		:= 0.00
	local nQuanti		:= 0.00
	local nQTABONO		:= 0.00

	if ( cAlias )->(dbSeek( cFil + cMat ) )
		while (cAlias)->( !Eof() .and. cFil+cMat == &(cPrefix+"_FILIAL")+&(cPrefix+"_MAT") )

			dData	:= (cAlias)->(&(cPrefix+"_DATA"))  	//-- Data do Apontamento
			cPD		:= (cAlias)->(&(cPrefix+"_PD"))    	//-- Codigo do Evento
			cPDI	:= (cAlias)->(&(cPrefix+"_PDI"))     	//-- Codigo do Evento Informado
			nQUANTC	:= (cAlias)->(&(cPrefix+"_QUANTC"))  	//-- Quantidade Calculada pelo Apontamento
			nQuanti	:= (cAlias)->(&(cPrefix+"_QUANTI"))  	//-- Quantidade Informada
			nQTABONO:= (cAlias)->(&(cPrefix+"_QTABONO")) 	//-- Quantidade Abonada
			cTPMARCA:= (cAlias)->(&(cPrefix+"_TPMARCA")) 	//-- Tipo da Marcacao
			cCC		:= (cAlias)->(&(cPrefix+"_CC")) 		//-- Centro de Custos

			if (cAlias)->( !Eval(bAcessa) )
				(cAlias)->( dbSkip() )
				Loop
			endif

			if dData < dMarcIni .or. dDATA > dMarcFim 
				(cAlias)->( dbSkip() )
				Loop
			endif

			//-> Obtem TODOS os ABONOS do Evento.
			//-- Trata a Qtde de Abonos
			aJustifica 	:= {} //-- Reinicializa aJustifica
			nEfetAbono	:=	0.00
			if nQuanti == 0 .and. fAbonos( dData , cPD , nil , @aJustifica , cTPMARCA , cCC , aAbonosPer ) > 0

				//-- Corre Todos os Abonos
				for nX := 1 To Len(aJustifica)

					//-> Cria Array Analitico de Abonos com horas Convertidas.
					//-- Obtem a Quantidade de Horas Abonadas
					nQuaSpc := aJustifica[nX,2] //_QtAbono

					//-- Converte as horas Abonadas para Centesimal
					if !( lSexagenal ) // Centesimal
						nQuaSpc:= fConvHr(nQuaSpc,'D')
					endif

					//-- Cria Novo Elemento no array ANALITICO de Abonos 
					aAdd( aAbonados, {} )
					aAdd( aAbonados[Len(aAbonados)], dData )
					aAdd( aAbonados[Len(aAbonados)], DescAbono(aJustifica[nX,1],'C') )

					aAdd( aAbonados[Len(aAbonados)], StrTran(StrZero(nQuaSpc,5,2),'.',':') )
					aAdd( aAbonados[Len(aAbonados)], DescTpMa(aBoxSPC,cTPMARCA))

					if !( lImpres )

						//-> Trata das Informacoes sobre o Evento Associado ao Motivo corrente.
						//-- Obtem Evento Associado
						cEvento := PosSP6( aJustifica[nX,1] , SRA->RA_FILIAL , "P6_EVENTO" , 01 )
						if ( lAbHoras := ( PosSP6( aJustifica[nX,1] , SRA->RA_FILIAL , "P6_ABHORAS" , 01 ) $ " S" ) )
							//-- Se o motivo abona Horas
							if ( lAbHoras )
								if !Empty( cEvento )
									if ( nPos := aScan( aCodAbono, { |x| x[1] == cEvento } ) ) > 0
										aCodAbono[nPos,2] := __TimeSum(aCodAbono[nPos,2], aJustifica[nX,2] ) //_QtAbono
									else
										aAdd(aCodAbono, {cEvento,  aJustifica[nX,2] }) // Codigo do Evento e Qtde Abonada
									endif
								else 
									/*+------------------------------------------------------------------------+
									| A T E N C A O: Neste Ponto deveriamos tratar o paramentro MV_ABOSEVE   |
									|                no entanto, como ja havia a deducao abaixo e caso al-   |
									|                guem migra-se da versao 609 com o cadastro de motivo    |
									|                de abonos abonando horas mas sem o codigo, deixariamos  |
									|                de tratar como antes e o cliente argumentaria alteracao |
									|                de conceito.                                            |
									+------------------------------------------------------------------------+*/ 
									//-- Se o motivo  nao possui abono associado
									//-- Calcula o total de horas a abonar efetivamente
									nEfetAbono:= __TimeSum(nEfetAbono, aJustifica[nX,2] ) //_QtAbono
								endif
							endif
						else	
							/*+------------------------------------------------------------------+
							| Se Motivo de Abono Nao Abona Horas e o Codigo do Evento Relaci-  |
							| onado ao Abono nao Estiver Vazio, Eh como se fosse uma  altera   |
							| racao do Codigo de Evento. Ou seja, Vai para os Totais      as   |
							| Horas do Abono que serao subtraidas das Horas Calculadas (  Po   |
							| deriamos Chamar esta operacao de "Informados via Abono" ).       |
							| Para que esse processo seja feito o Parametro MV_SUBABAP  devera |
							| ter o Conteudo igual a "S"                                       |
							+------------------------------------------------------------------+*/
							if ( ( lMvSubAbAp ) .and. !Empty( cEvento ) )
								//-- Se o motivo  nao possui abono associado
								//-- Calcula o total de horas a abonar efetivamente 
								if ( nPos := aScan( aCodAbono, { |x| x[1] == cEvento } ) ) > 0
									aCodAbono[nPos,2] := __TimeSum(aCodAbono[nPos,2], aJustifica[nX,2] ) //_QtAbono
								else
									aAdd(aCodAbono, {cEvento,  aJustifica[nX,2] }) // Codigo do Evento e Qtde Abonada
								endif
								//-- O total de horas acumulado em nEfetAbono sera deduzido do 
								//-- total de horas apontadas.
								nEfetAbono:= __TimeSum(nEfetAbono, aJustifica[nX,2] ) //_QtAbono
							endif
						endif
					endif	
				next nX 
			endif

			if !( lImpres )
				//-- Obtem o Codigo do Evento  (Informado ou Calculado)
				cCodigo:= If(!Empty(cPDI), cPDI, cPD )

				//-- Obtem a posicao no Calendario para a Data

				if ( nPos 	:= aScan(aTabCalend, {|x| x[1] ==dDATA .and. x[4] == '1E' }) ) > 0 
					//-- Obtem o Turno vigente na Data
					cTno	:=	aTabCalend[nPos,14]  
					//-- Carrega ou recupera os codigos correspondentes a horas extras na Data
					cCodExtras	:= ''
					CarExtAut( @cCodExtras , cTno , cAutoriza )
					lExtra:=.F.
					if cCodigo$cCodExtras 
						lExtra:=.T.
					endif   
				endif      

				//-- Se o Evento for Alguma HE Solicitada (Autorizada ou Nao Autorizada) 
				//-- Ou  Valido Qquer Evento (Autorizado e Nao Autorizado)
				//-- OU  Evento possui um identificador correspondente a Evento Autorizado ou Nao Autorizado.
				//-- Ou  Evento e' referente a banco de horas 
				if lExtra .or. cAutoriza == '*' .or.;
				(aScan(aId,{|aEvento| ( aEvento[1] == cCodigo .and. Right(aEvento[2],1) == cAutoriza ) .Or.;
				( aEvento[1] == cCodigo .And. cAutoriza == 'A' .And. Empty(aEvento[2]) .And. aEvento[4] == "S" ) .Or.;
				( aEvento[1] == cCodigo .And. aEvento[2] == '027N')}  ) > 0.00) //-> Especifico CERTISIGN.

					//-- Procura em aTotais pelo acumulado do Evento Lido
					if ( nPos := aScan(aTotais,{|x| x[1] = cCodigo  }) ) > 0    
						//-- Subtrai do evento a qtde de horas que efetivamente abona horas conforme motivo de abono
						aTotais[nPos,2] := __TimeSum(aTotais[nPos,2],If(nQuanti>0, 0, __TimeSub(nQUANTC,nEfetAbono)))
						aTotais[nPos,3] := __TimeSum(aTotais[nPos,3],nQuanti)
						aTotais[nPos,4] := __TimeSum(aTotais[nPos,4],nQTABONO)

					else 
						//-- Adiciona Evento em Acumulados
						//-- Subtrai do evento a qtde de horas que efetivamente abona horas conforme motivo de abono
						aAdd(aTotais,{cCodigo,If(nQuanti > 0, 0, __TimeSub(nQUANTC,nEfetAbono)), nQuanti,nQTABONO,lExtra })
					endif
				endif
			endif
			(cAlias)->( dbSkip() )
		End while
	endif
return( nil )

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | fTotalSPB      | Autor | TOTVS     	         | Data | 05.06.2000|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Totaliza eventos a partir do SPB.                                 |
+-----------+-------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                     |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|           |                                                                   |
+-----------+-------------------------------------------------------------------+
*/
static function fTotalSPB(aTotais,cFil,cMat,dDataIni,dDataFim,bAcessa,cAlias)
	local cPrefix := ""

	cPrefix		:= SubStr(cAlias,-2)
	if ( cAlias )->( dbSeek( cFil + cMat ) )
		while (cAlias)->( !Eof() .and. cFil+cMat == &(cPrefix+"_FILIAL")+&(cPrefix+"_MAT") )

			if (cAlias)->( &(cPrefix+"_DATA") < dDataIni .or. &(cPrefix+"_DATA") > dDataFim )
				(cAlias)->( dbSkip() )
				Loop
			endif

			if (cAlias)->( !Eval(bAcessa) )
				(cAlias)->( dbSkip() )
				Loop
			endif

			if ( nPos := aScan(aTotais,{|x| x[1] == (cAlias)->( &(cPrefix+"_PD") ) }) ) > 0
				aTotais[nPos,2] := aTotais[nPos,2] + (cAlias)->( &(cPrefix+"_HORAS") ) 
			else
				aAdd(aTotais,{(cAlias)->( &(cPrefix+"_PD") ),(cAlias)->( &(cPrefix+"_HORAS") ),0,0 })
			endif
			(cAlias)->( dbSkip() )
		End while
	endif
return( nil )

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | LoadX3Box      | Autor | TOTVS     	         | Data | 10.12.2001|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Retorna array da ComboBox                                         |
+-----------+-------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                     |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|           |                                                                   |
+-----------+-------------------------------------------------------------------+
*/
static function LoadX3Box(cCampo)
	local aRet:={},nCont,nIgual
	local cCbox,cString
	local aSvArea := SX3->(GetArea())

	SX3->(DbSetOrder(2))
	SX3->(DbSeek(cCampo))

	cCbox := SX3->(X3Cbox())
	//-- Opcao 1   |Opcao 2 |Opcao 3|Opcao 4
	//-- 01=Amarelo;02=Preto;03=Azul;04=Vermelho  
	//   | |->nIgual        À->nCont
	//   |->cString: 01=Amarelo
	//aRet:={{01,Amarelo},{02.Preto},...}

	while !Empty(cCbox) 
		nCont:=AT(";",cCbox) 
		nIgual:=AT("=",cCbox)
		cString:=AllTrim(SubStr(cCbox,1,nCont-1)) //Opcao
		if nCont == 0
			aAdd(aRet,{SubStr(cString,1,nigual-1),SubStr(cString,nigual+1)})
			Exit
		else
			aAdd(aRet,{SubStr(cString,1,nigual-1),SubStr(cString,nigual+1)})
		endif 
		cCbox:=SubStr(cCbox,nCont+1)
	end
	RestArea(aSvArea)
return( aRet )

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | DescTPMarc     | Autor | TOTVS     	         | Data | 10.12.2001|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Retorna Descricao do Tipo da Marcacao                             |
+-----------+-------------------------------------------------------------------+
| Parametros| aBox     - Array Contendo as Opcoes do Combox Ja Carregadas       |
|           | cTpMarca - Tipo da Marcacao                                       |
+-----------+-------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                     |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|           |                                                                   |
+-----------+-------------------------------------------------------------------+
*/
static function DescTpMa(aBox,cTpMarca)
	local cRet:=''
	local nTpMarca:=0
	//-- SE Existirem Opcoes Realiza a Busca da Marcacao
	if Len(aBox)>0
		nTpmarca:=aScan(aBox,{|xtp| xTp[1] == cTpMarca})
		cRet:=If(nTpMarca>0,aBox[nTpmarca,2],"")
	endif
return( cRet )

/*
+-----------+----------------+-------+-----------------------+------+------------+
| Rotina    | Monta_Per      | Autor | TOTVS     	         | Data | 09.04.1996 |
+-----------+----------------+-------+-----------------------+------+------------+
| Descricao | dDataIni => Data Inicial do Periodo solicitada pelo usuario.       |
|           | dDataFim => Data Final do Periodo solicitada pelo usuario.         |
|           | cFil     => Filial do Funcionario em processamento.                |
|           | cMat     => Matricula do Funcionario em processamento.             |
|           | dIniAtu  => Data Inicial do Periodo encontrado nas Marcações (Sp8).|
|           | dFimAtu  => Data Final do Periodo encontrado nas Marcações (Sp8).  |
+-----------+--------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                      |
+-----------+--------------------------------------------------------------------+
|                                   MANUTENÇÕES                                  |
+-----------+--------------------------------------------------------------------+
| Data      | Autor - Motivo                                                     |
+-----------+--------------------------------------------------------------------+
|           |                                                                    |
+-----------+--------------------------------------------------------------------+
*/
static function Monta_Per( dDataIni , dDataFim , cFil , cMat , dIniAtu , dFimAtu )
	local aPeriodos := {}
	local cFilSPO	:= xFilial( "SPO" , cFil )
	local dAdmissa	:= SRA->RA_ADMISSA
	local dPerIni   := Ctod("//")
	local dPerFim   := Ctod("//")

	SPO->( dbSetOrder( 1 ) )
	SPO->( dbSeek( cFilSPO , .F. ) )
	while SPO->( !Eof() .and. PO_FILIAL == cFilSPO )
		dPerIni := SPO->PO_DATAINI
		dPerFim := SPO->PO_DATAFIM  
		/*
		== Filtra Periodos de Apontamento a Serem considerados em funcao do Periodo Solicitado ==

		Pode ser que nenhuma data dos periodos lidos de SPO seja selecionada, porque o periodo 
		selecionado para o processo ainda não foi fechado.
		*/
		if dPerFim < dDataIni .OR. dPerIni > dDataFim                                                      
			SPO->( dbSkip() )  
			Loop  
		endif

		//-- Somente Considera Periodos de Apontamentos com Data Final Superior a Data de Admissao
		if ( dPerFim >= dAdmissa )
			aAdd( aPeriodos , { dPerIni , dPerFim , Max( dPerIni , dDataIni ) , Min( dPerFim , dDataFim ) } )
		else
			Exit
		endif
		SPO->( dbSkip() )
	End while

	/*
	dDataIni => Data Inicial do Periodo solicitada pelo usuario.       
	dDataFim => Data Final do Periodo solicitada pelo usuario.       
	dIniAtu  => Data Inicial do Periodo encontrado nas Marcações (Sp8).
	dFimAtu  => Data Final do Periodo encontrado nas Marcações (Sp8).  
	*/

	if ( aScan( aPeriodos , { |x| x[1] == dIniAtu .and. x[2] == dFimAtu } ) == 0.00 ) //Procura na matriz pelo periodo localizado na SP8 e não encontrando processa.
		dPerIni := dIniAtu
		dPerFim	:= dFimAtu 
		/*
		Se a data final do periodo da SP8 NÃO for menor que a Data Inicial solicitada pelo usuário
		Ou se a data inicial do periodo da SP8 NÃO for maior que a Data Final solicitada pelo usuario, processa.
		*/
		if !(dPerFim < dDataIni .OR. dPerIni > dDataFim)  
			if ( dPerFim >= dAdmissa )
				aAdd(aPeriodos, { dPerIni, dPerFim, Max(dPerIni,dDataIni), Min(dPerFim,dDataFim) } )
			endif
		endif
	endif
return( aPeriodos )

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | CarExtAut     | Autor | TOTVS     	         | Data | 24.05.2002|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Retorna Relacao de Horas Extras por Filial/Turno                  |
+-----------+-------------------------------------------------------------------+
| Parametros| cCodExtras --> String que Contem ou Contera os Codigos            |
|           | cTnoCad    --> Turno conforme o Dia                               |
|           | cAutoriza  --> "*" Horas Autorizadas/Nao Autorizadas              | 
|           |                "A" Horas Autorizadas                              | 
|           |                "N" Horas Nao Autorizadas                          |
+-----------+-------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                     |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|           |                                                                   |
+-----------+-------------------------------------------------------------------+
*/
static function CarExtAut( cCodExtras , cTnoCad , cAutoriza )
	local aTabExtra		:= {}
	local cFilSP4		:= fFilFunc("SP4")
	local cTno			:= ""
	local lFound		:= .F.
	local lRet			:= .T.
	local nX			:= 0
	local naTabExtra	:= 0    
	local ncTurno	    := 0.00

	static aExtrasTno

	if ( PCount() == 0.00 )
		aExtrasTno	:= nil              
	else
		default aExtrasTno	:= {} 
		//-- Procura Tabela (Filial + Turno corrente)
		if ( lFound	:= ( SP4->( dbSeek( cFilSP4 + cTnoCad , .F. ) ) ) )
			cTno		:=	cTnoCad
			lFound	:=	.T.
		else      
			//-- Procura Tabela (Filial)    
			cTno	:= Space(Len(SP4->P4_TURNO))
			lFound	:= SP4->( dbSeek(  cFilSP4 + cTno , .F.) )
		endif    
		//-- Se Existe Tabela de HE
		if ( lFound )
			//-- Verifica se a Tabela de HE para o Turno ainda nao foi carregada
			if (ncTurno:=aScan(aExtrasTno,{|aTurno| aTurno[1]  == cFilSP4 .and. aTurno[2] == cTno} )) == 0.00
				//-- Se nao Encontrou Carrega Tabela para Filial e Turno especificos
				GetTabExtra( @aTabExtra , cFilSP4 , cTno , .F. , .F. )     
				//-- Posiciona no inicio da Tabela de HE da Filial Solicitada
				if !Empty(aTabExtra)
					naTabExtra:=	Len(aTabExtra)
					//-- Corre C¢digos de Hora Extra da Filial
					for nX:=1 To naTabExtra
						//-- Se Ambos os Tipos de Eventos ou Autorizados
						if cAutoriza == '*' .or. (cAutoriza == 'A' .and. !Empty(aTabExtra[nX,4]))
							cCodExtras += aTabExtra[nX,4]+'A' //-- Cod Autorizado
						endif
						//-- Se Ambos os Tipos de Eventos ou Nao Autorizados					
						if cAutoriza == '*' .or. (cAutoriza == 'N' .and. !Empty(aTabExtra[nX,5]))
							cCodExtras += aTabExtra[nX,5]+'N' //-- Cod Nao Autorizado                
						endif
					next nX
				endif	  
				//-- Cria Nova Relacao de Codigos Extras para o Turno Lido
				aAdd(aExtrasTno,{cFilSP4,cTno,cCodExtras})
			else
				//-- Recupera Tabela Anteriormente Lida
				cCodExtras:=aExtrasTno[ncTurno,3] 
			endif                    
		endif	
	endif
return( lRet )

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | CarId          | Autor | TOTVS     	         | Data | 25.05.2002|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Retorna Relacao de Eventos da Filial                              |
+-----------+-------------------------------------------------------------------+
| Parametros| cFil --> Codigo da Filial desejada                                |
|           | aId  --> Array com a Relacao                                      |
|           | cAutoriza  --> "*" Horas Autorizadas/Nao Autorizadas              | 
|           |                "A" Horas Autorizadas                              | 
|           |                "N" Horas Nao Autorizadas                          |
+-----------+-------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                     |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|           |                                                                   |
+-----------+-------------------------------------------------------------------+
*/	
static function CarId( cFil , aId , cAutoriza )
	local nPos	:= 0.00
	//-- Preenche o Array aCodAut com os Eventos (Menos DSR Mes Ant.)
	SP9->( dbSeek( cFil , .T. ) )
	while SP9->( !Eof() .and. cFil == P9_FILIAL )
		if ( ( Right(SP9->P9_IDPON,1) == cAutoriza ) .or. ( cAutoriza == "*" ) )
			aAdd( aId , Array( 04 ) )
			nPos := Len( aId )
			aId[ nPos , 01 ] := SP9->P9_CODIGO	//-- Codigo do Evento 
			aId[ nPos , 02 ] := SP9->P9_IDPON 	//-- Identificador do Ponto 
			aId[ nPos , 03 ] := SP9->P9_CODFOL	//-- Codigo do da Verba Folha
			aId[ nPos , 04 ] := SP9->P9_BHORAS	//-- Evento para B.Horas
		endif
		SP9->( dbSkip() )
	end
return( nil )

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | fGetApo        | Autor | TOTVS     	         | Data | 23.03.2015|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Retorna Apontamentos do funcionario.                              |
+-----------+-------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                     |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|           |                                                                   |
+-----------+-------------------------------------------------------------------+
*/
static function fGetApo(aResult,dInicio,dFim,lImpAcum)
	local aArea		:= GetArea()
	local cAliasQry	:= GetnextAlias()
	local cWhere	:= ""
	local cPrefixo	:= If(lImpAcum,"PH_","PC_")
	local cJoinFil	:= ""
	local nControl  := 0
	local nPosResu  := 0

	cWhere += "%"
	cWhere += cPrefixo + "FILIAL = '" + SRA->RA_FILIAL + "' AND "
	cWhere += cPrefixo + "MAT = '" + SRA->RA_MAT + "' AND "
	cWhere += cPrefixo + "DATA >= '" + DtoS(dInicio) + "' AND "
	cWhere += cPrefixo + "DATA <= '" + DtoS(dFim) + "' "
	cWhere += "%"
	if lImpAcum
		cJoinFil:= "%" + FWJoinFilial("SPH", "SP9") + "%"
		BeginSql Alias cAliasQry
			SELECT             
			SPH.PH_DATA, SPH.PH_PD, SPH.PH_QUANTC, SPH.PH_QUANTI, SP9.P9_CLASEV, SP9.P9_IDPON
			FROM 
			%Table:SPH% SPH
			INNER JOIN %Table:SP9% SP9
			ON %exp:cJoinFil% AND SP9.%NotDel% AND SPH.PH_PD = SP9.P9_CODIGO		
			WHERE
			%Exp:cWhere% AND SPH.%NotDel%
			ORDER BY SPH.PH_DATA, SPH.PH_PD	
		EndSql 	
	else
		cJoinFil:= "%" + FWJoinFilial("SPC", "SP9") + "%"
		BeginSql Alias cAliasQry
			SELECT             
			SPC.PC_DATA, SPC.PC_PD, SPC.PC_QUANTC, SPC.PC_QUANTI, SP9.P9_CLASEV, SP9.P9_IDPON
			FROM 
			%Table:SPC% SPC
			INNER JOIN %Table:SP9% SP9
			ON %exp:cJoinFil% AND SP9.%NotDel% AND SPC.PC_PD = SP9.P9_CODIGO			
			WHERE
			%Exp:cWhere%  AND SPC.%NotDel%
			ORDER BY SPC.PC_DATA, SPC.PC_PD	
		EndSql 	
	endif

	while !(cAliasQry)->(Eof())
		nControl := 0
		if (cAliasQry)->P9_CLASEV == "01" //Hora Extra
			if !Empty(aResult)
				for nPosResu := 1 To Len(aResult)
					if             aResult[nPosResu][1] = &(cPrefixo+"DATA") .And.;
					aResult[nPosResu][2] = '1'                
						nControl := aResult[nPosResu][4]
					endif
				next
			endif
			nControl ++
			(cAliasQry)->(aAdd(aResult,{&(cPrefixo+"DATA"),"1",If(&(cPrefixo+"QUANTI")>0,&(cPrefixo+"QUANTI"),&(cPrefixo+"QUANTC")),nControl}))
		elseif (cAliasQry)->P9_CLASEV $ "02*03*04*05" //Faltas/Atrasos/Saida antecipada
			if !Empty(aResult)
				for nPosResu := 1 To Len(aResult)
					if             aResult[nPosResu][1] = &(cPrefixo+"DATA") .And.;
					aResult[nPosResu][2] = '2'                
						nControl := aResult[nPosResu][4]
					endif
				next
			endif
			nControl ++
			(cAliasQry)->(aAdd(aResult,{&(cPrefixo+"DATA"),"2",If(&(cPrefixo+"QUANTI")>0,&(cPrefixo+"QUANTI"),&(cPrefixo+"QUANTC")),nControl}))
			//(cAliasQry)->(aAdd(aResult,{&(cPrefixo+"DATA"),"2",If(&(cPrefixo+"QUANTI")>0,&(cPrefixo+"QUANTI"),&(cPrefixo+"QUANTC"))}))
		elseif (cAliasQry)->P9_IDPON $ "003N*004A*027N*028A" //Adicional Noturno
			if !Empty(aResult)
				for nPosResu := 1 To Len(aResult)
					if             aResult[nPosResu][1] = &(cPrefixo+"DATA") .And.;
					aResult[nPosResu][2] = '3'                
						nControl := aResult[nPosResu][4]
					endif
				next
			endif
			nControl ++	    
			(cAliasQry)->(aAdd(aResult,{&(cPrefixo+"DATA"),"3",If(&(cPrefixo+"QUANTI")>0,&(cPrefixo+"QUANTI"),&(cPrefixo+"QUANTC")),nControl}))
			//(cAliasQry)->(aAdd(aResult,{&(cPrefixo+"DATA"),"3",If(&(cPrefixo+"QUANTI")>0,&(cPrefixo+"QUANTI"),&(cPrefixo+"QUANTC"))}))
		endif	
		(cAliasQry)->(DbSkip())
	end
	(cAliasQry)->(DbCloseArea())
	RestArea(aArea)
return Nil

/*
+-----------+----------------+-------+-----------------------+------+-----------+
| Rotina    | fImpSign       | Autor | TOTVS     	         | Data | 23.03.2015|
+-----------+----------------+-------+-----------------------+------+-----------+
| Descricao | Imprime espaço para assinatura do funcionario.                    |
+-----------+-------------------------------------------------------------------+
| Uso       | Padrao TOTVS.                                                     |
+-----------+-------------------------------------------------------------------+
|                                   MANUTENÇÕES                                 |
+-----------+-------------------------------------------------------------------+
| Data      | Autor - Motivo                                                    |
+-----------+-------------------------------------------------------------------+
|           |                                                                   |
+-----------+-------------------------------------------------------------------+
*/
static function fImpSign(oPrinter)
	//Mensagem antes da assinatura
	if !Empty(cMenPad1) .or. !Empty(cMenPad2)
		oPrinter:SayAlign(nLinTot-35,nCol+2,cMenPad1 + cMenPad2,oFontM,500,100,,ALIGN_H_LEFT)
	endif
	oPrinter:SayAlign(nLinTot-20,nCol,Replicate("_",50),oFontP,nColTot,100,,ALIGN_H_CENTER)
	oPrinter:SayAlign(nLinTot-10,nCol,STR0013,oFontP,nColTot,100,,ALIGN_H_CENTER) // 'Assinatura do Funcionario'
return Nil

static function arqValido( cFile )
	local lRet := .F.
	local nTam := 0
	default cFile := ""

	if !empty( cFile )
		nTam := u_csTamArq( cFile ) //pega o tamanho do arquivo criado
		lRet := !( nTam < 1025 ) //arquivo com bytes criados devem estar em branco, logo sera um arquivo invalido
	endif
return lRet
