-- CreateTable
CREATE TABLE `Pedido` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `nomeItem` VARCHAR(191) NOT NULL,
    `quantidade` INTEGER NOT NULL,
    `solicitante` VARCHAR(191) NOT NULL,
    `fornecedor` VARCHAR(191) NOT NULL,
    `motivo` VARCHAR(191) NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'A Solicitar',
    `dataPreenchimento` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataSolicitacao` DATETIME(3) NULL,
    `dataBaixa` DATETIME(3) NULL,
    `ativo` BOOLEAN NOT NULL DEFAULT true,
    `arquivado` BOOLEAN NOT NULL DEFAULT false,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `Pedido_status_ativo_arquivado_idx`(`status`, `ativo`, `arquivado`),
    INDEX `Pedido_dataPreenchimento_idx`(`dataPreenchimento`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Configuracao` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `diasParaArquivar` INTEGER NOT NULL DEFAULT 30,
    `itensPorPagina` INTEGER NOT NULL DEFAULT 10,
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
