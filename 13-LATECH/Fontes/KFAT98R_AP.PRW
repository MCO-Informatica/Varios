#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Kfat98r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AESTRU1,_CTEMP1,WNREL,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,LEND,TAMANHO,LIMITE,TITULO,ARETURN")
SetPrvt("NOMEPROG,NLASTKEY,ADRIVER,CBCONT,CPERG,NLIN")
SetPrvt("M_PAG,_NTOTQTD,_NTOTFAT,_NTOTSAL,_NTOTVLR,_NTQTD")
SetPrvt("_NTFAT,_NTSAL,_NTVLR,_CCHAVE,I,_CNOMECLI")
SetPrvt("_NQTDSALDO,CTITADD1,CABEC1,CABEC2,REGUA1,REGUA2")
SetPrvt("_CINDEX,_LFLAGNAT,_CDESCNATU,_CPEDLINHA,_CAUXCLI,_CAUXPRO")
SetPrvt("_CAUXPED,_DAUXDAT,_CAUXNAT,AREGS,J,")



aEstru1 :={}
AADD(aEstru1,{"EMAIL"   ,"C",150,0})
AADD(aEstru1,{"ULTCOM"  ,"D",08,0})
AADD(aEstru1,{"NOME" 	,"C",60,0})
AADD(aEstru1,{"FANTASIA","C",20,0})
AADD(aEstru1,{"TIPREV"  ,"C",01,0})
AADD(aEstru1,{"SITUACA" ,"C",01,0})
AADD(aEstru1,{"VENDED"  ,"C",06,0})
AADD(aEstru1,{"UF"  	,"C",02,0})
AADD(aEstru1,{"MUNIC"   ,"C",60,0})
AADD(aEstru1,{"TELEF"   ,"C",20,0})
AADD(aEstru1,{"CNPJ"    ,"C",14,0})
AADD(aEstru1,{"CODIGO"  ,"C",06,0})
AADD(aEstru1,{"LOJA"    ,"C",02,0})
AADD(aEstru1,{"PESSOA"  ,"C",01,0})
AADD(aEstru1,{"CONTATO" ,"C",15,0})
AADD(aEstru1,{"RISCO"   ,"C",01,0})

_cTemp1 := CriaTrab( aEstru1, .T. )
dbUseArea(.T.,,_cTemp1,"TRB",IF(.T. .OR. .F., !.F., NIL), .F. )

cPerg := "KFAT98R"

//ValidPerg()     //----> Atualiza o arquivo de perguntas SX1

Pergunte(cPerg,.T.)

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Processa({||RunProc()},"Mala Direta Prospeccao")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(RunProc)},"Pedidos de Venda em Aberto")
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function RunProc
Static Function RunProc()


_cQuery :=	""

_cQuery +=	"SELECT DISTINCT "
_cQuery +=	"A1_EMAIL 'EMAIL', "
_cQuery +=	"A1_ULTCOM 'ULTCOM', "
_cQuery +=	"A1_NOME 'NOME', "
_cQuery +=	"A1_NREDUZ 'FANTASIA', "
_cQuery +=	"A1_X_TIPO 'REVENDA', "
_cQuery +=	"A1_STATUS 'SITUACAO', "
_cQuery +=	"A1_VEND 'VENDEDOR', "
_cQuery +=	"A1_EST 'UF', "
_cQuery +=	"A1_MUN 'MUNIC', "
_cQuery +=	"A1_TEL 'TELEF', "
_cQuery +=	"A1_CGC 'CNPJ', "
_cQuery +=	"A1_COD 'CODIGO', "
_cQuery +=	"A1_LOJA 'LOJA', "
_cQuery +=	"A1_PESSOA 'PESSOA', "
_cQuery +=	"A1_CONTATO 'CONTATO', "
_cQuery +=	"A1_RISCO 'RISCO' "
_cQuery +=	"FROM SA1010 SA1 "
_cQuery +=	"WHERE SA1.D_E_L_E_T_='' "
_cQuery +=	"AND A1_NREDUZ BETWEEN '"+ALLTRIM(MV_PAR01)+"' AND '"+ALLTRIM(MV_PAR02)+"' "
_cQuery +=	"AND A1_NOME BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' "
_cQuery +=	"AND A1_COD BETWEEN '"+ALLTRIM(MV_PAR05)+"' AND '"+ALLTRIM(MV_PAR07)+"' "
_cQuery +=	"AND A1_LOJA BETWEEN '"+ALLTRIM(MV_PAR06)+"' AND '"+ALLTRIM(MV_PAR08)+"' "
_cQuery +=	"AND A1_COD BETWEEN '"+ALLTRIM(MV_PAR05)+"' AND '"+ALLTRIM(MV_PAR07)+"' "
_cQuery +=	"AND A1_VEND BETWEEN '"+ALLTRIM(MV_PAR09)+"' AND '"+ALLTRIM(MV_PAR10)+"' "
_cQuery +=	"AND A1_EST BETWEEN '"+ALLTRIM(MV_PAR11)+"' AND '"+ALLTRIM(MV_PAR12)+"' "
_cQuery +=	"AND A1_MUN BETWEEN '"+ALLTRIM(MV_PAR13)+"' AND '"+ALLTRIM(MV_PAR14)+"' "

If !Empty(MV_PAR15)
	_cQuery +=	"AND A1_ULTCOM BETWEEN '"+DTOS(MV_PAR15)+"' AND '"+DTOS(MV_PAR16)+"' "
EndIf

If !Empty(MV_PAR17)
	_cQuery +=	"AND A1_X_TIPO = '"+ALLTRIM(MV_PAR17)+"' "
EndIf	

If !Empty(MV_PAR18)
	_cQuery +=	"AND A1_STATUS = '"+ALLTRIM(MV_PAR18)+"' "
EndIf	

If !Empty(MV_PAR19)
	_cQuery +=	"AND A1_EMAIL LIKE '%"+ALLTRIM(MV_PAR19)+"%' "
EndIf

_cQuery +=	"ORDER BY A1_NOME "


MEMOWRIT("C:\SQLREL.txt",_cQuery)
_cQuery := ChangeQuery(_cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"SQL", .F., .T.)

TCSETFIELD( "SQL","ULTCOM","D")

dbSelectArea("SQL")
ProcRegua(RecCount())

Do While !Eof()
	
	IncProc("Selecionando Dados do Cliente: "+SQL->CODIGO+"/"+SQL->LOJA+" "+SQL->FANTASIA)
	
	DbSelectArea("TRB")
	RecLock("TRB",.t.)
	TRB->EMAIL    :=      SQL->EMAIL
	TRB->ULTCOM   :=      SQL->ULTCOM
	TRB->NOME     :=      SQL->NOME
	TRB->FANTASIA :=      SQL->FANTASIA
	TRB->TIPREV   :=      SQL->REVENDA
	TRB->SITUACA  :=      SQL->SITUACAO
	TRB->VENDED   :=      SQL->VENDEDOR
	TRB->UF		  :=      SQL->UF
	TRB->MUNIC    :=      SQL->MUNIC
	TRB->TELEF    :=      SQL->TELEF
	TRB->CNPJ     :=      SQL->CNPJ
	TRB->CODIGO   :=      SQL->CODIGO
	TRB->LOJA     :=      SQL->LOJA
	TRB->PESSOA   :=      SQL->PESSOA
	TRB->CONTATO  :=      SQL->CONTATO
	TRB->RISCO    :=      SQL->RISCO
	MsUnLock()
	
	DbSelectArea("SQL")
	DbSkip()
EndDo

DbSelectArea("SQL")
DbCloseArea("SQL")

DbSelectArea("TRB")
//----> cria um arquivo dbf para importacao no excel
_cNomeDbf := ALLTRIM(MV_PAR21)
Copy To &_cNomeDbf VIA "DBFCDXADS"

CpyS2T( _cNomeDbf, "C:\TOTVS12\", .F. )

//----> seleciono o SX1 para limpar a 15 pergunta para geracao do dbf para excel
DbSelectArea('SX1')
If DbSeek('KFAT98R01')
	RecLock('SX1',.F.)
	SX1->X1_CNT01 := ''
	MsUnLock()
EndIf

DbSelectArea("TRB")
DbCloseArea("TRB")
Ferase(_cTemp1+".dbf")
Ferase(_cTemp1+".idx")
Ferase(_cTemp1+".mem")

MS_FLUSH()

Return

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()

DbSelectArea("SX1")
DbSetOrder(1)
If !DbSeek(cPerg)
	
	aRegs := {}
	
	aadd(aRegs,{cPerg,'01','Do Fantasia    ? ','mv_ch1','C',20, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'02','Ate o Fantasia ? ','mv_ch2','C',20, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'03','Do Nome        ? ','mv_ch3','C',60, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'04','Ate o Nome     ? ','mv_ch4','C',60, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'05','Do Cliente     ? ','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','SA1'})
	aadd(aRegs,{cPerg,'06','Da Loja        ? ','mv_ch6','C',02, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'07','Ate o Cliente  ? ','mv_ch7','C',06, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','','SA1'})
	aadd(aRegs,{cPerg,'08','Ate a Loja     ? ','mv_ch8','C',02, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'09','Do Vendedor    ? ','mv_ch9','C',06, 0, 0,'G', '', 'mv_par09','','','','','','','','','','','','','','','SA3'})
	aadd(aRegs,{cPerg,'10','Ate o Vendedor ? ','mv_cha','C',06, 0, 0,'G', '', 'mv_par10','','','','','','','','','','','','','','','SA3'})
	aadd(aRegs,{cPerg,'11','Do Estado      ? ','mv_chb','C',02, 0, 0,'G', '', 'mv_par11','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'12','Ate o Estado   ? ','mv_chc','C',02, 0, 0,'G', '', 'mv_par12','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'13','Do Municipio   ? ','mv_chd','C',60, 0, 0,'G', '', 'mv_par13','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'14','Ate o Municipio? ','mv_che','C',60, 0, 0,'G', '', 'mv_par14','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'15','Da Ult Compra  ? ','mv_chf','D',08, 0, 0,'G', '', 'mv_par15','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'16','Ate Ult Compra ? ','mv_chg','D',08, 0, 0,'G', '', 'mv_par16','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'17','Tipo Revenda   ? ','mv_chh','C',01, 0, 0,'G', '', 'mv_par17','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'18','Situacao       ? ','mv_chi','C',01, 0, 0,'G', '', 'mv_par18','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'19','Email Contem   ? ','mv_chj','C',150, 0, 0,'G', '','mv_par19','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'20','Ultimo Pedido  ? ','mv_chk','N',01, 0, 0,'C', '', 'mv_par20','','','','','','','','','','','','','','',''})
	aadd(aRegs,{cPerg,'21','Nome Arquivo   ? ','mv_chl','C',20, 0, 0,'C', '', 'mv_par21','','','','','','','','','','','','','','',''})
	
	For i:=1 to Len(aRegs)
		Dbseek(cPerg+StrZero(i,2))
		If found() == .f.
			RecLock("SX1",.t.)
			For j:=1 to Fcount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnLock()
		EndIf
	Next
EndIf

Return()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retorna para sua Chamada (KFAT98R)                                        *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

