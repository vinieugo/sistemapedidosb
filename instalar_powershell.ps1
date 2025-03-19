# Sistema de Pedidos - Script de Instalação PowerShell
# ---------------------------------------------
# Este script instala todas as dependências necessárias para o Sistema de Pedidos
# Execute no PowerShell com permissões de administrador
# ---------------------------------------------

# Habilitar execução de scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

Write-Host "====================================================" -ForegroundColor Green
Write-Host "  SISTEMA DE PEDIDOS - INSTALAÇÃO VIA POWERSHELL" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green
Write-Host ""

# Verificar se está executando como Administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[ERRO] Este script precisa ser executado como Administrador!" -ForegroundColor Red
    Write-Host "Por favor, abra o PowerShell como Administrador e execute novamente." -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
    exit
}

# Verificar se o Chocolatey está instalado
Write-Host "[INFO] Verificando instalação do Chocolatey..." -ForegroundColor Yellow
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "[INFO] Instalando o Chocolatey..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Reiniciar o ambiente de path
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    
    Write-Host "[OK] Chocolatey instalado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "[OK] Chocolatey já está instalado." -ForegroundColor Green
}

# Verificar/Instalar Node.js
Write-Host ""
Write-Host "[INFO] Verificando Node.js..." -ForegroundColor Yellow
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[INFO] Instalando Node.js..." -ForegroundColor Yellow
    choco install nodejs-lts -y
    
    # Reiniciar o ambiente de path
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    
    Write-Host "[OK] Node.js instalado com sucesso!" -ForegroundColor Green
} else {
    $nodeVersion = (node -v)
    Write-Host "[OK] Node.js $nodeVersion já está instalado." -ForegroundColor Green
}

# Verificar/Instalar MySQL
Write-Host ""
Write-Host "[INFO] Verificando MySQL..." -ForegroundColor Yellow
if (-not (Get-Service -Name "MySQL80" -ErrorAction SilentlyContinue)) {
    Write-Host "[INFO] Instalando MySQL..." -ForegroundColor Yellow
    
    # Configurar usuário root e senha
    choco install mysql --version=8.0.32 --params="/port:3306 /password:root" -y
    
    # Reiniciar o serviço do MySQL para aplicar as configurações
    Restart-Service -Name "MySQL80" -Force
    
    Write-Host "[OK] MySQL instalado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "[OK] MySQL já está instalado." -ForegroundColor Green
}

# Criar banco de dados
Write-Host ""
Write-Host "[INFO] Criando banco de dados 'sistema_pedidos'..." -ForegroundColor Yellow

$mysqlPath = "C:\Program Files\MySQL\MySQL Server 8.0\bin"
if (Test-Path $mysqlPath) {
    Set-Location $mysqlPath
    $createDBScript = @"
CREATE DATABASE IF NOT EXISTS sistema_pedidos;
"@

    $createDBScript | Out-File -FilePath "temp_create_db.sql" -Encoding ASCII
    
    # Executar o script SQL
    Start-Process -FilePath ".\mysql.exe" -ArgumentList "--user=root", "--password=root", "-e", "source temp_create_db.sql" -NoNewWindow -Wait
    
    # Remover arquivo temporário
    Remove-Item "temp_create_db.sql" -Force
    
    Write-Host "[OK] Banco de dados criado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "[AVISO] Caminho do MySQL não encontrado. Verifique a instalação." -ForegroundColor Yellow
    Write-Host "Você precisará criar o banco de dados manualmente:" -ForegroundColor Yellow
    Write-Host "CREATE DATABASE sistema_pedidos;" -ForegroundColor Cyan
}

# Verificar Git e clonar repositório (se necessário)
$projetoPath = (Get-Location).Path
if (-not (Test-Path "$projetoPath\package.json")) {
    Write-Host ""
    Write-Host "[INFO] Projeto não encontrado na pasta atual." -ForegroundColor Yellow
    Write-Host "[INFO] Verificando Git..." -ForegroundColor Yellow
    
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "[INFO] Instalando Git..." -ForegroundColor Yellow
        choco install git -y
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        Write-Host "[OK] Git instalado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "[OK] Git já está instalado." -ForegroundColor Green
    }
    
    Write-Host "[INFO] Clonando repositório do GitHub..." -ForegroundColor Yellow
    git clone https://github.com/vinieugo/sistemapedidos.git
    Set-Location sistemapedidos
    $projetoPath = (Get-Location).Path
    
    Write-Host "[OK] Repositório clonado com sucesso!" -ForegroundColor Green
}

# Instalar dependências do frontend
Write-Host ""
Write-Host "[INFO] Instalando dependências do frontend..." -ForegroundColor Yellow
Set-Location $projetoPath
npm install
Write-Host "[OK] Dependências do frontend instaladas!" -ForegroundColor Green

# Instalar dependências do backend
Write-Host ""
Write-Host "[INFO] Instalando dependências do backend..." -ForegroundColor Yellow
Set-Location "$projetoPath\backend"
npm install
Write-Host "[OK] Dependências do backend instaladas!" -ForegroundColor Green

# Configurar Prisma
Write-Host ""
Write-Host "[INFO] Configurando Prisma e migrações..." -ForegroundColor Yellow
npx prisma generate
npx prisma migrate deploy
Write-Host "[OK] Prisma configurado com sucesso!" -ForegroundColor Green

# Finalizar
Set-Location $projetoPath
Write-Host ""
Write-Host "====================================================" -ForegroundColor Green
Write-Host "  INSTALAÇÃO CONCLUÍDA COM SUCESSO!" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Para iniciar o sistema:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Inicie o backend:" -ForegroundColor Cyan
Write-Host "   cd backend" -ForegroundColor White
Write-Host "   npm run dev" -ForegroundColor White
Write-Host ""
Write-Host "2. Em outro terminal, inicie o frontend:" -ForegroundColor Cyan
Write-Host "   cd $projetoPath" -ForegroundColor White
Write-Host "   npm run dev" -ForegroundColor White
Write-Host ""
Write-Host "O sistema estará disponível em: http://localhost:5173" -ForegroundColor Green
Write-Host ""
Write-Host "====================================================" -ForegroundColor Green

Read-Host "Pressione Enter para sair" 