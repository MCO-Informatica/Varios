#Include 'Totvs.ch'
#Include 'Protheus.ch'

Static cPA8_ret := Space(10)

//-------------------------------------------------------------------------
// Rotina | CSPA8BOX     | Autor | Rafael Beghini     | Data | 23.07.2019
//-------------------------------------------------------------------------
// Descr. | Consulta padrão para campos da PA8
//        | É executado através do F3 dos campos
//-------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital.
//-------------------------------------------------------------------------
User Function CSPA8BOX()
	Local aProd   	:= {}
	Local cSQL    	:= ''
	Local cTRB    	:= ''
	Local cRet		:= ''
	Local cField	:= ReadVar()
	Local cCampo	:= ''
	Local cX3_Tit	:= ''
	Local lRet		:= .T.
	Local nOpc		:= 0
	Local oDlg
	Local oLbx
	Local oPnlAll
	Local oPnlBot
	Local oConfirm
	Local oCancel
	
	Private cCadastro := '[CSPA8BOX] - Dados PA8'
	
	IF cField == 'M->PA8_AC'
		cCampo := '01'
	ElseIF cField == 'M->PA8_SEG'
		cCampo := '02'
	ElseIF cField == 'M->PA8_CADEIA'
		cCampo := '03'
	ElseIF cField == 'M->PA8_INDICA'
		cCampo := '04'
	ElseIF cField == 'M->PA8_VARIAC'
		cCampo := '05'
	ElseIF cField == 'M->PA8_VALIDA'
		cCampo := '06'
	ElseIF cField == 'M->PA8_MIDIA'
		cCampo := '07'
	ElseIF cField == 'M->PA8_TPVALI'
		cCampo := '08'
	EndIF
	
	IF Empty( cCampo )
		Return( lRet )
	EndIF
	
	SX3->( dbSetOrder( 2 ) )
	If SX3->( dbSeek( Substr(cField,4) ) )
		cX3_Tit := ' - ' + Alltrim( SX3->X3_TITULO )
	EndIF
	
	//-- Construção da Query.
	cSQL += " SELECT X5_DESCRI, PBZ_COD, PBZ_DESC " + CRLF
	cSQL += " FROM " + RetSqlName('PBZ') + " PBZ " + CRLF
	cSQL += " 	INNER JOIN " + RetSqlName('SX5') + " SX5 " + CRLF
	cSQL += " 		ON SX5.D_E_L_E_T_= ' ' " + CRLF
	cSQL += "			AND X5_FILIAL = PBZ_FILIAL " + CRLF
	cSQL += "			AND X5_TABELA = 'ZL' " + CRLF
	cSQL += "			AND X5_CHAVE = PBZ_CATEG " + CRLF
	cSQL += "WHERE PBZ.D_E_L_E_T_= ' ' " + CRLF
	cSQL += "AND PBZ_FILIAL = ' ' " + CRLF
	cSQL += "AND PBZ_CATEG = '" + cCampo + "' " + CRLF
	cSQL += "ORDER  BY PBZ.R_E_C_N_O_  " + CRLF

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	
	FWMsgRun(,{|| PLSQuery( cSQL, cTRB )},,'Buscando os dados, aguarde...')
	
	If (cTRB)->( BOF() .And. EOF() )
		MsgInfo('Não foi possível encontrar registros de produtos.', cCadastro + cX3_Tit)
		Return( lRet )
	Else
		While .NOT. (cTRB)->( EOF() )
			(cTRB)->( AAdd( aProd, { PBZ_COD, PBZ_DESC } ) )
			(cTRB)->( dbSkip() )
		End
	Endif
	(cTRB)->(dbCloseArea())
	FErase( cTRB + GetDBExtension() )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro + cX3_Tit FROM 0,0 TO 308,770 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
	   oDlg:lEscClose := .F.
		
	   oPnlAll := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
	   oPnlAll:Align := CONTROL_ALIGN_ALLCLIENT
		
	   oPnlBot := TPanel():New(0,0,'',oDlg,NIL,.F.,,,,0,14,.F.,.T.)
	   oPnlBot:Align := CONTROL_ALIGN_BOTTOM
		
	   oLbx := TwBrowse():New(0,0,1000,1020,,{'Código','Descrição'},,oPnlAll,,,,,,,,,,,,.F.,,.T.,,.F.)
	   oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	   oLbx:SetArray( aProd )
	   oLbx:bLine := {|| { aProd[oLbx:nAt,1], aProd[oLbx:nAt,2] } }

	   oLbx:bLDblClick := {|| cRet := aProd[oLbx:nAt,1], nOpc := 1,oDlg:End() }
	   
	   @ 1,1  BUTTON oConfirm PROMPT 'Confirmar' SIZE 40,11 PIXEL OF oPnlBot ACTION { || cRet := aProd[oLbx:nAt,1], nOpc := 1, oDlg:End() }
	   @ 1,44 BUTTON oCancel  PROMPT 'Sair'      SIZE 40,11 PIXEL OF oPnlBot ACTION { || oDlg:End(), lRet := .F. } 
	
	ACTIVATE MSDIALOG oDlg CENTER
	
	IF nOpc == 1
		cPA8_ret := cRet	
	EndIF	
	
Return( lRet )

User Function CSPA8RET()
Return(cPA8_ret)