#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSFR0001  �Autor  �SEITI               � Data �  26/10/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rela�orio de materiais para atendimento                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rela�orio de materiais para atendimento                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function CSFR0001()


SetPrvt("ARETURN,NLASTKEY,CPERG,CSTRING,WNREL,CNOMEPROG")
SetPrvt("CTITULO,CDESC1,CDESC2,CDESC3,AORD,CTAMANHO")
SetPrvt("M_PAG,_COD,_PRD,_NPOS,_UN,_QUANT")
SetPrvt("_VLR,ADRIVER,INICIA,NLIN,NCOLMAX,CARQTMP")
SetPrvt("CIND01,CIND02,CIND03,NINDEX,_ARRAY,_VETOR")
SetPrvt("NPOS,_NCONTER,_DT,_AL,L_EST,_I,_VFOR,_NTPRZ,_NTPQZ,_VLRT")
SetPrvt("_J,N_MES,A_MES,C_MES,C_ANO,C_MESANO,_NTQTD,_NTVLR,_NTVLC,cDesc, _NCLI ")
SetPrvt("_NPQTD,_NPVLR,_NPVLC, _NPPRZ,_NPPQZ, _NUME")


#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 22/08/03 ==> 	#DEFINE PSAY SAY
#ENDIF
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

cperg := padr("RTEC01",LEN(SX1->X1_GRUPO))
//cPerg    :=   // Parametro  cadastrado do SX1
ValidPerg("RTEC01")

pergunte(cPerg,.F.)
//��������������������������������������������������������������Ŀ
//�     Variaveis tipo Local padrao de todos os relatorios       �
//����������������������������������������������������������������
cString  := "SB1" // Alias do Arquivo principal
wnrel    := "CSFR001"  // Nome do Relatorio para impressao em arquivo
cNomeProg:= "CSFR001"
ctitulo  := "Rela�orio de materiais para atendimento"
cDesc1   := "Rela�orio de materiais para atendimento"
cDesc2   := " "
cDesc3   := "Especifico CertiSign 25.10.06"
aOrd     := {}
cTamanho := "G"
M_PAG    := 1 // Variavel que incrementa pagina do Cabec
_COD     := " "
_PRD     := " "
_npos    := 0
_UN    := " "
_QUANT := 0
_VLR   := 0
_NTQTD := 0
_NTVLR := 0
_NTVLC := 0
_VFOR  := " "
_NTPRZ := 0
_NTPQZ := 0
_VLRT  := 0
_NPQTD := 0
_NPVLR := 0
_NPVLC := 0
_NPPRZ := 0
_NPPQZ := 0
_NUME := 0
cDesc  := "  "
_array := {}
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


//��������������������������������������������������������������Ŀ
//� Variaveis de controle especifico do programa                 �
//����������������������������������������������������������������
nLin    := 0
nColMax := 240 // Tamanho maximo do relat�rio

//��������������������������������������������������������������Ŀ
//� Array com mes por Extenso                                    �
//����������������������������������������������������������������


	RptStatus({|| Imprimir()})// Substituido pelo assistente de conversao do AP6 IDE em 22/08/03 ==> 	RptStatus({|| Execute(Imprimir)},,.F.)

Set Device to Screen

Return

//��������������������������������������������������������������������Ŀ
//� Cabecalho                                                          �
//����������������������������������������������������������������������


//��������������������������������������������������������������������Ŀ
//� Impressao                                                          �
//����������������������������������������������������������������������


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
Select PA2_CODTEC, (Select AA1_NOMTEC From %Table:AA1% AA1 Where AA1.%NotDel% and AA1_CODTEC = PA2_CODTEC) As PA2_NOMTEC, 
PA1_OS, PA1_ITEM, PA1_PRODUT, PA1_DESCRI, PA0_CLILOC, PA0_LOJLOC, PA0_CLLCNO, PA0_CONTAT, PA0_TEL 
From %Table:PA0% PA0, %Table:PA1% PA1, %Table:PA2% PA2 
Where PA0.%NotDel% and PA1.%NotDel% and PA2.%NotDel%
and PA0_OS = PA1_OS and PA0_OS = PA2_NUMOS 
and PA0_OS Between %Exp:MV_PAR01% and %Exp:MV_PAR02%
and PA0_CLILOC Between %Exp:MV_PAR05% and %Exp:MV_PAR06%
and PA0_DTAGEN Between %Exp:DToS(MV_PAR07)% and %Exp:DToS(MV_PAR08)%
and PA2_CODTEC Between %Exp:MV_PAR03% and %Exp:MV_PAR04%

Order By PA2_CODTEC
EndSql
DbSelectArea("TRB")

ProcRegua( LastRec() )

_nCont:= 0

If !Empty(TRB->PA2_CODTEC)
    _TEC := TRB->PA2_CODTEC
	nLin := 65
	if nliN > 60
		ImpCab()
	endif

	@ nLin,001 PSAY "Tecnico: "+AllTrim(TRB->PA2_CODTEC)+'-'+AllTrim(TRB->PA2_NOMTEC)
	nLin := nLin + 1
	DbGoTop()
	Do While !Eof("TRB")
	
		if nliN > 60
			ImpCab()
		endif
        If _TEC <> TRB->PA2_CODTEC 
			@ nLin,001 PSAY "Total de materiais: "
			@ nLin,021 PSAY transf(_nCont,"@r 999,999,999")
			_nCont:= 0
			nLin := nLin +2
			if nliN > 60
				ImpCab()
			endif
			@ nLin,001 PSAY "Tecnico: "+AllTrim(TRB->PA2_CODTEC)+'-'+AllTrim(TRB->PA2_NOMTEC)        
			nLin := nLin +1			
			if nliN > 60
				ImpCab()
			endif

		End If

		@ nLin,001 PSAY AllTrim(TRB->PA1_OS)
		@ nLin,008 PSAY AllTrim(TRB->PA1_PRODUT)+"-"+AllTrim(TRB->PA1_DESCRI)
		@ nLin,055 PSAY AllTrim(TRB->PA0_CLILOC)+"/"+AllTrim(TRB->PA0_LOJLOC)+"-"+AllTrim(TRB->PA0_CLLCNO)
		@ nLin,108 PSAY AllTrim(TRB->PA0_CONTAT)
		@ nLin,125 PSAY AllTrim(TRB->PA0_TEL)
		_nCont := _nCont + 1
	    _TEC := TRB->PA2_CODTEC		
		IncProc( )
		nLin := nLin +1
		
	DbSkip()
	End Do
	@ nLin,001 PSAY "Total de materiais: "
	@ nLin,021 PSAY transf(_nCont,"@r 999,999,999")
	nLin := nLin +1
	
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
@ nlin, 00 PSAY "N. Aten.             Materiais                                          Cliente                             Contato         Telefone"
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


