#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RPCPR003    º Autor ³ Adriano Leonardo º Data ³ 25/10/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de prioridade de ordem de produção.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RPCPR003(_aHeadCpy,_aColsCpy,_cSala)

Local _aSavArea		:= GetArea()
Local _aSavSC5		:= SC5->(GetArea())
Local _aSavSM2		:= SM2->(GetArea())
Default _aColsCpy	:= {}
Default _aHeadCpy	:= {}
Default _cSala		:= ""
Private _aCols		:= aClone(_aColsCpy)
Private _aHeader	:= aClone(_aHeadCpy)
Private _cCodSala	:= _cSala
Private _cRotina	:= "RPCPR003"
Private oPrn
Private cPerg		:= _cRotina
Private oBrush		:= TBrush():New(,CLR_HGRAY)
Private oFont01		:= TFont():New( "Arial",,18,,.T.,,,,.F.,.F.) //Arial 18 - Negrito
Private oFont02		:= TFont():New( "Arial",,15,,.T.,,,,.F.,.F.) //Arial 11 - Negrito
Private oFont03		:= TFont():New( "Arial",,11,,.T.,,,,.F.,.F.) //Arial 09 - Negrito
Private oFont04		:= TFont():New( "Arial",,11,,.F.,,,,.F.,.F.) //Arial 09 - Normal
Private oFont05		:= TFont():New( "Arial",,10,,.F.,,,,.F.,.F.) //Arial 09 - Normal
Private _nLin		:= 050 //Linha inicial para impressão
Private _nLinFin	:= 570 //Linha final para impressão
Private _nEspPad	:= 020 //Espaçamento padrão entre linhas
Private _cEnter		:= CHR(13) + CHR(10)

//Chamada da função para geração do relatório
Processa({ |lEnd| GeraPDF(@lEnd) },_cRotina,"Gerando relatório... Por favor aguarde!",.T.)

RestArea(_aSavSC5)
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

ImpCab()
ImpItens()
ImpRodape()

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
	
	oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*4), 0800, "-4") //Box sequência de produção

	oPrn:Say( _nLin, 0005, "" ,oFont01, 0800) //Imprimo uma linha em branco pela função say, para que a função sayalign passe a funcionar, bug interno ADVPL

	ImpLogo()
		
	oPrn:SayAlign( _nLin + (_nEspPad*1.5), 0005, "Sequência de Produção", oFont01, 0800-0005,0060,,2,0)
			
	oPrn:Box( _nLin, 0600, _nLin + (_nEspPad*1), 0700, "-4") //Código
	oPrn:Box( _nLin, 0700, _nLin + (_nEspPad*1), 0800, "-4")

	oPrn:SayAlign( _nLin, 0600, "Código"			, oFont03, 0700-0600,0060,,2,0)
	oPrn:SayAlign( _nLin, 0700, "PRO-RG-007"		, oFont03, 0800-0700,0060,,2,0)
	
	_nLin +=  _nEspPad
	
	oPrn:Box( _nLin, 0600, _nLin + (_nEspPad*1), 0700, "-4") //Data da revisão
	oPrn:Box( _nLin, 0700, _nLin + (_nEspPad*1), 0800, "-4")

	oPrn:SayAlign( _nLin, 0600, "Data da revisão"	, oFont03, 0700-0600,0060,,2,0)	
	oPrn:SayAlign( _nLin, 0700, "23/02/2016"		, oFont03, 0800-0700,0060,,2,0)
		
	_nLin +=  _nEspPad
	
	oPrn:Box( _nLin, 0600, _nLin + (_nEspPad*1), 0700, "-4") //Revisão
	oPrn:Box( _nLin, 0700, _nLin + (_nEspPad*1), 0800, "-4")
	
	oPrn:SayAlign( _nLin, 0600, "Revisão"			, oFont03, 0700-0600,0060,,2,0)
	oPrn:SayAlign( _nLin, 0700, "3"					, oFont03, 0800-0700,0060,,2,0)
	
	
	_nLin +=  _nEspPad
	
	oPrn:Box( _nLin, 0600, _nLin + (_nEspPad*1), 0700, "-4") //Emissão
	oPrn:Box( _nLin, 0700, _nLin + (_nEspPad*1), 0800, "-4")
	
	oPrn:SayAlign( _nLin, 0600, "Emissão"			, oFont03, 0700-0600,0060,,2,0)
	oPrn:SayAlign( _nLin, 0700, "13/08/2013"		, oFont03, 0800-0700,0060,,2,0)
	
	_nLin +=  _nEspPad
	
	oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*1), 0200, "-4") //Responsável
	oPrn:Box( _nLin, 0200, _nLin + (_nEspPad*1), 0800, "-4")
	
	oPrn:SayAlign( _nLin, 0005, "Responsável:", oFont02, 0200-0005,0060,,2,0)
	oPrn:SayAlign( _nLin, 0205, UsrRetName(__cUserId) , oFont02, 0800-0200,0060,,0,0)
	
	_nLin +=  _nEspPad
	
	oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*1), 0200, "-4") //Misturador
	oPrn:Box( _nLin, 0200, _nLin + (_nEspPad*1), 0800, "-4")
	oPrn:SayAlign( _nLin, 0005, "Misturador:", oFont02, 0200-0005,0060,,2,0)
	oPrn:SayAlign( _nLin, 0205, Posicione("SZ6",1,xFilial("SZ6")+_cCodSala,"Z6_DESCR") , oFont02, 0800-0200,0060,,0,0)
	
	_nLin +=  _nEspPad
	
	oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*1), 0200, "-4") //Data
	oPrn:Box( _nLin, 0200, _nLin + (_nEspPad*1), 0800, "-4")
	oPrn:SayAlign( _nLin, 0005, "Data:", oFont02, 0200-0005,0060,,2,0)
	oPrn:SayAlign( _nLin, 0205, DTOC(dDataBase) , oFont02, 0800-0200,0060,,0,0)
	
	_nLin +=  _nEspPad
	
	oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*4), 0100, "-4") //Checagem da linha, antes do uso
	oPrn:Box( _nLin, 0100, _nLin + (_nEspPad*4), 0400, "-4")
	oPrn:Box( _nLin, 0400, _nLin + (_nEspPad*4), 0560, "-4")
	oPrn:Box( _nLin, 0560, _nLin + (_nEspPad*4), 0800, "-4")
	oPrn:SayAlign( _nLin, 0005, "Checagem da linha, antes do uso"	, oFont02, 0100-0005,0060,,2,0)
	oPrn:SayAlign( _nLin, 0100, "Condições de higiene:"				, oFont02, 0400-0100,0060,,2,0)
	oPrn:SayAlign( _nLin + (_nEspPad*1), 0100, "(    ) Conforme"	, oFont04, 0400-0100,0060,,2,0)
	oPrn:SayAlign( _nLin + (_nEspPad*2), 0100, "(    ) Não Conforme", oFont04, 0400-0100,0060,,2,0)
	oPrn:SayAlign( _nLin, 0400, "Ausência de perigos no misturador:", oFont02, 0560-0400,0060,,2,0)
	oPrn:SayAlign( _nLin + (_nEspPad*2), 0400, "(    ) Conforme"	, oFont04, 0560-0400,0060,,2,0)
	oPrn:SayAlign( _nLin + (_nEspPad*3), 0400, "(    ) Não Conforme", oFont04, 0560-0400,0060,,2,0)
	oPrn:SayAlign( _nLin, 0560, "Linha liberada para uso:"			, oFont02, 0800-0560,0060,,2,0)
	oPrn:SayAlign( _nLin + (_nEspPad*1), 0560, "(    ) Sim"			, oFont04, 0800-0560,0060,,2,0)
	oPrn:SayAlign( _nLin + (_nEspPad*2), 0560, "(    ) Não"			, oFont04, 0800-0560,0060,,2,0)
	
	_nLin +=  (_nEspPad	* 4)
	
	oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*1), 0100, "-4") //Sequencia
	oPrn:SayAlign( _nLin, 0005, "Sequência", oFont02, 0100-0005,0060,,2,0)
	oPrn:Box( _nLin, 0100, _nLin + (_nEspPad*1), 0400, "-4") //Produto
	oPrn:SayAlign( _nLin, 0100, "Produto", oFont02, 0400-0100,0060,,2,0)
	oPrn:Box( _nLin, 0400, _nLin + (_nEspPad*1), 0480, "-4") //Número BI
	oPrn:SayAlign( _nLin, 0400, "Número BI", oFont02, 0480-0400,0060,,2,0)
	oPrn:Box( _nLin, 0480, _nLin + (_nEspPad*1), 0560, "-4") //Lote
	oPrn:SayAlign( _nLin, 0480, "Lote", oFont02, 0560-0480,0060,,2,0)
	oPrn:Box( _nLin, 0560, _nLin + (_nEspPad*1), 0650, "-4") //Quantidade
	oPrn:SayAlign( _nLin, 0560, "Quantidade", oFont02, 0650-0560,0060,,2,0)
	oPrn:Box( _nLin, 0650, _nLin + (_nEspPad*1), 0800, "-4") //Assinatura
	oPrn:SayAlign( _nLin, 0650, "Assinatura", oFont02, 0800-0650,0060,,2,0)
	
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
		oPrn:SayBitmap(050,010,cLogoD,0085,0050)
	Else
		oPrn:SayBitmap(050,010,cLogo ,0085,0050)
	EndIf

Return()

Static Function ImpItens()

	Local _nItem	:= 1	
	Local _nQuebLin := 1
	Local _nNumCar	:= 0
	Local _nPalavra	:= 0
			
	_nLin += _nEspPad
		
	For _nItem := 1 To Len(_aCols)
		
		oPrn:Box( _nLin, 0005, _nLin + (_nEspPad*1), 0100, "-4") //Sequencia
		oPrn:SayAlign( _nLin, 0005, AllTrim(Str(_nItem)), oFont05, 0100-0005,0060,,2,0)
		
		oPrn:Box( _nLin, 0100, _nLin + (_nEspPad*1), 0400, "-4") //Produto	
		oPrn:SayAlign( _nLin, 0100, AllTrim(_aCols[_nItem,aScan(_aHeader,{|x|Alltrim(x[2]) == "B1_DESCINT"})]), oFont05, 0400-0100,0060,,2,0)
		
		oPrn:Box( _nLin, 0400, _nLin + (_nEspPad*1), 0480, "-4") //Número BI
		
		_cNumOP := _aCols[_nItem,aScan(_aHeader,{|x|Alltrim(x[2]) == "C2_NUM"		})]
		_cNumOP += _aCols[_nItem,aScan(_aHeader,{|x|Alltrim(x[2]) == "C2_ITEM"		})]
		_cNumOP += _aCols[_nItem,aScan(_aHeader,{|x|Alltrim(x[2]) == "C2_SEQUEN"	})]
		_cNumOP += _aCols[_nItem,aScan(_aHeader,{|x|Alltrim(x[2]) == "C2_ITEMGRD"	})]
		
		oPrn:SayAlign( _nLin, 0400, _cNumOP, oFont05, 0480-0400,0060,,2,0)
		
		oPrn:Box( _nLin, 0480, _nLin + (_nEspPad*1), 0560, "-4") //Lote
		oPrn:SayAlign( _nLin, 0480, AllTrim(_aCols[_nItem,aScan(_aHeader,{|x|Alltrim(x[2]) == "C2_LOTECTL"})]), oFont05, 0560-0480,0060,,2,0)
		
		oPrn:Box( _nLin, 0560, _nLin + (_nEspPad*1), 0650, "-4") //Quantidade
		oPrn:SayAlign( _nLin, 0560, Transform((_aCols[_nItem,aScan(_aHeader,{|x|Alltrim(x[2]) == "C2_QUANT"})]),PesqPict("SC2","C2_QUANT")), oFont05, 0650-0560,0060,,2,0)
		
		oPrn:Box( _nLin, 0650, _nLin + (_nEspPad*1), 0800, "-4") //Assinatura
		oPrn:SayAlign( _nLin, 0650, "", oFont05, 0800-0650,0060,,2,0)
		
		_nLin += _nEspPad
		
		QuebraPag()
	Next
	
Return()

Static Function ImpRodape()
	
	oPrn:Box( _nLin, 0005, _nLin + _nEspPad, 0800, "-4")
	oPrn:SayAlign( _nLin+5 , 0005, " Verificação diária:", oFont02, 0800-0005,0060,,0,0)
	
Return()

Static Function QuebraPag()
	
	If _nLin >= _nLinFin
		oPrn:EndPage()
		oPrn:StartPage()
		
		_nLin := 0040
	EndIf
	
Return()