#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CRPR030    �Autor  � Tatiana Pontes     � Data � 08/11/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Impress�o de Saldos de Certificados.				          ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CRPR030()

	Local oReport              
	Local cTitulo := "Saldo Mensal de Certificados Verificados"
	LOcal aCpos := GetCpos("SZV")
	If Len(aCpos)>0
		oReport:= ReportDef(aCpos,cTitulo)
		oReport:PrintDialog()
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ReportDef  �Autor  � Tatiana Pontes     � Data � 08/11/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Impress�o de Saldos de Certificados 				          ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                 

Static Function ReportDef(aCpos,cTitulo)

	Local oReport 
	Local oSection1
	Local oCell         
	Local aOrdem := {}
	Local nX        
	Local cPergunte	:= "CRPR030"
	
	AtuSx1(cPergunte)
	Pergunte(cPergunte,.F.)      
	
	oReport:= TReport():New(cPergunte,cTitulo,cPergunte, {|oReport| ReportPrint(oReport,aCpos)},cTitulo)
	oReport:SetTotalInLine(.F.)
	oReport:SetLandScape()
	
	oSection1 := TRSection():New(oReport,cTitulo,{},aOrdem) 
	oSection1 :SetTotalInLine(.F.)                                
	
	For nX:=1 to Len(aCpos)                              
		TRCell():New(oSection1,	aCpos[nX],"",SZV->(RetTitle(aCpos[nX])),PesqPict("SZV",aCpos[nX]),IIf(aCpos[nX]=="ZV_SALANO",4,Tamsx3(aCpos[nX])[1]),,) 
	Next nX

Return(oReport)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ReportPrint � Autor � Tatiana Pontes    � Data � 08/11/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Impress�o de Saldos de Certificados				          ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportPrint(oReport,aCpos)

	Local oSection1 := oReport:Section(1) 
	Local nOrdem    := oReport:Section(1):GetOrder() 
	Local nX		:= 0
	Local nY		:= 0
	Local cQuery	:= ""
	
	cQuery := "SELECT * FROM "+RetSqlName("SZV")+" SZV "
	cQuery += "			WHERE 	SZV.D_E_L_E_T_ = '' "
	cQuery += "				AND	SZV.ZV_CODENT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += "				AND	SZV.ZV_SALANO BETWEEN "+StrZero(MV_PAR03,4)+" AND "+StrZero(MV_PAR04,4)+" "
	cQuery += "			ORDER BY SZV.ZV_CODENT "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
	
	oReport:SetMeter(TRB->(RecCount()))
	Do While !TRB->(Eof())	
		// Se cancelado pelo usuario                            	     
		If oReport:Cancel()
			Exit			
		Else	
			For nX:=1 to Len(aCpos)                                                
				oSection1:Cell(aCpos[nX]):SetValue(TRB->&(aCpos[nX]))				
			Next nX
			oSection1:Init() 
			oSection1:PrintLine()
		 EndIf
		 TRB->(dbSkip())
	EndDo	           
	TRB->(dbCloseArea())
	oSection1:Finish() 
				
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AtuSx1     � Autor � Tatiana Pontes     � Data � 08/11/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza��o dos SX1.								          ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                     

Static Function AtuSx1(cPerg)

	Local aHlpPor := {}
	
	aHlpPor := {}
	Aadd( aHlpPor, ""	)
	Aadd( aHlpPor, ""	)
	PutSx1(cPerg,	"01","Entidade de?","","","mv_ch1","C",TamSX3("ZV_CODENT")[1],0,1,;   
					"G","","SZ3","","S","mv_par01","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)
	
	aHlpPor := {}
	Aadd( aHlpPor, ""	)
	Aadd( aHlpPor, ""		)
	PutSx1(cPerg,	"02","Entidade at�?","","","mv_ch2","C",TamSX3("ZV_CODENT")[1],0,1,;   
					"G","","SZ3","","S","mv_par02","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)
	
	aHlpPor := {}
	Aadd( aHlpPor, ""	)
	Aadd( aHlpPor, ""	)
	PutSx1(cPerg,	"03","Ano de?","","","mv_ch3","N",TamSX3("ZV_SALANO")[1],0,1,;   
					"G","","","","S","mv_par03","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)
	
	aHlpPor := {}
	Aadd( aHlpPor, ""	)
	Aadd( aHlpPor, ""		)
	PutSx1(cPerg,	"04","Ano at�?","","","mv_ch4","N",TamSX3("ZV_SALANO")[1],0,1,;   
					"G","","","","S","mv_par04","","","","","","","","","","","","","","","","",aHlpPor,aHlpPor,aHlpPor)
	
Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GetCpos    �Autor  � Tatiana Pontes     � Data � 08/11/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Composicao dos campos a serem impressos.			          ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GetCpos(cAlias) 

	Local aCpos := {}
	
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cAlias)) 
	Do While !SX3->(Eof()) .And. SX3->X3_ARQUIVO==cAlias
		If SX3->X3_USADO=="���������������" .And. SX3->X3_CAMPO <> "ZV_LOGALT" .AND. SX3->X3_CAMPO <> "ZV_CATPROD" .AND. SX3->X3_CAMPO <> "ZV_CATDESC"
			aAdd(aCpos,SX3->X3_CAMPO)
		EndIf
		SX3->(dbSkip())
	EndDo
	
Return aCpos
