#INCLUDE "MATR130.CH"
#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR130  � Autor �Alexandre Inacio Lemes � Data �03/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da Rela��o de Divergencias de Pedidos de Compras   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR130(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function XMATR130()

Local oReport

If TRepInUse()
	//����������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                �
	//������������������������������������������������������������������������
	oReport:= ReportDef()
 	oReport:PrintDialog()
Else
	MATR130R3()
EndIf                   

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �Alexandre Inacio Lemes �Data  �03/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da Rela��o de Divergencias de Pedidos de Compras   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local cTitle   := STR0001 //"Relacao de Divergencias de Pedidos de Compras"
Local oReport 
Local oSection1

Local cAliasSD1 := GetNextAlias()

//������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                   �
//� mv_par01 // a partir da data de recebimento                            �
//� mv_par02 // ate a data de recebimento                                  �
//� mv_par03 // Lista itens Pedido - Que constam na NF / todos os itens    �
//��������������������������������������������������������������������������
Pergunte("MTR130",.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New("MTR130",cTitle,"MTR130", {|oReport| ReportPrint(oReport,cAliasSD1)},STR0002+" "+STR0003) //"Emissao da Relacao de Itens para Compras com divergencias"
oReport:SetLandscape() 
//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relatorio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de codigo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSection1:= TRSection():New(oReport,STR0016,{"SD1","SF1","SA2","SB1"},/*aOrdem*/)
oSection1:SetHeaderPage()                                

TRCell():New(oSection1,"D1_DOC"    ,"SD1",/*Titulo*/,/*Picture*/,MAX(TamSX3("C7_NUM")[1],TamSX3("D1_DOC")[1]),/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_EMISSAO","SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_FORNECE","SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_LOJA"   ,"SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"A2_NOME"   ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_COD"    ,"SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_UM"     ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_QUANT"  ,"SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_VUNIT"  ,"SD1",/*Titulo*/,/*Picture*/,TamSX3("C7_PRECO")[1]+4,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"F1_DTDIGIT","SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"F1_COND"   ,"SF1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2:= TRSection():New(oSection1,STR0017,{"SC7","SA2","SB1"}) 
oSection2:SetHeaderPage()

TRCell():New(oSection2,"C7_NUM"    ,"SC7",/*Titulo*/,/*Picture*/,MAX(TamSX3("C7_NUM")[1],TamSX3("D1_DOC")[1]),/*lPixel*/,/*{|| code-block de impressao }*/)   
TRCell():New(oSection2,"C7_EMISSAO","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_FORNECE","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_LOJA"   ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"A2_NOME"   ,"SA2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_PRODUTO","SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B1_UM"     ,"SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_QUANT"  ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"VALUNIT"   ,"   ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| nValorSC7 })
TRCell():New(oSection2,"C7_DATPRF" ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"C7_COND"   ,"SC7",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection1:Cell("D1_FORNECE"):GetFieldInfo("C7_FORNECE")
oSection1:Cell("D1_QUANT"):GetFieldInfo("C7_QUANT")
oSection1:Cell("F1_DTDIGIT"):GetFieldInfo("C7_DATPRF")
oSection1:Cell("F1_COND"):GetFieldInfo("C7_COND")
oSection2:Cell("VALUNIT"):GetFieldInfo("C7_PRECO")
oSection2:Cell("VALUNIT"):SetSize(TamSX3("C7_PRECO")[1]+4)

oSection2:Cell("C7_EMISSAO"):HideHeader()
oSection2:Cell("C7_FORNECE"):HideHeader()
oSection2:Cell("C7_LOJA"):HideHeader()
oSection2:Cell("A2_NOME"):HideHeader()
oSection2:Cell("C7_PRODUTO"):HideHeader()
oSection2:Cell("B1_UM"):HideHeader()
oSection2:Cell("C7_QUANT"):HideHeader()
oSection2:Cell("VALUNIT"):HideHeader()
oSection2:Cell("C7_DATPRF"):HideHeader()
oSection2:Cell("C7_COND"):HideHeader()

oSection1:SetNoFilter("SB1")
oSection1:SetNoFilter("SA2")
oSection1:SetNoFilter("SF1")
oSection2:SetNoFilter("SB1")
oSection2:SetNoFilter("SA2")
 
Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Alexandre Inacio Lemes �Data  �03/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da Rela��o de Divergencias de Pedidos de Compras   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasSD1)

Local oSection1  := oReport:Section(1) 
Local oSection2  := oReport:Section(1):Section(1)  
Local dDataSav   := ctod("")
Local aItPcNotNF := {}
Local cCondPagto := ""
Local cNumPcSD1  := ""
Local cItemPcSD1 := ""

Local nExiste    := 0
Local nX         := 0

Private nValorSC7:= 0

dbSelectArea("SC7")
dbSetOrder(1)

dbSelectArea("SF1")
dbSetOrder(1)

dbSelectArea("SD1")
dbSetOrder(1)

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �	
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)
//������������������������������������������������������������������������Ŀ
//�Query do relat�rio da secao 1                                           �
//��������������������������������������������������������������������������
oReport:Section(1):BeginQuery()	

BeginSql Alias cAliasSD1

SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_ITEM,D1_EMISSAO,D1_DTDIGIT,D1_QUANT,D1_VUNIT,
           D1_TIPODOC,D1_SERIREM,D1_REMITO,D1_ITEMREM,D1_PEDIDO,D1_ITEMPC,D1_TIPO,F1_FILIAL,F1_DOC,F1_SERIE,
           F1_FORNECE,F1_LOJA,F1_COND,F1_EMISSAO,F1_TIPO,F1_DTDIGIT 
         	
FROM %table:SD1% SD1, %table:SF1% SF1

WHERE D1_FILIAL = %xFilial:SD1% AND 
      D1_DTDIGIT >= %Exp:Dtos(mv_par01)% AND 
	  D1_DTDIGIT <= %Exp:Dtos(mv_par02)% AND 
  	  D1_TIPO = 'N' AND
	  SD1.%NotDel% AND
	  D1_FORNECE >= %Exp:mv_par04% AND 
	  D1_FORNECE <= %Exp:mv_par05% AND 
	  D1_COD >= %Exp:mv_par06% AND 
	  D1_COD <= %Exp:mv_par07% AND 
  	  F1_FILIAL = %xFilial:SF1% AND 
	  F1_DOC = D1_DOC AND
	  F1_SERIE = D1_SERIE AND
	  F1_FORNECE = D1_FORNECE AND
	  F1_LOJA = D1_LOJA AND
  		  SF1.%NotDel% 
	  
ORDER BY %Order:SD1% 
		
EndSql 

oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)


TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1") + (cAliasSD1)->D1_COD })
TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2") + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA })

oReport:SetMeter(SD1->(LastRec()))
dbSelectArea(cAliasSD1)

If cPaisLoc == "BRA"
	
	While !oReport:Cancel() .And. !(cAliasSD1)->(Eof())
		
		oReport:IncMeter()
		If oReport:Cancel()
			Exit
		EndIf
		
		dDataSav  := dDataBase
		dDataBase := (cAliasSD1)->D1_DTDIGIT
		
		cDoc := (cAliasSD1)->D1_DOC + (cAliasSD1)->D1_SERIE + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA
		
		If mv_par03 == 2 .And. !Empty((cAliasSD1)->D1_PEDIDO)
			nExiste := aScan(aItPcNotNF,{|x| x[1] == (cAliasSD1)->D1_PEDIDO })
			If nExiste == 0
				dbSelectArea("SC7")
				dbSetOrder(14)
				If dbSeek(xFilEnt(xFilial("SC7"))+(cAliasSD1)->D1_PEDIDO,.F.)
					SA2->(dbSetOrder(1))
					SA2->(dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
					
					While SC7->C7_NUM == (cAliasSD1)->D1_PEDIDO
						aadd(aItPcNotNF,{ SC7->C7_NUM,SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_ITEM,SC7->C7_PRODUTO,;
						SA2->A2_NOME,SC7->C7_COND,SC7->C7_EMISSAO,;
						SC7->C7_UM,SC7->C7_QUANT,SC7->C7_PRECO,SC7->C7_DATPRF })
						dbSelectArea("SC7")
						dbSkip()
					EndDo
				EndIf
			Endif
		EndIf
		
		dbSelectArea("SC7")
		SC7->(dbSetOrder(19))       
		If dbSeek(xFilEnt(xFilial("SC7"))+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC,.F.)
			nValorSC7 := IIf(Empty(SC7->C7_REAJUSTE),xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,1,(cAliasSD1)->D1_EMISSAO,TamSX3("C7_PRECO")[2],SC7->C7_TXMOEDA),Formula(SC7->C7_REAJUSTE))
			
			cCondPagto := (cAliasSD1)->F1_COND
			
			If SC7->C7_COND  <> cCondPagto .Or. SC7->C7_DATPRF <> (cAliasSD1)->D1_DTDIGIT .Or. ;
				SC7->C7_QUANT <> (cAliasSD1)->D1_QUANT .Or. nValorSC7 <> (cAliasSD1)->D1_VUNIT
				
				oSection1:Init()
				oSection1:PrintLine()
				oSection2:Init()
				oSection2:PrintLine()
				
				oSection1:Finish()
			EndIf
			
			If mv_par03 == 2 .And. !Empty((cAliasSD1)->D1_PEDIDO)
				nExiste := ascan(aItPcNotNF,{|x| x[1]+x[2]+x[3]+x[4]+x[5]==SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_ITEM+SC7->C7_PRODUTO})
				If nExiste > 0
					aDel(aItPcNotNF,nExiste)
					aSize(aItPcNotNF,len(aItPcNotNF)-1)
				EndIf
			EndIf
			
		Else
			
			oSection1:Init()
			oSection1:PrintLine()
			oReport:PrintText(STR0010,,oSection1:Cell("D1_DOC"):ColPos()) // "Nao ha' pedido de compra colocado"
			oSection1:Finish()
			
		EndIf
		
		dDataBase := dDataSav
		
		dbSelectArea(cAliasSD1)
		dbSkip()
		
		If mv_par03 == 2 .And. cDoc <> (cAliasSD1)->D1_DOC + (cAliasSD1)->D1_SERIE + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA
			
			If Len(aItPcNotNF) > 0
				
				oReport:FatLine()
				oReport:PrintText(STR0015+" "+Substr(cDoc,1,6),,oSection1:Cell("D1_DOC"):ColPos()) // "Itens do(s) pedido(s) que nao constam na Nota Fiscal "
				
				For nX :=1 to Len(aItPcNotNF)
					
					oReport:PrintText(aItPcNotNF[nX,01]+" "+aItPcNotNF[nX,04]+"  "+dtoc(aItPcNotNF[nX,08])+space(6)+;
					aItPcNotNF[nX,02]+space(08)+aItPcNotNF[nX,03]+space(05)+aItPcNotNF[nX,06]+space(11)+;
					aItPcNotNF[nX,05]+space(05)+aItPcNotNF[nX,09]+space(08)+TransForm(aItPcNotNF[nX,10],PesqPictQt("C7_QUANT",12))+;
					space(05)+TransForm(aItPcNotNF[nX,11],PesqPictQt("C7_PRECO",14))+space(05)+dtoc(aItPcNotNF[nX,12])+;
					space(07)+aItPcNotNF[nX,07],,oSection1:Cell("D1_DOC"):ColPos())
					
				Next nX
				
				oReport:FatLine()
				oReport:SkipLine()
				
				aItPcNotNF := {}
				
			EndIf
			
		EndIf
		
	EndDo
	
Else
	
	While !oReport:Cancel() .And. !(cAliasSD1)->(Eof())
		
		oReport:IncMeter()
		If oReport:Cancel()
			Exit
		EndIf
		
		If IsRemito(1,(cAliasSD1)+"->D1_TIPODOC")
			dBSkip()
			Loop
		Endif
		
		If !Empty((cAliasSD1)->D1_REMITO)

			aArea := GetArea()
			dbSelectArea("SD1")
			dbSetOrder(1)
			dbSeek(xFilial("SD1")+ (cAliasSD1)->D1_REMITO + (cAliasSD1)->D1_SERIREM + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA + (cAliasSD1)->D1_COD + (cAliasSD1)->D1_ITEMREM )
			cNumPcSD1  := SD1->D1_PEDIDO
			cItemPcSD1 := SD1->D1_ITEMPC
			RestArea(aArea)

		Else
			cNumPcSD1  := (cAliasSD1)->D1_PEDIDO
			cItemPcSD1 := (cAliasSD1)->D1_ITEMPC
		Endif
		
		dDataSav  := dDataBase
		dDataBase := (cAliasSD1)->D1_DTDIGIT
		
		cDoc := (cAliasSD1)->D1_DOC + (cAliasSD1)->D1_SERIE + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA
		
		dbSelectArea("SC7")
		SC7->(dbSetOrder(1))
		If dbSeek(xFilial("SC7")+cNumPcSD1+cItemPcSD1)
			
			nValorSC7 := IIf(Empty(SC7->C7_REAJUSTE),xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,1,(cAliasSD1)->D1_EMISSAO,TamSX3("C7_PRECO")[2],SC7->C7_TXMOEDA),Formula(SC7->C7_REAJUSTE))
			
			cCondPagto := (cAliasSD1)->F1_COND
			
			If SC7->C7_COND  <> cCondPagto .Or. SC7->C7_DATPRF <> (cAliasSD1)->D1_DTDIGIT .Or. ;
				SC7->C7_QUANT <> (cAliasSD1)->D1_QUANT .Or. nValorSC7 <> (cAliasSD1)->D1_VUNIT
				
				oSection1:Init()
				oSection1:PrintLine()
				oSection2:Init()
				oSection2:PrintLine()
				
				oSection1:Finish()
			EndIf
			
		Else
			
			oSection1:Init()
			oSection1:PrintLine()
			oReport:PrintText(STR0010,,oSection1:Cell("D1_DOC"):ColPos()) // "Nao ha' pedido de compra colocado"
			oSection1:Finish()
			
		EndIf
		
		dDataBase := dDataSav
		
		dbSelectArea(cAliasSD1)
		dbSkip()
		
	EndDo
	
EndIf

oSection2:Finish()	

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR130R3� Autor � Claudinei M. Benzi    � Data � 05.09.91 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da Rela��o de Divergencias de Pedidos de Compras   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR130R3(void)                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
���Marcos Simidu �24/06/98�XXXXXX�Acerto lay-out nro. NFs p/12 bytes.     ���
��� Edson  M.    �04/11/98�XXXXXX�Acerto no lay-out p/ o ano 2000.        ���
��� BRUNO        �01/12/98�MELHOR�Inclusao das funcoes impr130loc e       |��
���              �        �      �ImprLinhaRem para o tratamento dos remi-|��
���              �        �      �tos da versao argentina.                |��
��� Edson   M.   �30/03/99�XXXXXX�Passar o tamanho na SetPrint.           ���
��� Patricia Sal.�20/12/99�XXXXXX�Acerto LayOut,Fornec.c/20 pos. e Lj.c/ 4���
���              �        �      �pos.;Troca da PesqPictQt() p/PesqPict().���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
sTATIC Function MATR130R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL wnrel
LOCAL titulo := OemToAnsi(STR0001)	//"Relacao de Divergencias de Pedidos de Compras"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Emissao da Relacao de Itens para Compras"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"com divergencias"
LOCAL cDesc3 := ""
LOCAL cString:= "SD1"
LOCAL cCond := ""
LOCAL Tamanho := "M"

Static aTamSXG, aTamSXG2

PRIVATE cPerg:= "MTR130"
PRIVATE aReturn := { STR0004, 1,STR0005, 2, 2, 1, "",0 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR130"
PRIVATE aLinha  := { } , nLastKey := 0
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
li       := 80
m_pag    := 1
wnrel    := "MATR130"

Tamanho := If(cPaisLoc=="MEX","G","M")

Pergunte("MTR130",.F.)
//���������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                �
//� mv_par01 // a partir da data de recebimento                         �
//� mv_par02 // ate a data de recebimento                               �
//� mv_par03 // Lista itens Pedido - Que constam na NF / todos os itens �
//�����������������������������������������������������������������������
 
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif
 
SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

// Verif. conteudo das Variaveis Grupo de Fornec. (001) e Loja (002)
aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

RptStatus({|lEnd| R130Imp(@lEnd,wnrel,cString,Tamanho)},Titulo)

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R130IMP  � Autor � Cristina M. Ogura     � Data � 10.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR130                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function R130Imp(lEnd,wnrel,cString,Tamanho)
Local cabec1,cabec2
Local limite := If(cPaisLoc == "MEX",220,132)
Local cbCont := 0

nTipo := IIF(aReturn[4]==1,15,18)
//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
titulo := STR0006	//"DIVERGENCIAS ENTRE NF DE COMPRAS E PEDIDOS"
cabec1 := STR0007	//" NOTA   EMISSAO CODIGO LJ  FORNECEDOR                    PRODUTO         UM    QUANTIDADE           VALOR UNITARIO  DT.ENTREGA COND."
cabec2 := STR0008	//"PEDIDO"

// Se nao for LayOut minimo, considerar o maximo
If aTamSXG[1] != aTamSXG[3]
	cabec1 := If(cPaisLoc=="MEX",STR0018,STR0012) //     "NOTA         EMISSAO    CODIGO               LJ   FORNECEDOR       PRODUTO         UM QUANTIDADE   VALOR UNITARIO   DT.ENTREGA COND."
	
	//                        xxxxxxxxxxxx xxxxxxxxxx xxxxxxxxxxxxxxxxxxxx xxxx 1234567890123456 xxxxxxxxxxxxxxx xx xxxxxxxxxxxx xxxxxxxxxxxxxxxx xxxxxxxxxx xxx
	//                        0         1         2         3         4         5         6         7         8         9        10        11       12        13
	//                        01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345679012345678901234567890123
	
Else
	cabec1 := If(cPaisLoc=="MEX",STR0019,STR0007) //" NOTA         EMISSAO    CODIGO LJ FORNECEDOR                       PRODUTO         UM QUANTIDADE   VALOR UNITARIO   DT.ENTREGA COND."
	//                        xxxxxxxxxxxx xxxxxxxxxx xxxxxx xx 12345678901234567890123456789012 xxxxxxxxxxxxxxx xx xxxxxxxxxxxx xxxxxxxxxxxxxxxx xxxxxxxxxx xxx
	//                        0         1         2         3         4         5         6         7         8         9        10        11       12        13
	//                        01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345679012345678901234567890123
	
Endif

If cPaisloc=="BRA"
	Impr130(titulo,cabec1,cabec2,nomeprog,nTipo,tamanho,lEnd)
Else
	Impr130Loc(titulo,cabec1,cabec2,nomeprog,nTipo,tamanho,lEnd)
	
EndIf

IF li !=80
	li++
	@li,000 PSAY Replicate("-",limite)
	roda(CbCont,"DIVERGENCIAS"," ")
EndIF

//��������������������������������������������������������������Ŀ
//� Restaura a Integridade dos dados                             �
//����������������������������������������������������������������
dbSelectArea("SD1")
Set Filter To
dbSetOrder(1)

dbSelectArea("SF1")
dbSetOrder(1)

dbSelectArea("SC7")
dbSetOrder(1)

dbSelectArea("SA2")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � IMPR130  � Autor � Claudinei M. Benzi    � Data � 05.09.91 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Relatorio                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR130                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Impr130(titulo,cabec1,cabec2,nomeprog,nTipo,tamanho,lEnd)

LOCAL cPedido  := " "
LOCAL cNota    := " "
LOCAL cNFant   := " "
LOCAL nPosLoja := 31
LOCAL nPosNome := 34
LOCAL nTamNome := 32
LOCAL nX       := 0
LOCAL lRet     := .T.
LOCAL lPesqSC7 := .T.
LOCAL dDataSav := dDataBase
LOCAL dData    := ctod("")
LOCAL aArraySC7:= {}

// Se Nao for LayOut minimo, considerar o maximo (Fornec. com 20 pos. e loja com 4 pos.)
If aTamSXG[1] != aTamSXG[3]
	nPosLoja += aTamSXG[4] - aTamSXG[3]
	nPosNome += ((aTamSXG[4] - aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
	nTamNome -= ((aTamSXG[4] - aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
Endif

dbSelectArea("SD1")
dbGotop()
dbSetOrder(1)
dbSeek(xFilial(),.F.)

SetRegua(RecCount())

cPedido   := SD1->D1_PEDIDO
cNota     := SD1->D1_DOC
aArraySC7 := {}

While !Eof() .and. D1_FILIAL == xFilial()
	
	If lEnd
		@PROW()+1,001 PSAY STR0009		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IncRegua()
	
	If D1_TIPO $ "IDBCP"
		dbSkip()
		Loop
	Endif
	
	If D1_DTDIGIT < mv_par01 .Or. D1_DTDIGIT > mv_par02
		dbSkip()
		Loop
	Endif

	If IsRemito(1,'SD1->D1_TIPODOC')
		dBSkip()
		Loop
	Endif	

	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial()+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
		dData := SF1->F1_DTDIGIT
	Else
		dData := Ctod("")
	Endif

	cNFAnt := SD1->D1_DOC
	cNota  := SD1->D1_DOC

	If lPesqSC7 .And. !Empty(SD1->D1_PEDIDO)
		dbSelectArea("SC7")
		dbSetOrder(14)
		If dbSeek(xFilEnt(xFilial("SC7"))+SD1->D1_PEDIDO,.F.)
			                                        
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
			
			dbSelectArea("SC7")
			While SC7->C7_NUM == SD1->D1_PEDIDO

				   aadd(aArraySC7,{ SC7->C7_NUM,SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_ITEM,SC7->C7_PRODUTO,;
				   IIF(EMPTY(SA2->A2_NREDUZ),SA2->A2_NOME,SA2->A2_NREDUZ),SC7->C7_COND,SC7->C7_EMISSAO,;
				   SC7->C7_UM,SC7->C7_QUANT,SC7->C7_PRECO,SC7->C7_DATPRF })

				dbSelectArea("SC7")
				dbSkip()
			EndDo
		EndIf
		lPesqSC7 := .F.
	EndIf
	
	cCond := ""
	dbSelectArea("SC7")
	dbSetOrder(19)
	If dbSeek(xFilEnt(xFilial("SC7"))+SD1->D1_COD+SD1->D1_PEDIDO+SD1->D1_ITEMPC,.F.)
		
		dDataSav  := dDataBase
		dDataBase := SD1->D1_DTDIGIT
		cCond		 := SC7->C7_COND
		
		If SD1->D1_ITEMPC != SC7->C7_ITEM
			
			While !Eof() .And. SC7->C7_PRODUTO == SD1->D1_COD     .And.;
				SC7->C7_FORNECE == SD1->D1_FORNECE .And.;
				SC7->C7_LOJA    == SD1->D1_LOJA    .And.;
				SC7->C7_NUM     == SD1->D1_PEDIDO  .And.;
				SC7->C7_ITEM    != SD1->D1_ITEMPC
				dbSelectArea("SC7")
				dbSkip()
				Loop
			EndDo
			
		Endif
		
		If SD1->D1_QUANT <> SC7->C7_QUANT .Or.;
			SD1->D1_VUNIT <> IIf(Empty(SC7->C7_REAJUSTE),xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,1,SF1->F1_EMISSAO,TamSX3("C7_PRECO")[2],SC7->C7_TXMOEDA),Formula(SC7->C7_REAJUSTE)) .Or.;
			SD1->D1_DTDIGIT <> SC7->C7_DATPRF .Or. SF1->F1_COND <> SC7->C7_COND
			
			dDataBase := dDataSav
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
			
			If li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			Endif
			
			ImprLinha(1,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond,aArraySC7)
	
        Else
        
			If MV_PAR03 == 2 .And. Len(aArraySC7) > 0
				nPos := ascan(aArraySC7,{|x| x[1]+x[2]+x[3]+x[4]+x[5]==SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_ITEM+SC7->C7_PRODUTO})
				If npos > 0
					aDel(aArraySC7,nPos)
					aSize(aArraySC7,len(aArraySC7)-1)
				EndIf		
		    EndIf   
					
		Endif
		
	Else
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA)
		
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		
		ImprLinha(2,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData)
		
	Endif
	
	dbSelectArea("SD1")
	dbSkip()

	If cNota <> SD1->D1_DOC .Or. SD1->(Eof())
		
		If MV_PAR03 == 2 .And. Len(aArraySC7) > 0
			If li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			Endif
			@ li,000 PSAY __PrtThinLine()
			li++
			@ li,000 PSAY STR0015+" "+cNFAnt // "Itens do(s) pedido(s) que nao constam na nota "
			Li+=2
			
			For nX :=1 to Len(aArraySC7)
				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				Endif
				
				@ li,013 PSAY aArraySC7[nX,8]
				@ li,024 PSAY aArraySC7[nX,2]
				@ li,nPosLoja PSAY aArraySC7[nX,3]
				@ li,nPosNome PSAY SUBS(aArraySC7[nX,6],1,nTamNome)
				@ li,067 PSAY aArraySC7[nX,5]
				@ li,083 PSAY aArraySC7[nX,9]
				@ li,086 PSAY aArraySC7[nX,10]  Picture PesqPict("SC7","C7_QUANT",12)
				@ li,099 PSAY aArraySC7[nX,11]  Picture PesqPict("SC7","C7_PRECO",16)
				@ li,116 PSAY aArraySC7[nX,12]
				@ li,129 PSAY aArraySC7[nX,7]   Picture PesqPict("SC7","C7_COND",3)				

				Li++
			Next nX
			@ li,000 PSAY __PrtThinLine()
			li+= 2
		EndIf
		
		cPedido   := SD1->D1_PEDIDO
		cNota     := SD1->D1_DOC
		aArraySC7 := {}
		lPesqSC7  := .T.
	Endif
	
EndDo

dDataBase:= dDataSav // Restaura data-base do sistema

Return .T.
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �IMPRLINHA � Autor � Claudinei M. Benzi    � Data � 05.09.91 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao da Linha de Detalhe                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR130                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImprLinha(nFlag,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond,aArraySC7)
LOCAL dDataSav
LOCAL nPosLoja := 31
LOCAL nPosNome := 34
LOCAL nTamNome := 32
LOCAL nPos     := 0
LOCAL nIncCol  := If(cPaisLoc == "MEX",10,0)

// Se Nao for LayOut minimo, considerar o maximo (Fornec. com 20 pos. e loja com 4 pos.)
If aTamSXG[1] != aTamSXG[3]
	nPosLoja += aTamSXG[4] - aTamSXG[3]
	nPosNome += ((aTamSXG[4] - aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
	nTamNome -= ((aTamSXG[4] - aTamSXG[3]) + (aTamSXG2[4] - aTamSXG2[3]))
Endif
If nFlag == 1
	@ li,000 PSAY SD1->D1_DOC
	@ li,013+nIncCol PSAY SD1->D1_EMISSAO
	@ li,024+nIncCol PSAY SD1->D1_FORNECE
	@ li,nPosLoja+nIncCol PSAY SD1->D1_LOJA
	@ li,nPosNome+nIncCol PSAY IIF(EMPTY(SA2->A2_NREDUZ),SUBS(SA2->A2_NOME,1,nTamNome),Subs(SA2->A2_NREDUZ,1,nTamNome))
	@ li,067+nIncCol PSAY SD1->D1_COD
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+SD1->D1_COD)
	
	@ li,083+nIncCol PSAY SB1->B1_UM
	@ li,086+nIncCol PSAY SD1->D1_QUANT   Picture PesqPict("SD1","D1_QUANT",12)
	@ li,099+nIncCol PSAY SD1->D1_VUNIT   Picture PesqPict("SD1","D1_VUNIT",16)
	@ li,116+nIncCol PSAY IIF(!empty(dData), dData , "")
	@ li,129+nIncCol PSAY SF1->F1_COND		Picture PesqPict("SF1","F1_COND",3)
	
	Li++
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	dDataSav  := dDataBase
	dDataBase := SD1->D1_DTDIGIT
	If cPaisLoc == "BRA"
		@ li,000 PSAY "PED.  " +SC7->C7_NUM
	Else
		@ li,000 PSAY SC7->C7_NUM
	EndIf
	@ li,013 PSAY SC7->C7_EMISSAO
	@ li,024 PSAY SC7->C7_FORNECE
	@ li,nPosLoja PSAY SC7->C7_LOJA
	@ li,nPosNome PSAY IIF(EMPTY(SA2->A2_NREDUZ),SUBS(SA2->A2_NOME,1,nTamNome),Subs(SA2->A2_NREDUZ,1,nTamNome))
	@ li,067 PSAY SC7->C7_PRODUTO
	@ li,083 PSAY SB1->B1_UM
	@ li,086 PSAY SC7->C7_QUANT     Picture PesqPict("SC7","C7_QUANT",12)
	@ li,099 PSAY IIf(Empty(SC7->C7_REAJUSTE),xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,1,SF1->F1_EMISSAO,TamSX3("C7_PRECO")[2],SC7->C7_TXMOEDA),Formula(SC7->C7_REAJUSTE))  Picture PesqPict("SC7","C7_PRECO",16)
	@ li,116 PSAY SC7->C7_DATPRF
	@ li,129 PSAY cCond				  Picture PesqPict("SC7","C7_COND",3)
	dDataBase := dDataSav

	If cPaisLoc <> "BRA"
		Li++
	Else
        nPos := ascan(aArraySC7,{|x| x[1]+x[2]+x[3]+x[4]+x[5]==SC7->C7_NUM+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_ITEM+SC7->C7_PRODUTO})
        If npos > 0
           aDel(aArraySC7,nPos)
           aSize(aArraySC7,len(aArraySC7)-1)
        EndIf  
		Li+=2
	EndIf
	
Else
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	@ li,000 PSAY SD1->D1_DOC
	@ li,013+nIncCol PSAY SD1->D1_DTDIGIT
	@ li,024+nIncCol PSAY SD1->D1_FORNECE
	@ li,nPosLoja+nIncCol PSAY SD1->D1_LOJA
	@ li,nPosNome+nIncCol PSAY IIF(EMPTY(SA2->A2_NREDUZ),SUBS(SA2->A2_NOME,1,nTamNome),Subs(SA2->A2_NREDUZ,1,nTamNome))
	@ li,067+nIncCol PSAY SD1->D1_COD
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+SD1->D1_COD)
	
	@ li,083+nIncCol PSAY SB1->B1_UM
	@ li,086+nIncCol PSAY SD1->D1_QUANT     Picture PesqPict("SD1","D1_QUANT",12)
	@ li,099+nIncCol PSAY SD1->D1_VUNIT     Picture PesqPict("SD1","D1_VUNIT",16)
	@ li,116+nIncCol PSAY IIF(!empty(dData), dData , "")
	
	Li++
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	@ li,000 PSAY STR0010	//"Nao ha' pedido de compra colocado"
	If cPaisLoc <> "BRA"
		Li++
	Else
		Li+=2
	EndIf
Endif

Return .T.
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � impr130loc Autor � Bruno Sobieski        � Data � 27.11.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Relatorio                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR130                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Impr130Loc(titulo,cabec1,cabec2,nomeprog,nTipo,tamanho,lEnd)
Local dDataSav,lRet
Local dData := CtoD("")
Local aRemped := array(8) 

//���������������������������������������������������������������������������������Ŀ
//�  [1]=indica se existe remito;[2]=numero do remito;[3]=item do remito;           �
//�	 [4]=indica se existe pedido;[5]=numero do pedido;[6]=item do pedido�
//�	 [7]=produto no remito;[8]=produto no pedido                        �
//�����������������������������������������������������������������������������������

dbSelectArea("SD1")
dbGotop()
dbSetOrder(1)
dbSeek(xFilial(),.F.)

SetRegua(RecCount())

While !Eof() .and. D1_FILIAL == xFilial()
	
	If lEnd
		@PROW()+1,001 PSAY STR0009		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IncRegua()
	
	If D1_TIPO $ "IDBCP"
		dbSkip()
		Loop
	Endif
	
	If D1_DTDIGIT < mv_par01 .Or. D1_DTDIGIT > mv_par02
		dbSkip()
		Loop
	Endif

	If IsRemito(1,'SD1->D1_TIPODOC')
		dBSkip()
		Loop
	Endif	

	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial()+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
		dData := SF1->F1_DTDIGIT
	Endif
	
	cCond := ""
	
    //Verifica se existe remito e pedido retornando na area e indices selecionados
    aRemped := Existremped("SC7",4)

	If aRemped[4] // . . . se houver pedido
		dDataSav  := dDataBase
		dDataBase := SD1->D1_DTDIGIT
		cCond		 := SC7->C7_COND
		If aRemped[6] != SC7->C7_ITEM
			While !Eof() .And. SC7->C7_PRODUTO == SD1->D1_COD .And.;
				SC7->C7_FORNECE == SD1->D1_FORNECE .And.;
				SC7->C7_LOJA == SD1->D1_LOJA .And.;
				SC7->C7_NUM == aRemped[5] .And.;
				SC7->C7_ITEM != aRemped[6]
				dbSelectArea("SC7")
				dbSkip()
				Loop
			End
		Endif
		
		lRet := .F.
		IF SD1->D1_QUANT == SC7->C7_QUANT .AND.;
			SD1->D1_VUNIT == IIf(Empty(SC7->C7_REAJUSTE),SC7->C7_PRECO,Formula(SC7->C7_REAJUSTE)) .AND.;
			SD1->D1_DTDIGIT == SC7->C7_DATPRF .AND.;
			SF1->F1_COND == SC7->C7_COND
			If SD1->D1_LOJA == SC7->C7_LOJA
				lRet := .T.
			EndIf
			If lRet
		        dDataBase := dDataSav
				dbSelectArea("SD1")
				dbSkip()
				Loop
			EndIf
		Endif
		
		dDataBase := dDataSav
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		ImprLinha(1,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond)
	Else
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial()+SD1->D1_FORNECE+SD1->D1_LOJA)
		If li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		ImprLinha(2,titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,dData,cCond)
	Endif

	dbSelectArea("SD1")
	dbSkip()

EndDo

Return .T.

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �Existremped�Autor  �Leandro cg          � Data �  08/20/01   ���
��������������������������������������������������������������������������͹��
���Desc.     �Verifica existencia de remito e pedido de compra             ���
���          �                                                             ���
��������������������������������������������������������������������������͹��
���Uso       � MATR130                                                     ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function Existremped(cAlias,nIndex)

Local aRet   := array(11) 
Local nRecno := SD1->(Recno())
/*              
//������������������������������������������������������������������������������������������������������������Ŀ
//� - aRet                                                                                                     |
  |                                                                                                            |
  |	[1]=indica se existe remito;[2]=numero do remito;[3]=item do remito;                                       �
//� [4]=indica se existe pedido;[5]=numero do pedido;[6]=item do pedido                                        �
//� [7]=produto no remito;[8]=produto no pedido                                                                �
//�                                                                                                            �
//� Esta funcao verifica a existencia de Remito e pedido para uma Nota Fiscal, setando e devolvendo a variavel �
//� aRet com o conteudo descrito acima                                                                         |
  |                                                                                                            �
//�  - cAlias = area selecionada no momento em que a funcao e chamada                                          |
  |  - nIndex = indice utilizado no momento em que a funcao e chamada                                          �
//��������������������������������������������������������������������������������������������������������������
*/
    //Verifica se a Nota possui Remito             

	If !Empty(SD1->D1_REMITO)
		
    	aRet[1] := .T.
    	aRet[2] := SD1->D1_REMITO
    	aRet[3] := SD1->D1_ITEMREM
    	aRet[7] := SD1->D1_COD
    	aRet[9] := SD1->D1_SERIREM
    	aRet[10]:= SD1->D1_FORNECE
    	aRet[11]:= SD1->D1_LOJA

		dbSelectArea("SD1")
		dbSetOrder(1)
		dbSeek(xFilial("SD1")+aRet[2]+aRet[9]+aRet[10]+aRet[11]+aRet[7]+aRet[3])
		
	Else
        aRet[1] := .F.
        aRet[2] := 0
        aret[3] := 0
        aRet[7] := ""
	Endif
	
    //---

    //Se houver remito, verifica se existe pedido atraves do remito ...
  	dbSelectArea("SC7")
    dbSetOrder(4)
   	If dbSeek(xFilial()+SD1->D1_COD+SD1->D1_PEDIDO+SD1->D1_ITEMPC,.F.) 
       	aRet[4] := .T.
       	aRet[5] := C7_NUM
       	aRet[6] := C7_ITEM
       	aRet[8] := C7_PRODUTO
   	Else
   	  	aRet[4] := .F.
       	aRet[5] := 0
       	aRet[6] := 0    
       	aRet[8] := ""    
    Endif
    //--- (Isto e feito pelo fato de que nao e gravado o numero do pedido na nota quando a mesma possui remito)
         
	SD1->(dbGoto(nRecno))

    //Retorna area e indice
    dbSelectArea(cAlias)
    dbSelectArea(nIndex)
    //---
                
Return(aRet)
