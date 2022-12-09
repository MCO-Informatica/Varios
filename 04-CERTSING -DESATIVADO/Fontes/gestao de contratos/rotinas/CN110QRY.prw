//----------------------------------------------------------------------------------
// Rotina | CN100Qry | Autor | Renato Ruy                        | Data | 29.10.2014 
//----------------------------------------------------------------------------------
// Descr. | Ponto de entrada acionado após a elaboração da query para apresentar os
//        | dados para o usuário com o painel de selecao de contrato/cronograma.
//----------------------------------------------------------------------------------
// Objet. | Trazer os dados apenas do contrato em questão e para as situações
//        | necessárias.
//----------------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//----------------------------------------------------------------------------------
User Function CN110QRY()
	Local cExp := ""
	cExp := "SELECT DISTINCT CN9.CN9_FILIAL, "
	cExp += "                CN9.CN9_NUMERO, "
	cExp += "                CN9.CN9_REVISA, "
	cExp += "                CN9.CN9_DTINIC, "
	cExp += "                CN9.CN9_DTFIM, "
	cExp += "                CN9.CN9_CONDPG, "
	cExp += "                CN9.CN9_SITUAC, "
	cExp += "                CN9.CN9_SALDO "
	cExp += "FROM " + RetSqlName("CN9") + " CN9, " 
	cExp += "     " + RetSqlName("CNA") + " CNA, " 
	cExp += "     " + RetSqlName("CN1") + " CN1  "
	cExp += " WHERE CN9.CN9_FILIAL = '" + xFilial("CN9") + "'"
	cExp += "       AND CNA.CNA_FILIAL = '"+ xFilial("CNA") + "'"
	cExp += "       AND CN1.CN1_FILIAL = '"+ xFilial("CN1") + "'"
	cExp += "       AND CN9.CN9_NUMERO = CNA.CNA_CONTRA "
	cExp += "       AND CN9.CN9_REVISA = CNA.CNA_REVISA "
	cExp += "       AND CN9.CN9_TPCTO  = CN1.CN1_CODIGO "
	cExp += "       AND CN9.CN9_SITUAC IN ('02','03','04','05','09','10') "
	cExp += "       AND CN9.CN9_REVATU = ' ' "
	//cExp += "       AND CNA.CNA_CRONOG = ' ' " em teste com a Bruna no ambiente Rleg2.
	cExp += "       AND CN9.D_E_L_E_T_ = ' ' "
	cExp += "       AND CNA.D_E_L_E_T_ = ' ' "
	cExp += "       AND CN1.D_E_L_E_T_ = ' ' "
Return( cExp ) 