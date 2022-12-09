#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SHREL01   º Autor ³ FABIANO B.CARA     º Data ³  01/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de ficha cadastral de funcionario                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Shangri-la                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SHREL01


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "Ficha Cadastral"
Private cPict          := ""
Private titulo       := "Ficha Cadastral"
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := ""
Private imprime      := .T.
Private aOrd 			:= {"Matricula","Nome","Centro de Custo"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "SHREL01" 
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := PADR("SHRL1",LEN(SX1->X1_GRUPO))
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "SHREL01" 
Private cString := "SRA"

dbSelectArea("SRA")
dbSetOrder(1)

SHPerg()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  01/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Private nOrdem

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())
dbGoTop()

While !EOF()

	IncRegua()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

	IF SRA->RA_mat < MV_PAR01 .OR. SRA->RA_MAT > MV_PAR02    .or. ;
		SRA->RA_nome < MV_PAR03 .OR. SRA->RA_nome > MV_PAR04  .or. ;
		SRA->RA_CC < MV_PAR05 .OR. SRA->RA_CC > MV_PAR06
	   SRA->(DbSkip())
	   Loop
	ENDIF
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Titulo:="FICHA DE FUNCIONARIOS"
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin++
   Endif

	ImpFicha()

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ImpFicha


//Cabecalho
//                  012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                            1         2         3         4         5         6         7         8
SRJ->(DbSeek(XFilial("SRJ")+SRA->RA_codfunc))
SI3->(DbSeek(XFilial("SI3")+SRA->RA_cc))
nLin:=8
@ ++nLin, 000 Psay "|------------------------------------------------------------------------------|"
@ ++nLin, 000 Psay "|USO RESTRITO DA EMPRESA                                     Matricula: "+SRA->RA_mat+" |"
@ ++nLin, 000 Psay "|Empresa: "+PADR(SM0->M0_nome,48)+"  Admissao: "+Dtoc(SRA->RA_admissa)+" |"
@ ++nLin, 000 Psay "|Funcao: "+Padr(SRJ->RJ_desc,20)+"   Salario: "+Transform(SRA->RA_salario,"@E 999,999.99")+"    Experiencia: "+Transform(SRA->(RA_vctoexp - RA_admissa),"999")+" dias   |"
@ ++nLin, 000 Psay "|Exame Admissional: "+Dtoc(SRA->RA_examedi)+"                                                   |"
@ ++nLin, 000 Psay "|Centro de Custo:  ("+IF('ESPANADOR'$UPPER(SI3->I3_DESC),'X',' ')+")Espanador    ("+IF('ROBSON'$UPPER(SI3->I3_DESC),'X',' ')+")Robson      ("+IF('ESCOVAS'$UPPER(SI3->I3_DESC),'X',' ')+")Escovas     ("+IF('GERAL'$UPPER(SI3->I3_DESC),'X',' ')+")Prod Geral |"
@ ++nLin, 000 Psay "|                  ("+IF('INJECAO'$UPPER(SI3->I3_DESC),'X',' ')+")Injecao      ("+IF('EXTRUSAO'$UPPER(SI3->I3_DESC),'X',' ')+")Extrusao    ("+IF('VIVEIRO'$UPPER(SI3->I3_DESC),'X',' ')+")Viveiro     ("+IF('MARABU'$UPPER(SI3->I3_DESC),'X',' ')+")Marabu     |"
@ ++nLin, 000 Psay "|                  ("+IF('MANUTENCAO'$UPPER(SI3->I3_DESC),'X',' ')+")Manutencao   ("+IF('RECUPERACAO'$UPPER(SI3->I3_DESC),'X',' ')+")Recuperacao ("+IF('ADMINISTRATIVO'$UPPER(SI3->I3_DESC),'X',' ')+")Administrativo            |" 
@ ++nLin, 000 Psay "|                  ( )_______________                                          |" 
SPJ->(DbSeek(XFilial("SPJ")+SRA->RA_TNOTRAB+"012"))
@ ++nLin, 000 Psay "|Turno de Trabalho: Segunda Feira das "+Transform(SPJ->PJ_ENTRA1*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA1*100,"@R 99:99")+" e das "+Transform(SPJ->PJ_ENTRA2*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA2*100,"@R 99:99")+"      |" 
SPJ->(DbSkip())
@ ++nLin, 000 Psay "|Turno de Trabalho:   Terça Feira das "+Transform(SPJ->PJ_ENTRA1*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA1*100,"@R 99:99")+" e das "+Transform(SPJ->PJ_ENTRA2*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA2*100,"@R 99:99")+"      |" 
SPJ->(DbSkip())
@ ++nLin, 000 Psay "|Turno de Trabalho:  Quarta Feira das "+Transform(SPJ->PJ_ENTRA1*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA1*100,"@R 99:99")+" e das "+Transform(SPJ->PJ_ENTRA2*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA2*100,"@R 99:99")+"      |" 
SPJ->(DbSkip())
@ ++nLin, 000 Psay "|Turno de Trabalho:  Quinta Feira das "+Transform(SPJ->PJ_ENTRA1*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA1*100,"@R 99:99")+" e das "+Transform(SPJ->PJ_ENTRA2*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA2*100,"@R 99:99")+"      |" 
SPJ->(DbSkip())
@ ++nLin, 000 Psay "|Turno de Trabalho:   Sexta Feira das "+Transform(SPJ->PJ_ENTRA1*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA1*100,"@R 99:99")+" e das "+Transform(SPJ->PJ_ENTRA2*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA2*100,"@R 99:99")+"      |" 
SPJ->(DbSkip())
@ ++nLin, 000 Psay "|Turno de Trabalho:        Sabado das "+Transform(SPJ->PJ_ENTRA1*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA1*100,"@R 99:99")+" e das "+Transform(SPJ->PJ_ENTRA2*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA2*100,"@R 99:99")+"      |" 
SPJ->(DbSkip())
@ ++nLin, 000 Psay "|Turno de Trabalho:       Domingo das "+Transform(SPJ->PJ_ENTRA1*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA1*100,"@R 99:99")+" e das "+Transform(SPJ->PJ_ENTRA2*100,"@R 99:99")+" as "+Transform(SPJ->PJ_SAIDA2*100,"@R 99:99")+"      |" 
SPJ->(DbSkip())
@ ++nLin, 000 Psay "|------------------------------------------------------------------------------|"
//                  012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                            1         2         3         4         5         6         7         8
@ ++nLin, 000 Psay "|CADASTRO                                                                      |"
@ ++nLin, 000 Psay "|Nome: "+Padr(SRA->RA_nome,40)+"                                |"
@ ++nLin, 000 Psay "|Endereco: "+Padr(SRA->RA_enderec,40)+" Complemento: "+Padr(SRA->RA_complem,13)+" |"
@ ++nLin, 000 Psay "|Bairro: "+Padr(SRA->RA_bairro,20)+"   Cidade: "+Padr(SRA->RA_municip,22)+"                 |"
@ ++nLin, 000 Psay "|Estado: "+Padr(SRA->RA_estado,02)+"   CEP: "+Transform(SRA->RA_cep,"@R 99999-999")+"   Telefone: "+Transform(SRA->RA_telefon,"@R (999)9999-999999")+"                      |"
@ ++nLin, 000 Psay "|Nome Pai: "+Padr(SRA->RA_PAI,27)+"   Nome Mae: "+Padr(SRA->RA_MAE,27)+" |"
@ ++nLin, 000 Psay "|Sexo: "+IF(SRA->RA_SEXO="M","Masculino","Feminino")+"  Estado Civil: ("+IF(SRA->RA_ESTCIVI=="S","X"," ")+")Solteiro ("+IF(SRA->RA_ESTCIVI=="A","X"," ")+")Amigado ("+IF(SRA->RA_ESTCIVI=="D","X"," ")+")Divorciado ("+IF(SRA->RA_ESTCIVI=="V","X"," ")+") Viuvo |"
SRB->(DbSeek(XFilial("SRB")+SRA->RA_mat))
_cong:=Space(23)
Do While SRB->RB_mat == SRA->RA_mat .And. !SRB->(EOF())
	IF SRB->RB_graupar = "C"
		_cong:=SRB->RB_nome
	ENDIF
   SRB->(DbSkip())
EndDo
SX5->(DbSeek(XFilial("SX5")+"12"+SRA->RA_natural))
_natur:=SX5->X5_DESCRI
SX5->(DbSeek(XFilial("SX5")+"34"+SRA->RA_naciona))
_nacio:=SX5->X5_DESCRI
@ ++nLin, 000 Psay "|Data Nascimento: "+DTOC(SRA->RA_NASC)+"    ("+IF(SRA->RA_ESTCIVI=="C","X"," ")+")Casado  Nome Conjuge: "+Padr(_cong,20)+" |"
@ ++nLin, 000 Psay "|Naturalidade: "+Padr(_NATUR,20)+"   Nacionalidade: "+Padr(_NACIO,23)+"      |"
SA6->(DbSeek(XFilial("SA6")+SRA->RA_BCDEPSA))
@ ++nLin, 000 Psay "|Possui conta Bancaria ? ("+IF(!EMPTY(SRA->RA_CTDEPSA),"X"," ")+")Sim ("+IF(EMPTY(SRA->RA_CTDEPSA),"X"," ")+")Nao   Banco: "+PADR(SA6->A6_NOME,10)+" Ag/Cta: "+SRA->RA_BCDEPSA+"    |"
@ ++nLin, 000 Psay "|Escolaridade:("+IF(SRA->RA_GRINRAI=="10","X"," ")+")Analfabeto        ("+IF(SRA->RA_GRINRAI=="20","X"," ")+")4a Serie incompleto ("+IF(SRA->RA_GRINRAI=="25","X"," ")+")4a Serie Completo |"
@ ++nLin, 000 Psay "|             ("+IF(SRA->RA_GRINRAI=="30","X"," ")+")8a Serie incompl  ("+IF(SRA->RA_GRINRAI=="35","X"," ")+")8a Serie Completo   ("+IF(SRA->RA_GRINRAI=="40","X"," ")+")Colegial Incompl  |"
@ ++nLin, 000 Psay "|             ("+IF(SRA->RA_GRINRAI=="45","X"," ")+")Colegial Completo ("+IF(SRA->RA_GRINRAI=="50","X"," ")+")Superior Incompleto ("+IF(SRA->RA_GRINRAI=="55","X"," ")+")Superior Completo |"
@ ++nLin, 000 Psay "|             ("+IF(SRA->RA_GRINRAI=="65","X"," ")+")Mestrado          ("+IF(SRA->RA_GRINRAI=="75","X"," ")+")Doutorado           ( )_________________ |"
@ ++nLin, 000 Psay "|------------------------------------------------------------------------------|"
@ ++nLin, 000 Psay "|DOCUMENTOS                                                                    |"
@ ++nLin, 000 Psay "|RG: "+TRANSFORM(SRA->RA_RG,"@R 99.999.999-99")+"    Emissao: "+DTOC(SRA->RA_ADMISSA)+"       UF: "+SRA->RA_ESTADO+"     CPF: "+TRANSFORM(SRA->RA_CIC,"@R 999.999.999-99")+"   |"
@ ++nLin, 000 Psay "|PIS:"+TRANSFORM(SRA->RA_PIS,"@R 999.999.999.999")+"  Dt.Cadastro PIS: "+DTOC(SRA->RA_ADMISSA)+"     Banco: _________________   |"
@ ++nLin, 000 Psay "|Cart.Prof: "+PADR(SRA->RA_NUMCP,10)+"  Serie: "+PADR(SRA->RA_SERCP,10)+"  Est.: "+SRA->RA_UFCP+" Tit.Eleitor: "+PADR(SRA->RA_TITULOE,12)+"  |"
@ ++nLin, 000 Psay "|Zona/Secao: "+PADR(SRA->RA_ZONASEC,10)+"                     Cart.Motorista: "+PADR(SRA->RA_HABILIT,12)+"       |"
@ ++nLin, 000 Psay "|Carteira Reservista: "+PADR(SRA->RA_RESERVI,15)+"  Data Dispensa: __/__/____               |"
@ ++nLin, 000 Psay "|------------------------------------------------------------------------------|"

Titulo:= "FICHA DE FUNCIONARIOS - BENEFICIOS"
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 8
@ ++nLin, 000 Psay "|-------------------------------------------------------------------------------|"
@ ++nLin, 000 Psay "|* Filhos maiores de 14 anos: 999   Filhos menores de 14 anos: 999             |"
@ ++nLin, 000 Psay "|  (Anexar xerox de RG e/ou certidao de nascimento de filhos)                  |"
@ ++nLin, 000 Psay "|                                                                              |"
@ ++nLin, 000 Psay "|* Tem interesse em adquirir plano de saude e gostaria maiores informacoes     |"
@ ++nLin, 000 Psay "|  ( )Sim   ( )Nao                                                             |"
@ ++nLin, 000 Psay "|                                                                              |"
@ ++nLin, 000 Psay "|* Voce necessita de conducao para trabalhar ?                                 |"
@ ++nLin, 000 Psay "|  ( )Sim   ( )Nao                                                             |"
@ ++nLin, 000 Psay "|                                                                              |"
@ ++nLin, 000 Psay "|* Voce paga pensao alimenticia ?                                              |"
@ ++nLin, 000 Psay "|  ( )Sim   ( )Nao                                                             |"
@ ++nLin, 000 Psay "|------------------------------------------------------------------------------|"
@ ++nLin, 000 Psay "|PERFIL                                                                        |"
@ ++nLin, 000 Psay "|Cor dos cabelos: _______________   Cor dos olhos: ________________            |"
@ ++nLin, 000 Psay "|Peso: ________   Altura: ________                                             |"
@ ++nLin, 000 Psay "|Raca: ("+IF(SRA->RA_RACACOR=="2","X"," ")+")Branca  ("+IF(SRA->RA_RACACOR=="4","X"," ")+")Negra  ("+IF(SRA->RA_RACACOR=="6","X"," ")+")Amarela  ("+IF(SRA->RA_RACACOR=="8","X"," ")+")Parda  ("+IF(SRA->RA_RACACOR=="1","X"," ")+")Indigena                  |"
@ ++nLin, 000 Psay "|------------------------------------------------------------------------------|"
@ ++nLin, 000 Psay "|                                                                              |"
@ ++nLin, 000 Psay "|                                                                              |"
@ ++nLin, 000 Psay "|                                                                              |"
@ ++nLin, 000 Psay "|                                                                              |"
@ ++nLin, 000 Psay "|   DECLARO QUE TODAS AS INFORMACOES PRESTADAS NESTA FICHA SAO VERDADEIRAS     |"
@ ++nLin, 000 Psay "|                                                                              |"
@ ++nLin, 000 Psay "|                                                                              |"
@ ++nLin, 000 Psay "|                                                                              |"
@ ++nLin, 000 Psay "|ANEXAR OS SEGUINTE DOCUMENTOS                                                 |"
@ ++nLin, 000 Psay "|                                                                              |"
@ ++nLin, 000 Psay "|+----+---------------------------------------------------------+----+         |"
@ ++nLin, 000 Psay "||Item| Descricao                                               | OK |         |"
@ ++nLin, 000 Psay "||----+---------------------------------------------------------+----+         |"
@ ++nLin, 000 Psay "|| 01 | Xerox de RG                                             |    |         |"
@ ++nLin, 000 Psay "||----+---------------------------------------------------------+----+         |"
@ ++nLin, 000 Psay "|| 02 | Xerox de CPF                                            |    |         |"
@ ++nLin, 000 Psay "||----+---------------------------------------------------------+----+         |"
@ ++nLin, 000 Psay "|| 03 | Xerox de comprovante de endereco                        |    |         |"
@ ++nLin, 000 Psay "||----+---------------------------------------------------------+----+         |"
@ ++nLin, 000 Psay "|| 04 | Xerox de comprovante de casamento e RG conjuge          |    |         |"
@ ++nLin, 000 Psay "||----+---------------------------------------------------------+----+         |"
@ ++nLin, 000 Psay "|| 05 | Xerox de certidao de nascimento ou RG dos filhos        |    |         |"
@ ++nLin, 000 Psay "||----+---------------------------------------------------------+----+         |"
@ ++nLin, 000 Psay "|| 06 | Xerox de acordo judicial se voce paga pensao alimenticia|    |         |"
@ ++nLin, 000 Psay "|+----+---------------------------------------------------------+----+         |"
@ ++nLin, 000 Psay "|                                                                              |"
@ ++nLin, 000 Psay "|------------------------------------------------------------------------------|"

nLin := 150

Return
//--------------------------------------------------------------------------------------
Static Function SHPerg

cPerg := PADR(cPerg,10)
aRegs :={}
aAdd(aRegs,{cPerg,"01","Matricula De       ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"02","Matricula Ate      ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"03","Nome De            ?","","","mv_ch3","C",30,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"04","Nome Ate           ?","","","mv_ch4","C",30,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"05","C.Custo de         ?","","","mv_ch5","C",09,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SI3",""})
aAdd(aRegs,{cPerg,"06","C.Custo ate        ?","","","mv_ch6","C",09,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SI3",""})
ValidPerg(aRegs,cPerg)

Return
//--------------------------------------------------------------------------------------

