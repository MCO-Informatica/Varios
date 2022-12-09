#include "rwmake.ch" 
#include "topconn.ch" 

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±± 
±±ºPrograma ³FINA200   º Autor ³      Luiz Alberto    º Data ³ 15/07/14   º±± 0000012342
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±ºDescricao ³ O ponto de entrada FINA200 do CNAB a receber sera executadoº±±          PARAMIXB
±±º          ³apos carregar os dados do arquivo de recepcao bancaria e    º±± _aValores    :
±±º          ³sera utilizado para alterar os dados recebidos linha a linhaº±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                        SE1->E1_NUM
±±ºUso       ³ FINA200 - CNAB a receber ( < aValores> ) --> URET          º±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
*/ 


User Function F200VAR() 
Local aArea     := Getarea() 
Local aValores  := ParamIxb[01]
Local cDPNat	:= &(GetMv("MV_NATDPBC"))                           
Local aArea		:=	GetArea()

SE1->(dbSetOrder(16),dbSeek(xFilial("SE1")+Left(aValores[1],10)))

If SEE->EE_CODIGO == '001' .And. nJuros > 0 .And. nDescont > 0
	nValrec		:= nDescont + nJuros
	nDescont	:= 0.00                                   
ElseIf SEE->EE_CODIGO == '001' .And. nJuros > 0 .And. Empty(nDescont) .And. SE1->E1_SITUACA == '2'
	nValrec		-= nJuros
ElseIf nDespes > 0.00	// Ocorrencia Entrada Confirmada Nao será processada pois deverá ser lançada manualmente para alimentar fluxo de caixa nat.
	// Baixa Despesa do Titulo Com ExecAuto Para Alimentar Movimentação Banco

	SED->(dbSetOrder(1), dbSeek(xFilial("SED")+GetMV("MV_NATDPBC")))
	
	lMsErroAuto	:=	 .f.

    aFINA100 := {    	{"E5_FILIAL"        ,xFilial("SE5")		  , Nil },;
    					{"E5_DATA"        	,dBaixa	               ,Nil},;
                        {"E5_MOEDA"        	,"R$"                    ,Nil},;
                        {"E5_VALOR"         ,nDespes		          ,Nil},;
                        {"E5_RECPAG"        ,'P'                  ,Nil},;
                        {"E5_NATUREZ"    	,cDPNat			  ,Nil},;
                        {"E5_BANCO"        	,cBanco                  ,Nil},;
                        {"E5_AGENCIA"    	,cAgencia        	      ,Nil},;
                        {"E5_CONTA"        	,cConta                  ,Nil},;
                        {"E5_HISTOR"    	,'Oc.: ('+AllTrim(aValores[14])+") TARIFA BANCARIA" ,Nil},;
                        {"E5_DTDIGIT"    	,dDatabase			  ,Nil}}
					                                                   
	MSExecAuto({|x,y,z,w| FINA100(x,y,z,w),cIdMov := SE5->E5_IDMOVI },,aFINA100,3)
    If lMsErroAuto
        MostraErro()
        Alert("Falha na Baixa Para Alimentar Fluxo por Natureza da Despesa do Titulo !!! - Saida ")
    Else
		nDespes		:= 0.00
    EndIf   	
    RestArea(aArea)
Endif

RestArea(aArea)
return 