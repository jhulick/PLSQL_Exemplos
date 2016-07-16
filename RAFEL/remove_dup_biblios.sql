CREATE OR REPLACE PROCEDURE REMOVE_DUP_BIBLIOS IS
   CURSOR C1 IS
   select codigo, codpessoa from lusuario where codpessoa in (
      select codpessoa from lusuario group by codpessoa having count(codigo) > 1)
      and situsuario = 'C'
      and codpessoa in (select codpessoa from lusuario where situsuario in ('R', 'I') group by codpessoa)
      order by codpessoa
      for update of codigo;
   nusuario  number;
   tcodigo   lusuario.codigo%type;
   
BEGIN
   DBMS_OUTPUT.put_line('REMOÇÃO DOS USUARIO DUPLICADOS DO BIBLIOS ');
   for RC1 in c1 loop
      nusuario := 0;
      select count(codigo) into nusuario from lusuario where situsuario in ('R', 'I') and codpessoa = rc1.codpessoa;
      if nusuario > 1 OR nusuario = 0 then
         dbms_output.put_line(RC1.CODPESSOA || ' PESSOA COM MAIS DE UM USUARIO DA BIBLIOTECA COM SITUAÇÃO DIFERENTE DE CANSELADO');
      else
         select codigo into tcodigo from lusuario where situsuario in ('R', 'I') and codpessoa = rc1.codpessoa;
         UPDATE LEMPRESTIMOS SET CODCLIENTE = tcodigo WHERE CODCLIENTE = RC1.CODIGO;
         dbms_output.put_line(RC1.CODIGO || ' USUARIO DA BIBLIOTECA SUBISTITUIDO PELO ' || tcodigo);
         delete LUSUUNI where codusuario = rc1.codigo;
         delete LUSUARIOCOMPL where codigo = rc1.codigo;
         delete lusuario where CURRENT OF C1;
      end if;
   end loop;
   --commit;
END; -- Procedure
/

