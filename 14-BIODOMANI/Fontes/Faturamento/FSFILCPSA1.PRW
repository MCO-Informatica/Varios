#Include 'Protheus.ch'
#Include 'TopConn.ch'

//---------------------------------------------------------------------------------
// Rotina | FSFILCPSA1          | Autor | Lucas Baia          | Data | 31/08/2021			
//---------------------------------------------------------------------------------
// Descr. | Fonte Customizado para realizar um Filtro Especifíco na Consulta Padrão																		
//        | de Clientes pelo Pedido de Venda.																		
//---------------------------------------------------------------------------------
// Uso    | Biodomani Indústria e Comércio Ltda																		
//---------------------------------------------------------------------------------

User Function FSFILCPSA1()

Local cVend :=RetVend()
Local cUser := RetCodUsr()
Local cRet  :=  "@#.T.@#"

If cUser == "000054"
    cRet := "@# A1_VEND == '"+cVend+"' .OR. A1_VEND1 == '"+cVend+"' .OR. A1_VENDE == '"+cVend+"' .OR. A1_VENDE1 == '"+cVend+"'@#"
Endif

return cRet



Static Function RetVend()
Local cVend :=""

dbselectarea("SA3")
dbsetorder(1)

SA3->(DBGotop())

Do While !SA3->(Eof())

	If Alltrim(__cUserID) == Alltrim(SA3->A3_CODUSR)
		cVend := SA3->A3_COD
	Endif

	SA3->(DBSkip())

EndDo

return cVend
