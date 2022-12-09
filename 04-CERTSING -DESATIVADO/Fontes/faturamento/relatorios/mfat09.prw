#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFAT08    ºAutor  ³RECLOP	 		      º Data ³  01/23/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório Demostrativo de Vendas - Visao Diretoria          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MFat09()

	Local cDesc1      		:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
	Local cDesc3         	:= "Demonstrativo de Vendas"
	Local cPict          	:= ""
	Local titulo       	 	:= "Demonstrativo de Vendas"
	Local nLin         		:= 80
	Local Cabec1       		:= "MES        CANAL         PRODUTO            DESCRICAO                SEGUIMENTO       CLI/LOJA   NOME               QTD     VEND1   NOME1             VEND2     NOME2   NF/ITEM    BPAG    AR                VALOR    EMISSAO "
	Local Cabec2			:= ""
	Local imprime      		:= .T.
	Local aOrd 				:= {}
	Private lEnd         	:= .F.
	Private lAbortPrint  	:= .F.
	Private limite          := 220
	Private tamanho         := "G"
	Private nomeprog        := "MFAT09"
	Private nTipo           := 18
	Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cbtxt      		:= Space(10)
	Private cbcont     		:= 00
	Private CONTFL     		:= 01
	Private m_pag      		:= 01
	Private wnrel      		:= "MFAT09"
	Private cString 		:= ""
	Private cPerg			:= "MFAT09"

	AjustaSX1()
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

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

	EndIf
Return

/*/
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Funï¿½ï¿½o    ï¿½RUNREPORT ï¿½ Autor ï¿½ AP6 IDE            ï¿½ Data ï¿½  16/12/2009 ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Descriï¿½ï¿½o ï¿½ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½ monta a janela com a regua de processamento.               ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ Programa principal                                         ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem
	Local nPos 		:= 0
	Local aCombo 	:= {}
	Local cORIGPV 	:= ''
	Local cCodAR 	:= cNOME_AR := cCodigo_AR := cDescricao_AR := cCodigo_do_Posto := cDescricao_do_Posto := ''
	Local _nI 		:= 1

	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	IF dbSeek( 'C5_XORIGPV' )
		aCombo := StrToKarr( X3CBox(), ';' )
	EndIF
	
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ SETREGUA -> Indica quantos registros serao processados para a regua ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

	SetRegua(RecCount())

	_aPVORG		:= StrToArray(Alltrim(mv_par03),";")

	_cPVORG		:= " "

	For _nI := 1 To Len(_aPVORG)
		If !Empty(_aPVORG[_nI])
			_cPVORG += "'" + _aPVORG[_nI] + "'"
			If _nI <> Len(_aPVORG)
				_cPVORG += ","
			EndIf
		EndIf
	Next _nI

	_cPVORG := Alltrim(_cPVORG)

	_cCountTes := Len(_cPVORG)
	_cCountNewTes := _cCountTes -2
	_cNewTes := Substring(_cPVORG,2,_cCountNewTes)

	IF EMPTY(MV_PAR03)
		MV_PAR03 := '1;2;3;4;5;6;7;8;9;0;A'
	END

	cAlias := "TRC"

	Begin Sequence

		BeginSql Alias cAlias
		SELECT DISTINCT SUBSTR(SD2.D2_EMISSAO, 5, 2) 
                || '/' 
                || SUBSTR(SD2.D2_EMISSAO, 1, 4)  AS Mes, 
                TRIM(SZ2.Z2_CANAL)               AS Canal, 
                SC5.C5_XORIGPV                   AS ORIG_PV, 
                SD2.D2_COD                       AS Produto, 
                TRIM(SB1.B1_DESC)                AS Descricao, 
                TRIM(SZ1.Z1_DESCSEG)             AS Seguimento, 
                SD2.D2_CLIENTE                   AS Cliente, 
                SD2.D2_LOJA                      AS Loja, 
                TRIM(SA1.A1_NOME)                AS Nome, 
                SD2.D2_QUANT                     AS Quantidade, 
                SC5.C5_VEND1                     AS Cod_Vend1, 
                TRIM(SA3.A3_NOME)                AS Nome_Vend1, 
                SF2.F2_VEND2                     AS Cod_Vend2, 
                TRIM(SA3A.A3_NOME)               AS Nome_Vend2, 
                SD2.D2_DOC                       AS Nota_Fiscal, 
                SD2.D2_ITEM                      AS Item_Nota, 
                SC5.C5_CHVBPAG                   AS Numero_BPAG, 
                SC5.C5_NUM                       AS Numero_Pedido, 
                Cast (D2_TOTAL AS NUMBER(13, 2)) AS Valor_Unit, 
                SD2.D2_VALFRE                    AS Despesa, 
                ( SD2.D2_TOTAL + SD2.D2_VALFRE ) AS Valor_Total, 
                SE4.E4_DESCRI                    AS Cond_Pagto, 
                ( CASE 
                    WHEN SC5.C5_TIPMOV = ' ' THEN 'Vendas Corporativa' 
                    WHEN SC5.C5_TIPMOV = '1' THEN 'Boleto' 
                    WHEN SC5.C5_TIPMOV = '2' THEN 'Cartao Credito' 
                    WHEN SC5.C5_TIPMOV = '3' THEN 'Cartao Debito' 
                    WHEN SC5.C5_TIPMOV = '4' THEN 'DA' 
                    WHEN SC5.C5_TIPMOV = '5' THEN 'DDA' 
                    WHEN SC5.C5_TIPMOV = '6' THEN 'Voucher' 
                    WHEN SC5.C5_TIPMOV = '7' THEN 'DA ITAU' 
                    ELSE 'Nova condição de pagamento - Verifique com Sistemas Corporativos' 
                  END )                          AS Forma_Pagto, 
                SC5.C5_XNPSITE                   AS Ped_Site, 
                SC5.C5_XLINDIG                   AS Linha_Digit, 
                ' '                              AS Cta_Debito, 
                ' '                              AS Cta_Credito, 
                SD2.D2_VALIMP5                   AS Vlr_COF, 
                SD2.D2_VALIMP6                   AS Vlr_PIS, 
                SD2.D2_EMISSAO                   AS Emissao, 
                SD2.D2_TES                       AS TES, 
                ' '                              AS Fisico_Jur, 
                ' '                              AS Nome_Reduz, 
                ' '                              AS Tipo, 
                ' '                              AS Cep, 
                ' '                              AS Endereco, 
                SA1.A1_EST                       AS Estado, 
                SA1.A1_CODMUN                       AS Cod_Mun, 
                SA1.A1_MUN                       AS Municipio, 
                ' '                              AS Bairro, 
                ' '                              AS DDD, 
                ' '                              AS Tel, 
                ' '                              AS Contato, 
                ' '                              AS Email, 
                ' '                              AS CPF_CNPJ, 
                ' '                              AS CNAE, 
                SC5.C5_EMISSAO                   AS Emissao_Pedido, 
                ACY_DESCRI                       AS Grp_Cliente, 
                ( CASE 
                    WHEN C5_XPOSTO <> ' ' THEN SZ3.Z3_CODAR 
                    WHEN C5_CHVBPAG <> ' ' THEN SZ5.Z5_CODAR 
                    ELSE ' ' 
                  END )                          AS COD_AR, 
                ( CASE 
                    WHEN C5_XPOSTO <> ' ' THEN TRIM(SZ3.Z3_DESAR) 
                    WHEN C5_CHVBPAG <> ' ' THEN TRIM(SZ5.Z5_DESCAR) 
                    ELSE ' ' 
                  END )                          AS Nome_AR, 
                ( CASE 
                    WHEN C5_XPOSTO <> ' ' THEN C5_XPOSTO 
                    WHEN C5_CHVBPAG <> ' ' THEN SZ5.Z5_CODPOS 
                    ELSE ' ' 
                  END )                          AS COD_Posto, 
                ( CASE 
                    WHEN C5_XPOSTO <> ' ' THEN TRIM(SZ3.Z3_DESENT) 
                    WHEN C5_CHVBPAG <> ' ' THEN TRIM(SZ5.Z5_DESPOS) 
                    ELSE ' ' 
                  END )                          AS Nome_Posto 
		FROM   %Table:SD2% SD2 
		       INNER JOIN %Table:SF2% SF2 
		               ON SD2.D2_FILIAL = SF2.F2_FILIAL 
		                  AND SD2.D2_DOC = SF2.F2_DOC 
		                  AND SD2.D2_SERIE = SF2.F2_SERIE 
		                  AND SF2.D_E_L_E_T_ = ' ' 
		                  AND SD2.D_E_L_E_T_ = ' ' 
		       LEFT JOIN %Table:SB1% SB1 
		              ON SB1.B1_FILIAL = SD2.D2_FILIAL 
		                 AND SB1.B1_COD = SD2.D2_COD 
		                 AND SB1.D_E_L_E_T_ = ' ' 
		       LEFT JOIN %Table:SA1% SA1 
		              ON SA1.A1_FILIAL = ' ' 
		                 AND SA1.A1_COD = SD2.D2_CLIENTE 
		                 AND SA1.A1_LOJA = SD2.D2_LOJA 
		                 AND SA1.D_E_L_E_T_ = ' ' 
		       LEFT JOIN %Table:ACY% ACY 
		              ON ACY.ACY_FILIAL = SA1.A1_FILIAL 
		                 AND ACY_GRPVEN = SA1.A1_GRPVEN 
		                 AND ACY.D_E_L_E_T_ = ' ' 
		       INNER JOIN %Table:SA3% SA3 
		               ON SA3.A3_FILIAL = ' ' 
		                  AND SA3.A3_COD = SF2.F2_VEND1 
		                  AND SA3.D_E_L_E_T_ = ' ' 
		       LEFT JOIN %Table:SA3A% SA3A 
		              ON SA3A.A3_FILIAL = ' ' 
		                 AND SA3A.A3_COD = SF2.F2_VEND2 
		                 AND SA3A.D_E_L_E_T_ = ' ' 
		       LEFT JOIN %Table:SC5% SC5 
		              ON SC5.C5_FILIAL = %xFilial:SC5% 
		                 AND SC5.C5_NUM = SD2.D2_PEDIDO 
		                 AND SC5.D_E_L_E_T_ = ' ' 
		       LEFT JOIN %Table:SZ2% SZ2 
		              ON SZ2.Z2_FILIAL = ' ' 
		                 AND SZ2.Z2_CODIGO = SA3.A3_XCANAL 
		                 AND SZ2.D_E_L_E_T_ = ' ' 
		       LEFT JOIN %Table:SZ1% SZ1 
		              ON SZ1.Z1_FILIAL = ' ' 
		                 AND SZ1.Z1_CODSEG = SB1.B1_XSEG 
		                 AND SZ1.D_E_L_E_T_ = ' ' 
		       LEFT JOIN %Table:SE4% SE4 
		              ON SE4.E4_FILIAL = ' ' 
		                 AND SC5.C5_CONDPAG = SE4.E4_CODIGO 
		                 AND SE4.D_E_L_E_T_ = ' ' 
		       LEFT JOIN %Table:SZ3% SZ3 
		              ON SZ3.D_E_L_E_T_ = ' ' 
		                 AND SZ3.Z3_FILIAL = ' ' 
		                 AND SZ3.Z3_CODGAR = SC5.C5_XPOSTO 
		       LEFT JOIN %Table:SZ5% SZ5 
		              ON SZ5.D_E_L_E_T_ = ' ' 
		                 AND SZ5.Z5_FILIAL = ' ' 
		                 AND SZ5.Z5_PEDGAR = SC5.C5_CHVBPAG 
		                 AND Z5_TIPO = 'VALIDA' 
		       INNER JOIN %Table:SF4% SF4 
		               ON SF4.F4_FILIAL = ' ' 
		                  AND SF4.F4_DUPLIC = 'S' 
		                  AND SF4.D_E_L_E_T_ = ' ' 
		                  AND SF4.F4_CODIGO > '500' 
		WHERE  SF2.F2_FILIAL = %xFilial:SF2%
		       AND SD2.D2_FILIAL = %xFilial:SF2%
		       AND SD2.D2_EMISSAO >= %Exp:MV_PAR01% 
		       AND SD2.D2_EMISSAO <= %Exp:MV_PAR02% 
		       AND SC5.C5_XORIGPV IN (%Exp:_cNewTes%)
		
		ORDER  BY MES, 
		          SD2.D2_DOC, 
		          NOME_VEND1, 
		          SD2.D2_ITEM, 
		          SEGUIMENTO, 
		          CANAL
	EndSQL
	
	aLastQuery    := GetLastQuery()
	cLastQuery    := aLastQuery[2]
	
Recover

	aLastQuery    := GetLastQuery()
	cLastQuery    := aLastQuery[2]

END SEQUENCE

MemoWrite("C:\Data\query_mfat09.sql",cLastQuery)


//Array p/ Excel
_aCabec 	:= {}
_aDados		:= {}

AAdd(_aDados, {	"MES",;
	"CANAL",;
	"ORIG_PV",;
	"PRODUTO",;
	"DESCRICAO",;
	"SEGUIMENTO",;
	"CLI/LOJA",;
	"NOME",;
	"QTD",;
	"VEND1",;
	"NOME VEND1",;
	"VEND2", ;
	"NOME VEND2",;
	"NF/ITEM",;
	"BPAG",;
	"Numero_Pedido",;
	"VALOR UNIT",;
	"DESPESA",;
	"VALOR",;
	"VALOR_TIT",;
	"SALDO_PAGAR",;
	"FORMA_DE_PAGTO",;
	"COND_PAGTO",;
	" PED_SITE",;
	"LINHA_DIGITAV.",;
	" CTA_DEBTO",;
	"CTA_CREDITO",;
	"VLR_COF",;
	"VLR_PIS",;
	"EMISSAO",;
	"TES",;
	"TIPO",;
	"NOME_REDUZ",;
	"TIPO",;
	"CEP",;
	"ENDERECO",;
	"ESTADO",;
	"COD_MUN",;
	"MUNICIPIO",;
	"BAIRRO",;
	"DDD",;
	"TEL",;
	"CONTATO",;
	"EMAIL",;
	"CPF_CNPJ",;
	"CNAE",;
	"Emissao_Pedido",;
	"Grp_Cliente",;
	"Codigo_AR",;
	"Descricao_AR",;
	"Codigo_do_Posto",;
	"Descricao_do_Posto",;
	"Numero_Oportunidade"})
AAdd(_aDados, {})

DbSelectArea("TRC")
TRC->(dbGoTop())

While !TRC->(Eof())

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif


	cNumB := TRC->Nota_Fiscal
	cCliB := TRC->Cliente
	cAliasB := "TMP"

	BeginSql Alias cAliasB

		SELECT SUM(E1_VALOR) AS VALOR, SUM(E1_SALDO) AS SALDO FROM %Table:SE1% E1
		WHERE
		E1.E1_NUM = %Exp:cNumB% AND E1.E1_CLIENTE = %Exp:cCliB% AND E1.D_E_L_E_T_ = ' '

	EndSQL
	
	nPos := AScan( aCombo, {|x| Left(x,1) == TRC->ORIG_PV  } )
	cORIGPV  := IIF( nPos > 0,SubStr( aCombo[nPos],3,Len(aCombo[nPos]) ), '')
	
	
	AAdd(_aDados, {	TRC->Mes,;
		TRC->Canal,;
		cORIGPV,;
		TRC->Produto,;
		TRC->Descricao,;
		TRC->Seguimento,;
		TRC->Cliente + "/" + TRC->Loja,;
		TRC->Nome,;
		TRC->Quantidade,;
		TRC->Cod_Vend1,;
		TRC->Nome_Vend1,;
		TRC->Cod_Vend2,;
		TRC->Nome_Vend2,;
		Alltrim(TRC->Nota_Fiscal) + "/" + Alltrim(TRC->Item_Nota),;
		TRC->Numero_BPAG,;
		TRC->Numero_Pedido,;
		Transform(TRC->Valor_Unit,  '@E 999,999,999.99'),;
		Transform(TRC->Despesa,  '@E 999,999,999.99'),;
		Transform(TRC->Valor_Total,  '@E 999,999,999.99'),;
		Transform(TMP->VALOR,  '@E 999,999,999.99'),;
		Transform(TMP->SALDO,  '@E 999,999,999.99'),;
		TRC->Forma_Pagto,;
		TRC->Cond_Pagto,;
		TRC->Ped_Site,;
		TRC->Linha_Digit, ;
		TRC->Cta_Debito, ;
		TRC->Cta_Credito,;
		Transform(TRC->Vlr_COF, '@E 999,999.99'),;
		Transform(TRC->Vlr_PIS, '@E 999,999.99'),;
		STOD(TRC->Emissao),;
		TRC->TES,;
		TRC->FISICO_JUR,;
		TRC->NOME_REDUZ,;
		TRC->TIPO,;
		'',;
		'',;
		TRC->ESTADO,;
		TRC->Cod_Mun,;
		TRC->MUNICIPIO,;
		'',;
		'',;
		'',;
		'',;
		'',;
		IIF(TRC->FISICO_JUR="J",Transform(TRC->CPF_CNPJ,'@R 99.999.999/9999-99'),Transform(TRC->CPF_CNPJ,'@R 999.999.999-99')),;
		'',;
		STOD(TRC->Emissao_Pedido),;
		TRC->Grp_Cliente,;
		TRC->COD_AR,;
		TRC->Nome_AR,;
		TRC->COD_Posto,;
		TRC->Nome_Posto})
		
	
                  

	nLin++
	TRC->(dbSkip())
	TMP->(DbCloseArea())


EndDo

TRC->(DbCloseArea())

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

DlgToExcel({ {"ARRAY","Demosntrativo de Vendas", _aCabec, _aDados} })

SET DEVICE TO SCREEN

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ Se impressao em disco, chama o gerenciador de impressao...          ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½-ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½Funï¿½ï¿½o    ï¿½ AjustaSX1    ï¿½Autor ï¿½  Douglas Mello		ï¿½    16/12/2009   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½-ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½Descriï¿½ï¿½o ï¿½ Ajusta perguntas do SX1                                    ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ù±ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/
Static Function AjustaSX1()

	Local aArea := GetArea()

	PutSx1(cPerg,"01","Emissao De         ","Emissao De         ","Emissao De         ","mv_ch1","D",08,00,01,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
	PutSx1(cPerg,"02","Emissao Ate        ","Emissao Ate        ","Emissao Ate        ","mv_ch2","D",08,00,01,"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
	PutSx1(cPerg,"03","Origem P.V.        ","Origem P.V.        ","Origem P.V.        ","mv_ch9","C",25,00,01,"G","",""   ,"","","mv_par03"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","",{"1 'MANUAL'  2 'VAREJO' 3 'HARDWARE AVULSO'   4 'TELEVENDAS'  5 'ATENDIMENTO EXTERNO'"})

	RestArea(aArea)

Return

/*/{Protheus.doc} CSPVORF3
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 11/06/2018
@version 1.0
@return cRetorno, 
@param cMVPAR03, characters, descricao
@type function
/*/
user function CSPVORF3(cMVPAR03)

Local oDlg
Local oPnlLbx
Local oLbx
Local oMrk      := LoadBitmap( GetResources(), "LBOK" )
Local oNoMrk    := LoadBitmap( GetResources(), "LBNO" )
Local cTitle 	:= "Origem de Pedidos"
Local cRetorno	:= ""
Local aDadosOp 	:= {}
Local aCombo	:= StrToKArr(U_CSC5XBOX(),";")
Local aAux 		:= {}
Local aButton	:= {}
Local nL		:= 2
Local Ni		:= 0
Local lMrkAll 	:= .F.

For Ni := 1 To Len(aCombo)
	aAux := {}
	aAux := StrToKArr(aCombo[Ni],"=")
	aAdd(aDadosOp, { .F., aAux[1], aAux[2]})
Next

If !Empty(mv_par03) .And. Empty(cMVPAR03)
	cMVPAR03 := mv_par03
EndIf

If !Empty(cMVPAR03)
	aAux := {}
	aAux := StrToKArr(cMVPAR03,";")
	For Ni := 1 To Len(aAux)
		If !Empty(aAux[Ni])
			nPosItem := aScan(aDadosOp,{|x| AllTrim(x[2]) == AllTrim(aAux[Ni])})
			If nPosItem > 0
				aDadosOp[nPosItem][1] := .T.
			EndIf
		EndIf 
	Next
EndIf

aAdd( aButton, {"&Concluído", "{|| oDlg:End() }"})
aAdd( aButton, {"&Abandonar", "{|| oDlg:End() }"})

DEFINE MSDIALOG oDlg TITLE cTitle FROM 0,0 TO 300,250 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
		//oDlg:lEscClose := .F.
			
		oPnlLbx := TPanel():New(0,0,'',oDlg,,.T.,,,,80,0,.T.,.T.)
		oPnlLbx:Align := CONTROL_ALIGN_ALLCLIENT

		oPnlBott := TPanel():New(0,0,'',oDlg,,.T.,,,,40,14,.T.,.F.)
		oPnlBott:Align := CONTROL_ALIGN_BOTTOM		
	
		oLbx := TwBrowse():New(0,0,800,400,,{'','Código','Descrição',''},{20,25,80},oPnlLbx,,,,,,,,,,,,.F.,,.T.,,.F.,,.F.,.F.)
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oLbx:SetArray( aDadosOp )
		oLbx:bLDblClick := {|| aDadosOp[oLbx:nAt,1]:=!aDadosOp[oLbx:nAt,1]}
		   
		oLbx:bLine := {|| {Iif(aDadosOp[oLbx:nAt,1],oMrk,oNoMrk),aDadosOp[oLbx:nAt,2],aDadosOp[oLbx:nAt,3]}}
		oLbx:bHeaderClick := {|oBrw,nCol,aDim| lMrkAll := !lMrkAll,;
			                     AEval( aDadosOp, {|p| p[1] := lMrkAll } ),oLbx:Refresh()}
			                     
		For Ni := 1 To Len( aButton )			
			TButton():New(3,nL,aButton[nI,1],oPnlBott,&(aButton[nI,2]),38,10,,,.F.,.T.,.F.,,.F.,,,.F.)
			nL += 40
		Next Ni			                     
         
ACTIVATE MSDIALOG oDlg CENTER

For Ni := 1 To Len(aDadosOp)
	If aDadosOp[Ni][1]
		cRetorno += aDadosOp[Ni][2] + Iif( Len(aDadosOp)>1 , ";", "")
	EndIf
Next

If rat(";",cRetorno) == Len(cRetorno)
	cRetorno := Substr(cRetorno,1,Len(cRetorno)-1)
EndIf

cRetorno := AllTrim(cRetorno)

Return cRetorno

/*/{Protheus.doc} CSFT09VLD
//TODO Descrição auto-gerada.
@author yuri.volpe
@since 11/06/2018
@version 1.0
@return lRet
@param cLista, characters, descricao
@type function
/*/
User Function CSFT09VLD(cLista)

Local lRet 		:= .T.
Local aCombo 	:= StrToKArr(U_CSC5XBOX(),";")
Local aLista	:= StrToKArr(cLista,";")
Local aDadosOp	:= {}
Local aAux		:= {}
Local cCodigo	:= ""

If Len(cLista) == 1
	cLista += ";"
EndIf

For Ni := 1 To Len(aCombo)
	aAux := {}
	aAux := StrToKArr(aCombo[Ni],"=")
	aAdd(aDadosOp, aAux[1])
Next

For Ni := 1 To Len(aLista)
	If !Empty(aLista[Ni])
		If aScan(aDadosOp,{|x| AllTrim(x) == AllTrim(aLista[Ni])}) == 0
			cCodigo += aLista[Ni] + ";"
		EndIf
	EndIf
Next

If !Empty(cCodigo)
	
	If rat(";",cCodigo) == Len(cCodigo)
		cCodigo := Substr(cCodigo,1,Len(cCodigo)-1)
	EndIf

	lRet := .F.
	MsgStop("Os códigos [" + cCodigo + "] não são valores válidos de Origem de Pedido." + CHR(13)+CHR(10) + "Selecione os itens mais uma vez.")
EndIf

Return lRet