#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ ANFAT02         ºAutor³ Antonio Marcos Andriani    º Data ³ 07/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Browse principal da Tela de Importacao de XML.                         º±±
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
User Function ANFAT02()
Private cCadastro	:= "Importação de XML"

// Incluída opção para buscar do diretório - Robson Santos - Call System - 08/05/2012
Private aRotina 	:=	{{ "Pesquisar"		, "AxPesqui"	  ,	0, 1 },;
						 { "Visualizar"		, "AxVisual"	  ,	0, 2 },;
						 { "Consulta Nfe"	, "U_ATUALSTAT" ,	0, 2 },;  //4
						 { "Baixar Nfe"		, ;
						 "if( MsgYesNo ( 'Esta opção poderá demorar alguns instantes devido a tráfego de internet, disponobilidade no servidor de e-mails, confirma?' ), U_ANFAT01({'E'}), .f. )",;
						 	0, 2 },; //3
						 { "Imp Pasta"      		  , "U_ANFAT01({'D'})", 0, 3 },;  //3
						 { "Gerar Pré-Nota(Unitário)" , "U_ANFAT03"	  ,	0, 2 },;       
						 { "Gerar Pré-Nota(Lote)"     , "U_ANFATLOT()",0, 2 },;
						 { "Excluir"	    		  , "U_ANFAT02E"	  ,	0, 5 },;
						 { "Legenda"				  , "U_ANFAT02X"    ,	0, 2 } }    //3

// Alterada a ordem das cores Verde e Azul, no status 1 como Verde ficou mais intuitivo que é o único (além do com falha) que pode ser excluído.
// Robson Santos - Call System - 20/06/2012{ "Excluir"	    , "U_ANFAT02E"	  ,	0, 5 },;
Private aCores		:=	{	{ 'UZQ->UZQ_STATUS=="1"', 	'BR_VERDE' },; 		// XML Importado
							{ 'UZQ->UZQ_STATUS=="2"',	'BR_AZUL' },;		// Pre-Nota a Classificar(Nfe)  
							{ 'UZQ->UZQ_STATUS=="6"',	'BR_VIOLETA' },;	// Pre-Nota a Classificar(Cte)
							{ 'UZQ->UZQ_STATUS=="3"',	'BR_VERMELHO' },;	// Pre-Nota Classifica
							{ 'UZQ->UZQ_STATUS=="4"',	'BR_AMARELO' },;	// NF-e Não autorizada na Receita
							{ 'UZQ->UZQ_STATUS=="5"',	'BR_CINZA' }}		// Falha na Importacao
							
Private cDelFunc 	:= ".T."

dbSelectArea( "UZQ" )
dbSetOrder( 1 )

mBrowse( 6,1,22,75,"UZQ",,,,,, aCores )     //Monta a interface de cadastro de XMLs

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ ANFAT02X        ºAutor³ Antonio Marcos Andriani    º Data ³ 08/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Tela para visualizacao das cores e descricoes da Legenda.              º±±
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
User Function ANFAT02X()
BrwLegenda( "Importação de XML", 	"Legenda",	{	{ "BR_VERDE"  		, '1-XML Importado'  					} ,;
													{ "BR_AZUL"			, '2-Pre-Nota a Classficar(NFe)'    	} ,; 
													{ "BR_VIOLETA"		, '6-Pre-Nota a Classficar(CTe)'    	} ,; 
													{ "BR_VERMELHO"		, '3-Pre-Nota Classificada'    			} ,;
													{ "BR_AMARELO"		, '4-NFe não autorizada no SEFAZ'		} ,;
													{ "BR_CINZA"		, '5-Divergência Compra'				} } )
Return



/*************************************************************************************************
* Função para exclusão de cadastro de XML, somente se ainda não gerada pré-nota (status = 1 ou 4)
* Robson Santos - Call System - 19/06/2012
*************************************************************************************************/
User function ANFAT02E(cAlias,nReg, nOpc)

 // Se status não for de nf com pre-nota gerada Alias()
If !UZQ->UZQ_STATUS $ "2/3"   

	//Executa rotina padrão do sistema que apresenta o cadastro na tela para confirmar ou cancelar, se cancelar retorna 2.            		
 	AxDeleta( cAlias, nReg, nOpc,,,,,,.T.,,,,,)  
 
Else   

	Aviso("Atenção!", "Este XML não pode ser excluído pois já gerou pré-nota.", {"OK"})

Endif   

Return Nil
			
