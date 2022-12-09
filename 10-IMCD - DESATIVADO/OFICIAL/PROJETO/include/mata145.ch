#IFDEF SPANISH
   #define STR0001 "Aviso de Cobro"
   #define STR0002 "Buscar"
   #define STR0003 "Visualizacion"
   #define STR0004 "Incluir"
   #define STR0005 "Modificar"
   #define STR0006 "Borrado"
   #define STR0007 "Homologar"
   #define STR0008 "PEDIDO"
   #define STR0009 "Pedido de compra"
   #define STR0010 "Facturas"
   #define STR0011 "Itemes de la factura"
   #define STR0012 'BUSQUEDA'
   #define STR0013 "Pedido de compras"
   #define STR0014 "Tienda"
   #define STR0015 "Item"
   #define STR0016 "Saldo"
   #define STR0017 "Entrega"
   #define STR0018 "Producto"
   #define STR0019 "Descripcion"
   #define STR0020 "Tipo"
   #define STR0021 "Valor Unit."
   #define STR0022 "Emision"
   #define STR0023 "Deposito"
   #define STR0024 'Seleccione el Pedido de Compra'
   #define STR0025 '¿Confirma la homologacion de este Aviso de Cobro?'
   #define STR0026 'Atencion'
   #define STR0027 'Espere... homologando '
   #define STR0028 '¿Desea interrumpir la homologacion?'
   #define STR0029 'Si'
   #define STR0030 'No'
   #define STR0031 'Homologacion interrumpida por el operador'
   #define STR0032 'Algunas facturas de este Aviso de Cobro no fueron homologadas.  Corrija los problemas que'
   #define STR0033 'impidieron la homologacion completa del aviso y ejecute nuevamente la rutina correspondiente.    '
   #define STR0034 'Obs.: se genero el archivo "ARNAOHOM.LOG" con informaciones sobre los itemes no homologados       '
   #define STR0035 'Leyenda'
   #define STR0036 'A.R. no homologado'
   #define STR0037 'A.R. parcialmente homologado'
   #define STR0038 'A.R. homologado'
   #define STR0039 'Uno o mas itemes del A.R. no homologados'
   #define STR0040 'INTERRUMPIDO POR EL USUARIO'
   #define STR0041 'No fue posible realizar la grabacion del LOG de error referente a los itemes del A.R.'
   #define STR0042 'Este Aviso de Embarque ja foi Homologado.'
#ELSE
   #IFDEF ENGLISH
      #define STR0001 "Receive warning"
      #define STR0002 "Search"
      #define STR0003 "View"
      #define STR0004 "Insert"
      #define STR0005 "Warn"
      #define STR0006 "Delete"
      #define STR0007 "Ratify"
      #define STR0008 "ORDER"
      #define STR0009 "Purchase Order"
      #define STR0010 "Invoices"
      #define STR0011 "Invoice Items"
      #define STR0012 'SEARCH'
      #define STR0013 "Purchase Orders"
      #define STR0014 "Unit"
      #define STR0015 "Item"
      #define STR0016 "Balance"
      #define STR0017 "Delivery"
      #define STR0018 "Product"
      #define STR0019 "Description"
      #define STR0020 "Type"
      #define STR0021 "Unit Value"
      #define STR0022 "Issue"
      #define STR0023 "Warehouse"
      #define STR0024 'Select the Purchase Order'
      #define STR0025 'Confirm  the Ratification of this Receive Warning?'
      #define STR0026 'Attention'
      #define STR0027 'Wait... Ratifying '
      #define STR0028 'Do you want to interrupt the ratification?'
      #define STR0029 'Yes'
      #define STR0030 'No'
      #define STR0031 'Ratification Interrupted by the Operator'
      #define STR0032 'Some Invoices of this Receive Warning were not Ratified. Correct the problems that'
      #define STR0033 'make the A.R. Complete Ratification impossible and accomplish the Ratification routine again. '
      #define STR0034 'Note.: The "ARNAOHOM.LOG" file was generated with information of the not Ratified items'
      #define STR0035 'Caption'
      #define STR0036 'A.R. Not Ratified'
      #define STR0037 'A.R. Partially Ratified'
      #define STR0038 'A.R. Ratified'
      #define STR0039 'A.R. Item(s) not Ratified'
      #define STR0040 'INTERRUPTED BY THE USER'
      #define STR0041 'It was not possible to carry out the error LOG recording referent to the A.R. item(s)'
	   #define STR0042 'Este Aviso de Embarque ja foi Homologado.'
   #ELSE
      #define STR0001 "Aviso de Recebimento"
      #define STR0002 "Pesquisar"
      #define STR0003 "Visualiza"
      #define STR0004 "Incluir"
      #define STR0005 "Alterar"
      #define STR0006 "Excluir"
      #define STR0007 "Homologar"
      #define STR0008 "PEDIDO"
      #define STR0009 "Pedido de Compra"
      #define STR0010 "Notas Fiscais"
      #define STR0011 "Itens da Nota Fiscal"
      #define STR0012 'PESQUISA'
      #define STR0013 "Pedido de Compras"
      #define STR0014 "Loja"
      #define STR0015 "Item"
      #define STR0016 "Saldo"
      #define STR0017 "Entrega"
      #define STR0018 "Produto"
      #define STR0019 "Descricao"
      #define STR0020 "Tipo"
      #define STR0021 "Valor Unit."
      #define STR0022 "Emissao"
      #define STR0023 "Armazem"
      #define STR0024 'Selecione o Pedido de Compra'
      #define STR0025 'Confirma a Homologacao deste Aviso de Recebimento?'
      #define STR0026 'Atencao'
      #define STR0027 'Aguarde... Homologando '
      #define STR0028 'Deseja interromper a Homologacao?'
      #define STR0029 'Sim'
      #define STR0030 'Nao'
      #define STR0031 'Homologacao Interrompida pelo Operador'
      #define STR0032 'Algumas Notas Fiscais deste Aviso de Recebimento nao foram Homologados.  Corrija os problemas que'
      #define STR0033 'impossibilitaram a Homologacao Completa do A.R. e execute novamente a rotina de Homologacao.     '
      #define STR0034 'Obs.: Foi gerado o arquivo "ARNAOHOM.LOG" com informacoes sobre os itens nao Homologados         '
      #define STR0035 'Legenda'
      #define STR0036 'A.R. Nao Homologado'
      #define STR0037 'A.R. Parcialmente Homologado'
      #define STR0038 'A.R. Homologado'
      #define STR0039 'Item(ns) do A.R. nao Homologado(s)'
      #define STR0040 'INTERROMPIDO PELO USUARIO'
      #define STR0041 'Nao foi possivel realizar a gravacao do LOG de erro referente ao(s) item(ns) do A.R.'
	   #define STR0042 'Este Aviso de Embarque ja foi Homologado.'
   #ENDIF
#ENDIF