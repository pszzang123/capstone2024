// CustomerList.jsx
import React, { useState, useEffect } from 'react';
import { listCustomers } from '../services/CustomerService';

function CustomerList() {
    const [customers, setCustomers] = useState([]);

    useEffect(() => {
        listCustomers().then(response => {
            setCustomers(response.data);
        });
    }, []);

    return (
        <div>
            <h2>Customers</h2>
            <ul>
                {customers.map(customer => (
                    <li key={customer.email}>{customer.name} - {customer.email}</li>
                ))}
            </ul>
        </div>
    );
}

export default CustomerList;
