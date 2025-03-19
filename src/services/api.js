import axios from 'axios';

const api = axios.create({
  baseURL: 'http://192.168.5.3:8081/api'
});

// Função auxiliar para ajustar datas considerando o fuso horário
const ajustarData = (dataString, ehFinal = false) => {
  if (!dataString) return null;
  
  const data = new Date(dataString);
  // Define para o início ou fim do dia conforme o parâmetro
  if (ehFinal) {
    data.setHours(23, 59, 59, 999);
  } else {
    data.setHours(0, 0, 0, 0);
  }
  
  return data.toISOString();
};

export const getPedidos = async (page = 1, status = null, dataInicial = null, dataFinal = null) => {
  const params = { 
    page,
    ...(Array.isArray(status) ? { status: status.join(',') } : status ? { status } : {}),
    ...(dataInicial && { dataInicial: ajustarData(dataInicial, false) }),
    ...(dataFinal && { dataFinal: ajustarData(dataFinal, true) })
  };
  const response = await api.get('/pedidos', { params });
  return response.data;
};

export const criarPedido = async (pedido) => {
  const response = await api.post('/pedidos', pedido);
  return response.data;
};

export const atualizarPedido = async (id, pedido) => {
  const response = await api.put(`/pedidos/${id}`, pedido);
  return response.data;
};

export const deletarPedido = async (id) => {
  await api.delete(`/pedidos/${id}`);
};

export const getConfiguracoes = async () => {
  const response = await api.get('/configuracoes');
  return response.data;
};

export const atualizarConfiguracoes = async (config) => {
  const response = await api.put('/configuracoes', config);
  return response.data;
};

export const arquivarPedidosAntigos = async () => {
  const response = await api.post('/arquivar-pedidos');
  return response.data;
}; 