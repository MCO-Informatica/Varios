#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERCNX    บAutor  ณDouglas Mello       บ Data ณ  06/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 										 					  บฑฑ
ฑฑบ          ณ 										                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ JOB executado em horario especificado em parametro        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VERCNX()

Local cTime :=  time()
Local cFileOut  := ""
Local cJobEmp 	:= Getjobprofstring("JOBEMP","01")
Local cJobFil 	:= Getjobprofstring("JOBFIL","02")
Local cInterval := Getjobprofstring("INTERVAL","60")
Local cHrExec	:= ""
//Local cFileMic := "\pedidosfaturados\pedidos_microsiga_"+Dtos(DdataBase)+".txt" //nao faturados
//Local cFileFat := "\pedidosfaturados\pedidos_faturados_"+Dtos(DdataBase)+".txt"
//Local cFileVdi := "\pedidosfaturados\vendas_diretas_"+Dtos(DdataBase)+".txt"

Local cFileMic := "\pedidosfaturados\pedidos_microsiga_20101110.txt" //nao faturados
Local cFileFat := "\pedidosfaturados\pedidos_faturados_20101110.txt"
Local cFileVdi := "\pedidosfaturados\vendas_diretas_20101110.txt"



//Conout("Job VERCNX - Begin Emp("+cJobEmp+"/"+cJobFil+")" )
//Conout("Interval Check : "+cInterval)

Rpcsettype(2)
RpcSetEnv(cJobEmp,cJobFil)

OpenGTEnv()				// Abertura das Tabelas

cHrExec 	:=  GetNewPar("MV_VERTXTH", "00:01")
//nDiasAnt 	:=  GetNewPar("MV_VERTXTD", 0)

If Substr(time(),1,5) = cHrExec
//	Conout("Job GARA181 - EXECUTE Emp("+cJobEmp+"/"+cJobFil+")" )

	/*
	If !File( "c:\teste.txt" )
	   Alert( "Arquivo nใo localizado" )
	EndIf
	*/
    
	If !File(cFileFat)
		U_GARA180()			
	EndIf
	               
	If !File(cFileMic)
		U_GARA181()			
	EndIf
	
	If !File(cFileVdi)
		U_GARA182()			
	EndIf
	
                             
EndIf


Return()
