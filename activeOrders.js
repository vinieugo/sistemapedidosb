function renderOrderRow(order) {
    return `
        <tr>
            <td>${order.id}</td>
            <td>${order.customerName}</td>
            <td>${order.dateSolic || 'aguardando'}</td>
            <td>${order.status}</td>
        </tr>
    `;
}
