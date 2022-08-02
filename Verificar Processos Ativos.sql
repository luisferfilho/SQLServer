Select Processo                = spid

,Computador           = hostname

,Usuario                 = loginame

,Status                  = status

,BloqueadoPor         = blocked

,TipoComando         = cmd

,Aplicativo              = program_name

from    master..sysprocesses

where status in ('runnable', 'suspended')

order by blocked desc, status, spid

