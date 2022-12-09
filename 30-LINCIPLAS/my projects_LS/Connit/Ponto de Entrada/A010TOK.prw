#Include "rwmake.ch"
#Include "Protheus.ch"
 
/*
+=========================================================+
|Programa: A010TOK |Autor: Antonio Carlos |Data: 15/07/09 |
+=========================================================+
|Descricao: PE utilizado para validação do cadastro de    |
|produtos antes da gravação                               |
+=========================================================+
|Uso: Laselva                                             |
+=========================================================+
*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function A010TOK()
///////////////////////

Local 	_lRet 	:= .T.
Local aRetUsu	:= {}

Private cCTGrpUser	:= ""
                             
If Inclui
	If !U_LS_VLCODB()
		Return(.f.)
	EndIf
EndIf

If !SX6->(DbSeek('  LS_GRP' + M->B1_GRUPO))
	RecLock('SX6',.t.)
	SX6->X6_VAR     := 'LS_GRP' + M->B1_GRUPO
	SX6->X6_TIPO    := 'C'
	SX6->X6_DESCRIC := 'Codigo dos usuario com permissao para inclusao/'
	SX6->X6_DESC1   := 'alteracao dos produtos do grupo ' + M->B1_GRUPO
	SX6->X6_PROPRI  := 'U'
	MsUnLock()
	DbSelectArea('SB1')
EndIf

If !empty(GetMv('LS_GRP' + M->B1_GRUPO))
	If !('/' + __cUserID + '/' $ '/' + GetMv('LA_PODER') + '/' + GetMv('LS_GRP' + M->B1_GRUPO))
		MsgBox('Usuario não autorizado a incluir/alterar produtos do grupo ' + M->B1_GRUPO,'ATENÇÃO!!!','ALERT')
		Return(.f.)
	EndIf
EndIf

_cB1Cod := fBuscaCpo('SB1', 5, xFilial("SB1") + M->B1_CODBAR, 'B1_COD')
If _cB1Cod <> M->B1_COD .and. !empty(_cB1Cod)
	MsgStop("Código de Barras já utilizado no produto: " + _cB1Cod + ". Favor verificar!")
	Return(.f.)
EndIf    
If M->B1_GRUPO $ GetMv("MV_GRPISEN")
	If fBuscaCpo('SF4', 1, xFilial("SF4") + M->B1_TS, 'F4_ICM') == "S"
		MsgStop("TES inválido! Para produto Isento o TES não pode calcular ICMS!")
		Return(.f.)
	EndIf
EndIf

If (altera .and. SB1->B1_MSBLQL == '1') .or. M->B1_MSBLQL == '2'                            
	U_CADP005(M->B1_COD,M->B1_DESC,M->B1_LOCPAD,M->B1_ENCALHE,M->B1_GRUPO,M->B1_PRV1,M->B1_PRV2,M->B1_EDICAO,M->B1_MSBLQL,M->B1_ORIGEM) 
EndIf
      
If _lRet .and. lCopia
	_cQuery := "SELECT Z09_FILIAL, Z09_ENDER FROM " + RetSqlName('Z09') + " (NOLOCK)"
	_cQuery += " WHERE Z09_CODPRO = '" + SB1->B1_COD + "'"
	_cQuery += " AND D_E_L_E_T_ = ''"
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_Z09', .F., .T.)
	Do While !eof()        
		RecLock('Z09',.t.)
		Z09->Z09_FILIAL := _Z09->Z09_FILIAL
		Z09->Z09_CODPRO := M->B1_COD
		Z09->Z09_CODBAR := M->B1_CODBAR
		Z09->Z09_ENDER  := _Z09->Z09_ENDER
		MsUnLock()
		DbSelectArea('_Z09')
		DbSkip()
	EndDo
	DbCloseArea()	
EndIf  

If altera .and. _lRet .and. M->B1_COD == SB1->B1_COD .and. M->B1_MSBLQL == '2' .and. SB1->B1_MSBLQL == '1'

	If !SX6->(DbSeek('  LS_MAI' + M->B1_GRUPO))
		RecLock('SX6',.t.)
		SX6->X6_VAR     := 'LS_MAI' + M->B1_GRUPO
		SX6->X6_TIPO    := 'C'
		SX6->X6_DESCRIC := 'Lista de emails para recebimento das notifica-'
		SX6->X6_DESC1   := 'coes de desbloqueio de produtos ' + M->B1_GRUPO
		SX6->X6_PROPRI  := 'U'
		MsUnLock()
		DbSelectArea('SB1')
	EndIf
	
	PswOrder(1)
	_cCopia := ''
	_cUser  := ''
	If PswSeek(substr(Embaralha(SB1->B1_USERLGI,1),3,6))
		_cCopia      := alltrim(PswRet()[1,14])
		_cUser       := alltrim(PswRet()[1,04])
	EndIf
	
	cAssunto	:= " DESBLOQUEIO DO PRODUTO " + Alltrim(M->B1_COD) + " - " + M->B1_DESC
	cPara		:= GETMV("LS_MAI" + M->B1_GRUPO)
	cMensagem	:= ""
	cPara       := alltrim(cPara) + iif(!empty(cPara),',','') + _cCopia
	cMensagem += "<TR>"
	cMensagem += "<FONT face='Verdana' size='2'<h2>Informamos o desbloqueio do produto "
	cMensagem += "<b>"+Alltrim(M->B1_COD) + " - "+Alltrim(M->B1_DESC) + ", incluido por " + iif(empty(_cUser),left(Embaralha(SB1->B1_USERLGI,1),15) ,_cUser)
	cMensagem += ' em ' + FWLeUserlg('B1_USERLGI',2) + ".</b/>  </h2>"
	If empty(GetMv('LS_MAI' + M->B1_GRUPO))
		cMensagem += "<FONT face='Verdana' size='2'<h2>Endereço de email não cadadatrado para o grupo " + M->B1_GRUPO + ". Verificar e informar ao administrador do sistema.</h2>"
	EndIf
	cMensagem += "<FONT face='Verdana' size='2'<h2>Att,</h2>"
	cMensagem += "<FONT face='Verdana' size='2'<h2>Depto. Fiscal</h2>"
    If len(alltrim(cPara)) > 1
	    U_EnvMail(cPara,cAssunto, cMensagem)
	Else
		MsgBox('Produto cadastrado por ' + _cUser + _cEnter + 'Endereço de email não cadadatrado para o grupo ' + M->B1_GRUPO + _cEnter + 'Verificar e informar ao administrador do sistema.','ATENÇÃO!!!','ALERT')
	EndIf

EndIf
Return(_lRet)
//Retorna o nome do grupo de usuarios
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function CTGrpUser(cCodGrup)
///////////////////////////////////

Local cName   := Space(15)
Local aGrupo  := {}

PswOrder(1)
IF	PswSeek(cCodGrup,.F.)
	aGrupo   := PswRet()
	cNameGrp := Upper(Alltrim(aGrupo[1,2]))
EndIF
IF cCodGrup == "******"
	cNameGrp := "Todos"
EndIF

Return(cNameGrp)


Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                
User Function MA010BUT()
////////////////////////                                                                                   
If IsInCallStack("A010DELETA")         
	_cQuery := "SELECT COUNT(*) QUANT FROM " + RetSqlName('SD1') + " (NOLOCK) WHERE D1_COD = '" + SB1->B1_COD + "' AND D_E_L_E_T_ = ''"
	DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_TRB', .F., .T.)
	_lRet := (_TRB->QUANT > 0)
 	DbCloseArea()
	If !_lRet
		_cQuery := "SELECT COUNT(*) QUANT FROM " + RetSqlName('SC6') + " (NOLOCK) WHERE C6_PRODUTO = '" + SB1->B1_COD + "' AND D_E_L_E_T_ = ''"
		DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_TRB', .F., .T.)
		_lRet := (_TRB->QUANT > 0)
		DbCloseArea()
	EndIf
	If !_lRet
		_cQuery := "SELECT COUNT(*) QUANT FROM " + RetSqlName('SC7') + " (NOLOCK) WHERE C7_PRODUTO = '" + SB1->B1_COD + "' AND D_E_L_E_T_ = ''"
		DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_TRB', .F., .T.)
		_lRet := (_TRB->QUANT > 0)
		DbCloseArea()
	EndIf
	If !_lRet
		_cQuery := "SELECT COUNT(*) QUANT FROM " + RetSqlName('SG1') + " (NOLOCK) WHERE G1_COD = '" + SB1->B1_COD + "' AND D_E_L_E_T_ = ''"
		DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_TRB', .F., .T.)
		_lRet := (_TRB->QUANT > 0)
		DbCloseArea()
	EndIf
	If !_lRet
		_cQuery := "SELECT 'UPDATE " + RetSqlName('SBZ') + " SET D_E_L_E_T_ = ''*'', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE R_E_C_N_O_ = ' + CONVERT(CHAR,R_E_C_N_O_) QUERY FROM " + RetSqlName('SBZ') + " (NOLOCK) WHERE BZ_COD = '" + SB1->B1_COD + "' AND D_E_L_E_T_  = ''"
		DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_TRB', .F., .T.)
		Do While !eof()
			TcSqlExec(_TRB->QUERY)
			DbSkip()
		EndDo
		DbCloseArea()
		TcSqlExec("UPDATE " + RetSqlName('Z09') + " SET D_E_L_E_T_ = '*' WHERE Z09_CODPRO = '" + SB1->B1_COD + "'")
	EndIf
EndIf
Return()  // deveria retornar um array com botoes para a tela de deleção do produto

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MTA010MNU()
/////////////////////////
                
aRotina[4,2] := 'U_LS010ALT'
Return()
                     
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS010ALT()
/////////////////////////


If !SX6->(DbSeek('  LS_GRP' + SB1->B1_GRUPO))
	RecLock('SX6',.t.)
	SX6->X6_VAR     := 'LS_GRP' + SB1->B1_GRUPO
	SX6->X6_TIPO    := 'C'
	SX6->X6_DESCRIC := 'Codigo dos usuario com permissao para inclusao/'
	SX6->X6_DESC1   := 'alteracao dos produtos do grupo ' + SB1->B1_GRUPO
	SX6->X6_PROPRI  := 'U'
	MsUnLock()
	DbSelectArea('SB1')
EndIf

If !empty(GetMv('LS_GRP' + SB1->B1_GRUPO))
	If !('/' + __cUserID + '/' $ '/' + GetMv('LA_PODER') + '/' + GetMv('LS_GRP' + SB1->B1_GRUPO))
		MsgBox('Usuario não autorizado a incluir/alterar produtos do grupo ' + SB1->B1_GRUPO,'ATENÇÃO!!!','ALERT')
		Return()
	EndIf
EndIf          

DbSelectArea('SB1')
cAlias := 'SB1'
nReg   := recno()
nOpc   := 4                

A010Altera(cAlias,nReg,nOpc)

Return()
