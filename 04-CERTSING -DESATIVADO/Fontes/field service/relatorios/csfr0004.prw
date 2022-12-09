#include "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "colors.ch"
//#include "color.ch"
#include "ap5mail.ch"      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT001   บAutor  ณSEITI               บ Data ณ  13/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Vendas                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Relatorio de Vendas                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function CSFR004()


SetPrvt("ARETURN,NLASTKEY,CPERG,CSTRING,WNREL,CNOMEPROG")
SetPrvt("CTITULO,CDESC1,CDESC2,CDESC3,AORD,CTAMANHO,M_PAG")


aReturn  := { "Zebrado", 1,"Administracao", 1,2, 1, "",1 }
nLastKey := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01     // Data de                                      ณ
//ณ mv_par02     // Data Ate                                     ณ
//ณ mv_par03     // Cliente de                                   ณ
//ณ mv_par04     // Cliente ate                                  ณ
//ณ MV_PAR07     // Moeda                                        ณ
//ณ MV_PAR08     // Conversใo                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cPerg    := PADR("RFAT01",len(SX1->X1_GRUPO)) 
//ValidPerg("RFAT01")

pergunte(cPerg,.F.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ     Variaveis tipo Local padrao de todos os relatorios       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cString  := "SB1" // Alias do Arquivo principal
wnrel    := "CSFR004"  // Nome do Relatorio para impressao em arquivo
cNomeProg:= "CSFR004"
ctitulo  := "Atendimentos realizados"
cDesc1   := "Atendimentos realizados"
cDesc2   := " "
cDesc3   := "Especifico CertiSign 25.10.06"
aOrd     := {}
cTamanho := "G"
M_PAG    := 1
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ           Envia controle para a funcao SETPRINT              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel:=SetPrint( cString,;  // Alias do Arquivo Principal
wnrel,;    // Nome Padrฦo do Relatขrio
cPerg,;    // Nome do Grupo de Perguntas ( SX1 )
@cTitulo,;  // Titulo de Relatขrio
cDesc1, cDesc2, cDesc3,;   // Descriฦo do Relatขrio
.F.,;      // Habilita o Dicion rio de Dados
aOrd,;     // Array contento a ordem do arquivo principal
.F.,;      // Habilita a Compressฦo do Relatขrio
cTamanho ) // Tamanho do Relatขrio ( G (220), M(132), P(80) Colunas )

If LastKey() == 27 .OR. nLastKey == 27
	SET FILTER TO
	Return
Endif


SetDefault( aReturn, cString )

If LastKey() == 27 .OR. nLastKey == 27
	SET FILTER TO
	Return
Endif


//RptStatus({|| Imprimir()})
Processa({|| Imprimir()})
Set Device to Screen

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImprimir  บAutor  ณSEITI               บ Data ณ  13/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que imprimi os dados carregados no vetor            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Relatorio de Vendas                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Imprimir

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea("TRB")
End If

BeginSql Alias "TRB"
Select PA0_STATUS, PA0_OS, PA0_CLILOC, PA0_LOJLOC, PA0_CLLCNO, (Select Sum(PA1_VALOR) From %Table:PA1% PA1 
Where PA1.%NotDel% and PA0_OS = PA1_OS) As Total
From %Table:PA0% PA0
Where PA0.%NotDel%
Order By PA0_STATUS
EndSql

DbSelectArea("TRB")

ProcRegua( LastRec() )

_nCont:= 0

If !Empty(TRB->PA0_STATUS)
    _TEC := TRB->PA0_STATUS
/*
	nLin := 65
	if nliN > 60
		ImpCab()
	endif
*/
	cLin := "Status "+Iif(AllTrim(TRB->PA0_STATUS)== 'A','Aberto','Fechado')+CHR(13)+CHR(10)
	//nLin := nLin +1	
	DbGoTop()
	Do While !Eof("TRB")
	    /*
		if nliN > 60
			ImpCab()
		endif
		*/
        If _TEC <> TRB->PA0_STATUS
			cLin += "Total de atendimentos: "+CHR(13)+CHR(10)
			cLin += transf(_nCont,"@r 999,999,999")+CHR(13)+CHR(10)
			_nCont:= 0
/*			nLin := nLin +1
			if nliN > 60
				ImpCab()
			endif
*/
			cLin += "Status "+Iif(AllTrim(TRB->PA0_STATUS)== 'A','Aberto','Fechado')+CHR(13)+CHR(10)
//			nLin := nLin +1			
/*  
			if nliN > 60
				ImpCab()
			endif
*/
		End If

		cLin += AllTrim(TRB->PA0_OS)+CHR(13)+CHR(10)
		cLin += AllTrim(TRB->PA0_CLILOC)+"/"+AllTrim(TRB->PA0_LOJLOC)+"-"+AllTrim(TRB->PA0_CLLCNO)+CHR(13)+CHR(10)
		cLin += transf(TRB->Total,"@r 999,999,999.99")+CHR(13)+CHR(10)
		
		
		
		_nCont := _nCont + 1
	    _TEC := TRB->PA0_STATUS
		IncProc( )
//		nLin := nLin +1
		
	DbSkip()
	End Do
	cLin += "Total de atendimentos: "+CHR(13)+CHR(10)
	cLin += transf(_nCont,"@r 999,999,999.99")
//	nLin := nLin +1
	
End If

		//Conexao com o Servidor Exchange		
		CONNECT SMTP SERVER "smtp.uol.com.br" ACCOUNT "mfalcheti" PASSWORD "c6h12o6" RESULT lExchange
		SEND MAIL FROM "mfalcheti@uol.com.br" ;
		TO "dmello@certisign.com.br" ;    // email para monitorar para ver se esta ativo ou nao 07/10/2010 - Solicitado pela Bianca
		CC "rconceicao@certisign.com.br" ;
		SUBJECT "Faturamento Diแrio" ;
		BODY cLin ;
		RESULT lSend
		DISCONNECT SMTP SERVER	
		
		If !lExchange
//			Conout("Erro na tentativa de conectar no servidor exchange ...")
		Else
//			Conout("Conexao com o servidor Exchange " + "smtp.convergence.com.br" + " estabelecida ...") 
			Alert("Conexao com o servidor Exchange " + "smtp.convergence.com.br" + " estabelecida ...")
		Endif
		
		If lSend
//			Conout("E-Mail enviado com sucesso para " + "rodrigo.seiti@terra.com.br")
			Alert("E-Mail enviado com sucesso para " + "rodrigo.seiti@terra.com.br")
		Else
//			Conout("Erro ao enviar o e-mail de faturamento ...")
			Alert("Erro ao enviar o e-mail de faturamento ...")			
		Endif


/*
Set Device to Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
*/
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpCab    บAutor  ณSEITI               บ Data ณ  13/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que imprimi o cabe็alho de dados                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Relatorio de Vendas                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpCab
nLin:=0
nLin := Cabec( cTitulo, "", "", cNomeProg, cTamanho, 15 )
nLin:= nLin+ 1
@ nlin, 00 PSAY "N. Aten.             Cliente                                Endere็o                 Contato                 Telefone"
nLin:= nLin+ 1
@ nLin,00 PSay __PrtThinLine()
nLin:= nLin+ 1
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณCristian Gutierrez  บ Data ณ  17/01/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica a existencia das perguntas criando-as caso nao    บฑฑ
ฑฑบ          ณ existam                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                                                    .ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea	:= GetArea()
Local aRegs := {}
Local nX		:= 0
Local nY		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontagem do array contendo as perguntas a serem verificadas/criadas        .ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aRegs,{cPerg,"01","Data de             ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data ate            ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Cliente de          ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"04","Cliente at้         ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"05","Moeda               ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Dolar","","","","","Ufir","","","","","Euro","","","","","Iene","","","","","","","","","AL",""})
aAdd(aRegs,{cPerg,"06","Conversใo           ?","","","mv_ch6","N",01,0,0,"C","","mv_par06","Do Dia","","","","","Do Faturamento","","","","","","","","","","","","","","","","","","","AL",""})
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerificacao e/ou gravacao das perguntas no arquivo SX1                     .ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX1")
dbSetorder(1)

For nX:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[nX,2])
		RecLock("SX1",.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				FieldPut(nY,aRegs[nX,nY])
			EndIf
		Next
		SX1->(MsUnlock())
	EndIf
Next

RestArea(aArea)
Return



/*
		//Conexao com o Servidor Exchange		
		CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cPass RESULT lExchange
		SEND MAIL FROM cConta TO cEmail CC "mpaladini@commcenter.com.br" SUBJECT "Faturamento Diแrio CommCenter" BODY cLin Result lSend
		DISCONNECT SMTP SERVER	
		
		If !lExchange
			Conout("Erro na tentativa de conectar no servidor exchange ...")
		Else
			Conout("Conexao com o servidor Exchange " + cServer + " estabelecida ...")
		Endif
		
		If lSend
			Conout("E-Mail enviado com sucesso para " + cEmail)
		Else
			Conout("Erro ao enviar o e-mail de faturamento ...")
		Endif
                         
*/
