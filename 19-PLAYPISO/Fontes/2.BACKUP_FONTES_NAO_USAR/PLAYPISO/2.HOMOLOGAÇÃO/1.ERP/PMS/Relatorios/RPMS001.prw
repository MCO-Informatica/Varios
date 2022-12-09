#INCLUDE "TOPCONN.CH"
//#INCLUDE "MATR265.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPMS001   �Autor  �Alexandre Sousa     � Data �  08/27/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio de listagem de projetos.                          ���
���          �Mostra o custo e o markup.                                  ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RPMS001()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local cDesc1 	:="Este relatorio tem o objetivo de listar os Or�amentos em andamento"
Local cDesc2 	:=''//STR0002	//"apos o Faturamento de uma NF ou a Criacao de uma OP caso consumam"
Local cDesc3 	:=''//STR0003	//"materiais que utilizam o controle de Localizacao Fisica"
Local cString	:="SD2"

Private tamanho	:="P"
Private cbCont,cabec1,cabec2,cbtxt
Private cPerg	:="RPMS001"
Private aOrd	:= {}
Private aReturn := {"Zebrado",1,"Administracao", 2, 2, 1, "",0 }	//"Zebrado"###"Administracao"
Private nomeprog:="RPMS001",nLastKey := 0
Private li		:=80, limite:=132, lRodape:=.F.
Private wnrel  	:= "RPMS001"
Private titulo 	:="OR�AMENTOS DO PER�ODO"
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

Private a_poscl := {}
Private a_posln := {}

Private a_Header	:= {}
Private a_dados := {}


Aadd(a_Header,{"CODIGO"     				,"C",06,0})  // Saidas para Beneficiamento
Aadd(a_Header,{"TP"	    					,"C",02,0})
Aadd(a_Header,{"GRUP" 						,"C",04,0})  // Saidas para Beneficiamento
Aadd(a_Header,{"DESCRI��O"					,"C",30,0})  // Saidas para Beneficiamento
Aadd(a_Header,{"UN"							,"C",02,0})
Aadd(a_Header,{"FL"							,"C",02,0})
Aadd(a_Header,{"ARMZ"						,"C",02,0})
Aadd(a_Header,{"SALDO EM ESTOQUE"			,"N",12,0})
Aadd(a_Header,{"EMPENHO PARA REQ/PV/RESEVA"	,"N",12,2})
Aadd(a_Header,{"ESTOQUE DISPONIVEL"			,"N",12,2})
Aadd(a_Header,{"VALOR EM ESTOQUE"			,"N",12,2})
Aadd(a_Header,{"VALOR EMPENHADO"			,"N",20,0})


nLin	:= 100
nCol	:= 60
nPula	:= 60

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt   := SPACE(10)
cbcont  := 0
Li      := 80
m_pag   := 1
cabec2  := ""

cabec1  := ""// STR0007 "ENDERECO        |LOTE          |COD.NYTRON     |COD.CLIENTE       |QUANTIDADE"
//                                1         2         3         4         5         6         7         8         9        10        11        12        13        14
//                       012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

//�������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                          �
//���������������������������������������������������������������
AjustaSX1()
pergunte( cPerg,.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01       	  Pick List   1 - NF  2 - OP                 �
//� mv_par02	     	  De  Nota Fiscal Venda                  �
//� mv_par03	     	  Ate Nota Fiscal Venda                  �
//� mv_par04	     	  De  Data de Entrega                    �
//� mv_par05	     	  Ate Data de Entrega                    �
//� mv_par06	     	  De  Cliente                            �
//� mv_par07	     	  Ate Cliente                            �
//� mv_par08	     	  De  Ordem de Producao                  �
//� mv_par09	     	  Ate Ordem de Producao                  �
//� mv_par10	     	  Qtd p/ impressao 1 - Original 2 - Saldo�
//� mv_par11        Considera OPs 1- Firmes 2- Previstas 3- Ambas�
//� mv_par12	     	  Moeda                                  �
//� mv_par13              Outras moedas                          �
//����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//�������������������������������������������������������������Ŀ
//� Lista Pick-List para Nota Fiscal de Venda                   �
//���������������������������������������������������������������
cSerIni := If(cPaisLoc=="BRA",MV_PAR14,MV_PAR16)
cSerFin := If(cPaisLoc=="BRA",MV_PAR15,MV_PAR17)

Processa({||C265ImpNF()}, titulo, "Imprimindo, aguarde...")


If	( aReturn[5] == 1 ) //1-Disco, 2-Impressora
	oPrn:Preview()
Else
	oPrn:Setup()
	oPrn:Print()
EndIf

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C265ImpNF� Autor � Jesus Pedro           � Data � 13.11.97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio para Pick-List da Nota Fiscal de Venda���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR265	                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C265ImpNF()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local bBlock, cChaveAnt:="",cChaveDB:=""
Local lExistBlock:=ExistBlock("MR265MAIL")
Private cNfAnt := Space(6)
Private nValorNf := 0
Private n_x		 := 0

nOrdem := aReturn[8]

//��������������������������������������������������������������Ŀ
//� Coloca areas nas Ordens Corretas                             �
//����������������������������������������������������������������
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

c_query := " select * from "+RetSqlName('AF8')+" "
c_query += " where AF8_DATA between '"+DtoS(MV_PAR01)+"' and '"+DtoS(MV_PAR02)+"' "
c_query += " and   AF8_FILIAL = '"+xFilial('AF8')+"' "
c_query += " and   D_E_L_E_T_ <> '*' "
c_query += " order by AF8_FASE, AF8_DESCRI, AF8_DATA"

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

	If QRY->AF8_FASE $ MV_PAR04
		fPulareg()
		Loop
	EndIf

	If !empty(MV_PAR03)
		If !(QRY->AF8_FASE $ MV_PAR03)
			fPulareg()
			Loop
		EndIf
	EndIf
	
	n_custo :=  fRetCusto(QRY->AF8_PROJET, QRY->AF8_REVISA)
	If n_custo < MV_PAR05
		fPulareg()
		Loop
	EndIf

	If n_cont > 40
		CabecNF("000001")
		n_cont := 0
	EndIf

	nLin += nPula

	oPrn:Box(nLin-10,50,nLin+50,nfim)
	oPrn:Box(nLin-10,50,nLin+50,(nfim-(50))/10)
	oPrn:Box(nLin-10,50,nLin+50,2*(nfim-(50))/10)
	oPrn:Box(nLin-10,50,nLin+50,5*(nfim-(50))/10)
	oPrn:Box(nLin-10,50,nLin+50,7*(nfim-(50))/10)
	oPrn:Box(nLin-10,50,nLin+50,8*(nfim-(50))/10)
	oPrn:Box(nLin-10,50,nLin+50,9*(nfim-(50))/10)

	c_imp := DtoC(stod(QRY->AF8_DATA))
	oPrn:Say(nLin,nCol,c_imp,oFont08,100)
	
	c_imp := QRY->AF8_PROJET
	oPrn:Say(nLin,nCol+aCols[1],c_imp,oFont08,100)
	
	c_imp := SubStr(QRY->AF8_DESCRI, 1,35)
	oPrn:Say(nLin,nCol+aCols[2],c_imp,oFont08,100)
	
	c_imp := QRY->AF8_FASE + "-"+GetAdvFval('AEA', 'AEA_DESCRI', xFilial('AEA')+QRY->AF8_FASE, 1, '-')
	oPrn:Say(nLin,nCol+aCols[3],c_imp,oFont08,100)

	c_imp := transform(n_custo, '@E 999,999,999.99')
	oPrn:Say(nLin,nCol+aCols[4],c_imp,oFont08,100)

	c_imp := transform(QRY->AF8_VALBDI, '@E 999,999,999.99')
	oPrn:Say(nLin,nCol+aCols[5],c_imp,oFont08,100)

	c_imp := transform(QRY->AF8_VALBDI + n_custo, '@E 999,999,999.99')
	oPrn:Say(nLin,nCol+aCols[6],c_imp,oFont08,100)

	n_totc += n_custo
	n_totbdi += QRY->AF8_VALBDI
	n_cont++

	fPulareg()

EndDo


If aReturn[5] = 1
	dbCommitAll()
Endif

MS_FLUSH()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CabecNF  � Autor � Jesus Pedro           � Data � 13.11.97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o cabecalho do relatorio por PV                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR265	                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CabecNF(c_cod)

Local aArea := GetArea()
Local cTxt := ""
nLin	:= 100
nCol	:= 60
nPula	:= 60

oPrn:EndPage()


If Li > 55
	
	oPrn:Say(nLin,nCol+1000,Titulo,oFont14n,100)
	oPrn:Box(50,50,200,nfim)
	
	oPrn:Box(50,50,200,nfim-360)
	
	oPrn:Say(060,2040,"Folha....: " + str(NPAG),oFont12,100)
	oPrn:Say(090,2040,"DT.Emiss.: " + dtoc(date()),oFont12,100)
	
	nLin += nPula
	nLin += nPula
	nLin += nPula
//	oPrn:Box(nLin-10,50,nLin+50,nfim)
//	oPrn:Box(nLin-10,50,nLin+50,400)
	
	
//	nLin += nPula
//	nLin += nPula
	
	oPrn:Box(nLin-10,50,nLin+50,nfim)
	oPrn:Box(nLin-10,50,nLin+50,(nfim-(50))/10)
	oPrn:Box(nLin-10,50,nLin+50,2*(nfim-(50))/10)
	oPrn:Box(nLin-10,50,nLin+50,5*(nfim-(50))/10)
//	oPrn:Box(nLin-10,50,nLin+50,6*(nfim-(50))/10)
	oPrn:Box(nLin-10,50,nLin+50,7*(nfim-(50))/10)
	oPrn:Box(nLin-10,50,nLin+50,8*(nfim-(50))/10)
	oPrn:Box(nLin-10,50,nLin+50,9*(nfim-(50))/10)
	
	c_imp := "DATA"
	oPrn:Say(nLin,nCol,c_imp,oFont12n,100)
	
	c_imp := "OR�AMENTO"
	oPrn:Say(nLin,nCol+aCols[1],c_imp,oFont12n,100)
	
	c_imp := "DESCRI��O"
	oPrn:Say(nLin,nCol+aCols[2],c_imp,oFont12n,100)
	
	c_imp := "FASE"
	oPrn:Say(nLin,nCol+aCols[3],c_imp,oFont12n,100)
	
	c_imp := "CUSTO"
	oPrn:Say(nLin,nCol+aCols[4],c_imp,oFont12n,100)
	
	c_imp := "MARKUP"
	oPrn:Say(nLin,nCol+aCols[5],c_imp,oFont12n,100)

	c_imp := "TOTAL"
	oPrn:Say(nLin,nCol+aCols[6],c_imp,oFont12n,100)

	nLin += nPula
	imprp	:= .T.
	
Endif

RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DetalheNF� Autor � Jesus Pedro           � Data � 13.11.97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o detalhe da Nota Fiscal de Venda                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR265	                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DetalheNF(Tamanho)
//	@ Li,016 PSAY SD2->D2_LOTECTL			Picture PesqPict("SD2","D2_LOTECTL",10)
//	@ Li,030 PSAY SD2->D2_COD				Picture PesqPict("SD2","D2_COD",15)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C265ImpOP� Autor �Rodrigo de A. Sartorio � Data � 14.04.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio para Pick-List da Ordem de Producao   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR265	                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C265ImpOP( lEnd, tamanho, titulo, wnRel )
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL cChave,cCompara
PRIVATE cOpAnt := Space(11)

//��������������������������������������������������������������Ŀ
//� Coloca areas nas Ordens Corretas                             �
//����������������������������������������������������������������
dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SD4")
dbSetOrder(2)

dbSelectArea("SDC")
dbSetOrder(2)

dbSelectArea("SC2")
dbSetOrder(1)

//��������������������������������������������������������������Ŀ
//� Monta filtro e indice da IndRegua                            �
//����������������������������������������������������������������
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

//��������������������������������������������������������Ŀ
//� Verifica o numero de registros validos para a SetRegua �
//����������������������������������������������������������
dbGoTop()
//SetRegua(LastRec())

cChaveAnt := "????????????????"

While !Eof()
	//��������������������������������������������������������������Ŀ
	//� Verifica se o usuario interrompeu o relatorio                �
	//����������������������������������������������������������������
	
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
	
	//��������������������������������������������������������������Ŀ
	//� Lista o cabecalho da Ordem de Producao                       �
	//����������������������������������������������������������������
	CabecOP(Tamanho)
	
	dbSelectArea("SD4")
	dbSeek(xFilial()+cOPAnt)
	While !Eof() .And. D4_FILIAL+D4_OP == xFilial()+cOpAnt
		//��������������������������������������������������������������Ŀ
		//� Lista o detalhe da ordem de producao                         �
		//����������������������������������������������������������������
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
			//��������������������������������������������������������������Ŀ
			//� Varre composicao do empenho                                  �
			//����������������������������������������������������������������
			If !Empty(cChave) .AND. dbSeek(cChave)
				Do While !Eof() .And. cChave == &(cCompara)
					CabecOP(Tamanho)
					@ Li,016 PSAY DC_LOTECTL	Picture PesqPict("SDC","DC_LOTECTL",10)
					//					@ Li,61 PSAY DC_NUMLOTE	Picture PesqPict("SDC","DC_NUMLOTE",6)
					@ Li,000 PSAY DC_LOCALIZ Picture PesqPict("SDC","DC_LOCALIZ",15)
					//					@ Li,86 PSAY DC_NUMSERI Picture PesqPict("SDC","DC_NUMSERI",20)
					//��������������������������������������������������������������Ŀ
					//�Lista quantidade de acordo com o parametro selecionado        �
					//����������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CabecOP  � Autor �Rodrigo de A. Sartorio � Data � 14.04.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o cabecalho do relatorio por Ordem de Producao     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR265	                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DetalheOP� Autor �Rodrigo de A. Sartorio � Data � 14.04.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o detalhe da Ordem de Producao                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR265	                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CabecRem � Autor � Guilherme C. Leal     � Data � 18.04.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cabecalho/Encabezado/Header				                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR265	                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �DetalheRem� Autor � Guilherme C. Leal     � Data � 18.04.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Detalhe do Remito/Detalle del Remito/Remito Detail         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR265	                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DetalheRem(Tamanho)
//@ Li,16 PSAY Left(SB1->B1_DESC,30)		Picture PesqPict("SB1","B1_DESC",30)
//@ Li,47 PSAY SB1->B1_UM				Picture PesqPict("SB1","B1_UM",2)
@ Li,016 PSAY SD2->D2_LOTECTL			Picture PesqPict("SD2","D2_LOTECTL",10)
@ Li,030 PSAY SD2->D2_COD			Picture PesqPict("SD2","D2_COD",15)

//@ Li,61 PSAY SD2->D2_NUMLOTE			Picture PesqPict("SD2","D2_NUMLOTE",6)
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  �Alexandre Lemes     � Data � 18/12/2003  ���
�������������������������������������������������������������������������͹��
���Uso       � MATR600 AP7                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Aadd(aHelpPor,"Informe as fases do OR�AMENTO que deseja ")
Aadd(aHelpPor,"imprimir Ex.: 01/02/03/04              ")

PutSX1(cPerg,cSeq,"Imprimir Fase","","",cCH,"C",40,0,0,"G","","","","S",cPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
cSeq := Soma1(cSeq)
cCH  := Soma1(cCH)
cPAR := Soma1(cPAR)
aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
Aadd(aHelpPor,"Informe as fases do OR�AMENTO que deseja ")
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


Return




Static Function fRetCusto(c_prj, c_rev)

Local n_Ret := 0

c_query := " select * from "+RetSqlName('AFC')+" "
c_query += " where AFC_PROJET = '"+c_prj+"' "
c_query += " and   AFC_REVISA = '"+c_rev+"'"
c_query += " and   D_E_L_E_T_ <> '*' "
c_query += " and   AFC_NIVEL = '001' "
c_query += " and   AFC_FILIAL = '"+xFilial('AFC')+"' "


If Select("TRP") > 0          
	DbSelectArea("TRP")
	DbCloseArea()                 
EndIf                          
                                
TcQuery c_Query New Alias "TRP"

If TRP->(!EOF())
	n_Ret := TRP->AFC_CUSTO
EndIf


Return n_Ret



Static Function fPulareg()

	c_fase := QRY->AF8_FASE
	QRY->(DBSKIP())
	
	If c_fase <> QRY->AF8_FASE .and. n_totc + n_totbdi > 0
		nLin += nPula
		
		oPrn:Box(nLin-10,50,nLin+50,nfim)
//		oPrn:Box(nLin-10,50,nLin+50,(nfim-(50))/10)
//		oPrn:Box(nLin-10,50,nLin+50,2*(nfim-(50))/10)
//		oPrn:Box(nLin-10,50,nLin+50,5*(nfim-(50))/10)
		oPrn:Box(nLin-10,50,nLin+50,7*(nfim-(50))/10)
		oPrn:Box(nLin-10,50,nLin+50,8*(nfim-(50))/10)
		oPrn:Box(nLin-10,50,nLin+50,9*(nfim-(50))/10)
		
		c_imp := "TOTAL DA FASE: " + c_fase+ "-"+GetAdvFval('AEA', 'AEA_DESCRI', xFilial('AEA')+c_fase, 1, '-')
		oPrn:Say(nLin,nCol,c_imp,oFont12n,100)

		c_imp := transform(n_totc, '@E 999,999,999.99')
		oPrn:Say(nLin,nCol+aCols[4],c_imp,oFont08,100)
	
		c_imp := transform(n_totbdi, '@E 999,999,999.99')
		oPrn:Say(nLin,nCol+aCols[5],c_imp,oFont08,100)
	
		c_imp := transform(n_totc + n_totbdi, '@E 999,999,999.99')
		oPrn:Say(nLin,nCol+aCols[6],c_imp,oFont08,100)
		nLin += nPula
		n_totc := 0
		n_totbdi := 0
	EndIf

Return