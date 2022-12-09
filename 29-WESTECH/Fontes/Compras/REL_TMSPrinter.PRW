#INCLUDE "RWMAKE.CH"
#include 'topconn.ch'
#INCLUDE "FONT.CH"
#INCLUDE "TOTVS.CH"

User Function PedComPo()

/*ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿ï¿½ï¿½
ï¿½ï¿½ï¿½Funï¿½ï¿½o    ï¿½PedComIR  ï¿½ Autor ï¿½Francisco Oliveira     ï¿½ Data ï¿½16.04.2010ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½
ï¿½ï¿½ï¿½Descriï¿½ï¿½o ï¿½Emitir pedido de compras com informaï¿½ï¿½o de inspeï¿½ï¿½o de      ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½recebimento    				                              ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½
ï¿½ï¿½ï¿½Parametrosï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½
ï¿½ï¿½ï¿½ Uso      ï¿½ Emitir pedido de compras                                   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½*/

Local nn
Local _cQueryPC := ""
Private aPerg :={}
Private cPerg := "PComPor"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa

fAjustaSx1()

Pergunte(cPerg,.t.)

If Select("PEDCOMIR") <> 0
	PEDCOMIR->( DbCLoseArea() )
End

Processa({|lEnd|MontaRel(),"Imprimindo Pedido Compras","AGUARDE.."})

Return Nil


//********************************************************************************************


Static Function MontaRel()

Local nD, nP , nC, _cObs
Local nValor 		:= 1
Private cTipoCont := ""
Private nTotalCom2 := 0
Private cRequer := ""
Private _cObsItem := ""
Private nCont  := 0
Private nCont1 := 1
Private Cont   := 1
Private Cont1  := 15
Private oPrint,oFont7,oFont7n,oFont8,oFont8n,oFont9,oFont9n,oFont10,oFont16,oFont16n,oFont20,oFont24,oFont9b
Private aDadosEmp	:=	{SM0->M0_NOMECOM,; //Nome da Empresa - 1
SM0->M0_ENDCOB ,; //Endereï¿½o - 2ï¿½
AllTrim(SM0->M0_BAIRCOB)+" - "+AllTrim(SM0->M0_CIDCOB)+" - " + SM0->M0_ESTCOB,;  // + " - " + SM0->M0_UFCOB,;//Complemento - 3
Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3),; //CEP - 4
SM0->M0_TEL,; //Telefones - 5
Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+; // CNPJ - 6
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+;
Subs(SM0->M0_CGC,13,2),; //CGC
Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+; // INSCR. ESTADUAL - 7
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3),;
Subs(SM0->M0_CIDENT,1,20)} //Cidade da

//Parï¿½metros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont7  := TFont():New("Calibri",8,7 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7n := TFont():New("Calibri",8,7 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8  := TFont():New("Calibri",8,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7a  := TFont():New("Arial",8,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7an  := TFont():New("Arial",8,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8n := TFont():New("Calibri",8,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Calibri",8,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9b := TFont():New("Calibri",8,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9n := TFont():New("Calibri",8,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Calibri",8,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11 := TFont():New("Calibri",8,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12 := TFont():New("Calibri",8,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13 := TFont():New("Calibri",8,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14 := TFont():New("Calibri",8,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Calibri",8,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Calibri",8,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20 := TFont():New("Calibri",8,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Calibri",8,24,.T.,.T.,5,.T.,5,.T.,.F.)
oFont28 := TFont():New("Calibri",8,28,.T.,.T.,5,.T.,5,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';

oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)

oPrint:= TMSPrinter():New("PedCom")
//oPrint:SetPortrait() // ou SetLandscape()
oPrint:SetLandScape()
oPrint:SetPaperSize(9)

/*//=========
oPrint := TmsPrinter():New()

oPrint:SetPortrait() ( Para Retrato) ou
oPrint:SetLandScape() ( Para Paisagem )

oPrint:SetPaperSize(1)     ( 1 - Carta ) ou
oPrint:SetPaperSize(9)     ( 9 - A4 )
//========*/


oPrint:Setup() // para configurar impressora

cFileLogo := "lgrl" + cEmpAnt + ".bmp"
DbSelectArea("SA2"); DbSetOrder(1)


cQuery := "SELECT C7_NUM, C7_FORNECE, C7_LOJA, C7_EMISSAO, C7_CONAPRO, C7_TOTAL, C7_ITEM, C7_PRODUTO, C7_QTSEGUM, C7_SEGUM, C7_IPI, C7_ALIQISS, C7_PICM, C7_XXDTREV, C7_ICMSRET, C7_CONTATO,"
cQuery += "       C7_COND, C7_TPFRETE, C7_FRETE, C7_CC, C7_CONTA, C7_DESCRI, C7_QUANT, C7_PRECO, C7_XXREV, C7_MOEDA, R_E_C_N_O_ NRECNO, ISNULL( CONVERT( VARCHAR(4096), CONVERT(VARBINARY(4096), C7_XNOTAS)),'') AS C7_XNOTAS,  "
cQuery += "       C7_DATPRF, C7_UM, C7_VALIPI, C7_USER, C7_APROV, C7_OBS, ISNULL( CONVERT( VARCHAR(4096), CONVERT(VARBINARY(4096), C7_XMEMO)),'') AS C7_XMEMO, C7_DESC, C7_NUMSC, C7_ITEMCTA, C7_MSG, C7_REAJUST, C7_DESPESA, C7_SEGURO, C7_VALFRE, C7_VLDESC "
cQuery += " FROM " + RetSQLName("SC7") + " SC7 "
cQuery += "WHERE C7_FILIAL = '" + XFILIAL("SC7") + "' AND "
cQuery += "C7_NUM     >= '" + MV_PAR01 + "' AND  "
cQuery += "C7_NUM     <= '" + MV_PAR02 + "' AND  "
cQuery += "C7_FORNECE >= '" + MV_PAR03 + "' AND  "
cQuery += "C7_FORNECE <= '" + MV_PAR04 + "' AND  "
cQuery += "C7_LOJA    >= '" + MV_PAR05 + "' AND  "
cQuery += "C7_LOJA    <= '" + MV_PAR06 + "' AND  "
//cQuery += "C7_EMISSAO >= '" + DTOS(MV_PAR07) + "' AND  "
//cQuery += "C7_EMISSAO <= '" + DTOS(MV_PAR08) + "' AND  "
//cQuery += "C7_PRODUTO >= '" + MV_PAR09 + "' AND  "
//cQuery += "C7_PRODUTO <= '" + MV_PAR10 + "' AND  "
cQuery += "C7_CONAPRO <> 'B' AND "
cQuery += "SC7.D_E_L_E_T_ <> '*'"
cQuery += "ORDER BY C7_NUM, C7_ITEM"
cQuery := ChangeQuery(cQuery)

dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cQuery),"PEDCOMIR", .F., .T.)
TcSetField( "PEDCOMIR", "C7_EMISSAO" , "D", 8, 0 )
// TcSetField( "PEDCOMIR", "C7_DATPRF"  , "D", 8, 0 )


DbSelectArea("PEDCOMIR")
DbGoTop()

_cObs := "1 - A mercadoria sera aceita somente se, na sua Nota Fiscal constar o numero do nosso Pedido de Compra."
//_cObs := "1 - Somente aceitaremos a mercadoria se a na sua Nota Fiscal constar o numero do nosso Pedido de Compras."

Do While !PEDCOMIR->(Eof())
	SA2->(DbSeek( xFilial("SA2") + PEDCOMIR->C7_FORNECE + PEDCOMIR->C7_LOJA) )
	cCodCredor 		:= alltrim(SA2->A2_COD)
	cLojaCredor		:= SA2->A2_LOJA
	cNomeCredor 	:= Alltrim(SA2->A2_NOME)
	cCGC        	:= SA2->A2_CGC
	cEnd        	:= Alltrim(SA2->A2_END)
	cBairro			:= Alltrim(SA2->A2_BAIRRO)
	cCidade			:= Alltrim(SA2->A2_MUN)
	cDDI			:= Alltrim(SA2->A2_DDI)
	cDDD			:= Alltrim(SA2->A2_DDD)
	cTel        	:= Alltrim(SA2->A2_TEL)
	cMun        	:= Alltrim(SA2->A2_MUN)
	cEst        	:= SA2->A2_EST
	cPAIS			:= SA2->A2_PAIS
	cEmail			:= Alltrim(SA2->A2_EMAIL)
	cCEP			:= Alltrim(SA2->A2_CEP)
	cINSCR			:= Alltrim(SA2->A2_INSCR)
	cINSCRM			:= Alltrim(SA2->A2_INSCRM)
	cTemCredor  	:= .T.
	cNaoBloqueado	:= .T.
	cTemCredor    	:= .F.
	cNumPed       	:= PEDCOMIR->C7_Num
	cCodFor       	:= PEDCOMIR->C7_Fornece
	cNumSC			:= PEDCOMIR->C7_NUMSC
	aDados        	:= {}
	cObserv       	:= PEDCOMIR->C7_OBS
	dDataEmi		:= PEDCOMIR->C7_EMISSAO
	nRevisao		:= PEDCOMIR->C7_XXREV
	dRevisao		:= PEDCOMIR->C7_XXDTREV
	cMoeda			:= PEDCOMIR->C7_MOEDA
	cContato		:= PEDCOMIR->C7_CONTATO
	//dDataEnt		:= PEDCOMIR->C7_DATPRF
	_cSolic__		:= Posicione("SC1",1,xFilial("SC1") + PEDCOMIR->C7_NUMSC,"C1_USER")
	_cCompr__		:= Posicione("SY1",3,xFilial("SY1") + PEDCOMIR->C7_USER,"Y1_NOME")
	_cCompr2__		:= Posicione("SY1",3,xFilial("SY1") + PEDCOMIR->C7_USER,"Y1_USER")
	_cAprov__		:= Posicione("SAK",1,xFilial("SAK") + PEDCOMIR->C7_APROV,"AK_NOME")
	nTotGeral 		:= 0
	nTotalIPI 		:= 0
	nTotalIPI 		:= 0
	nTotalDesc		:= 0
	nTotalDesp		:= 0
	nTotalSeg		:= 0
	nTotalFrete		:= 0
	nTotalProd		:= 0
	nTotalCom  		:= 0
	nSubTotal  		:= 0
	nTotalICMSRET	:= 0
	nTotPdSIPI		:= 0
	cCondPagto		:= Posicione("SE4",1,xFilial("SE4") + PEDCOMIR->C7_COND,"E4_DESCRI") 	//cCondPagto		:= PEDCOMIR->C7_COND + " - " + Posicione("SE4",1,xFilial("SE4") + PEDCOMIR->C7_COND,"E4_DESCRI")
	cTipoFrete		:= IF(PEDCOMIR->C7_TPFRETE = "F","FOB","CIF") +  Transform(PEDCOMIR->C7_FRETE,"@E 999,999.99")
	cFormula		:= Posicione("SM4",1,xFilial("SM4") + PEDCOMIR->C7_MSG,"M4_CODIGO")
	cFormula2		:= Posicione("SM4",1,xFilial("SM4") + PEDCOMIR->C7_REAJUST,"M4_CODIGO")
	cXMEMO       	:= MSMM(PEDCOMIR->C7_XMEMO)
	cXNOTAS       	:= MSMM(PEDCOMIR->C7_XNOTAS)

	

	//cProdIngles		:= Posicione("SB1",1,xFilial("SB1") + PEDCOMIR->C7_PRODUTO,"B1_XXDI")

		if substr(alltrim(PEDCOMIR->C7_ITEMCTA),1,2) $ "AT/PR/EN/EQ/GR/ST" 
			cRequer := "1"
		elseif alltrim(PEDCOMIR->C7_ITEMCTA) == "ESTOQUE" 
			cRequer := "1"
		elseif alltrim(PEDCOMIR->C7_ITEMCTA) $ "ADMINISTRACAO/QUALIDADE/ENGENHARIA/PROPOSTA/ATIVO/ZZZZZZZZZZZZZ/XXXXXX" .AND. EMPTY(cRequer)
			cRequer := "2"
		endif

	Do While !Eof() .And. PEDCOMIR->C7_NUM == cNumPed
		TcSetField( "PEDCOMIR", "C7_EMISSAO" , "D", 8, 0 )
		aAdd(aDados,{PEDCOMIR->C7_ITEM,;	// 1
		PEDCOMIR->C7_DATPRF,;          		// 2
		Trim(PEDCOMIR->C7_DESCRI),;      	// 3
		PEDCOMIR->C7_QUANT,;             	// 4
		PEDCOMIR->C7_PRECO,;              	// 5
		PEDCOMIR->C7_TOTAL,;             	// 6
		PEDCOMIR->C7_PRODUTO,;				// 7
		PEDCOMIR->C7_UM,;            		// 8
		PEDCOMIR->C7_VALIPI,;           	// 9
		PEDCOMIR->C7_DESC,;					// 10
		PEDCOMIR->C7_OBS,;                	// 11
		PEDCOMIR->C7_ITEMCTA,;            	// 12
		PEDCOMIR->C7_DESPESA,;            	// 13
		PEDCOMIR->C7_SEGURO,;            	// 14
		PEDCOMIR->C7_VALFRE,;            	// 15
		PEDCOMIR->C7_VLDESC,;            	// 16
		PEDCOMIR->C7_CC,;					// 17
		PEDCOMIR->C7_XXREV,;				// 18
		PEDCOMIR->C7_QTSEGUM,;				// 19
		PEDCOMIR->C7_SEGUM,;				// 20
		PEDCOMIR->C7_IPI,;					// 21
		PEDCOMIR->C7_PICM,;					// 22
		PEDCOMIR->C7_ALIQISS,;				// 23
		PEDCOMIR->C7_ICMSRET,;				// 24
		PEDCOMIR->C7_XMEMO,;				// 25
		PEDCOMIR->C7_XNOTAS})				// 26
		
		nTotalProd	+= PEDCOMIR->C7_TOTAL	//Totalizando Valor do produto
		nTotalDesc	+= PEDCOMIR->C7_VLDESC  //Totalizando Descontos
		nTotalDesp  += PEDCOMIR->C7_DESPESA // Totalizando Despesas
		nTotalSeg	+= PEDCOMIR->C7_SEGURO // Totalizando Seguro
		nTotalFrete	+= PEDCOMIR->C7_VALFRE // Totalizando Frete
		nTotalICMSRET += PEDCOMIR->C7_ICMSRET // Totalizando ICMS Retido
		//nTotalAcre	+= aDados[nP,]  //Totalizando Acrescimo
		nTotalProd	+= PEDCOMIR->C7_PRECO	//Totalizando Valor do produto
		nTotalCom	+= (PEDCOMIR->C7_TOTAL + PEDCOMIR->C7_VALIPI + PEDCOMIR->C7_SEGURO + PEDCOMIR->C7_DESPESA + PEDCOMIR->C7_VALFRE) - (PEDCOMIR->C7_VLDESC + PEDCOMIR->C7_ICMSRET)  // Totalizando Valor do pedido de compras
		nTotalIPI 	+= PEDCOMIR->C7_VALIPI // Totalizando IPI
		cXNOTAS		:= PEDCOMIR->C7_XNOTAS
		//nTotGeral += PEDCOMIR->C7_TOTAL + PEDCOMIR->C7_VALIPI  // Totalizando Valor do pedido de compras

		DbSkip()
	EndDo

	SET FILTER TO CTD->CTD_ITEM <> 'ADMINISTRACAO' .AND. CTD->CTD_ITEM<>'PROPOSTA' .AND. CTD->CTD_ITEM<>'QUALIDADE' .AND. CTD->CTD_ITEM<>'ATIVO' ;
			 .AND. CTD->CTD_ITEM<>'ENGENHARIA' .AND. CTD->CTD_ITEM<>'ZZZZZZZZZZZZZ' .AND. CTD->CTD_ITEM<>'XXXXXX' .AND. SUBSTR(CTD->CTD_ITEM,9,2) >= '15'
	
	nTotPdSIPI += (nTotalCom - nTotalIPI) - nTotalDesp - nTotalFrete

	//=================================== Conversão moeda
	//******************************
	dbSelectArea("SM2")
	//SM2->( dbSetOrder(1) )

	_cQuery := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY2"
	
	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())

	//*************************

		if cMoeda = 2
			dData := dDataEmi
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA2
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA2
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
				
			enddo
			nTotalCom2		:= nTotalCom * nValor
			
		elseif cMoeda= 3
			dData := dDataEmi
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA3
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA3
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
			enddo
			nTotalCom2		:= nTotalCom * nValor
		elseif cMoeda = 4
			dData := dDataEmi
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA4
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA4
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
			enddo
			nTotalCom2		:= nTotalCom * nValor
		else
			nTotalCom2		:= nTotalCom 
		endif
		QUERY2->( DbCloseArea() )
	//===================================
	//local de de entrega usando cadastro de formulas

	dbSelectArea("SM4")
	SM4->( dbSetOrder(1) )
	If SM4->( dbSeek( xFilial("SM4")+cFormula) )
		cCODIGO  := SUBSTR(SM4->M4_FORMULA,2,6)

		If SA2->( dbSeek( xFilial("SA2")+cCODIGO) )
			ccNREDUZ  	:= SA2->A2_NREDUZ
			ccEnd		:= SA2->A2_END
			ccBairro	:= SA2->A2_BAIRRO
			ccEst		:= SA2->A2_EST
			ccMun		:= SA2->A2_MUN
			ccCEP		:= SA2->A2_CEP
			ccPAIS		:= SA2->A2_PAIS
		ENDIF

	ENDIF

	If SM4->( dbSeek( xFilial("SM4")+cFormula2) )
		//msgAlert ( cFormula2 )
		cLinha1 := SM4->M4_XNOTAL1
		cLinha2 := SM4->M4_XNOTAL2
		cLinha3 := SM4->M4_XNOTAL3
		cLinha4 := SM4->M4_XNOTAL4
		cLinha5 := SM4->M4_XNOTAL5
		cLinha6 := SM4->M4_XNOTAL6
		cLinha7 := SM4->M4_XNOTAL7
		cLinha8 := SM4->M4_XNOTAL8
		cLinha9 := SM4->M4_XNOTAL9
		cLinha10 := SM4->M4_XNOTA10
		cLinha11 := SM4->M4_XNOTA11
		cLinha12 := SM4->M4_XNOTA12
		cLinha13 := SM4->M4_XNOTA13
		cLinha14 := SM4->M4_XNOTA14

	ENDIF
	
	
	//===================================

	IF cMoeda = 1
		varSimb := "R$"
	ELSEIF cMoeda = 2
		varSimb := "US$"
	ELSEIF cMoeda = 3
		varSimb := "UFIR"
	ELSEIF cMoeda = 4
		varSimb := "EUR"
	ENDIF

	nPos	:= 0
	lchk01	:= .T.
	nCont	:= 0
	//nCont := nCont + 1     //***************************

	_cObsItem	:= ""

	For nC := 1 to Len(aDados)
		If !Empty(aDados[nc,11])
			If lchk01
				_cObsItem	:= Alltrim(aDados[nc,11]) + " - "
				lchk01 := .F.
			Else
				_cObsItem += Alltrim(aDados[nc,11]) + " - "
			Endif
		Endif

		If Cont > Cont1
			nCont1 := nCont1 + 1
			Cont := 1

		Endif
		//Cont := Cont + 1

	Next

	lEmpCab := lEmpRoda := .t.
	// Controla Qtd de Numero de Linhas Por pedido de compras Maximo de 15 linhas nos itens de um pedido
		//PEDCOMIR->C7_XMEMO,;				// 25
		//PEDCOMIR->C7_XNOTAS})				// 26
		//PEDCOMIR->C7_OBS,;                	// 11
	nLinMax	:= 18 // 19 //36 //17 //23
	nLinAtu	:= 1
	lCrtPag	:= .T.

	For nP := 1 to len(aDados)

		If  nLinAtu > nLinMax
			nCont := nCont + 1
			//oPrint:Say  (0260,1900,Transform(StrZero(ncont,3),""),oFont10)
			//oPrint:Say  (0260,1970,"de",oFont10)
			//oPrint:Say  (0260,2020,Transform(StrZero(ncont1,3),""),oFont10)

			oPrint:EndPage() // Finaliza a pï¿½gina
			lEmpCab := .t.
			lCrtPag	:= .F.
			nLinAtu := 1

			nSubTotal := 0

		Endif
		//================== Numer de paginas ==========================
		If lEmpCab
			EmpCab(_cObs)
			lEmpCab := .f.
			nPos := 0

			If lCrtPag
				nCont := nCont + 1
				//nCont1 := nCont1 + 1

				nSubTotal	+= 0
				//**********
			Endif
			// Numero de Pagina / Paginas
		   	//oPrint:Say  (0360,3100,Transform(StrZero(ncont,3),""),oFont8)
		   	oPrint:Say  (0360,3000,"Pagina " + Transform(StrZero(ncont,3),"") ,oFont8) // + " de " + Transform(StrZero(ncont1,3),"") ****
                                                          

		Endif
		//===============================================================
		_nTamStr	:= 85
		_lChkTam	:= .T.
		_nTamDesc	:= 85

		//**********
		nSubTotal	+= aDados[nP,6] + aDados[nP,9] + aDados[nP,14]  + aDados[nP,15] - aDados[nP,16] // Totalizando Valor do pedido de compras

		If nLinAtu <= nLinMax
			oPrint:Say  (0520+nPos,0060,aDados[nP,1],oFont7) //Item produto
			oPrint:Say  (0520+nPos,0140,aDados[nP,7],oFont7) //Codigo produto


			IF MV_PAR12 = 1
				cProdIngles		:= Posicione("SB1",1,xFilial("SB1") + aDados[nP,7],"B1_XXDI") // descriï¿½ï¿½o em ingles
				aDadosConc := ALLTRIM(cProdIngles) + " " + ALLTRIM(aDados[nP,11]) + " " + ALLTRIM(aDados[nP,25]) 
			ELSE
		   		aDadosConc := alltrim(Posicione("SB1",1,xFilial("SB1") + ALLTRIM(aDados[nP,7]),"B1_DESC")) + " " + ALLTRIM(aDados[nP,11]) + " " + ALLTRIM(aDados[nP,25])  // descricao em portugues ALLTRIM(aDados[nP,3])
		 	END IF
			/*
		 	nLinhas := MLCount(ALLTRIM(aDadosConc),85)
			For nXi:= 1 To nLinhas
			        cTxtLinha := MemoLine(ALLTRIM(aDadosConc),85,nXi)
			        If ! Empty(cTxtLinha)
			               oPrint:Say(0520+nPos,470,(cTxtLinha),oFont7)
			        EndIf
			        nPos		+= 40
			Next nXi
*/

			oPrint:Say  (0520+nPos,0470,ALLTRIM(Substr(aDadosConc,1,_nTamStr)),oFont7) // Desc.Produto oPrint:Say  (0580+nPos,0370,Substr(aDados[nP,3],1,_nTamStr),oFont7)

			nLinAtu := nLinAtu + 1

			If Len(aDadosConc) > _nTamDesc  // Len(ALLTRIM(aDados[nP,3] + " " + ALLTRIM(aDados[nP,11]))) > _nTamDesc
				While _lChkTam
					nPos		+= 40
					//_nTamDesc	:= _nTamDesc + 1

					IF MV_PAR12 = 1
						cProdIngles		:= ALLTRIM(Posicione("SB1",1,xFilial("SB1") + aDados[nP,7],"B1_XXDI"))
						aDadosConc := ALLTRIM(cProdIngles) + ALLTRIM(aDados[nP,11]) + " " + ALLTRIM(aDados[nP,25]) 
					ELSE
		   				aDadosConc := ALLTRIM(aDados[nP,3]) + " " + AllTrim(aDados[nP,11]) + " " + ALLTRIM(aDados[nP,25]) 
		 			END IF

					// aDadosConc := aDados[nP,3] + " " + aDados[nP,11]

					oPrint:Say  (0520+nPos,470,Substr(aDadosConc,_nTamDesc + 1,_nTamStr),oFont7) // Desc.Produto oPrint:Say  (0580+nPos,370,Substr(aDados[nP,3],_nTamDesc + 1,_nTamStr),oFont7)
					If Len(aDadosConc) > (_nTamDesc + _nTamStr) + 1 // Len(ALLTrim(aDados[nP,3] + " " + AllTrim(aDados[nP,11]))) > (_nTamDesc + _nTamStr) + 1
						_nTamDesc += _nTamStr
						nLinAtu := nLinAtu + 1
						Loop
					Else
						_lChkTam	:= .F.
					Endif
				Enddo
			Endif

			//oPrint:Say  (0940+nPos,0410,Posicione("SB1",1,xFilial("SB1") + aDados[nP,7],"B1_DESC"),oFont8) // Desc.Produto
			oPrint:Say  (0520+nPos,1810, Alltrim(Transform(aDados[nP,4],"@E 999,999.9999")),oFont7,20,,,1)//quantidade produto
			oPrint:Say  (0520+nPos,1850,aDados[nP,8],oFont8)//Unidade de medida
			oPrint:Say  (0520+nPos,2090, Alltrim(Transform(aDados[nP,19],"@E 999,999,999.999999")),oFont7,20,,,1) //2a. quantidade produto
			oPrint:Say  (0520+nPos,2430, Alltrim(Transform(aDados[nP,5],"@E 999,999,999.999999")),oFont7,20,,,1) //Preco do produto
			oPrint:Say  (0520+nPos,2110,aDados[nP,20],oFont8)//2a. Unidade de medida

			IF MV_PAR12 = 1
				oPrint:Say  (0520+nPos,2720,"0,00",oFont7)//Valor IPI
				oPrint:Say  (0520+nPos,2790,"0,00",oFont7)//Valor ICMS
				oPrint:Say  (0520+nPos,2890,"0,00",oFont7)//Valor ISS
			ELSE
		   		oPrint:Say  (0520+nPos,2710,Transform(aDados[nP,21],"@E 999.99"),oFont7)//Valor IPI
		   		oPrint:Say  (0520+nPos,2800,Transform(aDados[nP,22],"@E 999.99"),oFont7)//Valor ICMS
		   		oPrint:Say  (0520+nPos,2890,Transform(aDados[nP,23],"@E 999.99"),oFont7)//Valor ISS
		 	END IF

			oPrint:Say  (0520+nPos,2680, Alltrim(transform(aDados[nP,6],"@E 999,999,999.99")),oFont7,20,,,1)//Valor Total
			oPrint:Say  (0520+nPos,2970,Substr(aDados[nP,2],7,2) + "/" + Substr(aDados[nP,2],5,2) + "/" + Substr(aDados[nP,2],1,4),oFont7) // Data de Entrega
			oPrint:Say  (0520+nPos,3130,aDados[nP,12],oFont7) // Item contabil

			cTipoCont := Substr(aDados[nP,12],1,2)

			/*
			nTotPdSIPI = nTotalCom - nTotalIPI
			nTotalProd	+= aDados[nP,6]	//Totalizando Valor do produto
			nTotalDesc	+= aDados[nP,16]  //Totalizando Descontos
			nTotalDesp  += aDados[nP,13] // Totalizando Despesas
			nTotalSeg	+= aDados[nP,14] // Totalizando Seguro
			nTotalFrete	+= aDados[nP,15] // Totalizando Frete
			nTotalICMSRET += aDados[nP,24] // Totalizando ICMS Retido
			//nTotalAcre	+= aDados[nP,]  //Totalizando Acrescimo
			nTotalProd	+= aDados[nP,5]	//Totalizando Valor do produto
			nTotalCom	+= (aDados[nP,6] + aDados[nP,9] + aDados[nP,14] + aDados[nP,13] + aDados[nP,15]) - (aDados[nP,16] + aDados[nP,24])  // Totalizando Valor do pedido de compras
			nTotalIPI 	+= aDados[nP,9] // Totalizando IPI
			*/

			If nLinAtu = nLinMax - 1 .OR. nLinAtu = nLinMax
				//************
				oPrint:Say  (1400,3250, alltrim(transform(nSubTotal ,"@E 999,999,999.99")),oFont11,20,,,1)// SubTotal do pedido de compras
				//************

			End if

			nPos  += 40
			nLinAtu := nLinAtu + 1

		EndIf

	Next

	//oPrint:Say  (2030,2900,varSimb + " " + transform(nTotalCom ,"@E 999,999,999.99"),oFont12)// Total do pedido de compras


	DbSelectArea("PEDCOMIR")

	nCont := nCont + 1 //==============
	nCont1 := nCont1 + 1 //==============


	If EOF() = .T.
		//nTotPdSIPI = nTotalCom - nTotalIPI

		//oPrint:Say  (1470,3250, alltrim(transform(nSubTotal ,"@E 999,999,999.99")),oFont11,20,,,1)// SubTotal do pedido de compras
		/*
		oPrint:Say  (1530,3250, alltrim(transform(nTotPdSIPI ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Produtos sem IPI
		oPrint:Say  (1590,3250, alltrim(transform(nTotalSeg ,"@E 999,999,999.99")),oFont9,20,,,1)   // Totalizando Seguro
		oPrint:Say  (1650,3250, alltrim(transform(nTotalFrete ,"@E 999,999,999.99")),oFont9,20,,,1) // Totalizando Frete
		oPrint:Say  (1710,3250, alltrim(transform(nTotalDesp ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Despesa
		oPrint:Say  (1770,3250, alltrim(transform(nTotalIPI ,"@E 999,999,999.99")),oFont9,20,,,1)   // Totalizando IPI
		//oPrint:Say  (2110,2570,varSimb + " " + transform(nSubTotal ,"@E 999,999,999.99"),oFont11)// SubTotal do pedido de compras
		oPrint:Say  (1830,3250, alltrim(transform(nTotalDesc ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Desconto
		oPrint:Say  (1890,3250, alltrim(transform(nTotalICMSRET ,"@E 999,999,999.99")),oFont9,20,,,1) // Totalizando ICMS ST
		oPrint:Say  (1950,3250, alltrim(transform(nTotalCom ,"@E 999,999,999.99")),oFont12,20,,,1)      // Total do pedido de compras
		*/
	EndIf


	oPrint:EndPage() // Finaliza a pï¿½gina

Enddo


oPrint:EndPage() // Finaliza a pï¿½gina

PEDCOMIR->( DbCloseArea() )
//================================================



If Mv_par11 == 2
	oPrint:Preview()  // Visualiza antes de imprimir
Else
	oPrint:Print() // Imprime direto na impressora default do AP5
End


Return nil


//*****************************************************************************************
//|------------------------------------------------------------------------|
//| Impressao do corpo do pedido de compras                                |
//|------------------------------------------------------------------------|
Static Function EMPCAB(_cObs)
local nXi
Local cGrup := ""
Local cGrup2 := ""
Local cGrup3 := ""

Private cUserCoord := ""

IF MV_PAR12 == 2
		//... Impressao do cabecalho
		oPrint:StartPage()   // Inicia uma nova pï¿½gina

		// Cabecalho
		//oPrint:FillRect({0050,0050,0190,0740},oBrush2)

		oPrint:Box	(0050,0050,0510,3300) //Box Cabeï¿½a

		oPrint:Box	(0050,0050,0190,0740) // logo
		oPrint:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrint:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Dados da Empresa
		oPrint:Box	(0050,0050,0410,0740) // Empresa
		// oPrint:Say  ( 0220,0580,"Empresa " ,oFont9n)
		oPrint:Say  ( 0210,0060,ALLTRIM(aDadosEmp[2]),oFont8)   // Endereco
		oPrint:Say  ( 0250,0060,aDadosEmp[3] + " - " + "BRASIL - " + "CEP: " + aDadosEmp[4] ,oFont8) // CEP
		oPrint:Say  ( 0290,0060,"Tel.: " + "55-11-3234-5400 - Fax: 55-11-3234-5423" ,oFont8) // TEL
		oPrint:Say  ( 0330,0060,"CNPJ: " + aDadosEmp[6] + " - " + "Insc.Est. - " + aDadosEmp[7] ,oFont8) // CNPJ
		oPrint:Say  ( 0370,0060,"Insc. Municipal: 3.489.047-5",oFont8)
		//oPrint:Say  ( 0370,0060,"E-mail NF Eletrï¿½nica: notafiscal@westech.com.br ",oFont8n)

		// Ordem de Compra
		oPrint:Box	(0050,0740,0190,1340) // Titulo Pedido
		oPrint:Say  (0070,0800,"ORDEM DE COMPRA  ",oFont14)
		oPrint:Say  (0120,0900,"No " + cNumPed,oFont14)

		oPrint:Box	(0190,0740,0350,1050) // Data Emissao
		oPrint:Say  (0220,0780,"Data Emissao " ,oFont12)
		oPrint:Say  (0280,0780,DTOC(dDataEmi) ,oFont12)


		oPrint:Box	(0190,1050,0350,1340) // Revisao
		oPrint:Say  (0220,1100,"Revisao: No: " + Transform(nRevisao, "@E 999"),oFont9)
		If EMPTY(dRevisao)
			oPrint:Say  (0280,1100,"Data: " + SPACE(3) ,oFont9)
		Else
			oPrint:Say  (0280,1100,"Data: " + Substr(dRevisao,7,2) + "/" + Substr(dRevisao,5,2) + "/" + Substr(dRevisao,1,4) ,oFont9)

		Endif

		//oPrint:Say  (0280,1090,"Nï¿½: " + Transform(nRevisao, "@E 999"),oFont8n)

		oPrint:Box	(0050,1340,0350,2400) // Fornecedor
		oPrint:Say  (0070,1350,"Fornecedor",oFont9n)
		oPrint:Say  (0110,1350, cCodCredor + " - " + cNomeCredor,oFont9n)
		oPrint:Say  (0150,1350,cEnd + " - " + cBAIRRO ,oFont8)
		oPrint:Say  (0190,1350,cMUN + " - "  + cEst + " - " + cPAIS + " - CEP: " + cCEP + " - Tel: " + cDDI + "-" + cDDD + "-" + cTel,oFont8)
		oPrint:Say  (0230,1350,"CNPJ: " + Transform(cCGC,"@R 99.999.999/9999-99") + " - " + "Inscr. Est.: " + cINSCR + " - Inscr. Mun.: " + cINSCRM  ,oFont8)
		oPrint:Say  (0270,1350,"E-mail:" + cEmail,oFont8)
		oPrint:Say  (0310,1350,"Contato: " + cContato,oFont8)

		oPrint:Box	(0050,2400,0185,3300) // Local de Entrega
		oPrint:Say  (0060,2410,"Local de Entrega: ",oFont9n)
		IF EMPTY(cFormula)
			oPrint:Say  (0100,2410, ALLTRIM( aDadosEmp[2]) ,oFont8)
			oPrint:Say  (0140,2410, ALLTRIM( aDadosEmp[3]) + " - " + ALLTRIM( aDadosEmp[4]),oFont8)

		ELSE
			oPrint:Say  (0100,2410, ALLTRIM(ccNREDUZ) + " - " + ALLTRIM(ccEND) ,oFont8)
			oPrint:Say  (0140,2410, ALLTRIM(ccBAIRRO) + " - " + ALLTRIM(ccMUN) + " - " + ALLTRIM(ccEST) + " - CEP: " + ALLTRIM(ccCEP),oFont8)
		ENDIF

		oPrint:Box	(0050,2400,0350,3300) // Local de Cobranca
		oPrint:Say  (0195,2410,"Local de Cobranca: ",oFont9n)
		oPrint:Say  (0235,2410, ALLTRIM( aDadosEmp[2]) ,oFont8)
		oPrint:Say  (0275,2410, ALLTRIM( aDadosEmp[3]) + " - " + ALLTRIM( aDadosEmp[4]),oFont8)
		oPrint:Say  (0315,2410,"E-mail NF Eletronica: notafiscal@westech.com.br ",oFont8n)

		oPrint:Box	(0350,0740,0410,3300) // Local de Cobranca
		oPrint:Say  (0360,0790,"Autorizamos o fornecimento dos seguintes materiais / servicos, conforme condicoes estabelecidas nesta ordem de compra e seus anexos. ",oFont9n)

		oPrint:Box	(0350,2900,0410,3300) // Numero Pagina
		//oPrint:Say  (0360,2920,"Pï¿½gina",oFont9)

		oPrint:Box	(0410,0050,0460,3300) // cabecalhos itens pedido
		oPrint:Box	(0410,0050,0460,1650)
		oPrint:Say  (0420,0950,"Escopo de Fornecimento",oFont7n,1800,,,1)
		oPrint:Box	(0410,2210,0460,2700)
		oPrint:Say  (0420,2350,"Precos com Impostos",oFont7n)
		oPrint:Box	(0410,2700,0460,2960)
		oPrint:Say  (0420,2730,"Impostos Inclusos",oFont7n)

		oPrint:Box	(2050,0050,2120,3300) // Cond. pag
		//oPrint:Say  (2020,1510,"Condiï¿½ï¿½o de Pagamento: ",oFont9n)
		oPrint:Say  (2060,0070,"Condicaoo de Pagamento: " + cCondPagto, oFont9n,,,0)

		oPrint:Box	(1370,2400,1480,3300)
		oPrint:Say  (1400,2420,"SubTotal pagina " + varSimb + " : ",oFont9)

		oPrint:Box	(1480,2400,1580,3300)
		oPrint:Say  (1510,2420,"Total Itens (s/ IPI) " + varSimb + " : ",oFont9)
		oPrint:Say  (1510,3250, alltrim(transform(nTotPdSIPI ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Produtos sem IPI

		oPrint:Box	(1580,2400,1820,3300)
		oPrint:Say  (1590,2420,"Seguro " + varSimb + " : ",oFont9)
		oPrint:Say  (1590,3250, alltrim(transform(nTotalSeg ,"@E 999,999,999.99")),oFont9,20,,,1)   // Totalizando Seguro

		//oPrint:Box	(1640,2400,1700,3300)
		oPrint:Say  (1650,2420,"Frete " + varSimb + " : ",oFont9)
		oPrint:Say  (1650,3250, alltrim(transform(nTotalFrete ,"@E 999,999,999.99")),oFont9,20,,,1) // Totalizando Frete

		//oPrint:Box	(1700,2400,1940,3300)
		oPrint:Say  (1710,2420,"Despesas " + varSimb + " : ",oFont9)
		oPrint:Say  (1710,3250, alltrim(transform(nTotalDesp ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Despesa

		//oPrint:Box	(1760,2400,1820,3300)
		oPrint:Say  (1770,2420,"Total IPI " + varSimb + " : ",oFont9)
		oPrint:Say  (1770,3250, alltrim(transform(nTotalIPI ,"@E 999,999,999.99")),oFont9,20,,,1)   // Totalizando IPI

		oPrint:Box	(1820,2400,1940,3300)
		oPrint:Say  (1830,2420,"Desconto " + varSimb + " : ",oFont9)
		oPrint:Say  (1830,3250, alltrim(transform(nTotalDesc ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Desconto

		//oPrint:Box	(1880,2400,1940,3300)
		oPrint:Say  (1890,2420,"ICMS Subst.Tributaria " + varSimb + " : ",oFont9)
		oPrint:Say  (1890,3250, alltrim(transform(nTotalICMSRET ,"@E 999,999,999.99")),oFont9,20,,,1) // Totalizando ICMS ST

		oPrint:Box	(1940,2400,2050,3300)
		oPrint:Say  (1975,2420,"Total Ordem de Compra " + varSimb + " : ",oFont12)
		oPrint:Say  (1975,3250, alltrim(transform(nTotalCom ,"@E 999,999,999.99")),oFont12,20,,,1)      // Total do pedido de compras

		// Cabecalho Itens do Pedido

		oPrint:Box	(0460,0050,0510,3300) // cabecalhos itens pedido

		oPrint:Box	(0460,0050,1370,0130) // cabecalho Item
		oPrint:Say  (0470,0060,"Item",oFont7n)

		oPrint:Box	(0460,0130,1370,0465) // cabecalho Codigo
		oPrint:Say  (0470,0200,"Codigo",oFont7n)

		oPrint:Box	(0460,0465,1370,1650) // cabecalho Descricao
		oPrint:Say  (0470,0900,"Descricao do Material e/ou Servico",oFont7n)

		oPrint:Box	(0460,1650,1370,1830) // cabecalho Quantidade
		oPrint:Say  (0470,1690,"1a Qtd.",oFont7n)

		oPrint:Box	(0460,1830,1370,1930) // cabecalho Undidade de medida
		oPrint:Say  (0470,1840,"1a Un.",oFont7n)

		oPrint:Box	(0460,1930,1370,2110) // cabecalho Quantidade
		oPrint:Say  (0470,1970,"2a Qtd.",oFont7n)

		oPrint:Box	(0460,2110,1370,2210) // cabecalho Undidade de medida
		oPrint:Say  (0470,2120,"2a Un.",oFont7n)

		oPrint:Box	(0460,2210,1370,2450) // cabecalho Preco Unitario
		oPrint:Say  (0470,2270,"Unitario " + varSimb,oFont7n)

		oPrint:Box	(0460,2450,1370,2700) // cabecalho Total
		oPrint:Say  (0470,2540,"Total " + varSimb,oFont7n)

		oPrint:Box	(0460,2700,1370,2780) // cabecalho Ipi
		oPrint:Say  (0470,2710,"IPI %",oFont7n)

		oPrint:Box	(0460,2780,1370,2880) // cabecalho Ipi
		oPrint:Say  (0470,2790,"ICMS %",oFont7n)

		oPrint:Say  (0470,2890,"ISS %",oFont7n)

		oPrint:Box	(0460,2960,1370,3120) // cabecalho Data Entrega
		oPrint:Say  (0470,2970,"Data Entrega",oFont7n)

		oPrint:Box	(0460,3120,1370,3300) // cabecalho No. Job
		oPrint:Say  (0470,3130,"Item Contabil",oFont7n)

		// Rodapï¿½
		oPrint:Box	(1370,0050,2170,3300) //

		//oPrint:Box	(1700,200,2100,3300) // Nota do Pedido
		oPrint:Say  (1375,0070,"Notas ",oFont9n)

		IF EMPTY(cFormula2) .AND. EMPTY(cXNotas)

			oPrint:Say  (1410,0070,"As Condicoes Gerais de Compras - Anexo 3 - PQ-90-0784 revisao 05 - sao parte integrante desta Ordem de compra: ",oFont7a)
			oPrint:Say  (1450,0070,"A Ordem de Compra e as Condicoes Gerais de Compra deverao ser assinadas e devolvidas em ate tres dias. A partir deste prazo serao considerados aprovadas.",oFont7a)
			oPrint:Say  (1490,0070,"Nao serao aceitas notas fiscais de recebimento de materiais sem que nela constem numero da Ordem de Compra.",oFont7a)
			oPrint:Say  (1530,0070,"A Westech se reserva o direito de efetuar testes na fabrica do fornecedor antes da liberacao para entrega. ",oFont7a)
			oPrint:Say  (1570,0070,"A penalidadade por atraso de entrega sera de 0,3% ao dia com teto maximo de 10%. Os valores correspondente serao glosados do pagamento a ser feito. ",oFont7a)
			oPrint:Say  (1610,0070,"Os preco informados incluem ICMS, PIS e COFINS.",oFont7a)
			oPrint:Say  (1650,0070,"Os pagamentos serao feitos atraves de deposito bancario.",oFont7a)
			oPrint:Say  (1690,0070,"Material destinado a industrializacao.",oFont7a)
			oPrint:Say  (1730,0070,"Enviar certificado de qualidade do produto anexado a nota fiscal.",oFont7a)
			oPrint:Say  (1770,0070,"Importante:",oFont7an)
			oPrint:Say  (1810,0070,"A Westech nao aceita emissao de boletos para pagamentos, bem como, nao aceita negociacao de duplicata com terceiros.",oFont7an)
			oPrint:Say  (1850,0070,"Fornecer uma via fisica do Certificado de Materia Prima / Procedencia junto com envio do produto e uma via eletronica (e-mail) junto com nota fiscal.",oFont7an)
			oPrint:Say  (1890,0070,"",oFont7a)
			oPrint:Say  (1930,0070,"",oFont7a)


		ELSEIF !EMPTY(cFormula2) .AND. EMPTY(cXNotas)
			oPrint:Say  (1410,0070,cLinha1,oFont7a)
			oPrint:Say  (1450,0070,cLinha2,oFont7a)
			oPrint:Say  (1490,0070,cLinha3,oFont7a)
			oPrint:Say  (1530,0070,cLinha4,oFont7a)
			oPrint:Say  (1570,0070,cLinha5,oFont7a)
			oPrint:Say  (1610,0070,cLinha6,oFont7a)
			oPrint:Say  (1650,0070,cLinha7,oFont7a)
			oPrint:Say  (1690,0070,cLinha8,oFont7a)
			oPrint:Say  (1730,0070,cLinha9,oFont7a)
			oPrint:Say  (1770,0070,cLinha10,oFont7a)
			oPrint:Say  (1810,0070,cLinha11,oFont7a)
			oPrint:Say  (1850,0070,cLinha12,oFont7a)
			oPrint:Say  (1890,0070,cLinha13,oFont7a)
			oPrint:Say  (1930,0070,cLinha14,oFont7a)
			
		ELSEIF !EMPTY(cXNotas)
			///oPrint:Say  (1410,0070,Alltrim(cXNotas),oFont7a)
			nLin := 1370
			nLinhas := MLCount(cXNotas,200)
			For nXi:= 1 To 18
			
			        cTxtLinha := MemoLine(cXNotas,200,nXi)
			        If ! Empty(cTxtLinha)
			              oPrint:Say(nLin+=40,0070,(cTxtLinha),oFont7a)
			        EndIf
			        			       
			Next nXi
		END IF

		oPrint:FillRect({2120,0050,2170,1490},oBrush)
		oPrint:FillRect({2120,1490,2170,2450},oBrush)
		oPrint:FillRect({2120,2450,2170,3300},oBrush)

		
		oPrint:Box	(2120,0050,2170,1100)
		oPrint:Say  (2130,0650,"Emissao",oFont8n)
		
				
		oPrint:Box	(2120,1100,2170,2650)
		oPrint:Say  (2130,1820,"Aprovacao",oFont8n)
		
		oPrint:Box	(2120,2650,2170,3300)
		oPrint:Say  (2130,2660,"Aceitacao desta Ordem de Compra Pelo Fornecedor",oFont9n)

		// Socitante
		cIdSolic		:= Alltrim(Posicione("SC1",6,xFilial("SC1") + cNumPed,"C1_USER"))
		cAssSolic	:= GetSrvProfString('Startpath','') + cIdSolic + '.BMP'
		oPrint:SayBitmap(2230,0070,cAssSolic,0520,0120)
		
		oPrint:Box	(2170,0050,2350,0530)  // (2170,0050,2350,0700) 
		oPrint:Say  (2180,0060,"Solicitante",oFont8n)
		oPrint:Say  (2210,0060,AllTrim(UsrFullName(Posicione("SC1",6,xFilial("SC1") + cNumPed,"C1_USER"))),oFont8)
		oPrint:Say  (2310,0060,Posicione("ZZE",1,xFilial("ZZE") + (Posicione("SC1",6,xFilial("SC1") + cNumPed,"C1_USER")),"ZZE_CARGO"),oFont8)
	
		//Assinatura Emitido por
		cIdConf		:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_USER"))
		cAssConf	:= GetSrvProfString('Startpath','') + cIdConf + '.BMP'
		oPrint:SayBitmap(2230,0540,cAssConf,0520,0120)

		oPrint:Box	(2170,0530,2350,1100) // Emitido por (2170,0700,2350,1290)
		oPrint:Say  (2180,0540,"Comprador(a)",oFont8n)
		oPrint:Say  (2210,0540,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_USER"))),oFont8)
		oPrint:Say  (2310,0540,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_USER"),"ZZE_CARGO"),oFont8)
		
		// Assinatura Coordenador
		oPrint:Box	(2170,1100,2350,1600) // coordenador (2170,1290,2350,1870)
		if  EMPTY(SC7->C7_XAPRN1) .and. SC7->C7_ITEMCTA <> 'ADMINISTRACAO'//.OR. alltrim(SC7->C7_XCTRVB) <> "4" // 
			oPrint:Say  (2210,1110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,1110,"DO COORDENADOR(A)",oFont8n)
			
		elseif !EMPTY(SC7->C7_XAPRN1) //.AND. alltrim(SC7->C7_XCTRVB) == "4" //elseif cRequer == "1" .and. !EMPTY(SC7->C7_XAPRN1)
			cIdCoord	:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"))
			cAssCoord	:= GetSrvProfString('Startpath','') + cIdCoord + '.BMP'
			oPrint:SayBitmap(2230,1110,cAssCoord,0520,0120)
			oPrint:Say  (2180,1110,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"))),oFont8)
			oPrint:Say  (2310,1110,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"),"ZZE_CARGO"),oFont8)
		endif

		cUserCoord := POSICIONE("CTD",1,XFILIAL("CTD")+ SC7->C7_ITEMCTA,"CTD_XIDPM")
		
		PswOrder(1)
		If PswSeek(cUserCoord, .T. )
			cGrup := alltrim(PSWRET()[1][12])
		endif

		//MsgInfo(cGrup)

		// Assinatura Gerência
		oPrint:Box	(2170,1600,2350,2100)  // Gerenccia (2170,1290,2350,1870)
		if EMPTY(SC7->C7_XAPRN3) .AND.  substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR' .AND. nTotalCom > 1000 .AND. cGrup == "Contratos(E)" 
			oPrint:Say  (2210,1610,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,1610,"DA GERENCIA",oFont8n)

		elseif EMPTY(SC7->C7_XAPRN3) .AND.  substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR' .AND. nTotalCom > 1500 .AND. cGrup == "Contratos" 
			oPrint:Say  (2210,1610,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,1610,"DA GERENCIA",oFont8n)
		
		elseif !EMPTY(SC7->C7_XAPRN3) //.AND. alltrim(SC7->C7_XCTRVB) == "4" //elseif cRequer == "1" .and. !EMPTY(SC7->C7_XAPRN1)
			cIdGeren	:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN3"))
			cAssGeren	:= GetSrvProfString('Startpath','') + cIdGeren + '.BMP'
			oPrint:SayBitmap(2230,1610,cAssGeren,0520,0120)
			oPrint:Say  (2180,1610,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN3"))),oFont8)
			oPrint:Say  (2310,1610,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN3"),"ZZE_CARGO"),oFont8)
		endif
			
		//ENDIF
		
		oPrint:Box	(2170,2100,2350,2650) // Diretoria (2170,1870,2350,2650)

		// Assinatura DIRETORIA
		if EMPTY(SC7->C7_XAPRN2) .AND. nTotalCom > 1000 .AND. substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR'  .AND. cGrup == "Contratos(E)" 
			oPrint:Say  (2210,2110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,2110,"DA DIRETORIA",oFont8n)
			oPrint:Say  (2210,2110,"",oFont20)

		elseif EMPTY(SC7->C7_XAPRN2) .AND. nTotalCom > 1500 .AND. substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR' .AND. cGrup == "Contratos" 
			oPrint:Say  (2210,2110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,2110,"DA DIRETORIA",oFont8n)
			oPrint:Say  (2210,2110,"",oFont20)
		
		elseif EMPTY(SC7->C7_XAPRN2) .AND. !substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR'// cRequer = "1"
			oPrint:Say  (2210,2110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,2110,"DA DIRETORIA",oFont8n)
			oPrint:Say  (2210,2110,"",oFont20)
			
		elseif !EMPTY(SC7->C7_XAPRN2)
			cIdDiret	:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN2"))
			cAssDiret	:= GetSrvProfString('Startpath','') + cIdDiret + '.BMP'
			oPrint:SayBitmap(2230,2110,cAssDiret,0520,0120)
			oPrint:Say  (2180,2110,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN2"))),oFont8)
			oPrint:Say  (2310,2110,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN2"),"ZZE_CARGO"),oFont8)
			
		//elseif EMPTY(SC7->C7_XAPRN2) .AND. cRequer = "2"
			//oPrint:Say  (2210,1920,"",oFont20)	
			
		endif

		oPrint:Box	(2170,2650,2350,3030) //
		oPrint:Say  (2180,2660,"Nome / Assinatura",oFont8n)

		oPrint:Box	(2170,3030,2350,3300) //
		oPrint:Say  (2180,3040,"Data",oFont9n)
		
ELSE
		//... Impressao do cabecalho
		oPrint:StartPage()   // Inicia uma nova pï¿½gina

		// Cabecalho
		//oPrint:FillRect({0050,0050,0190,0740},oBrush2)

		oPrint:Box	(0050,0050,0510,3300) //Box Cabeï¿½a

		oPrint:Box	(0050,0050,0190,0740) // logo
		oPrint:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrint:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Dados da Empresa
		oPrint:Box	(0050,0050,0410,0740) // Empresa
		// oPrint:Say  ( 0220,0580,"Empresa " ,oFont9n)
		oPrint:Say  ( 0210,0060,ALLTRIM(aDadosEmp[2]),oFont8)   // Endereco
		oPrint:Say  ( 0250,0060,aDadosEmp[3] + " - " + "BRASIL - " + "CEP: " + aDadosEmp[4] ,oFont8) // CEP
		oPrint:Say  ( 0290,0060,"Tel.: " + "55-11-3234-5400 - Fax: 55-11-3234-5423" ,oFont8) // TEL
		oPrint:Say  ( 0330,0060,"CNPJ: " + aDadosEmp[6] + " - " + "Insc.Est. - " + aDadosEmp[7] ,oFont8) // CNPJ
		oPrint:Say  ( 0370,0060,"Insc. Municipal: 3.489.047-5",oFont8)
		//oPrint:Say  ( 0370,0060,"E-mail NF Eletrï¿½nica: notafiscal@westech.com.br ",oFont8n)

		// Ordem de Compra
		oPrint:Box	(0050,0740,0190,1340) // Titulo Pedido
		oPrint:Say  (0070,0800,"PURCHASE ORDER ",oFont14)
		oPrint:Say  (0120,0900,"No " + cNumPed,oFont14)

		oPrint:Box	(0190,0740,0350,1050) // Data Emissao
		oPrint:Say  (0220,0780,"Issue " ,oFont12)
		oPrint:Say  (0280,0780,DTOC(dDataEmi) ,oFont12)

		oPrint:Box	(0190,1050,0350,1340) // Revisao
		oPrint:Say  (0220,1100,"Review: No: " + Transform(nRevisao, "@E 999"),oFont9)
		If EMPTY(dRevisao)
			oPrint:Say  (0280,1100,"Date: " + SPACE(3) ,oFont9)
		Else
			oPrint:Say  (0280,1100,"Date: " + Substr(dRevisao,7,2) + "/" + Substr(dRevisao,5,2) + "/" + Substr(dRevisao,1,4) ,oFont9)

		Endif

		//oPrint:Say  (0280,1090,"Nï¿½: " + Transform(nRevisao, "@E 999"),oFont8n)

		oPrint:Box	(0050,1340,0350,2400) // Fornecedor
		oPrint:Say  (0070,1350,"Provider",oFont9n)
		oPrint:Say  (0110,1350, cCodCredor + " - " + cNomeCredor,oFont9n)
		oPrint:Say  (0150,1350,cEnd + " - " + cBAIRRO ,oFont8)
		oPrint:Say  (0190,1350,cMUN + " - "  + cEst + " - " + cPAIS + " - CEP: " + cCEP + " - Tel: " + cDDI + "-" + cDDD + "-" + cTel,oFont8)
		oPrint:Say  (0230,1350,"CNPJ: " + Transform(cCGC,"@R 99.999.999/9999-99") + " - " + "Inscr. Est.: " + cINSCR + " - Inscr. Mun.: " + cINSCRM  ,oFont8)
		oPrint:Say  (0270,1350,"E-mail:" + cEmail,oFont8)
		oPrint:Say  (0310,1350,"Contact: " + cContato,oFont8)

		oPrint:Box	(0050,2400,0185,3300) // Local de Entrega
		oPrint:Say  (0060,2410,"Delivery Address: ",oFont9n)
		IF EMPTY(cFormula)
			oPrint:Say  (0100,2410, ALLTRIM( aDadosEmp[2]) ,oFont8)
			oPrint:Say  (0140,2410, ALLTRIM( aDadosEmp[3]) + " - " + ALLTRIM( aDadosEmp[4]),oFont8)

		ELSE
			oPrint:Say  (0100,2410, ALLTRIM(ccNREDUZ) + " - " + ALLTRIM(ccEND) ,oFont8)
			oPrint:Say  (0140,2410, ALLTRIM(ccBAIRRO) + " - " + ALLTRIM(ccMUN) + " - " + ALLTRIM(ccEST) + " - CEP: " + ALLTRIM(ccCEP),oFont8)
		ENDIF

		oPrint:Box	(0050,2400,0350,3300) // Local de Cobranca
		oPrint:Say  (0195,2410,"Local Billing ",oFont9n)
		oPrint:Say  (0235,2410, ALLTRIM( aDadosEmp[2]) ,oFont8)
		oPrint:Say  (0275,2410, ALLTRIM( aDadosEmp[3]) + " - " + ALLTRIM( aDadosEmp[4]),oFont8)
		oPrint:Say  (0315,2410,"E-mail NF Eletronica: notafiscal@westech.com.br ",oFont8n)

		oPrint:Box	(0350,0740,0410,3300) // Local de Cobranca
		oPrint:Say  (0360,0790,"We authorize the supply of the following materials / services, condition established this purchase order and its attachments ",oFont9n)

		oPrint:Box	(0350,2900,0410,3300) // Numero Pagina
		//oPrint:Say  (0360,2920,"Pï¿½gina",oFont9)

		oPrint:Box	(0410,0050,0460,3300) // cabecalhos itens pedido
		oPrint:Box	(0410,0050,0460,1650)
		oPrint:Say  (0420,0950,"Scope of Supply",oFont7n,1800,,,1)
		oPrint:Box	(0410,2210,0460,2700)
		oPrint:Say  (0420,2350,"Prices Taxes",oFont7n)
		oPrint:Box	(0410,2700,0460,2960)
		oPrint:Say  (0420,2730,"Including taxes",oFont7n)

		oPrint:Box	(2050,0050,2120,3300) // Cond. pag
		//oPrint:Say  (2020,1510,"Condiï¿½ï¿½o de Pagamento: ",oFont9n)
		oPrint:Say  (2060,0070,"Terms of Payment: " + cCondPagto, oFont9n,,,0)

		//oPrint:Box	(2010,2400,2120,3300) // Cond. pag
		//oPrint:Say  (2020,2420,"Terms of Payment: ",oFont9n)
		//oPrint:Say  (2060,2420,cCondPagto, oFont9n)
		
		//***
		
		
		//****oPrint:Box	(1470,2400,1520,3300)
		oPrint:Box	(1370,2400,1520,3300)
		oPrint:Say  (1400,2420,"SubTotal page " + varSimb + " : ",oFont9)

		oPrint:Box	(1520,2400,1580,3300)
		oPrint:Say  (1530,2420,"Total Items (s/ IPI) " + varSimb + " : ",oFont9)
		oPrint:Say  (1530,3250, alltrim(transform(nTotPdSIPI ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Produtos sem IPI

		oPrint:Box	(1580,2400,1820,3300)
		oPrint:Say  (1590,2420,"Insurance " + varSimb + " : ",oFont9)
		oPrint:Say  (1590,3250, alltrim(transform(nTotalSeg ,"@E 999,999,999.99")),oFont9,20,,,1)   // Totalizando Seguro

		//oPrint:Box	(1640,2400,1700,3300)
		oPrint:Say  (1650,2420,"Freight " + varSimb + " : ",oFont9)
		oPrint:Say  (1650,3250, alltrim(transform(nTotalFrete ,"@E 999,999,999.99")),oFont9,20,,,1) // Totalizando Frete

		//oPrint:Box	(1700,2400,1940,3300)
		oPrint:Say  (1710,2420,"Expenses " + varSimb + " : ",oFont9)
		oPrint:Say  (1710,3250, alltrim(transform(nTotalDesp ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Despesa

		//oPrint:Box	(1760,2400,1820,3300)
		oPrint:Say  (1770,2420,"Total IPI " + varSimb + " : ",oFont9)
		oPrint:Say  (1770,3250, alltrim(transform(nTotalIPI ,"@E 999,999,999.99")),oFont9,20,,,1)   // Totalizando IPI

		oPrint:Box	(1820,2400,1940,3300)
		oPrint:Say  (1830,2420,"Discount " + varSimb + " : ",oFont9)
		oPrint:Say  (1830,3250, alltrim(transform(nTotalDesc ,"@E 999,999,999.99")),oFont9,20,,,1)  // Totalizando Desconto

		//oPrint:Box	(1880,2400,1940,3300)
		oPrint:Say  (1890,2420,"ICMS tax substitution " + varSimb + " : ",oFont9)
		oPrint:Say  (1890,3250, alltrim(transform(nTotalICMSRET ,"@E 999,999,999.99")),oFont9,20,,,1) // Totalizando ICMS ST

		oPrint:Box	(1940,2400,2050,3300)
		oPrint:Say  (1975,2420,"Total Purchase Order " + varSimb + " : ",oFont12)
		oPrint:Say  (1975,3250, alltrim(transform(nTotalCom ,"@E 999,999,999.99")),oFont12,20,,,1)      // Total do pedido de compras
	
		// Cabecalho Itens do Pedido

		oPrint:Box	(0460,0050,0510,3300) // cabecalhos itens pedido

		oPrint:Box	(0460,0050,1370,0130) // cabecalho Item
		oPrint:Say  (0470,0060,"Item",oFont7n)

		oPrint:Box	(0460,0130,1370,0430) // cabecalho Codigo
		oPrint:Say  (0470,0200,"Code",oFont7n)

		oPrint:Box	(0460,0430,1370,1650) // cabecalho Descricao
		oPrint:Say  (0470,0900,"Description of Material and / or Service",oFont7n)

		oPrint:Box	(0460,1650,1370,1830) // cabecalho Quantidade
		oPrint:Say  (0470,1690,"1a. Qtd.",oFont7n)

		oPrint:Box	(0460,1830,1370,1930) // cabecalho Undidade de medida
		oPrint:Say  (0470,1840,"1a. Un.",oFont7n)

		oPrint:Box	(0460,1930,1370,2110) // cabecalho Quantidade
		oPrint:Say  (0470,1970,"2a. Qtd.",oFont7n)

		oPrint:Box	(0460,2110,1370,2210) // cabecalho Undidade de medida
		oPrint:Say  (0470,2120,"2a Un.",oFont7n)

		oPrint:Box	(0460,2210,1370,2450) // cabecalho Preco Unitario
		oPrint:Say  (0470,2270,"Each " + varSimb,oFont7n)

		oPrint:Box	(0460,2450,1370,2700) // cabecalho Total
		oPrint:Say  (0470,2540,"Total " + varSimb,oFont7n)

		oPrint:Box	(0460,2700,1370,2780) // cabecalho Ipi
		oPrint:Say  (0470,2710,"IPI %",oFont7n)

		oPrint:Box	(0460,2780,1370,2880) // cabecalho Ipi
		oPrint:Say  (0470,2790,"ICMS %",oFont7n)

		oPrint:Say  (0470,2890,"ISS %",oFont7n)

		oPrint:Box	(0460,2960,1370,3120) // cabecalho Data Entrega
		oPrint:Say  (0470,2970,"Delivery Date",oFont7n)

		oPrint:Box	(0460,3120,1370,3300) // cabecalho No. Job
		oPrint:Say  (0470,3130,"ACC Number",oFont7n)

		// Rodapï¿½
		oPrint:Box	(1370,0050,2170,3300) //

		//oPrint:Box	(1700,200,2100,3300) // Nota do Pedido
		oPrint:Say  (1375,0070,"Observations ",oFont9n)

		IF EMPTY(cFormula2) .AND. EMPTY(cXNotas)

			oPrint:Say  (1410,0070,"",oFont8)
			oPrint:Say  (1450,0070,"",oFont8)
			oPrint:Say  (1490,0070,"",oFont8)
			oPrint:Say  (1530,0070,"",oFont8)
			oPrint:Say  (1570,0070,"",oFont8)
			oPrint:Say  (1610,0070,"",oFont8)
			oPrint:Say  (1650,0070,"",oFont8)
			oPrint:Say  (1690,0070,"",oFont8)
			oPrint:Say  (1730,0070,"",oFont8)
			oPrint:Say  (1870,0070,"",oFont8)
			oPrint:Say  (1810,0070,"",oFont8)
			oPrint:Say  (1850,0070,"",oFont8)
			oPrint:Say  (1890,0070,"",oFont8)
			oPrint:Say  (1930,0070,"",oFont8)

		ELSEIF !EMPTY(cFormula2) .AND. EMPTY(cXNotas)
		
			oPrint:Say  (1410,0070,cLinha1,oFont8)
			oPrint:Say  (1450,0070,cLinha2,oFont8)
			oPrint:Say  (1490,0070,cLinha3,oFont8)
			oPrint:Say  (1530,0070,cLinha4,oFont8)
			oPrint:Say  (1570,0070,cLinha5,oFont8)
			oPrint:Say  (1610,0070,cLinha6,oFont8)
			oPrint:Say  (1650,0070,cLinha7,oFont8)
			oPrint:Say  (1690,0070,cLinha8,oFont8)
			oPrint:Say  (1730,0070,cLinha9,oFont8)
			oPrint:Say  (1770,0070,cLinha10,oFont8)
			oPrint:Say  (1810,0070,cLinha11,oFont8)
			oPrint:Say  (1850,0070,cLinha12,oFont8)
			oPrint:Say  (1890,0070,cLinha13,oFont8)
			oPrint:Say  (1930,0070,cLinha14,oFont8)
			
		ELSEIF !EMPTY(cXNotas)
			///oPrint:Say  (1410,0070,Alltrim(cXNotas),oFont7a)
			nLin := 1370
			nLinhas := MLCount(cXNotas,200)
			For nXi:= 1 To 18
			
			        cTxtLinha := MemoLine(cXNotas,200,nXi)
			        If ! Empty(cTxtLinha)
			              oPrint:Say(nLin+=40,0070,(cTxtLinha),oFont7a)
			        EndIf
			        			       
			Next nXi
			
		END IF
		

		oPrint:FillRect({2120,0050,2170,1490},oBrush)
		oPrint:FillRect({2120,1490,2170,2450},oBrush)
		oPrint:FillRect({2120,2450,2170,3300},oBrush)

		oPrint:Box	(2120,0050,2170,1100)
		oPrint:Say  (2130,0650,"Emission",oFont8n)
		
		oPrint:Box	(2120,1100,2170,2650)
		oPrint:Say  (2130,1820,"Approval",oFont8n)
		
		oPrint:Box	(2120,2650,2170,3300)
		oPrint:Say  (2130,2660,"Acceptance of this Purchase Order by Supplier",oFont9n)

		
		//***
		// Socitante
		cIdSolic		:= Alltrim(Posicione("SC1",6,xFilial("SC1") + cNumPed,"C1_USER"))
		cAssSolic	:= GetSrvProfString('Startpath','') + cIdSolic + '.BMP'
		oPrint:SayBitmap(2230,0070,cAssSolic,0520,0120)
		
		oPrint:Box	(2170,0050,2350,0530)  // (2170,0050,2350,0700) 
		oPrint:Say  (2180,0060,"Requester",oFont8n)
		oPrint:Say  (2210,0060,AllTrim(UsrFullName(Posicione("SC1",6,xFilial("SC1") + cNumPed,"C1_USER"))),oFont8)
		oPrint:Say  (2310,0060,Posicione("ZZE",1,xFilial("ZZE") + (Posicione("SC1",6,xFilial("SC1") + cNumPed,"C1_USER")),"ZZE_CARGO"),oFont8)

		//Assinatura Emitido por
		cIdConf		:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_USER"))
		cAssConf	:= GetSrvProfString('Startpath','') + cIdConf + '.BMP'
		oPrint:SayBitmap(2230,0540,cAssConf,0520,0120)

		oPrint:Box	(2170,0530,2350,1100) // Emitido por (2170,0700,2350,1290)
		oPrint:Say  (2180,0540,"Issued by",oFont8n)
		oPrint:Say  (2210,0540,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_USER"))),oFont8)
		oPrint:Say  (2310,0540,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_USER"),"ZZE_CARGO"),oFont8)

		
		// Assinatura Coordenador
		oPrint:Box	(2170,1100,2350,1600) // coordenador (2170,1290,2350,1870)
		if  EMPTY(SC7->C7_XAPRN1) .and. SC7->C7_ITEMCTA <> 'ADMINISTRACAO'//.OR. alltrim(SC7->C7_XCTRVB) <> "4" // 
			oPrint:Say  (2210,1110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,1110,"DO COORDENADOR(A)",oFont8n)
			
		elseif !EMPTY(SC7->C7_XAPRN1) //.AND. alltrim(SC7->C7_XCTRVB) == "4" //elseif cRequer == "1" .and. !EMPTY(SC7->C7_XAPRN1)
			cIdCoord	:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"))
			cAssCoord	:= GetSrvProfString('Startpath','') + cIdCoord + '.BMP'
			oPrint:SayBitmap(2230,1110,cAssCoord,0520,0120)
			oPrint:Say  (2180,1110,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"))),oFont8)
			oPrint:Say  (2310,1110,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN1"),"ZZE_CARGO"),oFont8)
		endif

		cUserCoord := POSICIONE("CTD",1,XFILIAL("CTD")+ SC7->C7_ITEMCTA,"CTD_XIDPM")
		
		PswOrder(1)
		If PswSeek(cUserCoord, .T. )
			cGrup := alltrim(PSWRET()[1][12])
		endif

		// Assinatura Gerência
		oPrint:Box	(2170,1600,2350,2100)  // Gerenccia (2170,1290,2350,1870)
		if EMPTY(SC7->C7_XAPRN3) .AND.  substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR' .AND. nTotalCom > 1000 .AND. cGrup == "Contratos(E)" //.AND. cTipoCont $ "AT/PR"
			oPrint:Say  (2210,1610,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,1610,"DA GERENCIA",oFont8n)

		elseif EMPTY(SC7->C7_XAPRN3) .AND.  substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR' .AND. nTotalCom > 1500 .AND. cGrup == "Contratos" //.AND. cTipoCont $ "AT/PR"
			oPrint:Say  (2210,1610,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,1610,"DA GERENCIA",oFont8n)
		
		elseif !EMPTY(SC7->C7_XAPRN3) //.AND. alltrim(SC7->C7_XCTRVB) == "4" //elseif cRequer == "1" .and. !EMPTY(SC7->C7_XAPRN1)
			cIdGeren	:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN3"))
			cAssGeren	:= GetSrvProfString('Startpath','') + cIdGeren + '.BMP'
			oPrint:SayBitmap(2230,1610,cAssGeren,0520,0120)
			oPrint:Say  (2180,1610,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN3"))),oFont8)
			oPrint:Say  (2310,1610,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN3"),"ZZE_CARGO"),oFont8)
		endif

		PswOrder(2)
		If PswSeek( SC7->C7_XAPRN1, .T. )
			cGrup := alltrim(PSWRET()[1][12])
		endif

		oPrint:Box	(2170,2100,2350,2650) // Diretoria (2170,1870,2350,2650)

		// Assinatura DIRETORIA
		if EMPTY(SC7->C7_XAPRN2) .AND. nTotalCom > 1000 .AND. substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR' .AND. cGrup == "Contratos(E)" //ALLTRIM(SC7->C7_XAPRN1) $ ("000071/000076/000078/000046")
			oPrint:Say  (2210,2110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,2110,"DA DIRETORIA",oFont8n)
			oPrint:Say  (2210,2110,"",oFont20)
		
		elseif EMPTY(SC7->C7_XAPRN2) .AND. nTotalCom > 1500 .AND. substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR' .AND. cGrup == "Contratos" //ALLTRIM(SC7->C7_XAPRN1) $ ("000071/000076/000078/000046")
			oPrint:Say  (2210,2110,"REQUER APROVACAO",oFont20)
			oPrint:Say  (2290,2110,"DA DIRETORIA",oFont8n)
			oPrint:Say  (2210,2110,"",oFont20)
		
		elseif EMPTY(SC7->C7_XAPRN2) .AND. !substr(SC7->C7_ITEMCTA,1,2) $ 'AT/PR/ST/EQ/CM/EN/GR'// cRequer = "1"
			oPrint:Say  (2210,2110,"REQUER APROVACAO.....",oFont20)
			oPrint:Say  (2290,2110,"DA DIRETORIA",oFont8n)
			oPrint:Say  (2210,2110,"",oFont20)
			
		elseif !EMPTY(SC7->C7_XAPRN2)
			cIdDiret	:= Alltrim(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN2"))
			cAssDiret	:= GetSrvProfString('Startpath','') + cIdDiret + '.BMP'
			oPrint:SayBitmap(2230,2110,cAssDiret,0520,0120)
			oPrint:Say  (2180,2110,AllTrim(UsrFullName(Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN2"))),oFont8)
			oPrint:Say  (2310,2110,Posicione("ZZE",1,xFilial("ZZE") + Posicione("SC7",1,xFilial("SC7") + cNumPed,"C7_XAPRN2"),"ZZE_CARGO"),oFont8)
			
		//elseif EMPTY(SC7->C7_XAPRN2) .AND. cRequer = "2"
			//oPrint:Say  (2210,1920,"",oFont20)	
			
		endif
	
		oPrint:Box	(2170,2650,2350,3030) //
		oPrint:Say  (2180,2660,"Name / Signature",oFont8n)

		oPrint:Box	(2170,3030,2350,3300) //
		oPrint:Say  (2180,3040,"Date",oFont9n)



ENDIF



DbSelectArea("PEDCOMIR")

//oPrint:EndPage() // Finaliza a pï¿½gina

Return


//*************************************************************************************

Static Function fAjustaSx1()
local i, j
cAlias	:= Alias()
_nPerg 	:= 1


dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(cPerg)
	DO WHILE ALLTRIM(SX1->X1_GRUPO) == ALLTRIM(cPerg)
		_nPerg := _nPerg + 1
		DBSKIP()
	ENDDO
ENDIF

aRegistro:= {}
//          Grupo/Ordem/Pergunt              		/SPA/ENG/Variavl/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/Pyme/GRPSXG/HELP/PICTURE
aAdd(aRegistro,{cPerg,"01","Do Pedido?		","","","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","",""})
aAdd(aRegistro,{cPerg,"02","Ate Pedido?		","","","mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","",""})
aAdd(aRegistro,{cPerg,"03","Do Fornecedor?	","","","mv_ch3","C",06,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegistro,{cPerg,"04","Ate Fornecedor?	","","","mv_ch4","C",06,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegistro,{cPerg,"05","Da Loja?		","","","mv_ch5","C",02,00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"06","Ate Loja? 		","","","mv_ch6","C",02,00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"07","Da Emissao?		","","","mv_ch7","D",08,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"08","Ate Emissao?	","","","mv_ch8","D",08,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistro,{cPerg,"09","Do Produto?		","","","mv_ch9","C",15,00,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegistro,{cPerg,"10","Ate Produto?	","","","mv_cha","C",15,00,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
aAdd(aRegistro,{cPerg,"11","Imprim./Visual?	","","","mv_chb","N",01,00,2,"N","","mv_par11","Imprimir","","","","","Visua.Impr.","","","","","","","","","","","","","","","","","","","   ","","","",""})
aAdd(aRegistro,{cPerg,"12","Idioma OC?		","","","mv_chc","N",01,00,2,"N","","mv_par12","Ingles","","","","","Portugues","","","","","","","","","","","","","","","","","","","   ","","","",""})

IF Len(aRegistro) >= _nPerg
	For i:= _nPerg  to Len(aRegistro)
		Reclock("SX1",.t.)
		For j:=1 to FCount()
			If J<= LEN (aRegistro[i])
				FieldPut(j,aRegistro[i,j])
			Endif
		Next
		MsUnlock()
	Next
EndIf
dbSelectArea(cAlias)
Return
