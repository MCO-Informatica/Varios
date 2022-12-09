#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GARA182   �Autor  �OPVS CA             � Data �  06/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa de exportacao de arquivo TXT em layout especifico ���
���          � para importacao pelo sistema GAR                           ���
�������������������������������������������������������������������������͹��
���Uso       � JOB executado em horario especificado em parametro        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GARA182

Local cTime :=  time()
Local _cSql 	:= ""
Local cFileOut  := ""
Local nHandle	:= -1 
Local cValor	:= ""
Local cJobEmp 	:= Getjobprofstring("JOBEMP","01")
Local cJobFil 	:= Getjobprofstring("JOBFIL","02")
Local cInterval := Getjobprofstring("INTERVAL","60")
Local cHrExec	:= ""

Conout("Job GARA182 - Begin Emp("+cJobEmp+"/"+cJobFil+")" )
Conout("Interval Check : "+cInterval)

Rpcsettype(3)
RpcSetEnv(cJobEmp,cJobFil)

OpenGTEnv()				// Abertura das Tabelas

cHrExec 	:=  GetNewPar("MV_GARTXTH", "00:01")
nDiasAnt 	:=  GetNewPar("MV_GARTXTD", 0)

If Substr(time(),1,5) = cHrExec
	While !File("\pedidosfaturados\vendas_diretas_"+Dtos(DdataBase)+".txt")
		Conout("Job GARA182 - EXECUTE Emp("+cJobEmp+"/"+cJobFil+")" )
	
		_cSql := "SELECT "
		_cSql += "	C6_ITEM, "
		_cSql += "	C6_NUM AS CD_SIGA, "
		_cSql += "	B1_DESC AS DS_PRODUTO, "
		_cSql += "	C6_VALOR AS VL_PRODUTO, "
		_cSql += "	B1_CATEGO AS CD_STATUS, "
		_cSql += "	SUBSTR(C6_DATFAT,7,2) + '/' + SUBSTR(C6_DATFAT,5,2) + '/' + SUBSTR(C6_DATFAT,1,4) AS DT_FATURAMENTO "
		_cSql += "FROM "
		_cSql += "	"+RetSqlName("SC5")+" SC5 INNER JOIN "+RetSqlName("SC6")+" SC6 ON	"
		_cSql += "	C5_NUM = C6_NUM INNER JOIN "+RetSqlName("SA3")+" SA3 ON "
		_cSql += "	(C5_VEND1 = A3_COD OR C5_VEND2 = A3_COD) INNER JOIN "+RetSqlName("SB1")+" SB1 ON "
		_cSql += "	C6_PRODUTO = B1_COD "
		_cSql += "WHERE " 
		_cSql += "	C5_FILIAL = '"+xFilial("SC5")+"' AND "
		_cSql += "	SC5.D_E_L_E_T_ = ' ' AND "
		_cSql += "	C6_FILIAL = '"+xFilial("SC6")+"' AND "
		_cSql += "	C6_PEDGAR = '' AND "
		_cSql += " 	C6_DATFAT >= '"+DtoS(dDataBase-nDiasAnt)+"' AND " 
		_cSql += " 	SC6.D_E_L_E_T_ = ' ' AND "
		_cSql += "	A3_FILIAL = '"+xFilial("SA3")+"' AND "
		_cSql += "	A3_XCANAL = '000001' AND "
		_cSql += "	A3_MSBLQL = '2' AND "
		_cSql += "	SA3.D_E_L_E_T_ = ' ' AND "
		_cSql += "	B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cSql += "	B1_CATEGO IN ('1','2') AND "
		_cSql += "	SB1.D_E_L_E_T_ = ' '	"
		_cSql += "GROUP BY "
		_cSql += "	C6_ITEM, " 
		_cSql += "	C6_NUM, " 
		_cSql += "	B1_DESC, "
		_cSql += "	C6_VALOR, "
		_cSql += "	B1_CATEGO, "
		_cSql += "	C6_DATFAT "
		_cSql += "ORDER BY "
		_cSql += "	C6_DATFAT, "
		_cSql += "	C6_NUM "
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSql),"TRBVEND",.F.,.T.)
		
		TcSetField("TRBVEND","VL_PRODUTO","N",15,2)
		//Path da pasta onde os arquivos gerados serao salvos \\192.168.16.30\t$\Totvs\Protheus_Data10\pedidosfaturados	
		cFileOut := "\pedidosfaturados\vendas_diretas_"+Dtos(DdataBase)+".txt"
		nHandle := FCREATE(cFileOut)
		
		If nHandle != -1
				
			TRBVEND->(DbEval({||	cValor := Str(TRBVEND->VL_PRODUTO),;
									FWrite(nHandle,	PADR(TRBVEND->CD_SIGA,38)+;
													PADR(TRBVEND->DS_PRODUTO,30)+;								
							 						PADR(StrTran(alltrim(cValor),".",","),16)+;
													PADR(TRBVEND->CD_STATUS,1)+;												
													PADR(TRBVEND->DT_FATURAMENTO,10)+;
													CRLF ) }) )		
		
			fclose(nHandle)
			Conout("Job GARA182 - SUCESS EXECUTE Emp("+cJobEmp+"/"+cJobFil+")" )
			Conout("Tempo de Execucao Inicio- "+cTime+" Termino "+Time())
			Conout("Arquivo Criado - "+cFileOut)
			
		Else
			Conout("Job GARA182 - ERRO EXECUTE Emp("+cJobEmp+"/"+cJobFil+")" )
			CONOUT("ERROR - FAILED TO CREATE "+cFileOut+" - FERROR "+str(ferror()))
		Endif
		
		TRBVEND->(DbCloseArea())
	EndDo
EndIf

Return