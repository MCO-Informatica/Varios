#Include 'Protheus.ch'
#Include "TopConn.ch"

/* -------------------------------- */
/* Rotina para alterar os valores na tabela SN3 */
/* -------------------------------- */

User Function ManutSN3()
	Local aArea   := GetArea()

	/*Private cCadastro := "Tela de ajuste de valores de Saldos de Ativos"
	Private aRotina   := {  { "Pesquisar" , "AxPesqui"  , 0, 1 },;
		{ "Visualizar", "AxVisual"  , 0, 2 },;
		{ "Alterar"	  , "AxAltera('SN3',SN3->(RECNO()),4)"  , 0, 3 } }
*/
    SetFunName("ZMODEL1")

	If RetCodUsr() $ "000271,000141,000000,000806"
    
        U_zModel1()
        
	Else
		MsgAlert("Você não tem permissão para utilizar esta rotina!","Atenção")
	EndIf

	RestArea(aArea)

Return .T.
 