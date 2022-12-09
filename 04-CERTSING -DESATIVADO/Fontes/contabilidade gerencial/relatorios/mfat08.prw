#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFAT08    ºAutor  ³RECLOP	 		      º Data ³  01/18/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório Demostrativo de Vendas - Visao Contabil           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MFat08()

Local cDesc1      		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Demonstrativo de Vendas"
Local cPict          	:= ""
Local titulo       	 	:= "Demonstrativo de Vendas"
Local nLin         		:= 80
Local Cabec1       		:= "MES        CANAL         PRODUTO            DESCRICAO                SEGUIMENTO       CLI/LOJA   NOME               QTD     VEND1   NOME1             VEND2     NOME2   NF/ITEM    BPAG    AR                VALOR    EMISSAO "
Local Cabec2			:= ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite          := 220
Private tamanho         := "G"
Private nomeprog        := "MFAT08"
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "MFAT08"
Private cString 		:= ""
Private cPerg			:= "MFAT08"

AjustaSX1()
If !Pergunte(cPerg,.T.)
	Return
Else

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
	   Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

EndIf
Return

/*/
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Funï¿½ï¿½o    ï¿½RUNREPORT ï¿½ Autor ï¿½ AP6 IDE            ï¿½ Data ï¿½  16/12/2009 ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Descriï¿½ï¿½o ï¿½ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½ monta a janela com a regua de processamento.               ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ Programa principal                                         ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ SETREGUA -> Indica quantos registros serao processados para a regua ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

SetRegua(RecCount())



_aTes		:= StrToArray(Alltrim(mv_par11),";")

_cTes		:= " "

For _nI := 1 To Len(_aTes)
	If !Empty(_aTes[_nI])
		_cTes += "'" + _aTes[_nI] + "'"
		If _nI <> Len(_aTes)
			_cTes += ","
		EndIf
	EndIf
Next _nI

_cTes := Alltrim(_cTes)

_cCountTes := Len(_cTes)
_cCountNewTes := _cCountTes -2
_cNewTes:= Substring(_cTes,2,_cCountNewTes)

//cAlias := GetNextAlias()

cAlias := "TRC"


Begin Sequence

BeginSql Alias cAlias


Select
 SubStr(SD2.D2_EMISSAO,5,2)||'/'||SUBSTR(SD2.D2_EMISSAO,1,4)	    					As Mes,
 SZ2.Z2_CANAL											                              	As Canal,
 (
       CASE
            WHEN SC5.C5_XORIGPV = '1' THEN 'MANUAL'
            WHEN SC5.C5_XORIGPV = '2' THEN 'VAREJO'
            WHEN SC5.C5_XORIGPV = 'A' THEN 'VAREJO'
            WHEN SC5.C5_XORIGPV = '3' THEN 'HARDWARE AVULSO'
            WHEN SC5.C5_XORIGPV = '4' THEN 'TELEVENDAS'
            WHEN SC5.C5_XORIGPV = '5' THEN 'ATENDIMENTO EXTERNO'
       ELSE
       'NAO EXISTE INFORMAÇÃO DE ORIGEM DE PEDIDO CADASTRADA - ENTRE EM CONTATO COM A AREA DE SISTEMAS CORPORATIVOS'
       END) 																			AS ORIG_PV,
 SD2.D2_COD													                            As Produto,
 SB1.B1_DESC												                            As Descricao,
 SZ1.Z1_DESCSEG												                            As Seguimento,
 SD2.D2_CLIENTE												                            As Cliente,
 SD2.D2_LOJA												                            As Loja,
 SA1.A1_NOME												                            As Nome,
 SD2.D2_QUANT												                            As Quantidade,
 SC5.C5_VEND1												                            As Cod_Vend1,
 SA3.A3_NOME                                                      						As Nome_Vend1,
 SF2.F2_VEND2 												                            As Cod_Vend2,
 (SELECT SA3.A3_NOME FROM %Table:SA3% WHERE SA3.A3_FILIAL = %xFilial:SA3% AND SA3.A3_COD = SF2.F2_VEND2   AND SA3.D_E_L_E_T_   =   ' ' ) AS Nome_Vend2,
 SD2.D2_DOC													                            As Nota_Fiscal,
 SD2.D2_ITEM												                            As Item_Nota,
 SC5.C5_CHVBPAG												                            As Numero_BPAG,
 SC5.C5_NUM												  	                            As Numero_Pedido,
 CAST (D2_TOTAL AS NUMBER(13,2))             				              				As Valor_Unit,
 SD2.D2_VALFRE					             				                            As Despesa,
 (SD2.D2_TOTAL+SD2.D2_VALFRE)	             				              				As Valor_Total,
 SE4.E4_DESCRI                                                    						As Cond_Pagto,
 (
  case
    when SC5.C5_TIPMOV = ' ' then 'Vendas Corporativa'
    when SC5.C5_TIPMOV = '1' then 'Boleto'
    when SC5.C5_TIPMOV = '2' then 'Cartao Credito'
    when SC5.C5_TIPMOV = '3' then 'Cartao Debito'
    when SC5.C5_TIPMOV = '4' then 'DA'
    when SC5.C5_TIPMOV = '5' then 'DDA'
    when SC5.C5_TIPMOV = '6' then 'Voucher'

    else 'Novo Condição de Pagamento - Entre em contato com a area de Sistemas Corporativos'
  end )                                                         					   As Forma_Pagto,
 SC5.C5_XNPSITE                                                   					   As Ped_Site,
 SC5.C5_XLINDIG                                                   					   As Linha_Digit,
 SA1.A1_CONTA                                                    	 				   As Cta_Debito,
 SB1.B1_CONTA                                                     					   As Cta_Credito,
 SD2.D2_VALIMP5                                                   					   As Vlr_COF,
 SD2.D2_VALIMP6                                                   					   As Vlr_PIS,
 SD2.D2_EMISSAO												                           As Emissao,
 SD2.D2_TES													                           As TES,
 SA1.A1_PESSOA												                           As Fisico_Jur,
 SA1.A1_NREDUZ												                           As Nome_Reduz,
 SA1.A1_TIPO												                           As Tipo,
 SA1.A1_CEP													                           As Cep,
 SA1.A1_END													                           As Endereco,
 SA1.A1_EST													                           As Estado,
 SA1.A1_COD_MUN												                           As Cod_Mun,
 SA1.A1_MUN													                           As Municipio,
 SA1.A1_BAIRRO												                           As Bairro,
 SA1.A1_DDD												        	                   As DDD,
 SA1.A1_TEL													                           As Tel,
 SA1.A1_CONTATO												                           As Contato,
 SA1.A1_EMAIL												                           As Email,
 SA1.A1_CGC													                           As CPF_CNPJ,
 SA1.A1_CNAE												                           As CNAE,
 SC5.C5_EMISSAO												                           As Emissao_Pedido,
 SC5.C5_AR													                           As Ar,
 (SELECT SZ3.Z3_DESENT FROM %Table:SZ3% SZ3 Where SZ3.Z3_FILIAL = ' ' AND SZ3.Z3_CODENT = SC5.C5_AR AND SZ3.D_E_L_E_T_ = ' ' AND ROWNUM = 1) As Nome_AR,
 ACY_DESCRI 																		   As Grp_Cliente,
 (SELECT SZ5.Z5_CODAR  FROM %Table:SZ5%  SZ5 WHERE SZ5.Z5_FILIAL = '  ' AND SZ5.Z5_PEDGAR = SC5.C5_CHVBPAG  AND SZ5.D_E_L_E_T_ = ' ' AND ROWNUM = 1) As Codigo_AR,
 (SELECT SZ5.Z5_DESCAR FROM %Table:SZ5%  SZ5 WHERE SZ5.Z5_FILIAL = '  ' AND SZ5.Z5_PEDGAR = SC5.C5_CHVBPAG  AND SZ5.D_E_L_E_T_ = ' ' AND ROWNUM = 1) As Descricao_AR,
 (SELECT SZ5.Z5_CODPOS FROM %Table:SZ5%  SZ5 WHERE SZ5.Z5_FILIAL = '  ' AND SZ5.Z5_PEDGAR = SC5.C5_CHVBPAG  AND SZ5.D_E_L_E_T_ = ' ' AND ROWNUM = 1) As Codigo_do_Posto,
 (SELECT SZ5.Z5_DESPOS FROM %Table:SZ5%  SZ5 WHERE SZ5.Z5_FILIAL = '  ' AND SZ5.Z5_PEDGAR = SC5.C5_CHVBPAG  AND SZ5.D_E_L_E_T_ = ' ' AND ROWNUM = 1) As Descricao_do_Posto
  From
%Table:SD2% SD2 INNER JOIN %Table:SF2% SF2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND
SD2.D2_SERIE = SF2.F2_SERIE AND  SF2.D_E_L_E_T_   =   ' '   AND SD2.D_E_L_E_T_   =  ' '
LEFT JOIN %Table:SB1% SB1 ON SB1.B1_FILIAL = SD2.D2_FILIAL AND  SB1.B1_COD = SD2.D2_COD AND
SB1.D_E_L_E_T_   =   ' '
LEFT JOIN %Table:SA1% SA1 ON SA1.A1_FILIAL = ' ' AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA AND
SA1.D_E_L_E_T_   =   ' '
LEFT JOIN %Table:ACY% ACY ON ACY.ACY_FILIAL = SA1.A1_FILIAL AND ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' '
LEFT JOIN %Table:SA3% SA3 ON SA3.A3_FILIAL = '  ' AND SA3.A3_COD = SF2.F2_VEND1   AND SA3.D_E_L_E_T_   =   ' '
LEFT JOIN %Table:SC5% SC5 ON SC5.C5_FILIAL = %xFilial:SC5% AND SC5.C5_NUM =  SD2.D2_PEDIDO AND SC5.D_E_L_E_T_   =   ' '
LEFT JOIN %Table:SZ2% SZ2 ON SZ2.Z2_FILIAL = '  ' AND SZ2.Z2_CODIGO  = SA3.A3_XCANAL AND SZ2.D_E_L_E_T_   =   ' '
LEFT JOIN %Table:SZ1% SZ1 ON SZ1.Z1_FILIAL = '  ' AND SZ1.Z1_CODSEG = SB1.B1_XSEG   AND  SZ1.D_E_L_E_T_   =   ' '
LEFT JOIN %Table:SE4% SE4 ON SE4.E4_FILIAL = '  ' AND SC5.C5_CONDPAG = SE4.E4_CODIGO AND  SE4.D_E_L_E_T_   =   ' '
 Where
 //--TABELA SF2
 SF2.F2_FILIAL    =    %xFilial:SF2%				AND
 SF2.F2_VEND2     >=   %Exp:MV_PAR05% 				AND
 SF2.F2_VEND2     <=   %Exp:MV_PAR06% 				AND
 //--TABELA SD2
 SD2.D2_FILIAL    =    %xFilial:SD2%				AND
 SD2.D2_EMISSAO   >=   %Exp:MV_PAR01%				AND
 SD2.D2_EMISSAO   <=   %Exp:MV_PAR02%   			AND
 SD2.D2_COD       >=   %Exp:MV_PAR03% 	    		AND
 SD2.D2_COD       <=   %Exp:MV_PAR04%	     		AND
 SD2.D2_TES       IN (  %Exp:_cNewTes%		)		AND
 //--TABELA SC5
 SC5.C5_VEND1     >=   %Exp:MV_PAR05%      			AND
 SC5.C5_VEND1     <=   %Exp:MV_PAR06% 		        AND
 SC5.C5_XNATURE   >=   %Exp:MV_PAR09%  		        AND
 SC5.C5_XNATURE   <=   %Exp:MV_PAR10% 		        AND
 //--TABELA SZ2
 SZ2.Z2_CODIGO    >=   %Exp:MV_PAR07%              AND
 SZ2.Z2_CODIGO    <=   %Exp:MV_PAR08%

 Order By Mes, SD2.D2_DOC, SA3.A3_NOME, SD2.D2_ITEM, Seguimento, Canal

 EndSQL

 aLastQuery    := GetLastQuery()
 cLastQuery    := aLastQuery[2]

 Recover

 aLastQuery    := GetLastQuery()
 cLastQuery    := aLastQuery[2]

 END SEQUENCE


//Array p/ Excel
_aCabec 	:= {}
_aDados		:= {}

AAdd(_aDados, {	"MES",;
				"CANAL",;
				"ORIG_PV",;
				"PRODUTO",;
				"DESCRICAO",;
				"SEGUIMENTO",;
				"CLI/LOJA",;
				"NOME",;
				"QTD",;
				"VEND1",;
				"NOME VEND1",;
				"VEND2",;
				"NOME VEND2",;
				"NF/ITEM",;
				"BPAG",;
				"Numero_Pedido",;
				"VALOR UNIT",;
				"DESPESA",;
				"VALOR",;
				"FORMA_DE_PAGTO",;
				"COND_PAGTO",;
				" PED_SITE",;
				"LINHA_DIGITAV.",;
				" CTA_DEBTO",;
				"CTA_CREDITO",;
				"VLR_COF",;
				"VLR_PIS",;
				"EMISSAO",;
				"TES",;
				"TIPO",;
				"NOME_REDUZ",;
				"TIPO",;
				"CEP",;
				"ENDERECO",;
				"ESTADO",;
				"COD_MUN",;
				"MUNICIPIO",;
				"BAIRRO",;
				"DDD",;
				"TEL",;
				"CONTATO",;
				"EMAIL",;
				"CPF_CNPJ",;
				"CNAE",;
				"Emissao_Pedido",;
				"AR",;
				"NOME_AR",;
				"Grp_Cliente",;
				"Codigo_AR",;
				"Descricao_AR",;
				"Codigo_do_Posto",;
				"Descricao_do_Posto",;
				"Numero_Oportunidade"})
AAdd(_aDados, {})

DbSelectArea("TRC")
TRC->(dbGoTop())

While !TRC->(Eof())

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

//Variavel para Orig do Pedido
cOrigPV := TRC->ORIG_PV

//Descrição AR
 cNOME_AR := " "
 cCodAR   := " "

 If TRC->AR <> " "
 	cCodAR := TRC->AR
  	DbSelectArea("SZ3")
   	SZ3->(DbSetOrder(1))
	If SZ3->(DbSeek(xFilial("SZ3")+cCodAR))
		cNOME_AR := SZ3->Z3_DESENT
	Else
		cNOME_AR := " "
	EndIf
 EndIf


/*BEGINDOC - **RECLOP**
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÿ \§ \§$¿
//³-Modificação realizado dia 18/02 - Solicitado pelo IVAN pela OTRS 2012122710001573 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÿÙ
ENDDOC*/

 IF SUBSTR(TRC->ORIG_PV,1,1)$"M"

 	cCodVend1:=	TRC->Cod_Vend1
 	cCodVend2:= TRC->Cod_Vend2

 	DbSelectArea("SA3")
 	SA3->(DbSetOrder(1))

 	If cCodVend1 <> " "
 		SA3->(DbSeek(xFilial("SA3")+cCodVend1))
 			IF cCodVend1 = "VA0009"
 				cOrigPV := SA3->A3_NOME

 			ElseIF SubStr(cCodVend1,1,2) $ "VC"

 				cCodCan := SA3->A3_XCANAL
 				DbSelectArea("SZ2")
 				SZ2->(DbSetOrder(1))
 				SZ2->(DbSeek(xFilial("SZ2")+cCodCan))
 				cOrigPV := SZ2->Z2_CANAL
 				SZ2->(DbCloseArea())

 			ElseIF cCodVend1 = "VA0001"
 			     cOrigPV := "VAREJO"

 			EndIF
 		SA3->(DbCloseArea())
 	Endif
 Endif

		AAdd(_aDados, {	TRC->Mes,;		//	MES,;
						TRC->Canal,;		//	CANAL,;
						cOrigPV,;		//	ORIG_PV,;
						TRC->Produto,;		//	PRODUTO,;
						TRC->Descricao,;		//	DESCRICAO,;
						TRC->Seguimento,;		//	SEGUIMENTO,;
						TRC->Cliente + "/" + TRC->Loja,;		//	CLI/LOJA,;
						TRC->Nome,;		//	NOME,;
						TRC->Quantidade,;		//	QTD;
						TRC->Cod_Vend1,;		//	VEND1,;
						TRC->Nome_Vend1,;		//	NOME VEND1,;
						TRC->Cod_Vend2,;		//	VEND2,;
						TRC->Nome_Vend2,;		//	NOME VEND2,;
						Alltrim(TRC->Nota_Fiscal) + "/" + Alltrim(TRC->Item_Nota),;		//	NF/ITEM,;
						TRC->Numero_BPAG,;		//	BPAG,;
						TRC->Numero_Pedido,;		//	Numero_Pedido,;
						Transform(TRC->Valor_Unit,  '@E 999,999,999.99'),;		//	VALOR UNIT,;
						Transform(TRC->Despesa,  '@E 999,999,999.99'),;		//	DESPESA,;
						Transform(TRC->Valor_Total,  '@E 999,999,999.99'),;		//	VALOR,;
						TRC->Cond_Pagto,;		//	FORMA_DE_PAGTO,;
						TRC->Forma_Pagto,;		//	COND_PAGTO,;
						TRC->Ped_Site,;		//	 PED_SITE,;
						TRC->Linha_Digit, ;		//	LINHA_DIGITAV.,;
						TRC->Cta_Debito, ;		//	 CTA_DEBTO,;
						TRC->Cta_Credito,;		//	CTA_CREDITO,;
						Transform(TRC->Vlr_COF, '@E 999,999.99'),;		//	VLR_COF,;
						Transform(TRC->Vlr_PIS, '@E 999,999.99'),;		//	VLR_PIS,;
						STOD(TRC->Emissao),;		//	EMISSAO,;
						TRC->TES,;		//	TES,;
						TRC->FISICO_JUR,;		//	TIPO,;
						TRC->NOME_REDUZ,;		//	NOME_REDUZ,;
						TRC->TIPO,;		//	TIPO,;
						'',;		//	CEP,;
						'',;		//	ENDERECO,;
						'',;		//	ESTADO,;
						'',;		//	COD_MUN,;
						'',;		//	MUNICIPIO,;
						'',;		//	BAIRRO,;
						'',;		//	DDD,;
						'',;		//	TEL,;
						TRC->CONTATO,;		//	CONTATO,;
						'',;		//	EMAIL,;
						'',;		//	CPF_CNPJ,;
						'',;		//	CNAE,;
						STOD(TRC->Emissao_Pedido),;		//	Emissao_Pedido,;
						TRC->Ar,;		//	AR,;
						cNOME_AR,;		//	NOME_AR,;
						TRC->Grp_Cliente,;		//	Grp_Cliente,;
						TRC->Codigo_AR,;		//	Codigo_AR,;
						TRC->Descricao_AR,;		//	Descricao_AR,;
						TRC->Codigo_do_Posto,;		//	Codigo_do_Posto,;
						TRC->Descricao_do_Posto})		//	Descricao_do_Posto,;




   nLin++
   TRC->(dbSkip())


EndDo

TRC->(DbCloseArea())

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

//If mv_par12 == 1
	DlgToExcel({ {"ARRAY","Demosntrativo de Vendas - Visão Contabil", _aCabec, _aDados} })
//EndIf

SET DEVICE TO SCREEN

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ Se impressao em disco, chama o gerenciador de impressao...          ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½-ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½Funï¿½ï¿½o    ï¿½ AjustaSX1    ï¿½Autor ï¿½  Douglas Mello		ï¿½    16/12/2009   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½-ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½Descriï¿½ï¿½o ï¿½ Ajusta perguntas do SX1                                    ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ù±ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/
Static Function AjustaSX1()

Local aArea := GetArea()

PutSx1(cPerg,"01","Emissao De         ","Emissao De         ","Emissao De         ","mv_ch1","D",08,00,01,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
PutSx1(cPerg,"02","Emissao Ate        ","Emissao Ate        ","Emissao Ate        ","mv_ch2","D",08,00,01,"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
PutSx1(cPerg,"03","Produto De         ","Produto De         ","Produto De         ","mv_ch3","C",15,00,01,"G","","SB1","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Produto inicial a ser considerado"})
PutSx1(cPerg,"04","Produto Ate        ","Produto Ate        ","Produto Ate        ","mv_ch4","C",15,00,01,"G","","SB1","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Produto final a ser considerado"})
PutSx1(cPerg,"05","Vendedor De        ","Vendedor De        ","Vendedor De        ","mv_ch5","C",06,00,01,"G","","SA3","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Vendedor inicial a ser considerado"})
PutSx1(cPerg,"06","Vendedor De        ","Veadedor Ate       ","Vendedor Ate       ","mv_ch6","C",06,00,01,"G","","SA3","","","mv_par06"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Vendedor final a ser considerado"})
PutSx1(cPerg,"07","Canal De           ","Canal De           ","Canal De           ","mv_ch7","C",06,00,01,"G","","SZ2","","","mv_par07"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Canal inicial a ser considerado"})
PutSx1(cPerg,"08","Canal Ate          ","Canal Ate          ","Canal Ate          ","mv_ch8","C",06,00,01,"G","","SZ2","","","mv_par08"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Canal final a ser considerado"})
PutSx1(cPerg,"09","Natureza De        ","Natureza De        ","Natureza De        ","mv_ch3","C",15,00,01,"G","","SED","","","mv_par11"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Natureza inicial a ser considerado"})
PutSx1(cPerg,"10","Natureza Ate       ","Natureza Ate       ","Natureza Ate       ","mv_ch4","C",15,00,01,"G","","SED","","","mv_par12"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Natureza final a ser considerado"})
PutSx1(cPerg,"11","TES                ","TES                ","TES                ","mv_ch9","C",30,00,01,"G","","   ","","","mv_par09"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Exemplo: 501;502;503"})
PutSx1(cPerg,"12","Excel			  ","Excel              ","Excel              ","mv_chA","N",01,00,01,"C","",""   ,"","","mv_par10","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo Exce"})

RestArea(aArea)

Return