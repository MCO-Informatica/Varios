#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa º FA050GRV º Autor º Luiz Alberto     º Data º  MAR/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Funcao   º Gravação do Titulo Contas a Pagar       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso      º Personalizacao Metalacre                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA050FIN()
Local _aAreaSE2	:= SE2->(GetArea())
Local _aAreaSED	:= SED->(GetArea())
Local _aAreaSA2	:= SA2->(GetArea())
Local cPrefixo	:= SE2->E2_PREFIXO
Local cTitulo	:= SE2->E2_NUM
Local cParcela	:= SE2->E2_PARCELA
Local nRegNF    := SE2->(Recno())

If Empty(SE2->E2_TITPAI) .And. Alltrim(SE2->E2_ORIGEM) == 'FINA050' .And. !AllTrim(SE2->E2_TIPO) $ 'PA,PR,NDF,PRE'
	If RecLock("SE2", .F.)
		SE2->E2_XAPROV	:=	AllTrim(GetNewPar("MV_XFINAPR",'000040'))
		SE2->E2_XCONAP 	:=	'B'
		SE2->(MsUnlock())
	Endif	

	// Criação de controle de Alçadas
	
	U_FinAlc()          
Else

	If RecLock("SE2", .F.)
		SE2->E2_XAPROV	:=	AllTrim(GetNewPar("MV_XFINAPR",'000040'))
		SE2->E2_XCONAP 	:=	'L'
		SE2->(MsUnlock())
	Endif	

Endif

SE2->(dbGoTo(nRegNF))

// Se gerar titulos de impostos os mesmos nascem liberados então

c_UPDQry  := "  UPDATE "+RETSQLNAME("SE2")"
c_UPDQry  += "  SET E2_XAPROV  = '"+AllTrim(GetNewPar("MV_XFINAPR",'000040'))+"', "
c_UPDQry  += "      E2_XCONAP  = 'L' "
c_UPDQry  += "	WHERE E2_TITPAI = '" + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA +"' "
c_UPDQry  += "  AND E2_TIPO <> 'NF' "
c_UPDQry  += "  AND E2_FILIAL = '" + xFilial("SE2") + "' "
c_UPDQry  += "  AND D_E_L_E_T_='' "
	
TcSqlExec(c_UPDQry)
	
RestArea(_aAreaSE2)
RestArea(_aAreaSED)
RestArea(_aAreaSA2)
Return .T.