#include "rwmake.ch"  
#INCLUDE "Ap5Mail.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ ÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ ฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออป ฑฑ
ฑฑบPrograma  ณ ATUMOEDASบ Autor ณRenan      บ Data ณ  02/12/2015           บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออน ฑฑ
ฑฑบDescrio ณ Programa para Atualizacao do Dolar (ou qualquer outra moeda)บฑฑ
ฑฑบDescrio ณ apos as cota็๕es do dia (normalmente apos as 17h30).        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ นฑฑ
ฑฑบUso       ณ Rodar a partir do Menu ou via JOB agendado todo dia depois  บฑฑ
ฑฑบ          ณ das 18h00 para ser apos o fechamento do dolar do dia.       บฑฑ
ฑฑบ          ณ Pode-se usar a mesma rotina para atualizar quaisquer moedas บฑฑ
ฑฑบ          ณ que possuam cota็ao oficial no site do Banco Central.       บฑฑ
ฑฑบ          ณ Caso o Banco Central mude o endere็o do arquivo CSV, altere บฑฑ
ฑฑบ          ณ no fonte ou crie um parโmetro. Pode-se tambem gerar um      บฑฑ
ฑฑบ          ณ email para o departamento financeiro, para monitoramento    บฑฑ
ฑฑบ          ณ e ajustes da rotina.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ ผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ATUMOEDAS()
Local cFile, cTexto, nLinhas, j, lAuto, nPass, m, jj := .F. 

If Select("SX2")==0 // Testa se estแ sendo rodado do menu
	RPCSETENV("01","01","admin","2017pzn",,"JOB",{"SM2"})
	Qout("JOB - Atualizacao do Dolar...")
	lAuto := .T.
EndIf

For nPass := 6 to 0 step -1 
// Refaz dos ultimos 6 dias para o caso de algum dia a conexao ter falhado
	
	dDataRef := dDataBase //- nPass

	If Dow(dDataRef) == 1    // Se for domingo
		cFile := DTOS(dDataRef - 2)+".csv"
	ElseIf Dow(dDataBase) == 7            // Se for sแbado
		cFile := DTOS(dDataRef - 1)+".csv"
	Else                                   // Se for dia normal
		cFile := DTOS(dDataRef)+".csv"
	EndIf
	
	cDolar 	:=0
	cFranco	:=0  
	cEuro 	:=0      
	
	cTexto  :=  HTTPGET('http://www4.bcb.gov.br/download/fechamento/'+cFile)
	nLinhas := MLCount(cTexto, 81)
	For j := 1 to nLinhas
	    jj:=.t.
		cLinha := Memoline(cTexto,81,j)
		cData  := Substr(cLinha,1,10)
		cCompra := StrTran(Substr(cLinha,22,14),",",".")
		cVenda  := StrTran(Substr(cLinha,33,14),",",".")

		
		If Subst(cLinha,12,3)=="220" // Dolar Americano
			DbSelectArea("SM2")
			DbSetOrder(1)
			
			dData := CTOD(cData)-1
			For m := 1 To 1//30 // projeta para 15 dias.
				dData++
				If DbSeek(DTOS(dData))
					Reclock("SM2",.F.)
				Else
					Reclock("SM2",.T.)
					Replace M2_DATA   With dData
				EndIf
				Replace M2_MOEDA2 With Val(cVenda) 
				cDolar := Val(cVenda)
				Replace M2_INFORM With "S"
				MsUnlock("SM2")
			Next
		EndIf
        
		If Subst(cLinha,12,3)=="425" // FRANCO
			DbSelectArea("SM2")
			DbSetOrder(1)
			
			dData := CTOD(cData)-1
			For m := 1 To 2 //30 // projeta para 15 dias.
				dData++
				If DbSeek(DTOS(dData))
					Reclock("SM2",.F.)
				Else
					Reclock("SM2",.T.)
					Replace M2_DATA   With dData
				EndIf
				Replace M2_MOEDA3 With Val(cVenda)
				cFranco := Val(cVenda)
				MsUnlock("SM2")
			Next
		EndIf
		
		If Subst(cLinha,12,3)=="978" // EURO
			DbSelectArea("SM2")
			DbSetOrder(1)
			
			dData := CTOD(cData)-1
			For m := 1 To 2//30 // projeta para 15 dias.
				dData++
				If DbSeek(DTOS(dData))
					Reclock("SM2",.F.)
				Else
					Reclock("SM2",.T.)
					Replace M2_DATA   With dData
				EndIf
				Replace M2_MOEDA4 With Val(cVenda)
				cEuro := Val(cVenda)
				MsUnlock("SM2")
			Next
		EndIf
		
	Next
next
   
if jj
//  	Messagebox("Atualizacao efetuada com sucesso","OK", 0)
  	//MSGBOX("Atualizacao efetuada com sucesso", ,"INFO")
else 
   //	Alert("  Falha no processamento, verifique conexao com internet ou tente mais tarde !") 	
EndIf
		//(titulo do e-mail,conte๚do,e-mail destino,caminho dos anexos (se houver),e-mail de origem,e-mail que receberแ c๓pia oculta)
u_rcfgm001("Cota็ใo de Moedas do Dia - Protheus :"+Dtoc(DDatabase),"Cota็ใo do dia :"+ CHR(13)+CHR(10)+ CHR(13)+CHR(10) +"Dolar: " +str(cDolar)+ CHR(13)+CHR(10) + "Franco: "+str(cFranco) + CHR(13)+CHR(10)+ "Euro: "+str(cEuro) + CHR(13)+CHR(10)+ CHR(13)+CHR(10)+"Valores consultados pelo Sistema Protheus no Site do Banco Central. " , "protheus@prozyn.com.br", , "ricardo@prozyn.com.br")  	
If lAuto
	RpcClearEnv()
	//Qout("FIM - JOB - Atualizacao das Moedas.")
EndIf

Qout("FIM - JOB - Atualizacao das Moedas.")
	
Return



