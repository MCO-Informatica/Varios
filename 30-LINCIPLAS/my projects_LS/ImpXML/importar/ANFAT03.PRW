#include "protheus.ch"
#include "RWMAKE.CH"
#include "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ ANFAT03         บAutorณ Antonio Marcos Andriani    บ Data ณ 07/02/2012 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Tela para geracao da Pre-Nota de Entrada e ajustes de acordo com o PC  บฑฑ
ฑฑบ         ณ e Nota Fiscal de Entrada recebida no formato XML.                      บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Generico                                                               บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*****************************************************************************************
* Alterado para adicionar Num Pedido Compra e Item ao vetor de itens somente ap๓s todos
* os demais campos para a fun็ใo MATA140, pois retorna Item do PC invแlido caso contrแrio.
* Robson Santos - Call System - 17/07/2012
*****************************************************************************************/
/*****************************************************************************************
* Incluํdo tratamento de erro em caso de falha na abertura de arquivo XML para gera็ใo
* da Pr้-Nota. Robson Santos - Call System - 08/08/2012
*****************************************************************************************/
/*****************************************************************************************
* Incluํdo o envio do n๚mero da chave da NFe (cChaveNfe) para a Pr้-Nota gerada.
* Robson Santos - Call System - 12/08/2012
*****************************************************************************************/

User Function ANFAT03()      

Local cPerg 		:= "ANFAT03"
Local cFileXml		:= Alltrim( Lower( UZQ->UZQ_LOCARQ ) )
Local cMsg			:= ""
Local oXml			:= Nil
Local aButtons 		:= {}
Local oDlg			:= Nil
Local aSay			:= {}
Local nOpcao		:= 0
Local bGet 			:= NIL
Local oGet 			:= NIL
Local nTop 			:= 5
Local nWidth 		:= 0
Local cGet 			:= ""
Local cPict 		:= ""
Local cVar 			:= ""
Local n 			:= 0
Local _aHeader 		:= {}
Local _aCols 		:= {} 
Local aH_Pc 		:= {}
Local aC_Pc 		:= {}
Local aH_Nf 		:= {}
Local aC_Nf 		:= {}
Local nColPos		:= 0
Local nColuna		:= 0
Local lZeraEsq      := SuperGetMV( "MV_XZERAE", .F.,  .T. ) 

Local _nSuperior:= 080
Local _nEsquerda:= 003
Local _nInferior:= 253
//Local _nDireita := 440 
Local _nDireita := 597
Local _nOpcGD 	:= GD_UPDATE//GD_UPDATE+GD_INSERT+GD_DELETE
Local _cLinOk 	:= "AllwaysTrue"
Local _cTudoOk  := "AllwaysTrue"
Local _cIniCpos := "D1_ITEM" 
Local _aAlterGDa:= { "D1_PEDIDO","D1_ITEMPC" }    
 Local _nFreeze  := 000
Local _nMax 	:= 999
Local _cFieldOk := "AllwaysTrue"
Local _cSuperDel:= ""
Local _cDelOk 	:= "AllwaysFalse"

Local _oFontCab := TFont():New( "Arial",, 20,,.F.,,,, .F., .F. )  
lOCAL _oFontBot := TFont():New( "Courier New",, 14,.T.,.F.,,,, .F.,.F. ) 
Local _oFont    := TFont():New( "Courier New",, 18,,.T.,,,, .F., .F. ) 

Private	lMSHelpAuto	:= .F.     
Private _aItErr 	:= {}
Private	lMsErroAuto := .F.
Private _aResps   	:= {}

If UZQ->UZQ_STATUS $ "2/3/5/6"             // se com pr้-nota jแ gerada ou com falha na importa็ใo
	MsgAlert( "Nใo ้ permitido gerar pr้-nota de XML com esse Status!", "ANFAT03" )
	Return( Nil )
ElseIf UZQ->UZQ_STATUS == "4"            // Se nใo autorizado uso da NF-e   

	//If !ApMsgNoYes("Esta NFe estแ como nใo autorizada pela SEFAZ. Tente consultar novamente a SEFAZ antes de continuar ou clique em [Sim] para gerar a pr้-nota assim mesmo.", "NF-e Nใo autorizada!")    // Se NรO confirmado
 	MsgStop( "Esta NFe estแ como nใo autorizada pela SEFAZ. Tente consultar novamente a SEFAZ antes de continuar." , "ANFAT03" )
  	Return( Nil )
    //Endif
Endif


MsAguarde( { || oXml := U_LerXml( cFileXml, @cMsg ) }, "Aguarde!", "Lendo XML...", .T. )

If !( ValType(oXml) == "O" ) .or. !Empty( cMsg )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Envia email de aviso sobre o erro                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cAssunto	:= "ERRO - Rotina de Gera็ใo de Pr้-Nota"
	cMensagem	:= "Houve uma falha na tentativa de leitura do arquivo XML."  + CRLF 
	cMensagem	+= "Provavelmente existe um erro na estrutura do arquivo." + CRLF + CRLF
	cMensagem	+= "Ou arquivo nใo encontrado em: " + cFileXml
	Aviso(cAssunto, cMensagem , {"OK"})

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Envia mensagem de erro para o console do server Protheus                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ConOut( "" )	
	ConOut( cAssunto )
	ConOut( cMensagem )
	ConOut( "" )	

	Return(nil)
	
Endif   

// Copiando para pasta o arquivo temporแria
CpyS2T(   cFileXml, GetTempPath() )  
_cDirTmp := GetTempPath() + Substr( cFileXml, Rat('\',cFileXml ) + 1, len(cFileXml) ) 
_cArqXML := MemoRead ( _cDirTmp )  

_cTipo	 := "N"
_cFormul := "N"

// COnsulta de NFe
if UZQ->UZQ_TIPO ==  "NFE" 

	_cDoc := PadR( Alltrim( oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT ), TamSX3("F1_DOC")[1], " " )    
	
	IF lZeraEsq
		_cDoc 	    := StrZero(Val(_cDoc),TamSX3("F1_DOC")[1])  // Converte n๚mero da NF para 9 dํgitos com zeros เ esquerda
	ENDIF    
	
	_cSerie		:= PadR( oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text, TamSX3("F1_SERIE")[1], " " )
	_dEmissao	:= Stod( StrTran( oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dEmi:Text, "-", "" ) ) 
	_nDespesa	:= 0
	_cCnpjEmi	:= PadR( Alltrim( oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT ), TamSX3("A2_CGC")[1], " " )      
	
	_aRetFor := GetAdvFVal( "SA2", {"A2_COD","A2_LOJA","A2_NREDUZ"}, xFilial( "SA2" ) +_cCnpjEmi, 3 )
 	_cFornece	:= _aRetFor[01]
	_cLoja		:= _aRetFor[02] 
	
	_cNmFor		:= OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT
	_cEndFor    := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XLGR:TEXT 
	_cCidFor   	:= OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT
	_cTelFor	:= OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_FONE:TEXT
	_cCepFor	:= OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT
	_cEspecie	:= "SPED" 
	_cValor		:= 'R$ ' + Alltrim(Transform ( Val(OXML:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT), "@E 999,999,999.99" ))
	_cNatureza	:= Alltrim(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT)
 	_cChaveNfe	:= Padr( Alltrim( oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT ), TamSX3("UZQ_CHVNFE")[1], " " )    

// COnsulta de CTE	
Else    

	_cDoc		:= PadR( Alltrim( OXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT ), TamSX3("F1_DOC")[1], " " )    
	
	IF lZeraEsq
		_cDoc 	    := StrZero(Val(_cDoc),TamSX3("F1_DOC")[1])  // Converte n๚mero da NF para 9 dํgitos com zeros เ esquerda
	ENDIF    
	
	_cSerie		:= PadR( OXML:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:TEXT, TamSX3("F1_SERIE")[1], " " )
	_dEmissao	:= Stod( StrTran( OXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT, "-", "" ) ) 
	_nDespesa	:= 0
	_cCnpjEmi	:= PadR( Alltrim( OXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT ), TamSX3("A2_CGC")[1], " " )  
	
	_aRetFor := GetAdvFVal( "SA2", {"A2_COD","A2_LOJA","A2_NREDUZ"}, xFilial( "SA2" ) +_cCnpjEmi, 3 )
  	_cFornece	:= _aRetFor[01]
	_cLoja		:= _aRetFor[02] 
	
	_cNmFor		:= OXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME:TEXT   
	_cEndFor    := OXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XLGR:TEXT 
	_cCidFor   	:= OXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT
	_cTelFor	:= OXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_FONE:TEXT 
	_cCepFor	:= OXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_CEP:TEXT
	_cEspecie	:= "CTE" 
	_cValor		:= 'R$ ' + Alltrim(Transform ( Val(OXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT), "@E 999,999,999.99" ))
	_cNatureza	:= Alltrim(OXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NATOP:TEXT)
	_cChaveNfe	:= Padr( Alltrim( OXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT ), TamSX3("UZQ_CHVNFE")[1], " " )    
	
Endif  
      
// Vefificando se a NF existe
SF1->( dbSetOrder( 1 ) )
_lNFEmit := SF1->( dbSeek( xFilial( "SF1" ) + _cDoc + _cSerie + _cFornece + _cLoja + _cTipo ) )

/// Antigo
DEFINE MSDIALOG oDlg FROM 000, 000 TO 560, 1200 PIXEL TITLE 'Gera็ใo de Pr้-Nota via XML' STYLE DS_MODALFRAME   
 
 	/////  Grupo 1 -  Dados do Emitente"  
 	oGroup01 := TGroup():New( c(001),c(001),c(060),c(240),'',oDlg,,,.T. )   
	oSay00 := TSay():Create( oDlg, {||'C๓digo: '},	 c(05), c(005),,_oFontCab,,,,.T.,CLR_RED,CLR_WHITE,100,20)  
 	oSay01 := TSay():Create( oDlg, {||'Fornecedor:'},c(15), c(005),,_oFontCab,,,,.T.,CLR_RED,CLR_WHITE,100,20) 
	oSay02 := TSay():Create( oDlg, {||'Endere็o:'},	 c(25), c(005),,_oFontCab,,,,.T.,CLR_RED,CLR_WHITE,100,20)  
 	oSay03 := TSay():Create( oDlg, {||'Cidade:  '},  c(35), c(005),,_oFontCab,,,,.T.,CLR_RED,CLR_WHITE,100,20) 
 	oSay03a:= TSay():Create( oDlg, {||'CEP:  '}	,    c(35), c(175),,_oFontCab,,,,.T.,CLR_RED,CLR_WHITE,100,20) 
	oSay04 := TSay():Create( oDlg, {||'Telefone:'},	 c(45), c(005),,_oFontCab,,,,.T.,CLR_RED,CLR_WHITE,100,20) 
	
	oSay05 := TSay():Create( oDlg, {|| _cFornece },	 c(05),c(045),,_oFontCab,,,,.T.,CLR_BLACK,CLR_WHITE,100,010 ) 
	oSay06 := TSay():Create( oDlg, {|| _cNmFor   },	 c(15),c(045),,_oFontCab,,,,.T.,CLR_BLACK,CLR_WHITE,200,010 )
	oSay08 := TSay():Create( oDlg, {|| _cEndFor  },	 c(25),c(045),,_oFontCab,,,,.T.,CLR_BLACK,CLR_WHITE,200,010 )
	oSay09 := TSay():Create( oDlg, {|| _cCidFor  },	 c(35),c(045),,_oFontCab,,,,.T.,CLR_BLACK,CLR_WHITE,100,010 )    
	oSay09 := TSay():Create( oDlg, {|| _cCepFor	 },	 c(35),c(195),,_oFontCab,,,,.T.,CLR_BLACK,CLR_WHITE,100,010 )    
	oSay10 := TSay():Create( oDlg, {|| _cTelFor  },	 c(45),c(045),,_oFontCab,,,,.T.,CLR_BLACK,CLR_WHITE,100,010 )
 
	/////  Grupo 2 -  Dados da Nota"   
	oGroup02 := TGroup():New( c(001),c(242),c(060),c(469),'',oDlg,,,.T. )   
	
	oSay11 := TSay():Create( oDlg, {||'Nota Fiscal:'}	, c(05), c(250),,_oFontCab,,,,.T.,CLR_RED,CLR_WHITE,100,20) 
	oSay12 := TSay():Create( oDlg, {||'Total:'}			, c(15), c(250),,_oFontCab,,,,.T.,CLR_RED,CLR_WHITE,100,20)  
  	oSay13 := TSay():Create( oDlg, {||'Natureza: '}		, c(25), c(250),,_oFontCab,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oSay14 := TSay():Create( oDlg, {||'Chave '+UZQ->UZQ_TIPO}  , c(35), c(250),,_oFontCab,,,,.T.,CLR_RED,CLR_WHITE,100,20) 
	
	oSay15 := TSay():Create( oDlg, {|| _cDoc }	,	 c(05),c(290),,_oFontCab,,,,.T.,CLR_HRED ,CLR_WHITE,225,010 )  
	oSay15 := TSay():Create( oDlg, {|| _cValor },	 c(15),c(290),,_oFontCab,,,,.T.,CLR_BLACK,CLR_WHITE,225,010 ) 
	oSay15 := TSay():Create( oDlg, {|| _cNatureza }, c(25),c(290),,_oFontCab,,,,.T.,CLR_BLACK,CLR_WHITE,225,010 ) 
    
	// deixar com GET para possibilitar copiar o c๓digo
	oTGet01:=TGet():New( c(35),c(290),{|| _cChaveNfe },oDlg,225,010,"",,CLR_BLACK,CLR_WHITE,_oFontCab,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,,,,, )  

	/////  Grupo 3 -  GetDados ( Itens )        
	_aHeader := HeaderXml()
	_aCols   := ColsXml( _aHeader, oXml, UZQ_TIPO == "NFE" )
	oGroup03 := TGroup():New( c(061),c(001),c(200),c(469),'',oDlg,,,.T. )  
		
	if len( _aCols ) > 0
	
	 	oGetItens :=  MsNewGetDados():New( _nSuperior, _nEsquerda, _nInferior, _nDireita,_nOpcGD,_cLinOk,_cTudoOk,_cIniCpos,_aAlterGDa,;
		 								   _nFreeze, _nMax, _cFieldOk , _cSuperDel,   _cDelOk, oDlg, _aHeader, _aCols ) 
		 								   
		// Controle de cores somente na NFE
		if UZQ->UZQ_TIPO ==  "NFE"  
		
			oGetItens:oBrowse:lUseDefaultColors := .F.   
		
		   	oGetItens:oBrowse:SetBlkBackColor({||u__DefineCor( oGetItens:aCols, oGetItens:nAt,_aHeader,oGetItens ) }) 
		 	oGetItens:oBrowse:blDblClick :=  {||u__ExibeLOG(oGetItens:aCols,oGetItens:nAt ) } 
		 	
		Endif
		
	EndIf
	
	/////  Grupo 4 -  Bot๕es controle
	oTButtT := TButton():New( c(046), c(350), "&Preencher em Lote",oDlg, {|| _Perg() },070,15,,_oFontBot,.F.,.T.,.F.,,.F.,{|| !Empty( _aCols ).and.;
																		   UZQ->UZQ_TIPO ==  "NFE" .and. !_lNFEmit },,.F. ) 	
	oTButtC := TButton():New( c(046), c(410), "&Ver XML",oDlg, {|| ShellExecute( "open","iexplore.exe", _cDirTmp ,"", 1 ) },070,15,,_oFontBot,.F.,.T.,.F.,,.F.,,,.F. ) 	 
 	oTButtPC:= TButton():New( c(205), c(300), "&Item(Ped.Compras)",oDlg, {|| U_ANFAT03B( oGetItens, _cFornece, _cLoja )  };
 											  ,060,15,,_oFontBot,.F.,.T.,.F.,,.F.,{|| !Empty( _aCols ) .and. UZQ->UZQ_TIPO=="NFE" .and. !_lNFEmit },,.F. ) 	
 	
 	oTButtG := TButton():New( c(205), c(360), "&Gerar Nota"	  	  ,oDlg, {|| if ( MsgYesno ( "Confirma emissใo?" ), ;
 																		 ( MsAguarde( { || U_ANFAT03A( _cTipo, _cFormul, _cDoc, _cSerie, _dEmissao,;
 																		     _nDespesa, _cFornece, _cLoja, _cEspecie, _cChaveNfe, oGetItens:aCols, _aHeader ) },;
 																		     "Aguarde...", "Gerando Pr้-Nota!", .T. ),oDlg:End()), .f. )  },;
 																		     060,15,,_oFontBot,.F.,.T.,.F.,,.F.,{|| !Empty( _aCols ).and. !_lNFEmit },,.F. ) 	
 																		     
 	oTButtS := TButton():New( c(205), c(420), "&Sair"			  ,oDlg, {|| oDlg:End() },060,15,,_oFontBot,.F.,.T.,.F.,,.F.,,,.F. ) 				
   
 
ACTIVATE MSDIALOG oDlg CENTERED  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Apaga o arquivo XML da pasta Temporaria CLIENTE	       				   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fErase( _cDirTmp  )    

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ ANFAT03A        บAutorณ Antonio Marcos Andriani    บ Data ณ 07/02/2012 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Gera uma Pre Nota de Entrada Baseado no arquivo XML recido do          บฑฑ
ฑฑบ         ณ Fornecedor e ajustado pelo Depto Compras.                              บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe  ณ ColsXml( ExpC1, ExpC2,  ExpC3, ExpC4, ExpD5, ExpN6, ExpC7, ExpC8,      บฑฑ
ฑฑบ         ณ          ExpC9, ExpA10, ExpA11 )                                       บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametr ณ ExpC1  = Tipo da Nota Fiscal (N=Normal, D=Devolucao, B=Beneficiamento) บฑฑ
ฑฑบ         ณ ExpC2  = Indica se deve usar Formulario Proprio ( S=Sim, N=Nao )       บฑฑ
ฑฑบ         ณ ExpC3  = Numero da Nota Fiscal                                         บฑฑ
ฑฑบ         ณ ExpC4  = Numero da Serie                                               บฑฑ
ฑฑบ         ณ ExpD5  = Data da Emissao da Nota                                       บฑฑ
ฑฑบ         ณ ExpN6  = Valor das Despesas                                            บฑฑ
ฑฑบ         ณ ExpC7  = Codigo do Fornecedor                                          บฑฑ
ฑฑบ         ณ ExpC8  = Codigo da Loja                                                บฑฑ
ฑฑบ         ณ ExpC9  = Tipo/Especie do Documento Fiscal                              บฑฑ
ฑฑบ         ณ ExpA10 = aHeader com dados do XML para geracao da Nota                 บฑฑ
ฑฑบ         ณ ExpA11 = aCos com dados do XML para geracao da Nota                    บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Generico                                                               บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/   
User Function ANFAT03A( cTipo, cFormul, cDoc, cSerie, dEmissao, nDespesa, cFornece, cLoja, cEspecie, cChaveNfe, aC_Xml, aH_Xml ) 

Local aLinha	:= {}
Local aCabec	:= {}
Local aItens	:= {}
Local nx		:= 0
Local nPItem	:= aScan( aH_Xml,{ |x| Alltrim( Upper( x[2] ) ) == "D1_ITEM" } )
Local nPCod		:= aScan( aH_Xml,{ |x| Alltrim( Upper( x[2] ) ) == "D1_COD" } )
Local nPQuant	:= aScan( aH_Xml,{ |x| Alltrim( Upper( x[2] ) ) == "D1_QUANT" } )
Local nPVUnit	:= aScan( aH_Xml,{ |x| Alltrim( Upper( x[2] ) ) == "D1_VUNIT" } )
Local nPTotal	:= aScan( aH_Xml,{ |x| Alltrim( Upper( x[2] ) ) == "D1_TOTAL" } )
Local nPValDesc	:= aScan( aH_Xml,{ |x| Alltrim( Upper( x[2] ) ) == "D1_VALDESC" } )
Local nPPedido	:= aScan( aH_Xml,{ |x| Alltrim( Upper( x[2] ) ) == "D1_PEDIDO" } )
Local nPItemPc	:= aScan( aH_Xml,{ |x| Alltrim( Upper( x[2] ) ) == "D1_ITEMPC" } )
Local cCodProd 	:= ""
Local cPedCompra := ""
Local cItemPC   := ""
Local lCriaSA5  := SuperGetMV( "MV_XAUTSA5", .F.,  .F. )

Local nOpc
Local aRotAuto      := {}
Private lMsHelpAuto := .t.  // direciona as mensagens de help para o arq. de log
Private lMsErroAuto := .f.

aCabec := {}
aadd( aCabec,{ "F1_TIPO"   	, cTipo		, Nil } )
aadd( aCabec,{ "F1_FORMUL" 	, cFormul	, Nil } )
aadd( aCabec,{ "F1_DOC"    	, cDoc		, Nil } )
aadd( aCabec,{ "F1_SERIE"  	, cSerie	, Nil } )
aadd( aCabec,{ "F1_EMISSAO"	, dEmissao	, Nil } )
aadd( aCabec,{ "F1_DESPESA"	, nDespesa	, Nil } ) 
aadd( aCabec,{ "F1_DESPESA"	, nDespesa	, Nil } ) 
aadd( aCabec,{ "F1_DESPESA"	, nDespesa	, Nil } ) 
aadd( aCabec,{ "F1_DESPESA"	, nDespesa	, Nil } ) 
aadd( aCabec,{ "F1_DESPESA"	, nDespesa	, Nil } ) 
aadd( aCabec,{ "F1_DESPESA"	, nDespesa	, Nil } ) 
aadd( aCabec,{ "F1_DESPESA"	, nDespesa	, Nil } ) 
aadd( aCabec,{ "F1_DESPESA"	, nDespesa	, Nil } ) 
aadd( aCabec,{ "F1_DESPESA"	, nDespesa	, Nil } ) 
aadd( aCabec,{ "F1_FORNECE"	, cFornece	, Nil } )
aadd( aCabec,{ "F1_LOJA"   	, cLoja		, Nil } )
aadd( aCabec,{ "F1_ESPECIE"	, cEspecie	, Nil } )
aadd( aCabec,{ "F1_COND"	, "001"		, Nil } )
aadd( aCabec,{ "F1_CHVNFE"	, cChaveNfe , Nil } )
	
For nx := 1 To Len( aC_XML )

	If ( Empty( aC_XML[ nx, nPPedido ] ) .or. Empty( aC_XML[ nx, nPItemPc ] ) ) .and. UZQ->UZQ_TIPO ==  "NFE"  

        SA5->(DbSetOrder(14))
        If !SA5->( dbSeek( xFilial( "SA5" ) + cFornece + cLoja + aC_XML[ nx, nPCod ] ) )
            Alert( "Cadastre a amarra็ใo produto x fornecedor para o produto: " + aC_XML[ nx, nPCod ] + " ou selecione um Pedido de Compra." )
            Return( Nil )
        Else
            cCodProd := SA5->A5_PRODUTO
        Endif

	Else

        SC7->(dbSetOrder( 1 ))	// C7_FILIAL + C7_NUM + C7_ITEM + C7_SEQUEN
		If SC7->( dbSeek( xFilial( "SC7" ) + aC_XML[ nx, nPPedido ] + aC_XML[ nx, nPItemPc ] ) ) .and. UZQ->UZQ_TIPO ==  "NFE"
		
			cCodProd := SC7->C7_PRODUTO
			
            //aadd( aLinha,{ "D1_PEDIDO" 	, aC_XML[ nx, nPPedido ]	,Nil})  // Nใo se pode adicionar n๚mero e item do PC antes dos demais campos na Array aLinha - Robson - Call System - 17/07/2012
            cPedCompra := aC_XML[ nx, nPPedido ]
            //aadd( aLinha,{ "D1_ITEMPC" 	, aC_XML[ nx, nPItemPc ]	,Nil})  // Nใo se pode adicionar n๚mero e item do PC antes dos demais campos na Array aLinha - Robson - Call System - 17/07/2012
            cItemPC := aC_XML[ nx, nPItemPc ]
                
            //Incluํdas outras informa็๕es do Pedido de Compra normalmente trazidas quando usada a rotina padrใo do Protheus - Robson Santos - Call System - 20/06/2012
            aadd( aLinha,{ "D1_XOBS" 	, SC7->C7_OBS				,Nil})
            aadd( aLinha,{ "D1_CC"	 	, SC7->C7_CC				,Nil})
            aadd( aLinha,{ "D1_LOCAL" 	, SC7->C7_LOCAL				,Nil})
            aadd( aLinha,{ "D1_UM"      , SC7->C7_UM                ,Nil})

            SA5->(DbSetOrder(14))
            If !SA5->( dbSeek( xFilial( "SA5" ) + cFornece + cLoja + aC_XML[ nx, nPCod ] ) ) 
 
                SA5->( DbSetOrder( 1 ))   //Filial + Fornecedor + loja + Produto
                If !SA5->( dbSeek( xFilial( "SA5" ) + cFornece + cLoja + cCodProd ) )   // Se nใo existe no cadastro de Amarra็ใo produto x fornecedor
                    nOpc := 3           // Fazer a inclusใo
                    aadd( aRotAuto,{ "A5_NOMPROD" , SC7->C7_DESCRI	, Nil } )       // Pega a descri็ใo do Produto no Pedido de Compra
                Else
                    nOpc := 4           // Fazer altera็ใo
                Endif

                cCaption := "Confirma็ใo"
                cMsg     := "Deseja criar amarra็ใo produto x fornecedor para o Produto: " + cCodProd + "Cod Prod Forn: " + aC_XML[ nx, nPCod ]
                
                If !lCriaSA5   //nao cria automatico pergunta
	                If ApMsgNoYes(cMsg, cCaption)    // Se confirmado
	                    
    	                aRotAuto := {}
        	            aadd ( aRotAuto, {"A5_FORNECE", cFornece            ,Nil})
            	        aadd ( aRotAuto, {"A5_LOJA"   , cLoja               ,Nil})
                	    aadd ( aRotAuto, {"A5_PRODUTO", cCodProd            ,Nil})
                    	aadd ( aRotAuto, {"A5_CODPRF" , aC_XML[ nx, nPCod ] ,Nil})
                    
	                    Begin Transaction
    	                    DbSelectArea("SA5")
        	                DbSeek(xFilial("SA5")) 
            	            MsExecAuto( { |x,y| MATA060(x,y)} , aRotAuto, nOpc)  
                	        If lMsErroAuto
                    	        MostraErro()
                        	    DisarmTransaction()
	                        Else
    	                        Alert("Amara็ใo Produto x Fornecedor efetuada com sucesso!")
        	                Endif 
            	        End Transaction
                     Endif
                Else    //cria Sa5 automaticamente sem perguntar
    	                aRotAuto := {}
        	            aadd ( aRotAuto, {"A5_FORNECE", cFornece            ,Nil})
            	        aadd ( aRotAuto, {"A5_LOJA"   , cLoja               ,Nil})
                	    aadd ( aRotAuto, {"A5_PRODUTO", cCodProd            ,Nil})
                    	aadd ( aRotAuto, {"A5_CODPRF" , aC_XML[ nx, nPCod ] ,Nil})
                    
	                    Begin Transaction
    	                    DbSelectArea("SA5")
        	                DbSeek(xFilial("SA5")) 
            	            MsExecAuto( { |x,y| MATA060(x,y)} , aRotAuto, nOpc)  
                	        If lMsErroAuto
                    	        MostraErro()
                        	    DisarmTransaction()
        	                Endif 
            	        End Transaction
                Endif

            Endif
            
		Elseif UZQ->UZQ_TIPO ==  "NFE"
			Alert( "PC " + aC_XML[ nx, nPPedido ] + "-" + aC_XML[ nx, nPItemPc ] + " Nใo encontrado. Cadastre a amarra็ใo produto x fornecedor para o produto: " + aC_XML[ nx, nPCod ] + " ou selecione um Pedido de Compra." )
			Return( Nil )
			
		Else   
		
			cCodProd := PadR( GetMv("MV_XMPRODFR"), TamSX3( "B1_COD" )[1] )
		
		Endif

	Endif
    
    If SB1->(FieldPos("B1_ULOTE")) > 0  //TRATAMENTO LOTE PARA CLIENTE ANDRA
       If Posicione( "SB1", 1, xFilial( "SB1" ) + cCodProd, "B1_ULOTE" )  == "S"
          MsgAlert("Nota Fiscal possui itens com controle de Lote, nใo possivel importa็ใo !!!")
          Return( Nil )  
       Endif
    Endif

    aadd( aLinha, { "D1_ITEM"  		, aC_XML[ nx, nPItem ]		, Nil } ) 
 	aadd( aLinha, { "D1_COD"   		, cCodProd					, Nil } )
	aadd( aLinha, { "D1_QUANT" 		, aC_XML[ nx, nPQuant ]		, Nil } )
	
	if !empty(_aResps)
	
		if !empty(_aResps[01]) 
		
			aadd( aLinha, { "D1_TES", _aResps[01] , Nil } )
		
		Endif
	
	Endif
	
	aadd( aLinha, { "D1_VUNIT" 		, aC_XML[ nx, nPVUnit ]		, Nil } )
	aadd( aLinha, { "D1_TOTAL" 		, aC_XML[ nx, nPTotal ]		, Nil } )
	aadd( aLinha, { "D1_VALDESC" 	, aC_XML[ nx, nPValDesc ]	, Nil } ) 
	aadd( aLinha, { "D1_VEND" 		, ""						, Nil } ) 
	
    If !Empty(cPedCompra) .and. !Empty(cItemPC)
        aadd( aLinha,{ "D1_PEDIDO" 	, cPedCompra	,Nil})
        aadd( aLinha,{ "D1_ITEMPC" 	, cItemPC   	,Nil})
    Endif

	aAdd( aItens, aLinha ) 
	aLinha := {}

Next

Begin Transaction

	lMSHelpAuto	:= .T.
	lMsErroAuto := .F. 
    MSExecAuto({|x,y,z| MATA140(x,y,z)},aCabec,aItens,3)
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
	Else
		RecLock( "UZQ", .F. )
		UZQ_STATUS 	:= IF ( UZQ->UZQ_TIPO == 'NFE', "2" , "6" )
		UZQ_NFGER	:= SF1->F1_DOC
		UZQ_SERGER	:= SF1->F1_SERIE
		UZQ_CODFOR	:= SF1->F1_FORNECE
		UZQ_LOJFOR	:= SF1->F1_LOJA
		MsUnLock()
	EndIf

End Transaction

	
Return( Nil )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ ANFAT03B        บAutorณ Antonio Marcos Andriani    บ Data ณ 14/02/2012 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Rotina para permitir ao usuario selecionar um item do Pedido de        บฑฑ
ฑฑบ         ณ Compras relacionado ao item da Nota Fiscal de Entrada.                 บฑฑ
ฑฑบ         ณ ( Selecao somente por item )                                           บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe  ณ U_ANFAT03B( ExpO1, ExpC2, ExpC3 )                                      บฑฑ
ฑฑบSintaxe  ณ U_ANFAT03B( ExpO1, ExpC2, ExpC3 )                                      บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametr ณ ExpO1 = Objeto GetDados conteundo dados do XML da Nota Fiscal          บฑฑ
ฑฑบ         ณ ExpC2 = Codigoo do Fornececedor                                        บฑฑ
ฑฑบ         ณ ExpC3 = Codigo da Loja                                                 บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Generico                                                               บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ANFAT03B( oGdXml, cFornece, cLoja )   

	Local cTitulo		:= "Selecionar Pedido de Compras ( por item )"
	Local oDlg     		:= Nil
	Local oLbx     		:= Nil
	Local nPCodProdF	:= aScan( oGdXml:aHeader,{ |x| Alltrim(Upper(x[2]))=="D1_COD" } )
	Local nPPcXml     	:= aScan( oGdXml:aHeader, {|x| Alltrim(Upper(x[2]))=="D1_PEDIDO" } )
	Local nPItXml		:= aScan( oGdXml:aHeader, {|x| Alltrim(Upper(x[2]))=="D1_ITEMPC" } ) 
	Local nPosDprod     := aScan( oGdXml:aHeader, {|x| Alltrim(Upper(x[2]))=="B1_DESC" } ) 
	Local aVetor		:= {}
	Local nOpcao		:= 0
	Local nLin			:= 0
	Local aButtons		:= { { 'PESQUISA', { || A103VisuPC( aVetor[oLbx:nAt,14]) }, "Visualiza Pedido" } }

	Private n 			:= 1

		
	If nPCodProdF > 0 .and. !Empty( oGdXml:aCols[ oGdXml:nAt, nPCodProdF ] )

		/***********************************************************************************************************
		* Alterado para buscar todos os pedidos do fornecedor caso nใo encontrado em amarra็ใo produto x fornecedor
		* Robson Santos - Call System - 20/06/2012
		***********************************************************************************************************/
		
		//SA5->( DbOrderNickName("FORCODPRF") )
		SA5->(DbSetOrder(14))
		If !SA5->( dbSeek( xFilial( "SA5" ) + cFornece + cLoja + oGdXml:aCols[ oGdXml:nAt, nPCodProdF ] ) )
			//Alert( "Produto nใo localizado na Tabela de Produto x Fornecedor!!!!" )
			//Return( Nil )
            //Endif

			dbSelectArea( "SC7" )
			dbSetOrder( 17 )	// C7_FILIAL + C7_FORNECE + C7_LOJA + C7_PRODUTO

			If SC7->( dbSeek( xFilial( "SC7" ) + cFornece + cLoja ) )

				Do While SC7->( !Eof() ) .and. xFilial( "SC7" ) == SC7->C7_FILIAL .and. SC7->C7_FORNECE == cFornece .and. SC7->C7_LOJA == cLoja
				   
				    //Se PC jแ nใo estiver na lista e se pedido nใo encerrado.
					If ( (( nPos := aScan( oGdXml:aCols, {|x| x[nPPcXml]+x[nPItXml]==SC7->C7_NUM+SC7->C7_ITEM } ) ) == 0 ) .OR.;
						 ( nPos > 0 .and. nPos == oGdXml:nAt )) .AND. SC7->C7_RESIDUO <> "S" .AND. SC7->C7_QUJE < SC7->C7_QUANT
					
						aAdd( aVetor, {	SC7->C7_NUM,;
										SC7->C7_TIPO,;
										SC7->C7_ITEM,;
										SC7->C7_PRODUTO,;
										SC7->C7_UM,;
										SC7->C7_SEGUM,;
										SC7->C7_QUJE,;
										SC7->C7_QUANT,;
										SC7->C7_LOCAL,;
										SC7->C7_OBS,;
										SC7->C7_LOJA,;
										SC7->C7_DESCRI,;
										SC7->C7_DESC,;
										SC7->( RECNO() ) } )
				
					Endif
					
					SC7->( dbSkip() )
			
				Enddo
			
			Endif
		Else
			
			dbSelectArea( "SC7" )
			dbSetOrder( 2 )	// C7_FILIAL + C7_PRODUTO + C7_FORNECE + C7_LOJA + C7_NUM

			If SC7->( dbSeek( xFilial( "SC7" ) + SA5->A5_PRODUTO + cFornece + cLoja ) )

				Do While SC7->( !Eof() ) .and. xFilial( "SC7" ) == SC7->C7_FILIAL .and. SC7->C7_PRODUTO == SA5->A5_PRODUTO .and. ;
						 SC7->C7_FORNECE == cFornece .and. SC7->C7_LOJA == cLoja
				   
					//Se PC jแ nใo estiver na lista e se pedido nใo encerrado.
					If (( ( nPos := aScan( oGdXml:aCols, {|x| x[nPPcXml]+x[nPItXml]==SC7->C7_NUM+SC7->C7_ITEM } ) ) == 0 ) .OR.;
						( nPos > 0 .and. nPos == oGdXml:nAt )) .AND. SC7->C7_RESIDUO <> "S" .AND. SC7->C7_QUJE < SC7->C7_QUANT
					
						aAdd( aVetor, {	SC7->C7_NUM,;
										SC7->C7_TIPO,;
										SC7->C7_ITEM,;
										SC7->C7_PRODUTO,;
										SC7->C7_UM,;
										SC7->C7_SEGUM,;
										SC7->C7_QUJE,;
										SC7->C7_QUANT,;
										SC7->C7_LOCAL,;
										SC7->C7_OBS,;
										SC7->C7_LOJA,;
										SC7->C7_DESCRI,;
										SC7->C7_DESC,;
										SC7->( RECNO() ) } )
				
					Endif
					
					SC7->( dbSkip() )
			
				Enddo
			
			Endif
		Endif
	Endif


	If Len( aVetor ) > 0 
	
		// ordenando por numero do pedido de compra + item
		aSort(aVetor ,,, {|x,y| x[1] + x[4] + x[3]  > y[1] + y[4] + y[3] } )

		//+-----------------------------------------------+
		//| Monta a tela para usuario visualizar consulta |
		//+-----------------------------------------------+
		DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 241,500 PIXEL
										
		@ 15,02 LISTBOX oLbx FIELDS HEADER 	"Numero PC", "Tipo", "Item", "Produto", "Unidade", "Segunda UM", "Quantidade Entregue", "Quantidade", "Armazem", "Observacoes", ;
										"Loja", "Descricao", "% Desc Item", "Uso sistema" SIZE 245,105 OF oDlg PIXEL	

		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| {	aVetor[oLbx:nAt,1],;
							aVetor[oLbx:nAt,2],;
							aVetor[oLbx:nAt,3],;
							aVetor[oLbx:nAt,4],;
							aVetor[oLbx:nAt,5],;
							aVetor[oLbx:nAt,6],;
							aVetor[oLbx:nAt,7],;
							aVetor[oLbx:nAt,8],;
							aVetor[oLbx:nAt,9],;
							aVetor[oLbx:nAt,10],;
							aVetor[oLbx:nAt,11],;
							aVetor[oLbx:nAt,12],;	                   	
							aVetor[oLbx:nAt,13],;
							aVetor[oLbx:nAt,14]	}}
								
		ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, {|| nOpcao:=1, nLin := oLbx:nAt, oDlg:End() }, {|| oDlg:End()},,aButtons )
		
		If nOpcao == 1
		
			oGdXml:aCols[ oGdXml:oBrowse:nAt, nPPcXml ] := aVetor[nLin,1]
			oGdXml:aCols[ oGdXml:oBrowse:nAt, nPItXml ] := aVetor[nLin,3]
			oGdXml:oBrowse:Refresh()

        Endif

    Else

        Alert( "Nenhum pedido de compra para o item: " + Alltrim(oGdXml:aCols[ oGdXml:nAt, nPCodProdF ])+ " - " +;
           		Alltrim(oGdXml:aCols[ oGdXml:nAt,nPosDprod ]) + ", foi encontrado !" )

	Endif	

Return( Nil )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ ANFAT03C        บAutorณ Antonio Marcos Andriani    บ Data ณ 14/02/2012 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Rotina para permitir ao usuario selecionar um Pedido de Compras        บฑฑ
ฑฑบ         ณ relacionado os itens do PC aos itens da Nota Fiscal de Entrada.        บฑฑ
ฑฑบ         ณ ( Selecao somente por Pedido de Compras )                              บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe  ณ U_ANFAT03C( ExpO1, ExpC2, ExpC3 )                                      บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametr ณ ExpO1 = Objeto GetDados conteundo dados do XML da Nota Fiscal          บฑฑ
ฑฑบ         ณ ExpC2 = Codigoo do Fornececedor                                        บฑฑ
ฑฑบ         ณ ExpC3 = Codigo da Loja                                                 บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Generico                                                               บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ANFAT03C( oGdXml, cFornece, cLoja )  

Local cTitulo		:= "Selecionar Pedido de Compra"
Local oDlg     		:= Nil
Local oLbx     		:= Nil
Local oOk  			:= LoadBitmap( GetResources(), "CHECKED" )
Local oNo      		:= LoadBitmap( GetResources(), "UNCHECKED" ) 
Local nPCodProdF	:= aScan( oGdXml:aHeader, { |x| Alltrim( Upper( x[2] )) == "D1_COD" } )
Local nPPcXml     	:= aScan( oGdXml:aHeader, { |x| Alltrim( Upper( x[2] )) == "D1_PEDIDO" } )
Local nPItXml		:= aScan( oGdXml:aHeader, { |x| Alltrim( Upper( x[2] )) == "D1_ITEMPC" } )
Local aVetor		:= {}
Local nOpcao		:= 0
Local nLin			:= 0
Local aButtons		:= { { 'PESQUISA', { || A103VisuPC( aVetor[oLbx:nAt,6]) }, "Visualiza Pedido" } }

Private n 			:= 1

If nPCodProdF > 0 .and. !Empty( oGdXml:aCols[ oGdXml:nAt, nPCodProdF ] ) 

	//SA5->( DbOrderNickName("FORCODPRF") )A5_FILIAL+A5_FORNECE+A5_LOJA+A5_CODPRF                                                                                                                          
	SA5->(DbSetOrder(14))
	If !SA5->( dbSeek( xFilial( "SA5" ) + cFornece + cLoja + oGdXml:aCols[ oGdXml:nAt, nPCodProdF ] ) )
		Alert( "Produto nใo localizado na Tabela de Produto x Fornecedor!!!!" )
		Return( Nil )
	Endif

	dbSelectArea( "SC7" )
	dbSetOrder( 6 )	// C7_FILENT, C7_PRODUTO, C7_FORNECE, C7_LOJA, C7_NUM, R_E_C_N_O_, D_E_L_E_T_

	If SC7->( dbSeek( xFilial( "SC7" ) + SA5->A5_PRODUTO + cFornece + cLoja ) )

		Do While SC7->( !Eof() ) .and. xFilial( "SC7" ) == SC7->C7_FILIAL .and. SC7->C7_PRODUTO == SA5->A5_PRODUTO .and. ;
		         SC7->C7_FORNECE == cFornece .and. SC7->C7_LOJA == cLoja
           
			If ( ( nPos := aScan( aVetor, {|x| x[3]==SC7->C7_NUM } ) ) == 0 )
			
				aAdd( aVetor, { .F.,;
								SC7->C7_LOJA,;
								SC7->C7_NUM,;
								SC7->C7_EMISSAO,;
								SC7->C7_ORIGEM,;
		    					SC7->( RECNO() ) } )
		
			Endif
			
			SC7->( dbSkip() )
	
		Enddo
	
	Endif

Endif


If Len( aVetor ) > 0

	//+-----------------------------------------------+
	//| Monta a tela para usuario visualizar consulta |
	//+-----------------------------------------------+
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 241,500 PIXEL
									
	@ 15,02 LISTBOX oLbx FIELDS HEADER 	"", "Loja", "Numero PC", "Emissao", "Origem", "Uso sistema" SIZE 245,105 OF oDlg PIXEL ;
	ON dblClick( aVetor[oLbx:nAt][1] := !aVetor[oLbx:nAt][1], oLbx:Refresh() )

	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
	                   	aVetor[oLbx:nAt,2],;
	                   	aVetor[oLbx:nAt,3],;
	                  	aVetor[oLbx:nAt,4],;
	                   	aVetor[oLbx:nAt,5],;
	                   	aVetor[oLbx:nAt,6] } }
		                    
	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar( oDlg, {|| nOpcao:=1, nLin := oLbx:nAt, oDlg:End() }, {|| oDlg:End()},,aButtons )
	
    //	If nOpcao == 1
	//
	//	oGdXml:aCols[ oGdXml:oBrowse:nAt, nPPcXml ] := aVetor[nLin,1]
	//	oGdXml:aCols[ oGdXml:oBrowse:nAt, nPItXml ] := aVetor[nLin,3]
	//  oGdXml:oBrowse:Refresh()
	//  Endif
	
Else

	Alert( "Nenhuma informacao foi localizada!!!" )

Endif	

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ HeaderXml       บAutorณ Antonio Marcos Andriani    บ Data ณ 14/02/2012 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Cria o aHeader para uso no objeto MsNewGetDados de apresntacao das     บฑฑ
ฑฑบ         ณ informacoes do XML da Nota Fiscal de Entrada.                          บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Generico                                                               บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function HeaderXml()
Local aH := {}

aHeader := {}
AADD( aH, { RetTitle( "D1_ITEM" )		, "D1_ITEM"  	,  PesqPict("SD1","D1_ITEM" )		, TamSX3( "D1_ITEM" )[1]	, TamSX3( "D1_ITEM" )[2]	, ".F."	, "", "C"	,, "V",,,, "V"  } )
AADD( aH, { RetTitle( "D1_COD" ) 		, "D1_COD"     	,  PesqPict("SD1","D1_COD" )		, TamSX3( "D1_COD" )[1]		, TamSX3( "D1_COD" )[2]		, ""	, "", "C"	,, "V",,,, "V"  } )
AADD( aH, { RetTitle( "B1_DESC" )  		, "B1_DESC"     ,  PesqPict("SB1","B1_DESC" )		, TamSX3( "B1_DESC" )[1]	, TamSX3( "B1_DESC" )[2]	, ".F."	, "", "C"	,, "V",,,, "V"  } )
AADD( aH, { RetTitle( "D1_QUANT" ) 		, "D1_QUANT"    ,  PesqPict("SD1","D1_QUANT" )		, TamSX3( "D1_QUANT" )[1]	, TamSX3( "D1_QUANT" )[2]	, ".F."	, "", "N"	,, "V",,,, "V"  } )
AADD( aH, { RetTitle( "D1_VUNIT" ) 		, "D1_VUNIT"    ,  "@E 9,999,999.9999"				, 14						, 4							, ".F."	, "", "N"	,, "V",,,, "V"  } )
AADD( aH, { RetTitle( "D1_TOTAL" ) 		, "D1_TOTAL"    ,  PesqPict("SD1","D1_TOTAL" )		, TamSX3( "D1_TOTAL" )[1]	, TamSX3( "D1_TOTAL" )[2]	, ".F."	, "", "N"	,, "V",,,, "V"  } )
AADD( aH, { RetTitle( "D1_VALDESC" )	, "D1_VALDESC"	,  PesqPict("SD1","D1_VALDESC" )	, TamSX3( "D1_VALDESC" )[1]	, TamSX3( "D1_VALDESC" )[2]	, ".F."	, "", "N"	,, "V",,,, "V"  } )
AADD( aH, { RetTitle( "D1_PEDIDO" )		, "D1_PEDIDO"	,  PesqPict("SD1","D1_PEDIDO" )		, TamSX3( "D1_PEDIDO" )[1]	, TamSX3( "D1_PEDIDO" )[2]	, ".F."	, "", "C"	,, "V",,,, "V"  } )
AADD( aH, { RetTitle( "D1_ITEMPC" )		, "D1_ITEMPC"	,  PesqPict("SD1","D1_ITEMPC" )		, TamSX3( "D1_ITEMPC" )[1]	, TamSX3( "D1_ITEMPC" )[2]	, ".F."	, "", "C"	,, "V",,,, "V"  } )

Return( aH )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ ColsXml         บAutorณ Antonio Marcos Andriani    บ Data ณ 14/02/2012 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Cria o aCols a ser usado no objeto MsNewGetDados de apresentacao das   บฑฑ
ฑฑบ         ณ informacoes do XML da Nota Fiscal de Entrada.                          บฑฑ
ฑฑบ         ณ                                                                        บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe  ณ ColsXml( ExpA1, ExpO2 )                                                บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametr ณ ExpA1 = aHeader com campos do objeto MsNewGetDados.                    บฑฑ
ฑฑบ         ณ ExpO2 = Objeto contendo o arquivo XML da Nota Fiscal de Entrada.       บฑฑ
ฑฑบ         ณ                                                                        บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Generico                                                               บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ColsXml( aHeader, oXml, _lNFe )  

Local aC     	:= {}
Local aColsRet  := {}
Local aArea  	:= GetArea()
Local nx		:= 0
Local oDet		:= if ( _lNFe, oXml:_NFEPROC:_NFE:_INFNFE:_DET, OXML:_CTEPROC:_CTE:_INFCTE )
Private oBkpDet

For nx := 1 to Iif( ValType( oDet ) == "A", Len( oDet ), 1 )

	If ( Valtype( oDet ) == "A" )
        
        oBkpDet:= oDet[nx]   //coloco em outra variavel para poder utilizar a funcao Type e verificar se a tag existe
        
		aAdd( aC, StrZero( nx, TamSX3( "D1_ITEM" )[1] ) )
		//aAdd( aC, PadR( oDet[nx]:_PROD:_CPROD:TEXT, TamSX3( "D1_COD" )[1], " " ) )
		aAdd( aC, PadR( oDet[nx]:_PROD:_CPROD:TEXT, TamSX3( "A5_CODPRF" )[1], " " ) )  // Considerar tamanho do campo do produto do fornecedor na amarra็ใo produto x fornecedor
		aAdd( aC, PadR( oDet[nx]:_PROD:_XPROD:TEXT, TamSX3( "B1_DESC" )[1], " " ) )	
		aAdd( aC, Val( oDet[nx]:_PROD:_QTRIB:TEXT) )	
		aAdd( aC, Val( oDet[nx]:_PROD:_VUNCOM:TEXT) )			
		aAdd( aC, Val( oDet[nx]:_PROD:_VPROD:TEXT) )				
	    aAdd( aC, Iif( Valtype( XmlChildEx( oDet[nx]:_PROD, "_VDESC" ) ) == "U", 0 , Val( oDet[nx]:_PROD:_VDESC:TEXT ) ) )  
	    
        IF Type("oBkpDet:_PROD:_XPED")<>"U"
		    aAdd( aC, PadR( oDet[nx]:_PROD:_XPED:TEXT, TamSX3( "C7_NUM" )[1], " " ) )
		    IF Type("oBkpDet:_PROD:_NITEMPED")<>"U"
 			    aAdd( aC, STRZERO(VAL( oDet[nx]:_PROD:_nItemPed:TEXT),TamSX3( "C7_ITEM" )[1]) )
            ELSE                                                                           
                aAdd( aC, SPACE(TamSX3( "C7_ITEM" )[1]) )
 	        ENDIF
        ELSE
		    aAdd( aC, Space( TamSX3( "C7_NUM" )[1] ) )
		    aAdd( aC, Space( TamSX3( "C7_ITEM" )[1] ) )
        ENDIF
		aAdd( aC, .F. )

	Else
	
		if _lNFe
		
			aAdd( aC, StrZero( nx, TamSX3( "D1_ITEM" )[1] ) )
			aAdd( aC, PadR( oDet:_PROD:_CPROD:TEXT, TamSX3( "A5_CODPRF" )[1], " " ) )  // Considerar tamanho do campo do produto do fornecedor na amarra็ใo produto x fornecedor
			aAdd( aC, PadR( oDet:_PROD:_XPROD:TEXT, TamSX3( "B1_DESC" )[1], " " ) )	
			aAdd( aC, Val( oDet:_PROD:_QTRIB:TEXT) )	
			aAdd( aC, Val( oDet:_PROD:_VUNCOM:TEXT) )			
			aAdd( aC, Val( oDet:_PROD:_VPROD:TEXT) )				
		    aAdd( aC, Iif( Valtype( XmlChildEx( oDet:_PROD, "_VDESC" ) ) == "U", 0 , Val( oDet:_PROD:_VDESC:TEXT ) ) )
		       
		    IF Type("oDet:_PROD:_XPED")<>"U"   
		    
	        	IF VALTYPE(oDet:_PROD:_XPED) <> "NIL"
			    	aAdd( aC, PadR( oDet:_PROD:_XPED:TEXT, TamSX3( "C7_NUM" )[1], " " ) )
			    	IF /*VALTYPE(oDet:_PROD:_NITEMPED) <> "NIL"*/ Type("oDet:_PROD:_NITEMPED")<>"U"
	 			    	aAdd( aC, STRZERO(VAL( oDet:_PROD:_nItemPed:TEXT),TamSX3( "C7_ITEM" )[1]) )
	            	ELSE                                                                           
	                	aAdd( aC, SPACE(TamSX3( "C7_ITEM" )[1]) )
	            	ENDIF
	            	
	            Else
	            
	            	aAdd( aC, Space( TamSX3( "C7_NUM" )[1] ) )
			    	aAdd( aC, Space( TamSX3( "C7_ITEM" )[1] ) ) 
	            	
	         	Endif
	        ELSE
			    aAdd( aC, Space( TamSX3( "C7_NUM" )[1] ) )
			    aAdd( aC, Space( TamSX3( "C7_ITEM" )[1] ) )
	        ENDIF
		
			
		Else 
		
			DbSelectArea("SB1")
     		DbSetorder(1)   
     		
 			if DbSeek( xFilial("SB1") + PadR( GetMv("MV_XMPRODFR"), TamSX3( "A5_CODPRF" )[1] ) ) .and. !empty(GetMv("MV_XMPRODFR"))  
 			
 				// Se encontrado e nใo estiver bloqueado
 				if SB1->B1_MSBLQL <> '1' 
      
		            aAdd( aC, StrZero( nx, TamSX3( "D1_ITEM" )[1] ) )
					aAdd( aC, SB1->B1_COD  ) 			 
					aAdd( aC, PadR( SB1->B1_DESC, TamSX3( "B1_DESC" )[1] ) )	
					aAdd( aC, 1 )
					aAdd( aC, Val( OXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT ) )			
					aAdd( aC, Val( OXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT ) )				
				    aAdd( aC, 0 )  
				    aAdd( aC, Space( TamSX3( "C7_NUM" )[1] ) )
			   		aAdd( aC, Space( TamSX3( "C7_ITEM" )[1] ) )
				    
				Else
				
					MsgStop ( "Produto Frete informado no parโmetro <MV_XMPRODFR> esta estแ bloqueado, favor vefificar !" ) 
				    
				Endif
			
			Else
			
				MsgStop ( "Produto Frete nใo encontrado, verifique o c๓digo informado no parโmetro <MV_XMPRODFR> estแ correto !" )
			
			Endif    
			   
		    
		Endif  
		
		if !empty(aC)
		
			aAdd( aC, .F. ) 
			
		Endif
	
	Endif
	
	if !empty(aC)
	
		aAdd( aColsRet, Ac )
		aC := {}  
		
	Endif

Next

Return( aColsRet ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autor  ณ Ivan de Oliveira ณ 		 Data ณ11/06/2012ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function C(nTam)   
	Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                               
	//ณTratamento para tema "Flat"ณ                                               
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)    

//____________________________________________________________________________//
// Fun็ใo para tratamento das regras de cores para a grid da MsNewGetDados
//____________________________________________________________________________// 
 
User Function _DefineCor( alinha, nLinha, aHeader,oGdXml ) 

/* 
Tabela de Cores Microsiga

#define CLR_BLACK             0       // RGB(   0,   0,   0 )
#define CLR_BLUE        8388608       // RGB(   0,   0, 128 )
#define CLR_GREEN        32768        // RGB(   0, 128,   0 )
#define CLR_CYAN        8421376       // RGB(   0, 128, 128 )
#define CLR_RED             128       // RGB( 128,   0,   0 )               	
#define CLR_MAGENTA     8388736       // RGB( 128,   0, 128 )
#define CLR_BROWN        32896        // RGB( 128, 128,   0 )
#define CLR_HGRAY      12632256       // RGB( 192, 192, 192 )
#define CLR_LIGHTGRAY CLR_HGRAY

//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ//
//                      High Intensity Colors
//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ//

#define CLR_GRAY        8421504       // RGB( 128, 128, 128 )
#define CLR_HBLUE      16711680       // RGB(   0,   0, 255 )
#define CLR_HGREEN        65280       // RGB(   0, 255,   0 )
#define CLR_HCYAN      16776960       // RGB(   0, 255, 255 )
#define CLR_HRED            255       // RGB( 255,   0,   0 )
#define CLR_HMAGENTA   16711935       // RGB( 255,   0, 255 )
#define CLR_YELLOW        65535       // RGB( 255, 255,   0 )
#define CLR_WHITE      16777215       // RGB( 255, 255, 255 )

*/

Local _nCorOk  := 16777215 // Branco -  RGB(255,255,255)
Local _nCorDiv := 65535 	// Amarelo - RGB(255,255,0) 
Local _lDiv    := .f. 
 
// Criando a lista de compara็๕es - Bloco do Pedido     
Local nPPcXml  := aScan( oGdXml:aHeader, {|x| Alltrim(Upper(x[2]))=="D1_PEDIDO" } )
Local nPItXml  := aScan( oGdXml:aHeader, {|x| Alltrim(Upper(x[2]))=="D1_ITEMPC" } ) 
Local nPCodProdF:= aScan( oGdXml:aHeader,{ |x| Alltrim(Upper(x[2]))=="D1_COD" } ) 
Local nPosDprod := aScan( oGdXml:aHeader, {|x| Alltrim(Upper(x[2]))=="B1_DESC" } ) 
Local _lCor2   := .f. 
Local _nRetCor := _nCorOk

if nLinha > 0 

 	// Verificando os conte๚dos
  	if Empty(aLinha[nLinha][nPPcXml]) .and. Empty(aLinha[nLinha][nPItXml]) 
  	
  		_nRetCor := _nCorDiv   
  		if  aScan( _aItErr, {|x|  x[01 ] == nLinha } ) == 0
	
	
	   		aadd ( _aItErr, { nLinha, ' ' ,Padr( 'Pedido Compra nใo associado', 32 ), ;
									   PadL( Left(Alltrim(aLinha[nLinha][nPCodProdF]) + ' ' + Alltrim(aLinha[nLinha][nPosDprod]),25 ), 25 ), ;
		 	                           PadL( "" , 25 )  } ) 
		 	                           
		Endif
		
	EndIf 

Endif
		   
Return _nRetCor     

//____________________________________________________________________________//
// Fun็ใo para tratamento das regras de cores para a grid da MsNewGetDados
//____________________________________________________________________________// 
 
User Function _ExibeLOG( aLinha, nLinha )    

	Local _cErro  := "+------------------------------+------------------------+-------------------------+" + chr(13)+chr(10)    
	Local _cErro  += ": Descri็ใo Erro               -           Conte๚do XML -        Conte๚do Sistema :" + chr(13)+chr(10) 
	Local _cErro  += "+------------------------------+------------------------+-------------------------+" + chr(13)+chr(10) 
	 
	_nPos := aScan( _aItErr,{|x| x[1] == nLinha } )
	
	if _nPos > 0
	
		// Construindo a exibi็ใo do LOG 
		for _i:= _nPos to len( _aItErr )  
		
			if _aItErr[_i][01] == nLinha
	
				_cErro += _aItErr[_i][03] + _aItErr[_i][04] + _aItErr[_i][05] + chr(13) + chr(10) 
				
			EndIf
			
		Next
		      
		// Exbindo erros
		EECVIEW( _cErro )
		
	Else
	                                                                                                   
		MsgInfo ( " Este item jแ esta associado com item de pedido de compra !" )
		
	EndIf
Return  


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณfuncion   ณ _Perg	   ณ autor ณ  ivan de oliveira     ณ data ณ31/07/13ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณdescrip.  ณ Perguntas dinโmicas para Tipo de Movimento e Dt.Inventแrio ณฑฑ
ฑฑณ          ณ 															  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ uso      ณ generico                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณparametrosณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
Static Function _Perg ( _nTipo )  

Local _aPergs := {} 
_aResps		  := {} 

Default _nTipo := 1    

if _nTipo == 1  
                 
	aAdd(_aPergs,{1,"TES (Entr) : ",Space(TamSX3("F4_CODIGO")[1]),"", "Existcpo('SF4').and.U__ValTpMov(1)","SF4",'.T.',20,.T.})
	
ElseIf _nTipo == 2    

 	aAdd( _aPergs,{ 1,"Data inicial ",Ctod(Space(8)),"","","","",50,.t.})
 	aAdd( _aPergs,{ 1,"Data final   ",Ctod(Space(8)),"","","","",50,.F.}) 
	
Endif
	
ParamBox(_aPergs,"Parโmetros", @_aResps,{|| if ( _nTipo == 2, U__ValTpMov(2), .t. ) },,,,,,,.F.,.F.)    

if !empty ( _aResps ) 

	if _nTipo == 1 

		MsgInfo ( "Serแ utilizada para todos os itens da Pr้-Nota ser gerada a TES:" + _aResps[01] ) 
		
	ElseIf _nTipo == 2 
		
	Endif 

Endif 
	
Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณfuncion   ณ _ValTpMovณ autor ณ  ivan de oliveira     ณ data ณ31/07/13  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณdescrip.  ณ Validar Tipos de Entrada/Saํda							  ณฑฑ
ฑฑณ          ณ 															  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ uso      ณ generico                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณparametrosณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/

User Function _ValTpMov(_nTipo)  

Local _lRet := .t.  

Default _nTipo := 1

if _nTipo == 1 

	if Val(SF4->F4_CODIGO) > 499   
	
		MsgAlert ( "Favor selecionar somente TES de Entrada ! ", "Aten็ใo" )
		_lRet := .F.
	
	Endif                                   
	
ElseIf _nTipo == 2 .and. len(_aResps) > 0

	if  _aResps[02]  <  _aResps[01]  
	
		MsgAlert ( "Data final nใo pode ser menor que a inicial ! ", "Aten็ใo" )
		_lRet := .F.
	
	Endif
 
Endif

Return _lRet         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออออออหอออออัออออออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณ ANFATLOT        บAutorณ iVAN de Oliveira    		 บ Data ณ 24/09/2013 บฑฑ
ฑฑฬอออออออออุอออออออออออออออออสอออออฯออออออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Gera Pr้ Notas por Lote ( Somente CTE )						         บฑฑ
ฑฑบ         ณ                                            							 บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe  ณ U_ANFATLOT()                                     						 บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametr ณ           															 บฑฑ
ฑฑบ         ณ                                       								 บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ Generico                                                               บฑฑ
ฑฑฬอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 บฑฑ
ฑฑฬอออออออออออออออัอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ  Programador  ณ  Data   ณ Motivo da Alteracao                                    บฑฑ
ฑฑฬอออออออออออออออุอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ               ณ         ณ                                                        บฑฑ
ฑฑศอออออออออออออออฯอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ANFATLOT 

Local _nQtErros := 0 
Local lZeraEsq  := SuperGetMV( "MV_XZERAE", .F.,  .T. )    
Local aLinha    := {}  
Local aItens    := {}        
Local _cCodProd := PadR( GetMv("MV_XMPRODFR"), TamSX3( "B1_COD" )[1] )         
Local _cCodTEs  := PadR( GetMv("MV_XMTESFR"),  TamSX3( "F4_CODIGO" )[1] )
Local _nCont    := 0     
Local oXml      := Nil 
 
Private _aResps := {} 
Private lMsHelpAuto := .t.  // direciona as mensagens de help para o arq. de log
Private lMsErroAuto := .f.

_Perg(2)  

// Verificando se existem os parโmetros necessแrios
_lExProd := !empty( Posicione( "SB1",1,  xFilial("SB1") + _cCodProd, "B1_COD" ))
_lExTes  := !empty( Posicione( "SF4" ,1, xFilial("SF4") + _cCodTEs , "F4_CODIGO") ) 

if _lExProd .and. SB1->B1_MSBLQL <> '1' .AND. SF4->F4_MSBLQL <> '1'.and.!empty(SB1->B1_COD)
 
	// Se foi validado as perguntas
	if !empty ( _aResps ) 
	
		if  MsgYesno ( "Serใo geradas pr้-notas dos XML referentes a CTE para o perํodo de: "  + Dtoc( _aResps[01]  ) + ' e '  + Dtoc( _aResps[02] ) + chr(13) + chr(13) +;
		               "Confima? " )  
		               
			dbSelectArea("UZQ") 
			UZQ->(dbSetOrder(4))
			UZQ->(dbSeek( xFilial("UZQ") + 'CTE' + Padr( ' ', TamSX3( "F4_CODIGO" )[1] )))
			
			// Sele็ใo registros
			While !UZQ->(Eof()) .And. UZQ->UZQ_FILIAL == xFilial("UZQ") .And. UZQ->UZQ_TIPO == 'CTE' .and. Empty(UZQ->UZQ_NFGER);
			                    .and. UZQ->UZQ_DTNF  >= _aResps[01]   .and. UZQ->UZQ_DTNF <= _aResps[02] 
			                    
				// Somente NFE AUTORIZADAS
				if  UZQ->UZQ_STATUS == '1' 
			       
					cFileXml := Alltrim( Lower( UZQ->UZQ_LOCARQ ) )
					cMsg	 := ""
					       
					MsAguarde( { || oXml := U_LerXml( cFileXml, @cMsg ) }, "Aguarde!", "Lendo XML...", .T. )
		
					If !( ValType(oXml) == "O" ) .or. !Empty( cMsg )
		
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Envia email de aviso sobre o erro                                        ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						cAssunto	:= "ERRO - Rotina de Gera็ใo de Pr้-Nota"
						cMensagem	:= "Houve uma falha na tentativa de leitura do arquivo XML."  + CRLF 
						cMensagem	+= "Provavelmente existe um erro na estrutura do arquivo." + CRLF + CRLF
						cMensagem	+= "Ou arquivo nใo encontrado em: " + cFileXml
						Aviso(cAssunto, cMensagem , {"OK"})
					
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Envia mensagem de erro para o console do server Protheus                 ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						ConOut( "" )	
						ConOut( cAssunto )
						ConOut( cMensagem )
						ConOut( "" )	
						_nQtErros++  
						
						if _nQtErros > 3
						                                                                                               
					   		if !MsgYesno ( "Estใo ocorrendo muitos erros de leitura de xml, deseja continuar ? ", "Aten็ใo " ) 
					   		
					   			_nQtErros := 0
					   			exit 
					   		
					 		Endif
					   		
					 	Endif
						
					Else   
					
						_cDoc := PadR( Alltrim( OXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT ), TamSX3("F1_DOC")[1], " " )    
			
		   				IF lZeraEsq
							_cDoc := StrZero(Val(_cDoc),TamSX3("F1_DOC")[1])  // Converte n๚mero da NF para 9 dํgitos com zeros เ esquerda
		   				ENDIF    
			
				   		_cSerie		:= PadR( OXML:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:TEXT, TamSX3("F1_SERIE")[1], " " )
		   				_dEmissao	:= Stod( StrTran( OXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT, "-", "" ) ) 
						_nDespesa	:= 0
					  	_cFornece	:= UZQ->UZQ_CODFOR
						_cLoja		:= UZQ->UZQ_LOJFOR
						_cEspecie	:= "CTE" 
		   				_cValor		:= Val(OXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT) 
			 			_cChaveNfe	:= Padr( Alltrim( OXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT ), TamSX3("UZQ_CHVNFE")[1], " " )  
			 			_cTipo	 	:= "N"
						_cFormul 	:= "N" 
	
						// Construindo o cabe็alho da NF
			 			aLinha      := {} 
			 			aCabec 		:= {}
						aadd( aCabec,{ "F1_TIPO"   	, _cTipo	, Nil } )
						aadd( aCabec,{ "F1_FORMUL" 	, _cFormul	, Nil } )
						aadd( aCabec,{ "F1_DOC"    	, _cDoc		, Nil } )
						aadd( aCabec,{ "F1_SERIE"  	, _cSerie	, Nil } )
						aadd( aCabec,{ "F1_EMISSAO"	, _dEmissao	, Nil } )
						aadd( aCabec,{ "F1_DESPESA"	, _nDespesa	, Nil } ) 
						aadd( aCabec,{ "F1_FORNECE"	, _cFornece	, Nil } )
						aadd( aCabec,{ "F1_LOJA"   	, _cLoja	, Nil } )
						aadd( aCabec,{ "F1_ESPECIE"	, _cEspecie	, Nil } )
						aadd( aCabec,{ "F1_COND"	, "001"		, Nil } )
						aadd( aCabec,{ "F1_CHVNFE"	, _cChaveNfe , Nil } )
			 			
			 		 	//Preenchendo a linha de itens da NF
			 			aadd( aLinha, { "D1_ITEM"  		, StrZero( 1, TamSX3( "D1_ITEM" )[1] )	, Nil } ) 
		 				aadd( aLinha, { "D1_COD"   		, _cCodProd				   				, Nil } )
						aadd( aLinha, { "D1_QUANT" 		, 1						   				, Nil } )   
						
						// Gravar com a TES se estiver parametrizado.
						if _lExTes  
							aadd( aLinha, { "D1_TES"	, _cCodTEs 				   				, Nil } )
						Endif  
						
						aadd( aLinha, { "D1_VUNIT" 		, _cValor	   			   				, Nil } )
		   				aadd( aLinha, { "D1_TOTAL" 		, _cValor	   			   				, Nil } )
						aadd( aLinha, { "D1_VALDESC" 	, 0						   				, Nil } ) 
						aadd( aLinha, { "D1_VEND" 		, ""									, Nil } ) 
				
						aAdd( aItens, aLinha ) 
						
						// Executando a inclusใo
						Begin Transaction
		
							lMSHelpAuto	:= .T.
							lMsErroAuto := .F.  
							
							MsAguarde( { || MSExecAuto({|x,y,z| MATA140(x,y,z)},aCabec,aItens,3) }, "Aguarde!", "Gerando Pr้-Notas...", .T. )
		   				   //	MSExecAuto({|x,y,z| MATA140(x,y,z)},aCabec,aItens,3)
		   					
							If lMsErroAuto
								DisarmTransaction()
								MostraErro()
		   					Else
								RecLock( "UZQ", .F. )
								UZQ_STATUS 	:= IF ( UZQ->UZQ_TIPO == 'NFE', "2" , "6" )
								UZQ_NFGER	:= SF1->F1_DOC
								UZQ_SERGER	:= SF1->F1_SERIE
								UZQ_CODFOR	:= SF1->F1_FORNECE
								UZQ_LOJFOR	:= SF1->F1_LOJA
								MsUnLock()
							EndIf
		
						End Transaction  
						
						_nCont++
		
					Endif  			
					
	 			Endif
	 				
	 			dbSelectArea("UZQ")   
	 			dbSkip()  
			
			Enddo  
			
			if _nCont > 0 .and. !lMsErroAuto
			
				MsgInfo( "Foram geradas: " + StrZero(_nCont,4) + " Pr้-Nota(s) com sucesso ! ", "Aten็ใo" )
			
			Else  
			
				MsgStop ( "Nenhuma Pr้-Nota foi gerada os parโmetros informados !", "Aten็ใo" )
			
			Endif
		               
		Endif
	
	Endif   
	                                                                                                                   	
Else   

 	if  !_lExTes  
	
		MsgStop ( "TES bloqueada, verifique o c๓digo informado no parโmetro <MV_XMTESFR> estแ correto !" )
	
	Elseif !_lExProd 
	
		MsgStop ( "Produto Frete nใo encontrado ou bloqueado, verifique o c๓digo informado no parโmetro <MV_XMPRODFR> estแ correto !" )
	
	Endif

Endif
	
Return

