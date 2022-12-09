#INCLUDE "MATR900.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR900  � Autor � Nereu Humberto Junior � Data � 25.07.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Kardex fisico - financeiro                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function KDXMTL()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	MATR900R3()
EndIf

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Nereu Humberto Junior  � Data �25.07.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relatorio                                  ���
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
Local oSection1
Local oSection2
Local oSection3
Local oCell         
Local aOrdem      := {}
Local aSB1Cod     := {}
Local aSB1Ite     := {}
Local cPicB2Qt    := PesqPictQt("B2_QATU" ,18)
Local cTamB2Qt    := TamSX3('B2_QATU')[1]
Local cPicB2Cust  := PesqPict("SB2","B2_CM1",18)
Local cTamB2Cust  := TamSX3('B2_CM1')[1]
Local cPicD1Qt    := PesqPict("SD1","D1_QUANT" ,18)
Local cTamD1Qt    := TamSX3('D1_QUANT')[1]
Local cPicD1Cust  := PesqPict("SD1","D1_CUSTO",18)
Local cTamD1Cust  := TamSX3('D1_CUSTO')[1]
Local cPicD2Qt    := PesqPict("SD2","D2_QUANT" ,18)
Local cTamD2Qt    := TamSX3('D2_QUANT')[1]
Local cPicD2Cust  := PesqPict("SD2","D2_CUSTO1",18)
Local cTamD2Cust  := TamSX3('D2_CUSTO1')[1]
Local cTamD1CF    := TamSX3('D1_CF')[1]
Local cTamCCPVPJOP:= TamSX3(MaiorCampo("D3_CC;D3_PROJPMS;D3_OP;D2_CLIENTE"))[1] 
Local lVEIC       := Upper(GetMV("MV_VEICULO"))=="S"
Local nTamSX1	  := Len(SX1->X1_GRUPO)
Local nTamData 	  := IIF(__SetCentury(),10,8)
Local lVer116     := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)

//��������������������������������������������������������������Ŀ
//�MV_CUSFIL - Parametro utilizado para verificar se o sistema   |
//|utiliza custo unificado por:                                  |
//|      F = Custo Unificado por Filial                          |
//|      E = Custo Unificado por Empresa                         |
//|      A = Custo Unificado por Armazem                         | 
//����������������������������������������������������������������
Local lCusFil    := AllTrim(SuperGetMV('MV_CUSFIL' ,.F.,"A")) == "F"
Local lCusEmp    := AllTrim(SuperGetMv('MV_CUSFIL' ,.F.,"A")) == "E"


//��������������������������������������������������������������Ŀ
//�MV_CUSREP - Parametro utilizado para habilitar o calculo do   �
//�            Custo de Reposicao.                               �
//����������������������������������������������������������������
Local lCusRep  := SuperGetMv("MV_CUSREP",.F.,.F.) .And. (FindFunction("MA330AvRep") .And. MA330AvRep())

//��������������������������������������������������������������Ŀ
//� Ajusta perguntas no SX1 a fim de preparar o relatorio p/     �
//� custo unificado por empresa                                  �
//����������������������������������������������������������������
If lCusFil .Or. lCusEmp
	MTR900CUnf(lCusFil,lCusEmp)
EndIf

//�����������������������������������������������������������������Ŀ
//| Checa versao dos fontes relacionados. NAO REMOVER !!!           �
//�������������������������������������������������������������������
If !(FindFunction("SIGACUSA_V")	.And. SIGACUSA_V() >= 20091212)
	Final(OemToAnsi(STR0062)) //"Atualizar SIGACUSA.PRX"
EndIf
If !(FindFunction("SIGACUSB_V")	.And. SIGACUSB_V() >= 20091212)
	Final(OemToAnsi(STR0063)) //"Atualizar SIGACUSB.PRX"
EndIf
If !(FindFunction("MATXFUNB_V")	.And. MATXFUNB_V() >= 20091212)
	Final(OemToAnsi(STR0064)) //"Atualizar MATXFUNB.PRX"
EndIf
If !(FindFunction("MATA330_V")	.And. MATA330_V() >= 20091212)
	Final(OemToAnsi(STR0067)) //"Atualizar MATA330.PRX"
EndIf

//��������������������������������������������������������������Ŀ
//� Ajusta perguntas no SX1 									 �
//����������������������������������������������������������������
AjustaSX1()

//��������������������������������������������������������������Ŀ
//� Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                �
//����������������������������������������������������������������
aSB1Cod	:= TAMSX3("B1_COD")
aSB1Ite	:= TAMSX3("B1_CODITE")

If lVeic
   dbSelectArea("SX1")
   dbSetOrder(1)
   dbSeek(PADR("MTR900",nTamSX1))
   Do While SX1->X1_GRUPO == PADR("MTR900",nTamSX1) .And. !SX1->(Eof())
      If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. ;
	     (SX1->X1_TAMANHO <> aSB1Ite[1] .Or. Upper(SX1->X1_F3) <> "VR4")
         RecLock("SX1",.F.)
         SX1->X1_TAMANHO := aSB1Ite[1]
         SX1->X1_F3 := "VR4"
         dbCommit()
         MsUnlock()
      EndIf
      dbSkip()
   EndDo
   dbCommitAll()
Else
   dbSelectArea("SX1")
   dbSetOrder(1)
   dbSeek(PADR("MTR900",nTamSX1))
   Do While SX1->X1_GRUPO == PADR("MTR900",nTamSX1) .And. !SX1->(Eof())
      If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. ;
  	     (SX1->X1_TAMANHO <> aSB1Cod[1] .Or. Upper(SX1->X1_F3) <> "SB1")
         RecLock("SX1",.F.)
         SX1->X1_TAMANHO := aSB1Cod[1]
         SX1->X1_F3 := "SB1"
         dbCommit()
         MsUnlock()
      EndIf
      dbSkip()
   EndDo
   dbCommitAll()
EndIf
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
oReport:= TReport():New("MATR900",STR0001,"MTR900", {|oReport| ReportPrint(oReport)},STR0002+" "+STR0003)
oReport:SetLandscape()    
oReport:SetTotalInLine(.F.)

//���������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                      �
//�����������������������������������������������������������
//����������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                     �
//� mv_par01         // Do produto                           �
//� mv_par02         // Ate o produto                        �
//� mv_par03         // Do tipo                              �
//� mv_par04         // Ate o tipo                           �
//� mv_par05         // Da data                              �
//� mv_par06         // Ate a data                           �
//� mv_par07         // Lista produtos s/movimento           �
//� mv_par08         // Qual Local (almoxarifado)            �
//� MV_par09         // (d)OCUMENTO/(s)EQUENCIA              �
//� mv_par10         // moeda selecionada ( 1 a 5 )          �
//� mv_par11         // Seq.de Digitacao /Calculo            �
//� mv_par12         // Pagina Inicial                       �
//� mv_par13         // Lista Transf Locali (Sim/Nao)        �
//� mv_par14         // Do  Grupo                            �
//� mv_par15         // Ate o Grupo                          �
//� mv_par16         // Seleciona Filial?                    �
//� mv_par17         // Qual Custo ? ( Medio / Reposicao )   �
//������������������������������������������������������������
Pergunte("MTR900",.F.)

Aadd( aOrdem, STR0004 ) // " Codigo Produto "
Aadd( aOrdem, STR0005 ) // " Tipo do Produto"

//��������������������������������������������������������������Ŀ
//� Definicao da Sessao 1 - Dados do Produto                     �
//����������������������������������������������������������������
oSection1 := TRSection():New(oReport,STR0059,{"SB1","SB2"},aOrdem) //"Produtos (Parte 1)"
oSection1 :SetTotalInLine(.F.)
oSection1 :SetReadOnly()
oSection1 :SetLineStyle()

If lVeic
	TRCell():New(oSection1,"B1_CODITE","SB1",/*Titulo*/					,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
EndIf
TRCell():New(oSection1,"cProduto"	,"   ",/*Titulo*/					,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("cProduto"):GetFieldInfo("B1_COD")
TRCell():New(oSection1,"B1_DESC"	,"SB1",/*Titulo*/					,/*Picture*/,30				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_UM"		,"SB1",STR0053						,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"cTipo"		,"   ",STR0054						,"@!"		,2				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_GRUPO"	,"SB1",STR0055						,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"nCusMed"	,"   ",IIf(lCusRep .And. mv_par17==2,STR0068,STR0056)	,cPicB2Cust	,cTamB2Cust		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"nQtdSal"	,"   ",STR0034						,cPicB2Qt	,cTamB2Qt		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"nVlrSal"	,"   ",STR0035						,cPicB2Cust	,cTamB2Cust		,/*lPixel*/,/*{|| code-block de impressao }*/)
//��������������������������������������������������������������Ŀ
//� Definicao da Sessao 2 - Cont. dos dados do Produto           �
//����������������������������������������������������������������
If lVer116
	oSection2 := TRSection():New(oSection1,STR0060,{"SB1","SB2","NNR"}) //"Produtos (Parte 2)"
Else
	oSection2 := TRSection():New(oSection1,STR0060,{"SB1","SB2"}) //"Produtos (Parte 2)"
EndIf	
oSection2 :SetTotalInLine(.F.)
oSection2 :SetReadOnly()
oSection2 :SetLineStyle()

If lVeic
	TRCell():New(oSection2	,"cProduto"		,"   ",/*Titulo*/	,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	oSection2:Cell("cProduto"):GetFieldInfo("B1_COD")
	TRCell():New(oSection2	,"B1_UM"		,"SB1",STR0053		,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2	,"cTipo"		,"   ",STR0054		,"@!"			,2			,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2	,"B1_GRUPO"		,"SB1",STR0055		,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
Endif	
If cPaisLoc<>"CHI"
	TRCell():New(oSection2	,"B1_POSIPI"	,"SB1",STR0057		,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
Endif	

If lVer116
	TRCell():New(oSection2		,'NNR_DESCRI'	,"NNR",STR0058		,/*Picture*/	,/*Tamanho*/,/*lPixel*/,{|| If(lCusFil .Or. lCusEmp , MV_PAR08 , Posicione("NNR",1,xFilial("NNR")+MV_PAR08,"NNR_DESCRI")) })
Else
	TRCell():New(oSection2		,"B2_LOCALIZ"	,"SB2",STR0058		,/*Picture*/	,/*Tamanho*/,/*lPixel*/,{|| If(lCusFil .Or. lCusEmp , MV_PAR08 , SB2->B2_LOCALIZ) })
EndIf
//��������������������������������������������������������������Ŀ
//� Definicao da Sessao 3 - Movimentos                           �
//����������������������������������������������������������������
oSection3 := TRSection():New(oSection2,STR0061,{"SD1","SD2","SD3"}) //"Movimenta��o dos Produtos"
oSection3 :SetHeaderPage()
oSection3 :SetTotalInLine(.F.)
oSection3 :SetTotalText(STR0021) //"T O T A I S  :"
oSection3 :SetReadOnly()

TRCell():New(oSection3,"dDtMov"		,"   ",STR0036+CRLF+STR0037	,/*Picture*/,nTamData		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTES"		,"   ",STR0038				,"@!"		,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cCF"		,"   ",STR0039				,"@!"		,cTamD1CF		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cDoc"		,"   ",STR0040+CRLF+STR0041	,"@!"		,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco1"	,"   ","|"+CRLF+"|"			,/*Picture*/,1		   		,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"cLote"		,"   ",'Numero'+CRLF+'Lote'	,"@!"		,9,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco1"	,"   ","|"+CRLF+"|"			,/*Picture*/,1		   		,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nENTQtd"	,"   ",STR0042+CRLF+STR0043	,cPicD1Qt	,cTamD1Qt  		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco2"	,"   ","|"+CRLF+"|"			,/*Picture*/,1		   		,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nENTCus"	,"   ",STR0042+CRLF+STR0044	,cPicD1Cust	,cTamD1Cust		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco3"	,"   ","|"+CRLF+"|"			,/*Picture*/,1		   		,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nCusMov"	,"   ",STR0045+CRLF+STR0046	,cPicB2Cust	,cTamB2Cust		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco4"	,"   ","|"+CRLF+"|"			,/*Picture*/,1		   		,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nSAIQtd"	,"   ",STR0047+CRLF+STR0043	,cPicD2Qt	,cTamD2Qt		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco5"	,"   ","|"+CRLF+"|"			,/*Picture*/,1				,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nSAICus"	,"   ",STR0047+CRLF+STR0044	,cPicD2Cust	,cTamD2Cust		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco6"	,"   ","|"+CRLF+"|"			,/*Picture*/,1				,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nSALDQtd"	,"   ",STR0048+CRLF+STR0043	,cPicB2Qt	,cTamB2Qt		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco7"	,"   ","|"+CRLF+"|"			,/*Picture*/,1				,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"nSALDCus"	,"   ",STR0048+CRLF+STR0049	,cPicB2Cust	,cTamB2Cust		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"cTraco8"	,"   ","|"+CRLF+"|"			,/*Picture*/,1		   		,/*lPixel*/,{|| "|" })
TRCell():New(oSection3,"cCCPVPJOP"	,"   ",STR0050+CRLF+STR0051 ,"@!"		,cTamCCPVPJOP+2 ,/*lPixel*/,/*{|| code-block de impressao }*/)

// Definir o formato de valores negativos (para o caso de devolucoes)
oSection3:Cell("nENTQtd"):SetNegative("PARENTHESES")
oSection3:Cell("nENTCus"):SetNegative("PARENTHESES")
oSection3:Cell("nSAIQtd"):SetNegative("PARENTHESES")
oSection3:Cell("nSAICus"):SetNegative("PARENTHESES")

TRFunction():New(oSection3:Cell("nENTQtd")	,NIL,"SUM"		,/*oBreak*/,"",cPicD1Qt		,{|| oSection3:Cell("nENTQtd"):GetValue(.T.) },.T.,.F.)
TRFunction():New(oSection3:Cell("nENTCus")	,NIL,"SUM"		,/*oBreak*/,"",cPicD1Cust	,{|| oSection3:Cell("nENTCus"):GetValue(.T.) },.T.,.F.)

TRFunction():New(oSection3:Cell("nSAIQtd")	,NIL,"SUM"		,/*oBreak*/,"",cPicD2Qt		,{|| oSection3:Cell("nSAIQtd"):GetValue(.T.) },.T.,.F.)
TRFunction():New(oSection3:Cell("nSAICus")	,NIL,"SUM"		,/*oBreak*/,"",cPicD2Cust	,{|| oSection3:Cell("nSAICus"):GetValue(.T.) },.T.,.F.)

TRFunction():New(oSection3:Cell("nSALDQtd")	,NIL,"ONPRINT"	,/*oBreak*/,"",cPicB2Qt		,{|| oSection3:Cell("nSALDQtd"):GetValue(.T.) },.T.,.F.)
TRFunction():New(oSection3:Cell("nSALDCus")	,NIL,"ONPRINT"	,/*oBreak*/,"",cPicB2Cust	,{|| oSection3:Cell("nSALDCus"):GetValue(.T.) },.T.,.F.)

oSection3:SetNoFilter("SD1")
oSection3:SetNoFilter("SD2")
oSection3:SetNoFilter("SD3")

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Nereu Humberto Junior  � Data �21.06.2006���
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
Static Function ReportPrint(oReport)

Static lIxbConTes := NIL

Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(1):Section(1)  
Local oSection3 := oReport:Section(1):Section(1):Section(1)  
Local nOrdem    := oReport:Section(1):GetOrder() 
Local cSelectD1 := '', cWhereD1 := '', cWhereD1C := ''
Local cSelectD2 := '', cWhereD2 := '', cWhereD2C := ''
Local cSelectD3 := '', cWhereD3 := '', cWhereD3C := ''
Local cSelectVe := '%%', cUnion := '%%'
Local aDadosTran:= {}
Local lContinua := .F.
Local lFirst    := .T. 
Local lTransEnd := .T.
Local aSalAtu   := { 0,0,0,0,0,0,0 }
Local cPicB2Qt2 := PesqPictQt("B2_QTSEGUM" ,18)
Local cTRBSD1	:= CriaTrab(,.F.)
Local cTRBSD2	:= Subs(cTrbSD1,1,7)+"A"
Local cTRBSD3	:= Subs(cTrbSD1,1,7)+"B"
Local cSeqIni 	:= Replicate("z",6)
Local nRegTr    := 0
Local nTotRegs  := 0
Local nInd      := 0
Local cProdAnt  := ""
Local cLocalAnt := ""
Local cIndice	:= ""
Local cCampo1   := ""
Local cCampo2   := ""
Local cCampo3   := ""
Local cCampo4   := ""
Local cNumSeqTr := "" 
Local cAlias    := ""
Local cTipoNf   := ""
// Indica se esta listando relatorio do almox. de processo
Local lLocProc  := alltrim(mv_par08) == GetMv("MV_LOCPROC")
// Indica se deve imprimir movimento invertido (almox. de processo)
Local lInverteMov :=.F.
Local lPriApropri :=.T.
//��������������������������������������������������������������Ŀ
//� Verifica se existe ponto de entrada                          �
//����������������������������������������������������������������
Local lTesNEst := .F.
//��������������������������������������������������������������Ŀ
//� Codigo do produto importado - NAO DEVE SER LISTADO           �
//����������������������������������������������������������������
Local cProdImp := GetMV("MV_PRODIMP")

Local cWhereB1A:= " " 
Local cWhereB1B:= " " 
Local cWhereB1C:= " " 
Local cWhereB1D:= " " 

Local cQueryB1A:= " " 
Local cQueryB1B:= " " 
Local cQueryB1C:= " " 
Local cQueryB1D:= " " 

//��������������������������������������������������������������Ŀ
//� Concessionaria de Veiculos                                   �
//����������������������������������������������������������������
Local lVEIC    := Upper(GetMV("MV_VEICULO"))=="S"

Local lImpSMov := .F.
Local lImpS3   := .F.
LOCAL cProdMNT := GetMv("MV_PRODMNT")
LOCAL cProdTER := GetMv("MV_PRODTER")
Local aProdsMNT := {}

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para processamento de Filiais           �
//����������������������������������������������������������������
Local aFilsCalc := MatFilCalc( Iif (!IsBlind(), mv_par16 == 1, .F.))
Local cFilBack  := cFilAnt
Local nForFilial:= 0

//�����������������������������������������������������Ŀ
//� Variavel utilizada para inicar a pagina do relatorio�
//�������������������������������������������������������
Local n_pag     := mv_par12
Local cAliasTop := ""
Local cCondicao := ""  
Local cFilUsrSB1:= oSection1:GetAdvplExp("SB1")
Local cFilUsrSB2:= oSection1:GetAdvplExp("SB2")

#IFDEF TOP  
	If !(TcSrvType()=="AS/400") .And. !("POSTGRES" $ TCGetDB())
		cAliasTop := GetNextAlias()
	Else
#ENDIF 
	cCondicao := ""
#IFDEF TOP
	EndIf
#ENDIF

Private bBloco   := { |nV,nX| Trim(nV)+IIf(Valtype(nX)='C',"",Str(nX,1)) }

//��������������������������������������������������������������Ŀ
//�MV_CUSREP - Parametro utilizado para habilitar o calculo do   �
//�            Custo de Reposicao.                               �
//����������������������������������������������������������������
Private lCusRep  := SuperGetMv("MV_CUSREP",.F.,.F.) .And. (FindFunction("MA330AvRep") .And. MA330AvRep())

cProdMNT := cProdMNT + Space(15-Len(cProdMNT))
cProdTER := cProdTER + Space(15-Len(cProdTER))

//��������������������������������������������������������������Ŀ
//�MV_CUSFIL - Parametro utilizado para verificar se o sistema   |
//|utiliza custo unificado por:                                  |
//|      F = Custo Unificado por Filial                          |
//|      E = Custo Unificado por Empresa                         |
//|      A = Custo Unificado por Armazem                         | 
//����������������������������������������������������������������
Private lCusFil    := AllTrim(SuperGetMV('MV_CUSFIL' ,.F.,"A")) == "F"
Private lCusEmp    := AllTrim(SuperGetMv('MV_CUSFIL' ,.F.,"A")) == "E"

lCusFil:=lCusFil .And. mv_par08 == Repl("*",TamSX3("B2_LOCAL")[1])
lCusEmp:=lCusEmp .And. mv_par08 == Repl("#",TamSX3("B2_LOCAL")[1])

Private lDev := .F. // Flag que indica se nota � devolu�ao (.T.) ou nao (.F.)

oReport:SetPageNumber(n_pag)
//��������������������������������������������������������������Ŀ
//� Alerta o usuario que o custo de reposicao esta desativado.   �
//����������������������������������������������������������������
If mv_par17==2 .And. !lCusRep
	Help(" ",1,"A910CUSRP")
	mv_par17 := 1
EndIf

//��������������������������������������������������������������Ŀ
//� aFilsCalc - Array com filiais a serem processadas            �
//����������������������������������������������������������������
If !Empty(aFilsCalc)

	For nForFilial := 1 To Len( aFilsCalc )
	
		If aFilsCalc[ nForFilial, 1 ]
		
			cFilAnt := aFilsCalc[ nForFilial, 2 ]

			oReport:EndPage() //Reinicia Pagina
			
			oReport:SetTitle(OemToAnsi(STR0008) + IIf(mv_par11==1,IIf(lCusRep .And. mv_par17==2,STR0065,STR0009),IIf(lCusRep .And. mv_par17==2,STR0066,STR0010) ) + " " + IIf(lCusFil .Or. lCusEmp,"",OemToAnsi(STR0011)+" "+mv_par08) ) // "KARDEX FISICO-FINANCEIRO "###"(SEQUENCIA)"###"(CALCULO)"###"L O C A L :"
			If nOrdem == 1
				oReport:SetTitle( oReport:Title()+Alltrim(STR0017+STR0004+STR0018+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par10))))+")")+' - ' + aFilsCalc[ nForFilial, 3 ] ) //" (Por "###" ,em "
			Else
				oReport:SetTitle( oReport:Title()+Alltrim(STR0017+STR0005+STR0018+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par10))))+")")+' - ' + aFilsCalc[ nForFilial, 3 ] ) //" (Por "###" ,em "
			EndIf
				
			If lVeic
				oSection1:Cell("cProduto"	):Disable()
				oSection1:Cell("B1_UM"		):Disable()
				oSection1:Cell("cTipo"		):Disable()
				oSection1:Cell("B1_GRUPO"	):Disable()
			EndIf
				
			If mv_par09 $ "Ss"
				oSection3:Cell("cDoc"):SetTitle(STR0052+CRLF+STR0041) //"SEQUENCIA"
			EndIf	

			dbSelectArea("SD1")   // Itens de Entrada
			nTotRegs += LastRec()
			
			dbSelectArea("SD2")   // Itens de Saida
			nTotRegs += LastRec()
			
			dbSelectArea("SD3")   // movimentacoes internas (producao/requisicao/devolucao)
			nTotRegs += LastRec()
			
			dbSelectArea("SB2")  // Saldos em estoque
			dbSetOrder(1)
			nTotRegs += LastRec()
			
			//������������������������������������������������������������������������Ŀ
			//�MTAAVLTES - Ponto de Entrada executado durante a montagem do relatorio  |
			//|            para verificar se devera considerar TES que nao atualiza    |
			//|            saldos em estoque.                                          |
			//��������������������������������������������������������������������������
			lIxbConTes := IF(lIxbConTes == NIL,ExistBlock("MTAAVLTES"),lIxbConTes)

			//������������������������������������������������������������������������Ŀ
			//�Filtragem do relatorio                                                  �
			//��������������������������������������������������������������������������
			#IFDEF TOP
				If !(TcSrvType()=="AS/400") .And. !("POSTGRES" $ TCGetDB())
				//������������������������������������������������������������������������Ŀ
				//�Transforma parametros Range em expressao SQL                            �	
				//��������������������������������������������������������������������������
				MakeSqlExpr(oReport:uParam)
				 
				//������������������������������������������������������������������������Ŀ
				//�Query do relatorio da secao 1                                           �
				//��������������������������������������������������������������������������
				oReport:Section(1):BeginQuery()	
				
				//������������������������������������������������������������������������Ŀ
				//�Complemento do SELECT da tabela SD1                                     �
				//��������������������������������������������������������������������������
				If lCusRep .And. mv_par17==2
					cSelectD1 := "% D1_CUSRP"
					cSelectD1 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
				Else
					cSelectD1 := "% D1_CUSTO"
					If mv_par10 > 1
						cSelectD1 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
					EndIf
				EndIf	
				cSelectD1 += " CUSTO,"
				cSelectD1 += "%"
				//������������������������������������������������������������������������Ŀ
				//�Complemento do SELECT da tabela SB1 para MV_VEICULO                     �
				//��������������������������������������������������������������������������	
				cSelectVe := "%" 
				cSelectVe += ","
				If lVEIC
					cSelectVe += "SB1.B1_CODITE B1_CODITE,"
				EndIf
				cSelectVe += "%" 
				//������������������������������������������������������������������������Ŀ
				//�Complemento do Where da tabela SD1                                      �
				//��������������������������������������������������������������������������	
				cWhereD1 := "%" 
				cWhereD1 += "AND" 
				If !(lCusFil .Or. lCusEmp)
					cWhereD1 += " D1_LOCAL = '" + mv_par08 + "' AND"
				EndIf
				cWhereD1 += "%" 
				//������������������������������������������������������������������������Ŀ
				//�Complemento do Where da tabela SD1 (Tratamento Filial)                  �
				//��������������������������������������������������������������������������	
				If lCusEmp
					If !Empty(xFilial("SD1")) .And. !Empty(xFilial("SF4"))
						cWhereD1C := "%"
						cWhereD1C += " D1_FILIAL = F4_FILIAL AND "
						cWhereD1C += "%"
					Else
						cWhereD1C := "% %"
					EndIf	
				Else
					cWhereD1C := "%"
					cWhereD1C += " D1_FILIAL ='" + xFilial("SD1") + "' AND "
					cWhereD1C += " SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND"
					cWhereD1C += "%"
				EndIf	
				//������������������������������������������������������������������������Ŀ
				//�Complemento do SELECT da tabela SD2                                     �
				//��������������������������������������������������������������������������
				If lCusRep .And. mv_par17==2
				    cSelectD2 := "% D2_CUSRP"
					cSelectD2 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
				Else
				    cSelectD2 := "% D2_CUSTO"
					cSelectD2 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
				EndIf	
				cSelectD2 += " CUSTO,"
			    cSelectD2 += "%"	
				//������������������������������������������������������������������������Ŀ
				//�Complemento do Where da tabela SD1                                      �
				//��������������������������������������������������������������������������	
				cWhereD2 := "%" 
				cWhereD2 += "AND" 
				If !(lCusFil .Or. lCusEmp)
					cWhereD2 += " D2_LOCAL = '" + mv_par08 + "' AND"
				EndIf
				cWhereD2 += "%"    
				//������������������������������������������������������������������������Ŀ
				//�Complemento do Where da tabela SD2 (Tratamento Filial)                  �
				//��������������������������������������������������������������������������	
				If lCusEmp
					If !Empty(xFilial("SD2")) .And. !Empty(xFilial("SF4"))
						cWhereD2C := "%"
						cWhereD2C += " D2_FILIAL = F4_FILIAL AND "
						cWhereD2C += "%"
					Else
						cWhereD2C := "% %"
					EndIf	
				Else
					cWhereD2C := "%"
					cWhereD2C += " D2_FILIAL ='" + xFilial("SD2") + "' AND "
					cWhereD2C += " SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND"
					cWhereD2C += "%"
				EndIf	
				//������������������������������������������������������������������������Ŀ
				//�Complemento do SELECT da tabelas SD3                                    �
				//��������������������������������������������������������������������������
				If lCusRep .And. mv_par17==2
					cSelectD3 := "% D3_CUSRP"
					cSelectD3 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
				Else
					cSelectD3 := "% D3_CUSTO"
					cSelectD3 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
				EndIf	
				cSelectD3 +=	" CUSTO," 
				cSelectD3 += "%"    
				//������������������������������������������������������������������������Ŀ
				//�Complemento do WHERE da tabela SD3                                      �
				//��������������������������������������������������������������������������
			    cWhereD3 := "%"
				If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
					cWhereD3 += " D3_ESTORNO <> 'S' AND"
				EndIf
				If SuperGetMV('MV_D3SERVI', .F., 'N') == 'N' .And. IntDL()
					cWhereD3 += " ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500')  "
					cWhereD3 += " OR  (D3_SERVIC <> '   ' AND D3_TM > '500' AND D3_LOCAL ='"+SuperGetMV('MV_CQ', .F., '98')+"') ) AND"
				EndIf
				If !(lCusFil .Or. lCusEmp) .And. !lLocProc
					cWhereD3 += " D3_LOCAL = '"+mv_par08+"' AND" 
				EndIf
				If	!lVEIC
					cWhereD3+= " SB1.B1_COD >= '"+mv_par01+"' AND SB1.B1_COD <= '"+mv_par02+"' AND"
				Else
					cWhereD3+= " SB1.B1_CODITE >= '"+mv_par01+"' AND SB1.B1_CODITE <= '"+mv_par02+"' AND"
				EndIf	
				If lCusEmp
					cWhereD3 += " SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
				Else
					cWhereD3 += " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
				EndIf
				cWhereD3 += " SB1.B1_GRUPO >= '"+mv_par14+"' AND SB1.B1_GRUPO <= '"+mv_par15+"' AND SB1.B1_COD <> '"+cProdimp+"' AND "
				cWhereD3 += " SB1.D_E_L_E_T_=' ' AND"
				cWhereD3 += "%"	
				//������������������������������������������������������������������������Ŀ
				//�Complemento do Where da tabela SD3 (Tratamento Filial)                  �
				//��������������������������������������������������������������������������	
				If lCusEmp
					cWhereD3C := "% %"
				Else
					cWhereD3C := "%"
					cWhereD3C += " D3_FILIAL ='" + xFilial("SD3")  + "' AND "
					cWhereD3C += "%"
				EndIf	
				//������������������������������������������������������������������������Ŀ
				//�Complemento do WHERE da tabela SB1 para todos os selects                �
				//��������������������������������������������������������������������������
				cWhereB1A:= "%" 
			   	cWhereB1B:= "%" 
			    cWhereB1C:= "%" 
			    cWhereB1D:= "%" 	
				If	!lVEIC
					cWhereB1A+= " AND SB1.B1_COD >= '"+mv_par01+"' AND SB1.B1_COD <= '"+mv_par02+"'"
					cWhereB1B+= " AND SB1.B1_COD = SB1EXS.B1_COD"
					If lCusEmp
						cWhereB1C+= " SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
						cWhereB1D+= " SB1EXS.B1_COD >= '"+mv_par01+"' AND SB1EXS.B1_COD <= '"+mv_par02+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
					Else
						cWhereB1C+= " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
						cWhereB1D+= " SB1EXS.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1EXS.B1_COD >= '"+mv_par01+"' AND SB1EXS.B1_COD <= '"+mv_par02+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
					EndIf	
				Else
					cWhereB1A+= " AND SB1.B1_CODITE >= '"+mv_par01+"' AND SB1.B1_CODITE <= '"+mv_par02+"'"
					cWhereB1B+= " AND SB1.B1_COD = SB1EXS.B1_COD"
					If lCusEmp
						cWhereB1C+= " SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
						cWhereB1D+= " SB1EXS.B1_CODITE >= '"+mv_par01+"' AND SB1EXS.B1_CODITE <= '"+mv_par02+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
					Else
						cWhereB1C+= " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
						cWhereB1D+= " SB1EXS.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1EXS.B1_CODITE >= '"+mv_par01+"' AND SB1EXS.B1_CODITE <= '"+mv_par02+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
					EndIf	
				EndIf	
			
				cWhereB1C += " SB1.B1_GRUPO >= '"+mv_par14+"' AND SB1.B1_GRUPO <= '"+mv_par15+"' AND SB1.B1_COD <> '"+cProdimp+"' AND "
				cWhereB1C += " SB1.D_E_L_E_T_=' '"
				cWhereB1D += " SB1EXS.B1_GRUPO >= '"+mv_par14+"' AND SB1EXS.B1_GRUPO <= '"+mv_par15+"' AND SB1EXS.B1_COD <> '"+cProdimp+"' AND "
				cWhereB1D += " SB1EXS.D_E_L_E_T_=' '"	
				
				cQueryB1A:= Subs(cWhereB1A,2)
				cQueryB1B:= Subs(cWhereB1B,2)
				cQueryB1C:= Subs(cWhereB1C,2)
				cQueryB1D:= Subs(cWhereB1D,2)
				
				cWhereB1A+= "%" 
			   	cWhereB1B+= "%" 
			    cWhereB1C+= "%" 
			    cWhereB1D+= "%" 	
			 	//��������������������������������������������������������Ŀ
				//� So inclui as condicoes a seguir qdo lista produtos sem �
				//� movimento                                              �
				//����������������������������������������������������������
				cQueryD1 := " FROM "
				cQueryD1 += RetSqlName("SB1") + " SB1"
				cQueryD1 += (", " + RetSqlName("SD1")+ " SD1 ")
				cQueryD1 += (", " + RetSqlName("SF4")+ " SF4 ")
				cQueryD1 += " WHERE SB1.B1_COD = D1_COD"
				If lCusEmp
					If !Empty(xFilial("SD1")) .And. !Empty(xFilial("SF4"))
						cQueryD1 += " AND F4_FILIAL = D1_FILIAL "
					EndIf	
				Else
					cQueryD1 += (" AND D1_FILIAL = '" + xFilial("SD1")+"'" )
					cQueryD1 += (" AND F4_FILIAL = '" + xFilial("SF4") + "'")
				EndIf	
				cQueryD1 += (" AND SD1.D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S'")
				cQueryD1 += (" AND D1_DTDIGIT >= '" + DTOS(mv_par05) + "'")
				cQueryD1 += (" AND D1_DTDIGIT <= '" + DTOS(mv_par06) + "'")
				cQueryD1 +=  " AND D1_ORIGLAN <> 'LF'"
				If !(lCusFil .Or. lCusEmp)
					cQueryD1 += " AND D1_LOCAL = '" + mv_par08 + "'"
				EndIf
				cQueryD1 += " AND SD1.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' '"
				
				cQueryD2 := " FROM "
				cQueryD2 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD2")+ " SD2 , "+ RetSqlName("SF4")+" SF4 "
				cQueryD2 += " WHERE SB1.B1_COD = D2_COD "
				If lCusEmp
					If !Empty(xFilial("SD2")) .And. !Empty(xFilial("SF4"))
						cQueryD2 += " AND F4_FILIAL = D2_FILIAL "
					EndIf	
				Else
					cQueryD2 += " AND D2_FILIAL = '"+xFilial("SD2")+"' "
					cQueryD2 += " AND F4_FILIAL = '"+xFilial("SF4")+"' " 
				EndIf	
				cQueryD2 += " AND SD2.D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S'"
				cQueryD2 += " AND D2_EMISSAO >= '"+DTOS(mv_par05)+"' AND D2_EMISSAO <= '"+DTOS(mv_par06)+"'"
				cQueryD2 += " AND D2_ORIGLAN <> 'LF'"
				If !(lCusFil .Or. lCusEmp)
					cQueryD2 += " AND D2_LOCAL = '"+mv_par08+"'"
				EndIf
				cQueryD2 += " AND SD2.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' '"	
				
				cQueryD3 := " FROM "
				cQueryD3 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD3")+ " SD3 "
				cQueryD3 += " WHERE SB1.B1_COD = D3_COD " 
				If !lCusEmp
					cQueryD3 += " AND D3_FILIAL = '"+xFilial("SD3")+"' "
				EndIf	
				cQueryD3 += " AND D3_EMISSAO >= '"+DTOS(mv_par05)+"' AND D3_EMISSAO <= '"+DTOS(mv_par06)+"'"
				If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
					cQueryD3 += " AND D3_ESTORNO <> 'S'"
				EndIf
				If SuperGetMV('MV_D3SERVI', .F., 'N') == 'N' .And. IntDL()
					cQueryD3 += " AND ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500')  "
					cQueryD3 += " OR  (D3_SERVIC <> '   ' AND D3_TM > '500' AND D3_LOCAL ='"+SuperGetMV('MV_CQ', .F., '98')+"') )"
				EndIf					
				If !(lCusFil .Or. lCusEmp) .And. !lLocProc
					cQueryD3 += " AND D3_LOCAL = '"+mv_par08+"'"
				EndIf
				cQueryD3 += " AND SD3.D_E_L_E_T_=' '"	
				
				cQuerySub:= "SELECT 1 "
				
				If mv_par07 == 1
					cQuery2 := " AND NOT EXISTS (" + cQuerySub + cQueryD1
					cQuery2 += cQueryB1B
					cQuery2 += " AND "
					cQuery2 += cQueryB1C
					cQuery2 += ") AND NOT EXISTS ("
					cQuery2 += cQuerySub + cQueryD2
					cQuery2 += cQueryB1B
					cQuery2 += " AND "
					cQuery2 += cQueryB1C
					cQuery2 += ") AND NOT EXISTS ("
					cQuery2 += cQuerySub + cQueryD3
					cQuery2 += cQueryB1B
					cQuery2 += " AND "
					cQuery2 += cQueryB1C + ")"
			        
					cUnion := "%"
					cUnion += " UNION SELECT 'SB1'"		// 01
					cUnion += ", SB1EXS.B1_COD"			// 02
					cUnion += ", SB1EXS.B1_TIPO"		// 03
					cUnion += ", SB1EXS.B1_UM"			// 04
					cUnion += ", SB1EXS.B1_GRUPO"		// 05
					cUnion += ", SB1EXS.B1_DESC"		// 06
					cUnion += ", SB1EXS.B1_POSIPI"		// 07
					cUnion += ", ''"					// 08
					cUnion += ", ''"					// 09
					cUnion += ", ''"					// 10
					cUnion += ", ''"					// 11
					cUnion += ", ''"					// 12
					cUnion += ", ''"					// 13
					cUnion += ", ''"					// 14
					cUnion += ", 0"						// 15
					cUnion += ", 0"						// 16
					cUnion += ", ''"					// 17
					cUnion += ", ''"					// 18
					cUnion += ", ''"					// 19
					cUnion += ", ''"					// 20
					cUnion += ", ''"					// 21
					cUnion += ", ''"					// 22
					cUnion += ", ''"					// 23
					cUnion += ", ''"					// 24
					cUnion += ", 0"						// 25
					cUnion += ", ''"					// 26
					cUnion += ", ''"					// 27
					If lVEIC
						cUnion += ", SB1EXS.B1_CODITE CODITE"	// 28
					EndIf		
					cUnion += ", 0"						// 29		   
					cUnion += " FROM "+RetSqlName("SB1") + " SB1EXS WHERE"
					cUnion += cQueryB1D
					cUnion += cQuery2
					cUnion += "%"
				EndIf
				
				cOrder := "%"
				If ! lVEIC
					If nOrdem == 1 //" Codigo Produto "###" Tipo do Produto"
						cOrder += " 2,"
					ElseIf nOrdem == 2
						cOrder += " 3,2,"
					EndIf
				Else
					If nOrdem ==1 //" Codigo Produto "###" Tipo do Produto"
						cOrder += " 28, 2, 5," 	// B1_CODITE, B1_COD, B1_GRUPO
					ElseIf nOrdem == 2
						cOrder += " 3, 28, 2, 5," // B1_TIPO, B1_CODITE, B1_COD, B1_GRUPO
					EndIf
				EndIf
			
				If mv_par11 == 1
//					cOrder += "17,12"+IIf(lVEIC,',29',',28')
					cOrder += "12"+IIf(lVEIC,',29',',28')
				Else
					If lCusFil .Or. lCusEmp
						cOrder += "8,12"+IIf(lVEIC,',29',',28')
					Else
//						cOrder += "17,8,12"+IIf(lVEIC,',29',',28')
						cOrder += "8"+IIf(lVEIC,',29',',28')
					EndIf
				EndIf	
				cOrder += "%"
				
				BeginSql Alias cAliasTop
				
					SELECT 	'SD1' ARQ, 				//-- 01 ARQ
							 SB1.B1_COD PRODUTO, 	//-- 02 PRODUTO
							 SB1.B1_TIPO TIPO, 		//-- 03 TIPO
							 SB1.B1_UM,   			//-- 04 UM
							 SB1.B1_GRUPO,      	//-- 05 GRUPO
							 SB1.B1_DESC,      		//-- 06 DESCR
						     SB1.B1_POSIPI, 		//-- 07
						     D1_SEQCALC SEQCALC,    //-- 08
							 D1_DTDIGIT DATA,		//-- 09 DATA
							 D1_TES TES,			//-- 10 TES
							 D1_CF CF,				//-- 11 CF
							 D1_NUMSEQ SEQUENCIA,	//-- 12 SEQUENCIA
							 D1_DOC DOCUMENTO,		//-- 13 DOCUMENTO
							 D1_SERIE SERIE,		//-- 14 SERIE
							 D1_QUANT QUANTIDADE,	//-- 15 QUANTIDADE
							 D1_QTSEGUM QUANT2UM,	//-- 16 QUANT2UM
							 D1_LOCAL ARMAZEM,		//-- 17 ARMAZEM
				             ' ' PROJETO,			//-- 18 PROJETO
							 ' ' OP,				//-- 19 OP
							 ' ' CC,				//-- 20 OP
							 D1_FORNECE FORNECEDOR,	//-- 21 FORNECEDOR
							 D1_LOJA LOJA,			//-- 22 LOJA
							 ' ' PEDIDO,            //-- 23 PEDIDO
							 D1_TIPO TIPONF,		//-- 24 TIPO NF
							 %Exp:cSelectD1%		//-- 25 CUSTO 
							 ' ' TRT, 				//-- 26 TRT
							 D1_LOTECTL LOTE 	   	//-- 27 LOTE
							 %Exp:cSelectVe%       	//-- 28 CODITE
							 SD1.R_E_C_N_O_ NRECNO  //-- 29 RECNO
							 					 
					FROM %table:SB1% SB1,%table:SD1% SD1,%table:SF4% SF4
					
					WHERE SB1.B1_COD     =  SD1.D1_COD		AND  	%Exp:cWhereD1C%						
						  SD1.D1_TES     =  SF4.F4_CODIGO	AND
						  SF4.F4_ESTOQUE =  'S'				AND 	SD1.D1_DTDIGIT >= %Exp:mv_par05%	AND
						  SD1.D1_DTDIGIT <= %Exp:mv_par06%	AND		SD1.D1_ORIGLAN <> 'LF'				   
						  %Exp:cWhereD1%
						  SD1.%NotDel%						AND 	SF4.%NotDel%                           
						  %Exp:cWhereB1A%                   AND
						  %Exp:cWhereB1C%
						  
				    UNION
				    
					SELECT 'SD2',	     			
							SB1.B1_COD,	        	
							SB1.B1_TIPO,		    
							SB1.B1_UM,				
							SB1.B1_GRUPO,		    
							SB1.B1_DESC,		    
							SB1.B1_POSIPI,
							D2_SEQCALC,
							D2_EMISSAO,				
							D2_TES,					
							D2_CF,					
							D2_NUMSEQ,				
							D2_DOC,					
							D2_SERIE,				
							D2_QUANT,				
							D2_QTSEGUM,				
							D2_LOCAL,				
							' ',					
							' ',					
							' ',					
							D2_CLIENTE,				
							D2_LOJA,				
							D2_PEDIDO,
							D2_TIPO,				
							%Exp:cSelectD2%			
							' ', 					
							D2_LOTECTL
							%Exp:cSelectVe%
							SD2.R_E_C_N_O_ SD2RECNO //-- 29 RECNO
							
					FROM %table:SB1% SB1,%table:SD2% SD2,%table:SF4% SF4
					
					WHERE	SB1.B1_COD     =  SD2.D2_COD		AND	%Exp:cWhereD2C%						
							SD2.D2_TES     =  SF4.F4_CODIGO		AND
							SF4.F4_ESTOQUE =  'S'				AND	SD2.D2_EMISSAO >= %Exp:mv_par05%	AND
							SD2.D2_EMISSAO <= %Exp:mv_par06%	AND	SD2.D2_ORIGLAN <> 'LF'				   
							%Exp:cWhereD2%
							SD2.%NotDel%						AND SF4.%NotDel%						   
							%Exp:cWhereB1A%                     AND
						  	%Exp:cWhereB1C%
			
					UNION		
				
					SELECT 	'SD3',	    			
							SB1.B1_COD,	    	    
							SB1.B1_TIPO,		    
							SB1.B1_UM,				
							SB1.B1_GRUPO,	     	
							SB1.B1_DESC,		    
							SB1.B1_POSIPI,
							D3_SEQCALC,
							D3_EMISSAO,				
							D3_TM,					
							D3_CF,					
							D3_NUMSEQ,				
							D3_DOC,					
							' ',					
							D3_QUANT,				
							D3_QTSEGUM,				
							D3_LOCAL,				
							D3_PROJPMS,
							D3_OP,					
							D3_CC,
							' ',					
							' ',					
							' ',					
							' ',									
							%Exp:cSelectD3%			
							D3_TRT, 
							D3_LOTECTL
							%Exp:cSelectVe%
							SD3.R_E_C_N_O_ SD3RECNO //-- 29 RECNO
			
					FROM %table:SB1% SB1,%table:SD3% SD3
			
					WHERE	SB1.B1_COD     =  SD3.D3_COD 		AND %Exp:cWhereD3C%						
							SD3.D3_EMISSAO >= %Exp:mv_par05%	AND	SD3.D3_EMISSAO <= %Exp:mv_par06%	AND
							%Exp:cWhereD3% 	
							SD3.%NotDel% 
							
					%Exp:cUnion%			
			
					ORDER BY %Exp:cOrder%
				
				EndSql 
				oSection2:SetParentQuery()
				//������������������������������������������������������������������������Ŀ
				//�Metodo EndQuery ( Classe TRSection )                                    �
				//�                                                                        �
				//�Prepara o relatorio para executar o Embedded SQL.                       �
				//�                                                                        �
				//�ExpA1 : Array com os parametros do tipo Range                           �
				//�                                                                        �
				//��������������������������������������������������������������������������
				oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
				
				//������������������������������������������������������������������������Ŀ
				//�Inicio da impressao do fluxo do relatorio                               �
				//��������������������������������������������������������������������������
				dbSelectArea(cAliasTop)
				oReport:SetMeter(nTotRegs)
				
				TcSetField(cAliasTop,DATA ,"D", TamSx3("D1_DTDIGIT")[1], TamSx3("D1_DTDIGIT")[2] )

				While !oReport:Cancel() .And. !(cAliasTop)->(Eof())
					
					If oReport:Cancel()
						Exit
					EndIf
					

					oReport:IncMeter()
					
					//��������������������������������������������������Ŀ
					//�Executa filtro de usuario - SB1					 �
					//����������������������������������������������������					
					
					If !Empty(cFilUsrSB1) 
						DbSelectArea("SB1")
						SB1->(dbSetOrder(1))
					    SB1->(dbSeek( xFilial("SB1") + (cAliasTop)->PRODUTO))
					    If !(&(cFilUsrSB1))
					       (cAliasTop)->(dbSkip())
			    		   Loop
				    	EndIf   
					EndIf
					
					//��������������������������������������������������Ŀ
					//�Executa filtro de usuario - SB2					 �
					//����������������������������������������������������	
					     
					If !Empty(cFilUsrSB2)
						DbSelectArea("SB2")
						SB2->(dbSetOrder(1))
					    SB2->(dbSeek( xFilial("SB2") + (cAliasTop)->PRODUTO))
					    If !(&(cFilUsrSB2))
					       (cAliasTop)->(dbSkip())
				    	   Loop
				    	EndIf   
					EndIf
					
					//��������������������������������������������������Ŀ
					//� Se nao encontrar no arquivo de saldos ,nao lista �
					//����������������������������������������������������
					dbSelectArea("SB2")
					If !dbSeek(xFilial("SB2")+(cAliasTop)->PRODUTO+If(lCusFil .Or. lCusEmp,"",mv_par08))
						dbSelectArea(cAliasTop)
						dbSkip()
						Loop
					EndIf
					
					dbSelectArea(cAliasTop)
					cProdAnt  := (cAliasTop)->PRODUTO
					cLocalAnt := alltrim(SB2->B2_LOCAL)
					
					lFirst:=.F.
			
					MR900ImpS1(@aSalAtu,cAliasTop,.T.,lVEIC,lCusFil,lCusEmp,oSection1,oSection2,oReport)
					
					oSection3:Init()
					While !oReport:Cancel() .And. !(cAliasTop)->(Eof()) .And. (cAliasTop)->PRODUTO = cProdAnt .And. If(lCusFil .Or. lCusEmp .Or. lLocProc,.T.,IIf(alltrim((cAliasTop)->ARQ) <> 'SB1',alltrim((cAliasTop)->ARMAZEM)==cLocalAnt,.T.))
						oReport:IncMeter()
						lContinua := .F.
						lImpSMov  := .F.
						If Alltrim((cAliasTop)->ARQ) $ "SD1/SD2"
							lFirst:=.T.
							SF4->(dbSeek(xFilial("SF4")+(cAliasTop)->TES))
							//��������������������������������������������������������������Ŀ
							//� Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  �
							//����������������������������������������������������������������
							//��������������������������������������������������������������Ŀ
							//� Executa ponto de entrada para verificar se considera TES que �
							//� NAO ATUALIZA saldos em estoque.                              �
							//����������������������������������������������������������������
							If lIxbConTes .And. SF4->F4_ESTOQUE != "S"
								lTesNEst := ExecBlock("MTAAVLTES",.F.,.F.)
								lTesNEst := If(ValType(lTesNEst) # "L",.F.,lTesNEst)
							EndIf
							If SF4->F4_ESTOQUE != "S" .And. !lTesNEst
								dbSkip()
								Loop
							EndIf
						ElseIf Alltrim((cAliasTop)->ARQ) == "SD3"
							lFirst:=.T.
							//����������������������������������������������������������������Ŀ
							//� Quando movimento ref apropr. indireta, so considera os         �
							//� movimentos com destino ao almoxarifado de apropriacao indireta.�
							//������������������������������������������������������������������
							lInverteMov:=.F.
							If alltrim((cAliasTop)->ARMAZEM) != cLocalAnt .Or. lCusFil .Or. lCusEmp
								If !(Substr((cAliasTop)->CF,3,1) == "3")
									If !(lCusFil .Or. lCusEmp)
										dbSkip()
										Loop
									EndIf
								ElseIf lPriApropri
									lInverteMov:=.T.
								EndIf
							EndIf
							//����������������������������������������������������������������Ŀ
							//� Caso seja uma transferencia de localizacao verifica se lista   �
							//� o movimento ou nao                                             �
							//������������������������������������������������������������������
							If mv_par13 == 2 .And. Substr((cAliasTop)->CF,3,1) == "4"
								cNumSeqTr := (cAliasTOP)->(PRODUTO+SEQUENCIA+ARMAZEM)
								aDadosTran:={(cAliasTOP)->TES,(cAliasTOP)->QUANTIDADE,(cAliasTOP)->CUSTO,(cAliasTOP)->QUANT2UM,(cAliasTOP)->TIPO,;
								(cAliasTOP)->DATA,(cAliasTOP)->CF,(cAliasTOP)->SEQUENCIA,(cAliasTOP)->DOCUMENTO,(cAliasTOP)->PRODUTO,;
								(cAliasTOP)->OP,(cAliasTOP)->PROJETO,(cAliasTOP)->CC,alltrim((cAliasTOP)->ARQ),(cAliasTOP)->LOTE}
								dbSkip()
								If (cAliasTOP)->(PRODUTO+SEQUENCIA+ARMAZEM) == cNumSeqTr
									dbSkip()
									Loop
								Else
									lContinua := .T.
									If !Localiza(aDadosTran[10])
										If lFirst
											oSection3:Cell("dDtMov"):SetValue(STOD(aDadosTran[6]))
											oSection3:Cell("cTES"):SetValue(aDadosTran[1])
											If ( cPaisLoc=="BRA" )
												oSection3:Cell("cCF"):Show()
												If	lInverteMov
													oSection3:Cell("cCF"):SetValue(Substr(aDadosTran[7],1,3)+"*")
												Else
													oSection3:Cell("cCF"):SetValue(aDadosTran[7])
												EndIf
											Else
												oSection3:Cell("cCF"):Hide()
												oSection3:Cell("cCF"):SetValue("   ")
											EndIf
											If mv_par09 $ "Ss"
												oSection3:Cell("cDoc"):SetValue(aDadosTran[8])
											Else
												oSection3:Cell("cDoc"):SetValue(aDadosTran[9])
											Endif
										EndIf
										If aDadosTran[1] <= "500"
											oSection3:Cell("nENTQtd"):Show()
											oSection3:Cell("nENTCus"):Show()
											oSection3:Cell("nCusMov"):Show()
											
											oSection3:Cell("nENTQtd"):SetValue(aDadosTran[2])
											oSection3:Cell("nENTCus"):SetValue(aDadosTran[3])
											oSection3:Cell("nCusMov"):SetValue(aDadosTran[3] / aDadosTran[2])
											
											oSection3:Cell("nSAIQtd"):Hide()
											oSection3:Cell("nSAICus"):Hide()
											oSection3:Cell("nSAIQtd"):SetValue(0)
											oSection3:Cell("nSAICus"):SetValue(0)
											
											aSalAtu[1] += aDadosTran[2]
											aSalAtu[mv_par10+1] += aDadosTran[3]
											aSalAtu[7] += aDadosTran[4]
										Else
											oSection3:Cell("nENTQtd"):Hide()
											oSection3:Cell("nENTCus"):Hide()
											oSection3:Cell("nENTQtd"):SetValue(0)
											oSection3:Cell("nENTCus"):SetValue(0)
											
											oSection3:Cell("nCusMov"):Show()
											oSection3:Cell("nSAIQtd"):Show()
											oSection3:Cell("nSAICus"):Show()
											
											oSection3:Cell("nCusMov"):SetValue(aDadosTran[3] / aDadosTran[2])
											oSection3:Cell("nSAIQtd"):SetValue(aDadosTran[2])
											oSection3:Cell("nSAICus"):SetValue(aDadosTran[3])
											
											aSalAtu[1] -= aDadosTran[2]
											aSalAtu[mv_par10+1] -= aDadosTran[3]
											aSalAtu[7] -= aDadosTran[4]
										EndIf
									Else
										lTransEnd := .F.
									EndIf
								EndIf
							EndIf
						EndIf
						If lFirst .And. !lContinua .And. lTransEnd
							oSection3:Cell("dDtMov"):SetValue(STOD(DATA))
							oSection3:Cell("cTES"):SetValue(TES)
							If ( cPaisLoc=="BRA" )
								oSection3:Cell("cCF"):Show()
								oSection3:Cell("cCF"):SetValue(CF)
								If	lInverteMov
									oSection3:Cell("cCF"):SetValue(Substr(CF,1,3)+"*")
								Else
									oSection3:Cell("cCF"):SetValue(CF)
								EndIf
							Else
								oSection3:Cell("cCF"):Hide()
								oSection3:Cell("cCF"):SetValue("   ")
							EndIf
							If mv_par09 $ "Ss"
								oSection3:Cell("cDoc"):SetValue(SEQUENCIA)
							Else
								oSection3:Cell("cDoc"):SetValue(DOCUMENTO)
							Endif
						EndIf
						
						Do Case
							Case Alltrim((cAliasTop)->ARQ) == "SD1" .And. !lContinua .And. lTransEnd
								lDev:=MTR900Dev("SD1",cAliasTop)
								If (cAliasTOP)->TES <= "500" .And. !lDev
									If (cAliasTOP)->TIPONF != "C"
										oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)
										oSection3:Cell("nCusMov"):Show()
									Else
										oSection3:Cell("nCusMov"):SetValue(0)
										oSection3:Cell("nCusMov"):Hide()
									EndIf
									
									oSection3:Cell("nENTQtd"):Show()
									oSection3:Cell("nENTCus"):Show()
									oSection3:Cell("cLote"):Show()
									
									oSection3:Cell("nENTQtd"):SetValue((cAliasTOP)->QUANTIDADE)
									oSection3:Cell("nENTCus"):SetValue((cAliasTOP)->CUSTO)
									oSection3:Cell("cLote"):SetValue((cAliasTOP)->LOTE)
									
									oSection3:Cell("nSAIQtd"):Hide()
									oSection3:Cell("nSAICus"):Hide()
									oSection3:Cell("nSAIQtd"):SetValue(0)
									oSection3:Cell("nSAICus"):SetValue(0)
									
									aSalAtu[1] += (cAliasTOP)->QUANTIDADE
									aSalAtu[mv_par10+1] += (cAliasTOP)->CUSTO
									aSalAtu[7] += (cAliasTOP)->QUANT2UM
								Else
									If (cAliasTOP)->TIPONF != "C"
										oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)
										oSection3:Cell("nCusMov"):Show()
									Else
										oSection3:Cell("nCusMov"):SetValue(0)
										oSection3:Cell("nCusMov"):Hide()
									EndIf
									
									oSection3:Cell("nENTQtd"):Hide()
									oSection3:Cell("nENTCus"):Hide() 
									oSection3:Cell("cLote"):Hide() 
									
									oSection3:Cell("nENTQtd"):SetValue(0)
									oSection3:Cell("nENTCus"):SetValue(0)                     
									oSection3:Cell("cLote"):SetValue('')
									
									oSection3:Cell("nSAIQtd"):Show()
									oSection3:Cell("nSAICus"):Show()
									
									If lDev
										oSection3:Cell("nSAIQtd"):SetValue((cAliasTOP)->QUANTIDADE * -1)
										oSection3:Cell("nSAICus"):SetValue((cAliasTOP)->CUSTO * -1)
										
										aSalAtu[1] += (cAliasTOP)->QUANTIDADE
										aSalAtu[mv_par10+1] += (cAliasTOP)->CUSTO
										aSalAtu[7] += (cAliasTOP)->QUANT2UM
									Else
										oSection3:Cell("nSAIQtd"):SetValue((cAliasTOP)->QUANTIDADE)
										oSection3:Cell("nSAICus"):SetValue((cAliasTOP)->CUSTO)
										
										aSalAtu[1] 			-= (cAliasTOP)->QUANTIDADE
										aSalAtu[mv_par10+1]	-= (cAliasTOP)->CUSTO
										aSalAtu[7]			-= (cAliasTOP)->QUANT2UM
									EndIf
								EndIf
							Case Alltrim((cAliasTop)->ARQ) = "SD2" .And. !lContinua .And. lTransEnd
								lDev:=MTR900Dev("SD2",cAliasTop)
								If (cAliasTOP)->TES <= "500" .Or. lDev
									If lDev
										oSection3:Cell("nENTQtd"):Show()
										oSection3:Cell("nENTCus"):Show()
										oSection3:Cell("cLote"):Show()
										
										oSection3:Cell("nENTQtd"):SetValue((cAliasTOP)->QUANTIDADE * -1)
										oSection3:Cell("nENTCus"):SetValue((cAliasTOP)->CUSTO * -1)
										oSection3:Cell("cLote"):SetValue((cAliasTOP)->LOTE)
										
										aSalAtu[1] 			-= (cAliasTOP)->QUANTIDADE
										aSalAtu[mv_par10+1]	-= (cAliasTOP)->CUSTO
										aSalAtu[7]			-= (cAliasTOP)->QUANT2UM
									Else
										oSection3:Cell("nENTQtd"):Show()
										oSection3:Cell("nENTCus"):Show()
										oSection3:Cell("cLote"):Show() 
									
										oSection3:Cell("nENTQtd"):SetValue((cAliasTOP)->QUANTIDADE)
										oSection3:Cell("nENTCus"):SetValue((cAliasTOP)->CUSTO)
										oSection3:Cell("cLote"):SetValue((cAliasTOP)->LOTE)
										
										
										aSalAtu[1]			+= (cAliasTOP)->QUANTIDADE
										aSalAtu[mv_par10+1]	+= (cAliasTOP)->CUSTO
										aSalAtu[7]			+= (cAliasTOP)->QUANT2UM
									EndIf
									
									If (cAliasTOP)->TIPONF != "C"
										oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)
										oSection3:Cell("nCusMov"):Show()
									Else
										oSection3:Cell("nCusMov"):SetValue(0)
										oSection3:Cell("nCusMov"):Hide()
									EndIf
									oSection3:Cell("nSAIQtd"):Hide()
									oSection3:Cell("nSAICus"):Hide()
									oSection3:Cell("nSAIQtd"):SetValue(0)
									oSection3:Cell("nSAICus"):SetValue(0)
								Else
									If (cAliasTOP)->TIPONF != "C"
										oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)
										oSection3:Cell("nCusMov"):Show()
									Else
										oSection3:Cell("nCusMov"):SetValue(0)
										oSection3:Cell("nCusMov"):Hide()
									EndIf
									
									oSection3:Cell("nENTQtd"):Hide()
									oSection3:Cell("nENTCus"):Hide()
									oSection3:Cell("nENTQtd"):SetValue(0)
									oSection3:Cell("nENTCus"):SetValue(0)
									
									oSection3:Cell("nSAIQtd"):Show()
									oSection3:Cell("nSAICus"):Show()
									
									oSection3:Cell("nSAIQtd"):SetValue((cAliasTOP)->QUANTIDADE)
									oSection3:Cell("nSAICus"):SetValue((cAliasTOP)->CUSTO)
									
									aSalAtu[1]			-= (cAliasTOP)->QUANTIDADE
									aSalAtu[mv_par10+1]	-= (cAliasTOP)->CUSTO
									aSalAtu[7]			-= (cAliasTOP)->QUANT2UM
								EndIf
							Case Alltrim((cAliasTop)->ARQ) == "SD3" .And. !lContinua  .And. lTransEnd
								lDev := .F.
								If	lInverteMov
									If (cAliasTOP)->TES > "500"
										oSection3:Cell("nENTQtd"):Show()
										oSection3:Cell("nENTCus"):Show()
										oSection3:Cell("nCusMov"):Show()
										oSection3:Cell("cLote"):Show()
										
										oSection3:Cell("nENTQtd"):SetValue((cAliasTOP)->QUANTIDADE)
										oSection3:Cell("nENTCus"):SetValue((cAliasTOP)->CUSTO)
										oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)
										oSection3:Cell("cLote"):SetValue((cAliasTOP)->LOTE)

										oSection3:Cell("nSAIQtd"):Hide()
										oSection3:Cell("nSAICus"):Hide()
										oSection3:Cell("nSAIQtd"):SetValue(0)
										oSection3:Cell("nSAICus"):SetValue(0)
										
										aSalAtu[1]			+= (cAliasTOP)->QUANTIDADE
										aSalAtu[mv_par10+1]	+= (cAliasTOP)->CUSTO
										aSalAtu[7]			+= (cAliasTOP)->QUANT2UM
									Else
										oSection3:Cell("nENTQtd"):Hide()
										oSection3:Cell("nENTCus"):Hide()
										oSection3:Cell("cLote"):Show()
										oSection3:Cell("nENTQtd"):SetValue(0)
										oSection3:Cell("nENTCus"):SetValue(0)
										oSection3:Cell("cLote"):SetValue((cAliasTOP)->LOTE)
	
										oSection3:Cell("nCusMov"):Show()
										oSection3:Cell("nSAIQtd"):Show()
										oSection3:Cell("nSAICus"):Show()
										
										oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)
										oSection3:Cell("nSAIQtd"):SetValue((cAliasTOP)->QUANTIDADE)
										oSection3:Cell("nSAICus"):SetValue((cAliasTOP)->CUSTO)
										
										aSalAtu[1]			-= (cAliasTOP)->QUANTIDADE
										aSalAtu[mv_par10+1]	-= (cAliasTOP)->CUSTO
										aSalAtu[7]			-= (cAliasTOP)->QUANT2UM
									EndIf
									If lCusFil .Or. lCusEmp
										lPriApropri:=.F.
									EndIf
								Else
									If (cAliasTOP)->TES <= "500"
										oSection3:Cell("nENTQtd"):Show()
										oSection3:Cell("nENTCus"):Show()
										oSection3:Cell("nCusMov"):Show()                   
										oSection3:Cell("cLote"):Show()                   
										
										
										oSection3:Cell("nENTQtd"):SetValue((cAliasTOP)->QUANTIDADE)
										oSection3:Cell("nENTCus"):SetValue((cAliasTOP)->CUSTO)
										oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)
										oSection3:Cell("cLote"):SetValue((cAliasTOP)->LOTE)
										
										oSection3:Cell("nSAIQtd"):Hide()
										oSection3:Cell("nSAICus"):Hide()
										oSection3:Cell("nSAIQtd"):SetValue(0)
										oSection3:Cell("nSAICus"):SetValue(0)
										
										aSalAtu[1]			+= (cAliasTOP)->QUANTIDADE
										aSalAtu[mv_par10+1]	+= (cAliasTOP)->CUSTO
										aSalAtu[7]			+= (cAliasTOP)->QUANT2UM
									Else
										oSection3:Cell("nENTQtd"):Hide()
										oSection3:Cell("nENTCus"):Hide()
										oSection3:Cell("nENTQtd"):SetValue(0)
										oSection3:Cell("nENTCus"):SetValue(0)
										
										oSection3:Cell("nCusMov"):Show()
										oSection3:Cell("nSAIQtd"):Show()
										oSection3:Cell("nSAICus"):Show()
										oSection3:Cell("nCusMov"):Show()                   
										
										oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)
										oSection3:Cell("nSAIQtd"):SetValue((cAliasTOP)->QUANTIDADE)
										oSection3:Cell("nSAICus"):SetValue((cAliasTOP)->CUSTO)
										oSection3:Cell("cLote"):SetValue((cAliasTOP)->LOTE)
										
										
										aSalAtu[1]			-= (cAliasTOP)->QUANTIDADE
										aSalAtu[mv_par10+1]	-= (cAliasTOP)->CUSTO
										aSalAtu[7]			-= (cAliasTOP)->QUANT2UM
									EndIf
									If lCusFil .Or. lCusEmp
										lPriApropri:=.T.
									EndIf
								EndIf
						EndCase
						If lFirst  .And. lTransEnd
							oSection3:Cell("nSALDQtd"):SetValue(aSalAtu[1])
							oSection3:Cell("nSALDCus"):SetValue(aSalAtu[mv_par10+1])
						EndIf
						Do Case
							Case Alltrim((cAliasTop)->ARQ) == "SD3" .And. !lContinua  .And. lTransEnd
								If Empty((cAliasTOP)->OP) .And. Empty((cAliasTOP)->PROJETO)
									oSection3:Cell("cCCPVPJOP"):SetValue('CC'+(cAliasTOP)->CC)
								ElseIf !Empty((cAliasTOP)->PROJETO)
									oSection3:Cell("cCCPVPJOP"):SetValue('PJ'+(cAliasTOP)->PROJETO)
								ElseIf !Empty((cAliasTOP)->OP)
									oSection3:Cell("cCCPVPJOP"):SetValue('OP'+(cAliasTOP)->OP)
								EndIf
							Case Alltrim((cAliasTop)->ARQ) == "SD1" .And. !lContinua .And. lTransEnd
								cTipoNf := 'F-'
								SD1->(dbGoTo((cAliasTop)->NRECNO))
								SD2->(dbSetOrder(3))
								If SD2->(dbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA))
									If SD2->D2_TIPO <> 'B'
										cTipoNf := 'C-'
									EndIf									
								EndIf
								oSection3:Cell("cCCPVPJOP"):SetValue(cTipoNf+(cAliasTOP)->FORNECEDOR)
							Case Alltrim((cAliasTop)->ARQ) == "SD2" .And. !lContinua .And. lTransEnd
								//����������������������������������������������������������������������Ŀ
								//�N - QNC: 002117                                                       �
								//�Corrigida a ultima coluna do relatorio onde apresentava nas notas     �
								//�de saida o n�mero do pedido de compra , ao inv�s de apresentar        �
								//�o codigo do cliente quando o D2_TIPO="N",                             �
								//�quando D2_TIPO="B" mostrar o codigo do fornecedor.                    �
								//������������������������������������������������������������������������
								If ((cAliasTop)->TIPONF) $ "B|D"
									oSection3:Cell("cCCPVPJOP"):SetValue('F-'+(cAliasTop)->FORNECEDOR)
								Else
									oSection3:Cell("cCCPVPJOP"):SetValue('C-'+(cAliasTop)->FORNECEDOR)
								EndIf
							Case lContinua .And. aDadosTran[14] == "SD3" .And. lTransEnd
								If Empty(aDadosTran[11]) .And. Empty(aDadosTran[12])
									oSection3:Cell("cCCPVPJOP"):SetValue('CC'+aDadosTran[13])
								ElseIf !Empty(aDadosTran[12])
									oSection3:Cell("cCCPVPJOP"):SetValue('PJ'+aDadosTran[12])
								ElseIf !Empty(aDadosTran[11])
									oSection3:Cell("cCCPVPJOP"):SetValue('OP'+aDadosTran[11])
								EndIf
						EndCase
						
						If lFirst .And. lTransEnd
							oSection3:PrintLine()
						Endif
						lTransEnd := .T.
						
						If !lInverteMov .Or. (lInverteMov .And. lPriApropri)
							If !lContinua //Acerto para utilizar o Array aDadosTranf[]
								dbSkip()
							EndIf
						EndIf
					EndDo
					
					If lFirst
						oReport:PrintText(STR0022+TransForm(aSalAtu[7],cPicB2Qt2),,oSection3:Cell('nSAICus'):ColPos()) //"QTD. NA SEGUNDA UM: "
					Else
						If !MTR900IsMNT()
							oReport:PrintText(STR0023)	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
							oReport:ThinLine()
							lImpSMov := .T.
						Else
							If FindFunction("NGProdMNT")
								aProdsMNT := aClone(NGProdMNT())
								If aScan(aProdsMNT, {|x| AllTrim(x) == AllTrim(SB1->B1_COD) }) == 0
									oReport:PrintText(STR0023)	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
									oReport:ThinLine()
									lImpSMov := .T.
								EndIf
							ElseIf SB1->B1_COD <> cProdMNT .And. SB1->B1_COD <> cProdTER
								oReport:PrintText(STR0023)	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
								oReport:ThinLine()
								lImpSMov := .T.
							EndIf
						EndIf
					EndIf
					
					oSection1:Finish()
					oSection2:Finish()
					If !lImpSMov
						oSection3:Finish()
					Endif
				EndDo
				dbSelectArea(cAliasTop)
				Else				
			#ENDIF
				dbSelectArea("SD1")
				If mv_par11 == 1
					dbSetOrder(5)
				Else
					If lCusFil .Or. lCusEmp
						cIndice:="D1_FILIAL+D1_COD+D1_SEQCALC+D1_NUMSEQ"
					Else
						cIndice:="D1_FILIAL+D1_COD+D1_LOCAL+D1_SEQCALC+D1_NUMSEQ"
					EndIf
					INDREGUA("SD1",cTrbSD1,cIndice,,DBFilter(),STR0019)	//"Selecionando Registros"
					nInd := RetIndex("SD1")
					#IFNDEF TOP
			  		   dbSetIndex(cTrbSD1+OrdBagExt())
					#ENDIF
					dbSetOrder(nInd+1)
				EndIf
				
				dbSelectArea("SD2")
				If mv_par11 == 1
					dbSetOrder(1)
				Else
					If lCusFil .Or. lCusEmp
						cIndice:="D2_FILIAL+D2_COD+D2_SEQCALC+D2_NUMSEQ"
					Else
						cIndice:="D2_FILIAL+D2_COD+D2_LOCAL+D2_SEQCALC+D2_NUMSEQ"
					EndIf
					INDREGUA("SD2",cTrbSD2,cIndice,,,STR0019)	//"Selecionando Registros"
					nInd := RetIndex("SD2")
					#IFNDEF TOP
					  dbSetIndex(cTrbSD2+OrdBagExt())
					#ENDIF
					dbSetOrder(nInd+1)
				EndIf
				
				dbSelectArea("SD3")
			
				If mv_par11 == 1
					dbSetOrder(3)
				Else
					If lCusFil .Or. lCusEmp
						cIndice:="D3_FILIAL+D3_COD+D3_SEQCALC+D3_NUMSEQ"
					Else
						cIndice:="D3_FILIAL+D3_COD+D3_LOCAL+D3_SEQCALC+D3_NUMSEQ"
					EndIf
			
					IndRegua("SD3",cTrbSD3,cIndice,,,STR0019)	//"Selecionando Registros"
			
					nInd := RetIndex("SD3")
					#IFNDEF TOP
			     	  dbSetIndex(cTrbSD3+OrdBagExt())
			 		#ENDIF
				    dbSetOrder(nInd+1)
				EndIf
				
				dbSelectArea("SB1")
				If ! lVEIC
					If nOrdem == 1
						dbSetOrder(1)
						dbseek(cFilial+mv_par01)
						cOrder := IndexKey()
					ElseIf nOrdem == 2
						dbSetOrder(2)
						dbseek(cFilial+mv_par03)
						cOrder := IndexKey()
					EndIf  
				Else
					If nOrdem == 1
						cOrder := "B1_FILIAL+B1_CODITE"
					ElseIf nOrdem == 2
						cOrder := "B1_FILIAL+B1_TIPO+B1_CODITE"
					EndIf  
				EndIf
				//������������������������������������������������������������������������Ŀ
				//�Transforma parametros Range em expressao Advpl                          �
				//��������������������������������������������������������������������������
				MakeAdvplExpr(oReport:uParam)
			
				cCondicao := 'B1_FILIAL == "'+xFilial("SB1")+'".And.' 
				cCondicao += 'B1_TIPO >= "'+mv_par03+'".And.B1_TIPO <="'+mv_par04+'".And.'
				If ! lVEIC
					cCondicao += 'B1_COD >= "'+mv_par01+'".And.B1_COD <="'+mv_par02+'".And.'
				Else
					cCondicao += 'B1_CODITE >= "'+mv_par01+'".And.B1_CODITE <="'+mv_par02+'".And.'
				Endif	
				cCondicao += 'B1_GRUPO >= "'+mv_par14+'".And.B1_GRUPO <="'+mv_par15+'".And.'	
				cCondicao += 'B1_COD <> "'+Substr(cProdImp,1,Len(B1_COD))+'"'
			
				oReport:Section(1):SetFilter(cCondicao,cOrder)
				
				dbSelectArea("SB1")
				oReport:SetMeter(nTotRegs)
				
				While !oReport:Cancel() .And. SB1->(!Eof())
					
					If oReport:Cancel()
						Exit
					EndIf
					
					oReport:IncMeter()
					
					dbSelectArea("SB2")
					//��������������������������������������������������Ŀ
					//� Se nao encontrar no arquivo de saldos ,nao lista �
					//����������������������������������������������������
					If !dbSeek(xFilial("SB2")+SB1->B1_COD+IF(lCusFil .Or. lCusEmp,"",mv_par08))
						dbSelectArea("SB1")
						dbSkip()
						Loop
					EndIf
					
					cProdAnt  := SB1->B1_COD
					cLocalAnt := alltrim(B2_LOCAL)
					
					dbSelectArea("SD1")
					dbSeek(cFilial+SB1->B1_COD+If(lCusFil .Or. lCusEmp,"",SB2->B2_LOCAL))
					dbSelectArea("SD2")
					dbSeek(cFilial+SB1->B1_COD+If(lCusFil .Or. lCusEmp,"",SB2->B2_LOCAL))
					dbSelectArea("SD3")
					dbSeek(cFilial+SB1->B1_COD+If(lCusFil .Or. lCusEmp.Or.lLocProc,"",SB2->B2_LOCAL))
					
					oSection3:Init()
					While .T.
						lImpSMov := .F.
						lImpS3   := .F.
						dbSelectArea("SD1")
						If !Eof() .and. D1_FILIAL == xFilial("SD1") .and. D1_COD = cProdAnt .and. If(lCusFil .Or. lCusEmp,.T.,alltrim(D1_LOCAL) = cLocalAnt)
							
							//��������������������������������������������������������������Ŀ
							//� Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  �
							//����������������������������������������������������������������
							dbSelectArea("SF4")
							dbSeek(xFilial("SF4")+SD1->D1_TES)
							dbSelectArea("SD1")
							//��������������������������������������������������������������Ŀ
							//� Executa ponto de entrada para verificar se considera TES que �
							//� NAO ATUALIZA saldos em estoque.                              �
							//����������������������������������������������������������������
							If lIxbConTes .And. SF4->F4_ESTOQUE != "S"
								lTesNEst := ExecBlock("MTAAVLTES",.F.,.F.)
								lTesNEst := If(ValType(lTesNEst) # "L",.F.,lTesNEst)
							EndIf
							
							If D1_ORIGLAN $ "LF" .Or. (SF4->F4_ESTOQUE != "S" .And. !lTesNEst)
								dbSkip()
								Loop
							Else
								If D1_DTDIGIT < mv_par05 .or. D1_DTDIGIT > mv_par06
									dbSkip()
									loop
								Else
									cSeqIni := IIf(mv_par11==1,D1_NUMSEQ,D1_SEQCALC+D1_NUMSEQ)
									cAlias := Alias()
								Endif
							EndIf
						EndIf
						
						dbSelectArea("SD2")
						If !Eof() .and. D2_FILIAL == xFilial("SD2") .and. D2_COD = cProdAnt .and. If(lCusFil .Or. lCusEmp,.T.,alltrim(D2_LOCAL) = cLocalAnt)
							
							dbSelectArea("SF4")
							dbSeek(cFilial+SD2->D2_TES)
							dbSelectArea("SD2")
							
							//��������������������������������������������������������������Ŀ
							//� Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  �
							//����������������������������������������������������������������
							//��������������������������������������������������������������Ŀ
							//� Executa ponto de entrada para verificar se considera TES que �
							//� NAO ATUALIZA saldos em estoque.                              �
							//����������������������������������������������������������������
							If lIxbConTes .And. SF4->F4_ESTOQUE != "S"
								lTesNEst := ExecBlock("MTAAVLTES",.F.,.F.)
								lTesNEst := If(ValType(lTesNEst) # "L",.F.,lTesNEst)
							EndIf
							
							If D2_ORIGLAN == "LF" .Or. (SF4->F4_ESTOQUE != "S" .And. !lTesNEst)
								dbSkip()
								Loop
							Else
								If D2_EMISSAO < mv_par05 .or. D2_EMISSAO > mv_par06
									dbSkip()
									Loop
								Else
									If mv_par11 == 1
										If D2_NUMSEQ < cSeqIni
											cSeqIni := D2_NUMSEQ
											cAlias  := Alias()
										Endif
									Else
										If D2_SEQCALC+D2_NUMSEQ < cSeqIni
											cSeqIni := D2_SEQCALC+D2_NUMSEQ
											cAlias  := Alias()
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
						
						dbSelectArea("SD3")
						If !Eof() .and. D3_FILIAL == xFilial("SD3") .and. D3_COD = cProdAnt .and. If(lCusFil .Or. lCusEmp.Or.lLocProc,.T.,alltrim(D3_LOCAL) = cLocalAnt)
							//����������������������������������������������������������������Ŀ
							//� Quando movimento ref apropr. indireta, so considera os         �
							//� movimentos com destino ao almoxarifado de apropriacao indireta.�
							//������������������������������������������������������������������
							lInverteMov:=.F.
							If alltrim(D3_LOCAL) != cLocalAnt .Or. lCusFil .Or. lCusEmp
								If !(Substr(D3_CF,3,1) == "3")
									If !(lCusFil .Or. lCusEmp)
										dbSkip()
										Loop
									EndIf
								ElseIf lPriApropri
									lInverteMov:=.T.
								EndIf
							EndIf
							
							If D3_EMISSAO < mv_par05 .or. D3_EMISSAO > mv_par06
								dbSkip()
								Loop
							EndIf
							// VALIDACAO TRATAMENTO SE CONSIDERA OS ESTORNO E SE CONSIDERA MOVIMENTOS WMS
							If !D3Valido()
								dbSkip()
								Loop
							EndIf
							
							//����������������������������������������������������������������Ŀ
							//� Caso seja uma transferencia de localizacao verifica se lista   �
							//� o movimento ou nao                                             �
							//������������������������������������������������������������������
							If mv_par13 == 2 .And. Substr(D3_CF,3,1) == "4"
								cNumSeqTr := SD3->D3_COD+SD3->D3_NUMSEQ+SD3->D3_LOCAL
								nRegTr    := Recno()
								dbSkip()
								If SD3->D3_COD+SD3->D3_NUMSEQ+SD3->D3_LOCAL == cNumSeqTr
									dbSkip()
									Loop
								Else
									dbGoto(nRegTr)
								EndIf
							EndIf
							If mv_par11 == 1
								If D3_NUMSEQ < cSeqIni
									cSeqIni := D3_NUMSEQ
									cAlias  := Alias()
								EndIf
							Else
								If D3_SEQCALC+D3_NUMSEQ < cSeqIni
									cSeqIni := D3_SEQCALC+D3_NUMSEQ
									cAlias  := Alias()
								EndIf
							EndIf
						EndIf
						
						If !Empty(cAlias)
							dbSelectArea(cAlias)
							cCampo1 := Subs(cAlias,2,2)+IIf(cAlias=="SD1","_DTDIGIT","_EMISSAO")
							cCampo2 := Subs(cAlias,2,2)+"_TES"
							cCampo3 := Subs(cAlias,2,2)+"_CF"
							cCampo4 := Subs(cAlias,2,2)+IIf(mv_par09 $ "Ss","_NUMSEQ","_DOC" )
							
							If lFirst
								MR900ImpS1(@aSalAtu,,.F.,lVEIC,lCusFil,lCusEmp,oSection1,oSection2,oReport)
								lFirst  := .F.
								lFirst1 := .F.
							EndIf
							
							oSection3:Cell("dDtMov"):SetValue(&cCampo1)
							If cAlias == "SD3"
								oSection3:Cell("cTES"):SetValue(D3_TM)
							Else
								oSection3:Cell("cTES"):SetValue(&cCampo2)
							EndIf
							
							If ( cPaisLoc=="BRA" )
								oSection3:Cell("cCF"):Show()
								oSection3:Cell("cCF"):SetValue(&cCampo3)
							Else
								oSection3:Cell("cCF"):Hide()
								oSection3:Cell("cCF"):SetValue("   ")
							EndIf
							oSection3:Cell("cDoc"):SetValue(&cCampo4)
							
							Do Case
								Case cAlias = "SD1"
									lDev:=MTR900Dev("SD1")
									If D1_TES <= "500" .And. !lDev
										If SF1->F1_TIPO != "C"
											oSection3:Cell("nCusMov"):SetValue((&(Eval(bBloco,"D1_CUSTO",iif(mv_par10==1," ",mv_par10))) / D1_QUANT))
											oSection3:Cell("nCusMov"):Show()
										Else
											oSection3:Cell("nCusMov"):SetValue(0)
											oSection3:Cell("nCusMov"):Hide()
										EndIf
										
										oSection3:Cell("nENTQtd"):Show()
										oSection3:Cell("nENTCus"):Show()
										
										oSection3:Cell("nENTQtd"):SetValue(D1_QUANT)
										oSection3:Cell("nENTCus"):SetValue(&(Eval(bBloco,"D1_CUSTO",iif(mv_par10==1," ",mv_par10))))
										
										oSection3:Cell("nSAIQtd"):Hide()
										oSection3:Cell("nSAICus"):Hide()
										oSection3:Cell("nSAIQtd"):SetValue(0)
										oSection3:Cell("nSAICus"):SetValue(0)
										
										aSalAtu[1] 			+= D1_QUANT
										aSalAtu[mv_par10+1]	+= &(Eval(bBloco,"D1_CUSTO",iif(mv_par10==1," ",mv_par10)))
										aSalAtu[7]			+= D1_QTSEGUM
									Else
										If SF1->F1_TIPO != "C"
											oSection3:Cell("nCusMov"):SetValue((&(Eval(bBloco,"D1_CUSTO",iif(mv_par10==1," ",mv_par10))) / D1_QUANT))
											oSection3:Cell("nCusMov"):Show()
										Else
											oSection3:Cell("nCusMov"):SetValue(0)
											oSection3:Cell("nCusMov"):Hide()
										EndIf
										oSection3:Cell("nENTQtd"):Hide()
										oSection3:Cell("nENTCus"):Hide()
										oSection3:Cell("nENTQtd"):SetValue(0)
										oSection3:Cell("nENTCus"):SetValue(0)
										
										oSection3:Cell("nSAIQtd"):Show()
										oSection3:Cell("nSAICus"):Show()
										
										If lDev
											oSection3:Cell("nSAIQtd"):SetValue(D1_QUANT * -1)
											oSection3:Cell("nSAICus"):SetValue(&(Eval(bBloco,"D1_CUSTO",iif(mv_par10==1," ",mv_par10))) * -1)
			
											aSalAtu[1]			+= D1_QUANT
											aSalAtu[mv_par10+1]	+= &(Eval(bBloco,"D1_CUSTO",iif(mv_par10==1," ",mv_par10)))
											aSalAtu[7]			+= D1_QTSEGUM
										Else
											oSection3:Cell("nSAIQtd"):SetValue(D1_QUANT)
											oSection3:Cell("nSAICus"):SetValue(&(Eval(bBloco,"D1_CUSTO",iif(mv_par10==1," ",mv_par10))))
			
											aSalAtu[1]			-= D1_QUANT
											aSalAtu[mv_par10+1]	-= &(Eval(bBloco,"D1_CUSTO",iif(mv_par10==1," ",mv_par10)))
											aSalAtu[7]			-= D1_QTSEGUM
										EndIf
									EndIf
								Case cAlias = "SD2"
									lDev:=MTR900Dev("SD2")
									If D2_TES <= "500" .Or. lDev
										oSection3:Cell("nSAIQtd"):Hide()
										oSection3:Cell("nSAICus"):Hide()
										oSection3:Cell("nSAIQtd"):SetValue(0)
										oSection3:Cell("nSAICus"):SetValue(0)
										
										oSection3:Cell("nENTQtd"):Show()
										oSection3:Cell("nENTCus"):Show()
										If lDev
											oSection3:Cell("nENTQtd"):SetValue(D2_QUANT  * -1)
											oSection3:Cell("nENTCus"):SetValue(&(Eval(bBloco,"D2_CUSTO",mv_par10)) * -1)
											
											aSalAtu[1]			-= D2_QUANT
											aSalAtu[mv_par10+1]	-= &(Eval(bBloco,"D2_CUSTO",mv_par10))
											aSalAtu[7]			-= D2_QTSEGUM
										Else
											oSection3:Cell("nENTQtd"):SetValue(D2_QUANT)
											oSection3:Cell("nENTCus"):SetValue(&(Eval(bBloco,"D2_CUSTO",mv_par10)))
											
											aSalAtu[1]			+= D2_QUANT
											aSalAtu[mv_par10+1]	+= &(Eval(bBloco,"D2_CUSTO",mv_par10))
											aSalAtu[7]			+= D2_QTSEGUM
										EndIf
										If SF2->F2_TIPO != "C"
											oSection3:Cell("nCusMov"):SetValue((&(Eval(bBloco,"D2_CUSTO",mv_par10)) / D2_QUANT))
											oSection3:Cell("nCusMov"):Show()
										Else
											oSection3:Cell("nCusMov"):SetValue(0)
											oSection3:Cell("nCusMov"):Hide()
										EndIf
									Else
										oSection3:Cell("nENTQtd"):Hide()
										oSection3:Cell("nENTCus"):Hide()
										oSection3:Cell("nENTQtd"):SetValue(0)
										oSection3:Cell("nENTCus"):SetValue(0)
										
										oSection3:Cell("nSAIQtd"):Show()
										oSection3:Cell("nSAICus"):Show()
										
										If SF2->F2_TIPO != "C"
											oSection3:Cell("nCusMov"):SetValue((&(Eval(bBloco,"D2_CUSTO",mv_par10)) / D2_QUANT))
											oSection3:Cell("nCusMov"):Show()
										Else
											oSection3:Cell("nCusMov"):SetValue(0)
											oSection3:Cell("nCusMov"):Hide()
										EndIf
										
										oSection3:Cell("nSAIQtd"):SetValue(D2_QUANT)
										oSection3:Cell("nSAICus"):SetValue(&(Eval(bBloco,"D2_CUSTO",mv_par10)))
			
										aSalAtu[1]			-= D2_QUANT
										aSalAtu[mv_par10+1]	-= &(Eval(bBloco,"D2_CUSTO",mv_par10))
										aSalAtu[7]			-= D2_QTSEGUM
									EndIf
								Otherwise
									lDev := .F.
									If	lInverteMov
										If D3_TM > "500"
											
											oSection3:Cell("nENTQtd"):Show()
											oSection3:Cell("nENTCus"):Show()
											oSection3:Cell("nCusMov"):Show()
											
											oSection3:Cell("nENTQtd"):SetValue(D3_QUANT)
											oSection3:Cell("nENTCus"):SetValue(&(Eval(bBloco,"D3_CUSTO",mv_par10)))
											oSection3:Cell("nCusMov"):SetValue((&(Eval(bBloco,"D3_CUSTO",mv_par10)) / D3_QUANT))
											
											oSection3:Cell("nSAIQtd"):Hide()
											oSection3:Cell("nSAICus"):Hide()
											oSection3:Cell("nSAIQtd"):SetValue(0)
											oSection3:Cell("nSAICus"):SetValue(0)
											
											aSalAtu[1]			+= D3_QUANT
											aSalAtu[mv_par10+1]	+= &(Eval(bBloco,"D3_CUSTO",mv_par10))
											aSalAtu[7]			+= D3_QTSEGUM
										Else
											oSection3:Cell("nENTQtd"):Hide()
											oSection3:Cell("nENTCus"):Hide()
											oSection3:Cell("nENTQtd"):SetValue(0)
											oSection3:Cell("nENTCus"):SetValue(0)
											
											oSection3:Cell("nCusMov"):Show()
											oSection3:Cell("nSAIQtd"):Show()
											oSection3:Cell("nSAICus"):Show()
											
											oSection3:Cell("nCusMov"):SetValue((&(Eval(bBloco,"D3_CUSTO",mv_par10)) / D3_QUANT))
											oSection3:Cell("nSAIQtd"):SetValue(D3_QUANT)
											oSection3:Cell("nSAICus"):SetValue(&(Eval(bBloco,"D3_CUSTO",mv_par10)))
											
											aSalAtu[1]			-= D3_QUANT
											aSalAtu[mv_par10+1]	-= &(Eval(bBloco,"D3_CUSTO",mv_par10))
											aSalAtu[7]			-= D3_QTSEGUM
										EndIf
										If lCusFil .Or. lCusEmp
											lPriApropri:=.F.
										EndIf
									Else
										If D3_TM <= "500"
											
											oSection3:Cell("nENTQtd"):Show()
											oSection3:Cell("nENTCus"):Show()
											oSection3:Cell("nCusMov"):Show()
											
											oSection3:Cell("nENTQtd"):SetValue(D3_QUANT)
											oSection3:Cell("nENTCus"):SetValue(&(Eval(bBloco,"D3_CUSTO",mv_par10)))
											oSection3:Cell("nCusMov"):SetValue((&(Eval(bBloco,"D3_CUSTO",mv_par10)) / D3_QUANT))
											
											oSection3:Cell("nSAIQtd"):Hide()
											oSection3:Cell("nSAICus"):Hide()
											oSection3:Cell("nSAIQtd"):SetValue(0)
											oSection3:Cell("nSAICus"):SetValue(0)
											
											aSalAtu[1]			+= D3_QUANT
											aSalAtu[mv_par10+1]	+= &(Eval(bBloco,"D3_CUSTO",mv_par10))
											aSalAtu[7]			+= D3_QTSEGUM
										Else
											oSection3:Cell("nENTQtd"):Hide()
											oSection3:Cell("nENTCus"):Hide()
											oSection3:Cell("nENTQtd"):SetValue(0)
											oSection3:Cell("nENTCus"):SetValue(0)
											
											oSection3:Cell("nCusMov"):Show()
											oSection3:Cell("nSAIQtd"):Show()
											oSection3:Cell("nSAICus"):Show()
											
											oSection3:Cell("nCusMov"):SetValue((&(Eval(bBloco,"D3_CUSTO",mv_par10)) / D3_QUANT))
											oSection3:Cell("nSAIQtd"):SetValue(D3_QUANT)
											oSection3:Cell("nSAICus"):SetValue(&(Eval(bBloco,"D3_CUSTO",mv_par10)))
											
											aSalAtu[1]			-= D3_QUANT
											aSalAtu[mv_par10+1]	-= &(Eval(bBloco,"D3_CUSTO",mv_par10))
											aSalAtu[7]			-= D3_QTSEGUM
										EndIf
										If lCusFil .Or. lCusEmp
											lPriApropri:=.T.
										EndIf
									EndIf
							EndCase
							
							oSection3:Cell("nSALDQtd"):SetValue(aSalAtu[1])
							oSection3:Cell("nSALDCus"):SetValue(aSalAtu[mv_par10+1])
							
							Do Case
								Case cAlias = "SD3"  && movimentos (SD3)
									If Empty(D3_OP) .And. Empty(D3_PROJPMS)
										oSection3:Cell("cCCPVPJOP"):SetValue('CC'+D3_CC)
									ElseIf !Empty(D3_PROJPMS)
										oSection3:Cell("cCCPVPJOP"):SetValue('PJ'+D3_PROJPMS)
									ElseIf !Empty(D3_OP)
										oSection3:Cell("cCCPVPJOP"):SetValue('OP'+D3_OP)
									EndIf
								Case cAlias = "SD1"  && compras    (SD1)
									cTipoNf := 'F-'
									aAreaSD2:=SD2->(GetArea())
									SD2->(dbSetOrder(3))
									If SD2->(dbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA))
										If !(SD2->D2_TIPO $ 'B|D')
											cTipoNf := 'C-'
										EndIf									
									EndIf
									RestArea(aAreaSD2)
									dbSelectArea('SD1')
									oSection3:Cell("cCCPVPJOP"):SetValue(cTipoNf+D1_FORNECE)
								Case cAlias = "SD2"  && vendas     (SD2)
									If D2_TIPO $ "B|D"
										oSection3:Cell("cCCPVPJOP"):SetValue('F-'+D2_CLIENTE)
									Else
										oSection3:Cell("cCCPVPJOP"):SetValue('C-'+D2_CLIENTE)
									EndIf
							EndCase
				
							cSeqIni := Replicate("z",6)
							cAlias := ""
							
							If !lImpSMov
								oSection3:PrintLine()
							Endif
							
							If !lInverteMov .Or. (lInverteMov .And. lPriApropri)
								dbSkip()
							EndIf
						Else
							If !lFirst
								oReport:PrintText(STR0022+AllTrim(TransForm(aSalAtu[7],cPicB2Qt2)),,oSection3:Cell('nSAICus'):ColPos()) //"QTD. NA SEGUNDA UM: "
								lImpS3 := .T.
							Else
								//��������������������������������������������������������Ŀ
								//� Verifica se deve ou nao listar os produtos s/movimento �
								//����������������������������������������������������������
								If mv_par07 == 1
									MR900ImpS1(@aSalAtu,,.F.,lVEIC,lCusFil,lCusEmp,oSection1,oSection2,oReport)
									
									If !MTR900IsMNT()
										oReport:PrintText(STR0023)	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
										oReport:ThinLine()
										lImpSMov := .T.
									Else
										If FindFunction("NGProdMNT")
											aProdsMNT := aClone(NGProdMNT())
											If aScan(aProdsMNT, {|x| AllTrim(x) == AllTrim(SB1->B1_COD) }) == 0
												oReport:PrintText(STR0023)	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
												oReport:ThinLine()
												lImpSMov := .T.
											EndIf
										ElseIf SB1->B1_COD <> cProdMNT .And. SB1->B1_COD <> cProdTER
											oReport:PrintText(STR0023)	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
											oReport:ThinLine()
											lImpSMov := .T.
										EndIf
									EndIf	
									
								EndIf
							EndIf
							Exit
						EndIf
					EndDo
					lFirst  := .T.
					oSection1:Finish()
					oSection2:Finish()
					If !lImpSMov .And. lImpS3
						oSection3:Finish()
					EndIf
					
					dbSelectArea("SB1")
					dbSkip()
				EndDo
				
				dbSelectArea("SD1")
				If !Empty(cTrbSD1) .And. File(cTrbSD1 + OrdBagExt())
					RetIndex("SD1")
					Ferase(cTrbSD1+OrdBagExt())
				EndIf
				dbSetOrder(1)
				dbSelectArea("SD2")
				If !Empty(cTrbSD2) .And. File(cTrbSD2 + OrdBagExt())
					RetIndex("SD2")
					Ferase(cTrbSD2+OrdBagExt())
				EndIf
				dbSetOrder(1)
				dbSelectArea("SD3")
				If !Empty(cTrbSD3) .And. File(cTrbSD2 + OrdBagExt())
					RetIndex("SD3")
					Ferase(cTrbSD3+OrdBagExt())
				EndIf
				dbSetOrder(1)	
	        #IFDEF TOP
		    	EndIf
			#ENDIF

		EndIf
        
        #IFDEF TOP
			If !(TcSrvType()=="AS/400") .And. !("POSTGRES" $ TCGetDB())
		    	If Select(cAliasTop)>0
		    		dbSelectArea(cAliasTop)
		       		dbCloseArea() 
		       	Endif 
			EndIf
		#ENDIF
	Next nForFilial
	
EndIf

// Restaura Filial Corrente
cFilAnt := cFilBack

Return NIL
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MATR900R3 � Autor � Paulo Boschetti       � Data � 06.10.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Kardex fisico - financeiro (Antigo)                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Rodrigo     �24/06/98�XXXXXX�Acerto no tamanho do documento para 12    ���
���            �        �      �posicoes                                  ���
���Rodrigo     �17/07/98�13742A�Acerto na impressao de devolucoes conforme���
���            �        �      �MATR910                                   ���
���Rodrigo Sart�05/11/98�XXXXXX� Acerto p/ Bug Ano 2000                   ���
���Bruno Sobies�18/12/98�Melhor�Exclucao impressao do CF nas localizacoes ���
���Cesar       �25/03/99�20051A�Alteracao do Lay-Out p/ Sair #OP Completa ���
���Patricia Sal�26/11/99�25253A�Acerto da Coluna do TES(ano c/ 4 digitos).���
�������������������������������������������������������������������������Ĵ��
���Marcos Hirak�11/05/05�XXXXXX�Imprimir B1_CODITE quando for gestao de   ���
���            �        �      �Concessionarias ( MV_VEICULO = "S").      ���
���            �        �      �foi retirado a variavel "cProdant"        ���
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MATR900R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local titulo   := STR0001		//"Kardex Fisico"
Local cDesc1   := STR0002		//"Este programa emitir� uma rela��o com as movimenta��es"
Local cDesc2   := STR0003		//"dos produtos selecionados, ordenados sequencialmente."
Local cDesc3   := ""
Local cString  := "SB1"
Local lRet     := .T.
Local nTamSX1  := Len(SX1->X1_GRUPO)

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         �
//����������������������������������������������������������������
Local aArea1	:= Getarea() 
Local lEnd		:= .F.

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private para SIGAVEI, SIGAPEC e SIGAOFI       �
//����������������������������������������������������������������
Private lVEIC   := Upper(GetMV("MV_VEICULO"))=="S"
Private aSB1Cod := {}
Private aSB1Ite := {}
Private nCOL1	:= 0
Private Tamanho := "G"
Private wnrel   := "MATR900"
Private aOrd    := {OemToAnsi(STR0004),OemToAnsi(STR0005)}						//" Codigo Produto "###" Tipo do Produto"
Private aReturn := {OemToAnsi(STR0006), 1,OemToAnsi(STR0007), 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
Private aLinha  := { },nLastKey := 0
Private cPerg   :="MTR900"
Private bBloco  := { |nV,nX| Trim(nV)+IIf(Valtype(nX)='C',"",Str(nX,1)) }

//��������������������������������������������������������������Ŀ
//�MV_CUSFIL - Parametro utilizado para verificar se o sistema   |
//|utiliza custo unificado por:                                  |
//|      F = Custo Unificado por Filial                          |
//|      E = Custo Unificado por Empresa                         |
//|      A = Custo Unificado por Armazem                         | 
//����������������������������������������������������������������
Private lCusFil    := AllTrim(SuperGetMV('MV_CUSFIL' ,.F.,"A")) == "F"
Private lCusEmp    := AllTrim(SuperGetMv('MV_CUSFIL' ,.F.,"A")) == "E"

//��������������������������������������������������������������Ŀ
//�MV_CUSREP - Parametro utilizado para habilitar o calculo do   �
//�            Custo de Reposicao.                               �
//����������������������������������������������������������������
Private lCusRep  := SuperGetMv("MV_CUSREP",.F.,.F.) .And. (FindFunction("MA330AvRep") .And. MA330AvRep())

//�����������������������������������������������������������������Ŀ
//| Checa versao dos fontes relacionados. NAO REMOVER !!!           �
//�������������������������������������������������������������������
If !(FindFunction("SIGACUSA_V")	.And. SIGACUSA_V() >= 20091212)
	Final(OemToAnsi(STR0062)) //"Atualizar SIGACUSA.PRX"
EndIf
If !(FindFunction("SIGACUSB_V")	.And. SIGACUSB_V() >= 20091212)
	Final(OemToAnsi(STR0063)) //"Atualizar SIGACUSB.PRX"
EndIf
If !(FindFunction("MATXFUNB_V")	.And. MATXFUNB_V() >= 20091212)
	Final(OemToAnsi(STR0064)) //"Atualizar MATXFUNB.PRX"
EndIf
If !(FindFunction("MATA330_V")	.And. MATA330_V() >= 20091212)
	Final(OemToAnsi(STR0067)) //"Atualizar MATA330.PRX"
EndIf

dbSelectArea("SF4")
dbSetOrder(1)

dbSelectArea("SD3")
dbSetOrder(1)

dbSelectArea("SD2")
dbSetOrder(1)

dbSelectArea("SF2")
dbSetOrder(1)

dbSelectArea("SD1")
dbSetOrder(1)

dbSelectArea("SF1")
dbSetOrder(1)

dbSelectArea("SB2")
dbSetOrder(1)

dbSelectArea("SB1")
dbSetOrder(1)
//��������������������������������������������������������������Ŀ
//� Ajusta perguntas no SX1 a fim de preparar o relatorio p/     �
//� custo unificado por empresa/Filial                           �
//����������������������������������������������������������������
If lCusfil .Or. lCusEmp
	MTR900CUnf(lCusFil,lCusEmp)
EndIf

//��������������������������������������������������������������Ŀ
//� Ajusta perguntas no SX1 									 �
//����������������������������������������������������������������
AjustaSX1()

//��������������������������������������������������������������Ŀ
//� Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                �
//����������������������������������������������������������������
aSB1Cod	:= TAMSX3("B1_COD")
aSB1Ite	:= TAMSX3("B1_CODITE")

If lVEIC

   dbSelectArea("SX1")
   dbSetOrder(1)
   dbSeek(PADR(cPerg,nTamSX1))
   Do While SX1->X1_GRUPO == PADR(cPerg,nTamSX1) .And. !SX1->(Eof())
      If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. ;
	     (SX1->X1_TAMANHO <> aSB1Ite[1] .Or. Upper(SX1->X1_F3) <> "VR4")
         RecLock("SX1",.F.)
         SX1->X1_TAMANHO := aSB1Ite[1]
         SX1->X1_F3 := "VR4"
         dbCommit()
         MsUnlock()
      EndIf
      dbSkip()
   EndDo
   dbCommitAll()
   RestArea(aArea1)
Else
   dbSelectArea("SX1")
   dbSetOrder(1)
   dbSeek(PADR(cPerg,nTamSX1))
   Do While SX1->X1_GRUPO == PADR(cPerg,nTamSX1) .And. !SX1->(Eof())
      If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. ;
	     (SX1->X1_TAMANHO <> aSB1Cod[1] .Or. Upper(SX1->X1_F3) <> "SB1")
         RecLock("SX1",.F.)
         SX1->X1_TAMANHO := aSB1Cod[1]
         SX1->X1_F3 := "SB1"
         dbCommit()
         MsUnlock()
      EndIf
      dbSkip()
   EndDo
   dbCommitAll()
   RestArea(aArea1)
EndIf

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//����������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                     �
//� mv_par01         // Do produto                           �
//� mv_par02         // Ate o produto                        �
//� mv_par03         // Do tipo                              �
//� mv_par04         // Ate o tipo                           �
//� mv_par05         // Da data                              �
//� mv_par06         // Ate a data                           �
//� mv_par07         // Lista produtos s/movimento           �
//� mv_par08         // Qual Local (almoxarifado)            �
//� MV_par09         // (d)OCUMENTO/(s)EQUENCIA              �
//� mv_par10         // moeda selecionada ( 1 a 5 )          �
//� mv_par11         // Seq.de Digitacao /Calculo            �
//� mv_par12         // Pagina Inicial                       �
//� mv_par13         // Lista Transf Locali (Sim/Nao)        �
//� mv_par14         // Do  Grupo                            �
//� mv_par15         // Ate o Grupo                          �
//� mv_par16         // Seleciona Filial?                    �
//� mv_par17         // Qual Custo ? ( Medio / Reposicao )   �
//������������������������������������������������������������
Pergunte("MTR900",.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

If nLastKey = 27
	dbClearFilter()
	lRet := .F.
EndIf

If lRet

	SetDefault(aReturn,cString)

	If nLastKey = 27
		dbClearFilter()
		lRet := .F.
	EndIf

	If lRet 
		RptStatus( { |lEnd| R900Imp( @lEnd, wnRel, tamanho, titulo ) }, titulo )
    EndIf

EndIf    

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R900IMP  � Autor � Rodrigo de A. Sartorio� Data � 16.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R900Imp(ExpL1,ExpC1,ExpC2,ExpC3)		                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1 = var. p/ controle de interrupcao pelo usuario 	  ���
���          � ExpC1 = codigo do relatorio                                ���
���          � ExpC2 = codigo ref. ao tamanho do relatorio (P/M/G)        ���
���          � ExpC3 = titulo do relatorio                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR900			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R900Imp(lEnd,WnRel,tamanho,titulo)

Static lIxbConTes  := NIL

Local aDadosTran:= {}
Local aAreaSD2  := {}
Local lContinua := .F.
Local nTam      := 18
Local CbTxt,CbCont,Cabec1,Cabec2
Local cSeqIni   := Replicate("z",6)
Local cAlias    := ""
Local cProdAnt  := ""
Local cLocalAnt := ""
Local cCampo1   := "" 
Local cCampo2   := "" 
Local cCampo3   := "" 
Local cCampo4   := ""
Local cNumSeqTr := "" 
Local cCusto    := ""
Local cTipoNf   := ""
Local nTotRegs  := 0
Local nRegTr    := 0
Local lFirst    := .T.
Local lFirst1   := .T.
Local lTransEnd := .T.
Local aSalAtu   := { 0,0,0,0,0,0,0 } , nTipo
Local nEntrada  := nSaida :=0
Local nCEntrada := nCSaida:=0
Local nInd      := 0
Local cPicB2Qt  := PesqPictQt("B2_QATU"  ,nTam)
Local cPicB2Qt2 := PesqPictQt("B2_QTSEGUM",nTam)
Local cPicD1Qt  := PesqPictQt("D1_QUANT" ,nTam)
Local cPicD2Qt  := PesqPictQt("D2_QUANT" ,nTam)
Local cPicD3Qt  := PesqPictQt("D3_QUANT" ,nTam)
Local cPicB2Cust:= PesqPict("SB2","B2_CM"+Str(mv_par10,1),nTam,mv_par10)
Local cPicD1Cust:= PesqPict("SD1","D1_CUSTO"+IIf(mv_par10 == 1 ,"",Str(mv_par10,1)),nTam,mv_par10)
Local cPicD2Cust:= PesqPict("SD2","D2_CUSTO"+Str(mv_par10,1),nTam,mv_par10)
Local cPicD3Cust:= PesqPict("SD3","D3_CUSTO"+Str(mv_par10,1),nTam,mv_par10)
Local cTRBSD1   := CriaTrab(,.F.)
Local cTRBSD2   := Subs(cTrbSD1,1,7)+"A"
Local cTRBSD3   := Subs(cTrbSD1,1,7)+"B"
Local lDev  // Flag que indica se nota � devolu�ao (.T.) ou nao (.F.)
// Indica se esta listando relatorio do almox. de processo
Local lLocProc  := alltrim(mv_par08) == SuperGetMv("MV_LOCPROC")
// Indica se deve imprimir movimento invertido (almox. de processo)
Local lInverteMov:= .F.
Local lPriApropri:= .T.

//��������������������������������������������������������������Ŀ
//� Verifica se existe ponto de entrada                          �
//����������������������������������������������������������������
Local lTesNEst := .F.

//��������������������������������������������������������������Ŀ
//� Codigo do produto importado - NAO DEVE SER LISTADO           �
//����������������������������������������������������������������
Local cProdImp := GetMV("MV_PRODIMP")

Local cAliasTop:="KARDEXSQL"
Local cQuery   := ""
Local cQuery2  := ""
Local cQueryD1 := ""
Local cQueryD2 := ""
Local cQueryD3 := ""
Local cQueryD1P:= ""
Local cQueryD2P:= ""
Local cQueryD3P:= "" 
Local cQuerySub:= ""
Local cQueryB1A:= "" 	
Local cQueryB1B:= "" 	
Local cQueryB1C:= "" 	
Local cQueryB1D:= "" 	

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         �
//����������������������������������������������������������������
Local cArq1     := "" 
Local nInd1     := 0

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para processamento por Filial           �
//����������������������������������������������������������������
Local aFilsCalc := MatFilCalc( Iif (!IsBlind(), mv_par16 == 1, .F.) )   

Local cFilBack  := cFilAnt
Local nForFilial:= 0
Local cProdMNT := GetMv("MV_PRODMNT")
Local cProdTER := GetMv("MV_PRODTER")
Local aProdsMNT := {}
Local nX

//��������������������������������������������������������������Ŀ
//� Alerta o usuario que o custo de reposicao esta desativado.   �
//����������������������������������������������������������������
If mv_par17==2 .And. !lCusRep
	Help(" ",1,"A910CUSRP")
	mv_par17 := 1
EndIf

cProdMNT := cProdMNT + Space(15-Len(cProdMNT))
cProdTER := cProdTER + Space(15-Len(cProdTER))

If !Empty(aFilsCalc)

	For nForFilial := 1 To Len( aFilsCalc )
	
		If aFilsCalc[ nForFilial, 1 ]
		
			cFilAnt := aFilsCalc[ nForFilial, 2 ]
	
			If !lVEIC
				cQueryB1A:= " AND SB1.B1_COD >= '" + mv_par01 + "'"
				cQueryB1A+= " AND SB1.B1_COD <= '" + mv_par02 + "'"
			Else
				cQueryB1A:= " AND SB1.B1_CODITE >= '" + mv_par01 + "'"
				cQueryB1A+= " AND SB1.B1_CODITE <= '" + mv_par02 + "'"
			EndIf
	
			cQueryB1B:= " AND SB1.B1_COD = SB1EXS.B1_COD"
	
			If !lCusEmp
				cQueryB1C:= " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
			EndIf	

			cQueryB1C+= " AND SB1.B1_TIPO >= '"		+ mv_par03	+ "'"
			cQueryB1C+= " AND SB1.B1_TIPO <= '"		+ mv_par04	+ "'"
			cQueryB1C+= " AND SB1.B1_GRUPO >= '"	+ mv_par14	+ "'"
			cQueryB1C+= " AND SB1.B1_GRUPO <= '"	+ mv_par15	+ "'"
			cQueryB1C+= " AND SB1.B1_COD <> '"		+ cProdimp	+ "'"
			cQueryB1C+= " AND SB1.D_E_L_E_T_<>'*'"
			
			If !lCusEmp
				cQueryB1D:= " SB1EXS.B1_FILIAL = '" + xFilial("SB1")+"'" 
				cQueryB1D+= " AND"
			EndIf	
	
			If ! lVEIC
				If lCusEmp
					cQueryB1D+= " SB1EXS.B1_COD >= '" + mv_par01 + "'"
				Else
					cQueryB1D+= " SB1EXS.B1_COD >= '" + mv_par01 + "'"
				EndIf
				cQueryB1D+= " AND SB1EXS.B1_COD <= '" + mv_par02 + "'"
			Else
				cQueryB1D+= " SB1EXS.B1_CODITE >= '" + mv_par01 + "'"
				cQueryB1D+= " AND SB1EXS.B1_CODITE <= '" + mv_par02 + "'"
			EndIf
	
			cQueryB1D+= " AND SB1EXS.B1_TIPO >= '"	+ mv_par03 + "'"
			cQueryB1D+= " AND SB1EXS.B1_TIPO <= '"	+ mv_par04 + "'"
			cQueryB1D+= " AND SB1EXS.B1_GRUPO >= '" + mv_par14 + "'"
			cQueryB1D+= " AND SB1EXS.B1_GRUPO <= '" + mv_par15 + "'"
			cQueryB1D+= " AND SB1EXS.B1_COD <> '"	+ cProdimp + "'"
	
			cQueryB1D+= " AND SB1EXS.D_E_L_E_T_<> '*'"
			
			lIxbConTes := IF(lIxbConTes == NIL,ExistBlock("MTAAVLTES"),lIxbConTes)
			
			//��������������������������������������������������������������Ŀ
			//� Verifica se utiliza custo unificado por Filial/Empresa       �
			//����������������������������������������������������������������
			lCusFil:=lCusFil .And. mv_par08 == Repl("*",TamSX3("B2_LOCAL")[1])
			lCusEmp:=lCusEmp .And. mv_par08 == Repl("#",TamSX3("B2_LOCAL")[1])
			
			//��������������������������������������������������������������Ŀ
			//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
			//����������������������������������������������������������������
			cbtxt := Space(10)
			cbcont:= 0
			li    := 80
			m_pag := mv_par12
	
			titulo := OemToAnsi(STR0008)+IIf(mv_par11==1,IIf(lCusRep .And. mv_par17==2,STR0065,STR0009),IIf(lCusRep .And. mv_par17==2,STR0066,STR0010) ) + " " + IIf(lCusFil,"",OemToAnsi(STR0011)+" "+mv_par08)		// "KARDEX FISICO-FINANCEIRO "###"(SEQUENCIA)"###"(CALCULO)"###"L O C A L :"
			cabec1 := OemToAnsi(STR0012)+IIf(mv_par09 $ "Dd", STR0013 , STR0014 ) +STR0015			//"    OPERACAO      "###"   DOCUMENTO   "###"   SEQUENCIA   "###" |               E  N  T  R  A  D  A  S             |         CUSTO MEDIO   |                  S  A  I  D  A  S                |                   S   A   L   D   O              |CLI,FOR,"
			cabec2 := OemToAnsi(STR0016)															//"    DATA    TES C.F    NUMERO     |            QUANTIDADE             CUSTO TOTAL    |        DO MOVIMENTO   |            QUANTIDADE             CUSTO TOTAL    |            QUANTIDADE               VALOR TOTAL  |CC , PJ ou OP"
			
			//�������������������������������������������������������������������Ŀ
			//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
			//���������������������������������������������������������������������
			nTipo  := IIf(aReturn[4]==1,15,nTam)
			
			//������������������������������������������������������������Ŀ
			//� Adiciona a ordem escolhida ao titulo do relatorio          �
			//��������������������������������������������������������������
			If Type("NewHead")#"U"
				NewHead += STR0017+AllTrim(aOrd[aReturn[8]])+STR0018+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par10))))+")" + " - " + aFilsCalc[ nForFilial, 3 ]	//" (Por "###" ,em "
			Else
				Titulo  += STR0017+AllTrim(aOrd[aReturn[8]])+STR0018+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par10))))+")" + " - " + aFilsCalc[ nForFilial, 3 ]	//" (Por "###" ,em "
			EndIf
	
			dbSelectArea("SB2")
			dbSetOrder(1)
	
			#IFDEF TOP
				If !(TcSrvType()=="AS/400") .And. !("POSTGRES" $ TCGetDB())
			
					dbSelectArea("SD1")           // Itens de Entrada
					nTotRegs += LastRec()
				
					dbSelectArea("SD2")           // Itens de Saida
					nTotRegs += LastRec()
			
					dbSelectArea("SD3")           // movimentacoes internas (producao/requisicao/devolucao)
					nTotRegs += LastRec()
			
					dbSelectArea("SB2")			  // Saldos em estoque
					dbSetOrder(1)
					nTotRegs += LastRec()
	
					// **** ATENCAO - O ORDER BY UTILIZA AS POSICOES DO SELECT, SE ALGUM CAMPO
					// **** FOR INCLUIDO NA QUERY OU ALTERADO DE LUGAR DEVE SER REVISTA A SINTAXE
					// **** DO ORDER BY
					// Query do produto
					// 1 ARQ
					// 2 PRODUTO
					// 3 TIPO
					// 4 UM
					// 5 GRUPO
					// 6 DESC
					// 7 POSIPI
					// 8 SEQCALC
					// 9 DATA
					// 10 TES
					// 11 CF
					// 12 SEQUENCIA
					// 13 DOCUMENTO
					// 14 SERIE
					// 15 QUANTIDADE
					// 16 QUANT2UM
					// 17 ARMAZEM
					// 18 PROJETO
					// 19 OP
					// 20 CC
					// 21 FORNECEDOR
					// 22 LOJA
					// 23 PEDIDO
					// 24 TIPO NF
					// 25 CUSTO
					// 26 TRT 
					// 27 LOTE
					// 28 B1_CODITE  - GESTAO DE CONCESSION�RIAS
					// 29 RECNO
					// Query completa
				
					// **** ATENCAO - O ORDER BY UTILIZA AS POSICOES DO SELECT, SE ALGUM CAMPO
					// **** FOR INCLUIDO NA QUERY OU ALTERADO DE LUGAR DEVE SER REVISTA A SINTAXE
					// **** DO ORDER BY
	
					cQueryD1P:= ""
					cQuerySub:= "SELECT 1 "
	
					cQueryD1P+= "SELECT 'SD1' ARQ"		  		// 01
					cQueryD1P+= ", SB1.B1_COD PRODUTO"	  		// 02
					cQueryD1P+= ", SB1.B1_TIPO TIPO"	  		// 03
					cQueryD1P+= ", SB1.B1_UM"			  		// 04
					cQueryD1P+= ", SB1.B1_GRUPO"		  		// 05
					cQueryD1P+= ", SB1.B1_DESC"			   		// 06
					cQueryD1P+= ", SB1.B1_POSIPI"		   		// 07
					cQueryD1P+= ", D1_SEQCALC SEQCALC"	   		// 08
					cQueryD1P+= ", D1_DTDIGIT DATA"		   		// 09
					cQueryD1P+= ", D1_TES TES"			   		// 10
					cQueryD1P+= ", D1_CF CF"			   		// 11
					cQueryD1P+= ", D1_NUMSEQ SEQUENCIA"	  		// 12
					cQueryD1P+= ", D1_DOC DOCUMENTO"	  		// 13
					cQueryD1P+= ", D1_SERIE SERIE"		   		// 14
					cQueryD1P+= ", D1_QUANT QUANTIDADE"	   		// 15
					cQueryD1P+= ", D1_QTSEGUM QUANT2UM"	   		// 16
					cQueryD1P+= ", D1_LOCAL ARMAZEM"	   		// 17
					cQueryD1P+= ", '' PROJETO"			   		// 18
					cQueryD1P+= ", '' OP"				  		// 19
					cQueryD1P+= ", '' CC"				  		// 20
					cQueryD1P+= ", D1_FORNECE FORNECEDOR"  		// 21
					cQueryD1P+= ", D1_LOJA LOJA"		   		// 22
					cQueryD1P+= ", '' PEDIDO"			  		// 23
					cQueryD1P+= ", D1_TIPO TIPONF"		 		// 24
					If lCusRep .And. mv_par17 == 2
						cQueryD1P+= ", D1_CUSRP"		 		// 25
						// COLOCA A MOEDA DO CUSTO
						cQueryD1P += Str(mv_par10,1,0)	
						cQueryD1P += " CUSTO"			
					Else
						cQueryD1P+= ", D1_CUSTO"		  		// 25
						// COLOCA A MOEDA DO CUSTO
						If mv_par10 > 1
							cQueryD1P+= Str(mv_par10,1,0)
						EndIf
						cQueryD1P += " CUSTO"			
					EndIf	
					cQueryD1P += ", '' TRT"						// 26
					cQueryD1P += ", D1_LOTECTL LOTE"	 		// 27
					If lVEIC
						cQueryD1P+= ", SB1.B1_CODITE B1_CODITE"	// 28
					EndIf
					cQueryD1P += ", SD1.R_E_C_N_O_ NRECNO"		// 29
	
		   			cQueryD1 := " FROM " 	
	
					cQueryD1 += RetSqlName("SB1") + " SB1"
					cQueryD1 += ", " + RetSqlName("SD1") + " SD1"
					cQueryD1 += ", " + RetSqlName("SF4") + " SF4"
	
		   			cQueryD1 += " WHERE"
	
					cQueryD1 += " SB1.B1_COD = D1_COD"
					If lCusEmp
						If !Empty(xFilial("SD1")) .And. !Empty(xFilial("SF4"))
							cQueryD1 += " AND F4_FILIAL = D1_FILIAL "
						EndIf	
					Else
						cQueryD1 += " AND D1_FILIAL = '" + xFilial("SD1") + "'"
						cQueryD1 += " AND F4_FILIAL = '" + xFilial("SF4") + "'"
					EndIf	
					cQueryD1 += " AND SD1.D1_TES = F4_CODIGO"
					cQueryD1 += " AND F4_ESTOQUE = 'S'"
					cQueryD1 += " AND D1_DTDIGIT >= '" + DTOS(mv_par05) + "'"
					cQueryD1 += " AND D1_DTDIGIT <= '" + DTOS(mv_par06) + "'"
					cQueryD1 += " AND D1_ORIGLAN <> 'LF'"
					If !(lCusFil .Or. lCusEmp)
						cQueryD1 += " AND D1_LOCAL = '" + mv_par08 + "'"
					EndIf
					//����������������������������������������������������������������������Ŀ
					//� Nao imprimir o produto MANUTENCAO (MV_PRDMNT) qdo integrado com MNT. �
					//������������������������������������������������������������������������
					If MTR900IsMNT() 
						If FindFunction("NGProdMNT")
							aProdsMNT := aClone(NGProdMNT())
							For nX := 1 To Len(aProdsMNT)
								cQueryD1 += " AND SB1.B1_COD <> '" + aProdsMNT[nX] + "'"
							Next nX
						Else
							cQueryD1 += " AND SB1.B1_COD <> '" + cProdMNT + "'"
							cQueryD1 += " AND SB1.B1_COD <> '" + cProdTER + "'"
						EndIf
					EndIf	
					cQueryD1 += " AND SD1.D_E_L_E_T_<>'*'"
					cQueryD1 += " AND SF4.D_E_L_E_T_<>'*'"
			
					cQueryD2P := " SELECT 'SD2'"	  			// 01
					cQueryD2P += ", SB1.B1_COD"		  			// 02
					cQueryD2P += ", SB1.B1_TIPO"	  			// 03
					cQueryD2P += ", SB1.B1_UM"		 			// 04
					cQueryD2P += ", SB1.B1_GRUPO"	 			// 05
					cQueryD2P += ", SB1.B1_DESC"	 			// 06
					cQueryD2P += ", SB1.B1_POSIPI"	 			// 07
					cQueryD2P += ", D2_SEQCALC"		 			// 08
					cQueryD2P += ", D2_EMISSAO"		 			// 09
					cQueryD2P += ", D2_TES"		  				// 10
					cQueryD2P += ", D2_CF"		   				// 11
					cQueryD2P += ", D2_NUMSEQ"	  				// 12
					cQueryD2P += ", D2_DOC"			 			// 13
					cQueryD2P += ", D2_SERIE"		 			// 14
					cQueryD2P += ", D2_QUANT"		 			// 15
					cQueryD2P += ", D2_QTSEGUM"					// 16
					cQueryD2P += ", D2_LOCAL"	   				// 17
					cQueryD2P += ", ''"			   				// 18
					cQueryD2P += ", ''"			  				// 19
					cQueryD2P += ", ''"			   				// 20
					cQueryD2P += ", D2_CLIENTE"	   				// 21
					cQueryD2P += ", D2_LOJA"	   				// 22
					cQueryD2P += ", D2_PEDIDO"					// 23
					cQueryD2P += ", D2_TIPO"		  			// 24
					If lCusRep .And. mv_par17 == 2
						cQueryD2P+= ", D2_CUSRP"	   			// 25
						// COLOCA A MOEDA DO CUSTO
						cQueryD2P += Str(mv_par10,1,0)
					Else
						cQueryD2P += ", D2_CUSTO"				// 25
						// COLOCA A MOEDA DO CUSTO
						cQueryD2P += Str(mv_par10,1,0)
					EndIf	
					cQueryD2P += ", ''"							// 26
					cQueryD2P += ", D2_LOTECTL"					// 27
					
					If lVEIC
						cQueryD2P += ", SB1.B1_CODITE"			// 28
					EndIf
					cQueryD2P += ", SD2.R_E_C_N_O_ SD2RECNO"	// 29
			
					cQueryD2 := " FROM "
			
					cQueryD2 += RetSqlName("SB1") + " SB1"
					cQueryD2 += ", " + RetSqlName("SD2") + " SD2"
					cQueryD2 += ", " + RetSqlName("SF4") + " SF4"
			
					cQueryD2 += " WHERE"
			
					cQueryD2 += " SB1.B1_COD = D2_COD"
					If lCusEmp
						If !Empty(xFilial("SD2")) .And. !Empty(xFilial("SF4"))
							cQueryD2 += " AND F4_FILIAL = D2_FILIAL "
						EndIf	
					Else
						cQueryD2 += " AND D2_FILIAL = '" + xFilial("SD2") + "'"
						cQueryD2 += " AND F4_FILIAL = '" + xFilial("SF4") + "'"
					EndIf	
					cQueryD2 += " AND SD2.D2_TES = F4_CODIGO"
					cQueryD2 += " AND F4_ESTOQUE = 'S'"
					cQueryD2 += " AND D2_EMISSAO >= '" + DTOS(mv_par05) + "'"
					cQueryD2 += " AND D2_EMISSAO <= '" + DTOS(mv_par06) + "'"
					cQueryD2 += " AND D2_ORIGLAN <> 'LF'"
					If !(lCusFil .Or. lCusEmp)
						cQueryD2 += " AND D2_LOCAL = '" + mv_par08 + "'"
					EndIf
					//����������������������������������������������������������������������Ŀ
					//� Nao imprimir o produto MANUTENCAO (MV_PRDMNT) qdo integrado com MNT. �
					//������������������������������������������������������������������������
					If MTR900IsMNT() 
						If FindFunction("NGProdMNT")
							aProdsMNT := aClone(NGProdMNT())
							For nX := 1 To Len(aProdsMNT)
								cQueryD2 += " AND SB1.B1_COD <> '" + aProdsMNT[nX] + "'"
							Next nX
						Else
							cQueryD2 += " AND SB1.B1_COD <> '" + cProdMNT + "'"
							cQueryD2 += " AND SB1.B1_COD <> '" + cProdTER + "'"
						EndIf
					EndIf	
					cQueryD2 += " AND SD2.D_E_L_E_T_<>'*'"
					cQueryD2 += " AND SF4.D_E_L_E_T_<>'*'"
			
					cQueryD3P := " SELECT 'SD3'"   				// 01
					cQueryD3P += ", SB1.B1_COD"	   				// 02
					cQueryD3P += ", SB1.B1_TIPO"   				// 03
					cQueryD3P += ", SB1.B1_UM"					// 04
					cQueryD3P += ", SB1.B1_GRUPO"  				// 05
					cQueryD3P += ", SB1.B1_DESC"   				// 06
					cQueryD3P += ", SB1.B1_POSIPI" 				// 07
					cQueryD3P += ", D3_SEQCALC"	   				// 08
					cQueryD3P += ", D3_EMISSAO"	   				// 09
					cQueryD3P += ", D3_TM"		   				// 10
					cQueryD3P += ", D3_CF"						// 11
					cQueryD3P += ", D3_NUMSEQ"	   				// 12
					cQueryD3P += ", D3_DOC"						// 13
					cQueryD3P += ", ''"			   				// 14
					cQueryD3P += ", D3_QUANT"	   				// 15
					cQueryD3P += ", D3_QTSEGUM"					// 16
					cQueryD3P += ", D3_LOCAL"	  				// 17
					cQueryD3P += ", D3_PROJPMS"	  				// 18
					cQueryD3P += ", D3_OP"		  				// 19
					cQueryD3P += ", D3_CC"		  				// 20
					cQueryD3P += ", ''"			 				// 21
					cQueryD3P += ", ''"							// 22
					cQueryD3P += ", ''"			  				// 23
					cQueryD3P += ", ''"			  				// 24
					If lCusRep .And. mv_par17 == 2
						cQueryD3P+= ", D3_CUSRP"  				// 25
						// COLOCA A MOEDA DO CUSTO
						cQueryD3P += Str(mv_par10,1,0)
					Else
						cQueryD3P += ", D3_CUSTO"  				// 25
						// COLOCA A MOEDA DO CUSTO
						cQueryD3P += Str(mv_par10,1,0)
					EndIF	
					cQueryD3P += ", D3_TRT"		  				// 26
					cQueryD3P += ", D3_LOTECTL"	   				// 27
			
					If lVEIC
						cQueryD3P += ", SB1.B1_CODITE"			// 28
					EndIf
					cQueryD3P += ", SD3.R_E_C_N_O_ SD3RECNO"	// 29
			
					cQueryD3 := " FROM "
			
					cQueryD3 += RetSqlName("SB1") + " SB1"
					cQueryD3 += ", " + RetSqlName("SD3") + " SD3"
			
					cQueryD3 += " WHERE"
			
					cQueryD3 += " SB1.B1_COD = D3_COD"
					If !lCusEmp
						cQueryD3 += " AND D3_FILIAL = '"	+ xFilial("SD3") + "'"
					EndIf	
					cQueryD3 += " AND D3_EMISSAO >= '"	+ DTOS(mv_par05) + "'"
					cQueryD3 += " AND D3_EMISSAO <= '"	+ DTOS(mv_par06) + "'"
					If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
						cQueryD3 += " AND D3_ESTORNO <> 'S'"
					EndIf
					If SuperGetMV('MV_D3SERVI', .F., 'N') == 'N' .And. IntDL()
						cQueryD3 += " AND ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500')  "
						cQueryD3 += " OR  (D3_SERVIC <> '   ' AND D3_TM > '500' AND D3_LOCAL ='"+SuperGetMV('MV_CQ', .F., '98')+"') )"
					EndIf		
					If !(lCusFil .Or. lCusEmp) .And. !lLocProc
						cQueryD3 += " AND D3_LOCAL = '" + mv_par08 + "'"
					EndIf
					//����������������������������������������������������������������������Ŀ
					//� N�o imprimir o produto MANUTENCAO (MV_PRDMNT) qdo integrado com MNT. �
					//������������������������������������������������������������������������
					If MTR900IsMNT() 
						If FindFunction("NGProdMNT")
							aProdsMNT := aClone(NGProdMNT())
							For nX := 1 To Len(aProdsMNT)
								cQueryD3 += " AND SB1.B1_COD <> '" + aProdsMNT[nX] + "'"
							Next nX
						Else
							cQueryD3 += " AND SB1.B1_COD <> '" + cProdMNT + "'"
							cQueryD3 += " AND SB1.B1_COD <> '" + cProdTER + "'"
						EndIf
					EndIf	
					cQueryD3 += " AND SD3.D_E_L_E_T_<>'*'"
	
					cQuery := cQueryD1P + cQueryD1 + cQueryB1A + cQueryB1C
					cQuery += " UNION "
					cQuery += cQueryD2P + cQueryD2 + cQueryB1A + cQueryB1C
					cQuery += " UNION "
					cQuery += cQueryD3P + cQueryD3 + cQueryB1A + cQueryB1C
			
					//��������������������������������������������������������Ŀ
					//� So inclui as condicoes a seguir qdo lista produtos sem �
					//� movimento                                              �
					//����������������������������������������������������������
					If mv_par07 == 1
			
					   cQuery2:= " AND NOT EXISTS " + "(" + cQuerySub + cQueryD1 + cQueryB1B + cQueryB1C + ")"
					   cQuery2+= " AND NOT EXISTS " + "(" + cQuerySub + cQueryD2 + cQueryB1B + cQueryB1C + ")"
					   cQuery2+= " AND NOT EXISTS " + "(" + cQuerySub + cQueryD3 + cQueryB1B + cQueryB1C + ")"
			
					   cQuery += " UNION"
			
					   cQuery += " SELECT 'SB1'"			// 01
					   cQuery += ", SB1EXS.B1_COD"	   		// 02
					   cQuery += ", SB1EXS.B1_TIPO"	   		// 03
					   cQuery += ", SB1EXS.B1_UM"	   		// 04
					   cQuery += ", SB1EXS.B1_GRUPO"   		// 05
					   cQuery += ", SB1EXS.B1_DESC"			// 06
					   cQuery += ", SB1EXS.B1_POSIPI"		// 07
					   cQuery += ", ''"						// 08
					   cQuery += ", ''"				   		// 09
					   cQuery += ", ''"				   		// 10
					   cQuery += ", ''"						// 11
					   cQuery += ", ''"						// 12
					   cQuery += ", ''"						// 13
					   cQuery += ", ''"						// 14
					   cQuery += ", 0"						// 15
					   cQuery += ", 0"						// 16
					   cQuery += ", ''"						// 17
					   cQuery += ", ''"				   		// 18
					   cQuery += ", ''"				   		// 19
					   cQuery += ", ''"				  		// 20
					   cQuery += ", ''"				  		// 21
					   cQuery += ", ''"				  		// 22
					   cQuery += ", ''"				  		// 23
					   cQuery += ", ''"				  		// 24
					   cQuery += ", 0"				   		// 25
					   cQuery += ", ''"				   		// 26
					   cQuery += ", ''"				   		// 27		   
						If lVEIC
							cQuery += ", SB1EXS.B1_CODITE"	// 28
						EndIf
					   cQuery += ", 0"				   		// 29		   
			
						cQuery += " FROM "
					   
						cQuery += RetSqlName("SB1") + " SB1EXS"
			
						cQuery += " WHERE "
			
						cQuery += cQueryB1D
						cQuery += cQuery2
					EndIf
	
					If ! lVEIC
						If aReturn[8]==1 //" Codigo Produto "###" Tipo do Produto"
							cQuery += " ORDER BY 2,"
						ElseIf aReturn[8] == 2
							cQUery += " ORDER BY 3,2,"
						EndIf
					Else
						If aReturn[8]==1 //" Codigo Produto "###" Tipo do Produto"
							// B1_CODITE, B1_COD, B1_GRUPO
							cQuery += " ORDER BY 28, 2, 5,"
						ElseIf aReturn[8] == 2
							// B1_TIPO, B1_CODITE, B1_COD, B1_GRUPO
							cQuery += " ORDER BY 3, 28, 2, 5,"
						EndIf
					EndIf
	
					If mv_par11 == 1
///						cQuery += "17,12"+IIf(lVEIC,',29',',28')
						cQuery += "12"+IIf(lVEIC,',29',',28')						
					Else
						If lCusFil .Or. lCusEmp
							cQuery+="8,12"+IIf(lVEIC,',29',',28')
						Else
//							cQuery+="17,8,12"+IIf(lVEIC,',29',',28') 
							cQuery += "8"+IIf(lVEIC,',29',',28')							
						EndIf
					EndIf
					cQuery:=ChangeQuery(cQuery)
					MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasTOP,.F.,.T.)},STR0019)
					SetRegua(nTotRegs)
					dbSelectArea(cAliasTop)	
					dbgotop()
					While !(cAliasTop)->(Eof())
						If lEnd
							@PROW()+1,001 PSay STR0020		//"CANCELADO PELO OPERADOR"
							Exit
						EndIf

						IncRegua()
			
						//������������������������������������������������������������������������Ŀ
						//� Filtra Registros de Acordo com a Pasta  Filtro da Janela de Impressao  �
						//��������������������������������������������������������������������������
						If !Empty(aReturn[7])
							dbSelectArea("SB1")
							dbSetOrder(1)
							If dbSeek(xFilial("SB1") + (cAliasTop)->PRODUTO)
								If !&(aReturn[7])
									dbSelectArea(cAliasTop)
									dbSkip()
									Loop
								EndIf
							Else
								dbSelectArea(cAliasTop)
								dbSkip()
								Loop
							EndIf
							dbSelectArea(cAliasTop)
						EndIf
	
						//��������������������������������������������������Ŀ
						//� Se nao encontrar no arquivo de saldos nao lista  �
						//����������������������������������������������������
						If !lCusEmp
							dbSelectArea("SB2")
							If !dbSeek( xFilial("SB2") + (cAliasTop)->PRODUTO + If( lCusFil .Or. lCusEmp, "", mv_par08 ) )
								dbSelectArea(cAliasTop)
								dbSkip()
								Loop
							EndIf
						EndIf
									
						dbSelectArea(cAliasTop)
						cProdAnt  := (cAliasTop)->PRODUTO
						cLocalAnt := alltrim(SB2->B2_LOCAL)
				
						nEntrada :=nSaida  :=0
						nCEntrada:=nCSaida :=0
						lFirst   :=.F.
	
						If li > 54
							cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
						EndIf
						MTR900CAB(@aSalAtu,Alias(),cPicB2Cust,nTam,.T.,cAliasTop)
	
						While !Eof() .And. (cAliasTop)->PRODUTO = cProdAnt .And. If(lCusFil .Or. lCusEmp .Or. lLocProc,.T.,IIf(alltrim((cAliasTop)->ARQ) <> 'SB1',alltrim((cAliasTop)->ARMAZEM)==cLocalAnt,.T.))
							IncProc()
							lContinua := .F.
							If Alltrim((cAliasTop)->ARQ) $ "SD1/SD2"
								lFirst:=.T.
								SF4->( dbSeek( xFilial("SF4") + (cAliasTop)->TES ) )
								//��������������������������������������������������������������Ŀ
								//� Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  �
								//����������������������������������������������������������������
								//��������������������������������������������������������������Ŀ
								//� Executa ponto de entrada para verificar se considera TES que �
								//� NAO ATUALIZA saldos em estoque.                              �
								//����������������������������������������������������������������
								If lIxbConTes .And. SF4->F4_ESTOQUE != "S"
									lTesNEst := ExecBlock("MTAAVLTES",.F.,.F.)
									lTesNEst := If(ValType(lTesNEst) # "L",.F.,lTesNEst)
								EndIf
								If SF4->F4_ESTOQUE != "S" .And. !lTesNEst
									dbSkip()
									Loop
								EndIf
							ElseIf Alltrim((cAliasTop)->ARQ) == "SD3"
								lFirst:=.T.
								//����������������������������������������������������������������Ŀ
								//� Quando movimento ref apropr. indireta, so considera os         �
								//� movimentos com destino ao almoxarifado de apropriacao indireta.�
								//������������������������������������������������������������������
								lInverteMov:=.F.
								If alltrim((cAliasTop)->ARMAZEM) != cLocalAnt .Or. (lCusFil .Or. lCusEmp)
									If !(Substr((cAliasTop)->CF,3,1) == "3")
										If !(lCusFil .Or. lCusEmp)
											dbSkip()
											Loop
										EndIf
									ElseIf lPriApropri
										lInverteMov:=.T.
									EndIf
								EndIf
								//����������������������������������������������������������������Ŀ
								//� Caso seja uma transferencia de localizacao verifica se lista   �
								//� o movimento ou nao                                             �
								//������������������������������������������������������������������
								If mv_par13 == 2 .And. Substr((cAliasTop)->CF,3,1) == "4"
									cNumSeqTr := (cAliasTOP)->(PRODUTO+SEQUENCIA+ARMAZEM)
									aDadosTran:={(cAliasTOP)->TES,(cAliasTOP)->QUANTIDADE,(cAliasTOP)->CUSTO,(cAliasTOP)->QUANT2UM,(cAliasTOP)->TIPO,;
									             (cAliasTOP)->DATA,(cAliasTOP)->CF,(cAliasTOP)->SEQUENCIA,(cAliasTOP)->DOCUMENTO,(cAliasTOP)->PRODUTO,;
									             (cAliasTOP)->OP,(cAliasTOP)->PROJETO,(cAliasTOP)->CC,alltrim((cAliasTOP)->ARQ)}
									dbSkip()
									If (cAliasTOP)->(PRODUTO+SEQUENCIA+ARMAZEM) == cNumSeqTr
										dbSkip()
										Loop
									Else
										lContinua := .T.
										If !Localiza(aDadosTran[10]) //Verifica se Utiliza localizacao
											If li > 58
												If mv_par16 == 1
													cabec( titulo + " - " + aFilsCalc[ nForFilial, 3 ], cabec1, cabec2, wnrel, Tamanho, nTipo )
												Else
													cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
												EndIf
											EndIf
											If lFirst
												@Li ,000 PSay STOD(aDadosTran[6])
												@Li ,011 PSay aDadosTran[1]
												If ( cPaisLoc=="BRA" )
													If	lInverteMov
														@Li , 016 PSay Substr(aDadosTran[7],1,3)					
														@Li , 019 PSay "*"
													Else
														@Li , 016 PSay aDadosTran[7]
											   		EndIf
												EndIf
												@Li , 021 PSay PadR(IIf(mv_par09 $ "Ss",aDadosTran[8],aDadosTran[9]),12)+" |"
											EndIf
											If aDadosTran[1] <= "500"
												@Li ,045 PSay aDadosTran[2] Picture cPicD3Qt
												@Li ,062 PSay aDadosTran[3] Picture cPicD3Cust
												@Li ,083 PSay "|"
												@Li ,085 PSay aDadosTran[3] / aDadosTran[2] Picture cPicB2Cust
												@Li ,104 PSay "|"
												nEntrada   += aDadosTran[2]
												aSalAtu[1] += aDadosTran[2]
												nCEntrada  +=  aDadosTran[3]
												aSalAtu[mv_par10+1] += aDadosTran[3]
												aSalAtu[7] += aDadosTran[4]
											Else
												@Li ,083 PSay "|"
												@Li ,085 PSay aDadosTran[3] / aDadosTran[2] Picture cPicB2Cust
												@Li ,104 PSay "|"
												@Li ,114 PSay aDadosTran[2] Picture cPicD3Qt
												@Li ,132 PSay aDadosTran[3] Picture cPicD3Cust
												nSaida	   += aDadosTran[2]
												aSalAtu[1] -= aDadosTran[2]
												nCSaida	   += aDadosTran[3]
												aSalAtu[mv_par10+1] -= aDadosTran[3]
												aSalAtu[7] -= aDadosTran[4]
											EndIf
										Else
											lTransEnd := .F.
										EndIf
									EndIf
								EndIf
							EndIf
							If li > 58 .And. !lContinua
								If mv_par16 == 1
									cabec( titulo + " - " + aFilsCalc[ nForFilial, 3 ], cabec1, cabec2, wnrel, Tamanho, nTipo )
								Else
									cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
								EndIf
							EndIf
							If lFirst .And. !lContinua
								@Li ,000 PSay STOD(DATA)
								@Li ,011 PSay TES
								If ( cPaisLoc=="BRA" )
									If	lInverteMov
										@Li , 016 PSay Substr(CF,1,3)					
										@Li , 019 PSay "*"
									Else
										@Li , 016 PSay CF
									EndIf
								EndIf
								@Li , 021 PSay PadR(IIf(mv_par09 $ "Ss",SEQUENCIA,DOCUMENTO),12)+" |"
							EndIf
							Do Case
								Case Alltrim((cAliasTop)->ARQ) == "SD1" .And. !lContinua
									lDev:=MTR900Dev("SD1",cAliasTop)
									If (cAliasTOP)->TES <= "500" .And. !lDev
										@Li ,045 PSay (cAliasTOP)->QUANTIDADE Picture cPicD1Qt
										@Li ,062 PSay (cAliasTOP)->CUSTO Picture cPicD1Cust
										@Li ,083 PSay "|"
										If (cAliasTOP)->TIPONF != "C"
											@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
										EndIf
										@Li ,104 PSay "|"
										nEntrada   += (cAliasTOP)->QUANTIDADE
										aSalAtu[1] += (cAliasTOP)->QUANTIDADE
										nCEntrada  += (cAliasTOP)->CUSTO
										aSalAtu[mv_par10+1] += (cAliasTOP)->CUSTO
										aSalAtu[7] += (cAliasTOP)->QUANT2UM
									Else
										@Li ,083 PSay "|"
										If (cAliasTOP)->TIPONF != "C"
											@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
										EndIf
										@Li ,104 PSay "|"
										If lDev
											@Li ,107 PSay Space((nTam-1)-Len(Alltrim(Transform((cAliasTOP)->QUANTIDADE,cPicD1Qt))))+"("+Alltrim(Transform((cAliasTOP)->QUANTIDADE,cPicD1Qt))+")"
											cCusto:=Transform((cAliasTOP)->CUSTO,cPicD1Cust)
											@Li ,132 PSay Space((nTam-1)-Len(Alltrim(cCusto)))+"("+Alltrim(cCusto)+")"
											nSaida 	   -= (cAliasTOP)->QUANTIDADE
											aSalAtu[1] += (cAliasTOP)->QUANTIDADE
											nCSaida	   -=(cAliasTOP)->CUSTO
											aSalAtu[mv_par10+1] += (cAliasTOP)->CUSTO
											aSalAtu[7] += (cAliasTOP)->QUANT2UM
										Else
											@Li ,114 PSay (cAliasTOP)->QUANTIDADE Picture cPicD1Qt
											@Li ,132 PSay (cAliasTOP)->CUSTO Picture cPicD1Cust
											nSaida 	   += (cAliasTOP)->QUANTIDADE
											aSalAtu[1] -= (cAliasTOP)->QUANTIDADE
											nCSaida	   +=(cAliasTOP)->CUSTO
											aSalAtu[mv_par10+1] -= (cAliasTOP)->CUSTO
											aSalAtu[7] -= (cAliasTOP)->QUANT2UM
										EndIf
						   			EndIf
								Case Alltrim((cAliasTop)->ARQ) = "SD2" .And. !lContinua
									lDev:=MTR900Dev("SD2",cAliasTop)
									If (cAliasTOP)->TES <= "500" .Or. lDev
										If lDev
											@Li ,038 PSay Space((nTam-1)-Len(Alltrim(Transform((cAliasTOP)->QUANTIDADE,cPicD2Qt))))+"("+Alltrim(Transform((cAliasTOP)->QUANTIDADE,cPicD2Qt))+")"
											cCusto:=Transform((cAliasTOP)->CUSTO,cPicD2Cust)
											@Li ,062 PSay Space((nTam-1)-Len(Alltrim(cCusto)))+"("+Alltrim(cCusto)+")"
											nEntrada   -= (cAliasTOP)->QUANTIDADE
											aSalAtu[1] -= (cAliasTOP)->QUANTIDADE
											nCEntrada  -= (cAliasTOP)->CUSTO
											aSalAtu[mv_par10+1] -= (cAliasTOP)->CUSTO
											aSalAtu[7] -= (cAliasTOP)->QUANT2UM
										Else
											@Li ,045 PSay (cAliasTOP)->QUANTIDADE Picture cPicD2Qt
											@Li ,062 PSay (cAliasTOP)->CUSTO Picture cPicD2Cust
											nEntrada   += (cAliasTOP)->QUANTIDADE
											aSalAtu[1] += (cAliasTOP)->QUANTIDADE
											nCEntrada  += (cAliasTOP)->CUSTO
											aSalAtu[mv_par10+1] += (cAliasTOP)->CUSTO
											aSalAtu[7] += (cAliasTOP)->QUANT2UM
										EndIf
										@Li ,083 PSay "|"
										If (cAliasTOP)->TIPONF != "C"
											@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
										EndIf
										@Li ,104 PSay "|"
									Else
										@Li ,083 PSay "|"
										If (cAliasTOP)->TIPONF != "C"
											@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
										EndIf
										@Li ,104 PSay "|"
										@Li ,114 PSay (cAliasTOP)->QUANTIDADE Picture cPicD2Qt
										@Li ,132 PSay (cAliasTOP)->CUSTO Picture cPicD2Cust
										nSaida     += (cAliasTOP)->QUANTIDADE
										aSalAtu[1] -= (cAliasTOP)->QUANTIDADE
										nCSaida    +=  (cAliasTOP)->CUSTO
										aSalAtu[mv_par10+1] -= (cAliasTOP)->CUSTO
										aSalAtu[7] -= (cAliasTOP)->QUANT2UM
									EndIf
								Case Alltrim((cAliasTop)->ARQ) == "SD3" .And. !lContinua
									If	lInverteMov
										If (cAliasTOP)->TES > "500"
											@Li ,045 PSay (cAliasTOP)->QUANTIDADE Picture cPicD3Qt
											@Li ,062 PSay (cAliasTOP)->CUSTO Picture cPicD3Cust
											@Li ,083 PSay "|"
											@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
											@Li ,104 PSay "|"
											nEntrada   += (cAliasTOP)->QUANTIDADE
											aSalAtu[1] += (cAliasTOP)->QUANTIDADE
											nCEntrada  +=  (cAliasTOP)->CUSTO
											aSalAtu[mv_par10+1] += (cAliasTOP)->CUSTO
											aSalAtu[7] += (cAliasTOP)->QUANT2UM
										Else	
											@Li ,083 PSay "|"
											@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
											@Li ,104 PSay "|"
											@Li ,114 PSay (cAliasTOP)->QUANTIDADE Picture cPicD3Qt
											@Li ,132 PSay (cAliasTOP)->CUSTO Picture cPicD3Cust
											nSaida     += (cAliasTOP)->QUANTIDADE
											aSalAtu[1] -= (cAliasTOP)->QUANTIDADE
											nCSaida    += (cAliasTOP)->CUSTO
											aSalAtu[mv_par10+1] -= (cAliasTOP)->CUSTO
											aSalAtu[7] -= (cAliasTOP)->QUANT2UM
										EndIf
										If lCusFil .Or. lCusEmp
											lPriApropri:=.F.
										EndIf
									Else
										If (cAliasTOP)->TES <= "500"
											@Li ,045 PSay (cAliasTOP)->QUANTIDADE Picture cPicD3Qt
											@Li ,062 PSay (cAliasTOP)->CUSTO Picture cPicD3Cust
											@Li ,083 PSay "|"
											@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
											@Li ,104 PSay "|"
											nEntrada   += (cAliasTOP)->QUANTIDADE
											aSalAtu[1] += (cAliasTOP)->QUANTIDADE
											nCEntrada  +=  (cAliasTOP)->CUSTO
											aSalAtu[mv_par10+1] += (cAliasTOP)->CUSTO
											aSalAtu[7] += (cAliasTOP)->QUANT2UM
										Else
											@Li ,083 PSay "|"
											@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
											@Li ,104 PSay "|"
											@Li ,114 PSay (cAliasTOP)->QUANTIDADE Picture cPicD3Qt
											@Li ,132 PSay (cAliasTOP)->CUSTO Picture cPicD3Cust
											nSaida     += (cAliasTOP)->QUANTIDADE
											aSalAtu[1] -= (cAliasTOP)->QUANTIDADE
											nCSaida    += (cAliasTOP)->CUSTO
											aSalAtu[mv_par10+1] -= (cAliasTOP)->CUSTO
											aSalAtu[7] -= (cAliasTOP)->QUANT2UM
										EndIf
										If lCusFil .Or. lCusEmp
											lPriApropri:=.T.
										EndIf
									EndIf
							EndCase
							If lFirst .And. lTransEnd
								@ Li,153 PSay "|"
								@ Li,155 PSay aSalAtu[1] Picture cPicB2Qt
								@ Li,177 PSay aSalAtu[mv_par10+1] Picture cPicB2Cust
								@ Li,195 PSay "|"
							EndIf
							Do Case
								Case Alltrim((cAliasTop)->ARQ) == "SD3" .And. !lContinua .And. lTransEnd
									If Empty((cAliasTOP)->OP) .And. Empty((cAliasTOP)->PROJETO)
										@ LI,197 PSay 'CC'+(cAliasTOP)->CC
									ElseIf !Empty((cAliasTOP)->PROJETO)
										@ LI,197 PSay 'PJ'+(cAliasTOP)->PROJETO
									ElseIf !Empty((cAliasTOP)->OP)
										@ LI,207 PSay 'OP'+(cAliasTOP)->OP
									EndIf
								Case Alltrim((cAliasTop)->ARQ) == "SD1" .And. !lContinua .And. lTransEnd
									cTipoNf := 'F-'
									SD1->(dbGoTo((cAliasTop)->NRECNO))
									SD2->(dbSetOrder(3))
									If SD2->(dbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA))
										If !(SD2->D2_TIPO $ 'B|D')
											cTipoNf := 'C-'
										EndIf									
									EndIf
									@ LI,207 PSay cTipoNf+(cAliasTOP)->FORNECEDOR
								Case Alltrim((cAliasTop)->ARQ) == "SD2" .And. !lContinua .And. lTransEnd
									//����������������������������������������������������������������������Ŀ
									//�N - QNC: 002117                                                       �
									//�Corrigida a ultima coluna do relatorio onde apresentava nas notas     �
									//�de saida o n�mero do pedido de compra , ao inv�s de apresentar        �
									//�o codigo do cliente quando o D2_TIPO="N",                             �
									//�quando D2_TIPO="B" mostrar o codigo do fornecedor.                    �
									//������������������������������������������������������������������������
									If ((cAliasTop)->TIPONF) $ "B|D"
										@ LI,207 PSay 'F-'+(cAliasTop)->FORNECEDOR
									Else
										@ LI,207 PSay 'C-'+(cAliasTop)->FORNECEDOR
									EndIf
								Case lContinua .And. aDadosTran[14] == "SD3"  .And. lTransEnd
									If Empty(aDadosTran[11]) .And. Empty(aDadosTran[12])
										@ LI,197 PSay 'CC'+aDadosTran[13] 
									ElseIf !Empty(aDadosTran[12])
										@ LI,197 PSay 'PJ'+aDadosTran[12]
									ElseIf !Empty(aDadosTran[11])
										@ LI,207 PSay 'OP'+aDadosTran[11]
									EndIf
							EndCase
							If lTransEnd							
								Li++
							End If
							lTransEnd := .T.
							If !lInverteMov .Or. (lInverteMov .And. lPriApropri)
								If !lContinua //Acerto para utilizar o Array aDadosTranf[]
									dbSkip()
								EndIf
							EndIf
						EndDo
	
						If lFirst
							If li > 58
								cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
							Else	
								Li ++
							EndIf
							@ li,000 PSay STR0021	//"T O T A I S  :"
							@ Li,045 PSay nEntrada	Picture cPicD1Qt
							@ Li,062 PSay nCEntrada	Picture cPicD1Cust
							@ Li,114 PSay nSaida	Picture cPicD2Qt
							@ Li,132 PSay nCSaida	Picture cPicD2Cust
							@ Li,155 PSay aSalAtu[1] Picture cPicB2Qt
							@ Li,177 PSay aSalAtu[mv_par10+1] Picture cPicB2Cust
							Li++
							@ Li,135 PSay STR0022	//"QTD. NA SEGUNDA UM: "
							@ Li,155 PSay aSalAtu[7] Picture cPicB2Qt2
							Li++
							@Li ,   0 PSay __PrtThinLine()
						Else
							If !MTR900IsMNT()
								@Li ,  0 PSay STR0023	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
								Li++
								@Li ,  0 PSay __PrtThinLine()
							Else
								If FindFunction("NGProdMNT")
									aProdsMNT := aClone(NGProdMNT())
									If aScan(aProdsMNT, {|x| AllTrim(x) == AllTrim(SB1->B1_COD) }) == 0
										@Li ,  0 PSay STR0023	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
										Li++
										@Li ,  0 PSay __PrtThinLine()
									EndIf
								ElseIf SB1->B1_COD <> cProdMNT .And. SB1->B1_COD <> cProdTER
									@Li ,  0 PSay STR0023	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
									Li++
									@Li ,  0 PSay __PrtThinLine()
								EndIf
							EndIf	
						EndIf
						Li++
					EndDo
					dbSelectArea(cAliasTop)	
					dbCloseArea()
				Else
			#ENDIF
				dbSelectArea("SD1")
				If mv_par11 == 1
					dbSetOrder(5)
				Else
					If lCusFil .Or. lCusEmp
						cIndice:="D1_FILIAL+D1_COD+D1_SEQCALC+D1_NUMSEQ"
					Else
						cIndice:="D1_FILIAL+D1_COD+D1_LOCAL+D1_SEQCALC+D1_NUMSEQ"
					EndIf
					INDREGUA("SD1",cTrbSD1,cIndice,,DBFilter(),STR0019)	//"Selecionando Registros"
					nInd := RetIndex("SD1")
					#IFNDEF TOP
			  		   dbSetIndex(cTrbSD1+OrdBagExt())
					#ENDIF
					dbSetOrder(nInd+1)
				EndIf
		
				dbSelectArea("SD2")
				If mv_par11 == 1
					dbSetOrder(1)
				Else
					If lCusFil .Or. lCusEmp
						cIndice:="D2_FILIAL+D2_COD+D2_SEQCALC+D2_NUMSEQ"
					Else
						cIndice:="D2_FILIAL+D2_COD+D2_LOCAL+D2_SEQCALC+D2_NUMSEQ"
					EndIf
					INDREGUA("SD2",cTrbSD2,cIndice,,,STR0019)	//"Selecionando Registros"
					nInd := RetIndex("SD2")
					#IFNDEF TOP
					  dbSetIndex(cTrbSD2+OrdBagExt())
					#ENDIF
					dbSetOrder(nInd+1)
				EndIf
		
				dbSelectArea("SD3")
			
				If mv_par11 == 1
					dbSetOrder(3)
				Else
					If lCusFil .Or. lCusEmp
						cIndice:="D3_FILIAL+D3_COD+D3_SEQCALC+D3_NUMSEQ"
					Else
						cIndice:="D3_FILIAL+D3_COD+D3_LOCAL+D3_SEQCALC+D3_NUMSEQ"
					EndIf
			
					IndRegua("SD3",cTrbSD3,cIndice,,,STR0019)	//"Selecionando Registros"
			
					nInd := RetIndex("SD3")
					#IFNDEF TOP
			     	  dbSetIndex(cTrbSD3+OrdBagExt())
			 		#ENDIF
				    dbSetOrder(nInd+1)
				EndIf
				
				Set Softseek On
			
				dbSelectArea("SB1")
	
				If ! lVEIC
					If aReturn[8]==1
						dbSetOrder(1)
						dbseek(cFilial+mv_par01)
						cCond1:="B1_COD"
						cCond2:="mv_par02"
						nInd1	:= 0 
			
					ElseIf aReturn[8] == 2
						dbSetOrder(2)
						dbseek(cFilial+mv_par03)
						cCond1:="B1_TIPO"
						cCond2:="mv_par04"
						nInd1	:= 1
					EndIf  
				Else
					cArq1	:= CriaTrab( nil,.F. )
					If aReturn[8]==1
						IndRegua('SB1',cArq1,"B1_FILIAL+B1_CODITE")
						nInd1	:= RetIndex('SB1')
						#IFNDEF TOP
							dbSetIndex(cArq1 + OrdBagExt())
						#ENDIF
						dbSetOrder(nInd1 + 1)
						dbseek(cFilial+mv_par01)
						cCond1:="B1_CODITE"
						cCond2:="mv_par02"
					ElseIf aReturn[8] == 2
						IndRegua('SB1',cArq1,"B1_FILIAL+B1_TIPO+B1_CODITE")
						nInd1	:= RetIndex('SB1')
						#IFNDEF TOP
							dbSetIndex(cArq1 + OrdBagExt())
						#ENDIF
						dbSetOrder(nInd1 + 1)
						dbSeek(cFilial+mv_par03)
						cCond1:="B1_TIPO"
						cCond2:="mv_par04"
					EndIf  
				EndIf
				Set Softseek Off
			
				SetRegua(LastRec())
		
				While !Eof() .and. B1_FILIAL == cFilial .and. &cCond1 <= &cCond2
					
					If lEnd
						@PROW()+1,001 PSay STR0020		//"CANCELADO PELO OPERADOR"
						Exit
					EndIf
					
					IncRegua()
			
					dbSelectArea("SB1")
					//������������������������������������������������������������������������Ŀ
					//� Filtra Registros de Acordo com a Pasta  Filtro da Janela de Impressao  �
					//��������������������������������������������������������������������������
					If !Empty(aReturn[7])
						If !&(aReturn[7])
							dbSkip()
							Loop
						Endif   
					EndIf
			
					// Filtra por Tipo
					If B1_TIPO < mv_par03 .or. B1_TIPO > mv_par04
						dbSkip()
						Loop
					EndIf
					
					// Filtra por Produto
					If ! lVEIC
						If B1_COD < mv_par01 .or. B1_COD > mv_par02
							dbSkip()
							Loop
						EndIf
					Else
						If B1_CODITE < mv_par01 .or. B1_CODITE > mv_par02
							dbSkip()
							Loop
						EndIf
					EndIf		
	
					// Nao lista produto de importacao
					If B1_COD == Substr(cProdImp,1,Len(B1_COD))
						dbSkip()
						Loop
					EndIf
					
					// Filtra por Grupo
					If B1_GRUPO < mv_par14 .or. B1_GRUPO > mv_par15
						dbSkip()
						Loop
					EndIf
			
					//��������������������������������������������������Ŀ
					//� Se nao encontrar no arquivo de saldos nao lista  �
					//����������������������������������������������������
					dbSelectArea("SB2")
					If !dbSeek(cFilial+SB1->B1_COD+If(lCusFil .Or. lCusEmp,"",mv_par08))
						dbSelectArea("SB1")
						dbSkip()
						Loop
					EndIf
					
					cProdAnt  := SB1->B1_COD
					cLocalAnt := alltrim(B2_LOCAL)
					
					dbSelectArea("SD1")
					dbSeek(cFilial+SB1->B1_COD+If(lCusFil .Or. lCusEmp,"",SB2->B2_LOCAL))
					dbSelectArea("SD2")
					dbSeek(cFilial+SB1->B1_COD+If(lCusFil .Or. lCusEmp,"",SB2->B2_LOCAL))
					dbSelectArea("SD3")
					dbSeek(cFilial+SB1->B1_COD+If(lCusFil .Or. lCusEmp .Or.lLocProc,"",SB2->B2_LOCAL))
			
					While .T.
						
						dbSelectArea("SD1")
						If !Eof() .And. D1_FILIAL == xFilial("SD1") .And. D1_COD = cProdAnt .And. If(lCusFil .Or. lCusEmp,.T.,alltrim(D1_LOCAL) = cLocalAnt)
							
							dbSelectArea("SF4")
							dbSeek(cFilial+SD1->D1_TES)
							dbSelectArea("SD1")
							
							//��������������������������������������������������������������Ŀ
							//� Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  �
							//����������������������������������������������������������������
							//��������������������������������������������������������������Ŀ
							//� Executa ponto de entrada para verificar se considera TES que �
							//� NAO ATUALIZA saldos em estoque.                              �
							//����������������������������������������������������������������
							If lIxbConTes .And. SF4->F4_ESTOQUE != "S"
								lTesNEst := ExecBlock("MTAAVLTES",.F.,.F.)
								lTesNEst := If(ValType(lTesNEst) # "L",.F.,lTesNEst)
							EndIf
							
							If D1_ORIGLAN $ "LF" .Or. (SF4->F4_ESTOQUE != "S" .And. !lTesNEst)
								dbSkip()
								Loop
							Else
								If D1_DTDIGIT < mv_par05 .or. D1_DTDIGIT > mv_par06
									dbSkip()
									loop
								Else
									cSeqIni := IIf(mv_par11==1,D1_NUMSEQ,D1_SEQCALC+D1_NUMSEQ)
									cAlias := Alias()
								Endif
							EndIf
						EndIf
						
						dbSelectArea("SD2")
						If !Eof() .And. D2_FILIAL == xFilial("SD2") .And. D2_COD = cProdAnt .And. If(lCusFil .Or. lCusEmp,.T.,alltrim(D2_LOCAL) = cLocalAnt)
							
							dbSelectArea("SF4")
							dbSeek(cFilial+SD2->D2_TES)
							dbSelectArea("SD2")
							
							//��������������������������������������������������������������Ŀ
							//� Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  �
							//����������������������������������������������������������������
							//��������������������������������������������������������������Ŀ
							//� Executa ponto de entrada para verificar se considera TES que �
							//� NAO ATUALIZA saldos em estoque.                              �
							//����������������������������������������������������������������
							If lIxbConTes .And. SF4->F4_ESTOQUE != "S"
								lTesNEst := ExecBlock("MTAAVLTES",.F.,.F.)
								lTesNEst := If(ValType(lTesNEst) # "L",.F.,lTesNEst)
							EndIf
					
							If D2_ORIGLAN == "LF" .Or. (SF4->F4_ESTOQUE != "S" .And. !lTesNEst)
								dbSkip()
								Loop
							Else
								If D2_EMISSAO < mv_par05 .Or. D2_EMISSAO > mv_par06
									dbSkip()
									Loop
								Else
									If mv_par11 == 1
										If D2_NUMSEQ < cSeqIni
											cSeqIni := D2_NUMSEQ
											cAlias  := Alias()
										Endif
									Else
										If D2_SEQCALC+D2_NUMSEQ < cSeqIni
											cSeqIni := D2_SEQCALC+D2_NUMSEQ
											cAlias  := Alias()
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
				
						dbSelectArea("SD3")
						If !Eof() .And. D3_FILIAL == xFilial("SD3") .And. D3_COD = cProdAnt .And. If(lCusFil .Or. lCusEmp.Or.lLocProc,.T.,alltrim(D3_LOCAL) = cLocalAnt)
							//����������������������������������������������������������������Ŀ
							//� Quando movimento ref apropr. indireta, so considera os         �
							//� movimentos com destino ao almoxarifado de apropriacao indireta.�
							//������������������������������������������������������������������
							lInverteMov:=.F.
							If alltrim(D3_LOCAL) != cLocalAnt .Or. lCusFil .Or. lCusEmp
								If !(Substr(D3_CF,3,1) == "3")
									If !lCusFil .Or. lCusEmp
										dbSkip()
										Loop
									EndIf
								ElseIf lPriApropri
									lInverteMov:=.T.
								EndIf
							EndIf
			
							If D3_EMISSAO < mv_par05 .Or. D3_EMISSAO > mv_par06
								dbSkip()
								Loop
							EndIf
							 // Validacao tratamento se considera os estornos e se considera movimentos WMS
							If !D3Valido() 
								dbSkip()
								Loop
							EndIf
				 	
							//����������������������������������������������������������������Ŀ
							//� Caso seja uma transferencia de localizacao verifica se lista   �
							//� o movimento ou nao                                             �
							//������������������������������������������������������������������
							If mv_par13 == 2 .And. Substr(D3_CF,3,1) == "4"
								cNumSeqTr := SD3->D3_COD+SD3->D3_NUMSEQ+SD3->D3_LOCAL
								nRegTr    := Recno()
								dbSkip()
								If SD3->D3_COD+SD3->D3_NUMSEQ+SD3->D3_LOCAL == cNumSeqTr
									dbSkip()
									Loop
								Else
									dbGoto(nRegTr)
								EndIf
							EndIf
							If mv_par11 == 1
								If D3_NUMSEQ < cSeqIni
									cSeqIni := D3_NUMSEQ
									cAlias := Alias()
								EndIf
							Else
								If D3_SEQCALC+D3_NUMSEQ < cSeqIni
									cSeqIni := D3_SEQCALC+D3_NUMSEQ
									cAlias := Alias()
								EndIf
							EndIf
						EndIf
				
						If !Empty(cAlias)
							dbSelectArea(cAlias)
							cCampo1 := Subs(cAlias,2,2)+IIf(cAlias=="SD1","_DTDIGIT","_EMISSAO")
							cCampo2 := Subs(cAlias,2,2)+"_TES"
							cCampo3 := Subs(cAlias,2,2)+"_CF"
							cCampo4 := Subs(cAlias,2,2)+IIf(mv_par09 $ "Ss","_NUMSEQ","_DOC" )
							
							If li > 58
								cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
							EndIf
							
							If lFirst
								nEntrada :=nSaida :=0
								nCEntrada:=nCSaida:=0
								If li > 54
									cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
								EndIf
								MTR900CAB(@aSalAtu,cAlias,cPicB2Cust,nTam,.F.)
								lFirst  := .F.
								lFirst1 := .F.
							EndIf
			
							If li > 58
								cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
							EndIf
					
							@Li , 0 PSay &cCampo1
							If cAlias == "SD3"
								@Li ,011 PSay D3_TM
							Else
								@Li ,011 PSay &cCampo2
							EndIf
							If ( cPaisLoc=="BRA" )
								@Li , 016 PSay &cCampo3
								If	lInverteMov
									@Li , 019 PSay "*"
								EndIf
							EndIf
							@Li , 021 PSay PadR(&cCampo4,12)+" |"
							Do Case
							Case cAlias = "SD1"
								lDev:=MTR900Dev("SD1")
								If D1_TES <= "500" .And. !lDev
									@Li ,045 PSay D1_QUANT Picture cPicD1Qt
									@Li ,062 PSay &(Eval(bBloco,"D1_CUSTO",IIf(mv_par10==1," ",mv_par10))) Picture cPicD1Cust
									@Li ,083 PSay "|"
									If SF1->F1_TIPO != "C"
										@Li ,085 PSay (&(Eval(bBloco,"D1_CUSTO",IIf(mv_par10==1," ",mv_par10))) / D1_QUANT) Picture cPicB2Cust
									EndIf
									@Li ,104 PSay "|"
									nEntrada   += D1_QUANT
									aSalAtu[1] += D1_QUANT
									nCEntrada  += &(Eval(bBloco,"D1_CUSTO",IIf(mv_par10==1," ",mv_par10)))
									aSalAtu[mv_par10+1] += &(Eval(bBloco,"D1_CUSTO",IIf(mv_par10==1," ",mv_par10)))
									aSalAtu[7] += D1_QTSEGUM
								Else
									@Li ,083 PSay "|"
									If SF1->F1_TIPO != "C"
										@Li ,085 PSay (&(Eval(bBloco,"D1_CUSTO",IIf(mv_par10==1," ",mv_par10))) / D1_QUANT) Picture cPicB2Cust
									EndIf
									@Li ,104 PSay "|"
									If lDev
										@Li ,107 PSay Space((nTam-1)-Len(Alltrim(Transform(D1_QUANT,cPicD1Qt))))+"("+Alltrim(Transform(D1_QUANT,cPicD1Qt))+")"
										cCusto:=Transform(&(Eval(bBloco,"D1_CUSTO",IIf(mv_par10==1," ",mv_par10))),cPicD1Cust)
										@Li ,132 PSay Space((nTam-1)-Len(Alltrim(cCusto)))+"("+Alltrim(cCusto)+")"
										nSaida 	  -= D1_QUANT
										aSalAtu[1] += D1_QUANT
										nCSaida	  -=&(Eval(bBloco,"D1_CUSTO",IIf(mv_par10==1," ",mv_par10)))
										aSalAtu[mv_par10+1] += &(Eval(bBloco,"D1_CUSTO",IIf(mv_par10==1," ",mv_par10)))
										aSalAtu[7] += D1_QTSEGUM
									Else
										@Li ,114 PSay D1_QUANT Picture cPicD1Qt
										@Li ,132 PSay &(Eval(bBloco,"D1_CUSTO",IIf(mv_par10==1," ",mv_par10))) Picture cPicD1Cust
										nSaida 	  += D1_QUANT
										aSalAtu[1] -= D1_QUANT
										nCSaida	  +=&(Eval(bBloco,"D1_CUSTO",IIf(mv_par10==1," ",mv_par10)))
										aSalAtu[mv_par10+1] -= &(Eval(bBloco,"D1_CUSTO",IIf(mv_par10==1," ",mv_par10)))
										aSalAtu[7] -= D1_QTSEGUM
									EndIf
								EndIf
							Case cAlias = "SD2"
								lDev:=MTR900Dev("SD2")
								If D2_TES <= "500" .Or. lDev
									If lDev
										@Li ,038 PSay Space((nTam-1)-Len(Alltrim(Transform(D2_QUANT,cPicD2Qt))))+"("+Alltrim(Transform(D2_QUANT,cPicD2Qt))+")"
										cCusto:=Transform(&(Eval(bBloco,"D2_CUSTO",mv_par10)),cPicD2Cust)
										@Li ,062 PSay Space((nTam-1)-Len(Alltrim(cCusto)))+"("+Alltrim(cCusto)+")"
										nEntrada   -= D2_QUANT
										aSalAtu[1] -= D2_QUANT
										nCEntrada  -= &(Eval(bBloco,"D2_CUSTO",mv_par10))
										aSalAtu[mv_par10+1] -= &(Eval(bBloco,"D2_CUSTO",mv_par10))
										aSalAtu[7] -= D2_QTSEGUM
									Else
										@Li ,045 PSay D2_QUANT Picture cPicD2Qt
										@Li ,062 PSay &(Eval(bBloco,"D2_CUSTO",mv_par10)) Picture cPicD2Cust
										nEntrada   += D2_QUANT
										aSalAtu[1] += D2_QUANT
										nCEntrada  += &(Eval(bBloco,"D2_CUSTO",mv_par10))
										aSalAtu[mv_par10+1] += &(Eval(bBloco,"D2_CUSTO",mv_par10))
										aSalAtu[7] += D2_QTSEGUM
									EndIf
									@Li ,083 PSay "|"
									If SF2->F2_TIPO != "C"
										@Li ,085 PSay (&(Eval(bBloco,"D2_CUSTO",mv_par10)) / D2_QUANT) Picture cPicB2Cust
									EndIf
									@Li ,104 PSay "|"
								Else
									@Li ,083 PSay "|"
									If SF2->F2_TIPO != "C"
										@Li ,085 PSay (&(Eval(bBloco,"D2_CUSTO",mv_par10)) / D2_QUANT) Picture cPicB2Cust
									EndIf
									@Li ,104 PSay "|"
									@Li ,114 PSay D2_QUANT Picture cPicD2Qt
									@Li ,132 PSay &(Eval(bBloco,"D2_CUSTO",mv_par10)) Picture cPicD2Cust
									nSaida     += D2_QUANT
									aSalAtu[1] -= D2_QUANT
									nCSaida	  +=  &(Eval(bBloco,"D2_CUSTO",mv_par10))
									aSalAtu[mv_par10+1] -= &(Eval(bBloco,"D2_CUSTO",mv_par10))
									aSalAtu[7] -= D2_QTSEGUM
								EndIf
							Otherwise
								If	lInverteMov
									If D3_TM > "500"
										@Li ,045 PSay D3_QUANT Picture cPicD3Qt
										@Li ,062 PSay &(Eval(bBloco,"D3_CUSTO",mv_par10)) Picture cPicD3Cust
										@Li ,083 PSay "|"
										@Li ,085 PSay (&(Eval(bBloco,"D3_CUSTO",mv_par10)) / D3_QUANT) Picture cPicB2Cust
										@Li ,104 PSay "|"
										nEntrada	  += D3_QUANT
										aSalAtu[1] += D3_QUANT
										nCEntrada  +=  &(Eval(bBloco,"D3_CUSTO",mv_par10))
										aSalAtu[mv_par10+1] += &(Eval(bBloco,"D3_CUSTO",mv_par10))
										aSalAtu[7] += D3_QTSEGUM
									Else
										@Li ,083 PSay "|"
										@Li ,085 PSay (&(Eval(bBloco,"D3_CUSTO",mv_par10)) / D3_QUANT) Picture cPicB2Cust
										@Li ,104 PSay "|"
										@Li ,114 PSay D3_QUANT Picture cPicD3Qt
										@Li ,132 PSay &(Eval(bBloco,"D3_CUSTO",mv_par10)) Picture cPicD3Cust
										nSaida	  += D3_QUANT
										aSalAtu[1] -= D3_QUANT
										nCSaida	  += &(Eval(bBloco,"D3_CUSTO",mv_par10))
										aSalAtu[mv_par10+1] -= &(Eval(bBloco,"D3_CUSTO",mv_par10))
										aSalAtu[7] -= D3_QTSEGUM
									EndIf
									If lCusFil .Or. lCusEmp
										lPriApropri:=.F.
									EndIf
								Else
									If D3_TM <= "500"
										@Li ,045 PSay D3_QUANT Picture cPicD3Qt
										@Li ,062 PSay &(Eval(bBloco,"D3_CUSTO",mv_par10)) Picture cPicD3Cust
										@Li ,083 PSay "|"
										@Li ,085 PSay (&(Eval(bBloco,"D3_CUSTO",mv_par10)) / D3_QUANT) Picture cPicB2Cust
										@Li ,104 PSay "|"
										nEntrada	  += D3_QUANT
										aSalAtu[1] += D3_QUANT
										nCEntrada  +=  &(Eval(bBloco,"D3_CUSTO",mv_par10))
										aSalAtu[mv_par10+1] += &(Eval(bBloco,"D3_CUSTO",mv_par10))
										aSalAtu[7] += D3_QTSEGUM
									Else
										@Li ,083 PSay "|"
										@Li ,085 PSay (&(Eval(bBloco,"D3_CUSTO",mv_par10)) / D3_QUANT) Picture cPicB2Cust
										@Li ,104 PSay "|"
										@Li ,114 PSay D3_QUANT Picture cPicD3Qt
										@Li ,132 PSay &(Eval(bBloco,"D3_CUSTO",mv_par10)) Picture cPicD3Cust
										nSaida	  += D3_QUANT
										aSalAtu[1] -= D3_QUANT
										nCSaida	  += &(Eval(bBloco,"D3_CUSTO",mv_par10))
										aSalAtu[mv_par10+1] -= &(Eval(bBloco,"D3_CUSTO",mv_par10))
										aSalAtu[7] -= D3_QTSEGUM
									EndIf
									If lCusFil .Or. lCusEmp
										lPriApropri:=.T.
									EndIf
								EndIf
							EndCase
							@ Li,153 PSay "|"
							@ Li,155 PSay aSalAtu[1] Picture cPicB2Qt
							@ Li,177 PSay aSalAtu[mv_par10+1] Picture cPicB2Cust
							@ Li,195 PSay "|"
							Do Case
								Case cAlias = "SD3"  && movimentos (SD3)
									If Empty(D3_OP) .And. Empty(D3_PROJPMS)
										@ LI,197 PSay 'CC'+D3_CC
									ElseIf !Empty(D3_PROJPMS)
										@ LI,197 PSay 'PJ'+D3_PROJPMS
									ElseIf !Empty(D3_OP)
										@ LI,207 PSay 'OP'+D3_OP
									EndIf
								Case cAlias = "SD1"  && compras    (SD1)
									cTipoNf := 'F-'
									aAreaSD2:=SD2->(GetArea())
									SD2->(dbSetOrder(3))
									If SD2->(dbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA))
										If !(SD2->D2_TIPO $ 'B|D')
											cTipoNf := 'C-'
										EndIf									
									EndIf
									RestArea(aAreaSD2)
									dbSelectArea('SD1')
									@ LI,207 PSay cTipoNf+D1_FORNECE
								Case cAlias = "SD2"  && vendas     (SD2)
									If D2_TIPO $ "B|D"
			 							@ LI,207 PSay 'F-'+D2_CLIENTE
			 						Else
			 							@ LI,207 PSay 'C-'+D2_CLIENTE
				 					EndIf
							EndCase
							
							Li++
							cSeqIni := Replicate("z",6)
							cAlias := ""
							If !lInverteMov .Or. (lInverteMov .And. lPriApropri)
								dbSkip()
							EndIf
						Else
							If !lFirst
								If li > 58
									cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
								Else	
									Li ++
								EndIf
								@ li,000 PSay STR0021	//"T O T A I S  :"
								@ Li,045 PSay nEntrada	Picture cPicD1Qt
								@ Li,062 PSay nCEntrada	Picture cPicD1Cust
								@ Li,114 PSay nSaida	Picture cPicD2Qt
								@ Li,132 PSay nCSaida	Picture cPicD2Cust
								@ Li,155 PSay aSalAtu[1] Picture cPicB2Qt
								@ Li,177 PSay aSalAtu[mv_par10+1] Picture cPicB2Cust
								Li++
								@ Li,135 PSay STR0022	//"QTD. NA SEGUNDA UM: "
								@ Li,155 PSay aSalAtu[7] Picture cPicB2Qt2
								Li++
								@Li ,   0 PSay __PrtThinLine()
								Li++
								lFirst := .T.
							Else
								//��������������������������������������������������������Ŀ
								//� Verifica se deve ou nao listar os produtos s/movimento �
								//����������������������������������������������������������
								If mv_par07 == 1
									If li > 54
										cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
									EndIf
									MTR900CAB(@aSalAtu,Alias(),cPicB2Cust,nTam,.F.)

									If !MTR900IsMNT()
										@Li ,  0 PSay STR0023	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
										Li++
										@Li ,  0 PSay __PrtThinLine()
										Li++
									Else
										If FindFunction("NGProdMNT")
											aProdsMNT := aClone(NGProdMNT())
											If aScan(aProdsMNT, {|x| AllTrim(x) == AllTrim(SB1->B1_COD) }) == 0
												@Li ,  0 PSay STR0023	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
												Li++
												@Li ,  0 PSay __PrtThinLine()
												Li++
											EndIf
										ElseIf SB1->B1_COD <> cProdMNT .And. SB1->B1_COD <> cProdTER
											@Li ,  0 PSay STR0023	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
											Li++
											@Li ,  0 PSay __PrtThinLine()
											Li++
										EndIf
									EndIf
										
									lFirst  := .T.
									lFirst1 := .T.
								EndIf
							EndIf
							Exit
						EndIf
					EndDo
					lFirst  := .T.
					dbSelectArea("SB1")
					dbSkip()
				EndDo
			#IFDEF TOP
				EndIf
			#ENDIF
	
			If li != 80
				roda(cbcont,cbtxt,Tamanho)
			EndIf
	
			dbSelectArea("SB1")
			dbClearFilter()
			If !Empty(cArq1) .And. File(cArq1 + OrdBagExt())
				RetIndex('SB1')
				FERASE(cArq1 + OrdBagExt())
			EndIf
			dbSetOrder(1)
			dbSelectArea("SB2")
			dbSetOrder(1)
			dbSelectArea("SD1")
			If !Empty(cTrbSD1) .And. File(cTrbSD1 + OrdBagExt())
				RetIndex("SD1")
				Ferase(cTrbSD1+OrdBagExt())
			EndIf
			dbSetOrder(1)
			dbSelectArea("SD2")
			If !Empty(cTrbSD2) .And. File(cTrbSD2 + OrdBagExt())
				RetIndex("SD2")
				Ferase(cTrbSD2+OrdBagExt())
			EndIf
			dbSetOrder(1)
			dbSelectArea("SD3")
			If !Empty(cTrbSD3) .And. File(cTrbSD2 + OrdBagExt())
				RetIndex("SD3")
				Ferase(cTrbSD3+OrdBagExt())
			EndIf
			dbSetOrder(1)
	    	
			//���������������������������������������������������������������������Ŀ
			//� Caso utilize o relatorio por empresa executar somente uma unica vez |
			//�����������������������������������������������������������������������
	    	If lCusEmp
	    		Exit
	    	EndIf
		
		EndIf
	
	Next nForFilial

	If aReturn[5] = 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	EndIf

	MS_FLUSH()

EndIf

// Restaura Filial Corrente
cFilAnt := cFilBack

RETURN
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MTR900val� Autor � Paulo Boschetti       � Data � 22.12.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida parametro mv_par09 - (d)OCUMENTO/(s)EQUENCIA        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Mtr900val()
Local lRet := .T.

If mv_par09 $ "dsDS"
	lRet := .T.
Else
	lRet := .F.
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MTR900Cab� Autor � Marcos Bregantim      � Data � 28.07.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cabecalho com dados do produto                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MTR900Cab(ExpA1,ExpC1,ExpC2,ExpN1,ExpL1,ExpC3)             ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array saldo atual	 	                          ���
���          � ExpC1 = Alias 	                                          ���
���          � ExpC2 = Picture do custo medio                             ���
���          � ExpN1 = Tamanho do campo saldo  	                          ���
���          � ExpL1 = Se esta' utilizando query                          ���
���          � ExpC3 = Alias Top                                          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum			                                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Mtr900Cab(aSalAtu,cAlias,cPicB2Cust,nTam,lQuery,cAliasTop)
Local nCusMed 	:= 0
Local i         := 0
Local nIndice   := 0
Local aSalAlmox	:= {}
Local aArea     := {}
Local cSeek		:= ""
Local cFilBkp   := cFilAnt
Local cTrbSB2	:= CriaTrab(,.F.)
Local lVer116   := (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)  

Default lQuery 	  := .F.
Default cAliasTop :="SB1"

//������������������������������������������������Ŀ
//� Calcula o Saldo Inicial do Produto             �
//��������������������������������������������������
If lCusFil
	aArea:=GetArea()
	aSalAtu  := { 0,0,0,0,0,0,0 }
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(cSeek:=xFilial("SB2") + If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD))
	While !Eof() .And. B2_FILIAL+B2_COD == cSeek
		aSalAlmox := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),SB2->B2_LOCAL,mv_par05,,,( lCusRep .And. mv_par17==2 ) )
		For i:=1 to Len(aSalAtu)
			aSalAtu[i] += aSalAlmox[i]
		Next i
		dbSkip()
	End
	RestArea(aArea)
ElseIf lCusEmp
	aArea:=GetArea()
	aSalAtu  := { 0,0,0,0,0,0,0 }
	dbSelectArea("SB2")
	dbSetOrder(1)
	INDREGUA("SB2",cTrbSB2,"B2_COD+B2_LOCAL",,,STR0019)	//"Selecionando Registros"
	nIndice := RetIndex("SB2") 
	#IFNDEF TOP
	   dbSetIndex(cTrbSB2+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndice+1)
	dbSeek(cSeek:=If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD))
	While !Eof() .And. SB2->B2_COD == cSeek
		If !Empty(xFilial("SB2"))
			cFilAnt:=SB2->B2_FILIAL
		EndIf	
		aSalAlmox := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),SB2->B2_LOCAL,mv_par05,,,( lCusRep .And. mv_par17==2 ) )
		For i:=1 to Len(aSalAtu)
			aSalAtu[i] += aSalAlmox[i]
		Next i
		dbSkip()
	End
	dbSelectArea("SB2")
	If !Empty(cTrbSB2) .And. File(cTrbSB2 + OrdBagExt())
		RetIndex("SB2")
		Ferase(cTrbSB2+OrdBagExt())
	EndIf
	cFilAnt := cFilBkp
	RestArea(aArea)
Else
	aSalAtu := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),mv_par08,mv_par05,,, ( lCusRep .And. mv_par17==2 ) )
EndIf
//������������������������������������������������Ŀ
//� Calcula o Custo de Reposicao do Produto        �
//��������������������������������������������������
If lCusRep .And. mv_par17==2
	aSalAtu := {aSalAtu[1],aSalAtu[18],aSalAtu[19],aSalAtu[20],aSalAtu[21],aSalAtu[22],aSalAtu[07]}
EndIf
//������������������������������������������������Ŀ
//� Calcula o Custo Medio do Produto               �
//��������������������������������������������������
SB2->(dbSetOrder(1))
SB2->(dbSeek(xFilial("SB2") + If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD)))
If aSalAtu[1] > 0
	nCusmed := aSalAtu[mv_par10+1]/aSalAtu[1]
ElseIf aSalAtu[1] == 0 .and. aSalAtu[mv_par10+1] == 0
	nCusMed := 0
Else
	nCusmed := &(Eval(bBloco,"SB2->B2_CM",mv_par10))
EndIf
If ! lVEIC
	@ Li,000    	PSay If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD)
	@ Li,PCol()+1	PSay SubStr((cAliasTop)->B1_DESC,1,30)
	@ Li,pCol()+1 	PSay STR0024+(cAliasTop)->B1_UM									//"UM : "
	@ Li,pCol()+1	PSay STR0025+If(lQuery,(cAliasTop)->TIPO,SB1->B1_TIPO)			//"TIPO : "
	@ Li,083 		PSay STR0026+(cAliasTop)->B1_GRUPO								//"GRUPO : "
	If lCusRep .And. mv_par17==2
		@ Li,110 PSay STR0068													//Custo de Reposi��o : "
	Else
		@ Li,115 PSay STR0027													//"Custo Medio : "
	EndIf
	@ Li,132 PSay nCusMed	 	Picture cPicB2Cust
	@ Li,155 PSay aSalAtu[1]	Picture PesqPictQt("B2_QATU" ,nTam)
	@ Li,177 PSay aSalAtu[mv_par10+1] Picture cPicB2Cust
	Li++
	@ Li,000 PSay STR0028+SUBS((cAliasTop)->B1_POSIPI,1,4)+"."+SUBS((cAliasTop)->B1_POSIPI,5,4)+"."+SUBS((cAliasTop)->B1_POSIPI,9,2)		//"Posicao IPI : "
	If lVer116
		@ Li,035 PSay STR0029+ If(lCusFil .Or. lCusEmp , MV_PAR08 , Posicione("NNR",1,xFilial("NNR")+MV_PAR08,"NNR_DESCRI")) 			//"Localizacao : "	
	Else		
		@ Li,035 PSay STR0029+ If(lCusFil .Or. lCusEmp , MV_PAR08 , SB2->B2_LOCALIZ) 			//"Localizacao : "
	EndIf
Else
	@ Li,000 PSay If(lQuery,(cAliasTOP)->B1_CODITE, SB1->B1_CODITE)
	@ Li,PCOL() + 1 PSay If(lQuery, (cAliasTOP)->B1_DESC, SB1->B1_DESC)
	@ Li,115 PSay IIf(lCusRep .And. mv_par17==2,STR0068,STR0027)				//"Custo Medio : " ### "Custo Reposi��o : "
	@ Li,132 PSay nCusMed	 	Picture cPicB2Cust
	@ Li,155 PSay aSalAtu[1]	Picture PesqPictQt("B2_QATU" ,nTam)
	@ Li,177 PSay aSalAtu[mv_par10+1] Picture cPicB2Cust
	Li++
	@ Li,000 PSay If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD)
	@ Li,PCOL() + 2 PSay STR0024+(cAliasTop)->B1_UM 							//"UM : "
	@ Li,PCOL() + 2 PSay STR0025+If(lQuery,(cAliasTop)->TIPO,SB1->B1_TIPO)	//"TIPO : "
	@ Li,PCOL() + 2 PSay STR0026+(cAliasTop)->B1_GRUPO							//"GRUPO : "
	@ Li,PCOL() + 2 PSay STR0028+SUBS((cAliasTop)->B1_POSIPI,1,4)+"."+SUBS((cAliasTop)->B1_POSIPI,5,4)+"."+SUBS((cAliasTop)->B1_POSIPI,9,2)		//"Posicao IPI : "
	If lVer116
		@ Li,PCOL() + 2 PSay STR0029+ If(lCusFil .Or. lCusEmp , MV_PAR08 , Posicione("NNR",1,xFilial("NNR")+MV_PAR08,"NNR_DESCRI") ) 	//"Localizacao : "
	Else
		@ Li,PCOL() + 2 PSay STR0029+ If(lCusFil .Or. lCusEmp , MV_PAR08 , SB2->B2_LOCALIZ) 	//"Localizacao : "
	EndIf
EndIf
Li += 2
dbSelectArea(cAlias)
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MTR900Dev� Autor � Rodrigo de A. Sartorio� Data � 17/07/98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Avalia se item pertence a uma nota de devolu�ao             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MTR900Dev(ExpC1,ExpC2)				                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias                                              ���
���          � ExpC2 = Alias Top                                          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR900                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MTR900Dev(cAlias,cAliasTop)
Static lListaDev := NIL

Local lRet:=.F.
Local cSeek:= If(!Empty(cAliasTop),(cAliasTop)->DOCUMENTO+(cAliasTop)->SERIE+(cAliasTop)->FORNECEDOR+(cAliasTop)->LOJA,"")

// Identifica se lista dev. na mesma coluna
lListaDev := If(ValType(lListaDev)#"L",GetMV("MV_LISTDEV"),lListaDev)

If lListaDev .And. cAlias == "SD1"
	dbSelectArea("SF1")
	If Empty(cSeek)
		cSeek:=SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
	EndIf
	If dbSeek(xFilial("SF1") + cSeek) .And. SF1->F1_TIPO == "D"
		lRet:=.T.
	EndIf
ElseIf lListaDev .And. cAlias == "SD2"
	dbSelectArea("SF2")
	If Empty(cSeek)
		cSeek:=+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
	EndIf
	If dbSeek(xFilial("SF2") + cSeek) .And. SF2->F2_TIPO == "D"
		lRet:=.T.
	EndIf
EndIf
dbSelectArea(If(Empty(cAliasTop),cAlias,cAliasTop))
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTR900CUnf � Autor �Rodrigo de A. Sartorio � Data �26/06/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ajusta grupo de perguntas p/ Custo Unificado                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MTR900Cunf(ExpL1)					                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpL1 = Custo Unificado								 	  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR900                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MTR900CUnf(lCusFil,lCusEmp)
Local aSvAlias:=GetArea()
Local nTamSX1 :=Len(SX1->X1_GRUPO)

Default lCusFil := .F.
Default lCusEmp := .F.

dbSelectArea("SX1")
If dbSeek(PADR("MTR900",nTamSX1)+"08",.F.)
	If !("MTR900VAlm" $ X1_VALID)
		RecLock("SX1",.F.)
		If Empty(X1_VALID)
			Replace X1_VALID With "MTR900VAlm"
		Else
			Replace X1_VALID With X1_VALID+".And.MTR900VAlm"
		EndIf
		MsUnlock()
	EndIf
	If lCusFil .And. X1_CNT01 != Repl("*",TamSX3("B2_LOCAL")[1])
		RecLock("SX1",.F.)
		Replace X1_CNT01 With Repl("*",TamSX3("B2_LOCAL")[1])
		MsUnlock()
	EndIf
	If lCusEmp .And. X1_CNT01 != Repl("#",TamSX3("B2_LOCAL")[1])
		RecLock("SX1",.F.)
		Replace X1_CNT01 With Repl("#",TamSX3("B2_LOCAL")[1])
		MsUnlock()
	EndIf
EndIf
RestArea(aSvAlias)
Return(NIL)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTR900VAlm � Autor �Rodrigo de A. Sartorio � Data �26/06/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida Almoxarifado do KARDEX com relacao a custo unificado ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR900                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MTR900VAlm()
Local lRet:=.T.
Local cConteudo:=&(ReadVar())
Local nOpc:=2
//��������������������������������������������������������������Ŀ
//�MV_CUSFIL - Parametro utilizado para verificar se o sistema   |
//|utiliza custo unificado por:                                  |
//|      F = Custo Unificado por Filial                          |
//|      E = Custo Unificado por Empresa                         |
//|      A = Custo Unificado por Armazem                         | 
//����������������������������������������������������������������
Local lCusFil    := AllTrim(SuperGetMV('MV_CUSFIL' ,.F.,"A")) == "F"
Local lCusEmp    := AllTrim(SuperGetMv('MV_CUSFIL' ,.F.,"A")) == "E"

If lCusFil .And. cConteudo != Repl("*",TamSX3("B2_LOCAL")[1])
	nOpc := Aviso(STR0030,STR0031,{STR0032,STR0033})	//"Aten��o"###"Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."###"Confirma"###"Abandona"
	If nOpc == 2
		lRet:=.F.
	EndIf
EndIf
If lCusEmp .And. cConteudo != Repl("#",TamSX3("B2_LOCAL")[1])
	nOpc := Aviso(STR0030,STR0031,{STR0032,STR0033})	//"Aten��o"###"Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."###"Confirma"###"Abandona"
	If nOpc == 2
		lRet:=.F.
	EndIf
EndIf
Return lRet
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � AjustaSX1� Autor � Marcos V. Ferreira    � Data �04/11/2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Altera descricao da pergunta no SX1                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR900			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSX1()

Local aAreaAnt := GetArea()
Local aPerg    := {}
Local cPerg    := "MTR900"
Local aHelpPor := aHelpEng := aHelpSpa := {}
Local nTamSX1  := Len(SX1->X1_GRUPO)
Local aTamSX3  := TamSx3("B2_LOCAL")

Aadd(aPerg,{"Digitacao","Digitacion","Typing"})
Aadd(aPerg,{"Calculo","Calculo","Calculation"})

dbSelectArea("SX1")
dbSetOrder(1)

If dbSeek(PADR(cPerg,nTamSX1)+"07") .And. SX1->X1_TIPO == "C"
	RecLock("SX1",.F.)
	Replace X1_TIPO     with "N"
	Replace X1_PRESEL   with 1
	Replace X1_GSC   	with "C"
	Replace X1_DEF01    with "Sim"
	Replace X1_DEFSPA1  with "Si"
	Replace X1_DEFENG1  with "Yes"
	Replace X1_DEF02    with "Nao"
	Replace X1_DEFSPA2  with "No"
	Replace X1_DEFENG2  with "No"
	Replace X1_CNT01    with " "
	MsUnLock()
EndIf           

//����������������������������������������������������������������������Ŀ
//� Ajusta tamanho da get de pergunta do armazem se diferente de B2_LOCAL�
//������������������������������������������������������������������������
dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(PADR(cPerg,nTamSX1)+"08") .And. SX1->X1_TIPO == "C" .And. SX1->X1_TAMANHO != aTamSX3[1]
	RecLock("SX1",.F.)
	Replace X1_TAMANHO with aTamSX3[1]
	MsUnLock()
EndIf

If dbSeek(PADR(cPerg,nTamSX1)+"11") .And. !(AllTrim(X1_DEF01) == "Digitacao")
	RecLock("SX1",.F.)
	Replace X1_DEF01 	with aPerg[1][1]
	Replace X1_DEFSPA1	with aPerg[1][2]
	Replace X1_DEFENG1 	with aPerg[1][3]
	Replace X1_DEF02 	with aPerg[2][1]
	Replace X1_DEFSPA2	with aPerg[2][2]
	Replace X1_DEFENG2 	with aPerg[2][3]
	MsUnLock()
EndIf

//��������������������������������������������������������������Ŀ
//� Remove do grupo a pergunta 16 antiga                         �
//����������������������������������������������������������������
dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(PADR("MTR900",nTamSX1)+"16")
	If SX1->X1_PERGUNT <> 'Seleciona Filiais?'
		RecLock("SX1",.F.)
		dbDelete()
		MsUnlock()
	EndIf
EndIf

//��������������������������������������������������������������Ŀ
//� Adiciona o Help da nova pergunta 16                          �
//����������������������������������������������������������������
aHelpPor := { 'Seleciona as filiais desejadas. Se NAO',;
              'apenas a filial corrente sera afetada.',;
              '' }
aHelpSpa := { 'Selecciona las sucursales deseadas. Si',;
              'NO solamente la sucursal actual es',;
              'afectado.' }
aHelpEng := { 'Select desired branch offices. If NO',;
              'only current branch office will be',;
              'affected.' }

//��������������������������������������������������������������Ŀ
//� Adiciona no grupo a nova pergunta 16                         �
//����������������������������������������������������������������
PutSx1('MTR900',;                //-- 01 - X1_GRUPO
    '16',;                       //-- 02 - X1_ORDEM
    'Seleciona Filiais?',;       //-- 03 - X1_PERGUNT
    '�Selecciona Sucursales?',;  //-- 04 - X1_PERSPA
    'Select Branch Offices?',;   //-- 05 - X1_PERENG
    'mv_chg',;                   //-- 06 - X1_VARIAVL
    'N',;                        //-- 07 - X1_TIPO
    1,;                          //-- 08 - X1_TAMANHO
    0,;                          //-- 09 - X1_DECIMAL
    2,;                          //-- 10 - X1_PRESEL
    'C',;                        //-- 11 - X1_GSC
    '',;                         //-- 12 - X1_VALID
    '',;                         //-- 13 - X1_F3
    '',;                         //-- 14 - X1_GRPSXG
    '',;                         //-- 15 - X1_PYME
    'mv_par16',;                 //-- 16 - X1_VAR01
    'Sim',;                      //-- 17 - X1_DEF01
    'Si',;                       //-- 18 - X1_DEFSPA1
    'Yes',;                      //-- 19 - X1_DEFENG1
    '',;                         //-- 20 - X1_CNT01
    'Nao',;                      //-- 21 - X1_DEF02
    'No',;                       //-- 22 - X1_DEFSPA2
    'No',;                       //-- 23 - X1_DEFENG2
    '',;                         //-- 24 - X1_DEF03
    '',;                         //-- 25 - X1_DEFSPA3
    '',;                         //-- 26 - X1_DEFENG3
    '',;                         //-- 27 - X1_DEF04
    '',;                         //-- 28 - X1_DEFSPA4
    '',;                         //-- 29 - X1_DEFENG4
    '',;                         //-- 30 - X1_DEF05
    '',;                         //-- 31 - X1_DEFSPA5
    '',;                         //-- 32 - X1_DEFENG5
    ,;      		             //-- 33 - HelpPor
    ,;          		         //-- 34 - HelpSpa
    ,;           		        //-- 35 - HelpEng
    '')                          //-- 36 - X1_HELP 
    
    PutSX1Help("P.MTR90016.",aHelpPor,aHelpEng,aHelpSpa,.T.)

//��������������������������������������������������������������Ŀ
//� Adiciona o Help da nova pergunta 17                          �
//����������������������������������������������������������������
aHelpPor := {'Selecione o tipo de custo a ser',;
		     'impresso no relatorio.'			,;
		     '- Custo Medio' ,;
			 '- Custo de Reposi��o (Somente Argentina)'}
aHelpSpa := {'Seleccione el tipo de costo que',;
			 ' se imprimira en el informe (S�lo Argentina)',;
			 '- Costo Medio' ,'- Costo de Reposicion'}
aHelpEng := {'Select the type of expense that',;
	         ' will be printed in the report.'	,;
			 ' Average cost ',;
			 '- Replacement cost (Only Argentina)'}

//��������������������������������������������������������������Ŀ
//� Adiciona no grupo a nova pergunta 17                         �
//����������������������������������������������������������������
PutSx1('MTR900',;				//-- 01 - X1_GRUPO
    '17',;						//-- 02 - X1_ORDEM
    'Qual Custo Imprimir?',;	//-- 03 - X1_PERGUNT
    '�Qu� Costo imprimir?',;	//-- 04 - X1_PERSPA
    'What Cost Print?',;		//-- 05 - X1_PERENG
    'mv_chh',;					//-- 06 - X1_VARIAVL
    'N',;						//-- 07 - X1_TIPO
    1,;							//-- 08 - X1_TAMANHO
    0,;							//-- 09 - X1_DECIMAL
    1,;							//-- 10 - X1_PRESEL
    'C',;						//-- 11 - X1_GSC
    '',;						//-- 12 - X1_VALID
    '',;						//-- 13 - X1_F3
    '',;						//-- 14 - X1_GRPSXG
    '',;						//-- 15 - X1_PYME
    'mv_par17',;				//-- 16 - X1_VAR01
    'Medio',;					//-- 17 - X1_DEF01
    'Medio',;					//-- 18 - X1_DEFSPA1
    'Average',;					//-- 19 - X1_DEFENG1
    '',;						//-- 20 - X1_CNT01
    'Reposi��o',;				//-- 21 - X1_DEF02
    'Reposicion',;				//-- 22 - X1_DEFSPA2
    'Replacement',;				//-- 23 - X1_DEFENG2
    '',;						//-- 24 - X1_DEF03
    '',;						//-- 25 - X1_DEFSPA3
    '',;						//-- 26 - X1_DEFENG3
    '',;						//-- 27 - X1_DEF04
    '',;						//-- 28 - X1_DEFSPA4
    '',;						//-- 29 - X1_DEFENG4
    '',;						//-- 30 - X1_DEF05
    '',;						//-- 31 - X1_DEFSPA5
    '',;						//-- 32 - X1_DEFENG5
    ,;							//-- 33 - HelpPor
    ,;			   				//-- 35 - HelpEng
    ,;			   				//-- 34 - HelpSpa
    '')							//-- 36 - X1_HELP   
    
  PutSX1Help("P.MTR90017.",aHelpPor,aHelpEng,aHelpSpa,.T.)

//��������������������������������������������������������������Ŀ
//� Adiciona o Help A910CUSRP                                    �
//����������������������������������������������������������������
aHelpPor := {"ATEN��O (Somente Argentina)." ,;
 			 "O Custo de Reposi��o esta ",;
			 "desativado, o relatorio sera impresso",;
			 "pelo custo medio." }
aHelpSpa := {"Atenci�n(S�lo Argentina).",;
		     "El Costo de Reposicion esta ",;
			 "desactivado, el informe se",;
			 "imprimira por el costo promedio. "}
aHelpEng := {"Attention(Only Argentina).",;
		     "The replacement cost is off,",;
			 "the report will be printed by the",;
			 "average cost." }			 
PutSX1Help("P"+"A910CUSRP",aHelpPor,aHelpEng,aHelpSpa,.T.)

aHelpPor := { "Verifique a configura��o do"			,"parametro MV_CUSREP e se existe na "	,"base de dados todos os campos"	,"utilizados para o custo de reposi��o."}
aHelpSpa := { "Verifique la configuracion del"		,"parametro MV_CUSREP y si existen en"	,"la base de datos todos los campos","utilizados para el costo de reposicion."}
aHelpEng := { "Check the configuration parameter"	,"MV_CUSREP and is in the database"		,"all the fields used for the"		,"replacement cost."}
PutSX1Help("S"+"A910CUSRP",aHelpPor,aHelpEng,aHelpSpa,.T.)

aHelpPor := { "Considera  o  Armazem  para o c�lculo do"," saldo no cadastro de saldos (SB2)."	,"- Quando MV_CUSFIL=F (Filial) utiliza **"	,"- Quando MV_CUFIL=E (Empresa) utiliza ##"}
aHelpEng := { "Considera  o  Armazem  para o c�lculo do"," saldo no cadastro de saldos (SB2)."	,"- Quando MV_CUSFIL=F (Filial) utiliza **"	,"- Quando MV_CUFIL=E (Empresa) utiliza ##"}
aHelpSpa := { "Considera  o  Armazem  para o c�lculo do"," saldo no cadastro de saldos (SB2)."	,"- Quando MV_CUSFIL=F (Filial) utiliza **"	,"- Quando MV_CUFIL=E (Empresa) utiliza ##"}
PutSX1Help("P"+".MTR90008.",aHelpPor,aHelpEng,aHelpSpa,.T.)
RestArea(aAreaAnt)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MR900ImpS1� Autor � Nereu Humberto Junior � Data � 25/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime a secao 1 e 2 (Dados do produto)                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �MR900ImpS1(@ExpA1,ExpC1,ExpL1,ExpL2,ExpL3,ExpO1,ExpO2,ExpO3)���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array com informacoes do saldo inicial do item     ���
���          �   [1] = Saldo inicial em quantidade                        ���
���          �   [2] = Saldo inicial em valor                             ���
���          �   [3] = Saldo inicial na 2a unidade de medida              ���
���          � ExpC1 = Alias                                              ���
���          � ExpL1 = Top                                                ���
���          � ExpL2 = Veiculo                                            ���
���          � ExpL3 = Custo Unificado                                    ���
���          � ExpO1 = Secao 1                                            ���
���          � ExpO2 = Secao 2                                            ���
���          � ExpO3 = obj Report                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR900                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MR900ImpS1(aSalAtu,cAliasTop,lQuery,lVEIC,lCusFil,lCusEmp,oSection1,oSection2,oReport)

Local aArea     := GetArea()
Local nCusMed   := 0
Local i         := 0
Local nIndice   := 0
Local aSalAlmox := {}
Local cSeek     := ""
Local cFilBkp   := cFilAnt
Local cTrbSB2	:= CriaTrab(,.F.)

Default lQuery   := .F.
Default cAliasTop:="SB1"
Default lCusFil  := .F.
default lCusEmp  := .F.

//������������������������������������������������Ŀ
//� Calcula o Saldo Inicial do Produto             �
//��������������������������������������������������
If lCusFil
	aArea:=GetArea()
	aSalAtu  := { 0,0,0,0,0,0,0 }
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(cSeek:=xFilial("SB2") + If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD))
	While !Eof() .And. B2_FILIAL+B2_COD == cSeek
		aSalAlmox := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),SB2->B2_LOCAL,mv_par05,,, ( lCusRep .And. mv_par17==2 ) )
		For i:=1 to Len(aSalAtu)
			aSalAtu[i] += aSalAlmox[i]
		Next i
		dbSkip()
	End
	RestArea(aArea)
ElseIf lCusEmp
	aArea:=GetArea()
	aSalAtu  := { 0,0,0,0,0,0,0 }
	dbSelectArea("SB2")
	dbSetOrder(1)
	INDREGUA("SB2",cTrbSB2,"B2_COD+B2_LOCAL",,,STR0019)	//"Selecionando Registros"
	nIndice := RetIndex("SB2") 
	#IFNDEF TOP
	   dbSetIndex(cTrbSB2+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndice+1)
	dbSeek(cSeek:=If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD))
	While !Eof() .And. SB2->B2_COD == cSeek
		If !Empty(xFilial("SB2"))
			cFilAnt:=SB2->B2_FILIAL
		EndIf	
		aSalAlmox := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),SB2->B2_LOCAL,mv_par05,,,( lCusRep .And. mv_par17==2 ) )
		For i:=1 to Len(aSalAtu)
			aSalAtu[i] += aSalAlmox[i]
		Next i
		dbSkip()
	End
	dbSelectArea("SB2")
	If !Empty(cTrbSB2) .And. File(cTrbSB2 + OrdBagExt())
		RetIndex("SB2")
		Ferase(cTrbSB2+OrdBagExt())
	EndIf
	cFilAnt := cFilBkp
	RestArea(aArea)
Else
	aSalAtu := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),mv_par08,mv_par05,,, ( lCusRep .And. mv_par17==2 ) )
EndIf
//������������������������������������������������Ŀ
//� Calcula o Custo de Reposicao do Produto        �
//��������������������������������������������������
If lCusRep .And. mv_par17==2
	aSalAtu := {aSalAtu[1],aSalAtu[18],aSalAtu[19],aSalAtu[20],aSalAtu[21],aSalAtu[22],aSalAtu[07]}
EndIf
//������������������������������������������������Ŀ
//� Calcula o Custo Medio do Produto               �
//��������������������������������������������������
SB2->(dbSetOrder(1))
SB2->(dbSeek(xFilial("SB2") + If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD)))
If aSalAtu[1] > 0
	nCusmed := aSalAtu[mv_par10+1]/aSalAtu[1]
ElseIf aSalAtu[1] == 0 .and. aSalAtu[mv_par10+1] == 0
	nCusMed := 0
Else
	nCusmed := &(Eval(bBloco,"SB2->B2_CM",mv_par10))
EndIf

oSection1:Init()
oSection2:Init()

oSection1:Cell("nCusMed"):SetValue(nCusMed)
oSection1:Cell("nQtdSal"):SetValue(aSalAtu[1])
oSection1:Cell("nVlrSal"):SetValue(aSalAtu[mv_par10+1])			

#IFDEF TOP
	If !(TcSrvType()=="AS/400") .And. !("POSTGRES" $ TCGetDB())
		oSection1:Cell("cProduto"	):SetValue((cAliasTop)->PRODUTO)			
		oSection1:Cell("cTipo"		):SetValue((cAliasTop)->TIPO	)
		If lVEIC
			oSection2:Cell("cProduto"	):SetValue((cAliasTop)->PRODUTO)			
			oSection2:Cell("cTipo"		):SetValue((cAliasTop)->TIPO	)
		Endif
		
		dbSelectArea("SB2")
		dbSeek(xFilial("SB2")+(cAliasTop)->PRODUTO+If(lCusFil .Or. lCusEmp,"",mv_par08))
 	Else
#ENDIF
	oSection1:Cell("cProduto"	):SetValue(SB1->B1_COD)			
	oSection1:Cell("cTipo"		):SetValue(SB1->B1_TIPO)
	If lVEIC
		oSection2:Cell("cProduto"	):SetValue(SB1->B1_COD)			
		oSection2:Cell("cTipo"		):SetValue(SB1->B1_TIPO)
	EndIf
#IFDEF TOP
	EndIf
#ENDIF	
oSection1:PrintLine()
oSection2:PrintLine()

RestArea(aArea)

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTR900IsMNT� Autor � Lucas                � Data � 03.10.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se ha integra��o com o modulo SigaMNT/NG          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR900                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MTR900IsMNT()
Local aArea
Local aAreaSB1
Local aProdsMNT := {}
Local cProdMNT	 := ""
Local nX := 0
Local lIntegrMNT := .F.

//Esta funcao encontra-se no modulo Manutencao de Ativos (NGUTIL05.PRX), e retorna os produtos (pode ser MAIS de UM), dos parametros de
//Manutencao - "M" (MV_PRODMNT) / Terceiro - "T" (MV_PRODTER) / ou Ambos - "*" ou em branco
If FindFunction("NGProdMNT")
	aProdsMNT := aClone(NGProdMNT("M"))
	If Len(aProdsMNT) > 0
		aArea	 := GetArea()
		aAreaSB1 := SB1->(GetArea())
		
		SB1->(dbSelectArea( "SB1" ))
		SB1->(dbSetOrder(1))
		For nX := 1 To Len(aProdsMNT)
			If SB1->(dbSeek( xFilial("SB1") + aProdsMNT[nX] ))
				lIntegrMNT := .T.
				Exit
			EndIf 
		Next nX
		
		RestArea(aAreaSB1)
		RestArea(aArea)
	EndIf
Else //Se a funcao nao existir, processa com o parametro aceitando 1 (UM) Produto
	cProdMNT := GetMv("MV_PRODMNT")
	cProdMNT := cProdMNT + Space(15-Len(cProdMNT))
	If !Empty(cProdMNT)
		aArea	 := GetArea()
		aAreaSB1 := SB1->(GetArea())
		SB1->(dbSelectArea( "SB1" ))
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek( xFilial('SB1') + cProdMNT ))
			lIntegrMNT := .T.
		EndIf 
		RestArea(aAreaSB1)
		RestArea(aArea)
	EndIf
EndIf
Return( lIntegrMNT )