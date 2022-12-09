#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Gufic010()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,NREGISTRO,CSAVSCR")
SetPrvt("CTAMANHO,CPERG,ARETURN,NLASTKEY,CTITULO,LEND")
SetPrvt("LI,M_PAG,WNREL,CSITUACA,CSEEK,ADBSTRU")
SetPrvt("ATAMSX3,NTOTABAT,NSALPEDL,NSALPEDB,NQTDPED,NSALPED")
SetPrvt("CQUERY,NVALFAT,ATOTREC1,ATOTREC2,ATOTPED,ATOTFAT")
SetPrvt("ATOTCHQ,CDBMS,LGCONTIT,LGCONPED,LGCONFAT,CARQREC1")
SetPrvt("CARQREC2,CARQCHQ,NREGSE1,CARQPED,CNUMERO,DEMISSAO")
SetPrvt("CARQFAT,CDOC,CDUPLIC,NPEDIDOS,NNOTAS,NTOTAL")
SetPrvt("NTITULOS,NTOTNOTA,NTOTPGTO,NTITPAGOS,CBTXT,CBCONT")
SetPrvt("AMATRIZ,CPAISVER,CMOEDA,CCABEC1,CCABEC2,CNOMEPROG")
SetPrvt("_CTEXTO,NLACO,_ACAMPOS,_NI,_ASX3AREA,_CMACRO")
SetPrvt("_CDADOS,AAREA,NSALDO,NPAGO,NATRASO,AMOTBX")
SetPrvt("NPOS,CMOTBX,NRECNO,CALIAS,NJUROS,CSITUACION")
SetPrvt("CMOTBBX,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GUFIC010 � Autor � Cesar Monteiro        � Data � 31/05/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime a consulta de titulos                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Guaratingueta                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
cDesc1 := "Este programa ir� imprimir a Consulta de um Cliente,"
cDesc2 := "informando os dados acumulados do Cliente, os Pedidos"
cDesc3 := "em aberto, Titulos em Aberto e rela��o do Faturamento."
cString:= "SA1"
nRegistro:= SA1 -> (RecNo())
cSavScr  := ""
cTamanho := "G"

cPerg    := "FIC010"
aReturn  := { "Zebrado", 1, "Administracao", 1, 2, 1, "",1 }
nLastKey := 0
cTitulo  := "CONSULTA POSICAO ATUAL DE CLIENTES"
lEnd     := .F.

#IFNDEF WINDOWS
	cSavScr := 	SaveScreen(00,00,24,79)
#ENDIF

li 		 := 80
m_pag 	 := 1

//�����������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                        �
//�������������������������������������������������������������
//�����������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                      �
//� MV_PAR01          // Emissao De                           �
//� MV_PAR02          // Emissao Ate                          �
//� MV_PAR03          // Vencimento De                        �
//� MV_PAR04          // Vencimento Ate                       �
//� MV_PAR05          // Considera Provisorios                �
//� MV_PAR06          // Do Prefixo                           �
//� MV_PAR07          // At� Prefixo                          �
//�������������������������������������������������������������

pergunte("FIC010",.T.)

wnrel :="GUFIC010"
wnrel := SetPrint(cString,wnrel,,cTitulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,cTamanho,"",.F.)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

DbSelectArea("SA1")
DbGoTo(nRegistro)

Set Device To Screen
#IFDEF WINDOWS
       Processa({|| Fc010Gera()},"Criando Arquivo de Trabalho")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>        Processa({|| Execute(Fc010Gera)},"Criando Arquivo de Trabalho")
#ELSE
       Fc010Gera()
#ENDIF
Set Device to Printer

#IFDEF WINDOWS
    RptStatus({|lEnd| FC010REL()},cTitulo)// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>     RptStatus({|lEnd| Execute(FC010REL)},cTitulo)
    Return
#ELSE
    Fc010Rel()
#ENDIF	

dbSelectArea("SA1")

#IFNDEF WINDOWS
	RestScreen(00,00,24,79,cSavScr)
#ENDIF
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fC010Gera � Autor � Eduardo Riera         � Data � 12/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Gera arquivo de trabalho para a Consulta de Clientes        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �fC010Gera()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GUFIC010 - Especifico Guaratingueta                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function fC010Gera
Static Function fC010Gera()

cSituaca := ""
cSeek    := ""
aDbStru  := {}
aTamSX3  := {}
nTotAbat := 0
nSalPedl := 0
nSalPedb := 0
nQtdPed  := 0
nSalPed  := 0
cQuery   := ""
nValFat  := 0
aTotRec1 := {0,0}
aTotRec2 := {0,0}
aTotPed  := {0,0,0,0}
aTotFat  := {0,0}
aTotChq  := {0,0,0.00,0.00,0,0.00}

#IFDEF TOP
    Local cDBMS := UPPER(TcGetDB())
#ENDIF                              
If Type("lGConTit") #"L"
   lGConTit := .t.
EndIf
If Type("lGConPed") #"L"
   lGConPed := .t.
EndIf
If Type("lGConFat") #"L"
   lGConFat := .t.
EndIf

If lGConTit
   lGConTit := .f.
   //���������������������������������������������������������������Ŀ
   //� Cria Arquivo Temporario do Contas a Receber                   �
   //�����������������������������������������������������������������
   aadd(aDbStru,{"PREFIXO   ","C",03,0})
   aTamSx3 := TamSX3("E1_NUM")
   aadd(aDbStru,{"NUMERO    ","C",aTamSx3[1],aTamSx3[2]})
   aadd(aDbStru,{"PARCELA   ","C",01,0})
   aadd(aDbStru,{"TIPO      ","C",03,0})
   aadd(aDbStru,{"EMISSAO   ","D",08,0})
   aTamSx3 := TamSX3("E1_VALOR")
   aadd(aDbStru,{"PRINCIPAL ","N",aTamSx3[1],aTamSx3[2]})
   aTamSx3 := TamSX3("E1_SALDO")
   aadd(aDbStru,{"SALDO     ","N",aTamSx3[1],aTamSx3[2]})
   aadd(aDbStru,{"VENCTO    ","D",08,0})
   aadd(aDbStru,{"NATUREZA  ","C",10,0})
   aadd(aDbStru,{"ATRASO    ","N",06,0})
   aadd(aDbStru,{"BANCO     ","C",03,0})
   aadd(aDbStru,{"VLRJUROS  ","N",aTamSx3[1],aTamSx3[2]})
   aTamSx3 := TamSX3("E1_NUMBCO")
   aadd(aDbStru,{"NUMBCO    ","C",aTamSx3[1],aTamSx3[2]})
   aadd(aDbStru,{"SITUACA   ","C",22,0})
   aadd(aDbStru,{"HISTORICO ","C",30,0})
   aadd(aDbStru,{"OCORRENCIA","C",34,0})
	
   cArqRec1 := CriaTrab(aDbStru, .T. )
   dbUseArea(.T.,,cArqRec1,"REC1",.F.,.F.)
   IndRegua("REC1",cArqRec1,"DTOS(VENCTO)",,,"Selecionando Registros...")
	
   adbStru := {}
   aadd(aDbStru,{"PREFIXO   ","C",03,0})
   aTamSx3 := TamSX3("E1_NUM")
   aadd(aDbStru,{"NUMERO    ","C",aTamSx3[1],aTamSx3[2]})
   aadd(aDbStru,{"PARCELA   ","C",01,0})
   aadd(aDbStru,{"EMISSAO   ","D",08,0})
   aadd(aDbStru,{"NATUREZA  ","C",10,0})
   aTamSx3 := TamSX3("E1_VALOR")
   aadd(aDbStru,{"PRINCIPAL ","N",aTamSx3[1],aTamSx3[2]})
   aadd(aDbStru,{"PAGO      ","N",aTamSx3[1],aTamSx3[2]})
   aadd(aDbStru,{"BAIXA     ","D",08,0})
   aadd(aDbStru,{"VENCTO    ","D",08,0})
   aadd(aDbStru,{"DISPONIV  ","D",08,0})
   aadd(aDbStru,{"ATRASO    ","N",06,0})
   aadd(aDbStru,{"BANCO     ","C",03,0})
   aadd(aDbStru,{"AGENCIA   ","C",05,0})
   aadd(aDbStru,{"CONTA     ","C",10,0})
   aadd(aDbStru,{"HISTORICO ","C",30,0})
   aadd(aDbStru,{"MOTIVO    ","C",10,0})
   aadd(aDbStru,{"OCORRENCIA","C",34,0})
	
   cArqRec2 := CriaTrab(aDbStru, .T. )
   dbUseArea(.T.,,cArqRec2,"REC2",.F.,.F.)
   IndRegua("REC2",cArqRec2,"DTOS(VENCTO)",,,"Selecionando Registros...")
   //��������������������������������������������������������Ŀ
   //�Gera arquivo s� com os cheques. Loc. Argentina.         �
   //����������������������������������������������������������
   If cPaisLoc<>"BRA"
      adbStru := {}
      aadd(aDbStru,{"SITUACION ","C",09,0})
      aadd(aDbStru,{"TIPO      ","C",02,0})
      aTamSx3 := TamSX3("E1_NUM")
      aadd(aDbStru,{"NUMERO    ","C",aTamSx3[1],aTamSx3[2]})
      aadd(aDbStru,{"EMISSAO   ","D",08,0})
      aTamSx3 := TamSX3("E1_VALOR")
      aadd(aDbStru,{"PRINCIPAL ","N",aTamSx3[1],aTamSx3[2]})
      aadd(aDbStru,{"MOEDA     ","N",02,0})
      aTamSx3 := TamSX3("E1_VLCRUZ")
      aadd(aDbStru,{"VALMOED1  ","N",aTamSx3[1],aTamSx3[2]})
      aadd(aDbStru,{"NATUREZA  ","C",10,0})
      aadd(aDbStru,{"VENCTO    ","D",08,0})
      aadd(aDbStru,{"DEPOSITO  ","D",08,0})
      aadd(aDbStru,{"BANCO     ","C",03,0})
      aadd(aDbStru,{"AGENCIA   ","C",05,0})
      aadd(aDbStru,{"CONTA     ","C",10,0})
      aadd(aDbStru,{"HISTORICO ","C",30,0})
		
      cArqChq := CriaTrab(aDbStru, .T. )
      dbUseArea(.T.,,cArqChq,"CHQ",.F.,.F.)
      IndRegua("CHQ",cArqCHQ,"Descend(SITUACION)+DTOS(VENCTO)",,,"Selecionando Registros...")
   Endif
	
   //���������������������������������������������������������������Ŀ
   //� Tratamento do Contas a Receber                                �
   //�����������������������������������������������������������������
   aTotRec1[1] := 0
   aTotRec1[2] := 0
   aTotRec2[1] := 0
   aTotRec2[2] := 0
	
   #IFDEF WINDOWS
       ProcRegua(2)
   #ELSE
       SetRegua(2)
   #ENDIF

   #IFDEF TOP
       If ( TcSrvType() != "AS/400" )
          cQuery := "SELECT SE1.R_E_C_N_O_ RECNO,"
          cQuery := cQuery+"SX5.X5_DESCRI DESCRI, "

          If cDBMS == "ORACLE"
             cQuery := cQuery+"NVL(SUM(ABAT.E1_VLCRUZ),0) TOTABAT "
          ElseiF cDBMS == "INFORMIX"
             cQuery := cQuery+"SUM(ABAT.E1_VLCRUZ) TOTABAT "
          Else
             cQuery := cQuery+"ISNULL(SUM(ABAT.E1_VLCRUZ),0) TOTABAT "
          Endif

          cQuery := cQuery+ "FROM "+RetSqlName("SE1")+" ABAT, "+RetSqlName("SE1")+" SE1, "
          cQuery := cQuery+  RetSqlName("SX5")+" SX5 "

          If cDBMS == "ORACLE"
             cQuery := cQuery + "WHERE ABAT.E1_FILIAL(+)    =   SE1.E1_FILIAL AND "
             cQuery := cQuery + "ABAT.E1_PREFIXO(+) =   SE1.E1_PREFIXO AND "
             cQuery := cQuery + "ABAT.E1_NUM(+)     =   SE1.E1_NUM AND "
             cQuery := cQuery + "ABAT.E1_PARCELA(+) =   SE1.E1_PARCELA AND "
             cQuery := cQuery + "ABAT.E1_CLIENTE(+) =   SE1.E1_CLIENTE AND "
             cQuery := cQuery + "ABAT.E1_LOJA(+)        =   SE1.E1_LOJA AND "
             cQuery := cQuery + "ABAT.E1_TIPO(+) LIKE '%-' AND"
          ElseIf  cDBMS == "INFORMIX"
             cQuery := cQuery + "WHERE ABAT.E1_FILIAL       =+ SE1.E1_FILIAL AND "
             cQuery := cQuery + "ABAT.E1_PREFIXO        =+  SE1.E1_PREFIXO AND "
             cQuery := cQuery + "ABAT.E1_NUM            =+  SE1.E1_NUM AND "
             cQuery := cQuery + "ABAT.E1_PARCELA        =+  SE1.E1_PARCELA AND "
             cQuery := cQuery + "ABAT.E1_CLIENTE        =+  SE1.E1_CLIENTE AND "
             cQuery := cQuery + "ABAT.E1_LOJA           =+  SE1.E1_LOJA AND "
             cQuery := cQuery + "ABAT.E1_TIPO LIKE '%-' AND"
          Else
             cQuery := cQuery + "WHERE ABAT.E1_FILIAL=*SE1.E1_FILIAL AND "
             cQuery := cQuery + "ABAT.E1_PREFIXO=*SE1.E1_PREFIXO AND "
             cQuery := cQuery + "ABAT.E1_NUM=*SE1.E1_NUM AND "
             cQuery := cQuery + "ABAT.E1_PARCELA=*SE1.E1_PARCELA AND "
             cQuery := cQuery + "ABAT.E1_CLIENTE=*SE1.E1_CLIENTE AND "
             cQuery := cQuery + "ABAT.E1_LOJA=*SE1.E1_LOJA AND "
             cQuery := cQuery + "ABAT.E1_TIPO LIKE '%-' AND "
          Endif
          cQuery := cQuery + " SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "
          cQuery := cQuery + " SE1.E1_CLIENTE='"+SA1->A1_COD+"' AND "
          cQuery := cQuery + " SE1.E1_LOJA='"+SA1->A1_LOJA+"' AND "

          If ( MV_PAR05 == 2 )
             cQuery := cQuery + " SE1.E1_TIPO<>'PR ' AND "
          EndIf

          cQuery := cQuery + " SE1.E1_PREFIXO>='"+MV_PAR06+"' AND "
          cQuery := cQuery + " SE1.E1_PREFIXO<='"+MV_PAR07+"' AND "
          cQuery := cQuery + " SE1.E1_FATURA IN('"+Space(Len(SE1->E1_FATURA))+"','NOTFAT') AND "
          cQuery := cQuery + " SE1.E1_EMISSAO>='"+DTOS(MV_PAR01)+"' AND "
          cQuery := cQuery + " SE1.E1_EMISSAO<='"+DTOS(MV_PAR02)+"' AND "
          cQuery := cQuery + " SE1.E1_VENCREA>='"+DTOS(MV_PAR03)+"' AND "
          cQuery := cQuery + " SE1.E1_VENCREA<='"+DTOS(MV_PAR04)+"' AND "
          cQuery := cQuery + " SE1.E1_TIPO NOT LIKE '%-' AND "
          cQuery := cQuery + " SE1.D_E_L_E_T_<>'*' AND "
          cQuery := cQuery + " SX5.X5_FILIAL='"+xFilial("SX5")+"' AND "
          cQuery := cQuery + " SX5.X5_TABELA='07' AND "
          cQuery := cQuery + " SX5.X5_CHAVE=SE1.E1_SITUACA AND "
          cQuery := cQuery + " SX5.D_E_L_E_T_<>'*' "
          cQuery := cQuery + "GROUP BY SE1.R_E_C_N_O_, SX5.X5_DESCRI"
			
          cQuery := ChangeQuery(cQuery)

          dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TOPQRY",.T.,.T.)
			
          While ( !Eof() )
                cSituaca := TOPQRY->DESCRI
                nTotAbat := TOPQRY->TOTABAT
                aTotRec1 := aTotRec1
                aTotChq  := aTotChq
                aTotRec2 := aTotRec2
                nRegSE1  := TOPQRY->RECNO

                Fc010Grv1()
				dbSkip()
          EndDo
			
          dbCloseArea("TOPQRY")
          #IFDEF WINDOWS
             IncProc()
          #ELSE
             IncRegua()
          #ENDIF
       Else
   #ENDIF
          dbSelectArea("SE5")
          dbSetOrder(4)

          dbSelectArea("SE1")
          dbSetOrder(2)
          dbSeek(xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA)
			
          While ( ! Eof() .And. SE1->E1_FILIAL==xFilial("SE1") .And. ;
                SE1->E1_CLIENTE+SE1->E1_LOJA == SA1->A1_COD+SA1->A1_LOJA )
			
				If ( SubStr(SE1->E1_TIPO,3,1) == "-" )   //Abatimentos
                   dbSkip()
                   Loop
				EndIF
				If ( SubStr(SE1->E1_TIPO,1,2)=="PR" .and. MV_PAR05 == 2 ) // N�o Considera Provisorios?
                   dbSkip()
                   Loop
				EndIf
				If ( SE1->E1_PREFIXO < MV_PAR06 .or. SE1->E1_PREFIXO > MV_PAR07 ) //Do Prefixo ao Prefixo
                   dbSkip()
                   Loop
				EndIf
				If ( !Empty(SE1->E1_FATURA) .and. Substr(SE1->E1_FATURA,1,6) != "NOTFAT" )
                   dbSkip()
                   Loop
				EndIf
				If (SE1->E1_VENCREA>=MV_PAR03 .and. SE1->E1_VENCREA<=MV_PAR04 .and.;
                    SE1->E1_EMISSAO>=MV_PAR01 .and. SE1->E1_EMISSAO<=MV_PAR02 )
					
					If ( SE1->E1_SALDO > 0 )
                       //�����������������������������������������������Ŀ
                       //�Calcula Abatimento                             �
                       //�������������������������������������������������
                       nTotAbat:=SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
                       SE1->(dbSetOrder(2))
                       //�����������������������������������������������Ŀ
                       //�Procura situacao do titulo na Tabela           �
                       //�������������������������������������������������
                       dbSelectArea("SX5")
                       dbSetOrder(1)
                       If ( dbSeek(xFilial("SX5")+"07"+SE1->E1_SITUACA) )
                           cSituaca := SE1->E1_SITUACA+"-"+SubStr(SX5->X5_DESCRI,1,20)
                       EndIf
                    EndIf

                    cSituaca := cSituaca
                    nTotAbat := nTotAbat
                    aTotRec1 := aTotRec1
                    aTotChq  := aTotChq
                    aTotRec2 := aTotRec2
                    nRegSE1  := SE1->(RecNo())

                    Fc010Grv1()
				EndIf
				dbSelectArea("SE1")
				dbSkip()
          EndDo
          #IFDEF WINDOWS
             IncProc()
          #ELSE
             IncRegua()
          #ENDIF
	#IFDEF TOP
       EndIf
	#ENDIF
Endif
   
If lGConPed	 //  Processa Pedido
   lGConPed := .f.
   #IFDEF WINDOWS
       ProcRegua(1)
   #ELSE
       SetRegua(1)
   #ENDIF
	
   //���������������������������������������������������������������Ŀ
   //� Processa Pedidos de Venda                                     �
   //�����������������������������������������������������������������
   //���������������������������������������������������������������Ŀ
   //� Cria Arquivo Temporario dos Pedidos                           �
   //�����������������������������������������������������������������
   aDbStru := {}
   aadd(aDbStru,{"PEDIDO    ","C",06,0})
   aadd(aDbStru,{"EMISSAO   ","D",08,0})
   aadd(aDbStru,{"SLDTOT    ","N",18,2})
   aadd(aDbStru,{"SLDLIB    ","N",18,2})
   aadd(aDbStru,{"SLDPED    ","N",18,2})
   cArqPed := CriaTrab(aDbStru, .T. )
   dbUseArea(.T.,,cArqPed,"PED",.F.,.F.)
   IndRegua("PED",cArqPed,"PEDIDO",,,"Selecionando Registros...")

   aTotPed[1] := 0
   aTotPed[2] := 0
   aTotPed[3] := 0
   aTotPed[4] := 0
	
   dbSelectArea("SC5")
   #IFDEF TOP
       If ( TcSrvType() != "AS/400" )
          cQuery := "SELECT SC6.C6_NUM PEDIDO,"
          cQuery := cQuery +      "  SC5.C5_EMISSAO EMISSAO,"
          cQuery := cQuery +      "  SC5.C5_MOEDA MOEDA, "
          cQuery := cQuery +      "  (SC6.C6_QTDVEN-SC6.C6_QTDEMP-SC6.C6_QTDENT) QTDVEN, "
          cQuery := cQuery +      "  SC6.C6_PRCVEN PRCVEN "
          cQuery := cQuery +"FROM "+RetSqlName("SC5")+" SC5,"+RetSqlName("SC6")+" SC6,"
          cQuery := cQuery +        RetSqlName("SF4")+" SF4 "
          cQuery := cQuery +"WHERE SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
          cQuery := cQuery +      " SC5.C5_CLIENTE='"+SA1->A1_COD+"' AND "
          cQuery := cQuery +      " SC5.C5_LOJACLI='"+SA1->A1_LOJA+"' AND "
          cQuery := cQuery +      " SC5.C5_TIPO NOT IN('D','B') AND "
          cQuery := cQuery +      " SC5.D_E_L_E_T_<>'*' AND "
          cQuery := cQuery +      " SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
          cQuery := cQuery +      " SC6.C6_NUM=SC5.C5_NUM AND "
          cQuery := cQuery +      " SC6.C6_BLQ NOT IN('R ','S ') AND "
          cQuery := cQuery +      " (SC6.C6_QTDVEN-SC6.C6_QTDEMP-SC6.C6_QTDENT)>0 AND "
          cQuery := cQuery +      " SC6.D_E_L_E_T_<>'*' AND "
          cQuery := cQuery +      " SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
          cQuery := cQuery +      " SF4.F4_CODIGO=SC6.C6_TES AND "
          cQuery := cQuery +      " SF4.F4_DUPLIC='S' AND "
          cQuery := cQuery +      " SF4.D_E_L_E_T_<>'*'"
			
          cQuery := ChangeQuery(cQuery)
          dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TOPQRY",.T.,.T.)
			
          TCSetField("TOPQRY","EMISSAO","D")

          While ( !Eof() )
                cNumero := TOPQRY->PEDIDO
                dEmissao:= TOPQRY->EMISSAO
                nSalPed := xMoeda(TOPQRY->QTDVEN*TOPQRY->PRCVEN,TOPQRY->MOEDA,1,TOPQRY->EMISSAO)
                nSalPedL:= 0
                nSalPedb:= 0
                aTotPed := aTotPed

                Fc010Grv2()
                dbSelectArea("TOPQRY")
				dbSkip()
          EndDo
			
          dbSelectArea("TOPQRY")
          dbCloseArea()
          dbSelectArea("SC5")
			
          cQuery := "SELECT SC6.C6_NUM PEDIDO,"
          cQuery := cQuery +      "  SC5.C5_EMISSAO EMISSAO,"
          cQuery := cQuery +      "  SC5.C5_MOEDA MOEDA,"
          cQuery := cQuery +      "  SC9.C9_QTDLIB QTDLIB,"
          cQuery := cQuery +      "  SC9.C9_PRCVEN PRCVEN,"
          cQuery := cQuery +      "  SC9.C9_DATALIB DATALIB,"
          cQuery := cQuery +      "  SC9.C9_BLCRED BLCRED "
          cQuery := cQuery +"FROM "+RetSqlName("SC5")+" SC5,"+RetSqlName("SC6")+" SC6,"
          cQuery := cQuery +        RetSqlName("SF4")+" SF4,"+RetSqlName("SC9")+" SC9 "
          cQuery := cQuery +"WHERE SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
          cQuery := cQuery +      " SC5.C5_CLIENTE='"+SA1->A1_COD+"' AND "
          cQuery := cQuery +      " SC5.C5_LOJACLI='"+SA1->A1_LOJA+"' AND "
          cQuery := cQuery +      " SC5.C5_TIPO NOT IN('D','B') AND "
          cQuery := cQuery +      " SC5.D_E_L_E_T_<>'*' AND "
          cQuery := cQuery +      " SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
          cQuery := cQuery +      " SC6.C6_NUM=SC5.C5_NUM AND "
          cQuery := cQuery +      " SC6.D_E_L_E_T_<>'*' AND "
          cQuery := cQuery +      " SC6.C6_BLQ NOT IN('R ','S ') AND "
          cQuery := cQuery +      " SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
          cQuery := cQuery +      " SF4.F4_CODIGO=SC6.C6_TES AND "
          cQuery := cQuery +      " SF4.F4_DUPLIC='S' AND "
          cQuery := cQuery +      " SF4.D_E_L_E_T_<>'*' AND "
          cQuery := cQuery +      " SC9.C9_FILIAL='"+xFilial("SC9")+"' AND "
          cQuery := cQuery +      " SC9.C9_PEDIDO=SC5.C5_NUM AND "
          cQuery := cQuery +      " SC9.C9_ITEM=SC6.C6_ITEM AND "
          cQuery := cQuery +      " SC9.C9_PRODUTO=SC6.C6_PRODUTO AND "
          cQuery := cQuery +      " SC9.C9_NFISCAL='"+Space(Len(SC9->C9_NFISCAL))+"' AND "
          cQuery := cQuery +      " SC9.D_E_L_E_T_<>'*'"

          cQuery := ChangeQuery(cQuery)

          dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TOPQRY",.T.,.T.)
			
          TCSetField("TOPQRY","EMISSAO","D")
          TCSetField("TOPQRY","DATALIB","D")
			
          While ( !Eof() )
                cNumero := TOPQRY->PEDIDO
                dEmissao:= TOPQRY->EMISSAO
                nSalPed := 0
                nSalPedL:= If( Empty(TOPQRY->BLCRED),xMoeda(TOPQRY->QTDLIB*TOPQRY->PRCVEN,TOPQRY->MOEDA,1,TOPQRY->DATALIB),0)
                nSalPedb:= If(!Empty(TOPQRY->BLCRED),xMoeda(TOPQRY->QTDLIB*TOPQRY->PRCVEN,TOPQRY->MOEDA,1,TOPQRY->DATALIB),0)
                aTotPed := aTotPed

                Fc010Grv2()


				dbSelectArea("TOPQRY")				
				dbSkip()
						
				#IFDEF WINDOWS
					IncProc()
				#ELSE
					IncRegua()
				#ENDIF
          EndDo
			
          dbSelectArea("TOPQRY")
          dbCloseArea()
          dbSelectArea("SC5")
       Else
	#ENDIF
          dbSelectArea("SC5")
          dbSetOrder(3)
          dbSeek(xFilial("SC5")+SA1->A1_COD)
          While ( !Eof() .And. C5_FILIAL==xFilial("SC5") .And. C5_CLIENTE == SA1->A1_COD )
                nSalPedl := 0
                nSalPedb := 0
                nQtdPed  := 0
                nSalPed  := 0
				If ( C5_LOJACLI != SA1->A1_LOJA )
                   dbSkip()
                   Loop
                EndIf
				If ( C5_TIPO $ "DB" )
                   dbSkip()
                   Loop
				Endif
				If ( C5_EMISSAO >= MV_PAR01 .And. C5_EMISSAO <= MV_PAR02 )
                   dbSelectArea("SC6")
                   dbSetOrder(1)
                   dbSeek(xFilial("SC6")+SC5->C5_NUM)
                   While ( !Eof() .And. C6_FILIAL+C6_NUM == xFilial('SC5')+SC5->C5_NUM )
						If AllTrim(C6_BLQ) $ "R#S"
                           DbSkip()
                           Loop
						Endif
						//�����������������������������������������������������������Ŀ
						//� Buscar Qtde no arquivo SC9 (itens liberados) p/ A1_SALPEDL�
						//�������������������������������������������������������������
						dbSelectArea("SC9")
						dbSetOrder(2)
                        cSeek := xFilial("SC9")+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_NUM+SC6->C6_ITEM
						dbSeek(cSeek)
						If Found()
                           dbSelectArea("SF4")
                           dbSetOrder(1)
                           dbSeek(xFilial("SF4")+SC6->C6_TES)
                           If Found() .And. F4_DUPLIC == "S"
                              dbSelectArea("SC9")
                              While !Eof() .And. C9_FILIAL+C9_CLIENTE+C9_LOJA+C9_PEDIDO+C9_ITEM == cSeek
                                  If Empty(C9_NFISCAL) .AND. SC6->C6_PRODUTO==SC9->C9_PRODUTO
                                     If Empty(SC9->C9_BLCRED)
                                        nSalpedl := nSalpedl + xMoeda( SC9->C9_QTDLIB * SC9->C9_PRCVEN , SC5->C5_MOEDA , 1 , SC9->C9_DATALIB )
                                     Else
                                        nSalpedb := nSalpedb + xMoeda( SC9->C9_QTDLIB * SC9->C9_PRCVEN , SC5->C5_MOEDA , 1 , SC9->C9_DATALIB )
                                     EndIf
                                  EndIf
                                  dbSkip()
                              End
                           EndIf
						Endif
						dbSelectArea("SC9")
						dbSetOrder(1)
						//�������������������������������������������������Ŀ
                        //� Buscar Qtde no arquivo SC6 p/ A1_SALPED         �
						//���������������������������������������������������
						dbSelectArea("SF4")
                        dbSeek(xFilial("SF4")+SC6->C6_TES)
						If ( Found() .And. F4_DUPLIC == "S" )
							nQtdPed := SC6->C6_QTDVEN - SC6->C6_QTDEMP - SC6->C6_QTDENT
							nQtdPed := IIf( nQtdPed < 0 , 0 , nQtdPed )
                            nSalped := nSalped + xMoeda( nQtdPed * SC6->C6_PRCVEN , SC5->C5_MOEDA , 1 , SC5->C5_EMISSAO )
						EndIf
						dbSelectArea("SC6")
						dbSkip()
					EndDo
                    If ( nSalped+nSalpedl+nSalpedb > 0 )
                       cNumero := SC5->C5_NUM
                       dEmissao:= SC5->C5_EMISSAO
                       nSalPed := nSalPed
                       nSalPedL:= nSalPedL
                       nSalPedb:= nSalPedB
                       aTotPed := aTotPed
 
                       Fc010Grv2()
					EndIf
				Endif
				dbSelectArea("SC5")
				dbSkip()
				#IFDEF WINDOWS
					IncProc()
				#ELSE
					IncRegua()
				#ENDIF
			EndDo
	#IFDEF TOP
       EndIf
	#ENDIF
Endif	
If lGConFat	 //  Processa Faturamento
   lGConFat := .f.
	
   #IFDEF WINDOWS
       ProcRegua(1)
   #ELSE
       SetRegua(1)
   #ENDIF

   //���������������������������������������������������������������Ŀ
   //� Cria Arquivo Temporario do Faturamento                        �
   //�����������������������������������������������������������������
   aDbStru := {}
   aTamSx3 := TamSX3("F2_DOC")
   aadd(aDbStru,{"NOTA      ","C",aTamSx3[1],aTamSx3[2]})
   aadd(aDbStru,{"EMISSAO   ","D",08,0})
   aadd(aDbStru,{"VALOR     ","N",18,2})
   aTamSx3 := TamSX3("F2_DUPL")
   aadd(aDbStru,{"DUPLICATA ","C",aTamSx3[1],aTamSx3[2]})
   cArqFat := CriaTrab(aDbStru, .T. )
   dbUseArea(.T.,,cArqFat,"FAT",.F.,.F.)
   IndRegua("FAT",cArqFat,"NOTA",,,"Selecionando Registros...")

   aTotFat[1] := 0
   aTotFat[2] := 0
	
   dbSelectArea("SF2")
   #IFDEF TOP
       If ( TcSrvType() != "AS/400" )
          cQuery := "SELECT SF2.F2_DOC DOC,"
          cQuery := cQuery +      "  SF2.F2_EMISSAO EMISSAO,"
          cQuery := cQuery +      "  SF2.F2_DUPL DUPLIC,"
          cQuery := cQuery +      "  (SF2.F2_VALMERC+SF2.F2_FRETE+SF2.F2_VALIPI+SF2.F2_SEGURO+SF2.F2_ICMSRET) VALFAT "
          cQuery := cQuery +"FROM "+RetSqlName("SF2")+" SF2 "
          cQuery := cQuery +"WHERE SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
          cQuery := cQuery +      " SF2.F2_CLIENTE='"+SA1->A1_COD+"' AND "
          cQuery := cQuery +      " SF2.F2_LOJA='"+SA1->A1_LOJA+"' AND "
          cQuery := cQuery +      " SF2.F2_TIPO NOT IN('D','B') AND "
          cQuery := cQuery +      " SF2.F2_EMISSAO>='"+DTOS(MV_PAR01)+"' AND "
          cQuery := cQuery +      " SF2.F2_EMISSAO<='"+DTOS(MV_PAR02)+"' AND "
          cQuery := cQuery +      " SF2.D_E_L_E_T_<>'*'"

          cQuery := ChangeQuery(cQuery)
			
          dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TOPQRY",.T.,.T.)
          TCSetField("TOPQRY","EMISSAO","D")
			
          While ( !Eof() )
                cDoc    := TOPQRY->DOC
                dEmissao:= TOPQRY->EMISSAO
                cDuplic := TOPQRY->DUPLIC
                nValFat := TOPQRY->VALFAT
                aTotFat := aTotFat

                Fc010Grv3()
				dbSkip()
          EndDo
			
          #IFDEF WINDOWS
               IncProc()
          #ELSE
               IncRegua()
          #ENDIF
			
          dbSelectArea("TOPQRY")
          dbCloseArea()
          dbSelectArea("SF2")
		Else
	#ENDIF
          dbSelectArea("SF2")
          dbSetOrder(2)
          dbSeek(xFilial("SF2")+SA1->A1_COD+SA1->A1_LOJA)
          While ( !Eof() .And. F2_FILIAL==xFilial("SF2") .And.;
                F2_CLIENTE+F2_LOJA == SA1->A1_COD+SA1->A1_LOJA )
				If ( SF2->F2_TIPO $ "DB" )
                   dbSkip()
                   Loop
				EndIf
				dbSelectArea("SF2")
				If ( SF2->F2_EMISSAO >= MV_PAR01 .And. SF2->F2_EMISSAO <= MV_PAR02 )
                   cDoc    := SF2->F2_DOC
                   dEmissao:= SF2->F2_EMISSAO
                   cDuplic := SF2->F2_DUPL
                   nValFat := SF2->F2_VALMERC+SF2->F2_FRETE+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_ICMSRET
                   aTotFat := aTotFat

                   FC010GRV3()
				EndIf
				dbSelectArea("SF2")
				dbSkip()
				#IFDEF WINDOWS
					IncProc()
				#ELSE
					IncRegua()
				#ENDIF
          EndDo
	#IFDEF TOP
		EndIf
	#ENDIF
EndIf

dbSelectArea("SE1")
dbSetOrder(1)

dbSelectArea("SE5")
dbSetOrder(1)

dbSelectArea("SF2")
dbSetOrder(1)

dbSelectArea("SF4")
dbSetOrder(1)

dbSelectArea("SC5")
dbSetOrder(1)

dbSelectArea("SC6")
dbSetOrder(1)

dbSelectArea("SC9")
dbSetOrder(1)

dbSelectArea("SA1")

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    � Fc010Rel � Autor � Pilar S. ALbaladejo   � Data � 16/01/96 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o � Impressao da posicao de cliente                            ���
��������������������������������������������������������������������������Ĵ��
��� Sintaxe   � Fc010Rel()                                                 ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � Guaratingueta                                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Fc010Rel
Static Function Fc010Rel()
//����������������������������������������������������������������������Ŀ
//�Salva a integridade dos dados                                         �
//������������������������������������������������������������������������
nPedidos := 0
nNotas   := 0
nTotal   := 0
nTitulos := 0
nTotNota := 0
nTotPgto := 0
nTitPagos:= 0
cbtxt    := SPACE(10)
cbcont   := 0
aMatriz  := {}
nRegistro:= SA1->(Recno())
cPaisVer := GETMV("MV_PAISLOC")  // Pa�s da Versao (BRA , ARG , USA )
cMoeda   := GetMv("MV_MCUSTO")
cMoeda   := SubStr(Getmv("MV_SIMB"+cMoeda)+Space(4),1,4)
cTitulo  := "CONSULTA POSICAO ATUAL DE CLIENTES"
cCabec1  := " "
cCabec2  := " "
cNomeProg:= "GUFIC010"
cTamanho := "G"
li       := 0
m_pag 	 := 1

SA1->(dbGoto(nRegistro))
cMoeda   := GetMv("MV_MCUSTO")
cMoeda   := SubStr(Getmv("MV_SIMB"+cMoeda)+Space(4),1,4)

cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)

@li,000 PSAY Replicate("*",220)
li := li + 1
@li,000 PSAY RetTitle("A1_COD")+": "+SA1->A1_COD+"-"+SA1->A1_LOJA+"  "+RetTitle("A1_NOME")+": "+SA1->A1_NOME+" "+RetTitle("A1_TEL")+": "+SA1->A1_TEL
li := li + 1
@li,000 PSAY RetTitle("A1_CGC")+": "+SA1->A1_CGC
li := li + 1
@Li,000 PSAY RetTitle("A1_PRICOM")+": "+DTOC(SA1->A1_PRICOM)
li := li + 1
@Li,000 PSAY RetTitle("A1_ULTCOM")+": "+DTOC(SA1->A1_ULTCOM)
li := li + 1
@Li,000 PSAY RetTitle("A1_MATR")+":     "+TransForm(SA1->A1_MATR,Tm(SA1->A1_MATR,14))
li := li + 1
@li,000 PSAY RetTitle("A1_SALDUP")+":     "+TransForm(SA1->A1_SALDUP,Tm(SA1->A1_SALDUP,14))
li := li + 1
@Li,000 PSAY RetTitle("A1_MCOMPRA")+cMoeda+": "+TransForm(SA1->A1_MCOMPRA,Tm(SA1->A1_MCOMPRA,14))
li := li + 1
@Li,000 PSAY RetTitle("A1_MSALDO")+cMoeda+": "+TransForm(SA1->A1_MSALDO,Tm(SA1->A1_MSALDO,14))
li := li + 1
@Li,000 PSAY RetTitle("A1_SALDUPM")+cMoeda+": "+TransForm(SA1->A1_SALDUPM,Tm(SA1->A1_SALDUPM,14))
li := li + 1
@Li,000 PSAY RetTitle("A1_CHQDEVO")+": "+TransForm(SA1->A1_CHQDEVO,"9999")
li := li + 1
@Li,000 PSAY RetTitle("A1_DTULCHQ")+": "+Dtoc(SA1->A1_DTULCHQ)
li := li + 1
@Li,000 PSAY RetTitle("A1_TITPROT")+": "+TransForm(SA1->A1_TITPROT,"9999")
li := li + 1
@Li,000 PSAY RetTitle("A1_DTULTIT")+": "+DtoC(SA1->A1_DTULTIT)
li := li + 1
@Li,000 PSAY RetTitle("A1_RISCO")+": "+SA1->A1_RISCO
li := li + 1
@Li,000 PSAY RetTitle("A1_LC")+": "+TransForm(SA1->A1_LC,Tm(SA1->A1_LC,14))
li := li + 1
@Li,000 PSAY RetTitle("A1_VENCLC")+": "+Dtoc(SA1->A1_VENCLC)
li := li + 1
@Li,000 PSAY RetTitle("A1_GUAOBS")+": "+Substr(SA1->A1_GUAOBS,1,205)
Li := li + 3

@li,00 PSAY "TITULOS EM ABERTO"
li := li + 1
@li,00 PSAY Repl("-",17)
li := li + 1
dbSelectArea("REC1")
dbSetOrder(1)
DbGotop()

//          1         2         3         4         5         6         7         8         9         0         1         2
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567

cCabec1 := "PREF NUMERO  PC TIPO DT EMISSAO  DATA VENCTO  VALOR DO TITULO  SALDO DO TITULO  NATUREZA    ATRASO  VALOR JUROS BCO  "
cCabec1 := cCabec1 + "NO. NO BANCO  SITUACAO               OCORRENCIA RETORNO                 HISTORICO                  "
@li, 00 PSAY cCabec1
aMatriz := {}
_cTexto := " "
While ( !EOF() )
      _cTexto:= DTOS(REC1->VENCTO)+PADL(REC1->PREFIXO,4)+"  "+REC1->NUMERO+Space(2)
      _cTexto:= _cTexto + REC1->PARCELA+"  "+REC1->TIPO+"  "
      _cTexto:= _cTexto + PadC(DTOC(REC1->EMISSAO),10)+"  "+ Padc(DTOC(REC1->VENCTO),11) +"  "
      _cTexto:= _cTexto + Transf(REC1->PRINCIPAL,"@E 9999,999,999.99")+"  "
      _cTexto:= _cTexto + Transf(REC1->SALDO,"@E 9999,999,999.99")+"  "
      _cTexto:= _cTexto + REC1->NATUREZA+"  "+Str(REC1->ATRASO,6)+" "
      _cTexto:= _cTexto + Transf(REC1->VLRJUROS,"@E 99999,999.99")+" "
      _cTexto:= _cTexto + REC1->BANCO+"  "
      _cTexto:= _cTexto + PadL(REC1->NUMBCO,13)+" "
      _cTexto:= _cTexto + PadL(REC1->SITUACA,22)+" "
      _cTexto:= _cTexto + PADL(REC1->OCORRENCIA,34)+" "
      _cTexto:= _cTexto + REC1->HISTORICO

      aadd( aMatriz,_cTexto)
      dbSkip()
End
aSort( aMatriz )
For nLaco := 1 to Len( aMatriz)
    IF li > 60
       cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
    Endif
    li := li + 1
    @li, 00 PSAY Subst( aMatriz[nLaco] , 10 , Len( aMatriz[nLaco] ) )
Next

li := li + 2
@li,00 PSAY "Total Tits.: " + StrZero(aTotRec1[1],5)
@li,62 PSAY aTotRec1[2] Picture tm(aTotRec1[2],16)
cCabec1 := " "
cCabec2 := " "
IF li > 60
   cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
   @ li,00 PSAY Replicate("*",220)
   li := li + 1
Else
   li := li + 3
EndIf                                                                                                          1
//                   1         2         3         4         5         6         7         8         9         0         1         2         3
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//                      4         5         6         7         8         9        20         1
//                   789012345678901234567890123456789012345678901234567890123456789012345678901234

cCabec1:= "PRF NUMERO PC EMISSAO    NATUREZA     VALOR TITULO     VALOR PAGO  BAIXA       VENCTO.     DISPONIV.  ATRASO  BCO  AGENCIA  CONTA        "
cCabec1:= cCabec1 + "OCORRENCIA RETORNO                  HISTORICO                       MOTIVO BAIXA"

@li, 00 PSAY "TITULOS RECEBIDOS"
li := li + 1
@li, 00 PSAY Repl("-",17)
li := li + 1

dbSelectArea("REC2")
dbGotop()

@li, 00 PSAY cCabec1

While ( !EOF() )
      IF li > 60
         cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
      EndIf
      li := li + 1

      @li, 00 PSAY REC2->PREFIXO
      @li, 04 PSAY REC2->NUMERO
      @li, 11 PSAY REC2->PARCELA
      @li, 14 PSAY REC2->EMISSAO
      @li, 25 PSAY REC2->NATUREZA
      @li, 36 PSAY Transf(Moeda(REC2->PRINCIPAL,1,"R"),"@E 999,999,999.99")
      @li, 51 PSAY REC2->PAGO picture '@E 999,999,999.99'
      @li, 67 PSAY REC2->BAIXA
      @li, 79 PSAY REC2->VENCTO
      @li,091 PSAY REC2->DISPONIV
      @li,102 PSAY REC2->ATRASO picture "999999"
      @li,110 PSAY REC2->BANCO
      @li,115 PSAY REC2->AGENCIA
      @li,124 PSAY REC2->CONTA
      @li,137 PSAY REC2->OCORRENCIA
      @li,173 PSAY REC2->HISTORICO
      @li,205 PSAY REC2->MOTIVO
      dbSelectArea( "REC2" )
      dbSkip()
EndDo

li := li + 2
@li,00 PSAY "Total Recs.: " + StrZero( aTotRec2[1],5 )
@li,51 PSAY aTotRec2[2] Picture '@E 999,999,999.99'

cCabec1 := " "
cCabec2 := " "
IF li > 60
   cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
   @ li,00 PSAY Replicate("*",220)
   li := li + 1
Else
   li := li + 3
EndIf

@li,00 PSAY "PEDIDOS COLOCADOS"
li := li + 1

@li,00 PSAY Repl("-",17)
li := li + 1

//                  1           2           3           4           5           6           7           8           9           1
//         12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901

cCabec1:= "NUMERO        DATA EMISSAO      VALOR TOTAL     PED. LIBERADOS   SALDO PEDIDOS"
dbSelectArea("PED")
dbGoTop()
@ Li,00 PSAY cCabec1
li := li + 1
While ( !Eof() )
      If ( li > 60 )
         cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
      EndIf

      @ Li,00 PSAY PED->PEDIDO
      @ Li,14 PSAY DTOC(PED->EMISSAO)
      @ Li,28 PSAY PED->SLDTOT  Picture PesqPict("SA1","A1_SALPED",15)
      @ Li,47 PSAY PED->SLDLIB Picture PesqPict("SA1","A1_SALPED",15)
      @ Li,63 PSAY PED->SLDPED Picture PesqPict("SA1","A1_SALPED",15)

      li := li + 1
      dbSkip()
EndDo
li := li + 1

dbSelectArea("SA1")
@li,00 PSAY "Total Peds.: " + StrZero(aTotPed[1],4)
@Li,28 PSAY aTotPed[2] Picture PesqPict("SA1","A1_SALPED",15)
@Li,47 PSAY aTotPed[3] Picture PesqPict("SA1","A1_SALPED",15)
@Li,63 PSAY aTotPed[4] Picture PesqPict("SA1","A1_SALPED",15)

cCabec1 := " "
cCabec2 := " "
IF ( li > 60 )
   cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
   @ li,00 PSAY Replicate("*",220)
   li := li + 1
Else
   li := li + 3
EndIf
@li,00 PSAY "FATURAMENTO"
li := li + 1
@li,00 PSAY Repl("-",11)
li := li + 1
cCabec1:= "NUMERO        DATA EMISSAO    VALOR DA NOTA  DUPLICATA"

dbSelectArea("FAT")
dbGotop()
@li, 00 PSAY cCabec1
li := li + 1
While (!Eof() )
      If ( li > 60 )
         cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
      EndIf
      @li,00 PSAY FAT->NOTA
      @li,14 PSAY FAT->EMISSAO
      @li,29 PSAY FAT->VALOR   Picture tm(nTotNota,14)
      @li,45 PSAY FAT->DUPLICATA
      li := li + 1
      dbSkip()
EndDo
li := li + 1
@li,00 PSAY "Total NFs. : " +StrZero(aTotFat[1],4)
@li,29 PSAY aTotFat[2] Picture Tm( aTotFat[2], 14 )

If cPaisLoc<>"BRA"
   cCabec1:="Sit. Tipo Numero      Emision  Vencto   Deposito   Valor Cheque Mda.    Valor Pesos  Bco  Agencia  Cuenta"
   IF ( li > 60 )
      cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
      @ li,00 PSAY Replicate("*",220)
      li := li + 1
   Else
      li := li + 3
   EndIf
   @li,00 PSAY "CHEQUES/TRANSFERENCIAS"

   li := li + 1
   @li,00 PSAY Repl("-",11)
   //                1            2         3            4            5         6            7            8         9            10
   //          123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
   cCabec1:= "Sit. Tipo Numero      Emision  Vencto   Deposito   Valor Cheque Mda.    Valor Pesos  Bco  Agencia  Cuenta"
   li := li + 1

   dbSelectArea("CHQ")
   dbGotop()
   @li, 00 PSAY cCabec1
   li := li + 1
   While (!Eof() )
         If ( li > 60 )
            cabec(cTitulo,cCabec1,cCabec2,cNomeProg,cTamanho)
         EndIf

         @li,001 PSAY SUBS(CHQ->SITUACION,1,3)+"."
         @li,006 PSAY CHQ->TIPO
         @li,011 PSAY CHQ->NUMERO
         @li,024 PSAY CHQ->EMISSAO
         @li,033 PSAY CHQ->VENCTO
         @li,042 PSAY CHQ->DEPOSITO
         @li,051 PSAY CHQ->PRINCIPAL Picture tm(CHQ->PRINCIPAL,14,2)
         @li,067 PSAY STRZERO(CHQ->MOEDA,2)
         @li,071 PSAY CHQ->VALMOED1  Picture tm(CHQ->VALMOED1,14,2)
         @li,087 PSAY CHQ->BANCO
         @li,092 PSAY CHQ->AGENCIA
         @li,101 PSAY CHQ->CONTA
         li := li + 1
         dbSkip()
   EndDo
   li := li + 1
	
   @li, 03 PSAY "Valor Total : "
   @li, 23 PSAY "Cobrados "   + Transf(aTotChq[1],"@EB 99999,999,999.99")
   @li, 50 PSAY "Pendientes " + Transf(aTotChq[2],"@EB 99999,999,999.99")
   @li, 77 PSAY "Pendientes " + Transf(aTotChq[5],"@EB 99999,999,999.99")
   li := li + 1
   @li, 03 PSAY "Cant. Total : "
   @li, 23 PSAY "Cobrados "   + Transf(aTotChq[3],"@EB 99999,999,999.99")
   @li, 50 PSAY "Pendientes " + Transf(aTotChq[4],"@EB 99999,999,999.99")
   @li, 77 PSAY "Rechazados " + Transf(aTotChq[6],"@EB 99999,999,999.99")
Endif

//-> Apos impressao do relatorio padrao ocorrera a impressao dos dados
//-> de Historico de Credito do Cliente (SZ2)

//-> Cria vetor com os campos a serem impressos. O vetor possui 6 posicoes:
//-> Campo, Linha e Coluna de Impr, Descricao a ser impressa, Tipo e Picture
//-> As 3 ultimas posicoes serao preenchidas pela rotina SX3Dados() que
//-> procura pela ocorrencia do campo no SX3 e coleta do dicionario de dados
//-> o cabecalho a ser impresso, o Tipo do Campo e a Picture de Impressao.

//-> A ORDEM DE IMPRESSAO DAS INFORMACOES ESTA RELACIONADA COM A ORDEM DE
//-> ADICAO DOS CAMPOS NO VETOR...
*---------------------------------------------------------------------------
//-> Estrutura: Nome do Campo, Col.de Impressao, Label, Tipo e Picture
_aCampos := {}
Aadd(_aCampos,{"Z2_GUCOD"  , 10, 02,"","",""})
Aadd(_aCampos,{"Z2_GUNOME" , 10, 40,"","",""})
Aadd(_aCampos,{"Z2_GUDPCOM", 12, 02,"","",""})
Aadd(_aCampos,{"Z2_GUVPCOM", 12, 50,"","",""})
Aadd(_aCampos,{"Z2_GUDUVEN", 14, 02,"","",""})
Aadd(_aCampos,{"Z2_GUVUVEN", 14, 50,"","",""})
Aadd(_aCampos,{"Z2_GUVMPED", 16, 02,"","",""})
Aadd(_aCampos,{"Z2_GUDMVEN", 18, 02,"","",""})
Aadd(_aCampos,{"Z2_GUVMVEN", 18, 50,"","",""})
Aadd(_aCampos,{"Z2_GUDMDUP", 20, 02,"","",""})
Aadd(_aCampos,{"Z2_GUVMDUP", 20, 50,"","",""})
Aadd(_aCampos,{"Z2_GUQMEDA", 22, 02,"","",""})
Aadd(_aCampos,{"Z2_GUDMATR", 24, 02,"","",""})
Aadd(_aCampos,{"Z2_GUQMATR", 24, 50,"","",""})
Aadd(_aCampos,{"Z2_GUQPEDI", 28, 02,"","",""})
Aadd(_aCampos,{"Z2_GUQDUPL", 30, 02,"","",""})
Aadd(_aCampos,{"Z2_GUQDATR", 32, 02,"","",""})
Aadd(_aCampos,{"Z2_GUOBS01", 38, 02,"","",""})
Aadd(_aCampos,{"Z2_GUOBS02", 39, 02,"","",""})
Aadd(_aCampos,{"Z2_GUOBS03", 40, 02,"","",""})
Aadd(_aCampos,{"Z2_GUOBS04", 41, 02,"","",""})
Aadd(_aCampos,{"Z2_GUOBS05", 42, 02,"","",""})
Aadd(_aCampos,{"Z2_GUOBS06", 43, 02,"","",""})
Aadd(_aCampos,{"Z2_GUOBS07", 44, 02,"","",""})
Aadd(_aCampos,{"Z2_GUOBS08", 45, 02,"","",""})
Aadd(_aCampos,{"Z2_GUOBS09", 46, 02,"","",""})
Aadd(_aCampos,{"Z2_GUOBS10", 47, 02,"","",""})

_nI := 0
DbSelectArea("SX3")
_aSX3Area := GetArea()
DbSetOrder(2)

//-> Varrendo SX3 em busca de dicionario de dados de cada campo...
For _nI := 1 To Len(_aCampos)
    If !DbSeek(_aCampos[_nI,1])
	   Loop
	EndIf

	If SX3->X3_CONTEXT == "V"
	   Loop
	Endif

    If Substr(SX3->X3_CAMPO,1,8) == "Z2_GUOBS"
      _aCampos[_nI,4] := " * "
    Else
      _aCampos[_nI,4] := SX3->X3_DESCRIC
    EndIf

    _aCampos[_nI,5] := SX3->X3_TIPO
    _aCampos[_nI,6] := SX3->X3_PICTURE
Next _nI
DbSelectArea("SX3")
RestArea(_aSX3Area)

DbSelectArea("SZ2")
DbSetOrder(1)
DbSeek( xFilial("SZ2")+SA1->A1_COD)

IF FOUND()
   li:= 80
   If li > 55
      Cabec(cTitulo," "," ",wnrel,cTamanho)
      @li,000 PSAY Replicate("*",220)
      li:= li+ 2
      @li,002 PSAY "DADOS HISTORICOS DE CREDITO"
      li:= li+ 1
      @li,002 PSAY "---------------------------"
   EndIf

   _cMacro := ""
   _cDados := ""
   _nI     := 0

   For _nI := 1 to Len(_aCampos)
       _cMacro := _aCampos[_nI,1]

       If _aCampos[_nI,5] == "C"
          If Substr(_aCampos[_nI,1],1,8) == "Z2_GUOBS"
             _cDados := _aCampos[_nI,4] + AllTrim(&_cMacro)
          Else
             _cDados := _aCampos[_nI,4] +": "+ AllTrim(&_cMacro)
          EndIf
       ElseIf _aCampos[_nI,5] == "N"
          _cDados := _aCampos[_nI,4]+": "+StrTran(PadL(&_cMacro,17," "),".",",")
       ElseIf _aCampos[_nI,5] == "D"
          _cDados := _aCampos[_nI,4] +": "+ DtoC(&_cMacro)
       ElseIf _aCampos[_nI,5] == "L"
          _cDados := _aCampos[_nI,4] +": "+ IIf(&_cMacro,"S","N")
       EndIf

       If _aCampos[_nI,1] == "Z2_GUOBS01"
          @ PRow()+2,02 PSAY Replicate("-",217)
          @ PRow()+2,02 PSAY "O B S E R V A C O E S"
       EndIf

       @ _aCampos[_nI,2],_aCampos[_nI,3] PSAY _cDados  //Picture _aCampos[_nI,6]
   Next _nI
EndIF

If li != 80
   li := li + 1
   Roda(cbcont,cbtxt,"G")
EndIF

dbSelectArea("REC1")
dbCloseArea()
FErase(cArqRec1+".DBF")
FErase(cArqRec1+OrdBagExt())

dbSelectArea("REC2")
dbCloseArea()
FErase(cArqRec2+".dbf")
FErase(cArqRec2+OrdBagExt())

dbSelectArea("FAT")
dbCloseArea()
FErase(cArqFat+".DBF")
FErase(cArqFat+OrdBagExt())

dbSelectArea("PED")
dbCloseArea()
FErase(cArqPed+".DBF")
FErase(cArqPed+OrdBagExt())
If cPaisLoc<>"BRA"
   dbSelectArea("CHQ")
   dbCloseArea()
   If cpaisloc == "ARG"
      FErase(cArqChq+".DBF")
      FErase(cArqChq+OrdBagExt())
   Endif
Endif

dbSelectArea("SA1")

Set Device To Screen
If aReturn[5] == 1
   Set Printer TO
   dbCommitAll()
   OurSpool(wnrel)
Endif
MS_FLUSH()
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Fc010Grv1 � Autor �Eduardo Riera          � Data �24.08.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Efetua a Gravacao do Contas a Receber                       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Situacao                                             ���
���          �ExpN2: Abatimento                                           ���
���          �ExpA3: Totais do SE1                                        ���
���          �ExpA4: Totais do CHQ                                        ���
���          �ExpA5: Registro no SE1                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Fc010Grv1
Static Function Fc010Grv1()

aArea   := GetArea()
nSaldo  := 0
nPago   := 0
nAtraso := 0
aMotBx  := ReadMotBx()
nPos    := 0
cMotBx  := ""
nRecNo  := 0
cQuery  := ""
cAlias  := ""
nJuros  := 0

nTotAbat:= If(nTotAbat==Nil,0,nTotAbat)

If (cAlias != "SE1")
   nRecNo := nRegSE1
   dbSelectArea("SE1")
   dbGoto(nRecNo)
EndIf

If (cPaisLoc<>"BRA" .And. Alltrim(SE1->E1_TIPO) == "CH" .Or. Alltrim(SE1->E1_TIPO) == "TF" )   //Cheques ou transferencias
   Do CASE
      CASE SE1->E1_STATUS=="R"
           cSituacion  := "Rechazado"
           aTotChq[5]  := aTotChq[5] + 1
           aTotChq[6]  := aTotChq[6] + SE1->E1_VLCRUZ
      CASE SE1->E1_STATUS=="B"
           cSituacion  := "Cobrado"
           aTotChq[1]  := aTotChq[1] + 1
           aTotChq[3]  := aTotChq[3] + SE1->E1_VLCRUZ
      OTHERWISE
           cSituacion  := "Pendiente"
           aTotChq[2]  := aTotChq[2] + 1
           aTotChq[4]  := aTotChq[4] + SE1->E1_VLCRUZ
   EndCase
   RecLock("CHQ",.T.)
   CHQ->SITUACION:=  cSituacion
   CHQ->TIPO     :=  SE1->E1_TIPO
   CHQ->NUMERO   :=  SE1->E1_NUM
   CHQ->EMISSAO  :=  SE1->E1_EMISSAO
   CHQ->PRINCIPAL:=  SE1->E1_VALOR
   CHQ->MOEDA    :=  SE1->E1_MOEDA
   CHQ->VALMOED1 :=  SE1->E1_VLCRUZ
   CHQ->NATUREZA :=  SE1->E1_NATUREZ
   CHQ->VENCTO   :=  SE1->E1_VENCTO
   CHQ->DEPOSITO :=  SE1->E1_BAIXA
   CHQ->BANCO    :=  SE1->E1_BCOCHQ
   CHQ->AGENCIA  :=  SE1->E1_AGECHQ
   CHQ->CONTA    :=  SE1->E1_CTACHQ
   CHQ->HISTORICO:=  SE1->E1_HIST
   MsUnLock()
Else
   If ( SE1->E1_SALDO > 0 )
      //�����������������������������������������������Ŀ
      //� Calcula Atraso e Juros                        �
      //�������������������������������������������������
      nJuros  := 0
      fa070Juros()
      nSaldo := SE1->E1_SALDO - nTotAbat
		
      dbSelectArea("REC1")
      RecLock("REC1",.T.)
		
      REC1->PREFIXO   := SE1->E1_PREFIXO
      REC1->NUMERO    := SE1->E1_NUM
      REC1->PARCELA   := SE1->E1_PARCELA
      REC1->TIPO      := SE1->E1_TIPO
      REC1->EMISSAO   := SE1->E1_EMISSAO
      REC1->NATUREZA  := SE1->E1_NATUREZ
      REC1->VENCTO    := DataValida(SE1->E1_VENCTO,.T.)
      If dDataBase > DataValida(SE1->E1_VENCTO)
         nAtraso := dDataBase - SE1->E1_VENCTO
      Else
         nAtraso := dDataBase - DataValida(SE1->E1_VENCTO,.T.)
      Endif
      REC1->ATRASO    := nAtraso
      REC1->BANCO     := SE1->E1_PORTADO
      REC1->SITUACA   := cSituaca
      REC1->HISTORICO := SE1->E1_HIST
      REC1->NUMBCO    := SE1->E1_NUMBCO
      REC1->PRINCIPAL := SE1->E1_VLCRUZ
      REC1->SALDO     := Moeda(SE1->E1_SALDO-nTotAbat,1,"R")
      REC1->VLRJUROS  := nJuros
      REC1->OCORRENCIA:= IF(EMPTY(SE1->E1_GUAOCOR)," ",Substr(SE1->E1_GUAOCOR,4,3)+"-"+;
                         GETADVFVAL("SEB","EB_DESCRI",xFILIAL("SEB")+SE1->E1_GUAOCORR+"R",1," "))
      MsUnlock()
	
      aTotRec1[1] := aTotRec1[1] + 1
      If ( REC1->TIPO $ "RA #"+MV_CRNEG )
         aTotRec1[2] := aTotRec1[2] - REC1->SALDO
      Else
         aTotRec1[2] := aTotRec1[2] + REC1->SALDO
      EndIf
   EndIf
EndIf

#IFDEF TOP
   If ( TcSrvType()!="AS/400" )
      cQuery := "SELECT R_E_C_N_O_ SE5RECNO FROM "+RetSqlName("SE5")+" WHERE "
      cQuery := cQuery + "E5_FILIAL='"+xFilial("SE5")+"' AND "
      cQuery := cQuery + "E5_NATUREZ='"+SE1->E1_NATUREZ+"' AND "
      cQuery := cQuery + "E5_PREFIXO='"+SE5->E5_PREFIXO+"' AND "
      cQuery := cQuery + "E5_NUMERO='"+SE1->E1_NUM+"' AND "
      cQuery := cQuery + "E5_PARCELA='"+SE1->E1_PARCELA+"' AND "
      cQuery := cQuery + "E5_TIPO='"+SE5->E5_TIPO+"' AND "
      cQuery := cQuery + "E5_RECPAG='R' AND "
      cQuery := cQuery + "E5_SITUACA<>'C' AND "
      cQuery := cQuery + "D_E_L_E_T_<>'*'"
		
      cQuery := ChangeQuery(cQuery)
      cAlias := CriaTrab(,.F.)+"A"
      dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

      While ( !(cAlias)->(Eof()) )
            dbSelectArea("SE5")
			dbGoto((cAlias)->(SE5RECNO))
			
            nPago   := 0
			nAtraso	:= 0
            IF (SE5->E5_TIPO $ "RA /PA /"+MV_CRNEG+"/"+MV_CPNEG)
               (cAlias)->(dbSkip())
               Loop
			EndIf

			//������������������������������������������������������������������Ŀ
			//� Verifica se existe estorno para esta baixa                       �
			//��������������������������������������������������������������������
			If TemBxCanc()
               (cAlias)->( dbSkip() )
               Loop
			EndIf

			If SE5->E5_DATA > DataValida(SE1->E1_VENCTO,.T.)
               nAtraso := SE5->E5_DATA - SE1->E1_VENCTO
			Else
               nAtraso := SE5->E5_DATA - DataValida(SE1->E1_VENCTO,.T.)
			Endif
			cMotBbx := "         "

			//������������������������������������������������������������������Ŀ
			//� Pesquisa a descricao do motivo da baixa                          �
			//��������������������������������������������������������������������
			nPos := Ascan(aMotBx, {|x| Substr(x,1,3) == Upper(SE5->E5_MOTBX) })
			If nPos > 0
				cMotBx := Substr(aMotBx[nPos],07,10)
			ElseIf E5_MOTBX == "CEC"
                cMotBx := "COMP CART"
			ElseIf E5_MOTBX == "LIQ"
                cMotBx := "LIQUIDAC."
			EndIf
			If ( E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
                nPago:= nPago+ E5_VALOR
			EndIf

			If ( nPago != 0 )
               dbSelectArea( "REC2" )
               dbSetOrder(1)
               RecLock("REC2",.T.)

               REC2->PREFIXO   := SE1->E1_PREFIXO
               REC2->NUMERO    := SE1->E1_NUM
               REC2->PARCELA   := SE1->E1_PARCELA
               REC2->EMISSAO   := SE1->E1_EMISSAO
               REC2->NATUREZA  := SE1->E1_NATUREZ
               REC2->VENCTO    := SE1->E1_VENCTO
               REC2->BAIXA     := SE5->E5_DATA
               REC2->DISPONIV  := SE5->E5_DTDISPO
               REC2->ATRASO    := nAtraso
               REC2->BANCO     := SE5->E5_BANCO
               REC2->AGENCIA   := SE5->E5_AGENCIA
               REC2->CONTA     := SE5->E5_CONTA
               REC2->HISTORICO := SE5->E5_HISTOR
               REC2->PRINCIPAL := SE1->E1_VLCRUZ
               REC2->PAGO      := nPago
               REC2->MOTIVO    := cMotBx
               REC2->OCORRENCIA:= IF(EMPTY(SE1->E1_GUAOCOR)," ",Substr(SE1->E1_GUAOCOR,4,3)+"-"+;
                                  GETADVFVAL("SEB","EB_DESCRI",xFILIAL("SEB")+SE1->E1_GUAOCORR+"R",1," "))
               MsUnlock()
               aTotRec2[1] := aTotRec2[1] + 1
               aTotRec2[2] := aTotRec2[2] + REC2->PAGO
			EndIf
			dbSelectArea( cAlias )
			dbSkip()
      EndDo
      dbSelectArea( cAlias )
      dbCloseArea()
		
      dbSelectArea("SE5")
   Else
#ENDIF
      dbSelectArea("SE5")
      dbSetOrder(4)
      dbSeek(xFilial("SE5")+SE1->E1_NATUREZ+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO,.T.)
		
      While ( !Eof() .And. xFilial("SE5") == SE5->E5_FILIAL .And.;
                          SE1->E1_NATUREZ == SE5->E5_NATUREZ .And.;
                          SE1->E1_PREFIXO == SE5->E5_PREFIXO .And.;
                              SE1->E1_NUM == SE5->E5_NUMERO  .And.;
                          SE1->E1_PARCELA == SE5->E5_PARCELA .And.;
                             SE1->E1_TIPO == SE5->E5_TIPO )
		
            nPago   := 0
            nAtraso := 0
            IF ( SE5->E5_TIPO $ "RA /PA /"+MV_CRNEG+"/"+MV_CPNEG )
               dbSkip( )
               Loop
            EndIf

            //���������������������������������������������������������������Ŀ
            //� Verifica se existe estorno para esta baixa                    �
            //�����������������������������������������������������������������
            If TemBxCanc( E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
               SE5->( dbSkip() )
               Loop
            EndIf
            If E5_SITUACA == "C"
               SE5->( dbSkip() )
               Loop
            Endif

            If SE5->E5_DATA > DataValida(SE1->E1_VENCTO,.T.)
               nAtraso := SE5->E5_DATA - SE1->E1_VENCTO
            Else
               nAtraso := SE5->E5_DATA - DataValida(SE1->E1_VENCTO,.T.)
            Endif
            cMotBbx := "         "

           //���������������������������������������������������������������Ŀ
           //� Pesquisa a descricao do motivo da baixa                       �
           //�����������������������������������������������������������������
           nPos := Ascan(aMotBx, {|x| Substr(x,1,3) == Upper(SE5->E5_MOTBX) })
           If nPos > 0
              cMotBx := Substr(aMotBx[nPos],07,10)
           ElseIf E5_MOTBX == "CEC"
              cMotBx := "COMP CART"
           ElseIf E5_MOTBX == "LIQ"
              cMotBx := "LIQUIDAC."
           EndIf
           If ( E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
              nPago := nPago + E5_VALOR
           EndIf

           If ( nPago != 0 )
              dbSelectArea( "REC2" )
              dbSetOrder(1)
              RecLock("REC2",.T.)

              REC2->PREFIXO   := SE1->E1_PREFIXO
              REC2->NUMERO    := SE1->E1_NUM
              REC2->PARCELA   := SE1->E1_PARCELA
              REC2->EMISSAO   := SE1->E1_EMISSAO
              REC2->NATUREZA  := SE1->E1_NATUREZ
              REC2->VENCTO    := SE1->E1_VENCTO
              REC2->BAIXA     := SE5->E5_DATA
              REC2->DISPONIV  := SE5->E5_DTDISPO
              REC2->ATRASO    := nAtraso
              REC2->BANCO     := SE5->E5_BANCO
              REC2->AGENCIA   := SE5->E5_AGENCIA
              REC2->CONTA     := SE5->E5_CONTA
              REC2->HISTORICO := SE5->E5_HISTOR
              REC2->PRINCIPAL := SE1->E1_VLCRUZ
              REC2->PAGO      := nPago
              REC2->MOTIVO    := cMotBx
              REC2->OCORRENCIA:= IF(EMPTY(SE1->E1_GUAOCOR)," ",Substr(SE1->E1_GUAOCOR,4,3)+"-"+ ;
                                 GETADVFVAL("SEB","EB_DESCRI",xFILIAL("SEB")+SE1->E1_GUAOCORR+"R",1," "))
              MsUnlock()
              aTotRec2[1] := aTotRec2[1] + 1
              aTotRec2[2] := aTotRec2[2] + REC2->PAGO
           EndIf
           dbSelectArea( "SE5" )
           dbSkip()
      EndDo
#IFDEF TOP
   EndIf
#ENDIF

RestArea(aArea)
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Fc010Grv2 � Autor �Eduardo Riera          � Data �23.08.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Efetua a Gravacao dos Pedidos                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Numero                                               ���
���          �ExpD2: Emissao                                              ���
���          �ExpN3: Saldo de Pedidos                                     ���
���          �ExpN4: Saldo dos Pedidos Liberado                           ���
���          �ExpN5: Saldo dos Pedidos Bloqueados                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Fc010Grv2
Static Function Fc010Grv2()

cAlias := Alias()

dbSelectArea("PED")
If (! dbSeek(cNumero) )
   RecLock("PED",.T.)
   aTotPed[1] := aTotPed[1] + 1
Else
	RecLock("PED",.F.)
EndIf
PED->PEDIDO	:= cNumero
PED->EMISSAO:= dEmissao
PED->SLDTOT := PED->SLDTOT + nSalPed+nSalPedL+nSalPedb
PED->SLDLIB := PED->SLDLIB + nSalPedL
PED->SLDPED := PED->SLDPED + nSalPed+nSalPedb
MsUnLock()

aTotPed[2] := aTotPed[2] + nSalPed+nSalPedL+nSalPedb
aTotPed[3] := aTotPed[3] + nSalPedL
aTotPed[4] := aTotPed[4] + nSalPed+nSalPedb

dbSelectArea(cAlias)

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Fc010Grv3 � Autor �Eduardo Riera          � Data �23.08.1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Efetua a Gravacao dos Pedidos                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Numero                                               ���
���          �ExpD2: Emissao                                              ���
���          �ExpC3: Duplicata                                            ���
���          �ExpN4: Valor Fatura                                         ���
���          �ExpA5: Total do Faturamento                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Fc010Grv3
Static Function Fc010Grv3()

cAlias := Alias()
dbSelectArea("FAT")
RecLock("FAT",.T.)
		
FAT->NOTA		:= cDoc
FAT->EMISSAO	:= dEmissao
FAT->VALOR		:= nValFat
FAT->DUPLICATA	:= cDuplic

aTotFat[1] := aTotFat[1] + 1
aTotFat[2] := aTotFat[2] + FAT->VALOR

MsUnlock()

dbSelectArea(cAlias)

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
