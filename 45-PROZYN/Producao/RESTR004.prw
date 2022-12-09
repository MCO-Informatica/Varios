#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funcao	 ≥ RESTR004   ≥ Autor ≥ Adriano Leonardo    ≥ Data ≥ 18/04/16 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥RelatÛrio de conferÍncia de saldos, mostra a composiÁ„o dos ≥±±
±±≥          ≥saldos considerando cada tabela individualmente, permitindo ≥±±
±±≥          ≥comparar os saldos fÌsicos e financeiros com os saldos por  ≥±±
±±≥          ≥lote e endereÁo, considerando tambÈm os saldos iniciais do  ≥±±
±±≥          ≥perÌodo e entradas e saÌdas em cada controle.               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso		 ≥SIGAEST  							      	       			  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

User Function RESTR004()

Private _cRotina	:= "RESTR004"
Private cPerg		:= _cRotina
Private _aSavArea := GetArea()

Private _cTitulo1	:= ""
Private _cTitulo2	:= ""
Private _cQuery	:= ""
Private _cAlias	:= GetNextAlias()
Private _lRet		:= .T.
Private _cEnt		:= + CHR(13) + CHR(10)
Private _cFileTMP	:= ""
Private lEnd		:= .F.
Private _dUlMes		:= SuperGetMV("MV_ULMES",,"20000101")

_nOpc :=	Aviso("RelatÛrio de ConferÍncia de Saldos","Este relatÛrio ir· confrontar os saldos x movimentaÁıes do produto no estoque, lote e endereÁo.",{"Continuar","Cancelar"},3)

//Caso o usu·rio escolha a opÁ„o cancelar, interrompo a rotina
If _nOpc == 2
	Return()
EndIf

ValidPerg()

While !Pergunte(cPerg,.T.)
	If MsgYesNo("Deseja cancelar a emiss„o do relatÛrio?",_cRotina+"_01")
		Return()
	EndIf
EndDo

If MV_PAR12 == 2
	If Empty(MV_PAR13) .Or. MV_PAR13>dDataBase
		MsgBox('Data para composiÁ„o do saldo inv·lida, ser· considerada a data do ˙ltimo fechamento de estoque.',_cRotina +"_00",'STOP')		
		_dUlMes		:= SuperGetMV("MV_ULMES",,"20000101")
	Else
		_dUlMes	:= MV_PAR13
	EndIf
EndIf

//Verifica se o usu·rio tem permiss„o para emitir relatÛrios em Excel
If !(SubStr(cAcesso,160,1) == "S" .AND. SubStr(cAcesso,168,1) == "S" .AND. SubStr(cAcesso,170,1) == "S")
	MsgBox('Usu·rio sem permiss„o para gerar relatÛrio em Excel. Informe o Administrador.',_cRotina +"_02",'STOP')
   Return(Nil)
EndIf

//Verifica se o Excel est· instalado
If !ApOleClient('MsExcel') .And. __cUserId<>'000000'
	MsgBox('Excel n„o instalado.',_cRotina +"_03",'ALERT')
   Return(Nil)
EndIf

_cTitulo1 := ("Par‚metros")
_cTitulo2 := ("ConferÍncia de Saldos - " + DTOC(_dUlMes) + " ‡ " + DTOC(dDataBase))

//Chamada da funÁ„o para construir as planilhas
Processa({ |lEnd| Geraxls(@lEnd) },_cRotina," Gerando relatÛrio em Excel...   Por favor aguarde.",.T.)

RestArea(_aSavArea)

Return()

Static Function MapearSaldos()

	_cEnt := CHR(13) + CHR(10)
	//Consulta para retornar a soma das quantidades selecionadas pelo coletor de dados
	/*
	_cQuery := "SELECT " + _cEnt
	_cQuery += "	B1_COD, " + _cEnt
	_cQuery += "	B1_MSBLQL, " + _cEnt
	_cQuery += "	B1_RASTRO, " + _cEnt
	_cQuery += "	B1_LOCALIZ, " + _cEnt
	_cQuery += "	B2_LOCAL, " + _cEnt
	_cQuery += "	B2_QATU, " + _cEnt
	
	If MV_PAR09 == 1 //Considera lote
		_cQuery += "	ISNULL((SELECT SUM(B8_SALDO) FROM " + RetSqlName("SB8") + " SB8 WHERE SB8.D_E_L_E_T_='' AND SB8.B8_FILIAL='" + xFilial("SB8") + "' AND SB8.B8_PRODUTO=SB1.B1_COD AND SB8.B8_LOCAL=SB2.B2_LOCAL),0) AS [B8_SALDO], " + _cEnt
		_cQuery += "	ISNULL((SELECT SUM(SBJ.BJ_QINI) FROM " + RetSqlName("SBJ") + " SBJ WHERE SBJ.D_E_L_E_T_='' AND SBJ.BJ_FILIAL='" + xFilial("SBJ") + "' AND SBJ.BJ_COD=SB2.B2_COD AND SBJ.BJ_LOCAL=SB2.B2_LOCAL AND BJ_DATA=(SELECT MAX(BJ_DATA) FROM " + RetSqlName("SBJ") + " AUX WHERE AUX.D_E_L_E_T_='' AND AUX.BJ_FILIAL=SBJ.BJ_FILIAL AND AUX.BJ_COD=SBJ.BJ_COD AND AUX.BJ_LOCAL=SBJ.BJ_LOCAL AND AUX.BJ_LOTECTL=SBJ.BJ_LOTECTL AND AUX.BJ_DATA<='" + DTOS(_dUlMes) + "')),0) AS [BJ_QINI], " + _cEnt
		_cQuery += "	ISNULL((SELECT SUM(D5_QUANT) FROM " + RetSqlName("SD5") + " SD5 WHERE SD5.D_E_L_E_T_='' AND SD5.D5_FILIAL='" + xFilial("SD5") + "' AND SD5.D5_DATA>=(SELECT MAX(BJ_DATA) FROM " + RetSqlName("SBJ") + " AUX WHERE AUX.D_E_L_E_T_='' AND AUX.BJ_FILIAL='" + xFilial("SBJ") + "' AND AUX.BJ_COD=SD5.D5_PRODUTO AND AUX.BJ_LOCAL=SD5.D5_LOCAL AND AUX.BJ_LOTECTL=SD5.D5_LOTECTL AND AUX.BJ_DATA<='" + DTOS(_dUlMes) + "') AND SD5.D5_ORIGLAN<='500' AND SD5.D5_ESTORNO='' AND SD5.D5_PRODUTO=SB2.B2_COD AND SD5.D5_LOCAL=SB2.B2_LOCAL),0) AS [E_D5_QUANT], " + _cEnt
		_cQuery += "	ISNULL((SELECT SUM(D5_QUANT) FROM " + RetSqlName("SD5") + " SD5 WHERE SD5.D_E_L_E_T_='' AND SD5.D5_FILIAL='" + xFilial("SD5") + "' AND SD5.D5_DATA>=(SELECT MAX(BJ_DATA) FROM " + RetSqlName("SBJ") + " AUX WHERE AUX.D_E_L_E_T_='' AND AUX.BJ_FILIAL='" + xFilial("SBJ") + "' AND AUX.BJ_COD=SD5.D5_PRODUTO AND AUX.BJ_LOCAL=SD5.D5_LOCAL AND AUX.BJ_LOTECTL=SD5.D5_LOTECTL AND AUX.BJ_DATA<='" + DTOS(_dUlMes) + "') AND SD5.D5_ORIGLAN >'500' AND SD5.D5_ESTORNO='' AND SD5.D5_PRODUTO=SB2.B2_COD AND SD5.D5_LOCAL=SB2.B2_LOCAL),0) AS [S_D5_QUANT], " + _cEnt
	EndIf

	If MV_PAR10 == 1 //Considera endereÁo	
		_cQuery += "	ISNULL((SELECT SUM(BF_QUANT) FROM " + RetSqlName("SBF") + " SBF WHERE SBF.D_E_L_E_T_='' AND SBF.BF_FILIAL='" + xFilial("SBF") + "' AND SBF.BF_PRODUTO=SB1.B1_COD AND SBF.BF_LOCAL=SB2.B2_LOCAL),0) AS [BF_QUANT], " + _cEnt	
		_cQuery += "	ISNULL((SELECT SUM(SBK.BK_QINI) FROM " + RetSqlName("SBK") + " SBK WHERE SBK.D_E_L_E_T_='' AND SBK.BK_FILIAL='" + xFilial("SBK") + "' AND SBK.BK_COD=SB2.B2_COD AND SBK.BK_LOCAL=SB2.B2_LOCAL AND BK_DATA=(SELECT MAX(BK_DATA) FROM " + RetSqlName("SBK") + " AUX WHERE AUX.D_E_L_E_T_='' AND AUX.BK_FILIAL=SBK.BK_FILIAL AND AUX.BK_COD=SBK.BK_COD AND AUX.BK_LOCAL=SBK.BK_LOCAL AND AUX.BK_LOCALIZ=SBK.BK_LOCALIZ AND AUX.BK_DATA<='" + DTOS(_dUlMes) + "')),0) AS [BK_QINI], " + _cEnt
		_cQuery += "	ISNULL((SELECT SUM(DB_QUANT) FROM " + RetSqlName("SDB") + " SDB WHERE SDB.D_E_L_E_T_='' AND SDB.DB_FILIAL='" + xFilial("SDB") + "' AND SDB.DB_DATA>=(SELECT MAX(BK_DATA) FROM " + RetSqlName("SBK") + " AUX WHERE AUX.D_E_L_E_T_='' AND AUX.BK_FILIAL='" + xFilial("SBK") + "' AND AUX.BK_COD=SDB.DB_PRODUTO AND AUX.BK_LOCAL=SDB.DB_LOCAL AND AUX.BK_LOCALIZ=SDB.DB_LOCALIZ AND AUX.BK_DATA<='" + DTOS(_dUlMes) + "') AND SDB.DB_TM<='500' AND SDB.DB_ESTORNO='' AND SDB.DB_PRODUTO=SB2.B2_COD AND SDB.DB_LOCAL=SB2.B2_LOCAL),0) AS [E_DK_QUANT], " + _cEnt
		_cQuery += "	ISNULL((SELECT SUM(DB_QUANT) FROM " + RetSqlName("SDB") + " SDB WHERE SDB.D_E_L_E_T_='' AND SDB.DB_FILIAL='" + xFilial("SDB") + "' AND SDB.DB_DATA>=(SELECT MAX(BK_DATA) FROM " + RetSqlName("SBK") + " AUX WHERE AUX.D_E_L_E_T_='' AND AUX.BK_FILIAL='" + xFilial("SBK") + "' AND AUX.BK_COD=SDB.DB_PRODUTO AND AUX.BK_LOCAL=SDB.DB_LOCAL AND AUX.BK_LOCALIZ=SDB.DB_LOCALIZ AND AUX.BK_DATA<='" + DTOS(_dUlMes) + "') AND SDB.DB_TM>'500' AND SDB.DB_ESTORNO='' AND SDB.DB_PRODUTO=SB2.B2_COD AND SDB.DB_LOCAL=SB2.B2_LOCAL),0) AS [S_DK_QUANT], " + _cEnt
		_cQuery += "	ISNULL((SELECT SUM(DA_SALDO) FROM " + RetSqlName("SDA") + " SDA WHERE SDA.D_E_L_E_T_='' AND SDA.DA_FILIAL='" + xFilial("SDA") + "' AND SDA.DA_DATA>=(SELECT MAX(BK_DATA) FROM " + RetSqlName("SBK") + " AUX WHERE AUX.D_E_L_E_T_='' AND AUX.BK_FILIAL='" + xFilial("SBK") + "' AND AUX.BK_COD=SDA.DA_PRODUTO AND AUX.BK_LOCAL=SDA.DA_LOCAL AND AUX.BK_DATA<='" + DTOS(_dUlMes) + "') AND SDA.DA_PRODUTO=SB2.B2_COD AND SDA.DA_LOCAL=SB2.B2_LOCAL),0) AS [DA_SALDO], " + _cEnt
	EndIf
	
	_cQuery += "	ISNULL((SELECT TOP 1 B9_QINI FROM " + RetSqlName("SB9") + " SB9 WHERE SB9.D_E_L_E_T_='' AND SB9.B9_FILIAL='" + xFilial("SB9") + "' AND SB9.B9_COD=B1_COD AND B9_LOCAL=B2_LOCAL AND B9_DATA>='" + DTOS(_dUlMes) + "' ORDER BY B9_DATA),0) AS [B9_QINI], " + _cEnt		
	_cQuery += "	ISNULL((SELECT ISNULL(SUM(D3_QUANT),0) FROM " + RetSqlName("SD3") + " SD3 WHERE SD3.D_E_L_E_T_='' AND SD3.D3_FILIAL='" + xFilial("SD3") + "' AND SD3.D3_EMISSAO>='" + DTOS(_dUlMes) + "' AND SD3.D3_COD=SB2.B2_COD AND D3_LOCAL=SB2.B2_LOCAL AND D3_TM<='500' AND D3_ESTORNO='') + (SELECT ISNULL(SUM(D1_QUANT),0) FROM " + RetSqlName("SD1") + "  SD1 INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD1.D_E_L_E_T_='' AND SD1.D1_FILIAL='" + xFilial("SD1") + "' AND SD1.D1_EMISSAO>='" + DTOS(_dUlMes) + "' AND SD1.D1_COD=SB2.B2_COD AND SD1.D1_LOCAL=SB2.B2_LOCAL AND SF4.D_E_L_E_T_='' AND SF4.F4_CODIGO=SD1.D1_TES AND SF4.F4_ESTOQUE='S' AND SF4.F4_FILIAL='" + xFilial("SF4") + "'),0) AS [D1_QUANT], " + _cEnt
	_cQuery += "	ISNULL((SELECT ISNULL(SUM(D3_QUANT),0) FROM " + RetSqlName("SD3") + " SD3 WHERE SD3.D_E_L_E_T_='' AND SD3.D3_FILIAL='" + xFilial("SD3") + "' AND SD3.D3_EMISSAO>='" + DTOS(_dUlMes) + "' AND SD3.D3_COD=SB2.B2_COD AND D3_LOCAL=SB2.B2_LOCAL AND D3_TM>'500' AND D3_ESTORNO='') + (SELECT ISNULL(SUM(D2_QUANT),0) FROM " + RetSqlName("SD2") + "  SD2 INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND SD2.D2_EMISSAO>='" + DTOS(_dUlMes) + "' AND SD2.D2_COD=SB2.B2_COD AND SD2.D2_LOCAL=SB2.B2_LOCAL AND SF4.D_E_L_E_T_='' AND SF4.F4_CODIGO=SD2.D2_TES AND SF4.F4_ESTOQUE='S' AND SF4.F4_FILIAL='" + xFilial("SF4") + "'),0) AS [D2_QUANT], " + _cEnt
	_cQuery += "    B1_DESC, B1_GRUPO, B1_TIPO FROM " + RetSqlName("SB1") + " SB1 " + _cEnt
	_cQuery += "INNER JOIN " + RetSqlName("SB2") + " SB2 " + _cEnt
	_cQuery += "ON SB1.B1_COD=SB2.B2_COD " + _cEnt
	_cQuery += "AND SB1.D_E_L_E_T_='' " + _cEnt
	_cQuery += "AND SB2.D_E_L_E_T_='' " + _cEnt
	_cQuery += "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' " + _cEnt
	_cQuery += "AND SB2.B2_FILIAL='" + xFilial("SB2") + "' " + _cEnt
	_cQuery += "AND SB2.B2_LOCAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + _cEnt
	_cQuery += "AND SB1.B1_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnt
	_cQuery += "AND SB1.B1_GRUPO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + _cEnt
	_cQuery += "AND SB1.B1_TIPO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	*/
	
	_cQuery := "SELECT " + _cEnt
	_cQuery += "	B1_COD, " + _cEnt
	_cQuery += "	B1_MSBLQL, " + _cEnt
	_cQuery += "	B1_RASTRO, " + _cEnt
	_cQuery += "	B1_LOCALIZ, " + _cEnt
	_cQuery += "	B2_LOCAL, " + _cEnt
	_cQuery += "	B2_QATU, " + _cEnt
	
	If MV_PAR09 == 1 //Considera lote
		_cQuery += "	ISNULL((SELECT SUM(B8_SALDO) FROM " + RetSqlName("SB8") + " SB8 WHERE SB8.D_E_L_E_T_='' AND SB8.B8_FILIAL='" + xFilial("SB8") + "' AND SB8.B8_PRODUTO=SB1.B1_COD AND SB8.B8_LOCAL=SB2.B2_LOCAL),0) AS [B8_SALDO], " + _cEnt
		_cQuery += "	ISNULL((SELECT SUM(SBJ.BJ_QINI) FROM " + RetSqlName("SBJ") + " SBJ WHERE SBJ.D_E_L_E_T_='' AND SBJ.BJ_FILIAL='" + xFilial("SBJ") + "' AND SBJ.BJ_COD=SB2.B2_COD AND SBJ.BJ_LOCAL=SB2.B2_LOCAL AND BJ_DATA='" + DTOS(_dUlMes) + "'),0) AS [BJ_QINI], " + _cEnt
		_cQuery += "	ISNULL((SELECT SUM(D5_QUANT) FROM " + RetSqlName("SD5") + " SD5 WHERE SD5.D_E_L_E_T_='' AND SD5.D5_FILIAL='" + xFilial("SD5") + "' AND SD5.D5_DATA>='" + DTOS(_dUlMes) + "' AND SD5.D5_ORIGLAN<='500' AND SD5.D5_ESTORNO='' AND SD5.D5_PRODUTO=SB2.B2_COD AND SD5.D5_LOCAL=SB2.B2_LOCAL),0) AS [E_D5_QUANT], " + _cEnt
		_cQuery += "	ISNULL((SELECT SUM(D5_QUANT) FROM " + RetSqlName("SD5") + " SD5 WHERE SD5.D_E_L_E_T_='' AND SD5.D5_FILIAL='" + xFilial("SD5") + "' AND SD5.D5_DATA>='" + DTOS(_dUlMes) + "' AND SD5.D5_ORIGLAN >'500' AND SD5.D5_ESTORNO='' AND SD5.D5_PRODUTO=SB2.B2_COD AND SD5.D5_LOCAL=SB2.B2_LOCAL),0) AS [S_D5_QUANT], " + _cEnt
	EndIf

	If MV_PAR10 == 1 //Considera endereÁo	
		_cQuery += "	ISNULL((SELECT SUM(BF_QUANT) FROM " + RetSqlName("SBF") + " SBF WHERE SBF.D_E_L_E_T_='' AND SBF.BF_FILIAL='" + xFilial("SBF") + "' AND SBF.BF_PRODUTO=SB1.B1_COD AND SBF.BF_LOCAL=SB2.B2_LOCAL),0) AS [BF_QUANT], " + _cEnt	
		_cQuery += "	ISNULL((SELECT SUM(SBK.BK_QINI) FROM " + RetSqlName("SBK") + " SBK WHERE SBK.D_E_L_E_T_='' AND SBK.BK_FILIAL='" + xFilial("SBK") + "' AND SBK.BK_COD=SB2.B2_COD AND SBK.BK_LOCAL=SB2.B2_LOCAL AND BK_DATA='" + DTOS(_dUlMes) + "'),0) AS [BK_QINI], " + _cEnt
		_cQuery += "	ISNULL((SELECT SUM(DB_QUANT) FROM " + RetSqlName("SDB") + " SDB WHERE SDB.D_E_L_E_T_='' AND SDB.DB_FILIAL='" + xFilial("SDB") + "' AND SDB.DB_DATA>='" + DTOS(_dUlMes) + "' AND SDB.DB_TM<='500' AND SDB.DB_ESTORNO='' AND SDB.DB_PRODUTO=SB2.B2_COD AND SDB.DB_LOCAL=SB2.B2_LOCAL),0) AS [E_DK_QUANT], " + _cEnt
		_cQuery += "	ISNULL((SELECT SUM(DB_QUANT) FROM " + RetSqlName("SDB") + " SDB WHERE SDB.D_E_L_E_T_='' AND SDB.DB_FILIAL='" + xFilial("SDB") + "' AND SDB.DB_DATA>='" + DTOS(_dUlMes) + "' AND SDB.DB_TM>'500' AND SDB.DB_ESTORNO='' AND SDB.DB_PRODUTO=SB2.B2_COD AND SDB.DB_LOCAL=SB2.B2_LOCAL),0) AS [S_DK_QUANT], " + _cEnt
		_cQuery += "	ISNULL((SELECT SUM(DA_SALDO) FROM " + RetSqlName("SDA") + " SDA WHERE SDA.D_E_L_E_T_='' AND SDA.DA_FILIAL='" + xFilial("SDA") + "' AND SDA.DA_DATA>='" + DTOS(_dUlMes) + "' AND SDA.DA_PRODUTO=SB2.B2_COD AND SDA.DA_LOCAL=SB2.B2_LOCAL),0) AS [DA_SALDO], " + _cEnt
	EndIf
		
	_cQuery += "	ISNULL((SELECT TOP 1 B9_QINI FROM " + RetSqlName("SB9") + " SB9 WHERE SB9.D_E_L_E_T_='' AND SB9.B9_FILIAL='" + xFilial("SB9") + "' AND SB9.B9_COD=B1_COD AND B9_LOCAL=B2_LOCAL AND B9_DATA>='" + DTOS(_dUlMes) + "' ORDER BY B9_DATA),0) AS [B9_QINI], " + _cEnt
	_cQuery += "	ISNULL((SELECT ISNULL(SUM(D3_QUANT),0) FROM " + RetSqlName("SD3") + " SD3 WHERE SD3.D_E_L_E_T_='' AND SD3.D3_FILIAL='" + xFilial("SD3") + "' AND SD3.D3_EMISSAO>='" + DTOS(_dUlMes) + "' AND SD3.D3_COD=SB2.B2_COD AND D3_LOCAL=SB2.B2_LOCAL AND D3_TM<='500' AND D3_ESTORNO='') + (SELECT ISNULL(SUM(D1_QUANT),0) FROM " + RetSqlName("SD1") + "  SD1 INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD1.D_E_L_E_T_='' AND SD1.D1_FILIAL='" + xFilial("SD1") + "' AND SD1.D1_EMISSAO>='" + DTOS(_dUlMes) + "' AND SD1.D1_COD=SB2.B2_COD AND SD1.D1_LOCAL=SB2.B2_LOCAL AND SF4.D_E_L_E_T_='' AND SF4.F4_CODIGO=SD1.D1_TES AND SF4.F4_ESTOQUE='S' AND SF4.F4_FILIAL='" + xFilial("SF4") + "'),0) AS [D1_QUANT], " + _cEnt
	_cQuery += "	ISNULL((SELECT ISNULL(SUM(D3_QUANT),0) FROM " + RetSqlName("SD3") + " SD3 WHERE SD3.D_E_L_E_T_='' AND SD3.D3_FILIAL='" + xFilial("SD3") + "' AND SD3.D3_EMISSAO>='" + DTOS(_dUlMes) + "' AND SD3.D3_COD=SB2.B2_COD AND D3_LOCAL=SB2.B2_LOCAL AND D3_TM>'500' AND D3_ESTORNO='') + (SELECT ISNULL(SUM(D2_QUANT),0) FROM " + RetSqlName("SD2") + "  SD2 INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D_E_L_E_T_='' AND SD2.D2_FILIAL='" + xFilial("SD2") + "' AND SD2.D2_EMISSAO>='" + DTOS(_dUlMes) + "' AND SD2.D2_COD=SB2.B2_COD AND SD2.D2_LOCAL=SB2.B2_LOCAL AND SF4.D_E_L_E_T_='' AND SF4.F4_CODIGO=SD2.D2_TES AND SF4.F4_ESTOQUE='S' AND SF4.F4_FILIAL='" + xFilial("SF4") + "'),0) AS [D2_QUANT], " + _cEnt
	_cQuery += "    B1_DESC, B1_GRUPO, B1_TIPO FROM " + RetSqlName("SB1") + " SB1 " + _cEnt
	_cQuery += "INNER JOIN " + RetSqlName("SB2") + " SB2 " + _cEnt
	_cQuery += "ON SB1.B1_COD=SB2.B2_COD " + _cEnt
	_cQuery += "AND SB1.D_E_L_E_T_='' " + _cEnt
	_cQuery += "AND SB2.D_E_L_E_T_='' " + _cEnt
	_cQuery += "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' " + _cEnt
	_cQuery += "AND SB2.B2_FILIAL='" + xFilial("SB2") + "' " + _cEnt
	_cQuery += "AND SB2.B2_LOCAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + _cEnt
	_cQuery += "AND SB1.B1_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + _cEnt
	_cQuery += "AND SB1.B1_GRUPO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + _cEnt
	_cQuery += "AND SB1.B1_TIPO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	
	//Crio tabela tempor·ria com o resultado da consulta no banco de dados
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.F.)
	
	dbSelectArea(_cAlias)
		
	While (_cAlias)->(!EOF())

		IncProc("Processando o produto: " + AllTrim((_cAlias)->B1_COD) + "...")
		
		_aAux	:= {}		
		_cResumo:= ""
		
		AAdd(_aAux,(_cAlias)->B1_COD)
		AAdd(_aAux,(_cAlias)->B1_DESC)
		AAdd(_aAux,(_cAlias)->B2_LOCAL)
		AAdd(_aAux,(_cAlias)->B1_GRUPO)
		AAdd(_aAux,(_cAlias)->B1_TIPO)		
		AAdd(_aAux,IIF((_cAlias)->B1_MSBLQL=="1","Sim","N„o"))
		
		If (_cAlias)->B1_MSBLQL=="1" .And. (_cAlias)->B2_QATU<>0
			_cResumo += (IIF(Empty(_cResumo),"",", ")+"PRODUTO BLOQUEADO COM SALDO")
		EndIf
		
		AAdd(_aAux,IIF((_cAlias)->B1_RASTRO=="L","Lote",IIF((_cAlias)->B1_RASTRO=="S","Sublote","N„o controla")))
		AAdd(_aAux,IIF((_cAlias)->B1_LOCALIZ=="S","Sim","N„o"))
		AAdd(_aAux,(_cAlias)->B2_QATU)
		
		If (_cAlias)->B2_QATU<0
			_cResumo += (IIF(Empty(_cResumo),"",", ")+"SALDO NEGATIVO")
		EndIf
		
		If MV_PAR09==1 //Considera lote
			If (_cAlias)->B1_RASTRO $ ("LS") .And. (_cAlias)->B2_QATU<>(_cAlias)->B8_SALDO
				_cResumo += (IIF(Empty(_cResumo),"",", ")+"SALDO SB2XSB8 DIVERGENTE")
			EndIf
			AAdd(_aAux,(_cAlias)->B8_SALDO)
		EndIf
		
		If MV_PAR10==1 //Considera endereÁo
			If (_cAlias)->B1_LOCALIZ == ("S") .And. (_cAlias)->B2_QATU<>((_cAlias)->BF_QUANT + (_cAlias)->DA_SALDO)
				_cResumo += (IIF(Empty(_cResumo),"",", ")+"SALDO SB2XSBF+SDA DIVERGENTE")
			EndIf
			AAdd(_aAux,(_cAlias)->BF_QUANT)
		EndIf
		
		If (_cAlias)->B9_QINI < 0
			_cResumo += (IIF(Empty(_cResumo),"",", ")+"SALDO INICIAL NEGATIVO")
		EndIf
		
		_nB9Qini := (_cAlias)->B9_QINI
		
		//Avalio o saldo inicial, com data diferente do fechamento
		If MV_PAR12 == 2 .And. _dUlMes <> SuperGetMV("MV_ULMES",,"20000101")
			_nB9Qini := (_cAlias)->B2_QATU+(_cAlias)->D2_QUANT-(_cAlias)->D1_QUANT
		EndIf
		
		AAdd(_aAux,_nB9Qini)
		
		If MV_PAR09==1 //Considera lote
			
			_nBJQini := (_cAlias)->BJ_QINI
			
			If MV_PAR12 == 2 .And. _dUlMes <> SuperGetMV("MV_ULMES",,"20000101")
				_nBJQini := (_cAlias)->BJ_QINI+(_cAlias)->S_D5_QUANT-(_cAlias)->E_D5_QUANT
			EndIf
			
			If (_cAlias)->B1_RASTRO $ ("LS") .And. _nB9Qini<>_nBJQini .And. MV_PAR12 <> 2
				_cResumo += (IIF(Empty(_cResumo),"",", ")+"SALDO INICIAL SB2XSBJ DIVERGENTE")
			EndIf
			
			AAdd(_aAux,_nBJQini)
		EndIf
		
		If MV_PAR10==1 //Considera endereÁo
			
			_nBKQini := (_cAlias)->BK_QINI
						
			If MV_PAR12 == 2 .And. _dUlMes <> SuperGetMV("MV_ULMES",,"20000101")
				_nBKQini := (_cAlias)->BK_QINI+(_cAlias)->S_DK_QUANT-(_cAlias)->E_DK_QUANT
			EndIf
			
			If (_cAlias)->B1_LOCALIZ == ("S") .And. _nB9Qini<>_nBKQini .And. MV_PAR12 <> 2
				_cResumo += (IIF(Empty(_cResumo),"",", ")+"SALDO INICIAL SB2XSBK DIVERGENTE")
			EndIf
			
			AAdd(_aAux,_nBKQini)
		EndIf
		
		AAdd(_aAux,(_cAlias)->D1_QUANT)
		
		If MV_PAR09==1 //Considera lote
		
			If (_cAlias)->B1_RASTRO $ ("LS") .And. (_cAlias)->D1_QUANT<>(_cAlias)->E_D5_QUANT
				_cResumo += (IIF(Empty(_cResumo),"",", ")+"ENTRADAS SD1+SD3 X SD5 DIVERGENTE")
			EndIf
			
			AAdd(_aAux,(_cAlias)->E_D5_QUANT)
		EndIf
		
		If MV_PAR10==1 //Considera endereÁo
		
			If (_cAlias)->B1_LOCALIZ == ("S") .And. (_cAlias)->D1_QUANT<>(_cAlias)->E_DK_QUANT
				_cResumo += (IIF(Empty(_cResumo),"",", ")+"ENTRADAS SD1+SD3 X SDK DIVERGENTE")
			EndIf
		
			AAdd(_aAux,(_cAlias)->E_DK_QUANT)
		EndIf
		
		AAdd(_aAux,(_cAlias)->D2_QUANT)
		
		If MV_PAR09==1 //Considera lote
			
			If (_cAlias)->B1_RASTRO $ ("LS") .And. (_cAlias)->D2_QUANT<>(_cAlias)->S_D5_QUANT
				_cResumo += (IIF(Empty(_cResumo),"",", ")+"SAÕDAS SD2+SD3 X SD5 DIVERGENTE")
			EndIf
		
			AAdd(_aAux,(_cAlias)->S_D5_QUANT)
		EndIf
		
		If MV_PAR10==1 //Considera endereÁo

			If (_cAlias)->B1_LOCALIZ == ("S") .And. (_cAlias)->D2_QUANT<>(_cAlias)->S_DK_QUANT
				_cResumo += (IIF(Empty(_cResumo),"",", ")+"SAÕDAS SD2+SD3 X SDK DIVERGENTE")
			EndIf
			
			AAdd(_aAux,(_cAlias)->S_DK_QUANT)
			
			If (_cAlias)->B1_LOCALIZ == ("S") .And. (_cAlias)->DA_SALDO>0
				_cResumo += (IIF(Empty(_cResumo),"",", ")+"SALDO PENDENTE DE ENDERE«AMENTO")
			EndIf
			
			AAdd(_aAux,(_cAlias)->DA_SALDO	)
		EndIf
		
		AAdd(_aAux,_cResumo)
		
		If MV_PAR11 == 2 //Imprime somente inconsistÍncias
			If !Empty(_cResumo)
				oExcel:AddRow(_cSheet2, _cTitulo2, _aAux )
			EndIf
		Else
			oExcel:AddRow(_cSheet2, _cTitulo2, _aAux )
		EndIf
		
		dbSelectArea(_cAlias)
		(_cAlias)->(dbSkip())
	EndDo
	
	//Fecho a tabela tempor·ria
	dbSelectArea(_cAlias)
	(_cAlias)->(dbCloseArea())
	
Return()

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funcao	 ≥ RESTA004   ≥ Autor ≥ Adriano Leonardo    ≥ Data ≥ 18/04/16 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥FunÁ„o respons·vel pela inclus„o dos par‚metros da rotina.  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso		 ≥SIGAEST  							      	       			  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ValidPerg()

Local i := 0
Local j := 0

_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs :={}

AADD(aRegs,{cPerg,"01","De armazÈm?"		,"","","mv_ch1","C",02,01,0,"G","","MV_PAR01",""			,"","","","",""						,"","","","","","","","","","","","","","","","","","",""	,"",""})
AADD(aRegs,{cPerg,"02","AtÈ armazÈm?"		,"","","mv_ch2","C",02,01,0,"G","","MV_PAR02",""			,"","","","",""						,"","","","","","","","","","","","","","","","","","",""	,"",""})
AADD(aRegs,{cPerg,"03","De produto?"		,"","","mv_ch3","C",15,01,0,"G","","MV_PAR03",""			,"","","","",""						,"","","","","","","","","","","","","","","","","","","SB1","",""})
AADD(aRegs,{cPerg,"04","AtÈ produto?"		,"","","mv_ch4","C",15,01,0,"G","","MV_PAR04",""			,"","","","",""						,"","","","","","","","","","","","","","","","","","","SB1","",""})
AADD(aRegs,{cPerg,"05","De grupo?"			,"","","mv_ch5","C",04,01,0,"G","","MV_PAR05",""			,"","","","",""						,"","","","","","","","","","","","","","","","","","","SBM","",""})
AADD(aRegs,{cPerg,"06","AtÈ grupo?"			,"","","mv_ch6","C",04,01,0,"G","","MV_PAR06",""			,"","","","",""						,"","","","","","","","","","","","","","","","","","","SBM","",""})
AADD(aRegs,{cPerg,"07","De tipo?"			,"","","mv_ch7","C",02,01,0,"G","","MV_PAR07",""			,"","","","",""						,"","","","","","","","","","","","","","","","","","","02"	,"",""})
AADD(aRegs,{cPerg,"08","AtÈ tipo?"			,"","","mv_ch8","C",02,01,0,"G","","MV_PAR08",""			,"","","","",""						,"","","","","","","","","","","","","","","","","","","02"	,"",""})
AADD(aRegs,{cPerg,"09","Considera Lote?"	,"","","mv_ch9","C",01,01,0,"C","","MV_PAR09","Sim"			,"","","","","N„o"					,"","","","","","","","","","","","","","","","","","",""	,"",""})
AADD(aRegs,{cPerg,"10","Considera EndereÁo?","","","mv_cha","C",01,01,0,"C","","MV_PAR10","Sim"			,"","","","","N„o"					,"","","","","","","","","","","","","","","","","","",""	,"",""})
AADD(aRegs,{cPerg,"11","Exibir?"			,"","","mv_chb","C",01,01,0,"C","","MV_PAR11","Todos"		,"","","","","Divergencias"			,"","","","","","","","","","","","","","","","","","",""	,"",""})
AADD(aRegs,{cPerg,"12","Saldos a partir de?","","","mv_chc","C",01,01,0,"C","","MV_PAR12","Fechamento"	,"","","","","Dt. abaixo"			,"","","","","","","","","","","","","","","","","","",""	,"",""})
AADD(aRegs,{cPerg,"13","Considera data?"	,"","","mv_chd","D",08,01,0,"G","","MV_PAR13",""			,"","","","",""						,"","","","","","","","","","","","","","","","","","",""	,"",""})

For i:=1 To Len(aRegs)
	If !MsSeek(cPerg+aRegs[i,2],.T.,.F.)
		RecLock("SX1",.T.)
		For j:=1 To FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else
				Exit
			EndIf
		Next
		MsUnlock()
	EndIf
Next
dbSelectArea(_sAlias)

Return()

Static Function Geraxls(lEnd)

Local _nPosPar		:= 0
Local _cFileTMP		:= ""
Local _cFile		:= ""
Private oExcel		:= FWMSEXCEL():New()
Private _cSheet1	:= "Par‚metros"
Private _cSheet2	:= "ConferÍncia de Saldos"
Private _aPar		:= {}

//Sheet1 - Par‚metros
oExcel:AddWorkSheet(_cSheet1)
oExcel:AddTable(_cSheet1,_cTitulo1)
oExcel:AddColumn(_cSheet1,_cTitulo1,"DESCRI«√O" ,1,1,.F.)
oExcel:AddColumn(_cSheet1,_cTitulo1,"CONTE⁄DO"  ,1,1,.F.)

//Localizo os par‚metros da rotina com base na tabela SX1
dbSelectArea("SX1")
dbSetOrder(1)  //Grupo + Ordem    
dbGoTop()
cPerg := PADR(cPerg,10)
If SX1->(dbSeek(cPerg))
	While !EOF() .And. SX1->X1_GRUPO==cPerg
	IncProc('Processando par‚metros.')
		
		//Adiciono os par‚metros em array auxiliar
		If SX1->X1_GSC<>'C'
			AAdd(_aPar,{ SX1->X1_PERGUNT,&(SX1->X1_VAR01) })
		Else //Localizo a descriÁ„o do par‚metro (combobox) conforme seleÁ„o
			If &(SX1->X1_VAR01)==1
				AAdd(_aPar,{ SX1->X1_PERGUNT,SX1->X1_DEF01 })
			 ElseIf &(SX1->X1_VAR01)==2
				AAdd(_aPar,{ SX1->X1_PERGUNT,SX1->X1_DEF02 })
			 ElseIf &(SX1->X1_VAR01)==3
				AAdd(_aPar,{ SX1->X1_PERGUNT,SX1->X1_DEF03 })
			 ElseIf &(SX1->X1_VAR01)==4
				AAdd(_aPar,{ SX1->X1_PERGUNT,SX1->X1_DEF04 })					
			 ElseIf &(SX1->X1_VAR01)==5
				AAdd(_aPar,{ SX1->X1_PERGUNT,SX1->X1_DEF05 })
			 EndIf
		EndIf
		
		dbSelectArea("SX1")
		dbSetOrder(1)  //Grupo + Ordem
		dbSkip()
	EndDo
EndIf

//Adiciono as linhas no Excel com base no array de par‚metros da rotina
If Len(_aPar) > 0
	For _nPosPar := 1 To Len(_aPar)
		oExcel:AddRow(_cSheet1, _cTitulo1, _aPar[_nPosPar])
	Next
EndIf
     
//Sheet 2 - Resumo de contagens
oExcel:AddWorkSheet(_cSheet2)
oExcel:AddTable(_cSheet2,_cTitulo2)

oExcel:AddColumn(_cSheet2,_cTitulo2,"PRODUTO"			,1,1,.F.)
oExcel:AddColumn(_cSheet2,_cTitulo2,"DESCRI«√O"			,1,1,.F.)
oExcel:AddColumn(_cSheet2,_cTitulo2,"ARM¡ZEM"			,1,1,.F.)
oExcel:AddColumn(_cSheet2,_cTitulo2,"GRUPO"				,1,1,.F.)
oExcel:AddColumn(_cSheet2,_cTitulo2,"TIPO"				,1,1,.F.)
oExcel:AddColumn(_cSheet2,_cTitulo2,"BLOQUEADO"			,1,1,.F.)
oExcel:AddColumn(_cSheet2,_cTitulo2,"CONTROLA LOTE"		,1,1,.F.)
oExcel:AddColumn(_cSheet2,_cTitulo2,"CONTROLA ENDERE«O"	,1,1,.F.)
oExcel:AddColumn(_cSheet2,_cTitulo2,"SALDO ATUAL"		,1,1,.T.)

If MV_PAR09==1 //Considera lote
	oExcel:AddColumn(_cSheet2,_cTitulo2,"SALDO LOTE"		,1,1,.T.)
EndIf

If MV_PAR10==1 //Considera endereÁo
	oExcel:AddColumn(_cSheet2,_cTitulo2,"SALDO ENDERE«O"	,1,1,.T.)
EndIf

oExcel:AddColumn(_cSheet2,_cTitulo2,"SALDO INICIAL"		,1,1,.T.)

If MV_PAR09==1 //Considera lote
	oExcel:AddColumn(_cSheet2,_cTitulo2,"SALDO INICIAL LOTE"		,1,1,.T.)
EndIf

If MV_PAR10==1 //Considera endereÁo
	oExcel:AddColumn(_cSheet2,_cTitulo2,"SALDO INICIAL ENDERE«O"	,1,1,.T.)
EndIf

oExcel:AddColumn(_cSheet2,_cTitulo2,"ENTRADAS ESTOQUE"	,1,1,.T.)

If MV_PAR09==1 //Considera lote
	oExcel:AddColumn(_cSheet2,_cTitulo2,"ENTRADAS LOTE"		,1,1,.T.)
EndIf

If MV_PAR10==1 //Considera endereÁo
	oExcel:AddColumn(_cSheet2,_cTitulo2,"ENTRADAS ENDERE«O"	,1,1,.T.)
EndIf

oExcel:AddColumn(_cSheet2,_cTitulo2,"SAÕDAS ESTOQUE"	,1,1,.T.)

If MV_PAR09==1 //Considera lote
	oExcel:AddColumn(_cSheet2,_cTitulo2,"SAÕDAS LOTE"		,1,1,.T.)
EndIf

If MV_PAR10==1 //Considera endereÁo
	oExcel:AddColumn(_cSheet2,_cTitulo2,"SAÕDAS ENDERE«O"	,1,1,.T.)
	oExcel:AddColumn(_cSheet2,_cTitulo2,"SALDO A ENDERE«AR"	,1,1,.T.)
EndIf

oExcel:AddColumn(_cSheet2,_cTitulo2,"RESUMO"	,1,1,.F.)

//Chamada da funÁ„o respons·vel pela seleÁ„o dos dados
MsgRun("Selecionando dados " + _cSheet2 + "... Por favor AGUARDE. ",_cTitulo2,{ || MapearSaldos()})

If lEnd
	Alert("Abortado!")
	FreeObj(oExcel)
	oExcel := NIL
	Return
EndIf

//Valida a emiss„o do relatÛrio e imprime
If _lRet
	IncProc("Abrindo Arquivo...")
	oExcel:Activate()
	_cFile := (CriaTrab(NIL, .F.) + ".xml")
	While File(_cFile)
		_cFile := (CriaTrab(NIL, .F.) + ".xml")
	EndDo
	oExcel:GetXMLFile(_cFile)
	oExcel:DeActivate()
	If !(File(_cFile))
		_cFile := ""
		Break
	EndIf
	
	_cFileTMP  := cGetFile('Arquivo Arquivo XML|*.xml','Salvar como',0,'C:\Dir\',.F.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.F.) //Define o local onde o arquivo ser· gerado
	
	//Verifico se o formato do arquivo foi definido corretamente
	If !Empty(_cFileTMP)
		If !(".XML" $ Upper(_cFileTMP))
			_cFileTmp := StrTran(_cFileTmp,'.','')
			_cFileTmp += ".xml"
		EndIf
	Else
		_cFileTMP := (GetTempPath() + _cFile)
	EndIf
	
	If !(__CopyFile(_cFile , _cFileTMP))
		fErase( _cFile )
		_cFile := ""
		Break
	EndIf
	
	fErase(_cFile)
	_cFile := _cFileTMP
	If !(File(_cFile))
		_cFile := ""
		Break
	EndIf
	
	oMsExcel:= MsExcel():New()
	oMsExcel:WorkBooks:Open(_cFile)
	oMsExcel:SetVisible(.T.)
	IncProc('RelatÛrio gerado com sucesso!')
	MsgBox('RelatÛrio gerado, por favor verifique!',_cRotina+'_05','ALERT')
	oMsExcel:= oMsExcel:Destroy()
Else
	MsgBox("N„o h· dados a serem apresentados.",_cRotina+"_06",'ALERT')
EndIf

FreeObj(oExcel)
oExcel := NIL

Return()