#include 'totvs.ch'
#INCLUDE "PROTHEUS.CH"

//---------------------------------------------------------------------------------
// Rotina | CSFIN010  | Autor | Rafael Beghini            | Data | 03/08/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina Sispag - Gera, recebe e lê o arquivo de retorno
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CSFIN010()
	Local cCond1 := 'E2_TIPO == "'+MVPAGANT+'" .and. ROUND(E2_SALDO,2) > 0'
	Local cCond2 := 'ROUND(E2_SALDO,2) + ROUND(E2_SDACRES,2)  = 0'
	Local cCond3 := '!Empty(E2_NUMBOR) .and.(ROUND(E2_SALDO,2)+ ROUND(E2_SDACRES,2) # ROUND(E2_VALOR,2)+ ROUND(E2_ACRESC,2))'
	Local cCond4 := '!Empty(E2_NUMBOR)'
	Local cCond5 := 'ROUND(E2_SALDO,2)+ ROUND(E2_SDACRES,2) # ROUND(E2_VALOR,2)+ ROUND(E2_ACRESC,2)' 
	
	Local aCores  := {{ cCond1 , "BR_BRANCO"   },; //"Adiantamento com saldo"
	                  { cCond2 , "BR_VERMELHO" },; //"Titulo Baixado" 
	                  { cCond3 , "BR_CINZA"    },; //"Titulo baixado parcialmente e em bordero"
	                  { cCond4 , "BR_PRETO"    },; //"Titulo em Bordero"
	                  { cCond5 , "BR_AZUL"     },; //"Baixado parcialmente"
	 				{ '.T.'  , "BR_VERDE"    } } //"Titulo em aberto"
	 				
	Private cCadastro  := "Sispag"
	
	Private aRotina := {{"Pesquisar"      , "AxPesqui"    , 0, 1 },;
			 		  {"Visualizar"     , "AxVisual"    , 0, 2 },;
	                    {"Gerar Arquivo"  , "U_CSFIN10A"  , 0, 2 },;
	                    {"Recebe Arquivo" , "U_CSFIN10B"  , 0, 2 },;
	                    {"Rel Ret. Sispag", "U_CSFIN10R"  , 0, 2 },;
	                    {"Legenda"        , "Fa040Legenda", 0, 2 } }
	                    
	dbSelectArea("SE2")
	dbSetOrder(1)
	 
	mBrowse( ,,,,"SE2",,,,,,aCores,,,,,,,,)
 
RETURN NIL

//---------------------------------------------------------------------------------
// Rotina | CSFIN10A  | Autor | Rafael Beghini            | Data | 03/08/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina Sispag - Gera o arquivo para envio ao Banco
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CSFIN10A()
	Fina300(3)
Return

//---------------------------------------------------------------------------------
// Rotina | CSFIN10B  | Autor | Rafael Beghini            | Data | 03/08/2015
//---------------------------------------------------------------------------------
// Descr. | Rotina Sispag - Recebo o arquivo para importar no sistema
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------
User Function CSFIN10B()
	Fina300(4)
Return

//---------------------------------------------------------------------------------
// Rotina | CSFIN10R  | Autor | Rafael Beghini            | Data | 03/08/2015
//---------------------------------------------------------------------------------
// Descr. | Relatório para verificar o arquivo de retorno
//---------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//---------------------------------------------------------------------------------						
User Function CSFIN10R()
	Local nOpc      := 0
	
	Private cTitulo := "Relatório Retorno Sispag"
	Private aSay    := {}
	Private aButton := {}
	
	aAdd( aSay , "Esta rotina irá imprimir o relatório de retorno de Sispag." )
	aAdd( aSay , "")
	aAdd( aSay , "Seu objetivo é validar o arquivo antes de importar para o sistema.")
	aAdd( aSay, "Clique em OK para continuar...")
	
	aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
	aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )
	
	FormBatch( cTitulo, aSay, aButton )

	If nOpc == 1
		U_CSFIN020()
	EndIF
Return						