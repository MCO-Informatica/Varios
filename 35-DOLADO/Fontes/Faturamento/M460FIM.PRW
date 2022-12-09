#INCLUDE "TOPCONN.CH"

/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PONTO DE ENTRADA CHAMADA M460FIM, SE REFERE A GRAVAÇÃO APÓS (DEPOIS) DA PREPARAÇÃO DE DOCUMENTO DE SAÍDA. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
User Function M460FIM()
	Local aArea := GetArea()
	Local lRet    := .t.
	Local _cIdEnt := " "


	_cIdEnt := RetIdEnti() //RETORNA A ENTIDADE DE NF DE ACORDO COM A FILIAL.

	SpedNFeTrf("SF2",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC,_cIdEnt,"1","1","4.00",,,) // FUNÇÃO QUE TRANSMITE AUTOMÁTICA.

	MsgInfo("Nota Fiscal "+SF2->F2_SERIE+SF2->F2_DOC+" acabou de ser transmitida!!!","ATENÇÃO") //EXIBE A MENSAGEM DIZENDO QUE A NOTA FOI TRANSMITIDA.

	U_MonitNFE( SF2->F2_SERIE, SF2->F2_DOC, SF2->F2_DOC,"SF2") //EXIBE A CONSULTA NFE DIZENDO QUE A NOTA FOI TRANSMITIDA OU NÃO.

	If SF2->F2_FIMP$"S" //----> NOTA AUTORIZADA
        Processa( {|| U_zGerDanfe('SF2')}, "Impressão DANFE", "Imprimindo DANFE...", .f.)
    else
        MsgInfo("Faça a impressão da DANFE daqui alguns minutos, pois a nota fiscal "+SF2->F2_SERIE+SF2->F2_DOC+" ainda não foi autorizada na SEFAZ.","ATENÇÃO") //EXIBE A MENSAGEM DIZENDO QUE A NOTA FOI TRANSMITIDA.    
    EndIf

RestArea(aArea)

return lRet
