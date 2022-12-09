#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSFR0003  �Autor  �SEITI               � Data �  26/10/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �AR                            					          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �AR                                   						  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function CSFR0003()


SetPrvt("ARETURN,NLASTKEY,CPERG,CSTRING,WNREL,CNOMEPROG")
SetPrvt("CTITULO,CDESC1,CDESC2,CDESC3,AORD,CTAMANHO")


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
//cPerg    := "RTEC03"  // Parametro  cadastrado do SX1
//ValidPerg("RTEC03")
cPerg    := PADR("RTEC03",len(SX1->X1_GRUPO))  // Parametro  cadastrado do SX1
//ValidPerg("RTEC03")
ValidPerg(PADR("RTEC03",len(SX1->X1_GRUPO)))
pergunte(cPerg,.F.)
//��������������������������������������������������������������Ŀ
//�     Variaveis tipo Local padrao de todos os relatorios       �
//����������������������������������������������������������������
cString  := "SB1" // Alias do Arquivo principal
wnrel    := "CSFR003"  // Nome do Relatorio para impressao em arquivo
cNomeProg:= "CSFR003"
ctitulo  := "AR"
cDesc1   := "AR"
cDesc2   := " "
cDesc3   := "Especifico CertiSign"
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


RptStatus({|| Imprimir()})

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
Select PA0_STATUS, PA0_OS, PA0_CLILOC, PA0_LOJLOC, PA0_CLLCNO, PA0_END, PA0_BAIRRO, PA0_BAIRRO, PA0_CEP, PA0_CONTAT, PA0_TEL, PA0_RAMAL, PA0_CIDADE,
PA0_ESTADO, PA0_CLIFAT,PA0_LOJAFA,
PA0_CONDPA, PA0_PROJET, PA0_OS, PA0_HRAGEN, PA0_DTAGEN,PA0_OBS
From %Table:PA0% PA0
Where PA0.%NotDel% and PA0_OS Between %Exp:MV_PAR01% and %Exp:MV_PAR02%
and PA0_CLILOC Between %Exp:MV_PAR05% and %Exp:MV_PAR06%
and PA0_DTAGEN Between %Exp:DToS(MV_PAR07)% and %Exp:DToS(MV_PAR08)%
and PA0_OS In (Select PA2_NUMOS From %Table:PA2% PA2
Where PA2.%NotDel% and PA2_CODTEC Between %Exp:MV_PAR03% and %Exp:MV_PAR04%)
EndSql

DbSelectArea("TRB")

ProcRegua( LastRec() )

_nCont:= 0

If !Empty(TRB->PA0_OS)
		
		Do While !Eof()
		
		nLin := 0
		nLin:= nLin+ 1		
		@ nLin,00 PSay __PrtThinLine()
		nLin:= nLin+ 1
		@ nLin,090 PSAY "Local de Atendimento"

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin:= nLin+ 1
		@ nLin,001 PSAY "Cliente: "+ AllTrim(TRB->PA0_CLLCNO)
		@ nLin,099 PSAY "|"
		@ nLin,100 PSAY "Cidade: "+ AllTrim(TRB->PA0_CIDADE)
		@ nLin,149 PSAY "|"
		@ nLin,150 PSAY "Estado: "+ AllTrim(TRB->PA0_ESTADO)
		@ nLin,200 PSAY "|"

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin:= nLin+ 1
		@ nLin,001 PSAY "Endere�o: " + AllTrim(TRB->PA0_END)
		@ nLin,099 PSAY "|"
		@ nLin,100 PSAY "Bairro: " + AllTrim(TRB->PA0_BAIRRO)
		@ nLin,149 PSAY "|"
		@ nLin,150 PSAY "CEP: " + AllTrim(TRB->PA0_CEP)
		@ nLin,200 PSAY "|"		
	
		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin := nLin + 1
		DbSelectArea("SA1")      
		DbSetOrder(1)
		DbGoTop()                 
		DbSeek(xFilial("SA1")+TRB->PA0_CLILOC+TRB->PA0_LOJLOC)
		@ nLin,001 PSAY "Contato: "+ AllTrim(TRB->PA0_CONTAT)
		@ nLin,099 PSAY "|"
		@ nLin,100 PSAY "Telefone: "+ AllTrim(TRB->PA0_TEL)
		@ nLin,124 PSAY "|"
		@ nLin,125 PSAY "Ramal: "+ AllTrim(TRB->PA0_RAMAL)
		@ nLin,139 PSAY "|"
		@ nLin,140 PSAY "E-mail: "+ AllTrim(SA1->A1_EMAIL)
 		@ nLin,200 PSAY "|"		

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin := nLin + 1
		@ nLin,090 PSAY "Cliente para faturamento"

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin:= nLin+ 1
		DbSelectArea("SA1")      
		DbSetOrder(1)
		DbGoTop()                 
		DbSeek(xFilial("SA1")+TRB->PA0_CLIFAT+TRB->PA0_LOJAFA)
		@ nLin,001 PSAY "Cliente: "+ AllTrim(SA1->A1_COD) +" - " + AllTrim(SA1->A1_NOME)
		@ nLin,088 PSAY "|"
		@ nLin,089 PSAY "CNPJ/CPF: "+ AllTrim(SA1->A1_CGC)
		@ nLin,119 PSAY "|"
		@ nLin,120 PSAY "Incr.Est.: "+ AllTrim(SA1->A1_INSCR)
		@ nLin,149 PSAY "|"
		@ nLin,150 PSAY "Cidade: "+ AllTrim(SA1->A1_MUN)
		@ nLin,187 PSAY "|"
		@ nLin,188 PSAY "Estado: "+ AllTrim(SA1->A1_EST)
		@ nLin,200 PSAY "|"

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin:= nLin+ 1
		@ nLin,001 PSAY "Endere�o: " + AllTrim(SA1->A1_END)
		@ nLin,099 PSAY "|"
		@ nLin,100 PSAY "Bairro: " + AllTrim(SA1->A1_BAIRRO)
		@ nLin,149 PSAY "|"
		@ nLin,150 PSAY "CEP: " + AllTrim(SA1->A1_CEP)
		@ nLin,200 PSAY "|"		
	
		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin := nLin + 1
		@ nLin,001 PSAY "Contato: "+ AllTrim(SA1->A1_CONTATO)
		@ nLin,099 PSAY "|"
		@ nLin,100 PSAY "Telefone: "+ AllTrim(SA1->A1_DDD)+AllTrim(SA1->A1_TEL)
		@ nLin,124 PSAY "|"
		@ nLin,125 PSAY "Ramal: "//+ AllTrim(TRB->PA0_RAMAL)
		@ nLin,139 PSAY "|"
		@ nLin,140 PSAY "E-mail: "+ AllTrim(SA1->A1_EMAIL)
 		@ nLin,200 PSAY "|"		

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin := nLin + 1
		@ nLin,001 PSAY "Atendimento: "+ AllTrim(TRB->PA0_OS)
		@ nLin,066 PSAY "|"
		@ nLin,067 PSAY "Projeto: "+ AllTrim(TRB->PA0_PROJET)
		@ nLin,122 PSAY "|"
		@ nLin,123 PSAY "Forma de Pagamento: "+ AllTrim(TRB->PA0_CONDPA)
 		@ nLin,200 PSAY "|"		

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin := nLin + 1
		@ nLin,001 PSAY "Transporte: "//+ AllTrim(TRB->PA0_OS)
		@ nLin,066 PSAY "|"
		@ nLin,067 PSAY "Custo do deslocamento: "//+ AllTrim(TRB->PA0_PROJET)
		@ nLin,122 PSAY "|"
		@ nLin,123 PSAY "Valor da visita: "//+ AllTrim(TRB->PA0_CONDPA)
 		@ nLin,200 PSAY "|"		

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin := nLin + 1
		@ nLin,001 PSAY "Data do Agendamento"
		@ nLin,021 PSAY "|"
		@ nLin,022 PSAY "Horario agendado"
		@ nLin,045 PSAY "|"
		@ nLin,046 PSAY "Horario de chegada"
		@ nLin,066 PSAY "|"
		@ nLin,067 PSAY "Horario de inicio"
		@ nLin,099 PSAY "|"
		@ nLin,100 PSAY "Horario termino"
		@ nLin,132 PSAY "|" 
		@ nLin,133 PSAY "Horas adicionais"//+ AllTrim(TRB->PA0_PROJET)
		@ nLin,166 PSAY "|"
		@ nLin,167 PSAY "Valor unitario hora"//+ AllTrim(TRB->PA0_CONDPA)
 		@ nLin,200 PSAY "|"		

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin := nLin + 1
		@ nLin,001 PSAY (SUBSTR(TRB->PA0_DTAGEN,7,2)+"/"+SUBSTR(TRB->PA0_DTAGEN,5,2)+"/"+SUBSTR(TRB->PA0_DTAGEN,1,4))
		@ nLin,021 PSAY "|"
		@ nLin,023 PSAY AllTrim(TRB->PA0_HRAGEN) 
		@ nLin,045 PSAY "|"
//		@ nLin,034 PSAY "Horario de chegada"
		@ nLin,066 PSAY "|"
//		@ nLin,067 PSAY "Horario de inicio"
		@ nLin,099 PSAY "|"
//		@ nLin,100 PSAY "Horario termino"
		@ nLin,132 PSAY "|"
//		@ nLin,133 PSAY "Horas adicionais"//+ AllTrim(TRB->PA0_PROJET)
		@ nLin,166 PSAY "|"
//		@ nLin,167 PSAY "Valor unitario hora"//+ AllTrim(TRB->PA0_CONDPA)
 		@ nLin,200 PSAY "|"		

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin := nLin + 1
		@ nLin,001 PSAY "Quantidade"
		@ nLin,021 PSAY "|"
		@ nLin,022 PSAY "Codigo do produto/Produto"
		@ nLin,150 PSAY "|"
		@ nLin,151 PSAY "Pedido"
		@ nLin,161 PSAY "|"
		@ nLin,162 PSAY "CNPJ/CPF"//+ AllTrim(TRB->PA0_PROJET)
		@ nLin,181 PSAY "|"
		@ nLin,182 PSAY "Valor"//+ AllTrim(TRB->PA0_CONDPA)
 		@ nLin,200 PSAY "|"		

		If Select("BRT") > 0
			DbSelectArea("BRT")
			DbCloseArea("BRT")
		End If

		BeginSql Alias "BRT"
			Select PA1_PRODUT, PA1_DESCRI, PA1_CNPJ, PA1_PEDIDO, PA1_VALOR,PA1_QUANT
			From %Table:PA1% PA1 
			Where PA1.%NotDel% and PA1_OS = %Exp:TRB->PA0_OS%
		EndSql
        _xCount	 := 0
        nItensAt := 0
		DbSelectArea("BRT")
		DbGoTop()
		Do While !Eof("BRT")
		    
			// 24/07/2013 - Renato Ruy
			// OTRS:2012061810000521
			// Gera nova p�gina quando o atendimento tem mais de 16 itens.
			
			If nItensAt > 14 // Salto de P�gina.
      			M_PAG 	 += 1
      			nLin  	 := 1
      			nItensAt := 0 
   			Endif
   			
   			// 24/07/2013 - Renato Ruy - Fim Altera��o

			nLin:= nLin+ 1
			@ nLin,00 PSay __PrtThinLine()
			nLin := nLin + 1
			@ nLin,001 PSAY BRT->PA1_QUANT
			@ nLin,020 PSAY "|"
			@ nLin,021 PSAY AllTrim(BRT->PA1_PRODUT)+ "-"+AllTrim(BRT->PA1_DESCRI)
			@ nLin,150 PSAY "|"
			@ nLin,151 PSAY AllTrim(BRT->PA1_PEDIDO)
			@ nLin,161 PSAY "|"
			@ nLin,162 PSAY AllTrim(BRT->PA1_CNPJ)
			@ nLin,181 PSAY "|"
			@ nLin,182 PSAY transf(BRT->PA1_VALOR,"@r 999,999,999.99")
 			@ nLin,200 PSAY "|"		
			nLin := nLin + 1
			@ nLin,150 PSAY "|"
			@ nLin,161 PSAY "|"
			@ nLin,181 PSAY "|"
 			@ nLin,200 PSAY "|"		
            
			nItensAt+= 1
			_xCount := _xCount + 1
		DbSkip()                                                 
		End Do
		For _i := 1 to (9-_xCount)
			nLin:= nLin+ 1
			@ nLin,00 PSay __PrtThinLine()
			nLin := nLin + 1
			@ nLin,150 PSAY "|"
			@ nLin,161 PSAY "|"
			@ nLin,181 PSAY "|"
 			@ nLin,200 PSAY "|"		

			nLin := nLin + 1
			@ nLin,150 PSAY "|"
			@ nLin,161 PSAY "|"
			@ nLin,181 PSAY "|"
 			@ nLin,200 PSAY "|"		
		
		Next _i

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin := nLin + 1
		@ nLin,001 PSAY "Observa��o: "
		@ nLin,150 PSAY "|"
		@ nLin,151 PSAY "Total a faturar "
		@ nLin,200 PSAY "|"		

		nLin := nLin + 1
		@ nLin,001 PSAY TRB->PA0_OBS
		@ nLin,150 PSAY "|"
		@ nLin,200 PSAY "|"		

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin := nLin + 1
		@ nLin,001 PSAY "Aprovo e autorizo o faturamento dos servi�os" 
		@ nLin,066 PSAY "|"
		@ nLin,067 PSAY "Data"
		@ nLin,132 PSAY "|"
		@ nLin,133 PSAY "Para uso da CertiSign Certificadora Digital"
		@ nLin,200 PSAY "|"		
 
		nLin := nLin + 1
		@ nLin,001 PSAY "de acordo com as condi��es acima"
		@ nLin,066 PSAY "|"
		@ nLin,132 PSAY "|"
		@ nLin,200 PSAY "|"		

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin := nLin + 1
		@ nLin,001 PSAY "Nome leg�vel"
		@ nLin,049 PSAY "|"
		@ nLin,050 PSAY "Assinatura com carimbo ou RG"
		@ nLin,099 PSAY "|"
		@ nLin,100 PSAY "Conferente AR"
		@ nLin,149 PSAY "|"
		@ nLin,150 PSAY "Conferente Dept Financeiro"
		@ nLin,200 PSAY "|"		

		nLin := nLin + 1
		@ nLin,049 PSAY "|"
		@ nLin,099 PSAY "|"
		@ nLin,149 PSAY "|"
		@ nLin,200 PSAY "|"		

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()
		nLin := nLin + 1
		@ nLin,001 PSAY "Nome do agente de valida��o"
		@ nLin,049 PSAY "|"
		@ nLin,050 PSAY "Assinatura agente de valida��o"
		@ nLin,099 PSAY "|"
		@ nLin,100 PSAY "Data AR"
		@ nLin,149 PSAY "|"
		@ nLin,150 PSAY "Data Financeiro"
		@ nLin,200 PSAY "|"		

		nLin := nLin + 1
		@ nLin,049 PSAY "|"
		@ nLin,099 PSAY "|"
		@ nLin,149 PSAY "|"
		@ nLin,200 PSAY "|"		

		nLin:= nLin+ 1
		@ nLin,00 PSay __PrtThinLine()



	DbSelectArea("TRB")
	DbSkip()
	End Do
	
End If

Set Device to Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

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
aAdd(aRegs,{cPerg,"01","Atendimento de      ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Atendimento ate     ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Tecnico de          ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","AA1",""})
aAdd(aRegs,{cPerg,"04","Tecnico ate         ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","AA1",""})
aAdd(aRegs,{cPerg,"05","Cliente de          ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"06","Cliente ate         ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"07","Data de             ?","","","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Date ate            ?","","","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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


