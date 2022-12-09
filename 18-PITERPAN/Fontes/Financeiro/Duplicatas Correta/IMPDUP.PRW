#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

User Function IMPDUP()


cPerg	:= "MTR750"

If !pergunte(cPerg,.T.)
	Return
Endif

Imprime()

Return()


Static Function IMPRIME()

///////////////////////////////////////////////////////////////////////
///Variaveis de fontes                                             ////
///////////////////////////////////////////////////////////////////////   
Private oFont6		:= TFONT():New("ARIAL",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal
Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
Private oFont8N 	:= TFONT():New("ARIAL",9,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
Private oFont10 	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 10 Normal
Private oFont10S	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.T.) ///Fonte 10 Sublinhando
Private oFont10N 	:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.F.) ///Fonte 10 Negrito
Private oFont10NS 	:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.T.) ///Fonte 10 Negrito Sublinhado
Private oFont11		:= TFONT():New("ARIAL",11,11,,.F.,,,,.T.,.F.) ///Fonte 11 Normal
Private oFont11NS	:= TFONT():New("ARIAL",11,11,,.T.,,,,.T.,.T.) ///Fonte 11 Negrito e Sublinhado
Private oFont11N	:= TFONT():New("ARIAL",11,11,,.T.,,,,.T.,.F.) ///Fonte 11 Negrito
Private oFont12		:= TFONT():New("ARIAL",12,12,,.F.,,,,.T.,.F.) ///Fonte 12 Normal
Private oFont12NS	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.T.) ///Fonte 12 Negrito e Sublinhado
Private oFont12N	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.F.) ///Fonte 12 Negrito
Private oFont13 	:= TFONT():New("ARIAL",13,13,,.F.,,,,.T.,.F.) ///Fonte 13 Normal 
Private oFont13N	:= TFONT():New("ARIAL",13,13,,.T.,,,,.T.,.F.) ///Fonte 13 Negrito
Private oFont14 	:= TFONT():New("ARIAL",14,14,,.F.,,,,.T.,.F.) ///Fonte 14 Normal 
Private oFont14N	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.F.) ///Fonte 14 Negrito
Private oFont16 	:= TFONT():New("ARIAL",16,16,,.F.,,,,.T.,.F.) ///Fonte 16 Normal
Private oFont16N	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.F.) ///Fonte 16 Negrito
Private oFont16NS	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.T.) ///Fonte 16 Negrito e Sublinhado
Private oFont22N	:= TFONT():New("ARIAL",22,22,,.T.,,,,.T.,.F.) ///Fonte 22 Negrito
Private cStartPath
Private nLin 		:= 100
Private oPrint		:= TMSPRINTER():New("")
Private nPag		:= 1
Private oBrush1 	:= TBrush():New( , CLR_HGRAY )     //CLR_HGRAY
Private oBrush2 	:= TBrush():New( , CLR_HGRAY )     //CLR_HGRAY
Private EOL  := Chr(13)+Chr(10)
Private _nEncerra := 0
Private nImp        := .F.
Private nSalto      := 1685

//Tamanho do Papel A4
#define DMPAPER_A4 9

//Orientacao do papel (Retrato ou Paisagem)
//oPrint:SetPaperSize(9)
//oPrint:SetLandscape() ///Define a orientacao da impressao como paisagem
oPrint:SetPortrait()///Define a orientacao da impressao como retrato

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
//ณMonta Query com itens para separa็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู
cQry:=EOL+ "SELECT E1_NUM                                                                                   "
cQry+=EOL+ ",E1_VALOR                                                                                       "
cQry+=EOL+ ",E1_CLIENTE                                                                                     "
cQry+=EOL+ ",E1_LOJA                                                                                     "
cQry+=EOL+ ",E1_PARCELA                                                                                     "
cQry+=EOL+ ",E1_VENCTO                                                                                      "
cQry+=EOL+ ",E1_EMISSAO                                                                                     "
cQry+=EOL+ "FROM  "+RetSqlName("SE1")+"  SE1                                                                "
cQry+=EOL+ "WHERE E1_FILIAL = '"+xFilial("SE1")+"'  "                                                       "
cQry+=EOL+ "AND SE1.D_E_L_E_T_ = ''                                                                         "
cQry+=EOL+ "AND E1_NUM BETWEEN '"+ALLTRIM(MV_PAR01)+"' AND '"+ALLTRIM(MV_PAR02)+"' AND E1_PREFIXO = '"+MV_PAR03+"' 	        "
cQry+=EOL+ "ORDER BY E1_PREFIXO,E1_NUM,E1_PARCELA                                                                             "
		
cQry := ChangeQuery(cQry)

If Select("QRY") > 0 
    QRY->(dbCloseArea()) 
EndIf

TCQUERY cQry NEW ALIAS "QRY"

If Empty(QRY->E1_NUM)    
	MsgAlert("Nใo foi encontrado nenhum titulo com esse numero! ","Aten็ใo")
	oPrint:EndPage()
	Return 
EndIf 

While QRY->(!EOF()) 
	//Monta o Cabe็alho

	Cabec()         
//	nLin+=50
	//nLin+=200 
	_cNota := QRY->E1_NUM

	While QRY->(!EOF()) .and. QRY->E1_NUM == _cNota
	//Salto de Pagina
		//Se nLin for maior que 1 entใo crie uma nova pagina.
//		If nLin > 1 //Valor original 2400
//		Rod() 
//		Alert (nPag)
//		nLin := 100
//		Cabec()
//		nLin+=200
//		Endif    
	nImp:= !nImp
  	If nImp
	   Cabec()
	EndIf

		oPrint:Say(360+If(nImp,0,1655), 1600,  DtoC(StoD(QRY->E1_EMISSAO)), oFont10N) //Data de Emissใo
		oPrint:Say(530+If(nImp,0,nSalto), 350,  QRY->E1_NUM, oFont10N) //Numero da Nota Fiscal ou do Titulo
		oPrint:Say(530+If(nImp,0,nSalto), 700,  "R$ "+Transform(QRY->E1_VALOR,"@E 9,999,999.99"), oFont10N) //Valor do titulo
		IF (QRY->E1_PARCELA = " ")                                                   
		oPrint:Say(530+If(nImp,0,nSalto), 1250, AllTrim(QRY->E1_NUM)+"-ฺnica", oFont10N) //Parcela do titulo		
		ELSE
		oPrint:Say(530+If(nImp,0,nSalto), 1250,  AllTrim(QRY->E1_NUM) + "-" + QRY->E1_PARCELA, oFont10N) //Parcela do titulo		
		ENDIF
		oPrint:Say(530+If(nImp,0,nSalto), 1600,  DtoC(StoD(QRY->E1_VENCTO)), oFont10N) //Vencimento do titulo (nใo ้ vencimento real) alterado a pedido do Sr. Roberto dia 21/02/13.
		oPrint:Say(850+If(nImp,0,nSalto), 600,  QRY->E1_CLIENTE+"/"+QRY->E1_LOJA+" - "+Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_NOME"), oFont10N) //Nome do Destinatario
		
		_cEND:= AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_END"))
		IF (_cEND <> "" .OR. _cEND <> "O MESMO")
			_cEND := AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_END"))+" - "+AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_BAIRRO")) 
			_cEST := Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_EST")
			_cCEP := Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_CEP")
			_cMUN := AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_MUN"))
		ELSE
			_cEND := AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_END"))+" - "+AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_BAIRRO"))
			_cEST := Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_EST")
			_cCEP := Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_CEP")
			_cMUN := AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_MUN"))
		ENDIF
		
		oPrint:Say(900+If(nImp,0,nSalto), 600, _cEND, oFont10N) //Endere็o do Destinatario	
		oPrint:Say(950+If(nImp,0,nSalto), 1350, Posicione("SX5",1,xFilial("SX5")+"12"+_cEST,"X5_DESCRI")) 
//		oPrint:Say(950, 1350,  AllTrim(Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE,"A1_EST")), oFont10N) //Estado do Destinatario
		oPrint:Say(950+If(nImp,0,nSalto), 2000,  Transform(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_CEP"),"@R 99999-999"), oFont10N) //Cep do Destinatario
		oPrint:Say(950+If(nImp,0,nSalto), 600,  AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_MUN")), oFont10N) //Municipio do Destinatario
		oPrint:Say(1000+If(nImp,0,nSalto), 800, AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_MUN"))+" - "+AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_EST")), oFont10N) //Pra็a de Pagamento do Destinatแrio
		oPrint:Say(1050+If(nImp,0,nSalto), 800,  Transform(AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_CGC")),"@R 99.999.999/9999-99"), oFont10N) //CNPJ do Destinatario
		oPrint:Say(1100+If(nImp,0,nSalto), 800,  AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_INSCR")), oFont10N) //Insc Estadual do Destinatario
		
		oPrint:Say(1280+If(nImp,0,1655), 550,  EXTENSO(QRY->E1_VALOR), oFont10N) //Valor do titulo por extenso		
			
		QRY->(DBSKIP()) 
		nPag++
		If !nImp
	   	Rod()
    	EndIf
	EndDo

//	Cabec()
  
EndDo
	
//Visualiza a impressao
oPrint:Preview() 

QRY->(DbCloseArea())

Return   
		
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabec     บAutor  Clistenis Batista    บ Data ณ  15/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Cabec()

PRIVATE oPrn    := NIL
PRIVATE oFont1  := NIL
PRIVATE oFont2  := NIL
PRIVATE oFont3  := NIL
PRIVATE oFont4  := NIL
PRIVATE oFont5  := NIL
PRIVATE oFont6  := NIL
 		
nLin := 50
oPrint:StartPage() // Inicia uma nova pagina
cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")
oPrint:SayBitmap(200, 70, cStartPath + "LGRL01.bmp", 400, 200)// Impressao da Logo
//oPrint:Say(nLin+55, 50, "                                                                                                 TอTULO NUM.: "+QRY->E1_NUM, oFont10)
//oPrint:Say(nLin+10, 2100, "Pแgina: " + cValToChar(nPag), oFont10)
//oPrint:Say(nLin+50, 2100, Time(), oFont10)
//oPrint:Say(nLin+85, 2100, DTOC(dDatabase), oFont10)
Private nSalto3 := 2165
//Criando o box geral
//linhainicio,colunainicio,linhafinal,colunafinal   
oPrint:Box(0100,0050,1650,2300)   // Cria BOX retangular em volta da duplicata
oPrint:Box(0100,0050,450,1250)   // Cria BOX retangular em volta do cabe็alho
oPrint:Box(0100,1250,450,2300)   // Cria BOX retangular em volta do cabe็alho
oPrint:Box(0450,0300,600,1850)   // Cria BOX retangular em volta dos campos de fatura corpo total
oPrint:FillRect( {0450,0300,500,1850}, oBrush1 )// Cria BOX retangular em volta dos campos de fatura parte cima (cinza)
oPrint:Box(0550,1900,800,2300)   // Cria BOX retangular a direira escrito DUPLICATA             
oPrint:Box(820,300,1150,2300)   // Cria BOX em volta dos dados do destinatแrio
oPrint:Box(1200,300,1400,500)   // Cria BOX em volta do cabe็alho do valor por extenso
oPrint:Box(1200,0500,1400,2300)   // Cria BOX em volta do valor por extenso
//oPrint:FillRect( {1200,0500,1400,2300}, oBrush1 )   // Cria BOX em volta do valor por extenso
oPrint:Line (450,550,600,550)  //Linha separando o numero da fatura
oPrint:Line (450,1050,600,1050)  //Linha separando o numero da fatura
oPrint:Line (450,1500,600,1500)  //Linha separando o numero da 

//As defini็๕es da 2ช Duplicata
oPrint:Box(3300,0050,1750,2300)   // Cria BOX retangular em volta da duplicata
oPrint:Box(2115,0050,1750,1250)   // Cria BOX retangular em volta do cabe็alho
oPrint:Box(2115,1250,1750,2300)   // Cria BOX retangular em volta do cabe็alho
oPrint:Box(2280,0300,2115,1850)   // Cria BOX retangular em volta dos campos de fatura corpo total
oPrint:FillRect( {2165,0300,2115,1850}, oBrush2 )// Cria BOX retangular em volta dos campos de fatura parte cima (cinza)
oPrint:Box(2500,1900,2225,2300)   // Cria BOX retangular a direira escrito DUPLICATA             
oPrint:Box(2835,300,2520,2300)   // Cria BOX em volta dos dados do destinatแrio
oPrint:Box(3050,300,2855,500)   // Cria BOX em volta do cabe็alho do valor por extenso
oPrint:Box(3050,0500,2855,2300)   // Cria BOX em volta do valor por extenso
//oPrint:FillRect( {3050,0500,2855,2300}, oBrush2 )   // Cria BOX em volta do valor por extenso
oPrint:Line (2280,550,2115,550)  //Linha separando o numero da fatura
oPrint:Line (2280,1050,2115,1050)  //Linha separando o numero da fatura
oPrint:Line (2280,1500,2115,1500)  //Linha separando o numero da fatura*/

/*
//ณInicio do texto do cabe็alhoณ
*/
Private nSalto1      := 1655
Private nSalto2      := 1685
        
		oPrint:Say(nLin+100+If(nImp,0,nSalto1), 500,  "PITER PAN IND. E COM. LTDA" , oFont10N)
		oPrint:Say(nLin+200+If(nImp,0,nSalto1), 500,  "RUA SOLON, 1100 - BOM RETIRO" , oFont8)
		oPrint:Say(nLin+250+If(nImp,0,nSalto1), 500,  "SรO PAULO - SP - CEP: 01127-00" , oFont8)		
		oPrint:Say(nLin+300+If(nImp,0,nSalto1), 500,  "Telefone: (11) 3357-0000 - Fax: (11) 3357-0002" , oFont8)
		oPrint:Say(nLin+350+If(nImp,0,nSalto1), 500,  "            E-mail: piterpan@piterpan.com.br" , oFont8)	
		
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDados do cabe็alho de duplicataณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                          
		oPrint:Say(nLin+070+If(nImp,0,nSalto1), 1300,  "                      D U P L I C A T A" , oFont14N)
		oPrint:Say(nLin+200+If(nImp,0,nSalto1), 1300,  "INSCRIวรO NO CNPJ (MF) Nบ: 61.497.186/0001-20" , oFont10)
		oPrint:Say(nLin+250+If(nImp,0,nSalto1), 1300,  "INSCRIวรO ESTADUAL Nบ: 104.817.670.116" , oFont10)		
		oPrint:Say(nLin+320+If(nImp,0,nSalto1), 1300,  "DATA DE EMISSรO: " , oFont8)		

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDizeres do cabe็alho dos quadros dos dados de titulosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say(0465, 0350,"FATURA Nบ " , oFont8)
		oPrint:Say(0465, 0580,"FATURA - DUPLICATA / VALOR R$ " , oFont8)
		oPrint:Say(0465, 1100,"DUPLICATA/Nบ DE ORDEM " , oFont8)
		oPrint:Say(0465, 1600,"VENCIMENTO    " , oFont8)

		//2ช DUPLICATA
		oPrint:Say(2120, 0350,"FATURA Nบ " , oFont8)
		oPrint:Say(2120, 0580,"FATURA - DUPLICATA / VALOR R$ " , oFont8)
		oPrint:Say(2120, 1100,"DUPLICATA/Nบ DE ORDEM " , oFont8)
		oPrint:Say(2120, 1600,"VENCIMENTO    " , oFont8)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTexto da caixa da direitaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		oPrint:Say(0600+If(nImp,0,nSalto1), 1950,"       PARA USO DA " , oFont8)
		oPrint:Say(0650+If(nImp,0,nSalto1), 1915,"INSTITUIวรO FINANCEIRA" , oFont8)
		oPrint:Say(0700+If(nImp,0,nSalto1), 1950,"DUPLICATA" , oFont14N)
                           

		oPrint:Say(0650+If(nImp,0,nSalto1), 300,"DESCONTO DE" , oFont8)
		oPrint:Say(0650+If(nImp,0,nSalto1), 750,"% SOBRE R$" , oFont8)
		oPrint:Say(0650+If(nImp,0,nSalto1), 1300,"ATษ" , oFont8)
		
		oPrint:Line (600, 200, 1500, 200)

		oPrint:Say(0750+If(nImp,0,nSalto1), 300,"CONDIวีES ESPECIAIS" , oFont8)
		
		oPrint:Say(850+If(nImp,0,nSalto2), 350,"DESTINATมRIO: " , oFont8)		
		oPrint:Say(900+If(nImp,0,nSalto2), 350,"ENDEREวO: " , oFont8)				
		oPrint:Say(950+If(nImp,0,nSalto2), 350,"MUNICอPIO: " , oFont8)				
		oPrint:Say(950+If(nImp,0,nSalto2), 1200,"ESTADO: " , oFont8)				
		oPrint:Say(950+If(nImp,0,nSalto2), 1900,"CEP: " , oFont8)				
		oPrint:Say(1000+If(nImp,0,nSalto2), 350,"PRAวA DE PAGAMENTO: " , oFont8)						
		oPrint:Say(1050+If(nImp,0,nSalto2), 350,"INSCR. NO C.N.P.J. (M.F.) Nบ: " , oFont8)						
		oPrint:Say(1100+If(nImp,0,nSalto2), 350,"INSCR. ESTADUAL Nบ: " , oFont8)						

		oPrint:Say(1220+If(nImp,0,nSalto1), 350, "VALOR" , oFont8N)	
		oPrint:Say(1270+If(nImp,0,nSalto1), 350, "  POR" , oFont8N)	
		oPrint:Say(1320+If(nImp,0,nSalto1), 345, "EXTENSO" , oFont8N)	
		
		oPrint:Say(1430+If(nImp,0,nSalto1), 350, "RECONHEวO(EMOS)  A  EXATIDรO  DESTA  DUPLICATA  DE  VENDA  MERCANTIL,  NA  IMPORTยNCIA  ACIMA,  QUE  PAGAREI(EMOS)  ภ " , oFont8)	
		oPrint:Say(1480+If(nImp,0,nSalto1), 350, "PITE PAN IND. E COM. LTDA., OU ภ SUA ORDEM NA PRAวA E VENCIMENTO INDICADOS." , oFont8)	
		
		oPrint:Say(1550+If(nImp,0,nSalto1), 350, "_______/_______/_______                                              ____________________________________________________" , oFont10)			
		oPrint:Say(1600+If(nImp,0,nSalto1), 450, "DATA DO ACEITE" , oFont8)			
		oPrint:Say(1600+If(nImp,0,nSalto1), 1600, "ASSINATURA DO SACADO" , oFont8)			

/*    
nLin += 100
nLin += 20
nLin += 20
nLin += 20

nLin += 50  
nLin += 50
oPrint:Line (nLin + 230, 50, nLin + 230, 2300)
nLin += 50

oPrint:Say(nLin+200, 50, "C๓digo", oFont10NS)
oPrint:Say(nLin+200, 250, "Produto", oFont10NS)
oPrint:Say(nLin+200, 800, "Nบ Lote", oFont10NS)
oPrint:Say(nLin+200, 1000, "Arm.", oFont10NS)
oPrint:Say(nLin+200, 1150, "Qtde Emb.", oFont10NS)  
oPrint:Say(nLin+200, 1400, "Qtde", oFont10NS)
oPrint:Say(nLin+200, 1550, "Unid", oFont10NS)
oPrint:Say(nLin+200, 1700, "Prc Unit.", oFont10NS)
oPrint:Say(nLin+200, 1900, "Vlr Total", oFont10NS)
oPrint:Say(nLin+200, 2100, "TES", oFont10NS)
oPrint:Say(nLin+200, 2200, "CFOP", oFont10NS)
*/

Return                    
        	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRod       บAutor  KAREM CAROLINE       บ Data ณ  06/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function Rod()

oPrint:EndPage() // Termina a pagina

Return 

