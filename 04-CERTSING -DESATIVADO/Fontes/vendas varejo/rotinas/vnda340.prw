#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNDA340   ºAutor  ³Darcio R. Sporl     º Data ³  31/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte criado para selecinar os títulos baixados de compras  º±±
±±º          ³do gar para enviar ao hub que repassra ao GAR liberando a   º±±
±±º          ³validação do pedido                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Opvs x Certisign                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                      
User Function VNDA340(aParSch)
Local cQuery	:= ""
Local aRecTit	:= {}
Local aRecPed	:= {}
Local nI		:= 0                      
Local cJobEmp	:= aParSch[1]
Local cJobFil	:= aParSch[2]
Local _lJob 	:= (Select('SX6')==0)
Local cDataProc := ""        
Local cNatNCC	:= ""

If _lJob
	RpcSetType(3)
	RpcSetEnv(cJobEmp, cJobFil)
EndIf
                     
cDataProc := SuperGetMV( "MV_X340DTP",, "" )
cNatNCC	  := SuperGetMV( "MV_X340NAT",, "" )

If Empty( cDataProc )
	cDataProc := "20120914"
EndIf	             

Conout( "VNDA340 - Montando a query - " + Time() )

cQuery := "SELECT SC5.C5_XNPSITE,SC5.C5_CHVBPAG, MAX(SE1.R_E_C_N_O_) RECSE1, MAX(SC5.R_E_C_N_O_) RECSC5  "
cQuery += "FROM  "+RetSqlName("SC5")+" SC5   "
cQuery += "INNER JOIN   "+RetSqlName("SE1")+"  SE1 ON   "
cQuery += "  SE1.E1_FILIAL = '"+xFilial("SE1")+"' AND   "
cQuery += "  SE1.E1_XNPSITE = SC5.C5_XNPSITE  AND " //SE1.E1_PEDGAR = SC5.C5_CHVBPAG AND "//Alterado por giovanni em 24/11/2016
cQuery += "  SE1.E1_EMISSAO > '" + cDataProc + "' AND " //Incluído a pedido do Sr. Giovanni em 20/09/2012
cQuery += "  SE1.E1_XFLAGEN = ' ' AND   "
cQuery += "  SE1.E1_TIPO = 'NCC' AND   " //Incluido por giovanni em 24/11/2016. Soemente NCC
cQuery += FilNatQry( cNatNCC )
cQuery += "  SE1.D_E_L_E_T_ = ' '   " 
cQuery += "WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"'   "
cQuery += "  AND SC5.C5_CHVBPAG > '0'   "
cQuery += "  AND SC5.C5_XNPSITE > '0'   "
cQuery += "  AND SC5.C5_TIPMOV  IN ('1','4','7') "  //Somente boletos e Débito em Conta
//cQuery += "  AND SC5.C5_EMISSAO > '" + cDataProc + "' " //Excluído a pedido do Sr. Giovanni em 25/09/2014
cQuery += "  AND ROWNUM <= 400  "
cQuery += "  AND SC5.D_E_L_E_T_ = ' ' "   
cQuery += "GROUP BY SC5.C5_XNPSITE,SC5.C5_CHVBPAG  "
cQuery += "UNION "
cQuery += "SELECT SC5.C5_XNPSITE,SC5.C5_XPEDORI, MAX(SE1.R_E_C_N_O_) RECSE1, MAX(SC5.R_E_C_N_O_) RECSC5  "
cQuery += "FROM  "+RetSqlName("SC5")+" SC5   "
cQuery += "INNER JOIN   "+RetSqlName("SE1")+"  SE1 ON   "
cQuery += "  SE1.E1_FILIAL = '"+xFilial("SE1")+"' AND   "
cQuery += "  SE1.E1_XNPSITE = SC5.C5_XNPSITE AND "
cQuery += "  SE1.E1_EMISSAO > '" + cDataProc + "'  AND  "
cQuery += "  SE1.E1_XFLAGEN = ' ' AND   "
cQuery += FilNatQry( cNatNCC )
cQuery += "  SE1.D_E_L_E_T_ = ' '   "
cQuery += "WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"'   "
cQuery += "  AND SC5.C5_XPEDORI > ' '   "
cQuery += "  AND SC5.C5_EMISSAO >'" + cDataProc + "'  "
cQuery += "  AND SC5.C5_XORIGPV IN ('7','8','9','0') " //AND SC5.C5_XORIGPV >= '7' // Alterado por giovanni em 24/11/2016
cQuery += "  AND ROWNUM <= 100 "
cQuery += "  AND SC5.D_E_L_E_T_ = ' '   "
cQuery += "GROUP BY SC5.C5_XNPSITE,SC5.C5_XPEDORI "
                                                



cQuery := ChangeQuery(cQuery)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYTRB",.F.,.T.)
DbSelectArea("QRYTRB")

Conout( "VNDA340 - Entrando no retorno da query - " + Time() )

Do While QRYTRB->( !EoF() )
          
	aRecTit := {}
	aRecPed := {}

	AAdd( aRecTit, QRYTRB->RECSE1 )
	AAdd( aRecPed, QRYTRB->RECSC5 ) 

	If U_VNDA481( aRecPed, aRecTit, "Liberação de Pagamento Automática referente Recebimento do Valor devido" )

		TcSqlExec(  "UPDATE "+ RetSqlName("SE1") + ;
					"   SET E1_XFLAGEN = 'X' " + ;
					"   WHERE " + ;
					"      E1_FILIAL = '" + xFilial("SE1") + "' AND " + ;
					"      E1_XNPSITE = '"+ Alltrim( QRYTRB->C5_XNPSITE ) + "' AND " + ;
					"      D_E_L_E_T_ = ' ' " )
					
	EndIf

	QRYTRB->( dbSkip() )
	
EndDo

DbSelectArea("QRYTRB")
QRYTRB->( DbCloseArea() )                                  

Conout( "VNDA340 - Processamento da query finalizado - " + Time() )

Return


/******************************************************************************
Rotina....: FilNatQry
Descricao.: Retorna clausula where para query de consulta de títulos x pedidos
Parametros: cNatNcc - String com as naturezas dos títulos para desconsiderar
Uso.......: VNDA340 - Certisign
******************************************************************************/
Static Function FilNatQry( cNatNCC )

Local cRet := ""
        
If ! Empty( cNatNCC )
                        
	cNatNCC := FormatIn( cNatNCC, "/" )
	
	If At( ",", cNatNCC ) > 0
		cRet += " SE1.E1_NATUREZ NOT IN " + cNatNCC + " AND "
	Else                               
		cNatNCC	:= StrTran( cNatNCC, "(", "" )
		cNatNCC	:= StrTran( cNatNCC, ")", "" )
		cRet	:= " SE1.E1_NATUREZ <> " + cNatNCC + " AND "
	EndIf		                          

	Conout( "VNDA340 - Filtro por natureza ativado - " + cNatNCC + " - " + Time() )

EndIf
	
Return cRet