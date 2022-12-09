#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
        #DEFINE PSAY SAY
#ENDIF
#include "topconn.ch"

User Function Boleto()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("NORDEM,TAM,LIMITE,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,CNATUREZA,CSTRING,LCONTINUA,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,WNREL,CMENSAGEM1,CMENSAGEM2,CMENSAGEM3")
SetPrvt("CMENSAGEM4,CTITINI,CTITFIN,CPREINI,CPREFIN,NVALOR")
SetPrvt("CPREFIXO,CTITULO,CPARCELA,NREGIST,XCHAVE,NJUR")
SetPrvt("NJUROS,NTXDESC,NDESCONT,LI,CEND1,CEND2")
SetPrvt("CCEP,_APERGUNTAS,_NLACO,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==>         #DEFINE PSAY SAY
#ENDIF

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � BOLETO   � Autor � MARCOS GOMES          � Data � 15/09/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Boleto Bancario. BRADESCO                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Exclusivo para Clientes Microsiga - Kenia                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Do Titulo                            �
//� mv_par02             // Ate o Titulo                         �
//� mv_par03             // Do Prefixo                           �
//� mv_par04             // Ate o Prefixo                        �
//� mv_par05             // Da Parcela                           �
//� mv_par06             // Ate a Parcela                        �
//� mv_par07             // linha de mensagem 1                  �
//� mv_par08             // linha de mensagem 2                  �
//� mv_par09             // linha de mensagem 3                  �
//� mv_par10             // linha de mensagem 4                  �
//����������������������������������������������������������������

nOrdem     := 0
tam        := "P"
limite     := 80
titulo     := PADC("BOLETO",71)
cDesc1     := PADC("Este programa ira emitir Boleto bancario ",71)
cDesc2     := PADC("banco Bradesco. ",71)
cDesc3     := ""
cNatureza  := ""
cString    := "SE1" 
lContinua  :=  .T.
aReturn    :=  { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog   := "BOLETO"
nLastKey   :=  0
cPerg      := "BOLETO    "
wnrel      := "BOLETO"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas.                          �
//����������������������������������������������������������������

Perguntas()
pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,tam)

#IFNDEF WINDOWS
        If LastKey() == 27 .or. nLastKey == 27
                __RetProc()
        Endif
#ELSE
        If LastKey() == 27 .or. nLastKey == 27
                __RetProc()
        Endif

#ENDIF

SetDefault(aReturn,cString)

If nLastKey == 27
   __RetProc()
Endif


//��������������������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora                 �
//����������������������������������������������������������������
//VerImp()

#IFNDEF WINDOWS
        If LastKey() == 27 .OR. nLastKey == 27
                __RetProc()
        Endif
#ENDIF

#IFDEF WINDOWS
        RptStatus({|| Duplicata()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>         RptStatus({|| Execute(Duplicata)})
        __RetProc()
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>         Function Duplicata
Static Function Duplicata()
#ENDIF

//��������������������������������������������������������������Ŀ
//� Trata as mensagemns do Boleto                                �
//����������������������������������������������������������������

cMensagem1 := IIF(!Empty(mv_par07),Formula( AllTrim( mv_par07 ))," ")
cMensagem2 := IIF(!Empty(mv_par08),Formula( AllTrim( mv_par08 ))," ")
cMensagem3 := IIF(!Empty(mv_par09),Formula( AllTrim( mv_par09 ))," ")
cMensagem4 := IIF(!Empty(mv_par10),Formula( AllTrim( mv_par10 ))," ")

//��������������������������������������������������������������Ŀ
//� Inicio do Processamento do Boleto                            �
//����������������������������������������������������������������

***** Procura o nome do cliente para jogar no boleto

cTITINI := mv_par01  // Titulo Inicial
cTITFIN := mv_par02  // Titulo Final 
cPREINI := mv_par03  // Prefixo Inicial
cPREFIN := mv_par04  // Prefixo Final

Set SofTSeek On

DbSelectArea("SE1")
DbSetorder(1)
DbSeek( xFilial("SE1") + mv_par03 + mv_par01 )

Set Softseek Off


*/
//��������������������������������������������������������������Ŀ
//� Inicio de Impressao do Boleto                                �
//����������������������������������������������������������������

  SetRegua( RecCount())
  SetPrc(0,0)

While !Eof() .And. SE1->E1_NUM >= MV_PAR01 .AND. SE1->E1_NUM <= MV_PAR02
       
//If SE1->E1_NUM >= mv_par01 .and. SE1->E1_NUM <= mv_par02 .and. ; 
//   SE1->E1_PREFIXO >= mv_par03 .and. SE1->E1_PREFIXO <= mv_par04

//��������������������������������������������������������������Ŀ
//� Verifica a Parcela  e Tipo do titulo                         �
//����������������������������������������������������������������

   If SE1->E1_PARCELA < mv_par05 .or. SE1->E1_PARCELA > mv_par06
      DbSkip()
      Loop
   EndIf
   
   If SE1->E1_TIPO == "AB-"
      DbSkip()
      Loop
   EndIf

//��������������������������������������������������������������Ŀ
//� Verifica abatimentos - MSG 14/03/00                          �
//����������������������������������������������������������������
   
   nValor   := 0.00
   cPrefixo := SE1->E1_PREFIXO
   cTitulo  := SE1->E1_NUM 
   cParcela := SE1->E1_PARCELA
   nRegist  := Recno()

   xChave   := SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + "AB-"
   
   If DbSeek( xFilial("SE1") + xChave )
      
      While SE1->E1_FILIAL == xFilial("SE1") .and. SE1->E1_PREFIXO == cPrefixo .and. ;
            SE1->E1_NUM == cTitulo .and. SE1->E1_PARCELA == cParcela .and. ;
            SE1->E1_TIPO == "AB-"
            
            // Desconta abatimentos
            nValor := nValor + SE1->E1_VALOR
            DbSkip()
      EndDo
   EndIf

   // Retorna ao registro original
   
   DbSelectArea("SE1")
   DbGoTo(nRegist)
   
   *** Calcula os Juros    
   nJur     := (SE1->E1_SALDO-nValor)/(25*30)
   nJUROS   := (SE1->E1_VALOR-nValor-SE1->E1_IRRF) * 0.002       // TAXA DE PERMANENCIA
   nTXDESC  := SE1->E1_DESCFIN / 100
   nDESCONT := (SE1->E1_VALOR-nValor-SE1->E1_IRRF) * nTXDESC    // DESCONTO DE PONTUALIDADE


   LI := 01

   dbSelectArea( "SA1" )
   DbSetOrder(1)
   dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)

   cEnd1    := AllTrim( SA1->A1_END )
   cEnd2    := AllTrim( SA1->A1_MUN ) + " - " + SA1->A1_EST
   cCep     := SA1->A1_CEP

  //��������������������������������������������������������������Ŀ
  //� Inicio da Impressao do Boleto                                �
  //����������������������������������������������������������������

  DbSelectArea( "SE1" )    

  @ LI, 000 PSAY "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO"
  @ LI, 050 PSAY Chr(18) + DtoC( SE1->E1_VENCTO )    // vencimento
    LI := LI + 3
  
  @ LI, 000 PSAY DtoC( SE1->E1_EMISSAO )   // data do documento    
  @ LI, 012 PSAY SE1->E1_NUM + " " + SE1->E1_PARCELA         // parcela
  @ LI, 024 PSAY "DUPL."                             // especie doc
  @ LI, 030 PSAY "NAO"                               // aceite
  @ LI, 034 PSAY SE1->E1_EMISSAO                     // data do processamento
    LI := LI + 1
  @ LI, 048 PSAY SE1->E1_VALOR-nValor-SE1->E1_IRRF PICTURE "@E 999,999,999.99"   // valor do documento
    LI := LI + 2
  
  //��������������������������������������������������������������Ŀ
  //� Desconto de Pontualidade                                     �
  //����������������������������������������������������������������

    @ LI, 000 PSAY nDESCONT PICTURE "@E 999,999,999.99"  // valor do desconto de pontualidade
    
    If !Empty( nDESCONT )    
        @ LI, 016 PSAY DtoC( SE1->E1_VENCTO )
    EndIf

  @ LI, 026 PSAY nJUROS  PICTURE "@E 999,999,999.99"                // juros permanencia
    LI := LI + 1
  @ LI, 000 PSAY Chr(15)   // Condensa a Impressora para Impressao de mensagens
    LI := LI + 1
  @ LI, 000 PSAY  IIF( Empty( cMensagem1 ), mv_par07, Substr( cMensagem1,1 ,60 ))  // linha de mensagem "Valor Expresso em REAL" 
    LI := LI + 1
  @ LI, 000 PSAY IIF( Empty( cMensagem2 ), mv_par08, Substr( cMensagem2,1 ,60 ))  // linha de mensagem 2 "Cobrar Multa de 10% apos Vencto : "+TRANSFORM(SE1->E1_VALOR/10,"@EB 999,999,999.99")+" Reais"
    LI := LI + 1
  @ LI, 000 PSAY IIF( Empty( cMensagem3 ), mv_par09, Substr( cMensagem3,1 ,60 ))  // linha de mensagem 3 "Cobrar Taxa de Permanencia apos Vencto : "+Transform(nJur,"@EB 9999.99")+" Reais/Dia"
    LI := LI + 1
  @ LI, 000 PSAY IIF( Empty( cMensagem4 ), mv_par10, Substr( cMensagem4,1 ,60 ))  // linha de mensagem 4 "Nao Dispensar juros de Mora" 
    LI := LI + 1
  @ LI, 000 PSAY Chr(18)
    LI := LI + 1
  
  //��������������������������������������������������������������Ŀ
  //� Imprime os dados do cliente                                  �
  //����������������������������������������������������������������
       
  @ LI, 003 PSAY Substr(SA1->A1_NOME, 1, 30 )
    LI := LI + 1
  @ LI,003 PSAY cEnd1

    LI := LI + 1
  @ LI,003 PSAY cEnd2 + " CEP : "+SubStr(cCep,1,5)+"-"+SubStr(cCep,6,3)
    
    If Len( AllTrim( SA1->A1_CGC )) == 11
       @ LI,037 PSAY " CPF : "+TRANSFORM(SA1->A1_CGC,"@R 999.999.999-99")  
    ElseIf Len( AllTrim( SA1->A1_CGC )) == 14
       @ LI,037 PSAY " CGC : "+TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99")  
    EndIf
  
    LI := LI + 8
  @ LI,000 PSAY chr(18) + " " 
    SETPRC(0,0)

//EndIf
DbSkip()
IncRegua()
EndDo

  //��������������������������������������������������������������Ŀ
  //� Finaliza impressao                                           �
  //����������������������������������������������������������������

set device to screen
dbcommitAll()

If aReturn[5] == 1
   Set Printer TO 
   ourspool(wnrel)
Endif

MS_FLUSH()
__RetProc()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   � PERGUNTAS� Autor � MARCOS GOMES          � Data � 29/09/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria grupo de perguntas no SX1.                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Exclusivo para Clientes Microsiga - Kenia                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION PERGUNTAS
Static FUNCTION PERGUNTAS()

_aPerguntas:= {}

//                  1       2          3                 4       5  6  7 8  9  10     11       12      13 14     15    16 17    18   19 20 21 22 23 24 25  26
AADD(_aPerguntas,{"BOLETO","01","Do Titulo          ?","mv_ch1","C",06,0,0,"G","","mv_par01","       ","","","       ","","","     ","","","","","","","","   ",})
AADD(_aPerguntas,{"BOLETO","02","Ate o Titulo       ?","mv_ch2","C",06,0,0,"G","","mv_par02","       ","","","       ","","","     ","","","","","","","","   ",})
AADD(_aPerguntas,{"BOLETO","03","Do Prefixo         ?","mv_ch3","C",03,0,0,"G","","mv_par03","       ","","","       ","","","     ","","","","","","","","   ",})
AADD(_aPerguntas,{"BOLETO","04","Ate o Prefixo      ?","mv_ch4","C",03,0,0,"G","","mv_par04","       ","","","       ","","","     ","","","","","","","","   ",})
AADD(_aPerguntas,{"BOLETO","05","Da Parcela         ?","mv_ch5","C",01,0,0,"G","","mv_par05","       ","","","       ","","","     ","","","","","","","","   ",})
AADD(_aPerguntas,{"BOLETO","06","Ate a Parcela      ?","mv_ch6","C",01,0,0,"G","","mv_par06","       ","","","       ","","","     ","","","","","","","","   ",})
AADD(_aPerguntas,{"BOLETO","07","Mensagem Linha 1   ?","mv_ch7","C",60,0,0,"G","","mv_par07","       ","","","       ","","","     ","","","","","","","","   ",})
AADD(_aPerguntas,{"BOLETO","08","Mensagem Linha 2   ?","mv_ch8","C",60,0,0,"G","","mv_par08","       ","","","       ","","","     ","","","","","","","","   ",})
AADD(_aPerguntas,{"BOLETO","09","Mensagem Linha 3   ?","mv_ch7","C",60,0,0,"G","","mv_par09","       ","","","       ","","","     ","","","","","","","","   ",})
AADD(_aPerguntas,{"BOLETO","10","Mensagem Linha 4   ?","mv_ch8","C",60,0,0,"G","","mv_par10","       ","","","       ","","","     ","","","","","","","","   ",})

DbSelectArea("SX1")

FOR _nLaco:=1 to LEN(_aPerguntas)
   If !DbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
        RecLock("SX1",.T.)
           SX1->X1_Grupo     := _aPerguntas[_nLaco,01]
           SX1->X1_Ordem     := _aPerguntas[_nLaco,02]
           SX1->X1_Pergunt   := _aPerguntas[_nLaco,03]
           SX1->X1_Variavl   := _aPerguntas[_nLaco,04]
           SX1->X1_Tipo      := _aPerguntas[_nLaco,05]
           SX1->X1_Tamanho   := _aPerguntas[_nLaco,06]
           SX1->X1_Decimal   := _aPerguntas[_nLaco,07]
           SX1->X1_Presel    := _aPerguntas[_nLaco,08]
           SX1->X1_Gsc       := _aPerguntas[_nLaco,09]
           SX1->X1_Valid     := _aPerguntas[_nLaco,10]
           SX1->X1_Var01     := _aPerguntas[_nLaco,11]
           SX1->X1_Def01     := _aPerguntas[_nLaco,12]
           SX1->X1_Cnt01     := _aPerguntas[_nLaco,13]
           SX1->X1_Var02     := _aPerguntas[_nLaco,14]
           SX1->X1_Def02     := _aPerguntas[_nLaco,15]
           SX1->X1_Cnt02     := _aPerguntas[_nLaco,16]
           SX1->X1_Var03     := _aPerguntas[_nLaco,17]
           SX1->X1_Def03     := _aPerguntas[_nLaco,18]
           SX1->X1_Cnt03     := _aPerguntas[_nLaco,19]
           SX1->X1_Var04     := _aPerguntas[_nLaco,20]
           SX1->X1_Def04     := _aPerguntas[_nLaco,21]
           SX1->X1_Cnt04     := _aPerguntas[_nLaco,22]
           SX1->X1_Var05     := _aPerguntas[_nLaco,23]
           SX1->X1_Def05     := _aPerguntas[_nLaco,24]
           SX1->X1_Cnt05     := _aPerguntas[_nLaco,25]
           SX1->X1_F3        := _aPerguntas[_nLaco,26]
        MsUnLock()
   EndIf
NEXT
__RetProc()

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

