#Include 'Protheus.ch'
#Include 'TopConn.ch'


/*/{Protheus.doc} MTA110MNU
Ponto de Entrada para adicionar uma rotina ao menu de SC
@type User_function
@version  1
@author Junior Placido
@since 24/04/2021
/*/
User Function MTA110MNU()

	AAdd(aRotina,{'Alterar Especial',"processa({||u_AltEspSC1()}, '', 'Alterar Especial', .f.)", 0, 4, 0, Nil })

Return


/*/{Protheus.doc} AltEspSC1
Função que dispara o novo Browse de alteração
@type User_function
@version  1
@author Junior Placido
@since 24/04/2021
/*/
User Function AltEspSC1()
	Local aArea   := GetArea()

	IF !(SC1->C1_FLAGGCT == '1')
		Alert("Somente solicitações integradas com Contratos poderão ser alteradas nesta modalidade","Atenção")
	ELSE
		zAltEsp(SC1->C1_NUM)
	ENDIF

	RestArea(aArea)

Return Nil


/*/{Protheus.doc} zAltEsp
Função para montar um novo browse com a solicitação filtrada
e sem acesso a alteração de campos especificos
@type Static_function
@version  1
@author Junior Placido
@since 24/04/2021
@param cNumSC, character, Numero da Solicitação
/*/
Static Function zAltEsp(cNumSC)
	Local aArea   := GetArea()
	Local cFunBkp := FunName()
	Local oBrowse
	Local cSql 	  := ""
	Local cContra := ""
	//Setando o nome da função, para a função customizada
	SetFunName("ALTESP")
	//Instânciando FWMBrowse, setando a tabela, a descrição
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SC1")
	oBrowse:SetDescription("Alterar Especial")
	//Filtrando os dados
	oBrowse:SetFilterDefault("SC1->C1_NUM == '"+cNumSC+"' ")
    /* 
    Em tempo de execução preenche o campo de FLAG com '2', para permitir a alteração
    */

	cSql := "SELECT * FROM "+RetSqlName("SC1")+" SC1 WHERE SC1.C1_NUM = '"+cNumSC+"' AND SC1.D_E_L_E_T_<> '*' AND SC1.C1_XCONTRA <> ' ' " //Busca solicitação
	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf
	TCQuery cSql New Alias "QRY"

	cContra := QRY->C1_XCONTRA

	/*
	While !QRY->(EOF())
		RecLock("SC1",.F.)
		SC1->C1_FLAGGCT := "1"
        SC1->C1_XCONTRA := QRY->C1_XCONTRA
		SC1->(MsUnlock())
		QRY->(DbSkip())
	End
	*/
	
	cSql := "UPDATE "+RetSqlName("SC1")+" SC1 SET SC1.C1_FLAGGCT = '2', SC1.C1_XCONTRA = '"+cContra+"' WHERE SC1.C1_NUM = '"+cNumSC+"' AND SC1.D_E_L_E_T_<> '*' " //Busca solicitação
	TcSqlExec(cSql)

	//Ativando a navegação
	oBrowse:Activate()
	//Voltando o nome da função
	SetFunName(cFunBkp)

	If !lCopia
		cSql := "UPDATE "+RetSqlName("SC1")+" SC1 SET SC1.C1_FLAGGCT = '1', SC1.C1_XCONTRA = '"+cContra+"' WHERE SC1.C1_NUM = '"+cNumSC+"' AND SC1.D_E_L_E_T_<> '*'  " //Busca solicitação
		TcSqlExec(cSql)
	EndIf

	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return Nil
