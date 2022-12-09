#INCLUDE "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#include "topconn.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "MSOLE.CH"
 
/* 
  PONTO DE ENTRADA MVC CNTA121() - Luiz M. Suguiura - UPDuo (28/07/2022)

  https://tdn.totvs.com/display/public/PROT/CNTA121+-+Exemplos+pontos+de+entrada_MVC

  05. Carregar dados adicionais na carga dos itens(CNE) = CN130INC
  09. Implementação equivalente CN130TOK

*/

User Function CNTA121()
Local aParam    := PARAMIXB
Local xRet      := .T.
Local oModel    := Nil
Local oModelCND := Nil
Local oModelCNE := Nil
//Local oModelCZY := Nil
Local cIdPonto  := ''
Local cIdModel  := ''
Local cCampo    := ""
Local cAction   := ""
Local xValue    := 0
Local cProj   

_cEmpCNB := CEMPANT+CFILANT
cProj := U_ItemSZ3(_cEmpCNB,"CNB")
    
If aParam = NIL
   Return()
Endif

oModel   := aParam[1]
cIdPonto := AllTrim(aParam[2])
cidModel := AllTrim(aParam[3])

//oModelPad     := FWModelActive()   cIdPonto = "FORMPRE" e aParam[5] = "SETVALUE" e aParam[6] = "CXN_CHECK"
//oModelGridCXN := oModelPad:GetModel('CXNDETAIL')
//oModel:getvalue("CXN_CHECK")
//Bloco teste para verificar o check mark da planilha
IF cIdModel = "CXNDETAIL"
   
    nA := 0
    lCheckModelo := oModel:getvalue("CXN_CHECK")
    lCheckTabela := CXN->CXN_CHECK
    lAlterou     := oModel:IsFieldUpdated("CXN_CHECK")
    IF nA = 1
        U_SOLCOMCTR()
    ENDIF

ENDIF

// !oModel:getvalue("CXN_CHECK") .and. CXN->CXN_CHECK = MARCANDO

// Antigo CN130Inc
// Atualizar as entidade contábeis conforme as regras - a partir da Planiha (CNB) ==> precisa ver como executar só uma vez
If cIdModel = "CNEDETAIL" .and. cIdPonto == "FORMLINEPOS"
    oModelPad  := FWModelActive()
    cContraAtual := oModelPad:GetValue("CNDMASTER", "CND_CONTRA")
    if cContraAtual = CNB->CNB_CONTRA
        oModelCNE := oModel  
        oModelCNE:LoadValue("CNE_CC", CNB->CNB_CC) 
        oModelCNE:LoadValue("CNE_CONTA", CNB->CNB_CONTA) 

		If !SubStr(cFilAnt, 1, 5) == "00300"          // se for Holding-Renova,pega o que esta na planilha
			cProj   := u_ItemSZ3(_cEmpCNB,"CNB")      // Função para selecionar projeto de acordo com a empresa
			_cProjC := U_ItemSZ0(cProj,"CNB")         // com base no item contabil/projeto, retorna o código do projeto em curso
			oModelCNE:LoadValue("CNE_ITEMCT", cProj)
            cCamada := SubStr(cProj, 1, 2) 
            oModelCNE:LoadValue("CNE_CLVL", cCamada)  
			If cCamada <>  SubStr(CNB->CNB_EC05DB, 1, 2)  //Se classe orçamentária diferente da SC altero os 2 primeiros digitos da classe
				cClasse := cCamada + SubStr(CNB->CNB_EC05DB, 3, 9)
                oModelCNE:LoadValue("CNE_EC05DB", cClasse)
			Else
				oModelCNE:LoadValue("CNE_EC05DB", CNB->CNB_EC05DB)
			Endif	
			If SubStr(AllTrim(CNB->CNB_CONTA), 1, 7) == "1232103" .AND. !Empty(_cProjC)
				oModelCNE:LoadValue("CNE_XIMCUR", "S")
				oModelCNE:LoadValue("CNE_XPROJI", AllTrim(_cProjC))   
			Endif
		Else	
			oModelCNE:LoadValue("CNE_CLVL",   CNB->CNB_CLVL)
			oModelCNE:LoadValue("CNE_ITEMCT", CNB->CNB_ITEMCT)
			oModelCNE:LoadValue("CNE_EC05DB", CNB->CNB_EC05DB)
			oModelCNE:LoadValue("CNE_XIMCUR", CNB->CNB_XIMCUR)
			oModelCNE:LoadValue("CNE_XPROJI", CNB->CNB_XPROJI)
		Endif
    ENDIF
EndIf

// Antigo CN130TOK
// Se Inclusão ou Alteração - Verifica se tem adiantamento  isincallstack("cn121medenc") aqui e commit
// Se Exclusão - Pergunta se tem certeza para excluir
If cIdPonto == "MODELPOS" .and. !IsInCallStack("CN121MEDENC")
    // oModel = instância de MPFormModel
    if oModel:GetOperation() == MODEL_OPERATION_INSERT
        If oModel:GetValue("CNDMASTER", "CND_TOTADT") = 0
            xRet := CN121_ConfAdt(oModel:GetValue("CNDMASTER", "CND_CONTRA"))
        EndIf
//    ElseIf oModel:GetOperation() == MODEL_OPERATION_UPDATE
//            xRet := CN121_ConfAdt(oModel:GetValue("CNDMASTER", "CND_CONTRA"))
//    ElseIf oModel:GetOperation() == MODEL_OPERATION_DELETE
//      xRet := MsgYesNo("Confirma exclusão?")
    endif
EndIf 

// Salvar o nome do usuário - executando antes do Committ do CND   CNA->CNA_CONTRA CNA->CNA_NUMERO  CNA->CNA_REVISA
If cIdPonto == "FORMCOMMITTTSPRE" .and. !IsInCallStack("CN121MEDENC")  
    if cIdModel == "CNDMASTER"
        oModelCND := oModel
        lIsInsert := aParam[4]
        if lIsInsert
            oModel:LoadValue("CND_XNOMUS", ALLTRIM(cUserName))
        endif
    endif
endif

// Após todas as gravações e fora da Transação  
// Não executar se for Exclusão de Medição ou Encerramento (ou Estorno)
If cIdPonto == "MODELCOMMITNTTS" .and. !IsInCallStack("CN121MEDENC")
 
    oModelFinal := oModel
    if oModel:GetOperation() <> MODEL_OPERATION_DELETE
        if CND->CND_FILIAL == CXN->CXN_FILIAL .AND. CND->CND_CONTRA == CXN->CXN_CONTRA .AND.;
            CND->CND_REVISA == CXN->CXN_REVISA .AND. CND->CND_NUMMED == CXN->CXN_NUMMED 
            CND->CND_FORNEC := CXN->CXN_FORNEC
            CND->CND_LJFORN := CXN->CXN_LJFORN
            CND->CND_CLIENT := CXN->CXN_CLIENT
            CND->CND_LOJACL := CXN->CXN_LJCLI
            CND->CND_NUMERO := CXN->CXN_NUMPLA
        endif
    endif
endif

// CN9->CN9_NUMERO CN9->CN9_REVISA
// CNA->CNA_CONTRA CNA->CNA_REVISA
// CNB->CNB_CONTRA CNB->CNB_REVISA
// CNC->CNC_NUMERO CNC->CNC_REVISA CNC->CNC_CODIGO CNC->CNC_LOJA
// CND->CND_CONTRA CND->CND_REVISA CND->CND_NUMMED  CND->CND_FORNEC
// CNE->CNE_CONTRA CNE->CNE_REVISA CNE->CNE_NUMMED  CNE->CNE_ITEM   CNE->CNE_NUMERO CNE->CNE_ITEM
// CXN->CXN_CONTRA CXN->CXN_REVISA CXN->CXN_NUMMED  CXN->CXN_NUMPLA CXN->CXN_FORNEC 



Return xRet


//****
Static Function CN121_ConfAdt(cContra)

Local lRetorno 	:= .T. 
Local cAliasQry	:= ""
Local cQuery		:= ""             
Local aArea		  := GetArea()
Local nContreg  := 0
Local cMsg      := ""


// Verifica se há adiantamento com saldo para o contrato
cAliasQry := GetNextAlias()
cQuery := "SELECT CNX_NUMERO, CNX_VLADT,CNX_SALDO "
cQuery += "  FROM "+RetSqlName("CNX")+" CNX "
cQuery += "  WHERE CNX_CONTRA ='"+cContra+ "'"
cQuery += "  AND CNX_XFILOR = '"+cFilAnt+"'"
cQuery += "  AND CNX_SALDO > 0 "
cQuery += "  AND CNX.D_E_L_E_T_=' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )
(cAliasQry)->(DbGoTop())

nContReg := 0
while !(cAliasQry)->(EOF())
    nContreg += 1
	  (cAliasQry)->(DbSkip())
EndDo

if nContReg > 0
    cMsg := "Atenção, existe(m) "+AllTrim(Str(nContReg))+" adiantamento(s) para esse contrato."+CHR(13)+CHR(10)+CHR(13)+CHR(10)
    cMsg += "Deseja sair sem utilizar adiantamento(s)?"
    if !MsgYesNo(cMsg, "Confirmação")
	      cMsg := "Utilize a aba Adiantamentos para visualizar"+CHR(13)+CHR(10)
	      cmsg += "o(s) adiantamento(s) existente(s)."
	      MessageBox(cMsg,"Retornar à Medição",64)
        lRetorno := .F.
   endif
endif

RestArea(aArea)

Return(lRetorno)
