#Include 'Protheus.ch' //Informa a biblioteca

User Function ESTTR01() //U_exemplo1()
Local aaCampos  	:= {"vItem","Codigo","Descricao","UnMedida","ArmzOr","EndOr","CodDes","DescrDes","UnMDes","LDESTINO","EndDes","NumSer","LOri","SLOr","DtVal","Potencia","Potencia","Quant","Quant2","SegQtd","Estorno","NumSeq","LoteDes","SubLDes","ValDes","Status"} //Variável contendo o campo editável no Grid
Local aBotoes	:= {}
Local nOpcaN1 := 0       //Variável onde será incluido o botão para a legenda
Private oLista                    //Declarando o objeto do browser
Private aCabecalho  := {}         //Variavel que montará o aHeader do grid

//Declarando os objetos de cores para usar na coluna de status do grid
Private oVerde  	:= LoadBitmap( GetResources(), "BR_VERDE")
Private oAzul  		:= LoadBitmap( GetResources(), "BR_AZUL")
Private oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO")
Private oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO")

Public aColsEx 	:= {}         //Variável que receberá os dados

DEFINE MSDIALOG oDlg TITLE "REDISTRIBUIÇÃO DE PRODUTOS - IMCD PHARMA" FROM 000, 000  TO 300, 700  PIXEL
//chamar a função que cria a estrutura do aHeader
CriaCabec()

//Monta o browser com inclusão, remoção e atualização
oLista := MsNewGetDados():New( 053, 078, 415, 775, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx)

//Carregar os itens que irão compor o conteudo do grid
Carregar()

//Alinho o grid para ocupar todo o meu formulário
oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

//Ao abrir a janela o cursor está posicionado no meu objeto
oLista:oBrowse:SetFocus()

//Crio o menu que irá aparece no botão Ações relacionadas
aadd(aBotoes,{"NG_ICO_LEGENDA", {||Legenda()},"Legenda","Legenda"})


//		DEFINE SBUTTON FROM 22,02 TYPE 1 ACTION (nOpcaN1 := 2, oDlg:End()) ENABLE OF oDlg
//		DEFINE SBUTTON FROM 22,28 TYPE 2 ACTION (nOpcaN2 := 3, oDlg:End()) ENABLE OF oDlg

EnchoiceBar(oDlg,{|| nOpcaN1 := 1, oDlg:End() }, {|| nOpcaN1 := 2, oDlg:End() }, , {{"BMPINCLUIR",{|| APMsgInfo("Teste")},"Teste"}})


ACTIVATE MSDIALOG oDlg CENTERED

If nOpcaN1 = 1
	xDoc := u_MyMata261()
	lContinua := MsgYesNo("ETIQUETAS, Deseja Imprimir Etiquetas ?")
	If lContinua                                 
	
		U_ETAIFF01(xDoc)
		ALERT("ETIQUETAS IMPRESSAS COM SUCESSO.")
	eLSE
		ALERT("OPERAÇÃO CANCELADA.")
	Endif
			
	
	RETURN()
ElseIf nOpcaN1 = 2
	ALERT("OPERAÇÃO CANCELADA.")
	Return()
Endif



Return



Static Function Carregar()
Local aProdutos := {}
Local rQtd:= 0
Local z := 0
Dbselectarea("SB1")
SB1->( dbSetOrder( 1 ) )
SB1->( DbSeek(xFilial("SB1")+PadR(SDA->DA_PRODUTO, tamsx3('D3_COD') [1])))

Dbselectarea("SBF")
SBF->( dbSetOrder( 2 ) )
SBF->( DbSeek (xFilial("SBF") + PadR(SDA->DA_PRODUTO, tamsx3('D3_COD')[1]) + PadR("10", tamsx3('BF_LOCAL')[1]) + PadR(SDA->DA_LOTECTL, tamsx3('BF_LOTECTL')[1]) ))

Dbselectarea("SB8")
SB8->( dbSetOrder( 3 ) )
SB8->( DbSeek(xFilial("SBF") + PadR(SDA->DA_PRODUTO, tamsx3('D3_COD')[1]) + PadR("10", tamsx3('BF_LOCAL')[1]) + PadR(SDA->DA_LOTECTL, tamsx3('BF_LOTECTL')[1]) ))

If SDA->DA_SALDO <> 0
	Alert("Para utilizar a redistribuição de saldo o produto deve estar endereçado. Favor Endereçar!")
	Return()
Endif

Dbselectarea("SBF")
SBF->( dbSetOrder( 2 ) )
If !DbSeek (xFilial("SBF") + PadR(SDA->DA_PRODUTO, tamsx3('D3_COD')[1]) + PadR("10", tamsx3('BF_LOCAL')[1]) + PadR(SDA->DA_LOTECTL, tamsx3('BF_LOTECTL')[1]) )
	Alert("Não existe saldo a redistribuir para o produto selecionado!")
	Return()
Endif

nTamLote := tamsx3('BF_LOTECTL')[1]



rQtd:= u_bTela(SB1->B1_COD)                  

xFator := 1

if SB1->B1_PESBRU > 0 .and. SB1->B1_PESO > 0
	xFator := (SB1->B1_PESBRU / SB1->B1_PESO) 
Endif

For z := 1 to rQtd // rQtdTtotvs
//	cChave := ALLTRIM(SDA->DA_DOC) + ALLTRIM(SDA->DA_SERIE)
//	nTam := nTamLote - LEN(cChave)
//	vLote := cChave + cValToChar(STRZERO(z,nTam))
	vslote := vLote := NextLote(SBF->BF_PRODUTO,"S")
	
	aadd(aProdutos,{oVerde,StrZero(z,4),SBF->BF_PRODUTO,SBF->BF_DESCRI,SB1->B1_UM,SBF->BF_LOCAL,SBF->BF_LOCALIZ,SBF->BF_PRODUTO,SBF->BF_DESCRI,SB1->B1_UM,"10","REDISTRIBUIR     ","   ",SBF->BF_LOTECTL,;
	SBF->BF_NUMLOTE, SB8->B8_DTVALID, Transform(0, "@E 999,999.99" ), Transform(((SDA->DA_QTDORI-SDA->DA_SALDO)/rQtd), "@E 999999.99" ), Transform((((SDA->DA_QTDORI-SDA->DA_SALDO)/rQtd)*xFator), "@E 999999.99" ) , Transform(0, "@E 999,999.99" ), " ", " ", vLote, vslote, SB8->B8_DTVALID, .F.})
Next

aColsEx := aProdutos

//Setar array do aCols do Objeto.
oLista:SetArray(aColsEx,.F.)

//Atualizo as informações no grid
oLista:Refresh()

aColsEx := aProdutos

Return(aColsEx)


//cria legenda
Static function Legenda()
Local aLegenda := {}
AADD(aLegenda,{"BR_VERDE"    	,"Produto Ativo" })

BrwLegenda("Legenda", "Legenda", aLegenda)
Return Nil


//cria cabeçalho luiz
Static Function CriaCabec()
Aadd(aCabecalho, {;
"",;//X3Titulo()
"IMAGEM",;  //X3_CAMPO
"@BMP",;		//X3_PICTURE
4,;			//X3_TAMANHO
0,;			//X3_DECIMAL
".F.",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",; 			//X3_F3
"V",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
"",;			//X3_WHEN
"V"})			//
Aadd(aCabecalho, {;
"Item",;//X3Titulo()
"vItem",;  //X3_CAMPO
"@!",;		//X3_PICTURE
5,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",; 			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN
Aadd(aCabecalho, {;
"Codigo",;//X3Titulo()
"Codigo",;  //X3_CAMPO
"@!",;		//X3_PICTURE
15,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"SB1",; 			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN
Aadd(aCabecalho, {;
"Descricao",;	//X3Titulo()
"Descricao",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
60,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;		//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN
Aadd(aCabecalho, {;
"Un.Medida",;	//X3Titulo()
"UnMedida",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
2,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Armz. Origem",;	//X3Titulo()
"ArmzOr",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
2,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"End.Origem",;	//X3Titulo()
"EndOr",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
15,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Codigo Destino",;	//X3Titulo()
"CodDes",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
15,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Descr. Destino",;	//X3Titulo()
"DescrDes",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
60,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Un.Med.Destino",;	//X3Titulo()
"UnMDes",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
2,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Local Destino",;	//X3Titulo()
"LDESTINO",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
2,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"NNR",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"End Destino",;	//X3Titulo()
"EndDes",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
18,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"SBE",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Num.Serie",;	//X3Titulo()
"NumSer",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
20,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Lote Origem",;	//X3Titulo()
"LOri",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
18,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"S-Lote Origem",;	//X3Titulo()
"SLOr",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
6,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Dt Validade",;	//X3Titulo()
"DtVal",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
8,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"D",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Potencia",;	//X3Titulo()
"Potencia",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
17,;			//X3_TAMANHO
2,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"N",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Peso Liquido",;	//X3Titulo()
"Quant",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
17,;			//X3_TAMANHO
2,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"N",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Peso Bruto",;	//X3Titulo()
"Quant2",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
17,;			//X3_TAMANHO
2,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"N",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Seg.Un.Qtd",;	//X3Titulo()
"SegQtd",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
17,;			//X3_TAMANHO
2,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"N",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Estorno",;	//X3Titulo()
"Estorno",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
1,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Num Sequen.",;	//X3Titulo()
"NumSeq",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
6,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Lote Destino",;	//X3Titulo()
"LoteDes",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
18,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"SubLote Destino",;	//X3Titulo()
"SubLDes",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
6,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Validade Destino",;	//X3Titulo()
"ValDes",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
8,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"D",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN

Aadd(aCabecalho, {;
"Status",;	//X3Titulo()
"Status",;  	//X3_CAMPO
"@!",;		//X3_PICTURE
1,;			//X3_TAMANHO
0,;			//X3_DECIMAL
"",;			//X3_VALID
"",;			//X3_USADO
"C",;			//X3_TIPO
"",;			//X3_F3
"R",;			//X3_CONTEXT
"",;			//X3_CBOX
"",;			//X3_RELACAO
""})			//X3_WHEN
Return


User function BTELA(vCod001) 

private cTitulo := "** Inclusão de Quantidade de etiquetas **" //titulo da janela 
private cTexto := "Informe a quantidade" 
private cQtd   :=  CriaVar("B1_QE",.T.) 



     DEFINE MSDIALOG oDlg2 TITLE cTitulo FROM 000,000 TO 100,300 PIXEL   //monta janela 
     @005,005 TO 045,145 OF oDlg2 PIXEL                          //borda interna 
     @015,020 SAY cTexto SIZE 060,007 OF oDlg2 PIXEL             //label 
     @012,075 MSGET cQtd SIZE 055,011 OF oDlg2 PIXEL PICTURE "@R 99,999.999" 

     DEFINE SBUTTON FROM 030,025 TYPE 1 ACTION (oDlg2:End()) ENABLE OF oDlg2              


ACTIVATE MSDIALOG oDlg2 CENTERED 

RETURN(cQtd)

