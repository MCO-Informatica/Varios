#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RESTR001    º Autor ³ Valdimari Martins  Data ³ 25/01/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de PickList - Expedição                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Específico para a empresa Prozyn  			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßPßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RESTR001()

Local _aSavArea		:= GetArea()
Private _cRotina	:= "RESTR001"
Private oPrn
Private cPerg		:= _cRotina
Private oBrush		:= TBrush():New(,CLR_HGRAY)
Private oFont01		:= TFont():New( "Arial",,20,,.T.,,,,.F.,.F.) //Arial 18 - Negrito
Private oFont02		:= TFont():New( "Arial",,12,,.T.,,,,.F.,.F.) //Arial 11 - Negrito
Private oFont03		:= TFont():New( "Arial",,09,,.T.,,,,.F.,.F.) //Arial 09 - Negrito
Private oFont04		:= TFont():New( "Arial",,10,,.F.,,,,.F.,.F.) //Arial 09 - Normal
Private oFont05		:= TFont():New( "Arial",,14,,.F.,,,,.F.,.F.) //Arial 09 - Normal
Private _nLin		:= 080 //Linha inicial para impressão
Private _nLinFin	:= 570 //Linha final para impressão
Private _nEspPad	:= 020 //Espaçamento padrão entre linhas
Private _cEnter		:= CHR(13) + CHR(10)
Private aRelImp		:= MaFisRelImp("MT100",{"SF2","SD2"})
Private _nMaxDesc	:= 32
Private _lPreview	:= .T.
Private _nPag       := 0
ValidPerg() //Chamada da função para inclusão dos parâmetros da rotina

While !Pergunte(cPerg,.T.)
	If MsgYesNo("Deseja cancelar a emissão do relatório?",_cRotina+"_01")
		Return()
	EndIf
EndDo

//Chamada da função para geração do relatório
Processa({ |lEnd| GeraPDF(@lEnd) },_cRotina,"Gerando relatório... Por favor aguarde!",.T.)

//wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"","","","",.F.)

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
Local _ObsExp   := ""
Local _nLObs    := 0
Local _nFObs    := 0

Local _cAliasTmp:= GetNextAlias()

//Montagem da consulta a ser realizada no banco de dados

_cQry := " Select F2_VOLUME1 as Volume,format(cast(SF2.F2_EMISSAO as date), 'd', 'en-gb') as Emissao, SF2.F2_DOC NOTA, SA1.A1_NREDUZ CLIENTE, SB1.B1_DESC PRODUTO, "
_cQry += " SD2.D2_QUANT QUANT, SD2.D2_UM UM, SD2.D2_LOTECTL Lote, ISNULL(CONVERT(VARCHAR(2024),CONVERT(VARBINARY(2024),SC5.C5_OBSEXP)),'') as OBSExp, SA4.A4_NREDUZ Transp "
_cQry += " From " + RetSqlName("SD2") + " SD2 "                                  
_cQry += " inner join " + RetSqlName("SF2") + " SF2 on SF2.F2_DOC   = SD2.D2_DOC     "
_cQry += " inner join " + RetSqlName("SA1") + " SA1 on SA1.A1_COD   = SF2.F2_CLIENTE and SA1.A1_LOJA = SF2.F2_LOJA "
_cQry += " left join " + RetSqlName("SA4")  + " SA4 on SA4.A4_COD   = SF2.F2_TRANSP  "
_cQry += " inner join " + RetSqlName("SB1") + " SB1 on SB1.B1_COD   = SD2.D2_COD     "
_cQry += " left join " + RetSqlName("SC5")  + " SC5 on SC5.C5_NOTA  = SF2.F2_DOC     "
_cQry += " Where SF2.F2_FILIAL = '"+xFilial("SF2")+"' and SF2.D_E_L_E_T_='' and SF2.D_E_L_E_T_='' and SA1.D_E_L_E_T_='' and SA4.D_E_L_E_T_='' and SB1.D_E_L_E_T_='' and SC5.D_E_L_E_T_='' "

If !empty(dtos(mv_par01))
	_cQry += " and SF2.F2_EMISSAO >= '"+dtos(mv_par01)+"' " + _cEnter 
EndIf
If !empty(dtos(mv_par02))
	_cQry += " and SF2.F2_EMISSAO <= '"+dtos(mv_par02)+"' " + _cEnter 
EndIf

_cQry += " Order by SA4.A4_NREDUZ, SF2.F2_EMISSAO, SF2.F2_DOC"

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
    _nFobs := 1
    if !empty((_cAliasTmp)->OBSExp)
    	_nFObs := int(len(AllTrim((_cAliasTmp)->OBSExp))/30)+2
    endif	
   	//Quadro com os box's 
	oPrn:Box(_nLin-5, 0000, _nLin+(15*_nFObs), 0065, "-4")//Dt. Faturamento
	oPrn:Box(_nLin-5, 0065, _nLin+(15*_nFObs), 0165, "-4")//Nota Fiscal	
	oPrn:Box(_nLin-5, 0120, _nLin+(15*_nFObs), 0385, "-4")//Cliente
	oPrn:Box(_nLin-5, 0250, _nLin+(15*_nFObs), 0436, "-4")//Produto
	oPrn:Box(_nLin-5, 0386, _nLin+(15*_nFObs), 0486, "-4")//Lote
	oPrn:Box(_nLin-5, 0436, _nLin+(15*_nFObs), 0536, "-4")//Quantidade
	oPrn:Box(_nLin-5, 0486, _nLin+(15*_nFObs), 0590, "-4")//Unid
	oPrn:Box(_nLin-5, 0510, _nLin+(15*_nFObs), 0640, "-4")//Transportadora
	oPrn:Box(_nLin-5, 0640, _nLin+(15*_nFObs), 0760, "-4")//Obs. Expedicao
	oPrn:Box(_nLin-5, 0760, _nLin+(15*_nFObs), 0790, "-4")//Vol

	
	//Quadro com os dados    
	oPrn:SayAlign(_nLin,0005, (_cAliasTmp)->EMISSAO,  	 								     oFont04, 0800-0005,0060,,0,2)//Emissão
	oPrn:SayAlign(_nLin,0070, (_cAliasTmp)->NOTA,    			                             oFont04, 0800-0005,0060,,0,2)//Nota
	oPrn:SayAlign(_nLin,0125, SUBSTR((_cAliasTmp)->CLIENTE,1,30),                            oFont04, 0800-0005,0060,,0,2)//Cliente
	oPrn:SayAlign(_nLin,0255, SUBSTR((_cAliasTmp)->PRODUTO,1,26),                            oFont04, 0800-0005,0060,,0,2)//Produto
	oPrn:SayAlign(_nLin,0390, (_cAliasTmp)->LOTE,					                         oFont04, 0800-0005,0060,,0,2)//Lote
	oPrn:SayAlign(_nLin,0440, Transform((_cAliasTmp)->QUANT, "@E 999,999.9999"),			 oFont04, 0800-0005,0060,,0,2)//Quant
	oPrn:SayAlign(_nLin,0490, (_cAliasTmp)->UM,												 oFont04, 0800-0005,0060,,0,2)//UM
	oPrn:SayAlign(_nLin,0515, SUBSTR((_cAliasTmp)->TRANSP,1,30),                             oFont04, 0800-0005,0060,,0,2)//Transp
	oPrn:SayAlign(_nLin,0765, cValtoChar((_cAliasTmp)->Volume),                  			 oFont04, 0800-0005,0060,,0,2)//Vol
//	oPrn:SayAlign(_nLin,0645,        (_cAliasTmp)->OBSExp,		                             oFont04, 0800-0005,0060,,0,2)//Obs
    nAvObs := 0
    if !empty((_cAliasTmp)->OBSExp)
//    	_nFObs := len(AllTrim((_cAliasTmp)->OBSExp))/30+2
    	For _nLObs := 1 to _nFObs
           If _nLObs == 1
				oPrn:SayAlign(_nLin, 645,MemoLine((_cAliasTmp)->OBSExp,023,_nLObs),  oFont04, 0735-0005,0060,,0,2)							
		   Else
				oPrn:SayAlign(_nLin+nAvObs, 645,MemoLine((_cAliasTmp)->OBSExp,023,_nLObs),  oFont04, 0735-0005,0060,,0,2)							
		   EndIf
		   nAvObs += 0015    
    	next
  	    _nLin += nAvObs
    else
	  _nLin += _nEspPad  	
    endif
		
	If _nLin >= _nLinFin
		oPrn:EndPage()
		Quebra()
	Endif
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
	oPrn:SayAlign( _nLin , 0005, "Picking List - Expedição",    oFont01, 0800-0005,0060,,2,0)
	oPrn:SayAlign( _nLin , 0005, "Página: " + strzero(_nPag,2), oFont03, 0800-0005,0060,,1,0)

	_nLin += 0040+_nEspPad		
	//Quadro com os box's 
	oPrn:Box(_nLin-5, 0000, _nLin+15, 0065, "-4")//Dt. Faturamento
	oPrn:Box(_nLin-5, 0065, _nLin+15, 0165, "-4")//Nota Fiscal	
	oPrn:Box(_nLin-5, 0120, _nLin+15, 0385, "-4")//Cliente
	oPrn:Box(_nLin-5, 0250, _nLin+15, 0436, "-4")//Produto
	oPrn:Box(_nLin-5, 0386, _nLin+15, 0486, "-4")//Lote
	oPrn:Box(_nLin-5, 0436, _nLin+15, 0536, "-4")//Quantidade
	oPrn:Box(_nLin-5, 0486, _nLin+15, 0590, "-4")//Unid
	oPrn:Box(_nLin-5, 0510, _nLin+15, 0640, "-4")//Transportadora
	oPrn:Box(_nLin-5, 0640, _nLin+15, 0790, "-4")//Obs. Expedicao
	oPrn:Box(_nLin-5, 0760, _nLin+15, 0790, "-4")//Vol
	
	//Quadro com nome das colunas				
	oPrn:SayAlign(_nLin,0009, "Dt Emissão",        oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0068, "Nota Fiscal",       oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0125, "Cliente",           oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0255, "Produto",           oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0390, "Lote",              oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0440, "Qtde",              oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0487, "Unid",              oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0515, "Transportadora",    oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0645, "Obs. Expedição",    oFont02, 0800-0005,0060,,0,2)
	oPrn:SayAlign(_nLin,0765, "Vol",    		   oFont02, 0800-0005,0060,,0,2)

	_nLin += _nEspPad

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

AADD(aRegs,{cPerg,"01","De Data Faturamento:"  ,"","","mv_ch1","D",10,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Até Data Faturamento:" ,"","","mv_ch2","D",10,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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