@echo off
REM Configurar usuário Git (ajuste estes valores)
git config --global user.name "vinieugo"
git config --global user.email "vinieugo@gmail.com"

REM Configurar o repositório Git
git init
git remote remove origin
git remote add origin https://github.com/vinieugo/sistemapedidos.git
git add .
git commit -m "Versão inicial do Sistema de Pedidos"
git branch -M main
git push -u origin main

echo "Concluído! Verifique o resultado acima para garantir que não houve erros."
pause 