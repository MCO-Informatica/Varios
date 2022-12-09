#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#include "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "AP5MAIL.CH"  
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"  
#INCLUDE "TOPCONN.CH"   
 
/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ ANFAT01         ºAutor³ Antonio Marcos Andriani    º Data ³ 03/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Rotina de Processamento de Leitura da Caixa Postal de emails das       º±±
±±º         ³ NFE's recebidas para Importacao dos XML's gerando Pre-Nota Entrada.    º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe  ³ u_ANFAT01( ExpC1 )   					                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametr ³ ExpC1 = Origem dos arquivos XML: "E" = E-mail; "D" => Diretório        º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ Generico                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³   Data     ³ Motivo da Alteracao                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Robson Santos³ 08/05/2012 ³ Incluída opção para importar arquivos de um diretór º±±
±±º  Robson Santos³ 14/06/2012 ³ Adaptado para cliente Burti						 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/***************************************************************************************
* Ajustado parâmetro de número máximo de e-mails a baixar por execução da rotina.
* Robson Santos - Call System - 29/08/2012
***************************************************************************************/


User Function ANFAT01( PARAMIXB ) 

Local aEmpAtivas	:= {}
Local nRec 			:= 0     
Local _lProcSch 	:= Type( "oMainWnd" ) <> "O"  //Processo via Scheduller?   
Local _lCont        := .t.

Default PARAMIXB    := {}
                                
if _lProcSch   

	cOrig 	  := PARAMIXB[01]  
	cEmpLogin := PARAMIXB[02] 
	cFilLogin := PARAMIXB[03]
 
 	RpcClearEnv()	
	RpcSetType( 3 )
	
	PREPARE ENVIRONMENT EMPRESA cEmpLogin FILIAL cFilLogin MODULO "COM" TABLES "SF1","SD1","SA1","SA2","SB1","SB2","SF4", "UZQ"  
	SetModulo( "SIGACOM" , "COM" )     
	
Else  

	cOrig := PARAMIXB[01]
 
Endif   

_aExcEmp := SuperGetMV( "MV_XEXCEMP", .F., {} )

// Se o tipo do parâmetro for diferente de array, fixar array vazio  
if ValType(_aExcEmp) <> "A" 

	_aExcEmp := {} 
	
Else  

	_aExcEmp := &_aExcEmp
	

Endif        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega array com todas as filiais da Empresa corrente no sigamat.emp    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nRec := SM0->( Recno() )
DBSelectArea( "SM0" )
DBGotop()
Do While !Eof()    
 
	_lDesvEmp := .f.
	If SM0->M0_CODIGO == cEmpAnt    //Traz somente filiais da empresa corrente - Robson Santos - Call System - 19/06/2012 
	
   		if _nPos := aScan( _aExcEmp, { |x| Alltrim(x[02]) == Alltrim(SM0->M0_CCG) } ) > 0 
   		
   			if Alltrim(_aExcEmp[_nPos][01]) <> alltrim(SM0->M0_FILIAL)
   			
   				_lDesvEmp := .t.
   			
   			Endif
   		
   		Endif  
   		
   		if !_lDesvEmp
	
	   		aadd( aEmpAtivas, { SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CGC, SM0->M0_INSC } ) 
	   		
		Endif
			
	Endif
	DBSkip()
Enddo
DBGoTo( nRec )  

If cOrig == "E"     // Se deseja buscar dos e-mails

 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le os e-mails da Caixa Postal de NFE de todas as filiais e grava os      ³
	//³ arquivos XML em pastas para cada empresa/filial.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
	if _lProcSch    
	
		U_ANFAT01A( aEmpAtivas, , _lProcSch, cOrig  )
 
	Else
	
   		MsgRun( "Aguarde! Lendo e-mails...",,{|| U_ANFAT01A( aEmpAtivas, , _lProcSch, cOrig, @_lCont  ) } )  
   		
 	Endif

elseif cOrig == "D"     // Se deseja buscar de um diretório
	
	//--------------------------------------------------------------------------
	// Busca arquivos XML de NFe em determinado diretório, os valida e os grava
	// nas pastas correspondentes as cada empresa/filial.
	//--------------------------------------------------------------------------
	MsgRun( "Aguarde! Lendo arquivos...",,{|| U_dANFAT01A( aEmpAtivas, _lProcSch, cOrig, @_lCont ) } )

endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre os XML's baixados, Importa no Protheus, Valida na Sefaz e caso      ³
//³ estiver tudo correto, disponibiliza para geracao de Pre-Nota             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if _lProcSch .and._lCont
 
	U_ANFAT01B( aEmpAtivas, _lProcSch  ) 
	Reset Environment    
	  
ElseIf _lCont
	
	MsgRun( "Aguarde! Importando XML's baixados...",,{|| U_ANFAT01B( aEmpAtivas ) } )    
	
Endif

Return( Nil )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ ANFAT01A        ºAutor³ Antonio Marcos Andriani    º Data ³ 08/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Rotina para acessar a Caixa Postal da conta de email que recebe as     º±±
±±º         ³ Notas Fiscais de Entrada no formato XML. Os arquivos XML que estiverem º±±
±±º         ³ em anexo nas mensagens serao salvos nas pastas de sua respectiva       º±±
±±º         ³ empresa/filial, nas pasta 'Baixados'.                                  º±±
±±º         ³ Ex: '\system\xml_nfe\0101\baixados'                                    º±±
±±º         ³     '\system\xml_nfe\0102\baixados'                                    º±±
±±º         ³     '\system\xml_nfe\0201\baixados'                                    º±±
±±º         ³ Apos o processamento as mensagens serao deletadas.                     º±±
±±º         ³ Para gravacao do arquivo 'XML' na Pasta correta o XML e aberto e o     º±±
±±º         ³ CNPJ do destinatario verificado no sigamat.emp.                        º±±
±±º         ³                                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe  ³ ANFAT01A( ExpA1, ExpN2 )                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametr ³ ExpA1 = Array com os campos Empresa, Filial, CNPJ e Inscricao de       º±±
±±º         ³         todas as empresas cadastradas no sigamat.emp.                  º±±
±±º         ³ ExpN2 = Quantidade de Mensagens a serem lidas para cada execucao       º±±
±±º         ³                                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ Generico                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Robson Santos ³10/05/2012³ Converter nome dos anexos para minúsculas pois algumas
                               comparações são sensíveis (case sensitive)            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ANFAT01A( aEmpAtivas , nQtdMsgsLer, _lProcSch, cOrig , _lCont )

/***************************************************************************************
* Parâmtros MV específicos para Burti - Robson Santos - Call System - 14/06/2012
***************************************************************************************/
 
Local cServerPop	:= Alltrim( SuperGetMV( "MV_XSRVMAI", .F., "mail@server.com.br" ) )
Local cContaPOP		:= Alltrim( SuperGetMV( "MV_XUSRMAI", .F., "nfe-xml-totvs" ) )
Local cSenhaPop		:= Alltrim( SuperGetMV( "MV_XSENMAI", .F., "" ) )
Local nPortaPop		:= Val( Alltrim( SuperGetMV( "MV_XPORMAI", .F., "110" ) ) )
Local cExtArq		:= "xml"
Local _nQtdMsg		:= 0
Local cStartPath	:= GetSrvProfString( "Startpath", "" )
Local cRootPath		:= GetSrvProfString( "Rootpath", "" )
Local cPstXml		:= Alltrim( SuperGetMV( "MV_XPSTXML", .F.,  cStartPath + "\xml_nfe\" ) )    

Local cServerSMTP   := Alltrim( SuperGetMV( "MV_XSRVSMT", .F., "" ) )    	// smtp.gmail.com
Local lServerSeg    := SuperGetMV( "MV_XSRCSEG", .F., .f. )       			// comunicação segura  
Local lServerAut    := SuperGetMV( "MV_XSRVAUT", .F., .f. )    		   		// REQUER AUTENTICAÇÃO comunicação segura

//Local cPstXml		:= cStartPath + "xml_nfe" 
//Local cTempPath     := GetTempPath()
     // Para o método SaveAttach deve-se passar o caminho completo
Local cPstEmpFil	:= ""
Local cPstBaixad	:= ""
Local cPstImport	:= ""
Local cPstRejeit	:= ""
Local cPstLog		:= ""
Local cPstTemp		:= ""
Local cMsg			:= ""

Local nPosCodEmp	:= 1
Local nPosCodFil	:= 2
Local nPosCgc		:= 3
Local nPosInsc		:= 4

Local cCgcDest		:= ""
Local nFoundEmp 	:= 0

Local oServer
Local oMessage
Local oXml
Local lErro			:= .f.    // variável para não excluir e-mail caso ocorra erro. Robson Santos - Call System - 18/06/2012

Default nQtdMsgsLer	:= 50  

cPstXml   += if ( Right(alltrim(cPstXml),1) <> '\', '\', '' )  
cTempPath := cRootPath + cPstXML + '\temp\' 
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existem Pastas para todas as Empresas                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx := 1 to Len( aEmpAtivas )

	cPstEmpFil	:= cPstXml    + aEmpAtivas[ nx, nPosCodEmp ] + aEmpAtivas[ nx, nPosCodFil ] 
	cPstBaixad	:= cPstEmpFil + "\baixados"
	cPstImport	:= cPstEmpFil + "\importados"
	cPstRejeit	:= cPstEmpFil + "\rejeitados" 
	cPstLog		:= cPstEmpFil + "\log" 
	cPstTemp	:= cPstXml 	  + "temp"    
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as Pastas caso nao existam no servidor                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !ChecaPastas( cPstXml, cPstEmpFil, cPstBaixad, cPstImport, cPstRejeit, cPstLog, cPstTemp,_lProcSch  )
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia email de aviso sobre o erro                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAssunto	:= "ERRO - Rotina de Importação de Nota Fiscal formato XML"
		cMensagem	:= "Houve um erro na criação das Pastas necessárias para Importação dos arquivos XML's." + CRLF + CRLF
		cMensagem	+= "Foi tentado criar as seguintes Pastas:" + CRLF + CRLF
		cMensagem	+= cPstXml + CRLF		
		cMensagem	+= cPstEmpFil + CRLF		
		cMensagem	+= cPstBaixad + CRLF		
		cMensagem	+= cPstImport + CRLF		
		cMensagem	+= cPstRejeit + CRLF		
		cMensagem	+= cPstLog + CRLF		
		cMensagem	+= cPstTemp + CRLF + CRLF
		cMensagem	+= "Favor verificar o problema." 
	
		if !_lProcSch   
		
	   		Aviso(cAssunto, cMensagem, {"OK"})     
	   		
	 	Else  
	 	
	 		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia mensagem de erro para o console do server Protheus                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 		ConOut( "" )	
	   		ConOut( cAssunto )
	   		ConOut( cMensagem )
			ConOut( "" )	
	 		U__XmlEnvM(  cAssunto, cMensagem, {}, _lProcSch )  
	 		
	 	Endif
		
		Return( .F. )
		
	Endif

Next  
 
// Recebendo e-mails
u_Rjoba999( _lProcSch ) 

//Gravando arquivos da Pasta  
u_Danfat01a( aEmpAtivas, _lProcSch, cOrig , @_lCont )

Return( .T. )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ dANFAT01A       ºAutor³ Robson Pereira dos Santos  º Data ³ 08/05/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Uma adaptação da rotina ANFAT01A de Antonio M. Andriani.               º±±
±±º         ³ Rotina para buscar e salvar os arquivos XML de NFe de diretório        º±±
±±º         ³ determinado e salvá-los nas pastas de sua respectiva empresa/filial    º±±
±±º         ³ Ex: '\system\xml_nfe\0101\baixados'                                    º±±
±±º         ³     '\system\xml_nfe\0102\baixados'                                    º±±
±±º         ³     '\system\xml_nfe\0201\baixados'                                    º±±
±±º         ³ Apos o processamento os arquivos serao renomeados para não importá-los º±±
±±º         ³ novamente. Para gravacao do arquivo 'XML' na Pasta correta o XML e     º±±
±±º         ³ aberto e o CNPJ do destinatario verificado no sigamat.emp.             º±±
±±º         ³                                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe  ³ dANFAT01A( ExpA1 )                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametr ³ ExpA1 = Array com os campos Empresa, Filial, CNPJ e Inscricao de       º±±
±±º         ³         todas as empresas cadastradas no sigamat.emp.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ Generico                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ³         ³                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function dANFAT01A( aEmpAtivas, _lProcSch, cOrig, _lCont )

Local cExtArq		:= "xml"
Local cStartPath	:= GetSrvProfString( "Startpath", "" )
Local cRootPath		:= GetSrvProfString( "Rootpath", "" )
Local cPstXml		:= Alltrim( SuperGetMV( "MV_XPSTXML", .F.,  cStartPath + "J" ) )  
Local cConta 		:= Alltrim( SuperGetMV( "MV_XUSRMAI", .F., "" ) )
Local cPstEmpFil	:= ""
Local cPstBaixad	:= ""
Local cPstImport	:= ""
Local cPstRejeit	:= ""
Local cPstLog		:= ""
Local cPstTemp		:= ""

Local nPosCodEmp	:= 1
Local nPosCodFil	:= 2
Local nPosCgc		:= 3
Local nPosInsc		:= 4

Local cCgcDest		:= ""
Local nFoundEmp 	:= 0
Local cMsg			:= ""

Local oXml      

Default _lProcSch := .f.  

cPstXml += if ( Right(alltrim(cPstXml),1) <> '\', '\', '' )  
cXMLPath := cRootPath + cPstXML + 'temp\' 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existem Pastas para todas as Empresas                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx := 1 to Len( aEmpAtivas )

	cPstEmpFil	:= cPstXml + aEmpAtivas[ nx, nPosCodEmp ] + aEmpAtivas[ nx, nPosCodFil ] 
	cPstBaixad	:= cPstEmpFil + "\baixados"
	cPstImport	:= cPstEmpFil + "\importados"
	cPstRejeit	:= cPstEmpFil + "\rejeitados" 
	cPstLog		:= cPstEmpFil + "\log" 
	cPstTemp	:= cPstXml 	  + "temp"  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as Pastas caso nao existam no servidor                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !ChecaPastas( cPstXml, cPstEmpFil, cPstBaixad, cPstImport, cPstRejeit, cPstLog, cPstTemp  )
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia mensagem de erro para o console do server Protheus                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAssunto	:= "ERRO - Rotina de Importação de Nota Fiscal formato XML"
		cMensagem	:= "Houve um erro na criação das Pastas necessárias para Importação dos arquivos XML's." + CRLF + CRLF
		cMensagem	+= "Foi tentado criar as seguintes Pastas:" + CRLF + CRLF
		cMensagem	+= cPstXml + CRLF		
		cMensagem	+= cPstEmpFil + CRLF		
		cMensagem	+= cPstBaixad + CRLF		
		cMensagem	+= cPstImport + CRLF		
		cMensagem	+= cPstRejeit + CRLF		
		cMensagem	+= cPstLog + CRLF		
		cMensagem	+= cPstTemp + CRLF + CRLF
		cMensagem	+= "Favor verificar o problema."   
		
		if !_lProcSch   
		
	   		Aviso(cAssunto, cMensagem, {"OK"})     
	   		
	 	Else 
	 	
	 		ConOut( "" )	
	   		ConOut( cAssunto )
	   		ConOut( cMensagem )
			ConOut( "" )	
	 		U__XmlEnvM(  cAssunto, cMensagem, {}, _lProcSch )  
	 		
	 	Endif 
	 	
	 	Return .f.
		
	Endif

Next
 
oXml := Nil 

if !_lProcSch .and.cOrig <> 'E' 

	// Apresenta tela para usuário selecionar o diretório que contém os arquivos XML - Robson Santos - Call System - 22/06/2012
	cXMLPath := cGetFile( '*.xml' , 'Arquivos XML de NF-e e/ou CT-e', 1, cXMLPath, .F., nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE, GETF_RETDIRECTORY ),.T., .T. )
	
	// Se cancelou a operação não permitir importação
	If !Empty(cXMLPath)  
	 
	 	cXMLPath += if ( Right(alltrim(cXMLPath),1) <> '\', '\', '' ) 
	 	
	 Else 
	 
	 	cXMLPath := "//" 
		
	 Endif 
	
Else  

	if _lProcSch  

		// Lendo da pasta baixas de e-mail 
		cXMLPath :=  cPstXML + 'temp\'   
		
	Else
	
		cXMLPath := cRootPath + cPstXML + 'temp\' 
		
	Endif

Endif     

// Retorna lista de arquivos .xml no diretório selecionado
// aArqs => Posição 1-cNome (Nome do arquivo), 2-cTamanho , 3-dData, 4-cHora, 5-cAtrubutos 
aArqs := DIRECTORY( cXMLPath + "*.xml", "D" )      
 
If Len(aArqs) == 0  

	_lCont := .f.
 
	if !_lProcSch   
	
		if cOrig == 'D' 
		
			if !empty(cXMLPath)    
	
    			Aviso("Atenção!", "Nenhum arquivo .XML encontrado no local " + cXMLPath, {"OK"})   
    			
 			Endif
    		
 		Else  
 		
 			Aviso("Atenção!", "Nenhum anexo(XML) disponível para download na conta de e-mail: " + cConta, {"OK"}) 
 		
 		Endif
    	
 	Else  
 	
 		ConOut( "Atenção!", "Nenhum anexo(XML) disponível para download na conta de e-mail: " + cConta )
 	 
 	Endif    
 	
Endif
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Le todos os arquivos no diretório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nArqs := 1 to len(aArqs)
 
	//Converte nome do arquivo para minúsculas
	aArqs[nArqs, 1] := Lower(aArqs[nArqs, 1])
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera somente os arquivos com extensao XML                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !( ( cExtArq $ aArqs[nArqs,1] ) .and. Right( aArqs[nArqs,1], 4 ) == "." + cExtArq ) .or. ;
		 ( Left( aArqs[nArqs,1], 3 ) == "ok_" )
		Loop
	Endif 
	
	if !_lProcSch 
	
		#IFDEFTOP 
	
			// Verificando se o arquivo já foi importado !
		 	_cAlias := GetNextAlias() 
	 		_cSeqXML:= "%'%" + aArqs[nArqs, 1] + "%'%"
	        
	        BEGINSQL ALIAS _cAlias  
	        %noParser%
	                  	
		        SELECT
		   			COUNT(1) QTDXML
		      	FROM
		       		%table:UZQ% UZQ
		       	WHERE
		       		UZQ.%notDel%     
					AND UZQ_LOCARQ LIKE %exp:_cSeqXML%  
	   
	   		ENDSQL
	    
	   		//cLastQuery    := aLastQuery[2] 
	     	(_cAlias)->( DbGotop() )   
	     	_lEncArq := (_cAlias)->(QTDXML) > 0 
	     	(_cAlias)->( dbCloseArea() )  
	    
	    #ELSE   
	    	 
 			DbSelectArea("UZQ")                                             
    		DbSetOrder(4)

      		_lEncArq := DbSeek( xFilial("UZQ") + Padr( cPstXML + cempant + cfilant + '\importados\' + Upper(aArqs[nArqs, 1]), TamSX3("UZQ_LOCARQ")[01]  ) )
                                                                                                    		
	    #ENDIF    
	         		
      	if _lEncArq
      	
      		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia mensagem de erro para o console do server Protheus                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cAssunto	:= "Advertência - Rotina de Importação de Nota Fiscal formato XML"
			cMensagem	:= "O arquivo selecionado: " + aArqs[nArqs, 1] + CRLF 
			cMensagem	+= "já foi importado, caso necessite de uma nova importação, apague a Nf/e  " + CRLF  
			cMensagem	+= "gerada e sua referência na Importação do xml e importe o mesmo novamente ! "  + CRLF   
	 
	 		Aviso( cAssunto, cMensagem, {"OK"})   
		 	
		 	_lCont := .t.
		 	
		 	if len(aArqs) > 2
		 	
		 		_lCont := MsgYesno( "Existem mais arquivos XML disponíveis na pasta, deseja continuar ?" )	 
		 		
		 	Endif 
		 	
		 	if _lCont
		 		
	        	Loop  
	        	
	    	Else 
	    	
	    		Exit
	    	
	    	Endif
      	
      	Endif
       	
       	if !alltrim(cPstTemp) $ cXMLPath		

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Copia o arquivo para uma pasta temporaria no server.                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !CpyT2S( cXMLPath + aArqs[nArqs,1], cPstTemp + '\' , .T. )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envia mensagem de erro para o console do server Protheus                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cAssunto	:= "ERRO - Rotina de Importação de Nota Fiscal formato XML"
				cMensagem	:= "Houve uma falha na tentativa de copiar o arquivo: "  + aArqs[nArqs,1] + CRLF 
				cMensagem	+= "da pasta de origem para uma pasta temporaria no Server." + CRLF  
				cMensagem	+= "Favor verificar o problema."   
				
			 	Aviso( cAssunto, cMensagem, {"OK"})	 	
		        Loop
			
			Endif  
			
		Endif
			
	Endif 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega arquivo XML no objeto oXML para leitura do CNPJ. Atraves do CNPJ   ³
	//³ e possivel saber de que empresa/filial pertence a Nota Fiscal de Entrada   ³
	//³ e o arquivo e copiado na pasta da empresa/filial correta.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
	oXml := U_LerXml( cPstTemp + '\' + aArqs[nArqs,1], @cMsg ) 
	
	If !( ValType(oXml) == "O" ) .or. !Empty( cMsg )
	  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia mensagem de erro para o console do server Protheus                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAssunto	:= "ERRO - Rotina de Importação de Nota Fiscal formato XML"
		cMensagem	:= "Houve uma falha na tentativa de leitura do arquivo XML: "  + aArqs[nArqs,1]  + CRLF 
		cMensagem	+= "Provavelmente existe um erro na estrutura do arquivo." + CRLF  
		cMensagem	+= "Favor verificar o problema com o Fornecedor!"  
		
		if !_lProcSch	  
		
        	Aviso( cAssunto, cMensagem, {"OK"})  
        	
  		Else
  		
  	 		ConOut( "" )	
	   		ConOut( cAssunto )
	   		ConOut( cMensagem )
			ConOut( "" )
        
        	u__XmlEnvM(  cAssunto, cMensagem, {}, _lProcSch  ) 
  					
  		Endif
        
		Loop
				  
   Endif  
   
   // Efetuando leitura em baixo nível pois valtype, type ( nó xml ) estava com problemas na validação
   _cFile   := cXMLPath + aArqs[nArqs,1]
   _cArqXML := MemoRead ( _cFile )  
 
   // NFE ou CTE   
   if !( '<nfeProc' $ _cArqXML .and. '<dest>' $ _cArqXML ) .and.  !( '<cteProc' $ _cArqXML .and. '<emit>' $ _cArqXML ) 
   
 		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia mensagem de erro para o console do server Protheus                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAssunto	:= "ERRO - Rotina de Importação de Nota Fiscal formato XML"
		cMensagem	:= "Houve uma falha na tentativa de leitura do arquivo XML: "  + aArqs[nArqs,1]  + CRLF 
		cMensagem	+= "na TAG do CNPJ. Provavelmente existe um erro na estrutura do arquivo." + CRLF 
		cMensagem	+= "Favor verificar o problema com o Fornecedor!"  
		
		if !_lProcSch   
		
        	Aviso( cAssunto, cMensagem, {"OK"}) 
        	
        Else 
        
        	ConOut( "" )	
	   		ConOut( cAssunto )
	   		ConOut( cMensagem )
			ConOut( "" )
        
        	u__XmlEnvM(  cAssunto, cMensagem, {}, _lProcSch  ) 
        	
  		Endif
        
		Loop

	Endif
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o CNPJ do XML e de qual empresa/filial pertence e copia o XML   ³
	//³ na pasta 'baixados' de sua empresa/filial.                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	// Verificando se é cte ou nfe     
	if '<nfeProc' $ _cArqXML
	
 		cCgcDest := OXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT 
 		cCgcRem  :=	Padr( Alltrim( oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT ), TamSX3("A1_CGC")[1], " " )
 		
 	Else 
 	
 		cCgcDest := SM0->M0_CGC 
 		cCgcRem  := Padr( Alltrim( OXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT ), TamSX3("A1_CGC")[1], " " )    
 	
 	Endif 
 	
 	// Localizando o Fornecedor
 	_lEncRem := .f.   
 	dbselectArea("SA2")
 	dbSetOrder(3) //Filial+CGCdbSeek(xFilial("SA2")+SA2->A2_CGC)
 	
 	if _lEncRem := dbSeek( xFilial("SA2") + cCgcRem )  
 	
 		_lEncRem := SA2->A2_MSBLQL <> '1'
 	
 	Endif 
 	
 	// Não encontrado ou bloqueado
 	if !_lEncRem 
 		
   		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia mensagem de erro para o console do server Protheus                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAssunto	:= "ERRO - Rotina de Importação de Nota Fiscal formato XML"
		cMensagem	:= "O CNPJ do Remetente não consta no cadastro de Fornecedores ou"  + CRLF 
		cMensagem	+= "o mesmo encontra-se bloqueado. " + CRLF + CRLF
		cMensagem	+= "O arquivo em anexo foi desconsiderado!"    
		
	 	if !_lProcSch   
	 	
        	Aviso( cAssunto, cMensagem, {"OK"})  
        	
   		Else
   		
        	ConOut( "" )	
	   		ConOut( cAssunto )
	   		ConOut( cMensagem )
			ConOut( "" )
        
        	u__XmlEnvM(  cAssunto, cMensagem, {}, _lProcSch  ) 
   			
  		Endif 
  		
  		Loop

    Endif    
 	
	If ( nFoundEmp := aScan( aEmpAtivas, { |x| Alltrim(Upper(x[nPosCgc])) == cCgcDest } ) ) == 0 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia mensagem de erro para o console do server Protheus                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAssunto	:= "ERRO - Rotina de Importação de Nota Fiscal formato XML"
		cMensagem	:= "O CNPJ do destinario não consta na lista de empresas/filiais"  + CRLF 
		//cMensagem	+= "do sigamat Andra. " + CRLF + CRLF
		cMensagem	+= "O arquivo em anexo foi desconsiderado!"    
		
	 	if !_lProcSch   
	 	
        	Aviso( cAssunto, cMensagem, {"OK"})  
        	
   		Else
   		
        	ConOut( "" )	
	   		ConOut( cAssunto )
	   		ConOut( cMensagem )
			ConOut( "" )
        
        	u__XmlEnvM(  cAssunto, cMensagem, {}, _lProcSch  ) 
   			
  		Endif
        
		Loop
	
	Endif
		
	cPstBaixad := cPstXml + "\" + aEmpAtivas[ nFoundEmp, nPosCodEmp ] + aEmpAtivas[ nFoundEmp, nPosCodFil ] + "\baixados"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ A funcao __CopyFile eh usada para copias de arquivos entre as pastas     ³
	//³ dentro da 'AP_DATA' do Protheus.                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !__CopyFile( cPstTemp + "\" + aArqs[nArqs,1], cPstBaixad + "\" + aArqs[nArqs,1] )
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia mensagem de erro para o console do server Protheus                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAssunto	:= "ERRO - Rotina de Importação de Nota Fiscal formato XML"
		cMensagem	:= "Houve uma falha na tentativa de copia do arquivo XML: "  + aArqs[nArqs,1]  + CRLF 
		cMensagem	+= ", da Pasta " + cPstTemp + " para a pasta " + cPstBaixad + "." + CRLF 
		cMensagem	+= "Favor verificar o problema com o Fornecedor!"  
		
	 	if !_lProcSch    
	 	
	   		Aviso( cAssunto, cMensagem, {"OK"})
	   		
	 	Else
	 	
	  		ConOut( "" )	
	   		ConOut( cAssunto )
	   		ConOut( cMensagem )
			ConOut( "" )
        	u__XmlEnvM(  cAssunto, cMensagem, {}, _lProcSch  ) 
	   		                                                                                                                   
	 	Endif
        
	Endif
					
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga o arquivo XML da pasta Temporaria no SERVER / tEMPORÁRIOS          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fErase( cPstTemp + "\" + aArqs[nArqs,1] )    
	
	_aArqTmp := DIRECTORY( cXMLPath + "*.tmp", "D" )      
 
	For _i := 1 to len(_aArqTmp)  
	
		fErase( cXMLPath + _aArqTmp[_i,1] ) 
	
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Renomeia arquivos importados na pasta original para não importar novamente. Somente nos Casos do Diretório ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cOrig == 'D'    
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Renomeia arquivos importados na pasta original para não importar novamente.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(FRename( cXMLPath + aArqs[nArqs,1], cXMLPath + "ok_" + aArqs[nArqs,1]) == 0 )
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   		//³ Envia mensagem de erro para o console do server Protheus                 ³
	   		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cAssunto	:= "ERRO - Rotina de Importação de Nota Fiscal formato XML"
			cMensagem	:= "Houve uma falha na tentativa de renomear o arquivo original: " + aArqs[nArqs,1]  + CRLF + CRLF
			cMensagem	+= "Favor verificar!"
		 
			if !_lProcSch	
		
        		Aviso( cAssunto, cMensagem, {"OK"})	  
        	
  			Else
  		
  		   		ConOut( "" )	
	   			ConOut( cAssunto )
	   			ConOut( cMensagem )
				ConOut( "" )
        
           		u__XmlEnvM(  cAssunto, cMensagem, {}, _lProcSch  ) 
        	
  	   		Endif 
  	   		
  	 	Endif
        
	endif
		
Next
	
Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ ANFAT01B        ºAutor³ Antonio Marcos Andriani    º Data ³ 10/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Rotina para Ler o arquivo XML e efetuar a gravacao na Tabela  de       º±±
±±º         ³ Cadastro de XML ( UZQ ).                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe  ³ ANFAT01B()                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ Generico                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ³         ³                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ANFAT01B( aEmpAtivas, _lProcSch )

	Local cMailResp 	:= Alltrim( SuperGetMV( "MV_XMAILRE", .F., "nfe-xml-totvs@call.com.br" ) )
	Local cStartPath	:= GetSrvProfString( "Startpath", "" )  
	
	Local cAccountE	:= Alltrim( SuperGetMV( "MV_XUSRMAI", .F., "" ) )
	Local cAccountR := Alltrim( SuperGetMV( "MV_XMAILRE", .F., " " ) )  
	Local cPassword	:= Alltrim( SuperGetMV( "MV_XSENMAI", .F., " " ) )                           
	Local cServer	:= Alltrim( SuperGetMV( "MV_XSRVSMT", .F., " " ) )
	Local cUserAut	:= Alltrim( SuperGetMV( "MV_XUSRMAI", .F., " " ) )             
	Local cPassAut	:= Alltrim( SuperGetMV( "MV_XSENMAI", .F., " " ) )  
	Local lServAut  := SuperGetMV( "MV_XSMTAUT", .F., .F. ) 
	Local lUsaTSS	:= SuperGetMV( "MV_XSRCSEG", .F., .F. )
	Local nPortaSmtp:= SuperGetMV( "MV_XPORSMT", .F., 25 )   
	Local nTimeOut  := SuperGetMV( "MV_XTIMEOU", .F., 60 ) 
	Local cUserNotif:= SuperGetMV( "MV_XUSNOTIF", .F., 60 )

	Local cPstXml		:= Alltrim( SuperGetMV( "MV_XPSTXML", .F.,  cStartPath + "\xml_nfe" ) )  
	Local lZeraEsq      := SuperGetMV( "MV_XZERAE", .F.,  .T. )
	Local cPstEmpFil	:= ""  //cNumEmp
	Local cPstBaixad	:= ""  //cPstXml + "\" + cPstEmpFil + "\baixados"
	Local cPstImport	:= ""  //cPstXml + "\" + cPstEmpFil + "\importados"
	Local cPstRejeit	:= ""  //cPstXml + "\" + cPstEmpFil + "\rejeitados"
	Local cPstLog		:= ""  //cPstXml + "\" + cPstEmpFil + "\log"
	Local nx			:= 0
	Local cMsg			:= ""
	Local oXml

	Local nPosCodEmp	:= 1
	Local nPosCodFil	:= 2
	
	cEmpBack := cEmpAnt
	cFilBack := cFilAnt 
	
	cPstXml += if ( Right(alltrim(cPstXml),1) <> '\', '\', '' )  
 
	/*****************************************************************************************
	* Alterado para considerar todas as filiais ativas e não somente a filial em execução
	* Robson Santos - Call System - 19/06/2012
	*****************************************************************************************/
	For xx := 1 to Len( aEmpAtivas )

		cPstEmpFil	:= cPstXml    + aEmpAtivas[ xx, nPosCodEmp ] + aEmpAtivas[ xx, nPosCodFil ] 
		cPstBaixad	:= cPstEmpFil + "\baixados"
		cPstImport	:= cPstEmpFil + "\importados"
		cPstRejeit	:= cPstEmpFil + "\rejeitados" 
		cPstLog		:= cPstEmpFil + "\log" 
		cPstTemp	:= cPstXml    + "temp" 

		aXmlImp := DIRECTORY( cPstBaixad + "\*.xml", "D" )
  
		For nx := 1 to Len( aXmlImp )

			cMsg	:= ""
			oXml 	:= U_LerXml( cPstBaixad + "\" + Lower( aXmlImp[ nx, 1 ] ), @cMsg )  
			_lGrav  := .f.
			If !( ValType(oXml) == "O" ) .or. !Empty( cMsg ) 
			
				if _lProcSch    
				
					Canout( "Erro no objeto XML!!!" )
				
				Else
					Alert( "Erro no objeto XML!!!" )   
					
				Endif     
				Loop  
				                                                        
			Endif 
			
			_cArqXML := MemoRead ( cPstBaixad + "\" + Lower( aXmlImp[ nx, 1 ]  ) )
			cMsg	 := "Teste msg ponteiro"	 
			cXml 	 := RetContArq( cPstBaixad + "\" + Lower( aXmlImp[ nx, 1 ] ) )
			dDtRecXml:= dDataBase 
			cStatus  := ''	   
			
			// NFE
			if '<nfeProc' $ _cArqXML	   
				
				cNota		:= PadR( Alltrim( oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT ), TamSX3("UZQ_DOC")[1], " " )
				cSerie		:= PadR( oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text, TamSX3("UZQ_SERIE")[1], " " )
				dDataNfe	:= Stod( StrTran( oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dEmi:Text, "-", "" ) ) 
				cCnpjEmi	:= Padr( Alltrim( oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT ), TamSX3("UZQ_CNPJEM")[1], " " )
				cRazaoEmi	:= Alltrim( oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT )
				cCnpjDest	:= Alltrim( oXml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT )
				cChaveNfe	:= Padr( Alltrim( oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT ), TamSX3("UZQ_CHVNFE")[1], " " )
				cProtocolo	:= oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT  
				cTipoNF		:= 'NFE' 
			   //	_cPedido    := ' ' // Pedido de venda
				
				// Valida o valor caso exista pedido  
				// Em estando diferente gravar com este status.
			 //	cStatus := '5'   
				
				// Envio de Notificação da ocorrência em caso erro pedido
			   	// 	U_EnvNot ( cServer, cUserAut, cPassAut, cUserNotif,  _cAssunto,  _cMensagem , _cAnexos )   
			  //	 	U__XmlEnvM(  _cAssunto, _cMensagem, {}, _lProcSch )  
			
			// CTE	
			ElseIf '<cteProc' $ _cArqXML
        	
        		cNota		:= PadR( Alltrim( OXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT ), TamSX3("UZQ_DOC")[1], " " )
				cSerie		:= PadR( OXML:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:TEXT, TamSX3("UZQ_SERIE")[1], " " )					
				dDataNfe	:= Stod( StrTran( OXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT, "-", "" ) ) 
				cCnpjEmi	:= Padr( Alltrim( OXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT ), TamSX3("UZQ_CNPJEM")[1], " " )
				cRazaoEmi	:= Alltrim( OXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME:TEXT )
				cCnpjDest	:= Alltrim( SM0->M0_CGC )
				cChaveNfe	:= Padr( Alltrim( OXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT ), TamSX3("UZQ_CHVNFE")[1], " " )
				cProtocolo	:= OXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT 
				cTipoNF		:= 'CTE'
        			
        	Endif  
        	
        	_nRet := 100   
        	
        	If .F. //IsReady() 
          
  	   			_nRet := ConsNFeChave( cProtocolo, GetIdEnt() )  
  	   	 	
  	   	 	Endif
            
            //verifica se preenche com zeros a esquerda o numero da nota fiscal de entrada
            if lZeraEsq
               cNota:= strzero(val(cNota),TamSX3("UZQ_DOC")[1])
            endif
            
   			// Gravando o Status do Sefaz ref. a Chave NFE, se -1 não foi possível conectar, abortar a inclusão
   			if empty(cStatus)
   			
	            if  _nRet == 100  
	            
	            	cStatus := "1"  
	            	
	            ElseIF _nRet > 0 
	            
	             	cStatus := "4"               
	             
	   			Endif 
	   			
	   		Endif
	   		
	   		// Incluir somente se houver conexão com Sefaz  
   			if _nRet > 0   
   			
   				_lEncRem := .f.   
   				dbselectArea("SA2")
 				dbSetOrder(3) //Filial+CGCdbSeek(xFilial("SA2")+SA2->A2_CGC)
 		
 		   		if _lEncRem := dbSeek( xFilial("SA2") + cCnpjEmi )   
 	
 					_lEncRem := SA2->A2_MSBLQL <> '1'
 	
   				Endif     
   				
   				// Vefificando se a NF existe  ]
	   			DbSelectArea('SF1')
				SF1->( dbSetOrder( 1 ) )
				_lNFEmit   := SF1->( dbSeek( aEmpAtivas[ xx, nPosCodFil ]  + cNota + cSerie + SA2->A2_COD + SA2->A2_LOJA + "N" ) )  
				
	   			cPstEmpFil := cPstXml + aEmpAtivas[ xx, nPosCodEmp ] + aEmpAtivas[ xx, nPosCodFil ] + "\importados\"
			   
				dbselectArea("UZQ")
				UZQ->( dbSetOrder( 2 ) )
				//If UZQ->( !dbSeek( xFilial( "UZQ" ) + cCnpjEmi + cNota + cSerie + cChaveNfe ) )
				If UZQ->( !dbSeek( aEmpAtivas[ xx, nPosCodFil ] + cCnpjEmi + cNota + cSerie + cChaveNfe ) ) 
				
					RecLock( "UZQ", .T. )   
					
						UZQ_FILIAL	:= aEmpAtivas[ xx, nPosCodFil ]   //xFilial( "UZQ" )
						UZQ_DOC		:= cNota
						UZQ_SERIE	:= cSerie
						UZQ_DTRECX	:= dDataNfe
						UZQ_DTNF	:= dDtRecXml
						UZQ_CNPJEM	:= cCnpjEmi
						UZQ_RAZAO	:= cRazaoEmi
						UZQ_CNPJDE	:= cCnpjDest
						UZQ_FILDES	:= aEmpAtivas[ xx, nPosCodFil ]   //xFilial( "UZQ" )
						UZQ_CHVNFE	:= cChaveNfe
						UZQ_XML		:= cXml
						UZQ_OBS		:= cMsg
						UZQ_LOCARQ	:= cPstEmpFil + Upper( aXmlImp[ nx, 1 ] )
						UZQ_STATUS	:= if ( _lNFEmit, '3', cStatus )
				   		UZQ_TIPO 	:= cTipoNF 
				   		
				   		if _lEncRem
				   		
				   			UZQ_CODFOR	:= SA2->A2_COD
							UZQ_LOJFOR	:= SA2->A2_LOJA 
							
						Endif
						
					MsUnLock()  
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ A funcao __CopyFile eh usada para copias de arquivos entre as pastas     ³
			   		//³ dentro da 'AP_DATA' do Protheus.                                         ³
			   		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   		If !__CopyFile( cPstBaixad + "\" + Lower( aXmlImp[ nx, 1 ] ), cPstImport + "\" + Lower( aXmlImp[ nx, 1 ] ) )
				
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Envia email de aviso sobre o erro                                        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cAssunto	:= "ERRO - Rotina de Importação de Nota Fiscal formato XML"
						cMensagem	:= "Houve uma falha na tentativa de copia do arquivo XML em anexo, "  + CRLF 
						cMensagem	+= "da Pasta " + cPstBaixad + " para a pasta " + cPstImport + CRLF 
						cMensagem	+= "apos a importação do arquivo para o Protheus." + CRLF + CRLF 
						cMensagem	+= "Favor verificar o problema com o Fornecedor!"
						//u__XmlEnvM( cMailResp, cAssunto, cMensagem, { cPstBaixad + "\" + Lower( aXmlImp[ nx, 1 ] ) }  ) 
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Envia mensagem de erro para o console do server Protheus                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		 				if !_lProcSch 
						
							Aviso(cAssunto, cMensagem, {"OK"})  
							
						Else
						
							ConOut( "" )	
			   	   			ConOut( cAssunto )
			   				ConOut( cMensagem )
					   		ConOut( "" )
		        
		        	   		u__XmlEnvM(  cAssunto, cMensagem, {}, _lProcSch  ) 
							
						Endif  
						
					Endif
									
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Apaga o arquivo XML da pasta Temporaria no SERVER                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				fErase( cPstBaixad + "\" + Lower( aXmlImp[ nx, 1 ] ) )     
				
			Else  
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envia email de aviso sobre o erro - Indisponibilidade do Sefaz           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cAssunto	:= "ERRO - Rotina de Importação de Nota Fiscal formato XML"  
				
				cMensagem	:= "Houve uma falha na tentativa de conexão com o Sefaz para verificar "  + CRLF 
				cMensagem	+= "o status do anexo XML: " + Lower( aXmlImp[ nx, 1 ] ) + CRLF 
				cMensagem	+= ", tente novamente mais tarde ! "  + CRLF  
				
				if !_lProcSch  
				
					Aviso(cAssunto, cMensagem, {"E r r o"} )  
						
				Else
			 
			 		u__XmlEnvM(  cAssunto, cMensagem, {}, _lProcSch  )   
			 		
				Endif
			
			Endif
	
		Next nx      
		
	Next xx
	
Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ ChecaPastas     ºAutor³ Antonio Marcos Andriani    º Data ³ 10/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Rotina para verificar a existencia das pastas de arquivos necessarias  º±±
±±º         ³ para gravacao dos arquivos XML's da rotina de Importacao.              º±±
±±º         ³ Caso as pastas nao existam, serao criadas.                             º±±
±±º         ³                                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe  ³ ChecaPastas( ExpC1, ExpC2, ExpC3, ExpC4, ExpC5, ExpC6, ExpC7 )         º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametr ³ ExpC1 = Pasta principal onde serao gravados os arquivos XML's.         º±±
±±º         ³ ExpC2 = Pasta posterior a ExpC1 e que indica a Empresa/Filial          º±±
±±º         ³ ExpC3 = Pasta de XML's baixados e pertence as pastas \ExpC1\ExpC2      º±±
±±º         ³ ExpC4 = Pasta de XML's importados e  pertence as pastas \ExpC1\ExpC2   º±±
±±º         ³ ExpC5 = Pasta de XML's rejeitados e pertence as pastas \ExpC1\ExpC2    º±±
±±º         ³ ExpC6 = Pasta de LOG dos XML's e pertence as pastas \ExpC1\ExpC2       º±±
±±º         ³ ExpC7 = Pasta Temporaria dos XML's. Pertence a pasta \ExpC1            º±±
±±º         ³                                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ Generico                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ³         ³                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ChecaPastas( cPstXml, cPstEmpFil, cPstBaixad, cPstImport, cPstRejeit, cPstLog, cPstTemp, _lProcSch  )
Local lRet 	:= .T.

If !ExistDir( cPstXml )  
	
	If MakeDir( cPstXml ) != 0       
	
		if _lProcSch 
			
			ConOut( "Não foi possível criar a pasta '" + cPstXml + "'. Favor verificar permissão do usuário!!!"  )
			
		Else
		 
			Alert( "Não foi possível criar a pasta '" + cPstXml + "'. Favor verificar permissão do usuário!!!" ) 
		Endif    
		
		lRet := .F. 
	Endif
Endif

If !ExistDir( cPstEmpFil ) 	  

	If MakeDir( cPstEmpFil ) != 0   
		if _lProcSch
			ConOut(	"Não foi possível criar a pasta '" + cPstEmpFil + "'. Favor verificar permissão do usuário!!!" ) 
		Else
			Alert( "Não foi possível criar a pasta '" + cPstEmpFil + "'. Favor verificar permissão do usuário!!!" ) 
		ENdif
		lRet := .F. 
	Endif
Endif

If !ExistDir( cPstBaixad ) 
	
	If MakeDir( cPstBaixad ) != 0    
		if _lProcSch  
			ConOut(	"Não foi possível criar a pasta '" + cPstBaixad + "'. Favor verificar permissão do usuário!!!" ) 
		Else
			Alert( "Não foi possível criar a pasta '" + cPstBaixad + "'. Favor verificar permissão do usuário!!!" ) 
		Endif
		lRet := .F. 
	Endif
Endif

If !ExistDir( cPstImport ) 	  

	If MakeDir( cPstImport ) != 0  
		if _lProcSch  
			ConOut(	"Não foi possível criar a pasta '" + cPstImport + "'. Favor verificar permissão do usuário!!!" )
		Else 
			Alert( "Não foi possível criar a pasta '" + cPstImport + "'. Favor verificar permissão do usuário!!!" )
		Endif
		
		lRet := .F. 
	Endif
Endif

If !ExistDir( cPstRejeit ) 	 

	If MakeDir( cPstRejeit ) != 0  
		if _lProcSch 
			ConOut("Não foi possível criar a pasta '" + cPstRejeit + "'. Favor verificar permissão do usuário!!!" )
		Else
			Alert( "Não foi possível criar a pasta '" + cPstRejeit + "'. Favor verificar permissão do usuário!!!" )
		Endif
		lRet := .F. 
	Endif
Endif

If !ExistDir( cPstLog ) 	

	If MakeDir( cPstLog ) != 0  
		if _lProcSch   
			ConOut("Não foi possível criar a pasta '" + cPstLog + "'. Favor verificar permissão do usuário!!!" )
		Else
			Alert( "Não foi possível criar a pasta '" + cPstLog + "'. Favor verificar permissão do usuário!!!" )
		Endif
		lRet := .F. 
	Endif
Endif

If !ExistDir( cPstTemp ) 	

	If MakeDir( cPstTemp ) != 0  
		if _lProcSch  
		
			ConOut("Não foi possível criar a pasta '" + cPstTemp + "'. Favor verificar permissão do usuário!!!" ) 
		Else
		
	   		Alert( "Não foi possível criar a pasta '" + cPstTemp + "'. Favor verificar permissão do usuário!!!" ) 
	   		
	 	Endif
		lRet := .F. 
	Endif
Endif

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ ConsultaNf      ºAutor³ Antonio Marcos Andriani    º Data ³ 03/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Consulta situacao da Nota Fiscal no SEFAZ                              º±±
±±º         ³                                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe  ³ ConsultaNf( ExpC1, ExpC2 )                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametr ³ ExpC1 =                                                                º±±
±±º         ³ ExpC2 =                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ Generico                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ³         ³                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ConsultaNf( cProtID, cMensagem )
Local cURL     	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cIdEnt 	:= GetIdEnt()

ProcConsNF( cURL, cIdEnt, cProtID, @cMensagem )

Return( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GetIdEnt  ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
±±³          ³Service                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetIdEnt() 

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"
	
oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM		
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15)) 
DBSELECTAREA("SX6")
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{'Erro'},3)
EndIf

RestArea(aArea)    

Return(cIdEnt)

RestArea(aArea)
Return(cIdEnt)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ProcConsNF³ Autor ³Gustavo G. Rueda       ³ Data ³17.03.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que apresenta o posicionamento da SEFAZ referente a ³±±
±±³          ³ um determinado documento fiscal.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcConsNF(cURL,cIdEnt,cProtID, cMensagem )
Local oWS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If !Empty(cIdEnt)

	oWs:= WsNFeSBra():New()
	oWs:cUserToken   := "TOTVS"
	oWs:cID_ENT      := cIdEnt
	oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"
	oWs:cNFECONSULTAPROTOCOLOID := cProtID
	If oWs:ConsultaProtocoloNfe()
		cMensagem := ""
		If !Empty(oWs:oWSCONSULTAPROTOCOLONFERESULT:cVERSAO)
			cMensagem += "Versão: "+oWs:oWSCONSULTAPROTOCOLONFERESULT:cVERSAO+CRLF	
		EndIf
		cMensagem += " Ambiente: "+IIf(oWs:oWSCONSULTAPROTOCOLONFERESULT:nAMBIENTE==1,"Produção","Homologação")+CRLF
		cMensagem += " Cod.Ret.NFe: "+oWs:oWSCONSULTAPROTOCOLONFERESULT:cCODRETNFE+CRLF	
		cMensagem += " Msg.Ret.NFe: "+oWs:oWSCONSULTAPROTOCOLONFERESULT:cMSGRETNFE+CRLF	
		If !Empty(oWs:oWSCONSULTAPROTOCOLONFERESULT:cPROTOCOLO)
			cMensagem += " Protocolo: "+oWs:oWSCONSULTAPROTOCOLONFERESULT:cPROTOCOLO+CRLF
		EndIf
		Aviso("Consulta NF",cMensagem,{"Ok"},3)	
	Else
		Aviso("Totvs SPED Manager",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)
	EndIf
Else
	Aviso("Totvs SPED Manager","Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!",{"Ok"},3)
EndIf

Return ( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ LesXml    ³ Autor ³ Antonio Marcos Andriani ³ Data ³ 10/02/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para retornar um objeto XML dado um arquivo XML passado  ³±±
±±³Descri‡„o ³ no parametros EXPC1.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Params.   ³  ExpC1 : Endereco e nome do arquivo XML a ser lido.             ³±±
±±³          ³ @ExpC2 : Mensagem de retorno, para casos de erro.               ³±±
±±³          ³                                                        	       |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LerXml( cFileXml, cMsg )    

Local cDelimit	:= "_"
Local cError	:= ""
Local cWarning	:= ""
Local lRetorno	:= .F.
Local oXml 		:= XmlParserFile( cFileXml, cDelimit, @cError, @cWarning)

lRetorno := ( Empty( cError ) .and. Empty( cWarning ) )
If !lRetorno
	cMsg	:= AllTrim( cError + Iif( !Empty( cError ) .and. !Empty( cWarning ), " - ", "" ) + cWarning )
	oXml	:= Nil
EndIf


Return( oXml )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RetContArq ³ Autor ³ Antonio Marcos Andriani ³ Data ³ 10/02/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna conteudo de um arquivo.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Params.   ³  ExpC1 : Endereco e nome do arquivo a ser lido.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetContArq( cFile )
Local cConteudo := ""

	FT_FUSE( cFile )
	FT_FGOTOP()
	Do While !FT_FEOF()
		cConteudo += FT_FREADLN() 
		FT_FSKIP() 
	EndDo
	FT_FUSE()
	
Return( cConteudo )



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ _XmlEnvM  ³ Autor ³ Antonio Marcos Andriani ³ Data ³ 10/02/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para o envio de emails                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Params.   ³ ExpC1 : Conta de destino do e-mail.                             ³±±
±±³          ³ ExpC2 : Assunto do e-mail.                                      ³±±
±±³          ³ ExpC3 : Corpo da mensagem a ser enviada.               	       |±±
±±³          ³ ExpC4 : Arquivo que devera seguir atachado no email    	       |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//Alterado para considerar os parâmetros específicos da Burti - Robson Santos - Call System - 14/06/2012

User Function _XmlEnvM( cAssunto, cMensagem, aAttach, lSched ) 

Local cAccountE	:= Alltrim( SuperGetMV( "MV_XUSRMAI", .F., "" ) )
Local cAccountR := Alltrim( SuperGetMV( "MV_XMAILRE", .F., " " ) )  
Local cPassword	:= Alltrim( SuperGetMV( "MV_XSENMAI", .F., " " ) )                           
Local cServer	:= Alltrim( SuperGetMV( "MV_XSRVSMT", .F., " " ) )
Local cUserAut	:= Alltrim( SuperGetMV( "MV_XUSRMAI", .F., " " ) )             
Local cPassAut	:= Alltrim( SuperGetMV( "MV_XSENMAI", .F., " " ) )  
Local lServAut  := SuperGetMV( "MV_XSMTAUT", .F., .F. ) 
Local lUsaTSS	:= SuperGetMV( "MV_XSRCSEG", .F., .F. )
Local nPortaSmtp:= SuperGetMV( "MV_XPORSMT", .F., 25 )   
Local nTimeOut  := SuperGetMV( "MV_XTIMEOU", .F., 60 )               
Local cUser		:= ""
Local nAt		:= 0
Local lSendMail	:= .F.
Local lConect	:= .F.
Local cError   	:= ""  

Default aAttach	:= {}
Default lSched  := .f.  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como BCC para que a pessoa pense³
//³que somente ela recebeu aquele email, tornando o email mais personalizado.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
oMail := TMailManager():New()  

if lUsaTSS      

	oMail:SetUseSSL(.T.)  
	   
Endif  

oMail:Init( '', cServer , cAccountE, cPassword, 0, nPortaSmtp )
oMail:SetSmtpTimeOut( nTimeOut )
nErro := oMail:SmtpConnect()	

if nErro == 0	     
                   
	// Servidor Requer Autenticação? 
	if lServAut
	
   		nErro := oMail:SmtpAuth( cAccountE, cPassword )  
   		
 	Endif
	
	If nErro == 0 
	
		nErro := oMail:SendMail(cAccountE,; 
				   				cAccountR 	,;         
				   				cAssunto 	,;         
								cMensagem 	,;         
				   				"" 			,;         
				   				"" 			,;          
				   				aAttach  	,;         
				   				Len(aAttach) )   
					
		if nErro <> 0 
		
			if lSched       
		
				ConOut( "Nao foi possivel efetuar o envio do Email. ERRO: " + oMail:GetErrorString(nErro) )

	   		Else 
	   		
				Aviso( "ERRO!", "Nao foi possivel efetuar o envio do Email. ERRO: " + oMail:GetErrorString(nErro) , {"OK"})  
				
			Endif
		
		Endif
	
	Else	
		
		if lSched
			ConOut( "ERRO: Não foi possível efetuar a autenticação do usuário no Servidor STMP. O Email não foi enviado..." )  
		Else
			Aviso( "ERRO!", "Não foi possível efetuar a autenticação do usuário no Servidor STMP. O Email não foi enviado...", {"OK"})      
		Endif
			
	Endif
	
	oMail:SMTPDisconnect()

Else
     
	if lSched

		ConOut( "ERRO: Não foi possível conexão com o Servidor SMPT. O Email não foi enviado..." )    
		
	Else        
	                                                                                                            
   		Aviso( "ERRO!", "Não foi possível conexão com o Servidor SMPT. O Email não foi enviado...", {"OK"})     
   		
 	Endif
 
Endif       

Return( Nil )



/*************************************************************************************************
* Função para consultar NFe na SEFAZ e atualizar seu status.
* Robson Santos - Call System - 22/06/2012
*************************************************************************************************/
User function ATUALSTAT(cAlias,nReg, nOpc)

	Local cTudoOk   := "(Alert('OK'),.T.)"
	Local nOpcao    := 0
    Local cMsg      := ""
    Local cProdutolo:= ""
    
    cProtocolo := UZQ->UZQ_CHVNFE

    //ConsultaNf( cProtocolo, @cMsg )        
    //ConsNFeChave( cProtocolo, '0' )
    _nRet := ConsNFeChave( cProtocolo, GetIdEnt() )  
            
    // Gravando o Status do Sefaz ref. a Chave NFE, se -1 não foi possível conectar, abortar a inclusão
    if  _nRet == 100  
            
    	cStatus := "1"  
            	
     ElseIF _nRet > 0 
            
     	cStatus := "4"               
             
   	Endif
     

	If (cAlias)->UZQ_STATUS == "4" .and. cStatus == "1"        // Se status atual for NFe não autorizada e o novo status for NFe autorizada
        RecLock( cAlias , .F. )
        UZQ->UZQ_STATUS := cStatus
        UZQ->UZQ_OBS    := cMsg
        MsUnLock()
	Endif

Return nil    


/*************************************************************************************************
* Função para consultar NFe na SEFAZ e atualizar seu status.
* Ivan de Oliveira - Call System - 09/01/2013
*************************************************************************************************/ 

Static Function ConsNFeChave( _cChaveNFe, _cIdEnt )

Local _cURL  := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local _nRet  := -1
Local _oWS 

_oWS:= WsNFeSBra():New()
_oWS:cUserToken   := "TOTVS"
_oWS:cID_ENT      := _cIdEnt
_oWS:cCHVNFE	  := _cChaveNFe
_oWS:_URL         := AllTrim(_cURL) + "/NFeSBRA.apw"

If _oWS:ConsultaChaveNFE()  

	_nRet := Val(_oWS:OWSCONSULTACHAVENFERESULT:CCODRETNFE)
   
EndIf

Return _nRet   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³IsReady   ³ Autor ³Microsiga	            ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se a conexao com a Totvs Sped Services pode ser    ³±±
±±³          ³estabelecida                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: URL do Totvs Services SPED                        OPC³±±
±±³          ³ExpN2: nTipo                                             OPC³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IsReady()

Local oWS
Local lRetorno
Local cURL  := PadR(GetNewPar("MV_SPEDURL","http://"),250)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o servidor da Totvs esta no ar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWs := WsSpedCfgNFe():New()
oWs:cUserToken := "TOTVS"
oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
If oWs:CFGCONNECT()
	lRetorno := .T.
Else
	lRetorno := .F.
EndIf   

Return(lRetorno)  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ _EnvNot  ³ Autor ³Microsiga	            ³ Data ³05.07.2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se a conexao com a Totvs Sped Services pode ser    ³±±
±±³          ³estabelecida                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: URL do Totvs Services SPED                        OPC³±±
±±³          ³ExpN2: nTipo                                             OPC³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function _EnvNot (_cSmtpServer, _cCtaSmtp, _cSenSmtp, _CtaPara,  _cAssunto,  _cMensagem , _cAnexos )   

// Tentativa de Envio
CONNECT SMTP SERVER _cSmtpServer ACCOUNT _cCtaSmtp PASSWORD _cSenSmtp TIMEOUT 500 result _lConectou     

	SEND MAIL FROM _cCtaSmtp to _CtaPara;
	SUBJECT _cAssunto;
	BODY _cMensagem;
	ATTACHMENT _cAnexos;
	RESULT _lConectou   

Get Mail Error _cTxtErr
							
DISCONNECT SMTP SERVER 

Return

 
			
