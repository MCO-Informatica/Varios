#INCLUDE 'PROTHEUS.CH'

// ponto de entrada na inclusï¿½o da oportunidade, utilizado na inclusï¿½o do apontamento, visto que o apontamento faz exec auto da oportunidade.
// o ponto de entrada valida se o aautoCab estï¿½ preenchido, caso esteja trata-se de uma chamada via execAuto, entï¿½o, executa o envio de email.

User Function FT300ABR()

Local aCab	:= Nil 
Local cQuery 	:= ''
Local aPara 	:= {} 
//Local nOp 	:= ParamIXB[1]
local aArea 	:= getArea()
local cMailVe	:= ""
Local oModel := PARAMIXB[1]
Local oMdlAD1 := oModel:GetModel("AD1MASTER")
//Local oMdlAD5 := oModel:GetModel("AD5MASTER")
Local nOperation := oModel:GetOperation()
                    
If SuperGetMV("MV_XENVMAI") == .F.    // DESABILITA ENVIO DE EMAIL NO APONTAMENTO
	Return .T.    
EndIf                        

// acrescetada validaï¿½ï¿½o para chamada da workarea, foi necessï¿½rio pois a work ï¿½rea faz abertura da rottina de modo diferente, e apresenta error.log
If Funname() <> "FATA310"
	If Type("aAutoCab")<>"U" .And. .NOT. Funname()=="CSFA110"
		aCab := AClone(aAutoCab)
	Else
		Return .T.
	EndIf
EndIf

If nOperation == 4 .AND. ( Funname()=="FATA310" .OR. (isInCallStack("FATA310") .AND. Funname()=="FATA320" ) .OR. Funname()=="CSFA110" )

	cMailVe	:= Alltrim(GETADVFVAL("SA3","A3_EMAIL",xFilial("SA3")+M->AD5_VEND,1,''))
	
	cQuery :="SELECT R_E_C_N_O_ "
	cQuery +="FROM  "  + RetSQLName("ZCE")
	cQuery +=" WHERE ZCE_FILIAL = '"+xFilial("ZCE")+"' AND "
	cQuery +="ZCE_ESTATU = '"+AD1->AD1_STAGE+"' AND "
	cQuery +="ZCE_ESTNOV = '"+M->AD5_EVENTO+"'AND "
	cQuery +="D_E_L_E_T_ = ' ' "
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBZCE",.F.,.T.)
	
	If  !TRBZCE->(eof())
		ZCE->(dbGoTo(TRBZCE->R_E_C_N_O_ ))
		aPara:= StrtoKarr(ZCE->ZCE_EMAIl,";")
		
		IF ( ZCE->ZCE_RESOPT == "S")
	
			cMailVe	:= Alltrim(GETADVFVAL("SA3","A3_EMAIL",xFilial("SA3")+AD1->AD1_VEND,1,''))
	
			aAdd(aPara,cMailVe)
		
		ENDIF

		IF ( ZCE->ZCE_RESAPT == "S")
	
			cMailVe	:= Alltrim(GETADVFVAL("SA3","A3_EMAIL",xFilial("SA3")+M->AD5_VEND,1,''))
	
			aAdd(aPara,cMailVe)
		
		ENDIF
	
		u_EnvMail(M->AD5_EVENTO,aPara)
	Endif
	TRBZCE->(dbCloseArea())  	

	//-----------------------------------------------------------------------------------------------
	// Rotina que faz parte do fonte CSFA310, o objetivo é armazenar o estágio atual da oportunidade.
	//-----------------------------------------------------------------------------------------------
		AD1->( dbSetOrder( 1 ) )
		AD1->( dbSeek( xFilial( 'AD1' ) + M->AD5_NROPOR ) )
		U_A310Arm( AD1->AD1_STAGE )
		
		
EndIf

RestArea(aArea)

Return .T.