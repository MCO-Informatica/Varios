#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  CPCpoAdc    Autor ³ Romay Oliveira     º Data ³  06/2015     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada na apuracao de pis/cofins para carregar	  º±±
±±º				campo no titulo SE2										  º±±
±±º																		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico Renova		                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs		 ³Inova Solution											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

User Function CPCpoAdc()

Local cAlias	:= PARAMIXB[1]   

// Luiz M Suguiura (29/09/2020) - Parâmetro para indicar o Gestor para liberação do título
Local _cLiber := GetNewPar( "MV_FINALAP", "000001")  


(cAlias)->E2_E_APUR	:= mv_par02  // data da apuracao
//(cAlias)->E2_E_APUR	:= mv_par23  // data da apuracao


// Luiz M. Suguiura - 29/09/2020
// Atualização dos campos referentes a Recuperação Judicial
// Se posterior a RJ (16/10/2019) grava o título Liberado
if MV_PAR02 > CtoD("16/10/2019")
	(cAlias)->E2_APROVA  := ""
    (cAlias)->E2_DATALIB := dDataBase   // Data da Liberação = Data da Apuração
    (cAlias)->E2_STATLIB := "03"
    (cAlias)->E2_USUALIB := "INC POSTERIOR REC JUDIC  "
    (cAlias)->E2_CODAPRO := "000000"   // Como o titulo foi gravado como liberado, gravado esse código de liberador
    (cAlias)->E2_XRJ     := "N"
else
    (cAlias)->E2_APROVA  := ""
    (cAlias)->E2_DATALIB := CtoD("  /  /    ")
    (cAlias)->E2_STATLIB := ""
    (cAlias)->E2_USUALIB := ""
    (cAlias)->E2_CODAPRO := _cLiber    // Como o titulo foi gravado bloqueado, esse deve ser o gestor para liberação
    (cAlias)->E2_XRJ     := "S"
endif

Return .T.  
