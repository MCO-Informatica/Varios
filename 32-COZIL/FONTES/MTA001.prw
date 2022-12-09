#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA001    ºAutor  ³Carlos E. Saturnino º Data ³  12/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tem a finalidade de validar o NCM digitado para o Item da   º±±
±±º          ³Pre Nota de entrada, e inclui-lo via execauto na tabela de  º±±
±±º          ³Produtos (SB1)											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cozil                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MTA001()

Local	lRet   	:= .T.
Local	cAlias 	:= Alias()
Local	aDados	:= {}
Local	nOpcao	:= 4		// 3 - Inclusao, 4 - Alteracao
Local	cCodigo	:= ""
Local	cNCM	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Guardo o conteudo do campo D1_COD em variavel							   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCodigo	:= aCols[n][aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_COD" })]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valido o Conteúdo do campo D1_NCM										   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	aCols[n][aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_NCM" })] == ""
	cNCM	:= M->D1_NCM
Else
	cNCM	:= aCols[n][aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_NCM" })]
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Guardo o conteudo da Tabela SB1 no Array com a estrutura necessaria para ExecAuto   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)
If MsSeek( xFilial("SB1") + cCodigo )
	aDados := {	{ "B1_COD"		,SB1->B1_COD		,Nil},; 		//Codigo
				{ "B1_DESC"		,SB1->B1_DESC		,Nil},;        	//Descricao
				{ "B1_POSIPI"	,cNCM				,Nil},;        //Pos.IPI/NCM
				{ "B1_TIPO"		,SB1->B1_TIPO		,Nil},;        	//Tipo
				{ "B1_UM"		,SB1->B1_UM			,Nil},;        	//Unidade
				{ "B1_LOCPAD"	,SB1->B1_LOCPAD		,Nil},;        	//Armazem Pad.
				{ "B1_GRUPO"	,SB1->B1_GRUPO		,Nil},;         //Grupo
				{ "B1_MSBLQL"	,SB1->B1_MSBLQL		,Nil},;         //Bloqueado
				{ "B1_TE"		,SB1->B1_TE			,Nil},;         //TE Padrao
				{ "B1_TS"		,SB1->B1_TS			,Nil},;         //TS Padrao
				{ "B1_SEGUM"	,SB1->B1_SEGUM		,Nil},;         //Seg.Un.Medi.
				{ "B1_CONV"		,SB1->B1_CONV		,Nil},;         //Fator Conv.
				{ "B1_ALTER"	,SB1->B1_ALTER		,Nil},;         //Alternativo
				{ "B1_PRV1"		,SB1->B1_PRV1		,Nil},;         //Preco Venda
				{ "B1_CUSTD"	,SB1->B1_CUSTD		,Nil},;         //Custo Stand.
				{ "B1_UCALSTD"	,SB1->B1_UCALSTD	,Nil},;         //Ult. Calculo
				{ "B1_UPRC"		,SB1->B1_UPRC		,Nil},;         //Ult. Preco
				{ "B1_UCOM"		,SB1->B1_UCOM		,Nil},;         //Ult. Compra
				{ "B1_PESO"		,SB1->B1_PESO		,Nil},;         //Peso Liquid
				{ "B1_CONTA"	,SB1->B1_CONTA		,Nil},;         //Cta Contabil
				{ "B1_CC"		,SB1->B1_CC			,Nil},;         //Centro Custo
				{ "B1_ITEMCC"	,SB1->B1_ITEMCC		,Nil},;         //Item Conta
				{ "B1_FAMILIA"	,SB1->B1_FAMILIA	,Nil},;         //Familia
				{ "B1_PROC"		,SB1->B1_PROC		,Nil},;         //Forn. Padrao
				{ "B1_QB"		,SB1->B1_QB			,Nil},;         //Base Estrut.
				{ "B1_LOJPROC"	,SB1->B1_LOJPROC	,Nil},;         //Loja Padrao
				{ "B1_FANTASM"	,SB1->B1_FANTASM	,Nil},;         //Fantasma
   				{ "B1_RASTRO"	,SB1->B1_RASTRO		,Nil},;         //Rastro
				{ "B1_FORAEST"	,SB1->B1_FORAEST	,Nil},;         //Fora estado
				{ "B1_COMIS"	,SB1->B1_COMIS		,Nil},;         //% Comissao
				{ "B1_MONO"		,SB1->B1_MONO		,Nil},;         //Forn. Canal
				{ "B1_PERINV"	,SB1->B1_PERINV		,Nil},;         //Per.Invent.
				{ "B1_DTREFP1"	,SB1->B1_DTREFP1	,Nil},;         //Dt.Ref.Prc 1
				{ "B1_CONINI"	,SB1->B1_CONINI		,Nil},;         //Cons.Inicial
				{ "B1_CODBAR"	,SB1->B1_CODBAR		,Nil},;         //Cod Barras
				{ "B1_FORMLOT"	,SB1->B1_FORMLOT	,Nil},;         //Cod Form Lot
				{ "B1_GRUPCOM"	,SB1->B1_GRUPCOM	,Nil},;         //Gr. Compras
				{ "B1_REVATU"	,SB1->B1_REVATU		,Nil},;         //Rev.Estrutur
				{ "B1_CLVL"		,SB1->B1_CLVL		,Nil},;         //Classe Valor
				{ "B1_EX_NCM"	,SB1->B1_EX_NCM		,Nil},;         //Ex-NCM
				{ "B1_EX_NBM"	,SB1->B1_EX_NBM		,Nil},;         //Ex-NBM
				{ "B1_ALIQISS"	,SB1->B1_ALIQISS	,Nil},;         //Aliq. ISS
				{ "B1_CODISS"	,SB1->B1_CODISS		,Nil},;         //Cod.Serv.ISS
				{ "B1_PICMRET"	,SB1->B1_PICMRET	,Nil},;         //Solid. Saida
				{ "B1_PICMENT"	,SB1->B1_PICMENT	,Nil},;         //Solid. Entr.
				{ "B1_IMPZFRC"	,SB1->B1_IMPZFRC	,Nil},;         //Imp.Z.Franca
				{ "B1_ORIGEM"	,SB1->B1_ORIGEM		,Nil},;         //Origem
				{ "B1_CLASFIS"	,SB1->B1_CLASFIS	,Nil},;         //Class.Fiscal
				{ "B1_GRTRIB"	,SB1->B1_GRTRIB		,Nil},;         //Grupo Trib.
				{ "B1_CONTSOC"	,SB1->B1_CONTSOC	,Nil},;         //Cont.Seg.Soc
				{ "B1_IRRF"		,SB1->B1_IRRF		,Nil},;         //Impos.Renda
				{ "B1_REDINSS"	,SB1->B1_REDINSS	,Nil},;         //% Red. INSS
				{ "B1_REDIRRF"	,SB1->B1_REDIRRF	,Nil},;         //% Red. IRRF
				{ "B1_TAB_IPI"	,SB1->B1_TAB_IPI	,Nil},;         //IPI de Pauta
				{ "B1_PCSLL"	,SB1->B1_PCSLL		,Nil},;         //Perc. CSLL
				{ "B1_PCOFINS"	,SB1->B1_PCOFINS	,Nil},;         //Perc. COFINS
				{ "B1_PPIS"		,SB1->B1_PPIS		,Nil},;         //Perc. PIS
				{ "B1_VLR_IPI"	,SB1->B1_VLR_IPI	,Nil},;   	     //IPI de Pauta
				{ "B1_VLR_ICM"	,SB1->B1_VLR_ICM	,Nil},;         //Icms Pauta
				{ "B1_INT_ICM"	,SB1->B1_INT_ICM	,Nil},;         //P.ICMS Prop.
				{ "B1_VLR_PIS"	,SB1->B1_VLR_PIS	,Nil},;         //Pis Pauta
				{ "B1_VLR_COF"	,SB1->B1_VLR_COF	,Nil},;         //COFINS Pauta
				{ "B1_QE"		,SB1->B1_QE			,Nil},;         //Qtd.Embalag.
				{ "B1_EMIN"		,SB1->B1_EMIN		,Nil},;         //Ponto Pedido
				{ "B1_ESTSEG"	,SB1->B1_ESTSEG		,Nil},;         //Seguranca
				{ "B1_ESTFOR"	,SB1->B1_ESTFOR		,Nil},;         //Form.Est.Seg
				{ "B1_FORPRZ"	,SB1->B1_FORPRZ		,Nil},;         //Form. Prazo
				{ "B1_PE"		,SB1->B1_PE			,Nil},;         //Entrega
				{ "B1_TIPE"		,SB1->B1_TIPE		,Nil},;         //Tipo Prazo
				{ "B1_LE"		,SB1->B1_LE			,Nil},;         //Lote Econom.
				{ "B1_LM"		,SB1->B1_LM			,Nil},;         //Lote Minimo
				{ "B1_TOLER"	,SB1->B1_TOLER		,Nil},;         //Tolerancia
				{ "B1_TIPODEC"	,SB1->B1_TIPODEC	,Nil},;         //Tipo Dec. OP
				{ "B1_MRP"		,SB1->B1_MRP		,Nil},;         //Entra MRP
				{ "B1_PRVALID"	,SB1->B1_PRVALID	,Nil},;         //Prazo Valid.
				{ "B1_EMAX"		,SB1->B1_EMAX		,Nil},;         //Estoq Maximo
				{ "B1_NOTAMIN"	,SB1->B1_NOTAMIN	,Nil},;         //Nota Minima
				{ "B1_NUMCQPR"	,SB1->B1_NUMCQPR	,Nil},;         //Produ??es CQ
				{ "B1_BITMAP"	,SB1->B1_BITMAP		,Nil},;         //Foto
				{ "B1_SERIE"	,SB1->B1_SERIE		,Nil},;         //Serie/Colec.
				{ "B1_FABRIC"	,SB1->B1_FABRIC		,Nil},;         //Fabricante
				{ "B1_REDPIS"	,SB1->B1_REDPIS		,Nil},;         //%Red.PIS
				{ "B1_REDCOF"	,SB1->B1_REDCOF		,Nil},;         //% Red.COFINS
				{ "B1_DATASUB"	,SB1->B1_DATASUB	,Nil},;         //Data Substit
				{ "B1_PESBRU"	,SB1->B1_PESBRU		,Nil},;         //Peso Bruto
				{ "B1_TIPCAR"	,SB1->B1_TIPCAR		,Nil},;         //Tipo Carga
				{ "B1_FRACPER"	,SB1->B1_FRACPER	,Nil},;         //Frac Permit
				{ "B1_LOTVEN"	,SB1->B1_LOTVEN		,Nil},;         //Qtde Venda
				{ "B1_GCCUSTO"	,SB1->B1_GCCUSTO	,Nil},;         //Gr Cnt Custo
				{ "B1_CCCUSTO"	,SB1->B1_CCCUSTO	,Nil},;         //CC p/ Custo
				{ "B1_CNAE"		,SB1->B1_CNAE		,Nil}		}   //CNAE
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executo a inclusao do Registro via MsExecAuto				   		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aDados) > 0
		MsExecAuto( { |X,Y|mata010 ( x,y ) }, aDados , nOpcao )
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Zera o Array com os dados.			                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aDados := {}
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava arquivo SB1ERRO.LOG no diretorio \SYSTEM\IMPORTACAO\ERROS\    		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MostraErro('SYSTEM\IMPORTACAO','SB1ERRO.LOG')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fecha Tabela em uso e reinicializa area anteriorVariaveis				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SB1->(dbCloseArea())
DbSelectArea( cAlias )

Return( )