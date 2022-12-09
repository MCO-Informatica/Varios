#INCLUDE "Totvs.ch"  
#include "fileio.ch"
#INCLUDE "TBICONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CRPA027    º Autor ³ Renato Ruy	     º Data ³  21/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para importação de dados que serão usado para     º±±
±±º          ³ calculo do remuneração de parceiros.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CRPA027D(cEmpP,cFilP,aPedido2)

Local nX 	  := 0
Local nZ 	  := 0
Local nCont	  := 0
Local cHTML	  := ""
Local aPed	  := {}
Local dData	  := CtoD("  /  /  ")
Local oObj

Default aPedido2 := {"0"}
Default cEmpP := "01"
Default cFilP := "02"

//Abre a conexão com a empresa
RpcSetType(3)
RpcSetEnv(cEmpP,cFilP)

If Select("CRPA027D") > 0
	CRPA027D->(DbCloseArea())
EndIf

//Busco os dados referente aos últimos 32 dias dos pedidos rejeitados.
Beginsql Alias "CRPA027D"
  SELECT Z5_PEDGAR  FROM PROTHEUS.SZ5010
  WHERE
  Z5_FILIAL = ' ' AND
  Z5_DATVAL >= (to_char(sysdate-32, 'YYYYMMDD')) AND
  Z5_DATVER = ' ' AND
  Z5_STATUS = '4' AND
  D_E_L_E_T_ = ' '
Endsql

DbSelectArea("CRPA027D")
CRPA027D->(DbGoTop())

While !CRPA027D->(EOF())
    
	Begin Sequence
	oWSObj := WSIntegracaoGARERPImplService():New()
	IF oWSObj:listarTrilhasDeAuditoriaParaIdPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
																									eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
																									Val( CRPA027D->Z5_PEDGAR ) )
	
		//Ação
		//RRG - VALIDAR
		//REM - VERIFICAR
		//EMI - EMISSAO
		//RVD - REVALIDAR  
	
	    //Analiso todas as linhas da trilha e gravo.
		For nX := 1 to Len(oWSObj:oWSauditoriaInfo)
		
			
			If ValType(oWSObj:oWSauditoriaInfo[nX]:cacao) <> "U"
			    
				//Somente verifico registro de confirmação de fraude e se tem no comentario que está confirmada.
				If AllTrim(oWSObj:oWSauditoriaInfo[nX]:cacao) == "AFC" .And. "CONFIRMADA A FRAUDE" $ Upper(oWSObj:oWSauditoriaInfo[nX]:CCOMENTARIO)
					
						ZZ5->(DbSetOrder(1))
						If !ZZ5->(DbSeek(xFilial("ZZ5")+AllTrim(CRPA027D->Z5_PEDGAR)))
							ZZ5->(RecLock("ZZ5",.T.))
						Else
							ZZ5->(RecLock("ZZ5",.F.))
						Endif
							ZZ5->ZZ5_FILIAL := xFilial("ZZ5")
							ZZ5->ZZ5_PEDGAR := AllTrim(CRPA027D->Z5_PEDGAR)
							ZZ5->ZZ5_OBS	:= StrTran(Upper(oWSObj:oWSauditoriaInfo[nX]:CCOMENTARIO),"&ATILDE;","A")
							ZZ5->ZZ5_DATA	:= CtoD(SubStr(AllTrim(oWSObj:OWSAUDITORIAINFO[nX]:CDATA),4,3)+SubStr(AllTrim(oWSObj:OWSAUDITORIAINFO[nX]:CDATA),1,3)+SubStr(AllTrim(oWSObj:OWSAUDITORIAINFO[nX]:CDATA),7,4))
							//Caso não tenha voucher, gera registro na lista negativa.
							SZF->(DbSetOrder(3))
							If SZF->(DbSeek(xFilial("SZF")+AllTrim(CRPA027D->Z5_PEDGAR)))
								ZZ5->ZZ5_CODVOU := SZF->ZF_COD
								ZZ5->ZZ5_STAT	:= "2" 
							Elseif "NAO" $ StrTran(Upper(oWSObj:oWSauditoriaInfo[nX]:CCOMENTARIO),"&ATILDE;","A")
								ZZ5->ZZ5_STAT	:= "1"
							Else
								ZZ5->ZZ5_STAT	:= "3"
							EndIf
							
							//STATUS FRAUDE
							// 1 - ANALISE
							// 2 - VOUCHER
							// 3 - CONFIRMADA
							
						ZZ5->(MsUnlock())
					
					
				EndIf
				
			EndIf
				
		Next
	    
	Else
		ConOut("Não foi possível encontrar a trilha ou problema de conexão!")
	Endif
	
	DelClassIntF()
	End Sequence

	CRPA027D->(DbSkip())
EndDo

dData := DtoS(dDatabase - 31)

If Select("CRPA027D") > 0
	CRPA027D->(DbCloseArea())
EndIf

//Busco os dados referente aos últimos 32 dias dos pedidos rejeitados.
Beginsql Alias "CRPA027D"
  SELECT ZZ5_PEDGAR,
         ZZ5_DATA,
  		 ZZ5_CODVOU,
  		 CASE
  		 WHEN ZZ5_STAT = '1' THEN 'EM ANALISE'
  		 WHEN ZZ5_STAT = '2' THEN 'GEROU VOUCHER'
  		 WHEN ZZ5_STAT = '3' THEN 'FRAUDE CONFIRMADA' END STATZZ5,
  		 ZZ5_OBS 
  FROM PROTHEUS.ZZ5010
  WHERE
  ZZ5_FILIAL = ' ' AND
  ZZ5_DATA >= %Exp:dData% AND
  ZZ5_STAT IN ('1','3') AND
  D_E_L_E_T_ = ' '
Endsql

CRPA027D->(DbGoTop())

cHTML += '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
cHTML += '<html>'
cHTML += '	<head>'
cHTML += '		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />'
cHTML += '		<title>Aviso de Fraude</title>'
cHTML += '	</head>'
cHTML += '	<body>'
cHTML += '		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">'
cHTML += '			<tbody>'
cHTML += '				<tr>'
cHTML += '					<td style="padding:5px; vertical-align:middle;" valign="middle" colspan="4">'
cHTML += '						<em><span style="font-size:20px;"><font color="#F4811D" face="Arial, Helvetica, sans-serif"><strong>Aviso de Fraude</strong></font></span><br />'
cHTML += '						<font color="#02519B" face="Arial, Helvetica, sans-serif" size="3">Sistema de Gest&atilde;o</font></em>'
cHTML += '						<p>'
cHTML += '							&nbsp;</p>'
cHTML += '					</td>'
cHTML += '					<td align="right" width="210">'
cHTML += '						<img alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" width="209" /><br />'
cHTML += '						&nbsp;</td>'
cHTML += '				</tr>'
cHTML += '				<tr>'
cHTML += '					<td bgcolor="#F4811D" colspan="5" height="4" width="0">'
cHTML += '						<img alt="" height="4" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
cHTML += '				</tr>'
cHTML += '				<tr>'
cHTML += '					<td colspan="5" style="padding:5px;" width="0">'
cHTML += '						<p>'
cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Prezado(s),</font></span></span></p>'
cHTML += '						<p>'
cHTML += '							<span style="font-family:verdana,geneva,sans-serif;"><span style="font-size:14px;"><font color="#333333">Segue abaixo os dados referente as fraudes;<strong></font></span></span></p>'
cHTML += '					</td>'
cHTML += '				</tr>'
cHTML += '				<tr>'
cHTML += '					<td bgcolor="#02519B" colspan="5" height="2" width="0">'
cHTML += '						<img alt="" height="2" src="http://comunicacaocertisign.com.br/email/2015/campanha_cacb/0410/spacer.gif" width="1" /></td>'
cHTML += '				</tr>'
cHTML += '				<tr>'
cHTML += '					<td bgcolor="#02519B" width="210"><Center><b><font color="#F8F8FF">Pedido Gar		</b></Center></td>'
cHTML += '					<td bgcolor="#02519B" width="210"><Center><b><font color="#F8F8FF">Codigo Voucher	</b></Center></td>'
cHTML += '					<td bgcolor="#02519B" width="210"><Center><b><font color="#F8F8FF">Data		 		</b></Center></td>'
cHTML += '					<td bgcolor="#02519B" width="210"><Center><b><font color="#F8F8FF">Status	 		</b></Center></td>'
cHTML += '					<td bgcolor="#02519B" width="210"><Center><b><font color="#F8F8FF">Observação		</b></Center></td>'
cHTML += '				</tr>'

While !CRPA027D->(EOF())

	If Mod( nCont, 2 ) == 0

		cHTML += '				<tr>'
		cHTML += '					<td>'+CRPA027D->ZZ5_PEDGAR+'</td>'
		cHTML += '					<td>'+CRPA027D->ZZ5_CODVOU+'</td>'
		cHTML += '					<td><Center>'+DtoC(StoD(CRPA027D->ZZ5_DATA))+'</Center></td>'
		cHTML += '					<td>'+CRPA027D->STATZZ5+'</td>'
		cHTML += '					<td>'+CRPA027D->ZZ5_OBS+'</td>'
		cHTML += '				</tr>'
	
	Else
	
		cHTML += '				<tr>'
		cHTML += '					<td bgcolor="#F4811D">'+CRPA027D->ZZ5_PEDGAR+'</td>'
		cHTML += '					<td bgcolor="#F4811D">'+CRPA027D->ZZ5_CODVOU+'</td>'
		cHTML += '					<td bgcolor="#F4811D"><Center>'+DtoC(StoD(CRPA027D->ZZ5_DATA))+'</Center></td>'
		cHTML += '					<td bgcolor="#F4811D">'+CRPA027D->STATZZ5+'</td>'
		cHTML += '					<td bgcolor="#F4811D">'+CRPA027D->ZZ5_OBS+'</td>'
		cHTML += '				</tr>'
	
	EndIf
	
	nCont += 1
	
	CRPA027D->(DbSkip())
EndDo

cHTML += '				<tr>'
cHTML += '					<td colspan="5" style="padding:5px" width="0">'
cHTML += '						<p align="left">'
cHTML += '							<font color="#666666" face="Arial, Helvetica, sans-serif" size="2"><em>Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em></font></p>'
cHTML += '					</td>'
cHTML += '				</tr>'
cHTML += '			</tbody>'
cHTML += '		</table>'
cHTML += '		<p>'
cHTML += '			&nbsp;</p>'
cHTML += '	</body>'
cHTML += '</html>'


FSSendMail( ;
			AllTrim(GetMV("MV_XFRAUDE")) , ;
			'CRPA027D - Aviso de Fraude.', ;
			cHTML )

RpcClearEnv()

Return