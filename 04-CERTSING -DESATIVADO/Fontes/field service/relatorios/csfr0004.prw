#include "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "colors.ch"
//#include "color.ch"
#include "ap5mail.ch"      
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFAT001   �Autor  �SEITI               � Data �  13/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio de Vendas                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Relatorio de Vendas                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function CSFR004()


SetPrvt("ARETURN,NLASTKEY,CPERG,CSTRING,WNREL,CNOMEPROG")
SetPrvt("CTITULO,CDESC1,CDESC2,CDESC3,AORD,CTAMANHO,M_PAG")


aReturn  := { "Zebrado", 1,"Administracao", 1,2, 1, "",1 }
nLastKey := 0

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Data de                                      �
//� mv_par02     // Data Ate                                     �
//� mv_par03     // Cliente de                                   �
//� mv_par04     // Cliente ate                                  �
//� MV_PAR07     // Moeda                                        �
//� MV_PAR08     // Convers�o                                    �
//����������������������������������������������������������������

cPerg    := PADR("RFAT01",len(SX1->X1_GRUPO)) 
//ValidPerg("RFAT01")

pergunte(cPerg,.F.)
//��������������������������������������������������������������Ŀ
//�     Variaveis tipo Local padrao de todos os relatorios       �
//����������������������������������������������������������������
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
//��������������������������������������������������������������Ŀ
//�           Envia controle para a funcao SETPRINT              �
//����������������������������������������������������������������
wnrel:=SetPrint( cString,;  // Alias do Arquivo Principal
wnrel,;    // Nome Padr�o do Relat�rio
cPerg,;    // Nome do Grupo de Perguntas ( SX1 )
@cTitulo,;  // Titulo de Relat�rio
cDesc1, cDesc2, cDesc3,;   // Descri��o do Relat�rio
.F.,;      // Habilita o Dicion�rio de Dados
aOrd,;     // Array contento a ordem do arquivo principal
.F.,;      // Habilita a Compress�o do Relat�rio
cTamanho ) // Tamanho do Relat�rio ( G (220), M(132), P(80) Colunas )

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Imprimir  �Autor  �SEITI               � Data �  13/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o que imprimi os dados carregados no vetor            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Relatorio de Vendas                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		SUBJECT "Faturamento Di�rio" ;
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpCab    �Autor  �SEITI               � Data �  13/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o que imprimi o cabe�alho de dados                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Relatorio de Vendas                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImpCab
nLin:=0
nLin := Cabec( cTitulo, "", "", cNomeProg, cTamanho, 15 )
nLin:= nLin+ 1
@ nlin, 00 PSAY "N. Aten.             Cliente                                Endere�o                 Contato                 Telefone"
nLin:= nLin+ 1
@ nLin,00 PSay __PrtThinLine()
nLin:= nLin+ 1
Return




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Cristian Gutierrez  � Data �  17/01/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica a existencia das perguntas criando-as caso nao    ���
���          � existam                                                    ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidPerg(cPerg)
//����������������������������������������������������������������������������Ŀ
//�Declaracao de variaveis                                                    .�
//������������������������������������������������������������������������������
Local aArea	:= GetArea()
Local aRegs := {}
Local nX		:= 0
Local nY		:= 0

//����������������������������������������������������������������������������Ŀ
//�Montagem do array contendo as perguntas a serem verificadas/criadas        .�
//������������������������������������������������������������������������������
aAdd(aRegs,{cPerg,"01","Data de             ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data ate            ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Cliente de          ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"04","Cliente at�         ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"05","Moeda               ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Dolar","","","","","Ufir","","","","","Euro","","","","","Iene","","","","","","","","","AL",""})
aAdd(aRegs,{cPerg,"06","Convers�o           ?","","","mv_ch6","N",01,0,0,"C","","mv_par06","Do Dia","","","","","Do Faturamento","","","","","","","","","","","","","","","","","","","AL",""})
//����������������������������������������������������������������������������Ŀ
//�Verificacao e/ou gravacao das perguntas no arquivo SX1                     .�
//������������������������������������������������������������������������������
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
		SEND MAIL FROM cConta TO cEmail CC "mpaladini@commcenter.com.br" SUBJECT "Faturamento Di�rio CommCenter" BODY cLin Result lSend
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
