#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LJ7002
// Autor 		Alexandre Dalpiaz
// Data 		10/04/2013
// Descricao  	PONTO DE ENTRADA APOS A GRAVAÇÃO DOS CUPONS FISCAIS
//				ATUALIZA CAMPOS ??_SITTRIB 
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LJ7002()
//////////////////////      
Local _cEnter := chr(13) + chr(10)

dbselectarea("SZV")  //_________________________ Tabela de Saldos da SuperPedido        
DbsetOrder(2)		 //_________________________ ZV_FILIAL + ZV_CODBAR
SET DELETED ON       //_________________________ Colocado por Ilidio em 04/02/15

_cQuery := "UPDATE SD2 "
_cQuery += _cEnter + " SET D2_LOCALIZ = '" + SL1->L1_VEND2 + "', D2_SITTRIB = "		   
_cQuery += _cEnter + " CASE RIGHT(F4_SITTRIB,2) "
_cQuery += _cEnter + " WHEN  '00'  "
_cQuery += _cEnter + " 		THEN CASE "
_cQuery += _cEnter + " 			WHEN D2_PICM = 0 "
_cQuery += _cEnter + " 				THEN '1' "
_cQuery += _cEnter + " 			ELSE"
_cQuery += _cEnter + " 				CASE WHEN SD2.D2_PICM < 10 "
_cQuery += _cEnter + " 				THEN 'T0'+REPLACE(CONVERT(VARCHAR,D2_PICM),'.','')+'0' "
_cQuery += _cEnter + " 				ELSE 'T'+CONVERT(VARCHAR,D2_PICM)+'00' "
_cQuery += _cEnter + " 			END"
_cQuery += _cEnter + " 		END	 "
_cQuery += _cEnter + " 	WHEN  '10'"
_cQuery += _cEnter + " 		THEN ''"		//??
_cQuery += _cEnter + " 	WHEN  '20'"
_cQuery += _cEnter + " 		THEN ''"		//??
_cQuery += _cEnter + " 	WHEN  '30'"
_cQuery += _cEnter + " 		THEN ''"		//??
_cQuery += _cEnter + " 	WHEN  '40'"
_cQuery += _cEnter + " 		THEN 'I1'"
_cQuery += _cEnter + " 	WHEN  '41'"
_cQuery += _cEnter + " 		THEN 'I1'"
_cQuery += _cEnter + " 	WHEN  '50'"			//??
_cQuery += _cEnter + " 		THEN ''"
_cQuery += _cEnter + " 	WHEN  '51'"			//??
_cQuery += _cEnter + " 		THEN ''"
_cQuery += _cEnter + " 	WHEN '60'"
_cQuery += _cEnter + " 		THEN 'N1'"
_cQuery += _cEnter + " 	WHEN  '70'"
_cQuery += _cEnter + " 		THEN ''"		//??
_cQuery += _cEnter + " 	WHEN '90'"
_cQuery += _cEnter + " 		THEN CASE WHEN D2_VALIMP1 = 0 AND D2_VALIMP2 = 0 AND D2_VALIMP3 = 0 AND D2_VALIMP4 = 0 AND D2_VALIMP5 = 0 AND D2_VALIMP6 = 0"
_cQuery += _cEnter + " 			THEN 'N1'"
_cQuery += _cEnter + " 			ELSE 'S0500'"
_cQuery += _cEnter + " 			END"
_cQuery += _cEnter + " 	ELSE ''	"
_cQuery += _cEnter + " 	END"

_cQuery += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK)"
_cQuery += _cEnter + " ON B1_COD 			= D2_COD"
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ 	= ''"

_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
_cQuery += _cEnter + " ON SF4.D_E_L_E_T_	= ''"
_cQuery += _cEnter + " AND F4_CODIGO = D2_TES"

_cQuery += _cEnter + " WHERE SD2.D_E_L_E_T_ = ''
_cQuery += _cEnter + " AND D2_DOC 			= '" + SF2->F2_DOC + "'"
_cQuery += _cEnter + " AND D2_SERIE 		= '" + SF2->F2_SERIE + "'"
_cQuery += _cEnter + " AND D2_FILIAL 		= '" + SF2->F2_FILIAL + "'"
_cQuery += _cEnter + " AND D2_CLIENTE 		= '" + SF2->F2_CLIENTE + "'"
_cQuery += _cEnter + " AND D2_LOJA 			= '" + SF2->F2_LOJA + "'"

nValSQL := TcSqlExec(_cQuery)

_cQuery := "UPDATE " + RetSqlName('SFT')
_cQuery += _cEnter + " SET FT_CLASFIS = D2_CLASFIS
_cQuery += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)"
_cQuery += _cEnter + " WHERE " + RetSqlName('SFT') + ".D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND FT_NFISCAL 		= D2_DOC"
_cQuery += _cEnter + " AND FT_SERIE 		= D2_SERIE"
_cQuery += _cEnter + " AND FT_FILIAL 		= D2_FILIAL"
_cQuery += _cEnter + " AND FT_ITEM 			= D2_ITEM"
_cQuery += _cEnter + " AND D2_DOC 			= '" + SF2->F2_DOC + "'"
_cQuery += _cEnter + " AND D2_SERIE 		= '" + SF2->F2_SERIE + "'"
_cQuery += _cEnter + " AND D2_FILIAL 		= '" + SF2->F2_FILIAL + "'"

nValSQL := TcSqlExec(_cQuery)                
                     
_cQuery := "UPDATE " + RetSqlName('CD2')
_cQuery += _cEnter + " SET CD2_ORIGEM 	= B1_ORIGEM"
_cQuery += _cEnter + " FROM " + RetSqlName('SB1') + " SB1 (NOLOCK)"
_cQuery += _cEnter + " WHERE B1_COD 		= CD2_CODPRO"
_cQuery += _cEnter + " AND SB1.D_E_L_E_T_ 	= ''"
_cQuery += _cEnter + " AND " + RetSqlName('CD2') + ".D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND CD2_TPMOV 		= 'S'"
_cQuery += _cEnter + " AND CD2_FILIAL 		= '" + SF2->F2_FILIAL + "'"
_cQuery += _cEnter + " AND CD2_DOC 			= '" + SF2->F2_DOC + "'"
_cQuery += _cEnter + " AND CD2_SERIE 		= '" + SF2->F2_SERIE + "'"
If SF1->F1_TIPO $ 'NCIP'
	_cQuery += _cEnter + " AND CD2_CODCLI 	= '" + SF2->F2_CLIENTE + "'"
	_cQuery += _cEnter + " AND CD2_LOJCLI 	= '" + SF2->F2_LOJA + "'"
Else
	_cQuery += _cEnter + " AND CD2_CODFOR 	= '" + SF2->F2_CLIENTE + "'"
	_cQuery += _cEnter + " AND CD2_LOJFOR 	= '" + SF2->F2_LOJA + "'"
EndIf                                    

nValSQL := TcSqlExec(_cQuery)                                  

If RecLock('SF2',.f.)
	SF2->F2_EMINFE := date()
	SF2->F2_HORNFE := left(time(),5)       
	SF2->F2_HORA   := SL1->L1_HORA
	MsUnLock()
Else
	SF2->F2_EMINFE := date()
	SF2->F2_HORNFE := left(time(),5)
	SF2->F2_HORA   := SL1->L1_HORA
	SF2->F2_VEND2  := SL1->L1_VEND2
EndIf

cHoraA	:= left(GetMv('LS_SPHRTXT'),5)  // HoraIni
cHoraB	:= right(GetMv('LS_SPHRTXT'),5) // HoraFim
nDias	:= GetMv("LS_DIASTXT",,5)

If time() > cHoraA .and.  time() < cHoraB

	For _nI := (nDias + 1) to (nDias + 5)		// 6 to 10
		_cArquivo := '\system\Integracao\SuperPedido\vendas_laselva_' + dtos(date()-_nI) + '.txt'
		If file(_cArquivo)
			fErase(_cArquivo)
		EndIf
	Next

	
	For _nI := 1 to nDias						// 5
		
		_cArquivo := '\system\Integracao\SuperPedido\vendas_laselva_' + dtos(date()-_nI) + '.txt'
		If !file(_cArquivo)
			MemoWrit(_cArquivo, _cArquivo)
// 53928891002584 CNPJ de Guarulhos
			_cQuery := "SELECT M0_CGC + '|' + RTRIM(B1_CODBAR) + '|' + RTRIM(B1_DESC) 		+ '|' + "
			_cQuery += _cEnter + " RTRIM(CONVERT(CHAR,CONVERT(DATETIME,D2_EMISSAO),111))	+ '|' + "
			_cQuery += _cEnter + " CONVERT(VARCHAR,SUM(D2_QUANT)) 							+ '|' + "
			_cQuery += _cEnter + " CONVERT(VARCHAR,B1_PRV1) 								+ '|' + "
			_cQuery += _cEnter + " CONVERT(VARCHAR,ROUND(AVG(D2_PRCVEN),2)) 				+ '|' + "
			_cQuery += _cEnter + " CONVERT(VARCHAR,ROUND(MIN(D2_PRCVEN),2)) 				+ '|' + "
			_cQuery += _cEnter + " CONVERT(VARCHAR,ROUND(MAX(D2_PRCVEN),2))					+ '|' + "
			_cQuery += _cEnter + " CONVERT(VARCHAR,ROUND(B1_PRV2,2))"
			
			_cQuery += _cEnter + " FROM " + RetSqlName('SF2') + " SF2 (NOLOCK) "
			
			_cQuery += _cEnter + " INNER JOIN  SIGAMAT SM0 (NOLOCK) ON F2_FILIAL 	= M0_CODFIL 
			_cQuery += _cEnter + " 									AND M0_CODIGO 	= '01' " 
//			_cQuery += _cEnter + " 									AND M0_CGC 	= '53928891002584' "   // Loja Guarulhos			
			
			_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SD2') + " SD2 (NOLOCK) ON  D2_FILIAL 			= F2_FILIAL "
         	_cQuery += _cEnter + " 														AND D2_DOC   		= F2_DOC "   
         	_cQuery += _cEnter + " 														AND D2_FILIAL  		= 90 " // Loja Guarulhos 
	        _cQuery += _cEnter + " 														AND D2_SERIE   		= F2_SERIE " 
	        _cQuery += _cEnter + " 														AND D2_EMISSAO  	= F2_EMISSAO "
	        _cQuery += _cEnter + " 														AND D2_ORIGLAN  	= 'LO' "  
	        _cQuery += _cEnter + " 														AND SD2.D_E_L_E_T_  = '' " 

			_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SB1') + " SB1 (NOLOCK) ON SB1.D_E_L_E_T_  	= '' " 
			_cQuery += _cEnter + "          											AND B1_COD   		= D2_COD " 
			_cQuery += _cEnter + "          											AND B1_GRUPO   		= '0003' " 
			_cQuery += _cEnter + "          											AND B1_PROC   		<> '000003' " // Descarta se for Fornecedor Clio
			
			
			_cQuery += _cEnter + " WHERE F2_EMINFE 			= '" + dtos(date()-_nI) + "'" // DATA DE EMISSAO DA NFE
			_cQuery += _cEnter + " AND F2_TIPO   			= 'N' "
			_cQuery += _cEnter + " AND F2_ESPECIE   		= 'CF' "
			_cQuery += _cEnter + " AND SF2.D_E_L_E_T_  		= '' "
			
			_cQuery += _cEnter + " GROUP BY M0_CGC, B1_CODBAR,B1_DESC, D2_EMISSAO , B1_PRV1, B1_PRV2 "
			_cQuery += _cEnter + " ORDER BY M0_CGC, B1_CODBAR "


			DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SPP', .F., .T.)
			_SPP->(dbgotop())	
//__________________________________________________________________________
// Bloco criado para subtrair os saldos restantes da SuperPedido
// que estão na tabela SZV - Ilidio Abreu - 03/02/15
  /*
While ! _SPP->(eof())
	_1c	:=	_2c	:=	_3c	:=	_4c	:=	_5c	:= "" 					//_____ CNPJ	CODBAR	DESC	EMISSÃO	QUANTIDADE         
	_nquant	:= 1												//_____ Quantidade de caracteres | 
	_c	:= ""
    for _k := 1 to len(_SPP->cField1)                                                             
   		_c:= substr(_SPP->cField1,_k,1)
   		if _c == "|"
			_nquant++
			if _nquant > 5
				exit
			endif
   			loop 			
		else
			_macro	:= "_"+alltrim(str(_nquant))+"c"    
			&_macro += _c
		endif
    next
    
    
    
//	if ! SZV->(Dbseek("  "+_2c))  							//_____ não encontra; apaga do email 
//		RECLOCK("_SPP",.f.)
//		_SPP->cField1 := " " 
//		msunlock()
//		loop
//	Endif 
	  
	if SZV->(Dbseek("  "+_2c)) .and. SZV->ZV_SALDO == 0       			   				//_____ saldo zerado; apaga do email 
		RECLOCK("_SPP",.f.)
		_SPP->cField1 := "APAGADO"+_SPP->cField1
		msunlock()
		loop
	endif      
	
	if (SZV->ZV_SALDO - val(_5c)) < 0		
		_cTexto	:= _1c+"|"+	_2c+"|"+_3c+"|"+_4c+"|"+SZV->ZV_SALDO
		reclock("_SPP",.f.)
		_SPP->cField1 := "MENOR QUE ZERO "+_cTexto+"  "+_SPP->cField1		 					//_____ quantidade no email recebe apenas a quantidade do saldo
		_cTexto	:= ""
		msunlock()
		
		reclock("SZV",.f.)
		SZV->ZV_SALDO := 0									//_____ saldo inferior a venda recebe saldo 'zero'
		SZV->(msunlock())
	Endif

	if (SZV->ZV_SALDO - _5c) >= 0		
		reclock("SZV",.f.)
		SZV->ZV_SALDO := (SZV->ZV_SALDO	- _5c)				//_____ quantidade vendida é abatida do saldo
		SZV->(msunlock())
	Endif

Enddo

//__________________________________________________________________________

     */
			_SPP->(dbgotop())
			copy to &_cArquivo SDF
			DbCloseArea()
			
			cServer   := GETMV("MV_RELSERV")
			cAccount  := AllTrim(GETMV("MV_RELACNT"))
			cPassword := AllTrim(GETMV("MV_RELAPSW"))
			cEnvia    := 'protheus@laselva.com.br'
			cAssunto  := "Vendas Laselva " + dtoc(date()-_nI)

//			cRecebe   := "elvis.bernardo@laselva.com.br;rodrigo.polini@laselva.com.br;richard.cabral@laselva.com.br;richard.mobile@terra.com.br"
			cRecebe   := GetMv('LS_SPEMTXT') 

			_cCorpo   := 'Vendas do grupo Laselva referente a ' + dtoc(date()-_nI) + _cEnter + _cEnter
			_cCorpo   += 'Email enviado automaticamente pelo sistema' + _cEnter
			_cCorpo   += 'Favor não responder'  + _cEnter + _cEnter
			_cCorpo   += 'Para alteração dos destinatários, verificar parâmetro LS_SPEMTXT' + _cEnter
			_cCorpo   += 'Para alteração do horário de geração, verificar parâmetro LS_SPHRTXT' + _cEnter
			_cCorpo	  += 'Para consultar o fonte de geração LJ7002.PRW' + _cEnter
			_cCorpo	  += 'Últimos 5 arquivos gravados em \system\Integracao\SuperPedido\vendas_laselva_AAAAMMDD.txt'

			CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
			Conout("CONNECT SMTP SERVER "+cServer+" ACCOUNT "+cAccount+" PASSWORD "+cPassword)			
			
			If lConectou
				
				If GetNewPar("MV_RELAUTH",.F.)
					_lRetAuth := MailAuth(cAccount,cPassword)
					Conout(If(_lRetAuth,"Autenticou","Não Autenticou"))
				Else
					_lRetAuth := .T.
				EndIf
				
				If _lRetAuth                           

					SEND MAIL FROM cEnvia TO cRecebe SUBJECT cAssunto BODY _cCorpo attachment _cArquivo RESULT lEnviado
					Conout("SEND MAIL FROM "+cEnvia+" TO "+cRecebe+" SUBJECT "+cAssunto+" BODY "+_cCorpo+" attachment "+_cArquivo)
					
					If !lEnviado
						cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
						GET MAIL ERROR cHtml
						Conout( "ERRO SMTP EM: " + cAssunto )
					Else
						DISCONNECT SMTP SERVER
					Endif
				Endif
			
			Else
				
				Conout( "ERRO SMTP EM: " + cAssunto )
				cHtml := "A T E N Ç Ã O! NÃO FOI POSSÍVEL CONEXÃO NO SERVIDOR DE E-MAIL"
				MsgAlert(cHtml)
				
			Endif
			
		EndIf
		
	Next
	
EndIf

Return()
  
Static Function CopiaFtp(cArqs)
Local cServidor
Local cServidor := '"ftp://edi4.biblion.com.br'
Local cLogin    :=  'ftplaselva'
Local cSenha    := 'suporte@2013'
Local cOrigem   := '\system\Integracao\SuperPedido\'
Local cDestino  := '\retorno\'
Local lRet      := .T.
Default cArqs   := 'vendas_laselva_' + dtos(date()-_nI) + '.txt'
FTPDisconnect()
If !FTPConnect( cServidor, ,cLogin, cSenha )
   APMsgInfo( 'Falha na conexão!' )
   lRet := .F.
Else
   If FTPDirChange(cOrigem)
     aArqs := FTPDIRECTORY( cArqs )
     nArqsCopy := Len(aArqs)
      If Len(aArqs) = 0
        APMsgInfo( 'Nenhum pedido encontrado no site, verificar arquivos locais' )
        lRet := .F.
      Else
        For n := 1 to Len(aArqs)
            If !FTPDOWNLOAD(cDestino+aArqs[n][1], aArqs[n][1] )
               APMsgInfo( 'Problemas ao copiar arquivo '+ aArqs[n][1] )
            Else
               If !FTPERASE( aArqs[n][1] )
                  APMsgInfo('Problemas ao apagar o arquivo ' + aArqs[n][1] )
               EndIf
            EndIf
        Next
      EndIf
   EndIf
EndIf
Return()

*/

/*
#INCLUDE "PROTHEUS.CH"
#DEFINE DEFAULT_FTP 21
#DEFINE PATH "\TESTE\"FUNCTION TESTFTP()
LOCAL ARETDIR := {}		
//TENTA SE CONECTAR AO SERVIDOR FTP EM LOCALHOST NA PORTA 21	//COM USUáRIO E SENHA ANôNIMOS
IF !FTPCONNECT( "LOCALHOST" , 21 ,"ANONYMOUS", "TEST@TEST.COM" )
	CONOUT( "NAO FOI POSSIVEL SE CONECTAR!!" )
	RETURN NIL
ENDIF   		
//TENTA REALIZAR O UPLOAD DE UM ITEM QUALQUER NO ARRAY   	
//ARMAZENA NO LOCAL INDICADO PELA CONSTANTE PATH
IF !FTPUPLOAD( PATH, ARETDIR[1][1] )
	CONOUT( "NAO FOI POSSIVEL REALIZAR O UPLOAD!!" )
	RETURN NIL
ENDIF		//TENTA DESCONECTAR DO SERVIDOR FTP
FTPDISCONNECT()
RETURN NIL
*/