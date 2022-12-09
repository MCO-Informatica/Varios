#Include 'Protheus.ch'

User Function F580MNBR() 
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Array com os campos do browse de marcacao                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 

Local aCampos := {}

DbSelectArea("SE2")
DbSetOrder(18)
While QRYSE2->(!EoF())
 	If SE2->(DbSeek(QRYSE2->(E2_FILIAL+E2_NUM+E2_PREFIXO+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
 	     RecLock("QRYSE2",.F.)    
			_nAbatim := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,dDataBase,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_FILIAL)
 	        QRYSE2->E2_XVALLIQ := QRYSE2->E2_SALDO-_nAbatim+QRYSE2->E2_SDACRES-QRYSE2->E2_SDDECRE
 	     QRYSE2->(MsUnlock())
 	EndIf
 QRYSE2->(DbSkip())
EndDo
QRYSE2->(DbGoTop())


//	{"E2_XVALLIQ" ,NIL,"Vlr. Liquido" ,				  },;
aCampos := {{"E2_OK"	  ,NIL,""             ,       },;
	{"E2_NUM" 	  ,NIL,"Num.Titulo"             ,     },;
	{"E2_NOMFOR"  ,NIL,"Nome Fornece" ,               },;
	{"E2_VALOR"   ,NIL,"Vlr.Titulo"   ,"@E 999,999,999,999,999.99"},; 
	{"E2_SALDO"   ,NIL,"Saldo"        ,"@E 999,999.99"},;                         
	{"E2_XVALLIQ" ,NIL,"Saldo Liquido" ,"@E 999,999,999,999.99"  },; 
	{"E2_EMISSAO" ,NIL,"DT Emissao"   ,"D" ,08 ,0 ,Nil},;
	{"E2_VENCTO"  ,NIL,"Vencimento"   ,"D" ,08 ,0 ,Nil},;
	{"E2_VENCREA" ,NIL,"Vencto Real"  ,"D" ,08 ,0 ,Nil},;
	{"E2_HIST"    ,NIL,"Historico"    ,"@!"           }}

Return(aCampos)
