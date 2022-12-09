/**************
EMCTBR005
Relatório Razonete Pagar / Receber
Alexandre Antunes de Lima
12/11/2014
**************/
#Include "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "TOPCONN.CH"

USER FUNCTION EMCTBR05()

Local cPerg := "EMCTBR05  "

ValidPerg(cPerg)  // Valida a pergunta do relatorio se nao existir ele cria

Pergunte(cPerg,.T.)

If SELECT("TRB") > 0
	TRB->(DbcloseArea())
Endif

If MV_PAR10 == 1
	Processa({ || SelectPag(.F.)}, "Aguarde",,.t.)
Else
	Processa({ || SelectRec(.F.)}, "Aguarde",,.t.)
EndIf

Return

Static Function SelectPag()

_cEmp   := "Empresa: "+SM0->M0_NOME + " CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")

_cTipos := ''
If MV_PAR09 == 1
	_cTipos:=	xFinrTipos()   //Funcao que seleciona os tipos no relatorio
EndIf

aStructure := {}

AADD( aStructure, {'ARQUIVO'   ,'C',03,0} )
AADD( aStructure, {'Filial','C',02,0} )
AADD( aStructure, {'DT_MOV','D',08,0} )
AADD( aStructure, {'FORNECE','C',06,0} )
AADD( aStructure, {'LOJA','C',02,0} )
AADD( aStructure, {'NOMFORN','C',40,0} )
AADD( aStructure, {'DOC','C',09,0} )
AADD( aStructure, {'SERIE','C',03,0} )
AADD( aStructure, {'PARCELA','C',03,0} )
AADD( aStructure, {'TIPO','C',03,0} )
AADD( aStructure, {'CONTA','C',10,0} )
AADD( aStructure, {'NATUREZA','C',10,0} )
AADD( aStructure, {'VALORPAG','N',14,2} )
AADD( aStructure, {'VALORCOMP','N',14,2} )
AADD( aStructure, {'VLRCONTAB','N',14,2} )

CriaTMP( aStructure, "TRB" )

cPath := cGetFile("\","Selecione o diretorio p/ gravação da planilha em excel ",,,,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)

// Titulos no Contas a Pagar SE2

cQuery := ""
cQuery+= "SELECT E2_FILIAL FILIAL, E2_EMIS1 EMISSAO,E2_NUM DOC,E2_PREFIXO SERIE,E2_FORNECE FORNECE,E2_LOJA LOJA,E2_NATUREZ NATUREZA,E2_TIPO TIPO,A2_CONTA CONTA,E2_FATURA FATURA,E2_ORIGEM ORIGEM,E2_MULTNAT MULTNAT,SUM(E2_VALOR)  VALOR "
cQuery+= "FROM "+RetSqlName("SE2")+" E2 "
If SM0->M0_CODIGO $ "01_05_06"
	cQuery += "LEFT JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_COD = E2.E2_FORNECE AND SA2.A2_LOJA = E2.E2_LOJA  AND SA2.D_E_L_E_T_ = ' '  "
Else
	cQuery += "LEFT JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = E2.E2_FILIAL AND SA2.A2_COD = E2.E2_FORNECE AND SA2.A2_LOJA = E2.E2_LOJA  AND SA2.D_E_L_E_T_ = ' '  "
EndIf
cQuery += "WHERE E2.E2_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E2.D_E_L_E_T_ = ' '  "
If MV_PAR09 == 1
	cQuery += "AND E2.E2_TIPO IN "+_cTipos
EndIf
cQuery += "AND E2.E2_NATUREZ NOT IN ('21000','21001','21002','21003','21004','21005','21009','21010','21011','21014','21016','21018') "
cQuery += "AND E2.E2_EMIS1 BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
cQuery += "AND E2.E2_FORNECE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
cQuery += "AND SA2.A2_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
cQuery += "AND E2.E2_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
cQuery += "GROUP BY E2_FILIAL,E2_EMIS1,E2_NUM,E2_PREFIXO,E2_FORNECE,E2_LOJA,E2_NATUREZ,E2_TIPO,A2_CONTA,E2_FATURA,E2_ORIGEM,E2_MULTNAT  "

If SELECT("TRBSE2I") > 0
	TRBSE2I->(DbcloseArea())
Endif

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE2I", .T., .T.)
_cRecnoFin := STRZERO(RecCount(),9)
dbGoTop()
ProcRegua(LastRec())

While !Eof()

	If ALLTRIM(TRBSE2I->DOC) ==	"000036037"
		_NALE:= 0
	ENDIF
	
	If TRBSE2I->FORNECE == "001433" .And. TRBSE2I->TIPO == "BOL" .And. SM0->M0_CODIGO $ "01" //Esta condicao existe pq tem outros titulo de serie diferente que tem que sair para esse fornecedor
		dbSkip()
		Loop
	EndIf
	
	_cRecnoIni := str(recno())
	
	IncProc("Montando arquivo de entrada por contas a pagar " + _cRecnoIni)
	
	If TRBSE2I->SERIE <> "CTE" .AND. TRBSE2I->TIPO <> "FT " .AND. ALLTRIM(TRBSE2I->FATURA) <> "NOTFAT" .AND. ALLTRIM(TRBSE2I->ORIGEM) <> "FINA290"
		
		cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01CR = '"+TRBSE2I->DOC+ "' AND CT2.CT2_AT03CR = '"+TRBSE2I->FORNECE +"' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE2I->EMISSAO+"'  "
		cQuery += "AND CT2_CREDIT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
		
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->ARQUIVO	:=	"SE2"
		TRB->FILIAL			:=	TRBSE2I->FILIAL
		TRB->DT_MOV		:=	STOD(TRBSE2I->EMISSAO)
		TRB->NATUREZA	:= TRBSE2I->NATUREZA
		TRB->FORNECE	:=	TRBSE2I->FORNECE
		TRB->LOJA			:=	TRBSE2I->LOJA
		If SM0->M0_CODIGO $ "01_05"
			TRB->NOMFORN	:=	Posicione("SA2",1,xFilial("SA2")+TRBSE2I->FORNECE+TRBSE2I->LOJA,"A2_NOME")
		Else
			TRB->NOMFORN	:=	Posicione("SA2",1,TRBSE2I->FILIAL+TRBSE2I->FORNECE+TRBSE2I->LOJA,"A2_NOME")
		EndIf
		TRB->DOC			:=	TRBSE2I->DOC
		TRB->SERIE			:=	TRBSE2I->SERIE
		TRB->CONTA		:=	TRBSE2I->CONTA
		TRB->TIPO			:=	TRBSE2I->TIPO
		TRB->VALORCOMP	+=	TRBSE2I->VALOR
		If TRBSE2I->VALOR <> TRBCT2->VALOR .AND. TRBCT2->VALOR <> 0
			TRB->VLRCONTAB +=	TRBSE2I->VALOR
		ELSE
			TRB->VLRCONTAB +=	TRBCT2->VALOR
		ENDIF
		MsUnLock()
	EndIf
	
	dbSelectArea("TRBSE2I")
	
	dbSkip()
	
End

// Movimento de Pagamento SE5
cQuery := ""
If SM0->M0_CODIGO $ "02_05" //Foi incluido esta linha pq o valor do juros nao pode somar com o valor principal para esta empresa, diferença no relatorio.
	cQuery += "SELECT E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR FORNECE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_PARCELA PARCELA,E5_NATUREZ NATUREZA,A2_CONTA CONTA,E2_NUM,E2_MULTNAT,E5_MOTBX,E5_SEQ,E5_DOCUMEN,E5_TIPODOC,SUM(E5_VALOR-E5_VLMULTA-E5_VLJUROS)  VALOR,SUM(E5_VLACRES) VLACRES,SUM(E5_VLDECRE) VLDECRE FROM "+RetSqlName("SE5")+" E5 "
Else
	cQuery += "SELECT E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR FORNECE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_PARCELA PARCELA,E5_NATUREZ NATUREZA,A2_CONTA CONTA,E2_NUM,E2_MULTNAT,E5_MOTBX,E5_SEQ,E5_DOCUMEN,E5_TIPODOC,SUM(E5_VALOR-E5_VLMULTA)  VALOR,SUM(E5_VLACRES) VLACRES,SUM(E5_VLDECRE) VLDECRE FROM "+RetSqlName("SE5")+" E5 "
EndIf
If SM0->M0_CODIGO $ "01_05_06"
	cQuery += "LEFT JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_COD = E5.E5_CLIFOR AND SA2.A2_LOJA = E5.E5_LOJA AND SA2.D_E_L_E_T_ = ' '  "
Else
	cQuery += "LEFT JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = E5.E5_FILIAL AND SA2.A2_COD = E5.E5_CLIFOR AND SA2.A2_LOJA = E5.E5_LOJA AND SA2.D_E_L_E_T_ = ' '  "
EndIf
cQuery += "LEFT JOIN "+RetSqlName("SE2")+" SE2 ON SE2.E2_FILIAL = E5.E5_FILIAL AND SE2.E2_FORNECE = E5.E5_CLIFOR AND SE2.E2_LOJA = E5.E5_LOJA AND SE2.E2_PREFIXO = E5.E5_PREFIXO AND SE2.E2_NUM = E5.E5_NUMERO AND SE2.E2_PARCELA = E5.E5_PARCELA AND SE2.E2_TIPO = E5.E5_TIPO AND SE2.D_E_L_E_T_ = ' '  "
cQuery += "WHERE E5.E5_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E5.D_E_L_E_T_ = ' '  "
cQuery += "AND E5.E5_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  AND E5.E5_RECPAG = 'P'  AND E5.E5_CLIFOR <> ' ' AND E5.E5_NUMERO <> ' ' "
cQuery += "AND E5_SITUACA  NOT IN ('C') "
If SM0->M0_CODIGO $ "01_02"
	cQuery += "AND E5_TIPODOC NOT IN ('MT')  "
Else
	cQuery += "AND E5_TIPODOC NOT IN ('JR','MT','DC')  "
	cQuery += "AND E5_MOTBX <> 'FAT' "
EndIf
cQuery += "AND E5.E5_CLIFOR BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
cQuery += "AND E5.E5_NATUREZ NOT IN ('21000','21001','21002','21003','21004','21005','21009','21010','21011','21014','21016','21018') "
If MV_PAR09 == 1
	cQuery += "AND E5.E5_TIPO IN "+_cTipos
EndIf
cQuery += "AND E5.E5_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
cQuery += "AND SA2.A2_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_CLIFOR,E5_LOJA,E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_PARCELA,E5_NATUREZ,A2_CONTA,E2_NUM,E2_MULTNAT,E5_MOTBX,E5_SEQ,E5_DOCUMEN,E5_TIPODOC  "

If SELECT("TRBSE5") > 0
	TRBSE5->(DbcloseArea())
Endif

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5", .T., .T.)
dbGoTop()
ProcRegua(LastRec())

While !Eof()

	If TRBSE5->FORNECE == "EMP105" .And. TRBSE5->TIPO == "FT " .And. SM0->M0_CODIGO $ "02" .And. TRBSE5->FILIAL == '03' .And. TRBSE5->DOC == '009422328'  //Esta condicao existe pq nao deve sair no relatorio diferenca da entrada em 23/02/2016
		dbSkip()
		Loop
	EndIf
	If TRBSE5->FORNECE == "EMP105" .And. TRBSE5->TIPO == "FT " .And. SM0->M0_CODIGO $ "02" .And. TRBSE5->FILIAL == '03' .And. TRBSE5->DOC == '006932696'  //Esta condicao existe pq nao deve sair no relatorio diferenca da entrada em 23/02/2016
		dbSkip()
		Loop
	EndIf
	If TRBSE5->FORNECE == "EMP105" .And. TRBSE5->TIPO == "FT " .And. SM0->M0_CODIGO $ "02" .And. TRBSE5->FILIAL == '03' .And. TRBSE5->DOC == '007644598'  //Esta condicao existe pq nao deve sair no relatorio diferenca da entrada em 23/02/2016
		dbSkip()
		Loop
	EndIf

	If TRBSE5->DOC == "160606001"
		_NALE := 0
	EndIf
	
	If SM0->M0_CODIGO $ "01_02"
		If !TRBSE5->E5_TIPODOC $ 'JR/DC' .And. TRBSE5->E5_MOTBX == 'FAT'
			dbSkip()
			Loop
		EndIf
		If TRBSE5->E5_TIPODOC $ 'JR/DC' .And. !TRBSE5->E5_MOTBX  $ 'FAT/LIQ'
			dbSkip()
			Loop
		EndIf
	EndIf

	If TRBSE5->FORNECE == "001433" .And. TRBSE5->TIPO == "BOL" .And. SM0->M0_CODIGO $ "01" //Esta condicao existe pq tem outros titulo de serie diferente que tem que sair para esse fornecedor
		dbSkip()
		Loop
	EndIf

	If TRBSE5->E5_MOTBX $ "LIQ" .And. !TRBSE5->E5_TIPODOC $ 'JR/DC' //alterado por alexandre em 15/12/2015 porque todos os titulos a pagar com motivo da baixa tipo LIQ nao deve sair no relatorio.
		dbSkip()
		Loop
	EndIf
	
	// Movimento Bancario SE5
	cQuery := ""
	cQuery += "SELECT E5_FILIAL ,E5_TIPO,E5_NATUREZ ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
	cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
	cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->FORNECE+"'  "
	cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
	cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
	cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
	cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
	cQuery += "AND E5.E5_SEQ = '"+TRBSE5->E5_SEQ+"'  "
	cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->E5_MOTBX+"'  "
	cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
	cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->PARCELA+"'  "
	cQuery += "AND E5.E5_TIPODOC = 'ES'  "
	cQuery += "GROUP BY E5_FILIAL,E5_TIPO,E5_NATUREZ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC "
	
	If SELECT("TRBSE5ES") > 0
		TRBSE5ES->(DbcloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5ES", .T., .T.)
	
	If TRBSE5ES->VALOR <> 0
		dbSelectArea("TRBSE5")
		dbSkip()
		IncProc()
		Loop
	EndIf
	
	_nJuros := 0
	
	If SM0->M0_CODIGO $ "01_02"
		If TRBSE5->E5_TIPODOC <> "JR"
			// Movimento Bancario SE5
			cQuery := ""
			cQuery += "SELECT E5_FILIAL ,E5_TIPO,E5_NATUREZ ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
			cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
			cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->FORNECE+"'  "
			cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
			cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
			cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
			cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
			If SM0->M0_CODIGO $ "02"
			Else
				cQuery += "AND E5.E5_SEQ = '"+TRBSE5->E5_SEQ+"'  "
			EndIf
			cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->E5_MOTBX+"'  "
			cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
			cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->PARCELA+"'  "
			cQuery += "AND E5.E5_TIPODOC = 'JR'  "
			cQuery += "GROUP BY E5_FILIAL,E5_TIPO,E5_NATUREZ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC "

			If SELECT("TRBSE5JR") > 0
				TRBSE5JR->(DbcloseArea())
			Endif
	
			dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5JR", .T., .T.)
	
			_nJuros := TRBSE5JR->VALOR

		EndIf
	Else
			// Movimento Bancario SE5
		cQuery := ""
		cQuery += "SELECT E5_FILIAL ,E5_TIPO,E5_NATUREZ ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
		cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
		cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->FORNECE+"'  "
		cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
		cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
		cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
		cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
		If SM0->M0_CODIGO $ "02"
		Else
			cQuery += "AND E5.E5_SEQ = '"+TRBSE5->E5_SEQ+"'  "
		EndIf
		cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->E5_MOTBX+"'  "
		cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
		cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->PARCELA+"'  "
		cQuery += "AND E5.E5_TIPODOC = 'JR'  "
		cQuery += "GROUP BY E5_FILIAL,E5_TIPO,E5_NATUREZ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC "

		If SELECT("TRBSE5JR") > 0
			TRBSE5JR->(DbcloseArea())
		Endif
	
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5JR", .T., .T.)
	
		_nJuros := TRBSE5JR->VALOR

	EndIf	

	_nDescont := 0
	
	If SM0->M0_CODIGO $ "01_02"
		If TRBSE5->E5_TIPODOC <> "DC"
			// Movimento Bancario SE5
			cQuery := ""
			cQuery += "SELECT E5_FILIAL ,E5_DATA,E5_TIPO,E5_NATUREZ ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
			cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
			cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->FORNECE+"'  "
			cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
			cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
			cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
			cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
//			If SM0->M0_CODIGO $ "02"
//			Else
				cQuery += "AND E5.E5_SEQ = '"+TRBSE5->E5_SEQ+"'  "
//			EndIf
			cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->E5_MOTBX+"'  "
			cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
			cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->PARCELA+"'  "
			cQuery += "AND E5.E5_TIPODOC = 'DC'  "
			cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_TIPO,E5_NATUREZ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC "
	
			If SELECT("TRBSE5DE") > 0
				TRBSE5DE->(DbcloseArea())
			Endif
	
			dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5DE", .T., .T.)

			_nDescont := TRBSE5DE->VALOR
		EndIf
	Else
			// Movimento Bancario SE5
			cQuery := ""
			cQuery += "SELECT E5_FILIAL ,E5_DATA,E5_TIPO,E5_NATUREZ ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
			cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
			cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->FORNECE+"'  "
			cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
			cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
			cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
			cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
			If SM0->M0_CODIGO $ "02"
			Else
				cQuery += "AND E5.E5_SEQ = '"+TRBSE5->E5_SEQ+"'  "
			EndIf
			cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->E5_MOTBX+"'  "
			cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
			cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->PARCELA+"'  "
			cQuery += "AND E5.E5_TIPODOC = 'DC'  "
			cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_TIPO,E5_NATUREZ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC "
	
			If SELECT("TRBSE5DE") > 0
				TRBSE5DE->(DbcloseArea())
			Endif
	
			dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5DE", .T., .T.)

			_nDescont := TRBSE5DE->VALOR
			
	EndIf	

	dbSelectArea("TRB")
	
	cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  = '"+TRBSE5->FILIAL + "' "
	cQuery += "AND CT2_HIST LIKE '%"+TRBSE5->DOC+"%' AND CT2.CT2_AT03DB = '"+TRBSE5->FORNECE +"' "
	cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
	cQuery += "AND CT2_DEBITO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
	cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
	
	If SELECT("TRBCT2") > 0
		TRBCT2->(DbcloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	
	IF TRBCT2->VALOR == 0
		cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL = '" +TRBSE5->FILIAL + "' "
		cQuery += "AND CT2_HIST LIKE '%"+TRBSE5->DOC+"%'"
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
		cQuery += "AND CT2_DEBITO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	ENDIF
	
	IF TRBCT2->VALOR == 0
		cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL = '" + TRBSE5->FILIAL + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+SubStr(TRBSE5->E5_DOCUMEN,4,9)+ "' AND CT2.CT2_AT03DB = '"+TRBSE5->FORNECE +"' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
		cQuery += "AND CT2_DEBITO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	
	IF TRBCT2->VALOR == 0
		cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL = '" + TRBSE5->FILIAL + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+SubStr(TRBSE5->E5_DOCUMEN,4,9)+ "' AND CT2.CT2_AT03DB = '"+SubStr(TRBSE5->E5_DOCUMEN,18,6) +"' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
		cQuery += "AND CT2_DEBITO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	
	IF TRBCT2->VALOR == 0
		cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL = '" + TRBSE5->FILIAL + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE5->DOC+ "' AND CT2.CT2_AT03DB = '"+TRBSE5->FORNECE +"' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
		cQuery += "AND CT2_DEBITO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	
	IF TRBCT2->VALOR == 0
		cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL = '" + TRBSE5->FILIAL + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE5->DOC+ "' AND CT2.CT2_AT03DB = '"+SubStr(TRBSE5->E5_DOCUMEN,18,6) +"' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
		cQuery += "AND CT2_DEBITO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf

	IF TRBCT2->VALOR == 0
		If SM0->M0_CODIGO $ "01_02"
			If TRBSE5->E5_TIPODOC == "JR"
				cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL = '" +TRBSE5->FILIAL + "' "
				cQuery += "AND CT2_HIST LIKE '%"+TRBSE5->DOC+"%'"
				cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND CT2_CREDIT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
				cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
				cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
		
				If SELECT("TRBCT2") > 0
					TRBCT2->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
			EndIf
		EndIf
	ENDIF
	
	dbSelectArea("TRB")
	
	RecLock("TRB",.T.)
	TRB->ARQUIVO	:=	"SE5"
	TRB->FILIAL			:=	TRBSE5->FILIAL
	TRB->DT_MOV		:= STOD(TRBSE5->DATA)
	TRB->FORNECE	:=	TRBSE5->FORNECE
	TRB->LOJA			:=	TRBSE5->LOJA
	If SM0->M0_CODIGO $ "01_05"
		TRB->NOMFORN	:=	Posicione("SA2",1,xFilial("SA2")+TRBSE5->FORNECE+TRBSE5->LOJA,"A2_NOME")
	Else
		TRB->NOMFORN	:=	Posicione("SA2",1,TRBSE5->FILIAL+TRBSE5->FORNECE+TRBSE5->LOJA,"A2_NOME")
	EndIf
	TRB->DOC			:=	TRBSE5->DOC
	TRB->SERIE			:=	TRBSE5->PREFIXO
	TRB->CONTA		:=	TRBSE5->CONTA
	TRB->PARCELA	:= TRBSE5->PARCELA
	TRB->TIPO			:= TRBSE5->TIPO
	TRB->NATUREZA	:=	TRBSE5->NATUREZA
	If SM0->M0_CODIGO $ "01" .And. TRBSE5->FILIAL $ "01_03"
		IF TRBSE5->E5_TIPODOC == 'JR' .AND. TRBSE5->E5_MOTBX == 'FAT'
			TRB->VALORCOMP	+=   (TRBSE5->VALOR - _nJuros +TRBSE5DE->VALOR)
		ElseIF TRBSE5->E5_TIPODOC == 'JR' .AND. TRBSE5->E5_MOTBX == 'LIQ'
			TRB->VALORCOMP	+=   (TRBSE5->VALOR)
		ELSE
//			TRB->VALORPAG	+=   (TRBSE5->VALOR - _nJuros +TRBSE5DE->VALOR) //Foi alterado em 10/08/2016 pq o valor do acrescimo estava somando ao valor da baixa e esse valor e considerado como juros, solicitado pela Amanda.
			IF TRBSE5DE->VALOR <> 0
				If _nJuros <> 0
					TRB->VALORPAG	+=   (TRBSE5->VALOR - _nJuros +TRBSE5DE->VALOR)
				Else
					TRB->VALORPAG	+=   (TRBSE5->VALOR - _nJuros +TRBSE5DE->VALOR - TRBSE5->VLACRES)
				EndIf
			ELSE
				If _nJuros <> 0
					TRB->VALORPAG	+=   (TRBSE5->VALOR - _nJuros + TRBSE5->VLDECRE)
				Else
					TRB->VALORPAG	+=   (TRBSE5->VALOR - _nJuros - TRBSE5->VLACRES + TRBSE5->VLDECRE)
				EndIf
			ENDIF
		ENDIF
	ElseIf SM0->M0_CODIGO $ "02" //.And. TRBSE5->FILIAL == "01"
		IF TRBSE5->E5_TIPODOC == 'JR' .AND. TRBSE5->E5_MOTBX == 'FAT'
			TRB->VALORCOMP	+=   (TRBSE5->VALOR)
		ElseIF TRBSE5->E5_TIPODOC == 'JR' .AND. TRBSE5->E5_MOTBX == 'LIQ'
			TRB->VALORCOMP	+=   (TRBSE5->VALOR)
		ELSE
			If SM0->M0_CODIGO $ "02" .And. TRBSE5->FILIAL $ "01"
				TRB->VALORPAG	+=   (TRBSE5->VALOR + TRBSE5DE->VALOR)
			Else
				If _nJuros == 0
					TRB->VALORPAG	+=   (TRBSE5->VALOR - TRBSE5->VLACRES+TRBSE5DE->VALOR)
				Else
					TRB->VALORPAG	+=   (TRBSE5->VALOR + TRBSE5DE->VALOR)
				EndIf
			EndIf
		EndIf
	ElseIf SM0->M0_CODIGO $ "03_05" .And. TRBSE5->FILIAL == "01"
		TRB->VALORPAG	+=   (TRBSE5->VALOR + TRBSE5DE->VALOR - _nJuros)
	Else
		TRB->VALORPAG	+=   (TRBSE5->VALOR - _nJuros)
	EndIf
	If (TRBSE5->VALOR - _nJuros) <> TRBCT2->VALOR .AND. TRBCT2->VALOR <> 0 .And. !SM0->M0_CODIGO $ "01_02" .AND. TRBSE5->FILIAL <> '01'
		TRB->VLRCONTAB +=	(TRBSE5->VALOR - _nJuros)
	ELSE
		TRB->VLRCONTAB +=	TRBCT2->VALOR
	ENDIF
	MsUnLock()
	
	dbSelectArea("TRBSE5")
	
	dbSkip()
	
	IncProc()
	
End

Processa({ || GERAXLS(.F.)}, "Aguarde",,.t.)

RETURN()


STATIC FUNCTION GERAXLS(lSchedule)

Local nConvert := 1
Local oExcel	:= FWMSEXCEL():New()

//oExcel:SetItalic(.T.)
oExcel:Set2LineBgColor("#F0F0F0")
oExcel:SetFontSize(10)
oExcel:SetFont("Arial")
oExcel:SetBold(.F.)

oExcel:AddworkSheet("Parametro")
oExcel:AddTable ("Parametro","Parametro Selecionado"+_cEmp)
oExcel:AddColumn("Parametro","Parametro Selecionado"+_cEmp,"Pergunta",1,4)
oExcel:AddColumn("Parametro","Parametro Selecionado"+_cEmp,"Respostas",1,2)
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Data de",mv_par01 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Data ate",mv_par02 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Da Filial",mv_par03 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Ate Filial",mv_par04 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Conta de",mv_par05 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Conta Ate",mv_par06 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Natureza de",mv_par07 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Natureza Ate",mv_par08 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Seleciona Tipo",IF(mv_par09=1,"Sim","Nao") })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Carteira",IF(mv_par10=1,"Pagar","Receber") })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Codigo de",mv_par11 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Codigo Ate",mv_par12 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Imprime entrada PA/NDF e RA/NCC",IF(mv_par13=1,"Sim","Nao") })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Tipos",_cTipos })

oExcel:AddworkSheet("Razonete")
oExcel:AddTable ("Razonete","Relatório Razonete a Pagar" + _cEmp )
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Empresa/Filial",1,4)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Data do Movimento",1,4)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Código do Fornecedor",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Nome do Fornecedor",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Nº Título",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Parcela",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Tipo",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Conta Contábil",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Natureza",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Valor do Pagamento (Débito)",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Valor da Compra (Crédito)",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Saldo",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"VLR CONTAB",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Pagar" + _cEmp,"Diferenca",1,2)

// Monta o saldo inicial do relatorio de razonete de Contas a Pagar SE2
///Incluido por Alexandre Antunes de Lima em 28/09/2015
///Alterado para pegar o saldo contabil de 31/12/2014 somente para a conta de fornecedor 21102007 conforme solicitado pela Amanda em 10/11/2015
_dDataIni		:= MV_PAR01  - 1
_nSaldoAnt	:= 0
_nSldPagar	:=	0
_aSdoContabil := {}
_aConta:={}

_cMesAno1 := dtos(mv_par01-1)
_cMesAno := dtos(mv_par02)
_cMesAno := SubStr(_cMesAno,5,2)+SubStr(_cMesAno,1,4)
_cMesAno1 := SubStr(_cMesAno1,5,2)+SubStr(_cMesAno1,1,4)

dbSelectArea("ZZC")
dbSeek(xFilial("ZZC")+"P"+_cMesAno1+"EMCTBR05")

If !Eof()
	_nSaldoAnt:= ZZC->ZZC_SALDO
Else
cQuery := ""
cQuery+= "SELECT E2_FILIAL FILIAL, E2_EMIS1 EMISSAO,E2_NUM DOC,E2_PREFIXO SERIE,E2_FORNECE FORNECE,E2_LOJA LOJA,E2_NATUREZ NATUREZA,E2_TIPO TIPO,A2_CONTA CONTA,E2_FATURA FATURA,E2_ORIGEM ORIGEM,E2_MULTNAT MULTNAT,SUM(E2_VALOR)  VALOR "
cQuery+= "FROM "+RetSqlName("SE2")+" E2 "
If SM0->M0_CODIGO $ "01_05_06"
	cQuery += "LEFT JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_COD = E2.E2_FORNECE AND SA2.A2_LOJA = E2.E2_LOJA  AND SA2.D_E_L_E_T_ = ' '  "
Else
	cQuery += "LEFT JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = E2.E2_FILIAL AND SA2.A2_COD = E2.E2_FORNECE AND SA2.A2_LOJA = E2.E2_LOJA  AND SA2.D_E_L_E_T_ = ' '  "
EndIf
cQuery += "WHERE E2.E2_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E2.D_E_L_E_T_ = ' '  "
If MV_PAR09 == 1
	cQuery += "AND E2.E2_TIPO IN "+_cTipos
EndIf
cQuery += "AND E2.E2_NATUREZ NOT IN ('21000','21001','21002','21003','21004','21005','21009','21010','21011','21014','21016','21018') "
cQuery += "AND E2.E2_EMIS1 BETWEEN '20150101' AND '"+DTOS(MV_PAR01-1)+"'  "
cQuery += "AND E2.E2_FORNECE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
cQuery += "AND SA2.A2_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
cQuery += "AND E2.E2_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
cQuery += "GROUP BY E2_FILIAL,E2_EMIS1,E2_NUM,E2_PREFIXO,E2_FORNECE,E2_LOJA,E2_NATUREZ,E2_TIPO,A2_CONTA,E2_FATURA,E2_ORIGEM,E2_MULTNAT  "

If SELECT("TRBSE2I") > 0
	TRBSE2I->(DbcloseArea())
Endif

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE2I", .T., .T.)
_cRecnoFin := STRZERO(RecCount(),9)
dbGoTop()
ProcRegua(LastRec())

While !Eof()
	
	If TRBSE2I->FORNECE == "001433" .And. TRBSE2I->TIPO == "BOL" .And. SM0->M0_CODIGO $ "01" //Esta condicao existe pq tem outros titulo de serie diferente que tem que sair para esse fornecedor
		dbSkip()
		Loop
	EndIf
	
	_cRecnoIni := str(recno())
	
	IncProc("Calculando o saldo inicial do contas a pagar " + _cRecnoIni)
	
	If TRBSE2I->SERIE <> "CTE" .AND. TRBSE2I->TIPO <> "FT " .AND. ALLTRIM(TRBSE2I->FATURA) <> "NOTFAT" .AND. ALLTRIM(TRBSE2I->ORIGEM) <> "FINA290"
		
		_nSldPagar += TRBSE2I->VALOR
		
	EndIf
	
	dbSelectArea("TRBSE2I")
	
	dbSkip()
	
End

// Movimento de Pagamento SE5
cQuery := ""
cQuery += "SELECT E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR FORNECE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_PARCELA PARCELA,E5_NATUREZ NATUREZA,A2_CONTA CONTA,E2_NUM,E2_MULTNAT,E5_MOTBX,E5_SEQ,E5_DOCUMEN,SUM(E5_VALOR-E5_VLMULTA)  VALOR,SUM(E5_VLACRES) VLACRES FROM "+RetSqlName("SE5")+" E5 "
If SM0->M0_CODIGO $ "01_05_06"
	cQuery += "LEFT JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_COD = E5.E5_CLIFOR AND SA2.A2_LOJA = E5.E5_LOJA AND SA2.D_E_L_E_T_ = ' '  "
Else
	cQuery += "LEFT JOIN "+RetSqlName("SA2")+" SA2 ON SA2.A2_FILIAL = E5.E5_FILIAL AND SA2.A2_COD = E5.E5_CLIFOR AND SA2.A2_LOJA = E5.E5_LOJA AND SA2.D_E_L_E_T_ = ' '  "
EndIf
cQuery += "LEFT JOIN "+RetSqlName("SE2")+" SE2 ON SE2.E2_FILIAL = E5.E5_FILIAL AND SE2.E2_FORNECE = E5.E5_CLIFOR AND SE2.E2_LOJA = E5.E5_LOJA AND SE2.E2_PREFIXO = E5.E5_PREFIXO AND SE2.E2_NUM = E5.E5_NUMERO AND SE2.E2_PARCELA = E5.E5_PARCELA AND SE2.E2_TIPO = E5.E5_TIPO AND SE2.D_E_L_E_T_ = ' '  "
cQuery += "WHERE E5.E5_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E5.D_E_L_E_T_ = ' '  "
cQuery += "AND E5.E5_DATA BETWEEN '20150101' AND '"+DTOS(MV_PAR01-1)+"'  AND E5.E5_RECPAG = 'P'  AND E5.E5_CLIFOR <> ' ' AND E5.E5_NUMERO <> ' ' "
cQuery += "AND E5_SITUACA  NOT IN ('C') "
cQuery += "AND E5_TIPODOC NOT IN ('JR','MT','DC')  "
cQuery += "AND E5_MOTBX <> 'FAT' "
cQuery += "AND E5.E5_CLIFOR BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
cQuery += "AND E5.E5_NATUREZ NOT IN ('21000','21001','21002','21003','21004','21005','21009','21010','21011','21014','21016','21018') "
If MV_PAR09 == 1
	cQuery += "AND E5.E5_TIPO IN "+_cTipos
EndIf
cQuery += "AND E5.E5_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
cQuery += "AND SA2.A2_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_CLIFOR,E5_LOJA,E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_PARCELA,E5_NATUREZ,A2_CONTA,E2_NUM,E2_MULTNAT,E5_MOTBX,E5_SEQ,E5_DOCUMEN  "
If SELECT("TRBSE5") > 0
	TRBSE5->(DbcloseArea())
Endif

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5", .T., .T.)
dbGoTop()
ProcRegua(LastRec())

While !Eof()
	
	If TRBSE5->FORNECE == "001433" .And. TRBSE5->TIPO == "BOL" .And. SM0->M0_CODIGO $ "01" //Esta condicao existe pq tem outros titulo de serie diferente que tem que sair para esse fornecedor
		dbSkip()
		Loop
	EndIf
	If TRBSE5->FORNECE == "EMP105" .And. TRBSE5->TIPO == "FT " .And. SM0->M0_CODIGO $ "02" .And. TRBSE5->FILIAL == '03' .And. TRBSE5->DOC == '009422328'  //Esta condicao existe pq nao deve sair no relatorio diferenca da entrada em 23/02/2016
		dbSkip()
		Loop
	EndIf
	If TRBSE5->FORNECE == "EMP105" .And. TRBSE5->TIPO == "FT " .And. SM0->M0_CODIGO $ "02" .And. TRBSE5->FILIAL == '03' .And. TRBSE5->DOC == '006932696'  //Esta condicao existe pq nao deve sair no relatorio diferenca da entrada em 23/02/2016
		dbSkip()
		Loop
	EndIf
	If TRBSE5->FORNECE == "EMP105" .And. TRBSE5->TIPO == "FT " .And. SM0->M0_CODIGO $ "02" .And. TRBSE5->FILIAL == '03' .And. TRBSE5->DOC == '007644598'  //Esta condicao existe pq nao deve sair no relatorio diferenca da entrada em 23/02/2016
		dbSkip()
		Loop
	EndIf
	
	// Movimento Bancario SE5
	cQuery := ""
	cQuery += "SELECT E5_FILIAL ,E5_TIPO,E5_NATUREZ ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
	cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
	cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->FORNECE+"'  "
	cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
	cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
	cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
	cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
	cQuery += "AND E5.E5_SEQ = '"+TRBSE5->E5_SEQ+"'  "
	cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->E5_MOTBX+"'  "
	cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
	cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->PARCELA+"'  "
	cQuery += "AND E5.E5_TIPODOC = 'ES'  "
	cQuery += "GROUP BY E5_FILIAL,E5_TIPO,E5_NATUREZ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC "
	
	If SELECT("TRBSE5ES") > 0
		TRBSE5ES->(DbcloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5ES", .T., .T.)
	
	If TRBSE5ES->VALOR <> 0
		dbSelectArea("TRBSE5")
		dbSkip()
		IncProc()
		Loop
	EndIf
	
	_nJuros := 0
	
	// Movimento Bancario SE5
	cQuery := ""
	cQuery += "SELECT E5_FILIAL ,E5_TIPO,E5_NATUREZ ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
	cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
	cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->FORNECE+"'  "
	cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
	cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
	cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
	cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
	If SM0->M0_CODIGO $ "02"
	Else
		cQuery += "AND E5.E5_SEQ = '"+TRBSE5->E5_SEQ+"'  "
	EndIf
	cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->E5_MOTBX+"'  "
	cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
	cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->PARCELA+"'  "
	cQuery += "AND E5.E5_TIPODOC = 'JR'  "
	cQuery += "GROUP BY E5_FILIAL,E5_TIPO,E5_NATUREZ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC "
	
	If SELECT("TRBSE5JR") > 0
		TRBSE5JR->(DbcloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5JR", .T., .T.)
	
	_nJuros := TRBSE5JR->VALOR
	
	// Movimento Bancario SE5
	cQuery := ""
	cQuery += "SELECT E5_FILIAL ,E5_DATA,E5_TIPO,E5_NATUREZ ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
	cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
	cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->FORNECE+"'  "
	cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
	cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
	cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
	cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
	If SM0->M0_CODIGO $ "02"
	Else
		cQuery += "AND E5.E5_SEQ = '"+TRBSE5->E5_SEQ+"'  "
	EndIf
	cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->E5_MOTBX+"'  "
	cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
	cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->PARCELA+"'  "
	cQuery += "AND E5.E5_TIPODOC = 'DC'  "
	cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_TIPO,E5_NATUREZ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC "
	
	If SELECT("TRBSE5DE") > 0
		TRBSE5DE->(DbcloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5DE", .T., .T.)
	
	If TRBSE5DE->VALOR <> 0 .And. SM0->M0_CODIGO $ '01_02'
		
		_nSldPagar -= TRBSE5DE->VALOR
		
	EndIf
	
	If SM0->M0_CODIGO $ "01" .And. TRBSE5->FILIAL $ "01_03"
		_nSldPagar -= (TRBSE5->VALOR - _nJuros +TRBSE5DE->VALOR)
	ElseIf SM0->M0_CODIGO $ "02" .And. TRBSE5->FILIAL == "01"
		If _nJuros == 0
			_nSldPagar -= (TRBSE5->VALOR - TRBSE5->VLACRES+TRBSE5DE->VALOR)
		Else
			_nSldPagar -= (TRBSE5->VALOR - _nJuros+TRBSE5DE->VALOR)
		EndIf
	ElseIf SM0->M0_CODIGO $ "05" .And. TRBSE5->FILIAL == "01"
		_nSldPagar -= (TRBSE5->VALOR + TRBSE5DE->VALOR - _nJuros)
	Else
		_nSldPagar -= (TRBSE5->VALOR - _nJuros)
	EndIf
	
	dbSelectArea("TRBSE5")
	
	dbSkip()
	
	IncProc()
	
End

aadd(_aConta,{'21102007'})

For _nx:= 1 to Len(_aConta)
	_aSdoContabil := SdoContabil(_aConta[_nx,1],ctod("31/12/2014"),"01","1")
	_nSaldoAnt += _aSdoContabil[1]
Next

If _nSldPagar < 0
	_nSldPagar := _nSldPagar * (-1)
EndIf

If _nSaldoAnt < 0
	_nSaldoAnt := _nSaldoAnt * (-1)
EndIf

_nSaldoAnt := _nSaldoAnt + _nSldPagar

EndIf

oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"","","","","","","","","","","Saldo Inicial Contabil","R$ " +Transform(_nSaldoAnt,"@E 999,999,999,999.99"),"","" })
oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"","","","","","","","","","","","","","" })

dbSelectArea("TRB")
dbGoTop()
ProcRegua(LastRec())


If MV_PAR01 >= CTOD("01/01/2015") .And. MV_PAR02 <= CTOD("31/01/2015") .And. SM0->M0_CODIGO $ "02" .And. MV_PAR03 $ "02/04"
	_nSaldo		:= _nSaldoAnt * (-1)
Else
	_nSaldo		:= _nSaldoAnt
EndIf

_nTotDeb	:= 0
_nTotCred	:= 0

If MV_PAR01 >= CTOD("01/01/2015") .And. MV_PAR02 <= CTOD("31/01/2015") .And. SM0->M0_CODIGO $ "01" .And. MV_PAR03 == "01"
		_nSaldo := _nSaldo - 4049.00
		oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"01/01",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"21102007",;
		"",;
		4049.00,;
		"",;
		_nSaldo,;
		4049.00,;
		""  })

		_nTotDeb += 4049.00

		_nSaldo := _nSaldo + 53502.62

		oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"01/01",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"21102007",;
		"",;
		"",;
		53502.62,;
		_nSaldo,;
		53502.62,;
		""  })

		_nTotCred += 53502.62

EndIf		

If MV_PAR01 >= CTOD("01/01/2015") .And. MV_PAR02 <= CTOD("31/01/2015") .And. SM0->M0_CODIGO $ "02" .And. MV_PAR03 == "01"
		_nSaldo := _nSaldo + 37096.77
		oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"02/01",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"21102007",;
		"",;
		"",;
		37096.77,;
		_nSaldo,;
		37096.77,;
		""  })

		_nTotCred += 37096.77

		_nSaldo := _nSaldo - 4676.08
		oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"02/01",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"21102007",;
		"",;
		4676.08,;
		"",;
		_nSaldo,;
		4676.08,;
		""  })

		_nTotDeb += 4676.08

EndIf		

If MV_PAR01 >= CTOD("01/01/2015") .And. MV_PAR02 <= CTOD("31/01/2015") .And. SM0->M0_CODIGO $ "02" .And. MV_PAR03 == "02"
		_nSaldo := _nSaldo + 1002.27
		oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"02/02",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"21102007",;
		"",;
		"",;
		1002.27,;
		_nSaldo,;
		1002.27,;
		""  })

		_nTotCred += 1002.27

		_nSaldo := _nSaldo + 56.31
		oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"02/02",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"21102007",;
		"",;
		"",;
		56.51,;
		_nSaldo,;
		56.31,;
		""  })

		_nTotCred += 56.31

EndIf		

If MV_PAR01 >= CTOD("01/01/2015") .And. MV_PAR02 <= CTOD("31/01/2015") .And. SM0->M0_CODIGO $ "02" .And. MV_PAR03 == "03"
/*		_nSaldo := _nSaldo - 29522.94
		oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"02/03",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"21102007",;
		"",;
		29522.94,;
		"",;
		_nSaldo,;
		29522.94,;
		""  })

		_nTotDeb += 29522.94
*/
		_nSaldo := _nSaldo + 799.49
		oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"02/03",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"21102007",;
		"",;
		"",;
		799.49,;
		_nSaldo,;
		799.49,;
		""  })

		_nTotCred += 799.49

EndIf		

If MV_PAR01 >= CTOD("01/01/2015") .And. MV_PAR02 <= CTOD("31/01/2015") .And. SM0->M0_CODIGO $ "02" .And. MV_PAR03 == "04"
		_nSaldo := _nSaldo - 5950.00
		oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"02/04",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"21102007",;
		"",;
		5950.00,;
		"",;
		_nSaldo,;
		5950.00,;
		""  })

		_nTotDeb += 5950.00

		_nSaldo := _nSaldo + 4495.35

		oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"02/04",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"21102007",;
		"",;
		"",;
		4495.35,;
		_nSaldo,;
		4495.35,;
		""  })

		_nTotCred += 4495.35

EndIf		

If MV_PAR01 >= CTOD("01/01/2015") .And. MV_PAR02 <= CTOD("31/01/2015") .And. SM0->M0_CODIGO $ "03" .And. MV_PAR03 == "01"
		_nSaldo := _nSaldo + 699.07
		oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"03/01",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"21102007",;
		"",;
		"",;
		699.07,;
		_nSaldo,;
		699.07,;
		""  })

		_nTotCred += 699.07

EndIf		

If MV_PAR01 >= CTOD("01/01/2015") .And. MV_PAR02 <= CTOD("31/01/2015") .And. SM0->M0_CODIGO $ "05"
		_nSaldo := _nSaldo + 1865.92
		oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"05/01",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"21102007",;
		"",;
		"",;
		1865.92,;
		_nSaldo,;
		1865.92,;
		""  })

		_nTotCred += 1865.92

EndIf		

While !Eof()
	
	_nSaldo := _nSaldo + TRB->VALORCOMP - TRB->VALORPAG

	oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{If(Empty(TRB->FILIAL),"",SM0->M0_CODIGO+"/"+TRB->FILIAL),If(Empty(TRB->DT_MOV),"",TRB->DT_MOV),;
	If(Empty(TRB->FORNECE),"",TRB->FORNECE+"/"+TRB->LOJA),If(Empty(TRB->NOMFORN),"",TRB->NOMFORN),;
		If(Empty(TRB->DOC),"",TRB->DOC),If(Empty(TRB->PARCELA),"",TRB->PARCELA),If(Empty(TRB->TIPO),"",TRB->TIPO),;
			If(Empty(TRB->CONTA),"",TRB->CONTA),If(Empty(TRB->NATUREZA),"",TRB->NATUREZA),If(Empty(TRB->VALORPAG),"",TRB->VALORPAG),;
				If(Empty(TRB->VALORCOMP),"",TRB->VALORCOMP),_nSaldo,TRB->VLRCONTAB,IF(TRB->VALORCOMP=0,TRB->VALORPAG-TRB->VLRCONTAB,TRB->VALORCOMP-TRB->VLRCONTAB)  })
					
					_nTotDeb += TRB->VALORPAG
					_nTotCred += TRB->VALORCOMP
					
					dbSelectArea("TRB")
					
					dbSkip()
					
					IncProc()
					
End
				
oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"","","","","","","","","","","","","","" })
oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"","","","","","","","","","","","","","" })
oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"","","","","","","","","Saldo Anterior","Total de Debito","Total de Credito","Saldo Final","","" })
oExcel:AddRow("Razonete","Relatório Razonete a Pagar" + _cEmp,{"","","","","","","","","R$ " +Transform(_nSaldoAnt,"@E 999,999,999,999.99"),Transform(_nTotDeb,"@E 999,999,999,999.99"),"R$ " +Transform(_nTotCred,"@E 999,999,999,999.99"),"R$ " +Transform(_nSaldo,"@E 999,999,999,999.99"),"","" })

If mv_par14 == 1
	dbSelectArea("ZZC")
	dbSeek(xFilial("ZZC")+"P"+_cMesAno+"EMCTBR05")
	
	If !Eof()
		RecLock("ZZC",.F.)
		ZZC->ZZC_SALDO := _nSaldo
		MsUnLock()
	Else
		RecLock("ZZC",.T.)
		ZZC->ZZC_FILIAL	:=	XFILIAL("ZZC")
		ZZC->ZZC_GRUPO:= "EMCTBR05"
		ZZC->ZZC_MESANO:= _cMESANO
		ZZC->ZZC_RECPAG:="P"
		ZZC->ZZC_SALDO := _nSaldo
		MsUnLock()
	EndIf
EndIf

_cArquivo := cPath+"Relatorio Razonete a pagar "+ SM0->M0_NOME + " - " + DTOS(Date()) + "_" + SubStr(Time(),1,2) + SubStr(Time(),4,2) + SubStr(Time(),7,2) +".xml"

// Luiz Alberto - Detalhamento das Contas Contabeis Utilizadas

oExcel:AddworkSheet("Detalhamento")
oExcel:AddTable ("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp )
oExcel:AddColumn("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,"Empresa/Filial",1,4)
oExcel:AddColumn("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,"Prefixo",1,4)
oExcel:AddColumn("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,"Titulo",1,4)
oExcel:AddColumn("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,"Parcela",1,2)
oExcel:AddColumn("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,"Tipo",1,2)
oExcel:AddColumn("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,"Codigo",1,2)
oExcel:AddColumn("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,"Loja",1,2)
oExcel:AddColumn("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,"Nome Fornecedor",1,2)
oExcel:AddColumn("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,"Emissão",1,2)
oExcel:AddColumn("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,"Vencimento",1,2)
oExcel:AddColumn("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,"Vlr Aberto",1,2)
oExcel:AddColumn("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,"Saldo",1,2)

_nSaldoAnt:= 0.00


cQuery := "SELECT R_E_C_N_O_ REGISTRO, * "
cQuery += "  FROM "+	RetSqlName("SE2")
cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery += " AND E2_VENCREA <= '"+ DTOS(mv_par02)+ "' "
cQuery += " AND E2_EMISSAO <= '" + DTOS(mv_par02) +"'"
cQuery += " AND (E2_BAIXA = '' OR E2_BAIXA > '" + DTOS(mv_par02) +"') "
cQuery += " AND E2_TIPO IN "+_cTipos
cQuery += " ORDER BY E2_EMISSAO "

If SELECT("TRBCTD") > 0
	TRBCT2->(DbcloseArea())
Endif
		
dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCTD", .T., .T.)

tcSetField("TRBCTD","E2_EMISSAO","D")
tcSetField("TRBCTD","E2_VENCREA","D")

Count To nReg

oExcel:AddRow("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,{"","","","","","","","","","","",""})
oExcel:AddRow("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,{"","","","","","","","","","","Saldo Anterior","R$ " +Transform(_nSaldoAnt,"@E 999,999,999,999.99")})
oExcel:AddRow("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,{"","","","","","","","","","","",""})

dbGoTop()
ProcRegua(nReg)
While TRBCTD->(!Eof())
	IncProc("Gerando Detalhes Saldos em Aberto ")

	SE2->(dbGoTo(TRBCTD->REGISTRO))


	//????????????????????????????
	//?Verifica se trata-se de abatimento ou provisorio, ou ?
					//?Somente titulos emitidos ate a data base				   ?
					//????????????????????????????
	IF SE2->E2_TIPO $ MVABATIM .Or. (SE2 -> E2_EMISSAO > dDataBase)
		dbSkip()
		Loop
	EndIF
	//????????????????????????????
	//?Verifica se ser?impresso titulos provis?ios		   ?
					//????????????????????????????
	IF E2_TIPO $ MVPROVIS 
		dbSkip()
		Loop
	EndIF	
	//????????????????????????????
	//?Verifica se ser?impresso titulos de Adiantamento	 ?
					//????????????????????????????
	IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG 
		dbSkip()
		Loop
	EndIF      

	IF SE2->E2_TIPO $ 'TX '
		dbSkip()
		Loop
	EndIF      
	
	If !Empty(SE2->E2_BAIXA) .And. SE2->E2_BAIXA > MV_PAR02 
		nSaldo := SE2->E2_VALOR
	Else
		nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,1,dDataBase,,SE2->E2_LOJA,,SE2->E2_TXMOEDA,1) // 1 = DT BAIXA    3 = DT DIGIT
	Endif

	//????????????????????????????
	//?Desconsidera caso saldo seja menor ou igual a zero   ?
				//????????????????????????????
	If nSaldo <= 0
		dbSkip()
		Loop
	Endif  

	_nSaldoAnt += nSaldo

	oExcel:AddRow("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,{If(Empty(TRBCTD->E2_FILIAL),"",SM0->M0_CODIGO+"/"+TRBCTD->E2_FILIAL),;
	TRBCTD->E2_PREFIXO,;
	TRBCTD->E2_NUM,;
	TRBCTD->E2_PARCELA,;
	TRBCTD->E2_TIPO,;
	TRBCTD->E2_FORNECE,;
	TRBCTD->E2_LOJA,;
	TRBCTD->E2_NOMFOR,;
	DtoC(TRBCTD->E2_EMISSAO),;
	DtoC(TRBCTD->E2_VENCREA),;
	nSaldo,;
	_nSaldoAnt})

	dbSkip()

End

oExcel:AddRow("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,{"","","","","","","","","","","",""})
oExcel:AddRow("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,{"","","","","","","","","","","Saldo Final","R$ " +Transform(_nSaldoAnt,"@E 999,999,999,999.99")})
oExcel:AddRow("Detalhamento","Detalhamento Saldos em Aberto " + _cEmp,{"","","","","","","","","","","",""})

TRBCTD->(dbCloseArea())

oExcel:Activate()
oExcel:GetXMLFile(_cArquivo)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( _cArquivo)
oExcelApp:SetVisible(.T.)

Return(.T.)

////Gera o razonete do contas a receber

Static Function SelectRec()

_cEmp   := " Empresa " + AllTrim(SM0->M0_NOME) + " CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")

If MV_PAR09 == 1
	_cTipos:=	xFinrTipos()   //Funcao que seleciona os tipos no relatorio
EndIf

aStructure := {}

AADD( aStructure, {'ARQUIVO'   ,'C',03,0} )
AADD( aStructure, {'Filial','C',02,0} )
AADD( aStructure, {'DT_MOV','D',08,0} )
AADD( aStructure, {'FORNECE','C',06,0} )
AADD( aStructure, {'LOJA','C',02,0} )
AADD( aStructure, {'NOMFORN','C',40,0} )
AADD( aStructure, {'DOC','C',09,0} )
AADD( aStructure, {'SERIE','C',03,0} )
AADD( aStructure, {'PARCELA','C',03,0} )
AADD( aStructure, {'TIPO','C',03,0} )
AADD( aStructure, {'CONTA','C',10,0} )
AADD( aStructure, {'NATUREZA','C',10,0} )
AADD( aStructure, {'VALORPAG','N',14,2} )
AADD( aStructure, {'VALORCOMP','N',14,2} )
AADD( aStructure, {'VLRCONTAB','N',14,2} )

CriaTMP( aStructure, "TRB" )

cPath := cGetFile("\","Selecione o diretorio p/ gravação da planilha em excel ",,,,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)

// Titulos no Contas a Receber SE1
cQuery := ""
cQuery+= "SELECT E1_FILIAL FILIAL, E1_EMISSAO EMISSAO,E1_NUM DOC,E1_PREFIXO SERIE,E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_NATUREZ NATUREZA,A1_CONTA CONTA,E1_TIPO TIPO,E1_FATURA FATURA,SUM(E1_VALOR)  VALOR,SUM(E1_VLRREAL) VLRREAL "
cQuery+= "FROM "+RetSqlName("SE1")+" E1 "
If SM0->M0_CODIGO $ "01_05_06"
	cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
Else
	cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = E1.E1_FILIAL AND SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
EndIf
cQuery += "LEFT JOIN "+RetSqlName("SF2")+" SF2 ON SF2.F2_CLIENTE = E1.E1_CLIENTE AND SF2.F2_LOJA = E1.E1_LOJA AND SF2.F2_DOC = E1.E1_NUM AND SF2.F2_SERIE = E1.E1_PREFIXO AND SF2.D_E_L_E_T_ = ' '  "
cQuery += "WHERE E1.E1_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E1.D_E_L_E_T_ = ' '  "
If MV_PAR09 == 1
	cQuery += "AND E1.E1_TIPO IN "+_cTipos
EndIf
//If SM0->M0_CODIGO $ "01_03" //tirado em 24/05/2016 E ACRESCENTADO O 'DEB'
cQuery += "AND E1.E1_PREFIXO NOT IN ('CRT','DEB') "
//EndIf
If SM0->M0_CODIGO $ "02"
	cQuery += "AND SF2.F2_FIMP NOT IN ('N') "
EndIf
cQuery += "AND E1.E1_ORITCA <> 'MENTOR' "
cQuery += "AND E1.E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
cQuery += "AND E1.E1_CLIENTE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
cQuery += "AND SA1.A1_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
cQuery += "AND E1.E1_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
cQuery += "GROUP BY E1_FILIAL,E1_EMISSAO,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_NATUREZ,A1_CONTA,E1_TIPO,E1_FATURA  "

If SELECT("TRBSE1I") > 0
	TRBSE1I->(DbcloseArea())
Endif

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE1I", .T., .T.)
dbGoTop()
ProcRegua(LastRec())

While !Eof()

	If ALLTRIM(TRBSE1I->DOC) == "000002006"
		_NALE:= 0
	EndIf
	
	If TRBSE1I->DOC $ "000195810" .AND. SM0->M0_CODIGO $ "02"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	
	If MV_PAR13 == 2 .AND. TRBSE1I->TIPO $ "RA /NCC" //.AND. TRBSE1I->E5_MOTBX <> "CMP"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	
	If TRBSE1I->TIPO $ "BOL" .AND. ALLTRIM(TRBSE1I->FATURA) = "NOTFAT"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	If TRBSE1I->TIPO $ "CC " .AND. ALLTRIM(TRBSE1I->FATURA) = "NOTFAT"  .AND. SM0->M0_CODIGO $ "02"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	If TRBSE1I->TIPO $ "FT " .AND. ALLTRIM(TRBSE1I->FATURA) = "NOTFAT"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	If TRBSE1I->TIPO $ "CH " .AND. ALLTRIM(TRBSE1I->SERIE) = "CP" .AND. SM0->M0_CODIGO $ "01"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	If TRBSE1I->TIPO $ "CH " .AND. SM0->M0_CODIGO $ "02"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	
	cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
	cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT03DB = '"+TRBSE1I->CLIENTE +"' "
	cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
	cQuery += "AND CT2_DEBITO = '"+TRBSE1I->CONTA+"'  "
	If SM0->M0_CODIGO $ "02"
		cQuery += "AND CT2_LP <> '588'    "
	EndIf
	cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
	cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
	
	If SELECT("TRBCT2") > 0
		TRBCT2->(DbcloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	
	If TRBCT2->Valor == 0 .And. ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ '05'
		cQuery:= "SELECT CT2_AT01DB,CT2_AT02DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT03DB = '"+TRBSE1I->CLIENTE +"' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_DEBITO = '11201001'  "
		cQuery += "AND CT2.CT2_AT02DB = '"+TRBSE1I->TIPO+"' "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT02DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	
	If TRBCT2->Valor == 0 .And. ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ '05'
		cQuery:= "SELECT CT2_AT01CR,CT2_AT02CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01CR = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT03CR = '"+TRBSE1I->CLIENTE +"' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_CREDIT = '11201001'  "
		cQuery += "AND CT2.CT2_AT02CR = '"+TRBSE1I->TIPO+"' "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01CR,CT2_AT02CR,CT2_AT03CR "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	
	If TRBCT2->Valor == 0 .And. ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ '05'
		cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT03DB = '999999' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_DEBITO = '"+TRBSE1I->CONTA+"'  "
		If SM0->M0_CODIGO $ "02"
			cQuery += "AND CT2_LP <> '588'    "
		EndIf
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	
	If TRBCT2->Valor == 0
		cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT03DB = '"+TRBSE1I->CLIENTE +"' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_DEBITO = '"+TRBSE1I->CONTA+"'  "
		If SM0->M0_CODIGO $ "02"
			cQuery += "AND CT2_LP <> '588'    "
		EndIf
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	If TRBCT2->Valor == 0 .And. ALLTRIM(TRBSE1I->TIPO) $ "CD/CC"
		cQuery:= "SELECT CT2_AT01DB,CT2_AT02DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_DEBITO = '"+TRBSE1I->CONTA+"'  "
		If SM0->M0_CODIGO $ "02"
			cQuery += "AND CT2_LP <> '588'    "
		EndIf
		If SM0->M0_CODIGO $ "05"
			cQuery += "AND CT2.CT2_AT02DB = '"+TRBSE1I->TIPO+"' "
		EndIf
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT02DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	If TRBCT2->Valor == 0 .And. ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ '01'
		cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_DEBITO = '11201001'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	IF ALLTRIM(TRBSE1I->DOC) == '003534'
		_NALE:=0
	ENDIF
	If TRBCT2->Valor <> TRBSE1I->VLRREAL .And. ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ '05'
		cQuery:= "SELECT CT2_AT01DB,CT2_AT02DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_KEY LIKE '%"+TRBSE1I->DOC+TRBSE1I->SERIE+"%'  "
		cQuery += "AND CT2_DEBITO = '11201001'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT02DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->ARQUIVO	:=	"SE1"
	TRB->FILIAL			:=	TRBSE1I->FILIAL
	TRB->DT_MOV		:=	STOD(TRBSE1I->EMISSAO)
	TRB->NATUREZA	:= TRBSE1I->NATUREZA
	TRB->FORNECE	:=	TRBSE1I->CLIENTE
	TRB->LOJA			:=	TRBSE1I->LOJA
	If SM0->M0_CODIGO $ "01_05"
		TRB->NOMFORN	:=	Posicione("SA1",1,xFilial("SA1")+TRBSE1I->CLIENTE+TRBSE1I->LOJA,"A1_NOME")
	Else
		TRB->NOMFORN	:=	Posicione("SA1",1,TRBSE1I->FILIAL+TRBSE1I->CLIENTE+TRBSE1I->LOJA,"A1_NOME")
	EndIf
	TRB->DOC			:=	TRBSE1I->DOC
	TRB->SERIE			:=	TRBSE1I->SERIE
	TRB->TIPO			:= TRBSE1I->TIPO
	TRB->CONTA		:=	TRBSE1I->CONTA
	If ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ "01/05" //Alterado por Alexandre em 14/12/2015 acrescentando a empresa 01
		If TRBSE1I->DOC == "000007700" .AND. ALLTRIM(TRBSE1I->TIPO) == 'CC' .AND. TRBSE1I->CLIENTE == '004824'
			TRB->VALORCOMP	+=	(TRBSE1I->VLRREAL + 7.29 + 2.07) // FOI INCLUIDO ESTA LINHA PQ O FINANCEIRO FEZ A MOVIMENTACAO ERRADA E NAO FECHA COM  CONTABILIDADE EM 29/01/2019 POR ALEXANDRE
		ELSE
			TRB->VALORCOMP	+=	TRBSE1I->VLRREAL
		ENDIF
	Else
		TRB->VALORCOMP	+=	TRBSE1I->VALOR
	EndIf
	If SM0->M0_CODIGO $ "01/05" .And. ALLTRIM(TRBSE1I->TIPO) $ "CC/CD" .And. TRBCT2->VALOR <> 0 //Alterado por Alexandre em 14/12/2015 acrescentando a empresa 01
		TRB->VLRCONTAB +=	TRB->VALORCOMP
	ElseIf SM0->M0_CODIGO $ "05" .And. ALLTRIM(TRBSE1I->TIPO) $ "CR" .And. TRBCT2->VALOR <> 0   //ALEXANDRE EM 11/06/2015
		TRB->VLRCONTAB +=	TRBSE1I->VALOR
	ElseIf SM0->M0_CODIGO $ "05" .And. ALLTRIM(TRBSE1I->TIPO) $ "R$/CH" .And. TRBCT2->VALOR <> 0
		TRB->VLRCONTAB +=	TRBSE1I->VALOR
	Else
		TRB->VLRCONTAB +=	TRBCT2->VALOR
	EndIf
	MsUnLock()
	
	dbSelectArea("TRBSE1I")
	dbSkip()
	
	IncProc("Montando arquivo de entrada por contas a receber " + TRBSE1I->DOC)
	
End

/////////////////////////////////ESTE BLOCO FOI COLOCADO DEVIDO AS TRANSFERENCIAS DE TITULOS DAS FILIALS BAURU, RECIFE E BAURU PARA A MATRIZ////////////////////////////////////////////////////////////////////
// Titulos no Contas a Receber SE1
cQuery := ""
cQuery+= "SELECT E1_FILIAL FILIAL, E1_EMISSAO EMISSAO,E1_NUM DOC,E1_PREFIXO SERIE,E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_NATUREZ NATUREZA,A1_CONTA CONTA,E1_TIPO TIPO,E1_FATURA FATURA,SUM(E1_VALOR)  VALOR,SUM(E1_VLRREAL) VLRREAL "
cQuery+= "FROM "+RetSqlName("SE1")+" E1 "
If SM0->M0_CODIGO $ "01_05_06"
	cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
Else
	cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = E1.E1_FILIAL AND SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
EndIf
cQuery += "WHERE E1.E1_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E1.D_E_L_E_T_ = ' '  "
If MV_PAR09 == 1
	cQuery += "AND E1.E1_TIPO IN "+_cTipos
EndIf
cQuery += "AND E1.E1_PREFIXO IN ('REC','SUM') "
cQuery += "AND E1.E1_ORITCA <> 'MENTOR' "
cQuery += "AND E1.E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
cQuery += "AND E1.E1_CLIENTE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
cQuery += "AND SA1.A1_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
cQuery += "AND E1.E1_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
cQuery += "GROUP BY E1_FILIAL,E1_EMISSAO,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_NATUREZ,A1_CONTA,E1_TIPO,E1_FATURA  "

If SELECT("TRBSE1I") > 0
	TRBSE1I->(DbcloseArea())
Endif

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE1I", .T., .T.)
dbGoTop()
ProcRegua(LastRec())

While !Eof()

	If TRBSE1I->DOC $ "000195810" .AND. SM0->M0_CODIGO $ "02"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	
	If MV_PAR13 == 2 .AND. TRBSE1I->TIPO $ "RA /NCC" //.AND. TRBSE1I->E5_MOTBX <> "CMP"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	
	If TRBSE1I->TIPO $ "BOL" .AND. ALLTRIM(TRBSE1I->FATURA) = "NOTFAT"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	If TRBSE1I->TIPO $ "CC " .AND. ALLTRIM(TRBSE1I->FATURA) = "NOTFAT"  .AND. SM0->M0_CODIGO $ "02"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	If TRBSE1I->TIPO $ "CH " .AND. ALLTRIM(TRBSE1I->SERIE) = "CP" .AND. SM0->M0_CODIGO $ "01"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	If TRBSE1I->TIPO $ "CH " .AND. SM0->M0_CODIGO $ "02"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	
	cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
	cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT03DB = '"+TRBSE1I->CLIENTE +"' "
	cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
	cQuery += "AND CT2_DEBITO = '"+TRBSE1I->CONTA+"'  "
	If SM0->M0_CODIGO $ "02"
		cQuery += "AND CT2_LP <> '588'    "
	EndIf
	cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
	cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
	
	If SELECT("TRBCT2") > 0
		TRBCT2->(DbcloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	
	If TRBCT2->Valor == 0 .And. ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ '05'
		cQuery:= "SELECT CT2_AT01DB,CT2_AT02DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT03DB = '"+TRBSE1I->CLIENTE +"' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_DEBITO = '11201001'  "
		cQuery += "AND CT2.CT2_AT02DB = '"+TRBSE1I->TIPO+"' "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT02DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	
	If TRBCT2->Valor == 0 .And. ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ '05'
		cQuery:= "SELECT CT2_AT01CR,CT2_AT02CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01CR = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT03CR = '"+TRBSE1I->CLIENTE +"' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_CREDIT = '11201001'  "
		cQuery += "AND CT2.CT2_AT02CR = '"+TRBSE1I->TIPO+"' "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01CR,CT2_AT02CR,CT2_AT03CR "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	
	If TRBCT2->Valor == 0 .And. ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ '05'
		cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT03DB = '999999' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_DEBITO = '"+TRBSE1I->CONTA+"'  "
		If SM0->M0_CODIGO $ "02"
			cQuery += "AND CT2_LP <> '588'    "
		EndIf
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	
	If TRBCT2->Valor == 0
		cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT03DB = '"+TRBSE1I->CLIENTE +"' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_DEBITO = '"+TRBSE1I->CONTA+"'  "
		If SM0->M0_CODIGO $ "02"
			cQuery += "AND CT2_LP <> '588'    "
		EndIf
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	If TRBCT2->Valor == 0 .And. ALLTRIM(TRBSE1I->TIPO) $ "CD/CC"
		cQuery:= "SELECT CT2_AT01DB,CT2_AT02DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_DEBITO = '"+TRBSE1I->CONTA+"'  "
		If SM0->M0_CODIGO $ "02"
			cQuery += "AND CT2_LP <> '588'    "
		EndIf
		If SM0->M0_CODIGO $ "05"
			cQuery += "AND CT2.CT2_AT02DB = '"+TRBSE1I->TIPO+"' "
		EndIf
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT02DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	If TRBCT2->Valor == 0 .And. ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ '01'
		cQuery:= "SELECT CT2_AT01DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_DEBITO = '11201001'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	If TRBCT2->Valor <> TRBSE1I->VLRREAL .And. ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ '05'
		cQuery:= "SELECT CT2_AT01DB,CT2_AT02DB,CT2_AT03DB,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01DB = '"+TRBSE1I->DOC+ "' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_KEY LIKE '%"+TRBSE1I->DOC+TRBSE1I->SERIE+"%'  "
		cQuery += "AND CT2_DEBITO = '11201001'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01DB,CT2_AT02DB,CT2_AT03DB "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->ARQUIVO	:=	"SE1"
	TRB->FILIAL			:=	TRBSE1I->FILIAL
	TRB->DT_MOV		:=	STOD(TRBSE1I->EMISSAO)
	TRB->NATUREZA	:= TRBSE1I->NATUREZA
	TRB->FORNECE	:=	TRBSE1I->CLIENTE
	TRB->LOJA			:=	TRBSE1I->LOJA
	If SM0->M0_CODIGO $ "01_05"
		TRB->NOMFORN	:=	Posicione("SA1",1,xFilial("SA1")+TRBSE1I->CLIENTE+TRBSE1I->LOJA,"A1_NOME")
	Else
		TRB->NOMFORN	:=	Posicione("SA1",1,TRBSE1I->FILIAL+TRBSE1I->CLIENTE+TRBSE1I->LOJA,"A1_NOME")
	EndIf
	TRB->DOC			:=	TRBSE1I->DOC
	TRB->SERIE			:=	TRBSE1I->SERIE
	TRB->TIPO			:= TRBSE1I->TIPO
	TRB->CONTA		:=	TRBSE1I->CONTA
	If ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ "01/05" //Alterado por Alexandre em 14/12/2015 acrescentando a empresa 01
		If TRBSE1I->DOC == "000007700" .AND. ALLTRIM(TRBSE1I->TIPO) == 'CC' .AND. TRBSE1I->CLIENTE == '004824'
			TRB->VALORCOMP	+=	(TRBSE1I->VLRREAL + 7.29 + 2.07) // FOI INCLUIDO ESTA LINHA PQ O FINANCEIRO FEZ A MOVIMENTACAO ERRADA E NAO FECHA COM  CONTABILIDADE EM 29/01/2019 POR ALEXANDRE
		ELSE
			TRB->VALORCOMP	+=	TRBSE1I->VLRREAL
		ENDIF
	Else
		TRB->VALORCOMP	+=	TRBSE1I->VALOR
	EndIf
	If SM0->M0_CODIGO $ "01/05" .And. ALLTRIM(TRBSE1I->TIPO) $ "CC/CD" .And. TRBCT2->VALOR <> 0 //Alterado por Alexandre em 14/12/2015 acrescentando a empresa 01
		TRB->VLRCONTAB +=	TRB->VALORCOMP
	ElseIf SM0->M0_CODIGO $ "05" .And. ALLTRIM(TRBSE1I->TIPO) $ "CR" .And. TRBCT2->VALOR <> 0   //ALEXANDRE EM 11/06/2015
		TRB->VLRCONTAB +=	TRBSE1I->VALOR
	ElseIf SM0->M0_CODIGO $ "05" .And. ALLTRIM(TRBSE1I->TIPO) $ "R$/CH" .And. TRBCT2->VALOR <> 0
		TRB->VLRCONTAB +=	TRBSE1I->VALOR
	Else
		TRB->VLRCONTAB +=	TRBCT2->VALOR
	EndIf
	MsUnLock()
	
	dbSelectArea("TRBSE1I")
	dbSkip()
	
	IncProc("Montando arquivo de entrada por contas a receber " + TRBSE1I->DOC)
	
End


////////////////////////////////////////FIM DO BLOCO/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


If SM0->M0_CODIGO $ "01_05"
	// Titulos que foram incluidos com o tipo CD/CC/CH venda do sigaloja no Contas a Receber SE1
	cQuery := ""
	cQuery+= "SELECT E1_FILIAL FILIAL, E1_EMISSAO EMISSAO,E1_NUM DOC,E1_PREFIXO SERIE,E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_NATUREZ NATUREZA,A1_CONTA CONTA,E1_TIPO TIPO,SUM(E1_VALOR)  VALOR,SUM(E1_VLRREAL) VLRREAL "
	cQuery+= "FROM "+RetSqlName("SE1")+" E1 "
	cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
	cQuery += "WHERE E1.E1_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E1.D_E_L_E_T_ = ' '  "
	cQuery += "AND E1.E1_TIPO IN ('CD ','CC ','CH ') "
	//	cQuery += "AND E1.E1_FATURA = 'NOTFAT' "
	cQuery += "AND E1.E1_ORITCA <> 'MENTOR' "
	cQuery += "AND E1.E1_FLAGFAT <> 'S' "
	cQuery += "AND E1.E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
	cQuery += "AND E1.E1_CLIENTE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
	cQuery += "AND SA1.A1_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	cQuery += "AND E1.E1_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
	cQuery += "GROUP BY E1_FILIAL,E1_EMISSAO,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_NATUREZ,A1_CONTA,E1_TIPO  "
Else
	// Titulos que foram incluidos com o tipo CD/CC/CH venda do sigaloja no Contas a Receber SE1
	cQuery := ""
	cQuery+= "SELECT E1_FILIAL FILIAL, E1_EMISSAO EMISSAO,E1_NUM DOC,E1_PREFIXO SERIE,E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_NATUREZ NATUREZA,A1_CONTA CONTA,E1_TIPO TIPO,SUM(E1_VALOR)  VALOR,SUM(E1_VLRREAL) VLRREAL "
	cQuery+= "FROM "+RetSqlName("SE1")+" E1 "
	If SM0->M0_CODIGO $ "01_06"
		cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
	Else
		cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = E1.E1_FILIAL AND SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
	EndIf
	cQuery += "WHERE E1.E1_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E1.D_E_L_E_T_ = ' '  "
	cQuery += "AND E1.E1_ORITCA <> 'MENTOR' "
	cQuery += "AND E1.E1_TIPO IN ('CD ','CC ','CH ') "
	cQuery += "AND E1.E1_FATURA = 'NOTFAT' "
	cQuery += "AND E1.E1_FLAGFAT <> 'S' "
	cQuery += "AND E1.E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
	cQuery += "AND E1.E1_CLIENTE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
	cQuery += "AND SA1.A1_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	cQuery += "AND E1.E1_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
	cQuery += "GROUP BY E1_FILIAL,E1_EMISSAO,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_NATUREZ,A1_CONTA,E1_TIPO  "
EndIf

If SELECT("TRBSE1I") > 0
	TRBSE1I->(DbcloseArea())
Endif

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE1I", .T., .T.)
dbGoTop()
ProcRegua(LastRec())

While !Eof()
	
	If TRBSE1I->TIPO $ "CH " .AND. ALLTRIM(TRBSE1I->SERIE) = "CP" .AND. SM0->M0_CODIGO $ "01"
		dbSelectArea("TRBSE1I")
		dbSkip()
		Loop
	EndIf
	
	cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
	cQuery += "AND CT2.CT2_AT01CR = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT03CR = '"+TRBSE1I->CLIENTE +"' "
	cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
	cQuery += "AND CT2_CREDIT = '"+TRBSE1I->CONTA+"'  "
	cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
	cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
	
	If SELECT("TRBCT2") > 0
		TRBCT2->(DbcloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	
	If TRBCT2->VALOR == 0
		cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01CR = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT02CR = 'NF' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_CREDIT = '"+TRBSE1I->CONTA+"'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	if  alltrim(TRBSE1I->DOC) == '003487'
		_nale:= 0
	endif
	
	If TRBCT2->VALOR <> TRBSE1I->VALOR .And. ALLTRIM(TRBSE1I->TIPO) $ 'CD' .And. SM0->M0_CODIGO $ "05"
		cQuery:= "SELECT CT2_AT01CR,CT2_AT02CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01CR = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT02CR = 'CD' "
		cQuery += "AND CT2_KEY LIKE '%"+TRBSE1I->SERIE+TRBSE1I->DOC+"%'  "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_CREDIT = '"+TRBSE1I->CONTA+"'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01CR,CT2_AT02CR,CT2_AT03CR "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	If TRBCT2->VALOR <> TRBSE1I->VALOR .And. ALLTRIM(TRBSE1I->TIPO) $ 'CC' .And. SM0->M0_CODIGO $ "05"
		cQuery:= "SELECT CT2_AT01CR,CT2_AT02CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01CR = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT02CR = 'CC' "
		cQuery += "AND CT2_KEY LIKE '%"+TRBSE1I->SERIE+TRBSE1I->DOC+"%'  "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_CREDIT = '"+TRBSE1I->CONTA+"'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01CR,CT2_AT02CR,CT2_AT03CR "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	EndIf
	
	dbSelectArea("TRB")
	RecLock("TRB",.T.)
	TRB->ARQUIVO	:=	"SE1"
	TRB->FILIAL			:=	TRBSE1I->FILIAL
	TRB->DT_MOV		:=	STOD(TRBSE1I->EMISSAO)
	TRB->NATUREZA	:= TRBSE1I->NATUREZA
	TRB->FORNECE	:=	TRBSE1I->CLIENTE
	TRB->LOJA			:=	TRBSE1I->LOJA
	If SM0->M0_CODIGO $ "01_05"
		TRB->NOMFORN	:=	Posicione("SA1",1,xFilial("SA1")+TRBSE1I->CLIENTE+TRBSE1I->LOJA,"A1_NOME")
	Else
		TRB->NOMFORN	:=	Posicione("SA1",1,TRBSE1I->FILIAL+TRBSE1I->CLIENTE+TRBSE1I->LOJA,"A1_NOME")
	EndIf
	TRB->DOC			:=	TRBSE1I->DOC
	TRB->SERIE			:=	TRBSE1I->SERIE
	TRB->TIPO			:= TRBSE1I->TIPO
	TRB->CONTA		:=	TRBSE1I->CONTA
	If TRBSE1I->DOC == "000007700" .AND. ALLTRIM(TRBSE1I->TIPO) == 'CC' .AND. TRBSE1I->CLIENTE == '004824' .And. SM0->M0_CODIGO $ '01'
		TRB->VALORPAG	+=	(TRBSE1I->VALOR + 7.29 + 2.07) // FOI INCLUIDO ESTA LINHA PQ O FINANCEIRO FEZ A MOVIMENTACAO ERRADA E NAO FECHA COM  CONTABILIDADE EM 29/01/2019 POR ALEXANDRE
	Else
		TRB->VALORPAG	+=	TRBSE1I->VALOR
	EndIf
	If TRBCT2->VALOR <> 0 .And. TRBSE1I->VALOR <> TRBCT2->VALOR .And. SM0->M0_CODIGO $ "05"  .And. ALLTRIM(TRBSE1I->TIPO) $ "CH"
		TRB->VLRCONTAB +=	(TRBSE1I->VALOR + 7.29 + 2.07)
	Else
		TRB->VLRCONTAB +=	TRBCT2->VALOR
	EndIf
	MsUnLock()
	If (TRBSE1I->VLRREAL - TRBSE1I->VALOR) > 0
		RecLock("TRB",.T.)
		TRB->ARQUIVO	:=	"SE1"
		TRB->FILIAL			:=	TRBSE1I->FILIAL
		TRB->DT_MOV		:=	STOD(TRBSE1I->EMISSAO)
		TRB->NATUREZA	:= TRBSE1I->NATUREZA
		TRB->FORNECE	:=	TRBSE1I->CLIENTE
		TRB->LOJA			:=	TRBSE1I->LOJA
		TRB->NOMFORN	:=	"TX ADM CARTAO"
		TRB->DOC			:=	TRBSE1I->DOC
		TRB->SERIE			:=	TRBSE1I->SERIE
		TRB->TIPO			:= TRBSE1I->TIPO
		TRB->CONTA		:=	TRBSE1I->CONTA
		TRB->VALORPAG	+=	TRBSE1I->(VLRREAL-VALOR)
		MsUnLock()
	EndIf
	
	dbSelectArea("TRBSE1I")
	
	dbSkip()
	
	IncProc("Montando arquivo de entrada por contas a receber " + TRBSE1I->DOC)
	
End

// Titulos que foram incluidos com o tipo CH na rotina de renegociacao no Contas a Receber SE1

If SM0->M0_CODIGO $ "02"
	cQuery := ""
	cQuery+= "SELECT E1_FILIAL FILIAL, E1_EMISSAO EMISSAO,E1_NUM DOC,E1_PREFIXO SERIE,E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_NATUREZ NATUREZA,A1_CONTA CONTA,E1_TIPO TIPO,E1_NUMLIQ,SUM(E1_VALOR)  VALOR,SUM(E1_VLRREAL) VLRREAL "
	cQuery+= "FROM "+RetSqlName("SE1")+" E1 "
	cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = E1.E1_FILIAL AND SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
	cQuery += "WHERE E1.E1_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E1.D_E_L_E_T_ = ' '  "
	cQuery += "AND E1.E1_TIPO IN ('CH ') "
	cQuery += "AND E1.E1_NUMLIQ <> '         ' "
	cQuery += "AND E1.E1_ORITCA <> 'MENTOR' "
	cQuery += "AND E1.E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
	cQuery += "AND E1.E1_CLIENTE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
	cQuery += "AND SA1.A1_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	cQuery += "AND E1.E1_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
	cQuery += "GROUP BY E1_FILIAL,E1_EMISSAO,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_NATUREZ,A1_CONTA,E1_TIPO,E1_NUMLIQ  "
	
	If SELECT("TRBSE1I") > 0
		TRBSE1I->(DbcloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE1I", .T., .T.)
	dbGoTop()
	ProcRegua(LastRec())
	
	While !Eof()
		
		If TRBSE1I->TIPO $ "CH " .AND. ALLTRIM(TRBSE1I->SERIE) = "CP" .AND. SM0->M0_CODIGO $ "01"
			dbSelectArea("TRBSE1I")
			dbSkip()
			Loop
		EndIf

/// Incluido no sistema pq existe titulos originais que tem valor menor que o novo devido a juros, entao ira buscar o juros do titulo original para descontar no valor do titulo CH para fechar na contabilidade em 29/01/2016 por Alexandre
		_nJuros := 0
		// Movimento Bancario SE5
		cQuery := ""
		cQuery += "SELECT E5_FILIAL ,E5_TIPO,E5_NATUREZ ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_TIPODOC,E5_DATA,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
		cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE1I->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
		cQuery += "AND E5.E5_CLIFOR = '"+TRBSE1I->CLIENTE+"'  "
		cQuery += "AND E5.E5_LOJA = '"+TRBSE1I->LOJA+"'  "
		cQuery += "AND E5.E5_DOCUMEN = '"+TRBSE1I->E1_NUMLIQ+"'  "
		cQuery += "AND E5.E5_TIPODOC = 'JR'  "
		cQuery += "GROUP BY E5_FILIAL,E5_TIPO,E5_NATUREZ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_TIPODOC,E5_DATA "
		
		If SELECT("TRBSE5JR") > 0
			TRBSE5JR->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5JR", .T., .T.)
		
		_nJuros		:= TRBSE5JR->VALOR
		
		cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
		cQuery += "AND CT2.CT2_AT01CR = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT03CR = '"+TRBSE1I->CLIENTE +"' "
		cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
		cQuery += "AND CT2_CREDIT = '"+TRBSE1I->CONTA+"'  "
		cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
		cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
		If SELECT("TRBCT2") > 0
			TRBCT2->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
		
		If TRBCT2->VALOR == 0
			cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
			cQuery += "AND CT2.CT2_AT01CR = '"+TRBSE1I->DOC+ "' AND CT2.CT2_AT02CR = 'NF' "
			cQuery += "AND CT2.CT2_DATA = '"+TRBSE1I->EMISSAO+"'  "
			cQuery += "AND CT2_CREDIT = '"+TRBSE1I->CONTA+"'  "
			cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
			cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
			
			If SELECT("TRBCT2") > 0
				TRBCT2->(DbcloseArea())
			Endif
			
			dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
		EndIf
		
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->ARQUIVO	:=	"SE1"
		TRB->FILIAL			:=	TRBSE1I->FILIAL
		TRB->DT_MOV		:=	STOD(TRBSE1I->EMISSAO)
		TRB->NATUREZA	:= TRBSE1I->NATUREZA
		TRB->FORNECE	:=	TRBSE1I->CLIENTE
		TRB->LOJA			:=	TRBSE1I->LOJA
		TRB->NOMFORN	:=	Posicione("SA1",1,TRBSE1I->FILIAL+TRBSE1I->CLIENTE+TRBSE1I->LOJA,"A1_NOME")
		TRB->DOC			:=	TRBSE1I->DOC
		TRB->SERIE			:=	TRBSE1I->SERIE
		TRB->TIPO			:= TRBSE1I->TIPO
		TRB->CONTA		:=	TRBSE1I->CONTA
		TRB->VALORPAG	+=	TRBSE1I->VALOR
		TRB->VLRCONTAB +=	TRBCT2->VALOR
		MsUnLock()

		If _nJuros <> 0
			dbSelectArea("TRBSE5JR")
			dbGoTop()
			While !Eof()
				dbSelectArea("TRB")
				RecLock("TRB",.T.)
					TRB->ARQUIVO	:=	"SE1"
					TRB->FILIAL			:=	TRBSE5JR->E5_FILIAL
					TRB->DT_MOV		:=	STOD(TRBSE5JR->E5_DATA)
					TRB->NATUREZA	:= TRBSE5JR->E5_NATUREZ
					TRB->FORNECE	:=	TRBSE5JR->E5_CLIFOR
					TRB->LOJA			:=	TRBSE5JR->E5_LOJA
					TRB->NOMFORN	:=	Posicione("SA1",1,TRBSE5JR->E5_FILIAL+TRBSE5JR->E5_CLIFOR+TRBSE5JR->E5_LOJA,"A1_NOME")
					TRB->DOC			:=	TRBSE5JR->E5_NUMERO
					TRB->SERIE			:=	TRBSE5JR->E5_PREFIXO
					TRB->TIPO			:= "JR"
					TRB->CONTA		:=	TRBSE1I->CONTA
					TRB->VALORCOMP:=	TRBSE5JR->VALOR
					TRB->VLRCONTAB :=	TRBSE5JR->VALOR
				MsUnLock()
				dbSelectArea("TRBSE5JR")
				dbSkip()
			End							
		EndIf
				
		dbSelectArea("TRBSE1I")
		
		dbSkip()
		
		IncProc("Montando arquivo de entrada por contas a receber " + TRBSE1I->DOC)
		
	End
EndIf

// Movimento Bancario SE5
cQuery := ""
// Foi alterado para nao trazer no valor principal o valor de juros devido em alguns caso ser acrescimo em 23/02/2016
cQuery += "SELECT E5_FILORIG FILORIG,E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR CLIENTE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_MOTBX MOTBX,E5_NATUREZ NATUREZA,A1_CONTA CONTA,E5_TIPODOC TIPODOC,E5_FATPREF FATPREF,E5_DOCUMEN DOCUMEN,E5_SEQ,E5_PARCELA,E5_FORNADT,SUM(E5_VALOR-E5_VLMULTA+E5_VLDESCO-E5_VLJUROS)  VALOR,SUM(E1_DECRESC) DECRESC,SUM(E5_VLDESCO) VLDESCO FROM "+RetSqlName("SE5")+" E5 "
cQuery += "LEFT JOIN "+RetSqlName("SE1")+" SE1 ON SE1.E1_PREFIXO = E5.E5_PREFIXO AND SE1.E1_NUM = E5.E5_NUMERO AND SE1.E1_PARCELA = E5.E5_PARCELA AND SE1.E1_CLIENTE = E5.E5_CLIFOR AND SE1.E1_LOJA = E5.E5_LOJA AND SE1.E1_TIPO = E5.E5_TIPO AND SE1.D_E_L_E_T_ = ' '  "
If SM0->M0_CODIGO $ "01_05_06"
	cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_COD = E5.E5_CLIFOR AND SA1.A1_LOJA = E5.E5_LOJA AND SA1.D_E_L_E_T_ = ' '  "
Else
	//cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = E5.E5_FILIAL AND SA1.A1_COD = E5.E5_CLIFOR AND SA1.A1_LOJA = E5.E5_LOJA AND SA1.D_E_L_E_T_ = ' '  "   //ALTERADO PELA LINHA ABAIXO POR TER COMPENSAÇÃO DE UMA FILIAL COM TITULO DE OUTRA EM 23/05/2016
	cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = E5.E5_FILORIG AND SA1.A1_COD = E5.E5_CLIFOR AND SA1.A1_LOJA = E5.E5_LOJA AND SA1.D_E_L_E_T_ = ' '  "
EndIf
cQuery += "WHERE E5.E5_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E5.D_E_L_E_T_ = ' '  " 
cQuery += "AND E5.E5_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  AND E5.E5_RECPAG = 'R'  AND E5.E5_CLIFOR <> ' ' AND E5.E5_NUMERO <> ' ' "
If SM0->M0_CODIGO $ "01_02"
	cQuery += "AND E5_TIPODOC NOT IN ('MT','CM','ES') "
Else
	cQuery += "AND E5_TIPODOC NOT IN ('MT','JR','CM','ES','DC') "
EndIf
cQuery += "AND E5.E5_CLIFOR BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
If MV_PAR09 == 1
	cQuery += "AND E5.E5_TIPO IN "+_cTipos
EndIf
cQuery += "AND E5.E5_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
//If SM0->M0_CODIGO $ "01_02_03" // Tirado para a Amanda avaliar
If SM0->M0_CODIGO $ "02_03"
	cQuery += "AND E5_MOTBX NOT IN ('LIQ','DEV') "
ElseIf SM0->M0_CODIGO $ "01" // Tirado
	cQuery += "AND E5_MOTBX NOT IN ('DEV') "
EndIf
//Incluido em 29/12/2015 por Alexandre para filtrar os titulos no SE1 da mentor
If SM0->M0_CODIGO $ "01_03"
	cQuery += "AND SE1.E1_ORITCA <> 'MENTOR' "
EndIf
If SM0->M0_CODIGO $ "01_05"
Else
	cQuery += "AND SA1.A1_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
EndIf
cQuery += "AND E5_SITUACA NOT IN ('C') "
cQuery += "AND E5_PREFIXO NOT IN ('DEB') "
cQuery += "GROUP BY E5_FILORIG,E5_FILIAL,E5_DATA,E5_CLIFOR,E5_LOJA,E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_MOTBX,E5_NATUREZ,A1_CONTA,E5_TIPODOC,E5_FATPREF,E5_DOCUMEN,E5_SEQ,E5_PARCELA,E5_FORNADT "
cQuery += "ORDER BY E5_DATA "

If SELECT("TRBSE5") > 0
	TRBSE5->(DbcloseArea())
Endif

dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5", .T., .T.)
dbGoTop()
ProcRegua(LastRec())

While !Eof()

//	IF TRBSE5->FILIAL >= MV_PAR03 .AND. TRBSE5->FILIAL <= MV_PAR04  //INCLUIDO POR TER COMPENSAÇÃO DE UMA FILIAL COM TITULO DE OUTRA EM 23/05/2016
			If ALLTRIM(TRBSE5->DOC) == "000216839"
				_NALE:= 0
			EndIf
			If ALLTRIM(TRBSE5->DOC) == "000010198"
				_NALE:= 0
			EndIf
			If SM0->M0_CODIGO $ "01_02"
				If !TRBSE5->TIPODOC $ "JR/DC" .AND. TRBSE5->MOTBX == "FAT"
					dbSelectArea("TRBSE5")
					dbSkip()
					Loop
				EndIf
				If TRBSE5->TIPODOC $ "JR/DC" .AND. TRBSE5->MOTBX <> "FAT"
					dbSelectArea("TRBSE5")
					dbSkip()
					Loop
				EndIf
			EndIf
			If TRBSE5->TIPO $ "CH " .AND. ALLTRIM(TRBSE5->PREFIXO) = "CP" .AND. SM0->M0_CODIGO $ "01"
				dbSelectArea("TRBSE5")
				dbSkip()
				Loop
			EndIf
			If ALLTRIM(TRBSE5->DOC) $ "PR41/2010"
				dbSelectArea("TRBSE5")
				dbSkip()
				Loop
			EndIf

			If SM0->M0_CODIGO $ '03_01_02'
				// Movimento Bancario SE5
				cQuery := ""
				cQuery += "SELECT E5_FILIAL ,E5_TIPO,E5_NATUREZ ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
				cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
				cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->CLIENTE+"'  "
				cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
				cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
				cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
				cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
				cQuery += "AND E5.E5_SEQ = '"+TRBSE5->E5_SEQ+"'  "
				cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->MOTBX+"'  "
				cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
				cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->E5_PARCELA+"'  "
				cQuery += "AND E5.E5_TIPODOC = 'ES'  "
				cQuery += "GROUP BY E5_FILIAL,E5_TIPO,E5_NATUREZ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC "
		
				If SELECT("TRBSE5ES") > 0
					TRBSE5ES->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5ES", .T., .T.)
		
				If TRBSE5ES->VALOR <> 0
					dbSelectArea("TRBSE5")
					dbSkip()
					IncProc()
					Loop
				EndIf
		
			EndIf
	
			dbSelectArea("TRBSE5")
			If MV_PAR13 == 2 .AND. TRBSE5->TIPO $ "RA /NCC" .AND. TRBSE5->MOTBX <> "CMP"
				dbSkip()
				IncProc()
				Loop
			EndIf
	
			If TRBSE5->TIPO == "NF " .AND. TRBSE5->TIPODOC == "BA" .AND. TRBSE5->MOTBX == "FAT" //.And. TRBSE5->FATPREF <> "CRT"
				dbSkip()
				IncProc()
				Loop
			EndIf
			If TRBSE5->TIPO == "FU " .AND. TRBSE5->TIPODOC == "BA" .AND. TRBSE5->MOTBX == "FAT" .And. SM0->M0_CODIGO $ "05"
				dbSkip()
				IncProc()
				Loop
			EndIf
	
			cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
			If SM0->M0_CODIGO $ "02_03"
				_cDoc := TRBSE5->DOC+"/"+TRBSE5->E5_PARCELA
				cQuery += "AND CT2_HIST LIKE '%"+AllTrim(_cDOC)+"%' AND CT2.CT2_AT03CR = '"+TRBSE5->CLIENTE +"' "
			Else
				cQuery += "AND CT2_HIST LIKE '%"+TRBSE5->DOC+"%' AND CT2.CT2_AT03CR = '"+TRBSE5->CLIENTE +"' "
			EndIf
			cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
			cQuery += "AND CT2_CREDIT = '"+TRBSE5->CONTA+"'  "
			cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
			cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
	
			If SELECT("TRBCT2") > 0
				TRBCT2->(DbcloseArea())
			Endif
	
			dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
	
			If TRBCT2->VALOR = 0
				cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
				cQuery += "AND CT2_AT01CR = '"+TRBSE5->DOC+"' AND CT2.CT2_AT03CR = '"+TRBSE5->CLIENTE +"' "
				cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND CT2_CREDIT = '"+TRBSE5->CONTA+"'  "
				cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
				cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
				If SELECT("TRBCT2") > 0
					TRBCT2->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
			EndIf
	
			If TRBCT2->VALOR = 0 .And. SM0->M0_CODIGO $ "01"
				cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
				cQuery += "AND CT2_AT01CR = '"+TRBSE5->DOC+"' AND CT2.CT2_AT03CR = '"+TRBSE5->E5_FORNADT +"' "
				cQuery += "AND CT2_HIST LIKE '%"+SUBSTRING(TRBSE5->DOCUMEN,4,9)+"%'  "
				cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND CT2_CREDIT = '"+TRBSE5->CONTA+"'  "
				cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
				cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
				If SELECT("TRBCT2") > 0
					TRBCT2->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
			EndIf
	
			If SM0->M0_CODIGO $ "05"
				cQuery:= "SELECT CT2_AT01CR,CT2_AT02CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
				cQuery += "AND CT2_AT01CR = '"+TRBSE5->DOC+"' AND CT2.CT2_AT03CR = '"+TRBSE5->CLIENTE +"' "
				cQuery += "AND CT2_AT02CR = '"+TRBSE5->TIPO+"'  "
				cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND CT2_CREDIT = '"+TRBSE5->CONTA+"'  "
				cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
				cQuery += "GROUP BY CT2_AT01CR,CT2_AT02CR,CT2_AT03CR "
		
				If SELECT("TRBCT2") > 0
					TRBCT2->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
			EndIf
	
	
			If TRBSE5->TIPODOC == 'CP' .And. SM0->M0_CODIGO == '02'
				cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
				If SM0->M0_CODIGO == "02"
					_cDoc := TRBSE5->DOC+"/"+TRBSE5->E5_PARCELA
					cQuery += "AND CT2_HIST LIKE '%"+AllTrim(_cDOC)+"%' AND CT2.CT2_AT03CR = '"+TRBSE5->CLIENTE +"' "
				Else
					cQuery += "AND CT2_HIST LIKE '%"+TRBSE5->DOC+"%' AND CT2.CT2_AT03CR = '"+TRBSE5->CLIENTE +"' "
				EndIf
				cQuery += "AND CT2.CT2_AT02CR IN ('NCC','RA ') "
				cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND CT2_CREDIT = '"+TRBSE5->CONTA+"'  "
				cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
				cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
				If SELECT("TRBCT2") > 0
					TRBCT2->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
			ElseIf TRBSE5->TIPODOC <> 'CP' .And. SM0->M0_CODIGO == '02'
				cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
				If SM0->M0_CODIGO == "02"
					_cDoc := TRBSE5->DOC+"/"+TRBSE5->E5_PARCELA
					cQuery += "AND CT2_HIST LIKE '%"+AllTrim(_cDOC)+"%' AND CT2.CT2_AT03CR = '"+TRBSE5->CLIENTE +"' "
				Else
					cQuery += "AND CT2_HIST LIKE '%"+TRBSE5->DOC+"%' AND CT2.CT2_AT03CR = '"+TRBSE5->CLIENTE +"' "
				EndIf
				cQuery += "AND CT2.CT2_AT02CR  NOT IN ('NCC','RA ') "
				cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND CT2_CREDIT = '"+TRBSE5->CONTA+"'  "
				cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
				cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
				If SELECT("TRBCT2") > 0
					TRBCT2->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
		
			EndIf
	
			If TRBCT2->VALOR = 0 .And. SM0->M0_CODIGO $ '02'
				cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
				cQuery += "AND CT2_AT01CR = '"+TRBSE5->DOC+"' AND CT2.CT2_AT03CR = '"+TRBSE5->CLIENTE +"' "
				cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND CT2_CREDIT = '"+TRBSE5->CONTA+"'  "
				cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
				cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
				If SELECT("TRBCT2") > 0
					TRBCT2->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
			EndIf
	
			If TRBCT2->VALOR = 0 .And. SM0->M0_CODIGO $ "02"
				cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
				cQuery += "AND CT2_HIST LIKE '%"+SUBSTRING(TRBSE5->DOCUMEN,4,9)+"%'  "
				cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND CT2_CREDIT = '"+TRBSE5->CONTA+"'  "
				cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
				cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
				If SELECT("TRBCT2") > 0
					TRBCT2->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
			EndIf
	
			If TRBCT2->VALOR = 0 .And. TRBSE5->MOTBX = 'CMP' .And. SM0->M0_CODIGO $ '02'
				// Movimento Bancario SE5
				cQuery := ""
				cQuery += "SELECT E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR CLIENTE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_MOTBX MOTBX,E5_NATUREZ NATUREZA,E5_TIPODOC TIPODOC,E5_FATPREF FATPREF,E5_DOCUMEN DOCUMEN,SUM(E5_VALOR-E5_VLJUROS-E5_VLMULTA)  VALOR FROM "+RetSqlName("SE5")+" E5 "
				cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
				cQuery += "AND E5.E5_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->CLIENTE+"'  "
				cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
				cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
				cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
				cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
				cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->MOTBX+"'  "
				cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
				cQuery += "AND E5.E5_TIPODOC = '"+TRBSE5->TIPODOC+"'  "
				cQuery += "AND E5.E5_FATPREF = '"+TRBSE5->FATPREF+"'  "
				cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->E5_PARCELA+"'  "
				cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_CLIFOR,E5_LOJA,E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_MOTBX,E5_NATUREZ,E5_TIPODOC,E5_FATPREF,E5_DOCUMEN "
				cQuery += "ORDER BY E5_DATA "
		
				If SELECT("TRBSE5O") > 0
					TRBSE5O->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5O", .T., .T.)
			EndIf
	
			If TRBCT2->VALOR = 0 .And. TRBSE5->MOTBX = 'CMP' .And. SM0->M0_CODIGO <> '02'
				cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
				cQuery += "AND CT2_HIST LIKE '%"+SUBSTRING(TRBSE5->DOCUMEN,4,9)+"%' AND CT2.CT2_AT03CR = '"+TRBSE5->CLIENTE +"' "
				cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND CT2_CREDIT = '"+TRBSE5->CONTA+"'  "
				cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
				cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
				If SELECT("TRBCT2") > 0
					TRBCT2->(DbcloseArea())
				Endif
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
			EndIf
	
			If TRBCT2->VALOR = 0 .And. TRBSE5->MOTBX = 'CMP' .And. SM0->M0_CODIGO $ '02'
				cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
				cQuery += "AND CT2_HIST LIKE '%"+SUBSTRING(TRBSE5O->DOCUMEN,4,9)+"%' AND CT2.CT2_AT03CR = '"+TRBSE5->CLIENTE +"' "
				cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND CT2_CREDIT = '"+TRBSE5->CONTA+"'  "
				cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
				cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
				If SELECT("TRBCT2") > 0
					TRBCT2->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
			EndIf
	
			If TRBCT2->VALOR = 0 .And. AllTrim(TRBSE5->TIPO) $ "CD/CC"
				cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
				cQuery += "AND CT2_AT01CR = '"+TRBSE5->DOC+"' AND CT2.CT2_AT03CR = '"+TRBSE5->CLIENTE +"' "
				cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND CT2_CREDIT = '11201005'  "
				cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
				cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
				If SELECT("TRBCT2") > 0
					TRBCT2->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
			EndIf
	
			If TRBCT2->VALOR = 0 .And. SM0->M0_CODIGO $ "02"
				cQuery:= "SELECT CT2_AT01CR,CT2_AT03CR,SUM(CT2_VALOR)  VALOR FROM "+RETSQLNAME('CT2')+" CT2  WHERE CT2.CT2_FILIAL  BETWEEN '" + MV_PAR03 + "' AND '"+MV_PAR04 + "' "
				cQuery += "AND CT2_FILIAL = '"+TRBSE5->FILIAL+"'  "
				cQuery += "AND CT2_HIST LIKE '%"+AllTrim(TRBSE5->DOC)+"%'  "
				cQuery += "AND CT2.CT2_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND CT2_CREDIT = '"+TRBSE5->CONTA+"'  "
				cQuery += "AND CT2.D_E_L_E_T_ = ' '    "
				cQuery += "GROUP BY CT2_AT01CR,CT2_AT03CR "
		
				If SELECT("TRBCT2") > 0
					TRBCT2->(DbcloseArea())
				Endif
		
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBCT2", .T., .T.)
			EndIf

			_nJuros := 0
	
			If SM0->M0_CODIGO $ "01_02" .AND. TRBSE5->TIPODOC == 'JR'
			Else
				cQuery := ""
				cQuery += "SELECT E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR CLIENTE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_MOTBX MOTBX,E5_NATUREZ NATUREZA,E5_TIPODOC TIPODOC,E5_FATPREF FATPREF,E5_DOCUMEN DOCUMEN,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
				cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
				cQuery += "AND E5.E5_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->CLIENTE+"'  "
				cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
				cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
				cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
				cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
				cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->MOTBX+"'  "
				cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
				cQuery += "AND E5.E5_TIPODOC = 'JR'  "
				cQuery += "AND E5.E5_FATPREF = '"+TRBSE5->FATPREF+"'  "
				cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->E5_PARCELA+"'  "
				cQuery += "AND E5.E5_SEQ = '"+TRBSE5->E5_SEQ+"'  "
				cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_CLIFOR,E5_LOJA,E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_MOTBX,E5_NATUREZ,E5_TIPODOC,E5_FATPREF,E5_DOCUMEN "
				cQuery += "ORDER BY E5_DATA "
	
				If SELECT("TRBSE5JUR") > 0
					TRBSE5JUR->(DbcloseArea())
				Endif
	
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5JUR", .T., .T.)

				_nJuros := TRBSE5JUR->VALOR
			EndIf	

			_nDescont := 0

			If SM0->M0_CODIGO $ "01_02" .AND. TRBSE5->TIPODOC == 'DC'
			Else
				cQuery := ""
				cQuery += "SELECT E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR CLIENTE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_MOTBX MOTBX,E5_NATUREZ NATUREZA,E5_TIPODOC TIPODOC,E5_FATPREF FATPREF,E5_DOCUMEN DOCUMEN,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
				cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
				cQuery += "AND E5.E5_DATA = '"+TRBSE5->DATA+"'  "
				cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->CLIENTE+"'  "
				cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
				cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
				cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
				cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
				cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->MOTBX+"'  "
				cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
				cQuery += "AND E5.E5_TIPODOC = 'DC'  "
				cQuery += "AND E5.E5_SITUACA = ' '  "
				cQuery += "AND E5.E5_FATPREF = '"+TRBSE5->FATPREF+"'  "
				cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->E5_PARCELA+"'  "
				cQuery += "AND E5.E5_SEQ = '"+TRBSE5->E5_SEQ+"'  "
				cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_CLIFOR,E5_LOJA,E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_MOTBX,E5_NATUREZ,E5_TIPODOC,E5_FATPREF,E5_DOCUMEN "
				cQuery += "ORDER BY E5_DATA "
	
				If SELECT("TRBSE5DES") > 0
					TRBSE5DES->(DbcloseArea())
				Endif
	
				dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5DES", .T., .T.)

				_nDescont := TRBSE5DES->VALOR
			
			EndIf
		
			dbSelectArea("TRB")
	
			RecLock("TRB",.T.)
			TRB->ARQUIVO	:=	"SE5"
			TRB->FILIAL			:=	TRBSE5->FILIAL
			TRB->DT_MOV		:= STOD(TRBSE5->DATA)
			TRB->FORNECE	:=	TRBSE5->CLIENTE
			TRB->LOJA			:=	TRBSE5->LOJA
			If SM0->M0_CODIGO $ "01_05"
				TRB->NOMFORN	:=	Posicione("SA1",1,xFilial("SA1")+TRBSE5->CLIENTE+TRBSE5->LOJA,"A1_NOME")
			Else
				TRB->NOMFORN	:=	Posicione("SA1",1,TRBSE5->FILORIG+TRBSE5->CLIENTE+TRBSE5->LOJA,"A1_NOME")
			EndIf
			TRB->DOC			:=	TRBSE5->DOC
			TRB->SERIE			:=	TRBSE5->PREFIXO
			If AllTrim(TRBSE5->TIPO) $ "CD/CC"
				TRB->CONTA		:=	"11201005"
			ElseIf AllTrim(TRBSE5->TIPO) $ "CH"
				TRB->CONTA		:=	"11201007"
			Else
				TRB->CONTA		:=	TRBSE5->CONTA
			EndIf
			TRB->PARCELA	:= TRBSE5->E5_PARCELA
			TRB->TIPO			:= TRBSE5->TIPO
			TRB->NATUREZA	:=	TRBSE5->NATUREZA
			If SM0->M0_CODIGO $ "01_02"
				If TRBSE5->TIPODOC == "JR" .AND. TRBSE5->MOTBX == "FAT" //INCLUIDO POR ALEXANDRE EM 27/01/2016
					TRB->VALORCOMP	+=	TRBSE5->VALOR - _nJuros + _nDescont
				Else
					TRB->VALORPAG	+=	TRBSE5->VALOR //- _nJuros Foi alterado para nao trazer no valor principal o valor de juros devido em alguns caso ser acrescimo em 23/02/2016  // + _nDescont tirado por Alexandre em 17/02/2016 devido a mudanca da regra de desconto por motivo FAT
				EndIf
			ElseIf SM0->M0_CODIGO $ "05"
				TRB->VALORPAG	+=   (TRBSE5->	VALOR) // + _nDescont)
			Else
				TRB->VALORPAG	+=	TRBSE5->	VALOR
			EndIf
			IF TRBCT2->VALOR <> 0 .AND. TRBSE5->VALOR <> TRBCT2->VALOR .AND. SM0->M0_CODIGO $ "03"
				TRB->VLRCONTAB +=	TRBSE5->VALOR
			ElseIF TRBCT2->VALOR <> 0 .AND. TRBSE5->VALOR <> TRBCT2->VALOR .AND. SM0->M0_CODIGO $ "01" //incluido para as novas regras de juros para a empresa 01 em 11/02/2016 por Alexandre
				TRB->VLRCONTAB +=	(TRBSE5->VALOR - _nJuros)
			ELSEIF TRBCT2->VALOR <> 0 .AND. TRBSE5->VALOR <> TRBCT2->VALOR .AND. SM0->M0_CODIGO $ "02"
				TRB->VLRCONTAB +=	(TRBSE5->VALOR - _nJuros + _nDescont)
			ELSE
				TRB->VLRCONTAB +=	TRBCT2->VALOR
			ENDIF
			MsUnLock()
//	ENDIF
		
	dbSelectArea("TRBSE5")
	
	dbSkip()
	
	IncProc()
	
End

Processa({ || GERXLSREC(.F.)}, "Aguarde",,.t.)

RETURN()


STATIC FUNCTION GERXLSREC(lSchedule)

Local nConvert := 1
Local oExcel	:= FWMSEXCEL():New()

//oExcel:SetItalic(.T.)
oExcel:Set2LineBgColor("#F0F0F0")
oExcel:SetFontSize(10)
oExcel:SetFont("Arial")
oExcel:SetBold(.F.)

oExcel:AddworkSheet("Parametro")
oExcel:AddTable ("Parametro","Parametro Selecionado"+_cEmp)
oExcel:AddColumn("Parametro","Parametro Selecionado"+_cEmp,"Pergunta",1,4)
oExcel:AddColumn("Parametro","Parametro Selecionado"+_cEmp,"Respostas",1,2)
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Data de",mv_par01 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Data ate",mv_par02 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Da Filial",mv_par03 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Ate Filial",mv_par04 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Conta de",mv_par05 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Conta Ate",mv_par06 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Natureza de",mv_par07 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Natureza Ate",mv_par08 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Seleciona Tipo",IF(mv_par09=1,"Sim","Nao")+" - "+_cTipos })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Carteira",IF(mv_par10=1,"Pagar","Receber") })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Codigo de",mv_par11 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Codigo Ate",mv_par12 })
oExcel:AddRow("Parametro","Parametro Selecionado"+_cEmp,{"Imprime entrada PA/NDF e RA/NCC",IF(mv_par13=1,"Sim","Nao") })

oExcel:AddworkSheet("Razonete")
oExcel:AddTable ("Razonete","Relatório Razonete a Receber" + _cEmp )
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Empresa/Filial",1,4)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Data do Movimento",1,4)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Código do Cliente",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Nome do Cliente",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Nº Título",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Parcela",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Tipo",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Conta Contábil",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Natureza",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Valor da Venda (Débito)",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Valor da Recebimento (Crédito)",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Saldo",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Valor Contabil",1,2)
oExcel:AddColumn("Razonete","Relatório Razonete a Receber" + _cEmp,"Diferenca",1,2)

// Monta o saldo inicial do relatorio de razonete de Contas a Receber SE1
_dDataIni	:= Firstday(MV_PAR01)  - 1
_aSdoContabil := {}
_nSldRec:=	0 //SldReceber(_dDataIni,1,.T.,.T.)
_aConta:={}
_nSaldoAnt := 0

_cMesAno1 := dtos(mv_par01-1)
_cMesAno := dtos(mv_par02)
_cMesAno := SubStr(_cMesAno,5,2)+SubStr(_cMesAno,1,4)
_cMesAno1 := SubStr(_cMesAno1,5,2)+SubStr(_cMesAno1,1,4)

dbSelectArea("ZZC")
dbSeek(xFilial("ZZC")+"R"+_cMesAno1+"EMCTBR05")

If !Eof()
	_nSaldoAnt:= ZZC->ZZC_SALDO
Else
	// Titulos no Contas a Receber SE1
	cQuery := ""
	cQuery+= "SELECT E1_FILIAL FILIAL, E1_EMISSAO EMISSAO,E1_NUM DOC,E1_PREFIXO SERIE,E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_NATUREZ NATUREZA,A1_CONTA CONTA,E1_TIPO TIPO,E1_FATURA FATURA,SUM(E1_VALOR)  VALOR,SUM(E1_VLRREAL) VLRREAL "
	cQuery+= "FROM "+RetSqlName("SE1")+" E1 "
	If SM0->M0_CODIGO $ "01_05_06"
		cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
	Else
		cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = E1.E1_FILIAL AND SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
	EndIf
	cQuery += "WHERE E1.E1_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E1.D_E_L_E_T_ = ' '  "
	If MV_PAR09 == 1
		cQuery += "AND E1.E1_TIPO IN "+_cTipos
	EndIf
	If SM0->M0_CODIGO $ "01_03"
		cQuery += "AND E1.E1_PREFIXO NOT IN ('CRT') "
	EndIf
	cQuery += "AND E1.E1_ORITCA <> 'MENTOR' "
	cQuery += "AND E1.E1_EMISSAO BETWEEN '20150101' AND '"+DTOS(MV_PAR01-1)+"'  "
	cQuery += "AND E1.E1_CLIENTE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
	cQuery += "AND SA1.A1_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	cQuery += "AND E1.E1_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
	cQuery += "GROUP BY E1_FILIAL,E1_EMISSAO,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_NATUREZ,A1_CONTA,E1_TIPO,E1_FATURA  "
	
	If SELECT("TRBSE1I") > 0
		TRBSE1I->(DbcloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE1I", .T., .T.)
	dbGoTop()
	ProcRegua(LastRec())
	
	While !Eof()
		
		If MV_PAR13 == 2 .AND. TRBSE1I->TIPO $ "RA /NCC" //.AND. TRBSE1I->E5_MOTBX <> "CMP"
			dbSelectArea("TRBSE1I")
			dbSkip()
			Loop
		EndIf
		
		If TRBSE1I->TIPO $ "BOL" .AND. ALLTRIM(TRBSE1I->FATURA) = "NOTFAT"
			dbSelectArea("TRBSE1I")
			dbSkip()
			Loop
		EndIf
		If TRBSE1I->TIPO $ "CC " .AND. ALLTRIM(TRBSE1I->FATURA) = "NOTFAT"  .AND. SM0->M0_CODIGO $ "02"
			dbSelectArea("TRBSE1I")
			dbSkip()
			Loop
		EndIf
		If TRBSE1I->TIPO $ "FT " .AND. ALLTRIM(TRBSE1I->FATURA) = "NOTFAT"
			dbSelectArea("TRBSE1I")
			dbSkip()
			Loop
		EndIf
		If TRBSE1I->TIPO $ "CH " .AND. ALLTRIM(TRBSE1I->SERIE) = "CP" .AND. SM0->M0_CODIGO $ "01"
			dbSelectArea("TRBSE1I")
			dbSkip()
			Loop
		EndIf
		If TRBSE1I->TIPO $ "CH " .AND. SM0->M0_CODIGO $ "02"
			dbSelectArea("TRBSE1I")
			dbSkip()
			Loop
		EndIf
		
		If ALLTRIM(TRBSE1I->TIPO) $ "CD/CC" .AND. SM0->M0_CODIGO $ "05"
			_nSldRec +=	TRBSE1I->VLRREAL
		Else
			_nSldRec +=	TRBSE1I->VALOR
		EndIf
		
		dbSelectArea("TRBSE1I")
		dbSkip()
		
		IncProc("Montando saldo inicial do contas a receber " + TRBSE1I->DOC)
		
	End
	If SM0->M0_CODIGO $ "01_05"
		// Titulos que foram incluidos com o tipo CD/CC/CH venda do sigaloja no Contas a Receber SE1
		cQuery := ""
		cQuery+= "SELECT E1_FILIAL FILIAL, E1_EMISSAO EMISSAO,E1_NUM DOC,E1_PREFIXO SERIE,E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_NATUREZ NATUREZA,A1_CONTA CONTA,E1_TIPO TIPO,SUM(E1_VALOR)  VALOR,SUM(E1_VLRREAL) VLRREAL "
		cQuery+= "FROM "+RetSqlName("SE1")+" E1 "
		cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
		cQuery += "WHERE E1.E1_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E1.D_E_L_E_T_ = ' '  "
		cQuery += "AND E1.E1_TIPO IN ('CD ','CC ','CH ') "
		//	cQuery += "AND E1.E1_FATURA = 'NOTFAT' "
		cQuery += "AND E1.E1_ORITCA <> 'MENTOR' "
		cQuery += "AND E1.E1_FLAGFAT <> 'S' "
		cQuery += "AND E1.E1_EMISSAO BETWEEN '20150101' AND '"+DTOS(MV_PAR01-1)+"'  "
		cQuery += "AND E1.E1_CLIENTE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
		cQuery += "AND SA1.A1_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
		cQuery += "AND E1.E1_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
		cQuery += "GROUP BY E1_FILIAL,E1_EMISSAO,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_NATUREZ,A1_CONTA,E1_TIPO  "
	Else
		// Titulos que foram incluidos com o tipo CD/CC/CH venda do sigaloja no Contas a Receber SE1
		cQuery := ""
		cQuery+= "SELECT E1_FILIAL FILIAL, E1_EMISSAO EMISSAO,E1_NUM DOC,E1_PREFIXO SERIE,E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_NATUREZ NATUREZA,A1_CONTA CONTA,E1_TIPO TIPO,SUM(E1_VALOR)  VALOR,SUM(E1_VLRREAL) VLRREAL "
		cQuery+= "FROM "+RetSqlName("SE1")+" E1 "
		If SM0->M0_CODIGO $ "01_06"
			cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
		Else
			cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = E1.E1_FILIAL AND SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
		EndIf
		cQuery += "WHERE E1.E1_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E1.D_E_L_E_T_ = ' '  "
		cQuery += "AND E1.E1_ORITCA <> 'MENTOR' "
		cQuery += "AND E1.E1_TIPO IN ('CD ','CC ','CH ') "
		cQuery += "AND E1.E1_FATURA = 'NOTFAT' "
		cQuery += "AND E1.E1_FLAGFAT <> 'S' "
		cQuery += "AND E1.E1_EMISSAO BETWEEN '20150101' AND '"+DTOS(MV_PAR01-1)+"'  "
		cQuery += "AND E1.E1_CLIENTE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
		cQuery += "AND SA1.A1_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
		cQuery += "AND E1.E1_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
		cQuery += "GROUP BY E1_FILIAL,E1_EMISSAO,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_NATUREZ,A1_CONTA,E1_TIPO  "
	EndIf
	If SELECT("TRBSE1I") > 0
		TRBSE1I->(DbcloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE1I", .T., .T.)
	dbGoTop()
	ProcRegua(LastRec())
	
	While !Eof()
		
		If TRBSE1I->TIPO $ "CH " .AND. ALLTRIM(TRBSE1I->SERIE) = "CP" .AND. SM0->M0_CODIGO $ "01"
			dbSelectArea("TRBSE1I")
			dbSkip()
			Loop
		EndIf
		
		_nSldRec +=	TRBSE1I->VALOR
		
		If (TRBSE1I->VLRREAL - TRBSE1I->VALOR) > 0
			_nSldRec +=	TRBSE1I->(VLRREAL-VALOR)
		EndIf
		
		dbSelectArea("TRBSE1I")
		
		dbSkip()
		
		IncProc("Montando saldo inicial do contas a receber " + TRBSE1I->DOC)
		
	End
	
	// Titulos que foram incluidos com o tipo CH na rotina de renegociacao no Contas a Receber SE1
	
	If SM0->M0_CODIGO $ "02"
		cQuery := ""
		cQuery+= "SELECT E1_FILIAL FILIAL, E1_EMISSAO EMISSAO,E1_NUM DOC,E1_PREFIXO SERIE,E1_CLIENTE CLIENTE,E1_LOJA LOJA,E1_NATUREZ NATUREZA,A1_CONTA CONTA,E1_TIPO TIPO,SUM(E1_VALOR)  VALOR,SUM(E1_VLRREAL) VLRREAL "
		cQuery+= "FROM "+RetSqlName("SE1")+" E1 "
		cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = E1.E1_FILIAL AND SA1.A1_COD = E1.E1_CLIENTE AND SA1.A1_LOJA = E1.E1_LOJA  AND SA1.D_E_L_E_T_ = ' '  "
		cQuery += "WHERE E1.E1_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E1.D_E_L_E_T_ = ' '  "
		cQuery += "AND E1.E1_TIPO IN ('CH ') "
		cQuery += "AND E1.E1_NUMLIQ <> '         ' "
		cQuery += "AND E1.E1_ORITCA <> 'MENTOR' "
		cQuery += "AND E1.E1_EMISSAO BETWEEN '20150101' AND '"+DTOS(MV_PAR01-1)+"'  "
		cQuery += "AND E1.E1_CLIENTE BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
		cQuery += "AND SA1.A1_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
		cQuery += "AND E1.E1_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
		cQuery += "GROUP BY E1_FILIAL,E1_EMISSAO,E1_NUM,E1_PREFIXO,E1_CLIENTE,E1_LOJA,E1_NATUREZ,A1_CONTA,E1_TIPO  "
		
		If SELECT("TRBSE1I") > 0
			TRBSE1I->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE1I", .T., .T.)
		dbGoTop()
		ProcRegua(LastRec())
		
		While !Eof()
			
			If TRBSE1I->TIPO $ "CH " .AND. ALLTRIM(TRBSE1I->SERIE) = "CP" .AND. SM0->M0_CODIGO $ "01"
				dbSelectArea("TRBSE1I")
				dbSkip()
				Loop
			EndIf
			
			_nSldRec +=	TRBSE1I->VALOR
			
			dbSelectArea("TRBSE1I")
			
			dbSkip()
			
			IncProc("Montando saldo inicial do contas a receber " + TRBSE1I->DOC)
			
		End
	EndIf
	
	// Movimento Bancario SE5
	cQuery := ""
	If SM0->M0_CODIGO $ "02"
		cQuery += "SELECT E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR CLIENTE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_MOTBX MOTBX,E5_NATUREZ NATUREZA,A1_CONTA CONTA,E5_TIPODOC TIPODOC,E5_FATPREF FATPREF,E5_DOCUMEN DOCUMEN,E5_SEQ,E5_PARCELA,SUM(E5_VALOR-E5_VLMULTA)  VALOR,SUM(E1_DECRESC) DECRESC,SUM(E5_VLDESCO) VLDESCO FROM "+RetSqlName("SE5")+" E5 "
		cQuery += "LEFT JOIN "+RetSqlName("SE1")+" SE1 ON SE1.E1_PREFIXO = E5.E5_PREFIXO AND SE1.E1_NUM = E5.E5_NUMERO AND SE1.E1_PARCELA = E5.E5_PARCELA AND SE1.E1_CLIENTE = E5.E5_CLIFOR AND SE1.E1_LOJA = E5.E5_LOJA AND SE1.E1_TIPO = E5.E5_TIPO AND SE1.D_E_L_E_T_ = ' '  "
	ElseIf SM0->M0_CODIGO $ "03_01"
		cQuery += "SELECT E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR CLIENTE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_MOTBX MOTBX,E5_NATUREZ NATUREZA,A1_CONTA CONTA,E5_TIPODOC TIPODOC,E5_FATPREF FATPREF,E5_DOCUMEN DOCUMEN,E5_SEQ,E5_PARCELA,E5_FORNADT,SUM(E5_VALOR-E5_VLJUROS-E5_VLMULTA+E5_VLDESCO)  VALOR FROM "+RetSqlName("SE5")+" E5 "
	ElseIf SM0->M0_CODIGO $ "05"
		cQuery += "SELECT E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR CLIENTE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_MOTBX MOTBX,E5_NATUREZ NATUREZA,A1_CONTA CONTA,E5_TIPODOC TIPODOC,E5_FATPREF FATPREF,E5_DOCUMEN DOCUMEN,SUM(E5_VALOR-E5_VLJUROS-E5_VLMULTA)  VALOR FROM "+RetSqlName("SE5")+" E5 "
	Else
		cQuery += "SELECT E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR CLIENTE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_MOTBX MOTBX,E5_NATUREZ NATUREZA,A1_CONTA CONTA,E5_TIPODOC TIPODOC,E5_FATPREF FATPREF,E5_DOCUMEN DOCUMEN,SUM(E5_VALOR-E5_VLJUROS-E5_VLMULTA+E5_VLDESCO)  VALOR FROM "+RetSqlName("SE5")+" E5 "
	EndIf
	If SM0->M0_CODIGO $ "01_05"
		cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_COD = E5.E5_CLIFOR AND SA1.A1_LOJA = E5.E5_LOJA AND SA1.D_E_L_E_T_ = ' '  "
	Else
		cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.A1_FILIAL = E5.E5_FILIAL AND SA1.A1_COD = E5.E5_CLIFOR AND SA1.A1_LOJA = E5.E5_LOJA AND SA1.D_E_L_E_T_ = ' '  "
	EndIf
	cQuery += "WHERE E5.E5_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND E5.D_E_L_E_T_ = ' '  "
	cQuery += "AND E5.E5_DATA BETWEEN '20150101' AND '"+DTOS(MV_PAR01-1)+"'  AND E5.E5_RECPAG = 'R'  AND E5.E5_CLIFOR <> ' ' AND E5.E5_NUMERO <> ' ' "
	cQuery += "AND E5_TIPODOC NOT IN ('MT','JR','CM','ES','DC') "
	cQuery += "AND E5.E5_CLIFOR BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
	If MV_PAR09 == 1
		cQuery += "AND E5.E5_TIPO IN "+_cTipos
	EndIf
	cQuery += "AND E5.E5_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
	If SM0->M0_CODIGO $ "01_02_03"
		cQuery += "AND E5_MOTBX NOT IN ('LIQ','DEV') "
	EndIf
	If SM0->M0_CODIGO $ "01_05"
	Else
		cQuery += "AND SA1.A1_CONTA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	EndIf
	If SM0->M0_CODIGO $ "02"
		cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_CLIFOR,E5_LOJA,E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_MOTBX,E5_NATUREZ,A1_CONTA,E5_TIPODOC,E5_FATPREF,E5_DOCUMEN,E5_SEQ,E5_PARCELA "
	ElseIf SM0->M0_CODIGO $ "03_01"
		cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_CLIFOR,E5_LOJA,E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_MOTBX,E5_NATUREZ,A1_CONTA,E5_TIPODOC,E5_FATPREF,E5_DOCUMEN,E5_SEQ,E5_PARCELA,E5_FORNADT "
	Else
		cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_CLIFOR,E5_LOJA,E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_MOTBX,E5_NATUREZ,A1_CONTA,E5_TIPODOC,E5_FATPREF,E5_DOCUMEN "
	EndIf
	cQuery += "ORDER BY E5_DATA "
	
	If SELECT("TRBSE5") > 0
		TRBSE5->(DbcloseArea())
	Endif
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5", .T., .T.)
	dbGoTop()
	ProcRegua(LastRec())
	
	While !Eof()
		If TRBSE5->TIPO $ "CH " .AND. ALLTRIM(TRBSE5->PREFIXO) = "CP" .AND. SM0->M0_CODIGO $ "01"
			dbSelectArea("TRBSE5")
			dbSkip()
			Loop
		EndIf
		
		If SM0->M0_CODIGO $ '03_01_02'
			// Movimento Bancario SE5
			cQuery := ""
			cQuery += "SELECT E5_FILIAL ,E5_TIPO,E5_NATUREZ ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
			cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
			cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->CLIENTE+"'  "
			cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
			cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
			cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
			cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
			cQuery += "AND E5.E5_SEQ = '"+TRBSE5->E5_SEQ+"'  "
			cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->MOTBX+"'  "
			cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
			cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->E5_PARCELA+"'  "
			cQuery += "AND E5.E5_TIPODOC = 'ES'  "
			cQuery += "GROUP BY E5_FILIAL,E5_TIPO,E5_NATUREZ,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_MOTBX,E5_SEQ,E5_TIPODOC "
			
			If SELECT("TRBSE5ES") > 0
				TRBSE5ES->(DbcloseArea())
			Endif
			
			dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5ES", .T., .T.)
			
			If TRBSE5ES->VALOR <> 0
				dbSelectArea("TRBSE5")
				dbSkip()
				IncProc()
				Loop
			EndIf
			
		EndIf
		
		dbSelectArea("TRBSE5")
		If MV_PAR13 == 2 .AND. TRBSE5->TIPO $ "RA /NCC" .AND. TRBSE5->MOTBX <> "CMP"
			dbSkip()
			IncProc()
			Loop
		EndIf
		
		If TRBSE5->TIPO == "NF " .AND. TRBSE5->TIPODOC == "BA" .AND. TRBSE5->MOTBX == "FAT" //.And. TRBSE5->FATPREF <> "CRT"
			dbSkip()
			IncProc()
			Loop
		EndIf
		If TRBSE5->TIPO == "FU " .AND. TRBSE5->TIPODOC == "BA" .AND. TRBSE5->MOTBX == "FAT" .And. SM0->M0_CODIGO $ "05"
			dbSkip()
			IncProc()
			Loop
		EndIf
		
		cQuery := ""
		cQuery += "SELECT E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR CLIENTE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_MOTBX MOTBX,E5_NATUREZ NATUREZA,E5_TIPODOC TIPODOC,E5_FATPREF FATPREF,E5_DOCUMEN DOCUMEN,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
		cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
		cQuery += "AND E5.E5_DATA = '"+TRBSE5->DATA+"'  "
		cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->CLIENTE+"'  "
		cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
		cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
		cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
		cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
		cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->MOTBX+"'  "
		cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
		cQuery += "AND E5.E5_TIPODOC = 'JR'  "
		cQuery += "AND E5.E5_FATPREF = '"+TRBSE5->FATPREF+"'  "
		If SM0->M0_CODIGO == "02"
			cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->E5_PARCELA+"'  "
		EndIf
		cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_CLIFOR,E5_LOJA,E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_MOTBX,E5_NATUREZ,E5_TIPODOC,E5_FATPREF,E5_DOCUMEN "
		cQuery += "ORDER BY E5_DATA "
		
		If SELECT("TRBSE5JUR") > 0
			TRBSE5JUR->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5JUR", .T., .T.)
		
		cQuery := ""
		cQuery += "SELECT E5_FILIAL FILIAL,E5_DATA DATA,E5_CLIFOR CLIENTE,E5_LOJA LOJA,E5_NUMERO DOC,E5_PREFIXO PREFIXO, E5_TIPO TIPO , E5_MOTBX MOTBX,E5_NATUREZ NATUREZA,E5_TIPODOC TIPODOC,E5_FATPREF FATPREF,E5_DOCUMEN DOCUMEN,SUM(E5_VALOR)  VALOR FROM "+RetSqlName("SE5")+" E5 "
		cQuery += "WHERE E5.E5_FILIAL = '"+TRBSE5->FILIAL+"' AND E5.D_E_L_E_T_ = ' '  "
		cQuery += "AND E5.E5_DATA = '"+TRBSE5->DATA+"'  "
		cQuery += "AND E5.E5_CLIFOR = '"+TRBSE5->CLIENTE+"'  "
		cQuery += "AND E5.E5_LOJA = '"+TRBSE5->LOJA+"'  "
		cQuery += "AND E5.E5_NUMERO = '"+TRBSE5->DOC+"'  "
		cQuery += "AND E5.E5_PREFIXO = '"+TRBSE5->PREFIXO+"'  "
		cQuery += "AND E5.E5_TIPO = '"+TRBSE5->TIPO+"'  "
		cQuery += "AND E5.E5_MOTBX = '"+TRBSE5->MOTBX+"'  "
		cQuery += "AND E5.E5_NATUREZ = '"+TRBSE5->NATUREZA+"'  "
		cQuery += "AND E5.E5_TIPODOC = 'DC'  "
		cQuery += "AND E5.E5_SITUACA = ' '  "
		cQuery += "AND E5.E5_FATPREF = '"+TRBSE5->FATPREF+"'  "
		If SM0->M0_CODIGO == "02"
			cQuery += "AND E5.E5_PARCELA = '"+TRBSE5->E5_PARCELA+"'  "
		EndIf
		cQuery += "GROUP BY E5_FILIAL,E5_DATA,E5_CLIFOR,E5_LOJA,E5_NUMERO,E5_PREFIXO,E5_TIPO,E5_MOTBX,E5_NATUREZ,E5_TIPODOC,E5_FATPREF,E5_DOCUMEN "
		cQuery += "ORDER BY E5_DATA "
		
		If SELECT("TRBSE5DES") > 0
			TRBSE5DES->(DbcloseArea())
		Endif
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), "TRBSE5DES", .T., .T.)
		
		If SM0->M0_CODIGO $ "02"
			_nSldRec -=	TRBSE5->VALOR - TRBSE5JUR->VALOR+TRBSE5DES->VALOR
		ElseIf SM0->M0_CODIGO $ "05"
			_nSldRec -=   (TRBSE5->	VALOR + TRBSE5DES->VALOR)
		Else
			_nSldRec -=	TRBSE5->	VALOR
		EndIf
		
		dbSelectArea("TRBSE5")
		
		dbSkip()
		
		IncProc()
		
	End
	
	aadd(_aConta,{'11201001'})
	//aadd(_aConta,{'11201004'})
	//aadd(_aConta,{'11201005'})
	//aadd(_aConta,{'11201007'})
	
	For _nx:= 1 to Len(_aConta)
		_aSdoContabil := SdoContabil(_aConta[_nx,1],ctod("31/12/2014"),"01","1")
		_nSaldoAnt += _aSdoContabil[1]
	Next
	
	If _nSaldoAnt < 0
		_nSaldoAnt := _nSaldoAnt * (-1)
	EndIf
	
	If _nSldRec < 0
		_nSldRec := _nSldRec * (-1)
	EndIf
	
	_nSaldoAnt:=_nSaldoAnt + _nSldRec
	
EndIf

//oExcel:AddRow("Razonete","Relatório Razonete a Receber" + _cEmp,{"","","","","","","","","","Saldo Inicial dos Titulos a Receber","","R$ "+Transform(_nSldRec,"@E 999,999,999,999.99"),"","" })
//oExcel:AddRow("Razonete","Relatório Razonete a Receber" + _cEmp,{"","","","","","","","","","","","","","" })

oExcel:AddRow("Razonete","Relatório Razonete a Receber" + _cEmp,{"","","","","","","","","","Saldo Inicial Contabil","","R$ "+Transform(_nSaldoAnt,"@E 999,999,999,999.99"),"","" })
oExcel:AddRow("Razonete","Relatório Razonete a Receber" + _cEmp,{"","","","","","","","","","","","","","" })

dbSelectArea("TRB")
dbGoTop()
ProcRegua(LastRec())

/////// Incluido por Alexandre em 17/02/2016 para ajustar o saldo
If MV_PAR01 >= CTOD("01/01/2015") .And. MV_PAR02 <= CTOD("31/01/2015") .And. SM0->M0_CODIGO $ "02" .And. MV_PAR03 == "02"
	_nSaldoAnt := _nSaldoAnt * (-1)
EndIf		
///////Fim da Inclusao

_nSaldo		:= _nSaldoAnt
_nTotDeb	:= 0
_nTotCred	:= 0

If MV_PAR01 >= CTOD("01/01/2015") .And. MV_PAR02 <= CTOD("31/01/2015") .And. SM0->M0_CODIGO $ "02" .And. MV_PAR03 == "03"
		_nSaldo := _nSaldo - (-29522.94)
		oExcel:AddRow("Razonete","Relatório Razonete a Receber" + _cEmp,{"02/03",;
		CTOD("02/01/2015"),;
		"",;
		"TRANSFERENCIA DE SALDO EM 02/01/2015",;
		"",;
		"",;
		"",;
		"11201001",;
		"",;
		"",;
		-29522.94,;
		_nSaldo,;
		-29522.94,;
		""  })

		_nTotCred += (-29522.94)

EndIf		

While !Eof()
	
	If AllTrim(TRB->CONTA) >= AllTrim(MV_PAR05) .AND. AllTrim(TRB->CONTA) <= AllTrim(MV_PAR06)
		
		_nSaldo := _nSaldo + TRB->VALORCOMP - TRB->VALORPAG
		
		oExcel:AddRow("Razonete","Relatório Razonete a Receber" + _cEmp,{If(Empty(TRB->FILIAL),"",SM0->M0_CODIGO+"/"+TRB->FILIAL),If(Empty(TRB->DT_MOV),"",TRB->DT_MOV),;
		If(Empty(TRB->FORNECE),"",TRB->FORNECE+"/"+TRB->LOJA),If(Empty(TRB->NOMFORN),"",TRB->NOMFORN),;
			If(Empty(TRB->DOC),"",TRB->DOC),If(Empty(TRB->PARCELA),"",TRB->PARCELA),If(Empty(TRB->TIPO),"",TRB->TIPO),;
				If(Empty(TRB->CONTA),"",TRB->CONTA),If(Empty(TRB->NATUREZA),"",TRB->NATUREZA),If(Empty(TRB->VALORCOMP),"",TRB->VALORCOMP),;
					If(Empty(TRB->VALORPAG),"",TRB->VALORPAG),_nSaldo,TRB->VLRCONTAB,IF(TRB->VALORCOMP=0,TRB->VALORPAG-TRB->VLRCONTAB,TRB->VALORCOMP-TRB->VLRCONTAB)  })
						
						_nTotDeb += TRB->VALORCOMP
						_nTotCred += TRB->VALORPAG
						
					EndIf
					
					dbSelectArea("TRB")
					
					dbSkip()
					
					IncProc()
					
End
				
oExcel:AddRow("Razonete","Relatório Razonete a Receber" + _cEmp,{"","","","","","","","","","","","","","" })
oExcel:AddRow("Razonete","Relatório Razonete a Receber" + _cEmp,{"","","","","","","","","","","","","","" })
oExcel:AddRow("Razonete","Relatório Razonete a Receber" + _cEmp,{"","","","","","","","","Saldo Anterior","Total de Debito","Total de Credito","Saldo Final","","" })
oExcel:AddRow("Razonete","Relatório Razonete a Receber" + _cEmp,{"","","","","","","","","R$ "+Transform(_nSaldoAnt,"@E 999,999,999,999.99"),"R$ "+Transform(_nTotDeb,"@E 999,999,999,999.99"),"R$ "+Transform(_nTotCred,"@E 999,999,999,999.99"),"R$ "+Transform(_nSaldo,"@E 999,999,999,999.99"),"",""})

If mv_par14 == 1
	dbSelectArea("ZZC")
	dbSeek(xFilial("ZZC")+"R"+_cMesAno+"EMCTBR05")
	
	If !Eof()
		RecLock("ZZC",.F.)
		ZZC->ZZC_SALDO := _nSaldo
		MsUnLock()
	Else
		RecLock("ZZC",.T.)
		ZZC->ZZC_FILIAL	:=	XFILIAL("ZZC")
		ZZC->ZZC_GRUPO:= "EMCTBR05"
		ZZC->ZZC_MESANO:= _cMESANO
		ZZC->ZZC_RECPAG:="R"
		ZZC->ZZC_SALDO := _nSaldo
		MsUnLock()
	EndIf
EndIf

_cArquivo := cPath+"Relatorio Razonete a receber "+ SM0->M0_NOME + " - " + DTOS(Date()) + "_" + SubStr(Time(),1,2) + SubStr(Time(),4,2) + SubStr(Time(),7,2) +".xml"

oExcel:Activate()
oExcel:GetXMLFile(_cArquivo)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( _cArquivo)
oExcelApp:SetVisible(.T.)

Return(.T.)

//CRIA O ARQUIVO DE TRABALHO

Static Function CriaTMP( aStructure, cArq )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria e Abre o Arquivo de Trabalho.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cArqTmp := CriaTrab(aStructure,.T.)
dbUseArea(.T.,,_cArqTmp, cArq,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndTRB := CriaTrab(Nil, .F.)
cChave  := "FILIAL+DTOS(DT_MOV)"
IndRegua( cArq ,cIndTRB,cChave,,,"Criando Indice...")

Return

Static Function ValidPerg(cPerg)

Private i,j
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}
// Grupo/Ordem/Pergunta/Perg.Espanhol/Perg.Ingles/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefIng1/Cnt01/Var02/Def02/DefSPA2/DefIng2/Cnt02/Var03/Def03/DefSPA3/DefIng3/Cnt03/Var04/Def04/DefSPA4/DefIng4/Cnt04/Var05/Def05/DefSPA5/DefIng5/Cnt05/Alias/Grupo
AADD(aRegs,{cPerg,"01","Data de   ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data Ate  ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Da Filial ?","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
AADD(aRegs,{cPerg,"04","Ate Filial ?","","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","SM0",""})
AADD(aRegs,{cPerg,"05","Conta de ?","","","mv_ch5","C",20,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","CT1",""})
AADD(aRegs,{cPerg,"06","Conta Ate ?","","","mv_ch6","C",20,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","CT1",""})
AADD(aRegs,{cPerg,"07","Natureza de ?","","","mv_ch7","C",10,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","SED",""})
AADD(aRegs,{cPerg,"08","Natureza Ate ?","","","mv_ch8","C",10,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","SED",""})
AADD(aRegs,{cPerg     ,"09"   ,"Seleciona Tipo ?",""                   ,""              ,"mv_ch9","N"  ,01          ,0          ,0        ,"C"  ,""    ,"mv_par09","Sim",""           ,""         ,""      ,""      ,"Nao","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg     ,"10"   ,"Carteira ?",""                   ,""              ,"mv_cha","N"  ,01          ,0          ,0        ,"C"  ,""    ,"mv_par10","Pagar",""           ,""         ,""      ,""      ,"Receber","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Codigo de ?","","","mv_chb","C",06,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Codigo ate ?","","","mv_chc","C",06,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Imprime entrada de PA/NDF e RA/NCC ?","","","mv_chd","N",01       ,0          ,0,        "C"  ,""    ,"mv_par13","Sim"   ,""           ,""         ,""      ,""      ,"Nao","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Grava Saldo do Relatorio ?","","","mv_che","N",01       ,0          ,0,        "C"  ,""    ,"mv_par14","Sim"   ,""           ,""         ,""      ,""      ,"Nao","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.t.)
		For j:=1 to len(aRegs[i])
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

Return


/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³xfinrtipos ³ Autor ³ Alexandre A. Lima         ³ Data ³ 06/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Abre tela com tipos de titulos.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Sigafin                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/
Static Function xFinrTipos()

LOCAL cCapital
LOCAL nX
LOCAL cCad  := OemToAnsi("Tipos de T¡tulos")
LOCAL cAlias:= Alias()
LOCAL oOk := LoadBitmap( GetResources(), "LBOK" )
LOCAL oNo := LoadBitmap( GetResources(), "LBNO" )
LOCAL oQual
LOCAL cVar := "  "
LOCAL nOpca
LOCAL oDlg
LOCAL aTipoBack:={}
LOCAL aTipos:={}
Local lRunDblClick := .T.

dbSelectArea("SX5")
dbSeek(cFilial+"05")

//³ Monta a tabela de tipos de T¡tulos                                   ³

While X5_FILIAL+X5_tabela == cFilial+"05"
	cCapital := Capital(X5_DESCRI)
	If SubStr(X5_CHAVE,1,3) == "PR "
		dbSkip( )
		Loop
	EndIf
	If SubStr(X5_CHAVE,3,1)== '-'
		_cChave:= SubStr(X5_CHAVE,1,2)+"  "
	Else
		_cChave:= SubStr(X5_CHAVE,1,4)
	EndIf
	Aadd(aTipos,{.T.,_cCHAVE+Iif(Len(cCapital)>15,;
	SubStr(cCapital,1,15),;
	cCapital+Space(15-Len(cCapital)))})
	dbSkip( )
End
aTipoBack := aClone(aTipos)
nOpca := 0
DEFINE MSDIALOG oDlg TITLE cCad From 9,0 To 35,50 OF oMainWnd

@0.5, 0.3 TO 13.6, 20.0 LABEL cCad OF oDlg
@2.3,3 Say OemToAnsi("  ")
@1.0,.7 LISTBOX oQual VAR cVar Fields HEADER "",OemToAnsi( "Tipos de T¡tulos" )  SIZE 150,170 ON DBLCLICK (aTipoBack:=FA060Troca(oQual:nAt,aTipoBack),oQual:Refresh()) NOSCROLL
oQual:SetArray(aTipoBack)
oQual:bLine := { || {if(aTipoBack[oQual:nAt,1],oOk,oNo),aTipoBack[oQual:nAt,2]}}
oQual:bHeaderClick := {|oObj,nCol| If(lRunDblClick .And. nCol==1, aEval(aTipoBack, {|e| e[1] := !e[1]}),Nil), lRunDblClick := !lRunDblClick, oQual:Refresh()}

DEFINE SBUTTON FROM 10  ,166  TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 22.5,166  TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg

IF nOpca == 1
	aTipos := Aclone(aTipoBack)
Endif

//³ Monta a string de tipos para filtrar o arquivo               ³

cTipos :="("
For nX := 1 To Len(aTipos)
	If aTipos[nX,1]
		cTipos += "'"+SubStr(aTipos[nX,2],1,3)+"',"
	EndIf
Next nX
DeleteObject(oOk)
DeleteObject(oNo)

cTipos +=  "'')"

dbSelectArea(cAlias)

Return(cTipos)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³SldPagar  ³ Autor ³ Eduardo Riera         ³ Data ³ 12/03/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o Saldo a Pagar  em uma determinada data.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SldPagar(dData,nMoeda,lDtAnterior)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ dData   : Data do Movimento a Receber - Default dDataBase  ³±±
±±³          ³ nMoeda  : Moeda do Saldo Bancario - Defa 1                 ³±±
±±³          ³ lDtAnterior: Se .T. Ate a Data,.F. Somente Data - Defa .T. ³±±
±±³          ³ lMovSE5 : Se .T. considera o saldo do SE5 - Defa .T.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function xSldPagar(dData,nMoeda,lDtAnterior,lMovSe5,_cNatIni,_cNatFim,_cTipo)

LOCAL aArea     := { Alias() , IndexOrd() , Recno() }
LOCAL aAreaSE2  := { SE2->(IndexOrd()), SE2->(Recno()) }
LOCAL bCondSE2
LOCAL nSaldo    := 0

#IFDEF TOP
	LOCAL cFiltro   := ""
#ENDIF

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Testa os parametros vindos do Excel                  ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMoeda      := If(Empty(nMoeda),1,nMoeda)
dData       := If(Empty(dData),dDataBase,dData)
lDtAnterior := BoolWindow(lDtAnterior)
lMovSe5     := BoolWindow(lMovSe5)
If ( ValType(nMoeda) == "C" )
	nMoeda      := Val(nMoeda)
EndIf
dData       := DataWindow(dData)
// Quando eh chamada do Excel, estas variaveis estao em branco
IF Empty(MVABATIM) .Or.;
	Empty(MV_CPNEG) .Or.;
	Empty(MVPAGANT) .Or.;
	Empty(MVPROVIS)
	CriaTipos()
Endif
dbSelectArea("SE2")
dbSetOrder(3)
bCondSE2  := {|| !Eof() .And. xFilial("SE2") == SE2->E2_FILIAL } // .And.;
//	SE2->E2_EMIS1 <= dData }
If ( lDtAnterior )
	dbSeek(xFilial("SE2"),.T.)
Else
	dbSeek(xFilial()+Dtos(dData))
EndIf
While ( Eval(bCondSe2) )
	If SE2->E2_NATUREZ >= _cNatIni .AND. SE2->E2_NATUREZ <= _cNatFim // Acrescentado por alexandre em 03/11/2015
		If ( SE2->E2_EMIS1 <= dData .And. ;
			!SE2->E2_TIPO $MVPROVIS+"/"+MVABATIM .AND. ;
			((!Empty(SE2->E2_FATURA).And.;
			Substr(SE2->E2_FATURA,1,6)=="NOTFAT" ) .Or.;
			(!Empty(SE2->E2_FATURA) .And.;
			Substr(SE2->E2_FATURA,1,6)!="NOTFAT" .And.;
			SE2->E2_DTFATUR > dData ) .Or.;
			Empty(SE2->E2_FATURA)) ) .And. SE2->E2_FLUXO != "N"
			If ( !SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG )
				If ( !lMovSE5 )
					nSaldo += xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,dData)
					nSaldo -= SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",1,dData,SE2->E2_FORNECE)
				Else
					nSaldo += SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,nMoeda,,dData,SE2->E2_LOJA)
					nSaldo -= SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",1,dData,SE2->E2_FORNECE)
				EndIf
			Else
				If ( !lMovSE5 .And. !SE2->E2_TIPO $ MVABATIM )
					nSaldo -= SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,nMoeda,,dData,SE2->E2_LOJA)
				Else
					nSaldo -= xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,dData)
				EndIf
			EndIf
		EndIf
	EndIf
	dbSelectArea("SE2")
	dbSkip()
EndDo
dbSelectArea("SE2")
RetIndex("SE2")
dbClearFilter()
dbSetOrder(aAreaSE2[1])
dbGoto(aAreaSE2[2])
dbSelectArea(aArea[1])
dbSetOrder(aArea[2])
dbGoto(aArea[3])
Return(nSaldo)
