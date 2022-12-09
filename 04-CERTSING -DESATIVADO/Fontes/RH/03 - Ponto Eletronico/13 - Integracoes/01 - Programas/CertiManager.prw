#INCLUDE 'Protheus.ch'
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TOPCONN.CH"


/*
+--------------------------------------------------------------------------------------------------------------------------------------------------+
| Rotina    | CertiManager | Autor | David Moraes	                                                                          | Data | 09.09.2014  |
+--------------------------------------------------------------------------------------------------------------------------------------------------+
| Descricao | Faz monitoramento dos status das Folhas de Ponto, enviadas aos e-mails dos colaboradores via CERTIFLOW. Avalia se o documento já foi |
|           | lido pelo colaborador e apresenta na tela esse status.                                                                               |
+--------------------------------------------------------------------------------------------------------------------------------------------------+
| Alteracao | 08.07.2015 - Alexandre Alves - Ajuste nos logs gerados pela rotina.                                                                  |
|           +--------------------------------------------------------------------------------------------------------------------------------------+
|           | 30.07.2015 - Alexandre Alves - Mantencao na query de leitura da tabela principal, incluindo filtro por Centro de Custo. Incluidas as |
|           | perguntas "Centro de Custo De/Até" para possibilitar o filtro.                                                                       |
|           |            - Elinimacao da função PUTPERMVPAR() do pergunte
|--------------------------------------------------------------------------------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                                                                                                  |
----------------------------------------------------------------------------------------------------------------------------------------------------
*/     
User Function CertiManager()
Local aList   := {}
Local aBrowse := {}
Local nOpca   := 0
Local aButtons:= {}
Local aCpoBro := {}
Local _stru   := {}

Private lInverte   := .F.
Private cMark      := GetMark()   
Private oMark//Cria um arquivo de Apoio
Private cPerg      := "CERTFLOW"
Private aSize      := MsAdvSize( .T. , .F. )
Private aCores     := {}
Private oDlg

AjustaSx1("CERTFLOW")

If Pergunte("CERTFLOW",.T.)

	cQuery := "SELECT PAN_MAT,    "+CRLF
	cQuery += "       PAN_FILMAT, "+CRLF 
	cQuery += "       PAN_STATUS, "+CRLF
	cQuery += "       PAN_ENCERR  "+CRLF
	cQuery += "FROM "+RetSqlName("PAN")+" PAN  "+CRLF
	cQuery += "WHERE PAN.D_E_L_E_T_ <> '*' AND "+CRLF
	cQuery += "      PAN.PAN_MAT    BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' AND "+CRLF
	cQuery += "      PAN.PAN_FILMAT BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' AND "+CRLF	
    cQuery += "      EXISTS(SELECT RA_MAT "+CRLF
    cQuery += "             FROM "+RetSqlName("SRA")+" SRA "+CRLF	
    cQuery += "             WHERE SRA.D_E_L_E_T_ <> '*' AND "+CRLF
    cQuery += "                   RA_FILIAL+RA_MAT = PAN_FILMAT+PAN_MAT AND "+CRLF
    cQuery += "                   RA_CC BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"') "+CRLF	

	
	If MV_PAR01 == 1                               //1=Aprovado
		cQuery += "AND PAN_STATUS = 1"+CRLF
	ElseIf MV_PAR01 == 2                           //2=Reprovado
		cQuery += "AND PAN_STATUS = 2"+CRLF
	ElseIf MV_PAR01 == 3                           //3=Aguardando Aprovacao
		cQuery += "AND PAN_STATUS = 3"+CRLF
	ElseIf MV_PAR01 == 4		                   //4=Não Enviado
		cQuery += "AND PAN_STATUS = 4"+CRLF	
	EndIF

	cQuery += "AND PAN_PONMES = '"+DTOS(MV_PAR02)+DTOS(MV_PAR03)+"'"+CRLF	

	If Select("TRB") > 0 
		TRB->(DbCloseArea())
	EndIf

	TcQuery cQuery New Alias "TRB"
		
	AADD(_stru,{"OK"        ,"C"	,2		,0		})
	AADD(_stru,{"CSTATUS"   ,"C"	,1		,0		})
	AADD(_stru,{"CDSTATUS"  ,"C"	,25		,0		})	
	AADD(_stru,{"ENCERRA"   ,"C"	,1		,0		})
	AADD(_stru,{"PROCESS"   ,"C"	,10		,0		})
	AADD(_stru,{"FILIAL"    ,"C"	,2		,0		})
	AADD(_stru,{"CCUSTO"	,"C"	,9		,0		})
	AADD(_stru,{"DESCC"		,"C"	,50		,0		})
	AADD(_stru,{"MAT"    	,"C"	,6 		,0		})
	AADD(_stru,{"NOME" 		,"C"	,30		,0		})
                                 
	cArq:=Criatrab(_stru,.T.)
	DBUSEAREA(.t.,,carq,"TTRB")//Alimenta o arquivo de apoio com os registros do cadastro de clientes (SA1)
	
	While TRB->(!EOF())	
		DbSelectArea("TTRB")	
		RecLock("TTRB",.T.)		
	
		TTRB->CSTATUS := TRB->PAN_STATUS

		If TRB->PAN_STATUS == "1"
			TTRB->CDSTATUS := "Aprovado"
		ElseIf TRB->PAN_STATUS == "2"
			TTRB->CDSTATUS := "Reprovado"
		ElseIf TRB->PAN_STATUS == "3"
			TTRB->CDSTATUS := "Aguardando Aprovação"		
		Else
			TTRB->CDSTATUS := "Não Enviado"
		EndIf
					
		If TRB->PAN_ENCERR =="1"
			TTRB->PROCESS := "Encerrado"
		Else
			TTRB->PROCESS := "Aberto"
		EndIf
		TTRB->ENCERRA  := TRB->PAN_ENCERR
		TTRB->FILIAL   := TRB->PAN_FILMAT
		TTRB->CCUSTO   := POSICIONE("SRA",1,TRB->PAN_FILMAT+TRB->PAN_MAT,"RA_CC")
		TTRB->DESCC    := POSICIONE("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01") //CTT_FILIAL+CTT_CUSTO
		TTRB->MAT      := TRB->PAN_MAT
		TTRB->NOME     := SRA->RA_NOME
		
 		MsunLock()	
		TRB->(DbSkip())
	EndDo
	
	aAdd(aCores,{"TTRB->CSTATUS == '1'","BR_VERDE"		})
	aAdd(aCores,{"TTRB->CSTATUS == '2'","BR_VERMELHO"	})//Define quais colunas (campos da TTRB) serao exibidas na MsSelect
	aAdd(aCores,{"TTRB->CSTATUS == '3'","BR_AMARELO"	})
	aAdd(aCores,{"TTRB->CSTATUS == '4'","BR_PRETO"		})	

//	AADD(_stru,{"OK"        ,"C"	,2		,0		})
	AADD(_stru,{"CDSTATUS"  ,"C"	,10		,0		})
	AADD(_stru,{"PROCESS"   ,"C"	,10		,0		})
	AADD(_stru,{"FILIAL"    ,"C"	,2		,0		})
	AADD(_stru,{"CCUSTO"	,"C"	,9		,0		})
	AADD(_stru,{"DESCC"		,"C"	,50		,0		})
	AADD(_stru,{"MAT"    	,"C"	,6 		,0		})
	AADD(_stru,{"NOME" 		,"C"	,30		,0		})

	
	aCpoBro	:= {{ "CDSTATUS"	,, "Status"         ,"@!"},;			
				{ "PROCESS"		,, "Processo"       ,"@!"},;			
				{ "FILIAL"		,, "Filial"         ,"@!"},;
				{ "CCUSTO"		,, "Centro de Custo","@!"},;
				{ "DESCC"		,, "Descrição"      ,"@!"},;
				{ "MAT"			,, "Matricula"      ,"@!"},;
				{ "NOME"		,, "Nome"      		,"@!"}}//Cria uma Dialog

	TTRB->(DbSelectArea("TTRB"))
	TTRB->(DbGoTop())
	
    DEFINE DIALOG oDlg TITLE "Monitor CertiFlow" FROM aSize[7],aSize[2] to aSize[6],aSize[5] PIXEL     
        
   	oMark := MsSelect():New("TTRB","","",aCpoBro,,,{01,01,aSize[4] - 6.5,aSize[3]},,,,,aCores)
//	oMark:bMark := {|| U_Disp()} //Exibe a Dialog

//	Aadd( aButtons, {"GERACERTFLOW", {|| ReenvProc()}, "CertiFlow...", "Reenviar" , {|| .T.}} )
	Aadd( aButtons, {"MONTATELA"	, {|| U_MontaTela(	TTRB->FILIAL ,	TTRB->MAT, DTOS(MV_PAR02)+"/"+DTOS(MV_PAR03) )}, "CertiFlow...", "Visualizar" , {|| .T.}} )		

    ACTIVATE DIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,{||lOk:=.T.,oDlg:End()},{||oDlg:End()},,@aButtons))
	
	TTRB->(DbCloseArea())
	Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)
	
  	If Select("TRB") > 0 
		TRB->(DbCloseArea())
	EndIf

EndIf

RETURN NIL

/*
---------------------------------------------------------------------------
| Rotina    | AjustaSx1     | Autor | David Moraes	 | Data | 09.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Adiciona novas perguntas utilizadas pela rotina 			  |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
Static Function AjustaSx1(cPerg)
Local nTamFil := TamSX3( "RA_FILIAL" )[1] 
Local nTamCC  := TamSX3( "RA_CC" )[1] 

PutSx1( cPerg, 	"01","Status","Status","Status","mv_ch1","C",1,0,0,"C","","","","",;
				"mv_par01","Aprovado","Aprovado","Aprovado","","Reprovado","Reprovado","Reprovado",;
				"Aguard. Aprovação","Aguard. Aprovação","Aguard. Aprovação","Não Enviado","Não Enviado","Não Enviado","Todos","Todos","Todos",,,)

PutSx1( cPerg, 	"02","Data De?" ,"Data De?" ,"Data De?" ,"mv_ch2","D",08,0,0,"G","NaoVazio()","","","",;
				"mv_par02","","","","","","","",;
				"","","","","","","","","",,,)

PutSx1( cPerg, 	"03","Data Até?","Data Até?","Data Até?","mv_ch3","D",08,0,0,"G","NaoVazio()","","","",;
				"mv_par03","","","","","","","",;
				"","","","","","","","","",,,)

PutSx1( cPerg, 	"04","Matricula De?","Matricula De?","Matricula De?","mv_ch4","C",6,0,0,"G","","SRA","","",;
				"mv_par04","","","",""," ","","",;
				"","","","","","","","","",,,)

PutSx1( cPerg, 	"05","Matricula Até?","Matricula Até?","Matricula Até?","mv_ch5","C",6,0,0,"G","","SRA","","",;
				"mv_par05","","","",""," ","","",;
				"","","","","","","","","",,,)
				
PutSx1( cPerg, 	"06","Filial De?","Filial De?","Filial De?","mv_ch6","C",nTamFil,0,0,"G","","SM0","","",;
				"mv_par06","","","","","","","",;
				"","","","","","","","","",,,)

PutSx1( cPerg, 	"07","Filial Até?","Filial Até?","Filial Até?","mv_ch7","C",nTamFil,0,0,"G","","SM0","","",;
				"mv_par07","","","","","","","",;
				"","","","","","","","","",,,)

PutSx1( cPerg, 	"08","C.Custo De?","C.Custo De?","C.Custo De?","mv_ch8","C",nTamCC,0,0,"G","","CTT","","",;
				"mv_par08","","","","","","","",;
				"","","","","","","","","",,,)

PutSx1( cPerg, 	"09","C.Custo Até?","C.Custo Até?","C.Custo Até?","mv_ch9","C",nTamCC,0,0,"G","","CTT","","",;
				"mv_par09","","","","","","","",;
				"","","","","","","","","",,,)


Return

/*
---------------------------------------------------------------------------
| Rotina    | AjustaLeg     | Autor | David Moraes	 | Data | 09.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Ajusta Legenda								 			  |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function AjustaLeg(aBrowse, nLin)
Local oRet     := ""

If aBrowse[nLin,01] == "1"
	 oRet     := LoadBitmap(GetResources(),'br_verde')
ElseIf aBrowse[nLin,01] == "2"
	 oRet     := LoadBitmap(GetResources(),'br_vermelho') 
ElseIf aBrowse[nLin,01] == "3"
	 oRet     := LoadBitmap(GetResources(),'br_amarelo') 
Else
	 oRet     := LoadBitmap(GetResources(),'br_preto') 
EndIf

Return oRet

/*
---------------------------------------------------------------------------
| Rotina    | ReenvProc     | Autor | David Moraes	 | Data | 09.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Reenvia o PDF para o CertiFlow				 			  |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------

Static Function ReenvProc()
Local nPosLin  := oMark:OBROWSE:NROWPOS
Local lExec    := .F.
Local cToken   := ""
Private aCertFlow := {}

cFilBkp := cFilAnt

TTRB->(DbGoTop())
While TTRB->(!EOF())

	If 	!Empty(TTRB->OK)

		cFilAnt := TTRB->FILIAL
	
		If TTRB->CSTATUS == "1" .Or. TTRB->CSTATUS == "3"//Aprovado e Aguardando
			Alert("Não é possível reenviar arquivo com status de aprovado ou aguardando aprovação :"+TTRB->MAT)
			TTRB->(DbSkip())
			Loop
		ElseIf TTRB->CSTATUS == "2"//Reprovado
			If TTRB->ENCERRA == "1"//Processo Encerrado
				Alert("O processo se encontra encerrado, é necessário iniciar um novo fluxo no CertiFlow :"+TTRB->MAT)
				TTRB->(DbSkip())
				Loop
			EndIf
		EndIf

		PAN->(DbSelectArea("PAN"))
		PAN->(DbSetOrder(1))
		If PAN->(DbSeek(xFilial("PAN")+TTRB->FILIAL+TTRB->MAT+SubStr(GetMv("MV_PONMES"),1,17)))
			Processa( {||  ReprocPDF(TTRB->MAT,PAN->PAN_CODCON)}, "Gerando PDF", "Processando aguarde...", .F.)
			lExec := .T.
		EndIf
	EndIf	
	TTRB->(DbSkip())
EndDo

If lExec
	oWsdl := WSFluxosExternos():New()
	
	xRet := oWsdl:UserAuthenticate()  
	
	If U_ParserCerti(1,oWsdl,@oWsdl:CUSERAUTHENTICATERESULT, @cToken)
		
		oWsdl := WSFluxosExternos():New()
		oWsdl:oWSparameters 	:= FluxosExternos_ArrayOfString():NEW()
		oWsdl:cflowCode     	:= "318"
		oWsdl:CAUTHENTICATETOKEN := cToken
		
		//string com o email do funcionário, nome do arquivo, matrícula
		//do funcionário, período e o código do controle
		oWsdl:oWSparameters:cString := aCertFlow
	
		xRet := oWsdl:StartFlowUploadingFile()
	EndIf

	Alert("Arquivo enviado com sucesso!")
EndIf

TTRB->(DbGoTo(nPosLin))

oMark:oBrowse:REFRESH()

cFilAnt := cFilBkp

Return
*/

/*
---------------------------------------------------------------------------
| Rotina    | Disp		     | Autor | David Moraes	 | Data | 09.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Altera o checkbox								 			  |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------

User Function Disp()
	
RecLock("TTRB",.F.)

If !Marked("OK")	
	TTRB->OK := ""
Endif             

MSUNLOCK()

oMark:oBrowse:Refresh()

Return()
*/

/*
---------------------------------------------------------------------------
| Rotina    | ReprocPDF	  | Autor | David Moraes	 | Data | 09.09.2014  |
|-------------------------------------------------------------------------|
| Descricao | Reprocessa PDF								 			  |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------

Static Function ReprocPDF(cMat,cControle)

Incproc("Processando registro: "+cMat)

U_GeraEspelhoPDF(cMat, Alltrim(cControle))

Return
*/