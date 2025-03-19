const { exec } = require('child_process');
const path = require('path');
const fs = require('fs');
require('dotenv').config();

const backupDir = path.join(__dirname, '../backups');

// Criar diretório de backup se não existir
if (!fs.existsSync(backupDir)) {
  fs.mkdirSync(backupDir);
}

const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
const filename = `backup-${timestamp}.sql`;
const filepath = path.join(backupDir, filename);

// Extrair informações do DATABASE_URL
const dbUrl = new URL(process.env.DATABASE_URL);
const host = dbUrl.hostname;
const user = dbUrl.username;
const password = dbUrl.password;
const database = dbUrl.pathname.substring(1);
const port = dbUrl.port || '3307';

// Comando de backup
const command = `mysqldump -h ${host} -P ${port} -u ${user} -p${password} ${database} > "${filepath}"`;

exec(command, (error, stdout, stderr) => {
  if (error) {
    console.error(`Erro ao fazer backup: ${error}`);
    return;
  }
  console.log(`Backup criado com sucesso em: ${filepath}`);

  // Manter apenas os últimos 7 backups
  fs.readdir(backupDir, (err, files) => {
    if (err) {
      console.error(`Erro ao ler diretório de backups: ${err}`);
      return;
    }

    const backupFiles = files
      .filter(file => file.startsWith('backup-'))
      .sort()
      .reverse();

    if (backupFiles.length > 7) {
      backupFiles.slice(7).forEach(file => {
        fs.unlink(path.join(backupDir, file), err => {
          if (err) console.error(`Erro ao deletar backup antigo ${file}: ${err}`);
        });
      });
    }
  });
}); 