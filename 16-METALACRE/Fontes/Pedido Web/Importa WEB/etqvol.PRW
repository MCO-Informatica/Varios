#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EtqVol ºAutor  ³ Luiz Alberto V Alves º Data ³  20/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Impressão de Etiquetas de Embalagem de Mercadoriasº±±
±±º          ³ por nota fiscal e por quantidade de volumes                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION EtqVol(cPedNum)
Local aArea	:= GetArea()
PRIVATE Exec       	:= .F.
Private cPerg    	:= PadR("ETQVO2",10)
Private aNotas		:= {}
Private oNotas	
Private _oSinal1   := LoadBitmap(GetResources(),"BR_MARROM")
Private _oSinal2   := LoadBitmap(GetResources(),"BR_VERMELHO")
Private _oSinal3   := LoadBitmap(GetResources(),"BR_AMARELO")
Private _oSinal4   := LoadBitmap(GetResources(),"BR_AZUL")
Private _oSinal5   := LoadBitmap(GetResources(),"BR_VERMELHO")
Private _oSinal6   := LoadBitmap(GetResources(),"BR_CINZA")
Private _oSinal7   := LoadBitmap(GetResources(),"BR_BRANCO")
Private _oSinal8   := LoadBitmap(GetResources(),"BR_LARANJA")
Private _oSinal9   := LoadBitmap(GetResources(),"BR_VERDE")
Private _oOk		 := LoadBitmap(GetResources(),"LBTIK")
Private _oNo  	 := LoadBitmap(GetResources(),"LBNO")

dbSelectArea("SF2")

AJUSTASX1()
                            
If cPedNum == Nil                                                      
	If !PERGUNTE(cPerg,.T.)
		Return
	Endif
Else 
	Pergunte(cPerg,.f.)
	MV_PAR01 := Space(TAMSX3("F2_DOC")[1])
	MV_PAR02 := Replicate("Z",TAMSX3("F2_DOC")[1])
	MV_PAR03 := Space(TAMSX3("F2_SERIE")[1])
	MV_PAR04 := Replicate("Z",TAMSX3("F2_SERIE")[1])
Endif
// Query Busca de Notas Fiscais

cQuery := 	 " SELECT F2_DOC, F2_SERIE, F2_EMISSAO, F2_CLIENTE, F2_LOJA, F2_TRANSP, F2_VALBRUT, F2_VOLUME1 "
cQuery +=	 " FROM " + RetSqlName("SF2") + " F2 (NOLOCK) "
cQuery +=	 " WHERE  "
cQuery +=	 " F2_FILIAL = '" + xFilial("SF2") + "' "
cQuery +=	 " AND F2.D_E_L_E_T_ = '' "      
cQuery +=	 " AND F2.F2_DOC >= '" + MV_PAR01 + "' AND F2.F2_DOC <= '" + MV_PAR02 + "' "
cQuery +=	 " AND F2.F2_SERIE >= '" + MV_PAR03 + "' AND F2.F2_SERIE <= '" + MV_PAR04 + "' "
cQuery +=	 " AND F2.F2_TIPO = 'N' " //AND F2.F2_FIMP IN('1','S') AND F2.F2_CHVNFE <> '' " // IMPRESSO APÓS DANFE E SÓMENTE VALIDAS
cQuery +=	 " ORDER BY F2_DOC "

TCQUERY cQuery NEW ALIAS "KAD"

TcSetField('KAD',"F2_EMISSAO","D")


dbSelectArea("KAD")
dbGoTop()
While KAD->(!Eof()) 
	nAchou := Ascan(aNotas,{|x| x[5] == KAD->F2_DOC})
	If Empty(nAchou)
		SD2->(dbSetOrder(3), dbSeek(xFilial("SD2")+KAD->F2_DOC+KAD->F2_SERIE))
	
		AAdd(aNotas,{	'',;
						'1',;
						DtoC(KAD->F2_EMISSAO),;
						SD2->D2_PEDIDO,;
						KAD->F2_DOC,;
						KAD->F2_SERIE,;
						KAD->F2_CLIENTE,;
						KAD->F2_LOJA,;
						Posicione("SA1",1,xFilial("SA1")+KAD->F2_CLIENTE+KAD->F2_LOJA,"A1_NOME"),;
						Str(KAD->F2_VOLUME1),;
						KAD->F2_TRANSP,;
						TransForm(KAD->F2_VALBRUT,"@E 9,999,999.99")})
	Endif
	KAD->(dbSkip(1))
Enddo
KAD->(dbCloseArea())     

If Empty(Len(aNotas))
	Alert("Notas Não Localizadas nos Filtros Informados, Verifique !!!")
	Return .t.
Endif

If cPedNum == NIL

	@ 001,001 TO 400,800 DIALOG oDlg TITLE "Selecao de Notas"

	@ 001, 001 LISTBOX oNotas Fields HEADER '','',"Emissão",'Pedido','Nota','Série','Cod Cli','Loja','Razão Social','Volume','Cod.Transp','Vlr Bruto' SIZE 400, 160 OF oDlg PIXEL ColSizes 50,50

	oNotas:SetArray(aNotas)
	oNotas:bLine := {|| {	Iif(aNotas[oNotas:nAt,2]=="1",_oSinal9,_oSinal2),;
							Iif(aNotas[oNotas:nAt,2]=="1",_oOk,_oNo),;
        					aNotas[oNotas:nAt,3],;
      						aNotas[oNotas:nAt,4],;
					      	aNotas[oNotas:nAt,5],;
					      	aNotas[oNotas:nAt,6],;
					      	aNotas[oNotas:nAt,7],;
					      	aNotas[oNotas:nAt,8],;
					      	aNotas[oNotas:nAt,9],;
					      	aNotas[oNotas:nAt,10],;
					      	aNotas[oNotas:nAt,11],;
					      	aNotas[oNotas:nAt,12]}}

	// Só Habilita a Marcacao se For Pagamento, se For Estorno já trará os Chques Marcados
	oNotas:bLDblClick := {||Processa({||dblClick(oNotas:nAt)})}

	@ 180,100 BUTTON "Marcar"         SIZE 40,15 ACTION MsAguarde({||MarcarTudo()},'Marcando Registros...')
	@ 180,150 BUTTON "Desmarcar"      SIZE 40,15 ACTION MsAguarde({||DesMarcaTudo()},'Desmarcando Registros...')
	@ 180,200 BUTTON "Etiquetas"		  SIZE 40,15 ACTION MsAguarde({|| Exec := .t. , Close(oDlg)},'Enviando Etiquetas...')
	@ 180,250 BUTTON "_Sair"          SIZE 40,15 ACTION Close(oDlg)

	ACTIVATE DIALOG oDlg CENTERED
	IF Exec
		PROCESSA({|lEnd|ImpGrafico(aNotas)})
	ENDIF
Else 
	If MsgYesNo('Confirma a Reimpressao das Etiquetas de Volume do Pedido ' + cPedNum + ' ? ')                                     
		ImpGrafico(aNotas)
	Endif
Endif

RestArea(aArea)
RETURN Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpGraficoºAutor  ³Microsiga           º Data ³  06/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao da Etiqueta em Modo Grafico.					  º±±
±±º          ³														      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 - Especifico - GPS                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpGrafico(aNotas)
Local oPrint
Local cLogo    		:= FisxLogo("1")
Local oBrush  		:= TBrush():NEW("",CLR_HGRAY)          
Local oBrushG  		:= TBrush():NEW("",CLR_YELLOW)          
Local oPen			:= TPen():New(0,5,CLR_BLACK)
Local oCouNew08		:= TFont():New("Courier New"	,08,08,,.F.,,,,.T.,.F.)
Local oCouNew02N	:= TFont():New("Courier New"	,02,02,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
Local oCouNew03N	:= TFont():New("Courier New"	,03,03,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
Local oCouNew04N	:= TFont():New("Courier New"	,10,10,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
Local oCouNew05N	:= TFont():New("Courier New"	,10,10,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
Local oCouNew06N	:= TFont():New("Courier New"	,06,06,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
Local oCouNew07N	:= TFont():New("Courier New"	,07,07,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
Local oCouNew08N	:= TFont():New("Courier New"	,08,08,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
Local oCouNew09N	:= TFont():New("Courier New"	,09,09,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
Local oCouNew10N	:= TFont():New("Courier New"	,10,10,,.T.,,,,.F.,.F.)		// Negrito
Local oCouNew12N	:= TFont():New("Courier New"	,12,12,,.T.,,,,.F.,.F.)		// Negrito
Local oCouNew12		:= TFont():New("Courier New"	,12,12,,.F.,,,,.T.,.F.)		// Negrito
Local oCouNew11N	:= TFont():New("Courier New"	,11,11,,.T.,,,,.F.,.F.)		// Negrito
Local oCouNew11 	:= TFont():New("Courier New"	,11,11,,.F.,,,,.T.,.F.)            
Local oArial02N		:= TFont():New("Arial"			,02,02,,.T.,,,,.F.,.F.)		// Negrito     
Local oArial03N		:= TFont():New("Arial"			,03,03,,.T.,,,,.F.,.F.)		// Negrito     
Local oArial04N		:= TFont():New("Arial"			,04,04,,.T.,,,,.F.,.F.)		// Negrito     
Local oArial05N		:= TFont():New("Arial"			,10,10,,.T.,,,,.F.,.F.)		// Negrito     
Local oArial06N		:= TFont():New("Arial"			,06,06,,.T.,,,,.F.,.F.)		// Negrito     
Local oArial07N		:= TFont():New("Arial"			,07,07,,.T.,,,,.F.,.F.)		// Negrito
Local oArial09N		:= TFont():New("Arial"			,09,09,,.T.,,,,.F.,.F.)		// Negrito
Local oArial10N		:= TFont():New("Arial"			,10,10,,.T.,,,,.F.,.F.)		// Negrito
Local oArial11N		:= TFont():New("Arial"			,11,11,,.T.,,,,.F.,.F.)		// Negrito
Local oArial12		:= TFont():New("Arial"			,12,12,,.F.,,,,.T.,.F.)		// 
Local oArial12N		:= TFont():New("Arial"			,12,12,,.T.,,,,.F.,.F.)		// Negrito
Local oArial14N		:= TFont():New("Arial"			,14,14,,.T.,,,,.F.,.F.)		// Negrito
Local oCouNew12S	:= TFont():New("Courier New"	,12,12,,.T.,,,,.F.,.F.)		// SubLinhado

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o objeto e Configura o Formato³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint := TMSPrinter():New("ETIQUETA")
oPrint:Setup()
oPrint:SetPortrait()
oPrint:SetPaperSize(9)			// Seta para papel A4

ProcRegua(Len(aNotas),'Imprimindo Etiquetas para Embalagem')    

For nN := 1 To Len(aNotas)
	IncProc()
	
	IF aNotas[nN,2] == '1' // Marcada
		If SF2->(dbSetOrder(1), dbSeek(xFilial("SF2")+aNotas[nN,5]+aNotas[nN,6]))
			cPedCli	:= ''       
			cPedido := '' 
			nQtd	:= 0
			If SD2->(dbSetOrder(3), dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
				cPedido := SD2->D2_PEDIDO
				
				While SD2->(!Eof()) .And. SD2->D2_FILIAL == xFilial("SD2") .And. SD2->D2_DOC == SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE .And.;
						SD2->D2_CLIENTE == SF2->F2_CLIENTE .And. SD2->D2_LOJA == SF2->F2_LOJA

					nQtd += SC6->C6_QTDVEN

					// Localiza Item do Pedido de Vendas
					
					If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))
						If !Empty(SC6->C6_PEDCLI) .And. !AllTrim(SC6->C6_PEDCLI)$cPedCli
							cPedCli+=' ' + AllTrim(SC6->C6_PEDCLI)+'/'
						Endif                                         
					Endif
					// Tratamento Conteudo Variavel cPedCli					
					If !Empty(cPedCli)
						cPedCli := Left(cPedCli,Len(AllTrim(cPedCli))-1)	// Elimina a ultima Barra
					Endif
					
					SD2->(dbSkip(1))
				Enddo
			Endif

			nEmbala := Int((nQtd/10))

			SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
			SA4->(dbSetOrder(1), dbSeek(xFilial("SA4")+SF2->F2_TRANSP))
			SD2->(dbSetOrder(3), dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
			SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
				
			nVolumes:= Iif(!Empty(SF2->F2_VOLUME1),SF2->F2_VOLUME1,1)
			nVolumes:= Iif(nVolumes < 4, 4, nVolumes)
//			For nI := 1 To nVolumes Step 4
				oPrint:StartPage()
				
				// LogoTipo Day Brasil
				
				oPrint:SayBitmap(020,100,cLogo,200,200)			
				                                                                                
				oPrint:Say(050,0350,"Nota   : ",oArial05N)  
				oPrint:Say(100,0350,"Série  : ",oArial05N) 
				oPrint:Say(150,0350,"Emissão: ",oArial05N) 
				oPrint:Say(200,0350,"Pedido WEB:",oArial05N)

				oPrint:Say(050,0600,SF2->F2_DOC,oCouNew05N)  
				oPrint:Say(100,0600,SF2->F2_SERIE,oCouNew05N) 
				oPrint:Say(150,0600,DtoC(SF2->F2_EMISSAO),oCouNew05N)
				If SC5->(FieldPos("C5_PEDWEB")) > 0
					oPrint:Say(200,0600,SC5->C5_PEDWEB,oCouNew05N)  
				Endif
	                             
				oPrint:Say(250,0100,"Cliente ",oArial05N)
			    lOutro  := .f.
			    If !Empty(SA1->A1_ENDENT)
			    	If AllTrim(SA1->A1_ENDENT) <> AllTrim(SA1->A1_END)
			    		lOutro := .t.
			    	Endif
			    Endif
			    
			    If At("A/C:",SC5->C5_MENNOTA) > 0 .And. lOutro
					cNome := SubStr(SC5->C5_MENNOTA,At("A/C:",SC5->C5_MENNOTA))
				Else
					cNome    := SA1->A1_NOME
				Endif

				_nLinhas := MlCount(cNome,40)
				lI := 0300
				For _nL := 1 To _nLinhas
					oPrint:Say(Li,0100,MemoLine(cNome,40,_nL),oCouNew04N)  
					lI+=40
				Next _nL
				

				oPrint:Say(400,0100,"Embalagem(s)",oArial05N)
//				oPrint:Say(400,0750,"Pedido ",oArial05N)

				oPrint:Say(450,0100,Str(nEmbala,3),oCouNew05N)  
//				oPrint:Say(450,0750,cPedido,oCouNew05N)  

//				oPrint:Say(200,0270,"Pedido Cliente ",oArial05N)
				
				nLin := 550
				
				oPrint:Say(nLin,0100,"Endereço: ",oArial05N)
				nLin+=50
				If !Empty(SA1->A1_ENDENT) .And. AllTrim(SA1->A1_END) <> AllTrim(SA1->A1_ENDENT)
					cEnd := AllTrim(SA1->A1_ENDENT)+' '+AllTrim(SA1->A1_BAIRROE)+ ' ' +AllTrim(SA1->A1_MUNE)+' '+AllTrim(SA1->A1_ESTE)+' CEP:'+TransForm(SA1->A1_CEPE,"@R 99999-999")
				Else
					cEnd := AllTrim(SA1->A1_END)+' '+AllTrim(SA1->A1_BAIRRO)+ ' ' + AllTrim(SA1->A1_MUN)+' '+AllTRIm(SA1->A1_COMPLEM)+' '+AllTrim(SA1->A1_EST)+' CEP:'+TransForm(SA1->A1_CEP,"@R 99999-999")
				Endif
				
				_nLinhas := MlCount(cEnd,30)
				lI := nLin
				For _nL := 1 To _nLinhas
					oPrint:Say(Li,0100,MemoLine(cEnd,30,_nL),oCouNew05N)  
					lI+=50
				Next _nL  
				nLin := lI

				If !Empty(SF2->F2_TRANSP)
					nLin+=50
					oPrint:Say(nLin,0100,"Transportadora ",oArial05N)
					nLin+=50
					oPrint:Say(nLin,0100,SA4->A4_NOME,oCouNew04N)  
				Endif                                                        

				nLin+=50
				oPrint:Say(nLin,0100,"Tipo Envio ",oArial05N)
				nLin+=50
				oPrint:Say(nLin,0100,SF2->F2_TRANSP,oCouNew04N)  
				
				

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Finaliza a Pagina³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				oPrint:EndPage()
//			Next
		Endif        

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Finaliza a Pagina³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//		oPrint:EndPage()
	Endif

Next
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Visualiza o Relatorio na Tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Preview()
//oPrint:Print()     
MS_FLUSH()
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1   ³ Autor ³ Anderson Ciriaco   ³ Data ³ 22/08/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajustar as perguntas no SX1.					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AjustaSX1		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RGPR01, Localizacoes...                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1()
LOCAL aRegs 	:= {}
LOCAL cPerg    := PadR("ETQVO2",10)
LOCAL aAreaOld 	:= GetArea()
Local nX        := 0

AADD(aRegs,{"Da Nota           ?","Da Nota           ?","Da Nota           ?","mv_ch1","C", 9,0,0,"G",""  ,"mv_par01",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""  	   ,""	   ,""	  ,"",""})
AADD(aRegs,{"Até a Nota        ?","Até a Nota        ?","Até a Nota        ?","mv_ch2","C", 9,0,0,"G",""  ,"mv_par02",""		     ,""		   ,""            ,"" ,"",""				  ,""			    ,""			   ,"","",""	   ,""	   ,""	  ,"",""})
AADD(aRegs,{"Da Serie          ?","Da Serie          ?","Da Serie          ?","mv_ch3","C", 3,0,0,"G",""  ,"mv_par03",""		     ,""		   ,""			  ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,"",""})
AADD(aRegs,{"Até a Serie       ?","Até a Serie       ?","Até a Serie       ?","mv_ch4","C", 3,0,0,"G",""  ,"mv_par04",""		     ,""		   ,""            ,"" ,"",""				  ,""				,""			   ,"","",""	   ,""	   ,""	  ,"",""})

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aRegs)
	If !(dbSeek(cPerg+StrZero(nx,2)))
		RecLock("SX1",.T.)
		Replace X1_GRUPO    with cPerg
		Replace X1_ORDEM   	with StrZero(nx,2)
		Replace x1_pergunte	with aRegs[nx][01]
		Replace x1_perspa   with aRegs[nx][02]
		Replace x1_pereng   with aRegs[nx][03]
		Replace x1_variavl	with aRegs[nx][04]
		Replace x1_tipo		with aRegs[nx][05]
		Replace x1_tamanho	with aRegs[nx][06]
		Replace x1_decimal	with aRegs[nx][07]
		Replace x1_presel   with aRegs[nx][08]
		Replace x1_gsc      with aRegs[nx][09]
		Replace x1_valid    with aRegs[nx][10]
		Replace x1_var01    with aRegs[nx][11]
		Replace x1_def01    with aRegs[nx][12]
		Replace x1_defspa1	with aRegs[nx][13]
		Replace x1_defeng1	with aRegs[nx][14]
		Replace x1_cnt01    with aRegs[nx][15]
		Replace x1_var02    with aRegs[nx][16]
		Replace x1_def02    with aRegs[nx][17]
		Replace x1_defspa2	with aRegs[nx][18]
		Replace x1_defeng2	with aRegs[nx][19]
		Replace x1_cnt02    with aRegs[nx][20]
		Replace x1_var03    with aRegs[nx][21]
		Replace x1_def03    with aRegs[nx][22]
		Replace x1_defspa3	with aRegs[nx][23]
		Replace x1_defeng3	with aRegs[nx][24]
		Replace x1_f3     	with aRegs[nx][25]
		Replace x1_grpsxg 	with aRegs[nx][26]
		MsUnlock()
	Endif
Next

RestArea( aAreaOld )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DblClick³ Autor ³ Luiz Alberto        ³ Data ³ 20/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao Responsavel pelo Double Click Tela Notas ³±±
±±³          |                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function dblClick(nPos)
Local aArea := GetArea()

If aNotas[nPos,2]=="1"
	aNotas[nPos,2]:="2"
Else
	aNotas[nPos,2]:="1"
Endif
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MarcaTudo ³ Autor ³ Luiz Alberto        ³ Data ³ 20/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao Responsavel por Marcar todas as Notas ³±±
±±³          |                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MarcarTudo()
For nI := 1 To Len(aNotas)
	aNotas[nI,2] := '1'
Next
oNotas:Refresh()
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ DesMarcaTudo³ Autor ³ Luiz Alberto        ³ Data ³ 20/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao Responsavel por Desmarcar todas as Notas ³±±
±±³          |                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DesMarcaTudo()
For nI := 1 To Len(aNotas)
	aNotas[nI,2] := '2'
Next
oNotas:Refresh()
Return .t.
