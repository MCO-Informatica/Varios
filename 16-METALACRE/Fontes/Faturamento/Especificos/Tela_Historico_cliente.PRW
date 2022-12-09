#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"                                                                                                         
#INCLUDE "COLORS.CH"     
#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"   
//--------------------------------------------------------------
/*/{Protheus.doc} HISTCLI
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 06/11/2012
/*/
//--------------------------------------------------------------
User Function HISTCLI(cCod,cloj)
Local aArea := GetArea()
PRIVATE DADOS := TFont():New("Arial Narrow",,018,,.F.,,,,,.F.,.F.)
PRIVATE FntPsq := TFont():New("Arial",,016,,.F.,,,,,.F.,.F.)
PRIVATE rotulo := TFont():New("Arial",,019,,.F.,,,,,.F.,.F.)

PRIVATE btSair

PRIVATE gNomCli
PRIVATE cNomCli := "Define variable value"
PRIVATE gCodCli
PRIVATE cCodCli := "Define variable value"
PRIVATE oFolder1
PRIVATE cTransp := ""
PRIVATE oDlgHist                
Private cCliMts := Space(06)
Private cPedido := Space(06)
Private cPedCli := Space(15)
Private cProdut := Space(30)
Private cDescri := Space(30)
Private cTransp := Space(30)
Private cAplica := Space(30)
Private cPerson := Space(30)
Private	oWBrowse1
Private aWBrowse1 := {{'','','','','','','','','','','','','','','','','','','',''}}

if !Empty(cCod)
	DBSELECTAREA("SA1")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SA1") + PADR(CCOD,6) + cloj )
		cCodCli := SA1->A1_COD + "/" + SA1->A1_LOJA
		cNomCli := ALLTRIM(SA1->A1_NOME) 
	ENDIF

	  DEFINE MSDIALOG oDlgHist TITLE "Historico do Cliente" FROM 000, 000  TO 550, 1300 COLORS 0, 16777215 PIXEL
	
	    @ 007, 005 SAY  "Cliente:" SIZE 032, 012 OF oDlgHist FONT rotulo COLORS 0, 16777215 PIXEL
	    @ 007, 045 MSGET gCodCli VAR cCodCli SIZE 060, 012 WHEN .F. OF oDlgHist COLORS 0, 16777215 FONT DADOS PIXEL
	    @ 007, 115 MSGET gNomCli VAR cNomCli SIZE 385, 012 WHEN .F. OF oDlgHist COLORS 0, 16777215 FONT DADOS PIXEL
	    
	    @ 025, 005 SAY  "Pedido:" SIZE 032, 012 OF oDlgHist FONT FntPsq COLORS 0, 16777215 PIXEL
	    @ 025, 030 MSGET oPedido VAR cPedido Picture "@!" Valid(fWBrowse1()) SIZE 060, 012 OF oDlgHist COLORS 0, 16777215 FONT DADOS PIXEL
	    @ 025, 100 SAY  "Ped.Cli:" SIZE 032, 012 OF oDlgHist FONT FntPsq COLORS 0, 16777215 PIXEL
	    @ 025, 125 MSGET oPedCli VAR cPedCli Picture "@!" Valid(fWBrowse1()) SIZE 060, 012 OF oDlgHist COLORS 0, 16777215 FONT DADOS PIXEL
	    @ 025, 195 SAY  "Produto:" SIZE 032, 012 OF oDlgHist FONT FntPsq COLORS 0, 16777215 PIXEL
	    @ 025, 220 MSGET oProdut VAR cProdut Picture "@!" Valid(fWBrowse1()) SIZE 060, 012 OF oDlgHist COLORS 0, 16777215 FONT DADOS PIXEL
	    @ 025, 290 SAY  "Descr.:" SIZE 032, 012 OF oDlgHist FONT FntPsq COLORS 0, 16777215 PIXEL
	    @ 025, 315 MSGET oDescri VAR cDescri Picture "@!" Valid(fWBrowse1()) SIZE 060, 012 OF oDlgHist COLORS 0, 16777215 FONT DADOS PIXEL
	    @ 025, 385 SAY  "Transp:" SIZE 032, 012 OF oDlgHist FONT FntPsq COLORS 0, 16777215 PIXEL
	    @ 025, 410 MSGET oTransp VAR cTransp Picture "@!" Valid(fWBrowse1()) SIZE 060, 012 OF oDlgHist COLORS 0, 16777215 FONT DADOS PIXEL
	    @ 025, 475 SAY  "Aplic:" SIZE 032, 012 OF oDlgHist FONT FntPsq COLORS 0, 16777215 PIXEL
	    @ 025, 500 MSGET oAplica VAR cAplica Picture "@!" Valid(fWBrowse1()) SIZE 060, 012 OF oDlgHist COLORS 0, 16777215 FONT DADOS PIXEL
	    @ 025, 565 SAY  "Perso:" SIZE 032, 012 OF oDlgHist FONT FntPsq COLORS 0, 16777215 PIXEL
	    @ 025, 590 MSGET oPerson VAR cPerson Picture "@!" Valid(fWBrowse1()) SIZE 060, 012 OF oDlgHist COLORS 0, 16777215 FONT DADOS PIXEL

	    @ 050, 005 SAY  "Cliente MTS:" SIZE 060, 012 OF oDlgHist FONT FntPsq COLORS 0, 16777215 PIXEL
	    @ 050, 050 MSGET oCliMts VAR cCliMts Picture "@!" Valid(fWBrowse1()) SIZE 060, 012 OF oDlgHist COLORS 0, 16777215 FONT DADOS PIXEL

	    @ 075, 000 LISTBOX oWBrowse1 Fields HEADER "Pedido","Ped. Cliente","Qtde","Item","Descrição","Opcional PV","Vl Unitario","Entrega","Transportadora",'Tipo Frete',"CondPag","Personalização","Lacre Inicial","Lacre Final","Aplicacao Venda","Nota Fiscal", "Emissao NF", 'Codigo Mts','Loja Mts','Cliente MTS' SIZE 650, 190 OF oDlgHist FONT DADOS PIXEL 
	    
		oWBrowse1:LADJUSTCOLSIZE := .T.

	    fWBrowse1()
	    DEFINE SBUTTON btSair FROM 009, 518 TYPE 01 OF oDlgHist ENABLE ACTION Close(oDlgHist)
	
	  ACTIVATE MSDIALOG oDlgHist CENTERED

ELSE
	MSGALERT("CLIENTE NAO SELECIONADO.")
ENDIF
RestArea(aArea)
Return
//------------------------------------------------

//------------------------------------------------
Static Function fWBrowse1()
Local aAreaSA1	:=	SA1->(GetArea())

If Select("TMPT") <> 0
	TMPT->(dbCloseArea())
Endif

aWBrowse1 := {}

CQRY := " SELECT DISTINCT C6_CLI,C6_NUM,C6_ITEM, C6_QTDVEN,C6_PRODUTO,C6_DESCRI,C6_PRCVEN,C6_ENTREG,C5_TRANSP,C5_TPFRETE,C5_CONDPAG,C5_CLIMTS,C5_LOJMTS,E4_DESCRI,C6_XLACRE,ISNULL(Z02_DESC,'') Z02_DESC, C6_XINIC,C6_XFIM,C6_XAPLICA,C6_NOTA,C6_DATFAT,C6_PEDCLI,C6_OPC" 
CQRY += " FROM "+RETSQLNAME("SC5")+" SC5"
CQRY += " INNER JOIN "+RETSQLNAME("SC6")+" SC6"
CQRY += " ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND SC6.D_E_L_E_T_ ='' " 
CQRY += " INNER JOIN "+RETSQLNAME("SE4")+" SE4"
CQRY += " ON C5_FILIAL = E4_FILIAL AND E4_CODIGO = C5_CONDPAG AND SE4.D_E_L_E_T_='' "
CQRY += " LEFT JOIN "+RETSQLNAME("SA4")+" SA4" // 3L Systems - Utilizacao de Left Join Pois Existem Pedidos sem Transportadora - Luiz Alberto - 22-04-2014
CQRY += " ON A4_COD = C5_TRANSP  AND SA4.D_E_L_E_T_ =''  "
CQRY += " LEFT JOIN "+RETSQLNAME("Z02")+" Z02"
CQRY += " ON Z02_CODPER = C6_XLACRE AND Z02_CODCLI = C5_CLIENTE AND Z02_LOJACL = C5_LOJACLI AND Z02.D_E_L_E_T_=''  "
CQRY += " WHERE C6_CLI = '" + SA1->A1_COD + "' AND C6_LOJA = '" + SA1->A1_LOJA + "' "
CQRY += " AND SC5.D_E_L_E_T_=''"
CQRY += " AND SC5.C5_TIPO = 'N' "
If !Empty(cPedido)
	CQRY += " AND SC5.C5_NUM LIKE '%" + AllTrim(cPedido) + "%' "
Endif
If !Empty(cPedCli)
	CQRY += " AND SC6.C6_PEDCLI LIKE '%" + AllTrim(cPedCli) + "%' "
Endif
If !Empty(cProdut)
	CQRY += " AND SC6.C6_PRODUTO LIKE '%" + AllTrim(cProdut) + "%' "
Endif
If !Empty(cDescri)
	CQRY += " AND SC6.C6_DESCRI LIKE '%" + AllTrim(cDescri) + "%' "
Endif
If !Empty(cAplica)
	CQRY += " AND SC6.C6_XAPLICA LIKE '%" + AllTrim(cAplica) + "%' "
Endif
If !Empty(cPerson)
	CQRY += " AND SC6.C6_XLACRE LIKE '%" + AllTrim(cPerson) + "%' "
Endif
If !Empty(cCliMts)
	CQRY += " AND SC5.C5_CLIMTS LIKE '%" + AllTrim(cCliMts) + "%' "
Endif 
CQRY += " ORDER BY C6_NUM DESC"

TcQuery CQRY New Alias "TMPT"

Count To nReg

TMPT->(dbGoTop())

TcSetField( 'TMPT'	, "C6_ENTREG"	, "D", 08, 0 )             
TcSetField( 'TMPT'	, "C6_DATFAT"	, "D", 08, 0 )  
TcSetField( 'TMPT'	, "C6_PRCVEN"	, "N", 14, 6 )             
TcSetField( 'TMPT'	, "C6_QTDVEN"	, "N", 14, 0 )             
	
While TMPT->(!Eof())
	If SA4->(dbSetOrder(1), dbSeek(xFilial("SA4")+TMPT->C5_TRANSP))
 		_cTransp := SA4->A4_NOME
   	Else
    	_cTransp := ""
	EndIf                                                                      

	If !Empty(cTransp)
		If ! AllTrim(cTransp)$_cTransp     
			TMPT->(dbSkip(1));Loop
		Endif
	Endif
		
	cNomMts := ''
	If !Empty(TMPT->C5_CLIMTS)
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+TMPT->C5_CLIMTS+TMPT->C5_LOJMTS))
		cNomMts := SA1->A1_NOME
	Endif

    Aadd(aWBrowse1,{substr(TMPT->C6_NUM,1,6)    ,;
    				substr(TMPT->C6_PEDCLI,1,20) ,;
    				TMPT->C6_QTDVEN ,;
    				substr(alltrim(TMPT->C6_PRODUTO),1,15),;
    				SUBSTR(TMPT->C6_DESCRI,1,35),;
    				SUBSTR(TMPT->C6_OPC,1,20),;
    				TransForm(TMPT->C6_PRCVEN,'@E 9,999,999.9999') ,;
    				TMPT->C6_ENTREG,;
    				(TMPT->C5_TRANSP  + " - " + substr(_cTransp  ,1,20)  ),;
    				Iif(TMPT->C5_TPFRETE=='C','CIF','FOB'),;
    				(TMPT->C5_CONDPAG + " - " + SUBsTR(TMPT->E4_DESCRI,1,10)  ),;
    				(TMPT->C6_XLACRE + " - " + SUBsTR(TMPT->Z02_DESC,1,40)  ),;
    				TMPT->C6_XINIC  , ;
    				TMPT->C6_XFIM   ,;
    				substr(TMPT->C6_XAPLICA,1,15),;
   				 	substr(TMPT->C6_NOTA,1,9) , ;
    				TMPT->C6_DATFAT,;
    				TMPT->C5_CLIMTS,;                                                  
    				TMPT->C5_LOJMTS,;
	    			cNomMts  	}    )
		
	TMPT->(DBSKIP())
Enddo

If Empty(nReg)
	aWBrowse1 := {{'','','','','','','','','','','','','','','','','','','',''}}
Endif

oWBrowse1:SetArray(aWBrowse1)
oWBrowse1:bLine := {|| {;
							  aWBrowse1[oWBrowse1:nAt,1],;
						      aWBrowse1[oWBrowse1:nAt,2],;
						      aWBrowse1[oWBrowse1:nAt,3],;
						      aWBrowse1[oWBrowse1:nAt,4],;
						      aWBrowse1[oWBrowse1:nAt,5],;
						      aWBrowse1[oWBrowse1:nAt,6],;
						      aWBrowse1[oWBrowse1:nAt,7],;
						      aWBrowse1[oWBrowse1:nAt,8],;
						      aWBrowse1[oWBrowse1:nAt,9],;
						      aWBrowse1[oWBrowse1:nAt,10],;
						      aWBrowse1[oWBrowse1:nAt,11],;
						      aWBrowse1[oWBrowse1:nAt,12],;
						      aWBrowse1[oWBrowse1:nAt,13],;
						      aWBrowse1[oWBrowse1:nAt,14],;
						      aWBrowse1[oWBrowse1:nAt,15],;
						      aWBrowse1[oWBrowse1:nAt,16],;
						      aWBrowse1[oWBrowse1:nAt,17],;
						      aWBrowse1[oWBrowse1:nAt,18],;
						      aWBrowse1[oWBrowse1:nAt,19],;
						      aWBrowse1[oWBrowse1:nAt,20];
    }}
    // DoubleClick event
	oWBrowse1:nAt := 1
	oWBrowse1:Refresh()
	oDlgHist:Refresh()
	
RestArea(aAreaSA1)
Return