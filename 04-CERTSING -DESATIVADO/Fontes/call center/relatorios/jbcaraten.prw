#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJbCarAten บAutor  ณRene Lopes          บ Data ณ  05/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para gera็ใo de carga TXT                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*
Para que o JOB Funcione e necess๏ฟฝrio criar a seguintes linhas no SERVER respons๏ฟฝvel pelaexecucao do
JOB:
[TXT_GAR]
Enable=1 
Main=u_GARA180
Environment=CERTISIGN_NEW
JobEmp=01
JobFil=02

Tambem e necessario se certificar se o mesmo esta na chave [ONSTART] de acordo exemplo
[ONSTART]
Jobs=TXT_GAR
RefreshRate=60
*/
User Function JbCarAten(aParSch)
	Local aRET := {}
	Local aPAR := {}
	Private cJobEmp	:= Iif( aParSch == NIL, '01', aParSch[ 1 ] )	
	Private cJobFil	:= Iif( aParSch == NIL, '02', aParSch[ 2 ] )
	Private _lJob 	:= (Select('SX6')==0)

	Conout("Job JbCarAten - Begin Emp("+cJobEmp+"/"+cJobFil+")" )
	If _lJob
		RpcSetType(2)
		RpcSetEnv(cJobEmp, cJobFil)
		A010Proc()
	Else
		aAdd( aPAR, {1, "Data de"	 , Ctod(Space(8)), "","",""   ,"",0,.T.})
		aAdd( aPAR, {1, "Data ate"	 , Ctod(Space(8)), "","",""   ,"",0,.T.})
		IF ParamBox(aPAR,"Atendimento SAC",@aRET)
			A010Proc( aRET )
		EndIF
	EndIF
	Conout("Job JbCarAten - End Begin Emp("+cJobEmp+"/"+cJobFil+")" )
Return

Static Function A010Proc( aRET )
	Local cTime :=  time()
	Local _cSQL 	:= ""
	Local cFileOut  := ""
	Local nHandle	:= -1 
	Local cValor	:= ""
	Local cHrExec	:= ""    
	Local lForce    := .f.

	Default aRET := {}

	nDiasAnt 	:=  GetNewPar("MV_GARTXTD", 0) 

	While !File("\pedidosfaturados\atendimento_sac_"+Dtos(DATE())+".txt")
	
		Conout("Job JbCarAten - EXECUTE Emp("+cJobEmp+"/"+cJobFil+")" )
	    
	      _cSQL:="SELECT " 
	  	  _cSQL+="ADE_CODIGO AS Protocolo, "
	  	  _cSQL+="ADE_DATA   AS DT_Abertura_Protocolo, "
	  	  _cSQL+="ADE_HORA AS HR_Abertura, "
	  	  _cSQL+="C5_EMISSAO AS Emissao_Pedido, "
	  	  _cSQL+="D2_EMISSAO  AS Emissao_Nota_Fiscal, "
	  	  _cSQL+="ADE_XSTATG AS STATUS_GAR, "
	  	  _cSQL+="ADE_PEDGAR AS Pedido_GAR, "
	  	  _cSQL+="ADE_OPERAD AS Analista, "
	  	  _cSQL+="U7_NOME    AS Nome_Analista, "
	  	  _cSQL+="ADE_GRUPO  AS Equipe, "
	  	  _cSQL+="U0_NOME    AS NOME_EQUIPE "
		  _cSQL+="FROM "
		  _cSQL+=""+RetSqlName("SD2")+" SD2 ,"+RetSqlName("SC6")+ " SC6"
		  _cSQL+=" LEFT OUTER JOIN " +RetSqlName("SC5")+ " SC5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND SC5.D_E_L_E_T_<>'*' "
		  _cSQL+=", "+RetSqlName("SF4")+" SF4"
		  _cSQL+=", "+RetSqlName("ADE")+" ADE "
		  _cSQL+="LEFT OUTER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = ADE.ADE_FILIAL AND SB1.B1_COD = ADE.ADE_CODSB1 AND SB1.D_E_L_E_T_<>'*' "
		  _cSQL+="LEFT OUTER JOIN "+RetSqlName("SUL")+" SUL ON SUL.UL_TPCOMUN = ADE.ADE_TIPO AND SUL.D_E_L_E_T_<>'*' " 
		  _cSQL+="LEFT OUTER JOIN "+RetSqlName("SU7")+" SU7 ON SU7.U7_COD = ADE.ADE_OPERAD AND SU7.D_E_L_E_T_<>'*' "
		  _cSQL+="LEFT OUTER JOIN "+RetSqlName("SU0")+" SU0 ON SU0.U0_CODIGO = ADE.ADE_GRUPO AND SU0.D_E_L_E_T_<>'*' "
	      _cSQL+="WHERE "
	      _cSQL+="D2_FILIAL  = '"+xFilial("SD2")+"' AND "
	      IF _lJob
			_cSQL+="D2_EMISSAO >= '"+DtoS(dDataBase-nDiasAnt)+"' AND "
			_cSQL+="D2_EMISSAO <='"+DtoS(dDataBase)+"' AND "
		  Else
		  	_cSQL+= "d2_emissao >= '"+ dTos( aRET[1] ) +"' AND d2_emissao <= '"+ dTos( aRET[2] ) +"' AND " + CRLF
	  	  EndIF
		  _cSQL+="C6_FILIAL = '"+xFilial("SC6")+"' AND "
	  	  _cSQL+="C6_NUM    = D2_PEDIDO AND "
	  	  _cSQL+="C6_ITEM   = D2_ITEMPV AND "
	  	  _cSQL+="C6_PEDGAR <> ' '      AND "
	  	  _cSQL+="C6_XOPER <> '53'      AND "
	  	  _cSQL+="F4_CODIGO = D2_TES    AND "
	  	  _cSQL+="F4_DUPLIC = 'S'       AND "
	  	  _cSQL+="ADE_FILIAL = '"+xFilial("ADE")+"' AND "
	  	  _cSQL+="ADE_PEDGAR = C6_PEDGAR AND "
	  	  _cSQL+="ADE_PEDGAR <> ' '      AND "
	  	  _cSQL+="ADE_GRUPO = '42'       AND "
	  	  _cSQL+="SD2.D_E_L_E_T_ <> '*' AND "
	  	  _cSQL+="SC6.D_E_L_E_T_ <> '*' AND "
	  	  _cSQL+="SF4.D_E_L_E_T_ <> '*' AND "
	  	  _cSQL+="ADE.D_E_L_E_T_ <> '*'     "
	  	  _cSQL+="GROUP BY "
	      _cSQL+="ADE_CODIGO, ADE_DATA, ADE_HORA, C5_EMISSAO, D2_EMISSAO, ADE_XSTATG, ADE_PEDGAR, " 
	 	  _cSQL+="ADE_OPERAD,U7_NOME,  ADE_GRUPO,  U0_NOME "
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),"TRBATEND",.F.,.T.)
			
			//Path da pasta onde os arquivos gerados serao salvos \\192.168.16.131\t$\Totvs\Protheus_Data10\pedidosfaturados	
			cFileOut := "\pedidosfaturados\atendimento_sac_"+Dtos(DdataBase)+".txt"
			nHandle := FCREATE(cFileOut)
		
			cProtoc := " "
			cAbertu := " "
			cHrAbert:= " "
			cStatus := " "
			cPedGar := " "
			cCodAna := " "  
			cAnalis := " " 
			cNomeAn := " " 
			cEquipe := " " 
			cEmisPed:= " " 
			cEmisNF := " " 
	 
	 If nHandle != -1	
					
	    While TRBATEND->(!Eof())
	   
	 		
			cProtoc := PADR(TRBATEND->Protocolo,7)
			cAbertu := TRBATEND->DT_Abertura_Protocolo  
			cAbertu := SUBSTRING(cAbertu,7,2)+"/"+SUBSTRING(cAbertu,5,2)+"/"+SUBSTRING(cAbertu,1,4)
			cAbertu := PADR(cAbertu,11)  
			cHrAbert:= PADR(TRBATEND->HR_Abertura,6)
			cStatus := PADR(TRBATEND->STATUS_GAR,31)
			cPedGar := PADR(TRBATEND->Pedido_GAR,11) 
			cCodAna := PADR(TRBATEND->Analista,7)
			cAnalis := PADR(TRBATEND->Nome_Analista,41) 
			cNomeAn := PADR(TRBATEND->Equipe,3) 
			cEquipe := PADR(TRBATEND->NOME_EQUIPE,81)  
			cEmisPed:= TRBATEND->Emissao_Pedido   
			cEmisPed:= SUBSTRING(cEmisPed,7,2)+"/"+SUBSTRING(cEmisPed,5,2)+"/"+SUBSTRING(cEmisPed,1,4) 
			cEmisPed:= PADR(cEmisPed,11)       
			cEmisNF := TRBATEND->Emissao_Nota_Fiscal 
			cEmisNF := SUBSTRING(cEmisNF,7,2)+"/"+SUBSTRING(cEmisNF,5,2)+"/"+SUBSTRING(cEmisNF,1,4)
			cEmisNF := PADR(cEmisNF,11) 
			
			FWrite(nHandle, cProtoc+cAbertu+cHrAbert+cStatus+cPedGar+cCodAna+cAnalis+cNomeAn+cEquipe+cEmisPed+cEmisNF+CRLF )
			
			TRBATEND->(DbSkip())
			
			cProtoc := " "
			cAbertu := " "
			cHrAbert:= " "
			cStatus := " "
			cPedGar := " "
			cCodAna := " "  
			cAnalis := " " 
			cNomeAn := " " 
			cEquipe := " " 
			cEmisPed:= " " 
			cEmisNF := " "
	
	  
     	Enddo
		 		
		Fclose(nHandle)
		Conout("Job JbCarAten - SUCESS EXECUTE Emp("+cJobEmp+"/"+cJobFil+")" )
		Conout("Tempo de Execucao Inicio- "+cTime+" Termino "+Time())
		Conout("Arquivo Criado - "+cFileOut)
			
	Else
		Conout("Job JbCarAten - ERRO EXECUTE Emp("+cJobEmp+"/"+cJobFil+")" )
		CONOUT("ERROR - FAILED TO CREATE "+cFileOut+" - FERROR "+str(ferror()))
	Endif  
	
		TRBATEND->(DbCloseArea())
	EndDo
	ApMsgInfo( 'Processo finalizado', '[JbCarAten] - Atendimentos SAC')
Return                          