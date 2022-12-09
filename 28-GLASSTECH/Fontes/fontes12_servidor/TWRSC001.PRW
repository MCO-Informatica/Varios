#INCLUDE 'protheus.ch'
#INCLUDE 'totvs.ch'

Static nCol1 := 0010            
Static nCol2 := 0030            
Static nCol3 := 0050            
Static nCol4 := 0105            
Static nCol5 := 0180            
Static nCol6 := 0310            
Static nCol7 := 0350            
Static nCol8 := 0400

/*/{Protheus.doc} TWFUN02
//TODO Relatório de Movimentações Financeiras customizado.
@author Pirolo
@since 16/07/2020
@version undefined
@return return, return_description
/*/
User Function TWRSC001()
Local cFilePrint := "report"

//RpcSetType(3)
//RpcSetEnv("01", "0101")

//DbSelectArea("SC1")

If MsgYesNo("Gerar relatório em formato csv?")
	GeraCsv()
Else
	oPrint := FwMSPrinter():New(cFilePrint,6,.F.,,.F.,,,,,,,.T.)
	
	If Empty(oPrint:oFileWriter:oErroLog:Message)
		oPrint	:= GeraLinha(oPrint)
		oPrint:EndPage()
		oPrint:Preview()
	EndIf
	
	If Type("oPrint:nHandle") <> 'U'
		FClose(oPrint:nHandle)
	EndIf
	
	FreeObj(oPrint)
EndIf
Return

/*/{Protheus.doc} GeraLinha
//TODO Gera o relatório em FwMsPrinter.
@author Pirolo
@since 16/07/2020
@return return, return_description
/*/
Static Function GeraLinha(oPrint)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaração de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cLogo			:= FisxLogo("1")
Local cCodEmp		:= FWCodEmp()
Local cCodFil		:= FWCodFil()
Local nLin			:= 10
Local nLimPag		:= 700

Local cQry			:= ''

Local oFonte06		:= tFont():New("ARIAL",06,06,,.F.,,,,.T.,.F.)
Local oFonte06N		:= tFont():New("ARIAL",06,06,,.T.,,,,.T.,.F.)
Local oFonte08		:= tFont():New("ARIAL",08,08,,.F.,,,,.T.,.F.)
Local oFonte08N		:= tFont():New("ARIAL",08,08,,.T.,,,,.T.,.F.)
Local oFonte10		:= tFont():New("ARIAL",10,10,,.F.,,,,.T.,.F.)
Local oFonte10N		:= tFont():New("ARIAL",10,10,,.T.,,,,.T.,.F.)
Local oFonte11N		:= tFont():New("ARIAL",11,11,,.T.,,,,.T.,.F.)
Local oFonte12		:= tFont():New("ARIAL",12,12,,.F.,,,,.T.,.F.)
Local oFonte12N		:= tFont():New("ARIAL",12,12,,.T.,,,,.T.,.F.)
Local oFonte13N		:= tFont():New("ARIAL",13,13,,.T.,,,,.T.,.F.)
Local oFonte14		:= tFont():New("ARIAL",14,14,,.F.,,,,.T.,.F.)
Local oFonte14N		:= tFont():New("ARIAL",14,14,,.T.,,,,.T.,.F.)
Local oFonte16		:= tFont():New("ARIAL",16,16,,.F.,,,,.T.,.F.)
Local oFonte16N		:= tFont():New("ARIAL",16,16,,.T.,,,,.T.,.F.)
Local oFonte18		:= tFont():New("ARIAL",18,18,,.F.,,,,.T.,.F.)
Local oFonte18N		:= tFont():New("ARIAL",18,18,,.T.,,,,.T.,.F.)
Local oFonte20		:= tFont():New("ARIAL",20,20,,.F.,,,,.T.,.F.)
Local oFonte20N		:= tFont():New("ARIAL",20,20,,.T.,,,,.T.,.F.)
Local oFonte22		:= tFont():New("ARIAL",22,22,,.F.,,,,.T.,.F.)
Local oFonte22N		:= tFont():New("ARIAL",22,22,,.T.,,,,.T.,.F.)
Local oFonte24		:= tFont():New("ARIAL",24,24,,.F.,,,,.T.,.F.)
Local oFonte24N		:= tFont():New("ARIAL",24,24,,.T.,,,,.T.,.F.)
Local _oFonte06		:= tFont():New("Courier New",06,06,,.F.,,,,.T.,.F.)
Local _oFonte06N	:= tFont():New("Courier New",06,06,,.T.,,,,.T.,.F.)
Local _oFonte08		:= tFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
Local _oFonte08N	:= tFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)
Local _oFonte10		:= tFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
Local _oFonte10N	:= tFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
Local _oFonte12		:= tFont():New("Courier New",12,12,,.F.,,,,.T.,.F.)
Local _oFonte12N	:= tFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)
Local _oFonte14		:= tFont():New("Courier New",14,14,,.F.,,,,.T.,.F.)
Local _oFonte14N	:= tFont():New("Courier New",14,14,,.T.,,,,.T.,.F.)
Local _oFonte16		:= tFont():New("Courier New",16,16,,.F.,,,,.T.,.F.)
Local _oFonte16N	:= tFont():New("Courier New",16,16,,.T.,,,,.T.,.F.)

cQry := PegaQry()

DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQry),'QRY',.T.,.T.)
DbSelectArea('QRY')
DbGoTop()

While QRY->(!EOF())

	If nLin >= nLimPag .OR. nLin == 10//540
		If nLin > 10
			oPrint:EndPage()
		EndIf
		
		nLin := 0120 //nLinCab //Melhor aproveitamento da segunda pagina em diante
		oPrint:StartPage()
		oPrint:Say(0050,0210,OemToAnsi("Resumo - Solicitação de Compras"),	oFonte20N)

		oPrint:Say(0070,0120,OemToAnsi("Solicitante: "+QRY->C1_SOLICIT)  	,oFonte12N)
		oPrint:Say(0080,0120,OemToAnsi("Data Emissão:"+QRY->C1_EMISSAO)  	,oFonte12N)
		oPrint:Say(0070,0300,OemToAnsi("Grupo: "+QRY->C1_GRPPROD)  			,oFonte12N)
		oPrint:Say(0080,0300,OemToAnsi("Comprador:"+QRY->C1_CODCOMP)  		,oFonte12N)
		
		C1_GRUPCOM
		oPrint:SayBitmap(0000,0010,cLogo)
		oPrint:Line(nLin+1,0010,nLin+1,0780)
		
		oPrint:Say(nLin, nCol1, OemToAnsi("Filial"		),oFonte08)            
		oPrint:Say(nLin, nCol2, OemToAnsi("Item"			),oFonte08)            
		oPrint:Say(nLin, nCol3, OemToAnsi("Numero SC"	),oFonte08)            
		oPrint:Say(nLin, nCol4, OemToAnsi("Produto"		),oFonte08)            
		oPrint:Say(nLin, nCol5, OemToAnsi("Descrição"	),oFonte08)            
		oPrint:Say(nLin, nCol6, OemToAnsi("UM"			),oFonte08)            
		oPrint:Say(nLin, nCol7, OemToAnsi("Quant."		),oFonte08)            
		oPrint:Say(nLin, nCol8, OemToAnsi("Observação"	),oFonte08)            

		nLin += 10
	EndIf

	//Detalhe
	oPrint:Say(nLin, nCol1, OemToAnsi(Alltrim(QRY->C1_FILIAL   				)),oFonte08)
	oPrint:Say(nLin, nCol2, OemToAnsi(Alltrim(QRY->C1_ITEM   				)),oFonte08)
	oPrint:Say(nLin, nCol3, OemToAnsi(Alltrim(QRY->C1_NUM   				)),oFonte08)
	oPrint:Say(nLin, nCol4, OemToAnsi(Alltrim(QRY->C1_PRODUTO  				)),oFonte08)
	oPrint:Say(nLin, nCol5, OemToAnsi(Alltrim(QRY->C1_DESCRI     			)),oFonte08)
	oPrint:Say(nLin, nCol6, OemToAnsi(Alltrim(QRY->C1_UM   					)),oFonte08)
	oPrint:Say(       nLin, nCol7, OemToAnsi(Transform(QRY->C1_QUANT, "@E 999,999.99"))  	,oFonte08)
	
	oPrint:Say(nLin, nCol8, OemToAnsi(Alltrim(Substr(QRY->C1_OBS, 1,36)   	)),oFonte06)

	nLin += 10
	QRY->(DbSkip())
EndDo

Return oPrint

/*/{Protheus.doc} PegaQry
//TODO Função para centralizar a query em um mesmo local.
@author Pirolo
@since 16/07/2020
@return return, Query para seleção das movimentações financeiras
/*/
Static Function PegaQry()
Local cQry := ""
Local aPergs	:= {}
Local dDataDe	:= FirstDate(Date())
Local dDataAt	:= LastDate(Date())
 
cQry := "SELECT C1_FILIAL , C1_NUM   , C1_ITEM,   "+CRLF
cQry += "       C1_PRODUTO, C1_DESCRI, C1_UM  ,   "+CRLF
cQry += "       C1_QUANT  , C1_OBS   , C1_SOLICIT,"+CRLF
cQry += "Substring(C1_EMISSAO,7, 2)+'/'+substring(C1_EMISSAO,5, 2)+'/'+substring(C1_EMISSAO,1, 4) C1_EMISSAO, "+CRLF
cQry += "       C1_GRPPROD, C1_CODCOMP            "+CRLF
cQry += "FROM "+RetSqlName("SC1")+"               "+CRLF
cQry += "WHERE D_E_L_E_T_ = ' '                   "+CRLF
cQry += "AND   C1_FILIAL  = '"+SC1->C1_FILIAL+"'  "+CRLF
cQry += "AND   C1_NUM     = '"+SC1->C1_NUM+"'     "+CRLF
cQry += "AND   D_E_L_E_T_ = ' '                   "

Return cQry

/*/{Protheus.doc} GeraCsv
//TODO Função que gera o relatório em formato CSV.
@author Pirolo
@since 16/07/2020
@return return, return_description
@example
(examples)
@see (https://tdn.totvs.com/display/framework/FWFileWriter), (https://centraldeatendimento.totvs.com/hc/pt-br/articles/360020133472-MP-ADVPL-FWFileWriter-como-gravar-no-arquivo)
/*/
Static Function GeraCsv()
Local oFile := FWFILEWRITER():new("C:\Temp\SC"+SC1->(C1_FILIAL+C1_NUM)+".csv")
Local cQry	:= PegaQry()

//Verifica se o arquivo existe
If oFile:Exists()
	oFile:Erase()
EndIf
 
//Cria o arquivo
If (oFile:Create())
	If Select("QRY")>0
		QRY->(dbCloseArea())
	EndIf
	//Executa a query
	DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQry),'QRY',.T.,.T.)
	
	//Grava o cabeçalho do CSV
	oFile:Write("Filial;Item;Numero SC;Produto;Descrição;UM;Quant.;Observação"+CRLF)
	
	//Percorre a query, gravando as linhas
	While QRY->(!EOF())
		oFile:Write(Alltrim(QRY->C1_FILIAL)                     +";"+;
					Alltrim(QRY->C1_ITEM)                       +";"+;
					Alltrim(QRY->C1_NUM)                        +";"+;
					Alltrim(QRY->C1_PRODUTO)                    +";"+;
					Alltrim(QRY->C1_DESCRI)                     +";"+;
					Alltrim(QRY->C1_UM)                         +";"+;
					Transform(QRY->C1_QUANT, "@E 999,999.99")  +";"+;
					Alltrim(Substr(QRY->C1_OBS, 1,36))          +";"+CRLF)
		
		QRY->(DbSkip())
	EndDo
	
	//Fecha o arquivo
	oFile:Close()
	FreeObj(oFile)
Endif
 
Return
