#Include "Protheus.ch"
#Include "Rwmake.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณMFat07    บAutor: ณDouglas Mello          บData: ณ16/12/2009 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณDemonstrativo de Vendas p/ o dpto. Marketing.                บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function MFat07()

	Local cDesc1      	:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Demonstrativo de Vendas"
	Local cPict          := ""
	Local titulo       	:= "Demonstrativo de Vendas"
	Local nLin        	:= 80
	Local Cabec1      	:= "MES      CANAL          PRODUTO          DESCRICAO         SEGMENTO                        CLI/LOJA   NOME                 QTD VEND1   NOME1             VEND2     NOME2   NF/ITEM    BPAG       AR      VALOR    EMISSAO "
	Local Cabec2			:= "INFO. PROD. GAR"
	Local imprime     	:= .T.
	Local aOrd 			:= {}
	
	Private lEnd        	:= .F.
	Private lAbortPrint 	:= .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "MFAT07"
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1 }
	Private nLastKey     := 0
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "MFAT07"
	Private cString 		:= ""
	Private cPerg			:= "MFAT07A"
	
	//ValidPerg()
	CriaSx1( cPerg )
		
	//AjustaSX1()
	If !Pergunte(cPerg,.T.)
		Return
	Else
	
		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
		If nLastKey == 27
			Return
		Endif
	
		SetDefault(aReturn,cString)
	
		If nLastKey == 27
			Return
		Endif
	
		nTipo := If(aReturn[4]==1,15,18)
	
		RptStatus( {|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo )
	
	EndIf

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณRunReport บAutor: ณDouglas Mello          บData: ณ16/12/2009 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณFuncao auxiliar chamada pela RPTSTATUS. A funcao.            บฑฑ
ฑฑบ           ณRPTSTATUS monta a janela com a regua de processamento.       บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem
	Local _nI     		:= 0
	Local _cTes   		:= ""
	Local _aTes   		:= {}
	Local aCanal  		:= {}
	Local cCanal  		:= ''
	Local cSQL    		:= ''
	Local cTpRece 		:= ""
	Local cLicit  		:= ""
	Local cCnaeDesc		:= ""
	Local cCnaeNAmig	:= ""
	Local cXCAMIG		:= ""
	Local aOrigPV 		:= strtokarr( U_CSC5XBOX() ,';')
	Local nPos	  		:= 0
	Local cORIGPV 		:= ''
	Local nCnt 			:= 0
	Local nStart 		:= 0
	Local nEnd 			:= 0
	Local cNome1 		:= ""
	Local cNome2 		:= ""
	Local cNOME_AR 		:= ""
	Local cGrp_Cliente 	:= ""
	Local cCodigo_AR 	:= ""
	Local cDescricao_AR := ""
	Local cCodPosto 	:= ""
	Local cDescPosto 	:= ""
	Local cOportunidade	:= ""
	Local cCod_Parceiro := ""
	Local cVendCodRev	:= ""
	Local cVendNom 		:= ""
	Local cCodUnNeg     := ""
	Local cDesUnNeg     := ""
	Local nTotalFrete	:= 0
	Local nParcFrete	:= 0
	Local nNumItens		:= 0	
	Local nParcDesp		:= 0
	Local nTotalDesp	:= 0
	Local nTotalAcu		:= 0
	
	If !Empty(mv_par09)
		_aTes := StrToArray(Alltrim(mv_par09),";")
		_cTes := "("
	
		For _nI := 1 To Len(_aTes)
		
		
			If !Empty(_aTes[_nI])
				_cTes += "'" + _aTes[_nI] + "'"
				If _nI <> Len(_aTes)
					_cTes += ","
				EndIf
			EndIf
		Next _nI
		
		_cTes += ")"
	Endif
	
	IF .NOT. Empty( MV_par16 )
		aCanal := StrToArray( RTrim(Mv_par16), ';' )
		cCanal := "("
		
		For _nI := 1 To Len( aCanal )
			IF .NOT. Empty( aCanal[_nI] )
				cCanal += "'" + aCanal[_nI] + "'"
				IF _nI <> Len( aCanal )
					cCanal += ","
				EndIF
			EndIF
		Next _nI
		
		cCanal += ")"
	EndIF
	
	cSQL += "SELECT SD2.d2_filial                     AS Filial," 											+ CRLF
	cSQL += "       Substr(SD2.d2_emissao, 5, 2)" 															+ CRLF
	cSQL += "       || '/'" 																				+ CRLF
	cSQL += "       || Substr(SD2.d2_emissao, 1, 4)   AS Mes," 												+ CRLF
	cSQL += "       SZ2.z2_canal                      AS Canal," 											+ CRLF
	cSQL += "       SC5.c5_xnature                    AS Natureza," 										+ CRLF
	cSQL += "       SD2.d2_cod                        AS Produto," 											+ CRLF
	cSQL += "       SB1.b1_cod                        AS Cod_Prod," 										+ CRLF
	cSQL += "       SB1.b1_desc                       AS Descricao," 										+ CRLF
	cSQL += "       SZ1.z1_descseg                    AS Segmento," 										+ CRLF
	cSQL += "       SD2.d2_cliente                    AS Cliente," 											+ CRLF
	cSQL += "       SD2.d2_loja                       AS Loja," 											+ CRLF
	cSQL += "       SA1.a1_nome                       AS Nome," 											+ CRLF
	cSQL += "       SD2.d2_quant                      AS Quantidade," 										+ CRLF
	cSQL += "       SF2.f2_vend1                      AS Cod_Vend1," 										+ CRLF
	cSQL += "       SF2.f2_vend2                      AS Cod_Vend2," 										+ CRLF
	cSQL += "       SD2.d2_doc                        AS Nota_Fiscal," 										+ CRLF
	cSQL += "       SD2.d2_item                       AS Item_Nota," 										+ CRLF
	cSQL += "       SC5.c5_emissao                    AS Emissao_Pedido," 									+ CRLF
	cSQL += "       SC5.c5_chvbpag                    AS Numero_BPAG," 										+ CRLF
	cSQL += "       SC5.c5_num                        AS Numero_Pedido," 									+ CRLF
	cSQL += "       SC5.c5_ar                         AS Ar," 												+ CRLF
	cSQL += "       Cast (d2_total AS NUMBER(13, 2))  AS Valor_Unit," 										+ CRLF
	cSQL += "       SC5.c5_despesa                    AS Despesa," 											+ CRLF
	cSQL += "       SF2.F2_FRETE                      AS Frete," 											+ CRLF
	cSQL += "       SC5.c5_xcodlic                    AS Licitacao," 										+ CRLF
	cSQL += "       SC5.c5_tprece                     AS Tipo_Receita,"										+ CRLF
	cSQL += "       SC5.c5_mdempe                     AS Cod_Empen,"										+ CRLF
	cSQL += "       SC5.c5_xdtslft                    AS Dt_Solicitacao,"									+ CRLF
	//cSQL += "       ( SD2.d2_total + SC5.c5_despesa + SC5.c5_frete ) AS Valor_Total," 					+ CRLF
	cSQL += "       SD2.d2_total 					  AS Valor_Total,"					 					+ CRLF
	cSQL += "       SD2.d2_emissao                    AS Emissao," 											+ CRLF
	cSQL += "       SD2.d2_tes                        AS TES," 												+ CRLF
	cSQL += "       SA1.a1_pessoa                     AS Fisico_Jur," 										+ CRLF
	cSQL += "       SA1.a1_nreduz                     AS Nome_Reduz," 										+ CRLF
	cSQL += "       SA1.a1_tipo                       AS Tipo," 											+ CRLF
	cSQL += "       SA1.a1_cep                        AS Cep," 												+ CRLF
	cSQL += "       SA1.a1_end                        AS Endereco," 										+ CRLF
	cSQL += "       SA1.a1_est                        AS Estado," 											+ CRLF
	cSQL += "       SA1.a1_cod_mun                    AS Cod_Mun," 											+ CRLF
	cSQL += "       SA1.a1_mun                        AS Municipio," 										+ CRLF
	cSQL += "       SA1.a1_bairro                     AS Bairro," 											+ CRLF
	cSQL += "       SA1.a1_ddd                        AS DDD," 												+ CRLF
	cSQL += "       SA1.a1_tel                        AS Tel," 												+ CRLF
	cSQL += "       SA1.a1_contato                    AS Contato," 											+ CRLF
	cSQL += "       SA1.a1_email                      AS Email," 											+ CRLF
	cSQL += "       SA1.a1_cgc                        AS CPF_CNPJ," 										+ CRLF
	cSQL += "       SA1.a1_cnae                       AS CNAE," 											+ CRLF
	cSQL += "       SA1.a1_grpven                     AS Grp_Cliente," 										+ CRLF
	cSQL += "       SA1.a1_tpessoa                    AS Tipo_Pessoa," 										+ CRLF
	cSQL += "       SC5.C5_XORIGPV                    AS C5_XORIGPV," 										+ CRLF
	cSQL += "       ACU.ACU_DESC					  AS Categoria,"										+ CRLF	
	cSQL += "       SC5.C5_XCODREV					  AS Cod_Rev"											+ CRLF	
	cSQL += "FROM   " + RetSQLName("SD2") + " SD2" 															+ CRLF
	cSQL += "       INNER JOIN " + RetSQLName("SF2") + " SF2" 												+ CRLF
	cSQL += "              ON SF2.d_e_l_e_t_ = ' '" 														+ CRLF
	cSQL += "                 AND SF2.f2_filial = SD2.d2_filial" 											+ CRLF
	cSQL += "                 AND SF2.f2_doc = SD2.d2_doc" 													+ CRLF
	cSQL += "                 AND SF2.f2_serie = SD2.d2_serie" 												+ CRLF
	cSQL += "                 AND SF2.f2_cliente = SD2.d2_cliente" 											+ CRLF
	cSQL += "                 AND SF2.f2_vend1 >= '" + mv_par05 + "'" 										+ CRLF 
	cSQL += "                 AND SF2.f2_vend1 <= '" + mv_par06 + "'" 										+ CRLF 
	cSQL += "       INNER JOIN " + RetSQLName("SC5") + " SC5" 												+ CRLF
	cSQL += "              ON SC5.d_e_l_e_t_ = ' '" 														+ CRLF
	//cSQL += "                 AND SC5.c5_filial = '"+xFilial("SC5")+"'"									+ CRLF
	cSQL += "                 AND SC5.c5_num = SD2.d2_pedido" 												+ CRLF
	cSQL += "                 AND SC5.c5_xnature >= '" + mv_par07 + "'" 									+ CRLF 
	cSQL += "                 AND SC5.c5_xnature <= '" + mv_par08 + "'" 									+ CRLF 
	cSQL += "       INNER JOIN " + RetSQLName("SA3") + " SA3" 												+ CRLF
	cSQL += "              ON SA3.d_e_l_e_t_ = ' '" 														+ CRLF
	cSQL += "                 AND SA3.a3_filial = '" + xFilial("SA3") + "'" 								+ CRLF
	cSQL += "                 AND SA3.a3_cod = SF2.f2_vend1" 												+ CRLF
	cSQL += "       INNER JOIN " + RetSQLName("SZ2") + " SZ2" 												+ CRLF
	cSQL += "              ON SZ2.d_e_l_e_t_ = ' '" 														+ CRLF
	cSQL += "                 AND SZ2.z2_filial = '" + xFilial("SZ2") + "'" 								+ CRLF
	cSQL += "                 AND SZ2.z2_codigo = SA3.a3_xcanal" 											+ CRLF
	
	IF .NOT. Empty( MV_par16 )
		cSQL += "                 AND SZ2.z2_codigo IN " + cCanal   + "" 									+ CRLF
	EndIF
	
	cSQL += "       LEFT JOIN " + RetSQLName("SB1") + " SB1 " 												+ CRLF
	cSQL += "              ON SB1.d_e_l_e_t_ = ' '" 														+ CRLF
	cSQL += "                 AND SB1.b1_filial = SD2.d2_filial " 											+ CRLF
	cSQL += "                 AND SB1.b1_cod = SD2.d2_cod" 													+ CRLF
	cSQL += "       INNER JOIN " + RetSQLName("SA1") + " SA1 " 												+ CRLF
	cSQL += "              ON SA1.d_e_l_e_t_ = ' '" 														+ CRLF
	cSQL += "                 AND SA1.a1_filial = '" + xFilial("SA1") + "'" 								+ CRLF
	cSQL += "                 AND SA1.a1_cod = SD2.d2_cliente" 												+ CRLF
	cSQL += "                 AND SA1.a1_loja = SD2.d2_loja" 												+ CRLF
	cSQL += "       LEFT JOIN " + RetSQLName("SZ1") + " SZ1 " 												+ CRLF
	cSQL += "              ON SZ1.d_e_l_e_t_ = ' '" 														+ CRLF
	cSQL += "                 AND SZ1.z1_filial = '" + xFilial("SZ1") + "'" 								+ CRLF
	cSQL += "                 AND SZ1.z1_codseg = SB1.b1_xseg" 												+ CRLF
	cSQL += "       LEFT JOIN " + RetSQLName("ACV") + " ACV " 												+ CRLF
	cSQL += "              ON ACV.d_e_l_e_t_ = ' '" 														+ CRLF
	cSQL += "                 AND ACV.ACV_FILIAL = '" + xFilial("ACV") + "'"								+ CRLF
	cSQL += "                 AND ACV.ACV_CODPRO = SD2.D2_COD"												+ CRLF	
	cSQL += "       LEFT JOIN " + RetSQLName("ACU") + " ACU " 												+ CRLF
	cSQL += "              ON ACU.d_e_l_e_t_ = ' '" 														+ CRLF
	cSQL += "                 AND ACU.ACU_FILIAL = ACV.ACV_FILIAL " 										+ CRLF
	cSQL += "              	  AND ACU.ACU_COD = ACV.ACV_CATEGO  " 											+ CRLF				
	cSQL += "WHERE  SD2.D_E_L_E_T_= ' '" 																	+ CRLF
	
	If mv_par13 == 1
		cSQL += "		AND SD2.d2_filial  >= '" + mv_par14 + "' AND SD2.d2_filial <= '" + mv_par15 + "'"	+ CRLF
	Else
		cSQL += "		AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'" 										+ CRLF
	EndIf
	
	cSQL += "       AND SD2.d2_emissao >= '" + DtoS(mv_par01) + "'" 										+ CRLF
	cSQL += "       AND SD2.d2_emissao <= '" + DtoS(mv_par02) + "'" 										+ CRLF
	cSQL += "       AND SD2.d2_cod     >= '" + mv_par03       + "'" 										+ CRLF
	cSQL += "       AND SD2.d2_cod     <= '" + mv_par04       + "'" 										+ CRLF
	
	IF .NOT. Empty( MV_par09 )
		cSQL += "       AND SD2.d2_tes     IN " + _cTes        + "" 										+ CRLF
	EndIF
	
	cSQL += "       AND SD2.d2_cliente >= '" + mv_par11       + "'" 										+ CRLF
	cSQL += "       AND SD2.d2_cliente <= '" + mv_par12       + "'" 										+ CRLF
	cSQL += "ORDER  BY mes,"         																		+ CRLF
	cSQL += "          SD2.d2_doc,"  																		+ CRLF
	cSQL += "          SA3.a3_nome," 																		+ CRLF
	cSQL += "          SD2.d2_item," 																		+ CRLF
	cSQL += "          segmento,"  																			+ CRLF
	cSQL += "          canal"        																		+ CRLF
	
	If Select("TRC") > 0
		TRC->(DbCloseArea())
	EndIf
	nStart := Seconds()
	MsgRun("Executando pesquisa dos dados. Por favor, aguarde.","Demonstrativo de Vendas",{||dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), "TRC", .T., .T.)})
	nEnd := Seconds()
	
	Count To nCnt
	
	//Alert("Query: " + cValToChar((nEnd-nStart)/60))
	
	//MemoWrite("C:\Data\MFAT07.sql",cSQL)
	
	_cDataBase 	:= dDataBase
	_cTime 		:= Time()
	_aCabec 		:= {}
	_aDados		:= {}
	
	AAdd( _aDados, {	"FILIAL"				,;
						"MES"					,;
						"CANAL"					,;
						"NATUREZA"				,;
						"PRODUTO"				,;
						"DESCRICAO"				,;
						"SEGMENTO"				,;
						"CLI/LOJA"				,;
						"NOME"					,;
						"QTD"					,;
						"VEND1"					,;
						"NOME VEND1"			,;
						"VEND2"					,;
						"NOME VEND2"			,;
						"NF/ITEM"				,;
						"BPAG"					,;
						"NUMERO PEDIDO"			,;
						"VALOR UNIT"			,;
						"DESPESA"				,;
						"FRETE"					,;
						"VALOR"					,;
						"EMISSAO"				,;
						"TES"					,;
						"FISICO JUR"			,;
						"NOME REDUZ"			,;
						"TIPO"					,;
						"CEP"					,;
						"ENDERECO"				,;
						"ESTADO"				,;
						"COD MUN"				,;
						"MUNICIPIO"				,;
						"BAIRRO"				,;
						"DDD"					,;
						"TEL"					,;
						"CONTATO"				,;
						"EMAIL"					,;
						"CPF CNPJ"				,;
						"CNAE"					,;
						"DENOMINAวรO"			,;
						"NOME AMIGAVEL"			,;
						"Emissao Pedido"		,;
						"AR"					,;
						"NOME AR"				,;
						"GRP CLIENTE"			,;
						"CODIGO AR"				,;
						"DESCRIวรO AR"			,;
						"CODIGO DO POSTO"		,;
						"DESCRIวรO DO POSTO"	,;
						"NUMERO OPORTUNIDADE"	,;
						"INFO PROD GAR"         ,;
						"LICITAวรO"				,;
						"TIPO RECEITA"			,;
						"COD EMPENHO"			,;
						"DATA SOLICITACAO"		,;
						"ORIGEM PV"				,;
						"UNID. NEG."			,;
						"Cod_Rev"				,;
						"Vend_GC"				,;
						"Nome_GC"               ,;
						"COD UNID. NEG."        ,;
						"UNID. NEG."			,;
						"TIPO PESSOA"})
						
	AAdd(_aDados, {})
	
	//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	
	SetRegua(nCnt)
	
	nStart := Seconds()
	MsgRun("Reposicionando tabela. Aguarde.","Demonstrativo de Vendas",{|| TRC->(dbGoTop()) })
	nEnd := Seconds()
	
	IF TRC->( EOF() )
		MsgAlert('Nใo hแ dados para impressใo, por favor verifique os parโmetros informados.','Demonstrativo de Vendas')
		Return
	EndIF
	
	MsgRun("Abrindo tabelas para processamento. Por favor, aguarde.","Demonstrativo de Vendas",{||LoadTables()})
	
	nStart := Seconds()
	
	dbSelectArea("ACV")
	dbSetOrder(5)
	
	While !TRC->(Eof())
	
		IncRegua()
		ProcessMessage()
		
		nParcFrete 	:= 0
		nTotalFrete	:= 0
		nNumItens 	:= 0
			
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
	
		//-- Vendedor
		If SA3->(DbSeek(xFilial("SA3")+TRC->Cod_Vend1))
			cNome1 := SA3->A3_NOME
		Else
			cNome1 := ""
		EndIf
	
		If SA3->(DbSeek(xFilial("SA3")+TRC->Cod_Vend2))
			cNome2 := SA3->A3_NOME
		Else
			cNome2 := ""
		EndIf
	
		//-- Descri็ใo AR
		If SZ3->(DbSeek(xFilial("SZ3")+TRC->Ar))
			cNOME_AR := SZ3->Z3_DESENT
		Else
			cNOME_AR := ""
		EndIf
	
		//-- Desri็ใo Grupo do Cliente
		If ACY->(DbSeek(xFilial("ACY")+TRC->Grp_Cliente))
			cGrp_Cliente := ACY->ACY_DESCRI
		Else
			cGrp_Cliente := ""
		EndIf
	
		//-- Informa็๕es do Grupo
		If SZ5->(DbSeek(xFilial("SZ5")+TRC->Numero_BPAG))
			cCodigo_AR		:= SZ5->Z5_CODAR
			cDescricao_AR	:= SZ5->Z5_DESCAR
			cCodPosto		:= SZ5->Z5_CODPOS
			cDescPosto		:= SZ5->Z5_DESPOS
			cCod_Parceiro	:= SZ5->Z5_CODVEND
		Else
			cCodigo_AR		:= ""
			cDescricao_AR	:= ""
			cCodPosto		:= ""
			cDescPosto		:= ""
		EndIf
		
		//Tratamento para Z3_CODREV com mais de um c๓digo
		SZ3->(dbOrderNickname("REVENDEDOR"))
		If !SZ3->(dbSeek(xFilial("SZ3")+TRC->Cod_Rev))
		
			If Select("TMPCODREV") > 0
				TMPCODREV->(dbCloseArea())
			EndIf
			
			cQryCodRev := "SELECT R_E_C_N_O_ RECNOZ3 FROM SZ3010 WHERE Z3_CODREV LIKE '%" + AllTrim(TRC->Cod_Rev) + "%' AND D_E_L_E_T_ = ' '"
			dbUseArea(.T., "TOPCONN", tcGenQry(,,cQryCodRev), "TMPCODREV", .T., .T.)
			
			If TMPCODREV->(!EoF())
				SZ3->(dbGoTo(TMPCODREV->RECNOZ3))
			EndIf
			
			TMPCODREV->(dbCloseArea())
		EndIf
		
		//-- Localiza informa็๕es da Revenda
		If SZ3->(!EoF())
			If SZ3->Z3_TIPENT == "7"
				cVendCodRev := SZ3->Z3_VEND1
				
				If SA3->(dbSeek(xFilial("SA3")+cVendCodRev))
					cVendNom := SA3->A3_NOME
				EndIf			
			EndIf
		Else
			cVendCodRev 	:= ""
			cVendNom 		:= ""
			cCod_Parceiro	:= ""
		EndIf
	
		//-- Oportunidade
		If SC6->(DbSeek(xFilial("SC6")+TRC->Numero_Pedido))
			cOportunidade := ""
			While !SC6->(EoF()) .AND. SC6->C6_NUM == TRC->Numero_Pedido
				If !Empty(SC6->C6_NROPOR)
					cOportunidade := SC6->C6_NROPOR
				EndIf
				//nNumItens++
				SC6->(DbSkip())
			EndDo
		Else
			cOportunidade := ""
		Endif
		
		//-- Unidade de Negocio.
		If ACV->( DbSeek( xFilial("ACV") + TRC->Cod_Prod ) )
			cCodUnNeg := ACV->ACV_CATEGO
			cDesUnNeg := Posicione("ACU", 1, xFilial("ACU") + cCodUnNeg, "ACU_DESC")
		Else
			cCodUnNeg := ""
			cDesUnNeg := ""
		Endif

		//-> Verifica se o cliente ้ publico ou privado.
		cPublPriv := ""
		If !Empty(TRC->Tipo_Pessoa)
			If AllTrim(TRC->Tipo_Pessoa) == "EP"
				cPublPriv := "Publico"
			Else
				cPublPriv := "Privado"
			EndIf			
		EndIf
		
		//Alert("Numero de Itens: " + cValToChar(nNumItens))
		
		//-- Tratamento de Frete
		//nTotalFrete := TRC->Frete
		
		//Alert("Total Frete: " + cValToChar(nTotalFrete))
		
		/*If nNumItens > 1 .And. nTotalFrete > 0
			nParcFrete := nTotalFrete / nNumItens
			Alert("nParcFrete (dividido): " + cValToChar(nParcFrete))
		Else
			nParcFrete := nTotalFrete
			Alert("nParcFrete (full): " + cValToChar(nParcFrete))
		EndIf*/
		
		//-- Tratamento de Despesas
		nTotalDesp := TRC->Despesa
		
		If nNumItens > 1 .And. nTotalDesp > 0
			nParcDesp := nTotalDesp / nNumItens
		Else
			nParcDesp := nTotalDesp
		EndIf
		
		If SZY->(DbSeek(xFilial("SZY")+TRC->Licitacao))
			cLicit := SZY->ZY_NOMELIC
		Else
			cLicit := ""
		Endif
		
		//-- Calcula total acumulado com Despesas e Frete
		nTotalAcu := nParcDesp + TRC->Frete + TRC->Valor_Total
		
		cImprTela := ""
	
		If nLin > 55 //-- Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		If TRC->Tipo_Receita == "1"
			cTpRece := "Nova"                                                                                       
		ElseIf TRC->Tipo_Receita == "2"
			cTpRece := "Recorrente"
		ElseIf TRC->Tipo_Receita == "3"  
			cTpRece := "Projetos Especiais"
		Else
			cTpRece := " "
		EndIf
		
		//-- Inclusใo da descri็ใo amigavel CNAE.
		cCnaeDesc  := ""
		cCnaeNAmig := ""
		If !Empty(TRC->CNAE)
			cCnaeDesc  := AllTrim(Posicione("CC3",1,xFilial( "CC3" ) + TRC->CNAE,"CC3->CC3_DESC"))
			cXCAMIG    := AllTrim(Posicione("CC3",1,xFilial( "CC3" ) + TRC->CNAE,"CC3->CC3_XCAMIG"))
			cCnaeNAmig := AllTrim(Posicione("SX5",1,xFilial( "SX5" ) + 'ZX' + cXCAMIG ,"SX5->X5_DESCRI"))
		EndIf
		
		nPos    := AScan( aOrigPV, {|x| Left(x,1) == TRC->C5_XORIGPV } )
		cORIGPV := IIF( nPos > 0, aOrigPV[nPos], '')
		
		DbSelectArea("SC6")
		DbSetOrder(1)
		SC6->(DbSeek(TRC->Filial + TRC->Numero_Pedido))
		
		cImprTela := TRC->Mes 													+ "  "
		cImprTela += AllTrim(TRC->Canal) 										+ "  "
		cImprTela += TRC->Produto 												+ "  "
		cImprTela += SubStr(TRC->Descricao,1,16) 								+ "  "
		cImprTela += TRC->Segmento 												+ "  "
		cImprTela += TRC->Cliente + "/" + TRC->Loja 							+ "  "
		cImprTela += SubStr(TRC->Nome,1,20) 									+ "  "
		cImprTela += AllTrim(Str(TRC->Quantidade)) 								+ "  "
		cImprTela += TRC->Cod_Vend1 											+ "  "
		cImprTela += SubStr(cNome1,1,19) 										+ "  "
		cImprTela += TRC->Cod_Vend2 											+ "  "
		cImprTela += cNome2 													+ "  "
		cImprTela += Alltrim(TRC->Nota_Fiscal) + "/" + Alltrim(TRC->Item_Nota) 	+ "  "
		cImprTela += TRC->Numero_BPAG 											+ "  "
		cImprTela += TRC->Numero_Pedido 										+ "  "
		cImprTela += AllTrim(Transform(TRC->Valor_Total,  '@E 999,999,999.99'))	+ "  "
		cImprTela += DtoC(STOD(TRC->Emissao)) 									+ "  "
		cImprTela += TRC->Categoria												+ "  "
		cImprTela += cCod_Parceiro												+ "  "
		cImprTela += cVendCodRev												+ "  "
       	cImprTela += cVendNom													+ "  "
			
		//-- Verifica se encontrou valor no campo para impressao da
		//-- informacao GAR do produto.
		If !Empty(SC6->C6_PROGAR)
			@nLin,00 PSAY cImprTela
			nLin++
			cImprTela := ""
			cImprTela += SubStr(SC6->C6_PROGAR,1,13) + " "
			@nLin,00 PSAY cImprTela
			nLin++
			@nLin,00 PSAY ""
			nLin++
		Else
			@nLin,00 PSAY cImprTela
			nLin++
			@nLin,00 PSAY ""
			nLin++
		EndIf
	
		//-- VALOR UNIT","DESPESA","VALOR","EMISSAO","TES","FISICO_JUR","NOME_REDUZ","TIPO","CEP","ENDERECO","ESTADO","COD_MUN","MUNICIPIO","BAIRRO","DDD","TEL","CONTATO","EMAIL","CPF_CNPJ","CNAE","Emissao_Pedido","AR","NOME_AR"})
		AAdd(_aDados, 	{	TRC->Filial														,;
								TRC->Mes													,;
								TRC->Canal													,;
								TRC->Natureza												,;
								TRC->Produto												,;
								TRC->Descricao												,;
								TRC->Segmento												,;
								TRC->Cliente + "/" + TRC->Loja								,;
								TRC->Nome													,;
								TRC->Quantidade												,;
								TRC->Cod_Vend1												,;
								cNome1														,;
								TRC->Cod_Vend2												,;
								cNome2														,;
								Alltrim(TRC->Nota_Fiscal) + "/" + Alltrim(TRC->Item_Nota)	,;
								TRC->Numero_BPAG											,;
								TRC->Numero_Pedido											,;
								Transform(TRC->Valor_Unit,  '@E 999,999,999.99')			,;
								Transform(nParcDesp,  '@E 999,999,999.99')					,;
								Transform(TRC->Frete,  '@E 999,999,999.99')					,;
								Transform(nTotalAcu,  '@E 999,999,999.99')					,;
								STOD(TRC->Emissao)											,;
								TRC->TES													,;
								TRC->FISICO_JUR												,;
								TRC->NOME_REDUZ												,;
								TRC->TIPO													,;
								" "															,;
								" "															,;
								TRC->ESTADO													,;
								" "															,;
								TRC->MUNICIPIO												,;
								" "															,;
								" "															,;
								" "															,;
								" "															,;
								" "															,;
								" "															,;
								TRC->CNAE													,;
								cCnaeDesc													,;
								cCnaeNAmig													,;
								STOD(TRC->Emissao_Pedido)									,;
								TRC->Ar														,;
								cNOME_AR													,;
								cGrp_Cliente												,;
								cCodigo_AR													,;
								cDescricao_AR												,;
								cCodPosto													,;
								cDescPosto													,;
								cOportunidade												,;
								SC6->C6_PROGAR												,;
								cLicit														,;
								cTpRece														,;
								TRC->Cod_Empen												,;
								STOD(TRC->Dt_Solicitacao)									,;
								cORIGPV														,;							
								TRC->Categoria												,;
								TRC->Cod_Rev												,;
								cVendCodRev													,;
								cVendNom													,;
								cCodUnNeg													,;
								cDesUnNeg													,;
								cPublPriv})
								
		TRC->(dbSkip())
	
	EndDo
	
	nEnd := Seconds()
	
	//Alert("Processamento: " + cValToChar((nEnd-nStart)/60))
	
	If mv_par10 == 1
		DlgToExcel({ {"ARRAY","Demosntrativo de Vendas", _aCabec, _aDados} })
	EndIf
	
	SET DEVICE TO SCREEN
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณCriaSx1   บAutor: ณRafael Beghini         บData: ณ04/03/2016 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณCria as Perguntas usadas no parametro.                       บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CriaSx1( cPerg )
	
	Local aP     := {}
	Local i      := 0
	Local cSeq
	Local cMvCh
	Local cMvPar
	Local aHelp  := {}
	
	/***
	Caracterํstica do vetor p/ utiliza็ใo da fun็ใo SX1
	---------------------------------------------------
	[n,1] --> texto da pergunta
	[n,2] --> tipo do dado
	[n,3] --> tamanho
	[n,4] --> decimal
	[n,5] --> objeto G=get ou C=choice
	[n,6] --> validacao
	[n,7] --> F3
	[n,8] --> definicao 1
	[n,9] --> definicao 2
	[n,10] -> definicao 3
	[n,11] -> definicao 4
	[n,12] -> definicao 5
	***/
	
	aAdd( aP ,{"Emissใo de"       ,"D" ,08 ,0 ,"G" ,""                    	,"   "    ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"Emissใo ate"      ,"D" ,08 ,0 ,"G" ,"(mv_par02>=mv_par01)"	,"   "    ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"Produto de"       ,"C" ,15 ,0 ,"G" ,""                    	,"SB1"    ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"Produto ate"      ,"C" ,15 ,0 ,"G" ,""                    	,"SB1"    ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"Vendedor de"      ,"C" ,06 ,0 ,"G" ,""                    	,"SA3"    ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"Vendedor ate"     ,"C" ,06 ,0 ,"G" ,""                    	,"SA3"    ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"Natureza de"      ,"C" ,15 ,0 ,"G" ,""                    	,"SED"    ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"Natureza ate"     ,"C" ,15 ,0 ,"G" ,""                    	,"SED"    ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"TES"              ,"C" ,99 ,0 ,"G" ,""                    	,""       ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"Gerar excel"      ,"N" ,01 ,0 ,"C" ,""                    	,""       ,"Sim" ,"Nใo" ,"" ,"" ,""} )
	aAdd( aP ,{"Cliente de"       ,"C" ,06 ,0 ,"G" ,""                    	,"SA1"    ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"Cliente ate"      ,"C" ,06 ,0 ,"G" ,""                    	,"SA1"    ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"Cons.Filiais"     ,"N" ,01 ,0 ,"C" ,""                    	,""       ,"Sim" ,"Nใo" ,"" ,"" ,""} )
	aAdd( aP ,{"Filial de"        ,"C" ,02 ,0 ,"G" ,""                    	,"SM0"    ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"Filial ate"       ,"C" ,02 ,0 ,"G" ,""                    	,"SM0"    ,""    ,""    ,"" ,"" ,""} )
	aAdd( aP ,{"Canal de Venda"   ,"C" ,99 ,0 ,"G" ,""                    	,"SZ2_01" ,""    ,""    ,"" ,"" ,""} )
		
	aAdd( aHelp	,{"Informe a data de emissao inicial."						} )
	aAdd( aHelp	,{"Informe a data de emissao final."						} )	
	aAdd( aHelp	,{"Digite o produto inicial."								} )
	aAdd( aHelp	,{"Digite o produto final."									} )
	aAdd( aHelp	,{"Digite o vendedor inicial."								} )
	aAdd( aHelp	,{"Digite o vendedor final."								} )
	aAdd( aHelp	,{"Digite a natureza inicial."								} )
	aAdd( aHelp	,{"Digite a natureza final."								} )
	aAdd( aHelp	,{"Digite o codigo da TES,"		,"Exemplo: 501;502;503."	} )
	aAdd( aHelp	,{"Deseja gerar excel"										} )
	aAdd( aHelp	,{"Digite o cliente incial."								} )
	aAdd( aHelp	,{"Digite o cliente final."									} )
	aAdd( aHelp	,{"Considerar filiais"										} )
	aAdd( aHelp	,{"Digite a filial inicial."								} )
	aAdd( aHelp	,{"Digite a filial final."									} )
	aAdd( aHelp	,{"Selecione o canal de venda"	,"Exemplo: 000001;000002"	} )
	
	For i:=1 To Len(aP)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
		
		PutSx1(	cPerg							,;
					cSeq						,;
					aP[i,1],aP[i,1],aP[i,1]		,;
					cMvCh						,;
					aP[i,2]						,;
					aP[i,3]						,;
					aP[i,4]						,;
					0							,;
					aP[i,5]						,;
					aP[i,6]						,;
					aP[i,7]						,;
					""							,;
					""							,;
					cMvPar						,;
					aP[i,8],aP[i,8],aP[i,8]		,;
					""							,;
					aP[i,9],aP[i,9],aP[i,9]		,;
					aP[i,10],aP[i,10],aP[i,10]	,;
					aP[i,11],aP[i,11],aP[i,11]	,;
					aP[i,12],aP[i,12],aP[i,12]	,;
					aHelp[i]					,;
					{}							,;
					{}							,;
					"" )
	Next i
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณMFat7Opc  บAutor: ณRafael Beghini         บData: ณ04/03/2016 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณOpcoes para selecionar o canal de venda no pergunte.         บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function MFat7Opc()
	
	Local lOk   := .F.
	Local lMark := .F.
	Local oDlg
	Local oLbx
	Local oPanelBot
	Local oPanelAll
	Local oCancel 
	Local oConfirm
	
	Local oOk := LoadBitmap(,'NGCHECKOK.PNG')
	Local oNo := LoadBitmap(,'NGCHECKNO.PNG')
	
	Private cCadastro := 'Canais de Venda'
	Private aDADOS    := {}
	
	SZ2->( dbSetOrder(1) )
	SZ2->( dbGotop() )
	While .NOT. SZ2->( EOF() )
		aAdd( aDADOS, {lMark,SZ2->Z2_CODIGO,SZ2->Z2_CANAL} )
		SZ2->( dbSkip() )
	End
	
	If Empty( aDADOS )
		MsgInfo('Nใo foi possํvel encontrar registros de canal de venda, verifique.', cCadastro)
		Return( cRet )
	Endif

	DEFINE MSDIALOG oDlg FROM  31,58 TO 350,500 TITLE cCadastro PIXEL
			oPanelAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

			@ 40,05 LISTBOX oLbx FIELDS HEADER 'x','C๓digo','Nome do canal de venda' SIZE 350, 90 OF oPanelAll PIXEL ON ;
			dblClick(aDADOS[oLbx:nAt,1]:=!aDADOS[oLbx:nAt,1])
			oLbx:Align := CONTROL_ALIGN_ALLCLIENT
			oLbx:SetArray(aDADOS)
			oLbx:bLine := { || {Iif(aDADOS[oLbx:nAt,1],oOk,oNo),aDADOS[oLbx:nAt,2],aDADOS[oLbx:nAt,3]}}
			oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMark:=!lMark,;
			FWMsgRun(,{|| AEval(aDADOS, {|p|  p[1]:=lMark, oLbx:Refresh() } ) },,'Aguarde, '+Iif(lMark,'marcando','desmarcando')+' todos os canais...') }
			
			oPanelBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
			oPanelBot:Align := CONTROL_ALIGN_BOTTOM
	
			@ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPanelBot ACTION Iif(MFat7Seek(aDADOS,@lOk),oDlg:End(),NIL)
			@ 1,44 BUTTON oCancel  PROMPT 'Sair'  SIZE 40,11 PIXEL OF oPanelBot ACTION (oDlg:End())
	ACTIVATE MSDIALOG oDlg CENTER
	
Return( .T. )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณMFat7Seek บAutor: ณRafael Beghini         บData: ณ04/03/2016 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณRotina para retornar o codigo do Canal conforme posicionado. บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function MFat7Seek( aDADOS, lOk )
	
	Local cRet   := ''
	Local cCanal := ''
	Local nLin   := 0
	Local nPos   := 0
	Local nP     := 1
	Local nY     := 0
	Local nMv    := 0
	Local aMvPar := {}
	Local lRet   := .T.
	
	nPos := AScan( aDADOS, {|X| X[1]==.T. } )
	If nPos==0
		lRet := .F.
		MsgAlert('Nใo foi selecionado nenhum canal de venda.',cCadastro)
	Else
		For nMv := 1 To 40
			AAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
		Next nMv
		
	   For nY := 1 To Len(aDADOS)
	   		cRet += Iif(aDADOS[nY,1],aDADOS[nY,2],'')
	   Next
	   
	   //////////////////////////////////////
	   For nLin := 1 To Len( cRet ) / 6
			If Len(cCanal) == 0
			  cCanal += Substring(cRet,nP,6)
			  nP += 6
			Else
			  cCanal += ";"+Substring(cRet,nP,6)
			  nP += 6
			EndIf
		Next nLin
		cRet := cCanal
	   	//////////////////////////////////////
		
		For nMv := 1 To Len( aMvPar )
			&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
		Next nMv
		
		MV_PAR16 := cRet
		lOk      := lRet
	Endif
	
Return( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma:  ณMFat7Seek บAutor: ณRafael Beghini         บData: ณ04/03/2016 บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao: ณRotina para retornar o codigo do Canal conforme posicionado. บฑฑ
ฑฑฬอออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso:       ณCertisign - Certificadora Digital.                           บฑฑ
ฑฑศอออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function LoadTables()

Local nStart := Seconds()
Local nEnd := 0

DbSelectArea("SA3")
SA3->(DbSetOrder(1))

DbSelectArea("SZ3")
SZ3->(DbSetOrder(1))

DbSelectArea("ACY")
ACY->(DbSetOrder(1))	

DbSelectArea("SZ5")
SZ5->(DbSetOrder(1))
		
DbSelectArea("SC6")
SC6->(DbSetOrder(1))
		
DbSelectArea("SZY")
SZY->(DbSetOrder(1))

DbSelectArea("SC6")
SC6->(DbSetOrder(1))

nEnd := Seconds()

//Alert("Load Tables" + cValtoChar((nEnd-nStart)/60))

Return