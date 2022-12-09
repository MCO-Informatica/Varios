#Include  'Protheus.ch'
#include 'topconn.ch'
#include 'tBICONN.ch'
#include 'colors.ch'
#Define DMPAPER_A4 9


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³META1FX   ºAutor  ³Totalsiga           º Data ³  14/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºManut     ³ Bruno Daniel Abrigo em 14-03-12                            º±±
±±ºDesc.     ³ Etiqueta Metalacre Caixa                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Meta1FX()

&&TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] )
Local oFnt09b  := TFont():New( "Calibri",,9,,.T.,,,,,.f. )      	&& Tam 09
Local oFnt13b  := TFont():New( "Calibri",,13.5,,.t.,,,,,.f., )      && Tam 13.5

&&Variáveis de Posicionamento
Local x			:=-30
Local y			:=1
Local a			:=0
Local b			:=0

Local nEtiq1	:=0
Local nPosEti	:=0
Local nEtiqs	:=0
Local nQtEtiq1	:=0
Local nTotlote	:=0
Local nQtLote1	:=0
Local nlFim		:=0

Private cPerg:= "METAFX"
Private oPrint

oPrint:= TMSPrinter():New( "Etiqueta Metalacre 1" )
oPrint:Setup() 	&&Página tipo retrato
oPrint:SetPortrait() 	&&Página tipo retrato
oPrint:StartPage()		&&Inicia a Pagina
oPrint:SetpaperSize(9)  &&Papel A4


AjustaSx1(cPerg)
If !Pergunte(cPerg)
	Return
EndIf
&&_cOrdProd1:=Left(mv_par01,11)   &&Pergunta1
&&_cOrdProd:=Left(mv_par01,11)   &&Pergunta2 Bruno DAniel Abrigo em 14\03\2012
nQtlote :=MV_PAR03             &&Pergunta2

/*
-----------------------------------
Ajustes Bruno Abrigo em 15.05.12; Desc.: Campos alterados na consulta da Query para integrar com OP;
C6_QTDVEN = C2_QUANT
C6_XLACRE = C2_XLACRE
C6_NUM    = C2_NUM
C6_XEMBALA= C2_XEMBALA
C6_OPC    = C2_OPC
C6_XVOLITE= C2_XVOLITE
C6_XPBITEM= C2_XPBITEM
C6_XPLITEM= C2_XPLITEM 

C6_ENTREG = C2_DATPRF
-----------------------------------
*/
cQry:=" SELECT	ISNULL(A1_NOME,'') A1_NOME, A1_MUN, A1_EST, B1_COD, B1_DESC, "+CRLF
cQry+=" A7_CODCLI = "+CRLF
cQry+=" 		CASE  "+CRLF
cQry+=" 		WHEN C6_XCODCLI <> '' THEN C6_XCODCLI "+CRLF
cQry+=" 		WHEN C6_XCODCLI = '' THEN A7_CODCLI "+CRLF
cQry+=" 		END, "+CRLF
cQry+=" 		A7_CODFORN, A1_COD, C2_QUANT AS 'C6_QTDVEN', "+CRLF
cQry+=" C2_XLACRE AS 'C6_XLACRE', Z00_DESC, Z00_TIPO, Z00_DESC1,Z00_TMLACR,Z01_INIC,Z01_FIM,C2_NUM as 'C6_NUM' ,C6_PEDCLI, C2_XEMBALA AS 'C6_XEMBALA',C2_NUM, Z05_DESC, C2_OPC  AS 'C6_OPC', Z06_QTDMAX, Z06_OPCMAX,"+CRLF
cQry+=" Z05_PESOEM,Z06_PESOUN,C2_NUM+C2_ITEM+C2_SEQUEN LOTE, C2_ITEM, C2_QUANT, C2_XVOLITE AS 'C6_XVOLITE', C2_XPBITEM AS 'C6_XPBITEM', C2_XPLITEM AS 'C6_XPLITEM' "+CRLF

/*
cQry:=" SELECT	ISNULL(A1_NOME,'') A1_NOME, A1_MUN, A1_EST, B1_COD, B1_DESC, A7_CODCLI, A7_CODFORN, A1_COD, C6_QTDVEN, "
cQry+=" C6_XLACRE, Z00_DESC, Z00_TIPO, Z00_DESC1,Z01_INIC,Z01_FIM,C6_PEDCLI, C6_XEMBALA,C2_NUM, Z05_DESC, C6_OPC, Z06_QTDMAX, Z06_OPCMAX,"
cQry+=" Z05_PESOEM,Z06_PESOUN,C2_NUM+C2_ITEM+C2_SEQUEN LOTE, C2_ITEM, C2_QUANT, C6_XVOLITE, C6_XPBITEM, C6_XPLITEM "
*/

cQry+=" FROM "+RetSqlName("SC2")+" C2 "+CRLF
cQry+=" INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD=C2_PRODUTO AND B1.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SC6")+" C6 ON C6_NUM=C2_PEDIDO AND C6_ITEM=C2_ITEMPV AND C6.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SA1")+" A1 ON A1_COD=C2_CLI AND A1_LOJA=C2_LOJA AND A1.D_E_L_E_T_<>'*' "+CRLF
//cQry+=" LEFT  JOIN "+RetSqlName("Z06")+" Z06 ON Z06_PROD=B1_COD AND Z06_OPCMAX+'/'=C6_OPC AND Z06.D_E_L_E_T_<>'*' "      //Alterado por Tiago Gouveia conforme solicitação do Vinicius em 05/03/12
cQry+=" LEFT  JOIN "+RetSqlName("Z06")+" Z06 ON Z06_PROD=B1_COD AND Z06_COD=C2_XEMBALA AND Z06.D_E_L_E_T_<>'*' "+CRLF 
cQry+=" LEFT  JOIN "+RetSqlName("Z05")+" Z05 ON Z05_COD=Z06_EMBALA AND Z05.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SA7")+" A7 ON A7_CLIENTE=A1_COD AND A7_LOJA=A1_LOJA AND A7.D_E_L_E_T_<>'*' "+CRLF
cQry+=" LEFT  JOIN "+RetSqlName("SA7")+" A7 ON A7_CLIENTE=A1_COD AND A7_LOJA=A1_LOJA AND A7.A7_XOPC = C2_OPC AND A7.D_E_L_E_T_<>'*' AND A7.A7_PRODUTO = C2.C2_PRODUTO AND A7.A7_XLACRE IN('',C2_XLACRE) "  +CRLF
cQry+=" LEFT  JOIN "+RetSqlName("Z00")+" Z00 ON Z00_COD=C2_XLACRE AND Z00_CLI=A1_COD AND Z00.D_E_L_E_T_<>'*' "+CRLF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Bruno Daniel Abrigo acertos em 14\03\2012	- relacionamento tabelas   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
&&cQry+=" LEFT  JOIN "+RetSqlName("Z01")+" Z01 ON Z01_COD=C6_XLACRE AND Z01_PV=C6_NUM AND Z01.D_E_L_E_T_<>'*' "
cQry+=" LEFT  JOIN "+RetSqlName("Z01")+" Z01 ON Z01_COD=C2_XLACRE AND Z01_PV=C2_NUM AND C2_ITEM = Z01_ITEMPV AND Z01.D_E_L_E_T_<>'*' "+CRLF

cQry+=" WHERE C2.D_E_L_E_T_<>'*' "+CRLF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Bruno Daniel Abrigo acertos em 14\03\2012	- Ajuste Perguntas         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
&&cQry+=" AND C2_NUM+C2_ITEM+C2_SEQUEN='"+_cOrdProd+"' "
cQry+=" AND C2_NUM+C2_ITEM+C2_SEQUEN Between '"+Left(mv_par01,11) +"' and '"+Left(mv_par02,11) +"' and C2_DATPRF Between '"+DTOS(MV_PAR04)+"' and '"+DTOS(MV_PAR05)+"' "+CRLF

// Temp bruno
MemoWrite("C:\TotalSiga\Clientes\Metalacre\Fontes\Faturamento\Fontes\atualizados\Qrys\META1FX.txt", cQry)

DbUseArea( .T.,"TOPCONN",TcGenQry(,,cQry),"TRB",.T.,.T.)

TRB->(DbGoTop())
If TRB->(EOF())
	MsgInfo("Ordem de produção não localizada.")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Bruno Daniel Abrigo acertos em 14\03\2012	- Estrutura de repeticao   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !TRB->(Eof())
	
	&&Quantidade de Etiquetas
	nEtiq	:= TRB->C2_QUANT/nQtlote
	nEtiq	:= Round(nEtiq,0)
	&&Etiquetas Sobrando no Lote
	nEtiqs	:=Mod(TRB->C2_QUANT,nQtlote)
	IIf(Mod(TRB->C2_QUANT,nQtlote)<>0,nEtiq1:=1,0)
	nCaixas	:=0
	nEtiq0	:=1
	
	nEtiAtu:= TRB->Z01_INIC //Z01_FIM
	nQJaImp:= 1
	
	&&Impressão das Etiquetas conforme a Quantidade de Lacres
	For i:=1 To TRB->C6_XVOLITE//While nTotlote <= TRB->C2_QUANT
		
		
		If .T. //nQtlote1 > TRB->Z06_QTDMAX
			nTotlote+=nQtlote
			nQtlote1:=nQtlote1-nQtlote
			nlFim+= nQtlote1
			nlFim2:= nlFim/nQtlote
			nCaixas+=1
			
			LayoutMT1(oPrint,1,x,y) &&Imprime o Layout
			
			&&Informações Gerais
			oPrint:Say(y+265, x+2250,	cValtoChar(nCaixas)			,oFnt13b)
			oPrint:Say(y+565, x+435,	TRB->A1_NOME				,oFnt13b)
			oPrint:Say(y+550, x+1900,	TRB->C6_PEDCLI				,oFnt13b)
			oPrint:Say(y+655, x+600,	TRB->A7_CODFORN				,oFnt13b)
			oPrint:Say(y+655, x+1750,	TRB->A7_CODCLI				,oFnt13b)
			oPrint:Say(y+745, x+435,	TRB->Z00_DESC				,oFnt13b)
			oPrint:Say(y+745, x+1390,	TRB->C6_XLACRE				,oFnt13b)

			cTipo := ''
			If TRB->Z00_TIPO=='1'
				cTipo := 'Semi-Barreira'
			ElseIf TRB->Z00_TIPO=='2'
				cTipo := 'Sinalizacao'
			Endif                    

			oPrint:Say(y+745, x+1730,	cTipo				,oFnt13b)
			oPrint:Say(y+745, x+2220,	TRB->C2_NUM+" "+TRB->C2_ITEM	,oFnt13b)
			oPrint:Say(y+835, x+435,	TRB->A1_MUN					,oFnt13b)
			oPrint:Say(y+835, x+2250,	TRB->A1_EST					,oFnt13b)
			oPrint:Say(y+925, x+435,	TRB->B1_DESC		  		,oFnt13b)
			oPrint:Say(y+925, x+2250,	cValToChar(Year(DATE()))	,oFnt13b)
			oPrint:Say(y+1015, x+235,	""							,oFnt13b)
			nNewZ06MAX:= If(TRB->Z06_QTDMAX*nCaixas>TRB->C2_QUANT, TRB->C2_QUANT-(TRB->Z06_QTDMAX*(nCaixas-1)), TRB->Z06_QTDMAX )
			&&Quadrado separado
			oPrint:Say(y+1170,x+455,	cValtoChar(Strzero(nQJaImp,6))								,oFnt09b)
			nQJaImp+= nNewZ06MAX/MV_PAR03
			oPrint:Say(y+1170,x+1415,	cValToChar(Strzero(nQJaImp-1,6))								,oFnt09b)
			oPrint:Say(y+1250,x+335,	cValTochar(nNewZ06MAX)			 						,oFnt13b)
			oPrint:Say(y+1300,x+955,	cValToChar(nEtiAtu)											,oFnt09b)
			nEtiAtu+= nNewZ06MAX
			oPrint:Say(y+1300,x+1415,	cValToChar(nEtiAtu-1)											,oFnt09b)
			oPrint:Say(y+1390,x+595,	cValTochar(Strzero((nNewZ06MAX/MV_PAR03),6))   					,oFnt09b)
			oPrint:Say(y+1080,x+2235,	Iif(!Empty(TRB->C6_XPBITEM),cValtoChar(Round(TRB->C6_XPBITEM/TRB->C2_QUANT*nNewZ06MAX,2)),'')						,oFnt13b)
			oPrint:Say(y+1310,x+2235,	Iif(!Empty(TRB->C6_XPLITEM),cValToChar(Round(TRB->C6_XPLITEM/TRB->C2_QUANT*nNewZ06MAX,2)),'')						,oFnt13b)
			oPrint:Say(y+1390,x+1150,    TRB->Z05_DESC												,oFnt13b)
			&&Codigo de Barras
			MSBAR("CODE128",a+9.7,b+3.8,cValToChar(Strzero(nQJaImp-MV_PAR03,9))  								,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
			MSBAR("CODE128",a+9.7,b+12.2,cValTochar(Strzero(nQJaImp-1,9))								,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
			MSBAR("CODE128",a+10.8,b+7.9,cValToChar(Strzero((nEtiAtu-1-MV_PAR03),9))			,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
			MSBAR("CODE128",a+10.8,b+12.2,cValToChar(Strzero((nEtiAtu-1),9))	,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
			MSBAR("CODE128",a+11.6,b+4.8,cValTochar(Strzero((nNewZ06MAX),9))					,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
			
			
			
			nPosEti+=1
			nQtEtiq1+=nQtlote1
			nQtlote1:=nQtlote
			nEtiq0:=nlFim2+1
			
			&&Etiqueta parte superior da Pagina
			If nPosEti==2 .and. i < TRB->C6_XVOLITE
				oPrint:EndPage()
				oPrint:StartPage()
				nPosEti:=0
				x:=-30
				y:=1
				a:=0
				b:=0
				&&Etiqueta parte Inferior da Pagina
			Elseif MOD(nPosEti,2)<>0
				x:=-30
				y+=1600
				a+=13.55
			EndIf
			
		ELSE
			
			nQtlote1+=nQtlote
			nTotlote+=nQtlote
			
			&&Subtração para ajuste do total a ser impresso
			&&Impressão da penúltima etiqueta
			If nTotlote>TRB->C6_QTDVEN
				nTotlote:=nTotlote-nqtlote+nEtiqs
			EndIf
			
			If nTotlote>TRB->C6_QTDVEN
				&&Impressão da ultima Etiqueta com o Restante
				nQtlote1:=nQtlote1-nQtlote
				nQtlote1:=TRB->C6_QTDVEN-nlFim
				nlFim+= nQtlote1
				nlFim2:= Round((nlFim/nQtlote),0)
				Iif(MOD(nlFim,nQtlote)<>0,nlFim2+=1,nlFim2)
				
				nCaixas+=1
				
				LayoutMT1(oPrint,1,x,y) &&Imprime o Layout
				
				&&Informações Gerais
				oPrint:Say(y+265, x+2250,	cValtoChar(nCaixas)			,oFnt13b)
				oPrint:Say(y+565, x+435,	TRB->A1_NOME				,oFnt13b)
				oPrint:Say(y+550, x+1900,	TRB->C6_PEDCLI				,oFnt13b)
				oPrint:Say(y+655, x+600,	TRB->A7_CODFORN				,oFnt13b)
				oPrint:Say(y+655, x+1750,	TRB->A7_CODCLI				,oFnt13b)
				oPrint:Say(y+745, x+535,	TRB->Z00_DESC				,oFnt13b)
				oPrint:Say(y+745, x+1390,	TRB->C6_XLACRE				,oFnt13b)

				cTipo := ''
				If TRB->Z00_TIPO=='1'
					cTipo := 'Semi-Barreira'
				ElseIf TRB->Z00_TIPO=='2'
					cTipo := 'Sinalizacao'
				Endif                    
	
				oPrint:Say(y+745, x+1730,	cTipo				,oFnt13b)
				oPrint:Say(y+745, x+2220,	TRB->C2_NUM					,oFnt13b)
				oPrint:Say(y+835, x+435,	TRB->A1_MUN					,oFnt13b)
				oPrint:Say(y+835, x+2250,	TRB->A1_EST					,oFnt13b)
				oPrint:Say(y+925, x+435,	TRB->B1_DESC		  		,oFnt13b)
				oPrint:Say(y+925, x+2250,	cValToChar(Year(DATE()))	,oFnt13b)
				oPrint:Say(y+1015, x+235,	""							,oFnt13b)
				
				&&Quadrado separado
				oPrint:Say(y+1170,x+455,	cValtoChar(Strzero(nEtiq0,6))								,oFnt09b)
				oPrint:Say(y+1170,x+1415,	cValToChar(Strzero(nlFim2,6))								,oFnt09b)
				oPrint:Say(y+1250,x+335,	cValTochar(nQtlote1)										,oFnt13b)
				oPrint:Say(y+1300,x+955,	cValToChar(TRB->Z01_INIC+nQtEtiq1)							,oFnt09b)
				oPrint:Say(y+1300,x+1415,	cValToChar(TRB->Z01_INIC+nqtlote1+nQtEtiq1)					,oFnt09b)
				oPrint:Say(y+1390,x+595,	cValTochar(Strzero((nlFim2-nEtiq0+1),6))   					,oFnt09b)
				oPrint:Say(y+1080,x+2235,	Iif(!Empty(TRB->C6_XPBITEM),cValtoChar((TRB->C6_XPBITEM/nQtlote1)),'')						,oFnt13b)
				oPrint:Say(y+1310,x+2235,	Iif(!Empty(TRB->C6_XPLITEM),cValToChar((TRB->C6_XPLITEM/nQtLote1)),'')						,oFnt13b)
				oPrint:Say(y+1390,x+1150,    TRB->Z05_DESC												,oFnt13b)
				
				&&Codigo de Barras
				//MSBAR("CODE128",a+9.7,b+3.8,cValToChar(Strzero(nEtiq0,9))  								,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
				//MSBAR("CODE128",a+9.7,b+12.2,cValTochar(Strzero(nlFim2,9))								,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
				//MSBAR("CODE128",a+10.8,b+7.9,cValToChar(Strzero((TRB->Z01_INIC+nQtEtiq1),9))			,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
				//MSBAR("CODE128",a+10.8,b+12.2,cValToChar(Strzero((TRB->Z01_INIC+nqtlote1+nQtEtiq1),9))	,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
				//MSBAR("CODE128",a+11.6,b+4.8,cValTochar(Strzero((nlFim2-nEtiq0+1),9))					,oPrint,.F.,5,Nil,0.015,0.6,Nil,Nil,Nil,.F.)
			EndIf
			
		EndIF
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Bruno Daniel Abrigo acertos em 14\03\2012	- Estrutura de repeticao   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TRB->(dbSkip())
Enddo

&&Encerra a Pagina
oPrint:EndPage()
&&Visualiza impressão
oPrint:Preview()
&&Desativa Impressora
ms_flush()
dbCloseArea("TRB")

Return

&&Monta layout do arquivo(Meta1)
Static Function LayoutMT1(oPrint,i,x,y)


&&TFont(): New ( [ cName], [ uPar2], [ nHeight], [ uPar4], [ lBold], [ uPar6], [ uPar7], [ uPar8], [ uPar9], [ lUnderline], [ lItalic] )
Local oFnt08a	:= TFont():New( "Arial",,8,,.f.,,,,,.f. )      		&& Tam 08
Local oFnt13a	:= TFont():New( "Arial",,13,,.t.,,,,,.f.,.t. )      && Tam 13   italico
Local oFnt13c	:= TFont():New( "Calibri",,13,,.t.,,,,,.f., )  		&& Tam 13
Local oFnt13b	:= TFont():New( "Calibri",,13.5,,.t.,,,,,.f., )  	&& Tam 13.5
Local oFnt20a	:= TFont():New( "Arial",,20,,.f.,,,,,.f. )     		&& Tam 20
Local oFnt35a	:= TFont():New( "Arial Black",,35,,.t.,,,,,.f. )	&& Tam 35 - Titulo
&&X=Posição da Linha
Local x:=-30


&&Caixa Geral
&&Box - externo
oPrint:Box(y+080,x+090,y+1450,x+2400)
&&MiniBox  - interno &&Nro de Caixas
oPrint:Box(y+255,x+2190,y+345,x+2335)


&&Linhas
oPrint:Line(y+545,x+090,y+545,x+2400)   	//Linha 1
oPrint:Line(y+635,x+090,y+635,x+2400)   	//Linha 2
oPrint:Line(y+725,x+090,y+725,x+2400)   	//Linha 3
oPrint:Line(y+810,x+090,y+810,x+2400)  		//Linha 4
oPrint:Line(y+905,x+090,y+905,x+2400)   	//Linha 5
oPrint:Line(y+995,x+090,y+995,x+2400)   	//Linha 6
oPrint:Line(y+1085,x+090,y+1085,x+1665)   	//Linha 7
oPrint:Line(y+1240,x+1885,y+1240,x+2400)   	//Linha 8
&&Colunas
oPrint:Line(y+995, x+1665 ,y+1450 ,x+1665)   //Coluna 1
oPrint:Line(y+995, x+1885 ,y+1450 ,x+1885)   //Coluna 2
oPrint:Line(y+995, x+2150 ,y+1450 ,x+2150)   //Coluna 3


&&Cabeçalho &&Não alterar a disposição!!
oPrint:SayBitmap( y+170,080,"\SYSTEM\lgrl01.bmp",300,300 )
oPrint:Say(y+200, x+435,"METALACRE",oFnt35a)
oPrint:Say(y+365, x+415,"INDÚSTRIA E COMÉRCIO DE LACRES LTDA",oFnt13a)
oPrint:Say(y+135, x+1555,"METALACRE IND.COM.LACRES LTDA",oFnt13c)
oPrint:Say(y+195, x+1355,"C.N.P.J.           52.924.099/0001-11",oFnt13c)
oPrint:Say(y+195, x+2190,"Nº CX.:",oFnt13c)
oPrint:Say(y+255, x+1355,"I.E.                           336165261119",oFnt13c)


&&Informações Gerais
oPrint:Say(y+565, x+135,"CLIENTE:"			,oFnt13b)
oPrint:Say(y+550, x+1750,"PEDIDO"			,oFnt08a)
oPrint:Say(y+575, x+1750,"CLIENTE:"			,oFnt08a)
oPrint:Say(y+655, x+135,"CÓD. FORNECEDOR.:"	,oFnt13b)
oPrint:Say(y+655, x+1405,"CÓD.MATERIAL:"	,oFnt13b)
oPrint:Say(y+745, x+135,"PERSON.:"			,oFnt13b)
oPrint:Say(y+745, x+1205,"CÓDIGO:"			,oFnt13b)
oPrint:Say(y+745, x+1615,"TIPO:"			,oFnt13b)
oPrint:Say(y+745, x+2100,"O.F.:"			,oFnt13b)
oPrint:Say(y+835, x+135,"CIDADE:"			,oFnt13b)
oPrint:Say(y+835, x+1405,"VALIDADE: 2 ANOS"	,oFnt13b)
oPrint:Say(y+835, x+2135,"EST.:"			,oFnt13b)
oPrint:Say(y+925, x+135,"PRODUTO:"			,oFnt13b)
oPrint:Say(y+925, x+2135,"ANO:"				,oFnt13b)
oPrint:Say(y+1015, x+135,"N.FISCAL Nº:"		,oFnt13b)

&&Quadrado separado
oPrint:Say(y+1110,x+135,"LOTE DE:"			,oFnt13b)
oPrint:Say(y+1110,x+1115,"LOTE ATÉ:"		,oFnt13b)
oPrint:Say(y+1250,x+135,"QUANT.:"			,oFnt13b)
oPrint:Say(y+1250,x+755,"Nº INI.:"			,oFnt13b)
oPrint:Say(y+1250,x+1255,"Nº FIN.:"			,oFnt13b)
oPrint:Say(y+1340,x+135,"QTD.EMBALAGEM:"	,oFnt13b)
//oPrint:Say(y+1390,x+850,"TIPO EMBALAGEM:"   ,oFnt13b)   
oPrint:Say(y+1110,x+1675,"PESOS:"			,oFnt13b)
oPrint:Say(y+1080,x+1935,"BRUTO:"			,oFnt13b)
oPrint:Say(y+1310,x+1920,"LIQUIDO:"			,oFnt13b)

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								   ³
//³ mv_par01		 // Ordem de Produção								   ³
//³ mv_par03		 // Itens por Lote								       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function AjustaSx1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Bruno Daniel Abrigo acertos em 14\03\2012	- Ajuste perguntas		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aRegs:={}


AADD(aRegs,{cPerg,"01","Do Pedido       ?","","","mv_ch1","C",11,0,0 ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","","",""})
AADD(aRegs,{cPerg,"02","Ate o Pedido?","","","mv_ch2","C",11,0,0 ,"G","naovazio()","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC2","","","","",""})

AADD(aRegs,{cPerg,"03","Itens por Lote","","","mv_ch3","N",5,0,0 ,"G","naovazio()","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AADD(aRegs,{cPerg,"04","Dta Entreg.Inicial?","","","mv_ch4","D",8,0,0 ,"G","naovazio()","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Dta Entreg.Final  ?","","","mv_ch5","D",8,0,0 ,"G","naovazio()","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
/*
PutSx1(cPerg, "01","Ordem de Producao De?"," "," ","mv_ch1","C",11,0,0,"G","        "      , "SC2","","","mv_par01","","",""," ","","","" ,"","","","","","","",""," ")
PutSx1(cPerg, "02","Ord.de Producao Ate? "," "," ","mv_ch2","C",11,0,0,"G","        "      , "SC2","","","mv_par02","","",""," ","","","" ,"","","","","","","",""," ")
PutSx1(cPerg, "03","Itens por Lote"       ," "," ","mv_ch3","N",05,0,0,"G","        "      , "   ","","","mv_par03","","",""," ","","","" ,"","","","","","","",""," ")
PutSx1(cPerg, "04","Dta Entreg.Inicial?"  ," "," ","mv_ch4","D",08,0,0,"G","        "      , "   ","","","mv_par04","","",""," ","","","" ,"","","","","","","",""," ")
PutSx1(cPerg, "05","Dta Entreg.Final?"    ," "," ","mv_ch5","D",08,0,0,"G","        "      , "   ","","","mv_par05","","",""," ","","","" ,"","","","","","","",""," ")
*/

DbSelectArea("SX1")
SX1->(DbSetOrder(1))
SX1->(DbGotop())
if !SX1->(dbSeek(cPerg))
	For i:=1 to Len(aRegs)
		If !SX1->(dbSeek(cPerg+aRegs[i,2]))
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			SX1->(MsUnlock())
			dbCommit()
		Endif
	Next
Endif


Return

