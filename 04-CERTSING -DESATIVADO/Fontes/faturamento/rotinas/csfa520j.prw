#include "ap5mail.ch"
#Include 'Protheus.ch'
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} User Function nomeFunction
	
	Job que realiza o reenvio dos recebidos que falharam

	@type User Function
	@author Julio Teixeira  - Compila   
	@since 27/05/2021
	@version version
	@param aParam = {cEmp,cFil}
	@return Nil
/*/
User Function csfa520j(aParam)
	
	Local cAlias 
	Local cQuery := ""
	Local nLimD 
	Local cRecPgto
	Local cTipMov
	Local cPedido
	
	Default aParam := {"01","01"}

	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]

	DbSelectArea("SC5")

	nLimD := SuperGetMv("CP_DENVREC",.F.,5)
	cAlias := GetNextAlias()

	cQuery := " SELECT SC5.R_E_C_N_O_ C5_RECNO "+CRLF
	cQuery += " FROM "+RetSqlName("SC5")+" SC5 "+CRLF
	cQuery += " WHERE SC5.D_E_L_E_T_ <> '*' "+CRLF
	cQuery += " AND C5_EMISSAO >= '"+DtoS(Date()-nLimD)+"' "+CRLF
	cQuery += " AND C5_TIPMOV <> '6' "+CRLF
	cQuery += " AND C5_XRECPG = '' "+CRLF
	cQuery += " AND C5_FILIAL = '"+FWxFilial("SC5")+"' "+CRLF

	cQuery := ChangeQuery(cQuery)
    
	DBUseArea(.T., "TOPCONN", TcGenQry( , , cQuery), cAlias, .T., .T.) 

	While (cAlias)->(!EOF()) 
		
		SC5->(DbGoTo((cAlias)->C5_RECNO))
		cPedido := SC5->C5_NUM
		cTipMov := iif(Alltrim(SC5->C5_TIPMOV) $ "2,3,5","PR","NCC")
		cNpSite := SC5->C5_XNPSITE
		//geração de recibo de pagamento
		aRet := U_CSFA520(cPedido)
		//grava link e prepara registro para envio para hub
		If aRet[1]
			cRecPgto	:= aRet[2]
			
			SZQ->(Reclock("SZQ"))
			SZQ->ZQ_STATUS := "3"
			SZQ->ZQ_NF1 := ""
			SZQ->ZQ_OCORREN := "Recibo gerado com sucesso."
			SZQ->ZQ_DATA := ddatabase
			SZQ->ZQ_HORA:=time()
			SZQ->(MsUnlock())
			
			//gravação do link do recibo
			If !Empty(cRecPgto)

				RecLock("SC5", .F.)
				Replace SC5->C5_XRECPG With cRecPgto
				Replace SC5->C5_XFLAGEN With Space(TamSX3("C5_XFLAGEN")[1])
				SC5->(MsUnLock())
			
            EndIf
			
			U_GTPutOUT(cID,"R",cNpSite,{"RECIBO_PAGAMENTO",{.T.,"M00001",cNpSite,"JOB - Geração do Recibo com sucesso para tipo "+cTipMov+ " Pedido "+cPedido+" Pagamento "+Alltrim(SC5->C5_TIPMOV)}},cNpSite)

		EndIf
		
		(cAlias)->(DBSkip())
	Enddo

    RESET ENVIRONMENT 

Return Nil
