#include "protheus.ch"
/*
????????????????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????????????ͻ??
???Programa ? ANFAT02         ?Autor? Antonio Marcos Andriani    ? Data ? 07/02/2012 ???
????????????????????????????????????????????????????????????????????????????????????͹??
???Desc.    ? Browse principal da Tela de Importacao de XML.                         ???
???         ?                                                                        ???
????????????????????????????????????????????????????????????????????????????????????͹??
???Uso      ? Generico                                                               ???
????????????????????????????????????????????????????????????????????????????????????͹??
???                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 ???
????????????????????????????????????????????????????????????????????????????????????͹??
???  Programador  ?  Data   ? Motivo da Alteracao                                    ???
????????????????????????????????????????????????????????????????????????????????????͹??
???               ?         ?                                                        ???
????????????????????????????????????????????????????????????????????????????????????ͼ??
????????????????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????????????????
*/   
User Function ANFAT02()
Private cCadastro	:= "Importa??o de XML"

// Inclu?da op??o para buscar do diret?rio - Robson Santos - Call System - 08/05/2012
Private aRotina 	:=	{{ "Pesquisar"		, "AxPesqui"	  ,	0, 1 },;
						 { "Visualizar"		, "AxVisual"	  ,	0, 2 },;
						 { "Consulta Nfe"	, "U_ATUALSTAT" ,	0, 2 },;  //4
						 { "Baixar Nfe"		, ;
						 "if( MsgYesNo ( 'Esta op??o poder? demorar alguns instantes devido a tr?fego de internet, disponobilidade no servidor de e-mails, confirma?' ), U_ANFAT01({'E'}), .f. )",;
						 	0, 2 },; //3
						 { "Imp Pasta"      		  , "U_ANFAT01({'D'})", 0, 3 },;  //3
						 { "Gerar Pr?-Nota(Unit?rio)" , "U_ANFAT03"	  ,	0, 2 },;       
						 { "Gerar Pr?-Nota(Lote)"     , "U_ANFATLOT()",0, 2 },;
						 { "Excluir"	    		  , "U_ANFAT02E"	  ,	0, 5 },;
						 { "Legenda"				  , "U_ANFAT02X"    ,	0, 2 } }    //3

// Alterada a ordem das cores Verde e Azul, no status 1 como Verde ficou mais intuitivo que ? o ?nico (al?m do com falha) que pode ser exclu?do.
// Robson Santos - Call System - 20/06/2012{ "Excluir"	    , "U_ANFAT02E"	  ,	0, 5 },;
Private aCores		:=	{	{ 'UZQ->UZQ_STATUS=="1"', 	'BR_VERDE' },; 		// XML Importado
							{ 'UZQ->UZQ_STATUS=="2"',	'BR_AZUL' },;		// Pre-Nota a Classificar(Nfe)  
							{ 'UZQ->UZQ_STATUS=="6"',	'BR_VIOLETA' },;	// Pre-Nota a Classificar(Cte)
							{ 'UZQ->UZQ_STATUS=="3"',	'BR_VERMELHO' },;	// Pre-Nota Classifica
							{ 'UZQ->UZQ_STATUS=="4"',	'BR_AMARELO' },;	// NF-e N?o autorizada na Receita
							{ 'UZQ->UZQ_STATUS=="5"',	'BR_CINZA' }}		// Falha na Importacao
							
Private cDelFunc 	:= ".T."

dbSelectArea( "UZQ" )
dbSetOrder( 1 )

mBrowse( 6,1,22,75,"UZQ",,,,,, aCores )     //Monta a interface de cadastro de XMLs

Return


/*
????????????????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????????????ͻ??
???Programa ? ANFAT02X        ?Autor? Antonio Marcos Andriani    ? Data ? 08/02/2012 ???
????????????????????????????????????????????????????????????????????????????????????͹??
???Desc.    ? Tela para visualizacao das cores e descricoes da Legenda.              ???
???         ?                                                                        ???
????????????????????????????????????????????????????????????????????????????????????͹??
???Uso      ? Generico                                                               ???
????????????????????????????????????????????????????????????????????????????????????͹??
???                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 ???
????????????????????????????????????????????????????????????????????????????????????͹??
???  Programador  ?  Data   ? Motivo da Alteracao                                    ???
????????????????????????????????????????????????????????????????????????????????????͹??
???               ?         ?                                                        ???
????????????????????????????????????????????????????????????????????????????????????ͼ??
????????????????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????????????????
*/   
User Function ANFAT02X()
BrwLegenda( "Importa??o de XML", 	"Legenda",	{	{ "BR_VERDE"  		, '1-XML Importado'  					} ,;
													{ "BR_AZUL"			, '2-Pre-Nota a Classficar(NFe)'    	} ,; 
													{ "BR_VIOLETA"		, '6-Pre-Nota a Classficar(CTe)'    	} ,; 
													{ "BR_VERMELHO"		, '3-Pre-Nota Classificada'    			} ,;
													{ "BR_AMARELO"		, '4-NFe n?o autorizada no SEFAZ'		} ,;
													{ "BR_CINZA"		, '5-Diverg?ncia Compra'				} } )
Return



/*************************************************************************************************
* Fun??o para exclus?o de cadastro de XML, somente se ainda n?o gerada pr?-nota (status = 1 ou 4)
* Robson Santos - Call System - 19/06/2012
*************************************************************************************************/
User function ANFAT02E(cAlias,nReg, nOpc)

 // Se status n?o for de nf com pre-nota gerada Alias()
If !UZQ->UZQ_STATUS $ "2/3"   

	//Executa rotina padr?o do sistema que apresenta o cadastro na tela para confirmar ou cancelar, se cancelar retorna 2.            		
 	AxDeleta( cAlias, nReg, nOpc,,,,,,.T.,,,,,)  
 
Else   

	Aviso("Aten??o!", "Este XML n?o pode ser exclu?do pois j? gerou pr?-nota.", {"OK"})

Endif   

Return Nil
			
