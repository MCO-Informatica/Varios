#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FATA002  บAutor  ณ Ricardo Felipelli  บ Data ณ  20/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importacao dos dados de pedido de vendas, usando           บฑฑ
ฑฑบ          ณ MSEXECAUTO provenientes da escalena - e-commerce           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FATA002(cDirE, cDirS)
Private _cArquivo
Private aFiles	 := {}
Private _cArqDestino

/*
MV_TOP_AT := 'MSSQL7/TOPSQL'
MV_IP_AT  := '10.0.0.193'
_nCon := TCLink("MSSQL7/TOPSQL", "TOPSIGA")
//If (_nCon < 0)
//CONOUT("Falha Conexao TOPCONN - Erro: "+ str(nCon, 10, 0))
//EndIf
nAmbAtual := TcLink(GetMv("MV_TOP_AT",,"MSSQL7/TOPCONN"),GetMv("MV_IP_AT",,"TOPSIGA"))
TCSetConn(nAmbAtual)
*/


Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Executando rotina.", .T. )

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunProc   บAutor  ณ Ricardo Felipelli  บ Data ณ  26/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina auxiliar de Processamento                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lEnd)
Local _aCampos  := {}
Local _aVet     := {}
Local _aItens   := {}
Local _aItem    := {}
Local _aCabec   := {}
Local _aLinha   := {}
Local _cFileLog, _cPath := ""
Local _nNumCpos := _nCt := 0
Local i
Local j
Local cCnpj
Local lPrimeira := .T.
Local nOperacao
Local cProduto
Local nItem
Local nPos

//cArqSaida:=ALLTRIM(MV_PAR03)+"FL"+SM0->M0_CODFIL+STRZERO(MONTH(MV_PAR02),2)+RIGHT(STRZERO(YEAR(MV_PAR02),4),2)+".TXT"
cArqSaida := CriaTrab( , .F. )
nHdlArq   := FCreate(cArqSaida)
cCRLF     := CHR(13)+CHR(10)

If nHdlArq==-1
	MsgStop("Nao foi possivel criar o arquivo "+cArqSaida+", Verificar...")
	Return nil
EndIf

cLine := "INICIANDO O LOG - IMPORTACAO DE PEDIDO DE VENDA" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "-------------------------------------"
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "Arquivo............: "+cArqSaida + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "DataBase...........: "+Dtoc(dDataBase) + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "Data...............: "+Dtoc(MsDate()) + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "Hora...............: "+Time() + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "Environment........: "+GetEnvServer() + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))
cLine := "" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))


//Criei o campo a1_PROCESSADO na tabela lsvcliente, c5_PROCESSADO na tabela lsvpdcab e c6_PROCESSADO na tabela lsvpditem.

//altera o conteudo do campo a1_PROCESSADO quando o mesmo for null, novos registros
_cquery := " UPDATE LNK_LASELVA.INTEGRACAO_LASELVA.dbo.lsvcliente "
_cquery += " SET a1_PROCESSADO = '3' "  //where a1_PROCESSADO IS NULL "
TcSQLExec(_cquery)


//verifica se os clientes no banco escalena estao cadastrados no siga
dbselectarea("SB1")
dbsetorder(01)
dbselectarea("SA1")
dbsetorder(03) //A1_FILIAL+A1_CGC

_cquery := "SELECT * FROM LNK_LASELVA.INTEGRACAO_LASELVA.dbo.lsvcliente as ESCSA1"
//_cquery += " WHERE ESCSA1.a1_PROCESSADO = '0' "

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "ESCSA1", .F., .T.)

while ESCSA1->(!eof())
	if ESCSA1->a1_PROCESSADO <> '0'
		ESCSA1->(dbskip())
		loop
	endif
	
	_cquery := " SELECT * FROM " + RetSqlName('SA1') + " (NOLOCK)"
	_cquery += " WHERE a1_NOME = '" +ESCSA1->a1_NOME+ "'"
	_cquery += " AND a1_CGC = '" +ESCSA1->a1_CGC+ "'"
	_cquery += " AND a1_END	= '" +ESCSA1->a1_END+ "'"
	_cquery += " AND a1_ENDENT = '" +ESCSA1->a1_ENDENT+ "'"
	_cquery += " AND D_E_L_E_T_ = '' "

	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TMP", .F., .T.)
	
	if TMP->A1_NOME==ESCSA1->a1_NOME .and. TMP->A1_CGC==ESCSA1->a1_CGC .and. TMP->A1_END==ESCSA1->a1_END .and. TMP->A1_ENDENT==ESCSA1->a1_ENDENT
		TMP->(DBCLOSEAREA())
		ESCSA1->(dbskip())
		loop
	else
		TMP->(DBCLOSEAREA())
	endif
	
	dbselectarea("SA1")
	dbsetorder(03) //A1_FILIAL+A1_CGC
	SA1->(dbseek(xFilial("SA1")+ESCSA1->a1_CGC))
	
	if SA1->(!found())
		
		cCodCli := GetSxeNum("SA1","A1_COD")
		While .T.
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+cCodCli)
				RollBackSX8()
				cCodCli := GetSxeNum("SA1","A1_COD")
			Else
				ConfirmSX8()
				Exit
			EndIf
		EndDo
		//		aCliente := {}
		
		RecLock("SA1",.T.)
		
		SA1->A1_FILIAL  := space(02)
		SA1->A1_COD     := cCodCli
		SA1->A1_LOJA    := '01'
		SA1->A1_NOME    := ESCSA1->a1_NOME
		if len(ESCSA1->a1_CGC)==14
			SA1->A1_PESSOA   := 'J'
		else
			SA1->A1_PESSOA   := 'F'
		endif
		SA1->A1_NREDUZ   := ESCSA1->a1_NREDUZ
		SA1->A1_END      := ESCSA1->a1_END
		SA1->A1_TIPO     := ESCSA1->a1_TIPO
		SA1->A1_MUN      := ESCSA1->a1_MUN
		SA1->A1_EST      := ESCSA1->a1_EST
		SA1->A1_NATUREZ  := ESCSA1->a1_NATUREZ
		SA1->A1_BAIRRO   := ESCSA1->a1_BAIRRO
		SA1->A1_ESTADO   := ESCSA1->a1_ESTADO
		SA1->A1_CEP      := ESCSA1->a1_CEP
		SA1->A1_DDI      := ESCSA1->a1_DDI
		SA1->A1_DDD      := ESCSA1->a1_DDD
		SA1->A1_TEL      := ESCSA1->a1_TEL
		SA1->A1_FAX      := ESCSA1->a1_FAX
		SA1->A1_ENDCOB   := ESCSA1->a1_ENDCOB
		SA1->A1_BAIRROC  := ESCSA1->a1_BAIRROC
		SA1->A1_CEPC     := ESCSA1->a1_CEPC
		SA1->A1_PAIS     := ESCSA1->a1_PAIS
		SA1->A1_MUNC     := ESCSA1->a1_MUNC
		SA1->A1_ESTC     := ESCSA1->a1_ESTC
		//		SA1->A1_PAISDES  := ESCSA1->a1_PAISDES
		SA1->A1_ENDENT   := ESCSA1->a1_ENDENT
		SA1->A1_BAIRROE  := ESCSA1->a1_BAIRROE
		SA1->A1_CEPE     := ESCSA1->a1_CEPE
		SA1->A1_MUNE     := ESCSA1->a1_MUNE
		SA1->A1_ESTE     := ESCSA1->a1_ESTE
		SA1->A1_ENDREC   := ESCSA1->a1_ENDREC
		SA1->A1_CONTATO  := ESCSA1->a1_CONTATO
		SA1->A1_CGC      := ESCSA1->a1_CGC
		SA1->A1_INSCR    := ESCSA1->a1_INSCR
		SA1->A1_PFISICA  := ESCSA1->a1_PFISICA
		SA1->A1_INSCRM   := ESCSA1->a1_INSCRM
		SA1->A1_VEND     := ESCSA1->a1_VEND
		SA1->A1_COMIS    := ESCSA1->a1_COMIS
		SA1->A1_REGIAO   := ESCSA1->a1_REGIAO
		SA1->A1_CONTA    := ESCSA1->a1_CONTA
		SA1->A1_BCO1     := ESCSA1->a1_BCO1
		SA1->A1_BCO2     := ESCSA1->a1_BCO2
		SA1->A1_BCO3     := ESCSA1->a1_BCO3
		SA1->A1_BCO4     := ESCSA1->a1_BCO4
		SA1->A1_BCO5     := ESCSA1->a1_BCO5
		SA1->A1_TRANSP   := ESCSA1->a1_TRANSP
		SA1->A1_TPFRET   := ESCSA1->a1_TPFRET
//		SA1->A1_COND     := ESCSA1->a1_COND
		SA1->A1_COND     := '001'
		SA1->A1_DESC     := ESCSA1->a1_DESC
		SA1->A1_PRIOR    := ESCSA1->a1_PRIOR
		SA1->A1_RISCO    := ESCSA1->a1_RISCO
		SA1->A1_LC       := ESCSA1->a1_LC
		//		SA1->A1_VENCLC   := ESCSA1->a1_VENCLC  // Vencimento do Lim. Credit
		SA1->A1_CLASSE   := ESCSA1->a1_CLASSE
		SA1->A1_LCFIN    := ESCSA1->a1_LCFIN
		SA1->A1_MOEDALC  := ESCSA1->a1_MOEDALC
		SA1->A1_MSALDO   := ESCSA1->a1_MSALDO
		SA1->A1_MCOMPRA  := ESCSA1->a1_MCOMPRA
		SA1->A1_METR     := ESCSA1->a1_METR
		SA1->A1_PRICOM   := dDataBase  // ESCSA1->a1_PRICOM
		SA1->A1_ULTCOM   := dDataBase  // ESCSA1->a1_ULTCOM
		SA1->A1_NROCOM   := ESCSA1->a1_NROCOM
		SA1->A1_FORMVIS  := ESCSA1->a1_FORMVIS
		SA1->A1_TEMVIS   := ESCSA1->a1_TEMVIS
		SA1->A1_ULTVIS   := dDataBase  // ESCSA1->a1_ULTVIS
		SA1->A1_TMPVIS   := ESCSA1->a1_TMPVIS
		SA1->A1_TMPSTD   := ESCSA1->a1_TMPSTD
		SA1->A1_CLASVEN  := ESCSA1->a1_CLASVEN
		SA1->A1_MENSAGE  := ESCSA1->a1_MENSAGE
		SA1->A1_SALDUP   := ESCSA1->a1_SALDUP
		SA1->A1_RECISS   := ESCSA1->a1_RECISS
		SA1->A1_NROPAG   := ESCSA1->a1_NROPAG
		SA1->A1_SALPEDL  := ESCSA1->a1_SALPEDL
		SA1->A1_TRANSF   := ESCSA1->a1_TRANSF
		SA1->A1_SUFRAMA  := ESCSA1->a1_SUFRAMA
		SA1->A1_ATR      := ESCSA1->a1_ATR
		SA1->A1_VACUM    := ESCSA1->a1_VACUM
		SA1->A1_SALPED   := ESCSA1->a1_SALPED
		SA1->A1_TITPROT  := ESCSA1->a1_TITPROT
		//		SA1->A1_DTULTIT  := ESCSA1->a1_DTULTIT    // Data do Ult. Titulos Dev.
		SA1->A1_CHQDEVO  := ESCSA1->a1_CHQDEVO
		SA1->A1_CXPOSTA  := ESCSA1->a1_CXPOSTA
		//		SA1->A1_DTULCHQ  := ESCSA1->a1_DTULCHQ   // Dt.de Devol. Ult. Cheque
		SA1->A1_MATR     := ESCSA1->a1_MATR
		SA1->A1_MAIDUPL  := ESCSA1->a1_MAIDUPL
		SA1->A1_TABELA   := ESCSA1->a1_TABELA
		SA1->A1_INCISS   := ESCSA1->a1_INCISS
		SA1->A1_SALDUPM  := ESCSA1->a1_SALDUPM
		SA1->A1_PAGATR   := ESCSA1->a1_PAGATR
		SA1->A1_TELEX    := ESCSA1->a1_TELEX
		SA1->A1_ATIVIDA  := ESCSA1->a1_ATIVIDA
		SA1->A1_CARGO1   := ESCSA1->a1_CARGO1
		SA1->A1_CARGO2   := ESCSA1->a1_CARGO2
		SA1->A1_CARGO3   := ESCSA1->a1_CARGO3
		SA1->A1_SUPER    := ESCSA1->a1_SUPER
		SA1->A1_RTEC     := ESCSA1->a1_RTEC
		SA1->A1_ALIQIR   := ESCSA1->a1_ALIQIR
		SA1->A1_OBSERV   := ESCSA1->a1_OBSERV
		SA1->A1_RG       := ESCSA1->a1_RG
		SA1->A1_CALCSUF  := ESCSA1->a1_CALCSUF
		SA1->A1_DTNASC   := dDataBase  // ESCSA1->a1_DTNASC
		SA1->A1_SALPEDB  := ESCSA1->a1_SALPEDB
		SA1->A1_CLIFAT   := ESCSA1->a1_CLIFAT
		SA1->A1_GRPTRIB  := ESCSA1->a1_GRPTRIB
		SA1->A1_SATIV1   := ESCSA1->a1_SATIV1
		//		SA1->A1_DSATIV1  := ESCSA1->a1_DSATIV1 // Descricao Segmento 1
		SA1->A1_SATIV2   := ESCSA1->a1_SATIV2
		SA1->A1_CODLOC   := ESCSA1->a1_CODLOC
		//		SA1->A1_DSATIV2  := ESCSA1->a1_DSATIV2 // Descricao Segmento 2
		SA1->A1_TPISSRS  := ESCSA1->a1_TPISSRS
		SA1->A1_CODPAIS  := ESCSA1->a1_CODPAIS
		SA1->A1_TPESSOA  := ESCSA1->a1_TPESSOA
		SA1->A1_SATIV3   := ESCSA1->a1_SATIV3
		//		SA1->A1_DSATIV3  := ESCSA1->a1_DSATIV3 // Descricao Segmento 3
		SA1->A1_SATIV4   := ESCSA1->a1_SATIV4
		//		SA1->A1_DSATIV4  := ESCSA1->a1_DSATIV4 // Descricao Segmento 4
		SA1->A1_SATIV5   := ESCSA1->a1_SATIV5
		//		SA1->A1_DSATIV5  := ESCSA1->a1_DSATIV5 // Descricao Segmento 5
		SA1->A1_SATIV6   := ESCSA1->a1_SATIV6
		//		SA1->A1_DSATIV6  := ESCSA1->a1_DSATIV6 // Descricao Segmento 6
		SA1->A1_SATIV7   := ESCSA1->a1_SATIV7
		//		SA1->A1_DSATIV7  := ESCSA1->a1_DSATIV7 // Descricao Segmento 7
		SA1->A1_SATIV8   := ESCSA1->a1_SATIV8
		//		SA1->A1_DSATIV8  := ESCSA1->a1_DSATIV8 // Descricao Segmento 8
		//		SA1->A1_VM_MARC  := ESCSA1->a1_VM_MARC // Cod.Marcacao
		SA1->A1_CODAGE   := ESCSA1->a1_CODAGE
		SA1->A1_COMAGE   := ESCSA1->a1_COMAGE
		SA1->A1_TIPCLI   := ESCSA1->a1_TIPCLI
		SA1->A1_EMAIL    := ESCSA1->a1_EMAIL
		SA1->A1_DEST_1   := ESCSA1->a1_DEST_1
		SA1->A1_CODMUN   := ESCSA1->a1_CODMUN
		SA1->A1_DEST_2   := ESCSA1->a1_DEST_2
		SA1->A1_HPAGE    := ESCSA1->a1_HPAGE
		SA1->A1_DEST_3   := ESCSA1->a1_DEST_3
		SA1->A1_CONDPAG  := ESCSA1->a1_CONDPAG
		SA1->A1_DIASPAG  := ESCSA1->a1_DIASPAG
		//		SA1->A1_DESCPAG  := ESCSA1->a1_DESCPAG // Descricao em Portugues
		SA1->A1_OBS      := ESCSA1->a1_OBS
		SA1->A1_AGREG    := ESCSA1->a1_AGREG
		// 		SA1->A1_VM_OBS   := ESCSA1->a1_VM_OBS  // Observacoes
		SA1->A1_CODHIST  := ESCSA1->a1_CODHIST
		SA1->A1_RECINSS  := ESCSA1->a1_RECINSS
		SA1->A1_RECCOFI  := ESCSA1->a1_RECCOFI
		SA1->A1_RECCSLL  := ESCSA1->a1_RECCSLL
		SA1->A1_RECPIS   := ESCSA1->a1_RECPIS
		//		SA1->A1_HISTMK   := ESCSA1->a1_HISTMK  // Historico do Atendimento
		SA1->A1_TIPPER   := ESCSA1->a1_TIPPER
		SA1->A1_COD_MUN  := ESCSA1->a1_COD_MUN
		SA1->A1_SALFIN   := ESCSA1->a1_SALFIN
		SA1->A1_SALFINM  := ESCSA1->a1_SALFINM
		SA1->A1_CONTAB   := ESCSA1->a1_CONTAB
		SA1->A1_B2B      := ESCSA1->a1_B2B
		SA1->A1_GRPVEN   := ESCSA1->a1_GRPVEN
		SA1->A1_INSCRUR  := ESCSA1->a1_INSCRUR
		SA1->A1_CLICNV   := ESCSA1->a1_CLICNV
		SA1->A1_MSBLQL   := ESCSA1->a1_MSBLQL
		SA1->A1_SITUA    := ESCSA1->a1_SITUA
		SA1->A1_NUMRA    := ESCSA1->a1_NUMRA
		SA1->A1_SUBCOD   := ESCSA1->a1_SUBCOD
		SA1->A1_CDRDES   := ESCSA1->a1_CDRDES
		//		SA1->A1_REGDES   := ESCSA1->a1_REGDES // Reg. Destino
		SA1->A1_FILDEB   := ESCSA1->a1_FILDEB
		SA1->A1_CODFOR   := ESCSA1->a1_CODFOR
		SA1->A1_ABICS    := ESCSA1->a1_ABICS
		SA1->A1_BLEMAIL  := ESCSA1->a1_BLEMAIL
		SA1->A1_TIPOCLI  := ESCSA1->a1_TIPOCLI
		SA1->A1_IBGE     := ESCSA1->a1_IBGE
		SA1->A1_SIMPLES  := ESCSA1->a1_SIMPLES
		SA1->A1_CEINSS   := ESCSA1->a1_CEINSS
		SA1->A1_ABATIMP  := ESCSA1->a1_ABATIMP
		SA1->A1_RECIRRF  := ESCSA1->a1_RECIRRF
		SA1->A1_RECFET   := ESCSA1->a1_RECFET
		SA1->A1_TIMEKEE  := ESCSA1->a1_TIMEKEE
		SA1->A1_SIMPNAC  := ESCSA1->a1_SIMPNAC
		SA1->A1_PABCB    := ESCSA1->a1_PABCB
		SA1->A1_CTARE    := ESCSA1->a1_CTARE
		SA1->A1_CONTRIB  := ESCSA1->a1_CONTRIB
		SA1->A1_VINCULO  := ESCSA1->a1_VINCULO
		//		SA1->A1_DTINIV   := ESCSA1->a1_DTINIV    // Data Inicial do Vinculo
		//		SA1->A1_DTFIMV   := ESCSA1->a1_DTFIMV    // Data Final do Vinculo
		SA1->A1_OBSERV   := 'ESCALENA - Codigo ' + ESCSA1->a1_cod
		MsUnLock()
		
		//		Begin Transaction
		
		//		nOpcA:=AxInclui(cAlias,nReg,nOpc,/*aAcho*/,/*cFunc*/,/*aCpos*/,"MA030TudOk()",/*lF3*/,/*cTransact*/,aButtons,/*aParam*/,aRotAuto,/*lVirtual*/)
		//		If l030Inc
		//			ExecBlock("M030Inc",.f.,.f., nOpcA )
		//		Endif
		
		cLine := "Cliente: " + ESCSA1->a1_NOME + cCRLF
		fWrite(nHdlArq,cLine,Len(cLine))
		cLine := "Incluido com Sucesso" + cCRLF
		fWrite(nHdlArq,cLine,Len(cLine))
		cLine := "" + cCRLF
		fWrite(nHdlArq,cLine,Len(cLine))
		
		//		End Transaction
		
		//Gravar flag no banco lsvcliente na escalena pois jแ foi processado
		//	_cquery := " UPDATE LNK_LASELVA.INTEGRACAO_LASELVA.dbo.lsvcliente "
		_cquery := " UPDATE LNK_LASELVA.INTEGRACAO_LASELVA.dbo.lsvcliente "
		_cquery += " SET a1_PROCESSADO = '1' "
		_cquery += " where a1_NOME = '" +SA1->A1_NOME+ "'"
		_cquery += " AND a1_CGC = '" +SA1->A1_CGC+ "'"
		_cquery += " AND a1_END	= '" +SA1->A1_END+ "'"
		_cquery += " AND a1_ENDENT = '" +SA1->A1_ENDENT+ "'"
		//	_cquery += " AND a1_PRICOM = '" +dtos(SA1->A1_PRICOM)+ "'"
		TcSQLExec(_cquery)
		
	endif
	
	ESCSA1->(DBSKIP())
	
enddo

//Criei o campo a1_PROCESSADO na tabela lsvcliente, c5_PROCESSADO na tabela lsvpdcab e c6_PROCESSADO na tabela lsvpditem.


// PEDIDOS

dbselectarea("SC5")
dbsetorder(01) //A1_FILIAL+A1_CGC


_cquery := "SELECT * FROM LNK_LASELVA.INTEGRACAO_LASELVA.dbo.lsvpdcab as PED WHERE PED.c5_NUM = '3109'" // '3120' "

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "ESCSC5", .F., .T.)
//_cquery += " WHERE "
//_cquery += " PED.c5_PROCESSADO = ' ' AND "
//_cquery := " c5_NUM = '1007' "


//memowrite("FATA002c.SQL",_cQuery)
//DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "ESCSC5", .F., .T.)

while ESCSC5->(!eof())
	
	cDoc     := GetSxeNum("SC5","C5_NUM")
	While .T.
		DbSelectArea("SC5")
		DbSetOrder(1)
		If DbSeek(xFilial("SC5")+cDoc)
			RollBackSX8()
			cDoc := GetSxeNum("SC5","C5_NUM")
		Else
			ConfirmSX8()
			Exit
		EndIf
	EndDo
	
	_ped_esc := ESCSC5->c5_NUM  // numero do pedido original da escalena
	aCabec := {}
	aItens := {}
	
	// pesquisar na tabela de clientes o cliente com codigo escalena, para usar no campo c5_cliente
	_a1_clie    := '999999'
	_a1_lojacli := '99'
	_a1_est     := 'SP'
	_cquery := " SELECT A1_COD,A1_LOJA,A1_EST FROM " + RetSqlName('SA1') + " (NOLOCK) "
	_cquery += " WHERE A1_OBSERV LIKE '%" + ESCSC5->c5_CLIENTE + "%' AND D_E_L_E_T_ = '' "

	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TR2", .F., .T.)
	if TR2->(!eof())
		_a1_clie    := TR2->A1_COD
		_a1_lojacli := TR2->A1_LOJA
		_a1_est     := TR2->A1_EST
	endif
	TR2->(DbCloseArea())
	
	
	//	aadd(aCabec, {"C5_FILIAL",   ESCSC5->c5_FILIAL, Nil })
	aadd(aCabec, {"C5_FILIAL",   '01', Nil })   // - utilizado filial 01 pois o campo filial(escalena) ้ nulo
	aadd(aCabec, {"C5_NUM"   ,   cDoc, Nil})
	//	aadd(aCabec, {"C5_TIPO",     ESCSC5->c5_TIPO, Nil })
	aadd(aCabec, {"C5_TIPO",     'N', Nil })
	//	aadd(aCabec, {"C5_CLIENTE",  ESCSC5->c5_CLIENTE, Nil })
	aadd(aCabec, {"C5_CLIENTE",  _a1_clie, Nil })
	//	aadd(aCabec, {"C5_LOJACLI",  ESCSC5->c5_LOJACLI, Nil })
	aadd(aCabec, {"C5_LOJACLI",  _a1_lojacli, Nil })
	//	aadd(aCabec, {"C5_CLIENT",   ESCSC5->c5_CLIENT, Nil })
	aadd(aCabec, {"C5_CLIENT",   _a1_clie, Nil })
	//	aadd(aCabec, {"C5_LOJAENT",  ESCSC5->c5_LOJAENT, Nil })
	aadd(aCabec, {"C5_LOJAENT",  '01', Nil })
	aadd(aCabec, {"C5_TRANSP",   ESCSC5->c5_TRANSP, Nil })
	//	aadd(aCabec, {"C5_TIPOCLI",  ESCSC5->c5_TIPOCLI, Nil })
	aadd(aCabec, {"C5_TIPOCLI",  'R', Nil })
	//	aadd(aCabec, {"C5_CONDPAG",  ESCSC5->c5_CONDPAG, Nil })
	aadd(aCabec, {"C5_CONDPAG",  '001', Nil })
	aadd(aCabec, {"C5_TABELA",   ESCSC5->c5_TABELA, Nil })
	aadd(aCabec, {"C5_VEND1",    ESCSC5->c5_VEND1, Nil })
	aadd(aCabec, {"C5_COMIS1",   ESCSC5->c5_COMIS1, Nil })
	aadd(aCabec, {"C5_VEND2",    ESCSC5->c5_VEND2, Nil })
	aadd(aCabec, {"C5_COMIS2",   ESCSC5->c5_COMIS2, Nil })
	aadd(aCabec, {"C5_VEND3",    ESCSC5->c5_VEND3, Nil })
	aadd(aCabec, {"C5_COMIS3",   ESCSC5->c5_COMIS3, Nil })
	aadd(aCabec, {"C5_VEND4",    ESCSC5->c5_VEND4, Nil })
	aadd(aCabec, {"C5_COMIS4",   ESCSC5->c5_COMIS4, Nil })
	aadd(aCabec, {"C5_VEND5",    ESCSC5->c5_VEND5, Nil })
	aadd(aCabec, {"C5_COMIS5",   ESCSC5->c5_COMIS5, Nil })
	aadd(aCabec, {"C5_DESC1",    ESCSC5->c5_DESC1, Nil })
	aadd(aCabec, {"C5_DESC2",    ESCSC5->c5_DESC2, Nil })
	aadd(aCabec, {"C5_DESC3",    ESCSC5->c5_DESC3, Nil })
	aadd(aCabec, {"C5_DESC4",    ESCSC5->c5_DESC4, Nil })
	aadd(aCabec, {"C5_BANCO",    ESCSC5->c5_BANCO, Nil })
	aadd(aCabec, {"C5_DESCFI",   ESCSC5->c5_DESCFI, Nil })
	//	aadd(aCabec, {"C5_EMISSAO",  ESCSC5->c5_EMISSAO, Nil })
	aadd(aCabec, {"C5_EMISSAO",  dDataBase, Nil })
	aadd(aCabec, {"C5_COTACAO",  ESCSC5->c5_COTACAO, Nil })
	aadd(aCabec, {"C5_PARC1",    ESCSC5->c5_PARC1, Nil })
	//	aadd(aCabec, {"C5_DATA1",    ESCSC5->c5_DATA1, Nil })
	aadd(aCabec, {"C5_PARC2",    ESCSC5->c5_PARC2, Nil })
	//	aadd(aCabec, {"C5_DATA2",    ESCSC5->c5_DATA2, Nil })
	aadd(aCabec, {"C5_PARC3",    ESCSC5->c5_PARC3, Nil })
	//	aadd(aCabec, {"C5_DATA3",    ESCSC5->c5_DATA3, Nil })
	aadd(aCabec, {"C5_PARC4",    ESCSC5->c5_PARC4, Nil })
	//	aadd(aCabec, {"C5_DATA4",    ESCSC5->c5_DATA4, Nil })
	aadd(aCabec, {"C5_TPFRETE",  ESCSC5->c5_TPFRETE, Nil })
	aadd(aCabec, {"C5_FRETE",    ESCSC5->c5_FRETE, Nil })
	aadd(aCabec, {"C5_SEGURO",   ESCSC5->c5_SEGURO, Nil })
	aadd(aCabec, {"C5_DESPESA",  ESCSC5->c5_DESPESA, Nil })
	aadd(aCabec, {"C5_FRETAUT",  ESCSC5->c5_FRETAUT, Nil })
	aadd(aCabec, {"C5_REAJUST",  ESCSC5->c5_REAJUST, Nil })
	//	aadd(aCabec, {"C5_MOEDA",    ESCSC5->c5_MOEDA, Nil })
	aadd(aCabec, {"C5_MOEDA",    1, Nil })
	aadd(aCabec, {"C5_PESOL",    ESCSC5->c5_PESOL, Nil })
	aadd(aCabec, {"C5_PBRUTO",   ESCSC5->c5_PBRUTO, Nil })
	aadd(aCabec, {"C5_REIMP",    ESCSC5->c5_REIMP, Nil })
	aadd(aCabec, {"C5_REDESP",   ESCSC5->c5_REDESP, Nil })
	aadd(aCabec, {"C5_VOLUME1",  ESCSC5->c5_VOLUME1, Nil })
	aadd(aCabec, {"C5_VOLUME2",  ESCSC5->c5_VOLUME2, Nil })
	aadd(aCabec, {"C5_VOLUME3",  ESCSC5->c5_VOLUME3, Nil })
	aadd(aCabec, {"C5_VOLUME4",  ESCSC5->c5_VOLUME4, Nil })
	aadd(aCabec, {"C5_ESPECI1",  ESCSC5->c5_ESPECI1, Nil })
	aadd(aCabec, {"C5_ESPECI2",  ESCSC5->c5_ESPECI2, Nil })
	aadd(aCabec, {"C5_ESPECI3",  ESCSC5->c5_ESPECI3, Nil })
	aadd(aCabec, {"C5_ESPECI4",  ESCSC5->c5_ESPECI4, Nil })
	aadd(aCabec, {"C5_ACRSFIN",  ESCSC5->c5_ACRSFIN, Nil })
	aadd(aCabec, {"C5_MENNOTA",  ESCSC5->c5_MENNOTA, Nil })
	aadd(aCabec, {"C5_MENPAD",   ESCSC5->c5_MENPAD, Nil })
	aadd(aCabec, {"C5_INCISS",   ESCSC5->c5_INCISS, Nil })
	aadd(aCabec, {"C5_LIBEROK",  ESCSC5->c5_LIBEROK, Nil })
	aadd(aCabec, {"C5_OK",       ESCSC5->c5_OK, Nil })
	aadd(aCabec, {"C5_NOTA",     ESCSC5->c5_NOTA, Nil })
	aadd(aCabec, {"C5_SERIE",    ESCSC5->c5_SERIE, Nil })
	aadd(aCabec, {"C5_KITREP",   ESCSC5->c5_KITREP, Nil })
	aadd(aCabec, {"C5_OS",       ESCSC5->c5_OS, Nil })
	//	aadd(aCabec, {"C5_TIPLIB",   ESCSC5->c5_TIPLIB, Nil })
	aadd(aCabec, {"C5_TIPLIB",   '1', Nil })
	aadd(aCabec, {"C5_DESCONT",  ESCSC5->c5_DESCONT, Nil })
	aadd(aCabec, {"C5_PEDEXP",   ESCSC5->c5_PEDEXP, Nil })
	aadd(aCabec, {"C5_TXMOEDA",  ESCSC5->c5_TXMOEDA, Nil })
	//	aadd(aCabec, {"C5_TPCARGA",  ESCSC5->c5_TPCARGA, Nil })
	aadd(aCabec, {"C5_TPCARGA",  '2', Nil })
	aadd(aCabec, {"C5_PDESCAB",  ESCSC5->c5_PDESCAB, Nil })
	aadd(aCabec, {"C5_BLQ",      ESCSC5->c5_BLQ, Nil })
	aadd(aCabec, {"C5_FORNISS",  ESCSC5->c5_FORNISS, Nil })
	aadd(aCabec, {"C5_CONTRA",   ESCSC5->c5_CONTRA, Nil })
	aadd(aCabec, {"C5_KM",       ESCSC5->c5_KM, Nil })
	aadd(aCabec, {"C5_VLR_FRT",  ESCSC5->c5_VLR_FRT, Nil })
	aadd(aCabec, {"C5_RECISS",   ESCSC5->c5_RECISS, Nil })
	aadd(aCabec, {"C5_RECFAUT",  ESCSC5->c5_RECFAUT, Nil })
	aadd(aCabec, {"C5_TIPOPER",  ESCSC5->c5_TIPOPER, Nil })
	
	
	_cquery := "SELECT * FROM LNK_LASELVA.INTEGRACAO_LASELVA.dbo.lsvpditem AS ITEM"
	_cquery += " WHERE "
	//	_cquery += " c6_PROCESSADO = ' 'AND "
	_cquery += " ITEM.c6_NUM = '" + ESCSC5->c5_NUM + "'"

	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "ESCSC6", .F., .T.)
	
	_numitem := 1
	while ESCSC6->(!eof())
		_b1_um := 'PC'
		_b1_desc := 'ESCALENA'
		SB1->(dbseek(xfilial("SB1")+ESCSC6->c6_PRODUTO))
		if SB1->(found())
			_b1_um   := SB1->B1_UM
			_b1_desc := SB1->B1_DESC
		endif
		
		
		aLinha := {}
		aadd(aLinha,{"c6_FILIAL",   '01', Nil}) // ESCSC6->c6_FILIAL, Nil})  - utilizado filial 01 pois o campo filial(escalena) ้ nulo
		aadd(aLinha,{"c6_ITEM",     StrZero(_numitem,4), Nil}) 
		aadd(aLinha,{"c6_PRODUTO",  ESCSC6->c6_PRODUTO, Nil})
		//		aadd(aLinha,{"c6_UM",       ESCSC6->c6_UM, Nil})
		aadd(aLinha,{"c6_UM",   	_b1_um, Nil})
		aadd(aLinha,{"c6_QTDVEN",   ESCSC6->c6_QTDVEN, Nil})
		aadd(aLinha,{"c6_PRCVEN",   ESCSC6->c6_PRCVEN, Nil})
		aadd(aLinha,{"c6_VALOR",    ESCSC6->c6_VALOR, Nil})
		//		aadd(aLinha,{"c6_QTDLIB",   ESCSC6->c6_QTDLIB, Nil})
		aadd(aLinha,{"c6_QTDLIB",   ESCSC6->c6_QTDVEN, Nil})
		//		aadd(aLinha,{"c6_QTDLIB2",  ESCSC6->c6_QTDLIB2, Nil})
		aadd(aLinha,{"c6_QTDLIB2",  ESCSC6->c6_QTDVEN, Nil})
		//		aadd(aLinha,{"c6_SEGUM",    ESCSC6->c6_SEGUM, Nil})
		aadd(aLinha,{"c6_SLDALIB",  ESCSC6->c6_SLDALIB, Nil})
		//		aadd(aLinha,{"c6_OPER",     ESCSC6->c6_OPER, Nil})
		//		aadd(aLinha,{"c6_TES",      ESCSC6->c6_TES, Nil})
		aadd(aLinha,{"c6_TES",      '502', Nil})   // venda sem icm
		aadd(aLinha,{"c6_UNSVEN",   ESCSC6->c6_UNSVEN, Nil})
		//		aadd(aLinha,{"c6_LOCAL",    ESCSC6->c6_LOCAL, Nil})
		aadd(aLinha,{"c6_LOCAL",    '01', Nil})
		//		aadd(aLinha,{"c6_CF",       ESCSC6->c6_CF, Nil})
		if 	_a1_est == 'SP'
			aadd(aLinha,{"c6_CF",       '5106', Nil})
		else
			aadd(aLinha,{"c6_CF",       '5106', Nil})
		endif
		aadd(aLinha,{"c6_QTDENT",   ESCSC6->c6_QTDENT, Nil})
		aadd(aLinha,{"c6_QTDENT2",  ESCSC6->c6_QTDENT2, Nil})
		//		aadd(aLinha,{"c6_CLI",      ESCSC6->c6_CLI, Nil})
		//		aadd(aLinha,{"c6_CLI",    	cCodCli, Nil})
		aadd(aLinha,{"c6_CLI",      _a1_clie, Nil})
		aadd(aLinha,{"c6_DESCONT",  ESCSC6->c6_DESCONT, Nil})
		aadd(aLinha,{"c6_VALDESC",  ESCSC6->c6_VALDESC, Nil})
		//		aadd(aLinha,{"c6_ENTREG",   ESCSC6->c6_ENTREG, Nil})
		aadd(aLinha,{"c6_ENTREG",   dDataBase, Nil})
		aadd(aLinha,{"c6_LA",       ESCSC6->c6_LA, Nil})
		//		aadd(aLinha,{"c6_LOJA",     ESCSC6->c6_LOJA, Nil})
		aadd(aLinha,{"c6_LOJA",     _a1_lojacli, Nil})
		aadd(aLinha,{"c6_NOTA",     ESCSC6->c6_NOTA, Nil})
		aadd(aLinha,{"c6_SERIE",    ESCSC6->c6_SERIE, Nil})
		//		aadd(aLinha,{"c6_DATFAT",   ESCSC6->c6_DATFAT, Nil})
		aadd(aLinha,{"c6_NUM",      ESCSC6->c6_NUM, Nil})
		aadd(aLinha,{"c6_COMIS1",   ESCSC6->c6_COMIS1, Nil})
		aadd(aLinha,{"c6_COMIS2",   ESCSC6->c6_COMIS2, Nil})
		aadd(aLinha,{"c6_COMIS3",   ESCSC6->c6_COMIS3, Nil})
		aadd(aLinha,{"c6_COMIS4",   ESCSC6->c6_COMIS4, Nil})
		aadd(aLinha,{"c6_COMIS5",   ESCSC6->c6_COMIS5, Nil})
		aadd(aLinha,{"c6_PEDCLI",   ESCSC6->c6_PEDCLI, Nil})
		//		aadd(aLinha,{"c6_DESCRI",   ESCSC6->c6_DESCRI, Nil})
		aadd(aLinha,{"c6_DESCRI",   _b1_desc, Nil})
		aadd(aLinha,{"c6_PRUNIT",   ESCSC6->c6_PRUNIT, Nil})
		aadd(aLinha,{"c6_BLOQUEI",  ESCSC6->c6_BLOQUEI, Nil})
		aadd(aLinha,{"c6_RESERVA",  ESCSC6->c6_RESERVA, Nil})
		aadd(aLinha,{"c6_OP",       ESCSC6->c6_OP, Nil})
		aadd(aLinha,{"c6_OK",       ESCSC6->c6_OK, Nil})
		aadd(aLinha,{"c6_NFORI",    ESCSC6->c6_NFORI, Nil})
		aadd(aLinha,{"c6_SERIORI",  ESCSC6->c6_SERIORI, Nil})
		aadd(aLinha,{"c6_ITEMORI",  ESCSC6->c6_ITEMORI, Nil})
		//		aadd(aLinha,{"c6_IPIDEV",   ESCSC6->c6_IPIDEV, Nil})
		//		aadd(aLinha,{"c6_IPIDEV",   0, Nil})
		aadd(aLinha,{"c6_IDENTB6",  ESCSC6->c6_IDENTB6, Nil})
		//		aadd(aLinha,{"c6_BLQ",      ESCSC6->c6_BLQ, Nil})
		aadd(aLinha,{"c6_PICMRET",  ESCSC6->c6_PICMRET, Nil})
		aadd(aLinha,{"c6_CODISS",   ESCSC6->c6_CODISS, Nil})
		aadd(aLinha,{"c6_GRADE",    ESCSC6->c6_GRADE, Nil})
		aadd(aLinha,{"c6_ITEMGRD",  ESCSC6->c6_ITEMGRD, Nil})
		aadd(aLinha,{"c6_LOTECTL",  ESCSC6->c6_LOTECTL, Nil})
		aadd(aLinha,{"c6_NUMLOTE",  ESCSC6->c6_NUMLOTE, Nil})
		//		aadd(aLinha,{"c6_DTVALID",  ESCSC6->c6_DTVALID, Nil})
		aadd(aLinha,{"c6_NUMORC",   ESCSC6->c6_NUMORC, Nil})
		aadd(aLinha,{"c6_CHASSI",   ESCSC6->c6_CHASSI, Nil})
		aadd(aLinha,{"c6_OPC",      ESCSC6->c6_OPC, Nil})
		//		aadd(aLinha,{"c6_LOCALIZ",  ESCSC6->c6_LOCALIZ, Nil})
		aadd(aLinha,{"c6_NUMSERI",  ESCSC6->c6_NUMSERI, Nil})
		aadd(aLinha,{"c6_NUMOP",    ESCSC6->c6_NUMOP, Nil})
		aadd(aLinha,{"c6_ITEMOP",   ESCSC6->c6_ITEMOP, Nil})
		aadd(aLinha,{"c6_CLASFIS",  ESCSC6->c6_CLASFIS, Nil})
		aadd(aLinha,{"c6_QTDRESE",  ESCSC6->c6_QTDRESE, Nil})
		aadd(aLinha,{"c6_CONTRAT",  ESCSC6->c6_CONTRAT, Nil})
		aadd(aLinha,{"c6_NUMOS",    ESCSC6->c6_NUMOS, Nil})
		aadd(aLinha,{"c6_NUMOSFA",  ESCSC6->c6_NUMOSFA, Nil})
		//		aadd(aLinha,{"c6_CODFAB",   ESCSC6->c6_CODFAB, Nil})
		//		aadd(aLinha,{"c6_LOJAFA",   ESCSC6->c6_LOJAFA, Nil})
		aadd(aLinha,{"c6_ITEMCON",  ESCSC6->c6_ITEMCON, Nil})
		//		aadd(aLinha,{"c6_TPOP",     ESCSC6->c6_TPOP, Nil})
		aadd(aLinha,{"c6_REVISAO",  ESCSC6->c6_REVISAO, Nil})
		aadd(aLinha,{"c6_SERVIC",   ESCSC6->c6_SERVIC, Nil})
		aadd(aLinha,{"c6_ENDPAD",   ESCSC6->c6_ENDPAD, Nil})
		aadd(aLinha,{"c6_TPESTR",   ESCSC6->c6_TPESTR, Nil})
		aadd(aLinha,{"c6_CONTRT",   ESCSC6->c6_CONTRT, Nil})
		//		aadd(aLinha,{"c6_TPCONTR",  ESCSC6->c6_TPCONTR, Nil})
		aadd(aLinha,{"c6_ITCONTR",  ESCSC6->c6_ITCONTR, Nil})
		aadd(aLinha,{"c6_GEROUPV",  ESCSC6->c6_GEROUPV, Nil})
		aadd(aLinha,{"c6_PROJPMS",  ESCSC6->c6_PROJPMS, Nil})
		aadd(aLinha,{"c6_EDTPMS",   ESCSC6->c6_EDTPMS, Nil})
		aadd(aLinha,{"c6_TASKPMS",  ESCSC6->c6_TASKPMS, Nil})
		aadd(aLinha,{"c6_TRT",      ESCSC6->c6_TRT, Nil})
		aadd(aLinha,{"c6_QTDEMP",   ESCSC6->c6_QTDEMP, Nil})
		aadd(aLinha,{"c6_QTDEMP2",  ESCSC6->c6_QTDEMP2, Nil})
		aadd(aLinha,{"c6_PROJET",   ESCSC6->c6_PROJET, Nil})
		aadd(aLinha,{"c6_ITPROJ",   ESCSC6->c6_ITPROJ, Nil})
		aadd(aLinha,{"c6_POTENCI",  ESCSC6->c6_POTENCI, Nil})
		aadd(aLinha,{"c6_LICITA",   ESCSC6->c6_LICITA, Nil})
		//		aadd(aLinha,{"c6_REGWMS",   ESCSC6->c6_REGWMS, Nil})
//		aadd(aLinha,{"c6_MOPC",     ESCSC6->c6_MOPC, Nil})  // rf
		aadd(aLinha,{"c6_NUMCP",    ESCSC6->c6_NUMCP, Nil})
		aadd(aLinha,{"c6_NUMSC",    ESCSC6->c6_NUMSC, Nil})
		aadd(aLinha,{"c6_ITEMSC",   ESCSC6->c6_ITEMSC, Nil})
		//		aadd(aLinha,{"c6_SUGENTR",  ESCSC6->c6_SUGENTR, Nil})
		aadd(aLinha,{"c6_ABSCINS",  ESCSC6->c6_ABSCINS, Nil})
		aadd(aLinha,{"c6_ABATISS",  ESCSC6->c6_ABATISS, Nil})
		aadd(aLinha,{"c6_ABATMAT",  ESCSC6->c6_ABATMAT, Nil})
		
		_numitem++
		aadd(aItens,aLinha)
		ESCSC6->(DBSKIP())
		
	enddo
	
	//	MATA410(aCabec,aItens,3)
	nOperacao   := 3
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| MATA410(x,y,z)}, aCabec, aItens, nOperacao)
	If lMsErroAuto
		MostraErro()
		If ( __lSX8)
			RollBackSX8()
		EndIf
		DisarmTransaction()
	Else
		If ( __lSX8)
			ConfirmSX8()
		EndIf
	EndIf
	/*
	
	If !lMsErroAuto
	cLine := "Pedido: " + cDoc + cCRLF
	fWrite(nHdlArq,cLine,Len(cLine))
	cLine := "Incluido com Sucesso" + cCRLF
	fWrite(nHdlArq,cLine,Len(cLine))
	cLine := "" + cCRLF
	fWrite(nHdlArq,cLine,Len(cLine))
	Else
	ConOut("Erro na inclusao!")
	cLine := "Erro na inclusao do pedido: " + cDoc + cCRLF
	fWrite(nHdlArq,cLine,Len(cLine))
	EndIf
	
	*/
	
	dbselectarea("ESCSC5")
	// atualizar o flag do pedido jแ processado no bando da escalena
	_cquery := " UPDATE LNK_LASELVA.INTEGRACAO_LASELVA.dbo.lsvpdcab "
	_cquery += " SET c5_PROCESSADO ='1' where a1_PROCESSADO IS NULL AND c5_NUM =' " + _ped_esc + "'"
	TcSQLExec(_cquery)
	
	// atualizar o campo C5_MENNOTA, mensagem da nota fiscal com o numero original do pedido da escalena
	_cquery := " UPDATE LNK_LASELVA.INTEGRACAO_LASELVA.dbo.lsvcliente "
	_cquery += " SET c5_PROCESSADO ='1' where a1_PROCESSADO IS NULL AND c5_NUM =' "  + _ped_esc + "'"
	TcSQLExec(_cquery)
	
	ESCSC5->(dbskip())
	
enddo



If Select("ESCSA1") > 0
	DbSelectArea("ESCSA1")
	ESCSA1->(DbCloseArea())
EndIf
If Select("ESCSC5") > 0
	DbSelectArea("ESCSC5")
	ESCSC5->(DbCloseArea())
EndIf
If Select("ESCSC6") > 0
	DbSelectArea("ESCSC6")
	ESCSC6->(DbCloseArea())
EndIf


return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelArq    บAutor  ณ Ernani Forastieri  บ Data ณ  20/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina auxiliar de Selecao do arquivo texto a ser importadoบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function SelArq()
Private _cExtens   := "Arquivo Texto (*.TXT) |*.TXT|"
_cRet := cGetFile(_cExtens,"Selecione o Arquivo",,,.F.,GETF_NETWORKDRIVE+GETF_LOCALFLOPPY+GETF_LOCALHARD)
_cRet := ALLTRIM(_cRet)
Return _cRet
/*
