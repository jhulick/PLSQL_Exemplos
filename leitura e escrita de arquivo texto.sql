Declare
--
   out_file UTL_File.File_Type;
--
   Cursor Cur_Notas Is
      Select rpad(
         lpad(substr(To_char(N.numeromov),1,5),5,'0')||
         to_char(N.dataemissao,'DDMMYYYY')||
         lpad(substr(to_char(N.codcfo),1,4),4,'0')||
         lpad(substr(to_char(count(I.numerosequencial)),1,2),2,'0')||
         lpad(substr(to_char(sum(N.valorbruto*100)),1,12)
         ,12,'0'),32) Linha
      From TMOV N, TITMMOV I
      Where N.idmov = I.idmov
      Group by N.numeromov, N.dataemissao, N.codcfo;
Begin
   out_file := UTL_File.fopen('C:\Temp','entradas.txt','w');
   For Reg_Notas in Cur_Notas Loop
      UTL_File.put_line(out_file,Reg_Notas.linha);
   End Loop;
   UTL_File.fclose(out_file);
   Dbms_Output.put_line('Arquivo gerado com sucesso.');

Exception
   When UTL_FILE.INVALID_OPERATION Then
      Dbms_Output.Put_Line('Operação inválida no arquivo.');
      UTL_File.fclose(out_file);
   When UTL_FILE.WRITE_ERROR Then
      Dbms_Output.Put_Line('Erro de gravação no arquivo.');
      UTL_File.fclose(out_file);
   When UTL_FILE.INVALID_PATH Then
      Dbms_Output.Put_Line('Diretório inválido.');
      UTL_File.fclose(out_file);
   When UTL_FILE.INVALID_MODE Then
      Dbms_Output.Put_Line('Modo de acesso inválido.');
      UTL_File.fclose(out_file);
   When Others Then
      Dbms_Output.Put_Line('Problemas na geração do arquivo.');
      UTL_File.fclose(out_file);
End;
