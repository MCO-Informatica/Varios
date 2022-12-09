#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#Include "AP5Mail.ch"

#DEFINE VBOX      080
#DEFINE VSPACE    100                                  	
#DEFINE HSPACE    010
#DEFINE SAYVSPACE 008
#DEFINE SAYHSPACE 008
#DEFINE HMARGEM   100
#DEFINE HMARGEMT  040
#DEFINE VMARGEM   100
#DEFINE VMARGEMT  040


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT101   บAutor  ณ Luiz Alberto       บ Data ณ  04/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MetaLacre - Protheus 11                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFAT101()

Local cQuery := ""
Local cAliasSCK := CriaTrab(NIL,.F.)
Local nPag		:= 1

Private nTotalGeral := 0
Private lIpi:=.F.  
Private nIpi:= 0 
Private nVlrIpi:= 0  
Private nTotal:= 0

Private nPosV       := VMARGEM                      
Private ncw     	:= 0
Private li      	:= 5000
Private nLinMax	:= 3280  // N๚mero mแximo de Linhas  A4 - 2250 // Oficio - 2800
Private nColMax	:= 2300  // N๚mero mแximo de Colunas A4 - 3310 // Oficio - 3955
Private oPrint

Private oFont10
Private oFont10n
Private oFont12
Private oFont12n
Private oFont14
Private oFont14n                      
Private oFont16n
Private oFont18n
Private oFont20n
Private	oFnt13a
Private	oFnt35a

Private cLogo:=GetSrvProfString("Startpath","")+"logo_metalacre.gif" //verificar

AjustaSX1("RFAT101")
If !Pergunte("RFAT101", .T. )
	Return .t.
Endif


oPrint  	:= TMSPrinter():New("Or็amento")
oPrint		:Setup()	// Escolhe a impressora
oPrint		:SetPortrait()
oPrint  	:SetPaperSize(9)   // 9=Papel A4 210x297 mm
	
oFont08n   	:= TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.) 
oFont10n   	:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)    
oFont10  	:= TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont12n   	:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12  	:= TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n   	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.) 
oFont14  	:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.) 
oFont16n   	:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont18n   	:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20n   	:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)                                
oFnt13a		:= TFont():New( "Arial",,13,,.t.,,,,,.f.,.t. )      && Tam 13   italico
oFnt35a		:= TFont():New( "Arial Black",,35,,.t.,,,,,.f. )	&& Tam 35 - Titulo
	
	// query que efetua a contagem de registros a serem processados
cQuery := "	SELECT  "
cQuery += "	C5_NUM,  "
cQuery += "	C5_TRANSP,  "
cQuery += "	C5_CLIENTE,  "
cQuery += "	C5_LOJACLI, "
cQuery += "	A1_COD, "
cQuery += "	A1_LOJA, "
cQuery += "	A1_NOME, "
cQuery += "	ISNULL(A4_NOME,'') A4_NOME, "
cQuery += "	C6_PRODUTO, "
cQuery += "	C6_DESCRI, "
cQuery += "	C6_ENTREG, "
cQuery += "	C6_NUMOP, "
cQuery += "	C6_ITEMOP, "
cQuery += "	C6_NUM, "
cQuery += "	C6_ITEM, "
cQuery += "	C6_XINIC, "
cQuery += "	C6_XFIM, "
cQuery += "	SUM(C6_XVOLITE) CAIXAS, "
cQuery += "	SUM(C6_QTDVEN-C6_QTDENT) QTDE, "
cQuery += "	ENTREGA = "
cQuery += "	CASE "
cQuery += "	WHEN A4_XENDENT <> '' AND C5_TRANSP <> '001000' AND C5_TRANSP <> '' THEN RTRIM(ISNULL(A4_XENDENT,'')) + ' ' + RTRIM(ISNULL(A4_XBAIREN,'')) + ' ' + RTRIM(ISNULL(A4_XMUNENT,'')) + ' ' + RTRIM(ISNULL(A4_XESTENT,'')) "
//cQuery += "	--WHEN A4_XENDENT =  '' THEN RTRIM(ISNULL(A4_END,'')) + ' ' + RTRIM(ISNULL(A4_BAIRRO,'')) + ' ' + RTRIM(ISNULL(A4_MUN,'')) + ' ' + RTRIM(ISNULL(A4_EST,'')) "
cQuery += "	ELSE "
cQuery += "		RTRIM(ISNULL(A1_END,'')) + ' ' + RTRIM(ISNULL(A1_BAIRRO,'')) + ' ' + RTRIM(ISNULL(A1_MUN,'')) + ' ' + RTRIM(ISNULL(A1_EST,'')) "
cQuery += "	END, "
cQuery += "	ISNULL(A4_XHRENT,'') HORARIO "
cQuery += " FROM " + RetSqlName("SC5") + " C5 "
cQuery += " INNER JOIN " + RetSqlName("SC6") + " C6 "
cQuery += " ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.D_E_L_E_T_ = '' AND C6_ENTREG BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "  
cQuery += " INNER JOIN " + RetSqlName("SC9") + " C9 "
cQuery += " ON C9_FILIAL = C5_FILIAL AND C9_PEDIDO = C6_NUM AND C9_ITEM = C6_ITEM AND C9.D_E_L_E_T_ = '' AND C9_BLEST = '' AND C9_NFISCAL = '' "
cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1 "
cQuery += " ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN " + RetSqlName("SA4") + " A4 "
cQuery += " ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ = '' "
cQuery += " WHERE C5.D_E_L_E_T_ = '' "
cQuery += " GROUP BY C5_NUM, C5_TRANSP, C5_CLIENTE, C5_LOJACLI, A1_COD, A1_LOJA, A1_NOME, A4_NOME, C6_PRODUTO, C6_DESCRI, C6_ENTREG, C6_NUMOP, C6_ITEMOP, C6_NUM, C6_ITEM, C6_XINIC, C6_XFIM, A4_XENDENT, A4_XBAIREN, A4_XMUNENT, A4_XESTENT, A4_END, A4_BAIRRO, A4_MUN, A4_EST, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A4_XHRENT "
cQuery += " HAVING SUM(C6_QTDVEN-C6_QTDENT) > 0 "
cQuery += " ORDER BY C5_NUM, C5_TRANSP, C5_CLIENTE, C5_LOJACLI, A1_COD, A1_LOJA, A1_NOME, A4_NOME, C6_PRODUTO, C6_DESCRI, C6_ENTREG, C6_NUMOP, C6_ITEMOP, C6_NUM, C6_ITEM, C6_XINIC, C6_XFIM, A4_XENDENT, A4_XBAIREN, A4_XMUNENT, A4_XESTENT, A4_END, A4_BAIRRO, A4_MUN, A4_EST, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A4_XHRENT "
cQuery := ChangeQuery(cQuery)		
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TMP',.T.,.F.)

TcSetField('TMP','C6_ENTREG','D')

nPagAtu:= 1                                   

nTotCx := nTotMt := 0.00
cPed := TMP->C6_NUM

While TMP->(!Eof()) 
	If Li >= 3000	
		//Impressใo do Cabe็alho
		R101CABEC(nPagAtu)
		nPagAtu++   
	Endif
	
	//Impressao dos Itens
	R101ITENS(@Li)
		
	nTotCx += TMP->CAIXAS
	nTotMt += TMP->QTDE

	
	nCaixas := 0.00
	If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+TMP->C6_NUM))
		While SC6->(!Eof()) .And. SC6->C6_NUM == TMP->C6_NUM
			If !(SC6->C6_ENTREG >= MV_PAR01 .And. SC6->C6_ENTREG <= MV_PAR02)
				SC6->(dbSkip(1));Loop
			Endif
			If SC9->(dbSetOrder(1), dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
				If !(Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_NFISCAL))
					SC6->(dbSkip(1));Loop
				Endif
			Endif
			
			// Calculo Caixas


			// Posiciona Registro do Conteudo da Embalagem
			If !Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+SC6->C6_XEMBALA))
				SC6->(dbSkip(1));Loop
			Endif
			// Posiciona Registro do Tipo da Embalagem
			If !Z05->(dbSetOrder(1), dbSeek(xFilial("Z05")+Z06->Z06_EMBALA))
				SC6->(dbSkip(1));Loop
			Endif                                     
		
			&&Quantidade de Caixas/Item    &&Oscar
			nxCaixa	:= SC9->C9_QTDLIB/Z06->Z06_QTDMAX
			nInt  := Int(nxCaixa)
			nFrac := (nxCaixa - nInt)
			If !Empty(nFrac)
			    nInt++
			Endif
			nxCaixa := nInt
			nxCaixa := Iif(Empty(nxCaixa),1,nxCaixa)

			// Tratamento de Calculo de Caixas Para Entregas Parciais de Pedidos

			nCaixas += nxCaixa //SC6->C6_XVOLITE
			
			SC6->(dbSkip(1))
		Enddo
	Endif
	
	//Impressao do rodape
	
	TMP->(DbSkip())                           
	
	Li+=60
	
	If cPed <> TMP->C6_NUM
		oPrint:Say (Li-20,0850,'Total Caixas Pedido: (' + cPed + ') ' + Str(nCaixas),oFont12n,,,,0)   // tOTAL CAIXAS DO PEDIDO
		cPed := TMP->C6_NUM

		Li+=40
		oPrint:Box(Li,HMARGEM,Li,nColMax)
		Li+=60
	Endif
	
	If Li >= 3000
		R101RODA ()	
	Endif
EndDo                  

If !Empty(nTotCx)
	oPrint:Say(3220,1100,"Qt.Caixas: " + Str(nTotCx),oFont12n,,,,0)   
	oPrint:Say(3220,1700,"Qt.Materiais: " + Str(nTotMt),oFont12n,,,,0)   
Endif

TMP->(dbCloseArea())
oPrint:EndPage()     // Finaliza a pแgina
oPrint:Preview()     // Visualiza antes de imprimir
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT100   บAutor  ณMicrosiga           บ Data ณ  12/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function R101CABEC(nPag)
oPrint      :StartPage() // Inicia Nova pแgina
Li:=VSPACE
oPrint:Box(VMARGEM,HMARGEM,nLinMax,nColMax)

// Cabe็alho / Dados da Empresa

oPrint:Box(li,HMARGEM,500,900)
oPrint:Box(li,HMARGEM,500,nColMax)

Li:=li+50
oPrint:SayBitmap(li,HMARGEM+50,cLogo,750,220)	

oPrint:Box(500,100 ,650,300 ) // NF
oPrint:Box(500,300 ,650,1000) // Cliente / Empresa
oPrint:Box(500,1000,650,2000) // Endere็o de Entrega
oPrint:Box(500,2000,650,2300) // Qt.Caixas      

oPrint:Say(050,2090,"Pแgina: " + StrZero(nPag,3),oFont12,,,,0)   
oPrint:Say(300,1060,"CONTROLE DE ENTREGA DE MERCADORIAS",oFont12n,,,,0)   

oPrint:Say(510,110,"N.Fiscal",oFont12n,,,,0)   
oPrint:Say(560,115,"Data",oFont12n,,,,0)   

oPrint:Say(510,350,"Cliente / Empresa",oFont12n,,,,0)   
oPrint:Say(560,330,"Horario de Recebimento",oFont12n,,,,0)   

oPrint:Say(510,1100,"Ender. Entrega / Horแrio de Recebimento",oFont12n,,,,0)   

oPrint:Say(510,2050,"Qt.Caixas",oFont12n,,,,0)   
oPrint:Say(560,2050,"Qt.Mater.",oFont12n,,,,0)   

Li := 700

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT100   บAutor  ณMicrosiga           บ Data ณ  12/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function R101ITENS (nLin)

nxCaixa := 0
//Dados dos Itens (SCK)
//oPrint:Box(1150,HMARGEM,1680,nColMax)
//oPrint:Box(1150,nColMax-(nColMax/4),1680,nColMax)  

oPrint:Say (nLin   ,115,DtoC(TMP->C6_ENTREG),oFont10,,,,0)   
oPrint:Say (nLin   ,350,Capital(TMP->A1_NOME),oFont10,,,,0)   

                      
// Conforme Solicitacoa
// Efetua a soma de todas as caixas (Volumes) dos itens do pedido impresso


nCaixas := TMP->CAIXAS
If SC6->(dbSetOrder(2), dbSeek(xFilial("SC6")+TMP->C6_PRODUTO+TMP->C6_NUM+TMP->C6_ITEM))
	If SC9->(dbSetOrder(1), dbSeek(xFilial("SC9")+TMP->C6_NUM+TMP->C6_ITEM))
		// Calculo Caixas
		// Posiciona Registro do Conteudo da Embalagem
		Z06->(dbSetOrder(1), dbSeek(xFilial("Z06")+SC6->C6_XEMBALA))
		Z05->(dbSetOrder(1), dbSeek(xFilial("Z05")+Z06->Z06_EMBALA))
		
		&&Quantidade de Caixas/Item    &&Oscar
		nxCaixa	:= SC9->C9_QTDLIB/Z06->Z06_QTDMAX
		nInt  := Int(nxCaixa)
		nFrac := (nxCaixa - nInt)
		If !Empty(nFrac)
		    nInt++
		Endif
		nxCaixa := nInt
		nxCaixa := Iif(Empty(nxCaixa),1,nxCaixa)
					
	
		// Tratamento de Calculo de Caixas Para Entregas Parciais de Pedidos
	
		nCaixas += nxCaixa //SC6->C6_XVOLITE
	Else
		nCaixas := TMP->CAIXA
	Endif
Endif
			
oPrint:Say (nLin+60,2000,Str(nxCaixa),oFont12n,,,,0)   
	
oPrint:Say (nLin+60,330 ,TMP->HORARIO,oFont12,,,,0)   
oPrint:Say (nLin+60,1100,TMP->HORARIO,oFont12,,,,0)   

// Descricao do Produto, quebrado em 25 caractares

xLin := nLin+120
nLinhas := MLCOUNT(Capital(TMP->C6_DESCRI),25)
For _nY := 1 to nLinhas
	oPrint:Say (xLin   ,350,memoline(Capital(TMP->C6_DESCRI), 25, _nY),oFont10,,,,0)   
		
	
	// Numero do Pedido de Venda
	If _nY == nLinhas                                                                  
		oPrint:Say (xLin   ,850,TMP->C5_NUM,oFont12n,,,,0)   
		oPrint:Say (xLin   ,1100,'Transp: '+TMP->A4_NOME,oFont10,,,,0)   
		oPrint:Say (xLin   ,2000,Str(TMP->QTDE),oFont12n,,,,0)   

	Endif	
	xLin+=60
Next
oPrint:Say (xLin   ,0420,'Lacre Ini: ' + AllTrim(Str(TMP->C6_XINIC)) + ' Final: ' + AllTrim(Str(TMP->C6_XFIM)),oFont10,,,,0)   
                                            
// Impressใo do Endere็o de Entrega quebrado por 50 caracateres

nLinhas := MLCOUNT(Capital(TMP->ENTREGA),50)
For _nY := 1 to nLinhas
	oPrint:Say (nLin   ,1100,memoline(Capital(TMP->ENTREGA), 50, _nY),oFont10,,,,0)   
		
	nLin+=60
Next

nLin+=180
oPrint:Say (nLin   ,115,'OP: ' + TMP->C6_NUMOP+'/'+TMP->C6_ITEMOP,oFont12,,,,0)   

nLin+=40
oPrint:Box(nLin,HMARGEM,nLin,nColMax)
nLin+=40

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT100   บAutor  ณMicrosiga           บ Data ณ  12/17/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function R101RODA (nReg,lSub)                                       

//Observa็๕es Gerais
/*oPrint:Box(1680,HMARGEM,2070,nColMax)
oPrint:Box(1680,HMARGEM,1682,nColMax)
oPrint:Say (1710,HMARGEM+50,"Observa็๕es Gerais:",oFont12,,,,0)       // verificar

oPrint:Say (1780,HMARGEM+50,Substr(SCJ->CJ_XOBS,1,110),oFont12,,,,0)  
oPrint:Say (1850,HMARGEM+50,Substr(SCJ->CJ_XOBS,111,110),oFont12,,,,0)  
oPrint:Say (1920,HMARGEM+50,Substr(SCJ->CJ_XOBS,221,110),oFont12,,,,0)  

//Rodap้
oPrint:Box(2070,HMARGEM,nLinMax,nColMax)
oPrint:Box(2070,nColMax-(nColMax/4),nLinMax,nColMax)

oPrint:Say (1990,nColMax-((nColMax/4)/2),"Base de Calculo do Icms Sobre o Valor Total da NF",oFont10n,,,,2)  

oPrint:Say (2100,HMARGEM+50,"Em caso de confirma็ใo, favor retornar assinado ou",oFont12n,,,,0)  
oPrint:Say (2140,HMARGEM+50,"replicar o e-mail com 'or็amento aprovado'.",oFont12n,,,,0)         

oPrint:Say (2180,nColMax/2+(nColMax/8),"___________________________________",oFont10n,,,,2)  
oPrint:Say (2220,nColMax/2+(nColMax/8),"Carimbo e Assinatura",oFont10n,,,,2)  


oPrint:Say (2130,nColMax-(nColMax/4)+50,IIF(lSub,"Valor Total","Sub-Total"),oFont16n,,,,0)  
oPrint:Say (2130,nColMax-HMARGEM-50,Alltrim(Transform(nTotalGeral, PesqPict("SCK","CK_VALOR"))),oFont16n,,,,2)  

oPrint:Say (2280,nColMax-HMARGEM-150,DTOC(DDATABASE) + " - " + TIME(),oFont10n,,,,2)
  */
Ms_Flush()
oPrint:EndPage()     // Finaliza a pแgina

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณMicrosiga           บ Data ณ  12/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MetaLacre - Protheus 11                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function AjustaSX1(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )

PutSx1(	cPerg, "01", "Data Entrega de  ? ", "" , "","Mv_ch1","D"                     ,TAMSX3("C6_ENTREG")[1]  ,                       0 , 0,"G","",   ""   ,"","","Mv_par01","","","","","","","","","","","","","","","","",{"",""},{""},{""},"")
PutSx1(	cPerg, "02", "Data Entrega Ate ? ", "" , "","Mv_ch2","D"                     ,TAMSX3("C6_ENTREG")[1]  ,                       0 , 0,"G","",   ""   ,"","","Mv_par02","","","","","","","","","","","","","","","","",{"",""},{""},{""},"")
PutSx1(	cPerg, "03", "Pedido de  ?       ", "" , "","Mv_ch3","C"                     ,TAMSX3("C5_NUM")[1]  ,                          0 , 0,"G","",   "SC5","","","Mv_par03","","","","","","","","","","","","","","","","",{"",""},{""},{""},"")
PutSx1(	cPerg, "04", "Pedido Ate ?       ", "" , "","Mv_ch4","C"                     ,TAMSX3("C5_NUM")[1]  ,                          0 , 0,"G","",   "SC5","","","Mv_par04","","","","","","","","","","","","","","","","",{"",""},{""},{""},"")
PutSx1(	cPerg, "05", "Municipio de  ?    ", "" , "","Mv_ch5","C"                     ,TAMSX3("A4_MUN")[1]  ,                          0 , 0,"G","",   ""   ,"","","Mv_par05","","","","","","","","","","","","","","","","",{"",""},{""},{""},"")
PutSx1(	cPerg, "06", "Municipio Ate ?    ", "" , "","Mv_ch6","C"                     ,TAMSX3("A4_MUN")[1]  ,                          0 , 0,"G","",   ""   ,"","","Mv_par06","","","","","","","","","","","","","","","","",{"",""},{""},{""},"")

RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return() 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณMyGetEnd  ณ Autor ณ Liber De Esteban             ณ Data ณ 19/03/09 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica se o participante e do DF, ou se tem um tipo de endereco ณฑฑ
ฑฑณ          ณ que nao se enquadra na regra padrao de preenchimento de endereco  ณฑฑ
ฑฑณ          ณ por exemplo: Enderecos de Area Rural (essa verific็ใo e feita     ณฑฑ
ฑฑณ          ณ atraves do campo ENDNOT).                                         ณฑฑ
ฑฑณ          ณ Caso seja do DF, ou ENDNOT = 'S', somente ira retornar o campo    ณฑฑ
ฑฑณ          ณ Endereco (sem numero ou complemento). Caso contrario ira retornar ณฑฑ
ฑฑณ          ณ o padrao do FisGetEnd                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Obs.     ณ Esta funcao so pode ser usada quando ha um posicionamento de      ณฑฑ
ฑฑณ          ณ registro, pois serแ verificado o ENDNOT do registro corrente      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ SIGAFIS                                                           ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function MyGetEnd(cEndereco,cAlias)

Local cCmpEndN	:= SubStr(cAlias,2,2)+"_ENDNOT"
Local cCmpEst	:= SubStr(cAlias,2,2)+"_EST"
Local aRet		:= {"",0,"",""}

//Campo ENDNOT indica que endereco participante mao esta no formato <logradouro>, <numero> <complemento>
//Se tiver com 'S' somente o campo de logradouro sera atualizado (numero sera SN)
If (&(cAlias+"->"+cCmpEst) == "DF") .Or. ((cAlias)->(FieldPos(cCmpEndN)) > 0 .And. &(cAlias+"->"+cCmpEndN) == "1")
	aRet[1] := cEndereco
	aRet[3] := "SN"
Else
	aRet := FisGetEnd(cEndereco)
EndIf
Return aRet

