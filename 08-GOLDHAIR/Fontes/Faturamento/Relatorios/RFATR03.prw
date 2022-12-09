#INCLUDE "protheus.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"  
#INCLUDE "TopConn.ch"   

#DEFINE IMP_SPOOL 2

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATR03   � Autor � Anderson Goncalves � Data �  25/11/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Impressao do pedido de vendas                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gold Hair                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/ 
                                                                                   
User Function RFATR03(cPedido) 

//���������������������������������������������������������������������Ŀ
//� Variaveis da rotina                                                 �
//�����������������������������������������������������������������������
Private Titulo   	:= OemToAnsi("Pedido de Vendas")
Private cDesc    	:= OemToAnsi("Impress�o do Pedido de Vendas")
Private wnrel    	:= "RFATR03"
Private aOrd     	:= {}
Private aReturn  	:= { "Zebrado", 1,"Administracao", 2, 2, 2, "",2 }
Private cString  	:= "SC5"
Private cPerg    	:= "RFATR03"
Private nTamanho 	:= "G"         
Private nLastKey 	:= 0
Private nLin     	:= 0
Private lEnd     	:= .F.
Private limite   	:= 80
Private nLastKey 	:= 0
Private lAuto    	:= .F.
Private lImpresAut 	:= .F.

Private oFont		:= Nil
Private cCode		:= ""
Private nHeight   	:= 15
Private lBold     	:= .F.
Private lUnderLine	:= .F.
Private lPixel    	:= .T.
Private lPrint    	:=.F.

Private oFont06  := tFont():New("ARIAL",06,06,,.f.,,,,.t.,.f.)
Private oFont06N := tFont():New("ARIAL",06,06,,.t.,,,,.t.,.f.)
Private oFont08  := tFont():New("ARIAL",08,08,,.f.,,,,.t.,.f.)
Private oFont08N := tFont():New("ARIAL",08,08,,.t.,,,,.t.,.f.)
Private oFont09  := tFont():New("ARIAL",09,09,,.f.,,,,.t.,.f.)
Private oFont09N := tFont():New("ARIAL",09,09,,.t.,,,,.t.,.f.)
Private oFont10  := tFont():New("ARIAL",10,10,,.f.,,,,.t.,.f.)
Private oFont10N := tFont():New("ARIAL",10,10,,.t.,,,,.t.,.f.)
Private oFont11  := tFont():New("ARIAL",11,11,,.f.,,,,.t.,.f.)
Private oFont11N := tFont():New("ARIAL",11,11,,.t.,,,,.t.,.f.)
Private oFont12  := tFont():New("ARIAL",12,12,,.f.,,,,.t.,.f.)
Private oFont12N := tFont():New("ARIAL",12,12,,.t.,,,,.t.,.f.)
Private oFont14  := tFont():New("ARIAL",14,14,,.f.,,,,.t.,.f.)
Private oFont14N := tFont():New("ARIAL",14,14,,.t.,,,,.t.,.f.)
Private oFont16  := tFont():New("ARIAL",16,16,,.f.,,,,.t.,.f.)
Private oFont16N := tFont():New("ARIAL",16,16,,.t.,,,,.t.,.f.)
Private oFont18  := tFont():New("ARIAL",18,18,,.f.,,,,.t.,.f.)
Private oFont18N := tFont():New("ARIAL",18,18,,.t.,,,,.t.,.f.)   

Private oFont10C  := tFont():New("Courier New",10,10,,.f.,,,,.t.,.f.)
Private oFont10CN := tFont():New("Courier New",10,10,,.t.,,,,.t.,.f.)

Private nRegistros	:= 0    
Private oPrn  
Private nVez		:= 0
Private nPaginas	:= 1  

Private nValICMSST 	:= 0
Private nValIPI		:= 0
Private nValICMS	:= 0 
Private nDesconto	:= 0
Private nValProd	:= 0
Private nTotal 		:= 0   
Private nBaseICM	:= 0
Private nFrete		:= 0 
Private nPeso		:= 0
Private nVolume		:= 0      

//���������������������������������������������������������������������Ŀ
//� Posiciona no pedido de vendas                                       �
//�����������������������������������������������������������������������
dbSelectArea("SC5") 
SC5->(dbSetOrder(1))
SC5->(dbSeek(xFilial("SC5")+cPedido ))  

//���������������������������������������������������������������������Ŀ
//� Seleciona os itens do pedido                                        �
//����������������������������������������������������������������������� 
cQuery := "SELECT R_E_C_N_O_ RECSC6 FROM "+RetSqlName("SC6") + " (NOLOCK) "
cQuery += "WHERE C6_FILIAL = '"+SC5->C5_FILIAL+"' "
cQuery += "AND C6_NUM = '"+SC5->C5_NUM+"' "
cQuery += "AND D_E_L_E_T_ = ' ' "

If Select("QUERY") > 0
	QUERY->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "QUERY"
dbSelectArea("QUERY")
QUERY->(dbGoTop())   
QUERY->(dbEval({ || nRegistros++ },,{ ||!EOF()}))
QUERY->(dbGoTop())

//���������������������������������������������������������������������Ŀ
//� Inicia modo grafico                                                 �
//�����������������������������������������������������������������������
Private nDevice
Private oSetup
Private aDevice  := {}
Private cSession := GetPrinterSession()  

cFilePrint := "pedido_"+SC5->C5_NUM+"_"+Dtos(MSDate())+StrTran(Time(),":","")

oPrn      := FWMSPrinter():New(cFilePrint,6,.T.,,.T.)  
oPrn:SetPortrait()   
oPrn:SetResolution(78)
oPrn:SetPaperSize(DMPAPER_A4)
oPrn:SetMargin(60,60,60,60)
oPrn:cPathPDF := GetTempPath()

//���������������������������������������������������������������������Ŀ
//� Inicia a montagem do relatorio                                      �
//�����������������������������������������������������������������������
Processa({|| Imprime(@oPrn) },"Imprimindo...")   

oPrn:Preview()

FreeObj(oPrn)
oPrn := Nil   

//���������������������������������������������������������������������Ŀ
//� Dispara Email ao cliente                                            �
//�����������������������������������������������������������������������
If Aviso("RFATR03","Deseja enviar automaticamente este pedido por e-mail?",{"&Sim","&Nao"},2,"Aten��o") == 1  
	CpyT2S( GetTempPath()+cFilePrint+".pdf", "\spool\", .T. )
	EnvMail("\spool\"+cFilePrint+".pdf")
EndIf	

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Imprime   � Autor � Anderson Goncalves � Data �  21/11/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Impressao do boleto                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gold Hair                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/ 
                                                                                   
Static Function Imprime(oPrn)

//���������������������������������������������������������������������Ŀ
//� Variaveis da rotina                                                 �
//����������������������������������������������������������������������� 
Local nCont	:= 0  

//���������������������������������������������������������������������Ŀ
//� Inicializacao da regua                                              �
//����������������������������������������������������������������������� 
ProcRegua(nRegistros)  

Ma415Impos()  

dbSelectArea("SC6")
SC6->(dbSetOrder(1))  

dbSelectArea("SB1")
SB1->(dbSetOrder(1))

//���������������������������������������������������������������������Ŀ
//� Processa o resultado dos itens                                      �
//����������������������������������������������������������������������� 
nLinha := 780
While QUERY->(!EOF())      

	//���������������������������������������������������������������������Ŀ
	//� Atualiza a regua de processamento                                   �
	//����������������������������������������������������������������������� 
	IncProc("Imprimindo, aguarde...") 
	
	nCont++
	If nCont == 1
		nVez++ 
		Esqueleto(oPrn)
	EndIf    
	
	SC6->(dbGoTo(QUERY->RECSC6)) 
	SB1->(dbSeek(xFilial("SB1")+SC6->C6_PRODUTO ))
	
	oPrn:Say(nLinha,0010, SC6->C6_PRODUTO,oFont10C) 
	oPrn:Say(nLinha,0200, SubStr(SB1->B1_DESC,1,50),oFont10C) 
	oPrn:Say(nLinha,1025, TransForm(SC6->C6_QTDVEN,"@E 999999.99"),oFont10C)  
	oPrn:Say(nLinha,1220, TransForm(SC6->C6_PRCVEN,"@E 9,999,999.99"),oFont10C)
	oPrn:Say(nLinha,1580, TransForm(SC6->C6_DESCONT,"@E 999.99"),oFont10C)
	oPrn:Say(nLinha,1680, TransForm(SC6->C6_VALOR,"@E 9,999,999.99"),oFont10C)
	oPrn:Say(nLinha,1950, TransForm(SC6->C6_ENTREG,"@D"),oFont10C)
	oPrn:Say(nLinha,2140, TransForm(SB1->B1_PESO*SC6->C6_QTDVEN,PesqPict("SB1","B1_PESO")),oFont10C)
	
	nLinha+=50  
	
	If nCont == 21
		nCont 	:= 0
		nLinha 	:= 780
		oPrn:EndPage()
	EndIf  
	
	QUERY->(dbSkip())
	
Enddo  

//���������������������������������������������������������������������Ŀ
//� Finaliza Pagina                                                     �
//����������������������������������������������������������������������� 
oPrn:EndPage()

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Esqueleto � Autor � Anderson Goncalves � Data �  21/11/13   ���
�������������������������������������������������������������������������͹��
���Descricao �Montagem do esqueleto do relatorio                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gold Hair                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/ 
                                                                                   
Static Function Esqueleto(oPrn)

//���������������������������������������������������������������������Ŀ
//� Variaveis da rotina                                                 �
//�����������������������������������������������������������������������  
Local cBitMap := "goldhair.Bmp"  

//���������������������������������������������������������������������Ŀ
//� Inicializacao da nova pagina                                        �
//�����������������������������������������������������������������������
oPrn:StartPage() 

//���������������������������������������������������������������������Ŀ
//� Impressao dos dados do emitente                                     �
//�����������������������������������������������������������������������
oPrn:SayBitmap(010,010,cBitMap,468,167)	
oPrn:Say(050,0560, OemToAnsi("Emitente: "),oFont11N)   
oPrn:Say(050,0740, SM0->M0_NOMECOM,oFont11)
oPrn:Say(090,0560, OemToAnsi("Endere�o: ") ,oFont11N) 
oPrn:Say(090,0740, AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_BAIRCOB) ,oFont11)
oPrn:Say(130,0560, OemToAnsi("Cep:"),oFont11N)
oPrn:Say(130,0740, TransForm(SM0->M0_CEPCOB,"@R 99999-999")+" - "+AllTrim(SM0->M0_CIDCOB)+" - "+AllTrim(SM0->M0_ESTCOB),oFont11)
oPrn:Say(170,0560, OemToAnsi("Tel:"),oFont11N)
oPrn:Say(170,0740, SM0->M0_TEL,oFont11)   

oPrn:Say(170,1080, OemToAnsi("CGC:"),oFont11N)
oPrn:Say(170,1180, TransForm(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFont11)   
oPrn:Say(170,1600, OemToAnsi("Inscr.Estadual:"),oFont11N)
oPrn:Say(170,1840, TransForm(SM0->M0_INSC,"@R 999.999.999.999"),oFont11)  

nPaginas := If(nRegistros > 21,2,1)

oPrn:Say(020,1900, OemToAnsi("Emiss�o: ")+TransForm(dDataBase,"@D"),oFont09)
oPrn:Say(050,1900, OemToAnsi("Hora: ")+Time(),oFont09) 
oPrn:Say(080,1900, OemToAnsi("Pagina ")+AllTrim(Str(nVez))+"/"+AllTrim(Str(nPaginas)),oFont09) 

oPrn:Line(200,010,200,2320) 
oPrn:Say(240,0900, OemToAnsi("Pedido de venda n� "+SC5->C5_NUM),oFont14N)
oPrn:Line(250,010,250,2320)     

//���������������������������������������������������������������������Ŀ
//� Dados do cliente                                                    �
//�����������������������������������������������������������������������  
dbSelectArea("SA1")
SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI) ))

oPrn:Say(290,010, OemToAnsi("Cliente: "),oFont11N)   
oPrn:Say(290,190, SA1->A1_NOME,oFont11)
oPrn:Say(330,010, OemToAnsi("Endere�o: ") ,oFont11N) 
oPrn:Say(330,190, AllTrim(SA1->A1_END)+" - "+AllTrim(SA1->A1_BAIRRO) ,oFont11)
oPrn:Say(370,010, OemToAnsi("Cep:"),oFont11N)
oPrn:Say(370,190, TransForm(SA1->A1_CEP,"@R 99999-999")+" - "+AllTrim(SA1->A1_MUN)+" - "+AllTrim(SA1->A1_EST),oFont11)
oPrn:Say(410,010, OemToAnsi("Tel:"),oFont11N)
oPrn:Say(410,190, AllTrim(SA1->A1_DDD)+" - "+TransForm(SA1->A1_TEL,"@R 9999-9999"),oFont11)   

//���������������������������������������������������������������������Ŀ
//� Dados do Pedido                                                     �
//�����������������������������������������������������������������������  
oPrn:Line(440,010,440,2320) 
oPrn:Say(480,0980, OemToAnsi("Dados do Pedido"),oFont14N)
oPrn:Line(490,010,490,2320)  
                               
oPrn:Say(530,0010, OemToAnsi("Pedido: "),oFont11N)   
oPrn:Say(530,0250, SC5->C5_NUM,oFont11) 
oPrn:Say(530,1500, OemToAnsi("Emiss�o: "),oFont11N)   
oPrn:Say(530,1680, TransForm(SC5->C5_EMISSAO,"@D"),oFont11)
oPrn:Say(570,0010, OemToAnsi("Cond. Pagto: ") ,oFont11N) 
oPrn:Say(570,0250, AllTrim(SC5->C5_CONDPAG)+" - "+Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI") ,oFont11) 
oPrn:Say(570,1500, OemToAnsi("Vendedor: ") ,oFont11N) 
oPrn:Say(570,1680, AllTrim(SC5->C5_VEND1)+" - "+Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME") ,oFont11)
oPrn:Say(610,0010, OemToAnsi("Transportadora: "),oFont11N)
oPrn:Say(610,0250, AllTrim(SC5->C5_TRANSP)+" - "+Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME"),oFont11)
oPrn:Say(610,1500, OemToAnsi("Frete:"),oFont11N)
oPrn:Say(610,1680, If(SC5->C5_TPFRETE=="F","FOB","CIF"),oFont11)   

//���������������������������������������������������������������������Ŀ
//� Itens do Pedido                                                     �
//�����������������������������������������������������������������������  
oPrn:Line(640,010,640,2320) 
oPrn:Say(680,0980, OemToAnsi("Itens do Pedido"),oFont14N)
oPrn:Line(690,010,690,2320)  

oPrn:Say(730,0010, OemToAnsi("C�digo"),oFont11N) 
oPrn:Say(730,0200, OemToAnsi("Descri��o"),oFont11N) 
oPrn:Say(730,1000, OemToAnsi("Quantidade"),oFont11N)  
oPrn:Say(730,1300, OemToAnsi("Unit�rio"),oFont11N) 
oPrn:Say(730,1500, OemToAnsi("% Desconto"),oFont11N)  
oPrn:Say(730,1750, OemToAnsi("Vl. Total"),oFont11N)  
oPrn:Say(730,1950, OemToAnsi("Entrega"),oFont11N)  
oPrn:Say(730,2250, OemToAnsi("Peso"),oFont11N)    

If nVez == 1 

	//���������������������������������������������������������������������Ŀ
	//� Totais                                                              �
	//�����������������������������������������������������������������������  
	oPrn:Line(1800,010,1800,2320) 
	oPrn:Say(1840,0980, OemToAnsi("Total"),oFont14N)
	oPrn:Line(1850,010,1850,2320)   
	
	oPrn:Say(1890,0010, OemToAnsi("Base ICMS"),oFont11N) 
	oPrn:Say(1930,0010, TransForm(nBaseICM,"@E 9,999,999.99"),oFont11) 
	oPrn:Say(1890,0396, OemToAnsi("ICMS"),oFont11N)
	oPrn:Say(1930,0396, TransForm(nValICMS,"@E 9,999,999.99"),oFont11) 
	oPrn:Say(1890,0782, OemToAnsi("Subs.Tributaria"),oFont11N) 
	oPrn:Say(1930,0782, TransForm(nValICMSST,"@E 9,999,999.99"),oFont11) 
	oPrn:Say(1890,1168, OemToAnsi("Desconto"),oFont11N) 
	oPrn:Say(1930,1168, TransForm(nDesconto,"@E 9,999,999.99"),oFont11) 
	oPrn:Say(1890,1554, OemToAnsi("Valor Mercadoria"),oFont11N) 
	oPrn:Say(1930,1554, TransForm(nValProd,"@E 9,999,999.99"),oFont11) 
	oPrn:Say(1890,1940, OemToAnsi("Valor Total"),oFont11N) 
	oPrn:Say(1930,1940, TransForm(nTotal-(SC5->C5_X_TBO1+SC5->C5_X_TBO2),"@E 9,999,999.99"),oFont11)   
	
	oPrn:Say(1990,0010, OemToAnsi("Frete"),oFont11N) 
	oPrn:Say(2030,0010, TransForm(nFrete,"@E 9,999,999.99"),oFont11) 
	oPrn:Say(1990,0396, OemToAnsi("Peso Liquido"),oFont11N) 
	oPrn:Say(2030,0396, TransForm(nPeso,"@E 9,999,999.99"),oFont11) 
	oPrn:Say(1990,0782, OemToAnsi("Peso Bruto"),oFont11N)  
	oPrn:Say(2030,0782, TransForm(nPeso,"@E 9,999,999.99"),oFont11)
	oPrn:Say(1990,1168, OemToAnsi("Volumes"),oFont11N) 
	oPrn:Say(2030,1168, TransForm(nVolume,"@E 9,999,999.99"),oFont11)
	oPrn:Say(1990,1554, OemToAnsi("Bonif.Cliente"),oFont11N)
	oPrn:Say(2030,1554, TransForm(SC5->C5_X_TBO1,"@E 9,999,999.99"),oFont11) 
	oPrn:Say(1990,1940, OemToAnsi("Bonif.Vendedor"),oFont11N) 
	oPrn:Say(2030,1940, TransForm(SC5->C5_X_TBO2,"@E 9,999,999.99"),oFont11)  
	
	//���������������������������������������������������������������������Ŀ
	//� Observacoes                                                         �
	//�����������������������������������������������������������������������   
	aVenctos := Condicao((nTotal-(SC5->C5_X_TBO1+SC5->C5_X_TBO2)),SC5->C5_CONDPAG)  
	
	cCondicao := "Condi��o de pagamento valida para "+TransForm(dDataBase,"@D")+". Venctos: " 
	For nX := 1 To Len(aVenctos)
		cCondicao += TransForm(aVenctos[nX,1],"@D")+" R$ "+AllTrim(TransForm(aVenctos[nX,2],"@E 999,999,999.99"))+"; "
	Next nX 
	cCondicao := SubStr(cCondicao,1,Len(cCondicao)-1)
	cCondicao += " - "+SC5->C5_MENNOTA
	
	oPrn:Line(2100,010,2100,2320) 
	oPrn:Say(2140,0980, OemToAnsi("Observa��es"),oFont14N)
	oPrn:Line(2150,010,2150,2320)              
	
	oPrn:Box(2160,010,2600,2320)
	oPrn:Say(2200,020, SubStr(cCondicao,1,140),oFont10C) 
	If Len(cCondicao) > 140 
		oPrn:Say(2240,020, SubStr(cCondicao,141,140),oFont10C) 
	EndIf 
	If Len(cCondicao) > 280 
		oPrn:Say(2280,020, SubStr(cCondicao,281,140),oFont10C) 
	EndIf
	If Len(cCondicao) > 420 
		oPrn:Say(2320,020, SubStr(cCondicao,421,140),oFont10C) 
	EndIf
	                                                                 
	oPrn:Line(3000,010,3000,0800) 
	oPrn:Say(3040,010, SA1->A1_NOME,oFont11N)  
	
	oPrn:Line(3000,1100,3000,1890) 
	oPrn:Say(3040,1100, SM0->M0_NOME,oFont11N)

EndIf


Return Nil


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ma415Impos� Autor � Anderson Goncalves � Data �  25/11/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Verificacao dos impostos                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GoldHair                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/  

Static Function Ma415Impos()

//���������������������������������������������������������������������Ŀ
//� Variaveis da Rotina                                                 �
//�����������������������������������������������������������������������
Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aAreaSC5 	:= SC5->(GetArea())
Local aAreaSC6	:= SC6->(GetArea())
Local aTitles   := {"Nota Fiscal","Duplicatas","Rentabilidade"} //"Nota Fiscal"###"Duplicatas###"Rentabilidade"
Local aDupl     := {}
Local aFlHead   := {"Vencimento","Valor" } //"Vencimento"###"Valor"
Local aVencto   := {}
Local aRFHead   := { RetTitle("C6_PRODUTO"),RetTitle("C6_VALOR"),"C.M.V","Vlr.Presente","Lucro Bruto","Margem de Contribui��o(%)"}//"C.M.V"###"Vlr.Presente"###"Lucro Bruto"###"Margem de Contribui��o(%)"
Local aRentab   := {}
Local nX        := 0
Local nAcerto   := 0
Local nPrcLista := 0
Local nValMerc  := 0
Local nDesconto := 0
Local nAcresFin := 0
Local nQtdPeso  := 0
Local nItem     := 0
Local cParc     := ""
Local dDataCnd  := SC5->C5_EMISSAO
Local lCondVenda := .F.  // Template GEM - Se existe condicao de venda
Local oDlg
Local oDupl
Local oFolder
Local oRentab
//���������������������������������������������Ŀ
//�Posiciona Registros                          �
//�����������������������������������������������
dbSelectArea("SA1")
dbSetOrder(1)
MsSeek(xFilial("SA1")+If(!Empty(SC5->C5_CLIENT),SC5->C5_CLIENT,SC5->C5_CLIENTE)+SC5->C5_LOJAENT)

dbSelectArea("SE4")
dbSetOrder(1)
MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)

//���������������������������������������������Ŀ
//�Inicializa a funcao fiscal                   �
//�����������������������������������������������
MaFisSave()
MaFisEnd()
MaFisIni(Iif(Empty(SC5->C5_CLIENT),SC5->C5_CLIENTE,SC5->C5_CLIENT),;// 1-Codigo Cliente/Fornecedor
	SC5->C5_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
	"C",;				// 3-C:Cliente , F:Fornecedor
	"N",;				// 4-Tipo da NF
	SA1->A1_TIPO,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")

//Na argentina o calculo de impostos depende da serie.
If cPaisLoc == 'ARG'
	MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
Endif

//���������������������������������������������Ŀ
//�Agrega os itens para a funcao fiscal         �
//�����������������������������������������������
dbSelectArea("SC6")
SC6->(dbSetOrder(1))
SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM ))
While SC6->(!Eof()) .and. SC5->(C5_FILIAL+C5_NUM) == SC6->(C6_FILIAL+C6_NUM) 
	//������������������������������������������������������Ŀ
	//� Verifica se a linha foi deletada                     �
	//��������������������������������������������������������
	If !Empty(SC6->C6_PRODUTO)
		//���������������������������������������������Ŀ
		//�Posiciona Registros                          �
		//�����������������������������������������������			
		SB1->(dbSetOrder(1))
		If SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			nQtdPeso := SC6->C6_QTDVEN*SB1->B1_PESO 
			nPeso += nQtdPeso
		EndIf    
		
		nVolume += SC6->C6_QTDVEN 
		
	    SB2->(dbSetOrder(1))
	    SB2->(MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL))
	    SF4->(dbSetOrder(1))
	    SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))
		//���������������������������������������������Ŀ
		//�Calcula o preco de lista                     �
		//�����������������������������������������������
		nValMerc  := SC6->C6_VALOR
		nPrcLista := SC6->C6_PRUNIT
		nQtdPeso  := 0
		nItem++
		If ( nPrcLista == 0 )
			nPrcLista := A410Arred(nValMerc/SC6->C6_QTDVEN,"C6_PRCVEN")
		EndIf
		nAcresFin := A410Arred(SC6->C6_PRCVEN*SE4->E4_ACRSFIN/100,"D2_PRCVEN")
		nValMerc  += A410Arred(nAcresFin*SC6->C6_QTDVEN,"D2_TOTAL")
		nDesconto := A410Arred(nPrcLista*SC6->C6_QTDVEN,"D2_DESCON")-nValMerc
		nDesconto := IIf(nDesconto==0,SC6->C6_VALDESC,nDesconto)
		nDesconto := Max(0,nDesconto)
		nPrcLista += nAcresFin
		
		//Para os outros paises, este tratamento e feito no programas que calculam os impostos.
		If cPaisLoc=="BRA"
  			nValMerc  += nDesconto
		Endif
		
		//���������������������������������������������Ŀ
		//�Verifica a data de entrega para as duplicatas�
		//�����������������������������������������������
		If ( SC6->(FieldPos("C6_ENTREG"))>0 )
			If ( dDataCnd > SC6->C6_ENTREG .And. !Empty(SC6->C6_ENTREG) )
				dDataCnd := SC6->C6_ENTREG
			EndIf
		Else
			dDataCnd  := SC5->C5_EMISSAO
		EndIf
		//���������������������������������������������Ŀ
		//�Agrega os itens para a funcao fiscal         �
		//�����������������������������������������������
		MaFisAdd(SC6->C6_PRODUTO,;   	// 1-Codigo do Produto ( Obrigatorio )
			SC6->C6_TES,;	   	// 2-Codigo do TES ( Opcional )
			SC6->C6_QTDVEN,;  	// 3-Quantidade ( Obrigatorio )
			nPrcLista,;		  	// 4-Preco Unitario ( Obrigatorio )
			nDesconto,; 	// 5-Valor do Desconto ( Opcional )
			"",;	   			// 6-Numero da NF Original ( Devolucao/Benef )
			"",;				// 7-Serie da NF Original ( Devolucao/Benef )
			0,;					// 8-RecNo da NF Original no arq SD1/SD2
			0,;					// 9-Valor do Frete do Item ( Opcional )
			0,;					// 10-Valor da Despesa do item ( Opcional )
			0,;					// 11-Valor do Seguro do item ( Opcional )
			0,;					// 12-Valor do Frete Autonomo ( Opcional )
			nValMerc,;			// 13-Valor da Mercadoria ( Obrigatorio )
			0)					// 14-Valor da Embalagem ( Opiconal )
	
		SB1->(dbSetOrder(1))
		If SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))
			nQtdPeso := SC6->C6_QTDVEN*SB1->B1_PESO
		Endif	
		//���������������������������������������������Ŀ
		//�Altera peso para calcular frete              �
		//�����������������������������������������������
		MaFisAlt("IT_PESO",nQtdPeso,nItem)
		MaFisAlt("IT_PRCUNI",nPrcLista,nItem)
		MaFisAlt("IT_VALMERC",nValMerc,nItem)
	
		//���������������������������������������������Ŀ
		//�Analise da Rentabilidade                     �
		//�����������������������������������������������
		If SF4->F4_DUPLIC=="S"
			nY := aScan(aRentab,{|x| x[1] == SC6->C6_PRODUTO})
			If nY == 0
				aadd(aRenTab,{SC6->C6_PRODUTO,0,0,0,0,0})
				nY := Len(aRenTab)
			EndIf
			
			If cPaisLoc=="BRA"
				aRentab[nY][2] += (nValMerc - nDesconto)
			Else
				aRentab[nY][2] += nValMerc
			Endif			
			aRentab[nY][3] += SC6->C6_QTDVEN*SB2->B2_CM1	
		EndIf
	EndIf	
	dbSelectArea("SC6") 
	dbSkip()
EndDo
//���������������������������������������������Ŀ
//�Indica os valores do cabecalho               �
//�����������������������������������������������
MaFisAlt("NF_FRETE",SC5->C5_FRETE)
MaFisAlt("NF_SEGURO",SC5->C5_SEGURO)
MaFisAlt("NF_AUTONOMO",SC5->C5_FRETAUT)
MaFisAlt("NF_DESPESA",SC5->C5_DESPESA)
MaFisAlt("NF_DESCONTO",MaFisRet(,"NF_DESCONTO")+MaFisRet(,"NF_VALMERC")*SC5->C5_PDESCAB/100)
MaFisAlt("NF_DESCONTO",MaFisRet(,"NF_DESCONTO")+SC5->C5_DESCONT)
MaFisWrite(1)
//
// Template GEM - Gestao de Empreendimentos Imobiliarios
//
// Verifica se a condicao de pagamento tem vinculacao com uma condicao de venda
//
If ExistTemplate("GMCondPagto")
	lCondVenda := ExecTemplate("GMCondPagto",.F.,.F.,{SC5->C5_CONDPAG,} )
	If ValType("lCondVenda") # "L"
		lCondVenda := .f.
	EndIf
EndIf   

nValICMSST 	:= MaFisRet(,"NF_VALSOL")  
nValIPI		:= MaFisRet(,"NF_VALIPI") 
nValICMS	:= MaFisRet(,"NF_VALICM") 
nDesconto	:= MaFisRet(,"NF_DESCONTO")
nValProd	:= MaFisRet(,"NF_VALMERC")   
nBaseICM	:= MaFisRet(,"NF_BASEICM")      
nFrete		:= MaFisRet(,"NF_FRETE")
nTotal 		:= (nValICMSST+nValIPI+nValProd)-nDesconto

MaFisEnd()
MaFisRestore()

RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSA1)
RestArea(aArea)

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EnvMail   � Autor � Anderson Goncalves � Data �  21/11/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Envia Email ao Cliente                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gold Hair                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/  

Static Function EnvMail(cArquivo)

//���������������������������������������������������������������������Ŀ
//� Variaveis da rotina                                                 �
//�����������������������������������������������������������������������
Local cEdit1 	:= Space(255)
Local cEdit2 	:= "GoldHair - Pedido de vendas n� "+SC5->C5_NUM
Local cMemo1 	:= ""
Local oEdit1	:= Nil
Local oEdit2 	:= Nil
Local oMemo1	:= Nil   
Local cHtml		:= ""
Local _oDlg 	:= Nil   

dbSelectArea("SA1")
SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI) ))

cEdit1 := AllTrim(SA1->A1_EMAIL)
cEdit1 += Space(255-Len(AllTrim(SA1->A1_EMAIL)))

//���������������������������������������������������������������������Ŀ
//� Monta interface com o usuario                                       �
//�����������������������������������������������������������������������
DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Formul�rio de Email") FROM 201,182 TO 688,968 PIXEL

@ 004,027 MsGet oEdit1 Var cEdit1 Size 317,009 COLOR CLR_BLACK PIXEL OF _oDlg
@ 004,349 Button OemtoAnsi("&Enviar") Size 037,012 PIXEL OF _oDlg Action(_oDlg:End())
@ 005,004 Say "Para:" Size 014,008 COLOR CLR_BLACK PIXEL OF _oDlg
@ 016,027 MsGet oEdit2 Var cEdit2 Size 317,009 COLOR CLR_BLACK PIXEL OF _oDlg
@ 017,004 Say "Assunto:" Size 022,008 COLOR CLR_BLACK PIXEL OF _oDlg
@ 030,004 Say "Anexos:" Size 021,008 COLOR CLR_BLACK PIXEL OF _oDlg
@ 030,027 Say cArquivo Size 317,008 COLOR CLR_BLACK PIXEL OF _oDlg
@ 042,004 Say "Observa��es" Size 033,008 COLOR CLR_BLACK PIXEL OF _oDlg
@ 054,003 GET oMemo1 Var cMemo1 MEMO Of _oDlg MULTILINE Size 383,183 COLORS 0, 16777215 HSCROLL PIXEL 

ACTIVATE MSDIALOG _oDlg CENTERED   

//���������������������������������������������������������������������Ŀ
//� Definicao do corpo do email                                         �
//�����������������������������������������������������������������������
cHtml := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'+Chr(13)+Chr(10)
cHtml += '<html xmlns="http://www.w3.org/1999/xhtml">'+Chr(13)+Chr(10)
cHtml += '<head>'+Chr(13)+Chr(10)
cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'+Chr(13)+Chr(10)
cHtml += '<title>Pedido de Vendas</title>'+Chr(13)+Chr(10)
cHtml += '<style type="text/css">'+Chr(13)+Chr(10)
cHtml += '<!--'+Chr(13)+Chr(10)
cHtml += '.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; }'+Chr(13)+Chr(10)
cHtml += '.style8 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; font-style: italic; }'+Chr(13)+Chr(10)
cHtml += '.style9 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; font-style: italic; }'+Chr(13)+Chr(10)
cHtml += '.style10 {color: #896102}'+Chr(13)+Chr(10)
cHtml += '-->'+Chr(13)+Chr(10)
cHtml += '</style>'+Chr(13)+Chr(10)
cHtml += '</head>'+Chr(13)+Chr(10)

cHtml += '<body>'+Chr(13)+Chr(10)
cHtml += '<table width="703" border="0" align="center">'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td colspan="2" bgcolor="#F8F6F7"><div align="center"><img src="https://lh5.googleusercontent.com/-4qgdM2r1w6I/UpP6WuBYZgI/AAAAAAAAAQU/RYFAapCN4ug/w440-h157/goldhair.bmp" width="329" height="120" /></div></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td colspan="2" bgcolor="#FFFFFF">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td width="61" bgcolor="#FFFFFF" class="style8">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '    <td width="632" bgcolor="#FFFFFF" class="style7"><div align="justify"><span class="style8">Prezado Cliente,</span></div></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style7"><div align="justify"><span class="style8">Para vosso conforto, voc� esta recebendo em anexo, copia do pedido de vendas solicitado em %dData%. Aguardamos vosso retorno para darmos continuidade ao tramite de fabrica��o.</span></div></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td colspan="2" bgcolor="#FFFFFF" class="style8">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8"><div align="justify">Observa��es:</div></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8"><div align="justify">'+cMemo1+'</div></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td colspan="2" bgcolor="#FFFFFF" class="style8">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style9"><div align="right" class="style10"></div></td>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8">Atenciosamente</td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style9">&nbsp;</td>'+Chr(13)+Chr(10)
cHtml += '    <td bgcolor="#FFFFFF" class="style8">'+SM0->M0_NOME+'</td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '  <tr>'+Chr(13)+Chr(10)
cHtml += '    <td colspan="2" bgcolor="#F8F6F7" class="style9"><div align="right"><span class="style10">Workflow by Totvs11 - Gold Hair</span></div></td>'+Chr(13)+Chr(10)
cHtml += '  </tr>'+Chr(13)+Chr(10)
cHtml += '</table>'+Chr(13)+Chr(10)
cHtml += '</body>'+Chr(13)+Chr(10)
cHtml += '</html>'+Chr(13)+Chr(10)

//���������������������������������������������������������������������Ŀ
//� Envia para o SendMail                                               �
//�����������������������������������������������������������������������  
Processa({|| U_SndMail2(cEdit1,cEdit2,cHtml,cArquivo,.F.)},"Enviando Email, aguarde...") //Email Destino,Assunto,Texto Html,Anexo,se eh job

Return Nil