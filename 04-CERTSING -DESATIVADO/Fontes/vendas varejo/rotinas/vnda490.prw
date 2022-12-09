#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA490   ºAutor  ³OPVS (David)        º Data ³  11/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa de exportacao de arquivo TXT em layout especifico º±±
±±º          ³ para importacao pelo sistema GAR de vouchers utilizados    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VNDA490(aParSch)
	Local cSQL    := ''
	Local cTRB    := ''
	Local cFile   := ''
	Local cValor  := ''
	Local cJobEmp := aParSch[1]
	Local cJobFil := aParSch[2]
	Local nHandle := -1
	Local _lJob   := (Select('SX6')==0)
	
	If _lJob
		RpcSetType(3)
		RpcSetEnv(cJobEmp, cJobFil)
	EndIf

	nDiasAnt := GetNewPar("MV_GARTXTD", 0)

	cSQL += "SELECT B.ZG_NUMPED                   CD_PEDIDO, " + CRLF
	cSQL += "       B.ZG_NUMVOUC                  CD_VOUCHER, " + CRLF
	cSQL += "       A.ZF_OBS                      DS_MOTIVO, " + CRLF
	cSQL += "       B.ZG_DATAMOV                  DATAVOU, " + CRLF
	cSQL += "       SUBSTR(B.ZG_DATAMOV, 7, 2)||'/'||SUBSTR(B.ZG_DATAMOV, 5, 2)||'/'||SUBSTR(B.ZG_DATAMOV, 1, 4) DT_VOUCHER " + CRLF
	cSQL += "FROM   " + RetSqlName("SZF") + " A " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SZG") + " B " + CRLF
	cSQL += "               ON B.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND A.ZF_FILIAL = ZG_FILIAL " + CRLF
	cSQL += "                  AND A.ZF_CODFLU = ZG_CODFLU " + CRLF
	cSQL += "                  AND A.ZF_COD = ZG_NUMVOUC " + CRLF
	cSQL += "WHERE  B.ZG_DATAMOV >= '" + DtoS(Date() - nDiasAnt) + "' " + CRLF
	cSQL += "       AND A.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "UNION " + CRLF
	cSQL += "SELECT B.ZG_NUMPED                   CD_PEDIDO, " + CRLF
	cSQL += "       B.ZG_NUMVOUC                  CD_VOUCHER, " + CRLF
	cSQL += "       A.ZF_OBS                      DS_MOTIVO, " + CRLF
	cSQL += "       B.ZG_DATAMOV                  DATAVOU, " + CRLF
	cSQL += "       SUBSTR(B.ZG_DATAMOV, 7, 2)||'/'||SUBSTR(B.ZG_DATAMOV, 5, 2)||'/'||SUBSTR(B.ZG_DATAMOV, 1, 4) DT_VOUCHER" + CRLF
	cSQL += "FROM   " + RetSqlName("SZF") + " A " + CRLF
	cSQL += "       INNER JOIN " + RetSqlName("SZG") + " B " + CRLF
	cSQL += "               ON B.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND A.ZF_FILIAL = ZG_FILIAL " + CRLF
	cSQL += "                  AND A.ZF_CODFLU = ZG_CODFLU " + CRLF
	cSQL += "                  AND A.ZF_COD = ZG_NUMVOUC " + CRLF
	cSQL += "       INNER JOIN GTVOUCHER C " + CRLF
	cSQL += "               ON C.D_E_L_E_T_ = ' ' " + CRLF
	cSQL += "                  AND A.ZF_COD = GT_VOUCHER " + CRLF
	cSQL += "WHERE  A.D_E_L_E_T_ = ' '" + CRLF
	cSQL += "ORDER  BY CD_PEDIDO" + CRLF

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSQL ), cTRB, .F., .T. )
	
	//Path da pasta onde os arquivos gerados serao salvos \\192.168.16.30\t$\Totvs\Protheus_Data10\pedidosfaturados	
	cFile := "\pedidosfaturados\voucher_"+Dtos(date())+".txt"
	nHandle := FCREATE(cFile)
	
	If nHandle != -1
		OpenGTVou()
		
		While .NOT. (cTRB)->( EOF() )
			IF	Empty( (cTRB)->CD_PEDIDO )
				A490Put( (cTRB)->CD_VOUCHER, (cTRB)->DATAVOU, .T. )
			Else
				FWrite(nHandle,	PADR((cTRB)->CD_PEDIDO,38) + PADR((cTRB)->CD_VOUCHER,20) + PADR((cTRB)->DS_MOTIVO,150) + PADR((cTRB)->DT_VOUCHER,10) + CRLF )
				A490Put( (cTRB)->CD_VOUCHER, (cTRB)->DATAVOU, .F. )
			EndIF
			(cTRB)->( dbSkip() )	
		End
	Else
		Conout("Job vnda490 - ERRO EXECUTE Emp("+cJobEmp+"/"+cJobFil+")" )
		CONOUT("ERROR - FAILED TO CREATE "+cFile+" - FERROR "+str(ferror()))
	Endif

	(cTRB)->( DbCloseArea() )
Return

Static Function A490Put( cNumVOU, cDateVou, lGRV )
	DbSelectArea("GTVOUCHER")
	dbGotop()
	
	IF lGRV
		IF .NOT. DbSeek(cNumVOU)
			// Acrescrenta o registro na base de saida
			DbAppend(.F.)
			
			//GTVOUCHER->GT_PEDGAR  := cNumPED
			GTVOUCHER->GT_VOUCHER := cNumVOU
			GTVOUCHER->GT_DATE    := StoD(cDateVou)
			
			DBCommit()
			DbrUnlock()
		EndIF
	Else
		IF DbSeek(cNumVOU)
			dbrlock(recno())
			DbDelete()
			dbrunlock()
		EndIF
	EndIF
Return

Static Function OpenGTVou()
	If select("GTVOUCHER") <= 0
		USE GTVOUCHER ALIAS GTVOUCHER SHARED NEW VIA "TOPCONN"
		If NetErr()
			UserException("Falha ao abrir GTVOUCHER - SHARED" )
		Endif
		DbSetIndex("GTVOUCHER01")
		DbSetOrder(1)
	Endif
Return

/*
==================================================================
Funcao de criacao das tabelas
================================================================== */
User Function UpdTbVou()
	Local aStru :=  {}

	If !tccanopen('GTVOUCHER')
       // Cria a tabela caso nao exista
		aStru :=  {}
      
		aadd(aStru,{"GT_VOUCHER","C",15,0})
		aadd(aStru,{"GT_DATE"   ,"D",08,0})
 
		conout("Criando tabela de entrada GTVOUCHER")
		DbCreate('GTVOUCHER',aStru,"TOPCONN")
	Endif
 
	If !TcCanOpen('GTVOUCHER','GTVOUCHER01' )
       // cria o indice caso nao exista
		conout("Criando indice de entrada GTVOUCHER")
      
		USE GTVOUCHER ALIAS GTVOUCHER EXCLUSIVE NEW VIA "TOPCONN"
      
		IF NetErr()
			UserException("Falha ao abrir GTVOUCHER em modo exclusivo para criacao do indice." )
		Endif
      
       // Cria o indice para busca de dados
		INDEX ON GT_VOUCHER TO ("GTVOUCHER01")
      
		USE
	Endif
	Aviso( 'SIGAFAT', "Compatibilização executada com sucesso.", {"Ok"} )	
Return