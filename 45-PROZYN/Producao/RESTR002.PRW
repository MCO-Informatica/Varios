#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RESTR002    º Autor ³ Valdimari Martins  Data ³ 09/02/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de PickList - Expedição - Pedidos Liberados      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Específico para a empresa Prozyn  			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßPßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RESTR002()

	Local _aSavArea		:= GetArea()
	Private _cRotina	:= "RESTR002"
	Private oPrn
	Private cPerg		:= _cRotina
	Private oBrush		:= TBrush():New(,CLR_HGRAY)
	Private oFont01		:= TFont():New( "Arial",,20,,.T.,,,,.F.,.F.) //Arial 18 - Negrito
	Private oFont02		:= TFont():New( "Arial",,12,,.T.,,,,.F.,.F.) //Arial 11 - Negrito
	Private oFont03		:= TFont():New( "Arial",,09,,.T.,,,,.F.,.F.) //Arial 09 - Negrito
	Private oFont04		:= TFont():New( "Arial",,10,,.F.,,,,.F.,.F.) //Arial 09 - Normal
	Private oFont05		:= TFont():New( "Arial",,14,,.F.,,,,.F.,.F.) //Arial 09 - Normal
	Private _nLin		:= 080 //Linha inicial para impressão
	Private _nLinFin	:= 550 //Linha final para impressão
	Private _nEspPad	:= 020 //Espaçamento padrão entre linhas
	Private _cEnter		:= CHR(13) + CHR(10)
	Private aRelImp		:= MaFisRelImp("MT100",{"SC9","SC5"})
	Private _nMaxDesc	:= 32
	Private _lPreview	:= .T.
	Private _nPag       := 0
	ValidPerg() //Chamada da função para inclusão dos parâmetros da rotina

	While !Pergunte(cPerg,.T.)
		If MsgYesNo("Deseja cancelar a emissão do relatório?",_cRotina+"_01")
			RestArea(_aSavArea)
			Return()
		EndIf
	EndDo

	//Chamada da função para geração do relatório
	Processa({ |lEnd| GeraPDF(@lEnd) },_cRotina,"Gerando relatório... Por favor aguarde!",.T.)

	//wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"","","","",.F.)

	RestArea(_aSavArea)
Return()
    

Static Function GeraPDF()

Local _cFile	:= _cRotina
Local _nTipoImp	:= IMP_PDF //IMP_SPOOL //
Local _lPropTMS	:= .F.
Local _lDsbSetup:= .T.
Local _lTReport	:= .F.
Local _cPrinter	:= ""
Local _lServer	:= .F.
Local _lPDFAsPNG:= .T.
Local _lRaw		:= .F.
Local _lViewPDF	:= .T.
Local _nQtdCopy	:= 1
Local _nLObs    := 0
Local _nFObs    := 0
Local cPedAnt	:= ''

Local _cAliasTmp:= GetNextAlias()

//Montagem da consulta a ser realizada no banco de dados
// AJustado de C9_LOTECTL para C6_LOTECTL em 05/08/2020 por Zanni
_cQry := " Select format(cast(SC9.C9_DATALIB as date), 'd', 'en-gb') as Liberacao, SC9.C9_PEDIDO Pedido, SA1.A1_NREDUZ Cliente, SB1.B1_COD CODPROD, SB1.B1_DESC Produto, "
_cQry += " CASE WHEN SDC.DC_QUANT IS NULL THEN SC9.C9_QTDLIB ELSE SDC.DC_QUANT END Quant, SB1.B1_UM UM, SC5.C5_VOLUME1 as VOLUME, SC5.C5_ESPECI1 AS ESPECIE, CASE WHEN SDC.DC_LOTECTL IS NULL THEN SC6.C6_LOTECTL ELSE SDC.DC_LOTECTL END Lote, CASE WHEN SDC.DC_LOCALIZ IS NULL THEN SC6.C6_LOCALIZ ELSE SDC.DC_LOCALIZ END ENDERECO, SA4.A4_NREDUZ Transp, ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),SC5.C5_OBSEXP)),'') as OBSExp"
_cQry += " From " + RetSqlName("SC9") + " SC9 "                                  
_cQry += " INNER join "+ RetSqlName("SC5")+ " SC5 on SC5.C5_NUM   = SC9.C9_PEDIDO and SC5.D_E_L_E_T_=''  "
_cQry += " INNER join "+ RetSqlName("SC6")+ " SC6 on SC6.C6_NUM   = SC9.C9_PEDIDO and SC6.C6_ITEM = SC9.C9_ITEM and SC6.D_E_L_E_T_='' "
_cQry += " INNER join "+ RetSqlName("SA1")+ " SA1 on SA1.A1_COD   = SC9.C9_CLIENTE and SA1.A1_LOJA = SC9.C9_LOJA and SA1.D_E_L_E_T_='' "
_cQry += " INNER join "+ RetSqlName("SA4")+ " SA4 on SA4.A4_COD   = SC5.C5_TRANSP and SA4.D_E_L_E_T_=''  "
_cQry += " INNER join "+ RetSqlName("SB1")+ " SB1 on SB1.B1_COD   = SC9.C9_PRODUTO  and SB1.D_E_L_E_T_='' "
_cQry += " LEFT join "+RetSqlName("SDC")+" SDC ON DC_PEDIDO	  = C9_PEDIDO AND DC_ITEM = C9_ITEM AND DC_LOTECTL = C9_LOTECTL "
_cQry += " AND SDC.D_E_L_E_T_ = '' "
_cQry += " Where SC9.C9_FILIAL = '"+xFilial("SC9")+"' and SC9.D_E_L_E_T_='' AND SDC.D_E_L_E_T_ = '' "

If !empty(dtos(mv_par01))
	_cQry += " and SC9.C9_DATALIB >= '"+dtos(mv_par01)+"' " + _cEnter 
EndIf
If !empty(dtos(mv_par02))
	_cQry += " and SC9.C9_DATALIB <= '"+dtos(mv_par02)+"' " + _cEnter 
EndIf
If !empty(mv_par03)
	_cQry += " and SC9.C9_PEDIDO >= '"+mv_par03+"' " + _cEnter 
EndIf
If !empty(mv_par04)
	_cQry += " and SC9.C9_PEDIDO <= '"+mv_par04+"' " + _cEnter 
EndIf

_cQry += " Order by SA4.A4_NREDUZ, SC9.C9_DATALIB, SC9.C9_PEDIDO"


//Cria tabela temporária com base no resultado da query 7
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)
	
dbSelectArea(_cAliasTmp)

oPrn := FWMsPrinter():New(_cFile,_nTipoImp,_lPropTMS,,_lDsbSetup,_lTReport,,_cPrinter,_lServer,_lPDFAsPNG,_lRaw,_lViewPDF,_nQtdCopy)
oPrn:SetResolution(72)
oPrn:SetLandScape()	// Orientação do Papel (Paisagem)
oPrn:SetPaperSize(9)
//oPrn:cPathInServer(GetTempPath())
oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior

Quebra() 

dbSelectArea(_cAliasTmp)
DbGotop()
	
While !EOF()	               
    _nFobs := 2
    if !empty((_cAliasTmp)->OBSExp)
    	_nFObs := int(len(AllTrim((_cAliasTmp)->OBSExp))/30)+2
    endif	
   	//Quadro com os box's 
	oPrn:Box(_nLin-5, 0000, _nLin+(15*_nFObs), 0050, "-4")//Dt. Liberacao
	oPrn:Box(_nLin-5, 0050, _nLin+(15*_nFObs), 0090, "-4")//Pedido	
	oPrn:Box(_nLin-5, 0090, _nLin+(15*_nFObs), 0210, "-4")//Cliente
	oPrn:Box(_nLin-5, 0210, _nLin+(15*_nFObs), 0370, "-4")//Produto
	oPrn:Box(_nLin-5, 0370, _nLin+(15*_nFObs), 0440, "-4")//Lote
	oPrn:Box(_nLin-5, 0440, _nLin+(15*_nFObs), 0490, "-4")//Quantidade
	oPrn:Box(_nLin-5, 0490, _nLin+(15*_nFObs), 0540, "-4")//Unid
	oPrn:Box(_nLin-5, 0540, _nLin+(15*_nFObs), 0640, "-4")//Transportadora
	oPrn:Box(_nLin-5, 0640, _nLin+(15*_nFObs), 0790, "-4")//Obs. Expedicao

	
	//Quadro com os dados    
	oPrn:SayAlign(_nLin,0005, (_cAliasTmp)->LIBERACAO, 	 								     oFont04, 0800-0005,0060,,0,2)//Emissão
	oPrn:SayAlign(_nLin,0055, (_cAliasTmp)->PEDIDO,    			                             oFont04, 0800-0005,0060,,0,2)//Nota
	oPrn:SayAlign(_nLin,0095, SUBSTR((_cAliasTmp)->CLIENTE,1,30),                            oFont04, 0800-0005,0060,,0,2)//Cliente
	oPrn:SayAlign(_nLin,0215, Alltrim((_cAliasTmp)->CODPROD) + ' - ' +SUBSTR((_cAliasTmp)->PRODUTO,1,26),  oFont04, 0800-0005,0060,,0,2)//Produto
	oPrn:SayAlign(_nLin,0375, (_cAliasTmp)->LOTE,					                         oFont04, 0800-0005,0060,,0,2)//Lote
	oPrn:SayAlign(_nLin+10,0375, IF(!Empty((_cAliasTmp)->ENDERECO),(_cAliasTmp)->ENDERECO,"SEM ENDEREÇO"), oFont04, 0800-0005,0060,,0,2)//Endereço
	oPrn:SayAlign(_nLin,0440, Transform((_cAliasTmp)->QUANT, "@E 999,999.9999"),			 oFont04, 0800-0005,0060,,0,2)//Quant
	If (_cAliasTmp)->PEDIDO <> cPedAnt
		oPrn:SayAlign(_nLin+10,0440, Transform((_cAliasTmp)->VOLUME, "@E 999,999"),	     		 oFont04, 0800-0005,0060,,0,2)//VOLUME	
	EndIf
	oPrn:SayAlign(_nLin,0495, (_cAliasTmp)->UM,												 oFont04, 0800-0005,0060,,0,2)//UM
	If (_cAliasTmp)->PEDIDO <> cPedAnt
		oPrn:SayAlign(_nLin+10,0495, (_cAliasTmp)->ESPECIE,										 oFont04, 0800-0005,0060,,0,2)//ESPECIE
	EndIf
	oPrn:SayAlign(_nLin,0545, SUBSTR((_cAliasTmp)->TRANSP,1,30),                             oFont04, 0800-0005,0060,,0,2)//Transp
    nAvObs := 0
    if !empty((_cAliasTmp)->OBSExp)
//    	_nFObs := len(AllTrim((_cAliasTmp)->OBSExp))/30+2
    	For _nLObs := 1 to _nFObs
           If _nLObs == 1
				oPrn:SayAlign(_nLin, 645,MemoLine((_cAliasTmp)->OBSExp,030,_nLObs),  oFont04, 0800-0005,0060,,0,2)							
		   Else
				oPrn:SayAlign(_nLin+nAvObs, 645,MemoLine((_cAliasTmp)->OBSExp,030,_nLObs),  oFont04, 0800-0005,0060,,0,2)							
		   EndIf
		   nAvObs += 0015    
    	next
  	    _nLin += nAvObs
    else
	  _nLin += _nEspPad + 10
    endif
		
	If _nLin >= _nLinFin
		oPrn:EndPage()
		Quebra()
	Endif
	cPedAnt := (_cAliasTmp)->PEDIDO
	dbskip()
EndDo	
    
_nLin +=10
		        
oPrn:EndPage()
oPrn:Preview()

Return()


Static Function Quebra()

oPrn:StartPage()   

_nLin := 080
_nPag += 1

	ImpLogo() 
 

	oPrn:SayAlign(  0050 , 0005, "Emissão: " + DTOC(DDataBase), oFont03, 0800-0005,0060,,1,0)
    oPrn:SayAlign(  0060 , 0005, "Hora: " + SUBSTR(TIME(), 1, 2)+":"+ SUBSTR(TIME(), 4, 2)+":"+SUBSTR(TIME(), 7, 2), oFont03, 0800-0005,0060,,1,0)
	oPrn:SayAlign( _nLin , 0005, "Picking List - Expedição",    oFont01, 0800-0005,0060,,2,0)
	oPrn:SayAlign( _nLin , 0005, "Página: " + strzero(_nPag,2), oFont03, 0800-0005,0060,,1,0)

	_nLin += 0040+_nEspPad		
	//Quadro com os box's 
	oPrn:Box(_nLin-5, 0000, _nLin+30, 0050, "-4")//Dt. Liberação
	oPrn:Box(_nLin-5, 0050, _nLin+30, 0090, "-4")//Pedido	
	oPrn:Box(_nLin-5, 0090, _nLin+30, 0210, "-4")//Cliente
	oPrn:Box(_nLin-5, 0210, _nLin+30, 0370, "-4")//Produto
	oPrn:Box(_nLin-5, 0370, _nLin+30, 0440, "-4")//Lote
	oPrn:Box(_nLin-5, 0440, _nLin+30, 0490, "-4")//Quantidade / Volume
	oPrn:Box(_nLin-5, 0490, _nLin+30, 0540, "-4")//Unid / Espécie
	oPrn:Box(_nLin-5, 0540, _nLin+30, 0640, "-4")//Transportadora
	oPrn:Box(_nLin-5, 0640, _nLin+30, 0790, "-4")//Obs. Expedicao
	
	//Quadro com nome das colunas				
	oPrn:SayAlign(_nLin,0003, "Liberação",         oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0055, "Pedido",            oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0095, "Cliente",           oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0215, "Produto",           oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0375, "Lote /",            oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin+10,0375, "Endereço",       oFont02, 0800-0005,0060,,0,2)	
	oPrn:SayAlign(_nLin,0445, "Qtde /",            oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin+10,0445, "Volume",         oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0495, "Unid /",            oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin+10,0495, "Espécie",        oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0545, "Transportadora",    oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0645, "Obs. Expedição",    oFont02, 0800-0005,0060,,0,2)

	_nLin += _nEspPad + 10

Return()

Static Function ImpLogo()

	Local cLogo      	:= FisxLogo("1")
	Local cLogoD	    := ""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Logotipo                                     						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	lMv_Logod	:= .T.
	
	cLogoD := GetSrvProfString("Startpath","") + "lgrl" + cEmpAnt + cFilAnt + ".BMP"
	
	If !File(cLogoD)
		cLogoD	:= GetSrvProfString("Startpath","") + "lgrl" + "01" + ".BMP"
		If !File(cLogoD)
			lMv_Logod := .F.
		EndIf
	EndIf
	
	If lMv_Logod
		oPrn:SayBitmap(050,010,cLogoD,0170,100)
	Else               
		oPrn:SayBitmap(050,010,cLogo ,0170,100)
	EndIf

Return()

Static Function ValidPerg()

Local _sAlias	:= GetArea()
Local aRegs		:= {}
Local _x		:= 1
Local _y		:= 1
cPerg			:= PADR(cPerg,10)

AADD(aRegs,{cPerg,"01","De Data Liberacao:"  ,"","","mv_ch1","D",10,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Até Data Liberacao:" ,"","","mv_ch2","D",10,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","De Pedido:" 		 ,"","","mv_ch3","C", 6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SC5","","","",""})
AADD(aRegs,{cPerg,"04","Até Pedido:" 		 ,"","","mv_ch4","C", 6,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SC5","","","",""})

For _x := 1 To Len(aRegs)
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	If !SX1->(MsSeek(cPerg+aRegs[_x,2],.T.,.F.))
		RecLock("SX1",.T.)		
		For _y := 1 To FCount()                              
			If _y <= Len(aRegs[_x])                         
				FieldPut(_y,aRegs[_x,_y])        
			Else
				Exit
			EndIf
		Next
		SX1->(MsUnlock())
	EndIf
Next

RestArea(_sAlias)

Return()  
