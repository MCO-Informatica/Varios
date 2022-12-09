#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCRMR001    º Autor ³ Derik Santos     º Data ³ 26/08/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório proposta de venda                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RCRMR006()

Local _aSavArea		:= GetArea()
Local _aSavSCJ		:= SCJ->(GetArea())
Local _aSavSM2		:= SM2->(GetArea())
Private _cRotina	:= "RCRM006"
Private oPrn
Private cPerg		:= _cRotina
Private oBrush		:= TBrush():New(,CLR_HGRAY)
Private oFont01		:= TFont():New( "Arial",,18,,.T.,,,,.F.,.F.) //Arial 18 - Negrito
Private oFont02		:= TFont():New( "Arial",,15,,.T.,,,,.F.,.F.) //Arial 11 - Negrito
Private oFont03		:= TFont():New( "Arial",,11,,.T.,,,,.F.,.F.) //Arial 09 - Negrito
Private oFont04		:= TFont():New( "Arial",,11,,.F.,,,,.F.,.F.) //Arial 09 - Normal
Private _nLin		:= 050 //Linha inicial para impressão
Private _nLinFin	:= 570 //Linha final para impressão
Private _nEspPad	:= 020 //Espaçamento padrão entre linhas
Private _cEnter		:= CHR(13) + CHR(10)
Private aRelImp		:= MaFisRelImp("MT100",{"SF2","SD2"})
Private _nMaxDesc	:= 32

ValidPerg() //Chamada da função para inclusão dos parâmetros da rotina

While !Pergunte(cPerg,.T.)
	If MsgYesNo("Deseja cancelar a emissão do relatório?",_cRotina+"_01")
		Return()
	EndIf
EndDo

//Chamada da função para geração do relatório
Processa({ |lEnd| GeraPDF(@lEnd) },_cRotina,"Gerando relatório... Por favor aguarde!",.T.)

RestArea(_aSavSCJ)
RestArea(_aSavSM2)
RestArea(_aSavArea)

Return()

Static Function GeraPDF()

Local _cFile	:= _cRotina
Local _nTipoImp	:= IMP_PDF
Local _lPropTMS	:= .F.
Local _lDsbSetup:= .F.
Local _lTReport	:= .F.
Local _cPrinter	:= ""
Local _lServer	:= .F.
Local _lPDFAsPNG:= .T.
Local _lRaw		:= .F.
Local _lViewPDF	:= .T.
Local _nQtdCopy	:= 1

oPrn := FWMsPrinter():New(_cFile,_nTipoImp,_lPropTMS,,_lDsbSetup,_lTReport,,_cPrinter,_lServer,_lPDFAsPNG,_lRaw,_lViewPDF,_nQtdCopy)

oPrn:SetResolution(72)
oPrn:SetLandScape()	// Orientação do Papel (Paisagem)
oPrn:SetPaperSize(9)
oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior

Selecao()

oPrn:EndPage()
oPrn:Preview()

Return()

Static Function ImpCab()
		
	//Verifico se é a primeira página
	If !oPrn:IsFirstPage
		oPrn:EndPage()
	EndIf
	
	oPrn:StartPage()
	
	_nLin := 0040
	
	oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*2), 0800, "-4")
	
	oPrn:Say( _nLin, 0005, "" ,oFont01, 0800) //Imprimo uma linha em branco pela função say, para que a função sayalign passe a funcionar, bug interno ADVPL
	
	oPrn:SayAlign( _nLin + (_nEspPad/2), 0005, "Confirmação da Proposta " + AllTrim(_aCab[06]), oFont01, 0800-0005,0060,,2,0)
//	oPrn:SayAlign( _nLin + (_nEspPad/2), 0005, "Confirmação do Orçamento", oFont01, 0800-0005,0060,,2,0)	
  
		_nLin +=  _nEspPad * 2
	
	//Box do logotipo
	oPrn:Box( _nLin, 0200, _nLin + (_nEspPad*5), 0800, "-4")
	
	ImpLogo()
	
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Data:", oFont04, 0200-0005,0060,,0,0)
	oPrn:SayAlign( _nLin+5 , 0205, _aCab[01], oFont03, 0400-0205,0060,,0,0)
	_nLin += _nEspPad
	
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Empresa:", oFont04, 0200-0005,0060,,0,0)
	oPrn:SayAlign( _nLin+5 , 0205, _aCab[02], oFont04, 0400-0205,0060,,0,0)
	_nLin += _nEspPad
	
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Razão Social:", oFont04, 0200-0005,0060,,0,0)
	oPrn:SayAlign( _nLin+5 , 0205, _aCab[03], oFont04, 0400-0205,0060,,0,0)	
	_nLin += _nEspPad
	
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " CNPJ:", oFont04, 0200-0005,0060,,0,0)	
	oPrn:SayAlign( _nLin+5 , 0205, _aCab[04], oFont04, 0400-0205,0060,,0,0)	
	_nLin += _nEspPad
	
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Comprador:", oFont04, 0200-0005,0060,,0,0)	
	oPrn:SayAlign( _nLin+5 , 0205, _aCab[05], oFont04, 0400-0205,0060,,0,0)	
	_nLin += _nEspPad
	
//	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
//	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
//	oPrn:SayAlign( _nLin+5 , 0005, " Ordem de Compra:", oFont04, 0200-0005,0060,,0,0)
//	oPrn:SayAlign( _nLin+5 , 0205, _aCab[06], oFont04, 0400-0205,0060,,0,0)	
//	_nLin += _nEspPad
	
//	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
//	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
//	oPrn:SayAlign( _nLin+5 , 0005, " Data da emissão da NF:", oFont04, 0200-0005,0060,,0,0)	
//	oPrn:SayAlign( _nLin+5 , 0205, IIF(Len(_aDtEntr)==1,DTOC(STOD(_aDtEntr[1])),"Vide Observação"), oFont04, 0400-0205,0060,,0,0)	
//	_nLin += _nEspPad
	
//	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
//	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0400, "-4")
//	oPrn:SayAlign( _nLin+5 , 0005, " Data da expedição:", oFont04, 0200-0005,0060,,0,0)
//	oPrn:SayAlign( _nLin+5 , 0205, IIF(Len(_aDtExpe)==1,DTOC(STOD(_aDtExpe[1])),"Vide Observação"), oFont04, 0400-0205,0060,,0,0)
//	_nLin += _nEspPad
	
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
		oPrn:SayBitmap(082,500,cLogoD,0130,90)
	Else
		oPrn:SayBitmap(082,500,cLogo ,0130,90)
	EndIf

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidPerg   º Autor ³ Derik Santos     º Data ³ 26/08/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função responsável pela inclusão dos parâmetros da rotina. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn                			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ValidPerg()

Local _sAlias	:= GetArea()
Local aRegs		:= {}
Local _x		:= 1
Local _y		:= 1
cPerg			:= PADR(cPerg,10)

AADD(aRegs,{cPerg,"01","Orçamento:"	,"","","mv_ch1","C",TamSx3("CJ_NUM")[01],TamSx3("CJ_NUM")[02],0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SCJ","","","",""})

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


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Selecao     º Autor ³ Derik Santos     º Data ³ 26/08/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função responsável pela consulta dos registros via banco deº±±
±±º          ³ dados.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn                			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Selecao()
	
	Local _cAliasTmp:= GetNextAlias()
	Local _aItem	:= {}
	Local _cMoeda	:= ""
	Local _cTaxa	:= ""
	Private _aCab	:= {}
	Private _aItens	:= {}
	Private _aCond	:= {}
	Private _aObs	:= {}
	Private _aDtEntr:= {}
	Private _aDtExpe:= {}
	
	//Montagem da consulta a ser realizada no banco de dados
	_cQry := "SELECT " + _cEnter
	_cQry += "ISNULL((SELECT U5_CONTAT FROM " + RetSqlName("AC8") + " AC8 INNER JOIN " + RetSqlName("SU5") + " SU5 ON AC8.D_E_L_E_T_='' AND AC8.AC8_FILIAL='" + xFilial("AC8") + "' AND AC8_ENTIDA='SA1' AND AC8_CODENT='00000101' AND SU5.D_E_L_E_T_='' AND SU5.U5_FILIAL='" + xFilial("SU5") + "' AND SU5.U5_CODCONT=AC8.AC8_CODCON AND U5_DEPTO=(SELECT TOP 1 QB_DEPTO FROM " + RetSqlName("SQB") + " SQB WHERE SQB.D_E_L_E_T_='' AND SQB.QB_FILIAL='" + xFilial("SQB") + "' AND Upper(SQB.QB_DESCRIC) LIKE '%COMPRA%')),'') AS [COMPRADOR], " + _cEnter
	_cQry += "SCJ.R_E_C_N_O_ [CJ_RECNO], "
	_cQry += "* " + _cEnter
	_cQry += "FROM " + RetSqlName("SCJ") + " SCJ " + _cEnter
	_cQry += "INNER JOIN " + RetSqlName("SCK") + " SCK " + _cEnter
	_cQry += "ON SCJ.D_E_L_E_T_='' " + _cEnter
	_cQry += "AND SCJ.CJ_FILIAL='" + xFilial("SCJ") + "' " + _cEnter
	_cQry += "AND SCK.D_E_L_E_T_='' " + _cEnter
	_cQry += "AND SCK.CK_FILIAL='" + xFilial("SCK") + "' " + _cEnter
	_cQry += "AND SCJ.CJ_NUM=SCK.CK_NUM " + _cEnter
	_cQry += "AND SCJ.CJ_NUM='" + MV_PAR01 + "' " + _cEnter
	_cQry += "AND SCJ.CJ_TIPO NOT IN ('D','B') " + _cEnter
	_cQry += "INNER JOIN " + RetSqlName("SA1") + " SA1 " + _cEnter
	_cQry += "ON SA1.D_E_L_E_T_='' " + _cEnter
	_cQry += "AND SA1.A1_FILIAL='" + xFilial("SA1") + "' " + _cEnter
	_cQry += "AND SA1.A1_COD=SCJ.CJ_CLIENT " + _cEnter
	_cQry += "AND SA1.A1_LOJA=SCJ.CJ_LOJA " + _cEnter	
	_cQry += "INNER JOIN " + RetSqlName("SB1") + " SB1  "
	_cQry += "ON SB1.D_E_L_E_T_='' "
	_cQry += "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' "
	_cQry += "AND SB1.B1_COD=SCK.CK_PRODUTO "
	_cQry += "LEFT JOIN " + RetSqlName("SE4") + " SE4 " + _cEnter
	_cQry += "ON SE4.D_E_L_E_T_='' " + _cEnter
	_cQry += "AND SE4.E4_FILIAL='" + xFilial("SE4") + "' " + _cEnter
	_cQry += "AND SE4.E4_CODIGO=SCJ.CJ_CONDPAG " + _cEnter
	_cQry += "ORDER BY CK_ITEM " + _cEnter
	
	//Cria tabela temporária com base no resultado da query 7
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAliasTmp,.T.,.F.)
	
	dbSelectArea(_cAliasTmp)
		
	While (_cAliasTmp)->(!EOF())
	
		If (_cAliasTmp)->CJ_MOEDA < 6
			_cMoeda := "MV_MOEDA" + AllTrim(Str((_cAliasTmp)->CJ_MOEDA))
		ElseIf (_cAliasTmp)->CJ_MOEDA < 10
			_cMoeda := "MV_MOEDAP" + AllTrim(Str((_cAliasTmp)->CJ_MOEDA))
		Else
			_cMoeda := "MV_MOEDP" + AllTrim(Str((_cAliasTmp)->CJ_MOEDA))
		EndIf
		
		_cMoeda := SuperGetMV(_cMoeda,,"")
		
		If (_cAliasTmp)->CJ_MOEDA==1
			_cTaxa := "Não se aplica"
		Else
			dbSelectArea("SM2")
			dbSetOrder(1)
			If dbSeek(STOD((_cAliasTmp)->CK_ENTREG))
				If !Empty(SC5->C5_TXREF)
					_cTaxa := Transform(SC5->C5_TXREF,PesqPict("SM2","M2_MOEDA"+AllTrim(Str((_cAliasTmp)->CJ_MOEDA))))
				Else
					If (_cAliasTmp)->CJ_MOEDA<10
						_cTaxa := Transform(&("SM2->M2_MOEDA"+AllTrim(Str((_cAliasTmp)->CJ_MOEDA))),PesqPict("SM2","M2_MOEDA"+AllTrim(Str((_cAliasTmp)->CJ_MOEDA))))
					Else
						_cTaxa := Transform(&("SM2->M2_MOED" +AllTrim(Str((_cAliasTmp)->CJ_MOEDA))),PesqPict("SM2","M2_MOED" +AllTrim(Str((_cAliasTmp)->CJ_MOEDA))))
					EndIf
				EndIf
			Else
				_cTaxa := "Taxa não cadastrada"
			EndIf
		EndIf
		
		//Caso seja o primeiro item, preencho array com informações que deverão ser impressas no cabeçalho do relatório
		If Empty(_aCab)
			AAdd(_aCab,DTOC(STOD((_cAliasTmp)->CJ_EMISSAO)))
			AAdd(_aCab,(_cAliasTmp)->A1_NREDUZ)
			AAdd(_aCab,(_cAliasTmp)->A1_NOME)
			AAdd(_aCab,Transform((_cAliasTmp)->A1_CGC,IIF(Len(AllTrim((_cAliasTmp)->A1_CGC))==11,"@R 999.999.999-99","@R 99.999.999/9999-99")))
			AAdd(_aCab,(_cAliasTmp)->COMPRADOR)
//			AAdd(_aCab,(_cAliasTmp)->CJ_NUMPCOM) 
//			AAdd(_aCab,"000002")
			AAdd(_aCab,(_cAliasTmp)->CJ_NUM)
			
			
			//Inicio a função MaFis para cálculo dos impostos
			MaFisIni((_cAliasTmp)->CJ_CLIENT,;			// 1-Codigo Cliente/Fornecedor
			(_cAliasTmp)->CJ_LOJA,;						// 2-Loja do Cliente/Fornecedor
			IIF((_cAliasTmp)->CJ_TIPO $ 'DB',"F","C"),;	// 3-C:Cliente , F:Fornecedor
			(_cAliasTmp)->CJ_TIPO,;						// 4-Tipo da NF
			(_cAliasTmp)->CJ_TIPO,;			   			// 5-Tipo do Cliente/Fornecedor
			aRelImp,;									// 6-Relacao de Impostos que suportados no arquivo
			,;						   					// 7-Tipo de complemento
			,;											// 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1",;										// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MATA461")									// 10-Nome da rotina que esta utilizando a funcao
		EndIf

		//Adiciono o item no MaFis para composição dos valores
		MaFisAdd((_cAliasTmp)->CK_PRODUTO,;	// 1-Codigo do Produto ( Obrigatorio )
		(_cAliasTmp)->CK_TES,;				// 2-Codigo do TES ( Opcional )
		(_cAliasTmp)->CK_QTDVEN,;			// 3-Quantidade ( Obrigatorio )
		(_cAliasTmp)->CK_PRUNIT,;			// 4-Preco Unitario ( Obrigatorio )
		(_cAliasTmp)->CK_VALDESC,;			// 5-Valor do Desconto ( Opcional )
		"000001",;//(_cAliasTmp)->CK_NFORI,;			// 6-Numero da NF Original ( Devolucao/Benef )
		"000001",;//(_cAliasTmp)->CK_SERIORI,;			// 7-Serie da NF Original ( Devolucao/Benef )
		0,;									// 8-RecNo da NF Original no arq SD1/SD2
		0,;									// 9-Valor do Frete do Item ( Opcional )
		0,;									// 10-Valor da Despesa do item ( Opcional )
		0,;									// 11-Valor do Seguro do item ( Opcional )
		0,;									// 12-Valor do Frete Autonomo ( Opcional )
		(_cAliasTmp)->CK_PRCVEN,;			// 13-Valor da Mercadoria ( Obrigatorio )
		0,;									// 14-Valor da Embalagem ( Opiconal )
		0,;									// 15-RecNo do SB1
		0)									// 16-RecNo do SF4
		
		//Verifico se a data de entrega do item é igual ao anterior ou não
		If aScan(_aDtEntr,(_cAliasTmp)->CK_ENTREG)==0
			AAdd(_aDtEntr,(_cAliasTmp)->CK_ENTREG)
		EndIf

		//Verifico se a data de expedição do item é igual ao anterior ou não
//		If aScan(_aDtExpe,(_cAliasTmp)->CK_DTEXPED)==0
			AAdd(_aDtExpe,"20160826")//(_cAliasTmp)->CK_DTEXPED)
//		EndIf
		_nPreTot := (_cAliasTmp)->CK_PRCVEN * (_cAliasTmp)->CK_QTDVEN
		_aItem := {}
		
		//Populo array com informações a serem impressas nos itens do relatório
		AAdd(_aItem,(_cAliasTmp)->CK_ITEM)
		AAdd(_aItem,AllTrim((_cAliasTmp)->B1_DESC))
		AAdd(_aItem,Transform((_cAliasTmp)->CK_QTDVEN,PesqPict("SCK","CK_QTDVEN")))
		AAdd(_aItem,(_cAliasTmp)->CK_UM)
		AAdd(_aItem,Transform((_cAliasTmp)->CK_PRCVEN,PesqPict("SCK","CK_PRCVEN")))//Preço unitario
		AAdd(_aItem,_cMoeda)
		AAdd(_aItem,AllTrim(Str(MaFisRet(Len(_aItens)+1,"IT_ALIQICM")))+ "%")  //ICMS
		AAdd(_aItem,Transform((_nPreTot * MaFisRet(Len(_aItens)+1,"IT_ALIQICM")/100),"@E 9,999.99" ))  //PIS+COFINS
		AAdd(_aItem,Transform(_nPreTot,PesqPict("SCK","CK_PRCVEN"))) //Preço total
		AAdd(_aItem," - ")  //IPI
		AAdd(_aItem,(_cAliasTmp)->B1_ESPECIE)
		AAdd(_aItem,DTOC(STOD((_cAliasTmp)->CK_ENTREG)))
		AAdd(_aItem,DTOC(STOD((_cAliasTmp)->CK_DT1VEN)))
		AAdd(_aItens,_aItem)
		
		//Preencho informações sobre a transportadora e condição de pagamento
		If Empty(_aCond)
			AAdd(_aCond,_cTaxa)
			AAdd(_aCond,(_cAliasTmp)->E4_DESCRI)
//			AAdd(_aCond,(_cAliasTmp)->A4_NREDUZ)
//			AAdd(_aCond,(_cAliasTmp)->CJ_TPFRETE)
//			AAdd(_aCond,"FOB")
		EndIf
		
//		dbSelectArea("SCJ")
//		dbGoTo((_cAliasTmp)->CJ_RECNO) 
//		dbGoTo("2")		
		
		//Preencho informação com a observação do pedido, por se tratar de um campo memo, posiciono na própria SC5, via query haveria uma limitação de 1024 caracteres
//		_aObs := {SCJ->CJ_OBS}
		_aObs := {"."}
		
		dbSelectArea(_cAliasTmp)
		dbSkip()
	EndDo
	
	dbSelectArea(_cAliasTmp)
	(_cAliasTmp)->(dbCloseArea())
	
	ImpCab() 	//Imprime cabecalho do relatório
	ImpItens() 	//Imprime os itens do pedido
	ImpCond()	//Imprime as condições comerciais
	ImpObs()	//Imprime as observações
	
Return()

Static Function ImpItens()

	Local _nItem	:= 1	
	Local _nQuebLin := 1
	Local _nNumCar	:= 0
	Local _nPalavra	:= 0
			
	_nLin += _nEspPad
	
	oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*3), 0030, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, "Item", oFont03, 0030-0005,0060,,2,0)
	
	oPrn:Box( _nLin, 0030, _nLin + (_nEspPad*3), 0200, "-4")
	oPrn:SayAlign( _nLin+5 , 0030, "Produto", oFont03, 0200-0030,0060,,2,0)
	
	oPrn:Box( _nLin, 0200, _nLin + (_nEspPad*3), 0270, "-4")
	oPrn:SayAlign( _nLin+5 , 0200, "Quantidade", oFont03, 0270-0200,0060,,2,0)
	
	oPrn:Box( _nLin, 0270, _nLin + (_nEspPad*3), 0300, "-4")
	oPrn:SayAlign( _nLin+5 , 0270, "Unid", oFont03, 0300-0270,0060,,2,0)
	
	oPrn:Box( _nLin, 0300, _nLin + (_nEspPad*3), 0400, "-4")
	oPrn:SayAlign( _nLin+5 , 0300, "Preço unitário", oFont03, 0400-0300,0060,,2,0)
	
	oPrn:Box( _nLin, 0400, _nLin + (_nEspPad*3), 0440, "-4")
	oPrn:SayAlign( _nLin+5 , 0400, "Moeda", oFont03, 0440-0400,0060,,2,0)
	
	oPrn:Box( _nLin, 0440, _nLin + (_nEspPad*3), 0475, "-4")
	oPrn:SayAlign( _nLin+5 , 0440, "ICMS %", oFont03, 0475-0440,0060,,2,0)
	
	oPrn:Box( _nLin, 0475, _nLin + (_nEspPad*3), 0535, "-4")
	oPrn:SayAlign( _nLin+5 , 0475, "ICMS R$", oFont03, 0535-0475,0060,,2,0)
	
	oPrn:Box( _nLin, 0535, _nLin + (_nEspPad*3), 0640, "-4")
	oPrn:SayAlign( _nLin+5 , 0535, "Preço Total", oFont03, 0640-0535,0060,,2,0)
	
//	oPrn:Box( _nLin, 0605, _nLin + (_nEspPad*3), 0640, "-4")
//	oPrn:SayAlign( _nLin+5 , 0605, "IPI", oFont03, 0640-0605,0060,,2,0)
	
	oPrn:Box( _nLin, 0640, _nLin + (_nEspPad*3), 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0640, "Embalagem", oFont03, 0800-0640,0060,,2,0)
	
	_nLin += _nEspPad*3
	
	For _nItem := 1 To Len(_aItens)
		
		_aPalavras := Separa(AllTrim(_aItens[_nItem,02])," ")
		
		_nNumCar := 0
		_nQuebLin:= 1
		
		For _nPalavra := 1 To Len(_aPalavras)
			_nNumCar += Len(_aPalavras[_nPalavra]) + 1
			
			If _nPalavra + 1 <= Len(_aPalavras)
				If _nNumCar + Len(_aPalavras[_nPalavra+1]) + 1 >= _nMaxDesc
					_nQuebLin++
					_nNumCar := 0
				EndIf
			ElseIf _nNumCar >= _nMaxDesc
				_nQuebLin++
			EndIf
		Next
		
		oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*_nQuebLin), 0030, "-4")
		oPrn:Box( _nLin, 0030, _nLin + (_nEspPad*_nQuebLin), 0200, "-4")
		oPrn:Box( _nLin, 0200, _nLin + (_nEspPad*_nQuebLin), 0270, "-4")
		oPrn:Box( _nLin, 0270, _nLin + (_nEspPad*_nQuebLin), 0300, "-4")
		oPrn:Box( _nLin, 0300, _nLin + (_nEspPad*_nQuebLin), 0400, "-4")
		oPrn:Box( _nLin, 0400, _nLin + (_nEspPad*_nQuebLin), 0440, "-4")
		oPrn:Box( _nLin, 0440, _nLin + (_nEspPad*_nQuebLin), 0475, "-4")
		oPrn:Box( _nLin, 0475, _nLin + (_nEspPad*_nQuebLin), 0535, "-4")
		oPrn:Box( _nLin, 0535, _nLin + (_nEspPad*_nQuebLin), 0640, "-4")
//		oPrn:Box( _nLin, 0605, _nLin + (_nEspPad*_nQuebLin), 0640, "-4")
		oPrn:Box( _nLin, 0640, _nLin + (_nEspPad*_nQuebLin), 0800, "-4")
		
		oPrn:SayAlign( _nLin+5 , 0005, Space(1) + _aItens[_nItem,01] + Space(1)	, oFont04, 0030-0005,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0035, _aItens[_nItem,02]						, oFont04, 0200-0035,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0200, Space(1) + _aItens[_nItem,03] + Space(1)	, oFont04, 0270-0200,0060,,1,0)
		oPrn:SayAlign( _nLin+5 , 0270, Space(1) + _aItens[_nItem,04] + Space(1)	, oFont04, 0300-0270,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0300, Space(1) + _aItens[_nItem,05] + Space(1)	, oFont04, 0400-0300,0060,,1,0)
		oPrn:SayAlign( _nLin+5 , 0400, Space(1) + _aItens[_nItem,06] + Space(1)	, oFont04, 0440-0400,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0440, Space(1) + _aItens[_nItem,07] + Space(1)	, oFont04, 0475-0440,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0475, Space(1) + _aItens[_nItem,08] + Space(1)	, oFont04, 0535-0475,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0535, Space(1) + _aItens[_nItem,09] + Space(1)	, oFont04, 0605-0535,0060,,1,0)
//		oPrn:SayAlign( _nLin+5 , 0605, Space(1) + _aItens[_nItem,10] + Space(1)	, oFont04, 0640-0605,0060,,0,0)
		oPrn:SayAlign( _nLin+5 , 0640, Space(1) + _aItens[_nItem,11] + Space(1)	, oFont04, 0800-0640,0060,,0,0)
		
		_nLin += (_nEspPad*_nQuebLin)
		
		QuebraPag()
	Next
	
Return()

Static Function ImpCond()

	_nLin += _nEspPad		
	QuebraPag()
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Condições Comerciais:", oFont02, 0800-0005,0060,,0,0)
	_nLin += _nEspPad
	QuebraPag()	
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4") 
	oPrn:SayAlign( _nLin+5 , 0005, " Taxa de câmbio:", oFont04, 0200-0005,0060,,0,0)
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0205, Space(1) + _aCond[1], oFont04, 0800-0205,0060,,0,0)
	_nLin += _nEspPad
	QuebraPag()	
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Prazo de pagamento:", oFont04, 0200-0005,0060,,0,0)	
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0205, Space(1) + _aCond[2], oFont04, 0800-0205,0060,,0,0)	
	_nLin += _nEspPad
	QuebraPag()	
/*	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Transportadora:", oFont04, 0200-0005,0060,,0,0)
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0205, Space(1) + _aCond[3], oFont04, 0800-0205,0060,,0,0)	
	_nLin += _nEspPad
	QuebraPag()	
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0200, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Frete:", oFont04, 0200-0005,0060,,0,0)
	oPrn:Box( _nLin, 0200, _nLin + _nEspPad, 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0205, Space(1) + _aCond[4], oFont04, 0800-0205,0060,,0,0)	
	_nLin += _nEspPad
	QuebraPag()*/	
Return()

Static Function ImpObs()
	
	Local _nItem := 1
	
	_nLin += _nEspPad
		
	QuebraPag()
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Observações:", oFont02, 0800-0005,0060,,0,0)
	_nLin += _nEspPad
	QuebraPag()
	
	If Len(_aDtEntr)>1 .Or. Len(_aDtExpe)>1
		For _nItem := 1 To Len(_aItens)
			oPrn:SayAlign( _nLin+5 , 0005, "Item: " + AllTrim(_aItens[_nItem,01]) + " - Dt. Faturamento: " + _aItens[_nItem,12] + " - Dt. Expedição: " + _aItens[_nItem,13], oFont04, 0800-0005,0060,,0,0)
			_nLin += (_nEspPad-5)
			QuebraPag()
		Next
		 
		_nLin += 5
		QuebraPag()
	EndIf
	
	oPrn:SayAlign( _nLin+5 , 0005, AllTrim(_aObs[1]), oFont04, 0800-0005,0060,,0,0)
Return()

Static Function QuebraPag()
	
	If _nLin >= _nLinFin
		oPrn:EndPage()
		oPrn:StartPage()
		
		_nLin := 0040
		
		oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*2), 0800, "-4")
		
		oPrn:Say( _nLin, 0005, "" ,oFont01, 0800) //Imprimo uma linha em branco pela função say, para que a função sayalign passe a funcionar, bug interno ADVPL
		
		oPrn:SayAlign( _nLin + (_nEspPad/2), 0005, "Confirmação da Proposta " + AllTrim(_aCab[06]), oFont01, 0800-0005,0060,,2,0)
//		oPrn:SayAlign( _nLin + (_nEspPad/2), 0005, "Confirmação do Orçamento", oFont01, 0800-0005,0060,,2,0)
		
		_nLin +=  _nEspPad * 2
	EndIf
	
Return()