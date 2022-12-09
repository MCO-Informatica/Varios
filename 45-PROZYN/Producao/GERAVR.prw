#include "rwmake.ch" 
#include "fileio.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCRMR010  ºAutor  ³ Guilherme Coelho  º Data ³  22/11/2020  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para impressão do relatorio de Vale Refeição		   º±±
±±ºDesc.     ³ Prozyn - Protheus 12                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12 - Prozyn                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function GeraVR()

Local cPerg			:= "GPEVTR"
Local cTexto 		:= ""
Local nFile         := 0
Local cQuery        := ""
Local nOpc			:= 0



Pergunte(cPerg,.F.) 
Processa({|lEnd|}, "Vale Refeição", "Exportando...", .T.)


//If MV_PAR14 == 1

cQuery :=" SELECT SRA.RA_NOME, "
cQuery +="		  SRA.RA_CIC, "
cQuery +="		  CONCAT(CONCAT(CONCAT(CONCAT(SUBSTRING(SRA.RA_NASC,7,2),'/'),SUBSTRING(SRA.RA_NASC,5,2)),'/'),SUBSTRING(SRA.RA_NASC,1,4)) AS RA_NASC, "
cQuery +="		  SRA.RA_ADMISSA, "
cQuery +="		  SRA.RA_SEXO, "
cQuery +="		  SP8.P8_MAT, "
cQuery +="		  COUNT(SP8.P8_HORA)*13.18 AS P8_QUANT "
cQuery +="		  FROM (SELECT SP8.P8_FILIAL, "
cQuery +="		  SP8.P8_MAT, "
cQuery +="		  SP8.P8_DATA, "
cQuery +="		  CONVERT(NVARCHAR, CONVERT(DATETIME, SUM( CASE WHEN SP8.P8_RANK = 1 THEN (SP8.P8_HORA * -1) ELSE SP8.P8_HORA END)/24), 108) AS P8_HORA "               
cQuery +=" FROM (SELECT SP8.P8_FILIAL, "
cQuery +="		  		SP8.P8_MAT, "
cQuery +="		  		SP8.P8_DATA, "
cQuery +="		  		SP8.P8_HORA, "
cQuery +="		  		DENSE_RANK() OVER (PARTITION BY SP8.P8_MAT, SP8.P8_DATA, SP8.P8_ORDEM ORDER BY SP8.P8_HORA, SP8.R_E_C_N_O_) AS P8_RANK "
cQuery +="		 FROM "+ RetSqlName("SP8")+" SP8 "
cQuery +="		 WHERE 	SP8.D_E_L_E_T_ <> '*' AND "
cQuery +="		  		SP8.P8_APONTA <>  'N' AND "
cQuery +="		  		SP8.P8_TPMCREP <> 'D' AND "
cQuery +="		  		SP8.P8_DATA BETWEEN '"+ dtos(MV_PAR03)+"' AND '"+ dtos(MV_PAR04)+"' "
cQuery +="		 ) SP8 "
cQuery +=" GROUP BY SP8.P8_FILIAL, SP8.P8_MAT, SP8.P8_DATA "

cQuery +="	UNION "

cQuery +=" SELECT SPG.PG_FILIAL, "
cQuery +="		  SPG.PG_MAT, "
cQuery +="		  SPG.PG_DATA, "
cQuery +="		  CONVERT(NVARCHAR, CONVERT(DATETIME, SUM( CASE WHEN SPG.PG_RANK = 1 THEN (SPG.PG_HORA * -1) ELSE SPG.PG_HORA END)/24), 108) AS PG_HORA "
cQuery +=" FROM (SELECT SPG.PG_FILIAL, "
cQuery +="		  		SPG.PG_MAT, "
cQuery +="		  		SPG.PG_DATA, "
cQuery +="		  		SPG.PG_HORA, "
cQuery +="		  		DENSE_RANK() OVER (PARTITION BY SPG.PG_MAT, SPG.PG_DATA, SPG.PG_ORDEM ORDER BY SPG.PG_HORA, SPG.R_E_C_N_O_) AS PG_RANK "
cQuery +="		 FROM   "+ RetSqlName("SPG")+" SPG "
cQuery +="		 WHERE  SPG.D_E_L_E_T_ <> '*' AND "
cQuery +="		  		SPG.PG_APONTA <>  'N' AND "
cQuery +="		  		SPG.PG_TPMCREP <> 'D' AND "
cQuery +="		  		SPG.PG_DATA BETWEEN '"+ dtos(MV_PAR03)+"' AND '"+ dtos(MV_PAR04)+"' "
cQuery +="		  ) SPG "
cQuery +=" GROUP BY SPG.PG_FILIAL, SPG.PG_MAT, SPG.PG_DATA "
cQuery +=" 	 ) SP8 INNER JOIN "+ RetSqlName("SRA")+" SRA ON SP8.P8_MAT = SRA.RA_MAT "
cQuery +=" WHERE	SRA.D_E_L_E_T_ <> '*'  "
cQuery +=" 	AND	SP8.P8_MAT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "
cQuery +=" 	AND	SP8.P8_HORA >= '4'  "
cQuery +=" 	AND	LPAD('"+MV_PAR07+"', 5) LIKE '%' + SRA.RA_SITFOLH + '%'  "
cQuery +=" 	AND	LPAD('"+MV_PAR08+"', 5) LIKE '%' + SRA.RA_CATFUNC + '%'  "
cQuery +=" 	AND	RTRIM(LTRIM(SRA.RA_CC)) BETWEEN RTRIM(LTRIM('"+MV_PAR09+"')) AND  RTRIM(LTRIM('"+MV_PAR10+"'))  "
cQuery +=" 	AND SRA.RA_ADMISSA NOT BETWEEN '"+ dtos(MV_PAR05)+"' AND '"+ dtos(MV_PAR06)+"' "
cQuery +="  AND ISNULL('"+MV_PAR13+"', ' ') NOT LIKE '%' + RTRIM(LTRIM(SRA.RA_CC)) + '%' "
cQuery +="  AND SRA.RA_TNOTRAB <> '999' "
cQuery +=" GROUP BY SP8.P8_MAT, SRA.RA_NOME, SRA.RA_CIC, SRA.RA_NASC, SRA.RA_ADMISSA, SRA.RA_SEXO "
cQuery +=" ORDER BY  SP8.P8_MAT "

/*ElseIf MV_PAR14 == 2

cQuery :="SELECT 	SRA.RA_NOME, "
cQuery +="		SRA.RA_CIC, "
cQuery +="		CONCAT(CONCAT(CONCAT(CONCAT(SUBSTRING(SRA.RA_NASC,7,2),'/'),SUBSTRING(SRA.RA_NASC,5,2)),'/'),SUBSTRING(SRA.RA_NASC,1,4)) AS RA_NASC, "
cQuery +="		SRA.RA_ADMISSA, "
cQuery +="		SRA.RA_SEXO, "
cQuery +="		SRA.RA_MAT AS P8_MAT, "
cQuery +="		"+MV_PAR11+"*13.18 AS P8_QUANT  "
cQuery +="FROM 	"+ RetSqlName("SRA")+" SRA "
cQuery +="WHERE 	SRA.D_E_L_E_T_ <> '*' "
cQuery +="		AND	SRA.RA_MAT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery +="		AND	LPAD('"+MV_PAR07+"', 5) LIKE '%' + SRA.RA_SITFOLH + '%'  "
cQuery +="		AND	LPAD('"+MV_PAR08+"', 5) LIKE '%' + SRA.RA_CATFUNC + '%'  "
cQuery +="		AND	RTRIM(LTRIM(SRA.RA_CC)) BETWEEN RTRIM(LTRIM('"+MV_PAR09+"')) AND  RTRIM(LTRIM('"+MV_PAR10+"'))  "
cQuery +="      AND ISNULL('"+MV_PAR13+"', ' ') NOT LIKE '%' + RTRIM(LTRIM(SRA.RA_CC)) + '%' "
cQuery +=" AND SRA.RA_ADMISSA  BETWEEN '"+ dtos(MV_PAR05)+"' AND '"+ dtos(MV_PAR06)+"' "
cQuery +=" AND SRA.RA_TNOTRAB <> '999' "
cQuery +="ORDER BY  SRA.RA_MAT "

ElseIf MV_PAR14 == 3

cQuery :="SELECT 	SRA.RA_NOME, "
cQuery +="		SRA.RA_CIC, "
cQuery +="		CONCAT(CONCAT(CONCAT(CONCAT(SUBSTRING(SRA.RA_NASC,7,2),'/'),SUBSTRING(SRA.RA_NASC,5,2)),'/'),SUBSTRING(SRA.RA_NASC,1,4)) AS RA_NASC, "
cQuery +="		SRA.RA_ADMISSA, "
cQuery +="		SRA.RA_SEXO, "
cQuery +="		SRA.RA_MAT AS P8_MAT, "
cQuery +="		"+MV_PAR11+"*13.18 AS P8_QUANT  "
cQuery +="FROM 	"+ RetSqlName("SRA")+" SRA "
cQuery +="WHERE 	SRA.D_E_L_E_T_ <> '*' "
cQuery +="		AND	SRA.RA_MAT BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery +="		AND	LPAD('"+MV_PAR07+"', 5) LIKE '%' + SRA.RA_SITFOLH + '%'  "
cQuery +="		AND	LPAD('"+MV_PAR08+"', 5) LIKE '%' + SRA.RA_CATFUNC + '%'  "
cQuery +="		AND	RTRIM(LTRIM(SRA.RA_CC)) BETWEEN RTRIM(LTRIM('"+MV_PAR09+"')) AND  RTRIM(LTRIM('"+MV_PAR10+"'))  "
cQuery +="      AND ISNULL('"+MV_PAR13+"', ' ') NOT LIKE '%' + RTRIM(LTRIM(SRA.RA_CC)) + '%' "
cQuery +=" AND SRA.RA_TNOTRAB = '999' "
cQuery +=" AND SRA.RA_ADMISSA NOT BETWEEN '"+ dtos(MV_PAR05)+"' AND '"+ dtos(MV_PAR06)+"' "
cQuery +="ORDER BY  SRA.RA_MAT "

EndIf*/

dbUseArea(.T., "TOPCONN", TCGenQry( , , cQuery), "TEMP1", .F., .T.)

dbSelectArea("TEMP1")
TEMP1->( dbGoTop() )
 
// Chamada da função para geração co Arq. CSV
If ApMsgYesNO('Confirma os parametros?')
   MsAguarde({||LoadCSV()},"Aguarde","Gerando dados para a Planilha",.F.)                                          
Endif
                       

dbCloseArea("TEMP1")


Return
           
/***********************************/
  Static Function LoadCSV()
/***********************************/   
   	Local cArqLocal  := ""
   	Local cArqDir    := MV_PAR12
    Local nHdl       := 0
    Local cCodContr 	:= AllTrim(GETMV("MT_CONTRVR"))
    Local cCodEmp := CnpJEmp(FWCodEmp())
    
    Local cTime      := TIME() // Resultado: 10:37:17
	Local cHora      := SUBSTR(cTime, 1, 2) // Resultado: 10
	Local cMinutos   := SUBSTR(cTime, 4, 2) // Resultado: 37
	Local cSegundos  := SUBSTR(cTime, 7, 2) // Resultado: 17
	Local cFil		 := FWFilial()
	Local cEmp		 := FWCodEmp() 
	Local cUser 	 := __cUserID
	
	//Nome do Arquivo
	cArqLocal := "VR_de_"+ dtos(MV_PAR03)+"_ate_"+ dtos(MV_PAR04)+"_"+cEmp+""+cUser+""+cHora+""+cMinutos+""+cSegundos+".CSV"//
	//Cria uma arquivo vazio em disco
	nHdl := Fcreate("\vr\"+cArqLocal)
	
	fWrite(nHdl, ";CONTRATO;;;;;;;;"+ Chr(13) + Chr(10))   
    fWrite(nHdl, "%;"+cCodContr+";%;;;;;;;"+ Chr(13) + Chr(10))
    
    fWrite(nHdl, ";NOME DO USUµRIO;CPF;DATA DE NASCIMENTO;CàDIGO DE SEXO;VALOR;TIPO DE LOCAL ENTREGA;LOCAL DE ENTREGA;MATRÖCULA;")
	
	//dbGoTop() // Posiciona o cursor no início da área de trabalho ativa
	While TEMP1->( !Eof() )
		//Corpo do CSV
		fWrite(nHdl, Chr(13) + Chr(10) + "%;"+ TEMP1->RA_NOME +";"+;
										 TEMP1->RA_CIC +";"+;
										 TEMP1->RA_NASC +";"+;
										 TEMP1->RA_SEXO +";"+;
										 StrTran(CvalToChar(TEMP1->P8_QUANT),".",",") +";"+;
										 "FI" +";"+;
										 cCodEmp +";"+;
										 TEMP1->P8_MAT+";%")
	TEMP1->( dbSkip() )
	Enddo
			
	//Função escreve no arquivo.
	FWRITE(nHdl,"")               
	//Fecha o arquivo em disco
	FCLOSE(nHdl)
  
//Copia o arquivo da pasta \DATA\ do protheus para a maquina local.
If CpyS2T( "\vr\"+cArqLocal, cArqDir, .F. )
    
       MSGALERT("Arquivos exportados com sucesso.", "Exportação")//"Arquivos exportados com sucesso." - "Exportação"
   
Else
    MsgStop('Não foi possível copiar o arquivo')
EndIf  
             
Return
