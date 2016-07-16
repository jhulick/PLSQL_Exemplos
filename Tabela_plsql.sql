declare
   type tp_tab_cli is table of cliente%rowtype index by binary_integer;
   cli_tab1   tp_tab_cli;
   cli_tab2   tp_tab_cli;
   c          binary_integer;
   total      binary_integer;
   maior      fornecedor.nr_fornecedor%type;
begin
   c := 1;
   -- popula a tabela pl/sql cli_tab1
   for reccli in (select * from cliente) loop
      cli_tab1(c).nm_cliente  := reccli.nm_cliente;
      cli_tab1(c).sg_estado   := reccli.sg_estado;
      cli_tab1(c).ds_endereco := reccli.ds_endereco;
      cli_tab1(c).cd_municipio:= reccli.cd_municipio;
      cli_tab1(c).nr_fone     := reccli.nr_fone;
      c                       := c + 1;
   end loop;
   total := c - 1;
   -- copia o conteúdo de uma tabela pl/sql para outra
   cli_tab2 := cli_tab1;--cli_tab2 possui os mesmos índices e elemestos de cli_tab1
   for c in 1..total loop
      if cli_tab1(c).sg_estado = 'sc' then
         select max(nr_fornecedor)+1
         into maior
         from fornecedor;
         -- seleciona o próximo código vago de fornecedor e insere o elemento atual
         -- do índice (um cliente de 'sc')
         insert into fornecedor
         (nr_fornecedor, nm_fornecedor, sg_estado,
         ds_endereco, cd_muncipio, nr_fone)
         values
         (maior, cli_tab1(c).nm_cliente,
         cli_tab1(c).sg_estado, cli_tab1(c).ds_endereco,
         cli_tab1(c).cd_municipio,
         cli_tabq(c).nr_fone);
      end if;
   end loop;
   commit;
end;

