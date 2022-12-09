#include "PROTHEUS.CH"
#include "APWEBEX.CH"
#include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSWF002   	ºAutor  ³RENATO RUY      º Data ³  05/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³FUNCAO PARA DISPARO DE EMAIL INFORMANDO O VENCIMENTO DE     º±±
±±º          ³CONTRATOS.                                                  º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CERTISIGN                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CSJB002()

Local cDest 	:= ""
Local cRemet	:= ""
Local cAssunto	:= ""
Local cMensagem	:= ""
Local cAnexo	:= ""
Local nCount	:= 1

RPCSETTYPE(3)                                               
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02" MODULO "GCT" 	

cRemet := "contratos@certisign.com.br"
cDest  := AllTrim(GetMV("MV_CSJB02"))

cAssunto := "Contratos Vencidos ou a Vencer"  

BeginSql Alias "TTRB"
	Column CN9_DTINIC	As Date
	Column CN9_DTFIM	As Date
	Column CN9_DTASSI	As Date
	
SELECT  CASE WHEN CN9_FILIAL = '01' THEN 'RJ'
        WHEN CN9_FILIAL = '02' THEN 'SP'
        ELSE CN9_FILIAL
        END FILIAL,
        CN9_NUMERO,
        CN9_REVISA,
        CN9_CLIENT,
        CN9_LOJACL,
        A1_NOME,
        CN9_DTINIC,
        CN9_DTFIM,
        CN9_DTASSI,
        CN9_VLINI,
        CN9_SALDO
FROM %Table:CN9% CN9
LEFT JOIN %Table:SA1% SA1 ON A1_COD = CN9_CLIENT AND A1_LOJA = CN9_LOJACL AND SA1.%NOTDEL%
WHERE
CN9_SITUAC = '05' AND
CN9_NUMERO NOT IN (SELECT CN9_NUMERO FROM PROTHEUS.CN9010 CN9B WHERE CN9_REVISA > ' ' AND CN9B.D_E_L_E_T_ = ' ') AND
CN9_DTFIM <= %Exp:dtos(dDataBase)% AND
CN9.%NOTDEL%

EndSql

DbSelectArea("TTRB")

//Monta Cabeçalho
cMensagem := "<Html><body><TABLE border=1 cellspacing=0 cellpadding=2 bordercolor='666633'>"
cMensagem += "<TR><TD BGCOLOR=#6495ED>Filial</TD><TD BGCOLOR=#6495ED>Contrato</TD>"
cMensagem += "<TD BGCOLOR=#6495ED>Revisão</TD><TD BGCOLOR=#6495ED>Cod.Cliente</TD>"
cMensagem += "<TD BGCOLOR=#6495ED>Loja Cliente</TD><TD BGCOLOR=#6495ED>Razão Social</TD>"
cMensagem += "<TD BGCOLOR=#6495ED>Dt.Início</TD><TD BGCOLOR=#6495ED>Dt.Fim</TD>"
cMensagem += "<TD BGCOLOR=#6495ED>Dt.Assinatura</TD><TD BGCOLOR=#6495ED>Valor Inicial</TD>"
cMensagem += "<TD BGCOLOR=#6495ED>Saldo</TD></TR>"

While !EOF("TTRB")

If Mod(nCount,2) == 1

cMensagem += "<TR><TD>"+TTRB->FILIAL+"</TD><TD>"+TTRB->CN9_NUMERO+"</TD>"
cMensagem += "<TD>"+TTRB->CN9_REVISA+"</TD><TD>"+TTRB->CN9_CLIENT+"</TD>"
cMensagem += "<TD>"+TTRB->CN9_LOJACL+"</TD><TD>"+TTRB->A1_NOME+"</TD>"
cMensagem += "<TD>"+DtoC(TTRB->CN9_DTINIC)+"</TD><TD>"+DtoC(TTRB->CN9_DTFIM)+"</TD>"
cMensagem += "<TD>"+DtoC(TTRB->CN9_DTASSI)+"</TD><TD>"+Transform(TTRB->CN9_VLINI,"@E 999,999,999.99")+"</TD>"
cMensagem += "<TD>"+Transform(TTRB->CN9_SALDO,"@E 999,999,999.99")+"</TD></TR>"

Else

cMensagem += "<TR><TD BGCOLOR=#6495ED>"+TTRB->FILIAL+"</TD><TD BGCOLOR=#6495ED>"+TTRB->CN9_NUMERO+"</TD>"
cMensagem += "<TD BGCOLOR=#6495ED>"+TTRB->CN9_REVISA+"</TD><TD BGCOLOR=#6495ED>"+TTRB->CN9_CLIENT+"</TD>"
cMensagem += "<TD BGCOLOR=#6495ED>"+TTRB->CN9_LOJACL+"</TD><TD BGCOLOR=#6495ED>"+TTRB->A1_NOME+"</TD>"
cMensagem += "<TD BGCOLOR=#6495ED>"+DtoC(TTRB->CN9_DTINIC)+"</TD><TD BGCOLOR=#6495ED>"+DtoC(TTRB->CN9_DTFIM)+"</TD>"
cMensagem += "<TD BGCOLOR=#6495ED>"+DtoC(TTRB->CN9_DTASSI)+"</TD><TD BGCOLOR=#6495ED>"+Transform(TTRB->CN9_VLINI,"@E 999,999,999.99")+"</TD>"
cMensagem += "<TD BGCOLOR=#6495ED>"+Transform(TTRB->CN9_SALDO,"@E 999,999,999.99")+"</TD></TR>"

EndIf

nCount += 1

DbSelectArea("TTRB")
DbSkip()
EndDo

cMensagem += "</BODY></HTML>"

U_CSWF001( cRemet , cDest , cAssunto , cMensagem, "" )

RESET ENVIRONMENT

RETURN ()