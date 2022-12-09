#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Mta650i()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_NITEM,_AAREAANT,_AAREASC2,_AAREASC5,_AAREASC6,_AAREASZC")
SetPrvt("_AAREASG1,_NRECSC5,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MTA650I  ³ Autor ³ Jefferson Marques     ³ Data ³29/04/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Pedido de Venda Automatico para OP de Terceiros       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
_nItem      := 0
_aAreaANT   :=  GetArea()
_nRecSC5	:= 0

dbSelectArea("SC2")
_aAreaSC2   :=  GetArea()

dbSelectArea("SC5")
_aAreaSC5   :=  GetArea()

dbSelectArea("SC6")
_aAreaSC6   :=  GetArea()

dbSelectArea("SZC")
_aAreaSZC   :=  GetArea()

dbSelectArea("SC2")

//----> VERIFICA SE E ORDEM DE PRODUCAO DE TERCEIROS
If SC2->C2_TERCEI$"S"
	dbSelectArea("SC5")
	_aAreaSC5   :=  GetArea()
	dbSetOrder(12)
	If !dbSeek(xFilial("SC5")+SC2->C2_NF_TERC+SC2->C2_TIPO,.f.)
		If MsgBox("Deseja gerar Pedido de Venda para esta Ordem de Producao ?","Pedido de Venda Automatico","YesNo")
			
			dbSelectArea("SZC")
			_aAreaSZC   :=  GetArea()
			dbSetOrder(2)
			If dbSeek(xFilial("SZC")+SC2->C2_PRODUTO+SC2->C2_TIPO,.F.)
				
				dbSelectArea("SC5")
				RecLock("SC5",.t.)
				SC5->C5_FILIAL      :=  xFilial("SC5")
				SC5->C5_NUM         :=  GetSx8Num("SC5")
				SC5->C5_PEDCLI		:= 	SC2->C2_PEDCLI
				ConfirmSX8()
				
				SC5->C5_TIPO        :=  "N"
				SC5->C5_CLIENTE     :=  SZC->ZC_CLIENTE
				SC5->C5_LOJAENT     :=  SZC->ZC_LOJA
				SC5->C5_LOJACLI     :=  SZC->ZC_LOJA
				SC5->C5_TIPOCLI     :=  Posicione("SA1",1,xFilial("SA1")+SZC->ZC_CLIENTE+SZC->ZC_LOJA,"A1_TIPO")
				SC5->C5_TRANSP      :=  SZC->ZC_TRANSP
				SC5->C5_TABELA      :=  "1"
				SC5->C5_PAPELET     :=  SZC->ZC_PAPELET
				SC5->C5_TPCOBR      :=  "1"
				SC5->C5_VEND1       :=  SZC->ZC_VEND
				SC5->C5_COMIS1      :=  SZC->ZC_PCOMISS
				SC5->C5_CONDPAG     :=  SZC->ZC_CONDPAG
				SC5->C5_NATUREZ     :=  "0015"
				SC5->C5_EMISSAO     :=  dDataBase
				SC5->C5_MOEDA       :=  1
				SC5->C5_NF_TERC     :=  SC2->C2_NF_TERC
				SC5->C5_SERVICO     :=  SZC->ZC_SERVICO
				SC5->C5_MENNOTA     :=  "DEVOL REF NF "+SC2->C2_NF_TERC
				SC5->C5_X_USER		:=	USRFULLNAME(__CUSERID)
				MsUnLock()
				
				//----> MAO DE OBRA
				dbSelectArea("SC6")
				RecLock("SC6",.t.)
				SC6->C6_FILIAL      :=  xFilial("SC6")
				SC6->C6_ITEM        :=  "01"
				SC6->C6_PRODUTO     :=  SZC->ZC_CODMO
				SC6->C6_UM          :=  Posicione("SB1",1,xFilial("SB1")+SZC->ZC_CODMO,"B1_UM")
				SC6->C6_FORMATO     :=  "1"
				SC6->C6_TES         :=  SZC->ZC_TESMO
				SC6->C6_CF          :=  Posicione("SF4",1,xFilial("SF4")+SZC->ZC_TESMO,"F4_CF")
				SC6->C6_QTDVEN      :=  Round(IIF(SZC->ZC_TIPCOB$"M",SC2->C2_QUANT,SC2->C2_QTSEGUM),2)
				SC6->C6_PRCVEN      :=  SZC->ZC_PRECO
				SC6->C6_VALOR       :=  IIF(SZC->ZC_TIPCOB$"M",SC2->C2_QUANT * SZC->ZC_PRECO,SC2->C2_QTSEGUM * SZC->ZC_PRECO)
				SC6->C6_LOCAL       :=  Posicione("SB1",1,xFilial("SB1")+SZC->ZC_CODMO,"B1_LOCPAD")
				SC6->C6_CLI         :=  SZC->ZC_CLIENTE
				SC6->C6_ENTREG      :=  dDataBase
				SC6->C6_LOJA        :=  SZC->ZC_LOJA
				SC6->C6_NUM         :=  SC5->C5_NUM
				SC6->C6_DESCRI      :=  Alltrim(Posicione("SB1",1,xFilial("SB1")+SZC->ZC_CODMO,"B1_DESC"))+" "+Alltrim(SZC->ZC_CODPRO)
				SC6->C6_GRADE       :=  "N"
				SC6->C6_CLASFIS     :=  Posicione("SB1",1,xFilial("SB1")+SZC->ZC_CODMO,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+SZC->ZC_TESMO,"F4_SITTRIB")
				SC6->C6_FCICOD		:=	Posicione("CFD",2,xFilial("CFD")+SZC->ZC_CODMO,"CFD_FCICOD")
				MsUnLock()
				
				//----> PRODUTO BENEFICIADO
				dbSelectArea("SC6")
				RecLock("SC6",.t.)
				SC6->C6_FILIAL      :=  xFilial("SC6")
				SC6->C6_ITEM        :=  "02"
				SC6->C6_PRODUTO     :=  SC2->C2_PRODUTO
				SC6->C6_UM          :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_UM")
				SC6->C6_FORMATO     :=  "1"
				SC6->C6_TES         :=  SZC->ZC_TESRET
				SC6->C6_CF          :=  Posicione("SF4",1,xFilial("SF4")+SZC->ZC_TESRET,"F4_CF")
				SC6->C6_QTDVEN      :=  Round(SC2->C2_QUANT,2)
				SC6->C6_PRCVEN      :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_PRV1")
				SC6->C6_VALOR       :=  SC2->C2_QUANT * Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_PRV1")
				SC6->C6_LOCAL       :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_LOCPAD")
				SC6->C6_CLI         :=  SZC->ZC_CLIENTE
				SC6->C6_ENTREG      :=  dDataBase
				SC6->C6_LOJA        :=  SZC->ZC_LOJA
				SC6->C6_NUM         :=  SC5->C5_NUM
				SC6->C6_DESCRI      :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC")
				SC6->C6_GRADE       :=  "N"
				SC6->C6_CLASFIS     :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+SZC->ZC_TESRET,"F4_SITTRIB")
				SC6->C6_FCICOD		:=	Posicione("CFD",2,xFilial("CFD")+SC2->C2_PRODUTO,"CFD_FCICOD")
				MsUnLock()
				
				/*
				dbSelectArea("SG1")
				_aAreaSG1   :=  GetArea()
				dbSetOrder(1)
				If dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+Subs(SC2->C2_PRODUTO,1,3),.f.)
					
					//----> PODER DE TERCEIROS
					dbSelectArea("SC6")
					RecLock("SC6",.t.)
					SC6->C6_FILIAL      :=  xFilial("SC6")
					SC6->C6_ITEM        :=  "03"
					SC6->C6_PRODUTO     :=  SG1->G1_COMP
					SC6->C6_UM          :=  Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_UM")
					SC6->C6_FORMATO     :=  "1"
					SC6->C6_TES         :=  "600"
					SC6->C6_CF          :=  Posicione("SF4",1,xFilial("SF4")+"600","F4_CF")
					SC6->C6_QTDVEN      :=  Round(SC2->C2_QUANT,2)
					SC6->C6_PRCVEN      :=  SZC->ZC_PRECO
					SC6->C6_VALOR       :=  SC2->C2_QUANT * SZC->ZC_PRECO
					SC6->C6_LOCAL       :=  Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_LOCPAD")
					SC6->C6_CLI         :=  SZC->ZC_CLIENTE
					SC6->C6_ENTREG      :=  dDataBase
					SC6->C6_LOJA        :=  SZC->ZC_LOJA
					SC6->C6_NUM         :=  SC5->C5_NUM
					SC6->C6_DESCRI      :=  Alltrim(Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_DESC"))+" "+Alltrim(SG1->G1_COD)
					SC6->C6_GRADE       :=  "N"
					SC6->C6_CLASFIS     :=  "000"
					MsUnLock()
					
				EndIf
				*/
				
				//----> GRAVA O PEDIDO E O ITEM GERADO NA ORDEM DE PRODUCAO
				dbSelectArea("SC2")
				RecLock("SC2",.F.)
				SC2->C2_PV_TERC     :=  SC5->C5_NUM
				SC2->C2_IT_TERC     :=  SC6->C6_ITEM
				MsUnLock()
				
				MsgBox("Foi gerado o Pedido de Venda "+SC5->C5_NUM+". Favor avisar o pessoal da Expedicao.","Pedido de Venda Automatico Gerado","Info")
			Else
				MsgBox("O Pedido de Venda nao sera gerado devido ao produto "+Alltrim(SC2->C2_PRODUTO)+" nao estar cadastrado na Tabela de Precos de Terceiros.","Preco Nao Cadastrado","Stop")
			EndIf
		Else
			MsgBox("Nao sera gerado Pedido de Venda.","Pedido de Venda Automatico Cancelado","Stop")
		EndIf
	Else
		While SC5->(C5_NF_TERC+C5_SERVICO) == SC2->(C2_NF_TERC+C2_TIPO)
			dbSelectArea("SC5")
			_nRecSC5    := Recno()
			dbSkip()
		EndDo
		
		dbSelectArea("SC5")
		dbGoTo(_nRecSC5)
		
		//----> CASO O PEDIDO DE VENDA JA EXISTA PERGUNTA SE COMPLEMENTA OU CRIA NOVO PEDIDO
		If MsgBox("Ja existe o Pedido de Venda "+SC5->C5_NUM+" para a Nota Fiscal de Terceiros "+SC2->C2_NF_TERC+". Deseja incluir novo Pedido de Venda ?","Pedido de Venda Automatico","YesNo")
			
			dbSelectArea("SZC")
			_aAreaSZC   :=  GetArea()
			dbSetOrder(2)
			If dbSeek(xFilial("SZC")+SC2->C2_PRODUTO+SC2->C2_TIPO,.F.)
				
				dbSelectArea("SC5")
				RecLock("SC5",.t.)
				SC5->C5_FILIAL      :=  xFilial("SC5")
				SC5->C5_NUM         :=  GetSx8Num("SC5")
				SC5->C5_PEDCLI		:=	SC2->C2_PEDCLI
				ConfirmSX8()
				
				SC5->C5_TIPO        :=  "N"
				SC5->C5_CLIENTE     :=  SZC->ZC_CLIENTE
				SC5->C5_LOJAENT     :=  SZC->ZC_LOJA
				SC5->C5_LOJACLI     :=  SZC->ZC_LOJA
				SC5->C5_TIPOCLI     :=  Posicione("SA1",1,xFilial("SA1")+SZC->ZC_CLIENTE+SZC->ZC_LOJA,"A1_TIPO")
				SC5->C5_TRANSP      :=  SZC->ZC_TRANSP
				SC5->C5_TABELA      :=  "1"
				SC5->C5_PAPELET     :=  SZC->ZC_PAPELET
				SC5->C5_TPCOBR      :=  "1"
				SC5->C5_VEND1       :=  SZC->ZC_VEND
				SC5->C5_COMIS1      :=  SZC->ZC_PCOMISS
				SC5->C5_CONDPAG     :=  SZC->ZC_CONDPAG
				SC5->C5_NATUREZ     :=  "0015"
				SC5->C5_EMISSAO     :=  dDataBase
				SC5->C5_MOEDA       :=  1
				SC5->C5_NF_TERC     :=  SC2->C2_NF_TERC
				SC5->C5_SERVICO     :=  SZC->ZC_SERVICO
				SC5->C5_MENNOTA     :=  "DEVOL REF NF "+SC2->C2_NF_TERC
				SC5->C5_X_USER		:=	USRFULLNAME(__CUSERID)
				MsUnLock()
				
				//----> MAO DE OBRA
				dbSelectArea("SC6")
				RecLock("SC6",.t.)
				SC6->C6_FILIAL      :=  xFilial("SC6")
				SC6->C6_ITEM        :=  "01"
				SC6->C6_PRODUTO     :=  SZC->ZC_CODMO
				SC6->C6_UM          :=  Posicione("SB1",1,xFilial("SB1")+SZC->ZC_CODMO,"B1_UM")
				SC6->C6_FORMATO     :=  "1"
				SC6->C6_TES         :=  SZC->ZC_TESMO
				SC6->C6_CF          :=  Posicione("SF4",1,xFilial("SF4")+SZC->ZC_TESMO,"F4_CF")
				SC6->C6_QTDVEN      :=  Round(IIF(SZC->ZC_TIPCOB$"M",SC2->C2_QUANT,SC2->C2_QTSEGUM),2)
				SC6->C6_PRCVEN      :=  SZC->ZC_PRECO
				SC6->C6_VALOR       :=  IIF(SZC->ZC_TIPCOB$"M",SC2->C2_QUANT * SZC->ZC_PRECO,SC2->C2_QTSEGUM * SZC->ZC_PRECO)
				SC6->C6_LOCAL       :=  Posicione("SB1",1,xFilial("SB1")+SZC->ZC_CODMO,"B1_LOCPAD")
				SC6->C6_CLI         :=  SZC->ZC_CLIENTE
				SC6->C6_ENTREG      :=  dDataBase
				SC6->C6_LOJA        :=  SZC->ZC_LOJA
				SC6->C6_NUM         :=  SC5->C5_NUM
				SC6->C6_DESCRI      :=  Alltrim(Posicione("SB1",1,xFilial("SB1")+SZC->ZC_CODMO,"B1_DESC"))+" "+Alltrim(SZC->ZC_CODPRO)
				SC6->C6_GRADE       :=  "N"
				SC6->C6_CLASFIS     :=  Posicione("SB1",1,xFilial("SB1")+SZC->ZC_CODMO,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+SZC->ZC_TESMO,"F4_SITTRIB")
				SC6->C6_FCICOD		:=	Posicione("CFD",2,xFilial("CFD")+SZC->ZC_CODMO,"CFD_FCICOD")
				MsUnLock()
				
				//----> PRODUTO BENEFICIADO
				dbSelectArea("SC6")
				RecLock("SC6",.t.)
				SC6->C6_FILIAL      :=  xFilial("SC6")
				SC6->C6_ITEM        :=  "02"
				SC6->C6_PRODUTO     :=  SC2->C2_PRODUTO
				SC6->C6_UM          :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_UM")
				SC6->C6_FORMATO     :=  "1"
				SC6->C6_TES         :=  SZC->ZC_TESRET
				SC6->C6_CF          :=  Posicione("SF4",1,xFilial("SF4")+SZC->ZC_TESRET,"F4_CF")
				SC6->C6_QTDVEN      :=  Round(SC2->C2_QUANT,2)
				SC6->C6_PRCVEN      :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_PRV1")
				SC6->C6_VALOR       :=  SC2->C2_QUANT * Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_PRV1")
				SC6->C6_LOCAL       :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_LOCPAD")
				SC6->C6_CLI         :=  SZC->ZC_CLIENTE
				SC6->C6_ENTREG      :=  dDataBase
				SC6->C6_LOJA        :=  SZC->ZC_LOJA
				SC6->C6_NUM         :=  SC5->C5_NUM
				SC6->C6_DESCRI      :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC")
				SC6->C6_GRADE       :=  "N"
				SC6->C6_CLASFIS     :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+SZC->ZC_TESRET,"F4_SITTRIB")
				SC6->C6_FCICOD		:=	Posicione("CFD",2,xFilial("CFD")+SC2->C2_PRODUTO,"CFD_FCICOD")
				MsUnLock()
				
				/*
				dbSelectArea("SG1")
				_aAreaSG1   :=  GetArea()
				dbSetOrder(1)
				If dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+Subs(SC2->C2_PRODUTO,1,3),.f.)
					
					//----> PODER DE TERCEIROS
					dbSelectArea("SC6")
					RecLock("SC6",.t.)
					SC6->C6_FILIAL      :=  xFilial("SC6")
					SC6->C6_ITEM        :=  "03"
					SC6->C6_PRODUTO     :=  SG1->G1_COMP
					SC6->C6_UM          :=  Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_UM")
					SC6->C6_FORMATO     :=  "1"
					SC6->C6_TES         :=  "600"
					SC6->C6_CF          :=  Posicione("SF4",1,xFilial("SF4")+"600","F4_CF")
					SC6->C6_QTDVEN      :=  Round(SC2->C2_QUANT,2)
					SC6->C6_PRCVEN      :=  SZC->ZC_PRECO
					SC6->C6_VALOR       :=  SC2->C2_QUANT * SZC->ZC_PRECO
					SC6->C6_LOCAL       :=  Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_LOCPAD")
					SC6->C6_CLI         :=  SZC->ZC_CLIENTE
					SC6->C6_ENTREG      :=  dDataBase
					SC6->C6_LOJA        :=  SZC->ZC_LOJA
					SC6->C6_NUM         :=  SC5->C5_NUM
					SC6->C6_DESCRI      :=  Alltrim(Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_DESC"))+" "+Alltrim(SG1->G1_COD)
					SC6->C6_GRADE       :=  "N"
					SC6->C6_CLASFIS     :=  "000"
					MsUnLock()
					
				EndIf
				*/
				
				//----> GRAVA O PEDIDO E O ITEM GERADO NA ORDEM DE PRODUCAO
				dbSelectArea("SC2")
				RecLock("SC2",.F.)
				SC2->C2_PV_TERC     :=  SC5->C5_NUM
				SC2->C2_IT_TERC     :=  SC6->C6_ITEM
				MsUnLock()
				
				MsgBox("Foi gerado o Pedido de Venda "+SC5->C5_NUM+". Favor avisar o pessoal da Expedicao.","Pedido de Venda Automatico Gerado","Info")
			Else
				MsgBox("O Pedido de Venda nao sera gerado devido ao produto "+Alltrim(SC2->C2_PRODUTO)+" nao estar cadastrado na Tabela de Precos de Terceiros.","Preco Nao Cadastrado","Stop")
			EndIf
		Else
			If MsgBox("Deseja mesmo complementar o Pedido de Venda "+SC5->C5_NUM+" para a Nota Fiscal de Terceiros "+SC2->C2_NF_TERC+" ?","Complemento de Pedido de Venda Automatico","YesNo")
				
				dbSelectArea("SC6")
				_aAreaSC6   :=  GetArea()
				dbSetOrder(2)
				If dbSeek(xFilial("SC6")+SC2->C2_PRODUTO+SC5->C5_NUM,.f.)
					
					dbSelectArea("SZC")
					_aAreaSZC   :=  GetArea()
					dbSetOrder(2)
					If dbSeek(xFilial("SZC")+SC2->C2_PRODUTO+SC2->C2_TIPO,.f.)
						
						dbSelectArea("SC6")
						_aAreaSC6   :=  GetArea()
						dbSetOrder(16)
						If dbSeek(xFilial("SC6")+SZC->ZC_CODMO+SC5->C5_NUM+"MO TING "+IIF(SZC->ZC_TIPCOB$"M","MT ","KG ")+ALLTRIM(SC2->C2_PRODUTO),.f.)
							
							//----> MAO DE OBRA
							dbSelectArea("SC6")
							RecLock("SC6",.f.)
							SC6->C6_QTDVEN      :=  Round(SC6->C6_QTDVEN + IIF(SZC->ZC_TIPCOB$"M",SC2->C2_QUANT,SC2->C2_QTSEGUM),2)
							SC6->C6_VALOR       :=  SC6->C6_QTDVEN * SZC->ZC_PRECO
							MsUnLock()
						EndIf
						
						dbSelectArea("SC6")
						_aAreaSC6   :=  GetArea()
						dbSetOrder(16)
						If dbSeek(xFilial("SC6")+SC2->C2_PRODUTO+SC5->C5_NUM,.f.)
							
							//----> PRODUTO BENEFICIADO
							dbSelectArea("SC6")
							RecLock("SC6",.f.)
							SC6->C6_QTDVEN      :=  Round(SC6->C6_QTDVEN + SC2->C2_QUANT,2)
							SC6->C6_VALOR       :=  SC6->C6_QTDVEN * SZC->ZC_PRECO
							MsUnLock()
						EndIf
						
						/*
						dbSelectArea("SG1")
						_aAreaSG1   :=  GetArea()
						dbSetOrder(1)
						If dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+Subs(SC2->C2_PRODUTO,1,3),.f.)
							
							dbSelectArea("SC6")
							_aAreaSC6   :=  GetArea()
							dbSetOrder(10)
							If dbSeek(xFilial("SC6")+SG1->G1_COMP+SC5->C5_NUM+Alltrim(Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_DESC"))+" "+Alltrim(SG1->G1_COD),.f.)
								
								//----> PODER DE TERCEIROS
								dbSelectArea("SC6")
								RecLock("SC6",.f.)
								SC6->C6_QTDVEN      :=  Round(SC6->C6_QTDVEN + SC2->C2_QUANT,2)
								SC6->C6_VALOR       :=  SC6->C6_QTDVEN * SZC->ZC_PRECO
								MsUnLock()
							EndIf
						EndIf
						*/
						
						//----> GRAVA O PEDIDO E O ITEM GERADO NA ORDEM DE PRODUCAO
						dbSelectArea("SC2")
						RecLock("SC2",.F.)
						SC2->C2_PV_TERC     :=  SC5->C5_NUM
						SC2->C2_IT_TERC     :=  SC6->C6_ITEM
						MsUnLock()
						
						MsgBox("O Pedido de Venda "+SC5->C5_NUM+" foi complementado com a confirmacao dessa Ordem de Producao.","Complemento de Pedido de Venda Automatico","Info")
					Else
						MsgBox("O Pedido de Venda nao sera atualizado com produto "+Alltrim(SC2->C2_PRODUTO)+" devido ao mesmo nao estar cadastrado na Tabela de Precos de Terceiros.","Preco Nao Cadastrado","Stop")
					EndIf
				Else
					dbSelectArea("SC6")
					_aAreaSC6   :=  GetArea()
					dbSetOrder(1)
					dbSeek(xFilial("SC6")+SC5->C5_NUM,.f.)
					While SC6->C6_NUM == SC5->C5_NUM
						_nItem  :=  Val(SC6->C6_ITEM)
						dbSkip()
					EndDo
					
					dbSelectArea("SZC")
					_aAreaSZC   :=  GetArea()
					dbSetOrder(2)
					If dbSeek(xFilial("SZC")+SC2->C2_PRODUTO+SC2->C2_TIPO,.f.)
						
						_nItem  :=  _nItem + 1
						
						//----> MAO DE OBRA
						dbSelectArea("SC6")
						RecLock("SC6",.t.)
						SC6->C6_FILIAL      :=  xFilial("SC6")
						SC6->C6_ITEM        :=  StrZero(_nItem,2)
						SC6->C6_PRODUTO     :=  SZC->ZC_CODMO
						SC6->C6_UM          :=  Posicione("SB1",1,xFilial("SB1")+SZC->ZC_CODMO,"B1_UM")
						SC6->C6_FORMATO     :=  "1"
						SC6->C6_TES         :=  SZC->ZC_TESMO
						SC6->C6_CF          :=  Posicione("SF4",1,xFilial("SF4")+SZC->ZC_TESMO,"F4_CF")
						SC6->C6_QTDVEN      :=  Round(IIF(SZC->ZC_TIPCOB$"M",SC2->C2_QUANT,SC2->C2_QTSEGUM),2)
						SC6->C6_PRCVEN      :=  SZC->ZC_PRECO
						SC6->C6_VALOR       :=  IIF(SZC->ZC_TIPCOB$"M",SC2->C2_QUANT * SZC->ZC_PRECO,SC2->C2_QTSEGUM * SZC->ZC_PRECO)
						SC6->C6_LOCAL       :=  Posicione("SB1",1,xFilial("SB1")+SZC->ZC_CODMO,"B1_LOCPAD")
						SC6->C6_CLI         :=  SZC->ZC_CLIENTE
						SC6->C6_ENTREG      :=  dDataBase
						SC6->C6_LOJA        :=  SZC->ZC_LOJA
						SC6->C6_NUM         :=  SC5->C5_NUM
						SC6->C6_DESCRI      :=  Alltrim(Posicione("SB1",1,xFilial("SB1")+SZC->ZC_CODMO,"B1_DESC"))+" "+Alltrim(SZC->ZC_CODPRO)
						SC6->C6_GRADE       :=  "N"
						SC6->C6_CLASFIS     :=  Posicione("SB1",1,xFilial("SB1")+SZC->ZC_CODMO,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+SZC->ZC_TESMO,"F4_SITTRIB")
						SC6->C6_FCICOD		:=	Posicione("CFD",2,xFilial("CFD")+SZC->ZC_CODMO,"CFD_FCICOD")
						MsUnLock()
						
						_nItem  :=  _nItem + 1
						
						//----> PRODUTO BENEFICIADO
						dbSelectArea("SC6")
						RecLock("SC6",.t.)
						SC6->C6_FILIAL      :=  xFilial("SC6")
						SC6->C6_ITEM        :=  StrZero(_nItem,2)
						SC6->C6_PRODUTO     :=  SC2->C2_PRODUTO
						SC6->C6_UM          :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_UM")
						SC6->C6_FORMATO     :=  "1"
						SC6->C6_TES         :=  SZC->ZC_TESRET
						SC6->C6_CF          :=  Posicione("SF4",1,xFilial("SF4")+SZC->ZC_TESRET,"F4_CF")
						SC6->C6_QTDVEN      :=  Round(SC2->C2_QUANT,2)
						SC6->C6_PRCVEN      :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_PRV1")
						SC6->C6_VALOR       :=  SC2->C2_QUANT * Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_PRV1")
						SC6->C6_LOCAL       :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_LOCPAD")
						SC6->C6_CLI         :=  SZC->ZC_CLIENTE
						SC6->C6_ENTREG      :=  dDataBase
						SC6->C6_LOJA        :=  SZC->ZC_LOJA
						SC6->C6_NUM         :=  SC5->C5_NUM
						SC6->C6_DESCRI      :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC")
						SC6->C6_GRADE       :=  "N"
						SC6->C6_CLASFIS     :=  Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+SZC->ZC_TESRET,"F4_SITTRIB")
						SC6->C6_FCICOD		:=	Posicione("CFD",2,xFilial("CFD")+SC2->C2_PRODUTO,"CFD_FCICOD")
						MsUnLock()
						
						/*
						
						_nItem  :=  _nItem + 1
						
						dbSelectArea("SG1")
						_aAreaSG1   :=  GetArea()
						dbSetOrder(1)
						If dbSeek(xFilial("SG1")+SC2->C2_PRODUTO+Subs(SC2->C2_PRODUTO,1,3),.f.)
							
							//----> PODER DE TERCEIROS
							dbSelectArea("SC6")
							RecLock("SC6",.t.)
							SC6->C6_FILIAL      :=  xFilial("SC6")
							SC6->C6_ITEM        :=  StrZero(_nItem,2)
							SC6->C6_PRODUTO     :=  SG1->G1_COMP
							SC6->C6_UM          :=  Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_UM")
							SC6->C6_FORMATO     :=  "1"
							SC6->C6_TES         :=  "600"
							SC6->C6_CF          :=  Posicione("SF4",1,xFilial("SF4")+"600","F4_CF")
							SC6->C6_QTDVEN      :=  Round(SC2->C2_QUANT,2)
							SC6->C6_PRCVEN      :=  SZC->ZC_PRECO
							SC6->C6_VALOR       :=  SC2->C2_QUANT * SZC->ZC_PRECO
							SC6->C6_LOCAL       :=  Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_LOCPAD")
							SC6->C6_CLI         :=  SZC->ZC_CLIENTE
							SC6->C6_ENTREG      :=  dDataBase
							SC6->C6_LOJA        :=  SZC->ZC_LOJA
							SC6->C6_NUM         :=  SC5->C5_NUM
							SC6->C6_DESCRI      :=  Alltrim(Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_DESC"))+" "+Alltrim(SG1->G1_COD)
							SC6->C6_GRADE       :=  "N"
							SC6->C6_CLASFIS     :=  "000"
							MsUnLock()
							
						EndIf
						*/
						
						//----> GRAVA O PEDIDO E O ITEM GERADO NA ORDEM DE PRODUCAO
						dbSelectArea("SC2")
						RecLock("SC2",.F.)
						SC2->C2_PV_TERC     :=  SC5->C5_NUM
						SC2->C2_IT_TERC     :=  SC6->C6_ITEM
						MsUnLock()
						
						MsgBox("O Pedido de Venda "+SC5->C5_NUM+" foi complementado com a confirmacao dessa Ordem de Producao.","Complemento de Pedido de Venda Automatico","Info")
					Else
						MsgBox("O Pedido de Venda nao sera atualizado com produto "+Alltrim(SC2->C2_PRODUTO)+" devido ao mesmo nao estar cadastrado na Tabela de Precos de Terceiros.","Preco Nao Cadastrado","Stop")
					EndIf
					
					MsgBox("Nao sera complementado Pedido de Venda.","Complemento de Pedido de Venda Automatico Cancelado","Stop")
				EndIf
			EndIf
		EndIf
	EndIf
EndIf   
//INCLUSÃO PARA FACILITAR AS ALTERAÇÕES DE OPS PREVISTA
If MsgYesNo("Deseja alterar as OP's Prevista?", "Atenção!")
	If C2_TPOP == 'F' .AND. INCLUI
		U_MTAPREVISTA()
	EndIf
EndIf


//----> RESTAURA AREA SC2
RestArea(_aAreaSC2)

//----> RESTAURA AREA SC5
RestArea(_aAreaSC5)

//----> RESTAURA AREA SC6
RestArea(_aAreaSC6)

//----> RESTAURA AREA SZC
RestArea(_aAreaSZC)

//----> RESTAURA AREA ANTERIOR
RestArea(_aAreaANT)

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*


