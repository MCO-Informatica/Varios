#INCLUDE "TOPCONN.CH"
//#INCLUDE "MATR265.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RPMS003   ºAutor  ³Alexandre Sousa     º Data ³  08/27/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de listagem de orcamentos.                        º±±
±±º          ³Mostra o custo e o markup.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA.                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RPMS003()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 	:="Este relatorio tem o objetivo de listar os Orçamentos em andamento"
Local cDesc2 	:=''//STR0002	//"apos o Faturamento de uma NF ou a Criacao de uma OP caso consumam"
Local cDesc3 	:=''//STR0003	//"materiais que utilizam o controle de Localizacao Fisica"
Local cString	:="SD2"

Private a_xml		:= {}
Private tamanho	:="P"
Private cbCont,cabec1,cabec2,cbtxt
Private cPerg	:="RPMS003"
Private aOrd	:= {}
Private aReturn := {"Zebrado",1,"Administracao", 2, 2, 1, "",0 }	//"Zebrado"###"Administracao"
Private nomeprog:="RPMS003",nLastKey := 0
Private li		:=80, limite:=132, lRodape:=.F.
Private wnrel  	:= "RPMS003"
Private titulo 	:="ORÇAMENTOS DO PERÍODO"
Private cSerIni := ""
Private cSerFin := ""
Private nLin 	:= 100
Private nCol 	:= 50
Private nPula 	:= 30
Private imprp	:= .F.
Private a_cols 	:= {50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000}

Private	oFont14		:= TFont():New("Arial",,14,,.f.,,,,,.f.),;
oFont14n	:= TFont():New("Arial",,14,,.t.,,,,,.f.),;
oFont12 	:= TFont():New("Arial",,10,,.f.,,,,,.f.),;
oFont12n	:= TFont():New("Arial",,10,,.t.,,,,,.f.),;
oFont08 	:= TFont():New("Arial",,08,,.f.,,,,,.f.),;
oFont08n 	:= TFont():New("Arial",,08,,.t.,,,,,.f.),;
oFont10 	:= TFont():New("Arial",,10,,.f.,,,,,.f.),;
oPrn 		:= TMSPrinter():New()

Private	ncol1 := 350
Private	ncol2 := 650
Private	ncol3 := 850
Private	ncol4 := 1250
Private	ncol5 := 1550
Private	ncol6 := 1850
Private	ncol7 := 2100
Private	nfim  := 2350 //2470
Private	aCols := {180, 440, 1150, 1600, 1840, 2080, 2370}
Private RPMS00306 :=''
Private a_poscl := {}
Private a_posln := {}

Private a_Header:= {}
Private a_dados := {}
Private a_cpo	:= {}


DbSelectArea('SX3')
DbSetOrder(1)
DbSeek('AF1')



While SX3->(!EOF()) .and. SX3->X3_ARQUIVO = 'AF1'
	If X3Uso(SX3->X3_USADO) .and. SX3->X3_TIPO <> 'M' .and. SX3->X3_CONTEXT <> 'V'
		Aadd(a_Header,SX3->X3_TITULO )/*01*/
		Aadd(a_cpo, SX3->X3_CAMPO)
	EndIf
	SX3->(DbSkip())
EndDo

Aadd(a_Header,"CUSTO"		)/*01*/
Aadd(a_Header,"MARKUP"	)/*02*/
Aadd(a_Header,"TOTAL"	)/*03*/

Aadd(a_cpo, "AF5_CUSTO")
Aadd(a_cpo, "AF5_VALBDI")
Aadd(a_cpo, "AF5_TOTAL")

//Aadd(a_Header,"DATAORC"		)/*01*/
//Aadd(a_Header,"ORCAMENTO"	)/*02*/
//Aadd(a_Header,"DESCRICAO"	)/*03*/
//Aadd(a_Header,"CLIENTE"		)/*04*/
//Aadd(a_Header,"LOJACLI"		)/*05*/
//Aadd(a_Header,"PROSPECT"	)/*06*/
//Aadd(a_Header,"LOJAPRO"		)/*07*/
//Aadd(a_Header,"VALIDADE"	)/*08*/
//Aadd(a_Header,"TIPOORC"		)/*09*/
//Aadd(a_Header,"MIDIA"		)/*10*/
//Aadd(a_Header,"VENDEDOR"	)/*11*/
//Aadd(a_Header,"PROPOSTA"	)/*12*/
//Aadd(a_Header,"CUSTO"		)/*13*/
//Aadd(a_Header,"MARKUP"		)/*14*/
//Aadd(a_Header,"TOTAL"		)/*15*/

nLin	:= 100
nCol	:= 60
nPula	:= 60

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt   := SPACE(10)
cbcont  := 0
Li      := 80
m_pag   := 1
cabec2  := ""

cabec1  := ""// STR0007 "ENDERECO        |LOTE          |COD.NYTRON     |COD.CLIENTE       |QUANTIDADE"
//                                1         2         3         4         5         6         7         8         9        10        11        12        13        14
//                       012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
pergunte( cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01       	  Pick List   1 - NF  2 - OP                 ³
//³ mv_par02	     	  De  Nota Fiscal Venda                  ³
//³ mv_par03	     	  Ate Nota Fiscal Venda                  ³
//³ mv_par04	     	  De  Data de Entrega                    ³
//³ mv_par05	     	  Ate Data de Entrega                    ³
//³ mv_par06	     	  De  Cliente                            ³
//³ mv_par07	     	  Ate Cliente                            ³
//³ mv_par08	     	  De  Ordem de Producao                  ³
//³ mv_par09	     	  Ate Ordem de Producao                  ³
//³ mv_par10	     	  Qtd p/ impressao 1 - Original 2 - Saldo³
//³ mv_par11        Considera OPs 1- Firmes 2- Previstas 3- Ambas³
//³ mv_par12	     	  Moeda                                  ³
//³ mv_par13              Outras moedas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lista Pick-List para Nota Fiscal de Venda                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSerIni := If(cPaisLoc=="BRA",MV_PAR14,MV_PAR16)
cSerFin := If(cPaisLoc=="BRA",MV_PAR15,MV_PAR17)

Processa({||C265ImpNF()}, titulo, "Imprimindo, aguarde...")


If	( aReturn[5] == 1 ) //1-Disco, 2-Impressora
	oPrn:Preview()
Else
	oPrn:Setup()
	oPrn:Print()
EndIf

If MsgYesNo("*Deseja exportar para o Excel?")
	U_FGEN071(a_Header, a_dados)
EndIf    


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ C265ImpNF³ Autor ³ Jesus Pedro           ³ Data ³ 13.11.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Chamada do Relatorio para Pick-List da Nota Fiscal de Venda³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR265	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C265ImpNF()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local bBlock, cChaveAnt:="",cChaveDB:=""
Local lExistBlock:=ExistBlock("MR265MAIL")
Private cNfAnt := Space(6)
Private nValorNf := 0
Private n_x		 := 0

nOrdem := aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Coloca areas nas Ordens Corretas                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SD2")
dbSetOrder(1)

n_prpg := 30

n_mLin := 820

If nOrdem = 0
	nOrdem :=  1
EndIF

NPAG := 1


CabecNF("000001")


c_query := " select AF5_CUSTO, AF5_VALBDI, AF5_TOTAL, AF1_FILIAL, AF1010.* "
//'AF1_ORCAME, AF1_DATA, AF1_DESCRI, AF1_CLIENT, AF1_LOJA, AF1_XPROSP, AF1_XLOJAP, AF1_XNOMEC, AF1_VALID, AF1_FASE, AF1_CODMEM, AF1_GETTRF, AF1_TPORC, AF1_DTCONV, AF1_DELIM, AF1_MASCAR, AF1_NMAX, AF1_NMAXF3, AF1_TRUNCA, AF1_BDI, AF1_VALBDI, AF1_BDIPAD, AF1_TIPO, AF1_CODORC, AF1_RECALC, AF1_AUTCUS, AF1_CTRUSR, AF1_XMIDIA, AF1_XVEND, AF1_XDTPRP, AF1_XSTAT, AF1_XOBRA, AF1_XPROP, AF1_XENDOB, AF1_XBROBR, AF1_XMUNO, AF1_XCEPOB, AF1_XESTOB, AF1_XCOMPO, AF1_XREFOB, AF1_USERGI, AF1_USERGA, AF1_XPROJ, AF1_XDTRET, AF1_XHIST, AF1_XMTCAN, AF1_XCONTA, AF1_XEMAI1, AF1_XEMAI2, AF1_XEMAI3, AF1_XENGRE, AF1_XESTR, AF1_XTEL1, AF1_XTEL2, AF1_XTEL3, AF1_XCLASS  
c_query += " from "+RetSqlName('AF1')+" "
c_query += " inner join AF5010 "
c_query += " on    AF5_FILIAL = AF1_FILIAL "
c_query += " and   AF5_ORCAME = AF1_ORCAME "
c_query += " and   AF5_NIVEL = '001' "
c_query += " and   AF5010.D_E_L_E_T_ <> '*' "  
c_query += " and   AF1_XVEND between '"+MV_PAR06+"' and '"+MV_PAR07+"' "    
c_query += " where AF1_DATA between '"+DtoS(MV_PAR01)+"' and '"+DtoS(MV_PAR02)+"' " 
c_query += " and   AF1_MSFIL = '"+cFilAnt+"'"
c_query += " and   AF1_FILIAL = '"+xFilial('AF1')+"' "
c_query += " and   AF1010.D_E_L_E_T_ <> '*' "
c_query += " order by AF1_FASE, AF1_DATA"


If Select("QRY") > 0          
	DbSelectArea("QRY")           
	DbCloseArea()                 
EndIf                          
                                
TcQuery c_Query New Alias "QRY"

n_cont :=0 
c_fase := ''
n_totc := 0
n_totbdi := 0

While QRY->(!EOF())

	If QRY->AF1_FASE $ MV_PAR04
		fPulareg()
		Loop
	EndIf

	If !empty(MV_PAR03)
		If !(QRY->AF1_FASE $ MV_PAR03)
			fPulareg()
			Loop
		EndIf
	EndIf
	
	n_custo :=  fRetCusto(QRY->AF1_ORCAME)
	If (QRY->AF5_TOTAL) < MV_PAR05
		fPulareg()
		Loop
	EndIf

	If n_cont > 40
		CabecNF("000001")
		n_cont := 0
	EndIf

	nLin += nPula
	
    oPrn:Box(nLin-10,50,nLin+50,nfim)                 // cria a linha da data  ate o total          
    oPrn:Box(nLin-10,50,nLin+50,10+(nfim-(50))/10)    // cria a linha entre a  orçamento e o vendedor
    oPrn:Box(nLin-10,50,nLin+50,185+(nfim-(50))/10)  // cria a linha entre o orçamento e o vendedor
    oPrn:Box(nLin-10,50,nLin+50,455+(nfim-(50))/10)  // cria a linha entre o vendedor e a descricao
  	oPrn:Box(nLin-10,50,nLin+50,1160+(nfim-(50))/10) // cria a linha entre a  descricao e a fase 
	oPrn:Box(nLin-10,50,nLin+50,1550+(nfim-(50))/10) // cria a linha entre a a faste e o custo
 	oPrn:Box(nLin-10,50,nLin+50,1750+(nfim-(50))/10) // cria a linha entre o custo e markup  
 	oPrn:Box(nLin-10,50,nLin+50,1935+(nfim-(50))/10)  

	c_imp := DtoC(stod(QRY->AF1_DATA))            //data 
	oPrn:Say(nLin,nCol,c_imp,oFont08,100)
	                                                                                      
	c_imp := QRY->AF1_ORCAME
	oPrn:Say(nLin,5+nCol+aCols[1],c_imp,oFont08,100)    // orcamento  
	

//	c_imp := Left(Posicione('SA3',1,QRY->AF1_MSFIL+QRY->AF1_XVEND,'A3_NOME'),12)
//  oPrn:Say(nLin,aCols[2],c_imp,oFont08,100)                            
	
  	c_imp :=Left(GetAdvFval('SA3','A3_NOME',QRY->AF1_MSFIL+QRY->AF1_XVEND),11,'-')
	oPrn:Say(nLin,aCols[2],c_imp,oFont08,100)                            
	
	c_imp := SubStr(QRY->AF1_DESCRI, 1,35)               //descricao
	oPrn:Say(nLin,265+aCols[2],c_imp,oFont08,100)
	
	c_imp := QRY->AF1_FASE + "-"+GetAdvFval('AE9', 'AE9_DESCRI', xFilial('AE9')+QRY->AF1_FASE, 1,'-')    //fase
	oPrn:Say(nLin,245+aCols[3],c_imp,oFont08,100)
                                                                                                  

	c_imp := transform(QRY->AF5_CUSTO, '@E 999,999,999.99')           //custo
	oPrn:Say(nLin,175+aCols[4],c_imp,oFont08,100)

	c_imp := transform(QRY->AF5_VALBDI, '@E 999,999,999.99')          // markup
	oPrn:Say(nLin,135+aCols[5],c_imp,oFont08,100)

	c_imp := transform(QRY->AF5_TOTAL, '@E 999,999,999.99')           //total
	oPrn:Say(nLin,80+aCols[6],c_imp,oFont08,100)

	n_totc += n_custo
	n_totbdi += QRY->AF1_VALBDI
	n_cont++

	a_tmp := {}                                  
	
	For n_x:=1 to len(a_cpo)
		If type('QRY->'+a_cpo[n_x]) = 'N'
			Aadd(a_tmp, transform(QRY->&(a_cpo[n_x]), '@E 999,999,999.99'))
//		ElseIf type('QRY->'+a_cpo[n_x]) = 'D'
//			Aadd(a_tmp, QRY->&(a_cpo[n_x]))
		Else
			Aadd(a_tmp, QRY->&(a_cpo[n_x]))
		EndIf
	Next

//	Aadd(a_dados, {DtoC(StoD(QRY->AF1_DATA)), QRY->AF1_ORCAME, QRY->AF1_DESCRI, QRY->AF1_CLIENT, QRY->AF1_LOJA, QRY->AF1_XPROSP, QRY->AF1_XLOJAP,;
//					DtoC(StoD(QRY->AF1_VALID)), QRY->AF1_TPORC, QRY->AF1_XMIDIA, QRY->AF1_XVEND, DtoC(StoD(QRY->AF1_XDTPRP)),;
//					transform(n_custo, '@E 999,999,999.99'), transform(QRY->AF1_VALBDI, '@E 999,999,999.99'), transform(n_custo + QRY->AF1_VALBDI, '@E 999,999,999.99')})
	Aadd(a_dados, a_tmp)

	fPulareg()

EndDo


If aReturn[5] = 1
	dbCommitAll()
Endif

MS_FLUSH()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ CabecNF  ³ Autor ³ Jesus Pedro           ³ Data ³ 13.11.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Imprime o cabecalho do relatorio por PV                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR265	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CabecNF(c_cod)

Local aArea := GetArea()
Local cTxt := ""
nLin	:= 100
nCol	:= 60
nPula	:= 60

oPrn:EndPage()
//////////////////////////////////////////////////////////////////////////CABECARIO///////////////////

If Li > 55
	
	oPrn:Say(nLin,800,Titulo,oFont14n,100)
	oPrn:Box(50,50,200,nfim)
	
	oPrn:Box(50,50,200,nfim-360)
	
	oPrn:Say(060,2000,"Folha....: " + str(NPAG),oFont12,100)
	oPrn:Say(090,2000,"DT.Emiss.: " + dtoc(date()),oFont12,100)
//	oPrn:Say(120,2040,"DT.Fatur..: " + dtoc(SF2->F2_EMISSAO),oFont12,100)
	
	nLin += nPula
	nLin += nPula
	nLin += nPula
//	oPrn:Box(nLin-10,50,nLin+50,nfim)
//	oPrn:Box(nLin-10,50,nLin+50,400)
	
	
//	nLin += nPula
//	nLin += nPula
	
	//colunas do cabecario 
	
	
    oPrn:Box(nLin-10,50,nLin+50,nfim)                 // cria a maior coluna desde a data ate o total
 	oPrn:Box(nLin-10,50,nLin+50,(nfim-(50))/10)      // cria a linha entre a  data e o orcamento
 	oPrn:Box(nLin-10,50,nLin+50,200+(nfim-(50))/10)
 	oPrn:Box(nLin-10,50,nLin+50,455+(nfim-(50))/10)    // cria a linha entre o orcamento e a descricao
 	oPrn:Box(nLin-10,50,nLin+50,1160+(nfim-(50))/10)    // cria a linha entre a descricao e a fase
  //	oPrn:Box(nLin-10,50,nLin+50,6*(nfim-(50))/10)    
	oPrn:Box(nLin-10,50,nLin+50,1550+(nfim-(50))/10)     // cria a linha entre a fase e o custo
	oPrn:Box(nLin-10,50,nLin+50,1760+(nfim-(50))/10)      // cria a linha entre o custo e o markup
	oPrn:Box(nLin-10,50,nLin+50,1935+(nfim-(50))/10)      // cria a linha entre o markup e o total
	
	c_imp := "DATA"
	oPrn:Say(nLin,nCol,c_imp,oFont08n,100)
	
	c_imp := "ORÇAMENTO"
	oPrn:Say(nLin,nCol+aCols[1],c_imp,oFont08n,100) 
	
	c_imp := "VENDEDOR"
	oPrn:Say(nLin,15+aCols[2],c_imp,oFont08n,100)
		
	c_imp := "DESCRIÇÃO"
	oPrn:Say(nLin,265+aCols[2],c_imp,oFont08n,100)
	
	c_imp := "FASE"
	oPrn:Say(nLin,245+aCols[3],c_imp,oFont08n,100)
	
	c_imp := "CUSTO"
	oPrn:Say(nLin,195+aCols[4],c_imp,oFont08n,100)
	
	c_imp := "MARKUP"
	oPrn:Say(nLin,155+aCols[5],c_imp,oFont08n,100)

	c_imp := "TOTAL"
	oPrn:Say(nLin,115+aCols[6],c_imp,oFont08n,100)

	nLin += nPula
	imprp	:= .T.
	
Endif

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ DetalheNF³ Autor ³ Jesus Pedro           ³ Data ³ 13.11.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Imprime o detalhe da Nota Fiscal de Venda                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR265	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DetalheNF(Tamanho)
//	@ Li,016 PSAY SD2->D2_LOTECTL			Picture PesqPict("SD2","D2_LOTECTL",10)
//	@ Li,030 PSAY SD2->D2_COD				Picture PesqPict("SD2","D2_COD",15)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ C265ImpOP³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 14.04.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Chamada do Relatorio para Pick-List da Ordem de Producao   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR265	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C265ImpOP( lEnd, tamanho, titulo, wnRel )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cChave,cCompara
PRIVATE cOpAnt := Space(11)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Coloca areas nas Ordens Corretas                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SD4")
dbSetOrder(2)

dbSelectArea("SDC")
dbSetOrder(2)

dbSelectArea("SC2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta filtro e indice da IndRegua                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndex:=IndexKey()

cExpres:='C2_FILIAL=="'+xFilial()+'".And.'
cExpres+='C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD>="'+mv_par08+'".And.'
cExpres+='C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD<="'+mv_par09+'".And.'
cExpres+='DTOS(C2_DATPRF)>="'+DTOS(mv_par04)+'".And.'
cExpres+='DTOS(C2_DATPRF)<="'+DTOS(mv_par05)+'"'

cSC2ntx := CriaTrab(,.F.)
//IndRegua("SC2", cSC2ntx, cIndex,,cExpres,STR0010)	//"Selecionando Registros ..."
nIndex := RetIndex("SC2")
#IFNDEF TOP
	dbSetIndex(cSC2ntx+OrdBagExt())
#ENDIF
dbSetOrder( nIndex+1 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero de registros validos para a SetRegua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbGoTop()
//SetRegua(LastRec())

cChaveAnt := "????????????????"

While !Eof()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o usuario interrompeu o relatorio                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	If !MtrAvalOp(mv_par11)
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SB1")
	dbSeek(xFilial()+SC2->C2_PRODUTO)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lista o cabecalho da Ordem de Producao                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CabecOP(Tamanho)
	
	dbSelectArea("SD4")
	dbSeek(xFilial()+cOPAnt)
	While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOpAnt
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Lista o detalhe da ordem de producao                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CabecOP(Tamanho)
		DetalheOP(Tamanho)
		If Localiza(SD4->D4_COD)
			dbSelectArea("SDC")
			cChave := ''
			If Rastro(SD4->D4_COD)
				cChave:=xFilial()+SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL+SD4->D4_NUMLOTE
				cCompara:="DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE"
			ElseIf !Rastro(SD4->D4_COD)
				cChave:=xFilial()+SD4->D4_COD+SD4->D4_LOCAL+SD4->D4_OP+SD4->D4_TRT
				cCompara:="DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT"
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Varre composicao do empenho                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cChave) .AND. dbSeek(cChave)
				Do While !Eof() .And. cChave == &(cCompara)
					CabecOP(Tamanho)
					@ Li,016 PSAY DC_LOTECTL	Picture PesqPict("SDC","DC_LOTECTL",10)
					//					@ Li,61 PSAY DC_NUMLOTE	Picture PesqPict("SDC","DC_NUMLOTE",6)
					@ Li,000 PSAY DC_LOCALIZ Picture PesqPict("SDC","DC_LOCALIZ",15)
					//					@ Li,86 PSAY DC_NUMSERI Picture PesqPict("SDC","DC_NUMSERI",20)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Lista quantidade de acordo com o parametro selecionado        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If mv_par10 == 1
						@ Li,064 PSAY DC_QTDORIG Picture PesqPictQt("DC_QTDORIG",14)
						//						@ li,122 PSAY SD4->D4_DTVALID Picture PesqPict("SD4","D4_DTVALID",10)
						//						@ li,136 PSAY SD4->D4_POTENCI Picture PesqPictQt("D4_POTENCI", 14)
					Else
						@ Li,064 PSAY DC_QUANT Picture PesqPictQt("DC_QUANT",14)
						//					@ li,122 PSAY SD4->D4_DTVALID Picture PesqPict("SD4","D4_DTVALID",10)
						//						@ li,136 PSAY SD4->D4_POTENCI Picture PesqPictQt("D4_POTENCI", 14)
					EndIf
					Li++
					dbSkip()
				EndDo
			Else
				@ Li,064 PSAY SD4->D4_QUANT Picture PesqPictQt("D4_QUANT",14)
			EndIf
		Else
			@ Li,064 PSAY SD4->D4_QUANT Picture PesqPictQt("D4_QUANT",14)
			//			@ li,122 PSAY SD4->D4_DTVALID Picture PesqPict("SD4","D4_DTVALID",10)
			//			@ li,136 PSAY SD4->D4_POTENCI Picture PesqPictQt("D4_POTENCI", 14)
		EndIf
		Li++
		dbSelectArea("SD4")
		dbSkip()
	EndDo
	dbSelectArea("SC2")
	dbSkip()
EndDo

If Li != 80
	roda(cbcont,cbtxt,tamanho)
EndIf

dbSelectArea("SC2")
RetIndex("SC2")
Ferase(cSC2ntx+OrdBagExt())

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ CabecOP  ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 14.04.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Imprime o cabecalho do relatorio por Ordem de Producao     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR265	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ DetalheOP³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 14.04.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Imprime o detalhe da Ordem de Producao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR265	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DetalheOP(Tamanho)
Local cAlias:=Alias()
//@ Li,16 PSAY Left(SB1->B1_DESC,30)	Picture PesqPict("SB1","B1_DESC",30)
//@ Li,47 PSAY SB1->B1_UM					Picture PesqPict("SB1","B1_UM",2)
If !Localiza(SD4->D4_COD)
	@ Li,016 PSAY SD4->D4_LOTECTL	Picture PesqPict("SD4","D4_LOTECTL",10)
	//	@ Li,61 PSAY SD4->D4_NUMLOTE	Picture PesqPict("SD4","D4_NUMLOTE",6)
EndIf
dbSelectArea("SB1")
dbSeek(xFilial()+SD4->D4_COD)
@ Li,030 PSAY SD4->D4_COD				Picture PesqPict("SD4","D4_COD",15)

dbSelectArea(cAlias)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ CabecRem ³ Autor ³ Guilherme C. Leal     ³ Data ³ 18.04.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Cabecalho/Encabezado/Header				                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR265	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³DetalheRem³ Autor ³ Guilherme C. Leal     ³ Data ³ 18.04.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Detalhe do Remito/Detalle del Remito/Remito Detail         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR265	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DetalheRem(Tamanho)
//@ Li,16 PSAY Left(SB1->B1_DESC,30)		Picture PesqPict("SB1","B1_DESC",30)
//@ Li,47 PSAY SB1->B1_UM				Picture PesqPict("SB1","B1_UM",2)
@ Li,016 PSAY SD2->D2_LOTECTL			Picture PesqPict("SD2","D2_LOTECTL",10)
@ Li,030 PSAY SD2->D2_COD			Picture PesqPict("SD2","D2_COD",15)

//@ Li,61 PSAY SD2->D2_NUMLOTE			Picture PesqPict("SD2","D2_NUMLOTE",6)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Alexandre Lemes     º Data ³ 18/12/2003  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR600 AP7                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local cSeq		:= '01'
Local cCH		:= "mv_ch1"
Local cPAR		:= "MV_PAR01"

cPerg := padr(cPerg, 10)

PutSX1(cPerg,cSeq,"Data De?","","",cCH,"D",8,0,0,"G","","","","S",cPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
/*------------------------------------*/
cSeq := Soma1(cSeq)
cCH  := Soma1(cCH)
cPAR := Soma1(cPAR)
aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
//
//Aadd(aHelpPor,"Serie final a ser considerada na       ")
//Aadd(aHelpPor,"filtragem do cadastro de notas fiscais.")
//
//Aadd(aHelpSpa,"Serie final a considerarse en la       ")
//Aadd(aHelpSpa,"filtracion del archivo de facturas.    ")
//
//Aadd(aHelpEng,"Final serie to be considered in the    ")
//Aadd(aHelpEng,"filtering of invoices file.            ")
//
PutSX1(cPerg,cSeq,"Data Ate?","","",cCH,"D",8,0,0,"G","","","","S",cPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
cSeq := Soma1(cSeq)
cCH  := Soma1(cCH)
cPAR := Soma1(cPAR)
Aadd(aHelpPor,"Informe as fases do ORÇAMENTO que deseja ")
Aadd(aHelpPor,"imprimir Ex.: 01/02/03/04              ")
PutSX1(cPerg,cSeq,"Imprimir Fase","","",cCH,"C",40,0,0,"G","","","","S",cPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

cSeq := Soma1(cSeq)
cCH  := Soma1(cCH)
cPAR := Soma1(cPAR)
aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
Aadd(aHelpPor,"Informe as fases do ORÇAMENTO que deseja ")
Aadd(aHelpPor,"que nao sejam impressas Ex.: 01/02/03  ") 

PutSX1(cPerg,cSeq,"Nao imprimir Fase","","",cCH,"C",40,0,0,"G","","","","S",cPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

cSeq := Soma1(cSeq)
cCH  := Soma1(cCH)
cPAR := Soma1(cPAR)
aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
Aadd(aHelpPor,"Informe o valor desejado para que os   ")
Aadd(aHelpPor,"ORCAMENTOS impressos sejam maiores ou    ")
Aadd(aHelpPor,"iguais a este valor.                   ")
PutSX1(cPerg,cSeq,"Custo Maior que ? ","","",cCH,"N",12,2,0,"G","","","","S",cPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
 

cSeq := Soma1(cSeq)
cCH  := Soma1(cCH)
cPAR := Soma1(cPAR)
aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
Aadd(aHelpPor,"Informe o numero do vendedor")
Aadd(aHelpPor,"Caso não apareça as opções de vendedor")
Aadd(aHelpPor,"Retire os numeros do campo ")
Aadd(aHelpPor,"e clique na Lupa")
//PutSX1(cPerg,cSeq,"Custo Maior que ? ","","",cCH,"N",12,2,0,"G","","","","S",cPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//      cGrupo 	cOrde 	cDesPor	  cDesSpa	cDesEng cVar	cTipo 	cTamanho	cDecimal	nPreSel		cGSC	cValid	cF3	cGrpSXG	cPyme   	cVar01		cDef1Por	cDef1Spa	cDef1Eng	cCnt01	cDef2Por	cDef2Spa	cDef2Eng	cDef3Por	cDef3Spa	cDef3Eng	cDef4Por	cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp) 

PutSX1(cPerg,cSeq,"Do vendedor?",""         ,""   ,cCH     ,"C"    ,6         ,0         ,0           ,"G"     ,""    ,"SA3" ,""     ,"S"    ,cPAR    ,""         ,""        ,""          ,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
                                                              
cSeq := Soma1(cSeq)                         
cCH  := Soma1(cCH)                                                        
cPAR := Soma1(cPAR)                                                                                      
aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
Aadd(aHelpPor,"Informe o numero do Vendedor ")
Aadd(aHelpPor,"Caso não apareça as opções de vendedor ")
Aadd(aHelpPor,"Retire os numeros do campo ")
Aadd(aHelpPor,"e clique na Lupa")
//PutSX1(cPerg,cSeq,"Custo Maior que ? ","","",cCH,"N",12,2,0,"G","","","","S",cPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//      cGrupo 	cOrde 	cDesPor	  cDesSpa	cDesEng cVar	cTipo 	cTamanho	cDecimal	nPreSel		cGSC	cValid	cF3	cGrpSXG	cPyme	cVar01		cDef1Por	cDef1Spa	cDef1Eng	cCnt01	cDef2Por	cDef2Spa	cDef2Eng	cDef3Por	cDef3Spa	cDef3Eng	cDef4Por	cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp) 

PutSX1(cPerg,cSeq,"Ate o vendedor?",""   ,""        ,cCH	 ,"C"     ,6       ,0         ,0             ,"G"     ,""   ,"SA3" ,""     ,"S"    ,cPAR    ,""         ,""        ,""          ,"","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return




Static Function fRetCusto(c_prj)                                                                                                                                                    	

Local n_Ret := 0

c_query := " select * from "+RetSqlName('AF5')+" "
c_query += " where AF5_ORCAME = '"+c_prj+"' "
c_query += " and   D_E_L_E_T_ <> '*' "
c_query += " and   AF5_NIVEL = '001' "
c_query += " and   AF5_FILIAL = '"+xFilial('AFC')+"' "


If Select("TRP") > 0          
	DbSelectArea("TRP")
	DbCloseArea()                 
EndIf                          
                                
TcQuery c_Query New Alias "TRP"

If TRP->(!EOF())
	n_Ret := TRP->AF5_CUSTO
EndIf


Return n_Ret



Static Function fPulareg()

	c_fase := QRY->AF1_FASE
	QRY->(DBSKIP())
	
	If c_fase <> QRY->AF1_FASE .and. n_totc + n_totbdi > 0
		nLin += nPula
		                          //  ultima linha //linha dos totais
		oPrn:Box(nLin-10,50,nLin+50,nfim)
//		oPrn:Box(nLin-10,50,nLin+50,(nfim-(50))/10)
//		oPrn:Box(nLin-10,50,nLin+50,2*(nfim-(50))/10)
//		oPrn:Box(nLin-10,50,nLin+50,5*(nfim-(50))/10)
		oPrn:Box(nLin-10,50,nLin+50,1500+(nfim-(50))/10) //custo
		oPrn:Box(nLin-10,50,nLin+50,1700+(nfim-(50))/10) //markup
		oPrn:Box(nLin-10,50,nLin+50,1900+(nfim-(50))/10) //total
		
		c_imp := "TOTAL DA FASE: " + c_fase+ "-"+GetAdvFval('AE9', 'AE9_DESCRI', xFilial('AE9')+c_fase, 1, '-')
		oPrn:Say(nLin,nCol,c_imp,oFont12n,100)

		c_imp := transform(n_totc, '@E 999,999,999.99')
		oPrn:Say(nLin,130+aCols[4],c_imp,oFont08,100)
	
		c_imp := transform(n_totbdi, '@E 999,999,999.99')
		oPrn:Say(nLin,105+aCols[5],c_imp,oFont08,100)
	
		c_imp := transform(n_totc + n_totbdi, '@E 999,999,999.99')
		oPrn:Say(nLin,70+aCols[6],c_imp,oFont08,100)
		nLin += nPula
		n_totc := 0
		n_totbdi := 0
	EndIf

Return