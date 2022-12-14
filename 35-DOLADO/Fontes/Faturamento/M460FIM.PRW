#INCLUDE "TOPCONN.CH"

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PONTO DE ENTRADA CHAMADA M460FIM, SE REFERE A GRAVA??O AP?S (DEPOIS) DA PREPARA??O DE DOCUMENTO DE SA?DA. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
User Function M460FIM()
	Local aArea := GetArea()
	Local lRet    := .t.
	Local _cIdEnt := " "


	_cIdEnt := RetIdEnti() //RETORNA A ENTIDADE DE NF DE ACORDO COM A FILIAL.

	SpedNFeTrf("SF2",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC,_cIdEnt,"1","1","4.00",,,) // FUN??O QUE TRANSMITE AUTOM?TICA.

	MsgInfo("Nota Fiscal "+SF2->F2_SERIE+SF2->F2_DOC+" acabou de ser transmitida!!!","ATEN??O") //EXIBE A MENSAGEM DIZENDO QUE A NOTA FOI TRANSMITIDA.

	U_MonitNFE( SF2->F2_SERIE, SF2->F2_DOC, SF2->F2_DOC,"SF2") //EXIBE A CONSULTA NFE DIZENDO QUE A NOTA FOI TRANSMITIDA OU N?O.

	If SF2->F2_FIMP$"S" //----> NOTA AUTORIZADA
        Processa( {|| U_zGerDanfe('SF2')}, "Impress?o DANFE", "Imprimindo DANFE...", .f.)
    else
        MsgInfo("Fa?a a impress?o da DANFE daqui alguns minutos, pois a nota fiscal "+SF2->F2_SERIE+SF2->F2_DOC+" ainda n?o foi autorizada na SEFAZ.","ATEN??O") //EXIBE A MENSAGEM DIZENDO QUE A NOTA FOI TRANSMITIDA.    
    EndIf

RestArea(aArea)

return lRet
