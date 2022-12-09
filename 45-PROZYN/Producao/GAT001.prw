
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGAT001    บAutor  ณNewbridge           บ Data ณ  08/08/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gatilho para calculo das datas dos processos que serใo     บฑฑ
ฑฑบ          ณ apresentados na tela de monitoramento BPM                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


USer Function GAT001(dDataEnt)            

//IF GetEnvServer() == "PROZYN_NB"        


// se possuir estoque, verificar o tempo de laudo. se o laudo for < 1 assumir entrega digitada.

CQRY := "SELECT (B2_QATU - B2_QEMP- B2_RESERVA) AS B2_SLD FROM SB2010 WHERE B2_COD = '"+acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"})]+"' AND B2_LOCAL = '"+acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LOCAL"})]+"' AND D_E_L_E_T_ = '' "
CQRY	:= ChangeQuery(CQRY)

IF SELECT("TMP")>0
TMP->(DBCLOSEAREA())
ENDIF
dbUseArea(.T.,"TOPCONN",TcGenQry(,,CQRY),"TMP",.T.,.F.)  

		nDiasLau := POsicione("SA7",1,xFilial("SA7") + M->C5_CLIENTE + M->C5_LOJACLI + acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO"})] , 'A7_ANTEMPO' )   
		nDiasProd := POsicione("SB1",1,xFilial("SB1") + acols[n][2],'B1_PE' )  
		

IF TMP->B2_SLD <= acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN"})] // primeira condi็ใo nใo possui saldo em estoque  
		

		dDataFat := dDataEnt -1                  
		dDatalauF := dDataFat
		dDatalauI:= dDataFat- nDiasLau 
		dDataIniF:=dDatalauI -1  
		dDataIniP:=  dDataIniF - nDiasProd       
		
		//Indica se ้ laudo Externo
		
		If nDiasLau > 1 
			cLauExt := "1"
		Else
			cLauExt := "2"
		Endif
		
		If dDataIniP < dDataBase + 1 
			dDtSEntg := dDataBase+(nDiasLau+nDiasProd+3)
	
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_SUGENTR"})] := Ctod(" / /   ")
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTIPROD"})] := Ctod(" / /   ")
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTFPROD"})] := Ctod(" / /   ")
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTIINSP"})] := Ctod(" / /   ")
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTFINSP"})] := Ctod(" / /   ")
		 	 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LAUEXT"})] := '' 
		 	Alert("ATENวรO !!! Produto sem Estoque!!! Nใo ้ possivel atender essa data de Entrega: "  +Dtoc(dDataEnt)+ "   Considerar a data de Entrega Sugerida: "  +Dtoc(dDtSEntg) ) 
		 	
		 	
		 	dDataEnt := dDtSEntg
		 	                                                                 
		else 			 		   
		
	
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_SUGENTR"})] := dDataEnt
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTIPROD"})] := dDataIniP
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTFPROD"})] := dDataIniF
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTIINSP"})] := dDatalauI
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTFINSP"})] := dDatalauF
		 	 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LAUEXT"})] := cLauExt

	   	EndIf      
	   	
Elseif TMP->B2_SLD >=  acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN"})] .and. nDiasLau > 0  // segunda condi็ใo possui saldo em estoque mas possui laudo especial  

		
		nDiasProd:= 0
		dDtSEntg2:=	Ctod(" / /   ")
		
		dDataFat := dDataEnt -1                  
		dDatalauF := dDataFat
		dDatalauI:= dDataFat- nDiasLau 
		//dDataIniF:=dDatalauI -1  
		//dDataIniP:=  dDataIniF - nDiasProd       
		
		//Indica se ้ laudo Externo
		
		If nDiasLau > 1 
			cLauExt := "1"
		Else
			cLauExt := "2"
		Endif
		
		If dDatalauI < dDataBase + 1 
			dDtSEntg2 := dDataBase+(nDiasLau+nDiasProd+2)
	
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_SUGENTR"})] := Ctod(" / /   ")
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTIPROD"})] := Ctod(" / /   ")
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTFPROD"})] := Ctod(" / /   ")
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTIINSP"})] := Ctod(" / /   ")
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTFINSP"})] := Ctod(" / /   ")
		 	 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LAUEXT"})] := '' 
		 	Alert("ATENวรO !!! Laudo Externo!!! Nใo serแ possivel atender essa data de Entrega: "  +Dtoc(dDataEnt)+ "   Considerar a data de Entrega Sugerida: "  +Dtoc(dDtSEntg2) ) 
		 	
		 	dDataEnt := dDtSEntg2
		 	
		else 			 		   
		
	
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_SUGENTR"})] := dDataEnt
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTIPROD"})] := Ctod(" / /   ")
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTFPROD"})] := Ctod(" / /   ")
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTIINSP"})] := dDatalauI
			 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_DTFINSP"})] := dDatalauF
		 	 acols[n,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="C6_LAUEXT"})] := cLauExt

	   	EndIf

Endif
                          
Return dDataEnt  







USer Function GAT009()  
IF GetEnvServer() == "PROZYN" .or. GetEnvServer() == "PROZYN_NB"
CQRY := "SELECT * FROM SD1010 WHERE D1_DOC = '"+M->QEK_NTFISC+"' AND D1_LOTECTL = '"+M->QEK_LOTE+"' AND D_E_L_E_T_ = '' "
CQRY	:= ChangeQuery(CQRY)

IF SELECT("TMP")>0
TMP->(DBCLOSEAREA())
ENDIF
dbUseArea(.T.,"TOPCONN",TcGenQry(,,CQRY),"TMP",.T.,.F.)
DdATA := STOD(TMP->D1_DTVALID)
 iF eMPTY(DdATA)
 DdATA :=M->QEL_DTVAL
 eNDiF 
 else
  DdATA :=M->QEL_DTVAL
 eNDIF 
 
 
RETURN  DdATA