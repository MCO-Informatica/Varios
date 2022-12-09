#include 'totvs.ch'

/*/{Protheus.doc} MT410BRW
Este ponto de entrada é chamado antes da apresentação da mbrowse.
Define um botão no menu do browser para defnir o reenvio de um pedido ao intelipost.
@type function
@version  12.1.33
@author elton.alves@totvs.com.br
@since 18/05/2022
/*/
user function MT410BRW() 

Local aArea     := GetArea()
Local cQuery    := ""
Local nStatus   := ""

cQuery := " UPDATE " + RetSQLName( "SC5" )
cQuery += " SET C5_XCHVNFE = SF2.F2_CHVNFE "
cQuery += " FROM " + RetSQLName( "SC5" ) + " SC5"
cQuery += " INNER JOIN " + RetSQLName( "SF2" ) + " SF2 ON SC5.C5_NOTA =  SF2.F2_DOC AND SC5.C5_SERIE = SF2.F2_SERIE "
cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SF2.D_E_L_E_T_ = ' ' "
nStatus    := TCSQLExec( cQuery )
if (nStatus < 0)
     MSGINFO(TCSQLError())
endif
TcRefresh( 'SC5' )
SC5->( dbCommit() )

cQuery := " UPDATE " + RetSQLName( "SC5" )
cQuery += " SET C5_XORDS = CB7.CB7_ORDSEP "
cQuery += " FROM " + RetSQLName( "SC5" ) + " SC5"
cQuery += " INNER JOIN " + RetSQLName( "CB7" ) + " CB7 ON SC5.C5_NOTA =  CB7.CB7_NOTA AND SC5.C5_SERIE = CB7.CB7_SERIE "
cQuery += " WHERE CB7.CB7_NOTA <> ' ' " 
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND CB7.D_E_L_E_T_ = ' ' "
nStatus    := TCSQLExec( cQuery )
if (nStatus < 0)
     MSGINFO(TCSQLError())
endif
TcRefresh( 'SC5' )
SC5->( dbCommit() )

cQuery := " UPDATE " + RetSQLName( "SC5" )
cQuery += " SET C5_XDTPROC = SZ1.Z1_DATAPRC "
cQuery += " FROM " + RetSQLName( "SC5" ) + " SC5"
cQuery += " INNER JOIN " + RetSQLName( "SZ1" ) + " SZ1 ON SC5.C5_XPEDSHP = SZ1.Z1_PEDSHPF "
cQuery += " WHERE SZ1.Z1_PEDSHPF <> ' ' " 
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SZ1.D_E_L_E_T_ = ' ' "
nStatus    := TCSQLExec( cQuery )
if (nStatus < 0)
     MSGINFO(TCSQLError())
endif
TcRefresh( 'SC5' )
SC5->( dbCommit() )

cQuery := " UPDATE " + RetSQLName( "SC5" )
cQuery += " SET C5_XHRPROC = SZ1.Z1_HORAPRC "
cQuery += " FROM " + RetSQLName( "SC5" ) + " SC5"
cQuery += " INNER JOIN " + RetSQLName( "SZ1" ) + " SZ1 ON SC5.C5_XPEDSHP = SZ1.Z1_PEDSHPF "
cQuery += " WHERE SZ1.Z1_PEDSHPF <> ' ' " 
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SZ1.D_E_L_E_T_ = ' ' "
nStatus    := TCSQLExec( cQuery )
if (nStatus < 0)
     MSGINFO(TCSQLError())
endif
TcRefresh( 'SC5' )
SC5->( dbCommit() )


aAdd( aRotina, { "Reenvia Intelipost", "U_ReenvInt()", 0, 6 } )
aAdd( aRotina, { "Atualiza Chave NFe", "U_AtualizaChave()", 0, 6 } )
aAdd( aRotina, { "Atualiza Ord. Prod.", "U_AtuOrdem()", 0, 6 } )
aAdd( aRotina, { "Atu. Data Hora Proc.", "U_Atudthrprc()", 0, 6 } )

RestArea(aArea)

return

/*/{Protheus.doc} ReenvInt
Define que o pedido deverá ser reenviado ao intelipost novamente
@type function
@version  12.1.33
@author elton.alves@totvs.com.br
@since 18/05/2022
/*/
user function ReenvInt()

	if allTrim( SC5->C5_XHTTPCD ) == '200'

		apMsgAlert( 'Este pedido já foi enviado com sucesso ao intelipost', 'Atenção' )

	else

		RecLock( 'SC5', .F. )

		SC5->C5_XINTELI := '2'

		SC5->( MsUnlock() )

		apMsgAlert( 'Flag de envio intelipost alterado para NÃO. O pedido será reenviado ao intelipost.', 'Atenção' )

		DAREZ.U_intelipost()

	end if


return


User Function AtualizaChave()

Local aArea     := GetArea()
Local cQuery    := ""
Local nStatus   := ""

cQuery := " UPDATE " + RetSQLName( "SC5" )
cQuery += " SET C5_XCHVNFE = SF2.F2_CHVNFE "
cQuery += " FROM " + RetSQLName( "SC5" ) + " SC5"
cQuery += " INNER JOIN " + RetSQLName( "SF2" ) + " SF2 ON SC5.C5_NOTA =  SF2.F2_DOC AND SC5.C5_SERIE = SF2.F2_SERIE "
cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SF2.D_E_L_E_T_ = ' ' "
nStatus    := TCSQLExec( cQuery )
if (nStatus < 0)
     MSGINFO(TCSQLError())
endif
TcRefresh( 'SC5' )
SC5->( dbCommit() )

RestArea(aArea)

Return

User Function AtuOrdem()

Local aArea     := GetArea()
Local cQuery    := ""
Local nStatus   := ""

cQuery := " UPDATE " + RetSQLName( "SC5" )
cQuery += " SET C5_XORDS = CB7.CB7_ORDSEP "
cQuery += " FROM " + RetSQLName( "SC5" ) + " SC5"
cQuery += " INNER JOIN " + RetSQLName( "CB7" ) + " CB7 ON SC5.C5_NOTA =  CB7.CB7_NOTA AND SC5.C5_SERIE = CB7.CB7_SERIE "
cQuery += " WHERE CB7.CB7_NOTA <> ' ' " 
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND CB7.D_E_L_E_T_ = ' ' "
nStatus    := TCSQLExec( cQuery )
if (nStatus < 0)
     MSGINFO(TCSQLError())
endif
TcRefresh( 'SC5' )
SC5->( dbCommit() )

RestArea(aArea)
 
Return


User Function Atudthrprc()

Local aArea     := GetArea()
Local cQuery    := ""
Local nStatus   := ""

cQuery := " UPDATE " + RetSQLName( "SC5" )
cQuery += " SET C5_XDTPROC = SZ1.Z1_DATAPRC "
cQuery += " FROM " + RetSQLName( "SC5" ) + " SC5"
cQuery += " INNER JOIN " + RetSQLName( "SZ1" ) + " SZ1 ON SC5.C5_XPEDSHP = SZ1.Z1_PEDSHPF "
cQuery += " WHERE SZ1.Z1_PEDSHPF <> ' ' " 
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SZ1.D_E_L_E_T_ = ' ' "
nStatus    := TCSQLExec( cQuery )
if (nStatus < 0)
     MSGINFO(TCSQLError())
endif
TcRefresh( 'SC5' )
SC5->( dbCommit() )

cQuery := " UPDATE " + RetSQLName( "SC5" )
cQuery += " SET C5_XHRPROC = SZ1.Z1_HORAPRC "
cQuery += " FROM " + RetSQLName( "SC5" ) + " SC5"
cQuery += " INNER JOIN " + RetSQLName( "SZ1" ) + " SZ1 ON SC5.C5_XPEDSHP = SZ1.Z1_PEDSHPF "
cQuery += " WHERE SZ1.Z1_PEDSHPF <> ' ' " 
cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
cQuery += " AND SZ1.D_E_L_E_T_ = ' ' "
nStatus    := TCSQLExec( cQuery )
if (nStatus < 0)
     MSGINFO(TCSQLError())
endif
TcRefresh( 'SC5' )
SC5->( dbCommit() )

RestArea(aArea)

Return
