#INCLUDE "FATR050.ch"
#INCLUDE "FATR050.CH"
#include "fivewin.ch"
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FATR050  � Autor � Marco Bianchi         � Data �25/05/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de metas de vendas x realizado                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER Function CFATR050()

Local oReport

	oReport := ReportDef()
	oReport:PrintDialog()

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marco Bianchi         � Data �25/05/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport
Local cAliasQry := GetNextAlias()

Private nValReal := 0					// Valor Real
Private nQtdReal := 0					// Quantidade Real
Private nValMeta := 0					// Valor da Meta
Private aVendas  := { 0, 0, 0 } 		
Private aDevol   := { 0, 0, 0 }   

	
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
oReport := TReport():New("FATR050",STR0007,"FTR050P9R1", {|oReport| ReportPrint(oReport,cAliasQry)},STR0008+ " " + STR0009)
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)
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
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oMetas := TRSection():New(oReport,STR0020,{"SCT"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oMetas:SetTotalInLine(.F.)

TRCell():New(oMetas,"CT_DOC"    ,"SCT",STR0019   ,/*Picture*/			  			,TamSX3("CT_DOC")		[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Codigo da Meta
TRCell():New(oMetas,"CT_SEQUEN" ,"SCT",STR0012   ,/*Picture*/			  			,TamSX3("CT_SEQUEN")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Sequencia da Meta
TRCell():New(oMetas,"CT_DESCRI" ,"SCT",STR0011   ,/*Picture*/			  			,TamSX3("CT_DESCRI")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Descricao da Meta
TRCell():New(oMetas,"CT_DATA"   ,"SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_DATA")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Data da Meta
TRCell():New(oMetas,"CT_VEND"   ,"SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_VEND")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Codigo do Vendedor
TRCell():New(oMetas,"CT_REGIAO" ,"SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_REGIAO")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Regiao
TRCell():New(oMetas,"CT_PRODUTO","SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_PRODUTO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Codigo do Produto
TRCell():New(oMetas,"CT_GRUPO"  ,"SCT",/*Titulo*/,/*Picture*/			  			,TamSX3("CT_GRUPO")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Grupo do Produto
TRCell():New(oMetas,"CT_TIPO"   ,"SCT",STR0013   ,/*Picture*/			  			,TamSX3("CT_TIPO")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Tipo do Produto
TRCell():New(oMetas,"NVALMETA"  ,"   ",STR0010   ,PesqPict("SCT","CT_VALOR")	,TamSX3("CT_VALOR")	[1],/*lPixel*/,{|| xMoeda( CT_VALOR, CT_MOEDA, MV_PAR10, CT_DATA ) })	// Valor da Meta
TRCell():New(oMetas,"CT_QUANT"  ,"SCT",STR0018   ,PesqPict("SCT","CT_QUANT")	,TamSX3("CT_QUANT")	[1],/*lPixel*/,/*{|| code-block de impressao }*/)						// Quantidade da Meta
TRCell():New(oMetas,"NVALREAL"  ,"   ",STR0014   ,PesqPict("SCT","CT_VALOR")	,TamSX3("CT_VALOR")	[1],/*lPixel*/,{|| nValReal })			        						// Valor Real
TRCell():New(oMetas,"NQTDREAL"  ,"   ",STR0015   ,PesqPict("SCT","CT_QUANT") ,TamSX3("CT_QUANT")	[1],/*lPixel*/,{|| nQtdReal })											// Quantidade Real
TRCell():New(oMetas,"nVRMM"     ,"   ",STR0016   ,PesqPict("SCT","CT_VALOR")	,TamSX3("CT_VALOR")	[1],/*lPixel*/,{|| nValReal - nValMeta })								// Valor Real - Meta
TRCell():New(oMetas,"nQRMM"     ,"   ",STR0017   ,PesqPict("SCT","CT_QUANT")	,TamSX3("CT_QUANT")	[1],/*lPixel*/,{|| nQtdReal - CT_QUANT })								// Quantidade Real - Meta

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Eduardo Riera          � Data �04.05.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasQry)

Local cEstoq 	:= If( (mv_par12 == 1),"'S'",If( (mv_par12 == 2),"'N'","'S','N'" ) )
Local cDupli 	:= If( (mv_par11 == 1),"'S'",If( (mv_par11 == 2),"'N'","'S','N'" ) )

#IFNDEF TOP
	Local cCondicao := ""
#ENDIF

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
#IFDEF TOP
	
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)

	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	
		
	BeginSql Alias cAliasQry
    SELECT SCT.* 
		FROM %table:SCT% SCT
		WHERE CT_FILIAL = %xFilial:SCT% AND  
		CT_REGIAO >= %Exp:MV_PAR03% AND 
		CT_REGIAO <= %Exp:MV_PAR04% AND 		
		CT_DATA   >= %Exp:DToS(MV_PAR08)% AND 
		CT_DATA   <= %Exp:DToS(MV_PAR09)% AND 	
		SCT.%notdel% 
		ORDER BY CT_VEND, CT_CATEGO
	EndSql 
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery({MV_PAR05,MV_PAR06})
		
#ELSE
    cAliasQry := "SCT"

	//����������������������������������������������������������������������������������������������������Ŀ
	//�Utilizar a funcao MakeAdvlExpr, somente quando for utilizar o range de parametros para ambiente CDX �
	//������������������������������������������������������������������������������������������������������
	MakeAdvplExpr("FTR050P9R1") 

	//���������������������������������������������������������������������Ŀ
	//� Logica para ISAM                                                    �
	//�����������������������������������������������������������������������
	dbSelectArea("SCT")
	dbSetOrder(2)
	cCondicao += "CT_FILIAL='"      +xFilial("SCT")+"'.AND."
	
    // Regiao
	cCondicao += "CT_REGIAO>='"     + MV_PAR03+"'.AND."
	cCondicao += "CT_REGIAO<='"     + MV_PAR04+"'.AND."	

    // Tipo de produto
	If !Empty(mv_par05)
		cCondicao += +MV_PAR05+" .AND."
	EndIf	           

	// Grupo de produto
	If !Empty(mv_par06)
		cCondicao += +MV_PAR06+" .AND."
	EndIf	          

	cCondicao += "DTOS(CT_DATA)>='" +DToS(MV_PAR08)+"'.AND."
	cCondicao += "DTOS(CT_DATA)<='" +DToS(MV_PAR09)+"'
		
	oReport:Section(1):SetFilter(cCondicao,SCT->(IndexKey()))
	
#ENDIF		
//������������������������������������������������������������������������Ŀ
//�Metodo TrPosition()                                                     �
//�                                                                        �
//�Posiciona em um registro de uma outra tabela. O posicionamento ser�     �
//�realizado antes da impressao de cada linha do relat�rio.                �
//�                                                                        �
//�                                                                        �
//�ExpO1 : Objeto Report da Secao                                          �
//�ExpC2 : Alias da Tabela                                                 �
//�ExpX3 : Ordem ou NickName de pesquisa                                   �
//�ExpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
//�        cutada.                                                         �
//�                                                                        �				
//��������������������������������������������������������������������������

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
oReport:SetMeter(SCT->(LastRec()))


dbSelectArea(cAliasQry)
dbGoTop()
oReport:Section(1):Init()
While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	//��������������������������������������������������������������Ŀ
	//� Chama a funcao de calculo das vendas                         �
	//����������������������������������������������������������������       
	
		/*	
		��������������������������������������������������������������������������Ĵ��
		���Parametros�ExpN1: Tipo de Meta :(1-Numerico-Valor liquido - desconto )  ���
		���          �                     (2-Numerico-Quantidade )                ���
		���          �                     (3-Numerico-Valor bruto + desconto )    ���
		���          �                     (4-Array-contendo todos os valores acima���
		���          �                     (5-Array-contendo todos os valores acima���
		���          �                      por produto                            ���
		���          �ExpC2: cCodigo                                               ���
		���          �ExpD3: Data de Inicio                                        ���
		���          �ExpD4: Data de Termino                                       ���
		���          �ExpC5: Regiao de Vendas.                                     ���
		���          �ExpC6: Tipo de Produto                                       ���
		���          �ExpC7: Grupo de Produto                                      ���
		���          �ExpC8: Codigo do Produto                                     ���
		���          �ExpN9: Moeda para conversao                                  ���
		���          �ExpCA: Cliente                                               ���
		���          �ExpCB: Loja                                                  ���
		���          �ExpCC: CATEGORIA DO PRODUTO								   ���
		���          �       SGBD ISAM                                             ���
		���          �ExpCD: Determina se devem ser consideradas Notas fiscais (1) ���
		���          �       REMITOS (2) ou ambos tipos de documento (3)           ���
		��������������������������������������������������������������������������Ĵ��
		���Retorno   �ExpX1: Valor / Array conforme tipo da Meta                   ���
		��������������������������������������������������������������������������Ĵ��
		���Descri��o �Calcula o Valor das Vendas com base nas notas fiscais de     ���
		���          �saida                                                        ���
		���          �                                                             ���
		��������������������������������������������������������������������������Ĵ��
		*/

	aVendas := NfVendas(4,(cAliasQry)->CT_VEND,MV_PAR01,MV_PAR02,(cAliasQry)->CT_REGIAO,(cAliasQry)->CT_TIPO,(cAliasQry)->CT_GRUPO,(cAliasQry)->CT_PRODUTO,MV_PAR10,"","",(cAliasQry)->CT_CATEGO,,cDupli,cEstoq)
	
	aDevol := { 0,0,0 }
/*
	If MV_PAR07 == 1  	
		//��������������������������������������������������������������Ŀ
		//� Chama a funcao de calculo das devolucoes de venda            �
		//����������������������������������������������������������������
		aDevol := FtNfDevol(4,(cAliasQry)->CT_VEND,MV_PAR01,MV_PAR02,(cAliasQry)->CT_REGIAO,(cAliasQry)->CT_TIPO,(cAliasQry)->CT_GRUPO,(cAliasQry)->CT_PRODUTO,MV_PAR10,"","",,cDupli,cEstoq)
	EndIf 			
*/ 
 	nValReal := aVendas[ 1 ] - aDevol[ 1 ]
 	nQtdReal := aVendas[ 2 ] - aDevol[ 2 ]
	nValMeta := xMoeda( ( cAliasQry )->CT_VALOR, ( cAliasQry )->CT_MOEDA, MV_PAR10, ( cAliasQry )->CT_DATA ) 

	oReport:Section(1):PrintLine()
	
	
	dbSelectArea(cAliasQry)
	dbSkip()
	oReport:IncMeter()
EndDo
oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak(.T.) 


Return


Static Function NfVendas(nTpMeta,cCodigo,dDataIni,dDataFim,cRegiao,cTipo,cGrupo,cProduto,nMoeda,cCliente,cLoja,cCatego,cTipoDoc,cDupli,cEstoq)

Local aArea   := GetArea()
Local aAreaSA3:= SA3->(GetArea())
Local aAreaSF4:= SF4->(GetArea())
Local aAreaSD2:= SD2->(GetArea())
Local aAreaSF2:= SF2->(GetArea())
Local aGrupos := {} 
Local cQuery  := ""
Local cArqQry := "FtNfVendas"
Local cSeek   := ""
Local cComp   := ""
Local cVend   := ""
Local cIn     := ""
Local xRetorno := 0
Local nCntVend:= Fa440CntVen()
Local nCntFor := 0
Local nX      := 0
Local lVend   := .F.
Local nLoop
Local cRegiaoNF := ""
Local nVlrAux := 0

DEFAULT nTpMeta := 1
DEFAULT cCodigo := ""
DEFAULT dDataIni:= dDataBase
DEFAULT dDataFim:= dDataBase
DEFAULT cRegiao := ""
DEFAULT cTipo   := ""
DEFAULT cGrupo  := ""
DEFAULT cProduto:= ""
DEFAULT nMoeda  := 0 
DEFAULT cCliente:= ""
DEFAULT cLoja   := ""
DEFAULT cTipoDoc:= '3'
DEFAULT cDupli	 := "'S'"
DEFAULT cEstoq	 := "'S'"

//������������������������������������������������������������������������Ŀ
//�Acerta o Tamanho da Variaveis                                           �
//��������������������������������������������������������������������������
cCodigo := PadR(cCodigo,Len(SA3->A3_COD))
cRegiao := PadR(cRegiao,Len(SF2->F2_REGIAO))
cTipo   := PadR(cTipo,Len(SD2->D2_TP))
cGrupo  := PadR(cGrupo,Len(SD2->D2_GRUPO))
cProduto:= PadR(cProduto,Len(SD2->D2_COD))
                    
If nTpMeta == 4
	xRetorno := { 0, 0, 0 } 
EndIf
If nTpMeta == 5
	xRetorno := {} 
EndIf 

If !Empty( cCodigo ) 
	
	#IFNDEF TOP
		//������������������������������������������������������������������������Ŀ
		//� Adiciona o proprio representante                                       �
		//��������������������������������������������������������������������������
		cFilGrupo := "{ || SA3->A3_COD=='" + cCodigo + "'"
	#ENDIF 	
	
	//������������������������������������������������������������������������Ŀ
	//� Adiciona os grupos que estao abaixo deste representante                �
	//��������������������������������������������������������������������������
	If !Empty( aGrupos := FtReprEst( cCodigo ) )
	
		#IFDEF TOP
			cIn := "( "	
		#ENDIF	
		
		For nLoop := 1 to Len( aGrupos ) 
			
		    #IFDEF TOP
				cIn       += "'" + aGrupos[ nLoop, 1 ] + "',"
			#ELSE
				cFilGrupo += ".Or.SA3->A3_GRPREP=='" + aGrupos[ nLoop, 1 ] + "'" 			
			#ENDIF	
				
		Next nLoop  
		
		#IFDEF TOP
			cIn := Left( cIn, Len( cIn ) - 1 ) + ") "	
		#ENDIF	
		
	EndIf	
		
EndIf 		


#IFDEF TOP
	If ( TcSrvType()!="AS/400" )
		Do Case
			Case ( nTpMeta == 1 )
				cQuery := "SELECT SUM(SD2.D2_TOTAL) D2_TOTAL "
			Case ( nTpMeta == 2 )
				cQuery := "SELECT SUM(SD2.D2_QUANT) D2_QUANT "
			Case ( nTpMeta == 3 )
				cQuery := "SELECT SUM(SD2.D2_TOTAL+SD2.D2_DESCON) D2_TOTAL "
			Case ( nTpMeta == 4 )
				cQuery := "SELECT SUM(SD2.D2_TOTAL) D2_TOTAL, SUM(SD2.D2_TOTAL+SD2.D2_DESCON) D2_TOTDESC,SUM(SD2.D2_QUANT) D2_QUANT "
			OtherWise
				cQuery := "SELECT D2_COD,SUM(SD2.D2_TOTAL) D2_TOTAL, SUM(SD2.D2_TOTAL+SD2.D2_DESCON) D2_TOTDESC,SUM(SD2.D2_QUANT) D2_QUANT "
		EndCase 
		
		If !Empty( nMoeda ) 	
			cQuery += ",F2_MOEDA,D2_EMISSAO "
		EndIf 
			
		cQuery += "FROM "
		
		cQuery += RetSqlName("SD2")+" SD2,"
		cQuery += RetSqlName("SF4")+" SF4,"
		cQuery += RetSqlName("SF2")+" SF2, "
		cQuery += RetSqlName("ACV")+" ACV "
		cQuery += "WHERE "
	    
    	cQuery += "SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
    	cQuery += "SF2.F2_TIPO='N' AND "
				
		If ( !Empty(dDataIni) )
			cQuery += "SF2.F2_EMISSAO>='"+Dtos(dDataIni)+"' AND "
		EndIf
		If ( !Empty(dDataFim) )
			cQuery += "SF2.F2_EMISSAO<='"+Dtos(dDataFim)+"' AND "
		EndIf
		
		If ( !Empty(cRegiao) ) 
			If cPaisLoc == "BRA"
				cQuery += "SF2.F2_REGIAO='"+cRegiao+"' AND "                                    
			Else
				cQuery += "EXISTS ( SELECT A1_REGIAO FROM " + RetSqlName( "SA1" ) + " SA1 WHERE "
				cQuery += "SA1.A1_COD=SD2.D2_CLIENTE AND SA1.A1_LOJA=SD2.D2_LOJA AND "
				cQuery += "SA1.A1_REGIAO='" + cRegiao + "' AND "
				cQuery += "SA1.D_E_L_E_T_<>'*') AND "
			Endif
		Endif
		
		If ( !Empty(cCliente) )
			cQuery += "SF2.F2_CLIENTE='"+cCliente+"' AND "
		EndIf
		If ( !Empty(cLoja) )
			cQuery += "SF2.F2_LOJA='"+cLoja+"' AND "
		EndIf           
		If cTipoDoc == '1' .Or. cTipoDoc == '3'
			cQuery += " NOT ("+IsRemito(3,'SF2.F2_TIPODOC')+") AND "			
		ElseIf cTipoDoc == '2'	
			cQuery += IsRemito(3,'SF2.F2_TIPODOC')+" AND "			
		Endif
		cQuery += "SF2.D_E_L_E_T_<>'*' AND "
		cQuery += "SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
		cQuery += "SD2.D2_SERIE=SF2.F2_SERIE AND "
		cQuery += "SD2.D2_DOC=SF2.F2_DOC AND "
		cQuery += "SD2.D2_CLIENTE=SF2.F2_CLIENTE AND "
		cQuery += "SD2.D2_LOJA=SF2.F2_LOJA AND "
		If ( !Empty(cTipo) )
			cQuery += "SD2.D2_TP='"+cTipo+"' AND "
		EndIf
		If ( !Empty(cGrupo) )
			cQuery += "SD2.D2_GRUPO='"+cGrupo+"' AND "
		EndIf
		If ( !Empty(cProduto) )
			cQuery += "SD2.D2_COD='"+cProduto+"' AND "
		EndIf
		cQuery += "SD2.D_E_L_E_T_<>'*' AND "            

	  	//������������������������������������������������������������������������Ŀ
		//�Verifica a amara��o com a categoria de produtos.                        �
		//��������������������������������������������������������������������������		
	                                 
	    If ( !Empty (cCatego) )
			cQuery += "ACV.ACV_FILIAL='"+xFilial("ACV")+"' AND "
			cQuery += "ACV.ACV_CATEGO='"+cCatego+"' AND "
			cQuery += "(ACV.ACV_CODPRO=SD2.D2_COD OR ACV.ACV_GRUPO=SD2.D2_GRUPO) AND "
			cQuery += "ACV.D_E_L_E_T_<>'*' AND "            
		Endif
    	//������������������������������������������������������������������������Ŀ
		//�Verifica os Vendedores.                                                 �
		//��������������������������������������������������������������������������		
		If !Empty( cCodigo ) 
		
			cQuery += "EXISTS ( SELECT A3_FILIAL FROM " + RetSqlName( "SA3" ) + " SA3 WHERE "
			
			If ( !Empty(cCodigo) )
		    	cVend := "1"
		    	cQuery += "("
		    	For nCntFor := 1 To nCntVend
					cQuery += "SF2.F2_VEND"+cVend+"=SA3.A3_COD OR "
					cVend := Soma1(cVend,Len(SF2->F2_VEND1))
				Next nCntFor
				cQuery := SubStr(cQuery,1,Len(cQuery)-3)+") AND "
			EndIf
			                                                                                 
			cQuery += "SA3.A3_FILIAL='"+xFilial("SA3")+"' AND "
			
	    	If Empty( cIn ) 
		    	cQuery  += "SA3.A3_COD='"+cCodigo+"' AND "
	    	Else
		    	cQuery  += "(SA3.A3_COD='"+cCodigo+"' OR SA3.A3_GRPREP IN " + cIn + " ) AND "
			EndIf	    	
			
			cQuery += "	SA3.D_E_L_E_T_<>'*' ) AND " 
			
		EndIf		
		
		cQuery += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
		cQuery += "SF4.F4_CODIGO=SD2.D2_TES AND "
		cQuery += "SF4.F4_DUPLIC IN (" + cDupli + ") AND "
		cQuery += "SF4.F4_ESTOQUE IN (" + cEstoq + ") AND "
		cQuery += "SF4.D_E_L_E_T_<>'*' "
		If nTpMeta <> 5
			If !Empty( nMoeda )
				cQuery += "GROUP BY F2_MOEDA,D2_EMISSAO" 
			EndIf 
		Else
			If !Empty( nMoeda )
				cQuery += "GROUP BY F2_MOEDA,D2_EMISSAO,D2_COD"
			Else
				cQuery += "GROUP BY D2_COD "
			EndIf
		EndIf
		
		//�������������������������������������Ŀ
		//�Seleciona as remisiones nao faturadas�
		//���������������������������������������		
		If cPaisLoc <> "BRA" .And. cTipoDoc == "3"
			cQuery += " UNION ALL "
			Do Case
				Case ( nTpMeta == 1 )
					cQuery += "SELECT SUM(SD2.D2_PRCVEN * SD2.D2_QTDAFAT) D2_TOTAL "
				Case ( nTpMeta == 2 )
					cQuery += "SELECT SUM(SD2.D2_QTDAFAT) D2_QUANT "
				Case ( nTpMeta == 3 )
					cQuery += "SELECT SUM((SD2.D2_TOTAL+SD2.D2_DESCON) * (SD2.D2_QTDAFAT / SD2.D2_QUANT)) D2_TOTAL "
				Case ( nTpMeta == 4 )
					cQuery += "SELECT SUM(SD2.D2_PRCVEN * SD2.D2_QTDAFAT) D2_TOTAL, SUM((SD2.D2_TOTAL+SD2.D2_DESCON) * (SD2.D2_QTDAFAT / SD2.D2_QUANT)) D2_TOTDESC,SUM(SD2.D2_QTDAFAT) D2_QUANT "
				OtherWise
					cQuery += "SELECT D2_COD,SUM(SD2.D2_PRCVEN * SD2.D2_QTDAFAT) D2_TOTAL, SUM((SD2.D2_TOTAL+SD2.D2_DESCON) * (SD2.D2_QTDAFAT / SD2.D2_QUANT)) D2_TOTDESC,SUM(SD2.D2_QTDAFAT) D2_QUANT "
			EndCase 
			If !Empty( nMoeda ) 	
				cQuery += ",F2_MOEDA,D2_EMISSAO "
			EndIf 
			cQuery += "FROM "
			cQuery += RetSqlName("SD2")+" SD2,"
			cQuery += RetSqlName("SF4")+" SF4,"
			cQuery += RetSqlName("SF2")+" SF2 "
			cQuery += "WHERE "
	    	cQuery += "SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
	    	cQuery += "SF2.F2_TIPO='N' AND "
			If ( !Empty(dDataIni) )
				cQuery += "SF2.F2_EMISSAO>='"+Dtos(dDataIni)+"' AND "
			EndIf
			If ( !Empty(dDataFim) )
				cQuery += "SF2.F2_EMISSAO<='"+Dtos(dDataFim)+"' AND "
			EndIf
			If ( !Empty(cRegiao) ) 
				If cPaisLoc == "BRA"
					cQuery += "SF2.F2_REGIAO='"+cRegiao+"' AND "                                    
				Else
					cQuery += "EXISTS ( SELECT A1_REGIAO FROM " + RetSqlName( "SA1" ) + " SA1 WHERE "
					cQuery += "SA1.A1_COD=SD2.D2_CLIENTE AND SA1.A1_LOJA=SD2.D2_LOJA AND "
					cQuery += "SA1.A1_REGIAO='" + cRegiao + "' AND "
					cQuery += "SA1.D_E_L_E_T_<>'*') AND "
				Endif
			Endif
			If ( !Empty(cCliente) )
				cQuery += "SF2.F2_CLIENTE='"+cCliente+"' AND "
			EndIf
			If ( !Empty(cLoja) )
				cQuery += "SF2.F2_LOJA='"+cLoja+"' AND "
			EndIf
			cQuery += IsRemito(3,'SF2.F2_TIPODOC')+" AND "
			cQuery += "SF2.D_E_L_E_T_<>'*' AND "
			cQuery += "SD2.D2_FILIAL='"+xFilial("SD2")+"' AND "
			cQuery += "SD2.D2_SERIE=SF2.F2_SERIE AND "
			cQuery += "SD2.D2_DOC=SF2.F2_DOC AND "
			cQuery += "SD2.D2_CLIENTE=SF2.F2_CLIENTE AND "
			cQuery += "SD2.D2_LOJA=SF2.F2_LOJA AND "
			If ( !Empty(cTipo) )
				cQuery += "SD2.D2_TP='"+cTipo+"' AND "
			EndIf
			If ( !Empty(cGrupo) )
				cQuery += "SD2.D2_GRUPO='"+cGrupo+"' AND "
			EndIf
			If ( !Empty(cProduto) )
				cQuery += "SD2.D2_COD='"+cProduto+"' AND "
			EndIf
			cQuery += "SD2.D2_QTDAFAT > 0 AND "
			cQuery += "SD2.D_E_L_E_T_<>'*' AND "            
	    	//������������������������������������������������������������������������Ŀ
			//�Verifica os Vendedores.                                                 �
			//��������������������������������������������������������������������������		
			If !Empty( cCodigo ) 
				cQuery += "EXISTS ( SELECT A3_FILIAL FROM " + RetSqlName( "SA3" ) + " SA3 WHERE "
				If ( !Empty(cCodigo) )
			    	cVend := "1"
			    	cQuery += "("
			    	For nCntFor := 1 To nCntVend
						cQuery += "SF2.F2_VEND"+cVend+"=SA3.A3_COD OR "
						cVend := Soma1(cVend,Len(SF2->F2_VEND1))
					Next nCntFor
					cQuery := SubStr(cQuery,1,Len(cQuery)-3)+") AND "
				EndIf                                                                        
				cQuery += "SA3.A3_FILIAL='"+xFilial("SA3")+"' AND "
		    	If Empty( cIn ) 
			    	cQuery  += "SA3.A3_COD='"+cCodigo+"' AND "
		    	Else
			    	cQuery  += "(SA3.A3_COD='"+cCodigo+"' OR SA3.A3_GRPREP IN " + cIn + " ) AND "
				EndIf	    	
				cQuery += "	SA3.D_E_L_E_T_<>'*' ) AND " 
			EndIf
			cQuery += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
			cQuery += "SF4.F4_CODIGO=SD2.D2_TES AND "
			cQuery += "SF4.F4_DUPLIC IN (" + cDupli + ") AND "
			cQuery += "SF4.F4_ESTOQUE IN (" + cEstoq + ") AND "
			cQuery += "SF4.D_E_L_E_T_<>'*' "

			If nTpMeta <> 5
				If !Empty( nMoeda )
					cQuery += "GROUP BY F2_MOEDA,D2_EMISSAO" 
				EndIf 
			Else
				If !Empty( nMoeda )
					cQuery += "GROUP BY F2_MOEDA,D2_EMISSAO,D2_COD"
				Else
					cQuery += "GROUP BY D2_COD "
				EndIf
			EndIf
		Endif
					
		cQuery := ChangeQuery(cQuery)      
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
		If ( nTpMeta == 1 .Or. nTpMeta == 3 )
			TcSetField(cArqQry,"D2_TOTAL","N",18,2)
		ElseIf nTpMeta == 2
			TcSetField(cArqQry,"D2_QUANT","N",18,2)
		Else
			TcSetField(cArqQry,"D2_QUANT"  ,"N",18,2)
			TcSetField(cArqQry,"D2_TOTAL"  ,"N",18,2)
			TcSetField(cArqQry,"D2_TOTDESC","N",18,2)
		EndIf
		
		If !Empty( nMoeda ) 
			TcSetField(cArqQry,"F2_MOEDA"  ,"N",2,0)
			TcSetField(cArqQry,"D2_EMISSAO","D",8,0)
		EndIf 						
		
		While ( !Eof() )
			Do Case
				Case ( nTpMeta == 1 .Or. nTpMeta == 3 )
					xRetorno += If( Empty( nMoeda ), D2_TOTAL, xMoeda( D2_TOTAL, F2_MOEDA, nMoeda, D2_EMISSAO ) )
				Case nTpMeta == 2
					xRetorno += D2_QUANT
				Case nTpMeta == 4
					xRetorno[ 1 ] += If( Empty( nMoeda ), D2_TOTAL, xMoeda( D2_TOTAL, F2_MOEDA, nMoeda, D2_EMISSAO ) )
					xRetorno[ 2 ] += D2_QUANT
					xRetorno[ 3 ] += If( Empty( nMoeda ), D2_TOTDESC, xMoeda( D2_TOTDESC, F2_MOEDA, nMoeda, D2_EMISSAO ) )
				OtherWise
					nX := aScan(xRetorno,{|x| x[1] == D2_COD})
					If nX == 0
						aadd(xRetorno,{D2_COD,0,0,0})
						nX := Len(xRetorno)
					EndIf
					xRetorno[nX][2] += If( Empty( nMoeda ), D2_TOTAL, xMoeda( D2_TOTAL, F2_MOEDA, nMoeda, D2_EMISSAO ) )
					xRetorno[nX][3] += D2_QUANT
					xRetorno[nX][4] += If( Empty( nMoeda ), D2_TOTDESC, xMoeda( D2_TOTDESC, F2_MOEDA, nMoeda, D2_EMISSAO ) )
			EndCase
			dbSelectArea(cArqQry)
			dbSkip()		
		EndDo
		dbSelectArea(cArqQry)
		dbCloseArea()
		dbSelectArea("SD2")
	Else
#ENDIF         
		//������������������������������������������������������������������������Ŀ
		//�Efetua a selecao dos registros                                          �
		//��������������������������������������������������������������������������
		dbSelectArea("SD2")
		dbSetOrder(5)
		cSeek  := xFilial("SD2")+AllTrim(Dtos(dDataIni))
		cComp  := "SD2->D2_FILIAL=='"+xFilial("SD2")+"'"
		If ( !Empty(dDataIni) )
			cComp += ".And. Dtos(SD2->D2_EMISSAO)>='"+Dtos(dDataIni)+"'"
		EndIf
		If ( !Empty(dDataFim) )
			cComp += ".And. Dtos(SD2->D2_EMISSAO)<='"+Dtos(dDataFim)+"'"
		EndIf
		MsSeek(cSeek,.T.)
		While ( !Eof() .And. &cComp )
			//������������������������������������������������������������������������Ŀ
			//�Posiciona Registros.                                                    �
			//��������������������������������������������������������������������������
			dbSelectArea("SF2")
			dbSetOrder(1)
			MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)

			If cTipoDoc == '3' .Or. (cTipoDoc == '1' .And. !IsRemito(1,'SF2->F2_TIPODOC')).Or.;
					(cTipoDoc == '2' .And. IsRemito(1,'SF2->F2_TIPODOC'))
				If !IsRemito(1,"SD2->D2_TIPODOC") .Or. SD2->D2_QTDAFAT > 0
					dbSelectArea("SF4")
					dbSetOrder(1)
					MsSeek(xFilial("SF4")+SD2->D2_TES)
					cVend := "1"
					lVend := .F.
					If ( !Empty(cCodigo) )
				    	For nCntFor := 1 To nCntVend
						
							//������������������������������������������������������������������������Ŀ
							//� Pesquisa por todos os vendedores do SF2 no SA3                         �
							//��������������������������������������������������������������������������
					
							cCodVend := SF2->(FieldGet(FieldPos("F2_VEND"+cVend))) 
						
							SA3->( dbSetOrder( 1 ) ) 
							If SA3->( MsSeek( xFilial( "SA3" ) + cCodVend ) )  
						
								//������������������������������������������������������������������������Ŀ
								//� Verifica se eh o proprio vendedor ou se o vendedor esta                �
								//� no grupo de vendedores validos                                         �								
								//��������������������������������������������������������������������������
							    If SA3->A3_COD == cCodigo .Or. !Empty( AScan( aGrupos, { |x| x[1]==SA3->A3_GRPREP } ) )
									lVend := .T. 
								EndIf
							EndIf 					
	
							cVend := Soma1(cVend,Len(SF2->F2_VEND1))
							If ( lVend )
								Exit 
							EndIf
						
						Next nCntFor
					Else
						lVend := .T.					
					EndIf
					cRegiaoNF := SF2->F2_REGIAO
					If cPaisLoc <> "BRA" .And. !Empty(cRegiao)
						If Empty(cRegiaoNF)
							cRegiaoNF := Posicione("SA1",1,xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA,"A1_REGIAO")
						Endif
					Endif
					If ((Empty(cRegiao).Or.cRegiao==cRegiaoNF).And.;
						( lVend .And. SF2->F2_TIPO=='N') .And.;
						(Empty(cTipo).Or.cTipo==SD2->D2_TP).And.;
						(Empty(cGrupo).Or.cGrupo==SD2->D2_GRUPO).And.;
						(Empty(cProduto).Or.cProduto==SD2->D2_COD).And.;
						(Empty(cCliente).Or.cCliente==SD2->D2_CLIENTE).And.;
						(Empty(cLoja).Or.cLoja==SD2->D2_LOJA).And.;
						(SF4->F4_DUPLIC $ cDupli .And. SF4->F4_ESTOQUE $ cEstoq)) 
		
						If IsRemito(1,"SD2->D2_TIPODOC")
							Do Case
								Case ( nTpMeta == 1 )
									nVlrAux := SD2->D2_PRCVEN * SD2->D2_QTDAFAT
									xRetorno += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
								Case ( nTpMeta == 2 )
									xRetorno += SD2->D2_QTDAFAT
								Case ( nTpMeta == 3 )
									nVlrAux := (SD2->D2_TOTAL+SD2->D2_DESCON) * (SD2->D2_QTDAFAT / SD2->D2_QUANT)
									xRetorno += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
								Case ( nTpMeta == 4 )
									nVlrAux := SD2->D2_PRCVEN * SD2->D2_QTDAFAT
									xRetorno[ 1 ] += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
									xRetorno[ 2 ] += SD2->D2_QTDAFAT
									nVlrAux := (SD2->D2_TOTAL+SD2->D2_DESCON) * (SD2->D2_QTDAFAT / SD2->D2_QUANT)
									xRetorno[ 3 ] += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
								OtherWise
									nX := aScan(xRetorno,{|x| X[1] == SD2->D2_COD})
									If nX == 0
										aadd(xRetorno,{SD2->D2_COD,0,0,0})
										nX := Len(xRetorno)
									EndIf
									nVlrAux := SD2->D2_PRCVEN * SD2->D2_QTDAFAT
									xRetorno[nX][2] += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
									xRetorno[nX][3] += SD2->D2_QTDAFAT
									nVlrAux := (SD2->D2_TOTAL+SD2->D2_DESCON) * (SD2->D2_QTDAFAT / SD2->D2_QUANT)
									xRetorno[nX][4] += If( Empty( nMoeda ), nVlrAux, xMoeda( nVlrAux, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
							EndCase
						Else
							Do Case
								Case ( nTpMeta == 1 )
									xRetorno += If( Empty( nMoeda ), SD2->D2_TOTAL, xMoeda( SD2->D2_TOTAL, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
								Case ( nTpMeta == 2 )
									xRetorno += SD2->D2_QUANT
								Case ( nTpMeta == 3 )
									xRetorno += If( Empty( nMoeda ), SD2->D2_TOTAL+SD2->D2_DESCON, xMoeda( SD2->D2_TOTAL+SD2->D2_DESCON, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
								Case ( nTpMeta == 4 )
									xRetorno[ 1 ] += If( Empty( nMoeda ), SD2->D2_TOTAL, xMoeda( SD2->D2_TOTAL, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
									xRetorno[ 2 ] += SD2->D2_QUANT
									xRetorno[ 3 ] += If( Empty( nMoeda ), SD2->D2_TOTAL+SD2->D2_DESCON, xMoeda( SD2->D2_TOTAL+SD2->D2_DESCON, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
								OtherWise
									nX := aScan(xRetorno,{|x| X[1] == SD2->D2_COD})
									If nX == 0
										aadd(xRetorno,{SD2->D2_COD,0,0,0})
										nX := Len(xRetorno)
									EndIf
									xRetorno[nX][2] += If( Empty( nMoeda ), SD2->D2_TOTAL, xMoeda( SD2->D2_TOTAL, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
									xRetorno[nX][3] += SD2->D2_QUANT
									xRetorno[nX][4] += If( Empty( nMoeda ), SD2->D2_TOTAL+SD2->D2_DESCON, xMoeda( SD2->D2_TOTAL+SD2->D2_DESCON, SF2->F2_MOEDA, nMoeda, SD2->D2_EMISSAO ) )
							EndCase
						Endif
					EndIf
				Endif
			Endif
			dbSelectArea("SD2")
			dbSkip()
		EndDo
		
#IFDEF TOP
	EndIf
#ENDIF
RestArea(aAreaSD2)
RestArea(aAreaSF2)
RestArea(aAreaSF4)
RestArea(aAreaSA3)
RestArea(aArea)
Return(xRetorno)

